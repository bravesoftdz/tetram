unit Form_Gestion;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, DBCtrls, ComCtrls, Db, Menus,
  ExtCtrls, Buttons, Proc_Gestions, VDTButton, VirtualTrees, VirtualTree;

type
  TInfo_Gestion = record
    Mode: TVirtualMode;
    ListeHint, AjoutHint, ModifHint, SuppHint: string;
    ProcAjouter: TActionGestionAdd;
    ProcModifier: TActionGestionModif;
    ProcSupprimer: TActionGestionSupp;
    Filtre: string;
    BoutonSupp: TVDTButton;
  end;

  TFrmGestions = class(TForm)
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
    btEmprunteurs: TVDTButton;
    Bevel1: TBevel;
    Bevel3: TBevel;
    VirtualTreeView: TVirtualStringTree;
    ScanEdit: TEdit;
    VDTButton1: TVDTButton;
    Bevel2: TBevel;
    Bevel5: TBevel;
    btAchats: TVDTButton;
    Bevel6: TBevel;
    Bevel7: TBevel;
    VDTButton3: TVDTButton;
    procedure FormCreate(Sender: TObject);
    function GestionCourante(SB: TSpeedButton = nil): TInfo_Gestion;
    procedure ajouterClick(Sender: TObject);
    procedure modifierClick(Sender: TObject);
    procedure supprimerClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure VDTButton2Click(Sender: TObject);
    procedure VDTButton1Click(Sender: TObject);
    procedure ScanEditKeyPress(Sender: TObject; var Key: Char);
    procedure VDTButton3Click(Sender: TObject);
  protected
  private
    { Déclarations privées }
    GestionAchat, GestionAlbum, GestionAuteur, GestionGenre, GestionCollection,
      GestionEmprunteur, GestionEditeur, GestionSerie: TInfo_Gestion;
    LastButton: TSpeedButton;
    procedure AssignIG(var IG: TInfo_Gestion; Ajouter: TActionGestionAdd; Modifier: TActionGestionModif; Supprimer: TActionGestionSupp; const Liste_Hint, Ajout_Hint, Modif_Hint, Supp_Hint: string; Mode: TVirtualMode; Filtre: string = ''; BoutonSupp: TVDTButton = nil);
  public
    { Déclarations publiques }
    SelString: string;
  end;

var
  FrmGestions: TFrmGestions;

implementation

uses Commun, CommonConst, Procedures;

const
  HintListeAlbums = 'Liste des albums';
  HintAjoutAlbum = 'Ajouter un album';
  HintModifAlbum = 'Modifier l''album sélectionné';
  HintSuppAlbum = 'Supprimer l''album sélectionné';
  HintListeAuteurs = 'Liste des auteurs';
  HintAjoutAuteur = 'Ajouter un auteur';
  HintModifAuteur = 'Modifier l''auteur sélectionné';
  HintSuppAuteur = 'Supprimer l''auteur sélectionné';
  HintListeEmprunteurs = 'Liste des emprunteurs';
  HintAjoutEmprunteur = 'Ajouter un emprunteur';
  HintModifEmprunteur = 'Modifier l''emprunteur sélectionné';
  HintSuppEmprunteur = 'Supprimer l''emprunteur sélectionné';
  HintListeSeries = 'Liste des séries';
  HintAjoutSerie = 'Ajouter une série';
  HintModifSerie = 'Modifier la série sélectionnée';
  HintSuppSerie = 'Supprimer la série sélectionnée';
  HintListeGenres = 'Liste des genres';
  HintAjoutGenre = 'Ajouter un genre';
  HintModifGenre = 'Modifier le genre sélectionné';
  HintSuppGenre = 'Supprimer le genre sélectionné';
  HintListeEditeurs = 'Liste des éditeurs';
  HintAjoutEditeur = 'Ajouter un éditeur';
  HintModifEditeur = 'Modifier l''éditeur sélectionné';
  HintSuppEditeur = 'Supprimer l''éditeur sélectionné';
  HintListeCollections = 'Liste des collections';
  HintAjoutCollection = 'Ajouter une collection';
  HintModifCollection = 'Modifier la collection sélectionnée';
  HintSuppCollection = 'Supprimer la collection sélectionnée';

  NoSuppression = 'Impossible de supprimer un élément pendant l''édition d''un autre';

const
  First: Boolean = True;

{$R *.DFM}

procedure TFrmGestions.AssignIG(var IG: TInfo_Gestion; Ajouter: TActionGestionAdd; Modifier: TActionGestionModif; Supprimer: TActionGestionSupp; const Liste_Hint, Ajout_Hint, Modif_Hint, Supp_Hint: string; Mode: TVirtualMode; Filtre: string; BoutonSupp: TVDTButton);
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
  IG.BoutonSupp := BoutonSupp;
end;

function TFrmGestions.GestionCourante(SB: TSpeedButton = nil): TInfo_Gestion;

  function test(var ig: TInfo_Gestion; Bouton1, Bouton2: TSpeedButton; Retour: TInfo_Gestion): Boolean;
  begin
    Result := False;
    if (Bouton1 = Bouton2) or Bouton1.Down then begin
      ig := Retour;
      Result := True;
    end;
  end;

