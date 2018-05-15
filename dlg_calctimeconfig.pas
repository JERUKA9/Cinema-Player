unit dlg_calctimeconfig;

interface

uses
  Windows;

procedure CreateCalcTimeConfig;
procedure DestroyCalcTimeConfig;
procedure ReloadLangCalcTimeConfig;

function isCalcTimeConfigMsg(var Msg: TMsg; var bClose: boolean): boolean;

implementation

uses Messages, SysUtils, Forms, CommCtrl, cp_RemoteControl,
  global_consts, language, cp_utils, zb_sys_env, settings_header;

const
  clsChartName = 'CP_CALCTIMECHART';

  IDD_CALCTIMECONFIG             = 13000;
  IDC_LB_AXIS_Y                  = 13001;
  IDC_CHART                      = 13002;
  IDC_LB_AXIS_X                  = 13003;
  IDC_LB_MINTIME                 = 13004;
  IDC_LB_MINTIME_VALUE           = 13005;
  IDC_SLD_MINTIME                = 13006;
  IDC_LB_MAXTIME                 = 13007;
  IDC_LB_MAXTIME_VALUE           = 13008;
  IDC_SLD_MAXTIME                = 13009;
  IDC_LB_CONSTTIME               = 13010;
  IDC_LB_CONSTTIME_VALUE         = 13011;
  IDC_SLD_CONSTTIME              = 13012;
  IDC_LB_INCTIME                 = 13013;
  IDC_LB_INCTIME_VALUE           = 13014;
  IDC_SLD_INCTIME                = 13015;


type
  TCalcTimeConfig = class(TObject)
  private
    handle: HWND;
    FMinTime: Extended;
    FMaxTime: Extended;
    FConstTime: Extended;
    FIncTime: Extended;
    x1, x2, y1, y2: integer;
//    angle: Extended;
    procedure SetIncTime(const Value: Extended);
    procedure SetMaxTime(const Value: Extended);
    procedure SetMinTime(const Value: Extended);
    procedure SetConstTime(const Value: Extended);
    procedure RecalcRanges;
    function GetTime(i: integer): Extended;
    procedure PaintChart(hWnd: HWND);
    procedure RePaintChart;
  public
    constructor Create();
    function Initialize: boolean;
    procedure Deinitialize;
    function wndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool;
    procedure ReloadLang;
    property MinTime: Extended write SetMinTime;
    property MaxTime: Extended write SetMaxTime;
    property IncTime: Extended write SetIncTime;
    property ConstTime: Extended write SetConstTime;
  end;


var
  CalcTimeConfig: TCalcTimeConfig = nil;
  class_registered: boolean;

function chartWindowProc(hWnd: HWND; Msg, wParam, lParam: cardinal): cardinal; stdcall;
begin
  case Msg of
    WM_PAINT:
    begin
      CalcTimeConfig.PaintChart(hWnd);
      Result := 0;
    end;
    WM_ERASEBKGND:
      Result := 1;
  else
    Result := DefWindowProc(hWnd, Msg, wParam, lParam);
  end;
end;

