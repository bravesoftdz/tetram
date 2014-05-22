unit Entities.Full;

interface

uses
  System.SysUtils, Windows, Classes, Dialogs, Entities.Lite, Commun, CommonConst, DateUtils, Generics.Collections,
  Generics.Defaults, System.Generics.Collections, ORM.Core.Entities, Entities.Types, ORM.Core.Attributes, ORM.Core.Types,
  ORM.Core.Factories;

type
  TObjetFullClass = class of TObjetFull;

  TObjetFull = class(TabstractDBEntity)
  strict private
    FAssociations: TStringList;
  protected
    constructor Create; override;
    procedure DoClear; override;
  public
    RecInconnu: Boolean;
    destructor Destroy; override;
    function ChaineAffichage(dummy: Boolean = True): string; virtual;
  published
    property Associations: TStringList read FAssociations;
  end;

  TListFull = class(TabstractEntity)
  end;

  [Entity('editeurs')]
  TEditeurFull = class(TObjetFull)
  strict private
    FNomEditeur: RAutoTrimString;
    FSiteWeb: RAutoTrimString;
  private
    procedure SetNomEditeur(const Value: string);
    procedure SetSiteWeb(const Value: string);
    function GetNomEditeur: string;
    function GetSiteWeb: string;
  protected
    procedure DoClear; override;
  published
    [PrimaryKey]
    property ID_Editeur: RGUIDEx read GetID write SetID;
    [EntityField]
    property NomEditeur: string read GetNomEditeur write SetNomEditeur;
    [EntityField]
    property SiteWeb: string read GetSiteWeb write SetSiteWeb;
  end;

  [Entity('collections')]
  TCollectionFull = class(TObjetFull)
  strict private
    FNomCollection: RAutoTrimString;
    FEditeur: TEditeurLite;
  private
    function GetID_Editeur: RGUIDEx;
    procedure SetNomCollection(const Value: string);
    function GetNomCollection: string;
  protected
    constructor Create; override;
    procedure DoClear; override;
  public
    destructor Destroy; override;
  published
    [PrimaryKey]
    property ID_Collection: RGUIDEx read GetID write SetID;
    [EntityField]
    property NomCollection: string read GetNomCollection write SetNomCollection;
    [EntityField('id_editeur')]
    property Editeur: TEditeurLite read FEditeur;
    property ID_Editeur: RGUIDEx read GetID_Editeur;
  end;

  [Entity('univers')]
  TUniversFull = class(TObjetFull)
  strict private
    FNomUnivers: RAutoTrimString;
    FUniversParent: TUniversLite;
    FDescription: RLongString;
    FSiteWeb: RAutoTrimString;
  private
    procedure SetNomUnivers(const Value: string);
    function GetID_UniversParent: RGUIDEx;
    procedure SetSiteWeb(const Value: string);
    function GetNomUnivers: string;
    function GetDescription: string;
    function GetSiteWeb: string;
    procedure SetDescription(const Value: string);
  protected
    constructor Create; override;
    procedure DoClear; override;
  public
    destructor Destroy; override;
    function ChaineAffichage(dummy: Boolean = True): string; override;
  published
    [PrimaryKey]
    property ID_Univers: RGUIDEx read GetID write SetID;
    [EntityField]
    property NomUnivers: string read GetNomUnivers write SetNomUnivers;
    [EntityField]
    property SiteWeb: string read GetSiteWeb write SetSiteWeb;
    [EntityField]
    property Description: string read GetDescription write SetDescription;
    [EntityField('id_univers_parent')]
    property UniversParent: TUniversLite read FUniversParent;
    property ID_UniversParent: RGUIDEx read GetID_UniversParent;
  end;

  [Entity('series')]
  TSerieFull = class(TObjetFull)
  strict private
    FTitreSerie: RAutoTrimString;
    FTerminee: RTriStateValue;
    FSujet: RLongString;
    FNotes: RLongString;
    FCollection: TCollectionLite;
    FSiteWeb: RAutoTrimString;
    FGenres: TStringList;
    FEditeur: TEditeurFull;
    FSuivreManquants: Boolean;
    FColoristes: TObjectList<TAuteurSerieLite>;
    FComplete: Boolean;
    FScenaristes: TObjectList<TAuteurSerieLite>;
    FSuivreSorties: Boolean;
    FCouleur: RTriStateValue;
    FDessinateurs: TObjectList<TAuteurSerieLite>;
    FAlbums: TObjectList<TAlbumLite>;
    FParaBD: TObjectList<TParaBDLite>;
    FNbAlbums: Integer;
    FVO: RTriStateValue;
    FReliure: ROption;
    FEtat: ROption;
    FFormatEdition: ROption;
    FTypeEdition: ROption;
    FOrientation: ROption;
    FSensLecture: ROption;
    FNotation: Integer;
    FUnivers: TObjectList<TUniversLite>;
  private
    function GetID_Editeur: RGUIDEx;
    function GetID_Collection: RGUIDEx;
    procedure SetTitreSerie(const Value: string);
    procedure SetSiteWeb(const Value: string);
    function GetNotes: string;
    function GetSiteWeb: string;
    function GetSujet: string;
    procedure SetNotes(const Value: string);
    procedure SetSujet(const Value: string);
    function GetTitreSerie: string;
  protected
    constructor Create; override;
    procedure DoClear; override;
  public
    destructor Destroy; override;
    function ChaineAffichage: string; reintroduce; overload;
    function ChaineAffichage(Simple: Boolean): string; overload; override;
  published
    [PrimaryKey]
    property ID_Serie: RGUIDEx read GetID write SetID;
    property ID_Editeur: RGUIDEx read GetID_Editeur;
    property ID_Collection: RGUIDEx read GetID_Collection;
    [EntityField]
    property TitreSerie: string read GetTitreSerie write SetTitreSerie;
    property Terminee: RTriStateValue read FTerminee write FTerminee;
    property Genres: TStringList read FGenres;
    [EntityField('sujetserie')]
    property Sujet: string read GetSujet write SetSujet;
    [EntityField('remarquesserie')]
    property Notes: string read GetNotes write SetNotes;
    [EntityField('id_editeur')]
    property Editeur: TEditeurFull read FEditeur;
    [EntityField('id_collection')]
    property Collection: TCollectionLite read FCollection;
    [EntityField]
    property SiteWeb: string read GetSiteWeb write SetSiteWeb;
    [EntityField]
    property Complete: Boolean read FComplete write FComplete;
    [EntityField]
    property SuivreManquants: Boolean read FSuivreManquants write FSuivreManquants;
    [EntityField]
    property SuivreSorties: Boolean read FSuivreSorties write FSuivreSorties;
    [EntityField('nb_albums')]
    property NbAlbums: Integer read FNbAlbums write FNbAlbums;
    property Albums: TObjectList<TAlbumLite> read FAlbums;
    property ParaBD: TObjectList<TParaBDLite> read FParaBD;
    property Scenaristes: TObjectList<TAuteurSerieLite> read FScenaristes;
    property Dessinateurs: TObjectList<TAuteurSerieLite> read FDessinateurs;
    property Coloristes: TObjectList<TAuteurSerieLite> read FColoristes;
    property VO: RTriStateValue read FVO write FVO;
    property Couleur: RTriStateValue read FCouleur write FCouleur;
    property Etat: ROption read FEtat write FEtat;
    property Reliure: ROption read FReliure write FReliure;
    property TypeEdition: ROption read FTypeEdition write FTypeEdition;
    property FormatEdition: ROption read FFormatEdition write FFormatEdition;
    property Orientation: ROption read FOrientation write FOrientation;
    property SensLecture: ROption read FSensLecture write FSensLecture;
    [EntityField]
    property Notation: Integer read FNotation write FNotation;
    property Univers: TObjectList<TUniversLite> read FUnivers;

    // pour rétrocompatibilité pour les scripts
    property Titre: string read GetTitreSerie write SetTitreSerie;
  end;

  [Entity('personnes')]
  TAuteurFull = class(TObjetFull)
  strict private
    FBiographie: RLongString;
    FNomAuteur: RAutoTrimString;
    FSiteWeb: RAutoTrimString;
    FSeries: TObjectList<TSerieFull>;
  private
    procedure SetNomAuteur(const Value: string);
    procedure SetSiteWeb(const Value: string);
    function GetBiographie: string;
    function GetNomAuteur: string;
    function GetSiteWeb: string;
    procedure SetBiographie(const Value: string);
  protected
    constructor Create; override;
    procedure DoClear; override;
  public
    destructor Destroy; override;
    function ChaineAffichage(dummy: Boolean = True): string; override;
  published
    [PrimaryKey('id_personne')]
    property ID_Auteur: RGUIDEx read GetID write SetID;
    [EntityField('nompersonne')]
    property NomAuteur: string read GetNomAuteur write SetNomAuteur;
    [EntityField]
    property SiteWeb: string read GetSiteWeb write SetSiteWeb;
    [EntityField]
    property Biographie: string read GetBiographie write SetBiographie;
    property Series: TObjectList<TSerieFull> read FSeries;
  end;

  [Entity('editions')]
  TEditionFull = class(TObjetFull)
  strict private
    FStock: Boolean;
    FCouvertures: TObjectList<TCouvertureLite>;
    FPrix: Currency;
    FAnneeCote: Integer;
    FISBN: RAutoTrimString;
    FGratuit: Boolean;
    FPrete: Boolean;
    FNombreDePages: Integer;
    FNumeroPerso: RAutoTrimString;
    FNotes: RLongString;
    FReliure: ROption;
    FAnneeEdition: Integer;
    FDedicace: Boolean;
    FCouleur: Boolean;
    FEtat: ROption;
    FCollection: TCollectionLite;
    FFormatEdition: ROption;
    FTypeEdition: ROption;
    FPrixCote: Currency;
    FOrientation: ROption;
    FDateAchat: TDateTime;
    FOffert: Boolean;
    FSensLecture: ROption;
    FEditeur: TEditeurFull;
    FVO: Boolean;

    [EntityField]
    FID_Album: TGUID;
  private
    function Get_sDateAchat: string;
    procedure SetNumeroPerso(const Value: string);
    function GetISBN: string;
    function GetNotes: string;
    function GetNumeroPerso: string;
    procedure SetISBN(const Value: string);
    procedure SetNotes(const Value: string);
    function GetID_Album: RGUIDEx;
    procedure SetID_Album(const Value: RGUIDEx);
  protected
    constructor Create; override;
    procedure DoClear; override;
  public
    destructor Destroy; override;
    function ChaineAffichage(dummy: Boolean = True): string; override;
  published
    [PrimaryKey]
    property ID_Edition: RGUIDEx read GetID write SetID;
    property ID_Album: RGUIDEx read GetID_Album write SetID_Album;
    [EntityField('id_editeur')]
    property Editeur: TEditeurFull read FEditeur;
    [EntityField('id_collection')]
    property Collection: TCollectionLite read FCollection;
    property TypeEdition: ROption read FTypeEdition write FTypeEdition;
    [EntityField]
    property AnneeEdition: Integer read FAnneeEdition write FAnneeEdition;
    property Etat: ROption read FEtat write FEtat;
    property Reliure: ROption read FReliure write FReliure;
    [EntityField]
    property NombreDePages: Integer read FNombreDePages write FNombreDePages;
    property FormatEdition: ROption read FFormatEdition write FFormatEdition;
    property Orientation: ROption read FOrientation write FOrientation;
    [EntityField]
    property AnneeCote: Integer read FAnneeCote write FAnneeCote;
    property SensLecture: ROption read FSensLecture write FSensLecture;
    [EntityField]
    property Prix: Currency read FPrix write FPrix;
    [EntityField]
    property PrixCote: Currency read FPrixCote write FPrixCote;
    [EntityField]
    property Couleur: Boolean read FCouleur write FCouleur;
    [EntityField]
    property VO: Boolean read FVO write FVO;
    [EntityField]
    property Dedicace: Boolean read FDedicace write FDedicace;
    [EntityField]
    property Stock: Boolean read FStock write FStock;
    [EntityField]
    property Prete: Boolean read FPrete write FPrete;
    [EntityField]
    property Offert: Boolean read FOffert write FOffert;
    [EntityField]
    property Gratuit: Boolean read FGratuit write FGratuit;
    [EntityField]
    property ISBN: string read GetISBN write SetISBN;
    [EntityField]
    property DateAchat: TDateTime read FDateAchat write FDateAchat;
    property sDateAchat: string read Get_sDateAchat;
    [EntityField]
    property Notes: string read GetNotes write SetNotes;
    [EntityField]
    property NumeroPerso: string { [25] } read GetNumeroPerso write SetNumeroPerso;
    property Couvertures: TObjectList<TCouvertureLite> read FCouvertures;
  end;

  [Entity('albums')]
  TAlbumFull = class(TObjetFull)
  strict private
    FTitreAlbum: RAutoTrimString;
    FSerie: TSerieFull;
    FSujet: RLongString;
    FHorsSerie: Boolean;
    FMoisParution: Integer;
    FTomeFin: Integer;
    FColoristes: TObjectList<TAuteurAlbumLite>;
    FNotes: RLongString;
    FAnneeParution: Integer;
    FScenaristes: TObjectList<TAuteurAlbumLite>;
    FIntegrale: Boolean;
    FDessinateurs: TObjectList<TAuteurAlbumLite>;
    FTomeDebut: Integer;
    FTome: Integer;
    FEditions: TObjectList<TEditionFull>;
    FComplet: Boolean;
    FReadyToFusion: Boolean;
    FFusionneEditions: Boolean;
    FNotation: Integer;
    FDefaultSearch: RAutoTrimString;
    FUnivers: TObjectList<TUniversLite>;
    FUniversFull: TList<TUniversLite>;
    FReadyToImport: Boolean;
  private
    function GetID_Serie: RGUIDEx;
    function GetDefaultSearch: string;
    procedure SetDefaultSearch(const Value: string);
    function GetSerie: TSerieFull;
    function GetTitreAlbum: string;
    procedure SetTitreAlbum(const Value: string);
    function GetNotes: string;
    function GetSujet: string;
    procedure SetNotes(const Value: string);
    procedure SetSujet(const Value: string);
  protected
    constructor Create; override;
    procedure DoClear; override;
  public
    destructor Destroy; override;
    function ChaineAffichage(AvecSerie: Boolean): string; overload; override;
    function ChaineAffichage(Simple, AvecSerie: Boolean): string; reintroduce; overload;

    property ReadyToImport: Boolean read FReadyToImport write FReadyToImport;
    property ReadyToFusion: Boolean read FReadyToFusion write FReadyToFusion;
    property FusionneEditions: Boolean read FFusionneEditions write FFusionneEditions;
    property DefaultSearch: string read GetDefaultSearch write SetDefaultSearch;
  published
    [EntityField]
    property Complet: Boolean read FComplet write FComplet;
    [PrimaryKey]
    property ID_Album: RGUIDEx read GetID write SetID;
    property ID_Serie: RGUIDEx read GetID_Serie;
    [EntityField]
    property TitreAlbum: string read GetTitreAlbum write SetTitreAlbum;
    [EntityField('id_serie')]
    property Serie: TSerieFull read GetSerie;
    [EntityField]
    property MoisParution: Integer read FMoisParution write FMoisParution;
    [EntityField]
    property AnneeParution: Integer read FAnneeParution write FAnneeParution;
    [EntityField]
    property Tome: Integer read FTome write FTome;
    [EntityField]
    property TomeDebut: Integer read FTomeDebut write FTomeDebut;
    [EntityField]
    property TomeFin: Integer read FTomeFin write FTomeFin;
    [EntityField]
    property HorsSerie: Boolean read FHorsSerie write FHorsSerie;
    [EntityField]
    property Integrale: Boolean read FIntegrale write FIntegrale;
    property Scenaristes: TObjectList<TAuteurAlbumLite> read FScenaristes;
    property Dessinateurs: TObjectList<TAuteurAlbumLite> read FDessinateurs;
    property Coloristes: TObjectList<TAuteurAlbumLite> read FColoristes;
    [EntityField('sujetalbum')]
    property Sujet: string read GetSujet write SetSujet;
    [EntityField('remarquesalbum')]
    property Notes: string read GetNotes write SetNotes;
    property Editions: TObjectList<TEditionFull> read FEditions;
    [EntityField]
    property Notation: Integer read FNotation write FNotation;
    property Univers: TObjectList<TUniversLite> read FUnivers;
    property UniversFull: TList<TUniversLite> read FUniversFull;

    // pour rétrocompatibilité pour les scripts
    property Titre: string read GetTitreAlbum write SetTitreAlbum;
  end;

  [Entity('parabd')]
  TParaBDFull = class(TObjetFull)
  strict private
    FAuteurs: TObjectList<TAuteurParaBDLite>;
    FStock: Boolean;
    FTitreParaBD: RAutoTrimString;
    FPrix: Currency;
    FAnneeCote: Integer;
    FGratuit: Boolean;
    FCategorieParaBD: ROption;
    FSerie: TSerieFull;
    FAnneeEdition: Integer;
    FDedicace: Boolean;
    FDescription: RLongString;
    FPrixCote: Currency;
    FNumerote: Boolean;
    FDateAchat: TDateTime;
    FOffert: Boolean;
    FUnivers: TObjectList<TUniversLite>;
    FUniversFull: TList<TUniversLite>;
    FPhotos: TObjectList<TPhotoLite>;
    FNotes: RLongString;
  private
    function Get_sDateAchat: string;
    procedure SetTitreParaBD(const Value: string);
    function GetID_Serie: RGUIDEx;
    function GetDescription: string;
    function GetNotes: string;
    function GetTitreParaBD: string;
    procedure SetDescription(const Value: string);
    procedure SetNotes(const Value: string);
  protected
    constructor Create; override;
    procedure DoClear; override;
  public
    destructor Destroy; override;

    function ChaineAffichage(AvecSerie: Boolean): string; overload; override;
    function ChaineAffichage(Simple, AvecSerie: Boolean): string; reintroduce; overload;
  published
    [PrimaryKey]
    property ID_ParaBD: RGUIDEx read GetID write SetID;
    property ID_Serie: RGUIDEx read GetID_Serie;
    [EntityField('annee')]
    property AnneeEdition: Integer read FAnneeEdition write FAnneeEdition;
    property CategorieParaBD: ROption read FCategorieParaBD write FCategorieParaBD;
    [EntityField]
    property AnneeCote: Integer read FAnneeCote write FAnneeCote;
    [EntityField]
    property TitreParaBD: string { [150] } read GetTitreParaBD write SetTitreParaBD;
    property Auteurs: TObjectList<TAuteurParaBDLite> read FAuteurs;
    [EntityField]
    property Description: string read GetDescription write SetDescription;
    [EntityField]
    property Notes: string read GetNotes write SetNotes;
    [EntityField('id_serie')]
    property Serie: TSerieFull read FSerie;
    [EntityField]
    property Prix: Currency read FPrix write FPrix;
    [EntityField]
    property PrixCote: Currency read FPrixCote write FPrixCote;
    [EntityField]
    property Dedicace: Boolean read FDedicace write FDedicace;
    [EntityField]
    property Numerote: Boolean read FNumerote write FNumerote;
    [EntityField]
    property Stock: Boolean read FStock write FStock;
    [EntityField]
    property Offert: Boolean read FOffert write FOffert;
    [EntityField]
    property Gratuit: Boolean read FGratuit write FGratuit;
    [EntityField]
    property DateAchat: TDateTime read FDateAchat write FDateAchat;
    property sDateAchat: string read Get_sDateAchat;
    property Univers: TObjectList<TUniversLite> read FUnivers;
    property UniversFull: TList<TUniversLite> read FUniversFull;
    property Photos: TObjectList<TPhotoLite> read FPhotos;
  end;

