unit cp_CinemaEngine;

interface

uses
  cp_DirectShow, Windows, Messages, Classes, Controls, SysUtils, ActiveX,
  Graphics, Consts, cp_graphics;

type
  TEnumFilterNamesFunc = procedure(const filterName: PChar;
    hasPropertyPage: boolean) of object;
  TEnumFilterFunc = function(const pFilter: IBaseFilter): boolean of object;

  TCPPlayState =
  (
    cpStopped,
    cpPaused,
    cpPlaying,
    cpWaiting,
    cpScanForward,
    cpScanReverse,
    cpClosed
  );

  TCPReadyState =
  (
    cpReadyStateUninitialized,
    cpReadyStateLoading,
    cpReadyStateInteractive,
    cpReadyStateComplete
  );

  TCPDisplayMode =
  (
    cpTime,
    cpFrames
  );

  TPlayStateChange = procedure(PlayState: TCPPlayState) of object;
  TReadyStateChange = procedure(ReadyState: TCPReadyState) of object;

  TVolumeRange = -10000..0;

  TAudioStream = class(TObject)
    name: string;
    streamNo: integer;
    langID: LCID;
    //isAC3: boolean;
  end;

  TAudioRenderer = class(TObject)
    name: string;
    CLSID: TGUID;
  end;

/// Klasa Cinema
  TCinema = class(TCustomControl)
  private
    pGraphBuilder: IGraphBuilder;
    pMediaControl: IMediaControl;
    pMediaSeeking: IMediaSeeking;
    pAudioControl: IBasicAudio;
    pVideoControl: IBasicVideo2;
    pVideoWindow: IVideoWindow;
    pStreamSelect: IAMStreamSelect;
{$IFDEF GRABBER}
    pMediaEvent: IMediaEvent;
//    InPutPin  : IPin;
//    OutPutPin : IPin;
    pBaseFilter: IBaseFilter;
    pSampleGrabber: ISampleGrabber;
    FEnableScreenShot: boolean;
{$ENDIF}
    FFileName: WideString;
    FMute: boolean;
    FPlayState: TCPPlayState;
    FVolume: TVolumeRange;

    FPlayStateChange: TPlayStateChange;
    FReadyStateChange: TReadyStateChange;

    CoInitializeResult: HResult;

    FBeforeClose: TNotifyEvent;

    FAudioStreams: TList;
    FAudioRenderers: TList;

//    FFullScreen: boolean;
//    FCanResize: boolean;
//    FLengthInFrame: string;
//    FTotalTime: string;

//    HoldVideoZoom: double;
//    HoldCenterPoint: TCenterPoint;

{$IFDEF OVERLAY}
    OverlayColorDetected: boolean;
    OverlayColorDetectionCounter: byte;
    OverlayColor: COLORREF;
{$ENDIF}
    FCurrentAudioStream: integer;

    FSeekToKeyFrame: cardinal;

    _enumFiltersNamesFunc: TEnumFilterNamesFunc;
    FCurrentAudioRenderer: integer;

    function GetCurrentPosition: double;
    function GetDisplayMode: TCPDisplayMode;
    function GetDuration: double;
    function GetRate: double;
    function GetVideoSize: TSize;
    function GetVideoHeight: integer;
    function GetVideoWidth: integer;
    function GetVolume: TVolumeRange;
    procedure SetCurrentPosition(ACurrentPosition: double);
    procedure SetCurrentPositionFirstTime(ACurrentPosition: double);
    procedure SetDisplayMode(ADisplayMode: TCPDisplayMode);
//    procedure SetFullScreen(const Value: boolean);
    procedure SetMute(AMute: boolean);
    procedure SetPlayState(APlayState: TCPPlayState);
    procedure SetRate(ARate: double);
    procedure SetVideoVisible(AVisible: boolean);
    procedure SetVolume(AVolume: TVolumeRange);

    function Initialize: HRESULT;
    procedure DoPlayStateChange;
    procedure DoReadyStateChange(AReadyState: TCPReadyState);
    procedure DoBeforeClose;
//    procedure SetCanResize(const Value: boolean);
    function GetFPS: double;
    function GetCurrentFPS: double;
    procedure EnumAudioStreams;
    function GetAudioStream(Index: Integer): TAudioStream;
    function GetAudioStreamsCount: integer;
    function GetFilter(name_: WideString; out pFilter: IBaseFilter): boolean;
    function GetFilterAfterPin(const pPin: IPin; out pFilter: IBaseFilter): boolean;
    function GetFilterAfterFilter(const pFilter: IBaseFilter; out pFilter2: IBaseFilter): boolean;
    procedure EnumFilters(const EnumFunc: TEnumFilterFunc);
//    function CheckTrackInfoFunc(const pFilter: IBaseFilter): boolean;
    function CheckStreamSelectFunc(const pFilter: IBaseFilter): boolean;
    function GetFilterNamesFunc(const pFilter: IBaseFilter): boolean;
    procedure getCat(catlist: TList; CatGUID: TGUID);
    procedure clearObjectList(var list: TList);
    function GetAudioRenderer(Index: Integer): TAudioRenderer;
    function GetAudioRenderersCount: integer;
//    procedure Paint(); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
//    procedure ChangeSize(const NewSize: TRect; KeepAspect: boolean);
    procedure Close;//(EndOfFile: boolean = false);
    procedure EnumFiltersNames(EnumFunc: TEnumFilterNamesFunc);
{$IFDEF OVERLAY}
    function GetOverlayColorKey(var color_key: COLORREF): boolean;
{$ENDIF}
    function IsVideo: boolean;
    function IsSound: boolean;
    procedure Open(const FileName: WideString; StartPos: double = 0.0);
    procedure Play;
    procedure Pause;
    procedure Stop;
    procedure ShowStatistic;
    procedure ShowCursor(const CanShow: LongBool);
    function GetVideoPos: TRect;
    procedure SetVideoPos(const Value: TRect);
//    procedure ReconnectFilters;
{$IFDEF GRABBER}
    function ScreenShot(Bitmap: TBitmap): boolean;
{$ENDIF}
    function IsCursorVisibled: LongBool;
    function DisplayFilterProperties(ParentWnd: integer; FilterName: string): boolean;
    function SelectAudioStream(item: integer): boolean;
    property AudioRenderersCount: integer read GetAudioRenderersCount;
    property AudioRenderers[Index: Integer]: TAudioRenderer read GetAudioRenderer;
    property CurrentAudioRenderer: integer read FCurrentAudioRenderer write FCurrentAudioRenderer;
    property AudioStreamsCount: integer read GetAudioStreamsCount;
    property AudioStreams[Index: Integer]: TAudioStream read GetAudioStream;
    property CurrentAudioStream: integer read FCurrentAudioStream;
//    property CanResize: boolean read FCanResize write SetCanResize;
    property CurrentPosition: double read GetCurrentPosition write SetCurrentPosition;
    property DisplayMode: TCPDisplayMode read GetDisplayMode write SetDisplayMode;
    property Duration: double read GetDuration;
    property FileName: WideString read FFileName;
    property FPS: double read GetFPS;
    property CurrentFPS: double read GetCurrentFPS;
