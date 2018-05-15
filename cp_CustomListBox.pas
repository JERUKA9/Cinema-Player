unit cp_CustomListBox;

interface

uses
  Windows, Messages, Forms, SysUtils, Classes, Graphics, Controls;

type
//  TListBoxStyle = (lbStandard, lbOwnerDrawFixed, lbOwnerDrawVariable,
//    lbVirtual, lbVirtualOwnerDraw);
  TListBoxStyle = (lbVirtual, lbVirtualOwnerDraw);

  TOwnerDrawState = set of (odSelected, odGrayed, odDisabled, odChecked,
    odFocused, odDefault, odHotLight, odInactive, odNoAccel, odNoFocusRect,
    odReserved1, odReserved2, odComboBoxEdit);

  TDrawItemEvent = procedure(Control: TWinControl; Index: Integer;
    Rect: TRect; State: TOwnerDrawState) of object;

  TMeasureItemEvent = procedure(Control: TWinControl; Index: Integer;
    var Height: Integer) of object;

  TVirtualListBox = class(TWinControl)
  private
    FAutoComplete: Boolean;
    FItems: TStringList;
    FFilter: String;
    FLastTime: Cardinal;
    FMultiSelect: Boolean;
    FBorderStyle: TBorderStyle;
    FCanvas: TCanvas;
    FColumns: Integer;
    FItemHeight: Integer;
//    FOldCount: Integer;
    FStyle: TListBoxStyle;
    FIntegralHeight: Boolean;
    FSorted: Boolean;
    FExtendedSelect: Boolean;
    FTabWidth: Integer;
//    FSaveItems: TStringList;
    FSaveTopIndex: Integer;
    FSaveItemIndex: Integer;
    FOnDrawItem: TDrawItemEvent;
    FOnMeasureItem: TMeasureItemEvent;
    function GetItemHeight: Integer;
    function GetTopIndex: Integer;
    procedure LBGetText(var Message: TMessage); message LB_GETTEXT;
    procedure LBGetTextLen(var Message: TMessage); message LB_GETTEXTLEN;
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetColumnWidth;
    procedure SetColumns(Value: Integer);
    procedure SetExtendedSelect(Value: Boolean);
    procedure SetIntegralHeight(Value: Boolean);
    procedure SetItemHeight(Value: Integer);
    procedure SetItems(Value: TStringList);
    procedure SetSelected(Index: Integer; Value: Boolean);
    procedure SetSorted(Value: Boolean);
    procedure SetStyle(Value: TListBoxStyle);
    procedure SetTabWidth(Value: Integer);
    procedure SetTopIndex(Value: Integer);
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure CNMeasureItem(var Message: TWMMeasureItem); message CN_MEASUREITEM;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    function GetScrollWidth: Integer;
    procedure SetScrollWidth(const Value: Integer);
  protected
    FMoving: Boolean;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure WndProc(var Message: TMessage); override;
    procedure DragCanceled; override;
    procedure DrawItem(Index: Integer; Rect: TRect;
      State: TOwnerDrawState); virtual;
    function GetCount: Integer;
    function GetSelCount: Integer;
    procedure MeasureItem(Index: Integer; var Height: Integer); virtual;
    function GetItemIndex: Integer;
    function GetSelected(Index: Integer): Boolean;
    procedure KeyPress(var Key: Char); override;
    procedure SetMultiSelect(Value: Boolean);
    procedure SetItemIndex(const Value: Integer);
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property Columns: Integer read FColumns write SetColumns default 0;
    property ExtendedSelect: Boolean read FExtendedSelect write SetExtendedSelect default True;
    property IntegralHeight: Boolean read FIntegralHeight write SetIntegralHeight default False;
    property ItemHeight: Integer read GetItemHeight write SetItemHeight;
    property ParentColor default False;
    property Sorted: Boolean read FSorted write SetSorted default False;
    property Style: TListBoxStyle read FStyle write SetStyle default lbVirtual;
    property TabWidth: Integer read FTabWidth write SetTabWidth default 0;
    property OnDrawItem: TDrawItemEvent read FOnDrawItem write FOnDrawItem;
    property OnMeasureItem: TMeasureItemEvent read FOnMeasureItem write FOnMeasureItem;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddItem(Item: String; AObject: TObject);
    procedure Clear;
    procedure ClearSelection;
