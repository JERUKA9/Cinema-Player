unit cp_FrameManager;

interface

uses
  Windows, Classes, SysUtils, cp_CinemaEngine;

type

  TAspectRatioMode =
  (
    arOriginal,
    arFree,
    ar16to9,
    ar4to3,
    ar2_35to1,
    arCustom
  );

  TCPDisplaySize =
  (
    cpHalfSize,
    cpNormalSize,
    cpDoubleSize
  );

  TCenterPoint = record
    Horiz: double;
    Vert: double;
  end;

  TFrameManager = class(TObject)
  private
    cp: TCinema;
    aspect_ratio: TAspectRatioMode;
    zoom: double;
    display_size: TCPDisplaySize;
    center_point: TCenterPoint;
    org_width: integer;
    org_height: integer;
    aspect_ratio_value: double;
    is_hold_coords: boolean;
    FChangeAspectRatio: TNotifyEvent;
    procedure DoChangeAscpectRatio;
  public
    constructor Create;
    destructor Destroy; override;

    function get_aspect_ratio: TAspectRatioMode;
    procedure set_aspect_ratio(const value: TAspectRatioMode);
    function get_center_point: TCenterPoint;
    procedure set_center_point(const value: TCenterPoint);
    function get_zoom: double;
    procedure set_zoom(const value: double);
    procedure set_hold_coords(const value: boolean);
    function get_display_size: TCPDisplaySize;
    procedure set_display_size(const value: TCPDisplaySize);
    function get_video_rect: TRect;
    procedure set_video_rect(const value: TRect);

    procedure set_size(w, h: integer);
    function get_next_aspect_ratio: TAspectRatioMode;
    function get_aspect_value: double;
    procedure change_video_pos(new_size: PRect = nil; keep_aspect: boolean = true);
    procedure assign_cinema(const engine: TCinema);

    property OnChangeAspectRatio: TNotifyEvent read FChangeAspectRatio write FChangeAspectRatio;
  end;

implementation

uses
  cp_utils;

{ TFrameManager }

procedure TFrameManager.assign_cinema(const engine: TCinema);
begin
  cp := engine;
end;

procedure TFrameManager.change_video_pos(new_size: PRect;
  keep_aspect: boolean);
var
  NewViewSize: TSize;
  DestRect: TRect;
  TmpAspectRatio: double;
begin
  if cp.IsVideo and (cp.PlayState <> cpClosed) {and FCanResize }then
  begin
    if new_size = nil then
    begin
      NewViewSize.cx := cp.ClientRect.Right - cp.ClientRect.Left;
      NewViewSize.cy := cp.ClientRect.Bottom - cp.ClientRect.Top;

      DestRect := cp.ClientRect;

{$IFDEF DEBUG}
      with destrect do
      WriteLog('ChngVidPos.NewS=nil', Format('Rect: (%4d,%4d); (%4d,%4d); Zoom: %5f',
        [Left, Top, Right, Bottom, zoom]));
{$ENDIF}
    end
    else
      with new_size^ do
      begin
        NewViewSize.cx := Right - Left;
        NewViewSize.cy := Bottom - Top;

        if not is_hold_coords then
        begin
          center_point.Horiz := (Left + Right) / 2 / cp.ClientWidth;// Self.Width;
          center_point.Vert := (Top + Bottom) / 2 / cp.ClientHeight;// Self.Height;
        end;

        DestRect := new_size^;

{$IFDEF DEBUG}
      with destrect do
      WriteLog('ChngVidPos.NewS<>nil', Format('Rect: (%4d,%4d); (%4d,%4d); Zoom: %5f',
        [Left, Top, Right, Bottom, zoom]));
{$ENDIF}
      end;

    TmpAspectRatio := NewViewSize.cx / NewViewSize.cy;

    if (not keep_aspect) and (aspect_ratio = arCustom) then
      aspect_ratio_value := TmpAspectRatio;

{$IFDEF DEBUG}
      with destrect do
      WriteLog('ChngVidPos.Aspect', Format('Tmp: %5.4f; Aspect: %5.4f',
        [TmpAspectRatio, get_aspect_value]));

      WriteLog('ChngVidPos.NVS', Format('Width: %4d; Heigth: %4d',
        [NewViewSize.Width, NewViewSize.Height]));
{$ENDIF}
    with DestRect do
    begin
      if keep_aspect then
      begin
        if (get_aspect_value - TmpAspectRatio) > 0.001 then
        begin
          InflateRect(DestRect, 0, -round((NewViewSize.cy - (NewViewSize.cx / get_aspect_value)) / 2));

{$IFDEF DEBUG}
      WriteLog('ChngVidPos.CalcZoom', Format('NVSW: %4d; ClntW %4d',
        [NewViewSize.Width, cp.ClientRect.Right]));
      with destrect do
      WriteLog('ChngVidPos.AspectW', Format('Rect: (%4d,%4d); (%4d,%4d); Zoom: %5f',
        [Left, Top, Right, Bottom, zoom]));
{$ENDIF}
        end
        else
          if (TmpAspectRatio - get_aspect_value) > 0.001 then
          begin
            InflateRect(DestRect, -round((NewViewSize.cx - (NewViewSize.cy * get_aspect_value)) / 2), 0);

