#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=D:\_code_\hypoBrowser\main\hypo_browser.ico
#AutoIt3Wrapper_Outfile=HypoGameBrowser_1.0.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Comment=Kingpin Game Browser by hypo_v8
#AutoIt3Wrapper_Res_Description=Game browser for Kingpin, KingpinQ3 and Quake2
#AutoIt3Wrapper_Res_Fileversion=1.0.3.0
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gspyicons\1.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gspyicons\2.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gspyicons\3.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gspyicons\4.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gspyicons\5.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gspyicons\6.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gspyicons\7.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gspyicons\8.ico
#AutoIt3Wrapper_Res_File_Add=D:\_code_\hypoBrowser\icons\logo_1.bmp,rt_bitmap,logo_1
#AutoIt3Wrapper_Res_File_Add=D:\_code_\hypoBrowser\icons\logo_3.bmp,rt_bitmap,logo_2
#AutoIt3Wrapper_Res_File_Add=D:\_code_\hypoBrowser\icons\buttons_1.bmp,rt_bitmap,button_1
#AutoIt3Wrapper_Res_File_Add=D:\_code_\hypoBrowser\icons\buttons_2.bmp,rt_bitmap,button_2
#AutoIt3Wrapper_Res_File_Add=D:\_code_\hypoBrowser\icons\buttons_3.bmp,rt_bitmap,button_3
#AutoIt3Wrapper_Res_File_Add=D:\_code_\hypoBrowser\icons\buttons_4.bmp,rt_bitmap,button_4
#AutoIt3Wrapper_Res_File_Add=D:\_code_\hypoBrowser\icons\buttons_5.bmp,rt_bitmap,button_5
#AutoIt3Wrapper_AU3Check_Parameters=-d
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;#AutoIt3Wrapper_Res_File_Add=D:\_code_\hypoBrowser\icons\po.mp3,rt_rcdata, AUDIO_0
;#AutoIt3Wrapper_Res_File_Add=D:\_code_\hypoBrowser\icons\1p.mp3,rt_rcdata, AUDIO_1

;======= hypo do not delet above ====================

Global Const $versionName = "HypoGameBrowser"
Global Const $versionNum = "1.0.3" ;1.0.0
;1.0.1 fixed issue with kp refresh. when a servre times out the updated responce may stil get skiped
;1.0.2 fixed 'mod' display issue. using 'gametype' from responce now
;      added proper gamespy protocol encrypter. fixes non qtracker master issues. eg.. master.333networks.com
;1.0.3 added fix to prevent font scale changing
;      updated offline list.
;
;1.0.4.... 	todo update offline list.
;			todo support additional games. (lots of work required)
;			todo option to combine all masters lists into 1 big list. (lots of work required)

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiImageList.au3>
#include <GuiStatusBar.au3>
#include <ImageListConstants.au3>
#include <ListViewConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
#include <Array.au3>
#include <GuiListView.au3>
#include <String.au3>
#include <GuiButton.au3>
#include <GuiTab.au3>
#include <TrayConstants.au3>
#include <WinAPIReg.au3>
#include <WinAPIDlg.au3>
#include <WinAPIMisc.au3>
#include <GuiMenu.au3>
#include <WinAPI.au3>
#include <WinAPIFiles.au3>
#include <InetConstants.au3>
#include <File.au3>
#include <Misc.au3>
#include <ColorConstants.au3>
#include <WinAPITheme.au3>
#include <GuiListBox.au3>
#include <IE.au3>
#include <GDIPlus.au3>


#Region global Varables
Global $HypoGameBrowser, $tabGroupGames, $TabSheet1, $ListView1KP, $ListView2, $ListView3, $TabSheet2, $ListView1KPQ3, $ListView2KPQ3
Global $ListView3KPQ3, $TabSheet3, $ListView1Q2, $ListView2Q2, $ListView3Q2, $TabSheet4, $SettingsBgBlack
Global $InputMaster1, 		$InputMaster2, 		$InputMaster3, 		$InputMaster4, 		$RadioMaster1, 		$RadioMaster2, 		$RadioMaster3, 		$RadioMaster4, 		$GroupKingpin
Global $InputMaster1KPQ3, 	$InputMaster2KPQ3, 	$InputMaster3KPQ3, 	$InputMaster4KPQ3, 	$RadioMaster1KPQ3, 	$RadioMaster2KPQ3, 	$RadioMaster3KPQ3, 	$RadioMaster4KPQ3,	$GroupKingpinQ3
Global $InputMaster1Q2,		$InputMaster2Q2, 	$InputMaster3Q2, 	$InputMaster4Q2, 	$RadioMaster1Q2, 	$RadioMaster2Q2, 	$RadioMaster3Q2, 	$RadioMaster4Q2, 	$GroupQuake2
Global $RadioMasterTCP_KPQ3, $RadioMasterUDP_KPQ3, $RadioMasterTCP_Q2, $RadioMasterUDP_Q2, $InputKPQ3_proto, $LabelMasterKPQ3_proto
Global $Game_Config, $path_Kingpin, $path_KPQ3, $path_Quake2, $Button_kp, $Button_kpq3, $Button_q2, $runCommands, $RunKingpinCMD, $RunKingpinQ3CMD, $RunQuake2CMD, $PlayerNames
Global $InputNameKP, $InputNameKPQ3, $InputNameQ2, $Group_M_Settings, $hosted_server, $getPort, $remove_Server, $add_Server, $ExcludeSrever
Global $addKPQ3, $addQuake2, $MLinkGroup, $MLink, $StartupMBrowser, $StartupMChkBox, $refreshAutoGrp, $refreshTimeImput, $refreshChkBox
Global $textRefresh, $soundChkBox, $About, $Label1, $Label2, $Label3, $Label4, $Label5, $Label6, $Label7, $Web_links, $Link_KP_info
Global $Link_Ham_web, $Link_ham_chat, $Link_Ham_feedback, $Link_kpq3, $TabSheet5, $ChatGroup1, $SettingsBgBlack2, $ConnectChatBtn
Global $TabSheet6, $ListView1M, $ListView2M, $ListView3M, $Group3, $playersOnline, $playersOnlineKPQ3, $playersOnlineQ2, $GetServersBtn
Global $RefServerBtn, $FavServerBtn, $OffLineServeBtn, $Icon1, $Icon2, $Icon3, $SettingsBtn, $LowerStatus, $trayExit, $trayMax, $tray_mini, $webObj_ctrl
Global $MOTD_Input, $ProgressBar_Group, $ProgressBar
Global $GBG_gamebrowser, $GBG_Refresh, $GB_RB_Kingpin, $GB_RB_KingpinQ3, $GB_RB_Quake2, $GBG_Sounds, $GB_Players_sound, $Master_server_address
Global $GB_IN_refreshTime, $GB_TXT_refreshTime, $link_hypo_email, $RadioMasterHTTP_Q2
Global $Group_opt_window, $opt_minToTray, $hotKey_Input, $hotKey_btn, $hotKey_alt, $hotKey_ctrl


Global $webObj = _IECreateEmbedded()
Global $aDPI = _GDIPlus_GraphicsGetDPIRatio() ;windows font scale

;get icons from internal resources. 0=global 1-3=autoit
Global $ImageList1 = _GUIImageList_Create(16, 16, 5)
_GUIImageList_AddIcon($ImageList1, @ScriptFullPath, 4, True)
_GUIImageList_AddIcon($ImageList1, @ScriptFullPath, 5, True)
_GUIImageList_AddIcon($ImageList1, @ScriptFullPath, 6, True)
_GUIImageList_AddIcon($ImageList1, @ScriptFullPath, 7, True)
_GUIImageList_AddIcon($ImageList1, @ScriptFullPath, 8, True)
_GUIImageList_AddIcon($ImageList1, @ScriptFullPath, 9, True)
_GUIImageList_AddIcon($ImageList1, @ScriptFullPath, 10, True)
_GUIImageList_AddIcon($ImageList1, @ScriptFullPath, 11, True)
#EndRegion

;DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0)
;DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($HypoGameBrowser), "wstr", 0, "wstr", 0)
_WinAPI_SetThemeAppProperties(1) ;1= allow aero outter

#Region ### START Koda GUI section ### Form=C:\Programs\codeing\autoit-v3\SciTe\Koda\Dave\hypogamebrowser.kxf
;~ $HypoGameBrowser = GUICreate("HypoGameBrowser", 808, 614, -1, -1, BitOR($GUI_SS_DEFAULT_GUI,$WS_MAXIMIZEBOX,$WS_SIZEBOX,$WS_THICKFRAME,$WS_TABSTOP))
$HypoGameBrowser = GUICreate("HypoGameBrowser", 810, 615, -1, -1, BitOR($GUI_SS_DEFAULT_GUI,$WS_MAXIMIZEBOX,$WS_SIZEBOX,$WS_THICKFRAME,$WS_TABSTOP))
GUISetIcon(@AutoItExe, -1)
GUISetFont(8* $aDPI[0], 0, 0,  "MS Sans Serif", $HypoGameBrowser)
$tabGroupGames = GUICtrlCreateTab(61, 4, 746, 589, BitOR($TCS_FLATBUTTONS,$TCS_FORCELABELLEFT,$TCS_BUTTONS))
GUICtrlSetFont(-1, 10*$aDPI[0], 800, 0, "MS Sans Serif")
ConsoleWrite("!GIU DPI= "&$aDPI[0] & @CRLF)


GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM)


;==> TAB 1  -=Kingpin=-
$TabSheet1 = GUICtrlCreateTabItem("Kingpin")
$ListView1KP = GUICtrlCreateListView("Num|IP|Server Name|Ping|Players|Map|Mod", 65, 36, 738, 317, -1, BitOR($WS_EX_CLIENTEDGE,$LVS_EX_SUBITEMIMAGES,$LVS_EX_FULLROWSELECT))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 1)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 4)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 240)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 65)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 4, 70)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 5, 160)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 6, 170)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM)
$ListView2 = GUICtrlCreateListView("Name|Frags|Ping", 65, 354, 445, 231, BitOR($GUI_SS_DEFAULT_LISTVIEW,$LVS_AUTOARRANGE,$LVS_ALIGNLEFT,$WS_HSCROLL,$WS_VSCROLL), BitOR($WS_EX_CLIENTEDGE,$LVS_EX_SUBITEMIMAGES,$LVS_EX_FULLROWSELECT))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 200)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 50)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 50)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT)
$ListView3 = GUICtrlCreateListView("Rules|Value", 513, 354, 289, 231, BitOR($GUI_SS_DEFAULT_LISTVIEW,$LVS_AUTOARRANGE,$LVS_ALIGNLEFT,$WS_HSCROLL,$WS_VSCROLL), BitOR($WS_EX_CLIENTEDGE,$LVS_EX_SUBITEMIMAGES,$LVS_EX_FULLROWSELECT))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 130)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 120)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
;==> TAB 2  -=KingpinQ3=-
$TabSheet2 = GUICtrlCreateTabItem("KingpinQ3")
$ListView1KPQ3 = GUICtrlCreateListView("Num|IP|Server Name|Ping|Players|Map|Mod", 65, 36, 738, 317, -1, BitOR($WS_EX_CLIENTEDGE,$LVS_EX_SUBITEMIMAGES,$LVS_EX_FULLROWSELECT))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 1)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 4)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 240)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 65)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 4, 70)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 5, 160)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 6, 170)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM)
$ListView2KPQ3 = GUICtrlCreateListView("Name|Frags|Ping", 65, 354, 445, 231, BitOR($GUI_SS_DEFAULT_LISTVIEW,$LVS_AUTOARRANGE,$LVS_ALIGNLEFT,$WS_HSCROLL,$WS_VSCROLL))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 200)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 50)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 50)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT)
$ListView3KPQ3 = GUICtrlCreateListView("Rules|Value", 513, 354, 289, 231, BitOR($GUI_SS_DEFAULT_LISTVIEW,$LVS_AUTOARRANGE,$LVS_ALIGNLEFT,$WS_HSCROLL,$WS_VSCROLL))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 130)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 120)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
;==> TAB 3  -=Quake2=-
$TabSheet3 = GUICtrlCreateTabItem("Quake2")
$ListView1Q2 = GUICtrlCreateListView("Num|IP|Server Name|Ping|Players|Map|Mod", 65, 36, 738, 317, -1, BitOR($WS_EX_CLIENTEDGE,$LVS_EX_SUBITEMIMAGES,$LVS_EX_FULLROWSELECT))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 1)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 4)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 240)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 65)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 4, 70)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 5, 160)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 6, 170)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM)
$ListView2Q2 = GUICtrlCreateListView("Name|Frags|Ping", 65, 354, 445, 231, BitOR($GUI_SS_DEFAULT_LISTVIEW,$LVS_AUTOARRANGE,$LVS_ALIGNLEFT,$WS_HSCROLL,$WS_VSCROLL))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 200)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 50)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 50)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT)
$ListView3Q2 = GUICtrlCreateListView("Rules|Value", 513, 354, 289, 231, BitOR($GUI_SS_DEFAULT_LISTVIEW,$LVS_AUTOARRANGE,$LVS_ALIGNLEFT,$WS_HSCROLL,$WS_VSCROLL))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 130)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 120)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)


