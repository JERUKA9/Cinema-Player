unit cp_Registry;

interface

uses
  Windows, SysUtils;

type
  TRegKeyInfo = record
    NumSubKeys: Integer;
    MaxSubKeyLen: Integer;
    NumValues: Integer;
    MaxValueLen: Integer;
    MaxDataLen: Integer;
    FileTime: TFileTime;
  end;

  TConfigStorage = class(TObject)
  public
    destructor Destroy; override;

    function OpenKey(const Key: string; CanCreate: boolean = false): boolean; virtual; abstract;
    procedure CloseKey; virtual; abstract;

    function ReadBool(const Name: string; Default: Boolean = false): Boolean; virtual; abstract;
    function ReadFloat(const Name: string; Default: Double = 0.0): Double; virtual; abstract;
    function ReadInteger(const Name: string; Default: integer = 0): integer; virtual; abstract;
    function ReadString(const Name: string; Default: string = ''): string; virtual; abstract;
    procedure WriteBool(const Name: string; Value: Boolean); virtual; abstract;
    procedure WriteFloat(const Name: string; Value: Double); virtual; abstract;
    procedure WriteInteger(const Name: string; Value: integer); virtual; abstract;
    procedure WriteString(const Name, Value: String); virtual; abstract;
    procedure DeleteKey(const Name: String); virtual; abstract;
  end;

  TRegistry = class(TConfigStorage)
  private
    FRootKey: HKEY;
    FKey: HKEY;
    function GetKey(const Key: string): HKEY;
    function GetKeyInfo(Key: HKey; var Value: TRegKeyInfo): Boolean;
    function GetData(const Name: string; {const DataType: DWORD; }Buffer: Pointer;
      BufSize: Integer): boolean;
    procedure PutData(const Name: string; Buffer: Pointer; BufSize,
      RegData: integer);

  public
    constructor Create;

    function OpenKey(const Key: string; CanCreate: boolean = false): boolean; override;
    procedure CloseKey; override;

    function ReadBool(const Name: string; Default: boolean = false): Boolean; override;
    function ReadFloat(const Name: string; Default: double = 0.0): Double; override;
    function ReadInteger(const Name: string; Default: integer = 0): Integer; override;
    function ReadString(const Name: string; Default: string = ''): string; override;
    procedure WriteBool(const Name: string; Value: Boolean); override;
    procedure WriteFloat(const Name: string; Value: Double); override;
    procedure WriteInteger(const Name: string; Value: Integer); override;
    procedure WriteString(const Name, Value: string); override;
    procedure DeleteKey(const Name: string); override;
    procedure DeleteValue(const Value: string);

    property RootKey: HKEY read FRootKey write FRootKey;
  end;

  TIniFile = class(TConfigStorage)
  private
    _file_name: string;
    _def_file_name: string;
    _section: string;
  public
    constructor Create(const FileName: string; const DefaultFileName: string = '');

    function OpenKey(const Key: string; CanCreate: boolean = false): boolean; override;
    procedure CloseKey; override;

    function ReadBool(const Name: string; Default: Boolean = false): Boolean; override;
    function ReadFloat(const Name: string; Default: Double = 0.0): Double; override;
    function ReadInteger(const Name: string; Default: integer = 0): integer; override;
    function ReadString(const Name: string; Default: string = ''): string; override;
    function ReadIntString(const Name: integer; Default: string = ''): string;
    procedure WriteBool(const Name: string; Value: Boolean); override;
    procedure WriteFloat(const Name: string; Value: Double); override;
    procedure WriteInteger(const Name: string; Value: integer); override;
    procedure WriteString(const Name, Value: String); override;
    procedure DeleteKey(const Name: String); override;
    procedure UpdateFile;
    property FileName: string read _file_name;
  end;

implementation

{ TRegistry }

procedure TRegistry.CloseKey;
begin
  if FKey <> 0 then
  begin
    RegCloseKey(FKey);
    FKey := 0;
  end;
end;

constructor TRegistry.Create;
begin
  FRootKey := HKEY_CURRENT_USER;
  FKey := 0;
