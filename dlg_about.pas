unit dlg_about;

interface

uses
  Windows, Messages, SysUtils, CommCtrl;

type
  TStringArray = array of string;
  PStringArray = ^TStringArray;

procedure showAbout(parent: HWND; langs: PStringArray);

implementation

uses
  language, cp_utils, global_consts, cp_graphics, xp_theme, uBumpData;

type
  TDlgAbout = class(TObject)
  private
    parentWnd: HWND;
    lngs: PStringArray;
    lngs_count: integer;
    bmp, bmp2: TDIBmp;
    oldCinemaWndProc: Pointer;
    mx: integer;

    function initializeBump(hWndItem: HWND): boolean;
    procedure finalizeBump();
    procedure paintBump(hWndBump: HWND; dc: HDC);
    function wndProc(hDlg: HWND; Msg, wParam, lParam: cardinal): LongBool;
    function wndCinemaProc(hWnd: HWND; Msg, wParam, lParam: cardinal): cardinal;
    function wndUrlProc(hWnd: HWND; Msg, wParam, lParam: cardinal): cardinal;

  public
    constructor Create(parent: HWND; langs: PStringArray);

    function initialize(): boolean;
    procedure finalize();
    procedure show();
  end;


const
  IDD_ABOUT             = 3000;
  IDB_DELPHI            = 3001;
  IDC_TAB               = 3002;
  IDC_CINEMA            = 3003;
  IDB_BUMP              = 3004;
  IDC_AUTHOR            = 3005;
  IDC_EMAIL             = 3006;
  IDC_WWW               = 3007;
  IDC_AUTHOR4           = 3008;
  IDC_WWW2              = 3009;
  IDC_LIST              = 3010;
  IDC_VERSION           = 3011;

  donatorCount = 12;
  donatorsList: array[0..donatorCount - 1] of string =
  (
    ('Piotr Pamu³a'),
    ('krisq'),
    ('Tomasz Krzysztof Wrona (CrowKing)'),
    ('Tomasz Œmierzchalski (NiSSeS)'),
    ('Marek Jaros³aw Horyñski'),
    ('ToMo'),
    ('jaykay4'),
    ('Wojciech Tracz'),
    ('Marek Justyñski'),
    ('Artur Grudziñski (Art)'),
    ('Jacek i Dominika Apanasik'),
    ('Grzegorz Olszewski')
  );

var
  dlgAbout: TDlgAbout;

function cinemaWndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): cardinal; stdcall;
begin
  Result := dlgAbout.wndCinemaProc(hWnd, Msg, wParam, lParam);
end;

function urlWndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): cardinal; stdcall;
begin
  Result := dlgAbout.wndUrlProc(hWnd, Msg, wParam, lParam);
end;

function dlgAboutWndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool; stdcall;
begin
  Result := dlgAbout.wndProc(hWnd, Msg, wParam, lParam);
end;

procedure showAbout(parent: HWND; langs: PStringArray);
begin
  dlgAbout := TDlgAbout.Create(parent, langs);
  try
    if dlgAbout.initialize() then
    begin
      dlgAbout.show();
      dlgAbout.finalize();
    end;
  finally
    dlgAbout.Free;
  end;
end;

{ TDlgAbout }

constructor TDlgAbout.Create(parent: HWND; langs: PStringArray);
begin
  lngs := langs;
  lngs_count := Length(lngs^);
  parentWnd := parent;
  mx := MinInt;
end;

procedure TDlgAbout.finalize;
const
  clsURLName = 'CP_URL';
begin
  finalizeBump();
  UnregisterClass(clsURLName, hInstance);
end;

procedure TDlgAbout.finalizeBump;
begin
  bmp.Free;
  bmp2.Free;
end;

function TDlgAbout.initialize: boolean;
const
  clsURLName = 'CP_URL';
var
  wndCls_: WNDCLASS;
begin
  ZeroMemory(@wndCls_, sizeof(wndCls_));
  wndCls_.lpszClassName := PChar(clsURLName);
  wndCls_.style := CS_HREDRAW or CS_VREDRAW or CS_PARENTDC;
  wndCls_.lpfnWndProc := @urlWndProc;
  wndCls_.hInstance := hInstance;
  wndCls_.hCursor := LoadCursor(0, MAKEINTRESOURCE(IDC_HAND));

  Result := RegisterClass(wndCls_) > 0;
end;

function TDlgAbout.initializeBump(hWndItem: HWND): boolean;
var
  rc: TRect;
  txt: array[0..30] of char;
  f: TFnt;
  fd: TFontData;
  hbmp: HBITMAP;
  hbr: HBRUSH;
