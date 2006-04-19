unit Form_EditParaBD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, DBEditLabeled, VirtualTrees, ComCtrls, VDTButton,
  VirtualTree, ComboCheck, ExtCtrls, Buttons, Frame_RechercheRapide, ExtDlgs;

type
  TFrmEditParaBD = class(TForm)
    Panel2: TPanel;
    btnOK: TBitBtn;
    btnAnnuler: TBitBtn;
    ScrollBox: TScrollBox;
    Label2: TLabel;
    Label6: TLabel;
    btCreateur: TVDTButton;
    Label19: TLabel;
    Bevel1: TBevel;
    Label20: TLabel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    edTitre: TEditLabeled;
    description: TMemoLabeled;
    lvAuteurs: TVDTListViewLabeled;
    vtPersonnes: TVirtualStringTree;
    vtSeries: TVirtualStringTree;
    Label24: TLabel;
    edAnneeCote: TEditLabeled;
    Label25: TLabel;
    edPrixCote: TEditLabeled;
    VDTButton14: TVDTButton;
    Label10: TLabel;
    edAnneeEdition: TEditLabeled;
    cbStock: TCheckBoxLabeled;
    cbGratuit: TCheckBoxLabeled;
    cbOffert: TCheckBoxLabeled;
    dtpAchat: TDateTimePickerLabeled;
    Label18: TLabel;
    Label9: TLabel;
    edPrix: TEditLabeled;
    SpeedButton3: TVDTButton;
    cbDedicace: TCheckBoxLabeled;
    Label12: TLabel;
    cbxCategorie: TLightComboCheck;
    Panel1: TPanel;
    imgVisu: TImage;
    cbNumerote: TCheckBoxLabeled;
    Panel3: TPanel;
    ChoixImage: TVDTButton;
    FrameRechercheRapideSerie: TFrameRechercheRapide;
    FrameRechercheRapideAuteur: TFrameRechercheRapide;
    Panel4: TPanel;
    cbImageBDD: TCheckBoxLabeled;
    VDTButton1: TVDTButton;
    ChoixImageDialog: TOpenPictureDialog;
    procedure cbOffertClick(Sender: TObject);
    procedure cbGratuitClick(Sender: TObject);
    procedure edPrixChange(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure VDTButton14Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAnnulerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure VDTButton1Click(Sender: TObject);
    procedure ChoixImageClick(Sender: TObject);
    procedure vtPersonnesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtPersonnesDblClick(Sender: TObject);
    procedure btCreateurClick(Sender: TObject);
    procedure lvAuteursKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FCreation: Boolean;
    FisAchat: Boolean;
    FID_ParaBD: TGUID;
    FOldImageStockee: Boolean;
    FOldFichierImage, FCurrentFichierImage: string;
    procedure SetID_ParaBD(const Value: TGUID);
    { Déclarations privées }
  public
    { Déclarations publiques }
    property isCreation: Boolean read FCreation;
    property isAchat: Boolean read FisAchat write FisAchat;
    property ID_ParaBD: TGUID read FID_ParaBD write SetID_ParaBD;
  end;

  TFrmEditAchatParaBD = class(TFrmEditParaBD)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  DM_Princ, JvUIB, Commun, jvuiblib, CommonConst, Textes, Procedures, jpeg, Proc_Gestions, TypeRec, Divers;

{$R *.dfm}

{ TFrmEditAchatParaBD }

constructor TFrmEditAchatParaBD.Create(AOwner: TComponent);
begin
  inherited;
  FisAchat := True;
end;

{ TFrmEditParaBD }

procedure TFrmEditParaBD.SetID_ParaBD(const Value: TGUID);
var
  q: TJvUIBQuery;
  Stream: TStream;
  jpg: TJPEGImage;
begin
  FID_ParaBD := Value;

  q := TJvUIBQuery.Create(nil);
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);

    SQL.Text := 'SELECT TITREPARABD, ANNEE, ID_Serie, STOCKAGEPARABD, ACHAT, DESCRIPTION, DEDICACE, NUMEROTE, ANNEECOTE, PRIXCOTE, GRATUIT, OFFERT,';
    SQL.Add('DATEACHAT, PRIX, STOCK, CATEGORIEPARABD, FICHIERPARABD, CASE WHEN IMAGEPARABD IS NULL THEN 0 ELSE 1 END HASBLOBIMAGE');
    SQL.Add('FROM PARABD WHERE ID_ParaBD = ?');
    Params.AsString[0] := GUIDToString(FID_ParaBD);
    FetchBlobs := True;
    Open;

    FCreation := Eof;
    if not FCreation then begin
      edTitre.Text := Fields.ByNameAsString['TITREPARABD'];
      edAnneeEdition.Text := Fields.ByNameAsString['ANNEE'];
      cbxCategorie.Value := Fields.ByNameAsInteger['CATEGORIEPARABD'];
      cbDedicace.Checked := Fields.ByNameAsBoolean['DEDICACE'];
      cbNumerote.Checked := Fields.ByNameAsBoolean['NUMEROTE'];
      description.Lines.Text := Fields.ByNameAsString['DESCRIPTION'];

      vtSeries.CurrentValue := StringToGUID(Fields.ByNameAsString['ID_SERIE']);

      cbOffert.Checked := Fields.ByNameAsBoolean['OFFERT'];
      cbGratuit.Checked := Fields.ByNameAsBoolean['GRATUIT'];
      cbOffertClick(nil);

      dtpAchat.Date := Now;
      dtpAchat.Checked := not Fields.ByNameIsNull['DateAchat'];
      if dtpAchat.Checked then dtpAchat.Date := Fields.ByNameAsDate['DateAchat'];

      if Fields.ByNameIsNull['PRIX'] then
        edPrix.Text := ''
      else
        edPrix.Text := FormatCurr(FormatMonnaie, Fields.ByNameAsCurrency['PRIX']);
      edAnneeCote.Text := Fields.ByNameAsString['ANNEECOTE'];
      if Fields.ByNameIsNull['PRIXCOTE'] then
        edPrixCote.Text := ''
      else
        edPrixCote.Text := FormatCurr(FormatMonnaie, Fields.ByNameAsCurrency['PRIXCOTE']);
      cbStock.Checked := Fields.ByNameAsBoolean['STOCK'];

      FOldImageStockee := Fields.ByNameAsBoolean['STOCKAGEPARABD'];
      FOldFichierImage := Fields.ByNameAsString['FICHIERPARABD'];
      if (Fields.ByNameAsSmallint['HASBLOBIMAGE'] = 1) or (FOldFichierImage <> '') then
        cbImageBDD.Checked := FOldImageStockee;

      FetchBlobs := False;

      lvAuteurs.Items.BeginUpdate;
      SQL.Text := 'SELECT * FROM PROC_AUTEURS(NULL, NULL, ?)';
      Params.AsString[0] := GUIDToString(FID_ParaBD);
      Open;
      while not Eof do begin
        with lvAuteurs.Items.Add do begin
          Data := TAuteur.Make(q);
          Caption := TAuteur(Data).ChaineAffichage;
        end;
        Next;
      end;

      Stream := GetCouvertureStream(True, FID_ParaBD, imgVisu.Height, imgVisu.Width, Utilisateur.Options.AntiAliasing);
      if Assigned(Stream) then try
        jpg := TJPEGImage.Create;
        try
          jpg.LoadFromStream(Stream);
          imgVisu.Picture.Assign(jpg);
        finally
          FreeAndNil(jpg);
        end;
      finally
        FreeAndNil(Stream);
      end;
    end;

    FCurrentFichierImage := FOldFichierImage;
  finally
    lvAuteurs.Items.EndUpdate;
    Transaction.Free;
    Free;
  end;
