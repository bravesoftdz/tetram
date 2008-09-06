unit Procedures;

interface

uses
  SysUtils, Windows, Classes, Dialogs, ComCtrls, ExtCtrls, Controls, Forms, Graphics, CommonConst, JvUIB, jpeg, GraphicEx,
  StdCtrls, ComboCheck, JvUIBLib, Commun;

function AffMessage(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; Son: Boolean = False): Word;

function FormExistB(ClassType: TClass): Boolean;
function FormExistI(ClassType: TClass): Integer;

procedure MoveListItem(LV: TListView; Sens: Integer);

function DessineImage(Image: TImage; const Fichier: string): Boolean;

procedure LitOptions;
procedure EcritOptions;

procedure PrepareLV(Form: TForm);

function SupprimerTable(const Table: string): Boolean;
function SupprimerToutDans(const ChampSupp, Table: string; UseTransaction: TJvUIBTransaction = nil): Boolean; overload;
function SupprimerToutDans(const ChampSupp, Table, Reference: string; const Valeur: TGUID; UseTransaction: TJvUIBTransaction = nil): Boolean; overload;

type
  PRecRef = ^TRecRef;
  TRecRef = record
    ref: Integer;
  end;

function AjoutMvt(const ID_Emprunteur, RefObjet: TGUID; DateE: TDateTime; Pret: Boolean): Boolean;
procedure InitScrollBoxTableChamps(ScrollBox: TScrollBox; const Table: string; Ref: Integer; Editable: Boolean = False);
procedure VideListePointer(ListView: TListView);

function GetShellImage(const Path: string; Large, Open: Boolean): Integer;

type
  ILockWindow = interface
  end;
  TLockWindow = class(TInterfacedObject, ILockWindow)
  private
    FLocked: Boolean;
  public
    constructor Create(Form: TWinControl);
    destructor Destroy; override;
  end;

  IInformation = interface
    procedure ShowInfo(const Msg: ShortString);
  end;
  TInformation = class(TInterfacedObject, IInformation)
  private
    FInfo: TForm;
    FLabel: TLabel;
    procedure SetupDialog;
  public
    procedure ShowInfo(const Msg: ShortString);
    constructor Create;
    destructor Destroy; override;
  end;

function GetCouvertureStream(isParaBD: Boolean; const ID_Couverture: TGUID; Hauteur, Largeur: Integer; AntiAliasing: Boolean; Cadre: Boolean = False; Effet3D: Integer = 0): TStream; overload;
function GetCouvertureStream(const Fichier: string; Hauteur, Largeur: Integer; AntiAliasing: Boolean; Cadre: Boolean = False; Effet3D: Integer = 0): TStream; overload;
procedure LoadCouverture(isParaBD: Boolean; const ID_Couverture: TGUID; Picture: TPicture);
function GetJPEGStream(const Fichier: string): TStream;
function SearchNewFileName(const Chemin, Fichier: string; Reserve: Boolean = True): string;

procedure LoadCombo(Categorie: Integer; Combo: TLightComboCheck);
procedure LoadStrings(Categorie: Integer; Strings: TStrings);

implementation

uses
  Divers, Textes, ShellAPI, ReadOnlyCheckBox,
  JvUIBase, MaskUtils, Mask, DM_Princ, IniFiles, Math, VirtualTrees, DbEditLabeled, ActnList,
  Types, UBdtForms;

function AffMessage(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; Son: Boolean = False): Word;
begin
  if Son then MessageBeep(MB_ICONERROR);
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
    if Screen.Forms[i].ClassType = ClassType then Inc(Result);
end;

function DessineImage(Image: TImage; const Fichier: string): Boolean;
var
  largeuraff, hauteuraff, largeurimg, hauteurimg: Integer;
  marge: Integer;
  hg: IHourGlass;
begin
  Result := False;
  Image.Picture := nil;
  if not FileExists(Fichier) then Exit;
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

  function LitStr(Table: TJvUIBQuery; const Champ, Defaut: string): string;
  begin
    with Table do
    begin
      Params.AsString[0] := Champ;
      Open;
      if not Eof then
        Result := Fields.AsString[0]
      else
        Result := Defaut;
    end;
  end;

