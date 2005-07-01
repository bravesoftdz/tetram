unit DrawTreeDemo;

// Virtual Treeview sample form demonstrating following features:
//   - General use of TVirtualDrawTree.
//   - Use of vertical node image alignment.
//   - Effective use of node initialization on demand to load images.
// Written by Mike Lischke.
//
// Note: define the symbol "GraphicEx" if you have my GraphicEx library
// available (see http://www.delphi-gems.com) which allows to load
// more image formats into the application.
// Otherwise disable the conditional symbol to compile this demo.

{$warn UNIT_PLATFORM OFF}
{$warn SYMBOL_PLATFORM OFF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, VirtualTrees, StdCtrls, GraphicEx, ImgList, ComCtrls,
  Registry, ActnList, ZipMstr, UnrarComp, UInterfacePlugIn;

type
  TDrawTreeForm = class(TForm)
    VDT1: TVirtualDrawTree;
    Button5: TButton;
    Button3: TButton;
    Button1: TButton;
    ActionList1: TActionList;
    actOk: TAction;
    Essayer: TAction;
    Unrar1: TUnrar;
    ZipMaster1: TZipMaster;
    procedure FormCreate(Sender: TObject);
    procedure VDT1CompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure VDT1DrawHint(Sender: TBaseVirtualTree; Canvas: TCanvas; Node: PVirtualNode; R: TRect; Column: TColumnIndex);
    procedure VDT1DrawNode(Sender: TBaseVirtualTree; const PaintInfo: TVTPaintInfo);
    procedure VDT1FreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VDT1GetHintSize(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var R: TRect);
    procedure VDT1GetNodeWidth(Sender: TBaseVirtualTree; Canvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; var NodeWidth: Integer);
    procedure VDT1InitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure VDT1HeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure EssayerExecute(Sender: TObject);
    procedure actOkExecute(Sender: TObject);
    procedure VDT1DblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FSelectedImage, FPathTemp: string;
    FImages: TStringList;
    FSelectedArchive: string;
    FUseTest: Boolean;
    procedure RescaleImage(Source, Target: TBitmap);
    function ExtraitArchive(var Image: string; out Archive, Fichier: string): Boolean;
  published
    procedure LoadListe(ListeFichiers: string);
    property SelectedImage: string read FSelectedImage;
    property SelectedArchive: string read FSelectedArchive;
    property UseTest: Boolean read FUseTest;
  public
    FMainProg: IMainProg;
  end;

implementation

uses
  FileCtrl, ShellAPI, Mask, ShlObj, ActiveX, UCommon, UInterfaceChange;

{$R *.DFM}

const
  ThumbSize = 60;
  HintFactor = 4;

type
  // This data record contains all necessary information about a particular file system object.
  // This can either be a folder (virtual or real) or an image file.
  PShellObjectData = ^TShellObjectData;
  TShellObjectData = record
    FullPath,
    Display, Archive, Fichier: String;
    Image: TBitmap;
    Properties: String;   // some image properties, preformatted
  end;

procedure TDrawTreeForm.FormCreate(Sender: TObject);
var
  dummy: array[0..MAX_PATH] of Char;
begin
  VDT1.NodeDataSize := SizeOf(TShellObjectData);
  VDT1.RootNodeCount := 0;
  ZeroMemory(@dummy[0], SizeOf(dummy));
  GetTempPath(SizeOf(dummy), dummy);
  FPathTemp := IncludeTrailingPathDelimiter(StrPas(dummy));
  FImages := TStringList.Create;
end;

procedure TDrawTreeForm.RescaleImage(Source, Target: TBitmap);
// if source is in at least one dimension larger than the thumb size then
// rescale source but keep aspect ratio
var
  NewWidth,
  NewHeight: Integer;
begin
  if (Source.Width > ThumbSize) or (Source.Height > ThumbSize) then begin
    if Source.Width > Source.Height then begin
      NewWidth := ThumbSize;
      NewHeight := Round(ThumbSize * Source.Height / Source.Width);
    end else begin
      NewHeight := ThumbSize;
      NewWidth := Round(ThumbSize * Source.Width / Source.Height);
    end;

    Target.Width := NewWidth;
    Target.Height := NewHeight;
    SetStretchBltMode(Target.Canvas.Handle, HALFTONE);
    StretchBlt(Target.Canvas.Handle, 0, 0, NewWidth, NewHeight,
      Source.Canvas.Handle, 0, 0, Source.Width, Source.Height, SRCCOPY);
  end else
    Target.Assign(Source);
end;

function TDrawTreeForm.ExtraitArchive(var Image: string; out Archive, Fichier: string): Boolean;
var
  ext: string;
  i: Integer;
begin
  Result := False;
  i := Pos('|', Image);
  Archive := Copy(Image, Succ(i), Length(Image));
  Fichier := Copy(Image, 1, Pred(i));
  ext := LowerCase(ExtractFileExt(Archive));
  if (ext = '.rar') then begin
    try
      Unrar1.RarFile := Archive;
      Unrar1.FileMask := ExtractFileName(Fichier);
      Unrar1.PathMask := IncludeTrailingPathDelimiter(ExtractFilePath(Fichier));
      Unrar1.PathDest := FPathTemp + 'WallPepper\';
      Unrar1.UsePath := False;
      Unrar1.Extract;
      Image := Unrar1.PathDest + Unrar1.FileMask;
      Result := True;
    finally
      Unrar1.Close;
      Unrar1.FileMask := '';
      Unrar1.PathMask := '';
    end;
  end else if (ext = '.zip') then begin
    try
      ZipMaster1.ZipFileName := Archive;
      ZipMaster1.FSpecArgs.Add(Fichier);
      ZipMaster1.ExtrBaseDir := FPathTemp + 'WallPepper\';
      ZipMaster1.ExtrOptions := ZipMaster1.ExtrOptions - [ExtrDirNames] + [ExtrForceDirs, ExtrOverWrite];
      ZipMaster1.Extract;
      Image := ZipMaster1.ExtrBaseDir + ExtractFileName(Fichier);
      Result := True;
    finally
      ZipMaster1.ZipFileName := '';
      ZipMaster1.FSpecArgs.Clear;
    end;
  end;
end;

procedure TDrawTreeForm.VDT1InitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  Data: PShellObjectData;
  Picture: TPicture;
  i: Integer;
  Image: string;
begin
  Data := Sender.GetNodeData(Node);
  Data.FullPath := FImages[Node.Index];
  i := Pos('|', Data.FullPath);
  Image := Data.FullPath;
  if i = 0 then begin
    Data.Display := ExtractFileName(Data.FullPath) + #13#10 + ExtractFilePath(Data.FullPath);
    Data.Archive := '';
    Data.Fichier := Data.FullPath;
  end else begin
    ExtraitArchive(Image, Data.Archive, Data.Fichier);
    Data.Display := Data.Fichier + #13#10 + Data.Archive;
  end;
  Include(InitialStates, ivsMultiline);
  Picture := TPicture.Create;
  try
    try
      Data.Image := TBitmap.Create;
      Picture.LoadFromFile(Image);
      if not (Picture.Graphic is TBitmap) then begin
        with Data.Image do begin
          Width := Picture.Width;
          Height := Picture.Height;
          Canvas.Draw(0, 0, Picture.Graphic);
        end;
        Picture.Bitmap.Assign(Data.Image);
      end;
      RescaleImage(Picture.Bitmap, Data.Image);

      Data.Properties := Data.Properties + Format('%d x %d pixels', [Picture.Width, Picture.Height]);
      case Picture.Bitmap.PixelFormat of
        pf1bit:  Data.Properties := Data.Properties + ', 2 colors';
        pf4bit:  Data.Properties := Data.Properties + ', 16 colors';
        pf8bit:  Data.Properties := Data.Properties + ', 256 colors';
        pf15bit: Data.Properties := Data.Properties + ', 32K colors';
        pf16bit: Data.Properties := Data.Properties + ', 64K colors';
        pf24bit: Data.Properties := Data.Properties + ', 16M colors';
        pf32bit: Data.Properties := Data.Properties + ', 16M+ colors';
      end;
      if Cardinal(Data.Image.Height) + 4 > TVirtualDrawTree(Sender).DefaultNodeHeight then
          Sender.NodeHeight[Node] := Data.Image.Height + 4;
    except
      Data.Image.Free;
      Data.Image := nil;
    end;
  finally
    Picture.Free;
  end;
end;

procedure TDrawTreeForm.VDT1FreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PShellObjectData;
begin
  Data := Sender.GetNodeData(Node);
  Data.Image.Free;
  Finalize(Data^); // Clear string data.
end;

procedure TDrawTreeForm.VDT1DrawNode(Sender: TBaseVirtualTree; const PaintInfo: TVTPaintInfo);
// This is the main paint routine for a node in a draw tree. There is nothing special here. Demonstrating the
// specific features of a draw tree (compared to the string tree) is a bit difficult, since the only difference is
// that the draw tree does not handle node content (captions in the case of the string tree).
var
  Data: PShellObjectData;
  X: Integer;
  S: WideString;
  dR, R: TRect;
begin
  with Sender as TVirtualDrawTree, PaintInfo do begin
    Data := Sender.GetNodeData(Node);
    if (Column = FocusedColumn) and (Node = FocusedNode) then
      Canvas.Font.Color := clHighlightText
    else
      Canvas.Font.Color := clWindowText;

    SetBKMode(Canvas.Handle, TRANSPARENT);

    R := ContentRect;
    InflateRect(R, -TextMargin, 0);
    Dec(R.Right);
    Dec(R.Bottom);
    S := '';
    case Column of
      0, 2:
        begin
          if Column = 2 then begin
            if Assigned(Data.Image) then
              S:= Data.Properties;
          end else
            S := Data.Display;
          if Length(S) > 0 then begin
//            with R do begin
//              if (NodeWidth - 2 * Margin) > (Right - Left) then
//                S := ShortenString(Canvas.Handle, S, Right - Left, False);
//            end;
            DrawTextW(Canvas.Handle, PWideChar(S), Length(S), dR, DT_LEFT or DT_CENTER or DT_CALCRECT, False);
            Inc(R.Top, ((R.Bottom - R.Top) - (dR.Bottom - dR.Top)) div 2); 
            DrawTextW(Canvas.Handle, PWideChar(S), Length(S), R, DT_LEFT or DT_CENTER, False);
          end;
        end;
      1:
        begin
          if Assigned(Data.Image) then begin
            X := ContentRect.Left + (VDT1.Header.Columns[1].Width - Data.Image.Width - Margin) div 2;
            BitBlt(Canvas.Handle, X, ContentRect.Top + 2, Data.Image.Width, Data.Image.Height, Data.Image.Canvas.Handle,
              0, 0, SRCCOPY);
          end;
        end;
    end;
  end;
end;

procedure TDrawTreeForm.VDT1GetNodeWidth(Sender: TBaseVirtualTree; Canvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; var NodeWidth: Integer);
// Since the draw tree does not know what is in a cell, we have to return the width of the content (not the entire
// cell width, this could be determined by the column width).
var
  Data: PShellObjectData;
  AMargin: Integer;
begin
  with Sender as TVirtualDrawTree do
    AMargin := TextMargin;

    Data := Sender.GetNodeData(Node);
    case Column of
      0:
        begin
          if Node.Parent = Sender.RootNode then
            NodeWidth := Canvas.TextWidth(Data.FullPath) + 2 * AMargin
          else
            NodeWidth := Canvas.TextWidth(ExtractFileName(Data.FullPath)) + 2 * AMargin;
        end;
      1:
        begin
          if Assigned(Data.Image) then
            NodeWidth := Data.Image.Width;
        end;
      2:
        NodeWidth := Canvas.TextWidth(Data.Properties) + 2 * AMargin;
    end;
end;

procedure TDrawTreeForm.VDT1GetHintSize(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var R: TRect);
// Draw trees must manage parts of the hints themselves. Here we return the size of the hint window we want to show
// or an empty rectangle in the case we don't want a hint at all.
var
  Data: PShellObjectData;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) and Assigned(Data.Image) and (Column = 1) then
    R := Rect(0, 0, HintFactor * Data.Image.Width, HintFactor * Data.Image.Height)
  else
    R := Rect(0, 0, 0, 0);
