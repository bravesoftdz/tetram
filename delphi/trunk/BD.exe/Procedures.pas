unit Procedures;

interface

uses SysUtils, Windows, Classes, Dialogs, ComCtrls, ExtCtrls, Controls, Forms, Graphics, CommonConst, UIB, jpeg, GraphicEx, StdCtrls, ComboCheck,
  UIBLib, Commun;

function AffMessage(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; Son: Boolean = False): Word;

function FormExistB(ClassType: TClass): Boolean;
function FormExistI(ClassType: TClass): Integer;

procedure MoveListItem(LV: TListView; Sens: Integer);

function DessineImage(Image: TImage; const Fichier: string): Boolean;

procedure LitOptions;
procedure EcritOptions;

procedure PrepareLV(Form: TForm);

function SupprimerTable(const Table: string): Boolean;
function SupprimerToutDans(const ChampSupp, Table: string; UseTransaction: TUIBTransaction = nil): Boolean; overload;
function SupprimerToutDans(const ChampSupp, Table, Reference: string; const Valeur: TGUID; UseTransaction: TUIBTransaction = nil): Boolean; overload;

type
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

function GetCouvertureStream(isParaBD: Boolean; const ID_Couverture: TGUID; Hauteur, Largeur: Integer; AntiAliasing: Boolean; Cadre: Boolean = False;
  Effet3D: Integer = 0): TStream; overload;
function GetCouvertureStream(const Fichier: string; Hauteur, Largeur: Integer; AntiAliasing: Boolean; Cadre: Boolean = False; Effet3D: Integer = 0)
  : TStream; overload;
procedure LoadCouverture(isParaBD: Boolean; const ID_Couverture: TGUID; Picture: TPicture);
function GetJPEGStream(const Fichier: string): TStream;
function SearchNewFileName(const Chemin, Fichier: string; Reserve: Boolean = True): string;

procedure LoadCombo(Categorie: Integer; Combo: TLightComboCheck);
procedure LoadStrings(Categorie: Integer; Strings: TStrings);

function FindCmdLineSwitch(const cmdLine, Switch: string): Boolean; overload;
function FindCmdLineSwitch(const cmdLine, Switch: string; out Value: string): Boolean; overload;

implementation

uses Divers, Textes, ShellAPI, LabeledCheckBox, MaskUtils, Mask, UdmPrinc, IniFiles, Math, VirtualTrees, EditLabeled, ActnList, Types, UBdtForms,
  StrUtils;

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
begin
  Result := False;
  Image.Picture := nil;
  if not FileExists(Fichier) then
    Exit;
  hg := THourGlass.Create;
  with TPicture.Create do
    try
      LoadFromFile(Fichier);
      hauteurimg := Height;
      largeurimg := Width;
      largeuraff := Image.Width;
      hauteuraff := Image.Height;
      if (hauteurimg >= hauteuraff) and (largeurimg >= largeuraff) then
        if (hauteurimg / largeurimg) > (hauteuraff / largeuraff) then
        begin
          largeuraff := Windows.MulDiv(hauteuraff, largeurimg, hauteurimg);
          marge := (Image.Width - largeuraff) div 2;
          Image.Canvas.StretchDraw(Rect(marge, 0, marge + largeuraff, hauteuraff), Graphic);
        end
        else
        begin
          hauteuraff := Windows.MulDiv(largeuraff, hauteurimg, largeurimg);
          marge := (Image.Height - hauteuraff) div 2;
          Image.Canvas.StretchDraw(Rect(0, marge, largeuraff, marge + hauteuraff), Graphic);
        end
      else
        Image.Canvas.Draw((largeuraff - largeurimg) div 2, (hauteuraff - hauteurimg) div 2, Graphic);
      Result := True;
    finally
      Free;
    end;
end;

procedure LitOptions;

  function LitStr(Table: TUIBQuery; const Champ, Defaut: string): string;
  begin
    with Table do
    begin
      Params.AsString[0] := Copy(Champ, 1, Params.MaxStrLen[0]);
      Open;
      if not Eof then
        Result := Fields.AsUnicodeString[0]
      else
        Result := Defaut;
    end;
  end;