function WindowProc(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool; stdcall;
begin
  case Msg of
    WM_CLOSE:
    begin
      if wParam = 0 then
        wParam := IDCANCEL;
      if LOWORD(wParam) = IDCANCEL then
      begin
        config.SubAutoMinTime := CalcTimeConfig.FMinTime;
        config.SubAutoMaxTime := CalcTimeConfig.FMaxTime;
        config.SubAutoConstTime := CalcTimeConfig.FConstTime;
        config.SubAutoIncTime := CalcTimeConfig.FIncTime;
      end;

      DestroyCalcTimeConfig;

      Result := true;
    end;
    WM_DESTROY:
    begin
      Result := false;
    end;
  else
    Result := CalcTimeConfig.wndProc(hWnd, Msg, wParam, lParam);
  end;
end;

procedure CreateCalcTimeConfig;
var
  wndCls: WNDCLASS;
begin
  if CalcTimeConfig = nil then
  begin
    ZeroMemory(@wndCls, sizeof(wndCls));
    wndCls.lpszClassName := PChar(clsChartName);
    wndCls.style := CS_HREDRAW or CS_VREDRAW or CS_PARENTDC;
    wndCls.lpfnWndProc := @chartWindowProc;
    wndCls.hInstance := hInstance;

    class_registered := (RegisterClass(wndCls) <> 0) or (GetLastError = ERROR_ALREADY_EXISTS);
    if not class_registered then exit;

    CalcTimeConfig := TCalcTimeConfig.Create;
    if not CalcTimeConfig.Initialize then
      DestroyCalcTimeConfig;
  end
  else
  begin
    DestroyCalcTimeConfig;
//    ShowWindow(CalcTimeConfig.handle, SW_SHOWNORMAL);
//    BringWindowToTop(CalcTimeConfig.handle);
  end;
end;

procedure DestroyCalcTimeConfig;
begin
  if CalcTimeConfig <> nil then
  begin
    CalcTimeConfig.Deinitialize;
    CalcTimeConfig.Free;
    CalcTimeConfig := nil;
    UnregisterClass(clsChartName, hInstance);
  end;
end;

procedure ReloadLangCalcTimeConfig;
begin
  if CalcTimeConfig <> nil then
    CalcTimeConfig.ReloadLang;
end;

function isCalcTimeConfigMsg(var Msg: TMsg; var bClose: boolean): boolean;
begin
  bClose := false;
  Result := false;
  if (CalcTimeConfig <> nil) then
  begin
    if (Msg.message = WM_KEYDOWN) and (Msg.wParam = VK_F8) then
    begin
      Result := true;
      bClose := true;
    end
    else
      Result := IsDialogMessage(CalcTimeConfig.handle, Msg);
  end;
end;

{ TCalcTimeConfig }

constructor TCalcTimeConfig.Create();
begin
  FMinTime := config.SubAutoMinTime;
  FMaxTime := config.SubAutoMaxTime;
  FIncTime := config.SubAutoIncTime;
  FConstTime := config.SubAutoConstTime;
  RecalcRanges;
end;

procedure TCalcTimeConfig.Deinitialize;
begin
  if handle <> 0 then
  begin
    DestroyWindow(handle);
    handle := 0;
  end;
end;

function TCalcTimeConfig.GetTime(i: integer): Extended;
//var
//  x, y: Extended;
begin     //0.0001 * len + 0.04) * len + 0.5
//  Result := (FIncTime * i + FConstTime) * i + FMinTime;
//  if config.SubAutoIncTime >= 0 then
    Result := config.SubAutoIncTime * i * i + config.SubAutoConstTime * i + config.SubAutoMinTime;
//  else
//  begin
//    Result := -config.SubAutoIncTime * i * i + config.SubAutoConstTime * i;
//    Result := config.SubAutoConstTime * i;
//    angle := pi - 2 * arcsin(Result / sqrt(i * i + Result * Result));
//    Result := -config.SubAutoIncTime * i * i;
//    x := i * cos(angle) - Result * sin(angle);
//    y := i * sin(angle) + Result * cos(angle);
//    Result := y + config.SubAutoMinTime + config.SubAutoConstTime * i;
//    Result := FConstTime / (2 * -FIncTime) + sqrt(delta);
//    Result := FMinTime + y2 * Result / x2;
//    Result := -FIncTime * sqrt(i) * 300 + FConstTime * i + FMinTime;
//  end;
  if Result > config.SubAutoMaxTime then
    Result := config.SubAutoMaxTime;
end;

function TCalcTimeConfig.Initialize: boolean;
begin
  handle := CreateDialog(hInstance, MAKEINTRESOURCE(IDD_CALCTIMECONFIG),
                         Application.MainForm.Handle, @WindowProc);

  if handle = 0 then
  begin
    DisplayError(SysErrorMessage(GetLastError));
    Result := false;
  end
  else
  begin
    ShowWindow(handle, SW_SHOWNORMAL);
    Result := true;
  end
end;

procedure TCalcTimeConfig.PaintChart(hWnd: HWND);
const
  margin = 20;
var
  cr, r: TRect;
  i: integer;
  x_size, y_size: integer;
  ps: PAINTSTRUCT;
  dc, mdc: HDC;
  bmp: HBITMAP;
  pen: HBRUSH;
begin
  mdc := BeginPaint(hWnd, ps);
  if mdc <> 0 then
  begin
    GetClientRect(hWnd, cr);
    x_size := cr.Right - margin;
    y_size := cr.Bottom - margin;
    dc := CreateCompatibleDC(mdc);
    bmp := CreateCompatibleBitmap(mdc, cr.Right, cr.Bottom);
    SelectObject(dc, bmp);

    SelectObject(dc, GetStockObject(DEFAULT_GUI_FONT));

    SetRect(r, 0, 0, margin, cr.Bottom);
    FillRect(dc, r, COLOR_BTNFACE + 1);
    SetRect(r, margin, y_size, cr.Right, cr.Bottom);
    FillRect(dc, r, COLOR_BTNFACE + 1);

    Rectangle(dc, margin, 0, r.Right, y_size);

    pen := CreatePen(PS_DOT, 1, $C0C0C0);
    for i := 1 to 5 do
    begin
      r.Left := margin div 2;
      r.Top := margin + (y_size - margin) * (5 - i) div 5;
      r.BottomRight := r.TopLeft;

      SelectObject(dc, GetStockObject(BLACK_PEN));
      MoveToEx(dc, margin - 3, r.Top, nil);
      LineTo(dc, margin, r.Top);

      SelectObject(dc, pen);
      LineTo(dc, cr.Right - 1, r.Top);

      SetBkMode(dc, TRANSPARENT);
      DrawText(dc, PChar(IntToStr(y2 * i div 5)), -1, r, DT_CENTER or DT_NOCLIP or DT_SINGLELINE or DT_VCENTER);

    end;
    for i := 0 to 11 do
    begin
      r.Left := margin + (x_size - margin) * (12 - i) div 12;
      r.Top := y_size + margin div 2;
      r.BottomRight := r.TopLeft;

      SelectObject(dc, GetStockObject(BLACK_PEN));
      MoveToEx(dc, r.Left, y_size, nil);
      LineTo(dc, r.Left, y_size + 3);

      SelectObject(dc, pen);
      LineTo(dc, r.Left, 0);

      SetBkMode(dc, TRANSPARENT);
      DrawText(dc, PChar(IntToStr(x2 * (12 - i) div 12)), -1, r, DT_CENTER or DT_NOCLIP or DT_SINGLELINE or DT_VCENTER);
    end;
    SelectObject(dc, GetStockObject(BLACK_PEN));
    DeleteObject(pen);

    MoveToEx(dc, margin - 3, y_size - 1, nil);
    LineTo(dc, margin, y_size - 1);
    LineTo(dc, margin, y_size + 3);
    r.Left := margin div 2;
    r.Top := y_size + margin div 2;
    r.BottomRight := r.TopLeft;
    DrawText(dc, '0', -1, r, DT_CENTER or DT_NOCLIP or DT_SINGLELINE or DT_VCENTER);

    SelectObject(dc, CreatePen(PS_SOLID, 1, $0000FF));
    MoveToEx(dc, margin, y_size - 1 - round(config.SubAutoMinTime * (y_size - margin) / y2), nil);

    for i := x1 to x2 do
      LineTo(dc, margin + round(i * (x_size - margin) / x2), y_size - 1 - round(GetTime(i) * (y_size - margin) / y2));

    DeleteObject(SelectObject(dc, GetStockObject(BLACK_PEN)));

    BitBlt(mdc, 0, 0, cr.Right, cr.Bottom, dc, 0, 0, SRCCOPY);
    DeleteObject(bmp);
    DeleteDC(dc);
  end;
  EndPaint(hWnd, ps);
end;

procedure TCalcTimeConfig.RecalcRanges;
//var
//  i: integer;
//  tmp: double;
begin
{
  y1 := 0;//round(int(FMinTime));
  if Frac(FMaxTime * 1.2) = 0 then
    y2 := round(int(FMaxTime + 1))
  else
    y2 := round(int(FMaxTime));

  x1 := 0;
  i := 0;
  repeat
    tmp := GetTime(i);
    inc(i, 30);
  until tmp >= FMaxTime;
  x2 := round(i * 1.2);
}
  x1 := 0; y1 := 0; x2 := 120; y2 := 5;
end;

procedure TCalcTimeConfig.ReloadLang;
begin
  SetWindowText(handle, PChar(GetHint(LangStor[LNG_SAS_WINDOWCAPTION])));

  SetDlgItemText(handle, IDCANCEL, PChar(LangStor[LNG_CANCEL]));
  SetDlgItemText(handle, IDOK, PChar(LangStor[LNG_OK]));

  SetDlgItemText(handle, IDC_LB_MAXTIME, PChar(LangStor[LNG_SAS_MAXIMALTIME]));
  SetDlgItemText(handle, IDC_LB_MINTIME, PChar(LangStor[LNG_SAS_MINIMALTIME]));
  SetDlgItemText(handle, IDC_LB_CONSTTIME, PChar(LangStor[LNG_SAS_CONSTTIME]));
  SetDlgItemText(handle, IDC_LB_INCTIME, PChar(LangStor[LNG_SAS_INCREMENTALTIME]));

  SetDlgItemText(handle, IDC_LB_AXIS_X, PChar('[' + LangStor[LNG_SAS_LETTERS] + ']'));
  SetDlgItemText(handle, IDC_LB_AXIS_Y, PChar('[' + LangStor[LNG_OPT_SECOND] + ']'));
end;

procedure TCalcTimeConfig.SetIncTime(const Value: Extended);
begin
  if (config.SubAutoIncTime <> Value) then
  begin
    config.SubAutoIncTime := Value;
    RecalcRanges;
    RePaintChart;
  end;
end;

procedure TCalcTimeConfig.SetMaxTime(const Value: Extended);
begin
  if (config.SubAutoMaxTime <> Value) then
  begin
    config.SubAutoMaxTime := Value;
    RecalcRanges;
    RePaintChart;
  end;
end;

procedure TCalcTimeConfig.SetMinTime(const Value: Extended);
begin
  if (config.SubAutoMinTime <> Value) then
  begin
    config.SubAutoMinTime := Value;
    RecalcRanges;
    RePaintChart;
  end;
end;

procedure TCalcTimeConfig.SetConstTime(const Value: Extended);
//var
//  y: extended;
begin
  if (config.SubAutoConstTime <> Value) then
  begin
    config.SubAutoConstTime := Value;
//    y := FConstTime * 100;
//    angle := pi - 2 * arcsin(y / sqrt(10000 + y * y));
    RecalcRanges;
    RePaintChart;
  end;
end;

function TCalcTimeConfig.wndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool;
begin
  case Msg of
    WM_INITDIALOG:
    begin
      handle := hWnd;
    // Min time
      SetDlgItemText(hWnd, IDC_LB_MINTIME_VALUE, PChar(FormatFloat('0.00', config.SubAutoMinTime)));
      SendDlgItemMessage(hWnd, IDC_SLD_MINTIME, TBM_SETRANGE, 1, MAKELONG(0, 15)); // od 0.5 do 2.0 co 0.1
      SendDlgItemMessage(hWnd, IDC_SLD_MINTIME, TBM_SETPOS, 1, round((config.SubAutoMinTime - 0.5) * 10));

    // max time
      SetDlgItemText(hWnd, IDC_LB_MAXTIME_VALUE, PChar(FormatFloat('0.00', config.SubAutoMaxTime)));
      SendDlgItemMessage(hWnd, IDC_SLD_MAXTIME, TBM_SETRANGE, 1, MAKELONG(0, 20)); // od 3.0 do 5.0 co 0.1
      SendDlgItemMessage(hWnd, IDC_SLD_MAXTIME, TBM_SETPOS, 1, round((config.SubAutoMaxTime - 3.0) * 10));

    // Const time
      SetDlgItemText(hWnd, IDC_LB_CONSTTIME_VALUE, PChar(FormatFloat('0.000', config.SubAutoConstTime)));
      SendDlgItemMessage(hWnd, IDC_SLD_CONSTTIME, TBM_SETRANGE, 1, MAKELONG(0, 40)); // od 0.0 do 0.1 co 0.0025
      SendDlgItemMessage(hWnd, IDC_SLD_CONSTTIME, TBM_SETPOS, 1, round(config.SubAutoConstTime * 400));

    // Inc time
      SetDlgItemText(hWnd, IDC_LB_INCTIME_VALUE, PChar(FormatFloat('0.0000', config.SubAutoIncTime)));
      SendDlgItemMessage(hWnd, IDC_SLD_INCTIME, TBM_SETRANGE, 1, MAKELONG(0, 20)); // od -0.001 do 0.001 co 0.0001
      SendDlgItemMessage(hWnd, IDC_SLD_INCTIME, TBM_SETPOS, 1, round((config.SubAutoIncTime {+ 0.001}) * 5000));

      ReloadLang;

      Result := true;
    end;
    WM_HSCROLL:
    begin
      case GetDlgCtrlID(lParam) of
        IDC_SLD_MINTIME:
        begin
          MinTime := 0.5 + 0.1 * SendMessage(lParam, TBM_GETPOS, 0, 0);
          SetDlgItemText(hWnd, IDC_LB_MINTIME_VALUE, PChar(FormatFloat('0.00', config.SubAutoMinTime)));
        end;
        IDC_SLD_MAXTIME:
        begin
          MaxTime := 3.0 + 0.1 * SendMessage(lParam, TBM_GETPOS, 0, 0);
          SetDlgItemText(hWnd, IDC_LB_MAXTIME_VALUE, PChar(FormatFloat('0.00', config.SubAutoMaxTime)));
        end;
        IDC_SLD_CONSTTIME:
        begin
          ConstTime := 0.0025 * SendMessage(lParam, TBM_GETPOS, 0, 0);
          SetDlgItemText(hWnd, IDC_LB_CONSTTIME_VALUE, PChar(FormatFloat('0.000', config.SubAutoConstTime)));
        end;
        IDC_SLD_INCTIME:
        begin
          IncTime := {-0.001 +} 0.0002 * SendMessage(lParam, TBM_GETPOS, 0, 0);
          SetDlgItemText(hWnd, IDC_LB_INCTIME_VALUE, PChar(FormatFloat('0.0000', config.SubAutoIncTime)));
        end;
      end;
      Result := false;
    end;
{    WM_KEYDOWN:
    begin
      if wParam = VK_F8 then
      begin
        PostMessage(hWnd, WM_CLOSE, wParam, 0);
        Result := true;
      end
      else
        Result := false;
    end;
}    WM_COMMAND:
    begin
      case LOWORD(wParam) of
        IDOK, IDCANCEL:
        begin
          PostMessage(hWnd, WM_CLOSE, wParam, 0);
          Result := true;
        end;
      else
        Result := false;
      end;
    end;
{    WM_NCACTIVATE:
      if LongBool(wParam) then
        Application.DialogHandle := hWnd
      else
        Application.DialogHandle := 0; }
    else
      Result := false;
  end;
end;

procedure TCalcTimeConfig.RePaintChart;
begin
  InvalidateRect(GetDlgItem(handle, IDC_CHART), nil, true);
//  UpdateWindow(h_chart);
end;

end.