var
  op: TJvUIBQuery;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  op := TJvUIBQuery.Create(nil);
  with op do
  try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT FIRST 1 Valeur FROM OPTIONS WHERE NOM_OPTION = ? ORDER BY DM_OPTIONS DESC';
    Utilisateur.Options.SymboleMonnetaire := LitStr(op, 'SymboleM', CurrencyString);
    FormatMonnaie := IIf(CurrencyFormat in [0, 2], Utilisateur.Options.SymboleMonnetaire + IIf(CurrencyFormat = 2, ' ', ''), '') + FormatMonnaieCourt + IIf(CurrencyFormat in [1, 3], IIf(CurrencyFormat = 3, ' ', '') + Utilisateur.Options.SymboleMonnetaire, '');
    RepImages := LitStr(op, 'RepImages', RepImages);
  finally
    Transaction.Free;
    Free;
  end;
  with TIniFile.Create(FichierIni) do
  try
    Utilisateur.Options.ModeDemarrage := ReadBool('DIVERS', 'ModeDemarrage', True);
    Utilisateur.Options.FicheAlbumWithCouverture := ReadBool('DIVERS', 'FicheWithCouverture', True);
    Utilisateur.Options.FicheParaBDWithImage := ReadBool('DIVERS', 'ParaBDWithImage', True);
    Utilisateur.Options.Images := ReadBool('DIVERS', 'Images', True);
    Utilisateur.Options.AntiAliasing := ReadBool('DIVERS', 'AntiAliasing', True);
    Utilisateur.Options.ImagesStockees := ReadBool('ModeEdition', 'ImagesStockees', False);
    Utilisateur.Options.FormatTitreAlbum := ReadInteger('DIVERS', 'FormatTitreAlbum', 0);
    Utilisateur.Options.AvertirPret := ReadBool('DIVERS', 'AvertirPret', False);
    Utilisateur.Options.GrandesIconesMenus := ReadBool('DIVERS', 'GrandesIconesMenus', True);
    Utilisateur.Options.GrandesIconesBarre := ReadBool('DIVERS', 'GrandesIconesBarre', True);
    Utilisateur.Options.VerifMAJDelai := ReadInteger('Divers', 'VerifMAJDelai', 4);
    Utilisateur.Options.SerieObligatoireAlbums := ReadBool('DIVERS', 'SerieObligatoireAlbums', False);
    Utilisateur.Options.SerieObligatoireParaBD := ReadBool('DIVERS', 'SerieObligatoireParaBD', False);
    Utilisateur.Options.RepertoireScripts := IncludeTrailingPathDelimiter(ReadString('DIVERS', 'Scripts', IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'scripts'));

    Utilisateur.Options.SiteWeb.Adresse := ReadString('WWW', 'Adresse', '');
    Utilisateur.Options.SiteWeb.Cle := ReadString('WWW', 'AuthKey', '');
    Utilisateur.Options.SiteWeb.Modele := ReadString('WWW', 'Modele', 'Site par défaut');
    Utilisateur.Options.SiteWeb.MySQLServeur := ReadString('WWW', 'MySQLServeur', 'localhost');
    Utilisateur.Options.SiteWeb.MySQLLogin := ReadString('WWW', 'MySQLLogin', '');
    Utilisateur.Options.SiteWeb.MySQLPassword := ReadString('WWW', 'MySQLPassword', '');
    Utilisateur.Options.SiteWeb.MySQLBDD := ReadString('WWW', 'MySQLBDD', Utilisateur.Options.SiteWeb.MySQLLogin);
    Utilisateur.Options.SiteWeb.MySQLPrefix := ReadString('WWW', 'MySQLPrefix', 'bdt');
    Utilisateur.Options.SiteWeb.BddVersion := ReadString('WWW', 'BddVersion', '');
    Utilisateur.Options.SiteWeb.Paquets := ReadInteger('WWW', 'Paquets', 4096);
  finally
    Free;
  end;
end;

