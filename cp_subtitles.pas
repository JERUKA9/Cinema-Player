unit cp_subtitles;

interface

uses
  Windows, SysUtils, Classes, Forms, Graphics, global_consts, commctrl,
  cp_CinemaEngine, subtitles_header, subtitles_style;

type
  TGetOneSubtitle = function (tempSubtitles: TStringList;
    var i: integer; var Subtitle: string; var Start, Stop: double): boolean of object;

/// Klasa TSubtitles
  TSubtitles = class(TObject)
  private
    FDeltaTime: double;
    FLoading: boolean;

    FRescaleBeginLine,
    FRescaleEndLine: integer;
    FRescaleFromTime,
    FRescaleToTime: double;
    FRescaleAfterFromTime,
    FRescaleAfterToTime: double;

    FNewFPS: double;

    FDeltaTimeChanged: TNotifyEvent;
    FIsEdited: boolean;
    FFPS: double;
    FSubtitleType: TSubtitleType;
    FViewer: THandle;
    DinamicTimeFrom,
    DinamicTimeTo: integer;
    GetOneSubtitle: TGetOneSubtitle;
    Items: TStringList;

    FFileName: string;
    FOnNeedRefresh: TNotifyevent;

    _ssa_event_detected: boolean;
    _ssa_event_format: string;

    function GetMDVDLine(tempSubtitles: TStringList; var i: integer;
      var Subtitle: string; var Start, Stop: double): boolean;
    function GetHATAKLine(tempSubtitles: TStringList; var i: integer;
      var Subtitle: string; var Start, Stop: double): boolean;
    function GetLRCLine(tempSubtitles: TStringList; var i: integer;
      var Subtitle: string; var Start, Stop: double): boolean;
    function GetMPL1Line(tempSubtitles: TStringList; var i: integer;
      var Subtitle: string; var Start, Stop: double): boolean;
    function GetMPL2Line(tempSubtitles: TStringList; var i: integer;
      var Subtitle: string; var Start, Stop: double): boolean;
    function GetMPL3Line(tempSubtitles: TStringList; var i: integer;
      var Subtitle: string; var Start, Stop: double): boolean;
    function GetTIMELine(tempSubtitles: TStringList; var i: integer;
      var Subtitle: string; var Start, Stop: double): boolean;
    function GetTMPLine(tempSubtitles: TStringList; var i: integer;
      var Subtitle: string; var Start, Stop: double): boolean;
    function GetSRTLine(tempSubtitles: TStringList; var i: integer;
      var Subtitle: string; var Start, Stop: double): boolean;
    function GetSSALine(tempSubtitles: TStringList; var i: integer;
      var Subtitle: string; var Start, Stop: double): boolean;
    procedure DetectSubtitlesType(const tempSubtitles: TStringList);
    procedure SetDeltaTime(const Value: double);
    function SaveSubtitles(const FileName: string; FileType: TSubtitleType): boolean;
    function GetChanged: boolean;
    function GetCount: integer;
    function GetSubtitleLength(s: PChar): integer;
  public
    default_style: TSubtitlesParser;
    is_default_style: boolean;
    constructor Create(AViewer: THandle = 0);
    destructor Destroy; override;


    function FindCurrentText(CurrentTime: double; bFindNearest: boolean = false): integer;
    function FindPrevError(Index: integer): integer;
    function FindNextError(Index: integer): integer;
//    function IsFaultless: boolean;
    procedure LoadFromFile(const FName: string; var isFaultless: boolean);
    procedure ReloadFile;
    procedure RefreshViewer;
    procedure SaveToFile(const FileName: string); overload;
    procedure SaveToFile(const FileName: string; FileType: TSubtitleType); overload;

    procedure AddItem(Text: string; Data: PSubtitleData; Index: integer = -1);
    procedure Clear;
    procedure ChangeFPS(NewFPS: double);
    procedure Delete(Index: integer);
    procedure SetNotChanged;
    procedure GetRescaleParams(var FB, TB, FA, TA: double);
    procedure SetRescaleFrom(Index: integer);
    procedure SetRescaleTo(Index: integer);
    procedure GetFPS(var FPS, NewFPS: double);
    function GetSubtitle(Index: integer): string;
    function GetSubtitleStart(Index: integer): double;
    function GetSubtitleAbsoleteStart(Index: integer): double;
    function GetSubtitleStop(Index: integer): double;
    function GetSubtitleAbsoletStop(Index: integer): double;
    procedure Rescale(FBTime, TBTime, FATime, TATime: double);
    procedure SetSubtitle(Index: integer; NewText: string);
    procedure SetSubtitleStart(Index: integer; NewTime: double);
    procedure SetSubtitleStop(Index: integer; NewTime: double);
    procedure ResetDynamic;

    class function stripTagsFromSubtitle(subtitle: PChar): string;

    property Changed: boolean read GetChanged;
    property Count: integer read GetCount;
    property DeltaTime: double read FDeltaTime write SetDeltaTime;
    property FileName: string read FFileName;
    property Loading: boolean read FLoading;
//    property FPS: double read FFPS;
    property OnDeltaTimeChange: TNotifyEvent read FDeltaTimeChanged write FDeltaTimeChanged;
    property OnNeedRefresh: TNotifyevent read FOnNeedRefresh write FOnNeedRefresh;
    property SubtitleType: TSubtitleType read FSubtitleType;
    property Viewer: THandle read FViewer write FViewer;
  end;

var
  Subtitles: TSubtitles;

implementation

uses
  main, language, cp_utils, zb_sys_env, settings_header;

{ TSubtitles }

procedure TSubtitles.SaveToFile(const FileName: string);
var
  i: integer;
  RescaledStart: array of double;
  RescaledStop: array of double;
begin
  if SaveSubtitles(FileName, SubtitleType) then
    try
      SetLength(RescaledStart, Items.Count);
      SetLength(RescaledStop, Items.Count);
      for i := 0 to Items.Count - 1 do
      begin
        RescaledStart[i] := GetSubtitleStart(i);
        RescaledStop[i] := GetSubtitleStop(i);
      end;

      SetNotChanged;

      for i := 0 to Items.Count - 1 do
      begin
        PSubtitleData(Items.Objects[i]).Start := RescaledStart[i];
        PSubtitleData(Items.Objects[i]).Stop := RescaledStop[i];
      end;
    finally
      RescaledStart := nil;
      RescaledStop := nil;
      RefreshViewer;
    end;
end;

procedure TSubtitles.DetectSubtitlesType(const tempSubtitles: TStringList);
var
  Text: string;
  Start, Stop: double;
  i: integer;
  x: TSubtitleType;