end;

procedure TFrmEditParaBD.cbOffertClick(Sender: TObject);
begin
  if cbOffert.Checked then
    Label18.Caption := rsTransOffertLe
  else
    Label18.Caption := rsTransAcheteLe;
end;

procedure TFrmEditParaBD.cbGratuitClick(Sender: TObject);
begin
  if cbGratuit.Checked then edPrix.Text := '';
end;

procedure TFrmEditParaBD.edPrixChange(Sender: TObject);
begin
  if edPrix.Text <> '' then cbGratuit.Checked := False;
end;

procedure TFrmEditParaBD.SpeedButton3Click(Sender: TObject);
var
  c: Currency;
begin
  c := StrToCurrDef(StringReplace(edPrix.Text, Utilisateur.Options.SymboleMonnetaire, '', []), 0);
  if Convertisseur(SpeedButton3, c) then
    if edPrix.Focused then
      edPrix.Text := FormatCurr(FormatMonnaieSimple, c)
    else
      edPrix.Text := FormatCurr(FormatMonnaie, c);
end;

procedure TFrmEditParaBD.VDTButton14Click(Sender: TObject);
var
  c: Currency;
begin
  c := StrToCurrDef(StringReplace(edPrixCote.Text, Utilisateur.Options.SymboleMonnetaire, '', []), 0);
  if Convertisseur(SpeedButton3, c) then
    if edPrixCote.Focused then
      edPrixCote.Text := FormatCurr(FormatMonnaieSimple, c)
    else
      edPrixCote.Text := FormatCurr(FormatMonnaie, c);
