unit subtitles_style;

interface

uses
  Windows, Classes, SysUtils, subtitles_header, cp_graphics;

type
  THPosition = (phNone, phLeft, phCenter, phRight);
  TVPosition = (pvNone, pvTop, pvCenter, pvBottom);
  TSubtitlePosition = record
    hPosition: THPosition;
    vPosition: TVPosition;
  end;

  TTagType = (ttFontColor, ttFontName, ttFontSize, ttFontCharset,
    ttFontStyle, ttHatakFontStyle, ttPosition, ttHatakPosition, ttCoordinate, ttBkgColor);
  TTagTypes = set of TTagType;

  PSubtitlesStyle = ^TSubtitlesStyle;
  TSubtitlesStyle = record
    fd: TFontData;
    font_color: COLORREF;
    bkg_color: COLORREF;
    position: TSubtitlePosition;
    tags: TTagTypes;
  end;

  TSubtitlesParser = class(TObject)
  private
    line_style: TSubtitlesStyle;
    whole_style: TSubtitlesStyle;
    function is_font(var ss: TSubtitlesStyle): boolean;
    function is_font_size(var ss: TSubtitlesStyle): boolean;
    function is_bkg_color(var ss: TSubtitlesStyle): boolean;
    function is_font_color(var ss: TSubtitlesStyle): boolean;
    function is_pos(var ss: TSubtitlesStyle): boolean;
  public
    do_log: boolean;
    constructor Create;
    procedure clear(total: boolean);
    procedure get_whole_style(var fs: TSubtitlesStyle);
    procedure get_line_style(var fs: TSubtitlesStyle);
    procedure parse(var start_pos, end_pos: PChar; var line_found,
      whole_found: boolean; first_line: boolean);
    function is_whole_font: boolean;
    function is_whole_font_size: boolean;
    function is_whole_bkg_color: boolean;
    function is_whole_font_color: boolean;
    function is_whole_pos: boolean;
    function is_line_font: boolean;
    function is_line_font_size: boolean;
    function is_line_bkg_color: boolean;
    function is_line_font_color: boolean;
    function is_line_pos: boolean;
  end;

implementation

  procedure apply_font_style(fa: TFontAttr; fa1: TFontAttrs;
    var fa2: TFontAttrs);
  begin
    if fa in fa1 then
      if fa in fa2 then
        Exclude(fa2, fa)
      else
        Include(fa2, fa);
  end;

{ TSubtitlesParser }

