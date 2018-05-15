unit file_types;

interface

uses
  Classes, SysUtils;

procedure newRegisterFiles(pls, fls, assoc: TStrings; ReloadLang: boolean);
procedure RegisterFiles(pls, fls, assoc: TStrings; ReloadLang: boolean);

implementation

uses
  Windows, cp_registry, ShlObj, global_consts, settings_header, language,
  cp_utils;

procedure UnRegisterFiles121(fls, assoc: TStrings);
var
  i: integer;
  Reg: TRegistry;

  procedure UnRegisterMenuItem(Extension: string; Reg: TRegistry);
  var
    MyKey: string;
//    MyValue: string;
  begin
    if Pos('!', Extension) = 1 then
      Delete(Extension, 1, 1);
    with Reg do
    begin
      if OpenKey('.' + Extension, false) then
      begin
        MyKey := ReadString('');
        CloseKey;
        if MyKey <> '' then
        begin
          if OpenKey(MyKey + '\DefaultIcon', false) then
          begin
            if ReadString('PrevValue') <> '' then
              WriteString('', ReadString('PrevValue'));
            CloseKey;
          end;

          if OpenKey(MyKey + '\shell\open\command', false) then
          begin
            if ReadString('PrevValue') <> '' then
              WriteString('', ReadString('PrevValue'));
            CloseKey;
          end;

          if OpenKey(MyKey + '\shell\play\command', false) then
          begin
            if ReadString('PrevValue') <> '' then
              WriteString('', ReadString('PrevValue'));
            CloseKey;
          end;

          DeleteKey(MyKey + '\shell\openMT');
        end;
      end;
    end;
  end;

begin
  Reg := TRegistry.Create;
  with Reg do
  begin
    RootKey := HKEY_CLASSES_ROOT;
    for i := 0 to fls.Count - 1 do
      UnRegisterMenuItem(fls[i], Reg);
    for i := 0 to assoc.Count - 1 do
      UnRegisterMenuItem(assoc[i], Reg);
  end;
  Reg.Free;
  SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_FLUSHNOWAIT, nil, nil);
end;

procedure xpCDMenu(attach_fls, attach_pls: boolean);

  procedure processHandlerKey(reg: TRegistry; base_key, key, id: string;
    create_key: boolean);
  begin
    with reg do
  end;


const
  common_key = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\';
  play_file = 'PlayWithCinemaPlayer';
//  PlayList = 'PlayListWithCinemaPlayer';
var
  id: string;
