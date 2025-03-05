#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=D:\_code_\hypoBrowser\main\hypo_browser.ico
#AutoIt3Wrapper_Outfile=HypoGameBrowser_1.0.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Comment='Kingpin Game Browser by hypo_v8'
#AutoIt3Wrapper_Res_Description='Game browser for Kingpin, KingpinQ3 and Quake2'
#AutoIt3Wrapper_Res_Fileversion=1.0.4.8
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gspyicons\1.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gspyicons\2.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gspyicons\3.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gspyicons\4.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gspyicons\5.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gspyicons\6.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gspyicons\7.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gspyicons\8.ico
#AutoIt3Wrapper_Res_File_Add=D:\_code_\hypoBrowser\icons\logo_5.bmp,rt_bitmap,logo_1
#AutoIt3Wrapper_AU3Check_Parameters=-d
#Au3Stripper_Parameters=/so /rm
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;======= hypo do not delet above ====================
;icons from https://github.com/XQF/xqf/tree/master/src/xpm
;todo ADD GAMES

Global Const $versionName = "HypoGameBrowser"
Global Const $versionNum = "1.0.4" ;1.0.0
#region ;About
;1.0.1
;      fixed issue with kp refresh. when a servre times out the updated responce may stil get skiped
;1.0.2
;      fixed 'mod' display issue. using 'gametype' from responce now
;      added proper gamespy protocol encrypter. fixes non qtracker master issues. eg.. master.333networks.com
;1.0.3
;      added fix to prevent font scale changing
;      updated offline list.
;1.0.4
;      fixed mbrowser game port
;      updated offline list
;      cleaned up dupe code
;      added kpq3 mLink (need to recheck enable mLinks to update reg)
;      added additional games.
;      cleaned up ui for additional games
;1.0.4.3
;      fixed re-ping un-responsive servers
;      added auto refresh per game option
;      fixed bug in using custom master
;      added alien arena, warsow, jedi outcast, jedi Academy, Star Trek: Elite Force, Soldier of Fortune II, hexen FTE, Heretic FTE, DDay:Normandy
;      cleanup/combined more game arrays
;      added enums to define protocols
;      disable autorefresh value change when active
;      disable error msgbox for autorefresh
;1.0.4.5
;      added multi master option. combine ip's
;      added additional themes
;1.0.4.6
;      fixed TCP using incorrect gameID(auto refresh)
;      cleaned up unused vars
;      moved more msgbox alerts to statusbar
;      allow combine protocols for q3 servers eg(2002|2003)
;      fixed for q3 parsing. now checks for prefix '\'
;      added jedi server challenge
;1.0.4.7
;      added server filters. full/empty/offline
;      moved game config to an ini file. so custom games can be added
;      moved game icons out of .exe and into a sub folder. so user can define them in gameConfig.ini
;      added blue theme
;      settings file now using default autoit .ini functions
;1.0.4.8
;      updated filters code
;      added additional games to config (MOHAA, Tremulous, Xonotic, Q3Rally )
;      fixed typo C2M defines
;      default master set to 1 when loading new game
;      added gameConfig.ini option to hide game
;      added Q3ET protocol. master no support for game filters
;      split setting packet size up/down
;      increased receive packet size, newer games are large single packets.
;      updated gamespy packet reader. handle queryid better for split packets.


;1.0.x todo
;      update offline list.
;      support additional games.
;      option to set max servers to ping per 1000ms. currently 50!!
;      handle GameSpy port with master protocol
;      keep listview sort after refresh
;      1/4 and 3/4 full icon
;      fix game specific checks
;      full/empty not working on all Q3 masters
;      ipv6
;      run query master on separate socket.
;          so it can check for response after getting some servers
;      ...
#EndRegion

#Region ;=> includes
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
#include <GuiEdit.au3>
#include <GuiComboBox.au3>
#include <ComboConstants.au3>
#include <GuiComboBoxEx.au3>
#EndRegion

AutoItSetOption("GUICloseOnESC", 0)

#Region ;=> global Varables

;$NET_PROTOCOL_
Global Enum _
	$NET_PROTOCOL_NONE, _
	$NET_PROTOCOL_TCP, _
	$NET_PROTOCOL_UDP, _
	$NET_PROTOCOL_WEB, _
	$NET_PROTOCOL_HTTP, _
	$NET_PROTOCOL_HTTPS

;listview index
Global Enum _
	$LV_A_IDX, _
	$LV_A_IP, _
	$LV_A_NAME

;recieve packet array
Global Enum _
	$PACKET_DATA, _
	$PACKET_IP, _
	$PACKET_PORT, _
	$PACKET_PING, _
	$PACKET_SIZE = $PACKET_PING, _
	$COUNT_PACKET

Global	$COUNT_GAME_INIT = 3
Global	$COUNT_GAME = $COUNT_GAME_INIT

;tab ID
Global Enum _
	$TAB_GB, _
	$TAB_MB, _
	$TAB_CHAT, _
	$TAB_CFG, _
	$COUNT_TABS ;total tabs count

Global Const $MAX_PLAYERS = 64
Global Const $g_iMaxSer = 750 ; global max servers to get, q2/qw list is huge
Global Const $g_iMaxIP = 50 ;max servers ping will get at once. update
Global Const $GUIMINWID = 824, $GUIMINHT = 650 ;set restricted GUI size

Global Enum _ ;CLEAN SV NAMES
	$CLEAN_NONE, _
	$CLEAN_SOF1, _
	$CLEAN_Q3 ; ^5Name

Global Enum _ ;BOT TYPES
	$BOT_NONE, _
	$BOT_Q2, _ ;wallfly
	$BOT_Q3    ;ping < 2


Global Enum _
	$C2S_NONE, _
	$C2S_Q1, _
	$C2S_Q2, _
	$C2S_Q3, _
	$C2S_MOH, _
	$C2S_HEX2, _
	$C2S_HW, _
	$C2S_GS
Func GetData_C2S($idx)
	Switch $idx
		Case $C2S_NONE
			Return ''
		Case $C2S_Q1
			Return BinaryToString('0x8000000A02')&'QUAKE'
		Case $C2S_HEX2
			Return BinaryToString('0x8000000C02')&'HEXENII'
		Case $C2S_Q2
			Return 'ÿÿÿÿstatus'&@LF
		Case $C2S_Q3
			Return 'ÿÿÿÿgetstatus'&@LF ;&Chr(0)
		Case $C2S_MOH
			Return BinaryToString('0xFFFFFFFF02') &'getstatus'&@LF
		Case $C2S_HW
			Return 'ÿÿÿÿÿstatus'&@LF
		Case $C2S_GS
			Return '\status\'&@LF
	EndSwitch
	Return ''
EndFunc

Global Enum _ ;S2C
	$S2C_NONE, _
	$S2C_Q1, _
	$S2C_HEX2, _
	$S2C_HW, _
	$S2C_Q2, _
	$S2C_Q3, _
	$S2C_GS
Func GetData_S2C($idx)
	;most are ignored. using first '\'
	Switch $idx
		Case $S2C_NONE
			Return ''
		Case $S2C_Q1
			Return ''
		Case $S2C_HEX2
			Return ''
		Case $S2C_HW
			Return 'ÿÿÿÿn'
		Case $S2C_Q2
			Return 'ÿÿÿÿprint'
		Case $S2C_Q3
			Return 'ÿÿÿÿstatusResponse'
		Case $S2C_GS
			Return '\TODO\' ;known by gs port anyway
	EndSwitch
	Return ''
EndFunc

Global Enum _ ;C2M
	$C2M_NONE, _
	$C2M_Q1, _
	$C2M_Q2, _
	$C2M_Q3, _
	$C2M_Q3ET, _ ;no filters
	$C2M_HEX2, _
	$C2M_HW, _
	$C2M_AA, _ ;alien arena
	$C2M_PB2, _
	$C2M_GS
Func GetData_C2M($idx)
	Switch $idx
		Case $C2M_Q1
			Return 'c'&@lf
		Case $C2M_Q2
			Return 'query'&@lf
		Case $C2M_Q3, $C2M_Q3ET
			Return 'ÿÿÿÿgetservers'
		Case $C2M_HEX2
			Return 'ÿc'&chr(0)
		Case $C2M_HW
			Return 'ÿc'&@lf
		Case $C2M_AA
			Return 'ÿÿÿÿquery'&@lf
		Case $C2M_PB2
			Return 'ÿÿÿÿserverlist2'&@lf
		Case $C2M_GS
			Return '\list\\'
	EndSwitch
	Return ''
EndFunc

Global Enum _ ;M2C
	$M2C_NONE, _
	$M2C_Q1, _
	$M2C_Q2, _
	$M2C_Q3, _
	$M2C_Q3ET, _ ;recieve multiple packets with '\EOT' on each one
	$M2C_HEX2, _
	$M2C_JEDI, _  ;inconsistant masters, invalid space in responce on some hosts
	$M2C_STEF1, _ ;same as q3, but ip list is hex string. expecting ' \' before ip
	$M2C_PB2
Func GetData_M2C($idx)
	Switch $idx
		Case $M2C_Q1
			Return 'ÿÿÿÿd'
		Case $M2C_Q2
			Return 'ÿÿÿÿservers'
		Case $M2C_Q3, $M2C_JEDI, $M2C_STEF1, $M2C_Q3ET ;merged/fixed
			Return 'ÿÿÿÿgetserversResponse'
		Case $M2C_HEX2
			Return 'ÿÿÿÿÿd'
		Case $M2C_PB2
			Return 'ÿÿÿÿserverlist2response'
	EndSwitch
	Return ''
EndFunc

Global Enum _ ;M2C_EOT
	$EOT_NONE, _
	$EOT_Q1, _
	$EOT_Q2, _
	$EOT_Q3, _
	$EOT_DP
Func GetData_M2C_EOT($idx)
	Switch $idx
		Case $EOT_NONE
			Return ''
		Case $EOT_Q1
			Return BinaryToString('0xd192', 1) ;'Ñ’'
		Case $EOT_Q2
			Return 'gp'
		Case $EOT_Q3
			Return '\EOT'
		Case $EOT_DP
			Return '\EOT'&chr(0)&chr(0)&chr(0)
	EndSwitch
	Return ''
EndFunc


;todo move to enum
;'JK3' 'STEF1' 'PAINT'


Global Enum _
	$GNAME_MENU, _    ;0: gamename. used for dropdown menu and exe names
	$GNAME_SAVE, _    ;1: abbreviated names (save file)
	$GNAME_GS, _      ;2: gamespy name (to send to TCP master)
	$GNAME_DP, _      ;3: darkplace name (to send to master UDP)
	$NET_C2S, _       ;4: CLIENT-> SERVER  (send message to server) (gamespy port uses '\status\')
	$NET_S2C, _       ;5: SERVER-> CLIENT  (recieve message from server )(unused for now, they all have '\' after header)
	$NET_GS_P, _      ;6: CLIENT-> SERVER  (communication port, not game port)
	$NET_C2M, _       ;7: CLIENT-> MASTER (send message to master)
	$NET_C2M_Q3PRO, _ ;8: CLIENT-> MASTER (USE PROTOCOL) (send message to master using Q3 protocol 0/1)
	$NET_M2C, _       ;9: MASTER-> CLIENT (receive message from master) note: 1 additional char is trimed
	$NET_M2C_SEP, _   ;10: MASTER-> CLIENT (IP SEPERATOR) (receive message from master. ip seperator <length>)
	$NET_M2C_EOT, _   ;11: MASTER-> CLIENT (END OF DATA) (receive message from master. end of transmition string)
	$SV_CLEAN, _      ;12: CLEANUP SV NAMES (^5...)
	$BOT_TYPE, _      ;13: remove bot from counts
	$ICON_PATH, _     ;14:
	$MASTER_ADDY, _   ;15:
	$COUNT_CFG
Global $g_gameConfig[$COUNT_GAME][$COUNT_CFG] = [ _
 	['Kingpin',              'KP',     'kingpin',                 '', $C2S_GS,    $S2C_Q2, -10, $C2M_Q2,    '',      $M2C_Q2,     0, $EOT_Q2,   $CLEAN_NONE, $BOT_NONE, 'gameicons\kp1.ico',  "master.kingpin.info:28900|master.maraakate.org:28900|master.hambloch.com:28900|master.333networks.com:28900"], _ ;kingpin
	['KingpinQ3',            'KPQ3',   'kingpinQ3',    'KingpinQ3-1', $C2S_Q3,    $S2C_Q3,   0, $C2M_Q3,    '75',    $M2C_Q3,     1, $EOT_DP,   $CLEAN_Q3,   $BOT_Q3,   'gameicons\kpq3.ico', "master.kingpinq3.com:27950|master.kingpin.info:27950|master.ioquake3.org:27950|gsm.qtracker.com:28900"], _ ;kpq3
	['Quake2',               'Q2',     'Quake2',                  '', $C2S_Q2,    $S2C_Q2,   0, $C2M_Q2,    '',      $M2C_Q2,     0, $EOT_Q2,   $CLEAN_NONE, $BOT_NONE, 'gameicons\q2.ico',   "http://q2servers.com/?mod=&raw=1|http://q2servers.com/?g=dday&raw=1|master.netdome.biz:27900|master.quakeservers.net:27900|master.333networks.com:28900"] _ ;quake2
]
;todo ADD GAMES


;listview column ID
Global Enum _
	$COL_NAME, _
	$COL_IP, _
	$COL_PORT, _ ;communication port
	$COL_PING, _
	$COL_PORTGS, _ ;gamespy reported game port
	$COL_TIME, _
	$COL_PLAYERS, _
	$COL_INFOSTR, _ ;stored as array
	$COL_INFOPLYR, _ ; stored as string
	$COL_MAP, _
	$COL_MOD, _
	$COL_IDX, _  ;sorted list, index
	$COUNT_COL
;multi game arrays
Global $g_aServerStrings[$COUNT_GAME][$g_iMaxSer][$COUNT_COL];keep each server array in memory [num][string/ip/port/ping/HostPort]
Global $g_aFavList[$COUNT_GAME] ;redim

Global Enum _
	$GCFG_MAST_DEF, _
	$GCFG_MAST_CUST, _
	$GCFG_MAST_PROTO, _
	$GCFG_EXE_PATH, _
	$GCFG_NAME_PLYR, _
	$GCFG_RUN_CMD, _
	$GCFG_AUTO_REF, _
	$COUNT_GCFG
Global $g_aGameSetup[$COUNT_GAME][$COUNT_GCFG] ;redim
Global $g_aIconIdx[$COUNT_GAME+1] ;+mbrowser

;========
;main UI
Global $HypoGameBrowser, $tabGroupGames, $UI_Combo_gameSelector, $UI_TabSheet[$COUNT_TABS]
Global $UI_Btn_pingList, $UI_Btn_loadFav, $UI_Btn_offlineList, $UI_Btn_settings, $UI_Btn_expand, $UI_Btn_refreshMaster
Global $UI_Text_filter, $UI_Btn_filterOffline, $UI_Btn_filterEmpty, $UI_Btn_filterFull
Global $UI_Icon_hypoLogo, $UI_Tray_exit, $UI_Tray_max, $UI_Tray_minimize
;games TAB
Global $UI_ListV_svData_A, $UI_ListV_svData_B, $UI_ListV_svData_C
;settings TAB
Global $UI_Combo_master, $UI_Text_setupTitle, $UI_In_master_Cust, $UI_In_gamePath, $UI_In_playerName, $UI_In_runCmd, $UI_In_master_proto
Global $UI_Text_masterAddress, $UI_Text_playerName, $UI_Text_runCmd, $UI_Btn_gamePath, $UI_Text_setupBG, $UI_CBox_gameRefresh, $UI_CBox_gamePingAll
Global $UI_CBox_autoRefresh, $UI_Combo_M_addServer, $UI_Combo_hkey, $UI_Label_hotkey, $UI_TextAbout, $UI_Grp_hosted, $UI_Combo_theme
Global $UI_Grp_gameConfig, $UI_CBox_tryNextMaster, $UI_CBox_useMLink, $UI_In_refreshTime, $UI_Tex_refreshTime, $GUI_gameSetup
Global $UI_Grp_mBrowser, $UI_In_getPortM, $UI_MHost_removeServer, $UI_MHost_addServer, $UI_MHost_excludeSrever
Global $UI_Grp_webLinks, $UI_Text_linkKPInfo, $UI_Text_linkMServers, $UI_Text_linkSupport, $UI_Text_linkContactM
Global $UI_CBox_sound, $UI_Grp_gameSetup, $UI_Text_linkKPQ3, $UI_Text_linkHypoEmail, $UI_Text_linkDiscord, $UI_Btn_gameNew
Global $UI_Grp_browserOpt, $UI_CBox_minToTray, $UI_In_hotKey, $UI_Btn_setHotKey, $UI_Text_masterUser, $UI_Text_masterProto
;m-browser TAB
Global $UI_ListV_mb_ABC[3], $UI_Text_countMPlayers
;chat TAB
Global $UI_Text_chatBG, $UI_Btn_chatConnect, $UI_Obj_webPage = _IECreateEmbedded(), $UI_Obj_webPage_ctrl
;statusbar
Global $MOTD_Input, $UI_Prog_getServer, $UI_Text_masterDisplay ;$MOTD_Background,
;main  gui
Global $aDPI[2]
Global $HypoGameBrowser_AccelTable[1][2] ;todo local?

;gui3
Global $UI3_In_icon,$UI3_Grp_names,$UI3_Text_nameGame,$UI3_In_nameGame,$UI3_Text_nameSave, _
	$UI3_In_nameSave,$UI3_Text_nameGSpy,$UI3_In_nameGSpy,$UI3_Text_nameDP,$UI3_In_nameDP,$UI3_Grp_server, _
	$UI3_Text_c2sMSG,$UI3_Combo_c2sMSG,$UI3_Text_s2cMSG,$UI3_Combo_s2cMSG,$UI3_Text_gsPort,$UI3_In_gsPort, _
	$UI3_Text_svClean,$UI3_Combo_svClean,$UI3_Text_svBot,$UI3_Combo_svBot,$UI3_Grp_master,$UI3_Text_c2mMSG, _
	$UI3_Combo_c2mMSG,$UI3_Text_q3Protocol,$UI3_In_q3Protocol,$UI3_Text_m2cMSG,$UI3_Combo_m2cMSG, _
	$UI3_Text_m2cEOT,$UI3_Combo_m2cEOT,$UI3_Text_masters, _
	$UI3_In_masters,$UI3_Btn_save,$UI3_Btn_cancel,$UI3_Text_icon
;========================================================
; -->Global settings
Global $g_cfgVersion = 0
Global $g_iGSGameLast = 0 ;store menu
Global $g_isGettingServers = 0 ;0=no, 1=yes, -1=finished

;total server counts
Global $g_iServerCountTotal = 0 ;get # of servers to use later to stop refresh
Global $g_iServerCountTotal_Responded = 0	;count the server if we recieved info

Global $g_iTabNum = 0
Global $g_iCurGameID = 0 ; startup kp?
Global $g_iGameSetupLastIdx = 0 ;settings gameIdx

;delayed update. exit WM
Global $g_iListview_changed = 0

;==> sockets. one for master, one for client
Global $g_hSocketServerUDP = -1 ; socket for servers communication
;Global $g_hSocketMasterUDP = -1 ; socket for master communication
Global $g_hSocReqNum = 0 ; console log

Global $g_aStoredWinSize[4] ;store win size b4 minimizing it. or it causes error when exiting
Global $g_bWasMaximized = False
Global $g_bWasMinimized = False
Global $g_bGuiResized = False

;set time of last refresh. for auto refresh
Global $g_iLastRefreshTime ;

;-->  player counts for audio
Global $g_iPlayerCount_GS = 0
Global $g_aPlayerCount_M[3] = [0, 0, 0]

Global $iMGameType = 0 ;Tab m-browser. needs extra info to lunch game
;Global $g_iLoadOnStartup_M = 0

Global $g_sStatusbarString_working = "" ;store current message. temp message will timeout
Global $g_statusBarTime = 0
Global Const $g_statusBar_timeOut = 6000 ; 6 sec to restore working message

Global $g_bAutoRefresh = False ; = _GUICtrlComboBox_GetCurSel($UI_CBox_autoRefresh)
Global $g_bAutoRefreshActive = False ;auto refresh prevents popup dialogs
Global $g_iAutoRefreshGame = 0 ; last game refreshed(either active or setup enabled auto refresh)
Global $g_iTimeInputBox = 1;

Global $g_UseTheme = 0
Global $g_sGameCfgPath = @ScriptDir & "/gameConfig.ini"

;==> color for visual theme
Global Enum _
	$THEME_BG_LIGHT, _ ;listview
	$THEME_BG_DARK, _  ;buttons, input boxes
	$THEME_TEXT, _     ;active text
	$THEME_DISABLE, _  ;disabled text
	$COUNT_THEME

Global $g_aTheme = [ _
 	[ _ ; theme orange
		0x373737, _  ;BG_LIGHT grey (0x7a7a7a)
		0x272727, _  ;BG_DARK  dark grey. button color (0xe58816)
		0xff8c00, _  ;TEXT     orange
		0xbbbbbb], _ ;DISABLE  grey text. disabled
 	[ _ ;theme green
		0x232b21, _  ;BG_LIGHT grey (0x7a7a7a)
		0x162114, _  ;BG_DARK  dark grey. button color (0xe58816)
		0x92d186, _  ;TEXT     green
		0xA7BAA4], _ ;DISABLE grey text. disabled
	[ _ ; theme light
		0xcdd3d6, _  ;BG_LIGHT
		0x90a3a8, _  ;BG_DARK
		0x0b1317, _  ;TEXT
		0x636363], _   ;DISABLE
	[ _ ; theme blue
		0x132433, _  ;BG_LIGHT
		0x091214, _  ;BG_DARK
		0x9ccee6, _  ;TEXT
		0x899ba1] _   ;DISABLE
]

;====================
;--> M BROWER Globals
Global $MPopupInfo, $serverInfoRefBtn, $serverInfoConBtn, $ListView1POP, $ListView2POP
Global Const $g_sMWebString[3] = [ _
	"https://hambloch.com/kingpin/mbrowser.php?game=kingpin&username=hypobrowser&v=1.0", _
	"https://hambloch.com/kingpin/mbrowser.php?game=kingpinq3&username=hypobrowser&v=1.0", _
	"https://hambloch.com/kingpin/mbrowser.php?game=quake2&username=hypobrowser&v=1.0"] ;unused..

; files that should be deleted
Global Const $g_sM_tmpFile_reg = @TempDir & "\kingpin_MLink.reg"
Global Const $g_sM_tmpFile[3] = [ _
	@TempDir & "\KP_Server_Array.txt", _
	@TempDir & "\KPQ3_Server_Array.txt", _
	@TempDir & "\Q2Web_Server_Array.txt"]

Global Const $mp3path[11] = [ _
	@TempDir & "\1_po.mp3", _
	@TempDir & "\2_po.mp3", _
	@TempDir & "\3_po.mp3", _
	@TempDir & "\4_po.mp3", _
	@TempDir & "\5_po.mp3", _
	@TempDir & "\6_po.mp3", _
	@TempDir & "\7_po.mp3", _
	@TempDir & "\8_po.mp3", _
	@TempDir & "\9_po.mp3", _
	@TempDir & "\10_po.mp3", _
	@TempDir & "\10plus_po.mp3"]

;get icons from internal resources. 0=global 1-3=autoit
Global $ImageList1 = _GUIImageList_Create(16, 16, 5)
Global $ImageListGames = _GUIImageList_Create(16, 16, 5, 3)

Global $bEventStartKingpin = False 	;while loop call for $WM_NOTIFY
;popup menu
Global  Enum $ContextKP_Connect = 2800, $ContexKP_Refresh, $ContexKP_AddFav, $ContexKP_RemFav, _
			$ContexKP_RefreshM, $ContextKP_ConnectM, $ContexKP_AddFavM, $ContexKP_RemFavM, _
			$ContextKP_CopyIP, $ContexKP_GetInfoM  ; these are used in menu definition to link to WM_COMMAND

Global Const $g_listID_offset = 3000

Global $bEventRightClick = False 	;while loop call for $WM_NOTIFY
Global $bEventRightClickM = False 	;while loop call for $WM_NOTIFY

;sort listview
Global $g_ilastColumn_A = -1
Global $g_ilastColumn_C = -1
Global $g_vSortSense_C[2] = [False, False]
Global $g_bLV_A_startUpdate = False

#EndRegion

;DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0)
;DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($HypoGameBrowser), "wstr", 0, "wstr", 0)
_WinAPI_SetThemeAppProperties(1) ;1= allow aero outter
Opt("GUIResizeMode", $GUI_DOCKAUTO+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1) ; Enable TrayOnEventMode.
Opt("TCPTimeout", 1000)
Opt("GUIOnEventMode", 1)
Opt("GUIDataSeparatorChar", "|") ;"|" is the default


#Region --> STARTUP
_GDIPlus_GraphicsGetDPIRatio($aDPI) ;windows font scale
iniFile_CFG_Load()
BuildIconList()

BulidMainGui()
BulidMainGui_Finish()
iniFile_Load() ;load ini first for game path?
iniFile_Load_Fix() ;fix any missing data
M_RunGameFrom_MLInk() ;check if a command lunched the exe, then exit
CheckSingleState() ;close if multiple are open
startupMainUI()
UpdateRegForMBrowserLinks()

