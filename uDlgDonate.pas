unit uDlgDonate;

interface

uses
  Windows, Messages, SysUtils;

procedure showDonate(const parent: HWND);

implementation

uses
  language, cp_utils, global_consts, cp_graphics;

const
  IDD_DONATION                   = 17000;
  IDC_LB_DONATIONINFO            = 17001;
  IDC_LB_DONATIONBANKACCOUNT     = 17002;
  IDC_LB_DONATIONINFO2           = 17003;
  IDB_PAYPAL                     = 17004;
  IDB_MONEYBOOKERS               = 17005;
  IDC_PAYPAL                     = 17006;
  IDC_MONEYBOOKERS               = 17007;
  IDC_AUTHOR                     = 3005;

var
  oldBankAccountWndProc: Pointer;
  oldDonateButtonWndProc: Pointer;

function getAccountNumber(): string;
var
  i: integer;
  tmp1: integer;
begin
//                           '50102055581111108926900161'
  Result := '';
// 11111
  for i := 0 to 4 do
    Result := Result + '1';
// 5558[11111]
  Result := '8' + Result;
  for i := 0 to 2 do
    Result := '5' + Result;

// 501020[555811111]
  tmp1 := 10;
  Result := IntToStr(tmp1 * 2) + Result;
  Result := IntToStr(tmp1) + Result;
  Result := IntToStr(tmp1 * 5) + Result;

// [501020555811111]089269
  Result := Result + '0';
  dec(tmp1, 2);
  Result := Result + IntToStr(tmp1);
  Result := Result + IntToStr(tmp1 + 1);
  Result := Result + '2';
  Result := Result + IntToStr(tmp1 - 2);
  Result := Result + IntToStr(tmp1 + 1);

// [501020555811111089269]00
  for i := 0 to 1 do
    Result := Result + '0';

// [50102055581111108926900]161
  Result := Result + IntToStr(tmp1 * 2);
  Result := Result + '1';
  Insert(' ', Result, 3);
  Insert(' ', Result, 8);
  Insert(' ', Result, 13);
  Insert(' ', Result, 18);
  Insert(' ', Result, 23);
  Insert(' ', Result, 28);
end;

function bankAccountWndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): cardinal; stdcall;
var
  ps: PAINTSTRUCT;
  dc: HDC;
  rc: TRect;
  f: TFnt;
  fd: TFontData;
begin
  case Msg of
    WM_PAINT:
    begin
      dc := BeginPaint(hWnd, ps);
      GetClientRect(hWnd, rc);
      FillRect(dc, rc, GetSysColorBrush(COLOR_BTNFACE));
      SetTextColor(dc, GetSysColor(COLOR_BTNTEXT));
      SetBkColor(dc, GetSysColor(COLOR_BTNFACE));
      f := TFnt.Create;
      f.assign(GetStockObject(DEFAULT_GUI_FONT));
      f.get_font_data(fd);
      f.unassign;
      Include(fd.attr, faBold);
      f.initialize(fd);
      SelectObject(dc, f.get_handle);
      DrawText(dc, PChar(getAccountNumber), -1, rc, DT_LEFT or DT_VCENTER or DT_CENTER or DT_SINGLELINE or DT_NOCLIP);
      SelectObject(dc, GetStockObject(DEFAULT_GUI_FONT));
      f.Free;
      EndPaint(hWnd, ps);
      Result := 0;
    end;
    WM_ERASEBKGND:
    begin
      Result := 1;
    end;
    else
      Result := CallWindowProc(oldBankAccountWndProc, hWnd, Msg, wParam, lParam);
  end;
end;

function donateButtonWndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): cardinal; stdcall;
begin
  case Msg of
    WM_SETCURSOR:
    begin
      SetCursor(LoadCursor(0, MAKEINTRESOURCE(IDC_HAND)));
      Result := 1;
    end;
    else
      Result := CallWindowProc(oldDonateButtonWndProc, hWnd, Msg, wParam, lParam);
  end;
end;

function dlgDonateWndProc(hWnd_: HWND; Msg, wParam, lParam: cardinal): LongBool; stdcall;
const
  szDonateURL: array[boolean] of PChar = ('moneybookers.', 'paypal.');
var
//  cur: HCURSOR;
  dc: HDC;
  rc, rc2: TRect;
  nVOffset: integer;

  procedure adjustWindowSize(childHWnd: HWND; nVOffset: integer;
    bOnlyResize: boolean = false; bCenter: boolean = false);
  begin
    GetWindowRect(childHWnd, rc);
    if IsChild(hWnd_, childHWnd) then
      MapWindowPoints(0, hWnd_, rc, 2);
    if bOnlyResize then
      inc(rc.Bottom, nVOffset)
    else
      OffsetRect(rc, 0, nVOffset);
    if bCenter then
      OffsetRect(rc, 0, -nVOffset div 2);
    MoveWindow(childHWnd, rc.Left, rc.Top, rc.Right - rc.Left, rc.Bottom - rc.Top, false);
  end;

