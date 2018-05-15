unit uSubtitleMixer;

interface

uses
  Windows, Classes, SysUtils;

type
  PMixImageInfo = ^TMixImageInfo;
  TMixImageInfo = record
    uWidth: DWORD;
    uHeight: DWORD;
    uWidthInBytes: DWORD;
  end;

  eAspectRatio = (a4_3 = 0, a16_9);

  TSubtitleMixer = class(TObject)
  private
    m_eAspectRatio: eAspectRatio;
    m_uInputWidth: DWORD;
    m_iInputHeight: integer;
    m_uInputWidthInBytes: DWORD;
    m_iOutputHeight: integer;
    m_uBPP: DWORD;
    m_uMiddleOffset: DWORD;
    m_iOutputBufferSize: integer;
    m_iInputBufferSize: integer;
    m_uFirstLine: DWORD;
    m_uLastLine: DWORD;

    m_pMixImageInfo: PMixImageInfo;
    m_pMixImageData: PByteArray;

    m_pMixBitmapData: PByteArray;
    m_pMixBitmapInfo: PMixImageInfo;
    m_bMixImageVisible: boolean;
    m_X: integer;
    m_Y: integer;

    procedure RenderImageARGB(pDest: PByteArray; pSource: PByteArray;
      bReverseImage: boolean);
  public
    constructor Create();
    destructor Destroy(); override;

    procedure SetAspectRatio(eRatio: eAspectRatio);
    function GetAspectRatio(): eAspectRatio;
    procedure SetPictureSize(uWidth: DWORD; iHeight: integer; uBPP: DWORD);
    function DecideBufferSize(): integer;
    function GetOutputHeight(): integer;

    function GetOutputWidth(): DWORD;
    procedure Render(pDest: PByteArray; pSource: PByteArray;
      bReverseImage: boolean = false);
    function GetOutputBufferSize(): integer;
    function LoadBitmap(const pszFilename: PChar): boolean;
    procedure ReleaseBitmap();
    procedure SetBitmapVisible(bVisible: boolean; x, y: integer);
    procedure MixImage(pMixImageInfo: PMixImageInfo; pData: Pointer; x,
      y: integer);
    procedure RGB24ToARGB(pDest: PByteArray; pSource: PByteArray; iLen: integer;
      uAlpha: byte);
  end;

implementation

{ TSubtitleMixer }

constructor TSubtitleMixer.Create;
begin
  m_eAspectRatio := a4_3;
  m_uInputWidth := 0;
  m_iInputHeight := 0;
  m_iOutputBufferSize := -1;
  m_bMixImageVisible := false;
  m_pMixBitmapData := nil;
  m_pMixBitmapInfo := nil;
end;

function TSubtitleMixer.DecideBufferSize: integer;
begin
  if (m_iInputHeight = 0) or (m_uInputWidth = 0) then
    Result := -1
  else
    Result := m_iOutputHeight * m_uInputWidthInBytes;
end;

destructor TSubtitleMixer.Destroy;
begin
  ReleaseBitmap();
  inherited;
end;

function TSubtitleMixer.GetAspectRatio(): eAspectRatio;
begin
  Result := m_eAspectRatio;
end;

function TSubtitleMixer.GetOutputBufferSize: integer;
begin
  Result := m_iOutputBufferSize;
end;

function TSubtitleMixer.GetOutputHeight: integer;
begin
  Result := m_iOutputHeight;
end;

function TSubtitleMixer.GetOutputWidth: DWORD;
begin
  Result := m_uInputWidth;
end;

function TSubtitleMixer.LoadBitmap(const pszFilename: PChar): boolean;
var
  bfh: BITMAPFILEHEADER;
  bih: BITMAPINFOHEADER;
  pFile: TFileStream;
  iLen: integer;
  iBitmapSize: integer;
  iMixBitmapSize: integer;
  pBitmapData: PByteArray;
begin
  Result := false;
  pFile := TFileStream.Create(pszFileName, fmInput);
  try
    iLen := pFile.Read(bfh, sizeof(BITMAPFILEHEADER));
    if iLen = sizeof(BITMAPFILEHEADER) then
    begin
      iLen := pFile.Read(bih, sizeof(BITMAPINFOHEADER));
      if iLen = sizeof(BITMAPINFOHEADER) then
      begin
        if (bih.biBitCount = 24) then
        begin
          iBitmapSize := bih.biWidth * bih.biBitCount * bih.biHeight div 8;
          iMixBitmapSize := bih.biWidth * 4 * bih.biHeight;

          GetMem(m_pMixBitmapData, iMixBitmapSize);
          GetMem(pBitmapData, iBitmapSize);

          pFile.Seek(bfh.bfOffBits, soFromBeginning);
          iLen := pFile.Read(pBitmapData^, iBitmapSize);

          if iLen = iBitmapSize then
          begin
            RGB24ToARGB(m_pMixBitmapData, pBitmapData, iBitmapSize, 128);
            FreeMem(pBitmapData);
            new(m_pMixBitmapInfo);
            m_pMixBitmapInfo.uHeight := bih.biHeight;
            m_pMixBitmapInfo.uWidth := bih.biWidth;
            m_pMixBitmapInfo.uWidthInBytes := bih.biWidth * 4;

            Result := true;
          end
          else
            FreeMem(pBitmapData);
        end;
      end;
    end;
  finally
    pFile.Free;
  end;
