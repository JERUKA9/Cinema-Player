unit uSpeakers;

interface

uses
  Windows, Classes, SysUtils, ActiveX, SpeechAPI4, SpeechAPI5, WinSock2;

//TODO: cleanup, add: volume, rate


type
  TSpeakerRangeValue = 0..100;

  TSpeakerKind = (skExpressIVO, skSAPI4, skSAPI5);

  PSpeakerVoice = ^TSpeakerVoice;
  TSpeakerVoice = record
    _kind: TSpeakerKind;
    _index: integer;
  end;

  TAbstractSpeaker = class(TObject)
  private

  protected
    _initialized: boolean;
    _window_handle: THandle;

    _curr_voice: integer;

    _flush_before_speak: boolean;

    _volumeSupported: boolean;
    _volume: TSpeakerRangeValue;
    _default_volume: DWORD;

    _rateSupported: boolean;
    _rate: TSpeakerRangeValue;
    _default_rate: DWORD;
  public
    constructor create(wnd_handle: THandle); virtual;
    destructor destroy; override;

    function isInitialised: boolean;
    function initialize: boolean; virtual; abstract;
    procedure deinitialize; virtual;

    procedure speak(const phrase: string); virtual; abstract;
    procedure setFlushBeforeSpeak(const state: boolean);
    procedure flush(); virtual; abstract;
    function getVoices(const sl: TStringList): boolean; virtual; abstract;
    function selectVoice(index: integer): boolean; virtual; abstract;

    function volumeAvailable(): boolean;
    function setVolume(const volume: TSpeakerRangeValue): boolean; virtual; abstract;
    function getVolume(): TSpeakerRangeValue;
    procedure presetVolume(const volume: TSpeakerRangeValue);

    function rateAvailable(): boolean;
    function setRate(const rate: TSpeakerRangeValue): boolean; virtual; abstract;
    function getRate(): TSpeakerRangeValue;
    procedure presetRate(const rate: TSpeakerRangeValue);

    procedure resetSettings(); virtual; abstract;
  end;

  TSAPI4Speaker = class(TAbstractSpeaker)
  private
    _pAudioMMDevice: IAudioMultimediaDevice;
    _pEnum: ITTSEnum;
    _pCentral: ITTSCentral;
    _iAttributes: ITTSAttributes;
//    _pNotifySink: ITTSNotifySink;
//    _dwKey: DWORD;

    _low_volume, _high_volume: DWORD;

    _low_rate, _high_rate: DWORD;
  public
    constructor create(wnd_handle: THandle); override;

    function initialize: boolean; override;
    procedure deinitialize; override;

    procedure speak(const phrase: string); override;
    procedure flush(); override;
    function getVoices(const sl: TStringList): boolean; override;
    function selectVoice(index: integer): boolean; override;
    function setVolume(const volume: TSpeakerRangeValue): boolean; override;
    function setRate(const rate: TSpeakerRangeValue): boolean; override;
    procedure resetSettings(); override;
  end;

  TSAPI5Speaker = class(TAbstractSpeaker)
  private
    _pVoice: ISpVoice;
    _pTokenCategory: ISpObjectTokenCategory;
    _pEnum: IEnumSpObjectTokens;

  public
    constructor create(wnd_handle: THandle); override;

    function initialize: boolean; override;
    procedure deinitialize; override;

    procedure speak(const phrase: string); override;
    procedure flush(); override;
    function getVoices(const sl: TStringList): boolean; override;
    function selectVoice(index: integer): boolean; override;
    function setVolume(const volume: TSpeakerRangeValue): boolean; override;
    function setRate(const rate: TSpeakerRangeValue): boolean; override;
    procedure resetSettings(); override;
  end;

  TExpressIVOServerResponseType = (eisrOK, eisrERR, eisrRANGE, eisrYES, eisrNO,
    eisrUNK);
  TExpressIVOCommandType = (eicSayIt, eicPause, eicResume, eicStop,
    eicIsSpeaking, eicPitch, eicSpeed, eicVolume, eicDefault, eicClose,
    eicVersion, eicVoice);

  TExpressIVOSpeaker = class(TAbstractSpeaker)
  private
    _socket: TSocket;

    function send(const eicCmd: TExpressIVOCommandType;
      var strParam: string): TExpressIVOServerResponseType;
    function recv(): string;
  public
    constructor create(wnd_handle: THandle); override;

    function initialize: boolean; override;
    procedure deinitialize; override;

    procedure speak(const phrase: string); override;
    procedure flush(); override;
    function getVoices(const sl: TStringList): boolean; override;
    function selectVoice(index: integer): boolean; override;
    function setVolume(const volume: TSpeakerRangeValue): boolean; override;
    function setRate(const rate: TSpeakerRangeValue): boolean; override;
    procedure resetSettings(); override;
  end;

