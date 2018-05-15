unit cp_RemoteControl;

interface

procedure CreateRemoteController;
procedure ActivateRemoteController;
procedure DestroyRemoteController;

const
  classNameRemote = 'CinemaPlayer_RemoteControl';

//var
//  ignore_activation: boolean = false;

implementation

uses Windows, Messages, SysUtils, Forms, main, global_consts, cp_utils;

var
  handle: HWND;

function ewActivateRemote(hwnd: HWND; lParam: LPARAM): boolean; stdcall;
var
  pid: DWORD;
  pid_CP: DWORD;
//  atom: DWORD;
  cn: char100;
  wt: string;
begin
  GetWindowThreadProcessId(hwnd, @pid);
  GetWindowThreadProcessId(frmCinemaPlayer.Handle, @pid_CP);
  FillChar(cn, 100, 0);
  GetClassName(hwnd, cn, 100);
  Result := true;
  if cn = classNameRemote then
  begin
    if ((pid = pid_CP) and (lParam = 0)) then
      wt := 'Remote'
    else
      if ((pid <> pid_CP) and (lParam = 2)) then
      begin
        wt := 'Remote';
        Result := false;
      end
      else
        wt := ' ';

    SetWindowText(hwnd, PChar(wt));
  end;
end;

function ewCloseDialog(hwnd: HWND; lParam: LPARAM): boolean; stdcall;
var
  pid: DWORD;
  atom: DWORD;
begin
  GetWindowThreadProcessId(hwnd, @pid);
  atom := GetClassLong(hwnd, GCW_ATOM);
  Result := not ((pid = DWORD(lParam)) and (atom = 32770));
  if not Result then
  begin
    SendMessage(hwnd, WM_CLOSE, 0, 0);
  end;
end;

function WindowProc(hWnd: HWND; Msg, wParam, lParam: cardinal): cardinal; stdcall;
var
  pid: DWORD;
begin
  if (Msg = WM_REMOTE) and (lParam = 0) then
  begin
    with frmCinemaPlayer do case LOWORD(wParam) of
      $00 .. $16, $1a .. $4d:
        PostMessage(frmCinemaPlayer.Handle, Msg, wParam or $8000, lParam);
      $17 .. $19:
        if frmCinemaPlayer.OpenActionActive then
        begin
          pid := GetCurrentProcessId();
          EnumWindows(@ewCloseDialog, pid);
        end
        else
          PostMessage(frmCinemaPlayer.Handle, Msg, wParam or $8000, lParam);
    end;
  end;
  Result := DefWindowProc(hWnd, Msg, wParam, lParam);
end;

function watek(p: Pointer): DWORD;
var
  wc: WNDCLASS;
  msg: TMsg;
begin
  wc.style := 0;
  wc.lpfnWndProc := @WindowProc;
  wc.cbClsExtra := 0;
  wc.cbWndExtra := 0;
  wc.hInstance := hInstance;
  wc.hIcon := 0;
  wc.hCursor := 0;
  wc.hbrBackground := 0;
  wc.lpszMenuName := nil;
  wc.lpszClassName := classNameRemote;

  RegisterClass(wc);
  handle := CreateWindowEx(
    WS_EX_TOOLWINDOW,
    classNameRemote,
    'Remote',
    WS_POPUP or WS_VISIBLE,
    -1000,
    -1000,
    0,
    0,
    Application.Handle,
    0,
    hInstance,
    nil
  );

  SetFocus(frmCinemaPlayer.Handle);

  while GetMessage(msg, 0, 0, 0) do
  begin
    TranslateMessage(msg);
    DispatchMessage(msg);
  end;

  UnRegisterClass(classNameRemote, hInstance);

  Result := 1;
end;

procedure ActivateRemoteController;
begin
  EnumWindows(@ewActivateRemote, 0);
end;

procedure CreateRemoteController;
var
  id: cardinal;
begin
  BeginThread(nil, 0, @watek, nil, 0, id);
end;

procedure DestroyRemoteController;
begin
  if handle <> 0 then
    DestroyWindow(handle);

  EnumWindows(@ewActivateRemote, 1);
  EnumWindows(@ewActivateRemote, 2);
end;

end.