//    property FullScreen: boolean read FFullScreen write SetFullScreen;
    property Mute: boolean read FMute write SetMute;
    property PlayState: TCPPlayState read FPlayState write SetPlayState;
    property Rate: double read GetRate write SetRate;
    property VideoSize: TSize read GetVideoSize;
    property VideoHeight: integer read GetVideoHeight;// write SetHeight;
    property VideoWidth: integer read GetVideoWidth;// write SetWidth;
    property VideoVisible: boolean write SetVideoVisible;
    property Volume: TVolumeRange read GetVolume write SetVolume;
{$IFDEF GRABBER}
    property EnableScreenShot: boolean read FEnableScreenShot write FEnableScreenShot;
{$ENDIF}
//    property LengthInFrame: string read FLengthInFrame;
//    property TotalTime: string read FTotalTime;
  published
    property Align;
    property Color;
    property PopupMenu;
    property TabStop;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnClick;
    property OnDblClick;
    property OnResize;
    property OnPlayStateChange: TPlayStateChange read FPlayStateChange write FPlayStateChange;
    property OnReadyStateChange: TReadyStateChange read FReadyStateChange write FReadyStateChange;
    property OnBeforeClose: TNotifyEvent read FBeforeClose write FBeforeClose;
  end;

{$IFDEF GRABBER}
const
  GrabberFilterName              = 'SampleGrabber';
{$ENDIF}

implementation

uses
  global_consts;

const
  OutOfMemory                    = 'Out of memory!';
  AVI_Splitter: WideString       = 'AVI Splitter';
  

{ TCinema }

{function StringToGUID(const S: string): TGUID;
begin
  CLSIDFromString(PWideChar(WideString(S)), Result);
end;

function GUIDToString(const ClassID: TGUID): string;
var
  P: PWideChar;
begin
  StringFromCLSID(ClassID, P);
  Result := P;
  CoTaskMemFree(P);
end;
}
procedure FreeMediaType(mt: PAM_MEDIA_TYPE);
begin
  if (mt^.cbFormat <> 0) then
  begin
    CoTaskMemFree(mt^.pbFormat);
    // Strictly unnecessary but tidier
    mt^.cbFormat := 0;
    mt^.pbFormat := nil;
  end;
  if (mt^.pUnk <> nil) then mt^.pUnk := nil;
end;


function TCinema.GetFilterNamesFunc(const pFilter: IBaseFilter): boolean;
const
  fn_len: integer = 127;
var
  pSpecify: ISpecifyPropertyPages;
//  has_property_page: boolean;
  filter_name: string;

  FilterInfo: TFilterInfo;
begin
  if pFilter.QueryFilterInfo(FilterInfo) = S_OK then
  begin
    SetLength(filter_name, fn_len);
    WideCharToMultiByte(CP_ACP, 0, @FilterInfo.achName, -1, @filter_name[1], fn_len, nil, nil);
{$IFDEF GRABBER}
    if filter_name <> GrabberFilterName then
    begin
{$ENDIF}
      if Assigned(_enumFiltersNamesFunc) then
        _enumFiltersNamesFunc(PChar(filter_name), pFilter.QueryInterface(ISpecifyPropertyPages, pSpecify) = S_OK);
      pSpecify := nil;
{$IFDEF GRABBER}
    end;
{$ENDIF}
    FilterInfo.pGraph := nil;
  end;
  Result := true;
end;

function TCinema.CheckStreamSelectFunc(const pFilter: IBaseFilter): boolean;
begin
// break search if interface was found
  Result := pFilter.QueryInterface(IID_IAMStreamSelect, pStreamSelect) <> S_OK;
end;

procedure TCinema.Close;//(EndOfFile: boolean);
begin
{  if EndOfFile then
  begin
    if not (FPlayState in [cpStopped, cpClosed]) and Assigned(pMediaControl) then
    begin
      PlayState := cpClosed;
      pMediaControl.Stop;
      if Assigned(pMediaControl) then pMediaControl.Stop;
    end;
  end
  else}
  if CoInitializeResult in [S_OK, S_FALSE] then
  begin
    if FFileName <> '' then
      DoBeforeClose;

    if Assigned(pMediaControl) then
      pMediaControl.Stop;

    clearObjectList(FAudioStreams);
    DoReadyStateChange(cpReadyStateUninitialized);

    PlayState := cpClosed;

    if not IsCursorVisibled then
    begin
      Windows.ShowCursor(true);
      ShowCursor(true);
    end;

{$IFDEF GRABBER}
    if Assigned(pSampleGrabber) then
    begin
      pSampleGrabber := nil;
    end;

    if Assigned(pBaseFilter) then
      pBaseFilter := nil;

//      if Assigned(InPutPin) then
//        InPutPin := nil;

//      if Assigned(OutPutPin) then
//        OutPutPin := nil;
    if Assigned(pMediaEvent) then
      pMediaEvent := nil;
{$ENDIF}

    if Assigned(pVideoWindow) then
    begin
      with pVideoWindow do
      begin
        put_Visible(false);
        put_Owner(0);
      end;
      pVideoWindow := nil;
    end;

    if Assigned(pStreamSelect) then
      pStreamSelect := nil;

    if Assigned(pVideoControl) then
      pVideoControl := nil;

    if Assigned(pAudioControl) then
      pAudioControl := nil;

    if Assigned(pMediaSeeking) then
      pMediaSeeking := nil;

    if Assigned(pMediaControl) then
      pMediaControl := nil;

    if Assigned(pGraphBuilder) then
      pGraphBuilder := nil;

    FFileName := '';
  end;
end;

constructor TCinema.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FAudioStreams := TList.Create;
  FAudioRenderers := TList.Create;
  getCat(FAudioRenderers, CLSID_AudioRendererCategory);
  ControlStyle := [csReplicatable, csAcceptsControls, csClickEvents, csDoubleClicks];
  Width := 100;
  Height := 100;
  CoInitializeResult := CoInitialize(nil);
  PlayState := cpClosed;
  DisplayMode := cpTime;
//  FCanResize := true;
end;

destructor TCinema.Destroy;
begin
//  Close(false);
  clearObjectList(FAudioStreams);
  FAudioStreams.Free;
  clearObjectList(FAudioRenderers);
  FAudioRenderers.Free;
  CoUninitialize;
  inherited Destroy;
end;

function TCinema.DisplayFilterProperties(ParentWnd: integer;
  FilterName: string): boolean;
var
  pEnum: IEnumFilters;
  pFilter: IBaseFilter;
  pSpecify: ISpecifyPropertyPages;
  FilterInfo: TFilterInfo;
  caGUID: TCAGUID;
  pcFetched: longint;
  StopEnum: boolean;
  fName: string;
begin
  Result := false;

  if (FilterName <> '') and Assigned(pGraphBuilder) then
    if pGraphBuilder.EnumFilters(pEnum) = S_OK then
    begin
      StopEnum := false;

      while not StopEnum and (pEnum.Next(1, pFilter, @pcFetched) = S_OK) do
      begin
        if pFilter.QueryInterface(ISpecifyPropertyPages, pSpecify) = S_OK then
        begin
          if pFilter.QueryFilterInfo(FilterInfo) = S_OK then
          begin
            pcFetched := 64;
            SetLength(fName, pcFetched);
            WideCharToMultiByte(CP_ACP, 0, @FilterInfo.achName, -1, @fName[1], pcFetched, nil, nil);
            if PChar(fName) = FilterName then
            begin
              if pSpecify.GetPages(caGUID) = S_OK then
              begin
                Result := OleCreatePropertyFrame(ParentWnd, 0, 0, FilterInfo.achName, 1, @pFilter, caGUID.cElems, caGUID.pElems, 0, 0, nil) = S_OK;
                CoTaskMemFree(caGUID.pElems);
              end;
              StopEnum := true;
            end;
            FilterInfo.pGraph := nil;
          end;
          pSpecify := nil;
        end;
        pFilter := nil;
      end;
      pEnum := nil;
    end;