implementation

uses
  UMetadata;

{ TObjetFull }

function TObjetFull.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := '';
end;

procedure TObjetFull.DoClear;
begin
  inherited;
  RecInconnu := True;
  FAssociations.Clear;
end;

constructor TObjetFull.Create;
begin
  inherited;
  FAssociations := TStringList.Create;
end;

destructor TObjetFull.Destroy;
begin
  FAssociations.Free;
  inherited;
end;

{ TAlbumFull }

function TAlbumFull.ChaineAffichage(AvecSerie: Boolean): string;
begin
  Result := ChaineAffichage(False, AvecSerie);
end;

function TAlbumFull.ChaineAffichage(Simple, AvecSerie: Boolean): string;
begin
  Result := FormatTitreAlbum(Simple, AvecSerie, TitreAlbum, Serie.TitreSerie, Tome, TomeDebut, TomeFin, Integrale, HorsSerie);
end;

procedure TAlbumFull.DoClear;
begin
  inherited;
  FReadyToFusion := False;
  // le statut doit être conservé même si on fait un clear
  // FFusionneEditions := True;

  ID_Album := GUID_NULL;
  TitreAlbum := '';

  FComplet := False;
  MoisParution := 0;
  AnneeParution := 0;
  Tome := 0;
  TomeDebut := 0;
  TomeFin := 0;
  HorsSerie := False;
  Integrale := False;
  Notation := 900;

  Scenaristes.Clear;
  Dessinateurs.Clear;
  Coloristes.Clear;
  Sujet := '';
  Notes := '';
  Serie.Clear;
  Univers.Clear;
  UniversFull.Clear;

  Editions.Clear;
