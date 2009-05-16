unit UfrmEditSerie;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Db, StdCtrls, ExtCtrls, DBCtrls, Mask, Buttons, VDTButton, ComCtrls,
  EditLabeled, VirtualTrees, VirtualTree, LoadComplet, Menus, ExtDlgs, UframRechercheRapide, CRFurtif, UframBoutons, UBdtForms,
  ComboCheck, StrUtils, PngSpeedButton, UframVTEdit;

type
  TfrmEditSerie = class(TbdtForm)
    ScrollBox2: TScrollBox;
    Label5: TLabel;
    Label8: TLabel;
    Label2: TLabel;
    edTitre: TEditLabeled;
    Label17: TLabel;
    vtGenres: TVirtualStringTree;
    Label15: TLabel;
    Bevel3: TBevel;
    Bevel2: TBevel;
    Label6: TLabel;
    histoire: TMemoLabeled;
    Label7: TLabel;
    remarques: TMemoLabeled;
    cbTerminee: TCheckBoxLabeled;
    cbManquants: TCheckBoxLabeled;
    vtAlbums: TVirtualStringTree;
    VDTButton13: TVDTButton;
    edSite: TEditLabeled;
    Label1: TLabel;
    btScenariste: TCRFurtifLight;
    btDessinateur: TCRFurtifLight;
    Label19: TLabel;
    btColoriste: TCRFurtifLight;
    lvScenaristes: TVDTListViewLabeled;
    lvDessinateurs: TVDTListViewLabeled;
    lvColoristes: TVDTListViewLabeled;
    vtParaBD: TVirtualStringTree;
    Bevel5: TBevel;
    Label3: TLabel;
    Label4: TLabel;
    FrameRechercheRapideGenre: TFramRechercheRapide;
    Bevel1: TBevel;
    Frame11: TframBoutons;
    cbSorties: TCheckBoxLabeled;
    cbComplete: TCheckBoxLabeled;
    Label9: TLabel;
    edNbAlbums: TEditLabeled;
    cbCouleur: TCheckBoxLabeled;
    cbVO: TCheckBoxLabeled;
    Label12: TLabel;
    cbxEtat: TLightComboCheck;
    Label14: TLabel;
    cbxEdition: TLightComboCheck;
    Label13: TLabel;
    cbxReliure: TLightComboCheck;
    Label22: TLabel;
    cbxOrientation: TLightComboCheck;
    Label27: TLabel;
    cbxSensLecture: TLightComboCheck;
    Label23: TLabel;
    cbxFormat: TLightComboCheck;
    vtEditPersonnes: TframVTEdit;
    vtEditCollections: TframVTEdit;
    vtEditEditeurs: TframVTEdit;
    edAssociations: TMemoLabeled;
    Label10: TLabel;
    Bevel4: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Frame11btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edTitreChange(Sender: TObject);
    procedure vtGenresInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vtGenresChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtGenresDblClick(Sender: TObject);
    procedure vtAlbumsDblClick(Sender: TObject);
    procedure VDTButton13Click(Sender: TObject);
    procedure edSiteChange(Sender: TObject);
    procedure btColoristeClick(Sender: TObject);
    procedure lvColoristesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ScanEditKeyPress(Sender: TObject; var Key: Char);
    procedure lvScenaristesData(Sender: TObject; Item: TListItem);
    procedure lvDessinateursData(Sender: TObject; Item: TListItem);
    procedure lvColoristesData(Sender: TObject; Item: TListItem);
    procedure vtParaBDDblClick(Sender: TObject);
    procedure cbTermineeClick(Sender: TObject);
    procedure cbCompleteClick(Sender: TObject);
    procedure vtEditPersonnesVTEditChange(Sender: TObject);
    procedure OnEditPersonne(Sender: TObject);
    procedure vtEditEditeursVTEditChange(Sender: TObject);
  private
    { Déclarations privées }
    FSerie: TSerieComplete;
    procedure SetSerie(Value: TSerieComplete);
    function GetID_Serie: TGUID;
  public
    { Déclarations publiques }
    property ID_Serie: TGUID read GetID_Serie;
    property Serie: TSerieComplete read FSerie write SetSerie;
  end;