end;

procedure TDrawTreeForm.VDT1DrawHint(Sender: TBaseVirtualTree; Canvas: TCanvas; Node: PVirtualNode; R: TRect; Column: TColumnIndex);
// Here we actually paint the hint. It is the image in a larger size.
var
  Data: PShellObjectData;
  Picture: TPicture;
  Bitmap: TBitmap;
  i: Integer;
  Image: string;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) and Assigned(Data.Image) and (Column = 1) then begin
  i := Pos('|', Data.FullPath);
  Image := Data.FullPath;
  if i = 0 then begin
    Data.Display := ExtractFileName(Data.FullPath) + #13#10 + ExtractFilePath(Data.FullPath);
    Data.Archive := '';
    Data.Fichier := Data.FullPath;
  end else begin
    ExtraitArchive(Image, Data.Archive, Data.Fichier);
    Data.Display := Data.Fichier + #13#10 + Data.Archive;
  end;
  Picture := TPicture.Create;
  try
    Picture.LoadFromFile(Image);
    if not (Picture.Graphic is TBitmap) then begin
      Bitmap := TBitmap.Create;
      Bitmap.Width := Picture.Width;
      Bitmap.Height := Picture.Height;
      Bitmap.Canvas.Draw(0, 0, Picture.Graphic);
      Picture.Bitmap.Assign(Bitmap);
    end;
    SetStretchBltMode(Canvas.Handle, HALFTONE);
    StretchBlt(Canvas.Handle, 0, 0, HintFactor * Data.Image.Width, HintFactor * Data.Image.Height, Picture.Bitmap.Canvas.Handle, 0, 0,
      Picture.Bitmap.Width, Picture.Bitmap.Height, SRCCOPY);
  finally
    Picture.Free;
  end;



