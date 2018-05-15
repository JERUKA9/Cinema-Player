unit cp_graphics;

interface

uses
  Windows, Classes, SysUtils;

type
  TGDIObject = class(TObject)
  protected
    _handle: HGDIOBJ;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure uninitialize; virtual;
    procedure assign(h: HGDIOBJ); virtual; abstract;
    function unassign: HGDIOBJ; virtual;
    function get_handle: HGDIOBJ;
  end;

  TBmp = class(TGDIObject)
  protected
    _bits: PDWORD;
    _bmp: BITMAP;
    _dc: HDC;
  public
    function initialize(width, height: integer): boolean; virtual; abstract;
    procedure uninitialize; override;

    procedure assign(h: HGDIOBJ); override;
    function unassign: HGDIOBJ; override;

    procedure clear; virtual; abstract;
    function get_dc(): HDC;
    function get_width(): integer;
    function get_height(): integer;
    function get_pitch(): integer;
    function get_bits(): Pointer;
    procedure SaveToFile(fname: string);
  end;

  TDDBmp = class(TBmp)
  public
    function initialize(width, height: integer): boolean; override;
    procedure clear; override;
  end;

  TDIBmp = class(TBmp)
  public
    function initialize(width, height: integer; bpp: word = 32): boolean; reintroduce;
    procedure clear; override;
  end;

  TFontAttr = (faBold, faItalic, faUnderline);
  TFontAttrs = set of TFontAttr;
  TFontData = record
    name: array[0..LF_FACESIZE - 1] of AnsiChar;
    size: integer;
    attr: TFontAttrs;
    charset: byte;
  end;

  TFnt = class(TGDIObject)
  private
    _logfont: LOGFONT;
  public
    function initialize(var fd: TFontData): boolean; overload;
    function initialize(var lg: LOGFONT): boolean; overload;
    procedure uninitialize; override;
    function is_same_font(var fd: TFontData): boolean; overload;
    function is_same_font(var lg: LOGFONT): boolean; overload;
    procedure get_font_data(var fd: TFontData);

    procedure assign(h: HGDIOBJ); override;
    function unassign: HGDIOBJ; override;
    class function height_to_size(height: integer): integer;
    class function size_to_height(size: integer): integer;
  end;

implementation

var
  log_pixels: integer;

{ TGDIObject }

constructor TGDIObject.Create;
begin
  unassign;
end;

destructor TGDIObject.Destroy;
begin
  uninitialize;
  inherited Destroy;
end;

function TGDIObject.get_handle: HGDIOBJ;
begin
  Result := _handle;
end;

function TGDIObject.unassign: HGDIOBJ;
begin
  Result := _handle;
  _handle := 0;
end;

procedure TGDIObject.uninitialize;
begin
  if _handle > 0 then
  begin
    DeleteObject(_handle);
    _handle := 0;
  end;
end;

{ TBmp }

procedure TBmp.uninitialize;
begin
  if _handle > 0 then
  begin
    if _dc > 0 then
      DeleteDC(_dc);
    inherited uninitialize;
    _bits := nil;
    _dc := 0;
    ZeroMemory(@_bmp, sizeof(BITMAP));
  end;
end;

function TBmp.get_dc: HDC;
begin
  Result := _dc;
end;

function TBmp.get_height: integer;
begin
  Result := _bmp.bmHeight;
end;

function TBmp.get_width: integer;
begin
  Result := _bmp.bmWidth;
end;

function TBmp.get_bits: Pointer;
var
  bf_: DIBSECTION;
begin
  GetObject(_handle, sizeof(DIBSECTION), @bf_);
  Result := bf_.dsBm.bmBits;
end;

function TBmp.get_pitch: integer;
begin
  Result := _bmp.bmWidthBytes;
end;

procedure TBmp.assign(h: HGDIOBJ);
var
  hb_: HBITMAP;
begin
  if _handle = 0 then
    _dc := CreateCompatibleDC(0);
  hb_ := SelectObject(_dc, h);
  if _handle > 0 then
    DeleteObject(hb_);
  _handle := h;
  GetObject(_handle, sizeof(BITMAP), @_bmp);
end;

function TBmp.unassign: HGDIOBJ;
begin
  Result := inherited unassign;
  _bits := nil;
  _dc := 0;
  ZeroMemory(@_bmp, sizeof(BITMAP));
end;

procedure TBmp.SaveToFile(fname: string);
var
  bits: PDWORD;
begin
  with TFileStream.Create(ExtractFilePath(ParamStr(0)) + Format(fname + '%d_%d.raw', [get_width, get_height]), fmCreate) do
    try
      bits := get_bits;
      Write(bits^, get_height * get_pitch);
    finally
      Free;
    end;
end;

{ TDDBmp }

function TDDBmp.initialize(width, height: integer): boolean;
var
  tmp_dc_: HDC;
begin
  Result := false;
  if (_handle <> 0) and (_bmp.bmWidth = width) and (_bmp.bmHeight = height) then
  begin
    Result := true;
    exit;
  end;
  uninitialize;
  tmp_dc_ := GetDC(0);
  try
    _handle := CreateCompatibleBitmap(tmp_dc_, width, height);
    if (_handle > 0) and (GetObject(_handle, sizeof(BITMAP), @_bmp) = sizeof(BITMAP)) then
    begin
      _dc := CreateCompatibleDC(0);
      SelectObject(_dc, _handle);
      Result := true;
    end
    else
      uninitialize;
  finally
    ReleaseDC(0, tmp_dc_);
  end;
end;

procedure TDDBmp.clear;
begin
//  if _handle > 0 then
//    BitBlt(_dc, 0, 0, _bmp.bmWidth, _bmp.bmHeight, );
end;

