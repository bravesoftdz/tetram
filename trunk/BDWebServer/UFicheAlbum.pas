unit UFicheAlbum;

interface

uses
  SysUtils, Windows, Classes, HTTPApp, WebModu, HTTPProd, LoadComplet, dialogs,
  WebComp, Procedures, WebAdapt;

type
  TFicheAlbum = class(TWebPageModule)
    PageProducer: TPageProducer;
    Album: TAdapter;
    HorsSerie: TAdapterBooleanField;
    AnneeParution: TAdapterField;
    RefAlbum: TAdapterField;
    TitreAlbum: TAdapterField;
    HistoireAlbum: TAdapterMemoField;
    NotesAlbum: TAdapterMemoField;
    Scenaristes: TPagedAdapter;
    ScenaristeRefPersonne: TAdapterField;
    ScenaristesNom: TAdapterField;
    Dessinateurs: TPagedAdapter;
    DessinateurRefPersonne: TAdapterField;
    DessinateurNom: TAdapterField;
    Genres: TPagedAdapter;
    Genre: TAdapterField;
    Coloristes: TPagedAdapter;
    Serie: TAdapter;
    RefSerie: TAdapterField;
    TitreSerie: TAdapterField;
    Editions: TPagedAdapter;
    RefEdition: TAdapterField;
    Tome: TAdapterField;
    Integrale: TAdapterBooleanField;
    ColoristeRefPersonne: TAdapterField;
    ColoristeNom: TAdapterField;
    RefEditeur: TAdapterField;
    NomEditeur: TAdapterField;
    RefCollection: TAdapterField;
    NomCollection: TAdapterField;
    VO: TAdapterBooleanField;
    Dedicace: TAdapterBooleanField;
    Couleur: TAdapterBooleanField;
    AnneeEdition: TAdapterField;
    Etat: TAdapterField;
    Reliure: TAdapterField;
    Prix: TAdapterField;
    Stock: TAdapterBooleanField;
    Prete: TAdapterBooleanField;
    ISBN: TAdapterField;
    Terminee: TAdapterField;
    HistoireSerie: TAdapterMemoField;
    NotesSerie: TAdapterMemoField;
    Couvertures: TPagedAdapter;
    Edition: TAdapterField;
    RefCouverture: TAdapterField;
    Couverture: TAdapterImageField;
    TomeDebut: TAdapterField;
    TomeFin: TAdapterField;
    EditionNotes: TAdapterMemoField;
    EditeurSiteWeb: TAdapterField;
    DateAchat: TAdapterField;
    Gratuit: TAdapterBooleanField;
    Offert: TAdapterBooleanField;
    NombreDePages: TAdapterField;
    Orientation: TAdapterField;
    FormatEdition: TAdapterField;
    procedure WebPageModuleBeforeDispatchPage(Sender: TObject; const PageName: string; var Handled: Boolean);
    procedure WebPageModuleAfterDispatchPage(Sender: TObject; const PageName: string);
    procedure AfficheGetHREF(Sender: TObject; var HREF: string);
    procedure ActeursGetValueCount(Sender: TObject; var Count: Integer);
    procedure ActeursGetValues(Sender: TObject; Index: Integer; var Value: Variant);
    procedure HorsSerieGetValue(Sender: TObject; var Value: Boolean);
    procedure AnneeParutionGetValue(Sender: TObject; var Value: Variant);
    procedure RefALbumGetValue(Sender: TObject; var Value: Variant);
    procedure TitreAlbumGetValue(Sender: TObject; var Value: Variant);
    procedure HistoireAlbumGetValue(Sender: TObject; var Value: string);
    procedure NotesAlbumGetValue(Sender: TObject; var Value: string);
    procedure ScenaristesGetRecordCount(Sender: TObject; var Count: Integer);
    procedure ScenaristesGetRecordIndex(Sender: TObject; var Index: Integer);
    procedure ScenaristesGetNextRecord(Sender: TObject; var Eof: Boolean);
    procedure ScenaristesGetFirstRecord(Sender: TObject; var Eof: Boolean);
    procedure ScenaristeRefPersonneGetValue(Sender: TObject; var Value: Variant);
    procedure ScenaristesNomGetValue(Sender: TObject; var Value: Variant);
    procedure DessinateurRefPersonneGetValue(Sender: TObject; var Value: Variant);
    procedure DessinateurNomGetValue(Sender: TObject; var Value: Variant);
    procedure DessinateursGetFirstRecord(Sender: TObject; var Eof: Boolean);
    procedure DessinateursGetNextRecord(Sender: TObject; var Eof: Boolean);
    procedure DessinateursGetRecordCount(Sender: TObject; var Count: Integer);
    procedure DessinateursGetRecordIndex(Sender: TObject; var Index: Integer);
    procedure GenreGetValue(Sender: TObject; var Value: Variant);
    procedure GenresGetFirstRecord(Sender: TObject; var Eof: Boolean);
    procedure GenresGetNextRecord(Sender: TObject; var Eof: Boolean);
    procedure GenresGetRecordCount(Sender: TObject; var Count: Integer);
    procedure GenresGetRecordIndex(Sender: TObject; var Index: Integer);
    procedure ColoristesGetFirstRecord(Sender: TObject; var Eof: Boolean);
    procedure ColoristesGetNextRecord(Sender: TObject; var Eof: Boolean);
    procedure ColoristesGetRecordCount(Sender: TObject; var Count: Integer);
    procedure ColoristesGetRecordIndex(Sender: TObject; var Index: Integer);
    procedure TitreAlbumGetDisplayText(Sender: TObject; var Value: string);
    procedure AnneeParutionGetDisplayText(Sender: TObject; var Value: string);
    procedure TitreSerieGetDisplayText(Sender: TObject; var Value: string);
    procedure TitreSerieGetValue(Sender: TObject; var Value: Variant);
    procedure RefSerieGetValue(Sender: TObject; var Value: Variant);
    procedure WebPageModuleCreate(Sender: TObject);
    procedure TomeGetValue(Sender: TObject; var Value: Variant);
    procedure TomeGetDisplayText(Sender: TObject; var Value: string);
    procedure IntegraleGetValue(Sender: TObject; var Value: Boolean);
    procedure PrixGetDisplayText(Sender: TObject; var Value: string);
    procedure TermineeGetValue(Sender: TObject; var Value: Variant);
    procedure EditionsGetFirstRecord(Sender: TObject; var Eof: Boolean);
    procedure EditionsGetNextRecord(Sender: TObject; var Eof: Boolean);
    procedure EditionsGetRecordCount(Sender: TObject; var Count: Integer);
    procedure EditionsGetRecordIndex(Sender: TObject; var Index: Integer);
    procedure RefEditionGetValue(Sender: TObject; var Value: Variant);
    procedure RefEditeurGetValue(Sender: TObject; var Value: Variant);
    procedure NomEditeurGetValue(Sender: TObject; var Value: Variant);
    procedure RefCollectionGetValue(Sender: TObject; var Value: Variant);
    procedure NomCollectionGetValue(Sender: TObject; var Value: Variant);
    procedure AnneeEditionGetValue(Sender: TObject; var Value: Variant);
    procedure AnneeEditionGetDisplayText(Sender: TObject; var Value: string);
    procedure EtatGetValue(Sender: TObject; var Value: Variant);
    procedure EtatGetDisplayText(Sender: TObject; var Value: string);
    procedure ReliureGetValue(Sender: TObject; var Value: Variant);
    procedure ReliureGetDisplayText(Sender: TObject; var Value: string);
    procedure PrixGetValue(Sender: TObject; var Value: Variant);
    procedure CouleurGetValue(Sender: TObject; var Value: Boolean);
    procedure VOGetValue(Sender: TObject; var Value: Boolean);
    procedure DedicaceGetValue(Sender: TObject; var Value: Boolean);
    procedure StockGetValue(Sender: TObject; var Value: Boolean);
    procedure PreteGetValue(Sender: TObject; var Value: Boolean);
    procedure ISBNGetValue(Sender: TObject; var Value: Variant);
    procedure ColoristeRefPersonneGetValue(Sender: TObject; var Value: Variant);
    procedure ColoristeNomGetValue(Sender: TObject; var Value: Variant);
    procedure ColoristeNomGetDisplayText(Sender: TObject; var Value: string);
    procedure DessinateurNomGetDisplayText(Sender: TObject; var Value: string);
    procedure ScenaristesNomGetDisplayText(Sender: TObject; var Value: string);
    procedure HistoireSerieGetValue(Sender: TObject; var Value: string);
    procedure NotesSerieGetValue(Sender: TObject; var Value: string);
    procedure GenreGetDisplayText(Sender: TObject; var Value: string);
    procedure EditionGetValue(Sender: TObject; var Value: Variant);
    procedure EditionGetDisplayText(Sender: TObject; var Value: string);
    procedure CouverturesGetFirstRecord(Sender: TObject; var Eof: Boolean);
    procedure CouverturesGetNextRecord(Sender: TObject; var Eof: Boolean);
    procedure CouverturesGetRecordCount(Sender: TObject; var Count: Integer);
    procedure CouverturesGetRecordIndex(Sender: TObject; var Index: Integer);
    procedure CouvertureGetHREF(Sender: TObject; var HREF: string);
    procedure RefCouvertureGetValue(Sender: TObject; var Value: Variant);
    procedure CouvertureGetImageName(Sender: TObject; var Value: string);
    procedure TomeDebutGetValue(Sender: TObject; var Value: Variant);
    procedure TomeDebutGetDisplayText(Sender: TObject; var Value: string);
    procedure TomeFinGetValue(Sender: TObject; var Value: Variant);
    procedure TomeFinGetDisplayText(Sender: TObject; var Value: string);
    procedure EditionNotesGetValue(Sender: TObject; var Value: string);
    procedure EditeurSiteWebGetValue(Sender: TObject; var Value: Variant);
    procedure EditeurSiteWebGetDisplayText(Sender: TObject; var Value: string);
    procedure DateAchatGetValue(Sender: TObject; var Value: Variant);
    procedure DateAchatGetDisplayText(Sender: TObject; var Value: string);
    procedure NomEditeurGetDisplayText(Sender: TObject; var Value: string);
    procedure OffertGetValue(Sender: TObject; var Value: Boolean);
    procedure GratuitGetValue(Sender: TObject; var Value: Boolean);
    procedure NombreDePagesGetDisplayText(Sender: TObject; var Value: string);
    procedure NombreDePagesGetValue(Sender: TObject; var Value: Variant);
    procedure OrientationGetDisplayText(Sender: TObject; var Value: string);
    procedure OrientationGetValue(Sender: TObject; var Value: Variant);
    procedure FormatEditionGetDisplayText(Sender: TObject; var Value: string);
    procedure FormatEditionGetValue(Sender: TObject; var Value: Variant);
  private
    { déclarations privées }
    FAlbum: TAlbumComplet;
    FEditions: array of TEditionComplete;
    FScenaristePosition, FDessinateurPosition, FColoristePosition, FEditionPosition, FGenrePosition, FCouverturePosition: Integer;
  public
    { déclarations publiques }
  end;

