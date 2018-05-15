unit closing;

interface

uses Windows, SysUtils, Graphics, Forms, Messages;

procedure TurnOffSystem;

implementation

uses global_consts, language, settings_header;

type
  TCloseSystemType = (csSuspend, csShutdown, csHibernate);

const
  IDD_SHUTDOWN                    = 18000;
  IDC_PROGRESS                    = 18001;

var
  TimeCount: integer;
  mnoznik: double;
  hDlg: HWND = 0;
  oldProgressWndProc: Pointer;

procedure closeSystem(cs: TCloseSystemType);

  procedure sleepSystem(bHibernate: boolean);
  type
    TSetSuspendState = function(Hibernate, ForceCritical, DisableWakeEvent: BOOLEAN): BOOLEAN; stdcall;
  const
    powrprof_lib = 'powrprof.dll';
    setsuspstate_fun = 'SetSuspendState';
  var
    SetSuspendState: TSetSuspendState;
    ModuleHandle: HMODULE;
  begin
    ModuleHandle := LoadLibrary(powrprof_lib);
    if ModuleHandle = 0 then
      raise Exception.Create('Library not found: ' + powrprof_lib);

    SetSuspendState := GetProcAddress(ModuleHandle, setsuspstate_fun);
    if Assigned(SetSuspendState) then
      SetSuspendState(bHibernate, false, false)
    else
      SetSystemPowerState(not bHibernate, true);
    if ModuleHandle <> 0 then
      FreeLibrary(ModuleHandle);
  end;

  function adjustPrivilenges(): boolean;
  var
    iToken: THandle;
    iPriveleg: TTokenPrivileges;
    iaresult: cardinal;
  begin
    if Win32Platform <> VER_PLATFORM_WIN32_NT then
    begin
      Result := true;
    end
    else
    begin
      Result := false;
      FillChar(iPriveleg, SizeOf(iPriveleg), #0);
      if OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, iToken) and
         LookupPrivilegeValue(nil, 'SeShutdownPrivilege', iPriveleg.Privileges[0].Luid) then
      begin
        iPriveleg.PrivilegeCount := 1;
        iPriveleg.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
        if AdjustTokenPrivileges(iToken, False, iPriveleg,
                    Sizeof(iPriveleg), iPriveleg, iaresult) then
          Result := true;
      end;
    end;
  end;

begin
  if adjustPrivilenges() then
    case cs of
      csSuspend:
        sleepSystem(false);
      csHibernate:
        sleepSystem(true);
      csShutdown:
      begin
        ExitWindowsEx(EWX_POWEROFF or EWX_SHUTDOWN, 0);
        Application.Terminate;
      end;
    end;
end;


procedure KillSystem;
var
  cs: TCloseSystemType;
begin
  if hDlg <> 0 then
    EndDialog(hDlg, 0);
  cs := TCloseSystemType(config.Shutdown);
  closeSystem(cs);
end;

function wndProgressProc(_hWnd: HWND; msg: UINT; wParam, LParam: longint): longint; stdcall;
var
  myRect: TRect;
  ps: PAINTSTRUCT;
  brush: HBRUSH;
  wndText: array[0..20] of char;
begin
  Result := 0;
  case msg of
    WM_PAINT:
    begin
      wParam := BeginPaint(_hWnd, ps);
      if wParam <> 0 then
      begin
        GetClientRect(_hWnd, myRect);
        myRect.Left := myRect.Right - round(TimeCount * mnoznik);
        brush := CreateSolidBrush(ColorToRGB(clWindow));
        FillRect(wParam, myRect, brush);
        DeleteObject(brush);
        brush := CreateSolidBrush(PatternColor);
        GetClientRect(_hWnd, myRect);
        myRect.Right := myRect.Right - round(TimeCount * mnoznik);
        FillRect(wParam, myRect, brush);
        DeleteObject(brush);

        GetClientRect(_hWnd, myRect);
        GetWindowText(_hWnd, wndText, 21);
        SetTextColor(wParam, ColorToRGB(clWindowText));
        SetBkMode(wParam, TRANSPARENT);
        DrawText(wParam, wndText, -1, myRect, DT_CENTER or DT_VCENTER or DT_SINGLELINE);
      end;
      EndPaint(_hWnd, ps);
    end;
    else result := CallWindowProc(oldProgressWndProc, _hWnd, msg, wParam, lParam);
  end;
end;

function wndProc(_hWnd: HWND; msg: UINT; wParam, LParam: longint): longint; stdcall;
var
  myRect: TRect;
begin
  Result := 0;
  case msg of
    WM_INITDIALOG:
    begin
      hDlg := _hWnd;
      SetWindowText(GetDlgItem(_hWnd, IDCANCEL), PChar(LangStor[LNG_CANCEL]));

      TimeCount := config.ShutdownDelay;
      GetClientRect(GetDlgItem(_hWnd, IDC_PROGRESS), myRect);
      mnoznik := (myRect.Right - myRect.Left) / TimeCount;
      oldProgressWndProc := Pointer(SetWindowLong(GetDlgItem(_hWnd, IDC_PROGRESS), GWL_WNDPROC, integer(@wndProgressProc)));
      SetDlgItemText(_hWnd, IDC_PROGRESS, PChar(Format(' %d %s', [TimeCount, LangStor[LNG_OPT_SECOND]])));
      InvalidateRect(GetDlgItem(_hWnd, IDC_PROGRESS), nil, false);
      SetTimer(_hWnd, 100, 1000, nil);
    end;
    WM_TIMER:
    begin
      if wParam = 100 then
      begin
        if TimeCount = 0 then
        begin
          KillSystem();
          KillTimer(_hWnd, 100);
          EndDialog(_hWnd, 0);
        end
        else
          dec(TimeCount);
        SetDlgItemText(_hWnd, IDC_PROGRESS, PChar(Format(' %d %s', [TimeCount, LangStor[LNG_OPT_SECOND]])));
        InvalidateRect(GetDlgItem(_hWnd, IDC_PROGRESS), nil, false);
      end;
    end;
    WM_COMMAND:
    begin
      case wParam of
        IDCANCEL:
        begin
          KillTimer(_hWnd, 100);
          EndDialog(_hWnd, 0);
        end;
      end;
    end;
    WM_CLOSE:
      SetWindowLong(GetDlgItem(_hWnd, IDC_PROGRESS), GWL_WNDPROC, integer(oldProgressWndProc));
    else Result := DefWindowProc(_hWnd, msg, wParam, lParam);
  end;
end;

procedure TurnOffSystem;
begin
  if config.WaitShutdown then
  begin
    DialogBox(hInstance, MAKEINTRESOURCE(IDD_SHUTDOWN), Application.Handle, @wndProc);
    hDlg := 0;
  end
  else
    KillSystem;
end;

end.