end;

function TRegistry.GetData(const Name: string; Buffer: Pointer;
  BufSize: Integer): boolean;
begin
  Result := RegQueryValueEx(FKey, PChar(Name), nil, nil, PByte(Buffer), @BufSize) = ERROR_SUCCESS ;
end;

procedure TRegistry.PutData(const Name: string; Buffer: Pointer;
  BufSize: Integer; RegData: integer);
begin
  RegSetValueEx(FKey, PChar(Name), 0, RegData, Buffer, BufSize);
end;

function TRegistry.GetKey(const Key: string): HKEY;
begin
  Result := 0;
  RegOpenKeyEx(FRootKey, PChar(Key), 0, KEY_ALL_ACCESS, Result);
end;

function TRegistry.GetKeyInfo(Key: HKey; var Value: TRegKeyInfo): Boolean;
begin
  FillChar(Value, SizeOf(TRegKeyInfo), 0);
  Result := RegQueryInfoKey(Key, nil, nil, nil, @Value.NumSubKeys,
    @Value.MaxSubKeyLen, nil, @Value.NumValues, @Value.MaxValueLen,
    @Value.MaxDataLen, nil, @Value.FileTime) = ERROR_SUCCESS;
  if SysLocale.FarEast and (Win32Platform = VER_PLATFORM_WIN32_NT) then
    with Value do
    begin
      Inc(MaxSubKeyLen, MaxSubKeyLen);
      Inc(MaxValueLen, MaxValueLen);
    end;
end;

function TRegistry.OpenKey(const Key: string; CanCreate: boolean): boolean;
var
  Disposition: integer;
begin
  CloseKey;

  if CanCreate then
    Result := RegCreateKeyEx(FRootKey, PChar(Key), 0, nil, REG_OPTION_NON_VOLATILE,
      KEY_ALL_ACCESS, nil, FKey, @Disposition) = ERROR_SUCCESS
  else
    Result := RegOpenKeyEx(FRootKey, PChar(Key), 0, KEY_ALL_ACCESS, FKey) = ERROR_SUCCESS;
end;

procedure TRegistry.DeleteKey(const Name: String);
var
  Len: DWORD;
  i: Integer;
  KeyName: string;
  {OldKey, }TempKey: HKEY;
  Info: TRegKeyInfo;
begin
//  OldKey := FKey;
  TempKey := GetKey(Name);
  if Tempkey <> 0 then
  try
//    FKey := TempKey;
    if GetKeyInfo(TempKey, Info) then
    begin
      SetString(KeyName, nil, Info.MaxSubKeyLen + 1);
      for i := Info.NumSubKeys - 1 downto 0 do
      begin
        Len := Info.MaxSubKeyLen + 1;
        if RegEnumKeyEx(TempKey, DWORD(I), PChar(KeyName), Len, nil, nil, nil, nil) = ERROR_SUCCESS then
          DeleteKey(PChar(KeyName));
      end;
    end;
  finally
//    SetCurrentKey(OldKey);
    RegCloseKey(TempKey);
  end;
//  Result := RegDeleteKey(FRootKey, PChar(Name)) = ERROR_SUCCESS;
  RegDeleteKey(FRootKey, PChar(Name));
end;

function TRegistry.ReadBool(const Name: string; Default: Boolean): Boolean;
begin
  Result := ReadInteger(Name, Ord(Default)) <> 0;
end;

function TRegistry.ReadFloat(const Name: string; Default: Double): Double;
var
  Data: double;
begin
  if GetData(Name, @Data, sizeof(Data)) then
    Result := Data
  else
    Result := Default;
end;

function TRegistry.ReadInteger(const Name: string; Default: Integer): integer;
var
  Data: integer;
begin
  if GetData(Name, @Data, sizeof(Data)) then
    Result := Data
  else
    Result := Default;
end;

function TRegistry.ReadString(const Name: string; Default: string): string;
var
  Data: array[0..999] of char;
begin
  ZeroMemory(@Data, 1000);
  if GetData(Name, @Data, 1000) then
    Result := Data
  else
    Result := Default;
