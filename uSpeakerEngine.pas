unit uSpeakerEngine;

interface

uses
  Windows, Classes, Messages, SysUtils, Forms, ActiveX, uSpeakers;

type
  TSpeakerEngine = class(TObject)
  private
    _speakers: array[TSpeakerKind] of TAbstractSpeaker;
    _currentSpeaker: TAbstractSpeaker;
    _voices_list: TStringList;

    _thread: THandle;
    _cs: TRTLCriticalSection;
    _handle: THandle;

    _initialised: boolean;

    _last_phrase: string;
    _flush_before_speak: boolean;

    _volume: TSpeakerRangeValue;
    _rate: TSpeakerRangeValue;

    function windowProc(hWnd: HWND; Msg, wParam, lParam: cardinal): cardinal;
    function populateVoices(): boolean;
    function getVoice(i: integer): string;
    procedure clearVoiceList;
  protected

  public
    constructor create;
    destructor destroy; override;

    function initialise(): boolean;
    procedure deinitialise();

    function isInitialised(): boolean;
    function changeVoice(i: integer; volume, rate: TSpeakerRangeValue): boolean; overload;
    function changeVoice(engine: WORD; i: WORD; volume, rate: TSpeakerRangeValue): boolean; overload;

    function setVolume(const volume: TSpeakerRangeValue): boolean;
    function getVolume(): TSpeakerRangeValue;
    function setRate(const rate: TSpeakerRangeValue): boolean;
    function getRate(): TSpeakerRangeValue;
    function volumeAvailable(): boolean;
    function rateAvailable(): boolean;
    procedure resetSettings();

    procedure speak(const phrase: string);
    procedure setFlushBeforeSpeak(const state: boolean);
    procedure flush();

    function getVoicesCount(): integer;
    property voices[i: integer]: string read getVoice;
  end;

implementation

function WindowProc(hWnd: HWND; Msg, wParam, lParam: cardinal): cardinal; stdcall;
begin
  Result := TSpeakerEngine(Pointer(GetWindowLong(hWnd, GWL_USERDATA))).WindowProc(hWnd, Msg, wParam, lParam);
  if Result = 0 then
    Result := DefWindowProc(hWnd, Msg, wParam, lParam);
end;

const
  classNameSpeaker = 'CinemaPlayer_Speaker';
  WM_GETVOICES     = WM_APP + 1;
  WM_CHANGEVOICE   = WM_APP + 2;
  WM_SPEAK         = WM_APP + 3;
  WM_SETVOLUME     = WM_APP + 4;
  WM_SETRATE       = WM_APP + 5;
  WM_TERMINATE     = WM_APP + 6;
  WM_FLUSH         = WM_APP + 7;
  WM_FLUSHBEFSPEAK = WM_APP + 8;

// w¹tek spikera
function speak_thread(speaker: TSpeakerEngine): integer;
var
  wc: WNDCLASS;
  msg: TMsg;
begin
  CoInitializeEx(nil, COINIT_APARTMENTTHREADED);
  try
    wc.style := 0;
    wc.lpfnWndProc := @WindowProc;
    wc.cbClsExtra := 0;
    wc.cbWndExtra := 0;
    wc.hInstance := hInstance;
    wc.hIcon := 0;
    wc.hCursor := 0;
    wc.hbrBackground := 0;
    wc.lpszMenuName := nil;
    wc.lpszClassName := classNameSpeaker;

    Windows.RegisterClass(wc);
    speaker._handle := CreateWindowEx(
      WS_EX_TOOLWINDOW,
      classNameSpeaker,
      nil,
      WS_POPUP,
      0, 0, 0, 0,
      Application.Handle,
      0,
      hInstance,
      nil
    );
    SetWindowLong(speaker._handle, GWL_USERDATA, Integer(Pointer(speaker)));

    while GetMessage(msg, 0, 0, 0) do
    begin
      TranslateMessage(msg);
      DispatchMessage(msg);
    end;
  except
  end;
  Windows.UnRegisterClass(classNameSpeaker, hInstance);

  CoUninitialize();  // This is only for the worker thread.
  Result := 0;
