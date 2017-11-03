unit UFicheSerie;

interface

uses
  SysUtils, Classes, HTTPApp, WebModu, HTTPProd, WebAdapt, WebComp, LoadComplet, Procedures, dialogs;

type
  TFicheSerie = class(TWebPageModule)
    PageProducer: TPageProducer;
    Serie: TAdapter;
    RefSerie: TAdapterField;
    TitreSerie: TAdapterField;
    Terminee: TAdapterField;
    Albums: TPagedAdapter;
    RefAlbum: TAdapterField;
    TitreAlbum: TAdapterField;
    Tome: TAdapterField;
    HorsSerie: TAdapterBooleanField;
    Libelle: TAdapterField;
    Integrale: TAdapterBooleanField;
    Genres: TPagedAdapter;
    Genre: TAdapterField;
    HistoireSerie: TAdapterMemoField;
    NotesSerie: TAdapterMemoField;
    Editeur: TAdapter;
    RefEditeur: TAdapterField;
    NomEditeur: TAdapterField;
    EditeurSiteWeb: TAdapterField;
    Collection: TAdapter;
    RefCollection: TAdapterField;
    NomCollection: TAdapterField;
    TomeDebut: TAdapterField;
    TomeFin: TAdapterField;
    SerieSiteWeb: TAdapterField;
    Scenaristes: TPagedAdapter;
    ScenaristeRefPersonne: TAdapterField;
    ScenaristesNom: TAdapterField;
    Dessinateurs: TPagedAdapter;
    DessinateurRefPersonne: TAdapterField;
    DessinateurNom: TAdapterField;
    Coloristes: TPagedAdapter;
    ColoristeRefPersonne: TAdapterField;
    ColoristeNom: TAdapterField;
    procedure WebPageModuleBeforeDispatchPage(Sender: TObject; const PageName: string; var Handled: Boolean);
    procedure WebPageModuleAfterDispatchPage(Sender: TObject; const PageName: string);
    procedure RefSerieGetValue(Sender: TObject; var Value: Variant);
    procedure AcheteGetValue(Sender: TObject; var Value: Boolean);
    procedure AlbumsGetFirstRecord(Sender: TObject; var Eof: Boolean);
    procedure AlbumsGetNextRecord(Sender: TObject; var Eof: Boolean);
    procedure AlbumsGetRecordCount(Sender: TObject; var Count: Integer);
    procedure AlbumsGetRecordIndex(Sender: TObject; var Index: Integer);
    procedure RefAlbumGetValue(Sender: TObject; var Value: Variant);
    procedure TitreAlbumGetValue(Sender: TObject; var Value: Variant);
    procedure TitreAlbumGetDisplayText(Sender: TObject; var Value: string);
    procedure TomeGetDisplayText(Sender: TObject; var Value: string);
    procedure TomeGetValue(Sender: TObject; var Value: Variant);
    procedure HorsSerieGetValue(Sender: TObject; var Value: Boolean);
    procedure LibelleGetDisplayText(Sender: TObject; var Value: string);
    procedure WebPageModuleCreate(Sender: TObject);
    procedure IntegraleGetValue(Sender: TObject; var Value: Boolean);
    procedure TitreSerieGetValue(Sender: TObject; var Value: Variant);
    procedure TitreSerieGetDisplayText(Sender: TObject; var Value: string);
    procedure HistoireSerieGetValue(Sender: TObject; var Value: string);
    procedure NotesSerieGetValue(Sender: TObject; var Value: string);
    procedure GenresGetFirstRecord(Sender: TObject; var Eof: Boolean);
    procedure GenresGetNextRecord(Sender: TObject; var Eof: Boolean);
    procedure GenresGetRecordCount(Sender: TObject; var Count: Integer);
    procedure GenresGetRecordIndex(Sender: TObject; var Index: Integer);
    procedure GenreGetValue(Sender: TObject; var Value: Variant);
    procedure GenreGetDisplayText(Sender: TObject; var Value: string);
    procedure TermineeGetValue(Sender: TObject; var Value: Variant);
    procedure RefCollectionGetValue(Sender: TObject; var Value: Variant);
    procedure NomCollectionGetValue(Sender: TObject; var Value: Variant);
    procedure NomCollectionGetDisplayText(Sender: TObject; var Value: string);
    procedure RefEditeurGetValue(Sender: TObject; var Value: Variant);
    procedure NomEditeurGetValue(Sender: TObject; var Value: Variant);
    procedure NomEditeurGetDisplayText(Sender: TObject; var Value: string);
    procedure EditeurSiteWebGetValue(Sender: TObject; var Value: Variant);
    procedure EditeurSiteWebGetDisplayText(Sender: TObject; var Value: string);
    procedure TomeDebutGetValue(Sender: TObject; var Value: Variant);
    procedure TomeDebutGetDisplayText(Sender: TObject; var Value: string);
    procedure TomeFinGetValue(Sender: TObject; var Value: Variant);
    procedure TomeFinGetDisplayText(Sender: TObject; var Value: string);
    procedure SerieSiteWebGetValue(Sender: TObject; var Value: Variant);
    procedure SerieSiteWebGetDisplayText(Sender: TObject; var Value: string);
    procedure ScenaristeRefPersonneGetDisplayText(Sender: TObject; var Value: string);
    procedure ScenaristesNomGetDisplayText(Sender: TObject; var Value: string);
    procedure ScenaristesNomGetValue(Sender: TObject; var Value: Variant);
    procedure DessinateurRefPersonneGetDisplayText(Sender: TObject; var Value: string);
    procedure DessinateurNomGetDisplayText(Sender: TObject; var Value: string);
    procedure DessinateurNomGetValue(Sender: TObject; var Value: Variant);
    procedure ColoristeRefPersonneGetDisplayText(Sender: TObject; var Value: string);
    procedure ColoristeNomGetDisplayText(Sender: TObject; var Value: string);
    procedure ColoristeNomGetValue(Sender: TObject; var Value: Variant);
    procedure ScenaristesGetFirstRecord(Sender: TObject; var Eof: Boolean);
    procedure ScenaristesGetNextRecord(Sender: TObject; var Eof: Boolean);
    procedure ScenaristesGetRecordCount(Sender: TObject; var Count: Integer);
    procedure ScenaristesGetRecordIndex(Sender: TObject; var Index: Integer);
    procedure DessinateursGetRecordIndex(Sender: TObject; var Index: Integer);
    procedure DessinateursGetRecordCount(Sender: TObject; var Count: Integer);
    procedure DessinateursGetNextRecord(Sender: TObject; var Eof: Boolean);
    procedure DessinateursGetFirstRecord(Sender: TObject; var Eof: Boolean);
    procedure ColoristesGetRecordCount(Sender: TObject; var Count: Integer);
    procedure ColoristesGetRecordIndex(Sender: TObject; var Index: Integer);
    procedure ColoristesGetNextRecord(Sender: TObject; var Eof: Boolean);
    procedure ColoristesGetFirstRecord(Sender: TObject; var Eof: Boolean);
  private
    { déclarations privées }
    FSerie: TSerieComplete;
    FAlbumsPosition, FScenaristePosition, FDessinateurPosition, FColoristePosition, FGenrePosition: Integer;
  public
    { déclarations publiques }
  end;

