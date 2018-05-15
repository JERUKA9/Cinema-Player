unit cp_TrackBars;

interface

uses
  Windows, Messages, Classes, Graphics, Controls, ExtCtrls;

type
  TEdgeBorder = (ebLeft, ebTop, ebRight, ebBottom);
  TEdgeBorders = set of TEdgeBorder;

  TCustomTrackBar = class(TCustomPanel)
  private
    { Private declarations }
    skala: double;
    FMax: integer;
    FMin: integer;
    FPosition: integer;
    FMargin: integer;
    FTumbsize: integer;
    MouseDown: boolean;
    FOnChange: TNotifyEvent;
    procedure SetMax(AMax: integer);
    procedure SetMin(AMin: integer);
    procedure SetPosition(APosition: integer);
    procedure SetMargin(AMargin: integer);
    procedure SetTumbSize(ATumbSize: integer);
  protected
    { Protected declarations }
    procedure skaluj;
    procedure WMLButtonDown(var Msg: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMMouseMove(var Msg: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMLButtonUp(var Msg: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure SetEnabled(Value: Boolean); override;
    function GetScale: double;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); Override;
  published
    { Published declarations }
    property Align;
    property Color;
    property Enabled: boolean read GetEnabled write SetEnabled;
    property ParentColor;
    property Max: integer read FMax write SetMax;
    property Min: integer read FMin write SetMin;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property Margin: integer read FMargin write SetMargin;
    property Position: integer read FPosition write SetPosition;
    property ShowHint;
    property TumbSize: integer read FTumbSize write SetTumbSize;
    property Visible;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TNeedHintEvent = procedure(Sender: TObject; ATime: integer) of object;

  TPositionTrackBar = class(TCustomTrackBar)
  private
    FEdgeBorders: TEdgeBorders;
    FMinimalView: boolean;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnNeedHint: TNeedHintEvent;
    function GetTumbPos: integer;
    procedure SetSilentPosition(APosition: integer);
    procedure SetEdgeBorders(Value: TEdgeBorders);
  protected
    { Protected declarations }
    procedure WMMouseMove(var Msg: TWMMouseMove); message WM_MOUSEMOVE;
    procedure CMMouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
  public
    procedure Paint; Override;
    property MinimalView: boolean read FMinimalView write FMinimalView;
    property SilentPosition: integer write SetSilentPosition;
    property TumbPos: integer read GetTumbPos;
  published
    property EdgeBorders: TEdgeBorders read FEdgeBorders write SetEdgeBorders default [ebLeft, ebTop, ebRight, ebBottom];
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnNeedHint: TNeedHintEvent read FOnNeedHint write FOnNeedHint;
  end;

  TVolumeTrackBar = class(TCustomTrackBar)
  private
    property TumbSize;
  public
    constructor Create(AOwner: TComponent); Override;
    procedure Paint; Override;
  end;

implementation

{ TCustomTrackBar }

constructor TCustomTrackBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csReplicatable];
  Margin := 10;
  TumbSize := 12;
  Width := 100;
  Height := 20;
  DoubleBuffered:=true;
  Max:=100;
  Min:=0;
  Position:=0;
  MouseDown := false;
  Caption := '';
  skaluj;
end;

procedure TCustomTrackBar.SetEnabled(Value: Boolean);
begin
  inherited SetEnabled(Value);
  invalidate;
end;

procedure TCustomTrackBar.skaluj;
begin
  if (FMax - FMin) <> 0 then
    skala := (Width - (2 * Margin) - TumbSize) / (FMax - FMin)
  else
    skala := 0;
end;

procedure TCustomTrackBar.SetMax(AMax: integer);
begin
  if (AMax >= FMin)and
     (AMax <> FMax) then
  begin
    FMax := AMax;
    skaluj;
    FPosition := FMin;
    Invalidate;
  end;
end;

procedure TCustomTrackBar.SetMin(AMin: integer);
begin
  if (AMin <= FMax)and
     (AMin <> FMin) then
  begin
    FMin := AMin;
    skaluj;
    FPosition := AMin;
    Invalidate;
  end;
end;

procedure TCustomTrackBar.SetPosition(APosition: integer);
begin
  if (APosition <> FPosition) then
  begin
    if (APosition < Min) then
      APosition := Min;
    if (APosition > Max) then
     APosition := Max;
    FPosition := APosition;
    invalidate;
    if Assigned(FOnChange) then
      FOnChange(Self);
  end;
end;

procedure TCustomTrackBar.WMLButtonDown(var Msg: TWMLButtonDown);
begin
  inherited;
  SetCapture(Handle);
  MouseDown := true;
  if Msg.XPos <= (Margin + (TumbSize div 2)) then
    Position := FMin
  else
    if Msg.XPos >= (Width - Margin - (TumbSize div 2)) then
      Position := FMax
    else
      Position := round((Msg.XPos - Margin - (TumbSize div 2)) / skala) + FMin;
end;

procedure TCustomTrackBar.WMMouseMove(var Msg: TWMMouseMove);
begin
  inherited;
  if MouseDown then
    WMLButtonDown(Msg);
end;

procedure TCustomTrackBar.WMLButtonUp(var Msg: TWMLButtonUp);
begin
  inherited;
  MouseDown := false;
  ReleaseCapture;
end;

procedure TCustomTrackBar.WMSize(var Msg: TWMSize);
begin
  skaluj;
  Invalidate;
end;

procedure TCustomTrackBar.SetMargin(AMargin: integer);
begin
  if AMargin <> FMargin then
  begin
    FMargin := AMargin;
    skaluj;
    Invalidate;
  end;
end;

procedure TCustomTrackBar.SetTumbSize(ATumbSize: integer);
begin
  if ATumbSize <> FTumbSize then
  begin
    FTumbSize := ATumbSize;
    skaluj;
    Invalidate;
  end;
end;

function TCustomTrackBar.GetScale: double;
begin
  Result := skala;
end;

{ TVolumeTrackBar }

constructor TVolumeTrackBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TumbSize := 0;
end;

procedure TVolumeTrackBar.Paint;
var
  foo: double;
  i: integer;
begin
  with Canvas do
  begin
    foo := (Width - 3 - 2 * Margin) * (Position / Max);
    for i := Margin to Width - Margin - 3 do
      if ((i - Margin) mod 3) = 0 then
      begin
        if (i - Margin) >= foo then
//          Brush.Color := clBtnFace
          Brush.Color := clBtnShadow
        else
          Brush.Color := clWindow;
        Pen.Color := clBtnShadow;
        Rectangle(
          i,
          round((Height / 2) + 5 - ((i * 14) / (Width - 6 - 2 * Margin))),
          i + 4,
//          (Height div 2) + 8);
          Height - 3);
      end;
  end;
end;

{ TPositionTrackBar }

procedure TPositionTrackBar.CMMouseEnter(var Msg: TMessage);
begin
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);
end;

