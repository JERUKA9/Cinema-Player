unit dlg_settings;

interface

uses
  Windows, Messages, Classes, SysUtils, commctrl;

type
  TApplyMethod = procedure of object;

function doSettings(parent: HWND; apply_proc: TApplyMethod): DWORD;

var
  settings_visibled: boolean = false;
  audio_renderers_list: string = '';

implementation

uses
  language, xp_theme, cp_utils, subtitles_header, global, subtitles_renderer,
  subtitles_style, settings_header, file_types, cp_dialogs, editctrls,
  clrbtnctrls, cp_graphics, global_consts, uSpeakerEngine;

type
  TSettings = class(TObject)
  private
//    _first_message: boolean;
    _page_rc: TRect;
    _page_dlg_rc: TRect;
    _page_gradient_rc: TRect;
    _page_caption_rc: TRect;
    rc: TRect;
    dlgHandle: THandle;
    txt, txt2: char100;
    _subtitle_example: TSubtitlesRenderer;
    _osd_example: TSubtitlesRenderer;
    _subtitle_font_data: TSubtitlesStyle;
    _osd_font_data: TSubtitlesStyle;
    _apply_proc: TApplyMethod;
    _speaker: TSpeakerEngine;
    function dlgWP(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool;
    function pagePlaylistWP(hWnd: HWND; Msg, wParam,
      lParam: cardinal): LongBool;
    function pageEditorWP(hWnd: HWND; Msg, wParam,
      lParam: cardinal): LongBool;
    function pageFilesWP(hWnd: HWND; Msg, wParam,
      lParam: cardinal): LongBool;
    function pageOSDOtherWP(hWnd: HWND; Msg, wParam,
      lParam: cardinal): LongBool;
    function pagePlayFullScrWP(hWnd: HWND; Msg, wParam,
      lParam: cardinal): LongBool;
    function pagePlayNaviWP(hWnd: HWND; Msg, wParam,
      lParam: cardinal): LongBool;
    function pagePlayOtherWP(hWnd: HWND; Msg, wParam,
      lParam: cardinal): LongBool;
    function pageSbtFontWP(hWnd: HWND; Msg, wParam,
      lParam: cardinal): LongBool;
    function pageSbtOtherWP(hWnd: HWND; Msg, wParam,
      lParam: cardinal): LongBool;
    function pageDirectoriesWP(hWnd: HWND; Msg, wParam,
      lParam: cardinal): LongBool;
    function pageSpeakerWP(hWnd: HWND; Msg, wParam,
      lParam: cardinal): LongBool;
    function pageOtherWP(hWnd: HWND; Msg, wParam,
      lParam: cardinal): LongBool;
    function add_treeitem(name: string; parent: HTREEITEM; hDlg: HWND;
      id: DWORD; hTree: THandle): HTREEITEM;
    procedure DrawGradientRect(dc: HDC; rc: TRect; clFrom, clTo: COLORREF);
    procedure populateList(hList: HWND; s: string; force_pls: boolean;
      add_msg, setitem_msg: cardinal);
    function collectListbox(hList: HWND; check_type: boolean): string;
    procedure populateVideoModes(hCombo: HWND);
    procedure populateVideoFreq(hCombo: HWND; r: string);
    procedure setButtons;
    procedure PrepareSettings(var cs: TConfig);
    procedure RefreshExample(h: HWND);
    function GetFirstSelection(hList: HWND): integer;
    procedure MoveSelected(hListFrom, hListTo: HWND; data_value: DWORD);
    procedure MoveAll(hListFrom, hListTo: HWND; data_value: DWORD);
    procedure SetItem(hList: HWND; index: integer);
    procedure SaveToFile;
    procedure SetApplyButtonState(bEnabled: boolean);
  public
    function Show(parent: HWND): DWORD;
  end;

const
  IDD_SETTINGS                   = 2000;
  IDC_TREE                       = 2001;
  IDC_APPLY                      = 2003;
  IDC_SAVETOFILE                 = 2004;

  IDD_SBT_FONT                   = 4000;
  IDC_LB_EXAMPLE                 = 4001;
  IDC_ED_FONT_NAME               = 4002;
  IDC_LB_FONT_NAME               = 4003;
  IDC_LB_FONT_SIZE               = 4004;
  IDC_ED_FONT_SIZE               = 4005;
  IDC_BT_CHANGE_FONT             = 4006;
  IDC_LB_RENDER                  = 4007;
  IDC_CBO_RENDER                 = 4008;
  IDC_LB_ANTIALIAS               = 4009;
  IDC_CBO_ANTIALIAS              = 4010;
  IDC_CHK_OVERLAY                = 4011;
  IDC_GRP_COLORS                 = 4012;
  IDC_LB_TEXTCOLOR               = 4013;
  IDC_LB_BKGCOLOR                = 4014;
  IDC_BT_DEFCOLORS               = 4015;
  IDC_SHP_TEXTCOLOR              = 4016;
  IDC_SHP_BKGCOLOR               = 4017;

  IDD_SBT_OTHER                  = 5000;
  IDC_GRP_OTHERFONT              = 5001;
  IDC_CHK_AUTOSIZE               = 5002;
  IDC_LB_DISTANCE                = 5003;
  IDC_LB_DISTANCE1               = 5004;
  IDC_IED_DISTANCE               = 5005;
  IDC_LB_SUBROWS                 = 5006;
  IDC_IED_SUBROWS                = 5007;
  IDC_CHK_AUTOTIME               = 5008;
  IDC_LB_CALCTIME                = 5009;
  IDC_IED_CALCTIME               = 5010;
  IDC_LB_CALCTIME2               = 5011;
  IDC_CHK_AUTOPOS                = 5012;
  IDC_CHK_SUBWIDTH               = 5013;
  IDC_IED_SUBWIDTH               = 5014;
  IDC_CBO_SUBWIDTH               = 5015;
  IDC_CHK_LOADSUBTITLES          = 5016;
  IDC_LB_SEARCHINGOUTOFSUBTITLES = 5017;
  IDC_CBO_SEARCHINGOUTOFSUBTITLES= 5018;

  IDD_PLAY_NAVI                  = 6000;
  IDC_LB_LARGESTEPS              = 6001;
  IDC_IED_LARGESTEPS             = 6002;
  IDC_LB_LARGESTEPS2             = 6003;
  IDC_LB_SMALLSTEPS              = 6004;
  IDC_IED_SMALLSTEPS             = 6005;
  IDC_LB_SMALLSTEPS2             = 6006;
  IDC_GRP_MOUSEWHEEL             = 6007;
  IDC_CBO_MOUSEWHEEL             = 6008;
  IDC_CHK_REVERSEWHEEL           = 6009;
  IDC_CHK_PAUSEONCONTROL         = 6010;
  IDC_CHK_PAUSEWHENMINIMIZED     = 6011;
  IDC_CHK_PAUSEAFTERLBUTTONCLICK = 6012;

  IDD_PLAY_FULLSCR               = 7000;
  IDC_LB_HIDECURSOR              = 7001;
  IDC_IED_HIDECURSOR             = 7002;
  IDC_LB_HIDECURSOR2             = 7003;
  IDC_CHK_HIDETASKBAR            = 7004;
  IDC_CHK_AUTOFULLSCREEN         = 7005;
  IDC_CHK_CHANGERESOLUTION       = 7006;
  IDC_CBO_RESOLUTION             = 7007;
  IDC_CBO_FREQUENCY              = 7008;
  IDC_CHK_PANELONTOP             = 7009;
  IDC_CHK_FORCESTDCTRLPANELMODE  = 7010;
  IDC_CHK_DBLCLK2FULLSCR         = 7011;

  IDD_PLAY_OTHER                 = 8000;
  IDC_LB_ASFFPS                  = 8001;
  IDC_CBO_ASFFPS                 = 8002;
  IDC_CHK_AUTOPLAY               = 8003;
  IDC_CHK_CLOSEPLAYER            = 8004;
  IDC_CHK_ONEINSTANCE            = 8005;
  IDC_CHK_SEARCHNEXTPART         = 8006;
  IDC_GRP_CLOSESYSTEM            = 8007;
  IDC_CHK_REMEMBERSUSPENDSTATE   = 8008;
  IDC_CBO_CLOSESYSTEM            = 8009;
  IDC_CHK_SHUTDOWNDELAY          = 8010;
  IDC_IED_SHUTDOWNDELAY          = 8011;
  IDC_LB_SHUTDOWNDELAY           = 8012;
  IDC_LB_AUDIORENDERER           = 8013;
  IDC_CBO_AUDIORENDERER          = 8014;

  IDD_EDITOR                     = 9000;
  IDC_CHK_STOPONERROR            = 9001;

  IDD_OTHER                      = 9500;
  IDC_CHK_CLEARHISTORYATEXIT     = 9501;
  IDC_CHK_DISABLEFRAMERESIZE        = 9502;

  IDD_OSD_FONT                   = 10000;
// reszta identyfikatow jak IDD_SBT_FONT

  IDD_OSD_OTHER                  = 11000;
  IDC_CHK_OSDENABLED             = 11001;
  IDC_CHK_OSDLEFTRIGHT           = 11002;
  IDC_LB_OSDDISPLAYTIME          = 11003;
  IDC_IED_OSDDISPLAYTIME         = 11004;
  IDC_LB_OSDDISPLAYTIME2         = 11005;
  IDC_CHK_OSDCURRENTTIME         = 11006;
  IDC_IED_OSDCURRENTTIME         = 11007;
  IDC_LB_OSDCURRENTTIME          = 11008;
  IDC_LB_OSDTOPPOSITION          = 11009;
  IDC_IED_OSDTOPPOSITION         = 11010;
  IDC_LB_OSDLEFTPOSITION         = 11011;
  IDC_IED_OSDLEFTPOSITION        = 11012;


  IDD_FILES                      = 12000;
  IDC_GRP_FILESSUPPORTED         = 12001;
  IDC_LB_FILESNOTASSOCIATED      = 12002;
  IDC_LB_FILESASSOCIATED         = 12003;
  IDC_LBX_PLSNOTASSOCIATED       = 12004;
  IDC_LBX_FLSNOTASSOCIATED       = 12005;
  IDC_LBX_ASSOCIATED             = 12006;
  IDC_BT_INCLUDE                 = 12007;
  IDC_BT_INCALL                  = 12008;
  IDC_BT_EXCLUDE                 = 12009;
  IDC_BT_EXCALL                  = 12010;
  IDC_ED_ADDEXT                  = 12011;
  IDC_BT_ADDEXT                  = 12012;
  IDC_CHK_ADDTOCONTEXT           = 12013;
  IDC_BT_APPLYCHANGES            = 12014;

  IDD_DIRECTORIES                = 15000;
  IDC_GRP_MOVIEFOLDER            = 15001;
  IDC_ED_MOVIEFOLDER             = 15002;
  IDC_BT_MOVIEFOLDER             = 15003;
  IDC_GRP_SBTFOLDER              = 15004;
  IDC_ED_SBTFOLDER               = 15005;
  IDC_BT_SBTFOLDER               = 15006;
  IDC_GRP_SCRSHOTFOLDER          = 15007;
  IDC_ED_SCRSHOTFOLDER           = 15008;
  IDC_BT_SCRSHOTFOLDER           = 15009;

  IDD_SPEAKER                    = 16000;
  IDC_CHK_SPEAKERENABLE          = 16001;
  IDC_LB_SPEAKERSELECT           = 16002;
  IDC_CBO_SPEAKERSELECT          = 16003;
  IDC_LB_SPEAKERVOLUME           = 16004;
  IDC_SLD_SPEAKERVOLUME          = 16005;
  IDC_LB_SPEAKERRATE             = 16006;
  IDC_SLD_SPEAKERRATE            = 16007;
  IDC_BT_SPEAKERDEF              = 16008;
  IDC_CHK_SPEAKERFLUSHPREV       = 16009;
  IDC_BT_SPEAKERTEST             = 16010;
  IDC_CHK_SPEAKERHIDESUBTITLES   = 16011;

  IDD_PLAYLIST                   = 21000;
  IDC_CHK_SEARCHNEXTPARTONCDROM  = 21001;

  check_state: array[boolean] of byte = (BST_UNCHECKED, BST_CHECKED);

var
  dlgSettings: TSettings;

function doSettings(parent: HWND; apply_proc: TApplyMethod): DWORD;
begin
  dlgSettings := TSettings.Create;
  try
    regIntEditClass;
    regColorButtonClass;
    settings_visibled := true;
    dlgSettings._apply_proc := apply_proc;
    Result := dlgSettings.Show(parent);
  finally
    settings_visibled := false;
    dlgSettings.Free;
    unregIntEditClass;
    unregColorButtonClass;
  end;
end;

function pageSbtFontWndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool; stdcall;
begin
  Result := dlgSettings.pageSbtFontWP(hWnd, Msg, wParam, lParam);
end;

function pageSbtOtherWndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool; stdcall;
begin
  Result := dlgSettings.pageSbtOtherWP(hWnd, Msg, wParam, lParam);
end;

function pagePlayNaviWndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool; stdcall;
begin
  Result := dlgSettings.pagePlayNaviWP(hWnd, Msg, wParam, lParam);
end;

function pagePlayFullScrWndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool; stdcall;
begin
  Result := dlgSettings.pagePlayFullScrWP(hWnd, Msg, wParam, lParam);
end;

function pagePlayOtherWndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool; stdcall;
begin
  Result := dlgSettings.pagePlayOtherWP(hWnd, Msg, wParam, lParam);
end;

function pageEditorWndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool; stdcall;
begin
  Result := dlgSettings.pageEditorWP(hWnd, Msg, wParam, lParam);
end;

function pageOSDOtherWndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool; stdcall;
begin
  Result := dlgSettings.pageOSDOtherWP(hWnd, Msg, wParam, lParam);
end;

function pageFilesWndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool; stdcall;
begin
  Result := dlgSettings.pageFilesWP(hWnd, Msg, wParam, lParam);
end;

function pageDirectoriesWndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool; stdcall;
begin
  Result := dlgSettings.pageDirectoriesWP(hWnd, Msg, wParam, lParam);
end;

function pageSpeakerWndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool; stdcall;
begin
  Result := dlgSettings.pageSpeakerWP(hWnd, Msg, wParam, lParam);
end;

function pagePlaylistWndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool; stdcall;
begin
  Result := dlgSettings.pagePlaylistWP(hWnd, Msg, wParam, lParam);
end;

function dlgWndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool; stdcall;
begin
  Result := dlgSettings.dlgWP(hWnd, Msg, wParam, lParam);
end;

function pageOtherWndProc(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool; stdcall;
begin
  Result := dlgSettings.pageOtherWP(hWnd, Msg, wParam, lParam);
end;

{ TSettings }

function TSettings.Show(parent: HWND): DWORD;
begin
  Result := DialogBox(hInstance, MAKEINTRESOURCE(IDD_SETTINGS), parent, @dlgWndProc);
end;

function TSettings.pageSbtFontWP(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool;
var
  i: integer;
  cl: COLORREF;
  sr: TSubtitlesRenderer;
  pss: PSubtitlesStyle;
  psa: PSbtAttr;
  render_cbo_modifier: byte;
begin
  case Msg of
    WM_INITDIALOG:
    begin
      SetDlgItemText(hWnd, IDC_LB_FONT_NAME, PChar(LangStor[LNG_OPT_FONTNAME]));
      SetDlgItemText(hWnd, IDC_LB_FONT_SIZE, PChar(LangStor[LNG_OPT_FONTSIZE]));
      SetDlgItemText(hWnd, IDC_LB_RENDER, PChar(LangStor[LNG_OPT_RENDERSTYLE]));
      if lParam = IDD_SBT_FONT then
        SendDlgItemMessage(hWnd, IDC_CBO_RENDER, CB_ADDSTRING, 0, integer(PChar(LangStor[LNG_OPT_RENDERRECT])));
      SendDlgItemMessage(hWnd, IDC_CBO_RENDER, CB_ADDSTRING, 0, integer(PChar(LangStor[LNG_OPT_RENDERSOLIDRECTS])));
      SendDlgItemMessage(hWnd, IDC_CBO_RENDER, CB_ADDSTRING, 0, integer(PChar(LangStor[LNG_OPT_RENDERONLYTEXT])));
      SendDlgItemMessage(hWnd, IDC_CBO_RENDER, CB_ADDSTRING, 0, integer(PChar(LangStor[LNG_OPT_RENDERTHINBORDER])));
      SendDlgItemMessage(hWnd, IDC_CBO_RENDER, CB_ADDSTRING, 0, integer(PChar(LangStor[LNG_OPT_RENDERTHICKBORDER])));
      SendDlgItemMessage(hWnd, IDC_CBO_RENDER, CB_ADDSTRING, 0, integer(PChar(LangStor[LNG_OPT_RENDERFATBORDER])));
      SetDlgItemText(hWnd, IDC_LB_ANTIALIAS, PChar(LangStor[LNG_OPT_ANTIALIASING]));
      SendDlgItemMessage(hWnd, IDC_CBO_ANTIALIAS, CB_ADDSTRING, 0, integer(PChar(LangStor[LNG_OPT_ANTIALIASNONE])));
      for i := 1 to 3 do
        SendDlgItemMessage(hWnd, IDC_CBO_ANTIALIAS, CB_ADDSTRING, 0, integer(PChar(Format(LangStor[LNG_OPT_ANTIALIASLEVEL], [i]))));
      SetDlgItemText(hWnd, IDC_BT_CHANGE_FONT, PChar(LangStor[LNG_OPT_CHANGE]));
      SetDlgItemText(hWnd, IDC_GRP_COLORS, PChar(LangStor[LNG_OPT_COLORS]));
      SetDlgItemText(hWnd, IDC_LB_TEXTCOLOR, PChar(LangStor[LNG_OPT_TEXT]));
      SetDlgItemText(hWnd, IDC_LB_BKGCOLOR, PChar(LangStor[LNG_OPT_BORDER]));
      SetDlgItemText(hWnd, IDC_BT_DEFCOLORS, PChar(LangStor[LNG_OPT_RESET]));

      with config do
      begin
        if lParam = IDD_SBT_FONT then
        begin
          _subtitle_example := TSubtitlesRenderer.Create(GetDlgItem(hWnd, IDC_LB_EXAMPLE));
          sr := _subtitle_example;
          _subtitle_font_data := SubtitlesAttr.Style;
          pss := @_subtitle_font_data;
          psa := @SubtitlesAttr;
          render_cbo_modifier := 0;
        end
        else
        begin
          _osd_example := TSubtitlesRenderer.Create(GetDlgItem(hWnd, IDC_LB_EXAMPLE));
          sr := _osd_example;
          _osd_font_data := OSDAttr.Style;
          pss := @_osd_font_data;
          psa := @OSDAttr;
          render_cbo_modifier := 1;
        end;
        CheckDlgButton(hWnd, IDC_CHK_OVERLAY, check_state[psa^.Overlay]);
        SendDlgItemMessage(hWnd, IDC_CBO_RENDER, CB_SETCURSEL, integer(psa^.RenderMode) - render_cbo_modifier, 0);
        SendDlgItemMessage(hWnd, IDC_CBO_ANTIALIAS, CB_SETCURSEL, integer(psa^.AntiAliasing), 0);
        SetDlgItemText(hWnd, IDC_ED_FONT_NAME, pss^.fd.name);
        SetDlgItemText(hWnd, IDC_ED_FONT_SIZE, PChar(IntToStr(pss^.fd.size)));
        SendDlgItemMessage(hWnd, IDC_SHP_TEXTCOLOR, CBM_SETCOLOR, 0, pss^.font_color);
        SendDlgItemMessage(hWnd, IDC_SHP_BKGCOLOR, CBM_SETCOLOR, 0, pss^.bkg_color);
        pss^.position.hPosition := phCenter;
        pss^.position.vPosition := pvCenter;

        sr.set_use_overlay(false);
        GetClientRect(GetDlgItem(hWnd, IDC_LB_EXAMPLE), rc);
        sr.set_parent_rect(rc);
        sr.set_font_scale(1);
        sr.set_attributes(pss^, psa^.RenderMode, psa^.AntiAliasing);
        sr.render(LangStor[LNG_OPT_SAMPLETEXT]);
        sr.enable;
        if lParam = IDD_SBT_FONT then
        begin
          pss^.position := SubtitlesAttr.Style.position;
        end
        else
        begin
          pss^.position := OSDAttr.Style.position;
        end;
      end;
    end;
    WM_COMMAND:
    begin
      case LOWORD(wParam) of
        IDC_BT_CHANGE_FONT:
          if HIWORD(wParam) = BN_CLICKED then
          begin
            if GetWindowLong(hWnd, GWL_ID) = IDD_SBT_FONT then
              pss := @_subtitle_font_data
            else
              pss := @_osd_font_data;
            FontDialog.Font.initialize(pss^.fd);
            FontDialog.FontColor := pss^.font_color;
            if FontDialog.Execute then
            begin
              SetApplyButtonState(true);
              FontDialog.Font.get_font_data(pss^.fd);
              pss^.font_color := FontDialog.FontColor;
              SetDlgItemText(hWnd, IDC_ED_FONT_NAME, pss^.fd.name);
              SetDlgItemInt(hWnd, IDC_ED_FONT_SIZE, pss^.fd.size, true);
              RefreshExample(hWnd);
            end;
          end;
        IDC_SHP_TEXTCOLOR, IDC_SHP_BKGCOLOR:
          if HIWORD(wParam) = BN_CLICKED then
          begin
            if GetWindowLong(hWnd, GWL_ID) = IDD_SBT_FONT then
              pss := @_subtitle_font_data
            else
              pss := @_osd_font_data;
            ColorDialog.Color := SendDlgItemMessage(hWnd, LOWORD(wParam), CBM_GETCOLOR, 0, 0);
            if ColorDialog.Execute then
            begin
              SetApplyButtonState(true);
              SendDlgItemMessage(hWnd, LOWORD(wParam), CBM_SETCOLOR, 0, ColorDialog.Color);
              if LOWORD(wParam) = IDC_SHP_TEXTCOLOR then
                pss^.font_color := ColorDialog.Color
              else
                pss^.bkg_color := ColorDialog.Color;
              RefreshExample(hWnd);
            end;
          end;
        IDC_BT_DEFCOLORS:
          if HIWORD(wParam) = BN_CLICKED then
          begin
            SetApplyButtonState(true);
            if GetWindowLong(hWnd, GWL_ID) = IDD_SBT_FONT then
              cl := $00E0E0E0
            else
              cl := $0011C1EE;
            SendDlgItemMessage(hWnd, IDC_SHP_BKGCOLOR, CBM_SETCOLOR, 0, $00000000);
            SendDlgItemMessage(hWnd, IDC_SHP_TEXTCOLOR, CBM_SETCOLOR, 0, cl);
            RefreshExample(hWnd);
          end;
        IDC_CBO_RENDER, IDC_CBO_ANTIALIAS:
          if HIWORD(wParam) = CBN_SELCHANGE then
          begin
            SetApplyButtonState(true);
            RefreshExample(hWnd);
          end;
        IDC_CHK_OVERLAY:
          if HIWORD(wParam) = BN_CLICKED then
            SetApplyButtonState(true);
      else
        Result := false;
      end;
    end;
    WM_DESTROY:
    begin
      if GetWindowLong(hWnd, GWL_ID) = IDD_SBT_FONT then
        _subtitle_example.Free
      else
        _osd_example.Free;
    end;
  else
    Result := false;
  end;
end;

function TSettings.pageSbtOtherWP(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool;
var
  state: boolean;
  value: UINT;
begin
  case Msg of
    WM_INITDIALOG:
    begin
      SetDlgItemText(hWnd, IDC_CHK_AUTOSIZE, PChar(LangStor[LNG_OPT_AUTOSIZE]));
      SetDlgItemText(hWnd, IDC_LB_DISTANCE, PChar(LangStor[LNG_OPT_DISTANCE]));
      SetDlgItemText(hWnd, IDC_LB_DISTANCE1, PChar(LangStor[LNG_OPT_DISTANCE1]));
      SetDlgItemText(hWnd, IDC_LB_SUBROWS, PChar(LangStor[LNG_OPT_SUBTITLEROWS]));
      SetDlgItemText(hWnd, IDC_CHK_AUTOPOS, PChar(LangStor[LNG_OPT_AUTOADJUSTSUBTITLESPOS]));
      SetDlgItemText(hWnd, IDC_CHK_LOADSUBTITLES, PChar(LangStor[LNG_OPT_LOADSUBTITLES]));
      SetDlgItemText(hWnd, IDC_LB_CALCTIME, PChar(LangStor[LNG_OPT_DISPLAYSUBTITLESTIME]));
      SetDlgItemText(hWnd, IDC_LB_CALCTIME2, PChar(LangStor[LNG_OPT_SECOND]));
      SetDlgItemText(hWnd, IDC_CHK_AUTOTIME, PChar(LangStor[LNG_OPT_AUTOADJUSTSUBTITLESTIME]));
      SetDlgItemText(hWnd, IDC_CHK_SUBWIDTH, PChar(LangStor[LNG_OPT_SUBWIDTH]));
      SendDlgItemMessage(hWnd, IDC_CBO_SUBWIDTH, CB_ADDSTRING, 0, integer(PChar(LangStor[LNG_OPT_PIXEL])));
      SendDlgItemMessage(hWnd, IDC_CBO_SUBWIDTH, CB_ADDSTRING, 0, integer(PChar(LangStor[LNG_PERCENT])));
      SetDlgItemText(hWnd, IDC_LB_SEARCHINGOUTOFSUBTITLES, PChar(LangStor[LNG_OPT_SEARCHINGOUTOFSUBTITLES]));
      SendDlgItemMessage(hWnd, IDC_CBO_SEARCHINGOUTOFSUBTITLES, CB_ADDSTRING, 0, integer(PChar(LangStor[LNG_OPT_SOOSEXACT])));
      SendDlgItemMessage(hWnd, IDC_CBO_SEARCHINGOUTOFSUBTITLES, CB_ADDSTRING, 0, integer(PChar(LangStor[LNG_OPT_SOOSSIMILAR])));
      SendDlgItemMessage(hWnd, IDC_CBO_SEARCHINGOUTOFSUBTITLES, CB_ADDSTRING, 0, integer(PChar(LangStor[LNG_OPT_SOOSUNLIKE])));

      with config do
      begin
        CheckDlgButton(hWnd, IDC_CHK_LOADSUBTITLES, check_state[LoadSubtitles]);
        CheckDlgButton(hWnd, IDC_CHK_AUTOSIZE, check_state[AutoSizeText]);
        SetDlgItemInt(hWnd, IDC_IED_DISTANCE, EdgeSpace, true);
        SendDlgItemMessage(hWnd, IDC_IED_DISTANCE, IEM_SETRANGE, 0, MAKELONG(50, 0));
        SetDlgItemInt(hWnd, IDC_IED_SUBROWS, SubtitleRows, true);
        SendDlgItemMessage(hWnd, IDC_IED_SUBROWS, IEM_SETRANGE, 0, MAKELONG(10, 0));
        CheckDlgButton(hWnd, IDC_CHK_AUTOPOS, check_state[AdjustTextPos]);
        CheckDlgButton(hWnd, IDC_CHK_AUTOTIME, check_state[AutoTextDelay]);
        SendMessage(hWnd, WM_COMMAND, MAKELONG(IDC_CHK_AUTOTIME, BN_CLICKED), 0);
        SetDlgItemInt(hWnd, IDC_IED_CALCTIME, TextDelay, true);
        SendDlgItemMessage(hWnd, IDC_IED_CALCTIME, IEM_SETRANGE, 0, MAKELONG(10, 0));
        SendDlgItemMessage(hWnd, IDC_CBO_SUBWIDTH, CB_SETCURSEL, integer(MaxSubWidthPercent), 0);
        SetDlgItemInt(hWnd, IDC_IED_SUBWIDTH, MaxSubWidth, true);
        if MaxSubWidthPercent then
          SendDlgItemMessage(hWnd, IDC_IED_SUBWIDTH, IEM_SETRANGE, 0, MAKELONG(100, 50))
        else
          SendDlgItemMessage(hWnd, IDC_IED_SUBWIDTH, IEM_SETRANGE, 0, MAKELONG(10000, 500));
        CheckDlgButton(hWnd, IDC_CHK_SUBWIDTH, check_state[MaxSubWidthActive]);
        SendMessage(hWnd, WM_COMMAND, MAKELONG(IDC_CHK_SUBWIDTH, BN_CLICKED), 0);
        SendDlgItemMessage(hWnd, IDC_CBO_SEARCHINGOUTOFSUBTITLES, CB_SETCURSEL, integer(SearchingOutOFSubtitles), 0);
      end;
    end;
    WM_COMMAND:
    begin
      case LOWORD(wParam) of
        IDC_CHK_AUTOTIME:
          if HIWORD(wParam) = BN_CLICKED then
          begin
            SetApplyButtonState(true);
            state := IsDlgButtonChecked(hWnd, IDC_CHK_AUTOTIME) = BST_CHECKED;
            EnableWindow(GetDlgItem(hWnd, IDC_IED_CALCTIME), state);
            EnableWindow(GetDlgItem(hWnd, IDC_LB_CALCTIME), state);
            EnableWindow(GetDlgItem(hWnd, IDC_LB_CALCTIME2), state);
          end;
        IDC_CHK_SUBWIDTH:
          if HIWORD(wParam) = BN_CLICKED then
          begin
            SetApplyButtonState(true);
            state := IsDlgButtonChecked(hWnd, IDC_CHK_SUBWIDTH) = BST_CHECKED;
            EnableWindow(GetDlgItem(hWnd, IDC_IED_SUBWIDTH), state);
            EnableWindow(GetDlgItem(hWnd, IDC_CBO_SUBWIDTH), state);
          end;
        IDC_CBO_SUBWIDTH:
          if HIWORD(wParam) = CBN_SELCHANGE then
          begin
            SetApplyButtonState(true);
            case SendDlgItemMessage(hWnd, IDC_CBO_SUBWIDTH, CB_GETCURSEL, 0, 0) of
              0: // pixele
              begin
                SendDlgItemMessage(hWnd, IDC_IED_SUBWIDTH, IEM_SETRANGE, 0, MAKELONG(10000, 500));
                value := 500;
              end;
              1: // procenty
              begin
                SendDlgItemMessage(hWnd, IDC_IED_SUBWIDTH, IEM_SETRANGE, 0, MAKELONG(100, 50));
                value := 100;
              end;
            end;
            SetDlgItemInt(hWnd, IDC_IED_SUBWIDTH, value, false);
          end;
        IDC_CHK_AUTOSIZE,
        IDC_CHK_AUTOPOS,
        IDC_CHK_LOADSUBTITLES:
          if HIWORD(wParam) = BN_CLICKED then
            SetApplyButtonState(true);
        IDC_IED_DISTANCE,
        IDC_IED_SUBROWS,
        IDC_IED_CALCTIME,
        IDC_IED_SUBWIDTH:
          if HIWORD(wParam) = EN_CHANGE then
            SetApplyButtonState(true);
        IDC_CBO_SEARCHINGOUTOFSUBTITLES:
          if HIWORD(wParam) = CBN_SELCHANGE then
            SetApplyButtonState(true);
      else
        Result := false;
      end;
    end;
    WM_VSCROLL:
      SetApplyButtonState(true);
  else
    Result := false;
  end;
end;

function TSettings.pagePlayNaviWP(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool;
//const
//  radios: array[boolean] of integer = (IDC_RD_WHEELVOLUME, IDC_RD_WHEELPOSITION);
begin
  case Msg of
    WM_INITDIALOG:
    begin
      SetDlgItemText(hWnd, IDC_LB_LARGESTEPS, PChar(LangStor[LNG_OPT_LARGESTEPS]));
      SetDlgItemText(hWnd, IDC_LB_LARGESTEPS2, PChar(LangStor[LNG_OPT_SECOND]));
      SetDlgItemText(hWnd, IDC_LB_SMALLSTEPS, PChar(LangStor[LNG_OPT_SMALLSTEPS]));
      SetDlgItemText(hWnd, IDC_LB_SMALLSTEPS2, PChar(LangStor[LNG_OPT_SECOND]));
      SetDlgItemText(hWnd, IDC_GRP_MOUSEWHEEL, PChar(LangStor[LNG_OPT_MOUSEWHEEL]));
      SendDlgItemMessage(hWnd, IDC_CBO_MOUSEWHEEL, CB_ADDSTRING, 0, integer(PChar(GetHint(LangStor[LNG_OPT_WHEELVOLUME]))));
      SendDlgItemMessage(hWnd, IDC_CBO_MOUSEWHEEL, CB_ADDSTRING, 0, integer(PChar(GetHint(LangStor[LNG_OPT_WHEELPOSITION]))));
      SendDlgItemMessage(hWnd, IDC_CBO_MOUSEWHEEL, CB_ADDSTRING, 0, integer(PChar(GetHint(LangStor[LNG_OPT_WHEELSUBTITLES]))));
      SetDlgItemText(hWnd, IDC_CHK_REVERSEWHEEL, PChar(LangStor[LNG_OPT_REVERSEWHEEL]));
      SetDlgItemText(hWnd, IDC_CHK_PAUSEONCONTROL, PChar(LangStor[LNG_OPT_PAUSEONCONTROL]));
      SetDlgItemText(hWnd, IDC_CHK_PAUSEWHENMINIMIZED, PChar(LangStor[LNG_OPT_PAUSEWHENMINIMIZED]));
      SetDlgItemText(hWnd, IDC_CHK_PAUSEAFTERLBUTTONCLICK, PChar(LangStor[LNG_OPT_PAUSEAFTERLBUTTONCLICK]));
      with config do
      begin
        SetDlgItemInt(hWnd, IDC_IED_LARGESTEPS, PageSize, true);
        SendDlgItemMessage(hWnd, IDC_IED_LARGESTEPS, IEM_SETRANGE, 0, MAKELONG(1000, 0));
        SetDlgItemInt(hWnd, IDC_IED_SMALLSTEPS, LineSize, true);
        SendDlgItemMessage(hWnd, IDC_IED_SMALLSTEPS, IEM_SETRANGE, 0, MAKELONG(100, 0));
        SendDlgItemMessage(hWnd, IDC_CBO_MOUSEWHEEL, CB_SETCURSEL, integer(MouseWheelMode), 0);
        CheckDlgButton(hWnd, IDC_CHK_REVERSEWHEEL, check_state[ReverseWheel]);
        CheckDlgButton(hWnd, IDC_CHK_PAUSEONCONTROL, check_state[PauseOnControl]);
        CheckDlgButton(hWnd, IDC_CHK_PAUSEWHENMINIMIZED, check_state[PauseWhenMinimized]);
        CheckDlgButton(hWnd, IDC_CHK_PAUSEAFTERLBUTTONCLICK, check_state[PauseAfterClick]);
      end;
    end;
    WM_COMMAND:
      case LOWORD(wParam) of
        IDC_CBO_MOUSEWHEEL:
          if HIWORD(wParam) = CBN_SELCHANGE then
            SetApplyButtonState(true);
        IDC_CHK_PAUSEONCONTROL,
        IDC_CHK_PAUSEWHENMINIMIZED,
        IDC_CHK_PAUSEAFTERLBUTTONCLICK,
        IDC_CHK_REVERSEWHEEL:
          if HIWORD(wParam) = BN_CLICKED then
            SetApplyButtonState(true);
        IDC_IED_LARGESTEPS,
        IDC_IED_SMALLSTEPS:
          if HIWORD(wParam) = EN_CHANGE then
            SetApplyButtonState(true);
      end;
    WM_VSCROLL:
      SetApplyButtonState(true);
  else
    Result := false;
  end;
end;

function TSettings.pagePlayFullScrWP(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool;
begin
  case Msg of
    WM_INITDIALOG:
    begin
      SetDlgItemText(hWnd, IDC_LB_HIDECURSOR, PChar(LangStor[LNG_OPT_HIDECURSOR]));
      SetDlgItemText(hWnd, IDC_LB_HIDECURSOR2, PChar(LangStor[LNG_OPT_SECOND]));
      SetDlgItemText(hWnd, IDC_CHK_HIDETASKBAR, PChar(LangStor[LNG_OPT_HIDETASKBAR]));
      SetDlgItemText(hWnd, IDC_CHK_AUTOFULLSCREEN, PChar(LangStor[LNG_OPT_AUTOFULLSCREEN]));
      SetDlgItemText(hWnd, IDC_CHK_CHANGERESOLUTION, PChar(LangStor[LNG_OPT_CHANGERESOLUTION]));
      SetDlgItemText(hWnd, IDC_CHK_PANELONTOP, PChar(LangStor[LNG_OPT_PANELONTOP]));
      SetDlgItemText(hWnd, IDC_CHK_FORCESTDCTRLPANELMODE, PChar(LangStor[LNG_OPT_FORCESTDCTRLPANELMODE]));
      SetDlgItemText(hWnd, IDC_CHK_DBLCLK2FULLSCR, PChar(LangStor[LNG_OPT_DBLCLK2FULLSCR]));
      with config do
      begin
        SetDlgItemInt(hWnd, IDC_IED_HIDECURSOR, TurnOffCur div 1000, true);
        SendDlgItemMessage(hWnd, IDC_IED_HIDECURSOR, IEM_SETRANGE, 0, MAKELONG(10, 0));
        CheckDlgButton(hWnd, IDC_CHK_HIDETASKBAR, check_state[HideTaskBar]);
        CheckDlgButton(hWnd, IDC_CHK_AUTOFULLSCREEN, check_state[AutoFullScreen <> afsNone]);
        SendMessage(hWnd, WM_COMMAND, MAKELONG(IDC_CHK_AUTOFULLSCREEN, BN_CLICKED), 0);

        CheckDlgButton(hWnd, IDC_CHK_CHANGERESOLUTION, check_state[AutoFullScreen = afsFFS]);
        CheckDlgButton(hWnd, IDC_CHK_PANELONTOP, check_state[PanelOnTop]);
        CheckDlgButton(hWnd, IDC_CHK_FORCESTDCTRLPANELMODE, check_state[ForceStdCtrlPanelMode]);
        CheckDlgButton(hWnd, IDC_CHK_DBLCLK2FULLSCR, check_state[DblClick2FullScr]);

        populateVideoModes(GetDlgItem(hWnd, IDC_CBO_RESOLUTION));
        txt[GetDlgItemText(hWnd, IDC_CBO_RESOLUTION, txt, 100)] := #0;
        populateVideoFreq(GetDlgItem(hWnd, IDC_CBO_FREQUENCY), txt);
      end
    end;
    WM_COMMAND:
    begin
      case LOWORD(wParam) of
        IDC_CHK_AUTOFULLSCREEN:
          if HIWORD(wParam) = BN_CLICKED then
          begin
            SetApplyButtonState(true);
            EnableWindow(
               GetDlgItem(hWnd, IDC_CHK_CHANGERESOLUTION),
               IsDlgButtonChecked(hWnd, IDC_CHK_AUTOFULLSCREEN) = BST_CHECKED);
          end;
        IDC_CBO_RESOLUTION:
          if HIWORD(wParam) = CBN_SELCHANGE then
          begin
            SetApplyButtonState(true);
            txt[GetDlgItemText(hWnd, IDC_CBO_RESOLUTION, txt, 100)] := #0;
            populateVideoFreq(GetDlgItem(hWnd, IDC_CBO_FREQUENCY), txt);
          end;
        IDC_CHK_HIDETASKBAR,
        IDC_CHK_CHANGERESOLUTION,
        IDC_CHK_PANELONTOP,
        IDC_CHK_FORCESTDCTRLPANELMODE,
        IDC_CHK_DBLCLK2FULLSCR:
          if HIWORD(wParam) = BN_CLICKED then
            SetApplyButtonState(true);
        IDC_CBO_FREQUENCY:
          if HIWORD(wParam) = CBN_SELCHANGE then
            SetApplyButtonState(true);
        IDC_IED_HIDECURSOR:
          if HIWORD(wParam) = EN_CHANGE then
            SetApplyButtonState(true);
      else
        Result := false;
      end;
    end;
    WM_VSCROLL:
      SetApplyButtonState(true);
  else
    Result := false;
  end;
end;

function TSettings.pagePlayOtherWP(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool;
//const
//  radios: array[boolean] of integer = (IDC_RD_SUSPENDSYSTEM, IDC_RD_SHUTDOWNSYSTEM);
var
  fold: string;
  state: boolean;
begin
  case Msg of
    WM_INITDIALOG:
    begin
      SetDlgItemText(hWnd, IDC_LB_ASFFPS, PChar(LangStor[LNG_OPT_ASFFPS]));
      SetDlgItemText(hWnd, IDC_CHK_AUTOPLAY, PChar(LangStor[LNG_OPT_AUTOPLAY]));
      SetDlgItemText(hWnd, IDC_CHK_CLOSEPLAYER, PChar(LangStor[LNG_OPT_CLOSEPLAYER]));
      SetDlgItemText(hWnd, IDC_CHK_ONEINSTANCE, PChar(LangStor[LNG_OPT_ONEINSTANCE]));
      SetDlgItemText(hWnd, IDC_LB_AUDIORENDERER, PChar(LangStor[LNG_OPT_AUDIOOUTPUT]));
      SendDlgItemMessage(hWnd, IDC_CBO_AUDIORENDERER, CB_ADDSTRING, 0, integer(PChar(GetHint(LangStor[LNG_DEFAULT]))));
      SetDlgItemText(hWnd, IDC_GRP_CLOSESYSTEM, PChar(LangStor[LNG_OPT_CLOSESYSTEM]));
      SetDlgItemText(hWnd, IDC_CHK_REMEMBERSUSPENDSTATE, PChar(LangStor[LNG_OPT_REMEMBERSUSPENDSTATE]));
      SendDlgItemMessage(hWnd, IDC_CBO_CLOSESYSTEM, CB_ADDSTRING, 0, integer(PChar(GetHint(LangStor[LNG_OPT_SUSPENDSYSTEM]))));
      SendDlgItemMessage(hWnd, IDC_CBO_CLOSESYSTEM, CB_ADDSTRING, 0, integer(PChar(GetHint(LangStor[LNG_OPT_SHUTDOWNSYSTEM]))));
      SendDlgItemMessage(hWnd, IDC_CBO_CLOSESYSTEM, CB_ADDSTRING, 0, integer(PChar(GetHint(LangStor[LNG_OPT_HIBERNATESYSTEM]))));
      SetDlgItemText(hWnd, IDC_CHK_SHUTDOWNDELAY, PChar(LangStor[LNG_OPT_SHUTDOWNDELAY]));
      SetDlgItemText(hWnd, IDC_LB_SHUTDOWNDELAY, PChar(LangStor[LNG_OPT_SECOND]));
      with config do
      begin
        populateList(GetDlgItem(hWnd, IDC_CBO_ASFFPS), asf_list, false, CB_ADDSTRING, CB_SETITEMDATA);
        SetDlgItemText(hWnd, IDC_CBO_ASFFPS, PChar(FloatToStr(DefaultFPS)));
        CheckDlgButton(hWnd, IDC_CHK_AUTOPLAY, check_state[Autoplay]);
        CheckDlgButton(hWnd, IDC_CHK_CLOSEPLAYER, check_state[CloseAfterPlay]);
        CheckDlgButton(hWnd, IDC_CHK_ONEINSTANCE, check_state[OneCopy]);
        populateList(GetDlgItem(hWnd, IDC_CBO_AUDIORENDERER), audio_renderers_list, false, CB_ADDSTRING, CB_SETITEMDATA);
        SendDlgItemMessage(hWnd, IDC_CBO_AUDIORENDERER, CB_SETCURSEL, AudioRenderer, 0);

        CheckDlgButton(hWnd, IDC_CHK_REMEMBERSUSPENDSTATE, check_state[RememberSuspendState]);
        SendDlgItemMessage(hWnd, IDC_CBO_CLOSESYSTEM, CB_SETCURSEL, Shutdown, 0);
        CheckDlgButton(hWnd, IDC_CHK_SHUTDOWNDELAY, check_state[WaitShutdown]);
        SendMessage(hWnd, WM_COMMAND, MAKELONG(IDC_CHK_SHUTDOWNDELAY, BN_CLICKED), 0);

        SetDlgItemInt(hWnd, IDC_IED_SHUTDOWNDELAY, ShutdownDelay, true);
        SendDlgItemMessage(hWnd, IDC_IED_SHUTDOWNDELAY, IEM_SETRANGE, 0, MAKELONG(60, 0));
      end;
    end;
    WM_COMMAND:
      case LOWORD(wParam) of
        IDC_CBO_ASFFPS:
        begin
          if HIWORD(wParam) = CBN_KILLFOCUS then
          begin
            try
              txt[GetWindowText(lParam, txt, 100)] := #0;
              if StrToFloat(txt) <= 0 then
                raise ERangeError.Create('');
            except
              SetFocus(lParam);
              MessageBeep(MB_ICONHAND);
            end;
          end;
          if HIWORD(wParam) = CBN_EDITCHANGE then
            SetApplyButtonState(true);
        end;
        IDC_CHK_SHUTDOWNDELAY:
          if HIWORD(wParam) = BN_CLICKED then
          begin
            SetApplyButtonState(true);
            state := IsDlgButtonChecked(hWnd, IDC_CHK_SHUTDOWNDELAY) = BST_CHECKED;
            EnableWindow(GetDlgItem(hWnd, IDC_IED_SHUTDOWNDELAY), state);
            EnableWindow(GetDlgItem(hWnd, IDC_LB_SHUTDOWNDELAY), state);
          end;
        IDC_CHK_AUTOPLAY,
        IDC_CHK_CLOSEPLAYER,
        IDC_CHK_ONEINSTANCE,
        IDC_CHK_REMEMBERSUSPENDSTATE:
          if HIWORD(wParam) = BN_CLICKED then
            SetApplyButtonState(true);
        IDC_IED_SHUTDOWNDELAY:
          if HIWORD(wParam) = EN_CHANGE then
            SetApplyButtonState(true);
        IDC_CBO_CLOSESYSTEM,
        IDC_CBO_AUDIORENDERER:
          if HIWORD(wParam) = CBN_SELCHANGE then
            SetApplyButtonState(true);
      else
        Result := false;
      end;
    WM_VSCROLL:
      SetApplyButtonState(true);
  else
    Result := false;
  end;
end;

function TSettings.pagePlaylistWP(hWnd: HWND; Msg, wParam,
  lParam: cardinal): LongBool;
begin
  case Msg of
    WM_INITDIALOG:
    begin
      SetDlgItemText(hWnd, IDC_CHK_SEARCHNEXTPART, PChar(LangStor[LNG_OPT_SEARCHNEXTPART]));
      SetDlgItemText(hWnd, IDC_CHK_SEARCHNEXTPARTONCDROM, PChar(LangStor[LNG_OPT_SEARCHNEXTPARTONCDROM]));
      CheckDlgButton(hWnd, IDC_CHK_SEARCHNEXTPART, check_state[config.SearchNextMoviePart]);
      CheckDlgButton(hWnd, IDC_CHK_SEARCHNEXTPARTONCDROM, check_state[config.SearchNextMoviePartOnCDROM]);
      pagePlaylistWP(hWnd, WM_COMMAND, MAKELONG(IDC_CHK_SEARCHNEXTPART, BN_CLICKED), 0);
    end;
    WM_COMMAND:
    begin
      case LOWORD(wParam) of
        IDC_CHK_SEARCHNEXTPART:
          if HIWORD(wParam) = BN_CLICKED then
            EnableWindow(GetDlgItem(hWnd, IDC_CHK_SEARCHNEXTPARTONCDROM), IsDlgButtonChecked(hWnd, IDC_CHK_SEARCHNEXTPART) = BST_CHECKED);
      end;
      SetApplyButtonState(true);
    end;
  else
    Result := false;
  end;
end;

function TSettings.pageEditorWP(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool;
begin
  case Msg of
    WM_INITDIALOG:
    begin
      SetDlgItemText(hWnd, IDC_CHK_STOPONERROR, PChar(LangStor[LNG_OPT_STOPONERROR]));
      CheckDlgButton(hWnd, IDC_CHK_STOPONERROR, check_state[config.StopOnError]);
    end;
    WM_COMMAND:
      SetApplyButtonState(true);
  else
    Result := false;
  end;
end;

function TSettings.pageOtherWP(hWnd: HWND; Msg, wParam,
  lParam: cardinal): LongBool;
begin
  case Msg of
    WM_INITDIALOG:
    begin
      SetDlgItemText(hWnd, IDC_CHK_CLEARHISTORYATEXIT, PChar(LangStor[LNG_OPT_CLEARHISTORYATEXIT]));
      CheckDlgButton(hWnd, IDC_CHK_CLEARHISTORYATEXIT, check_state[config.ClearHistoryAtExit]);
      SetDlgItemText(hWnd, IDC_CHK_DISABLEFRAMERESIZE, PChar(LangStor[LNG_OPT_DISABLEFRAMERESIZE]));
      CheckDlgButton(hWnd, IDC_CHK_DISABLEFRAMERESIZE, check_state[config.DisableResizeFrame]);
    end;
    WM_COMMAND:
      SetApplyButtonState(true);
  else
    Result := false;
  end;
end;


function TSettings.pageDirectoriesWP(hWnd: HWND; Msg, wParam,
  lParam: cardinal): LongBool;
var
  fold: string;
  state: boolean;
begin
  case Msg of
    WM_INITDIALOG:
    begin
      SetDlgItemText(hWnd, IDC_GRP_MOVIEFOLDER, PChar(LangStor[LNG_OPT_MOVIEFOLDER]));
      SetDlgItemText(hWnd, IDC_GRP_SBTFOLDER, PChar(LangStor[LNG_OPT_SUBTITLESFOLDER]));
      SetDlgItemText(hWnd, IDC_GRP_SCRSHOTFOLDER, PChar(LangStor[LNG_OPT_SCRSHOTFOLDER]));
      with config do
      begin
        SetDlgItemText(hWnd, IDC_ED_MOVIEFOLDER, PChar(MovieFolder));
        SetDlgItemText(hWnd, IDC_ED_SBTFOLDER, PChar(SubtitlesFolder));
        SetDlgItemText(hWnd, IDC_ED_SCRSHOTFOLDER, PChar(ScreenShotFolder));
      end;
    end;
    WM_COMMAND:
    begin
      case LOWORD(wParam) of
        IDC_BT_MOVIEFOLDER, IDC_BT_SBTFOLDER, IDC_BT_SCRSHOTFOLDER:
          if HIWORD(wParam) = BN_CLICKED then
          begin
            SetLength(fold, 1024);
// identyfikator kotrolki EDIT powinien byc o jeden mniejszy ni¿ odpowiadaj¹cy
// mu BUTTON: LOWORD(wParam) - 1
            fold[GetDlgItemText(hWnd, LOWORD(wParam) - 1, PChar(fold), 1024) + 1] := #0;
            if fold = '' then
              fold := ExtractFilePath(ParamStr(0));
            if SelectDirectory(
                 dlgHandle,
                 LangStor[LNG_DIALOG_SELECTFOLDER],
                 desktop_name,
                 fold,
                 fold) then
            begin
              SetApplyButtonState(true);
              SetDlgItemText(hWnd, LOWORD(wParam) - 1, PChar(fold));
            end;
          end;
      else
        Result := false;
      end;
    end;
  else
    Result := false;
  end;
end;

function TSettings.pageSpeakerWP(hWnd: HWND; Msg, wParam,
  lParam: cardinal): LongBool;
var
  state: boolean;
  i: integer;
begin
  case Msg of
    WM_INITDIALOG:
    begin
      SetDlgItemText(hWnd, IDC_CHK_SPEAKERENABLE, PChar(LangStor[LNG_OPT_SPEAKERENABLE]));
      SetDlgItemText(hWnd, IDC_CHK_SPEAKERFLUSHPREV, PChar(LangStor[LNG_OPT_SPEAKERFLUSHPREV]));
      SetDlgItemText(hWnd, IDC_CHK_SPEAKERHIDESUBTITLES, PChar(LangStor[LNG_OPT_SPEAKERHIDESUBTITLES]));
      SetDlgItemText(hWnd, IDC_LB_SPEAKERSELECT, PChar(LangStor[LNG_OPT_SPEAKERSELECT]));
      _speaker := TSpeakerEngine.Create();
      if _speaker.Initialise then
      begin
        for i := 0 to _speaker.getVoicesCount - 1 do
          SendDlgItemMessage(hWnd, IDC_CBO_SPEAKERSELECT, CB_ADDSTRING, 0, integer(PChar(_speaker.voices[i])));
      end;
      SetDlgItemText(hWnd, IDC_LB_SPEAKERVOLUME, PChar(LangStor[LNG_OPT_SPEAKERVOLUME]));
      SetDlgItemText(hWnd, IDC_LB_SPEAKERRATE, PChar(LangStor[LNG_OPT_SPEAKERRATE]));
      SetDlgItemText(hWnd, IDC_BT_SPEAKERTEST, PChar(LangStor[LNG_OPT_SPEAKERTEST]));
      SetDlgItemText(hWnd, IDC_BT_SPEAKERDEF, PChar(LangStor[LNG_OPT_RESET]));
      with config do
      begin
        CheckDlgButton(hWnd, IDC_CHK_SPEAKERENABLE, check_state[SpeakerEnabled]);
        CheckDlgButton(hWnd, IDC_CHK_SPEAKERFLUSHPREV, check_state[SpeakerFlushPrevPhrase]);
        CheckDlgButton(hWnd, IDC_CHK_SPEAKERHIDESUBTITLES, check_state[SpeakerHideSubtitles]);
        SendMessage(hWnd, WM_COMMAND, MAKELONG(IDC_CHK_SPEAKERENABLE, BN_CLICKED), 0);
        SendDlgItemMessage(hWnd, IDC_CBO_SPEAKERSELECT, CB_SETCURSEL, SpeakerSelected, 0);
        SendDlgItemMessage(hWnd, IDC_SLD_SPEAKERVOLUME, TBM_SETRANGE, 1, MAKELONG(0, 100));
        SendDlgItemMessage(hWnd, IDC_SLD_SPEAKERVOLUME, TBM_SETTICFREQ, 10, 0);
        SendDlgItemMessage(hWnd, IDC_SLD_SPEAKERVOLUME, TBM_SETPOS, 1, SpeakerVolume);
        SendDlgItemMessage(hWnd, IDC_SLD_SPEAKERRATE, TBM_SETRANGE, 1, MAKELONG(0, 100));
        SendDlgItemMessage(hWnd, IDC_SLD_SPEAKERRATE, TBM_SETTICFREQ, 10, 0);
        SendDlgItemMessage(hWnd, IDC_SLD_SPEAKERRATE, TBM_SETPOS, 1, SpeakerRate);
        pageSpeakerWP(hWnd, WM_COMMAND, MAKELONG(IDC_CBO_SPEAKERSELECT, CBN_SELCHANGE), 0);
        pageSpeakerWP(hWnd, WM_COMMAND, MAKELONG(IDC_CHK_SPEAKERENABLE, BN_CLICKED), 0);
      end;
    end;
    WM_COMMAND:
    begin
      case LOWORD(wParam) of
        IDC_CHK_SPEAKERENABLE:
          if HIWORD(wParam) = BN_CLICKED then
          begin
            SetApplyButtonState(true);
            state := IsDlgButtonChecked(hWnd, IDC_CHK_SPEAKERENABLE) = BST_CHECKED;
            EnableWindow(GetDlgItem(hWnd, IDC_LB_SPEAKERSELECT), state);
            EnableWindow(GetDlgItem(hWnd, IDC_CBO_SPEAKERSELECT), state);
            EnableWindow(GetDlgItem(hWnd, IDC_LB_SPEAKERVOLUME), state and _speaker.volumeAvailable());
            EnableWindow(GetDlgItem(hWnd, IDC_SLD_SPEAKERVOLUME), state and _speaker.volumeAvailable());
            EnableWindow(GetDlgItem(hWnd, IDC_LB_SPEAKERRATE), state and _speaker.rateAvailable());
            EnableWindow(GetDlgItem(hWnd, IDC_SLD_SPEAKERRATE), state and _speaker.rateAvailable());
            EnableWindow(GetDlgItem(hWnd, IDC_BT_SPEAKERTEST), state);
            EnableWindow(GetDlgItem(hWnd, IDC_BT_SPEAKERDEF), state);
            EnableWindow(GetDlgItem(hWnd, IDC_CHK_SPEAKERFLUSHPREV), state);
            EnableWindow(GetDlgItem(hWnd, IDC_CHK_SPEAKERHIDESUBTITLES), state);
          end;
        IDC_CBO_SPEAKERSELECT:
          if HIWORD(wParam) = CBN_SELCHANGE then
          begin
            SetApplyButtonState(true);
            state := IsDlgButtonChecked(hWnd, IDC_CHK_SPEAKERENABLE) = BST_CHECKED;
            _speaker.changeVoice(
              SendDlgItemMessage(hWnd, LOWORD(wParam), CB_GETCURSEL, 0, 0),
              SendDlgItemMessage(hWnd, IDC_SLD_SPEAKERVOLUME, TBM_GETPOS, 0, 0),
              SendDlgItemMessage(hWnd, IDC_SLD_SPEAKERRATE, TBM_GETPOS, 0, 0));
            EnableWindow(GetDlgItem(hWnd, IDC_SLD_SPEAKERVOLUME), _speaker.volumeAvailable() and state);
            EnableWindow(GetDlgItem(hWnd, IDC_LB_SPEAKERVOLUME), _speaker.volumeAvailable() and state);
            EnableWindow(GetDlgItem(hWnd, IDC_SLD_SPEAKERRATE), _speaker.rateAvailable() and state);
            EnableWindow(GetDlgItem(hWnd, IDC_LB_SPEAKERRATE), _speaker.rateAvailable() and state);
          end;
        IDC_BT_SPEAKERDEF:
          if HIWORD(wParam) = BN_CLICKED then
          begin
            SetApplyButtonState(true);
            _speaker.resetSettings();
            SendDlgItemMessage(hWnd, IDC_SLD_SPEAKERVOLUME, TBM_SETPOS, 1, _speaker.getVolume());
            SendDlgItemMessage(hWnd, IDC_SLD_SPEAKERRATE, TBM_SETPOS, 1, _speaker.getRate());
          end;
        IDC_BT_SPEAKERTEST:
          if HIWORD(wParam) = BN_CLICKED then
          begin
            _speaker.flush();
            _speaker.setVolume(SendDlgItemMessage(hWnd, IDC_SLD_SPEAKERVOLUME, TBM_GETPOS, 0, 0));
            _speaker.setRate(SendDlgItemMessage(hWnd, IDC_SLD_SPEAKERRATE, TBM_GETPOS, 0, 0));
            _speaker.speak(LangStor[LNG_OPT_SAMPLETEXT]);
          end;
        IDC_CHK_SPEAKERFLUSHPREV,
        IDC_CHK_SPEAKERHIDESUBTITLES:
          if HIWORD(wParam) = BN_CLICKED then
            SetApplyButtonState(true);
      else
        Result := false;
      end;
    end;
    WM_HSCROLL:
    begin
      case GetDlgCtrlID(lParam) of
        IDC_SLD_SPEAKERVOLUME,
        IDC_SLD_SPEAKERRATE:
        begin
          SetApplyButtonState(true);
        end;
      end;
    end;
    WM_DESTROY:
    begin
      _speaker.Free;
    end;
  else
    Result := false;
  end;
end;

procedure TSettings.populateList(hList: HWND; s: string; force_pls: boolean;
      add_msg, setitem_msg: cardinal);
var
  i: integer;
  tmp: string;
  item_data: DWORD;
begin
  while s <> '' do
  begin
    if s[1] = #13 then
      Delete(s, 1, 1);
    i := Pos(#13, s);
    if i = 0 then
    begin
      tmp := s;
      i := MaxInt;
    end
    else
      tmp := Copy(s, 1, i - 1);
    if force_pls or (tmp[1] = '!') then
    begin
      if tmp[1] = '!' then
        Delete(tmp, 1, 1);
      item_data := 1;
    end
    else
      item_data := 0;
    while (tmp <> '') and (tmp[1] < #32) do
      Delete(tmp, 1, 1);

    SendMessage(
      hList,
      setitem_msg,
      SendMessage(hList, add_msg, 0, integer(PChar(tmp))),
      item_data);
    Delete(s, 1, i);
  end;
end;

function TSettings.collectListbox(hList: HWND; check_type: boolean): string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to SendMessage(hList, LB_GETCOUNT, 0, 0) - 1 do
  begin
    if check_type and (SendMessage(hList, LB_GETITEMDATA, i, 0) = 1) then
      Result := Result + '!';
    txt[SendMessage(hList, LB_GETTEXT, i, integer(@txt))] := #0;
    Result := Result + txt + #13;
  end;
end;

function TSettings.pageFilesWP(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool;
var
  fls, pls, assoc: TStringList;
  index, i: Integer;
begin                
  case Msg of
    WM_INITDIALOG:
    begin
      SetDlgItemText(hWnd, IDC_GRP_FILESSUPPORTED, PChar(LangStor[LNG_OPT_FILESSUPPORTED]));
      SetDlgItemText(hWnd, IDC_LB_FILESNOTASSOCIATED, PChar(LangStor[LNG_OPT_FILESNOTASSOCIATED]));
      SetDlgItemText(hWnd, IDC_LB_FILESASSOCIATED, PChar(LangStor[LNG_OPT_FILESASSOCIATED]));
      SetDlgItemText(hWnd, IDC_CHK_ADDTOCONTEXT,
        PChar(Format(LangStor[LNG_OPT_ADDTOCONTEXT], [GetHint(LangStor[LNG_SHELLMENU_OPENWITH]) + ' ' + ProgName])));
      SetDlgItemText(hWnd, IDC_BT_APPLYCHANGES, PChar(LangStor[LNG_OPT_APPLYCHANGES]));

      with config do
      begin
        populateList(GetDlgItem(hWnd, IDC_LBX_PLSNOTASSOCIATED), SupportedPLS, true, LB_ADDSTRING, LB_SETITEMDATA);
        populateList(GetDlgItem(hWnd, IDC_LBX_FLSNOTASSOCIATED), Supported, false, LB_ADDSTRING, LB_SETITEMDATA);
        populateList(GetDlgItem(hWnd, IDC_LBX_ASSOCIATED), Associated, false, LB_ADDSTRING, LB_SETITEMDATA);
        CheckDlgButton(hWnd, IDC_CHK_ADDTOCONTEXT, check_state[AddOpenWith]);
        SetButtons;
      end;
    end;
    WM_COMMAND:
    begin
      case LOWORD(wParam) of
        IDC_BT_APPLYCHANGES:
          if HIWORD(wParam) = BN_CLICKED then
          begin
            with config do
            begin
              AddOpenWith := IsDlgButtonChecked(hWnd, IDC_CHK_ADDTOCONTEXT) = BST_CHECKED;
              Supported := collectListbox(GetDlgItem(hWnd, IDC_LBX_FLSNOTASSOCIATED), false);
              SupportedPLS := collectListbox(GetDlgItem(hWnd, IDC_LBX_PLSNOTASSOCIATED), false);
              Associated := collectListbox(GetDlgItem(hWnd, IDC_LBX_ASSOCIATED), true);
              fls := TStringList.Create;
              pls := TStringList.Create;
              assoc := TStringList.Create;
              try
                fls.Text := Supported;
                pls.Text := SupportedPLS;
                assoc.Text := Associated;
                RegisterFiles(pls, fls, assoc, false);
              finally
                fls.Free;
                pls.Free;
                assoc.Free;
              end;
            end;

            SaveFileTypes;
          end;
        IDC_BT_INCLUDE:
          if HIWORD(wParam) = BN_CLICKED then
          begin
            index := GetFirstSelection(GetDlgItem(hWnd, IDC_LBX_PLSNOTASSOCIATED));
            if index <> LB_ERR then
            begin
              MoveSelected(GetDlgItem(hWnd, IDC_LBX_PLSNOTASSOCIATED), GetDlgItem(hWnd, IDC_LBX_ASSOCIATED), 1);
              SetItem(GetDlgItem(hWnd, IDC_LBX_PLSNOTASSOCIATED), index);
            end;

            index := GetFirstSelection(GetDlgItem(hWnd, IDC_LBX_FLSNOTASSOCIATED));
            if index <> LB_ERR then
            begin
              MoveSelected(GetDlgItem(hWnd, IDC_LBX_FLSNOTASSOCIATED), GetDlgItem(hWnd, IDC_LBX_ASSOCIATED), 0);
              SetItem(GetDlgItem(hWnd, IDC_LBX_FLSNOTASSOCIATED), index);
            end;
          end;
        IDC_BT_INCALL:
          if HIWORD(wParam) = BN_CLICKED then
          begin
            MoveAll(GetDlgItem(hWnd, IDC_LBX_PLSNOTASSOCIATED), GetDlgItem(hWnd, IDC_LBX_ASSOCIATED), 1);
            SetItem(GetDlgItem(hWnd, IDC_LBX_PLSNOTASSOCIATED), 0);

            MoveAll(GetDlgItem(hWnd, IDC_LBX_FLSNOTASSOCIATED), GetDlgItem(hWnd, IDC_LBX_ASSOCIATED), 0);
            SetItem(GetDlgItem(hWnd, IDC_LBX_FLSNOTASSOCIATED), 0);
          end;
        IDC_BT_EXCLUDE:
          if HIWORD(wParam) = BN_CLICKED then
          begin
            index := GetFirstSelection(GetDlgItem(hWnd, IDC_LBX_ASSOCIATED));
            if index <> -1 then
            begin
              MoveSelected(GetDlgItem(hWnd, IDC_LBX_ASSOCIATED), GetDlgItem(hWnd, IDC_LBX_PLSNOTASSOCIATED), 1);
              MoveSelected(GetDlgItem(hWnd, IDC_LBX_ASSOCIATED), GetDlgItem(hWnd, IDC_LBX_FLSNOTASSOCIATED), 0);
//              MoveSelected(GetDlgItem(hWnd, IDC_LBX_PLSNOTASSOCIATED), GetDlgItem(hWnd, IDC_LBX_ASSOCIATED), 1);
//              MoveSelected(GetDlgItem(hWnd, IDC_LBX_FLSNOTASSOCIATED), GetDlgItem(hWnd, IDC_LBX_ASSOCIATED), 0);
              SetItem(GetDlgItem(hWnd, IDC_LBX_ASSOCIATED), index);
            end;
          end;
        IDC_BT_EXCALL:
          if HIWORD(wParam) = BN_CLICKED then
          begin
            MoveAll(GetDlgItem(hWnd, IDC_LBX_ASSOCIATED), GetDlgItem(hWnd, IDC_LBX_PLSNOTASSOCIATED), 1);
            SetItem(GetDlgItem(hWnd, IDC_LBX_ASSOCIATED), 0);

            MoveAll(GetDlgItem(hWnd, IDC_LBX_ASSOCIATED), GetDlgItem(hWnd, IDC_LBX_FLSNOTASSOCIATED), 0);
            SetItem(GetDlgItem(hWnd, IDC_LBX_ASSOCIATED), 0);
          end;
        IDC_BT_ADDEXT:
          if HIWORD(wParam) = BN_CLICKED then
          begin
            txt[GetDlgItemText(hWnd, IDC_ED_ADDEXT, txt, 100)] := #0;
            if (SendDlgItemMessage(hWnd, IDC_LBX_ASSOCIATED, LB_FINDSTRING, -1, integer(@txt)) = LB_ERR) and
               (SendDlgItemMessage(hWnd, IDC_LBX_FLSNOTASSOCIATED, LB_FINDSTRING, -1, integer(@txt)) = LB_ERR) then
            begin
              SendDlgItemMessage(hWnd, IDC_LBX_FLSNOTASSOCIATED, LB_ADDSTRING, 0, integer(@txt));
              EnableWindow(GetDlgItem(hWnd, IDC_BT_INCLUDE), true);
              EnableWindow(GetDlgItem(hWnd, IDC_BT_INCALL), true);
            end
            else
              Beep;
          end;
        IDC_ED_ADDEXT:
          if HIWORD(wParam) = EN_CHANGE then
          begin
            txt[GetDlgItemText(hWnd, IDC_ED_ADDEXT, txt, 100)] := #0;
            EnableWindow(GetDlgItem(hWnd, IDC_BT_ADDEXT), Trim(txt) <> '');
          end;
      else
        Result := false;
      end;
    end;
  else
    Result := false;
  end;
end;

procedure TSettings.DrawGradientRect(dc: HDC; rc: TRect; clFrom, clTo: COLORREF);
var
  steps,
  fromR, fromG, fromB,
  toR, toG, toB,
  stepR, stepG, stepB: WORD;
  p, old_p: HPEN;
  i: integer;
begin
  steps := rc.Right - rc.Left;
  fromR := (clFrom shl 8);
  fromG := clFrom and $ff00;
  fromB := (clFrom shr 8) and $ff00;
  toR := (clTo shl 8);
  toG := clTo and $ff00;
  toB := (clTo shr 8) and $ff00;
  stepR := (toR - fromR) div steps;
  stepG := (toG - fromG) div steps;
  stepB := (toB - fromB) div steps;
  for i := rc.Left to rc.Right - 1 do
  begin
    p := CreatePen(PS_SOLID, rc.Bottom - rc.Top,
      ((fromR shr 8) or (fromG and $ff00) or (DWORD(fromB) shl 8 and $ff0000)));
    old_p := SelectObject(dc, p);
    MoveToEx(dc, i, rc.Top, nil);
    LineTo(dc, i + 1, rc.Top);
    p := SelectObject(dc, old_p);
    DeleteObject(p);
    inc(fromR, stepR);
    inc(fromG, stepG);
    inc(fromB, stepB);
  end;
end;

function TSettings.add_treeitem(name: string; parent: HTREEITEM; hDlg: HWND;
  id: DWORD; hTree: THandle): HTREEITEM;
var
  tci: TV_INSERTSTRUCT;
  ti: TV_ITEM;
  rc: TRect;
begin
  tci.hParent := parent;
  tci.hInsertAfter := TVI_LAST;
  ti.mask := TVIF_TEXT or TVIF_PARAM or TVIF_STATE;
  ti.pszText := PChar(name);
  ti.cchTextMax := Length(name);
  ti.lParam := hDlg;
  ti.state := TVIS_EXPANDED;
  ti.stateMask := TVIS_EXPANDED;
  tci.item := ti;
  Result := TreeView_InsertItem(hTree, tci);
  if (Result <> nil) and (hDlg > 0) then
  begin
    SetWindowText(id, ti.pszText);
    MoveWindow(hDlg, _page_dlg_rc.Left, _page_dlg_rc.Top, _page_dlg_rc.Right, _page_dlg_rc.Bottom, false);
    if isXPThemeSupported then
      EnableThemeDialogTexture(hDlg, ETDT_ENABLETAB);
    SetWindowLong(hDlg, GWL_ID, id);
  end;
end;

function TSettings.dlgWP(hWnd: HWND; Msg, wParam, lParam: cardinal): LongBool;
var
  hti: HTREEITEM;
  ti: TV_ITEM;
  _hTheme: HTHEME;
  ps: PAINTSTRUCT;
  dc: HDC;
  wtxt: array[0..99] of widechar;
  color: COLORREF;
  h: THandle;
begin
  case Msg of
    WM_INITDIALOG:
    begin
      dlgHandle := hWnd;
      SetRect(_page_dlg_rc, 124,28,255,212); {left, top, width, height}
      MapDialogRect(hWnd, _page_dlg_rc);
      SetRect(_page_rc, 118, 4, 385, 243);
      MapDialogRect(hWnd, _page_rc);
      SetRect(_page_gradient_rc, 121, 23, 379, 24);
      MapDialogRect(hWnd, _page_gradient_rc);
      _page_gradient_rc.Bottom := _page_gradient_rc.Top + 1;
      SetRect(_page_caption_rc, 138, 6, 363, 22);
      MapDialogRect(hWnd, _page_caption_rc);
      h := GetDlgItem(hWnd, IDC_TREE);
      hti := add_treeitem(LangStor[LNG_OPT_SUBTITLESNAME], TVI_ROOT, 0, 0, h);
      TreeView_SelectItem(h, add_treeitem(
        LangStor[LNG_OPT_FONT], hti,
        CreateDialogParam(hInstance, MAKEINTRESOURCE(IDD_SBT_FONT), hWnd, @pageSbtFontWndProc, IDD_SBT_FONT),
        IDD_SBT_FONT, h));
      TreeView_SelectItem(h, hti);
      add_treeitem(
        LangStor[LNG_OPT_OTHEROPTIONS], hti,
        CreateDialog(hInstance, MAKEINTRESOURCE(IDD_SBT_OTHER), hWnd, @pageSbtOtherWndProc),
        IDD_SBT_OTHER, h);

      hti := add_treeitem(LangStor[LNG_OPT_PLAYNAME], TVI_ROOT, 0, 0, h);
      add_treeitem(
        LangStor[LNG_OPT_NAVIGATION], hti,
        CreateDialog(hInstance, MAKEINTRESOURCE(IDD_PLAY_NAVI), hWnd, @pagePlayNaviWndProc),
        IDD_PLAY_NAVI, h);
      add_treeitem(
        LangStor[LNG_OPT_FULLSCREEN], hti,
        CreateDialog(hInstance, MAKEINTRESOURCE(IDD_PLAY_FULLSCR), hWnd, @pagePlayFullScrWndProc),
        IDD_PLAY_FULLSCR, h);
      add_treeitem(
        LangStor[LNG_OPT_OTHEROPTIONS], hti,
        CreateDialog(hInstance, MAKEINTRESOURCE(IDD_PLAY_OTHER), hWnd, @pagePlayOtherWndProc),
        IDD_PLAY_OTHER, h);

      add_treeitem(
        GetHint(LangStor[LNG_PLAYLIST]), TVI_ROOT,
        CreateDialog(hInstance, MAKEINTRESOURCE(IDD_PLAYLIST), hWnd, @pagePlaylistWndProc),
        IDD_PLAYLIST, h);

      add_treeitem(
        LangStor[LNG_EDT_WINDOWCAPTION], TVI_ROOT,
        CreateDialog(hInstance, MAKEINTRESOURCE(IDD_EDITOR), hWnd, @pageEditorWndProc),
        IDD_EDITOR, h);

      hti := add_treeitem('OSD', TVI_ROOT, 0, 0, h);
      add_treeitem(
        LangStor[LNG_OPT_FONT], hti,
        CreateDialogParam(hInstance, MAKEINTRESOURCE(IDD_SBT_FONT), hWnd, @pageSbtFontWndProc, IDD_OSD_FONT),
        IDD_OSD_FONT, h);
      add_treeitem(
        LangStor[LNG_OPT_OTHEROPTIONS], hti,
        CreateDialog(hInstance, MAKEINTRESOURCE(IDD_OSD_OTHER), hWnd, @pageOSDOtherWndProc),
        IDD_OSD_OTHER, h);

      add_treeitem(
        LangStor[LNG_OPT_SPEAKERNAME], TVI_ROOT,
        CreateDialog(hInstance, MAKEINTRESOURCE(IDD_SPEAKER), hWnd, @pageSpeakerWndProc),
        IDD_SPEAKER, h);

      add_treeitem(
        LangStor[LNG_OPT_FOLDERS], TVI_ROOT,
        CreateDialog(hInstance, MAKEINTRESOURCE(IDD_DIRECTORIES), hWnd, @pageDirectoriesWndProc),
        IDD_DIRECTORIES, h);

      add_treeitem(
        LangStor[LNG_OPT_EXTENSIONSNAME], TVI_ROOT,
        CreateDialog(hInstance, MAKEINTRESOURCE(IDD_FILES), hWnd, @pageFilesWndProc),
        IDD_FILES, h);

      add_treeitem(
        LangStor[LNG_OPT_OTHEROPTIONS], TVI_ROOT,
        CreateDialog(hInstance, MAKEINTRESOURCE(IDD_OTHER), hWnd, @pageOtherWndProc),
        IDD_OTHER, h);

      SetWindowText(hWnd, PChar(LangStor[LNG_OPT_WINDOWCAPTION]));
      SetDlgItemText(hWnd, IDOK, PChar(LangStor[LNG_OK]));
      SetDlgItemText(hWnd, IDCANCEL, PChar(LangStor[LNG_CANCEL]));
      SetDlgItemText(hWnd, IDC_SAVETOFILE, PChar(LangStor[LNG_OPT_SAVETOFILE] + '...'));
      SetDlgItemText(hWnd, IDC_APPLY, PChar(LangStor[LNG_APPLY]));
      SetApplyButtonState(false);
    end;
    WM_CLOSE:
    begin
      EndDialog(dlgHandle, IDCANCEL);
    end;
    WM_COMMAND:
    begin
      case LOWORD(wParam) of
        IDOK, IDCANCEL:
          if HIWORD(wParam) = BN_CLICKED then
          begin
            if LOWORD(wParam) = IDOK then
              PrepareSettings(config);
            EndDialog(dlgHandle, LOWORD(wParam));
          end;
        IDC_SAVETOFILE:
          if HIWORD(wParam) = BN_CLICKED then
          begin
            SaveToFile;
          end;
        IDC_APPLY:
          if HIWORD(wParam) = BN_CLICKED then
          begin
            PrepareSettings(config);
            _apply_proc();
            SetApplyButtonState(false);
          end;
      else
        Result := false;
      end;
    end;
    WM_NOTIFY:
    begin
      case PNMHDR(lParam).idFrom of
        IDC_TREE:
        begin
          case PNMHDR(lParam).code of
            TVN_ITEMEXPANDING:
            begin
              if PNMTreeView(lParam).action = TVE_COLLAPSE then
                Result := true;
            end;
            TVN_SELCHANGING:
            begin
              ti.mask := TVIF_PARAM;
              ti.hItem := PNMTreeView(lParam)^.itemNew.hItem;
              TreeView_GetItem(PNMHDR(lParam).hwndFrom, ti);
              Result := ti.lParam = 0;
              if not Result then
              begin
                ShowWindow(ti.lParam, SW_SHOW);
                BringWindowToTop(ti.lParam);
              end;
              ti.hItem := PNMTreeView(lParam)^.itemOld.hItem;
              TreeView_GetItem(PNMHDR(lParam).hwndFrom, ti);
              ShowWindow(ti.lParam, SW_HIDE);
              InvalidateRect(hWnd, @_page_caption_rc, true);
            end;
            TVN_SELCHANGED:
            begin
              ti.mask := TVIF_PARAM;
              ti.hItem := PNMTreeView(lParam)^.itemNew.hItem;
              TreeView_GetItem(PNMHDR(lParam).hwndFrom, ti);
              if ti.lParam = 0 then
              begin
                hti := TreeView_GetNextItem(PNMHDR(lParam).hwndFrom, PNMTreeView(lParam)^.itemNew.hItem, TVGN_CHILD);
                if (PNMTreeView(lParam)^.action = TVC_BYKEYBOARD) and
                   (PNMTreeView(lParam)^.itemOld.hItem = hti) then
                begin
                  hti := TreeView_GetPrevVisible(PNMHDR(lParam).hwndFrom, PNMTreeView(lParam)^.itemNew.hItem);
                end;
                TreeView_SelectItem(PNMHDR(lParam).hwndFrom, hti);
              end;
            end;
          else
            Result := false;
          end;
        end;
      else
        Result := false;
      end;
    end;
    WM_PAINT:
    begin
      dc := BeginPaint(hWnd, ps);
      ti.mask := TVIF_TEXT;
      ZeroMemory(@txt, 100);
      ti.cchTextMax := 100;
      ti.hItem :=
        TreeView_GetParent(GetDlgItem(hWnd, IDC_TREE),
                           TreeView_GetSelection(GetDlgItem(hWnd, IDC_TREE)));
      if ti.hItem <> nil then
      begin
        ti.pszText := txt;
        TreeView_GetItem(GetDlgItem(hWnd, IDC_TREE), ti);
        StrCat(txt, ' - ');
      end;
      ti.hItem := TreeView_GetSelection(GetDlgItem(hWnd, IDC_TREE));
      ZeroMemory(@txt2, 100);
      ti.pszText := txt2;
      TreeView_GetItem(GetDlgItem(hWnd, IDC_TREE), ti);
      StrCat(txt, txt2);

      if isXPThemeSupported then
      begin
        _hTheme := OpenThemeData(hWnd, 'tab');
        if _hTheme > 0 then
        begin
          DrawThemeBackground(_hTheme, dc, TABP_PANE, 0, _page_rc, PRect(nil)^);
          GetThemeColor(_hTheme, TABP_PANE, 0, 3802, color);
          wtxt[MultiByteToWideChar(CP_ACP, 0, txt, Length(txt), @wtxt[1], 99)] := #0;
          DrawThemeText(_hTheme, dc, TABP_PANE, 0, @wtxt[1], -1,
                DT_VCENTER or DT_SINGLELINE or DT_NOCLIP, 0, _page_caption_rc);
          CloseThemeData(_hTheme);
        end;
      end
      else
      begin
        FillRect(dc, _page_rc, GetSysColorBrush(COLOR_BTNFACE));
        DrawEdge(dc, _page_rc, EDGE_SUNKEN, BF_RECT);
        color := GetSysColor(COLOR_GRADIENTACTIVECAPTION);
        rc := _page_caption_rc;
        SetBkMode(dc, TRANSPARENT);
        DrawText(dc, txt, -1, rc, DT_VCENTER or DT_SINGLELINE or DT_NOCLIP);
      end;

{      if isXPThemeSupported then
      begin
        _hTheme := OpenThemeData(hWnd, 'StartPanel');
        if _hTheme > 0 then
        begin
          CloseThemeData(_hTheme);
        end;
      end
      else
      begin
      end;}

      DrawGradientRect(dc, _page_gradient_rc, GetSysColor(COLOR_ACTIVECAPTION), color);

      EndPaint(hWnd, ps);
      Result := true;
    end;
  else
    Result := false;
  end;
end;

function TSettings.pageOSDOtherWP(hWnd: HWND; Msg, wParam,
  lParam: cardinal): LongBool;
const
  osd_align: array[boolean] of THPosition = (phLeft, phRight);
var
  state: boolean;
begin
  case Msg of
    WM_INITDIALOG:
    begin
      SetDlgItemText(hWnd, IDC_CHK_OSDENABLED, PChar(LangStor[LNG_OPT_OSDENABLED]));
      SetDlgItemText(hWnd, IDC_CHK_OSDLEFTRIGHT, PChar(LangStor[LNG_OPT_OSDLEFTRIGHT]));
      SetDlgItemText(hWnd, IDC_LB_OSDDISPLAYTIME, PChar(LangStor[LNG_OPT_OSDDISPLAYTIME]));
      SetDlgItemText(hWnd, IDC_LB_OSDDISPLAYTIME2, PChar(LangStor[LNG_OPT_SECOND]));
      SetDlgItemText(hWnd, IDC_CHK_OSDCURRENTTIME, PChar(LangStor[LNG_OPT_OSDCURRENTTIME]));
      SetDlgItemText(hWnd, IDC_LB_OSDCURRENTTIME, PChar(LangStor[LNG_OPT_MINUTE]));
      SetDlgItemText(hWnd, IDC_LB_OSDTOPPOSITION, PChar(LangStor[LNG_OPT_OSDTOPPOSITION]));
      SetDlgItemText(hWnd, IDC_LB_OSDLEFTPOSITION, PChar(LangStor[LNG_OPT_OSDLEFTPOSITION]));

      with config do
      begin
        CheckDlgButton(hWnd, IDC_CHK_OSDENABLED, check_state[OSDEnabled]);
        CheckDlgButton(hWnd, IDC_CHK_OSDLEFTRIGHT, check_state[_osd_font_data.position.hPosition = phRight]);
        SetDlgItemInt(hWnd, IDC_IED_OSDDISPLAYTIME, OSDDisplayTime, true);
        SendDlgItemMessage(hWnd, IDC_IED_OSDDISPLAYTIME, IEM_SETRANGE, 0, MAKELONG(10, 0));
        CheckDlgButton(hWnd, IDC_CHK_OSDCURRENTTIME, check_state[OSDCurrentTimeEnabled]);;
        SendMessage(hWnd, WM_COMMAND, MAKELONG(IDC_CHK_OSDCURRENTTIME, BN_CLICKED), 0);

        SetDlgItemInt(hWnd, IDC_IED_OSDCURRENTTIME, OSDCurrentTime, true);
        SendDlgItemMessage(hWnd, IDC_IED_OSDCURRENTTIME, IEM_SETRANGE, 0, MAKELONG(100, 0));
        SetDlgItemInt(hWnd, IDC_IED_OSDTOPPOSITION, osd_y_margin, true);
        SendDlgItemMessage(hWnd, IDC_IED_OSDTOPPOSITION, IEM_SETRANGE, 0, MAKELONG(50, 0));
        SetDlgItemInt(hWnd, IDC_IED_OSDLEFTPOSITION, osd_x_margin, true);
        SendDlgItemMessage(hWnd, IDC_IED_OSDLEFTPOSITION, IEM_SETRANGE, 0, MAKELONG(50, 0));
      end;
    end;
    WM_COMMAND:
    begin
//      SetWindowText(GetParent(hWnd), PChar(Format('%x: %x', [LOWORD(wParam), HIWORD(wParam)])));
      if HIWORD(wParam) = BN_CLICKED then
        SetApplyButtonState(true);
      case LOWORD(wParam) of
        IDC_CHK_OSDCURRENTTIME:
          if HIWORD(wParam) = BN_CLICKED then
          begin
            state := IsDlgButtonChecked(hWnd, IDC_CHK_OSDCURRENTTIME) = BST_CHECKED;
            EnableWindow(GetDlgItem(hWnd, IDC_IED_OSDCURRENTTIME), state);
            EnableWindow(GetDlgItem(hWnd, IDC_LB_OSDCURRENTTIME), state);
          end;
        IDC_CHK_OSDLEFTRIGHT:
          if HIWORD(wParam) = BN_CLICKED then
          begin
            _osd_font_data.position.hPosition := osd_align[IsDlgButtonChecked(hWnd, IDC_CHK_OSDLEFTRIGHT) = BST_CHECKED];
          end;
        IDC_IED_OSDDISPLAYTIME,
        IDC_IED_OSDCURRENTTIME,
        IDC_IED_OSDTOPPOSITION,
        IDC_IED_OSDLEFTPOSITION:
          if HIWORD(wParam) = EN_CHANGE then
            SetApplyButtonState(true);
      else
        Result := false;
      end;
    end;
    WM_VSCROLL:
    begin
      SetApplyButtonState(true);
{      case GetDlgCtrlID(lParam) of
        IDC_SLD_SPEAKERVOLUME,
        IDC_SLD_SPEAKERRATE:
        begin
          SetApplyButtonState(true);
        end;
      end;
 }   end;
  else
    Result := false;
  end;
end;

procedure TSettings.setButtons;
var
  SrcEmpty, DstEmpty: Boolean;
  h: HWND;
begin
  h := GetDlgItem(dlgHandle, IDD_SBT_OTHER);
  SrcEmpty :=
    ((GetFocus = GetDlgItem(h, IDC_LBX_PLSNOTASSOCIATED)) and
     (SendDlgItemMessage(h, IDC_LBX_PLSNOTASSOCIATED, LB_GETCOUNT, 0, 0) = 0)) or
    (SendDlgItemMessage(h, IDC_LBX_FLSNOTASSOCIATED, LB_GETCOUNT, 0, 0) = 0);
  DstEmpty := SendDlgItemMessage(h, IDC_LBX_ASSOCIATED, LB_GETCOUNT, 0, 0) = 0;
  EnableWindow(GetDlgItem(h, IDC_BT_INCLUDE), not SrcEmpty);
  EnableWindow(GetDlgItem(h, IDC_BT_INCALL), not SrcEmpty);
  EnableWindow(GetDlgItem(h, IDC_BT_EXCLUDE), not DstEmpty);
  EnableWindow(GetDlgItem(h, IDC_BT_EXCALL), not DstEmpty);
end;

procedure TSettings.PrepareSettings(var cs: TConfig);
type
  PLongBool = ^LongBool;
var
  res_str: PChar;
  CharCount: byte;
  h: HWND;
begin
  with cs do
  begin
    h := GetDlgItem(dlgHandle, IDD_SBT_FONT);
    SubtitlesAttr.Style := _subtitle_font_data;
    SubtitlesAttr.Overlay := IsDlgButtonChecked(h, IDC_CHK_OVERLAY) = BST_CHECKED;
    SubtitlesAttr.RenderMode := TRenderMode(SendDlgItemMessage(h, IDC_CBO_RENDER, CB_GETCURSEL, 0, 0));
    SubtitlesAttr.AntiAliasing := TAntialiasing(SendDlgItemMessage(h, IDC_CBO_ANTIALIAS, CB_GETCURSEL, 0, 0));

    h := GetDlgItem(dlgHandle, IDD_SBT_OTHER);
    LoadSubtitles := IsDlgButtonChecked(h, IDC_CHK_LOADSUBTITLES) = BST_CHECKED;
    AutoSizeText := IsDlgButtonChecked(h, IDC_CHK_AUTOSIZE) = BST_CHECKED;
    EdgeSpace := GetDlgItemInt(h, IDC_IED_DISTANCE, PLongBool(nil)^, true);
    SubtitleRows := GetDlgItemInt(h, IDC_IED_SUBROWS, PLongBool(nil)^, true);
    AdjustTextPos := IsDlgButtonChecked(h, IDC_CHK_AUTOPOS) = BST_CHECKED;
    AutoTextDelay := IsDlgButtonChecked(h, IDC_CHK_AUTOTIME) = BST_CHECKED;
    TextDelay := GetDlgItemInt(h, IDC_IED_CALCTIME, PLongBool(nil)^, true);
    MaxSubWidthActive := IsDlgButtonChecked(h, IDC_CHK_SUBWIDTH) = BST_CHECKED;
    MaxSubWidthPercent := boolean(SendDlgItemMessage(h, IDC_CBO_SUBWIDTH, CB_GETCURSEL, 0, 0));
    MaxSubWidth := GetDlgItemInt(h, IDC_IED_SUBWIDTH, PLongBool(nil)^, true);
    SearchingOutOfSubtitles := TSearchingOutOfSubtitles(SendDlgItemMessage(h, IDC_CBO_SEARCHINGOUTOFSUBTITLES, CB_GETCURSEL, 0, 0));

    h := GetDlgItem(dlgHandle, IDD_PLAY_NAVI);
    PageSize := GetDlgItemInt(h, IDC_IED_LARGESTEPS, PLongBool(nil)^, true);
    LineSize := GetDlgItemInt(h, IDC_IED_SMALLSTEPS, PLongBool(nil)^, true);
    MouseWheelMode := TMouseWheelMode(SendDlgItemMessage(h, IDC_CBO_MOUSEWHEEL, CB_GETCURSEL, 0, 0));
    ReverseWheel := IsDlgButtonChecked(h, IDC_CHK_REVERSEWHEEL) = BST_CHECKED;
    PauseOnControl := IsDlgButtonChecked(h, IDC_CHK_PAUSEONCONTROL) = BST_CHECKED;
    PauseWhenMinimized := IsDlgButtonChecked(h, IDC_CHK_PAUSEWHENMINIMIZED) = BST_CHECKED;
    PauseAfterClick := IsDlgButtonChecked(h, IDC_CHK_PAUSEAFTERLBUTTONCLICK) = BST_CHECKED;

    h := GetDlgItem(dlgHandle, IDD_PLAY_FULLSCR);
    TurnOffCur := GetDlgItemInt(h, IDC_IED_HIDECURSOR, PLongBool(nil)^, true) * 1000;
    HideTaskBar := IsDlgButtonChecked(h, IDC_CHK_HIDETASKBAR) = BST_CHECKED;
    if IsDlgButtonChecked(h, IDC_CHK_AUTOFULLSCREEN) = BST_CHECKED then
      if IsDlgButtonChecked(h, IDC_CHK_CHANGERESOLUTION) = BST_CHECKED then
        AutoFullScreen := afsFFS
      else
        AutoFullScreen := afsFS
    else
      AutoFullScreen := afsNone;
    txt[GetDlgItemText(h, IDC_CBO_RESOLUTION, txt, 100)] := #0;
    res_str := txt;
    ScanNumber(res_str, cardinal(Res.Width), CharCount);
    inc(res_str);
    ScanNumber(res_str, cardinal(Res.Height), CharCount);
    inc(res_str);
    ScanNumber(res_str, cardinal(Res.Depth), CharCount);
    if IsWindowEnabled(GetDlgItem(h, IDC_CBO_FREQUENCY)) then
    begin
      txt[GetDlgItemText(h, IDC_CBO_FREQUENCY, txt, 100)] := #0;
      Res.VRefresh := StrToInt(txt);
    end
    else
      Res.VRefresh := 0;
    PanelOnTop := IsDlgButtonChecked(h, IDC_CHK_PANELONTOP) = BST_CHECKED;
    ForceStdCtrlPanelMode := IsDlgButtonChecked(h, IDC_CHK_FORCESTDCTRLPANELMODE) = BST_CHECKED;
    DblClick2FullScr := IsDlgButtonChecked(h, IDC_CHK_DBLCLK2FULLSCR) = BST_CHECKED;

    h := GetDlgItem(dlgHandle, IDD_PLAY_OTHER);
    txt[GetDlgItemText(h, IDC_CBO_ASFFPS, txt, 100)] := #0;
    DefaultFPS := StrToFloat(txt);
    Autoplay := IsDlgButtonChecked(h, IDC_CHK_AUTOPLAY) = BST_CHECKED;
    CloseAfterPlay := IsDlgButtonChecked(h, IDC_CHK_CLOSEPLAYER) = BST_CHECKED;
    OneCopy := IsDlgButtonChecked(h, IDC_CHK_ONEINSTANCE) = BST_CHECKED;
    AudioRenderer := SendDlgItemMessage(h, IDC_CBO_AUDIORENDERER, CB_GETCURSEL, 0, 0);

    RememberSuspendState := IsDlgButtonChecked(h, IDC_CHK_REMEMBERSUSPENDSTATE) = BST_CHECKED;
    Shutdown := SendDlgItemMessage(h, IDC_CBO_CLOSESYSTEM, CB_GETCURSEL, 0, 0);
    WaitShutdown := IsDlgButtonChecked(h, IDC_CHK_SHUTDOWNDELAY) = BST_CHECKED;
    ShutdownDelay := GetDlgItemInt(h, IDC_IED_SHUTDOWNDELAY, PLongBool(nil)^, true);

    h := GetDlgItem(dlgHandle, IDD_EDITOR);
    StopOnError := IsDlgButtonChecked(h, IDC_CHK_STOPONERROR) = BST_CHECKED;


    h := GetDlgItem(dlgHandle, IDD_OSD_FONT);
    OSDAttr.Style := _osd_font_data;
    OSDAttr.Overlay := IsDlgButtonChecked(h, IDC_CHK_OVERLAY) = BST_CHECKED;
    OSDAttr.RenderMode := TRenderMode(SendDlgItemMessage(h, IDC_CBO_RENDER, CB_GETCURSEL, 0, 0) + 1);
    OSDAttr.AntiAliasing := TAntialiasing(SendDlgItemMessage(h, IDC_CBO_ANTIALIAS, CB_GETCURSEL, 0, 0));

    h := GetDlgItem(dlgHandle, IDD_OSD_OTHER);
    OSDEnabled := IsDlgButtonChecked(h, IDC_CHK_OSDENABLED) = BST_CHECKED;
    OSDDisplayTime := GetDlgItemInt(h, IDC_IED_OSDDISPLAYTIME, PLongBool(nil)^, true);
    OSDCurrentTimeEnabled := IsDlgButtonChecked(h, IDC_CHK_OSDCURRENTTIME) = BST_CHECKED;
    OSDCurrentTime := GetDlgItemInt(h, IDC_IED_OSDCURRENTTIME, PLongBool(nil)^, true);
    osd_y_margin := GetDlgItemInt(h, IDC_IED_OSDTOPPOSITION, PLongBool(nil)^, true);
    osd_x_margin := GetDlgItemInt(h, IDC_IED_OSDLEFTPOSITION, PLongBool(nil)^, true);

    h := GetDlgItem(dlgHandle, IDD_DIRECTORIES);
    txt[GetDlgItemText(h, IDC_ED_MOVIEFOLDER, txt, 100)] := #0;
    MovieFolder := txt;
    txt[GetDlgItemText(h, IDC_ED_SBTFOLDER, txt, 100)] := #0;
    SubtitlesFolder := txt;
    txt[GetDlgItemText(h, IDC_ED_SCRSHOTFOLDER, txt, 100)] := #0;
    ScreenShotFolder := txt;

    h := GetDlgItem(dlgHandle, IDD_SPEAKER);
    SpeakerEnabled := IsDlgButtonChecked(h, IDC_CHK_SPEAKERENABLE) = BST_CHECKED;
    SpeakerFlushPrevPhrase := IsDlgButtonChecked(h, IDC_CHK_SPEAKERFLUSHPREV) = BST_CHECKED;
    SpeakerHideSubtitles := IsDlgButtonChecked(h, IDC_CHK_SPEAKERHIDESUBTITLES) = BST_CHECKED;
    SpeakerSelected := SendDlgItemMessage(h, IDC_CBO_SPEAKERSELECT, CB_GETCURSEL, 0, 0);
    SpeakerVolume := SendDlgItemMessage(h, IDC_SLD_SPEAKERVOLUME, TBM_GETPOS, 0, 0);
    SpeakerRate := SendDlgItemMessage(h, IDC_SLD_SPEAKERRATE, TBM_GETPOS, 0, 0);

    h := GetDlgItem(dlgHandle, IDD_PLAYLIST);
    SearchNextMoviePart := IsDlgButtonChecked(h, IDC_CHK_SEARCHNEXTPART) = BST_CHECKED;
    SearchNextMoviePartOnCDROM := IsDlgButtonChecked(h, IDC_CHK_SEARCHNEXTPARTONCDROM) = BST_CHECKED;

    h := GetDlgItem(dlgHandle, IDD_OTHER);
    ClearHistoryAtExit := IsDlgButtonChecked(h, IDC_CHK_CLEARHISTORYATEXIT) = BST_CHECKED;
    DisableResizeFrame := IsDlgButtonChecked(h, IDC_CHK_DISABLEFRAMERESIZE) = BST_CHECKED;
  end;
end;

procedure TSettings.RefreshExample(h: HWND);
var
  p: TSubtitlePosition;
  pss: PSubtitlesStyle;
  sr: TSubtitlesRenderer;
  render_cbo_modifier: byte;
begin
  if GetWindowLong(h, GWL_ID) = IDD_SBT_FONT then
  begin
    sr := _subtitle_example;
    pss := @_subtitle_font_data;
    render_cbo_modifier := 0;
  end
  else
  begin
    sr := _osd_example;
    pss := @_osd_font_data;
    render_cbo_modifier := 1;
  end;

  pss^.font_color := SendDlgItemMessage(h, IDC_SHP_TEXTCOLOR, CBM_GETCOLOR, 0, 0);
  pss^.bkg_color := SendDlgItemMessage(h, IDC_SHP_BKGCOLOR, CBM_GETCOLOR, 0, 0);
  p := pss^.position;
  pss^.position.hPosition := phCenter;
  pss^.position.vPosition := pvCenter;
  sr.set_attributes(
    pss^,
    TRenderMode(SendDlgItemMessage(h, IDC_CBO_RENDER, CB_GETCURSEL, 0, 0) + render_cbo_modifier),
    TAntialiasing(SendDlgItemMessage(h, IDC_CBO_ANTIALIAS, CB_GETCURSEL, 0, 0)));
  pss^.position := p;
  sr.refresh;
end;

function TSettings.GetFirstSelection(hList: HWND): integer;
begin
  if SendMessage(hList, LB_GETSELITEMS, 1, integer(@Result)) = 0 then
    Result := LB_ERR;
end;

procedure TSettings.MoveSelected(hListFrom, hListTo: HWND; data_value: DWORD);
var
  ai: array[0..99] of integer;
  i, count: integer;
  item_data: DWORD;
begin
  count := SendMessage(hListFrom, LB_GETSELITEMS, 100, integer(@ai));
  for i := count - 1 downto 0 do
  begin
    item_data := SendMessage(hListFrom, LB_GETITEMDATA, ai[i], 0);
    if item_data = data_value then
    begin
      txt[SendMessage(hListFrom, LB_GETTEXT, ai[i], integer(@txt))] := #0;
      SendMessage(
        hListTo,
        LB_SETITEMDATA,
        SendMessage(hListTo, LB_ADDSTRING, 0, integer(@txt)),
        item_data);
      SendMessage(hListFrom, LB_DELETESTRING, ai[i], 0);
    end;
  end;
end;

procedure TSettings.SetItem(hList: HWND; index: integer);
var
  MaxIndex: integer;
begin
  SetFocus(hList);
  MaxIndex := SendMessage(hList, LB_GETCOUNT, 0, 0) - 1;
  if index = LB_ERR then
    index := 0
  else
    if index > MaxIndex then
      index := MaxIndex;
  SendMessage(hList, LB_SETSEL, 1, index);
  SetButtons;
end;

procedure TSettings.MoveAll(hListFrom, hListTo: HWND; data_value: DWORD);
var
  i, count: integer;
  item_data: DWORD;
begin
  count := SendMessage(hListFrom, LB_GETCOUNT, 0, 0);
  for i := count - 1 downto 0 do
  begin
    item_data := SendMessage(hListFrom, LB_GETITEMDATA, i, 0);
    if item_data = data_value then
    begin
      txt[SendMessage(hListFrom, LB_GETTEXT, i, integer(@txt))] := #0;
      SendMessage(
        hListTo,
        LB_SETITEMDATA,
        SendMessage(hListTo, LB_ADDSTRING, 0, integer(@txt)),
        item_data);
      SendMessage(hListFrom, LB_DELETESTRING, i, 0);
    end;
  end;
end;

procedure TSettings.SaveToFile;
var
  DestDir: string;
  cs: Tconfig;
begin
  if SelectDirectory(dlgHandle, LangStor[LNG_DIALOG_SELECTFOLDER],
     desktop_name, ExtractFilePath(ParamStr(0)), DestDir) then
  begin
    PrepareSettings(cs);
    cs.AudioVolume := config.AudioVolume;
    cs.AspectRatio := config.AspectRatio;
    cs.Mute := config.Mute;
    cs.Playlist := config.Playlist;
    cs.PlaylistToLeft := config.PlaylistToLeft;
    cs.RepeatList := config.RepeatList;
    cs.TextDelay := config.TextDelay;
    cs.Shuffle := config.Shuffle;
    cs.StayOnTop := config.StayOnTop;
    cs.SubAutoMinTime := config.SubAutoMinTime;
    cs.SubAutoMaxTime := config.SubAutoMaxTime;
    cs.SubAutoConstTime := config.SubAutoConstTime;
    cs.SubAutoIncTime := config.SubAutoIncTime;
    cs.SuspendState := config.SuspendState;
    cs.ViewStandard := config.ViewStandard;
    cs.ViewStandard := config.ViewStandard;
    SaveConfig(cs, true, NormalizeDir(DestDir) + ProgName + '.ini', true);
  end;
end;

procedure TSettings.populateVideoModes(hCombo: HWND);

  function compare(const r1, r2: TRes): Integer;
  begin
    Result :=
      (r1.Depth - r2.Depth) * 1000000 +
      (r1.Width - r2.Width) * 1000 +
      (r1.Height - r2.Height);
  end;

type
  Pres = ^TRes;
var
  counter, i: integer;
  dm, old_dm: DEVMODE;
  ret: boolean;
  l: TList;
  r: PRes;
  s, old_s: string;
begin
  ZeroMemory(@old_dm, sizeof(DEVMODE));
  counter := 0;
  l := TList.Create;
  repeat
    ret := EnumDisplaySettings(nil, counter, dm);
    if (dm.dmBitsPerPel > 8) then
    begin
      if (old_dm.dmPelsWidth <> dm.dmPelsWidth) or
         (old_dm.dmPelsHeight <> dm.dmPelsHeight) or
         (old_dm.dmBitsPerPel <> dm.dmBitsPerPel) then
      begin
        new(r);
        r.Width := dm.dmPelsWidth;
        r.Height := dm.dmPelsHeight;
        r.Depth := dm.dmBitsPerPel;
        old_dm := dm;
        l.Add(r);
      end;
    end;
    inc(counter);
  until not ret;
  l.Sort(@compare);

  old_s := '';
  i := 0;
  for counter := 0 to l.Count - 1 do
  begin
    s := Format('%dx%dx%d', [PRes(l[counter]).Width, PRes(l[counter]).Height, PRes(l[counter]).Depth]);
    if old_s <> s then
    begin
      SendMessage(hCombo, CB_ADDSTRING, 0, integer(PChar(s)));
      if (config.Res.Width = PRes(l[counter]).Width) and
         (config.Res.Height = PRes(l[counter]).Height) and
         (config.Res.Depth = PRes(l[counter]).Depth) then
        SendMessage(hCombo, CB_SETCURSEL, counter - i, 0);
    end
    else
      inc(i);
    old_s := s;
    dispose(PRes(l[counter]));
  end;
  l.Free;
end;

procedure TSettings.populateVideoFreq(hCombo: HWND; r: string);

  function compare(const f1, f2: Pointer): Integer;
  begin
    Result := integer(f1) - integer(f2);
  end;

var
  counter, i: integer;
  dm: DEVMODE;
  ret: boolean;
  l: TList;
  s: string;
  res_str: PChar;
  res: TRes;
  char_count: byte;
begin
  res_str := PChar(r);
  ScanNumber(res_str, cardinal(res.Width), char_count);
  inc(res_str);
  ScanNumber(res_str, cardinal(res.Height), char_count);
  inc(res_str);
  ScanNumber(res_str, cardinal(res.Depth), char_count);
  SendMessage(hCombo, CB_RESETCONTENT, 0, 0);
  counter := 0;
  ZeroMemory(@dm, sizeof(DEVMODE));
  l := TList.Create;
  try
    repeat
      ret := EnumDisplaySettings(nil, counter, dm);
      if (res.Width = dm.dmPelsWidth) and
         (res.Height = dm.dmPelsHeight) and
         (res.Depth = dm.dmBitsPerPel) and
         (dm.dmDisplayFrequency > 0) then
      begin
        l.Add(Pointer(dm.dmDisplayFrequency));
      end;
      inc(counter);
    until not ret;
    l.Sort(@compare);
    for i := 0 to l.Count - 1 do
      SendMessage(hCombo, CB_ADDSTRING, 0, integer(PChar(IntToStr(integer(l[i])))));
    EnableWindow(hCombo, l.Count > 0);
    if (res.Width = config.res.Width) and
       (res.Height = config.res.Height) and
       (res.Depth = config.res.Depth) then
    begin
      i := l.IndexOf(Pointer(config.res.VRefresh));
      if i = -1 then
        i := l.Count - 1;
    end
    else
      i := l.Count - 1;
    if i >= 0 then
      SendMessage(hCombo, CB_SETCURSEL, i, 0);
  finally
    l.Free;
  end;
end;

procedure TSettings.SetApplyButtonState(bEnabled: boolean);
begin
  EnableWindow(GetDlgItem(dlgHandle, IDC_APPLY), bEnabled);
end;

end.