procedure EcritOptions;

  procedure Sauve(Table: TJvUIBQuery; const Champ: string; Valeur: Currency); overload;
  begin
    with Table do
    begin
      SQL.Text := 'UPDATE OR INSERT INTO OPTIONS (Nom_Option, Valeur) VALUES (:Nom_Option, :Valeur) MATCHING (Nom_Option)';
      Params.ByNameAsString['Nom_Option'] := Champ;
      Params.ByNameAsCurrency['Valeur'] := Valeur;
      ExecSQL;
    end;
  end;

  procedure Sauve(Table: TJvUIBQuery; const Champ, Valeur: string); overload;
  begin
    with Table do
    begin
      SQL.Text := 'UPDATE OR INSERT INTO OPTIONS (Nom_Option, Valeur) VALUES (:Nom_Option, :Valeur) MATCHING (Nom_Option)';
      Params.ByNameAsString['Nom_Option'] := Champ;
      Params.ByNameAsString['Valeur'] := Valeur;
      ExecSQL;
    end;
  end;

var
  op: TJvUIBQuery;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  op := TJvUIBQuery.Create(nil);
  with op do
  try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    Sauve(op, 'SymboleM', Utilisateur.Options.SymboleMonnetaire);
    Sauve(op, 'RepImages', RepImages);
    Transaction.Commit;
  finally
    Transaction.Free;
    Free;
  end;
  with TIniFile.Create(FichierIni) do
  try
    WriteBool('DIVERS', 'ModeDemarrage', Utilisateur.Options.ModeDemarrage);
    WriteBool('DIVERS', 'Images', Utilisateur.Options.Images);
    WriteBool('DIVERS', 'FicheWithCouverture', Utilisateur.Options.FicheAlbumWithCouverture);
    WriteBool('DIVERS', 'ParaBDWithImage', Utilisateur.Options.FicheParaBDWithImage);
    WriteBool('DIVERS', 'AntiAliasing', Utilisateur.Options.AntiAliasing);
    WriteBool('DIVERS', 'AvertirPret', Utilisateur.Options.AvertirPret);
    WriteBool('DIVERS', 'GrandesIconesMenus', Utilisateur.Options.GrandesIconesMenus);
    WriteBool('DIVERS', 'GrandesIconesBarre', Utilisateur.Options.GrandesIconesBarre);
    WriteBool('ModeEdition', 'ImagesStockees', Utilisateur.Options.ImagesStockees);
    WriteInteger('DIVERS', 'FormatTitreAlbum', Utilisateur.Options.FormatTitreAlbum);
    WriteInteger('Divers', 'VerifMAJDelai', Utilisateur.Options.VerifMAJDelai);
    WriteBool('DIVERS', 'SerieObligatoireAlbums', Utilisateur.Options.SerieObligatoireAlbums);
    WriteBool('DIVERS', 'SerieObligatoireParaBD', Utilisateur.Options.SerieObligatoireParaBD);

    WriteString('DIVERS', 'RepImages', ''); // efface la ligne

    WriteString('WWW', 'Adresse', Utilisateur.Options.SiteWeb.Adresse);
    WriteString('WWW', 'AuthKey', Utilisateur.Options.SiteWeb.Cle);
    WriteString('WWW', 'Modele', Utilisateur.Options.SiteWeb.Modele);
    WriteString('WWW', 'MySQLServeur', Utilisateur.Options.SiteWeb.MySQLServeur);
    WriteString('WWW', 'MySQLLogin', Utilisateur.Options.SiteWeb.MySQLLogin);
    WriteString('WWW', 'MySQLPassword', Utilisateur.Options.SiteWeb.MySQLPassword);
    WriteString('WWW', 'MySQLBDD', Utilisateur.Options.SiteWeb.MySQLBDD);
    WriteString('WWW', 'MySQLPrefix', Utilisateur.Options.SiteWeb.MySQLPrefix);
    WriteString('WWW', 'BddVersion', Utilisateur.Options.SiteWeb.BddVersion);
    WriteInteger('WWW', 'Paquets', Utilisateur.Options.SiteWeb.Paquets);
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
  if not Assigned(AListItem) then Exit;
  if not (AListItem.Index + Sens in [0..LV.Items.Count - 1]) then Exit;
  TmpAListItem := LV.Items[AListItem.Index + Sens];
  if not Assigned(TmpAListItem) then Exit;
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
  i, j, w: integer;
