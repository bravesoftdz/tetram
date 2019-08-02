unit UfrmGestion;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, DBCtrls, ComCtrls, Db, Menus,
  ExtCtrls, Buttons, Proc_Gestions, VDTButton, VirtualTrees, BDTK.GUI.Controls.VirtualTree,
  BDTK.GUI.Frames.QuickSearch, BD.GUI.Forms, PngSpeedButton;

type
  PInfo_Gestion = ^RInfo_Gestion;

  RInfo_Gestion = record
    Mode: TVirtualMode;
    ListeHint, AjoutHint, ModifHint, SuppHint: string;
    ProcAjouter: TActionGestionAdd;
    ProcModifier: TActionGestionModif;
    ProcSupprimer: TActionGestionSupp;
    ProcAcheter: TActionGestionAchat;
    ProcImporter, ProcExporter: Boolean;
    Filtre: string;
    DerniereRecherche: string;
  end;

  TfrmGestions = class(TbdtForm)
    Panel3: TPanel;
    VDTButton2: TVDTButton;
    Bevel4: TBevel;
    ajouter: TVDTButton;
    modifier: TVDTButton;
    supprimer: TVDTButton;
    Panel14: TPanel;
    btAlbums: TVDTButton;
    btEditeurs: TVDTButton;
    btAuteurs: TVDTButton;
    btGenre: TVDTButton;
    btCollections: TVDTButton;
    btSeries: TVDTButton;
    btUnivers: TVDTButton;
    Bevel1: TBevel;
    Bevel3: TBevel;
    VirtualTreeView: TVirtualStringTree;
    Bevel2: TBevel;
    btAchatsAlbums: TVDTButton;
    Bevel6: TBevel;
    Bevel7: TBevel;
    btAcheter: TVDTButton;
    Bevel8: TBevel;
    btParaBD: TVDTButton;
    btAchatsParaBD: TVDTButton;
    FrameRechercheRapide1: TFramRechercheRapide;
    btExporter: TVDTButton;
    btImporter: TVDTButton;
    procedure FormCreate(Sender: TObject);
    function GestionCourante(SB: TSpeedButton = nil): PInfo_Gestion;
    procedure ajouterClick(Sender: TObject);
    procedure modifierClick(Sender: TObject);
    procedure supprimerClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure VDTButton2Click(Sender: TObject);
    procedure ScanEditKeyPress(Sender: TObject; var Key: Char);
    procedure btAcheterClick(Sender: TObject);
    procedure btImporterClick(Sender: TObject);
    procedure FrameRechercheRapide1edSearchChange(Sender: TObject);
  protected
  private
    { D�clarations priv�es }
    GestionAchatAlbum, GestionAlbum, GestionAuteur, GestionGenre, GestionCollection, GestionUnivers, GestionEditeur, GestionSerie, GestionParaBD, GestionAchatParaBD: RInfo_Gestion;
    LastButton: TSpeedButton;
    procedure AssignIG(var IG: RInfo_Gestion; Ajouter: TActionGestionAdd; Modifier: TActionGestionModif; Supprimer: TActionGestionSupp; const Liste_Hint, Ajout_Hint, Modif_Hint, Supp_Hint: string; Mode: TVirtualMode; const Filtre: string = ''; Acheter: TActionGestionAchat = nil; Importer: Boolean = False; Exporter: Boolean = False);
  public
    { D�clarations publiques }
    SelString: string;
  end;

var
  frmGestions: TfrmGestions;

implementation

uses
  BD.Utils.StrUtils, BD.Common, BD.Utils.GUIUtils, UfrmWizardImport, UHistorique;

const
  HintListeAlbums = 'Liste des albums';
  HintAjoutAlbum = 'Ajouter un album';
  HintModifAlbum = 'Modifier l''album s�lectionn�';
  HintSuppAlbum = 'Supprimer l''album s�lectionn�';
  HintListeAuteurs = 'Liste des auteurs';
  HintAjoutAuteur = 'Ajouter un auteur';
  HintModifAuteur = 'Modifier l''auteur s�lectionn�';
  HintSuppAuteur = 'Supprimer l''auteur s�lectionn�';
  HintListeUnivers = 'Liste des univers';
  HintAjoutUnivers = 'Ajouter un univers';
  HintModifUnivers = 'Modifier l''univers s�lectionn�';
  HintSuppUnivers = 'Supprimer l''univers s�lectionn�';
  HintListeSeries = 'Liste des s�ries';
  HintAjoutSerie = 'Ajouter une s�rie';
  HintModifSerie = 'Modifier la s�rie s�lectionn�e';
  HintSuppSerie = 'Supprimer la s�rie s�lectionn�e';
  HintListeGenres = 'Liste des genres';
  HintAjoutGenre = 'Ajouter un genre';
  HintModifGenre = 'Modifier le genre s�lectionn�';
  HintSuppGenre = 'Supprimer le genre s�lectionn�';
  HintListeEditeurs = 'Liste des �diteurs';
  HintAjoutEditeur = 'Ajouter un �diteur';
  HintModifEditeur = 'Modifier l''�diteur s�lectionn�';
  HintSuppEditeur = 'Supprimer l''�diteur s�lectionn�';
  HintListeCollections = 'Liste des collections';
  HintAjoutCollection = 'Ajouter une collection';
  HintModifCollection = 'Modifier la collection s�lectionn�e';
  HintSuppCollection = 'Supprimer la collection s�lectionn�e';
  HintListeParaBD = 'Liste des objets para-BD';
  HintAjoutParaBD = 'Ajouter un objet para-BD';
  HintModifParaBD = 'Modifier l''objet s�lectionn�';
  HintSuppParaBD = 'Supprimer l''objet s�lectionn�';

  NoSuppression = 'Impossible de supprimer un �l�ment pendant l''�dition d''un autre';

