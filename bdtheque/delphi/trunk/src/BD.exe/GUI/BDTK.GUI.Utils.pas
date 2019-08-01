unit BDTK.GUI.Utils;

interface

uses SysUtils, Windows, StdCtrls, Forms, Controls, ExtCtrls, BD.Common, Graphics, StrUtils, Dialogs, SyncObjs,
  uib, BD.Utils.StrUtils, System.Classes, ComboCheck, BD.Entities.Full, BD.Entities.Types,
  BD.DB.Connection;

type
  IImpressionApercu = interface
    ['{10227EB6-D5D0-4541-AAD6-D1A62E9308C9}']
    procedure ImpressionExecute(Sender: TObject);
    procedure ApercuExecute(Sender: TObject);
    function ImpressionUpdate: Boolean;
    function ApercuUpdate: Boolean;
  end;

  IFicheEditable = interface
    ['{2B938304-BB07-48D7-8A19-F3C70C38E271}']
    procedure ModificationExecute(Sender: TObject);
    function ModificationUpdate: Boolean;
  end;

  IModeEditing = interface
  end;

  TModeEditing = class(TInterfacedObject, IModeEditing)
  strict private
    FOldMode: TModeConsult;
  public
    constructor Create;
    destructor Destroy; override;
  end;

function Convertisseur(Caller: TControl; var Value: Currency): Boolean;

function Choisir(const Texte1, Texte2: string; Bouton: Integer): TModalResult;

type
  TDetailAlbumOption = (daoScenario, daoDessins, daoCouleurs, daoHistoire, daoNotes);
  TDetailAlbumOptions = set of TDetailAlbumOption;

function ChoisirDetailAlbum(Bouton: Integer; out DetailsOptions: TDetailAlbumOptions): TModalResult;

type
  TDetailSerieOption = (dsoSerieSeule, dsoListeAlbums, dsoAlbumsDetails, dsoListeEditions, dsoEditionsDetaillees);

const
  LibelleDetailSerieOption: array [TDetailSerieOption, TDetailSerieOption] of string = (('Série seule', 'Liste simplifiée des albums et para-BD',
    'Liste détaillée des albums et para-BD', 'Liste simplifiée des éditions', 'Liste détaillée des éditions'), ('', '', '', '', ''),
    ('', '', 'Album seul', 'Liste simplifiée des éditions', 'Liste détaillée des éditions'), ('', '', '', '', ''), ('', '', '', '', ''));

function ChoisirDetailSerie(NiveauDetailMax: TDetailSerieOption; out DetailSerieOption: TDetailSerieOption; out PrevisionsManquants: Boolean)
  : TModalResult; overload;
function ChoisirDetailSerie(NiveauDetailMax: TDetailSerieOption; out DetailSerieOption: TDetailSerieOption): TModalResult; overload;

procedure LitOptions;
procedure EcritOptions;

function SupprimerTable(const Table: string): Boolean;
function SupprimerToutDans(const ChampSupp, Table: string; UseTransaction: TManagedTransaction = nil): Boolean; overload;
function SupprimerToutDans(const ChampSupp, Table, Reference, Sauf: string; UseTransaction: TManagedTransaction = nil): Boolean; overload;
function SupprimerToutDans(const ChampSupp, Table, Reference: string; const Valeur: RGUIDEx; UseTransaction: TManagedTransaction = nil): Boolean; overload;

function GetCouvertureStream(isParaBD: Boolean; const ID_Couverture: RGUIDEx; Hauteur, Largeur: Integer; AntiAliasing: Boolean; Cadre: Boolean = False;
  Effet3D: Integer = 0): TStream; overload;
procedure LoadCouverture(isParaBD: Boolean; const ID_Couverture: RGUIDEx; Picture: TPicture);
function SearchNewFileName(const Chemin, Fichier: string; Reserve: Boolean = True): string;

procedure LoadCombo(Combo: TLightComboCheck; List: TStrings; DefaultValue: ROption);

implementation

uses UfrmChoixDetail, UfrmChoix, BDTK.GUI.Forms.Converter, BDTK.GUI.Forms.Main, Divers, BD.Utils.GUIUtils, Math, BD.Strings, ActnList, UfrmChoixDetailSerie,
  BDTK.GUI.DataModules.Main, System.IniFiles, Vcl.Imaging.jpeg, System.IOUtils;