var
  op: TUIBQuery;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  op := TUIBQuery.Create(nil);
  with op do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'SELECT FIRST 1 Valeur FROM OPTIONS WHERE NOM_OPTION = ? ORDER BY DM_OPTIONS DESC';
      Prepare(True);
      TGlobalVar.Utilisateur.Options.SymboleMonnetaire := LitStr(op, 'SymboleM', FormatSettings.CurrencyString);
      FormatMonnaie := IfThen(FormatSettings.CurrencyFormat in [0, 2], TGlobalVar.Utilisateur.Options.SymboleMonnetaire +
        IfThen(FormatSettings.CurrencyFormat = 2, ' ', ''), '') + FormatMonnaieCourt + IfThen(FormatSettings.CurrencyFormat in [1, 3],
        IfThen(FormatSettings.CurrencyFormat = 3, ' ', '') + TGlobalVar.Utilisateur.Options.SymboleMonnetaire, '');
      RepImages := LitStr(op, 'RepImages', RepImages);
    finally
      Transaction.Free;
      Free;
    end;
  with TIniFile.Create(FichierIni) do
    try
      TGlobalVar.Utilisateur.Options.ModeDemarrage := ReadBool('DIVERS', 'ModeDemarrage', True);
      TGlobalVar.Utilisateur.Options.FicheAlbumWithCouverture := ReadBool('DIVERS', 'FicheWithCouverture', True);
      TGlobalVar.Utilisateur.Options.FicheParaBDWithImage := ReadBool('DIVERS', 'ParaBDWithImage', True);
      TGlobalVar.Utilisateur.Options.Images := ReadBool('DIVERS', 'Images', True);
      TGlobalVar.Utilisateur.Options.AntiAliasing := ReadBool('DIVERS', 'AntiAliasing', True);
      TGlobalVar.Utilisateur.Options.ImagesStockees := ReadBool('ModeEdition', 'ImagesStockees', False);
      TGlobalVar.Utilisateur.Options.FormatTitreAlbum := ReadInteger('DIVERS', 'FormatTitreAlbum', 0);
      TGlobalVar.Utilisateur.Options.AvertirPret := ReadBool('DIVERS', 'AvertirPret', False);
      TGlobalVar.Utilisateur.Options.GrandesIconesMenus := ReadBool('DIVERS', 'GrandesIconesMenus', True);
      TGlobalVar.Utilisateur.Options.GrandesIconesBarre := ReadBool('DIVERS', 'GrandesIconesBarre', True);
      TGlobalVar.Utilisateur.Options.VerifMAJDelai := ReadInteger('Divers', 'VerifMAJDelai', 4);
      TGlobalVar.Utilisateur.Options.SerieObligatoireAlbums := ReadBool('DIVERS', 'SerieObligatoireAlbums', False);
      TGlobalVar.Utilisateur.Options.SerieObligatoireParaBD := ReadBool('DIVERS', 'SerieObligatoireParaBD', False);
      TGlobalVar.Utilisateur.Options.AfficheNoteListes := ReadBool('DIVERS', 'AfficheNoteListes', True);

      TGlobalVar.Utilisateur.Options.SiteWeb.Adresse := ReadString('WWW', 'Adresse', '');
      TGlobalVar.Utilisateur.Options.SiteWeb.Cle := ReadString('WWW', 'AuthKey', '');
      TGlobalVar.Utilisateur.Options.SiteWeb.Modele := ReadString('WWW', 'Modele', 'Site par défaut');
      TGlobalVar.Utilisateur.Options.SiteWeb.MySQLServeur := ReadString('WWW', 'MySQLServeur', 'localhost');
      TGlobalVar.Utilisateur.Options.SiteWeb.MySQLLogin := ReadString('WWW', 'MySQLLogin', '');
      TGlobalVar.Utilisateur.Options.SiteWeb.MySQLPassword := ReadString('WWW', 'MySQLPassword', '');
      TGlobalVar.Utilisateur.Options.SiteWeb.MySQLBDD := ReadString('WWW', 'MySQLBDD', TGlobalVar.Utilisateur.Options.SiteWeb.MySQLLogin);
      TGlobalVar.Utilisateur.Options.SiteWeb.MySQLPrefix := ReadString('WWW', 'MySQLPrefix', 'bdt');
      TGlobalVar.Utilisateur.Options.SiteWeb.BddVersion := ReadString('WWW', 'BddVersion', '');
      TGlobalVar.Utilisateur.Options.SiteWeb.Paquets := ReadInteger('WWW', 'Paquets', 4096);
    finally
      Free;
    end;