procedure TPositionTrackBar.CMMouseLeave(var Msg: TMessage);
begin
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
end;

function TPositionTrackBar.GetTumbPos: integer;
begin
  Result := round((Position - Min) * skala) + Margin - ({2 * }TumbSize);
end;

procedure TPositionTrackBar.Paint;
var
  MyRect: TRect;
  foo: integer;
begin
  Canvas.Brush.Color := clBtnFace;
  Canvas.Pen.Color := clBtnShadow;
  Canvas.FillRect(ClientRect);
  MyRect := ClientRect;

  DrawEdge(Canvas.Handle, MyRect, EDGE_ETCHED, Byte(FEdgeBorders) or BF_ADJUST);
  if FMinimalView then
  begin
    MyRect := Rect(Margin + (TumbSize div 2), (Height div 2) - 2, Width - Margin - (TumbSize div 2), (Height div 2) + 3);
  end
  else
  begin
    MyRect := Rect(Margin + (TumbSize div 2), (Height div 2) - 4, Width - Margin - (TumbSize div 2), (Height div 2) + 3);
  end;

{  if FMinimalView then
  begin
    DrawEdge(Canvas.Handle, MyRect, EDGE_ETCHED, BF_RIGHT or BF_LEFT);
    MyRect := Rect(Margin + TumbSize, (Height div 2) - 2, Width - Margin - TumbSize, (Height div 2) + 3);
  end
  else
  begin
    DrawEdge(Canvas.Handle, MyRect, EDGE_ETCHED, BF_BOTTOM);
    MyRect := Rect(Margin + TumbSize, (Height div 2) - 4, Width - Margin - TumbSize, (Height div 2) + 3);
  end;
}
  DrawEdge(Canvas.Handle, MyRect, EDGE_ETCHED, BF_RECT or BF_SOFT or BF_MIDDLE);

  if Enabled then
  begin
    Canvas.Brush.Color := clWindow;
    InflateRect(MyRect, -1, -1);
    with MyRect do
      Rectangle(Canvas.Handle, Left, Top, Right, Bottom);
  end;
//  else
//    Canvas.Brush.Color := clBtnFace;
//  Canvas.Pen.Color := clWindow; //BtnShadow;

  if Enabled then
  begin
    Canvas.Brush.Color := clBtnShadow;
    Canvas.Pen.Color := clHighlight;

    foo := round((Position - Min) * skala) + Margin {+ (TumbSize div 2)};
    if FMinimalView then
      MyRect := Rect(foo {- TumbSize div 2}, (Height - TumbSize) div 2, foo + TumbSize {div 2}, (Height + TumbSize) div 2)
    else
      MyRect := Rect(foo {- TumbSize div 2}, (Height - TumbSize) div 2 - 1, foo + TumbSize {div 2}, (Height + TumbSize) div 2 - 1);

    DrawEdge(Canvas.Handle, MyRect, EDGE_BUMP, BF_RECT or BF_SOFT or BF_MIDDLE);

    Canvas.Brush.Color := clBtnShadow;
    Canvas.Pen.Color := clBtnHighlight;
  end;
end;

procedure TPositionTrackBar.SetEdgeBorders(Value: TEdgeBorders);
begin
  if FEdgeBorders <> Value then
  begin
    FEdgeBorders := Value;
    RecreateWnd;
  end;
end;

procedure TPositionTrackBar.SetSilentPosition(APosition: integer);
begin
  if (APosition >= Min)and
     (APosition <= Max)and
     (APosition <> FPosition) then
  begin
    FPosition := APosition;
    invalidate;
  end;
end;

procedure TPositionTrackBar.WMMouseMove(var Msg: TWMMouseMove);
var
  tempPos: integer;
begin
  inherited;
  if Assigned(OnNeedHint) then
  begin
    if Msg.XPos <= (Margin + (TumbSize div 2)) then
      tempPos := FMin
    else
      if Msg.XPos >= (Width - Margin - (TumbSize div 2)) then
        tempPos := FMax
      else
        tempPos := round((Msg.XPos - Margin - (TumbSize div 2)) / skala) + FMin;
    OnNeedHint(Self, tempPos);
  end;
end;

end.
