unit Entities.Full;

interface

uses
  SysUtils, Windows, Classes, Dialogs, Entities.Lite, Commun, CommonConst, DateUtils, Generics.Collections,
  Generics.Defaults, System.Generics.Collections, Entities.Common, Vcl.StdCtrls;

type
  PAutoTrimString = ^RAutoTrimString;

  RAutoTrimString = record
  private
    Value: string;
  public
    class operator Implicit(a: string): RAutoTrimString;
    class operator Implicit(a: RAutoTrimString): string;
    class operator Equal(a, b: RAutoTrimString): Boolean;
    class operator NotEqual(a, b: RAutoTrimString): Boolean;
  end;

  PLongString = ^RLongString;

  RLongString = record
  private
    Value: string;
  public
    class operator Implicit(a: string): RLongString;
    class operator Implicit(a: RLongString): string;
  end;

  PTriStateValue = ^RTriStateValue;

  RTriStateValue = record
  private
    Value: Integer;
    function IsUndefined: Boolean;
    function GetAsBoolean(DefaultIfUndefined: Boolean): Boolean;
  public
    class operator Implicit(a: Boolean): RTriStateValue;
    class operator Implicit(a: RTriStateValue): Integer;
    class operator Implicit(a: TCheckBoxState): RTriStateValue;
    class operator Implicit(a: RTriStateValue): TCheckBoxState;
    class operator Equal(a, b: RTriStateValue): Boolean;
    class operator NotEqual(a, b: RTriStateValue): Boolean;

    class function FromInteger(a: Integer): RTriStateValue; static;
    class function Default: RTriStateValue; static;

    procedure SetUndefined;
    property Undefined: Boolean read IsUndefined;
    // des propriétés plutôt que des Implicit pour declencher des erreurs de compilation
    property AsBoolean[DefaultIfUndefined: Boolean]: Boolean read GetAsBoolean;
  end;

  POption = ^ROption;

  ROption = record
    Value: Integer;
    Caption: RAutoTrimString;
    class operator Implicit(a: ROption): Integer;
    class operator Implicit(a: Integer): ROption;
  end;

function MakeOption(Value: Integer; const Caption: RAutoTrimString): ROption; inline;

