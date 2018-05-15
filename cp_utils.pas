unit cp_utils;

interface

uses
  Windows, Classes, SysUtils, Forms;

procedure SetSize(h: HWND; const r: TRect);
function FixString(Value: string): string;
function Abs(Value: integer): integer;
function Min(Value1, Value2: integer): integer;
function Max(Value1, Value2: integer): integer;
function IsExpectedFile(ExaminedFile, Extensions: string): boolean;
function NormalizeDir(Dir: string): string;
function ScanBlanks(const S: PChar): PChar;
function ScanNumber(var S: PChar; var Number: DWORD; var CharCount: Byte): Boolean;
function ScanChar(var S: PChar; Ch: Char): Boolean;
function ScanToChar(var S: PChar; Ch: Char): Boolean;
procedure ScanCaret(const S: PChar);
procedure AddMenuItem(mHandle, mSub: HMENU; mMask, mState, mType, ID, mPos: cardinal;
  BMPnr: byte; mItem: string);
procedure DeleteMenu(mHandle: HMENU);
procedure ShowPopupMenu(mHandle: HMENU; wHandle: HWND);
{$IFDEF DEBUG}
procedure WriteLog(where: string = ''; msg: string = '');
{$ENDIF}
function GetHint(s: string): string;
//function File_Exists(FileName: string): boolean;
function IsNextFile(curr_file, new_file: string; search_forward: boolean): boolean;
procedure ForceDirectories(Dir: string);
  var letters: array [0..255] of integer;
function freqMatchStr(const str1, str2: string): integer;
function calcEditDistance(const s1, s2: string): integer;

procedure sendMail(hWnd: HWND; const EMail: string);
procedure gotoWWW(hWnd: HWND; const Site: string);
function ExtractFileNameWithoutExt(const strFileName: string): string;

implementation

uses
  global_consts, settings_header, language, subeditor, ShellAPI;

{function File_Exists(FileName: string): boolean;
var
  Handle: THandle;
  FindData: TWin32FindData;
begin
  Handle := FindFirstFile(PChar(FileName), FindData);
  Result :=  Handle <> INVALID_HANDLE_VALUE;
  if Result then
    Windows.FindClose(Handle);
end;
}

procedure SetSize(h: HWND; const r: TRect);
begin
  MoveWindow(
    h,
    r.Left,
    r.Top,
    r.Right - r.Left,
    r.Bottom - r.Top,
    true);
end;

function IsNextFile(curr_file, new_file: string; search_forward: boolean): boolean;
var
  curr_len, new_len: integer;
  differ_start, curr_differ_stop, new_differ_stop: integer;
  curr_int, new_int: int64;
  curr_str_diff, new_str_diff: string;
begin
  Result := false;
  curr_file := AnsiLowerCase(curr_file);
  new_file := AnsiLowerCase(new_file);
  if curr_file = new_file then
    exit;
  if ExtractFileExt(curr_file) <> ExtractFileExt(new_file) then
    exit;

  curr_len := Length(curr_file);
  new_len := Length(new_file);

  differ_start := 1;
// find first different char in files names
  while (differ_start <= curr_len) and (differ_start <= new_len) and
        (curr_file[differ_start] = new_file[differ_start]) do
    inc(differ_start);
  if (differ_start = 1) and not (curr_file[differ_start] in ['0'..'9']) then
    exit;

// step back while last common char is digit
  while (differ_start > 2) and
        (curr_file[differ_start - 1] in ['0'..'9']) and (new_file[differ_start - 1] in ['0'..'9']) do
    dec(differ_start);

  curr_differ_stop := curr_len;
  new_differ_stop := new_len;
  while (curr_differ_stop >= 1) and (new_differ_stop >= 1) and
        (curr_file[curr_differ_stop] = new_file[new_differ_stop]) do
  begin
    dec(curr_differ_stop);
    dec(new_differ_stop);
  end;

  if (curr_differ_stop < differ_start) or (new_differ_stop < differ_start) then
    exit;


