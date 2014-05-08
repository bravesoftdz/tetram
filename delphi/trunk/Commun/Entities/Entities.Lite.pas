unit Entities.Lite;

interface

uses
  Windows, SysUtils, DB, Classes, ComCtrls, StdCtrls, Commun, UMetaData, SyncObjs, Generics.Collections,
  Entities.Common;

type
  TBaseLiteClass = class of TBaseLite;

  TBaseLite = class(TDBEntity)
  public
    function ChaineAffichage(dummy: Boolean = True): string; virtual; abstract;
  end;

  TPhotoLite = class(TBaseLite)
  public
    OldNom, NewNom: string { [255] };
    OldStockee, NewStockee: Boolean;

    constructor Create; override;

    procedure Assign(Source: TPersistent); override;
    function ChaineAffichage(dummy: Boolean = True): string; override;
  end;

  TCouvertureLite = class(TPhotoLite)
  public
    Categorie: Smallint;
    sCategorie: string { [50] };

    procedure Assign(Source: TPersistent); override;
  end;

  TParaBDLite = class(TBaseLite)
  public
    Titre: string { [150] };
    ID_Serie: RGUIDEx;
    Serie: string { [150] };
    sCategorie: string { [50] };
    Achat: Boolean;
    Complet: Boolean;

    procedure Assign(Source: TPersistent); override;
    function ChaineAffichage(AvecSerie: Boolean): string; overload; override;
    function ChaineAffichage(Simple: Boolean; AvecSerie: Boolean): string; reintroduce; overload;
  end;

  TPersonnageLite = class(TBaseLite)
  public
    Nom: string { [150] };

    procedure Assign(Source: TPersistent); override;
    function ChaineAffichage(dummy: Boolean = True): string; override;
    procedure Clear; override;
  end;

  TAuteurLite = class(TBaseLite)
  public
    Personne: TPersonnageLite;
    ID_Album, ID_Serie: RGUIDEx;
    Metier: TMetierAuteur;

    procedure Assign(Source: TPersistent); override;

    constructor Create; override;
    destructor Destroy; override;

    procedure Clear; override;
    function ChaineAffichage(dummy: Boolean = True): string; override;
  end;

  TUniversLite = class(TBaseLite)
  public
    NomUnivers: string { [50] };

    procedure Assign(Source: TPersistent); override;

    function ChaineAffichage(dummy: Boolean = True): string; override;
    procedure Clear; override;
  end;

  TEditeurLite = class(TBaseLite)
  public
    NomEditeur: string { [50] };

    procedure Assign(Source: TPersistent); override;

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

    procedure Assign(Source: TPersistent); override;

    function ChaineAffichage(AvecSerie: Boolean): string; overload; override;
    function ChaineAffichage(Simple, AvecSerie: Boolean): string; reintroduce; overload;
  end;

  TCollectionLite = class(TBaseLite)
  public
    NomCollection: string { [50] };
    Editeur: TEditeurLite;

    procedure Assign(Source: TPersistent); override;

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

    procedure Assign(Source: TPersistent); override;

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

    procedure Assign(Source: TPersistent); override;

    constructor Create; override;
    destructor Destroy; override;

    function ChaineAffichage(dummy: Boolean = True): string; override;
    procedure Clear; override;
  end;

  TConversionLite = class(TBaseLite)
  public
    Monnaie1, Monnaie2: string { [5] };
    Taux: Double;

    function ChaineAffichage(dummy: Boolean = True): string; override;
  end;

  TGenreLite = class(TBaseLite)
  public
    Genre: string { [50] };
    Quantite: Integer;

    procedure Assign(Source: TPersistent); override;

    function ChaineAffichage(dummy: Boolean = True): string; override;
    procedure Clear; override;
  end;

function MakeAuteur(const Nom: string; Metier: TMetierAuteur): TAuteurLite;
function MakeUnivers(const Nom: string): TUniversLite;

implementation

uses
  StrUtils, Entities.FactoriesLite, CommonConst;

function MakeAuteur(const Nom: string; Metier: TMetierAuteur): TAuteurLite;
begin
  Result := TFactoryAuteurLite.getInstance;
  Result.Personne.Nom := Nom;
  Result.Metier := Metier;
end;

function MakeUnivers(const Nom: string): TUniversLite;
begin
  Result := TFactoryUniversLite.getInstance;
  Result.NomUnivers := Nom;
end;

{ TConversionLite }

function TConversionLite.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := Format('1 %s = %.2f %s', [Monnaie1, Taux, Monnaie2]);
end;

{ TPhotoLite }

procedure TPhotoLite.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TPhotoLite then
  begin
    OldNom := TPhotoLite(Source).OldNom;
    NewNom := TPhotoLite(Source).NewNom;
    OldStockee := TPhotoLite(Source).OldStockee;
    NewStockee := TPhotoLite(Source).NewStockee;
  end;
end;

function TPhotoLite.ChaineAffichage(dummy: Boolean): string;
begin
  Result := NewNom;