function FicheSerie: TFicheSerie;

implementation

{$R *.dfm}

uses WebReq, WebCntxt, WebFact, Variants, CommonConst, TypeRec, Commun;

function FicheSerie: TFicheSerie;
begin
  Result := TFicheSerie(WebContext.FindModuleClass(TFicheSerie));
end;

procedure TFicheSerie.WebPageModuleCreate(Sender: TObject);
begin
  PageProducer.HTMLFile := WebServerPath + Name + '.html';
end;

procedure TFicheSerie.WebPageModuleBeforeDispatchPage(Sender: TObject; const PageName: string; var Handled: Boolean);
var
  Modele: string;
begin
  Modele := Request.QueryFields.Values['Modele'];
  if Modele <> '' then
    PageProducer.HTMLFile := WebServerPath + Modele + '.html'
  else
    PageProducer.HTMLFile := WebServerPath + PageName + '.html';
  FSerie := TSerieComplete.Create(StringToGUIDDef(Request.QueryFields.Values['RefSerie'], GUID_NULL));
  FAlbumsPosition := 0;
  FGenrePosition := 0;
  FScenaristePosition := 0;
  FDessinateurPosition := 0;
  FColoristePosition := 0;
end;

procedure TFicheSerie.WebPageModuleAfterDispatchPage(Sender: TObject; const PageName: string);
begin
  FreeAndNil(FSerie);
end;

procedure TFicheSerie.RefSerieGetValue(Sender: TObject; var Value: Variant);
begin
  Value := GUIDToString(FSerie.ID_Serie);
end;

procedure TFicheSerie.AcheteGetValue(Sender: TObject; var Value: Boolean);
begin
  Value := FSerie.Terminee = 1;
end;

procedure TFicheSerie.AlbumsGetFirstRecord(Sender: TObject; var Eof: Boolean);
begin
  FAlbumsPosition := 0;
  Eof := FAlbumsPosition >= FSerie.Albums.Count;
end;