implementation

uses
  uSpeakerEngine, zb_sys_env;

{
type
  TTSNotifySink = class(TInterfacedObject, ITTSNotifySink)
  private
    _speaker: TSAPI4Speaker;
  protected
   function AttribChanged(dwAttribute: DWORD): HRESULT; stdcall;
   function AudioStart(qTimeStamp: QWORD): HRESULT; stdcall;
   function AudioStop(qTimeStamp: QWORD): HRESULT; stdcall;
   function Visual(qTimeStamp: QWORD; cIPAPhoneme: Char; cEnginePhoneme: Char;
     dwHints: DWORD; apTTSMouth: PTTSMouth): HRESULT; stdcall;
  public
   constructor create(speaker : TSAPI4Speaker);
  end;
}

{ TAbstractSpeaker }

constructor TAbstractSpeaker.create(wnd_handle: THandle);
begin
  _initialized := false;
  _window_handle := wnd_handle;
  _curr_voice := -1;
end;

procedure TAbstractSpeaker.deinitialize;
begin
  _initialized := false;
end;

destructor TAbstractSpeaker.destroy;
begin
  deinitialize;
  inherited;
end;

function TAbstractSpeaker.getRate: TSpeakerRangeValue;
begin
  Result := _rate;
end;

function TAbstractSpeaker.getVolume: TSpeakerRangeValue;
begin
  Result := _volume;
end;

function TAbstractSpeaker.isInitialised: boolean;
begin
  Result := _initialized;
end;

procedure TAbstractSpeaker.presetRate(const rate: TSpeakerRangeValue);
begin
  _rate := rate;
end;

procedure TAbstractSpeaker.presetVolume(const volume: TSpeakerRangeValue);
begin
  _volume := volume;
end;

function TAbstractSpeaker.rateAvailable: boolean;
begin
  Result := _rateSupported;
end;

procedure TAbstractSpeaker.setFlushBeforeSpeak(const state: boolean);
begin
  _flush_before_speak := state;
end;

function TAbstractSpeaker.volumeAvailable: boolean;
begin
  Result := _volumeSupported;
end;

{ TSAPI4Speaker }

constructor TSAPI4Speaker.create(wnd_handle: THandle);
begin
  inherited;
  _iAttributes := nil;
  _pCentral := nil;
  _pEnum := nil;
  _pAudioMMDevice := nil;
  _curr_voice := -1;
end;

procedure TSAPI4Speaker.deinitialize;
begin
  inherited;
//  if _curr_voice <> -1 then
//    _pCentral.UnRegister(_dwKey);
  _iAttributes := nil;
  _pCentral := nil;
//  _pNotifySink := nil;
  _pEnum := nil;
  _pAudioMMDevice := nil;
  _curr_voice := -1;
end;

procedure TSAPI4Speaker.flush;
begin
  if initialize() and (_curr_voice > -1) then
  begin
    if _pCentral = nil then
    begin
      exit;
    end;

    _pCentral.AudioReset();
  end;
end;

function TSAPI4Speaker.getVoices(const sl: TStringList): boolean;
var
  modeInfo_: TTSModeInfo;
//  numFound_: ULONG;
  psv_: PSpeakerVoice;
  i_: integer;
begin
  Result := initialize();
  if Result then
  begin
    _pEnum.Reset;
    i_ := 0;
    while _pEnum.Next(1, modeInfo_, nil) = S_OK do
    begin
      new(psv_);
      psv_._kind := skSAPI4;
      psv_._index := i_;
      inc(i_);
      sl.AddObject(modeInfo_.szModeName + ' [SAPI4]', TObject(psv_));
//      _pEnum.Next(1, modeInfo_, @numFound_);
    end;
//    _pEnum := nil;
  end;
end;

function TSAPI4Speaker.initialize: boolean;
begin
  Result := _initialized;
  if Result then
    exit;

  if Succeeded(CoCreateInstance(CLSID_MMAudioDest, nil, CLSCTX_ALL,
     IID_IAudioMultiMediaDevice, _pAudioMMDevice)) then
  begin