function FicheAlbum: TFicheAlbum;

implementation

{$R *.dfm}

uses WebReq, WebCntxt, WebFact, Variants, TypeRec, Commun, Divers,
  CommonConst;

function FicheAlbum: TFicheAlbum;
begin
  Result := TFicheAlbum(WebContext.FindModuleClass(TFicheAlbum));
end;

procedure TFicheAlbum.WebPageModuleCreate(Sender: TObject);
begin
  PageProducer.HTMLFile := WebServerPath + Name + '.html';
end;

procedure TFicheAlbum.WebPageModuleBeforeDispatchPage(Sender: TObject; const PageName: string; var Handled: Boolean);
var
  Modele: string;
  i: Integer;
begin
  Modele := Request.QueryFields.Values['Modele'];
  if Modele <> '' then
    PageProducer.HTMLFile := WebServerPath + Modele + '.html'
  else
    PageProducer.HTMLFile := WebServerPath + PageName + '.html';
  FAlbum := TAlbumComplet.Create(StringToGUIDDef(Request.QueryFields.Values['RefAlbum'], GUID_NULL));
  SetLength(FEditions, FAlbum.Editions.Editions.Count);
  for i := 0 to Pred(Length(FEditions)) do
    FEditions[i] := TEditionComplete.Create(TEdition(FAlbum.Editions.Editions[i]).ID);
  FScenaristePosition := 0;
  FDessinateurPosition := 0;
  FColoristePosition := 0;
  FEditionPosition := 0;
  FGenrePosition := 0;
