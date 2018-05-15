unit global_consts;

interface

uses
  Windows, Messages, Classes, cp_CinemaEngine;

const
  ProgName: PChar                    = 'CinemaPlayer';
  szURL: string                      = 'cinemaplayer.net';
  szEmail: PChar                     = 'info@';
  szWWW: PChar                       = 'www.';
  szForum: PChar                     = 'forum.';
  Author: PChar                      = 'Zbigniew Chwedoruk';
  Version: PChar                     = '1.6';
  Beta: PChar                        = 'beta9';
  Data: PChar                        = '17.01.2007';

  DefMovieExt: PChar                 = 'ASF'#13'AVI'#13'MKA'#13'MKV'#13'MOV'#13'MP4'#13'MPG'#13'MPE'#13'MPEG'#13'M1V'#13'OGG'#13'OGM'#13'QT'#13'RMVB'#13'WMA'#13'WMV'#13;
  DefPlayListExt: PChar              = 'PLS'#13'M3U'#13'ASX'#13'VPL'#13'BPP'#13'LST'#13'MBL'#13;
  DefSubtitleExt: PChar              = 'TXT'#13'SRT'#13'MPL'#13'MPL2'#13'SBT'#13'LRC'#13'SUB'#13'SSA'#13'ASS'#13;
  SaveSubtitleExt: PChar             = 'Sub Ripper hh:mm:ss,ms --> hh:mm:ss,ms...|*.srt|MicroDVD {xxxx}{xxxx}...|*.txt|' +
                                       'HATAK {hh:mm:ss,ms-hh:mm:ss,ms}...|*.txt|Lyrics [mm:ss]...|*.lrc|' +
                                       'MPL1 xxxx,xxxx,0,...(*.txt)|*.txt|MPL2 [xxxx][xxxx]...|*.txt|MPL3 [xxxx][xxxx]...|*.txt|' +
                                       'Time hh:mm:ss,1=...|*.txt|TMPlayer hh:mm:ss:...|*.txt';

  sHKEY: PChar                       = 'Software\ZbyloSoft\CinemaPlayer';

  sIs13Ver:PChar                     = 'Is13Ver';
  sPolski: PChar                     = 'Polski';
  sEnglish: PChar                    = 'English';

  iDonateID                          = 130;


  timerPlayer                 = 1;
  timerMouseOnCinema          = 100;
  timerClearSubtitle          = 200;
  timerShowEditor             = 300;
  timerRefreshVideoRect       = 400;
//  timerRefreshVideosize       = 500;
  timerEnableVideoResize      = 600;
  //timerPlayPause              = 700;
  timerGetOverlayColor        = 800;

  RenderAhead                 = 0.3;    // przyspieszenie wyswietlania napisow aby dac czas na rendering
  TextInterval: cardinal      = 50;
//  TextPause: double           = 0.1;

  RecentCount                 = 10;

  MinFontSize                 = 10;


  MinWindowWidth              = 556;
  MinWindowMiniWidth          = 200;
  MinWindowHeight             = 200;

  PatternColor: COLORREF      = $002CE2FC;
  MinInt: cardinal            = $80000000;

// Ikonki
  iconNone                    = -1;
  iconPlay                    = 0;
  iconPause                   = 1;
  iconStop                    = 2;
  iconPlayNext                = 3;
  iconPlayPrev                = 4;
  iconLargeBack               = 5;
  iconBack                    = 6;
  iconStep                    = 7;
  iconLargeStep               = 8;
  iconOpenFileOn              = 9;
  iconOpenTextOn              = 10;
  iconOpenFileOff             = 11;
  iconOpenTextOff             = 12;
  iconFullScreen              = 13;
  iconFixedFullScreen         = 14;
  iconVolume                  = 15;
  iconMute                    = 16;
  iconOptions                 = 17;
  iconShowSubtitles           = 18;
  iconHideSubtitles           = 19;
  iconStayOnTop               = 20;
  iconPowerOff                = 21;
  iconViewStandart            = 22;
  iconPlaylistShuffle         = 23;
  iconPlaylistRepeat          = 24;
  iconPlaylistSort            = 25;
  iconPlaylistMoveUp          = 26;
  iconPlaylistMoveDown        = 27;
  iconPlaylist                = 28;
  iconEditor                  = 29;
  iconExit                    = 30;
  iconNewText                 = 31;
  iconSave                    = 32;
  iconSaveAs                  = 33;
  iconInsertBefore            = 34;
  iconInsertAfter             = 35;
  iconDeleteLine              = 36;
  iconFindNextError           = 37;
  iconFindPrevError           = 38;
  iconError                   = 39;
  iconFollow                  = 40;
  iconCommitChanges           = 41;
  iconArrangeWindows          = 42;
  iconViewMinimal             = 43;
  iconTimeCorrector           = 44;

  ArrayVolume: array[0..35] of smallint =
    (-10000, -3500, -2400, -1800,
      -1600, -1400, -1200, -1000,
       -900,  -800,  -700,  -600,
       -500,  -450,  -400,  -350,
       -300,  -280,  -260,  -230,
       -200,  -180,  -160,  -140,
       -120,  -100,   -90,   -80,
        -70,  - 60,   -50,   -40,
        -30,   -20,   -10,     0);


  WM_REMOTE = WM_USER + $1000;

// sekcje w plikach INI
  sekcja: PChar                      = 'Settings';

  asf_list: PChar = '12'#13'14,998'#13'23,976'#13'24'#13'25'#13'29,97'#13'30';

type
  char100 = array[0..99] of char;
  Pchar100 = ^char100;

  TAutoFullScreen = (afsNone, afsFS, afsFFS);

  THistoryFile = packed record
    Movie: string;
    Text: string;
  end;
  PHistoryFile = ^THistoryFile;

  TBookmarkFile = packed record
    FileName: string;
    Position: double;
  end;
  PBookmarkFile = ^TBookmarkFile;

  TChangeResolution = packed record
    WindowPosition: TRect;
    Rate: integer;
    FullScreen: boolean;
    ResChanged: boolean;
    InChange: boolean;
    WP: TWindowPlacement;
  end;

  TTimeParts = packed record
    h, m, s, ms: WORD;
  end;
  PTimeParts = ^TTimeParts;

  TMouseWheelMode = (mwmVolume, mwmMediaPosition, mwmSubtitles);

var
  ChangeResolution: TChangeResolution;
  PopupMenuVisible: boolean = false;
  IdleMouseTime,
  PowerOffActive: cardinal;
  SSaverActive,
  OnlyChangePlayedItem: boolean;
  //ForceSystemSuspend: boolean = false;
  Punkt: TPoint;
  PSSnapshot: TCPPlayState;
  IsVer13: boolean;


implementation

end.