end;

procedure EcritOptions;

  procedure Sauve(Table: TUIBQuery; const Champ: string; Valeur: Currency); overload;
  begin
    with Table do
    begin
      SQL.Text := 'UPDATE OR INSERT INTO OPTIONS (Nom_Option, Valeur) VALUES (:Nom_Option, :Valeur) MATCHING (Nom_Option)';
      Prepare(True);
      Params.AsString[1] := Copy(Champ, 1, Params.MaxStrLen[0]);
      Params.AsCurrency[1] := Valeur;
      ExecSQL;
    end;
  end;

  procedure Sauve(Table: TUIBQuery; const Champ, Valeur: string); overload;
  begin
    with Table do
    begin
      SQL.Text := 'UPDATE OR INSERT INTO OPTIONS (Nom_Option, Valeur) VALUES (:Nom_Option, :Valeur) MATCHING (Nom_Option)';
      Prepare(True);
      Params.AsString[0] := Copy(Champ, 1, Params.MaxStrLen[0]);
      Params.AsString[1] := Copy(Valeur, 1, Params.MaxStrLen[1]);
      ExecSQL;
    end;
  end;

var
  op: TUIBQuery;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  op := TUIBQuery.Create(nil);
  with op do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      Sauve(op, 'SymboleM', TGlobalVar.Utilisateur.Options.SymboleMonnetaire);
      Sauve(op, 'RepImages', RepImages);
      Transaction.Commit;
    finally
      Transaction.Free;
      Free;
    end;
  with TIniFile.Create(FichierIni), TGlobalVar.Utilisateur.Options do
    try
      WriteBool('DIVERS', 'ModeDemarrage', ModeDemarrage);
      WriteBool('DIVERS', 'Images', Images);
      WriteBool('DIVERS', 'FicheWithCouverture', FicheAlbumWithCouverture);
      WriteBool('DIVERS', 'ParaBDWithImage', FicheParaBDWithImage);
      WriteBool('DIVERS', 'AntiAliasing', AntiAliasing);
      WriteBool('DIVERS', 'AvertirPret', AvertirPret);
      WriteBool('DIVERS', 'GrandesIconesMenus', GrandesIconesMenus);
      WriteBool('DIVERS', 'GrandesIconesBarre', GrandesIconesBarre);
      WriteBool('ModeEdition', 'ImagesStockees', ImagesStockees);
      WriteInteger('DIVERS', 'FormatTitreAlbum', FormatTitreAlbum);
      WriteInteger('Divers', 'VerifMAJDelai', VerifMAJDelai);
      WriteBool('DIVERS', 'SerieObligatoireAlbums', SerieObligatoireAlbums);
      WriteBool('DIVERS', 'SerieObligatoireParaBD', SerieObligatoireParaBD);
      WriteBool('DIVERS', 'AfficheNoteListes', AfficheNoteListes);

      WriteString('DIVERS', 'RepImages', ''); // efface la ligne

      WriteString('WWW', 'Adresse', SiteWeb.Adresse);
      WriteString('WWW', 'AuthKey', SiteWeb.Cle);
      WriteString('WWW', 'Modele', SiteWeb.Modele);
      WriteString('WWW', 'MySQLServeur', SiteWeb.MySQLServeur);
      WriteString('WWW', 'MySQLLogin', SiteWeb.MySQLLogin);
      WriteString('WWW', 'MySQLPassword', SiteWeb.MySQLPassword);
      WriteString('WWW', 'MySQLBDD', SiteWeb.MySQLBDD);
      WriteString('WWW', 'MySQLPrefix', SiteWeb.MySQLPrefix);
      WriteString('WWW', 'BddVersion', SiteWeb.BddVersion);
      WriteInteger('WWW', 'Paquets', SiteWeb.Paquets);
    finally
      Free;
    end;
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
begin
  for i := 0 to Form.ComponentCount - 1 do
    try
      if Form.Components[i] is TListView then
        with Form.Components[i] as TListView do
          if Columns.Count = 1 then
            Columns[0].Width := ClientWidth - GetSystemMetrics(SM_CXVSCROLL);
      if Form.Components[i] is TVirtualStringTree then
        with (Form.Components[i] as TVirtualStringTree).Header do
          if Columns.Count > 0 then
          begin
            w := 0;
            for j := 0 to Pred(Columns.Count) do
              if j <> MainColumn then
                Inc(w, Columns[j].Width);
            Columns[MainColumn].Width := TreeView.ClientWidth - w - GetSystemMetrics(SM_CXVSCROLL);
          end;
    except
    end;