procedure TSubtitlesParser.parse(var start_pos, end_pos: PChar;
  var line_found, whole_found: boolean; first_line: boolean);

  function find_tag(var start, stop: PChar; var tag: string;
    var global_tag: boolean; var tt: TTagType): boolean;
  var
    begin_tag, end_tag: PChar;
    tag_char: char;
  begin
    Result := false;
    global_tag := false;
    if (start[0] in ['/', '\', '_', '[']) then
    begin
      tt := ttFontStyle;
      case start[0] of
        '/':
          tag := 'I';
        '\':
          tag := 'B';
        '_':
          tag := 'U';
        '[':
        begin
          if (stop - 1)[0] = ']' then
          begin
            tag := 'B';
          end
          else
          begin
            if StrPos(start, ']') <> nil then
            begin
              exit;
            end
            else
            begin
              tt := ttBkgColor;
              tag := '$000001';
            end;
          end;
        end;
      end;
      Result := true;
// niektóre tagi mog¹ wystapiæ tak¿e na koñcu linii
      if ((start[0] = (stop - 1)[0])) or ((start[0] = '[') and ((stop - 1)[0] = ']')) then
      begin
        dec(stop);
      end;
      inc(start);
      exit;
    end;
    if (start[0] = '<') then
    begin
      if (stop - start >= 7) and (start[2] = '>') then
      begin
        begin_tag := PChar('<' + start[1] + '>');
        end_tag := PChar('</' + start[1] + '>');
        if StrLIComp(stop - 4, end_tag, 4) = 0 then
        begin
          tt := ttFontStyle;
          tag := UpCase(start[1]);
          if not (tag[1] in ['B', 'I', 'U']) then
            tag := 'I';

          inc(start, 3);
          dec(stop, 4);
          Result := true;
          exit;
        end;
      end;
    end;
    if (start[0] = '{') or ((stop - 1)[0] = '}') then
    begin
      if (start[0] = '{') then
      begin
        begin_tag := start;
        end_tag := StrPos(start, '}');
      end
      else
      begin
        (stop - 1)[0] := #0;
        begin_tag := StrRScan(start, '{');
        (stop - 1)[0] := '}';
        end_tag := stop - 1;
      end;
      if (end_tag = nil) or (begin_tag = nil) or
         (end_tag > stop) or (begin_tag < start) or
         (begin_tag[2] <> ':') then  // to nie jest tag
        exit;
      tag_char := UpCase(begin_tag[1]);
      global_tag := (tag_char = begin_tag[1]); // duza litera oznacza atrybut dla calego napisu
      tag := Trim(Copy(begin_tag, 4, integer(end_tag - begin_tag) - 3));
      Result := true;
      case tag_char of
        'C':
        begin
          tt := ttFontColor;
          if Pos('$', tag) <> 1 then
            tag := '$' + tag;
        end;
        'F': tt := ttFontName;
        'S': tt := ttFontSize;
        'H': tt := ttFontCharset;
        'Y':
        begin
          tt := ttFontStyle;
          tag := UpperCase(tag);
        end;
        'X':
        begin
          tt := ttHatakFontStyle;
          tag := UpperCase(tag);
        end;
        'P': tt := ttPosition;
        'Q':
        begin
          tt := ttHatakPosition;
          tag := UpperCase(tag);
        end;
        'O': tt := ttCoordinate;
        'B':
        begin
          tt := ttBkgColor;
          if Pos('$', tag) <> 1 then
            tag := '$' + tag;
        end;
      else
        Result := false;
      end;
      if (start[0] = '{') then
        start := end_tag + 1
      else
        stop := begin_tag;
    end;
  end;

type
  TCharsets = record
    name: string;
    value: byte;
  end;

const
  Charsets: array[0..18] of TCharsets =
  (
    (name: 'ANSI'; value: ANSI_CHARSET),
    (name: 'DEFAULT'; value: DEFAULT_CHARSET),
    (name: 'SYMBOL'; value: SYMBOL_CHARSET),
    (name: 'MAC';value: MAC_CHARSET),
    (name: 'SHIFTJIS'; value: SHIFTJIS_CHARSET),
    (name: 'HANGEUL'; value: HANGEUL_CHARSET),
    (name: 'GB2312'; value: GB2312_CHARSET),
    (name: 'CHINESEBIG5'; value: CHINESEBIG5_CHARSET),
    (name: 'OEM'; value: OEM_CHARSET),
    (name: 'JOHAB'; value: JOHAB_CHARSET),
    (name: 'HEBREW'; value: HEBREW_CHARSET),
    (name: 'ARABIC'; value: ARABIC_CHARSET),
    (name: 'BALTIC';value: BALTIC_CHARSET),
    (name: 'GREEK'; value: GREEK_CHARSET),
    (name: 'TURKISH'; value: TURKISH_CHARSET),
    (name: 'VIETNAMESE'; value: VIETNAMESE_CHARSET),
    (name: 'THAI'; value: THAI_CHARSET),
    (name: 'EASTEUROPE'; value: EASTEUROPE_CHARSET),
    (name: 'RUSSIAN'; value: RUSSIAN_CHARSET)
  );

var
  tag: string;
  global_tag: boolean;
  tt: TTagType;
  ss: PSubtitlesStyle;
  i: integer;
begin
  clear(first_line);
  end_pos := StrPos(start_pos, #13);
  if end_pos = nil then
    end_pos := StrEnd(start_pos);
// ltrim
  while (start_pos < end_pos) and (start_pos[0] = ' ') do
    inc(start_pos);
// rtrim
  while (start_pos < end_pos) and ((end_pos - 1)[0] = ' ') do
    dec(end_pos);
//  if do_log then
//  begin
//    sl.Add(Format('source: "%s"', [Copy(start_pos, 1, end_pos - start_pos)]));
//  end;
  line_found := false;
//  whole_found := false;
  while find_tag(start_pos, end_pos, tag, global_tag, tt) do
  begin
    if global_tag then
      if first_line then
      begin
        ss := @whole_style;
        whole_found := true;
      end
      else
        continue
    else
    begin
      ss := @line_style;
      line_found := true;
    end;

    Include(ss.tags, tt);
    case tt of
      ttFontName:
        StrPCopy(ss.fd.name, tag);
      ttFontColor:
        ss.font_color := StrToIntDef(tag, $ffffff);
      ttFontSize:
        ss.fd.size := StrToInt(tag);
      ttFontCharset:
      begin
        for i := 0 to 16 do
          if tag = (Charsets[i].name + '_CHARSET') then
          begin
            ss.fd.charset := Charsets[i].value;
            break;
          end;
      end;
      ttFontStyle, ttHatakFontStyle:
      begin
        for i := 1 to Length(tag) do
        begin
          case tag[i] of
            'B': Include(ss.fd.attr, faBold);
            'U': Include(ss.fd.attr, faUnderline);
            'I': Include(ss.fd.attr, faItalic);
          else
            continue;
          end;
        end;
      end;
      ttPosition:
      begin
        if (Length(tag) = 1) then
          if (tag = '0') then
            whole_style.position.vPosition := pvTop
          else
            whole_style.position.vPosition := pvBottom;
      end;
      ttHatakPosition:
      begin
        if (Length(tag) = 2) then
        begin
          case tag[1] of
            'L': whole_style.position.hPosition := phLeft;
            'C': whole_style.position.hPosition := phCenter;
            'R': whole_style.position.hPosition := phRight;
          end;
          case tag[2] of
            'T': whole_style.position.vPosition := pvTop;
            'C': whole_style.position.vPosition := pvCenter;
            'B': whole_style.position.vPosition := pvBottom;
          end;
        end;
      end;
      ttCoordinate:
      begin
      end;
      ttBkgColor:
        ss.bkg_color := StrToIntDef(tag, $000000);
    end;
  end;

//  if not do_log then
//    exit;
//  if line_found then
{  begin
    sl.Add('      line style:');
    if ttFontName in line_style.tags then
      sl.Add(Format('        FontName: %s', [line_style.fd.name]));
    if ttFontSize in line_style.tags then
      sl.Add(Format('        FontSize: %d', [line_style.fd.size]));
    if ttFontColor in line_style.tags then
      sl.Add(Format('        FontColor: $%.8x', [line_style.font_color]));
    if ttFontCharset in line_style.tags then
    begin
      sl.Add('        FontCharset: ');
      for i := 0 to 18 do
        if Charsets[i].value = line_style.fd.charset then
          sl[sl.Count - 1] := sl[sl.Count - 1] + Charsets[i].name;
    end;
    if (ttFontStyle in line_style.tags) or (ttHatakFontStyle in line_style.tags) then
    begin
      sl.Add('        FontStyle: ');
      if faBold in line_style.fd.attr then
        sl[sl.Count - 1] := sl[sl.Count - 1] + 'fsBold, ';
      if faItalic in line_style.fd.attr then
        sl[sl.Count - 1] := sl[sl.Count - 1] + 'fsItalic, ';
      if faUnderline in line_style.fd.attr then
        sl[sl.Count - 1] := sl[sl.Count - 1] + 'fsUnderline, ';
    end;
    if (ttPosition in line_style.tags) or (ttHatakPosition in line_style.tags) then
    begin
      sl.Add('        Position: ');
      case line_style.position.hPosition of
        phNone: sl[sl.Count - 1] := sl[sl.Count - 1] + 'phNone,';
        phLeft: sl[sl.Count - 1] := sl[sl.Count - 1] + 'phLeft,';
        phCenter: sl[sl.Count - 1] := sl[sl.Count - 1] + 'phCenter,';
        phRight: sl[sl.Count - 1] := sl[sl.Count - 1] + 'phRight,';
      end;
      case line_style.position.vPosition of
        pvNone: sl[sl.Count - 1] := sl[sl.Count - 1] + 'pvNone';
        pvTop: sl[sl.Count - 1] := sl[sl.Count - 1] + 'pvTop';
        pvCenter: sl[sl.Count - 1] := sl[sl.Count - 1] + 'pvCenter';
        pvBottom: sl[sl.Count - 1] := sl[sl.Count - 1] + 'pvBottom';
      end;
    end;
    if ttBkgColor in line_style.tags then
      sl.Add(Format('        BkgColor: $%.8x', [line_style.bkg_color]));
  end;
//  if whole_found then
  begin
    sl.Add('      whole style:');
    if ttFontName in whole_style.tags then
      sl.Add(Format('        FontName: %s', [whole_style.fd.name]));
    if ttFontSize in whole_style.tags then
      sl.Add(Format('        FontSize: %d', [whole_style.fd.size]));
    if ttFontColor in whole_style.tags then
      sl.Add(Format('        FontColor: $%.8x', [whole_style.font_color]));
    if ttFontCharset in whole_style.tags then
    begin
      sl.Add('        FontCharset: ');
      for i := 0 to 18 do
        if Charsets[i].value = whole_style.fd.charset then
          sl[sl.Count - 1] := sl[sl.Count - 1] + Charsets[i].name;
    end;
    if (ttFontStyle in whole_style.tags) or (ttHatakFontStyle in whole_style.tags) then
    begin
      sl.Add('        FontStyle: ');
      if faBold in whole_style.fd.attr then
        sl[sl.Count - 1] := sl[sl.Count - 1] + 'fsBold, ';
      if faItalic in whole_style.fd.attr then
        sl[sl.Count - 1] := sl[sl.Count - 1] + 'fsItalic, ';
      if faUnderline in whole_style.fd.attr then
        sl[sl.Count - 1] := sl[sl.Count - 1] + 'fsUnderline, ';
    end;
    if (ttPosition in whole_style.tags) or (ttHatakPosition in whole_style.tags) then
    begin
      sl.Add('        Position: ');
      case whole_style.position.hPosition of
        phNone: sl[sl.Count - 1] := sl[sl.Count - 1] + 'phNone,';
        phLeft: sl[sl.Count - 1] := sl[sl.Count - 1] + 'phLeft,';
        phCenter: sl[sl.Count - 1] := sl[sl.Count - 1] + 'phCenter,';
        phRight: sl[sl.Count - 1] := sl[sl.Count - 1] + 'phRight,';
      end;
      case whole_style.position.vPosition of
        pvNone: sl[sl.Count - 1] := sl[sl.Count - 1] + 'pvNone';
        pvTop: sl[sl.Count - 1] := sl[sl.Count - 1] + 'pvTop';
        pvCenter: sl[sl.Count - 1] := sl[sl.Count - 1] + 'pvCenter';
        pvBottom: sl[sl.Count - 1] := sl[sl.Count - 1] + 'pvBottom';
      end;
    end;
    if ttBkgColor in whole_style.tags then
      sl.Add(Format('        BkgColor: $%.8x', [whole_style.bkg_color]));
  end;}
end;

procedure TSubtitlesParser.clear(total: boolean);

  procedure clear_item(var s: TSubtitlesStyle);
  begin
    s.tags := [];
    s.fd.attr := [];
    s.position.hPosition := phNone;
    s.position.vPosition := pvNone;
  end;

begin
  ZeroMemory(@line_style, sizeof(TSubtitlesStyle));
  if total then
    ZeroMemory(@whole_style, sizeof(TSubtitlesStyle));
//    clear_item(whole_style);
end;

constructor TSubtitlesParser.Create;
begin
  do_log := false;
  clear(true);
end;

procedure TSubtitlesParser.get_whole_style(var fs: TSubtitlesStyle);
var
  fa: TFontAttrs;
begin
  if (whole_style.tags = []) then
    exit;

// czcionka
  if is_whole_font then
  begin
    if ttFontName in whole_style.tags then
      fs.fd.name := whole_style.fd.name;
    if ttFontSize in whole_style.tags then
      fs.fd.size := whole_style.fd.size;
    if ttFontCharset in whole_style.tags then
      fs.fd.charset := whole_style.fd.charset;
    if (ttFontStyle in whole_style.tags) then
    begin
      fa := fs.fd.attr;
      apply_font_style(faBold, whole_style.fd.attr, fa);
      apply_font_style(faItalic, whole_style.fd.attr, fa);
      apply_font_style(faUnderline, whole_style.fd.attr, fa);
      fs.fd.attr := fa;
    end;

  end;

// kolor czcionki
  if is_whole_font_color then
    fs.font_color := whole_style.font_color;

// kolor t³a
  if is_whole_bkg_color then
    fs.bkg_color := whole_style.bkg_color;

// pozycja na ekranie
  if is_whole_pos then
  begin
    if whole_style.position.hPosition <> phNone then
      fs.position.hPosition := whole_style.position.hPosition;
    if whole_style.position.vPosition <> pvNone then
      fs.position.vPosition := whole_style.position.vPosition;
  end;

  fs.tags := fs.tags + whole_style.tags;
end;

procedure TSubtitlesParser.get_line_style(var fs: TSubtitlesStyle);
var
  fa: TFontAttrs;
//  ss: TSubtitlesStyle;
begin
  if (line_style.tags = []) then
    exit;

// czcionka
// czcionka
  if is_line_font then
  begin
    if ttFontName in line_style.tags then
      fs.fd.name := line_style.fd.name;
    if ttFontSize in line_style.tags then
      fs.fd.size := line_style.fd.size;
    if ttFontCharset in line_style.tags then
      fs.fd.charset := line_style.fd.charset;
    if (ttFontStyle in line_style.tags) then
    begin
      fa := fs.fd.attr;
      apply_font_style(faBold, line_style.fd.attr, fa);
      apply_font_style(faItalic, line_style.fd.attr, fa);
      apply_font_style(faUnderline, line_style.fd.attr, fa);
      fs.fd.attr := fa;
    end;

  end;

// kolor czcionki
  if is_line_font_color then
    fs.font_color := line_style.font_color;

// kolor t³a
  if is_line_bkg_color then
    fs.bkg_color := line_style.bkg_color;

// pozycja na ekranie
  if is_line_pos then
  begin
    if line_style.position.hPosition <> phNone then
      fs.position.hPosition := line_style.position.hPosition;
    if line_style.position.vPosition <> pvNone then
      fs.position.vPosition := line_style.position.vPosition;
  end;

  fs.tags := fs.tags + line_style.tags;

{  sl.Add('      get_current_style:');
  if ttFontName in ss.tags then
    sl.Add(Format('        FontName: %s', [ss.fd.name]));
  if ttFontSize in ss.tags then
    sl.Add(Format('        FontSize: %d', [ss.fd.size]));
  if ttFontColor in ss.tags then
    sl.Add(Format('        FontColor: $%.8x', [ss.font_color]));
  if ttFontCharset in ss.tags then
  begin
    sl.Add('        FontCharset: ');
//      for i := 0 to 18 do
//        if Charsets[i].value = ss.charset then
//          sl[sl.Count - 1] := sl[sl.Count - 1] + Charsets[i].name;
  end;
  if (ttFontStyle in ss.tags) or (ttHatakFontStyle in ss.tags) then
  begin
    sl.Add('        FontStyle: ');
    if faBold in ss.fd.attr then
      sl[sl.Count - 1] := sl[sl.Count - 1] + 'fsBold, ';
    if faItalic in ss.fd.attr then
      sl[sl.Count - 1] := sl[sl.Count - 1] + 'fsItalic, ';
    if faUnderline in ss.fd.attr then
      sl[sl.Count - 1] := sl[sl.Count - 1] + 'fsUnderline, ';
  end;
  if (ttPosition in ss.tags) or (ttHatakPosition in ss.tags) then
  begin
    sl.Add('        Position: ');
    case ss.position.hPosition of
      phNone: sl[sl.Count - 1] := sl[sl.Count - 1] + 'phNone,';
      phLeft: sl[sl.Count - 1] := sl[sl.Count - 1] + 'phLeft,';
      phCenter: sl[sl.Count - 1] := sl[sl.Count - 1] + 'phCenter,';
      phRight: sl[sl.Count - 1] := sl[sl.Count - 1] + 'phRight,';
    end;
    case ss.position.vPosition of
      pvNone: sl[sl.Count - 1] := sl[sl.Count - 1] + 'pvNone';
      pvTop: sl[sl.Count - 1] := sl[sl.Count - 1] + 'pvTop';
      pvCenter: sl[sl.Count - 1] := sl[sl.Count - 1] + 'pvCenter';
      pvBottom: sl[sl.Count - 1] := sl[sl.Count - 1] + 'pvBottom';
    end;
  end;
  if ttBkgColor in ss.tags then
    sl.Add(Format('        BkgColor: $%.8x', [ss.bkg_color]));}
end;

function TSubtitlesParser.is_bkg_color(var ss: TSubtitlesStyle): boolean;
begin
  Result := ttBkgColor in ss.tags;
end;

function TSubtitlesParser.is_font_color(var ss: TSubtitlesStyle): boolean;
begin
  Result := ttFontColor in ss.tags;
end;

function TSubtitlesParser.is_font(var ss: TSubtitlesStyle): boolean;
begin
  Result :=
    (ttFontName in ss.tags) or
    (ttFontSize in ss.tags) or
    (ttFontCharset in ss.tags) or
    (ttFontStyle in ss.tags) or
    (ttHatakFontStyle in ss.tags);
end;

function TSubtitlesParser.is_font_size(var ss: TSubtitlesStyle): boolean;
begin
  Result :=
    (ttFontSize in ss.tags);
end;

function TSubtitlesParser.is_pos(var ss: TSubtitlesStyle): boolean;
begin
  Result :=
    (ttPosition in ss.tags) or
    (ttHatakPosition in ss.tags) or
    (ttCoordinate in ss.tags);
end;

function TSubtitlesParser.is_line_bkg_color: boolean;
begin
  Result := is_bkg_color(line_style);
end;

function TSubtitlesParser.is_line_font_color: boolean;
begin
  Result := is_font_color(line_style);
end;

function TSubtitlesParser.is_line_font: boolean;
begin
  Result := is_font(line_style);
end;

function TSubtitlesParser.is_line_font_size: boolean;
begin
  Result := is_font_size(line_style);
end;

function TSubtitlesParser.is_line_pos: boolean;
begin
  Result := is_pos(line_style);
end;

function TSubtitlesParser.is_whole_bkg_color: boolean;
begin
  Result := is_bkg_color(whole_style);
end;

function TSubtitlesParser.is_whole_font_color: boolean;
begin
  Result := is_font_color(whole_style);
end;

function TSubtitlesParser.is_whole_font: boolean;
begin
  Result := is_font(whole_style);
end;

function TSubtitlesParser.is_whole_font_size: boolean;
begin
  Result := is_font_size(whole_style);
end;

function TSubtitlesParser.is_whole_pos: boolean;
begin
  Result := is_pos(whole_style);
end;

end.
