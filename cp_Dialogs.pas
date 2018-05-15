unit cp_Dialogs;

interface

uses
  Windows, Classes, Messages, SysUtils, cp_graphics, Forms, ShlOBJ, ActiveX;

type

{ TCommonDialog }

  TCommonDialog = class(TObject)
  protected
    _active: boolean;
  public
    constructor Create; virtual;
    function isActive(): boolean;
  end;

{ TOpenDialog }

  TOpenDialog = class(TCommonDialog)
  private
    _filter: string;
    _filter_index: Integer;
    _initial_dir: string;
    _default_ext: string;
    _file_name: string;
    _files: TStrings;
    procedure SetInitialDir(const Value: string);
  protected
    function DoExecute(Func: Pointer): Boolean;
    procedure GetFileNames(var Files: PChar);
  public
    constructor Create; override;
    destructor Destroy; override;
    function Execute: Boolean; virtual;
    property Files: TStrings read _files;
    property DefaultExt: string read _default_ext write _default_ext;
    property FileName: string read _file_name write _file_name;
    property Filter: string read _filter write _filter;
    property FilterIndex: Integer read _filter_index write _filter_index default 1;
    property InitialDir: string read _initial_dir write SetInitialDir;
  end;

{ TSaveDialog }

  TSaveDialog = class(TOpenDialog)
    function Execute: Boolean; override;
  end;

{ TColorDialog }

  TColorDialog = class(TCommonDialog)
  private
    _color: COLORREF;
  public
    function Execute: Boolean;
    property Color: COLORREF read _color write _color default 0; //clBlack
  end;

{ TFontDialog }

  TFontDialog = class(TCommonDialog)
  private
    _font: TFnt;
    _color: COLORREF;
//    _font_charset_modified: Boolean;
//    _font_color_modified: Boolean;
    procedure SetFont(Value: TFnt);
    procedure UpdateFromLogFont(lg: LOGFONT);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function Execute: Boolean;
    property Font: TFnt read _font write SetFont;
    property FontColor: COLORREF read _color write _color;
  end;

function SelectDirectory(Handle: THandle; const Caption: string; const Root: PWideChar;
  const StartDirectory: string; out Directory: string): Boolean;

function isAnyCommonDialogActive(): boolean;

const
  desktop_name: PWideChar = 'desktop';

var
  OpenDialog: TOpenDialog = nil;
  SaveDialog: TSaveDialog = nil;
  ColorDialog: TColorDialog = nil;
  FontDialog: TFontDialog = nil;

implementation


type
  TDialogFunc = function(var DialogData): Bool stdcall;

  TOpenFilename = packed record
    lStructSize: DWORD;
    hWndOwner: HWND;
    hInstance: HINST;
    lpstrFilter: PAnsiChar;
    lpstrCustomFilter: PAnsiChar;
    nMaxCustFilter: DWORD;
    nFilterIndex: DWORD;
    lpstrFile: PAnsiChar;
    nMaxFile: DWORD;
    lpstrFileTitle: PAnsiChar;
    nMaxFileTitle: DWORD;
    lpstrInitialDir: PAnsiChar;
    lpstrTitle: PAnsiChar;
    Flags: DWORD;
    nFileOffset: Word;
    nFileExtension: Word;
    lpstrDefExt: PAnsiChar;
    lCustData: LPARAM;
    lpfnHook: function(Wnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): UINT stdcall;
    lpTemplateName: PAnsiChar;
    pvReserved: Pointer;
    dwReserved: DWORD;
    FlagsEx: DWORD;
  end;

  POFNotify = ^TOFNotify;
  TOFNotify = packed record
    hdr: TNMHdr;
    lpOFN: ^TOpenFilename;
    pszFile: PAnsiChar;
  end;

