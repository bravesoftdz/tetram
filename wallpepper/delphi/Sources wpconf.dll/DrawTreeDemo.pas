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

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, GraphicEx, ImgList, ComCtrls,
  Registry, ActnList, ZipMstr, UnrarComp, UInterfacePlugIn, ExtCtrls;

type
  TDrawTreeForm = class(TForm)
    Button5: TButton;
    Button3: TButton;
    Button1: TButton;
    ActionList1: TActionList;
    actOk: TAction;
    Essayer: TAction;
    Unrar1: TUnrar;
    ZipMaster1: TZipMaster;
    Panel2: TPanel;
    ListBox1: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure EssayerExecute(Sender: TObject);
    procedure actOkExecute(Sender: TObject);
    procedure VDT1DblClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  private
    FSelectedImage, FPathTemp: string;
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
  FileCtrl, ShellAPI, Mask, ShlObj, ActiveX, UCommon, UInterfaceChange, Math;

{$R *.DFM}

type
  // This data record contains all necessary information about a particular file system object.
  // This can either be a folder (virtual or real) or an image file.
  TShellObjectData = class
    FullPath,
      Display, Archive, Fichier: string;
    Image: TBitmap;
    Properties: string; // some image properties, preformatted
  end;

procedure TDrawTreeForm.FormCreate(Sender: TObject);
var
  dummy: array[0..MAX_PATH] of Char;
begin
  ZeroMemory(@dummy[0], SizeOf(dummy));
  GetTempPath(SizeOf(dummy), dummy);
  FPathTemp := IncludeTrailingPathDelimiter(StrPas(dummy));
end;

procedure TDrawTreeForm.RescaleImage(Source, Target: TBitmap);
// if source is in at least one dimension larger than the thumb size then
// rescale source but keep aspect ratio
var
  NewWidth,
    NewHeight: Integer;
begin
  if (Source.Width > Image1.Width) or (Source.Height > Image1.Height) then begin
    if Source.Width > Source.Height then begin
      NewWidth := Image1.Width;
      NewHeight := Round(Image1.Width * Source.Height / Source.Width);
    end
    else begin
      NewHeight := Image1.Height;
      NewWidth := Round(Image1.Height * Source.Width / Source.Height);
    end;

    Target.Width := NewWidth;
    Target.Height := NewHeight;
    SetStretchBltMode(Target.Canvas.Handle, HALFTONE);
    StretchBlt(Target.Canvas.Handle, 0, 0, NewWidth, NewHeight,
      Source.Canvas.Handle, 0, 0, Source.Width, Source.Height, SRCCOPY);
  end
  else
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
  end
  else if (ext = '.zip') then begin
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

procedure TDrawTreeForm.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
begin
  Essayer.Enabled := ListBox1.ItemIndex <> -1;
  actOk.Enabled := Essayer.Enabled;
end;

procedure TDrawTreeForm.EssayerExecute(Sender: TObject);
var
  Data: TShellObjectData;
begin
  Data := TShellObjectData(ListBox1.Items.Objects[ListBox1.ItemIndex]);
  FUseTest := ChangeWallPap(PChar(Data.FullPath), nil, ctManuel, FMainProg) or UseTest;
end;

procedure TDrawTreeForm.actOkExecute(Sender: TObject);
var
  Data: TShellObjectData;
begin
  Data := TShellObjectData(ListBox1.Items.Objects[ListBox1.ItemIndex]);
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
  ListBox1.Items.Clear;

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
      ListBox1.Items.Add(Trim(s));
    end;
  finally
    CloseFile(F);
  end;
end;

procedure TDrawTreeForm.ListBox1Click(Sender: TObject);
var
  Data: TShellObjectData;
  Picture: TPicture;
  i: Integer;
  Image: string;
begin
  Data := TShellObjectData(ListBox1.Items.Objects[ListBox1.ItemIndex]);
  if not Assigned(Data) then begin
    Data := TShellObjectData.Create;
    ListBox1.Items.Objects[ListBox1.ItemIndex] := Data;
    Data.FullPath := ListBox1.Items[ListBox1.ItemIndex];
    i := Pos('|', Data.FullPath);
    Image := Data.FullPath;
    if i = 0 then begin
      Data.Display := ExtractFileName(Data.FullPath) + #13#10 + ExtractFilePath(Data.FullPath);
      Data.Archive := '';
      Data.Fichier := Data.FullPath;
    end
    else begin
      ExtraitArchive(Image, Data.Archive, Data.Fichier);
      Data.Display := Data.Fichier + #13#10 + Data.Archive;
    end;
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
          pf1bit: Data.Properties := Data.Properties + ', 2 colors';
          pf4bit: Data.Properties := Data.Properties + ', 16 colors';
          pf8bit: Data.Properties := Data.Properties + ', 256 colors';
          pf15bit: Data.Properties := Data.Properties + ', 32K colors';
          pf16bit: Data.Properties := Data.Properties + ', 64K colors';
          pf24bit: Data.Properties := Data.Properties + ', 16M colors';
          pf32bit: Data.Properties := Data.Properties + ', 16M+ colors';
        end;
      except
        Data.Image.Free;
        Data.Image := nil;
      end;
    finally
      Picture.Free;
    end;
  end;
  Image1.Picture.Assign(Data.Image);
  Label1.Caption := Data.Display;
  Label2.Caption := Data.Properties;
end;

end.

