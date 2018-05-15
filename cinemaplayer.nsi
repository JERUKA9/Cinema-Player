;NSIS Modern User Interface version 1.9
;Instalator CinemaPlayer
;Napisa³ Andrzej Milewski

;zmienne
;$1 - typ pliku ma³e litery w rejestrze ogólnym
;$2 - typ pliku du¿e litery w rejestrze lokalnym

!define MUI_PRODUCT "CinemaPlayer"
!define VER_MAJOR 1
!define VER_MINOR 4a
!define MUI_VERSION ${VER_MAJOR}.${VER_MINOR}

!include "MUI.nsh"

;--------------------------------
;Configuration

SetCompress force
SetCompressor Zlib

  !define MUI_COMPONENTSPAGE
    !define MUI_COMPONENTSPAGE_SMALLDESC
  !define MUI_DIRECTORYPAGE
  
  !define MUI_ABORTWARNING
  
  !define MUI_UNINSTALLER
  !define MUI_UNCONFIRMPAGE

  ;Language
  !insertmacro MUI_LANGUAGE "Polish"
  !insertmacro MUI_LANGUAGE "English"
  
  ;Titles
  LangString TITLE_SecPlayer ${LANG_ENGLISH} "Player"
  LangString TITLE_SecPlayer ${LANG_POLISH} "Odtwarzacz"
  LangString TITLE_SecMenuStart ${LANG_ENGLISH} "Start Menu + Desktop Shortcuts"
  LangString TITLE_SecMenuStart ${LANG_POLISH} "Menu Start i Pulpit"
  LangString TITLE_SecMSFolder ${LANG_ENGLISH} "StartMenu folder"
  LangString TITLE_SecMSFolder ${LANG_POLISH} "Folder w Menu Start"
  LangString TITLE_SecMSDesktop ${LANG_ENGLISH} "Desktop Shortcut"
  LangString TITLE_SecMSDesktop ${LANG_POLISH} "Skrót na pulpicie"
  LangString TITLE_SecMSQuickL ${LANG_ENGLISH} "Quicklunch Shortcut"
  LangString TITLE_SecMSQuickL ${LANG_POLISH} "Skrót w szybkim uruchamianiu"
  LangString TITLE_SecAssoc ${LANG_ENGLISH} "Associated files"
  LangString TITLE_SecAssoc ${LANG_POLISH} "Powi¹zania plików"
  LangString TITLE_SecAssPls ${LANG_ENGLISH} "Playlists"
  LangString TITLE_SecAssPls ${LANG_POLISH} "Playlisty"
  LangString TITLE_SecAssAV ${LANG_ENGLISH} "Audio/Video"
  LangString TITLE_SecAssAV ${LANG_POLISH} "Audio/Wideo"
  LangString TITLE_SecLang ${LANG_ENGLISH} "Languages"
  LangString TITLE_SecLang ${LANG_POLISH} "Jêzyki obs³ugi"
  
  ;Descriptions
  LangString DESC_SecPlayer ${LANG_POLISH} "Wymagane pliki do uruchomienia odtwarzacza"
  LangString DESC_SecPlayer ${LANG_ENGLISH} "Files required to use player"
  LangString DESC_SecMenuStart ${LANG_POLISH} "Ustawienia Menu Start i Pulpitu"
  LangString DESC_SecMenuStart ${LANG_ENGLISH} "Adds icons to your start menu, desktop and quicklunch for easy access"
  LangString DESC_SecAssoc ${LANG_POLISH} "Pliki z jakimi rozszerzeniami maj¹ siê uruchamiaæ po podwójnym klikniêciu mysz¹"
  LangString DESC_SecAssoc ${LANG_ENGLISH} "Associated files"
  LangString DESC_SecLang ${LANG_POLISH} "Pliki z jêzykami obs³ugi."
  LangString DESC_SecLang ${LANG_ENGLISH} "Language files"
  
  ;Other
  LangString OTH_MsgReadme ${LANG_POLISH} "Otworzyæ plik README.TXT?"
  LangString OTH_MsgReadme ${LANG_ENGLISH} "View README.TXT?"
  
  ;General
  OutFile "CinemaPlayer${VER_MAJOR}${VER_MINOR}.exe"
  
  ;Folder-selection page
  InstallDir "$PROGRAMFILES\${MUI_PRODUCT}"

;--------------------------------
;Installer Sections

