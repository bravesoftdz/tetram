unit UfrmEditParaBD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, EditLabeled, VirtualTrees, ComCtrls, VDTButton,
  VirtualTree, ComboCheck, ExtCtrls, Buttons, UframRechercheRapide, ExtDlgs, LoadComplet,
  CRFurtif, UframBoutons, UBdtForms, PngSpeedButton, UframVTEdit;

type
  TfrmEditParaBD = class(TbdtForm)
    ScrollBox: TScrollBox;
    Label2: TLabel;
    Label6: TLabel;
    btCreateur: TVDTButton;
    Label19: TLabel;
    Bevel1: TBevel;
    Label20: TLabel;
    Bevel4: TBevel;
    edTitre: TEditLabeled;
    description: TMemoLabeled;
    lvAuteurs: TVDTListViewLabeled;
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
    Panel4: TPanel;
    cbImageBDD: TCheckBoxLabeled;
    VDTButton1: TCRFurtifLight;
    ChoixImageDialog: TOpenPictureDialog;
    Frame11: TframBoutons;
    Bevel2: TBevel;
    vtEditSeries: TframVTEdit;
    vtEditPersonnes: TframVTEdit;
    Bevel3: TBevel;
    Label28: TLabel;
    vtEditUnivers: TframVTEdit;
    Label11: TLabel;
    procedure cbOffertClick(Sender: TObject);
    procedure cbGratuitClick(Sender: TObject);
    procedure edPrixChange(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure VDTButton14Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure VDTButton1Click(Sender: TObject);
    procedure ChoixImageClick(Sender: TObject);
    procedure btCreateurClick(Sender: TObject);
    procedure lvAuteursKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure lvAuteursData(Sender: TObject; Item: TListItem);
    procedure cbxCategorieChange(Sender: TObject);
    procedure vtEditSeriesVTEditChange(Sender: TObject);
    procedure vtEditPersonnesVTEditChange(Sender: TObject);
    procedure OnEditPersonnes(Sender: TObject);
  private
    FCreation: Boolean;
    FisAchat: Boolean;
    FParaBD: TParaBDComplet;
    FDateAchat: TDateTime;
    procedure SetParaBD(const Value: TParaBDComplet);
    function GetID_ParaBD: TGUID;
    { Déclarations privées }
  public
    { Déclarations publiques }
    property isCreation: Boolean read FCreation;
    property isAchat: Boolean read FisAchat write FisAchat;
    property ID_ParaBD: TGUID read GetID_ParaBD;
    property ParaBD: TParaBDComplet read FParaBD write SetParaBD;
  end;

  TFrmEditAchatParaBD = class(TfrmEditParaBD)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  Commun, CommonConst, Textes, Procedures, ProceduresBDtk, jpeg, Proc_Gestions, TypeRec, Divers, UHistorique,
  UMetadata;

{$R *.dfm}
{ TFrmEditAchatParaBD }

constructor TFrmEditAchatParaBD.Create(AOwner: TComponent);
begin
  inherited;
  FisAchat := True;
end;

{ TFrmEditParaBD }

procedure TfrmEditParaBD.SetParaBD(const Value: TParaBDComplet);
var
  Stream: TStream;
  jpg: TJPEGImage;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  FParaBD := Value;

  lvAuteurs.Items.BeginUpdate;
  try
    edTitre.Text := FParaBD.TitreParaBD;
    edAnneeEdition.Text := NonZero(IntToStr(FParaBD.AnneeEdition));
    cbxCategorie.Value := FParaBD.CategorieParaBD.Value;
    cbDedicace.Checked := FParaBD.Dedicace;
    cbNumerote.Checked := FParaBD.Numerote;
    description.Text := FParaBD.description.Text;

    vtEditSeries.CurrentValue := FParaBD.Serie.ID_Serie;

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

    if FParaBD.HasImage then
      cbImageBDD.Checked := FParaBD.ImageStockee;

    Stream := GetCouvertureStream(True, FParaBD.ID_ParaBD, imgVisu.Height, imgVisu.Width, TGlobalVar.Utilisateur.Options.AntiAliasing);
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

procedure TfrmEditParaBD.cbOffertClick(Sender: TObject);
begin
  if cbOffert.Checked then
    Label18.Caption := rsTransOffertLe
  else
    Label18.Caption := rsTransAcheteLe;
end;

procedure TfrmEditParaBD.cbGratuitClick(Sender: TObject);
begin
  if cbGratuit.Checked then
    edPrix.Text := '';
end;

procedure TfrmEditParaBD.edPrixChange(Sender: TObject);
begin
  if edPrix.Text <> '' then
    cbGratuit.Checked := False;
end;

procedure TfrmEditParaBD.SpeedButton3Click(Sender: TObject);
var
  c: Currency;
begin
  c := StrToCurrDef(StringReplace(edPrix.Text, TGlobalVar.Utilisateur.Options.SymboleMonnetaire, '', []), 0);
  if Convertisseur(SpeedButton3, c) then
    if edPrix.Focused then
      edPrix.Text := FormatCurr(FormatMonnaieSimple, c)
    else
      edPrix.Text := FormatCurr(FormatMonnaie, c);
end;

procedure TfrmEditParaBD.VDTButton14Click(Sender: TObject);
var
  c: Currency;
begin
  c := StrToCurrDef(StringReplace(edPrixCote.Text, TGlobalVar.Utilisateur.Options.SymboleMonnetaire, '', []), 0);
  if Convertisseur(SpeedButton3, c) then
    if edPrixCote.Focused then
      edPrixCote.Text := FormatCurr(FormatMonnaieSimple, c)
    else
      edPrixCote.Text := FormatCurr(FormatMonnaie, c);
end;

procedure TfrmEditParaBD.FormActivate(Sender: TObject);
begin
  Invalidate;
end;

procedure TfrmEditParaBD.FormCreate(Sender: TObject);
begin
  PrepareLV(Self);
  vtEditSeries.Mode := vmSeries;
  vtEditSeries.VTEdit.LinkControls.Add(Label20);
  vtEditUnivers.Mode := vmUnivers;
  vtEditUnivers.VTEdit.LinkControls.Add(Label11);
  vtEditPersonnes.Mode := vmPersonnes;
  vtEditPersonnes.VTEdit.LinkControls.Add(Label19);
  vtEditPersonnes.AfterEdit := OnEditPersonnes;

  LoadCombo(7 { Catégorie ParaBD } , cbxCategorie);

  VDTButton1.Click;
end;

procedure TfrmEditParaBD.btnOKClick(Sender: TObject);
var
  AnneeCote: Integer;
  PrixCote: Currency;
  hg: IHourGlass;
begin
  if TGlobalVar.Utilisateur.Options.SerieObligatoireParaBD and IsEqualGUID(vtEditSeries.CurrentValue, GUID_NULL) then
  begin
    AffMessage(rsSerieObligatoire, mtInformation, [mbOk], True);
    vtEditSeries.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;
  if (Length(Trim(edTitre.Text)) = 0) and IsEqualGUID(vtEditSeries.CurrentValue, GUID_NULL) then
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
  PrixCote := StrToCurrDef(StringReplace(edPrixCote.Text, TGlobalVar.Utilisateur.Options.SymboleMonnetaire, '', []), 0);
  if (AnneeCote * PrixCote = 0) and (AnneeCote + PrixCote <> 0) then
  begin
    // une cote doit être composée d'une année ET d'un prix
    AffMessage(rsCoteIncomplete, mtInformation, [mbOk], True);
    edAnneeCote.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;

  hg := THourGlass.Create;

  FParaBD.TitreParaBD := Trim(edTitre.Text);
  FParaBD.AnneeEdition := StrToIntDef(edAnneeEdition.Text, 0);
  FParaBD.CategorieParaBD := MakeOption(cbxCategorie.Value, cbxCategorie.Caption);
  FParaBD.Dedicace := cbDedicace.Checked;
  FParaBD.Numerote := cbNumerote.Checked;
  FParaBD.description.Text := description.Text;
  FParaBD.AnneeCote := AnneeCote;
  FParaBD.PrixCote := PrixCote;
  FParaBD.Gratuit := cbGratuit.Checked;
  FParaBD.Offert := cbOffert.Checked;
  if dtpAchat.Checked then
    FParaBD.DateAchat := Trunc(dtpAchat.Date)
  else
    FParaBD.DateAchat := 0;
  FParaBD.Prix := StrToCurrDef(StringReplace(edPrix.Text, TGlobalVar.Utilisateur.Options.SymboleMonnetaire, '', []), 0);
  FParaBD.Stock := cbStock.Checked;

  FParaBD.ImageStockee := cbImageBDD.Checked;

  FParaBD.SaveToDatabase;
  if isAchat then
    FParaBD.Acheter(False);

  ModalResult := mrOk;
end;

procedure TfrmEditParaBD.VDTButton1Click(Sender: TObject);
begin
  imgVisu.Picture := nil;
  FParaBD.FichierImage := '';
  cbImageBDD.Checked := TGlobalVar.Utilisateur.Options.ImagesStockees;
  FParaBD.HasImage := False;
end;

procedure TfrmEditParaBD.ChoixImageClick(Sender: TObject);
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
      Stream := GetCouvertureStream(FParaBD.FichierImage, imgVisu.Height, imgVisu.Width, TGlobalVar.Utilisateur.Options.AntiAliasing);
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

procedure TfrmEditParaBD.vtEditPersonnesVTEditChange(Sender: TObject);
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
  IdPersonne := vtEditPersonnes.CurrentValue;
  btCreateur.Enabled := (not IsEqualGUID(IdPersonne, GUID_NULL)) and NotIn(lvAuteurs);
end;

procedure TfrmEditParaBD.vtEditSeriesVTEditChange(Sender: TObject);
begin
  FParaBD.Serie.Fill(vtEditSeries.CurrentValue);
  vtEditUnivers.Visible := IsEqualGUID(FParaBD.Serie.ID_Serie, GUID_NULL);
  Label11.Visible := IsEqualGUID(FParaBD.Serie.ID_Serie, GUID_NULL);
end;

procedure TfrmEditParaBD.OnEditPersonnes(Sender: TObject);
var
  i: Integer;
  Auteur: TAuteur;
  CurrentAuteur: TPersonnage;
begin
  CurrentAuteur := vtEditPersonnes.VTEdit.Data;
  for i := 0 to Pred(lvAuteurs.Items.Count) do
  begin
    Auteur := lvAuteurs.Items[i].Data;
    if IsEqualGUID(Auteur.Personne.ID, vtEditPersonnes.CurrentValue) then
    begin
      Auteur.Personne.Assign(CurrentAuteur);
      lvAuteurs.Items[i].Caption := Auteur.ChaineAffichage;
    end;
  end;
  lvAuteurs.Invalidate;
end;

procedure TfrmEditParaBD.btCreateurClick(Sender: TObject);
var
  PA: TAuteur;
begin
  if IsEqualGUID(vtEditPersonnes.CurrentValue, GUID_NULL) then
    Exit;
  PA := TAuteur.Create;
  PA.Fill(TPersonnage(vtEditPersonnes.VTEdit.Data), ID_ParaBD, GUID_NULL, TMetierAuteur(0));
  FParaBD.Auteurs.Add(PA);
  lvAuteurs.Items.Count := FParaBD.Auteurs.Count;
  lvAuteurs.Invalidate;
  vtEditPersonnesVTEditChange(vtEditPersonnes.VTEdit);
end;

procedure TfrmEditParaBD.lvAuteursKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  src: TListView;
begin
  if Key <> VK_DELETE then
    Exit;
  src := TListView(Sender);
  if src = lvAuteurs then
    FParaBD.Auteurs.Delete(src.Selected.Index);
  lvAuteurs.Items.Count := FParaBD.Auteurs.Count;
  src.Invalidate;
  vtEditPersonnesVTEditChange(vtEditPersonnes.VTEdit);
end;

procedure TfrmEditParaBD.FormShow(Sender: TObject);
begin
  // code pour contourner un bug du TDateTimePicker
  // Cheched := False est réinitialisé au premier affichage du compo (à la création de son handle)
  dtpAchat.Date := Now;
  dtpAchat.Checked := FDateAchat > 0;
  if dtpAchat.Checked then
    dtpAchat.Date := FDateAchat;
end;

function TfrmEditParaBD.GetID_ParaBD: TGUID;
begin
  Result := FParaBD.ID_ParaBD;
end;

procedure TfrmEditParaBD.lvAuteursData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FParaBD.Auteurs[Item.Index];
  Item.Caption := TAuteur(Item.Data).ChaineAffichage;
end;

procedure TfrmEditParaBD.cbxCategorieChange(Sender: TObject);
begin
  if cbxCategorie.Value = 0 then
    btCreateur.Caption := 'Auteur'
  else
    btCreateur.Caption := 'Créateur';
end;

end.