//    RichEdit1.Lines.Add('CoCreateInstance IID_IAudioMultiMediaDevice Success')
    if Succeeded(CoCreateInstance(CLSID_TTSEnumerator, nil, CLSCTX_ALL,
       IID_ITTSEnum, _pEnum)) then
    begin
//      RichEdit1.Lines.Add('CoCreateInstance IID_ITTSEnum Success');
//todo: check this below
//      _pNotifySink := TTSNotifySink.create(Self);
      Result := true;
{
    end
    else
    begin
      RichEdit1.Lines.Add('CoCreateInstance IID_ITTSEnum Failed');
}
    end;
{
  end
  else
  begin
    RichEdit1.Lines.Add('CoCreateInstance IID_IAudioMultiMediaDevice Failed');
}
  end;
  if not Result then
  begin
    _pEnum := nil;
    _pAudioMMDevice := nil;
  end
  else
    _initialized := true;
//TODO: check for Voice
end;

procedure TSAPI4Speaker.resetSettings;
begin
  if initialize() and (_curr_voice > -1) and (_iAttributes <> nil) then
  begin
    presetVolume(round((LOWORD(_default_volume) - LOWORD(_low_volume)) * 100 / (LOWORD(_high_volume) - LOWORD(_low_volume))));
    _iAttributes.VolumeSet(_default_volume);
    presetRate(round((_default_rate - _low_rate) * 100 / (_high_rate - _low_rate)));
    _iAttributes.SpeedSet(_default_rate);
  end;
end;

function TSAPI4Speaker.selectVoice(index: integer): boolean;
var
  i_: integer;
  modeInfo_: TTSMODEINFO;
  numFound_: ULONG;
begin
  Result := (_curr_voice <> index) and initialize();
  if Result then
  begin
    Result := false;
    _pEnum.Reset;
    for i_ := 0 to index do
      _pEnum.Next(1, modeInfo_, @numFound_);
    if numFound_ > 0 then
    begin
//      if _curr_voice <> -1 then
//        _pCentral.UnRegister(_dwKey);

      _iAttributes := nil;
      _pCentral := nil;
      if Succeeded(_pEnum.Select(modeInfo_.gModeID, _pCentral, IUnknown(_pAudioMMDevice))) then
      begin
        Result := true;
        _curr_voice := index;
        _volumeSupported := false;
        _rateSupported := false;
        if (modeInfo_.dwInterfaces and TTSI_ITTSATTRIBUTES) <> 0 then
        begin
          if Succeeded(_pCentral.QueryInterface(IID_ITTSAttributes, _iAttributes)) then
          begin
            if (modeInfo_.dwFeatures and TTSFEATURE_VOLUME) <> 0 then
              if not (_iAttributes.VolumeGet(_default_volume) = TTSERR_NOTSUPPORTED) then
                if not (_iAttributes.VolumeSet(_default_volume) = TTSERR_NOTSUPPORTED) then
                begin
                  _volumeSupported := true;
                  _iAttributes.VolumeSet(TTSATTR_MAXVOLUME);
                  _iAttributes.VolumeGet(_high_volume);
                  _iAttributes.VolumeSet(TTSATTR_MINVOLUME);
                  _iAttributes.VolumeGet(_low_volume);

//  MessageBox(0, PChar('selectVoice defVolume: ' + IntToStr(_default_volume)), nil, 0);
//  MessageBox(0, PChar('selectVoice Volume: ' + IntToStr(_volume)), nil, 0);
                  setVolume(_volume);
                  _iAttributes.VolumeGet(numFound_);
                end;

            if (modeInfo_.dwFeatures and TTSFEATURE_SPEED) <> 0 then
              if not (_iAttributes.SpeedGet(_default_rate) = TTSERR_NOTSUPPORTED) then
                if not (_iAttributes.SpeedSet(_default_rate) = TTSERR_NOTSUPPORTED) then
                begin
                  _rateSupported := true;
                  _iAttributes.SpeedSet(TTSATTR_MAXSPEED);
                  _iAttributes.SpeedGet(_high_rate);
                  _iAttributes.SpeedSet(TTSATTR_MINSPEED);
                  _iAttributes.SpeedGet(_low_rate);
