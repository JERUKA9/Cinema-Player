unit actions;

interface

uses
  Windows, Classes, SysUtils, commctrl;

type
  PACCEL = ^ACCEL;
  ACCEL = packed record
    fVirt: Byte;     { Also called the flags field }
    key: Word;
    cmd: Word;
  end;

  TzbAction = class;

  TzbActionHandler = procedure(a: TzbAction);

  TzbActionsManager = class(TObject)
  private
    _actions: TList;
    _haccel: HACCEL;
    _menus: TList;
    _toolbars: TList;
    _ascii_accels_disabled: boolean;

    procedure enable_invoked(cmd_id: WORD; state: WordBool);
    function getAction(cmd_id: WORD): TzbAction;

  public
    constructor create();
    destructor destroy(); override;

    procedure registerAccels();
    procedure unregisterAccels();
    procedure enableAsciiAccels();
    procedure disableAsciiAccels();
    procedure changeAccel(cmd_id: WORD; sc_virt: byte; sc_key: word);

    procedure addAction(action: TzbAction);
    procedure setEnabled(cmd_id: WORD; value: boolean);
    function getEnabled(cmd_id: WORD): boolean;
    function getCaptionId(cmd_id: WORD): WORD;

  end;

  TzbAction = class(TObject)
  private
    _enabled: boolean;
    _handler: TzbActionHandler;
    _image_index: integer;
    _accel: ACCEL;
    _parent: TzbActionsManager;
    _caption_id: WORD;
  protected

  public
    constructor create(handler: TzbActionHandler; image_index: integer;
      cmd_id: WORD; sc_virt: byte; sc_key: WORD; caption_id: WORD);

    procedure execute();
  end;

implementation

{ TzbAction }

constructor TzbAction.create(handler: TzbActionHandler; image_index: integer;
      cmd_id: WORD; sc_virt: byte; sc_key: WORD; caption_id: WORD);
begin
  _parent := nil;
  _enabled := true;
  _handler := handler;
  _image_index := image_index;
  _accel.fVirt := sc_virt;
  _accel.key := sc_key;
  _accel.cmd := cmd_id;
  _caption_id := caption_id;
end;

procedure TzbAction.execute;
begin
  if Assigned(_handler) and _enabled then
    _handler(Self);
end;

{ TzbActionsManager }

procedure TzbActionsManager.addAction(action: TzbAction);
var
  i: word;
begin
  i := action._accel.cmd;
  if (_actions.Count > i) then
  begin
    if (_actions[i] <> nil) then
      raise Exception.Create('[addAction] action exists');
  end
  else
    _actions.Count := i;
  _actions[i] := action;
end;

procedure TzbActionsManager.changeAccel(cmd_id: WORD; sc_virt: byte;
  sc_key: word);
var
  a: TzbAction;
begin
  a := getAction(cmd_id);
//todo sprawdzanie dubli
  a._accel.fVirt := sc_virt;
  a._accel.key := sc_key;
end;

constructor TzbActionsManager.create();
begin
  _actions := TList.Create;
  _menus := TList.Create;
  _toolbars := TList.Create;
  _haccel := 0;
  _ascii_accels_disabled := false;
end;

destructor TzbActionsManager.destroy();
var
  i: integer;
begin
  unregisterAccels();

  for i := 0 to _actions.Count - 1 do
    TzbAction(_actions).Free;
  _actions.Free;
  _menus.Free;
  _toolbars.Free;

  inherited;
end;

procedure TzbActionsManager.disableAsciiAccels;
var
  i, accel_count: integer;
  paccels: PACCEL;
begin
  if (_ascii_accels_disabled) then
    exit;

  if (_haccel <> 0) then
    unregisterAccels;

  paccels := nil;
  try
    try
      GetMem(paccels, sizeof(ACCEL) * _actions.Count);
    except
      on EOutOfMemory do
//        DisplayError('Out of memory error');
    end;

    accel_count := 0;
    for i := 0 to _actions.Count - 1 do
    if (TzbAction(_actions[i])._accel.fVirt and (FALT or FCONTROL or FSHIFT)) <> 0 then
    begin
      paccels^ := TzbAction(_actions[i])._accel;
      inc(paccels);
      inc(accel_count);
    end;

    dec(paccels, accel_count);
    _haccel := CreateAcceleratorTable(paccels^, accel_count);
    _ascii_accels_disabled := true;
  finally
    if paccels <> nil then
      FreeMem(paccels);
  end;
end;

procedure TzbActionsManager.enableAsciiAccels;
begin
  if (_ascii_accels_disabled) then
  begin
    registerAccels;
    _ascii_accels_disabled := false;
  end;
end;

procedure TzbActionsManager.enable_invoked(cmd_id: WORD; state: WordBool);
const
  menu_item_state: array[boolean] of cardinal = (MFS_DISABLED, MFS_DISABLED xor $ffffffff);
var
  i: integer;
  tbi: TBBUTTONINFO;
  mii: MENUITEMINFO;
  id: integer;
begin
  tbi.cbSize := sizeof(tbi);
  tbi.dwMask := 0;
  for i := 0 to _toolbars.Count - 1 do
  begin
    id := SendMessage(HWND(_toolbars[i]), TB_GETBUTTONINFO, cmd_id, integer(@tbi));
    if id <> -1 then
      SendMessage(HWND(_toolbars[i]), TB_ENABLEBUTTON, id, MAKELONG(WORD(state), 0));
  end;

  mii.cbSize := sizeof(mii);
  mii.fMask := MIIM_STATE;
  for i := 0 to _menus.Count - 1 do
  begin
    if GetMenuItemInfo(HMENU(_menus[i]), cmd_id, false, mii) then
    begin
      mii.fState := mii.fState or menu_item_state[state];
      SetMenuItemInfo(HMENU(_menus[i]), cmd_id, false, mii);
    end;
  end;
end;

function TzbActionsManager.getAction(cmd_id: WORD): TzbAction;
begin
  Result := nil;
  if _actions.Count > cmd_id then
    Result := _actions[cmd_id];

  if Result = nil then
    raise Exception.Create('[getAction] action not exists');
end;

function TzbActionsManager.getCaptionId(cmd_id: WORD): WORD;
var
  a: TzbAction;
begin
  a := getAction(cmd_id);
  Result := a._caption_id;
end;

function TzbActionsManager.getEnabled(cmd_id: WORD): boolean;
var
  a: TzbAction;
begin
  a := getAction(cmd_id);
  Result := a._enabled;
end;

procedure TzbActionsManager.registerAccels;
var
  i: integer;
  paccels: PACCEL;
begin
  if _haccel <> 0 then
    unregisterAccels;

  paccels := nil;
  try
    try
      GetMem(paccels, sizeof(ACCEL) * _actions.Count);
    except
      on EOutOfMemory do
//        DisplayError('Out of memory error');
    end;

    for i := 0 to _actions.Count - 1 do
    begin
      paccels^ := TzbAction(_actions[i])._accel;
      inc(paccels);
    end;

    dec(paccels, _actions.Count);
    _haccel := CreateAcceleratorTable(paccels^, _actions.Count);

  finally
    if paccels <> nil then
      FreeMem(paccels);
  end;
end;

procedure TzbActionsManager.setEnabled(cmd_id: WORD; value: boolean);
var
  a: TzbAction;
begin
  a := getAction(cmd_id);
  a._enabled := value;
  enable_invoked(cmd_id, value);
end;

procedure TzbActionsManager.unregisterAccels;
begin
  if _haccel <> 0 then
  begin
    DestroyAcceleratorTable(_haccel);
    _haccel := 0;
  end;
end;

end.
