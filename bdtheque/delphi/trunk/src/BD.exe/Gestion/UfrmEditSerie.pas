﻿unit UfrmEditSerie;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.Mask, Vcl.Buttons, VDTButton, Vcl.ComCtrls,
  EditLabeled, VirtualTrees, BDTK.GUI.Controls.VirtualTree, BD.Entities.Full, Vcl.Menus, Vcl.ExtDlgs, BDTK.GUI.Frames.QuickSearch, BD.GUI.Frames.Buttons, BD.GUI.Forms,
  ComboCheck, System.StrUtils, PngSpeedButton, UframVTEdit;

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
    edHistoire: TMemoLabeled;
    Label7: TLabel;
    edNotes: TMemoLabeled;
    cbTerminee: TCheckBoxLabeled;
    cbManquants: TCheckBoxLabeled;
    vtAlbums: TVirtualStringTree;
    VDTButton13: TVDTButton;
    edSite: TEditLabeled;
    Label1: TLabel;
    btScenariste: TVDTButton;
    btDessinateur: TVDTButton;
    Label19: TLabel;
    btColoriste: TVDTButton;
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
    Label28: TLabel;
    vtEditUnivers: TframVTEdit;
    Label11: TLabel;
    btUnivers: TVDTButton;
    lvUnivers: TVDTListViewLabeled;
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
    procedure vtEditUniversVTEditChange(Sender: TObject);
    procedure btUniversClick(Sender: TObject);
    procedure lvUniversData(Sender: TObject; Item: TListItem);
    procedure lvUniversKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Déclarations privées }
    FSerie: TSerieFull;
    procedure SetSerie(Value: TSerieFull);
    function GetID_Serie: TGUID;
  public
    { Déclarations publiques }
    property ID_Serie: TGUID read GetID_Serie;
    property Serie: TSerieFull read FSerie write SetSerie;
  end;

implementation

uses
  BD.Utils.StrUtils, Proc_Gestions, BD.Entities.Lite, BD.Utils.GUIUtils, Divers, BD.Strings, System.StdConvs, Winapi.ShellAPI, BD.Common, Vcl.Imaging.jpeg,
  UHistorique, BD.Entities.Metadata, BDTK.Entities.Dao.Lite, BDTK.Entities.Dao.Full, BDTK.GUI.Utils,
  BD.Entities.Common, BD.Entities.Factory.Lite, BD.Entities.Dao.Lambda, BD.Entities.Types;

{$R *.DFM}

const
  RemplacerValeur = 'Remplacer %s par %s ?';

