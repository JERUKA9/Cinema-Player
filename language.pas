unit language;

interface

uses Windows, Classes, SysUtils, cp_Registry;

type
  tLangData = class(TObject)
  private
    _name: string;
    _author: string;
    _lang: LANGID;
  public
    constructor create(const name, author: string; lang: LANGID);

    property name: string read _name;
    property author: string read _author;
    property lang: LANGID read _lang;
  end;

  tLanguages = class(TObject)
  private
    _list: TList;
    _current_lang: LANGID;
    _selected_lang: LANGID;
    function getItem(i: integer): tLangData;
    function findItem(lang: LANGID): integer;
  public
    constructor create;
    destructor destroy; override;

    function count(): integer;
    property items[i: integer]: tLangData read getItem; default;
    property current_lang: LANGID read _current_lang;
    property selected_lang: LANGID read _selected_lang;

    function selectLang(new_lang: LANGID; can_use_default: boolean): boolean;
  end;

var
  languages_list: tLanguages;

const
  LNG_FIRST_ITEM                    = 0001;

  LNG_NAME                          = 0001;
  LNG_AUTHOR                        = 0002;
  LNG_LANGID                        = 0003;
  LNG_OK                            = 0004;
  LNG_CANCEL                        = 0005;
  LNG_CLOSE                         = 0006;
  LNG_APPLY                         = 0007;
  LNG_ON                            = 0008;
  LNG_OFF                           = 0009;
  LNG_PERCENT                       = 0010;
  LNG_DEFAULT                       = 0011;
  LNG_BROWSE                        = 0012;

  LNG_FILEMENU                      = 0101;
  LNG_OPENMOVIE                     = 0102;
  LNG_RELOADMOVIE                   = 0103;
  LNG_OPENSUBTITLES                 = 0104;
  LNG_OPENDIRECTORY                 = 0105;
  LNG_ADDMOVIE                      = 0106;
  LNG_ADDDIRECTORY                  = 0107;
  LNG_OPENPLAYLIST                  = 0108;
  LNG_SAVEPLAYLIST                  = 0109;
  LNG_RECENTFILES                   = 0131;
  LNG_CLEARRECENT                   = 0132;
  LNG_GOTOBOOKMARK                  = 0133;
  LNG_SETBOOKMARK                   = 0134;
  LNG_BOOKMARK                      = 0135;
  LNG_ENABLESCREENSHOT              = 0141;
  LNG_SCREENSHOT                    = 0142;
  LNG_OPTIONS                       = 0151;
  LNG_FILTERSUSED                   = 0152;
  LNG_PROPERTIES                    = 0153;
  LNG_LANGUAGES                     = 0154;
  LNG_SHUTDOWN                      = 0155;
  LNG_EXIT                          = 0156;

  LNG_VIEWMENU                      = 0201;
  LNG_VIEWSTANDARD                  = 0202;
  LNG_VIEWMINIMAL                   = 0203;
  LNG_FULLSCREEN                    = 0204;
  LNG_FIXEDFULLSCREEN               = 0205;
  LNG_ZOOMMENU                      = 0210;
  LNG_ASPECTRATIO                   = 0211;
  LNG_ASPECTRATIOORIGINAL           = 0212;
  LNG_ASPECTRATIOFREE               = 0213;
  LNG_ASPECTRATIOOTHER              = 0214;
  LNG_TIMEREMAINING                 = 0220;
  LNG_HIDESUBTITLES                 = 0221;
  LNG_STAYONTOP                     = 0222;
  LNG_PLAYLISTONLEFT                = 0223;
  LNG_PLAYLIST                      = 0224;
  LNG_SUBTITLESEDITOR               = 0225;
  LNG_STATISTICS                    = 0226;
  LNG_MINIMIZE                      = 0227;
  LNG_RETURNTOWINDOW                = 0228;

  LNG_PLAYMENU                      = 0301;
  LNG_PLAYPREV                      = 0302;
  LNG_PLAY                          = 0303;
  LNG_PAUSE                         = 0304;
  LNG_STOP                          = 0305;
  LNG_PLAYNEXT                      = 0306;
  LNG_LARGEBACK                     = 0307;
  LNG_BACK                          = 0308;
  LNG_STEP                          = 0309;
  LNG_LARGESTEP                     = 0310;
  LNG_SPEEDMENU                     = 0320;
  LNG_PLAYSLOWER                    = 0321;
  LNG_PLAYNORMAL                    = 0322;
  LNG_PLAYFASTER                    = 0323;
  LNG_VOLUMEMENU                    = 0330;
  LNG_VOLUMEUP                      = 0331;
  LNG_VOLUMEDOWN                    = 0332;
  LNG_VOLUMEMUTE                    = 0333;
  LNG_AUDIOSTREAMS                  = 0340;
  LNG_AUDIO                         = 0341;

  LNG_PLAYLISTSHUFFLE               = 0350;
  LNG_PLAYLISTREPEAT                = 0351;
  LNG_PLAYLISTINVERTSELECT          = 0352;
  LNG_PLAYLISTSELECTNONE            = 0353;
  LNG_PLAYLISTSELECTALL             = 0354;
  LNG_PLAYLISTDELETESELECTED        = 0355;
  LNG_PLAYLISTCROP                  = 0356;
  LNG_PLAYLISTDELETEDEATH           = 0357;
  LNG_PLAYLISTDELETEALL             = 0358;
  LNG_PLAYLISTMOVEUP                = 0359;
  LNG_PLAYLISTMOVEDOWN              = 0360;
  LNG_PLAYLISTSORT                  = 0361;

  LNG_HELPMENU                      = 0400;
  LNG_ABOUT                         = 0401;
  LNG_SHORTCUTS                     = 0402;
  LNG_HOMEPAGE                      = 0403;
  LNG_FORUMPAGE                     = 0404;


  LNG_OPT_WINDOWCAPTION             = 0501;
  LNG_OPT_SAVETOFILE                = 0502;
  LNG_OPT_OTHEROPTIONS              = 0503;
  LNG_OPT_SECOND                    = 0504;
  LNG_OPT_MINUTE                    = 0505;
  LNG_OPT_SUBTITLESNAME             = 0506;
  LNG_OPT_FONT                      = 0507;
  LNG_OPT_SAMPLETEXT                = 0508;
  LNG_OPT_PIXEL                     = 0509;
  LNG_OPT_FONTNAME                  = 0520;
  LNG_OPT_FONTSIZE                  = 0521;
  LNG_OPT_RENDERSTYLE               = 0522;
  LNG_OPT_RENDERRECT                = 0523;
  LNG_OPT_RENDERSOLIDRECTS          = 0524;
  LNG_OPT_RENDERONLYTEXT            = 0525;
  LNG_OPT_RENDERTHINBORDER          = 0526;
  LNG_OPT_RENDERTHICKBORDER         = 0527;
  LNG_OPT_ANTIALIASING              = 0528;
  LNG_OPT_ANTIALIASNONE             = 0529;
  LNG_OPT_ANTIALIASLEVEL            = 0530;
  LNG_OPT_CHANGE                    = 0531;
  LNG_OPT_COLORS                    = 0532;
  LNG_OPT_TEXT                      = 0533;
  LNG_OPT_BORDER                    = 0534;
  LNG_OPT_RESET                     = 0535;
  LNG_OPT_AUTOSIZE                  = 0550;
  LNG_OPT_DISTANCE                  = 0551;
  LNG_OPT_DISTANCE1                 = 0552;
  LNG_OPT_DISPLAYSUBTITLESTIME      = 0553;
  LNG_OPT_AUTOADJUSTSUBTITLESTIME   = 0554;
  LNG_OPT_SUBTITLESFOLDER           = 0555;
  LNG_OPT_SUBTITLEROWS              = 0556;
  LNG_OPT_RENDERFATBORDER           = 0557;
  LNG_OPT_SUBWIDTH                  = 0558;
  LNG_OPT_LOADSUBTITLES             = 0559;
  LNG_OPT_PLAYNAME                  = 0560;
  LNG_OPT_NAVIGATION                = 0561;
  LNG_OPT_LARGESTEPS                = 0562;
  LNG_OPT_SMALLSTEPS                = 0563;
  LNG_OPT_MOUSEWHEEL                = 0564;
  LNG_OPT_WHEELPOSITION             = 0565;
  LNG_OPT_WHEELVOLUME               = 0566;
  LNG_OPT_REVERSEWHEEL              = 0567;
  LNG_OPT_FULLSCREEN                = 0568;
  LNG_OPT_HIDECURSOR                = 0569;
  LNG_OPT_HIDETASKBAR               = 0570;
  LNG_OPT_AUTOFULLSCREEN            = 0571;
  LNG_OPT_CHANGERESOLUTION          = 0572;
  LNG_OPT_PANELONTOP                = 0573;
  LNG_OPT_PAUSEONCONTROL            = 0574;
  LNG_OPT_ASFFPS                    = 0575;
  LNG_OPT_AUTOPLAY                  = 0576;
  LNG_OPT_CLOSEPLAYER               = 0577;
  LNG_OPT_ONEINSTANCE               = 0578;
  LNG_OPT_CLOSESYSTEM               = 0579;
  LNG_OPT_SUSPENDSYSTEM             = 0580;
  LNG_OPT_SHUTDOWNSYSTEM            = 0581;
  LNG_OPT_SHUTDOWNDELAY             = 0582;
  LNG_OPT_MOVIEFOLDER               = 0583;
  LNG_OPT_OSDENABLED                = 0584;
  LNG_OPT_OSDDISPLAYTIME            = 0585;
  LNG_OPT_OSDCURRENTTIME            = 0586;
  LNG_OPT_OSDTOPPOSITION            = 0587;
  LNG_OPT_STOPONERROR               = 0588;
  LNG_OPT_EXTENSIONSNAME            = 0589;
  LNG_OPT_FILESSUPPORTED            = 0590;
  LNG_OPT_FILESNOTASSOCIATED        = 0591;
  LNG_OPT_FILESASSOCIATED           = 0592;
  LNG_OPT_ADDTOCONTEXT              = 0593;
  LNG_OPT_APPLYCHANGES              = 0594;
  LNG_OPT_REMEMBERSUSPENDSTATE      = 0595;
  LNG_OPT_SEARCHNEXTPART            = 0596;
  LNG_OPT_OSDLEFTPOSITION           = 0597;
  LNG_OPT_OSDLEFTRIGHT              = 0598;
  LNG_OPT_DBLCLK2FULLSCR            = 0599;
  LNG_OPT_AUTOADJUSTSUBTITLESPOS    = 0600;
  LNG_OPT_FOLDERS                   = 0601;
  LNG_OPT_PAUSEWHENMINIMIZED        = 0602;
  LNG_OPT_FORCESTDCTRLPANELMODE     = 0603;
  LNG_OPT_SCRSHOTFOLDER             = 0604;
  LNG_OPT_SPEAKERNAME               = 0605;
  LNG_OPT_SPEAKERENABLE             = 0606;
  LNG_OPT_SPEAKERSELECT             = 0607;
  LNG_OPT_SPEAKERVOLUME             = 0608;
  LNG_OPT_SPEAKERRATE               = 0609;
  LNG_OPT_SPEAKERFLUSHPREV          = 0610;
  LNG_OPT_SPEAKERTEST               = 0611;
  LNG_OPT_SPEAKERHIDESUBTITLES      = 0612;
  LNG_OPT_AUDIOOUTPUT               = 0613;
  LNG_OPT_HIBERNATESYSTEM           = 0614;
  LNG_OPT_PAUSEAFTERLBUTTONCLICK    = 0615;
  LNG_OPT_WHEELSUBTITLES            = 0616;
  LNG_OPT_SEARCHNEXTPARTONCDROM     = 0617;
  LNG_OPT_CLEARHISTORYATEXIT        = 0618;
  LNG_OPT_DISABLEFRAMERESIZE        = 0619;
  LNG_OPT_SEARCHINGOUTOFSUBTITLES   = 0620;
  LNG_OPT_SOOSEXACT                 = 0621;
  LNG_OPT_SOOSSIMILAR               = 0622;
  LNG_OPT_SOOSUNLIKE                = 0623;

  LNG_EDT_WINDOWCAPTION             = 0701;
  LNG_EDT_NEW                       = 0702;
  LNG_EDT_SAVE                      = 0703;
  LNG_EDT_SAVEAS                    = 0704;
  LNG_EDT_ADDBEFORE                 = 0705;
  LNG_EDT_ADDAFTER                  = 0706;
  LNG_EDT_DELETE                    = 0707;
  LNG_EDT_PREVERROR                 = 0708;
  LNG_EDT_NEXTERROR                 = 0709;
  LNG_EDT_FOLLOWMOVIE               = 0710;
  LNG_EDT_ARRANGEWINDOWS            = 0711;
  LNG_EDT_APPLYCHANGES              = 0712;
  LNG_EDT_RESCALEFROM               = 0713;
  LNG_EDT_RESCALETO                 = 0714;
  LNG_EDT_TIMECORRECTOR             = 0715;
  LNG_EDT_TIMECORRECTORUNDO         = 0716;
  LNG_EDT_TIMECORRECTORSHIFT        = 0717;
  LNG_EDT_TIMECORRECTORRESCALE      = 0718;
  LNG_EDT_TIMECORRECTORFPS          = 0719;
  LNG_EDT_TIMECORRECTORFORWARD      = 0720;
  LNG_EDT_TIMECORRECTORBACKWARD     = 0721;
  LNG_EDT_TIMECORRECTORFROM         = 0722;
  LNG_EDT_TIMECORRECTORTO           = 0723;
  LNG_EDT_TIMECORRECTORBEFORE       = 0724;
  LNG_EDT_TIMECORRECTORAFTER        = 0725;
  LNG_EDT_TIMECORRECTORFROMFPS      = 0726;
  LNG_EDT_TIMECORRECTORTOFPS        = 0727;

  LNG_SAS_WINDOWCAPTION             = 0801;
  LNG_SAS_MINIMALTIME               = 0802;
  LNG_SAS_MAXIMALTIME               = 0803;
  LNG_SAS_CONSTTIME                 = 0804;
  LNG_SAS_INCREMENTALTIME           = 0805;
  LNG_SAS_LETTERS                   = 0806;

  LNG_ABOUT_WINDOWCAPTION           = 0820;
  LNG_ABOUT_AUTHOR                  = 0821;
  LNG_DONATIONINFO2                 = 0827;
  LNG_DONATION                      = 0828;
  LNG_DONATIONINFO                  = 0829;

  LNG_SHELLMENU_OPEN                = 0830;
  LNG_SHELLMENU_PLAY                = 0831;
  LNG_SHELLMENU_OPENWITH            = 0832;

  LNG_STATUS_PLAYING                = 0840;
  LNG_STATUS_PAUSED                 = 0841;
  LNG_STATUS_STOPPED                = 0842;
  LNG_STATUS_FPS                    = 0843;
  LNG_STATUS_SUBTITLES              = 0844;
  LNG_STATUS_SPEED                  = 0845;

  LNG_DIALOG_SUBTITLES              = 0860;
  LNG_DIALOG_MOVIES                 = 0861;
  LNG_DIALOG_PLAYLISTS              = 0862;
  LNG_DIALOG_ALL                    = 0863;
  LNG_DIALOG_SELECTFOLDER           = 0864;
  LNG_DIALOG_PRESSCTRL              = 0865;

  LNG_MSG_ERROR                     = 0901;
  LNG_MSG_QUESTION                  = 0902;
  LNG_MSG_BADFILE                   = 0903;
  LNG_MSG_BADPLAYLIST               = 0904;
  LNG_MSG_BADSUBTITLES              = 0905;
  LNG_MSG_FILENOTEXISTS             = 0906;
  LNG_MSG_CANTDISPLAYWINDOW         = 0907;
  LNG_MSG_NEXTCD                    = 0908;
  LNG_MSG_CONFIRMDELETE             = 0909;

  LNG_KEY_NAME_SPACE                = 0940;
  LNG_KEY_NAME_PERIOD               = 0941;
  LNG_KEY_NAME_UP                   = 0942;
  LNG_KEY_NAME_DOWN                 = 0943;
  LNG_KEY_NAME_LEFT                 = 0944;
  LNG_KEY_NAME_RIGHT                = 0945;
  LNG_KEY_FIRST                     = 0950;
  LNG_KEY_CTRL_O                    = 0950;
  LNG_KEY_CTRL_SHIFT_O              = 0951;
  LNG_KEY_CTRL_Q                    = 0952;
  LNG_KEY_ALT_O                     = 0953;
  LNG_KEY_ALT_SHIFT_O               = 0954;
  LNG_KEY_CTRL_D                    = 0955;
  LNG_KEY_CTRL_SHIFT_D              = 0956;
  LNG_KEY_ALT_D                     = 0957;
  LNG_KEY_ALT_SHIFT_D               = 0958;
  LNG_KEY_CTRL_L                    = 0959;
  LNG_KEY_CTRL_SHIFT_L              = 0960;
  LNG_KEY_CTRL_S                    = 0961;
  LNG_KEY_CTRL_T                    = 0962;
  LNG_KEY_CTRL_SHIFT_T              = 0963;
  LNG_KEY_CTRL_0                    = 0964;
  LNG_KEY_CTRL_1                    = 0965;
  LNG_KEY_CTRL_2                    = 0966;
  LNG_KEY_CTRL_3                    = 0967;
  LNG_KEY_CTRL_4                    = 0968;
  LNG_KEY_CTRL_5                    = 0969;
  LNG_KEY_CTRL_6                    = 0970;
  LNG_KEY_CTRL_7                    = 0971;
  LNG_KEY_CTRL_8                    = 0972;
  LNG_KEY_CTRL_9                    = 0973;
  LNG_KEY_CTRL_SHIFT_0              = 0974;
  LNG_KEY_CTRL_SHIFT_1              = 0975;
  LNG_KEY_CTRL_SHIFT_2              = 0976;
  LNG_KEY_CTRL_SHIFT_3              = 0977;
  LNG_KEY_CTRL_SHIFT_4              = 0978;
  LNG_KEY_CTRL_SHIFT_5              = 0979;
  LNG_KEY_CTRL_SHIFT_6              = 0980;
  LNG_KEY_CTRL_SHIFT_7              = 0981;
  LNG_KEY_CTRL_SHIFT_8              = 0982;
  LNG_KEY_CTRL_SHIFT_9              = 0983;
  LNG_KEY_SPACE                     = 0984;
  LNG_KEY_PERIOD                    = 0985;
  LNG_KEY_CTRL_P                    = 0986;
  LNG_KEY_CTRL_N                    = 0987;
  LNG_KEY_CTRL_A                    = 0988;
  LNG_KEY_DEL                       = 0989;
  LNG_KEY_SHIFT_DEL                 = 0990;
  LNG_KEY_CTRL_DEL                  = 0991;
  LNG_KEY_ALT_UP                    = 0992;
  LNG_KEY_ALT_DOWN                  = 0993;
  LNG_KEY_CTRL_R                    = 0994;
  LNG_KEY_CTRL_F                    = 0995;
  LNG_KEY_NUM0                      = 0996;
  LNG_KEY_NUM1                      = 0997;
  LNG_KEY_NUM2                      = 0998;
  LNG_KEY_NUM3                      = 0999;
  LNG_KEY_NUM4                      = 1000;
  LNG_KEY_NUM5                      = 1001;
  LNG_KEY_NUM6                      = 1002;
  LNG_KEY_NUM7                      = 1003;
  LNG_KEY_NUM8                      = 1004;
  LNG_KEY_NUM9                      = 1005;
  LNG_KEY_CTRL_NUM2                 = 1006;
  LNG_KEY_CTRL_NUM4                 = 1007;
  LNG_KEY_CTRL_NUM6                 = 1008;
  LNG_KEY_CTRL_NUM8                 = 1009;
  LNG_KEY_NUM_PLUS                  = 1010;
  LNG_KEY_NUM_MINUS                 = 1011;
  LNG_KEY_NUM_PERIOD                = 1012;
  LNG_KEY_ALT_1                     = 1013;
  LNG_KEY_ALT_2                     = 1014;
  LNG_KEY_ALT_3                     = 1015;
  LNG_KEY_PG_UP                     = 1016;
  LNG_KEY_PG_DOWN                   = 1017;
  LNG_KEY_LEFT                      = 1018;
  LNG_KEY_RIGHT                     = 1019;
  LNG_KEY_ENTER                     = 1020;
  LNG_KEY_BACKSPACE                 = 1021;
  LNG_KEY_CTRL_Z                    = 1022;
  LNG_KEY_CTRL_C                    = 1023;
  LNG_KEY_CTRL_X                    = 1024;
  LNG_KEY_UP                        = 1025;
  LNG_KEY_DOWN                      = 1026;
  LNG_KEY_CTRL_M                    = 1027;
  LNG_KEY_LEFT_BOX_BRACKET          = 1028;
  LNG_KEY_RIGHT_BOX_BRACKET         = 1029;
  LNG_KEY_P                         = 1030;
  LNG_KEY_ALT_T                     = 1031;
  LNG_KEY_CTRL_MINUS                = 1032;
  LNG_KEY_CTRL_EQUAL                = 1033;
  LNG_KEY_CTRL_UP                   = 1034;
  LNG_KEY_CTRL_DOWN                 = 1035;
  LNG_KEY_CTRL_SHIFT_MINUS          = 1036;
  LNG_KEY_CTRL_SHIFT_EQUAL          = 1037;
  LNG_KEY_CTRL_SHIFT_UP             = 1038;
  LNG_KEY_CTRL_SHIFT_DOWN           = 1039;
  LNG_KEY_ALT_ENTER                 = 1040;
  LNG_KEY_CTRL_ENTER                = 1041;
  LNG_KEY_ESC                       = 1042;
  LNG_KEY_CTRL_F4                   = 1043;
  LNG_KEY_SHIFT_ESC                 = 1044;
  LNG_KEY_F1                        = 1045;
  LNG_KEY_F7                        = 1046;
  LNG_KEY_F8                        = 1047;
  LNG_KEY_F9                        = 1048;
  LNG_KEY_F10                       = 1049;
  LNG_KEY_F11                       = 1050;
  LNG_KEY_F12                       = 1051;
  LNG_KEY_PRINTSCRN                 = 1052;
  LNG_KEY_LAST                      = 1052;

  LNG_LAST_ITEM                     = 1052;