begin
  for i := 0 to Form.ComponentCount - 1 do
  try
    if Form.Components[i] is TListView then
      with Form.Components[i] as TListView do
        if Columns.Count = 1 then Columns[0].Width := ClientWidth - GetSystemMetrics(SM_CXVSCROLL);
    if Form.Components[i] is TVirtualStringTree then
      with (Form.Components[i] as TVirtualStringTree).Header do
        if Columns.Count > 0 then
        begin
          w := 0;
          for j := 0 to Pred(Columns.Count) do
            if j <> MainColumn then Inc(w, Columns[j].Width);
          Columns[MainColumn].Width := TreeView.ClientWidth - w - GetSystemMetrics(SM_CXVSCROLL);
        end;
  except
  end;
end;

function SupprimerTable(const Table: string): Boolean;
begin
  try
    with TJvUIBQuery.Create(nil) do
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

function SupprimerToutDans(const ChampSupp, Table: string; UseTransaction: TJvUIBTransaction = nil): Boolean;
begin
  Result := SupprimerToutDans(ChampSupp, Table, '', GUID_NULL, UseTransaction);
end;

function SupprimerToutDans(const ChampSupp, Table, Reference: string; const Valeur: TGUID; UseTransaction: TJvUIBTransaction = nil): Boolean;
begin
  try
    with TJvUIBQuery.Create(nil) do
    try
      if Assigned(UseTransaction) then
        Transaction := UseTransaction
      else
        Transaction := GetTransaction(DMPrinc.UIBDataBase);

      if ChampSupp <> '' then
        SQL.Add(Format('UPDATE %s set %s = True', [Table, ChampSupp]))
      else
        SQL.Add(Format('DELETE FROM %s', [Table]));

      if Reference <> '' then SQL.Add(Format('WHERE %s = ''%s''', [Reference, GUIDToString(Valeur)]));
      ExecSQL;
      Transaction.Commit;
      Result := True;
    finally
      if not Assigned(UseTransaction) then Transaction.Free;
      Free;
    end;
  except
    Result := False;
  end;
end;

const
  ErrorSaveMvt = 'Impossible d''enregistrer le mouvement !';

