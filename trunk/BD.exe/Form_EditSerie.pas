unit Form_EditSerie;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Db, StdCtrls, ExtCtrls, DBCtrls, Mask, Buttons, VDTButton, ComCtrls,
  DBEditLabeled, VirtualTrees, VirtualTree, LoadComplet, Menus, ExtDlgs, Frame_RechercheRapide, CRFurtif, Fram_Boutons;

type
  TFrmEditSerie = class(TForm)
    ScrollBox2: TScrollBox;
    Label5: TLabel;
    Label8: TLabel;
    vtEditeurs: TVirtualStringTree;
    vtCollections: TVirtualStringTree;
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
    cbComplete: TCheckBoxLabeled;
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
    vtPersonnes: TVirtualStringTree;
    lvColoristes: TVDTListViewLabeled;
    vtParaBD: TVirtualStringTree;
    Bevel5: TBevel;
    Label3: TLabel;
    Label4: TLabel;
    FrameRechercheRapidePersonnes: TFrameRechercheRapide;
    FrameRechercheRapideGenre: TFrameRechercheRapide;
    FrameRechercheRapideCollection: TFrameRechercheRapide;
    FrameRechercheRapideEditeur: TFrameRechercheRapide;
    Bevel1: TBevel;
    Frame11: TFrame1;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Frame11btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OnNewCollection(Sender: TObject);
    procedure edTitreChange(Sender: TObject);
    procedure vtEditeursChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtGenresInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vtGenresChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtEditeursDblClick(Sender: TObject);
    procedure vtCollectionsDblClick(Sender: TObject);
    procedure vtGenresDblClick(Sender: TObject);
    procedure vtAlbumsDblClick(Sender: TObject);
    procedure VDTButton13Click(Sender: TObject);
    procedure edSiteChange(Sender: TObject);
    procedure vtPersonnesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtPersonnesDblClick(Sender: TObject);
    procedure btColoristeClick(Sender: TObject);
    procedure lvColoristesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ScanEditKeyPress(Sender: TObject; var Key: Char);
    procedure lvScenaristesData(Sender: TObject; Item: TListItem);
    procedure lvDessinateursData(Sender: TObject; Item: TListItem);
    procedure lvColoristesData(Sender: TObject; Item: TListItem);
    procedure vtParaBDDblClick(Sender: TObject);
  private
    { Déclarations privées }
    FSerie: TSerieComplete;
    procedure SetID_Serie(Value: TGUID);
    function GetID_Serie: TGUID;
  public
    { Déclarations publiques }
    property ID_Serie: TGUID read GetID_Serie write SetID_Serie;
  end;

implementation

uses
  Commun, Proc_Gestions, TypeRec, DM_Princ, JvUIB, Procedures, Divers, Textes, StdConvs, ShellAPI, CommonConst, JPEG;

{$R *.DFM}

const
  RemplacerValeur = 'Remplacer %s par %s ?';
  PasModifier = 'Impossible de modifier le support !';
  PasAjouter = 'Impossible d''ajouter le support !';

procedure TFrmEditSerie.FormCreate(Sender: TObject);
begin
  PrepareLV(Self);
  FrameRechercheRapidePersonnes.VirtualTreeView := vtPersonnes;
  FrameRechercheRapideEditeur.VirtualTreeView := vtEditeurs;
  FrameRechercheRapideCollection.VirtualTreeView := vtCollections;
  FrameRechercheRapideCollection.OnNew := OnNewCollection;
  FrameRechercheRapideGenre.VirtualTreeView := vtGenres;
  vtGenres.Mode := vmGenres;
  vtGenres.CheckImageKind := ckXP;
  vtGenres.TreeOptions.MiscOptions := vtGenres.TreeOptions.MiscOptions + [toCheckSupport];
  vtPersonnes.Mode := vmPersonnes;
  vtEditeurs.Mode := vmEditeurs;
  vtCollections.Mode := vmNone;
  vtCollections.UseFiltre := True;
  vtAlbums.Mode := vmNone;
  vtAlbums.UseFiltre := True;
  vtParaBD.Mode := vmNone;
  vtParaBD.UseFiltre := True;

  FSerie := TSerieComplete.Create;
end;

procedure TFrmEditSerie.FormDestroy(Sender: TObject);
begin
  lvScenaristes.Items.Count := 0;
  lvDessinateurs.Items.Count := 0;
  lvColoristes.Items.Count := 0;
  FSerie.Free;
end;