type
  TLanguage = array[LNG_FIRST_ITEM..LNG_LAST_ITEM] of string;

{  TLangItem = class(TObject)
    id: word;
    text: string;
  end;

  TLanguage = class(TList)
  private
    function GetText(Index: word): string;
    procedure PutText(Index: word; const Value: string);
    function GetID(Index: integer; from_item: integer = -1;
      to_item: integer = -1): integer;
  public
    procedure Clear; override;
    property Items[Index: word]: string read GetText write PutText; default;
  end;
}


var
  LangStor: TLanguage;

implementation

uses
  global_consts, cp_utils;

const
  MainSection: PChar           = 'Language';
  MainWindowSection: PChar     = 'MainWindow';
  StatusSection: PChar         = 'Status';
  OptionsWindowSection: PChar  = 'OptionsWindow';
  EditorWindowSection: PChar   = 'EditorWindow';
  AboutWindowSection: PChar    = 'AboutWindow';
  MessagesSection: PChar       = 'Messages';
  KeyboardSection: PChar       = 'Keyboard';
  FileDialogSection: PChar     = 'FileDialog';
  ContextMenuSection: PChar    = 'ContextMenu';
  SubtAutoSettsSection: PChar  = 'SubtAutoSetts';

{ tLangData }

constructor tLangData.create(const name, author: string; lang: LANGID);
begin
  _name := name;
  _author := author;
  _lang := lang;