end;

procedure TFrmEditParaBD.FormActivate(Sender: TObject);
begin
  Invalidate;
end;

procedure TFrmEditParaBD.FormDestroy(Sender: TObject);
begin
  TAuteur.VideListe(lvAuteurs);
end;

procedure TFrmEditParaBD.btnAnnulerClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmEditParaBD.FormCreate(Sender: TObject);
begin
  PrepareLV(Self);
  FrameRechercheRapideSerie.VirtualTreeView := vtSeries;
  FrameRechercheRapideAuteur.VirtualTreeView := vtPersonnes;
  vtSeries.Mode := vmSeries;
  vtPersonnes.Mode := vmPersonnes;

  LoadCombo(7 {Catégorie ParaBD}, cbxCategorie);

  VDTButton1.Click;
end;

procedure TFrmEditParaBD.btnOKClick(Sender: TObject);
var
  i, AnneeCote: Integer;
  FID_Serie: TGUID;
  PrixCote: Currency;
  q: TJvUIBQuery;
  hg: IHourGlass;
  s: string;
  Stream: TStream;
begin
  if Length(Trim(edTitre.Text)) = 0 then begin
    AffMessage(rsTitreObligatoire, mtInformation, [mbOk], True);
    edTitre.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;
  if cbxCategorie.Value = -1 then begin
    AffMessage(rsTypeParaBDObligatoire, mtInformation, [mbOk], True);
    // cbxType.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;
  if IsEqualGUID(vtSeries.CurrentValue, GUID_NULL) then begin
    AffMessage(rsSerieObligatoire, mtInformation, [mbOk], True);
    FrameRechercheRapideSerie.edSearch.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;
  AnneeCote := StrToIntDef(edAnneeCote.Text, 0);
  PrixCote := StrToCurrDef(StringReplace(edPrixCote.Text, Utilisateur.Options.SymboleMonnetaire, '', []), 0);
  if (AnneeCote * PrixCote = 0) and (AnneeCote + PrixCote <> 0) then begin
    // une cote doit être composée d'une année ET d'un prix
    AffMessage(rsCoteIncomplete, mtInformation, [mbOk], True);
    edAnneeCote.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;

  hg := THourGlass.Create;
  q := TJvUIBQuery.Create(nil);
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);

    if FCreation then begin
      SQL.Text := 'INSERT INTO PARABD (ID_ParaBD, TITREPARABD, ANNEE, ID_Serie, CATEGORIEPARABD, DEDICACE, NUMEROTE, ANNEECOTE, PRIXCOTE, GRATUIT, OFFERT, DATEACHAT, PRIX, STOCK, TITREINITIALESPARABD, DESCRIPTION, UPPERDESCRIPTION, COMPLET)';
      SQL.Add('VALUES');
      SQL.Add('(:ID_ParaBD, :TITREPARABD, :ANNEE, :ID_Serie, :CATEGORIEPARABD, :DEDICACE, :NUMEROTE, :ANNEECOTE, :PRIXCOTE, :GRATUIT, :OFFERT, :DATEACHAT, :PRIX, :STOCK, :TITREINITIALESPARABD, :DESCRIPTION, :UPPERDESCRIPTION, 1)');
    end
    else begin
      if isAchat then begin
        SQL.Text := 'UPDATE PARABD SET ACHAT = 0 WHERE ID_Album = ?';
        Params.AsString[0] := GUIDToString(FID_ParaBD);
        Execute;
      end;

      SQL.Text := 'UPDATE PARABD SET';
      SQL.Add('TITREPARABD = :TITREPARABD, ANNEE = :ANNEE, ID_Serie = :ID_Serie, CATEGORIEPARABD = :CATEGORIEPARABD, DEDICACE = :DEDICACE, NUMEROTE = :NUMEROTE, ANNEECOTE = :ANNEECOTE,');
      SQL.Add('PRIXCOTE = :PRIXCOTE, GRATUIT = :GRATUIT, OFFERT = :OFFERT, DATEACHAT = :DATEACHAT, PRIX = :PRIX, STOCK = :STOCK, COMPLET = 1,');
      SQL.Add('DESCRIPTION = :DESCRIPTION, TITREINITIALESPARABD = :TITREINITIALESPARABD,');
      SQL.Add('UPPERDESCRIPTION = :UPPERDESCRIPTION');
      SQL.Add('WHERE (ID_ParaBD = :ID_ParaBD)');
    end;

    Params.ByNameAsString['ID_ParaBD'] := GUIDToString(FID_ParaBD);
    s := Trim(edTitre.Text);
    Params.ByNameAsString['TITREPARABD'] := s;
    Params.ByNameAsString['TITREINITIALESPARABD'] := MakeInitiales(UpperCase(SansAccents(s)));
    if edAnneeEdition.Text = '' then
      Params.ByNameIsNull['ANNEE'] := True
    else
      Params.ByNameAsString['ANNEE'] := edAnneeEdition.Text;
    FID_Serie := vtSeries.CurrentValue;
    Params.ByNameAsString['ID_SERIE'] := GUIDToString(FID_Serie);
    Params.ByNameAsInteger['CATEGORIEPARABD'] := cbxCategorie.Value;
    Params.ByNameAsBoolean['DEDICACE'] := cbDedicace.Checked;
    Params.ByNameAsBoolean['NUMEROTE'] := cbNumerote.Checked;
    s := description.Lines.Text;
    if s <> '' then begin
      ParamsSetBlob('DESCRIPTION', s);
      s := UpperCase(SansAccents(s));
      ParamsSetBlob('UPPERDESCRIPTION', s);
    end
    else begin
      Params.ByNameIsNull['DESCRIPTION'] := True;
      Params.ByNameIsNull['UPPERDESCRIPTION'] := True;
    end;
    if (AnneeCote > 0) then begin // le prix obligatoire si l'année est saisie a déjà été controlé
      Params.ByNameAsInteger['ANNEECOTE'] := AnneeCote;
      Params.ByNameAsCurrency['PRIXCOTE'] := PrixCote;
    end
    else begin
      Params.ByNameIsNull['ANNEECOTE'] := True;
      Params.ByNameIsNull['PRIXCOTE'] := True;
    end;
    Params.ByNameAsBoolean['GRATUIT'] := cbGratuit.Checked;
    Params.ByNameAsBoolean['OFFERT'] := cbOffert.Checked;
    if dtpAchat.Checked then
      Params.ByNameAsDate['DATEACHAT'] := Trunc(dtpAchat.Date)
    else
      Params.ByNameIsNull['DATEACHAT'] := True;
    if (edPrix.Text <> '') then
      Params.ByNameAsCurrency['PRIX'] := StrToCurrDef(StringReplace(edPrix.Text, Utilisateur.Options.SymboleMonnetaire, '', []), 0)
    else
      Params.ByNameIsNull['PRIX'] := True;
    Params.ByNameAsBoolean['STOCK'] := cbStock.Checked;
    ExecSQL;

    SupprimerToutDans('', 'AUTEURS_PARABD', 'ID_ParaBD', FID_ParaBD);
    SQL.Clear;
    SQL.Add('INSERT INTO AUTEURS_PARABD (ID_ParaBD, ID_Personne)');
    SQL.Add('VALUES (:ID_Album, :ID_Personne)');
    for i := 0 to lvAuteurs.Items.Count - 1 do begin
      Params.AsString[0] := GUIDToString(FID_ParaBD);
      Params.AsString[1] := GUIDToString(TAuteur(lvAuteurs.Items[i].Data).Personne.ID);
      ExecSQL;
    end;

    if (FOldFichierImage <> FCurrentFichierImage) or (FOldImageStockee <> cbImageBDD.Checked) then begin
      if FCurrentFichierImage = '' then begin
        SQL.Text := 'UPDATE PARABD SET IMAGEPARABD = NULL, STOCKAGEPARABD = 0, FICHIERPARABD = NULL WHERE ID_ParaBD = :ID_ParaBD';
        Params.ByNameAsString['ID_ParaBD'] := GUIDToString(FID_ParaBD);
        ExecSQL;
      end
      else begin
        if cbImageBDD.Checked then begin
          SQL.Text := 'UPDATE PARABD SET IMAGEPARABD = :IMAGEPARABD, STOCKAGEPARABD = 1, FICHIERPARABD = :FICHIERPARABD WHERE ID_ParaBD = :ID_ParaBD';
          if ExtractFilePath(FCurrentFichierImage) = '' then FCurrentFichierImage := IncludeTrailingPathDelimiter(RepImages) + FCurrentFichierImage;
          Stream := GetCouvertureStream(FCurrentFichierImage, -1, -1, False);
          try
            ParamsSetBlob('IMAGEPARABD', Stream);
          finally
            Stream.Free;
          end;
          Params.ByNameAsString['FICHIERPARABD'] := ExtractFileName(FCurrentFichierImage);
          Params.ByNameAsString['ID_ParaBD'] := GUIDToString(FID_ParaBD);
          ExecSQL;
        end
        else begin
          SQL.Text := 'SELECT Result FROM SAVEBLOBTOFILE(:Chemin, :Fichier, :BlobContent)';
          if ExtractFilePath(FCurrentFichierImage) = '' then FCurrentFichierImage := IncludeTrailingPathDelimiter(RepImages) + FCurrentFichierImage;
          Stream := GetCouvertureStream(FCurrentFichierImage, -1, -1, False);
          try
            FCurrentFichierImage := SearchNewFileName(RepImages, ExtractFileName(FCurrentFichierImage), True);
            Params.ByNameAsString['Chemin'] := RepImages;
            Params.ByNameAsString['Fichier'] := FCurrentFichierImage;
            ParamsSetBlob('BlobContent', Stream);
          finally
            Stream.Free;
          end;
          Open;

          SQL.Text := 'UPDATE PARABD SET IMAGEPARABD = NULL, STOCKAGEPARABD = 0, FICHIERPARABD = :FICHIERPARABD WHERE ID_ParaBD = :ID_ParaBD';
          Params.ByNameAsString['FICHIERPARABD'] := FCurrentFichierImage;
          Params.ByNameAsString['ID_ParaBD'] := GUIDToString(FID_ParaBD);
          ExecSQL;
        end;
      end;
    end;

    Transaction.Commit;
  finally
    Transaction.Free;
    Free;
  end;
  ModalResult := mrOk;
