unit Form_EditAlbum;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, DBCtrls, StdCtrls, ImgList, DBEditLabeled,
  VDTButton, ExtDlgs, Mask, ComCtrls, Buttons, VirtualTrees, VirtualTree, Menus, TypeRec, ActnList, LoadComplet, ComboCheck,
  Frame_RechercheRapide, CRFurtif, Fram_Boutons;

type
  TFrmEditAlbum = class(TForm)
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
    btScenariste: TCRFurtifLight;
    lvDessinateurs: TVDTListViewLabeled;
    btDessinateur: TCRFurtifLight;
    vtPersonnes: TVirtualStringTree;
    Label19: TLabel;
    vstImages: TVirtualStringTree;
    ChoixImage: TCRFurtifLight;
    VDTButton4: TCRFurtifLight;
    VDTButton5: TCRFurtifLight;
    Bevel1: TBevel;
    Label20: TLabel;
    vtSeries: TVirtualStringTree;
    btColoriste: TCRFurtifLight;
    lvColoristes: TVDTListViewLabeled;
    cbIntegrale: TCheckBoxLabeled;
    Label1: TLabel;
    edTome: TEditLabeled;
    Label5: TLabel;
    vtEditeurs: TVirtualStringTree;
    Label8: TLabel;
    vtCollections: TVirtualStringTree;
    Label4: TLabel;
    vtEditions: TListBoxLabeled;
    VDTButton3: TVDTButton;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    cbHorsSerie: TCheckBoxLabeled;
    Label15: TLabel;
    edNotes: TMemoLabeled;
    Label16: TLabel;
    edTomeDebut: TEditLabeled;
    Label17: TLabel;
    edTomeFin: TEditLabeled;
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
    VDTButton13: TCRFurtifLight;
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
    FrameRechercheRapidePersonnes: TFrameRechercheRapide;
    FrameRechercheRapideSerie: TFrameRechercheRapide;
    FrameRechercheRapideEditeur: TFrameRechercheRapide;
    FrameRechercheRapideCollection: TFrameRechercheRapide;
    Bevel2: TBevel;
    Frame11: TFrame1;
    btResetSerie: TCRFurtifLight;
    procedure ajoutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ChoixImageClick(Sender: TObject);
    procedure edTitreChange(Sender: TObject);
    procedure VDTButton2Click(Sender: TObject);
    procedure lvDessinateursKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure vstImagesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure VDTButton4Click(Sender: TObject);
    procedure VDTButton5Click(Sender: TObject);
    procedure OnNewSerie(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure longueur2KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure vtPersonnesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstImagesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vstImagesPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure vstImagesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtEditeursChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtSeriesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VDTButton3Click(Sender: TObject);
    procedure OnNewCollection(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure VDTButton6Click(Sender: TObject);
    procedure edISBNExit(Sender: TObject);
    procedure edISBNChange(Sender: TObject);
    procedure vstImagesInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstImagesChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstImagesEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vstImagesNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
    procedure vtEditeursClick(Sender: TObject);
    procedure vtCollectionsClick(Sender: TObject);
    procedure edAnneeEditionChange(Sender: TObject);
    procedure vtCollectionsChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtEditionsClick(Sender: TObject);
    procedure vtSeriesDblClick(Sender: TObject);
    procedure vtPersonnesDblClick(Sender: TObject);
    procedure vtEditeursDblClick(Sender: TObject);
    procedure vtCollectionsDblClick(Sender: TObject);
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
    procedure btResetSerieClick(Sender: TObject);
  private
    { Déclarations privées }
    FAlbum: TAlbumComplet;
    FCurrentEditionComplete: TEditionComplete;
    FEditeurCollectionSelected: array of Boolean;
    FEditionChanging: Boolean;
    FScenaristesSelected, FDessinateursSelected, FColoristesSelected: Boolean;
    FisAchat: Boolean;
    FCategoriesImages: TStringList;
    procedure UpdateEdition;
    procedure RefreshEditionCaption;
    procedure SetID_Album(const Value: TGUID);
    procedure VisuClose(Sender: TObject);
    procedure AjouteAuteur(List: TList; lvList: TVDTListViewLabeled; Auteur: TPersonnage; var FlagAuteur: Boolean); overload;
    procedure AjouteAuteur(List: TList; lvList: TVDTListViewLabeled; Auteur: TPersonnage); overload;
    procedure EditeurCollectionSelected(Sender: TObject; NextSearch: Boolean);
    function GetID_Album: TGUID;
    function GetCreation: Boolean;
  public
    { Déclarations publiques }
    property isCreation: Boolean read GetCreation;
    property isAchat: Boolean read FisAchat write FisAchat;
    property ID_Album: TGUID read GetID_Album write SetID_Album;
  end;

implementation

uses
  Commun, JvUIB, CommonConst, Textes, Divers, Proc_Gestions, JvUIBLib, Procedures, ProceduresBDtk, Types, jpeg;

{$R *.DFM}

const
  RemplacerValeur = 'Remplacer %s par %s ?';

  { TFrmEditAlbum }

procedure TFrmEditAlbum.FormCreate(Sender: TObject);
var
  i: Integer;
  mi: TMenuItem;
begin
  PrepareLV(Self);

  FrameRechercheRapidePersonnes.VirtualTreeView := vtPersonnes;
  FrameRechercheRapideSerie.VirtualTreeView := vtSeries;
  FrameRechercheRapideSerie.OnNew := OnNewSerie;
  FrameRechercheRapideEditeur.VirtualTreeView := vtEditeurs;
  FrameRechercheRapideEditeur.OnSearch := EditeurCollectionSelected;
  FrameRechercheRapideCollection.VirtualTreeView := vtCollections;
  FrameRechercheRapideCollection.OnNew := OnNewCollection;
  FrameRechercheRapideCollection.OnSearch := EditeurCollectionSelected;

  FAlbum := TAlbumComplet.Create;

  SetLength(FEditeurCollectionSelected, 0);
  FCurrentEditionComplete := nil;
  vtPersonnes.Mode := vmPersonnes;
  vtEditeurs.Mode := vmEditeurs;
  vtCollections.Mode := vmNone;
  vtCollections.UseFiltre := True;
  vtSeries.Mode := vmSeries;
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
  edPrix.CurrencyChar := Utilisateur.Options.SymboleMonnetaire[1];
  FScenaristesSelected := False;
  FDessinateursSelected := False;
  FColoristesSelected := False;

  FCategoriesImages := TStringList.Create;

  LoadCombo(1 {Etat}, cbxEtat);
  LoadCombo(2 {Reliure}, cbxReliure);
  LoadCombo(3 {TypeEdition}, cbxEdition);
  LoadCombo(4 {Orientation}, cbxOrientation);
  LoadCombo(5 {Format}, cbxFormat);
  LoadStrings(6 {Categorie d'image}, FCategoriesImages);

  for i := 0 to Pred(FCategoriesImages.Count) do begin
    mi := TMenuItem.Create(pmChoixCategorie);
    mi.Caption := FCategoriesImages.ValueFromIndex[i];
    mi.Tag := StrToInt(FCategoriesImages.Names[i]);
    mi.OnClick := miChangeCategorieImageClick;
    pmChoixCategorie.Items.Add(mi);
  end;
end;

procedure TFrmEditAlbum.SetID_Album(const Value: TGUID);
var
  i: Integer;
  PE: TEditionComplete;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  FAlbum.Fill(Value);

  lvScenaristes.Items.BeginUpdate;
  lvDessinateurs.Items.BeginUpdate;
  lvColoristes.Items.BeginUpdate;
  vtEditions.Items.BeginUpdate;
  try
    edTitre.Text := FAlbum.Titre;
    edMoisParution.Text := NonZero(IntToStr(FAlbum.MoisParution));
    edAnneeParution.Text := NonZero(IntToStr(FAlbum.AnneeParution));
    edTome.Text := NonZero(IntToStr(FAlbum.Tome));
    edTomeDebut.Text := NonZero(IntToStr(FAlbum.TomeDebut));
    edTomeFin.Text := NonZero(IntToStr(FAlbum.TomeFin));
    cbIntegrale.Checked := FAlbum.Integrale;
    cbHorsSerie.Checked := FAlbum.HorsSerie;
    histoire.Lines.Text := FAlbum.Sujet.Text;
    remarques.Lines.Text := FAlbum.Notes.Text;
    cbIntegraleClick(cbIntegrale);

    lvScenaristes.Items.Count := FAlbum.Scenaristes.Count;
    lvDessinateurs.Items.Count := FAlbum.Dessinateurs.Count;
    lvColoristes.Items.Count := FAlbum.Coloristes.Count;

    FScenaristesSelected := lvScenaristes.Items.Count > 0;
    FDessinateursSelected := lvDessinateurs.Items.Count > 0;
    FColoristesSelected := lvColoristes.Items.Count > 0;

    vtSeries.OnChange := nil;
    vtSeries.CurrentValue := FAlbum.ID_Serie;
    btResetSerie.Enabled := not IsEqualGUID(FAlbum.ID_Serie, GUID_NULL);
    vtSeries.OnChange := vtSeriesChange;

    SetLength(FEditeurCollectionSelected, FAlbum.Editions.Editions.Count);
    for i := 0 to Pred(FAlbum.Editions.Editions.Count) do begin
      PE := FAlbum.Editions.Editions[i];
      FEditeurCollectionSelected[i] := True;
      vtEditions.AddItem(PE.ChaineAffichage, PE);
    end;

    if FAlbum.RecInconnu or isAchat then VDTButton3.Click;
  finally
    vtEditions.Items.EndUpdate;
    lvScenaristes.Items.EndUpdate;
    lvDessinateurs.Items.EndUpdate;
    lvColoristes.Items.EndUpdate;
  end;
end;

procedure TFrmEditAlbum.AjouteAuteur(List: TList; lvList: TVDTListViewLabeled; Auteur: TPersonnage);
var
  dummy: Boolean;
begin
  AjouteAuteur(List, lvList, Auteur, dummy);
end;

procedure TFrmEditAlbum.AjouteAuteur(List: TList; lvList: TVDTListViewLabeled; Auteur: TPersonnage; var FlagAuteur: Boolean);
var
  PA: TAuteur;
begin
  PA := TAuteur.Create;
  PA.Fill(Auteur, ID_Album, GUID_NULL, 0);
  List.Add(PA);
  lvList.Items.Count := List.Count;
  lvList.Invalidate;

  FlagAuteur := True;
end;

procedure TFrmEditAlbum.ajoutClick(Sender: TObject);
begin
  if IsEqualGUID(vtPersonnes.CurrentValue, GUID_NULL) then Exit;
  case TSpeedButton(Sender).Tag of
    1: AjouteAuteur(FAlbum.Scenaristes, lvScenaristes, TPersonnage(vtPersonnes.GetFocusedNodeData), FScenaristesSelected);
    2: AjouteAuteur(FAlbum.Dessinateurs, lvDessinateurs, TPersonnage(vtPersonnes.GetFocusedNodeData), FDessinateursSelected);
    3: AjouteAuteur(FAlbum.Coloristes, lvColoristes, TPersonnage(vtPersonnes.GetFocusedNodeData), FColoristesSelected);
  end;
  vtPersonnesChange(vtPersonnes, vtPersonnes.FocusedNode);
end;

procedure TFrmEditAlbum.lvDessinateursKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  src: TListView;
begin
  if Key <> VK_DELETE then Exit;
  src := TListView(Sender);
  if src = lvScenaristes then FAlbum.Scenaristes.Delete(src.Selected.Index);
  if src = lvDessinateurs then FAlbum.Dessinateurs.Delete(src.Selected.Index);
  if src = lvColoristes then FAlbum.Coloristes.Delete(src.Selected.Index);
  lvScenaristes.Items.Count := FAlbum.Scenaristes.Count;
  lvDessinateurs.Items.Count := FAlbum.Dessinateurs.Count;
  lvColoristes.Items.Count := FAlbum.Coloristes.Count;
  src.Invalidate;
  vtPersonnesChange(vtPersonnes, vtPersonnes.FocusedNode);
end;

procedure TFrmEditAlbum.FormDestroy(Sender: TObject);
begin
  lvScenaristes.Items.Count := 0;
  lvDessinateurs.Items.Count := 0;
  lvColoristes.Items.Count := 0;
  FCurrentEditionComplete := nil;
  vtEditions.Clear;
  FAlbum.Free;
  FCategoriesImages.Free;
end;

procedure TFrmEditAlbum.Frame11btnOKClick(Sender: TObject);
var
  i: Integer;
  EditionComplete: TEditionComplete;
  hg: IHourGlass;
  AfficheEdition: Integer;
  cs: string;
begin
  if Utilisateur.Options.SerieObligatoireAlbums and IsEqualGUID(vtSeries.CurrentValue, GUID_NULL) then begin
    AffMessage(rsSerieObligatoire, mtInformation, [mbOk], True);
    FrameRechercheRapideSerie.edSearch.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;
  if (Length(Trim(edTitre.Text)) = 0) and IsEqualGUID(vtSeries.CurrentValue, GUID_NULL) then begin
    AffMessage(rsTitreObligatoireAlbumSansSerie, mtInformation, [mbOk], True);
    edTitre.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;
  if not (StrToIntDef(edMoisParution.Text, 1) in [1..12]) then begin
    AffMessage(rsMoisParutionIncorrect, mtInformation, [mbOk], True);
    edMoisParution.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;

  UpdateEdition; // force la mise à jour du REditionComplete en cours si c pas déjà fait

  AfficheEdition := -1;
  for i := 0 to Pred(vtEditions.Items.Count) do begin
    EditionComplete := Pointer(vtEditions.Items.Objects[i]);
    if IsEqualGUID(EditionComplete.Editeur.ID_Editeur, GUID_NULL) then begin
      AffMessage(rsEditeurObligatoire, mtInformation, [mbOk], True);
      AfficheEdition := i;
    end;
    cs := EditionComplete.ISBN;
    if cs = '' then begin
      // l'utilisation de l'isbn n'étant obligatoire que depuis "quelques années", les bd anciennes n'en n'ont pas: donc pas obligatoire de le saisir
//      AffMessage('Le numéro ISBN est obligatoire !', mtInformation, [mbOk], True);
//      AfficheEdition := i;
    end;
    if not VerifieISBN(cs) then
      if MessageDlg(Format(RemplacerValeur, [EditionComplete.ISBN, FormatISBN(cs)]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
        EditionComplete.ISBN := cs;
      end
      else begin
        //        AffMessage('Le numéro ISBN est obligatoire !', mtInformation, [mbOk], True);
        //        AfficheEdition := i;
      end;
    if (EditionComplete.AnneeCote * EditionComplete.PrixCote = 0) and (EditionComplete.AnneeCote + EditionComplete.PrixCote <> 0) then begin
      // une cote doit être composée d'une année ET d'un prix
      AffMessage(rsCoteIncomplete, mtInformation, [mbOk], True);
      AfficheEdition := i;
    end;
  end;
  if AfficheEdition <> -1 then begin
    vtEditions.ItemIndex := AfficheEdition;
    vtEditeurs.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;

  hg := THourGlass.Create;

  FAlbum.Titre := Trim(edTitre.Text);
  if edAnneeParution.Text = '' then begin
    FAlbum.AnneeParution := 0;
    FAlbum.MoisParution := 0;
  end
  else begin
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
  FAlbum.Sujet.Text := histoire.Lines.Text;
  FAlbum.Notes.Text := remarques.Lines.Text;

  FAlbum.SaveToDatabase;
  if isAchat then FAlbum.Acheter(False);

  ModalResult := mrOk;
end;

procedure TFrmEditAlbum.edTitreChange(Sender: TObject);
begin
  Caption := 'Saisie d''album - ' + FormatTitre(edTitre.Text);
end;

procedure TFrmEditAlbum.VDTButton2Click(Sender: TObject);
begin
  ModifierSeries(vtSeries);
end;

procedure TFrmEditAlbum.ChoixImageClick(Sender: TObject);
var
  i: Integer;
  PC: TCouverture;
begin
  with ChoixImageDialog do begin
    Options := Options + [ofAllowMultiSelect];
    Filter := GraphicFilter(TGraphic);
    InitialDir := RepImages;
    FileName := '';
    if Execute then begin
      vstImages.BeginUpdate;
      try
        for i := 0 to Files.Count - 1 do begin
          PC := TCouverture.Create;
          FCurrentEditionComplete.Couvertures.Add(PC);
          PC.ID := GUID_NULL;
          PC.OldNom := Files[i];
          PC.NewNom := PC.OldNom;
          PC.OldStockee := Utilisateur.Options.ImagesStockees;
          PC.NewStockee := PC.OldStockee;
          if FCurrentEditionComplete.Couvertures.Count = 1 then
            PC.Categorie := 0
          else
            PC.Categorie := 1;
          PC.sCategorie := FCategoriesImages.Values[IntToStr(PC.Categorie)];
        end;
      finally
        vstImages.RootNodeCount := FCurrentEditionComplete.Couvertures.Count;
        vstImages.EndUpdate;
      end;
    end;
  end;
end;

procedure TFrmEditAlbum.vstImagesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  PC: TCouverture;
  hg: IHourGlass;
  ms: TStream;
  jpg: TJPEGImage;
begin
  VDTButton4.Enabled := Assigned(Node) and (Node.Index > 0);
  VDTButton5.Enabled := Assigned(Node) and (Node.Index < Pred(vstImages.RootNodeCount));

  if Assigned(Node) then begin
    PC := FCurrentEditionComplete.Couvertures[Node.Index];
    hg := THourGlass.Create;
    if IsEqualGUID(PC.ID, GUID_NULL) then
      ms := GetCouvertureStream(PC.NewNom, imgVisu.Height, imgVisu.Width, Utilisateur.Options.AntiAliasing)
    else
      ms := GetCouvertureStream(False, PC.ID, imgVisu.Height, imgVisu.Width, Utilisateur.Options.AntiAliasing);
    if Assigned(ms) then try
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

procedure TFrmEditAlbum.vstImagesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then begin
    FCurrentEditionComplete.Couvertures.Delete(vstImages.FocusedNode.Index);
    vstImages.RootNodeCount := FCurrentEditionComplete.Couvertures.Count;
    imgVisu.Picture.Assign(nil);
    vstImages.ReinitNode(vstImages.RootNode, True);
  end;
end;

procedure TFrmEditAlbum.VDTButton4Click(Sender: TObject);
begin
  FCurrentEditionComplete.Couvertures.Move(vstImages.FocusedNode.Index, Pred(vstImages.FocusedNode.Index));
  vstImages.FocusedNode := vstImages.FocusedNode.PrevSibling;
  vstImages.Selected[vstImages.FocusedNode] := True;
  vstImages.Invalidate;
end;

procedure TFrmEditAlbum.VDTButton5Click(Sender: TObject);
begin
  FCurrentEditionComplete.Couvertures.Move(vstImages.FocusedNode.Index, Succ(vstImages.FocusedNode.Index));
  vstImages.FocusedNode := vstImages.FocusedNode.NextSibling;
  vstImages.Selected[vstImages.FocusedNode] := True;
  vstImages.Invalidate;
end;

procedure TFrmEditAlbum.OnNewSerie(Sender: TObject);
begin
  AjouterSeries(vtSeries, FrameRechercheRapideSerie.edSearch.Text);
  vtEditeurs.InitializeRep;
  vtCollections.InitializeRep;
  vtSeriesChange(vtSeries, vtSeries.FocusedNode);
end;

procedure TFrmEditAlbum.FormActivate(Sender: TObject);
begin
  Invalidate;
end;

procedure TFrmEditAlbum.longueur2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = ' ' then Key := '0';
end;

procedure TFrmEditAlbum.FormShow(Sender: TObject);
begin
  // la selection de l'édition doit se faire ici à cause d'un bug du TDateTimePicker:
  //   il se forcerait à "Checked = True" si on le fait dans le SetID_Album
  if vtEditions.ItemIndex = -1 then begin
    vtEditions.ItemIndex := 0;
    vtEditions.OnClick(vtEditions);
  end;
  edTitre.SetFocus;
end;

procedure TFrmEditAlbum.vtPersonnesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
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
  btScenariste.Enabled := (not IsEqualGUID(IdPersonne, GUID_NULL)) and NotIn(LVScenaristes);
  btDessinateur.Enabled := (not IsEqualGUID(IdPersonne, GUID_NULL)) and NotIn(LVDessinateurs);
  btColoriste.Enabled := (not IsEqualGUID(IdPersonne, GUID_NULL)) and NotIn(LVColoristes);
end;

procedure TFrmEditAlbum.vstImagesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var
  PC: TCouverture;
begin
  PC := FCurrentEditionComplete.Couvertures[Node.Index];
  CellText := '';
  case Column of
    0: CellText := PC.NewNom;
    1: CellText := PC.sCategorie;
  end;
end;

procedure TFrmEditAlbum.vstImagesPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  PC: TCouverture;
begin
  PC := FCurrentEditionComplete.Couvertures[Node.Index];
  if (Column = 0) and (not IsEqualGUID(PC.ID, GUID_NULL)) then
    if vstImages.Selected[Node] then
      TargetCanvas.Font.Color := clInactiveCaption
    else
      TargetCanvas.Font.Color := clInactiveCaptionText;
end;

procedure TFrmEditAlbum.vtEditeursChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  ID_Editeur: TGUID;
begin
  ID_Editeur := vtEditeurs.CurrentValue;
  if IsEqualGUID(ID_Editeur, GUID_NULL) then begin
    vtCollections.Mode := vmNone;
  end
  else begin
    vtCollections.Filtre := 'ID_Editeur = ' + QuotedStr(GUIDToString(ID_Editeur));
    if vtCollections.Mode <> vmCollections then vtCollections.Mode := vmCollections;
  end;
  FrameRechercheRapideCollection.btNew.Enabled := not IsEqualGUID(ID_Editeur, GUID_NULL);
  RefreshEditionCaption;
end;

procedure TFrmEditAlbum.vtSeriesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  i: Integer;
begin
  FAlbum.ID_Serie := vtSeries.CurrentValue;
  btResetSerie.Enabled := not IsEqualGUID(FAlbum.ID_Serie, GUID_NULL);
  if btResetSerie.Enabled then begin
    if not (FScenaristesSelected and FDessinateursSelected and FColoristesSelected) then try
      lvScenaristes.Items.BeginUpdate;
      lvDessinateurs.Items.BeginUpdate;
      lvColoristes.Items.BeginUpdate;
      if not FScenaristesSelected then begin
        lvScenaristes.Items.Count := 0;
        FAlbum.Scenaristes.Clear;
        for i := 0 to Pred(FAlbum.Serie.Scenaristes.Count) do
          AjouteAuteur(FAlbum.Scenaristes, lvScenaristes, TAuteur(FAlbum.Serie.Scenaristes[i]).Personne);
      end;
      if not FDessinateursSelected then begin
        lvDessinateurs.Items.Count := 0;
        FAlbum.Dessinateurs.Clear;
        for i := 0 to Pred(FAlbum.Serie.Dessinateurs.Count) do
          AjouteAuteur(FAlbum.Dessinateurs, lvDessinateurs, TAuteur(FAlbum.Serie.Dessinateurs[i]).Personne);
      end;
      if not FColoristesSelected then begin
        lvColoristes.Items.Count := 0;
        FAlbum.Coloristes.Clear;
        for i := 0 to Pred(FAlbum.Serie.Coloristes.Count) do
          AjouteAuteur(FAlbum.Coloristes, lvColoristes, TAuteur(FAlbum.Serie.Coloristes[i]).Personne);
      end;
    finally
      lvScenaristes.Items.EndUpdate;
      lvDessinateurs.Items.EndUpdate;
      lvColoristes.Items.EndUpdate;
    end;

    if Assigned(FCurrentEditionComplete) and (not FEditeurCollectionSelected[vtEditions.ItemIndex]) then begin
      vtEditeurs.CurrentValue := FAlbum.Serie.Editeur.ID_Editeur;
      vtCollections.CurrentValue := FAlbum.Serie.Collection.ID;
    end;
  end;
end;

procedure TFrmEditAlbum.VDTButton3Click(Sender: TObject);
var
  EditionComplete: TEditionComplete;
begin
  SetLength(FEditeurCollectionSelected, Succ(Length(FEditeurCollectionSelected)));
  FEditeurCollectionSelected[Pred(Length(FEditeurCollectionSelected))] := False;
  EditionComplete := TEditionComplete.Create;
  EditionComplete.New;
  EditionComplete.ID_Album := ID_Album;
  EditionComplete.Couleur := True;
  EditionComplete.VO := False;
  EditionComplete.Stock := True;
  EditionComplete.Dedicace := False;
  EditionComplete.Etat := cbxEtat.DefaultValueChecked;
  EditionComplete.Reliure := cbxReliure.DefaultValueChecked;
  EditionComplete.Orientation := cbxOrientation.DefaultValueChecked;
  EditionComplete.FormatEdition := cbxFormat.DefaultValueChecked;
  EditionComplete.TypeEdition := cbxEdition.DefaultValueChecked;
  if not IsEqualGUID(vtSeries.CurrentValue, GUID_NULL) then begin
    EditionComplete.Editeur.ID_Editeur := TSerie(vtSeries.GetFocusedNodeData).Editeur.ID;
    EditionComplete.Collection.ID := TSerie(vtSeries.GetFocusedNodeData).Collection.ID;
  end;
  FAlbum.Editions.Editions.Add(EditionComplete);
  vtEditions.AddItem('Nouvelle edition', Pointer(EditionComplete));
  vtEditions.ItemIndex := Pred(vtEditions.Items.Count);
  vtEditionsClick(nil);
end;

procedure TFrmEditAlbum.OnNewCollection(Sender: TObject);
begin
  AjouterCollections(vtCollections, vtEditeurs.CurrentValue, FrameRechercheRapideCollection.edSearch.Text);
end;

procedure TFrmEditAlbum.SpeedButton3Click(Sender: TObject);
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

procedure TFrmEditAlbum.VDTButton6Click(Sender: TObject);
var
  cs: string;
begin
  cs := edISBN.Text;
  if not VerifieISBN(cs) then
    if MessageDlg(Format(RemplacerValeur, [edISBN.Text, cs]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then edISBN.Text := cs;
end;

procedure TFrmEditAlbum.edISBNExit(Sender: TObject);
begin
  edISBN.Text := Trim(edISBN.Text);
end;

procedure TFrmEditAlbum.edISBNChange(Sender: TObject);
begin
  VDTButton6.Enabled := edISBN.Text <> '';
  RefreshEditionCaption;
end;

procedure TFrmEditAlbum.vstImagesInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  PC: TCouverture;
begin
  PC := FCurrentEditionComplete.Couvertures[Node.Index];
  Node.CheckType := ctCheckBox;
  if PC.NewStockee then
    Node.CheckState := csCheckedNormal
  else
    Node.CheckState := csUncheckedNormal;
end;

procedure TFrmEditAlbum.vstImagesChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  PC: TCouverture;
begin
  PC := FCurrentEditionComplete.Couvertures[Node.Index];
  PC.NewStockee := (Node.CheckState = csCheckedNormal);
end;

procedure TFrmEditAlbum.vstImagesEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
//var
//  PC: TCouverture;
begin
  //  PC := FCurrentEditionComplete.Couvertures[Node.Index];
  //  Allowed := (PC.Reference <> -1) and (PC.NewStockee) and (PC.NewStockee = PC.OldStockee);

  // devrait être autorisé aussi pour changer le nom de l'image
  // l'édition de la catégorie d'image n'est pas gérée par le virtualtreeview
  Allowed := False;
end;

procedure TFrmEditAlbum.vstImagesNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
var
  PC: TCouverture;
begin
  PC := FCurrentEditionComplete.Couvertures[Node.Index];
  case Column of
    0: PC.NewNom := NewText;
    1: ;
  end;
end;

procedure TFrmEditAlbum.vtEditeursClick(Sender: TObject);
begin
  FEditeurCollectionSelected[vtEditions.ItemIndex] := True;
end;

procedure TFrmEditAlbum.vtCollectionsClick(Sender: TObject);
begin
  FEditeurCollectionSelected[vtEditions.ItemIndex] := True;
end;

procedure TFrmEditAlbum.UpdateEdition;
begin
  if not FEditionChanging and Assigned(FCurrentEditionComplete) then begin
    FCurrentEditionComplete.ISBN := edISBN.Text;
    FCurrentEditionComplete.AnneeEdition := StrToIntDef(edAnneeEdition.Text, 0);
    FCurrentEditionComplete.Prix := StrToCurrDef(StringReplace(edPrix.Text, Utilisateur.Options.SymboleMonnetaire, '', []), 0);
    FCurrentEditionComplete.Editeur.ID_Editeur := vtEditeurs.CurrentValue;
    FCurrentEditionComplete.Editeur.NomEditeur := vtEditeurs.Caption;
    FCurrentEditionComplete.Collection.ID := vtCollections.CurrentValue;
    FCurrentEditionComplete.Collection.NomCollection := vtCollections.Caption;
    FCurrentEditionComplete.Stock := cbStock.Checked;
    FCurrentEditionComplete.VO := cbVO.Checked;
    FCurrentEditionComplete.Couleur := cbCouleur.Checked;
    FCurrentEditionComplete.Dedicace := cbDedicace.Checked;
    FCurrentEditionComplete.Gratuit := cbGratuit.Checked;
    FCurrentEditionComplete.Offert := cbOffert.Checked;
    FCurrentEditionComplete.TypeEdition := cbxEdition.Value;
    FCurrentEditionComplete.sTypeEdition := cbxEdition.Caption;
    FCurrentEditionComplete.Etat := cbxEtat.Value;
    FCurrentEditionComplete.sEtat := cbxEtat.Caption;
    FCurrentEditionComplete.Reliure := cbxReliure.Value;
    FCurrentEditionComplete.sReliure := cbxReliure.Caption;
    FCurrentEditionComplete.Orientation := cbxOrientation.Value;
    FCurrentEditionComplete.sOrientation := cbxOrientation.Caption;
    FCurrentEditionComplete.FormatEdition := cbxFormat.Value;
    FCurrentEditionComplete.sFormatEdition := cbxFormat.Caption;
    FCurrentEditionComplete.NombreDePages := StrToIntDef(edNombreDePages.Text, 0);
    FCurrentEditionComplete.AnneeCote := StrToIntDef(edAnneeCote.Text, 0);
    FCurrentEditionComplete.PrixCote := StrToCurrDef(StringReplace(edPrixCote.Text, Utilisateur.Options.SymboleMonnetaire, '', []), 0);
    if dtpAchat.Checked then
      FCurrentEditionComplete.DateAchat := Trunc(dtpAchat.Date)
    else
      FCurrentEditionComplete.DateAchat := 0;
    FCurrentEditionComplete.Notes.Text := edNotes.Lines.Text;
  end;
end;

procedure TFrmEditAlbum.RefreshEditionCaption;
var
  s: string;
begin
  if not FEditionChanging and Assigned(FCurrentEditionComplete) then begin
    UpdateEdition;
    s := FCurrentEditionComplete.ChaineAffichage;
    if FCurrentEditionComplete.RecInconnu then s := '* ' + s;
    vtEditions.Items[vtEditions.ItemIndex] := s;
  end;
end;

procedure TFrmEditAlbum.edAnneeEditionChange(Sender: TObject);
begin
  RefreshEditionCaption;
end;

procedure TFrmEditAlbum.vtCollectionsChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  RefreshEditionCaption;
end;

procedure TFrmEditAlbum.vtEditionsClick(Sender: TObject);
begin
  UpdateEdition;
  FEditionChanging := True;
  try
    if vtEditions.ItemIndex > -1 then
      FCurrentEditionComplete := Pointer(vtEditions.Items.Objects[vtEditions.ItemIndex])
    else
      FCurrentEditionComplete := nil;

    PanelEdition.Visible := Assigned(FCurrentEditionComplete);
    vstImages.Clear;
    vstImages.RootNodeCount := 0;
    if Assigned(FCurrentEditionComplete) then begin
      edISBN.Text := ClearISBN(FCurrentEditionComplete.ISBN);
      edAnneeEdition.Text := NonZero(IntToStr(FCurrentEditionComplete.AnneeEdition));
      if FCurrentEditionComplete.Prix = 0 then
        edPrix.Text := ''
      else
        edPrix.Text := FormatCurr(FormatMonnaie, FCurrentEditionComplete.Prix);
      vtEditeurs.CurrentValue := FCurrentEditionComplete.Editeur.ID_Editeur;
      if IsEqualGUID(vtEditeurs.CurrentValue, GUID_NULL) then vtEditeurs.FullCollapse;
      vtCollections.CurrentValue := FCurrentEditionComplete.Collection.ID;
      cbStock.Checked := FCurrentEditionComplete.Stock;
      cbVO.Checked := FCurrentEditionComplete.VO;
      cbCouleur.Checked := FCurrentEditionComplete.Couleur;
      cbDedicace.Checked := FCurrentEditionComplete.Dedicace;
      cbGratuit.Checked := FCurrentEditionComplete.Gratuit;
      cbOffert.Checked := FCurrentEditionComplete.Offert;
      cbOffertClick(nil);
      cbxEdition.Value := FCurrentEditionComplete.TypeEdition;
      cbxEtat.Value := FCurrentEditionComplete.Etat;
      cbxReliure.Value := FCurrentEditionComplete.Reliure;
      cbxOrientation.Value := FCurrentEditionComplete.Orientation;
      cbxFormat.Value := FCurrentEditionComplete.FormatEdition;
      dtpAchat.Date := Now;
      dtpAchat.Checked := FCurrentEditionComplete.DateAchat > 0;
      if dtpAchat.Checked then dtpAchat.Date := FCurrentEditionComplete.DateAchat;
      edNombreDePages.Text := NonZero(IntToStr(FCurrentEditionComplete.NombreDePages));
      edAnneeCote.Text := NonZero(IntToStr(FCurrentEditionComplete.AnneeCote));
      if FCurrentEditionComplete.PrixCote = 0 then
        edPrixCote.Text := ''
      else
        edPrixCote.Text := FormatCurr(FormatMonnaie, FCurrentEditionComplete.PrixCote);
      edNotes.Lines.Text := FCurrentEditionComplete.Notes.Text;
      vstImages.RootNodeCount := FCurrentEditionComplete.Couvertures.Count;
    end;
  finally
    ChoixImage.Enabled := Assigned(FCurrentEditionComplete);
    FEditionChanging := False;
  end;
end;

procedure TFrmEditAlbum.vtSeriesDblClick(Sender: TObject);
var
  i: TGUID;
begin
  if (vtSeries.GetFirstSelected <> nil) then begin
    ModifierSeries(vtSeries);
    i := vtCollections.CurrentValue;
    vtEditeurs.InitializeRep;
    vtCollections.InitializeRep;
    vtCollections.CurrentValue := i;
    vtSeriesChange(vtSeries, vtSeries.GetFirstSelected);
  end;
end;

procedure TFrmEditAlbum.vtPersonnesDblClick(Sender: TObject);
var
  i: Integer;
  iCurrentAuteur: TGUID;
  Auteur: TAuteur;
  CurrentAuteur: TPersonnage;
begin
  iCurrentAuteur := vtPersonnes.CurrentValue;
  if ModifierAuteurs(vtPersonnes) then begin
    CurrentAuteur := vtPersonnes.GetFocusedNodeData;
    for i := 0 to Pred(lvScenaristes.Items.Count) do begin
      Auteur := lvScenaristes.Items[i].Data;
      if IsEqualGUID(Auteur.Personne.ID, iCurrentAuteur) then begin
        Auteur.Personne.Assign(CurrentAuteur);
        lvScenaristes.Items[i].Caption := Auteur.ChaineAffichage;
      end;
    end;
    lvScenaristes.Invalidate;
    for i := 0 to Pred(lvDessinateurs.Items.Count) do begin
      Auteur := lvDessinateurs.Items[i].Data;
      if IsEqualGUID(Auteur.Personne.ID, iCurrentAuteur) then begin
        Auteur.Personne.Assign(CurrentAuteur);
        lvDessinateurs.Items[i].Caption := Auteur.ChaineAffichage;
      end;
    end;
    lvDessinateurs.Invalidate;
    for i := 0 to Pred(lvColoristes.Items.Count) do begin
      Auteur := lvColoristes.Items[i].Data;
      if IsEqualGUID(Auteur.Personne.ID, iCurrentAuteur) then begin
        Auteur.Personne.Assign(CurrentAuteur);
        lvColoristes.Items[i].Caption := Auteur.ChaineAffichage;
      end;
    end;
    lvColoristes.Invalidate;
  end;
end;

procedure TFrmEditAlbum.vtEditeursDblClick(Sender: TObject);
begin
  ModifierEditeurs(vtEditeurs);
end;

procedure TFrmEditAlbum.vtCollectionsDblClick(Sender: TObject);
begin
  ModifierCollections(vtCollections);
end;

procedure TFrmEditAlbum.cbIntegraleClick(Sender: TObject);
var
  cl: TColor;
begin
  edTomeDebut.Enabled := cbIntegrale.Checked;
  edTomeFin.Enabled := cbIntegrale.Checked;
  if cbIntegrale.Checked then
    cl := clWindowText
  else
    cl := clInactiveCaptionText;
  Label16.Font.Color := cl;
  Label17.Font.Color := cl;
end;

procedure TFrmEditAlbum.cbGratuitClick(Sender: TObject);
begin
  if cbGratuit.Checked then edPrix.Text := '';
end;

procedure TFrmEditAlbum.edPrixChange(Sender: TObject);
begin
  if edPrix.Text <> '' then cbGratuit.Checked := False;
end;

procedure TFrmEditAlbum.VisuClose(Sender: TObject);
begin
  TForm(TImage(Sender).Parent).ModalResult := mrCancel;
end;

procedure TFrmEditAlbum.imgVisuClick(Sender: TObject);
var
  PC: TCouverture;
  hg: IHourGlass;
  ms: TStream;
  jpg: TJPEGImage;
  Couverture: TImage;
  Frm: TForm;
begin
  if not Assigned(vstImages.FocusedNode) then Exit;
  PC := FCurrentEditionComplete.Couvertures[vstImages.FocusedNode.Index];
  hg := THourGlass.Create;
  if IsEqualGUID(PC.ID, GUID_NULL) then
    ms := GetCouvertureStream(PC.NewNom, 400, 500, Utilisateur.Options.AntiAliasing)
  else
    ms := GetCouvertureStream(False, PC.ID, 400, 500, Utilisateur.Options.AntiAliasing);
  if Assigned(ms) then try
    jpg := TJPEGImage.Create;
    Frm := TForm.Create(Self);
    Couverture := TImage.Create(Frm);
    try
      jpg.LoadFromStream(ms);
      Frm.BorderIcons := [];
      Frm.BorderStyle := bsToolWindow;
      Frm.Position := poOwnerFormCenter;
      Couverture.Parent := Frm;
      Couverture.Picture.Assign(jpg);
      Couverture.Cursor := crHandPoint;
      Couverture.OnClick := VisuClose;
      Couverture.AutoSize := True;
      Frm.AutoSize := True;
      Frm.ShowModal;
    finally
      FreeAndNil(jpg);
      FreeAndNil(Couverture);
      FreeAndNil(Frm);
    end;
  finally
    FreeAndNil(ms);
  end;
end;

procedure TFrmEditAlbum.vstImagesDblClick(Sender: TObject);
var
  PC: TCouverture;
begin
  if not Assigned(vstImages.FocusedNode) then Exit;
  PC := FCurrentEditionComplete.Couvertures[vstImages.FocusedNode.Index];
  if IsEqualGUID(PC.ID, GUID_NULL) then
    with ChoixImageDialog do begin
      Options := Options - [ofAllowMultiSelect];
      FileName := PC.NewNom;
      if Execute then begin
        PC.NewNom := FileName;
        vstImages.InvalidateNode(vstImages.FocusedNode);
      end;
    end;
end;

procedure TFrmEditAlbum.cbOffertClick(Sender: TObject);
begin
  if cbOffert.Checked then
    Label18.Caption := rsTransOffertLe
  else
    Label18.Caption := rsTransAcheteLe;
end;

procedure TFrmEditAlbum.vstImagesStructureChange(Sender: TBaseVirtualTree; Node: PVirtualNode; Reason: TChangeReason);
begin
  vstImagesChange(Sender, vstImages.FocusedNode);
end;

procedure TFrmEditAlbum.VDTButton13Click(Sender: TObject);
var
  dummy, Code: string;
begin
  if InputQuery('EAN-ISBN', 'Saisir le numéro EAN-ISBN de l''édition:', Code) then begin
    dummy := Code;
    if not VerifieEAN(dummy) and (MessageDlg(Code + #13#13'Le caractère de contrôle de ce numéro EAN-ISBN n''est pas correct.'#13#10'Voulez-vous néanmoins utiliser ce code barre?', mtWarning, [mbYes, mbNo], 0) = mrNo) then Exit;
    if StrToIntDef(edAnneeEdition.Text, 0) >= 2007 then begin // en 2007, les ISBN passent à 13 caractères
      Code := Copy(Code, 1, 12);
      VerifieISBN(Code, 13)
    end
    else begin
      Code := Copy(Code, 4, 9);
      VerifieISBN(Code, 10)
    end;
    edisbn.Text := Code;
  end;
end;

procedure TFrmEditAlbum.vtEditionsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  OldIndex: Integer;
begin
  if Key = VK_DELETE then begin
    OldIndex := vtEditions.ItemIndex;

    vtEditions.DeleteSelected;
    FAlbum.Editions.Editions.Delete(OldIndex);
    if OldIndex < vtEditions.Items.Count then
      vtEditions.ItemIndex := OldIndex
    else
      vtEditions.ItemIndex := Pred(vtEditions.Items.Count);
    vtEditionsClick(vtEditions);
  end;
end;

procedure TFrmEditAlbum.VDTButton14Click(Sender: TObject);
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

procedure TFrmEditAlbum.vstImagesMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  pt: TPoint;
  Node: PVirtualNode;
begin
  Node := vstImages.GetNodeAt(X, Y);
  if (Node <> nil) and (vstImages.Header.Columns.ColumnFromPosition(Point(X, Y)) = 1) then begin
    with vstImages.GetDisplayRect(Node, 1, False) do begin
      X := Left;
      Y := Bottom;
    end;
    pt := vstImages.ClientToScreen(Point(X, Y));
    pmChoixCategorie.PopupComponent := TComponent(Node.Index);
    pmChoixCategorie.Tag := TCouverture(FCurrentEditionComplete.Couvertures[Node.Index]).Categorie;
    pmChoixCategorie.Popup(pt.X, pt.Y);
  end;
end;

procedure TFrmEditAlbum.miChangeCategorieImageClick(Sender: TObject);
var
  PC: TCouverture;
begin
  PC := FCurrentEditionComplete.Couvertures[Integer(TPopupMenu(TMenuItem(Sender).GetParentMenu).PopupComponent)];
  PC.Categorie := Integer(TMenuItem(Sender).Tag);
  PC.sCategorie := FCategoriesImages.Values[IntToStr(PC.Categorie)];
  vstImages.Invalidate;
end;

procedure TFrmEditAlbum.pmChoixCategoriePopup(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to Pred(pmChoixCategorie.Items.Count) do
    pmChoixCategorie.Items[i].Checked := pmChoixCategorie.Tag = pmChoixCategorie.Items[i].Tag;
end;

procedure TFrmEditAlbum.EditeurCollectionSelected(Sender: TObject; NextSearch: Boolean);
begin
  FEditeurCollectionSelected[vtEditions.ItemIndex] := True;
end;

procedure TFrmEditAlbum.lvScenaristesData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FAlbum.Scenaristes[Item.Index];
  Item.Caption := TAuteur(Item.Data).ChaineAffichage;
end;

procedure TFrmEditAlbum.lvDessinateursData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FAlbum.Dessinateurs[Item.Index];
  Item.Caption := TAuteur(Item.Data).ChaineAffichage;
end;

procedure TFrmEditAlbum.lvColoristesData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FAlbum.Coloristes[Item.Index];
  Item.Caption := TAuteur(Item.Data).ChaineAffichage;
end;

function TFrmEditAlbum.GetID_Album: TGUID;
begin
  Result := FAlbum.ID_Album;
end;

function TFrmEditAlbum.GetCreation: Boolean;
begin
  Result := FAlbum.RecInconnu;
end;

procedure TFrmEditAlbum.btResetSerieClick(Sender: TObject);
begin
  vtSeries.CurrentValue := GUID_NULL;
end;

end.

