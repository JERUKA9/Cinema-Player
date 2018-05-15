unit logger;

interface

uses
  Windows;

procedure _debug(s: string);
procedure _debugFmt(s: string; const Args: array of const);
procedure _debug_win_error();
procedure _debug_register_thread(name: string; id: DWORD = 0);

procedure _trace(const s: string); overload;
procedure _trace(const s: string; params: array of const); overload;

implementation

uses
  Classes, SysUtils;

type
  TLogger = class(TObject)
  private
    _cs: TRTLCriticalSection;
//    _sl: TStringList;
    _threads: TStringList;

    procedure save;
  public
    constructor create();
    destructor destroy; override;

    procedure debug(s: string);
    procedure win_error;
    procedure registerThread(name: string; id: DWORD);
  end;

var
  _logger: TLogger;

procedure _trace(const s: string; params: array of const);
begin
  OutputDebugString(PChar(Format(s, params)));
end;

procedure _trace(const s: string);
begin
  OutputDebugString(PChar(s));
end;

procedure _debug_win_error();
begin
  _logger.win_error;
end;

procedure _debug(s: string);
begin
  _logger.debug(s);
end;

procedure _debugFmt(s: string; const Args: array of const);
begin
  _logger.debug(Format(s, Args));
end;

procedure _debug_register_thread(name: string; id: DWORD);
var
  id_: DWORD;
begin
  if id = 0 then
    id_ := GetCurrentThreadId
  else
    id_ := id;
  _logger.registerThread(name, id_);
end;

{ TLogger }

constructor TLogger.create();
begin
  InitializeCriticalSection(_cs);
//  _sl := TStringList.Create;
  _threads := TStringList.Create;
end;

procedure TLogger.debug(s: string);
var
  thread_name_: string;
  i_: integer;
  date_: string;
  time_: string;
  SystemTime_: TSystemTime;

  t: TextFile;
begin
  EnterCriticalSection(_cs);
  i_ := _threads.IndexOfObject(TObject(GetCurrentThreadId));
  if i_ = -1 then
    thread_name_ := IntToHex(GetCurrentThreadId, 8)
  else
    thread_name_ := _threads[i_];
  GetLocalTime(SystemTime_);
  with SystemTime_ do
  begin
    date_ := Format('%02d-%02d-%02d', [wDay, wMonth, wYear mod 100]);
    time_ := Format('%02d:%02d:%02d.%03d', [wHour, wMinute, wSecond, wMilliseconds]);
  end;
  for i_ := 1 to 7 do
    if date_[i_] = ' ' then date_[i_] := '0';
  for i_ := 1 to 12 do
    if time_[i_] = ' ' then time_[i_] := '0';

  Assign(t, ChangeFileExt(ParamStr(0), '.log'));
  Append(t);
  Writeln(t,
    date_ + ' ' + time_ + ' ' +
    Format('%-10s', [thread_name_]) + ':' + s);
  save;
  CloseFile(t);
  LeaveCriticalSection(_cs);
end;

destructor TLogger.destroy;
begin
  save;
  DeleteCriticalSection(_cs);
//  _sl.Free;
  _threads.Free;
  inherited;
end;

procedure TLogger.registerThread(name: string; id: DWORD);
begin
  EnterCriticalSection(_cs);
  if _threads.IndexOfObject(TObject(id)) = -1 then
    _threads.Objects[_threads.Add(name)] := TObject(id);
  LeaveCriticalSection(_cs);
end;

procedure TLogger.save;
begin
//  _sl.SaveToFile(ChangeFileExt(ParamStr(0), '.log'));
end;

procedure TLogger.win_error;
var
  gle: cardinal;
begin
  gle := GetLastError;
  debug(Format('%s: [%.8x]', [SysErrorMessage(gle), gle]));
end;

initialization

  _logger := TLogger.create();
  _debug_register_thread('main');
{  if FileExists(ChangeFileExt(ParamStr(0), '.log')) then
  begin
    _logger._sl.LoadFromFile(ChangeFileExt(ParamStr(0), '.log'));
    _logger._sl.Add('');
    _logger._sl.Add('');
  end;
}//  _logger._sl.Add('=================================================================================');
  _debug('========================= Begin session ==============================');
  _debug('');

finalization

  _debug('');
  _debug('========================== End session ===============================');
//  _logger._sl.Add('=================================================================================');
  _logger.Free;

end.