implementation

uses
  Commun, Proc_Gestions, TypeRec, Procedures, Divers, Textes, StdConvs, ShellAPI, CommonConst, JPEG,
  UHistorique, UMetadata;

{$R *.DFM}

const
  RemplacerValeur = 'Remplacer %s par %s ?';
  PasModifier = 'Impossible de modifier le support !';
  PasAjouter = 'Impossible d''ajouter le support !';

procedure TfrmEditSerie.FormCreate(Sender: TObject);
begin
  PrepareLV(Self);
  FrameRechercheRapideGenre.VirtualTreeView := vtGenres;
  vtGenres.Mode := vmGenres;
  vtGenres.CheckImageKind := ckXP;
  vtGenres.TreeOptions.MiscOptions := vtGenres.TreeOptions.MiscOptions + [toCheckSupport];
  vtEditPersonnes.Mode := vmPersonnes;
  vtEditPersonnes.VTEdit.LinkControls.Add(Label19);
  vtEditEditeurs.Mode := vmEditeurs;
  vtEditCollections.Mode := vmNone;
  vtEditCollections.VTEdit.PopupWindow.TreeView.UseFiltre := True;
  vtEditCollections.VTEdit.LinkControls.Add(Label8);
  vtEditEditeurs.VTEdit.LinkControls.Add(Label5);
  vtAlbums.Mode := vmNone;
  vtAlbums.UseFiltre := True;
  vtParaBD.Mode := vmNone;
  vtParaBD.UseFiltre := True;
  vtEditPersonnes.AfterEdit := OnEditPersonne;

  LoadCombo(1 {Etat}, cbxEtat);
  cbxEtat.Value := -1;
  LoadCombo(2 {Reliure}, cbxReliure);
  cbxReliure.Value := -1;
  LoadCombo(3 {TypeEdition}, cbxEdition);
  cbxEdition.Value := -1;
  LoadCombo(4 {Orientation}, cbxOrientation);
  cbxOrientation.Value := -1;
  LoadCombo(5 {Format}, cbxFormat);
  cbxFormat.Value := -1;
  LoadCombo(8 {Sens de lecture}, cbxSensLecture);
  cbxSensLecture.Value := -1;
end;

procedure TfrmEditSerie.FormDestroy(Sender: TObject);
begin
  lvScenaristes.Items.Count := 0;
  lvDessinateurs.Items.Count := 0;
  lvColoristes.Items.Count := 0;
end;

procedure TfrmEditSerie.Frame11btnOKClick(Sender: TObject);
begin
  if Length(Trim(edTitre.Text)) = 0 then
  begin
    AffMessage(rsTitreObligatoire, mtInformation, [mbOk], True);
    edTitre.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;
  if IsEqualGUID(vtEditEditeurs.CurrentValue, GUID_NULL) then
  begin
    AffMessage(rsEditeurObligatoire, mtInformation, [mbOk], True);
    vtEditEditeurs.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;

  FSerie.Titre := Trim(edTitre.Text);
  FSerie.Terminee := Integer(cbTerminee.State);
  FSerie.SuivreSorties := cbSorties.Checked;
  FSerie.Complete := cbComplete.Checked;
  FSerie.SuivreManquants := cbManquants.Checked;
  FSerie.NbAlbums := StrToIntDef(edNbAlbums.Text, -1);
  FSerie.SiteWeb := Trim(edSite.Text);
  FSerie.ID_Editeur := vtEditEditeurs.CurrentValue;
  FSerie.ID_Collection := vtEditCollections.CurrentValue;
  FSerie.Sujet.Text := histoire.Text;
  FSerie.Notes.Text := remarques.Text;

  FSerie.VO := Integer(cbVO.State);
  FSerie.Couleur := Integer(cbCouleur.State);

  FSerie.TypeEdition := MakeOption(cbxEdition.Value, cbxEdition.Caption);
  FSerie.Etat := MakeOption(cbxEtat.Value, cbxEtat.Caption);
  FSerie.Reliure := MakeOption(cbxReliure.Value, cbxReliure.Caption);
  FSerie.Orientation := MakeOption(cbxOrientation.Value, cbxOrientation.Caption);
  FSerie.FormatEdition := MakeOption(cbxFormat.Value, cbxFormat.Caption);
  FSerie.SensLecture := MakeOption(cbxSensLecture.Value, cbxSensLecture.Caption);

  FSerie.Associations.Text := edAssociations.Lines.Text;

  FSerie.SaveToDatabase;
  FSerie.SaveAssociations(vmSeries, GUID_NULL);

  ModalResult := mrOk;
