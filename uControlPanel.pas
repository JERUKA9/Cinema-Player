unit uControlPanel;

interface

uses
  Windows, Messages, cp_TrackBars, settings_header;

type
  tControlPanelDesign = (cpdMicro, cpdMini, cpdStandart);
  tControlPanelMode = (cpmEmbeded, cpmFree);

  tControlPanelStatusType = (
    cpsPlayerState,
    cpsFormat,
    cpsRate,
    cpsMedianame,
    cpsSubtitles,
    cpsCurrTime,
    cpsTopTime);

  tControlPanelStatusItem = record
    szText: string;
    bVisible: boolean;
    rcBounds: TRect;
  end;

  tControlPanel = class(TObject)
  private
    fHandle: HWND;
    fDesign: tControlPanelDesign;
    fMode: tControlPanelMode;
    fOldStatusWndProc: Pointer;
    frcStatus: TRect;
    fStatus: array[tControlPanelStatusType] of tControlPanelStatusItem;
    fbLMBDownInCurrTime: boolean;
  private
    function wndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): cardinal;
    procedure paintStatus();
  public
    constructor create(const handle: HWND; const cpd: tControlPanelDesign;
      const cpm: tControlPanelMode);
    destructor destroy; override;

    procedure calculate;
    procedure setMode(const cpm: tControlPanelMode);
    procedure setDesign(const cpd: tControlPanelDesign);
    procedure setVisible(const state: boolean);
    procedure setHandle(const handle: HWND);
    function isVisibled: boolean;

    function getHeight: integer;
    procedure gotoFullscreen;
    procedure gotoNormalWindow;

    procedure setStatus(const aszText: string; cps: tControlPanelStatusType);
    function getStatus(cps: tControlPanelStatusType): string;
//    function isStandartView: boolean;
  end;

var
  control_panel: tControlPanel;

implementation

uses
  main, cp_utils;

const
  CONTROLPANEL_HEIGHT       = 61;
  MINICONTROLPANEL_HEIGHT   = 26;
  STATUS_HEIGHT             = 18;


function statusWndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): cardinal; stdcall;
begin
  Result := control_panel.wndProc(hWnd, Msg, wParam, lParam);
end;

{ tControlPanel }

constructor tControlPanel.Create(const handle: HWND; const cpd: tControlPanelDesign;
  const cpm: tControlPanelMode);
begin
  fHandle := handle;
  fOldStatusWndProc := Pointer(SetWindowLong(fHandle, GWL_WNDPROC, integer(@statusWndProc)));
  fMode := cpm;
  fDesign := cpd;
  fbLMBDownInCurrTime := false;
end;

destructor tControlPanel.Destroy;
begin
  SetWindowLong(fHandle, GWL_WNDPROC, integer(fOldStatusWndProc));
  inherited;
end;

function tControlPanel.getHeight: integer;
const
  height: array[tControlPanelDesign] of integer = (0, MINICONTROLPANEL_HEIGHT, CONTROLPANEL_HEIGHT);
begin
  Result := height[fDesign];
end;

function tControlPanel.getStatus(cps: tControlPanelStatusType): string;
begin
  Result := fStatus[cps].szText;
end;

procedure tControlPanel.gotoFullscreen;
begin
//TODO zmieniæ stan akcji
  if (not config.ViewStandard) and config.ForceStdCtrlPanelMode then
    setDesign(cpdStandart);
  fStatus[cpsMediaName].bVisible := true;
end;

procedure tControlPanel.gotoNormalWindow;
begin
//TODO zmieniæ stan akcji
  if (not config.ViewStandard) and config.ForceStdCtrlPanelMode then
    setDesign(cpdMini);
  fStatus[cpsMediaName].bVisible := false;
end;

function tControlPanel.isVisibled: boolean;
begin
  Result := IsWindowVisible(fHandle);
end;

