#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=D:\_code_\hypoBrowser\main\hypo_browser.ico
#AutoIt3Wrapper_Outfile=HypoGameBrowser_1.0.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Comment='Kingpin Game Browser by hypo_v8'
#AutoIt3Wrapper_Res_Description='Game browser for Kingpin, KingpinQ3 and Quake2'
#AutoIt3Wrapper_Res_Fileversion=1.0.4.4
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gspyicons\1.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gspyicons\2.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gspyicons\3.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gspyicons\4.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gspyicons\5.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gspyicons\6.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gspyicons\7.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gspyicons\8.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gameicons\kp1.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gameicons\kpq3.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gameicons\q2.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gameicons\dday.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gameicons\hex.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gameicons\hex.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gameicons\hw.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gameicons\hr2.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gameicons\q1.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gameicons\q1.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gameicons\qw.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gameicons\sof.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gameicons\sof2.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gameicons\dak.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gameicons\alienarena.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gameicons\warsow.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gameicons\jk2.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gameicons\jk3.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gameicons\stef.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gameicons\pb2.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gameicons\unvan.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gameicons\sin.ico
#AutoIt3Wrapper_Res_Icon_Add=D:\_code_\hypoBrowser\gameicons\m.ico
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


;1.0.x todo
;      update offline list.
;      support additional games.
;      option to combine all masters lists into 1 big list.
;      option to set max servers to ping per 1000ms
;      handel GameSpy port with master protocol
;      keep listview sort after refresh
;      1/4 and 3/4 full icon
;      move game config to an external file
;      add setting to master. auto refresh all(needs combine masters implemented)
;      add setting to master...
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

;multi game ID (must match tab button order)
Global Enum _
	$ID_KP1, _
	$ID_KPQ3, _
	$ID_Q2, _
	$ID_DDAY, _
	$ID_HEX, _     ;hexen
	$ID_HEXFTE, _  ;hexen FTE
	$ID_HW, _      ;hexenworld
	$ID_HER2, _    ;Heretic
	$ID_Q1, _
	$ID_Q1FTE, _ ; quake FTE
	$ID_QW, _
	$ID_SOF1, _
	$ID_SOF2, _	 ;Soldier of Fortune II
	$ID_DAIK, _
	$ID_ALIENA, _
	$ID_WARSOW, _
	$ID_JK2, _   ;jedi outcast
	$ID_JK3, _   ;jedi Academy
	$ID_STEF1, _ ;Star Trek: Elite Force
	$ID_PAINT, _ ;PAINTBALL2
	$ID_UNVAN, _ ;Unvanquished
	$ID_SIN, _   ;todo ADD GAMES
	$COUNT_GAME, _ ;, _ ;store last game index
	$ID_M = $COUNT_GAME ;used for startup game index

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


Global Enum _ ;EOT
	$EOT_NONE, _
	$EOT_Q1, _
	$EOT_Q2, _
	$EOT_Q3, _
	$EOT_DP
Func GetData_EOT($idx)
	Switch $idx
		Case $EOT_NONE
			Return ''
		Case $EOT_Q1
			Return BinaryToString('0xd192', 1) ;'Ñ’'
		Case $EOT_Q2
			Return 'gp'
		Case $EOT_Q3
			Return 'EOT'
		Case $EOT_DP
			Return 'EOT'&chr(0)&chr(0)&chr(0)
	EndSwitch
	Return ''
EndFunc

Global Enum _
	$C2S_NONE, _
	$C2S_Q1, _
	$C2S_Q2, _
	$C2S_Q3, _
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
			Return 'ÿÿÿÿgetstatus'&@LF
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
	$C2M_HEX2, _
	$C2M_HW, _
	$C2M_AA, _
	$C2M_PB2, _
	$C2M_GS
Func GetData_C2M($idx)
	Switch $idx
		Case $C2M_Q1
			Return 'c'&@lf
		Case $C2M_Q2
			Return 'query'&@lf
		Case $C2M_Q3
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
	$M2C_HEX2, _
	$M2C_STEF1, _
	$M2C_PB2
Func GetData_M2C($idx)
	Switch $idx
		Case $M2C_Q1
			Return 'ÿÿÿÿd'
		Case $M2C_Q2
			Return 'ÿÿÿÿservers'
		Case $M2C_Q3
			Return 'ÿÿÿÿgetserversResponse'
		Case $M2C_HEX2
			Return 'ÿÿÿÿÿd'
		Case $M2C_STEF1
			Return 'ÿÿÿÿgetserversResponse '
		Case $M2C_PB2
			Return 'ÿÿÿÿserverlist2response'
	EndSwitch
	Return ''

EndFunc

Global Enum _
	$GNAME_MENU, _    ;0: gamename. used for dropdown menu and exe names
	$GNAME_SAVE, _    ;1: abbreviated names (save file)
	$GNAME_GS, _      ;2: gamespy name (to send to TCP master)
	$GNAME_DP, _      ;3: darkplace name (to send to master UDP)
	$NET_C2S, _       ;4 CLIENT-> SERVER  (send message to server) (gamespy port uses '\status\')
	$NET_S2C, _       ;5 SERVER-> CLIENT  (recieve message from server )(unused for now, they all have '\' after header)
	$NET_GS_P, _      ;6 CLIENT-> SERVER  (communication port, not game port)
	$NET_C2M, _       ;7 CLIENT-> MASTER (send message to master)
	$NET_C2M_Q3PRO, _ ;8 CLIENT-> MASTER (USE PROTOCOL) (send message to master using Q3 protocol 0/1)
	$NET_M2C, _       ;9 MASTER-> CLIENT (receive message from master) note: 1 additional char is trimed
	$NET_M2C_SEP, _   ;10 MASTER-> CLIENT (IP SEPERATOR) (receive message from master. ip seperator <length>)
	$NET_M2C_EOT, _   ;11 MASTER-> CLIENT (END OF DATA) (receive message from master. end of transmition string)
	$MASTER_ADDY, _   ;12
	$COUNT_CFG
Global $g_gameConfig[$COUNT_GAME][$COUNT_CFG] = [ _ ;FTE-Quake
 	['Kingpin',              'KP',     'kingpin',                 '', $C2S_GS,    $S2C_Q2, -10, $C2M_Q2,    '',      $M2C_Q2,     0, $EOT_Q2, "master.kingpin.info:28900|master.maraakate.org:28900|master.hambloch.com:28900|master.333networks.com:28900"], _ ;kingpin
	['KingpinQ3',            'KPQ3',   'kingpinQ3',    'KingpinQ3-1', $C2S_Q3,    $S2C_Q3,   0, $C2M_Q3,    '75',    $M2C_Q3,     1, $EOT_DP,   "master.kingpinq3.com:27950|master.kingpin.info:28900|master.ioquake3.org:27950|gsm.qtracker.com:28900"], _ ;kpq3
	['Quake2',               'Q2',     'Quake2',                  '', $C2S_Q2,    $S2C_Q2,   0, $C2M_Q2,    '',      $M2C_Q2,     0, $EOT_Q2,   "http://q2servers.com/?mod=&raw=1|http://q2servers.com/?g=dday&raw=1|master.netdome.biz:27900|master.quakeservers.net:27900|master.333networks.com:28900"], _ ;quake2
	['DDay: Normandy',       'DDAY',   'dday',                    '', $C2S_Q2,    $S2C_Q2,   0, $C2M_Q2,    '',      $M2C_Q2,     0, $EOT_Q2,   "http://q2servers.com/?g=dday&raw=1"], _ ;dday
	['Hexen2',               'HEX2',   'hexen2',                  '', $C2S_HEX2,  $S2C_HEX2, 0, $C2M_HEX2,  '',      $M2C_HEX2,   0, $EOT_Q2,   "https://hexenworld.org/hexen2|master.maraakate.org:28900|master.hexenworld.org:27900|master.frag-net.com:27900"], _ ;hexen2
	['Hexen2 FTE',           'HEX2FTE','hexen2fte',     'FTE-Hexen2', $C2S_Q3,    $S2C_Q3,   0, $C2M_Q3,    '3',     $M2C_Q3,     1, $EOT_NONE, "master.frag-net.com:27950|master.maraakate.org:27950|master.maraakate.org:28900"], _  ;hexen2 FTEQW	;todo check gamespy
	['HexenWorld',           'HEXW',   'hexenworld',              '', $C2S_HW,    $S2C_HW,   0, $C2M_HW,    '',      $M2C_HEX2,   0, $EOT_NONE, "master.hexenworld.org:27900|master.maraakate.org:28900|https://www.qtracker.com/server_list_details.php?game=hexenworld|master.frag-net.com:27900"], _  ;hexenworld. ÿ prefix], _
	['Heretic2',             'HER2',   'heretic2',                '', $C2S_GS,    $S2C_Q2,   1, $C2M_Q2,    '',      $M2C_Q2,     0, $EOT_Q2,   "https://hexenworld.org/heretic2|master.openspy.net:28900|master.333networks.com:28900|master.maraakate.org:28900"], _  ;heretic2], _
	['Quake1',               'Q1',     'quake1',                  '', $C2S_Q1,    $S2C_Q1,   0, $C2M_Q1,    '',      $M2C_Q1,     0, $EOT_Q1,   "master.maraakate.org:28900|https://www.quakeservers.net/lists/servers/global.txt|gsm.qtracker.com:28900"], _  ;quake1 EOT(0xd192)], _
	['Quake1 FTE',           'Q1FTE',  'quake1fte',      'FTE-Quake', $C2S_Q3,    $S2C_Q3,   0, $C2M_Q3,    '3',     $M2C_Q3,     1, $EOT_NONE, "master.frag-net.com:27950|master.maraakate.org:27950|master.maraakate.org:28900"], _  ;quake1 FTEQW
	['QuakeWorld',           'QW' ,    'quakeworld',              '', $C2S_Q2,    $S2C_Q1,   0, $C2M_Q1,    '',      $M2C_Q1,     0, $EOT_Q1,   "master.quakeworld.nu:27000|master.quakeservers.net:27000|qwmaster.fodquake.net:27000|qwmaster.ocrana.de:27000|master.maraakate.org:28900"], _  ;quakeworld EOT(0xd192)], _
	['Soldier of Fortune',   'SOF1',   'sofretail',               '', $C2S_GS,    $S2C_Q2,   1, $C2M_Q2,    '',      $M2C_Q2,     0, $EOT_Q2,   "sof1master.megalag.org:28900|gsm.qtracker.com:28900|https://www.qtracker.com/server_list_details.php?game=soldieroffortune|master.333networks.com:28900"], _  ;sof1], _
	['Soldier of Fortune II','SOF2',   'sof2',                    '', $C2S_Q3,    $S2C_Q3,   0, $C2M_Q3,    '2004',  $M2C_Q3,     1, $EOT_DP,   "master.1fxmod.org:20110|master.sof2.ravensoft.com:20110|http://www.qtracker.com/server_list_details.php?game=soldieroffortune2|master.maraakate.org:28900"], _  ;Soldier of Fortune II], _ ; Soldier of Fortune II
	['Daikatana',            'DAIK',   'daikatana',               '', $C2S_GS,    $S2C_Q2, -10, $C2M_Q2,    '',      $M2C_Q2,     0, $EOT_Q2,   "master.maraakate.org:28900|master.333networks.com:28900|master.openspy.net:28900|gsm.qtracker.com:28900"], _  ;daikatana], _
	['AlienArena',           'ALIENA', 'alienarna',               '', $C2S_Q2,    $S2C_Q2,   0, $C2M_AA,    '',      $M2C_Q2,     0, $EOT_NONE, "master.alienarena.org:27900|master2.alienarena.org:27900|master.maraakate.org:28900|master.333networks.com:28900|master.openspy.net:28900"], _  ;AlienArena], _
	['Warsow',               'WARSO',  'warsow',            'Warsow', $C2S_Q3,    $S2C_Q3,   0, $C2M_Q3,    '12',    $M2C_Q3,     1, $EOT_DP,   "dpmaster.deathmask.net:27950|ghdigital.com:27950|excalibur.nvg.ntnu.no:27950|eu.master.warsow.gg:27950|master.maraakate.org:28900"], _  ;Warsow'], _ ; Qfusion
	['Jedi: Outcast',        'JK2',    'starwarsjediknight',      '', $C2S_Q3,    $S2C_Q3,   0, $C2M_Q3,    '16',    $M2C_Q3,     1, $EOT_DP,   "master.jkhub.org:28060|masterjk2.ravensoft.com:28060|master.jk2mv.org:28060|master.maraakate.org:28900"], _  ;Jedi Outcast], _ ; jedi outcast
	['Jedi: Academy',        'JK3',    'jk3',                     '', $C2S_Q3,    $S2C_Q3,   0, $C2M_Q3,    '26',    $M2C_Q3,     1, $EOT_DP,   "master.jkhub.org:29060|masterjk3.ravensoft.com:29060|master.maraakate.org:28900"], _  ;jedi Academy], _ ; jedi Academy
	['Star Trek: EF',        'STEF1',  'stef1',                   '', $C2S_Q3,    $S2C_Q3,   0, $C2M_Q3,    '24',    $M2C_STEF1,  1, $EOT_Q3,   "master.stvef.org:27953|master.stef1.daggolin.de:27953|master.stef1.ravensoft.com:27953|efmaster.tjps.eu:27953|master.maraakate.org:28900"], _  ;Star Trek: Elite Force], _ ; Star Trek: Elite Force
	['PaintBall 2',          'PAINT',  'paintball',               '', $C2S_Q2,    $S2C_Q2,   0, $C2M_PB2,   '',      $M2C_PB2,    0, $EOT_Q2,   "dplogin.com:27900|http://www.otb-server.de/serverlist.txt|http://dplogin.com/serverlist.php"], _  ;paintball], _
	['Unvanquished',         'UNVAN',  'unvanquished',            '', $C2S_Q3,    $S2C_Q3,   0, $C2M_Q3,    '86',    $M2C_Q3,     1, $EOT_NONE, "master.unvanquished.net:27950|master2.unvanquished.net:27950|master.ioquake3.org:27950"], _  ;unvanquished], _ ;UNVANQUISHED ;master not using darkplace
	['Sin',                  'SIN',    'sin',                     '', $C2S_GS,    $S2C_Q2,   1, $C2M_Q2,    '',      $M2C_Q2,     0, $EOT_Q2,   "master.maraakate.org:28900|master.gameranger.com|master.333networks.com:28900"] _   ;sin]
] ;  #0                      #1        #2                         #3   #4         #5         #6 #7          #8       #9          #10 #11
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
Global $g_aFavList[$COUNT_GAME] ;= ["", "", ""]
Global $g_aGameSetup_Master_Combo[$COUNT_GAME] ;idx
Global $g_aGameSetup_Master_Cust[$COUNT_GAME] ;string
Global $g_aGameSetup_EXE[$COUNT_GAME]   ;path
Global $g_aGameSetup_Name[$COUNT_GAME]   ;string
Global $g_aGameSetup_RunCmd[$COUNT_GAME] ;string
Global $g_aGameSetup_AutoRefresh[$COUNT_GAME] ;bool
Global $g_aGameSetup_Master_Proto[$COUNT_GAME]