;==> TAB 4  -=SETUP=-
$TabSheet4 = GUICtrlCreateTabItem("Setup ")
$SettingsBgBlack = GUICtrlCreateLabel("", 65, 34, 737, 554, BitOR($SS_CENTER,$SS_SUNKEN))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM)
GUICtrlSetState(-1, $GUI_DISABLE)
$Master_server_address = GUICtrlCreateGroup("Master Server Settings", 73, 38, 242, 436, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$GroupKingpin = GUICtrlCreateGroup("Kingpin Masters", 81, 52, 226, 121, BitOR($GUI_SS_DEFAULT_GROUP,$BS_LEFT))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$InputMaster1 = GUICtrlCreateInput("master.kingpin.info:28900", 105, 72, 193, 21, $ES_READONLY);
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetState(-1, $GUI_DISABLE)
$InputMaster2 = GUICtrlCreateInput("master.hambloch.com:28900", 105, 96, 193, 21, $ES_READONLY);master1.kingpin.info:28900
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetState(-1, $GUI_DISABLE)
$InputMaster3 = GUICtrlCreateInput("master.333networks.com:28900", 105, 120, 193, 21, $ES_READONLY);""
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetState(-1, $GUI_DISABLE)
$InputMaster4 = GUICtrlCreateInput("gsm.qtracker.com:28900", 105, 144, 193, 21);
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$RadioMaster1 = GUICtrlCreateRadio("", 89, 72, 13, 21)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$RadioMaster2 = GUICtrlCreateRadio("", 89, 96, 13, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$RadioMaster3 = GUICtrlCreateRadio("", 89, 120, 13, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$RadioMaster4 = GUICtrlCreateRadio("", 89, 144, 13, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$GroupKingpinQ3 = GUICtrlCreateGroup("KingpinQ3 Masters", 81, 176, 226, 145, BitOR($GUI_SS_DEFAULT_GROUP,$BS_LEFT))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$InputMaster1KPQ3 = GUICtrlCreateInput("masterkpq3.kingpin.info:27950", 105, 196, 193, 21, $ES_READONLY)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetState(-1, $GUI_DISABLE)
$InputMaster2KPQ3 = GUICtrlCreateInput("master.hambloch.com:28900", 105, 220, 193, 21, $ES_READONLY)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetState(-1, $GUI_DISABLE)
$InputMaster3KPQ3 = GUICtrlCreateInput("master.ioquake3.org:27950", 105, 244, 193, 21, $ES_READONLY)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetState(-1, $GUI_DISABLE)
$InputMaster4KPQ3 = GUICtrlCreateInput("gsm.qtracker.com:28900", 105, 268, 193, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$RadioMaster1KPQ3 = GUICtrlCreateRadio("", 89, 196, 13, 21)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$RadioMaster2KPQ3 = GUICtrlCreateRadio("", 89, 220, 13, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$RadioMaster3KPQ3 = GUICtrlCreateRadio("", 89, 244, 13, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$RadioMaster4KPQ3 = GUICtrlCreateRadio("", 89, 268, 13, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$RadioMasterTCP_KPQ3 = GUICtrlCreateCheckbox("TCP", 104, 292, 45, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip(-1, "Gamespy protocol"&@CRLF&"Qtracker etc..")
$RadioMasterUDP_KPQ3 = GUICtrlCreateCheckbox("UDP", 156, 292, 45, 21)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip(-1, "UDP for Quake protocol Requests"&@CRLF&"Same as the ingame browser")
$InputKPQ3_proto = GUICtrlCreateInput("74", 205, 292, 30, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
;GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip(-1, "Game Protocol for IOQ3 masters"&@CRLF&"74=Beta, 75=Release")
$LabelMasterKPQ3_proto = GUICtrlCreateLabel("Protocol", 240, 295, 43, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Game Protocol for IOQ3 masters"&@CRLF&"74=Beta, 75=Release")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$GroupQuake2 = GUICtrlCreateGroup("Quake2 Masters", 81, 324, 226, 141, BitOR($GUI_SS_DEFAULT_GROUP,$BS_LEFT))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$InputMaster1Q2 = GUICtrlCreateInput("q2servers.com:80", 105, 344, 193, 21, $ES_READONLY)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetState(-1, $GUI_DISABLE)
$InputMaster2Q2 = GUICtrlCreateInput("master.netdome.biz:27900", 105, 368, 193, 21, $ES_READONLY)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetState(-1, $GUI_DISABLE)
$InputMaster3Q2 = GUICtrlCreateInput("master.quakeservers.net:27900", 105, 392, 193, 21, $ES_READONLY)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetState(-1, $GUI_DISABLE)
$InputMaster4Q2 = GUICtrlCreateInput("gsm.qtracker.com:28900", 105, 416, 193, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$RadioMaster1Q2 = GUICtrlCreateRadio("", 89, 344, 13, 21)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$RadioMaster2Q2 = GUICtrlCreateRadio("", 89, 368, 13, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$RadioMaster3Q2 = GUICtrlCreateRadio("", 89, 392, 13, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$RadioMaster4Q2 = GUICtrlCreateRadio("RadioMaster4Q2", 89, 416, 13, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$RadioMasterTCP_Q2 = GUICtrlCreateCheckbox("TCP", 104, 440, 45, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip(-1, "Gamespy protocol"&@CRLF&"Qtracker etc..")
$RadioMasterUDP_Q2 = GUICtrlCreateCheckbox("UDP", 152, 440, 49, 17)

GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip(-1, "UDP for Quake protocol Requests"&@CRLF&"Same as the ingame browser")
$RadioMasterHTTP_Q2 = GUICtrlCreateCheckbox("WEB", 200, 440, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip(-1, "Get master list webite at q2servers.com" &@CRLF& "Disables all the above masters")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group_M_Settings = GUICtrlCreateGroup("M Browser Settings", 373, 38, 420, 213, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$hosted_server = GUICtrlCreateGroup("Hosted Server", 381, 53, 113, 189, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$add_Server = GUICtrlCreateButton("Add Server", 389, 76, 93, 29)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Add a server to 'M' Website listing so game can be seen in M-Browser")
$remove_Server = GUICtrlCreateButton("Remove Server", 389, 112, 93, 29)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Remove a server to 'M' Website listing so game can not be seen in M-Browser")
$ExcludeSrever = GUICtrlCreateButton("Exclude Server", 389, 148, 93, 29)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Exclude a server from 'M' Website listing so game can not be seen in M-Browser. Even if listed at Qtracker")
$getPort = GUICtrlCreateInput("31510", 389, 188, 93, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Set Server port" & @CRLF & "Default Game Kingpin")
$addKPQ3 = GUICtrlCreateCheckbox("KPQ3", 389, 213, 49, 25)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Add KingpinQ3 Ports")
$addQuake2 = GUICtrlCreateCheckbox("Q2", 445, 213, 37, 25)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Add Quake2 Ports")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$MLinkGroup = GUICtrlCreateGroup("Use 'M' Web Links", 501, 53, 109, 49, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$MLink = GUICtrlCreateCheckbox("Enable", 509, 73, 65, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Enable web links to connect to 'servers' listed on M's Website."& @CRLF&"Make sure to set Kingpin Game Path first. Then enable option.")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$StartupMBrowser = GUICtrlCreateGroup("Startup 'M' Browser", 501, 105, 109, 45, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$StartupMChkBox = GUICtrlCreateCheckbox("Enable", 509, 125, 61, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Startup using  M-Browser. Getting servers straightaway")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$refreshAutoGrp = GUICtrlCreateGroup("Misc", 501, 153, 109, 89, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$refreshTimeImput = GUICtrlCreateInput("3", 509, 213, 29, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Time in Minutes between auto refresh")
$refreshChkBox = GUICtrlCreateCheckbox("Auto Refresh", 509, 189, 85, 25)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Auto refresh all games." & @CRLF & "Will not refresh when minimized.")
$textRefresh = GUICtrlCreateLabel("Refresh Time", 541, 217, 67, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Time in Minutes between auto refresh")
$soundChkBox = GUICtrlCreateCheckbox("Play Sound", 509, 169, 93, 21)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Play a sound if there is a player in a server")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$About = GUICtrlCreateGroup("About", 617, 53, 169, 189, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$Label1 = GUICtrlCreateLabel("M-Browser GUI Version", 625, 73, 114, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$Label2 = GUICtrlCreateLabel("By David Smyth (hypo_v8)", 625, 89, 129, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$Label3 = GUICtrlCreateLabel("The original M-Browser is a ", 625, 113, 134, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$Label4 = GUICtrlCreateLabel("command line interface that ", 625, 129, 137, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$Label5 = GUICtrlCreateLabel("Michael Hambloch (M) released.", 625, 145, 156, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$Label6 = GUICtrlCreateLabel("Using M's Website to", 625, 170, 104, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$Label7 = GUICtrlCreateLabel("Source Kingpin Servers", 625, 186, 115, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$GBG_gamebrowser = GUICtrlCreateGroup("GameSpy Browser Settings", 373, 258, 272, 117, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$GBG_Refresh = GUICtrlCreateGroup("Auto Refresh", 381, 274, 145, 91, BitOR($GUI_SS_DEFAULT_GROUP,$BS_LEFT))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$GB_RB_Kingpin = GUICtrlCreateCheckbox("Kingpin", 389, 290, 65, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Game to be auto refreshed" & @CRLF & "Will not refresh when minimized")
$GB_RB_KingpinQ3 = GUICtrlCreateCheckbox("KingpinQ3", 389, 314, 77, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Game to be auto refreshed" & @CRLF & "Will not refresh when minimized")
$GB_RB_Quake2 = GUICtrlCreateCheckbox("Quake2", 389, 338, 65, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Game to be auto refreshed" & @CRLF & "Will not refresh when minimized")
$GB_IN_refreshTime = GUICtrlCreateInput("3", 457, 290, 29, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Time in Minutes between auto refresh")
$GB_TXT_refreshTime = GUICtrlCreateLabel("Time", 489, 294, 27, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Time in Minutes between auto refresh")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$GBG_Sounds = GUICtrlCreateGroup("Sounds", 533, 274, 104, 91, BitOR($GUI_SS_DEFAULT_GROUP,$BS_LEFT))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$GB_Players_sound = GUICtrlCreateCheckbox("Players Online", 541, 290, 89, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Play a sound if there is a player in a server")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlSetState(-1, $GUI_HIDE)
$Web_links = GUICtrlCreateGroup("Web Links", 673, 258, 120, 117, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$Link_KP_info = GUICtrlCreateLabel("Kingpin.info", 685, 274, 59, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetCursor (-1, 0)
$Link_Ham_web = GUICtrlCreateLabel("M's Server List", 685, 290, 73, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetCursor (-1, 0)
$Link_ham_chat = GUICtrlCreateLabel("Chat", 685, 306, 26, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetCursor (-1, 0)
$Link_Ham_feedback = GUICtrlCreateLabel("Contact M", 685, 322, 53, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetCursor (-1, 0)
$Link_kpq3 = GUICtrlCreateLabel("KingpinQ3", 685, 338, 53, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetCursor (-1, 0)
$link_hypo_email = GUICtrlCreateLabel("Email Me", 685, 354, 47, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Email me")
GUICtrlSetCursor (-1, 0)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Game_Config = GUICtrlCreateGroup("Game Path", 73, 478, 312, 101, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$path_Kingpin = GUICtrlCreateInput("Kingpin.exe", 169, 494, 209, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$path_KPQ3 = GUICtrlCreateInput("KingpinQ3-32.exe", 169, 522, 209, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$path_Quake2 = GUICtrlCreateInput("Quake2.exe", 169, 550, 209, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$Button_kp = GUICtrlCreateButton("Kingpin", 81, 494, 81, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$Button_kpq3 = GUICtrlCreateButton("KingpinQ3", 81, 522, 81, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$Button_q2 = GUICtrlCreateButton("Quake2", 81, 550, 81, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlSetState(-1, $GUI_HIDE)
$PlayerNames = GUICtrlCreateGroup("Player Names", 389, 478, 128, 101, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$InputNameKP = GUICtrlCreateInput("", 397, 494, 113, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$InputNameKPQ3 = GUICtrlCreateInput("", 397, 522, 113, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$InputNameQ2 = GUICtrlCreateInput("", 397, 550, 113, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$runCommands = GUICtrlCreateGroup("Additional Run Commands", 521, 478, 272, 101, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$RunKingpinCMD = GUICtrlCreateInput("+set developer 1", 529, 494, 256, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$RunKingpinQ3CMD = GUICtrlCreateInput("", 529, 522, 256, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$RunQuake2CMD = GUICtrlCreateInput("+set developer 1", 529, 550, 256, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlCreateGroup("", -99, -99, 1, 1)


$Group_opt_window = GUICtrlCreateGroup("Browser Options", 673, 382, 121, 93, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$opt_minToTray = GUICtrlCreateCheckbox("Minimize to tray", 684, 400, 93, 21)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "This is used in tray menu(Minimize) and on game lunch")
$hotKey_Input = GUICtrlCreateInput("", 737, 426, 49, 21)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "HotKey. Accepts a-z")
$hotKey_alt = GUICtrlCreateRadio("Alt +", 681, 430, 41, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$hotKey_ctrl = GUICtrlCreateRadio("Ctrl +", 681, 450, 49, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$hotKey_btn = GUICtrlCreateButton("Apply", 737, 450, 49, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Apply a global HotKey bind."&@CRLF&"This will bring hypobrowser window to the front(active)")
GUICtrlCreateGroup("", -99, -99, 1, 1)


;==>CHAT TAB 5
$TabSheet5 = GUICtrlCreateTabItem("Chat")
$ChatGroup1 = GUICtrlCreateGroup("", 65, 40, 735, 549)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM)
$SettingsBgBlack2 = GUICtrlCreateLabel("", 65, 44, 735, 549)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM)
GUICtrlSetState(-1, $GUI_DISABLE)
$webObj_ctrl = GUICtrlCreateObj($webObj, 69, 48, 728, 504)
GUICtrlSetResizing($webObj_ctrl,$GUI_DOCKBORDERS ) ;==>add hypo

$ConnectChatBtn = GUICtrlCreateButton("Connect", 69, 556, 81, 25)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlCreateGroup("", -99, -99, 1, 1)


;==>M-BROWSER TAB
$TabSheet6 = GUICtrlCreateTabItem("M-Browser")
$ListView1M = GUICtrlCreateListView("Num|IP|Server Name|Ping|Players|Map", 65, 36, 736, 257, -1, BitOR($WS_EX_CLIENTEDGE,$LVS_EX_SUBITEMIMAGES,$LVS_EX_FULLROWSELECT))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 1)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 4)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 240)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 65)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 4, 70)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 5, 160)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM)
$ListView2M = GUICtrlCreateListView("Num|IP|Server Name|Ping|Players|Map", 65, 296, 735, 149, -1, BitOR($WS_EX_CLIENTEDGE,$LVS_EX_SUBITEMIMAGES,$LVS_EX_FULLROWSELECT))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 1)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 4)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 240)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 65)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 4, 70)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 5, 160)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT)
$ListView3M = GUICtrlCreateListView("Num|IP|Server Name|Ping|Players|Map", 65, 448, 735, 101, -1, BitOR($WS_EX_CLIENTEDGE,$LVS_EX_SUBITEMIMAGES,$LVS_EX_FULLROWSELECT))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 1)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 4)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 240)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 65)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 4, 70)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 5, 160)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT)
$Group3 = GUICtrlCreateGroup("", 69, 548, 357, 41)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$playersOnline = GUICtrlCreateInput("kingpin", 77, 562, 118, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_RIGHT,$ES_READONLY,$WS_BORDER), $WS_EX_STATICEDGE)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Players")
$playersOnlineKPQ3 = GUICtrlCreateInput("KingpinQ3", 199, 562, 118, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_RIGHT,$ES_READONLY,$WS_BORDER), $WS_EX_STATICEDGE)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Players")
$playersOnlineQ2 = GUICtrlCreateInput("Quake2", 321, 562, 94, 21, BitOR($ES_RIGHT,$ES_READONLY,$WS_BORDER), $WS_EX_STATICEDGE)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Players")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
;==> end tabs

;==> buttons
$GetServersBtn = GUICtrlCreateButton("Refresh", 3, 56+8, 56, 41, $BS_BITMAP)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Get servers from the master and refresh them" & @CRLF &" Shortcut F5")
$RefServerBtn = GUICtrlCreateButton("Ping List", 3, 104+4, 56, 41, $BS_BITMAP)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Refresh game servers in current list, without talking to the master.")
$FavServerBtn = GUICtrlCreateButton("Favorite", 3, 152, 56, 41, $BS_BITMAP)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "View favorite server list."&@CRLF&" PingList will run once they are loaded")
$OffLineServeBtn = GUICtrlCreateButton("OffLine", 3, 212, 56, 41, $BS_BITMAP)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Load offline server list for the selected game."&@CRLF&" You will need to refresh list with PingList..")
$SettingsBtn = GUICtrlCreateButton("Setup", 3, 310, 56, 41, $BS_BITMAP)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Settings")

;$Icon1 = GUICtrlCreateIcon(@AutoItExe, -1, 3, 4, 56, 56)
;$Icon1 = GUICtrlCreatePic("", 3, 4, 56, 56)
;$Icon1 = GUICtrlCreateButton("", 3, 4, 56, 56)
$Icon1 = GUICtrlCreateLabel("", 3, 4, 56, 56, $SS_SUNKEN, 0)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Setup all games and M-Browser")

;~ $Icon2 = GUICtrlCreateLabel("", 20, 371, 22, 216, -1, 0);$WS_EX_CLIENTEDGE
;~ GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
;~ GUICtrlSetTip(-1, "Setup all games and M-Browser")



;_WinAPI_SetThemeAppProperties(6)

;==>statusbar
;$MOTD_Input = GUICtrlCreateInput(" Use Refresh to receive list from master. Use Ping to updates current servers in view. Offline loads internal servers", 61, 591, 746, 19)
;GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT)
;GUICtrlSetState(-1, $GUI_DISABLE)
;==> MOTD
$MOTD_Input = GUICtrlCreateInput(" Use Refresh to receive list from master. Use Ping to updates current servers in view. Offline loads internal servers", 118, 591, 689, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT)
;==> progress bar
$ProgressBar_Group = GUICtrlCreateGroup("", 61, 585, 57, 27)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$ProgressBar = GUICtrlCreateProgress(64, 593, 51, 17, 1);$PBS_SMOOTH =1
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)

TraySetIcon(@AutoItExe, -1)
TraySetClick("16")
$trayExit = TrayCreateItem("Exit")
TrayCreateItem("")
$trayMax = TrayCreateItem("Restore/Maximize")
$tray_mini = TrayCreateItem("Minimize")


Dim $HypoGameBrowser_AccelTable[1][2] = [["{F5}", $GetServersBtn]]
GUISetAccelerators($HypoGameBrowser_AccelTable)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


#Region --> COLORS
;==> color for visual theme
Global $COLOR_1BLACK = 0x373737 	;grey
Global $COLOR_2BLACK =0x272727		;dark grey
Global $COLOR_1ORANGE = 0xff8c00 	;orange


GUISetColor()
Func GUISetColor()
	Local $iloop
	;gui parts to color
	Local $hwNames1= [$SettingsBgBlack, $SettingsBgBlack2, $ListView1KP, $ListView1KPQ3, $ListView1M, $ListView1Q2, $ListView2, _
		$ListView2KPQ3,$ListView2M ,$ListView2Q2 ,$ListView3 ,$ListView3KPQ3 ,$ListView3M ,$ListView3Q2, _
		$GroupKingpin, $GroupKingpinQ3, $GroupQuake2 ,$Game_Config ,$runCommands ,$PlayerNames ,$Web_links, $Label2, $Label3, $Label4, $Label5, $Label6, $Label7, _
		$Group_M_Settings, $hosted_server, $MLinkGroup, $StartupMBrowser, $refreshAutoGrp, $About, $addKPQ3, $addQuake2, $MLink, $StartupMChkBox, $refreshChkBox, $textRefresh, $soundChkBox,$Label1, _ ;M config
		$Link_KP_info, $Link_Ham_web, $Link_ham_chat, $Link_Ham_feedback, $Link_kpq3, $link_hypo_email, _ ;web links
		$GBG_gamebrowser, $GBG_Refresh, $GB_RB_Kingpin, $GB_RB_KingpinQ3, $GB_RB_Quake2, $GBG_Sounds, $GB_Players_sound, $GB_TXT_refreshTime, $Master_server_address, $LabelMasterKPQ3_proto, _
		$RadioMasterTCP_KPQ3, $RadioMasterUDP_KPQ3, $RadioMasterTCP_Q2, $RadioMasterUDP_Q2, $RadioMasterHTTP_Q2, _
		$Group_opt_window, $opt_minToTray, $hotKey_alt, $hotKey_ctrl]


	GUICtrlSetDefColor($COLOR_1ORANGE,$HypoGameBrowser)
	GUISetBkColor($COLOR_1BLACK, $HypoGameBrowser)

	;set all gui item colors
	For $iloop = 0 to UBound($hwNames1)-1
		GUICtrlSetColor	 ($hwNames1[$iloop], $COLOR_1ORANGE)
		GUICtrlSetBkColor($hwNames1[$iloop], $COLOR_1BLACK)
	Next

	;add image to left buttons
	_ResourceSetImageToCtrl($GetServersBtn, 	"button_1")
	_ResourceSetImageToCtrl($RefServerBtn, 		"button_2")
	_ResourceSetImageToCtrl($FavServerBtn, 		"button_3")
	_ResourceSetImageToCtrl($OffLineServeBtn, 	"button_4")
	_ResourceSetImageToCtrl($SettingsBtn, 		"button_5")

	_ResourceSetImageToCtrl($Icon1, 			"logo_1")
	_ResourceSetImageToCtrl($Icon2, 			"logo_2")

	;remove theme off progressbar
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($ProgressBar), "wstr", 0, "wstr", 0)

	;$ProgressBar
	GUICtrlSetColor($ProgressBar, $COLOR_1ORANGE)


	;==> buttons. M settings
	GUICtrlSetStyle($add_Server, 0) ;hypo reset style
	GUICtrlSetStyle($remove_Server, 0) ;hypo reset style
	GUICtrlSetStyle($ExcludeSrever, 0) ;hypo reset style
	;==> buttons. game path
	GUICtrlSetStyle($Button_kp, 0) ;hypo reset style
	GUICtrlSetStyle($Button_kpq3, 0) ;hypo reset style
	GUICtrlSetStyle($Button_q2, 0) ;hypo reset style
	GUICtrlSetStyle($hotKey_btn, 0) ;hypo reset style

EndFunc
#EndRegion


#Region --> GLOBAL
;========================================================
; -->Global settings

Opt("GUIResizeMode", $GUI_DOCKAUTO+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)

Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1) ; Enable TrayOnEventMode.

Opt("TCPTimeout", 1000)
Opt("GUIOnEventMode", 1)


WinSetTitle($HypoGameBrowser,"", string($versionName &"  (v"& $versionNum&")"))

Global $serverRefreshTimer = TimerInit() ;global functions
Global $isGettingServers = 0

Global $iMaxSer = 350 ; global max servers to get, q2 list is huge
Global $iMaxIP = Int(25) ;max servers ping will get at once

;set a time of sent packet
;Global $serverPingArray[$iMaxSer]

;keep each server array in memory [num][string/ip/port/ping/HostPort] //#5 store kingpin gameport contained in server string
Global $sServerStringArray[$iMaxSer][5]
Global $sServerStringArrayKPQ3[$iMaxSer][4]
Global $sServerStringArrayQ2[$iMaxSer][4]

Global $iServerCountTotal = 0 ;get # of servers to use later to stop refresh
Global $iServerCountAdd = 0	;count the server if we recieved info

Global $tabNum = 1 ;hypo todo: set option 4 startup tab??

DisableUIButtons() ;hypo add this to let ui load

Global $changedListview = 0

Global $iOldSelectNumKp 	= -1
Global $iOldSelectNumKPQ3 	= -1
Global $iOldSelectNumQ2 	= -1

Global $iMOldSelectNumKp 	= -1
Global $iMOldSelectNumKPQ3 	= -1
Global $iMOldSelectNumQ2 	= -1

Global $iLastListviewSortStatus = -1
Global $iLastListviewSortStatusKPQ3 = -1
Global $iLastListviewSortStatusQ2 = -1

;sort server rules
Global $iLastRulesSortStatus = -1
Global $iLastRulesSortStatusKPQ3 = -1
Global $iLastRulesSortStatusQ2 = -1

Global $iListVewID[$iMaxSer]
Global $iListVewIDKPQ3[$iMaxSer]
Global $iListVewIDQ2[$iMaxSer]

Global $bOffline 		= True
Global $bOfflineKPQ3 	= True
Global $bOfflineQ2 		= True

Global $aFavKP[0]
Global $aFavKPQ3[0]
Global $aFavQ2[0]
Global $bStartupFav = False

;==> sockets. one for master, one for client
Global $hSocketServerUDP = -1 ; socket for servers communication
Global $hSocketMasterUDP = -1 ; socket for master communication
Global $hSocReqNum = 0 ; console log

Global Const $GUIMINWID = 824, $GUIMINHT = 650 ;set your restricted GUI size here

Global $StoredWinSize[4] ;store win size b4 minimizing it. or it causes error when exiting
Global $wasMaximized =False
Global $wasMinimized =False
Global $guiResized = False
Global $minToTray = 1 ;goto tray on minimize

Global $GS_countPlayers = 0

Global $gsIsChecked_KP = 0
Global $gsIsChecked_KPQ3 = 0
Global $gsIsChecked_Q2 = 0
Global $GS_lastRefreshTime
Global $Q2Web_lastRefreshTime

Global $tmpStatusbarString = ""
Global $statusBarChanged = False

;hotkeys
Global $sHkeyPlus=""
Global $sHkeyKey=""

;==================
;--> M BROWER COPY
; files that should be deleted

Global $MPopupInfo, $serverInfoRefBtn, $serverInfoConBtn, $ListView1POP, $ListView2POP

;Global Const $versionName = "hypobrowser"
;Global Const $versionNum = 1.00
Global 		 $m_GameName ; = "Kingpin"

Global Const $isTmpFilePath_KP = @TempDir & "\KP_Server_Array.txt"
Global Const $isTmpFilePath_KPQ3 = @TempDir & "\KPQ3_Server_Array.txt"
Global Const $isTmpFilePath_Q2Web = @TempDir & "\Q2Web_Server_Array.txt"

Global $mp3path1 = @TempDir & "\1_po.mp3"
Global $mp3path2 = @TempDir & "\2_po.mp3"
Global $mp3path3 = @TempDir & "\3_po.mp3"
Global $mp3path4 = @TempDir & "\4_po.mp3"
Global $mp3path5 = @TempDir & "\5_po.mp3"
Global $mp3path6 = @TempDir & "\6_po.mp3"
Global $mp3path7 = @TempDir & "\7_po.mp3"
Global $mp3path8 = @TempDir & "\8_po.mp3"
Global $mp3path9 = @TempDir & "\9_po.mp3"
Global $mp3path10 = @TempDir & "\10_po.mp3"
Global $mp3path10p = @TempDir & "\10plus_po.mp3"

FileInstall("D:\_code_\hypoBrowser\sounds\M_old\1_po.mp3", $mp3path1)
FileInstall("D:\_code_\hypoBrowser\sounds\M_old\2_po.mp3", $mp3path2)
FileInstall("D:\_code_\hypoBrowser\sounds\M_old\3_po.mp3", $mp3path3)
FileInstall("D:\_code_\hypoBrowser\sounds\M_old\4_po.mp3", $mp3path4)
FileInstall("D:\_code_\hypoBrowser\sounds\M_old\5_po.mp3", $mp3path5)
FileInstall("D:\_code_\hypoBrowser\sounds\M_old\6_po.mp3", $mp3path6)
FileInstall("D:\_code_\hypoBrowser\sounds\M_old\7_po.mp3", $mp3path7)
FileInstall("D:\_code_\hypoBrowser\sounds\M_old\8_po.mp3", $mp3path8)
FileInstall("D:\_code_\hypoBrowser\sounds\M_old\9_po.mp3", $mp3path9)
FileInstall("D:\_code_\hypoBrowser\sounds\M_old\10_po.mp3", $mp3path10)
FileInstall("D:\_code_\hypoBrowser\sounds\M_old\10plus_po.mp3", $mp3path10p)


Global Const $mLinkFilePathDel = @TempDir & "\disableMLink.reg"	;Global $mLinkFilePathDel = 0
Global Const $mLinkFilePathEnable = @TempDir & "\enableMlink.reg"

Global $M_lastRefreshTime; stored difference in time. for auto refresh

Global $PortToUse = 0
Global $refreshChkBoxState = 0 ;enable auto refresh, default off. saved to settings
Global $useSounds = 1
Global $useMStartup = 0

;-->  disaply player count
Global $countPlayers = 0
Global $countServers = 0
Global $countPlayersKPQ3 = 0
Global $countServersKPQ3 = 0
Global $countPlayersQ2 = 0
Global $countServersQ2 = 0
Global $iMOldSelectNumKp
Global $iMOldSelectNumKPQ3
Global $iMOldSelectNumQ2

Global $iMGameType = 1 ;Tab 6(m-browser) needs extra info to lunch game

iniFileLoad() ;load ini first for game path?
runGameFromM_LInk() ;check if a command lunched the exe, then exit
CheckSingleState() ;close if multiple are open

$M_lastRefreshTime = TimerInit() ;set time of last refresh


; chek reg for key in use and set check box for offline
Local $regKeyMBrowser = _WinAPI_RegOpenKey($HKEY_CLASSES_ROOT, 'M-Browser' , $KEY_QUERY_VALUE)
If Not $regKeyMBrowser = 0 Then GUICtrlSetState( $MLink, $GUI_CHECKED )
_WinAPI_RegCloseKey($regKeyMBrowser)
;--> M-BROWSER
;=============

;====================
;-- ONLY ONE INSTANCE
func CheckSingleState()
	If _Singleton("HypoGameBrowser", 1) = 0 Then
		MsgBox($MB_SYSTEMMODAL, "Warning", "HypoGameBrowser is already running")
		Exit
	EndIf
EndFunc ;-> ONLY ONE INSTANCE
;====================

;====================
;-- START NETWORK
TCPStartup()
UDPStartup()
;====================


;==============
;--> RAND PORT
Global $portRand = Random(50000, 55532, 1)

; port for servers communication
Func _BIND_SERVER_SOCKET()
	Local $ipSet

	For $ipSet = 0 to 5
		If $ipSet =5 Then
			MsgBox($MB_SYSTEMMODAL, "ERROR",  "Can Not allocate a local port",0, $HypoGameBrowser)
		EndIf
		$hSocketServerUDP =_UDPBind("", 0) ;$portRand
		If $hSocketServerUDP > 0 Then
			$portRand += 20
			ExitLoop
		Else
			$portRand += 1
		EndIf
	Next ;--> Rand Port
EndFunc

; port for master communication
Func _BIND_MASTER_SOCKET()
	Local $ipSet

	For $ipSet = 0 to 5
		If $ipSet = 5 Then
			MsgBox($MB_SYSTEMMODAL, "ERROR",  "Can Not allocate a local port",0, $HypoGameBrowser)
		EndIf
		$hSocketMasterUDP =_UDPBind("", 0) ;$portRand
		If $hSocketMasterUDP > 0 Then
			ExitLoop
		Else
			$portRand += 1
		EndIf
	Next ;--> Rand Port

EndFunc
;==============

$GS_lastRefreshTime = TimerInit() ;set time of last refresh
$Q2Web_lastRefreshTime = TimerInit() ;set time of last refresh

;==============
;--> Reset Refresh Timers
Func ResetRefreshTimmers()
	$M_lastRefreshTime = TimerInit() ;set time of last refresh
	$GS_lastRefreshTime = TimerInit() ;set time of last refresh
	$Q2Web_lastRefreshTime = TimerInit() ;set time of last refresh
EndFunc
;==============

;==============
;M load startup
;LoadMStartupOpt()
Func LoadMStartupOpt()
	If $useMStartup =1 Then
		_GUICtrlTab_ActivateTab($tabGroupGames, 5)
		;GUICtrlSetState($GetServersBtn, $GUI_HIDE)
		GUICtrlSetState($FavServerBtn, $GUI_HIDE)
		GUICtrlSetState($OffLineServeBtn, $GUI_HIDE)
		$tabNum = 6
		MRefresh()
	Else
		_GUICtrlTab_ActivateTab($tabGroupGames, 0)
		$tabNum = 1
	EndIf
EndFunc
;==============

_GUICtrlListView_SetImageList($ListView1KP, $ImageList1, 1)
_GUICtrlListView_SetImageList($ListView1KPQ3, $ImageList1, 1)
_GUICtrlListView_SetImageList($ListView1Q2, $ImageList1, 1)

_GUICtrlListView_RegisterSortCallBack($ListView1KP)
_GUICtrlListView_RegisterSortCallBack($ListView1KPQ3)
_GUICtrlListView_RegisterSortCallBack($ListView1Q2)

_GUICtrlListView_RegisterSortCallBack($ListView3)
_GUICtrlListView_RegisterSortCallBack($ListView3KPQ3)
_GUICtrlListView_RegisterSortCallBack($ListView3Q2)



; --> global settings
;========================================================
#EndRegion --> END GLOBAL


#Region --> INI FILE
;========================================================
;--> ini file setup
Func iniFileLoad()
	ConsoleWrite("-----========= loading=========-----" & @CRLF)
	Local $aArray, $i, $j=0, $k=0, $l=0, $aTmp

	If Not _FileReadToArray(StringTrimRight(@ScriptFullPath, 4) & ".ini", $aArray, 0)=0 Then
		For $i = 0 to UBound($aArray) -1
			If StringInStr($aArray[$i], 'Kingpin=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then GUICtrlSetData( $path_Kingpin , 	$aTmp[0])
			ElseIf	StringInStr($aArray[$i], 'KingpinQ3=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then GUICtrlSetData( $path_KPQ3 ,		$aTmp[0])
			ElseIf	StringInStr($aArray[$i], 'Quake2=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then GUICtrlSetData( $path_Quake2 ,	$aTmp[0])
			ElseIf	StringInStr($aArray[$i], 'M_TimeRefresh=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then GUICtrlSetData( $refreshTimeImput ,	$aTmp[0])
			ElseIf	StringInStr($aArray[$i], 'M_AutoRefresh=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then
					If $aTmp[0] = "1" Then
						GUICtrlSetState( $refreshChkBox, $GUI_CHECKED)
						$refreshChkBoxState = 1
					Else
						GUICtrlSetState( $refreshChkBox , $GUI_UNCHECKED)
						$refreshChkBoxState = 0
					EndIf
				EndIf
			ElseIf	StringInStr($aArray[$i], 'M_Sounds=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then
					If $aTmp[0] = "1" Then
						GUICtrlSetState( $soundChkBox, $GUI_CHECKED)
						$useSounds = 1
					Else
						GUICtrlSetState( $soundChkBox , $GUI_UNCHECKED)
						$useSounds = 0
					EndIf
				EndIf
			ElseIf	StringInStr($aArray[$i], 'FavKP=') Then
				ReDim $aFavKP[$j+1]
				$aFavKP[$j] = _StringBetween( $aArray[$i], '"' , '"')[0]
				ConsoleWrite("fav KP found = "&$aFavKP[$j]&@CRLF)
				$j += 1
			ElseIf	StringInStr($aArray[$i], 'FavKPQ3=') Then
				ReDim $aFavKPQ3[$k+1]
				$aFavKPQ3[$k] = _StringBetween( $aArray[$i], '"' , '"')[0]
				ConsoleWrite("fav KPQ3 found = "&$aFavKPQ3[$k]&@CRLF)
				$k += 1
			ElseIf	StringInStr($aArray[$i], 'FavQ2=') Then
				ReDim $aFavQ2[$l+1]
				$aFavQ2[$l] = _StringBetween( $aArray[$i], '"' , '"')[0]
				ConsoleWrite("fav Q2 found = "&$aFavQ2[$l]&@CRLF)
				$l += 1
			ElseIf	StringInStr($aArray[$i], 'MasterKP=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then GUICtrlSetData( $InputMaster4 ,	$aTmp[0])
			ElseIf	StringInStr($aArray[$i], 'MasterKPQ3=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then GUICtrlSetData( $InputMaster4KPQ3 ,	$aTmp[0])
			ElseIf	StringInStr($aArray[$i], 'MasterQ2=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then GUICtrlSetData( $InputMaster4Q2 ,	$aTmp[0])

			ElseIf	StringInStr($aArray[$i], 'NameKP=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then GUICtrlSetData( $InputNameKP ,	$aTmp[0])
			ElseIf	StringInStr($aArray[$i], 'NameKPQ3=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then GUICtrlSetData( $InputNameKPQ3 ,	$aTmp[0])
			ElseIf	StringInStr($aArray[$i], 'NameQ2=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then GUICtrlSetData( $InputNameQ2 ,	$aTmp[0])

			ElseIf	StringInStr($aArray[$i], 'RunOptKP=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then GUICtrlSetData( $RunKingpinCMD ,	$aTmp[0])
			ElseIf	StringInStr($aArray[$i], 'RunOptKPQ3=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then GUICtrlSetData( $RunKingpinQ3CMD ,	$aTmp[0])
			ElseIf	StringInStr($aArray[$i], 'RunOptQ2=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then GUICtrlSetData( $RunQuake2CMD ,	$aTmp[0])


			ElseIf	StringInStr($aArray[$i], 'MasterUsedKP=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then
					_GUICtrlButton_SetCheck($RadioMaster1, $BST_UNCHECKED)
					If StringCompare($aTmp[0],"1")=0 Then _GUICtrlButton_SetCheck($RadioMaster1, $BST_CHECKED)
					If StringCompare($aTmp[0],"2")=0 Then _GUICtrlButton_SetCheck($RadioMaster2, $BST_CHECKED)
					If StringCompare($aTmp[0],"3")=0 Then _GUICtrlButton_SetCheck($RadioMaster3, $BST_CHECKED)
					If StringCompare($aTmp[0],"4")=0 Then _GUICtrlButton_SetCheck($RadioMaster4, $BST_CHECKED)
				EndIf
			ElseIf	StringInStr($aArray[$i], 'MasterUsedKPQ3=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then
					_GUICtrlButton_SetCheck($RadioMaster1KPQ3, $BST_UNCHECKED)
					If StringCompare($aTmp[0],"1")=0 Then _GUICtrlButton_SetCheck($RadioMaster1KPQ3, $BST_CHECKED)
					If StringCompare($aTmp[0],"2")=0 Then _GUICtrlButton_SetCheck($RadioMaster2KPQ3, $BST_CHECKED)
					If StringCompare($aTmp[0],"3")=0 Then _GUICtrlButton_SetCheck($RadioMaster3KPQ3, $BST_CHECKED)
					If StringCompare($aTmp[0],"4")=0 Then _GUICtrlButton_SetCheck($RadioMaster4KPQ3, $BST_CHECKED)
					If StringCompare($aTmp[0],"1")=0 Then DisableKPQ3_TCP_UDP(1)
					If StringCompare($aTmp[0],"2")=0 Then DisableKPQ3_TCP_UDP(2)
					If StringCompare($aTmp[0],"3")=0 Then DisableKPQ3_TCP_UDP(3)
					If StringCompare($aTmp[0],"4")=0 Then DisableKPQ3_TCP_UDP(4)
					If StringCompare($aTmp[0],"1")=0 Then AutoSelectKPQ3_TCP_UDP(1)
					If StringCompare($aTmp[0],"2")=0 Then AutoSelectKPQ3_TCP_UDP(2)
					If StringCompare($aTmp[0],"3")=0 Then AutoSelectKPQ3_TCP_UDP(3)
					If StringCompare($aTmp[0],"4")=0 Then AutoSelectKPQ3_TCP_UDP(4)
				EndIf
			ElseIf	StringInStr($aArray[$i], 'MasterUsedQ2=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then
					_GUICtrlButton_SetCheck($RadioMaster1Q2, $BST_UNCHECKED)
					If StringCompare($aTmp[0],"1")=0 Then _GUICtrlButton_SetCheck($RadioMaster1Q2, $BST_CHECKED)
					If StringCompare($aTmp[0],"2")=0 Then _GUICtrlButton_SetCheck($RadioMaster2Q2, $BST_CHECKED)
					If StringCompare($aTmp[0],"3")=0 Then _GUICtrlButton_SetCheck($RadioMaster3Q2, $BST_CHECKED)
					If StringCompare($aTmp[0],"4")=0 Then _GUICtrlButton_SetCheck($RadioMaster4Q2, $BST_CHECKED)
					If StringCompare($aTmp[0],"1")=0 Then DisableQ2_TCP_UDP(1)
					If StringCompare($aTmp[0],"2")=0 Then DisableQ2_TCP_UDP(2)
					If StringCompare($aTmp[0],"3")=0 Then DisableQ2_TCP_UDP(3)
					If StringCompare($aTmp[0],"4")=0 Then DisableQ2_TCP_UDP(4)
					If StringCompare($aTmp[0],"1")=0 Then AutoSelectQ2_TCP_UDP(1)
					If StringCompare($aTmp[0],"2")=0 Then AutoSelectQ2_TCP_UDP(2)
					If StringCompare($aTmp[0],"3")=0 Then AutoSelectQ2_TCP_UDP(3)
					If StringCompare($aTmp[0],"4")=0 Then AutoSelectQ2_TCP_UDP(4)
				EndIf
;~ 			ElseIf	StringInStr($aArray[$i], 'Q2SERVERS=') Then
;~ 				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
;~ 				If not @error Then
;~ 					if $aTmp[0] = "Yes" Then
;~ 						GUICtrlSetState( $RadioMasterHTTP_Q2, $GUI_CHECKED)
;~ 					Else
;~ 						GUICtrlSetState( $RadioMasterHTTP_Q2, $GUI_UNCHECKED)
;~ 					EndIf
;~ 				EndIf
			ElseIf	StringInStr($aArray[$i], 'KPQ3Protocol=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then GUICtrlSetData( $InputKPQ3_proto ,	$aTmp[0])
			ElseIf	StringInStr($aArray[$i], 'KPQ3UDP=') Then
					If SelectedGameMasterKPQ3Num() = 4 Then
						$aTmp = _StringBetween( $aArray[$i], '"' , '"')
						If not @error Then
							if StringCompare($aTmp[0],"Yes")=0 Then
								GUICtrlSetState( $RadioMasterUDP_KPQ3, $GUI_CHECKED)
								GUICtrlSetState( $RadioMasterTCP_KPQ3, $GUI_UNCHECKED)
								;DisableKPQ3_TCP_UDP(4)
								AllowUDP_Input(1)
							Else
								GUICtrlSetState( $RadioMasterUDP_KPQ3, $GUI_UNCHECKED)
								GUICtrlSetState( $RadioMasterTCP_KPQ3, $GUI_CHECKED)
							EndIf
						EndIf
					EndIf
			ElseIf	StringInStr($aArray[$i], 'M_UseMStartup=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then
					If StringCompare($aTmp[0],"1")=0 Then
						GUICtrlSetState( $StartupMChkBox, $GUI_CHECKED)
						$useMStartup = 1
					Else
						GUICtrlSetState( $StartupMChkBox, $GUI_UNCHECKED)
						$useMStartup = 0
					EndIf
				EndIf

			ElseIf	StringInStr($aArray[$i], 'MinimizeToTray=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then
					If StringCompare($aTmp[0],"1")=0 Then
						GUICtrlSetState( $opt_minToTray, $GUI_CHECKED)
						$minToTray = 1
					Else
						GUICtrlSetState( $opt_minToTray, $GUI_UNCHECKED)
						$minToTray = 0
					EndIf
				EndIf
			ElseIf	StringInStr($aArray[$i], 'Hotkey=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then
					GUICtrlSetData($hotKey_Input, $aTmp[0])
				EndIf
			ElseIf	StringInStr($aArray[$i], 'HotkeyAlt=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then
					If StringCompare($aTmp[0],"1")=0 Then
						GUICtrlSetState( $hotKey_alt, $GUI_CHECKED)
						GUICtrlSetState( $hotKey_ctrl, $GUI_UNCHECKED)
					Else
						GUICtrlSetState( $hotKey_alt, $GUI_UNCHECKED)
						GUICtrlSetState( $hotKey_ctrl, $GUI_CHECKED)
					EndIf

					If StringLen( GUICtrlRead($hotKey_Input))>=1 Then
						ApplyhotKey(0)
					EndIf
				EndIf

			ElseIf	StringInStr($aArray[$i], 'Position=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"', $STR_ENDNOTSTART)
				If not @error Then
					;if $aTmp[0]= -32000 Then $aTmp[0]= 0
					;if $aTmp[1]= -32000 Then $aTmp[1]= 0
					WinMove($HypoGameBrowser, $HypoGameBrowser, $aTmp[0], $aTmp[1], $aTmp[2], $aTmp[3])
					SetWinSizeForMinimize() ; save location to memory now, incase
				EndIf
			ElseIf	StringInStr($aArray[$i], 'GS_AutoGame=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then
					If StringCompare($aTmp[0],"1")=0 Then
						GUICtrlSetState( $GB_RB_Kingpin, $GUI_CHECKED)
					ElseIf StringCompare($aTmp[0],"2")=0 Then
						GUICtrlSetState( $GB_RB_KingpinQ3, $GUI_CHECKED)
					ElseIf StringCompare($aTmp[0],"3")=0 Then
						GUICtrlSetState( $GB_RB_Quake2, $GUI_CHECKED)
					EndIf
				EndIf
			ElseIf	StringInStr($aArray[$i], 'GS_AutoTime=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then GUICtrlSetData( $GB_IN_refreshTime, $aTmp[0])
			ElseIf	StringInStr($aArray[$i], 'GS_Sounds=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"')
				If not @error Then
					If StringCompare($aTmp[0],"1")=0 Then
						GUICtrlSetState($GB_Players_sound, $GUI_CHECKED)
					EndIf
				EndIf
			EndIf
		Next

	EndIf

ConsoleWrite("-----========= loading DONE=========-----" & @CRLF)

EndFunc


Func iniFileSave()
	ConsoleWrite("-----========= saving=========-----" & @CRLF)
	local $iniFileCFG = string(StringTrimRight(@ScriptFullPath, 4) & ".ini")
	Local $iSize = 43 ;LINES... quick set default array size, minus fav
	Local $iniFileArray[$iSize]
	Local $i, $j, $k

	local $stateMinimized = WinGetState($HypoGameBrowser)

	Local $v[4]
	$v = WinGetPos($HypoGameBrowser)

						;16=minimized 32 maximized
	if BitAND($stateMinimized,16) Or BitAND($stateMinimized, 32) Then
		$v = $StoredWinSize
		ConsoleWrite(" window old resize saved instead.."&@CRLF)
	EndIf

	;make sure size is not below min allowed
	If $v[2] < $GUIMINWID Then $v[2] = $GUIMINWID
	If $v[3] < $GUIMINHT Then $v[3] = $GUIMINHT

	Local $GameToRefresh = 0
	if _IsChecked($GB_RB_Kingpin) Then
		$GameToRefresh = 1
	Elseif _IsChecked($GB_RB_KingpinQ3) Then
		$GameToRefresh = 2
	Elseif _IsChecked($GB_RB_Quake2) Then
		$GameToRefresh = 3
	EndIf

	Local $GS_sounsEnable = 0
	if _IsChecked($GB_Players_sound) Then
		$GS_sounsEnable = 1
	EndIf

	Local $opt_hotkey = 1
	if _IsChecked($hotKey_ctrl) Then
		$opt_hotkey = 0
	EndIf

	$iniFileArray[0] = "[MBrowser]"
	$iniFileArray[1] = String('M_TimeRefresh=' & '"' & 	GUICtrlRead($refreshTimeImput) 	& '"')
	$iniFileArray[2] = String('M_AutoRefresh=' & '"' & 	$refreshChkBoxState & '"')
	$iniFileArray[3] = String('M_Sounds=' & '"' & 		$useSounds 						& '"')
	$iniFileArray[4] = String('M_UseMStartup=' & '"' & 	$useMStartup 					& '"')
	$iniFileArray[5] = ""
	$iniFileArray[6] = "[exePath]"
	$iniFileArray[7] = String( 'Kingpin=' & '"' & 		GUICtrlRead($path_Kingpin) 		& '"')
	$iniFileArray[8] = String( 'KingpinQ3=' & '"' & 	GUICtrlRead($path_KPQ3) 		& '"')
	$iniFileArray[9] = String( 'Quake2=' & '"' & 		GUICtrlRead($path_Quake2) 		& '"')
	$iniFileArray[10] = ""
	$iniFileArray[11] = "[Name]"
	$iniFileArray[12] = String( 'NameKP=' & '"' & 		GUICtrlRead($InputNameKP) 		& '"')
	$iniFileArray[13] = String( 'NameKPQ3=' & '"' & 	GUICtrlRead($InputNameKPQ3) 	& '"')
	$iniFileArray[14] = String( 'NameQ2=' & '"' & 		GUICtrlRead($InputNameQ2) 		& '"')
	$iniFileArray[15] = ""
	$iniFileArray[16] = "[Commands]"
	$iniFileArray[17] = String( 'RunOptKP=' & '"' & 	GUICtrlRead($RunKingpinCMD) 	& '"')
	$iniFileArray[18] = String( 'RunOptKPQ3=' & '"' &	GUICtrlRead($RunKingpinQ3CMD) 	& '"')
	$iniFileArray[19] = String( 'RunOptQ2=' & '"' & 	GUICtrlRead($RunQuake2CMD) 		& '"')
	$iniFileArray[20] = ""
	$iniFileArray[21] = "[Master]"
	$iniFileArray[22] = String( 'MasterKP=' & '"' & 	GUICtrlRead($InputMaster4) 		& '"')
	$iniFileArray[23] = String( 'MasterKPQ3=' & '"' & 	GUICtrlRead($InputMaster4KPQ3) 	& '"')
	$iniFileArray[24] = String( 'MasterQ2=' & '"' & 	GUICtrlRead($InputMaster4Q2)	& '"')
	$iniFileArray[25] = ""
	$iniFileArray[26] = "[MasterUsed]"
	$iniFileArray[27] = String( 'MasterUsedKP=' & '"' &	SelectedGameMasterKPNum() 		& '"')
	$iniFileArray[28] = String( 'MasterUsedKPQ3='& '"'&	SelectedGameMasterKPQ3Num() 	& '"')
	$iniFileArray[29] = String( 'MasterUsedQ2=' & '"' &	SelectedGameMasterQ2Num() 		& '"')
;~ 	$iniFileArray[30] = String( 'Q2SERVERS=' 	& '"' &	SelectedGameMasterQ2Web() 		& '"') ;Q2SERVERS																							;Q2SERVERS
	$iniFileArray[30] = String( 'KPQ3Protocol=' & '"' &	GUICtrlRead($InputKPQ3_proto) 	& '"')
	$iniFileArray[31] = String( 'KPQ3UDP=' 		& '"' &	SelectUDPMasterKPQ3() 			& '"')
	$iniFileArray[32] = ""
	$iniFileArray[33] = "[Settings]"
	$iniFileArray[34] = String('Position='&'"'&$v[0]&'" "'&$v[1]&'" "'&$v[2]&'" "'&$v[3]&'"')
	$iniFileArray[35] = String('GS_AutoGame=' & '"' & 	$GameToRefresh 					& '"')
	$iniFileArray[36] = String( 'GS_AutoTime=' & '"' & 	GUICtrlRead($GB_IN_refreshTime)	& '"')
	$iniFileArray[37] = String('GS_Sounds=' & '"' & 	$GS_sounsEnable					& '"')
	$iniFileArray[38] = String('MinimizeToTray='& '"' &	$minToTray						& '"')
	$iniFileArray[39] = String('Hotkey='& '"' &			GUICtrlRead($hotKey_Input)		& '"')
	$iniFileArray[40] = String('HotkeyAlt='& '"' &		$opt_hotkey						& '"')

	$iniFileArray[41] = ""
	$iniFileArray[42] = "[Favourites]"
	;======= array[] = +1 ============


	;kingpin fav
	ConsoleWrite(" Fav kp   "&UBound($aFavKP) &@CRLF)
	For $i = 0 To UBound($aFavKP)-1
		;If $i = UBound($aFavKP) Then ExitLoop(1)
		If $aFavKP[$i] > "" Then
			ReDim $iniFileArray[$iSize+1+$i]
			$iniFileArray[$iSize+$i] = String('FavKP=' & '"' & $aFavKP[$i] & '"')
		EndIf
	Next
	;kingpinq3 fav
	ConsoleWrite(" Fav kpq3 "&UBound($aFavKPQ3) &@CRLF)
	For $j = 0 To UBound($aFavKPQ3)-1

		;If $i = UBound($aFavKPQ3) Then ExitLoop(1)
		If $aFavKPQ3[$k] > "" Then
			ReDim $iniFileArray[$iSize+1+$i+$j]
			$iniFileArray[$iSize+$i+$j] = String('FavKPQ3=' & '"' & $aFavKPQ3[$j] & '"')
		EndIf
	Next
	;quake fav
	ConsoleWrite(" Fav q2   "&UBound($aFavQ2) &@CRLF)
	For $k = 0 To UBound($aFavQ2)-1

		;If $i = UBound($aFavQ2) Then ExitLoop(1)
		If $aFavQ2[$k] > "" Then
			ReDim $iniFileArray[$iSize+1+$i+$j+$k]
			$iniFileArray[$iSize+$i+$j+$k] = String('FavQ2=' & '"' & $aFavQ2[$k] & '"')
		EndIf
	Next



	Local $testWrite = _FileWriteFromArray( $iniFileCFG, $iniFileArray, 0 )

	If @error Or $testWrite = 0 Then
		MsgBox($MB_SYSTEMMODAL, "", "Could not Save Settings ",0, $HypoGameBrowser )
		ResetRefreshTimmers()
	EndIf

ConsoleWrite("-----========= saving DONE=========-----" & @CRLF)
EndFunc ;--> end ini file setup
;========================================================
#EndRegion


#Region --> MBROWSER

	#Region -->EVENTS
	;GUICtrlSetOnEvent($Button_Refresh,"MRefresh")
		Func MRefresh()
			GetServerList()
			setServerTabArray()
		EndFunc
	#EndRegion --> EVENTS


	#Region --> add server ports
	;========================================================
	;-->add server ports
	;================
	;-->add KingpinQ3
	Func TickedGamePortKPQ3()
		If _IsChecked($addKPQ3) Then
			GUICtrlSetState( $addQuake2, $GUI_UNCHECKED)
		Else
			GUICtrlSetState( $addQuake2, $GUI_UNCHECKED)
		EndIf
	EndFunc

	;=============
	;-->add Quake2
	Func TickedGamePortQuake()
		If _IsChecked($addQuake2) Then
			GUICtrlSetState( $addKPQ3, $GUI_UNCHECKED)
		Else
			GUICtrlSetState( $addKPQ3, $GUI_UNCHECKED)
		EndIf
	EndFunc

	;================
	;-->selected game
	Func GameNameToSetPort()
		if  _IsChecked($addKPQ3) Then
			$m_GameName = "kingpinq3"
		ElseIf  _IsChecked($addQuake2) Then
			$m_GameName = "quake2"
		Else
			$m_GameName = "kingpin"
		EndIf
	EndFunc

	;===================
	;--> set port string
	Func setPortString()
		$PortToUse = GUICtrlRead($getPort)
	EndFunc

	;==============
	;--> add server
	Func ServerAddPortKP()
		setPortString() ;set port from string
		GameNameToSetPort();set global Gamename for sent port

		;/mbrowser.php?game=kingpin		&	username=	M-Browser+1.8&v=1.8 &join=	removeserver	:31520	&quit=1
		;/mbrowser.php?game=kingpinQ3	&	username=	hypobrowser&v=1.01	&join=	excludeserver	:31620	&quit=1

		Local $stringCombineVars = String("http://kingpin.hambloch.com/mbrowser.php?game=" & $m_GameName & "&username=" & _
										$versionName &  "&v=" & $versionNum & "&join=addserver:" & $PortToUse & "&quit=1")

									ConsoleWrite(	$stringCombineVars&@CRLF)
		local $tmpSize = InetGetSize($stringCombineVars,$INET_FORCERELOAD)

		MsgBox($MB_SYSTEMMODAL, "Add Port", "Game = " & $m_GameName & @CRLF & "Port = " & $PortToUse,0, $HypoGameBrowser )
		ResetRefreshTimmers()
	EndFunc

	;=================
	;--> remove server
	Func ServerRemovePortKP()
		setPortString()
		GameNameToSetPort();set global Gamename for sent port

		Local $stringCombineVars = String("http://kingpin.hambloch.com/mbrowser.php?game=" & $m_GameName & "&username=" & _
									$versionName &  "&v=" & $versionNum & "&join=removeserver:" & $PortToUse & "&quit=1")
		local $tmpSize = InetGetSize($stringCombineVars,$INET_FORCERELOAD)
									ConsoleWrite(	$stringCombineVars&@CRLF)

		MsgBox($MB_SYSTEMMODAL, "Remove Port", "Game = " & $m_GameName & @CRLF & "Port = " & $PortToUse,0, $HypoGameBrowser )
		ResetRefreshTimmers()
	EndFunc

	;==================
	;--> exclude server
	Func ServerExcludePortKP()
		setPortString()
		GameNameToSetPort();set global Gamename for sent port

		Local $stringCombineVars = String("http://kingpin.hambloch.com/mbrowser.php?game=" & $m_GameName & "&username=" & _
									$versionName &  "&v=" & $versionNum & "&join=excludeserver:" & $PortToUse & "&quit=1")
		local $tmpSize = InetGetSize($stringCombineVars,$INET_FORCERELOAD)
								ConsoleWrite(	$stringCombineVars&@CRLF)

		MsgBox($MB_SYSTEMMODAL, "Exclude Port", "Game = " & $m_GameName & @CRLF & "Port = " & $PortToUse,0, $HypoGameBrowser )
		ResetRefreshTimmers()
	EndFunc
	; -->PORT end add game via port settings
	;=============================================================================
	#EndRegion


	#Region --> ServerDetailArray
	;=====================
	;--> ServerDetailArray
	Func ServerDetailArray($serverInfoString)
		ConsoleWrite("string.. " &$serverInfoString& @CRLF)

		If $serverInfoString = "" Then
			Return False
		Else
			$serverInfoString = StringReplace($serverInfoString, "Info string length exceeded" & Chr(10), "",0 )

			Local $tmpstr = StringSplit($serverInfoString, Chr(10), $STR_ENTIRESPLIT)
			If @error Then
				MsgBox($MB_SYSTEMMODAL, "","Error in packet, no Return" )
				ResetRefreshTimmers();reset refresh on msgbox
				Return
			EndIf

			Local $numLines = $tmpstr[0] ;3 lines standard >= players
			;MsgBox($MB_SYSTEMMODAL, "","finnn:" & $numLines )

			If Not StringInStr($tmpstr[1],"ÿÿÿÿprint") And Not StringInStr($tmpstr[1],"ÿÿÿÿstatusResponse") Then
				MsgBox($MB_SYSTEMMODAL, "","error in packet header (no 'yyyy')" )
				ResetRefreshTimmers()
				Return
			EndIf

			Local $serverVars = $tmpstr[2]
			Local $i2
			Local $iRay=0
			Local $intADD1

		;;;; set server string varables
			local $servrVarArray = StringSplit($serverVars, "\" ) ;setup server strings
			if Not @error Then
				_GUICtrlListView_DeleteAllItems($ListView2POP)
				For $i2 = 2 To $servrVarArray[0] Step 2

				$intADD1 = $i2
				$intADD1 += 1

				_GUICtrlListView_AddItem($ListView2POP, $servrVarArray[$i2],-1, 0)
				_GUICtrlListView_AddSubItem($ListView2POP,$iRay, $servrVarArray[$intADD1]	 ,1)	;string
				$iRay +=1
				Next
			EndIf

		;;;; add players info, max 31 char for player name
			Local $iply = 3
			If Not $tmpstr[3] = "" Then
				local $plyr = 0
				Local $playerName =""
				local $plyrStatus
				Local $plyrStatusArray
				_GUICtrlListView_DeleteAllItems($ListView1POP)
				For $iply = 3 To $numLines Step 1
					If Not $tmpstr[$iply] ="" Then ;catch end line @LF, EOT

						$playerName = _StringBetween($tmpstr[$iply], '"', '"' ) ;get server name[0]
						$plyrStatus = StringReplace($tmpstr[$iply], '"' & $playerName[0] & '"', "") ;
						$plyrStatusArray = StringSplit($plyrStatus, " " ) ;setup server strings

						_GUICtrlListView_AddItem($ListView1POP, $playerName[0],-1, 0)				;Name
						_GUICtrlListView_AddSubItem($ListView1POP,$plyr, $plyrStatusArray[1] ,1)	;Frags
						_GUICtrlListView_AddSubItem($ListView1POP,$plyr, $plyrStatusArray[2] ,2)	;Ping

						$plyr += 1 ;increase 1
					EndIf
				Next
			EndIf
		EndIf

		Return True
	EndFunc
	;--> ServerDetailArray
	;=====================
	#EndRegion


	#Region --> M Get server info strings
	;========================================================
	;--> Get server info strings
	Func GetServerPacket()
		Local $serverIP, $serverPort, $status, $timeCounted, $data
		local $getTimeDiffServer = TimerInit()
		Local $sIPAddress, $iPort, $iErrorX

		Local $serverAddress = StringSplit(GetTabSelectedArrayStringIP(),":")
		If @error Then Return ""

		$sIPAddress = TCPNameToIP( $serverAddress[1])
		$iPort = $serverAddress[2]

		$iErrorX = _UDPSendTo($sIPAddress, $iPort, sendStatusMessageType(), ($hSocketServerUDP))
		if @error Then
			ConsoleWrite("UDP Send \status\ sock error =  " & $iErrorX & " error" & @CRLF)
			Return
		EndIf


		Do ;loop untill complet info string is recieved or timed out. 3.5 seconds
			$data = _UDPRecvFrom(($hSocketServerUDP),2048,0)
			$timeCounted = TimerDiff($getTimeDiffServer)
			If $timeCounted > 3500 Then
				ConsoleWrite("error geting packet "&@CRLF)
				Return ""
			EndIf
		Until IsArray($data)


		ConsoleWrite(" packet recieved "& $data[0]& @CRLF)

		Return $data[0] ;$serverInfoString
	EndFunc
	;--> END Get server info strings
	;========================================================
	#EndRegion


	#Region --> server info POPUP
	;=====================
	;--> server info POPUP
	Global $posX = WinGetPos($HypoGameBrowser)[0]
	Global $posY = WinGetPos($HypoGameBrowser)[1]

	GetServerDetailsPopupFunc()
	Func GetServerDetailsPopupFunc()
		;;;GUISetState(@SW_DISABLE,$HypoGameBrowser)

		;;--> creat PopUp GUI
		#Region ### START Koda GUI section ### Form=C:\Programs\codeing\autoit-v3\SciTe\Koda\Templates\M_Browser_GUI_ServerInfo1.kxf
		;$MPopupInfo = GUICreate("Server Info", 547, 426, $posX, $posY, -1, -1, $HypoGameBrowser) ;note hypov8 using main window position
		$MPopupInfo = GUICreate("Server Info", 547, 426, $posX, $posY, BitOR($WS_CAPTION, $WS_POPUP, $WS_SYSMENU), -1, $HypoGameBrowser)
		;$MPopupInfo = GUICreate("Server Info", 547, 426, -1, -1, BitOR($GUI_SS_DEFAULT_GUI,$WS_MINIMIZE), -1, $HypoGameBrowser)
		;$Group1POP = GUICtrlCreateGroup("", 8, 8, 297, 409)
		$ListView1POP = GUICtrlCreateListView("Name|Frags|Ping", 8, 16, 296, 401)
		GUICtrlSendMsg($ListView1POP, $LVM_SETCOLUMNWIDTH, 0, 195)
		GUICtrlSendMsg($ListView1POP, $LVM_SETCOLUMNWIDTH, 1, 45)
		GUICtrlSendMsg($ListView1POP, $LVM_SETCOLUMNWIDTH, 2, 45)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		GUICtrlCreateGroup("", 312, 8, 225, 369)
		$ListView2POP = GUICtrlCreateListView("Server Rules|Value", 312, 16, 225, 361)
		GUICtrlSendMsg($ListView2POP, $LVM_SETCOLUMNWIDTH, 0, 85)
		GUICtrlSendMsg($ListView2POP, $LVM_SETCOLUMNWIDTH, 1, 110)
		Global $tmpCtrl = GUICtrlCreateGroup("", -99, -99, 1, 1)
		$serverInfoRefBtn = GUICtrlCreateButton("Refresh", 440, 384, 81, 33)
		$serverInfoConBtn = GUICtrlCreateButton("Connect", 336, 384, 89, 33)
		GUICtrlSetFont($serverInfoConBtn, 8* $aDPI[0], 800, 0, "MS Sans Serif")
		GUISetState(@SW_HIDE,$MPopupInfo)
		GUISetFont(8* $aDPI[0], 0, 0,  "MS Sans Serif", $MPopupInfo)
		#EndRegion ### END Koda GUI section ###
		;;--> END creat PopUp GUI

		GUICtrlSetColor($ListView1POP, $COLOR_1ORANGE)
		GUICtrlSetBkColor ($ListView1POP,$COLOR_1BLACK)
		GUICtrlSetColor($ListView2POP, $COLOR_1ORANGE)
		GUICtrlSetBkColor ($ListView2POP,$COLOR_1BLACK)

;~ 			If StringInStr(@OSTYPE, "WIN32_NT") Then
;~ 				DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($ListView1POP), "wstr", 0, "wstr", 0)
;~ 				DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($ListView2POP), "wstr", 0, "wstr", 0)
;~ 				DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($tmpCtrl ), "wstr", 0, "wstr", 0)
;~ 			EndIf


		GUISetOnEvent($GUI_EVENT_CLOSE,"ExitLoopForm", $MPopupInfo)
		GUICtrlSetOnEvent($serverInfoConBtn,"serverInfoConnectBtn")
		GUICtrlSetOnEvent($serverInfoRefBtn, "serverInfoRefreshBtn")
	EndFunc
	;--> END Get server info strings
	;==============================

	Func GetServerDetailsPopup()
		;GUISetState(
		;GUICtrlSetPos(

		$posX = WinGetPos($HypoGameBrowser)[0]
		$posY = WinGetPos($HypoGameBrowser)[1]
		$posX += 56
		$posY += 78


		GUISetState(@SW_DISABLE,$HypoGameBrowser)
		GUISetState(@SW_SHOW,$MPopupInfo)
		WinMove($MPopupInfo, WinMove,$posX, $posY)
		GUISetCoord(33, 33,-1, -1, $MPopupInfo)

		serverInfoRefreshBtn()
	EndFunc

	Func serverInfoRefreshBtn()
		DisableMPopupButtons()
		_BIND_SERVER_SOCKET()

		Local	$serverInfoString = GetServerPacket()
		If Not $serverInfoString = "" Then ServerDetailArray($serverInfoString)
		_UDPCloseSocket($hSocketServerUDP)
		EnableMPopupButtons()
	EndFunc

	func DisableMPopupButtons()
		GUICtrlSetState($serverInfoConBtn, $GUI_DISABLE)
		GUICtrlSetState($serverInfoRefBtn, $GUI_DISABLE)
		GUISetState(@SW_DISABLE,$MPopupInfo)
	EndFunc

	func EnableMPopupButtons()
		GUICtrlSetState($serverInfoConBtn, $GUI_ENABLE)
		GUICtrlSetState($serverInfoRefBtn, $GUI_ENABLE)
		GUISetState(@SW_ENABLE,$MPopupInfo)
	EndFunc



	Func serverInfoConnectBtn()
		_GUICtrlListView_DeleteAllItems($ListView2POP) ;hypo delet data
		_GUICtrlListView_DeleteAllItems($ListView1POP) ;hypo delet data
		GUISetState(@SW_HIDE,$MPopupInfo)
		Opt("GUIOnEventMode",1)
		GUISetState(@SW_ENABLE, $HypoGameBrowser)
		GUISetState(@SW_RESTORE, $HypoGameBrowser)
		;WinActive($HypoGameBrowser)
		Start_Kingpin()
	EndFunc

	Func ExitLoopForm()
		_GUICtrlListView_DeleteAllItems($ListView2POP) ;hypo delet data
		_GUICtrlListView_DeleteAllItems($ListView1POP) ;hypo delet data
		GUISetState(@SW_HIDE,$MPopupInfo)
		GUISetState(@SW_ENABLE, $HypoGameBrowser)
		GUISetState(@SW_RESTORE, $HypoGameBrowser)
	EndFunc

	;========================================================
	#EndRegion


	#Region --> runGameFromM_LInk
	;========================================================
	Func runGameFromM_LInk() ;If FileExists("kingpin.exe") OR ($CmdLine[0]<>"" AND
		If Not $CmdLine[0] Then return

		Local $cmdString = "m-browser://"

		If StringInStr($CmdLine[1], $cmdString)=1 Then
			local $serverIP = StringTrimLeft($CmdLine[1], StringLen($cmdString))
			If FileExists("kingpin.exe") Then
				ShellExecute( "kingpin.exe"," +set developer 1 +connect " & $serverIP)
			Else
				Local $rungame = GUICtrlRead($path_Kingpin)
				local $aArrayPath = $rungame
				$aArrayPath =StringReverse($aArrayPath)
				Local $tmpstr = string(StringSplit( $aArrayPath, "\" )[1])
				local $tmpLen = StringLen($tmpstr )
				local $trimEXE = StringTrimRight($rungame,$tmpLen) ;kingpin.exe ;trim exe to seet active path (stop missing color map issue)
				ShellExecute( $rungame, " +set developer 1 +connect " & $serverIP, $trimEXE )
				Exit
			EndIf
		EndIf

		;GUISetState(@SW_RESTORE, $HypoGameBrowser)
		;no commands to process
	EndFunc
	;========================================================
	#EndRegion

	Func _IsChecked($idControlID)
		Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
	EndFunc


	#Region --> use auto refresh
	;========================================================
	; --> use auto refresh
	Func AutoRefreshTimer()
		Local $intTimeStringBox, $oldTabNum
		Local $timeCounted
		local $stateMinimized = WinGetState( $HypoGameBrowser)
		Local $getWinState = WinGetState($MPopupInfo)

		;disable autor efresh if not ready
		If  BitAND($stateMinimized,16) Then Return ;$WIN_STATE_MINIMIZED
		if BitAND($getWinState,2) Then Return ;$WIN_STATE_VISIBLE ;if M-popup showing, disable refresh
		if $isGettingServers > 0 Then Return ;todo: <> or -1?

		;mBrowser
		If $refreshChkBoxState = 1 Then ;$GUI_CHECKED
			$intTimeStringBox = Int(GUICtrlRead($refreshTimeImput))
			If $intTimeStringBox <= 1 Then $intTimeStringBox = 1
			$intTimeStringBox *= 1000 * 60
			$timeCounted = TimerDiff($M_lastRefreshTime)
			If $timeCounted > $intTimeStringBox Then
				GetServerList()
				setServerTabArray()
			EndIf
		EndIf

		;gameSpy
		If  _IsChecked($GB_RB_Kingpin) Then
			$intTimeStringBox = Int(GUICtrlRead($GB_IN_refreshTime)) ; get time
			If $intTimeStringBox <= 1 Then $intTimeStringBox = 1
			$intTimeStringBox *= 1000 * 60
			;check last refresh time
			$timeCounted = TimerDiff($GS_lastRefreshTime)
			If $timeCounted > $intTimeStringBox Then
				$oldTabNum = $tabNum
				$tabNum = 1
				GetMasterServerList(True, 1)
				$tabNum = $oldTabNum
			EndIf
		ElseIf _IsChecked($GB_RB_KingpinQ3) Then
			$intTimeStringBox = Int(GUICtrlRead($GB_IN_refreshTime)) ; get time
			If $intTimeStringBox <= 1 Then $intTimeStringBox = 1
			$intTimeStringBox *= 1000 * 60
			;check last refresh time
			$timeCounted = TimerDiff($GS_lastRefreshTime)
			If $timeCounted > $intTimeStringBox Then
				$oldTabNum = $tabNum
				$tabNum = 2
				GetMasterServerList(True, 2)
				$tabNum = $oldTabNum
			EndIf
		ElseIf _IsChecked($GB_RB_Quake2) Then
			$intTimeStringBox = Int(GUICtrlRead($GB_IN_refreshTime)) ; get time
			If $intTimeStringBox <= 1 Then $intTimeStringBox = 1
			$intTimeStringBox *= 1000 * 60
			;check last refresh time
			$timeCounted = TimerDiff($GS_lastRefreshTime)
			If $timeCounted > $intTimeStringBox Then
				$oldTabNum = $tabNum
				$tabNum = 3
				GetMasterServerList(True, 3)
				$tabNum = $oldTabNum
			EndIf
		EndIf
	EndFunc


	;=======================
	;--> RefreshChkBoxToggle
	GUICtrlSetOnEvent($refreshChkBox, "RefreshChkBoxToggle")
		Func RefreshChkBoxToggle()
			If _IsChecked($refreshChkBox) Then
				$refreshChkBoxState = 1
				$M_lastRefreshTime = TimerInit()
			Else
				$refreshChkBoxState = 0
			EndIf
		EndFunc
	;=====================
	;--> SoundChkBoxToggle
	GUICtrlSetOnEvent($soundChkBox, "SoundChkBoxToggle")
		Func SoundChkBoxToggle()
				If _IsChecked($soundChkBox) Then
				$useSounds = 1
			Else
				$useSounds = 0
			EndIf
		EndFunc
	; --> END auto refresh
	;========================================================
	#EndRegion


	#Region -->  disaply player count
	;=============================================================================
	;-->  disaply player count

	;============================
	;-->update the info bar Kingpin
	Func UpdatePlayersStatus( $getPlayerIinfo)
		If $getPlayerIinfo = ""	Then Return False ;make sure string exists
		Local $String = StringSplit($getPlayerIinfo, '/', $STR_CHRSPLIT)
		if @error Then Return 0 ;todo: check
		Local $count = $String[1]
		$countPlayers += Int($count)
		If int($count) > 0 Then Return True
	EndFunc

	Func SetPlayersOnlineString()
		GUICtrlSetData($playersOnline,"KP Players: " & $countPlayers & " " );& "  and " & $countServers & " Servers")
		If $countPlayers > 0 Then
			GUICtrlSetColor( $playersOnline, $COLOR_RED)
		Else
			GUICtrlSetColor( $playersOnline, $COLOR_BLACK)
		EndIf
	EndFunc

	;============================
	;-->update the info bar KPQ3
	Func UpdatePlayersStatusKPQ3( $getPlayerIinfoKPQ3)
		If $getPlayerIinfoKPQ3 = ""	Then Return False ;make sure string exists
		Local $String = StringSplit($getPlayerIinfoKPQ3, '/', $STR_CHRSPLIT)
		if @error Then Return 0 ;todo: check
		Local $count = $String[1]
		$countPlayersKPQ3 += Int($count)
		If int($count) > 0 Then Return True
	EndFunc

	Func SetPlayersOnlineStringKPQ3()
		GUICtrlSetData($playersOnlineKPQ3,"KPQ3 Players: " & $countPlayersKPQ3 & " " );& " Servers:" & $countServersKPQ3)
		If $countPlayersKPQ3 > 0 Then
			GUICtrlSetColor( $playersOnlineKPQ3, $COLOR_RED)
		Else
			GUICtrlSetColor( $playersOnlineKPQ3, $COLOR_BLACK)
		EndIf
	EndFunc

	;============================
	;-->update the info bar Q2
	Func UpdatePlayersStatusQ2( $getPlayerIinfoQ2)
		If $getPlayerIinfoQ2 = "" Then Return False ;make sure string exists
		Local 	$String = StringSplit($getPlayerIinfoQ2, '/', $STR_CHRSPLIT)
		if @error Then Return 0 ;todo: check
		Local 	$count = $String[1]
		$countPlayers += Int($count)
		If int($count) > 0 Then Return True
	EndFunc

	;============================
	;--> Quake2 players
	Func SetPlayersOnlineStringQ2()
		GUICtrlSetData($playersOnlineQ2,"Q2 Players: " & $countPlayersQ2 & " " );& " Servers:" & $countServersKPQ3)
		If $countPlayersQ2 > 0 Then
			GUICtrlSetColor( $playersOnlineQ2, $COLOR_RED)
		Else
			GUICtrlSetColor( $playersOnlineQ2, $COLOR_BLACK)
		EndIf
	EndFunc
	;-->  END disaply player count
	;=============================================================================
	#EndRegion


	#Region --> GetServerList File
	;=============================================================================
	;--> GetServerList File
	Func GetServerList()
		Local $i
		DisableUIButtons()

		;loop through 2 files
		For $i = 1 To 2
			Local $hDownload
			$M_lastRefreshTime = TimerInit() ;set a new time for auto refresh
			If $i = 2 Then
				FileDelete($isTmpFilePath_KPQ3)
				$hDownload = InetGet("http://kingpin.hambloch.com/mbrowser.php?game=kingpinq3&username=hypobrowser&v=1.0", _
				$isTmpFilePath_KPQ3, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND ) ;$INET_DOWNLOADBACKGROUND $INET_DOWNLOADWAIT
				ConsoleWrite("getting kpq3 web file"&@CRLF)
			Else
				FileDelete($isTmpFilePath_KP)
				;$hDownload = InetGet("http://hypov8.kingpin.info/motd.htm", _
				$hDownload = InetGet("http://kingpin.hambloch.com/mbrowser.php?game=kingpin&username=hypobrowser&v=1.0", _
				$isTmpFilePath_KP, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND )
				ConsoleWrite("getting kp web file"&@CRLF)
			EndIf

			Local $timeCounted = TimerDiff($M_lastRefreshTime)

		   Do
				If $timeCounted > 3000 Then
					InetClose($hDownload)
					ExitLoop
				EndIf
				Sleep(250)
		   Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE )

			InetClose($hDownload)
		Next

		EnableUIButtons()
	EndFunc
	;--> GetServerList File
	;=============================================================================
	#EndRegion


	#Region --> set ServerList per tab
	;=============================================================================
	;--> set ServerList per tab
	Func setServerTabArray()

		Local $aArray, $aArrayKPQ3, $i
		Local $noLoadOffLine = 0
		Local $sString
		local $stringCol[100] ;max collums
		Local $stringColQ2[20]

		$GS_countPlayers = 0

;============> start kp
		If FileExists($isTmpFilePath_KP)=0 Then
			MsgBox($MB_SYSTEMMODAL, "ERROR: Cant Get 'M' Server List", "There was an error downloading the Kingpin Server list." & _
			@CRLF & "Check Your Connection?",0, $HypoGameBrowser )
			ResetRefreshTimmers()
			Return
		EndIf

		$aArray = FileReadToArray($isTmpFilePath_KP)
		If @error Then ;error ask to use offline list
			MsgBox($MB_SYSTEMMODAL, "ERROR: In Server List", "The Server list format is incorrect", 0, $HypoGameBrowser )
			ResetRefreshTimmers()
			Return
		EndIf ;end error geting file

		If IsArray($aArray) Then
			ConsoleWrite("web kp file is array"&@CRLF)
			_GUICtrlListView_DeleteAllItems($ListView1M)
			Local $i1 = 0
			Local $iQ = 0
			Local $fixed, $hostName

			$countPlayers = 0
			$countServers = 0
			For $i = 0 To UBound($aArray) - 1 ; Loop through the array.
				If  StringInStr($aArray[$i], "MOTD:") Then
					GUICtrlSetData($MOTD_Input , String(" " & $aArray[$i]))
				ElseIf StringInStr($aArray[$i],"ERROR <host not found>") Then
					ConsoleWrite("ERROR <host not found>"&@CRLF)
				ElseIf StringInStr($aArray[$i],"Quakematch") Then
					;fix each line string, remove server name and replace consecitive spaces with "|"
					$fixed = StringReplace($aArray[$i], '""', '"(hostname unkown)"') ;replace ""
					$hostName = _StringBetween($fixed, '"', '"' ) ;get server name[0]
					if not @error Then
						$sString = StringReplace($fixed, '"' & $hostName[0] & '"', "") ;
						$sString = StringRegExpReplace($sString, "\h+", "|")
						;$sString = StringReplace($sString, '""', "") ;replace ""
						$sString = StringSplit($sString, '|', $STR_CHRSPLIT)
						$stringColQ2[int($iQ)] = GUICtrlCreateListViewItem($iQ, $ListView3M)
						; _GUICtrlListView_AddItem($ListView1M, $sString[1],-1, $i1)
						_GUICtrlListView_AddSubItem($ListView3M,$iQ, $sString[1]	,1)			;IP
						_GUICtrlListView_AddSubItem($ListView3M,$iQ, $hostName[0] 	,2) 			;server
						_GUICtrlListView_AddSubItem($ListView3M,$iQ, $sString[3]	,5)			;map
						_GUICtrlListView_AddSubItem($ListView3M,$iQ, $sString[6]	,4)			;players
						_GUICtrlListView_AddSubItem($ListView3M,$iQ, $sString[8]	,3)			;ping
						If UpdatePlayersStatusQ2( $sString[6]) Then GUICtrlSetBkColor( $stringColQ2[int($iQ)], $COLOR_YELLOW)
						$iQ += 1 ;increase list by 1
					EndIf ;end error
				Else
					;fix each line string, remove server name and replace consecitive spaces with "|"
					$fixed = StringReplace($aArray[$i], '""', '"(hostname unkown)"') ;replace ""
					$hostName = _StringBetween($fixed, '"', '"' ) ;get server name[0]
					if not @error then
						$sString = StringReplace($fixed, '"' & $hostName[0] & '"', "") ;
						$sString = StringRegExpReplace($sString, "\h+", "|")
						;$sString = StringReplace($sString, '""', "") ;replace ""
						$sString = StringSplit($sString, '|', $STR_CHRSPLIT)
						$stringCol[int($i1)] = GUICtrlCreateListViewItem($i1, $ListView1M)
						; _GUICtrlListView_AddItem($ListView1M, $sString[1],-1, $i1)						;ip
						_GUICtrlListView_AddSubItem($ListView1M,$i1, $sString[1]	,1)						;IP
						_GUICtrlListView_AddSubItem($ListView1M,$i1, $hostName[0] 	,2) 						;server
						_GUICtrlListView_AddSubItem($ListView1M,$i1, $sString[3]	,5)						;map
						_GUICtrlListView_AddSubItem($ListView1M,$i1, $sString[6]	,4)						;players
						_GUICtrlListView_AddSubItem($ListView1M,$i1, $sString[8]	,3)						;ping
						If UpdatePlayersStatus( $sString[6]) Then GUICtrlSetBkColor( $stringCol[int($i1)], $COLOR_YELLOW)
						$i1 += 1 ;increase list by 1
					EndIf
				EndIf
			Next
			;_GUICtrlListView_SimpleSort($ListView1M,False, 1)
			$countServers = $i1
			$countServersQ2 = $iQ
			SetPlayersOnlineString()
			SetPlayersOnlineStringQ2()
			;_GUICtrlListView_SetItemSelected($ListView1M,0, True)
		Else ;end tab num
			ConsoleWrite("!web kp file is not array"&@CRLF)
		EndIf

;============> start kpq3
		If FileExists ($isTmpFilePath_KPQ3)=0 Then
			MsgBox($MB_SYSTEMMODAL, "ERROR: Cant Get 'M' Server List", "There was an error downloading the KingpinQ3 Server list." & _
			@CRLF & "Check Your Connection?",0, $HypoGameBrowser )
			ResetRefreshTimmers()
			Return
		EndIf

		$aArrayKPQ3 = FileReadToArray($isTmpFilePath_KPQ3)
		If @error Then ;error ask to use offline list
					MsgBox($MB_SYSTEMMODAL, "ERROR: Cant Get Server List", "There was an error downloading the KingpinQ3 Server list." & _
					@CRLF & "Check Your Connection?",0, $HypoGameBrowser )
					ResetRefreshTimmers()
					Return
				;EndIf
		EndIf ;end error geting file

		If IsArray($aArrayKPQ3) Then
			ConsoleWrite("web kpq3 file is array"&@CRLF)
			_GUICtrlListView_DeleteAllItems($ListView2M)
			Local $iQ3 = 0
			$countPlayersKPQ3 = 0
			$countServersKPQ3 = 0
			For $i = 0 To UBound($aArrayKPQ3) - 1 ; Loop through the array.
				If  StringInStr($aArrayKPQ3[$i], "MOTD:") Then
;~ 					_GUICtrlStatusBar_SetText($StatusBar1, $aArrayKPQ3[$i],2)
					GUICtrlSetData($MOTD_Input , String(" " & $aArrayKPQ3[$i]))
				ElseIf StringInStr($aArrayKPQ3[$i],"ERROR <host not found>") Then
					;Next
				Else
					;fix each line string, remove server name and replace consecitive spaces with "|"
					$fixed = StringReplace($aArrayKPQ3[$i], '""', '"(hostname unkown)"') ;replace ""
					$hostName = _StringBetween($fixed, '"', '"' ) ;get server name[0]
					;MsgBox( $MB_SYSTEMMODAL, "", $fixed)
					if not @error then
						$sString = StringReplace($fixed, '"' & $hostName[0] & '"', "") ;
						$sString = StringRegExpReplace($sString, "\h+", "|")
						;$sString = StringReplace($sString, '""', "") ;replace ""
						$sString = StringSplit($sString, '|', $STR_CHRSPLIT)

						$stringCol[int($iQ3)] = GUICtrlCreateListViewItem($iQ3, $ListView2M)
						If UpdatePlayersStatusKPQ3( $sString[6]) Then GUICtrlSetBkColor( $stringCol[int($iQ3)], $COLOR_YELLOW)

						_GUICtrlListView_AddSubItem($ListView2M,$iQ3, $sString[1]	,1)		;IP
						_GUICtrlListView_AddSubItem($ListView2M,$iQ3, $hostName[0] 	,2) 	;server
						_GUICtrlListView_AddSubItem($ListView2M,$iQ3, $sString[3]	,5)		;map
						_GUICtrlListView_AddSubItem($ListView2M,$iQ3, $sString[6]	,4)		;players
						_GUICtrlListView_AddSubItem($ListView2M,$iQ3, $sString[8]	,3)		;ping
						$iQ3 += 1 ;increase list by 1
					EndIf
				EndIf
			Next
			$countServersKPQ3 = $iQ3
			SetPlayersOnlineStringKPQ3()
			;_GUICtrlListView_SetItemSelected($ListView2M,0, True)
		Else ;end tab num
			ConsoleWrite("!web kpq3 file is not array"&@CRLF)
		EndIf


;$GS_countPlayers
		If $useSounds = 1 Then
			selectAudoToPlay(0)
		EndIf

	EndFunc
	;=-->set ServerList per tab
	;========================================================
	#EndRegion

	#Region --> Regedit m-links
	;=============================================================================
	;--> Regedit m-links

	GUICtrlSetOnEvent($MLink,"RegeditMlinks")
	Func RegeditMlinks()
			local $arrayRegEdit[16]
			local $getpath
			local $getAppName

			local $exePath = StringReplace(@AutoItExe, "\", "\\")

		If _IsChecked($MLink) Then
			If MsgBox(BitOR($MB_SYSTEMMODAL,  $MB_OKCANCEL), "M-Links", "Enable M-Browser Web Link Support",0, $HypoGameBrowser ) = $IDOK Then
				$arrayRegEdit[0] = string("Windows Registry Editor Version 5.00")
				$arrayRegEdit[1] = string("")
				$arrayRegEdit[2] = string("[HKEY_CLASSES_ROOT\M-Browser]")
				$arrayRegEdit[3] = string('@="URL:M-Browser Protocol"')
				$arrayRegEdit[4] = string('"URL Protocol"=""')
				$arrayRegEdit[5] = string('')
				$arrayRegEdit[6] = string('[HKEY_CLASSES_ROOT\M-Browser\DefaultIcon]') ;@AutoItExe ;@WorkingDir
				$arrayRegEdit[7] = string('@="' & $exePath& ',0"') ;('@="D:\\Kingpin\\Kingpin_M_Browser.exe,0"')
				$arrayRegEdit[8] = string('')
				$arrayRegEdit[9] = string('[HKEY_CLASSES_ROOT\M-Browser\shell]')
				$arrayRegEdit[10] = string('')
				$arrayRegEdit[11] = string('[HKEY_CLASSES_ROOT\m-browser\shell\open]')
				$arrayRegEdit[12] = string('@=""')
				$arrayRegEdit[13] = string('')
				$arrayRegEdit[14] = string('[HKEY_CLASSES_ROOT\M-Browser\shell\open\command]')
				$arrayRegEdit[15] = string('@="\"' & $exePath & '\" \"%1\""') ;('@="\"D:\\Kingpin\\Kingpin_M_Browser.exe\" \"%1\""')

				; Create a file in the users %TEMP% directory.
				;$mLinkFilePathEnable = @TempDir & "\enableMlink.reg"

				; Write array to a file by passing the file name.
				_FileWriteFromArray($mLinkFilePathEnable, $arrayRegEdit, 0)

				; Run the file.
				ShellExecute($mLinkFilePathEnable)

			Else
				GUICtrlSetState ( $MLink, $GUI_UNCHECKED ) ;disable offline radio box
			EndIf
		Else ;reset reg to disable mlinks
			If MsgBox(BitOR($MB_SYSTEMMODAL,  $MB_OKCANCEL), "M-Links", "Disable M-Browser Web Link Support",0, $HypoGameBrowser ) = $IDOK Then
				$arrayRegEdit[0] = string("Windows Registry Editor Version 5.00")
				$arrayRegEdit[1] = string("")
				$arrayRegEdit[2] = string("[-HKEY_CLASSES_ROOT\M-Browser]")

				; Create a file in the users %TEMP% directory.
				;$mLinkFilePathDel = @TempDir & "\disableMLink.reg"

				; Write array to a file by passing the file name.
				_FileWriteFromArray($mLinkFilePathDel, $arrayRegEdit, 0)

				; Run the file.
				ShellExecute($mLinkFilePathDel)
			Else
				GUICtrlSetState ( $MLink, $GUI_CHECKED ) ;enable offline radio box
			EndIf

		EndIf
	ResetRefreshTimmers()

	EndFunc
	;--> Regedit m-links
	;=============================================================================
	#EndRegion


#EndRegion --> M-BROWSER


#Region --> SERVER ARRAYS: RESET

Func resetArray()
	Local $i
; Set all arrays with nul values
	If $tabNum = 1 Or $tabNum > 3  Then
		For $i = 0 To $iMaxSer-1
			$sServerStringArray[$i][0] = "" 	;server string
			$sServerStringArray[$i][1] = ""		;ip
			$sServerStringArray[$i][2] = 0		;port
			$sServerStringArray[$i][3] = 0		;GamePort
			$sServerStringArray[$i][4] = 0		;time/ping
		Next
	ElseIf	$tabNum = 2 Then
		For $i = 0 To $iMaxSer-1
			$sServerStringArrayKPQ3[$i][0] = ""
			$sServerStringArrayKPQ3[$i][1] = ""
			$sServerStringArrayKPQ3[$i][2] = 0
			$sServerStringArrayKPQ3[$i][3] = 0
		Next
	ElseIf	$tabNum = 3 Then
		For $i = 0 To $iMaxSer-1
			$sServerStringArrayQ2[$i][0] = ""
			$sServerStringArrayQ2[$i][1] = ""
			$sServerStringArrayQ2[$i][2] = 0
			$sServerStringArrayQ2[$i][3] = 0
		Next
	EndIf
EndFunc

resetArrayStartup()
Func resetArrayStartup() ; Set all arrays with nul values
	Local $i, $j
	For $i = 0 To $iMaxSer-1
		$sServerStringArray[$i][0] = ""
		$sServerStringArray[$i][1] = ""
		$sServerStringArray[$i][2] = 0
		$sServerStringArray[$i][3] = 0
		$sServerStringArray[$i][4] = 0
		$sServerStringArrayKPQ3[$i][0] = ""
		$sServerStringArrayKPQ3[$i][1] = ""
		$sServerStringArrayKPQ3[$i][2] = 0
		$sServerStringArrayKPQ3[$i][3] = 0
		$sServerStringArrayQ2[$i][0] = ""
		$sServerStringArrayQ2[$i][1] = ""
		$sServerStringArrayQ2[$i][2] = 0
		$sServerStringArrayQ2[$i][3] = 0
	Next
EndFunc


#EndRegion --> END RESET ARRAY

#Region --> SETTINGS: Get Master info

; what master to use from settings
Func SelectedGameMasterAddressKP($retryCount)
	Local $ipPort[3], $tmp
	If _GUICtrlButton_GetCheck($RadioMaster1) Then
		If $retryCount = 0 Then $tmp = GUICtrlRead($InputMaster1)
		If $retryCount = 1 Then $tmp = GUICtrlRead($InputMaster2)
		If $retryCount = 2 Then $tmp = GUICtrlRead($InputMaster3)
	ElseIf _GUICtrlButton_GetCheck($RadioMaster2) Then
		If $retryCount = 0 Then $tmp = GUICtrlRead($InputMaster2)
		If $retryCount = 1 Then $tmp = GUICtrlRead($InputMaster3)
		If $retryCount = 2 Then $tmp = GUICtrlRead($InputMaster1)
	ElseIf _GUICtrlButton_GetCheck($RadioMaster3) Then
		If $retryCount = 0 Then $tmp = GUICtrlRead($InputMaster3)
		If $retryCount = 1 Then $tmp = GUICtrlRead($InputMaster1)
		If $retryCount = 2 Then $tmp = GUICtrlRead($InputMaster2)
	ElseIf _GUICtrlButton_GetCheck($RadioMaster4) Then
		If $retryCount = 0 Then $tmp = GUICtrlRead($InputMaster4)
		If $retryCount > 0 Then Return -1 ;fail when user has selected own master
	EndIf

	If Not StringInStr($tmp,":") Then $tmp = String($tmp & ":28900")
	$ipPort = StringSplit($tmp,":")

	Return $ipPort
EndFunc

; what master to use from settings
Func SelectedGameMasterAddressKPQ3($retryCount)
	Local $ipPort[3], $tmp, $userInputMaster = 0, $tmp2
	;#4 = tcp

	If _GUICtrlButton_GetCheck($RadioMaster1KPQ3) Then
		If $retryCount = 0 Then
			$tmp = GUICtrlRead($InputMaster1KPQ3)
			AutoSelectKPQ3_TCP_UDP(1)
		EndIf
		If $retryCount = 1 Then
			$tmp = GUICtrlRead($InputMaster2KPQ3)
			AutoSelectKPQ3_TCP_UDP(2)
		EndIf
		If $retryCount = 2 Then
			$tmp = GUICtrlRead($InputMaster3KPQ3)
			AutoSelectKPQ3_TCP_UDP(3)
		EndIf
	ElseIf _GUICtrlButton_GetCheck($RadioMaster2KPQ3) Then
		If $retryCount = 0 Then
			$tmp = GUICtrlRead($InputMaster2KPQ3)
			AutoSelectKPQ3_TCP_UDP(2)
		EndIf
		If $retryCount = 1 Then
			$tmp = GUICtrlRead($InputMaster3KPQ3)
			AutoSelectKPQ3_TCP_UDP(3)
		EndIf
		If $retryCount = 2 Then
			$tmp = GUICtrlRead($InputMaster1KPQ3)
			AutoSelectKPQ3_TCP_UDP(1)
		EndIf
	ElseIf _GUICtrlButton_GetCheck($RadioMaster3KPQ3) Then
		If $retryCount = 0 Then
			$tmp = GUICtrlRead($InputMaster3KPQ3)
			AutoSelectKPQ3_TCP_UDP(3)
		EndIf
		If $retryCount = 1 Then
			$tmp = GUICtrlRead($InputMaster1KPQ3)
			AutoSelectKPQ3_TCP_UDP(1)
		EndIf
		If $retryCount = 2 Then
			$tmp = GUICtrlRead($InputMaster2KPQ3)
			AutoSelectKPQ3_TCP_UDP(2)
		EndIf
	ElseIf _GUICtrlButton_GetCheck($RadioMaster4KPQ3) Then
		If $retryCount = 0 Then $tmp = GUICtrlRead($InputMaster4KPQ3)
		If $retryCount > 0 Then Return -1 ;fail when user has selected own master
		$userInputMaster = 1
	EndIf

	If Not StringInStr($tmp,":") Then
		if _IsChecked($RadioMasterTCP_KPQ3) Then
			$tmp = String($tmp & ":28900")
		Else
			$tmp = String($tmp & ":27950")
		EndIf
	ElseIf  $userInputMaster = 1 Then
		$tmp2 = StringSplit($tmp, ":")
		if StringCompare($tmp2[2],"28900")=0 Then
			GUICtrlSetState( $RadioMasterUDP_KPQ3, $GUI_UNCHECKED)
			GUICtrlSetState( $RadioMasterTCP_KPQ3, $GUI_CHECKED)
			AllowUDP_Input(0)
		Else
			GUICtrlSetState( $RadioMasterUDP_KPQ3, $GUI_CHECKED)
			GUICtrlSetState( $RadioMasterTCP_KPQ3, $GUI_UNCHECKED)
			AllowUDP_Input(1)
		EndIf
	EndIf
	ConsoleWrite("ip string= "&$tmp&@CRLF)
	$ipPort = StringSplit($tmp,":")
	Return $ipPort
EndFunc

; what master to use from settings
Func SelectedGameMasterAddressQ2($retryCount)
	Local $ipPort[3], $tmp, $userInputMaster = 0, $tmp2
	If _GUICtrlButton_GetCheck($RadioMaster1Q2) Then
		If $retryCount = 0 Then
			$tmp = GUICtrlRead($InputMaster1Q2)
			AutoSelectQ2_TCP_UDP(1)
		EndIf
		If $retryCount = 1 Then
			$tmp = GUICtrlRead($InputMaster2Q2)
			AutoSelectQ2_TCP_UDP(2)
		EndIf
		If $retryCount = 2 Then
			$tmp = GUICtrlRead($InputMaster3Q2)
			AutoSelectQ2_TCP_UDP(3)
		EndIf
	ElseIf _GUICtrlButton_GetCheck($RadioMaster2Q2) Then
		If $retryCount = 0 Then
			$tmp = GUICtrlRead($InputMaster2Q2)
			AutoSelectQ2_TCP_UDP(2)
		EndIf
		If $retryCount = 1 Then
			$tmp = GUICtrlRead($InputMaster3Q2)
			AutoSelectQ2_TCP_UDP(3)
		EndIf
		If $retryCount = 2 Then
			$tmp = GUICtrlRead($InputMaster1Q2)
			AutoSelectQ2_TCP_UDP(1)
		EndIf
	ElseIf _GUICtrlButton_GetCheck($RadioMaster3Q2) Then
		If $retryCount = 0 Then
			$tmp = GUICtrlRead($InputMaster3Q2)
			AutoSelectQ2_TCP_UDP(3)
		EndIf
		If $retryCount = 1 Then
			$tmp = GUICtrlRead($InputMaster1Q2)
			AutoSelectQ2_TCP_UDP(1)
		EndIf
		If $retryCount = 2 Then
			$tmp = GUICtrlRead($InputMaster2Q2)
			AutoSelectQ2_TCP_UDP(2)
		EndIf
	ElseIf _GUICtrlButton_GetCheck($RadioMaster4Q2) Then
		If $retryCount = 0 Then $tmp = GUICtrlRead($InputMaster4Q2)
		If $retryCount > 0 Then Return -1 ;fail when user has selected own master
		$userInputMaster = 1
	EndIf



	;must be a user input
	If Not StringInStr($tmp,":") Then
		if _IsChecked($RadioMasterTCP_Q2) Then
			$tmp = String($tmp & ":28900")
			ConsoleWrite("master= 28900" &$ipPort[1]&@CRLF)
		Else
			$tmp = String($tmp & ":27900")
			ConsoleWrite("master= 27900"&@CRLF)
		EndIf
	ElseIf  $userInputMaster =1 Then ;sellect tcp auto for 28900
		$tmp2 = StringSplit($tmp, ":")
		if StringCompare($tmp2[2], "28900")=0 Then
			GUICtrlSetState( $RadioMasterUDP_Q2, $GUI_UNCHECKED)
			GUICtrlSetState( $RadioMasterTCP_Q2, $GUI_CHECKED)
			ConsoleWrite("master= TCP"&@CRLF)
		Else
			GUICtrlSetState( $RadioMasterUDP_Q2, $GUI_CHECKED)
			GUICtrlSetState( $RadioMasterTCP_Q2, $GUI_UNCHECKED)
			ConsoleWrite("master= UDP"&@CRLF)
		EndIf

	EndIf

	$ipPort = StringSplit($tmp,":")
	Return $ipPort
EndFunc

;radio button, selected master
Func SelectedGameMasterKPNum()
	If _GUICtrlButton_GetCheck($RadioMaster1) Then
		Return 1
	ElseIf _GUICtrlButton_GetCheck($RadioMaster2) Then
		Return 2
	ElseIf _GUICtrlButton_GetCheck($RadioMaster3) Then
		Return 3
	ElseIf _GUICtrlButton_GetCheck($RadioMaster4) Then
		Return 4
	EndIf
EndFunc
;radio button, selected master
Func SelectedGameMasterKPQ3Num()
	If _GUICtrlButton_GetCheck($RadioMaster1KPQ3) Then
		Return 1
	ElseIf _GUICtrlButton_GetCheck($RadioMaster2KPQ3) Then
		Return 2
	ElseIf _GUICtrlButton_GetCheck($RadioMaster3KPQ3) Then
		Return 3
	ElseIf _GUICtrlButton_GetCheck($RadioMaster4KPQ3) Then
		Return 4
	EndIf
EndFunc
;radio button, selected master
Func SelectedGameMasterQ2Num()
	If _GUICtrlButton_GetCheck($RadioMaster1Q2) Then
		Return 1
	ElseIf _GUICtrlButton_GetCheck($RadioMaster2Q2) Then
		Return 2
	ElseIf _GUICtrlButton_GetCheck($RadioMaster3Q2) Then
		Return 3
	ElseIf _GUICtrlButton_GetCheck($RadioMaster4Q2) Then
		Return 4
	EndIf
EndFunc
;~ Func SelectedGameMasterQ2Web()
;~ 	If _GUICtrlButton_GetCheck($RadioMasterHTTP_Q2) Then
;~ 		Return "Yes"
;~ 	Else
;~ 		Return "No"
;~ 	EndIf
;~ EndFunc

Func SelectUDPMasterKPQ3()
	If SelectedGameMasterKPQ3Num() = 4 And _IsChecked($RadioMasterUDP_KPQ3) Then
		Return "Yes"
	Else
		Return "No"
	EndIf
EndFunc
#EndRegion

#Region --> PROTOCOL: Relted settings
Func sendStatusMessageType()
	If $tabNum = 1 Or $tabNum > 3 And Not ($tabNum = 6) Then
		Return String('\status\') ; gamespy query protocol
	ElseIf $tabNum = 2 Then
		Return String('ÿÿÿÿgetstatus' & @LF) ; getinfo
	ElseIf $tabNum = 3 Then
		Return String('ÿÿÿÿstatus' & @LF)
	ElseIf 	$tabNum = 6 Then
		If $iMGameType =1 Then
			Return String('ÿÿÿÿstatus') ;quake query protocol
		ElseIf $iMGameType = 2 Then
			Return String('ÿÿÿÿgetstatus' & @LF)
		ElseIf $iMGameType = 3 Then
			Return String('ÿÿÿÿstatus' & @LF)
		EndIf
	EndIf
EndFunc

#EndRegion

#Region --> LISTVIEW: GET UI SELECTIONS
;=============
;-->Set tabNum
Func SelectedTabNum()
	If _GUICtrlTab_GetItemState($tabGroupGames, 0) =$TCIS_BUTTONPRESSED Then
		$tabNum = 1
		Return 1
	ElseIf _GUICtrlTab_GetItemState($tabGroupGames, 1) =$TCIS_BUTTONPRESSED Then
		$tabNum = 2
		Return 2
	ElseIf _GUICtrlTab_GetItemState($tabGroupGames, 2) =$TCIS_BUTTONPRESSED Then
		$tabNum = 3
		Return 3
	ElseIf _GUICtrlTab_GetItemState($tabGroupGames, 3) =$TCIS_BUTTONPRESSED Then
		$tabNum = 4
		Return 4
	ElseIf _GUICtrlTab_GetItemState($tabGroupGames, 4) =$TCIS_BUTTONPRESSED Then
		$tabNum = 5
		Return 5
	ElseIf _GUICtrlTab_GetItemState($tabGroupGames, 5) =$TCIS_BUTTONPRESSED Then
		$tabNum = 6
		Return 6
	Else
		$tabNum = 1
		Return 1
	EndIf
EndFunc

Func GetTabSelectedStringNumber();get listview #0 string (array number)
	Local $serSelNum, $listSelNum
	If $tabNum = 1 Then
		If Not _GUICtrlListView_GetSelectedCount($ListView1KP) Then Return 0
		$listSelNum = _GUICtrlListView_GetSelectionMark($ListView1KP)
		$serSelNum = _GUICtrlListView_GetItemText($ListView1KP,$listSelNum,0)
	ElseIf $tabNum = 2 Then
		If Not _GUICtrlListView_GetSelectedCount($ListView1KPQ3) Then Return 0
		$listSelNum = _GUICtrlListView_GetSelectionMark($ListView1KPQ3)
		$serSelNum = _GUICtrlListView_GetItemText($ListView1KPQ3,$listSelNum,0)
	ElseIf $tabNum = 3 Then
		If Not _GUICtrlListView_GetSelectedCount($ListView1Q2) Then Return 0
		$listSelNum = _GUICtrlListView_GetSelectionMark($ListView1Q2)
		$serSelNum = _GUICtrlListView_GetItemText($ListView1Q2,$listSelNum,0)
	EndIf
	Return $serSelNum
EndFunc

Func GetTabSelectedArrayStringIP() ;get listview #1 string (ip/port)
	Local $tmp, $serSelNum
	If $tabNum = 1 Then
		If Not _GUICtrlListView_GetSelectedCount($ListView1KP) Then Return ""
		$tmp = _GUICtrlListView_GetSelectionMark($ListView1KP)
		$serSelNum = _GUICtrlListView_GetItemText($ListView1KP,$tmp,1)
	ElseIf $tabNum = 2 Then
		If Not _GUICtrlListView_GetSelectedCount($ListView1KPQ3) Then Return ""
		$tmp = _GUICtrlListView_GetSelectionMark($ListView1KPQ3)
		$serSelNum = _GUICtrlListView_GetItemText($ListView1KPQ3,$tmp,1)
	ElseIf $tabNum = 3 Then
		If Not _GUICtrlListView_GetSelectedCount($ListView1Q2) Then Return ""
		$tmp = _GUICtrlListView_GetSelectionMark($ListView1Q2)
		$serSelNum = _GUICtrlListView_GetItemText($ListView1Q2,$tmp,1)
	ElseIf	$tabNum = 6 Then
		If $iMGameType = 1 Then
			If Not _GUICtrlListView_GetSelectedCount($ListView1M) Then Return ""
			$tmp = _GUICtrlListView_GetSelectionMark($ListView1M)
			$serSelNum = _GUICtrlListView_GetItemText($ListView1M,$tmp,1)
		ElseIf $iMGameType = 2 Then
			If Not _GUICtrlListView_GetSelectedCount($ListView2M) Then Return ""
			$tmp = _GUICtrlListView_GetSelectionMark($ListView2M)
			$serSelNum = _GUICtrlListView_GetItemText($ListView2M,$tmp,1)
		ElseIf $iMGameType = 3 Then
			If Not _GUICtrlListView_GetSelectedCount($ListView3M) Then Return ""
			$tmp = _GUICtrlListView_GetSelectionMark($ListView3M)
			$serSelNum = _GUICtrlListView_GetItemText($ListView3M,$tmp,1)
		EndIf
	EndIf

	Return $serSelNum
EndFunc

Func GetServerCountInArray() ;total displayed servers (in memory)
	Local $countServ =0

	If $tabNum = 1 Or $tabNum > 3 Then
		For $i = 0 To $iMaxSer -1
			;[1]=ip exists
			If Not $sServerStringArray[$i][1] = "" Then
				$countServ +=1
			Else
				ExitLoop
			EndIf
		Next
	ElseIf $tabNum = 2 Then
		For $i = 0 To $iMaxSer -1
			If Not $sServerStringArrayKPQ3[$i][1] = "" Then
				$countServ +=1
			Else
				ExitLoop
			EndIf
		Next
	ElseIf $tabNum = 3 Then
		For $i = 0 To $iMaxSer -1
			If Not $sServerStringArrayQ2[$i][1] = "" Then
				$countServ +=1
			Else
				ExitLoop
			EndIf
		Next
	EndIf
	Return $countServ
EndFunc

Func ListviewResetSortOrder() ;sort servers. using previous stored setting
	If $tabNum = 1 or $tabNum >3 Then
		If $iLastListviewSortStatus = -1 Then Return
		_GUICtrlListView_SortItems($ListView1KP, $iLastListviewSortStatus)
		_GUICtrlListView_SortItems($ListView1KP, $iLastListviewSortStatus)
	ElseIf $tabNum = 2 Then
		If $iLastListviewSortStatusKPQ3 = -1 Then Return
		_GUICtrlListView_SortItems($ListView1KPQ3, $iLastListviewSortStatusKPQ3)
		_GUICtrlListView_SortItems($ListView1KPQ3, $iLastListviewSortStatusKPQ3)
	ElseIf  $tabNum = 3 Then
		If $iLastListviewSortStatusQ2 = -1 Then Return
		_GUICtrlListView_SortItems($ListView1Q2, $iLastListviewSortStatusQ2)
		_GUICtrlListView_SortItems($ListView1Q2, $iLastListviewSortStatusQ2)
	EndIf
EndFunc

Func RulesResetSortOrder();sort server rules (window3)
	If $tabNum = 1 or $tabNum >3 Then
		If $iLastRulesSortStatus = -1 Then Return
		_GUICtrlListView_SortItems($ListView3, $iLastRulesSortStatus)
		_GUICtrlListView_SortItems($ListView3, $iLastRulesSortStatus)
	ElseIf $tabNum = 2 Then
		If $iLastRulesSortStatusKPQ3 = -1 Then Return
		_GUICtrlListView_SortItems($ListView3KPQ3, $iLastRulesSortStatusKPQ3)
		_GUICtrlListView_SortItems($ListView3KPQ3, $iLastRulesSortStatusKPQ3)
	ElseIf  $tabNum = 3 Then
		If $iLastRulesSortStatusQ2 = -1 Then Return
		_GUICtrlListView_SortItems($ListView3Q2, $iLastRulesSortStatusQ2)
		_GUICtrlListView_SortItems($ListView3Q2, $iLastRulesSortStatusQ2)
	EndIf
EndFunc

Func ChangedListview_NowFillServerStrings() ;if list selection changed. fill server rules
	Local $ListViewA = ServerArray1ToFill()
	Local $listSelNum = _GUICtrlListView_GetSelectionMark($ListViewA)
	If $tabNum =1 Then FillSelectedServerStrings(1, $listSelNum) ;<tabnum> | <selected array num>
	If $tabNum =2 Then FillSelectedServerStrings(2, $listSelNum)
	If $tabNum =3 Then FillSelectedServerStrings(3, $listSelNum)

EndFunc

#EndRegion END LISTVIEW: GET UI SELECTIONS

#Region --> TCP GAMESPY CHALLANGE
Func gsvalfunc($reg_)
ConsoleWrite(">bitshift=" &$reg_& @CRLF)
    if($reg_ < 26) then return($reg_ + Asc('A'));
    if($reg_ < 52) then return($reg_ + Asc('G'));
    if($reg_ < 62) then return($reg_ - 4);
    if($reg_ == 62) then return(Asc('+'));
    if($reg_ == 63) then return(Asc('/'));
    return(0);
EndFunc

Func getStringKeyValue($sIn, $sTest)
	if StringInStr($sIn, "\") Then
		Local $aTmp= StringSplit($sIn, "\")
		For $i1=1 to $aTmp[0]
			if StringCompare($aTmp[$i1],$sTest) ==0 Then
				;make sure string exists
				If $i1+1 <= $aTmp[0] Then
					Return $aTmp[$i1+1]
				Else
					Return ("") ;error
				EndIf
			EndIf
		Next
	EndIf
	Return ("") ;error
EndFunc

Func GameSpyChallenge($sInput, $sGameKey)
	Local $i1,$sOut,$keysz
	;Local $aRcv= StringSplit($sInput, "\")
	Local $aGameKey=  StringSplit($sGameKey, "", 2) ;kingpin gslite=mgNUaC

	If Not @error Then
		Local $sChallenge = getStringKeyValue($sInput, "secure")

		ConsoleWrite ("str chl="&$sChallenge&@CRLF)
		ConsoleWrite ("str len="& StringLen($sChallenge)&@CRLF)

		;this should allways be 6 chars..
		If $sChallenge <> "" And StringLen($sChallenge) == 6 Then
			Local $aSrc= StringSplit($sChallenge, "", 2)
			Local $enctmp[256],$a_, $b_,$x_, $y_,$z_,$p_[89], $tmp_[66], $size_=6, $iCnt=0

			;==>1
			$size_= 6 	;strlen(src);StringLen($size_)
			$keysz = 6 ;strlen(key)	;StringLen($keysz)
			;==>2
			for $i1= 0 to 255	; 256
				$enctmp[$i1] = $i1;
			Next
			;==>3
			$a_= 0
			for $i1= 0 to 255	; 256
				$a_ += $enctmp[$i1] + Asc($aGameKey[mod($i1, $keysz)])
				$a_= Mod($a_, 256)
				$x_ = $enctmp[$a_];
				$enctmp[$a_] = $enctmp[$i1];
				$enctmp[$i1] = $x_;
			Next
			;==>4
			$a_= 0
		    $b_= 0;
			for $i1 = 0 to UBound($aSrc)-1; Asc($aSrc[$i1]);todo ha??? ubound
				$a_ += Asc($aSrc[$i1]) + 1;
				$a_= Mod($a_, 256)
				$x_ = $enctmp[$a_];
				$b_ += $x_;
				$b_=Mod($b_,256)
				$y_ = $enctmp[$b_];
				$enctmp[$b_] = $x_;
				$enctmp[$a_] = $y_;
				$tmp_[$i1] = Mod(BitXOR(Asc($aSrc[$i1]), $enctmp[ BitAND(($x_ + $y_),0xff) ]),256);mod just incase
				ConsoleWrite("+out1="&$tmp_[$i1]&@CRLF)
			next

			;==>5
			ConsoleWrite(">$i1="&$i1&@CRLF)
			for $size_ = $i1 to Mod($size_, 3) ; size++)
				$tmp_[$size_] = 0;
			next

			;==>6
			;$p_="" ;= $sOut;

			for $i1 = 0 to  $size_-1 step 3
				$x_ = $tmp_[$i1];
				$y_ = $tmp_[$i1 + 1];
				$z_ = $tmp_[$i1 + 2];
				ConsoleWrite("!x="&$x_&" y="&$y_& " z="&$z_&@CRLF)
				ConsoleWrite("!x1="& BitAND($x_,3)&" y="& BitShift( BitAND($x_,3), -4)& " z="&BitShift($y_, 4)&@CRLF)
				$p_[0+$iCnt] = Chr(gsvalfunc(		BitShift($x_, 2)));
				$p_[1+$iCnt] = Chr(gsvalfunc(BitOR (BitShift( BitAND($x_,3), -4), BitShift($y_, 4))));
				$p_[2+$iCnt] = Chr(gsvalfunc(BitOR (BitShift( BitAND($y_,15), -2), BitShift($z_, 6))));
				$p_[3+$iCnt] = Chr(gsvalfunc(BitAND($z_,63)));
				$iCnt += 4
			next

			$sOut=""
			for $i1 = 0 to UBound($p_)-1
				If $p_[$i1] <> "" Then
					$sOut= string($sOut & $p_[$i1])
				Else
					ExitLoop
				EndIf
			Next
			;*$p_ = 0;LO/WUC4c
			;wwke+FSs
			;TQ87uZfr

			ConsoleWrite("!out challenge2=" &@CRLF&$p_[0]&@CRLF&$p_[1]&@CRLF&$p_[2]&@CRLF)
		Else
			$sOut ="ERROR___"
		EndIf
	EndIf
	ConsoleWrite("!out challenge1=" &$sOut&@CRLF)

	Return $sOut

EndFunc

#EndRegion

#Region --> TCP GET LIST FROM MASTER
Func GetListFromMasterTCP($sIPAddressDNS, $iPort)
	;resetArray() ;zero serverArray

	Local $tcpSocket,$dataRecv,$sIPAddress
	Local $sGameKey=  "mgNUaC" ;gspylite="mgNUaC" ;kingpin="QFWxY2" "Quake2"="rtW0xg"
	Local $gameSpyString="" ; = "\gamename\gspylite\gamever\01\location\0\validate\LO/WUC4c\final\\queryid\1.1"
	Local 				$gameSpyString2 = "\list\\gamename\kingpin"
	If $tabNum =2 Then 	$gameSpyString2 = "\list\\gamename\kingpinQ3"
	If $tabNum =3 Then 	$gameSpyString2 = "\list\\gamename\Quake2"



	$sIPAddress = TCPNameToIP($sIPAddressDNS)

	;try connect a few times then give up
	For $i3 =0 to 3
		$tcpSocket = TCPConnect($sIPAddress, $iPort)
		If $tcpSocket < 0 or @error Then
			If $i3 < 3 Then
				ConsoleWrite("retry connect to master" &@CRLF)
				TCPCloseSocket($tcpSocket)
				Sleep(1000)
				ContinueLoop
			Else
				ConsoleWrite("error TCP 1" &  $tcpSocket & "@err=" &@error&@CRLF)
				TCPCloseSocket($tcpSocket)
				Return -1
			EndIf
		EndIf
		ExitLoop ;connected ok
	Next

	;TCP connected
	$dataRecv = TCPRecv($tcpSocket, 1500,0) 	;recieve= 	\basic\\secure\TXKOAT
	If @error Or $dataRecv = "" Then
		ConsoleWrite("error TCP 3" &@CRLF)
		TCPCloseSocket($tcpSocket)
		Return -1
	EndIf

	;$dataRecv = "\basic\\secure\TXKOAT"
	ConsoleWrite ("tcp data recieved= "& $dataRecv& @CRLF)

	If StringInStr($dataRecv, "\secure\") Then ;"TXKOAT
		Local $sChall_resp = GameSpyChallenge($dataRecv, $sGameKey)

		$gameSpyString = string("\gamename\gspylite\location\0\validate\"&$sChall_resp& "\final\")

		TCPSend($tcpSocket, $gameSpyString) 	;send= 		\gamename\gspylite\gamever\01\location\0\validate\LO/WUC4c\final\\queryid\1.1
		ConsoleWrite("TCP Send1= " &$gameSpyString& @CRLF)
		If @error Then
			ConsoleWrite("error TCP 2" &@CRLF)
			TCPCloseSocket($tcpSocket)
			Return -1
		EndIf


		TCPSend($tcpSocket, $gameSpyString2) 	;send= 		\list\\gamename\kingpin
		consoleWrite("TCP Send2= " &$gameSpyString2& @CRLF)
		If @error Then
			ConsoleWrite("error TCP 2" &@CRLF)
			TCPCloseSocket($tcpSocket)
			Return -1
		EndIf

		$dataRecv = TCPRecv($tcpSocket, 2500,0)	;recieve= 	\ip\10.10.10:31510\ip\10.10.10:31520
		If @error Or $dataRecv = "" Then
			ConsoleWrite("error TCP 4" &@CRLF)
			TCPCloseSocket($tcpSocket)
			Return -1
		EndIf
		ConsoleWrite("TCP recieve string"& "0 "& $dataRecv &" "&@CRLF)

		For $i4 = 0 To 5 ;recieve upto 5 more lists, if long
			If Not StringInStr($dataRecv,"\final\") Then
				Local $dataRecv2 = TCPRecv($tcpSocket, 2500,0)
				If Not @error Or Not $dataRecv2 = "" Then
					$dataRecv = String($dataRecv & $dataRecv2)
					ConsoleWrite("TCP recieve string"& $i4+1 &" "& $dataRecv2 &" "&@CRLF)
					If StringInStr($dataRecv2,"\final\") Then ExitLoop
				EndIf
			Else
				ExitLoop
			EndIf
		Next
	EndIf
	;ConsoleWrite ("data recieved.."& $abc& " " & $dataRecv& @CRLF)
	ConsoleWrite ("data recieved.."& $dataRecv& @CRLF)
;WEnd ;hypo test master


 TCPCloseSocket($tcpSocket)


 	If Not $dataRecv = "" Then

		Local $countIP = StringSplit($dataRecv, "ip\", 1)
		if Not @error Then ConsoleWrite("num servers recieved== " &$countIP[0]-1&@CRLF)

		ConsoleWrite("data recievedTCP1=" & $dataRecv&@CRLF)
		Return $dataRecv
	Else
		Return -1
	EndIf
EndFunc
#EndRegion --> TCP GET LIST FROM MASTER

#Region --> UDP GET LIST FROM MASTER
Func GetListFromMasterUDP($sIPAddressDNS, $iPort)
	;resetArray() ;zero serverArray

	If @error Then ConsoleWrite("error startup")
	Local $tcpSocket
	Local $dataRecv
	Local $gameSpyString = ""
										  ;getservers KingpinQ3-1 75 full empty
	Local $gameSpyStringKPQ3 = string("ÿÿÿÿgetservers KingpinQ3-1 "& GUICtrlRead($InputKPQ3_proto) &" full empty"& Chr(0))
	Local $gameSpyStringQ2 = String("query"& Chr(10)& Chr(0)) ; query..
	Local $sIPAddress

	Local $iErrorX, $tmpStr, $output = "-1", $i, $ipLen = 0


	If $tabNum =2 Then $gameSpyString = $gameSpyStringKPQ3
	If $tabNum =3 Then $gameSpyString = $gameSpyStringQ2



	$sIPAddress = TCPNameToIP($sIPAddressDNS)

	$iErrorX = _UDPSendTo($sIPAddress, $iPort, $gameSpyString, $hSocketMasterUDP)
	if @error Then
		ConsoleWrite("UDP Send \status\ sock error =  " & $iErrorX & " error" & @CRLF)
		;ConsoleWrite("server sent num= " &$iIP&@CRLF)
	Else

		$serverRefreshTimer = TimerInit()
		Do
			$dataRecv = _UDPRecvFrom($hSocketMasterUDP,2048,0)
;~ 			If serverRefreshButtonState() Then
			If TimerDiff($serverRefreshTimer) > 3000 Then
				ConsoleWrite("button state up, timeout 3seconds"&@CRLF)
				ExitLoop(1) ;stop do
			EndIf
							;Sleep(10)
		Until IsArray($dataRecv)



		if $dataRecv = -1 Then
			ConsoleWrite("!!!Packet ERROR = " &$dataRecv&@CRLF)
			Return -1
		Else
			;resetArray() ;zero serverArray
			ConsoleWrite("!UDP zero array"&@CRLF)
			ConsoleWrite("PacketData= " &String($dataRecv[0])&@CRLF)

			;start the string
			$output = ""
			;////////////////// KPQ3 ///////////////////// ToDo: ipv6
			if StringInStr($dataRecv[0], "getserversResponse") Then
				ConsoleWrite("getserversResponse"&@CRLF)
				$dataRecv[0] = StringTrimLeft($dataRecv[0], StringLen("ÿÿÿÿgetserversResponse\")) ; kpq3
				$tmpStr	= StringSplit($dataRecv[0], "")
				If Not @error Then
					For $i = 1 To $tmpStr[0]
						$ipLen += 1
						If StringCompare($tmpStr[$i],"\")=0 Then;==> address end char
							if StringCompare($tmpStr[$i+1],"E")=0 And StringCompare($tmpStr[$i+2], "O")=0 And StringCompare($tmpStr[$i+3], "T")=0  Then ; \EOT
								$output = string( $output & "\final\")
								;ConsoleWrite(@CRLF)
								ExitLoop ;done!!
							EndIf
							$ipLen = 0
							ContinueLoop
						EndIf

						If $ipLen = 1 Then
							$output = string( $output & "\ip\")
							$output = string( $output & Asc($tmpStr[$i]) ) ; add every character
							$output = string( $output & ".")
						ElseIf $ipLen < 4 Then
							$output = string( $output & Asc($tmpStr[$i]) ) ; add every character
							$output = string( $output & ".")
						ElseIf $ipLen = 4 Then
							$output = string( $output & Asc($tmpStr[$i]) ) ; add every character
							$output = string( $output & ":")
						ElseIf $ipLen = 5 Then;==> port
							Local $tmpp1, $tmpp2, $tmp3
							$tmpp1 = BitShift(Asc($tmpStr[$i]), -8)
							$tmpp1 += Asc($tmpStr[$i+1])
							$output = string( $output & $tmpp1)
						ElseIf $ipLen = 6 Then
							$ipLen = 0
						EndIf
					Next
				Else
					Return -1
				EndIf
			;///////////////// QUAKE2 ////////////////////////
			ElseIf StringInStr($dataRecv[0], "servers ") Then
				$dataRecv[0] = StringTrimLeft($dataRecv[0], StringLen("ÿÿÿÿservers ")) ; Quake2
				$tmpStr	= StringSplit($dataRecv[0], "")
				If Not @error Then
					For $i = 1 To $tmpStr[0]
						$ipLen += 1
						; quake2
						If  $i = $tmpStr[0] Then
							$output = string( $output & "\final\")
							ConsoleWrite("\final\ "&String(Asc($tmpStr[$i]))&@CRLF)
							ExitLoop ;done!!
						EndIf

						If $ipLen = 1 Then
							$output = string( $output & "\ip\")
							$output = string( $output & Asc($tmpStr[$i]) ) ; add every character
							$output = string( $output & ".")
						ElseIf $ipLen < 4 Then
							$output = string( $output & Asc($tmpStr[$i]) ) ; add every character
							$output = string( $output & ".")
						ElseIf $ipLen = 4 Then
							$output = string( $output & Asc($tmpStr[$i]) ) ; add every character
							$output = string( $output & ":")
						ElseIf $ipLen = 5 Then;==> port
							Local $tmpp1, $tmpp2
							$tmpp1 = BitShift(Asc($tmpStr[$i]), -8)
							$tmpp1 += Asc($tmpStr[$i+1])
							$output = string( $output & $tmpp1)
						ElseIf $ipLen = 6 Then
							$ipLen = 0
						EndIf

					Next
				Else
					Return -1
				EndIf
			EndIf
			;//////////////////////////////////////////

		EndIf
	EndIf

 	If StringCompare($output,"-1")=0 Then
		Return -1
	Else

		Local $countIP = StringSplit($output, "\ip\", 1)
		if Not @error Then ConsoleWrite("num servers recieved== " &$countIP[0]-1&@CRLF)

		ConsoleWrite("PacketData Processed= " &$output&@CRLF)
		Return $output
	EndIf

EndFunc

#EndRegion --> UDP GET LIST FROM MASTER

#Region --> HTTP GET LIST FROM WEB
Func GetListFromHTTP()
	Local $i, $hDownload, $timeCounted, $aArray
	Local $sOutput=""
	;DisableUIButtons()

	$GS_lastRefreshTime = TimerInit() ;set a new time for auto refresh
	FileDelete($isTmpFilePath_Q2Web)
	$hDownload = InetGet("http://q2servers.com/?mod=&raw=1&inc=1",	$isTmpFilePath_Q2Web, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND )

	$timeCounted = TimerDiff($GS_lastRefreshTime)

	Do
		If $timeCounted > 3000 Then
			InetClose($hDownload)
			;EnableUIButtons()
			Return -1
		EndIf
		Sleep(250)
	Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE )
	InetClose($hDownload)


;process file

	$aArray = FileReadToArray($isTmpFilePath_Q2Web)
	If @error Then
		MsgBox($MB_SYSTEMMODAL, "ERROR: Cant Get List", "There was an error downloading server list from Q2Servers.com." & _
		@CRLF & "Check Your Connection?",0, $HypoGameBrowser )
		ResetRefreshTimmers() ;reset timers. msg box issue
		;EnableUIButtons()
		Return -1
	EndIf

	For $i = 0 To UBound($aArray)-1
		If $i = int($iMaxSer -1) Then ExitLoop
		$sOutput = String($sOutput&"\ip\"& $aArray[$i])

	Next

	;add final string
	$sOutput = String($sOutput&"\final\")
	ConsoleWrite("q2Servers recieved string= " &$sOutput& @CRLF)

	ResetRefreshTimmers() ;reset timers. msg box issue
	;EnableUIButtons()
	Return $sOutput
EndFunc
#EndRegion HTTP GET LIST FROM WEB

#Region --> TCP/UDP 'REFRESH' LIST FROM MASTER ..FILL ARRAY
;========================================================
; --> GetMasterServerList TCP/UDP
Func GetMasterServerList($isAutoRefresh, $tab)
	Local $ipPort[3] , $serverMessage, $i, $splitIP, $ipArray, $iPortx
	Local	$j =0

	DisableUIButtons()
	$GS_countPlayers = 0
	$GS_lastRefreshTime = TimerInit(); reset refresh time

	$isGettingServers = 1
	$iServerCountTotal = 0 ;get # servers to use later to stop refresh

;queery master for ip list, rotate to next master if failed
	For $i= 0 to 2
		If $isAutoRefresh = True Then
			If $tab = 1 Then
				$ipPort =  SelectedGameMasterAddressKP($i)
				$iLastListviewSortStatus = GUICtrlGetState($ListView1KP); set global sort for reset
			ElseIf $tab = 2 Then
				$ipPort =  SelectedGameMasterAddressKPQ3($i)
				$iLastListviewSortStatusKPQ3 = GUICtrlGetState($ListView1KPQ3); set global sort for reset
			ElseIf $tab = 3 Then
				$ipPort =  SelectedGameMasterAddressQ2($i)
				$iLastListviewSortStatusQ2 = GUICtrlGetState($ListView1Q2); set global sort for reset
			EndIf
		Else
			SelectedTabNum() ;recalled with button press
			If $tabNum = 1 Or $tabNum > 3 Then
				$ipPort =  SelectedGameMasterAddressKP($i)
				$iLastListviewSortStatus = GUICtrlGetState($ListView1KP); set global sort for reset
			ElseIf $tabNum = 2 Then
				$ipPort =  SelectedGameMasterAddressKPQ3($i)
				$iLastListviewSortStatusKPQ3 = GUICtrlGetState($ListView1KPQ3); set global sort for reset
			ElseIf $tabNum = 3 Then
				$ipPort =  SelectedGameMasterAddressQ2($i)
				$iLastListviewSortStatusQ2 = GUICtrlGetState($ListView1Q2); set global sort for reset
			EndIf
		EndIf

		If $i = 1 Then
			$tmpStatusbarString = GUICtrlRead($MOTD_Input)
			GUICtrlSetData($MOTD_Input , " SERVER NOT RESPONDING. Trying another Master")
			GUICtrlSetColor($MOTD_Input, $COLOR_RED)
			$statusBarChanged = True
		EndIf



		If $ipPort = -1 Then
			$serverMessage = -1
			ExitLoop
		EndIf


		If ($tabNum = 2) And _IsChecked($RadioMasterUDP_KPQ3) Then
			_BIND_MASTER_SOCKET()
			$serverMessage = GetListFromMasterUDP($ipPort[1], $ipPort[2])
			_UDPCloseSocket($hSocketMasterUDP)
		ElseIf ($tabNum = 3) And _IsChecked($RadioMasterHTTP_Q2) Then
			$serverMessage = GetListFromHTTP() ;q2
			ExitLoop
		ElseIf	($tabNum = 3) And _IsChecked($RadioMasterUDP_Q2) Then
			_BIND_MASTER_SOCKET()
			$serverMessage = GetListFromMasterUDP($ipPort[1], $ipPort[2]) ;quake2 master, using udp
			_UDPCloseSocket($hSocketMasterUDP)
		Else
			$serverMessage = GetListFromMasterTCP($ipPort[1], $ipPort[2])
		EndIf

		If Not ($serverMessage = -1) Then ExitLoop
	Next

	;RESET: udp/tcp selection
	If $tabNum = 2 Then
		SelectedGameMasterAddressKPQ3(0)
	ElseIf $tabNum = 3 Then
		SelectedGameMasterAddressQ2(0)
	EndIf

	_BIND_SERVER_SOCKET()
	If $hSocketServerUDP > 0 Then _SetPacketBufferSize($hSocketServerUDP, 25600)

;===================
; send getinfo to all servers recieved from master
	If Not ($serverMessage = -1) Then
		$serverMessage = StringTrimLeft($serverMessage, StringLen("\ip\")); remove first "\ip\"
		$serverMessage = StringTrimRight($serverMessage, StringLen("\final\")); remove end "\final\"
		Local $isSingleRefresh = False

		$ipArray =	StringSplit($serverMessage, "\ip\", $STR_ENTIRESPLIT + $STR_NOCOUNT)
		If @error Then
			If StringInStr($serverMessage, ":") Then
				$ipArray[0] = $serverMessage ;only 1 server, cant split strinng
				$isSingleRefresh = True
			Else
				ConsoleWrite("error spliting '\ip\' " & @CRLF)
				_UDPCloseSocket($hSocketServerUDP)
				MsgBox($MB_SYSTEMMODAL, "Master Server List","0 Servers in list from Master" &@CRLF& _
										"Try Another 'Master' in Setup" &@CRLF&@CRLF& _
										"If they all fail, try the 'Offline' button",0, $HypoGameBrowser )
				$isGettingServers = -1
				serverRefreshButtonState()
				ResetRefreshTimmers()
				Return
			EndIf
		EndIf

		If $isSingleRefresh = True Then
			$iServerCountTotal = 1
		Else
			$iServerCountTotal = UBound($ipArray)
		EndIf


		resetArray() ; remove all servers from $sServerStringArray

		Local $ListViewA = ServerArray1ToFill()
		_GUICtrlListView_DeleteAllItems($ListViewA)

		; fill server strings with fresh servers and as blank info
		For $i = 0 To UBound($ipArray) -1
			Local $sIP_Port
			$splitIP = StringSplit($ipArray[$i],":", $STR_NOCOUNT)
			If Not @error Then
				If $tabNum =1 Or $tabNum >3 And Not ($tabNum =6) Then
					$iPortx = int($splitIP[1])+ 10 ;todo: this should use \\hostport\\.
				Else
					$iPortx = int($splitIP[1])
				EndIf
				$sIP_Port = String($splitIP[0]&":"& $iPortx)
			Else
				ConsoleWrite("!error invalid ip from master" & @CRLF)
				ExitLoop
			EndIf


			_GUICtrlListView_AddItem($ListViewA, $i, -1)
			_GUICtrlListView_AddSubItem($ListViewA, $i, $sIP_Port,		1,-1) ;hypo ToDo: should this displays +10 port, not GS port?
			_GUICtrlListView_AddSubItem($ListViewA, $i, "???",			2,-1)
			_GUICtrlListView_AddSubItem($ListViewA, $i, "999",			3,-1)
			_GUICtrlListView_AddSubItem($ListViewA, $i, "0/0",			4,-1)
			;$iServerCountTotal += 1 ;hypo count total earlyer

			;==> fill internal ip array for each server
			;$splitIP = StringSplit($ipArray[$i],":", $STR_NOCOUNT)
			If $tabNum = 1 Or $tabNum > 3 Then
				$sServerStringArray[$i][1] =  $splitIP[0]
				$sServerStringArray[$i][2] =  $splitIP[1] ;added +10 port so connect works. shouldent need
				$bOffline = False
			ElseIf $tabNum = 2 Then
				$sServerStringArrayKPQ3[$i][1] =  $splitIP[0]
				$sServerStringArrayKPQ3[$i][2] =  $splitIP[1]
				$bOfflineKPQ3 = False
			ElseIf $tabNum = 3 Then
				$sServerStringArrayQ2[$i][1] =  $splitIP[0]
				$sServerStringArrayQ2[$i][2] =  $splitIP[1]
				$bOfflineQ2 = False
			EndIf

			;==> send getinfo to a small group servers $iMaxIP[25]
			If $i = ($j+ int($iMaxIP-1)) Then ;0 to 24
				ConsoleWrite("!servers inital2= "&$i-Int($iMaxIP-1) &"to" &$i & " total= "&$iServerCountTotal&@CRLF)
				If SendSTATUStoServers($ipArray, $i-Int($iMaxIP-1), $i ) Then ;get each server details
					listenIncommingServers(0) ;now listen for responce
				EndIf
				$j = Int($i+1) ;add one because array starts at 0
			EndIf
		Next


		If $j < $iServerCountTotal Then
			ConsoleWrite("!servers final2= "& $j& "to"&$iServerCountTotal&@CRLF)
			If SendSTATUStoServers($ipArray, $j, $i) Then ;get each server details
				listenIncommingServers(0) ;now listen for responce
			EndIf
		EndIf


		;check global recieved servers. if some failed. try recieve again
		Local $iLoop
		for $iLoop =0 To 3
			If $isGettingServers And $iServerCountAdd < $iServerCountTotal Then
				ConsoleWrite("!Some servers failed to respond. Sending Status again"&@CRLF)
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				;hypo send ping to list 1 more time
				Local $countServ1 = GetServerCountInArray() ;count servers in array
				;Local $aIPArrayRef2[1]
				Local $count =0
				For $int = 0 To $countServ1-1 ;UBound($aIPArrayRef)-1

					If	($tabNum = 1) Or ($tabNum > 3) Then
						If $sServerStringArray[$int][0] = "" Then
							SendSTATUStoServers($ipArray, $int, $int)
							$count += 1
						EndIf
					ElseIf $tabNum =2 Then
						If $sServerStringArrayKPQ3[$int][0] = "" Then
							SendSTATUStoServers($ipArray, $int, $int)
							$count += 1
						EndIf
					ElseIf	$tabNum = 3 Then
						If $sServerStringArrayQ2[$int][0] = "" Then
							SendSTATUStoServers($ipArray, $int, $int)
							$count += 1
						EndIf
					EndIf

				Next
				ConsoleWrite("!count= "&$count&@CRLF)
				If 	$count >0 Then
					listenIncommingServers(1)
				EndIf
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			EndIf
		Next

	Else ;returned -1
		MsgBox($MB_SYSTEMMODAL, "Master Server Error","ERROR Connecting to Master Server" &@CRLF& _
								"Try Another 'Master' in Setup" &@CRLF&@CRLF& _
								"If they all fail, try the 'Offline' button",0, $HypoGameBrowser )
		ResetRefreshTimmers()
		ConsoleWrite("server msg= " &$serverMessage&@CRLF)
		$isGettingServers = -1
	EndIf

	_UDPCloseSocket($hSocketServerUDP)
	$isGettingServers = -1
	serverRefreshButtonState()
	If _IsChecked($GB_Players_sound) Then selectAudoToPlay(1)

EndFunc; -->  GetMasterServerList TCP
;========================================================
#EndRegion --> TCP GET LIST, FILL ARRAY

#Region --> AUDIO
Func selectAudoToPlay($gameType)
	Local $players

	If $gameType = 1 Then
		$players = $GS_countPlayers
	Else
		$players = Int($countPlayers + $countPlayersKPQ3 +  $countPlayersQ2)
	EndIf
ConsoleWrite("players="&$players&@CRLF)

	If $players = 0 Then Return

	Switch($players)
		Case 1
			SoundPlay($mp3path1 , 0)
		Case 2
			SoundPlay($mp3path2 , 0)
		Case 3
			SoundPlay($mp3path3 , 0)
		Case 4
			SoundPlay($mp3path4 , 0)
		Case 5
			SoundPlay($mp3path5 , 0)
		Case 6
			SoundPlay($mp3path6 , 0)
		Case 7
			SoundPlay($mp3path7 , 0)
		Case 8
			SoundPlay($mp3path8 , 0)
		Case 9
			SoundPlay($mp3path9 , 0)
		Case 10
			SoundPlay($mp3path10 , 0)
		Case Else
			SoundPlay($mp3path10p , 0)
	EndSwitch
EndFunc

#EndRegion


;==> start external source code
#Region -->UDP _UDPBind _UDPSendTo _UDPRecvFrom _UDPCloseSocket _getsockopt _setsockopt _SetPacketBufferSize
; ===============================================================================================================================
; #INDEX# =======================================================================================================================
; Title .........: Winsock
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Functions that assist with Winsock library management.
; Author(s) .....: j0kky
; ===============================================================================================================================
Func _UDPBind($sSourceAddr = "", $iSourcePort = 0)

    If $sSourceAddr = Default Then $sSourceAddr = ""
    If $iSourcePort = Default Then $iSourcePort = 0
    $sSourceAddr = String($sSourceAddr)
    $iSourcePort = Number($iSourcePort)
    If Not ($iSourcePort >= 0 And $iSourcePort < 65535) Then Return SetError(-4, 0, -1) ; invalid parameter
    If $sSourceAddr <> "" Then
        StringRegExp($sSourceAddr, "((?:\d{1,3}\.){3}\d{1,3})", 3) ;$STR_REGEXPARRAYGLOBALMATCH
        If @error Then Return SetError(-4, 0, -1)
    EndIf

    Local $hWs2 = DllOpen("Ws2_32.dll")
    If @error Then Return SetError(-2, 0, -1) ;missing DLL
    Local $bError = 0, $nCode = 0
    Local $tagSockAddr = "short sin_family; ushort sin_port; " & _
            "STRUCT; ulong S_addr; ENDSTRUCT; " & _ ;sin_addr
            "char sin_zero[8]"
	Local $aRet, $tSockAddr, $nReturn


    Local $hSock = DllCall($hWs2, "uint", "socket", "int", 2, "int", 2, "int", 17); AF_INET, SOCK_DGRAM, IPPROTO_UDP
    If @error Then
        $bError = -1
    ElseIf ($hSock[0] = 4294967295) Or ($hSock[0] = -1) Then ;INVALID_SOCKET
        $bError = 1
    Else
        $hSock = $hSock[0]
    EndIf

    If (Not $bError) And ($sSourceAddr <> "") Then
        $aRet = DllCall($hWs2, "ulong", "inet_addr", "str", $sSourceAddr)
        If @error Then
            $bError = -1
        ElseIf ($aRet[0] = -1) Or ($aRet[0] = 4294967295) Or ($aRet[0] = 0) Then ;INADDR_NONE or INADDR_ANY
            $bError = 1
        Else
            $sSourceAddr = $aRet[0]
        EndIf
    EndIf

    If (Not $bError) And $iSourcePort Then
        $aRet = DllCall($hWs2, "ushort", "htons", "ushort", $iSourcePort)
        If @error Then
            $bError = -1
        Else
            $iSourcePort = $aRet[0]
        EndIf
    EndIf

    If Not $bError Then
        $tSockAddr = DllStructCreate($tagSockAddr)
        DllStructSetData($tSockAddr, "sin_family", 2) ;AF_INET
        If $iSourcePort Then
            DllStructSetData($tSockAddr, "sin_port", $iSourcePort)
        Else
            DllStructSetData($tSockAddr, "sin_port", 0)
        EndIf
        If $sSourceAddr Then
            DllStructSetData($tSockAddr, "S_addr", $sSourceAddr)
        Else
            DllStructSetData($tSockAddr, "S_addr", 0x000000) ;INADDR_ANY
        EndIf

        $aRet = DllCall($hWs2, "int", "bind", "uint", $hSock, "ptr", DllStructGetPtr($tSockAddr), "int", DllStructGetSize($tSockAddr))
        If @error Then
            $bError = -1
        ElseIf $aRet[0] <> 0 Then ;SOCKET_ERROR
            $bError = 1
        EndIf
        $tSockAddr = 0
    EndIf

    If $bError < 0 Then
        $nCode = -1 ;internal error
        $nReturn = -1 ;failure
        If $hSock Then UDPCloseSocket($hSock)
    ElseIf $bError > 0 Then
        If Not $nCode Then
            $aRet = DllCall($hWs2, "int", "WSAGetLastError")
            If @error Then
                $nCode = -1
            Else
                $nCode = $aRet[0]
            EndIf
            If $nCode = 0 Then $nCode = -3 ;undefined error
        EndIf
        $nReturn = -1
        If $hSock Then UDPCloseSocket($hSock)
    Else
        $nReturn = $hSock
    EndIf

    DllClose($hWs2)
	$hSocReqNum+=1
	ConsoleWrite(">BIND SOCKET eventNum= "& $hSocReqNum &@CRLF); hypo
    Return SetError($nCode, 0, $nReturn)
EndFunc   ;==>_UDPBind

Func _UDPSendTo($sIPAddr, $iDestPort, $iData, $iMainsocket = 0)
    If $iMainsocket = Default Then $iMainsocket = 0
    $iMainsocket = Number($iMainsocket)
    $sIPAddr = String($sIPAddr)
    $iDestPort = Number($iDestPort)
    $iData = String($iData)
    If Not ($iDestPort > 0 And $iDestPort < 65535) Or _
            $iMainsocket < 0 Then Return SetError(-4, 0, -1) ; invalid parameter
    StringRegExp($sIPAddr, "((?:\d{1,3}\.){3}\d{1,3})", 3) ;$STR_REGEXPARRAYGLOBALMATCH
    If @error Then Return SetError(-4, 0, -1)

    Local $hWs2 = DllOpen("Ws2_32.dll")
    If @error Then Return SetError(-2, 0, -1) ;missing DLL
    Local $bError = 0, $nCode = 0
    Local $tagSockAddr = "short sin_family; ushort sin_port; " & _
            "STRUCT; ulong S_addr; ENDSTRUCT; " & _ ;sin_addr
            "char sin_zero[8]"
	Local $nReturn, $aRet


    If Not $iMainsocket Then
        $aRet = DllCall($hWs2, "uint", "socket", "int", 2, "int", 2, "int", 17); AF_INET, SOCK_DGRAM, IPPROTO_UDP
        If @error Then
            $bError = -1
        ElseIf ($aRet[0] = 4294967295) Or ($aRet[0] = -1) Then ;INVALID_SOCKET
            $bError = 1
        Else
            $iMainsocket = $aRet[0]
        EndIf
    EndIf

    If Not $bError Then
        $aRet = DllCall($hWs2, "ulong", "inet_addr", "str", $sIPAddr)
        If @error Then
            $bError = -1
        ElseIf ($aRet[0] = -1) Or ($aRet[0] = 4294967295) Or ($aRet[0] = 0) Then ;INADDR_NONE or INADDR_ANY
            $bError = 1
        Else
            $sIPAddr = $aRet[0]
        EndIf
    EndIf

    If Not $bError Then
        $aRet = DllCall($hWs2, "ushort", "htons", "ushort", $iDestPort)
        If @error Then
            $bError = -1
        Else
            $iDestPort = $aRet[0]
        EndIf
    EndIf

    If Not $bError Then
        $aRet = DllCall($hWs2, "int", "ioctlsocket", "uint", $iMainsocket, "long", 0x8004667e, "ulong*", 1) ;FIONBIO
        If @error Then
            $bError = -1
        ElseIf $aRet[0] <> 0 Then ;SOCKET_ERROR
            $bError = 1
        EndIf
    EndIf

    If Not $bError Then
        Local $tSockAddr = DllStructCreate($tagSockAddr)
        DllStructSetData($tSockAddr, "sin_family", 2) ;AF_INET
        DllStructSetData($tSockAddr, "sin_port", $iDestPort)
        DllStructSetData($tSockAddr, "S_addr", $sIPAddr)
        Local $nLenght = StringLen($iData)
        Local $tBuf = DllStructCreate("char[" & $nLenght & "]")
        DllStructSetData($tBuf, 1, $iData)

        $aRet = DllCall($hWs2, "int", "sendto", "uint", $iMainsocket, "ptr", DllStructGetPtr($tBuf), _
			"int", $nLenght, "int", 0, "ptr", DllStructGetPtr($tSockAddr), "int", DllStructGetSize($tSockAddr))
        If @error Then
            $bError = -1
        ElseIf ($aRet[0] = -1) Or ($aRet[0] = 4294967295) Then ;SOCKET_ERROR
            $bError = 1
        Else
            Local $aReturn[2] = [$aRet[0], $iMainsocket]
        EndIf
    EndIf

    If $bError < 0 Then
        $nCode = -1 ;internal error
        $nReturn = -1 ;failure
    ElseIf $bError > 0 Then
        If Not $nCode Then
            $aRet = DllCall($hWs2, "int", "WSAGetLastError")
            If @error Then
                $nCode = -1
            Else
                $nCode = $aRet[0]
            EndIf
            If $nCode = 0 Then $nCode = -3 ;undefined error
        EndIf
        $nReturn = -1
    Else
        $nReturn = $aReturn
    EndIf
    DllClose($hWs2)
    Return SetError($nCode, 0, $nReturn)
EndFunc   ;==>_UDPSendTo

Func _UDPRecvFrom($iMainsocket, $iMaxLen, $iFlag = 0)
    If $iFlag = Default Then $iFlag = 0
    $iMainsocket = Number($iMainsocket)
    $iMaxLen = Number($iMaxLen)
    $iFlag = Number($iFlag)
    If $iMainsocket < 0 Or _
            $iMaxLen < 1 Or _
            Not ($iFlag = 0 Or $iFlag = 1) Then Return SetError(-4, 0, -1) ; invalid parameter

    Local $hWs2 = DllOpen("Ws2_32.dll")
    If @error Then Return SetError(-2, 0, -1) ;missing DLL
    Local $bError = 0, $nCode = 0
    Local $tagSockAddr = "short sin_family; ushort sin_port; " & _
            "STRUCT; ulong S_addr; ENDSTRUCT; " & _ ;sin_addr
            "char sin_zero[8]"
	Local $aRet, $nReturn

    If Not $bError Then
        $aRet = DllCall($hWs2, "int", "ioctlsocket", "uint", $iMainsocket, "long", 0x8004667e, "ulong*", 1) ;hypo default 1(dont block code);FIONBIO
        If @error Then																						;0 will wait untill data recieved or timed out
            $bError = -1
			ConsoleWrite("!ioctlsocket= 1"&@CRLF)
        ElseIf $aRet[0] <> 0 Then ;SOCKET_ERROR
            $bError = 1
			ConsoleWrite("!ioctlsocket= -1"&@CRLF)
        EndIf
    EndIf

    Local $tSockAddr = DllStructCreate($tagSockAddr)
    Local $tBuf = DllStructCreate("char[" & $iMaxLen & "]")

    $aRet = DllCall($hWs2, "int", "recvfrom", "uint", $iMainsocket, "ptr", DllStructGetPtr($tBuf), _
		"int", $iMaxLen, "int", 0, "ptr", DllStructGetPtr($tSockAddr), "int*", DllStructGetSize($tSockAddr))

    If @error Then
        $bError = -1
    ElseIf ($aRet[0] = -1) Or ($aRet[0] = 4294967295) Then ;SOCKET_ERROR
        $bError = 1
        $aRet = DllCall($hWs2, "int", "WSAGetLastError")
        If @error Then
            $bError = -1
        ElseIf $aRet[0] = 0 Or $aRet[0] = 10035 Then ;WSAEWOULDBLOCK
            $nCode = -10 ;internal function value, it means no error
        EndIf
    Else
        If $iFlag Then
            Local $aResult[3] = [Binary(DllStructGetData($tBuf, 1))] ;data
        Else
            Local $aResult[3] = [DllStructGetData($tBuf, 1)] ;data
        EndIf

        $aRet = DllCall($hWs2, "ptr", "inet_ntoa", "ulong", DllStructGetData($tSockAddr, "S_addr"))
        If @error Then
            $bError = -1
        ElseIf $aRet[0] = Null Then
            $bError = 1
        Else
            $aResult[1] = DllStructGetData(DllStructCreate("char[15]", $aRet[0]), 1) ;IP address
            $aRet = DllCall($hWs2, "ushort", "ntohs", "ushort", DllStructGetData($tSockAddr, "sin_port"))
            If @error Then
                $bError = -1
            Else
                $aResult[2] = $aRet[0] ;port
            EndIf
        EndIf
    EndIf

    If $bError < 0 Then
        $nCode = -1 ;internal error
        $nReturn = -1 ;failure
    ElseIf $bError > 0 Then
        If Not $nCode Then
            $aRet = DllCall($hWs2, "int", "WSAGetLastError")
            If @error Then
                $nCode = -1
            Else
                $nCode = $aRet[0]
            EndIf
            If $nCode = 0 Then $nCode = -3 ;undefined error
        EndIf
        If $nCode = -10 Then $nCode = 0
        $nReturn = -1
    Else
        $nReturn = $aResult
    EndIf
    DllClose($hWs2)
    Return SetError($nCode, 0, $nReturn)
EndFunc   ;==>_UDPRecvFrom

Func _UDPCloseSocket($iMainsocket)
    If IsArray($iMainsocket) Then
        If Not ((UBound($iMainsocket, 0) = 1) And (UBound($iMainsocket) = 2)) Then Return SetError(-1, 0, -4)
        $iMainsocket = $iMainsocket[1]
    Else
        If $iMainsocket < 1 Then Return SetError(-1, 0, -4)
    EndIf

    Local $hWs2 = DllOpen("Ws2_32.dll")
    If @error Then Return SetError(-2, 0, -1) ;missing DLL
    Local $bError = 0, $nCode = 0
	Local $aRet, $nReturn

    $aRet = DllCall($hWs2, "int", "closesocket", "uint", $iMainsocket)
    If @error Then
        $bError = -1
    ElseIf $aRet[0] <> 0 Then ;SOCKET_ERROR
        $bError = 1
    EndIf

    If $bError < 0 Then
        $nCode = -1 ;internal error
        $nReturn = -1 ;failure
    ElseIf $bError > 0 Then
        If Not $nCode Then
            $aRet = DllCall($hWs2, "int", "WSAGetLastError")
            If @error Then
                $nCode = -1
            Else
                $nCode = $aRet[0]
            EndIf
            If $nCode = 0 Then $nCode = -3 ;undefined error
        EndIf
        $nReturn = -1
    Else
        $nReturn = 1
    EndIf
    DllClose($hWs2)
	$hSocReqNum+=1
	ConsoleWrite(">CLOSE SOCKET eventNum= "&$hSocReqNum&@CRLF) ;hypo
    Return SetError($nCode, 0, $nReturn)
EndFunc   ;==>_UDPCloseSocket


;==> hypo set socket buffer larger
Func _SetPacketBufferSize($sSocket, $sSize)
	Local Const $SO_SNDBUF = 0x1001
	Local Const $SO_RCVBUF = 0x1002
	Local Const $SOL_SOCKET = 0xFFFF
	Local $tResult = DllStructCreate("int")
	Local $tSetting = DllStructCreate("int packet")
	Local $iRes
	DllStructSetData($tSetting, "packet", $sSize) ; Or 1 instead of "var1".

	Local $iRes = _setsockopt($sSocket, $SOL_SOCKET, $SO_SNDBUF, $tSetting)
	If $iRes = 0 Then
		ConsoleWrite(">set buffer size" & @CRLF)
	EndIf

	Local $iRes = _setsockopt($sSocket, $SOL_SOCKET, $SO_RCVBUF, $tSetting)
	If $iRes = 0 Then
		ConsoleWrite(">set buffer size" & @CRLF)
	EndIf

	Local $iRes = _getsockopt($sSocket, $SOL_SOCKET, $SO_SNDBUF, $tResult)
	If $iRes = 0 Then
		ConsoleWrite(">send buffer size = " & DllStructGetData($tResult, 1) & @CRLF)
	EndIf

	Local $iRes = _getsockopt($sSocket, $SOL_SOCKET, $SO_RCVBUF, $tResult)
	If $iRes = 0 Then
		ConsoleWrite(">receive buffer size = " & DllStructGetData($tResult, 1) & @CRLF)
	EndIf
EndFunc ;==> _SetPacketBufferSize

Func _getsockopt($iSocket, $iLevel, $iOptName, ByRef $tOptVal)
    Local $iOptLen = DllStructGetSize($tOptVal)
    Local $aRet = DllCall("WS2_32.DLL", "int", "getsockopt", "int", $iSocket, "int", $iLevel, "int", $iOptName, "struct*", $tOptVal, "int*", $iOptLen)
    Return $aRet[0]
EndFunc ;==> _getsockopt

Func _setsockopt($iSocket, $iLevel, $iOptName, ByRef $tOptVal)
    Local $iOptLen = DllStructGetSize($tOptVal)
    Local $aRet = DllCall("WS2_32.DLL", "int", "setsockopt", "int", $iSocket, "int", $iLevel, "int", $iOptName, "struct*", $tOptVal, "int*", $iOptLen)
    Return $aRet[0]
EndFunc ;==> _setsockopt



;-->END Winsock
; ===============================================================================================================================
#EndRegion

#Region -->ICON INCLUDE
;==> Resources.au3 by Zedna
Func _ResourceGet($ResName, $ResLang = 0) ; $RT_RCDATA = 10
	Local Const $IMAGE_BITMAP = 0
	Local $hInstance, $hBitmap, $InfoBlock, $GlobalMemoryBlock, $MemoryPointer, $ResSize

	;If $DLL = -1 Then
	  $hInstance = _WinAPI_GetModuleHandle("")
	 ; $hInstance = _WinAPI_LoadLibraryEx($DLL, $LOAD_LIBRARY_AS_DATAFILE)

	If $hInstance = 0 Then Return SetError(1, 0, 0)

	$hBitmap = _WinAPI_LoadImage($hInstance, $ResName, $IMAGE_BITMAP, 0, 0, 0)
	If @error Then Return SetError(2, 0, 0)
	Return $hBitmap ; returns handle to Bitmap

EndFunc


Func _ResourceSetImageToCtrl($CtrlId, $ResName) ; $RT_RCDATA = 10
	Local $ResData

	$ResData = _ResourceGet($ResName, 0)
	If @error Then Return SetError(1, 0, 0)

	_SetBitmapToCtrl($CtrlId, $ResData)
	If @error Then Return SetError(2, 0, 0)

	Return 1
EndFunc

; internal helper function
; thanks for improvements Melba
Func _SetBitmapToCtrl($CtrlId, $hBitmap)
    Local Const $STM_SETIMAGE = 0x0172
    Local Const $STM_GETIMAGE = 0x0173
    Local Const $BM_SETIMAGE = 0xF7
    Local Const $BM_GETIMAGE = 0xF6
    Local Const $IMAGE_BITMAP = 0
    Local Const $SS_BITMAP = 0x0E
    Local Const $BS_BITMAP = 0x0080
    Local Const $GWL_STYLE = -16

    Local $hWnd, $hPrev, $Style, $iCtrl_SETIMAGE, $iCtrl_GETIMAGE, $iCtrl_BITMAP

    $hWnd = GUICtrlGetHandle($CtrlId)
    If $hWnd = 0 Then Return SetError(1, 0, 0)


    $CtrlId = _WinAPI_GetDlgCtrlID($hWnd) ; support for $CtrlId = -1
    If @error Then Return SetError(2, 0, 0)


    ; determine control class and adjust constants accordingly
    Switch _WinAPI_GetClassName($CtrlId)
        Case "Button" ; button,checkbox,radiobutton,groupbox
            $iCtrl_SETIMAGE = $BM_SETIMAGE
            $iCtrl_GETIMAGE = $BM_GETIMAGE
            $iCtrl_BITMAP = $BS_BITMAP
        Case "Static" ; picture,icon,label
            $iCtrl_SETIMAGE = $STM_SETIMAGE
            $iCtrl_GETIMAGE = $STM_GETIMAGE
            $iCtrl_BITMAP = $SS_BITMAP
        Case Else
            Return SetError(3, 0, 0)
	EndSwitch

	; set SS_BITMAP/BS_BITMAP style to the control
    $Style = _WinAPI_GetWindowLong($hWnd, $GWL_STYLE)
    If @error Then Return SetError(4, 0, 0)
    _WinAPI_SetWindowLong($hWnd, $GWL_STYLE, BitOR($Style, $iCtrl_BITMAP))
    If @error Then Return SetError(5, 0, 0)

	; set image to the control
    $hPrev  = _SendMessage($hWnd, $iCtrl_SETIMAGE, $IMAGE_BITMAP, $hBitmap)
    If @error Then Return SetError(6, 0, 0)

    If $hPrev Then _WinAPI_DeleteObject($hPrev)

	Return 1
EndFunc
;==> END Resources.au3
#EndRegion
;==> end external source code

#Region --> UDP SEND STATUS ; --> send YYYYStatus
Func SendSTATUStoServers(Const ByRef $arrayServerX,$startNum, $endNum)
	Local $iIP, $iErrorX, $start
	Local $sIPAddress, $iPort, $serverAddress

	;SelectedTabNum()
	;$getTimePingServer = TimerInit()
	$serverRefreshTimer = TimerInit()

	If Not IsArray($arrayServerX) Or $arrayServerX = "" Then
		ConsoleWrite("!SendSTATUStoServers failed"&@CRLF)
		Return False
	EndIf
	ConsoleWrite("SendSTATUStoServers array= "&UBound($arrayServerX)&" start= "&$startNum&" end= " &$endNum&@CRLF)

	For $iIP = $startNum To UBound($arrayServerX)- 1 ;todo:
		If $arrayServerX[$iIP] = "" Then
			If $iIP > 0 Then
				ConsoleWrite("!servers blank= "&$iIP&@CRLF)
				ExitLoop
			Else
				ConsoleWrite("!SendSTATUStoServers failed@ "&$iIP&@CRLF)
				Return False
			EndIf
		EndIf

		$serverAddress 	= StringSplit($arrayServerX[$iIP], ":")
		If @error Then
			ConsoleWrite("error spliting ':' " & @CRLF)
			Return False; end??
		EndIf

		If  StringInStr($arrayServerX[$iIP] , "\final\") Or $arrayServerX[$iIP] = "" Then
			If $iIP > 0 Then
				Return True
			Else
				ConsoleWrite("fail2= "&$iIP&@CRLF)
				Return False
			EndIf
		EndIf



		$sIPAddress 	= TCPNameToIP( $serverAddress[1])
		$iPort 			= Int($serverAddress[2])

		;ConsoleWrite("UDP Send ip: " & $sIPAddress & " port: " & $iPort &@CRLF)

		$iErrorX = _UDPSendTo($sIPAddress, $iPort, sendStatusMessageType(), $hSocketServerUDP)
		if @error Then 	ConsoleWrite("UDP Send \status\ sock error =  " & $iErrorX & " error" & @CRLF)
		;ConsoleWrite("server sent num= " &$iIP&@CRLF)

		If $tabNum =1 or $tabNum >3 Then
			$sServerStringArray[$iIP][3] =TimerInit()
		ElseIf  $tabNum = 2 Then
			$sServerStringArrayKPQ3[$iIP][3] =TimerInit()
		ElseIf $tabNum = 3 Then
			$sServerStringArrayQ2[$iIP][3] =TimerInit()
		EndIf

		If $iIP = $endNum Then ExitLoop ;endnum added for q2, more than 30 servers at once
	Next

	Return True
EndFunc ; -->send YYYYStatus
;========================================================
#EndRegion --> END UDP SEND

#Region --> UDP RECV listenIncommingServers($iSFinal)
;========================================================
Func listenIncommingServers($iSFinal)
	Local $servNum, $i, $listNum
	Local $iPing
	local $data
	Local $msToGetServerinfo = TimerInit()
	;ConsoleWrite("array size time1= "&TimerDiff($msToGetServerinfo)&@CRLF)
	Local $countServ = GetServerCountInArray() ;count servers in array
	Local $localServerCount = 0
	Local $KpGsFinal

	While 1 ;loop until all servers recieved or timout hit
		$data=""
		Do
			$data = _UDPRecvFrom($hSocketServerUDP,2048,0)
			If TimerDiff($serverRefreshTimer) > 1000 Then
				ConsoleWrite(">TIMEOUT.. 1 seconds"&@CRLF)
				ExitLoop(2) ;stop do and stop while
			EndIf
		Until IsArray($data)

		GUICtrlSetData($ProgressBar, 0)

		; loop through complet internal server array
		For $servNum = 0 To $countServ - 1
			If $tabNum = 1 Or $tabNum > 3 Then ;check # of existing server
				If Not StringCompare($sServerStringArray[$servNum][1],$data[1])=0 Then ContinueLoop ;-10 gs port
				If Not StringCompare($sServerStringArray[$servNum][2],$data[2])=0 Then ContinueLoop
			ElseIf $tabNum = 2 Then
				If Not StringCompare($sServerStringArrayKPQ3[$servNum][1],$data[1])=0 Then	ContinueLoop
				If Not StringCompare($sServerStringArrayKPQ3[$servNum][2],$data[2])=0 Then	ContinueLoop
			ElseIf $tabNum = 3 Then
				If Not StringCompare($sServerStringArrayQ2[$servNum][1],$data[1])=0 Then ContinueLoop
				If Not StringCompare($sServerStringArrayQ2[$servNum][2],$data[2])=0 Then ContinueLoop
			EndIf

			; shouldent happen with kingpin GS port. ToDo test.
			if StringInStr($data[0],"Info string length exceeded") Then
				$data[0] = StringReplace($data[0], "Info string length exceeded" & Chr(10), "",0 )
				ConsoleWrite("!Info string length exceeded" & @CRLF)
			EndIf

			ConsoleWrite("string= " &$data[0] & @CRLF)
			; trim start of string
			If StringInStr($data[0], "ÿÿÿÿprint") Then
				$data[0]=	StringTrimLeft($data[0],StringLen("ÿÿÿÿprint\n")) ;11  trim to"\"
			ElseIf StringInStr($data[0], "ÿÿÿÿstatusResponse") Then
				$data[0]=	StringTrimLeft($data[0], StringLen("ÿÿÿÿstatusResponse\n")) ;20  trim to"\"
			ElseIf StringInStr($data[0], "\gamename\kingpin\") Then
				$data[0]=	StringTrimLeft($data[0], StringLen("\gamename\kingpin\")) ;18  trim to"\"
			EndIf
			ConsoleWrite("+Server strings ' " &$localServerCount+1& " '= "&$data[0]&@CRLF)
			$KpGsFinal=0

			local $ListViewA1 = ServerArray1ToFill()
			local $sIsUsed = _GUICtrlListView_GetItemText($ListViewA1,$servNum,2)
			;ConsoleWrite("isused=" & $sIsUsed & @CRLF)
			If $tabNum = 1 Or $tabNum > 3 Then
				If not ($sIsUsed = "???") Then
					ConsoleWrite("!!is used=" & $sIsUsed & @CRLF)
					ExitLoop(1)
				EndIf
			ElseIf $tabNum = 2 Then
				If not ($sIsUsed = "???") Then
					ConsoleWrite("!!is used=" & $sIsUsed & @CRLF)
					ExitLoop(1)
				EndIf
			ElseIf $tabNum = 3 Then
				If not ($sIsUsed = "???") Then
					ConsoleWrite("!!is used=" & $sIsUsed & @CRLF)
					ExitLoop(1)
				EndIf
			EndIf


			;todo; kp lf?
			;$data[0] = string( $data[0]& Chr(10))	;add @LF to end (for array later. player count)

			;fill internal server array
			If $tabNum = 1 Or $tabNum > 3 Then
				Local $tmpStrCnt = StringInStr($data[0], "\final\")	;"\queryid\" ;hypov8 todo: this should use queryID# then 111.2 111.3 etc.. to late..
				If Not ($tmpStrCnt = 0) Then
					$data[0] = StringLeft($data[0], $tmpStrCnt-1)
					$data[0] = string( $data[0]& Chr(10))	;add @LF to end (for array later. player count)
					$sServerStringArray[$servNum][0] = String($sServerStringArray[$servNum][0] & $data[0]) ; add existing+recieved data
					$data[0] = $sServerStringArray[$servNum][0]
					$KpGsFinal = 1
					$iPing = TimerDiff($sServerStringArray[$servNum][3])
				Else
					;more than 10 clients, gamespy will send it in another packet
					$tmpStrCnt = StringInStr($data[0],"\queryid\")
					If Not ($tmpStrCnt = 0) Then
						$data[0] = StringLeft($data[0], $tmpStrCnt-1)
					EndIf
					$sServerStringArray[$servNum][0] = String($sServerStringArray[$servNum][0] & $data[0]) ;todo: cause issues?? 20+clients?  ;$data[0] ;not "\queryid\"
				EndIf
			ElseIf $tabNum = 2 Then
				$data[0] = string( $data[0]& Chr(10))	;add @LF to end (for array later. player count)
				$sServerStringArrayKPQ3[$servNum][0] = $data[0]
				$iPing = TimerDiff($sServerStringArrayKPQ3[$servNum][3])
			ElseIf $tabNum = 3 Then
				$data[0] = string( $data[0]& Chr(10))	;add @LF to end (for array later. player count)
				$sServerStringArrayQ2[$servNum][0] = $data[0]
				$iPing = TimerDiff($sServerStringArrayQ2[$servNum][3])
			EndIf


			;$iPing = TimerDiff($serverPingArray[$servNum]) ;todo all use ping array

			;fill listview
			If ($tabNum > 1) Or ($KpGsFinal = 1) Then ;StringInStr($data[0],"\final\\queryid\")
				FillServerListArray($data, int($iPing), $servNum )	;data[0]=string   ;data[1]=ip   ;data[2]=port 22
				$localServerCount += 1
				$iServerCountAdd += 1
					ConsoleWrite("getnum=" & $servNum &" ping="& $iPing & " servCnt="& $iServerCountAdd &@CRLF)
			Else
				ConsoleWrite("!server not done?? $KpGsFinal="&$KpGsFinal&@CRLF)
			EndIf

;~ 			ConsoleWrite("serve count.. InGroup= "&$localServerCount & " Totals= " &$iServerCountAdd& "/"& $iServerCountTotal& @CRLF)

			if ($localServerCount = $iMaxIP) And ($isFinal = 0) Then ;$isFinal allow some extra time for missed servers
				ConsoleWrite("!got MAX servers"&@CRLF)
				ExitLoop(2) ;got every server for this wave
			EndIf

			GUICtrlSetData($ProgressBar, Int( $iServerCountAdd * 100 / $iServerCountTotal))


			If $iServerCountAdd = $iServerCountTotal Then
				ConsoleWrite("!got All servers"&@CRLF)
				ExitLoop(2) ;got every server
			EndIf


			ExitLoop(1); go back to udp recieve
		Next
	WEnd
EndFunc; --> listen Incomming Servers
;========================================================
#EndRegion

#Region --> GAME STRINGS DISPLAYED
;=======================================================
; --> fill array kp server
Func GetServerName($string)
	Local $i
	$string = StringReplace($string, Chr(10), "\") ;replace last @LF with '\', or string split will have players at end
	Local $servVars = StringSplit($string, "\") ; Chr(92)
	If @error Then ConsoleWrite("ERROR split... "& @CRLF)
	For $i = 1 to $servVars[0] Step 2
		If (StringCompare($servVars[$i],"hostname")=0) Or (StringCompare($servVars[$i], "sv_hostname")=0) Then
			return $servVars[$i+1]
		EndIf
	Next
	;Return "UNKNOWN HOSTNAME"
EndFunc
;===========================
Func GetPlayerCount($string)
	Local $player = 0
	Local $tmpstr
	Local $numLines, $iply, $i7,$tmpPlyrName
	Local $sXX[4]

	If $tabNum = 1 Then
		For $i7 =0 to 64

			$sXX = String("player_" & $i7 &"\") ;name player_0
			If StringInStr($string, $sXX) Then
			$player +=1
			Else
				Return $player
			EndIf
		Next
		Return $player
	Else
		$tmpstr = StringSplit($string, Chr(10), $STR_ENTIRESPLIT)
			If @error Then
				ConsoleWrite("player error no @LF" & $tmpstr&@CRLF)
				Return 0
			EndIf
		$numLines = $tmpstr[0] ;3 lines standard >= players
		For $iply = 2 To $numLines Step 1
			If Not ($tmpstr[$iply] = "") Then ;catch end line @LF, EOT
				$tmpPlyrName = _StringBetween($tmpstr[$iply],'"', '"')
				If @error Then ContinueLoop
				If (StringCompare($tmpPlyrName[0],"WallFly[BZZZ]") = 0) Then ContinueLoop
				$player +=1
			EndIf
		Next
		Return $player
	EndIf
EndFunc
;=======================
Func GetPlayerMax($string)
	Local $aServVars, $i, $tmp =0
	$string = StringReplace($string, Chr(10), "\") ;replace last @LF with '\', or string split will have players at end
	 $aServVars = StringSplit($string, '\', $STR_NOCOUNT)
	If @error Then ConsoleWrite("ERROR split... GetPlayerMax"& @CRLF)
	For $i = 0 to UBound($aServVars) -1 Step 2
		If (StringCompare($aServVars[$i],"maxclients")=0) Or (StringCompare($aServVars[$i],"sv_maxclients")=0) Then
			$tmp = Int($i) + 1
			Return $aServVars[$tmp]
		EndIf
	Next
	Return 0 ;failed to find
EndFunc
;=======================
Func GetMapName($string)
	$string = StringReplace($string, Chr(10), "\") ;replace last @LF with '\', or string split will have players at end
	Local $servVars = StringSplit($string, "\", $STR_NOCOUNT)
	For $i = 0 to UBound($servVars) -1 Step 2
		If StringCompare($servVars[$i],"mapname")=0 Then
			Return $servVars[$i+1]
		EndIf
	Next
	Return "" ;failed
EndFunc
;=======================
Func GetModName($string)
	$string = StringReplace($string, Chr(10), "\") ;replace last @LF with '\', or string split will have players at end
	Local $servVars = StringSplit($string, "\", $STR_NOCOUNT)
	;loop. look for gametype
	For $i = 0 to UBound($servVars) -1 Step 2
		if StringCompare($servVars[$i],"gametype")=0 Then
			Return $servVars[$i+1]
		EndIf
	Next
	;loop through again. use "gamename"
	For $i = 0 to UBound($servVars) -1 Step 2
		if StringCompare($servVars[$i],"gamename")=0 Then
			Return $servVars[$i+1]
		EndIf
	Next


	;loop through again. use "game"
	For $i = 0 to UBound($servVars) -1 Step 2
		If StringCompare($servVars[$i], "game")=0 Then
			Return $servVars[$i+1]
		EndIf
	Next


	Return "" ;failed
EndFunc ; --> fill array kp server
;=======================
Func GetGamePort($string)
	If $tabNum = 1 Or $tabNum >3 Then
		$string = StringReplace($string, Chr(10), "\") ;replace last @LF with '\', or string split will have players at end
		Local $servVars = StringSplit($string, "\", $STR_NOCOUNT)
		For $i = 0 to UBound($servVars) -1 Step 2
			if StringCompare($servVars[$i], "hostport")=0 Then
				Return $servVars[$i+1]
			EndIf
		Next
	EndIf

	Return "" ;failed
EndFunc ; --> set gamespy/game port for kingpin

;=================================

Func ServerArray1ToFill()
	If $tabNum = 1 Or $tabNum >3 And Not ($tabNum =6) Then	Return $ListView1KP
	If $tabNum = 2 Then	Return $ListView1KPQ3
	If $tabNum = 3 Then	Return $ListView1Q2
	If $tabNum = 6 Then
		If $iMGameType = 1 Then	Return $ListView1M
		If $iMGameType = 2 Then	Return $ListView2M
		If $iMGameType = 3 Then	Return $ListView3M
	EndIf

EndFunc

Func ServerArray2ToFill()
	If $tabNum =1 Or $tabNum >3 Then
		Return $ListView2
	ElseIf $tabNum =2 Then
		Return $ListView2KPQ3
	ElseIf $tabNum =3 Then
		Return $ListView2Q2
	EndIf
EndFunc

Func ServerArray3ToFill()
	If $tabNum =1 Or $tabNum >3 Then
		Return $ListView3
	ElseIf $tabNum =2 Then
		Return $ListView3KPQ3
	ElseIf $tabNum =3 Then
		Return $ListView3Q2
	EndIf
EndFunc

Func IconPingX($iPingX)
	If $iPingX <150 Then Return 1 ;green
	if $iPingX >= 150 And $iPingX < 500 Then Return 2 ;yellow
	If $iPingX >=500 Then Return 3 ;red
EndFunc

Func IconPlayerX($iPlayersX, $iPlayerMax)
	If $iPlayersX = 0 Then Return 0 ;empty

	If $iPlayersX = $iPlayerMax Then
		;$isPlayersInServer = True
		Return 6 ;full icon
	EndIf
	;$isPlayersInServer = True
	Return 7 ;half full icon
EndFunc


#EndRegion --> GAME STRINGS DISPLAYED

#Region --> FILL ARRAY1
;========================================================
; --> FillServerListArray
Func FillServerListArray($dataX, $ping, $servNum)
	;SelectedTabNum()
	Local $ListViewA = ServerArray1ToFill()


	;$stringCol[int($iQ3)] = GUICtrlCreateListViewItem("", $idListview) ;done earlyer. maybe use this later. to sort by ping+color?
	Local $ip 			= string( $dataX[1] & ":" & $dataX[2])
	Local $serverName 	= GetServerName($dataX[0])
	Local $playerCount 	= GetPlayerCount($dataX[0])
	Local $playerMax	= GetPlayerMax($dataX[0])
	Local $mapName 		= GetMapName($dataX[0])
	Local $modName    	= GetModName($dataX[0])
	Local $playerCnt 	= String($playerCount &"/"& $playerMax)
	Local $iconPlayer 	= IconPlayerX($playerCount,$playerMax )
	Local $iconPing		= IconPingX($ping)
	Local $portGame		= GetGamePort($dataX[0])

	$GS_countPlayers += $playerCount

	If Not ($portGame = "") Then
		$sServerStringArray[$servNum][4] = $portGame ;set gamespy reported game port
		$ip	= string( $dataX[1] & ":" & $portGame)
		_GUICtrlListView_AddSubItem($ListViewA,$servNum, $ip,		1, 	-1)				;IP
	endif
	_GUICtrlListView_AddSubItem($ListViewA,$servNum, $serverName ,	2, 	-1) 			;server
	_GUICtrlListView_AddSubItem($ListViewA,$servNum, $ping,			3,	$iconPing)		;ping
	_GUICtrlListView_AddSubItem($ListViewA,$servNum, $playerCnt,	4,	$iconPlayer)	;players
	_GUICtrlListView_AddSubItem($ListViewA,$servNum, $mapName,		5, 	-1)				;map
	_GUICtrlListView_AddSubItem($ListViewA,$servNum, $modName,		6, 	-1)				;mod

EndFunc ; --> FillServerListArray
;========================================================



#EndRegion --> END FILL ARRAY1

#Region  FILL ARRAY 2&3 STRINGS
;========================================================
; --> FillSelectedServerStrings
Func FillSelectedServerStrings($iTab, $iListNum)
	;#forceref $iListNum
	;SelectedTabNum()
	Local $serStrArray, $serSelNum
	Local $ListViewA = ServerArray1ToFill()
	Local $ListViewB = ServerArray2ToFill()
	Local $ListViewC = ServerArray3ToFill()


	If $iListNum = -1 Or $iTab > 3 Then
		ConsoleWrite("nothing selected" &@CRLF)
		Return
	EndIf

	;$serSelNum = GetTabSelectedStringNumber()
	$serSelNum = _GUICtrlListView_GetItemText($ListViewA,$iListNum,0)


	;delet b4 it gets a chance to exit
	_GUICtrlListView_DeleteAllItems($ListViewB)
	_GUICtrlListView_DeleteAllItems($ListViewC)

	If $iTab = 1 Then
		$iLastRulesSortStatus = GUICtrlGetState($ListView3); set global sort for reset
		$serStrArray = $sServerStringArray[$serSelNum][0]
		$iOldSelectNumKp = $iListNum
	ElseIf $iTab = 2 Then
		$iLastRulesSortStatusKPQ3 = GUICtrlGetState($ListView3KPQ3); set global sort for reset
		$serStrArray = $sServerStringArrayKPQ3[$serSelNum][0]
		$iOldSelectNumKPQ3 = $iListNum
	ElseIf $iTab = 3 Then
		$iLastRulesSortStatusQ2 = GUICtrlGetState($ListView3Q2); set global sort for reset
		$serStrArray = $sServerStringArrayQ2[$serSelNum][0]
		$iOldSelectNumQ2 = $iListNum
	EndIf

	ConsoleWrite("ListNum= '"  & $iListNum &"'  ServerNum= '" &$serSelNum &"'"& @CRLF)

	If Not ($serStrArray = "") Then
		Local $tmpstr = StringSplit($serStrArray, Chr(10)) ;, $STR_ENTIRESPLIT)
		If @error Then
			MsgBox($MB_SYSTEMMODAL, "","Error in packet, no Return" )
			ResetRefreshTimmers() ;reset timers if msg box used
			Return
		EndIf

		Local $numLines = $tmpstr[0] ;3 lines standard > =players
		Local $serverVars = $tmpstr[1]

;-------; set server string varables
		local $servrVarArray = StringSplit($serverVars, "\" ) ;setup server strings
		if Not @error Then
			Local $iLineNum=0, $i2

			For $i2 = 1 To $servrVarArray[0]-1 Step 2
			If StringInStr($servrVarArray[$i2], "player_0") Then ExitLoop
			If StringInStr($servrVarArray[$i2], "final\\") Then ExitLoop
			If StringInStr($servrVarArray[$i2], Chr(13)) Then ExitLoop ;shouldent happen


			; hypo todo: remove duplicate strings
			;GUICtrlCreateListViewItem($servrVarArray[$i2], $ListViewC)	;rules
			_GUICtrlListView_AddItem($ListViewC, $servrVarArray[$i2],-1, 0)							;rules
			_GUICtrlListView_AddSubItem($ListViewC,$iLineNum, $servrVarArray[Int($i2+1)]	 ,1)	;value
			$iLineNum += 1
			Next
		EndIf

		RulesResetSortOrder() ;apply a sort

;-------; add players info, max 31 char for player name
		Local $iply
		If $iTab = 1 Then
			;If StringInStr($serverVars, "player_0") Then
				For $i5 = 0 to 64
					Local $sXX[4]
					Local $sInfo[4]
					Local $tmp
					Local $sArray
					$sXX[0] = String("player_" & $i5 &"\") ;name player_0
					$sXX[1] = String("frags_" & $i5 &"\")	;frags_0
					$sXX[2] = String("ping_" & $i5 &"\")	;ping_0
					$sXX[3] = String("deaths_" & $i5 &"\")	;deaths_0

					If StringInStr($serverVars, $sXX[0]) = 0 Then Return
					For $i6 = 0 To 3 Step 1
						$sArray = StringSplit($serverVars, $sXX[$i6], $STR_ENTIRESPLIT + $STR_NOCOUNT)

						if @error Then Return ;no more players
						;ConsoleWrite("!str1.." & $sArray[0]&@CRLF &"str2.." & $sArray[1]&@CRLF)
						$tmp = StringLeft($sArray[1], Int(StringInStr($sArray[1],"\")-1) )
						$sInfo[$i6] = $tmp

					Next
					;Opt("GUIDataSeparatorChar","\")
					;GUICtrlCreateListViewItem($sInfo[0], $ListViewB) ;hypo spliting string if name has "|" in it
					_GUICtrlListView_AddItem($ListViewB, $sInfo[0],-1, 0)		;Name
					_GUICtrlListView_AddSubItem($ListViewB,$i5, $sInfo[1] ,1)	;Frags
					_GUICtrlListView_AddSubItem($ListViewB,$i5, $sInfo[2] ,2)	;Ping
				Next
			;EndIf
		Else ;kpq3 and q2. game port. uses seperate line for players
			If Not ($tmpstr[2] ="") Then
				local $plyr = 0
				Local $playerName =""
				local $plyrStatus
				Local $plyrStatusArray


				For $iply = 2 To $numLines Step 1
					If Not ($tmpstr[$iply] ="") Then ;catch end line @LF, EOT

						$playerName = _StringBetween($tmpstr[$iply], '"', '"' ) ;get server name[0]
						If @error Then ContinueLoop
						$plyrStatus = StringReplace($tmpstr[$iply], '"' & $playerName[0] & '"', "") ;
						$plyrStatusArray = StringSplit($plyrStatus, " " ) ;setup server strings

						;GUICtrlCreateListViewItem($playerName[0], $ListViewB)
						_GUICtrlListView_AddItem($ListViewB, $playerName[0],-1, 0)					;Name
						_GUICtrlListView_AddSubItem($ListViewB,$plyr, $plyrStatusArray[1] ,1, -1)	;Frags
						_GUICtrlListView_AddSubItem($ListViewB,$plyr, $plyrStatusArray[2] ,2, -1)	;Ping

						$plyr += 1 ;increase 1
					EndIf
				Next
			EndIf
		EndIf
	EndIf
EndFunc; --> FillSelectedServerStrings
;========================================================
#EndRegion --> FILL ARRAY 2&3 STRINGS

#Region --> GUI STATE enable/disble
Func DisableUIButtons()

	GUICtrlSetState($tabGroupGames, $GUI_DISABLE) ;distable tab change on refresh
	GUICtrlSetState($TabSheet1, 	$GUI_DISABLE)
	GUICtrlSetState($TabSheet2, 	$GUI_DISABLE)
	GUICtrlSetState($TabSheet3, 	$GUI_DISABLE)
	GUICtrlSetState($TabSheet4, 	$GUI_DISABLE)
	GUICtrlSetState($TabSheet6, 	$GUI_DISABLE)

	GUICtrlSetState($GetServersBtn, 	$GUI_DISABLE) ;disable get.. button
	GUICtrlSetState($RefServerBtn, 		$GUI_DISABLE)  ;disable Ref.. button
	GUICtrlSetState($FavServerBtn, 		$GUI_DISABLE)
	GUICtrlSetState($SettingsBtn, 		$GUI_DISABLE)
	GUICtrlSetState($OffLineServeBtn, 	$GUI_DISABLE)
	GUICtrlSetState($ListView1KP,		 	$GUI_DISABLE)
	GUICtrlSetState($ListView1KPQ3,	 	$GUI_DISABLE)
	GUICtrlSetState($ListView1Q2, 	 	$GUI_DISABLE)
		GUICtrlSetState($ListView1M, 	$GUI_DISABLE)
		GUICtrlSetState($ListView2M, 	$GUI_DISABLE)
		GUICtrlSetState($ListView3M, 	$GUI_DISABLE)
	If $tabNum = 5 Then
		_GUICtrlTab_SetCurSel($tabGroupGames, 4)
		_GUICtrlTab_ActivateTab($tabGroupGames, 4)
	EndIf

EndFunc

Func EnableUIButtons() ;$OffLineServeBtn
	;enable gui after loading
	GUICtrlSetState($tabGroupGames,		$GUI_ENABLE) ;distable tab change on refresh
	GUICtrlSetState($GetServersBtn, 	$GUI_ENABLE) ;disable get.. button
	GUICtrlSetState($RefServerBtn, 		$GUI_ENABLE)  ;disable Ref.. button
	GUICtrlSetState($FavServerBtn, 		$GUI_ENABLE)
	GUICtrlSetState($SettingsBtn, 		$GUI_ENABLE)
	GUICtrlSetState($OffLineServeBtn, 	$GUI_ENABLE)
	GUICtrlSetState($ListView1KP, 		$GUI_ENABLE)
	GUICtrlSetState($ListView1KPQ3, 	$GUI_ENABLE)
	GUICtrlSetState($ListView1Q2, 		$GUI_ENABLE)
		GUICtrlSetState($ListView1M, 	$GUI_ENABLE)
		GUICtrlSetState($ListView2M, 	$GUI_ENABLE)
		GUICtrlSetState($ListView3M, 	$GUI_ENABLE)

	If $tabNum = 5 Then
		_GUICtrlTab_SetCurSel($tabGroupGames, 4)
		_GUICtrlTab_ActivateTab($tabGroupGames, 4)
	EndIf
EndFunc
#EndRegion

#Region --> OFFLNE LIST

;========================================================
; --> set offline list
Func offLineKpList()
	DisableUIButtons()
	local const $svNum = 45
	Local $idx=0

	Local $sIP_Port, $tmpArray, $i
	Local $sIP =""
	Local $iPort =0
	Local $arrayOffline[$svNum]

	$arrayOffline[0] = "kp.hambloch.com:31510|Luschen Botmatch"
	$arrayOffline[1] = "kp.hambloch.com:31511|Luschen Hookmatch"
	$arrayOffline[2] = "kp.hambloch.com:31512|Luschen Deathmatch"
	$arrayOffline[3] = "kp.hambloch.com:31515|Luschen COOP"
	$arrayOffline[4] = "kp.hambloch.com:31516|Luschen Gunrace +Bots"
	$arrayOffline[5] = "kp.hambloch.com:31519|Killa's KPZ/CTF"

	$arrayOffline[6] = "130.185.249.124:31510|Newskool Classic Gangbang"
	$arrayOffline[7] = "130.185.249.124:31511|Newskool Instagib"
	$arrayOffline[8] = "130.185.249.124:31512|Newskool Bagman"
	$arrayOffline[9] = "130.185.249.124:31513|Newskool Fragfest"
	$arrayOffline[10] = "130.185.249.124:31514|Newskool CTF"
	$arrayOffline[11] = "130.185.249.124:31515|Newskool Crash Squad"
	$arrayOffline[12] = "130.185.249.124:31516|Newskool Power2"
	$arrayOffline[13] = "130.185.249.124:31517|Newskool Gunrace"

	$arrayOffline[14] = "130.185.249.124:31518|Newskool Killapin"
	$arrayOffline[15] = "130.185.249.124:31531|Newskool Kill Confirmed"
	$arrayOffline[16] = "130.185.249.124:31532|Newskool Hitmen"
	$arrayOffline[17] = "130.185.249.124:31533|Newskool Chicken Chase"
	$arrayOffline[18] = "130.185.249.124:31534|Newskool Rocketfest"
	$arrayOffline[19] = "130.185.249.124:31537|Newskool Easter/Summer/Halloween/Xmas"
	$arrayOffline[20] = "130.185.249.124:31538|Newskool Halloween/Xmas CTF"

	$arrayOffline[21] = "202.169.104.136:31211|macanah.mooo.com Street wars MoD"
	$arrayOffline[22] = "202.169.104.136:31355|macanah.mooo.com BOTMATCH"
	$arrayOffline[23] = "202.169.104.136:31510|macanah.mooo.com ffa"
	$arrayOffline[24] = "202.169.104.136:31513|macanah.mooo.com riotz mod"
	$arrayOffline[25] = "202.169.104.136:31515|macanah.mooo.com Jedi Force Mod"
	$arrayOffline[26] = "202.169.104.136:31516|macanah.mooo.com COOP"
	$arrayOffline[27] = "202.169.104.136:31517|macanah.mooo.com BaGmaN"
	$arrayOffline[28] = "202.169.104.136:31518|macanah.mooo.com Assault"
	$arrayOffline[29] = "202.169.104.136:31519|macanah.mooo.com CTF"
	$arrayOffline[30] = "202.169.104.136:31556|macanah.mooo.com Crash Squad"

	$arrayOffline[31] = "168.235.68.219:31512|East Coast Snitch Slappa (Bagman)"
	$arrayOffline[32] = "168.235.68.219:31513|East Coast Deathmatch"
	$arrayOffline[33] = "71.93.144.165:31510|California Carnage"
	$arrayOffline[34] = "208.77.22.94:31510|Dark Fiber FFA Chicago"
	$arrayOffline[35] = "5.1.74.153:31510|Dark Fiber FFA EU"
	$arrayOffline[36] = "148.251.10.210:31510|qw.servegame.org Kingpin server"

	; temp servers
	$arrayOffline[37] = "82.15.31.92:31511|AoM's UK Riotz Server"
	$arrayOffline[38] = "73.64.19.177:31510|DrBrain's Gangbang Server"
	$arrayOffline[39] = "82.169.45.137:31510|Fredz's server"
	$arrayOffline[40] = "84.87.109.134:31510|G()AT's server"
	$arrayOffline[41] = "84.87.109.134:31512|G()AT's test server"
	$arrayOffline[42] = "hypo.hambloch.com:31510|hypo_v8's server"
	$arrayOffline[43] = "93.41.146.9:31510|ITA KP Server"
	$arrayOffline[44] = "82.69.95.83:31510|Killa's Home server"


	resetArray()
	$bOffline 		= True
	_GUICtrlListView_DeleteAllItems($ListView1KP)

	For $i = 0 To ($svNum -1)
		$tmpArray = StringSplit($arrayOffline[$i],"|", $STR_NOCOUNT)
		$sIP_Port = StringSplit($tmpArray[0], ":", $STR_NOCOUNT)

		$sIP = TCPNameToIP($sIP_Port[0])
		$iPort = $sIP_Port[1]
		Local $sNewAdress = String($sIP &":" & $iPort)

		;GUICtrlCreateListViewItem($i, $ListView1KP) ;fill array with index num
		_GUICtrlListView_AddItem($ListView1KP, $i, -1)
		_GUICtrlListView_AddSubItem($ListView1KP, $i, $sNewAdress,	1) ;ip_port
		_GUICtrlListView_AddSubItem($ListView1KP, $i, $tmpArray[1],	2) ;name
		_GUICtrlListView_AddSubItem($ListView1KP, $i, "999",		3) ;ping
		_GUICtrlListView_AddSubItem($ListView1KP, $i, "0/0",		4) ; players

		;fill globbal server array in memory
		$sServerStringArray[$i][0] = String("hostname\"& $tmpArray[1] &"\" & @LF) ;hostname\host_xxx\@lf
		$sServerStringArray[$i][1] = $sIP
		$sServerStringArray[$i][2] = int($iPort)-10 ;store kp listen port in memory array but display game port
		$sServerStringArray[$i][4] = int($iPort) ;set gamespy reported game port
	Next
	$iServerCountTotal = $svNum
EndFunc ; -->offline kp list

;=====================
; --> set offline KPQ3 list
Func offLineKpQ3List()
	Local $sIP_Port, $tmpArray, $i
	Local $sIP =""
	Local $iPort =0
	Local $arrayOfflineKPQ3[8]

	$arrayOfflineKPQ3[0] = string('www.kingpinq3.com:31610|KingpinQ3 Server 4')
	$arrayOfflineKPQ3[1] = string('www.kingpinq3.com:31611|Bagman development server')
	$arrayOfflineKPQ3[2] = string('www.kingpinq3.com:31640|KingpinQ3 Server 5')
	$arrayOfflineKPQ3[3] = string('www.kingpinq3.com:31670|KingpinQ3 hitmen Server')
	$arrayOfflineKPQ3[4] = string('202.169.104.136:24910|KPQ3 FFA AUS')
	;;;;temp servers
	$arrayOfflineKPQ3[5] = string('0.0.0.127:31510|  --== TEMPORARY SERVERS ==--  ')
	$arrayOfflineKPQ3[6] = string('110.175.51.202:31600|KingpinQ3 hypo_v8')
	$arrayOfflineKPQ3[7] = string('110.175.51.202:31610|KingpinQ3 hypo_v8')

	resetArray()
	$bOfflineKPQ3 	= True

	_GUICtrlListView_DeleteAllItems($ListView1KPQ3)

	For $i = 0 To 7
		$tmpArray = StringSplit($arrayOfflineKPQ3[$i],"|", $STR_NOCOUNT)
		$sIP_Port = StringSplit($tmpArray[0], ":", $STR_NOCOUNT)

		$sIP = TCPNameToIP($sIP_Port[0])
		$iPort = Int($sIP_Port[1])
		Local $sNewAdress = String($sIP &":" & $iPort)

		;$iListVewIDKPQ3[$i] = GUICtrlCreateListViewItem($i, $ListView1KPQ3) ;fill array with index num
		_GUICtrlListView_AddItem($ListView1KPQ3, $i, -1)
		_GUICtrlListView_AddSubItem($ListView1KPQ3, $i, $sNewAdress,	1)
		_GUICtrlListView_AddSubItem($ListView1KPQ3, $i, $tmpArray[1],	2)
		_GUICtrlListView_AddSubItem($ListView1KPQ3, $i, "999",			3)
		_GUICtrlListView_AddSubItem($ListView1KPQ3, $i, "0/0",			4)

		;fill globbal server array in memory
		$sServerStringArrayKPQ3[$i][0] = String("hostname\"& $tmpArray[1] &"\" & @LF) ;hostname\host_xxx\@lf
		$sServerStringArrayKPQ3[$i][1] = $sIP
		$sServerStringArrayKPQ3[$i][2] = $iPort
	Next
	$iServerCountTotal = 8
EndFunc

;=====================
; --> set offline KPQ3 list
Func offLineQ2List()
	Local $sIP_Port, $tmpArray, $i
	Local $sIP =""
	Local $iPort =0
	Local $arrayOfflineQ2[14]

	$arrayOfflineQ2[0] = string('kp.servegame.com:27910|Luschen Quakematch')
	$arrayOfflineQ2[1] = string('202.169.104.136:56342|macanah-lurker.2fh.co CTF q2')
	$arrayOfflineQ2[2] = string('202.169.104.136:27712|macanah-lurker.2fh.co Ddayq2')
	$arrayOfflineQ2[3] = string('202.169.104.136:27916|macanah-lurker.2fh.co q2 ActioN')
	$arrayOfflineQ2[3] = string('202.169.104.136:27988|macanah-lurker.2fh.co q2 awaken2 assault')
	$arrayOfflineQ2[4] = string('202.169.104.136:27933|macanah-lurker.2fh.co q2 awaken2 ctf')
	$arrayOfflineQ2[5] = string('202.169.104.136:27934|macanah-lurker.2fh.co q2 Brazen CooP http')
	$arrayOfflineQ2[6] = string('202.169.104.136:27935|macanah-lurker.2fh.co q2 COOP')
	$arrayOfflineQ2[7] = string('202.169.104.136:27913|macanah-lurker.2fh.co q2 coop-gibrack-mod')
	$arrayOfflineQ2[8] = string('202.169.104.136:27910|macanah-lurker.2fh.co q2 FFA tourney')
	$arrayOfflineQ2[9] = string('202.169.104.136:32888|macanah-lurker.2fh.co q2 Holy Wars')
	$arrayOfflineQ2[10] = string('202.169.104.136:27915|macanah-lurker.2fh.co q2 JumP')
	$arrayOfflineQ2[11] = string('202.169.104.136:44444|macanah-lurker.2fh.co q2 MatriX')
	$arrayOfflineQ2[12] = string('202.169.104.136:27911|macanah-lurker.2fh.co q2 rocket arena')
	$arrayOfflineQ2[13] = string('202.169.104.136:27990|macanah-lurker.2fh.co q2OPENTDM')

	resetArray()
	$bOfflineQ2 	= True
	_GUICtrlListView_DeleteAllItems($ListView1Q2)

	For $i = 0 To 13
		$tmpArray = StringSplit($arrayOfflineQ2[$i],"|", $STR_NOCOUNT)
		$sIP_Port = StringSplit($tmpArray[0], ":", $STR_NOCOUNT)

		$sIP = TCPNameToIP($sIP_Port[0])
		$iPort = Int($sIP_Port[1])
		Local $sNewAdress = String($sIP &":" & $iPort)

		;GUICtrlCreateListViewItem($i, $ListView1Q2) ;fill array with index num
		_GUICtrlListView_AddItem($ListView1Q2, $i, -1)
		_GUICtrlListView_AddSubItem($ListView1Q2, $i, $sNewAdress,	1)
		_GUICtrlListView_AddSubItem($ListView1Q2, $i, $tmpArray[1],	2)
		_GUICtrlListView_AddSubItem($ListView1Q2, $i, "999",		3)
		_GUICtrlListView_AddSubItem($ListView1Q2, $i, "0/0",			4)

		;fill globbal server array in memory
		$sServerStringArrayQ2[$i][0] = String("hostname\"& $tmpArray[1] &"\" & @LF) ;hostname\host_xxx\@lf
		$sServerStringArrayQ2[$i][1] = $sIP
		$sServerStringArrayQ2[$i][2] = $iPort
	Next
	$iServerCountTotal = 14
	EnableUIButtons()
EndFunc


; -->offline kp list
;========================================================

#EndRegion --> END OFFLINE LIST

#Region --> BUTTON STATUS
;========================================================
; --> serverRefreshButtonState
Func serverRefreshButtonState()
	Local $finish = 0

	if $isGettingServers = 0 Then Return 1 ;finished
	If $iServerCountTotal = $iServerCountAdd Then	$finish = 1
	If $iServerCountTotal = 0 Then $finish = 0
	if $isGettingServers = -1 Then $finish = 1 ; if getting master list failed or no list at all
	If TimerDiff($serverRefreshTimer) > 3000 Then $finish = 1 ; hypo moved to last check
		;goto end
	If $finish = 0 Then Return 0 ;not finished

	$iServerCountTotal = 0
	$iServerCountAdd = 0
	$isGettingServers = 0
	ListviewResetSortOrder()
	GUICtrlSetData($ProgressBar, 0)
	_GUICtrlListView_Arrange($ListView1KP,0)
	EnableUIButtons()
	Return 1 ;finished
EndFunc; -->
;========================================================
#EndRegion END REFRESH BUTTON

#Region --> BUTTON OFFLINE
GUICtrlSetOnEvent($OffLineServeBtn, "LoadOffline")
	Func LoadOffline()
		DisableUIButtons()
		If $tabNum = 1 Or $tabNum >3  Then
			offLineKpList()
		ElseIf $tabNum = 2 Then
			offLineKpQ3List()
		ElseIf $tabNum = 3	Then
			offLineQ2List()
		EndIf
		EnableUIButtons()
	EndFunc
#EndRegion

#Region --> BUTTON PING LIST  ( also used in SERVER/OFFLINE LIST)

;refresh server in listview. dont talk to master
GUICtrlSetOnEvent($RefServerBtn, "RefreshServers")
	Func RefreshServers() ;allready in listview from master/offline
		SelectedTabNum()

		If $tabNum = 6 Then
			MRefresh() ;refresh mbrowser
			Return
		EndIf

		Local $i
		Local $aIPArrayRef[0] ;Dim
		Local $sIP =""
		Local $iPort =0
		Local $bSort = False
		Local $iState = -1 ;old sort state
		Local $jState ;1=tmp, 2=old

		DisableUIButtons()
		_BIND_SERVER_SOCKET()
		If $hSocketServerUDP > 0 Then _SetPacketBufferSize($hSocketServerUDP, 25600)

		$GS_countPlayers =0

		$isGettingServers = 1
		$iServerCountTotal = 0 ;get # servers to use later to stop refresh


		If $tabNum = 1 Or $tabNum >3 Then
			$iLastListviewSortStatus = GUICtrlGetState($ListView1KP); set global sort for reset
			_GUICtrlListView_DeleteAllItems($ListView1KP)
			For $i = 0 To $iMaxSer -1
				If $sServerStringArray[$i][2] > 0 Then
					$sServerStringArray[$i][0] = "" ;hypo reset server strings. effects GS
					$sIP = $sServerStringArray[$i][1]
					$iPort = $sServerStringArray[$i][2]
					ReDim $aIPArrayRef[$i+1]
					$aIPArrayRef[$i] = String($sIP & ":" & $iPort) ;add ip/port to array
					$iServerCountTotal += 1

					$iPort = Int($iPort)+10

					_GUICtrlListView_AddItem($ListView1KP, $i, -1)
					_GUICtrlListView_AddSubItem($ListView1KP, $i, String($sIP&":"& $iPort),	1,-1)
					_GUICtrlListView_AddSubItem($ListView1KP, $i, "???",					2,-1)
					_GUICtrlListView_AddSubItem($ListView1KP, $i, "999",					3,-1)
					_GUICtrlListView_AddSubItem($ListView1KP, $i, "0/0",					4,-1)
				Else
					ExitLoop(1)
				EndIf
			Next
		ElseIf $tabNum = 2 Then
				$iLastListviewSortStatusKPQ3 = GUICtrlGetState($ListView1KPQ3); set global sort for reset
				_GUICtrlListView_DeleteAllItems($ListView1KPQ3)
			For $i = 0 To $iMaxSer -1
				If $sServerStringArrayKPQ3[$i][2] >0 Then
					$sServerStringArrayKPQ3[$i][0] = "" ;hypo reset server strings. effects GS
					$sIP = $sServerStringArrayKPQ3[$i][1]
					$iPort = $sServerStringArrayKPQ3[$i][2]
					ReDim $aIPArrayRef[$i+1]
					$aIPArrayRef[$i]= String($sIP & ":" & $iPort) ;add ip/port to array
					$iServerCountTotal += 1

					_GUICtrlListView_AddItem($ListView1KPQ3, $i, -1)
					_GUICtrlListView_AddSubItem($ListView1KPQ3, $i, String($sIP&":"& $iPort),	1,-1)
					_GUICtrlListView_AddSubItem($ListView1KPQ3, $i, "???",						2,-1)
					_GUICtrlListView_AddSubItem($ListView1KPQ3, $i, "999",						3,-1)
					_GUICtrlListView_AddSubItem($ListView1KPQ3, $i, "0/0",						4,-1)
				Else
					ExitLoop(1)
				EndIf
			Next
		ElseIf	$tabNum = 3 Then
			$iLastListviewSortStatusQ2 = GUICtrlGetState($ListView1Q2); set global sort for reset
			_GUICtrlListView_DeleteAllItems($ListView1Q2)
			For $i = 0 To $iMaxSer -1
				If $sServerStringArrayQ2[$i][2] >0 Then
					$sServerStringArrayQ2[$i][0] = "" ;hypo reset server strings. effects GS
					$sIP = $sServerStringArrayQ2[$i][1]
					$iPort = $sServerStringArrayQ2[$i][2]
					ReDim $aIPArrayRef[$i+1]
					$aIPArrayRef[$i]= String($sIP & ":" & $iPort) ;add ip/port to array
					$iServerCountTotal += 1

					_GUICtrlListView_AddItem($ListView1Q2, $i, -1)
					_GUICtrlListView_AddSubItem($ListView1Q2, $i, String($sIP&":"& $iPort),	1,-1)
					_GUICtrlListView_AddSubItem($ListView1Q2, $i, "???",					2,-1)
					_GUICtrlListView_AddSubItem($ListView1Q2, $i, "999",					3,-1)
					_GUICtrlListView_AddSubItem($ListView1Q2, $i, "0/0",					4,-1)
				Else
					ExitLoop(1)
				EndIf
			Next
		EndIf

		Local $j =0

;button refresh. NOT using master

		;not array
		If UBound($aIPArrayRef) = 0 Then
			$isGettingServers = -1
			serverRefreshButtonState()
		Else
			For $i = 0 To UBound($aIPArrayRef)-1

				If $i = $j+Int($iMaxIP-1) Then ;0 to 24
					ConsoleWrite("!servers inital1= "& $i-Int($iMaxIP-1) &"to" &$i & " total= "&$iServerCountTotal&@CRLF)
					If SendSTATUStoServers($aIPArrayRef, $i-Int($iMaxIP-1), $i ) Then ;get each server details
						listenIncommingServers(0) ;now listen for responce
						$j = Int($i+1)
					EndIf
				EndIf
			Next

			;get last of servers
			If $j < $iServerCountTotal Then
				ConsoleWrite("!servers final1= "& $j& "to"&$iServerCountTotal&" int= "& $i&@CRLF)
				If SendSTATUStoServers($aIPArrayRef, $j, $i) Then ;get each server details
					listenIncommingServers(0) ;now listen for responce

				EndIf
			EndIf

			;check global recieved servers. if some failed. try recieve again
			;for x2? hypo todo: & change time?
			Local $iLoop
			for $iLoop =0 To 3
				If $isGettingServers And $iServerCountAdd < $iServerCountTotal Then
					ConsoleWrite("!Some servers failed to respond. Sending status again"&@CRLF)
					;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;hypo send ping to list 4 more times
					Local $countServ1 = GetServerCountInArray() ;count servers in array
					Local $count =0
					For $int = 0 To $countServ1-1
						If	($tabNum = 1) Or ($tabNum > 3) Then
							If $sServerStringArray[$int][0] = "" Then
								;todo reset ping
								SendSTATUStoServers($aIPArrayRef, $int, $int)
								$count += 1
							EndIf
						ElseIf $tabNum =2 Then
							If $sServerStringArrayKPQ3[$int][0] = "" Then
								SendSTATUStoServers($aIPArrayRef, $int, $int)
								$count += 1
							EndIf
						ElseIf	$tabNum = 3 Then
							If $sServerStringArrayQ2[$int][0] = "" Then
								SendSTATUStoServers($aIPArrayRef, $int, $int)
								$count += 1
							EndIf
						EndIf

					Next
					ConsoleWrite("!count= "&$count&@CRLF)
					If 	$count >0 Then
						listenIncommingServers(1)
					EndIf
					;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				EndIf
			Next

		EndIf

		_UDPCloseSocket($hSocketServerUDP)
		$isGettingServers = -1
		serverRefreshButtonState()

		If _IsChecked($GB_Players_sound) Then	selectAudoToPlay(1)

	EndFunc
#EndRegion

#Region --> BUTTON FAV
;load fave per game tab, refresh them to
GUICtrlSetOnEvent($FavServerBtn, "FavArrayLoad")
	Func FavArrayLoad()
		Local $ListViewA, $sIP_Port, $sIP, $iPort
		SelectedTabNum()
		resetArray()

		If $tabNum = 1 Or $tabNum >3 And Not ($tabNum =6) Then
			_GUICtrlListView_DeleteAllItems($ListView1KP)
			Local $j = 0
			For $i = 0 to UBound($aFavKP)-1
				ConsoleWrite("fav num = " &$i& " tab num " & $tabNum & @CRLF)
				If Not ($aFavKP[$i] = "") Then
					GUICtrlCreateListViewItem($i, $ListView1KP) ;fill array with index num
					_GUICtrlListView_AddSubItem($ListView1KP, $i, $aFavKP[$i],	1)
					_GUICtrlListView_AddSubItem($ListView1KP, $i, "???",	2)

					;fill globbal server array in memory
					$sIP_Port = StringSplit($aFavKP[$i], ":", $STR_NOCOUNT)
					If Not @error Then
						$sIP = TCPNameToIP($sIP_Port[0])
						$iPort = Int($sIP_Port[1]) ; Int($sIP_Port[1]) - 10
						$sServerStringArray[$j][0] = String("hostname\FavKP# "& $i+1 &"\" & @LF) ;hostname\fav#xx\@lf
						$sServerStringArray[$j][1] = $sIP
						$sServerStringArray[$j][2] = $iPort -10 ;todo: game/gamespy port. store in ini?
						$sServerStringArray[$j][4] = $iPort ;game port
						$j += 1 ;used incase fav has error
					EndIf
				Else
					ConsoleWrite("error in Fav"&@CRLF)
				EndIf
			Next
			If $j > 0 Then RefreshServers()
		ElseIf $tabNum = 2 Then
			_GUICtrlListView_DeleteAllItems($ListView1KPQ3)
			Local $j = 0
			For $i = 0 to UBound($aFavKPQ3)-1
				ConsoleWrite("fav num = " &$i& " tab num " & $tabNum & @CRLF)
				If Not ($aFavKPQ3[$i] = "") Then
					GUICtrlCreateListViewItem($i, $ListView1KPQ3) ;fill array with index num
					_GUICtrlListView_AddSubItem($ListView1KPQ3, $i, $aFavKPQ3[$i],	1)
					_GUICtrlListView_AddSubItem($ListView1KPQ3, $i, "???",	2)

					;fill globbal server array in memory
					$sIP_Port = StringSplit($aFavKPQ3[$i], ":", $STR_NOCOUNT)
					If Not @error Then
						$sIP = TCPNameToIP($sIP_Port[0])
						$iPort = Int($sIP_Port[1]) ; Int($sIP_Port[1]) - 10
						$sServerStringArrayKPQ3[$j][0] = String("hostname\FavKPQ3# "& $i+1 &"\" & @LF) ;hostname\fav#xx\@lf
						$sServerStringArrayKPQ3[$j][1] = $sIP
						$sServerStringArrayKPQ3[$j][2] = $iPort
						$j += 1 ;used incase fav has error
					EndIf
				Else
					ConsoleWrite("error in string???"&@CRLF)
				EndIf
			Next
			If $j > 0 Then RefreshServers()
		ElseIf $tabNum = 3 Then
			_GUICtrlListView_DeleteAllItems($ListView1Q2)
			Local $j = 0
			For $i = 0 to UBound($aFavQ2)-1
				ConsoleWrite("fav num = " &$i& " tab num " & $tabNum & @CRLF)
				If not ($aFavQ2[$i] = "") Then
					GUICtrlCreateListViewItem($i, $ListView1Q2) ;fill array with index num
					_GUICtrlListView_AddSubItem($ListView1Q2, $i, $aFavQ2[$i],	1)
					_GUICtrlListView_AddSubItem($ListView1Q2, $i, "???",	2)

					;fill globbal server array in memory
					$sIP_Port = StringSplit($aFavQ2[$i], ":", $STR_NOCOUNT)
					If Not @error Then
						$sIP = TCPNameToIP($sIP_Port[0])
						$iPort = Int($sIP_Port[1]) ; Int($sIP_Port[1]) - 10
						$sServerStringArrayQ2[$j][0] = String("hostname\FavQ2# "& $i+1 &"\" & @LF) ;hostname\fav#xx\@lf
						$sServerStringArrayQ2[$j][1] = $sIP
						$sServerStringArrayQ2[$j][2] = $iPort
						$j += 1 ;used incase fav has error
					EndIf
				Else
					ConsoleWrite("error in string???"&@CRLF)
				EndIf
			Next
			If $j > 0 Then RefreshServers()
		EndIf
	EndFunc
#EndRegion

#Region --> EVENT MOUSE

Global  enum $ContextKP_Connect = 2800, $ContexKP_Refresh, $ContexKP_AddFav, $ContexKP_RemFav, _
			$ContexKP_RefreshM, $ContextKP_ConnectM, $ContexKP_AddFavM, $ContexKP_RemFavM, _
			$ContextKP_CopyIP, $ContexKP_GetInfoM  ; these are used in menu definition to link to WM_COMMAND

Global $bEventStartKingpin = False 	;while loop call for $WM_NOTIFY
Global $bEventRightClick = False 	;while loop call for $WM_NOTIFY
Global $bEventRightClickM = False 	;while loop call for $WM_NOTIFY


Func RighttClickMenuKP()
	Local $ListViewA = ServerArray1ToFill()
	Local $hMenu

	ConsoleWrite("right click" &@CRLF)
	$hMenu = _GUICtrlMenu_CreatePopup()
	_GUICtrlMenu_AddMenuItem($hMenu, "Refresh", $ContexKP_Refresh)
	_GUICtrlMenu_AddMenuItem($hMenu, "", 0)
	_GUICtrlMenu_AddMenuItem($hMenu, "Connect", $ContextKP_Connect)
	_GUICtrlMenu_AddMenuItem($hMenu, "", 0)
		_GUICtrlMenu_AddMenuItem($hMenu, "Copy IP", $ContextKP_CopyIP)
	_GUICtrlMenu_AddMenuItem($hMenu, "", 0)
	_GUICtrlMenu_AddMenuItem($hMenu, "Add Fav", $ContexKP_AddFav)
	_GUICtrlMenu_AddMenuItem($hMenu, "Remove Fav", $ContexKP_RemFav)
		Switch _GUICtrlMenu_TrackPopupMenu($hMenu, $HypoGameBrowser, -1, -1, 1, 1, 2)
			Case $ContexKP_Refresh
				RefreshSingle()
			Case $ContextKP_Connect
				Start_Kingpin()
			Case $ContexKP_AddFav
				FavArrayAdd()
			Case $ContexKP_RemFav
				FavArrayRemove()
			Case $ContextKP_CopyIP
				CopyIPToClipKP()

		EndSwitch
	_GUICtrlMenu_DestroyMenu($hMenu)
EndFunc

Func RighttClickMenuM()
	Local $ListViewA = ServerArray1ToFill()
	Local $hMenuMBr
	$hMenuMBr = _GUICtrlMenu_CreatePopup()
	_GUICtrlMenu_AddMenuItem($hMenuMBr, "M-Refresh", $ContexKP_RefreshM)
	_GUICtrlMenu_AddMenuItem($hMenuMBr, "", 0)
	_GUICtrlMenu_AddMenuItem($hMenuMBr, "M-Connect", $ContextKP_ConnectM)
	_GUICtrlMenu_AddMenuItem($hMenuMBr, "", 0)
	_GUICtrlMenu_AddMenuItem($hMenuMBr, "M-Add Fav", $ContexKP_AddFavM)
	_GUICtrlMenu_AddMenuItem($hMenuMBr, "M-Remove Fav", $ContexKP_RemFavM)
	_GUICtrlMenu_AddMenuItem($hMenuMBr, "", 0)
	_GUICtrlMenu_AddMenuItem($hMenuMBr, "M-Get Server Info", $ContexKP_GetInfoM)

        Switch _GUICtrlMenu_TrackPopupMenu($hMenuMBr, $HypoGameBrowser, -1, -1, 1, 1, 2)
			Case $ContexKP_RefreshM
				MRefresh()
		    Case $ContextKP_ConnectM
				Start_Kingpin()
			Case $ContexKP_AddFavM
				FavArrayAdd()
			Case $ContexKP_RemFavM
				FavArrayRemove()
			Case $ContexKP_GetInfoM
				GetServerDetailsPopup()
		EndSwitch
	_GUICtrlMenu_DestroyMenu($hMenuMBr)

EndFunc

;$tabGroupGames

GUIRegisterMsg($WM_EXITSIZEMOVE, "WM_NOTIFY")
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
;GUIRegisterMsg($WM_COMMAND, "WM_NOTIFY")

Func WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
	Local $iIDFrom, $iCode, $tNMHDR, $tInfo, $listIndexNum
	If ($hWnd = $HypoGameBrowser) Then
		Switch $iMsg
			Case $WM_EXITSIZEMOVE
				ConsoleWrite("$WM_EXITSIZEMOVE"&@CRLF)
				$guiResized = True
				$wasMaximized = False
				Return $GUI_RUNDEFMSG

			Case $WM_NOTIFY
				$tNMHDR = DllStructCreate($tagNMHDR, $lParam)
				$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
				$iCode = DllStructGetData($tNMHDR, "Code")
				If $isGettingServers = 0 Then
					Switch $iIDFrom
						Case $HypoGameBrowser
							ConsoleWrite("hypobrowser"&@CRLF)

						Case $ListView1KP 			;tab 1 kingpin
							Switch $iCode
								Case $NM_RCLICK, $NM_RDBLCLK 	;mouse2 $NM_DBLCLK
									$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam) ;$tagNMLISTVIEW
									FillSelectedServerStrings(1, DllStructGetData($tInfo, "Index") ) ;false?, tabNum, ListNum
									If DllStructGetData($tInfo, "Index") > -1 Then
										$bEventRightClick = 1
									EndIf
									ConsoleWrite("+-> $NM_RCLICK"&@CRLF)
								Case $NM_CLICK	;mouse1/arrow
									$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
									$listIndexNum = DllStructGetData($tInfo, "Index")
									;If Not $iOldSelectNumKp = $listIndexNum Then
										FillSelectedServerStrings(1, DllStructGetData($tInfo, "Index") ) ;false?, tabNum, ListNum
									;EndIf
									ConsoleWrite("+-> $NM_CLICK"&@CRLF)
								Case $LVN_KEYDOWN;mouse1/arrow //$LVN_ITEMCHANGED
									$tInfo = DllStructCreate($tagNMLVKEYDOWN, $lParam)
									$changedListview = DllStructGetData($tInfo, "Flags") ;2621440=down arrow 2490368=up arrow
									ConsoleWrite("$changedListview= "&$changedListview&@CRLF)
									ConsoleWrite("+-> $LVN_KEYDOWN"&@CRLF)
								Case $NM_DBLCLK, -114
									$bEventStartKingpin = 1
									ConsoleWrite("+-> $NM_DBLCLK"&@CRLF)
							endswitch
						Case $ListView1KPQ3
							Switch $iCode
								Case $NM_RCLICK
									$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
									FillSelectedServerStrings(2, DllStructGetData($tInfo, "Index") ) ;false?, tabNum, ListNum
									If DllStructGetData($tInfo, "Index") > -1 Then
										$bEventRightClick = 1
									EndIf
								Case $NM_CLICK
									$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
									FillSelectedServerStrings(2, DllStructGetData($tInfo, "Index") ) ;false?, tabNum, ListNum
								Case $LVN_KEYDOWN
									$tInfo = DllStructCreate($tagNMLVKEYDOWN, $lParam)
									$changedListview = DllStructGetData($tInfo, "Flags")
								Case $NM_DBLCLK, -114
									$bEventStartKingpin = 1
							endswitch
						Case $ListView1Q2
							Switch $iCode
								Case $NM_RCLICK
									$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
									FillSelectedServerStrings(3, DllStructGetData($tInfo, "Index") ) ;false?, tabNum, ListNum
									If DllStructGetData($tInfo, "Index") > -1 Then
										$bEventRightClick = 1
									EndIf
								Case $NM_CLICK
									$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
									FillSelectedServerStrings(3, DllStructGetData($tInfo, "Index") ) ;false?, tabNum, ListNum
								Case $LVN_KEYDOWN
									$tInfo = DllStructCreate($tagNMLVKEYDOWN, $lParam)
									$changedListview = DllStructGetData($tInfo, "Flags")
								Case $NM_DBLCLK, -114
									$bEventStartKingpin = 1
							endswitch

						;;--> m-browser -----------------------
						Case $ListView1M
							$iMGameType = 1
							Switch $iCode
								Case $NM_RCLICK
									$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam) ;$tagNMLISTVIEW
									If DllStructGetData($tInfo, "Index") > -1 Then
										$bEventRightClickM = 1
									EndIf
								Case $NM_CLICK
									$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
								Case $NM_RETURN
									$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
								Case $NM_DBLCLK, -114
									$bEventStartKingpin = 1
							endswitch
						Case $ListView2M
							$iMGameType = 2
							Switch $iCode
								Case $NM_RCLICK
									$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
									If DllStructGetData($tInfo, "Index") > -1 Then
										$bEventRightClickM = 1
									EndIf
								Case $NM_CLICK
									$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
								Case $NM_RETURN
									$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
								Case $NM_DBLCLK, -114
									$bEventStartKingpin = 1
							endswitch
						Case $ListView3M
							$iMGameType = 3
							Switch $iCode
								Case $NM_RCLICK
									$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
									If DllStructGetData($tInfo, "Index") > -1 Then
										$bEventRightClickM = 1
									EndIf
								Case $NM_CLICK
									$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
								Case $NM_RETURN
									$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
								Case $NM_DBLCLK, -114
									$bEventStartKingpin = 1
							endswitch
					EndSwitch
				EndIf
		EndSwitch
		Return $GUI_RUNDEFMSG
	EndIf
EndFunc   ;==>WM_NOTIFY


Func FavArrayRemove()
	SelectedTabNum()
	Local $ipPort = GetTabSelectedArrayStringIP()
	If $ipPort ="" Then Return

	If $tabNum = 1 Then
		For $i = 0 To UBound($aFavKP)-1
			If StringCompare($ipPort,$aFavKP[$i])=0 Then
				_ArrayDelete($aFavKP, $i)
				ConsoleWrite("fav length= " & UBound($aFavKP)& @CRLF)
				Return ;dont add an existing fav
			EndIf
		Next
	ElseIf	$tabNum = 2 Then
		For $i = 0 To UBound($aFavKPQ3)-1
			If StringCompare($ipPort,$aFavKPQ3[$i])=0 Then
				_ArrayDelete($aFavKPQ3, $i)
				ConsoleWrite("fav length= " & UBound($aFavKPQ3)& @CRLF)
				Return ;dont add an existing fav
			EndIf
		Next
	ElseIf $tabNum = 3 Then
		For $i = 0 To UBound($aFavQ2)-1
			If StringCompare($ipPort, $aFavQ2[$i])=0 Then
				_ArrayDelete($aFavQ2, $i)
				ConsoleWrite("fav length= " & UBound($aFavQ2)& @CRLF)
				Return ;dont add an existing fav
			EndIf
		Next
	ElseIf $tabNum = 6 Then		;--m browser
		If $iMGameType = 1 Then
			For $i = 0 To UBound($aFavKP)-1
				If StringCompare($ipPort,$aFavKP[$i])=0 Then
					_ArrayDelete($aFavKP, $i)
					ConsoleWrite("fav length= " & UBound($aFavKP)& @CRLF)
					Return ;dont add an existing fav
				EndIf
			Next
		ElseIf	$iMGameType = 2 Then
			For $i = 0 To UBound($aFavKPQ3)-1
				If StringCompare($ipPort,$aFavKPQ3[$i])=0 Then
					_ArrayDelete($aFavKPQ3, $i)
					ConsoleWrite("fav length= " & UBound($aFavKPQ3)& @CRLF)
					Return ;dont add an existing fav
				EndIf
			Next
		ElseIf $iMGameType = 3 Then
			For $i = 0 To UBound($aFavQ2)-1
				If StringCompare($ipPort, $aFavQ2[$i])=0 Then
					_ArrayDelete($aFavQ2, $i)
					ConsoleWrite("fav length= " & UBound($aFavQ2)& @CRLF)
					Return ;dont add an existing fav
				EndIf
			Next
		EndIf ;--end M
	EndIf ;--end tabnum
EndFunc


Func FavArrayAdd()
	SelectedTabNum()
	Local $ipPort = GetTabSelectedArrayStringIP()
	Local $i, $tmp
	If $ipPort = "" Then Return ;wont be needed?

	$tmp = StringSplit($ipPort, ":", $STR_NOCOUNT)
	$ipPort = String(TCPNameToIP($tmp[0])&":"& $tmp[1])

	If $tabNum = 1 Then
		For $i = 0 To UBound($aFavKP)-1
			If StringCompare($ipPort, $aFavKP[$i])=0 Then Return ;dont add an existing fav
		Next
		$i = UBound($aFavKP)
		ConsoleWrite("xfav size kp= " &$i+1& " ip= "& $ipPort& @CRLF)
		ReDim $aFavKP[$i+1]
		$aFavKP[$i] = $ipPort
	ElseIf	$tabNum = 2 Then
		For $i = 0 To UBound($aFavKPQ3)-1
			If StringCompare($ipPort,$aFavKPQ3[$i])=0 Then Return ;dont add an existing fav
		Next
		$i = UBound($aFavKPQ3)
		ConsoleWrite("xfav sizekpq3= " &$i+1& " ip= "& $ipPort& @CRLF)
		ReDim $aFavKPQ3[$i+1]
		$aFavKPQ3[$i] = $ipPort
	ElseIf $tabNum = 3 Then
		For $i = 0 To UBound($aFavQ2)-1
			If StringCompare($ipPort ,$aFavQ2[$i])=0 Then Return ;dont add an existing fav
		Next
		$i = UBound($aFavQ2)
		ConsoleWrite("xfav size q2= " &$i+1& " ip= "& $ipPort& @CRLF)
		ReDim $aFavQ2[$i+1]
		$aFavQ2[$i] = $ipPort
	ElseIf 	$tabNum = 6 Then
		If $iMGameType = 1 Then
			For $i = 0 To UBound($aFavKP)-1
				If StringCompare($ipPort,$aFavKP[$i])=0 Then Return ;dont add an existing fav
			Next
			$i = UBound($aFavKP)
			ConsoleWrite("xfav size kp= " &$i+1& " ip= "& $ipPort& @CRLF)
			ReDim $aFavKP[$i+1]
			$aFavKP[$i] = $ipPort
		ElseIf	$iMGameType = 2 Then
			For $i = 0 To UBound($aFavKPQ3)-1
				If StringCompare($ipPort,$aFavKPQ3[$i])=0 Then Return ;dont add an existing fav
			Next
			$i = UBound($aFavKPQ3)
			ConsoleWrite("xfav sizekpq3= " &$i+1& " ip= "& $ipPort& @CRLF)
			ReDim $aFavKPQ3[$i+1]
			$aFavKPQ3[$i] = $ipPort
		ElseIf $iMGameType = 3 Then
			For $i = 0 To UBound($aFavQ2)-1
				If StringCompare($ipPort, $aFavQ2[$i])=0 Then Return ;dont add an existing fav
			Next
			$i = UBound($aFavQ2)
			ConsoleWrite("xfav size q2= " &$i+1& " ip= "& $ipPort& @CRLF)
			ReDim $aFavQ2[$i+1]
			$aFavQ2[$i] = $ipPort
		EndIf ;--end M
	EndIf ;--end tabnum
EndFunc

Func CopyIPToClipKP()
	SelectedTabNum()
	Local $string = GetTabSelectedArrayStringIP()
	If $string = "" Then Return
	ClipPut($string)
EndFunc

#EndRegion --> END RIGHT CLICK EVENT

#Region --> EVENTS GUI
;========================================================
; --> EVENTS

GUISetOnEvent($GUI_EVENT_CLOSE, "ExitScript", $HypoGameBrowser)
	Func ExitScript()
		Local $hTimer = TimerInit()

		_GUICtrlListView_UnRegisterSortCallBack($ListView1KP)
		_GUICtrlListView_UnRegisterSortCallBack($ListView1KPQ3)
		_GUICtrlListView_UnRegisterSortCallBack($ListView1Q2)

		_GUICtrlListView_UnRegisterSortCallBack($ListView3)
		_GUICtrlListView_UnRegisterSortCallBack($ListView3KPQ3)
		_GUICtrlListView_UnRegisterSortCallBack($ListView3Q2)
		TCPShutdown()
		UDPShutdown()
		FileDelete($isTmpFilePath_KP)
		FileDelete($isTmpFilePath_KPQ3)
		FileDelete($isTmpFilePath_Q2Web)
		FileDelete($mLinkFilePathDel)
		FileDelete($mLinkFilePathEnable)
		iniFileSave()
		GUIDelete($MPopupInfo)
		GUIDelete($HypoGameBrowser)
		Exit
	EndFunc   ;==>CLOSEButton

;using refresh button
GUICtrlSetOnEvent ($GetServersBtn, "EventGetMasterServerList")
	Func EventGetMasterServerList()

		SelectedTabNum()
		If $tabNum = 6 Then
			MRefresh() ;refresh mbrowser
			Return
		EndIf
		GetMasterServerList(False, 0)
	EndFunc

;using setup button
GUICtrlSetOnEvent($SettingsBtn, "UseSettingsBtn")
	Func UseSettingsBtn()
		$tabNum = 4
		_GUICtrlTab_ActivateTab($tabGroupGames, 3)
	EndFunc

;using connect chat button
GUICtrlSetOnEvent($ConnectChatBtn,"load_gui")
	Func load_gui()
		GUICtrlSetColor($webObj, $COLOR_YELLOW)
		GUICtrlSetBkColor($webObj, $COLOR_BLACK)
		_IENavigate($webObj,"http://forum.hambloch.com/chat.php?room=kingpin&wio=hypo")
	EndFunc


Func _GDIPlus_GraphicsGetDPIRatio($iDPIDef = 96)
    _GDIPlus_Startup()
    Local $hGfx = _GDIPlus_GraphicsCreateFromHWND(0)
    If @error Then Return SetError(1, @extended, 0)
    Local $aResult
    #forcedef $__g_hGDIPDll, $ghGDIPDll

    $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetDpiX", "handle", $hGfx, "float*", 0)

    If @error Then Return SetError(2, @extended, 0)
    Local $iDPI = $aResult[2]
    Local $aresults[2] = [$iDPIDef / $iDPI, $iDPI / $iDPIDef]
    _GDIPlus_GraphicsDispose($hGfx)
    _GDIPlus_Shutdown()
    Return $aresults
EndFunc   ;==>_GDIPlus_GraphicsGetDPIRatio


;using tabs
GUICtrlSetOnEvent($tabGroupGames, "tab1")
	Func tab1()
		ConsoleWrite("event tabGroup."&@CRLF)

		GUICtrlSetState($GetServersBtn, $GUI_SHOW )
		GUICtrlSetState($FavServerBtn, $GUI_SHOW)
		GUICtrlSetState($OffLineServeBtn, $GUI_SHOW)
		GUICtrlSetState($RefServerBtn, $GUI_SHOW)
		;Local $tabX =
		Switch GUICtrlRead($tabGroupGames)
			Case 0
				$tabNum =1
			Case 1
				$tabNum =2
			Case 2
				$tabNum =3
			Case 3
				$tabNum =4
			Case 4
				$tabNum =5
			Case 5
				$tabNum =6
				;GUICtrlSetState($ListView1Q2, $GUI_DISABLE)
				GUICtrlSetState($RefServerBtn, $GUI_HIDE)
				GUICtrlSetState($FavServerBtn, $GUI_HIDE)
				GUICtrlSetState($OffLineServeBtn, $GUI_HIDE)
			Case Else
				$tabNum =1
				ConsoleWrite("no tab. using tab=1"&@CRLF)
		EndSwitch
	EndFunc

;sort servers kp
GUICtrlSetOnEvent($ListView1KP,"SortList1")
	Func	SortList1()
		_GUICtrlListView_SortItems($ListView1KP, GUICtrlGetState($ListView1KP))
	EndFunc
;sort servers kpq3
GUICtrlSetOnEvent($ListView1KPQ3,"SortList1KPQ3")
	Func	SortList1KPQ3()
		_GUICtrlListView_SortItems($ListView1KPQ3, GUICtrlGetState($ListView1KPQ3))
	EndFunc
;sort servers quake2
GUICtrlSetOnEvent($ListView1Q2,"SortList1Q2")
	Func	SortList1Q2()
			_GUICtrlListView_SortItems($ListView1Q2, GUICtrlGetState($ListView1Q2))
	EndFunc
;sort server rules kp
GUICtrlSetOnEvent($ListView3,"SortList3")
	Func	SortList3()
		_GUICtrlListView_SortItems($ListView3, GUICtrlGetState($ListView3))
	EndFunc
;sort server rules kpq3
GUICtrlSetOnEvent($ListView3KPQ3,"SortList3KPQ3")
	Func	SortList3KPQ3()
		_GUICtrlListView_SortItems($ListView3KPQ3, GUICtrlGetState($ListView3KPQ3))
	EndFunc
;sort server rules quake2
GUICtrlSetOnEvent($ListView3Q2,"SortList3Q2")
	Func	SortList3Q2()
			_GUICtrlListView_SortItems($ListView3Q2, GUICtrlGetState($ListView3Q2))
	EndFunc

;game path button kp
GUICtrlSetOnEvent($Button_kp, "EventButton_kp")
	Func EventButton_kp()
		Local $sFile = _WinAPI_OpenFileDlg('', @WorkingDir, 'Kingpin.exe (*.exe)|All Files (*.*)', 1, '', '', _
											BitOR($OFN_PATHMUSTEXIST, $OFN_FILEMUSTEXIST, $OFN_HIDEREADONLY))
		If Not @error Then
			GUICtrlSetData( $path_Kingpin,$sFile)
		EndIf
	EndFunc
;game path button kpq3
GUICtrlSetOnEvent($Button_kpq3, "EventButton_kpq3")
	Func EventButton_kpq3()
		Local $sFile = _WinAPI_OpenFileDlg('', @WorkingDir, 'KingpinQ3-32.exe (*.exe)|All Files (*.*)', 1, '', '', _
											BitOR($OFN_PATHMUSTEXIST, $OFN_FILEMUSTEXIST, $OFN_HIDEREADONLY))
		If Not @error Then
			GUICtrlSetData( $path_KPQ3 ,$sFile)
		EndIf
	EndFunc
;game path button quake2
GUICtrlSetOnEvent($Button_q2,"EventButton_q2")
	Func EventButton_q2()
		Local $sFile = _WinAPI_OpenFileDlg('', @WorkingDir, 'Quake2.exe (*.exe)|All Files (*.*)', 1, '', '', _
											BitOR($OFN_PATHMUSTEXIST, $OFN_FILEMUSTEXIST, $OFN_HIDEREADONLY))
		;Local $quakeEXEName = _WinAPI_GetExtended()
		If Not @error Then
			GUICtrlSetData( $path_Quake2,$sFile)
		EndIf
	EndFunc

;web links
GUICtrlSetOnEvent($Link_KP_info, "Link_KP_infoTXT")
	Func Link_KP_infoTXT()
		ShellExecute("http://www.kingpin.info", 1)	;LinkClick_kpinfo()
	EndFunc
GUICtrlSetOnEvent($Link_ham_chat, "Link_ham_chatTXT")
Func Link_ham_chatTXT()
	ShellExecute("http://forum.hambloch.com/chat.php?room=kingpin", 1)
EndFunc
GUICtrlSetOnEvent($Link_Ham_feedback, "Link_Ham_feedbackTXT")
	Func Link_Ham_feedbackTXT()
		ShellExecute("http://forum.hambloch.com/email.php?u=kingpin&email=@", 1)
	EndFunc
GUICtrlSetOnEvent($Link_Ham_web, "Link_Ham_webTXT")
	Func Link_Ham_webTXT()
				ShellExecute("http://kingpin.hambloch.com/?ref=mbrowser", 1)
	EndFunc
GUICtrlSetOnEvent($Link_kpq3, "Link_kpq3TXT")
	Func Link_kpq3TXT()
		ShellExecute("http://www.kingpinq3.com", 1)
	EndFunc
GUICtrlSetOnEvent($link_hypo_email, "Link_hypoTXT")
	Func Link_hypoTXT()
		ShellExecute("mailto:hypov8@hotmail.com?subject=kingpin", 1)
	EndFunc


; events GUI
GUISetOnEvent($GUI_EVENT_RESIZED, "GuiResized")
	Func GuiResized()
		ConsoleWrite("GuiResized"& @CRLF)
		$guiResized=True
		$wasMaximized = False
	EndFunc

GUISetOnEvent($GUI_EVENT_RESTORE, "GuiEventRestore_use")
	Func GuiEventRestore_use()
		ConsoleWrite("GuiEventRestore_use"&@CRLF)

		if $wasMinimized Then
			if $wasMaximized Then
				GuiSetState(@SW_MAXIMIZE, $HypoGameBrowser)
				$wasMaximized = True
			Else
				GuiSetState(@SW_RESTORE, $HypoGameBrowser)
				$wasMaximized = False
			EndIf
		Else
			if $wasMaximized Then
				GuiSetState(@SW_RESTORE, $HypoGameBrowser)
				$wasMaximized = False
			Else
				GuiSetState(@SW_MAXIMIZE, $HypoGameBrowser)
				$wasMaximized = True
			EndIf
		EndIf
		$wasMinimized = False
		$guiResized = True
	EndFunc

GUISetOnEvent($GUI_EVENT_MAXIMIZE, "GuiEventMaximize_use")
	Func GuiEventMaximize_use()
		ConsoleWrite("GuiEventMaximize_use"&@CRLF)
		$wasMaximized = True
		$wasMinimized = False
		GuiSetState(@SW_MAXIMIZE, $HypoGameBrowser)
		$guiResized = False ;True //hypo stop storing resize info on maximize
		;ConsoleWrite("GuiEventMaximize_use setSize"&@CRLF)
	EndFunc

GUISetOnEvent($GUI_EVENT_MINIMIZE, "GuiEventMinimize_use")
	Func GuiEventMinimize_use()
		ConsoleWrite("GuiEventMinimize_use " &@CRLF)
		GuiSetState(@SW_MINIMIZE,  $HypoGameBrowser)
		$wasMinimized = True
	EndFunc


	Func SetWinSizeForMinimize()
		Local $getWinState = WinGetState($HypoGameBrowser)
		Local $posi[4]

		if Not BitAND($getWinState,16) Then
			$posi = WinGetPos($HypoGameBrowser)
			If ($posi[0] >= -4) And ($posi[1] >= -4) Then
				$StoredWinSize = $posi
				ConsoleWrite("Store gui size"&@CRLF)
			EndIf
		EndIf
	EndFunc

;==> settings
;startup M browser checkbox
GUICtrlSetOnEvent($StartupMChkBox, "StartupMChkBoxToggle")
	Func StartupMChkBoxToggle()
			If _IsChecked($StartupMChkBox) Then
			$useMStartup = 1
		Else
			$useMStartup = 0
		EndIf
	EndFunc

;gamespy auto refresh checkbox
GUICtrlSetOnEvent($GB_RB_Kingpin, "Select_game_KP")
	Func Select_game_KP()
		ConsoleWrite("!Select_game_KP" &@CRLF)
		If _IsChecked( $GB_RB_Kingpin) Then
			GUICtrlSetState( $GB_RB_Kingpin, $GUI_CHECKED)
			GUICtrlSetState( $GB_RB_KingpinQ3, $GUI_UNCHECKED)
			GUICtrlSetState( $GB_RB_Quake2, $GUI_UNCHECKED)
			$GS_lastRefreshTime = TimerInit() ;restart refresh time
		Else
			GUICtrlSetState( $GB_RB_Kingpin, $GUI_UNCHECKED)
		EndIf
	EndFunc
;gamespy auto refresh checkbox
GUICtrlSetOnEvent($GB_RB_KingpinQ3, "Select_game_KPQ3")
	Func Select_game_KPQ3()
		If _IsChecked( $GB_RB_KingpinQ3) Then
			GUICtrlSetState( $GB_RB_KingpinQ3, $GUI_CHECKED)
			GUICtrlSetState( $GB_RB_Kingpin, $GUI_UNCHECKED)
			GUICtrlSetState( $GB_RB_Quake2, $GUI_UNCHECKED)
			$GS_lastRefreshTime = TimerInit()
		Else
			GUICtrlSetState( $GB_RB_Kingpin, $GUI_UNCHECKED)
		EndIf
	EndFunc
;gamespy auto refresh checkbox
GUICtrlSetOnEvent($GB_RB_Quake2, "Select_game_Q2")
	Func Select_game_Q2()
		If _IsChecked($GB_RB_Quake2) Then
			GUICtrlSetState( $GB_RB_Quake2, $GUI_CHECKED)
			GUICtrlSetState( $GB_RB_Kingpin, $GUI_UNCHECKED)
			GUICtrlSetState( $GB_RB_KingpinQ3, $GUI_UNCHECKED)
			$GS_lastRefreshTime = TimerInit()
		Else
			GUICtrlSetState( $GB_RB_Quake2, $GUI_UNCHECKED)
		EndIf
	EndFunc

;gamespy auto refresh sounds checkbox
GUICtrlSetOnEvent($GB_Players_sound, "GB_PlaySounds")
	Func GB_PlaySounds()	;--> SoundChkBoxToggle
				If _IsChecked($GB_Players_sound) Then
					GUICtrlSetState($GB_Players_sound, $GUI_CHECKED)
				Else
					GUICtrlSetState($GB_Players_sound, $GUI_UNCHECKED)
				EndIf
	EndFunc

;master protocol
GUICtrlSetOnEvent($RadioMasterTCP_KPQ3,"RadioMasterTCP_KPQ3")
	Func RadioMasterTCP_KPQ3()
		If _IsChecked($RadioMasterTCP_KPQ3) Then
			GUICtrlSetState($InputKPQ3_proto, $GUI_DISABLE)
			GUICtrlSetState($RadioMasterUDP_KPQ3, $GUI_UNCHECKED)
		else
			GUICtrlSetState($InputKPQ3_proto, $GUI_ENABLE) ;allow protocol change
			GUICtrlSetState($RadioMasterUDP_KPQ3, $GUI_CHECKED)
		EndIf
	EndFunc
;master protocol
GUICtrlSetOnEvent($RadioMasterUDP_KPQ3, "RadioMasterUDP_KPQ3")
	Func RadioMasterUDP_KPQ3()
		If _IsChecked($RadioMasterUDP_KPQ3) Then
			GUICtrlSetState($InputKPQ3_proto, $GUI_ENABLE) ;allow protocol change
			GUICtrlSetState($RadioMasterTCP_KPQ3, $GUI_UNCHECKED)
		else
			GUICtrlSetState($InputKPQ3_proto, $GUI_DISABLE)
			GUICtrlSetState($RadioMasterTCP_KPQ3, $GUI_CHECKED)
		EndIf
	EndFunc

;master to use
GUICtrlSetOnEvent($RadioMaster1KPQ3, "Master1KPQ3")
	Func Master1KPQ3()
		AutoSelectKPQ3_TCP_UDP(1)
		DisableKPQ3_TCP_UDP(1)
	EndFunc
GUICtrlSetOnEvent($RadioMaster2KPQ3, "Master2KPQ3")
	Func Master2KPQ3()
		AutoSelectKPQ3_TCP_UDP(2)
		DisableKPQ3_TCP_UDP(2)
	EndFunc
GUICtrlSetOnEvent($RadioMaster3KPQ3, "Master3KPQ3")
	Func Master3KPQ3()
		AutoSelectKPQ3_TCP_UDP(3)
		DisableKPQ3_TCP_UDP(3)
	EndFunc
GUICtrlSetOnEvent($RadioMaster4KPQ3, "Master4KPQ3")
	Func Master4KPQ3()
		AutoSelectKPQ3_TCP_UDP(4)
		DisableKPQ3_TCP_UDP(4)
	EndFunc

;==> kpq3 udp/tcp selector
	Func DisableKPQ3_TCP_UDP($kpq3MasterNumX)
		if $kpq3MasterNumx=4 Then
			GUICtrlSetState($RadioMasterUDP_KPQ3, 	$GUI_ENABLE)
			GUICtrlSetState($RadioMasterTCP_KPQ3, 	$GUI_ENABLE)
		Else
			GUICtrlSetState($RadioMasterUDP_KPQ3, 	$GUI_DISABLE)
			GUICtrlSetState($RadioMasterTCP_KPQ3, 	$GUI_DISABLE)
		EndIf

		if $kpq3MasterNumx=1 Or $kpq3MasterNumx=3 Or $kpq3MasterNumx=4 Then
			AllowUDP_Input(1)
		Else
			AllowUDP_Input(0)
		EndIf

	EndFunc


	Func AllowUDP_Input($isTrue)
		If $isTrue = 1 Then
			GUICtrlSetState($InputKPQ3_proto, $GUI_ENABLE) ;allow protocol change
		Else
			GUICtrlSetState($InputKPQ3_proto, $GUI_DISABLE)
		EndIf

	EndFunc


	Func AutoSelectKPQ3_TCP_UDP($kpq3MasterNum)
		if $kpq3MasterNum=1 Or $kpq3MasterNum=3 Or $kpq3MasterNum=4 Then
			GUICtrlSetState($RadioMasterUDP_KPQ3, $GUI_CHECKED) ; auto use UDP
			GUICtrlSetState($RadioMasterTCP_KPQ3, $GUI_UNCHECKED)
		else
			GUICtrlSetState($RadioMasterTCP_KPQ3, $GUI_CHECKED) ; auto use TCP
			GUICtrlSetState($RadioMasterUDP_KPQ3, $GUI_UNCHECKED)
		EndIf
	EndFunc
	;==> end q3 udp/tcp selector




GUICtrlSetOnEvent($RadioMasterTCP_Q2,"RadioMasterTCP_Q2")
	Func RadioMasterTCP_Q2()
		If _IsChecked($RadioMasterTCP_Q2) Then
			GUICtrlSetState($RadioMasterUDP_Q2, $GUI_UNCHECKED)
		else
			GUICtrlSetState($RadioMasterUDP_Q2, $GUI_CHECKED)
		EndIf
	EndFunc

GUICtrlSetOnEvent($RadioMasterUDP_Q2, "RadioMasterUDP_Q2")
	Func RadioMasterUDP_Q2()
		If _IsChecked($RadioMasterUDP_Q2) Then
			GUICtrlSetState($RadioMasterTCP_Q2, $GUI_UNCHECKED)
		else
			GUICtrlSetState($RadioMasterTCP_KPQ3, $GUI_CHECKED)
		EndIf
	EndFunc

GUICtrlSetOnEvent($RadioMaster1Q2, "Master1Q2")
	Func Master1Q2()
		AutoSelectQ2_TCP_UDP(1)
		DisableQ2_TCP_UDP(1)
	EndFunc
GUICtrlSetOnEvent($RadioMaster2Q2, "Master2Q2")
	Func Master2Q2()
		AutoSelectQ2_TCP_UDP(2)
		DisableQ2_TCP_UDP(2)
	EndFunc
GUICtrlSetOnEvent($RadioMaster3Q2, "Master3Q2")
	Func Master3Q2()
		AutoSelectQ2_TCP_UDP(3)
		DisableQ2_TCP_UDP(3)
	EndFunc
GUICtrlSetOnEvent($RadioMaster4Q2, "Master4Q2")
	Func Master4Q2()
		AutoSelectQ2_TCP_UDP(4)
		DisableQ2_TCP_UDP(4)
	EndFunc

;==> q2 udp/tcp selector
	Func DisableQ2_TCP_UDP($Q2MasterNumX)
		if $q2MasterNumx=4 Then
			GUICtrlSetState($RadioMasterUDP_Q2,	$GUI_ENABLE)
			GUICtrlSetState($RadioMasterTCP_Q2,	$GUI_ENABLE)
		Else
			GUICtrlSetState($RadioMasterUDP_Q2,	$GUI_DISABLE)
			GUICtrlSetState($RadioMasterTCP_Q2,	$GUI_DISABLE)
		EndIf
	EndFunc

	Func AutoSelectQ2_TCP_UDP($Q2MasterNum)
		if $Q2MasterNum=1 Then
			GUICtrlSetState($RadioMasterHTTP_Q2, $GUI_CHECKED)
			GUICtrlSetState($RadioMasterTCP_Q2, $GUI_UNCHECKED)
			GUICtrlSetState($RadioMasterUDP_Q2, $GUI_UNCHECKED)
		else
			GUICtrlSetState($RadioMasterUDP_Q2, $GUI_CHECKED)
			GUICtrlSetState($RadioMasterTCP_Q2, $GUI_UNCHECKED)
			GUICtrlSetState($RadioMasterHTTP_Q2, $GUI_UNCHECKED)
		EndIf
	EndFunc

;==> end q3 udp/tcp selector

;linked else where
GUICtrlSetOnEvent($add_Server, "ServerAddPortKP")
GUICtrlSetOnEvent($remove_Server, "ServerRemovePortKP")
GUICtrlSetOnEvent($ExcludeSrever, "ServerExcludePortKP")
GUICtrlSetOnEvent($addKPQ3, "TickedGamePortKPQ3")
GUICtrlSetOnEvent($addQuake2, "TickedGamePortQuake")

; --> END EVENTS
;========================================================
#EndRegion --> END MOUSE EVENTS

#Region --> WindowHotkeys

GUICtrlSetOnEvent($opt_minToTray, "MinToTray")
Func MinToTray()
	if _IsChecked($opt_minToTray) Then
		$minToTray = 1
	Else
		$minToTray = 0
	EndIf

EndFunc



GUICtrlSetOnEvent($hotKey_btn, "ApplyhotKeyBtn")

Func ApplyhotKeyBtn()
	ApplyhotKey(1)
EndFunc

;0= startup ini
;1= apply button
Func ApplyhotKey($button = 0)
	If $button = 1 Then
		If StringLen($sHkeyKey)>=1 And StringLen($sHkeyKey)>=1 Then
			HotKeySet($sHkeyPlus & $sHkeyKey);reset
			ConsoleWrite("!HotKey clear '"& $sHkeyKey&"'"&@CRLF)
		EndIf
	EndIf

	$sHkeyKey = GUICtrlRead($hotKey_Input)
	If $sHkeyKey = "" Then Return ;no hotkey. unbound
	$sHkeyKey = StringLower($sHkeyKey)
	$sHkeyKey = StringMid($sHkeyKey, 1, 1)
	GUICtrlSetData($hotKey_Input, $sHkeyKey)


	If StringLen($sHkeyKey)>=2 Or Asc($sHkeyKey) < 97 Or Asc($sHkeyKey) > 122  Then
		GUICtrlSetData($hotKey_Input, "")
		$sHkeyKey=""
		MsgBox($MB_SYSTEMMODAL,"ERROR: HOT KEY","Invalid Hot Key entered."&@CRLF& "Only accepts a-z",0,$HypoGameBrowser)
	Else
		If StringLen($sHkeyKey) = 1 Then
			If _IsChecked($hotKey_alt) Then
				$sHkeyPlus = "!"
			Else
				$sHkeyPlus = "^"
			EndIf
			ConsoleWrite("!HotKey set '"& $sHkeyKey&"'"&@CRLF)
			HotKeySet($sHkeyPlus & $sHkeyKey , "RestoreWindowHotKey")
		EndIf
	EndIf
EndFunc

Func RestoreWindowHotKey()
	ResetRefreshTimmers()

	If $wasMinimized Then
		If $wasMaximized Then
			GuiSetState(@SW_SHOW,  $HypoGameBrowser)
			GuiSetState(@SW_MAXIMIZE,  $HypoGameBrowser)
			$wasMaximized = True
		Else
			GuiSetState(@SW_SHOW,  $HypoGameBrowser)
			GuiSetState(@SW_RESTORE,  $HypoGameBrowser)
			;WinMove($HypoGameBrowser, $HypoGameBrowser, $StoredWinSize[0], $StoredWinSize[1], $StoredWinSize[2], $StoredWinSize[3])
			$wasMaximized = False
		EndIf

		ConsoleWrite("Was minimized " & @CRLF)
		ConsoleWrite("get posi= " & WinGetPos($HypoGameBrowser)[0] &@CRLF)
		ConsoleWrite("posi= " & $StoredWinSize[0]&" "& $StoredWinSize[1] &@CRLF)

	Else ;-->displayed
		If $wasMaximized Then
			GuiSetState(@SW_MAXIMIZE, $HypoGameBrowser)
			ConsoleWrite("Window Maximized " & @CRLF)
			$wasMaximized = True
		Else
			ConsoleWrite("Window Restored " & @CRLF)
			GuiSetState(@SW_RESTORE,  $HypoGameBrowser)
			ConsoleWrite("Window Restored2"& @CRLF)
			$wasMaximized = False
		EndIf

	EndIf
	$wasMinimized = False
EndFunc

;GUICtrlSetOnEvent($hotKey_alt, "")
;GUICtrlSetOnEvent($hotKey_ctrl, "")



#EndRegion --> WindowHotkeys

#Region --> REFRESH SELECTED
Func RefreshSingle()
	ConsoleWrite("RefreshSingle Server"&@CRLF)
	SelectedTabNum()
	DisableUIButtons()
	_BIND_SERVER_SOCKET()

	$isGettingServers = 1
	$iServerCountTotal = 1 ;get # servers to use later to stop refresh
	Local $tmpArray[1]
	Local $oldTime, $compTime, $iPing
	Local $data1,$data2
	Local $ListViewA = ServerArray1ToFill()
	Local $listSelNum = _GUICtrlListView_GetSelectionMark($ListViewA)	;mouse selected num. sort make this change compared to actual server index
	Local $serSelNum = GetTabSelectedStringNumber() 					;server index num
	$iServerCountAdd = 0


	If $tabNum = 1 Or $tabNum > 3 And Not ( $tabNum =6) Then
		$tmpArray[0] =	String($sServerStringArray[$serSelNum][1] &":"& $sServerStringArray[$serSelNum][2])
	Else
		$tmpArray[0] = GetTabSelectedArrayStringIP()
	EndIf

	If $tmpArray[0] ="" Then Return

	ConsoleWrite("ListNum= '"  & $listSelNum &"'  ServerNum= '" &$serSelNum &"'"& @CRLF)
	ConsoleWrite("address= " &$tmpArray[0]&@CRLF)


	$iLastListviewSortStatus = GUICtrlGetState($ListViewA); set global sort for reset. hypo re'sort??

	If SendSTATUStoServers($tmpArray, 0, 0) Then
		GUICtrlSetData($ProgressBar, 50)
		;reset array incase server does not reply, keep name
		_GUICtrlListView_AddSubItem($ListViewA, $listSelNum, "999",			3,-1)	;ping
		_GUICtrlListView_AddSubItem($ListViewA, $listSelNum, "0/0",			4,-1)	;players
		_GUICtrlListView_AddSubItem($ListViewA, $listSelNum, "",			5,-1)	;map
		_GUICtrlListView_AddSubItem($ListViewA, $listSelNum, "",			6,-1) 	;mod

		$oldTime = TimerInit()
		Do
			$data1 = _UDPRecvFrom($hSocketServerUDP,2048,0)
			;$serverRefreshTimer
			If serverRefreshButtonState() Then ;hypo todo: not use button? like ping all
				ConsoleWrite("Net TimeOut. Button state up"&@CRLF)
				ExitLoop ;stop do
			EndIf
		Until IsArray($data1)

		If IsArray($data1) Then
			if StringInStr($data1[0],"Info string length exceeded") Then ;todo: gs port neded?
				$data1[0] = StringReplace($data1[0], "Info string length exceeded" & Chr(10), "",0 )
				ConsoleWrite("trimed = Info string length exceeded"&@CRLF)
			EndIf


			If StringInStr($data1[0], "ÿÿÿÿprint") Then
				$data1[0]=	StringTrimLeft($data1[0],11) ;trim to first "\"
			ElseIf StringInStr($data1[0], "ÿÿÿÿstatusResponse") Then
				$data1[0]=	StringTrimLeft($data1[0], 20) ;trin to first "\"
			ElseIf StringInStr($data1[0], "\gamename\kingpin\") Then
				Local $tmpStrCnt
				$data1[0]=	StringTrimLeft($data1[0], 18) ; the first "\"
				;kingpin gsport. another get if string is to long
				If Not StringInStr($data1[0], "\final\") Then
					$tmpStrCnt = StringInStr($data1[0], "\queryid\")
					If $tmpStrCnt > 0 Then
						$data1[0] = StringLeft($data1[0], $tmpStrCnt-1)
					EndIf
					ConsoleWrite(">ServerStringArray3.0= " & $data1[0] & @CRLF)

					Do
						$data2 = _UDPRecvFrom($hSocketServerUDP,2048,0)
						If serverRefreshButtonState() Then ;hypo todo: not use button? like ping all
							ConsoleWrite("Net TimeOut. Button state up"&@CRLF)
							ExitLoop ;stop do
						EndIf
					Until IsArray($data2)
					;join string
					$data1[0]=String($data1[0]&$data2[0])

				EndIf

				$tmpStrCnt = StringInStr($data1[0], "\final\") ;remove \final\
				If $tmpStrCnt > 0 Then
					$data1[0] = StringLeft($data1[0], $tmpStrCnt-1)
				EndIf
			EndIf
			ConsoleWrite(">ServerStringArray3.2= " & $data1[0] & @CRLF)

			$data1[0] = string( $data1[0]& Chr(10))	;add @LF to end

			If $tabNum = 1 Or $tabNum > 3 Then
				$sServerStringArray[$serSelNum][0] = $data1[0]
			ElseIf $tabNum = 2 Then
				$sServerStringArrayKPQ3[$serSelNum][0] = $data1[0]
			ElseIf $tabNum = 3 Then
				$sServerStringArrayQ2[$serSelNum][0] = $data1[0]
			EndIf


			$iServerCountAdd += 1
			$iPing = Int(TimerDiff($oldTime))

			;fill selected server name etc in list 1
			FillServerListArray($data1, $iPing, $listSelNum );data[0]=string   ;data[1]=ip   ;data[2]=port 11

			;fill player and server var into list 2 and list 3
			If $tabNum =1 Then FillSelectedServerStrings(1, $listSelNum) ;<tabnum> | <selected array num>
			If $tabNum =2 Then FillSelectedServerStrings(2, $listSelNum)
			If $tabNum =3 Then FillSelectedServerStrings(3, $listSelNum)
		EndIf
	EndIf

	_UDPCloseSocket($hSocketServerUDP)
	serverRefreshButtonState()
	;$isPlayersInServer = False ;refresh selected ssets this but never uses it
	$GS_countPlayers = 0 ;reset player count for audio
EndFunc

#EndRegion --> END REFRESH SELECTED

#Region --> RUN GAME EXE
;========================================================
; -->Start_Kingpin ;todo cleanup
Func Start_Kingpin()
	SelectedTabNum()
	Local $rungame, $runCommand, $aArrayPath, $tmpstr, $tmpLen, $trimEXE, $ipSplit, $runName, $iHasGSPort


	Local $ipPort = GetTabSelectedArrayStringIP()
	If $ipPort = "" Then Return ;crashes with no server/ip
	$iHasGSPort = 0

	Local $iGameExe = 0 ;link mbrowser n tab1

	If ($tabNum =1) Then
		Local $serSelNum = GetTabSelectedStringNumber() ;server index num
		If $sServerStringArray[$serSelNum][4] > 0 Then ;gs port num
			$ipPort = String($sServerStringArray[$serSelNum][1] &":"& $sServerStringArray[$serSelNum][4])  ;set gamespy reported game port
			$iHasGSPort = 1
			ConsoleWrite("kingpin, using gamespy port " &$ipPort& @CRLF)
		EndIf
		$iGameExe = 1
	ElseIf ($tabNum =2) Then
		$iGameExe = 2
	ElseIf ($tabNum = 3) Then
		$iGameExe = 3
	ElseIf ($tabNum > 3) And ($tabNum < 6) Then
		$iGameExe = 3
	ElseIf ($tabNum = 6) Then
		ConsoleWrite("tab6"&@CRLF)
		If ($iMGameType = 1) Then
			ConsoleWrite("game1"&@CRLF)
			$iGameExe = 1
		ElseIf ($iMGameType = 2) Then
			ConsoleWrite("game2"&@CRLF)
			$iGameExe = 2
		ElseIf ($iMGameType = 3) Then
			ConsoleWrite("game3"&@CRLF)
			$iGameExe = 3
		EndIf
	EndIf

	ConsoleWrite("iGame= " &$iGameExe &" m-game=" & $iMGameType& " Tabnum="& $tabNum&@CRLF)

	If $iGameExe = 1 Then
		$rungame = GUICtrlRead($path_Kingpin)
		$runCommand = GUICtrlRead($RunKingpinCMD)
		$aArrayPath =StringReverse($rungame)
		$tmpstr = string(StringSplit( $aArrayPath, "\" )[1])
		$tmpLen = StringLen($tmpstr )
		$trimEXE = StringTrimRight($rungame,$tmpLen) ;kingpin.exe ;trim exe to seet active path (stop missing color map issue)
		$ipSplit =	StringSplit($ipPort,":", $STR_NOCOUNT)
		If Not (($iMGameType = 1) And ($iHasGSPort = 1)) Then	$ipSplit[1] +=10 ;add 10 to port for kp ;todo test not??
		$ipPort= String($ipSplit[0]&":" & $ipSplit[1])
		If GUICtrlRead($InputNameKP) Then
			$runName = String(" +set name "&GUICtrlRead($InputNameKP))
		Else
			$runName =""
		EndIf
	ElseIf $iGameExe = 2  Then
		$rungame = GUICtrlRead($path_KPQ3)
		$runCommand = GUICtrlRead($RunKingpinQ3CMD)
		$aArrayPath =StringReverse($rungame)
		$tmpstr = string(StringSplit( $aArrayPath, "\" )[1])
		$tmpLen = StringLen($tmpstr )
		$trimEXE = StringTrimRight($rungame,$tmpLen) ;kingpinq3-x86.exe
		If GUICtrlRead($InputNameKPQ3) Then
			$runName = String(" +set name "&GUICtrlRead($InputNameKPQ3))
		Else
			$runName =""
		EndIf
	ElseIf $iGameExe = 3  Then
		$rungame = GUICtrlRead($path_Quake2)
		$runCommand = GUICtrlRead($RunQuake2CMD)
		$aArrayPath =StringReverse($rungame)
		$tmpstr = string(StringSplit( $aArrayPath, "\" )[1])
		$tmpLen = StringLen($tmpstr )
		$trimEXE = StringTrimRight($rungame,$tmpLen) ;quake2.exe
		If GUICtrlRead($InputNameQ2) Then
			$runName = String(" +set name "&GUICtrlRead($InputNameQ2))
		Else
			$runName =""
		EndIf
	Else
		MsgBox($MB_SYSTEMMODAL, "",  "Select the Game Tab you want to play",0, $HypoGameBrowser )
		ResetRefreshTimmers()
		return
	EndIf

	Local $runpathReg = _WinAPI_RegOpenKey( $HKEY_LOCAL_MACHINE, "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\kingpin.exe", $KEY_QUERY_VALUE)
	Local $msgBoxKeyID, $failedEXE = False

ConsoleWrite(">run= "&$rungame&" >"&$runCommand&" >"&$runName&@CRLF)
	local $cmdString = string( $runCommand &" "& $runName&" +connect " & $ipPort )
	ConsoleWrite ("commans tring=" &$cmdString&@CRLF)

	;==========================================================================
	;run game. first search settings. 2nd search script dir. 3rd check regestry
	If FileExists($rungame) Then
		ConsoleWrite("run cmd any" & @CRLF)
		MinimizeWindow()


		ShellExecute( $rungame ,$cmdString , $trimEXE )
	;==> kingpin
	ElseIf $iGameExe =1 Then
		If $runpathReg Then ;$rungame = "Kingpin.exe" And
			ConsoleWrite("run cmd reg" & @CRLF)
			Local $tData = DllStructCreate('wchar[260]')
			_WinAPI_RegQueryValue($runpathReg, 'Path',$tData)
			MinimizeWindow()
			local $cmdString = string( $runCommand &" "& $runName&" +connect " & $ipPort)

			ShellExecute( 'kingpin.exe' , $cmdString, DllStructGetData($tData, 1))
			_WinAPI_RegCloseKey($runpathReg)
		Else
			$failedEXE = True
		EndIf
	Else
		$failedEXE = True
	EndIf



	If $failedEXE Then ;failed
		If $iGameExe = 1 Then
			$msgBoxKeyID = MsgBox(BitOR($MB_SYSTEMMODAL,$MB_OKCANCEL), "Kingpin Game Path",  "ERROR: Game .exe NOT found in" & _
			@CRLF & $rungame& @CRLF& @CRLF& "Press OK to setup your 'Kingpin' Game Path",0, $HypoGameBrowser )
			if $msgBoxKeyID = 1 Then EventButton_kp() ;file search dialog
		ElseIf $iGameExe = 2 Then
			$msgBoxKeyID = MsgBox(BitOR($MB_SYSTEMMODAL,$MB_OKCANCEL), "KingpinQ3 Game Path",  "ERROR: Game .exe NOT found in" & _
			@CRLF & $rungame& @CRLF& @CRLF& "Press OK to setup your 'KingpinQ3' Game Path",0, $HypoGameBrowser )
			if $msgBoxKeyID = 1 Then EventButton_kpq3() ;file search dialog
		ElseIf $iGameExe = 3 Then
			$msgBoxKeyID = MsgBox(BitOR($MB_SYSTEMMODAL,$MB_OKCANCEL), "Quake2 Game Path",  "ERROR Game .exe NOT found in" & _
			@CRLF & $rungame& @CRLF& @CRLF& "Press OK to setup your 'Quake2' Game Path",0, $HypoGameBrowser )
			if $msgBoxKeyID = 1 Then EventButton_q2() ;file search dialog
		EndIf
		ResetRefreshTimmers()
	EndIf

EndFunc
; -->Start_Kingpin
;========================================================
#EndRegion -->END RUN GAME EXE

#Region --> TRAY EVENTS
;========================================================
;--> tray events
TraySetOnEvent($TRAY_EVENT_PRIMARYUP, "TraySingle")  ;hypo todo: check focus?
	Func TraySingle()
		local $stateMinimized = WinGetState($HypoGameBrowser)

		If  BitAND($stateMinimized,16) Then ; Return ;$WIN_STATE_MINIMIZED
			ConsoleWrite("traySingleClick " & $stateMinimized&@CRLF)
			RestoreWindow()
		Else
			ConsoleWrite("traySingleClick " & $stateMinimized&@CRLF)
			MinimizeWindow()
		EndIf
	EndFunc


TrayItemSetOnEvent($trayMax, "RestoreWindow")
	Func RestoreWindow()
		;DisableUIButtons()
		ResetRefreshTimmers()

		If $wasMinimized Then
			If $wasMaximized Then
				GuiSetState(@SW_SHOW,  $HypoGameBrowser)
				GuiSetState(@SW_MAXIMIZE,  $HypoGameBrowser)
				$wasMaximized = True
			Else
				GuiSetState(@SW_SHOW,  $HypoGameBrowser)
				GuiSetState(@SW_RESTORE,  $HypoGameBrowser)
				;WinMove($HypoGameBrowser, $HypoGameBrowser, $StoredWinSize[0], $StoredWinSize[1], $StoredWinSize[2], $StoredWinSize[3])
				$wasMaximized = False
			EndIf

			ConsoleWrite("Was minimized " & @CRLF)
			ConsoleWrite("get posi= " & WinGetPos($HypoGameBrowser)[0] &@CRLF)
			ConsoleWrite("posi= " & $StoredWinSize[0]&" "& $StoredWinSize[1] &@CRLF)

		Else ;-->displayed
			If $wasMaximized Then
				ConsoleWrite("Window Restored " & @CRLF)
				GuiSetState(@SW_RESTORE,  $HypoGameBrowser)
				ConsoleWrite("Window Restored2"& @CRLF)
				$wasMaximized = False
			Else
				GuiSetState(@SW_MAXIMIZE, $HypoGameBrowser)
				ConsoleWrite("Window Maximized " & @CRLF)
				$wasMaximized = True
			EndIf

		EndIf
		$wasMinimized = False
		;EnableUIButtons()
	EndFunc ;--> tray events

TrayItemSetOnEvent($tray_mini, "MinimizeWindow")
	Func MinimizeWindow()
		Local $getWinState = WinGetState($HypoGameBrowser)
		if BitAND($getWinState,32) Then $wasMaximized = True

		ConsoleWrite("Tray Minimize wasMax= "&$wasMaximized & @CRLF)
		GuiSetState(@SW_MINIMIZE,  $HypoGameBrowser)
		If $minToTray = 1 Then	GuiSetState(@SW_HIDE,  $HypoGameBrowser)
		$wasMinimized = True
	EndFunc


TrayItemSetOnEvent($trayExit, "ExitScript")

;========================================================
#EndRegion  --> TRAY EVENTS

EnableUIButtons(); all loaded, should be ready now
LoadMStartupOpt(); check M-Startup

While 1
	If $bEventStartKingpin = 1 Then
		$bEventStartKingpin = 0
		Start_Kingpin()
	EndIf

	if $changedListview Then
		if $changedListview = 336 Or $changedListview = 328 then ChangedListview_NowFillServerStrings()
		$changedListview = 0
	EndIf

	If $bEventRightClick = 1 Then
		$bEventRightClick = 0
		 RighttClickMenuKP()
	EndIf

	If $bEventRightClickM = 1 Then
		$bEventRightClickM = 0
		 RighttClickMenuM()
	EndIf

	If ($guiResized = True) Then
		Local $hSize = WinGetPos($HypoGameBrowser)
		ConsoleWrite($hSize[2]& " "& $hSize[3] &@CRLF)

		If ($hSize[2] < $GUIMINWID) And ($hSize[3] < $GUIMINHT) Then
			WinMove($HypoGameBrowser, '', Default, Default, $GUIMINWID, $GUIMINHT)
		ElseIf ($hSize[2] < $GUIMINWID) Then
			WinMove($HypoGameBrowser, '', Default, Default, $GUIMINWID, $hSize[3])
		ElseIf ($hSize[3] < $GUIMINHT) Then
			WinMove($HypoGameBrowser, '', Default, Default, $hSize[2], $GUIMINHT)
		EndIf


		SetWinSizeForMinimize() ;store window size for later
		$guiResized = False
	EndIf


	AutoRefreshTimer() ;check time for auto refresh
	Sleep(200)

	If $statusBarChanged Then
		GUICtrlSetData($MOTD_Input , $tmpStatusbarString)
		GUICtrlSetColor($MOTD_Input, 0)
		$statusBarChanged = False
	EndIf


WEnd