end;

constructor TAlbumFull.Create;
begin
  inherited;
  FFusionneEditions := True;
  FDefaultSearch := '';
  FScenaristes := TObjectList<TAuteurAlbumLite>.Create;
  FDessinateurs := TObjectList<TAuteurAlbumLite>.Create;
  FColoristes := TObjectList<TAuteurAlbumLite>.Create;
  FSerie := TFactories.getInstance<TSerieFull>;
  FEditions := TObjectList<TEditionFull>.Create;
  FUnivers := TObjectList<TUniversLite>.Create;
  FUniversFull := TList<TUniversLite>.Create;
end;

destructor TAlbumFull.Destroy;
begin
  FreeAndNil(FScenaristes);
  FreeAndNil(FDessinateurs);
  FreeAndNil(FColoristes);
  FreeAndNil(FSerie);
  FreeAndNil(FEditions);
  FreeAndNil(FUnivers);
  FreeAndNil(FUniversFull);
  inherited;
end;

function TAlbumFull.GetDefaultSearch: string;
begin
  Result := FDefaultSearch;
end;

function TAlbumFull.GetID_Serie: RGUIDEx;
begin
  Result := Serie.ID_Serie;
end;

function TAlbumFull.GetNotes: string;
begin
  Result := FNotes;
end;