//  MessageBox(0, PChar('selectVoice defRate: ' + IntToStr(_default_rate)), nil, 0);
//  MessageBox(0, PChar('selectVoice Rate: ' + IntToStr(_rate)), nil, 0);
                  setRate(_rate);
                  setRate(_rate);
                  _iAttributes.SpeedGet(numFound_);
                end;
          end;
        end;
      end;

{
      if Result then
        MessageBox(0, 'Engine Select Success', nil, MB_OK)
      else
        MessageBox(0, 'Engine Select Failed', nil, MB_OK);
}
    end;
//    if Result then
//    begin
//      _pCentral.Register(Pointer(_pNotifySink), IID_ITTSNotifySink, _dwKey);
//    end;
  end;
end;

function TSAPI4Speaker.setRate(const rate: TSpeakerRangeValue): boolean;
begin
  presetRate(rate);
  Result := initialize() and (_curr_voice > -1) and (_iAttributes <> nil) and (_high_rate > 0) and
            Succeeded(_iAttributes.SpeedSet(int64(_high_rate - _low_rate) * _rate div 100 + _low_rate));
//  MessageBox(0, PChar(Format('setRate: int64(_high_rate"%x" - _low_rate"%x") * _rate"%x" div 100 + _low_rate"%x": %d',
//            [_high_rate, _low_rate, _rate, _low_rate, int64(_high_rate - _low_rate) * _rate div 100 + _low_rate])), nil, 0);
//            Succeeded(_pCentral.Inject(PChar(Format('\Spd=%d\',
//                      [round((_highRate - _lowRate) * (rate / 100)) + _lowRate]))));
end;

function TSAPI4Speaker.setVolume(const volume: TSpeakerRangeValue): boolean;
var
  left_, right_: WORD;
begin
  presetVolume(volume);
  left_ := DWORD(LOWORD(_high_volume) - LOWORD(_low_volume)) * _volume div 100 + LOWORD(_low_volume);
  right_ := DWORD(HIWORD(_high_volume) - HIWORD(_low_volume)) * _volume div 100 + HIWORD(_low_volume);
  Result := initialize() and (_curr_voice > -1) and (_iAttributes <> nil) and (_high_volume > 0) and
            Succeeded(_iAttributes.VolumeSet(DWORD(left_ or right_ shl 16)));
//  MessageBox(0, PChar('setVolume: ' + IntToHex(DWORD(left_ or right_ shl 16), 8)), nil, 0);
//            Succeeded(_pCentral.Inject(PChar(Format('\Vol=%d\',
//                      [round((_highVolume - _lowVolume) * (volume / 100)) + _lowVolume]))));
end;

procedure TSAPI4Speaker.speak(const phrase: string);
var
  data_: TSData;
begin
  if initialize() and (_curr_voice > -1) then
  begin
    if _pCentral = nil then
    begin
//      RichEdit1.Lines.Add('The Engine object does not exist.');
      exit;
    end;

    data_.dwSize := Length(phrase) + 1;
    data_.pData := PChar(phrase);

    if _flush_before_speak then
    begin
      flush();
    end;
    //_pCentral.TextData(CHARSET_TEXT, 0, data_, pointer(fTTSBufNotifySink), IID_ITTSBufNotifySink));
    _pCentral.TextData(CHARSET_TEXT, 0, data_, nil, IID_ITTSBufNotifySink);
{
    if Succeeded(_pCentral.TextData(CHARSET_TEXT, 0, data_, nil, IID_ITTSBufNotifySink)) then
        MessageBox(0, 'Speak Success', nil, MB_OK)
      else
        MessageBox(0, 'Speak Failed', nil, MB_OK);
}
  end;
end;

{ TSAPI5Speaker }

