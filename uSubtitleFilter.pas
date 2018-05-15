unit uSubtitleFilter;

interface

uses
  Windows, DirectShow9, BaseClass, ActiveX, uSubtitleMixer;

const
  CLSID_SubtitleFilter: TGUID = '{73c61876-48b2-44d4-912c-3ae2322d93ef}';
  IID_ISubtitleFilter: TGUID = '{9FB1ED1C-D34F-4196-9070-53F15A19A921}';
  ASPECTRATIO_4_3   = 0;
  ASPECTRATIO_16_9  = 1;

type
	ISubtitleFilter = interface(IUnknown)
    ['{9FB1ED1C-D34F-4196-9070-53F15A19A921}']
		function SetAspectRatio(iAspectRatio: integer): HRESULT; stdcall;
		function MixImage(uWidth, uHeight, uWidthInBytes: DWORD; pData: Pointer;
      x, y: integer): HRESULT; stdcall;
  end;

(*
// setup data - allows the self-registration to work.

const AMOVIESETUP_MEDIATYPE sudPinTypes =
{
	&MEDIATYPE_NULL        // clsMajorType
		, &MEDIASUBTYPE_NULL     // clsMinorType
};

const AMOVIESETUP_PIN psudPins[] =
{ { L"Input"            // strName
, FALSE               // bRendered
, FALSE               // bOutput
, FALSE               // bZero
, FALSE               // bMany
, &CLSID_NULL         // clsConnectsToFilter
, L""                 // strConnectsToPin
, 1                   // nTypes
, &sudPinTypes        // lpTypes
}
, { L"Output"           // strName
, FALSE               // bRendered
, TRUE                // bOutput
, FALSE               // bZero
, FALSE               // bMany
, &CLSID_NULL         // clsConnectsToFilter
, L""                 // strConnectsToPin
, 1                   // nTypes
, &sudPinTypes        // lpTypes
}
};

const AMOVIESETUP_FILTER sudNullNull =
{
	&CLSID_SubtitleFilter                 // clsID
		, L"Subtitle Filter"                 // strName
		, MERIT_DO_NOT_USE                // dwMerit
		, 2                               // nPins
		, psudPins                        // lpPin
};
*)

  TSubtitleFilter = class(TBCTransformFilter, ISubtitleFilter)
  private
    { private declarations }
    m_bReverseImage: boolean;
    m_pSubtitleMixer: TSubtitleMixer;

    function CheckInputType(mtIn: PAMMediaType): HRESULT; virtual;
    function DecideBufferSize(Allocator: IMemAllocator;
      prop: PAllocatorProperties): HRESULT; virtual;
    function GetMediaType(Position: integer;
      out MediaType: PAMMediaType): HRESULT; virtual;
    function CheckTransform(mtIn, mtOut: PAMMediaType): HRESULT; virtual;
    function Transform(msIn, msout: IMediaSample): HRESULT; virtual;

    //implement ISubtitleFilter
    function SetAspectRatio(iAspectRatio: integer): HRESULT; stdcall;
    function MixImage(uWidth, uHeight, uWidthInBytes: DWORD; pData: Pointer;
      x, y: integer): HRESULT; stdcall;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create();
    destructor Destroy(); override;
    class function CreateInstance(const Unk: IUnknown; out hr: HRESULT): TBCUnknown;
  end;

implementation

uses
  DSUtil, SysUtils;

{ TSubtitleFilter }

function TSubtitleFilter.CheckInputType(mtIn: PAMMediaType): HRESULT;
begin
 	if not (IsEqualGUID(mtIn.subtype, MEDIASUBTYPE_RGB32) or 
          IsEqualGUID(mtIn.subtype, MEDIASUBTYPE_YUY2)) then
  	Result := VFW_E_TYPE_NOT_ACCEPTED
  else if not IsEqualGUID(mtIn.majortype, MEDIATYPE_Video) then
		Result := VFW_E_TYPE_NOT_ACCEPTED
  else if (mtIn.cbFormat < sizeof(VIDEOINFOHEADER)) then
		Result := VFW_E_TYPE_NOT_ACCEPTED
  else
  	Result := S_OK;
end;

function TSubtitleFilter.CheckTransform(mtIn, mtOut: PAMMediaType): HRESULT;
begin

end;

constructor TSubtitleFilter.Create;
begin
  inherited Create('Subtitle Filter', nil,
    CLSID_SubtitleFilter);
	m_pSubtitleMixer := TSubtitleMixer.Create;
	m_bReverseImage := false;
end;

class function TSubtitleFilter.CreateInstance(const Unk: IInterface;
  out hr: HRESULT): TBCUnknown;