const
  First: Boolean = True;

{$R *.DFM}

procedure TfrmGestions.AssignIG(var IG: RInfo_Gestion; Ajouter: TActionGestionAdd; Modifier: TActionGestionModif; Supprimer: TActionGestionSupp; const Liste_Hint, Ajout_Hint, Modif_Hint, Supp_Hint: string; Mode: TVirtualMode; const Filtre: string = ''; Acheter: TActionGestionAchat = nil; Importer: Boolean = False; Exporter: Boolean = False);
begin
  IG.ProcAjouter := Ajouter;
  IG.ProcModifier := Modifier;
  IG.ProcSupprimer := Supprimer;
  IG.ListeHint := Liste_Hint;
  IG.AjoutHint := Ajout_Hint;
  IG.ModifHint := Modif_Hint;
  IG.SuppHint := Supp_Hint;
  IG.Mode := Mode;
  IG.Filtre := Filtre;
  IG.ProcAcheter := Acheter;
{$IFDEF RELEASE}
  IG.ProcImporter := False;
  IG.ProcExporter := False;
{$ELSE}
  IG.ProcImporter := Importer;
  IG.ProcExporter := Exporter;
{$ENDIF}
  IG.DerniereRecherche := '';
end;

function TfrmGestions.GestionCourante(SB: TSpeedButton = nil): PInfo_Gestion;

  function test(var ig: PInfo_Gestion; Bouton1, Bouton2: TSpeedButton; const Retour: RInfo_Gestion): Boolean;
  begin
    Result := False;
    if (Bouton1 = Bouton2) or Bouton1.Down then
    begin
      ig := @Retour;
      Result := True;
    end;
  end;

begin
  if test(Result, btAchatsAlbums, SB, GestionAchatAlbum) then
    Exit;
  if test(Result, btAlbums, SB, GestionAlbum) then
    Exit;
  if test(Result, btSeries, SB, GestionSerie) then
    Exit;
  if test(Result, btAuteurs, SB, GestionAuteur) then
    Exit;
  if test(Result, btUnivers, SB, GestionUnivers) then
    Exit;
  if test(Result, btEditeurs, SB, GestionEditeur) then
    Exit;
  if test(Result, btCollections, SB, GestionCollection) then
    Exit;
  if test(Result, btGenre, SB, GestionGenre) then
    Exit;
  if test(Result, btParaBD, SB, GestionParaBD) then
    Exit;
  if test(Result, btAchatsParaBD, SB, GestionAchatParaBD) then
    Exit;
  Result := @GestionAlbum;
end;