{
type
  TSpNotifyCallback = procedure(wParam: WPARAM; lParam: LPARAM); stdcall;

function SAPI5NotifyCallback(wParam: WPARAM; lParam: LPARAM): HRESULT; stdcall;
var
  pEvent: SPEVENT;

  procedure clearEvent();
  begin
    if pEvent.elParamType <> SPEI_UNDEFINED then
    begin
      if (pEvent.elParamType = SPET_LPARAM_IS_POINTER) or (pEvent.elParamType = SPET_LPARAM_IS_STRING) then
          CoTaskMemFree(Pointer(pEvent.lParam))
      else
        if (pEvent.elParamType = SPET_LPARAM_IS_TOKEN) or (pEvent.elParamType = SPET_LPARAM_IS_OBJECT) then
          IUnknown(pEvent.lParam) := nil;
    end;
    FillChar(pEvent, sizeof(pEvent), 0);
  end;

begin
  FillChar(pEvent, sizeof(pEvent), 0);

  while TSAPI5Speaker(Pointer(lParam))._pVoice.GetEvents(1, pEvent, nil) = S_OK do
  begin
    case pEvent.eEventId of
      SPEI_END_INPUT_STREAM: ;
//        SetEvent(TSAPI5Speaker(Pointer(lParam))._window_handle);
    end;
    clearEvent();
  end;
  clearEvent();

  Result := 0;
end;
}
constructor TSAPI5Speaker.create(wnd_handle: THandle);
begin
  inherited;
 _pVoice := nil;
end;

procedure TSAPI5Speaker.deinitialize;
begin
  inherited;
  _pVoice := nil;
end;

procedure TSAPI5Speaker.flush;
begin
  if initialize() and (_curr_voice > -1) then
  begin
    _pVoice.Speak(nil, SPF_PURGEBEFORESPEAK, nil);
  end;
end;

function TSAPI5Speaker.getVoices(const sl: TStringList): boolean;
var
  pToken_: ISpObjectToken;
  pwstrDesc_: PWideChar;
  pwstrLang_: PWideChar;
  wstrLang_: array[0..9] of WideChar;
  psv_: PSpeakerVoice;
  i_: integer;
begin
  Result := initialize();
  if Result then
  begin
    pwstrLang_ := wstrLang_;
    wstrLang_[MultiByteToWideChar(0, 0, PChar(IntToHex(SysLocale.DefaultLCID, 8)),
      Length(IntToHex(SysLocale.DefaultLCID, 8)), wstrLang_, 10)] := #0;

    _pEnum.Reset();
    i_ := 0;
    while _pEnum.Next(1, pToken_, nil) = S_OK do
    begin
      if pToken_.GetStringValue(pwstrLang_, pwstrDesc_) = SPERR_NOT_FOUND then
        pToken_.GetStringValue(nil, pwstrDesc_);

      new(psv_);
      psv_._kind := skSAPI5;
      psv_._index := i_;
      inc(i_);
      sl.AddObject(pwstrDesc_ + ' [SAPI5]', TObject(psv_));
      CoTaskMemFree(pwstrDesc_);
      pToken_ := nil;
    end;
  end;
end;

function TSAPI5Speaker.initialize: boolean;
begin
  Result := _initialized;
  if Result then
    exit;

  if Succeeded(CoCreateInstance(CLSID_SpVoice, nil, CLSCTX_ALL,
     IID_ISpVoice, _pVoice)) then
  begin
    _volumeSupported := true;
    _rateSupported := true;
//    RichEdit1.Lines.Add('CoCreateInstance IID_ISpVoice Success');
//    _pVoice.SetNotifyCallbackFunction(@SAPI5NotifyCallback, 0, LPARAM(Pointer(Self)));
//    _pVoice.SetInterest(SPEI_END_INPUT_STREAM, SPEI_END_INPUT_STREAM);

    if Succeeded(CoCreateInstance(CLSID_SpObjectTokenCategory, nil, CLSCTX_ALL,
       IID_ISpObjectTokenCategory, _pTokenCategory)) then
    begin
//      RichEdit1.Lines.Add('CoCreateInstance IID_ISpObjectTokenCategory Success');
      if Succeeded(_pTokenCategory.SetId(SPCAT_VOICES, 0)) then
      begin
        if Succeeded(_pTokenCategory.EnumTokens(nil, nil, _pEnum)) then
          Result := true;
      end;
{
    end
    else
    begin
      RichEdit1.Lines.Add('CoCreateInstance IID_ISpObjectTokenCategory Failed');
}
    end;
{
  end
  else
  begin
    RichEdit1.Lines.Add('CoCreateInstance IID_ISpVoice Failed');
}
  end;
  if not Result then
  begin
    _pEnum := nil;
    _pTokenCategory := nil;
    _pVoice := nil;
  end
  else
    _initialized := true;
end;

procedure TSAPI5Speaker.resetSettings;
begin
  if initialize() and (_curr_voice > -1) then
  begin
    presetVolume(_default_volume);
    _pVoice.SetVolume(_default_volume);
    presetRate((_default_rate * 100 + 1000) div 20);
    _pVoice.SetRate(_default_rate);
  end;