// step forward while first common char is digit
  while (curr_differ_stop < curr_len) and (new_differ_stop < new_len) and
        (curr_file[curr_differ_stop + 1] in ['0'..'9']) and (new_file[new_differ_stop + 1] in ['0'..'9']) do
  begin
    inc(curr_differ_stop);
    inc(new_differ_stop);
  end;

  curr_str_diff := Copy(curr_file, differ_start, curr_differ_stop - differ_start + 1);
  new_str_diff := Copy(new_file, differ_start, new_differ_stop - differ_start + 1);
  try
    curr_int := StrToInt(curr_str_diff);
    new_int := StrToInt(new_str_diff);
  except
    if (Length(curr_str_diff) = 1) and (Length(new_str_diff) = 1) and
       (LowerCase(curr_str_diff)[1] in ['a'..'z']) and
       (LowerCase(new_str_diff)[1] in ['a'..'z']) then
    begin
      Result :=
        (search_forward and ((Ord(new_str_diff[1]) - Ord(curr_str_diff[1])) = 1)) or
        (not search_forward and ((Ord(curr_str_diff[1]) - Ord(new_str_diff[1])) = 1));
    end;
    exit;
  end;
  Result :=
    (search_forward and ((new_int - curr_int) = 1)) or
    (not search_forward and ((curr_int - new_int) = 1));
end;

{$IFDEF DEBUG}
procedure WriteLog(where, msg: string);
begin
  writeln(output, Format('[' + FormatDateTime('hh:nn:ss', Time) + '] - %.20s: %s',
    [where, msg]));
end;
{$ENDIF}

function GetHint(s: string): string;
var
  i: integer;
begin
  i := Pos('&', s);
  if i > 0 then
    Delete(s, i, 1);
  i := Pos('...', s);
  if i > 0 then
    Delete(s, i, 3);
  Result := s;
end;

function FixString(Value: string): string;
var
  i: integer;
begin
  Result := Value;
  for i := 1 to Length(Result) do
    if Result[i] = ' ' then
      Result[i] := '0';
end;

function Abs(Value: integer): integer;
begin
  if Value < 0 then
    Result := Value * -1
  else
    Result := Value;
end;

function Min(Value1, Value2: integer): integer;
begin
  if Value1 < Value2 then
    Result := Value1
  else
    Result := Value2;
end;

function Max(Value1, Value2: integer): integer;
begin
  if Value1 > Value2 then
    Result := Value1
  else
    Result := Value2;
end;

function IsExpectedFile(ExaminedFile, Extensions: string): boolean;
var
  SL: TStringList;
  Ext: string;
  i: integer;
begin
  Ext := ExtractFileExt(ExaminedFile);
  Ext := Copy(Ext, Pos('.', Ext) + 1, MaxInt);
  Result := false;
  SL := TStringList.Create;
  try
    SL.Text := Extensions;
    for i := 0 to SL.Count - 1 do
    begin
      if AnsiCompareText(SL[i], Ext) = 0 then
      begin
        Result := true;
        break;
      end;
    end;
  finally
    SL.Free;
  end;
end;

function NormalizeDir(Dir: string): string;
begin
  try
    if AnsiLastChar(Dir) = '\' then
      Result := Dir
    else
      Result := Dir + '\';
  except
    Result := '';
  end;
end;

function ScanBlanks(const S: PChar): PChar;
var
  I: Integer;
begin
  I := 0;
  while (I <= Length(S)) and (S[I] = ' ') do
    Inc(I);
  Result := PChar(S) + I;
end;

function ScanNumber(var S: PChar; var Number: DWORD; var CharCount: Byte): Boolean;
var
  I: Integer;
  N: DWORD;
  Tekst: PChar;