const
  {$EXTERNALSYM OFN_OVERWRITEPROMPT}
  OFN_OVERWRITEPROMPT = $00000002;
  {$EXTERNALSYM OFN_HIDEREADONLY}
  OFN_HIDEREADONLY = $00000004;
  {$EXTERNALSYM OFN_ENABLEHOOK}
  OFN_ENABLEHOOK = $00000020;
  {$EXTERNALSYM OFN_ALLOWMULTISELECT}
  OFN_ALLOWMULTISELECT = $00000200;
  {$EXTERNALSYM OFN_EXPLORER}
  OFN_EXPLORER = $00080000;
  {$EXTERNALSYM OFN_ENABLESIZING}
  OFN_ENABLESIZING = $00800000;

  {$EXTERNALSYM CDN_FIRST}
  CDN_FIRST = -601;
  {$EXTERNALSYM CDN_INITDONE}
  CDN_INITDONE = CDN_FIRST - 0;

{$EXTERNALSYM GetOpenFileName}
function GetOpenFileName(var OpenFile: TOpenFilename): Bool; stdcall;  external 'comdlg32.dll'  name 'GetOpenFileNameA';
{$EXTERNALSYM GetSaveFileName}
function GetSaveFileName(var OpenFile: TOpenFilename): Bool; stdcall;  external 'comdlg32.dll'  name 'GetSaveFileNameA';

type
  TChooseColor = packed record
    lStructSize: DWORD;
    hWndOwner: HWND;
    hInstance: HWND;
    rgbResult: COLORREF;
    lpCustColors: ^COLORREF;
    Flags: DWORD;
    lCustData: LPARAM;
    lpfnHook: function(Wnd: HWND; Message: UINT; wParam: WPARAM; lParam: LPARAM): UINT stdcall;
    lpTemplateName: PAnsiChar;
  end;


const
  {$EXTERNALSYM CC_RGBINIT}
  CC_RGBINIT = $00000001;
  {$EXTERNALSYM CC_FULLOPEN}
  CC_FULLOPEN = $00000002;
  {$EXTERNALSYM CC_ENABLEHOOK}
  CC_ENABLEHOOK = $00000010;
  {$EXTERNALSYM CC_ANYCOLOR}
  CC_ANYCOLOR = $00000100;

{$EXTERNALSYM ChooseColor}
function ChooseColor(var CC: TChooseColor): Bool; stdcall; external 'comdlg32.dll'  name 'ChooseColorA';

