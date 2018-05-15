unit dlg_corrector;

interface

uses
  Windows, cp_subtitles;

procedure CreateTimeCorrector(parent: HWND; subtitles: TSubtitles);
procedure DestroyTimeCorrector;
procedure ReloadLangTimeCorrector;
procedure SetRescaleInDlg(time: double; time_from: boolean);

function isTimeCorrectorMsg(var Msg: TMsg): boolean;

implementation

uses
  Messages, SysUtils, Forms, subeditor, language, cp_utils, main,
  subtitles_header, commctrl, global_consts, editctrls, zb_sys_env, xp_theme;

const
  IDD_CORRECTOR                  = 14000;
  IDC_TC_TAB                     = 14001;
  IDC_BT_OK                      = 14002;
  IDC_BT_UNDO                    = 14003;
  IDC_BT_CLOSE                   = 14004;
  IDD_CORRECTSHIFT               = 14100;
  IDC_TED_SHIFTTIME              = 14101;
  IDC_RD_SHIFTAHEAD              = 14102;
  IDC_RD_SHIFTBACK               = 14103;
  IDD_CORRECTSCALE               = 14200;
  IDC_LB_SCALEFROM               = 14201;
  IDC_LB_SCALETO                 = 14202;
  IDC_LB_SCALEBEFORE             = 14203;
  IDC_LB_SCALEAFTER              = 14204;
  IDC_TED_SCALEBEFOREFROM        = 14205;
  IDC_TED_SCALEBEFORETO          = 14206;
  IDC_TED_SCALEAFETRFROM         = 14207;
  IDC_TED_SCALEAFTERTO           = 14208;
  IDD_CORRECTFPS                 = 14300;
  IDC_LB_FPSFROM                 = 14301;
  IDC_CBO_FPSFROM                = 14302;
  IDC_LB_FPSTO                   = 14303;
  IDC_ED_FPSTO                   = 14304;

