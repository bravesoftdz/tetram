unit ProceduresBDtk;

interface

uses SysUtils, Windows, StdCtrls, Forms, Controls, ExtCtrls, CommonConst, Graphics, StrUtils, Dialogs, SyncObjs,
  uib, Commun, System.Classes, ComboCheck, Entities.Full;

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
function SupprimerToutDans(const ChampSupp, Table: string; UseTransaction: TUIBTransaction = nil): Boolean; overload;
function SupprimerToutDans(const ChampSupp, Table, Reference, Sauf: string; UseTransaction: TUIBTransaction = nil): Boolean; overload;
function SupprimerToutDans(const ChampSupp, Table, Reference: string; const Valeur: RGUIDEx; UseTransaction: TUIBTransaction = nil): Boolean; overload;
function SupprimerToutDans(const ChampSupp, Table, Reference: string; const Valeur: RGUIDEx; const Sauf: string; UseTransaction: TUIBTransaction = nil)
  : Boolean; overload;

function GetCouvertureStream(isParaBD: Boolean; const ID_Couverture: RGUIDEx; Hauteur, Largeur: Integer; AntiAliasing: Boolean; Cadre: Boolean = False;
  Effet3D: Integer = 0): TStream; overload;
procedure LoadCouverture(isParaBD: Boolean; const ID_Couverture: RGUIDEx; Picture: TPicture);
function SearchNewFileName(const Chemin, Fichier: string; Reserve: Boolean = True): string;

procedure LoadCombo(Combo: TLightComboCheck; List: TStrings; DefaultValue: ROption);

implementation

uses UfrmChoixDetail, UfrmChoix, UfrmConvertisseur, UfrmFond, Divers, Procedures, Math, Textes, ActnList, UfrmChoixDetailSerie,
  UdmPrinc, System.IniFiles, Vcl.Imaging.jpeg, System.IOUtils;

function Choisir(const Texte1, Texte2: string; Bouton: Integer): TModalResult;
begin
  Result := mrCancel;
  if not Bouton in [0 .. 2] then
    Exit;
  if CanUseTaskDialog then
    with TTaskDialog.Create(nil) do
      try
        with Buttons.Add do
        begin
          Caption := Texte1;
          default := Bouton = 1;
          ModalResult := mrYes;
        end;

        with Buttons.Add do
        begin
          Caption := Texte2;
          default := Bouton = 2;
          ModalResult := mrNo;
        end;
        Flags := [tfAllowDialogCancellation, tfUseCommandLinks];
        CommonButtons := [tcbCancel];
        if Execute then
          Result := ModalResult;
      finally
        Free;
      end
  else
    with TFrmChoix.Create(Application) do
      try
        BtnChoix1.Caption := Texte1;
        BtnChoix2.Caption := Texte2;
        case Bouton of
          0:
            framBoutons1.btnAnnuler.default := True;
          1:
            BtnChoix1.default := True;
          2:
            BtnChoix2.default := True;
        end;
        Result := ShowModal;
      finally
        Free;
      end;
end;

function ChoisirDetailAlbum(Bouton: Integer; out DetailsOptions: TDetailAlbumOptions): TModalResult;
begin
  if not Bouton in [0 .. 2] then
  begin
    Result := 0;
    Exit;
  end;
  with TFrmChoixDetail.Create(Application) do
    try
      BtnChoix1.Caption := rsTransListeSimple;
      BtnChoix2.Caption := rsTransListeDetail;
      case Bouton of
        0:
          framBoutons1.btnAnnuler.default := True;
        1:
          BtnChoix1.default := True;
        2:
          BtnChoix2.default := True;
      end;
      Result := ShowModal;
      if Result = mrNo then
      begin
        if cbScenario.Checked then
          Include(DetailsOptions, daoScenario);
        if cbDessins.Checked then
          Include(DetailsOptions, daoDessins);
        if cbCouleurs.Checked then
          Include(DetailsOptions, daoCouleurs);
        if cbHistoire.Checked then
          Include(DetailsOptions, daoHistoire);
        if cbNotes.Checked then
          Include(DetailsOptions, daoNotes);
      end;
    finally
      Free;
    end;