end;

function SupprimerTable(const Table: string): Boolean;
begin
  try
    with TUIBQuery.Create(nil) do
      try
        Transaction := GetTransaction(DMPrinc.UIBDataBase);
        Transaction.Database.Connected := False; // fonctionne mais pas correct du tout!
        Transaction.Database.Connected := True;
        SQL.Text := 'DROP TABLE ' + Table;
        ExecSQL;
        Transaction.Commit;
        Result := True;
      finally
        Transaction.Free;
        Free;
      end;
  except
    Result := False;
  end;
end;

function SupprimerToutDans(const ChampSupp, Table: string; UseTransaction: TUIBTransaction = nil): Boolean;
begin
  Result := SupprimerToutDans(ChampSupp, Table, '', GUID_NULL, UseTransaction);
end;

function SupprimerToutDans(const ChampSupp, Table, Reference: string; const Valeur: TGUID; UseTransaction: TUIBTransaction = nil): Boolean;
begin
  try
    with TUIBQuery.Create(nil) do
      try
        if Assigned(UseTransaction) then
          Transaction := UseTransaction
        else
          Transaction := GetTransaction(DMPrinc.UIBDataBase);

        if ChampSupp <> '' then
          SQL.Add(Format('update %s set %s = True', [Table, ChampSupp]))
        else
          SQL.Add(Format('delete from %s', [Table]));

        if Reference <> '' then
          SQL.Add(Format('where %s = ''%s''', [Reference, GUIDToString(Valeur)]));
        ExecSQL;
        Transaction.Commit;
        Result := True;
      finally
        if not Assigned(UseTransaction) then
          Transaction.Free;
        Free;
      end;
  except
    Result := False;
  end;
end;

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
  // Trace: array of TPoint;
begin
  Result := TMemoryStream.Create;
  try
    if (Hauteur <> -1) or (Largeur <> -1) then
    begin
      if Hauteur = -1 then
      begin
        NewLargeur := Largeur;
        NewHauteur := Windows.MulDiv(NewLargeur, Image.Height, Image.Width);
      end
      else
      begin
        NewHauteur := Hauteur;
        NewLargeur := Windows.MulDiv(NewHauteur, Image.Width, Image.Height);
        if (Largeur <> -1) and (NewLargeur > Largeur) then
        begin
          NewLargeur := Largeur;
          NewHauteur := Windows.MulDiv(NewLargeur, Image.Height, Image.Width);
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
          Bmp.Assign(Image.Graphic);
          Stretch(NewLargeur, NewHauteur, sfBell, 0, Bmp);
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
          // SetLength(Trace, 6);
          // Trace[0] := Point(0, NewHauteur);
          // Trace[1] := Point(0 + Effet3D, Bmp.Height);
          // Trace[2] := Point(Bmp.Width, Bmp.Height);
          // Trace[3] := Point(Bmp.Width, 0 + Effet3D);
          // Trace[4] := Point(NewLargeur, 0);
          // Trace[5] := Point(NewLargeur, NewHauteur);
          // Bmp.Canvas.Polygon(Trace);

          for i := 0 to Effet3D do
          begin
            Bmp.Canvas.Pen.Color := ChangeLight(i, 0, Effet3D, clGray, clWhite);

            Bmp.Canvas.MoveTo(0 + i, NewHauteur + i);
            Bmp.Canvas.LineTo(NewLargeur + i, NewHauteur + i);
            Bmp.Canvas.LineTo(NewLargeur + i, 0 + i);
          end;
        end;

        with TJPEGImage.Create do
          try
            Assign(Bmp);
            PixelFormat := jf24Bit;
            CompressionQuality := 70;
            Compress;
            SaveToStream(Result);
          finally
            Free;
          end;
      finally
        Bmp.Free;
      end;
    end
    else
      Image.Graphic.SaveToStream(Result);

    Result.Position := 0;
  except
    FreeAndNil(Result);
  end;