end;

{ tLanguages }

function tLanguages.count: integer;
begin
  Result := _list.Count;
end;

function listSortCompare(item1, item2: Pointer): Integer;
begin
  Result := AnsiCompareText(tLangData(item1)._name, tLangData(item2)._name);  
end;

constructor tLanguages.create;

  procedure addLang(const fname: string);
  var
    Reg: TIniFile;
    LangName: string;
//    Ver: string;
    Author: string;
    LangId: integer;
    Def: boolean;
  begin
//    LangName := sEnglish;
//    LangId := $0409;
    if fname = '' then
    begin
      LangName := sPolski;
      Author := global_consts.Author;
      LangId := $0415;
      Def := true;
    end
    else
    begin
      Reg := TIniFile.Create(ExtractFilePath(ParamStr(0)) + fname);
      Reg.OpenKey('Language');
      LangName := Reg.ReadIntString(LNG_NAME, '');
      Author := Reg.ReadIntString(LNG_AUTHOR, '');
      LangId := StrToIntDef(Reg.ReadIntString(LNG_LANGID, '0'), 0);
      Def := false;
      Reg.Free;
    end;
    if (LangId = $0415) and not Def then
      exit;
    _list.Add(tLangData.create(LangName, Author, LangId));
  end;

var
  SR: TSearchRec;