Section  $(TITLE_SecPlayer) SecPlayer
SectionIn RO
  SetOutPath "$INSTDIR"
  File "D:\CP\program\CinemaPlayer.exe"
  File "D:\CP\program\autorun.inf"
  File "D:\CP\program\Keyboard.txt"
  File "D:\CP\program\License.txt"
  File "D:\CP\program\ReadMe.txt"
  
  StrCmp $LANGUAGE ${LANG_ENGLISH} 0 +3
    StrCpy $R1 "&Open with"
    StrCpy $R2 "P&lay with"
  StrCmp $LANGUAGE ${LANG_POLISH} 0 +3
    StrCpy $R1 "&Otwórz z"
    StrCpy $R2 "Od&twórz z"
  WriteRegStr HKCR "Applications\CinemaPlayer.exe\shell\open" "" "$R1 CinemaPlayer"
  WriteRegStr HKCR "Applications\CinemaPlayer.exe\shell\play" "" "$R2 CinemaPlayer"
  WriteRegStr HKCR "CinemaPlayer.File\shell\open" "" "$R1 CinemaPlayer"
  WriteRegStr HKCR "CinemaPlayer.File\shell\play" "" "$R2 CinemaPlayer"
  WriteRegStr HKCR "Applications\CinemaPlayer.exe\shell\open\command" "" "$\"$INSTDIR\CinemaPlayer.exe$\" $\"%L$\""
  WriteRegStr HKCR "Applications\CinemaPlayer.exe\shell\play\command" "" "$\"$INSTDIR\CinemaPlayer.exe$\" $\"%L$\""
  WriteRegStr HKCR "CinemaPlayer.File\DefaultIcon" "" "$INSTDIR\CinemaPlayer.exe,1"
  WriteRegStr HKCR "CinemaPlayer.File\shell\open\command" "" "$\"$INSTDIR\CinemaPlayer.exe$\" $\"%L$\""
  WriteRegStr HKCR "CinemaPlayer.File\shell\play\command" "" "$\"$INSTDIR\CinemaPlayer.exe$\" $\"%L$\""
  WriteRegStr HKCR "CinemaPlayer.File\shellex\PropertySheetHandlers" "" "AviPage"
  WriteRegStr HKCR "CinemaPlayer.File\shellex\PropertySheetHandlers\AviPage" "" "{00022613-0000-0000-C000-000000000046}"
  WriteRegStr HKCU "Software\ZbyloSoft\CinemaPlayer" "Lang" "Polski"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "AddOpenWith" "0"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "Antialias" "3"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "AudioVolume" "35"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "AutoFullScreen" "0"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "AutoPlay" "1"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "AutoSizeText" "1"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "AutoTextDelay" "1"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "CloseAfterPlay" "1"
  WriteRegBin HKCU "Software\ZbyloSoft\CinemaPlayer" "DefaultFPS" "0000000000003840"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "EdgeSpace" "3"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "FontBold" "1"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "FontCharset" "1"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "FontColor" "14737632"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "FontItalic" "0"
  WriteRegStr HKCU "Software\ZbyloSoft\CinemaPlayer" "FontName" "Arial"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "FontSize" "24"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "HideTaskBar" "0"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "LineSize" "10"
  WriteRegStr HKCU "Software\ZbyloSoft\CinemaPlayer" "MovieFolder" ""
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "Mute" "0"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "OneCopy" "0"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "OutLineColor" "0"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "PageSize" "60"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "PanelOnTop" "0"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "PauseOnControl" "0"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "Playlist" "0"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "RenderStyle" "3"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "Repeat" "0"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "ReverseWheel" "0"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "Shuffle" "0"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "Shutdown" "0"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "ShutdownDelay" "15"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "StayOnTop" "0"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "StopOnError" "0"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "SubtitleRows" "3"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "Slash2Italic" "1"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "TextDelay" "4"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "TurnOffCur" "3000"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "ViewStandard" "1"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "WaitShutdown" "1"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "WheelPosition" "1"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "ResDepth" "16"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "ResHeight" "480"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "ResWidth" "640"
  WriteRegDWORD HKCU "Software\ZbyloSoft\CinemaPlayer" "ResRefresh" "60"
  WriteRegStr HKCU "Software\ZbyloSoft\CinemaPlayer" "SubtitlesFolder" ""
  WriteRegStr HKCU "Software\ZbyloSoft\CinemaPlayer" "Supported" ""
  WriteRegStr HKCU "Software\ZbyloSoft\CinemaPlayer" "SupportedPLS" ""
  WriteRegStr HKCU "Software\ZbyloSoft\CinemaPlayer" "Associated" ""
  
  ;Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CinemaPlayer" "DisplayName" "CinemaPlayer"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CinemaPlayer" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegStr HKCU "Software\ZbyloSoft\CinemaPlayer" "Installer Language" $LANGUAGE
  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"