end;

{ TSpeakerEngine }

constructor TSpeakerEngine.create;
begin
  InitializeCriticalSection(_cs);
  _speakers[skExpressIVO] := TExpressIVOSpeaker.create(_handle);
  _speakers[skSAPI4] := TSAPI4Speaker.create(_handle);
  _speakers[skSAPI5] := TSAPI5Speaker.create(_handle);
  _voices_list := TStringList.create;
  _initialised := false;
end;

destructor TSpeakerEngine.destroy;
begin
  deinitialise();
  DeleteCriticalSection(_cs);
  _speakers[skExpressIVO].Free;
  _speakers[skSAPI4].Free;
  _speakers[skSAPI5].Free;
  _voices_list.Free;
  inherited Destroy;
end;

function TSpeakerEngine.populateVoices(): boolean;
begin
  EnterCriticalSection(_cs);
  try
    Result := SendMessage(_handle, WM_GETVOICES, 0, 0) = 1;
  finally
    LeaveCriticalSection(_cs);
  end;
end;

function TSpeakerEngine.changeVoice(i: integer; volume, rate: TSpeakerRangeValue): boolean;
begin
  if (i < 0) or (i >= _voices_list.Count) then
    Result := false
  else
    with PSpeakerVoice(_voices_list.Objects[i])^ do
      Result := changeVoice(WORD(_kind), _index, volume, rate);
end;

function TSpeakerEngine.changeVoice(engine, i: WORD; volume, rate: TSpeakerRangeValue): boolean;
begin
  if _initialised then
  begin
    _volume := volume;
    _rate := rate;
    Result := SendMessage(_handle, WM_CHANGEVOICE, engine, i) = 1;
  end
  else
    Result := false;
end;

procedure TSpeakerEngine.speak(const phrase: string);
begin
  if _last_phrase <> phrase then
  begin
    PostMessage(_handle, WM_SPEAK, 0, LPARAM(PChar(phrase)));
    _last_phrase := phrase;
  end;
end;

function TSpeakerEngine.isInitialised: boolean;
begin
  Result := _initialised;
end;

function TSpeakerEngine.windowProc(hWnd: HWND; Msg, wParam,
  lParam: cardinal): cardinal;
begin
  Result := 0;
  case Msg of
    WM_GETVOICES:
    begin
      _speakers[skExpressIVO].getVoices(_voices_list);
      _speakers[skExpressIVO].deinitialize;
      _speakers[skSAPI4].getVoices(_voices_list);
      _speakers[skSAPI4].deinitialize;
      _speakers[skSAPI5].getVoices(_voices_list);
      _speakers[skSAPI5].deinitialize;
      Result := 1;
    end;
    WM_CHANGEVOICE:
    begin
      if (_currentSpeaker <> nil) and (_currentSpeaker <> _speakers[TSpeakerKind(wParam)]) then
        _currentSpeaker.flush();

      _currentSpeaker := _speakers[TSpeakerKind(wParam)];
      _currentSpeaker.setFlushBeforeSpeak(_flush_before_speak);
//  MessageBox(0, PChar('wndproc Volume: ' + IntToStr(_volume)), nil, 0);
      _currentSpeaker.presetVolume(_volume);
//  MessageBox(0, PChar('wndproc rate: ' + IntToStr(_rate)), nil, 0);
      _currentSpeaker.presetRate(_rate);
      _currentSpeaker.selectVoice(lParam);
      Result := 1;
    end;
    WM_SPEAK:
    begin
      try
        EnterCriticalSection(_cs);
        if _currentSpeaker <> nil then
        begin
          _currentSpeaker.speak(PChar(lParam));
          Result := 1;
        end
        else
          Result := 0;
      finally
        LeaveCriticalSection(_cs);
      end;
    end;
    WM_SETVOLUME:
    begin
      if _currentSpeaker <> nil then
      begin
        _currentSpeaker.setVolume(wParam);
        Result := 1;
      end
      else
        Result := 0;
    end;
    WM_SETRATE:
    begin
      if _currentSpeaker <> nil then
      begin
        _currentSpeaker.setRate(wParam);
        Result := 1;
      end
      else
        Result := 0;
    end;
    WM_FLUSH:
    begin
      if _currentSpeaker <> nil then
      begin
        _currentSpeaker.flush();
        Result := 1;
      end
      else
        Result := 0;
    end;
    WM_FLUSHBEFSPEAK:
    begin
      if _currentSpeaker <> nil then
      begin
        _currentSpeaker.setFlushBeforeSpeak(wParam <> 0);
        Result := 1;
      end
      else
        Result := 0;
    end;
    WM_TERMINATE:
    begin
      _speakers[skExpressIVO].deinitialize;
      _speakers[skSAPI4].deinitialize;
      _speakers[skSAPI5].deinitialize;
      DestroyWindow(_handle);
      PostQuitMessage(0);
    end;
  end;