end;

procedure TfrmEditSerie.SetSerie(Value: TSerieComplete);
var
  i: Integer;
  hg: IHourGlass;
  s: string;
begin
  hg := THourGlass.Create;
  FSerie := Value;
  FSerie.FillAssociations(vmSeries);

  lvScenaristes.Items.BeginUpdate;
  lvDessinateurs.Items.BeginUpdate;
  lvColoristes.Items.BeginUpdate;
  try
    edTitre.Text := FSerie.Titre;
    if FSerie.Terminee = -1 then
      cbTerminee.State := cbGrayed
    else
      cbTerminee.State := TCheckBoxState(FSerie.Terminee);
    cbSorties.Checked := FSerie.SuivreSorties;
    vtEditEditeurs.CurrentValue := FSerie.ID_Editeur;
    vtEditCollections.CurrentValue := FSerie.ID_Collection;
    cbComplete.Checked := FSerie.Complete;
    cbManquants.Checked := FSerie.SuivreManquants;
    histoire.Text := FSerie.Sujet.Text;
    remarques.Text := FSerie.Notes.Text;
    edSite.Text := FSerie.SiteWeb;
    if FSerie.NbAlbums > 0 then
      edNbAlbums.Text := IntToStr(FSerie.NbAlbums);

    lvScenaristes.Items.Count := FSerie.Scenaristes.Count;
    lvDessinateurs.Items.Count := FSerie.Dessinateurs.Count;
    lvColoristes.Items.Count := FSerie.Coloristes.Count;

    s := '';
    for i := 0 to Pred(FSerie.Genres.Count) do
      AjoutString(s, FSerie.Genres.ValueFromIndex[i], ', ');
    Label15.Caption := s;

    if FSerie.VO = -1 then
      cbVO.State := cbGrayed
    else
      cbVO.State := TCheckBoxState(FSerie.VO);
    if FSerie.Couleur = -1 then
      cbCouleur.State := cbGrayed
    else
      cbCouleur.State := TCheckBoxState(FSerie.Couleur);
    cbxEdition.Value := FSerie.TypeEdition.Value;
    cbxEtat.Value := FSerie.Etat.Value;
    cbxReliure.Value := FSerie.Reliure.Value;
    cbxOrientation.Value := FSerie.Orientation.Value;
    cbxFormat.Value := FSerie.FormatEdition.Value;
    cbxSensLecture.Value := FSerie.SensLecture.Value;

    vtAlbums.Filtre := 'ID_Serie = ' + QuotedStr(GUIDToString(ID_Serie));
    vtAlbums.Mode := vmAlbumsSerie;
    vtAlbums.FullExpand;

    vtParaBD.Filtre := 'ID_Serie = ' + QuotedStr(GUIDToString(ID_Serie));
    vtParaBD.Mode := vmParaBDSerie;
    vtParaBD.FullExpand;

    edAssociations.Text := FSerie.Associations.Text;
  finally
    lvScenaristes.Items.EndUpdate;
    lvDessinateurs.Items.EndUpdate;
    lvColoristes.Items.EndUpdate;
  end;
end;

procedure TfrmEditSerie.FormShow(Sender: TObject);
begin
  edTitre.SetFocus;
end;

procedure TfrmEditSerie.edTitreChange(Sender: TObject);
begin
  Caption := 'Saisie de série - ' + FormatTitre(edTitre.Text);
end;