function Choisir(const Texte1, Texte2: string; Bouton: Integer): TModalResult;
var
  frm: TfrmChoix;
  dlg: TTaskDialog;
  btn: TTaskDialogBaseButtonItem;
begin
  Result := mrCancel;
  if not Bouton in [0 .. 2] then
    Exit;
  if CanUseTaskDialog then
  begin
    dlg := TTaskDialog.Create(nil);
    try
      btn := dlg.Buttons.Add;
      btn.Caption := Texte1;
      btn.Default := Bouton = 1;
      btn.ModalResult := mrYes;

      btn := dlg.Buttons.Add;
      btn.Caption := Texte2;
      btn.Default := Bouton = 2;
      btn.ModalResult := mrNo;

      dlg.Flags := [tfAllowDialogCancellation, tfUseCommandLinks];
      dlg.CommonButtons := [tcbCancel];
      if dlg.Execute then
        Result := dlg.ModalResult;
    finally
      dlg.Free;
    end;
  end
  else
  begin
    frm := TFrmChoix.Create(Application);
    try
      frm.BtnChoix1.Caption := Texte1;
      frm.BtnChoix2.Caption := Texte2;
      case Bouton of
        0:
          frm.framBoutons1.btnAnnuler.Default := True;
        1:
          frm.BtnChoix1.Default := True;
        2:
          frm.BtnChoix2.Default := True;
      end;
      Result := frm.ShowModal;
    finally
      frm.Free;
    end;
  end;
end;

function ChoisirDetailAlbum(Bouton: Integer; out DetailsOptions: TDetailAlbumOptions): TModalResult;
var
  frm: TfrmChoixDetail;
begin
  if not Bouton in [0 .. 2] then
    Exit(0);

  frm := TFrmChoixDetail.Create(Application);
  try
    frm.BtnChoix1.Caption := rsTransListeSimple;
    frm.BtnChoix2.Caption := rsTransListeDetail;
    case Bouton of
      0:
        frm.framBoutons1.btnAnnuler.default := True;
      1:
        frm.BtnChoix1.default := True;
      2:
        frm.BtnChoix2.default := True;
    end;
    Result := frm.ShowModal;
    if Result = mrNo then
    begin
      if frm.cbScenario.Checked then
        Include(DetailsOptions, daoScenario);
      if frm.cbDessins.Checked then
        Include(DetailsOptions, daoDessins);
      if frm.cbCouleurs.Checked then
        Include(DetailsOptions, daoCouleurs);
      if frm.cbHistoire.Checked then
        Include(DetailsOptions, daoHistoire);
      if frm.cbNotes.Checked then
        Include(DetailsOptions, daoNotes);
    end;
  finally
    frm.Free;
  end;
end;

function ChoisirDetailSerie(NiveauDetailMax: TDetailSerieOption; out DetailSerieOption: TDetailSerieOption): TModalResult;
var
  i: TDetailSerieOption;
  frm: TfrmChoixDetailSerie;
  dlg: TTaskDialog;
  btn: TTaskDialogBaseButtonItem;
begin
  Result := mrCancel;
  if CanUseTaskDialog then
  begin
    dlg := TTaskDialog.Create(nil);
    try
      for i := NiveauDetailMax to high(TDetailSerieOption) do
      begin
        btn := dlg.Buttons.Add;
        begin
          btn.Caption := LibelleDetailSerieOption[NiveauDetailMax][i];
          btn.Default := i = NiveauDetailMax;
          btn.ModalResult := 110 + Integer(i);
        end;
      end;

      dlg.Flags := [tfAllowDialogCancellation, tfUseCommandLinks];
      dlg.CommonButtons := [tcbCancel];

      if dlg.Execute and (dlg.ModalResult <> mrCancel) then
      begin
        Result := mrOk;
        DetailSerieOption := TDetailSerieOption(dlg.ModalResult - 110);
      end;
    finally
      dlg.Free;
    end;
  end
  else
  begin
    frm := TFrmChoixDetailSerie.Create(Application);
    try
      // cacher la checkbox avant d'assigner MaxNiveauDetail
      frm.CheckBox1.Visible := False;
      frm.MaxNiveauDetail := NiveauDetailMax;
      if frm.ShowModal <> mrCancel then
      begin
        Result := mrOk;
        DetailSerieOption := TDetailSerieOption(frm.ModalResult - 110);
      end;
    finally
      frm.Free;
    end;
  end;
