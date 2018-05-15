unit settings_header;

interface

uses
  Windows, subtitles_header, subtitles_style, cp_FrameManager, global_consts,
  uSpeakerEngine;

type
  TRes = record
    Width: DWORD;
    Height: DWORD;
    Depth: DWORD;
    VRefresh: DWORD;
  end;

  TSbtAttr = record
    Style: TSubtitlesStyle;
    AntiAliasing: TAntialiasing;
    Overlay: boolean;
    RenderMode: TRenderMode;
  end;
  PSbtAttr = ^TSbtAttr;

  TSearchingOutOFSubtitles = (soosExact, soosSimilar, soosUnlike);

  TConfig = record
    _DonateID: integer;
    AddOpenWith: boolean;
    AspectRatio: TAspectRatioMode;
    Associated: string;
    AudioRenderer: integer;
    AudioVolume: integer;
    AutoFullScreen: TAutoFullScreen;
    Autoplay: boolean;
    AutoSizeText: boolean;
    AutoTextDelay: boolean;
    AdjustTextPos: boolean;
    Bookmarks: array[1..10] of PBookmarkFile;
    ClearHistoryAtExit: boolean;
    CloseAfterPlay: boolean;
    DefaultFPS: double;
    DblClick2FullScr: boolean;
    EdgeSpace: integer;
    Files: array[1..RecentCount] of PHistoryFile;
    HideTaskBar: boolean;
    ForceStdCtrlPanelMode: boolean;
    LastMediaTime: double;
    LineSize: integer;
    LoadSubtitles: boolean;
    DisableResizeFrame: boolean;
    MaxSubWidthActive: boolean;
    MaxSubWidth: integer;
    MaxSubWidthPercent: boolean;
    MouseWheelMode: TMouseWheelMode;
    MovieFolder: string;
    Mute: boolean;
    OneCopy: boolean;
    OSDAttr: TSbtAttr;
    OSDDisplayTime: DWORD;
    OSDEnabled: boolean;
    osd_x_margin: integer;
    osd_y_margin: integer;
    OSDCurrentTimeEnabled: boolean;
    OSDCurrentTime: cardinal;
    PageSize: integer;
    PanelOnTop: boolean;
    PauseAfterClick: boolean;
    PauseOnControl: boolean;
    PauseWhenMinimized: boolean;
    Playlist: boolean;
    PlaylistToLeft: boolean;
    RememberSuspendState: boolean;
    RepeatList: boolean;
    Res: TRes;
    ReverseWheel: boolean;
    TextDelay: integer;
    TurnOffCur: cardinal;
    ReverseTime: boolean;
    ScreenShotFolder: string;
    SearchingOutOfSubtitles: TSearchingOutOFSubtitles;
    SearchNextMoviePart,
    SearchNextMoviePartOnCDROM,
    Shuffle: boolean;
    Shutdown: integer;
    ShutdownDelay: integer;
    SpeakerEnabled: boolean;
    SpeakerFlushPrevPhrase: boolean;
    SpeakerHideSubtitles: boolean;
    SpeakerSelected: integer;
    SpeakerVolume: 0..100;
    SpeakerRate: 0..100;
    StayOnTop: boolean;
    StopOnError: boolean;
    SubtitlesAttr: TSbtAttr;
    SubtitlesFolder: string;
    SubtitleRows: integer;
    SubAutoMinTime,
    SubAutoMaxTime,
    SubAutoConstTime,
    SubAutoIncTime: double;
    Supported: string;
    SupportedPLS: string;
    SuspendState: boolean;
    ViewStandard,
    WaitShutdown: boolean;
  end;

var
  config: TConfig;
  
implementation


end.
