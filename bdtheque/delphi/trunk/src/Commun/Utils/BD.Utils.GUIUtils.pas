unit BD.Utils.GUIUtils;

interface

uses
  System.SysUtils, Winapi.Windows, System.Classes, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Graphics, Vcl.Forms, BD.GUI.Forms.Progress, Vcl.Controls,
  Vcl.StdCtrls;

function AffMessage(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; Son: Boolean = False): Word;

function FormExistB(ClassType: TClass): Boolean;
function FormExistI(ClassType: TClass): Integer;

procedure MoveListItem(LV: TListView; Sens: Integer);

function DessineImage(Image: TImage; const Fichier: string): Boolean;
function ChargeImage(ImgBmp: TImage; const ResName: string; ForceVisible: Boolean = True): Boolean; overload;
function ChargeImage(Picture: TPicture; const ResName: string): Boolean; overload;

procedure PrepareLV(Form: TForm);

type
  IHourGlass = interface
  end;

  THourGlass = class(TInterfacedObject, IHourGlass)
  strict private
    FOldCursor: TCursor;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TEtapeProgression = (epNext, epFin);

  IWaiting = interface
    ['{82C50525-A282-4982-92DB-ED5FEC2E5C96}']
    procedure ShowProgression(const Texte: string; Etape: TEtapeProgression); overload; stdcall;
    procedure ShowProgression(Texte: PChar; Valeur, Maxi: Integer); overload; stdcall;
    procedure ShowProgression(const Texte: string; Valeur, Maxi: Integer); overload; stdcall;
  end;

  TWaiting = class(TInterfacedObject, IWaiting)
  strict private
    FTimer: TTimer;

    FCaption, FMessage: string;
    FValeur, FMaxi: Integer;
    FTimeToWait: Cardinal;
    FForm: TfrmProgression;
    PResult: PInteger;
    FromMainThread: Boolean;
    procedure InitForm;
    procedure ClearForm;
    procedure RefreshForm;
    procedure Execute(Sender: TObject);
    procedure Cancel(Sender: TObject);
  public
    constructor Create(const Msg: string = ''; WaitFor: Cardinal = 2000; Retour: PInteger = nil; MainThread: Boolean = True); reintroduce;
    destructor Destroy; override;
    procedure ShowProgression(const Texte: string; Etape: TEtapeProgression); overload; stdcall;
    procedure ShowProgression(const Texte: string; Valeur, Maxi: Integer); overload; stdcall;
    procedure ShowProgression(Texte: PChar; Valeur, Maxi: Integer); overload; stdcall;
  end;

  ILockWindow = interface
  end;

  TLockWindow = class(TInterfacedObject, ILockWindow)
  strict private
    FLocked: Boolean;
  public
    constructor Create(Form: TWinControl);
    destructor Destroy; override;
  end;

  IInformation = interface
    procedure ShowInfo(const Msg: string);
  end;

  TInformation = class(TInterfacedObject, IInformation)
  strict private
    FInfo: TForm;
    FLabel: TLabel;
    procedure SetupDialog;
  public
    procedure ShowInfo(const Msg: string);
    constructor Create;
    destructor Destroy; override;
  end;

function GetJPEGStream(AStream: TStream): TStream; overload;
function GetJPEGStream(const Fichier: string): TStream; overload;
function GetJPEGStream(const Fichier: string; Hauteur, Largeur: Integer; AntiAliasing: Boolean; Cadre: Boolean = False; Effet3D: Integer = 0): TStream; overload;
function ResizePicture(Image: TPicture; Hauteur, Largeur: Integer; AntiAliasing, Cadre: Boolean; Effet3D: Integer): TStream;

function FindCmdLineSwitch(const cmdLine, Switch: string): Boolean; overload;
function FindCmdLineSwitch(const cmdLine, Switch: string; out Value: string): Boolean; overload;

implementation

uses
  System.IOUtils, BD.Utils.StrUtils, BD.Common, Divers, VirtualTrees, GR32, GR32_Resamplers, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, JvGIF, BD.GUI.Forms,
  System.UITypes;

function AffMessage(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; Son: Boolean = False): Word;
begin
  if Son then
    MessageBeep(MB_ICONERROR);
  Result := MessageDlg(Msg, DlgType, Buttons, 0);