SectionEnd

SubSection  $(TITLE_SecMenuStart) SecMenuStart
  Section $(TITLE_SecMSFolder) SecMSFolder
  SectionIn RO
    CreateDirectory "$SMPROGRAMS\CinemaPlayer"
    CreateShortCut "$SMPROGRAMS\CinemaPlayer\CinemaPlayer.lnk" "$INSTDIR\CinemaPlayer.exe" "" "$INSTDIR\CinemaPlayer.exe" 0
    StrCmp $LANGUAGE ${LANG_ENGLISH} 0 +2
    StrCpy $R1 "Uninstall"
    StrCmp $LANGUAGE ${LANG_POLISH} 0 +2
    StrCpy $R1 "Odinstaluj"
    CreateShortCut "$SMPROGRAMS\CinemaPlayer\$R1 CinemaPlayer.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  SectionEnd
  Section $(TITLE_SecMSDesktop) SecMSDesktop
    CreateShortCut "$DESKTOP\CinemaPlayer.lnk" "$INSTDIR\CinemaPlayer.exe" "" "$INSTDIR\CinemaPlayer.exe" 0
  SectionEnd
  Section $(TITLE_SecMSQuickL) SecMSQuickL
    CreateShortCut "$QUICKLAUNCH\CinemaPlayer.lnk" "$INSTDIR\CinemaPlayer.exe" "" "$INSTDIR\CinemaPlayer.exe" 0
  SectionEnd
SubSectionEnd

SubSection $(TITLE_SecAssoc) SecAssoc
  SubSection $(TITLE_SecAssPls) SecAssPls
    Section "ASX"
      StrCpy $1 "asx"
      StrCpy $2 "ASX"
      StrCpy $3 "Y"
      Call InstallExt
    SectionEnd
    Section -
      StrCpy $2 "ASX"
      Call InstExtRegPLS
    SectionEnd
    Section "BPP"
      StrCpy $1 "bpp"
      StrCpy $2 "BPP"
      StrCpy $3 "Y"
      Call InstallExt
    SectionEnd
    Section -
      StrCpy $2 "BPP"
      Call InstExtRegPLS
    SectionEnd
    Section "LST"
      StrCpy $1 "lst"
      StrCpy $2 "LST"
      StrCpy $3 "Y"
      Call InstallExt
    SectionEnd
    Section -
      StrCpy $2 "LST"
      Call InstExtRegPLS
    SectionEnd
    Section "M3U"
      StrCpy $1 "m3u"
      StrCpy $2 "M3U"
      StrCpy $3 "Y"
      Call InstallExt
    SectionEnd
    Section -
      StrCpy $2 "M3U"
      Call InstExtRegPLS
    SectionEnd
    Section "MBL"
      StrCpy $1 "mbl"
      StrCpy $2 "MBL"
      StrCpy $3 "Y"
      Call InstallExt
    SectionEnd
    Section -
      StrCpy $2 "MBL"
      Call InstExtRegPLS
    SectionEnd
    Section "PLS"
      StrCpy $1 "pls"
      StrCpy $2 "PLS"
      StrCpy $3 "Y"
      Call InstallExt
    SectionEnd
    Section -
      StrCpy $2 "PLS"
      Call InstExtRegPLS
    SectionEnd
    Section "VPL"
      StrCpy $1 "vpl"
      StrCpy $2 "VPL"
      StrCpy $3 "Y"
      Call InstallExt
    SectionEnd
    Section -
      StrCpy $2 "VPL"
      Call InstExtRegPLS
    SectionEnd
  SubSectionEnd
  SubSection $(TITLE_SecAssAV) SecAssAV
    Section "ASF"
      StrCpy $1 "asf"
      StrCpy $2 "ASF"
      StrCpy $3 "Y"
      Call InstallExt
    SectionEnd
    Section -
      StrCpy $2 "ASF"
      Call InstExtReg
    SectionEnd
    Section "AVI"
      StrCpy $1 "avi"
      StrCpy $2 "AVI"
      StrCpy $3 "Y"
      Call InstallExt
    SectionEnd
    Section -
      StrCpy $2 "AVI"
      Call InstExtReg
    SectionEnd
    Section "M1V"
      StrCpy $1 "m1v"
      StrCpy $2 "M1V"
      StrCpy $3 "Y"
      Call InstallExt
    SectionEnd
    Section -
      StrCpy $2 "M1V"
      Call InstExtReg
    SectionEnd
    Section "MOV"
      StrCpy $1 "mov"
      StrCpy $2 "MOV"
      StrCpy $3 "Y"
      Call InstallExt
    SectionEnd
    Section -
      StrCpy $2 "MOV"
      Call InstExtReg
    SectionEnd
    Section "MPE"
      StrCpy $1 "mpe"
      StrCpy $2 "MPE"
      StrCpy $3 "Y"
      Call InstallExt
    SectionEnd
    Section -
      StrCpy $2 "MPE"
      Call InstExtReg
    SectionEnd
    Section "MPEG"
      StrCpy $1 "mpeg"
      StrCpy $2 "MPEG"
      StrCpy $3 "Y"
      Call InstallExt
    SectionEnd
    Section -
      StrCpy $2 "MPEG"
      Call InstExtReg
    SectionEnd
    Section "MPG"
      StrCpy $1 "mpg"
      StrCpy $2 "MPG"
      StrCpy $3 "Y"
      Call InstallExt
    SectionEnd
    Section -
      StrCpy $2 "MPG"
      Call InstExtReg
    SectionEnd
    Section "QT"
      StrCpy $1 "qt"
      StrCpy $2 "QT"
      StrCpy $3 "Y"
      Call InstallExt
    SectionEnd
    Section -
      StrCpy $2 "QT"
      Call InstExtReg
    SectionEnd
    Section "WMA"
      StrCpy $1 "wma"
      StrCpy $2 "WMA"
      StrCpy $3 "Y"
      Call InstallExt
    SectionEnd
    Section -
      StrCpy $2 "WMA"
      Call InstExtReg
    SectionEnd
    Section "WMV"
      StrCpy $1 "wmv"
      StrCpy $2 "WMV"
      StrCpy $3 "Y"
      Call InstallExt
    SectionEnd
    Section -
      StrCpy $2 "WMV"
      Call InstExtReg
    SectionEnd
  SubSectionEnd
