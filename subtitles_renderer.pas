unit subtitles_renderer;

interface

uses
  Windows, Messages, SysUtils, Classes, cp_CinemaEngine, subtitles_header,
  subtitles_style, cp_graphics, global_consts;

type
  TPrepareMode = (pmTextToRegion, pmTextToRects, pmDrawText);

  TSimpleMethod = procedure of object;

  pRgnRec = ^tRgnRec;
  tRgnRec = record
    old_rgn, new_rgn: HRGN;
  end;

  TAbstractRenderer = class(TObject)
  private
    _terminated: boolean;
    function check_source_data: boolean; virtual;
    function init_work_data(var new_rect: TRect): boolean; virtual; abstract;
    procedure free_work_data; virtual; abstract;
    procedure render_cliprects(var rgn: HRGN); virtual; abstract;
    function get_bkg_color: COLORREF; virtual; abstract;

    function CreateWnd(parent: HWND): boolean;

    procedure mouse_down(p: TPoint); virtual; abstract;
    procedure mouse_move(p: TPoint; state: DWORD); virtual; abstract;
    procedure mouse_up(p: TPoint); virtual; abstract;

    procedure wait;
  protected
    _cs: TRTLCriticalSection;
    _handle: THandle;
    _event: THandle;
    _thread: THandle;
    _wait_time: DWORD;
    _wait_result: DWORD;
    _freeze_visible: boolean;

    _parent_rect: TRect;
    _use_overlay: boolean;
    _render_mode: TRenderMode;
    _anti_alias: TAntialiasing;

    _work_dib: TDIBmp;
    _render_dib: TDIBmp;
    _paint_ddb: TDDBmp;

    _video_rect: TRect;
    _overlaycolor: COLORREF;
    _is_overlay: boolean;

    _cursor: PAnsiChar;
    _h_margin: integer;
    _v_margin: integer;
    _drag_point: TPoint;
    _begin_update: TSimpleMethod;
    _end_update: TSimpleMethod;

    _max_sub_width: integer;
    _max_sub_width_active: boolean;
    _max_sub_width_percent: boolean;

    _rgns: tRgnRec;

    function bmp_to_region(bmp: TBmp; color_key: COLORREF): HRGN;
    procedure bmp_for_overlay(paint_bmp, mask_bmp: TBmp;
      new_rect: TRect; color_key, color_mask: COLORREF);
    function get_fixed_parent_rect: TRect;
  public
    constructor Create(parent: HWND); virtual;
    destructor Destroy; override;

    function trylock(): boolean;
    procedure lock();
    procedure unlock();
    procedure clear(); virtual; abstract;
    procedure refresh();
    function disable(): boolean;
    procedure enable();
    procedure set_h_margin(ms: integer);
    procedure set_v_margin(ms: integer);
    procedure set_parent_rect(value: TRect);
    procedure set_use_overlay(ov: boolean);
    procedure set_overlay_colorkey(key: COLORREF; is_overlay: boolean);
    procedure set_cursor(value: PAnsiChar);
    procedure set_max_sub_options(active, percent: boolean);
    procedure set_max_sub_width(value: integer);
    function get_height(): integer;
    function get_width(): integer;
    function get_h_margin(): integer;
    function get_v_margin(): integer;
    function set_video_rect(value: TRect): boolean;
    property begin_update: TSimpleMethod read _begin_update write _begin_update;
    property end_update: TSimpleMethod read _end_update write _end_update;
    procedure test();
  end;

  TCustomTextRenderer = class(TAbstractRenderer)
  private
    function check_source_data: boolean; override;
    function get_bkg_color: COLORREF; override;
  protected
    _text: string;
    _style: TSubtitlesStyle;
    _curr_style: TSubtitlesStyle;
    _font_scale: double;
    _def_draw_style: cardinal;

    function calc_font_size(size: integer): integer;
    function calc_position(work_rect: TRect): TRect; virtual;

    procedure prepare_subtitle(pm: TPrepareMode; dc: HDC; text: string;
      var work_rect: TRect; var region: HRGN; draw_style: cardinal = 0); virtual; abstract;
    procedure draw_text(dc: HDC; text: string; var work_rect: TRect;
      draw_style: cardinal);
    procedure render_rects;
    function render_region: HRGN;
  public
//    constructor Create(parent: HWND);
//    destructor Destroy; override;

    procedure clear; override;
    procedure render(subtitle: string); virtual;

    function get_text: string;
    procedure set_font_scale(value: double); virtual;
    procedure set_attributes(ss: TSubtitlesStyle; rm: TRenderMode;
      aa: TAntialiasing); virtual; abstract;
  end;

  TSubtitlesRenderer = class(TCustomTextRenderer)
  private
    _fixed_rows: integer;
    _fixed_size: integer;
// workaround on lock conflict in "get_fixed_size"
    _fixed_scaled_size: integer;

    _line_parser: TSubtitlesParser;

    _whole_font: TFnt;
    _old_font: HFONT;
    _is_whole_font: boolean;

    _adjust_position: boolean;

    procedure get_curr_style(text: PChar);
    function init_work_data(var new_rect: TRect): boolean; override;
    procedure free_work_data; override;
    procedure render_cliprects(var rgn: HRGN); override;
    procedure mouse_down(p: TPoint); override;
    procedure mouse_move(p: TPoint; state: DWORD); override;
    procedure mouse_up(p: TPoint); override;
    procedure calc_fixed_size;
  protected
    procedure prepare_subtitle(pm: TPrepareMode; dc: HDC; text: string;
      var work_rect: TRect; var region: HRGN; draw_style: cardinal = 0); override;
    function calc_position(work_rect: TRect): TRect; override;
  public
    constructor Create(parent: HWND); override;
    destructor Destroy; override;

    procedure set_fixed_rows(fr: integer);
    function get_fixed_size: integer;

    procedure set_font_size(value: integer);
    procedure set_font_scale(value: double); override;
    procedure set_attributes(ss: TSubtitlesStyle; rm: TRenderMode;
      aa: TAntialiasing); override;
    procedure set_adjust_pos(value: boolean);
  end;

  TOSDRenderer = class(TCustomTextRenderer)
  private
    _is_new_font: boolean;
    _font: TFnt;
    function init_work_data(var new_rect: TRect): boolean; override;
    procedure free_work_data; override;
    procedure render_cliprects(var rgn: HRGN); override;
    procedure mouse_down(p: TPoint); override;
    procedure mouse_move(p: TPoint; state: DWORD); override;
    procedure mouse_up(p: TPoint); override;
  protected
    procedure prepare_subtitle(pm: TPrepareMode; dc: HDC; text: string;
      var work_rect: TRect; var region: HRGN; draw_style: cardinal = 0); override;
  public
    constructor Create(parent: HWND); override;
    destructor Destroy; override;

    procedure render(subtitle: string); override;
    procedure set_display_time(value: DWORD);
    procedure set_font_scale(value: double); override;
    procedure set_attributes(ss: TSubtitlesStyle; rm: TRenderMode;
      aa: TAntialiasing); override;
  end;

implementation

{$ifdef _debug}
uses
  logger;
 {$endif}

const
  text_border              = 2;
  WM_SETREGION             = WM_USER + 1000;
  WM_MOVEWINDOW            = WM_USER + 1001;

function swapColorValues(c: COLORREF): COLORREF;
begin
  Result :=
    ((c and $00ff0000) shr 16) or
    (c and $0000ff00) or
    ((c and $000000ff) shl 16);
end;

procedure set_mem(desc: PDWORD; len: DWORD; value: DWORD);
begin
  value := swapColorValues(value);
  while len > 0 do
  begin
    desc^ := value;
    inc(desc);
    dec(len);
  end;
end;

// w¹tek renderuj¹cy
function render_thread(renderer: TAbstractRenderer): integer;
type
  PMyRGBQuad = ^TMyRGBQuad;
  TMyRGBQuad = record
    case integer of
      0: (R, G, B, A: byte);
      1: (RGBA: COLORREF);
  end;

var
  new_rect_: TRect;
  line_size_: integer;
  i_, j_: integer;
  pSrc_, pDst_,                                        // bez obwódki
  pDstG_, pDstD_, pDstL_, pDstP_,                      // obwódka cienka
  pDstGG_, pDstDD_,                                    // obwódka gruba
  pSrcGL_, pSrcG_, pSrcGP_, pSrcL_, pSrcP_,
  pDstGGG_, pDstDDD_,                                    // obwódka gruba
  pSrcDL_, pSrcD_, pSrcDP_: PMyRGBQuad;                // antyaliasing
  pantialiased_: PMyRGBQuad;
  last_alloc_size_: integer;
  work_rgn_: HRGN;
  old_rgn_: HRGN;
  bkg_color: COLORREF;
