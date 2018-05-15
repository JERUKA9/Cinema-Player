unit clrbtnctrls;

interface

uses
  Windows, Messages, SysUtils;

procedure regColorButtonClass;
procedure unregColorButtonClass;

const
  CBM_SETCOLOR          = WM_USER + 100;
  CBM_GETCOLOR          = WM_USER + 101;

implementation

uses
  cp_graphics, xp_theme;

{type
  PClrBtnData = ^TClrBtnData;
  TClrBtnData = record
    color: COLORREF;
    bmp: TDDBmp;
  end;}

var
  buttonWndProc: Pointer;

procedure DrawClassicButton(hWnd: HWND; dc: HDC; rc: TRect; state: integer);
var
  hBr: HBRUSH;
  hPn: HPEN;
begin
  hBr := SelectObject(dc, GetSysColorBrush(COLOR_BTNFACE));
  if boolean(state and BST_FOCUS) then
  begin
    Rectangle(dc, rc.Left, rc.Top, rc.Right, rc.Bottom);
    InflateRect(rc, -1, -1);
  end;
  if boolean(state and BST_PUSHED) then
  begin
    hPn := SelectObject(dc, CreatePen(PS_SOLID, 1, GetSysColor(COLOR_BTNSHADOW)));
    Rectangle(dc, rc.Left, rc.Top, rc.Right, rc.Bottom);
    DeleteObject(SelectObject(dc, hPn));
  end
  else
    DrawFrameControl(dc, rc, DFC_BUTTON, DFCS_BUTTONPUSH);

  DeleteObject(SelectObject(dc, hBr));

  if boolean(state and BST_FOCUS) then
  begin
    InflateRect(rc, -3, -3);
    DrawFocusRect(dc, rc);
    InflateRect(rc, 4, 4);
  end;
end;

procedure DrawThemedButton(hWnd: HWND; dc: HDC; rc: TRect; state: integer);
var
  _hTheme: HTHEME;
  draw_state: integer;
  pt: TPoint;
begin
  _hTheme := OpenThemeData(hWnd, 'button');
  if _hTheme > 0 then
  begin
    if boolean(state and BST_PUSHED) then
      draw_state := PBS_PRESSED
    else
      if (GetWindowLong(hWnd, GWL_USERDATA) and $ff000000) <> 0 then
        draw_state := PBS_HOT
      else
        if boolean(state and BST_FOCUS) then
          draw_state := PBS_DEFAULTED
        else
          draw_state := PBS_NORMAL;

    if (IsThemeBackgroundPartiallyTransparent(_hTheme, BP_PUSHBUTTON, draw_state)) then
      DrawThemeParentBackground(hWnd, dc, nil);

    DrawThemeBackground(_hTheme, dc, BP_PUSHBUTTON, draw_state, rc, PRect(nil)^);
    CloseThemeData(_hTheme);
  end;

  if boolean(state and BST_FOCUS) then
  begin
    InflateRect(rc, -3, -3);
    DrawFocusRect(dc, rc);
    InflateRect(rc, 3, 3);
  end;
end;

function clrButtonWndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): cardinal; stdcall;
var
  bmp: TDDBmp;
  rc: TRect;
  ps: PAINTSTRUCT;
  dc: HDC;
  state: integer;
  hBr: HBRUSH;
  tme: TTRACKMOUSEEVENT;
begin
  case Msg of
    CBM_SETCOLOR:
    begin
      SetWindowLong(
        hWnd,
        GWL_USERDATA,
        (lParam and $ffffff) or (GetWindowLong(hWnd, GWL_USERDATA) and $ff000000));
      InvalidateRect(hWnd, nil, true);
      Result := 0;
      exit;
    end;
    CBM_GETCOLOR:
    begin
      Result := GetWindowLong(hWnd, GWL_USERDATA) and $ffffff;
      exit;
    end;
    WM_PAINT:
    begin
      GetClientRect(hWnd, rc);
      bmp := TDDBmp.Create;
      try
        bmp.initialize(rc.Right, rc.Bottom);
        state := SendMessage(hWnd, BM_GETSTATE, 0, 0);

        if isXPThemeSupported() then
          DrawThemedButton(hWnd, bmp.get_dc, rc, state)
        else
          DrawClassicButton(hWnd, bmp.get_dc, rc, state);

        InflateRect(rc, -6, -6);
        hBr := SelectObject(bmp.get_dc, CreateSolidBrush(GetWindowLong(hWnd, GWL_USERDATA) and $ffffff));
        Rectangle(bmp.get_dc, rc.Left, rc.Top, rc.Right, rc.Bottom);
        DeleteObject(SelectObject(bmp.get_dc, hBr));
        InflateRect(rc, 6, 6);

        dc := BeginPaint(hWnd, ps);
        BitBlt(dc, 0, 0, rc.Right, rc.Bottom, bmp.get_dc, 0, 0, SRCCOPY);
        EndPaint(hWnd, ps);
      finally
        bmp.Free;
      end;
      Result := 0;
      exit;
    end;
    WM_SETFOCUS, WM_KILLFOCUS:
    begin
      InvalidateRect(hWnd, nil, false);
    end;
    WM_MOUSELEAVE:
    begin
      SetWindowLong(hWnd, GWL_USERDATA, GetWindowLong(hWnd, GWL_USERDATA) and $00ffffff);
      InvalidateRect(hWnd, nil, false);
    end;
    WM_MOUSEMOVE:
    begin
      if (GetWindowLong(hWnd, GWL_USERDATA) and $ff000000) = 0 then
      begin
        tme.cbSize := sizeof(tme);
        tme.dwFlags := TME_LEAVE;
        tme.hwndTrack := hWnd;
        tme.dwHoverTime := 0;
        TrackMouseEvent(tme);
        SetWindowLong(hWnd, GWL_USERDATA, GetWindowLong(hWnd, GWL_USERDATA) or $ff000000);
        InvalidateRect(hWnd, nil, false);
      end;
    end;
  end;
  Result := CallWindowProc(buttonWndProc, hWnd, Msg, wParam, lParam);
end;

const
  clrButtonClassName = 'zbSHAPE';

procedure regColorButtonClass;
var
  wndc: WNDCLASS;
begin
  GetClassInfo(hInstance, 'BUTTON', wndc);
  buttonWndProc := wndc.lpfnWndProc;

  wndc.lpfnWndProc := @clrButtonWndProc;
  wndc.lpszClassName := clrButtonClassName;
  wndc.hInstance := hInstance;
  RegisterClass(wndc);
end;

procedure unregColorButtonClass;
begin
  UnregisterClass(clrButtonClassName, hInstance);
end;

end.
