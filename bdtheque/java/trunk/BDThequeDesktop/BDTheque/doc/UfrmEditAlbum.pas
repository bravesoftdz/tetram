unit UfrmEditAlbum;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, System.UITypes, ExtCtrls, DBCtrls, StdCtrls, ImgList, EditLabeled,
  VDTButton, ExtDlgs, Mask, ComCtrls, Buttons, VirtualTrees, VirtualTreeBdtk, Menus, Entities.Lite, ActnList, Entities.Full, ComboCheck,
  UframRechercheRapide, UframBoutons, UBdtForms, Generics.Collections, StrUtils,
  JvExMask, JvToolEdit, UVirtualTreeEdit, UfrmFond, PngSpeedButton,
  UframVTEdit, LoadCompletImport;

type
  TfrmEditAlbum = class(TbdtForm)
    ScrollBox: TScrollBox;
    ChoixImageDialog: TOpenPictureDialog;
    ImageList1: TImageList;
    Label3: TLabel;
    edAnneeParution: TEditLabeled;
    edTitre: TEditLabeled;
    Label2: TLabel;
    histoire: TMemoLabeled;
    Label6: TLabel;
    remarques: TMemoLabeled;
    Label7: TLabel;
    lvScenaristes: TVDTListViewLabeled;
    btScenariste: TVDTButton;
    lvDessinateurs: TVDTListViewLabeled;
    btDessinateur: TVDTButton;
    Label19: TLabel;
    vstImages: TVirtualStringTree;
    ChoixImage: TVDTButton;
    VDTButton4: TVDTButton;
    VDTButton5: TVDTButton;
    Bevel1: TBevel;
    Label20: TLabel;
    btColoriste: TVDTButton;
    lvColoristes: TVDTListViewLabeled;
    cbIntegrale: TCheckBoxLabeled;
    Label1: TLabel;
    edTome: TEditLabeled;
    Label4: TLabel;
    vtEditions: TListBoxLabeled;
    VDTButton3: TVDTButton;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    cbHorsSerie: TCheckBoxLabeled;
    Label17: TLabel;
    imgVisu: TImage;
    PanelEdition: TPanel;
    SpeedButton3: TVDTButton;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    VDTButton6: TVDTButton;
    Label12: TLabel;
    Label13: TLabel;
    cbxEtat: TLightComboCheck;
    cbxReliure: TLightComboCheck;
    Label14: TLabel;
    cbxEdition: TLightComboCheck;
    Label18: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    cbxOrientation: TLightComboCheck;
    Label23: TLabel;
    cbxFormat: TLightComboCheck;
    VDTButton13: TVDTButton;
    edPrix: TEditLabeled;
    edAnneeEdition: TEditLabeled;
    edISBN: TEditLabeled;
    cbVO: TCheckBoxLabeled;
    cbCouleur: TCheckBoxLabeled;
    cbStock: TCheckBoxLabeled;
    cbDedicace: TCheckBoxLabeled;
    dtpAchat: TDateTimePickerLabeled;
    cbGratuit: TCheckBoxLabeled;
    cbOffert: TCheckBoxLabeled;
    edNombreDePages: TEditLabeled;
    edMoisParution: TEditLabeled;
    Label24: TLabel;
    edAnneeCote: TEditLabeled;
    Label25: TLabel;
    edPrixCote: TEditLabeled;
    VDTButton14: TVDTButton;
    pmChoixCategorie: TPopupMenu;
    Bevel2: TBevel;
    Frame11: TframBoutons;
    edNumPerso: TEditLabeled;
    Label26: TLabel;
    Label27: TLabel;
    cbxSensLecture: TLightComboCheck;
    edTomeFin: TEditLabeled;
    edTomeDebut: TEditLabeled;
    Label16: TLabel;
    vtEditSerie: TframVTEdit;
    vtEditCollections: TframVTEdit;
    Label8: TLabel;
    vtEditEditeurs: TframVTEdit;
    Label5: TLabel;
    Label15: TLabel;
    edNotes: TMemoLabeled;
    Bevel6: TBevel;
    vtEditPersonnes: TframVTEdit;
    btnScript: TButton;
    Label28: TLabel;
    vtEditUnivers: TframVTEdit;
    Label29: TLabel;
    btUnivers: TVDTButton;
    lvUnivers: TVDTListViewLabeled;
    procedure ajoutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ChoixImageClick(Sender: TObject);
    procedure edTitreChange(Sender: TObject);
    procedure lvDessinateursKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure vstImagesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure VDTButton4Click(Sender: TObject);
    procedure VDTButton5Click(Sender: TObject);
    procedure OnNewSerie(Sender: TObject);
    procedure OnEditSerie(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure longueur2KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure vstImagesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstImagesPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure vstImagesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VDTButton3Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure VDTButton6Click(Sender: TObject);
    procedure edISBNExit(Sender: TObject);
    procedure edISBNChange(Sender: TObject);
    procedure vstImagesInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstImagesChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstImagesEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vstImagesNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
    procedure edAnneeEditionChange(Sender: TObject);
    procedure vtCollectionsChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtEditionsClick(Sender: TObject);
    procedure cbIntegraleClick(Sender: TObject);
    procedure cbGratuitClick(Sender: TObject);
    procedure edPrixChange(Sender: TObject);
    procedure imgVisuClick(Sender: TObject);
    procedure vstImagesDblClick(Sender: TObject);
    procedure cbOffertClick(Sender: TObject);
    procedure vstImagesStructureChange(Sender: TBaseVirtualTree; Node: PVirtualNode; Reason: TChangeReason);
    procedure VDTButton13Click(Sender: TObject);
    procedure vtEditionsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure VDTButton14Click(Sender: TObject);
    procedure vstImagesMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure miChangeCategorieImageClick(Sender: TObject);
    procedure pmChoixCategoriePopup(Sender: TObject);
    procedure Frame11btnOKClick(Sender: TObject);
    procedure lvScenaristesData(Sender: TObject; Item: TListItem);
    procedure lvDessinateursData(Sender: TObject; Item: TListItem);
    procedure lvColoristesData(Sender: TObject; Item: TListItem);
    procedure JvComboEdit1Change(Sender: TObject);
    procedure framVTEdit1VTEditChange(Sender: TObject);
    procedure OnEditAuteurs(Sender: TObject);
    procedure vtEditEditeursVTEditChange(Sender: TObject);
    procedure vtEditCollectionsVTEditChange(Sender: TObject);
    procedure btnScriptClick(Sender: TObject);
    procedure vtEditUniversVTEditChange(Sender: TObject);
    procedure lvUniversData(Sender: TObject; Item: TListItem);
    procedure lvUniversKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btUniversClick(Sender: TObject);
  strict private
    FAlbum: TAlbumFull;
    FCurrentEditionComplete: TEditionFull;
    FEditeurCollectionSelected: array of Boolean;
    FEditionChanging: Boolean;
    FScenaristesSelected, FDessinateursSelected, FColoristesSelected: Boolean;
    FisAchat: Boolean;
    procedure UpdateEdition;
    procedure RefreshEditionCaption;
    procedure SetAlbum(Value: TAlbumFull);
    procedure VisuClose(Sender: TObject);
    procedure AjouteAuteur(List: TList<TAuteurAlbumLite>; lvList: TVDTListViewLabeled; Auteur: TPersonnageLite; var FlagAuteur: Boolean); overload;
    procedure AjouteAuteur(List: TList<TAuteurAlbumLite>; lvList: TVDTListViewLabeled; Auteur: TPersonnageLite); overload;
    function GetID_Album: TGUID;
    function GetCreation: Boolean;
  private
    FAlbumImport: TAlbumFull;
    procedure SaveToObject;
  public
    { Déclarations publiques }
    property isCreation: Boolean read GetCreation;
    property isAchat: Boolean read FisAchat write FisAchat;
    property ID_Album: TGUID read GetID_Album;
    property Album: TAlbumFull read FAlbum write SetAlbum;
  end;

implementation

uses
  Commun, CommonConst, Textes, Divers, Proc_Gestions, Procedures, ProceduresBDtk, Types, jpeg, DateUtils,
  UHistorique, UMetadata, Entities.DaoLite, Entities.DaoFull, Entities.Common, Entities.Types,
  Entities.FactoriesLite, Entities.FactoriesFull, Entities.DaoLambda;

{$R *.DFM}

const
  RemplacerValeur = 'Remplacer %s par %s ?';

  { TFrmEditAlbum }

procedure TfrmEditAlbum.FormCreate(Sender: TObject);
var
  i: Integer;
  mi: TMenuItem;
begin
  PrepareLV(Self);

  vtEditSerie.VTEdit.LinkControls.Add(Label20);
  vtEditEditeurs.VTEdit.LinkControls.Add(Label5);
  vtEditCollections.VTEdit.LinkControls.Add(Label8);

  vtEditSerie.AfterAppend := OnNewSerie;
  vtEditSerie.AfterEdit := OnEditSerie;
  vtEditPersonnes.AfterEdit := OnEditAuteurs;

  SetLength(FEditeurCollectionSelected, 0);
  FCurrentEditionComplete := nil;
  vtEditPersonnes.Mode := vmPersonnes;
  vtEditEditeurs.Mode := vmEditeurs;
  vtEditUnivers.Mode := vmUnivers;
  vtEditCollections.Mode := vmNone;
  vtEditCollections.VTEdit.PopupWindow.TreeView.UseFiltre := True;
  vtEditSerie.Mode := vmSeries;
  vstImages.LinkControls.Clear;
  vstImages.LinkControls.Add(ChoixImage);
  vstImages.LinkControls.Add(VDTButton4);
  vstImages.LinkControls.Add(VDTButton5);
  vstImages.Mode := vmNone;
  vstImages.CheckImageKind := ckXP;
  vstImages.TreeOptions.StringOptions := [];
  vstImages.TreeOptions.MiscOptions := vstImages.TreeOptions.MiscOptions + [toCheckSupport];
  vstImages.TreeOptions.PaintOptions := vstImages.TreeOptions.PaintOptions - [toShowButtons, toShowRoot, toShowTreeLines];
  FEditionChanging := False;
  edPrix.CurrencyChar := TGlobalVar.Utilisateur.Options.SymboleMonnetaire[1];
  FScenaristesSelected := False;
  FDessinateursSelected := False;
  FColoristesSelected := False;

  LoadCombo(cbxEtat, TDaoListe.ListEtats, TDaoListe.DefaultEtat);
  LoadCombo(cbxReliure, TDaoListe.ListReliures, TDaoListe.DefaultReliure);
  LoadCombo(cbxEdition, TDaoListe.ListTypesEdition, TDaoListe.DefaultTypeEdition);
  LoadCombo(cbxOrientation, TDaoListe.ListOrientations, TDaoListe.DefaultOrientation);
  LoadCombo(cbxFormat, TDaoListe.ListFormatsEdition, TDaoListe.DefaultFormatEdition);
  LoadCombo(cbxSensLecture, TDaoListe.ListSensLecture, TDaoListe.DefaultSensLecture);

  for i := 0 to Pred(TDaoListe.ListTypesCouverture.Count) do
  begin
    mi := TMenuItem.Create(pmChoixCategorie);
    mi.Caption := TDaoListe.ListTypesCouverture.ValueFromIndex[i];
    mi.Tag := StrToInt(TDaoListe.ListTypesCouverture.Names[i]);
    mi.OnClick := miChangeCategorieImageClick;
    pmChoixCategorie.Items.Add(mi);
  end;
end;

procedure TfrmEditAlbum.SetAlbum(Value: TAlbumFull);
var
  i: Integer;
  PE: TEditionFull;
  hg: IHourGlass;
  OldvtEditionsItemIndex: Integer;
begin
  hg := THourGlass.Create;
  FAlbum := Value;

  lvScenaristes.Items.BeginUpdate;
  lvDessinateurs.Items.BeginUpdate;
  lvColoristes.Items.BeginUpdate;
  vtEditions.Items.BeginUpdate;
  try
    edTitre.Text := FAlbum.TitreAlbum;
    edMoisParution.Text := NonZero(IntToStr(FAlbum.MoisParution));
    edAnneeParution.Text := NonZero(IntToStr(FAlbum.AnneeParution));
    edTome.Text := NonZero(IntToStr(FAlbum.Tome));
    edTomeDebut.Text := NonZero(IntToStr(FAlbum.TomeDebut));
    edTomeFin.Text := NonZero(IntToStr(FAlbum.TomeFin));
    cbIntegrale.Checked := FAlbum.Integrale;
    cbHorsSerie.Checked := FAlbum.HorsSerie;
    histoire.Text := FAlbum.Sujet;
    remarques.Text := FAlbum.Notes;
    cbIntegraleClick(cbIntegrale);

    lvUnivers.Items.Count := FAlbum.Univers.Count;
    lvScenaristes.Items.Count := FAlbum.Scenaristes.Count;
    lvDessinateurs.Items.Count := FAlbum.Dessinateurs.Count;
    lvColoristes.Items.Count := FAlbum.Coloristes.Count;

    FScenaristesSelected := lvScenaristes.Items.Count > 0;
    FDessinateursSelected := lvDessinateurs.Items.Count > 0;
    FColoristesSelected := lvColoristes.Items.Count > 0;

    vtEditSerie.VTEdit.OnChange := nil;
    vtEditSerie.CurrentValue := FAlbum.ID_Serie;
    vtEditSerie.VTEdit.OnChange := JvComboEdit1Change;

    // tout ce mic mac pour l'actualisation par script
    OldvtEditionsItemIndex := vtEditions.ItemIndex;
    FCurrentEditionComplete := nil;
    vtEditions.Clear;
    vtEditionsClick(nil);
    SetLength(FEditeurCollectionSelected, FAlbum.Editions.Count);
    for i := 0 to Pred(FAlbum.Editions.Count) do
    begin
      PE := FAlbum.Editions[i];
      FEditeurCollectionSelected[i] := True;
      vtEditions.AddItem(PE.ChaineAffichage, PE);
    end;
    vtEditions.ItemIndex := OldvtEditionsItemIndex;
    vtEditionsClick(nil);

    if (FAlbum.RecInconnu and (FAlbum.Editions.Count = 0)) or isAchat then
      VDTButton3.Click;
  finally
    vtEditions.Items.EndUpdate;
    lvScenaristes.Items.EndUpdate;
    lvDessinateurs.Items.EndUpdate;
    lvColoristes.Items.EndUpdate;
  end;
end;

procedure TfrmEditAlbum.AjouteAuteur(List: TList<TAuteurAlbumLite>; lvList: TVDTListViewLabeled; Auteur: TPersonnageLite);
var
  dummy: Boolean;
begin
  AjouteAuteur(List, lvList, Auteur, dummy);
end;

procedure TfrmEditAlbum.AjouteAuteur(List: TList<TAuteurAlbumLite>; lvList: TVDTListViewLabeled; Auteur: TPersonnageLite; var FlagAuteur: Boolean);
var
  PA: TAuteurAlbumLite;
begin
  PA := TFactoryAuteurAlbumLite.getInstance;
  TDaoAuteurAlbumLite.Fill(PA, Auteur, ID_Album, GUID_NULL, TMetierAuteur(0));
  List.Add(PA);
  lvList.Items.Count := List.Count;
  lvList.Invalidate;

  FlagAuteur := True;
end;

procedure ImportScript(frm: TfrmEditAlbum);
var
  oldIsAchat: Boolean;
begin
  try
    if frm.FAlbumImport.ReadyToFusion then
    begin
      frm.SaveToObject;
      frm.vtEditSerie.VTEdit.PopupWindow.TreeView.InitializeRep;
      frm.vtEditUnivers.VTEdit.PopupWindow.TreeView.InitializeRep;
      frm.vtEditPersonnes.VTEdit.PopupWindow.TreeView.InitializeRep;
      frm.vtEditEditeurs.VTEdit.PopupWindow.TreeView.InitializeRep;
      frm.vtEditCollections.VTEdit.PopupWindow.TreeView.InitializeRep;
      TDaoAlbumFull.FusionneInto(frm.FAlbumImport, frm.Album);
      oldIsAchat := frm.isAchat;
      try
        frm.isAchat := False;
        frm.Album := frm.Album; // recharger la fenêtre avec frm.Album
      finally
        frm.isAchat := oldIsAchat;
      end;
    end;
  finally
    FreeAndNil(frm.FAlbumImport);
  end;
end;

procedure TfrmEditAlbum.btnScriptClick(Sender: TObject);
begin
  FreeAndNil(FAlbumImport); // si on a annulé la précédente maj par script, l'objet n'avait pas été détruit
  FAlbumImport := TDaoAlbumFull.getInstance;
  if FAlbum.TitreAlbum <> '' then
    FAlbumImport.DefaultSearch := FormatTitre(FAlbum.TitreAlbum)
  else
    FAlbumImport.DefaultSearch := FormatTitre(FAlbum.Serie.TitreSerie);
  Historique.AddWaiting(fcScripts, @ImportScript, Self, nil, FAlbumImport);
end;

procedure TfrmEditAlbum.btUniversClick(Sender: TObject);
begin
  if IsEqualGUID(vtEditUnivers.CurrentValue, GUID_NULL) then
    Exit;

  FAlbum.Univers.Add(TFactoryUniversLite.Duplicate(TUniversLite(vtEditUnivers.VTEdit.Data)));
  lvUnivers.Items.Count := FAlbum.Univers.Count;
  lvUnivers.Invalidate;

  vtEditUniversVTEditChange(vtEditUnivers.VTEdit);
end;

procedure TfrmEditAlbum.ajoutClick(Sender: TObject);
begin
  if IsEqualGUID(vtEditPersonnes.CurrentValue, GUID_NULL) then
    Exit;
  case TSpeedButton(Sender).Tag of
    1:
      AjouteAuteur(FAlbum.Scenaristes, lvScenaristes, TPersonnageLite(vtEditPersonnes.VTEdit.Data), FScenaristesSelected);
    2:
      AjouteAuteur(FAlbum.Dessinateurs, lvDessinateurs, TPersonnageLite(vtEditPersonnes.VTEdit.Data), FDessinateursSelected);
    3:
      AjouteAuteur(FAlbum.Coloristes, lvColoristes, TPersonnageLite(vtEditPersonnes.VTEdit.Data), FColoristesSelected);
  end;
  framVTEdit1VTEditChange(vtEditPersonnes.VTEdit);
end;

procedure TfrmEditAlbum.lvDessinateursKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  src: TListView;
begin
  if Key <> VK_DELETE then
    Exit;
  src := TListView(Sender);
  if src = lvScenaristes then
    FAlbum.Scenaristes.Delete(src.Selected.Index);
  if src = lvDessinateurs then
    FAlbum.Dessinateurs.Delete(src.Selected.Index);
  if src = lvColoristes then
    FAlbum.Coloristes.Delete(src.Selected.Index);
  lvScenaristes.Items.Count := FAlbum.Scenaristes.Count;
  lvDessinateurs.Items.Count := FAlbum.Dessinateurs.Count;
  lvColoristes.Items.Count := FAlbum.Coloristes.Count;
  src.Invalidate;
  framVTEdit1VTEditChange(vtEditPersonnes.VTEdit);
end;

procedure TfrmEditAlbum.FormDestroy(Sender: TObject);
begin
  lvScenaristes.Items.Count := 0;
  lvDessinateurs.Items.Count := 0;
  lvColoristes.Items.Count := 0;
  FCurrentEditionComplete := nil;
  vtEditions.Clear;
  FreeAndNil(FAlbumImport); // si on a annulé la précédente maj par script, l'objet n'avait pas été détruit
end;

procedure TfrmEditAlbum.Frame11btnOKClick(Sender: TObject);
var
  i: Integer;
  EditionComplete: TEditionFull;
  hg: IHourGlass;
  AfficheEdition, lISBN: Integer;
  cs: string;
begin
  // if TGlobalVar.Utilisateur.Options.SerieObligatoireAlbums and IsEqualGUID(vtSeries.CurrentValue, GUID_NULL) then
  if TGlobalVar.Utilisateur.Options.SerieObligatoireAlbums and IsEqualGUID(vtEditSerie.CurrentValue, GUID_NULL) then
  begin
    AffMessage(rsSerieObligatoire, mtInformation, [mbOk], True);
    vtEditSerie.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;
  // if (Length(Trim(edTitre.Text)) = 0) and IsEqualGUID(vtSeries.CurrentValue, GUID_NULL) then
  if (Length(Trim(edTitre.Text)) = 0) and IsEqualGUID(vtEditSerie.CurrentValue, GUID_NULL) then
  begin
    AffMessage(rsTitreObligatoireAlbumSansSerie, mtInformation, [mbOk], True);
    edTitre.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;
  if not(StrToIntDef(edMoisParution.Text, 1) in [1 .. 12]) then
  begin
    AffMessage(rsMoisParutionIncorrect, mtInformation, [mbOk], True);
    edMoisParution.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;

  UpdateEdition; // force la mise à jour du REditionComplete en cours si c pas déjà fait

  AfficheEdition := -1;
  for i := 0 to Pred(vtEditions.Items.Count) do
  begin
    EditionComplete := TEditionFull(vtEditions.Items.Objects[i]);
    if IsEqualGUID(EditionComplete.Editeur.ID_Editeur, GUID_NULL) then
    begin
      AffMessage(rsEditeurObligatoire, mtInformation, [mbOk], True);
      AfficheEdition := i;
    end;
    cs := EditionComplete.ISBN;
    if cs = '' then
    begin
      // l'utilisation de l'isbn n'étant obligatoire que depuis "quelques années", les bd anciennes n'en n'ont pas: donc pas obligatoire de le saisir
      // AffMessage('Le numéro ISBN est obligatoire !', mtInformation, [mbOk], True);
      // AfficheEdition := i;
    end;
    lISBN := Length(cs);
    if not(lISBN in [10, 13]) then
      if (EditionComplete.AnneeEdition = 0) or (EditionComplete.AnneeEdition >= 2007) then
        lISBN := 13
      else
        lISBN := 10;
    if not VerifieISBN(cs, lISBN) then
      if MessageDlg(Format(RemplacerValeur, [FormatISBN(EditionComplete.ISBN), FormatISBN(cs)]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        EditionComplete.ISBN := cs;
      end
      else
      begin
        // AffMessage('Le numéro ISBN est obligatoire !', mtInformation, [mbOk], True);
        // AfficheEdition := i;
      end;
    if (EditionComplete.AnneeCote * EditionComplete.PrixCote = 0) and (EditionComplete.AnneeCote + EditionComplete.PrixCote <> 0) then
    begin
      // une cote doit être composée d'une année ET d'un prix
      AffMessage(rsCoteIncomplete, mtInformation, [mbOk], True);
      AfficheEdition := i;
    end;
  end;
  if AfficheEdition <> -1 then
  begin
    vtEditions.ItemIndex := AfficheEdition;
    vtEditEditeurs.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;

  hg := THourGlass.Create;
  SaveToObject;

  TDaoAlbumFull.SaveToDatabase(FAlbum, nil);
  if isAchat then
    TDaoAlbumFull.Acheter(FAlbum, False);

  ModalResult := mrOk;
end;

procedure TfrmEditAlbum.SaveToObject;
var
  hg: IHourGlass;
begin
  UpdateEdition; // force la mise à jour du REditionComplete en cours si c pas déjà fait

  hg := THourGlass.Create;

  FAlbum.TitreAlbum := Trim(edTitre.Text);
  if edAnneeParution.Text = '' then
  begin
    FAlbum.AnneeParution := 0;
    FAlbum.MoisParution := 0;
  end
  else
  begin
    FAlbum.AnneeParution := StrToInt(edAnneeParution.Text);
    if edMoisParution.Text = '' then
      FAlbum.MoisParution := 0
    else
      FAlbum.MoisParution := StrToInt(edMoisParution.Text);
  end;
  FAlbum.Tome := StrToIntDef(edTome.Text, 0);
  if (not cbIntegrale.Checked) or (edTomeDebut.Text = '') then
    FAlbum.TomeDebut := 0
  else
    FAlbum.TomeDebut := StrToInt(edTomeDebut.Text);
  if (not cbIntegrale.Checked) or (edTomeFin.Text = '') then
    FAlbum.TomeFin := 0
  else
    FAlbum.TomeFin := StrToInt(edTomeFin.Text);
  FAlbum.Integrale := cbIntegrale.Checked;
  FAlbum.HorsSerie := cbHorsSerie.Checked;
  FAlbum.Sujet := histoire.Text;
  FAlbum.Notes := remarques.Text;
end;

procedure TfrmEditAlbum.framVTEdit1VTEditChange(Sender: TObject);
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
      Result := not IsEqualGUID(TAuteurLite(LV.Items[i].Data).Personne.ID, IdPersonne);
      Inc(i);
    end;
  end;

begin
  IdPersonne := vtEditPersonnes.CurrentValue;
  btScenariste.Enabled := (not IsEqualGUID(IdPersonne, GUID_NULL)) and NotIn(lvScenaristes);
  btDessinateur.Enabled := (not IsEqualGUID(IdPersonne, GUID_NULL)) and NotIn(lvDessinateurs);
  btColoriste.Enabled := (not IsEqualGUID(IdPersonne, GUID_NULL)) and NotIn(lvColoristes);
end;

procedure TfrmEditAlbum.edTitreChange(Sender: TObject);
begin
  Caption := 'Saisie d''album - ' + FormatTitre(edTitre.Text);
end;

procedure TfrmEditAlbum.ChoixImageClick(Sender: TObject);
var
  i: Integer;
  PC: TCouvertureLite;
begin
  with ChoixImageDialog do
  begin
    Options := Options + [ofAllowMultiSelect];
    Filter := GraphicFilter(TGraphic);
    InitialDir := RepImages;
    FileName := '';
    if Execute then
    begin
      vstImages.BeginUpdate;
      try
        for i := 0 to Files.Count - 1 do
        begin
          PC := TFactoryCouvertureLite.getInstance;
          FCurrentEditionComplete.Couvertures.Add(PC);
          PC.ID := GUID_NULL;
          PC.OldNom := Files[i];
          PC.NewNom := PC.OldNom;
          if FCurrentEditionComplete.Couvertures.Count = 1 then
            PC.Categorie := 600
          else
            PC.Categorie := 601;
          PC.sCategorie := TDaoListe.ListTypesCouverture.Values[IntToStr(PC.Categorie)];
        end;
      finally
        vstImages.RootNodeCount := FCurrentEditionComplete.Couvertures.Count;
        vstImages.EndUpdate;
      end;
    end;
  end;
end;

procedure TfrmEditAlbum.vstImagesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  PC: TCouvertureLite;
  hg: IHourGlass;
  ms: TStream;
  jpg: TJPEGImage;
begin
  VDTButton4.Enabled := Assigned(Node) and (Node.Index > 0);
  VDTButton5.Enabled := Assigned(Node) and (Node.Index < Pred(vstImages.RootNodeCount));

  if Assigned(Node) then
  begin
    PC := FCurrentEditionComplete.Couvertures[Node.Index];
    hg := THourGlass.Create;
    if IsEqualGUID(PC.ID, GUID_NULL) then
      ms := GetJPEGStream(PC.NewNom, imgVisu.Height, imgVisu.Width, TGlobalVar.Utilisateur.Options.AntiAliasing)
    else
      ms := GetCouvertureStream(False, PC.ID, imgVisu.Height, imgVisu.Width, TGlobalVar.Utilisateur.Options.AntiAliasing);
    if Assigned(ms) then
      try
        jpg := TJPEGImage.Create;
        try
          jpg.LoadFromStream(ms);
          imgVisu.Picture.Assign(jpg);
        finally
          FreeAndNil(jpg);
        end;
      finally
        FreeAndNil(ms);
      end;
  end
  else
    imgVisu.Picture.Assign(nil);
end;

procedure TfrmEditAlbum.vstImagesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    FCurrentEditionComplete.Couvertures.Delete(vstImages.FocusedNode.Index);
    vstImages.RootNodeCount := FCurrentEditionComplete.Couvertures.Count;
    imgVisu.Picture.Assign(nil);
    vstImages.ReinitNode(vstImages.RootNode, True);
  end;
end;

procedure TfrmEditAlbum.VDTButton4Click(Sender: TObject);
begin
  FCurrentEditionComplete.Couvertures.Move(vstImages.FocusedNode.Index, Pred(vstImages.FocusedNode.Index));
  vstImages.FocusedNode := vstImages.FocusedNode.PrevSibling;
  vstImages.Selected[vstImages.FocusedNode] := True;
  vstImages.Invalidate;
end;

procedure TfrmEditAlbum.VDTButton5Click(Sender: TObject);
begin
  FCurrentEditionComplete.Couvertures.Move(vstImages.FocusedNode.Index, Succ(vstImages.FocusedNode.Index));
  vstImages.FocusedNode := vstImages.FocusedNode.NextSibling;
  vstImages.Selected[vstImages.FocusedNode] := True;
  vstImages.Invalidate;
end;

procedure TfrmEditAlbum.OnNewSerie(Sender: TObject);
begin
  vtEditEditeurs.VTEdit.PopupWindow.TreeView.InitializeRep;
  vtEditCollections.VTEdit.PopupWindow.TreeView.InitializeRep;
  JvComboEdit1Change(vtEditSerie.VTEdit);
end;

procedure TfrmEditAlbum.OnEditSerie(Sender: TObject);
var
  i: TGUID;
begin
  // on recharge la série
  TDaoSerieFull.Fill(FAlbum.Serie, FAlbum.ID_Serie, nil);
  i := vtEditCollections.CurrentValue;
  vtEditEditeurs.VTEdit.PopupWindow.TreeView.InitializeRep;
  vtEditCollections.VTEdit.PopupWindow.TreeView.InitializeRep;
  vtEditCollections.CurrentValue := i;
  JvComboEdit1Change(vtEditSerie.VTEdit);
end;

procedure TfrmEditAlbum.FormActivate(Sender: TObject);
begin
  Invalidate;
end;

procedure TfrmEditAlbum.longueur2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = ' ' then
    Key := '0';
end;

procedure TfrmEditAlbum.FormShow(Sender: TObject);
begin
  // la selection de l'édition doit se faire ici à cause d'un bug du TDateTimePicker:
  // il se forcerait à "Checked = True" si on le fait dans le SetID_Album
  if vtEditions.ItemIndex = -1 then
  begin
    vtEditions.ItemIndex := 0;
    vtEditions.OnClick(vtEditions);
  end;
  edTitre.SetFocus;
end;

procedure TfrmEditAlbum.vstImagesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  PC: TCouvertureLite;
begin
  PC := FCurrentEditionComplete.Couvertures[Node.Index];
  CellText := '';
  case Column of
    0:
      CellText := PC.NewNom;
    1:
      CellText := PC.sCategorie;
  end;
end;

procedure TfrmEditAlbum.vstImagesPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  PC: TCouvertureLite;
begin
  PC := FCurrentEditionComplete.Couvertures[Node.Index];
  if (Column = 0) and (not IsEqualGUID(PC.ID, GUID_NULL)) then
    if vstImages.Selected[Node] then
      TargetCanvas.Font.Color := clInactiveCaption
    else
      TargetCanvas.Font.Color := clInactiveCaptionText;
end;

procedure TfrmEditAlbum.vtEditCollectionsVTEditChange(Sender: TObject);
begin
  if vtEditions.ItemIndex > -1 then
    FEditeurCollectionSelected[vtEditions.ItemIndex] := True;
  RefreshEditionCaption;
end;

procedure TfrmEditAlbum.vtEditEditeursVTEditChange(Sender: TObject);
var
  ID_Editeur: TGUID;
begin
  if vtEditions.ItemIndex > -1 then
    FEditeurCollectionSelected[vtEditions.ItemIndex] := True;

  ID_Editeur := vtEditEditeurs.CurrentValue;
  if IsEqualGUID(ID_Editeur, GUID_NULL) then
    vtEditCollections.Mode := vmNone
  else
    vtEditCollections.Mode := vmCollections;
  if not IsEqualGUID(vtEditCollections.ParentValue, ID_Editeur) then
  begin
    vtEditCollections.ParentValue := ID_Editeur;
    vtEditCollections.VTEdit.PopupWindow.TreeView.Filtre := 'ID_Editeur = ' + QuotedStr(GUIDToString(vtEditCollections.ParentValue));
    vtEditCollections.CurrentValue := GUID_NULL;
    vtEditCollections.CanCreate := not IsEqualGUID(ID_Editeur, GUID_NULL);
  end;
  RefreshEditionCaption;
end;

procedure TfrmEditAlbum.VDTButton3Click(Sender: TObject);
var
  EditionComplete: TEditionFull;
begin
  SetLength(FEditeurCollectionSelected, Succ(Length(FEditeurCollectionSelected)));
  EditionComplete := TFactoryEditionFull.getInstance;
  EditionComplete.ID_Album := ID_Album;
  EditionComplete.Stock := True;
  EditionComplete.Dedicace := False;
  with FAlbum.Serie do
  begin
    EditionComplete.Couleur := IIf(RecInconnu or Couleur.Undefined, True, Couleur.AsBoolean[True]);
    EditionComplete.VO := IIf(RecInconnu or VO.Undefined, False, VO.AsBoolean[False]);
    EditionComplete.Etat := ROption.Create(IIf(RecInconnu or (Etat.Value = -1), cbxEtat.DefaultValueChecked, Etat.Value), '');
    EditionComplete.Reliure := ROption.Create(IIf(RecInconnu or (Reliure.Value = -1), cbxReliure.DefaultValueChecked, Reliure.Value), '');
    EditionComplete.Orientation := ROption.Create(IIf(RecInconnu or (Orientation.Value = -1), cbxOrientation.DefaultValueChecked, Orientation.Value), '');
    EditionComplete.FormatEdition := ROption.Create(IIf(RecInconnu or (FormatEdition.Value = -1), cbxFormat.DefaultValueChecked, FormatEdition.Value), '');
    EditionComplete.SensLecture := ROption.Create(IIf(RecInconnu or (SensLecture.Value = -1), cbxSensLecture.DefaultValueChecked, SensLecture.Value), '');
    EditionComplete.TypeEdition := ROption.Create(IIf(RecInconnu or (TypeEdition.Value = -1), cbxEdition.DefaultValueChecked, TypeEdition.Value), '');
  end;
  // if not IsEqualGUID(vtSeries.CurrentValue, GUID_NULL) then
  if not IsEqualGUID(vtEditSerie.CurrentValue, GUID_NULL) then
  begin
    EditionComplete.Editeur.ID_Editeur := TSerieLite(vtEditSerie.VTEdit.Data).Editeur.ID;
    EditionComplete.Collection.ID := TSerieLite(vtEditSerie.VTEdit.Data).Collection.ID;
  end;
  FAlbum.Editions.Add(EditionComplete);
  vtEditions.AddItem('Nouvelle edition', EditionComplete);
  vtEditions.ItemIndex := Pred(vtEditions.Items.Count);
  vtEditionsClick(nil);

  FEditeurCollectionSelected[Pred(Length(FEditeurCollectionSelected))] := False;
  RefreshEditionCaption;
end;

procedure TfrmEditAlbum.SpeedButton3Click(Sender: TObject);
var
  c: Currency;
begin
  c := BDStrToDoubleDef(StringReplace(edPrix.Text, TGlobalVar.Utilisateur.Options.SymboleMonnetaire, '', []), 0);
  if Convertisseur(SpeedButton3, c) then
    if edPrix.Focused then
      edPrix.Text := BDDoubleToStr(c)
    else
      edPrix.Text := BDCurrencyToStr(c);
end;

procedure TfrmEditAlbum.VDTButton6Click(Sender: TObject);
var
  lISBN: Integer;
  cs: string;
begin
  cs := edISBN.Text;
  lISBN := Length(cs);
  if not(lISBN in [10, 13]) then
    if StrToIntDef(edAnneeEdition.Text, StrToIntDef(edAnneeParution.Text, YearOf(Now))) >= 2007 then
      lISBN := 13
    else
      lISBN := 10;
  if not VerifieISBN(cs, lISBN) then
    if MessageDlg(Format(RemplacerValeur, [FormatISBN(edISBN.Text), FormatISBN(cs)]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      edISBN.Text := cs;
end;

procedure TfrmEditAlbum.edISBNExit(Sender: TObject);
begin
  edISBN.Text := Trim(edISBN.Text);
end;

procedure TfrmEditAlbum.edISBNChange(Sender: TObject);
begin
  VDTButton6.Enabled := edISBN.Text <> '';
  RefreshEditionCaption;
  if vtEditions.ItemIndex > -1 then
    FEditeurCollectionSelected[vtEditions.ItemIndex] := True;
end;

procedure TfrmEditAlbum.vstImagesInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  PC: TCouvertureLite;
begin
  PC := FCurrentEditionComplete.Couvertures[Node.Index];
  Node.CheckType := ctCheckBox;
  if PC.NewStockee then
    Node.CheckState := csCheckedNormal
  else
    Node.CheckState := csUncheckedNormal;
end;

procedure TfrmEditAlbum.vstImagesChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  FCurrentEditionComplete.Couvertures[Node.Index].NewStockee := (Node.CheckState = csCheckedNormal);
end;

procedure TfrmEditAlbum.vstImagesEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
// var
// PC: TCouvertureLite;
begin
  // PC := FCurrentEditionComplete.Couvertures[Node.Index];
  // Allowed := (PC.Reference <> -1) and (PC.NewStockee) and (PC.NewStockee = PC.OldStockee);

  // devrait être autorisé aussi pour changer le nom de l'image
  // l'édition de la catégorie d'image n'est pas gérée par le virtualtreeview
  Allowed := False;
end;

procedure TfrmEditAlbum.vstImagesNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
var
  PC: TCouvertureLite;
begin
  PC := FCurrentEditionComplete.Couvertures[Node.Index];
  case Column of
    0:
      PC.NewNom := NewText;
    1:
      ;
  end;
end;

procedure TfrmEditAlbum.UpdateEdition;
begin
  if not FEditionChanging and Assigned(FCurrentEditionComplete) then
  begin
    FCurrentEditionComplete.ISBN := edISBN.Text;
    FCurrentEditionComplete.AnneeEdition := StrToIntDef(edAnneeEdition.Text, 0);
    FCurrentEditionComplete.Prix := BDStrToDoubleDef(edPrix.Text, 0);
    FCurrentEditionComplete.Editeur.ID_Editeur := vtEditEditeurs.CurrentValue;
    FCurrentEditionComplete.Editeur.NomEditeur := vtEditEditeurs.VTEdit.PopupWindow.TreeView.Caption;
    FCurrentEditionComplete.Collection.ID := vtEditCollections.CurrentValue;
    FCurrentEditionComplete.Collection.NomCollection := vtEditCollections.VTEdit.PopupWindow.TreeView.Caption;
    FCurrentEditionComplete.Stock := cbStock.Checked;
    FCurrentEditionComplete.VO := cbVO.Checked;
    FCurrentEditionComplete.Couleur := cbCouleur.Checked;
    FCurrentEditionComplete.Dedicace := cbDedicace.Checked;
    FCurrentEditionComplete.Gratuit := cbGratuit.Checked;
    FCurrentEditionComplete.Offert := cbOffert.Checked;
    FCurrentEditionComplete.TypeEdition := ROption.Create(cbxEdition.Value, cbxEdition.Caption);
    FCurrentEditionComplete.Etat := ROption.Create(cbxEtat.Value, cbxEtat.Caption);
    FCurrentEditionComplete.Reliure := ROption.Create(cbxReliure.Value, cbxReliure.Caption);
    FCurrentEditionComplete.Orientation := ROption.Create(cbxOrientation.Value, cbxOrientation.Caption);
    FCurrentEditionComplete.FormatEdition := ROption.Create(cbxFormat.Value, cbxFormat.Caption);
    FCurrentEditionComplete.SensLecture := ROption.Create(cbxSensLecture.Value, cbxSensLecture.Caption);
    FCurrentEditionComplete.NombreDePages := StrToIntDef(edNombreDePages.Text, 0);
    FCurrentEditionComplete.AnneeCote := StrToIntDef(edAnneeCote.Text, 0);
    FCurrentEditionComplete.PrixCote := BDStrToDoubleDef(edPrixCote.Text, 0);
    if dtpAchat.Checked then
      FCurrentEditionComplete.DateAchat := Trunc(dtpAchat.Date)
    else
      FCurrentEditionComplete.DateAchat := 0;
    FCurrentEditionComplete.Notes := edNotes.Text;
    FCurrentEditionComplete.NumeroPerso := edNumPerso.Text;
  end;
end;

procedure TfrmEditAlbum.RefreshEditionCaption;
begin
  if not FEditionChanging and Assigned(FCurrentEditionComplete) then
  begin
    UpdateEdition;
    vtEditions.Items[vtEditions.ItemIndex] := FCurrentEditionComplete.ChaineAffichage;
  end;
end;

procedure TfrmEditAlbum.edAnneeEditionChange(Sender: TObject);
begin
  RefreshEditionCaption;
  if vtEditions.ItemIndex > -1 then
    FEditeurCollectionSelected[vtEditions.ItemIndex] := True;
end;

procedure TfrmEditAlbum.vtCollectionsChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  RefreshEditionCaption;
end;

procedure TfrmEditAlbum.vtEditionsClick(Sender: TObject);
begin
  UpdateEdition;
  FEditionChanging := True;
  try
    if vtEditions.ItemIndex > -1 then
      FCurrentEditionComplete := vtEditions.Items.Objects[vtEditions.ItemIndex] as TEditionFull
    else
      FCurrentEditionComplete := nil;

    PanelEdition.Visible := Assigned(FCurrentEditionComplete);
    vstImages.Clear;
    vstImages.RootNodeCount := 0;
    if Assigned(FCurrentEditionComplete) then
    begin
      edISBN.Text := ClearISBN(FCurrentEditionComplete.ISBN);
      edAnneeEdition.Text := NonZero(IntToStr(FCurrentEditionComplete.AnneeEdition));
      if FCurrentEditionComplete.Prix = 0 then
        edPrix.Text := ''
      else
        edPrix.Text := BDCurrencyToStr(FCurrentEditionComplete.Prix);
      vtEditEditeurs.CurrentValue := FCurrentEditionComplete.Editeur.ID_Editeur;
      vtEditCollections.CurrentValue := FCurrentEditionComplete.Collection.ID;
      cbStock.Checked := FCurrentEditionComplete.Stock;
      cbVO.Checked := FCurrentEditionComplete.VO;
      cbCouleur.Checked := FCurrentEditionComplete.Couleur;
      cbDedicace.Checked := FCurrentEditionComplete.Dedicace;
      cbGratuit.Checked := FCurrentEditionComplete.Gratuit;
      cbOffert.Checked := FCurrentEditionComplete.Offert;
      cbOffertClick(nil);
      cbxEdition.Value := FCurrentEditionComplete.TypeEdition.Value;
      cbxEtat.Value := FCurrentEditionComplete.Etat.Value;
      cbxReliure.Value := FCurrentEditionComplete.Reliure.Value;
      cbxOrientation.Value := FCurrentEditionComplete.Orientation.Value;
      cbxFormat.Value := FCurrentEditionComplete.FormatEdition.Value;
      cbxSensLecture.Value := FCurrentEditionComplete.SensLecture.Value;
      dtpAchat.Date := Now;
      dtpAchat.Checked := FCurrentEditionComplete.DateAchat > 0;
      if dtpAchat.Checked then
        dtpAchat.Date := FCurrentEditionComplete.DateAchat;
      edNombreDePages.Text := NonZero(IntToStr(FCurrentEditionComplete.NombreDePages));
      edAnneeCote.Text := NonZero(IntToStr(FCurrentEditionComplete.AnneeCote));
      if FCurrentEditionComplete.PrixCote = 0 then
        edPrixCote.Text := ''
      else
        edPrixCote.Text := BDCurrencyToStr(FCurrentEditionComplete.PrixCote);
      edNotes.Text := FCurrentEditionComplete.Notes;
      edNumPerso.Text := FCurrentEditionComplete.NumeroPerso;
      vstImages.RootNodeCount := FCurrentEditionComplete.Couvertures.Count;
      vstImages.Selected[vstImages.GetFirst] := True;
      vstImages.FocusedNode := vstImages.GetFirst;
    end;
  finally
    ChoixImage.Enabled := Assigned(FCurrentEditionComplete);
    FEditionChanging := False;
  end;
end;

procedure TfrmEditAlbum.OnEditAuteurs(Sender: TObject);
var
  i: Integer;
  Auteur: TAuteurAlbumLite;
  CurrentAuteur: TPersonnageLite;
begin
  CurrentAuteur := vtEditPersonnes.VTEdit.Data as TPersonnageLite;
  for i := 0 to Pred(lvScenaristes.Items.Count) do
  begin
    Auteur := lvScenaristes.Items[i].Data;
    if IsEqualGUID(Auteur.Personne.ID, CurrentAuteur.ID) then
    begin
      Auteur.Personne.Assign(CurrentAuteur);
      lvScenaristes.Invalidate;
    end;
  end;
  lvScenaristes.Invalidate;
  for i := 0 to Pred(lvDessinateurs.Items.Count) do
  begin
    Auteur := lvDessinateurs.Items[i].Data;
    if IsEqualGUID(Auteur.Personne.ID, CurrentAuteur.ID) then
    begin
      Auteur.Personne.Assign(CurrentAuteur);
      lvDessinateurs.Invalidate;
    end;
  end;
  lvDessinateurs.Invalidate;
  for i := 0 to Pred(lvColoristes.Items.Count) do
  begin
    Auteur := lvColoristes.Items[i].Data;
    if IsEqualGUID(Auteur.Personne.ID, CurrentAuteur.ID) then
    begin
      Auteur.Personne.Assign(CurrentAuteur);
      lvColoristes.Invalidate;
    end;
  end;
  lvColoristes.Invalidate;
end;

procedure TfrmEditAlbum.cbIntegraleClick(Sender: TObject);
var
  cl: TColor;
begin
  edTomeDebut.Enabled := cbIntegrale.Checked;
  edTomeFin.Enabled := cbIntegrale.Checked;
  if cbIntegrale.Checked then
    cl := clWindowText
  else
    cl := clInactiveCaption;
  Label16.Font.Color := cl;
  Label17.Font.Color := cl;
end;

procedure TfrmEditAlbum.cbGratuitClick(Sender: TObject);
begin
  if cbGratuit.Checked then
    edPrix.Text := '';
  if vtEditions.ItemIndex > -1 then
    FEditeurCollectionSelected[vtEditions.ItemIndex] := True;
end;

procedure TfrmEditAlbum.edPrixChange(Sender: TObject);
begin
  if edPrix.Text <> '' then
    cbGratuit.Checked := False;
  if vtEditions.ItemIndex > -1 then
    FEditeurCollectionSelected[vtEditions.ItemIndex] := True;
end;

procedure TfrmEditAlbum.VisuClose(Sender: TObject);
begin
  TForm(TImage(Sender).Parent).ModalResult := mrCancel;
end;

procedure TfrmEditAlbum.imgVisuClick(Sender: TObject);
var
  PC: TCouvertureLite;
  hg: IHourGlass;
  ms: TStream;
  jpg: TJPEGImage;
  Couverture: TImage;
  frm: TForm;
begin
  if not Assigned(vstImages.FocusedNode) then
    Exit;
  PC := FCurrentEditionComplete.Couvertures[vstImages.FocusedNode.Index];
  hg := THourGlass.Create;
  if IsEqualGUID(PC.ID, GUID_NULL) then
    ms := GetJPEGStream(PC.NewNom, 400, 500, TGlobalVar.Utilisateur.Options.AntiAliasing)
  else
    ms := GetCouvertureStream(False, PC.ID, 400, 500, TGlobalVar.Utilisateur.Options.AntiAliasing);
  if Assigned(ms) then
    try
      jpg := TJPEGImage.Create;
      frm := TbdtForm.Create(Self);
      Couverture := TImage.Create(frm);
      try
        jpg.LoadFromStream(ms);
        frm.BorderIcons := [];
        frm.BorderStyle := bsToolWindow;
        frm.Position := poOwnerFormCenter;
        Couverture.Parent := frm;
        Couverture.Picture.Assign(jpg);
        Couverture.Cursor := crHandPoint;
        Couverture.OnClick := VisuClose;
        Couverture.AutoSize := True;
        frm.AutoSize := True;
        frm.ShowModal;
      finally
        FreeAndNil(jpg);
        FreeAndNil(Couverture);
        FreeAndNil(frm);
      end;
    finally
      FreeAndNil(ms);
    end;
end;

procedure TfrmEditAlbum.JvComboEdit1Change(Sender: TObject);
var
  Auteur: TAuteurSerieLite;
begin
  TDaoSerieFull.Fill(FAlbum.Serie, vtEditSerie.CurrentValue, nil);
  if not IsEqualGUID(FAlbum.ID_Serie, GUID_NULL) then
  begin
    if not(FScenaristesSelected and FDessinateursSelected and FColoristesSelected) then
      try
        lvScenaristes.Items.BeginUpdate;
        lvDessinateurs.Items.BeginUpdate;
        lvColoristes.Items.BeginUpdate;
        if not FScenaristesSelected then
        begin
          lvScenaristes.Items.Count := 0;
          FAlbum.Scenaristes.Clear;
          for Auteur in FAlbum.Serie.Scenaristes do
            AjouteAuteur(FAlbum.Scenaristes, lvScenaristes, Auteur.Personne);
        end;
        if not FDessinateursSelected then
        begin
          lvDessinateurs.Items.Count := 0;
          FAlbum.Dessinateurs.Clear;
          for Auteur in FAlbum.Serie.Dessinateurs do
            AjouteAuteur(FAlbum.Dessinateurs, lvDessinateurs, Auteur.Personne);
        end;
        if not FColoristesSelected then
        begin
          lvColoristes.Items.Count := 0;
          FAlbum.Coloristes.Clear;
          for Auteur in FAlbum.Serie.Coloristes do
            AjouteAuteur(FAlbum.Coloristes, lvColoristes, Auteur.Personne);
        end;
      finally
        lvScenaristes.Items.EndUpdate;
        lvDessinateurs.Items.EndUpdate;
        lvColoristes.Items.EndUpdate;
      end;

    if Assigned(FCurrentEditionComplete) and (not FEditeurCollectionSelected[vtEditions.ItemIndex]) then
    begin
      vtEditEditeurs.CurrentValue := FAlbum.Serie.Editeur.ID_Editeur;
      vtEditCollections.CurrentValue := FAlbum.Serie.Collection.ID;

      with FAlbum.Serie do
      begin
        cbCouleur.Checked := IIf(RecInconnu or Couleur.Undefined, True, Couleur.AsBoolean[True]);
        cbVO.Checked := IIf(RecInconnu or VO.Undefined, False, VO.AsBoolean[False]);
        cbxEtat.Value := IIf(RecInconnu or (Etat.Value = -1), cbxEtat.DefaultValueChecked, Etat.Value);
        cbxReliure.Value := IIf(RecInconnu or (Reliure.Value = -1), cbxReliure.DefaultValueChecked, Reliure.Value);
        cbxOrientation.Value := IIf(RecInconnu or (Orientation.Value = -1), cbxOrientation.DefaultValueChecked, Orientation.Value);
        cbxFormat.Value := IIf(RecInconnu or (FormatEdition.Value = -1), cbxFormat.DefaultValueChecked, FormatEdition.Value);
        cbxSensLecture.Value := IIf(RecInconnu or (SensLecture.Value = -1), cbxSensLecture.DefaultValueChecked, SensLecture.Value);
        cbxEdition.Value := IIf(RecInconnu or (TypeEdition.Value = -1), cbxEdition.DefaultValueChecked, TypeEdition.Value);
      end;

      // on reset parce que le tcheckbox et tedit le flag à tort dans ce cas
      FEditeurCollectionSelected[vtEditions.ItemIndex] := False;
    end;
  end;
end;

procedure TfrmEditAlbum.vstImagesDblClick(Sender: TObject);
var
  PC: TCouvertureLite;
begin
  if not Assigned(vstImages.FocusedNode) then
    Exit;
  PC := FCurrentEditionComplete.Couvertures[vstImages.FocusedNode.Index];
  if IsEqualGUID(PC.ID, GUID_NULL) then
    with ChoixImageDialog do
    begin
      Options := Options - [ofAllowMultiSelect];
      FileName := PC.NewNom;
      if Execute then
      begin
        PC.NewNom := FileName;
        vstImages.InvalidateNode(vstImages.FocusedNode);
      end;
    end;
end;

procedure TfrmEditAlbum.cbOffertClick(Sender: TObject);
begin
  if cbOffert.Checked then
    Label18.Caption := rsTransOffertLe
  else
    Label18.Caption := rsTransAcheteLe;
  if vtEditions.ItemIndex > -1 then
    FEditeurCollectionSelected[vtEditions.ItemIndex] := True;
end;

procedure TfrmEditAlbum.vstImagesStructureChange(Sender: TBaseVirtualTree; Node: PVirtualNode; Reason: TChangeReason);
begin
  vstImagesChange(Sender, vstImages.FocusedNode);
end;

procedure TfrmEditAlbum.VDTButton13Click(Sender: TObject);
var
  dummy, Code: string;
begin
  if InputQuery('EAN-ISBN', 'Saisir le numéro EAN-ISBN de l''édition :', Code) then
  begin
    dummy := Code;
    if not VerifieEAN(dummy) and
      (MessageDlg(Code + #13#13'Le caractère de contrôle de ce numéro EAN-ISBN n''est pas correct.'#13#10'Voulez-vous néanmoins utiliser ce code barre?',
      mtWarning, [mbYes, mbNo], 0) = mrNo) then
      Exit;
    if StrToIntDef(edAnneeEdition.Text, 0) >= 2007 then
    begin // en 2007, les ISBN passent à 13 caractères
      Code := Copy(Code, 1, 12);
      VerifieISBN(Code, 13);
    end
    else
    begin
      Code := Copy(Code, 4, 9);
      VerifieISBN(Code, 10);
    end;
    edISBN.Text := Code;
  end;
end;

procedure TfrmEditAlbum.vtEditionsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  OldIndex: Integer;
begin
  if Key = VK_DELETE then
  begin
    OldIndex := vtEditions.ItemIndex;

    FCurrentEditionComplete := nil;
    vtEditions.DeleteSelected;
    FAlbum.Editions.Delete(OldIndex);
    if OldIndex < vtEditions.Items.Count then
      vtEditions.ItemIndex := OldIndex
    else
      vtEditions.ItemIndex := Pred(vtEditions.Items.Count);
    vtEditionsClick(vtEditions);
  end;
end;

procedure TfrmEditAlbum.vtEditUniversVTEditChange(Sender: TObject);
var
  IdUnivers: TGUID;

  function NotIn(LV: TListView): Boolean;
  var
    i: Integer;
  begin
    i := 0;
    Result := True;
    while Result and (i <= Pred(LV.Items.Count)) do
    begin
      Result := not IsEqualGUID(TUniversLite(LV.Items[i].Data).ID, IdUnivers);
      Inc(i);
    end;
  end;

begin
  IdUnivers := vtEditUnivers.CurrentValue;
  btUnivers.Enabled := (not IsEqualGUID(IdUnivers, GUID_NULL)) and NotIn(lvUnivers);
end;

procedure TfrmEditAlbum.VDTButton14Click(Sender: TObject);
var
  c: Currency;
begin
  c := BDStrToDoubleDef(edPrixCote.Text, 0);
  if Convertisseur(VDTButton14, c) then
    if edPrixCote.Focused then
      edPrixCote.Text := BDDoubleToStr(c)
    else
      edPrixCote.Text := BDCurrencyToStr(c);
end;

procedure TfrmEditAlbum.vstImagesMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  pt: TPoint;
  Node: PVirtualNode;
begin
  Node := vstImages.GetNodeAt(X, Y);
  if (Node <> nil) and (vstImages.Header.Columns.ColumnFromPosition(Point(X, Y)) = 1) then
  begin
    with vstImages.GetDisplayRect(Node, 1, False) do
    begin
      X := Left;
      Y := Bottom;
    end;
    pt := vstImages.ClientToScreen(Point(X, Y));
    pmChoixCategorie.PopupComponent := TComponent(Node.Index);
    pmChoixCategorie.Tag := FCurrentEditionComplete.Couvertures[Node.Index].Categorie;
    pmChoixCategorie.Popup(pt.X, pt.Y);
  end;
end;

procedure TfrmEditAlbum.miChangeCategorieImageClick(Sender: TObject);
var
  PC: TCouvertureLite;
begin
  PC := FCurrentEditionComplete.Couvertures[Integer(TPopupMenu(TMenuItem(Sender).GetParentMenu).PopupComponent)];
  PC.Categorie := Integer(TMenuItem(Sender).Tag);
  PC.sCategorie := TDaoListe.ListTypesCouverture.Values[IntToStr(PC.Categorie)];
  vstImages.Invalidate;
end;

procedure TfrmEditAlbum.pmChoixCategoriePopup(Sender: TObject);
var
  MenuItem: TMenuItem;
begin
  for MenuItem in pmChoixCategorie.Items do
    MenuItem.Checked := pmChoixCategorie.Tag = MenuItem.Tag;
end;

procedure TfrmEditAlbum.lvScenaristesData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FAlbum.Scenaristes[Item.Index];
  Item.Caption := TAuteurLite(Item.Data).ChaineAffichage;
end;

procedure TfrmEditAlbum.lvUniversData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FAlbum.Univers[Item.Index];
  Item.Caption := TUniversLite(Item.Data).ChaineAffichage;
end;

procedure TfrmEditAlbum.lvUniversKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  src: TListView;
begin
  if Key <> VK_DELETE then
    Exit;
  src := TListView(Sender);
  FAlbum.Univers.Delete(src.Selected.Index);
  lvUnivers.Items.Count := FAlbum.Univers.Count;
  src.Invalidate;
  vtEditUniversVTEditChange(vtEditUnivers.VTEdit);
end;

procedure TfrmEditAlbum.lvDessinateursData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FAlbum.Dessinateurs[Item.Index];
  Item.Caption := TAuteurLite(Item.Data).ChaineAffichage;
end;

procedure TfrmEditAlbum.lvColoristesData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FAlbum.Coloristes[Item.Index];
  Item.Caption := TAuteurLite(Item.Data).ChaineAffichage;
end;

function TfrmEditAlbum.GetID_Album: TGUID;
begin
  Result := FAlbum.ID_Album;
end;

function TfrmEditAlbum.GetCreation: Boolean;
begin
  Result := FAlbum.RecInconnu;
end;

end.