begin
  pantialiased_ := nil;
  last_alloc_size_ := 0;
  work_rgn_ := 0;
  old_rgn_ := 0;
  with renderer do try
    while true do
    begin
{$ifdef _debug}
_debug('wait');
{$endif}
        //OutputDebugString(PChar('try show subtitle'));
      wait;
      if _terminated then
{$ifdef _debug}
      begin
_debug('exit');
{$endif}
        exit;
{$ifdef _debug}
      end;
{$endif}

        //OutputDebugString(PChar('=======> OK'));
      if _freeze_visible then
{$ifdef _debug}
      begin
_debug('continue');
{$endif}
        continue;
{$ifdef _debug}
      end;
{$endif}

//_debug('try');
      lock;
      try
//_debug('check_source_data');
        if not check_source_data then
        begin
//_debug('bad source data');
//_debugFmt('wait result: %x', [_wait_result]);
          if old_rgn_ <> 0 then
          begin
            _rgns.old_rgn := old_rgn_;
            _rgns.new_rgn := 0;
            old_rgn_ := 0;
            PostMessage(_handle, WM_SETREGION, integer(@_rgns), integer(true));
          end;
          _paint_ddb.initialize(1, 1);
          PostMessage(_handle, WM_MOVEWINDOW, 0, 0);
          continue;
        end;

//_debug('check_source_data end');

// przygotuj _work_dib oraz pozycje obiektu na ekranie
        if not init_work_data(new_rect_) then
          continue;

//_debug('init_work_data');

        line_size_ := _work_dib.get_width;

        if _work_dib.get_height > 0 then
          if _anti_alias <> aaNone then
          begin
            if last_alloc_size_ <> (_work_dib.get_height * _work_dib.get_pitch) then
            begin
              last_alloc_size_ := (_work_dib.get_height * _work_dib.get_pitch);
              if pantialiased_ = nil then
                pantialiased_ := SysGetMem(last_alloc_size_)
              else
                pantialiased_ := SysReallocMem(pantialiased_, last_alloc_size_);
            end;

            if pantialiased_ <> nil then
            begin
              pSrc_ := PMyRGBQuad(_work_dib.get_bits);
              pDst_ := pantialiased_;

              pSrcG_ := pSrc_; Dec(pSrcG_, line_size_);
              pSrcGL_ := pSrcG_; Dec(pSrcGL_);
              pSrcGP_ := pSrcG_; Inc(pSrcGP_);
              pSrcD_ := pSrc_; Inc(pSrcD_, line_size_);
              pSrcDL_ := pSrcD_; Dec(pSrcDL_);
              pSrcDP_ := pSrcD_; Inc(pSrcDP_);
              pSrcL_ := pSrc_; Dec(pSrcL_);
              pSrcP_ := pSrc_; Inc(pSrcP_);

              for j_ := 0 to _work_dib.get_height - 1 do for i_ := 0 to _work_dib.get_width - 1 do
              begin
                if (j_ = 0) or (j_ = (_work_dib.get_height - 1)) or (i_ = 0) or (i_ = (_work_dib.get_width - 1)) then
                  pDst_.RGBA := pSrc_.RGBA
                else
                  case _anti_alias of
                    aaCross:
                    begin
                      pDst_.R := ((pSrcL_.R + pSrcP_.R + pSrcG_.R + pSrcD_.R) + 6 * pSrc_.R) div 10;
                      pDst_.G := ((pSrcL_.G + pSrcP_.G + pSrcG_.G + pSrcD_.G) + 6 * pSrc_.G) div 10;
                      pDst_.B := ((pSrcL_.B + pSrcP_.B + pSrcG_.B + pSrcD_.B) + 6 * pSrc_.B) div 10;
                    end;
                    aaDiagonal:
                    begin
                      pDst_.R := ((pSrcGL_.R + pSrcGP_.R + pSrcDL_.R + pSrcDP_.R) + 6 * pSrc_.R) div 10;
                      pDst_.G := ((pSrcGL_.G + pSrcGP_.G + pSrcDL_.G + pSrcDP_.G) + 6 * pSrc_.G) div 10;
                      pDst_.B := ((pSrcGL_.B + pSrcGP_.B + pSrcDL_.B + pSrcDP_.B) + 6 * pSrc_.B) div 10;
                    end;
                    aaFull:
                    begin
                      pDst_.R := ((pSrcGL_.R + pSrcG_.R + pSrcGP_.R + pSrcL_.R + pSrcP_.R +
                                  pSrcDL_.R + pSrcD_.R + pSrcDP_.R) div 2 + pSrc_.R) div 5;
                      pDst_.G := ((pSrcGL_.G + pSrcG_.G + pSrcGP_.G + pSrcL_.G + pSrcP_.G +
                                  pSrcDL_.G + pSrcD_.G + pSrcDP_.G) div 2 + pSrc_.G) div 5;
                      pDst_.B := ((pSrcGL_.B + pSrcG_.B + pSrcGP_.B + pSrcL_.B + pSrcP_.B +
                                  pSrcDL_.B + pSrcD_.B + pSrcDP_.B) div 2 + pSrc_.B) div 5;
                    end;
                  end;
                Inc(pDst_);
                Inc(pSrcGL_); Inc(pSrcG_); Inc(pSrcGP_);
                Inc(pSrcL_); Inc(pSrc_); Inc(pSrcP_);
                Inc(pSrcDL_); Inc(pSrcD_); Inc(pSrcDP_);
              end;
            end;
          end;

        bkg_color := get_bkg_color;