SubSectionEnd

SubSection $(TITLE_SecLang) SecLang
  Section "English"
  SectionIn RO
    StrCmp $LANGUAGE ${LANG_ENGLISH} 0 +2
    WriteRegStr HKCU "Software\ZbyloSoft\CinemaPlayer" "Lang" "English"
    SetOutPath "$INSTDIR"
    File "D:\CP\program\English.lng"
  SectionEnd
  Section "Czech"
    SetOutPath "$INSTDIR"
    File "D:\CP\program\Czech.lng"
  SectionEnd
  Section "Deutsch"
    SetOutPath "$INSTDIR"
    File "D:\CP\program\Deutsch.lng"
  SectionEnd
  Section "Portugues(Brasil)"
    SetOutPath "$INSTDIR"
    File "D:\CP\program\Portugues(Brasil).lng"
  SectionEnd
  Section "Slovencina"
    SetOutPath "$INSTDIR"
    File "D:\CP\program\Slovencina.lng"
  SectionEnd
SubSectionEnd

;Display the Finish header
;Insert this macro after the sections if you are not using a finish page
!insertmacro MUI_SECTIONS_FINISHHEADER

;--------------------------------
;Descriptions
!insertmacro MUI_FUNCTIONS_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecPlayer} $(DESC_SecPlayer)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecMenuStart} $(DESC_SecMenuStart)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecAssoc} $(DESC_SecAssoc)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecLang} $(DESC_SecLang)
!insertmacro MUI_FUNCTIONS_DESCRIPTION_END
 
;--------------------------------
;Installer Functions
Function .onInit
  ;Font
  Push Tahoma
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Function .onInstSuccess
  MessageBox MB_YESNO $(OTH_MsgReadme) IDNO NoReadme
    Exec "notepad.exe $INSTDIR\ReadMe.txt" ; view readme or whatever, if you want.
  NoReadme:
FunctionEnd