end;

procedure TFrmEditParaBD.VDTButton1Click(Sender: TObject);
begin
  imgVisu.Picture := nil;
  FCurrentFichierImage := '';
  cbImageBDD.Checked := Utilisateur.Options.ImagesStockees;
end;

procedure TFrmEditParaBD.ChoixImageClick(Sender: TObject);
var
  Stream: TStream;
  jpg: TJPEGImage;
begin
  with ChoixImageDialog do begin
    Options := Options - [ofAllowMultiSelect];
    Filter := GraphicFilter(TGraphic);
    InitialDir := RepImages;
    FileName := '';
    if Execute then begin
      FCurrentFichierImage := FileName;
      Stream := GetCouvertureStream(FCurrentFichierImage, imgVisu.Height, imgVisu.Width, Utilisateur.Options.AntiAliasing);
      if Assigned(Stream) then try
        jpg := TJPEGImage.Create;
        try
          jpg.LoadFromStream(Stream);
          imgVisu.Picture.Assign(jpg);
        finally
          FreeAndNil(jpg);
        end;
      finally
        FreeAndNil(Stream);
      end;
    end;
  end;
end;

procedure TFrmEditParaBD.vtPersonnesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  IdPersonne: TGUID;

  function NotIn(LV: TListView): Boolean;
  var
    i: Integer;
  begin
    i := 0;
    Result := True;
    while Result and (i <= Pred(LV.Items.Count)) do begin
      Result := not IsEqualGUID(TAuteur(LV.Items[i].Data).Personne.ID, IdPersonne);
      Inc(i);
    end;
  end;