end;

procedure TCinema.EnumFilters(const EnumFunc: TEnumFilterFunc);
var
  pEnum: IEnumFilters;
  pFilter: IBaseFilter;
  ContinueEnum: boolean;
begin
  if Assigned(EnumFunc) and Assigned(pGraphBuilder) then
    if pGraphBuilder.EnumFilters(pEnum) = S_OK then
    begin
      ContinueEnum := true;
      while ContinueEnum and (pEnum.Next(1, pFilter, nil) = S_OK) do
      begin
        ContinueEnum := EnumFunc(pFilter);
        pFilter := nil;
      end;
      pEnum := nil;
    end;
end;

{function TCinema.GetAspectRatio: TPoint;
var
  x, y: integer;
begin
  Result.x := -1;
  Result.y := -1;

  if IsVideo and Assigned(pVideoControl) then
  begin
    pVideoControl.GetPreferredAspectRatio(x, y);
    Result.x := x;
    Result.y := y;
  end;
end;}

function TCinema.GetCurrentPosition: double;
var
  temp: Int64;
begin
  if Assigned(pMediaSeeking) then
  begin
    pMediaSeeking.GetCurrentPosition(temp);
    Result := temp / ONE_SECOND;
  end
  else
    Result := -1;
end;

function TCinema.GetDisplayMode: TCPDisplayMode;
var
  temp: TGUID;
begin
  if Assigned(pMediaSeeking) then
    pMediaSeeking.GetTimeFormat(temp);
  if temp.D1 = TIME_FORMAT_MEDIA_TIME.D1 then
    Result := cpTime
  else
    Result := cpFrames;
end;

{function TCinema.GetDisplaySize: TCPDisplaySize;
begin
// not yet implemented
end;}

function TCinema.GetDuration: double;
var
  temp: Int64;
begin
  if Assigned(pMediaSeeking) then
  begin
    pMediaSeeking.GetDuration(temp);
    if DisplayMode = cpTime then
      Result := temp / ONE_SECOND
    else
      Result := temp;
  end
  else
    Result := 0.0;
end;

function TCinema.GetVideoHeight: integer;
var
  r: TRect;
begin
  r := GetVideoPos;
  Result := r.Bottom - r.Top;
end;

function TCinema.GetRate: double;
begin
  if Assigned(pMediaSeeking) then
    pMediaSeeking.GetRate(Result);
end;

function TCinema.GetVideoSize: TSize;
begin
  if IsVideo and Assigned(pVideoControl) then
    pVideoControl.GetVideoSize(Result.cx, Result.cy)
  else
  begin
    Result.cx := -1;
    Result.cy := -1;
  end;
end;

function TCinema.GetVolume: TVolumeRange;
var
  tempVolume: integer;
begin
  if ISSound and Assigned(pAudioControl) and not Mute then
  begin
    pAudioControl.get_Volume(tempVolume);
    Result := tempVolume;
  end
  else
    Result := FVolume;
end;

function TCinema.GetVideoWidth: integer;
var
  r: TRect;
begin
  r := GetVideoPos;
  Result := r.Right - r.Left;
end;

function TCinema.Initialize: HRESULT;
{$IFDEF GRABBER}
var
  dc: HDC;
  iBitDepth: integer;
  mt: TAM_Media_Type;
//  EnumPins: IEnumPins;
{$ENDIF}
begin
  if CoInitializeResult in [S_OK, S_FALSE] then
  begin
    Result := CoCreateInstance(CLSID_FilterGraph, nil, CLSCTX_INPROC, IID_IGraphBuilder, pGraphBuilder);
    if Result = S_OK then
      with pGraphBuilder do
      begin
        QueryInterface(IID_IMediaControl, pMediaControl);
        QueryInterface(IID_IMediaSeeking, pMediaSeeking);
        QueryInterface(IID_IBasicAudio, pAudioControl);
        QueryInterface(IID_IBasicVideo2, pVideoControl);
        QueryInterface(IID_IVideoWindow, pVideoWindow);
{$IFDEF GRABBER}
        if FEnableScreenShot then
        begin
          QueryInterface(IID_IMediaEvent, pMediaEvent);

          if CoCreateInstance(CLSID_SampleGrabber, nil, CLSCTX_INPROC, IID_IBaseFilter, pBaseFilter) = S_OK then
          begin
            if pGraphBuilder.AddFilter(pBaseFilter, GrabberFilterName) = S_OK then
            begin
              if pBaseFilter.QueryInterface(IID_ISampleGrabber, pSampleGrabber) = S_OK then
              begin
                dc := GetDC(0);
                iBitDepth := GetDeviceCaps(dc, BITSPIXEL);
                ReleaseDC(0, dc);

                ZeroMemory(@mt, sizeof(mt));
                mt.majortype := MEDIATYPE_Video;
                case iBitDepth of
                  8:
                      mt.subtype := MEDIASUBTYPE_RGB8;
                  16:
                      mt.subtype := MEDIASUBTYPE_RGB555;
                  24:
                      mt.subtype := MEDIASUBTYPE_RGB24;
                  32:
                      mt.subtype := MEDIASUBTYPE_RGB32;
                end;
{
                with mt do
                begin
                  majortype := MEDIATYPE_Video;
                  subtype := MEDIASUBTYPE_RGB32;
                end;
}
                pSampleGrabber.SetMediaType(mt);
              end;
            end;
          end;
        end;
{$ENDIF}
      end;
  end
  else
    Result := E_UNEXPECTED;
end;

function TCinema.IsSound: boolean;
var
  tmpVolume: integer;
begin
  Result := Assigned(pAudioControl) and (pAudioControl.get_Volume(tmpVolume) <> E_NOTIMPL);
end;

function TCinema.IsVideo: boolean;
var
  tmpVisible: LongBool;
begin
  Result := Assigned(pVideoWindow) and (pVideoWindow.get_Visible(tmpVisible) <> E_NOINTERFACE);
end;

/// Wczytuje film
procedure TCinema.Open(
          const FileName: WideString;     ///< Œcie¿ka dostêpu do pliku z filmem
          StartPos: double                ///< Pocz¹tkowa pozycja odtwarzania
          );
var
  RenderFileResult{, HR}: HResult;
//  pAudioRender, pFilter: IBaseFilter;
  temp: string;


  function InitializeRenderer(IsAC3Sound: boolean): HRESULT;
  begin
    Close;//(false);
    Result := Initialize();
    if Result <> S_OK then
    begin
      if Result = E_OUTOFMEMORY then
        temp := ' - ' + OutOfMemory
      else
        temp := '!';
      raise EOutOfMemory.Create('COM not initialized' + temp);
    end
    else
      if Assigned(pGraphBuilder) then
      begin
        Result := pGraphBuilder.RenderFile(@FileName[1], nil);
      end;
  end;