end;

procedure TFicheAlbum.WebPageModuleAfterDispatchPage(Sender: TObject; const PageName: string);
var
  i: Integer;
begin
  FreeAndNil(FAlbum);
  for i := 0 to Pred(Length(FEditions)) do
    FreeAndNil(FEditions[i]);
end;

procedure TFicheAlbum.AfficheGetHREF(Sender: TObject; var HREF: string);
begin
  if FEditions[FEditionPosition].Couvertures.Count > 0 then
    HREF := Format('/affiche?RefAlbum=%s&RefAffiche=%s', [GUIDToString(FAlbum.ID_Album), GUIDToString(TCouverture(FEditions[FEditionPosition].Couvertures[0]).ID)])
  else
    HREF := '/';
end;

procedure TFicheAlbum.ActeursGetValueCount(Sender: TObject; var Count: Integer);
begin
  Count := FAlbum.Scenaristes.Count;
end;

procedure TFicheAlbum.ActeursGetValues(Sender: TObject; Index: Integer; var Value: Variant);
begin
  if Index < FAlbum.Scenaristes.Count then
    Value := HTMLPrepare(TAuteur(FAlbum.Scenaristes[Index]).ChaineAffichage);
end;

procedure TFicheAlbum.HorsSerieGetValue(Sender: TObject; var Value: Boolean);
begin
  Value := FAlbum.HorsSerie;
