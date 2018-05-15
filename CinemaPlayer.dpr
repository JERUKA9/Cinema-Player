program CinemaPlayer;

{$IFDEF DEBUG}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  FastMM4 in 'FastMM4.pas',
  FastMM4Messages in 'FastMM4Messages.pas',
  Forms,
  Windows,
  SysUtils,
  Messages,
  global in 'global.pas',
  closing in 'closing.pas',
  crazyhint in 'crazyhint.pas',
  main in 'main.pas' {frmCinemaPlayer},
  cp_subtitles in 'cp_subtitles.pas',
  cp_utils in 'cp_utils.pas',
  global_consts in 'global_consts.pas',
  cp_RemoteControl in 'cp_RemoteControl.pas',
  dlg_calctimeconfig in 'dlg_calctimeconfig.pas',
  cp_FrameManager in 'cp_FrameManager.pas',
  settings_header in 'settings_header.pas',
  subtitles_header in 'subtitles_header.pas',
  subtitles_style in 'subtitles_style.pas',
  subtitles_renderer in 'subtitles_renderer.pas',
  cp_graphics in 'cp_graphics.pas',
  dlg_settings in 'dlg_settings.pas',
  dlg_about in 'dlg_about.pas',
  xp_theme in 'xp_theme.pas',
  file_types in 'file_types.pas',
  editctrls in 'editctrls.pas',
  clrbtnctrls in 'clrbtnctrls.pas',
  dlg_corrector in 'dlg_corrector.pas',
  subeditor in 'subeditor.pas' {frmEditor},
  zb_sys_env in 'zb_sys_env.pas',
  uControlPanel in 'uControlPanel.pas',
  uSpeakerEngine in 'uSpeakerEngine.pas',
  uSpeakers in 'uSpeakers.pas',
  language in 'language.pas',
  uDlgShortcuts in 'uDlgShortcuts.pas',
  uBumpData in 'uBumpData.pas',
  uDlgDonate in 'uDlgDonate.pas',
  uDlgSelectFile in 'uDlgSelectFile.pas',
  WinSock2 in 'winsock2.pas';

{$R *.RES}
{$R dlgs.RES}
{$R WindowsXP.RES}


var
  mutex: THandle = 0;

procedure PutDataToPrevInst;
var
  CopyData: TCopyDataStruct;
  hPrevInst: THandle;
  Parametry: PByteArray;
  DlugParam: DWORD;
  i: integer;
begin
  mutex := CreateMutex(nil, false, 'cp_mutex');
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    i := 0;
    repeat
      hPrevInst := FindWindow(PChar(string(TfrmCinemaPlayer.ClassName)), nil);
      sleep(100);
      inc(i);
    until (hPrevInst > 0) or (i = 50);
    if i = 50 then
    begin
      Halt(0);
    end;
    if hPrevInst > 0 then
    begin
      if ParamCount > 0 then
      begin
        DlugParam := 0;
        for i := 1 to ParamCount do
        begin
          inc(DlugParam, Length(ParamStr(i)) + 1);
        end;
        try
          GetMem(Parametry, DlugParam);
          try
            DlugParam := 0;
            for i := 1 to ParamCount do
            begin
              CopyMemory(Pointer(DWORD(Parametry) + DlugParam), PChar(ParamStr(i)), Length(ParamStr(i)) + 1);
              inc(DlugParam, Length(ParamStr(i)) + 1);
            end;
            CopyData.cbData := DlugParam;
            CopyData.lpData := Parametry;
            SendMessage(hPrevInst, WM_COPYDATA, 0, longint(@CopyData));
          finally
            FreeMem(Parametry);
          end;
        finally
        end;
      end;
      ShowWindow(hPrevInst, SW_RESTORE);
      SetFocus(hPrevInst);
      SetForegroundWindow(hPrevInst);
      Halt(0);
    end;
  end;
end;

//var
//  i: integer;
begin
  if config.OneCopy then
    PutDataToPrevInst;

  Application.Initialize;
  Application.HintHidePause := 4000;
  Application.CreateForm(TfrmCinemaPlayer, frmCinemaPlayer);
  Application.CreateForm(TfrmEditor, frmEditor);
  Application.Run;
  Application.Minimize;
  ReleaseMutex(mutex);
end.