begin
  if test(Result, btAchats, SB, GestionAchat) then Exit;
  if test(Result, btAlbums, SB, GestionAlbum) then Exit;
  if test(Result, btSeries, SB, GestionSerie) then Exit;
  if test(Result, btAuteurs, SB, GestionAuteur) then Exit;
  if test(Result, btEmprunteurs, SB, GestionEmprunteur) then Exit;
  if test(Result, btEditeurs, SB, GestionEditeur) then Exit;
  if test(Result, btCollections, SB, GestionCollection) then Exit;
  if test(Result, btGenre, SB, GestionGenre) then Exit;
  Result := GestionAlbum;
end;

procedure TFrmGestions.FormCreate(Sender: TObject);
begin
  Mode_en_cours := mdEdit;

  AssignIG(GestionAlbum, AjouterAlbums, ModifierAlbums, SupprimerAlbums,
    HintListeAlbums, HintAjoutAlbum, HintModifAlbum, HintSuppAlbum,
    vmAlbumsSerie);
  AssignIG(GestionAchat, AjouterAchats, ModifierAchats, SupprimerAchats,
    HintListeAlbums, HintAjoutAlbum, HintModifAlbum, HintSuppAlbum,
    vmAlbumsSerie, 'Achat = 1', VDTButton3);
  AssignIG(GestionAuteur, AjouterAuteurs2, ModifierAuteurs, SupprimerAuteurs,
    HintListeAuteurs, HintAjoutAuteur, HintModifAuteur, HintSuppAuteur,
    vmPersonnes);
  AssignIG(GestionGenre, AjouterGenres, ModifierGenres, SupprimerGenres,
    HintListeGenres, HintAjoutGenre, HintModifGenre, HintSuppGenre,
    vmGenres);
  AssignIG(GestionEmprunteur, AjouterEmprunteurs, ModifierEmprunteurs, SupprimerEmprunteurs,
    HintListeEmprunteurs, HintAjoutEmprunteur, HintModifEmprunteur, HintSuppEmprunteur,
    vmEmprunteurs);
  AssignIG(GestionSerie, AjouterSeries, ModifierSeries, SupprimerSeries,
    HintListeSeries, HintAjoutSerie, HintModifSerie, HintSuppSerie,
    vmSeries);
  AssignIG(GestionEditeur, AjouterEditeurs, ModifierEditeurs, SupprimerEditeurs,
    HintListeEditeurs, HintAjoutEditeur, HintModifEditeur, HintSuppEditeur,
    vmEditeurs);
  AssignIG(GestionCollection, AjouterCollections, ModifierCollections, SupprimerCollections,
    HintListeCollections, HintAjoutCollection, HintModifCollection, HintSuppCollection,
    vmCollections);
  LastButton := nil;
  VirtualTreeView.ShowAchat := False;
  SpeedButton1Click(btAlbums);
end;

procedure TFrmGestions.ajouterClick(Sender: TObject);
begin
  with GestionCourante do
    ProcAjouter(VirtualTreeView, ScanEdit.Text);
end;

procedure TFrmGestions.modifierClick(Sender: TObject);
begin
  with GestionCourante do
    ProcModifier(VirtualTreeView);
end;

procedure TFrmGestions.supprimerClick(Sender: TObject);
begin
  with GestionCourante do
    ProcSupprimer(VirtualTreeView);
end;

procedure TFrmGestions.SpeedButton1Click(Sender: TObject);
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  if Sender = LastButton then Exit;
  with GestionCourante(LastButton) do
    if Assigned(BoutonSupp) then BoutonSupp.Visible := False;
  LastButton := TSpeedButton(Sender);
  LastButton.Down := True;
  with GestionCourante do begin
    ajouter.Hint := AjoutHint;
    supprimer.Hint := SuppHint;
    modifier.Hint := ModifHint;
    VirtualTreeView.Mode := vmNone;
    VirtualTreeView.UseFiltre := Filtre <> '';
    VirtualTreeView.Filtre := Filtre;
    VirtualTreeView.Mode := Mode;
    VirtualTreeView.Header.Columns.Clear;
    if Assigned(BoutonSupp) then begin
      BoutonSupp.Visible := True;
      BoutonSupp.Left := Bevel7.Left + Bevel7.Width;
      BoutonSupp.Top := Bevel7.Top;
    end;
    Bevel7.Visible := Assigned(BoutonSupp);
  end;
  PrepareLV(Self);
end;

procedure TFrmGestions.VDTButton2Click(Sender: TObject);
begin
  VirtualTreeView.InitializeRep;
end;

procedure TFrmGestions.VDTButton1Click(Sender: TObject);
begin
  VirtualTreeView.Find(ScanEdit.Text, Sender = VDTButton1);
end;

procedure TFrmGestions.ScanEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    Key := #0;
    VirtualTreeView.OnDblClick(VirtualTreeView);
  end;
end;

procedure TFrmGestions.VDTButton3Click(Sender: TObject);
begin
  AcheterAlbums(VirtualTreeView);
end;

end.