end;

procedure TFicheAlbum.AnneeParutionGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FAlbum.AnneeParution;
end;

procedure TFicheAlbum.AnneeParutionGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := NonZero(IntToStr(FAlbum.AnneeParution));
end;

procedure TFicheAlbum.RefALbumGetValue(Sender: TObject; var Value: Variant);
begin
  Value := GUIDToString(FAlbum.ID_Album);
end;

procedure TFicheAlbum.TitreAlbumGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FormatTitre(FAlbum.Titre));
end;

procedure TFicheAlbum.TitreAlbumGetValue(Sender: TObject; var Value: Variant);
begin
  Value := HTMLPrepare(FAlbum.Titre);
end;

procedure TFicheAlbum.HistoireAlbumGetValue(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FAlbum.Sujet.Text);
end;

procedure TFicheAlbum.NotesAlbumGetValue(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FAlbum.Notes.GetText);
end;

procedure TFicheAlbum.ScenaristesGetRecordCount(Sender: TObject; var Count: Integer);
begin
  Count := FAlbum.Scenaristes.Count;
end;

procedure TFicheAlbum.ScenaristesGetRecordIndex(Sender: TObject; var Index: Integer);
begin
  Index := FScenaristePosition;
end;

procedure TFicheAlbum.ScenaristesGetNextRecord(Sender: TObject; var Eof: Boolean);
begin
  Eof := FScenaristePosition >= FAlbum.Scenaristes.Count;
  if not Eof then Inc(FScenaristePosition);
end;

procedure TFicheAlbum.ScenaristesGetFirstRecord(Sender: TObject; var Eof: Boolean);
begin
  FScenaristePosition := 0;
  Eof := FScenaristePosition >= FAlbum.Scenaristes.Count;
end;

procedure TFicheAlbum.ScenaristeRefPersonneGetValue(Sender: TObject; var Value: Variant);
begin
  Value := GUIDToString(TAuteur(FAlbum.Scenaristes[FScenaristePosition]).Personne.ID);
end;

procedure TFicheAlbum.ScenaristesNomGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FormatTitre(ScenaristesNom.Value));
end;

procedure TFicheAlbum.ScenaristesNomGetValue(Sender: TObject; var Value: Variant);
begin
  Value := TAuteur(FAlbum.Scenaristes[FScenaristePosition]).Personne.Nom;
end;

procedure TFicheAlbum.DessinateurRefPersonneGetValue(Sender: TObject; var Value: Variant);
begin
  Value := GUIDToString(TAuteur(FAlbum.Dessinateurs[FDessinateurPosition]).Personne.ID);
end;

procedure TFicheAlbum.DessinateurNomGetValue(Sender: TObject; var Value: Variant);
begin
  Value := TAuteur(FAlbum.Dessinateurs[FDessinateurPosition]).Personne.Nom
end;

procedure TFicheAlbum.DessinateurNomGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FormatTitre(DessinateurNom.Value));
end;