function TAlbumFull.GetSerie: TSerieFull;
begin
  Result := FSerie;
end;

function TAlbumFull.GetSujet: string;
begin
  Result := FSujet;
end;

function TAlbumFull.GetTitreAlbum: string;
begin
  Result := FTitreAlbum;
end;

procedure TAlbumFull.SetDefaultSearch(const Value: string);
begin
  FDefaultSearch := Value;
end;

procedure TAlbumFull.SetNotes(const Value: string);
begin
  FNotes := Value;
end;

procedure TAlbumFull.SetSujet(const Value: string);
begin
  FSujet := Value;
end;

procedure TAlbumFull.SetTitreAlbum(const Value: string);
begin
  FTitreAlbum := Value.Substring(0, LengthTitreAlbum);
end;

{ TEditionFull }

procedure TEditionFull.DoClear;
begin
  inherited;
  ID_Edition := GUID_NULL;
  Editeur.Clear;
  Collection.Clear;
  Couvertures.Clear;
  Notes := '';
  AnneeEdition := 0;
  NombreDePages := 0;
  AnneeCote := 0;
  Prix := 0;
  PrixCote := 0;
  Couleur := True;
  VO := False;
  Dedicace := False;
  Stock := True;
  Prete := False;
  Offert := False;
  Gratuit := False;
  ISBN := '';
  DateAchat := -1;
  NumeroPerso := '';
