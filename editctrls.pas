unit editctrls;

interface

uses
  Windows, Messages, commctrl, SysUtils, global_consts;

procedure regIntEditClass;
procedure regTimeEditClass;
//procedure freeEnhEditClass;
procedure unregIntEditClass;
procedure unregTimeEditClass;

const
  IEM_SETRANGE          = UDM_SETRANGE;
  IEM_SETPOS            = UDM_SETPOS;

  TEM_GETTIME           = WM_USER + 100;
  TEM_SETTIME           = WM_USER + 101;

implementation

const
  IDC_SPIN      = 100;

var
  editWndProc: Pointer;

function checkNewValue(hWnd: HWND; ptxt: Pchar100; to_add: string;
  modify: boolean): boolean;
var
  sel_pos, range: record
    case boolean of
      false:
        (dw: DWORD);
      true:
        (lo: WORD;
         hi: WORD);
  end;
  value: WORD;
  s: string;
begin
  ptxt[GetWindowText(hWnd, ptxt^, 100)] := #0;
  s := ptxt^;
  range.dw := SendDlgItemMessage(hWnd, IDC_SPIN, UDM_GETRANGE, 0, 0);
  if modify then
  begin
    sel_pos.dw := SendMessage(hWnd, EM_GETSEL, 0, 0);
    StrPCopy(ptxt^, Copy(ptxt^, 1, sel_pos.lo) + to_add + Copy(ptxt^, sel_pos.hi + 1, MaxInt));
  end;

  try
    value := StrToInt(ptxt^);
  except
    value := 0;
    ptxt^[0] := '0';
    ptxt^[1] := #0;
    if modify then
    begin
      Result := true;
      exit;
    end;
  end;

  if range.hi > value then
    StrPCopy(ptxt^, IntToStr(range.hi))
  else
    if range.lo < value then
      StrPCopy(ptxt^, IntToStr(range.lo));

  Result := s <> ptxt^;
end;

function intEditWndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): cardinal; stdcall;
var
  rc: TRect;
  updown_width: integer;
  txt: char100;
  hClip: THandle;
begin
  case Msg of
    WM_CREATE:
    begin
      GetClientRect(hWnd, rc);
      updown_width := GetSystemMetrics(SM_CXVSCROLL);
      rc.Left := rc.Right - updown_width;
      CreateWindowEx(
          0, UPDOWN_CLASS, nil,
          WS_CHILD or WS_VISIBLE or UDS_ARROWKEYS or UDS_SETBUDDYINT or UDS_NOTHOUSANDS,
          rc.Left, rc.Top, rc.Right - rc.Left, rc.Bottom - rc.Top,
          hWnd, IDC_SPIN, hInstance, nil);
      SendDlgItemMessage(hWnd, IDC_SPIN, UDM_SETRANGE, 0, MAKELONG(10, 0));
      SendDlgItemMessage(hWnd, IDC_SPIN, UDM_SETBUDDY, hWnd, 0);
      SetTimer(hWnd, 1000, 100, nil);
    end;
    WM_TIMER:
    begin
      KillTimer(hWnd, 1000);
      GetClientRect(hWnd, rc);
      updown_width := GetSystemMetrics(SM_CXVSCROLL);
      dec(rc.right, updown_width);
      SendMessage(hWnd, EM_SETRECTNP, 0, integer(@rc));
    end;
    WM_VSCROLL:
      if lParam = GetDlgItem(hWnd, IDC_SPIN) then
      begin
        SetWindowText(hWnd, PChar(IntToStr(HIWORD(wParam))));
        SendMessage(GetParent(hWnd), Msg, wParam, hWnd);
      end;
    WM_CHAR:
    begin
      Result := CallWindowProc(editWndProc, hWnd, Msg, wParam, lParam);
      if checkNewValue(hWnd, @txt, '', false) then
        SetWindowText(hWnd, txt);
      exit;
    end;
    WM_PASTE:
    begin
      if OpenClipboard(hWnd) then
      begin
        hClip := GetClipboardData(CF_TEXT);
        try
          if hClip <> 0 then
          begin
            try
              if not checkNewValue(hWnd, @txt, PChar(GlobalLock(hClip)), true) then
                exit;
            except
              exit;
            end;
          end;
        finally
          if hClip <> 0 then
            GlobalUnlock(hClip);
          CloseClipboard;
        end;
      end;
    end;
    WM_NOTIFY:
      case PNMHDR(lParam).idFrom of
        IDC_SPIN:
        begin
          with PNMUPDOWN(lParam)^ do
          begin
            txt[GetWindowText(hWnd, txt, 100)] := #0;
            if iPos <> StrToIntDef(txt, 0) then
              SendDlgItemMessage(hWnd, IDC_SPIN, UDM_SETPOS, 0,
                                 MAKELONG(StrToIntDef(txt, 0), 0));
          end;
        end;
      end;
    IEM_SETRANGE, IEM_SETPOS:
    begin
      Result := SendDlgItemMessage(hWnd, IDC_SPIN, Msg, wParam, lParam);
      exit;
    end;
    WM_NCDESTROY:
      DestroyWindow(GetDlgItem(hWnd, IDC_SPIN));
  end;
  Result := CallWindowProc(editWndProc, hWnd, Msg, wParam, lParam);