//_debug('anti_alias done');
        if _render_mode = rmFullRect then
          work_rgn_ := 0
        else
        begin
          _render_dib.initialize(_work_dib.get_width, _work_dib.get_height);

          if _render_mode = rmClipRects then
          begin
            render_cliprects(work_rgn_);
          end
          else
          begin
            if _render_mode = rmOnlyText then
            begin
              if _work_dib.get_height > 0 then
                CopyMemory(_render_dib.get_bits, _work_dib.get_bits, _render_dib.get_height * _render_dib.get_pitch)
            end
            else
            begin
              if _work_dib.get_height > 0 then
              begin
                set_mem(_render_dib.get_bits, _render_dib.get_height * _render_dib.get_width, bkg_color);
                bkg_color := swapColorValues(bkg_color);
                pSrc_ := PMyRGBQuad(_work_dib.get_bits);
                pDst_ := PMyRGBQuad(_render_dib.get_bits);

                case _render_mode of
                  rmThinBorder:
                  begin
                    pDstD_ := pDst_; Dec(pDstD_, line_size_);
                    pDstG_ := pDst_; Inc(pDstG_, line_size_);
                    pDstL_ := pDst_; Dec(pDstL_);
                    pDstP_ := pDst_; Inc(pDstP_);
  {
      takie cos musimy narysowac wokó³ ka¿dego zapalonego pixela:

                   +
                  +#+
                   +
  }
                    for j_ := 0 to _work_dib.get_height - 1 do for i_ := 0 to _work_dib.get_width - 1 do
                    begin
                      if (j_ = 0) or (j_ = (_work_dib.get_height - 1)) or (i_ = 0) or (i_ = (_work_dib.get_width - 1)) then
                        pDst_^ := pSrc_^
                      else
                        if pSrc_.RGBA <> bkg_color then
                        begin
                          pDst_^ := pSrc_^;
                          pDstG_^ := pSrc_^;
                          pDstD_^ := pSrc_^;
                          pDstL_^ := pSrc_^;
                          pDstP_^ := pSrc_^;
                        end;
                      Inc(pDst_);
                      Inc(pSrc_);
                      Inc(pDstG_);
                      Inc(pDstD_);
                      Inc(pDstL_);
                      Inc(pDstP_);
                    end;
                  end;
                  rmThickBorder:
                  begin
                    pDstD_ := pDst_; Dec(pDstD_, line_size_ + 2);
                    pDstG_ := pDst_; Inc(pDstG_, line_size_ - 2);
                    pDstL_ := pDst_; Dec(pDstL_, 2);
                    pDstDD_ := pDst_; Dec(pDstDD_, line_size_ * 2 + 1);
                    pDstGG_ := pDst_; Inc(pDstGG_, line_size_ * 2 - 1);
  {
      takie cos musimy narysowac wokó³ ka¿dego zapalonego pixela:

                  +++
                 +++++
                 ++#++
                 +++++
                  +++
  }
                    for j_ := 0 to _work_dib.get_height - 1 do for i_ := 0 to _work_dib.get_width - 1 do
                    begin
                      if (j_ <= 1) or (j_ >= (_work_dib.get_height - 2)) or
                         (i_ <= 1) or (i_ >= (_work_dib.get_width - 2)) or
                         (pSrc_.RGBA = bkg_color) then
                      begin
                        pDst_^ := pSrc_^;
                        Inc(pDstG_);
                        Inc(pDstL_);
                        Inc(pDstD_);
                        Inc(pDstGG_);
                        Inc(pDstDD_);
                      end
                      else
                      begin
                        pDstG_^ := pSrc_^; Inc(pDstG_); pDstG_^ := pSrc_^; Inc(pDstG_); pDstG_^ := pSrc_^; Inc(pDstG_); pDstG_^ := pSrc_^; Inc(pDstG_); pDstG_^ := pSrc_^; Dec(pDstG_, 3);
                        pDstL_^ := pSrc_^; Inc(pDstL_); pDstL_^ := pSrc_^; Inc(pDstL_); pDstL_^ := pSrc_^; Inc(pDstL_); pDstL_^ := pSrc_^; Inc(pDstL_); pDstL_^ := pSrc_^; Dec(pDstL_, 3);
                        pDstD_^ := pSrc_^; Inc(pDstD_); pDstD_^ := pSrc_^; Inc(pDstD_); pDstD_^ := pSrc_^; Inc(pDstD_); pDstD_^ := pSrc_^; Inc(pDstD_); pDstD_^ := pSrc_^; Dec(pDstD_, 3);
                        pDstGG_^ := pSrc_^; Inc(pDstGG_); pDstGG_^ := pSrc_^; Inc(pDstGG_); pDstGG_^ := pSrc_^; Dec(pDstGG_);
                        pDstDD_^ := pSrc_^; Inc(pDstDD_); pDstDD_^ := pSrc_^; Inc(pDstDD_); pDstDD_^ := pSrc_^; Dec(pDstDD_);
                      end;
                      Inc(pSrc_);
                    end;
                  end;
                  rmFatBorder:
                  begin
                    pDstD_ := pDst_; Dec(pDstD_, line_size_ + 2);
                    pDstG_ := pDst_; Inc(pDstG_, line_size_ - 2);
                    pDstL_ := pDst_; Dec(pDstL_, 3);
                    pDstDD_ := pDst_; Dec(pDstDD_, line_size_ * 2 + 2);
                    pDstGG_ := pDst_; Inc(pDstGG_, line_size_ * 2 - 2);
                    pDstDDD_ := pDst_; Dec(pDstDDD_, line_size_ * 3);
                    pDstGGG_ := pDst_; Inc(pDstGGG_, line_size_ * 3);
  {
      takie cos musimy narysowac wokó³ ka¿dego zapalonego pixela:

                   +
                 +++++
                 +++++
                +++#+++
                 +++++
                 +++++
                   +
  }
                    for j_ := 0 to _work_dib.get_height - 1 do for i_ := 0 to _work_dib.get_width - 1 do
                    begin
                      if (j_ <= 2) or (j_ >= (_work_dib.get_height - 3)) or
                         (i_ <= 2) or (i_ >= (_work_dib.get_width - 3)) or
                         (pSrc_.RGBA = bkg_color) then
                      begin
                        pDst_^ := pSrc_^;
                        Inc(pDstG_);
                        Inc(pDstL_);
                        Inc(pDstD_);
                        Inc(pDstGG_);
                        Inc(pDstDD_);
                        Inc(pDstGGG_);
                        Inc(pDstDDD_);
                      end
                      else
                      begin
                        pDstG_^ := pSrc_^; Inc(pDstG_); pDstG_^ := pSrc_^; Inc(pDstG_); pDstG_^ := pSrc_^; Inc(pDstG_); pDstG_^ := pSrc_^; Inc(pDstG_); pDstG_^ := pSrc_^; Dec(pDstG_, 3);
                        pDstL_^ := pSrc_^; Inc(pDstL_); pDstL_^ := pSrc_^; Inc(pDstL_); pDstL_^ := pSrc_^; Inc(pDstL_); pDstL_^ := pSrc_^; Inc(pDstL_); pDstL_^ := pSrc_^; Inc(pDstL_); pDstL_^ := pSrc_^; Inc(pDstL_); pDstL_^ := pSrc_^; Dec(pDstL_, 5);
                        pDstD_^ := pSrc_^; Inc(pDstD_); pDstD_^ := pSrc_^; Inc(pDstD_); pDstD_^ := pSrc_^; Inc(pDstD_); pDstD_^ := pSrc_^; Inc(pDstD_); pDstD_^ := pSrc_^; Dec(pDstD_, 3);
                        pDstGG_^ := pSrc_^; Inc(pDstGG_); pDstGG_^ := pSrc_^; Inc(pDstGG_); pDstGG_^ := pSrc_^; Inc(pDstGG_); pDstGG_^ := pSrc_^; Inc(pDstGG_); pDstGG_^ := pSrc_^; Dec(pDstGG_, 3);
                        pDstDD_^ := pSrc_^; Inc(pDstDD_); pDstDD_^ := pSrc_^; Inc(pDstDD_); pDstDD_^ := pSrc_^; Inc(pDstDD_); pDstDD_^ := pSrc_^; Inc(pDstDD_); pDstDD_^ := pSrc_^; Dec(pDstDD_, 3);
                        pDstGGG_^ := pSrc_^; Inc(pDstGGG_);
                        pDstDDD_^ := pSrc_^; Inc(pDstDDD_);
                      end;
                      Inc(pSrc_);
                    end;
                  end;
                end;
              end;
              bkg_color := swapColorValues(bkg_color);
            end;
            if not (_use_overlay and _is_overlay) then
              work_rgn_ := bmp_to_region(_render_dib, bkg_color);
          end;
        end;
//_debug('render done');

        if (_anti_alias <> aaNone) and (pantialiased_ <> nil) then
          CopyMemory(_work_dib.get_bits, pantialiased_, last_alloc_size_);

        if _render_mode <> rmFullRect then
          if _use_overlay and _is_overlay and (_work_dib.get_height > 0) then
            bmp_for_overlay(_work_dib, _render_dib, new_rect_, _overlaycolor, bkg_color);

        free_work_data;

        _paint_ddb.initialize(_work_dib.get_width, _work_dib.get_height);
        BitBlt(_paint_ddb.get_dc, 0, 0, _paint_ddb.get_width, _paint_ddb.get_height,
               _work_dib.get_dc, 0, 0, SRCCOPY);
      finally
//_debug('finally');
        unlock;
      end;

      if not _terminated then
      begin
        SetWindowPos(
          _handle, HWND_TOP,
          new_rect_.Left,
          new_rect_.Top,
          new_rect_.Right - new_rect_.Left,
          new_rect_.Bottom - new_rect_.Top,
          SWP_NOACTIVATE);
      end;

      if _use_overlay and _is_overlay then
      begin
        if old_rgn_ <> 0 then
        begin
          _rgns.old_rgn := old_rgn_;
          _rgns.new_rgn := 0;
          PostMessage(_handle, WM_SETREGION, integer(@_rgns), integer(true));
        end
        else
          InvalidateRect(_handle, nil, true);
      end
      else
      begin
        _rgns.old_rgn := old_rgn_;
        _rgns.new_rgn := work_rgn_;
        PostMessage(_handle, WM_SETREGION, integer(@_rgns), integer(true));
      end;

//      if old_rgn_ <> 0 then
//        DeleteObject(old_rgn_);
      old_rgn_ := work_rgn_;
      work_rgn_ := 0;
//      InvalidateRect(_handle, nil, true);
    end;
  finally
    if pantialiased_ <> nil then
      SysFreeMem(pantialiased_);
    _rgns.old_rgn := old_rgn_;
    _rgns.new_rgn := 0;
    PostMessage(_handle, WM_SETREGION, integer(@_rgns), integer(false));
//    if old_rgn_ <> 0 then
//      DeleteObject(old_rgn_);
    if work_rgn_ <> 0 then
      DeleteObject(work_rgn_);
  end;
end;

// procedura okna dla kontrolki renderera
function WindowProc(hWnd: HWND; Msg, wParam, lParam: cardinal): cardinal; stdcall;
var
  hdc_: HDC;
  ar_: TAbstractRenderer;
  ps_: PAINTSTRUCT;
  rc_: TRect;