function AjoutMvt(const ID_Emprunteur, RefObjet: TGUID; DateE: TDateTime; Pret: Boolean): Boolean;
begin
  Result := False;
  try
    with TJvUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'Execute procedure PROC_AJOUTMVT(:ID_Edition, :ID_Emprunteur, :DateEmprunt, :Pret)';

      Params.AsString[0] := GUIDToString(RefObjet);
      Params.AsString[1] := GUIDToString(ID_Emprunteur);
      Params.AsDateTime[2] := DateE;
      Params.AsInteger[3] := Iif(Pret, 1, 0);
      ExecSQL;
      Transaction.Commit;
    finally
      Transaction.Free;
      Free;
    end;
    Result := True;
  except
    AffMessage(ErrorSaveMvt + #13#10 + Exception(ExceptObject).Message, mtWarning, [mbOk], True);
  end;
end;

procedure VideListePointer(ListView: TListView);
var
  i: Integer;
  p: pointer;
begin
  try
    for i := 0 to ListView.Items.Count - 1 do
    begin
      p := ListView.Items[i].Data;
      Dispose(p);
    end;
  finally
    ListView.Items.Clear;
  end;
end;

procedure InitScrollBoxTableChamps(ScrollBox: TScrollBox; const Table: string; Ref: Integer; Editable: Boolean = False);
var
  t: Integer;
  c: TComponent;
  l: TLabel;
  s: string;
  Champs, Desc: TJvUIBQuery;
  Champ: Integer;
  LockUpdate: ILockWindow;
  TypeChamp: TUIBFieldType;
begin
  LockUpdate := TLockWindow.Create(ScrollBox);
  for t := ScrollBox.ControlCount - 1 downto 0 do
    ScrollBox.Controls[t].Free;
  t := 4;
  Desc := TJvUIBQuery.Create(nil);
  Champs := TJvUIBQuery.Create(nil);
  try
    with Desc do
    begin
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'SELECT Champ, TEXTECHAMP FROM description_typesupport WHERE Upper(TableChamps) = ? ORDER BY ordrechamp';
      Params.AsString[0] := UpperCase(Table);
      Open;
    end;
    if not Desc.Eof then
    begin
      with Champs do
      begin
        Transaction := Desc.Transaction;
        SQL.Text := 'SELECT * FROM ' + Table + ' WHERE RefSupport = ?';
        Params.AsInteger[0] := Ref;
        FetchBlobs := True;
        Open;
      end;
      with Desc do
      begin
        while not Eof do
        begin
          try
            Champ := Champs.Fields.GetFieldIndex(Fields.ByNameAsString['Champ']);
          except
            Champ := -1;
          end;
          if Champ <> -1 then
          begin
            TypeChamp := Fields.FieldType[Champ];
            case TypeChamp of
              uftChar, uftVarchar, uftInteger, uftFloat:
                begin
                  l := TLabel.Create(ScrollBox.Owner);
                  with l do
                  begin
                    Top := t;
                    Parent := ScrollBox;
                    Caption := Fields.ByNameAsString['TEXTECHAMP'] + ' :';
                    Left := 4;
                    Inc(t, Height);
                    Name := 'Compo' + IntToStr(ScrollBox.Owner.ComponentCount);
                  end;
                  if Editable then
                    c := TEditLabeled.Create(ScrollBox.Owner)
                  else
                    c := TEdit.Create(ScrollBox.Owner);
                  with TEdit(c) do
                  begin
                    Anchors := [akLeft, akTop, akRight];
                    BevelKind := bkTile;
                    BorderStyle := bsNone;
                    Top := t;
                    Parent := ScrollBox;
                    Left := 4;
                    Width := ScrollBox.Width - 12 - GetSystemMetrics(SM_CXVSCROLL);
                    Inc(t, Height);
                    Name := Champs.Fields.SqlName[Champ];
                    if not (Champs.Eof or Champs.Fields.IsNull[Champ]) then
                      Text := Champs.Fields.AsString[Champ]
                    else
                      Text := '';
                    if Editable then
                    begin
                      with TEditLabeled(c) do
                      begin
                        LinkControls.Add(l);
                        case TypeChamp of
                          uftChar, uftVarchar: TypeDonnee := tdChaine;
                          uftInteger: TypeDonnee := tdEntierSigne;
                          uftFloat: TypeDonnee := tdNumericSigne;
                        end;
                      end;
                    end
                    else
                      ReadOnly := True;
                  end;
                end;
              uftSmallInt:
                begin
                  if Editable then
                    c := TCheckBoxLabeled.Create(ScrollBox.Owner)
                  else
                    c := TReadOnlyCheckBox.Create(ScrollBox.Owner);
                  with TCheckBox(c) do
                  begin
                    Anchors := [akLeft, akTop, akRight];
                    Top := t;
                    Parent := ScrollBox;
                    Name := Champs.Fields.SqlName[Champ];
                    s := Fields.ByNameAsString['TEXTECHAMP'];
                    Caption := s;
                    Left := 4;
                    Width := TForm(ScrollBox.Owner).Canvas.TextWidth(s) + 32;
                    Inc(t, Height + 4);
                    Checked := not (Champs.Eof or Champs.Fields.IsNull[Champ]) and Champs.Fields.AsBoolean[Champ];
                    if Editable then
                    begin
                      with TCheckBoxLabeled(c) do
                      begin
                      end;
                    end;
                  end;
                end;
              uftBlob:
                begin
                  l := TLabel.Create(ScrollBox.Owner);
                  with l do
                  begin
                    Top := t;
                    Parent := ScrollBox;
                    Caption := Fields.ByNameAsString['TEXTECHAMP'] + ' :';
                    Left := 4;
                    Inc(t, Height);
                    Name := 'Compo' + IntToStr(ScrollBox.Owner.ComponentCount);
                  end;
                  if Editable then
                    c := TMemoLabeled.Create(ScrollBox.Owner)
                  else
                    c := TMemo.Create(ScrollBox.Owner);
                  with TMemo(c) do
                  begin
                    Anchors := [akLeft, akTop, akRight];
                    BevelKind := bkTile;
                    BorderStyle := bsNone;
                    Top := t;
                    Parent := ScrollBox;
                    Left := 4;
                    Width := ScrollBox.Width - 12 - GetSystemMetrics(SM_CXVSCROLL);
                    ClientHeight := 4 * TForm(ScrollBox.Owner).Canvas.TextHeight('A');
                    Inc(t, Height + 4);
                    Name := Champs.Fields.SqlName[Champ];
                    if not (Champs.Eof or Champs.Fields.IsNull[Champ]) then
                      Lines.Text := Champs.Fields.AsString[Champ]
                    else
                      Lines.Text := '';
                    WordWrap := True;
                    if Editable then
                    begin
                      with TMemoLabeled(c) do
                      begin
                        LinkControls.Add(l);
                      end;
                    end
                    else
                    begin
                      ReadOnly := True;
                      ScrollBars := ssVertical;
                    end;
                  end;
                end;
              uftDate, uftTime, uftTimestamp:
                begin
                  l := TLabel.Create(ScrollBox.Owner);
                  with l do
                  begin
                    Top := t;
                    Parent := ScrollBox;
                    Caption := Fields.ByNameAsString['TEXTECHAMP'] + ' :';
                    Left := 4;
                    Inc(t, Height);
                    Name := 'Compo' + IntToStr(ScrollBox.Owner.ComponentCount);
                  end;
                  if Editable then
                    c := TEditLabeled.Create(ScrollBox.Owner)
                  else
                    c := TEdit.Create(ScrollBox.Owner);
                  with TEdit(c) do
                  begin
                    Anchors := [akLeft, akTop, akRight];
                    BevelKind := bkTile;
                    BorderStyle := bsNone;
                    Top := t;
                    Parent := ScrollBox;
                    Left := 4;
                    Width := ScrollBox.Width - 12 - GetSystemMetrics(SM_CXVSCROLL);
                    Inc(t, Height + 4);
                    Name := Champs.Fields.SqlName[Champ];
                    if not (Champs.Eof or Champs.Fields.IsNull[Champ]) then
                      Text := Champs.Fields.AsString[Champ]
                    else
                      Text := '';
                    if Editable then
                    begin
                      with TEditLabeled(c) do
                      begin
                        LinkControls.Add(l);
                        case TypeChamp of
                          uftDate: TypeDonnee := tdDate;
                          uftTime: TypeDonnee := tdHeure;
                          uftTimestamp: TypeDonnee := tdDateHeure;
                        end;
                      end;
                    end
                    else
                      TEdit(c).ReadOnly := True;
                  end;
                end;
            end; // case Champ.Datatype
          end; // if Assigned(Champ)
          Next;
        end; // while not eof
      end; // with Desc
    end;
  finally
    Desc.Transaction.Free;
    Desc.Free;
    Champs.Free;
  end;
end;

function GetShellImage(const Path: string; Large, Open: Boolean): Integer;
var
  FileInfo: TSHFileInfo;
  Flags: Integer;
begin
  FillChar(FileInfo, SizeOf(FileInfo), #0);
  Flags := SHGFI_SYSICONINDEX or SHGFI_ICON;
  if Open then Flags := Flags or SHGFI_OPENICON;
  if Large then
    Flags := Flags or SHGFI_LARGEICON
  else
    Flags := Flags or SHGFI_SMALLICON;
  SHGetFileInfo(PChar(Path), 0, FileInfo, SizeOf(FileInfo), Flags);
  Result := FileInfo.iIcon;
end;

constructor TLockWindow.Create(Form: TWinControl);
begin
  inherited Create;
  FLocked := LockWindowUpdate(Form.Handle);
end;

destructor TLockWindow.Destroy;
begin
  if FLocked then LockWindowUpdate(0);
  inherited;
end;

function ResizePicture(Image: TPicture; Hauteur, Largeur: Integer; AntiAliasing, Cadre: Boolean; Effet3D: Integer): TStream;
var
  NewLargeur, NewHauteur: Integer;
  Bmp: TBitmap;
  Trace: array of TPoint;
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
        BMP.Canvas.TextOut(Bmp.Width, Bmp.Height, '');

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
          SetLength(Trace, 6);
          Trace[0] := Point(0, NewHauteur);
          Trace[1] := Point(0 + Effet3D, Bmp.Height);
          Trace[2] := Point(Bmp.Width, Bmp.Height);
          Trace[3] := Point(Bmp.Width, 0 + Effet3D);
          Trace[4] := Point(NewLargeur, 0);
          Trace[5] := Point(NewLargeur, NewHauteur);
          Bmp.Canvas.Polygon(Trace);
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

function GetCouvertureStream(isParaBD: Boolean; const ID_Couverture: TGUID; Hauteur, Largeur: Integer; AntiAliasing: Boolean; Cadre: Boolean = False; Effet3D: Integer = 0): TStream;
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
  with TJvUIBQuery.Create(nil) do
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
        if Chemin = '' then Chemin := RepImages;
        SQL.Text := 'SELECT BlobContent FROM LOADBLOBFROMFILE(:Chemin, :Fichier);';
        Params.AsString[0] := Chemin;
        Params.AsString[1] := Fichier;
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
  begin
    with TStringList.Create do
    try
      Text := StringReplace(LowerCase(Mask), ';', #13#10, [rfReplaceAll]);
      Result := IndexOf('*' + Fichier) <> -1;
    finally
      Free;
    end;
  end;

var
  jImg: TJPEGImage;
  Img: TPicture;
begin
  if MatchesMask(LowerCase(ExtractFileExt(Fichier)), GraphicFileMask(TJPEGImage)) then
  begin
    Result := TFileStream.Create(Fichier, fmOpenRead or fmShareDenyWrite);
  end
  else
  begin
    Result := TMemoryStream.Create;
    img := TPicture.Create;
    jImg := TJPEGImage.Create;
    try
      img.LoadFromFile(Fichier);
      jImg.PixelFormat := jf24Bit;
      jImg.Assign(img.Graphic);
      jImg.CompressionQuality := 70;
      jImg.Compress;
      jImg.SaveToStream(Result);
    finally
      jImg.Free;
      img.Free;
    end;
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
  if Assigned(FInfo) then FreeAndNil(FInfo);
  inherited;
end;

procedure TInformation.SetupDialog;
var
  FPanel: TPanel;
begin
  if Assigned(FInfo) then Exit;
  FInfo := TbdtForm.Create(Application);
  with FInfo do
  begin
    AutoSize := True;
    BorderWidth := 0;
    FormStyle := fsStayOnTop;
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

procedure TInformation.ShowInfo(const Msg: ShortString);
begin
  SetupDialog;
  FLabel.Caption := Msg;
  FInfo.Show;
  Application.ProcessMessages;
end;

function SearchNewFileName(const Chemin, Fichier: string; Reserve: Boolean = True): string;
begin
  with TJvUIBQuery.Create(nil) do
  try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT * FROM SearchFileName(:Chemin, :Fichier, :Reserve)';
    Params.AsString[0] := IncludeTrailingPathDelimiter(Chemin);
    Params.AsString[1] := Fichier;
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
  with TJvUIBQuery.Create(nil) do
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
  with TJvUIBQuery.Create(nil) do
  try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT REF, LIBELLE, DEFAUT FROM LISTES WHERE CATEGORIE = :Categorie ORDER BY ORDRE';

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
        if Fields.AsBoolean[2] then Combo.DefaultValueChecked := Valeur;
        HasNULL := Valeur = -1;
      end;
      Next;
    end;
    if not HasNULL then
      with Combo.Items.Add do
      begin
        Caption := '';
        Valeur := -1;
        Index := 0;
      end;

    Combo.Value := Combo.DefaultValueChecked;
  finally
    Transaction.Free;
    Free;
  end;
end;

end.