end;

function ChoisirDetailSerie(NiveauDetailMax: TDetailSerieOption; out DetailSerieOption: TDetailSerieOption; out PrevisionsManquants: Boolean): TModalResult;
var
  i: TDetailSerieOption;
  frm: TfrmChoixDetailSerie;
  dlg: TTaskDialog;
  btn: TTaskDialogBaseButtonItem;
begin
  Result := mrCancel;
  if CanUseTaskDialog then
  begin
    dlg := TTaskDialog.Create(nil);
    try
      for i := NiveauDetailMax to high(TDetailSerieOption) do
      begin
        btn := dlg.Buttons.Add;
        btn.Caption := LibelleDetailSerieOption[NiveauDetailMax][i];
        btn.Default := i = NiveauDetailMax;
        btn.ModalResult := 110 + Integer(i);
      end;

      btn := dlg.RadioButtons.Add;
      btn.Caption := 'Inclure Prévisions de sorties/Manquants';
      btn.Default := True;
      btn.ModalResult := 105;

      btn := dlg.RadioButtons.Add;
      btn.Caption := 'Exclure Prévisions de sorties/Manquants';
      btn.Default := False;
      btn.ModalResult := 106;

      dlg.Flags := [tfAllowDialogCancellation, tfUseCommandLinks];
      dlg.CommonButtons := [tcbCancel];

      if dlg.Execute and (dlg.ModalResult <> mrCancel) then
      begin
        Result := mrOk;
        DetailSerieOption := TDetailSerieOption(dlg.ModalResult - 110);
        PrevisionsManquants := Assigned(dlg.RadioButton) and (dlg.RadioButton.ModalResult = 105);
      end;
    finally
      dlg.Free;
    end;
  end
  else
  begin
    frm := TFrmChoixDetailSerie.Create(Application);
    try
      frm.MaxNiveauDetail := NiveauDetailMax;
      if frm.ShowModal <> mrCancel then
      begin
        Result := mrOk;
        DetailSerieOption := TDetailSerieOption(frm.ModalResult - 110);
        PrevisionsManquants := frm.CheckBox1.Checked;
      end;
    finally
      frm.Free;
    end;
  end;
end;

function Convertisseur(Caller: TControl; var Value: Currency): Boolean;
var
  p: TPoint;
  frm: TFrmConvers;
begin
  frm := TFrmConvers.Create(nil);
  try
    frm.Valeur := Value;
    p := Caller.ClientOrigin;
    Inc(p.y, Caller.Height);
    frm.Left := p.x;
    frm.Top := p.y;
    if frm.Left + frm.Width > Screen.WorkAreaRect.Right then
      frm.Left := Max(0, Screen.WorkAreaRect.Right - frm.Width);
    if frm.Top + frm.Height > Screen.WorkAreaRect.Bottom then
      frm.Top := Max(0, Screen.WorkAreaRect.Bottom - frm.Height);
    Result := frm.ShowModal = mrOk;
    if Result then
      Value := frm.Valeur;
  finally
    frm.Free;
  end;
end;

{ TModeEditing }

constructor TModeEditing.Create;
var
  i: Integer;
begin
  inherited;
  FOldMode := TGlobalVar.Mode_en_cours;
  TGlobalVar.Mode_en_cours := mdEditing;
  for i := 0 to Pred(frmFond.ActionsOutils.ActionCount) do
    TAction(frmFond.ActionsOutils.Actions[i]).Enabled := False;
end;

destructor TModeEditing.Destroy;
var
  i: Integer;
begin
  TGlobalVar.Mode_en_cours := FOldMode;
  if TGlobalVar.Mode_en_cours <> mdEditing then
    for i := 0 to Pred(frmFond.ActionsOutils.ActionCount) do
      TAction(frmFond.ActionsOutils.Actions[i]).Enabled := True;
  inherited;