begin
  for x := Low(TSubtitleType) to High(TSubtitleType) do
  begin
    FSubtitleType := x;
    case x of
      stSRT: GetOneSubtitle := GetSRTLine;
      stMDVD: GetOneSubtitle := GetMDVDLine;
      stHATAK: GetOneSubtitle := GetHATAKLine;
      stLRC: GetOneSubtitle := GetLRCLine;
      stMPL1: GetOneSubtitle := GetMPL1Line;
      stMPL2: GetOneSubtitle := GetMPL2Line;
      stMPL3: GetOneSubtitle := GetMPL3Line;
      stTIME: GetOneSubtitle := GetTIMELine;
      stTMP: GetOneSubtitle := GetTMPLine;
    else
      GetOneSubtitle := nil;
      FSubtitleType := stUnknown;
      exit;
    end;

    i := 0;
    while (i < 15) and (i < (tempSubtitles.Count)) do
    begin
      if (Trim(tempSubtitles[i]) <> '') and
         GetOneSubtitle(tempSubtitles, i, Text, Start, Stop) then
        exit;
      inc(i);
    end;
  end;
end;

procedure TSubtitles.Clear;
var
  i: integer;
begin
  ResetDynamic;
  SetNotChanged;

  for i := 0 to Items.Count - 1 do
  begin
    Dispose(PSubtitleData(Items.Objects[i]));
//    Items.Objects[i] := nil;
  end;
  ListView_SetItemCountEx(FViewer, 0, LVSICF_NOINVALIDATEALL);
  Items.Clear;
//  RefreshViewer;
  FFileName := '';
  default_style.clear(true);
  is_default_style := false;
end;


constructor TSubtitles.Create(AViewer: THandle);
begin
  Items := TStringList.Create;
  default_style := TSubtitlesParser.Create;
  default_style.do_log := true;
  is_default_style := false;
  GetOneSubtitle := nil;
  DeltaTime := 0;
  FViewer := AViewer;
  FIsEdited := false;
  ResetDynamic;

  FRescaleBeginLine := -1;
  FRescaleEndLine := -1;
end;

destructor TSubtitles.Destroy;
begin
  Clear;
  Items.Free;
  default_style.Free;
  inherited;
end;

function TSubtitles.FindCurrentText(CurrentTime: double; bFindNearest: boolean): integer;
const
  dinamic_tolerancy: double = 2.0;
var
  TempTime: double;

  function GetDisplayTime(Index: integer): double;
  var
    Len: integer;
  begin
    Len := PSubtitleData(Items.Objects[Index]).Length;// GetItemLength(Index);
    Result := (config.SubAutoIncTime * Len + config.SubAutoConstTime) * Len + config.SubAutoMinTime;
    if Result > config.SubAutoMaxTime then
      Result := config.SubAutoMaxTime;
  end;

  function GetDinTimeStart(Index: integer): double;
  var
    i: integer;
    curr_displaytime, next_start: double;
  begin
    if (Index > DinamicTimeFrom) and (Index <= DinamicTimeTo) then
    begin
      Result := GetSubtitleStart(DinamicTimeFrom);

      i := DinamicTimeFrom;
      repeat
        curr_displaytime := GetDisplayTime(i);
        next_start := GetSubtitleStart(i + 1);
        if (next_start > -1) and ((next_start + dinamic_tolerancy) < (Result + curr_displaytime)) then
          Result := next_start + dinamic_tolerancy
        else
          Result := Result + curr_displaytime;
        inc(i);
      until i >= Index;
    end
    else
    begin
      Result := GetSubtitleStart(Index);
    end;
  end;

  function GetDinTimeStop(Index: integer; Reset: boolean = false): double;
  var
    Start, DinamicCalc : double;
    curr_displaytime, next_start: double;
  begin
    Start := GetDinTimeStart(Index);

    if config.AutoTextDelay then
    begin
      Result := GetDisplayTime(Index);

      if DinamicTimeFrom <> -1 then
      begin
        if ((Index > DinamicTimeTo) or (Index < DinamicTimeFrom)) and Reset then
          ResetDynamic;
      end
      else
        if Index < (Items.Count - 1) then
        begin
          curr_displaytime := Result;
          next_start := GetSubtitleStart(Index + 1);

          if (Start + curr_displaytime) > next_start then
          begin
            DinamicTimeFrom := Index;
            DinamicCalc := 0;
            repeat
              curr_displaytime := GetDisplayTime(Index);
              next_start := GetSubtitleStart(Index + 1);
              if ((next_start + dinamic_tolerancy) < (Start + DinamicCalc + curr_displaytime)) then
                DinamicCalc := next_start - Start + dinamic_tolerancy
              else
                DinamicCalc := DinamicCalc + curr_displaytime;
              DinamicTimeTo := Index;
              inc(Index);
            until (Index = Items.Count - 1) or ((Start + DinamicCalc) <= next_start);
          end;
        end;
    end
    else
    begin
      Result := GetSubtitleStop(Index);
    end;
  end;

  function FindText(BeginLine, EndLine: integer; CurrentTime: double): integer;
  var
    MiddleLine: integer;
    CurrentLine: integer;
  begin
//sl.Add(Format('FindText(BeginLine: %d; EndLine: %d', [BeginLine, EndLine]));
    if (EndLine - BeginLine) > 1 then
    begin
      MiddleLine := BeginLine + (EndLine - BeginLine) div 2;
      if CurrentTime < GetDinTimeStart(MiddleLine) then
      begin
        Result := FindText(BeginLine, MiddleLine, CurrentTime);
      end
      else
      begin
        Result := FindText(MiddleLine, EndLine, CurrentTime);
      end;
    end
    else
    begin
      if CurrentTime <= GetDinTimeStart(EndLine) then
        CurrentLine := BeginLine
      else
        CurrentLine := EndLine;

      if (CurrentTime < (GetDinTimeStart(CurrentLine) + GetDinTimeStop(CurrentLine, true))) or bFindNearest then
      begin
        Result := CurrentLine;
      end
      else
        Result := -1;
    end;
  end;

begin
  TempTime := CurrentTime + RenderAhead;
  if (Items.Count = 0) or
     (TempTime < GetDinTimeStart(0)) or
     (TempTime > (GetDinTimeStart(Items.Count - 1) + GetDinTimeStop(Items.Count - 1))) then
  begin
    ResetDynamic;
    Result := -1;
  end
  else
  begin
    Result := FindText(0, Items.Count - 1, TempTime);
  end;
end;

function TSubtitles.GetMDVDLine(tempSubtitles: TStringList;
  var i: integer; var Subtitle: string; var Start, Stop: double): boolean;