procedure TFicheSerie.AlbumsGetNextRecord(Sender: TObject; var Eof: Boolean);
begin
  Eof := FAlbumsPosition >= FSerie.Albums.Count;
  if not Eof then Inc(FAlbumsPosition);
end;

procedure TFicheSerie.AlbumsGetRecordCount(Sender: TObject;
  var Count: Integer);
begin
  Count := FSerie.Albums.Count;
end;

procedure TFicheSerie.AlbumsGetRecordIndex(Sender: TObject; var Index: Integer);
begin
  Index := FAlbumsPosition;
end;

procedure TFicheSerie.RefAlbumGetValue(Sender: TObject; var Value: Variant);
begin
  Value := GUIDToString(TAlbum(FSerie.Albums[FAlbumsPosition]).ID);
end;

procedure TFicheSerie.TitreAlbumGetValue(Sender: TObject; var Value: Variant);
begin
  Value := TAlbum(FSerie.Albums[FAlbumsPosition]).Titre;
end;

procedure TFicheSerie.TitreAlbumGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FormatTitre(TitreAlbum.Value));
end;

procedure TFicheSerie.TomeGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := NonZero(IntToStr(Tome.Value));
end;

procedure TFicheSerie.TomeGetValue(Sender: TObject; var Value: Variant);
begin
  Value := TAlbum(FSerie.Albums[FAlbumsPosition]).Tome;
end;

procedure TFicheSerie.HorsSerieGetValue(Sender: TObject; var Value: Boolean);
begin
  Value := TAlbum(FSerie.Albums[FAlbumsPosition]).HorsSerie;
end;

procedure TFicheSerie.LibelleGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(TAlbum(FSerie.Albums[FAlbumsPosition]).ChaineAffichage);
end;

procedure TFicheSerie.IntegraleGetValue(Sender: TObject; var Value: Boolean);
begin
  Value := TAlbum(FSerie.Albums[FAlbumsPosition]).Integrale;
end;

procedure TFicheSerie.TitreSerieGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FSerie.Titre;
end;

procedure TFicheSerie.TitreSerieGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FormatTitre(TitreSerie.Value));
end;

procedure TFicheSerie.HistoireSerieGetValue(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FSerie.Sujet.Text);
end;

procedure TFicheSerie.NotesSerieGetValue(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FSerie.Notes.Text);
end;

procedure TFicheSerie.GenresGetFirstRecord(Sender: TObject; var Eof: Boolean);
begin
  FGenrePosition := 0;
  Eof := FGenrePosition >= FSerie.Genres.Count;
end;

procedure TFicheSerie.GenresGetNextRecord(Sender: TObject; var Eof: Boolean);
begin
  Eof := FGenrePosition >= FSerie.Genres.Count;
  if not Eof then Inc(FGenrePosition);
end;

procedure TFicheSerie.GenresGetRecordCount(Sender: TObject; var Count: Integer);
begin
  Count := FSerie.Genres.Count;
end;

procedure TFicheSerie.GenresGetRecordIndex(Sender: TObject; var Index: Integer);
begin
  Index := FGenrePosition;
end;

procedure TFicheSerie.GenreGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FSerie.Genres.ValueFromIndex[FGenrePosition];
end;

procedure TFicheSerie.GenreGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(Genre.Value);
end;

procedure TFicheSerie.TermineeGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FSerie.Terminee;
end;

procedure TFicheSerie.RefCollectionGetValue(Sender: TObject; var Value: Variant);
begin
  Value := GUIDToString(FSerie.Collection.ID);
end;

procedure TFicheSerie.NomCollectionGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FSerie.Collection.NomCollection;
end;

procedure TFicheSerie.NomCollectionGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FormatTitre(NomCollection.Value));
end;

procedure TFicheSerie.RefEditeurGetValue(Sender: TObject; var Value: Variant);
begin
  Value := GUIDToString(FSerie.Editeur.ID_Editeur);
end;

procedure TFicheSerie.NomEditeurGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FSerie.Editeur.NomEditeur;
end;

procedure TFicheSerie.NomEditeurGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FormatTitre(NomEditeur.Value));
end;

procedure TFicheSerie.EditeurSiteWebGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FSerie.Editeur.SiteWeb;
end;

procedure TFicheSerie.EditeurSiteWebGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(EditeurSiteWeb.Value);
end;

procedure TFicheSerie.TomeDebutGetValue(Sender: TObject; var Value: Variant);
begin
  Value := TAlbum(FSerie.Albums[FAlbumsPosition]).TomeDebut;
end;

procedure TFicheSerie.TomeDebutGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := NonZero(IntToStr(TomeDebut.Value));
end;

procedure TFicheSerie.TomeFinGetValue(Sender: TObject; var Value: Variant);
begin
  Value := TAlbum(FSerie.Albums[FAlbumsPosition]).TomeFin;