end;

procedure LitOptions;

  function LitStr(Table: TManagedQuery; const Champ, Defaut: string): string;
  begin
    Table.Params.AsString[0] := Copy(Champ, 1, Table.Params.MaxStrLen[0]);
    Table.Open;
    if not Table.Eof then
      Result := Table.Fields.AsUnicodeString[0]
    else
      Result := Defaut;
  end;

var
  op: TManagedQuery;
  hg: IHourGlass;
  ini: TIniFile;
begin
  hg := THourGlass.Create;
  op := dmPrinc.DBConnection.GetQuery;
  try
    op.SQL.Text := 'select first 1 valeur from options where nom_option = ? order by dm_options desc';
    op.Prepare(True);
    TGlobalVar.Utilisateur.Options.SymboleMonnetaire := LitStr(op, 'SymboleM', FormatSettings.CurrencyString);
    RepImages := LitStr(op, 'RepImages', RepImages);
  finally
    op.Free;
  end;
  ini := TIniFile.Create(FichierIni);
  try
    TGlobalVar.Utilisateur.Options.ModeDemarrage := ini.ReadBool('DIVERS', 'ModeDemarrage', True);
    TGlobalVar.Utilisateur.Options.FicheAlbumWithCouverture := ini.ReadBool('DIVERS', 'FicheWithCouverture', True);
    TGlobalVar.Utilisateur.Options.FicheParaBDWithImage := ini.ReadBool('DIVERS', 'ParaBDWithImage', True);
    TGlobalVar.Utilisateur.Options.Images := ini.ReadBool('DIVERS', 'Images', True);
    TGlobalVar.Utilisateur.Options.AntiAliasing := ini.ReadBool('DIVERS', 'AntiAliasing', True);
    TGlobalVar.Utilisateur.Options.ImagesStockees := ini.ReadBool('ModeEdition', 'ImagesStockees', False);
    TGlobalVar.Utilisateur.Options.FormatTitreAlbum := ini.ReadInteger('DIVERS', 'FormatTitreAlbum', 0);
    TGlobalVar.Utilisateur.Options.AvertirPret := ini.ReadBool('DIVERS', 'AvertirPret', False);
    TGlobalVar.Utilisateur.Options.GrandesIconesMenus := ini.ReadBool('DIVERS', 'GrandesIconesMenus', True);
    TGlobalVar.Utilisateur.Options.GrandesIconesBarre := ini.ReadBool('DIVERS', 'GrandesIconesBarre', True);
    TGlobalVar.Utilisateur.Options.VerifMAJDelai := ini.ReadInteger('Divers', 'VerifMAJDelai', 4);
    TGlobalVar.Utilisateur.Options.SerieObligatoireAlbums := ini.ReadBool('DIVERS', 'SerieObligatoireAlbums', False);
    TGlobalVar.Utilisateur.Options.SerieObligatoireParaBD := ini.ReadBool('DIVERS', 'SerieObligatoireParaBD', False);
    TGlobalVar.Utilisateur.Options.AfficheNoteListes := ini.ReadBool('DIVERS', 'AfficheNoteListes', True);

    TGlobalVar.Utilisateur.Options.SiteWeb.Adresse := ini.ReadString('WWW', 'Adresse', '');
    TGlobalVar.Utilisateur.Options.SiteWeb.Cle := ini.ReadString('WWW', 'AuthKey', '');
    TGlobalVar.Utilisateur.Options.SiteWeb.Modele := ini.ReadString('WWW', 'Modele', 'Site par défaut');
    TGlobalVar.Utilisateur.Options.SiteWeb.MySQLServeur := ini.ReadString('WWW', 'MySQLServeur', 'localhost');
    TGlobalVar.Utilisateur.Options.SiteWeb.MySQLLogin := ini.ReadString('WWW', 'MySQLLogin', '');
    TGlobalVar.Utilisateur.Options.SiteWeb.MySQLPassword := ini.ReadString('WWW', 'MySQLPassword', '');
    TGlobalVar.Utilisateur.Options.SiteWeb.MySQLBDD := ini.ReadString('WWW', 'MySQLBDD', TGlobalVar.Utilisateur.Options.SiteWeb.MySQLLogin);
    TGlobalVar.Utilisateur.Options.SiteWeb.MySQLPrefix := ini.ReadString('WWW', 'MySQLPrefix', 'bdt');
    TGlobalVar.Utilisateur.Options.SiteWeb.BddVersion := ini.ReadString('WWW', 'BddVersion', '');
    TGlobalVar.Utilisateur.Options.SiteWeb.Paquets := ini.ReadInteger('WWW', 'Paquets', 4096);

    {$IFDEF DEBUG}
    TGlobalVar.Utilisateur.Options.ServerSynchro := TGlobalVar.Utilisateur.Options.SiteWeb;
    {$ENDIF}
  finally
    ini.Free;
  end;
