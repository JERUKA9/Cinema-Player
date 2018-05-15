unit subeditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, cp_Dialogs,
  StdCtrls, ExtCtrls, ToolWin, Menus, cp_CinemaEngine, Mask, global_consts,
  ActnList, commctrl, ComCtrls;

type
  TfrmEditor = class(TForm)
    pnlEditor: TPanel;
    mEditLine: TMemo;
    tbarMain: TToolBar;
    meDelay: TMaskEdit;
    tbarControl: TToolBar;
    tbPlayPause: TToolButton;
    tbStop: TToolButton;
    ToolButton3: TToolButton;
    tbLargeBack: TToolButton;
    tbBack: TToolButton;
    tbStep: TToolButton;
    tbLargeStep: TToolButton;
    ToolBar3: TToolBar;
    tbApplyChanges: TToolButton;
    meTimeStart: TMaskEdit;
    tbNew: TToolButton;
    ActionList1: TActionList;
    aApplyChanges: TAction;
    tbOpenText: TToolButton;
    tbSave: TToolButton;
    ToolButton5: TToolButton;
    tbNextError: TToolButton;
    aNew: TAction;
    aSave: TAction;
    tbSaveAs: TToolButton;
    aSaveAs: TAction;
    tbPrevError: TToolButton;
    ToolButton9: TToolButton;
    aNextError: TAction;
    aPrevError: TAction;
    tbAddBeforeLine: TToolButton;
    tbDelLine: TToolButton;
    ToolButton12: TToolButton;
    aAddBeforeLine: TAction;
    aDelLine: TAction;
    tbAddAfterLine: TToolButton;
    aAddAfterLine: TAction;
    tbFollowMovie: TToolButton;
    tbArrangeWindows: TToolButton;
    ToolButton1: TToolButton;
    tbTimeCorrector: TToolButton;
    aTimeCorrector: TAction;
    aFollowMovie: TAction;
    aArrangeWindows: TAction;
    procedure FormCreate(Sender: TObject);
    procedure mEditLineEnter(Sender: TObject);
    procedure mEditLineExit(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure meTimeStartEnter(Sender: TObject);
    procedure meTimeStartExit(Sender: TObject);
    procedure meDelayKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure meTimeStartKeyPress(Sender: TObject; var Key: Char);
    procedure meTimeStartKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure aApplyChangesExecute(Sender: TObject);
    procedure aNewExecute(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure aSaveAsExecute(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure pnlEditorResize(Sender: TObject);
    procedure aNextErrorExecute(Sender: TObject);
    procedure aPrevErrorExecute(Sender: TObject);
    procedure aAddBeforeLineExecute(Sender: TObject);
    procedure aDelLineExecute(Sender: TObject);
    procedure aAddAfterLineExecute(Sender: TObject);
    procedure aTimeCorrectorExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure aFollowMovieExecute(Sender: TObject);
    procedure aArrangeWindowsExecute(Sender: TObject);
  private
    { Private declarations }
    CurrentLineNumber: integer;
    procedure ShowLine(Index: integer);
    procedure NeedRefresh(Sender: TObject);
    procedure CreateListView;
    procedure SetListViewOneSelected(index: integer);
    procedure WMNotify(var msg: TWMNotify); message WM_NOTIFY;
    procedure WMDrawItem(var msg: TWMDrawItem); message WM_DRAWITEM;
    procedure WMGetMinMaxInfo(var Msg: TMessage); message WM_GETMINMAXINFO;
  public
    { Public declarations }
    procedure FollowMovie(NewLineNumber: integer);
    procedure ReloadLang;
    procedure RefreshListView;
  end;

var
  frmEditor: TfrmEditor;

implementation

uses
  main, language, dlg_corrector, cp_subtitles, zb_sys_env, cp_utils, subtitles_header;

{$R *.DFM}

const
  LV_COL0_WIDTH          = 32;
  LV_COL1_WIDTH          = 80;
  LV_COL2_WIDTH          = 45;
  LV_COL3_WIDTH          = 351;

  CMD_ID_RESCALE_FROM    = 1000;
  CMD_ID_RESCALE_TO      = 1001;

var
  oldLVWndProc: Pointer;
  lvHandle: cardinal = 0;
  LVPopupMenu: HMENU;


{ TfrmEditor }

procedure TfrmEditor.FollowMovie(NewLineNumber: integer);
begin
  if NewLineNumber <> CurrentLineNumber then
  begin
    ListView_RedrawItems(lvHandle, CurrentLineNumber, CurrentLineNumber);
    CurrentLineNumber := NewLineNumber;
    ListView_RedrawItems(lvHandle, CurrentLineNumber, CurrentLineNumber);
    if (CurrentLineNumber > -1) and (CurrentLineNumber < ListView_GetItemCount(lvHandle)) and
       aFollowMovie.Checked then
    begin
      ShowLine(CurrentLineNumber);
    end;
  end;
end;

procedure TfrmEditor.FormCreate(Sender: TObject);
begin
  CreateListView;

  CurrentLineNumber := -1;
  meDelay.EditMask := '!9' + DecimalSeparator + '999;1;0';
  Subtitles.Viewer := lvHandle;
  Subtitles.OnNeedRefresh := NeedRefresh;
end;

procedure TfrmEditor.mEditLineEnter(Sender: TObject);
begin
  with frmCinemaPlayer do
  begin
    aPlay.ShortCut := 0;
    aPause.ShortCut := 0;
    aStop.ShortCut := 0;
    aSmallStep.ShortCut := 0;
    aSubtitleTimeBack.ShortCut := 0;
    aSubtitleTimeForward.ShortCut := 0;
    aSubtitleTimeReset.ShortCut := 0;
    aDelSel.ShortCut := 0;
  end;
  meTimeStartEnter(Sender);
end;

procedure TfrmEditor.mEditLineExit(Sender: TObject);
var
  p: double;
begin
  with frmCinemaPlayer do
  begin
    p := MyCinema.CurrentPosition;
    if MyCinema.PlayState = cpPlaying then
      aPause.ShortCut := ShortCut(VK_SPACE, [])
    else
      aPlay.ShortCut := ShortCut(VK_SPACE, []);
    MyCinema.CurrentPosition := p;
    aStop.ShortCut := ShortCut(Ord('.') or $90, []);
    aSubtitleTimeBack.ShortCut := ShortCut(Ord('[') or $90, []);
    aSubtitleTimeForward.ShortCut := ShortCut(Ord(']') or $90, []);
    aSubtitleTimeReset.ShortCut := ShortCut(Ord('P'), []);
    aSmallStep.ShortCut := ShortCut(VK_RETURN, []);
    aDelSel.ShortCut := ShortCut(VK_DELETE, []);
  end;
  meTimeStartExit(Sender);
end;

procedure TfrmEditor.FormHide(Sender: TObject);
begin
  mEditLineExit(nil);
end;

procedure TfrmEditor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if aTimeCorrector.Checked then
    DestroyTimeCorrector;
  frmCinemaPlayer.aSubEditor.Checked := false;
end;

procedure TfrmEditor.FormActivate(Sender: TObject);
begin
  with frmCinemaPlayer do
  begin
    aVolumeUp.ShortCut := 0;
    aVolumeDown.ShortCut := 0;
  end;
  if mEditLine.Focused then
    mEditLineEnter(nil);
  if (Sender = Self) and frmCinemaPlayer.aStayOnTop.Checked then
  begin
    SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
//    if aTimeCorrector.Checked then
//      with dlgTimeCorrector do
//        SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
  end;
end;

procedure TfrmEditor.meTimeStartEnter(Sender: TObject);
begin
  with frmCinemaPlayer do
  begin
    aSmallBack.ShortCut := 0;
    aStep.ShortCut := 0;
    aBack.ShortCut := 0;
    aPlaySlower.ShortCut := 0;
    aPlayNormal.ShortCut := 0;
    aPlayFaster.ShortCut := 0;
  end;
end;

procedure TfrmEditor.meTimeStartExit(Sender: TObject);
begin
  with frmCinemaPlayer do
  begin
    aSmallBack.ShortCut := ShortCut(VK_BACK, []);
    aStep.ShortCut := ShortCut(VK_RIGHT, []);
    aBack.ShortCut := ShortCut(VK_LEFT, []);
    aPlaySlower.ShortCut := ShortCut(Ord('Z'), [ssCtrl]);
    aPlayNormal.ShortCut := ShortCut(Ord('X'), [ssCtrl]);
    aPlayFaster.ShortCut := ShortCut(Ord('C'), [ssCtrl]);
  end;
end;

procedure TfrmEditor.meDelayKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  bufor: string;
  znak: char;
  i: integer;
begin
  with (Sender as TMaskEdit) do
    if ((Key = VK_UP) or (Key = VK_DOWN)) and (SelStart <> Length(Text)) then
    begin
      bufor := Text;
      for i := 1 to Length(bufor) do
        if bufor[i] = ' ' then
          bufor[i] := '0';
      i := SelStart;
      znak := Copy(bufor, SelStart + 1, 1)[1];
      if not (znak in ['0'..'9']) then
        exit;
      if Key = VK_UP then
        znak := Chr(Ord('0') + (succ(Ord(znak) - Ord('0')) mod 10))
      else
        if znak = '0' then
          znak := '9'
        else
          znak := Chr(Ord('0') + (pred(Ord(znak) - Ord('0')) mod 10));
      Text := Copy(bufor, 1, SelStart) + znak + Copy(bufor, SelStart + 2, MaxInt);
      SelStart := i;
      SelLength := 1;
    end;
end;

procedure TfrmEditor.meTimeStartKeyPress(Sender: TObject; var Key: Char);
var
  bufor: string;
  i: integer;
begin
  if not (Key in ['0'..'9']) then
    exit;
  with (Sender as TMaskEdit) do
    bufor := Copy(Text, 1, SelStart) + Key + Copy(Text, SelStart + 2, MaxInt);
  for i := 1 to Length(bufor) do
    if bufor[i] = ' ' then
      bufor[i] := '0';
  try
    StrToTime(Copy(bufor, 1, 7));
  except
    Key := #0;
  end;
end;

procedure TfrmEditor.meTimeStartKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  bufor: string;
  znak: char;
  i: integer;
begin
  with (Sender as TMaskEdit) do
    if ((Key = VK_UP) or (Key = VK_DOWN)) and (SelStart <> Length(Text)) then
    begin
      bufor := Text;
      for i := 1 to Length(bufor) do
        if bufor[i] = ' ' then
          bufor[i] := '0';
      i := SelStart;
      znak := Copy(bufor, i + 1, 1)[1];
      if not (znak in ['0'..'9']) then
        exit;
      if Key = VK_UP then
        if ((SelStart in [2, 5]) and (znak = '5')) or (znak = '9') then  // diesi¹tki minut lub sekund
          znak := '0'
        else
          znak := Chr(Ord('0') + (succ(Ord(znak) - Ord('0')) mod 10))
      else
        if znak = '0' then
          if SelStart in [2, 5] then  // diesi¹tki minut lub sekund
            znak := '5'
          else
            znak := '9'
        else
          znak := Chr(Ord('0') + (pred(Ord(znak) - Ord('0')) mod 10));
      bufor := Copy(bufor, 1, SelStart) + znak + Copy(bufor, SelStart + 2, MaxInt);
      if SelStart < 8 then
        try
          StrToTime(Copy(bufor, 1, 7));
        except
          exit;
        end;
      Text := bufor;
      SelStart := i;
      SelLength := 1;
    end;
end;

procedure TfrmEditor.aApplyChangesExecute(Sender: TObject);
var
  h, m, s, ms: WORD;
  temp: string;
  item: integer;
begin
  temp := FixString(meTimeStart.Text);
  h := StrToInt(Copy(temp, 1, 1));
  m := StrToInt(Copy(temp, 3, 2));
  s := StrToInt(Copy(temp, 6, 2));
  ms := StrToInt(Copy(temp, 9, 3));
  item := ListView_GetNextItem(lvHandle, -1, LVNI_ALL or LVNI_SELECTED);

  Subtitles.SetSubtitleStart(item, ((((h * 60) + m) * 60) + s) + ms / 1000);
  Subtitles.SetSubtitleStop(item, StrToFloat(FixString(meDelay.Text)));

  temp := mEditLine.Lines.Text;
  while Pos(#10, temp) <> 0 do
    System.Delete(temp, Pos(#10, temp), 1);
  while (temp <> '') and (AnsiLastChar(temp) = #13) do
    System.Delete(temp, Length(temp), 1);
  Subtitles.SetSubtitle(item, temp);
  Subtitles.RefreshViewer;
  ListView_RedrawItems(lvHandle, item, item + 1);
  Windows.SetFocus(lvHandle);
end;

procedure TfrmEditor.aNewExecute(Sender: TObject);
var
  isFaultless: boolean;
begin
  Subtitles.Clear;
  frmCinemaPlayer.aOpenText.ImageIndex := iconOpenTextOff;
  frmCinemaPlayer.aOpenText.Hint := LangStor[LNG_OPENSUBTITLES];
  Subtitles.RefreshViewer;
end;

procedure TfrmEditor.aSaveExecute(Sender: TObject);
var
  fn: string;
begin
  with Subtitles do
  begin
    if FileExists(FileName) then
    begin
      fn := ChangeFileExt(FileName, '.bak');
      RenameFile(FileName, fn);
    end;
    SaveToFile(FileName);
  end;
end;

procedure TfrmEditor.FormDeactivate(Sender: TObject);
begin
  with frmCinemaPlayer do
  begin
    aVolumeUp.ShortCut := ShortCut(VK_UP, []);
    aVolumeDown.ShortCut := ShortCut(VK_DOWN, []);
//    if aStayOnTop.Checked then
//      SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
  end;
end;

procedure TfrmEditor.ShowLine(Index: integer);
var
  top_item,
  count_per_page: integer;
  rc: TRect;
begin
  top_item := ListView_GetTopIndex(lvHandle);
  count_per_page := ListView_GetCountPerPage(lvHandle);
  Windows.GetClientRect(lvHandle, rc);
  while (Index < top_item) or (Index > (top_item + count_per_page)) do
  begin
    ListView_Scroll(lvHandle, 0, (Index - top_item) * (rc.Bottom div count_per_page));
    top_item := ListView_GetTopIndex(lvHandle);
  end;
end;

procedure TfrmEditor.aNextErrorExecute(Sender: TObject);
var
  i, i_f: integer;
begin
  i := ListView_GetTopIndex(lvHandle);
  i_f := ListView_GetNextItem(lvHandle, -1, LVNI_ALL or LVNI_FOCUSED);
  if (i_f <> -1) then i := i_f;

  i := Subtitles.FindNextError(i);
  if i = -1 then
    beep
  else
  begin
    SetListViewOneSelected(i);
    ShowLine(i);
  end;
end;

procedure TfrmEditor.aPrevErrorExecute(Sender: TObject);
var
  i, i_f: integer;
begin
  i := ListView_GetTopIndex(lvHandle);
  i_f := ListView_GetNextItem(lvHandle, -1, LVNI_ALL or LVNI_FOCUSED);
  if (i_f <> -1) then i := i_f - 2;

  if i > 0 then
    i := Subtitles.FindPrevError(i)
  else
    i := -1;

  if i = -1 then
    beep
  else
  begin
    SetListViewOneSelected(i);
    ShowLine(i);
  end;
end;

procedure TfrmEditor.aAddBeforeLineExecute(Sender: TObject);
var
  SubtitleData: PSubtitleData;
  Start: double;
  Index: integer;
  i_f: integer;
begin
  new(SubtitleData);
  i_f := ListView_GetNextItem(lvHandle, -1, LVNI_ALL or LVNI_FOCUSED);
  if i_f = -1 then
    Index := Subtitles.Count
  else
    Index := i_f;

  if Subtitles.Count = 0 then
    Start := frmCinemaPlayer.MyCinema.CurrentPosition
  else
  begin
    Start := Subtitles.GetSubtitleAbsoleteStart(Index) - 3;
    if (Index > 0) and (Subtitles.GetSubtitleAbsoleteStart(Index - 1) >= Start) then
      Start := (Subtitles.GetSubtitleAbsoleteStart(Index - 1) + Subtitles.GetSubtitleAbsoleteStart(Index)) / 2;
  end;
  SubtitleData.Start := Start;
  SubtitleData.Stop := 0;
  Subtitles.AddItem('', SubtitleData, Index);
  Subtitles.RefreshViewer;

  SetListViewOneSelected(Index);
  ListView_SetItemState(lvHandle, Index, LVNI_FOCUSED, LVNI_FOCUSED);
  ShowLine(Index);
  meTimeStart.SetFocus;
end;

procedure TfrmEditor.aAddAfterLineExecute(Sender: TObject);
var
  SubtitleData: PSubtitleData;
  Start: double;
  Index: integer;
  i_f: integer;
begin
  new(SubtitleData);
  i_f := ListView_GetNextItem(lvHandle, -1, LVNI_ALL or LVNI_FOCUSED);
  if i_f = -1 then
    Index := Subtitles.Count
  else
    Index := i_f + 1;

  if Subtitles.Count = 0 then
    Start := frmCinemaPlayer.MyCinema.CurrentPosition
  else
  begin
    Start := Subtitles.GetSubtitleAbsoleteStart(Index - 1) + 3;
    if (Index < (Subtitles.Count - 1)) and (Subtitles.GetSubtitleStart(Index) <= Start) then
      Start := (Subtitles.GetSubtitleAbsoleteStart(Index - 1) + Subtitles.GetSubtitleAbsoleteStart(Index)) / 2;
  end;
  SubtitleData.Start := Start;
  SubtitleData.Stop := 0;
  Subtitles.AddItem('', SubtitleData, Index);
  Subtitles.RefreshViewer;
  SetListViewOneSelected(Index);
  ListView_SetItemState(lvHandle, Index, LVNI_FOCUSED, LVNI_FOCUSED);
  ShowLine(Index);
  meTimeStart.SetFocus;
end;

procedure TfrmEditor.aDelLineExecute(Sender: TObject);
var
  Index: integer;
  i: integer;
begin
  if ListView_GetSelectedCount(lvHandle) = 0 then
    exit;

  if not DisplayQuestion(Format(LangStor[LNG_MSG_CONFIRMDELETE], [ListView_GetSelectedCount(lvHandle)])) then
    exit;

  Index := ListView_GetNextItem(lvHandle, -1, LVNI_ALL or LVNI_FOCUSED);
  for i := ListView_GetItemCount(lvHandle) - 1 downto ListView_GetNextItem(lvHandle, -1, LVNI_ALL or LVNI_SELECTED) do
    if ListView_GetItemState(lvHandle, i, LVNI_SELECTED) = LVNI_SELECTED then
    begin
      Subtitles.Delete(i);
    end;
  Subtitles.RefreshViewer;
  ListView_RedrawItems(lvHandle, 0, ListView_GetItemCount(lvHandle) - 1);
  SetListViewOneSelected(-1);

  if Subtitles.Count <= Index then
    Index := Subtitles.Count - 1;

  if Index > 0 then
  begin
    ListView_SetItemState(lvHandle, Index, LVNI_FOCUSED, LVNI_FOCUSED);
    ShowLine(Index);
  end;
end;

procedure TfrmEditor.aSaveAsExecute(Sender: TObject);
begin
  with SaveDialog do
  begin
//    DefaultExt := Copy(ExtractFileExt(Subtitles.FileName), 2, MaxInt);
    FileName := Subtitles.FileName;
    Filter := SaveSubtitleExt;
    FilterIndex := integer(Subtitles.SubtitleType) + 1;
    if Execute then
      Subtitles.SaveToFile(FileName, TSubtitleType(FilterIndex - 1));
  end;
end;

procedure TfrmEditor.pnlEditorResize(Sender: TObject);
begin
  mEditLine.Width := pnlEditor.ClientWidth - (meDelay.Left + meDelay.Width + 14);
end;

procedure TfrmEditor.ReloadLang;
begin
  Self.Caption := LangStor[LNG_EDT_WINDOWCAPTION];
  aNew.Hint := LangStor[LNG_EDT_NEW];
  aSave.Hint := LangStor[LNG_EDT_SAVE];
  aSaveAs.Hint := LangStor[LNG_EDT_SAVEAS];
  aAddBeforeLine.Hint := LangStor[LNG_EDT_ADDBEFORE];
  aAddAfterLine.Hint := LangStor[LNG_EDT_ADDAFTER];
  aDelLine.Hint := LangStor[LNG_EDT_DELETE];
  aPrevError.Hint := LangStor[LNG_EDT_PREVERROR];
  aNextError.Hint := LangStor[LNG_EDT_NEXTERROR];
  aApplyChanges.Hint := LangStor[LNG_EDT_APPLYCHANGES];
  aFollowMovie.Hint := LangStor[LNG_EDT_FOLLOWMOVIE];
  aArrangeWindows.Hint := LangStor[LNG_EDT_ARRANGEWINDOWS];
  aTimeCorrector.Hint := LangStor[LNG_EDT_TIMECORRECTOR];
  ReloadLangTimeCorrector;
end;

procedure TfrmEditor.aTimeCorrectorExecute(Sender: TObject);
begin
  aTimeCorrector.Checked := not aTimeCorrector.Checked;

  if aTimeCorrector.Checked then
  begin
    CreateTimeCorrector(Handle, Subtitles);
  end
  else
  begin
    DestroyTimeCorrector;
  end;
end;

procedure TfrmEditor.FormShow(Sender: TObject);
begin
  ReloadLang;
  Windows.SetFocus(lvHandle);
end;

procedure TfrmEditor.NeedRefresh(Sender: TObject);
begin
  aSave.Enabled := (ListView_GetItemCount(lvHandle) <> 0) and Subtitles.Changed;
  aSaveAs.Enabled := (ListView_GetItemCount(lvHandle) <> 0);
  aAddBeforeLine.Enabled := frmCinemaPlayer.MyCinema.FileName <> '';
  aAddAfterLine.Enabled := aAddBeforeLine.Enabled;
//  aDelLine.Enabled := aAddBeforeLine.Enabled;
  aPrevError.Enabled := Subtitles.Count > 0;
  aNextError.Enabled := aPrevError.Enabled;
  aFollowMovie.Enabled := aPrevError.Enabled;
end;

function LVWndProc(hwnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  hti: TLVHitTestInfo;
  item: integer;
//  temp: array[0..1023] of char;
  i: integer;
  rc: TRect;
begin
  case Msg of
//    WM_CHAR:
//      DisplayMessage('WM_CHAR', 'debug');
    WM_KEYUP:
    begin
      if wParam = VK_TAB then
        if (GetKeyState(VK_SHIFT) < 0) then
          SetFocus(frmEditor.mEditLine.Handle)
        else
          SetFocus(frmEditor.meTimeStart.Handle);
    end;
    WM_KEYDOWN:
    begin
      if wParam = VK_F11 then
        frmCinemaPlayer.aSubEditor.Execute;
    end;
    WM_SIZE:
    begin
      GetClientRect(hwnd, rc);
      ListView_SetColumnWidth(
        hwnd, 3,
        rc.Right - ListView_GetColumnWidth(hwnd, 2) - ListView_GetColumnWidth(hwnd, 1) - ListView_GetColumnWidth(hwnd, 0));
//      InvalidateRect(hwnd, nil, false);
    end;
    WM_LBUTTONDBLCLK:
    begin
      hti.pt := Point(LOWORD(lParam), HIWORD(lParam));
      item := ListView_HitTest(hwnd, hti);
      if item <> -1 then
        frmCinemaPlayer.MyCinema.CurrentPosition := Subtitles.GetSubtitleStart(item) - 2;
    end;
    WM_CONTEXTMENU:
    begin
      LVPopupMenu := CreatePopupMenu;
      hti.pt.x := LOWORD(lParam);
      hti.pt.y := HIWORD(lParam);
      ScreenToClient(hwnd, hti.pt);
      item := ListView_HitTest(hwnd, hti);
      frmEditor.SetListViewOneSelected(item);
      ListView_SetItemState(hwnd, item, LVIS_FOCUSED, LVIS_FOCUSED);
      AddMenuItem(LVPopupMenu, 0, 0, MFS_DISABLED * cardinal(item = -1), 0,
                             CMD_ID_RESCALE_FROM, 0, 0, LangStor[LNG_EDT_RESCALEFROM]);
      AddMenuItem(LVPopupMenu, 0, 0, MFS_DISABLED * cardinal(item = -1), 0,
                             CMD_ID_RESCALE_TO, 1, 0, LangStor[LNG_EDT_RESCALETO]);

      ShowPopupMenu(LVPopupMenu, hwnd);
      LVPopupMenu := 0;
    end;
    WM_COMMAND:
      if (HIWORD(wParam) = 0) then
        case LOWORD(wParam) of
          CMD_ID_RESCALE_FROM:
          begin
            i := ListView_GetNextItem(hwnd, -1, LVNI_ALL or LVNI_SELECTED);
            Subtitles.SetRescaleFrom(i);
            SetRescaleInDlg(Subtitles.GetSubtitleStart(i), true);
          end;
          CMD_ID_RESCALE_TO:
          begin
            i := ListView_GetNextItem(hwnd, -1, LVNI_ALL or LVNI_SELECTED);
            Subtitles.SetRescaleTo(i);
            SetRescaleInDlg(Subtitles.GetSubtitleStart(i), false);
          end;
        end;
//  else
//    Result := CallWindowProc(oldLVWndProc, hwnd, Msg, wParam, lParam);
  end;
  Result := CallWindowProc(oldLVWndProc, hwnd, Msg, wParam, lParam);
end;

procedure TfrmEditor.CreateListView;
var
  lvc: TLVColumn;
  nDPIFactor: integer;
begin
  lvHandle := CreateWindowEx(WS_EX_CLIENTEDGE, WC_LISTVIEW, '',
           WS_VISIBLE or WS_CHILD or WS_BORDER or WS_TABSTOP or WS_CHILD or
           LVS_REPORT or LVS_OWNERDATA or LVS_OWNERDRAWFIXED or LVS_NOSORTHEADER or LVS_SHAREIMAGELISTS,
           0, tbarMain.Height, ClientWidth, ClientHeight - tbarMain.Height - pnlEditor.Height,
           Handle, 0, hInstance, nil);
  oldLVWndProc := Pointer(SetWindowLong(lvHandle, GWL_WNDPROC, integer(@LVWndProc)));
  ListView_SetImageList(lvHandle, frmCinemaPlayer.ilNormal.Handle, LVSIL_SMALL);
  ListView_SetExtendedListViewStyle(lvHandle, LVS_EX_FULLROWSELECT);

  lvc.mask := LVCF_FMT or LVCF_WIDTH or LVCF_SUBITEM;
  lvc.fmt := LVCFMT_LEFT;
  lvc.cx := LV_COL0_WIDTH;
  lvc.iSubItem := 0;
  ListView_InsertColumn(lvHandle, 0, lvc);

  lvc.mask := LVCF_FMT or LVCF_WIDTH or LVCF_TEXT or LVCF_SUBITEM;
  lvc.fmt := LVCFMT_RIGHT;
  lvc.cx := LV_COL1_WIDTH;
  lvc.iSubItem := 1;
  lvc.pszText := 'Start';
  ListView_InsertColumn(lvHandle, 1, lvc);

  lvc.cx := LV_COL2_WIDTH;
  lvc.iSubItem := 2;
  lvc.pszText := 'Delay';
  ListView_InsertColumn(lvHandle, 2, lvc);

  lvc.fmt := LVCFMT_LEFT;
  lvc.cx := LV_COL3_WIDTH;
  lvc.iSubItem := 3;
  lvc.pszText := 'Text';
  ListView_InsertColumn(lvHandle, 3, lvc);

//  EnableWindow(ListView_GetHeader(lvHandle), false);
  BringWindowToTop(lvHandle);
end;

procedure TfrmEditor.FormResize(Sender: TObject);
//var
//  rc: TRect;
begin
  if lvHandle <> 0 then
  begin
    SetWindowPos(lvHandle, 0, 0, tbarMain.Height, ClientWidth, ClientHeight - tbarMain.Height - pnlEditor.Height, SWP_NOZORDER);
//    Windows.GetClientRect(lvHandle, rc);
//    ListView_SetColumnWidth(lvHandle, 3, rc.Right - LV_COL2_WIDTH - LV_COL1_WIDTH - LV_COL0_WIDTH);
  end;
end;

procedure TfrmEditor.SetListViewOneSelected(index: integer);
var
  i: integer;
begin
  i := -1;
  while ListView_GetSelectedCount(lvHandle) > 0 do
  begin
    i := ListView_GetNextItem(lvHandle, i, LVNI_ALL or LVNI_SELECTED);
    ListView_SetItemState(lvHandle, i, 0, LVIS_SELECTED);
  end;
  if index > -1 then
    ListView_SetItemState(lvHandle, index, LVIS_SELECTED or LVIS_FOCUSED, LVIS_SELECTED or LVIS_FOCUSED);
end;

procedure TfrmEditor.FormDestroy(Sender: TObject);
begin
  DestroyWindow(lvHandle);
end;

procedure TfrmEditor.WMNotify(var msg: TWMNotify);
var
  hwnd: THandle;
  item: integer;
//  temp: array[0..1023] of char;
  i: integer;
//  rc: TRect;
begin
  if msg.NMHdr.hwndFrom = lvHandle then
  begin
    hwnd := msg.NMHdr.hwndFrom;
    case msg.NMHdr.code of
      LVN_ITEMCHANGED:
      begin
        i := ListView_GetSelectedCount(hwnd);
        frmEditor.aDelLine.Enabled := i > 0;
        frmEditor.aApplyChanges.Enabled := i = 1;
        frmEditor.meTimeStart.Enabled := i = 1;
        frmEditor.meDelay.Enabled := i = 1;
        frmEditor.mEditLine.Enabled := i = 1;
        if i = 1 then
        begin
          item := ListView_GetNextItem(hwnd, -1, LVNI_ALL or LVNI_SELECTED);
          frmEditor.meTimeStart.Text := PrepareTime(Subtitles.GetSubtitleStart(item), true);
          frmEditor.meDelay.Text := FormatFloat('0.000', Subtitles.GetSubtitleStop(item));
          frmEditor.mEditLine.Lines.Text := Subtitles.GetSubtitle(item);
        end
        else
        begin
          frmEditor.mEditLine.Clear;
          frmEditor.meTimeStart.Text := '';
          frmEditor.meDelay.Text := '';
        end;
      end;
    end;
  end
  else inherited;
end;

procedure TfrmEditor.WMDrawItem(var msg: TWMDrawItem);
var
  rc: TRect;
  color, text_color: COLORREF;
  h_font, old_font: HFONT;
  l_font: LOGFONT;
  temp: string;
  i: integer;
//  imageIndex: integer;
begin
  with msg.DrawItemStruct^ do
    if (CtlType = ODT_LISTVIEW) and (hwndItem = lvHandle) then
    begin
      if itemID <> $ffffffff then
      begin
//        imageIndex := iconNone;
        if ((itemState and ODS_SELECTED) <> 0) {and (GetFocus = hwndItem) }then
        begin
          color := COLOR_HIGHLIGHT;
          text_color := clWhite;
        end
        else
        begin
          color := COLOR_WINDOW;
          text_color := COLOR_WINDOWTEXT;
        end;
        rc := rcItem;
        rc.Left := 17;
        FillRect(hDC, rc, GetSysColorBrush(color));
        if (itemID > 0) and (Subtitles.GetSubtitleStart(itemID - 1) >= Subtitles.GetSubtitleStart(itemID)) then
        begin
          text_color := clRed;
          ImageList_DrawEx(frmCinemaPlayer.ilNormal.Handle, 39,
            hDC, 1, rcItem.Top, frmCinemaPlayer.ilNormal.Width, frmCinemaPlayer.ilNormal.Height,
            CLR_NONE, CLR_NONE, 0);
//          imageIndex := iconError;
        end;

        SetTextColor(hDC, 0);

        if ((itemState and ODS_FOCUS) <> 0) and (GetFocus = hwndItem) then
        begin
          rc := rcItem;
          rc.Left := 17;
          DrawFocusRect(hDC, rc);
        end;

        SetTextColor(hDC, text_color);

        if (itemID = UINT(CurrentLineNumber)) and aFollowMovie.Checked then
        begin
          with l_font do
          begin
            lfHeight := -MulDiv(8, GetDeviceCaps(hDC, LOGPIXELSY), 72);
            lfWidth := 0;
            lfEscapement := 0;
            lfOrientation := 0;
            lfWeight := FW_DONTCARE;
            lfItalic := 0;
            lfUnderline := 1;
            lfStrikeOut := 0;
            lfCharSet := DEFAULT_CHARSET;
            lfOutPrecision := OUT_DEFAULT_PRECIS;
            lfClipPrecision := CLIP_DEFAULT_PRECIS;
            lfQuality := DEFAULT_QUALITY;
            lfPitchAndFamily := DEFAULT_PITCH;
            ZeroMemory(@lfFaceName, 32);
            GetTextFace(hDC, 32, lfFaceName);
          end;
          if h_font = 0 then
          begin
            beep;
            exit;
          end;
          h_font := CreateFontIndirect(l_font);
          old_font := SelectObject(hDC, h_font);
        end;

        rc.Left := Max(ListView_GetColumnWidth(hwndItem, 0) + 5, rcItem.Left);
        rc.Right := Min(ListView_GetColumnWidth(hwndItem, 0) + ListView_GetColumnWidth(hwndItem, 1) - 5, rcItem.Right);
        DrawText(hDC, PChar(PrepareTime(Subtitles.GetSubtitleStart(itemID), true)), -1,
                      rc, DT_RIGHT or DT_END_ELLIPSIS or DT_VCENTER or DT_SINGLELINE);

        rc.Left := Max(ListView_GetColumnWidth(hwndItem, 0) + ListView_GetColumnWidth(hwndItem, 1) + 5, rcItem.Left);
        rc.Right := Min(ListView_GetColumnWidth(hwndItem, 0) + ListView_GetColumnWidth(hwndItem, 1) + ListView_GetColumnWidth(hwndItem, 2) - 5, rcItem.Right);
        DrawText(hDC, PChar(FormatFloat('0.000', Subtitles.GetSubtitleStop(itemID))), -1,
                      rc, DT_RIGHT or DT_END_ELLIPSIS or DT_VCENTER or DT_SINGLELINE);

        rc.Left := Max(ListView_GetColumnWidth(hwndItem, 0) + ListView_GetColumnWidth(hwndItem, 1) + ListView_GetColumnWidth(hwndItem, 1) + 5, rcItem.Left);
        rc.Right := rcItem.Right - 5;

        temp := Subtitles.GetSubtitle(itemID);
        for i := 1 to Length(temp) do
          if temp[i] = #13 then temp[i] := '|';
        DrawText(hDC, PChar(temp), -1, rc, DT_LEFT or DT_END_ELLIPSIS or DT_VCENTER or DT_SINGLELINE);

        if (itemID = UINT(CurrentLineNumber)) then
        begin
          SelectObject(hDC, old_font);
          DeleteObject(h_font);
        end;
      end;
    end
    else inherited;
  msg.Result := 1;
end;

procedure TfrmEditor.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
  if Msg.CharCode = VK_TAB then
    if ((meTimeStart.Focused) and (ssCtrl in KeyDataToShiftState(Msg.KeyData))) or
       ((mEditLine.Focused) and not (ssCtrl in KeyDataToShiftState(Msg.KeyData))) then
    begin
      Handled := true;
      Windows.SetFocus(lvHandle);
    end;
end;

procedure TfrmEditor.WMGetMinMaxInfo(var Msg: TMessage);
begin
  with Msg do
    with PMinMaxInfo(lParam)^.ptMinTrackSize do
    begin
      x := 324;
      y := 150;
      Result := 0;
    end;
  inherited;
end;

procedure TfrmEditor.RefreshListView;
begin
  ListView_RedrawItems(lvHandle, 0, Subtitles.Count - 1);
//  ListView_RedrawItems(lvHandle, -1, - 1);
  UpdateWindow(lvHandle);
end;

procedure TfrmEditor.aFollowMovieExecute(Sender: TObject);
var
  nLineNo: integer;
begin
  aFollowMovie.Checked := not aFollowMovie.Checked;
  nLineno := Subtitles.FindCurrentText(frmCinemaPlayer.MyCinema.CurrentPosition, true);
  if nLineno < 0 then
    nLineno := 0;
  ShowLine(nLineNo);
end;

procedure TfrmEditor.aArrangeWindowsExecute(Sender: TObject);
var
  WorkArea,
  tempRect: TRect;
begin
  if ChangeResolution.FullScreen then
    frmCinemaPlayer.aRetToWin.Execute;

  SystemParametersInfo(SPI_GETWORKAREA, 0, @WorkArea, 0);
  tempRect := WorkArea;
  tempRect.Bottom := tempRect.Bottom div 2;
  frmCinemaPlayer.BoundsRect := tempRect;
  tempRect := WorkArea;
  tempRect.Top := tempRect.Bottom div 2;
  BoundsRect := tempRect;
end;

end.