end;

function FormExistB(ClassType: TClass): Boolean;
begin
  Result := FormExistI(ClassType) > 0;
end;

function FormExistI(ClassType: TClass): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to Screen.FormCount - 1 do
    if Screen.Forms[i].ClassType = ClassType then
      Inc(Result);
end;

function DessineImage(Image: TImage; const Fichier: string): Boolean;
var
  largeuraff, hauteuraff, largeurimg, hauteurimg: Integer;
  marge: Integer;
  hg: IHourGlass;
  p: TPicture;
begin
  Result := False;
  Image.Picture := nil;
  if not TFile.Exists(Fichier) then
    Exit;
  hg := THourGlass.Create;
  p := TPicture.Create;
  try
    p.LoadFromFile(Fichier);
    hauteurimg := p.Height;
    largeurimg := p.Width;
    largeuraff := Image.Width;
    hauteuraff := Image.Height;
    if (hauteurimg >= hauteuraff) and (largeurimg >= largeuraff) then
      if (hauteurimg / largeurimg) > (hauteuraff / largeuraff) then
      begin
        largeuraff := Winapi.Windows.MulDiv(hauteuraff, largeurimg, hauteurimg);
        marge := (Image.Width - largeuraff) div 2;
        Image.Canvas.StretchDraw(Rect(marge, 0, marge + largeuraff, hauteuraff), p.Graphic);
      end
      else
      begin
        hauteuraff := Winapi.Windows.MulDiv(largeuraff, hauteurimg, largeurimg);
        marge := (Image.Height - hauteuraff) div 2;
        Image.Canvas.StretchDraw(Rect(0, marge, largeuraff, marge + hauteuraff), p.Graphic);
      end
    else
      Image.Canvas.Draw((largeuraff - largeurimg) div 2, (hauteuraff - hauteurimg) div 2, p.Graphic);
    Result := True;
  finally
    p.Free;
  end;
end;

function ChargeImage(Picture: TPicture; const ResName: string): Boolean;
begin
  Result := False;
  Picture.Bitmap.FreeImage;
  if TGlobalVar.Options.Images and not IsRemoteSession then
  begin
    if TGlobalVar.HandleDLLPic <= 32 then
      TGlobalVar.HandleDLLPic := LoadLibrary(PChar(TGlobalVar.RessourcePic));
    if TGlobalVar.HandleDLLPic > 32 then
      try
        Picture.Bitmap.LoadFromResourceName(TGlobalVar.HandleDLLPic, ResName);
        Result := True;
      except
      end;
  end;
end;

function ChargeImage(ImgBmp: TImage; const ResName: string; ForceVisible: Boolean = True): Boolean;
begin
  Result := ChargeImage(ImgBmp.Picture, ResName);
  if ForceVisible then
    ImgBmp.Visible := not ImgBmp.Picture.Bitmap.Empty;
end;

procedure MoveListItem(LV: TListView; Sens: Integer);
var
  AListItem: TListItem;
  TmpAListItem: TListItem;
  swLI: TListItem;
begin
  AListItem := LV.Selected;
  if not Assigned(AListItem) then
    Exit;
  if not(AListItem.index + Sens in [0 .. LV.Items.Count - 1]) then
    Exit;
  TmpAListItem := LV.Items[AListItem.index + Sens];
  if not Assigned(TmpAListItem) then
    Exit;
  LV.Items.BeginUpdate;
  swLI := LV.Items.Add;
  try
    swLI.Assign(TmpAListItem);
    TmpAListItem.Assign(AListItem);
    AListItem.Assign(swLI);
    LV.Selected := TmpAListItem;
    LV.Selected.Focused := True;
    LV.Selected.MakeVisible(False);
  finally
    swLI.Delete;
    LV.Items.EndUpdate;
  end;
end;

procedure PrepareLV(Form: TForm);
var
  i, j, w: Integer;
  hdr: TVTHeader;
  lv: TListView;