end;

procedure TFicheSerie.TomeFinGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := NonZero(IntToStr(TomeFin.Value));
end;

procedure TFicheSerie.SerieSiteWebGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FSerie.SiteWeb;
end;

procedure TFicheSerie.SerieSiteWebGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(SerieSiteWeb.Value);
end;

procedure TFicheSerie.ScenaristeRefPersonneGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := GUIDToString(TAuteur(FSerie.Scenaristes[FScenaristePosition]).Personne.ID);
end;

procedure TFicheSerie.ScenaristesNomGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FormatTitre(ScenaristesNom.Value));
end;

procedure TFicheSerie.ScenaristesNomGetValue(Sender: TObject; var Value: Variant);
begin
  Value := TAuteur(FSerie.Scenaristes[FScenaristePosition]).Personne.Nom;
end;

procedure TFicheSerie.DessinateurRefPersonneGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := GUIDToString(TAuteur(FSerie.Dessinateurs[FDessinateurPosition]).Personne.ID);
end;

procedure TFicheSerie.DessinateurNomGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FormatTitre(DessinateurNom.Value));
end;

procedure TFicheSerie.DessinateurNomGetValue(Sender: TObject; var Value: Variant);
begin
  Value := TAuteur(FSerie.Dessinateurs[FDessinateurPosition]).Personne.Nom;
end;

procedure TFicheSerie.ColoristeRefPersonneGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := GUIDToString(TAuteur(FSerie.Coloristes[FColoristePosition]).Personne.ID);
end;

procedure TFicheSerie.ColoristeNomGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FormatTitre(ColoristeNom.Value));
end;

procedure TFicheSerie.ColoristeNomGetValue(Sender: TObject; var Value: Variant);
begin
  Value := TAuteur(FSerie.Coloristes[FColoristePosition]).Personne.Nom;
end;

procedure TFicheSerie.ScenaristesGetFirstRecord(Sender: TObject; var Eof: Boolean);
begin
  FScenaristePosition := 0;
  Eof := FScenaristePosition >= FSerie.Scenaristes.Count;
end;

procedure TFicheSerie.ScenaristesGetNextRecord(Sender: TObject; var Eof: Boolean);
begin
  Eof := FScenaristePosition >= FSerie.Scenaristes.Count;
  if not Eof then Inc(FScenaristePosition);
end;

procedure TFicheSerie.ScenaristesGetRecordCount(Sender: TObject; var Count: Integer);
begin
  Count := FSerie.Scenaristes.Count;
end;

procedure TFicheSerie.ScenaristesGetRecordIndex(Sender: TObject; var Index: Integer);
begin
  Index := FScenaristePosition;
end;

procedure TFicheSerie.DessinateursGetRecordIndex(Sender: TObject; var Index: Integer);
begin
  Index := FDessinateurPosition;
end;

procedure TFicheSerie.DessinateursGetRecordCount(Sender: TObject; var Count: Integer);
begin
  Count := FSerie.Dessinateurs.Count;
end;

procedure TFicheSerie.DessinateursGetNextRecord(Sender: TObject; var Eof: Boolean);
begin
  Eof := FDessinateurPosition >= FSerie.Dessinateurs.Count;
  if not Eof then Inc(FDessinateurPosition);
end;

procedure TFicheSerie.DessinateursGetFirstRecord(Sender: TObject; var Eof: Boolean);
begin
  FDessinateurPosition := 0;
  Eof := FDessinateurPosition >= FSerie.Dessinateurs.Count;
end;

procedure TFicheSerie.ColoristesGetRecordCount(Sender: TObject; var Count: Integer);
begin
  Count := FSerie.Coloristes.Count;
end;

procedure TFicheSerie.ColoristesGetRecordIndex(Sender: TObject; var Index: Integer);
begin
  Index := FColoristePosition;
end;

procedure TFicheSerie.ColoristesGetNextRecord(Sender: TObject; var Eof: Boolean);
begin
  Eof := FColoristePosition >= FSerie.Coloristes.Count;
  if not Eof then Inc(FColoristePosition);
end;

procedure TFicheSerie.ColoristesGetFirstRecord(Sender: TObject; var Eof: Boolean);
begin
  FColoristePosition := 0;
  Eof := FColoristePosition >= FSerie.Coloristes.Count;
end;

initialization
  if WebRequestHandler <> nil then
    WebRequestHandler.AddWebModuleFactory(TWebPageModuleFactory.Create(TFicheSerie, TWebPageInfo.Create([wpPublished {, wpLoginRequired}], ''), crOnDemand, caDestroy));

end.