type
  TObjetFullClass = class of TObjetFull;

  TObjetFull = class(TDBEntity)
  strict private
    FAssociations: TStringList;
  protected
    constructor Create; override;
  public
    RecInconnu: Boolean;
    destructor Destroy; override;
    procedure Clear; override;
    function ChaineAffichage(dummy: Boolean = True): string; virtual;
  published
    property Associations: TStringList read FAssociations;
  end;

  TListFull = class(TEntity)
  end;

  TEditeurFull = class(TObjetFull)
  strict private
    FNomEditeur: RAutoTrimString;
    FSiteWeb: RAutoTrimString;
    procedure SetNomEditeur(const Value: RAutoTrimString); inline;
    procedure SetSiteWeb(const Value: RAutoTrimString); inline;
  public
    procedure Clear; override;
  published
    property ID_Editeur: RGUIDEx read GetID write SetID;
    property NomEditeur: RAutoTrimString read FNomEditeur write SetNomEditeur;
    property SiteWeb: RAutoTrimString read FSiteWeb write SetSiteWeb;
  end;

  TCollectionFull = class(TObjetFull)
  strict private
    FNomCollection: RAutoTrimString;
    FEditeur: TEditeurLite;
    function GetID_Editeur: RGUIDEx; inline;
    procedure SetNomCollection(const Value: RAutoTrimString); inline;
  protected
    constructor Create; override;
  public
    destructor Destroy; override;
    procedure Clear; override;
  published
    property ID_Collection: RGUIDEx read GetID write SetID;
    property NomCollection: RAutoTrimString read FNomCollection write SetNomCollection;
    property Editeur: TEditeurLite read FEditeur;
    property ID_Editeur: RGUIDEx read GetID_Editeur;
  end;

  TUniversFull = class(TObjetFull)
  strict private
    FNomUnivers: RAutoTrimString;
    FUniversParent: TUniversLite;
    FDescription: RLongString;
    FSiteWeb: RAutoTrimString;
    procedure SetNomUnivers(const Value: RAutoTrimString); inline;
    function GetID_UniversParent: RGUIDEx; inline;
    procedure SetSiteWeb(const Value: RAutoTrimString);
  protected
    constructor Create; override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function ChaineAffichage(dummy: Boolean = True): string; override;
  published
    property ID_Univers: RGUIDEx read GetID write SetID;
    property NomUnivers: RAutoTrimString read FNomUnivers write SetNomUnivers;
    property SiteWeb: RAutoTrimString read FSiteWeb write SetSiteWeb;
    property Description: RLongString read FDescription write FDescription;
    property UniversParent: TUniversLite read FUniversParent;
    property ID_UniversParent: RGUIDEx read GetID_UniversParent;
  end;

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
    FColoristes: TObjectList<TAuteurLite>;
    FComplete: Boolean;
    FScenaristes: TObjectList<TAuteurLite>;
    FSuivreSorties: Boolean;
    FCouleur: RTriStateValue;
    FDessinateurs: TObjectList<TAuteurLite>;
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
    function GetID_Editeur: RGUIDEx; inline;
    function GetID_Collection: RGUIDEx; inline;
    procedure SetTitreSerie(const Value: RAutoTrimString); inline;
    procedure SetSiteWeb(const Value: RAutoTrimString); inline;
  protected
    constructor Create; override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function ChaineAffichage: string; reintroduce; overload;
    function ChaineAffichage(Simple: Boolean): string; overload; override;
  published
    property ID_Serie: RGUIDEx read GetID write SetID;
    property ID_Editeur: RGUIDEx read GetID_Editeur;
    property ID_Collection: RGUIDEx read GetID_Collection;
    property TitreSerie: RAutoTrimString read FTitreSerie write SetTitreSerie;
    property Terminee: RTriStateValue read FTerminee write FTerminee;
    property Genres: TStringList read FGenres;
    property Sujet: RLongString read FSujet write FSujet;
    property Notes: RLongString read FNotes write FNotes;
    property Editeur: TEditeurFull read FEditeur;
    property Collection: TCollectionLite read FCollection;
    property SiteWeb: RAutoTrimString read FSiteWeb write SetSiteWeb;
    property Complete: Boolean read FComplete write FComplete;
    property SuivreManquants: Boolean read FSuivreManquants write FSuivreManquants;
    property SuivreSorties: Boolean read FSuivreSorties write FSuivreSorties;
    property NbAlbums: Integer read FNbAlbums write FNbAlbums;
    property Albums: TObjectList<TAlbumLite> read FAlbums;
    property ParaBD: TObjectList<TParaBDLite> read FParaBD;
    property Scenaristes: TObjectList<TAuteurLite> read FScenaristes;
    property Dessinateurs: TObjectList<TAuteurLite> read FDessinateurs;
    property Coloristes: TObjectList<TAuteurLite> read FColoristes;
    property VO: RTriStateValue read FVO write FVO;
    property Couleur: RTriStateValue read FCouleur write FCouleur;
    property Etat: ROption read FEtat write FEtat;
    property Reliure: ROption read FReliure write FReliure;
    property TypeEdition: ROption read FTypeEdition write FTypeEdition;
    property FormatEdition: ROption read FFormatEdition write FFormatEdition;
    property Orientation: ROption read FOrientation write FOrientation;
    property SensLecture: ROption read FSensLecture write FSensLecture;
    property Notation: Integer read FNotation write FNotation;
    property Univers: TObjectList<TUniversLite> read FUnivers;

    // pour rétrocompatibilité pour les scripts
    property Titre: RAutoTrimString read FTitreSerie write SetTitreSerie;
  end;

  TAuteurFull = class(TObjetFull)
  strict private
    FBiographie: RLongString;
    FNomAuteur: RAutoTrimString;
    FSiteWeb: RAutoTrimString;
    FSeries: TObjectList<TSerieFull>;
    procedure SetNomAuteur(const Value: RAutoTrimString); inline;
    procedure SetSiteWeb(const Value: RAutoTrimString); inline;
  protected
    constructor Create; override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function ChaineAffichage(dummy: Boolean = True): string; override;
  published
    property ID_Auteur: RGUIDEx read GetID write SetID;
    property NomAuteur: RAutoTrimString read FNomAuteur write SetNomAuteur;
    property SiteWeb: RAutoTrimString read FSiteWeb write SetSiteWeb;
    property Biographie: RLongString read FBiographie write FBiographie;
    property Series: TObjectList<TSerieFull> read FSeries;
  end;

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
    FID_Album: RGUIDEx;
    FVO: Boolean;
    function Get_sDateAchat: string; inline;
    procedure SetNumeroPerso(const Value: RAutoTrimString); inline;
  protected
    constructor Create; override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function ChaineAffichage(dummy: Boolean = True): string; override;
  published
    property ID_Edition: RGUIDEx read GetID write SetID;
    property ID_Album: RGUIDEx read FID_Album write FID_Album;
    property Editeur: TEditeurFull read FEditeur;
    property Collection: TCollectionLite read FCollection;
    property TypeEdition: ROption read FTypeEdition write FTypeEdition;
    property AnneeEdition: Integer read FAnneeEdition write FAnneeEdition;
    property Etat: ROption read FEtat write FEtat;
    property Reliure: ROption read FReliure write FReliure;
    property NombreDePages: Integer read FNombreDePages write FNombreDePages;
    property FormatEdition: ROption read FFormatEdition write FFormatEdition;
    property Orientation: ROption read FOrientation write FOrientation;
    property AnneeCote: Integer read FAnneeCote write FAnneeCote;
    property SensLecture: ROption read FSensLecture write FSensLecture;
    property Prix: Currency read FPrix write FPrix;
    property PrixCote: Currency read FPrixCote write FPrixCote;
    property Couleur: Boolean read FCouleur write FCouleur;
    property VO: Boolean read FVO write FVO;
    property Dedicace: Boolean read FDedicace write FDedicace;
    property Stock: Boolean read FStock write FStock;
    property Prete: Boolean read FPrete write FPrete;
    property Offert: Boolean read FOffert write FOffert;
    property Gratuit: Boolean read FGratuit write FGratuit;
    property ISBN: RAutoTrimString read FISBN write FISBN;
    property DateAchat: TDateTime read FDateAchat write FDateAchat;
    property sDateAchat: string read Get_sDateAchat;
    property Notes: RLongString read FNotes write FNotes;
    property NumeroPerso: RAutoTrimString { [25] } read FNumeroPerso write SetNumeroPerso;
    property Couvertures: TObjectList<TCouvertureLite> read FCouvertures;
  end;

  TAlbumFull = class(TObjetFull)
  strict private
    FTitreAlbum: RAutoTrimString;
    FSerie: TSerieFull;
    FSujet: RLongString;
    FHorsSerie: Boolean;
    FMoisParution: Integer;
    FTomeFin: Integer;
    FColoristes: TObjectList<TAuteurLite>;
    FNotes: RLongString;
    FAnneeParution: Integer;
    FScenaristes: TObjectList<TAuteurLite>;
    FIntegrale: Boolean;
    FDessinateurs: TObjectList<TAuteurLite>;
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
    function GetID_Serie: RGUIDEx; inline;
    procedure SetTitreAlbum(const Value: RAutoTrimString); inline;
  private
    FReadyToImport: Boolean;
    function GetDefaultSearch: string;
    procedure SetDefaultSearch(const Value: string);
    function GetSerie: TSerieFull;
  protected
    constructor Create; override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function ChaineAffichage(AvecSerie: Boolean): string; overload; override;
    function ChaineAffichage(Simple, AvecSerie: Boolean): string; reintroduce; overload;

    property ReadyToImport: Boolean read FReadyToImport write FReadyToImport;
    property ReadyToFusion: Boolean read FReadyToFusion write FReadyToFusion;
    property FusionneEditions: Boolean read FFusionneEditions write FFusionneEditions;
    property DefaultSearch: string read GetDefaultSearch write SetDefaultSearch;
  published
    property Complet: Boolean read FComplet write FComplet;
    property ID_Album: RGUIDEx read GetID write SetID;
    property ID_Serie: RGUIDEx read GetID_Serie;
    property TitreAlbum: RAutoTrimString read FTitreAlbum write SetTitreAlbum;
    property Serie: TSerieFull read GetSerie;
    property MoisParution: Integer read FMoisParution write FMoisParution;
    property AnneeParution: Integer read FAnneeParution write FAnneeParution;
    property Tome: Integer read FTome write FTome;
    property TomeDebut: Integer read FTomeDebut write FTomeDebut;
    property TomeFin: Integer read FTomeFin write FTomeFin;
    property HorsSerie: Boolean read FHorsSerie write FHorsSerie;
    property Integrale: Boolean read FIntegrale write FIntegrale;
    property Scenaristes: TObjectList<TAuteurLite> read FScenaristes;
    property Dessinateurs: TObjectList<TAuteurLite> read FDessinateurs;
    property Coloristes: TObjectList<TAuteurLite> read FColoristes;
    property Sujet: RLongString read FSujet write FSujet;
    property Notes: RLongString read FNotes write FNotes;
    property Editions: TObjectList<TEditionFull> read FEditions;
    property Notation: Integer read FNotation write FNotation;
    property Univers: TObjectList<TUniversLite> read FUnivers;
    property UniversFull: TList<TUniversLite> read FUniversFull;

    // pour rétrocompatibilité pour les scripts
    property Titre: RAutoTrimString read FTitreAlbum write SetTitreAlbum;
  end;

  TParaBDFull = class(TObjetFull)
  strict private
    FAuteurs: TObjectList<TAuteurLite>;
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
    function Get_sDateAchat: string;
    procedure SetTitreParaBD(const Value: RAutoTrimString); inline;
  private
    function GetID_Serie: RGUIDEx;
  protected
    constructor Create; override;
  public
    destructor Destroy; override;
    procedure Clear; override;

    function ChaineAffichage(AvecSerie: Boolean): string; overload; override;
    function ChaineAffichage(Simple, AvecSerie: Boolean): string; reintroduce; overload;
  published
    property ID_ParaBD: RGUIDEx read GetID write SetID;
    property ID_Serie: RGUIDEx read GetID_Serie;
    property AnneeEdition: Integer read FAnneeEdition write FAnneeEdition;
    property CategorieParaBD: ROption read FCategorieParaBD write FCategorieParaBD;
    property AnneeCote: Integer read FAnneeCote write FAnneeCote;
    property TitreParaBD: RAutoTrimString { [150] } read FTitreParaBD write SetTitreParaBD;
    property Auteurs: TObjectList<TAuteurLite> read FAuteurs;
    property Description: RLongString read FDescription write FDescription;
    property Serie: TSerieFull read FSerie;
    property Prix: Currency read FPrix write FPrix;
    property PrixCote: Currency read FPrixCote write FPrixCote;
    property Dedicace: Boolean read FDedicace write FDedicace;
    property Numerote: Boolean read FNumerote write FNumerote;
    property Stock: Boolean read FStock write FStock;
    property Offert: Boolean read FOffert write FOffert;
    property Gratuit: Boolean read FGratuit write FGratuit;
    property DateAchat: TDateTime read FDateAchat write FDateAchat;
    property sDateAchat: string read Get_sDateAchat;
    property Univers: TObjectList<TUniversLite> read FUnivers;
    property UniversFull: TList<TUniversLite> read FUniversFull;
    property Photos: TObjectList<TPhotoLite> read FPhotos;
  end;