end;

procedure EcritOptions;

  procedure Sauve(Table: TManagedQuery; const Champ: string; Valeur: Currency); overload;
  begin
    Table.SQL.Text := 'update or insert into options (nom_option, valeur) values (:nom_option, :valeur) matching (nom_option)';
    Table.Prepare(True);
    Table.Params.AsString[1] := Copy(Champ, 1, Table.Params.MaxStrLen[0]);
    Table.Params.AsCurrency[1] := Valeur;
    Table.Execute;
  end;

  procedure Sauve(Table: TManagedQuery; const Champ, Valeur: string); overload;
  begin
    Table.SQL.Text := 'update or insert into options (nom_option, valeur) values (:nom_option, :valeur) matching (nom_option)';
    Table.Prepare(True);
    Table.Params.AsString[0] := Copy(Champ, 1, Table.Params.MaxStrLen[0]);
    Table.Params.AsString[1] := Copy(Valeur, 1, Table.Params.MaxStrLen[1]);
    Table.Execute;
  end;

var
  op: TManagedQuery;
  hg: IHourGlass;
  ini: TIniFile;
begin
  hg := THourGlass.Create;
  op := dmPrinc.DBConnection.GetQuery;
  try
    Sauve(op, 'SymboleM', TGlobalVar.Utilisateur.Options.SymboleMonnetaire);
    Sauve(op, 'RepImages', RepImages);
    op.Transaction.Commit;
  finally
    op.Free;
  end;
  ini := TIniFile.Create(FichierIni);
  try
    ini.WriteBool('DIVERS', 'ModeDemarrage', TGlobalVar.Utilisateur.Options.ModeDemarrage);
    ini.WriteBool('DIVERS', 'Images', TGlobalVar.Utilisateur.Options.Images);
    ini.WriteBool('DIVERS', 'FicheWithCouverture', TGlobalVar.Utilisateur.Options.FicheAlbumWithCouverture);
    ini.WriteBool('DIVERS', 'ParaBDWithImage', TGlobalVar.Utilisateur.Options.FicheParaBDWithImage);
    ini.WriteBool('DIVERS', 'AntiAliasing', TGlobalVar.Utilisateur.Options.AntiAliasing);
    ini.WriteBool('DIVERS', 'AvertirPret', TGlobalVar.Utilisateur.Options.AvertirPret);
    ini.WriteBool('DIVERS', 'GrandesIconesMenus', TGlobalVar.Utilisateur.Options.GrandesIconesMenus);
    ini.WriteBool('DIVERS', 'GrandesIconesBarre', TGlobalVar.Utilisateur.Options.GrandesIconesBarre);
    ini.WriteBool('ModeEdition', 'ImagesStockees', TGlobalVar.Utilisateur.Options.ImagesStockees);
    ini.WriteInteger('DIVERS', 'FormatTitreAlbum', TGlobalVar.Utilisateur.Options.FormatTitreAlbum);
    ini.WriteInteger('Divers', 'VerifMAJDelai', TGlobalVar.Utilisateur.Options.VerifMAJDelai);
    ini.WriteBool('DIVERS', 'SerieObligatoireAlbums', TGlobalVar.Utilisateur.Options.SerieObligatoireAlbums);
    ini.WriteBool('DIVERS', 'SerieObligatoireParaBD', TGlobalVar.Utilisateur.Options.SerieObligatoireParaBD);
    ini.WriteBool('DIVERS', 'AfficheNoteListes', TGlobalVar.Utilisateur.Options.AfficheNoteListes);

    ini.WriteString('DIVERS', 'RepImages', ''); // efface la ligne

    ini.WriteString('WWW', 'Adresse', TGlobalVar.Utilisateur.Options.SiteWeb.Adresse);
    ini.WriteString('WWW', 'AuthKey', TGlobalVar.Utilisateur.Options.SiteWeb.Cle);
    ini.WriteString('WWW', 'Modele', TGlobalVar.Utilisateur.Options.SiteWeb.Modele);
    ini.WriteString('WWW', 'MySQLServeur', TGlobalVar.Utilisateur.Options.SiteWeb.MySQLServeur);
    ini.WriteString('WWW', 'MySQLLogin', TGlobalVar.Utilisateur.Options.SiteWeb.MySQLLogin);
    ini.WriteString('WWW', 'MySQLPassword', TGlobalVar.Utilisateur.Options.SiteWeb.MySQLPassword);
    ini.WriteString('WWW', 'MySQLBDD', TGlobalVar.Utilisateur.Options.SiteWeb.MySQLBDD);
    ini.WriteString('WWW', 'MySQLPrefix', TGlobalVar.Utilisateur.Options.SiteWeb.MySQLPrefix);
    ini.WriteString('WWW', 'BddVersion', TGlobalVar.Utilisateur.Options.SiteWeb.BddVersion);
    ini.WriteInteger('WWW', 'Paquets', TGlobalVar.Utilisateur.Options.SiteWeb.Paquets);
  finally
    ini.Free;
  end;