procedure TfrmGestions.FormCreate(Sender: TObject);
begin
  TGlobalVar.Mode_en_cours := mdEdit;

  FrameRechercheRapide1.VirtualTreeView := VirtualTreeView;
  FrameRechercheRapide1.ShowNewButton := False;

  AssignIG(GestionAlbum, AjouterAlbums, ModifierAlbums, SupprimerAlbums,
    HintListeAlbums, HintAjoutAlbum, HintModifAlbum, HintSuppAlbum,
    vmAlbumsSerie, '', nil, True);
  AssignIG(GestionAchatAlbum, AjouterAchatsAlbum, ModifierAchatsAlbum, SupprimerAchatsAlbum,
    HintListeAlbums, HintAjoutAlbum, HintModifAlbum, HintSuppAlbum,
    vmAlbumsSerie, 'Achat = 1', AcheterAlbums);
  AssignIG(GestionAuteur, AjouterAuteurs2, ModifierAuteurs, SupprimerAuteurs,
    HintListeAuteurs, HintAjoutAuteur, HintModifAuteur, HintSuppAuteur,
    vmPersonnes);
  AssignIG(GestionGenre, AjouterGenres, ModifierGenres, SupprimerGenres,
    HintListeGenres, HintAjoutGenre, HintModifGenre, HintSuppGenre,
    vmGenres);
  AssignIG(GestionUnivers, AjouterUnivers, ModifierUnivers, SupprimerUnivers,
    HintListeUnivers, HintAjoutUnivers, HintModifUnivers, HintSuppUnivers,
    vmUnivers);
  AssignIG(GestionSerie, AjouterSeries, ModifierSeries, SupprimerSeries,
    HintListeSeries, HintAjoutSerie, HintModifSerie, HintSuppSerie,
    vmSeries);
  AssignIG(GestionEditeur, AjouterEditeurs, ModifierEditeurs, SupprimerEditeurs,
    HintListeEditeurs, HintAjoutEditeur, HintModifEditeur, HintSuppEditeur,
    vmEditeurs);
  AssignIG(GestionCollection, AjouterCollections, ModifierCollections, SupprimerCollections,
    HintListeCollections, HintAjoutCollection, HintModifCollection, HintSuppCollection,
    vmCollections);
  AssignIG(GestionParaBD, AjouterParaBD, ModifierParaBD, SupprimerParaBD,
    HintListeParaBD, HintAjoutParaBD, HintModifParaBD, HintSuppParaBD,
    vmParaBDSerie);
  AssignIG(GestionAchatParaBD, AjouterAchatsParaBD, ModifierAchatsParaBD, SupprimerAchatsParaBD,
    HintListeParaBD, HintAjoutParaBD, HintModifParaBD, HintSuppParaBD,
    vmParaBDSerie, 'Achat = 1', AcheterParaBD);
  LastButton := nil;
  VirtualTreeView.ShowAchat := False;
  SpeedButton1Click(btAlbums);
end;

procedure TfrmGestions.ajouterClick(Sender: TObject);
begin
  Historique.AddWaiting(fcGestionAjout, nil, nil, @GestionCourante^.ProcAjouter, VirtualTreeView, FrameRechercheRapide1.edSearch.Text);
end;

procedure TfrmGestions.modifierClick(Sender: TObject);
begin
  Historique.AddWaiting(fcGestionModif, nil, nil, @GestionCourante^.ProcModifier, VirtualTreeView);
end;

procedure TfrmGestions.supprimerClick(Sender: TObject);
begin
  Historique.AddWaiting(fcGestionSupp, nil, nil, @GestionCourante^.ProcSupprimer, VirtualTreeView);
end;

procedure TfrmGestions.SpeedButton1Click(Sender: TObject);
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  if Sender = LastButton then
    Exit;
  LastButton := TSpeedButton(Sender);
  LastButton.Down := True;

  ajouter.Hint := GestionCourante^.AjoutHint;
  supprimer.Hint := GestionCourante^.SuppHint;
  modifier.Hint := GestionCourante^.ModifHint;
  VirtualTreeView.Mode := vmNone;
  VirtualTreeView.UseFiltre := GestionCourante^.Filtre <> '';
  VirtualTreeView.Filtre := GestionCourante^.Filtre;
  VirtualTreeView.Mode := GestionCourante^.Mode;
  VirtualTreeView.Header.Columns.Clear;
  btImporter.Enabled := GestionCourante^.ProcImporter;
  btExporter.Enabled := GestionCourante^.ProcExporter;
  Bevel4.Visible := btImporter.Enabled or btExporter.Enabled;
  btImporter.Visible := Bevel4.Visible;
  btExporter.Visible := Bevel4.Visible;
  btAcheter.Visible := Assigned(GestionCourante^.ProcAcheter);
  Bevel7.Visible := btAcheter.Visible;
  PrepareLV(Self);
  FrameRechercheRapide1.edSearch.Text := GestionCourante^.DerniereRecherche;
end;

procedure TfrmGestions.VDTButton2Click(Sender: TObject);
begin
  VirtualTreeView.InitializeRep;
end;

procedure TfrmGestions.ScanEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    VirtualTreeView.OnDblClick(VirtualTreeView);
  end;
end;

procedure TfrmGestions.btAcheterClick(Sender: TObject);
begin
  Historique.AddWaiting(fcGestionAchat, nil, nil, @GestionCourante^.ProcAcheter, VirtualTreeView);
end;

procedure TfrmGestions.btImporterClick(Sender: TObject);
var
  frm: TfrmWizardImport;
begin
  frm := TfrmWizardImport.Create(nil);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

procedure TfrmGestions.FrameRechercheRapide1edSearchChange(Sender: TObject);
begin
  FrameRechercheRapide1.edSearchChange(Sender);
  GestionCourante^.DerniereRecherche := FrameRechercheRapide1.edSearch.Text;

  // l'un ou l'autre... je sais pas trop
  // FrameRechercheRapide1.edSearch.SelectAll;
  FrameRechercheRapide1.edSearch.SelStart := Length(FrameRechercheRapide1.edSearch.Text);
end;

end.

