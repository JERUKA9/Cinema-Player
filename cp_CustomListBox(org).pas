unit cp_CustomListBox_;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, StdCtrls, ExtCtrls;

type
  TLBGetDataEvent = procedure(Control: TWinControl; Index: Integer;
    var Data: string) of object;
  TLBGetDataObjectEvent = procedure(Control: TWinControl; Index: Integer;
    var DataObject: TObject) of object;
  TLBFindDataEvent = function(Control: TWinControl;
    FindString: string): Integer of object;

  TVirtualListBox = class(TCustomListBox)
  private

{    FAutoComplete: Boolean;
    FFilter: String;
    FLastTime: Cardinal;}
    FCount: Integer;
    FOldCount: Integer;

    FOnData: TLBGetDataEvent;
    FOnDataFind: TLBFindDataEvent;
    FOnDataObject: TLBGetDataObjectEvent;
//    FSaveItems: TStringList;
    FVirtualItems: TStringList;
    FSorted: Boolean;

    procedure LBGetText(var Message: TMessage); message LB_GETTEXT;
    procedure LBGetTextLen(var Message: TMessage); message LB_GETTEXTLEN;
    function GetCount: Integer;
    procedure SetCount(const Value: Integer);
    procedure SetVirtualItems(const Value: TStringList);
    procedure SetSorted(const Value: Boolean);
  protected
    FMoving: Boolean;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure ResetContent; override;
    function DoGetData(const Index: Integer): String;
    function DoGetDataObject(const Index: Integer): TObject;
    function DoFindData(const Data: String): Integer;
    property OnData: TLBGetDataEvent read FOnData write FOnData;
    property OnDataObject: TLBGetDataObjectEvent read FOnDataObject write FOnDataObject;
    property OnDataFind: TLBFindDataEvent read FOnDataFind write FOnDataFind;
    procedure AddItem(Item: String; AObject: TObject);
    property Sorted: Boolean read FSorted write SetSorted default False;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RefreshCount;
    function ItemAtPos(Pos: TPoint; Existing: Boolean): Integer; reintroduce;
    function ItemRect(Index: Integer): TRect; reintroduce;
    property VirtualItems: TStringList read FVirtualItems write SetVirtualItems;
    property Count: Integer read GetCount write SetCount;
  end;


implementation

{ TVirtualListBox }

constructor TVirtualListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FVirtualItems := TStringList.Create;
  FOldCount := -1;
end;

procedure TVirtualListBox.ResetContent;
begin
  exit;
end;

function TVirtualListBox.ItemAtPos(Pos: TPoint; Existing: Boolean): Integer;
var
//  Count: Integer;
  ItemRect: TRect;
begin
  if PtInRect(ClientRect, Pos) then
  begin
    Result := TopIndex;
//    Count := Items.Count;
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
//var
//  Count: Integer;
begin
//  Count := Items.Count;
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
  Styles: array[TListBoxStyle] of DWORD =
    (0, LBS_OWNERDRAWFIXED, LBS_OWNERDRAWVARIABLE);
  Sorteds: array[Boolean] of DWORD = (0, LBS_SORT);
  MultiSelects: array[Boolean] of DWORD = (0, LBS_MULTIPLESEL);
  ExtendSelects: array[Boolean] of DWORD = (0, LBS_EXTENDEDSEL);
  IntegralHeights: array[Boolean] of DWORD = (LBS_NOINTEGRALHEIGHT, 0);
  MultiColumns: array[Boolean] of DWORD = (0, LBS_MULTICOLUMN);
  TabStops: array[Boolean] of DWORD = (0, LBS_USETABSTOPS);
var
  Selects: PSelects;
begin
  inherited CreateParams(Params);
  with Params do
    Style := (Style or LBS_NODATA) and (not LBS_HASSTRINGS);
end;

procedure TVirtualListBox.CreateWnd;
begin
  inherited CreateWnd;
  if (FOldCount <> -1) then
  begin
    Count := FOldCount;
    FOldCount := -1;
//    Items.Count :=
{  if FSaveItems <> nil then
  begin
    FItems.Assign(FSaveItems);
    SetTopIndex(FSaveTopIndex);
    SetItemIndex(FSaveItemIndex);
    FSaveItems.Free;
    FSaveItems := nil;
  end;}
  end;
end;

procedure TVirtualListBox.DestroyWnd;
begin
  if (FCount > 0) then
  begin
    FOldCount := FCount;
//    FSaveItems := TStringList.Create;
//    FSaveItems.Assign(FItems);
//    FSaveTopIndex := GetTopIndex;
//    FSaveItemIndex := GetItemIndex;
//    Items.Free;
//    Items.Clear;
  end;
  inherited DestroyWnd;
end;

function TVirtualListBox.GetCount: Integer;
begin
  Result := FCount;
end;

procedure TVirtualListBox.SetCount(const Value: Integer);
var
  Error: Integer;
begin
  // Limited to 32767 on Win95/98 as per Win32 SDK
  Error := SendMessage(Handle, LB_SETCOUNT, Value, 0);
  if (Error <> LB_ERR) and (Error <> LB_ERRSPACE) then
    FCount := Value
  else
    raise Exception.CreateFmt('Error setting %s.Count', [Name]);
end;

procedure TVirtualListBox.LBGetText(var Message: TMessage);
var
  S: string;
begin
  if Assigned(FOnData) and (Message.WParam > -1) and (Message.WParam < Count) then
  begin
    S := '';
    OnData(Self, Message.wParam, S);
    StrCopy(PChar(Message.lParam), PChar(S));
    Message.Result := Length(S);
  end
  else
    Message.Result := LB_ERR;
end;

procedure TVirtualListBox.LBGetTextLen(var Message: TMessage);
var
  S: string;
begin
  if Assigned(FOnData) and (Message.WParam > -1) and (Message.WParam < Count) then
  begin
    S := '';
    OnData(Self, Message.wParam, S);
    Message.Result := Length(S);
  end
  else
    Message.Result := LB_ERR;
end;

function TVirtualListBox.DoFindData(const Data: String): Integer;
begin
  if Assigned(FOnDataFind) then
    Result := VirtualItems.IndexOf(Data)
//    Result := FOnDataFind(Self, Data)
  else
    Result := -1;
end;

function TVirtualListBox.DoGetData(const Index: Integer): String;
begin
//  if Assigned(FOnData) then FOnData(Self, Index, Result);
  Result := VirtualItems[Index];
end;

function TVirtualListBox.DoGetDataObject(const Index: Integer): TObject;
begin
//  if Assigned(FOnDataObject) then FOnDataObject(Self, Index, Result);
  Result := VirtualItems.Objects[Index];
end;

procedure TVirtualListBox.SetVirtualItems(const Value: TStringList);
begin
  VirtualItems.Assign(Value);
end;

destructor TVirtualListBox.Destroy;
begin
  FVirtualItems.Free;
  inherited Destroy;
end;

procedure TVirtualListBox.AddItem(Item: String; AObject: TObject);
begin
  VirtualItems.AddObject(Item, AObject);
end;

procedure TVirtualListBox.SetSorted(const Value: Boolean);
begin
  if FSorted <> Value then
  begin
    FSorted := Value;
    if FSorted then
    begin
      VirtualItems.Sort;
      Refresh;
    end;
  end;
end;

procedure TVirtualListBox.RefreshCount;
begin
  SetCount(VirtualItems.Count);
end;

end.