begin
  Result := 0;
  case Msg of
    WM_SETCURSOR:
    begin
      ar_ := TAbstractRenderer(Pointer(GetWindowLong(hWnd, GWL_USERDATA)));
      if (ar_._render_mode <> rmFullRect) and
         (ar_._cursor <> nil) then
      begin
        SetCursor(LoadCursor(0, MAKEINTRESOURCE(ar_._cursor)));
        Result := 1;
        exit;
      end;
    end;
    WM_CREATE:
    begin
      SetWindowLong(hWnd, GWL_USERDATA, THandle(CREATESTRUCT(Pointer(lParam)^).lpCreateParams));
      exit;
    end;
    WM_SETREGION:
    begin
//_debug('WM_SETREGION 1');
//      ar_ := TAbstractRenderer(Pointer(GetWindowLong(hWnd, GWL_USERDATA)));
//_debug('WM_SETREGION 2');
      SetWindowRgn(hWnd, pRgnRec(wParam).new_rgn, LongBool(lParam));
      if pRgnRec(wParam).old_rgn <> 0 then
        DeleteObject(pRgnRec(wParam).old_rgn);
//_debug('WM_SETREGION 3');
      InvalidateRect(hWnd, nil, true);
//_debug('WM_SETREGION 4');
      exit;
    end;
    WM_PAINT:
    begin
//?TODO przy zmianie rozdzielczosci blokuja sie watki
      ar_ := TAbstractRenderer(Pointer(GetWindowLong(hWnd, GWL_USERDATA)));
{$ifdef _debug}
  _debug(ar_.ClassName + ': WM_PAINT prebegin');
{$endif}
      ar_.lock;
{$ifdef _debug}
  _debug(ar_.ClassName + ': WM_PAINT begin');
{$endif}
      try
        if ar_._paint_ddb.get_dc > 0 then
        begin
          GetClientRect(hWnd, rc_);
          hdc_ := BeginPaint(hWnd, ps_);
          BitBlt(
            hdc_,
            (rc_.Right - ar_._paint_ddb.get_width) div 2,
            0,
            ar_._paint_ddb.get_width,
            ar_._paint_ddb.get_height,
            ar_._paint_ddb.get_dc,
            0,
            0,
            SRCCOPY);
          EndPaint(hWnd, ps_);
          exit;
        end;
      finally
{$ifdef _debug}
  _debug(ar_.ClassName + ': WM_PAINT end');
{$endif}
        ar_.unlock;
      end;
    end;
    WM_LBUTTONDOWN:
    begin
      TAbstractRenderer(Pointer(GetWindowLong(hWnd, GWL_USERDATA))).mouse_down(Point(LOWORD(lParam), HIWORD(lParam)));
    end;
    WM_LBUTTONUP:
    begin
      TAbstractRenderer(Pointer(GetWindowLong(hWnd, GWL_USERDATA))).mouse_up(Point(LOWORD(lParam), HIWORD(lParam)));
    end;
    WM_MOUSEMOVE:
    begin
      TAbstractRenderer(Pointer(GetWindowLong(hWnd, GWL_USERDATA))).mouse_move(Point(LOWORD(lParam), HIWORD(lParam)), wParam);
    end;
    WM_MOVEWINDOW:
    begin
      MoveWindow(hWnd, 0, 0, 0, 0, true);
    end;
  end;
  Result := DefWindowProc(hWnd, Msg, wParam, lParam);
end;

{ TAbstractRenderer }

procedure TAbstractRenderer.bmp_for_overlay(paint_bmp, mask_bmp: TBmp;
  new_rect: TRect; color_key, color_mask: COLORREF);
var
  pMask_, pPaint_: PDWORD;
  i_, j_: integer;
  overlay_from_line_, overlay_to_line_: integer;
begin
  color_mask := swapColorValues(color_mask);
  color_key := swapColorValues(color_key);
//  mask_bmp.SaveToFile('mask_bmp');
  pMask_ := mask_bmp.get_bits;
  pPaint_ := paint_bmp.get_bits;

  if IsRectEmpty(_video_rect) then
  begin
    overlay_from_line_ := 1;
    overlay_to_line_ := 0;
  end
  else
  begin
    overlay_from_line_ := _video_rect.Top - new_rect.Top;
    overlay_to_line_ := _video_rect.Bottom - new_rect.Top;
  end;

  j_ := mask_bmp.get_height - 1;
  while j_ >= 0 do
  begin
    if ((j_ > overlay_from_line_) and (j_ < overlay_to_line_)) or
        (color_mask <> 0) then
      for i_ := 0 to mask_bmp.get_width - 1 do
      begin
        if pMask_^ = color_mask then
          if (j_ > overlay_from_line_) and (j_ < overlay_to_line_) then
            pPaint_^ := color_key
          else
            pPaint_^ := 0;
        inc(pPaint_);
        inc(pMask_);
      end
    else
    begin
      inc(pPaint_, mask_bmp.get_width);
      inc(pMask_, mask_bmp.get_width);
    end;
    dec(j_);
  end;
//  paint_bmp.SaveToFile('paint_bmp');
end;

function TAbstractRenderer.bmp_to_region(bmp: TBmp;
  color_key: COLORREF): HRGN;
const
  ALLOC_UNIT = 100;
var
  rtn_rgn_: HRGN;
  x_, y_: Longint;
  max_rects_: DWORD;
  hData_: Cardinal;
  pData_: pRGNDATA;
  h_, h1_: HRGN;
  x0_: Longint;
  p_: PDWORD;
  pr_: pRect;
  tmp_rect_: TRect;
begin
  color_key := swapColorValues(color_key);

  rtn_rgn_ := 0;
  (* For better performances, we will use the ExtCreateRegion()
    function to create the region. This function take a RGNDATA
    structure on entry. We will add rectangles by amount of
    ALLOC_UNIT number in this structure. *)
  max_rects_ := ALLOC_UNIT;
  hData_ := GlobalAlloc(GMEM_MOVEABLE, sizeof(TRGNDATAHEADER) +
    (sizeof(TRECT) * max_rects_));
  pData_ := pRGNDATA(GlobalLock(hData_));
  pData_.rdh.dwSize := sizeof(TRGNDATAHEADER);
  pData_.rdh.iType := RDH_RECTANGLES;
  pData_.rdh.nCount := 0;
  pData_.rdh.nRgnSize := 0;
  SetRect(pData_.rdh.rcBound, MAXLONG, MAXLONG, 0, 0);

  (* Scan each bitmap row from bottom to top (the bitmap
    is inverted vertically) *)
  for y_ := 0  to Bmp.get_height - 1 do
  begin
    (* Scan each bitmap pixel from left to right *)
    x_ := 0;
    p_ := Bmp.get_bits;
    inc(p_, bmp.get_width * (Bmp.get_height - 1 - y_));
    while x_ < Bmp.get_width do
    begin
      (* Search for a continuous range of "non transparent pixels" *)
      x0_ := x_;
      while (x_ < Bmp.get_width) do
      begin
        if p_^ = color_key then
          break;

        Inc(p_);
        Inc(x_);
      end;

      if (x_ > x0_) then
      begin
        (* Add the pixels (x0_, y_) to (x_, y_+1) as a new
          rectangle in the region *)
        if (pData_.rdh.nCount >= max_rects_) then
        begin
          GlobalUnlock(hData_);
          max_rects_ := max_rects_ + ALLOC_UNIT;
          hData_ := GlobalReAlloc(hData_, sizeof(TRGNDATAHEADER) +
            (sizeof(TRECT) * max_rects_), GMEM_MOVEABLE);
          pData_ := pRGNDATA(GlobalLock(hData_));
        end;
        pr_ := pRECT(@pData_.Buffer);
        SetRect(tmp_rect_, x0_, y_, x_, y_ + 1);
        pRect(Cardinal(pr_) + (Cardinal(pData_.rdh.nCount)
          * SizeOf(TRect)))^ := tmp_rect_;
        if (x0_ < pData_.rdh.rcBound.left) then
          pData_.rdh.rcBound.left := x0_;
        if (y_ < pData_.rdh.rcBound.top) then
          pData_.rdh.rcBound.top := y_;
        if (x_ > pData_.rdh.rcBound.right) then
          pData_.rdh.rcBound.right := x_;
        if (y_+1 > pData_.rdh.rcBound.bottom) then
          pData_.rdh.rcBound.bottom := y_+1;
        inc(pData_.rdh.nCount);

        (* On Windows98, ExtCreateRegion() may fail if the number
          of rectangles is too large (ie: > 4000). Therefore, we have
          to create the region by multiple steps. *)
        if (pData_.rdh.nCount = 2000) then
        begin
          h1_ := ExtCreateRegion(nil, sizeof(TRGNDATAHEADER) +
            (sizeof(TRECT) * max_rects_), pData_^);
          if (rtn_rgn_ <> 0) then
          begin
            CombineRgn(rtn_rgn_, rtn_rgn_, h1_, RGN_OR);
            DeleteObject(h1_);
          end
          else
            rtn_rgn_ := h1_;
          pData_.rdh.nCount := 0;
          SetRect(pData_.rdh.rcBound, MAXLONG, MAXLONG, 0, 0);
        end;
      end;
      Inc(p_);
      Inc(x_);
    end;
  end;

  (* Create or extend the region with the remaining rectangles *)
  if pData_.rdh.nCount > 0 then
  begin
    h_ := ExtCreateRegion(nil, sizeof(TRGNDATAHEADER) + (sizeof(TRECT) *
      max_rects_), pData_^);
    if (rtn_rgn_ <> 0) then
    begin
      CombineRgn(rtn_rgn_, rtn_rgn_, h_, RGN_OR);
      DeleteObject(h_);
    end else
      rtn_rgn_ := h_;
  end;

  GlobalFree(hData_);
  Result := rtn_rgn_;