end;

procedure TSubtitleMixer.MixImage(pMixImageInfo: PMixImageInfo; pData: Pointer;
  x, y: integer);
begin
  if (pMixImageInfo <> nil) and (pData <> nil) then
  begin
    m_pMixImageData := PByteArray(pData);
    m_pMixImageInfo := pMixImageInfo;
    m_bMixImageVisible := true;
    if (x = 0) and (y = 0) then
      x := 1;
    m_X := x;
    m_Y := y;
  end
  else
    m_bMixImageVisible := false;
end;

procedure TSubtitleMixer.ReleaseBitmap;
begin
  if m_pMixBitmapInfo <> nil then
  begin
    Dispose(m_pMixBitmapInfo);
    m_pMixBitmapInfo := nil;
  end;

  if m_pMixBitmapData <> nil then
  begin
    FreeMem(m_pMixBitmapData);
    m_pMixBitmapData := nil;
  end;
end;

procedure TSubtitleMixer.Render(pDest, pSource: PByteArray; bReverseImage: boolean);
var
  y: integer;
  minY, maxY: integer;
  iLen: integer;
  uWidthInBytes: DWORD;
  uOff: DWORD;
  i: integer;
begin
  y := m_uFirstLine;


  if m_bMixImageVisible then
  begin
    if m_Y < m_uFirstLine then
    begin
      minY := m_uFirstLine;
      maxY := m_pMixImageInfo.uHeight - 1 - (m_uFirstLine - m_Y);
    end
    else
    begin
      minY := m_Y;
      maxY := minY + m_pMixImageInfo.uHeight - 1;
    end;

    if (m_X + m_pMixImageInfo.uWidth) < m_uInputWidth then
      uWidthInBytes := m_pMixImageInfo.uWidthInBytes
    else
      uWidthInBytes := (m_uInputWidth - m_X) * 4;
  end
  else
  begin
    minY := -1;
    maxY := -1;
  end;


  if bReverseImage then
  begin
    uOff := m_uMiddleOffset;
    for i := m_iInputHeight - 1 to 0 do
    begin
      if (y < minY) or (y > maxY) then
        CopyMemory(
          @pDest[uOff], 
          @pSource[i * m_uInputWidthInBytes],
          m_uInputWidthInBytes)
      else
      begin
        iLen := m_X * 4;
        CopyMemory(
          @pDest[uOff], 
          @pSource[i * m_uInputWidthInBytes],
          iLen);
        CopyMemory(
          @pDest[uOff + iLen + uWidthInBytes],
          @pSource[i * m_uInputWidthInBytes + iLen + uWidthInBytes],
          m_uInputWidthInBytes - uWidthInBytes - iLen);
      end;

      inc(uOff, m_uInputWidthInBytes);
      inc(y);
    end;
  end
  else
  begin
    // TODO:
    ASSERT(false, 'not reverse imege???');
    CopyMemory(
      @pDest[m_uMiddleOffset],
      @pSource,
      m_iInputBufferSize);
  end;
  if m_bMixImageVisible then
    RenderImageARGB(pDest, pSource, bReverseImage);
end;

procedure TSubtitleMixer.RenderImageARGB(pDest, pSource: PByteArray;
  bReverseImage: boolean);
var
  iDestY,
  iDestOffset,
  iSourceImageOffset,
  iSourceOffset: DWORD;
  pMixImageData: PByteArray;
  uWidthInBytes: DWORD;
  t, i, j: integer;
  bOnScreen: LongBool;