begin
  for i := 0 to Form.ComponentCount - 1 do
    try
      if Form.Components[i] is TListView then
      begin
        lv := TListView(Form.Components[i]);
        if lv.Columns.Count = 1 then
          lv.Columns[0].Width := lv.ClientWidth - GetSystemMetrics(SM_CXVSCROLL);
      end
      else if Form.Components[i] is TVirtualStringTree then
      begin
        hdr := TVirtualStringTree(Form.Components[i]).Header;
        if hdr.Columns.Count > 0 then
        begin
          w := 0;
          for j := 0 to Pred(hdr.Columns.Count) do
            if j <> hdr.MainColumn then
              Inc(w, hdr.Columns[j].Width);
          hdr.Columns[hdr.MainColumn].Width := hdr.TreeView.ClientWidth - w - GetSystemMetrics(SM_CXVSCROLL);
        end;
      end;
    except
    end;
end;

{ THourGlass }

constructor THourGlass.Create;
begin
  inherited;
  FOldCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
end;

destructor THourGlass.Destroy;
begin
  Screen.Cursor := FOldCursor;
  inherited;
end;

{ TLockWindow }

constructor TLockWindow.Create(Form: TWinControl);
begin
  inherited Create;
  FLocked := LockWindowUpdate(Form.Handle);
end;

destructor TLockWindow.Destroy;
begin
  if FLocked then
    LockWindowUpdate(0);
  inherited;
end;

{ TWaiting }

procedure TWaiting.ClearForm;
begin
  if Assigned(FForm) then
    FreeAndNil(FForm);
end;

constructor TWaiting.Create(const Msg: string; WaitFor: Cardinal; Retour: PInteger; MainThread: Boolean);
begin
  inherited Create;
  FTimer := TTimer.Create(nil);
  FTimer.Interval := WaitFor;
  FTimer.OnTimer := Execute;
  FromMainThread := MainThread;

  FForm := TfrmProgression.Create(Application);
  if Assigned(PResult) then
    FForm.framBoutons1.btnAnnuler.OnClick := Self.Cancel
  else
    FForm.framBoutons1.Visible := False;
  if FCaption <> '' then
    FForm.Caption := FCaption;

  FCaption := Msg;
  FTimeToWait := WaitFor;
  if Assigned(Retour) then
    Retour^ := 0;
  PResult := Retour;
  FTimer.Enabled := True;
end;

procedure TWaiting.InitForm;
begin
  RefreshForm;
  FForm.Show;
end;

destructor TWaiting.Destroy;
begin
  ShowProgression(FMessage, epFin);
  FreeAndNil(FTimer);
  if Assigned(FForm) then
    ClearForm;
  inherited;
end;

procedure TWaiting.Execute(Sender: TObject);
begin
  FTimer.Enabled := False;
  InitForm;
end;

procedure TWaiting.RefreshForm;
var
  tmp: string;
begin
  if Assigned(FForm) then
  begin
    FForm.ProgressBar1.Max := FMaxi;
    FForm.ProgressBar1.Position := FValeur;
    tmp := FMessage;
    if FForm.op.Canvas.TextWidth(tmp) > FForm.op.Width then
    begin
      while FForm.op.Canvas.TextWidth(tmp + '...') > FForm.op.Width do
        Delete(tmp, Length(tmp) div 2, 1);
      Insert('...', tmp, Length(tmp) div 2);
    end;
    FForm.op.Caption := tmp;
  end;
  if FromMainThread then
    Application.ProcessMessages;
end;

procedure TWaiting.ShowProgression(const Texte: string; Etape: TEtapeProgression);
begin
  case Etape of
    epNext:
      Inc(FValeur);
    epFin:
      FValeur := FMaxi;
  end;
  if Texte <> '' then
    FMessage := Texte;

  RefreshForm;
end;

procedure TWaiting.ShowProgression(const Texte: string; Valeur, Maxi: Integer);
begin
  FMaxi := Maxi;
  FValeur := Valeur;
  if Texte <> '' then
    FMessage := Texte;
  RefreshForm;
end;

procedure TWaiting.ShowProgression(Texte: PChar; Valeur, Maxi: Integer);
begin
  FMaxi := Maxi;
  FValeur := Valeur;
  if Texte <> '' then
    FMessage := Texte;
  RefreshForm;
end;

procedure TWaiting.Cancel(Sender: TObject);
begin
  if Assigned(PResult) then
    PResult^ := FForm.ModalResult;
  FForm.Release;
  FForm := nil;