end;

const
  mask = '0:00:00,000';

procedure checkMask(hWnd: HWND; caret_back: boolean);
var
  txt: char100;
  i: integer;
  s, s1: string;
  selStart: DWORD;
begin
  SendMessage(hWnd, EM_GETSEL, integer(@selStart), 0);
  txt[GetWindowText(hWnd, txt, 100)] := #0;
  s := txt;
  s1 := txt;
  while Length(s1) < Length(mask) do
    Insert('0', s1, selStart + 1);
  while Length(s1) > Length(mask) do
  begin
    if selStart >= Length(mask)then
      dec(SelStart);
    Delete(s1, selStart + 1, 1);
  end;
  StrPCopy(txt, s1);
//  txt[Length(mask)] := #0;
  for i := 0 to Length(mask) - 1 do
    if ((mask[i + 1] = '0') and not (txt[i] in ['0'..'9'])) or
        (mask[i + 1] <> '0') then
      txt[i] := mask[i + 1];

  if txt[2] > '5' then txt[2] := '5';
  if txt[5] > '5' then txt[5] := '5';

  if s <> txt then
    SetWindowText(hWnd, txt);
  if mask[selStart + 1] <> '0' then
    if caret_back then
      dec(selStart)
    else
      inc(selStart);
  SendMessage(hWnd, EM_SETSEL, selStart + 1, selStart);
end;

procedure paste(hWnd: HWND);
var
  hClip: cardinal;
  s: string;
  txt: char100;
  selStart, newStart: DWORD;
begin
  if OpenClipboard(hWnd) then
  begin
    hClip := GetClipboardData(CF_TEXT);
    try
      if hClip <> 0 then
      begin
        s := PChar(GlobalLock(hClip));
      end;
    finally
      if hClip <> 0 then
        GlobalUnlock(hClip);
      CloseClipboard;
    end;
    if hClip <> 0 then
    begin
      SendMessage(hWnd, EM_GETSEL, integer(@selStart), 0);
//     newStart := selStart + Length(s);
      txt[GetWindowText(hWnd, txt, 100)] := #0;
      s := Copy(txt, 1, selStart) + s + Copy(txt, selStart + 1, MaxInt);
      StrPLCopy(txt, s, Length(mask));
//      SendMessage(hWnd, EM_SETSEL, newStart, newStart);
      SetWindowText(hWnd, txt);
    end;
  end;
end;

function timeEditWndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): cardinal; stdcall;
var
  txt: char100;
  ptp: PTimeParts;
begin
  case Msg of
    WM_PASTE:
    begin
      paste(hWnd);
    end;
    TEM_GETTIME:
    begin
      ptp := Pointer(lParam);
      txt[GetWindowText(hWnd, txt, 100)] := #0;
      ptp^.h := StrToInt(Copy(txt, 1, 1));
      ptp^.m := StrToInt(Copy(txt, 3, 2));
      ptp^.s := StrToInt(Copy(txt, 6, 2));
      ptp^.ms := StrToInt(Copy(txt, 9, 3));
    end;
    TEM_SETTIME:
    begin
      ptp := Pointer(lParam);
      StrPCopy(txt, Format('%d:%2d:%2d,%3d', [ptp^.h, ptp^.m, ptp^.s, ptp^.ms]));
      SetWindowText(hWnd, txt);
    end;
    else
      Result := CallWindowProc(editWndProc, hWnd, Msg, wParam, lParam);
  end;
  if ((Msg = WM_KEYDOWN){ and (wParam < VK_SPACE)}) or
     ((Msg = WM_CHAR) {and (wParam >= VK_SPACE)}) or
     (Msg = WM_LBUTTONDOWN) or
     (Msg = WM_SETTEXT) then
    checkMask(hWnd, ((Msg = WM_KEYDOWN) and (wParam = VK_LEFT)));
end;

const
  intEditClassName = 'zbINTEDIT';
  timeEditClassName = 'zbTIMEEDIT';
//  floatEditClassName = 'CP_FLOATEDIT';

procedure regIntEditClass;
var
  wndc: WNDCLASS;
begin
  GetClassInfo(hInstance, 'EDIT', wndc);
  editWndProc := wndc.lpfnWndProc;

  wndc.lpfnWndProc := @intEditWndProc;
  wndc.lpszClassName := intEditClassName;
  wndc.hInstance := hInstance;
  RegisterClass(wndc);
end;

procedure regTimeEditClass;
var
  wndc: WNDCLASS;
begin
  GetClassInfo(hInstance, 'EDIT', wndc);
  editWndProc := wndc.lpfnWndProc;

  wndc.lpfnWndProc := @timeEditWndProc;
  wndc.lpszClassName := timeEditClassName;
  wndc.hInstance := hInstance;
  RegisterClass(wndc);
end;

procedure unregIntEditClass;
begin
  UnregisterClass(intEditClassName, hInstance);
end;

procedure unregTimeEditClass;
begin
  UnregisterClass(timeEditClassName, hInstance);
end;

//procedure freeEnhEditClass;
//begin
//end;

end.