//    SetStretchBltMode(Canvas.Handle, HALFTONE);
//    StretchBlt(Canvas.Handle, 0, 0, HintFactor * Data.Image.Width, HintFactor * Data.Image.Height, Data.Image.Canvas.Handle, 0, 0,
//      Data.Image.Width, Data.Image.Height, SRCCOPY);
  end;
end;

procedure TDrawTreeForm.VDT1CompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
// The node comparison routine is the heart of the tree sort. Here we have to tell the caller which node we consider
// being "larger" or "smaller".
var
  Data1,
  Data2: PShellObjectData;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);

  Result := CompareText(Data1.FullPath, Data2.FullPath);
end;

procedure TDrawTreeForm.VDT1HeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
// Click handler to switch the column on which will be sorted. Since we cannot sort image data sorting is actually
// limited to the main column.

begin
  if Button = mbLeft then begin
    with Sender do begin
      if Column <> MainColumn then
        SortColumn := NoColumn
      else begin
        if SortColumn = NoColumn then begin
          SortColumn := Column;
          SortDirection := sdAscending;
        end
        else
          if SortDirection = sdAscending then SortDirection := sdDescending
                                         else SortDirection := sdAscending;
        Treeview.SortTree(SortColumn, SortDirection, False);
      end;
    end;
  end;