end;

procedure TAbstractRenderer.wait;
begin
  _wait_result := WaitForSingleObject(_event, _wait_time);
end;

constructor TAbstractRenderer.Create(parent: HWND);
begin
  InitializeCriticalSection(_cs);
  CreateWnd(parent);
  _event := CreateEvent(nil, false, false, nil);
  _wait_time := 10000;//INFINITE;
  _freeze_visible := false;
  _thread := 0;
  _terminated := false;
  _h_margin := 0;
  _v_margin := 0;
  _video_rect := Rect(0, 0, 0, 0);

  _work_dib := TDIBmp.Create;
  _render_dib := TDIBmp.Create;
  _paint_ddb := TDDBmp.Create;
//  _work_font := TFnt.Create;
end;

function TAbstractRenderer.CreateWnd(parent: HWND): boolean;
const
  clsName = 'CP_REND';
var
  wndCls_: WNDCLASSEX;
begin
  wndCls_.cbSize := sizeof(WNDCLASSEX);
  wndCls_.lpszClassName := PChar(clsName);
  wndCls_.style := CS_HREDRAW or CS_VREDRAW;// or CS_OWNDC{or CS_PARENTDC};
  wndCls_.lpfnWndProc := @WindowProc;
  wndCls_.cbClsExtra := 0;
  wndCls_.cbWndExtra := 0;
  wndCls_.hInstance := hInstance;
  wndCls_.hIcon := 0;
  wndCls_.hIconSm := 0;
  wndCls_.hCursor := 0;
  wndCls_.hbrBackground := GetStockObject(BLACK_BRUSH);
  wndCls_.lpszMenuName := nil;

  _handle := 0;
  if (RegisterClassEx(wndCls_) > 0) or (GetLastError = ERROR_CLASS_ALREADY_EXISTS) then
  begin
    _handle := CreateWindowEx(
      0,
      PChar(clsName),
      nil,
      WS_CHILD or WS_VISIBLE or WS_CLIPCHILDREN or WS_CLIPSIBLINGS,
      0, 0, 0, 0,
      parent,
      0,
      hInstance,
      Self);
    UpdateWindow(_handle);
  end;
  Result := _handle > 0;
end;

destructor TAbstractRenderer.Destroy;
begin
  disable;
  _work_dib.Free;
//  _work_font.Free;
  _render_dib.Free;
  _paint_ddb.Free;
  CloseHandle(_event);
  DeleteCriticalSection(_cs);
  if _handle > 0 then
    DestroyWindow(_handle);
  inherited Destroy;
end;

function TAbstractRenderer.disable: boolean;
begin
  if _thread > 0 then
  begin
    _terminated := true;
//_debug('disable renderer (SetEvent)');
    SetEvent(_event);
//    WaitForSingleObject(_thread, INFINITE);
    Result := WaitForSingleObject(_thread, 100) <> WAIT_TIMEOUT;

//_debug('renderer disabled (SetEvent)');
    if Result then
    begin
      _thread := 0;
      _terminated := false;
  //    ShowWindow(_handle, SW_HIDE);
      MoveWindow(_handle, 0, 0, 0, 0, true);
    end;
  end
  else
    Result := true;
end;

procedure TAbstractRenderer.enable;
var
  ti_: DWORD;
begin
  if _thread = 0 then
    _thread := BeginThread(nil, 0, @render_thread, Self, 0, ti_);
//  ShowWindow(_handle, SW_SHOW);
{$ifdef _debug}
  _debug_register_thread(ClassName, ti_);
{$endif}
end;

function TAbstractRenderer.get_h_margin: integer;
begin
  lock;
  Result := _h_margin;
  unlock;
end;

function TAbstractRenderer.get_height: integer;
var
  r: TRect;
begin
  GetWindowRect(_handle, r);
  Result := r.Bottom - r.Top;
end;

function TAbstractRenderer.get_v_margin: integer;
begin
  lock;
  Result := _v_margin;
  unlock;
end;

function TAbstractRenderer.get_width: integer;
var
  r: TRect;
begin
  GetWindowRect(_handle, r);
  Result := r.Right - r.Left;
end;

procedure TAbstractRenderer.lock;
begin
  EnterCriticalSection(_cs);
end;

function TAbstractRenderer.trylock: boolean;
begin
  Result := TryEnterCriticalSection(_cs);
end;

procedure TAbstractRenderer.refresh;
begin
//  BringWindowToTop(_handle);
//_debug('refresh renderer (SetEvent)');
  lock;
  SetEvent(_event);
  unlock;
//_debug('renderer refreshed (SetEvent)');
end;

procedure TAbstractRenderer.set_cursor(value: PAnsiChar);
begin
  _cursor := value;
end;

procedure TAbstractRenderer.set_h_margin(ms: integer);
begin
  lock;
  _h_margin := ms;
  unlock;
end;

procedure TAbstractRenderer.set_overlay_colorkey(key: COLORREF;
  is_overlay: boolean);
begin
  _is_overlay := is_overlay;
  _overlaycolor := key;
//WARRNING moze byc problem z watkami
{  if Assigned(_overlay_colorkey) then
  begin
    Result := _overlay_colorkey(key);
  end
  else
    Result := false;}
end;

procedure TAbstractRenderer.set_parent_rect(value: TRect);
begin
  lock;
  _parent_rect := value;
  unlock;
end;

procedure TAbstractRenderer.set_use_overlay(ov: boolean);
begin
  lock;
  _use_overlay := ov;
  unlock;
end;

procedure TAbstractRenderer.set_v_margin(ms: integer);
begin
  lock;
  _v_margin := ms;
  unlock;
end;

function TAbstractRenderer.set_video_rect(value: TRect): boolean;
begin
  Result := trylock;
  if not Result then
    exit;
  _video_rect := value;
  unlock;
end;

procedure TAbstractRenderer.unlock;
begin
  LeaveCriticalSection(_cs);
end;

function TAbstractRenderer.check_source_data: boolean;
begin
  Result := _wait_result <> WAIT_TIMEOUT;
end;

procedure TAbstractRenderer.test;
begin
//todo
end;

procedure TAbstractRenderer.set_max_sub_width(value: integer);
begin
  _max_sub_width := value;
end;

procedure TAbstractRenderer.set_max_sub_options(active, percent: boolean);
begin
  _max_sub_width_active := active;
  _max_sub_width_percent := percent;
end;

function TAbstractRenderer.get_fixed_parent_rect: TRect;
begin
  lock;
  Result := _parent_rect;
  if _max_sub_width_active and
     (_max_sub_width_percent or (_parent_rect.Right > _max_sub_width)) then
  begin
//    MessageBox(0, '!!!!', nil, 0);
    if _max_sub_width_percent then
      Result.Right := Result.Right * _max_sub_width div 100
    else
      Result.Right := _max_sub_width;
    OffsetRect(Result, (_parent_rect.Right - Result.Right) div 2, 0);
  end;
  unlock;
end;

{ TCustomTextRenderer }

function TCustomTextRenderer.calc_font_size(size: integer): integer;
begin
//  Result := size;
  if round(size * _font_scale) > MinFontSize then
    Result := round(size * _font_scale)
  else
    Result := MinFontSize;
end;

procedure TCustomTextRenderer.clear;
begin
  lock;
  if _text <> '' then
  begin
    _text := '';
// todo niepotrzebnie odpala watek za kazdym razem
//_debug('clear renderer (SetEvent)');
    SetEvent(_event);
//_debug('renderer cleared (SetEvent)');
  end;
//  MoveWindow(_handle, 0, 0, 0, 0, true);
  unlock;
 // wyczysc napisy
end;

{
constructor TCustomTextRenderer.Create(parent: HWND);
begin

end;

destructor TCustomTextRenderer.Destroy;
begin

end;
}