begin
  _list := TList.Create;
  _current_lang := 0; _selected_lang := 0;
  addLang('');
  if FindFirst(NormalizeDir(ExtractFilePath(ParamStr(0))) + '*.lng', faAnyFile, SR) = 0 then
  begin
    repeat
      addLang(SR.FindData.cFileName);
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
  _list.Sort(listSortCompare);
end;

destructor tLanguages.destroy;
var
  i: integer;
begin
  for i := 0 to _list.Count - 1 do
  begin
    TObject(_list[i]).Free;
  end;
  _list.Free();
end;

function tLanguages.findItem(lang: LANGID): integer;
var
  i: integer;
  sublang: byte;
begin
  Result := -1;
  sublang := $ff;
  for i := 0 to _list.Count - 1 do
    if ((items[i]._lang and $ff) = (lang and $ff)) and
       ((lang shr 8) < sublang) then
    begin
      Result := i;
      if items[i]._lang = lang then
        exit;
    end;
end;

function tLanguages.getItem(i: integer): tLangData;
begin
  Result := _list[i];
end;

function tLanguages.selectLang(new_lang: LANGID;
  can_use_default: boolean): boolean;
var
  reg: TIniFile;

  procedure ReadItem(item: word; default: string);
  begin
    LangStor[item] := reg.ReadIntString(item, default);
  end;