begin

end;

function TSubtitleFilter.DecideBufferSize(Allocator: IMemAllocator;
  prop: PAllocatorProperties): HRESULT;
begin

end;

destructor TSubtitleFilter.Destroy;
begin
  m_pSubtitleMixer.Free;
  inherited;
end;

function TSubtitleFilter.GetMediaType(Position: integer;
  out MediaType: PAMMediaType): HRESULT;
var
  vih: VIDEOINFOHEADER;
  pv: PVIDEOINFOHEADER;
begin
  ASSERT(FInput.IsConnected());
  if (Position < 0) then
    Result := E_INVALIDARG
  else if (Position = 0) then
  begin
    Result := FInput.ConnectionMediaType(MediaType^);
    if FAILED(Result) then
      exit;

    fillchar(vih, sizeof(vih), 0);
    vih.bmiHeader.biCompression := BI_RGB;
    vih.bmiHeader.biBitCount    := 32;
    vih.bmiHeader.biSize        := sizeof(BITMAPINFOHEADER);
    if not IsEqualGUID(MediaType.formattype, FORMAT_VideoInfo) then
      Result := E_FAIL
    else
    begin
      pv := PVIDEOINFOHEADER(MediaType.pbFormat);
      vih.AvgTimePerFrame := pv.AvgTimePerFrame;
      m_pSubtitleMixer.SetPictureSize(
        pv.bmiHeader.biWidth, 
        pv.bmiHeader.biHeight,
        pv.bmiHeader.biBitCount);

      vih.bmiHeader.biHeight := m_pSubtitleMixer.GetOutputHeight();
      vih.bmiHeader.biWidth := m_pSubtitleMixer.GetOutputWidth();

      vih.bmiHeader.biPlanes       := 1;
      vih.bmiHeader.biSizeImage    := m_pSubtitleMixer.GetOutputBufferSize();//GetBitmapSize(&vih.bmiHeader);
      vih.bmiHeader.biClrImportant := 0;

      MediaType.majortype := MEDIATYPE_Video;
      MediaType.formattype := FORMAT_VideoInfo;
      MediaType.pbFormat := @vih;
      MediaType.cbFormat := sizeof(vih);
      MediaType.subtype := MEDIASUBTYPE_RGB32;
      MediaType.lSampleSize := vih.bmiHeader.biSizeImage;
      Result := S_OK;
    end;
  end
  else
    Result := VFW_S_NO_MORE_ITEMS;
end;

function TSubtitleFilter.MixImage(uWidth, uHeight, uWidthInBytes: DWORD;
  pData: Pointer; x, y: integer): HRESULT;
var
  mi: TMixImageInfo;
begin
  mi.uHeight := uHeight;
  mi.uWidth := uWidth;
  mi.uWidthInBytes := uWidthInBytes;
  FLock.Lock();
  m_pSubtitleMixer.MixImage(@mi, pData, x, y);
  FLock.UnLock();
  Result := S_OK;
end;

function TSubtitleFilter.SetAspectRatio(iAspectRatio: integer): HRESULT;
begin
  if iAspectRatio = ASPECTRATIO_4_3 then
    m_pSubtitleMixer.SetAspectRatio(a4_3)
  else
    m_pSubtitleMixer.SetAspectRatio(a16_9);

  Result := S_OK;
end;

function TSubtitleFilter.Transform(msIn, msout: IMediaSample): HRESULT;
var
  pMt: PAMMediaType;
  pv: PVIDEOINFOHEADER;
  pBufferIn, pBufferOut: PByte;
begin
  // Get pointers to the underlying buffers.
  Result := msout.GetMediaType(pMt);

  if Assigned(pMt) then
  begin
    if (FAILED(Result)) then
      exit;

    pv := PVIDEOINFOHEADER(pMt.pbFormat);
    if (pv.bmiHeader.biHeight < 0) then
      m_bReverseImage := TRUE;
    DeleteMediaType(pMt);
  end;  

  Result := msIn.GetPointer(pBufferIn);
  if (FAILED(Result)) then
    exit;

  Result := msout.GetPointer(pBufferOut);
  if (FAILED(Result)) then
    exit;

  try
{$ifndef DEBUG}
    FLock.Lock();
{$endif}
    m_pSubtitleMixer.Render(PByteArray(pBufferOut), PByteArray(pBufferIn), m_bReverseImage);
  finally
{$ifndef DEBUG}
    FLock.UnLock();
{$endif}
  end;

  msout.SetActualDataLength(m_pSubtitleMixer.GetOutputBufferSize());
  msout.SetSyncPoint(TRUE);
  Result := S_OK;
end;

end.