;========
;main UI
Global $HypoGameBrowser, $tabGroupGames, $UI_Combo_gameSelector, $UI_TabSheet[$COUNT_TABS]
Global $UI_Btn_pingList, $UI_Btn_loadFav, $UI_Btn_offlineList, $UI_Btn_settings, $UI_Btn_expand, $UI_Btn_refreshMaster
Global $UI_Icon_hypoLogo, $UI_Tray_exit, $UI_Tray_max, $UI_Tray_minimize
;games TAB
Global $UI_ListV_svData_A, $UI_ListV_svData_B, $UI_ListV_svData_C
;settings TAB
Global $UI_Combo_master, $UI_Text_setupTitle, $UI_In_master_Cust, $UI_In_gamePath, $UI_In_playerName, $UI_In_runCmd, $UI_In_master_proto
Global $UI_Text_masterAddress, $UI_Text_playerName, $UI_Text_runCmd, $UI_Btn_gamePath, $UI_Text_setupBG, $UI_Btn_gameRefresh
Global $UI_CBox_autoRefresh, $UI_Combo_M_addServer, $UI_Combo_hkey, $UI_Label_hotkey, $UI_TextAbout, $UI_Grp_hosted, $UI_CBox_theme
Global $UI_Grp_gameConfig, $UI_CBox_tryNextMaster, $UI_CBox_useMLink, $UI_In_refreshTime, $UI_Tex_refreshTime
Global $UI_Grp_mBrowser, $UI_In_getPortM, $UI_MHost_removeServer, $UI_MHost_addServer, $UI_MHost_excludeSrever
Global $UI_Grp_webLinks, $UI_Text_linkKPInfo, $UI_Text_linkMServers, $UI_Text_linkSupport, $UI_Text_linkContactM
Global $UI_CBox_sound, $UI_Grp_gameSetup, $UI_Text_linkKPQ3, $UI_Text_linkHypoEmail, $UI_Text_linkDiscord
Global $UI_Grp_browserOpt, $UI_CBox_minToTray, $UI_In_hotKey, $UI_Btn_setHotKey
;m-browser TAB
Global $UI_ListV_mb_ABC[3], $UI_Text_countMPlayers
;chat TAB
Global $UI_Text_chatBG, $UI_Btn_chatConnect, $UI_Obj_webPage = _IECreateEmbedded(), $UI_Obj_webPage_ctrl
;statusbar
Global $MOTD_Input, $UI_Prog_getServer, $UI_Text_masterDisplay ;$MOTD_Background,
;main  gui
Global $aDPI[2]
Global $HypoGameBrowser_AccelTable[1][2] ;todo local?

;========================================================
; -->Global settings
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
Global $g_hSocketMasterUDP = -1 ; socket for master communication
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

Global $g_tmpStatusbarString = ""
Global $g_statusBarTime = 0
;Global $g_ResizeListView = 0

Global $g_bAutoRefresh = False ; = _GUICtrlComboBox_GetCurSel($UI_CBox_autoRefresh)
Global $g_bAutoRefreshActive = False ;auto refresh prevents popup dialogs
Global $g_iAutoRefreshGame = 0 ; last game refreshed(either active or setup enabled auto refresh)
Global $g_iTimeInputBox = 1;

Global $g_UseTheme = False

;==> color for visual theme
Global Const $COLOR_HYPO_GREY = 0x373737 	;grey (0x7a7a7a)
Global Const $COLOR_HYPO_BLACK = 0x272727	;dark grey. button color (0xe58816)
Global Const $COLOR_HYPO_ORANGE = 0xff8c00 	;orange

