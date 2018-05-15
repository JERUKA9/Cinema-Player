unit uDlgShortcuts;

interface

uses
  Windows, Messages, SysUtils, CommCtrl;

procedure showShortcuts(parent: HWND);

implementation

uses
  language, cp_utils, global_consts, cp_graphics, xp_theme, zb_sys_env;

const
  IDD_SHORTCUTS                   = 19000;
  IDC_LBX_KEYLIST                 = 19001;

  COLUMN_OFFSET                   = 150;

  shortcuts_array: array[LNG_KEY_FIRST..LNG_KEY_LAST] of PChar =
  (
    'Ctrl + O',
    'Ctrl + Shift + O',
    'Ctrl + Q',
    'Alt + O',
    'Alt + Shift + O',
    'Ctrl + D',
    'Ctrl + Shift + D',
    'Alt + D',
    'Alt + Shift + D',
    'Ctrl + L',
    'Ctrl + Shift + L',
    'Ctrl + S',
    'Ctrl + T',
    'Ctrl + Shift + T',
    'Ctrl + 0',
    'Ctrl + 1',
    'Ctrl + 2',
    'Ctrl + 3',
    'Ctrl + 4',
    'Ctrl + 5',
    'Ctrl + 6',
    'Ctrl + 7',
    'Ctrl + 8',
    'Ctrl + 9',
    'Ctrl + Shift + 0',
    'Ctrl + Shift + 1',
    'Ctrl + Shift + 2',
    'Ctrl + Shift + 3',
    'Ctrl + Shift + 4',
    'Ctrl + Shift + 5',
    'Ctrl + Shift + 6',
    'Ctrl + Shift + 7',
    'Ctrl + Shift + 8',
    'Ctrl + Shift + 9',
    '',
    '. (%s)',
    'Ctrl + P',
    'Ctrl + N',
    'Ctrl + A',
    'Del',
    'Shift + Del',
    'Ctrl + Del',
    'Alt + ',
    'Alt + ',
    'Ctrl + R',
    'Ctrl + F',
    'Num0',
    'Num1',
    'Num2',
    'Num3',
    'Num4',
    'Num5',
    'Num6',
    'Num7',
    'Num8',
    'Num9',
    'Ctrl + Num2',
    'Ctrl + Num4',
    'Ctrl + Num6',
    'Ctrl + Num8',
    'Num+',
    'Num-',
    'Num. (%s)',
    'Alt + 1',
    'Alt + 2',
    'Alt + 3',
    'PgUp',
    'PgDown',
    '',
    '',
    'Enter',
    'Backspace',
    'Ctrl + Z',
    'Ctrl + C',
    'Ctrl + X',
    '',
    '',
    'Ctrl + M',
    '[',
    ']',
    'P',
    'Alt + T',
    'Ctrl + -',
    'Ctrl + =',
    'Ctrl + ',
    'Ctrl + ',
    'Ctrl + Shift + -',
    'Ctrl + Shift + =',
    'Ctrl + Shift + ',
    'Ctrl + Shift + ',
    'Alt + Enter',
    'Ctrl + Enter',
    'Esc',
    'Ctrl + F4',
    'Shift + Esc',
    'F1',
    'F7',
    'F8',
    'F9',
    'F10',
    'F11',
    'F12',
    'PrintScrn'
  );

var
  hBoldFont: HFONT;

function dlgShortcutsWndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool; stdcall;

  function getKeyName(const itemID: integer): string;
  begin
    case itemId of
      LNG_KEY_SPACE:
        Result := PChar(LangStor[LNG_KEY_NAME_SPACE]);
      LNG_KEY_LEFT:
        Result := PChar(shortcuts_array[itemID] + LangStor[LNG_KEY_NAME_LEFT]);
      LNG_KEY_RIGHT:
        Result := PChar(shortcuts_array[itemID] + LangStor[LNG_KEY_NAME_RIGHT]);
      LNG_KEY_ALT_UP,
      LNG_KEY_UP,
      LNG_KEY_CTRL_UP,
      LNG_KEY_CTRL_SHIFT_UP:
        Result := PChar(shortcuts_array[itemID] + LangStor[LNG_KEY_NAME_UP]);
      LNG_KEY_ALT_DOWN,
      LNG_KEY_DOWN,
      LNG_KEY_CTRL_DOWN,
      LNG_KEY_CTRL_SHIFT_DOWN:
        Result := PChar(shortcuts_array[itemID] + LangStor[LNG_KEY_NAME_DOWN]);
      LNG_KEY_PERIOD,
      LNG_KEY_NUM_PERIOD:
        Result := Format(shortcuts_array[itemID], [LangStor[LNG_KEY_NAME_PERIOD]]);
    else
      Result := shortcuts_array[itemID];
    end;
  end;