type

  TTimeCorrector = class(TObject)
  private
    _handle: HWND;
    _handle_shift: HWND;
    _handle_scale: HWND;
    _handle_fps: HWND;
    _subtitles: TSubtitles;
    _page_rc: TRect;
    procedure SetShift(Shift: double);
    procedure SetRescale(FB, TB, FA, TA: double);
    procedure SetFPS(FFPS, TFPS: double);
    procedure DoShift;
    procedure CancelShift;
    procedure DoRescale;
    procedure CancelRescale;
    procedure DoFPS;
    procedure CancelFPS;
    procedure populateList(hList: HWND; s: string);
    procedure setSubtitles(const value: TSubtitles);
    function dlgWP(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool;
    function pageWP(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool;
    function create_tabitem(id: DWORD; hPage, hTab: HWND): boolean;
  public
    function Initialize(parent: HWND; subtitles: TSubtitles): boolean;
    procedure Deinitialize;
    procedure ReloadLang;
  end;

var
  TimeCorrector: TTimeCorrector = nil;

var
  oldComboProc: Pointer;

function floatComboWndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): cardinal; stdcall;
var
  txt: char100;
begin
  if Msg = WM_KILLFOCUS then
    try
      txt[GetWindowText(hWnd, txt, 100)] := #0;
      StrToFloat(txt);
    except
      Beep;
      SetFocus(GetParent(hWnd));
      exit;
    end;
  Result := CallWindowProc(oldComboProc, hWnd, Msg, wParam, lParam);
end;

function WindowProc(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool; stdcall;
begin
  case Msg of
    WM_CLOSE:
    begin
//TODO: check this
      SetWindowLong(GetWindow(GetDlgItem(GetDlgItem(hWnd, IDD_CORRECTFPS), IDC_CBO_FPSFROM), GW_CHILD),
                    GWL_WNDPROC,
                    integer(@oldComboProc));

      DestroyTimeCorrector;
      Result := true;
    end;
    WM_DESTROY:
    begin
      Result := false;
    end;
  else
    Result := TimeCorrector.dlgWP(hWnd, Msg, wParam, lParam);
  end;
end;

function pageWndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool; stdcall;
begin
  Result := TimeCorrector.pageWP(hWnd, Msg, wParam, lParam);
end;

procedure CreateTimeCorrector(parent: HWND; subtitles: TSubtitles);
begin
  if TimeCorrector = nil then
  begin
    regTimeEditClass;
    TimeCorrector := TTimeCorrector.Create;
    if not TimeCorrector.Initialize(parent, subtitles) then
      DestroyTimeCorrector;
  end
  else
    begin
      ShowWindow(TimeCorrector._handle, SW_SHOWNORMAL);
      BringWindowToTop(TimeCorrector._handle);
    end;
end;

procedure DestroyTimeCorrector;
begin
  if TimeCorrector <> nil then
  begin
    TimeCorrector.Deinitialize;
    TimeCorrector.Free;
    TimeCorrector := nil;
    unregTimeEditClass;
  end;
  frmEditor.aTimeCorrector.Checked := false;
end;

procedure ReloadLangTimeCorrector;
begin
  if TimeCorrector <> nil then
    TimeCorrector.ReloadLang;
end;

procedure SetRescaleInDlg(time: double; time_from: boolean);
var
  idc: cardinal;
  tp: TTimeParts;
begin
  if TimeCorrector = nil then
    exit;

  tp := PrepareTimeParts(time, true);
  if time_from then
    idc := IDC_TED_SCALEBEFOREFROM
  else
    idc := IDC_TED_SCALEBEFORETO;

  SendDlgItemMessage(TimeCorrector._handle_scale, idc, TEM_SETTIME, 0, integer(@tp));
end;

function isTimeCorrectorMsg(var Msg: TMsg): boolean;
begin
  Result := (TimeCorrector <> nil) and IsDialogMessage(TimeCorrector._handle, Msg);
end;

{ TTimeCorrector }

procedure TTimeCorrector.Deinitialize;
begin
  if _handle <> 0 then
  begin
    DestroyWindow(_handle);
    _handle := 0;
  end;
end;

function TTimeCorrector.Initialize(parent: HWND; subtitles: TSubtitles): boolean;
begin
  _handle := CreateDialog(hInstance, MAKEINTRESOURCE(IDD_CORRECTOR),
                         parent, @WindowProc);

  if _handle = 0 then
  begin
    DisplayError(SysErrorMessage(GetLastError));
    Result := false;
  end
  else
  begin
    setSubtitles(subtitles);
    ShowWindow(_handle, SW_SHOWNORMAL);
    Result := true;
  end
end;

function TTimeCorrector.dlgWP(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool;
var
  rc, warc: TRect;
  tabs: array[0..2] of integer;
begin
  case Msg of
    WM_INITDIALOG:
    begin
      _handle := hWnd;
//      SetRect(page_rc, 13, 35, 237, 95);
      SetRect(_page_rc, 9, 22, 158, 59); {left, top, width, height}
      MapDialogRect(hWnd, _page_rc);
      SystemParametersInfo(SPI_GETWORKAREA, 0, @warc, 0);
      GetClientRect(hWnd, rc);
      SetWindowPos(hWnd, 0, warc.Right - rc.Right - 30, warc.Bottom - rc.Bottom - 30,
        0, 0, SWP_NOSIZE or SWP_NOZORDER);

      _handle_shift := CreateDialog(hInstance, MAKEINTRESOURCE(IDD_CORRECTSHIFT),
                                    hWnd, @pageWndProc);
      _handle_scale := CreateDialog(hInstance, MAKEINTRESOURCE(IDD_CORRECTSCALE),
                                    hWnd, @pageWndProc);
      _handle_fps := CreateDialog(hInstance, MAKEINTRESOURCE(IDD_CORRECTFPS),
                                    hWnd, @pageWndProc);

      oldComboProc := Pointer(
        SetWindowLong(GetWindow(GetDlgItem(_handle_fps, IDC_CBO_FPSFROM), GW_CHILD),
                      GWL_WNDPROC,
                      integer(@floatComboWndProc)));

      create_tabitem(0, _handle_shift, GetDlgItem(hWnd, IDC_TC_TAB));
      create_tabitem(1, _handle_scale, GetDlgItem(hWnd, IDC_TC_TAB));
      create_tabitem(2, _handle_fps, GetDlgItem(hWnd, IDC_TC_TAB));

      populateList(GetDlgItem(_handle_fps, IDC_CBO_FPSFROM), asf_list);

      ReloadLang;
    end;
    WM_COMMAND:
    begin
      case LOWORD(wParam) of
        IDC_BT_OK:
          if HIWORD(wParam) = BN_CLICKED then
          begin
            case SendDlgItemMessage(hWnd, IDC_TC_TAB, TCM_GETCURSEL, 0, 0) of
              0: DoShift;
              1: DoRescale;
              2: DoFPS;
            end;
            frmEditor.RefreshListView;
            Result := true;
          end;
        IDC_BT_UNDO:
          if HIWORD(wParam) = BN_CLICKED then
          begin
            case SendDlgItemMessage(hWnd, IDC_TC_TAB, TCM_GETCURSEL, 0, 0) of
              0: CancelShift;
              1: CancelRescale;
              2: CancelFPS;
            end;
            frmEditor.RefreshListView;
            Result := true;
          end;
        IDCANCEL:
          if HIWORD(wParam) = BN_CLICKED then
          begin
            PostMessage(hWnd, WM_CLOSE, wParam, 0);
            Result := true;
          end;
      else
        Result := true;
      end;
    end;
    WM_NOTIFY:
    begin
      case PNMHDR(lParam).idFrom of
        IDC_TC_TAB:
        begin
          case PNMHDR(lParam).code of
            TCN_SELCHANGE:
            begin
              tabs[0] := SW_HIDE; tabs[1] := SW_HIDE; tabs[2] := SW_HIDE;
              tabs[SendDlgItemMessage(hWnd, IDC_TC_TAB, TCM_GETCURSEL, 0, 0)] := SW_SHOW;
              ShowWindow(_handle_shift, tabs[0]);
              ShowWindow(_handle_scale, tabs[1]);
              ShowWindow(_handle_fps, tabs[2]);
              Result := true;
            end;
          end;
        end;
      else
        Result := false;
      end;
    end;
{    WM_NCACTIVATE:
      if LongBool(wParam) then
        Application.DialogHandle := hWnd
      else
        Application.DialogHandle := 0;}
    else
      Result := false;
  end;
end;

function TTimeCorrector.pageWP(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool;
//var
//  txt: char100;
begin
{  if (Msg = WM_COMMAND) and (LOWORD(wParam) = IDC_CBO_FPSFROM) and
     (HIWORD(wParam) = CBN_KILLFOCUS) then
    try
      txt[GetWindowText(lParam, txt, 100)] := #0;
      StrToFloat(txt);
    except
      Beep;
      SetFocus(lParam);
    end;}
  Result := false;
end;

procedure TTimeCorrector.populateList(hList: HWND; s: string);
var
  i: integer;
  tmp: string;
begin
//todo decimal separator
  while s <> '' do
  begin
    i := Pos(#13, s);
    if i = 0 then
    begin
      tmp := s;
      i := MaxInt;
    end
    else
      tmp := Copy(s, 1, i - 1);
    SendMessage(hList, CB_ADDSTRING, 0, integer(PChar(tmp)));
    Delete(s, 1, i);
  end;
end;

procedure TTimeCorrector.ReloadLang;
var
  tci: TC_ITEM;
begin
  SetWindowText(_handle, PChar(LangStor[LNG_EDT_TIMECORRECTOR]));

  tci.mask := TCIF_TEXT;
  tci.cchTextMax := 100;
  tci.pszText := PChar(LangStor[LNG_EDT_TIMECORRECTORSHIFT]);
  SendDlgItemMessage(_handle, IDC_TC_TAB, TCM_SETITEM, 0, integer(@tci));
  tci.pszText := PChar(LangStor[LNG_EDT_TIMECORRECTORRESCALE]);
  SendDlgItemMessage(_handle, IDC_TC_TAB, TCM_SETITEM, 1, integer(@tci));
  tci.pszText := PChar(LangStor[LNG_EDT_TIMECORRECTORFPS]);
  SendDlgItemMessage(_handle, IDC_TC_TAB, TCM_SETITEM, 2, integer(@tci));

  SetDlgItemText(_handle_shift, IDC_RD_SHIFTAHEAD, PChar(LangStor[LNG_EDT_TIMECORRECTORFORWARD]));
  SetDlgItemText(_handle_shift, IDC_RD_SHIFTBACK, PChar(LangStor[LNG_EDT_TIMECORRECTORBACKWARD]));

  SetDlgItemText(_handle_scale, IDC_LB_SCALEFROM, PChar(LangStor[LNG_EDT_TIMECORRECTORFROM]));
  SetDlgItemText(_handle_scale, IDC_LB_SCALETO, PChar(LangStor[LNG_EDT_TIMECORRECTORTO]));
  SetDlgItemText(_handle_scale, IDC_LB_SCALEBEFORE, PChar(LangStor[LNG_EDT_TIMECORRECTORBEFORE]));
  SetDlgItemText(_handle_scale, IDC_LB_SCALEAFTER, PChar(LangStor[LNG_EDT_TIMECORRECTORAFTER]));

  SetDlgItemText(_handle_fps, IDC_LB_FPSFROM, PChar(LangStor[LNG_EDT_TIMECORRECTORFROMFPS]));
  SetDlgItemText(_handle_fps, IDC_LB_FPSTO, PChar(LangStor[LNG_EDT_TIMECORRECTORTOFPS]));

  SetDlgItemText(_handle, IDC_BT_OK, PChar(LangStor[LNG_OK]));
  SetDlgItemText(_handle, IDC_BT_UNDO, PChar(LangStor[LNG_EDT_TIMECORRECTORUNDO]));
  SetDlgItemText(_handle, IDCANCEL, PChar(LangStor[LNG_CLOSE]));
end;

procedure TTimeCorrector.SetFPS(FFPS, TFPS: double);
begin
  SetDlgItemText(_handle_fps, IDC_CBO_FPSFROM, PChar(Format('%.3f', [FFPS])));
  SetDlgItemText(_handle_fps, IDC_ED_FPSTO, PChar(Format('%.3f', [TFPS])));
end;

procedure TTimeCorrector.SetRescale(FB, TB, FA, TA: double);
begin
  SetDlgItemText(_handle_scale, IDC_TED_SCALEBEFOREFROM, PChar(PrepareTime(FB, true)));
  SetDlgItemText(_handle_scale, IDC_TED_SCALEBEFORETO, PChar(PrepareTime(TB, true)));
  SetDlgItemText(_handle_scale, IDC_TED_SCALEAFETRFROM, PChar(PrepareTime(FA, true)));
  SetDlgItemText(_handle_scale, IDC_TED_SCALEAFTERTO, PChar(PrepareTime(TA, true)));
end;

procedure TTimeCorrector.SetShift(Shift: double);
const
  radios: array[boolean] of integer = (IDC_RD_SHIFTAHEAD, IDC_RD_SHIFTBACK);
begin
  SetDlgItemText(_handle_shift, IDC_TED_SHIFTTIME, PChar(PrepareTime(Shift, true)));
  CheckRadioButton(_handle_shift, IDC_RD_SHIFTAHEAD, IDC_RD_SHIFTBACK, radios[Shift < 0]);
end;

procedure TTimeCorrector.setSubtitles(const value: TSubtitles);
var
  FB, TB, FA, TA, FPS, NewFPS: double;
begin
  _subtitles := Value;

  SetShift(_subtitles.DeltaTime);
  _subtitles.GetRescaleParams(FB, TB, FA, TA);
  SetRescale(FB, TB, FA, TA);
  _subtitles.GetFPS(FPS, NewFPS);
  SetFPS(NewFPS, FPS);
end;

procedure TTimeCorrector.CancelFPS;
begin
  _subtitles.ChangeFPS(0);
end;

procedure TTimeCorrector.CancelRescale;
begin
//  SetDlgItemInt(_handle_scale, IDC_TED_SCALEBEFOREFROM, 0, false);
//  SetDlgItemInt(_handle_scale, IDC_TED_SCALEBEFORETO, 0, false);
  SetDlgItemInt(_handle_scale, IDC_TED_SCALEAFETRFROM, 0, false);
  SetDlgItemInt(_handle_scale, IDC_TED_SCALEAFTERTO, 0, false);
  _subtitles.Rescale(-1, -1, 0, 0);
end;

procedure TTimeCorrector.CancelShift;
begin
  SetDlgItemInt(_handle_shift, IDC_TED_SHIFTTIME, 0, false);
  _subtitles.DeltaTime := 0;
end;

procedure TTimeCorrector.DoFPS;
var
  txt: char100;
begin
  txt[GetDlgItemText(_handle_fps, IDC_CBO_FPSFROM, txt, 100)] := #0;
  if StrToFloat(txt) <= 0 then
  begin
    beep;
    SetFocus(GetDlgItem(_handle_fps, IDC_CBO_FPSFROM));
    exit;
  end;

  _subtitles.ChangeFPS(StrToFloat(txt));
end;

procedure TTimeCorrector.DoRescale;
var
  tp: TTimeParts;
  FB, TB, FA, TA: double;
begin
  SendDlgItemMessage(_handle_scale, IDC_TED_SCALEBEFOREFROM, TEM_GETTIME, 0, integer(@tp));
  FB := ((((tp.h * 60) + tp.m) * 60) + tp.s) + tp.ms / 1000;

  SendDlgItemMessage(_handle_scale, IDC_TED_SCALEBEFORETO, TEM_GETTIME, 0, integer(@tp));
  TB := ((((tp.h * 60) + tp.m) * 60) + tp.s) + tp.ms / 1000;

  if TB <= FB then
  begin
    SetFocus(GetDlgItem(_handle_scale, IDC_TED_SCALEBEFORETO));
    beep;
    exit;
  end;

  SendDlgItemMessage(_handle_scale, IDC_TED_SCALEAFETRFROM, TEM_GETTIME, 0, integer(@tp));
  FA := ((((tp.h * 60) + tp.m) * 60) + tp.s) + tp.ms / 1000;

  SendDlgItemMessage(_handle_scale, IDC_TED_SCALEAFTERTO, TEM_GETTIME, 0, integer(@tp));
  TA := ((((tp.h * 60) + tp.m) * 60) + tp.s) + tp.ms / 1000;

  if TA <= FA then
  begin
    SetFocus(GetDlgItem(_handle_scale, IDC_TED_SCALEAFTERTO));
    beep;
    exit;
  end;

  _subtitles.Rescale(FB, TB, FA, TA);
end;

procedure TTimeCorrector.DoShift;
const
  radios: array[boolean] of integer = (-1, 1);
var
  tp: TTimeParts;
begin
  SendDlgItemMessage(_handle_shift, IDC_TED_SHIFTTIME, TEM_GETTIME, 0, integer(@tp));
  _subtitles.DeltaTime :=
    ((((tp.h * 60) + tp.m) * 60) + tp.s) *
    radios[IsDlgButtonChecked(_handle_shift, IDC_RD_SHIFTBACK) = BST_CHECKED];
end;

function TTimeCorrector.create_tabitem(id: DWORD; hPage, hTab: HWND): boolean;
var
  tci: TC_ITEM;
begin
  tci.mask := TCIF_PARAM;
  tci.lParam := hPage;
  Result := SendMessage(hTab, TCM_INSERTITEM, id, integer(@tci)) > -1;
  if Result then
  begin
    MoveWindow(hPage, _page_rc.Left, _page_rc.Top, _page_rc.Right, _page_rc.Bottom, false); {left, top, width, height}
    if isXPThemeSupported then
      EnableThemeDialogTexture(hPage, ETDT_ENABLETAB);
  end;
end;

end.