end;

function TSAPI5Speaker.selectVoice(index: integer): boolean;
var
  pToken_, pOldToken_: ISpObjectToken;
  i_: integer;
  tmp_value_: WORD;
begin
  Result := initialize();
  if Result then
  begin
    Result := false;
    _pEnum.Reset;
    for i_ := 0 to index do
    begin
      pToken_ := nil;
      _pEnum.Next(1, pToken_, nil);
    end;
    if pToken_ <> nil then
    begin
      if _pVoice.GetVoice(pOldToken_) = S_OK then
      begin
        if pToken_ <> pOldToken_ then
        begin
          flush();
          Result := _pVoice.SetVoice(pToken_) = S_OK;
        end;
        pOldToken_ := nil;
      end;
{
      if Result then
        RichEdit1.Lines.Add('Engine Select Success')
      else
        RichEdit1.Lines.Add('Engine Select Failed');
}
    end;
    if Result then
    begin
      _pVoice.GetVolume(tmp_value_);
      _default_volume := tmp_value_;
      _pVoice.GetRate(i_);
      _default_rate := i_;
      _curr_voice := index;
      setVolume(_volume);
      setRate(_rate);
    end;
  end;
end;

function TSAPI5Speaker.setRate(const rate: TSpeakerRangeValue): boolean;
begin
  presetRate(rate);
  Result := initialize() and (_curr_voice > -1) and
            Succeeded(_pVoice.SetRate(20 * rate div 100 - 10));
end;

function TSAPI5Speaker.setVolume(const volume: TSpeakerRangeValue): boolean;
begin
  presetVolume(volume);
  Result := initialize() and (_curr_voice > -1) and
            Succeeded(_pVoice.SetVolume(volume));
end;

procedure TSAPI5Speaker.speak(const phrase: string);
var
  wstr_: WideString;
begin
  if initialize() and (_curr_voice > -1) then
  begin
// TODO????
    wstr_ := phrase;
//    wstr_[MultiByteToWideChar(0, 0, PChar(phrase), Length(phrase), wstr_, 10)] := #0;
    if _flush_before_speak then
    begin
      flush();
    end;
    _pVoice.Speak(PWideChar(wstr_), SPF_ASYNC or SPF_IS_NOT_XML, nil);
  end;
end;

{ TTSNotifySink }
{
function TTSNotifySink.AttribChanged(dwAttribute: DWORD): HRESULT;
begin
  Result := S_OK;
end;

function TTSNotifySink.AudioStart(qTimeStamp: QWORD): HRESULT;
begin
  Result := S_OK;
end;

function TTSNotifySink.AudioStop(qTimeStamp: QWORD): HRESULT;
begin
  Result := S_OK;
//  SetEvent(_speaker._window_handle);
end;

constructor TTSNotifySink.create(speaker: TSAPI4Speaker);
begin
  _speaker := speaker;
end;

function TTSNotifySink.Visual(qTimeStamp: QWORD; cIPAPhoneme,
  cEnginePhoneme: Char; dwHints: DWORD; apTTSMouth: PTTSMouth): HRESULT;
begin
  Result := S_OK;
end;
}

{ TExpressIVOSpeaker }

constructor TExpressIVOSpeaker.create(wnd_handle: THandle);
begin
  inherited;
  _socket := INVALID_SOCKET;
end;

procedure TExpressIVOSpeaker.deinitialize;
var
  strParam: string;
begin
  if _initialized then
  begin
    send(eicClose, strParam);
    closesocket(_socket);
    WSACleanup();
  end;
  inherited;
end;

procedure TExpressIVOSpeaker.flush;
var
  strParam: string;
begin
  if initialize() and (_curr_voice > -1) then
  begin
    strParam := '';
    if send(eicIsSpeaking, strParam) = eisrYES then
      send(eicStop, strParam);
  end;
end;

function TExpressIVOSpeaker.getVoices(const sl: TStringList): boolean;
var
  strParam: string;
  pSV: PSpeakerVoice;
begin
  Result := initialize();
  if Result then
  begin
    send(eicVersion, strParam);
    new(pSV);
    pSV._kind := skExpressIVO;
    pSV._index := 0;
    sl.AddObject('ExpressIVO ' + strParam, TObject(pSV));
  end;