var
  buffer: array[0..5] of Char;
  lang_item: integer;
  selected_lang: LANGID;
  strDefLang : string;
{$ifdef SAVE_LANG}
  sl: TStringList;
  i: integer;
{$endif}
begin
  Result := false;
 //Result := new_lang = _current_lang;
 //  if Result then
 //    exit;

  GetLocaleInfo(new_lang, LOCALE_ILANGUAGE, buffer, sizeof(buffer));
  selected_lang := StrToInt('$' + buffer);

  lang_item := findItem(selected_lang);
  if (lang_item = -1) and can_use_default then
  begin
    lang_item := findItem($0409); // English
    if (lang_item = -1) then
    begin
      lang_item := findItem($0415); // Polski
    end;
  end;

  if (lang_item = -1) or
     not ((selected_lang = $0415) or FileExists(ExtractFilePath(ParamStr(0)) + items[lang_item]._name + '.lng')) then
    exit;

  if (selected_lang = $0415) then
    strDefLang := sPolski
  else
    strDefLang := sEnglish;
  _current_lang := new_lang;
  _selected_lang := selected_lang;
  Result := true;

  Reg := TIniFile.Create(
    ExtractFilePath(ParamStr(0)) + items[lang_item]._name + '.lng',
    ExtractFilePath(ParamStr(0)) + strDefLang + '.lng');
  with Reg do
  begin
    OpenKey(MainSection);
    ReadItem(LNG_NAME, '');
    ReadItem(LNG_AUTHOR, '');
    ReadItem(LNG_OK, '&OK');
    ReadItem(LNG_CANCEL, '&Anuluj');
    ReadItem(LNG_CLOSE, '&Zamknij');
    ReadItem(LNG_APPLY, '&Zastosuj');
    ReadItem(LNG_ON, 'W³¹czone');
    ReadItem(LNG_OFF, 'Wy³¹czone');
    ReadItem(LNG_PERCENT, '%');
    ReadItem(LNG_DEFAULT, '&Domyœlny');
    ReadItem(LNG_BROWSE, '&Przegl¹daj');

    OpenKey(MainWindowSection);
    ReadItem(LNG_FILEMENU, '&Plik');
    ReadItem(LNG_OPENMOVIE, 'Otwórz &film');
    ReadItem(LNG_OPENSUBTITLES, 'Otwórz na&pisy');
    ReadItem(LNG_RELOADMOVIE, 'P&rze³aduj film');
    ReadItem(LNG_OPENDIRECTORY, 'Otwórz &katalog');
    ReadItem(LNG_ADDMOVIE, 'Do&daj film');
    ReadItem(LNG_ADDDIRECTORY, 'Dodaj katalo&g');
    ReadItem(LNG_OpenPlAYLIsT, 'Otwórz &playlistê');
    ReadItem(LNG_SAVEPLAYLIST, 'Zapisz p&laylistê');
    ReadItem(LNG_RECENTFILES, 'Ostat&nie pliki');
    ReadItem(LNG_CLEARRECENT, '&Wyczyœæ listê');
    ReadItem(LNG_GOTOBOOKMARK, 'Prz&ejdŸ do zak³adki');
    ReadItem(LNG_SETBOOKMARK, '&Ustaw zak³adkê');
    ReadItem(LNG_BOOKMARK, 'Zak³adka');
    ReadItem(LNG_ENABLESCREENSHOT, '&Zezwalaj na zrzuty ekranu');
    ReadItem(LNG_SCREENSHOT, 'Zrzut &ekranu');
    ReadItem(LNG_OPTIONS, 'Op&cje...');
    ReadItem(LNG_LANGUAGES, '&Jêzyki');
    ReadItem(LNG_FILTERSUSED, '&U¿ywane filtry');
    ReadItem(LNG_PROPERTIES, 'W³aœc&iwoœci...');
    ReadItem(LNG_SHUTDOWN, 'Zamknij system po sko&ñczeniu odtwarzania');
    ReadItem(LNG_EXIT, 'Z&akoñcz');

    ReadItem(LNG_VIEWMENU, '&Widok');
    ReadItem(LNG_VIEWSTANDARD, 'Widok stan&dardowy');
    ReadItem(LNG_VIEWMINIMAL, 'Widok &minimalny');
    ReadItem(LNG_FULLSCREEN, '&Pe³ny ekran');
    ReadItem(LNG_FIXEDFULLSCREEN, 'Pe³ny ekran ze &zmian¹ rozdzielczoœci');
    ReadItem(LNG_ZOOMMENU, 'Powiê&kszenie');
    ReadItem(LNG_ASPECTRATIO, '&Proporcje obrazu');
    ReadItem(LNG_ASPECTRATIOORIGINAL, '&Oryginalny rozmiar');
    ReadItem(LNG_ASPECTRATIOFREE, '&Dopasuj do okna');
    ReadItem(LNG_ASPECTRATIOOTHER, '&Inny');
    ReadItem(LNG_TIMEREMAINING, 'Cza&s pozosta³y do koñca filmu');
    ReadItem(LNG_HIDESUBTITLES, 'Ukry&j napisy');
    ReadItem(LNG_STAYONTOP, 'Zawsze na &wierzchu');
    ReadItem(LNG_STATISTICS, 'S&tatystyki...');
    ReadItem(LNG_PLAYLIST, 'Play&lista');
    ReadItem(LNG_PLAYLISTONLEFT, 'Playlista po le&wej stronie');
    ReadItem(LNG_SUBTITLESEDITOR, '&Edytor napisów');
    ReadItem(LNG_MINIMIZE, '&Minimalizuj');
    ReadItem(LNG_RETURNTOWINDOW, 'Powrót &do okna');

    ReadItem(LNG_PLAYMENU, '&Odtwórz');
    ReadItem(LNG_PLAY, '&Odtwarzaj');
    ReadItem(LNG_PAUSE, '&Pauza');
    ReadItem(LNG_STOP, '&Zatrzymaj');
    ReadItem(LNG_PLAYPREV, '&Poprzedni');
    ReadItem(LNG_PLAYNEXT, '&Nastêpny');
    ReadItem(LNG_LARGEBACK, 'Du¿y krok do t&y³u');
    ReadItem(LNG_BACK, 'Krok do ty&³u');
    ReadItem(LNG_STEP, 'Krok do &przodu');
    ReadItem(LNG_LARGESTEP, 'Du¿y krok do p&rzodu');
    ReadItem(LNG_SPEEDMENU, 'Prê&dkoœæ odtwarzania');
    ReadItem(LNG_PLAYSLOWER, 'Odtwarzaj &wolniej');
    ReadItem(LNG_PLAYNORMAL, 'Odtwarzaj &normalnie');
    ReadItem(LNG_PLAYFASTER, 'Odtwarzaj &szybciej');
    ReadItem(LNG_VOLUMEMENU, '&G³oœnoœæ');
    ReadItem(LNG_VOLUMEUP, '&G³oœniej');
    ReadItem(LNG_VOLUMEDOWN, '&Ciszej');
    ReadItem(LNG_VOLUMEMUTE, 'Wyci&sz');
    ReadItem(LNG_AUDIOSTREAMS, 'Œcie¿ki dŸwiêkowe');
    ReadItem(LNG_AUDIO, 'Œcie¿ka');

    ReadItem(LNG_PLAYLISTSHUFFLE, '&Wybieranie losowe');
    ReadItem(LNG_PLAYLISTREPEAT, 'Powtarza&j');
    ReadItem(LNG_PLAYLISTINVERTSELECT, 'Odwróæ &zaznaczenie');
    ReadItem(LNG_PLAYLISTSELECTNONE, 'Anuluj zaz&nacznie');
    ReadItem(LNG_PLAYLISTSELECTALL, 'Zaznacz &wszystko');
    ReadItem(LNG_PLAYLISTDELETESELECTED, '&Usuñ zaznaczone');
    ReadItem(LNG_PLAYLISTCROP, 'Usuñ n&iezaznaczone');
    ReadItem(LNG_PLAYLISTDELETEDEATH, 'Usuñ ni&eistniej¹ce wpisy');
    ReadItem(LNG_PLAYLISTDELETEALL, 'Usuñ wsz&ystko');
    ReadItem(LNG_PLAYLISTMOVEUP, 'Zaznaczone do gó&ry');
    ReadItem(LNG_PLAYLISTMOVEDOWN, 'Zaznaczone do do&³u');
    ReadItem(LNG_PLAYLISTSORT, '&Sortuj');

    ReadItem(LNG_HELPMENU, 'Pomo&c');
    ReadItem(LNG_ABOUT, '&O programie...');
    ReadItem(LNG_SHORTCUTS, 'Skróty &klawiszowe');
    ReadItem(LNG_HOMEPAGE, 'Strona &domowa');
    ReadItem(LNG_FORUMPAGE, '&Forum');

    OpenKey(OptionsWindowSection);
    ReadItem(LNG_OPT_WINDOWCAPTION, 'Opcje');
    ReadItem(LNG_OPT_SAVETOFILE, '&Zapisz do pliku');
    ReadItem(LNG_OPT_OTHEROPTIONS, 'Pozosta³e opcje');
    ReadItem(LNG_OPT_SECOND, 'sek.');
    ReadItem(LNG_OPT_MINUTE, 'min.');

    ReadItem(LNG_OPT_SUBTITLESNAME, 'Napisy');
    ReadItem(LNG_OPT_FONT, 'Czcionka');
    ReadItem(LNG_OPT_SAMPLETEXT, 'To jest kawa³ek tekstu...');
    ReadItem(LNG_OPT_PIXEL, 'pikseli');
    ReadItem(LNG_OPT_FONTNAME, 'Nazwa');
    ReadItem(LNG_OPT_FONTSIZE, 'Rozmiar');
    ReadItem(LNG_OPT_RENDERSTYLE, 'Styl napisów');
    ReadItem(LNG_OPT_RENDERRECT, 'Pod filmem');
    ReadItem(LNG_OPT_RENDERSOLIDRECTS, 'Prostok¹tne t³o');
    ReadItem(LNG_OPT_RENDERONLYTEXT, 'Tylko tekst');
    ReadItem(LNG_OPT_RENDERTHINBORDER, 'Cienka obwódka');
    ReadItem(LNG_OPT_RENDERTHICKBORDER, 'Gruba obwódka');
    ReadItem(LNG_OPT_RENDERFATBORDER, 'T³usta obwódka');
    ReadItem(LNG_OPT_ANTIALIASING, 'Antyaliasing');
    ReadItem(LNG_OPT_ANTIALIASNONE, 'Brak');
    ReadItem(LNG_OPT_ANTIALIASLEVEL, 'Poziom %d');
    ReadItem(LNG_OPT_CHANGE, '&Zmieñ...');
    ReadItem(LNG_OPT_COLORS, 'Kolory');
    ReadItem(LNG_OPT_TEXT, 'Tekst');
    ReadItem(LNG_OPT_BORDER, 'Obwódka');
    ReadItem(LNG_OPT_RESET, '&Domyœlne');
    ReadItem(LNG_OPT_AUTOSIZE, 'Dostosuj rozmiar &czcionki do rozmiarów filmu');
    ReadItem(LNG_OPT_DISTANCE, 'Odleg³oœæ napisów od dolnej krawêdzi filmu');
    ReadItem(LNG_OPT_DISTANCE1, '%');
    ReadItem(LNG_OPT_SUBTITLEROWS, 'Liczba wierszy napisów');
    ReadItem(LNG_OPT_DISPLAYSUBTITLESTIME, 'Wyœwietlaj napisy przez');
    ReadItem(LNG_OPT_AUTOADJUSTSUBTITLESTIME, 'Dobieraj automatycznie czas wyœwietlania napisów');
    ReadItem(LNG_OPT_AUTOADJUSTSUBTITLESPOS, '"Przyci¹gaj" napisy do filmu');
    ReadItem(LNG_OPT_SUBWIDTH, 'Maksymalna szerokoœæ napisów');
    ReadItem(LNG_OPT_LOADSUBTITLES, 'Wczytuj napisy automatycznie');
    ReadItem(LNG_OPT_SEARCHINGOUTOFSUBTITLES, 'Wyszukiwanie napisów');
    ReadItem(LNG_OPT_SOOSEXACT, 'Tylko o takiej samej nazwie jak film');
    ReadItem(LNG_OPT_SOOSSIMILAR, 'Dopuszczaj napisy o podobnej nazwie');
    ReadItem(LNG_OPT_SOOSUNLIKE, 'Dopuszczaj napisy o ma³o podobnej nazwie');

    ReadItem(LNG_OPT_PLAYNAME, 'Odtwarzanie');
    ReadItem(LNG_OPT_NAVIGATION, 'Nawigacja');
    ReadItem(LNG_OPT_LARGESTEPS, 'Du¿e kroki');
    ReadItem(LNG_OPT_SMALLSTEPS, 'Ma³e kroki');
    ReadItem(LNG_OPT_MOUSEWHEEL, 'Kó³ko myszy');
    ReadItem(LNG_OPT_WHEELPOSITION, 'Zmiana pozycji odtwarzania filmu');
    ReadItem(LNG_OPT_WHEELVOLUME, 'Regulacja g³oœnoœci');
    ReadItem(LNG_OPT_WHEELSUBTITLES, 'Przesuwanie napisów w czasie');
    ReadItem(LNG_OPT_REVERSEWHEEL, '&Odwróæ dzia³anie kó³ka myszy');
    ReadItem(LNG_OPT_PAUSEONCONTROL, 'Zatrzymaj odtwarzanie podczas zmiany &ustawieñ');
    ReadItem(LNG_OPT_PAUSEWHENMINIMIZED, 'Zatrzymaj odtwarzanie podczas &minimalizacji');
    ReadItem(LNG_OPT_PAUSEAFTERLBUTTONCLICK, 'Zatrzymaj odtwarzanie po klikniêciu &lewym przyciskiem myszy');
    ReadItem(LNG_OPT_FULLSCREEN, 'Pe³ny ekran');
    ReadItem(LNG_OPT_HIDECURSOR, 'Ukryj wskaŸnik myszy po');
    ReadItem(LNG_OPT_DBLCLK2FULLSCR, 'Przejœcie do pe³nego ekranu po podwójnym kliku na filmie');
    ReadItem(LNG_OPT_HIDETASKBAR, '&Ukryj pasek zadañ w trybie pe³noekranowym');
    ReadItem(LNG_OPT_AUTOFULLSCREEN, '&Automatycznie przejdŸ do pe³nego ekranu');
    ReadItem(LNG_OPT_PANELONTOP, '&Przenieœ panel kontrolny na górê ekranu');
    ReadItem(LNG_OPT_FORCESTDCTRLPANELMODE, '&Wymuszaj standardowy panel kontrolny w trybie pe³noekranowym');
    ReadItem(LNG_OPT_CHANGERESOLUTION, '&Zmieñ rozdzielczoœæ');
    ReadItem(LNG_OPT_ASFFPS, 'FPS dla plików ".asf" i napisów z klatkami');
    ReadItem(LNG_OPT_AUTOPLAY, '&Rozpocznij odtwarzanie filmu po za³adowaniu');
    ReadItem(LNG_OPT_CLOSEPLAYER, 'Za&mknij odtwarzacz po skoñczeniu odtwarzania');
    ReadItem(LNG_OPT_ONEINSTANCE, '&U¿ywaj tylko jednej kopii programu');
    ReadItem(LNG_OPT_AUDIOOUTPUT, 'Wyjœcie audio');

    ReadItem(LNG_OPT_CLOSESYSTEM, 'Zamknij system po skoñczeniu odtwarzania');
    ReadItem(LNG_OPT_SUSPENDSYSTEM, '&Prze³¹cz w stan oczekiwania');
    ReadItem(LNG_OPT_HIBERNATESYSTEM, '&Hibernacja');
    ReadItem(LNG_OPT_REMEMBERSUSPENDSTATE, 'P&amiêtaj stan przy ponownym uruchomieniu programu');
    ReadItem(LNG_OPT_SHUTDOWNSYSTEM, '&Zamknij system');
    ReadItem(LNG_OPT_SHUTDOWNDELAY, '&Czekaj przed zamkniêciem');

    ReadItem(LNG_OPT_SEARCHNEXTPART, '&Szukaj kolejnych czêœci filmu');
    ReadItem(LNG_OPT_SEARCHNEXTPARTONCDROM, '&Pytaj o kolejne p³yty, jeœli film jest na CD-ROM');

    ReadItem(LNG_OPT_OSDENABLED, 'W³¹cz &OSD');
    ReadItem(LNG_OPT_OSDLEFTRIGHT, 'Wyœwietlaj OSD po prawej stronie');
    ReadItem(LNG_OPT_OSDDISPLAYTIME, 'Wyœwietlaj OSD przez');
    ReadItem(LNG_OPT_OSDCURRENTTIME, 'Pokazuj aktualny czas filmu co');
    ReadItem(LNG_OPT_OSDTOPPOSITION, 'Odleg³oœæ OSD od górnej krawêdzi okna');
    ReadItem(LNG_OPT_OSDLEFTPOSITION, 'Odleg³oœæ OSD od bocznej krawêdzi okna');