procedure TfrmEditSerie.vtGenresInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  if Sender.GetNodeLevel(Node) > 0 then
  begin
    Node.CheckType := ctCheckBox;
    if Assigned(FSerie) and (FSerie.Genres.IndexOfName(GUIDToString(TGenre(RNodeInfo(vtGenres.GetNodeData(Node)^).Detail).ID)) <> -1) then
      Node.CheckState := csCheckedNormal
    else
      Node.CheckState := csUncheckedNormal;
  end;
end;

procedure TfrmEditSerie.vtGenresChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  s: string;
  i: Integer;
  PG: TGenre;
  NodeInfo: PNodeInfo;
begin
  NodeInfo := vtGenres.GetNodeData(Node);
  if Assigned(NodeInfo) and Assigned(NodeInfo.Detail) then
  begin
    PG := NodeInfo.Detail as TGenre;
    i := FSerie.Genres.IndexOfName(GUIDToString(PG.ID));
    if i = -1 then
      FSerie.Genres.Values[GUIDToString(PG.ID)] := PG.Genre
    else
      FSerie.Genres.Delete(i);
    s := '';
    for i := 0 to Pred(FSerie.Genres.Count) do
      AjoutString(s, FSerie.Genres.ValueFromIndex[i], ', ');
    Label15.Caption := s;
  end;
end;

procedure TfrmEditSerie.vtEditEditeursVTEditChange(Sender: TObject);
var
  ID_Editeur: TGUID;
begin
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
end;

procedure TfrmEditSerie.vtEditPersonnesVTEditChange(Sender: TObject);
var
  IdPersonne: TGUID;

  function NotIn(LV: TListView): Boolean;
  var
    i: Integer;
  begin
    // PRealisateur peut être utilisé pour transtyper un PActeur
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
  btScenariste.Enabled := (not IsEqualGUID(IdPersonne, GUID_NULL)) and NotIn(LVScenaristes);
  btDessinateur.Enabled := (not IsEqualGUID(IdPersonne, GUID_NULL)) and NotIn(LVDessinateurs);
  btColoriste.Enabled := (not IsEqualGUID(IdPersonne, GUID_NULL)) and NotIn(LVColoristes);
end;

procedure TfrmEditSerie.vtGenresDblClick(Sender: TObject);
begin
  Historique.AddWaiting(fcGestionModif, nil, nil, @ModifierGenres, vtGenres);
end;

procedure TfrmEditSerie.vtAlbumsDblClick(Sender: TObject);
begin
  Historique.AddWaiting(fcGestionModif, nil, nil, @ModifierAlbums, vtAlbums);
end;

procedure TfrmEditSerie.VDTButton13Click(Sender: TObject);
begin
  ShellExecute(Application.DialogHandle, nil, PChar(edSite.Text), nil, nil, SW_NORMAL);
end;

procedure TfrmEditSerie.edSiteChange(Sender: TObject);
begin
  VDTButton13.Enabled := CompareMem(PChar(LowerCase(Trim(edSite.Text))), PChar('http://'), 7);
end;

procedure TfrmEditSerie.OnEditPersonne(Sender: TObject);
var
  i: Integer;
  Auteur: TAuteur;
  CurrentAuteur: TPersonnage;
begin
  CurrentAuteur := vtEditPersonnes.VTEdit.Data;
  for i := 0 to Pred(lvScenaristes.Items.Count) do
  begin
    Auteur := lvScenaristes.Items[i].Data;
    if IsEqualGUID(Auteur.Personne.ID, vtEditPersonnes.CurrentValue) then
    begin
      Auteur.Personne.Assign(CurrentAuteur);
      lvScenaristes.Invalidate;
    end;
  end;
  lvScenaristes.Invalidate;
  for i := 0 to Pred(lvDessinateurs.Items.Count) do
  begin
    Auteur := lvDessinateurs.Items[i].Data;
    if IsEqualGUID(Auteur.Personne.ID, vtEditPersonnes.CurrentValue) then
    begin
      Auteur.Personne.Assign(CurrentAuteur);
      lvDessinateurs.Invalidate;
    end;
  end;
  lvDessinateurs.Invalidate;
  for i := 0 to Pred(lvColoristes.Items.Count) do
  begin
    Auteur := lvColoristes.Items[i].Data;
    if IsEqualGUID(Auteur.Personne.ID, vtEditPersonnes.CurrentValue) then
    begin
      Auteur.Personne.Assign(CurrentAuteur);
      lvColoristes.Invalidate;
    end;
  end;
  lvColoristes.Invalidate;