procedure TFicheAlbum.DessinateursGetFirstRecord(Sender: TObject; var Eof: Boolean);
begin
  FDessinateurPosition := 0;
  Eof := FDessinateurPosition >= FAlbum.Dessinateurs.Count;
end;

procedure TFicheAlbum.DessinateursGetNextRecord(Sender: TObject; var Eof: Boolean);
begin
  Eof := FDessinateurPosition >= FAlbum.Dessinateurs.Count;
  if not Eof then Inc(FDessinateurPosition);
end;

procedure TFicheAlbum.DessinateursGetRecordCount(Sender: TObject; var Count: Integer);
begin
  Count := FAlbum.Dessinateurs.Count;
end;

procedure TFicheAlbum.DessinateursGetRecordIndex(Sender: TObject; var Index: Integer);
begin
  Index := FDessinateurPosition;
end;

procedure TFicheAlbum.GenreGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(Genre.Value);
end;

procedure TFicheAlbum.GenreGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FAlbum.Serie.Genres.ValueFromIndex[FGenrePosition];
end;

procedure TFicheAlbum.GenresGetFirstRecord(Sender: TObject; var Eof: Boolean);
begin
  FGenrePosition := 0;
  Eof := FGenrePosition >= FAlbum.Serie.Genres.Count;
end;

procedure TFicheAlbum.GenresGetNextRecord(Sender: TObject; var Eof: Boolean);
begin
  Eof := FGenrePosition >= FAlbum.Serie.Genres.Count;
  if not Eof then Inc(FGenrePosition);
end;

procedure TFicheAlbum.GenresGetRecordCount(Sender: TObject; var Count: Integer);
begin
  Count := FAlbum.Serie.Genres.Count;
end;

procedure TFicheAlbum.GenresGetRecordIndex(Sender: TObject; var Index: Integer);
begin
  Index := FGenrePosition;
end;

procedure TFicheAlbum.ColoristesGetFirstRecord(Sender: TObject; var Eof: Boolean);
begin
  FColoristePosition := 0;
  Eof := FColoristePosition >= FAlbum.Coloristes.Count;
end;

procedure TFicheAlbum.ColoristesGetNextRecord(Sender: TObject; var Eof: Boolean);
begin
  Eof := FColoristePosition >= FAlbum.Coloristes.Count;
  if not Eof then Inc(FColoristePosition);
end;

procedure TFicheAlbum.ColoristesGetRecordCount(Sender: TObject; var Count: Integer);
begin
  Count := FAlbum.Coloristes.Count;
end;

procedure TFicheAlbum.ColoristesGetRecordIndex(Sender: TObject; var Index: Integer);
begin
  Index := FColoristePosition;
end;

procedure TFicheAlbum.TitreSerieGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FormatTitre(TitreSerie.Value));
end;

procedure TFicheAlbum.TitreSerieGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FAlbum.Serie.Titre;
end;

procedure TFicheAlbum.RefSerieGetValue(Sender: TObject; var Value: Variant);
begin
  Value := GUIDToString(FAlbum.Serie.ID_Serie);
end;

procedure TFicheAlbum.TomeGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FAlbum.Tome;
end;

procedure TFicheAlbum.TomeGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := NonZero(IntToStr(FAlbum.Tome));
end;

procedure TFicheAlbum.IntegraleGetValue(Sender: TObject; var Value: Boolean);
begin
  Value := FAlbum.Integrale;
end;

procedure TFicheAlbum.PrixGetDisplayText(Sender: TObject; var Value: string);
begin
  if FEditions[FEditionPosition].Prix = 0 then
    Value := ''
  else
    Value := HTMLPrepare(FormatCurr(FormatMonnaie, FEditions[FEditionPosition].Prix));
end;

procedure TFicheAlbum.TermineeGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FAlbum.Serie.Terminee;
end;

procedure TFicheAlbum.EditionsGetFirstRecord(Sender: TObject; var Eof: Boolean);
begin
  FEditionPosition := 0;
  FCouverturePosition := 0;
  Eof := FEditionPosition >= Length(FEditions);
end;

procedure TFicheAlbum.EditionsGetNextRecord(Sender: TObject; var Eof: Boolean);
begin
  Eof := FEditionPosition >= Length(FEditions);
  if not Eof then begin
    Inc(FEditionPosition);
    FCouverturePosition := 0;
  end;
end;