begin
  case Msg of
    WM_INITDIALOG:
    begin
      SetWindowText(hWnd_, PChar(GetHint(LangStor[LNG_DONATION]) + ' ' + global_consts.ProgName));
      SetDlgItemText(hWnd_, IDC_LB_DONATIONINFO, PChar(LangStor[LNG_DONATIONINFO]));

      SetDlgItemText(hWnd_, IDC_LB_DONATIONINFO2, PChar(LangStor[LNG_DONATIONINFO2] + ' donate@' + szURL));
      SetDlgItemText(hWnd_, IDC_AUTHOR, PChar(LangStor[LNG_ABOUT_AUTHOR] + ': ' + global_consts.Author));

      oldBankAccountWndProc := Pointer(SetWindowLong(GetDlgItem(hWnd_, IDC_LB_DONATIONBANKACCOUNT), GWL_WNDPROC, integer(@bankAccountWndProc)));
      oldDonateButtonWndProc := Pointer(SetWindowLong(GetDlgItem(hWnd_, IDC_PAYPAL), GWL_WNDPROC, integer(@donateButtonWndProc)));
      SetWindowLong(GetDlgItem(hWnd_, IDC_MONEYBOOKERS), GWL_WNDPROC, integer(@donateButtonWndProc));

      GetClientRect(GetDlgItem(hWnd_, IDC_LB_DONATIONINFO), rc2);
      rc := rc2;
      dc := GetDC(hWnd_);
      SelectObject(dc, GetStockObject(DEFAULT_GUI_FONT));

      DrawText(dc, PChar(LangStor[LNG_DONATIONINFO]), -1, rc, DT_CALCRECT or DT_NOPREFIX or DT_WORDBREAK);
      ReleaseDC(hWnd_, dc);
      nVOffset := rc.Bottom - rc2.Bottom + 20;
      adjustWindowSize(hWnd_, nVOffset, true, true);
      adjustWindowSize(GetDlgItem(hWnd_, IDC_LB_DONATIONINFO), nVOffset, true);
      adjustWindowSize(GetDlgItem(hWnd_, IDC_LB_DONATIONBANKACCOUNT), nVOffset);
      adjustWindowSize(GetDlgItem(hWnd_, IDC_LB_DONATIONINFO2), nVOffset);
      adjustWindowSize(GetDlgItem(hWnd_, IDC_PAYPAL), nVOffset);
      adjustWindowSize(GetDlgItem(hWnd_, IDC_MONEYBOOKERS), nVOffset);
      adjustWindowSize(GetDlgItem(hWnd_, IDC_AUTHOR), nVOffset);
      adjustWindowSize(GetDlgItem(hWnd_, IDOK), nVOffset);

      SetForegroundWindow(hWnd_);
      Result := true;
    end;
    WM_CLOSE:
    begin
      SetWindowLong(GetDlgItem(hWnd_, IDC_LB_DONATIONBANKACCOUNT), GWL_WNDPROC, integer(oldbankAccountWndProc));
      SetWindowLong(GetDlgItem(hWnd_, IDC_PAYPAL), GWL_WNDPROC, integer(oldDonateButtonWndProc));
      SetWindowLong(GetDlgItem(hWnd_, IDC_MONEYBOOKERS), GWL_WNDPROC, integer(oldDonateButtonWndProc));
      EndDialog(hWnd_, IDOK);
    end;
    WM_COMMAND:
    begin
      case LOWORD(wParam) of
        IDOK, IDCANCEL:
        begin
          if HIWORD(wParam) = BN_CLICKED then
            SendMessage(hWnd_, WM_CLOSE, 0, 0);
        end;
        IDC_PAYPAL,
        IDC_MONEYBOOKERS:
        begin
          if HIWORD(wParam) = STN_CLICKED then
          begin
            gotoWWW(hWnd_, szDonateURL[LOWORD(wParam) = IDC_PAYPAL] + szURL);
          end;
        end;
      else
        Result := false;
      end;
    end;
  else
    Result := false;
  end;
end;

procedure showDonate(const parent: HWND);
begin
  DialogBox(hInstance, MAKEINTRESOURCE(IDD_DONATION), parent, @dlgDonateWndProc);
end;

end.