begin
  GetClientRect(hWndItem, rc);
  bmp := TDIBmp.Create();
  bmp.initialize(rc.Right, rc.Bottom, 24);
  bmp2 := TDIBmp.Create();
  bmp2.initialize(rc.Right, rc.Bottom, 24);
  hbmp := LoadBitmap(hInstance, MAKEINTRESOURCE(IDB_BUMP));
  hbr := CreatePatternBrush(hbmp);
  FillRect(bmp.get_dc, rc, hbr);
  DeleteObject(hbr);
  DeleteObject(hbmp);

  SetTextColor(bmp.get_dc(), GetSysColor(COLOR_BTNTEXT));
  SetBkMode(bmp.get_dc(), TRANSPARENT);
  f := TFnt.Create;
  f.assign(GetStockObject(DEFAULT_GUI_FONT));
  f.get_font_data(fd);
  f.unassign;

  fd.name := 'Arial';
  fd.size := 32;
  Include(fd.attr, faBold);
  f.initialize(fd);
  SelectObject(bmp.get_dc(), f.get_handle);
  ZeroMemory(@txt, 31);
  GetWindowText(hWndItem, txt, 31);
  DrawText(bmp.get_dc(), txt, -1, rc, DT_CENTER or DT_VCENTER or DT_SINGLELINE or DT_NOCLIP);
  OffsetRect(rc, 1, 0);
  DrawText(bmp.get_dc(), txt, -1, rc, DT_CENTER or DT_VCENTER or DT_SINGLELINE or DT_NOCLIP);
  OffsetRect(rc, 2, 0);
  DrawText(bmp.get_dc(), txt, -1, rc, DT_CENTER or DT_VCENTER or DT_SINGLELINE or DT_NOCLIP);
  SelectObject(bmp.get_dc(), GetStockObject(DEFAULT_GUI_FONT));
  f.Free;
end;

procedure TDlgAbout.paintBump(hWndBump: HWND; dc: HDC);
var
  rc: TRect;
  x: integer;
begin
  GetClientRect(hWndBump, rc);
  x := round(rc.Right div 2 + rc.Right / 2.7 * sin(GetTickCount() mod 6000 * 6.28 / 6000));
  if x <> mx then
  begin
    mx := x;
    makeBump(
      mx,
      rc.Right, rc.Bottom,
      bmp.get_pitch(),
      PByteArray(bmp.get_bits()),
      PByteArray(bmp2.get_bits()));
  end;
  BitBlt(dc, 0, 0, rc.Right, rc.Bottom, bmp2.get_dc(), 0, 0, SRCCOPY);
end;

procedure TDlgAbout.show;
begin
  DialogBox(hInstance, MAKEINTRESOURCE(IDD_ABOUT), parentWnd, @dlgAboutWndProc);
end;

function TDlgAbout.wndCinemaProc(hWnd: HWND; Msg, wParam,
  lParam: cardinal): cardinal;
var
  ps: PAINTSTRUCT;
  dc: HDC;
begin
  case Msg of
    WM_PAINT:
    begin
      dc := BeginPaint(hWnd, ps);
      paintBump(hWnd, dc);
      EndPaint(hWnd, ps);
      Result := 0;
    end;
    WM_ERASEBKGND:
    begin
      Result := 1;
    end;
    else
      Result := CallWindowProc(oldCinemaWndProc, hWnd, Msg, wParam, lParam);
  end;
end;

function TDlgAbout.wndProc(hDlg: HWND; Msg, wParam,
  lParam: cardinal): LongBool;
var
  rc, rc1: TRect;
  h: THandle;
  i: integer;
  txt: array[0..99] of char;
  tci: TC_ITEM;