procedure TCustomTextRenderer.draw_text(dc: HDC; text: string;
  var work_rect: TRect; draw_style: cardinal);
var
  nullRgn: HRGN;
begin
  prepare_subtitle(pmDrawText, dc, text, work_rect, nullRgn, draw_style);
end;

function TCustomTextRenderer.check_source_data: boolean;
begin
  Result := (inherited check_source_data);
  if Result then
    Result := Trim(_text) <> ''
  else
    _text := '';
end;

function TCustomTextRenderer.get_text: string;
begin
  lock;
  Result := _text;
  unlock;
end;

procedure TCustomTextRenderer.set_font_scale(value: double);
begin
  lock;
  _font_scale := value;
  unlock;
end;

procedure TCustomTextRenderer.render_rects;
var
  nullRgn: HRGN;
  work_rect: TRect;
begin
  work_rect := Rect(0, 0, _work_dib.get_width, _work_dib.get_height);
  prepare_subtitle(pmTextToRects, _render_dib.get_dc, _text, work_rect, nullRgn, DT_CALCRECT);
end;

function TCustomTextRenderer.render_region: HRGN;
var
  work_rect: TRect;
begin
  work_rect := Rect(0, 0, _work_dib.get_width, _work_dib.get_height);
  prepare_subtitle(pmTextToRegion, _render_dib.get_dc, _text, work_rect, Result, DT_CALCRECT);
end;

function TCustomTextRenderer.calc_position(work_rect: TRect): TRect;
var
  pr_: TRect;
  pr_left_: integer;
  lr_margin_,
  tb_margin_: integer;
begin
// TODO - get_parent_rect
  pr_ := get_fixed_parent_rect;
  pr_left_ := pr_.Left;
  if pr_left_ > (_parent_rect.Right * _h_margin div 100) then
    lr_margin_ := pr_left_
  else
    lr_margin_ := (_parent_rect.Right * _h_margin div 100);

  tb_margin_ := (_parent_rect.Bottom * _v_margin div 100);

  if _render_mode <> rmFullRect then
  begin
    case _curr_style.position.hPosition of
      phLeft:
        OffsetRect(work_rect, lr_margin_, 0);
      phCenter:
        OffsetRect(work_rect, (_parent_rect.Right - work_rect.Right) div 2, 0);
      phRight:
        OffsetRect(work_rect, _parent_rect.Right - work_rect.Right - lr_margin_, 0);
    end;
    case _curr_style.position.vPosition of
      pvTop:
        OffsetRect(work_rect, 0, tb_margin_);
      pvCenter:
        OffsetRect(work_rect, 0, (_parent_rect.Bottom - work_rect.Bottom) div 2);
      pvBottom:
        OffsetRect(work_rect, 0, _parent_rect.Bottom - work_rect.Bottom - tb_margin_);
    end;
  end;
//  else
//    OffsetRect(work_rect, (_parent_rect.Right - work_rect.Right) div 2, 0);

  Result := work_rect;
end;

function TCustomTextRenderer.get_bkg_color: COLORREF;
begin
  Result := _curr_style.bkg_color;
{  Result :=
    ((Result and $00ff0000) shr 16) or
    (Result and $0000ff00) or
    ((Result and $000000ff) shl 16);}
end;

procedure TCustomTextRenderer.render(subtitle: string);
begin
  lock;
  if _text <> subtitle then
  begin
    _text := subtitle;
// todo niepotrzebnie odpala watek za kazdym razem
//_debug('render: ' + subtitle + ' (SetEvent)');
    SetEvent(_event);
//_debug('rendered: ' + subtitle + ' (SetEvent)');
  end;
  unlock;
end;

{ TSubtitlesRenderer }

constructor TSubtitlesRenderer.Create(parent: HWND);
begin
  inherited Create(parent);
  _line_parser := TSubtitlesParser.Create;
  _whole_font := TFnt.Create;
  _def_draw_style :=
    DT_EXPANDTABS or DT_WORDBREAK or DT_CENTER or DT_NOPREFIX or DT_NOCLIP;
  _adjust_position := true;
end;

destructor TSubtitlesRenderer.Destroy;
begin
  inherited Destroy;
  _line_parser.Free;
  _whole_font.Free;
end;

procedure TSubtitlesRenderer.prepare_subtitle(pm: TPrepareMode; dc: HDC;
  text: string; var work_rect: TRect; var region: HRGN;
  draw_style: cardinal);

  procedure add_rect(var DstRect: TRect; const Src1Rect, Src2Rect: TRect);
  begin
    DstRect := Src2Rect;
    if not IsRectEmpty(Src1Rect) then
    begin
      DstRect.Bottom := DstRect.Bottom + Src1Rect.Bottom;
      if Src1Rect.Right > Src2Rect.Right then
        DstRect.Right := Src1Rect.Right;
    end;
  end;

var
  line_start_, line_stop_: PChar;
  new_top_: integer;
  temp_rect_,
  temp_work_rect: TRect;
  temp_rgn_: HRGN;    // czy to jest potrzebne jesli tylko obliczam rozmiar napisow?
  only_calc_size_: boolean;
  len_: integer;
  line_found_,
  whole_found_: boolean;
  ss_: TSubtitlesStyle;
  old_brush_: HBRUSH;
  _old_font: HFONT;
  font_: TFnt;
  s: string;
begin
  line_start_ := PChar(text);
  only_calc_size_ := (draw_style and DT_CALCRECT) <> 0;
  _old_font := 0;
  new_top_ := 0;
  temp_work_rect := work_rect;

  case pm of
    pmTextToRegion:
    begin
      region := CreateRectRgn(0, 0, 0, 0);
    end;
{
    pmTextToRects:
    begin
    end;
}
    pmDrawText:
    begin
      if only_calc_size_ then
        SetRectEmpty(work_rect)
      else
        temp_rect_ := work_rect;
    end;
  end;

  line_found_ := false;
  whole_found_ := false;
  font_ := TFnt.Create;
  try
    ss_ := _curr_style;

    while line_start_ <> nil do
    begin
      if pm <> pmDrawText then
        temp_rect_ := work_rect;

      _line_parser.parse(line_start_, line_stop_, line_found_, whole_found_, false);

      if line_found_ then
      begin
        _line_parser.get_line_style(ss_);
        if (pm <> pmTextToRects) and _line_parser.is_line_bkg_color then
          SetBkColor(dc, ss_.bkg_color);

        if (not only_calc_size_) and _line_parser.is_line_font_color then
          SetTextColor(dc, ss_.font_color);

        if _line_parser.is_line_font then
        begin
          if _line_parser.is_line_font_size() then
            ss_.fd.size := calc_font_size(ss_.fd.size);
{          if faBold in ss_.fd.attr then
            s := 'fsBold, ';
          if faItalic in ss_.fd.attr then
            s := s + 'faItalic, ';
          if faUnderline in ss_.fd.attr then
            s := s + 'faUnderline';
          MessageBox(0, PChar(Format(
          'ss_.fd.name: %s'#13'ss_.fd.size: %d'#13'ss_.fd.attr: %s'#13'ss_.fd.charset: %d',
          [ss_.fd.name, ss_.fd.size, s, ss_.fd.charset])), nil, MB_SETFOREGROUND);}
          font_.initialize(ss_.fd);
          _old_font := SelectObject(dc, font_.get_handle);
        end;
      end;

      len_ := line_stop_ - line_start_;
      if pm = pmDrawText then
      begin
        if only_calc_size_ then
        begin
          temp_rect_ := temp_work_rect;
//TODO:
          if len_ = 0 then
            DrawText(dc, ' ', 1, temp_rect_, _def_draw_style or draw_style)
          else
            DrawText(dc, line_start_, len_, temp_rect_, _def_draw_style or draw_style);
          add_rect(work_rect, temp_rect_, work_rect);
        end
        else
        begin
          inc(temp_rect_.Top, new_top_);
//TODO:
          if len_ = 0 then
            new_top_ := DrawText(dc, ' ', 1, temp_rect_, _def_draw_style or draw_style)
          else
            new_top_ := DrawText(dc, line_start_, len_, temp_rect_, _def_draw_style or draw_style);
        end;
      end
      else
      begin