end;

procedure TDrawTreeForm.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
var
  Data: PShellObjectData;
begin
  Data := VDT1.GetNodeData(VDT1.FocusedNode);
  Essayer.Enabled := Assigned(Data);
  actOk.Enabled := Essayer.Enabled;
end;

procedure TDrawTreeForm.EssayerExecute(Sender: TObject);
var
  Data: PShellObjectData;
begin
  Data := VDT1.GetNodeData(VDT1.FocusedNode);
  FUseTest := ChangeWallPap(PChar(Data.FullPath), nil, ctManuel, FMainProg) or UseTest;
end;

procedure TDrawTreeForm.actOkExecute(Sender: TObject);
var
  Data: PShellObjectData;
begin
  Data := VDT1.GetNodeData(VDT1.FocusedNode);
  FSelectedImage := Data.FullPath;
  FSelectedArchive := '';
end;

procedure TDrawTreeForm.VDT1DblClick(Sender: TObject);
begin
  actOk.Execute;
end;

procedure TDrawTreeForm.LoadListe(ListeFichiers: string);
var
  f: file of Byte;
  c: Byte;
  s: string;
begin
  FImages.Clear;
  VDT1.RootNodeCount := 0;

  AssignFile(F, ListeFichiers);
  Reset(F);
  try
    Seek(f, 1); // #1
    while not Eof(f) do begin
      s := '';
      c := 32;
      if not Eof(f) then
        repeat
          s := s + Char(c);
          Read(f, c);
        until (c = 1) or Eof(f);
      if (c <> 1) then s := s + Char(c);
      FImages.Add(Trim(s));
    end;
  finally
    CloseFile(F);
  end;

  VDT1.RootNodeCount := FImages.Count;
end;

procedure TDrawTreeForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FImages);
end;

end.
