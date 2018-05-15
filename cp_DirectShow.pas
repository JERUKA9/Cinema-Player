unit cp_DirectShow;

interface

uses
  Windows, ActiveX;//, directshow;


//+----------------------------------------------------------------------------+
//|                              DirectShow section                            |
//+----------------------------------------------------------------------------+

type
  OAEVENT = Longint;
  OAHWND = Longint;
  HSEMAPHORE = Longint;  

const
  IID_IPin                            : TGUID = '{56A86891-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IEnumPins                       : TGUID = '{56A86892-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IEnumMediaTypes                 : TGUID = '{89C31040-846B-11CE-97D3-00AA0055595A}';
  IID_IFilterGraph                    : TGUID = '{56A8689F-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IEnumFilters                    : TGUID = '{56A86893-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IMediaFilter                    : TGUID = '{56A86899-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IBaseFilter                     : TGUID = '{56A86895-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IReferenceClock                 : TGUID = '{56A86897-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IMediaSample                    : TGUID = '{56A8689A-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IGraphBuilder                   : TGUID = '{56A868A9-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IMediaSeeking                   : TGUID = '{36B73880-C2C8-11CF-8B46-00805F6CEF60}';
  IID_IMediaControl                   : TGUID = '{56A868B1-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IBasicAudio                     : TGUID = '{56A868B3-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IBasicVideo                     : TGUID = '{56A868B5-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IBasicVideo2                    : TGUID = '{329BB360-F6EA-11D1-9038-00A0C9697298}';
  IID_IVideoWindow                    : TGUID = '{56A868B4-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IQualProp                       : TGUID = '{1BD0ECB0-F8E2-11CE-AAC6-0020AF0B99A3}';
  IID_IAMOpenProgress                 : TGUID = '{8E1C39A1-DE53-11cf-AA63-0080C744528D}';
  IID_IAMStreamSelect                 : TGUID = '{C1960960-17F5-11D1-ABE1-00A0C905F375}';
{$IFDEF OVERLAY}
//  IID_IOverlay                        : TGUID = '{56A868A1-0AD4-11CE-B03A-0020AF0BA770}';
{$ENDIF}
{$IFDEF GRABBER}
  IID_IMediaEvent                     : TGUID = '{56A868B6-0AD4-11CE-B03A-0020AF0BA770}';
  IID_ISampleGrabberCB                : TGUID = '{0579154A-2B53-4994-B0D0-E773148EFF85}';
  IID_ISampleGrabber                  : TGUID = '{6B652FFF-11FE-4FCE-92AD-0266B5D7C78F}';
{$ENDIF}
  IID_ICreateDevEnum                  : TGUID = '{29840822-5B84-11D0-BD3B-00A0C911CE86}';

type
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

  TCPDisplaySize =
  (
    cpDefaultSize,
    cpHalfSize,
    cpDoubleSize,
    cpFullScreen,
    cpFitToSize,
    cpOneSixteenthScreen,
    cpOneFourthScreen,
    cpOneHalfScreen
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

  TCPShowDialog =
  (
    cpShowDialogHelp,
    cpShowDialogStatistics,
    cpShowDialogOptions,
    cpShowDialogContextMenu
  );

const
  TIME_FORMAT_NONE         : TGUID = (D1:$00000000;D2:$0000;D3:$0000;D4:($00,$00,$00,$00,$00,$00,$00,$00));
  TIME_FORMAT_FRAME        : TGUID = (D1:$7B785570;D2:$8C82;D3:$11CF;D4:($BC,$0C,$00,$AA,$00,$AC,$74,$F6));
  TIME_FORMAT_BYTE         : TGUID = (D1:$7B785571;D2:$8C82;D3:$11CF;D4:($BC,$0C,$00,$AA,$00,$AC,$74,$F6));
  TIME_FORMAT_SAMPLE       : TGUID = (D1:$7B785572;D2:$8C82;D3:$11CF;D4:($BC,$0C,$00,$AA,$00,$AC,$74,$F6));
  TIME_FORMAT_FIELD        : TGUID = (D1:$7B785573;D2:$8C82;D3:$11CF;D4:($BC,$0C,$00,$AA,$00,$AC,$74,$F6));
  TIME_FORMAT_MEDIA_TIME   : TGUID = (D1:$7B785574;D2:$8C82;D3:$11CF;D4:($BC,$0C,$00,$AA,$00,$AC,$74,$F6));

  ONE_SECOND = 10000000;

const
  VFW_S_AUDIO_NOT_RENDERED             = $00040258;
  VFW_S_DUPLICATE_NAME                 = $0004022D;
  VFW_S_PARTIAL_RENDER                 = $00040242;
  VFW_S_VIDEO_NOT_RENDERED             = $00040257;
{$IFDEF OVERLAY}
//  VFW_E_NO_COLOR_KEY_SET               = $8004021A;
{$ENDIF}

  AM_SEEKING_NoPositioning             = 0;
  AM_SEEKING_AbsolutePositioning       = 1;
  AM_SEEKING_SeekToKeyFrame            = 4;
  AM_SEEKING_NoFlush                   = $20;

  AMSTREAMSELECTENABLE_ENABLE          = $1;
  AMSTREAMSELECTENABLE_ENABLEALL       = $2;


  CLSID_FilterGraph            : TGUID = (D1:$E436EBB3;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
{$IFDEF GRABBER}
  CLSID_SampleGrabber          : TGUID = (D1:$C1F400A0;D2:$3F08;D3:$11D3;D4:($9F,$0B,$00,$60,$08,$03,$9E,$37));
{$ENDIF}
  CLSID_AudioRender            : TGUID = (D1:$E30629D1;D2:$27E5;D3:$11CE;D4:($87,$5D,$00,$60,$8C,$B7,$80,$66));
  CLSID_DSoundRender           : TGUID = (D1:$79376820;D2:$07D0;D3:$11CF;D4:($A2,$4D,$00,$20,$AF,$D7,$97,$67));
  CLSID_SystemDeviceEnum       : TGUID = (D1:$62BE5D10;D2:$60EB;D3:$11D0;D4:($BD,$3B,$00,$A0,$C9,$11,$CE,$86));
  CLSID_AudioRendererCategory  : TGUID = (D1:$E0F158E1;D2:$CB04;D3:$11D0;D4:($BD,$4E,$00,$A0,$C9,$11,$CE,$86));

  MEDIATYPE_Video              : TGUID = (D1:$73646976;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIATYPE_Audio              : TGUID = (D1:$73647561;D2:$0000;D3:$0010;D4:($80,$00,$00,$AA,$00,$38,$9B,$71));
  MEDIASUBTYPE_RGB8            : TGUID = (D1:$E436EB7A;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_RGB565          : TGUID = (D1:$E436EB7B;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_RGB555          : TGUID = (D1:$E436EB7C;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_RGB24           : TGUID = (D1:$E436EB7D;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_RGB32           : TGUID = (D1:$E436EB7E;D2:$524F;D3:$11CE;D4:($9F,$53,$00,$20,$AF,$0B,$A7,$70));
  MEDIASUBTYPE_DOLBY_AC3_SPDIF : TGUID = (D1:$00000092;D2:$0000;D3:$0010;D4:($80,$00,$00,$aa,$00,$38,$9b,$71));
  MEDIASUBTYPE_DOLBY_AC3       : TGUID = (D1:$E06D802C;D2:$DB46;D3:$11CF;D4:($B4,$D1,$00,$80,$005F,$6C,$BB,$EA));
  FORMAT_VideoInfo             : TGUID = (D1:$05589F80;D2:$C356;D3:$11CE;D4:($BF,$01,$00,$AA,$00,$55,$59,$5A));
  FORMAT_VideoInfo2            : TGUID = (D1:$F72A76A0;D2:$EB0A;D3:$11D0;D4:($AC,$E4,$00,$00,$C0,$CC,$16,$BA));

type
  IEnumFilters = interface;
  IEnumMediaTypes = interface;
  IBaseFilter = interface;
  IFilterGraph = interface;
{$IFDEF GRABBER}
  ISampleGrabber = interface;
{$ENDIF}
  TRefTime = double;
  TReference_Time = int64;
  PReference_Time = ^TReference_Time;

  TPin_Direction = (
    PINDIR_INPUT,
    PINDIR_OUTPUT
  );

  TFilter_State = (
    State_Stopped,
    State_Paused,
    State_Running
  );

  TPin_Info = record
    pFilter: IBaseFilter;
    dir: TPin_Direction;
    achName: array[0..127] of WCHAR;
  end;

  TAM_Media_Type = record
    majortype: TGUID;
    subtype: TGUID;
    bFixedSizeSamples: BOOL;
    bTemporalCompression: BOOL;
    lSampleSize: ULONG;
    formattype: TGUID;
    pUnk: IUnknown;
    cbFormat: ULONG;
    pbFormat: Pointer;
  end;
  PAM_Media_Type = ^TAM_Media_Type;

  TFilterInfo = record
    achName: array[0..127] of WCHAR;
    pGraph: IFilterGraph;
  end;

  TVideoInfoHeader = record
    rcSource: TRect;
    rcTarget: TRect;
    dwBitRate: DWORD;
    dwBitErrorRate: DWORD;
    AvgTimePerFrame: TReference_Time;
    bmiHeader: TBitmapInfoHeader;
  end;

//  PVideoInfoHeader2 = ^TVideoInfoHeader2;
  TVideoInfoHeader2 = record
    rcSource: TRect;
    rcTarget: TRect;
    dwBitRate: DWORD;
    dwBitErrorRate: DWORD;
    AvgTimePerFrame: TReference_Time;
    dwInterlaceFlags: DWORD;         // use AMINTERLACE_* defines. Reject connection if undefined bits are not 0
    dwCopyProtectFlags: DWORD;       // use AMCOPYPROTECT_* defines. Reject connection if undefined bits are not 0
    dwPictAspectRatioX: DWORD;       // X dimension of picture aspect ratio, e.g. 16 for 16x9 display
    dwPictAspectRatioY: DWORD;       // Y dimension of picture aspect ratio, e.g.  9 for 16x9 display
    case integer of
    0: (dwControlFlags: DWORD;           // use AMCONTROL_* defines, use this from now on
        dwReserved2: DWORD;              // must be 0; reject connection otherwise
        bmiHeader: TBitmapInfoHeader);
    1: (dwReserved1: DWORD ;              // for backward compatiblity (was "must be 0";  connection rejected otherwise)
        dwReserved2_: DWORD;              // must be 0; reject connection otherwise
        bmiHeader_: TBitmapInfoHeader);
  end;

{$IFDEF OVERLAY}
(*  TColorKey = record
    KeyType: DWORD;
    PaletteIndex: DWORD;
    LowColorValue: COLORREF;
    HighColorValue: COLORREF;
  end;*)
{$ENDIF}

  IReferenceClock = interface(IUnknown)
    ['{56A86897-0AD4-11CE-B03A-0020AF0BA770}']
    function GetTime(out pTime: TReference_Time): HRESULT; stdcall;
    function AdviseTime(baseTime, streamTime: TReference_Time;
        hEvent: THandle; out pdwAdviseCookie: DWORD): HRESULT; stdcall;
    function AdvisePeriodic(startTime, periodTime: TReference_Time;
        hSemaphore: HSEMAPHORE; out pdwAdviseCookie: DWORD): HRESULT; stdcall;
    function Unadvise(dwAdviseCookie: DWORD): HRESULT; stdcall;
  end;

  IMediaFilter = interface(IPersist)
    ['{56A86899-0AD4-11CE-B03A-0020AF0BA770}']
    function Stop: HRESULT; stdcall;
    function Pause: HRESULT; stdcall;
    function Run(tStart: TReference_Time): HRESULT; stdcall;
    function GetState(dwMilliSecsTimeout: DWORD; out State: TFilter_State): HRESULT; stdcall;
    function SetSyncSource(pClock: IReferenceClock): HRESULT; stdcall;
    function GetSyncSource(out pClock: IReferenceClock): HRESULT; stdcall;
  end;

  IPin = interface(IUnknown)
    ['{56A86891-0AD4-11CE-B03A-0020AF0BA770}']
    function Connect(pReceivePin: IPin; const pmt: PAM_Media_Type): HRESULT; stdcall;
    function ReceiveConnection(pConnector: IPin; const pmt: TAM_Media_Type): HRESULT; stdcall;
    function Disconnect: HRESULT; stdcall;
    function ConnectedTo(out pPin: IPin): HRESULT; stdcall;
    function ConnectionMediaType(out pmt: TAM_Media_Type): HRESULT; stdcall;
    function QueryPinInfo(out pInfo: TPin_Info): HRESULT; stdcall;
    function QueryDirection(out pPinDir: TPin_Direction): HRESULT; stdcall;
    function QueryId(out Id: LPWSTR): HRESULT; stdcall;
    function QueryAccept(const pmt: TAM_Media_Type): HRESULT; stdcall;
    function EnumMediaTypes(out ppEnum: IEnumMediaTypes): HRESULT; stdcall;
    function QueryInternalConnections(out apPin: IPin; var nPin: ULONG): HRESULT; stdcall;
    function EndOfStream: HRESULT; stdcall;
    function BeginFlush: HRESULT; stdcall;
    function EndFlush: HRESULT; stdcall;
    function NewSegment(tStart, tStop: TReference_Time; dRate: double): HRESULT; stdcall;
  end;

  IFilterGraph = interface(IUnknown)
    ['{56A8689F-0AD4-11CE-B03A-0020AF0BA770}']
    function AddFilter(pFilter: IBaseFilter; pName: PWideChar): HRESULT; stdcall;
    function RemoveFilter(pFilter: IBaseFilter): HRESULT; stdcall;
    function EnumFilters(out ppEnum: IEnumFilters): HRESULT; stdcall;
    function FindFilterByName(pName: PWideChar; out ppFilter: IBaseFilter): HRESULT; stdcall;
    function ConnectDirect(ppinOut, ppinIn: IPin; pmt: PAM_Media_Type): HRESULT; stdcall;
    function Reconnect(ppin: IPin): HRESULT; stdcall;
    function Disconnect(ppin: IPin): HRESULT; stdcall;
    function SetDefaultSyncSource: HRESULT; stdcall;
  end;

  IGraphBuilder = interface(IFilterGraph)
    ['{56A868A9-0AD4-11CE-B03A-0020AF0BA770}']
    function Connect(ppinOut, ppinIn: IPin): HRESULT; stdcall;
    function Render(ppinOut: IPin): HRESULT; stdcall;
    function RenderFile(lpcwstrFile, lpcwstrPlayList: PWideChar): HRESULT; stdcall;
    function AddSourceFilter(lpcwstrFileName, lpcwstrFilterName: LPCWSTR;
        out ppFilter: IBaseFilter): HRESULT; stdcall;
    function SetLogFile(hFile: THandle): HRESULT; stdcall;
    function Abort: HRESULT; stdcall;
    function ShouldOperationContinue: HRESULT; stdcall;
  end;

  IMediaControl = interface(IDispatch)
    ['{56A868B1-0AD4-11CE-B03A-0020AF0BA770}']
    function Run: HResult; stdcall;
    function Pause: HResult; stdcall;
    function Stop: HResult; stdcall;
    function GetState(msTimeout: DWORD; out pfs: TFilter_State): HResult; stdcall;
    function RenderFile(strFilename: WideString): HResult; stdcall;
    function AddSourceFilter(strFilename: WideString; out ppUnk: IDispatch): HResult; stdcall;
    function get_FilterCollection(out ppUnk: IDispatch): HResult; stdcall;
    function get_RegFilterCollection(out ppUnk: IDispatch): HResult; stdcall;
    function StopWhenReady: HResult; stdcall;
  end;

  IMediaSeeking = interface(IUnknown)
    ['{36B73880-C2C8-11CF-8B46-00805F6CEF60}']
    function GetCapabilities(out pCapabilities: DWORD): HRESULT; stdcall;
    function CheckCapabilities(var pCapabilities: DWORD): HRESULT; stdcall;
    function IsFormatSupported(const pFormat: TGUID): HRESULT; stdcall;
    function QueryPreferredFormat(out pFormat: TGUID): HRESULT; stdcall;
    function GetTimeFormat(out pFormat: TGUID): HRESULT; stdcall;
    function IsUsingTimeFormat(const pFormat: TGUID): HRESULT; stdcall;
    function SetTimeFormat(const pFormat: TGUID): HRESULT; stdcall;
    function GetDuration(out pDuration: int64): HRESULT; stdcall;
    function GetStopPosition(out pStop: int64): HRESULT; stdcall;
    function GetCurrentPosition(out pCurrent: int64): HRESULT; stdcall;
    function ConvertTimeFormat(out pTarget: int64; pTargetFormat: PGUID;
               Source: int64; pSourceFormat: PGUID): HRESULT; stdcall;
    function SetPositions(var pCurrent: int64; dwCurrentFlags: DWORD;
               var pStop: int64; dwStopFlags: DWORD): HRESULT; stdcall;
    function GetPositions(out pCurrent, pStop: int64): HRESULT; stdcall;
    function GetAvailable(out pEarliest, pLatest: int64): HRESULT; stdcall;
    function SetRate(dRate: double): HRESULT; stdcall;
    function GetRate(out pdRate: double): HRESULT; stdcall;
    function GetPreroll(out pllPreroll: int64): HRESULT; stdcall;
  end;

  IBasicAudio = interface(IDispatch)
    ['{56A868B3-0AD4-11CE-B03A-0020AF0BA770}']
    function put_Volume(lVolume: Longint): HResult; stdcall;
    function get_Volume(out plVolume: Longint): HResult; stdcall;
    function put_Balance(lBalance: Longint): HResult; stdcall;
    function get_Balance(out plBalance: Longint): HResult; stdcall;
  end;

  IEnumPins = interface(IUnknown)
    ['{56A86892-0AD4-11CE-B03A-0020AF0BA770}']
    function Next(cPins: ULONG; out ppPins: IPin; pcFetched: PULONG): HRESULT; stdcall;
    function Skip(cPins: ULONG): HRESULT; stdcall;
    function Reset: HRESULT; stdcall;
    function Clone(out ppEnum: IEnumPins): HRESULT; stdcall;
  end;

  IEnumFilters = interface(IUnknown)
    ['{56A86893-0AD4-11CE-B03A-0020AF0BA770}']
    function Next(cFilters: ULONG; out ppFilter: IBaseFilter;
      pcFetched: PULONG): HRESULT; stdcall;
    function Skip(cFilters: ULONG): HRESULT; stdcall;
    function Reset: HRESULT; stdcall;
    function Clone(out ppEnum: IEnumFilters): HRESULT; stdcall;
  end;

  IEnumMediaTypes = interface(IUnknown)
    ['{89C31040-846B-11CE-97D3-00AA0055595A}']
    function Next(cMediaTypes: ULONG; out ppMediaTypes: PAM_Media_Type;
      pcFetched: PULONG): HRESULT; stdcall;
    function Skip(cMediaTypes: ULONG): HRESULT; stdcall;
    function Reset: HRESULT; stdcall;
    function Clone(out ppEnum: IEnumMediaTypes): HRESULT; stdcall;
  end;

  IBaseFilter = interface(IMediaFilter)
    ['{56A86895-0AD4-11CE-B03A-0020AF0BA770}']
    function EnumPins(out ppEnum: IEnumPins): HRESULT; stdcall;
    function FindPin(Id: PWideChar; out ppPin: IPin): HRESULT; stdcall;
    function QueryFilterInfo(out pInfo: TFilterInfo): HRESULT; stdcall;
    function JoinFilterGraph(pGraph: IFilterGraph; pName: PWideChar): HRESULT; stdcall;
    function QueryVendorInfo(out pVendorInfo: PWideChar): HRESULT; stdcall;
  end;

  IBasicVideo = interface(IDispatch)
    ['{56A868B5-0AD4-11CE-B03A-0020AF0BA770}']
    function get_AvgTimePerFrame(out pAvgTimePerFrame: TRefTime): HResult; stdcall;
    function get_BitRate(out pBitRate: Longint): HResult; stdcall;
    function get_BitErrorRate(out pBitErrorRate: Longint): HResult; stdcall;
    function get_VideoWidth(out pVideoWidth: Longint): HResult; stdcall;
    function get_VideoHeight(out pVideoHeight: Longint): HResult; stdcall;
    function put_SourceLeft(SourceLeft: Longint): HResult; stdcall;
    function get_SourceLeft(out pSourceLeft: Longint): HResult; stdcall;
    function put_SourceWidth(SourceWidth: Longint): HResult; stdcall;
    function get_SourceWidth(out pSourceWidth: Longint): HResult; stdcall;
    function put_SourceTop(SourceTop: Longint): HResult; stdcall;
    function get_SourceTop(out pSourceTop: Longint): HResult; stdcall;
    function put_SourceHeight(SourceHeight: Longint): HResult; stdcall;
    function get_SourceHeight(out pSourceHeight: Longint): HResult; stdcall;
    function put_DestinationLeft(DestinationLeft: Longint): HResult; stdcall;
    function get_DestinationLeft(out pDestinationLeft: Longint): HResult; stdcall;
    function put_DestinationWidth(DestinationWidth: Longint): HResult; stdcall;
    function get_DestinationWidth(out pDestinationWidth: Longint): HResult; stdcall;
    function put_DestinationTop(DestinationTop: Longint): HResult; stdcall;
    function get_DestinationTop(out pDestinationTop: Longint): HResult; stdcall;
    function put_DestinationHeight(DestinationHeight: Longint): HResult; stdcall;
    function get_DestinationHeight(out pDestinationHeight: Longint): HResult; stdcall;
    function SetSourcePosition(Left, Top, Width, Height: Longint): HResult; stdcall;
    function GetSourcePosition(out pLeft, pTop, pWidth, pHeight: Longint): HResult; stdcall;
    function SetDefaultSourcePosition: HResult; stdcall;
    function SetDestinationPosition(Left, Top, Width, Height: Longint): HResult; stdcall;
    function GetDestinationPosition(out pLeft, pTop, pWidth, pHeight: Longint): HResult; stdcall;
    function SetDefaultDestinationPosition: HResult; stdcall;
    function GetVideoSize(out pWidth, Height: Longint): HResult; stdcall;
    function GetVideoPaletteEntries(StartIndex, Entries: Longint;
        out pRetrieved: Longint; out pPalette): HResult; stdcall;
    function GetCurrentImage(var BufferSize: Longint; var pDIBImage): HResult; stdcall;
    function IsUsingDefaultSource: HResult; stdcall;
    function IsUsingDefaultDestination: HResult; stdcall;
  end;

  IBasicVideo2 = interface(IBasicVideo)
    ['{329bb360-f6ea-11d1-9038-00a0c9697298}']
    function GetPreferredAspectRatio(out plAspectX, plAspectY: Longint): HRESULT; stdcall;
  end;

  IQualProp = interface(IUnknown)
    ['{1BD0ECB0-F8E2-11CE-AAC6-0020AF0B99A3}']
    function get_FramesDroppedInRenderer(var pcFrames: Integer): HRESULT; stdcall;
    function get_FramesDrawn(out pcFrames: Integer): HRESULT; stdcall;
    function get_AvgFrameRate(out piAvgFrameRate: Integer): HRESULT; stdcall;
    function get_Jitter(out iJitter: Integer): HRESULT; stdcall;
    function get_AvgSyncOffset(out piAvg: Integer): HRESULT; stdcall;
    function get_DevSyncOffset(out piDev: Integer): HRESULT; stdcall;
  end;

  IVideoWindow = interface(IDispatch)
    ['{56A868B4-0AD4-11CE-B03A-0020AF0BA770}']
    function put_Caption(strCaption: WideString): HResult; stdcall;
    function get_Caption(out strCaption: WideString): HResult; stdcall;
    function put_WindowStyle(WindowStyle: Longint): HResult; stdcall;
    function get_WindowStyle(out WindowStyle: Longint): HResult; stdcall;
    function put_WindowStyleEx(WindowStyleEx: Longint): HResult; stdcall;
    function get_WindowStyleEx(out WindowStyleEx: Longint): HResult; stdcall;
    function put_AutoShow(AutoShow: LongBool): HResult; stdcall;
    function get_AutoShow(out AutoShow: LongBool): HResult; stdcall;
    function put_WindowState(WindowState: Longint): HResult; stdcall;
    function get_WindowState(out WindowState: Longint): HResult; stdcall;
    function put_BackgroundPalette(BackgroundPalette: Longint): HResult; stdcall;
    function get_BackgroundPalette(out pBackgroundPalette: Longint): HResult; stdcall;
    function put_Visible(Visible: LongBool): HResult; stdcall;
    function get_Visible(out pVisible: LongBool): HResult; stdcall;
    function put_Left(Left: Longint): HResult; stdcall;
    function get_Left(out pLeft: Longint): HResult; stdcall;
    function put_Width(Width: Longint): HResult; stdcall;
    function get_Width(out pWidth: Longint): HResult; stdcall;
    function put_Top(Top: Longint): HResult; stdcall;
    function get_Top(out pTop: Longint): HResult; stdcall;
    function put_Height(Height: Longint): HResult; stdcall;
    function get_Height(out pHeight: Longint): HResult; stdcall;
    function put_Owner(Owner: OAHWND): HResult; stdcall;
    function get_Owner(out Owner: OAHWND): HResult; stdcall;
    function put_MessageDrain(Drain: OAHWND): HResult; stdcall;
    function get_MessageDrain(out Drain: OAHWND): HResult; stdcall;
    function get_BorderColor(out Color: Longint): HResult; stdcall;
    function put_BorderColor(Color: Longint): HResult; stdcall;
    function get_FullScreenMode(out FullScreenMode: LongBool): HResult; stdcall;
    function put_FullScreenMode(FullScreenMode: LongBool): HResult; stdcall;
    function SetWindowForeground(Focus: Longint): HResult; stdcall;
    function NotifyOwnerMessage(hwnd: Longint; uMsg, wParam, lParam: Longint): HResult; stdcall;
    function SetWindowPosition(Left, Top, Width, Height: Longint): HResult; stdcall;
    function GetWindowPosition(out pLeft, pTop, pWidth, pHeight: Longint): HResult; stdcall;
    function GetMinIdealImageSize(out pWidth, pHeight: Longint): HResult; stdcall;
    function GetMaxIdealImageSize(out pWidth, pHeight: Longint): HResult; stdcall;
    function GetRestorePosition(out pLeft, pTop, pWidth, pHeight: Longint): HResult; stdcall;
    function HideCursor(HideCursor: LongBool): HResult; stdcall;
    function IsCursorHidden(out CursorHidden: LongBool): HResult; stdcall;
  end;

  IMediaSample = interface(IUnknown)
    ['{56A8689A-0AD4-11CE-B03A-0020AF0BA770}']
    function GetPointer(out ppBuffer: PBYTE): HRESULT; stdcall;
    function GetSize: Longint; stdcall;
    function GetTime(out pTimeStart, pTimeEnd: TReference_Time): HRESULT; stdcall;
    function SetTime(pTimeStart, pTimeEnd: PReference_Time): HRESULT; stdcall;
    function IsSyncPoint: HRESULT; stdcall;
    function SetSyncPoint(bIsSyncPoint: BOOL): HRESULT; stdcall;
    function IsPreroll: HRESULT; stdcall;
    function SetPreroll(bIsPreroll: BOOL): HRESULT; stdcall;
    function GetActualDataLength: Longint; stdcall;
    function SetActualDataLength(lLen: Longint): HRESULT; stdcall;
    function GetMediaType(out ppMediaType: PAM_Media_Type): HRESULT; stdcall;
    function SetMediaType(var pMediaType: TAM_Media_Type): HRESULT; stdcall;
    function IsDiscontinuity: HRESULT; stdcall;
    function SetDiscontinuity(bDiscontinuity: BOOL): HRESULT; stdcall;
    function GetMediaTime(out pTimeStart, pTimeEnd: int64): HRESULT; stdcall;
    function SetMediaTime(pTimeStart, pTimeEnd: Pint64): HRESULT; stdcall;
  end;

  IAMOpenProgress = interface(IUnknown)
    ['{8E1C39A1-DE53-11cf-AA63-0080C744528D}']
    function QueryProgress(out pllTotal, pllCurrent: int64): HRESULT; stdcall;
    function AbortOperation: HRESULT; stdcall;
  end;

{$IFDEF OVERLAY}
(*  IOverlayNotify = interface(IUnknown)
    ['{56A868A0-0AD4-11CE-B03A-0020AF0BA770}']
    function OnPaletteChange(dwColors: DWORD; const pPalette: TPALETTEENTRY): HRESULT; stdcall;
    function OnClipChange(const pSourceRect, pDestinationRect: TRect;
        const pRgnData: TRgnData): HRESULT; stdcall;
    function OnColorKeyChange(const pColorKey: TColorKey): HRESULT; stdcall;
    function OnPositionChange(const pSourceRect, pDestinationRect: TRect): HRESULT; stdcall;
  end;

  IOverlay = interface(IUnknown)
    ['{56A868A1-0AD4-11CE-B03A-0020AF0BA770}']
    function GetPalette(out pdwColors: DWORD; out ppPalette: PPALETTEENTRY): HRESULT; stdcall;
    function SetPalette(dwColors: DWORD; var pPalette: PaletteEntry): HRESULT; stdcall;
    function GetDefaultColorKey(out pColorKey: TColorKey): HRESULT; stdcall;
    function GetColorKey(out pColorKey: TColorKey): HRESULT; stdcall;
    function SetColorKey(var pColorKey: TColorKey): HRESULT; stdcall;
    function GetWindowHandle(out pHwnd: HWND): HRESULT; stdcall;
    function GetClipList(out pSourceRect, pDestinationRect: TRect;
        out ppRgnData: PRgnData): HRESULT; stdcall;
    function GetVideoPosition(out pSourceRect, pDestinationRect: TRect): HRESULT; stdcall;
    function Advise(pOverlayNotify: IOverlayNotify; dwInterests: DWORD): HRESULT; stdcall;
    function Unadvise: HRESULT; stdcall;
  end;*)
{$ENDIF}

{$IFDEF GRABBER}
  ISampleGrabberCB = interface(IUnknown)
    ['{0579154A-2B53-4994-B0D0-E773148EFF85}']
    function  SampleCB(SampleTime: Double; pSample: IMediaSample): HResult; stdcall;
    function  BufferCB(SampleTime: Double; pBuffer: PByte; BufferLen: longint): HResult; stdcall;
  end;

  ISampleGrabber = interface(IUnknown)
    ['{6B652FFF-11FE-4FCE-92AD-0266B5D7C78F}']
    function SetOneShot(OneShot: BOOL): HResult; stdcall;
    function SetMediaType(var pType: TAM_MEDIA_TYPE): HResult; stdcall;
    function GetConnectedMediaType(out pType: TAM_MEDIA_TYPE): HResult; stdcall;
    function SetBufferSamples(BufferThem: BOOL): HResult; stdcall;
    function GetCurrentBuffer(out pBufferSize: longint; Buffer: Pointer): HResult; stdcall;
    function GetCurrentSample(out ppSample: IMediaSample): HResult; stdcall;
    function SetCallback(pCallback: ISampleGrabberCB; WhichMethodToCallback: longint): HResult; stdcall;
  end;

  IMediaEvent = interface(IDispatch)
    ['{56A868B6-0AD4-11CE-B03A-0020AF0BA770}']
    function GetEventHandle(out hEvent: OAEVENT): HRESULT; stdcall;
    function GetEvent(out lEventCode: Longint; out lParam1, lParam2: Longint;
        msTimeout: DWORD): HRESULT; stdcall;
    function WaitForCompletion(msTimeout: DWORD; out pEvCode: Longint):
        HRESULT; stdcall;
    function CancelDefaultHandling(lEvCode: Longint): HRESULT; stdcall;
    function RestoreDefaultHandling(lEvCode: Longint): HRESULT; stdcall;
    function FreeEventParams(lEvCode: Longint; lParam1, lParam2: Longint):
        HRESULT; stdcall;
  end;
{$ENDIF}

  PIUNKNOWN = ^IUnknown;

  IAMStreamSelect = interface(IUnknown)
    ['{C1960960-17F5-11D1-ABE1-00A0C905F375}']
    function Count(out pcStreams: DWORD): HResult; stdcall;
    function Info(lIndex: Longint; ppmt: PAM_Media_Type;
        pdwFlags: PDWORD; out plcid: LCID; pdwGroup: PDWORD;
        out ppszName: PWCHAR; ppObject: PIUnknown; ppUnk : PIUNKNOWN): HResult; stdcall;
    function Enable(lIndex: Longint; dwFlags: DWORD): HResult; stdcall;
  end;

  ICreateDevEnum = interface(IUnknown)
    ['{29840822-5B84-11D0-BD3B-00A0C911CE86}']
    function CreateClassEnumerator(const clsidDeviceClass: TGUID;
        out ppEnumMoniker: IEnumMoniker; dwFlags: DWORD): HResult; stdcall;
  end;
//+----------------------------------------------------------------------------+
//|                      End of DirectShow section                             |
//+----------------------------------------------------------------------------+

implementation

end.

