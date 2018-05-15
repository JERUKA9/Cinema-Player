unit subtitles_header;

interface

uses
  Classes, SysUtils, global_consts;

type
  TSubtitleType = (stSRT, stMDVD, stHATAK, stLRC, stMPL1, stMPL3, stMPL2, stTIME, stTMP, stSSA, stUnknown);

  TAntialiasing = (aaNone, aaCross, aaDiagonal, aaFull);

  TSubtitleData = record
    Start: double;
    Stop: double;
    Length: integer;
  end;
  PSubtitleData = ^TSubtitleData;

  TRenderMode =
  (
    rmFullRect,               // jeden prostok¹t na szerokoœæ okna
    rmClipRects,              // ka¿da linia w oddzielnym prostok¹cie
    rmOnlyText,               // tylko tekst
    rmThinBorder,             // tekst z cienk¹ obwódk¹
    rmThickBorder,            // tekst z grub¹ obwódk¹
    rmFatBorder);             // tekst z bardzo grub¹ obwódk¹

function PrepareTime(Secs: double; AddMiliSec: boolean = false;
  precision: integer = 3; delimiter1: char = ':'; delimiter2: char = ','): string;

function PrepareTimeParts(Secs: double; AddMiliSec: boolean = false): TTimeParts;

implementation

function PrepareTime(Secs: double; AddMiliSec: boolean;
  precision: integer; delimiter1: char; delimiter2: char): string;
var
  h, m, s, ms: integer;
  tempInt: integer;
  minus: boolean;
begin
  Secs := int(Secs * 1000) / 1000;
  minus := Secs < 0;
  if minus then
    Secs := Secs * -1;
  ms := round(frac(Secs) * 1000);
  if AddMiliSec then
    tempInt := round(int(Secs))
  else
    tempInt := round(Secs);
  s := tempInt mod 60;
  tempInt := (tempInt - s) div 60;
  m := tempInt mod 60;
  h := tempInt div 60;
  Result := Format('%d' + delimiter1 + '%2d' + delimiter1 + '%2d', [h, m, s]);
  if AddMiliSec then
    Result := Result + Format(delimiter2 + '%' + IntToStr(precision) + 'd', [ms]);

  for tempInt := 1 to Length(Result) do
    if Result[tempInt] = ' ' then
      Result[tempInt] := '0';
  if minus then
    Result := '-' + Result;
end;

function PrepareTimeParts(Secs: double; AddMiliSec: boolean): TTimeParts;
var
  tempInt: integer;
begin
  Secs := int(Secs * 1000) / 1000;
  if AddMiliSec then
  begin
    Result.ms := round(frac(Secs) * 1000);
    tempInt := round(int(Secs));
  end
  else
  begin
    Result.ms := 0;
    tempInt := round(Secs);
  end;
  Result.s := tempInt mod 60;
  tempInt := (tempInt - Result.s) div 60;
  Result.m := tempInt mod 60;
  Result.h := tempInt div 60;
end;

end.
