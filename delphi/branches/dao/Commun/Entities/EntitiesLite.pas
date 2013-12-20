unit EntitiesLite;

interface

uses
  Windows, SysUtils, DB, Classes, ComCtrls, StdCtrls, Commun, UMetaData, SyncObjs, Generics.Collections;

type
  TBaseLiteClass = class of TBaseLite;

  TBaseLite = class(TObject)
  public
    ID: RGUIDEx;

    procedure Assign(Ps: TBaseLite); virtual;

    procedure AfterConstruction; override;
    constructor Create; virtual;

    procedure Clear; virtual;
    function ChaineAffichage(dummy: Boolean = True): string; virtual; abstract;
  end;

  TCouvertureLite = class(TBaseLite)
  public
    OldNom, NewNom: string { [255] };
    OldStockee, NewStockee: Boolean;
    Categorie: Smallint;
    sCategorie: string { [50] };

    procedure Assign(Ps: TBaseLite); override;

    function ChaineAffichage(dummy: Boolean = True): string; override;
  end;

  TParaBDLite = class(TBaseLite)
  public
    Titre: string { [150] };
    ID_Serie: RGUIDEx;
    Serie: string { [150] };
    sCategorie: string { [50] };
    Achat: Boolean;
    Complet: Boolean;

    procedure Assign(Ps: TBaseLite); override;

    function ChaineAffichage(AvecSerie: Boolean): string; overload; override;
    function ChaineAffichage(Simple: Boolean; AvecSerie: Boolean): string; reintroduce; overload;
  end;

  TPersonnageLite = class(TBaseLite)
  public
    Nom: string { [150] };

    procedure Assign(Ps: TBaseLite); override;

    function ChaineAffichage(dummy: Boolean = True): string; override;
    procedure Clear; override;
  end;

  TAuteurLite = class(TBaseLite)
  public
    Personne: TPersonnageLite;
    ID_Album, ID_Serie: RGUIDEx;
    Metier: TMetierAuteur;

    procedure Assign(Ps: TBaseLite); override;

    constructor Create; override;
    destructor Destroy; override;

    procedure Clear; override;
    function ChaineAffichage(dummy: Boolean = True): string; override;
  end;

  TUniversLite = class(TBaseLite)
  public
    NomUnivers: string { [50] };

    procedure Assign(Ps: TBaseLite); override;

    function ChaineAffichage(dummy: Boolean = True): string; override;
    procedure Clear; override;
  end;

  TEditeurLite = class(TBaseLite)
  public
    NomEditeur: string { [50] };

    procedure Assign(Ps: TBaseLite); override;

    function ChaineAffichage(dummy: Boolean = True): string; override;
    procedure Clear; override;
  end;

  TAlbumLite = class(TBaseLite)
  public
    Tome: Integer;
    TomeDebut: Integer;
    TomeFin: Integer;
    Titre: string { [150] };
    ID_Serie: RGUIDEx;
    Serie: string { [150] };
    ID_Editeur: RGUIDEx;
    Editeur: string { [50] };
    AnneeParution, MoisParution: Integer;
    Stock: Boolean;
    Integrale: Boolean;
    HorsSerie: Boolean;
    Achat: Boolean;
    Complet: Boolean;
    Notation: Integer;

    procedure Assign(Ps: TBaseLite); override;

    function ChaineAffichage(AvecSerie: Boolean): string; overload; override;
    function ChaineAffichage(Simple, AvecSerie: Boolean): string; reintroduce; overload;
  end;

  TCollectionLite = class(TBaseLite)
  public
    NomCollection: string { [50] };
    Editeur: TEditeurLite;

    procedure Assign(Ps: TBaseLite); override;

    constructor Create; override;
    destructor Destroy; override;

    function ChaineAffichage(Simple: Boolean = True): string; override;
    procedure Clear; override;
  end;

  TSerieLite = class(TBaseLite)
  public
    TitreSerie: string { [150] };
    Editeur: TEditeurLite;
    Collection: TCollectionLite;

    procedure Assign(Ps: TBaseLite); override;

    constructor Create; override;
    destructor Destroy; override;

    function ChaineAffichage(Simple: Boolean): string; override;
    procedure Clear; override;
  end;

  TEditionLite = class(TBaseLite)
  public
    AnneeEdition: Integer;
    ISBN: string { [17] };
    Editeur: TEditeurLite;
    Collection: TCollectionLite;

    procedure Assign(Ps: TBaseLite); override;

    constructor Create; override;
    destructor Destroy; override;

    function ChaineAffichage(dummy: Boolean = True): string; override;
    procedure Clear; override;
  end;

  TConversionLite = class(TBaseLite)
    Monnaie1, Monnaie2: string { [5] };
    Taux: Double;

    function ChaineAffichage(dummy: Boolean = True): string; override;
  end;

  TGenreLite = class(TBaseLite)
  public
    Genre: string { [50] };
    Quantite: Integer;

    procedure Assign(Ps: TBaseLite); override;

    function ChaineAffichage(dummy: Boolean = True): string; override;
    procedure Clear; override;
  end;