end;

function TExpressIVOSpeaker.initialize: boolean;
var
  WSAData: TWSAData;
  SockAddrIn: TSockAddrIn;
  szResult: array[0..5] of char;
  nBlock: integer;
begin
  Result := _initialized;
  if Result then
    exit;

  Result := isWinSock2Supported and (WSAStartup($0202, WSAData) = 0);
  if Result then
  begin
    _socket := socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
    if _socket = INVALID_SOCKET then
      exit;

    WSAAsyncSelect(_socket, 0, 0, 0);
    nBlock := 0;
    ioctlsocket(_socket, FIONBIO, nBlock);

    SockAddrIn.sin_family := PF_INET;
    SockAddrIn.sin_addr.s_addr := inet_addr('127.0.0.1');
    SockAddrIn.sin_port := htons(17024);

    Result := connect(_socket, @SockAddrIn, SizeOf(SockAddrIn)) = 0;
    if Result then
    begin
      recv();
//      _volumeSupported := true;
//      _rateSupported := true;
      _default_volume := 50;
      _default_rate := 50;
    end;

    _initialized := Result;
  end;

  if not Result then
    _socket := INVALID_SOCKET;
end;

function TExpressIVOSpeaker.recv: string;
var
  cResult: char;
  nLength: u_long;
begin
  Result := '';
  ioctlsocket(_socket, FIONREAD, nLength);
  while (WinSock2.recv(_socket, cResult, 1, 0) = 1) and (cResult <> #10) do
    if cResult >= ' ' then
      Result := Result + cResult;
end;

procedure TExpressIVOSpeaker.resetSettings;
var
  strParam: string;
begin
  if initialize() and (_curr_voice > -1) then
  begin
    strParam := '';
    send(eicDefault, strParam);
  end;
end;

function TExpressIVOSpeaker.selectVoice(index: integer): boolean;
begin
  Result := index = 0;
  if Result then
  begin
    _curr_voice := index;
    setVolume(_volume);
    setRate(_rate);
  end;
end;

function TExpressIVOSpeaker.send(const eicCmd: TExpressIVOCommandType;
  var strParam: string): TExpressIVOServerResponseType;
const
  szCmdArray: array[TExpressIVOCommandType] of string =
  (
    'SayIt|', 'Pause', 'Resume', 'Stop', 'IsSpeaking', 'Pitch|', 'Spd|', 'Vol|',
    'Default', 'Close', 'Version', 'Voice'
  );
  szResultArray: array[TExpressIVOServerResponseType] of string =
  (
    'OK', 'ERR', 'RANGE', 'YES', 'NO', 'UNK'
  );
var
  i: TExpressIVOServerResponseType;
begin
  strParam := szCmdArray[eicCmd] + strParam + #13#10;
  if (WinSock2.send(_socket, Pointer(strParam)^, Length(strParam), 0) = Length(strParam)) then
    strParam := recv;
//  else
//  begin
//    MessageBox(0, PChar(Format('[%x] %s', [WSAGetLastError(), SysErrorMessage(WSAGetLastError())])), nil, 0);
//  end;

  for i := Low(TExpressIVOServerResponseType) to High(TExpressIVOServerResponseType) do
    if szResultArray[i] = strParam then
    begin
      Result := i;
      exit;
    end;

  Result := eisrUNK;
end;

function TExpressIVOSpeaker.setRate(
  const rate: TSpeakerRangeValue): boolean;
var
  strParam: string;
begin
  exit;
  if initialize() and (_curr_voice > -1) then
  begin
    strParam := IntToStr(rate);
    send(eicSpeed, strParam);
  end;
end;

function TExpressIVOSpeaker.setVolume(
  const volume: TSpeakerRangeValue): boolean;
var
  strParam: string;
begin
  exit;
  if initialize() and (_curr_voice > -1) then
  begin
    strParam := IntToStr(volume);
    send(eicVolume, strParam);
  end;
end;

procedure TExpressIVOSpeaker.speak(const phrase: string);
var
  strParam: string;
begin
  if initialize() and (_curr_voice > -1) then
  begin
    if not _flush_before_speak then
    begin
      while send(eicIsSpeaking, strParam) = eisrYES do
      begin
        Sleep(50);
        strParam := '';
      end;
//      flush();
    end;
    strParam := phrase;
    send(eicSayIt, strParam);
  end;
end;

end.