procedure tControlPanel.paintStatus();
var
  dc, memDC: HDC;
  memBitmap, oldBitmap: HBITMAP;
  oldFont: HFONT;
  ps: TPaintStruct;
  rc: TRect;

  procedure drawStatusItem(cps: tControlPanelStatusType; nAlign: cardinal);
  begin
   if not fStatus[cps].bVisible then
     exit;

    rc := fStatus[cps].rcBounds;
    OffsetRect(rc, 0, -rc.Top);
    DrawText(memDC, PChar(fStatus[cps].szText), -1, rc, nAlign or DT_SINGLELINE or DT_VCENTER);
  end;

begin
  dc := GetDC(0);
  memBitmap := CreateCompatibleBitmap(
    dc,
    frcStatus.Right - frcStatus.Left,
    frcStatus.Bottom - frcStatus.Top);
  ReleaseDC(0, dc);
  memDC := CreateCompatibleDC(0);
  oldBitmap := SelectObject(memDC, memBitmap);
  oldFont := SelectObject(memDC, GetStockObject(DEFAULT_GUI_FONT));
//  SetBkMode(memDC, TRANSPARENT);
  SetBkColor(memDC, RGB(0, 0, 0));
  SetTextColor(memDC, RGB(255, 255, 255));
  try
    rc := frcStatus;
    OffsetRect(rc, -rc.Left, -rc.Top);
    FillRect(memDC, rc, GetStockObject(BLACK_BRUSH));
    drawStatusItem(cpsPlayerState, DT_LEFT);
    drawStatusItem(cpsFormat, DT_LEFT);
    drawStatusItem(cpsRate, DT_LEFT);
    drawStatusItem(cpsMedianame, DT_LEFT);
    drawStatusItem(cpsSubtitles, DT_RIGHT or DT_NOCLIP);
    drawStatusItem(cpsTopTime, DT_LEFT);
    if config.ReverseTime then
      SetTextColor(memDC, RGB(0, 255, 255));
    drawStatusItem(cpsCurrTime, DT_RIGHT);
    dc := BeginPaint(fHandle, ps);
    BitBlt(dc, frcStatus.Left, frcStatus.Top, frcStatus.Right, frcStatus.Bottom, memDC, 0, 0, SRCCOPY);
    EndPaint(fHandle, ps);
  finally
    SelectObject(memDC, oldBitmap);
    SelectObject(memDC, oldFont);
    DeleteDC(memDC);
    DeleteObject(memBitmap);
  end;
end;

procedure tControlPanel.calculate;
var
  rc, r: TRect;