end;

function SupprimerTable(const Table: string): Boolean;
var
  qry: TManagedQuery;
begin
  try
    qry := dmPrinc.DBConnection.GetQuery;
    try
      qry.Transaction.Database.Connected := False; // fonctionne mais pas correct du tout!
      qry.Transaction.Database.Connected := True;
      qry.SQL.Text := 'drop table ' + Table;
      qry.Execute;
      qry.Transaction.Commit;
      Result := True;
    finally
      qry.Free;
    end;
  except
    Result := False;
  end;
end;

function SupprimerToutDans(const ChampSupp, Table, Reference: string; const Valeur: RGUIDEx; const Sauf: string; UseTransaction: TManagedTransaction = nil): Boolean; overload;
var
  qry: TManagedQuery;
begin
  try
    qry := dmPrinc.DBConnection.GetQuery(UseTransaction);
    try
      if ChampSupp <> '' then
        qry.SQL.Add(Format('update %s set %s = True', [Table, ChampSupp])) // True ????
      else
        qry.SQL.Add(Format('delete from %s', [Table]));

      if (Reference <> '') then
        if not IsEqualGUID(Valeur, GUID_NULL) then
          qry.SQL.Add(Format('where %s = ''%s''', [Reference, GUIDToString(Valeur)]))
        else if Sauf <> '' then
          qry.SQL.Add(Format('where %s not in (%s)', [Reference, Sauf]));

      qry.Execute;
      qry.Transaction.Commit;
      Result := True;
    finally
      qry.Free;
    end;
  except
    Result := False;
  end;
end;

function SupprimerToutDans(const ChampSupp, Table: string; UseTransaction: TManagedTransaction = nil): Boolean;
begin
  Result := SupprimerToutDans(ChampSupp, Table, '', GUID_NULL, '', UseTransaction);
end;

function SupprimerToutDans(const ChampSupp, Table, Reference, Sauf: string; UseTransaction: TManagedTransaction = nil): Boolean; overload;
begin
  // /!\ Valeur = GUID_NULL et Sauf = '' => effacer la table !!!!
  // dans ce cas, il faut utiliser la méthode spécifique
  Result := (Sauf = '') or SupprimerToutDans(ChampSupp, Table, Reference, GUID_NULL, Sauf, UseTransaction);
end;

function SupprimerToutDans(const ChampSupp, Table, Reference: string; const Valeur: RGUIDEx; UseTransaction: TManagedTransaction = nil): Boolean; overload;
begin
  // /!\ Valeur = GUID_NULL et Sauf = '' => effacer la table !!!!
  // dans ce cas, il faut utiliser la méthode spécifique
  Result := IsEqualGUID(Valeur, GUID_NULL) or SupprimerToutDans(ChampSupp, Table, Reference, Valeur, '', UseTransaction);
