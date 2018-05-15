unit cp_ListBoxes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, StdCtrls, ExtCtrls,
  Forms, HTMLParser, comctrls, cp_Dialogs, cp_CinemaEngine, cp_CustomListBox;

type
  PItemData  = ^TItemData;
  TItemData = record
    Path: string;
    Title: string;
    Length: integer;
    Played: integer;
  end;

  TDeleteItemType = (ditSel, ditCrop, ditDeath, ditAll);
  TSelectItemType = (sitInvert, sitNone, sitAll);
  TFileRefType = (frtPLS, frtM3U, frtASX, frtVPL, frtBPP, frtLST, frtMBL, frtOther);
  TOpenItemType = (oitFile, oitPlaylist, oitBoth);

  TChargeEvent = procedure(Sender: TObject; Name: string; BeginPlay: boolean; Position : double) of object;

  TPlaylistBox = class(TVirtualListBox)
  private
    FOnDeleteItem: TNotifyEvent;
    FOnAddItem: TNotifyEvent;
    FOnChargeItem: TChargeEvent;
    FOnEnd: TNotifyEvent;
    FOnBegin: TNotifyEvent;
    FBadPlayList,
    FErrorCaption,
    FSelFold,
    FPressCTRL: string;
    FPlayedItem: integer;
    PlayedItemExist: boolean;
    FShuffle: boolean;
    FRepeatList: boolean;
    FAutoPlay: boolean;
    FShuffleIndex: integer;
    FCinema: TCinema;
    FCS: TRTLCriticalSection;
    procedure ClearPlayedFlags;
    procedure MyDrawItemEvent(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure SetShuffle(const Value: boolean);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Lock;
    procedure Unlock;
  public
    MovieFilter: string;
    MovieFolder: string;
    SubtitleFilter: string;
    PlayListFilter: string;
    AllFilter: string;
    MovieExt: string;
    PlayListExt: string;
    SubtitleExt: string;
    Add: boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddPlayItem(FileRef: string);
    procedure Clear; //reintroduce;
    procedure ChargeItem(ItemIndex: integer; BeginPlay: boolean; Position : double = 0.0);
    procedure OpenItem(Add: boolean; item_type: TOpenItemType);
    procedure OpenDir(Add: boolean; item_type: TOpenItemType);
    procedure ScanDir(Dir, Exts: string; ScanSubDir: boolean);
    procedure SaveList(FileName: string);
    procedure DeleteItems(DeleteItemType: TDeleteItemType);
    procedure PlayPrevItem;
    procedure PlayNextItem;
    procedure SelectItems(SelectItemType: TSelectItemType);
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ExtendedSelect;
    property Font;
    property ImeMode;
    property ImeName;
    property IntegralHeight;
    property ItemHeight;
    property Items;
    property MultiSelect;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property Style;
    property TabOrder;
    property TabStop;
    property TabWidth;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;

    property AutoPlay: boolean read FAutoPlay write FAutoPlay;
    property BadPlaylist: string read FBadPlayList write FBadPlayList;
    property ErrorCaption: string read FErrorCaption write FErrorCaption;
    property Cinema: TCinema read FCinema write FCinema;
    property OnBegin: TNotifyEvent read FOnBegin write FOnBegin;
    property OnEnd: TNotifyEvent read FOnEnd write FOnEnd;
    property OnAddItem: TNotifyEvent read FOnAddItem write FOnAddItem;
    property OnDeleteItem: TNotifyEvent read FOnDeleteItem write FOnDeleteItem;
    property OnChargeItem: TChargeEvent read FOnChargeItem write FOnChargeItem;
//    property OpenDialog: TOpenDialog read FOpenDialog write SetOpenDialog;
    property PressCTRL: string read FPressCTRL write FPressCTRL;
    property PlayedItem: integer read FPlayedItem write FPlayedItem;
    property Shuffle: boolean read FShuffle write SetShuffle;
    property RepeatList: boolean read FRepeatList write FRepeatList;
    property SelFold: string read FSelFold write FSelFold;
  end;

const
  MinInt: cardinal            = $80000000;

implementation

uses
  subtitles_header, global_consts;

{ TPlaylistBox }

procedure TPlaylistBox.MyDrawItemEvent(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  LengthTime: string;
begin
  with (Control as TPlaylistBox) do
  try
    Canvas.Brush.Style := bsSolid;

    if odSelected in (State) then
//      Canvas.Brush.Color := $002CE2FC
      Canvas.Brush.Color := clGray
    else
      Canvas.Brush.Color := clBlack;
    Canvas.FillRect(Rect);

    if (Index = PlayedItem) and PlayedItemExist then
      Canvas.Font.Color := clLime
    else
      Canvas.Font.Color := clGreen;


    if PItemData((Control as TPlaylistBox).Items.Objects[Index]).Length <> 0 then
    begin
      LengthTime := PrepareTime(PItemData((Control as TPlaylistBox).Items.Objects[Index]).Length);
      DrawText(Canvas.Handle, PChar(LengthTime), -1, Rect,
        DT_EXPANDTABS or DT_SINGLELINE or DT_RIGHT or DT_NOPREFIX or DT_VCENTER);// or DT_END_ELLIPSIS);

      Rect.Right := Rect.Right - Canvas.TextWidth(LengthTime);
    end;

    DrawText(Canvas.Handle, PChar((Control as TPlaylistBox).Items[Index]), -1, Rect,
      DT_EXPANDTABS or DT_SINGLELINE or DT_LEFT or DT_NOPREFIX or DT_VCENTER or DT_END_ELLIPSIS);

  finally
  end;
end;

procedure TPlaylistBox.AddPlayItem(FileRef: string);

  function DetectFileRefType(FileRef: string): TFileRefType;
  type
    TTypRozszerzenia = record
      Roz: string;
      Typ: TFileRefType;
    end;

  const
    Rozszerzenia: array[0..6] of TTypRozszerzenia =
    ((Roz: 'ASX'; Typ: frtASX),
     (Roz: 'BPP'; Typ: frtBPP),
     (Roz: 'LST'; Typ: frtLST),
     (Roz: 'M3U'; Typ: frtM3U),
     (Roz: 'MBL'; Typ: frtMBL),
     (Roz: 'PLS'; Typ: frtPLS),
     (Roz: 'VPL'; Typ: frtVPL));

  var
    Ext: string;
    i: integer;
  begin
    Ext := ExtractFileExt(FileRef);
    Ext := Copy(Ext, Pos('.', Ext) + 1, MaxInt);
    Result := frtOther;
    for i := 0 to 6 do
    begin
      if AnsiCompareText(Rozszerzenia[i].Roz, Ext) = 0 then
      begin
        Result := Rozszerzenia[i].Typ;
        break;
      end;
    end;
  end;

  procedure AddOneList(FileRef: string; FileRefType: TFileRefType);
  type
    TASXParsePhase = (appBegin, appTitle, appBeginEntry, appEndEntry);
  const
    PLSSection = 'playlist';
  var
    SL: TStringList;
    i, PLSCounter: integer;

    M3UTempLine, M3UTitle: string;
    M3ULength: integer;

    VPLTempLine, VPLParentPath: string;
    VPLIndex: integer;

    PLSTempLine, PLSTitle: string;
    PLSLength: integer;

    ASX: THtmlParser;
    ASXTempLine, ASXDefTitle, ASXTitle: string;
    ASXLength: integer;

    MBLTempLine, MBLTitle: string;

    procedure AddOneItem(Path, Title: string; Length: integer);
    var
      ItemData: PItemData;
      Tytul: string;
    begin
      new(ItemData);
      ItemData.Path := Path;
      ItemData.Title := Title;
      ItemData.Length := Length;
      ItemData.Played := MinInt;
      if ItemData.Title = '' then
        Tytul := ExtractFileName(ItemData.Path)
      else
        Tytul := ItemData.Title;
      AddItem(Tytul, TObject(ItemData));
      if Assigned(FOnAddItem) then
        OnAddItem(Self);
    end;

  begin
    case FileRefType of
      frtOther:
        if Trim(FileRef) <> '' then
          AddOneItem(FileRef, '', 0);
      frtPLS:
      begin
        SL := TStringList.Create;
        try
          try
            SL.LoadFromFile(FileRef);
            if SL.IndexOfName('NumberOfEntries') <> -1 then
            begin
              PLSCounter := StrToInt(SL.Values['NumberOfEntries']);

              for i := 1 to PLSCounter do
              begin
                if SL.IndexOfName('File' + IntToStr(i)) <> -1 then
                begin
                  PLSTempLine := SL.Values['File' + IntToStr(i)];
                  SL.Delete(SL.IndexOfName('File' + IntToStr(i)));

                  if SL.IndexOfName('Title' + IntToStr(i)) <> -1 then
                  begin
                    PLSTitle := SL.Values['Title' + IntToStr(i)];
                    SL.Delete(SL.IndexOfName('Title' + IntToStr(i)));
                  end
                  else
                    PLSTitle := '';

                  if SL.IndexOfName('Length' + IntToStr(i)) <> -1 then
                  begin
                    PLSLength := StrToInt(SL.Values['Length' + IntToStr(i)]);
                    SL.Delete(SL.IndexOfName('Length' + IntToStr(i)));
                  end
                  else
                    PLSLength := 0;

                  if not FileExists(PLSTempLine) and FileExists(ExtractFilePath(FileRef) + PLSTempLine) then
                    PLSTempLine := ExtractFilePath(FileRef) + PLSTempLine;
                  AddOneItem(PLSTempLine, PLSTitle, PLSLength);
                end;
              end;
            end;
          except
            on Exception do
              MessageBox(0, PChar(FBadPlayList), PChar(FErrorCaption), MB_OK or MB_TASKMODAL or MB_ICONERROR);
          end;
        finally
          SL.Free;
        end;
      end;
      frtM3U:
      begin
        SL := TStringList.Create;
        try
          try
            SL.LoadFromFile(FileRef);
            i := SL.IndexOf('#EXTM3U');
            if i = -1 then
              i := 0
            else
              inc(i);

            M3UTitle := '';
            M3ULength := 0;
            while i < SL.Count do
            begin
              if (Trim(SL[i]) <> '') then
              begin
                M3UTempLine := Trim(SL[i]);
                if Pos('#EXTINF:', AnsiUpperCase(M3UTempLine)) = 1 then
                begin
                  M3UTempLine := Copy(M3UTempLine, 9, MaxInt);
                  M3ULength := StrToInt(Copy(M3UTempLine, 1, Pos(',', M3UTempLine) - 1));
                  M3UTitle := Copy(M3UTempLine, Pos(',', M3UTempLine) + 1, MaxInt);
                end
                else
                begin
                  if not FileExists(M3UTempLine) and FileExists(ExtractFilePath(FileRef) + M3UTempLine) then
                    M3UTempLine := ExtractFilePath(FileRef) + M3UTempLine;
                  AddOneItem(M3UTempLine, M3UTitle, M3ULength);
                  M3UTitle := '';
                  M3ULength := 0;
                end;
              end;
              inc(i);
            end;
          except
            on Exception do
              MessageBox(0, PChar(FBadPlayList), PChar(FErrorCaption), MB_OK or MB_TASKMODAL or MB_ICONERROR);
          end;
        finally
          SL.Free;
        end;
      end;
      frtASX:
      begin
        ASX:= THtmlParser.Create;
        try
          ASX.LoadFromFile(FileRef);
          ASXDefTitle := '';
          while ASX.NextTag do
            if ASX.Tag.Name = 'ASX' then
              while ASX.NextTag do
              begin
                if ASX.Tag.Name = 'TITLE' then
                begin
                  ASXDefTitle := ASX.TextBetween;
                end;
                if ASX.Tag.Name = 'ENTRY' then
                begin
                  ASXTempLine := '';
//                  ASXTitle := ASXDefTitle;
                  ASXTitle := '';
                  ASXLength := 0;
                  while ASX.NextTag do
                  begin
                    if ASX.Tag.Name = '/TITLE' then
                    begin
                      ASXTitle := ASX.TextBetween;
                    end;
                    if ASX.Tag.Name = 'REF' then
                    begin
                      if ASX.Tag.Params.IndexOfName('href') <> -1 then
                      begin
                        ASXTempLine := ASX.Tag.Params.Values['href'];
                        if ASXTempLine <> '' then
                          while ASXTempLine[1] in ['''', '"'] do
                            Delete(ASXTempLine, 1, 1);
                        if ASXTempLine <> '' then
                          while ASXTempLine[Length(ASXTempLine)] in ['''', '"'] do
                            Delete(ASXTempLine, Length(ASXTempLine), 1);
                      end;
                    end;
                    if ASX.Tag.Name = 'LENGTH' then
                    begin
                      if ASX.Tag.Params.IndexOfName('value') <> -1 then
                      begin
                        ASXLength := StrToInt(ASX.Tag.Params.Values['value']);
                      end;
                    end;
                    if ASX.Tag.Name = '/ENTRY' then
                    begin
                      if not FileExists(ASXTempLine) and FileExists(ExtractFilePath(FileRef) + ASXTempLine) then
                        ASXTempLine := ExtractFilePath(FileRef) + ASXTempLine;
                      AddOneItem(ASXTempLine, ASXTitle, ASXLength);
                      break;
                    end;
                  end;
                end;
              end;
        finally
          ASX.Free;
        end;
      end;
      frtVPL:
      begin
        SL := TStringList.Create;
        try
          SL.LoadFromFile(FileRef);
          for i := 0 to SL.Count - 1 do
            if (Trim(SL[i]) <> '') then
            begin
              VPLTempLine := Trim(SL[i]);
              VPLParentPath := '';
              while Pos('..\', VPLTempLine) <> 0 do
              begin
                if VPLParentPath = '' then
                begin
                  VPLParentPath := ExtractFileDrive(SL[i]);
                  if VPLParentPath = '' then
                    VPLParentPath := ExtractFilePath(FileRef);
                end;
                VPLTempLine := Copy(VPLTempLine, Pos('..\', VPLTempLine) + 3, MaxInt);
                for VPLIndex := Length(VPLParentPath) - 1 downto 1 do
                  if VPLParentPath[VPLIndex] = '\' then
                  begin
                    SetLength(VPLParentPath, VPLIndex);
                    break;
                  end
              end;
              if VPLParentPath <> '' then
                VPLTempLine := VPLParentPath + VPLTempLine;
              if ExtractFilePath(VPLTempLine) = '' then
                VPLTempLine := ExtractFilePath(FileRef) + VPLTempLine;
              AddOneItem(VPLTempLine, '', 0);
            end;
        finally
          SL.Free;
        end;
      end;
      frtBPP, frtLST:
      begin
        SL := TStringList.Create;
        try
          SL.LoadFromFile(FileRef);
          for i := 0 to SL.Count - 1 do
            if (Trim(SL[i]) <> '') then
            begin
              if not FileExists(SL[i]) and FileExists(ExtractFilePath(FileRef) + SL[i]) then
                AddOneItem(ExtractFilePath(FileRef) + SL[i], '', 0)
              else
                AddOneItem(SL[i], '', 0)
            end;
        finally
          SL.Free;
        end;
      end;
      frtMBL:
      begin
        SL := TStringList.Create;
        try
          SL.LoadFromFile(FileRef);
          for i := SL.Count - 1 downto 0 do
            if (Trim(SL[i]) = '') then
              SL.Delete(i);

          MBLTempLine := ''; MBLTitle := '';
          for i := 0 to SL.Count - 1 do
          begin
            case (i mod 3) of
              0:
                MBLTitle := SL[i];
              2:
                MBLTempLine := SL[i];
            end;
            if (MBLTempLine <> '') and (MBLTitle <> '') then
            begin
              AddOneItem(MBLTempLine, MBLTitle, 0);
              MBLTempLine := ''; MBLTitle := '';
            end;
          end;
        finally
          SL.Free;
        end;
      end;
    end;
  end;

begin
  Lock;
  Items.BeginUpdate;
  AddOneList(FileRef, DetectFileRefType(FileRef));
  Items.EndUpdate;
  Unlock;
end;

procedure TPlaylistBox.ChargeItem(ItemIndex: integer; BeginPlay: boolean; Position : double);
var
  ItemsInView: integer;
begin
  PlayedItem := ItemIndex;
  PlayedItemExist := true;
  Repaint;

{  CinemaPlayerMain.OpenNewMovie(PItemData(lbPlaylist.Items.Objects[PlayedItem]).Path, 0.0);
  if BeginPlay and (not Option.Autoplay) then
    MyCinema.Play;}
  if ItemIndex >= Items.Count then
    exit;
  Lock;
  if FShuffle then
  begin
    if (PItemData(Items.Objects[PlayedItem]).Played = MinInt) then
    begin
      if FShuffleIndex = MinInt then
        FShuffleIndex := 0
      else
        inc(FShuffleIndex);
      PItemData(Items.Objects[PlayedItem]).Played := FShuffleIndex;
    end;
    FShuffleIndex := PItemData(Items.Objects[PlayedItem]).Played;
  end;
  ItemsInView := ClientHeight div ItemHeight;
  if not (PlayedItem in [TopIndex .. TopIndex + ItemsInView]) then
  begin
    TopIndex := PlayedItem - ItemsInView div 2;
  end;
  if Assigned(FOnChargeItem) then
    OnChargeItem(Self, PItemData(Items.Objects[PlayedItem]).Path, BeginPlay, Position);
  Unlock;
end;

procedure TPlaylistBox.ClearPlayedFlags;
var
  i: integer;
begin
  for i := 0 to Items.Count - 1 do
    PItemData(Items.Objects[i]).Played := MinInt;
end;

constructor TPlaylistBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  OnDrawItem := MyDrawItemEvent;
  DoubleBuffered := true;
  InitializeCriticalSection(FCS);
end;

procedure TPlaylistBox.DeleteItems(DeleteItemType: TDeleteItemType);
var
  i: integer;
  Accept: boolean;
begin
  Lock;
  Items.BeginUpdate;
  for i := Items.Count - 1 downto 0 do
  begin
    Accept :=
      ((DeleteItemType = ditSel) and Selected[i]) or
      ((DeleteItemType = ditCrop) and not Selected[i]) or
      ((DeleteItemType = ditDeath) and not FileExists(PItemData(Items.Objects[i]).Path)) or
      (DeleteItemType = ditAll);
    if Accept then
    begin
      if PlayedItem = i then
      begin
        PlayedItemExist := false;
      end;
      PItemData(Items.Objects[i]).Path := '';
      PItemData(Items.Objects[i]).Title := '';
      Dispose(PItemData(Items.Objects[i]));
      Items.Delete(i);
      if Assigned(FOnDeleteItem) then
        OnDeleteItem(Self);
    end;
  end;
  Items.EndUpdate;
  Unlock;
end;

procedure TPlaylistBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
//  if (Operation = opRemove) and (AComponent = FOpenDialog) then
//    FOpenDialog := nil;
  if (Operation = opRemove) and (AComponent = FCinema) then
    FCinema := nil;
end;

procedure TPlaylistBox.ScanDir(Dir, Exts: string; ScanSubDir: boolean);
var
  SR: TSearchRec;
  s, m: string;
begin
  if FindFirst(Dir + '*.*', faAnyFile, SR) = 0 then
  begin
    m := LowerCase(Exts);
    repeat
      if (SR.Name <> '.') and (SR.Name <> '..') then
      begin
        if (SR.Attr and faDirectory) <> 0 then
        begin
          if ScanSubDir then
            ScanDir(Dir + SR.FindData.cFileName + '\', Exts, ScanSubDir);
        end
        else
        begin
          s := ExtractFileExt(SR.FindData.cFileName);
          if (s <> '') and (s[1] = '.') then
            Delete(s, 1, 1);
          if (s <> '') then
          begin
            s := LowerCase(s);
            if (Pos(s + #13, m) = 1) or
               (Pos(#13 + s + #13, m) > 0) or
               (Pos(#13 + s, m) = (Length(m) - Length(s))) or
               (m = s) then
//          if IsExpectedFile(SR.FindData.cFileName, MovieExt) then
              AddPlayItem(Dir + SR.FindData.cFileName);
          end;
        end;
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

procedure TPlaylistBox.OpenDir(Add: boolean; item_type: TOpenItemType);
var
  InitialDir,
  Path: string;
  FilesExtFilter: string;
  ScanSubdir: boolean;

begin
//###
  if ((GetKeyState(VK_SHIFT) and $80) <> 0) or (Cinema.FileName = '') then
    InitialDir := MovieFolder
  else
    InitialDir := ExtractFilePath(Cinema.FileName);
  if SelectDirectory(Handle, SelFold + ' - ' + PressCTRL, desktop_name, InitialDir, Path) then
  begin
    ScanSubdir := GetKeyState(VK_CONTROL) < 0;
    try
      Self.Add := Add;
      Screen.Cursor := crHourglass;
      if not Add then
        DeleteItems(ditAll);

      case item_type of
        oitFile:
          FilesExtFilter := MovieExt;
        oitPlaylist:
          FilesExtFilter := PlayListExt;
        oitBoth:
          FilesExtFilter := MovieExt + PlayListExt
      end;
      if AnsiLastChar(Path) <> '\' then
        Path := Path + '\';
      ScanDir(Path, FilesExtFilter, ScanSubdir);
      ChargeItem(0, FAutoplay and (not Add));
    finally
      Self.Add := false;
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TPlaylistBox.OpenItem(Add: boolean; item_type: TOpenItemType);
var
  FileIndex: integer;
begin
  with OpenDialog do
  begin
    Filter := MovieFilter + '|' + PlayListFilter + '|' + AllFilter;
    case item_type of
      oitFile:
        FilterIndex := 1;
      oitPlaylist:
        FilterIndex := 2;
      else
        FilterIndex := 3;
    end;
    FileName := '';
// uwzglednic drug¹ czêœæ warunku
//    MessageBox(0, PCHAR(CinemaSettings.MovieFolder), nil, MB_OK);
    if ((GetKeyState(VK_SHIFT) and $80) <> 0) or (Cinema.FileName = '') then
      InitialDir := MovieFolder
    else
      InitialDir := ExtractFilePath(Cinema.FileName);
    if Execute then
      try
        Self.Add := Add;
        Screen.Cursor := crHourGlass;
        if not Add then
          DeleteItems(ditAll);

        for FileIndex := 0 to Files.Count - 1 do
          AddPlayItem(Files[FileIndex]);

        ChargeItem(0, AutoPlay and (not Add));
      finally
        Self.Add := false;
        Screen.Cursor := crDefault;
      end;
  end;
end;

procedure TPlaylistBox.PlayNextItem;
var
  i, NotPlayedCount, NextPlayed: integer;
  EndPlay: boolean;

  function GetNextItem: integer;
  var
    i: integer;
    NextItem, NextIndex: integer;
  begin
    Result := -1;

    if FShuffleIndex = MinInt then
      exit;

    if PlayedItemExist then
    begin
      NextIndex := MaxInt;
      NextItem := PlayedItem;
      for i := 0 to Items.Count - 1 do
      begin
        if (PItemData(Items.Objects[i]).Played > FShuffleIndex) and
           (PItemData(Items.Objects[i]).Played < NextIndex) then
        begin
          NextIndex := PItemData(Items.Objects[i]).Played;
          NextItem := i;
        end;
      end;
    end;

    if NextItem = PlayedItem then
      Result := -1
    else
      Result := NextItem;
  end;

begin
  EndPlay := false;
// czy mamy losowaæ kolejny numer?
  if Shuffle then
  begin
    NextPlayed := GetNextItem;
    if NextPlayed = -1 then
    begin
      NotPlayedCount := 0;
    // ile nieodegranych pozycji?
      for i := 0 to Items.Count - 1 do
        if PItemData(Items.Objects[i]).Played = MinInt then
          inc(NotPlayedCount);
    // jezeli ju¿ wszystkie odegrane, to kasujemy flagi
      if NotPlayedCount = 0 then
      begin
        ClearPlayedFlags;
        NotPlayedCount := Items.Count;
    // w ko³o Macieju?
        EndPlay := not RepeatList;
      end;
      if not EndPlay then
      begin
      // losujemy numerek...
        NextPlayed := random(NotPlayedCount);
      // i przechodziy do wylosowanej pozycji
        NotPlayedCount := 0;
        for i := 0 to Items.Count - 1 do
          if PItemData(Items.Objects[i]).Played = MinInt then
            if NotPlayedCount = NextPlayed then
            begin
              if FShuffleIndex = MinInt then
                PItemData(Items.Objects[i]).Played := 0
              else
                PItemData(Items.Objects[i]).Played := FShuffleIndex + 1;

              PlayedItem := i;
              break;
            end
            else
              inc(NotPlayedCount);
      end;
    end
    else
    begin
      PlayedItem := NextPlayed;
//        EndPlay := not aRepeat.Checked;
    end;
  end
  else
// je¿eli nie to bierzemy kolejny wolny..
  begin
    if PlayedItemExist then
    begin
    // jeœli nieostatni to jedziemy dalej
      if PlayedItem = Items.Count - 1 then
        EndPlay := not RepeatList;

      if not EndPlay then
        if PlayedItem = Items.Count - 1 then
          PlayedItem := 0
        else
          inc(FPlayedItem);
    end
    else
    begin
      if PlayedItem >= Items.Count then
        EndPlay := not RepeatList;

      if not EndPlay then
        if PlayedItem >= Items.Count then
          PlayedItem := 0;
    end;
  end;
  if EndPlay then
  begin
    ClearPlayedFlags;
    if Assigned(FOnEnd) then
      OnEnd(Self);
  end
  else
    ChargeItem(PlayedItem, true);
end;

procedure TPlaylistBox.PlayPrevItem;
var
  i, NotPlayedCount, PrevPlayed: integer;
  EndPlay: boolean;

  function GetPrevItem: integer;
  var
    i: integer;
    PrevItem, PrevIndex: integer;
  begin
    Result := -1;
    if FShuffleIndex = MinInt then
      exit;

    if PlayedItemExist then
    begin
      PrevIndex := MinInt;
      PrevItem := PlayedItem;
      for i := 0 to Items.Count - 1 do
      begin
        if (PItemData(Items.Objects[i]).Played < FShuffleIndex) and
         (PItemData(Items.Objects[i]).Played > PrevIndex) then
        begin
          PrevIndex := PItemData(Items.Objects[i]).Played;
          PrevItem := i;
        end;
      end;
    end;

    if PrevItem = PlayedItem then
      Result := -1
    else
      Result := PrevItem;
  end;

begin
  EndPlay := false;

  if Shuffle then                // czy losowaæ kolejny numer?
  begin
    PrevPlayed := GetPrevItem;
    if PrevPlayed = -1 then
    begin
      NotPlayedCount := 0;       // ile nieodegranych pozycji?
      for i := 0 to Items.Count - 1 do
        if PItemData(Items.Objects[i]).Played = MinInt then
          inc(NotPlayedCount);

      if NotPlayedCount = 0 then // wszystkie odegrane?
      begin
        ClearPlayedFlags;
        NotPlayedCount := Items.Count;
        EndPlay := not RepeatList; // w ko³o Macieju?
      end;
      if not EndPlay then
      begin
        PrevPlayed := random(NotPlayedCount);  // losujemy numerek...
        NotPlayedCount := 0;
        for i := 0 to Items.Count - 1 do       // i przechodzimy do wylosowanej pozycji
          if PItemData(Items.Objects[i]).Played = MinInt then
            if NotPlayedCount = PrevPlayed then
            begin
              if FShuffleIndex = MinInt then
                PItemData(Items.Objects[i]).Played := 0
              else
                PItemData(Items.Objects[i]).Played := FShuffleIndex - 1;
              PlayedItem := i;
              break;
            end
            else
              inc(NotPlayedCount);
      end;
    end
    else
    begin
      PlayedItem := PrevPlayed;
    end;
  end
  else
// je¿eli nie to bierzemy kolejny wolny..
  begin
  // jeœli nieostatni to jedziemy dalej
    if PlayedItem = 0 then
      EndPlay := not RepeatList;
    if not EndPlay then
      if PlayedItem in [1 .. Items.Count - 1] then
        dec(FPlayedItem)
      else
        PlayedItem := Items.Count - 1;
  end;

  if EndPlay then
  begin
    ClearPlayedFlags;
    if Assigned(FOnBegin) then
      OnBegin(Self);
  end
  else
    ChargeItem(PlayedItem, true);
end;

procedure TPlaylistBox.SelectItems(SelectItemType: TSelectItemType);
var
  i: integer;
begin
  for i := Items.Count - 1 downto 0 do
    case SelectItemType of
      sitInvert:
        Selected[i] := not Selected[i];
      sitNone:
        Selected[i] := false;
      sitAll:
        Selected[i] := true;
    end;
end;

{procedure TPlaylistBox.SetOpenDialog(const Value: TOpenDialog);
begin
  FOpenDialog := Value;
  if FOpenDialog <> nil then
  begin
    FOpenDialog.FreeNotification(Self);
  end;
end;
}
procedure TPlaylistBox.SetShuffle(const Value: boolean);
begin
  FShuffle := Value;
  FShuffleIndex := MinInt;
end;

procedure TPlaylistBox.SaveList(FileName: string);
var
  i: integer;
  sciezka: string;

  function CropPath(Path1, Path2: string): string;
  var
    p1, p2: string;
  begin
    p1 := AnsiLowerCaseFileName(Path1);
    p2 := AnsiLowerCaseFileName(Path2);
    if Pos(p1, p2) = 1 then
      Result := Copy(Path2, Length(Path1) + 1, MaxInt)
    else
      Result := Path2;
  end;

begin
  with TStringList.Create do
    try
      Add('<ASX version="3.0">');

      sciezka := ExtractFilePath(FileName);
      for i := 0 to Items.Count - 1 do
      begin
        Add('<ENTRY>');
        Add(Format('  <REF href="%s" />', [CropPath(sciezka, ExtractFilePath(PItemData(Items.Objects[i]).Path)) + ExtractFileName(PItemData(Items.Objects[i]).Path)]));
        if PItemData(Items.Objects[i]).Title <> '' then
          Add(Format('  <TITLE>%s</TITLE>', [PItemData(Items.Objects[i]).Title]));
        if PItemData(Items.Objects[i]).Length <> 0 then
          Add(Format('  <LENGTH value=%d />', [PItemData(Items.Objects[i]).Length]));
        Add('</ENTRY>');
      end;

      if Count > 1 then
      begin
        Add('</ASX>');
        SaveToFile(FileName);
      end;
    finally
      Free;
    end;
end;

procedure TPlaylistBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
    WindowClass.style := WindowClass.style or CS_HREDRAW or CS_VREDRAW;
end;

procedure TPlaylistBox.Clear;
var
  i: integer;
begin
  Lock;
  for i := Items.Count - 1 downto 0 do
  begin
    PItemData(Items.Objects[i]).Path := '';
    PItemData(Items.Objects[i]).Title := '';
    Dispose(PItemData(Items.Objects[i]));
    Items.Delete(i);
  end;
  if Assigned(FOnDeleteItem) then
    OnDeleteItem(Self);
  Unlock;
end;

destructor TPlaylistBox.Destroy;
begin
  DeleteCriticalSection(FCS);
  inherited Destroy;
end;

procedure TPlaylistBox.Lock;
begin
  EnterCriticalSection(FCS);
end;

procedure TPlaylistBox.Unlock;
begin
  LeaveCriticalSection(FCS);
end;

end.
