unit Form_EditParaBD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, DBEditLabeled, VirtualTrees, ComCtrls, VDTButton,
  VirtualTree, ComboCheck, ExtCtrls, Buttons, Frame_RechercheRapide, ExtDlgs, LoadComplet,
  CRFurtif, Fram_Boutons, UBdtForms;

type
  TFrmEditParaBD = class(TbdtForm)
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
    ChoixImage: TCRFurtifLight;
    FrameRechercheRapideSerie: TFrameRechercheRapide;
    FrameRechercheRapideAuteur: TFrameRechercheRapide;
    Panel4: TPanel;
    cbImageBDD: TCheckBoxLabeled;
    VDTButton1: TCRFurtifLight;
    ChoixImageDialog: TOpenPictureDialog;
    Frame11: TFrame1;
    Bevel2: TBevel;
    btResetSerie: TCRFurtifLight;
    procedure cbOffertClick(Sender: TObject);
    procedure cbGratuitClick(Sender: TObject);
    procedure edPrixChange(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure VDTButton14Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure VDTButton1Click(Sender: TObject);
    procedure ChoixImageClick(Sender: TObject);
    procedure vtPersonnesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtPersonnesDblClick(Sender: TObject);
    procedure btCreateurClick(Sender: TObject);
    procedure lvAuteursKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure lvAuteursData(Sender: TObject; Item: TListItem);
    procedure btResetSerieClick(Sender: TObject);
    procedure vtSeriesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure cbxCategorieChange(Sender: TObject);
  private
    FCreation: Boolean;
    FisAchat: Boolean;
    FParaBD: TParaBDComplet;
    FDateAchat: TDateTime;
    procedure SetID_ParaBD(const Value: TGUID);
    function GetID_ParaBD: TGUID;
    { Déclarations privées }
  public
    { Déclarations publiques }
    property isCreation: Boolean read FCreation;
    property isAchat: Boolean read FisAchat write FisAchat;
    property ID_ParaBD: TGUID read GetID_ParaBD write SetID_ParaBD;
  end;

  TFrmEditAchatParaBD = class(TFrmEditParaBD)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  JvUIB, Commun, jvuiblib, CommonConst, Textes, Procedures, ProceduresBDtk, jpeg, Proc_Gestions, TypeRec, Divers,
  UHistorique;

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
  Stream: TStream;
  jpg: TJPEGImage;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  FParaBD.Fill(Value);

  lvAuteurs.Items.BeginUpdate;
  try
    edTitre.Text := FParaBD.Titre;
    edAnneeEdition.Text := NonZero(IntToStr(FParaBD.AnneeEdition));
    cbxCategorie.Value := FParaBD.CategorieParaBD;
    cbDedicace.Checked := FParaBD.Dedicace;
    cbNumerote.Checked := FParaBD.Numerote;
    description.Lines.Text := FParaBD.Description.Text;

    vtSeries.CurrentValue := FParaBD.Serie.ID_Serie;

    cbOffert.Checked := FParaBD.Offert;
    cbGratuit.Checked := FParaBD.Gratuit;
    cbOffertClick(nil);

    // artifice pour contourner un bug du TDateTimePicker
    // dtpAchat est initialisé dans le OnShow de la fenêtre
    FDateAchat := FParaBD.DateAchat;

    if FParaBD.Prix = 0 then
      edPrix.Text := ''
    else
      edPrix.Text := FormatCurr(FormatMonnaie, FParaBD.Prix);
    edAnneeCote.Text := NonZero(IntToStr(FParaBD.AnneeCote));
    if FParaBD.PrixCote = 0 then
      edPrixCote.Text := ''
    else
      edPrixCote.Text := FormatCurr(FormatMonnaie, FParaBD.PrixCote);
    cbStock.Checked := FParaBD.Stock;

    lvAuteurs.Items.Count := FParaBD.Auteurs.Count;

    if FParaBD.HasImage then cbImageBDD.Checked := FParaBD.ImageStockee;

    Stream := GetCouvertureStream(True, FParaBD.ID_ParaBD, imgVisu.Height, imgVisu.Width, Utilisateur.Options.AntiAliasing);
    if Assigned(Stream) then
    try
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
  finally
    lvAuteurs.Items.EndUpdate;
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
  FParaBD.Free;
end;

procedure TFrmEditParaBD.FormCreate(Sender: TObject);
begin
  PrepareLV(Self);
  FrameRechercheRapideSerie.VirtualTreeView := vtSeries;
  FrameRechercheRapideAuteur.VirtualTreeView := vtPersonnes;
  vtSeries.Mode := vmSeries;
  vtPersonnes.Mode := vmPersonnes;

  LoadCombo(7 {Catégorie ParaBD}, cbxCategorie);

  FParaBD := TParaBDComplet.Create;

  VDTButton1.Click;
end;

procedure TFrmEditParaBD.btnOKClick(Sender: TObject);
var
  AnneeCote: Integer;
  PrixCote: Currency;
  hg: IHourGlass;
begin
  if Utilisateur.Options.SerieObligatoireParaBD and IsEqualGUID(vtSeries.CurrentValue, GUID_NULL) then
  begin
    AffMessage(rsSerieObligatoire, mtInformation, [mbOk], True);
    FrameRechercheRapideSerie.edSearch.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;
  if (Length(Trim(edTitre.Text)) = 0) and IsEqualGUID(vtSeries.CurrentValue, GUID_NULL) then
  begin
    AffMessage(rsTitreObligatoireParaBDSansSerie, mtInformation, [mbOk], True);
    edTitre.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;
  if cbxCategorie.Value = -1 then
  begin
    AffMessage(rsTypeParaBDObligatoire, mtInformation, [mbOk], True);
    // cbxType.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;

  AnneeCote := StrToIntDef(edAnneeCote.Text, 0);
  PrixCote := StrToCurrDef(StringReplace(edPrixCote.Text, Utilisateur.Options.SymboleMonnetaire, '', []), 0);
  if (AnneeCote * PrixCote = 0) and (AnneeCote + PrixCote <> 0) then
  begin
    // une cote doit être composée d'une année ET d'un prix
    AffMessage(rsCoteIncomplete, mtInformation, [mbOk], True);
    edAnneeCote.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;

  hg := THourGlass.Create;

  FParaBD.Titre := Trim(edTitre.Text);
  FParaBD.AnneeEdition := StrToIntDef(edAnneeEdition.Text, 0);
  FParaBD.CategorieParaBD := cbxCategorie.Value;
  FParaBD.Dedicace := cbDedicace.Checked;
  FParaBD.Numerote := cbNumerote.Checked;
  FParaBD.Description.Text := description.Lines.Text;
  FParaBD.AnneeCote := AnneeCote;
  FParaBD.PrixCote := PrixCote;
  FParaBD.Gratuit := cbGratuit.Checked;
  FParaBD.Offert := cbOffert.Checked;
  if dtpAchat.Checked then
    FParaBD.DateAchat := Trunc(dtpAchat.Date)
  else
    FParaBD.DateAchat := 0;
  FParaBD.Prix := StrToCurrDef(StringReplace(edPrix.Text, Utilisateur.Options.SymboleMonnetaire, '', []), 0);
  FParaBD.Stock := cbStock.Checked;

  FParaBD.ImageStockee := cbImageBDD.Checked;

  FParaBD.SaveToDatabase;
  if isAchat then FParaBD.Acheter(False);

  ModalResult := mrOk;
end;

procedure TFrmEditParaBD.VDTButton1Click(Sender: TObject);
begin
  imgVisu.Picture := nil;
  FParaBD.FichierImage := '';
  cbImageBDD.Checked := Utilisateur.Options.ImagesStockees;
  FParaBD.HasImage := False;
end;

procedure TFrmEditParaBD.ChoixImageClick(Sender: TObject);
var
  Stream: TStream;
  jpg: TJPEGImage;
begin
  with ChoixImageDialog do
  begin
    Options := Options - [ofAllowMultiSelect];
    Filter := GraphicFilter(TGraphic);
    InitialDir := RepImages;
    FileName := '';
    if Execute then
    begin
      FParaBD.FichierImage := FileName;
      Stream := GetCouvertureStream(FParaBD.FichierImage, imgVisu.Height, imgVisu.Width, Utilisateur.Options.AntiAliasing);
      if Assigned(Stream) then
      try
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
    while Result and (i <= Pred(LV.Items.Count)) do
    begin
      Result := not IsEqualGUID(TAuteur(LV.Items[i].Data).Personne.ID, IdPersonne);
      Inc(i);
    end;
  end;

begin
  IdPersonne := vtPersonnes.CurrentValue;
  btCreateur.Enabled := (not IsEqualGUID(IdPersonne, GUID_NULL)) and NotIn(lvAuteurs);
end;

type
  PRefresh = ^RRefresh;
  RRefresh = record
    F: TFrmEditParaBD;
    iCurrentAuteur: TGUID;
  end;

procedure RefreshAuteurs(Data: PRefresh);
var
  i: Integer;
  Auteur: TAuteur;
  CurrentAuteur: TPersonnage;
begin
  with Data.F do
  begin
    CurrentAuteur := vtPersonnes.GetFocusedNodeData;
    for i := 0 to Pred(lvAuteurs.Items.Count) do
    begin
      Auteur := lvAuteurs.Items[i].Data;
      if IsEqualGUID(Auteur.Personne.ID, Data.iCurrentAuteur) then
      begin
        Auteur.Personne.Assign(CurrentAuteur);
        lvAuteurs.Items[i].Caption := Auteur.ChaineAffichage;
      end;
    end;
    lvAuteurs.Invalidate;
  end;
end;

var
  R: RRefresh;

procedure TFrmEditParaBD.vtPersonnesDblClick(Sender: TObject);
begin
  R.F := Self;
  R.iCurrentAuteur := vtPersonnes.CurrentValue;
  Historique.AddWaiting(fcGestionModif, @RefreshAuteurs, @R, @ModifierAuteurs, vtPersonnes);
end;

procedure TFrmEditParaBD.btCreateurClick(Sender: TObject);
var
  PA: TAuteur;
begin
  if IsEqualGUID(vtPersonnes.CurrentValue, GUID_NULL) then Exit;
  PA := TAuteur.Create;
  PA.Fill(TPersonnage(vtPersonnes.GetFocusedNodeData), ID_ParaBD, GUID_NULL, 0);
  FParaBD.Auteurs.Add(PA);
  lvAuteurs.Items.Count := FParaBD.Auteurs.Count;
  lvAuteurs.Invalidate;
  vtPersonnesChange(vtPersonnes, vtPersonnes.FocusedNode);
end;

procedure TFrmEditParaBD.lvAuteursKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  src: TListView;
begin
  if Key <> VK_DELETE then Exit;
  src := TListView(Sender);
  if src = lvAuteurs then FParaBD.Auteurs.Delete(src.Selected.Index);
  lvAuteurs.Items.Count := FParaBD.Auteurs.Count;
  src.Invalidate;
  vtPersonnesChange(vtPersonnes, vtPersonnes.FocusedNode);
end;

procedure TFrmEditParaBD.FormShow(Sender: TObject);
begin
  // code pour contourner un bug du TDateTimePicker
  // Cheched := False est réinitialisé au premier affichage du compo (à la création de son handle)
  dtpAchat.Date := Now;
  dtpAchat.Checked := FDateAchat > 0;
  if dtpAchat.Checked then dtpAchat.Date := FDateAchat;
end;

function TFrmEditParaBD.GetID_ParaBD: TGUID;
begin
  Result := FParaBD.ID_ParaBD;
end;

procedure TFrmEditParaBD.lvAuteursData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FParaBD.Auteurs[Item.Index];
  Item.Caption := TAuteur(Item.Data).ChaineAffichage;
end;

procedure TFrmEditParaBD.btResetSerieClick(Sender: TObject);
begin
  vtSeries.CurrentValue := GUID_NULL;
end;

procedure TFrmEditParaBD.vtSeriesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  FParaBD.Serie.Fill(vtSeries.CurrentValue);
  btResetSerie.Enabled := not IsEqualGUID(FParaBD.Serie.ID_Serie, GUID_NULL);
end;

procedure TFrmEditParaBD.cbxCategorieChange(Sender: TObject);
begin
  if cbxCategorie.Value = 0 then
    btCreateur.Caption := 'Auteur'
  else
    btCreateur.Caption := 'Créateur';
end;

end.