//TODO:
        if len_ = 0 then
          new_top_ := DrawText(dc, ' ', 1, temp_rect_, _def_draw_style or draw_style)
        else
          DrawText(dc, line_start_, len_, temp_rect_, _def_draw_style or draw_style);
        inc(temp_rect_.Right, 2 * text_border);
        inc(temp_rect_.Bottom, 2 * text_border);
        OffsetRect(temp_rect_, (work_rect.Right - temp_rect_.Right) div 2, new_top_);

        if pm = pmTextToRects then
        begin
          if _line_parser.is_line_bkg_color then
          begin
            old_brush_ := CreateSolidBrush(ss_.bkg_color);
            FillRect(dc, temp_rect_, old_brush_);
            DeleteObject(old_brush_);
          end
          else
            FillRect(dc, temp_rect_, GetStockObject(WHITE_BRUSH));
        end
        else
        begin
          with temp_rect_ do
            temp_rgn_ := CreateRectRgn(Left, Top, Right, Bottom);
          CombineRgn(region, region, temp_rgn_, RGN_OR);
          DeleteObject(temp_rgn_);
        end;

        inc(new_top_, temp_rect_.Bottom - temp_rect_.Top - text_border);
      end;

      line_start_ := StrPos(line_stop_, #13);
      if line_start_ <> nil then
        inc(line_start_);

      if line_found_ then
      begin
        if (pm <> pmTextToRects) and _line_parser.is_line_bkg_color then
          SetBkColor(dc, _curr_style.bkg_color);

        if (not only_calc_size_) and _line_parser.is_line_font_color then
          SetTextColor(dc, _curr_style.font_color);

        if _line_parser.is_line_font then
        begin
          SelectObject(dc, _old_font);
          font_.uninitialize;
        end;
        _line_parser.clear(false);
        ss_ := _curr_style;
      end;
    end;
  finally
    font_.Free;
  end;
end;

procedure TSubtitlesRenderer.get_curr_style(text: PChar);
var
  line_start_,
  line_stop_: PChar;
  line_found_,
  whole_found_: boolean;
begin
  _curr_style := _style;
  whole_found_ := false;
  line_start_ := text;
  if line_start_ <> nil then
  begin
    _line_parser.parse(line_start_, line_stop_, line_found_, whole_found_, true);
    if whole_found_ then
      _line_parser.get_whole_style(_curr_style);
  end;
end;

procedure TSubtitlesRenderer.set_fixed_rows(fr: integer);
begin
  lock;
  _fixed_rows := fr;
  unlock;
end;

function TSubtitlesRenderer.get_fixed_size: integer;
begin
//  lock;
  Result := _fixed_scaled_size;
//  Result := round(_fixed_size * _font_scale);
//  unlock;
end;

procedure TSubtitlesRenderer.render_cliprects(var rgn: HRGN);
begin
  if _is_whole_font then
    _old_font := SelectObject(_render_dib.get_dc, _whole_font.get_handle);
  if _use_overlay and _is_overlay then
  begin
    if _work_dib.get_height > 0 then
      set_mem(_render_dib.get_bits, _render_dib.get_height * _render_dib.get_width, _curr_style.bkg_color);
    render_rects;
  end
  else
    rgn := render_region;
  if _is_whole_font then
    SelectObject(_render_dib.get_dc, _old_font);
end;

function TSubtitlesRenderer.init_work_data(var new_rect: TRect): boolean;
var
  work_rect_: TRect;
//  s: string;
begin
  _line_parser.clear(true);
  get_curr_style(PChar(_text));
//TODO czy dobrze porownywane sa style????
  _is_whole_font := not CompareMem(@_curr_style.fd, @_style.fd, sizeof(TFontData));
  _curr_style.fd.size := calc_font_size(_curr_style.fd.size);

//TODO - nie resetowac fontu niepotrzebnie
  _is_whole_font := true;
  if _work_dib.get_dc = 0 then
    _work_dib.initialize(1, 1);

//TODO sprawdzic czy font nie jest zwalony gdy jest wybrany w kontekscie
  if _is_whole_font then
    _whole_font.initialize(_curr_style.fd);

//  if (_render_mode = rmFullRect) then
//    GetClientRect(_handle, work_rect)
//  else
  begin
    work_rect_ := get_fixed_parent_rect;
    if work_rect_.Left > 0 then
      OffsetRect(work_rect_, -work_rect_.Left, 0);
    if _is_whole_font then
      _old_font := SelectObject(_work_dib.get_dc, _whole_font.get_handle);
    draw_text(_work_dib.get_dc, _text, work_rect_, DT_CALCRECT);
//  s := Format('(%d,%d)(%d,%d)', [work_rect.Left, work_rect.Top, work_rect.Right, work_rect.Bottom]);
    if _is_whole_font then
      SelectObject(_work_dib.get_dc, _old_font);

    inc(work_rect_.Bottom, 2 * text_border);
    inc(work_rect_.Right, 2 * text_border);
//TODO get_parent_rect
//    if (_render_mode = rmFullRect) and ((work_rect_.Right - work_rect_.Left) < _parent_rect.Right) then
//    begin
//      OffsetRect(work_rect_, (_parent_rect.Right - (work_rect_.Right - work_rect_.Left)) div 2, 0);
//    end
  end;

  Result := _work_dib.initialize(work_rect_.Right - work_rect_.Left, work_rect_.Bottom);
  if not Result then
  begin
    _whole_font.uninitialize;
    exit;
  end;

//  _work_dib.SaveToFile('_work_dib');
  new_rect := calc_position(work_rect_);
//  s := s + Format(' (%d,%d)(%d,%d)', [work_rect.Left, work_rect.Top, work_rect.Right, work_rect.Bottom]);
//  SetWindowText(GetParent(_handle), PChar(s));

{$ifdef _debug}
//_debug('text: "' + _text + '"');
//_debugFmt('new_rect: %d, %d; %d, %d', [new_rect.Left, new_rect.Top, new_rect.Right, new_rect.Bottom]);
{$endif}
  if _work_dib.get_height > 0 then
    set_mem(
      _work_dib.get_bits,
      _work_dib.get_height * _work_dib.get_width,
      _curr_style.bkg_color);

  SetTextColor(_work_dib.get_dc, _curr_style.font_color);
  SetBkColor(_work_dib.get_dc, _curr_style.bkg_color);
  if _is_whole_font then
    _old_font := SelectObject(_work_dib.get_dc, _whole_font.get_handle);
  InflateRect(work_rect_, -text_border, -text_border);
  draw_text(_work_dib.get_dc, _text, work_rect_, 0);
//  InflateRect(work_rect, text_border, text_border);
  if _is_whole_font then
    SelectObject(_work_dib.get_dc, _old_font);
end;

procedure TSubtitlesRenderer.free_work_data;
begin
  if _is_whole_font then
    _whole_font.uninitialize;
end;

procedure TSubtitlesRenderer.set_font_size(value: integer);
begin
  lock;
  _style.fd.size := value;
  calc_fixed_size;
  unlock;
end;

function TSubtitlesRenderer.calc_position(work_rect: TRect): TRect;
var
  pr_: TRect;
begin
// TODO - get_parent_rect
  if (_render_mode = rmFullRect) then
    if (_style.position.hPosition = phCenter) and (_style.position.vPosition = pvCenter) then
      Result := _parent_rect
    else
    begin
      pr_ := get_fixed_parent_rect;
      SetRect(
        Result,
        pr_.Left,
        pr_.Bottom,
        pr_.Right,
        pr_.Bottom + _fixed_rows * get_fixed_size);
      inc(Result.Top, (Result.Bottom - Result.Top) - (work_rect.Bottom - work_rect.Top));
    end
  else
    Result := inherited calc_position(work_rect);

  if _adjust_position then
    if not IsRectEmpty(_video_rect) then
    begin
      if _video_rect.Bottom < Result.Top then
        OffsetRect(Result, 0, _video_rect.Bottom - Result.Top + 5);
    end;
end;

procedure TSubtitlesRenderer.mouse_down(p: TPoint);
var
  tempMargin_v: integer;
  boundRect_: TRect;
begin
  if (_render_mode = rmFullRect) or (_style.position.vPosition = pvCenter) then
    exit;

  _drag_point := p;
  _freeze_visible := true;
  SetCapture(_handle);
  if Assigned(_begin_update) then
    _begin_update;
end;

procedure TSubtitlesRenderer.mouse_move(p: TPoint; state: DWORD);
var
  boundRect_: TRect;
begin
  if (_render_mode = rmFullRect) or (_style.position.vPosition = pvCenter) then
    exit;

  if ((state and VK_LBUTTON) <> 0) and (GetCapture = _handle) then
  begin
    GetWindowRect(_handle, boundRect_);
    MapWindowPoints(HWND_DESKTOP, GetParent(_handle), boundRect_, 2);
    OffsetRect(boundRect_, 0, p.y - _drag_point.y);
    if (_parent_rect.Bottom < boundRect_.Bottom) or
       ((_parent_rect.Bottom div 2) > boundRect_.Top) then
      exit;

    SetWindowPos(
      _handle, HWND_TOP,
      boundRect_.Left,
      boundRect_.Top,
      0, 0,
      SWP_NOSIZE);
    _v_margin := round((_parent_rect.Bottom - boundRect_.Bottom) * 100 / _parent_rect.Bottom);
  end;
end;

procedure TSubtitlesRenderer.mouse_up(p: TPoint);
begin
  if (_render_mode = rmFullRect) or (_style.position.vPosition = pvCenter) then
    exit;

  if GetCapture = _handle then
  begin
    _freeze_visible := false;
    ReleaseCapture;
    if Assigned(_end_update) then
      _end_update;
  end;
end;

procedure TSubtitlesRenderer.set_attributes(ss: TSubtitlesStyle;
  rm: TRenderMode; aa: TAntialiasing);
begin
  lock;
  _style := ss;
  _render_mode := rm;
  _anti_alias := aa;
  calc_fixed_size;
  unlock;
end;

procedure TSubtitlesRenderer.set_adjust_pos(value: boolean);
begin
  _adjust_position := value;
end;

procedure TSubtitlesRenderer.calc_fixed_size;
var
  old_font_: HFONT;
  fnt_: TFnt;
//  s: SIZE;
  r: TRECT;
begin
  fnt_ := TFnt.Create;
  try
    if fnt_.initialize(_style.fd) then
    begin
      if _work_dib.get_handle = 0 then
        _work_dib.initialize(1, 1);
      _old_font := SelectObject(_work_dib.get_dc, fnt_.get_handle);
      SetRect(r, 0, 0, 50, 0);
      DrawText(_work_dib.get_dc, 'Ój'#13'Ój', 5, r, DT_CALCRECT or DT_NOCLIP);
//      GetTextExtentPoint32(_work_dib.get_dc, 'Ój', 2, s);
//      _fixed_size := MulDiv(s.cy, 110, 100);
      _fixed_size := MulDiv(r.Bottom + 10, 1, 2);
      _fixed_scaled_size := round(_fixed_size * _font_scale);
      SelectObject(_work_dib.get_dc, _old_font);
    end;
  except
  end;
  fnt_.Free;
end;

procedure TSubtitlesRenderer.set_font_scale(value: double);
begin
  inherited set_font_scale(value);
  _fixed_scaled_size := round(_fixed_size * value);
end;

{ TOSDRenderer }

constructor TOSDRenderer.Create(parent: HWND);
begin
  inherited Create(parent);
  _font := TFnt.Create;
  _wait_time := 3000;
  _is_new_font := true;
  _def_draw_style :=
    DT_EXPANDTABS or DT_CENTER or DT_SINGLELINE or DT_NOPREFIX or DT_NOCLIP;
end;

destructor TOSDRenderer.Destroy;
begin
  inherited Destroy;
  _font.Free;
end;

procedure TOSDRenderer.free_work_data;
begin
end;

function TOSDRenderer.init_work_data(var new_rect: TRect): boolean;
var
  work_rect_: TRect;
begin
  if _is_new_font then
  begin
    _is_new_font := false;
    _curr_style := _style;
    _curr_style.fd.size := calc_font_size(_curr_style.fd.size);

    if _work_dib.get_dc = 0 then
      _work_dib.initialize(1, 1);

    SelectObject(_work_dib.get_dc, GetStockObject(DEFAULT_GUI_FONT));
    SelectObject(_render_dib.get_dc, GetStockObject(DEFAULT_GUI_FONT));
    _font.initialize(_curr_style.fd);
    SelectObject(_work_dib.get_dc, _font.get_handle);
    SelectObject(_render_dib.get_dc, _font.get_handle);
  end;

// TODO - get_parent_rect
  work_rect_ := get_fixed_parent_rect;
  OffsetRect(work_rect_, -work_rect_.Left, 0);
  draw_text(_work_dib.get_dc, _text, work_rect_, DT_CALCRECT);
  inc(work_rect_.Right, 2 * text_border);
  inc(work_rect_.Bottom, 2 * text_border);

  Result := _work_dib.initialize(work_rect_.Right, work_rect_.Bottom);
  if Result then
  begin
    SelectObject(_work_dib.get_dc, _font.get_handle);
    SelectObject(_render_dib.get_dc, _font.get_handle);
    new_rect := calc_position(work_rect_);

    if _work_dib.get_height > 0 then
      set_mem(
        _work_dib.get_bits,
        _work_dib.get_height * _work_dib.get_width,
        _curr_style.bkg_color);

    SetTextColor(_work_dib.get_dc, _curr_style.font_color);
    SetBkColor(_work_dib.get_dc, _curr_style.bkg_color);
    InflateRect(work_rect_, -1 * text_border, -text_border);
    draw_text(_work_dib.get_dc, _text, work_rect_, 0);
  end;
end;

procedure TOSDRenderer.mouse_down(p: TPoint);
begin
  if (_render_mode = rmFullRect) or (_style.position.hPosition = phCenter) then
    exit;
  _drag_point := p;
  _freeze_visible := true;
  SetCapture(_handle);
end;

procedure TOSDRenderer.mouse_move(p: TPoint; state: DWORD);
var
  boundRect_, pr_: TRect;
begin
  if (_render_mode = rmFullRect) or (_style.position.hPosition = phCenter) then
    exit;

// TODO - get_parent_rect
  if ((state and VK_LBUTTON) <> 0) and (GetCapture = _handle) then
  begin
    GetWindowRect(_handle, boundRect_);
    MapWindowPoints(HWND_DESKTOP, GetParent(_handle), boundRect_, 2);
    OffsetRect(boundRect_, p.x - _drag_point.x, p.y - _drag_point.y);
    if (boundRect_.Top < 0) or
       ((_parent_rect.Bottom div 2) < boundRect_.Bottom) or
       (boundRect_.Left < 0) or
       ((_parent_rect.Right div 2) < boundRect_.Right) then
      exit;

    SetWindowPos(
      _handle, HWND_TOP,
      boundRect_.Left,
      boundRect_.Top,
      0, 0,
      SWP_NOSIZE);
    _h_margin := (boundRect_.Left) * 100 div _parent_rect.Right;
    _v_margin := (boundRect_.Top) * 100 div _parent_rect.Bottom;
  end;
end;

procedure TOSDRenderer.mouse_up(p: TPoint);
begin
  if (_render_mode = rmFullRect) or (_style.position.hPosition = phCenter) then
    exit;

  if GetCapture = _handle then
  begin
    _freeze_visible := false;
    ReleaseCapture;
    if Assigned(_end_update) then
      _end_update;
  end;
end;

procedure TOSDRenderer.prepare_subtitle(pm: TPrepareMode; dc: HDC;
  text: string; var work_rect: TRect; var region: HRGN;
  draw_style: cardinal);
begin
  DrawText(dc, PChar(_text), -1, work_rect, _def_draw_style or draw_style);
  if pm <> pmDrawText then
  begin
    inc(work_rect.Right, 2 * text_border);
    inc(work_rect.Bottom, 2 * text_border);

    if pm = pmTextToRects then
      FillRect(dc, work_rect, GetStockObject(WHITE_BRUSH))
    else
      with work_rect do
        region := CreateRectRgn(Left, Top, Right, Bottom);
  end;
end;

procedure TOSDRenderer.render(subtitle: string);
begin
  Delete(subtitle, Pos('&', subtitle), 1);
  inherited render(subtitle);
end;

procedure TOSDRenderer.render_cliprects(var rgn: HRGN);
begin
  if _use_overlay and _is_overlay then
  begin
    if _work_dib.get_height > 0 then
      set_mem(_render_dib.get_bits, _render_dib.get_height * _render_dib.get_width, _curr_style.bkg_color);
    render_rects;
  end
  else
    rgn := render_region;
end;

procedure TOSDRenderer.set_attributes(ss: TSubtitlesStyle; rm: TRenderMode;
  aa: TAntialiasing);
begin
  lock;
  _is_new_font := _is_new_font or
    (StrComp(_style.fd.name, ss.fd.name) <> 0) or
    (_style.fd.size <> ss.fd.size) or
    (_style.fd.attr <> ss.fd.attr) or
    (_style.fd.charset <> ss.fd.charset);
  _style := ss;
  _render_mode := rm;
  if _render_mode = rmFullRect then
    _render_mode := rmClipRects;
  _anti_alias := aa;
  unlock;
end;

procedure TOSDRenderer.set_display_time(value: DWORD);
begin
  _wait_time := value;
end;

procedure TOSDRenderer.set_font_scale(value: double);
begin
  lock;
  _is_new_font := _is_new_font or (_font_scale <> value);
  _font_scale := value;
  unlock;
end;

end.