begin
{$IFDEF OVERLAY}
//   OverlayColorDetected := false;
   OverlayColorDetectionCounter := 0;
{$ENDIF}

   RenderFileResult := InitializeRenderer(false);
   if Succeeded(RenderFileResult) then
   begin
     case RenderFileResult of
       S_OK, VFW_S_AUDIO_NOT_RENDERED, VFW_S_DUPLICATE_NAME, VFW_S_PARTIAL_RENDER:
       begin
         FFileName := FileName;
         Hide;
         if Assigned(pVideoWindow) then
         begin
           pVideoWindow.put_AutoShow(false);
           pVideoWindow.put_Owner(Self.Handle);
           pVideoWindow.put_MessageDrain(Self.Handle);
           PlayState := cpStopped;
           SetCurrentPositionFirstTime(StartPos);
           FFileName := FileName;
//             FTotalTime := PrepareTime(Duration, false);
           pVideoWindow.put_WindowStyle(WS_CHILD or WS_CLIPSIBLINGS or WS_CLIPCHILDREN);
//             AspectRatioMode := arOriginal;
//             sleep(500);
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//             ChangeVideoPosition;
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//             sleep(1000);

           EnumAudioStreams;
           DoReadyStateChange(cpReadyStateComplete);
         end;
         Show;
       end;
       E_OUTOFMEMORY:
         raise EOutOfMemory.Create('Can''t open file - ' + OutOfMemory);
       VFW_S_VIDEO_NOT_RENDERED:
         begin
           DoReadyStateChange(cpReadyStateComplete);
           PlayState := cpStopped;
           raise EOutOfMemory.Create('Unknown video stream format!'#13'Codec not found');
         end;
       else
         raise Exception.Create('Can''t open file - unknown error!');
     end;
   end;
end;

procedure TCinema.Pause;
begin
  if not (FPlayState in [cpPaused, cpClosed]) and Assigned(pMediaControl) then
  begin
    PlayState := cpPaused;
    pMediaControl.Pause;
  end;
end;

procedure TCinema.Play;
var
  SeekPos, pCurrent, pStop: Int64;
begin
  if not (FPlayState in [cpPlaying, cpClosed]) and Assigned(pMediaControl) then
  begin
    PlayState := cpPlaying;
    if Assigned(pMediaSeeking) then
      if pMediaSeeking.GetPositions(pCurrent, pStop) = S_OK then
        if pCurrent = pStop then
        begin
          SeekPos := 0;
          pMediaSeeking.SetPositions(SeekPos, AM_SEEKING_AbsolutePositioning, SeekPos, AM_SEEKING_NoPositioning);
        end;
    pMediaControl.Run;
  end;
end;

procedure TCinema.SetCurrentPosition(ACurrentPosition: double);
var
  temp: Int64;
begin
  if Assigned(pMediaSeeking) then
  begin
    temp := round(ACurrentPosition * ONE_SECOND);
    pMediaSeeking.SetPositions(temp, AM_SEEKING_AbsolutePositioning or FSeekToKeyFrame,
                               temp, AM_SEEKING_NoPositioning or FSeekToKeyFrame);
{    if Assigned(pMediaControl) then
    begin
      if (PlayState = cpPaused) then
        pMediaControl.Pause;
    end;}
  end;
end;

procedure TCinema.SetDisplayMode(ADisplayMode: TCPDisplayMode);
begin
  if Assigned(pMediaSeeking) then
    case ADisplayMode of
      cpTime:
        pMediaSeeking.SetTimeFormat(TIME_FORMAT_MEDIA_TIME);
      cpFrames:
        pMediaSeeking.SetTimeFormat(TIME_FORMAT_FRAME);
    end;
end;

procedure TCinema.SetMute(AMute: boolean);
begin
  if FMute <> AMute then
  begin
    if IsSound and Assigned(pAudioControl) then
    begin
      if AMute then
        pAudioControl.put_Volume(-10000)
      else
        pAudioControl.put_Volume(FVolume);
    end;
    FMute := AMute;
  end;
end;

procedure TCinema.SetPlayState(APlayState: TCPPlayState);
begin
  if FPlayState <> APlayState then
  begin
    FPlayState := APlayState;
    DoPlayStateChange;
  end;
end;

procedure TCinema.SetRate(ARate: double);
begin
  if Assigned(pMediaSeeking) then
    pMediaSeeking.SetRate(ARate);
end;

procedure TCinema.SetVideoVisible(AVisible: boolean);
var
  tmpVisible: LongBool;
//  l, t, w, h: integer;
begin
//  if FVisible <> AVisible then
    if Assigned(pVideoWindow) and
       (pVideoWindow.get_Visible(tmpVisible) <> E_NOINTERFACE) then
    begin
      if boolean(tmpVisible) <> AVisible then
        if AVisible then
        begin
//          pVideoWindow.get_Left(l);
//          pVideoWindow.get_Top(t);
//          pVideoWindow.pt_Width(Self.Width);
//          pVideoWindow.set_Height(Self.Height);
//          MessageBox(0,
//            PChar(Format('poka¿ video. uchwyt okna: %d'#13' l: %d; t: %d w: %d; h: %d', [Self.Handle, l, t, w, h])),
//            nil, mb_ok or mb_taskmodal);
          pVideoWindow.put_Owner(Self.Handle);
          pVideoWindow.put_MessageDrain(Self.Handle);
          pVideoWindow.put_Visible(AVisible);
        end
        else
        begin
          pVideoWindow.put_Visible(AVisible);
          pVideoWindow.put_MessageDrain(0);
          pVideoWindow.put_Owner(0);
        end;
    end;
end;

procedure TCinema.SetVolume(AVolume: TVolumeRange);
begin
  if ISSound and Assigned(pAudioControl) then
    if Mute then
      pAudioControl.put_Volume(-10000)
    else
      pAudioControl.put_Volume(AVolume);
  FVolume := AVolume;
end;

procedure TCinema.ShowCursor(const CanShow: LongBool);
begin
  if Assigned(pVideoWindow) then
    pVideoWindow.HideCursor(not CanShow);
end;

function TCinema.IsCursorVisibled: LongBool;
begin
  Result := true;
  if Assigned(pVideoWindow) then
  begin
    pVideoWindow.IsCursorHidden(Result);
    Result := not Result
  end;
end;

procedure TCinema.ShowStatistic;
begin
// not yet implemented
end;

procedure TCinema.Stop;
//var
//  SeekPos: Int64;
begin
  if not (FPlayState in [cpStopped, cpClosed]) and Assigned(pMediaControl) then
  begin
    CurrentPosition := 0;
{    if Assigned(pMediaSeeking) then
    begin
      SeekPos := 0;
      pMediaSeeking.SetPositions(SeekPos, AM_SEEKING_AbsolutePositioning, SeekPos, AM_SEEKING_NoPositioning);
    end;}
    sleep(50);
    pMediaControl.Stop;
    PlayState := cpStopped;
  end;
end;

(*procedure TCinema.ChangeSize(const NewSize: TRect; KeepAspect: boolean);
var
  NewViewSize: TRectSize;
  DestRect: tRect;
  TmpAspectRatio: double;
begin
  if IsVideo and (PlayState <> cpClosed) then
  begin
    with NewSize do
    begin
      NewViewSize.Width := Right - Left;
      NewViewSize.Height := Bottom - Top;
    end;

    if (not KeepAspect) and (AspectRatioMode = arCustom) then
        FAspectRatio := NewViewSize.Width / NewViewSize.Height;

    TmpAspectRatio := NewViewSize.Width / NewViewSize.Height;

    DestRect := NewSize;

    with DestRect do
    begin
      if KeepAspect then
      begin
        if TmpAspectRatio < AspectRatio then
          InflateRect(DestRect, 0, -round((NewViewSize.Height - (NewViewSize.Width / AspectRatio)) / 2))
        else
          if TmpAspectRatio > FAspectRatio then
            InflateRect(DestRect, -round((NewViewSize.Width - (NewViewSize.Height * AspectRatio)) / 2), 0);
      end;
{      else
        if VPAspectRatio < FAspectRatio then
          InflateRect(DestRect, 0, -round((ViewPortSize.Height - (ViewPortSize.Width / FAspectRatio)) / 2))
        else
          if VPAspectRatio > FAspectRatio then
            InflateRect(DestRect, -round((ViewPortSize.Width - (ViewPortSize.Height * FAspectRatio)) / 2), 0);

{           if Form1.PanScan1.checked then
        begin
          tmpReal[0] := right / 100;
          tmpReal[1] := bottom / 100;

          left := left - trunc((PanScanPercent / 2) * tmpReal[0]);
          top := top - trunc((PanScanPercent / 2) * tmpReal[1]);
          right := right + trunc(((PanScanPercent / 2) * tmpReal[0]) * 2);
          bottom := bottom + trunc(((PanScanPercent / 2) * tmpReal[1]) * 2);
        end;}

      pVideoWindow.SetWindowPosition(Left, Top, Right - Left, Bottom - Top);
    end;
  end;
end;*)

(*procedure TCinema.ReconnectFilters;
//procedure TCinema.FilterEnum(EnumFunc: TEnumFunc);
var
  pEnum: IEnumFilters;
  pFilter: IBaseFilter;
  pcFetched: longint;
  FilterInfo: TFilterInfo;
  StopEnum: boolean;

//  fName: string;
//  WCLen: integer;

  pEnumPins: IEnumPins;
  StopEnumPins: boolean;
  pPin: IPin;
  pcFetchedPin: longint;
begin
{  if Assigned(pGraphBuilder) then
    pGraphBuilder.FindFilterByName('Video Renderer', pFilter);
    if Assigned(pFilter) then
    begin
      if pFilter.QueryFilterInfo(FilterInfo) = S_OK then
      begin
        if pFilter.EnumPins(pEnumPins) = S_OK then
        begin
          StopEnumPins := false;
          while (pEnumPins.Next(1, pPin, cardinal(pcFetchedPin)) = S_OK) do
          begin
            StopEnum := not (pGraphBuilder.Reconnect(pPin) = S_OK);
          end;
          pEnumPins := nil;
        end;
      end;
      pFilter := nil;
//      pGraphBuilder.Reconnect;(pFilter);
//      pGraphBuilder.AddFilter(pFilter, nil);
//      pFilter := nil;
    end;}
    if pGraphBuilder.EnumFilters(pEnum) = S_OK then
    begin
      StopEnum := false;

      while not StopEnum and (pEnum.Next(1, pFilter, cardinal(pcFetched)) = S_OK) do
      begin
        if pFilter.QueryFilterInfo(FilterInfo) = S_OK then
        begin

//          WCLen := 64;
//          SetLength(fName, 64);
//          WideCharToMultiByte(CP_ACP, 0, @FilterInfo.achName, -1, @fName[1], WCLen, nil, nil);
//          FilterInfo.pGraph := nil;
//          if fName = 'Video Renderer' then
            if pFilter.EnumPins(pEnumPins) = S_OK then
            begin
              StopEnumPins := false;
              while (pEnumPins.Next(1, pPin, cardinal(pcFetchedPin)) = S_OK) do
              begin
                StopEnum := not (pGraphBuilder.Reconnect(pPin) = S_OK);
              end;
              pEnumPins := nil;
            end;
        end;
        pFilter := nil;
      end;
      pEnum := nil;
    end;
end;*)

{$IFDEF GRABBER}
function TCinema.ScreenShot(Bitmap: TBitmap): boolean;
const
  BitCounts: array [pf1Bit..pf32Bit] of Byte = (1,4,8,16,16,24,32);
var
  BMIHeader  : PBitmapInfoHeader;
  BufferSize,
  evCode     : longint;
  mt         : TAM_Media_Type;
  buffer     : pointer;
  BMPInfo    : PBitmapInfo;
  hr         : hresult;
  savePos    : Int64;

  count      : integer;
  serr       : string;
  pf         : TPixelFormat;
begin
  if not FEnableScreenShot then
    exit;
  serr := '';
  Result := false;
  pMediaControl.Stop;
  savePos := round(CurrentPosition * ONE_SECOND);
  pSampleGrabber.SetOneShot(true);
  pSampleGrabber.SetBufferSamples(true);
  pMediaControl.Run;
  count := 0;
  while (pMediaEvent.WaitForCompletion(100, evCode) <> S_OK) and {(evCode <> EC_COMPLETE) and }(count < 10) do
    inc(count);

//  if count = 9 then
//    messagebox(0, 'timeout!', nil, mb_ok);
  BufferSize := 0;
  hr := pSampleGrabber.GetCurrentBuffer(BufferSize, nil);
  if not Failed(hr) then
  begin
    try
      GetMem(buffer, BufferSize);
    except
      messagebox(0, PChar(OutOfMemory + '!'), nil, mb_ok);
      pSampleGrabber.SetBufferSamples(false);
      pSampleGrabber.SetOneShot(false);
      exit;
    end;
    hr := pSampleGrabber.GetCurrentBuffer(BufferSize, buffer);
    if not Failed(hr) then
    begin
      hr := pSampleGrabber.GetConnectedMediaType(mt);
      if not Failed(hr) then
      begin
        if IsEqualGUID(mt.majortype, MEDIATYPE_Video) then
        begin
          if IsEqualGUID(mt.formattype, FORMAT_VideoInfo) or IsEqualGUID(mt.formattype, FORMAT_VideoInfo2) then
          begin
            if IsEqualGUID(mt.formattype, FORMAT_VideoInfo) then
              BMIHeader := Addr(TVideoInfoHeader(mt.pbFormat^).bmiHeader)
            else
              BMIHeader := Addr(TVideoInfoHeader2(mt.pbFormat^).bmiHeader);

            Bitmap.Width := BMIHeader.biWidth;
            Bitmap.Height := BMIHeader.biHeight;

            if IsEqualGUID(mt.subtype, MEDIASUBTYPE_RGB8) then
              pf := pf8bit
            else
              if IsEqualGUID(mt.subtype, MEDIASUBTYPE_RGB555) then
                pf := pf15bit
              else
                if IsEqualGUID(mt.subtype, MEDIASUBTYPE_RGB555) then
                  pf := pf15bit
                else
                  if IsEqualGUID(mt.subtype, MEDIASUBTYPE_RGB565) then
                    pf := pf16bit
                  else
                    if IsEqualGUID(mt.subtype, MEDIASUBTYPE_RGB24) then
                      pf := pf24bit
                    else
                      pf := pf32bit;

            Bitmap.PixelFormat := pf;
            CopyMemory(
              Bitmap.ScanLine[Bitmap.Height - 1],
              buffer,
              (integer(Bitmap.ScanLine[Bitmap.Height - 2]) -
               integer(Bitmap.ScanLine[Bitmap.Height - 1])) * Bitmap.Height);
            pMediaControl.Stop;
            pMediaControl.Run;
          end
          else
            serr := 'Unsupported media type!';
        end
        else
          serr := 'Unsupported media type (majortype)!';

        FreeMediaType(@mt);
      end
      else
        serr := 'GetConnectedMediaType failed.'#13 + SysErrorMessage(hr) + ' [' + inttohex(hr, 8) + ']';

      FreeMem(buffer);
    end
    else
      serr := 'GetCurrentBuffer (get buffer failed).';
  end
  else
    serr := 'GetCurrentBuffer (get size failed).';

  if serr <> '' then
  begin
    if SUCCEEDED(hr) then
      hr := GetLastError();

    serr := serr + #13 + SysErrorMessage(hr) + ' [' + inttohex(hr, 8) + ']';
    MessageBox(0, PChar(serr), nil, MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
  end;
  pSampleGrabber.SetBufferSamples(false);
  pSampleGrabber.SetOneShot(false);

  Result := serr = '';
end;
{$ENDIF}

procedure TCinema.DoPlayStateChange;
begin
  if Assigned(FPlayStateChange) then
    FPlayStateChange(FPlayState);
end;

procedure TCinema.DoReadyStateChange(AReadyState: TCPReadyState);
begin
  if Assigned(OnReadyStateChange) then
    OnReadyStateChange(AReadyState);
end;

(*procedure TCinema.SetFullScreen(const Value: boolean);
begin
  FFullScreen := Value;
{$IFDEF DEBUG}
  WriteLog('SetFullScreen');
{$ENDIF}
  ChangeVideoPosition;
end;*)

{procedure TCinema.SetCanResize(const Value: boolean);
begin
  FCanResize := Value;
  if FCanResize then
    ChangeVideoPosition;
end;}

function TCinema.GetFPS: double;
var
  pFilter: IBaseFilter;
  pBasicVideo: IBasicVideo;
begin
  Result := 0;
  if GetFilter('Video Renderer', pFilter) then
  begin
    if pFilter.QueryInterface(IID_IBasicVideo, pBasicVideo) = S_OK then
    begin
      if (LowerCase(ExtractFileExt(FFileName)) <> '.rmvb') and
         (pBasicVideo.get_AvgTimePerFrame(Result) = S_OK) and (Result > 0) then
        Result := 1 / Result
      else
      begin
        Result := Duration;
        DisplayMode := cpFrames;
        Result := Duration / Result;
        DisplayMode := cpTime;
      end;
      pBasicVideo := nil;
    end;
    pFilter := nil;
  end;
end;

{$IFDEF OVERLAY}
function TCinema.GetOverlayColorKey(var color_key: COLORREF): boolean;
var
//  pFilter: IBaseFilter;
//  pPin: IPin;
//  pOverlay: IOverlay;
//  tempColorKey: TColorKey;
  tempColorKey: COLORREF;
//  EnumPins: IEnumPins;
  myDC: HDC;
  myRect: TRect;
  myPoint: TPoint;
begin
{  if OverlayColorDetectionCounter = 10 then
  begin
    Result := OverlayColorDetected;
    Color := OverlayColor;
    exit;
  end;
    }
  Result := false;
//  Color := 0;
{  if Assigned(pGraphBuilder) then
  begin
    if Succeeded(pGraphBuilder.FindFilterByName('Video Renderer', pFilter))
       and Assigned(pFilter) then
    begin
      pFilter.EnumPins(EnumPins);
      EnumPins.Next(1, pPin, nil);
      EnumPins := nil;

      if Assigned(pPin) and (pPin.QueryInterface(IID_IOverlay, pOverlay) = S_OK) then
      begin
        pOverlay.GetColorKey(tempColorKey);
        begin
          Color := tempColorKey.LowColorValue;
          Result := true;
          OverlayColor := Color;
          OverlayColorDetected := true;
        end;
        pOverlay := nil;
      end;
      pPin := nil;
      pFilter := nil;
    end;
  end;

  if (not Result) or (TRGBQuad(Color).rgbBlue > 20) or (TRGBQuad(Color).rgbGreen > 20) or
     (TRGBQuad(Color).rgbRed > 20) then
}  begin
//    myDC := CreateDC('DISPLAY', nil, nil, nil);
    myDC := GetDC(0);
//    beep;
    if myDC = 0 then exit;
    myRect := GetVideoPos;
//    myRect := ClientRect;
//    myPoint := ClientToScreen(Point(0, 0));
//    OffsetRect(myRect, myPoint.x, myPoint.y);
    tempColorKey := GetPixel(myDC, myRect.Left + 10, myRect.Top + 10);
//    SetWindowText(Parent.Parent.Handle, PChar(intToHex(tempColorKey, 8)));
    if (tempColorKey = GetPixel(myDC, myRect.Right - 10, myRect.Top + 10)) and
       (tempColorKey = GetPixel(myDC, myRect.Right - 10, myRect.Bottom - 10)) and
       (tempColorKey = GetPixel(myDC, myRect.Left + 10, myRect.Bottom - 10)) then
    begin
      if tempColorKey < $202020 then
      begin
//        TForm(Parent.Parent).caption :=
//        Color := tempColorKey;
        Result := true;
//        OverlayColor := tempColorKey;
//        OverlayColorDetected := true;
        color_key := tempColorKey
      end;
    end;
    DeleteDC(myDC);
  end;
//  inc(OverlayColorDetectionCounter);
end;
{$ENDIF}

function TCinema.GetFilter(name_: WideString;
  out pFilter: IBaseFilter): boolean;
begin
  Result := false;
  if Assigned(pGraphBuilder) then
    Result := pGraphBuilder.FindFilterByName(PWideChar(name_), pFilter) = S_OK;
end;

function TCinema.GetFilterAfterPin(const pPin: IPin;
  out pFilter: IBaseFilter): boolean;
var
  pPinInfo: TPin_Info;
  pPinIn: IPin;
  PinDir: TPin_Direction;
begin
  Result := false;
  if pPin.QueryDirection(PinDir) = S_OK then
  begin
    if PinDir = PINDIR_OUTPUT then
    begin
      if pPin.ConnectedTo(pPinIn) = S_OK then
      begin
        if pPinIn.QueryPinInfo(pPinInfo) = S_OK then
        begin
          pFilter := pPinInfo.pFilter;
          Result := pFilter <> nil;
          if Result then
          begin
            //pFilter._AddRef;
            pPinInfo.pFilter := nil;
          end;
        end;
        pPinIn := nil;
      end;
    end;
  end;
end;

function TCinema.GetFilterAfterFilter(const pFilter: IBaseFilter;
  out pFilter2: IBaseFilter): boolean;
var
  pEnumPins: IEnumPins;
  pPinOut: IPin;
  pPinIn: IPin;
  pPinInfo: TPin_Info;
  PinDir: TPin_Direction;
begin
  Result := false;
  if pFilter.EnumPins(pEnumPins) = S_OK then
  begin
    while (not Result) and (pEnumPins.Next(1, pPinOut, nil) = S_OK) do
    begin
      if pPinOut.QueryDirection(PinDir) = S_OK then
        if PinDir = PINDIR_OUTPUT then
        begin
          if pPinOut.ConnectedTo(pPinIn) = S_OK then
          begin
            if pPinIn.QueryPinInfo(pPinInfo) = S_OK then
            begin
              pFilter2 := pPinInfo.pFilter;
              pPinInfo.pFilter := nil;
              Result := true;
            end;
            pPinIn := nil;
          end;
        end;
      pPinOut := nil;
    end;
    pEnumPins := nil;
  end;
end;

procedure TCinema.EnumAudioStreams;

  function IsAC3Audio(const pPin: IPin): boolean;
  var
    pFilter: IBaseFilter;
    pPinOut: IPin;
//    pFilterInfo: TFilterInfo;
//    pPinInfo: TPin_Info;
    pEnumMediaTypes: IEnumMediaTypes;
    pEnumPins: IEnumPins;

    pmt: PAM_Media_Type;
    PinDir: TPin_Direction;

  begin
    Result := false;
    if GetFilterAfterPin(pPin, pFilter) then
    begin
      //pFilter.QueryFilterInfo(pFilterInfo);
      //pFilterInfo.pGraph := nil;
      //pPinOut := pPin;
      if pFilter.EnumPins(pEnumPins) = S_OK then
      begin
        while pEnumPins.Next(1, pPinOut, nil) = S_OK do
        begin
          if (pPinOut.QueryDirection(PinDir) = S_OK) and
             (PinDir = PINDIR_OUTPUT) and
             (pPinOut.EnumMediaTypes(pEnumMediaTypes) = S_OK) then
          begin
            if pEnumMediaTypes.Next(1, pmt, nil) = S_OK then
            begin
              if IsEqualGUID(pmt.subtype, MEDIASUBTYPE_DOLBY_AC3_SPDIF) or
                 IsEqualGUID(pmt.subtype, MEDIASUBTYPE_DOLBY_AC3) then
              begin
                Result := true;
              end;
              FreeMediaType(pmt);
              CoTaskMemFree(pmt);
            end;
            pEnumMediaTypes := nil;
          end;
          pPinOut := nil;
          if Result then
            break;
        end;
        pEnumPins := nil;
      end;
      pFilter := nil;
    end;
  end;

var
  pEnumPins: IEnumPins;
  pEnumMediaTypes: IEnumMediaTypes;
  pFilter: IBaseFilter;
  pPin: IPin;
  pmt: PAM_Media_Type;
  i: integer;


  count: DWORD;
  lang: LCID;
  pname: PWideChar;
begin
  if GetFilter(AVI_Splitter, pFilter) then
  begin
    i := 0;
    if pFilter.EnumPins(pEnumPins) = S_OK then
    begin
      while pEnumPins.Next(1, pPin, nil) = S_OK do
      begin
        if pPin.EnumMediaTypes(pEnumMediaTypes) = S_OK then
        begin
          if pEnumMediaTypes.Next(1, pmt, nil) = S_OK then
          begin
            if IsEqualGUID(pmt.majortype, MEDIATYPE_Audio) then
            with TAudioStream(FAudioStreams[FAudioStreams.Add(TAudioStream.Create())]) do
            begin
              streamNo := i;
              langID := $0000;
              name := '';
//                FAudioStreams[Length(FAudioStreams) - 1].isAC3 :=
//                  {IsEqualGUID(pmt.subtype, MEDIASUBTYPE_DOLBY_AC3_SPDIF) or
//                  IsEqualGUID(pmt.subtype, MEDIASUBTYPE_DOLBY_AC3);//}IsAC3Audio(pPin);
            end;
            FreeMediaType(pmt);
            CoTaskMemFree(pmt);
          end;
          pEnumMediaTypes := nil;
        end;
        inc(i);
        pPin := nil;
      end;
      pEnumPins := nil;
    end;
    pFilter := nil;
  end
  else
  begin
    EnumFilters(CheckStreamSelectFunc);
    if Assigned(pStreamSelect) then
    begin
      pStreamSelect.Count(count);
      for i := 0 to integer(count) - 1 do
      begin
        pStreamSelect.Info(i, @pmt, nil, lang, nil, pname, nil, nil);
        if IsEqualGUID(pmt.majortype, MEDIATYPE_Audio) then
          with TAudioStream(FAudioStreams[FAudioStreams.Add(TAudioStream.Create())]) do
          begin
            streamNo := i;
            langID := lang;
            name := pname;
            //isAC3 := true;
              //IsEqualGUID(pmt.subtype, MEDIASUBTYPE_DOLBY_AC3_SPDIF) or
              //IsEqualGUID(pmt.subtype, MEDIASUBTYPE_DOLBY_AC3);//IsAC3Audio(pPin);
          end;
        FreeMediaType(pmt);
        CoTaskMemFree(pmt);
        CoTaskMemFree(pname);
      end;
    end;
  end;
end;

function TCinema.SelectAudioStream(item: integer): boolean;

  procedure RemoveFiltersChain(const pBaseFilter: IBaseFilter);
  var
    pFilter, pFilter2: IBaseFilter;
  begin
    pFilter := pBaseFilter;
    if GetFilterAfterFilter(pFilter, pFilter2) then
    begin
      RemoveFiltersChain(pFilter2);
      //pFilter := nil;
      //pFilter := pFilter2;
      //pFilter._AddRef;
      pFilter2 := nil;
    end;
    pGraphBuilder.RemoveFilter(pFilter);
  end;

  function SetAudioOutput(const pPin: IPin): boolean;
  var
    pFilter: IBaseFilter;
    pFilter2: IBaseFilter;
    pPinInfo: TPin_Info;
    filter_info: TFilterInfo;

    pEnumPins: IEnumPins;
    pPin1, pPin2: IPin;

    s: WideString;
    i: integer;
  begin
    Result := true;
    if pPin.QueryPinInfo(pPinInfo) = S_OK then
    begin
      pFilter := pPinInfo.pFilter;
      //pFilter._AddRef;
      pPinInfo.pFilter := nil;

      while GetFilterAfterFilter(pFilter, pFilter2) do
      begin
        pFilter := nil;
        pFilter := pFilter2;
        pFilter._AddRef;
        //pFilter2 := nil;
      end;

      if pFilter.EnumPins(pEnumPins) = S_OK then
      begin
        if pEnumPins.Next(1, pPin1, nil) = S_OK then
        begin
          if (pPin1.ConnectedTo(pPin2) = S_OK) and (pPin2 <> nil) then
          begin
            pGraphBuilder.RemoveFilter(pFilter);
            pFilter := nil;

//            MessageBox(0, PChar('CLSID_AudioRender: ' + GUIDToString(CLSID_AudioRender)), nil, 0);
//            MessageBox(0, PChar('CLSID_DSoundRender: ' + GUIDToString(CLSID_DSoundRender)), nil, 0);
//            for i := 0 to FAudioRenderers.Count - 1 do
//            begin
//              MessageBox(0, PChar(AudioRenderers[i].name + ': ' + GUIDToString(AudioRenderers[i].CLSID)), nil, 0);
//            end;

            if (FCurrentAudioRenderer > 0) and
               (CoCreateInstance(AudioRenderers[FCurrentAudioRenderer - 1].CLSID, nil, CLSCTX_INPROC_SERVER, IID_IBaseFilter, pFilter) = S_OK) then
            begin
              s := AudioRenderers[FCurrentAudioRenderer - 1].name;
              //MessageBox(0, PChar(AudioRenderers[FCurrentAudioRenderer - 1].name), nil, 0);
              pGraphBuilder.AddFilter(pFilter, PWideChar(s));
            end;
            pGraphBuilder.Render(pPin2);
            pPin2 := nil;
          end;
          pPin1 := nil;
        end;
        pEnumPins := nil;
      end;
      pFilter := nil;
    end;
  end;

  function isAudioSteram(i: integer): boolean;
  var
    j: integer;
  begin
    for j := 0 to GetAudioStreamsCount - 1 do
      if (AudioStreams[j].streamNo = i) then
      begin
        Result := true;
        exit;
      end;

    Result := false;
  end;

var
  pEnumPins: IEnumPins;
  pFilter: IBaseFilter;
  pFilter2: IBaseFilter;
  pPinOut: IPin;
  pPinIn: IPin;

  i: integer;
begin
  Result := false;
  if item >= GetAudioStreamsCount then exit;

  i := 0;
  if Assigned(pStreamSelect) then
  begin
    pStreamSelect.Enable(AudioStreams[item].streamNo, AMSTREAMSELECTENABLE_ENABLE);
    FCurrentAudioStream := item;
    Result := true;
  end
  else
    if GetFilter(AVI_Splitter, pFilter) then
    begin
      pMediaControl.Stop;
      if pFilter.EnumPins(pEnumPins) = S_OK then
      begin
        while pEnumPins.Next(1, pPinOut, nil) = S_OK do
        begin
          if isAudioSteram(i) then
            if i = AudioStreams[item].streamNo then
            begin
              if pPinOut.ConnectedTo(pPinIn) = S_OK then
                Result := true
              else
              begin
                Result := pGraphBuilder.Render(pPinOut) = S_OK;
                pPinOut.ConnectedTo(pPinIn);
              end;


              if (pPinIn <> nil) {and (FAudioStreams[item].isAC3)} then
              begin
                SetAudioOutput(pPinIn);
              end;

              FCurrentAudioStream := item;

              pPinIn := nil;
            end
            else
            begin
              if GetFilterAfterPin(pPinOut, pFilter2) then
              begin
                RemoveFiltersChain(pFilter2);
                pFilter2 := nil;
              end;
            end;
          inc(i);
          pPinOut := nil;
        end;
        pEnumPins := nil;
      end;
      pFilter := nil;

      case PlayState of
        cpPaused: pMediaControl.Pause;
        cpPlaying: pMediaControl.Run;
      end;
    end;
end;

function TCinema.GetCurrentFPS: double;
var
  pFilter: IBaseFilter;
  pQualProp: IQualProp;
  frameRate: integer;
begin
  Result := 0;
  if GetFilter('Video Renderer', pFilter) then
  begin
    if pFilter.QueryInterface(IID_IQualProp, pQualProp) = S_OK then
    begin
      if pQualProp.get_AvgFrameRate(frameRate) = S_OK then
        Result := frameRate / 100;
      pQualProp := nil;
    end;
    pFilter := nil;
  end;
end;

function TCinema.GetAudioStream(Index: Integer): TAudioStream;
begin
  if Index >= FAudioStreams.Count then
    raise EListError.Create(Format(SListIndexError, [Index]));

  Result := TAudioStream(FAudioStreams[Index]);
end;

function TCinema.GetAudioStreamsCount: integer;
begin
  Result := FAudioStreams.Count;
end;

procedure TCinema.SetCurrentPositionFirstTime(ACurrentPosition: double);
var
  temp: Int64;
  hr: cardinal;
begin
  if Assigned(pMediaSeeking) then
  begin
    temp := round(ACurrentPosition * ONE_SECOND);
    FSeekToKeyFrame := AM_SEEKING_SeekToKeyFrame;
    hr := pMediaSeeking.SetPositions(temp, AM_SEEKING_AbsolutePositioning or FSeekToKeyFrame,
                               temp, AM_SEEKING_NoPositioning or FSeekToKeyFrame);
    if hr = E_INVALIDARG then
    begin
      FSeekToKeyFrame := 0;//AM_SEEKING_NoFlush;
      pMediaSeeking.GetCapabilities(hr);
//      SM(IntToHex(hr, 8));
//      if UpperCase(ExtractFileExt(FFileName)) <> '.OGG' then
        pMediaSeeking.SetPositions(temp, AM_SEEKING_AbsolutePositioning or FSeekToKeyFrame,
                                   temp, AM_SEEKING_NoPositioning or FSeekToKeyFrame);
    end;
  end;
end;

procedure TCinema.DoBeforeClose;
begin
  if Assigned(OnBeforeClose) then
    OnBeforeClose(Self);
end;

function TCinema.GetVideoPos: TRect;
begin
  if IsVideo then
    with Result do
    begin
      pVideoWindow.GetWindowPosition(Left, Top, Right, Bottom);
      inc(Right, Left);
      inc(Bottom, Top);
    end
  else
    SetRectEmpty(Result);
end;

procedure TCinema.SetVideoPos(const Value: TRect);
begin
  with Value do
    pVideoWindow.SetWindowPosition(Left, Top, Right - Left, Bottom - Top);
end;

procedure TCinema.EnumFiltersNames(EnumFunc: TEnumFilterNamesFunc);
begin
  _enumFiltersNamesFunc := EnumFunc;
  EnumFilters(GetFilterNamesFunc);
end;

procedure TCinema.getCat(catlist: TList; CatGUID: TGUID);
const
  IID_IPropertyBag          : TGUID = '{55272A00-42CB-11CE-8135-00AA004BB851}';
var
  pSysDevEnum: ICreateDevEnum;
  pEnumCat: IEnumMoniker;
  pMoniker: IMoniker;
  pPropBag: IPropertyBag;
  ole_name: OleVariant;
  s_name: string;
  i: integer;
  item: TAudioRenderer;
begin
  clearObjectList(catlist);

  CocreateInstance(CLSID_SystemDeviceEnum, nil, CLSCTX_INPROC,
    IID_ICreateDevEnum, pSysDevEnum);
  if (pSysDevEnum.CreateClassEnumerator(CatGUID, pEnumCat, 0) = S_OK) then
  begin
    while(pEnumCat.Next(1, pMoniker, nil) = S_OK) do
    begin
      pMoniker.BindToStorage(nil, nil, IID_IPropertyBag, pPropBag);
      item := TAudioRenderer.Create;
      pPropBag.Read('FriendlyName', ole_name, nil);
      item.name := ole_name;
      if (pPropBag.Read('CLSID', ole_name,nil) = S_OK) then
      begin
        s_name := ole_name;
        CLSIDFromString(PWideChar(WideString(s_name)), item.CLSID);
      end
      else
        item.CLSID := GUID_NULL;

      catlist.Add(item);

      pPropBag := nil;
      pMoniker := nil;
    end;
    pEnumCat :=nil;
  end;
  pSysDevEnum :=nil;
end;

procedure TCinema.clearObjectList(var list: TList);
var
  i: integer;
begin
  for i := 0 to list.Count - 1 do
    TObject(list[i]).Free;
  list.Clear;
end;

function TCinema.GetAudioRenderer(Index: Integer): TAudioRenderer;
begin
  if Index >= FAudioRenderers.Count then
    raise EListError.Create(Format(SListIndexError, [Index]));

  Result := TAudioRenderer(FAudioRenderers[Index]);
end;

function TCinema.GetAudioRenderersCount: integer;
begin
  Result := FAudioRenderers.Count;
end;

end.