type
  TChooseFont = packed record
    lStructSize: DWORD;
    hWndOwner: HWnd;            { caller's window handle }
    hDC: HDC;                   { printer DC/IC or nil }
    lpLogFont: PLogFontA;     { pointer to a LOGFONT struct }
    iPointSize: Integer;        { 10 * size in points of selected font }
    Flags: DWORD;               { dialog flags }
    rgbColors: COLORREF;        { returned text color }
    lCustData: LPARAM;          { data passed to hook function }
    lpfnHook: function(Wnd: HWND; Message: UINT; wParam: WPARAM; lParam: LPARAM): UINT stdcall;
                                { pointer to hook function }
    lpTemplateName: PAnsiChar;    { custom template name }
    hInstance: HINST;       { instance handle of EXE that contains
                                  custom dialog template }
    lpszStyle: PAnsiChar;         { return the style field here
                                  must be lf_FaceSize or bigger }
    nFontType: Word;            { same value reported to the EnumFonts
                                  call back with the extra fonttype_
                                  bits added }
    wReserved: Word;
    nSizeMin: Integer;          { minimum point size allowed and }
    nSizeMax: Integer;          { maximum point size allowed if
                                  cf_LimitSize is used }
  end;

const
  {$EXTERNALSYM CF_SCREENFONTS}
  CF_SCREENFONTS = $00000001;
  {$EXTERNALSYM CF_ENABLEHOOK}
  CF_ENABLEHOOK = $00000008;
  {$EXTERNALSYM CF_INITTOLOGFONTSTRUCT}
  CF_INITTOLOGFONTSTRUCT = $00000040;

{$EXTERNALSYM ChooseFont}
function ChooseFont(var ChooseFont: TChooseFont): Bool; stdcall; external 'comdlg32.dll'  name 'ChooseFontA';

procedure CenterWindow(Wnd: HWnd);
var
  Rect: TRect;
  Monitor: TMonitor;
begin
  GetWindowRect(Wnd, Rect);
  if Application.MainForm <> nil then
    Monitor := Application.MainForm.Monitor
  else
    Monitor := Screen.Monitors[0];
  SetWindowPos(Wnd, 0,
    Monitor.Left + ((Monitor.Width - Rect.Right + Rect.Left) div 2),
    Monitor.Top + ((Monitor.Height - Rect.Bottom + Rect.Top) div 3),
    0, 0, SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOZORDER);
end;

function OpenSaveDialogHook(Wnd: HWnd; Msg: UINT; WParam: WPARAM; LParam: LPARAM): UINT; stdcall;
begin
  Result := 0;
  if (Msg = WM_NOTIFY) and (POFNotify(LParam)^.hdr.code = CDN_INITDONE) then
    CenterWindow(GetWindowLong(Wnd, GWL_HWNDPARENT));
  if Msg = WM_INITDIALOG then
    CenterWindow(Wnd);
end;

function OtherDialogHook(Wnd: HWnd; Msg: UINT; WParam: WPARAM; LParam: LPARAM): UINT; stdcall;
begin
  Result := 0;
//  if (Msg = WM_NOTIFY) and (POFNotify(LParam)^.hdr.code = CDN_INITDONE) then
//    CenterWindow(GetWindowLong(Wnd, GWL_HWNDPARENT));
  if Msg = WM_INITDIALOG then
    CenterWindow(Wnd);
end;

function SelDirCallBack(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
//var
//  R: TRect;
begin
  Result := 0;
  if uMsg = BFFM_INITIALIZED then
  begin
    CenterWindow(Wnd);
{    GetWindowRect(Wnd, R);
    R := Rect((GetSystemMetrics(SM_CXSCREEN) - R.Right + R.Left) div 2,
      (GetSystemMetrics(SM_CYSCREEN) - R.Bottom + R.Top) div 2,
      R.Right - R.Left, R.Bottom - R.Top);
//    FitRectToScreen(R);
    SetWindowPos(Wnd, 0, R.Left, R.Top, 0, 0, SWP_NOACTIVATE or
      SWP_NOSIZE or SWP_NOZORDER);}
    SendMessage(Wnd, BFFM_SETSELECTION, 1, lpData);//(PChar(Directory)));
  end
end;

function SelectDirectory(Handle: THandle; const Caption: string; const Root: PWideChar;
  const StartDirectory: string; out Directory: string): Boolean;
var
  BrowseInfo: TBrowseInfo;
  Buffer: PChar;
  RootItemIDList, MyItemIDList: PItemIDList;
  ShellMalloc: IMalloc;
  IDesktopFolder: IShellFolder;
  Eaten, Flags: LongWord;
begin
  Result := False;
//  Directory := 'c:\';
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then
  begin
    Buffer := ShellMalloc.Alloc(MAX_PATH);
    try
      SHGetDesktopFolder(IDesktopFolder);
      IDesktopFolder.ParseDisplayName(Handle, nil,
        POleStr(Root), Eaten, RootItemIDList, Flags);
      with BrowseInfo do
      begin
        hwndOwner := Handle;
        pidlRoot := RootItemIDList;
        pszDisplayName := Buffer;
        lpszTitle := PChar(Caption);
        ulFlags := BIF_RETURNONLYFSDIRS;
        lpfn := @SelDirCallBack;
        lParam := integer(PChar(StartDirectory));
      end;
      MyItemIDList := ShBrowseForFolder(BrowseInfo);
      Result :=  MyItemIDList <> nil;
      if Result then
      begin
        SHGetPathFromIDList(MyItemIDList, Buffer);
        ShellMalloc.Free(MyItemIDList);
        Directory := Buffer;
      end;
    finally
      ShellMalloc.Free(Buffer);
    end;
  end;
end;

{ TOpenDialog }

constructor TOpenDialog.Create;
begin
  _filter := '';
  _file_name := '';
  _files := TStringList.Create;
  inherited Create;
end;

destructor TOpenDialog.Destroy;
begin
  _files.Free;
  inherited Destroy;
end;

function TOpenDialog.DoExecute(Func: Pointer): Boolean;
const
  MultiSelectBufferSize = High(Word) - 16;

var
  OpenFilename: TOpenFilename;

  function AllocFilterStr(const S: string): string;
  var
    P: PChar;
  begin
    Result := '';
    if S <> '' then
    begin
      Result := S + #0;  // double null terminators
      P := AnsiStrScan(PChar(Result), '|');
      while P <> nil do
      begin
        P^ := #0;
        Inc(P);
        P := AnsiStrScan(P, '|');
      end;
    end;
  end;

var
  TempFilter, TempFilename, TempExt: string;
begin
  _files.Clear;
  FillChar(OpenFileName, SizeOf(OpenFileName), 0);
  with OpenFilename do
  begin
    if (Win32MajorVersion >= 5) and (Win32Platform = VER_PLATFORM_WIN32_NT) or { Win2k }
    ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and (Win32MajorVersion >= 4) and (Win32MinorVersion >= 90)) then { WinME }
      lStructSize := SizeOf(TOpenFilename)
    else
      lStructSize := SizeOf(TOpenFilename) - (SizeOf(DWORD) shl 1) - SizeOf(Pointer); { subtract size of added fields }
//    lStructSize := SizeOf(TOpenFilename);
    hInstance := SysInit.HInstance;
    TempFilter := AllocFilterStr(_filter);
    lpstrFilter := PChar(TempFilter);
    nFilterIndex := _filter_index;
    nMaxFile := MultiSelectBufferSize;

    SetLength(TempFilename, nMaxFile + 2);
    lpstrFile := PChar(TempFilename);
    FillChar(lpstrFile^, nMaxFile + 2, 0);
    StrLCopy(lpstrFile, PChar(_file_name), nMaxFile);

    lpstrInitialDir := PChar(_initial_dir);
    Flags := OFN_HIDEREADONLY or OFN_ALLOWMULTISELECT or OFN_ENABLESIZING or
          OFN_EXPLORER or OFN_OVERWRITEPROMPT or OFN_ENABLEHOOK;

    TempExt := _default_ext;
    if (TempExt = '') then
    begin
      TempExt := ExtractFileExt(_file_name);
      Delete(TempExt, 1, 1);
    end;

    if TempExt <> '' then
      lpstrDefExt := PChar(TempExt);

    hWndOwner := GetActiveWindow;
    lpfnHook := OpenSaveDialogHook;

    _active := true;
    Result := TDialogFunc(Func)(OpenFilename);
    _active := false;
    if Result then
    begin
      GetFileNames(OpenFilename.lpstrFile);
      _filter_index := nFilterIndex;
    end;
  end;
end;

function TOpenDialog.Execute: Boolean;
begin
  Result := DoExecute(@GetOpenFileName);
end;

procedure TOpenDialog.GetFileNames(var Files: PChar);
var
  Separator: Char;

  function ExtractFileName(P: PChar; var S: string): PChar;
  begin
    Result := AnsiStrScan(P, Separator);
    if Result = nil then
    begin
      S := P;
      Result := StrEnd(P);
    end
    else
    begin
      SetString(S, P, Result - P);
      Inc(Result);
    end;
  end;

  procedure ExtractFileNames(P: PChar);
  var
    DirName, FileName: string;
  begin
    P := ExtractFileName(P, DirName);
    P := ExtractFileName(P, FileName);
    if FileName = '' then
      _files.Add(DirName)
    else
    begin
      if AnsiLastChar(DirName)^ <> '\' then
        DirName := DirName + '\';
      repeat
        if (FileName[1] <> '\') and ((Length(FileName) <= 3) or
          (FileName[2] <> ':') or (FileName[3] <> '\')) then
          FileName := DirName + FileName;
        _files.Add(FileName);
        P := ExtractFileName(P, FileName);
      until FileName = '';
    end;
  end;

begin
  Separator := #0;
  ExtractFileNames(Files);
  _file_name := _files[0];
end;

procedure TOpenDialog.SetInitialDir(const Value: string);
var
  L: Integer;
begin
  L := Length(Value);
  if (L > 1) and IsPathDelimiter(Value, L)
    and not IsDelimiter(':', Value, L - 1) then Dec(L);
  _initial_dir := Copy(Value, 1, L);
end;

{ TSaveDialog }

function TSaveDialog.Execute: Boolean;
begin
  Result := DoExecute(@GetSaveFileName);
end;

{ TColorDialog }

function TColorDialog.Execute: Boolean;
const
  CustomColorsArray: array[0..15] of COLORREF =
    ($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF,
     $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF);
var
  ChooseColorRec: TChooseColor;

begin
  ZeroMemory(@ChooseColorRec, sizeof(ChooseColorRec));
  with ChooseColorRec do
  begin
    lStructSize := sizeof(ChooseColorRec);
    hInstance := SysInit.HInstance;
//    rgbResult := ColorToRGB(_color);
    rgbResult := _color;
    lpCustColors := @CustomColorsArray;
    Flags := CC_RGBINIT or CC_FULLOPEN or CC_ANYCOLOR or CC_ENABLEHOOK;
    hWndOwner := GetActiveWindow;
    lpfnHook := OtherDialogHook;
    _active := true;
    Result := ChooseColor(ChooseColorRec);
    _active := false;
    if Result then
      _color := rgbResult;
  end;
end;

{ TFontDialog }

constructor TFontDialog.Create;
var
  lg_: LOGFONT;
begin
  _font := TFnt.Create;
  GetObject(GetStockObject(SYSTEM_FONT), sizeof(LOGFONT), @lg_);
  _font.initialize(lg_);
  _color := 0; //black
  inherited Create;
end;

destructor TFontDialog.Destroy;
begin
  _font.Free;
  inherited Destroy;
end;

function TFontDialog.Execute: Boolean;
var
  ChooseFontRec: TChooseFont;
  lg: LOGFONT;
  OriginalFaceName: string;
  SaveFontDialog: TFontDialog;
begin
  ZeroMemory(@ChooseFontRec, sizeof(TChooseFont));
  with ChooseFontRec do
  begin
    lStructSize := SizeOf(ChooseFontRec);
    hDC := 0;
    lpLogFont := @lg;
    GetObject(Font.get_handle, SizeOf(lg), @lg);
    OriginalFaceName := lg.lfFaceName;
    Flags := CF_SCREENFONTS or CF_INITTOLOGFONTSTRUCT or CF_ENABLEHOOK;
    rgbColors := _color;
    lCustData := 0;
    nSizeMin := 0;
    nSizeMax := 0;
    hWndOwner := GetActiveWindow;
    lpfnHook := OtherDialogHook;
    SaveFontDialog := FontDialog;
    FontDialog := Self;
    _active := true;
    Result := ChooseFont(ChooseFontRec);
    _active := false;
    FontDialog := SaveFontDialog;
    if Result then
    begin
//      if AnsiCompareText(OriginalFaceName, lg.lfFaceName) <> 0 then
//        _font_charset_modified := True;
      UpdateFromLogFont(lg);
      _color := rgbColors;
    end;
  end;
end;

procedure TFontDialog.SetFont(Value: TFnt);
var
  lg: LOGFONT;
  fd: TFontData;
begin
  _font.uninitialize;
  GetObject(Value.get_handle, sizeof(LOGFONT), @lg);
  StrCopy(fd.name, lg.lfFaceName);
  fd.size := TFnt.height_to_size(lg.lfHeight);
  fd.attr := [];
  fd.charset := DEFAULT_CHARSET;
  _font.initialize(fd);
  _color := 0; //black
end;

procedure TFontDialog.UpdateFromLogFont(lg: LOGFONT);
begin
  _font.initialize(lg);
end;

{ TCommonDialog }

constructor TCommonDialog.Create;
begin
  _active := false;
end;

function TCommonDialog.isActive: boolean;
begin
  Result := _active;
end;

function isAnyCommonDialogActive(): boolean;
begin
  Result :=
    (Assigned(OpenDialog) and OpenDialog.isActive()) or
    (Assigned(SaveDialog) and SaveDialog.isActive()) or
    (Assigned(ColorDialog) and ColorDialog.isActive()) or
    (Assigned(FontDialog) and FontDialog.isActive());
end;

initialization

  OpenDialog := TOpenDialog.Create;
  SaveDialog := TSaveDialog.Create;
  ColorDialog := TColorDialog.Create;
  FontDialog := TFontDialog.Create;

finalization

  OpenDialog.Free;
  OpenDialog := nil;
  SaveDialog.Free;
  SaveDialog := nil;
  ColorDialog.Free;
  ColorDialog := nil;
  FontDialog.Free;
  FontDialog := nil;

end.