//  nStatusWidth: integer;
begin
  GetClientRect(fHandle, rc);
  r := rc;

  case fDesign of
    cpdMicro: ;
    cpdMini:
    begin
  // tollbar
      r.Top := 0;
      r.Bottom := 26;
      r.Right := 190;
      SetSize(frmCinemaPlayer.ToolBar.Handle, r);

  // suwaki
      r.Top := 0;
      r.Bottom := 14;
      r.Left := r.Right;
      if rc.Right > 350 then
        r.Right := rc.Right - 51
      else
        r.Right := rc.Right;
      SetSize(frmCinemaPlayer.ptbPosition.Handle, r);
  //status
      r.Top := 14;
      r.Bottom := 26;
      dec(r.Right);
      frcStatus := r;
  // volume
      r.Left := r.Right;
      r.Right := rc.Right;
      r.Top := rc.Top;
      SetSize(frmCinemaPlayer.vtbVolume.Handle, r);
      r := frcStatus;
    end;
    cpdStandart:
    begin
  // suwaki
      r.Bottom := 18;
      dec(r.Right, 51);
      SetSize(frmCinemaPlayer.ptbPosition.Handle, r);
      r.Left := r.Right;
      r.Right := rc.Right;
      SetSize(frmCinemaPlayer.ptbSpeed.Handle, r);
  // tollbar
      r.Top := 17;
      r.Bottom := 17 + 26;
      r.Right := rc.Right - 75;
      r.Left := 0;
      SetSize(frmCinemaPlayer.ToolBar.Handle, r);
  // volume
      r.Top := 17;
      r.Bottom := 17 + 26;
      r.Left := r.Right - 2;
      r.Right := r.Left + 27;
      SetSize(frmCinemaPlayer.ToolBarV.Handle, r);
      r.Left := r.Right - 1;
      r.Right := rc.Right;
      SetSize(frmCinemaPlayer.vtbVolume.Handle, r);
  //status
      inc(r.Top, 26);
      r.Bottom := rc.Bottom;
      r.Left := 0;
      frcStatus := r;
    end;
  end;
  r.Left := 7;
  r.Right := 84;
  fStatus[cpsPlayerState].rcBounds := r;
  r.Left := 88;
  r.Right := frcStatus.Right - frcStatus.Left - (538 - 426);
  fStatus[cpsFormat].rcBounds := r;
  r.Left := 144;
  r.Right := 270;//rc.Right - (538 - 426);
  fStatus[cpsRate].rcBounds := r;
  r.Left := 270;
  r.Right := frcStatus.Right - frcStatus.Left - (538 - 426);
  fStatus[cpsMedianame].rcBounds := r;

  r.Left := frcStatus.Right - frcStatus.Left - (538 - 426);
  r.Right := frcStatus.Right - frcStatus.Left - (538 - 426);
  fStatus[cpsSubtitles].rcBounds := r;
  r.Left := frcStatus.Right - frcStatus.Left - (538 - 426);
  r.Right := frcStatus.Right - frcStatus.Left - (538 - 481);
  fStatus[cpsCurrTime].rcBounds := r;
  r.Left := frcStatus.Right - frcStatus.Left - (538 - 487);
  r.Right := frcStatus.Right - frcStatus.Left;
  fStatus[cpsTopTime].rcBounds := r;

  frmCinemaPlayer.vtbVolume.Visible := frmCinemaPlayer.pnlControl.Visible and (rc.Right > 350);

  fStatus[cpsPlayerState].bVisible := rc.Right > 420;
  fStatus[cpsTopTime].bVisible := rc.Right > 295;
  fStatus[cpsCurrTime].bVisible := rc.Right > 235;
  fStatus[cpsSubtitles].bVisible := not config.OSDEnabled and (fDesign = cpdStandart);
  if not fStatus[cpsTopTime].bVisible then
    OffsetRect(fStatus[cpsCurrTime].rcBounds, fStatus[cpsCurrTime].rcBounds.Right - fStatus[cpsCurrTime].rcBounds.Left - 4, 0);
end;

procedure tControlPanel.setDesign(const cpd: tControlPanelDesign);
var
  r, rp: TRect;
begin
//  if fDesign = cpd then
//    exit;
  fDesign := cpd;
  GetClientRect(fHandle, r);
  GetClientRect(GetParent(fHandle), rp);
  with frmCinemaPlayer do
  begin
    case cpd of
      cpdMicro: ;
      cpdMini:
      begin
        r.Bottom := MINICONTROLPANEL_HEIGHT;
        tbSep1.Visible := false;
        tbSkipBack.Visible := false;
        tbRewind.Visible := false;
        tbFastForward.Visible := false;
        tbSkipForward.Visible := false;
        tbSep2.Visible := false;
        tbOpenMovie.Visible := false;
        tbOpenMovie2.Visible := true;
        tbSep3.Visible := false;
        tbFixedFullScreen.Visible := false;
        tbViewMinimal.Visible := false;
        tbViewStandard.Visible := true;
        tbHideText.Visible := false;
        tbStayOnTop.Visible := false;
        tbSep4.Visible := false;
        tbPlaylist.Visible := false;
        tbSubEditor.Visible := false;
        tbOptions.Visible := false;
        ToolBar.ButtonWidth := 22;

        ToolBarV.Visible := false;

        ptbSpeed.Visible := false;
        ptbPosition.MinimalView := true;
        ptbPosition.EdgeBorders := [ebLeft, ebRight];

        fStatus[cpsFormat].bVisible := false;
        fStatus[cpsRate].bVisible := false;
