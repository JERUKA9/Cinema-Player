unit crazyhint;

interface

uses
  Windows,Classes, Controls, Forms, Messages, Graphics, main, SysUtils;

type
/// Klasa CrazyHint
  TCrazyHint=class(THintWindow)
  private
    TextRect: TRect;
    MyCaption: TCaption;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  public
    function CalcHintRect(MaxWidth: Integer; const AHint: string;
      AData: Pointer): TRect; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ActivateHint(Rect: TRect; const AHint: string); override;
    procedure Paint; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure SilentSetPosition(const Left, Top: integer; AHint: string;
      Bold: boolean);
  end;

var
  HintWindowRef: TCrazyHint;
  ActiveModification: boolean = false;

implementation

uses
  global_consts, cp_utils;

const
  DrawStyle: cardinal =
    DT_EXPANDTABS or DT_WORDBREAK or DT_LEFT or
    DT_NOPREFIX;// or DrawTextBiDiModeFlagsReadingOnly;
  AddBorder = 1;
//  FrameColor: TColor = $002CE2FC;
  FrameColor: TColor = clBlack;
//  PatternColor: TColor = clWhite;
//  PatternColor: TColor = $002CE2FC;

constructor TCrazyHint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Canvas.Brush.Color := PatternColor;
  Color := PatternColor;
  Canvas.Font.Color := FrameColor;
  HintWindowRef := Self;
  DoubleBuffered := true;
end;

destructor TCrazyHint.Destroy;
begin
  HintWindowRef := nil;
  inherited Destroy;
end;

procedure TCrazyHint.ActivateHint(Rect: TRect; const AHint: string);
begin
//  DrawText(Canvas.Handle, PChar(AHint), -1, Rect, DrawStyle or DT_CALCRECT);
//  TextRect := Rect;
//  OffsetRect(TextRect, -TextRect.Left, -TextRect.Top);
//  inc(Rect.Right, 10 + 5 * AddBorder); inc(Rect.Bottom, 2 * AddBorder);
//  BoundsRect := Rect;
//  MyCaption := GetHint(Caption);
  MyCaption := GetHint(Caption);
  inherited ActivateHint(Rect, GetHint(AHint));
end;

procedure TCrazyHint.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style and not WS_BORDER;
end;

procedure TCrazyHint.Paint;
var
  R: TRect;
begin
  R := ClientRect;
  Canvas.FillRect(R);

  R := TextRect;
  OffsetRect(R, (ClientRect.Right - R.Right) div 2, (ClientRect.Bottom - R.Bottom) div 2);
  DrawText(Canvas.Handle, PChar(MyCaption), -1, R, DrawStyle);

  R := ClientRect;
  Canvas.Brush.Color := FrameColor;
  Canvas.FrameRect(R);
  Canvas.Brush.Color := PatternColor;
end;

procedure TCrazyHint.SilentSetPosition(const Left, Top: integer; AHint: string;
  Bold: boolean);
var
  tempRect: TRect;
begin
  if not ActiveModification then
  begin
    MyCaption := GetHint(Caption);
    exit;
  end;
  MyCaption := GetHint(AHint);
  if Bold then
    Canvas.Font.Style := Canvas.Font.Style + [fsBold]
  else
    Canvas.Font.Style := Canvas.Font.Style - [fsBold];
  tempRect := CalcHintRect(200, MyCaption, nil);
  OffsetRect(tempRect, BoundsRect.Left + Left, BoundsRect.Top + Top);
  BoundsRect := tempRect;

  Paint;
end;

function TCrazyHint.CalcHintRect(MaxWidth: Integer; const AHint: string;
  AData: Pointer): TRect;
begin
  Result := Rect(0, 0, MaxWidth, 0);

  if not ActiveModification then
    Canvas.Font.Style := Canvas.Font.Style - [fsBold];
  DrawText(Canvas.Handle, PChar(GetHint(AHint)), -1, Result, DrawStyle or DT_CALCRECT);
  TextRect := Result;
  inc(Result.Right, 10 + 5 * AddBorder); inc(Result.Bottom, 2 * AddBorder);
end;

procedure TCrazyHint.CMTextChanged(var Message: TMessage);
begin
  inherited;
  MyCaption := GetHint(Caption);
end;

initialization

  Application.ShowHint := false;
  HintWindowClass := TCrazyHint;
  Application.ShowHint := true;

end.