//    procedure CopySelection(Destination: TCustomListControl); override;
    procedure DeleteSelected;
    function ItemAtPos(Pos: TPoint; Existing: Boolean): Integer;
    function ItemRect(Index: Integer): TRect;
    procedure SelectAll;
    property AutoComplete: Boolean read FAutoComplete write FAutoComplete default True;
    property Canvas: TCanvas read FCanvas;
    property Count: Integer read GetCount;// write SetCount;
    property Items: TStringList read FItems write SetItems;
    property Selected[Index: Integer]: Boolean read GetSelected write SetSelected;
    property ScrollWidth: Integer read GetScrollWidth write SetScrollWidth default 0;
    property TopIndex: Integer read GetTopIndex write SetTopIndex;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property MultiSelect: Boolean read FMultiSelect write SetMultiSelect default False;
    property SelCount: Integer read GetSelCount;
  published
    property TabStop default True;
  end;


implementation

const
  SListIndexError = 'List index out of bounds (%d)';
  SInsertLineError = 'Unable to insert a line';
  SErrorSettingCount = 'Error setting %s.Count';

var
  CanUpdate: boolean = true;

procedure UpdateCount(ListBox: TVirtualListBox);
var
  Error: Integer;
begin
  if not CanUpdate then
    exit;
  // Limited to 32767 on Win95/98 as per Win32 SDK
  Error := SendMessage(ListBox.Handle, LB_SETCOUNT, ListBox.Items.Count, 0);
  if (Error = LB_ERR) or (Error = LB_ERRSPACE) then
    raise Exception.CreateFmt(SErrorSettingCount, [ListBox.Name]);
end;


type
  TListBoxStrings = class(TStringList)
  private
    ListBox: TVirtualListBox;
  protected
    procedure Put(Index: Integer; const S: string); override;
    procedure SetUpdateState(Updating: Boolean); override;
  public
    function Add(const S: string): Integer; override;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: string); override;
    procedure Move(CurIndex, NewIndex: Integer); override;
  end;

{ TListBoxStrings }

function TListBoxStrings.Add(const S: string): Integer;
begin
  Result := inherited Add(S);
  UpdateCount(ListBox);
end;

procedure TListBoxStrings.Insert(Index: Integer; const S: string);
begin
  inherited Insert(Index, S);
  UpdateCount(ListBox);
end;

procedure TListBoxStrings.Delete(Index: Integer);
begin
  inherited Delete(Index);
  UpdateCount(ListBox);
end;

procedure TListBoxStrings.Clear;
begin
  inherited Clear;
  UpdateCount(ListBox);
end;

procedure TListBoxStrings.SetUpdateState(Updating: Boolean);
begin
  inherited SetUpdateState(Updating);
//  if not Updating then ListBox.Refresh;
  if Updating then
  begin
    CanUpdate := false;
    SendMessage(ListBox.Handle, WM_SETREDRAW, Ord(not Updating), 0);
    UpdateCount(ListBox);
  end
  else
  begin
    CanUpdate := true;
    UpdateCount(ListBox);
    SendMessage(ListBox.Handle, WM_SETREDRAW, Ord(not Updating), 0);
  end;
end;

procedure TListBoxStrings.Move(CurIndex, NewIndex: Integer);
begin
  inherited Move(CurIndex, NewIndex);
  ListBox.Refresh;
end;

procedure TListBoxStrings.Put(Index: Integer; const S: string);
begin
  inherited Put(Index, S);
  ListBox.Refresh;
end;

{ TVirtualListBox }

const
  BorderStyles: array[TBorderStyle] of DWORD = (0, WS_BORDER);

constructor TVirtualListBox.Create(AOwner: TComponent);
const
  ListBoxStyle = [csSetCaption, csDoubleClicks];