var
  tempLine: PChar;
  tempStart, tempStop: cardinal;
  CharCount: byte;
  tmp: PChar;
  a, b: boolean;
begin
  Result := false;
  tempLine := PChar(tempSubtitles[i]);
  if (i = 0) and (StrPos(tempLine, '{DEFAULT}{}') = tempLine) then
  begin
    inc(tempLine, 12);
    default_style.parse(tempLine, tmp, a, b, true);
    is_default_style := a or b;
  end
  else
  begin
    if ScanChar(tempLine, '{') then                        // {
      if ScanNumber(tempLine, tempStart, CharCount) then   // Start
        if ScanChar(tempLine, '}') then                    // }
          if ScanChar(tempLine, '{') then                  // {
          begin
            ScanNumber(tempLine, tempStop, CharCount);     // Stop
            if ScanChar(tempLine, '}') then                // }
            begin
              tempLine := ScanBlanks(tempLine);
              Subtitle := Copy(tempLine, 1, MaxInt);
              Start := tempStart / FFPS;
              Stop := tempStop / FFPS;
              Result := true;
            end;
          end;
  end;
end;

function TSubtitles.GetHATAKLine(tempSubtitles: TStringList;
  var i: integer; var Subtitle: string; var Start, Stop: double): boolean;
var
  tempLine: PChar;
  CharCount: byte;
  h1, m1, s1, d1: cardinal;
  h2, m2, s2, d2: cardinal;

  procedure ChangeString(var s: string; from_str, to_str: string);
  var
    i: integer;
  begin
    repeat
      i := Pos(from_str, s);
      if i = 0 then
        exit;
      s := Copy(s, 1, i - 1) + to_str + Copy(s, i + Length(from_str), MaxInt);
    until false;
  end;

begin
  Result := false;
  tempLine := PChar(tempSubtitles[i]);
  if ScanChar(tempLine, '{') then                        // {
    if ScanNumber(tempLine, h1, CharCount) then          // h
    if ScanChar(tempLine, ':') then                      // :
    if ScanNumber(tempLine, m1, CharCount) then          // m
    if ScanChar(tempLine, ':') then                      // :
    if ScanNumber(tempLine, s1, CharCount) then          // s
    begin
      tempLine := ScanBlanks(tempLine);
      if (Length(tempLine) > 0) and (tempLine[0] = ',') then // ,
      begin
        inc(tempLine);
        ScanNumber(tempLine, d1, CharCount);             // d
      end
      else
        d1 := 0;

      if ScanChar(tempLine, '-') then                    // -

      if ScanNumber(tempLine, h2, CharCount) then        // h
      if ScanChar(tempLine, ':') then                    // :
      if ScanNumber(tempLine, m2, CharCount) then        // m
      if ScanChar(tempLine, ':') then                    // :
      if ScanNumber(tempLine, s2, CharCount) then        // s
      begin
        tempLine := ScanBlanks(tempLine);
        if (Length(tempLine) > 0) and (tempLine[0] = ',') then // ,
        begin
          inc(tempLine);
          ScanNumber(tempLine, d2, CharCount);           // d
        end
        else
          d2 := 0;
        if ScanChar(tempLine, '}') then                  // }
          begin
            tempLine := ScanBlanks(tempLine);
            Subtitle := Copy(tempLine, 1, MaxInt);
            Start := ((((h1 * 60) + m1) * 60 + s1) + d1 / 1000);
            Stop := ((((h2 * 60) + m2) * 60 + s2) + d2 / 1000);
            Result := true;
          end;
      end;
    end;
end;

function TSubtitles.GetLRCLine(tempSubtitles: TStringList;
  var i: integer; var Subtitle: string; var Start, Stop: double): boolean;
var
  tempLine: PChar;
  CharCount: byte;
  m, s: cardinal;
begin
  Result := false;
  tempLine := PChar(tempSubtitles[i]);
  if ScanChar(tempLine, '[') then                        // [
    if ScanNumber(tempLine, m, CharCount) then           // mm
      if ScanChar(tempLine, ':') then                    // :
        if ScanNumber(tempLine, s, CharCount) then       // ss
          if ScanChar(tempLine, ']') then                // ]
          begin
            tempLine := ScanBlanks(tempLine);
            if (m <> 0) or (s <> 0) then
            begin
              Subtitle := Copy(tempLine, 1, MaxInt);
              Start := (m * 60) + s;
              Stop := 0;
              Result := true;
            end;
          end;
end;

function TSubtitles.GetMPL1Line(tempSubtitles: TStringList;
  var i: integer; var Subtitle: string; var Start, Stop: double): boolean;
var
  tempLine: PChar;
  tempStart, tempStop: cardinal;
  CharCount: byte;
begin
  Result := false;
  tempLine := PChar(tempSubtitles[i]);
  if ScanNumber(tempLine, tempStart, CharCount) then       // Start
    if ScanChar(tempLine, ',') then                        // ,
      if ScanNumber(tempLine, tempStop, CharCount) then    // Stop
        if ScanChar(tempLine, ',') then                    // ,
        begin
          Stop := tempStop / 10;
          ScanNumber(tempLine, tempStop, CharCount);       // 0
          ScanChar(tempLine, ',');                         // ,
          tempLine := ScanBlanks(tempLine);
          Subtitle := Copy(tempLine, 1, MaxInt);
          Start := tempStart / 10;
          Result := true;
        end;
end;

function TSubtitles.GetMPL2Line(tempSubtitles: TStringList;
  var i: integer; var Subtitle: string; var Start, Stop: double): boolean;
var
  tempLine: PChar;
  tempStart, tempStop: cardinal;
  CharCount: byte;
begin
  Result := false;
  tempLine := PChar(tempSubtitles[i]);
  if ScanChar(tempLine, '[') then                        // [
    if ScanNumber(tempLine, tempStart, CharCount) then   // Start
      if ScanChar(tempLine, ']') then                    // ]
        if ScanChar(tempLine, '[') then                  // [
        begin
          ScanNumber(tempLine, tempStop, CharCount);     // Stop
          if ScanChar(tempLine, ']') then                // ]
          begin
            tempLine := ScanBlanks(tempLine);
            Subtitle := Copy(tempLine, 1, MaxInt);
            Start := tempStart / 10;
            Stop := tempStop / 10;
            Result := true;
          end;
        end;
end;

function TSubtitles.GetMPL3Line(tempSubtitles: TStringList; var i: integer;
  var Subtitle: string; var Start, Stop: double): boolean;
var
  tmp, line: PChar;
  a, b: boolean;