begin
  case Msg of
    WM_INITDIALOG:
    begin
      SetWindowText(hDlg, PChar(GetHint(LangStor[LNG_ABOUT])));
      SetDlgItemText(hDlg, IDC_AUTHOR, PChar(LangStor[LNG_ABOUT_AUTHOR] + ': ' + global_consts.Author));

      SetDlgItemText(hDlg, IDC_CINEMA, PChar(ProgName + string(' ') + Version));
      SetDlgItemText(hDlg, IDC_VERSION, PChar(Data + string(#9#9) + Beta));

      SetDlgItemText(hDlg, IDC_WWW, PChar(szWWW + szURL));
      SetDlgItemText(hDlg, IDC_EMAIL, PChar(szEmail + szURL));

      tci.mask := TCIF_TEXT;
      tci.pszText := txt;
      ZeroMemory(@txt, 100);
      StrPCopy(txt, GetHint(LangStor[LNG_LANGUAGES]));
      tci.cchTextMax := Length(txt);
      tci.lParam := 0;
      SendDlgItemMessage(hDlg, IDC_TAB, TCM_INSERTITEM, 0, integer(@tci));
      ZeroMemory(@txt, 100);
      StrPCopy(txt, GetHint(LangStor[LNG_DONATION]));
      tci.cchTextMax := Length(txt);
      tci.lParam := 1;
      SendDlgItemMessage(hDlg, IDC_TAB, TCM_INSERTITEM, 1, integer(@tci));
      h := GetDlgItem(hDlg, IDC_LIST);
      i := 100;
      SendMessage(h, LB_SETTABSTOPS, 1, integer(@i));
      SetParent(h, GetDlgItem(hDlg, IDC_TAB));
      GetClientRect(GetDlgItem(hDlg, IDC_TAB), rc);
      SendDlgItemMessage(hDlg, IDC_TAB, TCM_GETITEMRECT, 0, integer(@rc1));
      rc.Top := rc1.Bottom;
      InflateRect(rc, -10, -10);
      MoveWindow(h, rc.Left, rc.Top, rc.Right - rc.Left, rc.Bottom - rc.Top, true);

      for i := 0 to lngs_count - 1 do
        SendMessage(h, LB_ADDSTRING, 0, integer(PChar(lngs^[i])));

      initializeBump(GetDlgItem(hDlg, IDC_CINEMA));
      oldCinemaWndProc := Pointer(SetWindowLong(GetDlgItem(hDlg, IDC_CINEMA), GWL_WNDPROC, integer(@cinemaWndProc)));
      SetTimer(hDlg, 10, 40, nil);

      Result := true;

//      EnableThemeDialogTexture(hWnd, ETDT_ENABLETAB);
    end;
    WM_CLOSE:
    begin
      KillTimer(hDlg, 10);
      SetWindowLong(GetDlgItem(hDlg, IDC_CINEMA), GWL_WNDPROC, integer(oldCinemaWndProc));
      EndDialog(hDlg, IDOK);
    end;
    WM_TIMER:
    begin
      InvalidateRect(GetDlgItem(hDlg, IDC_CINEMA), nil, false);
    end;
    WM_COMMAND:
    begin
      case LOWORD(wParam) of
        IDC_EMAIL, IDC_WWW, IDC_WWW2:
        begin
          if HIWORD(wParam) = BN_CLICKED then
          begin
            ZeroMemory(@txt, 31);
            GetWindowText(lParam, txt, 31);
            if LOWORD(wParam) = IDC_EMAIL then
              sendMail(hDlg, txt)
            else
              gotoWWW(hDlg, txt);
            Result := true;
          end;
        end;
        IDOK, IDCANCEL:
          if HIWORD(wParam) = BN_CLICKED then
            SendMessage(hDlg, WM_CLOSE, 0, 0);
      else
        Result := false;
      end;
    end;
    WM_NOTIFY:
    begin
      case PNMHDR(lParam).idFrom of
        IDC_TAB:
        begin
          case PNMHDR(lParam).code of
            TCN_SELCHANGE:
            begin
              h := GetDlgItem(PNMHDR(lParam).hwndFrom, IDC_LIST);
              SendMessage(h, LB_RESETCONTENT, 0, 0);
              case SendMessage(PNMHDR(lParam).hwndFrom, TCM_GETCURSEL, 0, 0) of
                0:
                  for i := 0 to lngs_count - 1 do
                    SendMessage(h, LB_ADDSTRING, 0, integer(PChar(lngs^[i])));
                1:
                  for i := 0 to donatorCount - 1 do
                    SendMessage(h, LB_ADDSTRING, 0, integer(PChar(donatorsList[i])));
              end;
            end;
          end;
        end;
      end;
    end;
  else
    Result := false;
  end;
end;

function TDlgAbout.wndUrlProc(hWnd: HWND; Msg, wParam,
  lParam: cardinal): cardinal;
var
  ps: PAINTSTRUCT;
  dc: HDC;
  rc: TRect;
  txt: array[0..30] of char;
  f: TFnt;
  fd: TFontData;
begin
  case Msg of
    WM_PAINT:
    begin
      dc := BeginPaint(hWnd, ps);
      GetClientRect(hWnd, rc);
      FillRect(dc, rc, GetSysColorBrush(COLOR_BTNFACE));
      SetTextColor(dc, $ff0000);
      SetBkColor(dc, GetSysColor(COLOR_BTNFACE));
      f := TFnt.Create;
      f.assign(GetStockObject(DEFAULT_GUI_FONT));
      f.get_font_data(fd);
      f.unassign;
      Include(fd.attr, faUnderline);
      f.initialize(fd);
      SelectObject(dc, f.get_handle);
      ZeroMemory(@txt, 31);
      GetWindowText(hWnd, txt, 31);
      DrawText(dc, txt, -1, rc, DT_LEFT or {DT_VCENTER or} DT_SINGLELINE or DT_NOCLIP);
      SelectObject(dc, GetStockObject(DEFAULT_GUI_FONT));
      f.Free;
      EndPaint(hWnd, ps);
      Result := 0;
    end;
    WM_ERASEBKGND:
    begin
      Result := 1;
    end;
    WM_LBUTTONDOWN:
    begin
      SetCapture(hWnd);
      Result := 0;
    end;
    WM_LBUTTONUP:
    begin
      if GetCapture = hWnd then
      begin
        ReleaseCapture;
        GetClientRect(hWnd, rc);
        if (LOWORD(lParam) < rc.Right) and (HIWORD(lParam) < rc.Bottom) then
          SendMessage(GetParent(hWnd), WM_COMMAND, GetWindowLong(hWnd, GWL_ID), hWnd);
        Result := 0;
      end;
    end;
    WM_SETFOCUS:
    begin
      SetFocus(wParam);
      Result := 0;
    end;
    else
      Result := DefWindowProc(hWnd, Msg, wParam, lParam);
  end;
end;

end.