begin
  inherited Create(AOwner);
  if NewStyleControls then
    ControlStyle := ListBoxStyle else
    ControlStyle := ListBoxStyle + [csFramed];
  Width := 121;
  Height := 97;
  TabStop := True;
  ParentColor := False;
  FAutoComplete := True;
  FItems := TListBoxStrings.Create;
  TListBoxStrings(FItems).ListBox := Self;
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;
  FItemHeight := 16;
  FBorderStyle := bsSingle;
  FExtendedSelect := True;
//  FOldCount := -1;
end;

destructor TVirtualListBox.Destroy;
begin
  inherited Destroy;
  FCanvas.Free;
  FItems.Free;
//  FSaveItems.Free;
end;

procedure TVirtualListBox.AddItem(Item: String; AObject: TObject);
begin
// TODO: byæ mo¿e potrzeba odœwierzyæ COUNT
//  SetString(S, PChar(Item), StrLen(PChar(Item)));
  Items.BeginUpdate;
  Items.AddObject(Item, AObject);
  Items.EndUpdate;
end;

procedure TVirtualListBox.Clear;
begin
// TODO: to by³o
  FItems.Clear;
end;

procedure TVirtualListBox.ClearSelection;
var
  I: Integer;
begin
  if MultiSelect then
    for I := 0 to Items.Count - 1 do
      Selected[I] := False
  else
    ItemIndex := -1;
end;

{procedure TVirtualListBox.CopySelection(Destination: TCustomListControl);
var
  I: Integer;
begin
  if MultiSelect then
  begin
    for I := 0 to Items.Count - 1 do
      if Selected[I] then
        Destination.AddItem(PChar(Items[I]), Items.Objects[I]);
  end
  else
    if ItemIndex <> -1 then
      Destination.AddItem(PChar(Items[ItemIndex]), Items.Objects[ItemIndex]);
end;
}
procedure TVirtualListBox.DeleteSelected;
var
  I: Integer;
begin
  if MultiSelect then
  begin
    for I := Items.Count - 1 downto 0 do
      if Selected[I] then
        Items.Delete(I);
  end
  else
    if ItemIndex <> -1 then
      Items.Delete(ItemIndex);
end;

procedure TVirtualListBox.SetColumnWidth;
var
  ColWidth: Integer;
begin
  if (FColumns > 0) and (Width > 0) then
  begin
    ColWidth := Trunc(ClientWidth / FColumns);
    if ColWidth < 1 then ColWidth := 1;
    SendMessage(Handle, LB_SETCOLUMNWIDTH, ColWidth, 0);
  end;
end;

procedure TVirtualListBox.SetColumns(Value: Integer);
begin
  if FColumns <> Value then
    if (FColumns = 0) or (Value = 0) then
    begin
      FColumns := Value;
      RecreateWnd;
    end else
    begin
      FColumns := Value;
      if HandleAllocated then SetColumnWidth;
    end;
end;

function TVirtualListBox.GetItemIndex: Integer;
begin
  if MultiSelect then
    Result := SendMessage(Handle, LB_GETCARETINDEX, 0, 0)
  else
    Result := SendMessage(Handle, LB_GETCURSEL, 0, 0);
end;

function TVirtualListBox.GetCount: Integer;
begin
  Result := Items.Count;
end;

function TVirtualListBox.GetSelCount: Integer;
begin
  Result := SendMessage(Handle, LB_GETSELCOUNT, 0, 0);
end;

procedure TVirtualListBox.SetItemIndex(const Value: Integer);
begin
  if GetItemIndex <> Value then
    if MultiSelect then SendMessage(Handle, LB_SETCARETINDEX, Value, 0)
    else SendMessage(Handle, LB_SETCURSEL, Value, 0);
end;

procedure TVirtualListBox.SetExtendedSelect(Value: Boolean);
begin
  if Value <> FExtendedSelect then
  begin
    FExtendedSelect := Value;
    RecreateWnd;
  end;
end;

procedure TVirtualListBox.SetIntegralHeight(Value: Boolean);
begin
  if Value <> FIntegralHeight then
  begin
    FIntegralHeight := Value;
    RecreateWnd;
    RequestAlign;
  end;
end;

function TVirtualListBox.GetItemHeight: Integer;
begin
  Result := FItemHeight;
