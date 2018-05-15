unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, cp_Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, ImgList, ToolWin, Menus, ActnList, ShellAPI,
  Buttons, cp_ListBoxes, cp_CinemaEngine, cp_Registry, subtitles_renderer,
  cp_TrackBars, cp_CustomListBox, cp_FrameManager, global_consts, shlobj,
  uControlPanel, uSpeakerEngine;

type
  TChangeVideoPosition = (
    cvpDecreaseLeft, cvpDecreaseRight, cvpDecreaseWidth, cvpDecreaseTop,
    cvpDecreaseBottom, cvpDecreaseHeight, cvpIncreaseLeft, cvpIncreaseRight,
    cvpIncreaseWidth, cvpIncreaseTop, cvpIncreaseBottom, cvpIncreaseHeight,
    cvpDecreaseSize, cvpIncreaseSize, cvpCenterPos, cvpFitToWindow,
    cvpNextAspectRatio);

  TChangeVideoPositionSet = set of TChangeVideoPosition;

  TMovieResizeBorder = (mrbLeft, mrbTop, mrbRight, mrbBottom, mrbInside, mrbNone);

  TfrmCinemaPlayer = class(TForm)
    MainMenu: TMainMenu;
    miFile: TMenuItem;
    miOpenMovie: TMenuItem;
    miOpenText: TMenuItem;
    miExit: TMenuItem;
    miView: TMenuItem;
    miZoom: TMenuItem;
    N2: TMenuItem;
    miFullScreen: TMenuItem;
    miFixedFullScreen: TMenuItem;
    N3: TMenuItem;
    miOptions: TMenuItem;
    miPlay: TMenuItem;
    miPlayPause: TMenuItem;
    miStop: TMenuItem;
    N4: TMenuItem;
    miLargeBack: TMenuItem;
    miLargeStep: TMenuItem;
    miBack: TMenuItem;
    miStep: TMenuItem;
    N5: TMenuItem;
    miVolume: TMenuItem;
    miUp: TMenuItem;
    miDown: TMenuItem;
    miMute: TMenuItem;
    mi50: TMenuItem;
    mi100: TMenuItem;
    mi200: TMenuItem;
    ActionList: TActionList;
    ilNormal: TImageList;
    aPlay: TAction;
    aPause: TAction;
    aStop: TAction;
    aLargeBack: TAction;
    aLargeStep: TAction;
    aBack: TAction;
    aStep: TAction;
    aPlaySlower: TAction;
    aPlayNormal: TAction;
    aPlayFaster: TAction;
    aOpenFiles: TAction;
    aOpenText: TAction;
    aFullScreen: TAction;
    aFixedFullScreen: TAction;
    aMute: TAction;
    aVolumeUp: TAction;
    aVolumeDown: TAction;
    PopupMenu: TPopupMenu;
    pmRetToWin: TMenuItem;
    aOptions: TAction;
    aRetToWin: TAction;
    a50: TAction;
    a100: TAction;
    a200: TAction;
    aHideText: TAction;
    miHideText: TMenuItem;
    aStayOnTop: TAction;
    N12: TMenuItem;
    miStayOnTop: TMenuItem;
    N14: TMenuItem;
    aTimeReverse: TAction;
    miTimeReverse: TMenuItem;
    N15: TMenuItem;
    N11: TMenuItem;
    aStatistics: TAction;
    miHelp: TMenuItem;
    miAbout: TMenuItem;
    N17: TMenuItem;
    pmMinimize: TMenuItem;
    N18: TMenuItem;
    miLangs: TMenuItem;
    miCodecsProps: TMenuItem;
    miRecentFiles: TMenuItem;
    miGotoBookmarks: TMenuItem;
    N19: TMenuItem;
    miSetBookmarks: TMenuItem;
    miClearRecent: TMenuItem;
    N21: TMenuItem;
    aClearRecent: TAction;
    aNextAspectRatio: TAction;
    miAspectRatio: TMenuItem;
    miAROryginal: TMenuItem;
    miARFree: TMenuItem;
    miAR16_9: TMenuItem;
    miAR4_3: TMenuItem;
    aSetAspectRatio: TAction;
    miAROther: TMenuItem;
    miPlaylist: TMenuItem;
    aClose: TAction;
    aPlayNext: TAction;
    aPlayPrev: TAction;
    miPlayPrev: TMenuItem;
    miPlayNext: TMenuItem;
    aPlaylist: TAction;
    aOpenList: TAction;
    aSaveList: TAction;
    aOpenDir: TAction;
    aAddFiles: TAction;
    aAddDir: TAction;
    aDelSel: TAction;
    aDelCrop: TAction;
    aDelDeath: TAction;
    aDelAll: TAction;
    aSelInvert: TAction;
    aSelNone: TAction;
    aSelAll: TAction;
    aSort: TAction;
    aShuffle: TAction;
    aRepeat: TAction;
    aMoveUp: TAction;
    aMoveDown: TAction;
    pmPlayList: TPopupMenu;
    Invertselect1: TMenuItem;
    Selectnone1: TMenuItem;
    Selectall1: TMenuItem;
    MenuItem1: TMenuItem;
    miDelSel: TMenuItem;
    miDelCrop: TMenuItem;
    Deletedeathentries1: TMenuItem;
    miDelAll: TMenuItem;
    pmAddItems: TPopupMenu;
    miOpenFiles: TMenuItem;
    miOpenDir: TMenuItem;
    MenuItem2: TMenuItem;
    miAddFiles: TMenuItem;
    miAddDir: TMenuItem;
    miOpenPlaylist: TMenuItem;
    miSavePlaylist: TMenuItem;
    N27: TMenuItem;
    Sortplaylist1: TMenuItem;
    Shuffle1: TMenuItem;
    Repeat1: TMenuItem;
    N28: TMenuItem;
    MoveUp1: TMenuItem;
    MoveDown1: TMenuItem;
    N1: TMenuItem;
    Shuffle2: TMenuItem;
    Repeat2: TMenuItem;
    N25: TMenuItem;
    Addfiles1: TMenuItem;
    Adddirectory1: TMenuItem;
    OpenDirectory1: TMenuItem;
    Openplaylist2: TMenuItem;
    Saveplaylist2: TMenuItem;
    aShutDown: TAction;
    miProperties: TMenuItem;
    miViewStandard: TMenuItem;
    miViewMinimal: TMenuItem;
    aViewStandard: TAction;
    aViewMinimal: TAction;
    aSubEditor: TAction;
    aSmallStep: TAction;
    aSmallBack: TAction;
    N8: TMenuItem;
    aSubtitleTimeReset: TAction;
    aSubtitleTimeBack: TAction;
    aSubtitleTimeForward: TAction;
    aExit: TAction;
    N20: TMenuItem;
    miSpeed: TMenuItem;
    miShutDown: TMenuItem;
    Showsubtitleeditor1: TMenuItem;
    aMinimize: TAction;
    aPlaylistToLeft: TAction;
    N6: TMenuItem;
    miPlaylistToLeft: TMenuItem;
    aReload: TAction;
    pmAudioStreams: TPopupMenu;
    aIncSubtitlesSize: TAction;
    aDecSubtitlesSize: TAction;
    aMoveSubtitlesUp: TAction;
    aMoveSubtitlesDown: TAction;
    aDecVideoSize: TAction;
    aIncVideoSize: TAction;
    aDecVideoSizeX: TAction;
    aDecVideoSizeY: TAction;
    aIncVideoSizeX: TAction;
    aIncVideoSizeY: TAction;
    aMoveVideoLeft: TAction;
    aMoveVideoRight: TAction;
    aMoveVideoUp: TAction;
    aMoveVideoDown: TAction;
    aMoveVideoLeftUp: TAction;
    aMoveVideoRightUp: TAction;
    aMoveVideoLeftDown: TAction;
    aMoveVideoRightDown: TAction;
    miAudioStreams: TMenuItem;
    aCurrentTimeOnOSD: TAction;
    aCenterVideoPos: TAction;
    aFitToWindow: TAction;
    aMoveOSDUp: TAction;
    aMoveOSDDown: TAction;
    miReload: TMenuItem;
    miSubTimeSetts: TMenuItem;
    aSubTimeSetts: TAction;
    aSetBookmark: TAction;
    aGotoBookmark: TAction;
    PlaylistBox: TPlaylistBox;
    PlaylistSplitter: TPanel;
    MyCinema: TCinema;
    aAbout: TAction;
    pnlMain: TPanel;
    pnlControl: TPanel;
    ToolBarV: TToolBar;
    tbMute: TToolButton;
    vtbVolume: TVolumeTrackBar;
    ptbSpeed: TPositionTrackBar;
    ptbPosition: TPositionTrackBar;
    ToolBar: TToolBar;
    tbPlayPrev: TToolButton;
    tbPlayPause: TToolButton;
    tbStop: TToolButton;
    tbPlayNext: TToolButton;
    tbSep1: TToolButton;
    tbSkipBack: TToolButton;
    tbRewind: TToolButton;
    tbFastForward: TToolButton;
    tbSkipForward: TToolButton;
    tbSep2: TToolButton;
    tbOpenMovie: TToolButton;
    tbOpenMovie2: TToolButton;
    tbOpenText: TToolButton;
    tbSep3: TToolButton;
    tbFullScreen: TToolButton;
    tbFixedFullScreen: TToolButton;
    tbViewMinimal: TToolButton;
    tbViewStandard: TToolButton;
    tbHideText: TToolButton;
    tbStayOnTop: TToolButton;
    tbSep4: TToolButton;
    tbPlaylist: TToolButton;
    tbSubEditor: TToolButton;
    tbOptions: TToolButton;
    tbExit: TToolButton;
    miEnableScreenShot: TMenuItem;
    aEnableScreenShot: TAction;
    aScreenShot: TAction;
    N9: TMenuItem;
    miScreenShot: TMenuItem;
    aSpeaker: TAction;
    miAR2_35_1: TMenuItem;
    aDonate: TAction;
    miDonate: TMenuItem;
    N7: TMenuItem;
    miForum: TMenuItem;
    miHomepage: TMenuItem;
    N10: TMenuItem;
    N13: TMenuItem;
    miShortcuts: TMenuItem;
    aShortcuts: TAction;
    N16: TMenuItem;
    miClearBookmark: TMenuItem;
    aClearBookmark: TAction;
    N22: TMenuItem;
    N23: TMenuItem;
    procedure MyCinemaPlayStateChange(PlayState: TCPPlayState);
    procedure MyCinemaReadyStateChange(ReadyState: TCPReadyState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ptbPositionChange(Sender: TObject);
    procedure MyCinemaResize(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure aPlayExecute(Sender: TObject);
    procedure aPauseExecute(Sender: TObject);
    procedure aStopExecute(Sender: TObject);
    procedure aLargeBackExecute(Sender: TObject);
    procedure aBackExecute(Sender: TObject);
    procedure aStepExecute(Sender: TObject);
    procedure aLargeStepExecute(Sender: TObject);
    procedure aPlaySlowerExecute(Sender: TObject);
    procedure aPlayNormalExecute(Sender: TObject);
    procedure aPlayFasterExecute(Sender: TObject);
    procedure aOpenFilesExecute(Sender: TObject);
    procedure aOpenTextExecute(Sender: TObject);
    procedure aFullScreenExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure aFixedFullScreenExecute(Sender: TObject);
    procedure aMuteExecute(Sender: TObject);
    procedure vtbVolumeChange(Sender: TObject);
    procedure aVolumeUpExecute(Sender: TObject);
    procedure aVolumeDownExecute(Sender: TObject);
    procedure aRetToWinExecute(Sender: TObject);
    procedure aOptionsExecute(Sender: TObject);
    procedure aHideTextExecute(Sender: TObject);
    procedure a50Execute(Sender: TObject);
    procedure a100Execute(Sender: TObject);
    procedure a200Execute(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure aStayOnTopExecute(Sender: TObject);
    procedure miRecentClick(Sender: TObject);
    procedure miGotoBookmarkClick(Sender: TObject);
    procedure miSetBookmarkClick(Sender: TObject);
    procedure aTimeReverseExecute(Sender: TObject);
    procedure aStatisticsExecute(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure ptbPositionNeedHint(Sender: TObject; ATime: integer);
    procedure vtbVolumeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MyCinemaMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MyCinemaMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MyCinemaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MyCinemaDblClick(Sender: TObject);
    procedure ptbPositionMouseEnter(Sender: TObject);
    procedure ptbPositionMouseLeave(Sender: TObject);
    procedure aClearRecentExecute(Sender: TObject);
    procedure aNextAspectRatioExecute(Sender: TObject);
    procedure aSetAspectRatioExecute(Sender: TObject);
    procedure miAROryginalClick(Sender: TObject);
    procedure aCloseExecute(Sender: TObject);
    procedure aPlayNextExecute(Sender: TObject);
    procedure aPlayPrevExecute(Sender: TObject);
    procedure aPlaylistExecute(Sender: TObject);
    procedure aOpenListExecute(Sender: TObject);
    procedure aOpenDirExecute(Sender: TObject);
    procedure aAddFilesExecute(Sender: TObject);
    procedure aAddDirExecute(Sender: TObject);
    procedure aDelSelExecute(Sender: TObject);
    procedure aDelCropExecute(Sender: TObject);
    procedure aDelDeathExecute(Sender: TObject);
    procedure aDelAllExecute(Sender: TObject);
    procedure aSelInvertExecute(Sender: TObject);
    procedure aSelNoneExecute(Sender: TObject);
    procedure aSelAllExecute(Sender: TObject);
    procedure aSortExecute(Sender: TObject);
    procedure aShuffleExecute(Sender: TObject);
    procedure aRepeatExecute(Sender: TObject);
    procedure aMoveUpExecute(Sender: TObject);
    procedure aMoveDownExecute(Sender: TObject);
    procedure PlaylistBoxDeleteItem(Sender: TObject);
    procedure PlaylistBoxAddItem(Sender: TObject);
    procedure PlaylistBoxEnd(Sender: TObject);
    procedure PlaylistBoxBegin(Sender: TObject);
    procedure PlaylistBoxDblClick(Sender: TObject);
    procedure PlaylistBoxChargeItem(Sender: TObject; Name: String;
      BeginPlay: Boolean; Position: Double);
    procedure PlaylistSplitterMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PlaylistSplitterMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure PlaylistSplitterMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure aShutDownExecute(Sender: TObject);
    procedure miPropertiesClick(Sender: TObject);
    procedure aViewStandardExecute(Sender: TObject);
    procedure aViewMinimalExecute(Sender: TObject);
    procedure aSaveListExecute(Sender: TObject);
    procedure aSubEditorExecute(Sender: TObject);
    procedure aSmallStepExecute(Sender: TObject);
    procedure aSmallBackExecute(Sender: TObject);
    procedure miFileClick(Sender: TObject);
    procedure miViewClick(Sender: TObject);
    procedure pmAddItemsPopup(Sender: TObject);
    procedure aSubtitleTimeResetExecute(Sender: TObject);
    procedure aSubtitleTimeBackExecute(Sender: TObject);
    procedure aSubtitleTimeForwardExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure aExitExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure miPlayClick(Sender: TObject);
    procedure ptbSpeedChange(Sender: TObject);
    procedure ptbSpeedMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure aMinimizeExecute(Sender: TObject);
    procedure aPlaylistToLeftExecute(Sender: TObject);
    procedure aReloadExecute(Sender: TObject);
    procedure ActionListExecute(Action: TBasicAction;
      var Handled: Boolean);
    procedure aIncSubtitlesSizeExecute(Sender: TObject);
    procedure aDecSubtitlesSizeExecute(Sender: TObject);
    procedure aMoveSubtitlesUpExecute(Sender: TObject);
    procedure aMoveSubtitlesDownExecute(Sender: TObject);
    procedure pmAudioStreamsPopup(Sender: TObject);
    procedure aCurrentTimeOnOSDExecute(Sender: TObject);
    procedure aDecVideoSizeExecute(Sender: TObject);
    procedure aIncVideoSizeExecute(Sender: TObject);
    procedure aDecVideoSizeXExecute(Sender: TObject);
    procedure aIncVideoSizeXExecute(Sender: TObject);
    procedure aDecVideoSizeYExecute(Sender: TObject);
    procedure aIncVideoSizeYExecute(Sender: TObject);
    procedure aMoveVideoLeftExecute(Sender: TObject);
    procedure aMoveVideoRightExecute(Sender: TObject);
    procedure aMoveVideoUpExecute(Sender: TObject);
    procedure aMoveVideoDownExecute(Sender: TObject);
    procedure aMoveVideoLeftUpExecute(Sender: TObject);
    procedure aMoveVideoRightUpExecute(Sender: TObject);
    procedure aMoveVideoLeftDownExecute(Sender: TObject);
    procedure aMoveVideoRightDownExecute(Sender: TObject);
    procedure aCenterVideoPosExecute(Sender: TObject);
    procedure aFitToWindowExecute(Sender: TObject);
    procedure aMoveOSDUpExecute(Sender: TObject);
    procedure aMoveOSDDownExecute(Sender: TObject);
    procedure aSubTimeSettsClick(Sender: TObject);
    procedure ptbPositionMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ptbPositionMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MyCinemaBeforeClose(Sender: TObject);
    procedure aSetBookmarkExecute(Sender: TObject);
    procedure aGotoBookmarkExecute(Sender: TObject);
    procedure ptbPositionMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure aAboutExecute(Sender: TObject);
    procedure pnlControlResize(Sender: TObject);
    procedure aEnableScreenShotExecute(Sender: TObject);
    procedure aScreenShotExecute(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure aSpeakerExecute(Sender: TObject);
    procedure aDonateExecute(Sender: TObject);
    procedure miHomepageClick(Sender: TObject);
    procedure aShortcutsExecute(Sender: TObject);
    procedure miForumClick(Sender: TObject);
    procedure aClearBookmarkExecute(Sender: TObject);
  private
    { Private declarations }
    PrevTick: cardinal;
    RateStr: string;
    OldX, OldY: integer;
    MovieResizeBorder: TMovieResizeBorder;
    OldPlayState: boolean;
    MovieResizePoint: TPoint;
    ptLMBDown: TPoint;
    dwLMBDownTime: DWORD;
    TempPlayState: TCPPlayState;
    TrayHandle: THandle;
    FOpenActionActive: boolean;
    change_pos_in_progress: boolean;
    frame_manager: TFrameManager;
    subtitle_viewer: TSubtitlesRenderer;
    osd_viewer: TOSDRenderer;
    overlay_color: COLORREF;
    is_overlay_color: boolean;
    _speaker: TSpeakerEngine;
    _old_fps: double;
    strTotalTime: string;
    bPauseAfterClick: boolean;

    procedure frame_managerChangeAspectRatio(Sender: TObject);
    function AddMenuItem(ParentMenu: TMenuItem; ItemName: string;
      ProcClick: TNotifyEvent; ItemShortCut: TShortCut; First, SetEnabled: boolean): TMenuItem;
    procedure ResetVideoSize;
    procedure BuildFilterlistMenu;
    procedure ChangeSize(const Width, Height: integer);
    procedure CheckCommandLine();
    procedure CreateBookmarkMenu;
    procedure CreateLangMenu;
    procedure DoPlaylistResize;
    function FindResolution: DEVMODE;
    procedure GetFilesFilters;
    procedure GetMovieProp;
    procedure miLanguageClick(Sender: TObject);
    procedure miSetAudioStreamClick(Sender: TObject);
    procedure WMTimer(var Msg: TWMTimer); message WM_TIMER;
    procedure WMRemote(var Msg: TMessage); message WM_REMOTE;
    procedure WMGetMinMaxInfo(var Msg: TMessage); message WM_GETMINMAXINFO;
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
    procedure WMCopyData(var Msg: TWMCopyData); message WM_COPYDATA;
    procedure WMSetText(var Msg: TWMSetText); message WM_SETTEXT;
    procedure WMShowWindow(var Msg: TWMShowWindow); message WM_SHOWWINDOW;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure WMMove(var Msg: TWMMove); message WM_MOVE;
    procedure RebuildBookmarks;
    procedure ReloadLang;
    procedure ReRenderSubtitle;
    procedure SafeResize(NewPosition: TRect; dx, dy: integer);
    procedure SetNewFontSize(NewWidth, NewHeight: integer);
    procedure SetParentMenu(ParentMenu: TComponent; Item: TMenuItem;
      Index: integer);
    procedure SetStatus;
    procedure ShowMinimal;
    procedure ShowStandard;
    procedure ShowSampleSubtitle;
    procedure ToggleFullScreen;
    procedure ChangeVideoPosition(cvp: TChangeVideoPositionSet;
      CustomAspectRatio: boolean);
    procedure AppActivate(Sender: TObject);
    procedure AppDeactivate(Sender: TObject);
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
    function InsertCD: boolean;
    procedure VideoRectChanged;
    procedure subtitle_viewerBeginUpdate;
    procedure subtitle_viewerEndUpdate;
    procedure osd_viewerEndUpdate;
    procedure resize_window;
    procedure apply_options();
    procedure EnumFunc(const filterName: PChar;
      hasPropertyPage: boolean);
    procedure runStreamAfterLoadingSubtitles(isFaultless: boolean);
    function findSubtitles(const strMediaFile: string;
      var strSubtitleFile: string): boolean;
    procedure freeSubMenus(miParent: TMenuItem; nLeaveCount: integer);
    procedure RebuildRecent(const NewFile: string);
  public
    { Public declarations }
    procedure DeltaTimeChange(Sender: TObject);
    procedure miCodecPropertyClick(Sender: TObject);
    procedure MyShowCursor(const Show: boolean);
    procedure OpenNewMovie(FileName: string; Position: double);
    procedure EnableNumpadShortcuts;
    procedure DisableNumpadShortcuts;
    function FindNextPart(var FName: string; allow_scan_cd: boolean = true): boolean;
    procedure loadSubtitles(const szFileName: string; bWarnIfError: boolean;
      bAlwaysLoadFile: boolean);
    property OpenActionActive: boolean read FOpenActionActive;
  end;

var
  frmCinemaPlayer: TfrmCinemaPlayer;

implementation

uses
  {$ifdef _debug} logger, {$endif}
  global, language, crazyhint, closing, subeditor, cp_subtitles,
  cp_utils, cp_RemoteControl, dlg_calctimeconfig, settings_header,
  subtitles_header,  subtitles_style, dlg_settings, dlg_about, file_types,
  zb_sys_env, dlg_corrector, uDlgShortcuts, uDlgDonate, uDlgSelectFile;

{$R *.DFM}

const
  wndWindowStyle: cardinal =
    WS_VISIBLE or WS_OVERLAPPEDWINDOW or WS_CLIPSIBLINGS or WS_CLIPCHILDREN;
  wndExWindowStyle: cardinal =
    WS_EX_ACCEPTFILES or WS_EX_WINDOWEDGE or WS_EX_CONTROLPARENT;
  fsWindowStyle: cardinal =
    WS_VISIBLE or WS_SYSMENU or WS_MINIMIZEBOX or WS_MAXIMIZEBOX or WS_CLIPSIBLINGS or WS_CLIPCHILDREN;
  fsExWindowStyle: cardinal =
    WS_EX_ACCEPTFILES or WS_EX_CONTROLPARENT;

  VK_VOLUME_MUTE = 173;
  VK_VOLUME_DOWN = 174;
  VK_VOLUME_UP = 175;
  VK_MEDIA_NEXT_TRACK = 176;
  VK_MEDIA_PREV_TRACK = 177;
  VK_MEDIA_STOP = 178;
  VK_MEDIA_PLAY_PAUSE = 179;
  VK_LAUNCH_MEDIA_SELECT = 181;

type
  TLastMovieState = record
    file_name: string;
    subtitle_name: string;
    aspect_ratio: TAspectRatioMode;
    video_rect: TRect;
    zoom: double;
    display_size: TCPDisplaySize;
    center_point: TCenterPoint;
    audio_stream: integer;
    is_part_prev_movie: boolean;
  end;

var
  ParamF: boolean = false;
  ParamFF: boolean = false;
  ParamM: boolean = false;
  ParamMinView: boolean = false;

  PlayListResizePos,
  PlayListResizeX: integer;
  PlayListResize: boolean;
  IgnoreMouseOnCinema: boolean = false;
  GotoFSAfterOpen: boolean = false;
  ShowCurrentTime: cardinal;
  SampleSubVisibled: boolean = false;

  FirstActivate: boolean = true;

  LastMovieState: TLastMovieState;

(*function MonitorHookCallBack(nCode: integer; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  if nCode < 0 then
  begin
    Result := CallNextHookEx(MyHook, nCode, wParam, lParam);
    exit;
  end;
    Result := CallNextHookEx(MyHook, nCode, wParam, lParam);

//  if {(MyCinema.PlayState = cpPlaying) and }(nCode = HCBT_SYSCOMMAND) and
//     ((wParam = SC_SCREENSAVE) or (wParam = SC_MONITORPOWER)) {and (not ForceSystemSuspend) }then
 //   Result := 1
//  else
//    Result := CallNextHookEx(MyHook, nCode, wParam, lParam);
end;*)

//  MyHook := SetWindowsHookEx(WH_CBT, @MonitorHookCallBack, hInstance, GetCurrentThreadId);

function SetActiveWnd(Parameter: Pointer): Integer;
begin
  SetForegroundWindow(THandle(Parameter));
  Sleep(1);
  SetForegroundWindow(THandle(Parameter));
  Result := 0;
  EndThread(0);
end;

procedure ShowWnd;
var
//  ShowThread: THandle;
  ShowThreadID: cardinal;
begin
  {ShowThread := }BeginThread(nil, 0, @SetActiveWnd, Pointer(frmCinemaPlayer.Handle), 0, ShowThreadID);
//  WaitForSingleObject(ShowThread, INFINITE);
//  CloseHandle(ShowThread);
end;

procedure TfrmCinemaPlayer.EnumFunc(const filterName: PChar;
  hasPropertyPage: boolean);
begin
{$IFDEF GRABBER}
  if filterName <> GrabberFilterName then
  begin
{$ENDIF}
    AddMenuItem(miCodecsProps, filterName, miCodecPropertyClick, 0, true,
      hasPropertyPage);
{$IFDEF GRABBER}
  end;
{$ENDIF}
end;

procedure TfrmCinemaPlayer.ToggleFullScreen;
var
  Tryb: TDeviceMode;
  Pdm: PDeviceMode;
begin
  while not subtitle_viewer.disable do
    Application.ProcessMessages;
  while not osd_viewer.disable do
    Application.ProcessMessages;

  frame_manager.set_hold_coords(true);
  MyCinema.VideoVisible := true; // fix problem with Video going to hell...
  with ChangeResolution do
  begin
    InChange := true;
    tbExit.Visible := FullScreen;

    if FullScreen then
    begin
      control_panel.gotoFullscreen;
//      if not isStandartView then
//        aViewMinimal.Execute;

      IdleMouseTime := GetTickCount;
      GetCursorPos(Punkt);

      WP.length := sizeof(WP);
      GetWindowPlacement(Handle, @WP);
      if ResChanged then
        if (Screen.Width = integer(config.Res.Width)) and
           (Screen.Height = integer(config.Res.Height)) and
           (GetDeviceCaps(CreateIC('DISPLAY', nil, nil, nil), BITSPIXEL) = integer(config.Res.Depth)) then
          ResChanged := false
        else
        begin
          Tryb := FindResolution;
          ChangeDisplaySettings(Tryb, CDS_FULLSCREEN);
          SetCursorPos(Screen.Width div 2, Screen.Height div 2);
        end;

      SendMessage(GetDesktopWindow, WM_SETREDRAW, 0, 0);
      Menu := nil;

      SetWindowLong(Handle, GWL_STYLE, fsWindowStyle);
      SetWindowLong(Handle, GWL_EXSTYLE, fsExWindowStyle);
      SendMessage(GetDesktopWindow(), WM_SETREDRAW, 1, 0);

      WindowPosition := BoundsRect;
      if ResChanged then
        BoundsRect := Rect(0, 0, Screen.Width, Screen.Height)
      else
        BoundsRect := Rect(Monitor.Left, Monitor.Top, Monitor.Left + Monitor.Width, Monitor.Top + Monitor.Height);

      control_panel.setVisible(false);

      DoPlaylistResize;
      if aPlaylist.Checked then
        aPlaylist.Execute;

      SetTimer(Handle, timerPlayer, 100, nil);

      if config.HideTaskBar then
        ShowWindow(TrayHandle, SW_HIDE);
//      tbViewMinimal.Hide;
      if ResChanged then
      begin
//        osd_viewer.disable;
        TempPlayState := MyCinema.PlayState;
        aReload.Execute;
        if TempPlayState = cpPlaying then
          aPlay.Execute;
//        if config.OSDEnabled then
//        begin
//          osd_viewer.clear;
//          osd_viewer.enable;
//        end;
      end;
    end
    else
    begin
      ShowWindow(TrayHandle, SW_SHOW);
      if ResChanged then
      begin
        Pdm := nil;
        ChangeDisplaySettings(Pdm^, 0);
//        MyCinema.ReconnectFilters;
      end;

      BoundsRect := WindowPosition;

      SetWindowLong(Handle, GWL_STYLE, wndWindowStyle);
      SetWindowLong(Handle, GWL_EXSTYLE, wndExWindowStyle);

      Menu := MainMenu;
      if not config.ViewStandard then
        Menu := nil;

      control_panel.gotoNormalWindow;
      control_panel.setVisible(true);

      SetWindowPlacement(Handle, @WP);
      ShowWindow(TrayHandle, SW_SHOW);
      Windows.SetFocus(TrayHandle);

      SetTimer(Handle, timerPlayer, 100, nil);
      ShowWindow(TrayHandle, SW_SHOW);
      if not aStayOnTop.Checked then
        SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
      ResChanged := false;
//      tbViewMinimal.Show;
    end;

    ShowWnd;

    Application.ProcessMessages;

    InChange := false;
    GetCursorPos(Punkt);
    IdleMouseTime := GetTickCount;
    MyShowCursor(true);
  end;
  frame_manager.set_hold_coords(false);
  frame_manager.change_video_pos;
  VideoRectChanged;

  if not aHideText.Checked then
  begin
    resize_window;
    if (not config.SpeakerEnabled) or (not config.SpeakerHideSubtitles) then
      subtitle_viewer.enable;
    ReRenderSubtitle;
  end;

  if config.OSDEnabled then
  begin
    osd_viewer.clear;
    osd_viewer.enable;
  end;
end;

procedure TfrmCinemaPlayer.MyCinemaPlayStateChange(PlayState: TCPPlayState);
begin
  case PlayState of
    cpStopped, cpClosed:
    begin
      KillTimer(Handle, timerPlayer);
//      if PlayState = cpStopped then
//        config.LastMediaTime := -1;
      aPause.Enabled := false;
      aPause.Checked := false;
      aPlay.Enabled := true;
      aPlay.Checked := false;
      aStop.Enabled := true;
      aStop.Checked := true;
      a50.Enabled := true;
      a100.Enabled := true;
      a200.Enabled := true;
      ptbPosition.Enabled := true;
      aLargeBack.Enabled := true;
      aBack.Enabled := true;
      aLargeStep.Enabled := true;
      aStep.Enabled := true;
      ptbSpeed.Enabled := true;
      miSpeed.Enabled := true;
      aPlaySlower.Enabled := true;
      aPlayNormal.Enabled := true;
      aPlayFaster.Enabled := true;
      aScreenShot.Enabled := aEnableScreenShot.Checked;
      miZoom.Enabled := true;
      miAudioStreams.Enabled := false;
      if miPlayPause <> nil then
      begin
        miPlayPause.Action := aPlay;
        tbPlayPause.Action := aPlay;
        if Assigned(frmEditor) then
          frmEditor.tbPlayPause.Action := aPlay;
      end;
      aPause.ShortCut := 0;
      aPlay.ShortCut := ShortCut(VK_SPACE,[]);
      control_panel.setStatus(LangStor[LNG_STATUS_STOPPED], cpsPlayerState);
      subtitle_viewer.Clear;
      SetStatus;

      if not OnlyChangePlayedItem then
      begin
        SystemParametersInfo(SPI_SETSCREENSAVEACTIVE, cardinal(SSaverActive), nil, 0);
        SystemParametersInfo(SPI_SETPOWEROFFACTIVE, PowerOffActive, nil, 0);
      end;
    end;
    cpPlaying:
    begin
      SetTimer(Handle, timerPlayer, 100, nil);
      aPause.Enabled := true;
//      aPause.Enabled := true;
      aPause.Checked := false;
      aStop.Checked := false;
      aPlay.Checked := true;
      miAudioStreams.Enabled := true;
      if miPlayPause <> nil then
      begin
        miPlayPause.Action := aPause;
        tbPlayPause.Action := aPause;
        if Assigned(frmEditor) then
          frmEditor.tbPlayPause.Action := aPause;
      end;
      aPlay.ShortCut := 0;
      aPause.ShortCut := ShortCut(VK_SPACE, []);
      control_panel.setStatus(LangStor[LNG_STATUS_PLAYING], cpsPlayerState);
      SystemParametersInfo(SPI_SETSCREENSAVEACTIVE, cardinal(false), nil, 0);
      SystemParametersInfo(SPI_SETPOWEROFFACTIVE, 0, nil, 0);
    end;
    cpPaused:
    begin
      control_panel.setStatus(LangStor[LNG_STATUS_PAUSED], cpsPlayerState);
      aPause.Checked := true;
      aPlay.Checked := false;
      if miPlayPause <> nil then
      begin
        miPlayPause.Action := aPlay;
        tbPlayPause.Action := aPlay;
        if Assigned(frmEditor) then
          frmEditor.tbPlayPause.Action := aPlay;
      end;
      aPause.ShortCut := 0;
      aPlay.ShortCut := ShortCut(VK_SPACE,[]);
    end;
  end;
end;

procedure TfrmCinemaPlayer.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Pdm: ^_devicemode;
begin
//  UnhookWindowsHookEx(MyHook);
//  aSubEditor.Checked := false;


{  frmEditor.lvText.OnCustomDrawItem := nil;
  frmEditor.lvText.OnCustomDrawSubItem := nil;
  frmEditor.lvText.OnData := nil;}

  KillTimer(Handle, timerPlayer);
  DragAcceptFiles(Handle, False);
  MyCinema.Close;
  if ChangeResolution.FullScreen then
  begin
    if ChangeResolution.ResChanged then
    begin
      Pdm := nil;
      MyShowCursor(true);
//      ChangeDisplaySettingsEx(nil, Pdm^, 0, 0, nil);
      ChangeDisplaySettings(Pdm^, 0);
    end;
    ShowWindow(TrayHandle, SW_SHOW);
    ShowWindow(TrayHandle, SW_SHOW);
    ShowWindow(TrayHandle, SW_SHOW);
  end;
  if config.ClearHistoryAtExit then
    aClearRecent.Execute;
//  Hide;
end;

procedure TfrmCinemaPlayer.MyCinemaReadyStateChange(ReadyState: TCPReadyState);
var
  i: integer;

  procedure CloseMovie;
  begin
    control_panel.setStatus('', cpsMedianame);
    Caption := ProgName + ' ' + Version + Beta + ' - ' + szWWW + szURL;
    miZoom.Enabled := false;
    miSpeed.Enabled := false;
    aReload.Enabled := false;
    aOpenText.Enabled := false;
    MyShowCursor(true);
    aPlay.Enabled := false;
    aPlay.Checked := false;
    aPause.Enabled := false;
    aPause.Checked := false;
    aStop.Enabled := false;
    aStop.Checked := false;
    aLargeBack.Enabled := false;
    aBack.Enabled := false;
    aLargeStep.Enabled := false;
    aStep.Enabled := false;
    ptbSpeed.Enabled := false;
    aPlaySlower.Enabled := false;
    aPlayNormal.Enabled := false;
    aPlayFaster.Enabled := false;
    aScreenShot.Enabled := false;
    aOpenFiles.ImageIndex := iconOpenFileOff;
    aOpenFiles.Hint := LangStor[LNG_OPENMOVIE];
    control_panel.setStatus('', cpsCurrTime);
    control_panel.setStatus('', cpsFormat);
    control_panel.setStatus('', cpsPlayerState);
    control_panel.setStatus('', cpsToptime);
  end;

var
  audio_track_name: string;
begin
  case ReadyState of
    cpReadyStateUninitialized:
    begin
      CloseMovie;
    end;
    cpReadyStateComplete:
    begin
      frame_manager.change_video_pos;
      VideoRectChanged;
      ShowWnd;

      LastMovieState.is_part_prev_movie :=
        (LastMovieState.file_name <> '') and
        IsNextFile(LastMovieState.file_name, ExtractFileName(MyCinema.FileName), true);

      freeSubMenus(pmAudioStreams.Items, 0);
      freeSubMenus(miAudioStreams, 0);

      strTotalTime := PrepareTime(MyCinema.Duration);
      if MyCinema.AudioStreamsCount > 0 then
      begin
        for i := 0 to MyCinema.AudioStreamsCount - 1 do
        begin
          if MyCinema.AudioStreams[i].name = '' then
            audio_track_name := Format(LangStor[LNG_AUDIO] + ' %d', [i + 1])
          else
            audio_track_name := MyCinema.AudioStreams[i].name;
          AddMenuItem(pmAudioStreams.Items, audio_track_name,
            miSetAudioStreamClick, 0, false, true);
        end;

        if LastMovieState.is_part_prev_movie then
          pmAudioStreams.Items[LastMovieState.audio_stream].Click
        else
        begin
          // find correct language
          i := MyCinema.AudioStreamsCount - 1;
          while i >= 0 do
          begin
            if (MyCinema.AudioStreams[i].langID = languages_list.current_lang) or
               (MyCinema.AudioStreams[i].langID = languages_list.selected_lang) then
              break;
            dec(i);
          end;

          // language not found
          if i = -1 then
          begin
            // find correct mian language
            i := MyCinema.AudioStreamsCount - 1;
            while i >= 0 do
            begin
              if ((MyCinema.AudioStreams[i].langID and $ff) = (languages_list.current_lang and $ff)) or
                 ((MyCinema.AudioStreams[i].langID and $ff) = (languages_list.selected_lang and $ff)) then
                break;
              dec(i);
            end;
          end;

          if i = -1 then
            if MyCinema.AudioStreamsCount > 0 then
              i := 0;

          if i <> -1 then
            pmAudioStreams.Items[i].Click;
        end;
      end;

      miProperties.Enabled := MyCinema.Duration > 0;

      if miProperties.Enabled then
      begin
        control_panel.setStatus(ExtractFileName(MyCinema.FileName), cpsMedianame);
        Caption := ProgName + ': "' + control_panel.getStatus(cpsMedianame) + '"';
        aReload.Enabled := true;
        aOpenText.Enabled := true;
        aOpenFiles.ImageIndex := iconOpenFileOn;
        aOpenFiles.Hint := LangStor[LNG_OPENMOVIE] + #13 + MyCinema.FileName;
        GetMovieProp;
        vtbVolumeChange(nil);
        if (not ChangeResolution.FullScreen) and (WindowState <> wsMaximized) then
        begin
          if MyCinema.VideoSize.cx <> -1 then
          begin
            ResetVideoSize;
          end;
        end;

//          PlaylistBox.MovieProp.TextFileName := config.Files[1].Text;
        SetStatus;
        if {FirstActivate or} not ChangeResolution.InChange then
        begin
          if not (aFullScreen.Checked or aFixedFullScreen.Checked) then
          begin
            aFullScreen.Enabled := true;
            aFixedFullScreen.Enabled := true;
          end;

          RebuildRecent(MyCinema.FileName);
          control_panel.setStatus(PrepareTime(MyCinema.CurrentPosition, false), cpsCurrTime);
          loadSubtitles(config.Files[1].Text, false, false);
        end;
        control_panel.setStatus('/ ' + strTotalTime, cpsToptime);
      end
      else
      begin
        MyCinema.Close;
//        CloseMovie;

        DisplayError(LangStor[LNG_MSG_BADFILE]);
      end;
    end;
  end;
end;

procedure TfrmCinemaPlayer.GetMovieProp;
begin
  ptbPosition.Max := round(MyCinema.Duration * 10);
  ptbPosition.SilentPosition := round(MyCinema.CurrentPosition * 10);
  aPlayNormalExecute(nil);

  if MyCinema.FPS = 1 then
  begin
    ptbSpeed.Enabled := false;
    aPlaySlower.Enabled := false;
    aPlayNormal.Enabled := false;
    aPlayFaster.Enabled := false;
  end;
end;

procedure TfrmCinemaPlayer.ptbPositionChange(Sender: TObject);
begin
  if ptbPosition.Enabled then
  begin
    _speaker.flush();
    MyCinema.CurrentPosition := ptbPosition.Position / 10;
    control_panel.setStatus(PrepareTime(MyCinema.CurrentPosition, false), cpsCurrTime);
    osd_viewer.render(control_panel.getStatus(cpsCurrTime));
    Subtitles.ResetDynamic;
  end;
end;

procedure TfrmCinemaPlayer.MyCinemaResize(Sender: TObject);
begin
  if Assigned(frame_manager) then
  begin
    frame_manager.change_video_pos;
    subtitle_viewer.set_parent_rect(MyCinema.ClientRect);
    osd_viewer.set_parent_rect(MyCinema.ClientRect);
    VideoRectChanged;
    ReRenderSubtitle;
    SetTimer(Handle, timerGetOverlayColor, 300, nil);
  end;
end;

procedure TfrmCinemaPlayer.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
var
  MyShiftState: TShiftState;
begin
  MyShiftState := KeyDataToShiftState(Msg.KeyData);
//    CTRL+
  if MyShiftState = [ssCtrl] then
  begin
// w trybie pe³noekranowym menu jest od³aczone od formy wiêc nie dzia³aj¹ sktóty od zak³adek
    if (Msg.CharCode in [ord('0') .. ord('9')]) and (ChangeResolution.FullScreen) then
    begin
      if Msg.CharCode = ord('0') then
        miGotoBookmarks.Items[9].Click
      else
        miGotoBookmarks.Items[Msg.CharCode - ord('1')].Click;
      Handled := true;
    end;
  end;

//    SHIFT+
  if (ssShift in MyShiftState) then
  begin
//    CTRL+SHIFT+
    if (ssCtrl in MyShiftState) then
    begin
      Handled := true;
      if Msg.CharCode = ord('T') then
        aOpenText.Execute
      else
        if Msg.CharCode = ord('L') then
          aOpenList.Execute
        else
          if Msg.CharCode = ord('O') then
            aOpenFiles.Execute
          else
            if Msg.CharCode = ord('D') then
              aOpenDir.Execute
            else
              if (Msg.CharCode in [ord('0') .. ord('9')]) and (ChangeResolution.FullScreen) then
              begin
                if Msg.CharCode = ord('0') then
                  miSetBookmarks.Items[9].Click
                else
                  miSetBookmarks.Items[Msg.CharCode - ord('1')].Click;
              end
              else
                Handled := false;
    end
    else
//    ALT+SHIFT+
      if (ssAlt in MyShiftState) then
      begin
        Handled := true;
        if Msg.CharCode = ord('O') then
          aAddFiles.Execute
        else
          if Msg.CharCode = ord('D') then
            aAddDir.Execute
          else
            Handled := false;
      end;
  end;
end;

procedure TfrmCinemaPlayer.aPlayExecute(Sender: TObject);
begin
  if (MyCinema.FileName = '') then
  begin
    miRecentFiles[0].Click;
    if (MyCinema.Duration - config.LastMediaTime) > 0.1 then
      MyCinema.CurrentPosition := config.LastMediaTime
    else
      MyCinema.Stop;
    exit;
  end;

  aPlay.Checked := true;
  aPause.Checked := false;
  aStop.Checked := false;

  if MyCinema.PlayState <> cpPaused then
    ShowCurrentTime := GetTickCount;

  MyCinema.VideoVisible := true;
  MyCinema.Play;
{  if not ChangeResolution.FullScreen then
  begin
    if ((config.AutoFullScreen = afsFS) and GotoFSAfterOpen) or ParamF then
    begin
      aFullScreen.Execute;
    end
    else
      if ((config.AutoFullScreen = afsFFS) and GotoFSAfterOpen) or ParamFF then
      begin
        aFixedFullScreen.Execute;
      end
  end;}
  ParamF := false; ParamFF := false; GotoFSAfterOpen := false;
end;

procedure TfrmCinemaPlayer.aPauseExecute(Sender: TObject);
begin
  aPause.Checked := true;
  aPlay.Checked := false;
  MyCinema.Pause;
end;

procedure TfrmCinemaPlayer.aStopExecute(Sender: TObject);
begin
  aPlay.Checked := false;
  aPause.Checked := false;
  aStop.Checked := true;
  MyCinema.CurrentPosition := 0;
  ptbPosition.Position := 0;
  MyCinema.Stop;
  _speaker.flush();
end;

procedure TfrmCinemaPlayer.aLargeBackExecute(Sender: TObject);
begin
  with ptbPosition do
    Position := Position - config.PageSize * 10;
end;

procedure TfrmCinemaPlayer.aBackExecute(Sender: TObject);
begin
  with ptbPosition do
    Position := Position - config.LineSize * 10;
end;

procedure TfrmCinemaPlayer.aStepExecute(Sender: TObject);
begin
  with ptbPosition do
    Position := Position + config.LineSize * 10;
end;

procedure TfrmCinemaPlayer.aLargeStepExecute(Sender: TObject);
begin
  with ptbPosition do
    Position := Position + config.PageSize * 10;
end;

procedure TfrmCinemaPlayer.aPlaySlowerExecute(Sender: TObject);
begin
  with MyCinema do
    if Rate <> 0 then
    begin
      Rate := Rate - 0.05;
      aPlaySlower.Enabled := Rate > 0.1;
      aPlayFaster.Enabled := Rate < 2.0;
      ptbSpeed.Position := round(Rate * 10);
    end;
end;

procedure TfrmCinemaPlayer.aPlayNormalExecute(Sender: TObject);
begin
  with MyCinema do
    if Rate <> 0 then
    begin
      Rate := 1.0;
      aPlaySlower.Enabled := true;
      aPlayFaster.Enabled := true;
      ptbSpeed.Position := round(Rate * 10);
    end;
end;

procedure TfrmCinemaPlayer.aPlayFasterExecute(Sender: TObject);
begin
  with MyCinema do
    if Rate <> 0 then
    begin
      Rate := Rate + 0.05;
      aPlaySlower.Enabled := Rate > 0.1;
      aPlayFaster.Enabled := Rate < 2.0;
      ptbSpeed.Position := round(Rate * 10);
    end;
end;

procedure TfrmCinemaPlayer.aOpenFilesExecute(Sender: TObject);
begin
  FOpenActionActive := true;
  IgnoreMouseOnCinema := true;
//  osdPanel.Enabled := false;
  try
//    if aStayOnTop.Checked then
//      SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
    MyShowCursor(true);
//    Hide;
    PlaylistBox.OpenItem(false, oitFile);
//    MyCinema.pVideoWindow.put_Owner(Self.Handle);
//    MyCinema.pVideoWindow.put_MessageDrain(Self.Handle);
//    MyCinema.pVideoWindow.put_WindowStyle(WS_CHILD + WS_CLIPSIBLINGS + WS_CLIPCHILDREN);
//    Show;
  finally
//    if aStayOnTop.Checked then
//      SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
    FOpenActionActive := false;
    SetTimer(Self.Handle, timerMouseOnCinema, 3000, nil);
//    osdPanel.Enabled := true;
  end;
end;

procedure TfrmCinemaPlayer.aOpenTextExecute(Sender: TObject);
begin
  FOpenActionActive := true;
  try
//    if aStayOnTop.Checked then
//      SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
    MyShowCursor(true);
    with OpenDialog do
    begin
      Filter := PlaylistBox.SubtitleFilter + '|' + PlaylistBox.AllFilter;
      FilterIndex := 1;
      FileName := '';
      if (GetKeyState(VK_SHIFT) and $80) <> 0 then
        InitialDir := config.SubtitlesFolder
      else
        if FileExists(Subtitles.FileName) then
          InitialDir := ExtractFilePath(Subtitles.FileName)
        else
          InitialDir := ExtractFilePath(MyCinema.FileName);

      IgnoreMouseOnCinema := true;

      if Execute then
      begin
        Application.ProcessMessages;
        loadSubtitles(FileName, true, false);
        SetTimer(Self.Handle, timerMouseOnCinema, 3000, nil);
      end
      else
        IgnoreMouseOnCinema := false;
    end;
    if ChangeResolution.FullScreen and control_panel.isVisibled then
      control_panel.setVisible(false);
  finally
//    if aStayOnTop.Checked then
//      SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
    FOpenActionActive := false;
  end;
end;

procedure TfrmCinemaPlayer.aFullScreenExecute(Sender: TObject);
begin
  with ChangeResolution do
  begin
    FullScreen := not FullScreen;
    aFullScreen.Checked := FullScreen;
    aFixedFullScreen.Enabled := not FullScreen;
    ResChanged := false;
    ToggleFullScreen;
  end;
end;

procedure TfrmCinemaPlayer.FormCreate(Sender: TObject);
const
  panelMode: array[boolean] of tControlPanelDesign = (cpdMini, cpdStandart);
var
  bmp: TBitmap;
  i: integer;
begin
//  mouseLButtonDownPoint.x := -100;
//  mouseLButtonDownPoint.y := -100;
  bPauseAfterClick := false;
  dwLMBDownTime := 0;
  Application.OnMessage := AppMessage;
  control_panel := tControlPanel.create(pnlControl.Handle, cpdStandart, cpmEmbeded);
  frame_manager := TFrameManager.Create;
  frame_manager.assign_cinema(MyCinema);
  frame_manager.OnChangeAspectRatio := frame_managerChangeAspectRatio;
  LastMovieState.file_name := '';
  LastMovieState.is_part_prev_movie := false;

  change_pos_in_progress := false;
  FOpenActionActive := false;
  SystemParametersInfo(SPI_GETSCREENSAVEACTIVE, 0, @SSaverActive, 0);
  SystemParametersInfo(SPI_GETPOWEROFFACTIVE, 0, @PowerOffActive, 0);
  Subtitles.OnDeltaTimeChange := DeltaTimeChange;

  bmp := TBitmap.Create;
  Bmp.LoadFromResourceName(hInstance, 'IKONY');
  ilNormal.AddMasked(bmp, clFuchsia);
  bmp.free;

  Caption := ProgName + ' ' + Version + Beta + ' - ' + szWWW + szURL;
  OldX := MaxInt; OldY := MaxInt;
  DragAcceptFiles(Handle, True);

  TrayHandle := FindWindow('Shell_TrayWnd', nil);
  ToolBar.ButtonWidth := 22;
  ToolBar.DoubleBuffered := true;
  ToolBarV.DoubleBuffered := true;
  vtbVolume.DoubleBuffered := true;
  pnlControl.DoubleBuffered := true;

  aMoveDown.ShortCut := ShortCut(VK_DOWN, [ssAlt]);
  aMoveUp.ShortCut := ShortCut(VK_UP, [ssAlt]);
  aStop.ShortCut := ShortCut(Ord('.') or $90, []);
  aScreenShot.ShortCut := ShortCut(VK_SNAPSHOT, []);
  EnableNumpadShortcuts;

  subtitle_viewer := TSubtitlesRenderer.Create(pnlMain.Handle);
  subtitle_viewer.set_cursor(IDC_SIZENS);
  subtitle_viewer.set_adjust_pos(config.AdjustTextPos);
  subtitle_viewer.set_fixed_rows(config.SubtitleRows);
  subtitle_viewer.set_h_margin(config.EdgeSpace);
  subtitle_viewer.set_v_margin(config.EdgeSpace);
  subtitle_viewer.set_use_overlay(config.SubtitlesAttr.Overlay);
  subtitle_viewer.set_max_sub_options(config.MaxSubWidthActive, config.MaxSubWidthPercent);
  subtitle_viewer.set_max_sub_width(config.MaxSubWidth);
  subtitle_viewer.begin_update := subtitle_viewerBeginUpdate;
  subtitle_viewer.end_update := subtitle_viewerEndUpdate;
  subtitle_viewer.set_attributes(
    config.SubtitlesAttr.Style,
    config.SubtitlesAttr.RenderMode,
    config.SubtitlesAttr.AntiAliasing);

  osd_viewer := TOSDRenderer.Create(pnlMain.Handle);
  osd_viewer.set_cursor(IDC_SIZEALL);
  osd_viewer.set_display_time(config.OSDDisplayTime * 1000);
  osd_viewer.set_h_margin(config.osd_x_margin);
  osd_viewer.set_v_margin(config.osd_y_margin);
  osd_viewer.set_use_overlay(config.OSDAttr.Overlay);
  osd_viewer.set_max_sub_options(config.MaxSubWidthActive, config.MaxSubWidthPercent);
  osd_viewer.set_max_sub_width(config.MaxSubWidth);
  osd_viewer.end_update := osd_viewerEndUpdate;
  osd_viewer.set_attributes(
    config.OSDAttr.Style,
    config.OSDAttr.RenderMode,
    config.OSDAttr.AntiAliasing);

  _speaker := TSpeakerEngine.create();
  if config.SpeakerEnabled then
    aSpeaker.Execute;

  VideoRectChanged;

  CreateBookmarkMenu;
  CreateLangMenu;

  with PlaylistBox do
  begin
    AutoPlay := config.Autoplay;
  end;

  vtbVolume.Position := config.AudioVolume;
  if config.Mute then
    aMute.Execute;

  MyCinema.CurrentAudioRenderer := config.AudioRenderer;

  CheckCommandLine();

// jeœli nast¹pi³o wy³¹czenie ramki g³ownego okna (parametr "pelny ekran")
// to VCL utworzy³ okna na nowo i zmienily sie uchwyty
  control_panel.setHandle(pnlControl.Handle);

  if config.PlaylistToLeft then
    aPlaylistToLeft.Execute;
  if config.Playlist then
    aPlaylist.Execute;
  if config.Shuffle then
    aShuffle.Execute;
  if config.RepeatList then
    aRepeat.Execute;
  if config.ViewStandard and (not ParamMinView) then
    aViewStandard.Execute
  else
    aViewMinimal.Execute;
  if config.ReverseTime then
    aTimeReverse.Execute;

  if config.RememberSuspendState then
    aShutDown.Checked := config.SuspendState;

  aSetAspectRatio.Tag := integer(config.AspectRatio);
  aSetAspectRatio.Execute;

  CreateRemoteController;
  Application.OnActivate := AppActivate;
  Application.OnDeactivate := AppDeactivate;
//  WidthTimeText := lbPlaylist.Canvas.TextWidth('0:00:00') + 2;
  MyCinemaResize(MyCinema);
  Left := (Screen.Width - Width) div 2;
  Top := (Screen.Height - Height) div 2;
  if (MyCinema.FileName = '') and (config.LastMediaTime > 0) and
     (config.Files[1].Movie <> '') and (FileExists(config.Files[1].Movie)) then
    aPlay.Enabled := true;
end;

procedure TfrmCinemaPlayer.FormDestroy(Sender: TObject);
begin
  freeSubMenus(miRecentFiles, 2);
  DestroyRemoteController;
  subtitle_viewer.Free;
  subtitle_viewer := nil;
  osd_viewer.Free;
  osd_viewer := nil;
  control_panel.Free;
  control_panel := nil;
  frame_manager.Free;
  _speaker.Free;
  SystemParametersInfo(SPI_SETSCREENSAVEACTIVE, cardinal(SSaverActive), nil, 0);
  SystemParametersInfo(SPI_SETPOWEROFFACTIVE, PowerOffActive, nil, 0);
  PlaylistBox.DeleteItems(ditAll);
end;

procedure TfrmCinemaPlayer.aFixedFullScreenExecute(Sender: TObject);
begin
  with ChangeResolution do
  begin
    FullScreen := not FullScreen;
    aFixedFullScreen.Checked := FullScreen;
    aFullScreen.Enabled := not FullScreen;
    if FullScreen then
      ResChanged := true;
    ToggleFullScreen;
  end;
end;

function TfrmCinemaPlayer.FindResolution: DEVMODE;
var
  counter: integer;
begin
  counter := 0;
  while EnumDisplaySettings(nil, counter, Result) do
    if (Result.dmPelsWidth = cardinal(config.Res.Width)) and
       (Result.dmPelsHeight = cardinal(config.Res.Height)) and
       ((Result.dmDisplayFrequency = cardinal(config.Res.VRefresh)) or
        (cardinal(config.Res.VRefresh) = 0)) and
       (Result.dmBitsPerPel = cardinal(config.Res.Depth)) then
      break
    else
      inc(counter);
end;

procedure TfrmCinemaPlayer.aMuteExecute(Sender: TObject);
begin
  aMute.Checked := not aMute.Checked;
//  sbVolume.Down := aMute.Checked;
  MyCinema.Mute := aMute.Checked;
  config.Mute := aMute.Checked;
  if aMute.Checked then
    aMute.ImageIndex := iconMute
  else
    aMute.ImageIndex := iconVolume;
end;

procedure TfrmCinemaPlayer.vtbVolumeChange(Sender: TObject);
begin
  MyCinema.Volume := ArrayVolume[vtbVolume.Position];
  config.AudioVolume := vtbVolume.Position;
//  osdPanel.DisplayOSD(Format('%s - %d%%', [LangStor[LNG_VOLUMEMENU], round(100 * vtbVolume.Position / vtbVolume.Max)]));
  osd_viewer.render(Format('%s - %d%%', [LangStor[LNG_VOLUMEMENU], round(100 * vtbVolume.Position / vtbVolume.Max)]));
end;

procedure TfrmCinemaPlayer.OpenNewMovie(FileName: string; Position: double);

  function FindOnCDROM(var FName: string): boolean;
  var
    Drive: char;
    Temp: string;
  begin
    Temp := FName;
    for Drive := 'C' to 'Z' do
    begin
      Temp[1] := Drive;
      Result := FileExists(Temp);
      if Result then
      begin
        FName := Temp;
        exit;
      end;
    end;
  end;

begin
  if not FileExists(FileName) then
  begin
    if GetDriveType(PChar(ExtractFileDrive(FileName))) = DRIVE_CDROM then
    begin
      while true do
        if FindOnCDROM(FileName) then
          break
        else
          if not InsertCD then
            exit;
    end
    else
    begin
      DisplayError(LangStor[LNG_MSG_FILENOTEXISTS]);
      exit;
    end;
  end;

  Screen.Cursor := crAppStart;
  MyCinema.Stop;
  Application.ProcessMessages;
  ChangeResolution.InChange := false;
  GotoFSAfterOpen := config.AutoFullScreen <> afsNone;
  MyCinema.Open(FileName, Position);
  Application.ProcessMessages;
  Screen.Cursor := crDefault;
end;

procedure TfrmCinemaPlayer.aVolumeUpExecute(Sender: TObject);
begin
  vtbVolume.Position := vtbVolume.Position + 3;
end;

procedure TfrmCinemaPlayer.aVolumeDownExecute(Sender: TObject);
begin
  vtbVolume.Position := vtbVolume.Position - 3;
end;

procedure TfrmCinemaPlayer.aRetToWinExecute(Sender: TObject);
begin
  if ChangeResolution.FullScreen then
  begin
    if aFixedFullScreen.Enabled then
      aFixedFullScreen.Execute
    else
      aFullScreen.Execute;
  end;
end;

procedure TfrmCinemaPlayer.aOptionsExecute(Sender: TObject);
var
  tempPause: boolean;
  opt_result: DWORD;
  i: integer;
begin
  MyShowCursor(true);
  tempPause := config.PauseOnControl;
  if tempPause then
  begin
    OldPlayState := MyCinema.PlayState = cpPlaying;
    if OldPlayState then
      MyCinema.Pause;
  end;
  if audio_renderers_list = ''then
    for i := 0 to MyCinema.AudioRenderersCount - 1 do
    begin
      if audio_renderers_list <> '' then
        audio_renderers_list := audio_renderers_list + #13;
      audio_renderers_list := audio_renderers_list + MyCinema.AudioRenderers[i].name;
    end;
  _old_fps := config.DefaultFPS;
  opt_result := doSettings(Handle, apply_options);
  if tempPause and OldPlayState then
  begin
    MyCinema.Play;
    OldPlayState := false;
  end;

  GetFilesFilters;

  if opt_result = IDOK then
  begin
//TODO jesli rozmiar okna by³ "custom", to jest on teraz przycinany do rozmiaru filmu
    apply_options();
  end;
  PlaylistBox.AutoPlay := config.Autoplay;
  PlaylistBox.MovieFolder := config.MovieFolder;
end;

procedure TfrmCinemaPlayer.aHideTextExecute(Sender: TObject);
var
  W, H: integer;
begin
  aHideText.Checked := not aHideText.Checked;

  if not (ChangeResolution.FullScreen or (WindowState = wsMaximized)) then
  begin
    if MyCinema.FileName = '' then
    begin
      W := MyCinema.Width;
      if (config.SubtitlesAttr.RenderMode = rmFullRect) and aHideText.Checked then
        H := MyCinema.Height + subtitle_viewer.get_height
      else
        H := MyCinema.Height;
    end
    else
    begin
      W := MyCinema.VideoWidth;
      H := MyCinema.VideoHeight;
    end;

    ChangeSize(W, H);
  end;

  if aHideText.Checked then
  begin
    aHideText.ImageIndex := iconHideSubtitles;
    subtitle_viewer.disable;
  end
  else
  begin
    aHideText.ImageIndex := iconShowSubtitles;
    if not (config.SpeakerEnabled and config.SpeakerHideSubtitles) then
      subtitle_viewer.enable;
  end;
end;

procedure TfrmCinemaPlayer.a50Execute(Sender: TObject);
begin
  frame_manager.set_display_size(cpHalfSize);
  ResetVideoSize;
end;

procedure TfrmCinemaPlayer.a100Execute(Sender: TObject);
begin
  frame_manager.set_display_size(cpNormalSize);
  ResetVideoSize;
end;

procedure TfrmCinemaPlayer.a200Execute(Sender: TObject);
begin
  frame_manager.set_display_size(cpDoubleSize);
  ResetVideoSize;
end;

procedure TfrmCinemaPlayer.ChangeSize(const Width, Height: integer);
var
  tempRect: TRect;
begin
  if ChangeResolution.FullScreen then
    aRetToWin.Execute;
  if WindowState = wsMaximized then
    WindowState := wsNormal;
  tempRect := Rect(Left, Top, Left + Self.Width - ClientWidth + Width,
    Top + Self.Height - ClientHeight + Height + control_panel.getHeight);
  SafeResize(tempRect, 0, 0);
end;

procedure TfrmCinemaPlayer.PopupMenuPopup(Sender: TObject);
var
  i: integer;
begin
  aRetToWin.Enabled := ChangeResolution.FullScreen;
  PopupMenuVisible := true;
  SetParentMenu(PopupMenu, miPlayPrev, 3);
  SetParentMenu(PopupMenu, miPlayPause, 4);
  SetParentMenu(PopupMenu, miStop, 5);
  SetParentMenu(PopupMenu, miPlayNext, 6);
  SetParentMenu(PopupMenu, N4, 7);
  SetParentMenu(PopupMenu, miLargeBack, 8);
  SetParentMenu(PopupMenu, miBack, 9);
  SetParentMenu(PopupMenu, miStep, 10);
  SetParentMenu(PopupMenu, miLargeStep, 11);
  SetParentMenu(PopupMenu, N5, 12);
  SetParentMenu(PopupMenu, miZoom, 13);
  SetParentMenu(PopupMenu, miAspectRatio, 14);
  SetParentMenu(PopupMenu, miSpeed, 15);
  SetParentMenu(PopupMenu, miVolume, 16);
  SetParentMenu(PopupMenu, miAudioStreams, 17);
  for i := pmAudioStreams.Items.Count - 1 downto 0 do
    SetParentMenu(miAudioStreams, pmAudioStreams.Items[i], 0);
  SetParentMenu(PopupMenu, N11, 18);
  SetParentMenu(PopupMenu, miHideText, 19);
  SetParentMenu(PopupMenu, miSubTimeSetts, 20);
  SetParentMenu(PopupMenu, miStayOnTop, 21);
  SetParentMenu(PopupMenu, N15, 22);
  SetParentMenu(PopupMenu, miRecentFiles, 23);
  SetParentMenu(PopupMenu, miSetBookmarks, 24);
  SetParentMenu(PopupMenu, miGotoBookmarks, 25);
  SetParentMenu(PopupMenu, N3, 26);
  SetParentMenu(PopupMenu, miCodecsProps, 27);
  SetParentMenu(PopupMenu, miOptions, 28);
  SetParentMenu(PopupMenu, N18, 29);
  SetParentMenu(PopupMenu, miShutDown, 30);
  SetParentMenu(PopupMenu, miExit, 31);

  BuildFilterlistMenu;
end;

procedure TfrmCinemaPlayer.aStayOnTopExecute(Sender: TObject);
begin
  aStayOnTop.Checked := not aStayOnTop.Checked;
  config.StayOnTop := aStayOnTop.Checked;
  if aStayOnTop.Checked then
  begin
    SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
//    if Assigned(frmEditor) then
//      with frmEditor do
//        SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
  end
  else
  begin
    SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
//    if Assigned(frmEditor) then
//      with frmEditor do
//        SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
  end
end;

procedure TfrmCinemaPlayer.ReRenderSubtitle;
begin
  SetNewFontSize(MyCinema.Width, MyCinema.Height);
  subtitle_viewer.refresh;
  osd_viewer.refresh;
end;

procedure TfrmCinemaPlayer.RebuildRecent(const NewFile: string);
var
  i, Hit: integer;
  tempHF: PHistoryFile;
  NoText: boolean;
begin
  Hit := -1;
  if NewFile <> '' then
  begin
    tempHF := nil;
    for i := 1 to RecentCount do
      if config.Files[i].Movie = NewFile then
      begin
        tempHF := config.Files[i];
        Hit := i;
        break;
      end;

    if tempHF = nil then
    begin
      Hit := RecentCount;
      tempHF := config.Files[Hit];
      tempHF.Movie := NewFile;
      tempHF.Text := '';
    end;

    for i := Hit downto 2 do
      config.Files[i] := config.Files[i - 1];
    config.Files[1] := tempHF;

    if (tempHF.Text = '') then
      NoText := true
    else
      if (tempHF.Text[1] = '\') then
        NoText := false
      else
        NoText := not FileExists(tempHF.Text);

    if NoText and config.LoadSubtitles then
    begin
      if not findSubtitles(tempHF.Movie, tempHF.Text) and
        (config.SubtitlesFolder <> '') then
        findSubtitles(NormalizeDir(config.SubtitlesFolder) + ExtractFileName(tempHF.Movie), tempHF.Text);
    end;
  end;

  freeSubMenus(miRecentFiles, 2);
  miRecentFiles.Enabled := false;

  for i := RecentCount downto 1 do
  begin
    if config.Files[i].Movie <> '' then
    begin
      AddMenuItem(miRecentFiles,
        '&' + IntToStr(i mod 10) + '. ' + ExtractFileName(config.Files[i].Movie),
        miRecentClick, 0, true, true).Tag := i;
      miRecentFiles.Enabled := true;
      aClearRecent.Enabled := true;
    end;
  end;
end;

procedure TfrmCinemaPlayer.miRecentClick(Sender: TObject);
begin
  with PlaylistBox do
  begin
    aDelAll.Execute;
    AddPlayItem(config.Files[(Sender as TMenuItem).Tag].Movie);
//    RefreshCount;
    PlaylistBox.ChargeItem(0, config.Autoplay);
  end;
end;

procedure TfrmCinemaPlayer.aTimeReverseExecute(Sender: TObject);
begin
  aTimeReverse.Checked := not aTimeReverse.Checked;
  config.ReverseTime := aTimeReverse.Checked;
end;

procedure TfrmCinemaPlayer.aStatisticsExecute(Sender: TObject);
begin
  MyCinema.ShowStatistic;
end;

procedure TfrmCinemaPlayer.WMTimer(var Msg: TWMTimer);
var
  CurrentPos: double;
  CurrentTick: cardinal;
  VisibleLineNo: integer;
  Fname: string;
  currSubtitle: string;
//  col: COLORREF;
begin
  if Msg.TimerID = timerMouseOnCinema then
  begin
    IgnoreMouseOnCinema := false;
    KillTimer(Handle, timerMouseOnCinema);
    exit;
  end;

  if Msg.TimerID = timerClearSubtitle then
  begin
    KillTimer(Handle, timerClearSubtitle);
    SampleSubVisibled := false;
    if (subtitle_viewer.get_text = LangStor[LNG_OPT_SAMPLETEXT]) and
       (MyCinema.FileName = '') then
//    if SubtitleRenderer.Caption = LangStor.OptionsWindow.SbtPage.SampleText then
      subtitle_viewer.clear;
    exit;
  end;

  if Msg.TimerID = timerShowEditor then
  begin
    KillTimer(Handle, timerShowEditor);
    aSubEditor.Execute;
    Beep;
    frmEditor.aNextError.Execute;
    exit;
  end;

  if Msg.TimerID = timerRefreshVideoRect then
  begin
    KillTimer(Handle, timerRefreshVideoRect);
    VideoRectChanged;
    exit;
  end;

  if Msg.TimerID = timerGetOverlayColor then
  begin
    is_overlay_color := MyCinema.GetOverlayColorKey(overlay_color);
    subtitle_viewer.set_overlay_colorkey(overlay_color, is_overlay_color);
    osd_viewer.set_overlay_colorkey(overlay_color, is_overlay_color);
    KillTimer(Handle, timerGetOverlayColor);
    exit;
  end;

  CurrentPos := MyCinema.CurrentPosition;
  CurrentTick := GetTickCount;

  if not (Subtitles.Loading or (aHideText.Checked and not config.SpeakerEnabled)) then
  begin
    VisibleLineNo := Subtitles.FindCurrentText(CurrentPos);
    if VisibleLineNo = -1 then
    begin
      if not (aHideText.Checked or (config.SpeakerEnabled and config.SpeakerHideSubtitles)) then
        if SampleSubVisibled then
          subtitle_viewer.render(LangStor[LNG_OPT_SAMPLETEXT])
        else
          subtitle_viewer.clear;
    end
    else
    begin
//      SetNewFontSize(MyCinema.Width, MyCinema.Height);
      currSubtitle := Subtitles.GetSubtitle(VisibleLineNo);
      if not (aHideText.Checked or (config.SpeakerEnabled and config.SpeakerHideSubtitles)) then
      begin
        subtitle_viewer.render(currSubtitle);
      end;
      if config.SpeakerEnabled then
      begin
        if (VisibleLineNo = 0) then
        begin
          currSubtitle := AnsiLowerCase(currSubtitle);
          if (Pos('fps', currSubtitle) > 0) or
             (Pos('subedit', currSubtitle) > 0) or
             (Pos('http', currSubtitle) > 0) or
             (Pos('info', currSubtitle) > 0) or
             (Pos(LowerCase(LangStor[LNG_OPT_SUBTITLESNAME]), currSubtitle) > 0) or
             (Pos('movie', currSubtitle) > 0) then
            currSubtitle := '';
        end;

        _speaker.speak(TSubtitles.stripTagsFromSubtitle(PChar(currSubtitle)));
      end;
    end;

    if Assigned(frmEditor) and frmEditor.Visible then
      frmEditor.FollowMovie(VisibleLineNo);
  end;

  config.LastMediaTime := CurrentPos;

  if not (MyCinema.PlayState = cpPaused) then
  begin
    ptbPosition.SilentPosition := round(CurrentPos * 10);
  end;

  if (CurrentTick - PrevTick) >= 500 then
  begin
    control_panel.setStatus(FormatFloat('0.00', MyCinema.CurrentFPS), cpsRate);
    if RateStr <> '' then
      control_panel.setStatus(control_panel.getStatus(cpsRate) + '/' + RateStr, cpsRate); // + '/' + FormatFloat('0.00', MyCinema.FPS) + ' fps';
    PrevTick := CurrentTick;
  end;

  if aTimeReverse.Checked then
    control_panel.setStatus(PrepareTime(MyCinema.Duration - CurrentPos, false), cpsCurrTime)
  else
    control_panel.setStatus(PrepareTime(CurrentPos, false), cpsCurrTime);

  if ((CurrentTick - ShowCurrentTime) > (config.OSDCurrentTime * 60000)) and
     config.OSDCurrentTimeEnabled then
  begin
    if (MyCinema.PlayState = cpPlaying) or (MyCinema.PlayState = cpPaused) then
      aCurrentTimeOnOSD.Execute;
    ShowCurrentTime := CurrentTick;
  end;

  if ((GetTickCount - IdleMouseTime) >= config.TurnOffCur) and Focused and
     ChangeResolution.FullScreen and (not PopupMenuVisible) and (not PlaylistBox.Visible) and
     (not control_panel.isVisibled) and (not settings_visibled) and (not isAnyCommonDialogActive()) then
  begin
    GetCursorPos(Punkt);
    MyShowCursor(false);
  end;

  if (not change_pos_in_progress) and (not OnlyChangePlayedItem) and ((MyCinema.Duration - CurrentPos) < 0.1) then
  begin
    OnlyChangePlayedItem := true;
    Fname := MyCinema.FileName;
    if config.SearchNextMoviePart and FindNextPart(Fname) then
    begin
      if (PlaylistBox.Items.IndexOf(ExtractFileName(Fname)) = -1) then
        PlaylistBox.AddPlayItem(Fname);
      PlaylistBox.ChargeItem(PlaylistBox.Items.IndexOf(ExtractFileName(Fname)), true);
    end
    else
      PlaylistBox.PlayNextItem;
    OnlyChangePlayedItem := false;
  end;

//  if GetFocus <> Self.Handle then
//    osdPanel.DisplayOSD('brak focusa');
//  if MyCinema.GetOverlayColorKey(col) then
//  PlaylistBox.Color := col;
end;

procedure TfrmCinemaPlayer.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  nShift: integer;
  mwm: TMouseWheelMode;
begin
  if config.ReverseWheel then
    nShift := WheelDelta
  else
    nShift := -WheelDelta;

  nShift := nShift div 120;

  Handled := true;

  case config.MouseWheelMode of
    mwmVolume:
    begin
      if PtInRect(ptbPosition.BoundsRect, pnlControl.ScreenToClient(MousePos)) then
        mwm := mwmMediaPosition
      else
        mwm := mwmVolume;
    end;
    mwmMediaPosition:
    begin
      if PtInRect(vtbVolume.BoundsRect, pnlControl.ScreenToClient(MousePos)) then
        mwm := mwmVolume
      else
        mwm := mwmMediaPosition;
    end;
    mwmSubtitles:
    begin
      if PtInRect(ptbPosition.BoundsRect, pnlControl.ScreenToClient(MousePos)) then
        mwm := mwmMediaPosition
      else
        if PtInRect(vtbVolume.BoundsRect, pnlControl.ScreenToClient(MousePos)) then
          mwm := mwmVolume
        else
          mwm := mwmSubtitles;
    end;
    else
      mwm := config.MouseWheelMode;
  end;

  case mwm of
    mwmVolume:
      vtbVolume.Position := vtbVolume.Position + nShift;
    mwmMediaPosition:
      ptbPosition.Position := ptbPosition.Position + config.LineSize * 10 * nShift;
    mwmSubtitles:
    begin
      if nShift < 0 then
        aSubtitleTimeForward.Execute
      else
        aSubtitleTimeBack.Execute;
    end;
  end;
end;

procedure TfrmCinemaPlayer.ReloadLang;
var
  i: integer;
  fls, pls, assoc: TStringList;
begin
  ReloadLangCalcTimeConfig;

  ModifyMenu(MainMenu.Handle, 0, MF_BYPOSITION or MF_POPUP, miFile.Handle, PChar(LangStor[LNG_FILEMENU]));
  aOpenFiles.Caption := LangStor[LNG_OPENMOVIE];
  aReload.Caption := LangStor[LNG_RELOADMOVIE];
  if Pos(#13, aOpenFiles.Hint) = 0 then
    aOpenFiles.Hint := LangStor[LNG_OPENMOVIE]
  else
    aOpenFiles.Hint := LangStor[LNG_OPENMOVIE] + Copy(aOpenFiles.Hint, Pos(#13, aOpenFiles.Hint), MaxInt);
//  tbOpenMovie.Caption := LangStor[LNG_OPENMOVIE];
  tbOpenMovie.Hint := aOpenFiles.Hint;
  aOpenText.Caption := LangStor[LNG_OPENSUBTITLES];
  aOpenText.Hint := LangStor[LNG_OPENSUBTITLES];
  aOpenDir.Caption := LangStor[LNG_OPENDIRECTORY];
  aAddFiles.Caption := LangStor[LNG_ADDMOVIE];
  aAddDir.Caption := LangStor[LNG_ADDDIRECTORY];
  aOpenList.Caption := LangStor[LNG_OPENPLAYLIST];
  aSaveList.Caption := LangStor[LNG_SAVEPLAYLIST];
  miRecentFiles.Caption := LangStor[LNG_RECENTFILES];
  aClearBookmark.Caption := LangStor[LNG_CLEARRECENT];
  aClearRecent.Caption := LangStor[LNG_CLEARRECENT];
  aPlaylist.Caption := LangStor[LNG_PLAYLIST];
  aPlaylist.Hint := LangStor[LNG_PLAYLIST];
  aPlaylistToLeft.Caption := LangStor[LNG_PLAYLISTONLEFT];
  aSubEditor.Caption := LangStor[LNG_SUBTITLESEDITOR];
  aSubEditor.Hint := LangStor[LNG_SUBTITLESEDITOR];
  miGotoBookmarks.Caption := LangStor[LNG_GOTOBOOKMARK];
  miSetBookmarks.Caption := LangStor[LNG_SETBOOKMARK];
  RebuildBookmarks;
  aEnableScreenShot.Caption := LangStor[LNG_ENABLESCREENSHOT];
  aScreenShot.Caption := LangStor[LNG_SCREENSHOT] + ' (beta)';
  aOptions.Caption := LangStor[LNG_OPTIONS];
  aOptions.Hint := LangStor[LNG_OPTIONS];
  miLangs.Caption := LangStor[LNG_LANGUAGES];
  miCodecsProps.Caption := LangStor[LNG_FILTERSUSED];
  miProperties.Caption := LangStor[LNG_PROPERTIES];
  aExit.Caption := LangStor[LNG_EXIT];
  aExit.Hint := LangStor[LNG_EXIT];
  ModifyMenu(MainMenu.Handle, 1, MF_BYPOSITION or MF_POPUP, miView.Handle, PChar(LangStor[LNG_VIEWMENU]));
  aViewStandard.Caption := LangStor[LNG_VIEWSTANDARD];
  aViewStandard.Hint := LangStor[LNG_VIEWSTANDARD];
  aViewMinimal.Caption := LangStor[LNG_VIEWMINIMAL];
  aViewMinimal.Hint := LangStor[LNG_VIEWMINIMAL];
  aFullScreen.Caption := LangStor[LNG_FULLSCREEN];
  aFullScreen.Hint := LangStor[LNG_FULLSCREEN];
  aFixedFullScreen.Caption := LangStor[LNG_FIXEDFULLSCREEN];
  aFixedFullScreen.Hint := LangStor[LNG_FIXEDFULLSCREEN];
  miZoom.Caption := LangStor[LNG_ZOOMMENU];
  miAspectRatio.Caption := LangStor[LNG_ASPECTRATIO];
  miAROryginal.Caption := LangStor[LNG_ASPECTRATIOORIGINAL];
  miARFree.Caption := LangStor[LNG_ASPECTRATIOFREE];
  miAROther.Caption := LangStor[LNG_ASPECTRATIOOTHER];
  aTimeReverse.Caption := LangStor[LNG_TIMEREMAINING];
  aHideText.Caption := LangStor[LNG_HIDESUBTITLES];
  aSubTimeSetts.Caption := LangStor[LNG_SAS_WINDOWCAPTION];
  aHideText.Hint := LangStor[LNG_HIDESUBTITLES];
  aStayOnTop.Caption := LangStor[LNG_STAYONTOP];
  aStayOnTop.Hint := LangStor[LNG_STAYONTOP];
  aStatistics.Caption := LangStor[LNG_STATISTICS];
  aMinimize.Caption := LangStor[LNG_MINIMIZE];
  aRetToWin.Caption := LangStor[LNG_RETURNTOWINDOW];
  aShutDown.Caption := LangStor[LNG_SHUTDOWN];
  ModifyMenu(MainMenu.Handle, 2, MF_BYPOSITION or MF_POPUP, miPlay.Handle, PChar(LangStor[LNG_PLAYMENU]));
  aPlay.Caption := LangStor[LNG_PLAY];
  aPlay.Hint := LangStor[LNG_PLAY];
  aPause.Caption := LangStor[LNG_PAUSE];
  aPause.Hint := LangStor[LNG_PAUSE];
  aStop.Caption := LangStor[LNG_STOP];
  aStop.Hint := LangStor[LNG_STOP];
  aPlayPrev.Caption := LangStor[LNG_PLAYPREV];
  aPlayPrev.Hint := LangStor[LNG_PLAYPREV];
  aPlayNext.Caption := LangStor[LNG_PLAYNEXT];
  aPlayNext.Hint := LangStor[LNG_PLAYNEXT];
  aLargeBack.Caption := LangStor[LNG_LARGEBACK];
  aLargeBack.Hint := LangStor[LNG_LARGEBACK];
  aBack.Caption := LangStor[LNG_BACK];
  aBack.Hint := LangStor[LNG_BACK];
  aStep.Caption := LangStor[LNG_STEP];
  aStep.Hint := LangStor[LNG_STEP];
  aLargeStep.Caption := LangStor[LNG_LARGESTEP];
  aLargeStep.Hint := LangStor[LNG_LARGESTEP];
  aPlaySlower.Caption := LangStor[LNG_PLAYSLOWER];
  aPlaySlower.Hint := LangStor[LNG_PLAYSLOWER];
  aPlayNormal.Caption := LangStor[LNG_PLAYNORMAL];
  aPlayNormal.Hint := LangStor[LNG_PLAYNORMAL];
  aPlayFaster.Caption := LangStor[LNG_PLAYFASTER];
  aPlayFaster.Hint := LangStor[LNG_PLAYFASTER];
  miVolume.Caption := LangStor[LNG_VOLUMEMENU];
  miSpeed.Caption := LangStor[LNG_SPEEDMENU];
  aVolumeUp.Caption := LangStor[LNG_VOLUMEUP];
  aVolumeDown.Caption := LangStor[LNG_VOLUMEDOWN];
  aMute.Caption := LangStor[LNG_VOLUMEMUTE];
  aMute.Hint := LangStor[LNG_VOLUMEMUTE];
  aSpeaker.Caption := LangStor[LNG_OPT_SPEAKERNAME];
  miAudioStreams.Caption := LangStor[LNG_AUDIOSTREAMS];
  for i := 0 to miAudioStreams.Count - 1 do
    if MyCinema.AudioStreams[i].name = '' then
      miAudioStreams[i].Caption := Format(LangStor[LNG_AUDIO] + ' %d', [i + 1]);
  for i := 0 to pmAudioStreams.Items.Count - 1 do
    if MyCinema.AudioStreams[i].name = '' then
      pmAudioStreams.Items[i].Caption := Format(LangStor[LNG_AUDIO] + ' %d', [i + 1]);
  aShuffle.Caption := LangStor[LNG_PLAYLISTSHUFFLE];
  aRepeat.Caption := LangStor[LNG_PLAYLISTREPEAT];
  ModifyMenu(MainMenu.Handle, 3, MF_BYPOSITION or MF_POPUP or MF_HELP, miHelp.Handle, PChar(LangStor[LNG_HELPMENU]));
  DrawMenuBar(Handle);
  aShortcuts.Caption := LangStor[LNG_SHORTCUTS];
  aDonate.Caption := LangStor[LNG_DONATION];
  aAbout.Caption := LangStor[LNG_ABOUT];
  miHomepage.Caption := LangStor[LNG_HOMEPAGE];
  miForum.Caption := LangStor[LNG_FORUMPAGE];
  aSelInvert.Caption := LangStor[LNG_PLAYLISTINVERTSELECT];
  aSelNone.Caption := LangStor[LNG_PLAYLISTSELECTNONE];
  aSelAll.Caption := LangStor[LNG_PLAYLISTSELECTALL];
  aDelSel.Caption := LangStor[LNG_PLAYLISTDELETESELECTED];
  aDelCrop.Caption := LangStor[LNG_PLAYLISTCROP];
  aDelDeath.Caption := LangStor[LNG_PLAYLISTDELETEDEATH];
  aDelAll.Caption := LangStor[LNG_PLAYLISTDELETEALL];
  aMoveUp.Caption := LangStor[LNG_PLAYLISTMOVEUP];
  aMoveDown.Caption := LangStor[LNG_PLAYLISTMOVEDOWN];
  aSort.Caption := LangStor[LNG_PLAYLISTSORT];
  if MyCinema.FileName <> '' then
  begin
    case MyCinema.PlayState of
      cpPlaying:
        control_panel.setStatus(LangStor[LNG_STATUS_PLAYING], cpsPlayerState);
      cpStopped:
        control_panel.setStatus(LangStor[LNG_STATUS_STOPPED], cpsPlayerState);
      cpPaused:
        control_panel.setStatus(LangStor[LNG_STATUS_PAUSED], cpsPlayerState);
    end;
    SetStatus;
  end;

  PlaylistBox.BadPlaylist := LangStor[LNG_MSG_BADPLAYLIST];
  PlaylistBox.ErrorCaption := LangStor[LNG_MSG_ERROR];
  PlaylistBox.SelFold := LangStor[LNG_DIALOG_SELECTFOLDER];
  PlaylistBox.PressCTRL := LangStor[LNG_DIALOG_PRESSCTRL];

  if Visible and (GetDriveType(PChar(ExtractFileDrive(Application.ExeName))) <> DRIVE_CDROM) then
  begin
    fls := TStringList.Create;
    pls := TStringList.Create;
    assoc := TStringList.Create;
    try
      fls.Text := config.Supported;
      pls.Text := config.SupportedPLS;
      assoc.Text := config.Associated;
      newRegisterFiles(fls, pls, assoc, true);
    finally
      fls.Free;
      pls.Free;
      assoc.Free;
    end;
  end;

  GetFilesFilters;
end;

procedure TfrmCinemaPlayer.miLanguageClick(Sender: TObject);
begin
  if not languages_list.selectLang((Sender as TMenuItem).Tag, false) then
  begin
    Beep();
    exit;
  end;
  (Sender as TMenuItem).Checked := true;
  ReloadLang;
  if Assigned(frmEditor) then
    if frmEditor.Visible then frmEditor.ReloadLang;
end;

procedure TfrmCinemaPlayer.CreateLangMenu;
var
  i: integer;
  mi: TMenuItem;
begin
  for i := 0 to languages_list.count - 1 do
  begin
    mi := TMenuItem.Create(Self);
    mi.Caption := languages_list[i].name;
    mi.Tag := languages_list[i].lang;
    if mi.Tag = languages_list.selected_lang then
    begin
      mi.Checked := true;
      ReloadLang;
    end;
    mi.OnClick := miLanguageClick;
    mi.RadioItem := true;
    miLangs.Add(mi);
  end;
end;

procedure TfrmCinemaPlayer.GetFilesFilters;
var
  tempList: TStringList;
  i: integer;

  function GetFileDialogFilter(NewExts: string): string;
  var
    i: integer;
  begin
    if NewExts <> '' then
      Result := '*.';
    for i := 1 to Length(NewExts) do
    begin
      if NewExts[i] = #13 then
      begin
        if i < (Length(NewExts) - 1) then
          Result := Result + ';*.';
      end
      else
        if NewExts[i] <> #10 then
          Result := Result + NewExts[i];
    end;
  end;

begin
  tempList := TStringList.Create;
  try
    PlaylistBox.MovieExt := '';
    PlaylistBox.PlayListExt := '';
    tempList.Text := config.Supported;
    for i := 0 to tempList.Count - 1 do
      if tempList[i] <> '' then
      begin
        if PlaylistBox.MovieExt <> '' then
          PlaylistBox.MovieExt := PlaylistBox.MovieExt + #13;
        PlaylistBox.MovieExt := PlaylistBox.MovieExt + tempList[i];
      end;

    tempList.Text := config.SupportedPLS;
    for i := 0 to tempList.Count - 1 do
      if tempList[i] <> '' then
      begin
        if PlaylistBox.PlayListExt <> '' then
          PlaylistBox.PlayListExt := PlaylistBox.PlayListExt + #13;
        PlaylistBox.PlayListExt := PlaylistBox.PlayListExt + tempList[i];
      end;

    tempList.Text := config.Associated;
    for i := 0 to tempList.Count - 1 do
      if tempList[i] <> '' then
      begin
        if tempList[i][1] = '!' then
        begin
          if PlaylistBox.PlayListExt <> '' then
            PlaylistBox.PlayListExt := PlaylistBox.PlayListExt + #13;
          PlaylistBox.PlayListExt := PlaylistBox.PlayListExt + Copy(tempList[i], 2, MaxInt);
        end
        else
        begin
          if PlaylistBox.MovieExt <> '' then
            PlaylistBox.MovieExt := PlaylistBox.MovieExt + #13;
          PlaylistBox.MovieExt := PlaylistBox.MovieExt + tempList[i];
        end;
      end;

    PlaylistBox.MovieFilter := LangStor[lng_Dialog_Movies] + '|' + GetFileDialogFilter(PlaylistBox.MovieExt);
    PlaylistBox.MovieFolder := config.MovieFolder;
    PlaylistBox.SubtitleExt := DefSubtitleExt;
    PlaylistBox.SubtitleFilter := LangStor[lng_Dialog_Subtitles] + '|' + GetFileDialogFilter(PlaylistBox.SubtitleExt);
    PlaylistBox.PlayListFilter := LangStor[lng_Dialog_PlayLists] + '|' + GetFileDialogFilter(PlaylistBox.PlayListExt);
    PlaylistBox.AllFilter := LangStor[lng_Dialog_All] + ' (*.*)|*.*';
  finally
    tempList.Free;
  end;
end;

procedure TfrmCinemaPlayer.SetStatus;
begin
  if MyCinema.VideoSize.cx > 0 then
    control_panel.setStatus(IntToStr(MyCinema.VideoSize.cx) + 'x' + IntToStr(MyCinema.VideoSize.cy), cpsFormat)
  else
    control_panel.setStatus('', cpsFormat);
  if MyCinema.FPS > 1 then
    RateStr := FormatFloat('0.00', MyCinema.FPS) + ' fps'
  else
    RateStr := '';
  control_panel.setStatus(RateStr, cpsRate);
  //DeltaTimeChange(Subtitles);
end;

procedure TfrmCinemaPlayer.subtitle_viewerBeginUpdate;
begin
  TempPlayState := MyCinema.PlayState;
  if TempPlayState = cpPlaying then
    aPause.Execute;
end;

procedure TfrmCinemaPlayer.subtitle_viewerEndUpdate;
begin
  if TempPlayState = cpPlaying then
    aPlay.Execute;
  config.EdgeSpace := subtitle_viewer.get_v_margin;
end;

function TfrmCinemaPlayer.AddMenuItem(ParentMenu: TMenuItem; ItemName: string;
  ProcClick: TNotifyEvent; ItemShortCut: TShortCut; First, SetEnabled: boolean): TMenuItem;
begin
  Result := TMenuItem.Create(nil);
  with Result do
  begin
    Caption := ItemName;
    ShortCut := ItemShortCut;
    OnClick := ProcClick;
    Enabled := SetEnabled;
  end;
  if First then
    ParentMenu.Insert(0, Result)
  else
    ParentMenu.Add(Result);
end;

procedure TfrmCinemaPlayer.miCodecPropertyClick(Sender: TObject);
begin
  if not MyCinema.DisplayFilterProperties(Handle, TMenuItem(Sender).Caption) then
    DisplayError(LangStor[LNG_MSG_CANTDISPLAYWINDOW]);
end;

procedure TfrmCinemaPlayer.ptbPositionNeedHint(Sender: TObject; ATime: integer);
var
  tempPoint: TPoint;
begin
  if ActiveModification then
  begin
    if Sender = ptbSpeed then
    begin
      if (Sender as TCustomTrackBar).Hint <> (IntToStr(ATime * 10) + '%') then
        (Sender as TCustomTrackBar).Hint := IntToStr(ATime * 10) + '%';
    end
    else
    begin
      if (Sender as TCustomTrackBar).Hint <> PrepareTime(ATime / 10, false) then
        (Sender as TCustomTrackBar).Hint := PrepareTime(ATime / 10, false);
    end;

    GetCursorPos(tempPoint);
    if OldX = MaxInt then
    begin
      OldX := tempPoint.x;
      OldY := tempPoint.y;
    end;
    HintWindowRef.SilentSetPosition(tempPoint.x - OldX, tempPoint.y - OldY,
      (Sender as TCustomTrackBar).Hint, ATime = (Sender as TCustomTrackBar).Position);
    OldX := tempPoint.x;
    OldY := tempPoint.y;
  end;
end;

procedure TfrmCinemaPlayer.vtbVolumeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    vtbVolume.Position := 17;
end;

procedure TfrmCinemaPlayer.WMGetMinMaxInfo(var Msg: TMessage);
begin
  with Msg, PMinMaxInfo(lParam)^.ptMinTrackSize do
  begin
    if config.ViewStandard then
      x := MinWindowWidth
    else
      x := MinWindowMiniWidth;
    y := MinWindowHeight;
    Result := 0;
  end;
  inherited;
end;

procedure TfrmCinemaPlayer.MyCinemaMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  MyRect: TRect;
  MousePoint, CinemaMousePoint: TPoint;
  DeltaX, DeltaY: integer;
begin
//TODO jak przesune film, a potem porusze oknem,
// to zle odczytuje kolor overlay dla napisow
  if IgnoreMouseOnCinema {or CinemaIsMoved} then
    exit;
  MyRect := MyCinema.GetVideoPos;
  GetCursorPos(MousePoint);
  CinemaMousePoint := MyCinema.ScreenToClient(MousePoint);

  if (config.PauseOnControl and (ssLeft in Shift)) and not OldPlayState then
  begin
    OldPlayState := MyCinema.PlayState = cpPlaying;
    if OldPlayState then
      MyCinema.Pause;
  end;

  if not (PopupMenuVisible or (ChangeResolution.FullScreen and config.DisableResizeFrame)) then
    with MyRect do
    begin
      if (ssLeft in Shift) and (MovieResizeBorder <> mrbNone) then
      begin
        TopLeft := MyCinema.ScreenToClient(TopLeft);
        BottomRight := MyCinema.ScreenToClient(BottomRight);

        DeltaX := MousePoint.x - MovieResizePoint.x;
        DeltaY := MousePoint.y - MovieResizePoint.y;
        if GetKeyState(VK_CONTROL) < 0 then
          case MovieResizeBorder of
            mrbLeft:
              InflateRect(MyRect, -DeltaX, 0);
            mrbTop:
              InflateRect(MyRect, 0, -DeltaY);
            mrbRight:
              InflateRect(MyRect, DeltaX, 0);
            mrbBottom:
              InflateRect(MyRect, 0, DeltaY);
            mrbInside:
              OffsetRect(MyRect, DeltaX, DeltaY);
          end
        else
          case MovieResizeBorder of
            mrbLeft:
              InflateRect(MyRect, -DeltaX,
                -round((MyCinema.VideoHeight - ((MyCinema.VideoWidth - 2 * DeltaX) / frame_manager.get_aspect_value)) / 2));
            mrbTop:
              InflateRect(MyRect, -round((MyCinema.VideoWidth -
                ((MyCinema.VideoHeight - 2 * DeltaY) * frame_manager.get_aspect_value)) / 2), -DeltaY);
            mrbRight:
              InflateRect(MyRect, DeltaX,
                -round((MyCinema.VideoHeight - ((MyCinema.VideoWidth + 2 * DeltaX) / frame_manager.get_aspect_value)) / 2));
            mrbBottom:
              InflateRect(MyRect, -round((MyCinema.VideoWidth -
                ((MyCinema.VideoHeight + 2 * DeltaY) * frame_manager.get_aspect_value)) / 2), DeltaY);
            mrbInside:
              OffsetRect(MyRect, 0, DeltaY);
          end;
        if ((Right - Left) < 100) or ((Bottom - Top) < 100) then
          exit;
        MovieResizePoint := MousePoint;
        if GetKeyState(VK_CONTROL) < 0 then
          frame_manager.set_aspect_ratio(arCustom);
        frame_manager.change_video_pos(@MyRect, GetKeyState(VK_CONTROL) >= 0);
        VideoRectChanged;
      end
      else
      begin
        MyCinema.Cursor := crDefault;

        MovieResizeBorder := mrbNone;
        if abs(Left - MousePoint.x) < 10 then
        begin
          MyCinema.Cursor := crHSplit;
          MovieResizeBorder := mrbLeft;
        end
        else
          if abs(Right - MousePoint.x) < 10 then
          begin
            MyCinema.Cursor := crHSplit;
            MovieResizeBorder := mrbRight;
          end
          else
            if abs(Top - MousePoint.y) < 10 then
            begin
              MyCinema.Cursor := crVSplit;
              MovieResizeBorder := mrbTop;
            end
            else
              if abs(Bottom - MousePoint.y) < 10 then
              begin
                MyCinema.Cursor := crVSplit;
                MovieResizeBorder := mrbBottom;
              end
              else
              begin
                InflateRect(MyRect, -10, -10);
                if PtInRect(MyRect, MousePoint) then
                  MovieResizeBorder := mrbInside;
              end;
{        if ChangeResolution.FullScreen then
          if (MyCinemaMousePoint.x > ((MyCinema.Left + MyCinema.Width) -
                                   (PlaylistBox.Width * integer(PlaylistBox.Visible)) - 50)) and
             (not pControl.Visible) then
          begin
            if aPlaylist.Checked = false then
            begin
              MyShowCursor(true);
              aPlaylist.Execute;
            end;
          end
          else
          begin
            if aPlaylist.Checked = true then
              aPlaylist.Execute;
          end;}
      end;
    end;

  if ChangeResolution.FullScreen then
  begin
    if control_panel.isVisibled then
    begin
      if ((CinemaMousePoint.y < (MyCinema.Top + MyCinema.Height - 80)) and not config.PanelOnTop) or
         ((CinemaMousePoint.y > (MyCinema.Top + 80)) and config.PanelOnTop) then
        control_panel.setVisible(false);
    end
    else
      if ((CinemaMousePoint.y > (MyCinema.Top + MyCinema.Height - 80)) and not config.PanelOnTop) or
         ((CinemaMousePoint.y < (MyCinema.Top + 80)) and config.PanelOnTop) then
      begin
        MyShowCursor(true);
        control_panel.setVisible(true);
//TODO:        lCurrTime.Left := lCurrTime.Parent.Width - lCurrTime.Width - 58;
      end;
  end;

  if (abs(MousePoint.x - Punkt.x) > 3) or (abs(MousePoint.y - Punkt.y) > 3) then
  begin
    PopupMenuVisible := false;
    IdleMouseTime := GetTickCount;
    MyShowCursor(true);

    Punkt := MousePoint;
  end;
end;

procedure TfrmCinemaPlayer.MyCinemaMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if IgnoreMouseOnCinema or PopupMenuVisible then
    exit;

  if mbLeft = Button then
  begin
    if (GetTickCount() - dwLMBDownTime) <= GetDoubleClickTime() then
    begin
      MyCinemaDblClick(Sender);
      exit;
    end;
    SetCaptureControl(MyCinema);
{    if (config.PauseAfterClick) then
    begin
      GetCursorPos(mouseLButtonDownPoint);
//      mouseLButtonDownPoint.x := X;
//      mouseLButtonDownPoint.y := Y;
    end;  }
    GetCursorPos(MovieResizePoint);
    ptLMBDown := MovieResizePoint;
    dwLMBDownTime := GetTickCount();
  end;
{  if config.PauseOnControl or (mbLeft = Button) then
  begin
    OldPlayState := MyCinema.PlayState = cpPlaying;
    if OldPlayState then
      MyCinema.Pause;
  end;}
end;

procedure TfrmCinemaPlayer.MyShowCursor(const Show: boolean);
begin
  if MyCinema.IsCursorVisibled = Show then
    exit;
  ShowCursor(Show);
  MyCinema.ShowCursor(Show);
end;

procedure TfrmCinemaPlayer.MyCinemaMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  MousePoint: TPoint;
  rc: TRect;
begin
  if IgnoreMouseOnCinema then
    exit;

  case Button of
    mbLeft:
    begin
      if GetCaptureControl = MyCinema then
        SetCaptureControl(nil);
      if config.PauseAfterClick then
      begin
        GetCursorPos(MousePoint);
        if(abs(ptLMBDown.x - MousePoint.x) <= 3) and
          (abs(ptLMBDown.y - MousePoint.y) <= 3) then
        begin
          tbPlayPause.Action.Execute;
          bPauseAfterClick := true;
        end;
      end;
    end;
    mbRight:
    begin
      GetCursorPos(MousePoint);

      MyShowCursor(true);
      OldPlayState := (MyCinema.PlayState = cpPlaying) and config.PauseOnControl;
      if OldPlayState then
        MyCinema.Pause;

      PopupMenu.Popup(MousePoint.x, MousePoint.y);
      IgnoreMouseOnCinema := true;
      SetTimer(Self.Handle, timerMouseOnCinema, 1000, nil);

  {    if config.PauseOnControl then
      begin
        if OldPlayState and (MyCinema.PlayState <> cpStopped) then
        begin
          MyCinema.Play;
          OldPlayState := false;
        end;
      end;}
    end;

  end;
//  Application.ProcessMessages;
  if {config.PauseOnControl and} OldPlayState{or (mbLeft = Button) }then
  begin
    if {OldPlayState and }(MyCinema.PlayState <> cpStopped) then
    begin
      MyCinema.Play;
      OldPlayState := false;
    end;
  end;
end;

procedure TfrmCinemaPlayer.MyCinemaDblClick(Sender: TObject);
var
  tmpCenterPoint: TCenterPoint;
begin
  if bPauseAfterClick then
  begin
    tbPlayPause.Action.Execute;
    bPauseAfterClick := false;
  end;
//  KillTimer(Handle, timerPlayPause);
  IgnoreMouseOnCinema := true;
  SetTimer(Self.Handle, timerMouseOnCinema, 1000, nil);
  if GetKeyState(VK_CONTROL) < 0 then
  begin
    frame_manager.set_aspect_ratio(arOriginal);
    frame_manager.set_zoom(1);
    tmpCenterPoint.Horiz := 0.5;
    tmpCenterPoint.Vert := 0.5;
    frame_manager.set_center_point(tmpCenterPoint);
  end
  else
    if (config.DblClick2FullScr and (GetKeyState(VK_SHIFT) >= 0)) or
       ((not config.DblClick2FullScr) and (GetKeyState(VK_SHIFT) < 0)) then
      aFullScreen.Execute
    else
    begin
      tmpCenterPoint.Horiz := 0.5;
      tmpCenterPoint.Vert := 0.5;
      frame_manager.set_center_point(tmpCenterPoint);
    end;
end;

procedure TfrmCinemaPlayer.ptbPositionMouseEnter(Sender: TObject);
begin
  Application.HintPause := 100;
  Application.HintHidePause := MaxInt;
  ActiveModification := true;
end;

procedure TfrmCinemaPlayer.ptbPositionMouseLeave(Sender: TObject);
begin
  Application.HintPause := 500;
  Application.HintHidePause := 4000;
  ActiveModification := false;
end;

procedure TfrmCinemaPlayer.RebuildBookmarks;
var
  i: integer;
  Tekst: string;
begin
  for i := 1 to 10 do
  begin
    Tekst := '&' + IntToStr(i mod 10) + '. ';
    if config.Bookmarks[i].FileName <> '' then
      Tekst := Tekst +
        PrepareTime(config.Bookmarks[i].Position, false) + ' ==> ' +
        ExtractFileName(config.Bookmarks[i].FileName)
    else
      Tekst := Tekst + LangStor[LNG_BOOKMARK] + ' ' + IntToStr(i);
    miGotoBookmarks.Items[i - 1].Caption := Tekst;
    miSetBookmarks.Items[i - 1].Caption := Tekst;

    miGotoBookmarks.Items[i - 1].Enabled := config.Bookmarks[i].FileName <> '';
  end;
end;

procedure TfrmCinemaPlayer.CreateBookmarkMenu;
var
  i: integer;
  SetShortKey, GotoShortKey: TShortCut;
begin
  for i := 10 downto 1 do
  begin
    SetShortKey := ShortCut(Ord('0') + (i mod 10), [ssCtrl, ssShift]);
    GotoShortKey := ShortCut(Ord('0') + (i mod 10), [ssCtrl]);
    AddMenuItem(miGotoBookmarks, '', miGotoBookmarkClick, GotoShortKey, true, true).Tag := i + 10;
    AddMenuItem(miSetBookmarks, '', miSetBookmarkClick, SetShortKey, true, true).Tag := i + 10;
  end;
end;

procedure TfrmCinemaPlayer.miGotoBookmarkClick(Sender: TObject);
begin
  aGotoBookmark.Tag := (Sender as TMenuItem).Tag - 10;
  aGotoBookmark.Execute;
end;

procedure TfrmCinemaPlayer.miSetBookmarkClick(Sender: TObject);
begin
  aSetBookmark.Tag := (Sender as TMenuItem).Tag - 10;
  aSetBookmark.Execute;
end;

procedure TfrmCinemaPlayer.WMSysCommand(var Msg: TWMSysCommand);
begin
  if MyCinema.PlayState = cpPlaying then
  begin
    case Msg.CmdType and $FFF0 of
      SC_SCREENSAVE, SC_MONITORPOWER:
      begin
        Msg.Result := 1;
        exit;
      end;
    end;
  end;
  inherited;
end;

procedure TfrmCinemaPlayer.WMDropFiles(var Msg: TWMDropFiles);
var
  TotalNumberOfFiles, nFileLength: Integer;
  pszFileName: PChar;
  i: Integer;
  IsControlKey, IsShiftKey: boolean;
  onlySubtitles: boolean;
  subtitleFileName: string;
  p: TPoint;
begin
  GetCursorPos(p);
  IsControlKey := GetKeyState(VK_CONTROL) < 0;
  IsShiftKey := (GetKeyState(VK_SHIFT) < 0) or (WindowFromPoint(p) = PlaylistBox.Handle);
  TotalNumberOfFiles := DragQueryFile(Msg.Drop, $FFFFFFFF, Nil, 0);

  // check if user drop only subtitle files
  onlySubtitles := true;
  for i := 0 to TotalNumberOfFiles - 1 do
  begin
    nFileLength := DragQueryFile(Msg.Drop, i, Nil, 0) + 1;
    GetMem(pszFileName, nFileLength);
    DragQueryFile(Msg.Drop, i, pszFileName, nFileLength);

    if (GetFileAttributes(pszFileName) and FILE_ATTRIBUTE_DIRECTORY) <> 0 then
    begin
      onlySubtitles := false;
    end
    else
      if not IsExpectedFile(string(pszFileName), PlaylistBox.SubtitleExt) then
        onlySubtitles := false;
    FreeMem(pszFileName, nFileLength);
  end;


  if not IsShiftKey and not onlySubtitles then
    PlaylistBox.DeleteItems(ditAll);

  subtitleFileName := '';
  for i := 0 to TotalNumberOfFiles - 1 do
  begin
    nFileLength := DragQueryFile(Msg.Drop, i, Nil, 0) + 1;
    GetMem(pszFileName, nFileLength);
    DragQueryFile(Msg.Drop, i, pszFileName, nFileLength);

    if (GetFileAttributes(pszFileName) and FILE_ATTRIBUTE_DIRECTORY) <> 0 then
    begin
      PlaylistBox.ScanDir(NormalizeDir(string(pszFileName)), PlaylistBox.MovieExt, IsControlKey);
    end
    else
      if IsExpectedFile(string(pszFileName), PlaylistBox.SubtitleExt) then
      begin
        if subtitleFileName = '' then
          subtitleFileName := pszFileName;
      end
      else
        {if IsControlKey or
           IsExpectedFile(string(pszFileName), PlaylistBox.MovieExt) or
           IsExpectedFile(string(pszFileName), PlaylistBox.PlayListExt) then}
          PlaylistBox.AddPlayItem(string(pszFileName));
    FreeMem(pszFileName, nFileLength);
  end;

  DragFinish(Msg.Drop);
//  PlaylistBox.RefreshCount;

  if (not IsShiftKey and not onlySubtitles) or (MyCinema.FileName = '') then
  begin
    PlaylistBox.ChargeItem(0, config.Autoplay);
    ShowWnd;
  end;
  if subtitleFileName <> '' then
    loadSubtitles(subtitleFileName, true, true); 
end;

procedure TfrmCinemaPlayer.SafeResize(NewPosition: TRect; dx, dy: integer);
var
  tempPoint: TPoint;
  tempW, tempH: integer;
  WorkArea: TRect;
begin
  tempPoint.x := Left + Width div 2;
  tempPoint.y := Top + Height div 2;
  with NewPosition do
  begin
    if config.ViewStandard then
    begin
      if (Right - Left) < MinWindowWidth then
        Right := Left + MinWindowWidth;
    end
    else
    begin
      if (Right - Left) < MinWindowMiniWidth then
        Right := Left + MinWindowMiniWidth;
    end;
    if (Bottom - Top) < MinWindowHeight then
      Bottom := Top + MinWindowHeight;

    SetNewFontSize(Right - Left - (Width - ClientWidth), Bottom - Top - (Height - ClientHeight) - control_panel.getHeight);
    NewPosition.Bottom := NewPosition.Bottom +
      integer((config.SubtitlesAttr.RenderMode = rmFullRect) and
              (not (aHideText.Checked or (config.SpeakerEnabled and config.SpeakerHideSubtitles))) and
              (MyCinema.VideoWidth > 0)) *
      subtitle_viewer.get_fixed_size * config.SubtitleRows;

    tempW := Left + (Right - Left) div 2;
    tempH := Top + (Bottom - Top) div 2;
    OffsetRect(NewPosition, tempPoint.x - tempW, tempPoint.y - tempH);
    SystemParametersInfo(SPI_GETWORKAREA, 0, @WorkArea, 0);
    if Right > WorkArea.Right then
      OffsetRect(NewPosition, WorkArea.Right - Right, 0);
    if Bottom > WorkArea.Bottom then
      OffsetRect(NewPosition, 0, WorkArea.Bottom - Bottom);
    if Left < WorkArea.Left then
      OffsetRect(NewPosition, WorkArea.Left - Left, 0);
    if Top < WorkArea.Top then
      OffsetRect(NewPosition, 0, WorkArea.Top - Top);
  end;
  OffsetRect(NewPosition, dx, dy);
  BoundsRect := NewPosition;
end;

procedure TfrmCinemaPlayer.aClearRecentExecute(Sender: TObject);
var
  i: integer;
begin
  freeSubMenus(miRecentFiles, 2);
  miRecentFiles.Enabled := false;

  for i := 1 to RecentCount do
  begin
    config.Files[i].Movie := '';
    config.Files[i].Text := '';
  end;

  if MyCinema.FileName = '' then
    aPlay.Enabled := false;
end;

procedure TfrmCinemaPlayer.aNextAspectRatioExecute(Sender: TObject);
begin
  aSetAspectRatio.Tag := integer(frame_manager.get_next_aspect_ratio());
  aSetAspectRatio.Execute;
//  ChangeVideoPosition([cvpNextAspectRatio], false);
end;

procedure TfrmCinemaPlayer.aSetAspectRatioExecute(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to miAspectRatio.Count - 1 do
    if miAspectRatio.Items[i].Tag = aSetAspectRatio.Tag then
    begin
      miAspectRatio.Items[i].Checked := true;
      break;
    end;
  frame_manager.set_aspect_ratio(TAspectRatioMode(aSetAspectRatio.Tag));
end;

procedure TfrmCinemaPlayer.miAROryginalClick(Sender: TObject);
begin
  aSetAspectRatio.Tag := (Sender as TMenuItem).Tag;
  aSetAspectRatio.Execute;
//  frame_manager.set_aspect_ratio(TAspectRatioMode((Sender as TMenuItem).Tag));
end;

procedure TfrmCinemaPlayer.frame_managerChangeAspectRatio(Sender: TObject);
var
  temp: string;
begin
  config.AspectRatio := frame_manager.get_aspect_ratio;
  case config.AspectRatio of
    arOriginal:
    begin
      miAROryginal.Checked := true;
      temp := miAROryginal.Caption;
    end;
    arFree:
    begin
      miARFree.Checked := true;
      temp := miARFree.Caption;
    end;
    ar16to9:
    begin
      miAR16_9.Checked := true;
      temp := miAR16_9.Caption;
    end;
    ar4to3:
    begin
      miAR4_3.Checked := true;
      temp := miAR4_3.Caption;
    end;
    ar2_35to1:
    begin
      miAR2_35_1.Checked := true;
      temp := miAR2_35_1.Caption;
    end;
    arCustom:
    begin
      miAROther.Checked := true;
    end;
  end;

  if frame_manager.get_aspect_ratio() <> arCustom then
  begin
//    osdPanel.DisplayOSD(GetHint(temp));
    osd_viewer.render(GetHint(temp));
//    lSubtitles.Caption := quasiOSD;
//    SetTimer(Handle, timerRefreshDeltaTime, 1500, nil);
  end;
end;

procedure TfrmCinemaPlayer.aCloseExecute(Sender: TObject);
begin
//  aPlay.Checked := false;
//  aPause.Checked := false;
//  aStop.Checked := true;
  MyCinema.Close;
end;

var
  last_message_time: cardinal = 0;
procedure TfrmCinemaPlayer.WMCopyData(var Msg: TWMCopyData);
var
  i: DWORD;
  Shift: boolean;
  message_time: cardinal;
  delta_time: cardinal;
  item: PChar;
//  FileToCharge: string;
begin
//  logDebugFmt('Otrzymano parametrów z innej instancji. [%d]', [Msg.CopyDataStruct.cbData]);
  message_time := GetTickCount;
  delta_time := message_time - last_message_time;
  last_message_time := message_time;
  Shift := GetKeyState(VK_SHIFT) < 0;

  if (delta_time > 1000) and not Shift then
  begin
//    logDebug('Clearing playlist...');
    PlaylistBox.DeleteItems(ditAll);
//    logDebug('OK');
  end;

  try
    i := 0;
    repeat
      item := PChar(Msg.CopyDataStruct.lpData) + i;
      if (GetFileAttributes(item) and FILE_ATTRIBUTE_DIRECTORY) <> 0 then
        PlaylistBox.ScanDir(
          NormalizeDir(item),
          PlaylistBox.MovieExt + PlaylistBox.PlayListExt,
          GetDriveType(PChar(ExtractFileDrive(item))) = DRIVE_CDROM)
      else
//      logDebugFmt('Znaleziono parametr: "%s"', [string(PChar(Msg.CopyDataStruct.lpData) + i)]);
        PlaylistBox.AddPlayItem(item);
//      if i = 0 then
//        FileToCharge := string(PChar(Msg.CopyDataStruct.lpData) + i);
      inc(i, StrLen(PChar(Msg.CopyDataStruct.lpData) + i) + 1);
    until i >= Msg.CopyDataStruct.cbData;
    if IsIconic(Application.Handle) then
      Application.Restore;
  finally
    Msg.Result := 1;
  end;

//  PlaylistBox.RefreshCount;
  if (delta_time > 1000) and not Shift then
//  if PlaylistBox.Count = 1 then
  begin
//    logDebug('Odpalam film...');
    PlaylistBox.ChargeItem(0, config.Autoplay);
    ShowWnd;
//    logDebug('OK');
  end;
  inherited;
end;

procedure TfrmCinemaPlayer.aPlayNextExecute(Sender: TObject);
begin
  PlaylistBox.PlayNextItem;
end;

procedure TfrmCinemaPlayer.aPlayPrevExecute(Sender: TObject);
begin
  PlaylistBox.PlayPrevItem;
end;

procedure TfrmCinemaPlayer.aPlaylistExecute(Sender: TObject);
var
  tempPoint: TPoint;
begin
  aPlaylist.Checked := not aPlaylist.Checked;
  config.Playlist := aPlaylist.Checked;
  if aPlaylist.Checked and ChangeResolution.FullScreen then
  begin
    GetCursorPos(tempPoint);
//    tempPoint.x := Self.Monitor.Width - PlaylistBox.Width div 2;
    tempPoint.x := PlaylistBox.Left + PlaylistBox.Width div 2;
    SetCursorPos(tempPoint.x, tempPoint.y);
  end;
  PlaylistBox.Visible := aPlaylist.Checked;
{  if config.PlaylistToLeft then
    PlaylistSplitter.Left := PlaylistBox.Width
  else
    PlaylistSplitter.Left := PlaylistBox.Left - 3;}
  PlaylistSplitter.Visible := aPlaylist.Checked;
  if aPlaylist.Checked then
  begin
    if Visible then
      PlaylistBox.SetFocus;
    MyShowCursor(true);
    aLargeBack.ShortCut := ShortCut(VK_LEFT, [ssCtrl]);
    aLargeStep.ShortCut := ShortCut(VK_RIGHT, [ssCtrl]);
    aVolumeUp.ShortCut := ShortCut(VK_HOME, []);
    aVolumeDown.ShortCut := ShortCut(VK_END, []);
  end
  else
  begin
    aLargeBack.ShortCut := ShortCut(VK_PRIOR, []);
    aLargeStep.ShortCut := ShortCut(VK_NEXT, []);
    aVolumeUp.ShortCut := ShortCut(VK_UP, []);
    aVolumeDown.ShortCut := ShortCut(VK_DOWN, []);
  end;
end;

procedure TfrmCinemaPlayer.aOpenListExecute(Sender: TObject);
begin
  FOpenActionActive := true;
  IgnoreMouseOnCinema := true;
//  osdPanel.Enabled := false;
  try
//    if aStayOnTop.Checked then
//      SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
    PlaylistBox.OpenItem(false, oitPlaylist);
  finally
//    if aStayOnTop.Checked then
//      SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
    FOpenActionActive := false;
    SetTimer(Self.Handle, timerMouseOnCinema, 3000, nil);
//    osdPanel.Enabled := true;
  end;
end;

procedure TfrmCinemaPlayer.aOpenDirExecute(Sender: TObject);
begin
  FOpenActionActive := true;
  IgnoreMouseOnCinema := true;
//  osdPanel.Enabled := false;
  try
//    if aStayOnTop.Checked then
//      SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
    PlaylistBox.OpenDir(false, oitFile);
  finally
//    if aStayOnTop.Checked then
//      SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
    FOpenActionActive := false;
    SetTimer(Self.Handle, timerMouseOnCinema, 3000, nil);
//    osdPanel.Enabled := true;
  end;
end;

procedure TfrmCinemaPlayer.aAddFilesExecute(Sender: TObject);
begin
  FOpenActionActive := true;
  IgnoreMouseOnCinema := true;
//  osdPanel.Enabled := false;
  try
//    if aStayOnTop.Checked then
//      SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
    PlaylistBox.OpenItem(true, oitFile);
  finally
//    if aStayOnTop.Checked then
//      SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
    FOpenActionActive := false;
    SetTimer(Self.Handle, timerMouseOnCinema, 3000, nil);
//    osdPanel.Enabled := true;
  end;
end;

procedure TfrmCinemaPlayer.aAddDirExecute(Sender: TObject);
begin
  FOpenActionActive := true;
  IgnoreMouseOnCinema := true;
//  osdPanel.Enabled := false;
  try
//    if aStayOnTop.Checked then
//      SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
    PlaylistBox.OpenDir(true, oitFile);
  finally
//    if aStayOnTop.Checked then
//      SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
    FOpenActionActive := false;
    SetTimer(Self.Handle, timerMouseOnCinema, 3000, nil);
//    osdPanel.Enabled := true;
  end;
end;

procedure TfrmCinemaPlayer.aDelSelExecute(Sender: TObject);
begin
  if aPlaylist.Checked then
    PlaylistBox.DeleteItems(ditSel);
end;

procedure TfrmCinemaPlayer.aDelCropExecute(Sender: TObject);
begin
  if aPlaylist.Checked then
    PlaylistBox.DeleteItems(ditCrop);
end;

procedure TfrmCinemaPlayer.aDelDeathExecute(Sender: TObject);
begin
  if aPlaylist.Checked then
    PlaylistBox.DeleteItems(ditDeath);
end;

procedure TfrmCinemaPlayer.aDelAllExecute(Sender: TObject);
begin
//  if aPlaylist.Checked then
  PlaylistBox.DeleteItems(ditAll);
end;

procedure TfrmCinemaPlayer.aSelInvertExecute(Sender: TObject);
begin
  PlaylistBox.SelectItems(sitInvert);
end;

procedure TfrmCinemaPlayer.aSelNoneExecute(Sender: TObject);
begin
  PlaylistBox.SelectItems(sitNone);
end;

procedure TfrmCinemaPlayer.aSelAllExecute(Sender: TObject);
begin
  PlaylistBox.SelectItems(sitAll);
end;

procedure TfrmCinemaPlayer.aSortExecute(Sender: TObject);
var
  tempPointer: TObject;
begin
  if PlaylistBox.PlayedItem in [0 .. PlaylistBox.Items.Count - 1] then
    tempPointer := PlaylistBox.Items.Objects[PlaylistBox.PlayedItem]
  else
    tempPointer := nil;
  PlaylistBox.Sorted := true;
  PlaylistBox.Sorted := false;
  if tempPointer <> nil then
    PlaylistBox.PlayedItem := PlaylistBox.Items.IndexOfObject(tempPointer);// tempPointer := Pointer(lbPlaylist.Items.Objects[PlayedItem])
end;

procedure TfrmCinemaPlayer.aShuffleExecute(Sender: TObject);
begin
  aShuffle.Checked := not aShuffle.Checked;
  config.Shuffle := aShuffle.Checked;
  PlaylistBox.Shuffle := aShuffle.Checked;
  if aShuffle.Checked then
    Randomize;
end;

procedure TfrmCinemaPlayer.aRepeatExecute(Sender: TObject);
begin
  aRepeat.Checked := not aRepeat.Checked;
  config.RepeatList := aRepeat.Checked;
  PlaylistBox.RepeatList := aRepeat.Checked;
end;

procedure TfrmCinemaPlayer.aMoveUpExecute(Sender: TObject);
var
  i, MovedItem: integer;
  IsSelectedBlock: boolean;
  selList: TList;
  firstNotSelected, newSel: integer;
begin
  MovedItem := -1;
  IsSelectedBlock := false;
  selList := TList.Create;
  try
    firstNotSelected := PlaylistBox.Items.Count - 1;
    for i := 0 to PlaylistBox.Items.Count - 1 do
      if PlaylistBox.Selected[i] then
        selList.Add(Pointer(i))
      else
        if (firstNotSelected = PlaylistBox.Items.Count - 1) then
          firstNotSelected := i;

    for i := 0 to PlaylistBox.Items.Count do
      if (i < PlaylistBox.Items.Count) and PlaylistBox.Selected[i] then
        IsSelectedBlock := true
      else
      begin
        if (MovedItem > -1) and IsSelectedBlock then
        begin
          if MovedItem = PlaylistBox.PlayedItem then
            PlaylistBox.PlayedItem := i - 1
          else
            if PlaylistBox.PlayedItem in [MovedItem + 1 .. i - 1] then
              PlaylistBox.PlayedItem := PlaylistBox.PlayedItem - 1;
          PlaylistBox.Items.Move(MovedItem, i - 1);
        end;
        MovedItem := i;
        IsSelectedBlock := false;
      end;

    for i := 0 to selList.Count - 1 do
    begin
      newSel := integer(selList[i]);
      if newSel > firstNotSelected then
        dec(newSel);

      if newSel >= 0 then
        PlaylistBox.Selected[newSel] := true;
    end;
  finally
    selList.Free;
  end;
end;

procedure TfrmCinemaPlayer.aMoveDownExecute(Sender: TObject);
var
  i, MovedItem: integer;
  IsSelectedBlock: boolean;
  selList: TList;
  lastNotSelected, newSel: integer;
begin
  MovedItem := -1;
  IsSelectedBlock := false;
  selList := TList.Create;
  try
    lastNotSelected := 0;
    for i := PlaylistBox.Items.Count - 1 downto 0 do
      if PlaylistBox.Selected[i] then
        selList.Add(Pointer(i))
      else
        if (lastNotSelected = 0) then
          lastNotSelected := i;

    for i := PlaylistBox.Items.Count - 1 downto -1 do
      if (i > -1) and PlaylistBox.Selected[i] then
        IsSelectedBlock := true
      else
      begin
        if (MovedItem > -1) and IsSelectedBlock then
        begin
          if MovedItem = PlaylistBox.PlayedItem then
            PlaylistBox.PlayedItem := i + 1
          else
            if PlaylistBox.PlayedItem in [i + 1 .. MovedItem - 1] then
              PlaylistBox.PlayedItem := PlaylistBox.PlayedItem + 1;
          PlaylistBox.Items.Move(MovedItem, i + 1);
        end;
        MovedItem := i;
        IsSelectedBlock := false;
      end;

    for i := 0 to selList.Count - 1 do
    begin
      newSel := integer(selList[i]);
      if newSel < lastNotSelected then
        inc(newSel);

      if newSel < PlaylistBox.Items.Count then
        PlaylistBox.Selected[newSel] := true;
    end;
  finally
    selList.Free;
  end;
end;

procedure TfrmCinemaPlayer.PlaylistBoxDeleteItem(Sender: TObject);
begin
  if PlaylistBox.Items.Count = 0 then
  begin
    aSaveList.Enabled := false;
    aSort.Enabled := false;
    aDelSel.Enabled := false;
    aDelCrop.Enabled := false;
    aDelDeath.Enabled := false;
    aDelAll.Enabled := false;
    aSelInvert.Enabled := false;
    aSelNone.Enabled := false;
    aSelAll.Enabled := false;
  end;
  if PlaylistBox.Items.Count < 2 then
  begin
    aPlayNext.Enabled := false;
    aPlayPrev.Enabled := false;
    aMoveUp.Enabled := false;
    aMoveDown.Enabled := false;
  end;
end;

procedure TfrmCinemaPlayer.PlaylistBoxAddItem(Sender: TObject);
begin
  aSaveList.Enabled := true;
  aSort.Enabled := true;
  aDelSel.Enabled := true;
  aDelCrop.Enabled := true;
  aDelDeath.Enabled := true;
  aDelAll.Enabled := true;
  aSelInvert.Enabled := true;
  aSelNone.Enabled := true;
  aSelAll.Enabled := true;
  if PlaylistBox.Items.Count > 1 then
  begin
    aPlayNext.Enabled := true;
    aPlayPrev.Enabled := true;
    aMoveUp.Enabled := true;
    aMoveDown.Enabled := true;
  end;
end;

procedure TfrmCinemaPlayer.PlaylistBoxEnd(Sender: TObject);
begin
  aStop.Execute;
  ptbPosition.Position := 0;

  if (not PopupMenuVisible) and {(not control_panel.isVisibled) and}
     (not settings_visibled) and (not isAnyCommonDialogActive()) then
    if aShutDown.Checked then
        TurnOffSystem
    else
      if config.CloseAfterPlay then
        Close;
end;

procedure TfrmCinemaPlayer.PlaylistBoxBegin(Sender: TObject);
begin
  aStop.Execute;
  ptbPosition.Position := 0;
end;

procedure TfrmCinemaPlayer.PlaylistBoxDblClick(Sender: TObject);
begin
  PlaylistBox.ChargeItem(PlaylistBox.ItemIndex, true);
end;

procedure TfrmCinemaPlayer.PlaylistBoxChargeItem(Sender: TObject;
  Name: String; BeginPlay: Boolean; Position: Double);
begin
  if (Name = MyCinema.FileName) and PlaylistBox.Add then
    exit;

  if (Name = MyCinema.FileName) then
  begin
    _speaker.flush();
    MyCinema.CurrentPosition := Position;
  end
  else
    OpenNewMovie(Name, Position);

//  if (BeginPlay and (not config.Autoplay)) or ((LastMovieState.file_name <> '') and IsNextFile(LastMovieState.file_name, ExtractFileName(MyCinema.FileName), true)) then
  MyCinema.VideoVisible := true;
  if (BeginPlay and (not config.Autoplay)) or LastMovieState.is_part_prev_movie then
  begin
    aPlay.Execute;
  end;
  //else

  if LastMovieState.is_part_prev_movie then
  begin
    frame_manager.set_aspect_ratio(LastMovieState.aspect_ratio);
    frame_manager.set_video_rect(LastMovieState.video_rect);
    frame_manager.set_display_size(LastMovieState.display_size);
    if (LastMovieState.subtitle_name <> '') and (Subtitles.FileName = '') then
    begin
      runStreamAfterLoadingSubtitles(true);
    end;
  end;

  if LastMovieState.file_name <> '' then
  begin
    frame_manager.set_zoom(LastMovieState.zoom);
    frame_manager.set_center_point(LastMovieState.center_point);
  end;
{        if is_part_prev_movie then
          pmAudioStreams.Items[LastMovieState.audio_stream].Click
        else
          pmAudioStreams.Items[0].Click;
//        CheckPanelOnTop;}
end;

procedure TfrmCinemaPlayer.PlaylistSplitterMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  tempPoint: TPoint;
begin
  GetCursorPos(tempPoint);
  PlayListResizeX := tempPoint.x;
  if config.PlaylistToLeft then
    PlayListResizePos := PlaylistBox.Width
  else
    PlayListResizePos := PlaylistBox.Left;
  SetCaptureControl(PlaylistSplitter);
  PlayListResize := true;
end;

procedure TfrmCinemaPlayer.PlaylistSplitterMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  tempPoint: TPoint;
  tempRect: TRect;
begin
  if PlayListResize then
  begin
    GetCursorPos(tempPoint);
    tempRect := PlaylistBox.BoundsRect;
    if config.PlaylistToLeft then
    begin
      tempRect.Right := PlayListResizePos + tempPoint.x - PlayListResizeX;
      if tempRect.Right - tempRect.Left < 100 then
        tempRect.Right := tempRect.Left + 100;
      if tempRect.Right - tempRect.Left > 300 then
        tempRect.Right := tempRect.Left + 300;
      PlaylistSplitter.Left := tempRect.Right;
    end
    else
    begin
      tempRect.Left := PlayListResizePos + tempPoint.x - PlayListResizeX;
      if tempRect.Right - tempRect.Left < 100 then
        tempRect.Left := tempRect.Right - 100;
      if tempRect.Right - tempRect.Left > 300 then
        tempRect.Left := tempRect.Right - 300;
      PlaylistSplitter.Left := tempRect.Left - 3;
    end;

    PlaylistBox.BoundsRect := tempRect;
  end;
end;

procedure TfrmCinemaPlayer.PlaylistSplitterMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if PlayListResize then
  begin
    PlayListResize := false;
    ReleaseCapture;
  end;
end;

procedure TfrmCinemaPlayer.aShutDownExecute(Sender: TObject);
begin
  aShutDown.Checked := not aShutDown.Checked;
  config.SuspendState := aShutDown.Checked;
end;

procedure TfrmCinemaPlayer.miPropertiesClick(Sender: TObject);
//var
//  MyShellExecuteInfo : TShellExecuteInfo;
begin
{  ZeroMemory(@MyShellExecuteInfo, SizeOf(TShellExecuteInfo));

  MyShellExecuteInfo.cbSize := SizeOf(TShellExecuteInfo);
  MyShellExecuteInfo.lpFile := PChar(PlaylistBox.MovieProp.MovieFileName);
  MyShellExecuteInfo.lpVerb := 'properties';
  MyShellExecuteInfo.fMask  := SEE_MASK_INVOKEIDLIST;

  ShellExecuteEx(@MyShellExecuteInfo);}
end;

procedure TfrmCinemaPlayer.ShowMinimal;
var
  MenuHeight,
  ControlHeight: integer;
  tempRect: TRect;
begin
  if not ChangeResolution.FullScreen then
  begin
    MenuHeight := ClientHeight;
    ControlHeight := control_panel.getHeight;// CONTROLPANEL_HEIGHT;
    tempRect := BoundsRect;
    Menu := nil;
    MenuHeight := ClientHeight - MenuHeight;
  end;

  control_panel.setDesign(cpdMini);

  if not ChangeResolution.FullScreen then
  begin
    ControlHeight := ControlHeight - control_panel.getHeight;// MINICONTROLPANEL_HEIGHT;
    tempRect.Bottom := tempRect.Bottom - ControlHeight - subtitle_viewer.get_fixed_size *
      integer((MyCinema.VideoWidth > 0) and (config.SubtitlesAttr.RenderMode = rmFullRect) and
      not (aHideText.Checked or (config.SpeakerEnabled and config.SpeakerHideSubtitles)));
    tempRect.Top := tempRect.Top + MenuHeight;
    SafeResize(tempRect, 0, (MenuHeight - ControlHeight) div 2);
  end
  else
    resize_window;
end;

procedure TfrmCinemaPlayer.ShowStandard;
var
  MenuHeight,
  ControlHeight: integer;
  tempRect: TRect;
begin
  if not ChangeResolution.FullScreen then
  begin
    MenuHeight := ClientHeight;
    ControlHeight := control_panel.getHeight; //MINICONTROLPANEL_HEIGHT;
    tempRect := BoundsRect;
    Menu := MainMenu;
    MenuHeight := MenuHeight - ClientHeight;
  end;

  control_panel.setDesign(cpdStandart);

  if not ChangeResolution.FullScreen then
  begin
    ControlHeight := control_panel.getHeight {CONTROLPANEL_HEIGHT} - ControlHeight;
    tempRect.Bottom := tempRect.Bottom + ControlHeight - subtitle_viewer.get_fixed_size *
      integer((MyCinema.VideoWidth > 0) and (config.SubtitlesAttr.RenderMode = rmFullRect) and
      not (aHideText.Checked or (config.SpeakerEnabled and config.SpeakerHideSubtitles)));
    tempRect.Top := tempRect.Top - MenuHeight;
    SafeResize(tempRect, 0, -(MenuHeight - ControlHeight) div 2);
  end
  else
    resize_window;
end;

procedure TfrmCinemaPlayer.aViewStandardExecute(Sender: TObject);
begin
  aViewStandard.Checked := true;
  aViewMinimal.Checked := false;
  config.ViewStandard := true;
  ShowStandard;
end;

procedure TfrmCinemaPlayer.aViewMinimalExecute(Sender: TObject);
begin
  aViewMinimal.Checked := true;
  aViewStandard.Checked := false;
  config.ViewStandard := false;
  ShowMinimal;
end;

procedure TfrmCinemaPlayer.aSaveListExecute(Sender: TObject);
begin
  with SaveDialog do
  begin
    Filter := LangStor[LNG_DIALOG_PLAYLISTS] + '|*.asx|' + PlaylistBox.AllFilter;
    FilterIndex := 1;
    DefaultExt := 'asx';
//    if aStayOnTop.Checked then
//      SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
    IgnoreMouseOnCinema := true;
    if Execute then
      PlaylistBox.SaveList(FileName);
//    if aStayOnTop.Checked then
//      SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
    SetTimer(Self.Handle, timerMouseOnCinema, 3000, nil);
  end;
end;

procedure TfrmCinemaPlayer.aSubEditorExecute(Sender: TObject);
begin
  aSubEditor.Checked := not aSubEditor.Checked;
  if aSubEditor.Checked then
    frmEditor.Show
  else
    frmEditor.Close;
//  if not aSubEditor.Checked then
end;

procedure TfrmCinemaPlayer.aSmallStepExecute(Sender: TObject);
begin
  if PlaylistBox.Focused then
    PlaylistBoxDblClick(PlaylistBox)
  else
    ptbPosition.Position := ptbPosition.Position + 10;
end;

procedure TfrmCinemaPlayer.aSmallBackExecute(Sender: TObject);
begin
  ptbPosition.Position := ptbPosition.Position - 10;
end;

procedure TfrmCinemaPlayer.DeltaTimeChange(Sender: TObject);
var
  s: string;
begin
  if (Sender as TSubtitles).DeltaTime >= 0 then
    s := Format(LangStor[LNG_STATUS_SUBTITLES] + ' %.2f ' + LangStor[LNG_OPT_SECOND], [-(Sender as TSubtitles).DeltaTime])
  else
    if (Sender as TSubtitles).DeltaTime < 0 then
      s := Format(LangStor[LNG_STATUS_SUBTITLES] + ' +%.2f ' + LangStor[LNG_OPT_SECOND], [-(Sender as TSubtitles).DeltaTime]);

  if config.OSDEnabled then
    osd_viewer.render(s)
  else
    control_panel.setStatus(s, cpsSubtitles);
end;

procedure TfrmCinemaPlayer.WMSetText(var Msg: TWMSetText);
begin
  inherited;
  Application.Title := Msg.Text;
end;

procedure TfrmCinemaPlayer.SetParentMenu(ParentMenu: TComponent;
  Item: TMenuItem; Index: integer);
begin
try
  if Item.Parent <> nil then Item.Parent.Remove(Item);
  if ParentMenu <> nil then
    if ParentMenu is TMenu then
      TMenu(ParentMenu).Items.Add(Item)
    else if ParentMenu is TMenuItem then
      TMenuItem(ParentMenu).Add(Item);
  Item.MenuIndex := Index;
except
end;
end;

procedure TfrmCinemaPlayer.miFileClick(Sender: TObject);
begin
  SetParentMenu(miFile, miRecentFiles, 4);
  SetParentMenu(miFile, miSetBookmarks, 5);
  SetParentMenu(miFile, miGotoBookmarks, 6);
  SetParentMenu(miFile, N3, 10);
  SetParentMenu(miFile, miCodecsProps, 13);
  SetParentMenu(miFile, miOptions, 14);
  SetParentMenu(miFile, N18, 15);
  SetParentMenu(miFile, miShutDown, 16);
  SetParentMenu(miFile, miExit, 17);

  BuildFilterlistMenu;
end;

procedure TfrmCinemaPlayer.miViewClick(Sender: TObject);
begin
  SetParentMenu(miView, miZoom, 5);
  SetParentMenu(miView, miAspectRatio, 6);
  SetParentMenu(miView, N11, 9);
  SetParentMenu(miView, miHideText, 10);
  SetParentMenu(miView, miSubTimeSetts, 11);
  SetParentMenu(miView, miStayOnTop, 12);
  SetParentMenu(miView, N15, 13);
end;

procedure TfrmCinemaPlayer.pmAddItemsPopup(Sender: TObject);
begin
  SetParentMenu(pmAddItems, miRecentFiles, 0);
end;

procedure TfrmCinemaPlayer.aSubtitleTimeResetExecute(Sender: TObject);
begin
  Subtitles.DeltaTime := 0;
end;

procedure TfrmCinemaPlayer.aSubtitleTimeBackExecute(Sender: TObject);
begin
  Subtitles.DeltaTime := Subtitles.DeltaTime + 0.25;
end;

procedure TfrmCinemaPlayer.aSubtitleTimeForwardExecute(Sender: TObject);
begin
  Subtitles.DeltaTime := Subtitles.DeltaTime - 0.25;
end;

procedure TfrmCinemaPlayer.CheckCommandLine();
var
  i: integer;
begin
  for i := 1 to ParamCount do
    if AnsiLowerCase(ParamStr(i)) = '/f' then
      ParamF := true
    else
      if AnsiLowerCase(ParamStr(i)) = '/ff' then
        ParamFF := true
      else
        if AnsiLowerCase(ParamStr(i)) = '/m' then
          ParamM := true
        else
          if AnsiLowerCase(ParamStr(i)) = '/min' then
            ParamMinView := true
          else
          begin
            last_message_time := GetTickCount;
            if (GetFileAttributes(PChar(ParamStr(i))) and FILE_ATTRIBUTE_DIRECTORY) <> 0 then
              PlaylistBox.ScanDir(
                NormalizeDir(ParamStr(i)),
                PlaylistBox.MovieExt + PlaylistBox.PlayListExt,
                GetDriveType(PChar(ExtractFileDrive(ParamStr(i)))) = DRIVE_CDROM)
            else
              PlaylistBox.AddPlayItem(ParamStr(i));
          end;
  ParamM := ParamM and not (ParamF or ParamFF);

  if ParamM then
    WindowState := wsMaximized;

  if ParamF or ParamFF or
     ((PlaylistBox.Items.Count > 0) and FileExists(PItemData(PlaylistBox.Items.Objects[0]).Path) and
     config.Autoplay and (config.AutoFullScreen <> afsNone)) then
  begin
{
  if (ParamF or ParamFF or (config.AutoFullScreen <> afsNone)) and
     ((PlaylistBox.Items.Count > 0) and config.Autoplay and
      FileExists(PItemData(PlaylistBox.Items.Objects[0]).Path)) then
}
    SetWindowLong(Handle, GWL_STYLE, fsWindowStyle);
    SetWindowLong(Handle, GWL_EXSTYLE, fsExWindowStyle);
  end
//    BorderStyle := bsNone;
end;

procedure TfrmCinemaPlayer.FormShow(Sender: TObject);
begin
  aStayOnTop.Checked := not config.StayOnTop;
  aStayOnTop.Execute;
  subtitle_viewer.enable;
  osd_viewer.clear;
  if config.OSDEnabled then
    osd_viewer.enable;
end;

procedure TfrmCinemaPlayer.SetNewFontSize(NewWidth, NewHeight: integer);
var
  skala: double;
begin
  if config.AutoSizeText then
  begin
    if (Self.Monitor.Width / Self.Monitor.Height) < (NewWidth / NewHeight) then
      skala := NewWidth / Self.Monitor.Width
    else
      skala := NewHeight / Self.Monitor.Height;
  end
  else
    skala := 1.0;

  subtitle_viewer.set_font_scale(skala);
//  subtitle_viewer.set_h_margin(config.EdgeSpace);
//  subtitle_viewer.set_v_margin(config.EdgeSpace);

  osd_viewer.set_font_scale(skala);
//  osd_viewer.set_v_margin(config.EdgeSpace);
end;

function TfrmCinemaPlayer.FindNextPart(var FName: string;
  allow_scan_cd: boolean): boolean;

  function SearchFolder(CurrentPath, CurrentFile: string; IgnoreSubfolders: boolean;
    var ResultFile: string): boolean;
  var
    SR: TSearchRec;
  begin
    Result := false;
    if FindFirst(NormalizeDir(CurrentPath) + '*.*', faAnyFile, SR) = 0 then
    begin
      repeat
        if (SR.Name <> '.') and (SR.Name <> '..') then
        begin
          if (SR.Attr and faDirectory) <> 0 then
          begin
            if not IgnoreSubfolders then
            begin
              Result := SearchFolder(NormalizeDir(CurrentPath + SR.FindData.cFileName),
                          CurrentFile, IgnoreSubfolders, ResultFile);
            end;
          end
          else
          begin
            if IsNextFile(CurrentFile, SR.FindData.cFileName, true) then
            begin
              ResultFile := CurrentPath + SR.FindData.cFileName;
              Result := true;
            end;
          end;

          if Result then
            break;
        end;
      until FindNext(SR) <> 0;
      FindClose(SR);
    end;
  end;

  function FindOnCDROM(CurrentName: string; var ResultFile: string): boolean;
  var
    Drive: char;
  begin
    Result := false;
    for Drive := 'C' to 'Z' do
      if GetDriveType(PChar(string(Drive + ':'))) = DRIVE_CDROM then
      begin
        Result := SearchFolder(Drive + ':\', CurrentName, false, ResultFile);
        if Result then
        begin
          exit;
        end;
      end;
  end;

  function CanBeMoviePart(s: string): boolean;
  var
    c: char;

    function IsDigit(ch: Char): boolean;
    begin
      Result := (c >= '0') and (c <= '9');
    end;

    function IsSequenceInString(sub, name: string): boolean;
    var
      i: integer;
    begin
      i := Pos(sub, name);
      Result := (i <= (Length(name) - Length(sub))) and IsDigit(name[i + Length(sub)]);
    end;

  begin
    Result := false;
// czy ostatnia litera nazwy pliku jest cyfr¹?
    c := s[Length(s) - Length(ExtractFileExt(s))];
    if IsDigit(c) then
      Result := true
    else
    begin
      if not IsSequenceInString('cd', s) then
        if not IsSequenceInString('cd_', s) then
          if not IsSequenceInString('part', s) then
            if not IsSequenceInString('part_', s) then
              exit;
      Result := true;
    end;
  end;


var
  Typ_dysku: cardinal;
  TryAgain: boolean;
//  nextFName: string;
//  numberFName: string;
//  i: integer;
  file_name, file_path: string;
begin
  file_path := ExtractFilePath(FName);
  file_name := ExtractFileName(FName);
  repeat
    TryAgain := true;
    Result := SearchFolder(file_path, file_name, true, FName);
    if Result or not allow_scan_cd then
      exit;

    Typ_dysku := GetDriveType(PChar(file_path));
    if Typ_dysku = DRIVE_CDROM then
    begin
      Result := FindOnCDROM(file_name, FName);
      if Result then
        exit
      else
      begin
        if config.SearchNextMoviePartOnCDROM and CanBeMoviePart(AnsiLowerCase(file_name)) then
        begin
          TryAgain := InsertCD;
        end
        else
          TryAgain := false;
      end;
    end
    else
      exit;
  until Result or not TryAgain;
end;

procedure TfrmCinemaPlayer.ResetVideoSize;
const
  Sizescale: array[TCPDisplaySize] of double = (0.5, 1.0, 2.0);
var
  tmpW, tmpH: integer;
  rs: TSize;
begin
  rs := MyCinema.VideoSize;
  tmpW := round(rs.cx * SizeScale[frame_manager.get_display_size()]);
  tmpH := round(rs.cy * SizeScale[frame_manager.get_display_size()]);
  ChangeSize(tmpW, tmpH);
end;

procedure TfrmCinemaPlayer.aExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmCinemaPlayer.FormActivate(Sender: TObject);
begin
  if FirstActivate then
  begin
    FirstActivate := false;
    if config._DonateID <= iDonateID then
    begin
      aDonate.Execute;
      BringToFront();
    end;
    if PlaylistBox.Items.Count > 0 then
      try
        PlaylistBox.ChargeItem(0, config.Autoplay);
        FirstActivate := false;
      except
        SetWindowLong(Handle, GWL_STYLE, wndWindowStyle);
        SetWindowLong(Handle, GWL_EXSTYLE, wndExWindowStyle);
//        BorderStyle := bsSizeable;
        raise;
      end
    else
    begin
      RebuildRecent('');
    end;
//    osdPanel.Enabled := config.OSDEnabled;
//    resize_window;
  end;
  if aStayOnTop.Checked then
    SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
end;

procedure TfrmCinemaPlayer.miPlayClick(Sender: TObject);
var
  i: integer;
begin
  SetParentMenu(miPlay, miPlayPrev, 0);
  SetParentMenu(miPlay, miPlayPause, 1);
  SetParentMenu(miPlay, miStop, 2);
  SetParentMenu(miPlay, miPlayNext, 3);
  SetParentMenu(miPlay, N4, 4);
  SetParentMenu(miPlay, miLargeBack, 5);
  SetParentMenu(miPlay, miBack, 6);
  SetParentMenu(miPlay, miStep, 7);
  SetParentMenu(miPlay, miLargeStep, 8);
  SetParentMenu(miPlay, N5, 9);
  SetParentMenu(miPlay, miSpeed, 13);
  SetParentMenu(miPlay, miVolume, 15);
  SetParentMenu(miPlay, miAudioStreams, 16);
  for i := pmAudioStreams.Items.Count - 1 downto 0 do
    SetParentMenu(miAudioStreams, pmAudioStreams.Items[i], 0);
end;

procedure TfrmCinemaPlayer.ptbSpeedChange(Sender: TObject);
begin
  if MyCinema.Rate <> 0 then
  begin
    MyCinema.Rate := ptbSpeed.Position / 10;
    aPlaySlower.Enabled := ptbSpeed.Position > 1;
    aPlayFaster.Enabled := ptbSpeed.Position < 20;
  end;
end;

procedure TfrmCinemaPlayer.ptbSpeedMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    aPlayNormal.Execute;
end;

procedure TfrmCinemaPlayer.DoPlaylistResize;
begin
  PlaylistBox.Height := MyCinema.Height;
  PlaylistSplitter.Height := MyCinema.Height;
  if config.PlaylistToLeft then
  begin
    PlaylistBox.Left := 0;
    PlaylistSplitter.Left := PlaylistBox.Width;
  end
  else
  begin
    PlaylistBox.Left := MyCinema.Width - PlaylistBox.Width;
    PlaylistSplitter.Left := PlaylistBox.Left - 3;
  end;

{  tempRect := PlaylistBox.BoundsRect;
  if config.PlaylistToLeft then
  begin
    OffsetRect(tempRect, -(MyCinema.Width - PlaylistBox.Width), 0);
    PlaylistSplitter.Left := PlaylistBox.Width;
  end
  else
  begin
    OffsetRect(tempRect, MyCinema.Width - PlaylistBox.Width, 0);
    PlaylistSplitter.Left := PlaylistBox.Left - 3;
  end;
  PlaylistBox.BoundsRect := tempRect;}
end;

procedure TfrmCinemaPlayer.aMinimizeExecute(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TfrmCinemaPlayer.WMShowWindow(var Msg: TWMShowWindow);
var
  Pdm: ^_devicemode;
  Tryb: TDeviceMode;
begin
  with Msg do
    case Status of
      SW_PARENTCLOSING:
      begin
        if config.PauseWhenMinimized then
        begin
          if OldPlayState then
            PSSnapshot := cpPlaying
          else
            PSSnapshot := MyCinema.PlayState;
          OldPlayState := false;
          if (MyCinema.VideoSize.cx > 0) and (PSSnapshot = cpPlaying) then
          begin
            aPause.Execute;
          end;
        end;
        frame_manager.set_hold_coords(true);
        if ChangeResolution.FullScreen then
        begin
          if ChangeResolution.ResChanged then
          begin
            Pdm := nil;
            MyShowCursor(true);
            ChangeDisplaySettings(Pdm^, 0);
          end;
          if config.HideTaskBar then
            ShowWindow(TrayHandle, SW_SHOW);
        end;
      end;
      SW_PARENTOPENING:
      begin
        if config.PauseWhenMinimized then
        begin
          if (MyCinema.VideoSize.cx > 0) and (PSSnapshot = cpPlaying) then
            aPlay.Execute;
        end;
        if ChangeResolution.FullScreen then
        begin
          if config.HideTaskBar then
            ShowWindow(TrayHandle, SW_HIDE);

          if ChangeResolution.ResChanged then
          begin
            Tryb := FindResolution;
            ChangeDisplaySettings(Tryb, CDS_FULLSCREEN);
          end;
          BoundsRect := Rect(0, 0, Self.Monitor.Width, Self.Monitor.Height);
        end;
        frame_manager.set_hold_coords(false);
      end;
    end;
  inherited;
end;

procedure TfrmCinemaPlayer.aPlaylistToLeftExecute(Sender: TObject);
begin
  aPlaylistToLeft.Checked := not aPlaylistToLeft.Checked;
  config.PlaylistToLeft := aPlaylistToLeft.Checked;
  DoPlaylistResize;
end;

procedure TfrmCinemaPlayer.aReloadExecute(Sender: TObject);
var
  pos: double;
  nazwa: widestring;
//  ps: TCPPlayState;
begin
  pos := MyCinema.CurrentPosition;
  nazwa := MyCinema.FileName;
//  ps := MyCinema.PlayState;
  MyCinema.Close;
  _speaker.flush();
  MyCinema.Open(nazwa, pos);
//  if ps = cpPlaying then
//    MyCinema.Play;
end;

procedure TfrmCinemaPlayer.miSetAudioStreamClick(Sender: TObject);
var
  i: integer;
begin
  if (Sender as TMenuItem).Checked then
    exit;
  if MyCinema.SelectAudioStream((Sender as TMenuItem).MenuIndex) then
  begin
    for i := 0 to (Sender as TMenuItem).Parent.Count - 1 do
      (Sender as TMenuItem).Parent[i].Checked := false;
    (Sender as TMenuItem).Checked := true;
  end;
end;

procedure TfrmCinemaPlayer.BuildFilterlistMenu;
begin
  freeSubMenus(miCodecsProps, 0);

  MyCinema.EnumFiltersNames(EnumFunc);
  miCodecsProps.Enabled := miCodecsProps.Count > 0;
end;

procedure TfrmCinemaPlayer.ActionListExecute(Action: TBasicAction;
  var Handled: Boolean);
const
  sOnOff: array[boolean] of integer = (LNG_ON, LNG_OFF);
var
  info: string;
begin
  if (Action.Tag <> 0) and (Action is TAction) and (Action <> aSetAspectRatio) then
  begin
    info := (Action as TAction).Caption;
    if Action.Tag = 2 then
      info := info + ' - ' + LangStor[sOnOff[(Action as TAction).Checked]];
//    Caption := Action.Name + info;
    osd_viewer.render(info);
  end;
end;

procedure TfrmCinemaPlayer.aIncSubtitlesSizeExecute(Sender: TObject);
begin
  inc(config.SubtitlesAttr.Style.fd.size);
  subtitle_viewer.set_font_size(config.SubtitlesAttr.Style.fd.size);
  resize_window;
  ShowSampleSubtitle;
end;

procedure TfrmCinemaPlayer.aDecSubtitlesSizeExecute(Sender: TObject);
begin
  if config.SubtitlesAttr.Style.fd.size > 8 then
  begin
    dec(config.SubtitlesAttr.Style.fd.size);
    subtitle_viewer.set_font_size(config.SubtitlesAttr.Style.fd.size);
    resize_window;
    ShowSampleSubtitle;
  end;
end;

procedure TfrmCinemaPlayer.aMoveSubtitlesUpExecute(Sender: TObject);
begin
  if (config.EdgeSpace < 80) {and (config.EdgeSpace >= 0)} and
     (config.SubtitlesAttr.RenderMode <> rmFullRect) then
  begin
    inc(config.EdgeSpace);
    subtitle_viewer.set_v_margin(config.EdgeSpace);
    ShowSampleSubtitle;
  end;
end;

procedure TfrmCinemaPlayer.aMoveSubtitlesDownExecute(Sender: TObject);
begin
  if (config.EdgeSpace > 0) and
     (config.SubtitlesAttr.RenderMode <> rmFullRect) then
  begin
    dec(config.EdgeSpace);
    subtitle_viewer.set_v_margin(config.EdgeSpace);
    ShowSampleSubtitle;
  end;
end;

procedure TfrmCinemaPlayer.ChangeVideoPosition(cvp: TChangeVideoPositionSet;
  CustomAspectRatio: boolean);
const
  cvp_step = 2;
var
  rc: TRect;
begin
  if MyCinema.FileName = '' then exit;
  rc := MyCinema.GetVideoPos;
  rc.TopLeft := MyCinema.ScreenToClient(rc.TopLeft);
  rc.BottomRight := MyCinema.ScreenToClient(rc.BottomRight);

  if (cvpDecreaseLeft in cvp) then
    dec(rc.Left, cvp_step);

  if (cvpDecreaseRight in cvp) then
    if (MyCinema.VideoWidth > 100) then dec(rc.Right, cvp_step);

  if (cvpDecreaseTop in cvp) then
    dec(rc.Top, cvp_step);

  if (cvpDecreaseBottom in cvp) then
    if (MyCinema.VideoHeight > 100) then dec(rc.Bottom, cvp_step);

  if (cvpIncreaseLeft in cvp) then
    if (MyCinema.VideoWidth > 100) then inc(rc.Left, cvp_step);

  if (cvpIncreaseRight in cvp) then
    inc(rc.Right, cvp_step);

  if (cvpIncreaseTop in cvp) then
    if (MyCinema.VideoHeight > 100) then inc(rc.Top, cvp_step);

  if (cvpIncreaseBottom in cvp) then
    inc(rc.Bottom, cvp_step);

  if (cvpDecreaseSize in cvp) then
    if (MyCinema.VideoWidth > 100) and (MyCinema.VideoHeight > 100) then
      InflateRect(rc, -round(cvp_step * frame_manager.get_aspect_value), -cvp_step);

  if (cvpIncreaseSize in cvp) then
    if (MyCinema.VideoWidth > 100) and (MyCinema.VideoHeight > 100) then
      InflateRect(rc, round(cvp_step * frame_manager.get_aspect_value), cvp_step);

  if (cvpCenterPos in cvp) then
    OffsetRect(rc,
      (MyCinema.ClientWidth - (MyCinema.VideoWidth)) div 2 - rc.Left,
      (MyCinema.ClientHeight - (MyCinema.VideoHeight)) div 2 - rc.Top);

  if (cvpFitToWindow in cvp) then
    rc := MyCinema.ClientRect;

{
  if (cvpNextAspectRatio in cvp) then
  begin
    frame_manager.next_aspect_ratio();
    rc := MyCinema.ClientRect;
  end;
}

  if CustomAspectRatio then
    frame_manager.set_aspect_ratio(arCustom);
  frame_manager.change_video_pos(@rc, not CustomAspectRatio);
  VideoRectChanged;
end;

procedure TfrmCinemaPlayer.WMRemote(var Msg: TMessage);
begin
  case Msg.WParam of
    $8000: tbPlayPause.Action.Execute;
    $8001: aPlay.Execute;
    $8002: aPause.Execute;
    $8003: aStop.Execute;
    $8004: aBack.Execute;
    $8005: aStep.Execute;
    $8006: aLargeBack.Execute;
    $8007: aLargeStep.Execute;
    $8008: aPlayPrev.Execute;
    $8009: aPlayNext.Execute;
    $800a: aPlaySlower.Execute;
    $800b: aPlayFaster.Execute;
    $800c: aPlayNormal.Execute;

    $800d: aFullScreen.Execute;
//    $8022: //PanScan aOpenDir.Execute;
    $800e: aFixedFullScreen.Execute;
    $800f: aRetToWin.Execute;

    $8010: aExit.Execute;
    $8011: Application.Minimize;
    $8012:
    begin
      Application.BringToFront;
      Application.Restore;
    end;

    $8013: aVolumeUp.Execute;
    $8014: aVolumeDown.Execute;
    $8015: aMute.Execute;

    $8016: aPlaylist.Execute;
    $8017: aOpenFiles.Execute;
    $8018: aOpenText.Execute;
    $8019: aOpenDir.Execute;

    $801a: aIncSubtitlesSize.Execute;
    $801b: aDecSubtitlesSize.Execute;
    $801c: aHideText.Execute;
    $801d: aMoveSubtitlesUp.Execute;
    $801e: aMoveSubtitlesDown.Execute;
    $801f: aSubtitleTimeBack.Execute;
    $8020: aSubtitleTimeForward.Execute;
    $8021: aSubtitleTimeReset.Execute;

    $8023: aNextAspectRatio.Execute;
    $8024: aDecVideoSizeY.Execute;
    $8025: aIncVideoSizeY.Execute;
    $8026: aDecVideoSizeX.Execute;
    $8027: aIncVideoSizeX.Execute;
    $8028: aDecVideoSize.Execute;
    $8029: aIncVideoSize.Execute;

    $802a:
      if MyCinema.PlayState = cpPlaying then
        aPlaySlower.Execute
      else
        aBack.Execute;
    $802b:
      if MyCinema.PlayState = cpPlaying then
        aPlayFaster.Execute
      else
        aStep.Execute;
    $802c:
      if MyCinema.PlayState = cpPlaying then
        aPlayNormal.Execute
      else
        aPlay.Execute;
    $802d: aShutDown.Execute;
    $802e: aCurrentTimeOnOSD.Execute;

    $802f: aMoveVideoLeft.Execute;
    $8030: aMoveVideoRight.Execute;
    $8031: aMoveVideoUp.Execute;
    $8032: aMoveVideoDown.Execute;
    $8033: aMoveVideoLeftUp.Execute;
    $8034: aMoveVideoRightUp.Execute;
    $8035: aMoveVideoLeftDown.Execute;
    $8036: aMoveVideoRightDown.Execute;
    $8037: aCenterVideoPos.Execute;
    $8038: aFitToWindow.Execute;

    $8039..$8042:
    begin
      aSetBookmark.Tag := Msg.WParam - $8038;
      aSetBookmark.Execute;
    end;
    $8043..$804c:
    begin
      aGotoBookmark.Tag := Msg.WParam - $8042;
      aGotoBookmark.Execute;
    end;
    $804d: aSpeaker.Execute;
  end;
end;

procedure TfrmCinemaPlayer.pmAudioStreamsPopup(Sender: TObject);
var
  i: integer;
begin
  for i := miAudioStreams.Count - 1 downto 0 do
    SetParentMenu(pmAudioStreams.Items, miAudioStreams[i], 0);
end;

procedure TfrmCinemaPlayer.AppActivate(Sender: TObject);
begin
  ActivateRemoteController;
end;

procedure TfrmCinemaPlayer.aCurrentTimeOnOSDExecute(Sender: TObject);
begin
  if MyCinema.FileName <> '' then
  begin
//    osdPanel.DisplayOSD(lCurrTime.Caption + ' ' + lTopTime.Caption + ' [' + TimeToStr(Time) + ']');
    osd_viewer.render(control_panel.getStatus(cpsCurrTime) + ' ' + control_panel.getStatus(cpsTopTime) + ' [' + TimeToStr(Time) + ']');
  end;
end;

procedure TfrmCinemaPlayer.aDecVideoSizeExecute(Sender: TObject);
begin
  ChangeVideoPosition([cvpDecreaseSize], false);
end;

procedure TfrmCinemaPlayer.aIncVideoSizeExecute(Sender: TObject);
begin
  ChangeVideoPosition([cvpIncreaseSize], false);
end;

procedure TfrmCinemaPlayer.aDecVideoSizeXExecute(Sender: TObject);
begin
  ChangeVideoPosition([cvpIncreaseLeft, cvpDecreaseRight], true);
end;

procedure TfrmCinemaPlayer.aIncVideoSizeXExecute(Sender: TObject);
begin
  ChangeVideoPosition([cvpDecreaseLeft, cvpIncreaseRight], true);
end;

procedure TfrmCinemaPlayer.aDecVideoSizeYExecute(Sender: TObject);
begin
  ChangeVideoPosition([cvpIncreaseTop, cvpDecreaseBottom], true);
end;

procedure TfrmCinemaPlayer.aIncVideoSizeYExecute(Sender: TObject);
begin
  ChangeVideoPosition([cvpDecreaseTop, cvpIncreaseBottom], true);
end;

procedure TfrmCinemaPlayer.aMoveVideoLeftExecute(Sender: TObject);
begin
  ChangeVideoPosition([cvpDecreaseLeft, cvpDecreaseRight], false);
end;

procedure TfrmCinemaPlayer.aMoveVideoRightExecute(Sender: TObject);
begin
  ChangeVideoPosition([cvpIncreaseLeft, cvpIncreaseRight], false);
end;

procedure TfrmCinemaPlayer.aMoveVideoUpExecute(Sender: TObject);
begin
  ChangeVideoPosition([cvpDecreaseTop, cvpDecreaseBottom], false);
end;

procedure TfrmCinemaPlayer.aMoveVideoDownExecute(Sender: TObject);
begin
  ChangeVideoPosition([cvpIncreaseTop, cvpIncreaseBottom], false);
end;

procedure TfrmCinemaPlayer.aMoveVideoLeftUpExecute(Sender: TObject);
begin
  ChangeVideoPosition([cvpDecreaseLeft, cvpDecreaseRight, cvpDecreaseTop, cvpDecreaseBottom], false);
end;

procedure TfrmCinemaPlayer.aMoveVideoRightUpExecute(Sender: TObject);
begin
  ChangeVideoPosition([cvpIncreaseLeft, cvpIncreaseRight, cvpDecreaseTop, cvpDecreaseBottom], false);
end;

procedure TfrmCinemaPlayer.aMoveVideoLeftDownExecute(Sender: TObject);
begin
  ChangeVideoPosition([cvpDecreaseLeft, cvpDecreaseRight, cvpIncreaseTop, cvpIncreaseBottom], false);
end;

procedure TfrmCinemaPlayer.aMoveVideoRightDownExecute(Sender: TObject);
begin
  ChangeVideoPosition([cvpIncreaseLeft, cvpIncreaseRight, cvpIncreaseTop, cvpIncreaseBottom], false);
end;

procedure TfrmCinemaPlayer.aCenterVideoPosExecute(Sender: TObject);
begin
  ChangeVideoPosition([cvpCenterPos], false);
end;

procedure TfrmCinemaPlayer.aFitToWindowExecute(Sender: TObject);
begin
  ChangeVideoPosition([cvpFitToWindow], false);
end;

procedure TfrmCinemaPlayer.DisableNumpadShortcuts;
begin
  aNextAspectRatio.ShortCut := 0;
  aDecVideoSize.ShortCut := 0;
  aIncVideoSize.ShortCut := 0;
  aDecVideoSizeX.ShortCut := 0;
  aDecVideoSizeY.ShortCut := 0;
  aIncVideoSizeX.ShortCut := 0;
  aIncVideoSizeY.ShortCut := 0;
  aMoveVideoLeft.ShortCut := 0;
  aMoveVideoRight.ShortCut := 0;
  aMoveVideoUp.ShortCut := 0;
  aMoveVideoDown.ShortCut := 0;
  aMoveVideoLeftUp.ShortCut := 0;
  aMoveVideoRightUp.ShortCut := 0;
  aMoveVideoLeftDown.ShortCut := 0;
  aMoveVideoRightDown.ShortCut := 0;
  aCenterVideoPos.ShortCut := 0;
  aFitToWindow.ShortCut := 0;
end;

procedure TfrmCinemaPlayer.EnableNumpadShortcuts;
begin
  aNextAspectRatio.ShortCut := ShortCut(VK_DECIMAL, []);
  aDecVideoSize.ShortCut := ShortCut(VK_SUBTRACT, []);
  aIncVideoSize.ShortCut := ShortCut(VK_ADD, []);
  aDecVideoSizeX.ShortCut := ShortCut(VK_NUMPAD4, [ssCtrl]);
  aDecVideoSizeY.ShortCut := ShortCut(VK_NUMPAD2, [ssCtrl]);
  aIncVideoSizeX.ShortCut := ShortCut(VK_NUMPAD6, [ssCtrl]);
  aIncVideoSizeY.ShortCut := ShortCut(VK_NUMPAD8, [ssCtrl]);
  aMoveVideoLeft.ShortCut := ShortCut(VK_NUMPAD4, []);
  aMoveVideoRight.ShortCut := ShortCut(VK_NUMPAD6, []);
  aMoveVideoUp.ShortCut := ShortCut(VK_NUMPAD8, []);
  aMoveVideoDown.ShortCut := ShortCut(VK_NUMPAD2, []);
  aMoveVideoLeftUp.ShortCut := ShortCut(VK_NUMPAD7, []);
  aMoveVideoRightUp.ShortCut := ShortCut(VK_NUMPAD9, []);
  aMoveVideoLeftDown.ShortCut := ShortCut(VK_NUMPAD1, []);
  aMoveVideoRightDown.ShortCut := ShortCut(VK_NUMPAD3, []);
  aCenterVideoPos.ShortCut := ShortCut(VK_NUMPAD5, []);
  aFitToWindow.ShortCut := ShortCut(VK_NUMPAD0, []);
end;

procedure TfrmCinemaPlayer.AppDeactivate(Sender: TObject);
begin
  if aStayOnTop.Checked then
    SetWindowPos( Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
end;

procedure TfrmCinemaPlayer.aMoveOSDUpExecute(Sender: TObject);
begin
  if (config.osd_y_margin > 0) then
  begin
    dec(config.osd_y_margin);
//    osdPanel.Top := MyCinema.Height * config.OSDPositon div 100;
//TODO    osdPanel.Test;
    osd_viewer.set_v_margin(config.osd_y_margin);
  end;
end;

procedure TfrmCinemaPlayer.aMoveOSDDownExecute(Sender: TObject);
begin
  if (config.osd_y_margin < 50) then
  begin
    inc(config.osd_y_margin);
//    osdPanel.Top := MyCinema.Height * config.OSDPositon div 100;
//TODO    osdPanel.Test;
    osd_viewer.set_v_margin(config.osd_y_margin);
  end;
end;

procedure TfrmCinemaPlayer.ShowSampleSubtitle;
begin
  if (subtitle_viewer.get_text = '') and (MyCinema.FileName = '') then
    subtitle_viewer.render(LangStor[LNG_OPT_SAMPLETEXT]);
  SampleSubVisibled := true;
  ReRenderSubtitle;
  SetTimer(Handle, timerClearSubtitle, 1500, nil);
end;

procedure TfrmCinemaPlayer.aSubTimeSettsClick(Sender: TObject);
begin
  aSubTimeSetts.Checked := not aSubTimeSetts.Checked;
  if aSubTimeSetts.Checked then
    CreateCalcTimeConfig
  else
    DestroyCalcTimeConfig;
end;

procedure TfrmCinemaPlayer.ptbPositionMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  change_pos_in_progress := true;
end;

procedure TfrmCinemaPlayer.ptbPositionMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  change_pos_in_progress := false;
end;

function TfrmCinemaPlayer.InsertCD: boolean;
begin
  MyCinema.Stop;
  MyCinema.Close;
  aClose.Execute;
  OpenCDDoor;
  Result := DisplayQuestion(LangStor[LNG_MSG_NEXTCD]);
  CloseCDDoor;
//  if not Result then
end;

procedure TfrmCinemaPlayer.MyCinemaBeforeClose(Sender: TObject);
begin
  with LastMovieState do
  begin
    file_name := ExtractFileName(MyCinema.FileName);
    subtitle_name := ExtractFileName(subtitles.FileName);
    aspect_ratio := frame_manager.get_aspect_ratio;
    video_rect := MyCinema.GetVideoPos;
    display_size := frame_manager.get_display_size;
    zoom := frame_manager.get_zoom;
    center_point := frame_manager.get_center_point;
    audio_stream := MyCinema.CurrentAudioStream;
    is_part_prev_movie := false;
  end;
end;

procedure TfrmCinemaPlayer.aSetBookmarkExecute(Sender: TObject);
begin
  if MyCinema.FileName = '' then
    exit;
  config.Bookmarks[aSetBookmark.Tag].FileName := MyCinema.FileName;
  config.Bookmarks[aSetBookmark.Tag].Position := MyCinema.CurrentPosition;
  RebuildBookmarks;
end;

procedure TfrmCinemaPlayer.aGotoBookmarkExecute(Sender: TObject);
var
  i, indeks: integer;
  jest_na_liscie: boolean;
begin
  with PlaylistBox do
  begin
//    aDelAll.Execute;
    jest_na_liscie := false;
    indeks := -1;
    for i := 0 to PlaylistBox.Items.Count - 1 do
      if AnsiCompareText(PItemData(PlaylistBox.Items.Objects[i]).Path, config.Bookmarks[aGotoBookmark.Tag].FileName) = 0 then
      begin
        jest_na_liscie := true;
        indeks := i;
        break;
      end;
    if not jest_na_liscie then
    begin
      AddPlayItem(config.Bookmarks[aGotoBookmark.Tag].FileName);
//      RefreshCount;
      indeks := PlaylistBox.Items.Count - 1;
    end;

    PlaylistBox.ChargeItem(indeks, config.Autoplay, config.Bookmarks[aGotoBookmark.Tag].Position);
  end;
end;

procedure TfrmCinemaPlayer.VideoRectChanged;
var
  r: TRect;
  lock_ok: boolean;
begin
  r := MyCinema.GetVideoPos;
  MapWindowPoints(HWND_DESKTOP, MyCinema.Handle, r, 2);
  lock_ok := true;
  if Assigned(subtitle_viewer) then
    lock_ok := subtitle_viewer.set_video_rect(r);
  if lock_ok then
    if Assigned(osd_viewer) then
      lock_ok := osd_viewer.set_video_rect(r);
  if not lock_ok then
    SetTimer(Handle, timerRefreshVideoRect, 100, nil);
end;

procedure TfrmCinemaPlayer.ptbPositionMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  MyCinema.SendToBack;
end;

procedure TfrmCinemaPlayer.WMSize(var Msg: TWMSize);
begin
{$ifdef _debug}
//  _debug('WM_SIZE begin');
{$endif}
  resize_window;
  inherited;
{$ifdef _debug}
//  _debug('WM_SIZE end');
{$endif}
end;

procedure TfrmCinemaPlayer.resize_window;
var
  rc, r: TRect;
begin
//  if not (csDestroying in ComponentState) then
  if not ((csDestroying in ComponentState) or (csLoading in ComponentState)) then
  begin
    rc := GetClientRect;
    r := rc;
    SetSize(pnlMain.Handle, rc);

    if ChangeResolution.FullScreen then
    begin
      if config.PanelOnTop then
        rc.Bottom := control_panel.getHeight
      else
        rc.Top := rc.Bottom - control_panel.getHeight;
    end
    else
    begin
      dec(r.Bottom, control_panel.getHeight);
      rc.Top := r.Bottom;
    end;


    if config.SubtitlesAttr.RenderMode = rmFullRect then
      dec(r.Bottom, subtitle_viewer.get_fixed_size * config.SubtitleRows);

    SetSize(MyCinema.Handle, r);
    SetSize(pnlControl.Handle, rc);

    DoPlaylistResize;
  end;
end;

procedure TfrmCinemaPlayer.WMMove(var Msg: TWMMove);
begin
  VideoRectChanged;
end;

procedure TfrmCinemaPlayer.osd_viewerEndUpdate;
begin
  config.osd_x_margin := osd_viewer.get_h_margin;
  config.osd_y_margin := osd_viewer.get_v_margin;
end;

procedure TfrmCinemaPlayer.aAboutExecute(Sender: TObject);
var
  aos: TStringArray;
  i: integer;
begin
  SetLength(aos, languages_list.count());
  for i := 0 to languages_list.count() - 1 do
    aos[i] := languages_list[i].name + #9 + languages_list[i].author;

  showAbout(Handle, @aos);
end;

procedure TfrmCinemaPlayer.AppMessage(var Msg: TMsg; var Handled: Boolean);
var
  bCloseCalcTime: boolean;
///  bCloseCorrector: boolean;
begin
  Handled :=
    isCalcTimeConfigMsg(Msg, bCloseCalcTime) or
    isTimeCorrectorMsg(Msg);

  if bCloseCalcTime then
    aSubTimeSetts.Execute;

//  if bCloseCorrector then
//    frmEditor.aTimeCorrector.Execute;
end;

procedure TfrmCinemaPlayer.apply_options();
var
  MovieSize: TPoint;
  tmp_sub_style_: TSubtitlesStyle;
begin
  MovieSize.x := MyCinema.VideoWidth;
  MovieSize.y := MyCinema.VideoHeight;
  if _old_fps <> config.DefaultFPS then
  begin
    _old_fps := config.DefaultFPS;
    Subtitles.ReloadFile;
  end;

  if MyCinema.CurrentAudioRenderer <> config.AudioRenderer then
  begin
    MyCinema.CurrentAudioRenderer := config.AudioRenderer;
    MyCinema.SelectAudioStream(MyCinema.CurrentAudioStream);
  end;


  if config.SpeakerEnabled or (aSpeaker.Checked <> config.SpeakerEnabled) then
  begin
    aSpeaker.Checked := not config.SpeakerEnabled;
    aSpeaker.Tag := 0;
    aSpeaker.Execute;
    aSpeaker.Tag := 2;
  end;

  tmp_sub_style_ := config.SubtitlesAttr.Style;
  Subtitles.default_style.get_whole_style(tmp_sub_style_);
  subtitle_viewer.set_adjust_pos(config.AdjustTextPos);
  subtitle_viewer.set_fixed_rows(config.SubtitleRows);
  subtitle_viewer.set_h_margin(config.EdgeSpace);
  subtitle_viewer.set_v_margin(config.EdgeSpace);
  subtitle_viewer.set_max_sub_options(config.MaxSubWidthActive, config.MaxSubWidthPercent);
  subtitle_viewer.set_max_sub_width(config.MaxSubWidth);
  subtitle_viewer.set_use_overlay(config.SubtitlesAttr.Overlay);
  subtitle_viewer.set_attributes(
    tmp_sub_style_,
    config.SubtitlesAttr.RenderMode,
    config.SubtitlesAttr.AntiAliasing);
  if not (aHideText.Checked or (config.SpeakerEnabled and config.SpeakerHideSubtitles)) then
    subtitle_viewer.enable
  else
    subtitle_viewer.disable;

  osd_viewer.set_v_margin(config.osd_y_margin);
  osd_viewer.set_h_margin(config.osd_x_margin);
  osd_viewer.set_max_sub_options(config.MaxSubWidthActive, config.MaxSubWidthPercent);
  osd_viewer.set_max_sub_width(config.MaxSubWidth);
  osd_viewer.set_use_overlay(config.OSDAttr.Overlay);
  osd_viewer.set_attributes(
    config.OSDAttr.Style,
    config.OSDAttr.RenderMode,
    config.OSDAttr.AntiAliasing);
  osd_viewer.set_display_time(config.OSDDisplayTime * 1000);
  if config.OSDEnabled then
    osd_viewer.enable
  else
    osd_viewer.disable;

//TODO ustawic wyglad panelu kontrolnego na pelnym ekranie jesli zmieniono opcje

  if (MovieSize.x > 0) and not (ChangeResolution.FullScreen or (Self.WindowState = wsMaximized)) then
    ChangeSize(MovieSize.x, MovieSize.y);
  ReRenderSubtitle;
  if ChangeResolution.FullScreen then
    resize_window;
  if control_panel <> nil then
    control_panel.calculate;
end;

procedure TfrmCinemaPlayer.pnlControlResize(Sender: TObject);
begin
  if control_panel <> nil then
    control_panel.calculate;
end;

procedure TfrmCinemaPlayer.aEnableScreenShotExecute(Sender: TObject);
begin
  aEnableScreenShot.Checked := not aEnableScreenShot.Checked;
  MyCinema.EnableScreenShot := aEnableScreenShot.Checked;
  aScreenShot.Enabled := aEnableScreenShot.Checked and (MyCinema.FileName <> '');
  aReload.Execute;
end;

{$IFDEF GRABBER}
procedure TfrmCinemaPlayer.aScreenShotExecute(Sender: TObject);
var
  tempBMP: TBitmap;
  s, mydoc: string;
  i: integer;
  path: array[0..MAX_PATH - 1] of char;
begin
  if not aEnableScreenShot.Checked then
    exit;
  tempBMP := TBitmap.Create;
  try
    if MyCinema.ScreenShot(tempBMP) then
    begin
      mydoc := config.ScreenShotFolder;
      if mydoc = '' then
      begin
        SHGetSpecialFolderPath(Handle, path, CSIDL_PERSONAL, false);
        mydoc := path;
      end;

      s := ExtractFileName(MyCinema.FileName);
      i := LastDelimiter('.\:', s);
      if (i > 0) and (s[i] = '.') then
        s := Copy(s, 1, i - 1);
      s := NormalizeDir(mydoc) + s;
      ForceDirectories(s);

      tempBMP.SaveToFile(s + '\' + PrepareTime(MyCinema.CurrentPosition, true, 3, '_', '_') + '.bmp');
    end;
  finally
    tempBMP.Free;
  end;
end;
{$ENDIF}

procedure TfrmCinemaPlayer.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_SNAPSHOT:
      if aScreenShot.Enabled then
      begin
        aScreenShot.Execute;
        Key := 0;
      end;
    VK_VOLUME_MUTE:
      aMute.Execute;
    VK_VOLUME_DOWN:
      aVolumeDown.Execute;
    VK_VOLUME_UP:
      aVolumeUp.Execute;
    VK_MEDIA_NEXT_TRACK:
      aPlayNext.Execute;
    VK_MEDIA_PREV_TRACK:
      aPlayPrev.Execute;
    VK_MEDIA_STOP:
      aStop.Execute;
    VK_MEDIA_PLAY_PAUSE:
      tbPlayPause.Action.Execute;
  else
    exit;
  end;
  Key := 0;
end;

procedure TfrmCinemaPlayer.aSpeakerExecute(Sender: TObject);
begin
  aSpeaker.Checked := not aSpeaker.Checked;
  if aSpeaker.Checked then
  begin
    config.SpeakerEnabled := true;
    _speaker.initialise();
    if not _speaker.changeVoice(config.SpeakerSelected, config.SpeakerVolume, config.SpeakerRate) then
      aSpeaker.Execute;
    _speaker.setVolume(config.SpeakerVolume);
    _speaker.setRate(config.SpeakerRate);
    _speaker.setFlushBeforeSpeak(config.SpeakerFlushPrevPhrase);
  end
  else
  begin
    config.SpeakerEnabled := false;
    _speaker.deinitialise();
  end;

  if aSpeaker.Tag <> 0 then
    if config.SpeakerEnabled or (aSpeaker.Checked <> config.SpeakerEnabled) then
    begin
      aHideText.Checked := not aHideText.Checked;
      aHideText.Tag := 0;
      aHideText.Execute;
      aHideText.Tag := 2;
    end;
end;

procedure TfrmCinemaPlayer.aDonateExecute(Sender: TObject);
begin
  showDonate(Handle);
end;

procedure TfrmCinemaPlayer.runStreamAfterLoadingSubtitles(
  isFaultless: boolean);
begin
  if config.StopOnError and (not isFaultless) then
  begin
    aPause.Execute;
    SetTimer(Handle, timerShowEditor, 1000, nil);
  end
  else
  begin
    if config.Autoplay and (MyCinema.PlayState <> cpPlaying) then
    begin
      aPlay.Execute;
    end;
  end;
end;

procedure TfrmCinemaPlayer.loadSubtitles(const szFileName: string;
  bWarnIfError: boolean; bAlwaysLoadFile: boolean);
var
  tmp_sub_style_: TSubtitlesStyle;
  isFaultless: boolean;
begin
  subtitle_viewer.Clear;
  isFaultless := false;
  if config.LoadSubtitles or bAlwaysLoadFile then
  begin
    Subtitles.LoadFromFile(szFileName, isFaultless);
  end
  else
    subtitle_viewer.clear;
  runStreamAfterLoadingSubtitles(isFaultless);
  if bWarnIfError and (Subtitles.Count = 0) then
  begin
    DisplayError(LangStor[LNG_MSG_BADSUBTITLES]);
  end;
// DONE pozycja napisów na ekranie (czy jest dobrze ustawina)
  tmp_sub_style_ := config.SubtitlesAttr.Style;
  Subtitles.default_style.get_whole_style(tmp_sub_style_);
  subtitle_viewer.set_attributes(
    tmp_sub_style_,
    config.SubtitlesAttr.RenderMode,
    config.SubtitlesAttr.AntiAliasing);
  subtitle_viewer.enable;
end;

procedure TfrmCinemaPlayer.miHomepageClick(Sender: TObject);
begin
  gotoWWW(Handle, szWWW + szURL);
end;

procedure TfrmCinemaPlayer.aShortcutsExecute(Sender: TObject);
begin
  showShortcuts(Handle);
end;

procedure TfrmCinemaPlayer.miForumClick(Sender: TObject);
begin
  gotoWWW(Handle, szForum + szURL);
end;

function TfrmCinemaPlayer.findSubtitles(const strMediaFile: string;
  var strSubtitleFile: string): boolean;

  function exaclyFileExists(var strSubtitle: string): boolean;
  var
    sl: TStringList;
    i: integer;
  begin
    Result := false;
    sl := TStringList.Create;
    try
      sl.Text := PlaylistBox.SubtitleExt;
      for i := 0 to sl.Count - 1 do
      begin
        strSubtitle := ChangeFileExt(strSubtitle, '.' + sl[i]);
        if FileExists(strSubtitle) then
        begin
          Result := true;
          exit;
        end;
      end;
    finally
      sl.Free;
    end;
  end;

  procedure collectFiles(const slFilesList: TStringList;
    out slResult: TStringList; const strExtMask: string);
  var
    sl: TStringList;
    i: integer;
    strExt: string;
  begin
    sl := TStringList.Create;
    try
      sl.Text := strExtMask;
      for i := 0 to slFilesList.Count - 1 do
      begin
        strExt := ExtractFileExt(slFilesList[i]);
        if (strExt <> '') then
        begin
          Delete(strExt, 1, 1);
          if (sl.IndexOf(AnsiUpperCase(strExt)) <> -1) then
            slResult.Add(slFilesList[i]);
        end;
      end;
    finally
      sl.Free;
    end;
  end;

  type
    PBoolean = ^boolean;

  procedure findMostMatching(const slList: TStringList; const strPattern: string;
    var slResult: TStringList; var nMatchRate: integer; bWeakResult: PBoolean);
  var
    strSource: string;
    strTemp: string;
    i: integer;
    nMatch: integer;
  begin
    strSource := ExtractFileNameWithoutExt(strPattern);
    nMatchRate := MaxInt;
    slResult.Clear;
    for i := slList.Count - 1 downto 0 do
    begin
      strTemp := ExtractFileNameWithoutExt(slList[i]);
      nMatch := calcEditDistance(strSource, strTemp);
      if (nMatch <= nMatchRate) then
      begin
        if (nMatch < nMatchRate) then
          slResult.Clear;
        slResult.Add(slList[i]);
        slList.Delete(i);
        nMatchRate := nMatch;
        if (bWeakResult <> nil) then
          bWeakResult^ :=
            (nMatch <> abs(Length(strSource) - Length(strTemp))) and
            (nMatch / max(Length(strSource), Length(strTemp)) >= 0.5);
      end;
    end;
  end;

var
  sr: TSearchRec;
  sl: TStringList;
  slMedia: TStringList;
  slSubtitles: TStringList;
  nMatchRate: integer;
  nTmpMatchRate: integer;
  i: integer;
  bIsFileTypeCountEqual: boolean;
  bWeakResult: boolean;
  strTemp: string;
begin
  Result := false;

  if LastMovieState.is_part_prev_movie and (LastMovieState.subtitle_name <> '') then
  begin
    strSubtitleFile := ExtractFilePath(strMediaFile) + LastMovieState.subtitle_name;
    if FindNextPart(strSubtitleFile, false) and exaclyFileExists(strSubtitleFile) then
    begin
      Result := true;
      exit;
    end;
  end;

  strSubtitleFile := strMediaFile;
  if exaclyFileExists(strSubtitleFile) then
  begin
    Result := true;
    exit;
  end
  else
    if config.SearchingOutOfSubtitles = soosExact then
    begin
      strSubtitleFile := '';
      exit;
    end;

  strSubtitleFile := '';

  sl := TStringList.Create;
  try
    if FindFirst(NormalizeDir(ExtractFilePath(strMediaFile)) + '*.*', faDirectory, sr) = 0 then
    begin
      repeat
        if (sr.Name <> '.') and (sr.Name <> '..') and ((sr.Attr and faDirectory) = 0) then
          sl.Add(sr.FindData.cFileName);
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;

    slMedia := TStringList.Create;
    slSubtitles := TStringList.Create;
    try
      collectFiles(sl, slMedia, PlaylistBox.MovieExt);
      collectFiles(sl, slSubtitles, PlaylistBox.SubtitleExt);

      if (slMedia.Count = 1) and (slSubtitles.Count = 1) then
      begin
        Result := true;
        strSubtitleFile := ExtractFilePath(strMediaFile) + slSubtitles[0];
        exit;
      end;

      bIsFileTypeCountEqual := slMedia.Count = slSubtitles.Count;

      findMostMatching(slSubtitles, strMediaFile, sl, nMatchRate, @bWeakResult);
      if (sl.Count = 0) then
        exit;

      slSubtitles.Clear();
      strTemp := AnsiLowerCase(ExtractFileNameWithoutExt(strMediaFile));
      for i := 0 to slMedia.Count - 1 do
      begin
        if AnsiLowerCase(ExtractFileNameWithoutExt(slMedia[i])) = strTemp then
          continue;
        findMostMatching(sl, slMedia[i], slSubtitles, nTmpMatchRate, nil);
        if (nTmpMatchRate >= nMatchRate) then
          sl.AddStrings(slSubtitles)
        else
          slSubtitles.Clear;

        if sl.Count = 0 then
          break;
      end;

      if (slSubtitles.Count = 1) and (not bWeakResult {or bIsFileTypeCountEqual}) then
      begin
        Result := true;
        strSubtitleFile := ExtractFilePath(strMediaFile) + slSubtitles[0];
        exit;
      end;

      if (slSubtitles.Count > 0) and
         not (bWeakResult and (config.SearchingOutOfSubtitles < soosUnlike)) then
      begin
        if selectSubtitleFile(Handle, slSubtitles, strSubtitleFile) then
        begin
          Result := true;
          strSubtitleFile := ExtractFilePath(strMediaFile) + strSubtitleFile;
        end;
      end;
    finally
      if not Result then
        strSubtitleFile := '';
      slMedia.Free;
      slSubtitles.Free;
    end;
  finally
    sl.Free;
  end;
end;

procedure TfrmCinemaPlayer.aClearBookmarkExecute(Sender: TObject);
var
  i: integer;
begin
  for i := 1 to 10 do
  begin
    config.Bookmarks[i].FileName := '';
    config.Bookmarks[i].Position := 0;
  end;
  RebuildBookmarks;
end;

procedure TfrmCinemaPlayer.freeSubMenus(miParent: TMenuItem; nLeaveCount: integer);
begin
  while miParent.Count > nLeaveCount do
    miParent.Items[0].Free;
end;

end.