end;

constructor TEditionFull.Create;
begin
  inherited;
  FEditeur := TFactories.getInstance<TEditeurFull>;
  FCollection := TFactories.getInstance<TCollectionLite>;
  FCouvertures := TObjectList<TCouvertureLite>.Create;
end;

destructor TEditionFull.Destroy;
begin
  FreeAndNil(FCouvertures);
  FreeAndNil(FEditeur);
  FreeAndNil(FCollection);
  inherited;
end;

function TEditionFull.GetID_Album: RGUIDEx;
begin
  Result := FID_Album;
end;

function TEditionFull.GetISBN: string;
begin
  Result := FISBN;
end;

function TEditionFull.GetNotes: string;
begin
  Result := FNotes;
end;

function TEditionFull.GetNumeroPerso: string;
begin
  Result := FNumeroPerso;
end;

function TEditionFull.Get_sDateAchat: string;
begin
  if Self.DateAchat > 0 then
    Result := DateToStr(Self.DateAchat)
  else
    Result := '';
end;

function TEditionFull.ChaineAffichage(dummy: Boolean = True): string;
begin
  if RecInconnu then
    Result := '*'
  else
    Result := '';
  AjoutString(Result, FormatTitre(Editeur.NomEditeur), ' ');
  AjoutString(Result, FormatTitre(Collection.NomCollection), ' ', '(', ')');
  AjoutString(Result, NonZero(IntToStr(AnneeEdition)), ' ', '[', ']');
  AjoutString(Result, FormatISBN(ISBN), ' - ', 'ISBN ');
