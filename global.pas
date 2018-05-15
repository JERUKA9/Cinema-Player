unit global;

interface

uses
  Windows, Messages, Classes, cp_Registry, SysUtils, cp_CinemaEngine,
  subtitles_renderer, cp_FrameManager, global_consts, subtitles_style,
  settings_header, cp_graphics;

procedure SaveConfig(cs: TConfig; save_to_file: boolean;
  file_name: string; from_options: boolean);
procedure SaveFileTypes;
//function GetHint(s: string): string;

implementation

uses
  cp_utils, subtitles_header, language;

const
  sDonate                           = 'Interval';
  sAspectRatio: PChar               = 'AspectRatio';
  sAudioRenderer: PChar             = 'AudioRenderer';
  sAudioVolume: PChar               = 'AudioVolume';
  sAutoFullScreen: PChar            = 'AutoFullScreen';
  sAutoPlay: PChar                  = 'AutoPlay';
  sAutoSizeText: PChar              = 'AutoSizeText';
  sAutoTextDelay: PChar             = 'AutoTextDelay';
  sAdjustTextPos: PChar             = 'AdjustTextPos';
  sClearHistoryAtExit: PChar        = 'ClearHistoryAtExit';
  sCloseAfterPlay: PChar            = 'CloseAfterPlay';
  sDefaultFPS: PChar                = 'DefaultFPS';
  sEdgeSpace: PChar                 = 'EdgeSpace';
  sAntialias: PChar                 = 'Antialias';
  sOverlay: PChar                   = 'Overlay';
  sRenderStyle: PChar               = 'RenderStyle';
  sFontBold: PChar                  = 'FontBold';
  sFontCharset: PChar               = 'FontCharset';
  sFontColor: PChar                 = 'FontColor';
  sFontItalic: PChar                = 'FontItalic';
  sFontName: PChar                  = 'FontName';
  sFontSize: PChar                  = 'FontSize';
  sOutLineColor: PChar              = 'OutLineColor';
  sHideTaskBar: PChar               = 'HideTaskBar';
  sForceStdCtrlPanelMode: PChar     = 'ForceStdCtrlPanelMode';
  sLastMediaTime: PChar             = 'LastMediaTime';
  sLineSize: PChar                  = 'LineSize';
  sLoadSubtitles: PChar             = 'LoadSubtitles';
  sDisableResizeFrame               = 'DisableResizeFrame';
  sMaxSubWidthActive: PChar         = 'MaxSubWidthActive';
  sMaxSubWidthPercent: PChar        = 'MaxSubWidthPercent';
  sMaxSubWidth: PChar               = 'MaxSubWidth';
  sMovieFolder: PChar               = 'MovieFolder';
  sMute: PChar                      = 'Mute';
  sOneCopy: PChar                   = 'OneCopy';
  sOSDAntialias: PChar              = 'OSDAntialias';
  sOSDOverlay: PChar                = 'OSDOverlay';
  sOSDRenderStyle: PChar            = 'OSDRenderStyle';
  sOSDEnabled: PChar                = 'OSDEnabled';
  sOSDBkgColor: PChar               = 'OSDBkgColor';
  sOSDFontName: PChar               = 'OSDFontName';
  sOSDFontSize: PChar               = 'OSDFontSize';
  sOSDFontColor: PChar              = 'OSDFontColor';
  sOSDFontBold: PChar               = 'OSDFontBold';
  sOSDFontItalic: PChar             = 'OSDFontItalic';
  sOSDFontCharset: PChar            = 'OSDFontCharset';
  sOSDShowTimeEnabled: PChar        = 'OSDShowTimeEnabled';
  sOSDShowTime: PChar               = 'OSDShowTime';
  sOSDDisplayTime: PChar            = 'OSDDisplayTime';
  sOSDPosition: PChar               = 'OSDPosition';
  sOSDXPosition: PChar              = 'OSDXPosition';
  sOSDToLeft: PChar                 = 'OSDToLeft';
  sPageSize: PChar                  = 'PageSize';
  sPanelOnTop: PChar                = 'PanelOnTop';
  sPauseAfterClick: PChar           = 'PauseAfterClick';
  sPauseOnControl: PChar            = 'PauseOnControl';
  sPauseWhenMinimized: PChar        = 'PauseWhenMinimized';
  sDblClick2FullScr: PChar          = 'DblClick2FullScr';
  sPlaylist: PChar                  = 'Playlist';
  sPlaylistToLeft: PChar            = 'PlaylistToLeft';
  sRememberSuspendState: PChar      = 'RememberSuspendState';
  sRepeat: PChar                    = 'Repeat';
  sReverseWheel: PChar              = 'ReverseWheel';
  sScreenShotFolder: PChar          = 'ScreenShotFolder';
  sSearchingOutOfSubtitles: PChar   = 'SearchingOutOfSubtitles';
  sSearchNextMoviePart: PChar       = 'SearchNextMoviePart';
  sSearchNextMoviePartOnCDROM: PChar= 'SearchNextMoviePartOnCDROM';
  sShuffle: PChar                   = 'Shuffle';
  sShutdown: PChar                  = 'Shutdown';
  sShutdownDelay: PChar             = 'ShutdownDelay';
  sSpeakerEnabled: PChar            = 'SpeakerEnabled';
  sSpeakerFlushPrevPhrase: PChar    = 'SpeakerFlushPrevPhrase';
  sSpeakerHideSubtitles: PChar      = 'SpeakerHideSubtitles';
  sSpeakerSelected: PChar           = 'SpeakerSelected';
  sSpeakerVolume: PChar             = 'SpeakerVolume';
  sSpeakerRate: PChar               = 'SpeakerRate';
  sStayOnTop: PChar                 = 'StayOnTop';
  sStopOnError: PChar               = 'StopOnError';
  sSubtitlesFolder: PChar           = 'SubtitlesFolder';
  sSubtitleRows: PChar              = 'SubtitleRows';
  sSubAutoMinTime: PChar            = 'SubAutoMinTime';
  sSubAutoMaxTime: PChar            = 'SubAutoMaxTime';
  sSubAutoConstTime: PChar          = 'SubAutoConstTime';
  sSubAutoIncTime: PChar            = 'SubAutoIncTime';
  sSuspendState: PChar              = 'SuspendState';
  sSlash2Italic: PChar              = 'Slash2Italic';
  sTextDelay: PChar                 = 'TextDelay';
  sTurnOffCur: PChar                = 'TurnOffCur';
  sReverseTime: PChar               = 'TimeReverse';
  sViewStandard: PChar              = 'ViewStandard';
  sWaitShutdown: PChar              = 'WaitShutdown';
  sMouseWheelMode: PChar            = 'WheelPosition';

  sCinemaPlayer_ini: PChar          = 'CinemaPlayer.ini';
  sArial: PChar                     = 'Arial';

  sAddOpenWith: PChar               = 'AddOpenWith';
  sLang: PChar                      = 'LangID';
  sResDepth: PChar                  = 'ResDepth';
  sResHeight: PChar                 = 'ResHeight';
  sResRefresh: PChar                = 'ResRefresh';
  sResWidth: PChar                  = 'ResWidth';
  sSupported: PChar                 = 'Supported';
  sAssociated: PChar                = 'Associated';
  sSupportedPLS: PChar              = 'SupportedPLS';
  sMovie: PChar                     = 'Movie';
  sText: PChar                      = 'Text';
  sBMovie: PChar                    = 'BMovie';
  sBPos: PChar                      = 'BPos';