end;

function GetCouvertureStream(const Fichier: string; Hauteur, Largeur: Integer; AntiAliasing: Boolean; Cadre: Boolean = False; Effet3D: Integer = 0): TStream;
var
  Couverture: TPicture;
  img: TJPEGImage;
  Stream: TStream;
begin
  Couverture := TPicture.Create;
  try
    Stream := GetJPEGStream(Fichier);
    img := TJPEGImage.Create;
    try
      Stream.Position := 0;
      img.LoadFromStream(Stream);
      Couverture.Assign(img);
    finally
      img.Free;
      FreeAndNil(Stream);
    end;
    Result := ResizePicture(Couverture, Hauteur, Largeur, AntiAliasing, Cadre, Effet3D);
  finally
    Couverture.Free;
  end;
end;

function GetCouvertureStream(isParaBD: Boolean; const ID_Couverture: TGUID; Hauteur, Largeur: Integer; AntiAliasing: Boolean; Cadre: Boolean = False;
  Effet3D: Integer = 0): TStream;
var
  Couverture: TPicture;
begin
  Couverture := TPicture.Create;
  try
    LoadCouverture(isParaBD, ID_Couverture, Couverture);
    Result := ResizePicture(Couverture, Hauteur, Largeur, AntiAliasing, Cadre, Effet3D);
  finally
    Couverture.Free;
  end;
end;

procedure LoadCouverture(isParaBD: Boolean; const ID_Couverture: TGUID; Picture: TPicture);
var
  ms: TMemoryStream;
  img: TJPEGImage;
  Fichier, Chemin: string;
begin
  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      if isParaBD then
        SQL.Text := 'SELECT IMAGEPARABD, STOCKAGEPARABD, FichierParaBD FROM ParaBD WHERE ID_ParaBD = ?'
      else
        SQL.Text := 'SELECT IMAGECOUVERTURE, STOCKAGECOUVERTURE, FichierCouverture FROM Couvertures WHERE ID_Couverture = ?';
      Params.AsString[0] := GUIDToString(ID_Couverture);
      FetchBlobs := True;
      Open;
      if Eof or (Fields.IsNull[0] and Fields.IsNull[2]) then
        Picture.Assign(nil)
      else
      begin
        if not Fields.AsBoolean[1] then
        begin
          Fichier := ExtractFileName(Fields.AsString[2]);
          Chemin := ExtractFilePath(Fields.AsString[2]);
          if Chemin = '' then
            Chemin := RepImages;
          SQL.Text := 'SELECT BlobContent FROM LOADBLOBFROMFILE(:Chemin, :Fichier);';
          Prepare(True);
          Params.AsString[0] := Copy(Chemin, 1, Params.MaxStrLen[0]);
          Params.AsString[1] := Copy(Fichier, 1, Params.MaxStrLen[1]);
          Open;
          if Eof then
          begin
            Picture.Assign(nil);
            Exit;
          end;
        end;

        ms := TMemoryStream.Create;
        img := TJPEGImage.Create;
        try
          ReadBlob(0, ms);
          ms.Position := 0;
          img.LoadFromStream(ms);
          Picture.Assign(img);
        finally
          ms.Free;
          img.Free;
        end;
      end;
    finally
      Transaction.Free;
      Free;
    end;
end;

function GetJPEGStream(const Fichier: string): TStream;

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