;funkcja wi¹¿¹ca typy plików z programem
Function InstallExt
    ReadRegStr $R2 HKCU "Software\ZbyloSoft\CinemaPlayer" "Associated"
    WriteRegStr HKCU "Software\ZbyloSoft\CinemaPlayer" "Associated" "$R2$2$\r"
    ReadRegStr $R1 HKCR ".$1" ""
    StrCmp $R1 "" Label1
    StrCmp $R1 "CinemaPlayer.File" Label1
    WriteRegStr HKCR ".$1" "CPBackup" $R1
  Label1:
    WriteRegStr HKCR ".$1" "" "CinemaPlayer.File"
FunctionEnd

Function InstExtRegPLS
    StrCmp $3 "Y" Label1
    ReadRegStr $R1 HKCU "Software\ZbyloSoft\CinemaPlayer" "SupportedPLS"
    WriteRegStr HKCU "Software\ZbyloSoft\CinemaPlayer" "SupportedPLS" "$R1$2$\r$\n"
  Label1:
    StrCpy $3 "N"
FunctionEnd

Function InstExtReg
    StrCmp $3 "Y" Label1
    ReadRegStr $R1 HKCU "Software\ZbyloSoft\CinemaPlayer" "Supported"
    WriteRegStr HKCU "Software\ZbyloSoft\CinemaPlayer" "Supported" "$R1$2$\r$\n"
  Label1:
    StrCpy $3 "N"
FunctionEnd

Function un.BackExt
    ReadRegStr $R1 HKCR ".$2" ""
    StrCmp $R1 "CinemaPlayer.File" 0 NoBack
    ReadRegStr $R1 HKCR ".$2" "CPBackup"
    IfErrors Org
    StrCmp $R1 "CinemaPlayer.File" Org RestBack
    StrCmp $R1 "" 0 RestBack
  Org:
    WriteRegStr HKCR ".$2" "" "$2file"
    Goto NoBack
    RestBack:
    WriteRegStr HKCR ".$2" "" $R1
    DeleteRegValue HKCR ".$2" "CPBackup"
  NoBack:
FunctionEnd

Function un.onInit
  ;Get language from registry
  ReadRegStr $LANGUAGE HKCU "Software\ZbyloSoft\CinemaPlayer" "Installer Language"
FunctionEnd

;--------------------------------
;Uninstaller Section
Section "Uninstall"

StrCpy $2 "asx"
Call un.BackExt

StrCpy $2 "bpp"
Call un.BackExt

StrCpy $2 "lst"
Call un.BackExt

StrCpy $2 "m3u"
Call un.BackExt

StrCpy $2 "mbl"
Call un.BackExt

StrCpy $2 "pls"
Call un.BackExt

StrCpy $2 "vpl"
Call un.BackExt

StrCpy $2 "asf"
Call un.BackExt

StrCpy $2 "avi"
Call un.BackExt

StrCpy $2 "m1v"
Call un.BackExt

StrCpy $2 "mov"
Call un.BackExt

StrCpy $2 "mpe"
Call un.BackExt

StrCpy $2 "mpeg"
Call un.BackExt

StrCpy $2 "mpg"
Call un.BackExt

StrCpy $2 "qt"
Call un.BackExt

StrCpy $2 "wma"
Call un.BackExt

StrCpy $2 "wmv"
Call un.BackExt

  DeleteRegKey HKCR "Applications\CinemaPlayer.exe"
  DeleteRegKey HKCR "CinemaPlayer.File"
  DeleteRegKey HKCU "Software\ZbyloSoft\CinemaPlayer"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CinemaPlayer"

  Delete "$QUICKLAUNCH\CinemaPlayer.lnk"
  Delete "$DESKTOP\CinemaPlayer.lnk"
  Delete "$INSTDIR\CinemaPlayer.exe"
  Delete "$INSTDIR\autorun.inf"
  Delete "$INSTDIR\Keyboard.txt"
  Delete "$INSTDIR\License.txt"
  Delete "$INSTDIR\ReadMe.txt"
  Delete "$INSTDIR\Uninstall.exe"
  Delete "$INSTDIR\Czech.lng"
  Delete "$INSTDIR\Deutsch.lng"
  Delete "$INSTDIR\English.lng"
  Delete "$INSTDIR\Portugues(Brasil).lng"
  Delete "$INSTDIR\Slovencina.lng"

  RMDir "$INSTDIR"
  
  RMDir /r "$SMPROGRAMS\CinemaPlayer"
  
  ;Display the Finish header
  !insertmacro MUI_UNFINISHHEADER

SectionEnd