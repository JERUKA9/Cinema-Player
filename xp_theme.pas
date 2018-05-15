unit xp_theme;

interface

uses
  Windows;

type
  HTHEME = THandle;

var
  OpenThemeData: function(hwnd: HWND; pszClassList: PWideChar): HTHEME; stdcall;
  CloseThemeData: function(hTheme: HTHEME): HRESULT; stdcall;
  DrawThemeBackground: function(hTheme: HTHEME; hdc: HDC; iPartId, iStateId: integer;
    const pRect: TRect; const pClipRect: TRect): HRESULT; stdcall;
  DrawThemeText: function(hTheme: HTHEME; hdc: HDC; iPartId, iStateId: integer;
    pszText: PWideChar; iCharCount: integer; dwTextFlags, dwTextFlags2: DWORD;
    const pRect: TRect): HRESULT; stdcall;
  GetThemeColor: function(hTheme: HTHEME; iPartId, iStateId, iPropId: integer;
    var pColor: COLORREF): HRESULT; stdcall;
  GetThemeBackgroundContentRect: function(hTheme: HTHEME; hdc: HDC;
    iPartId, iStateId: integer; const pBoundingRect: TRect;
    var pContentRect: TRect): HRESULT; stdcall;

  SetWindowTheme: function(hwnd: HWND; pszSubAppName: PWideChar;
    pszSubIdList: PWideChar): HRESULT; stdcall;
  EnableThemeDialogTexture: function(hwnd: HWND;
    dwFlags: DWORD): HRESULT; stdcall;
  IsThemeBackgroundPartiallyTransparent: function(hTheme: HTHEME; iPartId,
    iStateId: Integer): BOOL; stdcall;
  DrawThemeParentBackground: function(hwnd: HWND; hdc: HDC;
    prc: PRECT): HRESULT; stdcall;
//  GetWindowTheme: function(hWnd: HWND): HTHEME; stdcall;

function isXPThemeSupported: boolean;

const
  TABP_PANE                = 9;
  ETDT_DISABLE             = $00000001;
  ETDT_ENABLE              = $00000002;
  ETDT_USETABTEXTURE       = $00000004;
  ETDT_ENABLETAB           = ETDT_ENABLE or ETDT_USETABTEXTURE;
  SPP_USERPANE             = 1;
  SPP_PLACESLISTSEPARATOR  = 7;
  SPS_NORMAL               = 1;
  BP_PUSHBUTTON            = 1;
  PBS_NORMAL               = 1;
  PBS_HOT                  = 2;
  PBS_PRESSED              = 3;
  PBS_DISABLED             = 4;
  PBS_DEFAULTED            = 5;

implementation

{ TXPTheme }

var
  hThemeLib: longint = 0;
  IsAppThemed: function(): BOOL; stdcall;
  IsThemeActive: function(): BOOL; stdcall;

function isXPThemeSupported: boolean;
begin
  Result := hThemeLib > 0;
  if Result then
    Result := IsAppThemed and IsThemeActive;
end;

initialization

  hThemeLib := LoadLibrary('uxtheme.dll');
  if hThemeLib = 0 then
  begin
    IsAppThemed := nil;
    IsThemeActive := nil;
    OpenThemeData := nil;
    CloseThemeData := nil;
    GetThemeBackgroundContentRect := nil;
    DrawThemeBackground := nil;
    DrawThemeText := nil;
    GetThemeColor := nil;
    SetWindowTheme := nil;
    EnableThemeDialogTexture := nil;
    IsThemeBackgroundPartiallyTransparent := nil;
    DrawThemeParentBackground := nil;
//    GetWindowTheme := nil;
  end
  else
  begin
    IsAppThemed := Pointer(GetProcAddress(hThemeLib, 'IsAppThemed'));
    IsThemeActive := Pointer(GetProcAddress(hThemeLib, 'IsThemeActive'));
    OpenThemeData := Pointer(GetProcAddress(hThemeLib, 'OpenThemeData'));
    CloseThemeData := Pointer(GetProcAddress(hThemeLib, 'CloseThemeData'));
    GetThemeBackgroundContentRect := Pointer(GetProcAddress(hThemeLib, 'GetThemeBackgroundContentRect'));
    DrawThemeBackground := Pointer(GetProcAddress(hThemeLib, 'DrawThemeBackground'));
    DrawThemeText := Pointer(GetProcAddress(hThemeLib, 'DrawThemeText'));
    GetThemeColor := Pointer(GetProcAddress(hThemeLib, 'GetThemeColor'));
    SetWindowTheme := Pointer(GetProcAddress(hThemeLib, 'SetWindowTheme'));
    EnableThemeDialogTexture := Pointer(GetProcAddress(hThemeLib, 'EnableThemeDialogTexture'));
    IsThemeBackgroundPartiallyTransparent := Pointer(GetProcAddress(hThemeLib, 'IsThemeBackgroundPartiallyTransparent'));
    DrawThemeParentBackground := Pointer(GetProcAddress(hThemeLib, 'DrawThemeParentBackground'));

//    GetWindowTheme := Pointer(GetProcAddress(hThemeLib, 'GetWindowTheme'));
  end;

finalization

  if hThemeLib > 0 then
    FreeLibrary(hThemeLib);

end.