begin
  Result := false;
  if (i = 0) then
  begin
    line := PChar(tempSubtitles[i]);
    if (StrPos(line, '[DEFAULT][]') = line) then
    begin
      inc(line, 12);
      default_style.parse(Line, tmp, a, b, true);
      is_default_style := a or b;
      exit;
    end;
  end;
  GetMPL2Line(tempSubtitles, i, Subtitle, Start, Stop);
end;

function TSubtitles.GetSRTLine(tempSubtitles: TStringList;
  var i: integer; var Subtitle: string; var Start, Stop: double): boolean;
type
  TPartSRTLine = (pslNull, pslNumber, pslTimes, pslSubtitle);

var
  tempLine: PChar;
  tempStart, tempStop: cardinal;
  CharCount: byte;
  LastLineType: TPartSRTLine;

  function GetPartSRTLine(CheckSubtitle: string; var CheckStart, CheckStop: cardinal): TPartSRTLine;
  var
    CheckLine: PChar;

    function ScanTimeLine(var TimeLine: PChar; var TimeStart, TimeStop: cardinal): boolean;

      function ScanTime(var TimeLine: PChar; var Time: cardinal): boolean;
      var
        h, m, s, d: cardinal;
      begin
        Result := false;
        if ScanNumber(CheckLine, h, CharCount) then      // h
        if ScanChar(CheckLine, ':') then                 // :
        if ScanNumber(CheckLine, m, CharCount) then      // m
        if ScanChar(CheckLine, ':') then                 // :
        if ScanNumber(CheckLine, s, CharCount) then      // s
        begin
          CheckLine := ScanBlanks(CheckLine);
          if (CheckLine[0] = '.') or
             (CheckLine[0] = ',') then                   // ,
            inc(CheckLine);
          if ScanNumber(CheckLine, d, CharCount) then    // d
            //if ((m <> 0) or (s <> 0) or (h <> 0) or (d <> 0)) and (m < 60) and (s < 60) then
            begin
              Time := (((h * 60) + m) * 60 + s) * 1000 + d;
              Result := true;
            end;
        end;
      end;

    begin
      Result := false;
      if ScanTime(CheckLine, CheckStart) then               // h1:m:s,d
        if ScanChar(CheckLine, '-') then
        if ScanChar(CheckLine, '-') then
        if ScanChar(CheckLine, '>') then                    // -->
          if ScanTime(CheckLine, CheckStop) then            // h1:m:s,d
            Result := true;
    end;

  begin
    Result := pslNull;
    CheckLine := PChar(CheckSubtitle);
    if ScanTimeLine(CheckLine, CheckStart, CheckStop) then  // h:m:s,d --> h:m:s,d
      Result := pslTimes
    else
    begin
      CheckLine := PChar(CheckSubtitle);
      if ScanNumber(CheckLine, CheckStart, CharCount) then    // N numer
      begin
        if Trim(CheckLine) = '' then
          Result := pslNumber;
      end;
      if Result = pslNull then
      begin
        CheckLine := PChar(CheckSubtitle);
        if Trim(CheckSubtitle) = '' then                           // pusta linia
          Result := pslNull
        else
          Result := pslSubtitle;                                  // napis
      end;
    end;
  end;

begin
  Result := false;
  tempLine := PChar(tempSubtitles[i]);
  if GetPartSRTLine(tempLine, tempStart, tempStop) = pslNumber then
  begin
    repeat
      inc(i);
    until (i = tempSubtitles.Count) or (Trim(tempSubtitles[i]) <> '');
    if i < tempSubtitles.Count then
    begin
      tempLine := PChar(tempSubtitles[i]);
      if GetPartSRTLine(tempLine, tempStart, tempStop) = pslTimes then
      begin
        Start := tempStart / 1000;
        Stop := tempStop/ 1000;
        Subtitle := '';
        repeat
          repeat
            inc(i);
          until (i = tempSubtitles.Count) or (Trim(tempSubtitles[i]) <> '');
          if i < tempSubtitles.Count then
          begin
            tempLine := PChar(tempSubtitles[i]);
            LastLineType := GetPartSRTLine(tempLine, tempStart, tempStop);
            if LastLineType = pslSubtitle then
            begin
              if Subtitle <> '' then
                Subtitle := Subtitle + '|';
              Subtitle := Subtitle + tempLine;
              Result := true;
            end;
          end;
          if LastLineType = pslNumber then
            dec(i)
        until (i >= tempSubtitles.Count) or (LastLineType = pslNumber);
      end;
    end;
  end
end;

function TSubtitles.GetTMPLine(tempSubtitles: TStringList;
  var i: integer; var Subtitle: string; var Start, Stop: double): boolean;
var
  tempLine: PChar;
  CharCount: byte;
  h, m, s: cardinal;
begin
  Result := false;
  tempLine := PChar(tempSubtitles[i]);
  if ScanNumber(tempLine, h, CharCount) then             // h
    if ScanChar(tempLine, ':') then                      // :
      if ScanNumber(tempLine, m, CharCount) then         // m
        if ScanChar(tempLine, ':') then                  // :
          if ScanNumber(tempLine, s, CharCount) then     // s
          begin
            tempLine := ScanBlanks(tempLine);
            if (tempLine[0] = ':') or (tempLine[0] = '=') then
              inc(tempLine);
            tempLine := ScanBlanks(tempLine);
            if ((m <> 0) or (s <> 0) or (h <> 0)) and (m < 60) and (s < 60) then
            begin
              Subtitle := Copy(tempLine, 1, MaxInt);
              Start := ((h * 60) + m) * 60 + s;
              Stop := 0;
              Result := true;
            end;
          end;
end;

function TSubtitles.GetTIMELine(tempSubtitles: TStringList;
  var i: integer; var Subtitle: string; var Start, Stop: double): boolean;
var
  tempSubtitle: string;
  tempStart: double;
//  IsGoodLine: boolean;

  function GetOneLine(tempSubtitle: string; var Subtitle: string;
    var Start: double): boolean;
  var
    tempLine: PChar;
    CharCount: byte;
    h, m, s, l: cardinal;
  begin
    Result := false;
    tempLine := PChar(tempSubtitle);
    if ScanNumber(tempLine, h, CharCount) then             // h
      if ScanChar(tempLine, ':') then                      // :
        if ScanNumber(tempLine, m, CharCount) then         // m
          if ScanChar(tempLine, ':') then                  // :
            if ScanNumber(tempLine, s, CharCount) then     // s
              if ScanChar(tempLine, ',') then              // ,
                if ScanNumber(tempLine, l, CharCount) then // l
                  if ScanChar(tempLine, '=') then          // =
                    if ((m <> 0) or (s <> 0) or (h <> 0)) and (m < 60) and (s < 60) then
                    begin
                      Subtitle := Copy(tempLine, 1, MaxInt);
                      Start := ((h * 60) + m) * 60 + s;
                      Stop := 0;
                      Result := true;
                      exit;
                    end;
    repeat
      inc(i);
    until (i = tempSubtitles.Count) or (Trim(tempSubtitles[i]) <> '');
  end;