var
  SettingsFromFile: boolean;
{
function GetHint(s: string): string;
var
  i: integer;
begin
  i := Pos('&', s);
  if i > 0 then
    Delete(s, i, 1);
  Result := s;
end;
}

procedure LoadConfig;

  procedure LoadCommonConfig(CS: TConfigStorage);
  const
    osd_align: array[boolean] of THPosition = (phRight, phLeft);
  begin
    with CS, config do
    begin
      AspectRatio := TAspectRatioMode(ReadInteger(sAspectRatio, Ord(arOriginal)));
      if (AspectRatio < arOriginal) or (AspectRatio >= arCustom) then
        AspectRatio := arOriginal;
      AudioRenderer := ReadInteger(sAudioRenderer, 0);
      AudioVolume := ReadInteger(sAudioVolume, 32);
      AutoFullScreen := TAutoFullScreen(ReadInteger(sAutoFullScreen, Ord(afsNone)));
      Autoplay := ReadBool(sAutoPlay, true);
      AutoSizeText := ReadBool(sAutoSizeText, true);
      AutoTextDelay := ReadBool(sAutoTextDelay, true);
      AdjustTextPos := ReadBool(sAdjustTextPos, true);
      ClearHistoryAtExit := ReadBool(sClearHistoryAtExit, false);
      CloseAfterPlay := ReadBool(sCloseAfterPlay, true);
      DefaultFPS := ReadFloat(sDefaultFPS, 24.0);
      EdgeSpace := ReadInteger(sEdgeSpace, 3);
      DisableResizeFrame := ReadBool(sDisableResizeFrame, false);
      StrPCopy(SubtitlesAttr.Style.fd.name, ReadString(sFontName, sArial));
      SubtitlesAttr.AntiAliasing := TAntialiasing(ReadInteger(sAntialias, Ord(aaFull)));
      SubtitlesAttr.RenderMode := TRenderMode(ReadInteger(sRenderStyle, integer(rmThinBorder)));
      SubtitlesAttr.Overlay := ReadBool(sOverlay, true);
      SubtitlesAttr.Style.fd.size := ReadInteger(sFontSize, 24);
      SubtitlesAttr.Style.font_color := ReadInteger(sFontColor, $00E0E0E0);
      SubtitlesAttr.Style.bkg_color := ReadInteger(sOutLineColor, 0); // black
      if ReadBool(sFontBold, true) then
        Include(SubtitlesAttr.Style.fd.attr, faBold);
      if ReadBool(sFontItalic, false) then
        Include(SubtitlesAttr.Style.fd.attr, faItalic);
      SubtitlesAttr.Style.fd.charset := ReadInteger(sFontCharset, DEFAULT_CHARSET);
      HideTaskBar := ReadBool(sHideTaskBar, false);
      ForceStdCtrlPanelMode := ReadBool(sForceStdCtrlPanelMode, true);
      LastMediaTime := ReadFloat(sLastMediaTime, -1);
      LineSize := ReadInteger(sLineSize, 10);
      LoadSubtitles := ReadBool(sLoadSubtitles, true);
      MaxSubWidthActive := ReadBool(sMaxSubWidthActive, false);
      MaxSubWidthPercent := ReadBool(sMaxSubWidthPercent, false);
      MaxSubWidth := ReadInteger(sMaxSubWidth, 0);
      if MaxSubWidthPercent then
      begin
        if not (MaxSubWidth in [50..100]) then
          MaxSubWidth := 100;
      end
      else
      begin
        if MaxSubWidth < 500 then
          MaxSubWidth := 500;
      end;
      MovieFolder := ReadString(sMovieFolder, '');
      Mute := ReadBool(sMute, false);
      OneCopy := ReadBool(sOneCopy, false);
      OSDAttr.AntiAliasing := TAntialiasing(ReadInteger(sOSDAntialias, Ord(aaFull)));
      OSDAttr.RenderMode := TRenderMode(ReadInteger(sOSDRenderStyle, integer(rmThinBorder)));
      OSDAttr.Overlay := ReadBool(sOSDOverlay, true);
      OSDAttr.Style.bkg_color := ReadInteger(sOSDBkgColor, 0); // black
      OSDEnabled := ReadBool(sOSDEnabled, true);
      StrPCopy(OSDAttr.Style.fd.name, ReadString(sOSDFontName, sArial));
      OSDAttr.Style.fd.size := ReadInteger(sOSDFontSize, 16);
      OSDAttr.Style.font_color := ReadInteger(sOSDFontColor, $11C1EE);
      if ReadBool(sOSDFontBold, true) then
        Include(OSDAttr.Style.fd.attr, faBold);
      if ReadBool(sOSDFontItalic, false) then
        Include(OSDAttr.Style.fd.attr, faItalic);
      OSDAttr.Style.fd.charset := ReadInteger(sOSDFontCharset, DEFAULT_CHARSET);
      OSDCurrentTimeEnabled := ReadBool(sOSDShowTimeEnabled, false);
      OSDCurrentTime := ReadInteger(sOSDShowTime, 15);
      OSDDisplayTime := ReadInteger(sOSDDisplayTime, 3);
      osd_x_margin := ReadInteger(sOSDXPosition, 2);
      osd_y_margin := ReadInteger(sOSDPosition, 10);
      OSDAttr.Style.position.hPosition := osd_align[ReadBool(sOSDToLeft, true)];
      PageSize := ReadInteger(sPageSize, 60);
      PanelOnTop := ReadBool(sPanelOnTop, false);
      PauseAfterClick := ReadBool(sPauseAfterClick, false);
      PauseOnControl := ReadBool(sPauseOnControl, false);
      PauseWhenMinimized := ReadBool(sPauseWhenMinimized, false);
      DblClick2FullScr := ReadBool(sDblClick2FullScr, true);
      Playlist := ReadBool(sPlaylist, false);
      PlaylistToLeft := ReadBool(sPlaylistToLeft, false);
      RememberSuspendState := ReadBool(sRememberSuspendState, false);
      RepeatList := ReadBool(sRepeat, false);
      ReverseWheel := ReadBool(sReverseWheel, false);
      ScreenShotFolder := ReadString(sScreenShotFolder, '');
      SearchingOutOfSubtitles := TSearchingOutOfSubtitles(ReadInteger(sSearchingOutOfSubtitles, integer(soosSimilar)));
      SearchNextMoviePart := ReadBool(sSearchNextMoviePart, true);
      SearchNextMoviePartOnCDROM := ReadBool(sSearchNextMoviePartOnCDROM, SearchNextMoviePart);
      Shuffle := ReadBool(sShuffle, false);
      Shutdown := ReadInteger(sShutdown, 0);
      ShutdownDelay := ReadInteger(sShutdownDelay, 15);
      SpeakerEnabled := ReadBool(sSpeakerEnabled, false);
      SpeakerFlushPrevPhrase := ReadBool(sSpeakerFlushPrevPhrase, false);
      SpeakerHideSubtitles := ReadBool(sSpeakerHideSubtitles, false);
      SpeakerSelected := ReadInteger(sSpeakerSelected, -1);
      SpeakerVolume := ReadInteger(sSpeakerVolume, 50);
      SpeakerRate := ReadInteger(sSpeakerRate, 50);
      StayOnTop := ReadBool(sStayOnTop, false);
      StopOnError := ReadBool(sStopOnError, false);
      SubtitlesFolder := ReadString(sSubtitlesFolder, '');
      SubtitleRows := ReadInteger(sSubtitleRows, 3);
      SubAutoMinTime := ReadFloat(sSubAutoMinTime, 0.5);
      SubAutoMaxTime := ReadFloat(sSubAutoMaxTime, 4.5);
      SubAutoConstTime := ReadFloat(sSubAutoConstTime, 0.05);
      SubAutoIncTime := ReadFloat(sSubAutoIncTime, 0.0001);
      if RememberSuspendState then
        SuspendState := ReadBool(sSuspendState, false);