begin
  iDestY :=	m_Y;
  iDestOffset := m_Y * m_uInputWidthInBytes + m_X * 4 - 1;
  iSourceImageOffset :=
    m_pMixImageInfo.uWidthInBytes * (m_pMixImageInfo.uHeight - 1);
  iSourceOffset := 0;

  pMixImageData := m_pMixImageData;
  if (m_X + m_pMixImageInfo.uWidth) <= m_uInputWidth then
    uWidthInBytes := m_pMixImageInfo.uWidthInBytes
  else
    uWidthInBytes := (m_uInputWidth - m_X) * 4;

  bOnScreen := false;
  for i := 0 to m_pMixImageInfo.uHeight - 1 do
  begin
    if (iDestY >= m_uFirstLine) and (iDestY <= m_uLastLine) then
    begin
      if bReverseImage then
        iSourceOffset := (m_iInputHeight - (iDestY - m_uFirstLine) - 1) *
          m_uInputWidthInBytes + m_X * 4 - 1
      else
        iSourceOffset := (iDestY - m_uFirstLine) * m_uInputWidthInBytes +
          m_X * 4 - 1;
      bOnScreen := true;
    end
    else
      bOnScreen := false;

    j := 0;
    while j < uWidthInBytes do
    begin
      case m_pMixImageData[iSourceImageOffset + j] of
        0:
          continue;
        128:
        asm
          // if (bOnScreen)
          mov ebx, bOnScreen
          or ebx,ebx
          jnz @l1
          mov ecx,0
          jmp @l2
@l1:
          mov ebx, pSource
          add ebx, iSourceOffset
          add ebx, j
          mov ecx, [ebx]
@l2:
          movd mm0, ecx

          mov ecx, pMixImageData
          add ecx, iSourceImageOffset
          add ecx, j
          mov ebx, [ecx]

          mov eax, $7f7f7f7f
          movd mm2, eax
          movd mm1, [ecx]

          psrlw mm0, 1
          pand mm0, mm2
          psrlw mm1, 1
          pand mm1, mm2
          paddb mm0, mm1

          mov ecx, pDest
          add ecx, iDestOffset
          add ecx, j
          movd [ecx], mm0
          emms
        end;
      else
        PDWORD(@pDest[iDestOffset + j])^ := 
          PDWORD(@m_pMixImageData[iSourceImageOffset + j])^;
      end;
      inc(j, 4);
    end;
    dec(iSourceImageOffset, m_pMixImageInfo.uWidthInBytes);
    inc(iDestOffset, m_uInputWidthInBytes);
    inc(iDestY);
    if iDestY >= m_iOutputHeight then
      break;
  end;
end;

procedure TSubtitleMixer.RGB24ToARGB(pDest, pSource: PByteArray; iLen: integer;
  uAlpha: byte);
var
  i, j: integer;
begin
  j := 0;
  i := 0;
  while i < iLen do
  begin
    CopyMemory(
      @pDest[j + 1], 
      @pSource[i], 
      3);
    if pSource[i] = 0 then
    begin
      pDest[j] := uAlpha;
    end
    else
      pDest[j] := 255;
    inc(j, 4);
    inc(i, 3);
  end;
end;

procedure TSubtitleMixer.SetAspectRatio(eRatio: eAspectRatio);
begin
  m_eAspectRatio := eRatio;
end;

procedure TSubtitleMixer.SetBitmapVisible(bVisible: boolean; x, y: integer);
begin
	if bVisible then
	begin
		m_pMixImageData := m_pMixBitmapData;
		m_pMixImageInfo := m_pMixBitmapInfo;
		if (x = 0) and (y = 0) then
			x := 1;
		m_X := x;
		m_Y := y;
  end;
	m_bMixImageVisible := bVisible;
end;

procedure TSubtitleMixer.SetPictureSize(uWidth: DWORD; iHeight: integer;
  uBPP: DWORD);
var
  aw, ah: double;
  w: double;
  h: double;
  origh: double;
begin
  m_uInputWidth := uWidth; 
  m_iInputHeight := abs(iHeight);
  m_uBPP := uBPP;
  m_uInputWidthInBytes := uBPP * m_uInputWidth div 8;
  w := m_uInputWidth;
  origh := m_iInputHeight;
  if m_eAspectRatio = a16_9 then
  begin
    aw := 16;
    ah := 9;
  end
  else
  begin
    aw := 4;
    ah := 3;
  end;

  h := w * ah / aw;

  if h < (origh + 5) then
   h := origh;

  m_iOutputHeight := round(h);

  m_uFirstLine := (m_iOutputHeight - m_iInputHeight) div 2 ;
  m_uMiddleOffset := (m_iOutputHeight - m_iInputHeight) div 2 * m_uInputWidthInBytes;
  m_uLastLine := m_uFirstLine + m_iInputHeight - 1;
  m_iOutputBufferSize := m_iOutputHeight * m_uInputWidthInBytes;
  m_iInputBufferSize := m_iInputHeight * m_uInputWidthInBytes;
end;

end.