end;

procedure TVirtualListBox.SetItemHeight(Value: Integer);
begin
  if (FItemHeight <> Value) and (Value > 0) then
  begin
    FItemHeight := Value;
    RecreateWnd;
  end;
end;

procedure TVirtualListBox.SetTabWidth(Value: Integer);
begin
  if Value < 0 then Value := 0;
  if FTabWidth <> Value then
  begin
    FTabWidth := Value;
    RecreateWnd;
  end;
end;

procedure TVirtualListBox.SetMultiSelect(Value: Boolean);
begin
  if FMultiSelect <> Value then
  begin
    FMultiSelect := Value;
    RecreateWnd;
  end;
end;

function TVirtualListBox.GetSelected(Index: Integer): Boolean;
var
  R: Longint;
begin
  R := SendMessage(Handle, LB_GETSEL, Index, 0);
  if R = LB_ERR then
    raise EListError.CreateFmt(SListIndexError, [Index]);
  Result := LongBool(R);
end;

procedure TVirtualListBox.SetSelected(Index: Integer; Value: Boolean);
begin
  if FMultiSelect then
  begin
    if SendMessage(Handle, LB_SETSEL, Longint(Value), Index) = LB_ERR then
      raise EListError.CreateFmt(SListIndexError, [Index]);
  end
  else
    if Value then
    begin
      if SendMessage(Handle, LB_SETCURSEL, Index, 0) = LB_ERR then
        raise EListError.CreateFmt(SListIndexError, [Index])
    end
    else
      SendMessage(Handle, LB_SETCURSEL, -1, 0);
end;

procedure TVirtualListBox.SetSorted(Value: Boolean);
begin
//  if FSorted <> Value then
  begin
    FSorted := Value;
    if Value then
      FItems.Sort;
  end;
end;

