#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=D:\_code_\icon\star_icon.ico
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Comment=bsp texture renamer
#AutoIt3Wrapper_Res_Fileversion=1.0.0.9
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****


; replace texture paths in bsp
; by hypov8
; 2024-12-13
; friday 13th


#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <String.au3>
#include <FileConstants.au3>
#include <WinAPIFiles.au3>
#include <Array.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Include <ScrollBarConstants.au3>
#Include <GUIEdit.au3>

Opt("GUIOnEventMode", 1)
Opt("GUICloseOnESC", 0)
Opt("TrayIconHide",1)
Opt("GUIDataSeparatorChar", "|")
AutoItSetOption("MustDeclareVars", 1)

#Region ### START Koda GUI section ### Form=C:\Programs\codeing\autoit-v3\SciTe\Koda\Dave\kp\-BACKUP\bsp_replace(001).kxf
Global $bsp_texture_rename = GUICreate("BSP Texture Rename.  By Hypov8", 425, 331, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "bsp_texture_renameClose")
Global $Input_file = GUICtrlCreateInput("Load file", 3, 7, 329, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
Global $Input_search = GUICtrlCreateInput("misc/", 75, 59, 257, 21)
GUICtrlSetTip(-1, "Search string. Note: must include first char")
Global $Input_replace = GUICtrlCreateInput("misc/new/", 75, 81, 183, 21)
GUICtrlSetTip(-1, "Replace String")
Global $Button_open = GUICtrlCreateButton("Open", 338, 7, 82, 30)
GUICtrlSetOnEvent(-1, "Button_openClick")
Global $Button_find = GUICtrlCreateButton("Find/Replace", 338, 72, 82, 33)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetOnEvent(-1, "Button_findClick")
Global $Label1 = GUICtrlCreateLabel("Search Prefix", 3, 59, 67, 17)
Global $Label2 = GUICtrlCreateLabel("Replace", 3, 85, 44, 17)
Global $Edit_log = GUICtrlCreateEdit("", 3, 111, 417, 215, BitOR($ES_AUTOVSCROLL,$ES_READONLY,$ES_WANTRETURN,$WS_VSCROLL))
Global $Input_file_out = GUICtrlCreateInput("Load file", 3, 29, 329, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
Global $Cbox_trunc = GUICtrlCreateCheckbox("Truncate", 267, 85, 62, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetTip(-1, "Truncate texture names to 31 char, or skip rename.")
Global $Button_list = GUICtrlCreateButton("List Textures", 338, 39, 82, 30)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetOnEvent(-1, "Button_listClick")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

#Region #global
Const $g_IDX_LUMP_OFFSET = 0 ;lump location
Const $g_IDX_LUMP_SIZE = 1 ;lump size
Const $g_LUMP_COUNT = 19
Const $g_OUT_EXT = "_NEW.bsp"

Global $g_LAST_DIR = @ScriptDir&"\"
Global $g_FILE_IDENT
Global $g_FILE_VERSION
Global $g_LUMP_INFO[$g_LUMP_COUNT][2]
Global $g_LUMP_DATA[$g_LUMP_COUNT]
Global $g_TEXTURE_COUNT = 0
Global $g_LUMP_DATA_TEX ;[$texCount][3] ;break up texture struct

Global $g_FILE_VALID = 0
#EndRegion

While 1
	Sleep(100)
WEnd


#Region # functions
Func fn_SetCurrentFolder($filePath)
	Local $iIdx = StringInStr($filePath, "\",1, -1)
	If $iIdx Then
		$g_LAST_DIR = StringLeft($filePath, $iIdx)
		ConsoleWrite("!set openFile Dialog= "&$g_LAST_DIR&@CRLF)
	EndIf
EndFunc

Func fn_AppendLogData($string)
	Local $data = GUICtrlRead($Edit_log)
	$data &= $string & @CRLF
	GUICtrlSetData($Edit_log, $data)
	;scroll to bottom
	local $iEnd = StringLen($data)
	_GUICtrlEdit_SetSel($Edit_log, $iEnd, $iEnd)
	_GUICtrlEdit_Scroll($Edit_log, $SB_SCROLLCARET)
	ConsoleWrite($string & @CRLF)
EndFunc

Func fn_ClearVarables()
	; clean memory
	Global $g_LUMP_INFO[$g_LUMP_COUNT][2]
	Global $g_LUMP_DATA[$g_LUMP_COUNT]
	$g_TEXTURE_COUNT = 0
	$g_LUMP_DATA_TEX = 0
	$g_FILE_VALID = 0
	fn_SetButtonState(0)
EndFunc

Func fn_SetButtonState($state)
	if $state = 0 Then
		GUICtrlSetState($Button_find, $GUI_DISABLE)
		GUICtrlSetState($Button_list, $GUI_DISABLE)
	Else
		GUICtrlSetState($Button_find, $GUI_ENABLE)
		GUICtrlSetState($Button_list, $GUI_ENABLE)
	EndIf
EndFunc

Func fn_ReadFile()
	;todo file check length

	;load file
	Local $fName = GUICtrlRead($Input_file)
	If FileExists($fName) Then
		Local $hFileOpen = FileOpen($fName, $FO_BINARY)
		if Not @error Then
			fn_AppendLogData("== read begin ==" )

			$g_FILE_IDENT = _WinAPI_SwapDWord(Dec(Hex(FileRead($hFileOpen, 4))))
			$g_FILE_VERSION = _WinAPI_SwapDWord(Dec(Hex(FileRead($hFileOpen, 4))))

			ConsoleWrite($g_FILE_IDENT&@CRLF)
			ConsoleWrite($g_FILE_VERSION&@CRLF)

			if Not ($g_FILE_IDENT = 1347633737) Or Not ($g_FILE_VERSION = 38) Then
				FileClose($hFileOpen)
				fn_AppendLogData("Invalid file id: " & $g_FILE_IDENT & " ver: "& $g_FILE_VERSION)
				return
			EndIf

			;==================
			;get lump positions
			For $i = 0 To $g_LUMP_COUNT-1
				$g_LUMP_INFO[$i][$g_IDX_LUMP_OFFSET] = _WinAPI_SwapDWord(Dec(Hex(FileRead($hFileOpen, 4))))
				$g_LUMP_INFO[$i][$g_IDX_LUMP_SIZE] = _WinAPI_SwapDWord(Dec(Hex(FileRead($hFileOpen, 4))))
			Next
			;_ArrayDisplay($g_LUMP_INFO)

			;texture struct sizes
			Local $sizeStart = 8*4 + 4 + 4 ; float vecs[2][4] + int flags + int value
			Local $sizeString = 32         ; char texture[32]
			Local $sizeEnd = 4             ; int nexttexinfo
			Local $sizeStruct = $sizeStart + $sizeString +	$sizeEnd
			$g_TEXTURE_COUNT = $g_LUMP_INFO[5][$g_IDX_LUMP_SIZE] / $sizeStruct

			Global $g_LUMP_DATA_TEX[$g_TEXTURE_COUNT][3] ;resize array

			fn_AppendLogData("Surface count: " & $g_TEXTURE_COUNT)

			;==================
			;read all lump data
			For $i = 0 To $g_LUMP_COUNT -1
				if not FileSetPos($hFileOpen, $g_LUMP_INFO[$i][$g_IDX_LUMP_OFFSET], $FILE_BEGIN) Then
					fn_AppendLogData("cant seek offset: " & $g_LUMP_INFO[$i][$g_IDX_LUMP_OFFSET])
					FileClose($hFileOpen)
					return
				EndIf

				;read texture lump
				if $i = 5 Then
					For $j = 0 To $g_TEXTURE_COUNT - 1
						;read texture struct

						$g_LUMP_DATA_TEX[$j][0] = hex(FileRead($hFileOpen, $sizeStart))
						$g_LUMP_DATA_TEX[$j][1] = StringStripWS(_HexToString(hex(FileRead($hFileOpen, $sizeString))), $STR_STRIPTRAILING)
						$g_LUMP_DATA_TEX[$j][2] = hex(FileRead($hFileOpen, $sizeEnd))
					Next
				Else
					;read whole lump to array
					$g_LUMP_DATA[$i] = Hex(FileRead($hFileOpen, $g_LUMP_INFO[$i][$g_IDX_LUMP_SIZE]))
				EndIf

			Next
			;ConsoleWrite(">lm lump: "& $g_LUMP_DATA[7] &@CRLF)

			FileClose($hFileOpen)
			fn_AppendLogData("== read done ==" &@CRLF)
			fn_SetButtonState(1)
			$g_FILE_VALID = 1
		Else
			fn_AppendLogData("Error: cant open file."  &@CRLF)
		EndIf

	Else
		fn_AppendLogData("Error: cant find file."  &@CRLF)
	EndIf
EndFunc

Func fn_ReplaceFolderNames()
	;get find/replace strings
	Local $sFind = GUICtrlRead($Input_search)
	Local $sReplace = GUICtrlRead($Input_replace)
	Local $sFindLen = StringLen($sFind)
	Local $iFindCount = 0
	Local $iFailedCount = 0
	Local $iUniqueCount = 0
	Local $aTruncTmp[$g_TEXTURE_COUNT]
	Local $aUniqueTmp[$g_TEXTURE_COUNT]
	Local $bTruncate = BitAND(GUICtrlRead($Cbox_trunc), $GUI_CHECKED)

	fn_AppendLogData("== searching ==")
	;fn_AppendLogData("Surface count: " & $g_TEXTURE_COUNT)

	;================
	;replace textures
	For $i = 0 To $g_TEXTURE_COUNT - 1
		Local $sCurData = $g_LUMP_DATA_TEX[$i][1]
		if StringInStr($sCurData, $sFind, 0, 1, 1, $sFindLen) Then
			Local $sTmp = $sReplace & StringMid($sCurData,  $sFindLen+1)

			;truncate if > 31 char
			If StringLen($sTmp) > 31 Then
				; only update if set
				If $bTruncate Then
					$g_LUMP_DATA_TEX[$i][1] = StringLeft($sTmp, 31) ;31+null
					$iFindCount += 1
				EndIf

				;add to print list
				if _ArraySearch($aTruncTmp, $sTmp, 0, $iFailedCount+1, 0) = -1 Then
					$aTruncTmp[$iFailedCount] = $sTmp
					$iFailedCount += 1
				EndIf
			Else
				; new length ok
				$g_LUMP_DATA_TEX[$i][1] = $sTmp
				$iFindCount += 1

				;add to print unique counter
				if _ArraySearch($aUniqueTmp, $sTmp, 0, $iUniqueCount+1, 0) = -1 Then
					$aUniqueTmp[$iUniqueCount] = $sTmp
					$iUniqueCount += 1
				EndIf
			EndIf
		EndIf
	Next


	;=============================
	;print truncated/failed rename
	If $iFailedCount > 0 Then
		Local $sTmp = ""
		For $i = 0 To $iFailedCount-1
			$sTmp &= "Name to long: " & $aTruncTmp[$i] & @CRLF
			If $bTruncate Then
				$sTmp &= "  truncated to: " & StringLeft($aTruncTmp[$i], 31) & @CRLF
			EndIf
		Next
		$sTmp = StringTrimRight($sTmp, 1) ; remove last CRLF
		fn_AppendLogData($sTmp)
	EndIf

	fn_AppendLogData("Surfaces renamed: " & $iFindCount &@CRLF& _
	                 "Textures renamed: " & $iUniqueCount)


	;===================
	; build texture lump
	Local $sNull32 = "0000000000000000000000000000000000000000000000000000000000000000"
	$g_LUMP_DATA[5] = ""
	For $j = 0 To $g_TEXTURE_COUNT - 1
		$g_LUMP_DATA[5] &= $g_LUMP_DATA_TEX[$j][0] ; texture header
		$g_LUMP_DATA[5] &= StringLeft(_StringToHex($g_LUMP_DATA_TEX[$j][1]) & $sNull32, 64) ;add trailing 00
		$g_LUMP_DATA[5] &= $g_LUMP_DATA_TEX[$j][2] ; texture footer
	Next

EndFunc

Func fn_WriteFile()
	fn_AppendLogData("== write begin ==" )
	;================
	;load target file
	Local $hFileOpen = FileOpen(GUICtrlRead($Input_file_out), BitOR($FO_OVERWRITE, $FO_BINARY))
	if @error Then
		fn_AppendLogData("Cant open file in write mode.")
	Else
		fn_AppendLogData("Output file: " & GUICtrlRead($Input_file_out))

		;write header
		FileWrite($hFileOpen, "0x"& hex(_WinAPI_SwapDWord($g_FILE_IDENT), 8))   ; ID
		FileWrite($hFileOpen, "0x"& hex(_WinAPI_SwapDWord($g_FILE_VERSION), 8)) ; version

		;write lump positions
		For $i = 0 To $g_LUMP_COUNT-1
			FileWrite($hFileOpen, "0x"& hex(_WinAPI_SwapDWord($g_LUMP_INFO[$i][$g_IDX_LUMP_OFFSET]), 8))
			FileWrite($hFileOpen, "0x"& hex(_WinAPI_SwapDWord($g_LUMP_INFO[$i][$g_IDX_LUMP_SIZE]), 8))
		Next

		;write lump data
		For $i = 0 To $g_LUMP_COUNT-1
			if $g_LUMP_INFO[$i][$g_IDX_LUMP_SIZE] > 0 Then ;ignore empty lump
				FileSetPos($hFileOpen, $g_LUMP_INFO[$i][$g_IDX_LUMP_OFFSET], $FILE_BEGIN) ;todo duplicate orig file instead?
				FileWrite($hFileOpen, "0x" & $g_LUMP_DATA[$i])
			EndIf
		Next

		;last lump. append null to align to 4 bytes
		FileSetPos($hFileOpen, 0, $FILE_END)
		Local $endOffs = FileGetPos($hFileOpen)
		Local $iLSize = BitAND($endOffs + 3, BitNOT(3)) - $endOffs
		If $iLSize > 0 Then
			Local $hStr = ""
			for $j=1 To $iLSize
				$hStr &= "00"
			Next
			ConsoleWrite("append null:"& $iLSize &@CRLF)
			FileWrite($hFileOpen,"0x" & $hStr) ; append null
		EndIf

		fn_AppendLogData("== write done ==" &@CRLF)
	EndIf

EndFunc

Func fn_ListTextures()
	Local $iFailedCount = 0
	Local $aFindTmp[$g_TEXTURE_COUNT]

	For $i = 0 To $g_TEXTURE_COUNT - 1
		Local $sCurData = $g_LUMP_DATA_TEX[$i][1]

		;add to print list
		if _ArraySearch($aFindTmp, $sCurData, 0, $iFailedCount+1, 0) = -1 Then
			$aFindTmp[$iFailedCount] = $sCurData
			$iFailedCount += 1
		EndIf
	Next


	fn_AppendLogData("== list textures start ==")
	;===================
	;print failed rename
	If $iFailedCount > 0 Then
		Local $sTmp = ""
		_ArraySort($aFindTmp, 1)
		if @error Then ConsoleWrite(">!err"&@error &@crlf)
		For $i = 0 To $iFailedCount-1
			$sTmp &= $aFindTmp[$i]& @CRLF
		Next
		$sTmp = StringTrimRight($sTmp, 1) ; remove last CRLF
		fn_AppendLogData($sTmp)
	EndIf
	fn_AppendLogData("== list textures end =="&@CRLF)
EndFunc


#EndRegion


#Region # events

; get bsp file path
Func Button_openClick()
	fn_ClearVarables()
	Local $file = FileOpenDialog("Open bsp file", $g_LAST_DIR, "bsp files (*.bsp)", 3, "MAP.BSP", $bsp_texture_rename)
	If @error Then
		GUICtrlSetData($Input_file, "")
		GUICtrlSetData($Input_file_out, "")
		fn_AppendLogData("Error loading file: " & $file)
	Else
		if StringCompare(StringRight($file, 4), ".bsp") = 0 Then
			GUICtrlSetData($Input_file, $file)
			GUICtrlSetData($Input_file_out, StringTrimRight($file, 4) & $g_OUT_EXT)
			fn_AppendLogData("File: " & $file)
			fn_SetCurrentFolder($file)
			If FileExists(GUICtrlRead($Input_file_out)) Then fn_AppendLogData("WARNING: output file exists.")
			fn_ReadFile()
		Else
			GUICtrlSetData($Input_file, "")
			GUICtrlSetData($Input_file_out, "")
			fn_AppendLogData("Error: file not bsp.")
		EndIf
	EndIf
EndFunc

;replace texture paths
Func Button_findClick()
	If $g_FILE_VALID Then
		fn_ReplaceFolderNames()
		fn_WriteFile()
	EndIf
EndFunc

Func bsp_texture_renameClose()
	Exit
EndFunc

Func bsp_texture_renameMaximize()

EndFunc
Func bsp_texture_renameMinimize()

EndFunc
Func bsp_texture_renameRestore()

EndFunc
Func Button_listClick()
	fn_ListTextures()
EndFunc
#EndRegion