procedure TFrmEditSerie.Frame11btnOKClick(Sender: TObject);
begin
  if Length(Trim(edTitre.Text)) = 0 then begin
    AffMessage(rsTitreObligatoire, mtInformation, [mbOk], True);
    edTitre.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;

  FSerie.Titre := Trim(edTitre.Text);
  FSerie.Terminee := Integer(cbTerminee.State);
  FSerie.Complete := cbComplete.Checked;
  FSerie.SiteWeb := Trim(edSite.Text);
  FSerie.ID_Editeur := vtEditeurs.CurrentValue;
  FSerie.ID_Collection := vtCollections.CurrentValue;
  FSerie.Sujet.Text := histoire.Lines.Text;
  FSerie.Notes.Text := remarques.Lines.Text;

  FSerie.SaveToDatabase;

  ModalResult := mrOk;
end;

procedure TFrmEditSerie.SetID_Serie(Value: TGUID);
var
  i: Integer;
  hg: IHourGlass;
  s: string;
begin
  hg := THourGlass.Create;
  FSerie.Fill(Value);
  lvScenaristes.Items.BeginUpdate;
  lvDessinateurs.Items.BeginUpdate;
  lvColoristes.Items.BeginUpdate;
  try
    edTitre.Text := FSerie.Titre;
    if FSerie.Terminee = -1 then
      cbTerminee.State := cbGrayed
    else
      cbTerminee.State := TCheckBoxState(FSerie.Terminee);
    vtEditeurs.CurrentValue := FSerie.ID_Editeur;
    vtCollections.CurrentValue := FSerie.ID_Collection;
    cbComplete.Checked := FSerie.Complete;
    histoire.Lines.Text := FSerie.Sujet.Text;
    remarques.Lines.Text := FSerie.Notes.Text;
    edSite.Text := FSerie.SiteWeb;

    lvScenaristes.Items.Count := FSerie.Scenaristes.Count;
    lvDessinateurs.Items.Count := FSerie.Dessinateurs.Count;
    lvColoristes.Items.Count := FSerie.Coloristes.Count;

    s := '';
    for i := 0 to Pred(FSerie.Genres.Count) do
      AjoutString(s, FSerie.Genres.ValueFromIndex[i], ', ');
    Label15.Caption := s;

    vtAlbums.Filtre := 'ID_Serie = ' + QuotedStr(GUIDToString(ID_Serie));
    vtAlbums.Mode := vmAlbumsSerie;
    vtAlbums.FullExpand;

    vtParaBD.Filtre := 'ID_Serie = ' + QuotedStr(GUIDToString(ID_Serie));
    vtParaBD.Mode := vmParaBDSerie;
    vtParaBD.FullExpand;
  finally
    lvScenaristes.Items.EndUpdate;
    lvDessinateurs.Items.EndUpdate;
    lvColoristes.Items.EndUpdate;
  end;
end;

procedure TFrmEditSerie.FormShow(Sender: TObject);
begin
  edTitre.SetFocus;
end;

procedure TFrmEditSerie.OnNewCollection(Sender: TObject);
begin
  AjouterCollections(vtCollections, vtEditeurs.CurrentValue, FrameRechercheRapideCollection.edSearch.Text);
end;

procedure TFrmEditSerie.edTitreChange(Sender: TObject);
begin
  Caption := 'Saisie de série - ' + FormatTitre(edTitre.Text);
end;

procedure TFrmEditSerie.vtEditeursChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
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
end;

procedure TFrmEditSerie.vtGenresInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  if Sender.GetNodeLevel(Node) > 0 then begin
    Node.CheckType := ctCheckBox;
    if Assigned(FSerie) and (FSerie.Genres.IndexOfName(GUIDToString(TGenre(RNodeInfo(vtGenres.GetNodeData(Node)^).Detail).ID)) <> -1) then
      Node.CheckState := csCheckedNormal
    else
      Node.CheckState := csUncheckedNormal;
  end;
end;

procedure TFrmEditSerie.vtGenresChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  s: string;
  i: Integer;
  PG: TGenre;
  NodeInfo: PNodeInfo;
begin
  NodeInfo := vtGenres.GetNodeData(Node);
  if Assigned(NodeInfo) and Assigned(NodeInfo.Detail) then begin
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

procedure TFrmEditSerie.vtEditeursDblClick(Sender: TObject);
begin
  ModifierEditeurs(vtEditeurs);
end;

procedure TFrmEditSerie.vtCollectionsDblClick(Sender: TObject);
begin
  ModifierCollections(vtCollections);
end;

procedure TFrmEditSerie.vtGenresDblClick(Sender: TObject);
begin
  ModifierGenres(vtGenres);
end;

procedure TFrmEditSerie.vtAlbumsDblClick(Sender: TObject);
begin
  ModifierAlbums(vtAlbums);
end;

procedure TFrmEditSerie.VDTButton13Click(Sender: TObject);
begin
  ShellExecute(Application.DialogHandle, nil, PChar(edSite.Text), nil, nil, SW_NORMAL);
end;

procedure TFrmEditSerie.edSiteChange(Sender: TObject);
begin
  VDTButton13.Enabled := Copy(LowerCase(edSite.Text), 1, 7) = 'http://';