implementation

uses
  UMetadata, Entities.FactoriesFull, Entities.FactoriesLite;

{ ROption }

function MakeOption(Value: Integer; const Caption: RAutoTrimString): ROption;
begin
  Result.Value := Value;
  Result.Caption := Caption;
end;

{ AutoTrimString }

class operator RAutoTrimString.Implicit(a: string): RAutoTrimString;
begin
  Result.Value := a.Trim;
end;

class operator RAutoTrimString.Equal(a, b: RAutoTrimString): Boolean;
begin
  Result := CompareStr(a.Value, b.Value) = 0;
end;

class operator RAutoTrimString.Implicit(a: RAutoTrimString): string;
begin
  Result := a.Value;
end;

class operator RAutoTrimString.NotEqual(a, b: RAutoTrimString): Boolean;
begin
  Result := CompareStr(a.Value, b.Value) <> 0;
end;

{ LongString }

class operator RLongString.Implicit(a: string): RLongString;
begin
  Result.Value := a.Trim([' ', #13, #10]);
end;

class operator RLongString.Implicit(a: RLongString): string;
begin
  Result := a.Value;
end;

{ RTriStateValue }

class function RTriStateValue.Default: RTriStateValue;
begin
  Result.SetUndefined;
end;

class operator RTriStateValue.Equal(a, b: RTriStateValue): Boolean;
begin
  Result := a.value = b.value;
end;

class function RTriStateValue.FromInteger(a: Integer): RTriStateValue;
begin
  if (a = -1) or (a in [0 .. 1]) then
    Result.Value := a
  else
    Result.SetUndefined;
end;

class operator RTriStateValue.Implicit(a: Boolean): RTriStateValue;
begin
  if a then
    Result.Value := 1
  else
    Result.Value := 0;
end;

class operator RTriStateValue.Implicit(a: RTriStateValue): Integer;
begin
  Result := a.Value;
end;

function RTriStateValue.IsUndefined: Boolean;
begin
  Result := Value = -1;
end;

class operator RTriStateValue.NotEqual(a, b: RTriStateValue): Boolean;
begin
  Result := not (a = b);
end;

procedure RTriStateValue.SetUndefined;
begin
  Value := -1;
end;

class operator RTriStateValue.Implicit(a: TCheckBoxState): RTriStateValue;
begin
  case a of
    cbUnchecked:
      Result := False;
    cbChecked:
      Result := True;
    cbGrayed:
      Result.SetUndefined;
  end;
end;

function RTriStateValue.GetAsBoolean(DefaultIfUndefined: Boolean): Boolean;
begin
  if Undefined then
    Result := DefaultIfUndefined
  else
    Result := Value = 1;
end;

class operator RTriStateValue.Implicit(a: RTriStateValue): TCheckBoxState;
begin
  if a.Value = 1 then
    Result := cbChecked
  else if a.Value = 0 then
    Result := cbUnchecked
  else
    Result := cbGrayed;
end;

{ ROption }

class operator ROption.Implicit(a: ROption): Integer;
begin
  Result := a.Value;
end;

class operator ROption.Implicit(a: Integer): ROption;
begin
  Result.Value := a;
  Result.Caption := '';
end;

{ TObjetFull }

function TObjetFull.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := '';
end;

procedure TObjetFull.Clear;
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

procedure TAlbumFull.Clear;
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
  Serie.DoClear;
  Univers.Clear;
  UniversFull.Clear;

  Editions.Clear;
end;

constructor TAlbumFull.Create;
begin
  inherited;
  FFusionneEditions := True;
  FDefaultSearch := '';
  FScenaristes := TObjectList<TAuteurLite>.Create;
  FDessinateurs := TObjectList<TAuteurLite>.Create;
  FColoristes := TObjectList<TAuteurLite>.Create;
  FSerie := TFactorySerieFull.getInstance;
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

function TAlbumFull.GetSerie: TSerieFull;
begin
  Result := FSerie;
end;

procedure TAlbumFull.SetDefaultSearch(const Value: string);
begin
  FDefaultSearch := Value;
end;

procedure TAlbumFull.SetTitreAlbum(const Value: RAutoTrimString);
begin
  FTitreAlbum := Copy(Value, 1, LengthTitreAlbum);
end;

{ TEditionFull }

procedure TEditionFull.Clear;
begin
  inherited;
  ID_Edition := GUID_NULL;
  Editeur.DoClear;
  Collection.DoClear;
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
  FEditeur := TFactoryEditeurFull.getInstance;
  FCollection := TFactoryCollectionLite.getInstance;
  FCouvertures := TObjectList<TCouvertureLite>.Create;
end;

destructor TEditionFull.Destroy;
begin
  FreeAndNil(FCouvertures);
  FreeAndNil(FEditeur);
  FreeAndNil(FCollection);
  inherited;
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

procedure TEditionFull.SetNumeroPerso(const Value: RAutoTrimString);
begin
  FNumeroPerso := Copy(Value, 1, LengthNumPerso);
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

procedure TSerieFull.Clear;
begin
  inherited;
  ID_Serie := GUID_NULL;
  TitreSerie := '';
  Albums.Clear;
  ParaBD.Clear;
  Genres.Clear;
  Sujet := '';
  Notes := '';
  Editeur.DoClear;
  Collection.DoClear;
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
  FEditeur := TFactoryEditeurFull.getInstance;
  FCollection := TFactoryCollectionLite.getInstance;
  FUnivers := TObjectList<TUniversLite>.Create(True);
  FScenaristes := TObjectList<TAuteurLite>.Create(True);
  FDessinateurs := TObjectList<TAuteurLite>.Create(True);
  FColoristes := TObjectList<TAuteurLite>.Create(True);
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

procedure TSerieFull.SetSiteWeb(const Value: RAutoTrimString);
begin
  FSiteWeb := Copy(Value, 1, LengthURL);
end;

procedure TSerieFull.SetTitreSerie(const Value: RAutoTrimString);
begin
  FTitreSerie := Copy(Value, 1, LengthTitreSerie);
end;

{ TEditeurFull }

procedure TEditeurFull.Clear;
begin
  inherited;
  ID_Editeur := GUID_NULL;
  FNomEditeur := '';
  FSiteWeb := '';
end;

procedure TEditeurFull.SetNomEditeur(const Value: RAutoTrimString);
begin
  FNomEditeur := Copy(Value, 1, LengthNomEditeur);
end;

procedure TEditeurFull.SetSiteWeb(const Value: RAutoTrimString);
begin
  FSiteWeb := Copy(Value, 1, LengthURL);
end;

{ TAuteurFull }

function TAuteurFull.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := FormatTitre(NomAuteur);
end;

procedure TAuteurFull.Clear;
begin
  inherited;
  Series.Clear;
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

procedure TAuteurFull.SetNomAuteur(const Value: RAutoTrimString);
begin
  FNomAuteur := Copy(Value, 1, LengthNomAuteur);
end;

procedure TAuteurFull.SetSiteWeb(const Value: RAutoTrimString);
begin
  FSiteWeb := Copy(Value, 1, LengthURL);
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

procedure TParaBDFull.Clear;
begin
  inherited;
  ID_ParaBD := GUID_NULL;

  AnneeEdition := 0;
  AnneeCote := 0;
  TitreParaBD := '';
  Auteurs.Clear;
  Description := '';
  Serie.DoClear;
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
  FAuteurs := TObjectList<TAuteurLite>.Create;
  FSerie := TFactorySerieFull.getInstance;
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

function TParaBDFull.GetID_Serie: RGUIDEx;
begin
  Result := Serie.ID_Serie;
end;

function TParaBDFull.Get_sDateAchat: string;
begin
  if Self.DateAchat > 0 then
    Result := DateToStr(Self.DateAchat)
  else
    Result := '';
end;

procedure TParaBDFull.SetTitreParaBD(const Value: RAutoTrimString);
begin
  FTitreParaBD := Copy(Value, 1, LengthTitreParaBD);
end;

{ TCollectionFull }

procedure TCollectionFull.Clear;
begin
  inherited;
  Editeur.DoClear;
end;

constructor TCollectionFull.Create;
begin
  inherited;
  FEditeur := TFactoryEditeurLite.getInstance;
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

procedure TCollectionFull.SetNomCollection(const Value: RAutoTrimString);
begin
  FNomCollection := Copy(Value, 1, LengthNomCollection);
end;

{ TUniversFull }

function TUniversFull.ChaineAffichage(dummy: Boolean): string;
begin
  Result := FormatTitre(NomUnivers);
end;

procedure TUniversFull.Clear;
begin
  inherited;
  UniversParent.DoClear;
end;

constructor TUniversFull.Create;
begin
  inherited;
  FUniversParent := TFactoryUniversLite.getInstance;
end;

destructor TUniversFull.Destroy;
begin
  FreeAndNil(FUniversParent);
  inherited;
end;

function TUniversFull.GetID_UniversParent: RGUIDEx;
begin
  Result := UniversParent.ID;
end;

procedure TUniversFull.SetNomUnivers(const Value: RAutoTrimString);
begin
  FNomUnivers := Copy(Value, 1, LengthNomUnivers);
end;

procedure TUniversFull.SetSiteWeb(const Value: RAutoTrimString);
begin
  FSiteWeb := Value;
end;

end.