end;

function TSpeakerEngine.setRate(const rate: TSpeakerRangeValue): boolean;
begin
  _rate := rate;
  PostMessage(_handle, WM_SETRATE, rate, 0);
  Result := true;
end;

function TSpeakerEngine.setVolume(const volume: TSpeakerRangeValue): boolean;
begin
  _volume := volume;
  PostMessage(_handle, WM_SETVOLUME, volume, 0);
  Result := true;
end;

function TSpeakerEngine.rateAvailable: boolean;
begin
  Result := (_currentSpeaker <> nil) and _currentSpeaker.rateAvailable();
end;

function TSpeakerEngine.volumeAvailable: boolean;
begin
  Result := (_currentSpeaker <> nil) and _currentSpeaker.volumeAvailable();
end;

function TSpeakerEngine.getVoice(i: integer): string;
begin
  Result := _voices_list[i];
end;

function TSpeakerEngine.getVoicesCount: integer;
begin
  Result := _voices_list.Count;
end;

procedure TSpeakerEngine.clearVoiceList;
var
  i: integer;
begin
  for i := 0 to _voices_list.Count - 1 do
    Dispose(PSpeakerVoice(_voices_list.Objects[i]));
  _voices_list.Clear;
end;

function TSpeakerEngine.initialise: boolean;
var
  i_: byte;
  ti_: DWORD;
begin
  if not _initialised then
  begin
    if _thread = 0 then
    begin
      _thread := BeginThread(nil, 0, @speak_thread, Self, 0, ti_);
      SetThreadPriority(_thread, THREAD_PRIORITY_BELOW_NORMAL);
    end;

    i_ := 255;
    while (_handle = 0) and (i_ > 0) do
    begin
      Sleep(10);
      dec(i_);
    end;
    _initialised := populateVoices();
  end;
  Result := _initialised;
end;

procedure TSpeakerEngine.deinitialise;
begin
  if _thread <> 0 then
  begin
    flush();
    PostMessage(_handle, WM_TERMINATE, 0, 0);
    WaitForSingleObject(_thread, INFINITE);
    clearVoiceList();
    _thread := 0;
    _handle := 0;
    _currentSpeaker := nil;
    _last_phrase := '';
    _initialised := false;
  end;
end;

procedure TSpeakerEngine.flush;
begin
  if _initialised then
  begin
    PostMessage(_handle, WM_FLUSH, 0, 0);
    _last_phrase := '';
  end;
end;

procedure TSpeakerEngine.resetSettings;
begin
  if _currentSpeaker <> nil then
  begin
    _currentSpeaker.resetSettings();
    _volume := _currentSpeaker.getVolume();
    _rate := _currentSpeaker.getRate();
  end
  else
  begin
    _volume := 50;
    _rate := 50;
  end;
end;

function TSpeakerEngine.getRate: TSpeakerRangeValue;
begin
  Result := _rate;
end;

function TSpeakerEngine.getVolume: TSpeakerRangeValue;
begin
  Result := _volume;
end;

procedure TSpeakerEngine.setFlushBeforeSpeak(const state: boolean);
begin
  _flush_before_speak := state;
  PostMessage(_handle, WM_FLUSHBEFSPEAK, integer(state), 0);
end;

end.