procedure TVirtualListBox.SetStyle(Value: TListBoxStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    RecreateWnd;
  end;
end;

function TVirtualListBox.GetTopIndex: Integer;
begin
  Result := SendMessage(Handle, LB_GETTOPINDEX, 0, 0);
end;

procedure TVirtualListBox.LBGetText(var Message: TMessage);
begin
  if (Message.WParam > -1) and (Message.WParam < Count) then
  begin
    StrCopy(PChar(Message.lParam), PChar(FItems[Message.wParam]));
    Message.Result := Length(FItems[Message.wParam]);
  end
  else
    Message.Result := LB_ERR;
end;

procedure TVirtualListBox.LBGetTextLen(var Message: TMessage);
begin
  if (Message.WParam > -1) and (Message.WParam < Count) then
    Message.Result := Length(FItems[Message.wParam])
  else
    Message.Result := LB_ERR;
end;

procedure TVirtualListBox.SetBorderStyle(Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TVirtualListBox.SetTopIndex(Value: Integer);
begin
  if GetTopIndex <> Value then
    SendMessage(Handle, LB_SETTOPINDEX, Value, 0);
end;

procedure TVirtualListBox.SetItems(Value: TStringList);
begin
  Items.Assign(Value);
// wys³anie komunikatu do kontrolki
//  Count := Count;
end;

function TVirtualListBox.ItemAtPos(Pos: TPoint; Existing: Boolean): Integer;
var
  Count: Integer;
  ItemRect: TRect;
begin
  if PtInRect(ClientRect, Pos) then
  begin
    Result := TopIndex;
    Count := Items.Count;
    while Result < Count do
    begin
      Perform(LB_GETITEMRECT, Result, Longint(@ItemRect));
      if PtInRect(ItemRect, Pos) then Exit;
      Inc(Result);
    end;
    if not Existing then Exit;
  end;
  Result := -1;
end;

function TVirtualListBox.ItemRect(Index: Integer): TRect;
var
  Count: Integer;
begin
  Count := Items.Count;
  if (Index = 0) or (Index < Count) then
    Perform(LB_GETITEMRECT, Index, Longint(@Result))
  else if Index = Count then
  begin
    Perform(LB_GETITEMRECT, Index - 1, Longint(@Result));
    OffsetRect(Result, 0, Result.Bottom - Result.Top);
  end else FillChar(Result, SizeOf(Result), 0);
end;

procedure TVirtualListBox.CreateParams(var Params: TCreateParams);
type
  PSelects = ^TSelects;
  TSelects = array[Boolean] of DWORD;
const
  Styles: array[TListBoxStyle] of DWORD = (LBS_OWNERDRAWFIXED, LBS_OWNERDRAWFIXED);
  Sorteds: array[Boolean] of DWORD = (0, LBS_SORT);
  MultiSelects: array[Boolean] of DWORD = (0, LBS_MULTIPLESEL);
  ExtendSelects: array[Boolean] of DWORD = (0, LBS_EXTENDEDSEL);
  IntegralHeights: array[Boolean] of DWORD = (LBS_NOINTEGRALHEIGHT, 0);
  MultiColumns: array[Boolean] of DWORD = (0, LBS_MULTICOLUMN);
  TabStops: array[Boolean] of DWORD = (0, LBS_USETABSTOPS);
  CSHREDRAW: array[Boolean] of DWORD = (CS_HREDRAW, 0);
  Data: array[Boolean] of DWORD = (LBS_HASSTRINGS, LBS_NODATA);
var
  Selects: PSelects;
begin
  inherited CreateParams(Params);
  CreateSubClass(Params, 'LISTBOX');
  with Params do
  begin
    Selects := @MultiSelects;
    if FExtendedSelect then Selects := @ExtendSelects;
    Style := Style or (WS_HSCROLL or WS_VSCROLL or
      Data[Self.Style in [lbVirtual, lbVirtualOwnerDraw]] or
      LBS_NOTIFY) or Styles[FStyle] or Sorteds[FSorted] or
      Selects^[FMultiSelect] or IntegralHeights[FIntegralHeight] or
      MultiColumns[FColumns <> 0] or BorderStyles[FBorderStyle] or
      TabStops[FTabWidth <> 0];
    if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then
    begin
      Style := Style and not WS_BORDER;
      ExStyle := ExStyle or WS_EX_CLIENTEDGE;
    end;
    WindowClass.style := WindowClass.style and not (CSHREDRAW[UseRightToLeftAlignment] or CS_VREDRAW);
  end;
end;

procedure TVirtualListBox.CreateWnd;
var
  W, H: Integer;
begin
  W := Width;
  H := Height;
  inherited CreateWnd;
  SetWindowPos(Handle, 0, Left, Top, W, H, SWP_NOZORDER or SWP_NOACTIVATE);
  if FTabWidth <> 0 then
    SendMessage(Handle, LB_SETTABSTOPS, 1, Longint(@FTabWidth));
  SetColumnWidth;
  if (Count <> -1) then
  begin
    SendMessage(Handle, LB_SETCOUNT, Count, 0);
//    UpdateCount(Self);// FCount := FOldCount;
    SetTopIndex(FSaveTopIndex);
    SetItemIndex(FSaveItemIndex);
//    FOldCount := -1;
  end;
end;

procedure TVirtualListBox.DestroyWnd;
begin
  if (Count > 0) then
  begin
//    FOldCount := FItems.Count;
    FSaveTopIndex := GetTopIndex;
    FSaveItemIndex := GetItemIndex;
  end;
  inherited DestroyWnd;
end;

procedure TVirtualListBox.WndProc(var Message: TMessage);
begin
  {for auto drag mode, let listbox handle itself, instead of TControl}
  if not (csDesigning in ComponentState) and ((Message.Msg = WM_LBUTTONDOWN) or
    (Message.Msg = WM_LBUTTONDBLCLK)) and not Dragging then
  begin
    if DragMode = dmAutomatic then
    begin
      if IsControlMouseMsg(TWMMouse(Message)) then
        Exit;
      ControlState := ControlState + [csLButtonDown];
      Dispatch(Message);  {overrides TControl's BeginDrag}
      Exit;
    end;
  end;
  inherited WndProc(Message);
end;

procedure TVirtualListBox.WMLButtonDown(var Message: TWMLButtonDown);
var
  ItemNo : Integer;
  ShiftState: TShiftState;
begin
  ShiftState := KeysToShiftState(Message.Keys);
  if (DragMode = dmAutomatic) and FMultiSelect then
  begin
    if not (ssShift in ShiftState) or (ssCtrl in ShiftState) then
    begin
      ItemNo := ItemAtPos(SmallPointToPoint(Message.Pos), True);
      if (ItemNo >= 0) and (Selected[ItemNo]) then
      begin
        BeginDrag (False);
        Exit;
      end;
    end;
  end;
  inherited;
  if (DragMode = dmAutomatic) and not (FMultiSelect and
    ((ssCtrl in ShiftState) or (ssShift in ShiftState))) then
    BeginDrag(False);
end;

procedure TVirtualListBox.CNCommand(var Message: TWMCommand);
begin
  case Message.NotifyCode of
    LBN_SELCHANGE:
      begin
        inherited Changed;
        Click;
      end;
    LBN_DBLCLK: DblClick;
  end;
end;

procedure TVirtualListBox.WMPaint(var Message: TWMPaint);

  procedure PaintListBox;
  var
    DrawItemMsg: TWMDrawItem;
    MeasureItemMsg: TWMMeasureItem;
    DrawItemStruct: TDrawItemStruct;
    MeasureItemStruct: TMeasureItemStruct;
    R: TRect;
    Y, I, H, W: Integer;
  begin
    { Initialize drawing records }
    DrawItemMsg.Msg := CN_DRAWITEM;
    DrawItemMsg.DrawItemStruct := @DrawItemStruct;
    DrawItemMsg.Ctl := Handle;
    DrawItemStruct.CtlType := ODT_LISTBOX;
    DrawItemStruct.itemAction := ODA_DRAWENTIRE;
    DrawItemStruct.itemState := 0;
    DrawItemStruct.hDC := Message.DC;
    DrawItemStruct.CtlID := Handle;
    DrawItemStruct.hwndItem := Handle;

    { Intialize measure records }
    MeasureItemMsg.Msg := CN_MEASUREITEM;
    MeasureItemMsg.IDCtl := Handle;
    MeasureItemMsg.MeasureItemStruct := @MeasureItemStruct;
    MeasureItemStruct.CtlType := ODT_LISTBOX;
    MeasureItemStruct.CtlID := Handle;

    { Draw the listbox }
    Y := 0;
    I := TopIndex;
    GetClipBox(Message.DC, R);
    H := Height;
    W := Width;
    while Y < H do
    begin
      MeasureItemStruct.itemID := I;
      if I < Items.Count then
        MeasureItemStruct.itemData := Longint(Pointer(Items.Objects[I]));
      MeasureItemStruct.itemWidth := W;
      MeasureItemStruct.itemHeight := FItemHeight;
      DrawItemStruct.itemData := MeasureItemStruct.itemData;
      DrawItemStruct.itemID := I;
      Dispatch(MeasureItemMsg);
      DrawItemStruct.rcItem := Rect(0, Y, MeasureItemStruct.itemWidth,
        Y + Integer(MeasureItemStruct.itemHeight));
      Dispatch(DrawItemMsg);
      Inc(Y, MeasureItemStruct.itemHeight);
      Inc(I);
      if I >= Items.Count then break;
    end;
  end;

begin
  if Message.DC <> 0 then
    { Listboxes don't allow paint "sub-classing" like the other windows controls
      so we have to do it ourselves. }
    PaintListBox
  else inherited;
end;

procedure TVirtualListBox.WMSize(var Message: TWMSize);
begin
  inherited;
  SetColumnWidth;
end;

procedure TVirtualListBox.DragCanceled;
var
  M: TWMMouse;
  MousePos: TPoint;
begin
  with M do
  begin
    Msg := WM_LBUTTONDOWN;
    GetCursorPos(MousePos);
    Pos := PointToSmallPoint(ScreenToClient(MousePos));
    Keys := 0;
    Result := 0;
  end;
  DefaultHandler(M);
  M.Msg := WM_LBUTTONUP;
  DefaultHandler(M);
end;

procedure TVirtualListBox.DrawItem(Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
var
  Flags: Longint;
  Data: String;
begin
  if Assigned(FOnDrawItem) then FOnDrawItem(Self, Index, Rect, State) else
  begin
    FCanvas.FillRect(Rect);
    if Index < Count then
    begin
      Flags := DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
      if not UseRightToLeftAlignment then
        Inc(Rect.Left, 2)
      else
        Dec(Rect.Right, 2);
      Data := Items[Index];
      DrawText(FCanvas.Handle, PChar(Data), Length(Data), Rect, Flags);
    end;
  end;
end;

procedure TVirtualListBox.MeasureItem(Index: Integer; var Height: Integer);
begin
  if Assigned(FOnMeasureItem) then FOnMeasureItem(Self, Index, Height)
end;

procedure TVirtualListBox.CNDrawItem(var Message: TWMDrawItem);
var
  State: TOwnerDrawState;
begin
  with Message.DrawItemStruct^ do
  begin
    State := TOwnerDrawState(LongRec(itemState).Lo);
    FCanvas.Handle := hDC;
    FCanvas.Font := Font;
    FCanvas.Brush := Brush;
    if (Integer(itemID) >= 0) and (odSelected in State) then
    begin
      FCanvas.Brush.Color := clHighlight;
      FCanvas.Font.Color := clHighlightText
    end;
    if Integer(itemID) >= 0 then
      DrawItem(itemID, rcItem, State) else
      FCanvas.FillRect(rcItem);
    if odFocused in State then DrawFocusRect(hDC, rcItem);
    FCanvas.Handle := 0;
  end;
end;

procedure TVirtualListBox.CNMeasureItem(var Message: TWMMeasureItem);
begin
  with Message.MeasureItemStruct^ do
  begin
    itemHeight := FItemHeight;
// TODO: mo¿e byc potrzebne wywo³anie procedury
//    if FStyle = lbOwnerDrawVariable then
//    if FStyle = lbVirtualOwnerDraw then
//      MeasureItem(itemID, Integer(itemHeight));
  end;
end;

procedure TVirtualListBox.CMCtl3DChanged(var Message: TMessage);
begin
  if NewStyleControls and (FBorderStyle = bsSingle) then RecreateWnd;
  inherited;
end;

procedure TVirtualListBox.SelectAll;
var
  I: Integer;
begin
  if FMultiSelect then
    for I := 0 to Items.Count - 1 do
      Selected[I] := True;
end;

procedure TVirtualListBox.KeyPress(var Key: Char);

  procedure FindString;
  var
    Idx, i: Integer;
  begin
    Sorted := true;
    Idx := LB_ERR;
    for i := Count - 1 downto 0 do
    begin
      if (AnsiCompareText(FFilter, FItems[i]) <= 0) then
      begin
        Idx := i;
        break;
      end;
    end;

    if Idx <> LB_ERR then
    begin
      if MultiSelect then
      begin
        ClearSelection;
        SendMessage(Handle, LB_SELITEMRANGE, 1, MakeLParam(Idx, Idx))
      end;
      ItemIndex := Idx;
      Click;
    end;
    if not Ord(Key) in [VK_RETURN, VK_BACK, VK_ESCAPE] then
      Key := #0;  // Clear so that the listbox's default search mechanism is disabled
  end;

begin
  inherited KeyPress(Key);
  if not FAutoComplete then exit;
  if GetTickCount - FLastTime >= 500 then
    FFilter := '';
  FLastTime := GetTickCount;
  if Ord(Key) <> VK_BACK then
    FFilter := FFilter + Key
  else
    Delete(FFilter, Length(FFilter), 1);
  if Length(FFilter) > 0 then
    FindString
  else
  begin
    ItemIndex := 0;
    Click;
  end;
end;

function TVirtualListBox.GetScrollWidth: Integer;
begin
  Result := SendMessage(Handle, LB_GETHORIZONTALEXTENT, 0, 0);
end;

procedure TVirtualListBox.SetScrollWidth(const Value: Integer);
begin
  if Value <> ScrollWidth then
    SendMessage(Handle, LB_SETHORIZONTALEXTENT, Value, 0);
end;

end.
