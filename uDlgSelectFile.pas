unit uDlgSelectFile;

interface

uses
  Windows, Messages, Classes, SysUtils;

function selectSubtitleFile(const parent: HWND; const slSubtitles: TStringList;
  out strSubtitle: string): boolean;

function selectURLFile(const parent: HWND; const slURLs: TStringList;
  out strURL: string): boolean;

implementation

uses
  language, cp_utils;

const
  IDD_SELECTFILE                  = 20000;
//  IDC_LB_CAPTION                  = 20001;
  IDC_CBO_URLFILE                 = 20002;
  IDC_LBX_FILES                   = 20003;
  IDC_BT_BROWSE                   = 20004;

var
  sl: TStringList;
  strResult: string;

function dlgSelectSubtitleWndProc(hWnd_: HWND; Msg, wParam, lParam: cardinal): LongBool; stdcall;
var
  i: integer;
begin
  case Msg of
    WM_INITDIALOG:
    begin
      SetWindowText(hWnd_, PChar(GetHint(LangStor[LNG_OPENSUBTITLES])));
      SetDlgItemText(hWnd_, IDOK, PChar(LangStor[LNG_OK]));
      SetDlgItemText(hWnd_, IDCANCEL, PChar(LangStor[LNG_CANCEL]));
      SetDlgItemText(hWnd_, IDC_BT_BROWSE, PChar(LangStor[LNG_BROWSE]));

//      SetDlgItemText(hWnd_, IDC_LB_DONATIONINFO2, PChar(LangStor[LNG_DONATIONINFO2] + ' donate@' + szURL));
//      SetDlgItemText(hWnd_, IDC_AUTHOR, PChar(LangStor[LNG_ABOUT_AUTHOR] + ': ' + global_consts.Author));
      ShowWindow(GetDlgItem(hWnd_, IDC_LBX_FILES), SW_SHOW);
      for i := 0 to sl.Count - 1 do
        SendDlgItemMessage(hWnd_, IDC_LBX_FILES, LB_ADDSTRING, 0, integer(PChar(sl[i])));

      SendDlgItemMessage(hWnd_, IDC_LBX_FILES, LB_SETCURSEL, 0, 0);
      SetFocus(GetDlgItem(hWnd_, IDC_LBX_FILES));

      Result := true;
    end;
//    WM_CLOSE:
//    begin
//      EndDialog(hWnd_, IDOK);
//    end;
    WM_COMMAND:
    begin
      case LOWORD(wParam) of
        IDOK, IDCANCEL, IDC_BT_BROWSE:
        begin
          if HIWORD(wParam) = BN_CLICKED then
          begin
            if LOWORD(wParam) = IDOK then
              strResult := sl[SendDlgItemMessage(hWnd_, IDC_LBX_FILES, LB_GETCURSEL, 0, 0)];
            EndDialog(hWnd_, LOWORD(wParam));
          end;
//            SendMessage(hWnd_, WM_CLOSE, 0, 0);
        end;
        IDC_LBX_FILES:
        begin
          if HIWORD(wParam) = LBN_DBLCLK then
          begin
            strResult := sl[SendDlgItemMessage(hWnd_, IDC_LBX_FILES, LB_GETCURSEL, 0, 0)];
            EndDialog(hWnd_, IDOK);
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

function selectSubtitleFile(const parent: HWND; const slSubtitles: TStringList;
  out strSubtitle: string): boolean;
begin
  sl := slSubtitles;
  sl.Sort();
  Result := DialogBox(hInstance, MAKEINTRESOURCE(IDD_SELECTFILE), parent,
              @dlgSelectSubtitleWndProc) = IDOK;
  if Result then
    strSubtitle := strResult;
end;

function dlgSelectURLWndProc(hWnd_: HWND; Msg, wParam, lParam: cardinal): LongBool; stdcall;
var
  rc: TRect;
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
{  case Msg of
    WM_INITDIALOG:
    begin
//      SetWindowText(hWnd_, PChar(GetHint(LangStor[LNG_DONATION]) + ' ' + global_consts.ProgName));
//      SetDlgItemText(hWnd_, IDC_LB_DONATIONINFO, PChar(LangStor[LNG_DONATIONINFO]));

      SetDlgItemText(hWnd_, IDC_LB_DONATIONINFO2, PChar(LangStor[LNG_DONATIONINFO2] + ' donate@' + szURL));
      SetDlgItemText(hWnd_, IDC_AUTHOR, PChar(LangStor[LNG_ABOUT_AUTHOR] + ': ' + global_consts.Author));

      GetClientRect(GetDlgItem(hWnd_, IDC_LB_DONATIONINFO), rc2);
      rc := rc2;
      nVOffset := rc.Bottom - rc2.Bottom + 20;
      adjustWindowSize(hWnd_, nVOffset, true, true);
      adjustWindowSize(GetDlgItem(hWnd_, IDOK), nVOffset);
      adjustWindowSize(GetDlgItem(hWnd_, ID_OK), nVOffset);
      adjustWindowSize(GetDlgItem(hWnd_, IDC_BT_BROWSE), nVOffset);

      Result := true;
    end;
//    WM_CLOSE:
//    begin
//      EndDialog(hWnd_, IDOK);
//    end;
    WM_COMMAND:
    begin
      case LOWORD(wParam) of
        IDOK, IDCANCEL:
        begin
          if HIWORD(wParam) = BN_CLICKED then
            EndDialog(hWnd_, LOWORD(wParam));
//            SendMessage(hWnd_, WM_CLOSE, 0, 0);
        end;
      else
        Result := false;
      end;
    end;
  else
    Result := false;
  end;}
end;

function selectURLFile(const parent: HWND; const slURLs: TStringList;
  out strURL: string): boolean;
begin
  sl := slURLs;
  Result := DialogBox(hInstance, MAKEINTRESOURCE(IDD_SELECTFILE), parent,
              @dlgSelectURLWndProc) = IDOK;
  if Result then
    strURL := strResult;
end;

end.