//        fStatus[cpsSubtitles].bVisible := false;
      end;
      cpdStandart:
      begin
        r.Bottom := CONTROLPANEL_HEIGHT;
        tbSep1.Visible := true;
        tbSkipBack.Visible := true;
        tbRewind.Visible := true;
        tbFastForward.Visible := true;
        tbSkipForward.Visible := true;
        tbSep2.Visible := true;
        tbOpenMovie.Visible := true;
        tbOpenMovie2.Visible := false;
        tbSep3.Visible := true;
        tbFixedFullScreen.Visible := true;
        tbViewMinimal.Visible := true;
        tbViewStandard.Visible := false;
        tbHideText.Visible := true;
        tbStayOnTop.Visible := true;
        tbSep4.Visible := true;
        tbPlaylist.Visible := true;
        tbSubEditor.Visible := true;
        tbOptions.Visible := true;
        ToolBar.ButtonWidth := 23;

        ToolBarV.Visible := true;

        fStatus[cpsFormat].bVisible := true;
        fStatus[cpsRate].bVisible := true;
//        fStatus[cpsSubtitles].bVisible := true;

        ptbSpeed.Visible := true;
        ptbPosition.MinimalView := false;
        ptbPosition.EdgeBorders := [ebBottom];
      end;
    end;
    ToolBar.Images := ilNormal;
  end;
end;

procedure tControlPanel.setHandle(const handle: HWND);
begin
  fHandle := handle;
  setDesign(fDesign);
  calculate;
end;

procedure tControlPanel.setMode(const cpm: tControlPanelMode);
begin
  fMode := cpm;
end;

procedure tControlPanel.setStatus(const aszText: string;
  cps: tControlPanelStatusType);
begin
  fStatus[cps].szText := aszText;
  InvalidateRect(fHandle, nil, false);
end;

procedure tControlPanel.setVisible(const state: boolean);
const
  show_state: array[boolean] of DWORD = (SW_HIDE, SW_SHOW);
begin
  ShowWindow(fHandle, show_state[state]);
  frmCinemaPlayer.ptbSpeed.Visible := state and (fDesign = cpdStandart);
  frmCinemaPlayer.ToolBarV.Visible := state and (fDesign = cpdStandart);
end;

function tControlPanel.wndProc(hWnd: HWND; Msg, wParam,
  lParam: cardinal): cardinal;
var
  p: TPoint;
  r: TRect;
begin
  case Msg of
    WM_PAINT:
    begin
      paintStatus();
      Result := 0;
    end;
    WM_LBUTTONDOWN:
    begin
      p.x := LOWORD(lParam);
      p.y := HIWORD(lParam);
      r := fStatus[cpsCurrTime].rcBounds;
      OffsetRect(r, frcStatus.Left, 0);
      fbLMBDownInCurrTime :=
        PtInRect(r, p) and
        fStatus[cpsCurrTime].bVisible and (fStatus[cpsCurrTime].szText <> '');
    end;
    WM_LBUTTONUP:
    begin
      p.x := LOWORD(lParam);
      p.y := HIWORD(lParam);
      r := fStatus[cpsCurrTime].rcBounds;
      OffsetRect(r, frcStatus.Left, 0);
      if fbLMBDownInCurrTime and PtInRect(r, p) then
        frmCinemaPlayer.aTimeReverse.Execute;
      fbLMBDownInCurrTime := false;
    end;
  else
    Result := CallWindowProc(fOldStatusWndProc, hWnd, Msg, wParam, lParam);
  end;
end;

end.