begin
  Result := false;
  Subtitle := '';
  Start := 0;
  Stop := 0;
  while (i < tempSubtitles.Count) and GetOneLine(tempSubtitles[i], tempSubtitle, tempStart) and
    ((Start = tempStart) or (Start = 0)) do    // ten sam czas co poprzednio, czyli kolejne linie jednego napisu
                                               // numer linii ignorujemy, bo nie jest istotny (powinno byc po kolei)
  begin
    Start := tempStart;
    if Subtitle <> '' then
      Subtitle := Subtitle + '|';
    Subtitle := Subtitle + tempSubtitle;
    Result := true;
    repeat
      inc(i);
    until (i = tempSubtitles.Count) or (Trim(tempSubtitles[i]) <> '');
  end;
end;

function TSubtitles.GetSSALine(tempSubtitles: TStringList; var i: integer;
  var Subtitle: string; var Start, Stop: double): boolean;

  function getTimePart(var p: PChar; var value: double): boolean;
  var
    CharCount: byte;
    h, m, s, ms: cardinal;
  begin
    Result := false;
    if ScanNumber(p, h, CharCount) then             // h
      if ScanChar(p, ':') then                      // :
        if ScanNumber(p, m, CharCount) then         // m
          if ScanChar(p, ':') then                  // :
            if ScanNumber(p, s, CharCount) then     // s
              if ScanChar(p, '.') then              // .
                if ScanNumber(p, ms, CharCount) then // ms
                begin
                  value := ((h * 60) + m) * 60 + s + ms / 100;
                  Result := true;
                end;
  end;

var
  line_: string;
  pline_: PChar;
  i_: integer;
begin
  Result := false;
  Subtitle := '';
  Start := 0;
  Stop := 0;
  if not _ssa_event_detected then
  begin
    while (i < (tempSubtitles.Count - 2)) and (LowerCase(Trim(tempSubtitles[i])) <> '[events]') do
      inc(i);
    inc(i);
    while (i < (tempSubtitles.Count - 1)) and (Trim(tempSubtitles[i]) = '') do
      inc(i);

    if i < (tempSubtitles.Count - 1) then
    begin
      _ssa_event_detected := true;
      line_ := LowerCase(Trim(tempSubtitles[i]));
      if Pos('format', line_) = 1 then
      begin
        inc(i);
        pline_ := PChar(line_);