var
//  w, h: integer;
  rc: TRect;
  dc: HDC;
  i: integer;
  handle: THandle;
  col: COLORREF;
  lf: LOGFONT;
begin
  Result := true;
  case Msg of
    WM_INITDIALOG:
    begin
      SetWindowText(hWnd, PChar(GetHint(LangStor[LNG_SHORTCUTS])));
      GetObject(GetStockObject(DEFAULT_GUI_FONT), sizeof(LOGFONT), @lf);
      lf.lfWeight := FW_BOLD;
      hBoldFont := CreateFontIndirect(lf);
      for i := LNG_KEY_FIRST to LNG_KEY_LAST do
        SendDlgItemMessage(hWnd, IDC_LBX_KEYLIST, LB_ADDSTRING, 0, integer(PChar(''{LangStor[i]})));
    end;
    WM_CLOSE:
    begin
      DeleteObject(hBoldFont);
      EndDialog(hWnd, IDOK);
    end;
{    WM_SIZE:
    begin
      w := LOWORD(lParam);
      h := HIWORD(lParam);
      dec(h, nBottomMargin);
      MoveWindow(GetDlgItem(hWnd, IDC_LBX_KEYLIST), 0, 0, w, h, true);
      GetWindowRect(GetDlgItem(hWnd, IDOK), rc);
      OffsetRect(rc, -rc.Left, -rc.Top);
      OffsetRect(rc, (w - rc.Right) div 2, h + (nBottomMargin - rc.Bottom) div 2);
      MoveWindow(GetDlgItem(hWnd, IDOK), rc.Left, rc.Top, rc.Right - rc.Left, rc.Bottom - rc.Top, true);
    end;
    WM_GETMINMAXINFO:
    begin
      with PMinMaxInfo(lParam)^.ptMinTrackSize do
      begin
        x := 550;
        y := 100;
      end;
    end;}
    WM_MEASUREITEM:
    begin
      with PMEASUREITEMSTRUCT(lParam)^ do
      begin
        handle := GetDlgItem(hWnd, IDC_LBX_KEYLIST);
        dc := GetDC(handle);
        SetRect(rc, 2, 0, COLUMN_OFFSET, 0);
        SelectObject(dc, hBoldFont);
        DrawText(dc, PChar(getKeyName(LNG_KEY_FIRST + itemID)), -1, rc, DT_CALCRECT or DT_NOPREFIX or DT_WORDBREAK);
        itemHeight := rc.Bottom;
        SelectObject(dc, GetStockObject(DEFAULT_GUI_FONT));
        GetClientRect(handle, rc);
        itemWidth := rc.Right;
        rc.Left := COLUMN_OFFSET;
        DrawText(dc, PChar(GetHint(LangStor[LNG_KEY_FIRST + itemID])), -1, rc, DT_CALCRECT or DT_NOPREFIX or DT_WORDBREAK);
        ReleaseDC(handle, dc);
        if rc.Bottom > integer(itemHeight) then
          itemHeight := rc.Bottom;
      end;
    end;
    WM_DRAWITEM:
    begin
      with PDRAWITEMSTRUCT(lParam)^ do
      begin
        if LongBool(itemId mod 2) then
          col := GetSysColor(COLOR_BTNFACE)
        else
          col := GetSysColor(COLOR_WINDOW);
        handle := CreateSolidBrush(col);
        FillRect(hDC, rcItem, handle);
        DeleteObject(handle);
        SetBkMode(hDC, TRANSPARENT);
        rc := rcItem;
        rc.Right := rc.Left + COLUMN_OFFSET;
        inc(rc.Left, 2);
        SelectObject(hDC, hBoldFont);
        DrawText(hDC, PChar(getKeyName(LNG_KEY_FIRST + itemID)), -1, rc, DT_NOPREFIX or DT_WORDBREAK);
        inc(rcItem.Left, COLUMN_OFFSET);
        SelectObject(hDC, GetStockObject(DEFAULT_GUI_FONT));
        DrawText(hDC, PChar(GetHint(LangStor[LNG_KEY_FIRST + itemID])), -1, rcItem, DT_NOPREFIX or DT_WORDBREAK);
      end;
    end;
    WM_COMMAND:
    begin
      case LOWORD(wParam) of
        IDOK, IDCANCEL:
          if HIWORD(wParam) = BN_CLICKED then
            SendMessage(hWnd, WM_CLOSE, 0, 0);
      else
        Result := false;
      end;
    end;
  else
    Result := false;
  end;
end;

procedure showShortcuts(parent: HWND);
begin
  DialogBox(hInstance, MAKEINTRESOURCE(IDD_SHORTCUTS), parent, @dlgShortcutsWndProc);
end;

end.