end;

procedure TfrmEditSerie.btColoristeClick(Sender: TObject);
var
  PA: TAuteur;
begin
  if IsEqualGUID(vtEditPersonnes.CurrentValue, GUID_NULL) then
    Exit;
  case TSpeedButton(Sender).Tag of
    1:
    begin
      PA := TAuteur.Create;
      PA.Fill(TPersonnage(vtEditPersonnes.VTEdit.Data), GUID_NULL, ID_Serie, maScenariste);
      FSerie.Scenaristes.Add(PA);
      lvScenaristes.Items.Count := FSerie.Scenaristes.Count;
      lvScenaristes.Invalidate;
    end;
    2:
    begin
      PA := TAuteur.Create;
      PA.Fill(TPersonnage(vtEditPersonnes.VTEdit.Data), GUID_NULL, ID_Serie, maDessinateur);
      FSerie.Dessinateurs.Add(PA);
      lvDessinateurs.Items.Count := FSerie.Dessinateurs.Count;
      lvDessinateurs.Invalidate;
    end;
    3:
    begin
      PA := TAuteur.Create;
      PA.Fill(TPersonnage(vtEditPersonnes.VTEdit.Data), GUID_NULL, ID_Serie, maColoriste);
      FSerie.Coloristes.Add(PA);
      lvColoristes.Items.Count := FSerie.Coloristes.Count;
      lvColoristes.Invalidate;
    end;
  end;
  vtEditPersonnesVTEditChange(vtEditPersonnes.VTEdit);
end;

procedure TfrmEditSerie.lvColoristesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  src: TListView;
begin
  if Key <> VK_DELETE then
    Exit;
  src := TListView(Sender);
  if src = lvScenaristes then
    FSerie.Scenaristes.Delete(src.Selected.Index);
  if src = lvDessinateurs then
    FSerie.Dessinateurs.Delete(src.Selected.Index);
  if src = lvColoristes then
    FSerie.Coloristes.Delete(src.Selected.Index);
  lvScenaristes.Items.Count := FSerie.Scenaristes.Count;
  lvDessinateurs.Items.Count := FSerie.Dessinateurs.Count;
  lvColoristes.Items.Count := FSerie.Coloristes.Count;
  src.Invalidate;
  vtEditPersonnesVTEditChange(vtEditPersonnes.VTEdit);
end;

procedure TfrmEditSerie.ScanEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    if vtGenres.GetFirstSelected <> nil then
      if vtGenres.CheckState[vtGenres.GetFirstSelected] = csCheckedNormal then
        vtGenres.CheckState[vtGenres.GetFirstSelected] := csUncheckedNormal
      else
        vtGenres.CheckState[vtGenres.GetFirstSelected] := csCheckedNormal;
  end;
end;

function TfrmEditSerie.GetID_Serie: TGUID;
begin
  Result := FSerie.ID_Serie;
end;

procedure TfrmEditSerie.lvScenaristesData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FSerie.Scenaristes[Item.Index];
  Item.Caption := TAuteur(Item.Data).ChaineAffichage;
end;

procedure TfrmEditSerie.lvDessinateursData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FSerie.Dessinateurs[Item.Index];
  Item.Caption := TAuteur(Item.Data).ChaineAffichage;
end;

procedure TfrmEditSerie.lvColoristesData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FSerie.Coloristes[Item.Index];
  Item.Caption := TAuteur(Item.Data).ChaineAffichage;
end;

procedure TfrmEditSerie.vtParaBDDblClick(Sender: TObject);
begin
  Historique.AddWaiting(fcGestionModif, nil, nil, @ModifierParaBD, vtParaBD);
end;

procedure TfrmEditSerie.cbTermineeClick(Sender: TObject);
begin
  cbSorties.Checked := not cbTerminee.Checked;
end;

procedure TfrmEditSerie.cbCompleteClick(Sender: TObject);
begin
  cbManquants.Checked := not cbComplete.Checked;
end;

end.