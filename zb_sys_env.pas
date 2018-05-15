unit zb_sys_env;

interface

uses
  Windows, Classes, SysUtils, Forms;

procedure OpenCDDoor;
procedure CloseCDDoor;

procedure DisplayMessage(msg: string; caption: string);
procedure DisplayError(msg: string; caption: string = '');
function DisplayQuestion(msg: string; caption: string = ''): boolean;

//function getLogPixelsPerInc: integer;


implementation

uses
  global_consts, settings_header, language;

var
  DialogBaseUnitsH: WORD;
  DialogBaseUnitsV: WORD;
  
//function getLogPixelsPerInc: integer;
//begin
//  Result := log_pixels;
//end;

function mciSendString(lpstrCommand, lpstrReturnString: PChar;
  uReturnLength: UINT; hWndCallback: HWND): DWORD; stdcall; external 'winmm.dll' name 'mciSendStringA';

procedure OpenCDDoor;
begin
  mciSendString('Set cdaudio door open wait', nil, 0, 0);
end;

procedure CloseCDDoor;
begin
  mciSendString('Set cdaudio door closed wait', nil, 0, 0);
end;

function sm(s: string; c: string; style: cardinal): integer;
//var
//  i: integer;
begin
//  if config.StayOnTop then
//  begin
//    for i := 0 to Screen.FormCount - 1 do
//      with Screen.Forms[i] do
//         if ClassNameIs('TfrmCinemaplayer') or ClassNameIs('TfrmEditor') then
//         SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);


//    with Application.MainForm do
//      SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
//todo
//    if Assigned(frmEditor) then with frmEditor do
//      SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
//  end;

  Result := MessageBox(Application.MainForm.Handle, PChar(s), PChar(c), style or MB_SETFOREGROUND or MB_APPLMODAL);
//  if config.StayOnTop then
//    with Application.MainForm do
//      SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE)
end;

procedure DisplayMessage(msg: string; caption: string);
begin
  sm(msg, caption, MB_OK or MB_ICONINFORMATION);
end;

procedure DisplayError(msg: string; caption: string);
begin
  if caption = '' then
    caption := LangStor[LNG_MSG_ERROR];
  sm(msg, caption, MB_OK or MB_ICONERROR);
end;

function DisplayQuestion(msg: string; caption: string): boolean;
begin
  if caption = '' then
    caption := LangStor[LNG_MSG_QUESTION];
  Result := sm(msg, caption, MB_YESNO or MB_ICONQUESTION) = IDYES;
end;

procedure initialize;
begin
  DialogBaseUnitsH := LOWORD(GetDialogBaseUnits);
  DialogBaseUnitsV := HIWORD(GetDialogBaseUnits);
end;

initialization

  initialize();

end.
