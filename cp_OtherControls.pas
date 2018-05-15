unit cp_OtherControls;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  ExtCtrls, StdCtrls;

type
  TBasePanel = class(TWinControl)
  public
    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }
    property Align;
    property Caption;
    property Color;
    property Enabled;
    property Font;
    property ParentColor;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnClick;
    property OnDblClick;
    property PopupMenu;
    property TabStop;
    property Visible;
    property OnResize;
  end;

  TOSDPanel = class(TCustomControl)
  private
    FDisplayTime: integer;
    property Caption;
    procedure WMTimer(var Msg: TWMTimer); message WM_TIMER;
    procedure SetDisplayTime(const Value: integer);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DisplayOSD(info: string = '');
    procedure Test;
    procedure Close;
    property Canvas;
  published
    { Published declarations }
    property Color;
    property DisplayTime: integer read FDisplayTime write SetDisplayTime;
    property Enabled;
    property Font;
    property ParentColor;
    property Visible;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseMove;
  end;

  TNewCheckBox = class(TCheckBox)
  private
    FWordWrap: boolean;
    procedure SetWordWrap(Value: boolean);
  protected
    procedure CreateParams(var Params: TCreateParams);override;
  public
    constructor Create(AOwner: TComponent);override;
  published
    property WordWrap: boolean read FWordWrap write SetWordWrap default true;
  end;

implementation

const
  timerOSD                    = 700;

{ TBasePanel }

constructor TBasePanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csReplicatable, csAcceptsControls, csClickEvents, csDoubleClicks];
  Width := 100;
  Height := 100;
end;

{procedure TBasePanel.WMPaint(var Msg: TWMPaint);
var
  MyHDC: HDC;
  MyHWND: HWND;
  MyRect: TRect;
begin
  inherited;
  MyRect := ClientRect;
  MyHDC := GetDeviceContext(MyHWND);
  if Name = 'bpVolume' then
  begin
    DrawEdge(MyHDC, MyRect, BDR_SUNKENOUTER, BF_TOP or BF_FLAT);
    OffsetRect(MyRect, 0, 1);
    DrawEdge(MyHDC, MyRect, BDR_RAISEDINNER, BF_TOP);
  end;
end;}

{ TNewCheckBox }

constructor TNewCheckBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWordWrap:=true;
end;

procedure TNewCheckBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
    if WordWrap then
      Style:=Style or BS_MULTILINE
    else
      Style:=Style and not BS_MULTILINE;
end;

procedure TNewCheckBox.SetWordWrap(Value: boolean);
begin
  if FWordWrap<>Value then
  begin
    FWordWrap:=Value;
    RecreateWnd;
  end;
end;

{ TOSDPanel }

procedure TOSDPanel.Close;
begin
  Hide;
  Caption := '';
end;

constructor TOSDPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 100;
  Height := 100;
  Caption := Name;
  FDisplayTime := 2000;
end;

procedure TOSDPanel.DisplayOSD(info: string);
var
  rc: TRect;
begin
  rc := GetClientRect;
  Canvas.Font := Font;
  if info = '' then
    info := Caption;
  Delete(info, Pos('&', info), 1);
  rc.Right := Canvas.TextWidth(info) + 4;
  rc.Bottom := Canvas.TextHeight(info) + 4;
  OffsetRect(rc, Left, Top);
  BoundsRect := rc;
  Caption := info;
  if Enabled then
  begin
    if Visible then
      Repaint
    else
      Show;
    SetTimer(Handle, timerOSD, FDisplayTime, nil);
  end;
end;

procedure TOSDPanel.Paint;
var
  Rect: TRect;
begin
  Rect := GetClientRect;
  with Canvas do
  begin
    Font := Self.Font;
    Brush.Color := Color;
    FillRect(Rect);
    Brush.Style := bsClear;
    DrawText(Handle, PChar(Caption), -1, Rect, DT_EXPANDTABS or DT_VCENTER or DT_CENTER or DT_LEFT or DT_SINGLELINE);
  end;
end;

procedure TOSDPanel.SetDisplayTime(const Value: integer);
begin
  FDisplayTime := Value;
end;

procedure TOSDPanel.Test;
begin
  DisplayOSD('OSD');
end;

procedure TOSDPanel.WMTimer(var Msg: TWMTimer);
begin
  if Msg.TimerID = timerOSD then
  begin
    KillTimer(Handle, timerOSD);
    Close;
  end;
end;

end.