end;

procedure TRegistry.WriteBool(const Name: string; Value: Boolean);
begin
  WriteInteger(Name, Ord(Value));
end;

procedure TRegistry.WriteFloat(const Name: string; Value: Double);
begin
  PutData(Name, @Value, SizeOf(Double), REG_BINARY);
end;

procedure TRegistry.WriteInteger(const Name: string;
  Value: Integer);
begin
  PutData(Name, @Value, SizeOf(Integer), REG_DWORD);
end;

procedure TRegistry.WriteString(const Name, Value: String);
begin
  PutData(Name, PChar(Value), Length(Value)+1, REG_SZ);
end;

procedure TRegistry.DeleteValue(const Value: string);
begin
  RegDeleteValue(FKey, PChar(Value));
end;

{ TIniFile }

constructor TIniFile.Create(const FileName: string; const DefaultFileName: string);
begin
  _file_name := FileName;
  _def_file_name := DefaultFileName;
end;

procedure TIniFile.DeleteKey(const Name: String);
begin
  WritePrivateProfileString(PChar(_section), PChar(Name), nil, PChar(_file_name));
end;

function TIniFile.ReadBool(const Name: string; Default: Boolean): Boolean;
begin
  Result := ReadInteger(Name, Ord(Default)) <> 0;
end;

function TIniFile.ReadFloat(const Name: string; Default: Double): Double;
var
  FloatStr: string;
begin
  FloatStr := ReadString(Name, '');
  Result := Default;
  if FloatStr <> '' then
  try
    Result := StrToFloat(FloatStr);
  except
    on EConvertError do
    else raise;
  end;
end;

function TIniFile.ReadInteger(const Name: string; Default: Integer): integer;
var
  IntStr: string;
begin
  IntStr := ReadString(Name, '');
  if (Length(IntStr) > 2) and (IntStr[1] = '0') and
    ((IntStr[2] = 'X') or (IntStr[2] = 'x')) then
    IntStr := '$' + Copy(IntStr, 3, Maxint);
  Result := StrToIntDef(IntStr, Default);
end;

function TIniFile.ReadString(const Name: string; Default: string): string;
const
  strUnavailable: PChar = '???';
var
  Buffer: array[0..2047] of Char;
begin
  GetPrivateProfileString(PChar(_section), PChar(Name), strUnavailable,
    Buffer, SizeOf(Buffer), PChar(_file_name));
  if (StrComp(strUnavailable, Buffer) = 0) then
    GetPrivateProfileString(PChar(_section), PChar(Name), PChar(Default),
      Buffer, SizeOf(Buffer), PChar(_def_file_name));
  SetString(Result, Buffer, StrLen(Buffer));
end;

function TIniFile.ReadIntString(const Name: integer;
  Default: string): string;
begin
  Result := ReadString(FormatFloat('0000', Name), Default);
end;

procedure TIniFile.UpdateFile;
begin
  WritePrivateProfileString(nil, nil, nil, PChar(_file_name));
end;

procedure TIniFile.WriteBool(const Name: string; Value: Boolean);
const
  Values: array[Boolean] of string = ('0', '1');
begin
  WriteString(Name, Values[Value]);
end;

procedure TIniFile.WriteFloat(const Name: string; Value: Double);
begin
  WriteString(Name, FloatToStr(Value));
end;

procedure TIniFile.WriteInteger(const Name: string;
  Value: Integer);
begin
  WriteString(Name, IntToStr(Value));
end;

procedure TIniFile.WriteString(const Name, Value: String);
begin
  WritePrivateProfileString(PChar(_section), PChar(Name), PChar(Value), PChar(_file_name))
end;

procedure TIniFile.CloseKey;
begin
  _section := '';
end;

function TIniFile.OpenKey(const Key: string; CanCreate: boolean): boolean;
begin
  _section := Key;
end;

{ TConfigStorage }

destructor TConfigStorage.Destroy;
begin
  CloseKey;
  inherited Destroy;
end;

end.