end;

constructor TPhotoLite.Create;
begin
  inherited;
  OldStockee := TGlobalVar.Utilisateur.Options.ImagesStockees;
  NewStockee := OldStockee;
end;

{ TCouvertureLite }

procedure TCouvertureLite.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TCouvertureLite then
  begin
    Categorie := TCouvertureLite(Source).Categorie;
    sCategorie := TCouvertureLite(Source).sCategorie;
  end;
end;

{ TEditeurLite }

procedure TEditeurLite.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TEditeurLite then
    NomEditeur := TEditeurLite(Source).NomEditeur;
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

{ TPersonnageLite }

procedure TPersonnageLite.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TPersonnageLite then
    Nom := TPersonnageLite(Source).Nom;
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

{ TAuteurLite }

procedure TAuteurLite.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TAuteurLite then
  begin
    ID_Album := TAuteurLite(Source).ID_Album;
    Metier := TAuteurLite(Source).Metier;
    Personne.Assign(TAuteurLite(Source).Personne);
  end;
end;

function TAuteurLite.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := Personne.ChaineAffichage;
end;

constructor TAuteurLite.Create;
begin
  inherited;
  Personne := TFactoryPersonnageLite.getInstance;
end;

destructor TAuteurLite.Destroy;
begin
  FreeAndNil(Personne);
  inherited;
end;

procedure TAuteurLite.Clear;
begin
  inherited;
  Personne.DoClear;
end;

{ TAlbumLite }

procedure TAlbumLite.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TAlbumLite then
  begin
    Titre := TAlbumLite(Source).Titre;
    Tome := TAlbumLite(Source).Tome;
    TomeDebut := TAlbumLite(Source).TomeDebut;
    TomeFin := TAlbumLite(Source).TomeFin;
    ID_Serie := TAlbumLite(Source).ID_Serie;
    Integrale := TAlbumLite(Source).Integrale;
    HorsSerie := TAlbumLite(Source).HorsSerie;
    ID_Editeur := TAlbumLite(Source).ID_Editeur;
    Serie := TAlbumLite(Source).Serie;
    Editeur := TAlbumLite(Source).Editeur;
    AnneeParution := TAlbumLite(Source).AnneeParution;
    MoisParution := TAlbumLite(Source).MoisParution;
    Stock := TAlbumLite(Source).Stock;
    Notation := TAlbumLite(Source).Notation;
  end;
end;

function TAlbumLite.ChaineAffichage(Simple, AvecSerie: Boolean): string;
begin
  Result := FormatTitreAlbum(Simple, AvecSerie, Titre, Serie, Tome, TomeDebut, TomeFin, Integrale, HorsSerie);
end;

function TAlbumLite.ChaineAffichage(AvecSerie: Boolean): string;
begin
  Result := ChaineAffichage(False, AvecSerie);
end;

{ TCollectionLite }

procedure TCollectionLite.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TCollectionLite then
  begin
    NomCollection := TCollectionLite(Source).NomCollection;
    Editeur.Assign(TCollectionLite(Source).Editeur);
  end;
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
  Editeur := TFactoryEditeurLite.getInstance;
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
  Editeur.DoClear;
end;

{ TSerieLite }

procedure TSerieLite.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TSerieLite then
  begin
    TitreSerie := TSerieLite(Source).TitreSerie;
    Editeur.Assign(TSerieLite(Source).Editeur);
    Collection.Assign(TSerieLite(Source).Collection);
  end;
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
  Editeur := TFactoryEditeurLite.getInstance;
  Collection := TFactoryCollectionLite.getInstance;
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
  Editeur.DoClear;
  Collection.DoClear;
end;

{ TEditionLite }

procedure TEditionLite.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TEditeurLite then
  begin
    AnneeEdition := TEditionLite(Source).AnneeEdition;
    ISBN := TEditionLite(Source).ISBN;
    Collection.Assign(TEditionLite(Source).Collection);
    Editeur.Assign(TEditionLite(Source).Editeur);
  end;
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
  Editeur := TFactoryEditeurLite.getInstance;
  Collection := TFactoryCollectionLite.getInstance;
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
  Editeur.DoClear;
  Collection.DoClear;
end;

{ TGenreLite }

procedure TGenreLite.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TGenreLite then
  begin
    Genre := TGenreLite(Source).Genre;
    Quantite := TGenreLite(Source).Quantite;
  end;
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

{ TParaBDLite }

procedure TParaBDLite.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TParaBDLite then
  begin
    Titre := TParaBDLite(Source).Titre;
    ID_Serie := TParaBDLite(Source).ID_Serie;
    Serie := TParaBDLite(Source).Serie;
    Achat := TParaBDLite(Source).Achat;
    Complet := TParaBDLite(Source).Complet;
  end;
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

{ TUniversLite }

procedure TUniversLite.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TUniversLite then
    NomUnivers := TUniversLite(Source).NomUnivers;
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