end;

function GetCouvertureStream(isParaBD: Boolean; const ID_Couverture: RGUIDEx; Hauteur, Largeur: Integer; AntiAliasing: Boolean; Cadre: Boolean = False;
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

procedure LoadCouverture(isParaBD: Boolean; const ID_Couverture: RGUIDEx; Picture: TPicture);
var
  ms: TMemoryStream;
  img: TJPEGImage;
  Fichier, Chemin: string;
  qry: TManagedQuery;
begin
  qry := dmPrinc.DBConnection.GetQuery;
  try
    if isParaBD then
      qry.SQL.Text := 'select imagephoto, stockagephoto, fichierphoto from photos where id_photo = ?'
    else
      qry.SQL.Text := 'select imagecouverture, stockagecouverture, fichiercouverture from couvertures where id_couverture = ?';
    qry.Params.AsString[0] := GUIDToString(ID_Couverture);
    qry.FetchBlobs := True;
    qry.Open;
    if qry.Eof or (qry.Fields.IsNull[0] and qry.Fields.IsNull[2]) then
      Picture.Assign(nil)
    else
    begin
      if not qry.Fields.AsBoolean[1] then
      begin
        Fichier := TPath.GetFileName(qry.Fields.AsString[2]);
        Chemin := TPath.GetDirectoryName(qry.Fields.AsString[2]);
        if Chemin = '' then
          Chemin := RepImages;
        qry.SQL.Text := 'select blobcontent from loadblobfromfile(:chemin, :fichier);';
        qry.Prepare(True);
        qry.Params.AsString[0] := Copy(Chemin, 1, qry.Params.MaxStrLen[0]);
        qry.Params.AsString[1] := Copy(Fichier, 1, qry.Params.MaxStrLen[1]);
        qry.Open;
        if qry.Eof then
        begin
          Picture.Assign(nil);
          Exit;
        end;
      end;

      ms := TMemoryStream.Create;
      img := TJPEGImage.Create;
      try
        qry.ReadBlob(0, ms);
        ms.Position := 0;
        img.LoadFromStream(ms);
        Picture.Assign(img);
      finally
        ms.Free;
        img.Free;
      end;
    end;
  finally
    qry.Free;
  end;
end;

function SearchNewFileName(const Chemin, Fichier: string; Reserve: Boolean = True): string;
var
  qry: TManagedQuery;
begin
  qry := dmPrinc.DBConnection.GetQuery;
  try
    qry.SQL.Text := 'select * from searchfilename(:chemin, :fichier, :reserve)';
    qry.Prepare(True);
    qry.Params.AsString[0] := Copy(IncludeTrailingPathDelimiter(Chemin), 1, qry.Params.MaxStrLen[0]);
    qry.Params.AsString[1] := Copy(Fichier, 1, qry.Params.MaxStrLen[1]);
    qry.Params.AsBoolean[2] := Reserve;
    qry.Open;
    Result := TPath.GetFileName(qry.Fields.AsString[0]);
  finally
    qry.Free;
  end;
end;

procedure LoadCombo(Combo: TLightComboCheck; List: TStrings; DefaultValue: ROption);
var
  HasNULL: Boolean;
  i: Integer;
  s: TSubItem;
begin
  Combo.Items.Clear;
  Combo.DefaultValueChecked := -1;
  HasNull := False;
  for i := 0 to Pred(List.Count) do
  begin
    s := Combo.Items.Add;
    s.Caption := List.ValueFromIndex[i];
    s.Valeur := StrToInt(List.Names[i]);
    if Integer(DefaultValue) = s.Valeur then
      Combo.DefaultValueChecked := s.Valeur;
    HasNULL := HasNull or (s.Valeur = -1);
  end;
  if not HasNULL then
  begin
    s := Combo.Items.Add;
    s.Caption := ' ';
    s.Valeur := -1;
    s.Index := 0;
  end;

  Combo.Value := Combo.DefaultValueChecked;
end;

end.