end;

function ChoisirDetailSerie(NiveauDetailMax: TDetailSerieOption; out DetailSerieOption: TDetailSerieOption): TModalResult;
var
  i: TDetailSerieOption;
begin
  Result := mrCancel;
  if CanUseTaskDialog then
    with TTaskDialog.Create(nil) do
      try
        for i := NiveauDetailMax to high(TDetailSerieOption) do
          with Buttons.Add do
          begin
            Caption := LibelleDetailSerieOption[NiveauDetailMax][i];
            default := i = NiveauDetailMax;
            ModalResult := 110 + Integer(i);
          end;

        Flags := [tfAllowDialogCancellation, tfUseCommandLinks];
        CommonButtons := [tcbCancel];

        if Execute and (ModalResult <> mrCancel) then
        begin
          Result := mrOk;
          DetailSerieOption := TDetailSerieOption(ModalResult - 110);
        end;
      finally
        Free;
      end
  else
    with TFrmChoixDetailSerie.Create(Application) do
      try
        // cacher la checkbox avant d'assigner MaxNiveauDetail
        CheckBox1.Visible := False;
        MaxNiveauDetail := NiveauDetailMax;
        if ShowModal <> mrCancel then
        begin
          Result := mrOk;
          DetailSerieOption := TDetailSerieOption(ModalResult - 110);
        end;
      finally
        Free;
      end;
end;

function ChoisirDetailSerie(NiveauDetailMax: TDetailSerieOption; out DetailSerieOption: TDetailSerieOption; out PrevisionsManquants: Boolean): TModalResult;
var
  i: TDetailSerieOption;
begin
  Result := mrCancel;
  if CanUseTaskDialog then
    with TTaskDialog.Create(nil) do
      try
        for i := NiveauDetailMax to high(TDetailSerieOption) do
          with Buttons.Add do
          begin
            Caption := LibelleDetailSerieOption[NiveauDetailMax][i];
            default := i = NiveauDetailMax;
            ModalResult := 110 + Integer(i);
          end;

        with RadioButtons.Add do
        begin
          Caption := 'Inclure Prévisions de sorties/Manquants';
          default := True;
          ModalResult := 105;
        end;
        with RadioButtons.Add do
        begin
          Caption := 'Exclure Prévisions de sorties/Manquants';
          default := False;
          ModalResult := 106;
        end;

        Flags := [tfAllowDialogCancellation, tfUseCommandLinks];
        CommonButtons := [tcbCancel];

        if Execute and (ModalResult <> mrCancel) then
        begin
          Result := mrOk;
          DetailSerieOption := TDetailSerieOption(ModalResult - 110);
          PrevisionsManquants := Assigned(RadioButton) and (RadioButton.ModalResult = 105);
        end;
      finally
        Free;
      end
  else
    with TFrmChoixDetailSerie.Create(Application) do
      try
        MaxNiveauDetail := NiveauDetailMax;
        if ShowModal <> mrCancel then
        begin
          Result := mrOk;
          DetailSerieOption := TDetailSerieOption(ModalResult - 110);
          PrevisionsManquants := CheckBox1.Checked;
        end;
      finally
        Free;
      end;
end;

function Convertisseur(Caller: TControl; var Value: Currency): Boolean;
var
  p: TPoint;