procedure TfrmEditSerie.FormCreate(Sender: TObject);
begin
  PrepareLV(Self);
  FrameRechercheRapideGenre.VirtualTreeView := vtGenres;
  vtGenres.Mode := vmGenres;
  vtGenres.TreeOptions.MiscOptions := vtGenres.TreeOptions.MiscOptions + [toCheckSupport];
  vtEditPersonnes.Mode := vmPersonnes;
  vtEditPersonnes.VTEdit.LinkControls.Add(Label19);
  vtEditEditeurs.Mode := vmEditeurs;
  vtEditCollections.Mode := vmNone;
  vtEditCollections.VTEdit.PopupWindow.TreeView.UseFiltre := True;
  vtEditCollections.VTEdit.LinkControls.Add(Label8);
  vtEditEditeurs.VTEdit.LinkControls.Add(Label5);
  vtEditUnivers.Mode := vmUnivers;
  vtEditUnivers.VTEdit.LinkControls.Add(Label11);
  vtAlbums.Mode := vmNone;
  vtAlbums.UseFiltre := True;
  vtParaBD.Mode := vmNone;
  vtParaBD.UseFiltre := True;
  vtEditPersonnes.AfterEdit := OnEditPersonne;

  LoadCombo(cbxEtat, TDaoListe.ListEtats, -1);
  LoadCombo(cbxReliure, TDaoListe.ListReliures, -1);
  LoadCombo(cbxEdition, TDaoListe.ListTypesEdition, -1);
  LoadCombo(cbxOrientation, TDaoListe.ListOrientations, -1);
  LoadCombo(cbxFormat, TDaoListe.ListFormatsEdition, -1);
  LoadCombo(cbxSensLecture, TDaoListe.ListSensLecture, -1);
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

  FSerie.TitreSerie := Trim(edTitre.Text);
  FSerie.Terminee := cbTerminee.State;
  FSerie.SuivreSorties := cbSorties.Checked;
  FSerie.Complete := cbComplete.Checked;
  FSerie.SuivreManquants := cbManquants.Checked;
  FSerie.NbAlbums := StrToIntDef(edNbAlbums.Text, -1);
  FSerie.SiteWeb := Trim(edSite.Text);
  TDaoEditeurFull.Fill(FSerie.Editeur, vtEditEditeurs.CurrentValue, nil);
  TDaoCollectionLite.Fill(FSerie.Collection, vtEditCollections.CurrentValue);
  FSerie.Sujet := edHistoire.Text;
  FSerie.Notes := edNotes.Text;

  FSerie.VO := cbVO.State;
  FSerie.Couleur := cbCouleur.State;

  FSerie.TypeEdition := ROption.Create(cbxEdition.Value, cbxEdition.Caption);
  FSerie.Etat := ROption.Create(cbxEtat.Value, cbxEtat.Caption);
  FSerie.Reliure := ROption.Create(cbxReliure.Value, cbxReliure.Caption);
  FSerie.Orientation := ROption.Create(cbxOrientation.Value, cbxOrientation.Caption);
  FSerie.FormatEdition := ROption.Create(cbxFormat.Value, cbxFormat.Caption);
  FSerie.SensLecture := ROption.Create(cbxSensLecture.Value, cbxSensLecture.Caption);

  FSerie.Associations.Text := edAssociations.Lines.Text;

  TDaoSerieFull.SaveToDatabase(FSerie, nil);
  TDaoSerieFull.SaveAssociations(FSerie, vmSeries, GUID_NULL);

  ModalResult := mrOk;
end;

procedure TfrmEditSerie.SetSerie(Value: TSerieFull);
var
  i: Integer;
  hg: IHourGlass;
  s: string;
begin
  hg := THourGlass.Create;
  FSerie := Value;
  TDaoSerieFull.FillAssociations(FSerie, vmSeries);

  lvScenaristes.Items.BeginUpdate;
  lvDessinateurs.Items.BeginUpdate;
  lvColoristes.Items.BeginUpdate;
  try
    edTitre.Text := FSerie.TitreSerie;
    cbTerminee.State := FSerie.Terminee;
    cbSorties.Checked := FSerie.SuivreSorties;
    vtEditEditeurs.CurrentValue := FSerie.ID_Editeur;
    vtEditCollections.CurrentValue := FSerie.ID_Collection;
    cbComplete.Checked := FSerie.Complete;
    cbManquants.Checked := FSerie.SuivreManquants;
    edHistoire.Text := FSerie.Sujet;
    edNotes.Text := FSerie.Notes;
    edSite.Text := FSerie.SiteWeb;
    if FSerie.NbAlbums > 0 then
      edNbAlbums.Text := IntToStr(FSerie.NbAlbums);

    lvUnivers.Items.Count := FSerie.Univers.Count;
    lvScenaristes.Items.Count := FSerie.Scenaristes.Count;
    lvDessinateurs.Items.Count := FSerie.Dessinateurs.Count;
    lvColoristes.Items.Count := FSerie.Coloristes.Count;

    s := '';
    for i := 0 to Pred(FSerie.Genres.Count) do
      AjoutString(s, FSerie.Genres.ValueFromIndex[i], ', ');
    Label15.Caption := s;

    cbVO.State := FSerie.VO;
    cbCouleur.State := FSerie.Couleur;
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
    if Assigned(FSerie) and (FSerie.Genres.IndexOfName(GUIDToString(vtGenres.GetNodeBasePointer(Node).ID)) <> -1) then
      Node.CheckState := csCheckedNormal
    else
      Node.CheckState := csUncheckedNormal;
  end;