end;

function ChangeLight(Value, FromValue, ToValue: Integer; Color, ToColor: TColor): TColor;

  function Min(a, b: Integer): Integer; inline;
  begin
    if a < b then
      Result := a
    else
      Result := b;
  end;

  function Max(a, b: Integer): Integer; inline;
  begin
    if a > b then
      Result := a
    else
      Result := b;
  end;

var
  rc, gc, bc: Integer;
begin
  Color := Color and not clSystemColor;
  ToColor := ToColor and not clSystemColor;
  rc := GetRValue(Color) + Round(MulDiv(GetRValue(ToColor) - GetRValue(Color), Value - FromValue, ToValue - FromValue));
  gc := GetGValue(Color) + Round(MulDiv(GetGValue(ToColor) - GetGValue(Color), Value - FromValue, ToValue - FromValue));
  bc := GetBValue(Color) + Round(MulDiv(GetBValue(ToColor) - GetBValue(Color), Value - FromValue, ToValue - FromValue));

  Result := RGB(Max(0, Min(255, rc)), Max(0, Min(255, gc)), Max(0, Min(255, bc)));
end;

function ResizePicture(Image: TPicture; Hauteur, Largeur: Integer; AntiAliasing, Cadre: Boolean; Effet3D: Integer): TStream;
var
  NewLargeur, NewHauteur, i: Integer;
  Bmp: TBitmap;
  BMP32Src, BMP32Dst: TBitmap32;
  j: TJPEGImage;
begin
  Result := TMemoryStream.Create;
  try
    if (Hauteur = -1) and (Largeur = -1) then
      Image.Graphic.SaveToStream(Result)
    else
    begin
      if Hauteur = -1 then
      begin
        NewLargeur := Largeur;
        NewHauteur := Winapi.Windows.MulDiv(NewLargeur, Image.Height, Image.Width);
      end
      else
      begin
        NewHauteur := Hauteur;
        NewLargeur := Winapi.Windows.MulDiv(NewHauteur, Image.Width, Image.Height);
        if (Largeur <> -1) and (NewLargeur > Largeur) then
        begin
          NewLargeur := Largeur;
          NewHauteur := Winapi.Windows.MulDiv(NewLargeur, Image.Height, Image.Width);
        end;
      end;
      Bmp := TBitmap.Create;
      try
        Dec(NewHauteur, Effet3D);
        Dec(NewLargeur, Effet3D);
        Bmp.Height := NewHauteur;
        Bmp.Width := NewLargeur;
        if AntiAliasing then
        begin
          BMP32Src := TBitmap32.Create;
          BMP32Dst := TBitmap32.Create;
          try
            BMP32Src.Assign(Image.Graphic);
            // pas besoin de variable: TBitmap32 va le détruire
            TLinearResampler.Create(BMP32Src);
            BMP32Dst.Height := NewHauteur;
            BMP32Dst.Width := NewLargeur;
            BMP32Dst.Draw(BMP32Dst.BoundsRect, BMP32Src.BoundsRect, BMP32Src);
            Bmp.Assign(BMP32Dst);
          finally
            BMP32Src.Free;
            BMP32Dst.Free;
          end;
        end
        else
          Bmp.Canvas.StretchDraw(Rect(0, 0, NewLargeur, NewHauteur), Image.Graphic);
        Bmp.Height := NewHauteur + Effet3D;
        Bmp.Width := NewLargeur + Effet3D;
        Bmp.Canvas.TextOut(Bmp.Width, Bmp.Height, '');

        if Cadre then
        begin
          Bmp.Canvas.Pen.Color := clBlack;
          Bmp.Canvas.Pen.Style := psSolid;
          Bmp.Canvas.Brush.Color := clBlack;
          Bmp.Canvas.Brush.Style := bsClear;
          Bmp.Canvas.Rectangle(0, 0, NewLargeur, NewHauteur);
        end;

        if Effet3D > 0 then
        begin
          Bmp.Canvas.Pen.Color := clBlack;
          Bmp.Canvas.Pen.Style := psSolid;
          Bmp.Canvas.Brush.Color := clGray;
          Bmp.Canvas.Brush.Style := bsSolid;

          for i := 0 to Effet3D do
          begin
            Bmp.Canvas.Pen.Color := ChangeLight(i, 0, Effet3D, clGray, clWhite);

            Bmp.Canvas.MoveTo(0 + i, NewHauteur + i);
            Bmp.Canvas.LineTo(NewLargeur + i, NewHauteur + i);
            Bmp.Canvas.LineTo(NewLargeur + i, 0 + i);
          end;
        end;

        j := TJPEGImage.Create;
        try
          j.Assign(Bmp);
          j.PixelFormat := jf24Bit;
          j.CompressionQuality := 70;
          j.Compress;
          j.SaveToStream(Result);
        finally
          j.Free;
        end;
      finally
        Bmp.Free;
      end;
    end;

    Result.Position := 0;
  except
    FreeAndNil(Result);
  end;