function MakeAuteur(const Nom: string; Metier: TMetierAuteur): TAuteurLite;
function MakeUnivers(const Nom: string): TUniversLite;

implementation

uses
  StrUtils;

function MakeAuteur(const Nom: string; Metier: TMetierAuteur): TAuteurLite;
begin
  Result := TAuteurLite.Create;
  Result.Personne.Nom := Nom;
  Result.Metier := Metier;
end;

function MakeUnivers(const Nom: string): TUniversLite;
begin
  Result := TUniversLite.Create;
  Result.NomUnivers := Nom;
end;

{ TBasePointeur }

procedure TBaseLite.AfterConstruction;
begin
  inherited;
  Clear;
end;

procedure TBaseLite.Assign(Ps: TBaseLite);
begin
  ID := Ps.ID;
end;

procedure TBaseLite.Clear;
begin
  ID := GUID_NULL;
end;

constructor TBaseLite.Create;
begin
  inherited;
  ID := GUID_NULL;
end;

{ TConversion }

function TConversionLite.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := Format('1 %s = %.2f %s', [Monnaie1, Taux, Monnaie2]);
end;

{ TCouverture }

procedure TCouvertureLite.Assign(Ps: TBaseLite);
begin
  inherited;
  OldNom := TCouvertureLite(Ps).OldNom;
  NewNom := TCouvertureLite(Ps).NewNom;
  OldStockee := TCouvertureLite(Ps).OldStockee;
  NewStockee := TCouvertureLite(Ps).NewStockee;
  Categorie := TCouvertureLite(Ps).Categorie;
  sCategorie := TCouvertureLite(Ps).sCategorie;
end;

function TCouvertureLite.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := NewNom;
end;

{ TEditeur }

procedure TEditeurLite.Assign(Ps: TBaseLite);
begin
  inherited Assign(Ps);
  NomEditeur := TEditeurLite(Ps).NomEditeur;
end;

function TEditeurLite.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := FormatTitre(NomEditeur);
end;

procedure TEditeurLite.Clear;
begin
  inherited;
  NomEditeur := '';
end;

{ TPersonnage }

procedure TPersonnageLite.Assign(Ps: TBaseLite);
begin
  inherited;
  Nom := TPersonnageLite(Ps).Nom;
end;

function TPersonnageLite.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := FormatTitre(Nom);
end;

procedure TPersonnageLite.Clear;
begin
  inherited;
  Nom := '';
end;

{ TAuteur }

procedure TAuteurLite.Assign(Ps: TBaseLite);
begin
  inherited;
  ID_Album := TAuteurLite(Ps).ID_Album;
  Metier := TAuteurLite(Ps).Metier;
  Personne.Assign(TAuteurLite(Ps).Personne);
end;

function TAuteurLite.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := Personne.ChaineAffichage;
end;

constructor TAuteurLite.Create;
begin
  inherited;
  Personne := TPersonnageLite.Create;
end;

destructor TAuteurLite.Destroy;
begin
  FreeAndNil(Personne);
  inherited;
end;

procedure TAuteurLite.Clear;
begin
  inherited;
  Personne.Clear;
end;

{ TAlbum }

procedure TAlbumLite.Assign(Ps: TBaseLite);
begin
  inherited;
  Titre := TAlbumLite(Ps).Titre;
  Tome := TAlbumLite(Ps).Tome;
  TomeDebut := TAlbumLite(Ps).TomeDebut;
  TomeFin := TAlbumLite(Ps).TomeFin;
  ID_Serie := TAlbumLite(Ps).ID_Serie;
  Integrale := TAlbumLite(Ps).Integrale;
  HorsSerie := TAlbumLite(Ps).HorsSerie;
  ID_Editeur := TAlbumLite(Ps).ID_Editeur;
  Serie := TAlbumLite(Ps).Serie;
  Editeur := TAlbumLite(Ps).Editeur;
  AnneeParution := TAlbumLite(Ps).AnneeParution;
  MoisParution := TAlbumLite(Ps).MoisParution;
  Stock := TAlbumLite(Ps).Stock;
  Notation := TAlbumLite(Ps).Notation;
end;

function TAlbumLite.ChaineAffichage(Simple, AvecSerie: Boolean): string;
begin
  Result := FormatTitreAlbum(Simple, AvecSerie, Titre, Serie, Tome, TomeDebut, TomeFin, Integrale, HorsSerie);
end;

function TAlbumLite.ChaineAffichage(AvecSerie: Boolean): string;
begin
  Result := ChaineAffichage(False, AvecSerie);
end;

{ TCollection }

procedure TCollectionLite.Assign(Ps: TBaseLite);
begin
  inherited;
  NomCollection := TCollectionLite(Ps).NomCollection;
  Editeur.Assign(TCollectionLite(Ps).Editeur);