begin
  with TRegistry.Create do
    try
      RootKey := HKEY_LOCAL_MACHINE;
      if attach_fls or attach_pls then
      begin
        if OpenKey(common_key + 'Handlers\' + play_file, true) then
        begin
          WriteString('DefaultIcon', ParamStr(0) + ',0');
          if attach_fls then
            id := '.File'
          else
            id := '.PlayList';
          WriteString('InvokeProgID', ProgName + id);
          WriteString('InvokeVerb', 'Open');
          WriteString('ProgID', 'Shell.HWEventHandlerShellExecute');
          WriteString('Provider', ProgName);
          WriteString('Action', GetHint(LangStor[LNG_SHELLMENU_PLAY]));
          CloseKey;
          if OpenKey(common_key + 'EventHandlers\PlayVideoFilesOnArrival', true) then
          begin
            WriteString(play_file, '');
            CloseKey;
          end;
        end;
      end
      else
      begin
        DeleteKey(common_key + 'Handlers\' + play_file);
        if OpenKey(common_key + 'EventHandlers\PlayVideoFilesOnArrival', false) then
        begin
          DeleteValue(play_file);
          CloseKey;
        end;
      end;
    finally
      Free;
    end;
end;

procedure RegisterFiles(pls, fls, assoc: TStrings; ReloadLang: boolean);
var
  i: integer;
  Reg: TRegistry;

  procedure RegisterMenuItem(Reg: TRegistry; Extension: string; Playlist: boolean);
  var
    MyKey: string;
  begin
    with Reg do
    begin
      if Playlist then
      begin
        MyKey := ProgName + '.PlayList';
        Delete(Extension, 1, 1);
      end
      else
        MyKey := ProgName + '.File';

      if OpenKey('.' + Extension, true) then
      begin
        if ReadString('') <> '' then
        begin
          if (ReadString('') = MyKey) then
            WriteString('', ReadString('CPBackup'));
          MyKey := ReadString('');
        end;
        if ReadString('') = '' then
        begin
          WriteString('', 'CPBackup');
          MyKey := Extension + 'File';
          WriteString('', MyKey);
        end;
        CloseKey;
      end;

      if config.AddOpenWith then
      begin
        OpenKey(MyKey + '\shell\openCP', true);
        WriteString('', LangStor[LNG_SHELLMENU_OPENWITH] + ' ' + ProgName);
        CloseKey;

        OpenKey(MyKey + '\shell\openCP\command', true);
        WriteString('', '"' + ParamStr(0) + '" "%L"');
        CloseKey;
      end
      else
        DeleteKey(MyKey + '\shell\openCP')
    end;
  end;

  procedure RegisterAssoc(Reg: TRegistry; Extension: string);
  var
    MyKey: string;
    IconIndex: char;
    Playlist: boolean;
  begin
    Playlist := Pos('!', Extension) = 1;
    if Playlist then
    begin
      IconIndex := '2';
      MyKey := ProgName + '.PlayList';
      Delete(Extension, 1, 1);
    end
    else
    begin
      IconIndex := '1';
      MyKey := ProgName + '.File';
    end;
    with Reg do
    begin
      OpenKey('.' + Extension, true);
      if ReadString('CPBackup') = '' then
        WriteString('CPBackup', ReadString(''));

      WriteString('', MyKey);
      CloseKey;

      OpenKey(MyKey + '\DefaultIcon', true);
      WriteString('', ParamStr(0) + ',' + IconIndex);
      CloseKey;

      OpenKey(MyKey + '\shell\open', true);
      WriteString('', LangStor[LNG_SHELLMENU_OPEN]);
      CloseKey;

      OpenKey(MyKey + '\shell\open\command', true);
      WriteString('', '"' + ParamStr(0) + '" "%L"');
      CloseKey;

      OpenKey(MyKey + '\shell\play', true);
      WriteString('', LangStor[LNG_SHELLMENU_PLAY]);
      CloseKey;

      OpenKey(MyKey + '\shell\play\command', true);
      WriteString('', '"' + ParamStr(0) + '" "%L"');
      CloseKey;

      DeleteKey(MyKey + '\shell\openCP\command');
      DeleteKey(MyKey + '\shell\openCP');
      CloseKey;


      if not Playlist then
      begin
        OpenKey(MyKey + '\shellex\PropertySheetHandlers', true);
        WriteString('', 'AviPage');
        CloseKey;

        OpenKey(MyKey + '\shellex\PropertySheetHandlers\AviPage', true);
        WriteString('', '{00022613-0000-0000-C000-000000000046}');
        CloseKey;

        if OpenKey('AVIFile\shellex\AdvancedPropertyHandlers') then
        begin
          OpenKey(MyKey + '\shellex\AdvancedPropertyHandlers', true);
          CloseKey;

          OpenKey(MyKey + '\shellex\AdvancedPropertyHandlers\{E14BB48F-3183-11D2-BE3C-3078302C2030}', true);
          CloseKey;
        end;
      end;
    end;
  end;

var
  file_ext_exists: boolean;
begin
  Reg := TRegistry.Create;
  with Reg do
  begin
    RootKey := HKEY_CLASSES_ROOT;
    for i := 0 to fls.Count - 1 do
      RegisterMenuItem(Reg, fls[i], false);
    for i := 0 to pls.Count - 1 do
      RegisterMenuItem(Reg, pls[i], true);
    file_ext_exists := false;
    for i := 0 to assoc.Count - 1 do
    begin
      if assoc[i][1] <> '!' then
        file_ext_exists := true;
      RegisterAssoc(Reg, assoc[i]);
    end;
  end;
  Reg.Free;
  if ((Win32MajorVersion = 5) and (Win32MinorVersion > 0)) or (Win32MajorVersion > 5) then
    xpCDMenu(file_ext_exists, assoc.Count > 0);
  if not ReloadLang then
    SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_FLUSHNOWAIT, nil, nil);
end;

procedure newRegisterFiles(pls, fls, assoc: TStrings; ReloadLang: boolean);
begin
  if not IsVer13 then
  begin
    UnRegisterFiles121(fls, assoc);
    with TRegistry.Create do
      try
        RootKey := HKEY_CURRENT_USER;
        OpenKey(sHKEY, true);
        WriteBool(sIs13Ver, true);
        CloseKey;
      finally
        Free;
      end;
  end;
  RegisterFiles(pls, fls, assoc, ReloadLang);
end;

end.