end;

function GetJPEGStream(const Fichier: string): TStream;
var
  f: TFileStream;
begin
  Result := nil;
  f := TFileStream.Create(Fichier, fmOpenRead or fmShareDenyWrite);
  try
    Result := GetJPEGStream(f);
  finally
    if Result <> f then
      f.Free;
  end;
end;

function GetJPEGStream(AStream: TStream): TStream;

  function MatchesMask(const Fichier, Mask: string): Boolean;
  var
    sl: TStringList;
  begin
    sl := TStringList.Create;
    try
      sl.Text := StringReplace(LowerCase(Mask), ';', #13#10, [rfReplaceAll]);
      Result := sl.IndexOf('*' + Fichier) <> -1;
    finally
      sl.Free;
    end;
  end;

const
  JPGMagic: array[0..2] of Byte = ($FF, $D8, $FF);
  GIFMagic: array[0..3] of Byte = ($47, $49, $46, $38);
  PNGMagic: array[0..7] of Byte = ($89, $50, $4E, $47, $0D, $0A, $1A, $0A);

var
  jImg: TJPEGImage;
  img: TPicture;
  graphClass: TGraphicClass;
  graph: TGraphic;
  buffer: array[0..7] of Byte;
begin
  AStream.Position := 0;
  AStream.ReadBuffer(buffer, Length(buffer));
  AStream.Position := 0;

  if CompareMem(@buffer, @JPGMagic, Length(JPGMagic)) then
    // déjà du JPEG
    Exit(AStream);

  if CompareMem(@buffer, @PNGMagic, Length(PNGMagic)) then
    // PNG
    graphClass := TPngImage
  else if CompareMem(@buffer, @GIFMagic, Length(GIFMagic)) then
    // GIF
    graphClass := TJvGIFImage
  else
    // type inconnu = on laisse faire la VCL, avec un peu de bol ça marchera
    graphClass := nil;

  Result := TMemoryStream.Create;
  img := nil;
  graph := nil;
  jImg := TJPEGImage.Create;
  try
    if Assigned(graphClass) then
    begin
      graph := graphClass.Create;
      graph.LoadFromStream(AStream);
    end
    else
    begin
      img := TPicture.Create;
      img.LoadFromStream(AStream);
    end;

    jImg.PixelFormat := jf24Bit;
    if Assigned(graph) then
      jImg.Assign(graph)
    else
      jImg.Assign(img.Graphic);
    jImg.CompressionQuality := 70;
    jImg.Compress;
    jImg.SaveToStream(Result);
  finally
    jImg.Free;
    img.Free;
    graph.Free;
  end;

  Result.Position := 0;
end;

function GetJPEGStream(const Fichier: string; Hauteur, Largeur: Integer; AntiAliasing: Boolean; Cadre: Boolean = False; Effet3D: Integer = 0): TStream;
var
  picture: TPicture;
  image: TJPEGImage;
  stream: TStream;
begin
  picture := TPicture.Create;
  try
    stream := GetJPEGStream(Fichier);
    image := TJPEGImage.Create;
    try
      stream.Position := 0;
      image.LoadFromStream(stream);
      picture.Assign(image);
    finally
      image.Free;
      stream.Free;
    end;
    Result := ResizePicture(picture, Hauteur, Largeur, AntiAliasing, Cadre, Effet3D);
  finally
    picture.Free;
  end;
end;

  { TInformation }

constructor TInformation.Create;
begin
  inherited;
  FInfo := nil;
  FLabel := nil;
end;

destructor TInformation.Destroy;
begin
  if Assigned(FInfo) then
    FreeAndNil(FInfo);
  inherited;
end;

procedure TInformation.SetupDialog;
var
  panel: TPanel;
begin
  if Assigned(FInfo) then
    Exit;

  FInfo := TbdtForm.Create(Application);
  FInfo.AutoSize := True;
  FInfo.BorderWidth := 0;
  FInfo.PopupMode := pmExplicit;
  FInfo.Position := poScreenCenter;
  FInfo.BorderStyle := bsNone;
  FInfo.BorderIcons := [];

  panel := TPanel.Create(FInfo);
  panel.Parent := FInfo;
  panel.AutoSize := True;
  panel.BorderWidth := 8;
  panel.Left := 0;
  panel.Top := 0;
  panel.Visible := True;

  FLabel := TLabel.Create(FInfo);
  FLabel.Parent := panel;
  FLabel.AutoSize := True;
  FLabel.Left := 0;
  FLabel.Top := 0;
  FLabel.Visible := True;
end;

procedure TInformation.ShowInfo(const Msg: string);
begin
  SetupDialog;
  FLabel.Caption := Msg;
  FInfo.Show;
  Application.ProcessMessages;
end;

function FindCmdLineSwitch(const cmdLine, Switch: string): Boolean;
var
  dummy: string;
begin
  Result := FindCmdLineSwitch(cmdLine, Switch, dummy);
end;

function FindCmdLineSwitch(const cmdLine, Switch: string; out Value: string): Boolean;

  function GetParamStr(p: PChar; var Param: string): PChar;
  var
    i, Len: Integer;
    Start, s: PChar;
  begin
    // U-OK
    while True do
    begin
      while (p[0] <> #0) and (p[0] <= ' ') do
        Inc(p);
      if (p[0] = '"') and (p[1] = '"') then
        Inc(p, 2)
      else
        Break;
    end;
    Len := 0;
    Start := p;
    while p[0] > ' ' do
    begin
      if p[0] = '"' then
      begin
        Inc(p);
        while (p[0] <> #0) and (p[0] <> '"') do
        begin
          Inc(Len);
          Inc(p);
        end;
        if p[0] <> #0 then
          Inc(p);
      end
      else
      begin
        Inc(Len);
        Inc(p);
      end;
    end;

    SetLength(Param, Len);

    p := Start;
    s := PChar(@Param[1]);
    i := 0;
    while p[0] > ' ' do
    begin
      if p[0] = '"' then
      begin
        Inc(p);
        while (p[0] <> #0) and (p[0] <> '"') do
        begin
          s[i] := p^;
          Inc(p);
          Inc(i);
        end;
        if p[0] <> #0 then
          Inc(p);
      end
      else
      begin
        s[i] := p^;
        Inc(p);
        Inc(i);
      end;
    end;

    Result := p;
  end;

  function ParamCount: Integer;
  var
    p: PChar;
    s: string;
  begin
    // U-OK
    Result := 0;
    p := GetParamStr(PChar(cmdLine), s);
    while True do
    begin
      p := GetParamStr(p, s);
      if s = '' then
        Break;
      Inc(Result);
    end;
  end;

type
  PCharArray = array [0 .. 0] of PChar;

  function ParamStr(index: Integer): string;
  var
    p: PChar;
    buffer: array [0 .. 260] of Char;
  begin
    Result := '';
    if index = 0 then
      SetString(Result, buffer, GetModuleFileName(0, buffer, Length(buffer)))
    else
    begin
      p := PChar(cmdLine);
      while True do
      begin
        p := GetParamStr(p, Result);
        if (index = 0) or (Result = '') then
          Break;
        Dec(index);
      end;
    end;
  end;

var
  i: Integer;
  s: string;
begin
  for i := 1 to ParamCount do
  begin
    s := ParamStr(i);
    if (SwitchChars = []) or CharInSet(s[1], SwitchChars) then
      if (AnsiCompareText(Copy(s, 2, Length(Switch)), Switch) = 0) then
      begin
        Value := Copy(s, Length(Switch) + 3, MaxInt);
        Result := True;
        Exit;
      end;
  end;
  Result := False;
end;

end.