//    ReadItem(LNG_OPT_NAME, 'Typy plików');
    ReadItem(LNG_OPT_STOPONERROR, 'Poka¿ edytor, je¿eli po wczytaniu napisów s¹ b³êdy');

    ReadItem(LNG_OPT_FOLDERS, 'Foldery');
    ReadItem(LNG_OPT_MOVIEFOLDER, 'Domyœlny folder dla filmów');
    ReadItem(LNG_OPT_SUBTITLESFOLDER, 'Domyœlny folder dla napisów');
    ReadItem(LNG_OPT_SCRSHOTFOLDER, 'Domyœlny folder dla zrzutów ekranowych');

    ReadItem(LNG_OPT_EXTENSIONSNAME, 'Typy plików');
    ReadItem(LNG_OPT_FILESSUPPORTED, 'Obs³ugiwane rozszerzenia');
    ReadItem(LNG_OPT_FILESNOTASSOCIATED, 'Nieskojarzone');
    ReadItem(LNG_OPT_FILESASSOCIATED, 'Skojarzone');
    ReadItem(LNG_OPT_ADDTOCONTEXT, '&Dodaj opcjê "%s" do menu kontekstowego, je¿eli plik nie jest skojarzony z odtwarzaczem');
    ReadItem(LNG_OPT_APPLYCHANGES, '&WprowadŸ zmiany');

    ReadItem(LNG_OPT_SPEAKERNAME, 'Lektor');
    ReadItem(LNG_OPT_SPEAKERENABLE, '&Czytaj napisy');
    ReadItem(LNG_OPT_SPEAKERSELECT, 'Wybierz g³os');
    ReadItem(LNG_OPT_SPEAKERVOLUME, 'G³oœnoœæ');
    ReadItem(LNG_OPT_SPEAKERRATE, 'Prêdkoœæ');
    ReadItem(LNG_OPT_SPEAKERFLUSHPREV, '&Przerwij ostatni¹ wypowiedŸ, jeœli pojawi³a siê nastêpna');
    ReadItem(LNG_OPT_SPEAKERTEST, '&Testuj');
    ReadItem(LNG_OPT_SPEAKERHIDESUBTITLES, '&Ukryj napisy, jeœli lektor jest aktywny');

    ReadItem(LNG_OPT_CLEARHISTORYATEXIT, '&Wyczyœæ historiê ostatnich plików przy wyjœciu z programu');
    ReadItem(LNG_OPT_DISABLEFRAMERESIZE, '&Blokuj modyfikacje kadru mysz¹ na pe³nym ekranie');

    OpenKey(EditorWindowSection);
    ReadItem(LNG_EDT_WINDOWCAPTION, 'Edytor napisów');
    ReadItem(LNG_EDT_NEW, 'Nowy');
    ReadItem(LNG_EDT_SAVE, 'Zapisz');
    ReadItem(LNG_EDT_SAVEAS, 'Zapisz jako');
    ReadItem(LNG_EDT_ADDBEFORE, 'Wstaw liniê przed');
    ReadItem(LNG_EDT_ADDAFTER, 'Wstaw liniê po');
    ReadItem(LNG_EDT_DELETE, 'Usuñ liniê');
    ReadItem(LNG_EDT_PREVERROR, 'ZnajdŸ poprzedni b³¹d');
    ReadItem(LNG_EDT_NEXTERROR, 'ZnajdŸ nastêpny b³¹d');
    ReadItem(LNG_EDT_FOLLOWMOVIE, 'Wyszukuj bie¿¹cy napis');
    ReadItem(LNG_EDT_ARRANGEWINDOWS, 'U³ó¿ okna');
    ReadItem(LNG_EDT_ARRANGEWINDOWS, 'WprowadŸ zmiany');
    ReadItem(LNG_EDT_RESCALEFROM, 'Przeskaluj czas od tej linii');
    ReadItem(LNG_EDT_RESCALETO, 'Przeskaluj czas do tej linii');
    ReadItem(LNG_EDT_TIMECORRECTOR, 'Korektor czasu');
    ReadItem(LNG_EDT_TIMECORRECTORUNDO, '&Cofnij');
    ReadItem(LNG_EDT_TIMECORRECTORSHIFT, 'Przesuniêcie');
    ReadItem(LNG_EDT_TIMECORRECTORRESCALE, 'Przeskalowanie');
    ReadItem(LNG_EDT_TIMECORRECTORFPS, 'Zmiana FPS');
    ReadItem(LNG_EDT_TIMECORRECTORFORWARD, 'do przodu');
    ReadItem(LNG_EDT_TIMECORRECTORBACKWARD, 'do ty³u');
    ReadItem(LNG_EDT_TIMECORRECTORFROM, 'Od czasu');
    ReadItem(LNG_EDT_TIMECORRECTORTO, 'Do czasu');
    ReadItem(LNG_EDT_TIMECORRECTORBEFORE, 'Przed');
    ReadItem(LNG_EDT_TIMECORRECTORAFTER, 'Po');
    ReadItem(LNG_EDT_TIMECORRECTORFROMFPS, 'Z FPS');
    ReadItem(LNG_EDT_TIMECORRECTORTOFPS, 'Na FPS');

    OpenKey(SubtAutoSettsSection);
    ReadItem(LNG_SAS_WINDOWCAPTION, 'Szybkoœæ wyœwietlania &napisów');
    ReadItem(LNG_SAS_MINIMALTIME, 'Czas minimalny');
    ReadItem(LNG_SAS_MAXIMALTIME, 'Czas maksymalny');
    ReadItem(LNG_SAS_CONSTTIME, 'Sta³y czas na literê');
    ReadItem(LNG_SAS_INCREMENTALTIME, 'Przyrost czasu na literê');
    ReadItem(LNG_SAS_LETTERS, 'Litery');

    OpenKey(AboutWindowSection);
    ReadItem(LNG_ABOUT_WINDOWCAPTION, 'O programie');
    ReadItem(LNG_ABOUT_AUTHOR, 'Autor');
    ReadItem(LNG_DONATION, 'Wsparcie projektu');
    ReadItem(LNG_DONATIONINFO,
      'CinemaPlayer jest darmowy. Jeœli chcesz dobrowolnie wesprzeæ ' +
      'rozwój programu lub uwa¿asz, ¿e warto wynagrodziæ Autora i ' +
      'zachêciæ go do dalszej pracy mo¿esz wp³aciæ dowoln¹ kwotê na podane ' +
      'ni¿ej konto bankowe Inteligo. Pamiêtaj, ' +
      'aby podaæ swój e-mail, t¹ drog¹ mo¿esz otrzymaæ ewentualne bonusy ' +
      '(jeœli pojawi¹ siê kiedyœ w przysz³oœci). Napisz te¿, pod jak¹ nazw¹ ' +
      '(ksywk¹) umieœciæ Ciê na liœcie ofiarodawców.'#13'Zebrane fundusze ' +
      'zostan¹ przeznaczone na rozwój i utrzymanie strony WWW ' +
      '(w³asna domena, nowy design). Bêdzie to te¿ istotny implus dla Autora, ' +
      'aby bardziej zaanga¿owaæ siê w rozwój programu.');
    ReadItem(LNG_DONATIONINFO2,
      'lub kliknij w wybrany baner i wyœlij datek na konto:');

    OpenKey(ContextMenuSection);
    ReadItem(LNG_SHELLMENU_OPEN, '&Otwórz');
    ReadItem(LNG_SHELLMENU_PLAY, 'Od&twórz');
    ReadItem(LNG_SHELLMENU_OPENWITH, 'Otwórz &z');

    OpenKey(StatusSection);
    ReadItem(LNG_STATUS_STOPPED, 'Zatrzymane');
    ReadItem(LNG_STATUS_PLAYING, 'Odtwarzanie');
    ReadItem(LNG_STATUS_PAUSED, 'Wstrzymane');
    ReadItem(LNG_STATUS_SUBTITLES, 'Napisy');
    ReadItem(LNG_STATUS_SPEED, 'Prêdkoœæ');

    OpenKey(FileDialogSection);
    ReadItem(LNG_DIALOG_SUBTITLES, 'Napisy');
    ReadItem(LNG_DIALOG_MOVIES, 'Filmy');
    ReadItem(LNG_DIALOG_PLAYLISTS, 'Playlisty');
    ReadItem(LNG_DIALOG_ALL, 'Wszystkie pliki');
    ReadItem(LNG_DIALOG_SELECTFOLDER, 'Wybierz folder');
    ReadItem(LNG_DIALOG_PRESSCTRL, 'Naciœnij CTRL, aby przeszukaæ podkatalogi');

    OpenKey(MessagesSection);
    ReadItem(LNG_MSG_ERROR, 'B³¹d');
    ReadItem(LNG_MSG_QUESTION, 'Pytanie');
    ReadItem(LNG_MSG_BADFILE, 'Nieznany format pliku z filmem!');
    ReadItem(LNG_MSG_BADPLAYLIST, 'Nie mogê wczytaæ pliku!');
    ReadItem(LNG_MSG_BADSUBTITLES, 'Nieznany format pliku z napisami!');
    ReadItem(LNG_MSG_FILENOTEXISTS, 'Plik nie istnieje!');
    ReadItem(LNG_MSG_CANTDISPLAYWINDOW, 'Nie mogê wyœwietliæ okna!');
    ReadItem(LNG_MSG_NEXTCD, 'Plik nie istnieje. Proszê w³ó¿yæ w³aœciwy dysk CD...');
    ReadItem(LNG_MSG_CONFIRMDELETE, 'Chcesz usun¹æ zaznaczone linie (%d)?');