end;

procedure TfrmEditSerie.vtGenresChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  s: string;
  i: Integer;
  PG: TGenreLite;
begin
  PG := TGenreLite(vtGenres.GetNodeBasePointer(Node));
  if Assigned(PG) then
  begin
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

procedure TfrmEditSerie.vtEditUniversVTEditChange(Sender: TObject);
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
  Auteur: TAuteurLite;
  CurrentAuteur: TPersonnageLite;
begin
  CurrentAuteur := vtEditPersonnes.VTEdit.Data as TPersonnageLite;
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
  PA: TAuteurSerieLite;
begin
  if IsEqualGUID(vtEditPersonnes.CurrentValue, GUID_NULL) then
    Exit;
  case TSpeedButton(Sender).Tag of
    1:
      begin
        PA := TFactoryAuteurSerieLite.getInstance;
        TDaoAuteurSerieLite.Fill(PA, TPersonnageLite(vtEditPersonnes.VTEdit.Data), ID_Serie, maScenariste);
        FSerie.Scenaristes.Add(PA);
        lvScenaristes.Items.Count := FSerie.Scenaristes.Count;
        lvScenaristes.Invalidate;
      end;
    2:
      begin
        PA := TFactoryAuteurSerieLite.getInstance;
        TDaoAuteurSerieLite.Fill(PA, TPersonnageLite(vtEditPersonnes.VTEdit.Data), ID_Serie, maDessinateur);
        FSerie.Dessinateurs.Add(PA);
        lvDessinateurs.Items.Count := FSerie.Dessinateurs.Count;
        lvDessinateurs.Invalidate;
      end;
    3:
      begin
        PA := TFactoryAuteurSerieLite.getInstance;
        TDaoAuteurSerieLite.Fill(PA, TPersonnageLite(vtEditPersonnes.VTEdit.Data), ID_Serie, maColoriste);
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
  Item.Caption := TAuteurLite(Item.Data).ChaineAffichage;
end;

procedure TfrmEditSerie.lvUniversData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FSerie.Univers[Item.Index];
  Item.Caption := TUniversLite(Item.Data).ChaineAffichage;
end;

procedure TfrmEditSerie.lvUniversKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  src: TListView;
begin
  if Key <> VK_DELETE then
    Exit;
  src := TListView(Sender);
  if src = lvUnivers then
    FSerie.Univers.Delete(src.Selected.Index);
  lvUnivers.Items.Count := FSerie.Univers.Count;
  src.Invalidate;
  vtEditUniversVTEditChange(vtEditUnivers.VTEdit);
end;

procedure TfrmEditSerie.lvDessinateursData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FSerie.Dessinateurs[Item.Index];
  Item.Caption := TAuteurLite(Item.Data).ChaineAffichage;
end;

procedure TfrmEditSerie.lvColoristesData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FSerie.Coloristes[Item.Index];
  Item.Caption := TAuteurLite(Item.Data).ChaineAffichage;
end;

procedure TfrmEditSerie.vtParaBDDblClick(Sender: TObject);
begin
  Historique.AddWaiting(fcGestionModif, nil, nil, @ModifierParaBD, vtParaBD);
end;

procedure TfrmEditSerie.cbTermineeClick(Sender: TObject);
begin
  cbSorties.Checked := not cbTerminee.Checked;
end;

procedure TfrmEditSerie.btUniversClick(Sender: TObject);
begin
  if IsEqualGUID(vtEditUnivers.CurrentValue, GUID_NULL) then
    Exit;

  FSerie.Univers.Add(TFactoryUniversLite.Duplicate(TUniversLite(vtEditUnivers.VTEdit.Data)));
  lvUnivers.Items.Count := FSerie.Univers.Count;
  lvUnivers.Invalidate;

  vtEditUniversVTEditChange(vtEditUnivers.VTEdit);
end;

procedure TfrmEditSerie.cbCompleteClick(Sender: TObject);
begin
  cbManquants.Checked := not cbComplete.Checked;
end;

end.