procedure TFicheAlbum.EditionsGetRecordCount(Sender: TObject; var Count: Integer);
begin
  Count := Length(FEditions);
end;

procedure TFicheAlbum.EditionsGetRecordIndex(Sender: TObject; var Index: Integer);
begin
  Index := FEditionPosition;
end;

procedure TFicheAlbum.RefEditionGetValue(Sender: TObject; var Value: Variant);
begin
  Value := GUIDToString(FEditions[FEditionPosition].ID_Edition);
end;

procedure TFicheAlbum.RefEditeurGetValue(Sender: TObject; var Value: Variant);
begin
  Value := GUIDToString(FEditions[FEditionPosition].Editeur.ID_Editeur);
end;

procedure TFicheAlbum.NomEditeurGetValue(Sender: TObject; var Value: Variant);
begin
  Value := HTMLPrepare(FEditions[FEditionPosition].Editeur.NomEditeur);
end;

procedure TFicheAlbum.RefCollectionGetValue(Sender: TObject; var Value: Variant);
begin
  Value := GUIDToString(FEditions[FEditionPosition].Collection.ID);
end;

procedure TFicheAlbum.NomCollectionGetValue(Sender: TObject; var Value: Variant);
begin
  Value := HTMLPrepare(FEditions[FEditionPosition].Collection.NomCollection);
end;

procedure TFicheAlbum.AnneeEditionGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FEditions[FEditionPosition].AnneeEdition;
end;

procedure TFicheAlbum.AnneeEditionGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := NonZero(IntToStr(FEditions[FEditionPosition].AnneeEdition));
end;

procedure TFicheAlbum.EtatGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FEditions[FEditionPosition].Etat;
end;

procedure TFicheAlbum.EtatGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := FEditions[FEditionPosition].sEtat;
end;

procedure TFicheAlbum.ReliureGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FEditions[FEditionPosition].Reliure;
end;

procedure TFicheAlbum.ReliureGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := FEditions[FEditionPosition].sReliure;
end;

procedure TFicheAlbum.PrixGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FEditions[FEditionPosition].Prix;
end;

procedure TFicheAlbum.CouleurGetValue(Sender: TObject; var Value: Boolean);
begin
  Value := FEditions[FEditionPosition].Couleur;
end;

procedure TFicheAlbum.VOGetValue(Sender: TObject; var Value: Boolean);
begin
  Value := FEditions[FEditionPosition].VO;
end;

procedure TFicheAlbum.DedicaceGetValue(Sender: TObject; var Value: Boolean);
begin
  Value := FEditions[FEditionPosition].Dedicace;
end;

procedure TFicheAlbum.StockGetValue(Sender: TObject; var Value: Boolean);
begin
  Value := FEditions[FEditionPosition].Stock;
end;

procedure TFicheAlbum.PreteGetValue(Sender: TObject; var Value: Boolean);
begin
  Value := FEditions[FEditionPosition].Prete;
end;

procedure TFicheAlbum.ISBNGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FEditions[FEditionPosition].ISBN;
end;

procedure TFicheAlbum.ColoristeRefPersonneGetValue(Sender: TObject; var Value: Variant);
begin
  Value := GUIDToString(TAuteur(FAlbum.Coloristes[FColoristePosition]).Personne.ID);
end;

procedure TFicheAlbum.ColoristeNomGetValue(Sender: TObject; var Value: Variant);
begin
  Value := TAuteur(FAlbum.Coloristes[FColoristePosition]).Personne.Nom;
end;

procedure TFicheAlbum.ColoristeNomGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FormatTitre(ColoristeNom.Value));
end;

procedure TFicheAlbum.HistoireSerieGetValue(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FAlbum.Serie.Sujet.Text);
end;

procedure TFicheAlbum.NotesSerieGetValue(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FAlbum.Serie.Notes.Text);
end;

procedure TFicheAlbum.EditionGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FEditions[FEditionPosition].TypeEdition;
end;

procedure TFicheAlbum.EditionGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := FEditions[FEditionPosition].sTypeEdition;
end;

procedure TFicheAlbum.CouverturesGetFirstRecord(Sender: TObject; var Eof: Boolean);
begin
  FCouverturePosition := 0;
  Eof := FCouverturePosition >= FEditions[FEditionPosition].Couvertures.Count;
end;