{ TDIBmp }

function TDIBmp.initialize(width, height: integer; bpp: word): boolean;
var
  _bmih: BITMAPINFOHEADER;
begin
  Result := false;
  if (_handle <> 0) and (_bmp.bmWidth = width) and (_bmp.bmHeight = height) then
  begin
    Result := true;
    exit;
  end;
  _bmih.biSize := sizeof(BITMAPINFOHEADER);
  _bmih.biWidth := width;
  _bmih.biHeight := height;
  _bmih.biPlanes := 1;
  _bmih.biBitCount := bpp;
  _bmih.biCompression := BI_RGB;
  _bmih.biSizeImage := 0;
  _bmih.biXPelsPerMeter := 0;
  _bmih.biYPelsPerMeter := 0;
  _bmih.biClrUsed := 0;
  _bmih.biClrImportant := 0;
  uninitialize;
  _handle := CreateDIBSection(0, PBITMAPINFO(@_bmih)^, 0, Pointer(_bits), 0, 0);
  if (_handle > 0) and (GetObject(_handle, sizeof(BITMAP), @_bmp) = sizeof(BITMAP)) then
  begin
    _dc := CreateCompatibleDC(0);
    SelectObject(_dc, _handle);
    Result := true;
  end
  else
    uninitialize;
end;

procedure TDIBmp.Clear;
begin
  if _handle > 0 then
    ZeroMemory(_bits, _bmp.bmWidthBytes * _bmp.bmHeight);
end;

{ TFnt }

class function TFnt.height_to_size(height: integer): integer;
begin
  Result := -MulDiv(height, 72, log_pixels)
end;

class function TFnt.size_to_height(size: integer): integer;
begin
  Result := -MulDiv(size, log_pixels, 72);
end;

function TFnt.initialize(var lg: LOGFONT): boolean;
begin
  Result := false;
  if is_same_font(lg) then
  begin
    Result := true;
    exit;
  end;
  uninitialize;
  _logfont := lg;
  _handle := CreateFontIndirect(_logfont);
  if (_handle > 0) and (GetObject(_handle, sizeof(LOGFONT), @_logfont) = sizeof(LOGFONT)) then
  begin
    Result := true;
  end
  else
    uninitialize;
end;

function TFnt.initialize(var fd: TFontData): boolean;
const
  fb: array[boolean] of integer = (FW_NORMAL, FW_BOLD);
begin
  Result := false;
  if is_same_font(fd) then
  begin
    Result := true;
    exit;
  end;
  uninitialize;
  StrCopy(_logfont.lfFaceName, fd.name);
  _logfont.lfHeight := size_to_height(fd.size);
  _logfont.lfWeight := fb[faBold in fd.attr];
  _logfont.lfItalic := byte(faItalic in fd.attr);
  _logfont.lfUnderline := byte(faUnderline in fd.attr);
  _logfont.lfCharSet := fd.charset;
  _logfont.lfOutPrecision := OUT_DEFAULT_PRECIS;
  _logfont.lfClipPrecision := CLIP_DEFAULT_PRECIS;
  _logfont.lfQuality := DEFAULT_QUALITY;
  _logfont.lfPitchAndFamily := DEFAULT_PITCH;
  _handle := CreateFontIndirect(_logfont);
  if (_handle > 0) and (GetObject(_handle, sizeof(LOGFONT), @_logfont) = sizeof(LOGFONT)) then
  begin
    Result := true;
  end
  else
    uninitialize;
end;

procedure TFnt.uninitialize;
begin
  if _handle > 0 then
  begin
    inherited uninitialize;
    ZeroMemory(@_logfont, sizeof(LOGFONT));
  end;
end;

function TFnt.is_same_font(var lg: LOGFONT): boolean;
begin
  Result := CompareMem(@_logfont, @lg, sizeof(LOGFONT));
end;

function TFnt.is_same_font(var fd: TFontData): boolean;
begin
  Result :=
    (_handle <> 0) and
    (UpperCase(_logfont.lfFaceName) = UpperCase(fd.name)) and
    (_logfont.lfCharSet = fd.charset) and
    (height_to_size(_logfont.lfHeight) = fd.size) and
    ((_logfont.lfWeight = FW_BOLD) = (faBold in fd.attr)) and
    ((_logfont.lfItalic > 0) = (faItalic in fd.attr)) and
    ((_logfont.lfUnderline > 0) = (faUnderline in fd.attr));
end;

procedure TFnt.assign(h: HGDIOBJ);
begin
  if _handle > 0 then
    uninitialize;
  _handle := h;
  GetObject(_handle, sizeof(LOGFONT), @_logfont);
end;

function TFnt.unassign: HGDIOBJ;
begin
  Result := inherited unassign;
  ZeroMemory(@_logfont, sizeof(LOGFONT));
end;

procedure TFnt.get_font_data(var fd: TFontData);
begin
  ZeroMemory(@fd, sizeof(TFontData));
  StrCopy(fd.name, _logfont.lfFaceName);
  fd.size := TFnt.height_to_size(_logfont.lfHeight);
  if _logfont.lfWeight = FW_BOLD then
    Include(fd.attr, faBold);
  if _logfont.lfItalic > 0 then
    Include(fd.attr, faItalic);
  if _logfont.lfUnderline > 0 then
    Include(fd.attr, faUnderline);
  fd.charset := _logfont.lfCharSet;
end;

procedure initialize;
var
  dc: HDC;
begin
  dc := GetDC(0);
  try
    log_pixels := GetDeviceCaps(dc, LOGPIXELSY);
  finally
    ReleaseDC(0, dc);
  end;
end;

initialization

  initialize();

end.