begin
  I := 0;
  N := 0;
  Tekst := ScanBlanks(S);
  CharCount := 0;
  while (I <= Length(Tekst)) and (Tekst[I] in ['0'..'9']) do
  begin
    N := N * 10 + WORD(Ord(Tekst[I]) - Ord('0'));
    Inc(I);
  end;
  CharCount := I;
  Number := N;
  S := Tekst + I;
  Result := I > 0;
end;

function ScanChar(var S: PChar; Ch: Char): Boolean;
var
  I: Integer;
  Tekst: PChar;
begin
  Result := False;
  Tekst := ScanBlanks(S);
  I := 0;
  if (I <= Length(Tekst)) and (Tekst[I] = Ch) then
  begin
    Inc(I);
    S := Tekst + I;
    Result := True;
  end;
end;

function ScanToChar(var S: PChar; Ch: Char): Boolean;
begin
  Result := False;
  while (S <> '') do
  begin
    if S[0] = Ch then
    begin
      Result := True;
      break;
    end;
    inc(S);
  end;
end;

procedure ScanCaret(const S: PChar);
var
  i: integer;
begin
  for i := 0 to Length(S) - 1 do
    if (S[i] = '|') or
       ((S[i] = '\') and (i > 0) and (S[i - 1] <> #13) and (S[i - 1] <> '/') and
        (S[i - 1] <> '_') and (S[i - 1] <> '}')) then
      S[i] := #13;
  i := Length(S) - 1;
  while (i >= 0) and (S[i] = #13) do
  begin
    S[i] := #0;
    dec(i);
  end;
end;

procedure AddMenuItem(mHandle, mSub: HMENU; mMask, mState, mType, ID, mPos: cardinal;
  BMPnr: byte; mItem: string);
var
  mii: tMENUITEMINFO;
begin
  fillchar(mii, SizeOf(mii), 0);
  with mii do
  begin
    cbSize := SizeOf(mii);
    fMask := MIIM_TYPE or MIIM_DATA or MIIM_STATE or MIIM_ID or mMask;
    fState := mState;
    fType := (MFT_STRING * cardinal(mItem <> '')) or mType;
    wID := ID;
    hSubMenu := mSub;
    dwItemData := 0;
    if mItem <> '' then
    begin
      mItem := mItem + #0;
      dwTypeData := PChar(mItem);
//      dwTypeData := PChar(LocalAlloc(LPTR, length(mItem)));
//      move(mItem[1], pointer(dwTypeData)^, length(mItem));
      cch := length(mItem);
//      mItem := mItem + chr(BMPnr + 1) + #0;
//      dwItemData := LocalAlloc(LPTR, length(mItem));
//      move(mItem[1], pointer(dwItemData)^, length(mItem));
    end
    else
    begin
      dwTypeData := nil;
      cch := 0;
    end;
  end;
  InsertMenuItem(mHandle, mPos, true, mii);
end;

procedure DeleteMenu(mHandle: HMENU);
var
  mii: tMENUITEMINFO;
  cnt: integer;
begin
  for cnt := 0 to GetMenuItemCount(mHandle) - 1 do
  begin
//    FillChar(mii, sizeof(mii), 0);
    with mii do
    begin
      cbSize := sizeof(mii);
      fMask := MIIM_DATA + MIIM_SUBMENU;
    end;
    if GetMenuItemInfo(mHandle, cnt, true, mii) then
    begin
      if mii.dwItemData <> 0 then
      begin
        LocalFree(mii.dwItemData);
        mii.fMask := MIIM_DATA;
        mii.dwItemData := 0;
        SetMenuItemInfo(mHandle, cnt, true, mii)
      end;
{      if mii.dwTypeData <> nil then
      begin
        LocalFree(cardinal(mii.dwTypeData));
        mii.fMask := MIIM_DATA;
        mii.dwItemData := 0;
        SetMenuItemInfo(mHandle, cnt, true, mii)
      end;}
      if mii.hSubMenu <> 0 then
      begin
        DeleteMenu(mii.hSubMenu);
        mii.fMask := MIIM_SUBMENU;
        mii.hSubMenu := 0;
        SetMenuItemInfo(mHandle, cnt, true, mii)
      end;
    end;
  end;
  DestroyMenu(mHandle);
end;

procedure ShowPopupMenu(mHandle: HMENU; wHandle: HWND);
var
  p: TPoint;
begin
  GetCursorPos(p);
  SetForegroundWindow(wHandle);
  TrackPopupMenu(mHandle, TPM_TOPALIGN or TPM_LEFTALIGN, p.x, p.y, 0, wHandle, nil);
  DeleteMenu(mHandle);
end;

function DirectoryExists(const Name: string): Boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributes(PChar(Name));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;

procedure ForceDirectories(Dir: string);
begin
  if Length(Dir) = 0 then
    exit;
  if (AnsiLastChar(Dir) <> nil) and (AnsiLastChar(Dir)^ = '\') then
    Delete(Dir, Length(Dir), 1);
  if (Length(Dir) < 3) or DirectoryExists(Dir)
    or (ExtractFilePath(Dir) = Dir) then Exit; // avoid 'xyz:\' problem.
  ForceDirectories(ExtractFilePath(Dir));
  CreateDir(Dir);
end;

function freqMatchStr(const str1, str2: string): integer;
var
  i, j: byte;
  letters: array[byte] of integer;
begin
  FillChar(letters, sizeof(integer) * 256, 0);
  j := 0;
  for i := 1 to length(str1) do
    inc(letters[ord(str1[i])]);
  for i := 1 to length(str2) do
    dec(letters[ord(str2[i])]);
  for i := 0 to 255 do
    inc(j, abs(letters[i]));
  Result := j;
end;

function calcEditDistance(const s1, s2: string): integer;

  function min(A,B: LongWord): LongWord;
  begin
    if A < B then
      Result := A
    else
      Result := B;
  end;

const
  cost_del: integer = 1;
  cost_ins: integer = 1;
  cost_sub: integer = 1;
var
  n1,n2: integer;
  dist: array of array of integer;
  i, j: integer;
  dist_del, dist_ins, dist_sub: integer;
begin
  n1 := Length(s1);
  n2 := Length(s2);

  SetLength(dist, n1 + 1, n2 + 1);

  dist[0, 0] := 0;

  for i := 1 to n1 do
    dist[i, 0] := dist[i - 1, 0] + cost_del;

  for i := 1 to n2 do
    dist[0, i] := dist[0, i - 1] + cost_ins;

  for i := 1 to n1 do
    for j := 1 to n2 do
    begin
      dist_del := dist[i - 1, j    ] + cost_del;
      dist_ins := dist[i    , j - 1] + cost_ins;
      dist_sub := dist[i - 1, j - 1] + integer(ord(s1[i] <> s2[j])) * cost_sub;
      dist[i, j] := min(min(dist_del, dist_ins), dist_sub);
    end;

  Result := dist[n1, n2];
  dist := nil;;
end;

procedure sendMail(hWnd: HWND; const EMail: string);
begin
  ShellExecute(hWnd, 'open', PChar('mailto:' + EMail + '?subject=' + ProgName), '', '', SW_NORMAL);
end;

procedure gotoWWW(hWnd: HWND; const Site: string);
begin
//  ShellExecute(dlgAboutBox.Handle, 'open', PChar('http:' + Site), '', '', SW_NORMAL);
  ShellExecute(hWnd, 'open', PChar('http://' + Site), '', '', SW_NORMAL);
end;

function ExtractFileNameWithoutExt(const strFileName: string): string;
var
  i: Integer;
begin
  i := LastDelimiter('\:', strFileName);
  Result := Copy(strFileName, i + 1, MaxInt);
  i := LastDelimiter('.\:', Result);
  if (i > 0) and (Result[i] = '.') then
    Result := Copy(Result, 1, i - 1);
end;

end.