//      Slash2Italic := ReadBool(sSlash2Italic, true);
      TextDelay := ReadInteger(sTextDelay, 4);
      TurnOffCur := ReadInteger(sTurnOffCur, 3000);
      ReverseTime := ReadBool(sReverseTime, false);
      ViewStandard := ReadBool(sViewStandard, true);
      WaitShutdown := ReadBool(sWaitShutdown, true);
      MouseWheelMode := TMouseWheelMode(ReadInteger(sMouseWheelMode, 1));
    end;
  end;

  procedure checkExtension(const ext: PChar);
  begin
    if (Pos(ext, config.Supported) = 0) and (Pos(ext, config.Associated) = 0) then
      config.Supported := config.Supported + ext;
  end;

var
  i: integer;
  Reg: TRegistry;
  IniFile: TIniFile;
begin
  Reg := TRegistry.Create;
  with Reg do
  begin
    RootKey := HKEY_CURRENT_USER;
    with config do
    begin
      OpenKey(sHKEY, true);
      WriteString('ProgDir', ParamStr(0));

      LoadCommonConfig(Reg);

      _DonateID := ReadInteger(sDonate, iDonateID);

      AddOpenWith := ReadBool(sAddOpenWith);
      languages_list.selectLang(ReadInteger(sLang, LANG_USER_DEFAULT), true);
      Res.Depth := ReadInteger(sResDepth, 16);
      Res.Height := ReadInteger(sResHeight, 480);
      Res.VRefresh := ReadInteger(sResRefresh, 60);
      Res.Width := ReadInteger(sResWidth, 640);
      Supported := ReadString(sSupported, DefMovieExt);
      Associated := ReadString(sAssociated); //'!ASX'#13'!BPP'#13'!LST'#13'!M3U'#13'!MBL'#13'!PLS'#13'!VPL'#13'ASF'#13'AVI'#13'DIVX'#13'M1V'#13'MOV'#13'MP3'#13'MPE'#13'MPEG'#13'MPG'#13'QT'#13'WMA'#13'WMV'#13);
      checkExtension('OGG'#13);
      checkExtension('OGM'#13);
      checkExtension('MKV'#13);
      checkExtension('MKA'#13);
      checkExtension('MP4'#13);
      checkExtension('RMVB'#13);
      SupportedPLS := ReadString(sSupportedPLS, DefPlayListExt);
      for i := 1 to RecentCount do
      begin
        new(Files[i]);
        Files[i].Movie := ReadString(sMovie + IntToStr(i));
        Files[i].Text := ReadString(sText + IntToStr(i));
      end;
      for i := 1 to 10 do
      begin
        new(Bookmarks[i]);
        Bookmarks[i].FileName := ReadString(sBMovie + IntToStr(i));
          Bookmarks[i].Position := ReadFloat(sBPos + IntToStr(i));
      end;
      IsVer13 := ReadBool(sIs13Ver);
      CloseKey;
    end;
    Free;
  end;

  SettingsFromFile := FileExists(ExtractFilePath(ParamStr(0)) + sCinemaPlayer_ini);
  if SettingsFromFile then
  begin
    IniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + sCinemaPlayer_ini);
    IniFile.OpenKey(sekcja);
    try
      LoadCommonConfig(IniFile);
    finally
      IniFile.Free;
    end;
  end;
end;

procedure SaveConfig(cs: TConfig; save_to_file: boolean;
  file_name: string; from_options: boolean);

  procedure SaveCommonConfig(storage: TConfigStorage);
  begin
    with storage, cs do
    begin
      WriteInteger(sAspectRatio, integer(AspectRatio));
      WriteInteger(sAudioRenderer, AudioRenderer);
      WriteInteger(sAudioVolume, AudioVolume);
      WriteInteger(sAutoFullScreen, integer(AutoFullScreen));
      WriteBool(sAutoPlay, Autoplay);
      WriteBool(sAutoSizeText, AutoSizeText);
      WriteBool(sAutoTextDelay, AutoTextDelay);
      WriteBool(sAdjustTextPos, AdjustTextPos);
      WriteBool(sClearHistoryAtExit, ClearHistoryAtExit);
      WriteBool(sCloseAfterPlay, CloseAfterPlay);
      WriteFloat(sDefaultFPS, DefaultFPS);
      WriteInteger(sEdgeSpace, EdgeSpace);
      WriteBool(sDisableResizeFrame, DisableResizeFrame);
      WriteInteger(sAntialias, integer(SubtitlesAttr.AntiAliasing));
      WriteBool(sOverlay, SubtitlesAttr.Overlay);
      WriteInteger(sRenderStyle, integer(SubtitlesAttr.RenderMode));
      WriteBool(sFontBold, faBold in SubtitlesAttr.Style.fd.attr);
      WriteInteger(sFontCharset, SubtitlesAttr.Style.fd.charset);
      WriteInteger(sFontColor, SubtitlesAttr.Style.font_color);
      WriteBool(sFontItalic, faItalic in SubtitlesAttr.Style.fd.attr);
      WriteString(sFontName, SubtitlesAttr.Style.fd.name);
      WriteInteger(sFontSize, SubtitlesAttr.Style.fd.size);
      WriteInteger(sOutLineColor, SubtitlesAttr.Style.bkg_color);
      WriteBool(sHideTaskBar, HideTaskBar);
      WriteBool(sForceStdCtrlPanelMode, ForceStdCtrlPanelMode);
      WriteFloat(sLastMediaTime, LastMediaTime);
      WriteInteger(sLineSize, LineSize);
      WriteBool(sLoadSubtitles, LoadSubtitles);
      WriteBool(sMaxSubWidthActive, MaxSubWidthActive);
      WriteBool(sMaxSubWidthPercent, MaxSubWidthPercent);
      WriteInteger(sMaxSubWidth, MaxSubWidth);
      WriteString(sMovieFolder, MovieFolder);
      WriteBool(sMute, Mute);
      WriteBool(sOneCopy, OneCopy);
      WriteInteger(sOSDAntialias, integer(OSDAttr.AntiAliasing));
      WriteBool(sOSDOverlay, OSDAttr.Overlay);
      WriteInteger(sOSDRenderStyle, integer(OSDAttr.RenderMode));
      WriteBool(sOSDEnabled, OSDEnabled);
      WriteInteger(sOSDBkgColor, OSDAttr.Style.bkg_color);
      WriteString(sOSDFontName, OSDAttr.Style.fd.name);
      WriteInteger(sOSDFontSize, OSDAttr.Style.fd.size);
      WriteInteger(sOSDFontColor, OSDAttr.Style.font_color);
      WriteBool(sOSDFontBold, faBold in OSDAttr.Style.fd.attr);
      WriteBool(sOSDFontItalic, faItalic in OSDAttr.Style.fd.attr);
      WriteInteger(sOSDFontCharset, OSDAttr.Style.fd.charset);
      WriteBool(sOSDShowTimeEnabled, OSDCurrentTimeEnabled);
      WriteInteger(sOSDShowTime, OSDCurrentTime);
      WriteInteger(sOSDDisplayTime, OSDDisplayTime);
      WriteInteger(sOSDPosition, osd_y_margin);
      WriteInteger(sOSDXPosition, osd_x_margin);
      WriteBool(sOSDToLeft, OSDAttr.Style.position.hPosition = phLeft);
      WriteInteger(sPageSize, PageSize);
      WriteBool(sPanelOnTop, PanelOnTop);
      WriteBool(sPauseAfterClick, PauseAfterClick);
      WriteBool(sPauseOnControl, PauseOnControl);
      WriteBool(sPauseWhenMinimized, PauseWhenMinimized);
      WriteBool(sDblClick2FullScr, DblClick2FullScr);
      WriteBool(sPlaylist, Playlist);
      WriteBool(sPlaylistToLeft, PlaylistToLeft);
      WriteBool(sRememberSuspendState, RememberSuspendState);
      WriteBool(sRepeat, RepeatList);
      WriteBool(sReverseWheel, ReverseWheel);
      WriteString(sScreenShotFolder, ScreenShotFolder);
      WriteInteger(sSearchingOutOfSubtitles, integer(SearchingOutOfSubtitles));
      WriteBool(sSearchNextMoviePart, SearchNextMoviePart);
      WriteBool(sSearchNextMoviePartOnCDROM, SearchNextMoviePartOnCDROM);
      WriteBool(sShuffle, Shuffle);
      WriteInteger(sShutdown, Shutdown);
      WriteInteger(sShutdownDelay, ShutdownDelay);
      WriteBool(sSpeakerEnabled, SpeakerEnabled);
      WriteBool(sSpeakerFlushPrevPhrase, SpeakerFlushPrevPhrase);
      WriteBool(sSpeakerHideSubtitles, SpeakerHideSubtitles);
      WriteInteger(sSpeakerSelected, SpeakerSelected);
      WriteInteger(sSpeakerVolume, SpeakerVolume);
      WriteInteger(sSpeakerRate, SpeakerRate);
      WriteBool(sStayOnTop, StayOnTop);
      WriteBool(sStopOnError, StopOnError);
      WriteString(sSubtitlesFolder, SubtitlesFolder);
      WriteInteger(sSubtitleRows, SubtitleRows);
      WriteFloat(sSubAutoMinTime, SubAutoMinTime);
      WriteFloat(sSubAutoMaxTime, SubAutoMaxTime);
      WriteFloat(sSubAutoConstTime, SubAutoConstTime);
      WriteFloat(sSubAutoIncTime, SubAutoIncTime);
      WriteBool(sSuspendState, SuspendState);
//      WriteBool(sSlash2Italic, Slash2Italic);
      WriteInteger(sTextDelay, TextDelay);
      WriteInteger(sTurnOffCur, TurnOffCur);
      WriteBool(sReverseTime, ReverseTime);
      WriteBool(sViewStandard, ViewStandard);
      WriteBool(sWaitShutdown, WaitShutdown);
      WriteInteger(sMouseWheelMode, integer(MouseWheelMode));
    end;
  end;

var
  i: integer;
  Reg: TRegistry;
  ini_file: TIniFile;
begin
  if save_to_file then
  begin
    ini_file := TIniFile.Create(file_name);
    ini_file.OpenKey(sekcja);
    if GetDriveType(PChar(ExtractFileDrive(file_name))) <> DRIVE_CDROM then
      try
        SaveCommonConfig(ini_file);
        ini_file.UpdateFile;
      except
      end;
    ini_file.Free;
  end;
  if from_options then
    exit;

  Reg := TRegistry.Create;
  try
    with Reg do
    begin
      RootKey := HKEY_CURRENT_USER;
      with cs do
      begin
        OpenKey(sHKEY, true);
        if not save_to_file then
          SaveCommonConfig(Reg);

        WriteInteger(sDonate, iDonateID + 1);

        for i := 1 to RecentCount do
        begin
          WriteString(sMovie + IntToStr(i), Files[i].Movie);
          WriteString(sText + IntToStr(i), Files[i].Text);
        end;
        for i := 1 to 10 do
        begin
          WriteString(sBMovie + IntToStr(i), Bookmarks[i].FileName);
          WriteFloat(sBPos + IntToStr(i), Bookmarks[i].Position);
        end;

        WriteInteger(sLang, languages_list.current_lang);
        WriteInteger(sResDepth, Res.Depth);
        WriteInteger(sResHeight, Res.Height);
        WriteInteger(sResWidth, Res.Width);
        WriteInteger(sResRefresh, Res.VRefresh);
        CloseKey;
      end;
    end;
  finally
    Reg.Free;
  end;
end;

procedure SaveFileTypes;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    with Reg do
    begin
      RootKey := HKEY_CURRENT_USER;
      with config do
        if OpenKey(sHKEY, true) then
        begin
          WriteBool(sAddOpenWith, AddOpenWith);
          WriteString(sSupported, Supported);
          WriteString(sSupportedPLS, SupportedPLS);
          WriteString(sAssociated, Associated);
          CloseKey;
        end;
    end;
  finally
    Reg.Free;
  end;
end;

procedure initializeUnit();
begin
  ZeroMemory(@config.SubtitlesAttr.Style, sizeof(TSubtitlesStyle));
  config.SubtitlesAttr.Style.position.hPosition := phCenter;
  config.SubtitlesAttr.Style.position.vPosition := pvBottom;
  config.SubtitlesAttr.Style.tags :=
    [ttFontColor, ttFontName, ttFontSize, ttFontCharset, ttFontStyle,
     ttHatakFontStyle, ttPosition, ttHatakPosition, ttCoordinate, ttBkgColor];
  ZeroMemory(@config.OSDAttr.Style, sizeof(TSubtitlesStyle));
  config.OSDAttr.Style.position.hPosition := phLeft;
  config.OSDAttr.Style.position.vPosition := pvTop;
  config.OSDAttr.Style.tags :=
    [ttFontColor, ttFontName, ttFontSize, ttFontCharset, ttFontStyle,
     ttHatakFontStyle, ttPosition, ttHatakPosition, ttCoordinate, ttBkgColor];

  LoadConfig;

  with ChangeResolution do
  begin
    FullScreen := false;
    ResChanged := false;
    InChange := false;
  end;
end;

procedure finalizeUnit();
var
  i: integer;
begin
  SaveConfig(config, SettingsFromFile,
    NormalizeDir(ExtractFilePath(ParamStr(0))) + sCinemaPlayer_ini, false);
  for i := 1 to RecentCount do
    if config.Files[i] <> nil then
      dispose(config.Files[i]);
  for i := 1 to 10 do
    if config.Bookmarks[i] <> nil then
      dispose(config.Bookmarks[i]);
end;

initialization

  initializeUnit();

finalization

  finalizeUnit();

end.