end;

procedure TEditionFull.SetID_Album(const Value: RGUIDEx);
begin
  FID_Album := Value;
end;

procedure TEditionFull.SetISBN(const Value: string);
begin
  FISBN := Value;
end;

procedure TEditionFull.SetNotes(const Value: string);
begin
  FNotes := Value;
end;

procedure TEditionFull.SetNumeroPerso(const Value: string);
begin
  FNumeroPerso := Value.Substring(0, LengthNumPerso);
end;

{ TSerieFull }

function TSerieFull.ChaineAffichage: string;
begin
  Result := ChaineAffichage(False);
end;

function TSerieFull.ChaineAffichage(Simple: Boolean): string;
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

procedure TSerieFull.DoClear;
begin
  inherited;
  ID_Serie := GUID_NULL;
  TitreSerie := '';
  Albums.Clear;
  ParaBD.Clear;
  Genres.Clear;
  Sujet := '';
  Notes := '';
  Editeur.Clear;
  Collection.Clear;
  Scenaristes.Clear;
  Dessinateurs.Clear;
  Coloristes.Clear;
  Univers.Clear;
  Couleur.SetUndefined;
  VO.SetUndefined;
  Terminee.SetUndefined;
  SiteWeb := '';
  Complete := False;
  SuivreManquants := True;
  SuivreSorties := True;
  NbAlbums := 0;
  Notation := 900;