begin
  with TFrmConvers.Create(nil) do
    try
      Valeur := Value;
      p := Caller.ClientOrigin;
      Inc(p.y, Caller.Height);
      Left := p.x;
      Top := p.y;
      if Left + Width > Screen.WorkAreaRect.Right then
        Left := Max(0, Screen.WorkAreaRect.Right - Width);
      if Top + Height > Screen.WorkAreaRect.Bottom then
        Top := Max(0, Screen.WorkAreaRect.Bottom - Height);
      Result := ShowModal = mrOk;
      if Result then
        Value := Valeur;
    finally
      Free;
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
      SQL.Text := 'select first 1 valeur from options where nom_option = ? order by dm_options desc';
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
      SQL.Text := 'update or insert into options (nom_option, valeur) values (:nom_option, :valeur) matching (nom_option)';
      Prepare(True);
      Params.AsString[1] := Copy(Champ, 1, Params.MaxStrLen[0]);
      Params.AsCurrency[1] := Valeur;
      Execute;
    end;
  end;

  procedure Sauve(Table: TUIBQuery; const Champ, Valeur: string); overload;
  begin
    with Table do
    begin
      SQL.Text := 'update or insert into options (nom_option, valeur) values (:nom_option, :valeur) matching (nom_option)';
      Prepare(True);
      Params.AsString[0] := Copy(Champ, 1, Params.MaxStrLen[0]);
      Params.AsString[1] := Copy(Valeur, 1, Params.MaxStrLen[1]);
      Execute;
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

function SupprimerTable(const Table: string): Boolean;
begin
  try
    with TUIBQuery.Create(nil) do
      try
        Transaction := GetTransaction(DMPrinc.UIBDataBase);
        Transaction.Database.Connected := False; // fonctionne mais pas correct du tout!
        Transaction.Database.Connected := True;
        SQL.Text := 'drop table ' + Table;
        Execute;
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
  Result := SupprimerToutDans(ChampSupp, Table, '', GUID_NULL, '', UseTransaction);
end;

function SupprimerToutDans(const ChampSupp, Table, Reference, Sauf: string; UseTransaction: TUIBTransaction = nil): Boolean; overload;
begin
  Result := SupprimerToutDans(ChampSupp, Table, Reference, GUID_NULL, Sauf, UseTransaction);
end;

function SupprimerToutDans(const ChampSupp, Table, Reference: string; const Valeur: RGUIDEx; UseTransaction: TUIBTransaction = nil): Boolean; overload;
begin
  Result := SupprimerToutDans(ChampSupp, Table, Reference, Valeur, '', UseTransaction);
end;

function SupprimerToutDans(const ChampSupp, Table, Reference: string; const Valeur: RGUIDEx; const Sauf: string; UseTransaction: TUIBTransaction = nil)
  : Boolean;
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

        if (Reference <> '') then
          if IsEqualGUID(Valeur, GUID_NULL) then
            SQL.Add(Format('where %s not in (%s)', [Reference, Sauf]))
          else
            SQL.Add(Format('where %s = ''%s''', [Reference, GUIDToString(Valeur)]));

        Execute;
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
begin
  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      if isParaBD then
        SQL.Text := 'select imageparabd, stockageparabd, fichierparabd from parabd where id_parabd = ?'
      else
        SQL.Text := 'select imagecouverture, stockagecouverture, fichiercouverture from couvertures where id_couverture = ?';
      Params.AsString[0] := GUIDToString(ID_Couverture);
      FetchBlobs := True;
      Open;
      if Eof or (Fields.IsNull[0] and Fields.IsNull[2]) then
        Picture.Assign(nil)
      else
      begin
        if not Fields.AsBoolean[1] then
        begin
          Fichier := TPath.GetFileName(Fields.AsString[2]);
          Chemin := TPath.GetDirectoryName(Fields.AsString[2]);
          if Chemin = '' then
            Chemin := RepImages;
          SQL.Text := 'select blobcontent from loadblobfromfile(:chemin, :fichier);';
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

function SearchNewFileName(const Chemin, Fichier: string; Reserve: Boolean = True): string;
begin
  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'select * from searchfilename(:chemin, :fichier, :reserve)';
      Prepare(True);
      Params.AsString[0] := Copy(IncludeTrailingPathDelimiter(Chemin), 1, Params.MaxStrLen[0]);
      Params.AsString[1] := Copy(Fichier, 1, Params.MaxStrLen[1]);
      Params.AsBoolean[2] := Reserve;
      Open;
      Result := TPath.GetFileName(Fields.AsString[0]);
    finally
      Transaction.Free;
      Free;
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