Func BuildTabViewPage($iTab, $sName)
	$UI_TabSheet[$iTab] = GUICtrlCreateTabItem($sName)
	Switch $iTab
		Case $TAB_GB ;0 to $COUNT_GAME-1
			GUICtrlSetState($UI_TabSheet[$iTab],$GUI_SHOW)
			;GUISwitch($HypoGameBrowser, $UI_TabSheet[$iTab])
			$UI_ListV_svData_A = GUICtrlCreateListView("Num|IP|Server Name|Ping|Players|Map|Mod", 65, 34, 738, 382, -1, BitOR($WS_EX_CLIENTEDGE,$LVS_EX_SUBITEMIMAGES,$LVS_EX_FULLROWSELECT))
			;GUICtrlRegisterListViewSort($UI_ListV_svData_A, "ListViewSort_A");updateLV
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 1)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 4)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 240)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 65)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 4, 70)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 5, 160)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 6, 170)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM)
			$UI_ListV_svData_B = GUICtrlCreateListView("Name|Frags|Ping|Deaths|Team", 121, 420, 389, 168, BitOR($GUI_SS_DEFAULT_LISTVIEW,$LVS_AUTOARRANGE,$LVS_ALIGNLEFT,$WS_HSCROLL,$WS_VSCROLL), BitOR($WS_EX_CLIENTEDGE,$LVS_EX_SUBITEMIMAGES,$LVS_EX_FULLROWSELECT))
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 150)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 50)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 50)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 50)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 4, 50)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT)
			$UI_ListV_svData_C = GUICtrlCreateListView("Rules|Value", 515, 420, 288, 168, BitOR($GUI_SS_DEFAULT_LISTVIEW,$LVS_AUTOARRANGE,$LVS_ALIGNLEFT,$WS_HSCROLL,$WS_VSCROLL), BitOR($WS_EX_CLIENTEDGE,$LVS_EX_SUBITEMIMAGES,$LVS_EX_FULLROWSELECT))
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 100)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 120)
			GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)

			$UI_Btn_expand = GUICtrlCreateButton("^", 65, 424, 51, 25, $BS_BITMAP) ; 65
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
			GUICtrlSetTip(-1, "Expand")

			;==> filters
			$UI_Text_filter = GUICtrlCreateLabel("Filters", 65, 488, 51, 13, $SS_CENTER)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
			$UI_Btn_filterOffline = GUICtrlCreateCheckbox("Offline", 65, 504, 51, 25, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_PUSHLIKE))
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
			$UI_Btn_filterEmpty = GUICtrlCreateCheckbox("Empty", 65, 532, 51, 25, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_PUSHLIKE))
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
			$UI_Btn_filterFull = GUICtrlCreateCheckbox("Full", 65, 560, 51, 25, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_PUSHLIKE))
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
		Case $TAB_MB
			$UI_ListV_mb_ABC[0] = GUICtrlCreateListView("Num|IP|Server Name|Ping|Players|Map", 65, 34, 738, 290, -1, BitOR($WS_EX_CLIENTEDGE,$LVS_EX_SUBITEMIMAGES,$LVS_EX_FULLROWSELECT))
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 1)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 4)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 240)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 65)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 4, 70)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 5, 160)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM)
			$UI_ListV_mb_ABC[1] = GUICtrlCreateListView("Num|IP|Server Name|Ping|Players|Map", 65, 348, 738, 148, -1, BitOR($WS_EX_CLIENTEDGE,$LVS_EX_SUBITEMIMAGES,$LVS_EX_FULLROWSELECT))
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 1)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 4)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 240)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 65)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 4, 70)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 5, 160)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT)
			$UI_ListV_mb_ABC[2] = GUICtrlCreateListView("Num|IP|Server Name|Ping|Players|Map", 65, 500, 738, 88, -1, BitOR($WS_EX_CLIENTEDGE,$LVS_EX_SUBITEMIMAGES,$LVS_EX_FULLROWSELECT))
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 1)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 4)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 240)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 65)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 4, 70)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 5, 160)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT)
			$UI_Text_countMPlayers = GUICtrlCreateLabel("", 65, 328, 738, 17, BitOR($SS_CENTER,$SS_CENTERIMAGE), $WS_EX_STATICEDGE)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT)
		Case $TAB_CHAT
			$UI_Text_chatBG = GUICtrlCreateLabel("", 65, 34, 738, 554, -1, $WS_EX_STATICEDGE)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM)
			GUICtrlSetState(-1, $GUI_DISABLE)
			;$UI_Obj_webPage = ObjCreate("DHTMLEdit.DHTMLEdit.1")
			$UI_Obj_webPage_ctrl = GUICtrlCreateObj($UI_Obj_webPage, 74, 42, 720, 512)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKRIGHT+$GUI_DOCKTOP)

			$UI_Btn_chatConnect = GUICtrlCreateButton("Connect", 74, 558, 81, 25)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
		Case $TAB_CFG
			;$UI_Text_setupBG = GUICtrlCreateLabel("", 65, 34, 737, 554, BitOR($SS_CENTER,$SS_SUNKEN))
			$UI_Text_setupBG = GUICtrlCreateLabel("", 65, 34, 738, 554, -1, $WS_EX_STATICEDGE)	;BitOR($SS_CENTER,$SS_SUNKEN)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM)
			GUICtrlSetState(-1, $GUI_DISABLE)

			;================
			; master settings
			$UI_Grp_gameSetup = GUICtrlCreateGroup("Game Setup", 73, 38, 256, 292, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))
				GUICtrlSetFont(-1, 9, 400, 0, "MS Sans Serif")
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$UI_Text_setupTitle = GUICtrlCreateLabel("Kingpin", 85, 62, 232, 24, BitOR($SS_CENTER,$SS_CENTERIMAGE), $WS_EX_STATICEDGE)
				GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$UI_Text_masterAddress = GUICtrlCreateLabel("Preset Master", 81, 106, 68, 21, $SS_CENTERIMAGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$UI_Combo_master = GUICtrlCreateCombo("", 153, 106, 168, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "Custom Master|set1|set2")
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$UI_Text_masterUser = GUICtrlCreateLabel("User Master", 81, 130, 68, 21, $SS_CENTERIMAGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$UI_In_master_Cust = GUICtrlCreateInput("gsm.qtracker.com:28900", 153, 130, 168, 21, BitOR($GUI_SS_DEFAULT_INPUT,$WS_BORDER), $WS_EX_STATICEDGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$UI_Text_masterProto = GUICtrlCreateLabel("Q3 Protocol", 81, 154, 64, 21, $SS_CENTERIMAGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$UI_In_master_proto = GUICtrlCreateInput("74", 153, 154, 84, 21, BitOR($GUI_SS_DEFAULT_INPUT,$WS_BORDER), $WS_EX_STATICEDGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Game Protocol for IOQ3 masters"&@CRLF&"74=Beta, 75=Release")
				$UI_CBox_gameRefresh = GUICtrlCreateCheckbox("AutoRefresh Game", 81, 178, 117, 21)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Add current game to the AutoRefresh list.")
				$UI_CBox_gamePingAll = GUICtrlCreateCheckbox("Ping All Masters", 81, 202, 101, 21)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Combine Master Server IP lists.")

				$UI_Btn_gameNew = GUICtrlCreateButton("Add/Update", 232, 184, 89, 33)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Update gameConfig.ini. Add new or edit existing game.")

				$UI_Btn_gamePath = GUICtrlCreateButton("Game Path", 81, 250, 65, 21)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$UI_In_gamePath = GUICtrlCreateInput("Game.exe", 153, 250, 168, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY,$WS_BORDER), $WS_EX_STATICEDGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$UI_Text_playerName = GUICtrlCreateLabel("Player Name", 81, 274, 64, 21, $SS_CENTERIMAGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$UI_In_playerName = GUICtrlCreateInput("", 153, 274, 168, 21, BitOR($GUI_SS_DEFAULT_INPUT,$WS_BORDER), $WS_EX_STATICEDGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$UI_Text_runCmd = GUICtrlCreateLabel("Commands", 81, 298, 60, 21, $SS_CENTERIMAGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Addition commandline arguments to add when running game")
				$UI_In_runCmd = GUICtrlCreateInput("+set developer 1", 153, 298, 168, 21, BitOR($GUI_SS_DEFAULT_INPUT,$WS_BORDER), $WS_EX_STATICEDGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
			GUICtrlCreateGroup("", -99, -99, 1, 1)
			;end master settings
			;================

			;===============
			;browser options
			$UI_grp_browserOpt = GUICtrlCreateGroup("Browser Options", 337, 38, 128, 292, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$UI_CBox_sound = GUICtrlCreateCheckbox("Play Sounds", 349, 62, 105, 21)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Play a sound if there is a player in a server")
				$UI_CBox_minToTray = GUICtrlCreateCheckbox("Minimize to Tray", 349, 86, 105, 21)
				GUICtrlSetState(-1, $GUI_CHECKED)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "This is used in tray menu(Minimize) and on game lunch")
				$UI_CBox_useMLink = GUICtrlCreateCheckbox("Use M Web Link", 349, 110, 105, 21)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Enable web links to connect to 'servers' listed on M's Website."& @CRLF&"Make sure to set Kingpin Game Path first. Then enable option.")
				$UI_CBox_tryNextMaster = GUICtrlCreateCheckbox("Ping Next Master", 349, 134, 105, 21)
				GUICtrlSetState(-1, $GUI_CHECKED)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "If master fails to respond, ping the next one in list. Not used for Custom Master")
				$UI_Combo_theme = GUICtrlCreateCombo("", 349, 162, 104, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "Theme None|Theme Orange|Theme Green|Theme Light|Theme Blue", "Theme Orange")
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Enable custom colors on GUI."&@CRLF&"Requires restart.")
				$UI_CBox_autoRefresh = GUICtrlCreateCheckbox("Auto Refresh", 349, 202, 97, 17)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Auto refresh active game.")
				$UI_In_refreshTime = GUICtrlCreateInput("3", 349, 222, 29, 21, BitOR($GUI_SS_DEFAULT_INPUT,$WS_BORDER), $WS_EX_STATICEDGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Time in Minutes between auto refresh")
				$UI_Tex_refreshTime = GUICtrlCreateLabel("Refresh Time", 381, 222, 67, 17, $SS_CENTERIMAGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Time in Minutes between auto refresh")
				$UI_Label_hotkey = GUICtrlCreateLabel("Hotkey (Restore)", 349, 258, 102, 13)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$UI_Combo_hKey = GUICtrlCreateCombo("", 349, 274, 104, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "ALT +|CTRL +|CTRL + ALT +", "ALT +")
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$UI_In_hotKey = GUICtrlCreateInput("", 349, 298, 33, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_LOWERCASE,$WS_BORDER), $WS_EX_STATICEDGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "HotKey. Accepts a-z")
				$UI_Btn_setHotKey = GUICtrlCreateButton("Apply", 389, 298, 64, 21)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Apply a Windows global hotkey")
			GUICtrlCreateGroup("", -99, -99, 1, 1)
			;end browser
			;===============

			;=============
			;hosted server
			$UI_Grp_hosted = GUICtrlCreateGroup("Hosted Server", 473, 38, 109, 172, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$UI_MHost_addServer = GUICtrlCreateButton("Add Server", 481, 62, 93, 25)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Add a server to 'M' Website listing so game can be seen in M-Browser")
				$UI_MHost_removeServer = GUICtrlCreateButton("Remove Server", 481, 90, 93, 25)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Remove a server to 'M' Website listing so game can not be seen in M-Browser")
				$UI_MHost_excludeSrever = GUICtrlCreateButton("Exclude Server", 481, 118, 93, 25)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Exclude a server from 'M' Website listing so game can not be seen in M-Browser. Even if listed at Qtracker")
				$UI_Combo_M_addServer = GUICtrlCreateCombo("", 481, 150, 93, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "kingpin|kingpinq3|quake2", "kingpin")
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$UI_In_getPortM = GUICtrlCreateInput("31510", 481, 178, 93, 21, BitOR($GUI_SS_DEFAULT_INPUT,$WS_BORDER), $WS_EX_STATICEDGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Set Server port" & @CRLF & "Default Game Kingpin")
			GUICtrlCreateGroup("", -99, -99, 1, 1)
			;end hosted
			;=============

			;=============
			;weblinks
			$UI_Grp_webLinks = GUICtrlCreateGroup("Web Links", 589, 38, 124, 172, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$UI_Text_linkKPInfo = GUICtrlCreateLabel("Kingpin.info", 597, 58, 99, 17, $SS_CENTERIMAGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Kingpin.info Website")
				GUICtrlSetCursor (-1, 0)
				$UI_Text_linkMServers = GUICtrlCreateLabel("M's Server List", 597, 78, 99, 17, $SS_CENTERIMAGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Server List Website (hambloch.com)")
				GUICtrlSetCursor (-1, 0)
				$UI_Text_linkContactM = GUICtrlCreateLabel("Contact M", 597, 98, 99, 17, $SS_CENTERIMAGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Contact M Via His Website (hambloch.com)")
				GUICtrlSetCursor (-1, 0)
				$UI_Text_linkKPQ3 = GUICtrlCreateLabel("KingpinQ3", 597, 118, 99, 17, $SS_CENTERIMAGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "KingpinQ3 Website")
				GUICtrlSetCursor (-1, 0)
				$UI_Text_linkDiscord = GUICtrlCreateLabel("Kingpin Discord", 597, 138, 99, 17, $SS_CENTERIMAGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Kingpin Discord")
				GUICtrlSetCursor (-1, 0)
				$UI_Text_linkHypoEmail = GUICtrlCreateLabel("Contact Hypov8", 597, 158, 99, 17, $SS_CENTERIMAGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Email Me")
				GUICtrlSetCursor (-1, 0)
				$UI_Text_linkSupport = GUICtrlCreateLabel("Support Me", 597, 178, 99, 17, $SS_CENTERIMAGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Buy Me a Coffee")
				GUICtrlSetCursor (-1, 0)
			GUICtrlCreateGroup("", -99, -99, 1, 1)
			;weblinks
			;=============

			;=============
			;mbrowser
			$UI_Grp_mBrowser = GUICtrlCreateGroup("M Browser Info", 473, 214, 240, 116, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$UI_TextAbout = GUICtrlCreateEdit("", 481, 234, 225, 89, BitOR($ES_NOHIDESEL,$ES_READONLY))
				GUICtrlSetData(-1, StringFormat("M-Browser GUI Version\r\nBy David Smyth (hypo_v8)\r\n\r\nThe original M-Browser is a command line \r\ninterface that Michael Hambloch(M) released.\r\nUsing M"&Chr(39)&"s Website to Source Kingpin Servers."))
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
			GUICtrlCreateGroup("", -99, -99, 1, 1)
			;mbrowser
			;=============
	EndSwitch
EndFunc

Func BulidMainGui()
	;#Region ### START Koda GUI section ### Form=C:\Programs\codeing\autoit-v3\SciTe\Koda\Dave\hypogamebrowser.kxf
	$HypoGameBrowser = GUICreate("HypoGameBrowser", 810, 615, -1, -1, BitOR($GUI_SS_DEFAULT_GUI,$WS_MAXIMIZEBOX,$WS_SIZEBOX,$WS_THICKFRAME,$WS_TABSTOP))
	GUISetIcon(@AutoItExe, -1)
	GUISetFont(8* $aDPI[0], 0, 0,  "MS Sans Serif", $HypoGameBrowser)

	;==> tabs
	$tabGroupGames = GUICtrlCreateTab(61, 4, 746, 607, BitOR($TCS_FLATBUTTONS,$TCS_FORCELABELLEFT,$TCS_BUTTONS))
		GUICtrlSetFont(-1, 10*$aDPI[0], 400, 0, "MS Sans Serif") ;was 800
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM)
		;TABS
		BuildTabViewPage($TAB_GB,   "Games") ; now combined
		BuildTabViewPage($TAB_MB,   "M-Browser")
		BuildTabViewPage($TAB_CHAT, "Chat")
		BuildTabViewPage($TAB_CFG,  "Setup")
	GUICtrlCreateTabItem("")

	;==> game selector
	$UI_Combo_gameSelector = _GUICtrlComboBoxEx_Create($HypoGameBrowser, "", 652, 8, 149, 582, $CBS_DROPDOWNLIST )

	;==> buttons
	$UI_Btn_refreshMaster = GUICtrlCreateButton("Refresh", 3, 56+8, 56, 41, $BS_BITMAP)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Get servers from the master and refresh them" & @CRLF &" Shortcut F5")
	$UI_Btn_pingList = GUICtrlCreateButton("Ping List", 3, 104+4, 56, 41, $BS_BITMAP)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Refresh game servers in current list, without talking to the master.")
	$UI_Btn_loadFav = GUICtrlCreateButton("Favorite", 3, 152, 56, 41, $BS_BITMAP)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "View favorite server list."&@CRLF&" PingList will run once they are loaded")
	$UI_Btn_offlineList = GUICtrlCreateButton("OffLine", 3, 212, 56, 41, $BS_BITMAP)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Load offline server list for the selected game."&@CRLF&" You will need to refresh list with PingList..")
	$UI_Btn_settings = GUICtrlCreateButton("Setup", 3, 310, 56, 41, $BS_BITMAP)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Settings")

	$UI_Icon_hypoLogo = GUICtrlCreateLabel("", 3, 4, 56, 56, $SS_SUNKEN, 0)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Support Me"&@CRLF&"Buy Me a Coffee")
	GUICtrlSetCursor (-1, 0)

	;==> progress bar
	$UI_Prog_getServer = GUICtrlCreateProgress(65, 591, 51, 17, 1, $WS_EX_STATICEDGE);$PBS_SMOOTH =1
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)

	;==> statusbar text
	$MOTD_Input = GUICtrlCreateLabel("", 119, 591, 391, 17, $SS_CENTERIMAGE, $WS_EX_STATICEDGE) ; BitOR($SS_CENTERIMAGE,$WS_BORDER)) ;, $SS_CENTERIMAGE)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKRIGHT+$GUI_DOCKHEIGHT)

	;==> statusbar master
	$UI_Text_masterDisplay = GUICtrlCreateLabel("Master:", 515, 591, 288, 17, BitOR($SS_RIGHT,$SS_CENTERIMAGE), $WS_EX_STATICEDGE)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Sklvggh")
	GUICtrlSetState(-1, $GUI_ONTOP)

	TraySetIcon(@AutoItExe, -1)
	TraySetClick("16")
	$UI_Tray_exit = TrayCreateItem("Exit")
	TrayCreateItem("")
	$UI_Tray_max = TrayCreateItem("Restore/Maximize")
	$UI_Tray_minimize = TrayCreateItem("Minimize")

	GUISetState(@SW_HIDE , $HypoGameBrowser) ;;;GUISetState(@SW_SHOW, $HypoGameBrowser)
	;#EndRegion ### END Koda GUI section ###
EndFunc

Func BulidMainGui_Finish()
	_GUICtrlComboBox_SetDroppedWidth($UI_Combo_master, 350)
	WinSetTitle($HypoGameBrowser,"", string($versionName &"  (v"& $versionNum&")"))
	GUICtrlSetData($MOTD_Input , "Use Refresh to receive list from master. Use Ping to updates current servers in view. Offline loads internal servers")
	GUICtrlSetTip($UI_In_master_proto, _
		"Game Protocol for Q3 UDP masters"&@CRLF& _
		"  Note: Use | to combine protocols."&@CRLF& _
		"  KingpinQ3:  74=Beta1, 75=Beta2"&@CRLF& _
		"  Quake3:  66=v1.30 67=1.31 68=1.32" &@CRLF& _
		"  Unvanquished:  86=v0.55"&@CRLF& _
		"  Warsow:  22=v2.10"&@CRLF& _
		"  Jedi Out:  15=v1.02 16=v1.04"&@CRLF& _
		"  Jedi Academy:  25=v1.0 26=v1.01"&@CRLF& _
		"  SOF 2:  2002=v1.0 2003=v1.01 2004=v1.04"&@CRLF& _
		"  Star Trek EF:  24"&@CRLF& _
		"  FTEQW: 3, (28)?"&@CRLF& _
		""&@CRLF _ ;todo ADD GAMES
	)


	;update listview
	_GUICtrlListView_JustifyColumn(GUICtrlGetHandle($UI_ListV_svData_A), 0, 0) ;IDX
	_GUICtrlListView_JustifyColumn(GUICtrlGetHandle($UI_ListV_svData_A), 1, 0) ;IP
	_GUICtrlListView_JustifyColumn(GUICtrlGetHandle($UI_ListV_svData_A), 3, 0) ;ping align right
	_GUICtrlListView_JustifyColumn(GUICtrlGetHandle($UI_ListV_svData_A), 4, 0) ;players align right
	;_GUICtrlListView_SetColumn(GUICtrlGetHandle($UI_ListV_svData_A), 3, "Ping", 50, 1, 2, True)

	_GUICtrlComboBoxEx_SetImageList($UI_Combo_gameSelector, $ImageListGames) ; icons
	_GUICtrlComboBoxEx_InitStorage($UI_Combo_gameSelector, $COUNT_GAME, 160)
	_GUICtrlComboBoxEx_SetItemHeight($UI_Combo_gameSelector, -1, 16)
	_GUICtrlComboBoxEx_SetItemHeight($UI_Combo_gameSelector, 0, 18)
	_GUICtrlComboBoxEx_BeginUpdate($UI_Combo_gameSelector)
	for $i = 0 to $COUNT_GAME-1 ; COUNT_GAME
		_GUICtrlComboBoxEx_AddString($UI_Combo_gameSelector, $g_gameConfig[$i][$GNAME_MENU], $g_aIconIdx[$i], $g_aIconIdx[$i])
	Next
	_GUICtrlComboBoxEx_AddString($UI_Combo_gameSelector, 'M-Browser (Tab)', $g_aIconIdx[$COUNT_GAME], $g_aIconIdx[$COUNT_GAME])
	_GUICtrlComboBoxEx_EndUpdate($UI_Combo_gameSelector)

	;remove theme on progressbar
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($UI_Prog_getServer), "wstr", 0, "wstr", 0)

	;progressbar (win/user set colors) ;$COLOR_WINDOWTEXT
	GUICtrlSetColor($UI_Prog_getServer, Int("0x" & StringRegExpReplace(Hex(_WinAPI_GetSysColor($COLOR_BTNTEXT), 6), "(..)(..)(..)", "\3\2\1")))

	;;;;;;$sNames &= "|M-Browser (Tab)"
	;;;;;;;;;;GUICtrlSetData($UI_Combo_gameSelector, $sNames , $g_gameConfig[$ID_KP1][$GNAME_MENU])
EndFunc

Func BuildIconList()
	for $i = 0 to $COUNT_GAME
		_GUIImageList_AddIcon($ImageList1, @ScriptFullPath, $i+ 4, True)
	Next

	for $i = 0 to $COUNT_GAME -1
		$g_aIconIdx[$i] = _GUIImageList_AddIcon($ImageListGames, @ScriptDir &'\'& $g_gameConfig[$i][$ICON_PATH], 0)
	Next
	$g_aIconIdx[$COUNT_GAME] = _GUIImageList_AddIcon($ImageListGames, @ScriptDir&'\gameicons\m.ico', 0)
EndFunc

Func _GDIPlus_GraphicsGetDPIRatio(ByRef $aDPI)
	local $iDPIDef = 96
	$aDPI[0] = 1
	$aDPI[1] = 1

	_GDIPlus_Startup()
	Local $hGfx = _GDIPlus_GraphicsCreateFromHWND(0)
	If Not @error Then
		#forcedef $__g_hGDIPDll
		Local $aRet = DllCall($__g_hGDIPDll, "int", "GdipGetDpiX", "handle", $hGfx, "float*", 0)
		If not @error Then
			$aDPI[0] = $iDPIDef / $aRet[2]
			$aDPI[1] = $aRet[2] / $iDPIDef
		EndIf
		_GDIPlus_GraphicsDispose($hGfx)
	EndIf
	_GDIPlus_Shutdown()
EndFunc   ;==>_GDIPlus_GraphicsGetDPIRatio


;======================
;--> SHOW UI. SET THEME
Func startupMainUI()
	;add this to let everything load
	EnableUIButtons(False)

	GameSetup_UpdateUI()

	;load dark theme
	$g_UseTheme = _GUICtrlComboBox_GetCurSel($UI_Combo_theme)
	if $g_UseTheme > 0 Then
		GUISetColor()
		SetUI_masterCust_State()
	Else
		$g_UseTheme = 0
	EndIf

	;$g_bAutoRefresh = _IsChecked($UI_CBox_autoRefresh)
	;_GUICtrlEdit_SetReadOnly($UI_In_refreshTime, $g_bAutoRefresh)
	UI_CBox_autoRefreshChanged()
	ConsoleWrite("!startup refresh id:"&$g_bAutoRefresh&@CRLF)

	_ResourceSetImageToCtrl($UI_Icon_hypoLogo, "logo_1") ;todo use icon

	FileInstall(".\sounds\1_po.mp3",      @TempDir & "\")
	FileInstall(".\sounds\2_po.mp3",      @TempDir & "\")
	FileInstall(".\sounds\3_po.mp3",      @TempDir & "\")
	FileInstall(".\sounds\4_po.mp3",      @TempDir & "\")
	FileInstall(".\sounds\5_po.mp3",      @TempDir & "\")
	FileInstall(".\sounds\6_po.mp3",      @TempDir & "\")
	FileInstall(".\sounds\7_po.mp3",      @TempDir & "\")
	FileInstall(".\sounds\8_po.mp3",      @TempDir & "\")
	FileInstall(".\sounds\9_po.mp3",      @TempDir & "\")
	FileInstall(".\sounds\10_po.mp3",     @TempDir & "\")
	FileInstall(".\sounds\10plus_po.mp3", @TempDir & "\")

	GUISetState(@SW_SHOW, $HypoGameBrowser) ;ready to be shown

	_GUICtrlListView_SetImageList($UI_ListV_svData_A, $ImageList1, 1)
	GUICtrlRegisterListViewSort($UI_ListV_svData_A, "ListViewSort_A")	;updateLV

	$HypoGameBrowser_AccelTable[0][0] = "{F5}"
	$HypoGameBrowser_AccelTable[0][1] = $UI_Btn_refreshMaster
	GUISetAccelerators($HypoGameBrowser_AccelTable)
EndFunc
;=================

;=================
;--> CHECK M-LINKS
Func UpdateRegForMBrowserLinks()
	Local $regKeyMBrowser = _WinAPI_RegOpenKey($HKEY_CLASSES_ROOT, 'M-Browser', $KEY_QUERY_VALUE)
	If Not ($regKeyMBrowser = 0) Then
		GUICtrlSetState( $UI_CBox_useMLink, $GUI_CHECKED )
	EndIf
	_WinAPI_RegCloseKey($regKeyMBrowser)
EndFunc
;=============


;=====================
;--> THEME COLORS
Func GUISetColor()
	;gui parts to color
	Local Const $hwNames1 = [$UI_Text_setupBG, $UI_Text_chatBG, _
		$UI_ListV_svData_A, $UI_ListV_svData_B, $UI_ListV_svData_C, _
		$UI_ListV_mb_ABC[0], $UI_ListV_mb_ABC[1], $UI_ListV_mb_ABC[2], _
		$UI_Grp_gameConfig, $UI_Grp_webLinks, $UI_Grp_mBrowser, $UI_CBox_useMLink, _ ;M config
		$UI_Text_linkKPInfo, $UI_Text_linkMServers, $UI_Text_linkSupport, $UI_Text_linkContactM, _ ;web links
		$UI_Text_linkKPQ3, $UI_Text_linkHypoEmail, $UI_Text_linkDiscord, _ ;web links
		$UI_CBox_sound, $UI_Tex_refreshTime, $UI_Grp_gameSetup, $UI_CBox_autoRefresh, _
		$UI_CBox_gameRefresh, $UI_CBox_gamePingAll, $UI_CBox_minToTray, $UI_CBox_tryNextMaster, _
		$UI_Grp_browserOpt, $UI_Label_hotkey, $UI_TextAbout, $UI_Grp_hosted, $UI_Text_setupTitle, _
		$UI_Text_masterAddress, $UI_Text_playerName, $UI_Text_runCmd, $UI_Btn_gamePath, _
		$UI_Text_masterUser, $UI_Text_masterProto]

	SetUITheme_main($HypoGameBrowser, $g_UseTheme)

	;set all gui item colors
	For $iloop = 0 to UBound($hwNames1)-1
		SetUITheme($hwNames1[$iloop], $g_UseTheme)
	Next

	;statusbar (win/user set colors)
	local $hColor_btn = Int("0x" & StringRegExpReplace(Hex(_WinAPI_GetSysColor($COLOR_BTNFACE), 6), "(..)(..)(..)", "\3\2\1"))
	GUICtrlSetBkColor($MOTD_Input, $hColor_btn)
	GUICtrlSetBkColor($UI_Text_masterDisplay, $hColor_btn)

	;button colors
	Local Const $hwNamesBtn = [$UI_Btn_refreshMaster, $UI_Btn_pingList, $UI_Btn_loadFav, _
		$UI_Btn_offlineList,  $UI_MHost_addServer, $UI_MHost_removeServer, $UI_Btn_gameNew, _
		$UI_Btn_settings, $UI_MHost_excludeSrever, $UI_Btn_gamePath, $UI_Btn_setHotKey, $UI_Btn_chatConnect] ;$UI_Btn_expand,
	For $iloop = 0 to UBound($hwNamesBtn)-1
		SetUITheme_button($hwNamesBtn[$iloop], $g_UseTheme)
	Next

	;settings inputs
	Local Const $hwNamesInput = [$UI_In_hotKey, $UI_In_playerName, $UI_In_runCmd, _
		$UI_In_master_proto, $UI_In_getPortM, $UI_In_refreshTime] ;$UI_In_master_Cust,
	For $iloop = 0 to UBound($hwNamesInput)-1
		SetUITheme_inputBox($hwNamesInput[$iloop], $g_UseTheme, True)
	Next

	;disabled input colors
	Local Const $hwInputDis = [$UI_Combo_M_addServer, $UI_Combo_hkey, _
		$UI_Combo_master, $UI_Combo_gameSelector, $UI_In_gamePath, $UI_Combo_theme]
	For $iloop = 0 to UBound($hwInputDis)-1
		SetUITheme_inputBox($hwInputDis[$iloop], $g_UseTheme, False)
	Next


	;$ProgressBar
	;SetUITheme_progress($g_UseTheme)
EndFunc
;====================

;=====================
;--> ONLY ONE INSTANCE
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
;--> Reset Refresh Timers
ResetRefreshTimmers()
Func ResetRefreshTimmers()
	$g_iLastRefreshTime = TimerInit() ;set time of last refresh
EndFunc
;==============

Func SetUITheme($hw, $themeID)
	; UI_Combo_theme g_UseTheme
	Switch $themeID
		Case 1 To $COUNT_THEME
			GUICtrlSetColor($hw,   $g_aTheme[$themeID-1][$THEME_TEXT] )
			GUICtrlSetBkColor($hw, $g_aTheme[$themeID-1][$THEME_BG_LIGHT])
	EndSwitch
EndFunc

Func SetUITheme_main($hw, $themeID)
	Switch $themeID
		Case 1 To $COUNT_THEME
			GUICtrlSetDefColor($g_aTheme[$themeID-1][$THEME_TEXT], $hw)
			GUISetBkColor($g_aTheme[$themeID-1][$THEME_BG_LIGHT], $hw)
			;GUICtrlSetDefBkColor($g_aTheme[$themeID][$THEME_BG_LIGHT], $HypoGameBrowser)
	EndSwitch
EndFunc

Func SetUITheme_button($hw, $themeID)
	Switch $themeID
		Case 1 To $COUNT_THEME
			GUICtrlSetColor	 ($hw, $g_aTheme[$themeID-1][$THEME_TEXT])
			GUICtrlSetBkColor($hw, $g_aTheme[$themeID-1][$THEME_BG_DARK])
	EndSwitch
EndFunc

Func SetUITheme_inputBox($hw, $themeID, $bEnabled)
	if $bEnabled Then
		Switch $themeID
			Case 1 To $COUNT_THEME
				GUICtrlSetColor($hw,   $g_aTheme[$themeID-1][$THEME_TEXT])
				GUICtrlSetBkColor($hw, $g_aTheme[$themeID-1][$THEME_BG_DARK])
		EndSwitch
	Else
		Switch $themeID
			Case 1 To $COUNT_THEME
				GUICtrlSetColor($hw,   $g_aTheme[$themeID-1][$THEME_DISABLE])
				GUICtrlSetBkColor($hw, $g_aTheme[$themeID-1][$THEME_BG_LIGHT])
		EndSwitch
	EndIf
EndFunc

Func SetUITheme_progress($themeID)
	Switch $themeID
		Case 1 To $COUNT_THEME
			GUICtrlSetColor($UI_Prog_getServer, $g_aTheme[$themeID-1][$THEME_TEXT])
	EndSwitch
EndFunc


Func SetUI_masterCust_State()
	Local $idx = _GUICtrlComboBox_GetCurSel($UI_Combo_master)

	ConsoleWrite(">master changed idx="&$idx&@CRLF)
	If $idx < 1 Then ;catch -1
		_GUICtrlEdit_SetReadOnly($UI_In_master_Cust, False)
		SetUITheme_inputBox($UI_In_master_Cust, $g_UseTheme, True)
	Else
		_GUICtrlEdit_SetReadOnly($UI_In_master_Cust, True)
		SetUITheme_inputBox($UI_In_master_Cust, $g_UseTheme, False)
	EndIf
EndFunc

GUICtrlSetOnEvent($UI_Combo_master, 'UI_Combo_masterChange')
Func UI_Combo_masterChange()
	SetUI_masterCust_State()
	GameSetup_Store() ; update master used
	UpdateMasterDisplay()
EndFunc


GUICtrlSetOnEvent($UI_Combo_gameSelector, 'UI_Combo_gameSelectorChange')
Func UI_Combo_gameSelectorChange()
	ConsoleWrite("!channn"&@CRLF)
	GameSetup_Store() ;save prev settings
	ComboChanged_SyncTab() ;switch tab if
	GameSetup_UpdateUI()

	SetSelectedGameID()
	If $g_iTabNum = $TAB_MB Or $g_iCurGameID >= $COUNT_GAME then
		return
	EndIf

	;clear selected column.
	GUICtrlSendMsg($UI_ListV_svData_A, $LVM_SETSELECTEDCOLUMN, -1, 0) ;updateLV

	;EnableUIButtons(False)
	BeginGettinServers()
	ListviewStoreIndexToArray($g_iCurGameID, True)

	Local $iGameIdx = $g_iCurGameID ;GetActiveGameIndex()
	local $iCount = GetServerCountInArray($iGameIdx)
	Local $aServerIdx[$iCount]
	Local $ListViewA = getListView_A_CID()
	Local $ListViewB = getListView_B_CID()
	Local $ListViewC = getListView_C_CID()

	_GUICtrlListView_DeleteAllItems($ListViewA)
	_GUICtrlListView_DeleteAllItems($ListViewB)
	_GUICtrlListView_DeleteAllItems($ListViewC)

	For $i = 0 To $iCount-1
		$aServerIdx[$i] = $i
	Next
	;FillServerStringArrayIP($iGameIdx, $ipArray)
	;FillServerStringArrayPing($iGameIdx, 999, $g_iServerCountTotal)

	ConsoleWrite('-game sel changed0'&@CRLF)

	If _IsChecked($UI_Btn_filterOffline) or _IsChecked($UI_Btn_filterEmpty) or _IsChecked($UI_Btn_filterFull) Then
		ConsoleWrite('-game sel changed1'&@CRLF)
		FillListView_A_Filtered($iGameIdx, $ListViewA, True)
	Else
		ConsoleWrite('-game sel changed2'&@CRLF)
		FillServerListView_popData($iGameIdx, $ListViewA) ;update listview ip
		FillListView_A_FullData($iGameIdx, $aServerIdx, 0, $iCount-1) ;full update
	EndIf

	;ResetServerListArrays
	FinishedGettinServers();/
EndFunc

Func SetActiveTab($iTab)
	_GUICtrlTab_SetCurSel($tabGroupGames, $iTab)
	_GUICtrlTab_ActivateTab($tabGroupGames, $iTab)
EndFunc

Func ComboChanged_SyncTab()
	;sync tab/gameSelector
	Local $iTab = GUICtrlRead($tabGroupGames)
	Local $idx = ComboBoxEx_GetCurSel()

	Switch $idx
		Case $COUNT_GAME ;$ID_M
			if $iTab = $TAB_GB Then
				$g_iTabNum = $TAB_MB
				SetActiveTab($TAB_MB)
			EndIf
		Case 0 to $COUNT_GAME -1
			$g_iGSGameLast = $idx
			if $iTab = $TAB_MB Then
				$g_iTabNum = $TAB_GB
				SetActiveTab($TAB_GB)
			EndIf
	EndSwitch
EndFunc

Func FixGameComboIndex(ByRef $idx, $iGameIdx)
	;FixGameComboIndex($g_aGameSetup_Master_Combo[$idx])
	if $idx	< 0 then
		$idx = 0
		ConsoleWrite("!fixed combo index1"&@CRLF)
	Else
		Local $iCount = StringSplit($g_gameConfig[$iGameIdx][$MASTER_ADDY], "|")[0] ; _GUICtrlComboBox_GetCount($UI_Combo_master)
		If $iCount > 0 and $idx > $iCount Then
			$idx = $iCount
			ConsoleWrite("!fixed combo idx2"&@CRLF)
		EndIf
	EndIf
EndFunc

Func GameSetup_Store() ;store values (tab-change or ini-save)
	Local $idx = $g_iGameSetupLastIdx  ; _GUICtrlComboBox_GetCurSel($UI_Combo_gameSetup)
	ConsoleWrite("+GameSetup_Store() id:"&$idx&@CRLF)
	if $idx >= 0 And $idx < $COUNT_GAME Then
		$g_aGameSetup[$idx][$GCFG_MAST_DEF]   = _GUICtrlComboBox_GetCurSel($UI_Combo_master)
		$g_aGameSetup[$idx][$GCFG_MAST_CUST]  = GUICtrlRead($UI_In_master_Cust)
		$g_aGameSetup[$idx][$GCFG_MAST_PROTO] = GUICtrlRead($UI_In_master_proto)
		$g_aGameSetup[$idx][$GCFG_EXE_PATH]   = GUICtrlRead($UI_In_gamePath)
		$g_aGameSetup[$idx][$GCFG_NAME_PLYR]  = GUICtrlRead($UI_In_playerName)
		$g_aGameSetup[$idx][$GCFG_RUN_CMD]    = GUICtrlRead($UI_In_runCmd)
		setBitvalue($g_aGameSetup[$idx][$GCFG_AUTO_REF], _IsChecked($UI_CBox_gameRefresh), 1)
		setBitvalue($g_aGameSetup[$idx][$GCFG_AUTO_REF], _IsChecked($UI_CBox_gamePingAll), 2)
		ConsoleWrite("!store id:"&$g_aGameSetup[$idx][$GCFG_AUTO_REF]&@CRLF)
		;check counts
		FixGameComboIndex($g_aGameSetup[$idx][$GCFG_MAST_DEF], $idx)
	EndIf
	;_ArrayDisplay($g_aGameSetup[$GCFG_AUTO_REF])
EndFunc

Func UpdateMasterDisplay()
	Local $idx = ComboBoxEx_GetCurSel()
	switch $idx
		Case 0 to $COUNT_GAME -1
			local $aMaster_addy = GetMasterAddressFromSettings($idx)
			GUICtrlSetData($UI_Text_masterDisplay,  " " &$aMaster_addy& " ") ;"Master: "&
			GUICtrlSetTip($UI_Text_masterDisplay, $aMaster_addy)
		case else
			GUICtrlSetData($UI_Text_masterDisplay, "")
			GUICtrlSetTip($UI_Text_masterDisplay,"")
	EndSwitch
EndFunc

;load game data
Func GameSetup_UpdateUI()
	Local $idx = ComboBoxEx_GetCurSel()
	$g_iGameSetupLastIdx = $idx
	ConsoleWrite("+gameChanged update UI="&$idx&@CRLF)
	if $idx < $COUNT_GAME Then
		GUICtrlSetData($UI_Text_setupTitle, $g_gameConfig[$idx][$GNAME_MENU])            ;title
		GUICtrlSetData($UI_Combo_master, "|Custom Master|" & $g_gameConfig[$idx][$MASTER_ADDY]) ;master list. rebuild
		_GUICtrlComboBox_SetCurSel($UI_Combo_master, $g_aGameSetup[$idx][$GCFG_MAST_DEF])   ;selection id
		GUICtrlSetData($UI_In_master_Cust, $g_aGameSetup[$idx][$GCFG_MAST_CUST])
		GUICtrlSetData($UI_In_master_proto, $g_aGameSetup[$idx][$GCFG_MAST_PROTO])
		GUICtrlSetData($UI_In_gamePath, $g_aGameSetup[$idx][$GCFG_EXE_PATH])
		GUICtrlSetData($UI_In_playerName, $g_aGameSetup[$idx][$GCFG_NAME_PLYR])
		GUICtrlSetData($UI_In_runCmd, $g_aGameSetup[$idx][$GCFG_RUN_CMD])
		_SetCheckedState($UI_CBox_gameRefresh, BitAND($g_aGameSetup[$idx][$GCFG_AUTO_REF], 1))
		_SetCheckedState($UI_CBox_gamePingAll, BitAND($g_aGameSetup[$idx][$GCFG_AUTO_REF], 2))
		_SetDisabledState($UI_CBox_tryNextMaster, Not BitAND($g_aGameSetup[$idx][$GCFG_AUTO_REF], 2))
	ElseIf $idx = $COUNT_GAME Then ;$ID_M Then
		;$g_iTabNum = $TAB_GB
		GUICtrlSetData($UI_Text_setupTitle, "M-Browser")
		GUICtrlSetData($UI_Combo_master, "|") ;master list. rebuild
		_GUICtrlComboBox_SetCurSel($UI_Combo_master, 0)   ;selection id
		GUICtrlSetData($UI_In_master_Cust, "")
		GUICtrlSetData($UI_In_master_proto, "")
		GUICtrlSetData($UI_In_gamePath, "")
		GUICtrlSetData($UI_In_playerName, "")
		GUICtrlSetData($UI_In_runCmd, "")
		_SetCheckedState($UI_CBox_gameRefresh, False)
		_SetCheckedState($UI_CBox_gamePingAll, False)
		_SetDisabledState($UI_CBox_tryNextMaster, True)
		;_GUICtrlTab_ActivateTab($tabGroupGames, $TAB_MB)
	EndIf
	UpdateMasterDisplay()
	;update disabled state
	UI_Combo_masterChange()
EndFunc

Func _SetCheckedState($hw, $bValue)
	If $bValue Then
		GUICtrlSetState($hw, $GUI_CHECKED)
	Else
		GUICtrlSetState($hw, $GUI_UNCHECKED)
	EndIf
EndFunc

Func _SetDisabledState($hw, $bValue)
	If $bValue Then
		GUICtrlSetState($hw, $GUI_ENABLE)
	Else
		GUICtrlSetState($hw, $GUI_DISABLE)
	EndIf
EndFunc

;==============
;M load startup
;LoadGameOnStartupOpt()
Func LoadGameOnStartupOpt()
	Local $idx = ComboBoxEx_GetCurSel()

	If $idx = $COUNT_GAME Then ; $ID_M Then
		$g_iTabNum = $TAB_MB
		SetActiveTab($TAB_MB)
		SetButtoShowState($TAB_MB)
		;MRefresh()
	Else
		$g_iTabNum = $TAB_GB
		SetActiveTab($TAB_GB)
		ComboBoxEx_SetCurSel($idx)
		$g_iGSGameLast = $idx
	EndIf
EndFunc
;==============

#EndRegion --> END STARTUP


#Region --> INI FILE
;========================================================
;--> ini file setup

Func iniFileSetChkBox(Const $sValue, ByRef $hw, ByRef $globalVal)
	Local $aTmp = _StringBetween($sValue, '"' , '"')
	Local $val = 0
	;ConsoleWrite("chkbox:"&$sValue&@CRLF)
	If not @error Then
		$val = Number($aTmp[0])
	Else
		$val = Number($sValue)
	EndIf

	_SetCheckedState($hw, $val)
	if Not ($globalVal = Null) Then $globalVal = ($val)?(True):(False)
EndFunc

Func iniFileSetCtrlData(Const $sValue, ByRef $hw)
	Local $aTmp = _StringBetween($sValue, '"' , '"')
	If not @error Then
		GUICtrlSetData($hw, $aTmp[0])
	Else
		GUICtrlSetData($hw, $sValue)
	EndIf
EndFunc

Func iniFileSetDropdown(Const $sValue, ByRef $hw)
	Local $aTmp = _StringBetween($sValue, '"' , '"')
	If not @error Then
		Local $iVal = Number($aTmp[0])
		if $iVal >= 0 Then
			_GUICtrlComboBox_SetCurSel($hw, $iVal)
		EndIf
	Else
		_GUICtrlComboBox_SetCurSel($hw, Number($sValue))
	EndIf
EndFunc

Func iniFileSetDropdownEx(Const $sValue, ByRef $hw)
	Local $aTmp = _StringBetween($sValue, '"' , '"')
	Local $iVal
	If not @error Then
		$iVal = Number($aTmp[0])
	Else
		$iVal = Number($sValue)
	EndIf

	if $iVal >= 0 Then
		;ComboBoxEx_SetCurSel($idx)
		_GUICtrlComboBoxEx_SetCurSel($hw, $iVal)
	EndIf
EndFunc

Func iniFileSetFav(const $sValue, $iGameIDx)
	Local $aTmp = _StringBetween($sValue, '"' , '"')
	Local $fav = ""
	If not @error Then
		$fav = $aTmp[0]
	Else
		$fav = $sValue
	EndIf

	If $g_aFavList[$iGameIDx] <> "" Then
		$g_aFavList[$iGameIDx] &= "|" & $fav
	Else
		$g_aFavList[$iGameIDx] = $fav
	EndIf
EndFunc

Func iniFileSetDropdownGame(Const $sValue, ByRef $array)
	Local $aTmp = _StringBetween($sValue, '"' , '"')
	If not @error Then
		$array = Number($aTmp[0]) ;todo check this
	Else
		$array = Number($sValue)
	EndIf
EndFunc

Func iniFileSet_GameSettings_Str(Const $sValue, ByRef $array)
	Local $aTmp = _StringBetween($sValue, '"' , '"')
	If not @error Then
		$array = String($aTmp[0])
	Else
		$array = String($sValue)
	EndIf
EndFunc

Func iniFileSet_GameSettings_Num(Const $sValue, ByRef $array)
	Local $aTmp = _StringBetween($sValue, '"' , '"')
	If not @error Then
		$array = Number($aTmp[0])
	Else
		$array = Number($sValue)
	EndIf
EndFunc

Func gameCFG_EOT_type($sData)
	Select
		Case StringCompare($sData,'Q1') = 0
			Return $EOT_Q1
		Case StringCompare($sData,'Q2') = 0
			Return $EOT_Q2
		Case StringCompare($sData,'Q3') = 0
			Return $EOT_Q3
		Case StringCompare($sData,'DP') = 0
			Return $EOT_DP
		Case Else
			Return $EOT_NONE
	EndSelect
EndFunc

Func gameCFG_C2S_type($sData)
	Select
		Case StringCompare($sData,'Q1') = 0
			Return $C2S_Q1
		Case StringCompare($sData,'Q2') = 0
			Return $C2S_Q2
		Case StringCompare($sData,'Q3') = 0
			Return $C2S_Q3
		Case StringCompare($sData,'MOH') = 0
			Return $C2S_MOH
		Case StringCompare($sData,'HEX2') = 0
			Return $C2S_HEX2
		Case StringCompare($sData,'HW') = 0
			Return $C2S_HW
		Case StringCompare($sData,'GS') = 0
			Return $C2S_GS
		Case Else
			Return $C2S_NONE
	EndSelect
EndFunc

Func gameCFG_S2C_type($sData)
	Select
		Case StringCompare($sData,'Q1') = 0
			Return $S2C_Q1
		Case StringCompare($sData,'Q2') = 0
			Return $S2C_Q2
		Case StringCompare($sData,'Q3') = 0
			Return $S2C_Q3
		Case StringCompare($sData,'HEX2') = 0
			Return $S2C_HEX2
		Case StringCompare($sData,'HW') = 0
			Return $S2C_HW
		Case StringCompare($sData,'GS') = 0
			Return $S2C_GS
		Case Else
			Return $S2C_NONE
	EndSelect
EndFunc

Func gameCFG_C2M_type($sData)
	Select
		Case StringCompare($sData,'Q1') = 0
			Return $C2M_Q1
		Case StringCompare($sData,'Q2') = 0
			Return $C2M_Q2
		Case StringCompare($sData,'Q3') = 0
			Return $C2M_Q3
		Case StringCompare($sData,'Q3ET') = 0
			Return $C2M_Q3ET
		Case StringCompare($sData,'HEX2') = 0
			Return $C2M_HEX2
		Case StringCompare($sData,'HW') = 0
			Return $C2M_HW
		Case StringCompare($sData,'AA') = 0
			Return $C2M_AA
		Case StringCompare($sData,'PB2') = 0
			Return $C2M_PB2
		Case StringCompare($sData,'GS') = 0
			Return $C2M_GS
		Case Else
			Return $C2M_NONE
	EndSelect
EndFunc

Func gameCFG_M2C_type($sData)
	Select
		Case StringCompare($sData,'Q1') = 0
			Return $M2C_Q1
		Case StringCompare($sData,'Q2') = 0
			Return $M2C_Q2
		Case StringCompare($sData,'Q3') = 0
			Return $M2C_Q3
		Case StringCompare($sData,'Q3ET') = 0
			Return $M2C_Q3ET
		Case StringCompare($sData,'HEX2') = 0
			Return $M2C_HEX2
		Case StringCompare($sData,'JEDI') = 0
			Return $M2C_JEDI
		Case StringCompare($sData,'STEF1') = 0
			Return $M2C_STEF1
		Case StringCompare($sData,'PB2') = 0
			Return $M2C_PB2
		Case Else
			Return $M2C_NONE
	EndSelect
EndFunc

Func gameCFG_CLEAN_type($sData)
	Select
		Case StringCompare($sData,'SOF1') = 0
			Return $CLEAN_SOF1
		Case StringCompare($sData,'Q3') = 0
			Return $CLEAN_Q3
		Case Else
			Return $CLEAN_NONE
	EndSelect
EndFunc

Func gameCFG_BOT_type($sData)
	Select
		Case StringCompare($sData,'Q2') = 0 ;wallfly
			Return $BOT_Q2
		Case StringCompare($sData,'Q3') = 0 ;ping < 2
			Return $BOT_Q3
		Case Else
			Return $BOT_NONE
	EndSelect
EndFunc


Func iniFile_CFG_Load()
	local $aSection, $g_off, $sSecName
	local $sFileName = $g_sGameCfgPath
	local $aSecNames = IniReadSectionNames($sFileName)
	if @error Then
		MsgBox(0, 'ERROR: cant read config', 'Config file missing', 0, $HypoGameBrowser)
		ExitScript()
	Else
		;remove disabled games (reduce gui game list)
		local $ret
		For $i = $aSecNames[0] To 1 Step -1
			If IniRead($sFileName, $aSecNames[$i], 'enabled_in_ui', '1') = '0' Then
				ConsoleWrite("!Inactive game idx:"&$i&" name:"&$aSecNames[$i] &@CRLF)
				$ret = _ArrayDelete($aSecNames, $i)
				If $ret > -1 Then
					ConsoleWrite("-count:"&$aSecNames[0]&" new:"&$ret&@CRLF)
					$aSecNames[0] = $ret - 1
				Else
					ConsoleWrite("!failed array delete err#:"&@error&@CRLF)
				EndIf
			EndIf
		Next

		$COUNT_GAME += $aSecNames[0]
		Redim $g_gameConfig[$COUNT_GAME][$COUNT_CFG]
		Redim $g_aServerStrings[$COUNT_GAME][$g_iMaxSer][$COUNT_COL]
		Redim $g_aFavList[$COUNT_GAME]
		Redim $g_aGameSetup[$COUNT_GAME][$COUNT_GCFG]
		Redim $g_aIconIdx[$COUNT_GAME+1]

		For $i = 1 to $aSecNames[0]
			$g_off = $i + $COUNT_GAME_INIT - 1
			$sSecName = $aSecNames[$i]
			$g_gameConfig[$g_off][$GNAME_MENU]    = $sSecName
			$g_gameConfig[$g_off][$GNAME_SAVE]    =                    IniRead($sFileName, $sSecName, 'savename',          'NULL')
			$g_gameConfig[$g_off][$GNAME_GS]      =                    IniRead($sFileName, $sSecName, 'gamespyname',       'NULL')
			$g_gameConfig[$g_off][$GNAME_DP]      =                    IniRead($sFileName, $sSecName, 'darkplacename',     '')
			$g_gameConfig[$g_off][$NET_C2S]       = gameCFG_C2S_type(  IniRead($sFileName, $sSecName, 'c2s_msg_type',      'Q2'))
			$g_gameConfig[$g_off][$NET_S2C]       = gameCFG_S2C_type(  IniRead($sFileName, $sSecName, 's2c_msg_type',      'Q2'))
			$g_gameConfig[$g_off][$NET_GS_P]      = Number(            IniRead($sFileName, $sSecName, 'gs_qport',          '0'))
			$g_gameConfig[$g_off][$NET_C2M]       = gameCFG_C2M_type(  IniRead($sFileName, $sSecName, 'c2m_msg_type',      'Q2'))
			$g_gameConfig[$g_off][$NET_C2M_Q3PRO] =                    IniRead($sFileName, $sSecName, 'c2m_q3protocol',    '')
			$g_gameConfig[$g_off][$NET_M2C]       = gameCFG_M2C_type(  IniRead($sFileName, $sSecName, 'm2c_msg_type',      'Q2'))
			$g_gameConfig[$g_off][$NET_M2C_SEP]   = Number(            IniRead($sFileName, $sSecName, 'm2c_msg_sep_count', '0'))
			$g_gameConfig[$g_off][$NET_M2C_EOT]   = gameCFG_EOT_type(  IniRead($sFileName, $sSecName, 'm2c_msg_eot',       ''))
			$g_gameConfig[$g_off][$SV_CLEAN]      = gameCFG_CLEAN_type(IniRead($sFileName, $sSecName, 'sv_name_type',      ''))
			$g_gameConfig[$g_off][$BOT_TYPE]      = gameCFG_BOT_type(  IniRead($sFileName, $sSecName, 'sv_bot_type',       ''))
			$g_gameConfig[$g_off][$ICON_PATH]     =                    IniRead($sFileName, $sSecName, 'icon',              '')
			$g_gameConfig[$g_off][$MASTER_ADDY]   =                    IniRead($sFileName, $sSecName, 'masters',           '')
		Next
	EndIf
EndFunc

Func iniFile_Load()
	local $sFileName = StringTrimRight(@ScriptFullPath, 4) & ".ini"
	Local $cfg_Pos, $_null = Null; unused, for byref

	;set default master selection. incase ini outdated
	For $i = 0 to $COUNT_GAME -1
		$g_aGameSetup[$i][$GCFG_EXE_PATH] = StringFormat("%s.exe", $g_gameConfig[$i][$GNAME_MENU]) ;game.exe
		$g_aGameSetup[$i][$GCFG_MAST_DEF] = 1 ;idx
	Next

	;check for first run
	If not FileExists($sFileName) Then
		Return
	EndIf

	ConsoleWrite("-----========= loading ini =========-----" & @CRLF)
	$g_cfgVersion = Number(IniRead($sFileName, 'Settings', 'Version', '0'))
	$cfg_Pos         = IniRead($sFileName,   'Settings', 'Position', '100 100 830 660')
	iniFileSetDropdownEx(IniRead($sFileName, 'Settings', 'StartupGame',     '0'), $UI_Combo_gameSelector)
	iniFileSetChkBox(IniRead($sFileName,     'Settings', 'PlaySounds',      '0'), $UI_CBox_sound,         $_null)
	iniFileSetChkBox(IniRead($sFileName,     'Settings', 'MinimizeToTray',  '0'), $UI_CBox_minToTray,     $_null)
	iniFileSetDropdown(IniRead($sFileName,   'Settings', 'UseTheme',        '1'), $UI_Combo_theme)
	iniFileSetChkBox(IniRead($sFileName,     'Settings', 'PingNextMaster',  '0'), $UI_CBox_tryNextMaster, $_null)
	iniFileSetChkBox(IniRead($sFileName,     'Settings', 'AutoRefresh',     '0'), $UI_CBox_autoRefresh,   $g_bAutoRefresh)
	iniFileSetCtrlData(IniRead($sFileName,   'Settings', 'AutoRefreshTime', '3'), $UI_In_refreshTime)
	iniFileSetDropdown(IniRead($sFileName,   'Settings', 'HotkeyAlt',       '0'), $UI_Combo_hKey)
	iniFileSetCtrlData(IniRead($sFileName,   'Settings', 'Hotkey',          ''),  $UI_In_hotKey)

	;fav
	Local $aFav = IniReadSection($sFileName, 'Favourites')
	if Not @error Then
		Local $sFav = 'Fav'
		If $g_cfgVersion >= 1 Then $sFav = ''
		For $i = 1 to $aFav[0][0]
			For $j = 0 to $COUNT_GAME -1
				If StringInStr($aFav[$i][0], $sFav & $g_gameConfig[$j][$GNAME_SAVE], $STR_NOCASESENSEBASIC) Then
					iniFileSetFav($aFav[$i][1], $j)
					ExitLoop
				EndIf
			Next
		Next
	EndIf

	;position
	Local $aTmp = StringSplit($cfg_Pos, ' ', 0)
	If not @error And $aTmp[0] >= 4 Then
			;make sure size is not below min allowed
		If $aTmp[3] < $GUIMINWID Then $aTmp[3] = $GUIMINWID
		If $aTmp[4] < $GUIMINHT  Then $aTmp[4] = $GUIMINHT
		WinMove($HypoGameBrowser, $HypoGameBrowser, Number($aTmp[1]), Number($aTmp[2]), Number($aTmp[3]), Number($aTmp[4]))
		SetWinSizeForMinimize() ; save location to memory now, incase
	EndIf

	Local $secNames[7][2] = [ _
		['MasterUsed',     'MasterUsed'], _
		['MasterCustom',   'MasterCustom'], _
		['MasterProtocol', 'MasterProtocol'], _
		['exePath',        'ExePath'], _
		['Name',           'Name'], _
		['Commands',       'RunOpt'], _
		['AutoRefresh',    'Refresh']]

	if $g_cfgVersion >= 1 Then
		For $i = 0 To 6
			$secNames[$i][1] = '' ;not needed
		Next
	EndIf

	local $sSaveStr
	For $i=0 To $COUNT_GAME -1
		$sSaveStr = $g_gameConfig[$i][$GNAME_SAVE]
		iniFileSetDropdownGame(     IniRead($sFileName, $secNames[0][0], $secNames[0][1] & $sSaveStr, '1'), $g_aGameSetup[$i][$GCFG_MAST_DEF])
		FixGameComboIndex($g_aGameSetup[$i][$GCFG_MAST_DEF], $i) ;fix invalid save index
		iniFileSet_GameSettings_Str(IniRead($sFileName, $secNames[1][0], $secNames[1][1] & $sSaveStr, ''),  $g_aGameSetup[$i][$GCFG_MAST_CUST])
		iniFileSet_GameSettings_Str(IniRead($sFileName, $secNames[2][0], $secNames[2][1] & $sSaveStr, ''),  $g_aGameSetup[$i][$GCFG_MAST_PROTO])
		iniFileSet_GameSettings_Str(IniRead($sFileName, $secNames[3][0], $secNames[3][1] & $sSaveStr, ''),  $g_aGameSetup[$i][$GCFG_EXE_PATH])
		iniFileSet_GameSettings_Str(IniRead($sFileName, $secNames[4][0], $secNames[4][1] & $sSaveStr, ''),  $g_aGameSetup[$i][$GCFG_NAME_PLYR])
		iniFileSet_GameSettings_Str(IniRead($sFileName, $secNames[5][0], $secNames[5][1] & $sSaveStr, ''),  $g_aGameSetup[$i][$GCFG_RUN_CMD])
		iniFileSet_GameSettings_Num(IniRead($sFileName, $secNames[6][0], $secNames[6][1] & $sSaveStr, ''),  $g_aGameSetup[$i][$GCFG_AUTO_REF])
	Next

	if $g_cfgVersion < 1 Then
		_FileCreate($sFileName)
		iniFile_Save() ;update format straightaway
		;~ For $i = 0 To 6
		;~ 	IniDelete ($sFileName, $secNames[$i][0]) ;remove old key/vals
		;~ Next
		;~ IniDelete($sFileName, 'Settings', Default)
		;~ IniDelete($sFileName, 'Favourites', Default)
	EndIf

	ConsoleWrite("-----========= loading ini DONE=========-----" & @CRLF)
EndFunc

Func iniFile_Load_Fix()
	;fill defaults
	For $i = 0 to $COUNT_GAME -1
		if $g_aGameSetup[$i][$GCFG_MAST_PROTO] = "" and $g_gameConfig[$i][$NET_C2M_Q3PRO] <> "" then
			$g_aGameSetup[$i][$GCFG_MAST_PROTO] = $g_gameConfig[$i][$NET_C2M_Q3PRO]
		EndIf
	Next
EndFunc

Func getCboxStr(ByRef $hw)
	;return value as string
	if _IsChecked($hw) Then
		Return "1"
	Else
		Return "0"
	EndIf
EndFunc

Func getComboStr(ByRef $hw)
	Return String(_GUICtrlComboBox_GetCurSel($hw))
EndFunc

Func getComboExStr(ByRef $hw)
	Return String(_GUICtrlComboBoxEx_GetCurSel($hw))
EndFunc

Func iniFile_Save()
	ConsoleWrite("-----========= saving=========-----" & @CRLF)
	local $iniFileCFG = string(StringTrimRight(@ScriptFullPath, 4) & ".ini")
	local $stateMinimized = WinGetState($HypoGameBrowser)
	Local $v = WinGetPos($HypoGameBrowser), $sSaveStr

	if BitAND($stateMinimized,16) Or BitAND($stateMinimized, 32) Then ;16=minimized 32 maximized
		$v = $g_aStoredWinSize
		ConsoleWrite(" window old resize saved instead.."&@CRLF)
	EndIf

	GameSetup_Store() ; save current master values

	;make sure size is not below min allowed
	If $v[2] < $GUIMINWID Then $v[2] = $GUIMINWID
	If $v[3] < $GUIMINHT Then $v[3] = $GUIMINHT

	IniWriteSection($iniFileCFG, 'Settings', _
		'Version='         & '1' &@LF& _
		'Position='        & StringFormat('%s %s %s %s', $v[0], $v[1], $v[2], $v[3]) &@LF& _
		'StartupGame='     & StringFormat('%s', getComboExStr($UI_Combo_gameSelector)) &@LF& _
		'PlaySounds='      & StringFormat('%s', getCboxStr($UI_CBox_sound)) &@LF& _
		'MinimizeToTray='  & StringFormat('%s', getCboxStr($UI_CBox_minToTray)) &@LF& _
		'UseTheme='        & StringFormat('%s', getComboStr($UI_Combo_theme)) &@LF& _
		'PingNextMaster='  & StringFormat('%s', getCboxStr($UI_CBox_tryNextMaster)) &@LF& _
		'AutoRefresh='     & StringFormat('%s', getCboxStr($UI_CBox_autoRefresh)) &@LF& _
		'AutoRefreshTime=' & StringFormat('%s', GUICtrlRead($UI_In_refreshTime)) &@LF& _
		'HotkeyAlt='       & StringFormat('%s', getComboStr($UI_Combo_hkey)) &@LF& _
		'Hotkey='          & StringFormat('%s', GUICtrlRead($UI_In_hotKey)) &@LF)

	Local $secNames[7] = [ _
		'MasterUsed', _
		'MasterCustom', _
		'MasterProtocol', _
		'exePath', _
		'Name', _
		'Commands', _
		'AutoRefresh']

	For $i = 0 to $COUNT_GAME-1
		$sSaveStr = $g_gameConfig[$i][$GNAME_SAVE]
		IniWrite($iniFileCFG, $secNames[0], $sSaveStr, StringFormat('%s', getSelectedMasterIndex($i)))
		IniWrite($iniFileCFG, $secNames[1], $sSaveStr, StringFormat('%s', $g_aGameSetup[$i][$GCFG_MAST_CUST]))
		IniWrite($iniFileCFG, $secNames[2], $sSaveStr, StringFormat('%s', $g_aGameSetup[$i][$GCFG_MAST_PROTO]))
		IniWrite($iniFileCFG, $secNames[3], $sSaveStr, StringFormat('%s', $g_aGameSetup[$i][$GCFG_EXE_PATH]))
		IniWrite($iniFileCFG, $secNames[4], $sSaveStr, StringFormat('%s', $g_aGameSetup[$i][$GCFG_NAME_PLYR]))
		IniWrite($iniFileCFG, $secNames[5], $sSaveStr, StringFormat('%s', $g_aGameSetup[$i][$GCFG_RUN_CMD]))
		IniWrite($iniFileCFG, $secNames[6], $sSaveStr, StringFormat('%s', $g_aGameSetup[$i][$GCFG_AUTO_REF]))
	Next

	;favourite
	Local $sFavData = ""
	For $i = 0 to $COUNT_GAME-1
		Local $aTmp = StringSplit($g_aFavList[$i], "|")
		For $j = 1 to $aTmp[0]
			If $aTmp[$j] <> "" Then
				$sFavData &= $g_gameConfig[$i][$GNAME_SAVE] &'='& $aTmp[$j] &@LF
			EndIf
		Next
	Next
	IniWriteSection($iniFileCFG, 'Favourites', $sFavData)

	ConsoleWrite("-----========= saving DONE=========-----" & @CRLF)
EndFunc ;--> end ini file setup
;========================================================
#EndRegion


#Region --> M-BROWSER
	Func MRefresh()
		M_GetServerList()
		M_SetServerTabArray()
	EndFunc

	#Region --> M-BROWSER add server ports

	;================
	;-->selected game
	Func M_Host_getGameName()
		;_GUICtrlComboBox_GetCurSel
		Local $sGame = GUICtrlRead($UI_Combo_M_addServer)
		If $sGame = "" Then
			Return "kingpin" ;  "kingpinq3" "quake2"
		Else
			Return $sGame ;"kingpin"|"kingpinq3"|"quake2"
		EndIf
	EndFunc

	;===================
	;--> set port string
	Func M_Host_getPortString()
		return GUICtrlRead($UI_In_getPortM)
	EndFunc

	Func M_Hosted_sendData($sCommand, $sInfo)
		Local $sPortToUse = M_Host_getPortString() ;set port from string
		Local $sGameName = M_Host_getGameName();set global Gamename for sent port
		;/mbrowser.php?game=kingpin		&	username=	M-Browser+1.8&v=1.8 &join=	removeserver	:31520	&quit=1
		;/mbrowser.php?game=kingpinQ3	&	username=	hypobrowser&v=1.01	&join=	excludeserver	:31620	&quit=1

		Local $sData = StringFormat( _
			"https://hambloch.com/kingpin/mbrowser.php?game=%s&username=%s&v=%s&join=%s:%s&quit=1", _
			$sGameName, StringLower($versionName), $versionNum, $sCommand, $sPortToUse)

		ConsoleWrite($sData&@CRLF)
		Local $ret = MsgBox($MB_OKCANCEL, $sInfo, 'Send "'&$sCommand& '" ?'&@CRLF&@CRLF& $sData, 0, $HypoGameBrowser )
		if $ret = $IDOK Then
			;local $tmpSize =
			InetGetSize($sData,$INET_FORCERELOAD)
		EndIf
	EndFunc

	;==============
	;--> add server
	Func M_ServerAddPortKP()
		M_Hosted_sendData('addserver', "Add Port")
	EndFunc

	;=================
	;--> remove server
	Func M_ServerRemovePortKP()
		M_Hosted_sendData('removeserver', "Remove Port")
	EndFunc

	;==================
	;--> exclude server
	Func M_ServerExcludePortKP()
		M_Hosted_sendData('excludeserver', "Exclude Port")
	EndFunc
	; -->PORT end add game via port settings
	;=============================================================================
	#EndRegion

	;=====================
	;--> M_ServerDetailArray
	Func M_ServerDetailArray($serverInfoString)
		ConsoleWrite("string.. " &$serverInfoString& @CRLF)

		If $serverInfoString = "" Then
			Return False
		Else
			$serverInfoString = StringReplace($serverInfoString, "Info string length exceeded" & Chr(10), "",0 )

			Local $tmpstr = StringSplit($serverInfoString, Chr(10), $STR_ENTIRESPLIT)
			If @error Then
				;MsgBox($MB_SYSTEMMODAL, "","Error in packet, no Return" )
				setTempStatusBarMessage("ERROR: No line feed char found in responce.", True)
				Return
			EndIf

			Local $numLines = $tmpstr[0] ;3 lines standard >= players
			If Not StringInStr($tmpstr[1], GetData_S2C($S2C_Q2), 1, 1, 1, 10) And Not StringInStr($tmpstr[1],GetData_S2C($S2C_Q3), 1, 1, 1, 20) Then
				;MsgBox($MB_SYSTEMMODAL, "","error in packet header (no 'yyyy')" )
				setTempStatusBarMessage("ERROR: Unknown header in responce.", True)
				Return
			EndIf

			Local $serverVars = $tmpstr[2]
			Local $i2
			Local $iRay=0
			Local $intADD1

		;;;; set server string varables
			local $servrVarArray = StringSplit($serverVars, "\" ) ;setup server strings
			if Not @error Then
				_GUICtrlListView_BeginUpdate($ListView2POP)
				_GUICtrlListView_DeleteAllItems($ListView2POP)
				For $i2 = 2 To $servrVarArray[0] Step 2
					$intADD1 = $i2
					$intADD1 += 1
					_GUICtrlListView_AddItem($ListView2POP, $servrVarArray[$i2],-1, 0)
					_GUICtrlListView_AddSubItem($ListView2POP,$iRay, $servrVarArray[$intADD1]	 ,1)	;string
					$iRay += 1
				Next
				_GUICtrlListView_EndUpdate($ListView2POP)
			EndIf

		;;;; add players info, max 31 char for player name
			Local $iply = 3
			If Not ($tmpstr[3] = "") Then
				local $plyr = 0, $playerName ="", $plyrStatus, $plyrStatusArray

				_GUICtrlListView_BeginUpdate($ListView1POP)
				_GUICtrlListView_DeleteAllItems($ListView1POP)
				For $iply = 3 To $numLines Step 1
					If Not ($tmpstr[$iply] = "") Then ;catch end line @LF, EOT

						$playerName = _StringBetween($tmpstr[$iply], '"', '"' ) ;get server name[0]
						$plyrStatus = StringReplace($tmpstr[$iply], '"' & $playerName[0] & '"', "") ;
						$plyrStatusArray = StringSplit($plyrStatus, " " ) ;setup server strings

						_GUICtrlListView_AddItem($ListView1POP, $playerName[0],-1, 0)				;Name
						_GUICtrlListView_AddSubItem($ListView1POP,$plyr, $plyrStatusArray[1] ,1)	;Frags
						_GUICtrlListView_AddSubItem($ListView1POP,$plyr, $plyrStatusArray[2] ,2)	;Ping
						$plyr += 1 ;increase 1
					EndIf
				Next
				_GUICtrlListView_EndUpdate($ListView1POP)
			EndIf
		EndIf

		Return True
	EndFunc
	;--> M_ServerDetailArray
	;=====================


	#Region --> M Get server info strings
	;========================================================
	;--> Get server info strings
	Func M_GetServerPacket($hSocket, $iGameIdx)
		Local $data = ""
		local $getTimeDiffServer = TimerInit()
		Local $sIPAddress, $iPort, $iErrorX

		Local $serverAddress = StringSplit(GetServerListA_SelectedData($LV_A_IP),":")
		If @error Then
			ConsoleWrite("Error: splitting string in M_GetServerPacket()"& @CRLF)
			Return ""
		EndIf

		$sIPAddress = TCPNameToIP( $serverAddress[1])
		$iPort = $serverAddress[2]

		$iErrorX = _UDPSendTo($sIPAddress, $iPort, sendStatusMessageType_UDP($iGameIdx, True), ($hSocket))
		if @error Then
			ConsoleWrite("UDP Send \status\ sock error =  " & $iErrorX & " error" & @CRLF)
			Return
		EndIf

		Do ;loop untill complet info string is recieved or timed out. 3.5 seconds
			$data = _UDPRecvFrom(($hSocket), 10000, 0)
			If TimerDiff($getTimeDiffServer) > 3500 Then
				ConsoleWrite("error geting packet "&@CRLF)
				Return ""
			EndIf
			Sleep(20)
		Until IsArray($data)

		ConsoleWrite(" packet recieved: "& $data[$PACKET_DATA]& @CRLF)

		Return $data[$PACKET_DATA] ;$serverInfoString
	EndFunc
	;--> END Get server info strings
	;========================================================
	#EndRegion


#Region --> GUI game setup
GUI_GameSetup_Build()
Func GUI_GameSetup_Build()
	Local $posXY = WinGetPos($HypoGameBrowser)
	;todo font scale

	#Region ### START Koda GUI section ### Form=C:\Programs\codeing\autoit-v3\SciTe\Koda\Dave\HypoGameBrowser_popup_newgame.kxf
	$GUI_gameSetup = GUICreate("Game Setup  (gameConfig.ini)", 509, 302, 673, 125, -1, -1, $HypoGameBrowser)
	$UI3_In_icon = GUICtrlCreateInput("icon", 92, 144, 157, 21)
	$UI3_Grp_names = GUICtrlCreateGroup("Names", 8, 8, 253, 125)
	$UI3_Text_nameGame = GUICtrlCreateLabel("Game Title", 24, 28, 60, 21, $SS_CENTERIMAGE)
	GUICtrlSetTip(-1, "Game name for menu.")
	$UI3_In_nameGame = GUICtrlCreateInput("", 92, 28, 157, 21)
	GUICtrlSetTip(-1, "Game name for menu.")
	$UI3_Text_nameSave = GUICtrlCreateLabel("Save ID", 24, 52, 60, 21, $SS_CENTERIMAGE)
	GUICtrlSetTip(-1, "Name used in save file. Keep it short and not conflicting.")
	$UI3_In_nameSave = GUICtrlCreateInput("", 92, 52, 157, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_UPPERCASE))
	GUICtrlSetTip(-1, "Name used in save file. Keep it short and not conflicting.")
	$UI3_Text_nameGSpy = GUICtrlCreateLabel("GameSpy", 24, 76, 60, 21, $SS_CENTERIMAGE)
	GUICtrlSetTip(-1, "Gamespy querry name for master.")
	$UI3_In_nameGSpy = GUICtrlCreateInput("", 92, 76, 157, 21)
	GUICtrlSetTip(-1, "Gamespy querry name for master.")
	$UI3_Text_nameDP = GUICtrlCreateLabel("Darkplace", 24, 100, 60, 21, $SS_CENTERIMAGE)
	GUICtrlSetTip(-1, "Darkplace querry name for master. updated Q3 protocol.")
	$UI3_In_nameDP = GUICtrlCreateInput("", 92, 100, 157, 21)
	GUICtrlSetTip(-1, "Darkplace querry name for master. updated Q3 protocol.")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$UI3_Grp_server = GUICtrlCreateGroup("Server Communication", 268, 8, 233, 161)
	$UI3_Text_c2sMSG = GUICtrlCreateLabel("Send MSG", 284, 28, 80, 21, $SS_CENTERIMAGE)
	GUICtrlSetTip(-1, "Message type sent to server.")
	$UI3_Combo_c2sMSG = GUICtrlCreateCombo("", 372, 28, 117, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "NONE|Q1|Q2|Q3|MOH|HEX2|HW|GS", "NONE")
	GUICtrlSetTip(-1, "Message type sent to server.")
	$UI3_Text_s2cMSG = GUICtrlCreateLabel("Responce", 284, 52, 80, 21, $SS_CENTERIMAGE)
	GUICtrlSetTip(-1, "Message type recieved from server.")
	$UI3_Combo_s2cMSG = GUICtrlCreateCombo("", 372, 52, 117, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "NONE|Q1|HEX2|HW|Q2|Q3|GS", "NONE")
	GUICtrlSetTip(-1, "Message type recieved from server.")
	$UI3_Text_gsPort = GUICtrlCreateLabel("GameSpy Port", 284, 76, 80, 21, $SS_CENTERIMAGE)
	GUICtrlSetTip(-1, "Gamespy query port, offset. Kingpin  uses -10(31500) for browser communication.")
	$UI3_In_gsPort = GUICtrlCreateInput("", 372, 76, 117, 21)
	GUICtrlSetTip(-1, "Gamespy query port, offset. Kingpin  uses -10(31500) for browser communication.")
	$UI3_Text_svClean = GUICtrlCreateLabel("Clean HostName", 284, 112, 80, 21, $SS_CENTERIMAGE)
	GUICtrlSetTip(-1, "Clean server name. Q3 uses ^5name for colored text.")
	$UI3_Combo_svClean = GUICtrlCreateCombo("", 372, 112, 117, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "NONE|SOF1|Q3 ", "NONE")
	GUICtrlSetTip(-1, "Clean server name. Q3 uses ^5name for colored text.")
	$UI3_Text_svBot = GUICtrlCreateLabel("Bot Type", 284, 136, 80, 21, $SS_CENTERIMAGE)
	GUICtrlSetTip(-1, "Check for known bot types, and remove from player counts. Q2 uses WallFly and <3 ping. Q3 uses 0 ping.")
	$UI3_Combo_svBot = GUICtrlCreateCombo("", 372, 136, 117, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "NONE|Q2|Q3", "NONE")
	GUICtrlSetTip(-1, "Check for known bot types, and remove from player counts. Q2 uses WallFly and <3 ping. Q3 uses 0 ping.")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$UI3_Grp_master = GUICtrlCreateGroup("Master Communication", 8, 176, 421, 117)
	$UI3_Text_c2mMSG = GUICtrlCreateLabel("Send MSG", 24, 200, 60, 21, $SS_CENTERIMAGE)
	GUICtrlSetTip(-1, "Message type sent to master.")
	$UI3_Combo_c2mMSG = GUICtrlCreateCombo("", 92, 200, 101, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "NONE|Q1|Q2|Q3|Q3ET|HEX2|HW|AA|PB2|GS", "NONE")
	GUICtrlSetTip(-1, "Message type sent to master.")
	$UI3_Text_q3Protocol = GUICtrlCreateLabel("Q3 Protocol", 208, 200, 60, 21, $SS_CENTERIMAGE)
	GUICtrlSetTip(-1, "Quake 3 querry protocol/number. Use pipe (|) to use multiple query.")
	$UI3_In_q3Protocol = GUICtrlCreateInput("", 276, 200, 137, 21)
	GUICtrlSetTip(-1, "Quake 3 querry protocol/number. Use pipe (|) to use multiple query.")
	$UI3_Text_m2cMSG = GUICtrlCreateLabel("Responce", 24, 224, 60, 21, $SS_CENTERIMAGE)
	GUICtrlSetTip(-1, "Message type recieved from master.")
	$UI3_Combo_m2cMSG = GUICtrlCreateCombo("", 92, 224, 101, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "NONE|Q1|Q2|Q3|Q3ET|HEX2|JEDI|STEF1|PB2", "NONE")
	GUICtrlSetTip(-1, "Message type recieved from master.")
	$UI3_Text_m2cEOT = GUICtrlCreateLabel("End of MSG", 208, 224, 60, 21, $SS_CENTERIMAGE)
	GUICtrlSetTip(-1, "End of Transmision(EOT) string. Scans end of message so it can terminate connection early.")
	$UI3_Combo_m2cEOT = GUICtrlCreateCombo("", 276, 224, 101, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "NONE|Q1|Q2|Q3|DP", "NONE")
	GUICtrlSetTip(-1, "End of Transmision(EOT) string. Scans end of message so it can terminate connection early.")
	$UI3_Text_masters = GUICtrlCreateLabel("Addresses", 24, 260, 60, 21, $SS_CENTERIMAGE)
	GUICtrlSetTip(-1, "Master server addresses. Seperate them using pipe (|).")
	$UI3_In_masters = GUICtrlCreateInput("", 92, 260, 325, 21)
	GUICtrlSetTip(-1, "Master server addresses. Seperate them using pipe (|).")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$UI3_Btn_save = GUICtrlCreateButton("Save", 436, 184, 65, 41)
	GUICtrlSetTip(-1, "Save new or update existing game.")
	$UI3_Btn_cancel = GUICtrlCreateButton("Cancel", 436, 260, 65, 33)
	GUICtrlSetTip(-1, "Close dialogbox.")
	$UI3_Text_icon = GUICtrlCreateLabel("Icon", 24, 144, 60, 21, $SS_CENTERIMAGE)
	GUISetState(@SW_HIDE, $GUI_gameSetup)
	#EndRegion ### END Koda GUI section ###
EndFunc

GUI_GameSetup_BuildFinish()
Func GUI_GameSetup_BuildFinish()
	GUISetFont(8* $aDPI[0], 0, 0,  "MS Sans Serif", $GUI_gameSetup)
	GUISetOnEvent($GUI_EVENT_CLOSE, "GUI_gameSetupClose", $GUI_gameSetup)
	GUICtrlSetOnEvent($UI3_Btn_save , "UI3_Btn_saveClick")
	GUICtrlSetOnEvent($UI3_Btn_cancel, "GUI_gameSetupClose")

	if $g_UseTheme Then
		SetUITheme_button($UI3_Btn_save, $g_UseTheme)
		SetUITheme_button($UI3_Btn_cancel, $g_UseTheme)

		Local $hwNames1 = [$UI3_Grp_names,	$UI3_Grp_server, $UI3_Grp_master, $UI3_Text_nameGame, _
		$UI3_Text_nameSave, $UI3_Text_nameGSpy,$UI3_Text_nameDP, $UI3_Text_icon, $UI3_Text_c2sMSG, _
		$UI3_Text_s2cMSG,$UI3_Text_gsPort,	$UI3_Text_svClean,$UI3_Text_svBot,$UI3_Text_c2mMSG,	_
		$UI3_Text_q3Protocol,$UI3_Text_m2cMSG,$UI3_Text_m2cEOT,$UI3_Text_masters]
		For $i = 0 to UBound($hwNames1)-1
			SetUITheme($hwNames1[$i], $g_UseTheme)
		Next

		Local $hwInput = [$UI3_In_masters,$UI3_In_q3Protocol,$UI3_In_gsPort,$UI3_In_nameGSpy, _
		$UI3_In_nameDP,$UI3_In_nameGame,$UI3_In_nameSave,$UI3_In_icon]
		For $i = 0 to UBound($hwInput)-1
			SetUITheme_inputBox($hwInput[$i], $g_UseTheme, True)
		Next

		Local $hwInputDis = [$UI3_Combo_m2cEOT,$UI3_Combo_svClean, _
		$UI3_Combo_svBot,$UI3_Combo_m2cMSG,$UI3_Combo_c2mMSG,$UI3_Combo_s2cMSG,$UI3_Combo_c2sMSG]
		For $i = 0 to UBound($hwInputDis)-1
			SetUITheme_inputBox($hwInputDis[$i], $g_UseTheme, False)
		Next

		SetUITheme_main($GUI_gameSetup, $g_UseTheme)
		SetUITheme($UI3_Grp_master, $g_UseTheme)
	EndIf
EndFunc

Func GUI_gameSetupClose()
	GUISetState(@SW_HIDE,$GUI_gameSetup)
	GUISetState(@SW_ENABLE, $HypoGameBrowser)
	GUISetState(@SW_RESTORE, $HypoGameBrowser)
EndFunc

Func UI3_Btn_saveClick()
	Local $ret = IniWriteSection($g_sGameCfgPath, _
		GUICtrlRead($UI3_In_nameGame), _
		'enabled_in_ui=1'    &@LF& _ ; show in ui
		'savename='          & GUICtrlRead($UI3_In_nameSave) &@LF& _
		'gamespyname='       & GUICtrlRead($UI3_In_nameGSpy) &@LF& _
		'darkplacename='     & GUICtrlRead($UI3_In_nameDP) &@LF& _
		'c2s_msg_type='      & GUICtrlRead($UI3_Combo_c2sMSG) &@LF& _
		's2c_msg_type='      & GUICtrlRead($UI3_Combo_s2cMSG) &@LF& _
		'gs_qport='          & GUICtrlRead($UI3_In_gsPort) &@LF& _
		'c2m_msg_type='      & GUICtrlRead($UI3_Combo_c2mMSG) &@LF& _
		'c2m_q3protocol='    & GUICtrlRead($UI3_In_q3Protocol) &@LF& _
		'm2c_msg_type='      & GUICtrlRead($UI3_Combo_m2cMSG) &@LF& _
		'm2c_msg_eot='       & GUICtrlRead($UI3_Combo_m2cEOT) &@LF& _
		'sv_name_type='      & GUICtrlRead($UI3_Combo_svClean) &@LF& _
		'sv_bot_type='       & GUICtrlRead($UI3_Combo_svBot) &@LF& _
		'icon='              & GUICtrlRead($UI3_In_icon) &@LF& _
		'masters='           & GUICtrlRead($UI3_In_masters) &@LF _
	)

	if $ret Then
		MsgBox(0, 'Save Game', 'Game saved to .ini file OK. Restart Browser to load updated config.', 0, $GUI_gameSetup)
	Else
		MsgBox(0, 'Save Game', 'ERROR: Game not saved to .ini', 0, $GUI_gameSetup)
	EndIf
	GUI_gameSetupClose()
EndFunc

Func UI3_AddCurrentGame()
	SetSelectedGameID()
	Local $iGameIdx = $g_iCurGameID
	Local $sGameName = $g_gameConfig[$iGameIdx][$GNAME_MENU]

	GUICtrlSetData($UI3_In_nameGame,     $sGameName)
	GUICtrlSetData($UI3_In_nameSave,     IniRead($g_sGameCfgPath, $sGameName, 'savename', '' ))
	GUICtrlSetData($UI3_In_nameGSpy,     IniRead($g_sGameCfgPath, $sGameName, 'gamespyname', '' ))
	GUICtrlSetData($UI3_In_nameDP,       IniRead($g_sGameCfgPath, $sGameName, 'darkplacename', '' ))
	_GUICtrlComboBox_SetCurSel($UI3_Combo_c2sMSG,   gameCFG_C2S_type(IniRead($g_sGameCfgPath, $sGameName, 'c2s_msg_type', '')))
	_GUICtrlComboBox_SetCurSel($UI3_Combo_s2cMSG,   gameCFG_S2C_type(IniRead($g_sGameCfgPath, $sGameName, 's2c_msg_type', '')))
	GUICtrlSetData($UI3_In_gsPort,       IniRead($g_sGameCfgPath, $sGameName, 'gs_qport', '0' ))
	_GUICtrlComboBox_SetCurSel($UI3_Combo_c2mMSG,   gameCFG_C2M_type(IniRead($g_sGameCfgPath, $sGameName, 'c2m_msg_type', '')))
	GUICtrlSetData($UI3_In_q3Protocol,   IniRead($g_sGameCfgPath, $sGameName, 'c2m_q3protocol', '' ))
	_GUICtrlComboBox_SetCurSel($UI3_Combo_m2cMSG,   gameCFG_M2C_type(IniRead($g_sGameCfgPath, $sGameName, 'm2c_msg_type', '')))
	_GUICtrlComboBox_SetCurSel($UI3_Combo_m2cEOT,   gameCFG_EOT_type(IniRead($g_sGameCfgPath, $sGameName, 'm2c_msg_eot', '')))
	_GUICtrlComboBox_SetCurSel($UI3_Combo_svClean,  gameCFG_CLEAN_type(IniRead($g_sGameCfgPath, $sGameName, 'sv_name_type', '')))
	_GUICtrlComboBox_SetCurSel($UI3_Combo_svBot,    gameCFG_BOT_type(IniRead($g_sGameCfgPath, $sGameName, 'sv_bot_type', '')))
	GUICtrlSetData($UI3_In_icon,         IniRead($g_sGameCfgPath, $sGameName, 'icon', '' ))
	GUICtrlSetData($UI3_In_masters,      IniRead($g_sGameCfgPath, $sGameName, 'masters', '' ))
EndFunc

GUICtrlSetOnEvent($UI_Btn_gameNew, "UI_Btn_gameNewClick")
Func UI_Btn_gameNewClick()
	UI3_AddCurrentGame()
	Local $posXY = WinGetPos($HypoGameBrowser)
	GUISetState(@SW_DISABLE, $HypoGameBrowser)
	GUISetState(@SW_SHOW, $GUI_gameSetup)
	WinMove($GUI_gameSetup, WinMove, $posXY[0] + 56, $posXY[1] + 78)
	GUISetCoord(33, 33,-1, -1, $GUI_gameSetup)
EndFunc

#EndRegion

	#Region --> server info POPUP
	M_GetServerDetailsPopupFunc()
	Func M_GetServerDetailsPopupFunc()
		Local $posXY = WinGetPos($HypoGameBrowser)

		;--> creat PopUp GUI
		#Region ### START Koda GUI section ### Form=C:\Programs\codeing\autoit-v3\SciTe\Koda\Templates\M_Browser_GUI_ServerInfo1.kxf
		$MPopupInfo = GUICreate("Server Info", 547, 426, $posXY[0], $posXY[1], BitOR($WS_CAPTION, $WS_POPUP, $WS_SYSMENU), -1, $HypoGameBrowser)
		$ListView1POP = GUICtrlCreateListView("Name|Frags|Ping", 8, 16, 296, 401)
		GUICtrlSendMsg($ListView1POP, $LVM_SETCOLUMNWIDTH, 0, 195)
		GUICtrlSendMsg($ListView1POP, $LVM_SETCOLUMNWIDTH, 1, 45)
		GUICtrlSendMsg($ListView1POP, $LVM_SETCOLUMNWIDTH, 2, 45)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		GUICtrlCreateGroup("", 312, 8, 225, 369)
		$ListView2POP = GUICtrlCreateListView("Server Rules|Value", 312, 16, 225, 361)
		GUICtrlSendMsg($ListView2POP, $LVM_SETCOLUMNWIDTH, 0, 85)
		GUICtrlSendMsg($ListView2POP, $LVM_SETCOLUMNWIDTH, 1, 110)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		$serverInfoRefBtn = GUICtrlCreateButton("Refresh", 440, 384, 81, 33)
		$serverInfoConBtn = GUICtrlCreateButton("Connect", 336, 384, 89, 33)
		GUICtrlSetFont($serverInfoConBtn, 8* $aDPI[0], 800, 0, "MS Sans Serif")
		GUISetState(@SW_HIDE,$MPopupInfo)
		GUISetFont(8* $aDPI[0], 0, 0,  "MS Sans Serif", $MPopupInfo)
		#EndRegion ### END Koda GUI section ###
		;--> END creat PopUp GUI

		;if _IsChecked($UI_CBox_theme) Then
		;local $theme = _GUICtrlComboBox_GetCurSel($UI_Combo_theme)
		SetUITheme($ListView1POP, $g_UseTheme)
		SetUITheme($ListView2POP, $g_UseTheme)

		GUISetOnEvent($GUI_EVENT_CLOSE,"M_ExitLoopForm", $MPopupInfo)
		GUICtrlSetOnEvent($serverInfoConBtn,"M_ServerInfoConnectBtn")
		GUICtrlSetOnEvent($serverInfoRefBtn, "M_ServerInfoRefreshBtn")
	EndFunc

	Func M_GetServerDetailsPopup()
		Local $posXY = WinGetPos($HypoGameBrowser)
		GUISetState(@SW_DISABLE, $HypoGameBrowser)
		GUISetState(@SW_SHOW, $MPopupInfo)
		WinMove($MPopupInfo, WinMove, $posXY[0] + 56, $posXY[1] + 78)
		GUISetCoord(33, 33,-1, -1, $MPopupInfo)
		M_ServerInfoRefreshBtn()
	EndFunc

	Func M_ServerInfoRefreshBtn()
		Local $hSocket, $serverInfoString

		SetSelectedGameID() ;todo check this
		M_DisablePopupButtons()
		_BIND_UDP_SOCKET($hSocket)
		if $hSocket > 0 Then
			_UDP_setBuffSize($g_hSocketServerUDP, 256, 10000)
			$serverInfoString = M_GetServerPacket($hSocket, GetActiveGameIndex()) ;$g_iCurGameID
			If Not ($serverInfoString = "") Then
				M_ServerDetailArray($serverInfoString)
			EndIf
			_UDPCloseSocket($hSocket)
		EndIf
		M_EnableMPopupButtons()
	EndFunc

	func M_DisablePopupButtons()
		GUICtrlSetState($serverInfoConBtn, $GUI_DISABLE)
		GUICtrlSetState($serverInfoRefBtn, $GUI_DISABLE)
		GUISetState(@SW_DISABLE,$MPopupInfo)
	EndFunc

	func M_EnableMPopupButtons()
		GUICtrlSetState($serverInfoConBtn, $GUI_ENABLE)
		GUICtrlSetState($serverInfoRefBtn, $GUI_ENABLE)
		GUISetState(@SW_ENABLE,$MPopupInfo)
	EndFunc

	Func M_ServerInfoConnectBtn()
		_GUICtrlListView_DeleteAllItems($ListView2POP) ;hypo delet data
		_GUICtrlListView_DeleteAllItems($ListView1POP) ;hypo delet data
		GUISetState(@SW_HIDE,$MPopupInfo)
		Opt("GUIOnEventMode",1)
		GUISetState(@SW_ENABLE, $HypoGameBrowser)
		GUISetState(@SW_RESTORE, $HypoGameBrowser)
		;WinActive($HypoGameBrowser)
		Start_Kingpin()
	EndFunc

	Func M_ExitLoopForm()
		_GUICtrlListView_DeleteAllItems($ListView2POP) ;hypo delet data
		_GUICtrlListView_DeleteAllItems($ListView1POP) ;hypo delet data
		GUISetState(@SW_HIDE,$MPopupInfo)
		GUISetState(@SW_ENABLE, $HypoGameBrowser)
		GUISetState(@SW_RESTORE, $HypoGameBrowser)
	EndFunc

	;========================================================
	#EndRegion


	#Region --> M_RunGameFrom_MLInk
	;========================================================
	Func M_RunGameFrom_MLInk() ;If FileExists("kingpin.exe") OR ($CmdLine[0]<>"" AND
		Local $idx
		Local Const $cmdString[2][3] = [ _
			["m-browser://", 12, 1], _     ;kp
			["m-browser2://", 13, 2]]      ;kpq3

		If Not $CmdLine[0] Then
			;no commands to process
			return
		EndIf

		For $i = 0 To 1
			$idx = StringInStr($CmdLine[1], $cmdString[$i][0])
			If $idx Then
				Local $runServerAddress = StringTrimLeft($CmdLine[1], $idx + $cmdString[$i][1] -1)
				$runServerAddress = StringRegExpReplace($runServerAddress, "[^0-9]*$", "") ;trim any chars at end
				MsgBox("", "", "$CmdLine:"&$runServerAddress)
				LaunchGame($runServerAddress, $cmdString[$i][2])
				Exit
			EndIf
		Next
		Exit
	EndFunc
	;========================================================
	#EndRegion

	Func _IsChecked($idControlID)
		Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
	EndFunc


	#Region --> M-BROWSER disaply player count
	;============================
	;-->update the info bar Kingpin
	Func M_UpdatePlayersStatus($iGameIdx, $getPlayerIinfo)
		If $getPlayerIinfo <> "" Then
			Local $String = StringSplit($getPlayerIinfo, '/')
			if @error Then Return False
			Local $count = Number($String[1])
			If $count > 0 Then
				$g_aPlayerCount_M[$iGameIdx] += $count
				Return True
			EndIf
		EndIf
		Return False
	EndFunc

	Func M_SetPlayersOnlineString()
		GUICtrlSetData($UI_Text_countMPlayers, StringFormat( _
			"Online Players.   Kingpin: %i     KingpinQ3: %i     Quake2: %i                    ", _
			$g_aPlayerCount_M[0], _
			$g_aPlayerCount_M[1], _
			$g_aPlayerCount_M[2]));& "  and " & $countServers & " Servers")
	EndFunc
	;-->  END disaply player count
	;=============================================================================
	#EndRegion


	#Region --> M-BROWSER M_GetServerList File
	;=============================================================================
	;--> M_GetServerList File
	Func M_GetServerList()
		Local $i, $hDownload, $iTimeout
		EnableUIButtons(False)

		;loop through 2 files
		For $i = 0 To 1
			$iTimeout = TimerInit()
			FileDelete($g_sM_tmpFile[$i])
			$hDownload = InetGet($g_sMWebString[$i], $g_sM_tmpFile[$i], $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND ) ;$INET_DOWNLOADBACKGROUND $INET_DOWNLOADWAIT
			ConsoleWrite("getting web file idx:"&$i&@CRLF)

			Do ;wait for file to complete
				If TimerDiff($iTimeout) > 3000 Then
					ConsoleWrite("tieout"&@CRLF)
					ExitLoop
				EndIf
				Sleep(150)
			Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE)
			InetClose($hDownload)
		Next
		EnableUIButtons(True)

		ResetRefreshTimmers();set a new time for auto refresh
	EndFunc
	;--> M_GetServerList File
	;=============================================================================

	Func M_CheckFileReadToArray($sFilePath, $gameName, ByRef $aArray)
		If FileExists($sFilePath) Then
			$aArray = FileReadToArray($sFilePath)
			If @error Then ;error ask to use offline list
				if Not $g_bAutoRefreshActive Then
					MsgBox($MB_SYSTEMMODAL, _
						"ERROR: In Server List", _
						"The Server list format is incorrect", 0, $HypoGameBrowser)
				EndIf
				ResetRefreshTimmers()
				Return 0 ;error loading to array
			Else
				return 1
			EndIf
		Else
			If Not $g_bAutoRefreshActive Then
				MsgBox($MB_SYSTEMMODAL, _
					"ERROR: Cant Get 'M' Server List", _
					"There was an error downloading the " &$gameName& " Server list." &@CRLF& _
					"Check Your Connection?", 0, $HypoGameBrowser)
			EndIf
			ResetRefreshTimmers()
			Return 0 ;error geting file
		EndIf
	EndFunc

	Func M_UpdateListView($sLineData, $ListID, $iGameIdx, ByRef $iIdx)
		Local $hw, $hostName, $sString, $aData
		;fix each line string, remove server name and replace consecitive spaces with "|"
		$hostName = _StringBetween($sLineData, '"', '"' ) ;get server name[0]
		if not @error Then
			$sString = StringReplace($sLineData, '"' & $hostName[0] & '"', "") ; clear hostname
			$sString = StringRegExpReplace($sString, "\h+", "|") ;replace spaces with '|'
			$aData = StringSplit($sString, '|')
			$hw = GUICtrlCreateListViewItem($iIdx, $ListID)
			; _GUICtrlListView_AddItem($UI_List, $aData[1],-1, $iKP1)
			_GUICtrlListView_AddSubItem($ListID, $iIdx, $aData[1]    ,1)	;IP
			_GUICtrlListView_AddSubItem($ListID, $iIdx, $hostName[0] ,2)	;server
			_GUICtrlListView_AddSubItem($ListID, $iIdx, $aData[3]    ,5)	;map
			_GUICtrlListView_AddSubItem($ListID, $iIdx, $aData[6]    ,4)	;players
			_GUICtrlListView_AddSubItem($ListID, $iIdx, $aData[8]    ,3)	;ping
			If M_UpdatePlayersStatus($iGameIdx, $aData[6]) Then
				GUICtrlSetColor($hw, $COLOR_BLACK) ;found player, highlight it
				GUICtrlSetBkColor($hw, $COLOR_YELLOW) ;found player, highlight it
			EndIf
			$iIdx += 1 ;increase list by 1
		EndIf ;end error
	EndFunc

	;=============================================================================
	;--> set ServerList per tab
	Func M_SetServerTabArray()
		Local $aArray, $i
		Local $iKP1 = 0, $iQ2 = 0, $iKPQ3 = 0

		$g_iPlayerCount_GS = 0
		For $i = 0 to 2
			_GUICtrlListView_BeginUpdate($UI_ListV_mb_ABC[$i])
			_GUICtrlListView_DeleteAllItems($UI_ListV_mb_ABC[$i])
			$g_aPlayerCount_M[$i] = 0
			;$g_aCountServers[$i] = 0
		Next

		;============> start kp
		If M_CheckFileReadToArray($g_sM_tmpFile[0], "Kingpin", $aArray) Then
			;_ArrayDisplay($aArray, "m server list", Default, Default, 8)
			For $i = 0 To UBound($aArray) - 1 ; Loop through the array.
				If StringInStr($aArray[$i], "MOTD:") Then
					GUICtrlSetData($MOTD_Input , String(" " & $aArray[$i]))
				ElseIf StringInStr($aArray[$i],"ERROR <host not found>") Then ;todo check this
					ConsoleWrite("!!!ERROR <host not found>"&@CRLF)
				ElseIf StringInStr($aArray[$i],"Quakematch") Then
					M_UpdateListView($aArray[$i], $UI_ListV_mb_ABC[2], 2, $iQ2)
				Else ;kingpin
					M_UpdateListView($aArray[$i], $UI_ListV_mb_ABC[0], 0, $iKP1)
				EndIf
			Next
		Else
			ConsoleWrite("!web kp file is not array"&@CRLF)
		EndIf

		;============> start kpq3
		If M_CheckFileReadToArray($g_sM_tmpFile[1], "KingpinQ3", $aArray) Then
			For $i = 0 To UBound($aArray) - 1 ; Loop through the array.
				If  StringInStr($aArray[$i], "MOTD:") Then
					GUICtrlSetData($MOTD_Input , String(" " & $aArray[$i]))
				ElseIf StringInStr($aArray[$i],"ERROR <host not found>") Then ;todo check this
					ConsoleWrite("!!!ERROR <host not found>"&@CRLF)
				Else
					M_UpdateListView($aArray[$i], $UI_ListV_mb_ABC[1], 1, $iKPQ3)
				EndIf
			Next
		Else ;end tab num
			ConsoleWrite("!web kpq3 file is not array"&@CRLF)
		EndIf

		M_SetPlayersOnlineString()

		_GUICtrlListView_EndUpdate($UI_ListV_mb_ABC[0])
		_GUICtrlListView_EndUpdate($UI_ListV_mb_ABC[1])
		_GUICtrlListView_EndUpdate($UI_ListV_mb_ABC[2])

		If _IsChecked($UI_CBox_sound) Then ; $g_useSounds = 1 Then
			selectAudoToPlay(0) ; 0=mbrowser 1=gamespy
		EndIf
	EndFunc
	;=-->set ServerList per tab
	;========================================================
	#EndRegion

	;=============================================================================
	;--> Regedit m-links
	GUICtrlSetOnEvent($UI_CBox_useMLink,"M_Regedit_Mlinks")
	Func M_Regedit_Mlinks()
		local $exePath = StringReplace(@AutoItExe, "\", "\\")
		local $arrayRegEdit, $hFile

		If _IsChecked($UI_CBox_useMLink) Then
			If MsgBox(BitOR($MB_SYSTEMMODAL,  $MB_OKCANCEL), "M-Links", "Enable M-Browser Web Link Support", 0, $HypoGameBrowser ) = $IDOK Then
				Local Const $aMBLink[2] = ["M-Browser", "M-Browser2"]

				$arrayRegEdit = "Windows Registry Editor Version 5.00"      &@CRLF&@CRLF
				For $i =0 to 1
				 	$arrayRegEdit &= "" & _
						'[HKEY_CLASSES_ROOT\'&$aMBLink[$i]&']'             &@CRLF& _
						'@="URL:'&$aMBLink[$i]&' Protocol"'                &@CRLF& _
						'"URL Protocol"=""'                                &@CRLF&@CRLF& _
						'[HKEY_CLASSES_ROOT\'&$aMBLink[$i]&'\DefaultIcon]' &@CRLF& _         ;@AutoItExe ;@WorkingDir
						'@="' &$exePath& ',0"'                             &@CRLF&@CRLF& _   ;('@="D:\\Kingpin\\Kingpin_M_Browser.exe,0"')
						'[HKEY_CLASSES_ROOT\'&$aMBLink[$i]&'\shell]'       &@CRLF&@CRLF& _
						'[HKEY_CLASSES_ROOT\'&$aMBLink[$i]&'\shell\open]'  &@CRLF& _
						'@=""'                                                    &@CRLF&@CRLF& _
						'[HKEY_CLASSES_ROOT\'&$aMBLink[$i]&'\shell\open\command]' &@CRLF& _
						'@="\"' &$exePath& '\" \"%1\""'                           &@CRLF&@CRLF     ;('@="\"D:\\Kingpin\\Kingpin_M_Browser.exe\" \"%1\""')
				Next

				$hFile = FileOpen($g_sM_tmpFile_reg, $FO_OVERWRITE + $FO_UTF8)
				if $hFile = -1 Then
					setTempStatusBarMessage("Could not Save Settings")
				Else
					FileWrite($hFile, $arrayRegEdit) ;_FileWriteFromArray($iniFileCFG, $iniFileArray, 0)
					FileClose($hFile)
					ShellExecute($g_sM_tmpFile_reg); Run the file.
				EndIf
			Else
				GUICtrlSetState ( $UI_CBox_useMLink, $GUI_UNCHECKED ) ;disable offline radio box
			EndIf
		Else ;reset reg to disable mlinks
			If MsgBox(BitOR($MB_SYSTEMMODAL,  $MB_OKCANCEL), "M-Links", "Disable M-Browser Web Link Support", 0, $HypoGameBrowser ) = $IDOK Then
				$arrayRegEdit = ""& _
					"Windows Registry Editor Version 5.00" &@CRLF& _
					""                                     &@CRLF& _
					"[-HKEY_CLASSES_ROOT\M-Browser]"       &@CRLF& _
					"[-HKEY_CLASSES_ROOT\M-Browser2]"       &@CRLF

				$hFile = FileOpen($g_sM_tmpFile_reg, $FO_OVERWRITE + $FO_UTF8)
				if $hFile = -1 Then
					setTempStatusBarMessage("Could not Save Settings")
				Else
					FileWrite($hFile, $arrayRegEdit) ;_FileWriteFromArray($iniFileCFG, $iniFileArray, 0)
					FileClose($hFile)
					ShellExecute($g_sM_tmpFile_reg); Run the file.
				EndIf
			Else
				GUICtrlSetState ( $UI_CBox_useMLink, $GUI_CHECKED ) ;enable offline radio box
			EndIf

		EndIf
	EndFunc
	;--> Regedit m-links
	;=============================================================================

#EndRegion --> M-BROWSER

#Region --> SERVER ARRAYS: RESET
ResetServerListArrays(BitShift(1,-$COUNT_GAME)-1) ; startup. reset all arrays
Func ResetServerListArrays($listID)
	Local $bit
	; Set all arrays with nul values
	For $i = 0 to $COUNT_GAME -1
		$bit = BitShift(1, -$i)
		If BitAND($listID, $bit) = $bit Then
			;ConsoleWrite("+clear id:"&$i &@CRLF)
			For $j = 0 To $g_iMaxSer-1
				$g_aServerStrings[$i][$j][$COL_NAME]     = ""  ;server string
				$g_aServerStrings[$i][$j][$COL_IP]       = ""  ;ip
				$g_aServerStrings[$i][$j][$COL_PORT]     = 0   ;port
				$g_aServerStrings[$i][$j][$COL_PING]     = 0   ;ping
				$g_aServerStrings[$i][$j][$COL_PORTGS]   = 0   ;GamePort
				$g_aServerStrings[$i][$j][$COL_TIME]     = 0   ;timediff
				$g_aServerStrings[$i][$j][$COL_PLAYERS]  = 0   ;player count
				$g_aServerStrings[$i][$j][$COL_INFOSTR]  = ""  ;infostring (array)
				$g_aServerStrings[$i][$j][$COL_INFOPLYR] = ""  ;infostring players
				$g_aServerStrings[$i][$j][$COL_MAP]       = ""  ;MAP
				$g_aServerStrings[$i][$j][$COL_MOD]       = ""  ;MOD
				$g_aServerStrings[$i][$j][$COL_IDX]      = $j  ;listview indx (sort used)
			Next
		EndIf
	Next
EndFunc

#EndRegion --> END RESET ARRAY

#Region --> SETTINGS: Get Master info

Func GetMasterAddressFromSettings($iGameIdx)
	Local $iMasterIdx = getSelectedMasterIndex($iGameIdx)
	If $iMasterIdx = 0 Then ; custom master address
		Return $g_aGameSetup[$iGameIdx][$GCFG_MAST_CUST]
	Else
		Local $aDropdownText = StringSplit($g_gameConfig[$iGameIdx][$MASTER_ADDY], "|")
		Return $aDropdownText[$iMasterIdx]
	EndIf
EndFunc

Func GetMasterUsed($iGameIdx, $iMasterIdx, $retryCount)
	Local $aDropdownText = StringSplit($g_gameConfig[$iGameIdx][$MASTER_ADDY], "|")
	Local $iCount = $aDropdownText[0]
	If $retryCount > $iCount Then Return -1 ;exhausted list
	Local $idx = Mod($iMasterIdx+$retryCount, $iCount) + 1 ;1-based
	Return $aDropdownText[$idx]
EndFunc


; what master to use from settings
Func GetSelectedMasterAddress($iGameIdx, $retryCount, $bCombine)
	Local  $sMaster = "", $aRet[2]
	Local $iMasterIdx = getSelectedMasterIndex($iGameIdx)
	ConsoleWrite("+master id:"&$iMasterIdx&" retry:"&$retryCount&@CRLF)

	If $bCombine Then
		If $retryCount = 0 Then ;use custom master address
			$sMaster = $g_aGameSetup[$iGameIdx][$GCFG_MAST_CUST]
		Else
			;internal masters
			$sMaster = GetMasterUsed($iGameIdx, 0, $retryCount)
		EndIf
	Else
		If $iMasterIdx < 1 Then
			;use custom master address
			if $retryCount > 0 Then Return -1 ; only get user master
			$sMaster = $g_aGameSetup[$iGameIdx][$GCFG_MAST_CUST]
		Else
			;internal masters
			$sMaster = GetMasterUsed($iGameIdx, ($iMasterIdx - 1), $retryCount)
		EndIf
	EndIf

	If $sMaster = "" Or $sMaster = -1 Then
		ConsoleWrite("!master null"&@CRLF)
		Return $sMaster ; fail
	EndIf
	ConsoleWrite(">sMaster:"&$sMaster&@CRLF)

	If Not StringInStr($sMaster,":") Then
		$sMaster = String($sMaster & ":28900") ; append port
	EndIf

	$aRet[0] = GetMasterProtocol($sMaster)

	Switch $aRet[0]
		Case $NET_PROTOCOL_WEB
			$aRet[1] = "http://" & $sMaster ;port 80 without protocol
		Case $NET_PROTOCOL_HTTP, $NET_PROTOCOL_HTTPS
			$aRet[1] = $sMaster ;full string
		Case Else
			; "ip:port:extraData"
			$aRet[1] = StringFormat("%s:%s", $sMaster,  getMasterExtraInfo($iGameIdx)) ;$g_aGameSetup[$GCFG_MAST_PROTO]
			$aRet[1] = StringSplit($aRet[1],":", $STR_NOCOUNT)
			If @error Then Return -1
	EndSwitch

	Return $aRet
EndFunc

Func getSelectedMasterIndex($iGameIdx)
	Local $idx = $g_aGameSetup[$iGameIdx][$GCFG_MAST_DEF]
	if $idx < 0 Then
		Return 0
	Else
		Return $idx
	EndIf
EndFunc

#EndRegion


#Region --> PROTOCOL: Relted settings

Func sendEchoMessage_UDP($iGameIdx, $iServerId)
	if StringCompare($g_gameConfig[$iGameIdx][$GNAME_SAVE], 'JK3') = 0 Then ;todo
		Return "ÿÿÿÿ" & $g_aServerStrings[$iGameIdx][$iServerId][$COL_INFOSTR]
	EndIf
	;todo add games
	Return ""
EndFunc

Func sendStatusMessageType_UDP($iGameIdx, $isMBrowser) ;udp
	if $isMBrowser Then
		;user right click-> get-info
		Switch $iGameIdx
			Case 2
				Return GetData_C2S($C2S_Q2)
			Case 1
				Return GetData_C2S($C2S_Q3)
			Case Else
				Return GetData_C2S($C2S_Q2)	;kp gameport (q2 protocol)
		EndSwitch
	Else
		Return GetData_C2S($g_gameConfig[$iGameIdx][$NET_C2S])  ;$g_aServerSendStatus_UDP[$g_iTabNum]
	EndIf
	Return ""
EndFunc

#EndRegion

#Region --> LISTVIEW: GET UI SELECTIONS


;=============
;-->Set tabNum
Func SetSelectedGameID()
	$g_iTabNum = GUICtrlRead($tabGroupGames)
	$g_iCurGameID = ComboBoxEx_GetCurSel()
EndFunc


Func GetServerListA_SelectedData($column);get listview #0 string (array number)
	Local $tmp, $sRet = ""
	Local $ListViewA = getListView_A_CID()
	If _GUICtrlListView_GetSelectedCount($ListViewA) Then
		$tmp = _GUICtrlListView_GetSelectionMark($ListViewA)
		$sRet = _GUICtrlListView_GetItemText($ListViewA, $tmp, $column)
	EndIf

	If $column = $LV_A_IDX Then
		Return Number($sRet) ;index
	Else
		Return String($sRet) ;string
	EndIf
EndFunc

Func GetServerCountInArray($iGameIdx) ;total displayed servers (in memory)
	Local $countServ = 0
	if $iGameIdx >= $COUNT_GAME Then return 0

	For $i = 0 To $g_iMaxSer -1
		;[1]=ip exists
		If $g_aServerStrings[$iGameIdx][$i][$COL_IP] <> "" Then
			$countServ += 1
		Else
			ExitLoop
		EndIf
	Next
	Return $countServ
EndFunc


;store listview index to internal data
Func ListviewStoreIndexToArray($iGameIDx, $reset = False)
	Local $idx

	if $iGameIDx >= $COUNT_GAME then Return
	if $iGameIDx < 0 then Return

	if $reset Then
		$g_ilastColumn_A = -1
		For $i = 0 To $g_iMaxSer-1
			$g_aServerStrings[$iGameIDx][$i][$COL_IDX] = $i
		Next
	Else
		If $g_ilastColumn_A = -1 Then return
		For $i = 0 To _GUICtrlListView_GetItemCount($UI_ListV_svData_A)-1
			$idx = Number(_GUICtrlListView_GetItemText($UI_ListV_svData_A, $i, 0))
			$g_aServerStrings[$iGameIDx][$idx][$COL_IDX] = $i
		Next
	EndIf
EndFunc

Func ChangedListview_NowFillServerStrings() ;if list selection changed. fill server rules
	SetSelectedGameID()
	Local $ListViewA = getListView_A_CID()
	Local $listSelNum = _GUICtrlListView_GetSelectionMark($ListViewA)

	If $g_iTabNum = $TAB_GB Then
		Switch $g_iCurGameID
			Case 0 to $COUNT_GAME-1
				FillListView_BC_Selected($g_iCurGameID, $listSelNum)
			case Else
				FillListView_BC_Selected(0, $listSelNum) ;<tabnum> | <selected array num>
		EndSwitch
	EndIf
EndFunc

#EndRegion END LISTVIEW: GET UI SELECTIONS

#Region --> TCP GAMESPY CHALLANGE
Func gsvalfunc($reg_)
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
		For $i=1 to $aTmp[0]
			if StringCompare($aTmp[$i], $sTest) = 0 Then
				;make sure string exists
				If $i+1 <= $aTmp[0] Then
					Return $aTmp[$i+1]
				Else
					Return ("") ;error
				EndIf
			EndIf
		Next
	EndIf
	Return ("") ;error
EndFunc

Func GameSpyChallenge($sInput, $sGameKey)
	Local $i, $sOut, $keysz
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
			$size_= 6
			$keysz = 6
			;==>2
			for $i= 0 to 255	; 256
				$enctmp[$i] = $i;
			Next
			;==>3
			$a_= 0
			for $i= 0 to 255	; 256
				$a_ += $enctmp[$i] + Asc($aGameKey[mod($i, $keysz)])
				$a_= Mod($a_, 256)
				$x_ = $enctmp[$a_];
				$enctmp[$a_] = $enctmp[$i];
				$enctmp[$i] = $x_;
			Next
			;==>4
			$a_= 0
		    $b_= 0;
			for $i = 0 to UBound($aSrc)-1; Asc($aSrc[$i])
				$a_ += Asc($aSrc[$i]) + 1;
				$a_= Mod($a_, 256)
				$x_ = $enctmp[$a_];
				$b_ += $x_;
				$b_=Mod($b_,256)
				$y_ = $enctmp[$b_];
				$enctmp[$b_] = $x_;
				$enctmp[$a_] = $y_;
				$tmp_[$i] = Mod(BitXOR(Asc($aSrc[$i]), $enctmp[ BitAND(($x_ + $y_),0xff) ]),256);mod just incase
			next

			;==>5
			ConsoleWrite(">GS Challenge i="&$i&@CRLF)
			for $size_ = $i to Mod($size_, 3) ; size++)
				$tmp_[$size_] = 0;
			next

			for $i = 0 to  $size_-1 step 3
				$x_ = $tmp_[$i];
				$y_ = $tmp_[$i + 1];
				$z_ = $tmp_[$i + 2];
				$p_[0+$iCnt] = Chr(gsvalfunc(		BitShift($x_, 2)));
				$p_[1+$iCnt] = Chr(gsvalfunc(BitOR (BitShift( BitAND($x_,3), -4), BitShift($y_, 4))));
				$p_[2+$iCnt] = Chr(gsvalfunc(BitOR (BitShift( BitAND($y_,15), -2), BitShift($z_, 6))));
				$p_[3+$iCnt] = Chr(gsvalfunc(BitAND($z_,63)));
				$iCnt += 4
			next

			$sOut=""
			for $i = 0 to UBound($p_)-1
				If $p_[$i] <> "" Then
					$sOut= string($sOut & $p_[$i])
				Else
					ExitLoop
				EndIf
			Next
		Else
			$sOut ="ERROR___"
		EndIf
	EndIf
	ConsoleWrite("!out challenge1=" &$sOut&@CRLF)

	Return $sOut

EndFunc

#EndRegion


#Region --> TCP GET LIST FROM MASTER
Func GetListFromMasterTCP($iGameIdx, $sIPAddressDNS, $iPort)
	Local $tcpSocket, $data ="", $dataRecv, $sIPAddress, $iTryCount = 1
	Local $sGameKey=  "mgNUaC" ;gspylite="mgNUaC" ;kingpin="QFWxY2" "Quake2"="rtW0xg"
	Local $gameSpyString="" ; = "\gamename\gspylite\gamever\01\location\0\validate\LO/WUC4c\final\\queryid\1.1"

	$sIPAddress = TCPNameToIP($sIPAddressDNS)

	;try connect a few times then give up
	For $i3 = 0 to $iTryCount
		ConsoleWrite("ip:"&$sIPAddress&" port"&$iPort&@CRLF)
		$tcpSocket = TCPConnect($sIPAddress, $iPort)
		If $tcpSocket <= 0 or @error Then
			ConsoleWrite("!ERROR: TCPConnect soc:" & $tcpSocket & " @err=" &@error& " idx:"&$i3&@CRLF)
			If @error = 1 or @error = 2 or $i3 >= $iTryCount Then ; @error 1=ip 2=port
				ConsoleWrite("I Give up" &@CRLF)
				TCPCloseSocket($tcpSocket)
				Return -1
			EndIf
			TCPCloseSocket($tcpSocket)
			Sleep(1000)
			ContinueLoop
		EndIf
		ExitLoop ;connected ok
	Next
	;TCP connected
	if Not TcpRecvDataFromMaster($tcpSocket, $dataRecv, 1500) Then
		ConsoleWrite("error TCP 2" &@CRLF)
		Return -1 ;recieve= 	\basic\\secure\TXKOAT
	EndIf


	;ConsoleWrite("tcp data recieved= "& $dataRecv& @CRLF);$dataRecv = "\basic\\secure\TXKOAT"

	;recieved challenge
	If StringInStr($dataRecv, "\secure\") Then ;"TXKOAT
		;send= \gamename\gspylite\gamever\01\location\0\validate\LO/WUC4c\final\\queryid\1.1
		;~ $gameSpyString = StringFormat("\\gamename\\gspylite\\location\\0\\validate\\%s\\final\\", GameSpyChallenge($dataRecv, $sGameKey))
		;~ if not TcpSendDataToMaster($tcpSocket, $gameSpyString) Then Return -1

		;~ ;send= \list\\gamename\kingpin
		;~ $gameSpyString = StringFormat("\\list\\\\gamename\\%s\\final\\", $g_gameConfig[$iGameIdx][$GNAME_GS])
		;~ if not TcpSendDataToMaster($tcpSocket, $gameSpyString) Then Return -1

		$gameSpyString = StringFormat("\\gamename\\gspylite\\location\\0\\validate\\%s\\final\\\\list\\\\gamename\\%s\\final\\", _
			GameSpyChallenge($dataRecv, $sGameKey), $g_gameConfig[$iGameIdx][$GNAME_GS])
		if not TcpSendDataToMaster($tcpSocket, $gameSpyString) Then
			ConsoleWrite("error TCP send:" & $gameSpyString& @CRLF)
			Return -1
		EndIf

		;ConsoleWrite("-gs querry:"&$gameSpyString&@CRLF)

		;$dataRecv = ""
		For $i4 = 0 To 5 ;recieve upto 5 more lists, if long
			if Not TcpRecvDataFromMaster($tcpSocket, $dataRecv, 2500) Then
				ConsoleWrite("error TCP 3"&@CRLF)
				Return -1 ;recieve= \ip\10.10.10:31510\ip\10.10.10:31520\final\
			EndIf
			;ConsoleWrite("TCP recieve string idx:"& $i4+1 &" Data:"& $dataRecv &@CRLF)
			$data &= $dataRecv
			If StringInStr($data, "\final\", 0, -1) Then
				ConsoleWrite("+tcp found EOT"&@CRLF)
				ExitLoop
			EndIf
		Next
	EndIf
	;ConsoleWrite ("data recieved.."& $dataRecv& @CRLF)
	TCPCloseSocket($tcpSocket)

	If $data <> "" Then
		Local $countIP = StringSplit($data, "ip\", 1)
		if Not @error and $countIP[0] > 0 Then
			;ConsoleWrite("num servers:" &$countIP[0]-1&@CRLF)
			;ConsoleWrite("data recievedTCP1=" & $data&@CRLF)
			Return $data
		EndIf
	EndIf
	Return -1
EndFunc

Func TcpSendDataToMaster(ByRef $iSock, $sMsg)
	;ConsoleWrite("TCP Send:"& $sMsg &@CRLF)
	TCPSend($iSock, $sMsg)
	If @error Then
		ConsoleWrite("!ERROR: TCPsend errID: " &@error&@CRLF)
		TCPCloseSocket($iSock)
		Return False
	EndIf
	Return True
EndFunc

Func TcpRecvDataFromMaster(ByRef $iSock, ByRef $sMsg, $iMaxLen)
	$sMsg = TCPRecv($iSock, $iMaxLen, 0)
	;ConsoleWrite("TCP Recv:"& $sMsg &@CRLF)
	If @error Or $sMsg = "" Then
		ConsoleWrite("!ERROR: TCPRecv errID:"&@error&@CRLF)
		TCPCloseSocket($iSock)
		Return False
	EndIf
	Return True
EndFunc

#EndRegion --> TCP GET LIST FROM MASTER


#Region --> UDP GET

Func GetMessage_toSendMasterUDP($iGameIdx, $iProtocol)
	;q3 master protocol

	;If $g_gameConfig[$iGameIdx][$NET_C2M_Q3PRO] <> "" Then ;q3 uses protocol
	If $g_gameConfig[$iGameIdx][$NET_C2M] = $C2M_Q3 Then ;[$NET_C2S] = $C2S_Q3
		Local $sFull = (_IsChecked($UI_Btn_filterFull))? (''):('full ')
		Local $sEmpty = (_IsChecked($UI_Btn_filterEmpty))? (''):('empty ')
		local $sDPName = $g_gameConfig[$iGameIdx][$GNAME_DP]

		If $sDPName <> "" Then
			;dp master. ÿÿÿÿgetservers KingpinQ3-1 %s full empty
			Return StringFormat("%s %s %s %s%s", _
				GetData_C2M($g_gameConfig[$iGameIdx][$NET_C2M]), _
				$sDPName , _ ; add gamename (dp)
				$iProtocol, _
				$sFull, $sEmpty) _
				& Chr(0)
		Else
			;Q3 master. ÿÿÿÿgetservers 66 empty full demo.
			return StringFormat("%s %s %s%s", _
				GetData_C2M($g_gameConfig[$iGameIdx][$NET_C2M]), _
				$iProtocol, _
				$sFull, $sEmpty) _
				& Chr(0) ;quake3
		EndIf
	ElseIf $g_gameConfig[$iGameIdx][$NET_C2M] = $C2M_Q3ET Then
			;Q3ET master. ÿÿÿÿgetservers 84
			return StringFormat("%s %s", _
				GetData_C2M($g_gameConfig[$iGameIdx][$NET_C2M]), _
				$iProtocol) ;wolfET
	Else
		;non Q3 query
		return StringFormat("%s", _
			GetData_C2M($g_gameConfig[$iGameIdx][$NET_C2M])) _
			& Chr(0)
	EndIf
EndFunc

Func CleanupMasterResponceUDP_EOT($iGameIdx, $sEOT, ByRef $inData, ByRef $inLen, ByRef $retData)
	Local $sTail = StringRight($inData, StringLen($sEOT))
	$retData = ""

	If StringCompare($sTail, $sEOT, $STR_CASESENSE) = 0 Then
		$retData = StringTrimRight($inData, StringLen($sEOT))
		return True
	ElseIf $g_gameConfig[$iGameIdx][$NET_M2C_EOT] = $EOT_Q3 Or $g_gameConfig[$iGameIdx][$NET_M2C_EOT] = $EOT_DP Then
		Local $iCount = 0, $iLen = StringLen($inData)

		While (StringMid($inData, $iLen - $iCount , 1) = Chr(0)) And ($iCount < 6) ;dont trim longer than ip
			;ConsoleWrite("+len1"&StringMid($inData, $iLen - $iCount , 1)&@CRLF)
			ConsoleWrite("+len1="& Hex(StringToBinary(StringMid($inData, $iLen - $iCount , 1)))&@CRLF)
			$iCount +=1
		WEnd

		If $iCount Then ; StringCompare(StringRight($inData,3), Chr(0)&Chr(0)&Chr(0), $STR_CASESENSE) = 0 Then
			Local $tmpData = StringTrimRight($inData, $iCount)
			ConsoleWrite("!Checking DP master used for Q3. null count:"& $iCount &@CRLF)
			$sEOT = GetData_M2C_EOT($EOT_Q3)
			$sTail = StringRight($tmpData, StringLen($sEOT))
			If StringCompare($sTail, $sEOT, $STR_CASESENSE) = 0 Then
				ConsoleWrite("!!"&@CRLF)
				$retData = StringTrimRight($tmpData, StringLen($sEOT)) ; trim EOT
				return True
			EndIf
		EndIf
	EndIf

	Return False
EndFunc

Func CleanupMasterResponceUDP_Header($iGameIdx, ByRef $data, $trimLen)
	Local $idx, $iLen, $sHeader

	;ConsoleWrite("PacketData003=" &String($data)&@CRLF)
	if $data <> "" Then
		$sHeader = GetData_M2C($g_gameConfig[$iGameIdx][$NET_M2C])
		$iLen = StringLen($sHeader)
		$idx = StringInStr($data, $sHeader, 1, 1, 1, $iLen)
		If $idx Then
			$data = StringTrimLeft($data, $idx+$iLen - $trimLen) ; trim ÿÿÿÿservers\n... +1char(catch \0 \\)

			;extra message cleanup... paintball2 and jedi(jkhub.org)
			Switch $g_gameConfig[$iGameIdx][$NET_M2C]
				Case $M2C_STEF1, $M2C_JEDI, $M2C_Q3, $M2C_Q3ET ;todo use count?
					If Not (StringLeft($data, 1) = "\") Then
						;trim prefix upto '\'
						$idx = StringInStr($data, "\", $STR_CASESENSE, 1, 1, 3)
						If $idx Then $data = StringTrimLeft($data, $idx -1)
					EndIf
				Case  $M2C_PB2
					local const $sPBExtra = 'serverlist2' ;todo move name out of here?
					$idx = StringInStr($data, $sPBExtra, 0, 1, 1, 20) ;should be at start...
					If $idx Then
						$data = StringTrimLeft($data, $idx+StringLen($sPBExtra)+4) ; trim name + int(length)
						;ConsoleWrite("pb cleanup:"&$data&@CRLF)
					EndIf
				;Case
					;todo ADD GAMES
			EndSwitch
		EndIf
	EndIf
EndFunc

Func STFE_readMasterIPList($data)
	;Star Trek: Elite Force has ip sent as a hex string...
	local $ret = ""

	local $iMax = StringLen($data)
	For $i = 1 To $iMax -12 Step 13
		$ret &= "\" & BinaryToString("0x"&StringMid($data, $i+1, 12), 1)
	Next
	return $ret
EndFunc

Func BuildIPV4_fromAscArray(ByRef $aChars, $i)
	Return StringFormat("\ip\%u.%u.%u.%u:%u", _ ;uncompress byte to unsigned int
		($aChars[$i+0]), ($aChars[$i+1]), ($aChars[$i+2]), ($aChars[$i+3]), _ ;ip address
		BitShift(($aChars[$i+4]), -8) + ($aChars[$i+5])) ;port (Big-Endian)
EndFunc

Func BuildIPV6_fromAscArray(ByRef $aChars, $i)
	Local $ip = "", $port

	For $j = 0 To 15 Step 2
		$ip &= BinaryToString($aChars[$i+$j] & $aChars[$i+$j+1]) & ':' ;
	Next
	;$ip = BinaryToString($ip)
	$port = $aChars[$i+16] * 256 + $aChars[$i+17] ;Big-Endian

	Return StringFormat("\ip\%s%u", $ip, $port)
EndFunc


Func BuildIPList_fromMasterUDP($iGameIdx, ByRef $data, ByRef $retErr, $isQ3IPList)
	Local $sRet = "", $iStep = 6, $iCount, $aChars

	if $data <> "" Then
		If $g_gameConfig[$iGameIdx][$NET_M2C] = $M2C_STEF1 Then; If $iGameIdx = $ID_STEF1 Then
			$data = STFE_readMasterIPList($data)
		EndIf
		;todo ADD GAMES

		$aChars = StringToASCIIArray($data, 0, Default, $SE_ANSI)
		if $aChars = "" or Not IsArray($aChars) Then ;Or $aChars[0] = Null
			$retErr = -2 ;error: report no servers
		Else
			$iCount = UBound($aChars)
			ConsoleWrite(">count:" &$iCount&@CRLF)
			If $isQ3IPList Then
				Local $j = 0
				While $j < ($iCount -1)
					If $aChars[$j] = Asc('\') Then ;ipv4
						if ($j+7) < $iCount Then
							$sRet &= buildIPV4_fromAscArray($aChars, $j+1)
						EndIf
						$j +=7 ;4+2+1
					ElseIf $aChars[$j] = Asc('/') Then ;ipv6
						if ($j+19) < $iCount Then
							$sRet &= buildIPV6_fromAscArray($aChars, $j+1)
						EndIf
						$j +=19 ;16+2+1
					Else
						ExitLoop
					EndIf
				WEnd
			Else
				For $i = 0 to $iCount -1 Step $iStep
					if $i+6 <= $iCount Then
						$sRet &= buildIPV4_fromAscArray($aChars, $i)
					EndIf
				Next
			EndIf
			;ConsoleWrite("-out1:"&$output&@CRLF)
		EndIf
		$data = "" ;cleanup
	else
		$retErr = -2 ;error: report no servers
	EndIf
	Return $sRet
EndFunc

Func GetList_fromMasterUDP($iGameIdx, $sSendIPAddressDNS, $iSendPort, $sProtocol = "")
	;If @error Then ConsoleWrite("error startup")
	Local $dataRecv, $data = "", $retErr = -1
	Local $iErrorX, $output = "", $gameSpyString
	Local $aProto = StringSplit($sProtocol, "|")
	local $sEOT = GetData_M2C_EOT($g_gameConfig[$iGameIdx][$NET_M2C_EOT]) ;EOT
	local $tmpData, $hSocket = -1
	Local $isQ3IPList = 0, $isQ3IPList
	Local $sIP = TCPNameToIP($sSendIPAddressDNS)

	;q3 seperates ip with '\' or '/' for ipv6
	Switch $g_gameConfig[$iGameIdx][$NET_M2C]
		Case $M2C_Q3, $M2C_JEDI, $M2C_STEF1, $M2C_Q3ET
			$isQ3IPList = 1 ;todo use length from settings?
	EndSwitch

	_BIND_UDP_SOCKET($hSocket)
	If $hSocket < 1 Then Return -1
	_UDP_setBuffSize($g_hSocketServerUDP, 256, 10000)

	;handle munlitple protocols eg(2002|20004)
	For $iPIdx = 1 To $aProto[0]
		;ConsoleWrite("+protocol id:"&$iPIdx&@CRLF)
		$gameSpyString = GetMessage_toSendMasterUDP($iGameIdx, $aProto[$iPIdx]);"ÿÿÿÿgetservers FTE-Quake 3 full empty"
		;ConsoleWrite("-send packet="&$gameSpyString&@CRLF)
		;ConsoleWrite("-send packet=0x"& Hex(StringToBinary($gameSpyString))&@CRLF)

		If Not @error Then
			ConsoleWrite("ip:"&$sIP&" port:"&$iSendPort&@CRLF)
			$iErrorX = _UDPSendTo($sIP, $iSendPort, $gameSpyString, $hSocket)
			if @error Then ConsoleWrite("!UDP Send 'status' sock error=" & $iErrorX & " error" & @CRLF)
		EndIf

		if Not @error Then
			Local $iTimeOut = TimerInit(), $sTail, $dataLen
			While 1
				Do
					$dataRecv = _UDPRecvFrom($hSocket, 10000, 0) ;2048
					If TimerDiff($iTimeOut) > 2000 Then
						ConsoleWrite("button state up, timeout 2seconds"&@CRLF)
						ExitLoop(2) ;timedout. stop do+while
					EndIf
					Sleep(100)
				Until IsArray($dataRecv)

				$dataLen = $dataRecv[$PACKET_SIZE]
				;ConsoleWrite("-new packet=0x"& Hex(StringToBinary($dataRecv[$PACKET_DATA]))&@CRLF)

				;check for EOT
				$sTail = StringMid($dataRecv[$PACKET_DATA], $dataLen - StringLen($sEOT)+1, -1)
				;ConsoleWrite("+$sTail s:"&Hex(StringToBinary($sTail))&@CRLF) ;todo cleanup debug
				If CleanupMasterResponceUDP_EOT($iGameIdx, $sEOT, $dataRecv[$PACKET_DATA], $dataLen, $tmpData) Then
					CleanupMasterResponceUDP_Header($iGameIdx, $tmpData, $isQ3IPList);remove header data
					$data &= $tmpData
					;ConsoleWrite("-packet=0x"& Hex(StringToBinary($data))&@CRLF)
					ConsoleWrite(@CRLF&"+found 'EOT'"&@CRLF) ;todo cleanup debug
					If $dataLen > 700 And $g_gameConfig[$iGameIdx][$NET_M2C] = $M2C_Q3ET Then
						ContinueLoop ; ET send EOT on every packet. wait for timeout
					EndIf
					ExitLoop(1) ;recieved full packet
				Else
					;short message without EOT
					If $sEOT = "" and $data = "" and $dataLen < 512 Then
						$tmpData = $dataRecv[$PACKET_DATA]
						CleanupMasterResponceUDP_Header($iGameIdx, $tmpData, $isQ3IPList);remove header data
						$data &= $tmpData
						;ConsoleWrite("-packet=0x"& Hex(StringToBinary($data))&@CRLF)
						ExitLoop(1) ;recieved full packet
					EndIf
				EndIf

				$tmpData = $dataRecv[$PACKET_DATA]
				CleanupMasterResponceUDP_Header($iGameIdx, $tmpData, $isQ3IPList);remove header data
				$data &= $tmpData ;add recieved data
				; get multiple packets?
			WEnd
		EndIf
	Next
	_UDPCloseSocket($hSocket)

	;remove trailing '\' from q3(fix for multile servers)
	;if $isQ3IPList Then $data = StringTrimLeft($data, 1)

	;Servers recieved string
	;ConsoleWrite("-final packet=0x"& Hex(StringToBinary($data))&@CRLF)

	$output = BuildIPList_fromMasterUDP($iGameIdx, $data, $retErr, $isQ3IPList)

	If $output = "" Then
		Return $retErr
	Else
		Local $countIP = StringSplit($output, "\ip\", 1)
		if Not @error Then
			ConsoleWrite("-num UDP servers recieved:" &$countIP[0]-1&@CRLF)
		EndIf
		;ConsoleWrite("-rec master data processed:"& @CRLF&"-0x"&$output&@CRLF)
		Return $output
	EndIf
EndFunc
;--> END: UDP GET LIST FROM MASTER

;--> HTTP GET LIST FROM WEB
Func GetListFromHTTP($sData)
	Local $i, $hDownload, $iTimeout = TimerInit(), $aArray, $sWebLink
	Local $sOutput=""
	;EnableUIButtons(False)

	;~ If $netType = $NET_PROTOCOL_WEB Then
	;~ 	$sWebLink = StringFormat("http://%s", $sData) ;http://%s:%s/?mod=&raw=1&inc=1
	;~ Else
	;~ 	$sWebLink = StringFormat("%s", $sData)
	;~ EndIf
	$sWebLink = $sData

	FileDelete($g_sM_tmpFile[2])
	$hDownload = InetGet($sWebLink,	$g_sM_tmpFile[2], $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND )
	Do
		If TimerDiff($iTimeout) > 3000 Then
			InetClose($hDownload)
			ResetRefreshTimmers() ;reset timers. msg box issue
			Return -1
		EndIf
		Sleep(150)
	Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE)
	InetClose($hDownload)

	;process file

	$aArray = FileReadToArray($g_sM_tmpFile[2])
	If @error Then
		setTempStatusBarMessage("ERROR: Cant Get HTTP List.", True)
		;~ if Not $g_bAutoRefreshActive Then
		;~ 	MsgBox($MB_SYSTEMMODAL, "ERROR: Cant Get List", "There was an error downloading server list from "&$sWebLink& _
		;~ 		@CRLF & "Check Your Connection?",0, $HypoGameBrowser )
		;~ EndIf
		ResetRefreshTimmers() ;reset timers. msg box issue
		;EnableUIButtons(True)
		Return -1
	EndIf

	local $sIP, $aTmp
	For $i = 0 To UBound($aArray)-1
		If $i = ($g_iMaxSer -1) Then
			ExitLoop
		EndIf

		$aTmp = StringSplit($aArray[$i], ":")
		if $aTmp[0] = 2 Then ;ip/port
			$sIP = TCPNameToIP(StringStripWS($aTmp[1], 2)) ;todo cleanup. fix for invalid web list
			if not @error then $aArray[$i] = $sIP&":"&$aTmp[2]
		ElseIf $aTmp[0] >2 Then
			ConsoleWrite("!Invalid address. IPV6?:" &$aArray[$i]&@CRLF)
		Else
			ConsoleWrite("!Invalid IP address:" &$aArray[$i]&@CRLF)
		EndIf


		StringReplace($aArray[$i], ":", ":") ; dont do anything.. just getting count
		If @extended = 1 Then ;only one ':' in string. catch ipv6
			$sOutput = String($sOutput&"\ip\"& $aArray[$i])
		Else
			ConsoleWrite("!found IPV6:" &$aArray[$i]&@CRLF)
		EndIf
	Next

	;ConsoleWrite("HTTP Servers recieved string= " &$sOutput& @CRLF)

	ResetRefreshTimmers() ;reset timers. msg box issue
	;EnableUIButtons(True)
	Return $sOutput
EndFunc
; --> END: HTTP GET LIST FROM WEB

; --> TCP/UDP 'REFRESH' LIST FROM MASTER ..FILL ARRAY
Func GetIPArrayFromMasterResponce($sMasterMessage)
	Local $idx, $sTmp

	if $sMasterMessage = -1 Then ;todo fix msg box. goes to middle of screen
		setTempStatusBarMessage("ERROR: Cant connecting to Master Server.", True)
		;~ if Not $g_bAutoRefreshActive Then
		;~ 	MsgBox($MB_SYSTEMMODAL, "Master Server Error","ERROR Connecting to Master Server." &@CRLF& _
		;~ 							"Try Another 'Master' in Setup" &@CRLF&@CRLF& _
		;~ 							"If they all fail, try the 'Offline' button.",0, $HypoGameBrowser )
		;~ EndIf
		return -1
	ElseIf $sMasterMessage = -2 Then
		setTempStatusBarMessage("0 Servers in list from Master.", True)
		;~ if Not $g_bAutoRefreshActive Then
		;~ 	MsgBox($MB_SYSTEMMODAL, "Master Server List","0 Servers in list from Master." &@CRLF& _
		;~ 							"Try Another 'Master' in Setup." &@CRLF&@CRLF& _
		;~ 							"If they all fail, try the 'Offline' button.",0, $HypoGameBrowser )
		;~ EndIf
		return -1
	EndIf

	;clean up ip's
	if StringInStr($sMasterMessage, "\ip\", 0, 1, 1, 4) Then
		$sMasterMessage = StringTrimLeft($sMasterMessage, 4); remove first "\ip\"
	EndIf
	$idx = StringInStr($sMasterMessage, "\final\", 0, -1)
	if $idx Then
		$sMasterMessage = StringMid($sMasterMessage, 1, $idx-1); remove end "\final\"
	EndIf
	;ConsoleWrite("-server msg cleaned:" &$sMasterMessage&@CRLF)

	;split for return array
	Local $ipArray = StringSplit($sMasterMessage, "\ip\", $STR_ENTIRESPLIT + $STR_NOCOUNT)
	If Not IsArray($ipArray) Or UBound($ipArray) = 0 Then
		;~ If StringInStr($sMasterMessage, ":") Then
		;~ 	$ipArray[0] = $sMasterMessage ;only 1 server, cant split strinng
		;~ Else
		ConsoleWrite("error spliting '\ip\' " & @CRLF)
		setTempStatusBarMessage("0 Servers in list from Master.", True)
		;~ if Not $g_bAutoRefreshActive Then
		;~ 	MsgBox($MB_SYSTEMMODAL, "Master Server List","0 Servers in list from Master." &@CRLF& _
		;~ 							"Try Another 'Master' in Setup." &@CRLF&@CRLF& _
		;~ 							"If they all fail, try the 'Offline' button.",0, $HypoGameBrowser )
		;~ Endif
		Return -1
		;~ EndIf
	EndIf

	;convert DNS to ip
	For $i=0 to UBound($ipArray) - 1
		$sTmp = TCPNameToIP($ipArray[$i])
		If not @error Then
			$ipArray[$i] = $sTmp
		EndIf
	Next

	Return $ipArray
EndFunc

;========================================================
; --> GetServerListFromMaster TCP/UDP
Func GetServerListFromMaster($iGameIdx)
	Local $aMaster_IP, $serverMessage = -1, $ipArray[0], $iCount
	Local $bCombine = BitAND($g_aGameSetup[$iGameIdx][$GCFG_AUTO_REF], 2)? (True):(False)

	;ConsoleWrite('combine:'&$bCombine&@CRLF)
	$g_ilastColumn_A = -1 ;reset listview

	;EnableUIButtons(False)
	BeginGettinServers()
	$g_iPlayerCount_GS = 0
	$g_iServerCountTotal = 0 ;get # servers to use later to stop refresh

	;count masters in list
	If _IsChecked($UI_CBox_tryNextMaster) Or $bCombine Then
		local $aMast = StringSplit($g_gameConfig[$iGameIdx][$MASTER_ADDY], "|")
		If Not @error Then
			$iCount = $aMast[0]
			If Not $bCombine Then $iCount -= 1
			;ConsoleWrite('master count:' &$iCount&@CRLF)
		EndIf
	EndIf

	;queery master for ip list, rotate to next master if failed
	For $iIdx = 0 To $iCount  ;try multiple masters
		$aMaster_IP = GetSelectedMasterAddress($iGameIdx, $iIdx, $bCombine)

		;end of list
		If $aMaster_IP = -1 Then
			ConsoleWrite('!exit1'&@CRLF)
			$serverMessage = -1
			ExitLoop
		EndIf

		;failed ip
		If $aMaster_IP = "" Then
			ConsoleWrite('!continue1'&@CRLF)
			ContinueLoop
		EndIf

		If $bCombine Then
			if $iIdx = 0 Then setTempStatusBarMessage("Getting IP from all master servers in list.", False)
		Else
			if $iIdx = 1 Then setTempStatusBarMessage("SERVER NOT RESPONDING. Trying next Master in list.", True)
		EndIf

		;[protocol,ip,port,extraData]
		Switch $aMaster_IP[0] ; protocol
			Case $NET_PROTOCOL_TCP
				$serverMessage = GetListFromMasterTCP($iGameIdx, ($aMaster_IP[1])[0], ($aMaster_IP[1])[1]) ; [ip,port]
			Case $NET_PROTOCOL_UDP
				$serverMessage = GetList_fromMasterUDP($iGameIdx, ($aMaster_IP[1])[0], ($aMaster_IP[1])[1], ($aMaster_IP[1])[2]) ; [ip,port,proto]
			Case $NET_PROTOCOL_WEB, $NET_PROTOCOL_HTTP, $NET_PROTOCOL_HTTPS
				$serverMessage = GetListFromHTTP($aMaster_IP[1]) ; [webAddress]
		EndSwitch

		;ConsoleWrite('-serverMessage:'&$serverMessage&@CRLF)

		;valid server list
		If Not ($serverMessage = -1) And Not ($serverMessage = -2) Then
			local $aTmp = GetIPArrayFromMasterResponce($serverMessage) ;split masterServer message (0-base)
			if $aTmp = -1 Or Not IsArray($aTmp) Or UBound($aTmp) = 0 Then ;master failed
				if $iCount = 0 And Not $bCombine And $iIdx = 0 Then setTempStatusBarMessage("0 SERVER. Check custom master address.", True)
				ConsoleWrite('!continue2'&@CRLF)
				ContinueLoop ;try next?
			Else
				_ArrayAdd($ipArray, $aTmp); merge array

				;continue to get servers?
				if $bCombine Then ;BitAND($g_aGameSetup[$iGameIdx][$GCFG_AUTO_REF], 2)
					ConsoleWrite('!continue3'&@CRLF)
					ContinueLoop ;append additional servers
				Else
					ConsoleWrite('!exit4'&@CRLF)
					ExitLoop ;master valid, but dont combine
				EndIf
			EndIf
		EndIf

		;failed
		if Not $bCombine And $iIdx = 0 Then
			ConsoleWrite('!continue6'&@CRLF)
			If $serverMessage = -1 Then
				setTempStatusBarMessage("SERVER NOT RESPONDING. Check custom master address.", True)
			ElseIf $serverMessage = -2 Then
				setTempStatusBarMessage("0 SERVER. Try another master.", True)
			EndIf

		EndIf
	Next

	;~ If $iIdx = 1 Then
	;~ 	setTempStatusBarMessage("SERVER NOT RESPONDING. Trying next Master in list.", True)
	;~ EndIf


	;valid ip's?
	If $ipArray = -1 Or not IsArray($ipArray) Or UBound($ipArray) = 0 Then
		ConsoleWrite("invalid ip array"&@CRLF)
		FinishedGettinServers();/
		ResetRefreshTimmers()
		return
	EndIf

	if $bCombine Then
		$ipArray = _ArrayUnique($ipArray, 0, 0, 1, $ARRAYUNIQUE_NOCOUNT, 0)
		if @error Then
			ConsoleWrite("invalid arrayUnique err:"&@error&@CRLF)
			FinishedGettinServers()
			ResetRefreshTimmers()
		EndIf
	EndIf


	;clear selected column. todo work out how to re-sort without mouse click
	GUICtrlSendMsg($UI_ListV_svData_A, $LVM_SETSELECTEDCOLUMN, -1, 0) ;updateLV

	;clear internal array ($g_aServerStrings[])
	ResetServerListArrays(BitShift(1, -($iGameIdx)))

	;populate internal array with
	FillServerStringArrayIP($iGameIdx, $ipArray)

	;refresh list using internal array
	RefreshServersInListview($iGameIdx)

	;rebuild list using filters
	if _IsChecked($UI_Btn_filterOffline) or _IsChecked($UI_Btn_filterEmpty) or _IsChecked($UI_Btn_filterFull) Then
		FillListView_A_Filtered($iGameIdx, $UI_ListV_svData_A, False)
	EndIf

	;ListviewResetSortOrder()
	FinishedGettinServers();/
	ResetRefreshTimmers()
EndFunc; -->  GetServerListFromMaster TCP
;========================================================

Func GSpy_addServerData(ByRef $retGSData, $data)
	;assign new arraw
	If Not IsArray($retGSData) Then
		Local $aTmp[12]
		$retGSData = $aTmp
	EndIf

	local $idx = StringInStr($data, '\queryid\', $STR_CASESENSE, -1)
	Local $idxFinal = StringInStr($data, '\final\', $STR_CASESENSE, -1)
	If $idx Then
		local $sTrimedData = StringLeft($data, $idx -1)
		local $id = Number(StringRight($data, 1))
		if $id > 0  Then
			if $id > 10 Then $id = 10
			if $idxFinal Then
				$retGSData[0] = $id ;final marks count
				$sTrimedData = StringLeft($data, $idxFinal)
			EndIf
			$retGSData[$id]	&= $sTrimedData
		Else
			$retGSData[0] = 1 ;count
			$retGSData[1] &= $sTrimedData ; failed
			Return True
		EndIf
	Else
		$retGSData[0] = 1 ;count
		$retGSData[1] &= $data
		Return True
	EndIf

	For $i = 1 To $retGSData[0]
		if Not $retGSData[$i] Then Return False ;wating on more data
	Next

	Return True
EndFunc


;========================================================
;--> UDP RECV listenIncommingServers()
Func listenIncommingServers($iGameIdx, $aServerIdx, $start, $end) ;, $iOffset) ;todo fix final
	Local $i, $data, $dataRecv, $iSVResponded = 0 ;counter
	Local $iSVCount = $end-$start+1 ;  total this wave
	Local $sIP, $iPort, $iOff, $idx
	;Local $countServ = GetServerCountInArray($iGameIdx) ;count servers in array
	Local $aResponce[$iSVCount][$COUNT_PACKET]
	;Local Const	$sSV_ErrorStr = "Info string length exceeded"
	Local $isGamespy = ($g_gameConfig[$iGameIdx][$NET_GS_P])? ( True):(False)

	;dupe list. fill global/internal later
	For $i = 0 To $iSVCount-1
		;$iOff = $start + $i + $iOffset
		$iOff =  $aServerIdx[$start + $i]
		$aResponce[$i][$PACKET_DATA] = ""
		$aResponce[$i][$PACKET_IP]   = $g_aServerStrings[$iGameIdx][$iOff][$COL_IP]
		$aResponce[$i][$PACKET_PORT] = $g_aServerStrings[$iGameIdx][$iOff][$COL_PORT]
		$aResponce[$i][$PACKET_PING] = 0
	Next

	ConsoleWrite(">listen Incomming Servers count:"& $iSVCount  &@CRLF)
	GUICtrlSetData($UI_Prog_getServer, Int($start * 100 / $g_iServerCountTotal))

	Local $iTimeOut = TimerInit()
	While 1 ;loop until all servers recieved or timout hit
		While 1
			$dataRecv = _UDPRecvFrom($g_hSocketServerUDP, 10000, 0) ;2048
			if IsArray($dataRecv) Then
				ExitLoop(1)
			ElseIf TimerDiff($iTimeOut) > 990 Then
				ConsoleWrite(">TIMEOUT.. 1 seconds"&@CRLF)
				ExitLoop(2) ;stop do and stop while
			EndIf
			Sleep(10)
		WEnd ; Until  IsArray($dataRecv)

		$data =  $dataRecv[$PACKET_DATA]         ;datastream
		$sIP =   $dataRecv[$PACKET_IP]           ;ip
		$iPort = Number($dataRecv[$PACKET_PORT]) ;port
		;ConsoleWrite(StringFormat("Rec: %s:%i\n-%s\n", $sIP, $iPort, $data) &@CRLF)

		;check EOT
		For $i = 0 To $iSVCount -1
			$iOff = $aServerIdx[$start + $i]

			;find matching ip/port
			if $aResponce[$i][$PACKET_PORT] = $iPort And StringCompare($aResponce[$i][$PACKET_IP], $sIP) = 0 Then
				If $isGamespy Then
					if GSpy_addServerData($aResponce[$i][$PACKET_DATA], $data) Then
						;has '\final\
						$iSVResponded += 1
						$g_iServerCountTotal_Responded +=1
						$aResponce[$i][$PACKET_PING] = TimerDiff($g_aServerStrings[$iGameIdx][$iOff][$COL_TIME]) ;for ping
					EndIf
				Else
					if $aResponce[$i][$PACKET_DATA] = "" Then
						$iSVResponded += 1
						$g_iServerCountTotal_Responded +=1
					EndIf
					$aResponce[$i][$PACKET_DATA] &= $data
					$aResponce[$i][$PACKET_PING] = TimerDiff($g_aServerStrings[$iGameIdx][$iOff][$COL_TIME]) ;for ping
				EndIf
				;ConsoleWrite("+match id:" &$iOff&@CRLF)

				GUICtrlSetData($UI_Prog_getServer, Int((($start + $iSVResponded ) * 100) / $g_iServerCountTotal))
				if $iSVResponded = $iSVCount Then
					ConsoleWrite("!got All " &$iSVCount& " servers"&@CRLF)
					ExitLoop(2)
				Else
					ExitLoop(1)
				EndIf
			EndIf
		Next
	WEnd

	For $i = 0 To $iSVCount-1
		;$iOff = $start + $i + $iOffset
		$iOff =  $aServerIdx[$start + $i]
		If $aResponce[$i][$PACKET_DATA] = "" Then
			;todo fill dead server with icon
			ConsoleWrite("!missing data. svID:"&$iOff&@CRLF)
			ContinueLoop
		EndIf
		;server responceHeader\serverRules <key/value>...


		Select
			Case $isGamespy ; $g_gameConfig[$iGameIdx][$NET_GS_P] ;gamespy protocol
				if IsArray($aResponce[$i][$PACKET_DATA]) Then
					local $aData = _ArrayToString($aResponce[$i][$PACKET_DATA], "", 1) ;
					;ConsoleWrite('>'&$aData&@CRLF&@CRLF)
					$data = StringTrimLeft($aData, StringInStr($aData, "\")) ;remove prefix, upto "\"
					;player data
					$idx = StringInStr($data, "\player_")
					If $idx Then
						$g_aServerStrings[$iGameIdx][$iOff][$COL_INFOPLYR] = StringTrimLeft($data, $idx)
						$data = StringMid($data, 1, $idx)
					EndIf
				EndIf
			Case ($g_gameConfig[$iGameIdx][$NET_S2C] = $S2C_HEX2) Or ($g_gameConfig[$iGameIdx][$NET_S2C] = $S2C_Q1) ;Case $ID_HEX, $ID_Q1
				$data = Hexen2ServerResponce($aResponce[$i][$PACKET_DATA]) ;special case
			Case Else
				$data = StringTrimLeft($aResponce[$i][$PACKET_DATA], StringInStr($aResponce[$i][$PACKET_DATA], "\")) ;remove prefix, upto "\"
				;player data
				$idx = StringInStr($data, Chr(10), 1)  ;= StringSplit($string, Chr(10), $STR_ENTIRESPLIT)
				if $idx Then
					$g_aServerStrings[$iGameIdx][$iOff][$COL_INFOPLYR] = StringTrimLeft($data, $idx)
					$data = StringMid($data, 1, $idx)
				EndIf
			;todo ADD GAMES
		EndSelect

		$g_aServerStrings[$iGameIdx][$iOff][$COL_INFOSTR] = StringSplit($data, "\", $STR_NOCOUNT)
		$g_aServerStrings[$iGameIdx][$iOff][$COL_PING] = int($aResponce[$i][$PACKET_PING])
		;ConsoleWrite(StringFormat( ">id:%i\n-data:%s\n+p:%s l:%i", _
		;	$iOff, $data, $g_aServerStrings[$iGameIdx][$iOff][$COL_INFOPLYR], $g_aServerStrings[$iGameIdx][$iOff][$COL_IDX]) &@CRLF)
	Next

EndFunc; --> listen Incomming Servers
;========================================================

Func ReadStringInArray(ByRef $aChars, ByRef $idx, $numChars)
	Local $sRet = ""
	While $idx < $numChars
		if $aChars[$idx] = 0 then ;search null
			$idx += 1
			ExitLoop
		endif
		$sRet &= chr($aChars[$idx])
		$idx += 1
	WEnd
	return $sRet
EndFunc

Func ReadCharInArray(ByRef $aChars, ByRef $idx, $numChars)
	Local $sRet = ""
	if $idx < $numChars Then
		$sRet &= $aChars[$idx]
		$idx += 1
	EndIf

	Return $sRet
EndFunc

Func Hexen2ServerResponce(ByRef $data)
	;hexen uses a comprerssed message for info string
	local const $hex2_CCREP_SERVER_INFO = 131 ;0x83
	local const $hex2_NETFLAG_CTL = 0x80000000 ; 32768
	local $i = 0
	local $aChars = StringToASCIIArray($data, 0, Default, $SE_ANSI)
	Local $iLen = UBound($aChars)

	if not IsArray($aChars) or  $iLen < 4 Then return ""
	if not (BitAND(MSG_ReadLong($aChars, $i, $iLen, True), 0xffff0000) = $hex2_NETFLAG_CTL) Then return ""
	if not (MSG_ReadByte($aChars, $i, $iLen) = $hex2_CCREP_SERVER_INFO) Then return ""

	return  StringFormat( _
		"hostaddress\\%s\\hostname\\%s\\mapname\\%s\\numplayers\\%i\maxplayers\\%i\\protocol\\%i\\", _
		MSG_ReadString($aChars, $i, $iLen), _ ;hostaddress
		MSG_ReadString($aChars, $i, $iLen), _ ;hostname
		MSG_ReadString($aChars, $i, $iLen), _ ;mapname
		MSG_ReadByte($aChars, $i, $iLen), _   ;numplayers
		MSG_ReadByte($aChars, $i, $iLen), _   ;maxplayers/maxclients
		MSG_ReadByte($aChars, $i, $iLen))     ;protocol
EndFunc

Func FillListView_A_FullData($iGameIdx, $aServerIdx, $start, $end)
	Local $ListViewA = getListView_A_CID() ;todo cleanup fun
	Local $iOff, $iSVCount = $end-$start+1 ;  total this wave

	_GUICtrlListView_BeginUpdate($ListViewA)
	ConsoleWrite("$iGameIdx:"&$iGameIdx&@CRLF)
	For $i = 0 To $iSVCount-1
		;$iOff = $start + $i + $iOffset
		$iOff = $aServerIdx[$start + $i]
		FillServerListView_SV_Responce( _
			$iGameIdx, _
			$g_aServerStrings[$iGameIdx][$iOff][$COL_IP], _
			$g_aServerStrings[$iGameIdx][$iOff][$COL_PORT], _ ;
			$g_aServerStrings[$iGameIdx][$iOff][$COL_PORTGS], _ ;
			$g_aServerStrings[$iGameIdx][$iOff][$COL_NAME], _ ;
			$g_aServerStrings[$iGameIdx][$iOff][$COL_PING], _ ;
			$g_aServerStrings[$iGameIdx][$iOff][$COL_PLAYERS], _ ;
			$g_aServerStrings[$iGameIdx][$iOff][$COL_INFOSTR], _  ;data
			$g_aServerStrings[$iGameIdx][$iOff][$COL_INFOPLYR], _ ;player data
			$g_aServerStrings[$iGameIdx][$iOff][$COL_MAP], _
			$g_aServerStrings[$iGameIdx][$iOff][$COL_MOD], _
			$g_aServerStrings[$iGameIdx][$iOff][$COL_IDX])        ;sorted index
	Next
	_GUICtrlListView_EndUpdate($ListViewA)
EndFunc

; Post a WM_COMMAND message to a ctrl in a gui window
Func PostButClick($hWnd, $nCtrlID)
    DllCall("user32.dll", "int", "PostMessage", _
            "hwnd", $hWnd, _
            "int", 0x0111, _    ; $WM_COMMAND
            "int", BitAND($nCtrlID, 0x0000FFFF), _
            "hwnd", GUICtrlGetHandle($nCtrlID))
EndFunc   ;==>PostButClick

#EndRegion --> TCP GET LIST, FILL ARRAY

#Region -->  UDP UTIL
; port for master/server communication
Func _BIND_UDP_SOCKET(ByRef $iSocket)
	;Local $portRand = Random(50000, 55532, 1) ;RAND PORT

	For $ipSet = 0 to 30
		$iSocket = _UDPBind("", 0) ;$portRand
		If $iSocket > 0 Then
			ExitLoop
		Else
			;$portRand += 2
			ContinueLoop
		EndIf
	Next ;--> Rand Port

	If $iSocket <= 0 And Not $g_bAutoRefreshActive Then
		setTempStatusBarMessage("ERROR: Can't allocate a local port.", True)
	EndIf
EndFunc
;==============


;==> start external source code
; ===============================================================================================================================
; #INDEX# =======================================================================================================================
; Title .........: Winsock
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Functions that assist with Winsock library management.
; Author(s) .....: j0kky
; ===============================================================================================================================

Func _UDP_SocStruct()
	Local Const $tagSockAddr = "short sin_family; ushort sin_port; " & _
		"STRUCT; ulong S_addr; ENDSTRUCT; " & _ ;sin_addr
		"char sin_zero[8]"

	Return $tagSockAddr
EndFunc

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
        $tSockAddr = DllStructCreate(_UDP_SocStruct())
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
	$g_hSocReqNum+=1
	ConsoleWrite(">BIND SOCKET eventNum= "& $g_hSocReqNum &@CRLF); hypo
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
        Local $tSockAddr = DllStructCreate(_UDP_SocStruct())
        DllStructSetData($tSockAddr, "sin_family", 2) ;AF_INET (AF_INET6)
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
	Local $aRet, $nReturn, $bError = 0, $nCode = 0, $tSockAddr, $tBuf, $hWs2, $aResult[4]

	If $iFlag = Default Then $iFlag = 0
	$iMainsocket = Number($iMainsocket)
	$iMaxLen = Number($iMaxLen)
	$iFlag = Number($iFlag)
	If $iMainsocket < 0 Or _
			$iMaxLen < 1 Or _
			Not ($iFlag = 0 Or $iFlag = 1) Then Return SetError(-4, 0, -1) ; invalid parameter

	$hWs2 = DllOpen("Ws2_32.dll")
	If @error Then Return SetError(-2, 0, -1) ;missing DLL

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

	$tSockAddr = DllStructCreate(_UDP_SocStruct())
	;$tBuf = DllStructCreate("char[" & $iMaxLen & "]")
	$tBuf = DllStructCreate("BYTE[" & $iMaxLen & "]")

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
		$aResult[$PACKET_SIZE] = $aRet[0] ;return buffer size

		If $iFlag Then
			$aResult[$PACKET_DATA] = BinaryMid(Binary(DllStructGetData($tBuf, 1)), 1, $aRet[0]*8) ;data. todo check this ($aRet*x)
		Else
			$aResult[$PACKET_DATA] = StringMid(BinaryToString(DllStructGetData($tBuf, 1)), 1, $aRet[0])
		EndIf


		$aRet = DllCall($hWs2, "ptr", "inet_ntoa", "ulong", DllStructGetData($tSockAddr, "S_addr"))
		If @error Then
			$bError = -1
		ElseIf $aRet[0] = Null Then
			$bError = 1
		Else
			$aResult[$PACKET_IP] = DllStructGetData(DllStructCreate("char[15]", $aRet[0]), 1) ;IP address
			$aRet = DllCall($hWs2, "ushort", "ntohs", "ushort", DllStructGetData($tSockAddr, "sin_port"))
			If @error Then
				$bError = -1
			Else
				$aResult[$PACKET_PORT] = $aRet[0] ;port
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
	$g_hSocReqNum+=1
	ConsoleWrite(">CLOSE SOCKET eventNum= "&$g_hSocReqNum&@CRLF) ;hypo
    Return SetError($nCode, 0, $nReturn)
EndFunc   ;==>_UDPCloseSocket


;==> hypo set socket buffer larger
Func _UDP_setBuffSize($sSocket, $sSizeSend, $sSizeRecv)
	Local Const $SO_SNDBUF = 0x1001
	Local Const $SO_RCVBUF = 0x1002
	Local Const $SOL_SOCKET = 0xFFFF
	Local $tResult = DllStructCreate("int")
	Local $tSettingSend = DllStructCreate("int packet")
	Local $tSettingRecv = DllStructCreate("int packet")
	Local $iRes

	DllStructSetData($tSettingSend, "packet", $sSizeSend) ; Or 1 instead of "var1".
	DllStructSetData($tSettingRecv, "packet", $sSizeRecv) ; Or 1 instead of "var1".

	;set in/out packet size
	$iRes = _UDP_setSockOpt($sSocket, $SOL_SOCKET, $SO_SNDBUF, $tSettingSend)
	If $iRes = 0 Then ConsoleWrite(">set 'Send' buffer size" & @CRLF)
	$iRes = _UDP_setSockOpt($sSocket, $SOL_SOCKET, $SO_RCVBUF, $tSettingRecv)
	If $iRes = 0 Then ConsoleWrite(">set 'Rec' buffer size" & @CRLF)

	;confirm setting
	$iRes = _UDP_getSockOpt($sSocket, $SOL_SOCKET, $SO_SNDBUF, $tResult)
	If $iRes = 0 Then ConsoleWrite(">send buffer size = " & DllStructGetData($tResult, 1) & @CRLF)
	$iRes = _UDP_getSockOpt($sSocket, $SOL_SOCKET, $SO_RCVBUF, $tResult)
	If $iRes = 0 Then ConsoleWrite(">receive buffer size = " & DllStructGetData($tResult, 1) & @CRLF)
EndFunc ;==> _UDP_setBuffSize

Func _UDP_getSockOpt($iSocket, $iLevel, $iOptName, ByRef $tOptVal)
    Local $iOptLen = DllStructGetSize($tOptVal)
    Local $aRet = DllCall("WS2_32.DLL", "int", "getsockopt", "int", $iSocket, "int", $iLevel, "int", $iOptName, "struct*", $tOptVal, "int*", $iOptLen)
    Return $aRet[0]
EndFunc ;==> _UDP_getSockOpt

Func _UDP_setSockOpt($iSocket, $iLevel, $iOptName, ByRef $tOptVal)
    Local $iOptLen = DllStructGetSize($tOptVal)
    Local $aRet = DllCall("WS2_32.DLL", "int", "setsockopt", "int", $iSocket, "int", $iLevel, "int", $iOptName, "struct*", $tOptVal, "int*", $iOptLen)
    Return $aRet[0]
EndFunc ;==> _UDP_setSockOpt



;-->END Winsock
; ===============================================================================================================================
#EndRegion

#Region --> ICON INCLUDE
;==> Resources.au3 by Zedna
Func _ResourceGet($ResName, $ResLang = 0) ; $RT_RCDATA = 10
	Local Const $IMAGE_BITMAP = 0
	Local $hInstance, $hBitmap
	#forceref $ResLang

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

	_SetBitmapToCtrl($CtrlId, $ResData) ;todo unuused/cleanup
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
	#forceref $iCtrl_GETIMAGE

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


#Region --> UDP SEND
Func SendEchoToJediServer($iGameIdx, $aIPArray, $aServerIdx)
	Local $sIP = "", $sIdx = "", $svID, $sBetween, $sPData
	;_ArrayDisplay($aServerIdx)
	For $i = 0 To UBound($aIPArray) - 1
		$sPData = $g_aServerStrings[$iGameIdx][$aServerIdx[$i]][$COL_INFOSTR] ; & $g_aServerStrings[$iGameIdx][$aServerIdx[$i]][$COL_INFOPLYR]
		;ConsoleWrite("-dat:"&$sPData[0]&@CRLF)
		if IsArray($sPData) And StringInStr($sPData[0], "ÿÿÿÿecho", $STR_CASESENSE, 1, 1, 8) Then
			$sBetween = _StringBetween($sPData[0], '"', '"')
			if not @error Then
				If $sIP = "" Then
					$sIP &=  $aIPArray[$i]
					$sIdx &= $aServerIdx[$i]
				Else
					$sIP &=  "|"& $aIPArray[$i]
					$sIdx &= "|"& $aServerIdx[$i]
				EndIf
				$g_aServerStrings[$iGameIdx][$aServerIdx[$i]][$COL_INFOSTR] = $sBetween[0]
			EndIf
		EndIf
	Next

	if $sIP <> "" Then
		$aIPArray = StringSplit($sIP, "|", $STR_NOCOUNT)
		$aServerIdx = StringSplit($sIdx, "|", $STR_NOCOUNT)
		SendSTATUStoServers_Split($iGameIdx, $aIPArray, $aServerIdx, True)
	EndIf

	Return True
EndFunc

Func SendStatustoServers_Init($iGameIdx, $aIPArray, $aServerIdx, $bCheckDead = True)
	;
	Local $hSocketServerUDP = -1
	_BIND_UDP_SOCKET($g_hSocketServerUDP)
	If $g_hSocketServerUDP > 0 Then
		_UDP_setBuffSize($g_hSocketServerUDP, 256, 10000) ; large recieve packet

		SendSTATUStoServers_Split($iGameIdx, $aIPArray, $aServerIdx, False) ; send inital ping to all
		If StringCompare($g_gameConfig[$iGameIdx][$GNAME_SAVE], 'JK3') = 0 Then; $iGameIdx = $ID_JK3 Then ;todo add games
			SendEchoToJediServer($iGameIdx, $aIPArray, $aServerIdx)
		EndIf
		if $bCheckDead Then
			SendSTATUStoServers_CheckDead($iGameIdx, $aIPArray, $aServerIdx) ; check dead servers ;todo
		EndIf
		If _IsChecked($UI_CBox_sound) Then
			selectAudoToPlay(1) ; 0=mbrowser 1=gamespy
		EndIf
	Else
		ConsoleWrite("Error: Cant get port")
		Return False
	EndIf
	_UDPCloseSocket($g_hSocketServerUDP)

	ConsoleWrite("+finished getting servers gameID:"&$iGameIdx&@CRLF)
	Return True
EndFunc


Func SendSTATUStoServers_Split($iGameIdx, $aIPArrayRef, $aServerIdx, $echo)
	Local $end, $iLast = UBound($aIPArrayRef)-1
	ConsoleWrite("!server count:"&$iLast+1&@CRLF)

	if $iLast >= $g_iMaxSer Then $iLast = $g_iMaxSer - 1 ;make sure list is not to big

	For $start = 0 To $iLast Step $g_iMaxIP
		if (($start +  $g_iMaxIP-1) > $iLast) then
			$end = $iLast
		else
			$end = $start + $g_iMaxIP-1
		endif
		ConsoleWrite("!split count:"& $end + 1 &@CRLF)

		If SendSTATUStoServers($iGameIdx, $aIPArrayRef, $aServerIdx, $start, $end, $echo) Then ;get each server details
			listenIncommingServers($iGameIdx, $aServerIdx, $start, $end) ;now listen for responce
			FillListView_A_FullData($iGameIdx, $aServerIdx, $start, $end)
		EndIf
	Next
EndFunc

Func SendSTATUStoServers_CheckDead($iGameIdx, $aIPArrayRef, $aServerIdx)
	Local $iOff, $count = 0,  $aIP, $aSVID = $aServerIdx
	Local $sIPArrayRef_tmp = ""


	;hypo send ping to list 2 more times. if unresponsive
	for $iLoop = 0 To 0
		If $g_iServerCountTotal_Responded >= $g_iServerCountTotal Then
			ExitLoop
		EndIf

		if $iLoop = 0 Then ConsoleWrite("!Some servers failed to respond. Sending status again"&@CRLF)

		For $int = 0 To UBound($aIPArrayRef) -1
			$iOff = $aServerIdx[$int]
			If $g_aServerStrings[$iGameIdx][$iOff][$COL_PING] = 999 Then
				if $count Then $sIPArrayRef_tmp &= "|"
				$sIPArrayRef_tmp &= String($g_aServerStrings[$iGameIdx][$iOff][$COL_IP] &":"& _
				                           $g_aServerStrings[$iGameIdx][$iOff][$COL_PORT])
				$aSVID[$count] = $iOff
				$count += 1
			EndIf
		Next
		ConsoleWrite("!dead count: "&$count&@CRLF)

		if $sIPArrayRef_tmp <> "" Then
			SendSTATUStoServers_Split($iGameIdx, _
				StringSplit($sIPArrayRef_tmp, "|", $STR_NOCOUNT), _
				$aSVID, False)
		EndIf
	Next
EndFunc

Func SendSTATUStoServers($iGameIdx, $arrayServerX, $aServerIdx, $startNum, $endNum, $isEcho) ;, $iOffset = 0)
	Local $iIP, $iErrorX, $iRetCount = 0
	Local $sIPAddress, $iPort, $aIP_Port, $sSTATUS_msg
	Local $iSVCount = UBound($arrayServerX)

	;ConsoleWrite("!Send STATUS to Servers count:"&$endNum -$startNum +1 &@CRLF)

	If $iSVCount = 0 or IsArray($arrayServerX) = 0 Then
		ConsoleWrite("!Send STATUS to Servers failed"&@CRLF)
		Return False
	EndIf

	if Not $isEcho Then
		$sSTATUS_msg = sendStatusMessageType_UDP($iGameIdx, False) ;todo port...
	EndIf
	;ConsoleWrite(">Send STATUS to Servers. start:"&$startNum&" end:" &$endNum&" total:"&$iSVCount &@CRLF& "-message:"&$sSTATUS_msg& @CRLF)
	;ConsoleWrite("-sendto:"& Hex(StringToBinary($sSTATUS_msg))&@CRLF) ;todo cleanup

	For $iIP = $startNum To $endNum
		;ConsoleWrite("-server addy:"&$arrayServerX[$iIP]&@CRLF)
		If $iIP >= $iSVCount Then
			ConsoleWrite("!Error: end count larger than array. index:"&$iIP&@CRLF)
			ExitLoop
		EndIf
		If $arrayServerX[$iIP] = "" Then
			ConsoleWrite("!servers blank. index:"&$iIP&@CRLF)
			ContinueLoop
		EndIf

		$aIP_Port = StringSplit($arrayServerX[$iIP], ":")
		If @error Then
			ConsoleWrite("error spliting ':' str:" &$arrayServerX[$iIP] & @CRLF)
			Return False; end??
		EndIf

		If $isEcho Then
			$sSTATUS_msg = sendEchoMessage_UDP($iGameIdx, $aServerIdx[$iIP]) ;todo add games
		EndIf


		$sIPAddress = TCPNameToIP( $aIP_Port[1]) ;todo move this
		$iPort      = Number($aIP_Port[2])
		;ConsoleWrite("-UDP Send to:" &$sIPAddress&":"&$iPort & " msg:" &$sSTATUS_msg&@CRLF) ;todo

		$iErrorX = _UDPSendTo($sIPAddress, $iPort, $sSTATUS_msg, $g_hSocketServerUDP)
		if @error Then
			ConsoleWrite("!UDP Send \status\ sock error =  " & $iErrorX & " error" &"ip:"&$sIPAddress&":"& $iPort & @CRLF)
		Else
			$iRetCount += 1
		EndIf
		;$g_aServerStrings[$iGameIdx][$iIP+$iOffset][$COL_TIME] = TimerInit() ; store sent time
		$g_aServerStrings[$iGameIdx][$aServerIdx[$iIP]][$COL_TIME] = TimerInit() ; store sent time
	Next

	ConsoleWrite("-sendTo count:" &$iRetCount&@CRLF)
	Return $iRetCount
EndFunc ; -->send YYYYStatus
;========================================================
;--> END UDP SEND

#EndRegion

#Region --> GAME STRINGS DISPLAYED
;=======================================================
; --> fill array kp server
Func InfoStr_GetServerName(ByRef $aData)
	Local $sTmp = parseInfoString($aData, "hostname|sv_hostname") ;todo check game?
	Return StringRegExpReplace($sTmp, "[^ -ÿ]+" ,"") ;remove < asc(32)
EndFunc

;===========================
Func InfoStr_GetPlayerCount(ByRef $aData, ByRef $sPData, $iGameIdx)
	Local $player = 0, $sRet, $name, $frags, $ping, $aTmp

	;check info string first
	$sRet = parseInfoString($aData, "numplayers")
	if $sRet <> "" Then
		return Number($sRet, 1)
	EndIf

	;count actual players instead
	if $g_gameConfig[$iGameIdx][$NET_GS_P] then ;gamespy players
		;gs protocol...
		if $sPData = "" Then Return 0
		$aTmp = StringSplit($sPData, "\", $STR_NOCOUNT)
		For $i = 0 to $MAX_PLAYERS -1
			if parseInfoString($aTmp, "player_"& $i) <> "" Then
				$player += 1
			ElseIf $i > 0 Then
				 Return $player ;sof used player_1
			EndIf
		Next
	Else
		if $sPData = "" Then Return 0
		$aTmp = StringSplit($sPData, Chr(10))
		If @error Then
			ConsoleWrite("player error no @LF" & $sPData&@CRLF)
			Return 0
		EndIf
		;3 lines standard >= players
		For $iply = 1 To $aTmp[0]
			If $aTmp[$iply] <> "" Then ;catch end line @LF, EOT
				If Not parsePlayerString($aTmp[$iply], $name, $frags, $ping) Then ContinueLoop
				;remove bots from player counts
				Switch $g_gameConfig[$iGameIdx][$BOT_TYPE]
					Case $BOT_Q2 ; $ID_Q2, $ID_DDAY
						If StringInStr($name, "WallFly", $STR_NOCASESENSEBASIC) Then ContinueLoop ;WTF is this. skip bot?
						if Number($ping) < 3 Then ContinueLoop ;skip bot
					Case $BOT_Q3
						if Number($ping) = 0 Then ContinueLoop ;skip bot
					;todo ADD GAMES
				EndSwitch
				$player += 1
			EndIf
		Next
	EndIf

	Return $player
EndFunc

Func parseInfoString(ByRef $aData, $sSearch)
	Local $aSearch = StringSplit($sSearch, "|", $STR_NOCOUNT) ;read multiple keys

	For $sIdx = 0 to UBound($aSearch) -1
		For $i = 0 to UBound($aData) -2 Step 2
			If StringCompare($aData[$i], $aSearch[$sIdx]) = 0 Then
				Return $aData[$i+1]
			EndIf
		Next
	Next

	Return "" ;failed
EndFunc

;=======================
Func InfoStr_GetPlayerMax(ByRef $aData)
	Local $aServVars = parseInfoString($aData, "maxclients|maxplayers|sv_maxclients|") ;
	if $aServVars <> "" Then
		Return $aServVars
	EndIf
	Return "0" ;failed to find
EndFunc
;=======================
Func InfoStr_GetMapName(ByRef $aData)
	Return parseInfoString($aData, "mapname|map")
EndFunc
;=======================
Func InfoStr_GetModName(ByRef $aData)
	Return parseInfoString($aData, "gametype|gamename|game|*gamedir")
EndFunc ; --> fill array kp server
;=======================
Func InfoStr_GetGamePort(ByRef $aData)
	Return parseInfoString($aData, "hostport")
EndFunc ; --> set gamespy/game port for kingpin

;=================================


Func getListView_A_CID()
	Switch $g_iTabNum
		Case $TAB_GB ; 0 to $COUNT_GAME -1
			Return $UI_ListV_svData_A
		Case $TAB_MB
			Switch $iMGameType
				Case 0 to 2 ;$ID_Q2
					Return $UI_ListV_mb_ABC[$iMGameType]
				Case Else
					Return $UI_ListV_mb_ABC[0] ;default
			EndSwitch
		Case Else ;1
			Return $UI_ListV_svData_A ;default
	EndSwitch
EndFunc

Func getListView_B_CID()
	Switch $g_iTabNum
		Case $TAB_GB
			Switch $g_iCurGameID
				Case 0 To $COUNT_GAME-1
					Return $UI_ListV_svData_B
				Case Else
					Return $UI_ListV_svData_B ;default
			EndSwitch
		Case Else ;1
			Return $UI_ListV_svData_B ;default
	EndSwitch
EndFunc

Func getListView_C_CID()
	Switch $g_iTabNum
		Case $TAB_GB
			Switch $g_iCurGameID
				Case 0 To $COUNT_GAME-1
					Return $UI_ListV_svData_C
				Case Else
					Return $UI_ListV_svData_C ;default
			EndSwitch
		Case Else
			Return $UI_ListV_svData_C;default
	EndSwitch
EndFunc

Func IconPingX($iPingX)
	If $iPingX <150 Then Return 1 ;green
	if $iPingX >= 150 And $iPingX < 500 Then Return 2 ;yellow
	If $iPingX >=500 Then Return 3 ;red
EndFunc

Func IconPlayerX($iPlayersX, $iPlayerMax)
	If $iPlayersX = 0 Then
		Return 0 ;empty
	ElseIf $iPlayersX = $iPlayerMax Then
		Return 6 ;full icon
	EndIf
	Return 7 ;half full icon
EndFunc

#EndRegion --> GAME STRINGS DISPLAYED


#region --> OFFLINE LIST
; --> BUTTON OFFLINE
GUICtrlSetOnEvent($UI_Btn_offlineList, "UI_Btn_offlineListClicked")
	Func UI_Btn_offlineListClicked()
		SetSelectedGameID()
		EnableUIButtons(False)
		Switch $g_iCurGameID
			Case 0 to $COUNT_GAME -1
				LoadOffLineServerList($g_iCurGameID)
		EndSwitch
		EnableUIButtons(True)
	EndFunc

Func GetGameIDString($iGameIdx)
	Return $g_gameConfig[$iGameIdx][$GNAME_SAVE]
EndFunc

Func FindGameID($sGame)
	For $i = 0 to $COUNT_GAME-1
		if StringCompare($g_gameConfig[$i][$GNAME_SAVE], $sGame, $STR_NOCASESENSEBASIC) = 0 Then
			Return $i ;found game
		EndIf
	Next
	Return 0
EndFunc

;--> OFFLNE LIST
;========================================================
; --> set offline list
Func LoadOffLineServerList($iGameIdx)
	EnableUIButtons(False)
	Local $sIP_Port, $tmpArray, $i, $sIP, $iPort, $iPortGS, $arrayOffline, $svNum = 0
	Local $ListViewA = getListView_A_CID()
	Local $aTmpOffline[]

	$aTmpOffline['KP'] = "" & _
		"kp.hambloch.com:31510|Luschen Botmatch"      &@CRLF& _
		"kp.hambloch.com:31511|Luschen Hookmatch"     &@CRLF& _
		"kp.hambloch.com:31512|Luschen Deathmatch"    &@CRLF& _
		"kp.hambloch.com:31515|Luschen COOP"          &@CRLF& _
		"kp.hambloch.com:31516|Luschen Gunrace +Bots" &@CRLF& _
		"kp.hambloch.com:31519|---Battys kit---"	  &@CRLF& _
		"" & _
		"150.107.201.184:31510|Newskool Classic Gangbang" &@CRLF& _
		"150.107.201.184:31511|Newskool Instagib"         &@CRLF& _
		"150.107.201.184:31512|Newskool Bagman"           &@CRLF& _
		"150.107.201.184:31513|Newskool Fragfest"         &@CRLF& _
		"150.107.201.184:31514|Newskool CTF"              &@CRLF& _
		"150.107.201.184:31515|Newskool Crash Squad"      &@CRLF& _
		"150.107.201.184:31516|Newskool Power2"           &@CRLF& _
		"150.107.201.184:31517|Newskool Gunrace"          &@CRLF& _
		"" & _
		"150.107.201.184:31518|Newskool Killapin"                     &@CRLF& _
		"150.107.201.184:31531|Newskool Kill Confirmed"               &@CRLF& _
		"150.107.201.184:31532|Newskool Hitmen"                       &@CRLF& _
		"150.107.201.184:31533|Newskool Chicken Chase"                &@CRLF& _
		"150.107.201.184:31534|Newskool Rocketfest"                   &@CRLF& _
		"150.107.201.184:31537|Newskool Easter/Summer/Halloween/Xmas" &@CRLF& _
		"" & _
		"202.169.104.136:31355|macanah.mooo.com BOTMATCH"         &@CRLF& _
		"202.169.104.136:31399|macanah.mooo.com Kingpin Speedway" &@CRLF& _
		"202.169.104.136:31510|macanah.mooo.com ffa"              &@CRLF& _
		"202.169.104.136:31513|macanah.mooo.com riotz mod"        &@CRLF& _
		"202.169.104.136:31515|macanah.mooo.com Jedi Force Mod"   &@CRLF& _
		"202.169.104.136:31516|macanah.mooo.com Kpz COOP"         &@CRLF& _
		"202.169.104.136:31517|macanah.mooo.com BaGmaN"           &@CRLF& _
		"202.169.104.136:31518|macanah.mooo.com Assault"          &@CRLF& _
		"202.169.104.136:31519|macanah.mooo.com CTF"              &@CRLF& _
		"202.169.104.136:31556|macanah.mooo.com Crash Squad"      &@CRLF& _
		"" & _
		"109.205.61.174:31512|East Coast Snitch Slappa (Bagman)" &@CRLF& _
		"109.205.61.174:31513|East Coast Deathmatch"             &@CRLF& _
		"109.205.61.174:31514|East Coast CTF"                    &@CRLF& _
		"109.205.61.174:31515|East Coast Crash Squad"            &@CRLF& _
		"109.205.61.174:31517|East Coast Gunrace"                &@CRLF& _
		"109.205.61.174:31536|East Coast Xmas Crash"             &@CRLF& _
		"109.205.61.174:31537|East Coast Xmas"                   &@CRLF& _
		"109.205.61.174:31538|East Coast Xmas CTF"		         &@CRLF& _
		"" & _
		"208.77.22.94:31510|Dark Fiber FFA Chicago"             &@CRLF& _
		"45.89.125.89:31510|Dark Fiber FFA EU"                  &@CRLF& _
		"" & _
		"71.254.216.136:31510|Cent's Enhanced Bagman Server"    &@CRLF& _
		"71.254.216.136:31512|Cent's KPQ2 Deathmatch Server"    &@CRLF& _
		"71.254.216.136:31514|Cent's Blood Money Bagman Server" &@CRLF& _
		"71.254.216.136:31515|Cent's Crash TDM Server"          &@CRLF& _
		"" & _
		"188.74.83.135:19266|KeeF's Badass Server"     &@CRLF& _
		"188.74.83.135:19421|KeeF's Kit Mod Server"    &@CRLF& _
		"" & _; temp servers
		"82.15.31.92:31511|AoM's UK Riotz Server"      &@CRLF& _
		"73.64.19.177:31510|DrBrain's Gangbang Server" &@CRLF& _
		"82.169.45.137:31510|Fredz's server"           &@CRLF& _
		"84.87.109.134:31510|G()AT's server"           &@CRLF& _
		"84.87.109.134:31512|G()AT's test server"      &@CRLF& _
		"hypo.hambloch.com:31510|hypo_v8's server"     &@CRLF& _
		"93.41.146.9:31510|ITA KP Server"              &@CRLF& _
		"82.69.95.83:31510|Killa's Home server"

	$aTmpOffline['KPQ3'] = "" & _
		"www.kingpinq3.com:31600|KingpinQ3 DM Server"                          &@CRLF& _
		"www.kingpinq3.com:31610|KingpinQ3 CTF Server"                         &@CRLF& _
		"www.kingpinq3.com:31630|KingpinQ3 Realmode Deathmatch Server"         &@CRLF& _
		"www.kingpinq3.com:31640|KingpinQ3 One Flag CTF Server"                &@CRLF& _
		"www.kingpinq3.com:31650|KingpinQ3 Team Deathmatch Development Server" &@CRLF& _
		"www.kingpinq3.com:31660|Bagman development server"                    &@CRLF& _
		"www.kingpinq3.com:31670|KingpinQ3 Hitmen Server"                      &@CRLF& _
		"" & _ ;temp servers
		"hypo.hambloch.com:31600|KingpinQ3 hypo_v8" &@CRLF& _
		"hypo.hambloch.com:31610|KingpinQ3 hypo_v8"

	$aTmpOffline['Q2'] = "" & _
		"kp.servegame.com:27910|Luschen Quakematch"                       &@CRLF& _
		"202.169.104.136:56342|macanah-lurker.2fh.co CTF q2"              &@CRLF& _
		"202.169.104.136:27916|macanah-lurker.2fh.co q2 ActioN"           &@CRLF& _
		"202.169.104.136:27988|macanah-lurker.2fh.co q2 awaken2 assault"  &@CRLF& _
		"202.169.104.136:27933|macanah-lurker.2fh.co q2 awaken2 ctf"      &@CRLF& _
		"202.169.104.136:27934|macanah-lurker.2fh.co q2 Brazen CooP http" &@CRLF& _
		"202.169.104.136:27913|macanah-lurker.2fh.co q2 coop-gibrack-mod" &@CRLF& _
		"202.169.104.136:27915|macanah-lurker.2fh.co q2 JumP"             &@CRLF& _
		"202.169.104.136:44444|macanah-lurker.2fh.co q2 MatriX"           &@CRLF& _
		"202.169.104.136:27911|macanah-lurker.2fh.co q2 rocket arena"     &@CRLF& _
		"202.169.104.136:27990|macanah-lurker.2fh.co q2OPENTDM"

	$aTmpOffline['HEX2'] = "" & _
		"blackmarsh.hexenworld.org:26900|Hexen II DM w/ bots" &@CRLF& _
		"darkravager.ddns.net:26900|DarkRavagerH2Coop"        &@CRLF& _
		"blackmarsh.hexenworld.org:26901|"                    &@CRLF& _
		"blackmarsh.hexenworld.org:26902|"                    &@CRLF& _
		"blackmarsh.hexenworld.org:26903|"                    &@CRLF& _
		"clovr.xyz:26900|"                                    &@CRLF& _
		"romagnarines.mooo.com:26900|"                        &@CRLF& _
		"thebleeding.strangled.net:26900|"
	$aTmpOffline['HEXW'] = "" & _
		"68.83.198.53:26950|HexenWorld DM"                          &@CRLF& _
		"168.138.68.8:26956|DarkRavager Rival Kingdoms v.90 (beta)" &@CRLF& _
		"168.138.68.8:26955|DarkRavager DM Server"                  &@CRLF& _
		"68.83.198.53:26951|HexenWorld CTF"                         &@CRLF& _
		"168.138.68.8:26950|DarkRavagerSiege"                       &@CRLF& _
		"108.61.178.207:26950|de.quake.world:26950 Siege"           &@CRLF& _
		"51.195.189.61:26950|JakubM's Server"                       &@CRLF& _
		"108.61.178.207:26951|de.quake.world:26951 DM"
	$aTmpOffline['HER2'] = "" & _
		"71.84.56.38:28910|MyDedServer DM"             &@CRLF& _
		"45.235.98.10:27112|OldServers.com.ar - Coop"  &@CRLF& _
		"blackmarsh.hexenworld.org:28910|"             &@CRLF& _
		"clovr.xyz:28910|clovr - coop"                 &@CRLF& _
		"66.108.83.111:27910|"


	;$aTmpOffline[$ID_] = "" & _
	;todo ADD GAMES
	;NOTE: use actual game port. (gamespy port fixed below)

	ResetServerListArrays(BitShift(1, -($iGameIDx))) ;bit
	_GUICtrlListView_DeleteAllItems($ListViewA)
	;clear selected column. todo work out how to re-sort without mouse click
	GUICtrlSendMsg($UI_ListV_svData_A, $LVM_SETSELECTEDCOLUMN, -1, 0) ;updateLV


	;split string
	;$arrayOffline = StringSplit($aTmpOffline[$iGameIdx], @CRLF, BitOR($STR_NOCOUNT, $STR_ENTIRESPLIT))
	$arrayOffline = StringSplit($aTmpOffline[GetGameIDString($iGameIDx)], @CRLF, BitOR($STR_NOCOUNT, $STR_ENTIRESPLIT))
	if Not @error Then
		For $i = 0 To UBound($arrayOffline) -1
			if $arrayOffline[$i] <> "" then
				$tmpArray = StringSplit($arrayOffline[$i],"|", $STR_NOCOUNT)
				$sIP_Port = StringSplit($tmpArray[0],     ":", $STR_NOCOUNT)

				$sIP = TCPNameToIP($sIP_Port[0])
				If $g_gameConfig[$iGameIdx][$NET_GS_P] Then ;using gamespy protocol
					; NOTE: this could fail, if server is not compliant
					$iPort   = Number($sIP_Port[1]) + $g_gameConfig[$iGameIdx][$NET_GS_P] ;browser communication port.
					$iPortGS = Number($sIP_Port[1]) ; server port.
				else
					$iPort   = Number($sIP_Port[1])
					$iPortGS = 0
				endif

				;fill globbal server array in memory
				$g_aServerStrings[$iGameIdx][$i][$COL_NAME]   = $tmpArray[1] ; server name
				$g_aServerStrings[$iGameIdx][$i][$COL_IP]     = $sIP
				$g_aServerStrings[$iGameIdx][$i][$COL_PORT]   = $iPort
				$g_aServerStrings[$iGameIdx][$i][$COL_PING]   = 999;"999"
				$g_aServerStrings[$iGameIdx][$i][$COL_PORTGS] = $iPortGS ;set gamespy reported game port
				$svNum += 1
			EndIf
		Next
		$g_iServerCountTotal = $svNum
		FillServerListView_popData($iGameIdx, $ListViewA)
	Else
		$g_iServerCountTotal = 0
	EndIf
EndFunc ; -->offline kp list

; -->offline kp list
;========================================================
#endregion

#Region -->  BUTTON's

;--> GUI STATE enable/disble
Func EnableUIButtons($bEnable)
	;$UI_Btn_offlineList
	Local Const $list1 = [$tabGroupGames, $UI_Combo_gameSelector, $UI_Btn_refreshMaster, _
		$UI_Btn_filterEmpty, $UI_Btn_filterFull, $UI_Btn_filterOffline, _
		$UI_Btn_pingList, $UI_Btn_loadFav, $UI_Btn_settings,  $UI_Btn_offlineList] ;$UI_Btn_expand,
	Local $iState  = ($bEnable)? ($GUI_ENABLE):($GUI_DISABLE)
	Local $bActive = ($bEnable)? (False):(True)

	;set btn disabled state
	For $i = 0 to UBound($list1) - 1
		GUICtrlSetState($list1[$i], $iState)
	Next

	;disable user selection on game dropdown
	if $bEnable Then
		ControlEnable($HypoGameBrowser, "", $UI_Combo_gameSelector)
	Else
		ControlDisable($HypoGameBrowser, "", $UI_Combo_gameSelector)
		_GUICtrlComboBoxEx_ShowDropDown($UI_Combo_gameSelector, False)
	EndIf

	;set btn readonly state
	For $i = 0 to UBound($UI_ListV_mb_ABC) - 1
		_GUICtrlEdit_SetReadOnly($UI_ListV_mb_ABC[$i], $bActive)
	Next
	_GUICtrlEdit_SetReadOnly($UI_ListV_svData_A, $bActive)

	;todo check why this was needed? auto refresh?
	If $g_iTabNum = $TAB_CHAT Then
		ConsoleWrite("!!!chat tab"&@CRLF)
		SetActiveTab($TAB_CHAT)
	EndIf
EndFunc

Func BeginGettinServers()
	$g_isGettingServers = 1
	$g_iServerCountTotal_Responded = 0
	EnableUIButtons(False) ;disable dropdown
	$g_iServerCountTotal = 1 ;get # servers to use later to stop refresh
	$g_iPlayerCount_GS = 0

EndFunc; --> END REFRESH BUTTON

;========================================================
; --> FinishedGettinServers
Func FinishedGettinServers()
	$g_iServerCountTotal = 0
	$g_iServerCountTotal_Responded = 0
	$g_isGettingServers = 0 ; process WM_NOTIFY
	GUICtrlSetData($UI_Prog_getServer, 0)
	EnableUIButtons(True)
EndFunc; --> END REFRESH BUTTON
;========================================================
#EndRegion

#Region --> Fill server
Func FillServerStringArrayIP($iGameIdx, $ipArray)
	Local $sIP, $iPort, $splitIP, $iCount = UBound($ipArray) -1
	;_ArrayDisplay($ipArray)
	; fill server strings with fresh servers and as blank info
	if $iCount >= $g_iMaxSer then $iCount = $g_iMaxSer - 1

	For $i = 0 To $iCount
		$splitIP = StringSplit($ipArray[$i],":", $STR_NOCOUNT)
		If @error Then
			ConsoleWrite("!error invalid ip from master" & @CRLF)
			$sIP = $ipArray[$i]
			$iPort = 0
		Else
			$sIP = $splitIP[0]
			$iPort = Number($splitIP[1])
		EndIf

		;ConsoleWrite("port:"&$iPort&@CRLF)
		;ConsoleWrite("g:"&$iGameIdx& " i:"&$i& " c:"&$COL_IP&" ip:"&$sIP& " port:"&$iPort&@CRLF)
		$g_aServerStrings[$iGameIdx][$i][$COL_IP]   = $sIP
		$g_aServerStrings[$iGameIdx][$i][$COL_PORT] = $iPort ; browser communication port
		$g_aServerStrings[$iGameIdx][$i][$COL_PING] = 999;"999"
		if $g_gameConfig[$iGameIdx][$NET_GS_P] then
			;guess gameport for gamespy protocol. updated with serverinfo later
			$g_aServerStrings[$iGameIdx][$i][$COL_PORTGS] = $iPort -$g_gameConfig[$iGameIdx][$NET_GS_P]
			$g_aServerStrings[$iGameIdx][$i][$COL_NAME]   = StringFormat("%s:%i", $sIP, $g_aServerStrings[$iGameIdx][$i][$COL_PORTGS])
		Else
			$g_aServerStrings[$iGameIdx][$i][$COL_NAME]   = StringFormat("%s:%i", $sIP, $iPort) ;$sIP&":"&$iPort
		EndIf
	Next
EndFunc

Func FillServerStringArrayPing($iGameIdx, $sData, $iCount)
	For $i = 0 to $iCount -1
		$g_aServerStrings[$iGameIdx][$i][$COL_PING] = $sData
	Next
EndFunc

Func FillServerListView_popData($iGameIDx, $ListViewA, $bFilter = False)
	Local $sName, $sIP_Port, $sPing, $sPCount, $portIdx, $idx = 0
	;Local $ListViewA = getListView_A_CID()
	Local $bOffline = _IsChecked($UI_Btn_filterOffline)
	Local $bEmpty = _IsChecked($UI_Btn_filterEmpty)
	Local $bFull = _IsChecked($UI_Btn_filterFull)

	if $g_gameConfig[$iGameIdx][$NET_GS_P] then
		$portIdx = $COL_PORTGS
	else
		$portIdx = $COL_PORT
	endif

	_GUICtrlListView_BeginUpdate($ListViewA)
	_GUICtrlListView_DeleteAllItems($ListViewA)
	ConsoleWrite("popData gameID:"&$iGameIDx&@CRLF)

	For $i = 0 To $g_iMaxSer -1
		If $g_aServerStrings[$iGameIDx][$i][$COL_PING] > 0 Then ;ping. must be valid
			If $bFilter Then
				;ConsoleWrite("ping:"&$g_aServerStrings[$iGameIDx][$i][$COL_PING]&@CRLF)
				If $bOffline And ($g_aServerStrings[$iGameIDx][$i][$COL_PING] = 999) Then ContinueLoop
				;If $bEmpty And $g_aServerStrings[$iGameIDx][$i][$COL_PLAYERS] Then ContinueLoop
				;If $bFull And  Then ContinueLoop
				$g_aServerStrings[$iGameIdx][$i][$COL_IDX] = $idx ;update list index if filtered
			EndIf
			$sName = $g_aServerStrings[$iGameIDx][$i][$COL_NAME]
			$sIP_Port = StringFormat("%s:%i", $g_aServerStrings[$iGameIDx][$i][$COL_IP], $g_aServerStrings[$iGameIDx][$i][$portIdx])
			$sPing = StringFormat("%i", $g_aServerStrings[$iGameIDx][$i][$COL_PING]) ;int
			$sPCount = $g_aServerStrings[$iGameIDx][$i][$COL_PLAYERS]
			;fill listview
			;GUICtrlCreateListViewItem($i &'|'&$sIP_Port &'|'&$sName &'|'&$sPing&'|'&$sPCount, $ListViewA) ; not used as name may have "|"
			_GUICtrlListView_AddItem($ListViewA,    $i,              -1, $g_listID_offset+$i) ;offset ID.
			_GUICtrlListView_AddSubItem($ListViewA, $idx, $sIP_Port, 1,-1)
			_GUICtrlListView_AddSubItem($ListViewA, $idx, $sName,    2,-1)
			_GUICtrlListView_AddSubItem($ListViewA, $idx, $sPing,    3,-1)
			_GUICtrlListView_AddSubItem($ListViewA, $idx, $sPCount,  4,-1)
			; Set icon
			_GUICtrlListView_SetItemImage($ListViewA, $idx, -1)
			$idx +=1
		Else
			ConsoleWrite("update:"& $i &@CRLF)
			ExitLoop
		EndIf
	Next
	_GUICtrlListView_EndUpdate($ListViewA)
EndFunc

Func FillListView_A_Filtered($iGameIdx, $ListViewA, $bForce)
	Local $bOffline = _IsChecked($UI_Btn_filterOffline)
	Local $bEmpty = _IsChecked($UI_Btn_filterEmpty)
	Local $bFull = _IsChecked($UI_Btn_filterFull)

	;~ If Not $bForce And Not $bOffline And $g_gameConfig[$iGameIdx][$NET_C2M] = $C2S_Q3 Then
	;~ 	Return ;q3 master supports filters
	;~ EndIf

	;if $bForce Or $bOffline Or $bEmpty Or $bFull Then
	Local $sName, $sIP_Port, $sPing, $sPCount, $idx = 0, $playerCount, $playerMax
	local $portIdx = ($g_gameConfig[$iGameIdx][$NET_GS_P])? ($COL_PORTGS):($COL_PORT)

	_GUICtrlListView_BeginUpdate($ListViewA)
	_GUICtrlListView_DeleteAllItems($ListViewA)

	For $i = 0 To $g_iMaxSer -1
		;ConsoleWrite("ping:"&$g_aServerStrings[$iGameIDx][$i][$COL_PING]&@CRLF)
		If $g_aServerStrings[$iGameIDx][$i][$COL_PING] > 0 Then ;ping. must be valid
			;todo player counts include bots?
			$playerCount  = InfoStr_GetPlayerCount($g_aServerStrings[$iGameIdx][$i][$COL_INFOSTR], $g_aServerStrings[$iGameIdx][$i][$COL_INFOPLYR], $iGameIdx)
			$playerMax    = InfoStr_GetPlayerMax($g_aServerStrings[$iGameIdx][$i][$COL_INFOSTR])

			If $bOffline And ($g_aServerStrings[$iGameIDx][$i][$COL_PING] = 999) Then ContinueLoop
			If $bEmpty And $playerCount = 0 Then ContinueLoop
			If $bFull And $playerCount And $playerMax And $playerCount = $playerMax Then ContinueLoop
			;ConsoleWrite('pCount:'&$playerCount&@CRLF)
			;ConsoleWrite('-pData:'&$g_aServerStrings[$iGameIdx][$i][$COL_INFOPLYR]&@CRLF)

			$g_aServerStrings[$iGameIdx][$i][$COL_IDX] = $idx ;update list index if filtered
			$sIP_Port = StringFormat("%s:%i", $g_aServerStrings[$iGameIDx][$i][$COL_IP], $g_aServerStrings[$iGameIDx][$i][$portIdx])

			;fill listview
			_GUICtrlListView_AddItem($ListViewA,    $i,                -1, $g_listID_offset+$i) ;offset ID.
			_GUICtrlListView_AddSubItem($ListViewA, $idx, $sIP_Port, 1,-1)
			_GUICtrlListView_SetItemImage($ListViewA, $idx,            -1); Set icon

			FillServerListView_SV_Responce( _
				$iGameIdx, _
				$g_aServerStrings[$iGameIdx][$i][$COL_IP], _
				$g_aServerStrings[$iGameIdx][$i][$COL_PORT], _ ;
				$g_aServerStrings[$iGameIdx][$i][$COL_PORTGS], _ ;
				$g_aServerStrings[$iGameIdx][$i][$COL_NAME], _ ;
				$g_aServerStrings[$iGameIdx][$i][$COL_PING], _ ;
				$g_aServerStrings[$iGameIdx][$i][$COL_PLAYERS], _ ;
				$g_aServerStrings[$iGameIdx][$i][$COL_INFOSTR], _  ;data
				$g_aServerStrings[$iGameIdx][$i][$COL_INFOPLYR], _ ;player data
				$g_aServerStrings[$iGameIdx][$i][$COL_MAP], _
				$g_aServerStrings[$iGameIdx][$i][$COL_MOD], _
				$g_aServerStrings[$iGameIdx][$i][$COL_IDX])        ;sorted index
			$idx += 1
		Else
			ConsoleWrite("update:"& $i &@CRLF)
			ExitLoop
		EndIf
	Next
	_GUICtrlListView_EndUpdate($ListViewA)

EndFunc

Func CleanupServerName(ByRef $serverName, $iGameIdx)
	;cleanup server names, eg Quake3 uses ^2 for colored text
	Switch $g_gameConfig[$iGameIdx][$SV_CLEAN]
		Case $CLEAN_SOF1
			$serverName = StringRegExpReplace($serverName, "[^ -ÿ]+" ,"") ;remove < asc(32)
		Case $CLEAN_Q3 ; $ID_KPQ3, $ID_UNVAN, $ID_WARSOW, $ID_ALIENA, $ID_JK2, $ID_JK3, $ID_SOF2, $ID_STEF1
			$serverName = StringRegExpReplace($serverName, "\^." ,"") ;remove ^x
		;Case Else
		;todo ADD GAMES
	EndSwitch
EndFunc

;--> FILL ARRAY1
;========================================================
Func FillServerListView_SV_Responce($iGameIdx, ByRef $sIP, ByRef $sPort, ByRef $sPortGS, ByRef $svName, _
		ByRef $ping, ByRef $iPCount, ByRef $aSvData, ByRef $sPData, ByRef $map, ByRef $mod, $iListIndex)
	#forceref $sPort
	Local $ListViewA    = getListView_A_CID()
	Local $serverName   = InfoStr_GetServerName($aSvData)
	Local $playerCount  = InfoStr_GetPlayerCount($aSvData, $sPData, $iGameIdx)
	Local $playerMax    = InfoStr_GetPlayerMax($aSvData)
	Local $mapName      = InfoStr_GetMapName($aSvData)
	Local $modName      = InfoStr_GetModName($aSvData)
	Local $portGS       = InfoStr_GetGamePort($aSvData)
	Local $playerCnt    = String($playerCount &"/"& $playerMax)
	Local $playerIcon   = IconPlayerX($playerCount, $playerMax)
	Local $pingIcon     = IconPingX($ping)

	$g_iPlayerCount_GS += Number($playerCount)
	if $serverName <> "" Then
		CleanupServerName($serverName, $iGameIdx)
	ElseIf $serverName = "" Then
		$serverName = $svName ;invalid string(offline loaded?)
	EndIf

	; <-- return data
	$iPCount = $playerCount
	$svName = $serverName
	$map = $mapName
	$mod = $modName

	;update gameport from server string
	if $g_gameConfig[$iGameIdx][$NET_GS_P] And $portGS <> ""  then
		$sPortGS = Number($portGS) ;set gamespy reported game port
		Local $ip = string($sIP &":"& $sPortGS)
		_GUICtrlListView_SetItem($ListViewA, $ip, $iListIndex,		1,	-1)
	EndIf
	_GUICtrlListView_SetItem($ListViewA, $serverName, $iListIndex,  2,  -1)          ;server
	_GUICtrlListView_SetItem($ListViewA, $ping,       $iListIndex,  3,  $pingIcon)   ;ping
	_GUICtrlListView_SetItem($ListViewA, $playerCnt,  $iListIndex,  4,  $playerIcon) ;players
	_GUICtrlListView_SetItem($ListViewA, $mapName,    $iListIndex,  5,  -1)          ;map
	_GUICtrlListView_SetItem($ListViewA, $modName,    $iListIndex,  6,  -1)          ;mod
EndFunc ; --> FillServerListView_SV_Responce
;========================================================
;--> END FILL ARRAY1

Func parsePlayerString($sData, ByRef $name, ByRef $frags, ByRef $ping)
	Local $sTmp = StringStripWS($sData, $STR_STRIPLEADING + $STR_STRIPTRAILING)
	If $sTmp <> "" Then ;catch end line @LF, EOT
		Local $playerName = _StringBetween($sTmp, '"', '"' ) ;get player name[0]
		If @error Then Return False
		Local $aPDetails = StringSplit($sTmp, " ") ;setup server strings
		if @error Or $aPDetails[0] < 2 Then Return False
		$name  = $playerName[0]
		$frags = $aPDetails[1]
		$ping  = $aPDetails[2]
		Return True
	EndIf
	Return False
EndFunc

Func FillListView_B(ByRef $sPlayers, $ListViewB, $iGameIdx)
	;ConsoleWrite("-players:" &$sPlayers&@CRLF)
	If $sPlayers <> "" Then
		;_ArrayDisplay($sPlayers)
		_GUICtrlListView_BeginUpdate($ListViewB)
		;-------; add players info, max 31 char for player name
		if $g_gameConfig[$iGameIdx][$NET_GS_P] _ ;$iGameIdx = $ID_Q1 Or $iGameIdx = $ID_HEX
		Or ($g_gameConfig[$iGameIdx][$NET_S2C] = $S2C_HEX2) _
		Or ($g_gameConfig[$iGameIdx][$NET_S2C] = $S2C_Q1) Then ;hexen/q1 decompressed
		;todo ADD GAMES
			local const $aKey = ['player', 'frags', 'ping', 'deaths', 'team']

			;If StringInStr($serverVars, "player_0") Then
			Local $sInfo[5], $aPData
			$aPData = StringSplit($sPlayers, "\", $STR_NOCOUNT)
			if not @error Then
				For $pIdx = 0 to $MAX_PLAYERS - 1
					$sInfo[0] = parseInfoString($aPData, StringFormat("%s_%i", $aKey[0], $pIdx)) ;name
					if $sInfo[0] <> "" Then
						$sInfo[1] = parseInfoString($aPData, StringFormat("%s_%i", $aKey[1], $pIdx)) ;frags
						$sInfo[2] = parseInfoString($aPData, StringFormat("%s_%i", $aKey[2], $pIdx)) ;ping
						$sInfo[3] = parseInfoString($aPData, StringFormat("%s_%i", $aKey[3], $pIdx)) ;deaths
						$sInfo[4] = parseInfoString($aPData, StringFormat("%s_%i", $aKey[4], $pIdx)) ;team
					Else
						if $pIdx > 0 Then
							ExitLoop ;no players found
						Else
							ContinueLoop ; sof/MOHAA users player_1
						EndIf
					EndIf

					;Opt("GUIDataSeparatorChar","\")
					;GUICtrlCreateListViewItem($sInfo[0], $ListViewB) ;hypo spliting string if name has "|" in it
					_GUICtrlListView_AddItem($ListViewB,           $sInfo[0],    -1, 0)  ;Name
					_GUICtrlListView_AddSubItem($ListViewB, $pIdx, $sInfo[1] ,1, -1) ;Frags
					_GUICtrlListView_AddSubItem($ListViewB, $pIdx, $sInfo[2] ,2, -1) ;Ping
					_GUICtrlListView_AddSubItem($ListViewB, $pIdx, $sInfo[3] ,3, -1) ;deaths
					_GUICtrlListView_AddSubItem($ListViewB, $pIdx, $sInfo[4] ,4, -1) ;team
				Next
			EndIf
		Else ;kpq3 and q2. game port. uses seperate line for players
			Local $aTmp = StringSplit($sPlayers, Chr(10)) ;@lf
			;If Not ($tmpstr[2] ="") Then
			Local $name, $frags, $ping, $iPIdx = 0

			For $i = 1 To $aTmp[0]
				if parsePlayerString($aTmp[$i], $name, $frags, $ping) Then
					;GUICtrlCreateListViewItem($playerName[0], $ListViewB) ; not used as name may have "|"
					_GUICtrlListView_AddItem($ListViewB,            $name, -1,  0) ;Name
					_GUICtrlListView_AddSubItem($ListViewB, $iPIdx, $frags ,1, -1) ;Frags
					_GUICtrlListView_AddSubItem($ListViewB, $iPIdx, $ping  ,2, -1) ;Ping
					$iPIdx += 1 ;increase 1
				EndIf
			Next
			;EndIf
		EndIf
		_GUICtrlListView_EndUpdate($ListViewB)
	EndIf
EndFunc

Func FillListView_C(ByRef $serStrArray, $ListViewC)
	;update server varables in listview
	If IsArray($serStrArray) Then
		_GUICtrlListView_BeginUpdate($ListViewC)
		Local $iLen = UBound($serStrArray) -2
		Local $idx = 0
		For $i = 0 To $iLen Step 2
			;todo cleanup string before it gets here..
			If StringCompare($serStrArray[$i], "player_0") = 0 Then ExitLoop ;should not happen
			If StringCompare($serStrArray[$i], "final") = 0 Then ExitLoop ;todo check this
			If StringCompare($serStrArray[$i], "queryid") = 0 Then ExitLoop ;todo check this
			If StringInStr($serStrArray[$i], @LF) Then ExitLoop ;should not happen

			;used because string can contain "|"
			_GUICtrlListView_AddItem($ListViewC,          $serStrArray[$i],      -1, 0) ;rules
			_GUICtrlListView_AddSubItem($ListViewC, $idx, $serStrArray[$i+1], 1, -1)    ;value
			$idx +=1
		Next
		_GUICtrlListView_EndUpdate($ListViewC)
	EndIf

	if $g_ilastColumn_C > -1 Then
		;local $iCol = GUICtrlGetState($ListViewC)
		$g_vSortSense_C[0] = false
		$g_vSortSense_C[1] = false
		_GUICtrlListView_SimpleSort($ListViewC, $g_vSortSense_C, $g_ilastColumn_C, True) ;resort to user pref
	EndIf

EndFunc

;--> FILL ARRAY 2&3 STRINGS
;========================================================
; --> FillListView_BC_Selected
Func FillListView_BC_Selected($iGameIdx, $iListNum)
	Local $serSelNum
	Local $ListViewA = getListView_A_CID()
	Local $ListViewB = getListView_B_CID()
	Local $ListViewC = getListView_C_CID()

	If $iListNum = -1 Or $iGameIdx >= $COUNT_GAME Then
		ConsoleWrite("nothing selected" &@CRLF)
		Return
	EndIf

	;$serSelNum = GetServerListA_SelectedData()
	$serSelNum = Number(_GUICtrlListView_GetItemText($ListViewA, $iListNum, 0))

	;delet b4 it gets a chance to exit
	_GUICtrlListView_DeleteAllItems($ListViewB)
	_GUICtrlListView_DeleteAllItems($ListViewC)

	;$g_iLastSort_C[$iGameIdx] = GUICtrlGetState($ListViewC); set global sort for reset

	ConsoleWrite("ListNum= '"  &$iListNum&"'  ServerNum= '" &$serSelNum&"'"& @CRLF)
	FillListView_C($g_aServerStrings[$iGameIdx][$serSelNum][$COL_INFOSTR], $ListViewC)

	;deal with quake1 type server data
	Select
		Case ($g_gameConfig[$iGameIdx][$NET_S2C] = $S2C_HEX2) Or ($g_gameConfig[$iGameIdx][$NET_S2C] = $S2C_Q1) ; $ID_Q1, $ID_HEX ;todo q1?
			HEXGetPlayerInfo( _
				$g_aServerStrings[$iGameIdx][$serSelNum][$COL_IP], _
				$g_aServerStrings[$iGameIdx][$serSelNum][$COL_PORT], _
				$g_aServerStrings[$iGameIdx][$serSelNum][$COL_INFOSTR], _
				$g_aServerStrings[$iGameIdx][$serSelNum][$COL_INFOPLYR])
		;Case ;$iGameIdx $ID_JK3

		;todo ADD GAMES
	EndSelect

	FillListView_B($g_aServerStrings[$iGameIdx][$serSelNum][$COL_INFOPLYR], $ListViewB, $iGameIdx)

EndFunc; --> FillListView_BC_Selected
;========================================================
;--> FILL ARRAY 2&3 STRINGS


Func MSG_ReadByte(ByRef $aData, ByRef $i, $iMax)
	local $iRet = 0
	if $i < $iMax Then
		$iRet = $aData[$i]
		$i += 1
	EndIf
	Return $iRet
EndFunc

Func MSG_ReadLong(ByRef $aData, ByRef $i, $iMax, $littleEnd = False)
	Local $iRet = 0
	if ($i + 4) < $iMax Then
		if $littleEnd Then
			$iRet = BitShift($aData[$i+0], -24) + BitShift($aData[$i+1], -16) + BitShift($aData[$i+2], -8) + BitShift($aData[$i+3], 0)
		Else
			$iRet = BitShift($aData[$i+0], 0) + BitShift($aData[$i+1], -8) + BitShift($aData[$i+2], -16) + BitShift($aData[$i+3], -24)
		EndIf
		$i += 4
		return $iRet
	EndIf
	return $iRet
EndFunc

Func MSG_ReadString(byref $aASC, ByRef $i, $iMax)
	Local $sRet = ""
	while $i < $iMax
		if $aASC[$i] = 0 then
			$i += 1
			ExitLoop
		EndIf
		$sRet &= Chr($aASC[$i])
		$i += 1
	WEnd
	Return StringReplace($sRet, "\", "/") ;fix invalid char...
EndFunc

Func MSG_ReadShort(ByRef $aData, ByRef $i, $iMax, $littleEnd = False)
	Local $iRet = 0
	if ($i + 2) < $iMax Then
		If $littleEnd then
			$iRet = BitShift($aData[$i+0], -8) + BitShift($aData[$i+1], 0)
		else
			$iRet = BitShift($aData[$i+0], 0) + BitShift($aData[$i+1], -8)
		EndIf
		$i += 2
		return $iRet
	EndIf
	return $iRet
EndFunc

Func HEXProcessPlayerResponce($data)
	;local const $hex2_CCREP_SERVER_INFO = 131 ;0x83
	local const $hex2_CCREP_PLAYER_INFO = 132 ;0x84
	local const $hex2_NETFLAG_CTL = 0x80000000 ; 32768
	;ConsoleWrite("-data:"& StringToBinary($data, 1)&@CRLF)
	Local $i = 0, $pIdx, $name, $teamColor, $frags, $time, $address;, $header, $iMsgType
	local $aASC = StringToASCIIArray($data, 0, Default, $SE_ANSI)
	local $iLen = UBound($aASC)

	If not IsArray($aASC) or $iLen < 4 Then return ""
	if not (BitAND(MSG_ReadLong($aASC, $i, $iLen, True), 0xffff0000) = $hex2_NETFLAG_CTL) Then return ""
	if not (MSG_ReadByte($aASC, $i, $iLen) = $hex2_CCREP_PLAYER_INFO) Then return ""

	$pIdx      = MSG_ReadByte($aASC, $i, $iLen)
	$name      = MSG_ReadString($aASC, $i, $iLen) ;name
	$teamColor = MSG_ReadLong($aASC, $i, $iLen)   ;color
	$frags     = MSG_ReadLong($aASC, $i, $iLen)   ;frags
	$time      = MSG_ReadLong($aASC, $i, $iLen)   ;time
	$address   = MSG_ReadString($aASC, $i, $iLen) ;address

	Return StringFormat( "player_%i\\%s\\frags_%i\\%i\\ping_%i\\id:%s\\deaths_%i\\time:%i\\team_%i\\color:%i\\", _
		$pIdx, $name, _     ;name
		$pIdx, $frags, _    ;frags
		$pIdx, $address, _  ;ping
		$pIdx, $time, _     ;deaths
		$pIdx, $teamColor _ ;team
	)
EndFunc

Func HEXGetPlayerInfo(ByRef $sIPAddress, ByRef $iPort, ByRef $aData, ByRef $aPlayerData)
	local $iCount = 0, $dataRecv, $iPlyrCount, $hSocket

	if $aPlayerData <> "" then return ;$COL_INFOPLYR
	$iPlyrCount = Number(parseInfoString($aData, "numplayers"));check info string first
	if $iPlyrCount = 0 Then return
	;ConsoleWrite("+ping server for players"&@CRLF)

	_BIND_UDP_SOCKET($hSocket)
	If $hSocket > 0 Then
		_UDP_setBuffSize($hSocket, 512, 512) ; 25600

		for $i = 0 to $iPlyrCount-1
			_UDPSendTo($sIPAddress, $iPort, BinaryToString('0x80000007'&'03'&hex($i, 2)&"00"), $hSocket)
		Next

		Local $iTimeOut = TimerInit()
		While 1 ;loop until all players recieved or timout hit
			While 1
				$dataRecv = _UDPRecvFrom($hSocket, 512, 0)
				if IsArray($dataRecv) Then
					ExitLoop(1)
				ElseIf TimerDiff($iTimeOut) > 990 Then
					ConsoleWrite(">TIMEOUT.. 1 seconds"&@CRLF)
					ExitLoop(2) ;stop do and stop while
				EndIf
				Sleep(20)
			WEnd

			ConsoleWrite(StringFormat("Rec Player: %s\n", StringStripWS($dataRecv[$PACKET_DATA], 7)) &@CRLF)
			$aPlayerData &= HEXProcessPlayerResponce($dataRecv[$PACKET_DATA])
			$iCount += 1

			if $iCount >= $iPlyrCount Then
				ExitLoop(1)
			EndIf
		WEnd
	Else
		ConsoleWrite("Error: Cant get port")
		Return False
	EndIf
	_UDPCloseSocket($hSocket)
EndFunc


#EndRegion



#Region --> EVENT MOUSE, WM_NOTIFY

Func RighttClickMenuKP()
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
		Case $ContextKP_CopyIP
			CopyIPToClip()
		Case $ContexKP_AddFav
			FavArrayAdd()
		Case $ContexKP_RemFav
			FavArrayRemove()
	EndSwitch
	_GUICtrlMenu_DestroyMenu($hMenu)
EndFunc

Func RighttClickMenuM()
	Local $hMenuMBr = _GUICtrlMenu_CreatePopup()

	_GUICtrlMenu_AddMenuItem($hMenuMBr, "M-Refresh", $ContexKP_RefreshM)
	_GUICtrlMenu_AddMenuItem($hMenuMBr, "", 0)
	_GUICtrlMenu_AddMenuItem($hMenuMBr, "M-Connect", $ContextKP_ConnectM)
	_GUICtrlMenu_AddMenuItem($hMenuMBr, "", 0)
	_GUICtrlMenu_AddMenuItem($hMenuMBr, "M-Copy IP", $ContextKP_CopyIP)
	_GUICtrlMenu_AddMenuItem($hMenuMBr, "", 0)
	_GUICtrlMenu_AddMenuItem($hMenuMBr, "M-Add Fav", $ContexKP_AddFavM)
	;_GUICtrlMenu_AddMenuItem($hMenuMBr, "M-Remove Fav", $ContexKP_RemFavM) ;disabled
	_GUICtrlMenu_AddMenuItem($hMenuMBr, "", 0)
	_GUICtrlMenu_AddMenuItem($hMenuMBr, "M-Get Server Info", $ContexKP_GetInfoM)
	Switch _GUICtrlMenu_TrackPopupMenu($hMenuMBr, $HypoGameBrowser, -1, -1, 1, 1, 2)
		Case $ContexKP_RefreshM
			MRefresh()
		Case $ContextKP_ConnectM
			Start_Kingpin()
		Case $ContextKP_CopyIP
			CopyIPToClip()
		Case $ContexKP_AddFavM
			FavArrayAdd()
		;Case $ContexKP_RemFavM
		;	FavArrayRemove()
		Case $ContexKP_GetInfoM
			M_GetServerDetailsPopup()
	EndSwitch
	_GUICtrlMenu_DestroyMenu($hMenuMBr)

EndFunc


GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
Func WM_COMMAND($hWnd, $iMsg, $wParam, $lParam)
    #forceref $hWnd, $iMsg
	;local static $hListBox = GUICtrlGetHandle($UI_Combo_gameSelector)
    Local $hWndFrom, $iCode, $hWndListBox

	If Not IsHWnd($UI_Combo_gameSelector) Then $hWndListBox = GUICtrlGetHandle($UI_Combo_gameSelector)
    $hWndFrom = $lParam
    ;$iIDFrom = BitAND($wParam, 0xFFFF) ; Low Word
    $iCode = BitShift($wParam, 16) ; Hi Word
    Switch $hWndFrom
        Case $UI_Combo_gameSelector, $hWndListBox
            Switch $iCode
                Case $LBN_SELCHANGE ; changed
					UI_Combo_gameSelectorChange()
                    ;ConsoleWrite("!ch"&@CRLF)
            EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND

GUIRegisterMsg($WM_EXITSIZEMOVE, "WM_NOTIFY")
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
;GUIRegisterMsg($WM_COMMAND, "WM_NOTIFY")
Func WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
	Local $iIDFrom, $iCode, $tNMHDR, $tInfo
	#forceref $wParam

	If ($hWnd = $HypoGameBrowser) Then
		Switch $iMsg
			Case $WM_EXITSIZEMOVE
				;ConsoleWrite("$WM_EXITSIZEMOVE"&@CRLF)
				$g_bGuiResized = True
				$g_bWasMaximized = False
				;Return 0 ;$GUI_RUNDEFMSG ;todo

			Case $WM_NOTIFY
				If $g_isGettingServers = 0 Then
					$tNMHDR =  DllStructCreate($tagNMHDR, $lParam)
					$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
					$iCode =   DllStructGetData($tNMHDR, "Code")

					;===================
					;check listview ID's
					;For $i=0 to $COUNT_GAME-1
						If $UI_ListV_svData_A = $iIDFrom Then
							Switch $iCode
								Case $NM_RCLICK, $NM_RDBLCLK 	;mouse2 $NM_DBLCLK
									$g_iListview_changed = 999
									$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam) ;$tagNMLISTVIEW
									If DllStructGetData($tInfo, "Index") > -1 Then
										$bEventRightClick = 1
									EndIf
								Case $NM_CLICK	;mouse1/arrow
									$g_iListview_changed = 999
								Case $LVN_KEYDOWN ;mouse1/arrow //$LVN_ITEMCHANGED
									$tInfo = DllStructCreate($tagNMLVKEYDOWN, $lParam)
									$g_iListview_changed = DllStructGetData($tInfo, "Flags") ;2621440=down arrow 2490368=up arrow
								Case $NM_DBLCLK, -114
									$bEventStartKingpin = 1
							EndSwitch
							;if not ($i = $g_iTabNum) Then ConsoleWrite("!Tab and list dont match i:"&$i&" t:"&$g_iTabNum&@CRLF)
							;Return 0 ;$GUI_RUNDEFMSG
						EndIf
					;Next
					;=================
					; check M ID's
					For $i=0 to 2
						If $UI_ListV_mb_ABC[$i] = $iIDFrom Then
							Switch $iCode
								Case $NM_RCLICK
									$iMGameType = $i
									$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam) ;$tagNMLISTVIEW
									If DllStructGetData($tInfo, "Index") > -1 Then
										$bEventRightClickM = 1
									EndIf
								Case $NM_CLICK
									$iMGameType = $i
								;~ Case $NM_RETURN
								;~ 	$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
								Case $NM_DBLCLK, -114
									$iMGameType = $i
									$bEventStartKingpin = 1
							EndSwitch
							;Return 0 ;$GUI_RUNDEFMSG
						EndIf
					Next
					;=================
					; check other ID's
					Switch $iIDFrom
						Case $HypoGameBrowser
							ConsoleWrite("hypobrowser"&@CRLF)
							;Return 0; $GUI_RUNDEFMSG
					EndSwitch
				EndIf ; end if getting servers
			;end case $WM_NOTIFY
		EndSwitch
		;Return $GUI_RUNDEFMSG
	EndIf
	Return $GUI_RUNDEFMSG
	;ConsoleWrite("!WM_NOTIFY: not self"&@CRLF)
EndFunc   ;==>WM_NOTIFY

Func FavArrayRemove()
	SetSelectedGameID()
	Local $iGameIdx = $g_iCurGameID ; GetActiveGameIndex()
	Local $listIdx = GetServerListA_SelectedData($LV_A_IDX)
	Local $ipPort = GetServerListA_SelectedData($LV_A_IP)

	If $ipPort = "" Then
		Return
	EndIf

	;fav is stored using -10 port for kingpin
	if $g_gameConfig[$iGameIdx][$NET_GS_P] then
		$ipPort = String($g_aServerStrings[$iGameIdx][$listIdx][$COL_IP] &":"& _
		                 $g_aServerStrings[$iGameIdx][$listIdx][$COL_PORT])
	EndIf

	Local $aTmp = StringSplit($g_aFavList[$iGameIdx], "|")
	Local $iFoundIdx = 0

	;_ArrayDisplay($aTmp)
	For $i = 1 to $aTmp[0]
		If StringCompare($ipPort, $aTmp[$i]) = 0 Then
			$iFoundIdx = $i
			ExitLoop
		EndIf
	Next

	If $iFoundIdx Then
		$g_aFavList[$iGameIdx] = ""
		For $i = 1 to $aTmp[0]
			If $i = $iFoundIdx Then ContinueLoop
			$g_aFavList[$iGameIdx] &= $aTmp[$i] & "|"
		Next
		If $g_aFavList[$iGameIdx] <> "" Then $g_aFavList[$iGameIdx] = StringTrimRight($g_aFavList[$iGameIdx], 1)
	EndIf
	ConsoleWrite("fav:"&$g_aFavList[$iGameIdx]&@CRLF)
EndFunc

Func FavArrayAdd()
	SetSelectedGameID()
	Local $iGameIdx = $g_iCurGameID ;GetActiveGameIndex()
	Local $listIdx = GetServerListA_SelectedData($LV_A_IDX)
	Local $ipPort = GetServerListA_SelectedData($LV_A_IP)
	Local $i, $sTmp
	If $ipPort = "" Then
		ConsoleWrite("fav selection error"&@CRLF)
		Return ;wont be needed?
	EndIf

	;fav is stored using -10 port for kingpin/gamespy (server querry port)
	Switch $g_iTabNum
		Case $TAB_GB
			if $g_gameConfig[$iGameIdx][$NET_GS_P] then ;-10
				$ipPort = String( _
					$g_aServerStrings[$iGameIdx][$listIdx][$COL_IP] &":"& _
					$g_aServerStrings[$iGameIdx][$listIdx][$COL_PORT])
			EndIf
		Case $TAB_MB
			If $iMGameType = 0 Then
				$sTmp = StringSplit($ipPort, ":")
				If Not @error Then
					$ipPort = StringFormat("%s:%i", $sTmp[1], Number($sTmp[2]) -10); subtract -10 for gamespy
				EndIf
			EndIf
	EndSwitch


	;_ArrayDisplay($g_aFavList)
	Local $aTmp = StringSplit($g_aFavList[$iGameIdx], "|")
	For $i = 1 to $aTmp[0]
		;ConsoleWrite(">"&$aTmp[$i]&@CRLF)
		If StringCompare($ipPort, $aTmp[$i]) = 0 Then
			ConsoleWrite("existing fav"&@CRLF)
			Return ;existing
		EndIf
	Next

	;append new fav to list
	if $g_aFavList[$iGameIdx] <> "" Then
		$g_aFavList[$iGameIdx] &= "|" & $ipPort
	Else
		$g_aFavList[$iGameIdx] = $ipPort
	EndIf
EndFunc

Func CopyIPToClip()
	;compatable with both GB/MB
	SetSelectedGameID()
	Local $string = GetServerListA_SelectedData($LV_A_IP)
	If $string <> "" Then
		ClipPut($string)
	EndIf
EndFunc

#EndRegion --> END RIGHT CLICK EVENT

#Region --> EVENTS GUI
;========================================================
; --> EVENTS

;--> BUTTON PING LIST  ( also used in SERVER/OFFLINE LIST)
;refresh server in listview. dont talk to master
GUICtrlSetOnEvent($UI_Btn_pingList, "UI_Btn_pingListClicked")
	Func UI_Btn_pingListClicked() ;allready in listview from master/offline
		SetSelectedGameID()
		BeginGettinServers()
		ListviewStoreIndexToArray($g_iCurGameID, True)
		RefreshServersInListview($g_iCurGameID, True)
		FinishedGettinServers()
	EndFunc

;allready in listview from master/offline
Func RefreshServersInListview($iGameIdx, $isPing = False)
	Local $i, $sIP, $iPort, $aIPArray, $aServerIdx
	Local $sTmp = "", $sTmpIdx = "", $isFiltered = False
	Local $ListViewA = getListView_A_CID()

	;Local $iServerCount = GetServerCountInArray($iGameIdx)

	If $g_iTabNum = $TAB_MB then ; ID_M Then
		MRefresh() ;refresh mbrowser
		Return
	EndIf

	$g_iPlayerCount_GS = 0
	$g_iServerCountTotal = 0 ;get # servers to use later to stop refresh

	If $isPing And (_IsChecked($UI_Btn_filterEmpty) Or _IsChecked($UI_Btn_filterFull) Or _IsChecked($UI_Btn_filterOffline)) Then
		Local $idx, $itemCount = _GUICtrlListView_GetItemCount($ListViewA)
		$isFiltered = True
		ConsoleWrite('-count'&$itemCount&@CRLF)

		For $i = 0 To $itemCount -1
			$idx = Number(_GUICtrlListView_GetItemText($ListViewA, $i, 0))
			ConsoleWrite("----id:"&$idx &@CRLF)
			$sIP = $g_aServerStrings[$iGameIdx][$idx][$COL_IP]
			$iPort = $g_aServerStrings[$iGameIdx][$idx][$COL_PORT] ;gsPort
			$g_aServerStrings[$iGameIdx][$idx][$COL_IDX] = $i
			$sTmp &= String($sIP & ":" & $iPort) &"|"
			$sTmpIdx &= String($idx) &"|"
			$g_iServerCountTotal += 1
		Next
	Else
		For $i = 0 To $g_iMaxSer -1
			If $g_aServerStrings[$iGameIdx][$i][$COL_PING] > 0 Then
				$sIP = $g_aServerStrings[$iGameIdx][$i][$COL_IP]
				$iPort = $g_aServerStrings[$iGameIdx][$i][$COL_PORT] ;gsPort
				$sTmp &= String($sIP & ":" & $iPort) &"|"
				$sTmpIdx &= String($i) &"|"
				$g_iServerCountTotal += 1
			Else
				ExitLoop(1)
			EndIf
		Next
	EndIf
	$sTmp = StringTrimRight($sTmp, 1)
	$sTmpIdx = StringTrimRight($sTmpIdx, 1)

	;clear selected column.
	GUICtrlSendMsg($UI_ListV_svData_A, $LVM_SETSELECTEDCOLUMN, -1, 0) ;updateLV

	;update listview with invalid values
	FillServerStringArrayPing($iGameIdx, 999, $g_iServerCountTotal)
	if Not $isPing Then	FillServerListView_popData($iGameIdx, $ListViewA, $isFiltered)

	$aIPArray = StringSplit($sTmp, "|", $STR_NOCOUNT)
	$aServerIdx = StringSplit($sTmpIdx, "|", $STR_NOCOUNT)
	If IsArray($aIPArray) and UBound($aIPArray) > 0 _
	And IsArray($aServerIdx) and UBound($aServerIdx) > 0 Then
		For $i = 0 to UBound($aServerIdx) -1
			$aServerIdx[$i] = Number($aServerIdx[$i]) ;convert to int
		Next
		SendStatustoServers_Init($iGameIdx, $aIPArray, $aServerIdx)
	EndIf
EndFunc

;===== FavArrayLoad() =====
;load fav per game tab, refresh them to
GUICtrlSetOnEvent($UI_Btn_loadFav, "UI_Btn_loadFavClicked")
	Func UI_Btn_loadFavClicked()
		Local $ListViewA = getListView_A_CID()
		Local $iGameIdx, $ipArray

		SetSelectedGameID()
		$iGameIdx = $g_iCurGameID ;GetActiveGameIndex()
		ResetServerListArrays(BitShift(1, -($iGameIdx))) ; bit

		_GUICtrlListView_DeleteAllItems($ListViewA)
		;clear selected column. todo work out how to re-sort without mouse click
		GUICtrlSendMsg($UI_ListV_svData_A, $LVM_SETSELECTEDCOLUMN, -1, 0) ;updateLV
		If $g_aFavList[$iGameIdx] <> "" Then
			$ipArray = StringSplit($g_aFavList[$iGameIdx], "|", $STR_NOCOUNT)
			$g_iServerCountTotal = UBound($ipArray)
			If $g_iServerCountTotal > 0 Then
				;update internal arrays
				FillServerStringArrayIP($iGameIdx, $ipArray)
				FillServerStringArrayPing($iGameIdx, 999, $g_iServerCountTotal)
				;update listview
				FillServerListView_popData($iGameIdx, $ListViewA)
				RefreshServersInListview($iGameIdx)
				FinishedGettinServers()
			EndIf
		EndIf
	EndFunc
;===== END =====


;=====  RefreshSingle() =====
Func RefreshSingle()
	ConsoleWrite("RefreshSingle Server"&@CRLF)
	SetSelectedGameID()
	Local $iGameIdx = $g_iCurGameID
	;EnableUIButtons(False)
	BeginGettinServers()
	ListviewStoreIndexToArray($iGameIdx)
	$g_iServerCountTotal = 1 ;get # servers to use later to stop refresh

	Local $aServerIP[1] ;only update 1 server
	Local $aServerIdx[1] ;only update 1 server
	Local $ListViewA = getListView_A_CID()
	Local $listSelNum = _GUICtrlListView_GetSelectionMark($ListViewA) ;mouse selected num.
	Local $serSelNum = GetServerListA_SelectedData($LV_A_IDX) ;server index num (internal array ID)

	;~ if $g_gameConfig[$iGameIdx][$NET_GS_P] Then
		$aServerIP[0] = String($g_aServerStrings[$iGameIdx][$serSelNum][$COL_IP] &":"& _
		                      $g_aServerStrings[$iGameIdx][$serSelNum][$COL_PORT]) ; get game port (-10)
		$aServerIdx[0] = $serSelNum

	If $aServerIP[0] = "" Then
		;invalid ip
		Return
	EndIf

	;reset internal array
	$g_aServerStrings[$iGameIdx][$serSelNum][$COL_PLAYERS] = 0
	$g_aServerStrings[$iGameIdx][$serSelNum][$COL_PING] = 999
	$g_aServerStrings[$iGameIdx][$serSelNum][$COL_INFOSTR] = ""
	$g_aServerStrings[$iGameIdx][$serSelNum][$COL_INFOPLYR] = ""

	ConsoleWrite("ListNum= '" & $listSelNum &"'  ServerNum= '" &$serSelNum&"'"& @CRLF)
	ConsoleWrite("address= " & $aServerIP[0]&@CRLF)

	GUICtrlSetData($UI_Prog_getServer, 50)
	;reset array incase server does not reply, keep name
	_GUICtrlListView_SetItem($ListViewA, "999", $listSelNum, 3, -1)	;ping
	_GUICtrlListView_SetItem($ListViewA, "0/0", $listSelNum, 4, -1)	;players
	_GUICtrlListView_SetItem($ListViewA, "",    $listSelNum, 5, -1)	;map
	_GUICtrlListView_SetItem($ListViewA, "",    $listSelNum, 6, -1)	;mod

	SendStatustoServers_Init($iGameIdx, $aServerIP, $aServerIdx, False)

	;update server players/rules
	FillListView_BC_Selected($iGameIdx, $listSelNum);  $iGameID

	FinishedGettinServers();/
	;$isPlayersInServer = False ;refresh selected sets this but never uses it
	$g_iPlayerCount_GS = 0 ;reset player count for audio
EndFunc
;===== END RefreshSingle =====

;0 = inital shift. maximize server list
;1 = maximize server list
;2 = maximize server detail windows
Func SetFocusSize()
	Local $w1, $w2, $w3
	Local Const $offset[2] = [136, -136] ;init, min, max; 68,
	Local Static $lastPos = 0 ; g_ResizeListView
	;todo set in preferences?
	$lastPos = ($lastPos=1)? (0) : (1)

	$w1 = ControlGetPos($HypoGameBrowser, "", $UI_ListV_svData_A)
	$w2 = ControlGetPos($HypoGameBrowser, "", $UI_ListV_svData_B)
	$w3 = ControlGetPos($HypoGameBrowser, "", $UI_ListV_svData_C)
	GUICtrlSetPos($UI_ListV_svData_A, $w1[0], $w1[1]                  , $w1[2], $w1[3]+$offset[$lastPos])
	GUICtrlSetPos($UI_ListV_svData_B, $w2[0], $w2[1]+$offset[$lastPos], $w2[2], $w2[3]-$offset[$lastPos])
	GUICtrlSetPos($UI_ListV_svData_C, $w3[0], $w3[1]+$offset[$lastPos], $w3[2], $w3[3]-$offset[$lastPos])
EndFunc


GUISetOnEvent($GUI_EVENT_CLOSE, "ExitScript", $HypoGameBrowser)
	Func ExitScript()
		TCPShutdown()
		UDPShutdown()

		For $i=0 to 2
			FileDelete($g_sM_tmpFile[$i])
		Next
		FileDelete($g_sM_tmpFile_reg)
		iniFile_Save()

		;_GUICtrlListView_UnRegisterSortCallBack($UI_ListV_svData_A)
		;_GUICtrlListView_UnRegisterSortCallBack($UI_ListV_svData_C)
		_GUICtrlComboBoxEx_Destroy($UI_Combo_gameSelector)
		GUIDelete($MPopupInfo)
		GUIDelete($HypoGameBrowser)
		Exit
	EndFunc   ;==>CLOSEButton

	Func GetActiveGameIndex()
		Switch $g_iTabNum
			Case $TAB_GB ;0 to $COUNT_GAME-1
				Switch $g_iCurGameID
					Case 0 to $COUNT_GAME-1
						Return $g_iCurGameID
					Case Else
						Return 0 ;default
				EndSwitch
			case $TAB_MB
				Switch $iMGameType
					Case 0 to 2 ;todo $ID_Q2
						Return $iMGameType
					Case Else
						Return 0 ;default
				EndSwitch
			Case Else
				Return 0 ;default
		EndSwitch
	EndFunc

Func SetTabActiveGame()
	if ($g_iTabNum = $TAB_CFG) Or ($g_iTabNum = $TAB_CHAT) Then
		if ($g_iTabNum = $TAB_CFG) Then
			;update just incase user changed anything
			GameSetup_Store() ;save prev settings
			;UpdateMasterDisplay()
			;GameSetup_UpdateUI()
		EndIf

		Switch ComboBoxEx_GetCurSel()
			Case $COUNT_GAME ; $ID_M
				ConsoleWrite("-MB"&@CRLF)
				$g_iTabNum = $TAB_MB
				SetActiveTab($TAB_MB)
			Case Else
				ConsoleWrite("-GB"&@CRLF)
				$g_iTabNum = $TAB_GB
				SetActiveTab($TAB_GB)
		EndSwitch
	EndIf
EndFunc



;using refresh button
GUICtrlSetOnEvent ($UI_Btn_refreshMaster, "UI_Btn_refreshClicked")
	Func UI_Btn_refreshClicked()
		SetSelectedGameID()
		SetTabActiveGame() ;switch if in settings
		If $g_iTabNum = $TAB_MB Then
			ConsoleWrite("-m"&@CRLF)
			MRefresh() ;refresh mbrowser
			Return
		Else
			ConsoleWrite("-g"&@CRLF)
			GetServerListFromMaster($g_iCurGameID)
		EndIf
	EndFunc

;using setup button
GUICtrlSetOnEvent($UI_Btn_settings, "UI_Btn_settingsClicked")
	Func UI_Btn_settingsClicked()
		$g_iTabNum = $TAB_CFG
		SetActiveTab($TAB_CFG)
	EndFunc

;using expand button
GUICtrlSetOnEvent($UI_Btn_expand, "ExpandBtnClicked")
	Func ExpandBtnClicked()
		;$g_ResizeListView = 1
		SetFocusSize()
	EndFunc

;using connect chat button
GUICtrlSetOnEvent($UI_Btn_chatConnect,"load_gui")
	Func load_gui()
		SetUITheme($UI_Obj_webPage, $g_UseTheme)
		_IENavigate($UI_Obj_webPage, "https://forum.hambloch.com/c.php?r=kingpin")
	EndFunc ;_IECreateEmbedded

Func SetCBox_names($hw, $checked, $unchecked)
	If _IsChecked($hw) Then
		GUICtrlSetData($hw, $checked)
	Else
		GUICtrlSetData($hw, $unchecked)
	EndIf
EndFunc

;filters
GUICtrlSetOnEvent($UI_Btn_filterOffline,"UI_Btn_filterOfflineClicked")
	Func UI_Btn_filterOfflineClicked()
		SetCBox_names($UI_Btn_filterOffline, 'Hidden', 'Offline')
		SetSelectedGameID()
		FillListView_A_Filtered($g_iCurGameID, $UI_ListV_svData_A, True)
	EndFunc
GUICtrlSetOnEvent($UI_Btn_filterEmpty,"UI_Btn_filterEmptyClicked")
	Func UI_Btn_filterEmptyClicked()
		SetCBox_names($UI_Btn_filterEmpty, 'Hidden', 'Empty')
		SetSelectedGameID()
		FillListView_A_Filtered($g_iCurGameID, $UI_ListV_svData_A, True)
	EndFunc
GUICtrlSetOnEvent($UI_Btn_filterFull,"UI_Btn_filterFullClicked")
	Func UI_Btn_filterFullClicked()
		SetCBox_names($UI_Btn_filterFull, 'Hidden', 'Full')
		SetSelectedGameID()
		FillListView_A_Filtered($g_iCurGameID, $UI_ListV_svData_A, True)
	EndFunc


Func SetButtoShowState($iTab)
	Local Const $aButtons = [$UI_Btn_pingList, $UI_Btn_loadFav, $UI_Btn_offlineList]

	;main buttons
	Switch $iTab
		Case $TAB_GB ;gamespy
			For $i = 0 to UBound($aButtons) - 1
				GUICtrlSetState($aButtons[$i], $GUI_SHOW)
			Next
		Case  $TAB_MB ;mbrowser
			For $i = 0 to UBound($aButtons) - 1
				GUICtrlSetState($aButtons[$i], $GUI_HIDE)
			Next
		Case Else ;$TAB_CHAT, $TAB_CFG
			For $i = 0 to UBound($aButtons) - 1
				GUICtrlSetState($aButtons[$i], $GUI_HIDE)
			Next
	EndSwitch
EndFunc


;using tabs
GUICtrlSetOnEvent($tabGroupGames, "TabClicked")
	Func TabClicked()
		ConsoleWrite("event tab Clicked. oldTab:"&$g_iTabNum&@CRLF)

		;check if user is in settings
		If $g_iTabNum = $TAB_CFG Then ;update user settings on exit 'setup' tab
			GameSetup_Store() ;UI_Combo_masterChange
		EndIf

		TabClicked_SyncGameCombo()

		SetSelectedGameID() ;$g_iTabNum

		UpdateMasterDisplay() ;ui master text

		ConsoleWrite("event tab Clicked. newTab:"&$g_iTabNum&@CRLF)
		SetButtoShowState($g_iTabNum)
	EndFunc

;sync tab/gameSelector
Func TabClicked_SyncGameCombo()
	; ComboChanged_SyncTab()
	; note -=| endless loop if not handeled correctly. |=-
	Local $iTab = GUICtrlRead($tabGroupGames)
	Local $iGameIdx = ComboBoxEx_GetCurSel()
	ConsoleWrite("-tab:"&$iTab& " game:"&$iGameIdx&@CRLF)

	Switch $iTab
		Case $TAB_GB
			;GB Tab clicked, make sure dropdown is not M
			if $iGameIdx = $COUNT_GAME Then ; $ID_M Then
				;GameSetup_Store()
				ConsoleWrite("!gid:"&$g_iGSGameLast&@CRLF)
				$g_iCurGameID = $g_iGSGameLast
				ComboBoxEx_SetCurSel($g_iGSGameLast)
				GameSetup_UpdateUI()
			EndIf
		Case $TAB_MB
			ConsoleWrite("-tab:"&$iTab&" gID:"&$iGameIdx&@CRLF)
			;M Tab clicked. set dropdown to M
			ConsoleWrite("test:"&($iGameIdx = $COUNT_GAME)&@CRLF) ;$ID_M
			if Not ($iGameIdx = $COUNT_GAME) Then ;$ID_M
				ComboBoxEx_SetCurSel($COUNT_GAME) ;$ID_M
				GameSetup_UpdateUI() ;unused
			EndIf
	EndSwitch
EndFunc


GUICtrlSetOnEvent($UI_ListV_svData_A,"UI_ListV_sortA_Clicked")
Func UI_ListV_sortA_Clicked()
	If $g_isGettingServers Then Return
	$g_bLV_A_startUpdate = True
	;hilight column
	GUICtrlSendMsg($UI_ListV_svData_A, $LVM_SETSELECTEDCOLUMN, GUICtrlGetState($UI_ListV_svData_A), 0) ;updateLV
	ConsoleWrite(">lv start sort"&@CRLF)
EndFunc

Func ListViewSort_A($hWnd, $nItem1, $nItem2, $iColumn)
	#forceref $hWnd
	Local $data1, $data2
	Local $iRet = 0
	Local static $bSwitch = False
	Local $iGameIdx = $g_iCurGameID
	If $g_isGettingServers Then Return

	$nItem1 -= $g_listID_offset
	$nItem2 -= $g_listID_offset

	If $g_bLV_A_startUpdate Then
		$g_bLV_A_startUpdate = False
		ConsoleWrite("-lv sorting"&@CRLF)
		;swap sort order
		If $g_ilastColumn_A = $iColumn Then
			$bSwitch = ($bSwitch)? (False):(True)
			;use default sort order. dont
			ConsoleWrite("-lv1 switch:"&$bSwitch&@CRLF)
		Else
			$bSwitch = False
			$g_ilastColumn_A = $iColumn
			ConsoleWrite("-lv2 switch:"&$bSwitch&@CRLF)
		EndIf
	EndIf

	Switch $iColumn
		case 0 ;index. a>z sort
			$data1 = $nItem1
			$data2 = $nItem2
			$iRet = ($data1 < $data2)? (-1):(1)
		Case 1 ;ip:port. a>z sort
			$data1 = ConvertIPtoInt($g_aServerStrings[$iGameIdx][$nItem1][$COL_IP])
			$data2 = ConvertIPtoInt($g_aServerStrings[$iGameIdx][$nItem2][$COL_IP])
			if $data1 = $data2 Then
				$data1 = $data1 + 65536 + $g_aServerStrings[$iGameIdx][$nItem1][$COL_PORT]
				$data2 = $data2 + 65536 + $g_aServerStrings[$iGameIdx][$nItem2][$COL_PORT]
			endif
			$iRet = ($data1 < $data2)? (-1):(1)
		Case 2 ;sv name. a>z sort
			$data1 = $g_aServerStrings[$iGameIdx][$nItem1][$COL_NAME]
			$data2 = $g_aServerStrings[$iGameIdx][$nItem2][$COL_NAME]
			$iRet = ($data1 < $data2)? (-1):(1)
		Case 3 ;ping. a>z sort
			$data1 = $g_aServerStrings[$iGameIdx][$nItem1][$COL_PING]
			$data2 = $g_aServerStrings[$iGameIdx][$nItem2][$COL_PING]
			$iRet = ($data1 < $data2)? (-1):(1)
		Case 4 ;player count. z>a sort(high first)
			$data1 = $g_aServerStrings[$iGameIdx][$nItem1][$COL_PLAYERS]
			$data2 = $g_aServerStrings[$iGameIdx][$nItem2][$COL_PLAYERS]
			if $data1 = $data2 Then
				$data2 = $g_aServerStrings[$iGameIdx][$nItem1][$COL_IDX]
				$data1 = $g_aServerStrings[$iGameIdx][$nItem2][$COL_IDX]
			EndIf
			$iRet = ($data1 > $data2)? (-1):(1)
		Case 5 ;map.  a>z sort
			$data1 = $g_aServerStrings[$iGameIdx][$nItem1][$COL_MAP]
			$data2 = $g_aServerStrings[$iGameIdx][$nItem2][$COL_MAP]
			$iRet = ($data1 < $data2)? (-1):(1)
		Case 6 ;map.  a>z sort
			$data1 = $g_aServerStrings[$iGameIdx][$nItem1][$COL_MOD]
			$data2 = $g_aServerStrings[$iGameIdx][$nItem2][$COL_MOD]
			$iRet = ($data1 < $data2)? (-1):(1)
	EndSwitch

	If $bSwitch Then
		$iRet = -1 * $iRet
	EndIf

	return $iRet
EndFunc

Func ConvertIPtoInt($ip)
	$ip = StringSplit($ip, ".")
	if $ip[0] > 3  then
		return BitShift($ip[0], -24) + BitShift($ip[1], -16) + BitShift($ip[2], -8) + $ip[3]
	EndIf
	Return 0
EndFunc


;=================
;sort server rules
GUICtrlSetOnEvent($UI_ListV_svData_C,"SortListC")
	Func SortListC()
		local $iColClicked = GUICtrlGetState($UI_ListV_svData_C) ;updateLV C

		If Not ($g_ilastColumn_C = $iColClicked) Then
			;use default sort order.
			ConsoleWrite("reset sort"&@CRLF)
			$g_vSortSense_C[0] = False
			$g_vSortSense_C[1] = False
		EndIf

		ConsoleWrite(">s1:"&$g_vSortSense_C[0] &" c1:"&$g_vSortSense_C[1]&@CRLF)
		_GUICtrlListView_SimpleSort($UI_ListV_svData_C, $g_vSortSense_C, $iColClicked, true)
		$g_ilastColumn_C = $iColClicked
		ConsoleWrite("<s1:"&$g_vSortSense_C[0] &" c1:"&$g_vSortSense_C[1]&@CRLF)
		;hilight column
		GUICtrlSendMsg($UI_ListV_svData_C, $LVM_SETSELECTEDCOLUMN, $iColClicked, 0) ;updateLV
	EndFunc


Func ButtonGamePath($refIdx)
	Local $idx, $idx2, $sFolderPath = @WorkingDir

	if $refIdx = Null Then
		$idx = ComboBoxEx_GetCurSel()
	Else
		$idx = $refIdx
	EndIf

	If $idx >=0 And $idx < $COUNT_GAME Then
		$idx2 = StringInStr($g_aGameSetup[$idx][$GCFG_EXE_PATH], "\", $STR_CASESENSE, -1)
		if $idx2 Then
			$sFolderPath = StringMid($g_aGameSetup[$idx][$GCFG_EXE_PATH], 1, $idx2)
			if Not FileExists($sFolderPath) Then $sFolderPath = @WorkingDir
		EndIf
		ConsoleWrite("-folder:"&$sFolderPath&@CRLF)
		Local $sFilename = _WinAPI_OpenFileDlg('', $sFolderPath, 'Executables (*.exe)|All Files (*.*)', 1, _
			$g_gameConfig[$idx][$GNAME_MENU]&'.exe', '', BitOR($OFN_PATHMUSTEXIST, $OFN_FILEMUSTEXIST, $OFN_HIDEREADONLY), 0, Default, Default, $HypoGameBrowser)
		If Not @error Then
			$g_aGameSetup[$idx][$GCFG_EXE_PATH] = $sFilename ;save now?
			ConsoleWrite("-ref:"&$refIdx&@CRLF)
			GUICtrlSetData($UI_In_gamePath, $sFilename)
		EndIf
	EndIf
EndFunc
GUICtrlSetOnEvent($UI_Btn_gamePath, "UI_Btn_gamePathClicked")
	Func UI_Btn_gamePathClicked()
		ButtonGamePath(Null)
	EndFunc

Func setBitvalue(ByRef $data, $isEnabled, $bit)
	if $isEnabled Then
		$data = BitOR($data, $bit)
	ElseIf BitAND($data, $bit) Then
		$data = BitXOR($data, $bit)
	EndIf
EndFunc

GUICtrlSetOnEvent($UI_CBox_gameRefresh, "UI_CBox_gameRefreshClicked")
	Func UI_CBox_gameRefreshClicked()
		;UI_CBox_autoRefresh sync...
		Local $idx = ComboBoxEx_GetCurSel()
		local $isChecked = _IsChecked($UI_CBox_gameRefresh)
		if $idx >= $COUNT_GAME Then Return
		setBitvalue($g_aGameSetup[$idx][$GCFG_AUTO_REF], $isChecked, 1)
	EndFunc

GUICtrlSetOnEvent($UI_CBox_gamePingAll, "UI_CBox_gamePingAllClicked")
	Func UI_CBox_gamePingAllClicked()
		Local $idx = ComboBoxEx_GetCurSel()
		local $isChecked = _IsChecked($UI_CBox_gamePingAll)
		if $idx >= $COUNT_GAME Then Return
		setBitvalue($g_aGameSetup[$idx][$GCFG_AUTO_REF], $isChecked, 2)
		_SetDisabledState($UI_CBox_tryNextMaster, Not $isChecked)
	EndFunc

;web links
GUICtrlSetOnEvent($UI_Text_linkKPInfo, "UI_Text_linkKPInfo")	;kingpin.info
	Func UI_Text_linkKPInfo()
		ShellExecute("https://www.kingpin.info", 1)
	EndFunc
GUICtrlSetOnEvent($UI_Text_linkMServers, "UI_Text_linkMServers"); m server list
	Func UI_Text_linkMServers()
		ShellExecute("https://hambloch.com/kingpin/?ref=mbrowser", 1)
	EndFunc
GUICtrlSetOnEvent($UI_Text_linkContactM, "UI_Text_linkContactM") ;contact M
	Func UI_Text_linkContactM()
		ShellExecute("https://forum.hambloch.com/email.php?u=kingpin", 1)
	EndFunc
GUICtrlSetOnEvent($UI_Text_linkKPQ3, "UI_Text_linkKPQ3") ; kpq3
	Func UI_Text_linkKPQ3()
		ShellExecute("https://www.kingpinq3.com", 1)
	EndFunc
GUICtrlSetOnEvent($UI_Text_linkDiscord, "UI_Text_linkDiscord") ;discord
	Func UI_Text_linkDiscord()
		ShellExecute("https://discord.gg/mQseVd7Vd7", 1)
	EndFunc
GUICtrlSetOnEvent($UI_Text_linkHypoEmail, "UI_Text_linkHypoEmail") ; hypov8 email
	Func UI_Text_linkHypoEmail()
		ShellExecute("mailto:hypov8@hotmail.com?subject=kingpin", 1)
	EndFunc
GUICtrlSetOnEvent($UI_Text_linkSupport, "UI_Text_linkSupport") ;m chat
	Func UI_Text_linkSupport()
		ShellExecute("https://buymeacoffee.com/hypov8", 1)
	EndFunc

GUICtrlSetOnEvent ($UI_Icon_hypoLogo, "UI_Icon_hypoLogoClicked")
	Func UI_Icon_hypoLogoClicked()
		ShellExecute("https://buymeacoffee.com/hypov8", 1)
	EndFunc

; events GUI
GUISetOnEvent($GUI_EVENT_RESIZED, "GuiResized")
	Func GuiResized()
		ConsoleWrite("GuiResized"& @CRLF)
		$g_bGuiResized=True
		$g_bWasMaximized = False
	EndFunc

GUISetOnEvent($GUI_EVENT_RESTORE, "GuiEventRestore_use")
	Func GuiEventRestore_use()
		ConsoleWrite("GuiEventRestore_use"&@CRLF)
		;todo check this, buggy
		if $g_bWasMinimized Then
			if $g_bWasMaximized Then
				GuiSetState(@SW_MAXIMIZE, $HypoGameBrowser)
				$g_bWasMaximized = True
			Else
				GuiSetState(@SW_RESTORE, $HypoGameBrowser)
				$g_bWasMaximized = False
			EndIf
		Else
			if $g_bWasMaximized Then
				GuiSetState(@SW_RESTORE, $HypoGameBrowser)
				$g_bWasMaximized = False
			Else
				GuiSetState(@SW_MAXIMIZE, $HypoGameBrowser)
				$g_bWasMaximized = True
			EndIf
		EndIf
		$g_bWasMinimized = False
		$g_bGuiResized = True
	EndFunc

GUISetOnEvent($GUI_EVENT_MAXIMIZE, "GuiEventMaximize_use")
	Func GuiEventMaximize_use()
		ConsoleWrite("GuiEventMaximize_use"&@CRLF)
		$g_bWasMaximized = True
		$g_bWasMinimized = False
		GuiSetState(@SW_MAXIMIZE, $HypoGameBrowser)
		$g_bGuiResized = False ;True //hypo stop storing resize info on maximize
		;ConsoleWrite("GuiEventMaximize_use setSize"&@CRLF)
	EndFunc

GUISetOnEvent($GUI_EVENT_MINIMIZE, "GuiEventMinimize_use")
	Func GuiEventMinimize_use()
		ConsoleWrite("GuiEventMinimize_use " &@CRLF)
		GuiSetState(@SW_MINIMIZE,  $HypoGameBrowser)
		$g_bWasMinimized = True
	EndFunc


Func SetWinSizeForMinimize()
	Local $getWinState = WinGetState($HypoGameBrowser)
	Local $posi[4]

	if Not BitAND($getWinState,16) Then
		$posi = WinGetPos($HypoGameBrowser)
		If ($posi[0] >= -4) And ($posi[1] >= -4) Then
			$g_aStoredWinSize = $posi
			;ConsoleWrite("Store gui size"&@CRLF)
		EndIf
	EndIf
EndFunc

Func GetMasterProtocol($sMasterIP)
	Local $aIPPort = StringSplit($sMasterIP, ':')
	If not @error And $aIPPort >=2 Then
		If StringCompare($aIPPort[1], "https") = 0  then
			;https://www.qtracker.com/server_list_details.php?game=kingpin
			Return $NET_PROTOCOL_HTTPS
		ElseIf StringCompare($aIPPort[1], "http") = 0 then
			;http://q2servers.com/
			Return $NET_PROTOCOL_HTTP
		else
			Local $iPort = Number($aIPPort[2])
			If $iPort = 28900 Then
				Return $NET_PROTOCOL_TCP ;gamespy
			ElseIf $iPort = 80 Or $iPort = 81 Then
				Return $NET_PROTOCOL_WEB
			Else
				Return $NET_PROTOCOL_UDP ; ALL OTHER PORTS
			EndIf
		endif
	EndIf
	Return $NET_PROTOCOL_NONE ;failed.
EndFunc

Func getMasterExtraInfo($gameIDx)
	Return $g_aGameSetup[$gameIDx][$GCFG_MAST_PROTO] ;todo check this
EndFunc


GUICtrlSetOnEvent($UI_CBox_autoRefresh, "UI_CBox_autoRefreshChanged")
	Func UI_CBox_autoRefreshChanged()
		ConsoleWrite("autorefresh changed"&@CRLF)
		ResetRefreshTimmers()
		$g_bAutoRefresh = _IsChecked($UI_CBox_autoRefresh)

		If $g_bAutoRefresh then
			$g_iTimeInputBox = Number(GUICtrlRead($UI_In_refreshTime)) ; get time. todo onEvent changed
			$g_iTimeInputBox = ($g_iTimeInputBox < 1)? (1):($g_iTimeInputBox) ;1minute minimum
			$g_iTimeInputBox *= 1000 * 60 ;convert to min
			GUICtrlSetState($UI_In_refreshTime, $GUI_DISABLE)
			SetUITheme_inputBox($UI_In_refreshTime, $g_UseTheme, False)
		Else
			GUICtrlSetState($UI_In_refreshTime, $GUI_ENABLE)
			SetUITheme_inputBox($UI_In_refreshTime, $g_UseTheme, True)
		EndIf
		;_GUICtrlEdit_SetReadOnly($UI_In_refreshTime, $g_bAutoRefresh)
	EndFunc


;linked above
GUICtrlSetOnEvent($UI_MHost_addServer, "M_ServerAddPortKP")
GUICtrlSetOnEvent($UI_MHost_removeServer, "M_ServerRemovePortKP")
GUICtrlSetOnEvent($UI_MHost_excludeSrever, "M_ServerExcludePortKP")

; --> END EVENTS
;========================================================
#EndRegion --> END MOUSE EVENTS


#Region --> use auto refresh
;========================================================
; --> use auto refresh
Func AutoRefreshTimer()
	local $stateMinimized = WinGetState($HypoGameBrowser)
	Local $getWinState = WinGetState($MPopupInfo)

	;disable autor efresh if not ready
	If BitAND($stateMinimized,16) Or  BitAND($getWinState,2) Or $g_isGettingServers > 0 Then
		Return ;$WIN_STATE_MINIMIZED. $WIN_STATE_VISIBLE. if M-popup showing, disable refresh
	EndIf

	;gameSpy
	If $g_bAutoRefresh > 0 Then
		;check last refresh time
		If TimerDiff($g_iLastRefreshTime) > $g_iTimeInputBox Then
			Local $iGameIdx = ComboBoxEx_GetCurSel()
			Local $iOff ;
			$g_bAutoRefreshActive = True

			ResetRefreshTimmers() ; $g_iLastRefreshTime = TimerInit()

			if $iGameIdx = $COUNT_GAME Then ;$ID_M
				MRefresh()
			else
				;move to next game in list to refresh(if any)
				For $i = 0 To $COUNT_GAME -1
					$iOff = Mod($g_iAutoRefreshGame +$i+1, $COUNT_GAME)
					If BitAND($g_aGameSetup[$iOff][$GCFG_AUTO_REF], 1) Then
						$iGameIdx = $iOff
						;change selected game
						$g_iGSGameLast = $iGameIdx
						$g_iCurGameID = $iGameIdx
						ComboBoxEx_SetCurSel($iGameIdx)
						GameSetup_UpdateUI() ;unused
						Sleep(100)
						ExitLoop
					EndIf
				Next
				$g_iAutoRefreshGame = $iGameIdx
				GetServerListFromMaster($iGameIdx)
			EndIf
			$g_bAutoRefreshActive = False
		EndIf
	EndIf
EndFunc


#EndRegion

Func ComboBoxEx_GetCurSel()
	local $ret = _GUICtrlComboBoxEx_GetCurSel($UI_Combo_gameSelector)
	if $ret < 0 Then
		Return 0
	elseif $ret > $COUNT_GAME Then
		Return $COUNT_GAME
	EndIf
	Return $ret
EndFunc


Func ComboBoxEx_SetCurSel($idx)
	Return _GUICtrlComboBoxEx_SetCurSel($UI_Combo_gameSelector, $idx)
EndFunc


#Region --> WindowHotkeys

GUICtrlSetOnEvent($UI_Btn_setHotKey, "ApplyhotKeyBtn")
Func ApplyhotKeyBtn()
	 if ApplyhotKey() = False Then
		hotKeyWarning()
	EndIf
EndFunc

Func getHotKeyFlag()
	Local $idx = _GUICtrlComboBox_GetCurSel($UI_Combo_hkey)
	ConsoleWrite("hkey idx:"&$idx&@CRLF)
	Switch $idx
		Case 0
			Return "!" ; ALT
		Case 1
			Return "^" ; CTRL
		Case 2
			Return "!^" ; CTRL+ALT
		Case Else
			Return "" ;
	EndSwitch
EndFunc

Func hotKeyWarning()
	GUICtrlSetData($UI_In_hotKey, "")
	MsgBox($MB_SYSTEMMODAL,"ERROR: HOT KEY","Invalid Hot Key entered."&@CRLF& "Only a-z accepted.",0, $HypoGameBrowser)
EndFunc

;0= startup ini
;1= apply button
Func ApplyhotKey()
	Local $sHkeyKey ;a-z inputbox
	Local Static $sLastKey = ""

	;Reset
	If $sLastKey <> "" Then
		HotKeySet($sLastKey) ;reset
		ConsoleWrite("!HotKey cleared: '"& $sLastKey&"'"&@CRLF)
	EndIf

	$sHkeyKey = GUICtrlRead($UI_In_hotKey)
	If $sHkeyKey = "" Then
		Return False ;no hotkey. unbind
	EndIf

	;clean string. get only 1 char
	$sHkeyKey = StringMid(StringLower($sHkeyKey), 1, 1)
	GUICtrlSetData($UI_In_hotKey, $sHkeyKey)

	If Asc($sHkeyKey) < Asc("a") Or Asc($sHkeyKey) > Asc("z")  Then
		hotKeyWarning()
	Else
		$sLastKey = String(getHotKeyFlag() & $sHkeyKey)
		HotKeySet($sLastKey , "RestoreWindowHotKey") ; set hotkey
		ConsoleWrite("!HotKey set '"& $sHkeyKey&"'"&@CRLF)
		setTempStatusBarMessage("Hotkey Set")
	EndIf
	Return True
EndFunc


Func RestoreWindowHotKey()
	ResetRefreshTimmers()

	If $g_bWasMinimized Then
		If $g_bWasMaximized Then
			GuiSetState(@SW_SHOW,  $HypoGameBrowser)
			GuiSetState(@SW_MAXIMIZE,  $HypoGameBrowser)
			$g_bWasMaximized = True
		Else
			GuiSetState(@SW_SHOW,  $HypoGameBrowser)
			GuiSetState(@SW_RESTORE,  $HypoGameBrowser)
			;WinMove($HypoGameBrowser, $HypoGameBrowser, $g_aStoredWinSize[0], $g_aStoredWinSize[1], $g_aStoredWinSize[2], $g_aStoredWinSize[3])
			$g_bWasMaximized = False
		EndIf

		ConsoleWrite("Was minimized " & @CRLF)
		ConsoleWrite("get posi= " & WinGetPos($HypoGameBrowser)[0] &@CRLF)
		ConsoleWrite("posi= " & $g_aStoredWinSize[0]&" "& $g_aStoredWinSize[1] &@CRLF)

	Else ;-->displayed
		If $g_bWasMaximized Then
			GuiSetState(@SW_MAXIMIZE, $HypoGameBrowser)
			ConsoleWrite("Window Maximized " & @CRLF)
			$g_bWasMaximized = True
		Else
			ConsoleWrite("Window Restored " & @CRLF)
			GuiSetState(@SW_RESTORE,  $HypoGameBrowser)
			ConsoleWrite("Window Restored2"& @CRLF)
			$g_bWasMaximized = False
		EndIf

	EndIf
	$g_bWasMinimized = False
EndFunc

#EndRegion --> WindowHotkeys

#Region --> RUN GAME EXE

Func Start_Kingpin_failed($iGameIdx, $aEXEPath)
	local $sGameName = $g_gameConfig[$iGameIdx][$GNAME_MENU]
	Local $msgBoxKeyID = MsgBox(BitOR($MB_SYSTEMMODAL,$MB_OKCANCEL), _
		"Game Path",  "ERROR: '"&$sGameName&".exe' NOT found in" &@CRLF & $aEXEPath& @CRLF& @CRLF&  _
		"Press OK to setup your '"&$sGameName&"' Game Path", 0, $HypoGameBrowser )
	if $msgBoxKeyID = 1 Then
		ButtonGamePath($iGameIdx)	 ;file search dialog
	EndIf

	ResetRefreshTimmers()
EndFunc

;========================================================
; -->Start_Kingpin
Func Start_Kingpin()
	SetSelectedGameID()
	Local $runServerAddress = GetServerListA_SelectedData($LV_A_IP) ; will get M data to
	If $runServerAddress = "" Then
		 Return ;crashes with no server/ip
	EndIf
	LaunchGame($runServerAddress, GetActiveGameIndex()) ;get both GS and M id
EndFunc

Func LaunchGame($runServerAddress, $iGameIdx)
	Local $sInputPath, $sInputName, $sInputCommand, $idx
	Local $runEXE = "", $runEXEName = "", $runCMDString = "", $runWorkingPath = ""

	;exe path
	$sInputPath = $g_aGameSetup[$iGameIdx][$GCFG_EXE_PATH] ;GUICtrlRead($aRun[$iGameIdx])
	If $sInputPath <> "" Then
		$runEXE = StringStripWS($sInputPath, $STR_STRIPTRAILING +$STR_STRIPSPACES)
		$runEXE = StringReplace($runEXE, "/", "\", 0, 1)
		$idx = StringInStr($runEXE, "\",1, -1)
		If $idx Then
			$runEXEName = StringMid($runEXE, $idx)
			$runWorkingPath = StringLeft($runEXE, $idx)
			ConsoleWrite(">exe="&$runEXEName&" path="&$runWorkingPath&@CRLF)
		EndIf
	EndIf
	;player name
	$sInputName = $g_aGameSetup[$iGameIdx][$GCFG_NAME_PLYR];GUICtrlRead($aNAME[$iGameIdx])
	if $sInputName <> "" Then
		$runCMDString &= StringFormat("+set name %s ", StringStripWS($sInputName, $STR_STRIPTRAILING +$STR_STRIPSPACES))
	EndIf
	;lunch commands
	$sInputCommand = $g_aGameSetup[$iGameIdx][$GCFG_RUN_CMD] ;GUICtrlRead($aCMD[$iGameIdx])
	If $sInputCommand <> "" Then
		$runCMDString &= StringFormat("%s " ,StringStripWS($sInputCommand, $STR_STRIPTRAILING +$STR_STRIPSPACES))
	EndIf
	;add server ip
	$runCMDString &= StringFormat("+connect %s ", $runServerAddress)

	ConsoleWrite(">run="&$runEXE&" >"&$runCMDString &@CRLF)

	;==========================================================================
	;run game. first search settings 'path'. 2nd search script dir. 3rd check registry
	If $runEXE <> "" And FileExists($runEXE) Then
		ConsoleWrite(">run .exe from settings." & @CRLF)
		Tray_MinimizeWindow()
		ShellExecute($runEXE, $runCMDString, $runWorkingPath)
	;==> kingpin
	Else
		;script dir
		$runWorkingPath = @ScriptDir & "\"
		If $runEXEName <> "" And FileExists($runWorkingPath & $runEXEName) Then
			ConsoleWrite(">run .exe from script dir." & @CRLF)
			Tray_MinimizeWindow()
			ShellExecute($runEXEName, $runCMDString, $runWorkingPath)
		ElseIf StringCompare(GetGameIDString($iGameIdx),'KP', $STR_NOCASESENSEBASIC) = 0 Then ; $ID_KP1
			; try registry
			Local $runpathReg = _WinAPI_RegOpenKey( $HKEY_LOCAL_MACHINE, "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\kingpin.exe", $KEY_QUERY_VALUE)
			If @error Then
				Start_Kingpin_failed($iGameIdx, $runEXE)
			Else
				ConsoleWrite("run cmd from reg" & @CRLF)
				Local $tData = DllStructCreate('wchar[260]')
				_WinAPI_RegQueryValue($runpathReg, 'Path', $tData)
				Tray_MinimizeWindow()
				ShellExecute('kingpin.exe' , $runCMDString, DllStructGetData($tData, 1))
				_WinAPI_RegCloseKey($runpathReg)
			EndIf
		Else
			Start_Kingpin_failed($iGameIdx, $runEXE)
		EndIf
	EndIf
EndFunc
; -->Start_Kingpin
;========================================================
#EndRegion -->END RUN GAME EXE

#Region --> TRAY EVENTS
;========================================================
;--> tray events
TraySetOnEvent($TRAY_EVENT_PRIMARYUP, "Tray_Single") ;hypo todo: check focus?
	Func Tray_Single()
		local $stateMinimized = WinGetState($HypoGameBrowser)

		If  BitAND($stateMinimized,16) Then ; Return ;$WIN_STATE_MINIMIZED
			ConsoleWrite("traySingleClick " & $stateMinimized&@CRLF)
			Tray_RestoreWindow()
		Else
			ConsoleWrite("traySingleClick " & $stateMinimized&@CRLF)
			Tray_MinimizeWindow()
		EndIf
	EndFunc

TrayItemSetOnEvent($UI_Tray_max, "Tray_RestoreWindow")
	Func Tray_RestoreWindow()
		;EnableUIButtons(False)
		ResetRefreshTimmers()

		If $g_bWasMinimized Then
			If $g_bWasMaximized Then
				GuiSetState(@SW_SHOW,  $HypoGameBrowser)
				GuiSetState(@SW_MAXIMIZE,  $HypoGameBrowser)
				$g_bWasMaximized = True
			Else
				GuiSetState(@SW_SHOW,  $HypoGameBrowser)
				GuiSetState(@SW_RESTORE,  $HypoGameBrowser)
				;WinMove($HypoGameBrowser, $HypoGameBrowser, $g_aStoredWinSize[0], $g_aStoredWinSize[1], $g_aStoredWinSize[2], $g_aStoredWinSize[3])
				$g_bWasMaximized = False
			EndIf

			ConsoleWrite("Was minimized " & @CRLF)
			ConsoleWrite("get posi= " & WinGetPos($HypoGameBrowser)[0] &@CRLF)
			ConsoleWrite("posi= " & $g_aStoredWinSize[0]&" "& $g_aStoredWinSize[1] &@CRLF)

		Else ;-->displayed
			If $g_bWasMaximized Then
				ConsoleWrite("Window Restored " & @CRLF)
				GuiSetState(@SW_RESTORE,  $HypoGameBrowser)
				ConsoleWrite("Window Restored2"& @CRLF)
				$g_bWasMaximized = False
			Else
				GuiSetState(@SW_MAXIMIZE, $HypoGameBrowser)
				ConsoleWrite("Window Maximized " & @CRLF)
				$g_bWasMaximized = True
			EndIf

		EndIf
		$g_bWasMinimized = False
		;EnableUIButtons(True)
	EndFunc ;--> tray events

TrayItemSetOnEvent($UI_Tray_minimize, "Tray_MinimizeWindow")
	Func Tray_MinimizeWindow()
		Local $getWinState = WinGetState($HypoGameBrowser)
		if BitAND($getWinState,32) Then $g_bWasMaximized = True

		ConsoleWrite("Tray Minimize wasMax= "&$g_bWasMaximized & @CRLF)
		GuiSetState(@SW_MINIMIZE,  $HypoGameBrowser)
		If _IsChecked($UI_CBox_minToTray) Then
			GuiSetState(@SW_HIDE, $HypoGameBrowser) ;
		EndIf
		$g_bWasMinimized = True
	EndFunc

TrayItemSetOnEvent($UI_Tray_exit, "ExitScript")

;========================================================
#EndRegion  --> TRAY EVENTS


#Region --> AUDIO
Func selectAudoToPlay($gameType)
	Local $players

	If $gameType = 1 Then
		$players = $g_iPlayerCount_GS
	Else
		;mbrowser
		$players = $g_aPlayerCount_M[0] + $g_aPlayerCount_M[1] +  $g_aPlayerCount_M[2]
	EndIf
	ConsoleWrite("players="&$players&@CRLF)

	If $players = 0 Then Return
	If $players > 11 Then $players = 11

	SoundPlay($mp3path[$players-1] , 0)
EndFunc
#EndRegion

Func RestoreStatusBarMessage()
	GUICtrlSetData($MOTD_Input, $g_sStatusbarString_working)
	GUICtrlSetColor($MOTD_Input, 0)
	$g_sStatusbarString_working = ""
EndFunc

Func setTempStatusBarMessage($sMessage, $bSetRed = False)
	;only store current message if its not a temp message
	if $g_sStatusbarString_working = "" Then
		$g_sStatusbarString_working = GUICtrlRead($MOTD_Input)
	EndIf
	GUICtrlSetData($MOTD_Input , $sMessage)
	$g_statusBarTime = TimerInit() ; restore prior message after get servers
	;color text
	If $bSetRed Then
		GUICtrlSetColor($MOTD_Input, $COLOR_RED) ;todo check this against theme
	EndIf
EndFunc


;all loaded, set atcive
EnableUIButtons(True)
LoadGameOnStartupOpt(); check M-Startup
ApplyhotKey() ; apply hotkey

Global $hSize

While 1
	If $bEventStartKingpin = 1 Then
		$bEventStartKingpin = 0
		Start_Kingpin()
	EndIf

	if $g_iListview_changed Then
		if $g_iListview_changed = 336 Or $g_iListview_changed = 328 Or $g_iListview_changed = 999 Then
			ChangedListview_NowFillServerStrings() ; update server info
		EndIf
		$g_iListview_changed = 0
	EndIf

	If $bEventRightClick = 1 Then
		$bEventRightClick = 0
		RighttClickMenuKP()
	EndIf

	If $bEventRightClickM = 1 Then
		$bEventRightClickM = 0
		RighttClickMenuM()
	EndIf

	If ($g_bGuiResized = True) Then
		$hSize = WinGetPos($HypoGameBrowser)
		;ConsoleWrite($hSize[2]& " "& $hSize[3] &@CRLF)

		If ($hSize[2] < $GUIMINWID) And ($hSize[3] < $GUIMINHT) Then
			WinMove($HypoGameBrowser, '', Default, Default, $GUIMINWID, $GUIMINHT)
		ElseIf ($hSize[2] < $GUIMINWID) Then
			WinMove($HypoGameBrowser, '', Default, Default, $GUIMINWID, $hSize[3])
		ElseIf ($hSize[3] < $GUIMINHT) Then
			WinMove($HypoGameBrowser, '', Default, Default, $hSize[2], $GUIMINHT)
		EndIf

		SetWinSizeForMinimize() ;store window size for later
		$g_bGuiResized = False
	EndIf

	AutoRefreshTimer() ;check time for auto refresh
	Sleep(200)

	If Not ($g_statusBarTime = 0) Then
		If TimerDiff($g_statusBarTime) > $g_statusBar_timeOut Then
			$g_statusBarTime = 0
			RestoreStatusBarMessage()
		EndIf
	EndIf
WEnd