end;

constructor TSerieFull.Create;
begin
  inherited;
  FAlbums := TObjectList<TAlbumLite>.Create(True);
  FParaBD := TObjectList<TParaBDLite>.Create(True);
  FGenres := TStringList.Create;
  FEditeur := TFactories.getInstance<TEditeurFull>;
  FCollection := TFactories.getInstance<TCollectionLite>;
  FUnivers := TObjectList<TUniversLite>.Create(True);
  FScenaristes := TObjectList<TAuteurSerieLite>.Create(True);
  FDessinateurs := TObjectList<TAuteurSerieLite>.Create(True);
  FColoristes := TObjectList<TAuteurSerieLite>.Create(True);
end;

destructor TSerieFull.Destroy;
begin
  FreeAndNil(FAlbums);
  FreeAndNil(FParaBD);
  FreeAndNil(FGenres);
  FreeAndNil(FEditeur);
  FreeAndNil(FCollection);
  FreeAndNil(FScenaristes);
  FreeAndNil(FDessinateurs);
  FreeAndNil(FColoristes);
  FreeAndNil(FUnivers);
  inherited;
end;

function TSerieFull.GetID_Collection: RGUIDEx;
begin
  Result := Collection.ID;
end;

function TSerieFull.GetID_Editeur: RGUIDEx;
begin
  Result := Editeur.ID_Editeur;
end;

function TSerieFull.GetNotes: string;
begin
  Result := FNotes;
end;

function TSerieFull.GetSiteWeb: string;
begin
  Result := FSiteWeb;
end;

function TSerieFull.GetSujet: string;
begin
  Result := FSujet;
end;

function TSerieFull.GetTitreSerie: string;
begin
  Result := FTitreSerie;
end;

procedure TSerieFull.SetNotes(const Value: string);
begin
  FNotes := Value;
end;

procedure TSerieFull.SetSiteWeb(const Value: string);
begin
  FSiteWeb := Value.Substring(0, LengthURL);
end;

procedure TSerieFull.SetSujet(const Value: string);
begin
  FSujet := Value;
end;

procedure TSerieFull.SetTitreSerie(const Value: string);
begin
  FTitreSerie := Value.Substring(0, LengthTitreSerie);
end;

{ TEditeurFull }

procedure TEditeurFull.DoClear;
begin
  inherited;
  ID_Editeur := GUID_NULL;
  FNomEditeur := '';
  FSiteWeb := '';
end;

function TEditeurFull.GetNomEditeur: string;
begin
  Result := FNomEditeur;
end;

function TEditeurFull.GetSiteWeb: string;
begin
  Result := FSiteWeb;
end;

procedure TEditeurFull.SetNomEditeur(const Value: string);
begin
  FNomEditeur := Value.Substring(0, LengthNomEditeur);
end;

procedure TEditeurFull.SetSiteWeb(const Value: string);
begin
  FSiteWeb := Value.Substring(0, LengthURL);
end;

{ TAuteurFull }

function TAuteurFull.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := FormatTitre(NomAuteur);
end;

procedure TAuteurFull.DoClear;
begin
  inherited;
  Series.Clear;
end;

function TAuteurFull.GetBiographie: string;
begin
  Result := FBiographie;
end;

function TAuteurFull.GetNomAuteur: string;
begin
  Result := FNomAuteur;
end;

function TAuteurFull.GetSiteWeb: string;
begin
  Result := FSiteWeb;
end;

constructor TAuteurFull.Create;
begin
  inherited;
  FSeries := TObjectList<TSerieFull>.Create(True);
end;

destructor TAuteurFull.Destroy;
begin
  FreeAndNil(FSeries);
  inherited;
end;

procedure TAuteurFull.SetBiographie(const Value: string);
begin
  FBiographie := Value;
end;

procedure TAuteurFull.SetNomAuteur(const Value: string);
begin
  FNomAuteur := Value.Substring(0, LengthNomAuteur);
end;

procedure TAuteurFull.SetSiteWeb(const Value: string);
begin
  FSiteWeb := Value.Substring(0, LengthURL);
end;

{ TParaBDFull }

function TParaBDFull.ChaineAffichage(AvecSerie: Boolean): string;
begin
  Result := ChaineAffichage(False, AvecSerie);
end;

function TParaBDFull.ChaineAffichage(Simple, AvecSerie: Boolean): string;
var
  s: string;