end;

function TCollectionLite.ChaineAffichage(Simple: Boolean = True): string;
begin
  Result := FormatTitre(NomCollection);
  if not Simple then
    AjoutString(Result, FormatTitre(Editeur.NomEditeur), ' ', '(', ')');
end;

constructor TCollectionLite.Create;
begin
  inherited;
  Editeur := TEditeurLite.Create;
end;

destructor TCollectionLite.Destroy;
begin
  FreeAndNil(Editeur);
  inherited;
end;

procedure TCollectionLite.Clear;
begin
  inherited;
  NomCollection := '';
  Editeur.Clear;
end;

{ TSerie }

procedure TSerieLite.Assign(Ps: TBaseLite);
begin
  inherited;
  TitreSerie := TSerieLite(Ps).TitreSerie;
  Editeur.Assign(TSerieLite(Ps).Editeur);
  Collection.Assign(TSerieLite(Ps).Collection);
end;

function TSerieLite.ChaineAffichage(Simple: Boolean): string;
var
  s: string;
begin
  if Simple then
    Result := TitreSerie
  else
    Result := FormatTitre(TitreSerie);
  s := '';
  AjoutString(s, FormatTitre(Editeur.NomEditeur), ' ');
  AjoutString(s, FormatTitre(Collection.NomCollection), ' - ');
  AjoutString(Result, s, ' ', '(', ')');
end;

constructor TSerieLite.Create;
begin
  inherited;
  Editeur := TEditeurLite.Create;
  Collection := TCollectionLite.Create;
end;

destructor TSerieLite.Destroy;
begin
  FreeAndNil(Collection);
  FreeAndNil(Editeur);
  inherited;
end;

procedure TSerieLite.Clear;
begin
  inherited;
  Editeur.Clear;
  Collection.Clear;
end;

{ TEdition }

procedure TEditionLite.Assign(Ps: TBaseLite);
begin
  inherited;
  AnneeEdition := TEditionLite(Ps).AnneeEdition;
  ISBN := TEditionLite(Ps).ISBN;
  Collection.Assign(TEditionLite(Ps).Collection);
  Editeur.Assign(TEditionLite(Ps).Editeur);
end;

function TEditionLite.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := '';
  AjoutString(Result, FormatTitre(Editeur.NomEditeur), ' ');
  AjoutString(Result, FormatTitre(Collection.NomCollection), ' ', '(', ')');
  AjoutString(Result, NonZero(IntToStr(AnneeEdition)), ' ', '[', ']');
  AjoutString(Result, FormatISBN(ISBN), ' - ', 'ISBN ');
end;

constructor TEditionLite.Create;
begin
  inherited;
  Editeur := TEditeurLite.Create;
  Collection := TCollectionLite.Create;
end;

destructor TEditionLite.Destroy;
begin
  FreeAndNil(Editeur);
  FreeAndNil(Collection);
  inherited;
end;

procedure TEditionLite.Clear;
begin
  inherited;
  Editeur.Clear;
  Collection.Clear;
end;

{ TGenre }

procedure TGenreLite.Assign(Ps: TBaseLite);
begin
  inherited;
  Genre := TGenreLite(Ps).Genre;
  Quantite := TGenreLite(Ps).Quantite;
end;

function TGenreLite.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := Genre;
end;

procedure TGenreLite.Clear;
begin
  inherited;
  Genre := '';
end;

{ TParaBD }

procedure TParaBDLite.Assign(Ps: TBaseLite);
begin
  inherited;
  Titre := TParaBDLite(Ps).Titre;
  ID_Serie := TParaBDLite(Ps).ID_Serie;
  Serie := TParaBDLite(Ps).Serie;
  Achat := TParaBDLite(Ps).Achat;
  Complet := TParaBDLite(Ps).Complet;
end;

function TParaBDLite.ChaineAffichage(AvecSerie: Boolean): string;
begin
  Result := ChaineAffichage(False, AvecSerie);
end;

function TParaBDLite.ChaineAffichage(Simple: Boolean; AvecSerie: Boolean): string;
var
  s: string;
begin
  if Simple then
    Result := Titre
  else
    Result := FormatTitre(Titre);
  s := '';
  if AvecSerie then
    if Result = '' then
      Result := FormatTitre(Serie)
    else
      AjoutString(s, FormatTitre(Serie), ' - ');
  AjoutString(s, sCategorie, ' - ');
  if Result = '' then
    Result := s
  else
    AjoutString(Result, s, ' ', '(', ')');
end;

{ TUnivers }

procedure TUniversLite.Assign(Ps: TBaseLite);
begin
  inherited Assign(Ps);
  NomUnivers := TUniversLite(Ps).NomUnivers;
end;

function TUniversLite.ChaineAffichage(dummy: Boolean): string;
begin
  Result := FormatTitre(NomUnivers);
end;

procedure TUniversLite.Clear;
begin
  inherited;
  NomUnivers := '';
end;

end.