;input enabled
Global Const $COLOR_IN1_TEXT = 0xe58816 ;orange
Global Const $COLOR_IN1_BG = 0x202020   ;black
;input disabled
Global Const $COLOR_IN2_TEXT = 0xbbbbbb ;GREY disabled
Global Const $COLOR_IN2_BG = 0x373737   ;orange disabled

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
BuildIconList()
_GDIPlus_GraphicsGetDPIRatio($aDPI) ;windows font scale

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
			$UI_ListV_svData_B = GUICtrlCreateListView("Name|Frags|Ping|Deaths|Team", 65, 420, 445, 168, BitOR($GUI_SS_DEFAULT_LISTVIEW,$LVS_AUTOARRANGE,$LVS_ALIGNLEFT,$WS_HSCROLL,$WS_VSCROLL), BitOR($WS_EX_CLIENTEDGE,$LVS_EX_SUBITEMIMAGES,$LVS_EX_FULLROWSELECT))
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 200)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 50)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 50)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 50)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 4, 50)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT)
			$UI_ListV_svData_C = GUICtrlCreateListView("Rules|Value", 515, 420, 288, 168, BitOR($GUI_SS_DEFAULT_LISTVIEW,$LVS_AUTOARRANGE,$LVS_ALIGNLEFT,$WS_HSCROLL,$WS_VSCROLL), BitOR($WS_EX_CLIENTEDGE,$LVS_EX_SUBITEMIMAGES,$LVS_EX_FULLROWSELECT))
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 100)
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 120)
			GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
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
			$UI_Grp_gameSetup = GUICtrlCreateGroup("Game Setup", 73, 38, 216, 292, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))
			GUICtrlSetFont(-1, 9, 400, 0, "MS Sans Serif")
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
			$UI_Text_setupTitle = GUICtrlCreateLabel("Kingpin", 85, 62, 192, 24, BitOR($SS_CENTER,$SS_CENTERIMAGE), $WS_EX_STATICEDGE)
			GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
			$UI_Text_masterAddress = GUICtrlCreateLabel("Master Address", 81, 106, 76, 13)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
			$UI_Combo_master = GUICtrlCreateCombo("", 81, 122, 164, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
			$UI_In_master_proto = GUICtrlCreateInput("74", 249, 122, 32, 21, BitOR($GUI_SS_DEFAULT_INPUT,$WS_BORDER), $WS_EX_STATICEDGE)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
			GUICtrlSetTip(-1, "Game Protocol for IOQ3 masters"&@CRLF&"74=Beta, 75=Release")
			$UI_In_master_Cust = GUICtrlCreateInput("gsm.qtracker.com:28900", 81, 150, 200, 21, BitOR($GUI_SS_DEFAULT_INPUT,$WS_BORDER), $WS_EX_STATICEDGE)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
			$UI_Btn_gameRefresh = GUICtrlCreateCheckbox("AutoRefresh", 81, 178, 85, 21)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
			GUICtrlSetTip(-1, "Add current game to the AutoRefresh list.")
			$UI_Btn_gamePath = GUICtrlCreateButton("Game Path", 81, 242, 65, 21)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
			$UI_In_gamePath = GUICtrlCreateInput("Game.exe", 149, 242, 132, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY,$WS_BORDER), $WS_EX_STATICEDGE)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
			$UI_Text_playerName = GUICtrlCreateLabel("Player Name", 81, 270, 64, 21, $SS_CENTERIMAGE)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
			$UI_In_playerName = GUICtrlCreateInput("", 149, 270, 132, 21, BitOR($GUI_SS_DEFAULT_INPUT,$WS_BORDER), $WS_EX_STATICEDGE)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
			$UI_Text_runCmd = GUICtrlCreateLabel("Commands", 81, 298, 60, 21, $SS_CENTERIMAGE)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
			GUICtrlSetTip(-1, "Addition commandline arguments to add when running game")
			$UI_In_runCmd = GUICtrlCreateInput("+set developer 1", 149, 298, 132, 21, BitOR($GUI_SS_DEFAULT_INPUT,$WS_BORDER), $WS_EX_STATICEDGE)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
			GUICtrlCreateGroup("", -99, -99, 1, 1)
			;end master settings
			;================

			;===============
			;browser options
			$UI_grp_browserOpt = GUICtrlCreateGroup("Browser Options", 297, 38, 128, 292, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$UI_CBox_sound = GUICtrlCreateCheckbox("Play Sounds", 309, 62, 105, 21)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Play a sound if there is a player in a server")
				$UI_CBox_minToTray = GUICtrlCreateCheckbox("Minimize to tray", 309, 86, 105, 21)
				GUICtrlSetState(-1, $GUI_CHECKED)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "This is used in tray menu(Minimize) and on game lunch")
				$UI_CBox_theme = GUICtrlCreateCheckbox("Dark Theme", 309, 110, 105, 21)
				GUICtrlSetState(-1, $GUI_CHECKED)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Enable custom colors on GUI."&@CRLF&"Requires restart.")
				$UI_CBox_useMLink = GUICtrlCreateCheckbox("Use M Web Link", 309, 134, 105, 21)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Enable web links to connect to 'servers' listed on M's Website."& @CRLF&"Make sure to set Kingpin Game Path first. Then enable option.")
				$UI_CBox_autoRefresh = GUICtrlCreateCheckbox("Auto Refresh", 309, 194, 97, 21)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Auto refresh active game, or cycle through enabled games in Game-Setup")
				$UI_In_refreshTime = GUICtrlCreateInput("3", 309, 218, 29, 21, BitOR($GUI_SS_DEFAULT_INPUT,$WS_BORDER), $WS_EX_STATICEDGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Time in Minutes between auto refresh")
				$UI_Tex_refreshTime = GUICtrlCreateLabel("Refresh Time", 341, 218, 67, 21, $SS_CENTERIMAGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Time in Minutes between auto refresh")
				$UI_Label_hotkey = GUICtrlCreateLabel("Hotkey (Restore)", 309, 258, 102, 13)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$UI_Combo_hKey = GUICtrlCreateCombo("", 309, 274, 104, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "ALT +|CTRL +|CTRL + ALT +", "ALT +")
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$UI_In_hotKey = GUICtrlCreateInput("", 309, 298, 33, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_LOWERCASE,$WS_BORDER), $WS_EX_STATICEDGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "HotKey. Accepts a-z")
				$UI_Btn_setHotKey = GUICtrlCreateButton("Apply", 349, 298, 64, 21)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Apply a Windows global hotkey")
				$UI_CBox_tryNextMaster = GUICtrlCreateCheckbox("Ping Next Master", 309, 158, 105, 21)
				GUICtrlSetState(-1, $GUI_CHECKED)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "If master fails to respond, ping the next one in list.")
			GUICtrlCreateGroup("", -99, -99, 1, 1)
			;end browser
			;===============

			;=============
			;hosted server
			$UI_Grp_hosted = GUICtrlCreateGroup("Hosted Server", 433, 38, 109, 172, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$UI_MHost_addServer = GUICtrlCreateButton("Add Server", 441, 62, 93, 25)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Add a server to 'M' Website listing so game can be seen in M-Browser")
				$UI_MHost_removeServer = GUICtrlCreateButton("Remove Server", 441, 90, 93, 25)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Remove a server to 'M' Website listing so game can not be seen in M-Browser")
				$UI_MHost_excludeSrever = GUICtrlCreateButton("Exclude Server", 441, 118, 93, 25)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Exclude a server from 'M' Website listing so game can not be seen in M-Browser. Even if listed at Qtracker")
				$UI_Combo_M_addServer = GUICtrlCreateCombo("", 441, 150, 93, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "kingpin|kingpinq3|quake2", "kingpin")
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$UI_In_getPortM = GUICtrlCreateInput("31510", 441, 178, 93, 21, BitOR($GUI_SS_DEFAULT_INPUT,$WS_BORDER), $WS_EX_STATICEDGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Set Server port" & @CRLF & "Default Game Kingpin")
			GUICtrlCreateGroup("", -99, -99, 1, 1)
			;end hosted
			;=============

			;=============
			;weblinks
			$UI_Grp_webLinks = GUICtrlCreateGroup("Web Links", 549, 38, 124, 172, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$UI_Text_linkKPInfo = GUICtrlCreateLabel("Kingpin.info", 557, 58, 99, 17, $SS_CENTERIMAGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Kingpin.info Website")
				GUICtrlSetCursor (-1, 0)
				$UI_Text_linkMServers = GUICtrlCreateLabel("M's Server List", 557, 78, 99, 17, $SS_CENTERIMAGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Server List Website (hambloch.com)")
				GUICtrlSetCursor (-1, 0)
				$UI_Text_linkContactM = GUICtrlCreateLabel("Contact M", 557, 98, 99, 17, $SS_CENTERIMAGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Contact M Via His Website (hambloch.com)")
				GUICtrlSetCursor (-1, 0)
				$UI_Text_linkKPQ3 = GUICtrlCreateLabel("KingpinQ3", 557, 118, 99, 17, $SS_CENTERIMAGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "KingpinQ3 Website")
				GUICtrlSetCursor (-1, 0)
				$UI_Text_linkDiscord = GUICtrlCreateLabel("Kingpin Discord", 557, 138, 99, 17, $SS_CENTERIMAGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Kingpin Discord")
				GUICtrlSetCursor (-1, 0)
				$UI_Text_linkHypoEmail = GUICtrlCreateLabel("Contact Hypov8", 557, 158, 99, 17, $SS_CENTERIMAGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Email Me")
				GUICtrlSetCursor (-1, 0)
				$UI_Text_linkSupport = GUICtrlCreateLabel("Support Me", 557, 178, 99, 17, $SS_CENTERIMAGE)
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				GUICtrlSetTip(-1, "Buy Me a Coffee")
				GUICtrlSetCursor (-1, 0)
			GUICtrlCreateGroup("", -99, -99, 1, 1)
			;weblinks
			;=============

			;=============
			;mbrowser
			$UI_Grp_mBrowser = GUICtrlCreateGroup("M Browser Info", 433, 214, 240, 116, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))
				GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
				$UI_TextAbout = GUICtrlCreateEdit("", 441, 234, 225, 89, BitOR($ES_NOHIDESEL,$ES_READONLY))
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
	;~ $UI_Combo_gameSelector = GUICtrlCreateCombo("", 652, 10, 149, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
	$UI_Combo_gameSelector = _GUICtrlComboBoxEx_Create($HypoGameBrowser, "", 652, 8, 149, 525, $CBS_DROPDOWNLIST )
	;GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	;~ $UI_Text_gameSelector = GUICtrlCreateLabel("Game", 592, 10, 49, 21, BitOR($SS_RIGHT,$SS_CENTERIMAGE))
	;~ GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)


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
	$UI_Btn_expand = GUICtrlCreateButton("^", 30, 552, 31, 31, $BS_BITMAP) ; 65
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Expand")

	;$UI_Icon_hypoLogo = GUICtrlCreateIcon(@AutoItExe, -1, 3, 4, 56, 56)
	;$UI_Icon_hypoLogo = GUICtrlCreatePic("", 3, 4, 56, 56)
	;$UI_Icon_hypoLogo = GUICtrlCreateButton("", 3, 4, 56, 56)
	$UI_Icon_hypoLogo = GUICtrlCreateLabel("", 3, 4, 56, 56, $SS_SUNKEN, 0)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1, "Support Me"&@CRLF&"Buy Me a Coffee")
	GUICtrlSetCursor (-1, 0)

	;==> statusbar background
	;~ $MOTD_Background = GUICtrlCreateLabel("", 61, 589, 746, 22) ;, $WS_CLIPSIBLINGS)
	;~ GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT)

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
	Local $sNames = ""

	_GUICtrlComboBox_SetDroppedWidth($UI_Combo_master, 350)
	WinSetTitle($HypoGameBrowser,"", string($versionName &"  (v"& $versionNum&")"))
	GUICtrlSetData($MOTD_Input , "Use Refresh to receive list from master. Use Ping to updates current servers in view. Offline loads internal servers")
	GUICtrlSetTip($UI_In_master_proto, _
		"Game Protocol for Q3 UDP masters"&@CRLF& _
		"  KingpinQ3:  74=Beta1, 75=Beta2"&@CRLF& _
		"  Quake3:  66=v1.30 67=1.31 68=1.32" &@CRLF& _
		"  Unvanquished:  86=v0.55"&@CRLF& _
		"  Warsow:  22=v2.10"&@CRLF& _
		"  Jedi Out:  16=v1.04 15=v1.02"&@CRLF& _
		"  Jedi Academy:  26=v1.01 25=v1.0"&@CRLF& _
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
		_GUICtrlComboBoxEx_AddString($UI_Combo_gameSelector, $g_gameConfig[$i][$GNAME_MENU], $i, $i)
	Next
	_GUICtrlComboBoxEx_AddString($UI_Combo_gameSelector, 'M-Browser (Tab)', $COUNT_GAME, $COUNT_GAME)
	_GUICtrlComboBoxEx_EndUpdate($UI_Combo_gameSelector)

	;;;;;;$sNames &= "|M-Browser (Tab)"
	;;;;;;;;;;GUICtrlSetData($UI_Combo_gameSelector, $sNames , $g_gameConfig[$ID_KP1][$GNAME_MENU])
EndFunc

Func BuildIconList()
	for $i = 0 to $COUNT_GAME
		_GUIImageList_AddIcon($ImageList1, @ScriptFullPath, $i+ 4, True)
	Next

	for $i = 0 to $COUNT_GAME
		_GUIImageList_AddIcon($ImageListGames, @ScriptFullPath, $i+12)
	Next
EndFunc

Func _GDIPlus_GraphicsGetDPIRatio(ByRef $aDPI)
	local $iDPIDef = 96
	$aDPI[0] = 1
	$aDPI[1] = 1

	_GDIPlus_Startup()
	Local $hGfx = _GDIPlus_GraphicsCreateFromHWND(0)
	If Not @error Then
		#forcedef $__g_hGDIPDll, $ghGDIPDll
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
	if _IsChecked($UI_CBox_theme) Then
		$g_UseTheme = True
		GUISetColor()
		SetUI_masterCust_State()
	EndIf

	;$g_bAutoRefresh = _IsChecked($UI_CBox_autoRefresh)
	;_GUICtrlEdit_SetReadOnly($UI_In_refreshTime, $g_bAutoRefresh)
	UI_CBox_autoRefreshChanged()
	ConsoleWrite("!startup refresh id:"&$g_bAutoRefresh&@CRLF)

	_ResourceSetImageToCtrl($UI_Icon_hypoLogo, "logo_1") ;todo use icon

	FileInstall("D:\_code_\hypoBrowser\sounds\M_old\1_po.mp3",      @TempDir & "\")
	FileInstall("D:\_code_\hypoBrowser\sounds\M_old\2_po.mp3",      @TempDir & "\")
	FileInstall("D:\_code_\hypoBrowser\sounds\M_old\3_po.mp3",      @TempDir & "\")
	FileInstall("D:\_code_\hypoBrowser\sounds\M_old\4_po.mp3",      @TempDir & "\")
	FileInstall("D:\_code_\hypoBrowser\sounds\M_old\5_po.mp3",      @TempDir & "\")
	FileInstall("D:\_code_\hypoBrowser\sounds\M_old\6_po.mp3",      @TempDir & "\")
	FileInstall("D:\_code_\hypoBrowser\sounds\M_old\7_po.mp3",      @TempDir & "\")
	FileInstall("D:\_code_\hypoBrowser\sounds\M_old\8_po.mp3",      @TempDir & "\")
	FileInstall("D:\_code_\hypoBrowser\sounds\M_old\9_po.mp3",      @TempDir & "\")
	FileInstall("D:\_code_\hypoBrowser\sounds\M_old\10_po.mp3",     @TempDir & "\")
	FileInstall("D:\_code_\hypoBrowser\sounds\M_old\10plus_po.mp3", @TempDir & "\")

	GUISetState(@SW_SHOW, $HypoGameBrowser) ;ready to be shown

	_GUICtrlListView_SetImageList($UI_ListV_svData_A, $ImageList1, 1)
	GUICtrlRegisterListViewSort($UI_ListV_svData_A, "ListViewSort_A")	;updateLV
	;_GUICtrlListView_SimpleSort($UI_ListV_svData_A, $g_vSortSense_A, 0, False)
	;_GUICtrlListView_RegisterSortCallBack($UI_ListV_svData_A, 1, True)
	;_GUICtrlListView_RegisterSortCallBack($UI_ListV_svData_C, 0, True)

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
		$UI_Grp_gameConfig, $UI_Grp_webLinks, _
		$UI_Grp_mBrowser, $UI_CBox_useMLink, _ ;M config
		$UI_Text_linkKPInfo, $UI_Text_linkMServers, $UI_Text_linkSupport, $UI_Text_linkContactM, _ ;web links
		$UI_Text_linkKPQ3, $UI_Text_linkHypoEmail, $UI_Text_linkDiscord, _ ;web links
		$UI_CBox_sound, $UI_Tex_refreshTime, $UI_Grp_gameSetup, $UI_CBox_autoRefresh, $UI_CBox_tryNextMaster, $UI_Btn_gameRefresh, _
		$UI_Grp_browserOpt, $UI_CBox_minToTray, $UI_Label_hotkey, $UI_TextAbout, $UI_Grp_hosted, $UI_CBox_theme, _
		$UI_Text_masterAddress, $UI_Text_playerName, $UI_Text_runCmd, $UI_Btn_gamePath, $UI_Text_setupTitle]

	GUICtrlSetDefColor($COLOR_HYPO_ORANGE,$HypoGameBrowser)
	GUISetBkColor($COLOR_HYPO_GREY, $HypoGameBrowser)

	;set all gui item colors
	For $iloop = 0 to UBound($hwNames1)-1
		GUICtrlSetColor	 ($hwNames1[$iloop], $COLOR_HYPO_ORANGE)
		GUICtrlSetBkColor($hwNames1[$iloop], $COLOR_HYPO_GREY)
	Next

	;statusbar (win/user set colors)
	local $hColor_btn = Int("0x" & StringRegExpReplace(Hex(_WinAPI_GetSysColor($COLOR_BTNFACE), 6), "(..)(..)(..)", "\3\2\1"))
	;GUICtrlSetBkColor($MOTD_Background, $hColor_btn)
	GUICtrlSetBkColor($MOTD_Input, $hColor_btn)
	;GUICtrlSetBkColor($UI_Text_gameSelector, $hColor_btn)
	GUICtrlSetBkColor($UI_Text_masterDisplay, $hColor_btn)

	;button colors
	Local Const $hwNamesBtn = [$UI_Btn_refreshMaster, $UI_Btn_pingList, $UI_Btn_loadFav, $UI_Btn_offlineList, $UI_Btn_settings, $UI_Btn_expand, _
		$UI_MHost_addServer, $UI_MHost_removeServer, $UI_MHost_excludeSrever, $UI_Btn_gamePath, $UI_Btn_setHotKey, $UI_Btn_chatConnect]
	For $iloop = 0 to UBound($hwNamesBtn)-1
		GUICtrlSetColor	 ($hwNamesBtn[$iloop], $COLOR_HYPO_ORANGE)
		GUICtrlSetBkColor($hwNamesBtn[$iloop], $COLOR_HYPO_BLACK)
	Next

	;settings inputs
	Local Const $hwNamesInput = [$UI_In_hotKey, $UI_In_playerName, $UI_In_runCmd, _
		$UI_In_master_proto, $UI_In_getPortM, $UI_In_refreshTime] ;$UI_In_master_Cust,
	For $iloop = 0 to UBound($hwNamesInput)-1
		GUICtrlSetColor	 ($hwNamesInput[$iloop], $COLOR_IN1_TEXT)
		GUICtrlSetBkColor($hwNamesInput[$iloop], $COLOR_IN1_BG)
	Next

	;disabled input colors
	Local Const $hwInputDis = [$UI_Combo_M_addServer, $UI_Combo_hkey, $UI_Combo_master, $UI_Combo_gameSelector, $UI_In_gamePath]
	For $iloop = 0 to UBound($hwInputDis)-1
		GUICtrlSetColor	 ($hwInputDis[$iloop], $COLOR_IN2_TEXT)
		GUICtrlSetBkColor($hwInputDis[$iloop], $COLOR_IN2_BG)
	Next

	;remove theme on progressbar
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($UI_Prog_getServer), "wstr", 0, "wstr", 0)

	;$ProgressBar
	GUICtrlSetColor($UI_Prog_getServer, $COLOR_HYPO_ORANGE)
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

Func SetUI_masterCust_State()
	Local $idx = _GUICtrlComboBox_GetCurSel($UI_Combo_master)

	ConsoleWrite(">master changed idx="&$idx&@CRLF)
	If $idx <= 0 Then ;catch -1
		_GUICtrlEdit_SetReadOnly($UI_In_master_Cust, False)
		if $g_UseTheme Then
			GUICtrlSetColor($UI_In_master_Cust, $COLOR_IN1_TEXT)
			GUICtrlSetBkColor($UI_In_master_Cust, $COLOR_IN1_BG)
		EndIf
		;GUICtrlSetState($UI_In_master_Cust, $GUI_ENABLE)
	Else
		_GUICtrlEdit_SetReadOnly($UI_In_master_Cust, True)
		if $g_UseTheme Then
			GUICtrlSetColor($UI_In_master_Cust, $COLOR_IN2_TEXT)
			GUICtrlSetBkColor($UI_In_master_Cust, $COLOR_IN2_BG)
		EndIf
		;GUICtrlSetState($UI_In_master_Cust, $GUI_DISABLE)
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

	ConsoleWrite('-game sel changed'&@CRLF)
	FillServerListView_popData($iGameIdx, $ListViewA) ;update listview ip
	FillListView_A_FullData($iGameIdx, $aServerIdx, 0, $iCount-1) ;full update

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
		Case $ID_M
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
	if $idx	= -1 then
		$idx = 0
		ConsoleWrite("!fixed combo index1"&@CRLF)
	Else
		Local $iCount = StringSplit($g_gameConfig[$iGameIdx][$MASTER_ADDY], "|")[0] ; _GUICtrlComboBox_GetCount($UI_Combo_master)
		;ConsoleWrite(">Combo id:"&$iCount&" game:"& $iGameIdx&@CRLF)
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
		;ConsoleWrite("+Game Setup stored id:"&$idx& " g:" & $g_gameConfig[$idx][$GNAME_MENU]&@CRLF)
		;ConsoleWrite("-path:"&$g_aGameSetup_EXE[$idx] &@CRLF&"-UI:"&GUICtrlRead($UI_In_gamePath)&@CRLF)
		$g_aGameSetup_Master_Combo[$idx] = _GUICtrlComboBox_GetCurSel($UI_Combo_master)
		$g_aGameSetup_Master_Cust[$idx]  = GUICtrlRead($UI_In_master_Cust)
		$g_aGameSetup_Master_Proto[$idx] = GUICtrlRead($UI_In_master_proto)
		$g_aGameSetup_EXE[$idx]          = GUICtrlRead($UI_In_gamePath)
		$g_aGameSetup_Name[$idx]         = GUICtrlRead($UI_In_playerName)
		$g_aGameSetup_RunCmd[$idx]       = GUICtrlRead($UI_In_runCmd)
		$g_aGameSetup_AutoRefresh[$idx]  = _IsChecked($UI_Btn_gameRefresh)
		;check counts
		FixGameComboIndex($g_aGameSetup_Master_Combo[$idx], $idx)
	EndIf
	;_ArrayDisplay($g_aGameSetup_AutoRefresh)
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
		_GUICtrlComboBox_SetCurSel($UI_Combo_master, $g_aGameSetup_Master_Combo[$idx])   ;selection id
		GUICtrlSetData($UI_In_master_Cust, $g_aGameSetup_Master_Cust[$idx])
		GUICtrlSetData($UI_In_master_proto, $g_aGameSetup_Master_Proto[$idx])
		GUICtrlSetData($UI_In_gamePath, $g_aGameSetup_EXE[$idx])
		GUICtrlSetData($UI_In_playerName, $g_aGameSetup_Name[$idx])
		GUICtrlSetData($UI_In_runCmd, $g_aGameSetup_RunCmd[$idx])
		_SetCheckedState($UI_Btn_gameRefresh, $g_aGameSetup_AutoRefresh[$idx])
	ElseIf $idx = $ID_M Then
		;$g_iTabNum = $TAB_GB
		GUICtrlSetData($UI_Text_setupTitle, "M-Browser")
		GUICtrlSetData($UI_Combo_master, "|") ;master list. rebuild
		_GUICtrlComboBox_SetCurSel($UI_Combo_master, 0)   ;selection id
		GUICtrlSetData($UI_In_master_Cust, "")
		GUICtrlSetData($UI_In_master_proto, "")
		GUICtrlSetData($UI_In_gamePath, "")
		GUICtrlSetData($UI_In_playerName, "")
		GUICtrlSetData($UI_In_runCmd, "")
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


;==============
;M load startup
;LoadGameOnStartupOpt()
Func LoadGameOnStartupOpt()
	Local $idx = ComboBoxEx_GetCurSel()

	If $idx = $ID_M Then
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

Func iniFileSetChkBox(ByRef $sValue, ByRef $hw, ByRef $globalVal)
	Local $aTmp = _StringBetween($sValue, '"' , '"')
	;ConsoleWrite("chkbox:"&$sValue&@CRLF)
	If not @error Then
		If $aTmp[0] = "1" Then
			GUICtrlSetState($hw, $GUI_CHECKED)
			if Not ($globalVal = Null) Then $globalVal = True
		Else
			GUICtrlSetState($hw , $GUI_UNCHECKED)
			if Not ($globalVal = Null) Then $globalVal = False
		EndIf
	EndIf
EndFunc

Func iniFileSetCtrlData(ByRef $sValue, ByRef $hw)
	Local $aTmp = _StringBetween($sValue, '"' , '"')
	If not @error Then
		GUICtrlSetData($hw, $aTmp[0])
	EndIf
EndFunc

Func iniFileSetDropdown(ByRef $sValue, ByRef $hw)
	Local $aTmp = _StringBetween($sValue, '"' , '"')
	If not @error Then
		Local $iVal = Number($aTmp[0])
		if $iVal >= 0 Then
			_GUICtrlComboBox_SetCurSel($hw, $iVal)
		EndIf
	EndIf
EndFunc

Func iniFileSetDropdownEx(ByRef $sValue, ByRef $hw)
	Local $aTmp = _StringBetween($sValue, '"' , '"')
	If not @error Then
		Local $iVal = Number($aTmp[0])
		if $iVal >= 0 Then
			;ComboBoxEx_SetCurSel($idx)
			_GUICtrlComboBoxEx_SetCurSel($hw, $iVal)
		EndIf
	EndIf
EndFunc

Func iniFileSetFav(ByRef $sValue, $iGameIDx)
	Local $aTmp = _StringBetween($sValue, '"' , '"')
	If not @error Then
		If $g_aFavList[$iGameIDx] <> "" Then
			$g_aFavList[$iGameIDx] &= "|" & $aTmp[0]
		Else
			$g_aFavList[$iGameIDx] = $aTmp[0]
		EndIf
	EndIf
EndFunc

Func iniFileSetDropdownGame(ByRef $sValue, ByRef $array)
	Local $aTmp = _StringBetween($sValue, '"' , '"')
	If not @error Then
		$array = Number($aTmp[0]) ;todo check this
	EndIf
EndFunc

Func iniFileSet_GameSettings_Str(Const $sValue, ByRef $array)
	Local $aTmp = _StringBetween($sValue, '"' , '"')
	If not @error Then
		$array = String($aTmp[0])
	Else
		ConsoleWrite("ini error in:"&$sValue&@CRLF)
	EndIf
EndFunc

Func iniFileSet_GameSettings_Num(Const $sValue, ByRef $array)
	Local $aTmp = _StringBetween($sValue, '"' , '"')
	If not @error Then
		$array = Number($aTmp[0])
	Else
		$array = 0
		ConsoleWrite("ini error in:"&$sValue&@CRLF)
	EndIf
EndFunc


Func iniFile_Load()
	local $sFileName = StringTrimRight(@ScriptFullPath, 4) & ".ini"

	;check for first run
	If not FileExists($sFileName) Then
		;fill defaults
		For $i = 0 to $COUNT_GAME -1
			$g_aGameSetup_EXE[$i] = StringFormat("%s.exe", $g_gameConfig[$i][$GNAME_MENU]) ;game.exe
			$g_aGameSetup_Master_Combo[$i] = 1 ;idx
		Next
		Return
	EndIf

	;set default master selection. incase ini outdated
	For $i = 0 to $COUNT_GAME -1
		$g_aGameSetup_Master_Combo[$i] = 1 ;idx
	Next

	ConsoleWrite("-----========= loading ini =========-----" & @CRLF)
	Local $aArray, $aTmp
	Local $aVarInput = [['Hotkey=', $UI_In_hotKey], ['AutoRefreshTime=', $UI_In_refreshTime]]
	Local $aVarCBox = [ _
		['PlaySounds=', $UI_CBox_sound, Null], _
		['MinimizeToTray=', $UI_CBox_minToTray, Null], _
		['UseTheme=', $UI_CBox_theme, Null], _
		['PingNextMaster=', $UI_CBox_tryNextMaster, Null], _
		['AutoRefresh=', $UI_CBox_autoRefresh, $g_bAutoRefresh]]
	Local $aVarCombo = [["HotkeyAlt=", $UI_Combo_hKey]]
	Local $aVarComboEx = [["StartupGame=", $UI_Combo_gameSelector]]
	Local $aIni_GameSettings_masterUsed[$COUNT_GAME]   ;[MasterUsed]
	Local $aIni_GameSettings_masterCust[$COUNT_GAME]   ;[MasterCustom]
	Local $aIni_GameSettings_masterProto[$COUNT_GAME]  ;[MasterProtocol]
	Local $aIni_GameSettings_masterExe[$COUNT_GAME]    ;[exePath]
	Local $aIni_GameSettings_masterName[$COUNT_GAME]   ;[Name]
	Local $aIni_GameSettings_masterRunCmd[$COUNT_GAME] ;[Commands]
	Local $aIni_GameSettings_masterRefresh[$COUNT_GAME] ;[AutoRefresh]
	local $g_sFavName[$COUNT_GAME]

	For $i=0 To $COUNT_GAME -1
		$g_sFavName[$i]                      = StringFormat('Fav%s=',            $g_gameConfig[$i][$GNAME_SAVE])
		$aIni_GameSettings_masterUsed[$i]    = StringFormat('MasterUsed%s=',     $g_gameConfig[$i][$GNAME_SAVE])
		$aIni_GameSettings_masterCust[$i]    = StringFormat('MasterCustom%s=',   $g_gameConfig[$i][$GNAME_SAVE])
		$aIni_GameSettings_masterProto[$i]   = StringFormat('MasterProtocol%s=', $g_gameConfig[$i][$GNAME_SAVE])
		$aIni_GameSettings_masterExe[$i]     = StringFormat('ExePath%s=',        $g_gameConfig[$i][$GNAME_SAVE])
		$aIni_GameSettings_masterName[$i]    = StringFormat('Name%s=',           $g_gameConfig[$i][$GNAME_SAVE])
		$aIni_GameSettings_masterRunCmd[$i]  = StringFormat('RunOpt%s=',         $g_gameConfig[$i][$GNAME_SAVE])
		$aIni_GameSettings_masterRefresh[$i] = StringFormat('Refresh%s=',        $g_gameConfig[$i][$GNAME_SAVE])
	Next


	If Not (_FileReadToArray($sFileName, $aArray, 0) = 0) Then
		For $i = 0 to UBound($aArray) -1
			if $aArray[$i] = "" then ContinueLoop
			if StringInStr($aArray[$i], "[", $STR_CASESENSE, 1, 1, 1) then ContinueLoop
			;ConsoleWrite(">debug key="&$aArray[$i]&@CRLF)

			; input box
			For $j = 0 to UBound($aVarInput)-1
				If StringInStr($aArray[$i], $aVarInput[$j][0], 0) Then
					iniFileSetCtrlData($aArray[$i], $aVarInput[$j][1])
					ContinueLoop(2)
				EndIf
			Next
			;checkbox
			For $j = 0 to UBound($aVarCBox)-1
				If StringInStr($aArray[$i], $aVarCBox[$j][0], 0) Then
					iniFileSetChkBox($aArray[$i], $aVarCBox[$j][1], $aVarCBox[$j][2])
					ContinueLoop(2)
				EndIf
			Next
			;dropdown
			For $j = 0 to UBound($aVarCombo)-1
				If StringInStr($aArray[$i], $aVarCombo[$j][0], 0) Then
					iniFileSetDropdown($aArray[$i], $aVarCombo[$j][1])
					ContinueLoop(2)
				EndIf
			Next
			;dropdownEx
			For $j = 0 to UBound($aVarComboEx)-1
				If StringInStr($aArray[$i], $aVarComboEx[$j][0], 0) Then
					iniFileSetDropdownEx($aArray[$i], $aVarComboEx[$j][1])
					ContinueLoop(2)
				EndIf
			Next

			;fav
			For $j = 0 to UBound($g_sFavName)-1
				If StringInStr($aArray[$i], $g_sFavName[$j], 0) Then
					iniFileSetFav($aArray[$i], $j)
					ContinueLoop(2)
				EndIf
			Next
			;game setup [MasterUsed]
			For $j = 0 to $COUNT_GAME -1
				If StringInStr($aArray[$i], $aIni_GameSettings_masterUsed[$j], 0) Then
					iniFileSetDropdownGame($aArray[$i], $g_aGameSetup_Master_Combo[$j])
					FixGameComboIndex($g_aGameSetup_Master_Combo[$j], $j) ;fix invalid save index
					ContinueLoop(2)
				EndIf
			Next
			;game setup [MasterCustom]
			For $j = 0 to UBound($aIni_GameSettings_masterCust)-1
				If StringInStr($aArray[$i], $aIni_GameSettings_masterCust[$j], 0) Then
					iniFileSet_GameSettings_Str($aArray[$i], $g_aGameSetup_Master_Cust[$j])
					ContinueLoop(2)
				EndIf
			Next
			;game setup [MasterProtocol]
			For $j = 0 to UBound($aIni_GameSettings_masterProto)-1
				If StringInStr($aArray[$i], $aIni_GameSettings_masterProto[$j], 0) Then
					iniFileSet_GameSettings_Str($aArray[$i], $g_aGameSetup_Master_Proto[$j])
					ContinueLoop(2)
				EndIf
			Next
			;game setup [exePath]
			For $j = 0 to UBound($aIni_GameSettings_masterExe)-1
				If StringInStr($aArray[$i], $aIni_GameSettings_masterExe[$j], 0) Then
					iniFileSet_GameSettings_Str($aArray[$i], $g_aGameSetup_EXE[$j])
					ContinueLoop(2)
				EndIf
			Next
			;game setup [Name]
			For $j = 0 to UBound($aIni_GameSettings_masterName)-1
				If StringInStr($aArray[$i], $aIni_GameSettings_masterName[$j], 0) Then
					iniFileSet_GameSettings_Str($aArray[$i], $g_aGameSetup_Name[$j])
					ContinueLoop(2)
				EndIf
			Next
			;game setup [Commands] 'RunOpt'
			For $j = 0 to UBound($aIni_GameSettings_masterRunCmd)-1
				If StringInStr($aArray[$i], $aIni_GameSettings_masterRunCmd[$j], 0) Then
					iniFileSet_GameSettings_Str($aArray[$i], $g_aGameSetup_RunCmd[$j])
					ContinueLoop(2)
				EndIf
			Next
			;game refresh [AutoRefresh] 'RunOpt'
			For $j = 0 to UBound($aIni_GameSettings_masterRefresh)-1
				If StringInStr($aArray[$i], $aIni_GameSettings_masterRefresh[$j], 0) Then
					iniFileSet_GameSettings_Num($aArray[$i], $g_aGameSetup_AutoRefresh[$j])
					ContinueLoop(2)
				EndIf
			Next



			;window cords
			If StringInStr($aArray[$i], 'Position=') Then
				$aTmp = _StringBetween( $aArray[$i], '"' , '"', $STR_ENDNOTSTART)
				If not @error And UBound($aTmp) >= 4 Then
					WinMove($HypoGameBrowser, $HypoGameBrowser, $aTmp[0], $aTmp[1], $aTmp[2], $aTmp[3])
					SetWinSizeForMinimize() ; save location to memory now, incase
				EndIf
				ContinueLoop
			EndIf

			ConsoleWrite("unknown ini entry:"&$aArray[$i]&@CRLF)
		Next
	EndIf

	ConsoleWrite("-----========= loading ini DONE=========-----" & @CRLF)
EndFunc

Func iniFile_Load_Fix()
	;fill defaults
	For $i = 0 to $COUNT_GAME -1
		if $g_aGameSetup_Master_Proto[$i] = "" and $g_gameConfig[$i][$NET_C2M_Q3PRO] <> "" then
			$g_aGameSetup_Master_Proto[$i] = $g_gameConfig[$i][$NET_C2M_Q3PRO]
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
	Local $iSize = 44 ;LINES... quick set default array size, minus fav
	Local $iniFileArray

	local $stateMinimized = WinGetState($HypoGameBrowser)
	Local $v = WinGetPos($HypoGameBrowser)
	if BitAND($stateMinimized,16) Or BitAND($stateMinimized, 32) Then ;16=minimized 32 maximized
		$v = $g_aStoredWinSize
		ConsoleWrite(" window old resize saved instead.."&@CRLF)
	EndIf

	GameSetup_Store() ; save current master values

	;make sure size is not below min allowed
	If $v[2] < $GUIMINWID Then $v[2] = $GUIMINWID
	If $v[3] < $GUIMINHT Then $v[3] = $GUIMINHT

	;todo cleanup key names. use array
	$iniFileArray = ""& _
		"[Settings]"           &@CRLF& StringFormat( _
		'Position="%s" "%s" "%s" "%s"', $v[0], $v[1], $v[2], $v[3])    &@CRLF& StringFormat( _ ;todo cleanup str
		'StartupGame="%s"',     getComboExStr($UI_Combo_gameSelector)) &@CRLF& StringFormat( _ ;new
		'PlaySounds="%s"',      getCboxStr($UI_CBox_sound))            &@CRLF& StringFormat( _
		'MinimizeToTray="%s"',  getCboxStr($UI_CBox_minToTray))        &@CRLF& StringFormat( _
		'UseTheme="%s"',        getCboxStr($UI_CBox_theme))            &@CRLF& StringFormat( _
		'PingNextMaster="%s"',  getCboxStr($UI_CBox_tryNextMaster))    &@CRLF& StringFormat( _
		'AutoRefresh="%s"',     getCboxStr($UI_CBox_autoRefresh))      &@CRLF& StringFormat( _
		'AutoRefreshTime="%s"', GUICtrlRead($UI_In_refreshTime))       &@CRLF& StringFormat( _
		'HotkeyAlt="%s"',       getComboStr($UI_Combo_hkey))           &@CRLF& StringFormat( _
		'Hotkey="%s"',          GUICtrlRead($UI_In_hotKey))            &@CRLF& _
		""                      &@CRLF

	$iniFileArray &= "[MasterUsed]" &@CRLF
	For $i = 0 to $COUNT_GAME-1
		$iniFileArray &= StringFormat('MasterUsed%s="%s"',$g_gameConfig[$i][$GNAME_SAVE],getSelectedMasterIndex($i) ) &@CRLF
	Next
	$iniFileArray &= @CRLF&"[MasterCustom]" &@CRLF
	For $i = 0 to $COUNT_GAME-1
		$iniFileArray &= StringFormat('MasterCustom%s="%s"',$g_gameConfig[$i][$GNAME_SAVE], $g_aGameSetup_Master_Cust[$i]) &@CRLF
	Next
	$iniFileArray &= @CRLF&"[MasterProtocol]" &@CRLF
	For $i = 0 to $COUNT_GAME-1
		$iniFileArray &= StringFormat('MasterProtocol%s="%s"',$g_gameConfig[$i][$GNAME_SAVE], $g_aGameSetup_Master_Proto[$i] ) &@CRLF
	Next
	;exe paths
	$iniFileArray &= @CRLF&"[exePath]" &@CRLF;
	For $i = 0 to $COUNT_GAME-1
		$iniFileArray &= StringFormat('ExePath%s="%s"',$g_gameConfig[$i][$GNAME_SAVE], $g_aGameSetup_EXE[$i] ) &@CRLF
	Next
	$iniFileArray &= @CRLF&"[Name]" &@CRLF;
	For $i = 0 to $COUNT_GAME-1
		$iniFileArray &= StringFormat('Name%s="%s"',$g_gameConfig[$i][$GNAME_SAVE], $g_aGameSetup_Name[$i] ) &@CRLF
	Next
	$iniFileArray &= @CRLF&"[Commands]" &@CRLF; todo name... but users will have to re'setup
	For $i = 0 to $COUNT_GAME-1
		$iniFileArray &= StringFormat('RunOpt%s="%s"',$g_gameConfig[$i][$GNAME_SAVE], $g_aGameSetup_RunCmd[$i] ) &@CRLF
	Next
	$iniFileArray &= @CRLF&"[AutoRefresh]" &@CRLF;
	For $i = 0 to $COUNT_GAME-1
		$iniFileArray &= StringFormat('Refresh%s="%s"',$g_gameConfig[$i][$GNAME_SAVE], ($g_aGameSetup_AutoRefresh[$i])?("1"):("0") ) &@CRLF
	Next

	;favourite
	$iniFileArray &= @CRLF&"[Favourites]" &@CRLF
	For $i = 0 to $COUNT_GAME-1
		Local $aTmp = StringSplit($g_aFavList[$i], "|")
		For $j = 1 to $aTmp[0]
			If $aTmp[$j] <> "" Then
				$iniFileArray &= StringFormat('Fav%s="%s"',$g_gameConfig[$i][$GNAME_SAVE], $aTmp[$j]) &@CRLF
			EndIf
		Next
	Next

	$iniFileArray &= @CRLF

	Local $hFile = FileOpen($iniFileCFG, $FO_OVERWRITE + $FO_UTF8)
	if $hFile = -1 Then
		MsgBox($MB_SYSTEMMODAL, "", "Could not Save Settings.",0, $HypoGameBrowser)
		;ResetRefreshTimmers()
	Else
		FileWrite($hFile, $iniFileArray) ;_FileWriteFromArray($iniFileCFG, $iniFileArray, 0)
		FileClose($hFile)
	EndIf

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
			local $tmpSize = InetGetSize($sData,$INET_FORCERELOAD)
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
				MsgBox($MB_SYSTEMMODAL, "","Error in packet, no Return" )
				Return
			EndIf

			Local $numLines = $tmpstr[0] ;3 lines standard >= players
			;MsgBox($MB_SYSTEMMODAL, "","finnn:" & $numLines )
			;ÿÿÿÿprint""ÿÿÿÿstatusResponse"
			If Not StringInStr($tmpstr[1], GetData_S2C($S2C_Q2), 1, 1, 1, 10) And Not StringInStr($tmpstr[1],GetData_S2C($S2C_Q3), 1, 1, 1, 20) Then
				MsgBox($MB_SYSTEMMODAL, "","error in packet header (no 'yyyy')" )
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
	Func M_GetServerPacket($iGameIdx)
		Local $serverIP, $serverPort, $status, $data
		local $getTimeDiffServer = TimerInit()
		Local $sIPAddress, $iPort, $iErrorX

		Local $serverAddress = StringSplit(GetServerListA_SelectedData($LV_A_IP),":")
		If @error Then
			ConsoleWrite("Error: splitting string in M_GetServerPacket()"& @CRLF)
			Return ""
		EndIf

		$sIPAddress = TCPNameToIP( $serverAddress[1]) ;todo move this
		$iPort = $serverAddress[2]

		$iErrorX = _UDPSendTo($sIPAddress, $iPort, sendStatusMessageType_UDP($iGameIdx, True), ($g_hSocketServerUDP))
		if @error Then
			ConsoleWrite("UDP Send \status\ sock error =  " & $iErrorX & " error" & @CRLF)
			Return
		EndIf

		Do ;loop untill complet info string is recieved or timed out. 3.5 seconds
			$data = _UDPRecvFrom(($g_hSocketServerUDP),2048,0)
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

		if _IsChecked($UI_CBox_theme) Then
			GUICtrlSetColor($ListView1POP, $COLOR_HYPO_ORANGE)
			GUICtrlSetBkColor ($ListView1POP,$COLOR_HYPO_GREY)
			GUICtrlSetColor($ListView2POP, $COLOR_HYPO_ORANGE)
			GUICtrlSetBkColor ($ListView2POP,$COLOR_HYPO_GREY)
		EndIf

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
		SetSelectedGameID() ;todo check this
		M_DisablePopupButtons()
		_BIND_UDP_SOCKET($g_hSocketServerUDP)

		Local $serverInfoString = M_GetServerPacket(GetActiveGameIndex()) ;$g_iCurGameID
		If Not ($serverInfoString = "") Then
			M_ServerDetailArray($serverInfoString)
		EndIf
		_UDPCloseSocket($g_hSocketServerUDP)
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
				GUICtrlSetBkColor($hw, $COLOR_YELLOW) ;found player, highlight it
			EndIf
			$iIdx += 1 ;increase list by 1
		EndIf ;end error
	EndFunc

	;=============================================================================
	;--> set ServerList per tab
	Func M_SetServerTabArray()
		Local $aArray, $i, $sString
		Local $noLoadOffLine = 0, $iKP1 = 0, $iQ2 = 0, $iKPQ3 = 0
		local $stringCol[100] ;max collums
		Local $stringColQ2[20]

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
		local $arrayRegEdit

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

				Local $hFile = FileOpen($g_sM_tmpFile_reg, $FO_OVERWRITE + $FO_UTF8)
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

				Local $hFile = FileOpen($g_sM_tmpFile_reg, $FO_OVERWRITE + $FO_UTF8)
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
		Return $g_aGameSetup_Master_Cust[$iGameIdx]
	Else
		Local $aDropdownText = StringSplit($g_gameConfig[$iGameIdx][$MASTER_ADDY], "|")
		Return $aDropdownText[$iMasterIdx]
	EndIf
EndFunc

; what master to use from settings
Func SelectedGameMasterAddress($iGameIdx, $retryCount)
	Local  $idx, $iPortType, $sMaster = "", $aRet[2]
	Local $iMasterIdx = getSelectedMasterIndex($iGameIdx)
	ConsoleWrite("+master id:"&$iMasterIdx&@CRLF)

	If $iMasterIdx = 0 Then ; custom master address
		If $retryCount > 0 Then Return -1 ; fail
		$sMaster = $g_aGameSetup_Master_Cust[$iGameIdx]
		ConsoleWrite("+master addy:"&$sMaster&@CRLF)
		If $sMaster = "" Then Return -1 ; fail
	Else
		Local $aDropdownText = StringSplit($g_gameConfig[$iGameIdx][$MASTER_ADDY], "|")
		Local $iCount = $aDropdownText[0]
		ConsoleWrite("+master count:"&$iCount&@CRLF)
		If $retryCount >= $iCount Then
			ConsoleWrite("!master try count:"&$iCount&@CRLF)
			Return -1 ;exhausted list
		EndIf
		$iMasterIdx -= 1 ; subtract user
		$idx = Mod($iMasterIdx+$retryCount, $iCount) + 1 ;1-based
		$sMaster = $aDropdownText[$idx]
		ConsoleWrite("master=" &$sMaster&@CRLF)
	EndIf

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
			$aRet[1] = StringFormat("%s:%s", $sMaster,  getMaterExtraInfo($iGameIdx)) ;$g_aGameSetup_Master_Proto
			$aRet[1] = StringSplit($aRet[1],":", $STR_NOCOUNT)
			If @error Then Return -1
	EndSwitch

	Return $aRet
EndFunc

Func getSelectedMasterIndex($iGameIdx)
	Local $idx = $g_aGameSetup_Master_Combo[$iGameIdx]
	if $idx < 0 Then
		Return 0
	Else
		Return $idx
	EndIf
EndFunc

#EndRegion


#Region --> PROTOCOL: Relted settings
Func sendStatusMessageType_UDP($iGameIdx, $isMBrowser) ;udp
	if $isMBrowser Then
		Switch $iGameIdx ;user right click-> get-info
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
	Local $ListViewA = getListView_A_CID()
	Local $listSelNum = _GUICtrlListView_GetSelectionMark($ListViewA)

	If $g_iTabNum = $TAB_GB Then
		Switch $g_iCurGameID
			Case 0 to $COUNT_GAME-1
				FillListView_BC_Selected($g_iCurGameID, $listSelNum)
			case Else ;$ID_KP1
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
Func GetListFromMasterTCP($sIPAddressDNS, $iPort)
	Local $iGameIdx = $g_iCurGameID ;GetActiveGameIndex()
	Local $tcpSocket, $data ="", $dataRecv, $dataRecv2, $sIPAddress, $iTmpTime
	Local $sGameKey=  "mgNUaC" ;gspylite="mgNUaC" ;kingpin="QFWxY2" "Quake2"="rtW0xg"
	Local $gameSpyString="" ; = "\gamename\gspylite\gamever\01\location\0\validate\LO/WUC4c\final\\queryid\1.1"

	$sIPAddress = TCPNameToIP($sIPAddressDNS)
	$iTmpTime = TimerInit()

	;try connect a few times then give up
	For $i3 =0 to 3
		$tcpSocket = TCPConnect($sIPAddress, $iPort)
		If $tcpSocket <= 0 or @error Then
			If @error = 1 or @error = 2 or $i3 >= 3 Then ; @error 1=ip 2=port
				ConsoleWrite("error TCP 1" &  $tcpSocket & "@err=" &@error&@CRLF)
				TCPCloseSocket($tcpSocket)
				Return -1
			EndIf
			ConsoleWrite("retry connect to master" &@CRLF)
			TCPCloseSocket($tcpSocket)
			Sleep(1000)
			ContinueLoop
		EndIf
		ExitLoop ;connected ok
	Next
	;TCP connected
	if Not TcpRecvDataFromMaster($tcpSocket, $dataRecv, 1500) Then Return -1 ;recieve= 	\basic\\secure\TXKOAT

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
		if not TcpSendDataToMaster($tcpSocket, $gameSpyString) Then Return -1
		;ConsoleWrite("-gs querry:"&$gameSpyString&@CRLF)

		;$dataRecv = ""
		For $i4 = 0 To 5 ;recieve upto 5 more lists, if long
			if Not TcpRecvDataFromMaster($tcpSocket, $dataRecv, 2500) Then Return -1 ;recieve= \ip\10.10.10:31510\ip\10.10.10:31520\final\
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
		ConsoleWrite("error TCP 2 err:" &@error&@CRLF)
		TCPCloseSocket($iSock)
		Return False
	EndIf
	Return True
EndFunc

Func TcpRecvDataFromMaster(ByRef $iSock, ByRef $sMsg, $iMaxLen)
	$sMsg = TCPRecv($iSock, $iMaxLen, 0)
	;ConsoleWrite("TCP Recv:"& $sMsg &@CRLF)
	If @error Or $sMsg = "" Then
		ConsoleWrite("error TCP 4 err:"&@error&@CRLF)
		TCPCloseSocket($iSock)
		Return False
	EndIf
	Return True
EndFunc

#EndRegion --> TCP GET LIST FROM MASTER


#Region --> UDP GET

Func GetMessage_toSendMasterUDP($iGameIdx, $iProtocol)
	;ÿÿÿÿgetservers KingpinQ3-1 %s full empty
	;ÿÿÿÿgetservers 66 empty full demo.

	;q3 master protocol
	If $g_gameConfig[$iGameIdx][$NET_C2M_Q3PRO] <> "" Then ;q3 uses protocol
		local $sDPName = $g_gameConfig[$iGameIdx][$GNAME_DP]
		If $sDPName <> "" Then ;dp master
			Return StringFormat("%s %s %s full empty\n\0", _
				GetData_C2M($g_gameConfig[$iGameIdx][$NET_C2M]), _
				$sDPName , _ ; add gamename (dp)
				$iProtocol) ;& chr(0)
		Else
			return StringFormat("%s %s full empty\n\0", _
				GetData_C2M($g_gameConfig[$iGameIdx][$NET_C2M]), _
				$iProtocol) ;& chr(0) ;quake3
		EndIf
	Else
		return StringFormat("%s", GetData_C2M($g_gameConfig[$iGameIdx][$NET_C2M]) & Chr(0))
	EndIf
EndFunc

Func CleanupResponce_fromMasterUDP($iGameIdx, ByRef $data)
	Local $idx1, $iLen, $sHeader

	;ConsoleWrite("PacketData003=" &String($data)&@CRLF)
	if $data <> "" Then
		$sHeader = GetData_M2C($g_gameConfig[$iGameIdx][$NET_M2C])
		$iLen = StringLen($sHeader)
		$idx1 = StringInStr($data, $sHeader, 1, 1, 1, $iLen)
		If $idx1 Then
			$data = StringTrimLeft($data, $idx1+$iLen) ; trim ÿÿÿÿservers\n... +1char(catch \0 \\)

			;extra message cleanup... paintball2
			Switch $iGameIdx
				Case $ID_PAINT
					local const $sPBExtra = 'serverlist2' ;todo move name out of here?
					$idx1 = StringInStr($data, $sPBExtra, 0, 1, 1, 20) ;should be at start...
					If $idx1 Then
						$data = StringTrimLeft($data, $idx1+StringLen($sPBExtra)+4) ; trim name + int(length)
						;ConsoleWrite("pb cleanup:"&$data&@CRLF)
					EndIf
				;Case
					;todo ADD GAMES
			EndSwitch
		EndIf
		;ConsoleWrite("PacketData004:"&$data&@CRLF)
		ConsoleWrite("-cleaned master packet:"&@CRLF&"-0x"& Hex(StringToBinary($data))&@CRLF) ;todo cleanup debug
		ConsoleWrite("-cleaned:"&@CRLF&"-"& $data&@CRLF)
	EndIf
EndFunc

Func STFE_readMasterIPList($data)
	;Star Trek: Elite Force has ip sent as a hex string...
	local $ret = ""

	local $iMax = StringLen($data)
	For $i = 1 To $iMax -12 Step 13
		$ret &= BinaryToString("0x"&StringMid($data, $i, 12), 1) & "\"
	Next
	return $ret
EndFunc

Func BuildIPList_fromMasterUDP($iGameIdx, ByRef $data, ByRef $retErr)
	Local $sRet = "", $iStep = 6, $i, $iCount, $aChars

	if $data <> "" Then
		If $iGameIdx = $ID_STEF1 Then ;todo ADD GAMES
			$data = STFE_readMasterIPList($data)
		EndIf

		$aChars = StringToASCIIArray($data, 0, Default, $SE_ANSI)
		if $aChars = "" or Not IsArray($aChars) Then ;Or $aChars[0] = Null
			$retErr = -2 ;error: report no servers
		Else
			$iStep += $g_gameConfig[$iGameIdx][$NET_M2C_SEP] ;q3 adds '\' to end of ip
			;_ArrayDisplay($aChars)
			$iCount = UBound($aChars)-1
			ConsoleWrite(">count:" &$iCount&@CRLF)
			For $i = 0 to $iCount Step $iStep
				if $i+$iStep-1 <= $iCount Then
					$sRet &= StringFormat("\ip\%u.%u.%u.%u:%u", _ ;uncompress byte to int
						($aChars[$i+0]), ($aChars[$i+1]), ($aChars[$i+2]), ($aChars[$i+3]), _ ;ip address
						BitShift(($aChars[$i+4]), -8) + ($aChars[$i+5])) ;port
				EndIf
			Next
			;ConsoleWrite("-out1:"&$output&@CRLF)
		EndIf
		$data = "" ;cleanup
	else
		$retErr = -2 ;error: report no servers
	EndIf
	Return $sRet
EndFunc

Func GetList_fromMasterUDP($iGameIdx, $sSendIPAddressDNS, $iSendPort, $iProtocol = "")
	If @error Then ConsoleWrite("error startup")
	Local $tcpSocket, $dataRecv, $data = "", $retErr = -1
	Local $iErrorX, $output = ""
	Local $gameSpyString = GetMessage_toSendMasterUDP($iGameIdx, $iProtocol)
	ConsoleWrite("+len:"&StringLen($gameSpyString)&@CRLF) ;todo remove debug
	ConsoleWrite("-sending to master3:" &Hex(StringToBinary($gameSpyString))&@CRLF) ;todo remove debug
	ConsoleWrite("-sending to master2:" &$gameSpyString&@CRLF) ;todo remove debug

	_BIND_UDP_SOCKET($g_hSocketMasterUDP)
	Local $sIP = TCPNameToIP($sSendIPAddressDNS)
	If Not @error Then
		ConsoleWrite("ip:"&$sIP&" port:"&$iSendPort&@CRLF)
		$iErrorX = _UDPSendTo($sIP, $iSendPort, $gameSpyString, $g_hSocketMasterUDP)
		if @error Then
			ConsoleWrite("!UDP Send 'status' sock error=" & $iErrorX & " error" & @CRLF)
		EndIf
	EndIf

	if Not @error Then
		Local $iTimeOut = TimerInit(), $sTail, $dataLen
		local $sEOT = GetData_EOT($g_gameConfig[$iGameIdx][$NET_M2C_EOT]) ;EOT

		While 1
			Do
				$dataRecv = _UDPRecvFrom($g_hSocketMasterUDP, 10000, 0) ;2048
				If TimerDiff($iTimeOut) > 3000 Then
					ConsoleWrite("button state up, timeout 3seconds"&@CRLF)
					ExitLoop(2) ;timedout. stop do+while
				EndIf
				Sleep(100)
			Until IsArray($dataRecv)

			$dataLen = $dataRecv[$PACKET_SIZE]
			ConsoleWrite("+$dataLen="&$dataLen&@CRLF) ;todo cleanup debug
			ConsoleWrite("-received master packet:"&@CRLF&"-0x"& Hex(StringToBinary($dataRecv[$PACKET_DATA]))&@CRLF) ;todo cleanup debug
			ConsoleWrite("-received:"&@CRLF&"-"& $dataRecv[$PACKET_DATA]&@CRLF)
			;"ÿÿÿÿgetservers FTE-Quake 3 full empty"
			;check for EOT
			$sTail = StringMid($dataRecv[$PACKET_DATA], $dataLen - StringLen($sEOT)+1, -1)
			ConsoleWrite("+$sTail s:"&Hex(StringToBinary($sTail))&@CRLF) ;todo cleanup debug
			If StringCompare($sTail, $sEOT, $STR_CASESENSE) = 0 Then
				$data &= StringMid($dataRecv[$PACKET_DATA], 1, $dataLen - StringLen($sEOT)) ; trim EOT
				;ConsoleWrite("-packet=0x"& Hex(StringToBinary($data))&@CRLF)
				ConsoleWrite(@CRLF&"+found 'EOT'"&@CRLF) ;todo cleanup debug
				ExitLoop(1) ;recieved full packet
			Else
				;short message without EOT
				If $sEOT = "" and $data = "" and $dataLen < 512 Then
					$data &= $dataRecv[$PACKET_DATA]
					ConsoleWrite("-packet=0x"& Hex(StringToBinary($data))&@CRLF)
					ExitLoop(1) ;recieved full packet
				EndIf
			EndIf
			;add recieved data
			$data &= $dataRecv[$PACKET_DATA] ; get multiple packets?
		WEnd
	EndIf
	_UDPCloseSocket($g_hSocketMasterUDP)
	;Servers recieved string

	CleanupResponce_fromMasterUDP($iGameIdx, $data)
	$output = BuildIPList_fromMasterUDP($iGameIdx, $data, $retErr)

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
Func GetListFromHTTP($netType, $sData)
	Local $i, $hDownload, $iTimeout = TimerInit(), $aArray, $sWebLink
	Local $sOutput=""
	;EnableUIButtons(False)

	;~ If $netType = $NET_PROTOCOL_WEB Then
	;~ 	$sWebLink = StringFormat("http://%s", $sData) ;http://%s:%s/?mod=&raw=1&inc=1
	;~ Else
	;~ 	$sWebLink = StringFormat("%s", $sData)
	;~ EndIf
	$sWebLink = $sData

	ConsoleWrite("+master:"&$sWebLink&@CRLF)

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
		if Not $g_bAutoRefreshActive Then
			MsgBox($MB_SYSTEMMODAL, "ERROR: Cant Get List", "There was an error downloading server list from "&$sWebLink& _
				@CRLF & "Check Your Connection?",0, $HypoGameBrowser )
		EndIf
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
		if Not $g_bAutoRefreshActive Then
			MsgBox($MB_SYSTEMMODAL, "Master Server Error","ERROR Connecting to Master Server." &@CRLF& _
									"Try Another 'Master' in Setup" &@CRLF&@CRLF& _
									"If they all fail, try the 'Offline' button.",0, $HypoGameBrowser )
		EndIf
		return -1
	ElseIf $sMasterMessage = -2 Then
		if Not $g_bAutoRefreshActive Then
			MsgBox($MB_SYSTEMMODAL, "Master Server List","0 Servers in list from Master." &@CRLF& _
									"Try Another 'Master' in Setup." &@CRLF&@CRLF& _
									"If they all fail, try the 'Offline' button.",0, $HypoGameBrowser )
		EndIf
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
		if Not $g_bAutoRefreshActive Then
			MsgBox($MB_SYSTEMMODAL, "Master Server List","0 Servers in list from Master." &@CRLF& _
									"Try Another 'Master' in Setup." &@CRLF&@CRLF& _
									"If they all fail, try the 'Offline' button.",0, $HypoGameBrowser )
		Endif
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
	Local $aMaster_IP, $serverMessage = -1, $ipArray, $iPortx
	Local $j =0, $iCount = 0

	$g_ilastColumn_A = -1 ;reset listview

	;EnableUIButtons(False)
	BeginGettinServers()
	$g_iPlayerCount_GS = 0
	$g_iServerCountTotal = 0 ;get # servers to use later to stop refresh

	;count masters in list
	if _IsChecked($UI_CBox_tryNextMaster) Then
		local $aMast = StringSplit($g_gameConfig[$iGameIdx][$MASTER_ADDY], "|")
		if not @error Then
			$iCount = $aMast[0]-1
		;else
 			;$iCount = 20
		endif
	EndIf

	;queery master for ip list, rotate to next master if failed
	For $iIdx = 0 to $iCount  ;try multiple masters
		$aMaster_IP = SelectedGameMasterAddress($iGameIdx, $iIdx)

		If $aMaster_IP = -1 Then
			$serverMessage = -1
			ExitLoop
		EndIf

		If $iIdx = 1 Then
			setTempStatusBarMessage("SERVER NOT RESPONDING. Trying next Master in list.", True)
		EndIf

		;[protocol,ip,port,extraData]
		Switch $aMaster_IP[0] ; protocol
			Case $NET_PROTOCOL_TCP
				$serverMessage = GetListFromMasterTCP(($aMaster_IP[1])[0], ($aMaster_IP[1])[1]) ; [ip,port]
			Case $NET_PROTOCOL_UDP
				$serverMessage = GetList_fromMasterUDP($iGameIdx, ($aMaster_IP[1])[0], ($aMaster_IP[1])[1], ($aMaster_IP[1])[2]) ; [ip,port,proto]
			Case $NET_PROTOCOL_WEB, $NET_PROTOCOL_HTTP, $NET_PROTOCOL_HTTPS
				$serverMessage = GetListFromHTTP($aMaster_IP[0], $aMaster_IP[1]) ;web
		EndSwitch

		If Not ($serverMessage = -1) Then
			ExitLoop ;master valid
		EndIf
	Next

	;split masterServer message (1-base)
	$ipArray = GetIPArrayFromMasterResponce($serverMessage)
	If not IsArray($ipArray) Or $ipArray = -1 Then
		FinishedGettinServers();/
		ResetRefreshTimmers()
		return
	EndIf

	;clear selected column. todo work out how to re-sort without mouse click
	GUICtrlSendMsg($UI_ListV_svData_A, $LVM_SETSELECTEDCOLUMN, -1, 0) ;updateLV

	;clear internal array ($g_aServerStrings[])
	ResetServerListArrays(BitShift(1, -($iGameIdx)))

	;populate internal array with
	FillServerStringArrayIP($iGameIdx, $ipArray)

	;refresh list using internal array
	RefreshServersInListview($iGameIdx)

	;ListviewResetSortOrder()
	FinishedGettinServers();/
	ResetRefreshTimmers()
EndFunc; -->  GetServerListFromMaster TCP
;========================================================


;========================================================
;--> UDP RECV listenIncommingServers()
Func listenIncommingServers($iGameIdx, $aServerIdx, $start, $end) ;, $iOffset) ;todo fix final
	Local $i, $listNum, $iPing, $data, $dataRecv, $KpGsFinal, $iSVResponded = 0 ;counter
	Local $iSVCount = $end-$start+1 ;  total this wave
	Local $sIP, $iPort, $iOff, $idx
	;Local $iGameIdx = $g_iCurGameID ;GetActiveGameIndex()
	Local $countServ = GetServerCountInArray($iGameIdx) ;count servers in array
	Local $ListViewA = getListView_A_CID()
	Local $aResponce[$iSVCount][$COUNT_PACKET]
	Local Const	$sSV_ErrorStr = "Info string length exceeded"

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
			$dataRecv = _UDPRecvFrom($g_hSocketServerUDP, 2048, 0)
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
		;ConsoleWrite(StringFormat("Rec: %s:%i %s\n", $sIP, $iPort, $data ) &@CRLF)

		For $i = 0 To $iSVCount -1
			;$iOff = $start + $i + $iOffset
			$iOff =  $aServerIdx[$start + $i]
			if $aResponce[$i][$PACKET_PORT] = $iPort And StringCompare($aResponce[$i][$PACKET_IP], $sIP) = 0 Then
				;ConsoleWrite("+match id:" &$iOff&@CRLF)
				$aResponce[$i][$PACKET_DATA] &= $data
				$aResponce[$i][$PACKET_PING] = TimerDiff($g_aServerStrings[$iGameIdx][$iOff][$COL_TIME]) ;for ping
				$iSVResponded += 1
				$g_iServerCountTotal_Responded +=1
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

		If $g_gameConfig[$iGameIdx][$NET_GS_P] Then ;gamespy protocol
			$data = StringTrimLeft($aResponce[$i][$PACKET_DATA], StringInStr($aResponce[$i][$PACKET_DATA], "\")) ;remove prefix, upto "\"
			;player data
			$idx = StringInStr($data, "\player_")
			If $idx Then
				$g_aServerStrings[$iGameIdx][$iOff][$COL_INFOPLYR] = StringTrimLeft($data, $idx)
				$data = StringMid($data, 1, $idx)
			EndIf
		Else
			Switch $iGameIdx
				Case $ID_HEX, $ID_Q1
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
			EndSwitch
		EndIf

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
	local $i = 0, $iSVLen ;, $iMsgType, $header
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
	Local $portRand = Random(50000, 55532, 1) ;RAND PORT

	For $ipSet = 0 to 30
		$iSocket = _UDPBind("", 0) ;$portRand
		If $iSocket > 0 Then
			ExitLoop
		Else
			$portRand += 2
		EndIf
	Next ;--> Rand Port

	If $iSocket <= 0 And Not $g_bAutoRefreshActive Then
		MsgBox($MB_SYSTEMMODAL, "ERROR",  "Can Not allocate a local port",0, $HypoGameBrowser)
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
	Local $aRet, $nReturn, $bError = 0, $nCode = 0, $tSockAddr, $tBuf, $hWs2, $aResult[4]
	Local Const $tagSockAddr = "short sin_family; ushort sin_port; " & _
			"STRUCT; ulong S_addr; ENDSTRUCT; " & _ ;sin_addr
			"char sin_zero[8]"

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

	$tSockAddr = DllStructCreate($tagSockAddr)
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
		ConsoleWrite(">set 'Send' buffer size" & @CRLF)
	EndIf

	Local $iRes = _setsockopt($sSocket, $SOL_SOCKET, $SO_RCVBUF, $tSetting)
	If $iRes = 0 Then
		ConsoleWrite(">set 'Rec' buffer size" & @CRLF)
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

#Region --> ICON INCLUDE
;==> Resources.au3 by Zedna
Func _ResourceGet($ResName, $ResLang = 0) ; $RT_RCDATA = 10
	Local Const $IMAGE_BITMAP = 0
	Local $hInstance, $hBitmap

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

Func SendStatustoServers_Init($iGameIdx, $aIPArray, $aServerIdx, $bCheckDead = True) ; id
	;
	_BIND_UDP_SOCKET($g_hSocketServerUDP)
	If $g_hSocketServerUDP > 0 Then
		_SetPacketBufferSize($g_hSocketServerUDP, 25600)
		SendSTATUStoServers_Split($iGameIdx, $aIPArray, $aServerIdx) ; send inital ping to all
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


Func SendSTATUStoServers_Split($iGameIdx, $aIPArrayRef, $aServerIdx)
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

		If SendSTATUStoServers($iGameIdx, $aIPArrayRef, $aServerIdx, $start, $end) Then ;get each server details
			listenIncommingServers($iGameIdx, $aServerIdx, $start, $end) ;now listen for responce
			FillListView_A_FullData($iGameIdx, $aServerIdx, $start, $end)
		EndIf
	Next
EndFunc

Func SendSTATUStoServers_CheckDead($iGameIdx, $aIPArrayRef, $aServerIdx)
	;hypo send ping to list 2 more times. if unresponsive
	for $iLoop = 0 To 0
		If $g_iServerCountTotal_Responded >= $g_iServerCountTotal Then
			ExitLoop
		EndIf
		ConsoleWrite("!Some servers failed to respond. Sending status again"&@CRLF)

		Local $iOff, $count = 0, $sIPArrayRef_tmp = "", $aIPArrayRef_tmp, $aServerIdx_tmp = $aServerIdx
		For $int = 0 To UBound($aIPArrayRef) -1
			$iOff = $aServerIdx[$int]
			If $g_aServerStrings[$iGameIdx][$iOff][$COL_PING] = 999 Then
				if $count Then $sIPArrayRef_tmp &= "|"
				$sIPArrayRef_tmp &= String($g_aServerStrings[$g_iCurGameID][$iOff][$COL_IP] &":"& _
				                           $g_aServerStrings[$g_iCurGameID][$iOff][$COL_PORT])
				$aServerIdx_tmp[$count] = $iOff
				$count += 1
			EndIf
		Next
		ConsoleWrite("!dead count: "&$count&@CRLF)

		if $sIPArrayRef_tmp <> "" Then
			$aIPArrayRef_tmp = StringSplit($sIPArrayRef_tmp, "|", $STR_NOCOUNT)
			SendSTATUStoServers_Split($iGameIdx, $aIPArrayRef_tmp, $aServerIdx_tmp)
		EndIf
	Next
EndFunc

Func SendSTATUStoServers($iGameIdx, $arrayServerX, $aServerIdx, $startNum, $endNum) ;, $iOffset = 0)
	Local $iIP, $iErrorX, $start, $iRetCount = 0
	Local $sIPAddress, $iPort, $aIP_Port, $sSTATUS_msg
	;Local $iGameIdx = $g_iCurGameID ;GetActiveGameIndex()
	Local $iSVCount = UBound($arrayServerX)

	;ConsoleWrite("!Send STATUS to Servers count:"&$endNum -$startNum +1 &@CRLF)
	;$getTimePingServer = TimerInit()
	;_ArrayDisplay($arrayServerX, "SendSTATUStoServers1")

	If $iSVCount = 0 or IsArray($arrayServerX) = 0 Then
		ConsoleWrite("!Send STATUS to Servers failed"&@CRLF)
		Return False
	EndIf

	$sSTATUS_msg = sendStatusMessageType_UDP($iGameIdx, False) ;todo port...
	;ConsoleWrite(">Send STATUS to Servers. start:"&$startNum&" end:" &$endNum&" total:"&$iSVCount &@CRLF& _
	;	"-message:"&$sSTATUS_msg& @CRLF)

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

		$sIPAddress = TCPNameToIP( $aIP_Port[1]) ;todo move this
		$iPort      = Number($aIP_Port[2])
		;ConsoleWrite("-UDP Send to:" &$sIPAddress&":"&$iPort & " msg:" &$sSTATUS_msg&@CRLF) ;todo

		$iErrorX = _UDPSendTo($sIPAddress, $iPort, $sSTATUS_msg, $g_hSocketServerUDP)
		if @error Then
			ConsoleWrite("!UDP Send \status\ sock error =  " & $iErrorX & " error" & @CRLF)
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
	Local $player = 0, $sRet, $sPing, $name, $frags, $ping

	;check info string first
	$sRet = parseInfoString($aData, "numplayers")
	if $sRet <> "" Then
		return Number($sRet, 1)
	EndIf

	;count actual players instead
	if $g_gameConfig[$iGameIdx][$NET_GS_P] then ;gamespy players
		;gs protocol...
		if $sPData = "" Then Return 0
		Local $aTmp = StringSplit($sPData, "\", $STR_NOCOUNT)
		For $i = 0 to $MAX_PLAYERS -1
			if parseInfoString($aTmp, "player_"& $i) <> "" Then
				$player += 1
			ElseIf $i > 0 Then
				 Return $player ;sof used player_1
			EndIf
		Next
	Else
		Local $tmpPlyrName
		if $sPData = "" Then Return 0
		Local $aTmp = StringSplit($sPData, Chr(10))
		If @error Then
			ConsoleWrite("player error no @LF" & $sPData&@CRLF)
			Return 0
		EndIf
		;3 lines standard >= players
		For $iply = 1 To $aTmp[0]
			If $aTmp[$iply] <> "" Then ;catch end line @LF, EOT
				If Not parsePlayerString($aTmp[$iply], $name, $frags, $ping) Then ContinueLoop
				if Number($ping) < 3 Then ContinueLoop ;skip bot
				;==============================
				;remove bots from player counts
				Switch $iGameIdx
					Case $ID_Q2
						If StringInStr($name, "WallFly", $STR_NOCASESENSE) Then ContinueLoop ;WTF is this. skip
						if $ping = "-1" Then ContinueLoop ;skip bot
						if $ping = "0" Then ContinueLoop ;skip bot
						if $ping = "1" Then ContinueLoop ;skip bot
					Case $ID_STEF1, $ID_JK2, $ID_JK3, $ID_SOF2, $ID_UNVAN, $ID_WARSOW, $ID_ALIENA
						if $ping = "0" Then ContinueLoop ;skip bot
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
				Case 0 to $ID_Q2
					Return $UI_ListV_mb_ABC[$iMGameType]
				Case Else
					Return $UI_ListV_mb_ABC[$ID_KP1] ;default
			EndSwitch
		Case Else ;1
			Return $UI_ListV_svData_A ;default
	EndSwitch
EndFunc

Func getListView_B_CID()
	Switch $g_iTabNum
		Case $TAB_GB ; 0 to $COUNT_GAME -1
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
		Case $TAB_GB  ;0 to $COUNT_GAME -1
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
			Case Else
				LoadOffLineServerList($ID_KP1) ;default
		EndSwitch
		EnableUIButtons(True)
	EndFunc

;--> OFFLNE LIST
;========================================================
; --> set offline list
Func LoadOffLineServerList($iGameIdx)
	EnableUIButtons(False)
	Local $sIP_Port, $tmpArray, $i, $sIP, $iPort, $iPortGS, $arrayOffline, $svNum = 0
	Local $ListViewA = getListView_A_CID()
	Local $aTmpOffline[$COUNT_GAME]

	$aTmpOffline[$ID_KP1] = "" & _
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

	$aTmpOffline[$ID_KPQ3] = "" & _
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

	$aTmpOffline[$ID_Q2] = "" & _
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

	$aTmpOffline[$ID_HEX] = "" & _
		"blackmarsh.hexenworld.org:26900|Hexen II DM w/ bots" &@CRLF& _
		"darkravager.ddns.net:26900|DarkRavagerH2Coop"        &@CRLF& _
		"blackmarsh.hexenworld.org:26901|"                    &@CRLF& _
		"blackmarsh.hexenworld.org:26902|"                    &@CRLF& _
		"blackmarsh.hexenworld.org:26903|"                    &@CRLF& _
		"clovr.xyz:26900|"                                    &@CRLF& _
		"romagnarines.mooo.com:26900|"                        &@CRLF& _
		"thebleeding.strangled.net:26900|"
	$aTmpOffline[$ID_HW] = "" & _
		"68.83.198.53:26950|HexenWorld DM"                          &@CRLF& _
		"168.138.68.8:26956|DarkRavager Rival Kingdoms v.90 (beta)" &@CRLF& _
		"168.138.68.8:26955|DarkRavager DM Server"                  &@CRLF& _
		"68.83.198.53:26951|HexenWorld CTF"                         &@CRLF& _
		"168.138.68.8:26950|DarkRavagerSiege"                       &@CRLF& _
		"108.61.178.207:26950|de.quake.world:26950 Siege"           &@CRLF& _
		"51.195.189.61:26950|JakubM's Server"                       &@CRLF& _
		"108.61.178.207:26951|de.quake.world:26951 DM"
	$aTmpOffline[$ID_HER2] = "" & _
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
	$arrayOffline = StringSplit($aTmpOffline[$iGameIdx], @CRLF, BitOR($STR_NOCOUNT, $STR_ENTIRESPLIT))
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
		$UI_Btn_pingList, $UI_Btn_loadFav, $UI_Btn_settings, $UI_Btn_expand, $UI_Btn_offlineList]
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
	EnableUIButtons(False)
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
	Local $sIP, $iPort, $iPortGS, $splitIP, $iCount = UBound($ipArray) -1
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

;~ Func FillServerStringArrayPlayers($iGameID, $sData, $iCount)
;~ 	For $i = 0 to $iCount -1
;~ 		$g_aServerStrings[$iGameID-1][$i][$COL_PLAYERS] = $sData
;~ 	Next
;~ EndFunc

Func FillServerListView_popData($iGameIDx, $ListViewA)
	Local $splitIP, $sName, $sIP_Port, $sPing, $sPCount
	;Local $ListViewA = getListView_A_CID()
	Local $portIdx
	if $g_gameConfig[$iGameIdx][$NET_GS_P] then
		$portIdx = $COL_PORTGS
	else
		$portIdx = $COL_PORT
	endif

	_GUICtrlListView_BeginUpdate($ListViewA)
	_GUICtrlListView_DeleteAllItems($ListViewA)
	ConsoleWrite("popData gameID:"&$iGameIDx&@CRLF)
	local $sTmp
	For $i = 0 To $g_iMaxSer -1
		If $g_aServerStrings[$iGameIDx][$i][$COL_PING] > 0 Then ;ping. must be valid
			$sName = $g_aServerStrings[$iGameIDx][$i][$COL_NAME]
			$sIP_Port = StringFormat("%s:%i", $g_aServerStrings[$iGameIDx][$i][$COL_IP], $g_aServerStrings[$iGameIDx][$i][$portIdx])
			$sPing = StringFormat("%i", $g_aServerStrings[$iGameIDx][$i][$COL_PING]) ;int
			$sPCount = $g_aServerStrings[$iGameIDx][$i][$COL_PLAYERS]
			;fill listview
			;GUICtrlCreateListViewItem($i &'|'&$sIP_Port &'|'&$sName &'|'&$sPing&'|'&$sPCount, $ListViewA) ; not used as name may have "|"
			_GUICtrlListView_AddItem($ListViewA,    $i,              -1, $g_listID_offset+$i) ;offset ID.
			_GUICtrlListView_AddSubItem($ListViewA, $i, $sIP_Port, 1,-1)
			_GUICtrlListView_AddSubItem($ListViewA, $i, $sName,    2,-1)
			_GUICtrlListView_AddSubItem($ListViewA, $i, $sPing,    3,-1)
			_GUICtrlListView_AddSubItem($ListViewA, $i, $sPCount,  4,-1)
			; Set icon
			_GUICtrlListView_SetItemImage($ListViewA, $i, -1)
		Else
			ConsoleWrite("update:"& $i &@CRLF)
			ExitLoop
		EndIf
	Next
	_GUICtrlListView_EndUpdate($ListViewA)
EndFunc

Func CleanupServerName(ByRef $serverName, $iGameIdx)
	;cleanup server names, eg Quake3 uses ^2 for colored text
	Switch $iGameIdx
		Case $ID_SOF1
			$serverName = StringRegExpReplace($serverName, "[^ -ÿ]+" ,"") ;remove < asc(32)
		Case $ID_KPQ3, $ID_UNVAN, $ID_WARSOW, $ID_ALIENA, $ID_JK2, $ID_JK3, $ID_SOF2, $ID_STEF1
			$serverName = StringRegExpReplace($serverName, "\^." ,"") ;remove ^x
		;Case Else
		;todo ADD GAMES
	EndSwitch
EndFunc

;--> FILL ARRAY1
;========================================================
Func FillServerListView_SV_Responce($iGameIdx, ByRef $sIP, ByRef $sPort, ByRef $sPortGS, ByRef $svName, _
		ByRef $ping, ByRef $iPCount, ByRef $aSvData, ByRef $sPData, ByRef $map, ByRef $mod, $iListIndex)

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
	ConsoleWrite("-players:" &$sPlayers&@CRLF)
	If $sPlayers <> "" Then
		;_ArrayDisplay($sPlayers)
		_GUICtrlListView_BeginUpdate($ListViewB)
		;-------; add players info, max 31 char for player name
		Local $iply
		if $g_gameConfig[$iGameIdx][$NET_GS_P] _
		Or $iGameIdx = $ID_Q1 Or $iGameIdx = $ID_HEX Then ;hexen/q1 decompressed
		;todo ADD GAMES
			local const $aKey = ['player', 'frags', 'ping', 'deaths', 'team']

			;If StringInStr($serverVars, "player_0") Then
			Local $sXX[4], $sInfo[5], $tmp, $sArray, $aPData, $idx
			$aPData = StringSplit($sPlayers, "\", $STR_NOCOUNT)
			if not @error Then
				For $pIdx = 0 to $MAX_PLAYERS - 1
					$sInfo[0] = parseInfoString($aPData, StringFormat("%s_%i", $aKey[0], $pIdx)) ;name
					if $sInfo[0] <> "" Then
						ConsoleWrite("+found"&@CRLF)
						$sInfo[1] = parseInfoString($aPData, StringFormat("%s_%i", $aKey[1], $pIdx)) ;frags
						$sInfo[2] = parseInfoString($aPData, StringFormat("%s_%i", $aKey[2], $pIdx)) ;ping
						$sInfo[3] = parseInfoString($aPData, StringFormat("%s_%i", $aKey[3], $pIdx)) ;deaths
						$sInfo[4] = parseInfoString($aPData, StringFormat("%s_%i", $aKey[4], $pIdx)) ;team
					Else
						ExitLoop ;no players found
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
			Local $sTmp, $aPDetails, $name, $frags, $ping, $iPIdx = 0

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
		Local $idx = 0, $sTmp
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
		local $iCol = GUICtrlGetState($ListViewC)
		$g_vSortSense_C[0] = false
		$g_vSortSense_C[1] = false
		_GUICtrlListView_SimpleSort($ListViewC, $g_vSortSense_C, $g_ilastColumn_C, True) ;resort to user pref
	EndIf

EndFunc

;--> FILL ARRAY 2&3 STRINGS
;========================================================
; --> FillListView_BC_Selected
Func FillListView_BC_Selected($iTab, $iListNum)
	Local $serStrArray, $serSelNum, $i, $sPlayers
	Local $ListViewA = getListView_A_CID()
	Local $ListViewB = getListView_B_CID()
	Local $ListViewC = getListView_C_CID()
	Local $iGameIdx = $g_iCurGameID ;GetActiveGameIndex()

	If $iListNum = -1 Or $iTab >= $COUNT_GAME Then
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
	if $iGameIdx = $ID_Q1 Or $iGameIdx = $ID_HEX Then
		HEXGetPlayerInfo( _
			$g_aServerStrings[$iGameIdx][$serSelNum][$COL_IP], _
			$g_aServerStrings[$iGameIdx][$serSelNum][$COL_PORT], _
			$g_aServerStrings[$iGameIdx][$serSelNum][$COL_INFOSTR], _
			$g_aServerStrings[$iGameIdx][$serSelNum][$COL_INFOPLYR])
	EndIf
	;todo ADD GAMES
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

Func HEXSendGetPlayer($sIPAddress, $iPort, $g_hSocketServerUDP, $sRequest)
	;ConsoleWrite("-sending:" & StringToBinary($sRequest, 4)&@CRLF)
	local $iErrorX = _UDPSendTo($sIPAddress, $iPort, $sRequest, $g_hSocketServerUDP)
EndFunc

Func HEXProcessPlayerResponce($data)
	;local const $hex2_CCREP_SERVER_INFO = 131 ;0x83
	local const $hex2_CCREP_PLAYER_INFO = 132 ;0x84
	local const $hex2_NETFLAG_CTL = 0x80000000 ; 32768
	;ConsoleWrite("-data:"& StringToBinary($data, 1)&@CRLF)
	Local $ret = "", $i = 0, $pIdx, $name, $teamColor, $frags, $time, $address;, $header, $iMsgType
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
	local $iCount = 0, $dataRecv, $iPlyrCount

	if $aPlayerData <> "" then return ;$COL_INFOPLYR
	$iPlyrCount = Number(parseInfoString($aData, "numplayers"));check info string first
	if $iPlyrCount = 0 Then return
	;ConsoleWrite("+ping server for players"&@CRLF)

	_BIND_UDP_SOCKET($g_hSocketServerUDP)
	If $g_hSocketServerUDP > 0 Then
		_SetPacketBufferSize($g_hSocketServerUDP, 512) ; 25600
		;SendSTATUStoServers_Split
		for $i = 0 to $iPlyrCount-1
			HEXSendGetPlayer($sIPAddress, $iPort, $g_hSocketServerUDP, BinaryToString('0x80000007'&'03'&hex($i, 2)&"00")) ;todo move
		Next

		Local $iTimeOut = TimerInit()
		While 1 ;loop until all players recieved or timout hit
			While 1
				$dataRecv = _UDPRecvFrom($g_hSocketServerUDP, 512, 0)
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
	_UDPCloseSocket($g_hSocketServerUDP)
EndFunc


#EndRegion



#Region --> EVENT MOUSE, WM_NOTIFY



Func RighttClickMenuKP()
	Local $ListViewA = getListView_A_CID()
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
	Local $ListViewA = getListView_A_CID()
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
	local static $hListBox = GUICtrlGetHandle($UI_Combo_gameSelector)
    Local $hWndFrom, $iIDFrom, $iCode, $hWndListBox

	If Not IsHWnd($UI_Combo_gameSelector) Then $hWndListBox = GUICtrlGetHandle($UI_Combo_gameSelector)
    $hWndFrom = $lParam
    $iIDFrom = BitAND($wParam, 0xFFFF) ; Low Word
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
	Local $iIDFrom, $iCode, $tNMHDR, $tInfo, $listIndexNum
	#forceref $wParam

	If ($hWnd = $HypoGameBrowser) Then
		Switch $iMsg
			Case $WM_EXITSIZEMOVE
				ConsoleWrite("$WM_EXITSIZEMOVE"&@CRLF)
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
	Local $i, $tmp, $sTmp
	If $ipPort = "" Then
		ConsoleWrite("fav selection error"&@CRLF)
		Return ;wont be needed?
	EndIf

	;fav is stored using -10 port for kingpin/gamespy
	Switch $g_iTabNum
		Case $TAB_GB
			if $g_gameConfig[$iGameIdx][$NET_GS_P] then ;-10
				$ipPort = String( _
					$g_aServerStrings[$iGameIdx][$listIdx][$COL_IP] &":"& _
					$g_aServerStrings[$iGameIdx][$listIdx][$COL_PORT])
			EndIf
		Case $TAB_MB
			If $iMGameType = $ID_KP1 Then
				$sTmp = StringSplit($ipPort, ":")
				If Not @error Then
					$ipPort = StringFormat("%s:%i", $sTmp[1], Number($sTmp[2]) -10); subtract -10 for gamespy
				EndIf
			EndIf
	EndSwitch


	;_ArrayDisplay($g_aFavList)
	Local $aTmp = StringSplit($g_aFavList[$iGameIdx], "|")
	For $i = 1 to $aTmp[0]
		ConsoleWrite(">"&$aTmp[$i]&@CRLF)
		If StringCompare($ipPort, $aTmp[$i]) = 0 Then
			ConsoleWrite("existing fav"&@CRLF)
			Return ;existing
		EndIf
	Next

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
		RefreshServersInListview($g_iCurGameID)
		FinishedGettinServers()
	EndFunc

;allready in listview from master/offline
Func RefreshServersInListview($iGameIdx)
	Local $i, $sIP, $iPort, $sName, $ipPort, $aIPArray, $sTmp = "" ;Dim
	;Local $iGameIdx = $g_iCurGameID ;GetActiveGameIndex()
	Local $ListViewA = getListView_A_CID()
	Local $iServerCount = GetServerCountInArray($iGameIdx)

	If $g_iTabNum = $TAB_MB then ; ID_M Then
		MRefresh() ;refresh mbrowser
		Return
	EndIf

	;EnableUIButtons(False)
	;BeginGettinServers()
	;ListviewStoreIndexToArray()
	$g_iPlayerCount_GS = 0
	$g_iServerCountTotal = 0 ;get # servers to use later to stop refresh

	For $i = 0 To $g_iMaxSer -1
		If $g_aServerStrings[$iGameIdx][$i][$COL_PING] > 0 Then
			$sIP = $g_aServerStrings[$iGameIdx][$i][$COL_IP]
			$iPort = $g_aServerStrings[$iGameIdx][$i][$COL_PORT] ;gsPort
			;ReDim $aIPArray[$i+1]
			;$aIPArray[$i] = String($sIP & ":" & $iPort) ;add ip/port to array
			$sTmp &= String($sIP & ":" & $iPort) &"|"
			$g_iServerCountTotal += 1
		Else
			ExitLoop(1)
		EndIf
	Next
	$sTmp = StringTrimRight($sTmp, 1)

	;clear selected column.
	GUICtrlSendMsg($UI_ListV_svData_A, $LVM_SETSELECTEDCOLUMN, -1, 0) ;updateLV

	;update listview with invalid values
	FillServerStringArrayPing($iGameIdx, 999, $g_iServerCountTotal)
	FillServerListView_popData($iGameIdx, $ListViewA) ;$g_iServerCountTotal)

	$aIPArray = StringSplit($sTmp, "|", $STR_NOCOUNT)
	If IsArray($aIPArray) and UBound($aIPArray) > 0 Then

		local $iCount = UBound($aIPArray)
		local $aServerIdx[$iCount]
		for $i = 0 to $iCount -1
			$aServerIdx[$i] = $i
		Next
		SendStatustoServers_Init($iGameIdx, $aIPArray, $aServerIdx)
	EndIf

EndFunc

;===== FavArrayLoad() =====
;load fave per game tab, refresh them to
GUICtrlSetOnEvent($UI_Btn_loadFav, "UI_Btn_loadFavClicked")
	Func UI_Btn_loadFavClicked()
		Local $ListViewA = getListView_A_CID()
		Local $sIP_Port, $sIP, $iPort, $iGameIdx, $ipArray

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
	;EnableUIButtons(False)
	BeginGettinServers()
	ListviewStoreIndexToArray($g_iCurGameID)
	$g_iServerCountTotal = 1 ;get # servers to use later to stop refresh

	Local $aServerIP[1] ;only update 1 server
	Local $aServerIdx[1] ;only update 1 server
	Local $oldTime, $compTime, $iPing, $data1, $data2
	Local $ListViewA = getListView_A_CID()
	Local $listSelNum = _GUICtrlListView_GetSelectionMark($ListViewA) ;mouse selected num.
	Local $serSelNum = GetServerListA_SelectedData($LV_A_IDX) ;server index num (internal array ID)

	;~ if $g_gameConfig[$g_iCurGameID][$NET_GS_P] Then
		$aServerIP[0] = String($g_aServerStrings[$g_iCurGameID][$serSelNum][$COL_IP] &":"& _
		                      $g_aServerStrings[$g_iCurGameID][$serSelNum][$COL_PORT]) ; get game port (-10)
		$aServerIdx[0] = $serSelNum
	;~ Else
	;~ 	$aServerIP[0] = GetServerListA_SelectedData($LV_A_IP)
	;~ EndIf

	If $aServerIP[0] = "" Then
		;invalid ip
		Return
	EndIf

	;reset internal array
	$g_aServerStrings[$g_iCurGameID][$serSelNum][$COL_PLAYERS] = 0
	$g_aServerStrings[$g_iCurGameID][$serSelNum][$COL_PING] = 999
	$g_aServerStrings[$g_iCurGameID][$serSelNum][$COL_INFOSTR] = ""
	$g_aServerStrings[$g_iCurGameID][$serSelNum][$COL_INFOPLYR] = ""

	ConsoleWrite("ListNum= '" & $listSelNum &"'  ServerNum= '" &$serSelNum&"'"& @CRLF)
	ConsoleWrite("address= " & $aServerIP[0]&@CRLF)

	GUICtrlSetData($UI_Prog_getServer, 50)
	;reset array incase server does not reply, keep name
	_GUICtrlListView_SetItem($ListViewA, "999", $listSelNum, 3, -1)	;ping
	_GUICtrlListView_SetItem($ListViewA, "0/0", $listSelNum, 4, -1)	;players
	_GUICtrlListView_SetItem($ListViewA, "",    $listSelNum, 5, -1)	;map
	_GUICtrlListView_SetItem($ListViewA, "",    $listSelNum, 6, -1)	;mod

	SendStatustoServers_Init($g_iCurGameID, $aServerIP, $aServerIdx, False)

	;update server players/rules
	FillListView_BC_Selected($g_iCurGameID, $listSelNum);  $iGameID

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
						return $g_iCurGameID
					Case Else
						return $ID_KP1 ;default
				EndSwitch
				Return $g_iCurGameID; $g_iTabNum
			case $TAB_MB
				Switch $iMGameType
					Case 0 to $ID_Q2
						Return $iMGameType
					Case Else
						Return $ID_KP1 ;default
				EndSwitch
			Case Else
				Return $ID_KP1 ;default
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
			Case $ID_M
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
		If $g_UseTheme Then
			GUICtrlSetColor($UI_Obj_webPage, $COLOR_YELLOW)
			GUICtrlSetBkColor($UI_Obj_webPage, $COLOR_HYPO_BLACK)
		EndIf
		_IENavigate($UI_Obj_webPage, "https://forum.hambloch.com/c.php?r=kingpin")
	EndFunc ;_IECreateEmbedded


Func SetButtoShowState($iTab)
	Local Const $aButtons = [$UI_Btn_pingList, $UI_Btn_loadFav, $UI_Btn_offlineList]

	;main buttons
	Switch $iTab
		Case $TAB_GB ;gamespy
			GUICtrlSetState($UI_Btn_expand, $GUI_SHOW); expand button
			For $i = 0 to UBound($aButtons) - 1
				GUICtrlSetState($aButtons[$i], $GUI_SHOW)
			Next
		Case  $TAB_MB ;mbrowser
			GUICtrlSetState($UI_Btn_expand, $GUI_HIDE); expand button
			For $i = 0 to UBound($aButtons) - 1
				GUICtrlSetState($aButtons[$i], $GUI_HIDE)
			Next
		Case Else ;$TAB_CHAT, $TAB_CFG
			GUICtrlSetState($UI_Btn_expand, $GUI_HIDE); expand button
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
	Local $iGameID = ComboBoxEx_GetCurSel()
	ConsoleWrite("-tab:"&$iTab& " game:"&$iGameID&@CRLF)

	Switch $iTab
		Case $TAB_GB
			;GB Tab clicked, make sure dropdown is not M
			if $iGameID = $ID_M Then
				;GameSetup_Store()
				ConsoleWrite("!gid:"&$g_iGSGameLast&@CRLF)
				$g_iCurGameID = $g_iGSGameLast
				ComboBoxEx_SetCurSel($g_iGSGameLast)
				GameSetup_UpdateUI()
			EndIf
		Case $TAB_MB
			ConsoleWrite("-tab:"&$iTab&" m:"&$ID_M&@CRLF)
			;M Tab clicked. set dropdown to M
			ConsoleWrite("test:"&($iGameID = $ID_M)&@CRLF)
			if Not ($iGameID = $ID_M) Then
				ComboBoxEx_SetCurSel($ID_M)
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
	Local $data1, $data2
	Local $iRet = 0
	Local static $bSwitch = False
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
			$data1 = ConvertIPtoInt($g_aServerStrings[$g_iCurGameID][$nItem1][$COL_IP])
			$data2 = ConvertIPtoInt($g_aServerStrings[$g_iCurGameID][$nItem2][$COL_IP])
			if $data1 = $data2 Then
				$data1 = $data1 + 65536 + $g_aServerStrings[$g_iCurGameID][$nItem1][$COL_PORT]
				$data2 = $data2 + 65536 + $g_aServerStrings[$g_iCurGameID][$nItem2][$COL_PORT]
			endif
			$iRet = ($data1 < $data2)? (-1):(1)
		Case 2 ;sv name. a>z sort
			$data1 = $g_aServerStrings[$g_iCurGameID][$nItem1][$COL_NAME]
			$data2 = $g_aServerStrings[$g_iCurGameID][$nItem2][$COL_NAME]
			$iRet = ($data1 < $data2)? (-1):(1)
		Case 3 ;ping. a>z sort
			$data1 = $g_aServerStrings[$g_iCurGameID][$nItem1][$COL_PING]
			$data2 = $g_aServerStrings[$g_iCurGameID][$nItem2][$COL_PING]
			$iRet = ($data1 < $data2)? (-1):(1)
		Case 4 ;player count. z>a sort(high first)
			$data1 = $g_aServerStrings[$g_iCurGameID][$nItem1][$COL_PLAYERS]
			$data2 = $g_aServerStrings[$g_iCurGameID][$nItem2][$COL_PLAYERS]
			if $data1 = $data2 Then
				$data2 = $g_aServerStrings[$g_iCurGameID][$nItem1][$COL_IDX]
				$data1 = $g_aServerStrings[$g_iCurGameID][$nItem2][$COL_IDX]
			EndIf
			$iRet = ($data1 > $data2)? (-1):(1)
		Case 5 ;map.  a>z sort
			$data1 = $g_aServerStrings[$g_iCurGameID][$nItem1][$COL_MAP]
			$data2 = $g_aServerStrings[$g_iCurGameID][$nItem2][$COL_MAP]
			$iRet = ($data1 < $data2)? (-1):(1)
		Case 6 ;map.  a>z sort
			$data1 = $g_aServerStrings[$g_iCurGameID][$nItem1][$COL_MOD]
			$data2 = $g_aServerStrings[$g_iCurGameID][$nItem2][$COL_MOD]
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
		$idx2 = StringInStr($g_aGameSetup_EXE[$idx], "\", $STR_CASESENSE, -1)
		if $idx2 Then
			$sFolderPath = StringMid($g_aGameSetup_EXE[$idx], 1, $idx2)
			if Not FileExists($sFolderPath) Then $sFolderPath = @WorkingDir
		EndIf
		ConsoleWrite("-folder:"&$sFolderPath&@CRLF)
		Local $sFilename = _WinAPI_OpenFileDlg('', $sFolderPath, 'Executables (*.exe)|All Files (*.*)', 1, _
			$g_gameConfig[$idx][$GNAME_MENU]&'.exe', '', BitOR($OFN_PATHMUSTEXIST, $OFN_FILEMUSTEXIST, $OFN_HIDEREADONLY), 0, Default, Default, $HypoGameBrowser)
		If Not @error Then
			$g_aGameSetup_EXE[$idx] = $sFilename ;save now?
			ConsoleWrite("-ref:"&$refIdx&@CRLF)
			GUICtrlSetData($UI_In_gamePath, $sFilename)
		EndIf
	EndIf
EndFunc
GUICtrlSetOnEvent($UI_Btn_gamePath, "UI_Btn_gamePathClicked")
	Func UI_Btn_gamePathClicked()
		ButtonGamePath(Null)
	EndFunc

GUICtrlSetOnEvent($UI_Btn_gameRefresh, "UI_Btn_gameRefreshClicked")
	Func UI_Btn_gameRefreshClicked()
		;UI_CBox_autoRefresh sync...
		Local $idx = ComboBoxEx_GetCurSel()
		local $isChecked = _IsChecked($UI_Btn_gameRefresh)
		$g_aGameSetup_AutoRefresh[$idx] = $isChecked
		ConsoleWrite("refresh game id:" &$idx& " state:"&$isChecked&@CRLF)
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

Func getMaterExtraInfo($gameIDx)
	Return $g_aGameSetup_Master_Proto[$gameIDx] ;todo check this
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
			if $g_UseTheme Then
				GUICtrlSetColor($UI_In_refreshTime, $COLOR_IN1_TEXT)
				GUICtrlSetBkColor($UI_In_refreshTime, $COLOR_IN1_BG)
			EndIf
		Else
			GUICtrlSetState($UI_In_refreshTime, $GUI_ENABLE)
			if $g_UseTheme Then
				GUICtrlSetColor($UI_In_refreshTime, $COLOR_IN2_TEXT)
				GUICtrlSetBkColor($UI_In_refreshTime, $COLOR_IN2_BG)
			EndIf
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
	Local $intTimeStringBox, $oldGameID
	Local $timeCounted
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
			Local $aGames[$COUNT_GAME], $iOff ;
			$g_bAutoRefreshActive = True

			ResetRefreshTimmers() ; $g_iLastRefreshTime = TimerInit()

			if $iGameIdx = $ID_M Then
				MRefresh()
			else
				;move to next game in list to refresh(if any)
				For $i = 0 To $COUNT_GAME -1
					$iOff = Mod($g_iAutoRefreshGame +$i+1, $COUNT_GAME)
					If $g_aGameSetup_AutoRefresh[$iOff] Then
						$iGameIdx = $iOff
						;change selected game
						$g_iGSGameLast = $iGameIdx
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
	Local $msgBoxKeyID
	;failed
	;If $iGameIdx = $ID_KP1 Then
	;$g_aGameSetup_EXE

	local $sGameName = $g_gameConfig[$iGameIdx][$GNAME_MENU]


	$msgBoxKeyID = MsgBox(BitOR($MB_SYSTEMMODAL,$MB_OKCANCEL), _
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
	$sInputPath = $g_aGameSetup_EXE[$iGameIdx] ;GUICtrlRead($aRun[$iGameIdx])
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
	$sInputName = $g_aGameSetup_Name[$iGameIdx];GUICtrlRead($aNAME[$iGameIdx])
	if $sInputName <> "" Then
		$runCMDString &= StringFormat("+set name %s ", StringStripWS($sInputName, $STR_STRIPTRAILING +$STR_STRIPSPACES))
	EndIf
	;lunch commands
	$sInputCommand = $g_aGameSetup_RunCmd[$iGameIdx] ;GUICtrlRead($aCMD[$iGameIdx])
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
		ElseIf $iGameIdx = $ID_KP1 Then
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
	Local $aSoundPath = []

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
	GUICtrlSetData($MOTD_Input, $g_tmpStatusbarString)
	GUICtrlSetColor($MOTD_Input, 0)
EndFunc

Func setTempStatusBarMessage($sTempMessage, $bSetRed = False)
	$g_tmpStatusbarString = GUICtrlRead($MOTD_Input)
	GUICtrlSetData($MOTD_Input , $sTempMessage)
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
		$g_bGuiResized = False
	EndIf

	AutoRefreshTimer() ;check time for auto refresh
	Sleep(200)

	If Not ($g_statusBarTime = 0) Then
		If TimerDiff($g_statusBarTime) > 10000 Then
			$g_statusBarTime = 0
			RestoreStatusBarMessage()
		EndIf
	EndIf
WEnd