end;

procedure TFrmEditSerie.vtPersonnesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  IdPersonne: TGUID;

  function NotIn(LV: TListView): Boolean;
  var
    i: Integer;
  begin
    // PRealisateur peut être utilisé pour transtyper un PActeur
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

procedure TFrmEditSerie.vtPersonnesDblClick(Sender: TObject);
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
        lvScenaristes.Invalidate;
      end;
    end;
    lvScenaristes.Invalidate;
    for i := 0 to Pred(lvDessinateurs.Items.Count) do begin
      Auteur := lvDessinateurs.Items[i].Data;
      if IsEqualGUID(Auteur.Personne.ID, iCurrentAuteur) then begin
        Auteur.Personne.Assign(CurrentAuteur);
        lvDessinateurs.Invalidate;
      end;
    end;
    lvDessinateurs.Invalidate;
    for i := 0 to Pred(lvColoristes.Items.Count) do begin
      Auteur := lvColoristes.Items[i].Data;
      if IsEqualGUID(Auteur.Personne.ID, iCurrentAuteur) then begin
        Auteur.Personne.Assign(CurrentAuteur);
        lvColoristes.Invalidate;
      end;
    end;
    lvColoristes.Invalidate;
  end;
end;

procedure TFrmEditSerie.btColoristeClick(Sender: TObject);
var
  PA: TAuteur;
begin
  if IsEqualGUID(vtPersonnes.CurrentValue, GUID_NULL) then Exit;
  case TSpeedButton(Sender).Tag of
    1: begin
        PA := TAuteur.Create;
        PA.Fill(TPersonnage(vtPersonnes.GetFocusedNodeData), GUID_NULL, ID_Serie, 0);
        FSerie.Scenaristes.Add(PA);
        lvScenaristes.Items.Count := FSerie.Scenaristes.Count;
        lvScenaristes.Invalidate;
      end;
    2: begin
        PA := TAuteur.Create;
        PA.Fill(TPersonnage(vtPersonnes.GetFocusedNodeData), GUID_NULL, ID_Serie, 1);
        FSerie.Dessinateurs.Add(PA);
        lvDessinateurs.Items.Count := FSerie.Dessinateurs.Count;
        lvDessinateurs.Invalidate;
      end;
    3: begin
        PA := TAuteur.Create;
        PA.Fill(TPersonnage(vtPersonnes.GetFocusedNodeData), GUID_NULL, ID_Serie, 2);
        FSerie.Coloristes.Add(PA);
        lvColoristes.Items.Count := FSerie.Coloristes.Count;
        lvColoristes.Invalidate;
      end;
  end;
  vtPersonnesChange(vtPersonnes, vtPersonnes.FocusedNode);
end;

procedure TFrmEditSerie.lvColoristesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  src: TListView;
begin
  if Key <> VK_DELETE then Exit;
  src := TListView(Sender);
  if src = lvScenaristes then FSerie.Scenaristes.Delete(src.Selected.Index);
  if src = lvDessinateurs then FSerie.Dessinateurs.Delete(src.Selected.Index);
  if src = lvColoristes then FSerie.Coloristes.Delete(src.Selected.Index);
  lvScenaristes.Items.Count := FSerie.Scenaristes.Count;
  lvDessinateurs.Items.Count := FSerie.Dessinateurs.Count;
  lvColoristes.Items.Count := FSerie.Coloristes.Count;
  src.Invalidate;
  vtPersonnesChange(vtPersonnes, vtPersonnes.FocusedNode);
end;

procedure TFrmEditSerie.ScanEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    Key := #0;
    if vtGenres.GetFirstSelected <> nil then
      if vtGenres.CheckState[vtGenres.GetFirstSelected] = csCheckedNormal then
        vtGenres.CheckState[vtGenres.GetFirstSelected] := csUncheckedNormal
      else
        vtGenres.CheckState[vtGenres.GetFirstSelected] := csCheckedNormal;
  end;
end;

function TFrmEditSerie.GetID_Serie: TGUID;
begin
  Result := FSerie.ID_Serie;
end;

procedure TFrmEditSerie.lvScenaristesData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FSerie.Scenaristes[Item.Index];
  Item.Caption := TAuteur(Item.Data).ChaineAffichage;
end;

procedure TFrmEditSerie.lvDessinateursData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FSerie.Dessinateurs[Item.Index];
  Item.Caption := TAuteur(Item.Data).ChaineAffichage;
end;

procedure TFrmEditSerie.lvColoristesData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FSerie.Coloristes[Item.Index];
  Item.Caption := TAuteur(Item.Data).ChaineAffichage;
end;

procedure TFrmEditSerie.vtParaBDDblClick(Sender: TObject);
begin
  ModifierParaBD(vtParaBD);
end;

end.