{$IFDEF DEBUG}
      WriteLog('ChngVidPos.CalcZoom', Format('NVSH: %4d; ClntH %4d',
        [NewViewSize.height, cp.ClientRect.bottom]));
      with destrect do
      WriteLog('ChngVidPos.AspectH', Format('Rect: (%4d,%4d); (%4d,%4d); Zoom: %5f',
        [Left, Top, Right, Bottom, zoom]));
{$ENDIF}
          end;
      end;
      if (new_size <> nil) and not is_hold_coords then
        if (NewViewSize.cx / cp.ClientRect.Right) > (NewViewSize.cy / cp.ClientRect.Bottom) then
          zoom := NewViewSize.cx / cp.ClientRect.Right
        else
          zoom := NewViewSize.cy / cp.ClientRect.Bottom;
{      else
        if VPAspectRatio < FAspectRatio then
          InflateRect(DestRect, 0, -round((ViewPortSize.Height - (ViewPortSize.Width / FAspectRatio)) / 2))
        else
          if VPAspectRatio > FAspectRatio then
            InflateRect(DestRect, -round((ViewPortSize.Width - (ViewPortSize.Height * FAspectRatio)) / 2), 0);

{           if Form1.PanScan1.checked then
        begin
          tmpReal[0] := right / 100;
          tmpReal[1] := bottom / 100;

          left := left - trunc((PanScanPercent / 2) * tmpReal[0]);
          top := top - trunc((PanScanPercent / 2) * tmpReal[1]);
          right := right + trunc(((PanScanPercent / 2) * tmpReal[0]) * 2);
          bottom := bottom + trunc(((PanScanPercent / 2) * tmpReal[1]) * 2);
        end;}

      if new_size = nil then
      begin
// skalowanie
        InflateRect(DestRect,
          round((Right - Left) * (zoom - 1) / 2),      // dx
          round((Bottom - Top) * (zoom - 1) / 2));     // dy

{$IFDEF DEBUG}
      with destrect do
      WriteLog('ChngVidPos.Inflate', Format('Rect: (%4d,%4d); (%4d,%4d); Zoom: %5f',
        [Left, Top, Right, Bottom, zoom]));
{$ENDIF}
// korekcja po³o¿enia
        OffsetRect(DestRect,
          round(cp.Width * (center_point.Horiz - 0.5)),      // dx
          round(cp.Height * (center_point.Vert - 0.5)));     // dy
{$IFDEF DEBUG}
      WriteLog('ChngVidPos.Offset', Format('Rect: (%4d,%4d); (%4d,%4d); Zoom: %5f',
        [Left, Top, Right, Bottom, zoom]));
{$ENDIF}
      end;
{$IFDEF DEBUG}
      WriteLog;
{$ENDIF}
      cp.SetVideoPos(DestRect);
//      pVideoWindow.SetWindowPosition(Left, Top, Right - Left, Bottom - Top);
    end;
  end;
end;

constructor TFrameManager.Create;
begin
  zoom := 1.0;
  display_size := cpNormalSize;
  aspect_ratio := arOriginal;
  center_point.Horiz := 0.5;
  center_point.Vert := 0.5;
  is_hold_coords := false;
end;

destructor TFrameManager.Destroy;
begin
  inherited Destroy;
end;

procedure TFrameManager.DoChangeAscpectRatio;
begin
  if Assigned(OnChangeAspectRatio) then
    OnChangeAspectRatio(Self);
end;

function TFrameManager.get_aspect_ratio: TAspectRatioMode;
begin
  Result := aspect_ratio;
end;

function TFrameManager.get_aspect_value: double;
begin
  case aspect_ratio of
    arOriginal:
      Result := cp.VideoSize.cx / cp.VideoSize.cy;
    arFree:
      Result := cp.Width / cp.Height;
    ar16to9:
      Result := 16 / 9;
    ar4to3:
      Result := 4 / 3;
    ar2_35to1:
      Result := 2.35 / 1;
    else
      Result := aspect_ratio_value;
  end;
end;

function TFrameManager.get_center_point: TCenterPoint;
begin
  Result := center_point;
end;

function TFrameManager.get_display_size: TCPDisplaySize;
begin
  Result := display_size;
end;

function TFrameManager.get_video_rect: TRect;
begin

end;

function TFrameManager.get_zoom: double;
begin
  Result := zoom;
end;

function TFrameManager.get_next_aspect_ratio: TAspectRatioMode;
begin
  Result := Succ(aspect_ratio);
  if Result >= High(TAspectRatioMode) then
    Result := Low(TAspectRatioMode);
{
  if aspect_ratio = High(TAspectRatioMode) then
    set_aspect_ratio(Low(TAspectRatioMode))
  else
  begin
    set_aspect_ratio(Succ(aspect_ratio));
    if aspect_ratio = High(TAspectRatioMode) then
      set_aspect_ratio(Low(TAspectRatioMode));
  end;
}
end;

procedure TFrameManager.set_aspect_ratio(const value: TAspectRatioMode);
begin
  aspect_ratio := Value;
  case aspect_ratio of
    arOriginal:
      aspect_ratio_value := cp.VideoSize.cx / cp.VideoSize.cy;
    arFree:
      aspect_ratio_value := cp.Width / cp.Height;
    ar16to9:
      aspect_ratio_value := 16 / 9;
    ar4to3:
      aspect_ratio_value := 4 / 3;
    ar2_35to1:
      aspect_ratio_value := 2.35 / 1;
  end;
  DoChangeAscpectRatio;
  change_video_pos;
end;

procedure TFrameManager.set_center_point(const Value: TCenterPoint);
begin
  if not is_hold_coords then
  begin
    center_point := Value;
    change_video_pos;
  end;
end;

procedure TFrameManager.set_display_size(const value: TCPDisplaySize);
begin
  display_size := value;
end;

procedure TFrameManager.set_hold_coords(const value: boolean);
begin
  is_hold_coords := value;
end;

procedure TFrameManager.set_size(w, h: integer);
begin

end;

procedure TFrameManager.set_video_rect(const value: TRect);
begin
  if cp.IsVideo then
    change_video_pos(@value);
end;

procedure TFrameManager.set_zoom(const value: double);
begin
  if not is_hold_coords then
    zoom := value;
end;

end.