procedure TFicheAlbum.CouverturesGetNextRecord(Sender: TObject; var Eof: Boolean);
begin
  Eof := FCouverturePosition >= FEditions[FEditionPosition].Couvertures.Count;
  if not Eof then Inc(FCouverturePosition);
end;

procedure TFicheAlbum.CouverturesGetRecordCount(Sender: TObject; var Count: Integer);
begin
  Count := FEditions[FEditionPosition].Couvertures.Count;
end;

procedure TFicheAlbum.CouverturesGetRecordIndex(Sender: TObject; var Index: Integer);
begin
  Index := FCouverturePosition;
end;

procedure TFicheAlbum.CouvertureGetHREF(Sender: TObject; var HREF: string);
begin
  if FEditions[FEditionPosition].Couvertures.Count > 0 then
    HREF := Format('/Couverture?RefAlbum=%s&RefCouverture=%s', [GUIDToString(FAlbum.ID_Album), GUIDToString(TCouverture(FEditions[FEditionPosition].Couvertures[FCouverturePosition]).ID)])
  else
    HREF := '/';
end;

procedure TFicheAlbum.RefCouvertureGetValue(Sender: TObject; var Value: Variant);
begin
  Value := GUIDToString(TCouverture(FEditions[FEditionPosition].Couvertures[FCouverturePosition]).ID);
end;

procedure TFicheAlbum.CouvertureGetImageName(Sender: TObject; var Value: string);
begin
  Value := TCouverture(FEditions[FEditionPosition].Couvertures[FCouverturePosition]).OldNom;
end;

procedure TFicheAlbum.TomeDebutGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FAlbum.TomeDebut;
end;

procedure TFicheAlbum.TomeDebutGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := NonZero(IntToStr(FAlbum.TomeDebut));
end;

procedure TFicheAlbum.TomeFinGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FAlbum.TomeFin;
end;

procedure TFicheAlbum.TomeFinGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := NonZero(IntToStr(FAlbum.TomeFin));
end;

procedure TFicheAlbum.EditionNotesGetValue(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FEditions[FEditionPosition].Notes.Text);
end;

procedure TFicheAlbum.EditeurSiteWebGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FEditions[FEditionPosition].Editeur.SiteWeb;
end;

procedure TFicheAlbum.EditeurSiteWebGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(EditeurSiteWeb.Value);
end;

procedure TFicheAlbum.DateAchatGetValue(Sender: TObject; var Value: Variant);
begin
  if FEditions[FEditionPosition].DateAchat = 0 then
    Value := varNull
  else
    Value := FEditions[FEditionPosition].DateAchat
end;

procedure TFicheAlbum.DateAchatGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FEditions[FEditionPosition].sDateAchat);
end;

procedure TFicheAlbum.NomEditeurGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := HTMLPrepare(FormatTitre(NomEditeur.Value));
end;

procedure TFicheAlbum.OffertGetValue(Sender: TObject; var Value: Boolean);
begin
  Value := FEditions[FEditionPosition].Offert;
end;

procedure TFicheAlbum.GratuitGetValue(Sender: TObject; var Value: Boolean);
begin
  Value := FEditions[FEditionPosition].Gratuit;
end;

procedure TFicheAlbum.NombreDePagesGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := NonZero(IntToStr(FEditions[FEditionPosition].NombreDePages));
end;

procedure TFicheAlbum.NombreDePagesGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FEditions[FEditionPosition].NombreDePages;
end;

procedure TFicheAlbum.OrientationGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := FEditions[FEditionPosition].sOrientation;
end;

procedure TFicheAlbum.OrientationGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FEditions[FEditionPosition].Orientation;
end;

procedure TFicheAlbum.FormatEditionGetDisplayText(Sender: TObject; var Value: string);
begin
  Value := FEditions[FEditionPosition].sFormatEdition;
end;

procedure TFicheAlbum.FormatEditionGetValue(Sender: TObject; var Value: Variant);
begin
  Value := FEditions[FEditionPosition].FormatEdition;
end;

initialization
  if WebRequestHandler <> nil then
    WebRequestHandler.AddWebModuleFactory(TWebPageModuleFactory.Create(TFicheAlbum, TWebPageInfo.Create([wpPublished {, wpLoginRequired}], ''), crOnDemand, caDestroy));

end.