begin
  IdPersonne := vtPersonnes.CurrentValue;
  btCreateur.Enabled := (not IsEqualGUID(IdPersonne, GUID_NULL)) and NotIn(lvAuteurs);
end;

procedure TFrmEditParaBD.vtPersonnesDblClick(Sender: TObject);
var
  i: Integer;
  iCurrentAuteur: TGUID;
  Auteur: TAuteur;
  CurrentAuteur: TPersonnage;
begin
  iCurrentAuteur := vtPersonnes.CurrentValue;
  if ModifierAuteurs(vtPersonnes) then begin
    CurrentAuteur := vtPersonnes.GetFocusedNodeData;
    for i := 0 to Pred(lvAuteurs.Items.Count) do begin
      Auteur := lvAuteurs.Items[i].Data;
      if IsEqualGUID(Auteur.Personne.ID, iCurrentAuteur) then begin
        Auteur.Personne.Assign(CurrentAuteur);
        lvAuteurs.Items[i].Caption := Auteur.ChaineAffichage;
      end;
    end;
    lvAuteurs.Invalidate;
  end;
end;

procedure TFrmEditParaBD.btCreateurClick(Sender: TObject);
var
  PA: TAuteur;
begin
  if IsEqualGUID(vtPersonnes.CurrentValue, GUID_NULL) then Exit;
  PA := TAuteur.Create;
  PA.Fill(TPersonnage(vtPersonnes.GetFocusedNodeData), ID_ParaBD, GUID_NULL, 0);
  with lvAuteurs.Items.Add do begin
    Data := PA;
    Caption := PA.ChaineAffichage;
  end;
  vtPersonnesChange(vtPersonnes, vtPersonnes.FocusedNode);
end;

procedure TFrmEditParaBD.lvAuteursKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  src: TListView;
  PA: TAuteur;
begin
  if Key <> VK_DELETE then Exit;
  src := TListView(Sender);
  PA := src.Selected.Data;
  PA.Free;
  src.Selected.Delete;
  vtPersonnesChange(vtPersonnes, vtPersonnes.FocusedNode);
end;

end.