var
  jImg: TJPEGImage;
  img: TPicture;
  graphClass: TGraphicClass;
  graph: TGraphic;
  f: TFileStream;
  buffer: array [0 .. 2] of Byte;
begin
  f := TFileStream.Create(Fichier, fmOpenRead or fmShareDenyWrite);

  f.Position := 0;
  f.ReadBuffer(buffer, 3);
  f.Position := 0;

  if (buffer[0] = $FF) and (buffer[1] = $D8) and (buffer[2] = $FF) then
  begin
    Result := f;
    Exit;
  end
  else
    graphClass := FileFormatList.GraphicFromContent(f);

  Result := TMemoryStream.Create;
  img := nil;
  graph := nil;
  jImg := TJPEGImage.Create;
  try
    if Assigned(graphClass) then
    begin
      graph := graphClass.Create;
      graph.LoadFromStream(f);
    end
    else
    begin
      img := TPicture.Create;
      img.LoadFromFile(Fichier);
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
  FPanel: TPanel;
begin
  if Assigned(FInfo) then
    Exit;
  FInfo := TbdtForm.Create(Application);
  with FInfo do
  begin
    AutoSize := True;
    BorderWidth := 0;
    PopupMode := pmExplicit;
    Position := poScreenCenter;
    BorderStyle := bsNone;
    BorderIcons := [];
  end;
  FPanel := TPanel.Create(FInfo);
  with FPanel do
  begin
    Parent := FInfo;
    AutoSize := True;
    BorderWidth := 8;
    Left := 0;
    Top := 0;
    Visible := True;
  end;
  FLabel := TLabel.Create(FInfo);
  with FLabel do
  begin
    Parent := FPanel;
    AutoSize := True;
    Left := 0;
    Top := 0;
    Visible := True;
  end;
end;

procedure TInformation.ShowInfo(const Msg: string);
begin
  SetupDialog;
  FLabel.Caption := Msg;
  FInfo.Show;
  Application.ProcessMessages;
end;

function SearchNewFileName(const Chemin, Fichier: string; Reserve: Boolean = True): string;
begin
  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'SELECT * FROM SearchFileName(:Chemin, :Fichier, :Reserve)';
      Prepare(True);
      Params.AsString[0] := Copy(IncludeTrailingPathDelimiter(Chemin), 1, Params.MaxStrLen[0]);
      Params.AsString[1] := Copy(Fichier, 1, Params.MaxStrLen[1]);
      Params.AsBoolean[2] := Reserve;
      Open;
      Result := ExtractFileName(Fields.AsString[0]);
    finally
      Transaction.Free;
      Free;
    end;
end;

procedure LoadStrings(Categorie: Integer; Strings: TStrings);
begin
  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'SELECT REF, LIBELLE, DEFAUT FROM LISTES WHERE CATEGORIE = :Categorie ORDER BY ORDRE';

      Params.AsInteger[0] := Categorie;
      Open;
      Strings.Clear;
      while not Eof do
      begin
        Strings.Add(Fields.AsString[0] + '=' + Fields.AsString[1]);
        Next;
      end;
    finally
      Transaction.Free;
      Free;
    end;
end;

procedure LoadCombo(Categorie: Integer; Combo: TLightComboCheck);
var
  HasNULL: Boolean;
begin
  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'select ref, libelle, defaut from listes where categorie = :categorie order by ordre';

      HasNULL := False;

      Params.AsInteger[0] := Categorie;
      Open;
      Combo.Items.Clear;
      Combo.DefaultValueChecked := -1;
      while not Eof do
      begin
        with Combo.Items.Add do
        begin
          Caption := Fields.AsString[1];
          Valeur := Fields.AsInteger[0];
          if Fields.AsBoolean[2] then
            Combo.DefaultValueChecked := Valeur;
          HasNULL := Valeur = -1;
        end;
        Next;
      end;
      if not HasNULL then
        with Combo.Items.Add do
        begin
          Caption := ' ';
          Valeur := -1;
          index := 0;
        end;

      Combo.Value := Combo.DefaultValueChecked;
    finally
      Transaction.Free;
      Free;
    end;
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
    s := PChar(Param[1]);
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