begin
  if Simple then
    Result := TitreParaBD
  else
    Result := FormatTitre(TitreParaBD);
  s := '';
  if AvecSerie then
    if Result = '' then
      Result := FormatTitre(Serie.TitreSerie)
    else
      AjoutString(s, FormatTitre(Serie.TitreSerie), ' - ');
  AjoutString(s, CategorieParaBD.Caption, ' - ');
  if Result = '' then
    Result := s
  else
    AjoutString(Result, s, ' ', '(', ')');
end;

procedure TParaBDFull.DoClear;
begin
  inherited;
  ID_ParaBD := GUID_NULL;

  AnneeEdition := 0;
  AnneeCote := 0;
  TitreParaBD := '';
  Auteurs.Clear;
  Description := '';
  Serie.Clear;
  Prix := 0;
  PrixCote := 0;
  Dedicace := False;
  Numerote := False;
  Stock := True;
  Offert := False;
  Gratuit := False;
  DateAchat := -1;
  Univers.Clear;
  UniversFull.Clear;
  Photos.Clear;
end;

constructor TParaBDFull.Create;
begin
  inherited;
  FAuteurs := TObjectList<TAuteurParaBDLite>.Create;
  FSerie := TFactories.getInstance<TSerieFull>;
  FUnivers := TObjectList<TUniversLite>.Create;
  FUniversFull := TList<TUniversLite>.Create;
  FPhotos := TObjectList<TPhotoLite>.Create;
end;

destructor TParaBDFull.Destroy;
begin
  FreeAndNil(FAuteurs);
  FreeAndNil(FSerie);
  FreeAndNil(FPhotos);
  FreeAndNil(FUnivers);
  FreeAndNil(FUniversFull);
  inherited;
end;

function TParaBDFull.GetDescription: string;
begin
  Result := FDescription;
end;

function TParaBDFull.GetID_Serie: RGUIDEx;
begin
  Result := Serie.ID_Serie;
end;

function TParaBDFull.GetNotes: string;
begin
  Result := FNotes;
end;

function TParaBDFull.GetTitreParaBD: string;
begin
  Result := FTitreParaBD;
end;

function TParaBDFull.Get_sDateAchat: string;
begin
  if Self.DateAchat > 0 then
    Result := DateToStr(Self.DateAchat)
  else
    Result := '';
end;

procedure TParaBDFull.SetDescription(const Value: string);
begin
  FDescription := Value;
end;

procedure TParaBDFull.SetNotes(const Value: string);
begin
  FNotes := Value;
end;

procedure TParaBDFull.SetTitreParaBD(const Value: string);
begin
  FTitreParaBD := Value.Substring(0, LengthTitreParaBD);
end;

{ TCollectionFull }

procedure TCollectionFull.DoClear;
begin
  inherited;
  Editeur.Clear;
end;

constructor TCollectionFull.Create;
begin
  inherited;
  FEditeur := TFactories.getInstance<TEditeurLite>;
end;

destructor TCollectionFull.Destroy;
begin
  FreeAndNil(FEditeur);
  inherited;
end;

function TCollectionFull.GetID_Editeur: RGUIDEx;
begin
  Result := Editeur.ID;
end;

function TCollectionFull.GetNomCollection: string;
begin
  Result := FNomCollection;
end;

procedure TCollectionFull.SetNomCollection(const Value: string);
begin
  FNomCollection := Value.Substring(0, LengthNomCollection);
end;

{ TUniversFull }

function TUniversFull.ChaineAffichage(dummy: Boolean): string;
begin
  Result := FormatTitre(NomUnivers);
end;

procedure TUniversFull.DoClear;
begin
  inherited;
  UniversParent.Clear;
end;

constructor TUniversFull.Create;
begin
  inherited;
  FUniversParent := TFactories.getInstance<TUniversLite>;
end;

destructor TUniversFull.Destroy;
begin
  FreeAndNil(FUniversParent);
  inherited;
end;

function TUniversFull.GetNomUnivers: string;
begin
  Result := FNomUnivers;
end;

function TUniversFull.GetDescription: string;
begin
  Result := FDescription;
end;

function TUniversFull.GetID_UniversParent: RGUIDEx;
begin
  Result := UniversParent.ID;
end;

function TUniversFull.GetSiteWeb: string;
begin
  Result := FSiteWeb;
end;

procedure TUniversFull.SetDescription(const Value: string);
begin
  FDescription := Value;
end;

procedure TUniversFull.SetNomUnivers(const Value: string);
begin
  FNomUnivers := Value.Substring(0, LengthNomUnivers);
end;

procedure TUniversFull.SetSiteWeb(const Value: string);
begin
  FSiteWeb := Value.Substring(0, LengthURL);
end;

end.