// powinno byæ coœ takiego:
// Format: Marked, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text
        if ScanToChar(pline_, ':') then
        begin
          _ssa_event_format := ':';
          pline_ := ScanBlanks(pline_);
          while (pline_ <> '') and (pline_ <> 'text') do
          begin
            pline_ := ScanBlanks(pline_);

            if Pos('start', pline_) = 1 then
              _ssa_event_format := _ssa_event_format + '0'
            else
              if Pos('end', pline_) = 1 then
                _ssa_event_format := _ssa_event_format + '1';

            if ScanToChar(pline_, ',') then
            begin
              _ssa_event_format := _ssa_event_format + ',';
              inc(pline_);
            end;

            pline_ := ScanBlanks(pline_);
          end;
        end;
      end;
      while (i < tempSubtitles.Count) and (Trim(tempSubtitles[i]) = '') do
        inc(i);
    end;
  end;

  if _ssa_event_detected then
  begin
    line_ := Trim(tempSubtitles[i]);
    if Pos('dialogue', LowerCase(line_)) <> 1 then
      exit;
    pline_ := ScanBlanks(PChar(line_));
    i_ := 1;
    while (i_ <= Length(_ssa_event_format)) and (pline_ <> '') do
    begin
      if _ssa_event_format[i_] = '0' then
      begin
        getTimePart(pline_, Start);
        inc(i_);
      end
      else
        if _ssa_event_format[i_] = '1' then
        begin
          getTimePart(pline_, Stop);
          inc(i_);
        end;

      if ScanToChar(pline_, _ssa_event_format[i_]) then
        inc(pline_)
      else
        break;
      inc(i_);
    end;
    if i_ > Length(_ssa_event_format) then
    begin
      Subtitle := Copy(pline_, 1, MaxInt);
      for i_ := 1 to Length(pline_) - 1 do
        if (Subtitle[i_] = '\') and ((Subtitle[i_ + 1] = 'n') or (Subtitle[i_ + 1] = 'N')) then
        begin
          Subtitle[i_] := '|';
          Subtitle[i_ + 1] := ' ';
        end;
      Result := true;
    end;
  end;
end;

procedure TSubtitles.LoadFromFile(const FName: string; var isFaultless: boolean);
var
  i: integer;
  tempString: string;
  SubtitleData: PSubtitleData;
  slTemp: TStringList;
  Start, Stop, lastStart: double;
  tid: cardinal;
begin
  Clear;
  isFaultless := true;
  if FName <> '' then
  begin
    FLoading := true;
    Application.ProcessMessages;
    if frmCinemaPlayer.MyCinema.FPS = 1 then
      FFPS := config.DefaultFPS
    else
      FFPS := frmCinemaPlayer.MyCinema.FPS;
    lastStart := 0.0;

    slTemp := TStringList.Create;
    try
      slTemp.LoadFromFile(FName);

      tempString := LowerCase(ExtractFileExt(FName));
      if (tempString = '.ssa') or (tempString = '.ass') then
      begin
        FSubtitleType := stSSA;
        GetOneSubtitle := GetSSALine;
        _ssa_event_detected := false;
        _ssa_event_format := ':,0,1,,,,,,,';
      end
      else
        DetectSubtitlesType(slTemp);

      if FSubtitleType <> stUnknown then
      begin
        i := 0;
        while i < slTemp.Count do
        begin
          if (Trim(slTemp[i]) <> '') and
             GetOneSubtitle(slTemp, i, tempString, Start, Stop) then
          begin
            tempString := Trim(tempString);
            ScanCaret(PChar(tempString));
            if (lastStart <> Start) or (Items.Count = 0) then
            begin
              new(SubtitleData);
              SubtitleData^.Start := Start;
              Stop := Stop - Start;
              if Stop < 0 then
                Stop := 0;
              SubtitleData^.Stop := Stop;
              SubtitleData.Length := GetSubtitleLength(PChar(tempString));
              Items.AddObject(tempString, TObject(SubtitleData));
              lastStart := SubtitleData.Start;
              if (lastStart > Start) then
                isFaultless := false
            end
            else
              if lastStart = Start then
              begin
                Items[Items.Count - 1] := Items[Items.Count - 1] + #13 + tempString;
                inc(PSubtitleData(Items.Objects[Items.Count - 1]).Length, GetSubtitleLength(PChar(tempString)));
              end;
          end;
          inc(i);
        end;
      end
    finally
      slTemp.Free;
    end;

    FLoading := false;
  end;

  if Items.Count > 0 then
  begin
    FFileName := FName;
    frmCinemaPlayer.aOpenText.ImageIndex := iconOpenTextOn;
    frmCinemaPlayer.aOpenText.Hint := LangStor[LNG_OPENSUBTITLES] + #13 + FileName;
    config.Files[1].Text := FileName;
  end
  else
  begin
    FFileName := '';
    frmCinemaPlayer.aOpenText.ImageIndex := iconOpenTextOff;
    frmCinemaPlayer.aOpenText.Hint := LangStor[LNG_OPENSUBTITLES];
    config.Files[1].Text := '';
  end;

  RefreshViewer;
end;

procedure TSubtitles.RefreshViewer;
begin
  ListView_SetItemCountEx(FViewer, Items.Count, LVSICF_NOINVALIDATEALL);

(* do poprawy *)
  if Assigned(OnNeedRefresh) then
    OnNeedRefresh(Self);
end;

procedure TSubtitles.SetDeltaTime(const Value: double);
begin
  if (FDeltaTime <> Value) then
  begin
    FDeltaTime := Value;
    RefreshViewer;
    if Assigned(OnDeltaTimeChange) then
      OnDeltaTimeChange(Self);
  end;
end;

function TSubtitles.SaveSubtitles(const FileName: string;
  FileType: TSubtitleType): boolean;
var
  SL: TStringList;
  i: integer;
  _start, _stop: double;
  linia: string;

  procedure SetMDVDLine(const Subtitle: string; const Start, Stop: double);
  var
    tempStart, tempStop: cardinal;
    tempSubtitle: string;
  begin
    tempSubtitle := Subtitle;
    tempStart := round(Start * FFPS);
    tempStop := round(Stop * FFPS);
    while Pos(#13, tempSubtitle) > 0 do
      tempSubtitle[Pos(#13, tempSubtitle)] := '|';
    SL.Add(Format('{%d}{%d}%s', [tempStart, tempStop, tempSubtitle]));
  end;

  procedure SetHATAKLine(const Subtitle: string; const Start, Stop: double);
  var
    tempStart,
    tempStop,
    tempSubtitle: string;
  begin
    tempStart := PrepareTime(Start, true, 3);
    tempStop := PrepareTime(Stop, true, 3);
    tempSubtitle := Subtitle;
    while Pos(#13, tempSubtitle) > 0 do
      tempSubtitle[Pos(#13, tempSubtitle)] := '|';
    SL.Add(Format('{%s-%s} %s', [tempStart, tempStop, tempSubtitle]));
  end;

  procedure SetLRCLine(const Subtitle: string; const Start, Stop: double);
  var
    tempStart: cardinal;
    tempSubtitle: string;
  begin
    tempStart := round(Start);
    tempSubtitle := Subtitle;
    while Pos(#13, tempSubtitle) > 0 do
      tempSubtitle[Pos(#13, tempSubtitle)] := '|';
    SL.Add(Format('[%d:%d]%s', [tempStart div 60, tempStart mod 60, tempSubtitle]));
  end;

  procedure SetMPL1Line(const Subtitle: string; const Start, Stop: double);
  var
    tempStart, tempStop: cardinal;
    tempSubtitle: string;
  begin
    tempStart := round(Start * 10);
    tempStop := round(Stop * 10);
    tempSubtitle := Subtitle;
    while Pos(#13, tempSubtitle) > 0 do
      tempSubtitle[Pos(#13, tempSubtitle)] := '|';
    SL.Add(Format('%d,%d,0,%s', [tempStart, tempStop, tempSubtitle]));
  end;

  procedure SetMPL2Line(const Subtitle: string; const Start, Stop: double);
  var
    tempStart, tempStop: cardinal;
    tempSubtitle: string;
  begin
    tempStart := round(Start * 10);
    tempStop := round(Stop * 10);
    tempSubtitle := Subtitle;
    while Pos(#13, tempSubtitle) > 0 do
      tempSubtitle[Pos(#13, tempSubtitle)] := '|';
    SL.Add(Format('[%d][%d]%s', [tempStart, tempStop, tempSubtitle]));
  end;

  procedure SetTIMELine(const Subtitle: string; const Start, Stop: double);
  var
    tempStart,
    tempSubtitle: string;
    Index: integer;
  begin
    tempStart := PrepareTime(Start, false);
    tempSubtitle := Subtitle;
    Index := 0;
    while Pos(#13, tempSubtitle) > 0 do
    begin
      SL.Add(Format('%s,%d=%s', [tempStart, Index, Copy(tempSubtitle, 1, Pos(#13, tempSubtitle) - 1)]));
      tempSubtitle := Copy(tempSubtitle, Pos(#13, tempSubtitle) + 1, MaxInt);
      inc(Index);
    end;
    SL.Add(Format('%s,%d=%s', [tempStart, Index, tempSubtitle]));
  end;

  procedure SetTMPLine(const Subtitle: string; const Start, Stop: double);
  var
    tempSubtitle: string;
  begin
    tempSubtitle := Subtitle;
    while Pos(#13, tempSubtitle) > 0 do
      tempSubtitle[Pos(#13, tempSubtitle)] := '|';
    SL.Add(Format('%s:%s', [PrepareTime(Start, false), tempSubtitle]));
  end;

  procedure SetSRTLine(const Subtitle: string; const i: integer; const Start, Stop: double);
  var
    tempStart, tempStop,
    tempSubtitle: string;
  begin
    tempStart := PrepareTime(Start, true);
    if tempStart[2] = ':' then
      tempStart := '0' + tempStart;

    tempStop := PrepareTime(Stop, true);
    if tempStop[2] = ':' then
      tempStop := '0' + tempStop;

    tempSubtitle := Subtitle;
    SL.Add(IntToStr(i + 1));
    SL.Add(Format('%s --> %s', [tempStart, tempStop]));
    while Pos(#13, tempSubtitle) > 0 do
    begin
      SL.Add(Copy(tempSubtitle, 1, Pos(#13, tempSubtitle) - 1));
      tempSubtitle := Copy(tempSubtitle, Pos(#13, tempSubtitle) + 1, MaxInt);
    end;
    SL.Add(tempSubtitle);
    SL.Add('');
  end;

begin
  Result := false;
  if FileType = stUnknown then
    exit;

  SL := TStringList.Create;
  try
    for i := 0 to Items.Count - 1 do
    begin
      _start := GetSubtitleStart(i);
      _stop := _start + GetSubtitleStop(i);

      linia := Items[i];

      // je¿eli formatem Ÿród³owym by³ MPL2 to nale¿y usun¹æ znak "/" z pocz¹tku ka¿dej linii
      if (FileType <> stMPL2) and (SubtitleType = stMPL2) then
      begin
        if linia[1] = '/' then
          System.Delete(linia, 1, 1);
        while Pos(#13'/', linia) > 0 do
          System.Delete(linia, Pos(#13'/', linia) + 1, 1);
      end;

      case FileType of
        stSRT:
          SetSRTLine(linia, i, _start, _stop);
        stMDVD:
          SetMDVDLine(linia, _start, _stop);
        stHATAK:
          SetHATAKLine(linia, _start, _stop);
        stLRC:
          SetLRCLine(linia, _start, _stop);
        stMPL1:
          SetMPL1Line(linia, _start, _stop);
        stMPL2:
          SetMPL2Line(linia, _start, _stop);
        stTIME:
          SetTIMELine(linia, _start, _stop);
        stTMP:
          SetTMPLine(linia, _start, _stop);
      end;
    end;
    SL.SaveToFile(FileName);
    Result := true;
  finally
    SL.Free;
  end;
end;

procedure TSubtitles.SaveToFile(const FileName: string; FileType: TSubtitleType);
begin
  SaveSubtitles(FileName, FileType);
end;

(*function TSubtitles.IsFaultless: boolean;
var
  i: integer;
begin
  Result := FIsFaultless;
  FIsFaultless := true;
{  Result := true;
  for i := 1 to Items.Count - 1 do
//    if GetSubtitleStart(i - 1) >= GetSubtitleStart(i) then
    if PSubtitleData(Items.Objects[i - 1]).Start >= PSubtitleData(Items.Objects[i]).Start then
    begin
      Result := false;
      break;
    end;}
end;
*)
function TSubtitles.FindNextError(Index: integer): integer;
var
  i: integer;
begin
  Result := -1;
  for i := Index to Subtitles.Items.Count - 2 do
    if GetSubtitleStart(i) >= GetSubtitleStart(i + 1) then
    begin
      Result := i + 1;
      exit;
    end;
end;

function TSubtitles.FindPrevError(Index: integer): integer;
var
  i: integer;
begin
  Result := -1;
  for i := Index downto 0 do
    if GetSubtitleStart(i) >= GetSubtitleStart(i + 1) then
    begin
      Result := i + 1;
      exit;
    end;
end;

function TSubtitles.GetSubtitleStart(Index: integer): double;
begin
  if (Index < 0) or (Index >= Items.Count) then
  begin
    Result := -1;
    exit;
  end;

  Result := PSubtitleData(Items.Objects[Index]).Start;
// Rescale
  if (Index >= FRescaleBeginLine) and (Index <= FRescaleEndLine) then
  begin
    Result := FRescaleAfterFromTime + (FRescaleAfterToTime - FRescaleAfterFromTime) *
      (Result - PSubtitleData(Items.Objects[FRescaleBeginLine]).Start) /
      (PSubtitleData(Items.Objects[FRescaleEndLine]).Start - PSubtitleData(Items.Objects[FRescaleBeginLine]).Start);
  end;
// FPS
  if FNewFPS <> 0 then
    Result := FFPS * Result / FNewFPS;
// Shift
  Result := Result - DeltaTime;
end;

function TSubtitles.GetSubtitleStop(Index: integer): double;
var
  StartTime: double;
begin
  if (Index < 0) or (Index >= Items.Count) then
  begin
    Result := -1;
    exit;
  end;

  if PSubtitleData(Items.Objects[Index]).Stop = 0 then
    Result := config.TextDelay
  else
    Result := PSubtitleData(Items.Objects[Index]).Stop;

  StartTime := GetSubtitleStart(Index);

  if (Index < (Items.Count - 1)) and
     ((StartTime + Result) > GetSubtitleStart(Index + 1)) then
      Result := GetSubtitleStart(Index + 1) - StartTime;
end;

procedure TSubtitles.SetSubtitleStart(Index: integer; NewTime: double);
var
  Value: double;
begin
  if (Index < 0) or (Index >= Items.Count) then
  begin
    exit;
  end;

// Shift
  Value := NewTime + DeltaTime;
// FPS
  if FNewFPS <> 0 then
    Value := FFPS * Value / FNewFPS;
// Rescale
  if (Index >= FRescaleBeginLine) and (Index <= FRescaleEndLine) then
    Value := PSubtitleData(Items.Objects[FRescaleBeginLine]).Start + (Value - FRescaleAfterFromTime) *
      (PSubtitleData(Items.Objects[FRescaleEndLine]).Start - PSubtitleData(Items.Objects[FRescaleBeginLine]).Start) /
      (FRescaleAfterToTime - FRescaleAfterFromTime);

  PSubtitleData(Items.Objects[Index]).Start := Value;

  FIsEdited := true;
end;

procedure TSubtitles.SetSubtitleStop(Index: integer; NewTime: double);
//var
//  Value: double;
begin
//  if PSubtitleData(Items.Objects[Index]).Stop = 0 then
//  begin
//    Result := GetSubtitleStart(Index) + config.TextDelay;
//    if (Index < (Items.Count - 1)) and
//       (Result > GetSubtitleStart(Index + 1)) then
//        Result := GetSubtitleStart(Index + 1);
//  end
//  else
  if (Index < 0) or (Index >= Items.Count) then
  begin
    exit;
  end;

  PSubtitleData(Items.Objects[Index]).Stop := NewTime;
end;

procedure TSubtitles.Rescale(FBTime, TBTime, FATime, TATime: double);
var
  i: integer;
  BL, EL: integer;
begin
  if (FBTime > 0) and (TBTime > 0) then
  begin
    for i := 0 to Items.Count - 1 do
      if GetSubtitleStart(i) >= FBTime then
      begin
        BL := i;
        break;
      end;

    for i := 0 to Items.Count - 1 do
      if GetSubtitleStart(i) >= TBTime then
      begin
        EL := i;
        break;
      end;
  end
  else
  begin
    BL := -1;
    EL := -1;
  end;

  FRescaleBeginLine := BL;
  FRescaleEndLine := EL;
  FRescaleFromTime := FBTime;
  FRescaleToTime := TBTime;
  FRescaleAfterFromTime := FATime;
  FRescaleAfterToTime := TATime;
  RefreshViewer;
end;

procedure TSubtitles.ChangeFPS(NewFPS: double);
begin
  FNewFPS := NewFPS;
  RefreshViewer;
end;

function TSubtitles.GetChanged: boolean;
begin
  Result := FIsEdited or (DeltaTime <> 0) or (FNewFPS <> 0) or
    ((FRescaleBeginLine <> -1) and (FRescaleEndLine <> -1));
end;

procedure TSubtitles.AddItem(Text: string; Data: PSubtitleData;
  Index: integer);
begin
  if Index = -1 then
    Index := Items.Count;

  if Index <= FRescaleBeginLine then
    inc(FRescaleBeginLine);

  if Index <= FRescaleEndLine then
    inc(FRescaleEndLine);

  Items.Insert(Index, Text);
  Items.Objects[Index] := TObject(Data);
  FIsEdited := true;
end;

function TSubtitles.GetCount: integer;
begin
  Result := Items.Count;
end;

function TSubtitles.GetSubtitle(Index: integer): string;
begin
  Result := Items[Index];
end;

procedure TSubtitles.SetSubtitle(Index: integer; NewText: string);
begin
  if (Index < 0) or (Index >= Items.Count) then
  begin
    exit;
  end;

  Items[Index] := NewText;
  PSubtitleData(Items.Objects[Index]).Length := GetSubtitleLength(PChar(NewText));
end;

procedure TSubtitles.Delete(Index: integer);
begin
  dispose(PSubtitleData(Items.Objects[Index]));
  Items.Delete(Index);

  if Index <= FRescaleEndLine then
    dec(FRescaleEndLine);

  if Index < FRescaleBeginLine then
    dec(FRescaleEndLine)
  else
    if Index = FRescaleBeginLine then
      inc(FRescaleEndLine);

  FIsEdited := true;
end;

procedure TSubtitles.GetRescaleParams(var FB, TB, FA, TA: double);
begin
  if FRescaleFromTime = 0 then
    FB := GetSubtitleStart(0)
  else
    FB := FRescaleFromTime;
  if FRescaleToTime = -1 then
    TB := GetSubtitleStart(Count - 1)
  else
    TB := FRescaleToTime;

  FA := FRescaleAfterFromTime;
  TA := FRescaleAfterToTime;
end;

procedure TSubtitles.GetFPS(var FPS, NewFPS: double);
begin
  FPS := FFPS;
  NewFPS := FNewFPS;
end;

procedure TSubtitles.ReloadFile;
var
  isFautless: boolean;
begin
  LoadFromFile(FileName, isFautless);
end;

procedure TSubtitles.SetRescaleFrom(Index: integer);
begin
  FRescaleFromTime := GetSubtitleStart(Index);
end;

procedure TSubtitles.SetRescaleTo(Index: integer);
begin
  FRescaleToTime := GetSubtitleStart(Index);
end;

procedure TSubtitles.SetNotChanged;
begin
  fIsEdited := false;
  FDeltaTime := 0;
  FNewFPS := 0;
  FRescaleBeginLine := -1;
  FRescaleEndLine := -1;
end;

function TSubtitles.GetSubtitleAbsoleteStart(Index: integer): double;
begin
  if (Index < 0) or (Index >= Items.Count) then
  begin
    Result := -1;
    exit;
  end;

  Result := PSubtitleData(Items.Objects[Index]).Start;
end;

function TSubtitles.GetSubtitleAbsoletStop(Index: integer): double;
begin
  if (Index < 0) or (Index >= Items.Count) then
  begin
    Result := -1;
    exit;
  end;

  if PSubtitleData(Items.Objects[Index]).Stop = 0 then
    Result := config.TextDelay
  else
    Result := PSubtitleData(Items.Objects[Index]).Stop;
end;

procedure TSubtitles.ResetDynamic;
begin
  DinamicTimeFrom := -1;
  DinamicTimeTo := -1;
end;

function TSubtitles.GetSubtitleLength(s: PChar): integer;
//var
//  stop, end_tag: PChar;
begin
  Result := Length(stripTagsFromSubtitle(s));
(*  Result := 0;
  stop := StrPos(s, #13);
  if stop = '' then
    stop := StrEnd(s);
  while (s < stop) and (s <> '') do
  begin
    if (s[0] = '/') then
      inc(s);

    if (s[0] = '[') then
      inc(s);

    while s[0] = '{' do
    begin
      end_tag := StrPos(s, '}');
      if (end_tag = nil) or (end_tag > stop) {or (s[2] <> ':')} then  // to nie jest tag
        break;
      inc(s, integer(end_tag - s) + 1);
    end;

    inc(Result, integer(stop - s));
    s := stop;
    if s <> '' then
      inc(s);

    stop := StrPos(s, #13);
    if stop = '' then
      stop := StrEnd(s);
  end;
  *)
end;

class function TSubtitles.stripTagsFromSubtitle(subtitle: PChar): string;

  function find_tag(var start, stop: PChar): boolean;
  var
    begin_tag, end_tag: PChar;
  begin
    Result := false;
    if (start[0] in ['/', '\', '_', '[']) then
    begin
      if (start[0] = '[') and ((stop - 1)[0] <> ']') and (StrPos(start, ']') <> nil) then
        exit;
      Result := true;
// niektóre tagi mog¹ wystapiæ tak¿e na koñcu linii
      if ((start[0] = (stop - 1)[0])) or ((start[0] = '[') and ((stop - 1)[0] = ']')) then
        dec(stop);
      inc(start);
      exit;
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
         (end_tag > stop) or (begin_tag < start) {or
         (begin_tag[2] <> ':')} then  // to nie jest tag
        exit;
      if (start[0] = '{') then
        start := end_tag + 1
      else
        stop := begin_tag;
    end;
  end;

var
  i: integer;
  start_pos, end_pos: PChar;
begin
  Result := '';
  start_pos := subtitle;
  end_pos := StrPos(start_pos, #13);
  if end_pos = nil then
    end_pos := StrEnd(start_pos);
// ltrim
  while (start_pos < end_pos) and (start_pos[0] = ' ') do
    inc(start_pos);
// rtrim
  while (start_pos < end_pos) and ((end_pos - 1)[0] = ' ') do
    dec(end_pos);

  while start_pos <> nil do
  begin
    while find_tag(start_pos, end_pos) do ;

    Result := Result + Copy(start_pos, 0, end_pos - start_pos) + #13;

    start_pos := StrPos(end_pos, #13);
    if start_pos <> nil then
    begin
      inc(start_pos);
      end_pos := StrPos(start_pos, #13);
      if end_pos = nil then
        end_pos := StrEnd(start_pos);
    end;
  end;
end;

initialization

  Subtitles := TSubtitles.Create;

finalization

  Subtitles.Free;

end.