//      LocalSettings, 'Ustawienia zosta³y za³adowane z lokalnego pliku. Chcesz je zachowaæ?');

    OpenKey(KeyboardSection);
    ReadItem(LNG_KEY_NAME_SPACE, 'Spacja');
    ReadItem(LNG_KEY_NAME_PERIOD, 'Kropka');
    ReadItem(LNG_KEY_NAME_UP, 'Kursor w górê');
    ReadItem(LNG_KEY_NAME_DOWN, 'Kursor w dó³');
    ReadItem(LNG_KEY_NAME_LEFT, 'Kursor w lewo');
    ReadItem(LNG_KEY_NAME_RIGHT, 'Kursor w prawo');
    ReadItem(LNG_KEY_CTRL_O, 'Wczytanie filmów');
    ReadItem(LNG_KEY_CTRL_SHIFT_O, 'Wczytanie filmów z domyœlnego katalogu dla filmów (katalog mo¿na ustawiæ w opcjach)');
    ReadItem(LNG_KEY_CTRL_Q, 'Prze³adowanie aktualnego filmu');
    ReadItem(LNG_KEY_ALT_O, 'Dodanie filmów do playlisty');
    ReadItem(LNG_KEY_ALT_SHIFT_O, 'Dodanie filmów z domyœlnego katalogu dla filmów do playlisty (katalog mo¿na ustawiæ w opcjach)');
    ReadItem(LNG_KEY_CTRL_D, 'Wczytanie wszystkich filmów z wybranego katalogu');
    ReadItem(LNG_KEY_CTRL_SHIFT_D, 'Wczytanie wszystkich filmów z domyœlnego katalogu dla filmów (katalog mo¿na ustawiæ w opcjach)');
    ReadItem(LNG_KEY_ALT_D, 'Dodanie wszystkich filmów z wybranego katalogu do playlisty');
    ReadItem(LNG_KEY_ALT_SHIFT_D, 'Dodanie wszystkich filmów z domyœlnego katalogu dla filmów do playlisty (katalog mo¿na ustawiæ w opcjach)');
    ReadItem(LNG_KEY_CTRL_L, 'Wczytanie playlisty');
    ReadItem(LNG_KEY_CTRL_SHIFT_L, 'Wczytanie playlisty z domyœlnego katalogu dla filmów (katalog mo¿na ustawiæ w opcjach)');
    ReadItem(LNG_KEY_CTRL_S, 'Zapisanie playlisty');
    ReadItem(LNG_KEY_CTRL_T, 'Wczytanie tekstu');
    ReadItem(LNG_KEY_CTRL_SHIFT_T, 'Wczytanie tekstu z domyœlnego katalogu dla napisów (katalog mo¿na ustawiæ w opcjach)');
    ReadItem(LNG_KEY_CTRL_0, 'Wczytanie filmu z zak³adki 0');
    ReadItem(LNG_KEY_CTRL_1, 'Wczytanie filmu z zak³adki 1');
    ReadItem(LNG_KEY_CTRL_2, 'Wczytanie filmu z zak³adki 2');
    ReadItem(LNG_KEY_CTRL_3, 'Wczytanie filmu z zak³adki 3');
    ReadItem(LNG_KEY_CTRL_4, 'Wczytanie filmu z zak³adki 4');
    ReadItem(LNG_KEY_CTRL_5, 'Wczytanie filmu z zak³adki 5');
    ReadItem(LNG_KEY_CTRL_6, 'Wczytanie filmu z zak³adki 6');
    ReadItem(LNG_KEY_CTRL_7, 'Wczytanie filmu z zak³adki 7');
    ReadItem(LNG_KEY_CTRL_8, 'Wczytanie filmu z zak³adki 8');
    ReadItem(LNG_KEY_CTRL_9, 'Wczytanie filmu z zak³adki 9');
    ReadItem(LNG_KEY_CTRL_SHIFT_0, 'Zapisanie filmu do zak³adki 0');
    ReadItem(LNG_KEY_CTRL_SHIFT_1, 'Zapisanie filmu do zak³adki 1');
    ReadItem(LNG_KEY_CTRL_SHIFT_2, 'Zapisanie filmu do zak³adki 2');
    ReadItem(LNG_KEY_CTRL_SHIFT_3, 'Zapisanie filmu do zak³adki 3');
    ReadItem(LNG_KEY_CTRL_SHIFT_4, 'Zapisanie filmu do zak³adki 4');
    ReadItem(LNG_KEY_CTRL_SHIFT_5, 'Zapisanie filmu do zak³adki 5');
    ReadItem(LNG_KEY_CTRL_SHIFT_6, 'Zapisanie filmu do zak³adki 6');
    ReadItem(LNG_KEY_CTRL_SHIFT_7, 'Zapisanie filmu do zak³adki 7');
    ReadItem(LNG_KEY_CTRL_SHIFT_8, 'Zapisanie filmu do zak³adki 8');
    ReadItem(LNG_KEY_CTRL_SHIFT_9, 'Zapisanie filmu do zak³adki 9');
    ReadItem(LNG_KEY_SPACE, 'Odtwarzanie/Pauza');
    ReadItem(LNG_KEY_PERIOD, 'Zatrzymanie');
    ReadItem(LNG_KEY_CTRL_P, 'Poprzedni film z playlisty');
    ReadItem(LNG_KEY_CTRL_N, 'Nastêpny film z playlisty');
    ReadItem(LNG_KEY_CTRL_A, 'Zaznaczenie wszystkich pozycji na playliscie');
    ReadItem(LNG_KEY_DEL, 'Usuniêcie zaznaczonych elementów z playlisty');
    ReadItem(LNG_KEY_SHIFT_DEL, 'Usuniêcie niezaznaczonych elementów z playlisty');
    ReadItem(LNG_KEY_CTRL_DEL, 'Usuwa te pozycje z playlisty, które wskazuj¹ na nieistniej¹ce pliki');
    ReadItem(LNG_KEY_ALT_UP, 'Przesuwa zaznaczone pozycje na playliœcie do góry');
    ReadItem(LNG_KEY_ALT_DOWN, 'Przesuwa zaznaczone pozycje na playliœcie do do³u');
    ReadItem(LNG_KEY_CTRL_R, 'Powtarzanie playlisty po skoñczeniu odtwarzania');
    ReadItem(LNG_KEY_CTRL_F, 'Losowe odtwarzanie pozycji z playlisty');
    ReadItem(LNG_KEY_NUM0, 'Dopasowanie kadru do okna programu (z zachowaniem aktualnych proporcji)');
    ReadItem(LNG_KEY_NUM1, 'Przesuniêcie kadru w lewo i do do³u');
    ReadItem(LNG_KEY_NUM2, 'Przesuniêcie kadru do do³u');
    ReadItem(LNG_KEY_NUM3, 'Przesuniêcie kadru w prawo i do do³u');
    ReadItem(LNG_KEY_NUM4, 'Przesuniêcie kadru w lewo');
    ReadItem(LNG_KEY_NUM5, 'Ustawienie kadru na œrodku okna programu');
    ReadItem(LNG_KEY_NUM6, 'Przesuniêcie kadru w prawo');
    ReadItem(LNG_KEY_NUM7, 'Przesuniêcie kadru w lewo i do góry');
    ReadItem(LNG_KEY_NUM8, 'Przesuniêcie kadru do góry');
    ReadItem(LNG_KEY_NUM9, 'Przesuniêcie kadru w prawo i do góry');
    ReadItem(LNG_KEY_CTRL_NUM2, 'Zmniejszanie wysokoœci kadru');
    ReadItem(LNG_KEY_CTRL_NUM4, 'Zmniejszanie szerokoœci kadru');
    ReadItem(LNG_KEY_CTRL_NUM6, 'Zwiêkszanie szerokoœci kadru');
    ReadItem(LNG_KEY_CTRL_NUM8, 'Zwiêkszanie wysokoœci kadru');
    ReadItem(LNG_KEY_NUM_PLUS, 'Powiêkszenie kadru');
    ReadItem(LNG_KEY_NUM_MINUS, 'Pomniejszenie kadru');
    ReadItem(LNG_KEY_NUM_PERIOD, 'Zmiana (cyklicznie) predefiniowanych proporcji obrazu');
    ReadItem(LNG_KEY_ALT_1, '50% wielkoœci filmu');
    ReadItem(LNG_KEY_ALT_2, '100% wielkoœci filmu');
    ReadItem(LNG_KEY_ALT_3, '200% wielkoœci filmu');
    ReadItem(LNG_KEY_PG_UP, 'Du¿y skok do ty³u (standardowo 60 sek. mo¿na zmieniæ w opcjach)');
    ReadItem(LNG_KEY_PG_DOWN, 'Du¿y skok do przodu (standardowo 60 sek. mo¿na zmieniæ w opcjach)');
    ReadItem(LNG_KEY_LEFT, 'Ma³y skok do ty³u (standardowo 10 sek. mo¿na zmieniæ w opcjach)');
    ReadItem(LNG_KEY_RIGHT, 'Ma³y skok do przodu (standardowo 10 sek. mo¿na zmieniæ w opcjach)');
    ReadItem(LNG_KEY_ENTER, 'Sekunda do przodu (na playliœcie odtwarzanie wybranej pozycji)');
    ReadItem(LNG_KEY_BACKSPACE, 'Sekunda do ty³u');
    ReadItem(LNG_KEY_CTRL_Z, 'Zmniejszenie o 5% tempa odtwarzania filmu (min. do 50%)');
    ReadItem(LNG_KEY_CTRL_C, 'Zwiêkszenie o 5% tempa odtwarzania filmu (maks. do 150%)');
    ReadItem(LNG_KEY_CTRL_X, 'Przywrócenie normalnego tempa');
    ReadItem(LNG_KEY_UP, 'G³oœniej (kiedy widoczna jest playlista zmienione na HOME)');
    ReadItem(LNG_KEY_DOWN, 'Ciszej (kiedy widoczna jest playlista zmienione na END)');
    ReadItem(LNG_KEY_CTRL_M, 'Wyciszenie');
    ReadItem(LNG_KEY_LEFT_BOX_BRACKET, 'Przesuniêcie napisów wzglêdem filmu o sekundê do ty³u');
    ReadItem(LNG_KEY_RIGHT_BOX_BRACKET, 'Przesuniêcie napisów wzglêdem filmu o sekundê do przodu');
    ReadItem(LNG_KEY_P, 'Przywrócenie pocz¹tkowych ustawieñ tekstu wzglêdem filmu');
    ReadItem(LNG_KEY_ALT_T, 'Ukrycie/Pokazanie napisów');
    ReadItem(LNG_KEY_CTRL_MINUS, 'Pomniejszenie czcionki');
    ReadItem(LNG_KEY_CTRL_EQUAL, 'Powiêkszenie czcionki');
    ReadItem(LNG_KEY_CTRL_UP, 'Przesuniêcie napisów na ekranie do góry');
    ReadItem(LNG_KEY_CTRL_DOWN, 'Przesuniêcie napisów na ekranie do do³u');
    ReadItem(LNG_KEY_CTRL_SHIFT_MINUS, 'Pomniejszenie czcionki OSD');
    ReadItem(LNG_KEY_CTRL_SHIFT_EQUAL, 'Powiêkszenie czcionki OSD');
    ReadItem(LNG_KEY_CTRL_SHIFT_UP, 'Przesuniêcie OSD do góry');
    ReadItem(LNG_KEY_CTRL_SHIFT_DOWN, 'Przesuniêcie OSD do dó³u');
    ReadItem(LNG_KEY_ALT_ENTER, 'Pe³ny ekran bez zmiany rozdzielczoœci');
    ReadItem(LNG_KEY_CTRL_ENTER, 'Pe³ny ekran ze zmian¹ rozdzielczoœci');
    ReadItem(LNG_KEY_ESC, 'Powrót do okna z pe³nego ekranu');
    ReadItem(LNG_KEY_CTRL_F4, 'W³¹czenie/wy³¹czenie opcji zamykania systemu po skoñczonym odtwarzaniu');
    ReadItem(LNG_KEY_SHIFT_ESC, 'Minimalizacja programu');
    ReadItem(LNG_KEY_F1, 'Lista skrótów klawiszowych');
    ReadItem(LNG_KEY_F7, 'W³¹czenie/wy³¹czenie lektora');
    ReadItem(LNG_KEY_F8, 'W³¹czenie/wy³¹czenie edytora szybkoœci wyœwietlania napisów (inteligentne napisy)');
    ReadItem(LNG_KEY_F9, 'Pokazanie przez krótk¹ chwilê w OSD aktualnego czasu filmu oraz czasu systemowego');
    ReadItem(LNG_KEY_F10, 'W³¹czenie/wy³¹czenie playlisty');// (na pe³nym ekranie wystarczy przesun¹æ mysz do prawej krawêdzi ekranu)');
    ReadItem(LNG_KEY_F11, 'W³¹czenie/wy³¹czenie edytora napisów');
    ReadItem(LNG_KEY_F12, 'Opcje');
    ReadItem(LNG_KEY_PRINTSCRN, 'Zapis klatki do pliku (opcja wymaga wczeœniejszej aktywacji)');

    Free;
  end;
{$ifdef SAVE_LANG}
  sl := TStringList.Create;
  try
    for i := LNG_FIRST_ITEM to LNG_LAST_ITEM do
    begin
      if LangStor[i] <> '' then
        sl.Add(Copy(Format('%4d=%s', [10000 + i, LangStor[i]]), 2, MaxInt));
    end;
    sl.SaveToFile(ExtractFilePath(ParamStr(0)) + 'temp.lng');
  finally
    sl.Free;
  end;

{$endif}
end;

initialization

  languages_list := tLanguages.Create;

finalization

  languages_list.Free;

end.
