unit LoadComplet;

interface

uses SysUtils, Windows, Classes, Dialogs, TypeRec, Commun, CommonConst, UdmPrinc, UIB, DateUtils, ListOfTypeRec, Contnrs, UChampsRecherche,
  Generics.Collections, Generics.Defaults, VirtualTree;

type
  ROption = record
    Value: Integer;
    Caption: string;
  end;

function MakeOption(Value: Integer; const Caption: string): ROption; inline;

type
  TBaseComplet = class(TPersistent)
  protected
    class procedure WriteString(Stream: TStream; const Chaine: string);
    class procedure WriteStringLN(Stream: TStream; const Chaine: string);
  public
    constructor Create; virtual;
    procedure Fill(const Reference: TGUID); virtual;
    procedure BeforeDestruction; override;
    procedure Clear; virtual;
    procedure PrepareInstance; virtual;
    procedure WriteXMLToStream(Stream: TStream); virtual;
  end;

  TObjetComplet = class(TBaseComplet)
  strict private
    FAssociations: TStringList;
  private
    FID: TGUID;
  public
    RecInconnu: Boolean;
    constructor Create(const Reference: TGUID); reintroduce; overload; virtual;
    destructor Destroy; override;
    procedure Clear; override;
    procedure PrepareInstance; override;
    procedure SaveToDatabase; overload;
    procedure SaveToDatabase(UseTransaction: TUIBTransaction); overload; virtual;
    procedure New(ClearInstance: Boolean = True);
    function ChaineAffichage(dummy: Boolean = True): string; virtual;
    procedure FillAssociations(TypeData: TVirtualMode);
    procedure SaveAssociations(TypeData: TVirtualMode; const ParentID: TGUID);
  published
    property ID: TGUID read FID;
    property Associations: TStringList read FAssociations;
  end;

  TInfoComplet = class(TBaseComplet)
  end;

  TListComplet = class(TBaseComplet)
  end;

  TSrcEmprunt = (seTous, seAlbum, seEmprunteur);
  TSensEmprunt = (ssTous, ssPret, ssRetour);

  TEmpruntsComplet = class(TListComplet)
  strict private
    FNBEmprunts: Integer;
    FEmprunts: TObjectList<TEmprunt>;
  public
    constructor Create(const Reference: TGUID; Source: TSrcEmprunt = seTous; Sens: TSensEmprunt = ssTous; Apres: TDateTime = -1;
      Avant: TDateTime = -1; EnCours: Boolean = False; Stock: Boolean = False); reintroduce; overload;
    destructor Destroy; override;
    procedure Fill(const Reference: TGUID; Source: TSrcEmprunt = seTous; Sens: TSensEmprunt = ssTous; Apres: TDateTime = -1; Avant: TDateTime = -1;
      EnCours: Boolean = False; Stock: Boolean = False); reintroduce;
    procedure Clear; override;
    procedure PrepareInstance; override;
  published
    property Emprunts: TObjectList<TEmprunt>read FEmprunts;
    property NBEmprunts: Integer read FNBEmprunts write FNBEmprunts;
  end;

  TEditeurComplet = class(TObjetComplet)
  strict private
    FNomEditeur: string;
    FSiteWeb: string;
    procedure SetNomEditeur(const Value: string); inline;
    procedure SetSiteWeb(const Value: string); inline;
  public
    procedure Fill(const Reference: TGUID); override;
    procedure Clear; override;
    procedure SaveToDatabase(UseTransaction: TUIBTransaction); override;
  published
    property ID_Editeur: TGUID read FID write FID;
    property NomEditeur: string read FNomEditeur write SetNomEditeur;
    property SiteWeb: string read FSiteWeb write SetSiteWeb;
  end;

  TCollectionComplete = class(TObjetComplet)
  strict private
    FNomCollection: string;
    FEditeur: TEditeur;
    function GetID_Editeur: TGUID; inline;
    procedure SetID_Editeur(const Value: TGUID); inline;
    procedure SetNomCollection(const Value: string); inline;
  public
    destructor Destroy; override;
    procedure Fill(const Reference: TGUID); override;
    procedure Clear; override;
    procedure PrepareInstance; override;
    procedure SaveToDatabase(UseTransaction: TUIBTransaction); override;
  published
    property ID_Collection: TGUID read FID write FID;
    property NomCollection: string read FNomCollection write SetNomCollection;
    property Editeur: TEditeur read FEditeur;
    property ID_Editeur: TGUID read GetID_Editeur write SetID_Editeur;
  end;

  TSerieComplete = class(TObjetComplet)
  strict private
    FIdAuteur: TGUID;
    FForce: Boolean;

    FTitre: string;
    FTerminee: Integer;
    FSujet: TStringList;
    FNotes: TStringList;
    FCollection: TCollection;
    FSiteWeb: string;
    FGenres: TStringList;
    FEditeur: TEditeurComplet;
    FSuivreManquants: Boolean;
    FColoristes: TObjectList<TAuteur>;
    FComplete: Boolean;
    FScenaristes: TObjectList<TAuteur>;
    FSuivreSorties: Boolean;
    FCouleur: Integer;
    FDessinateurs: TObjectList<TAuteur>;
    FAlbums: TObjectList<TAlbum>;
    FParaBD: TObjectList<TParaBD>;
    FNbAlbums: Integer;
    FVO: Integer;
    FReliure: ROption;
    FEtat: ROption;
    FFormatEdition: ROption;
    FTypeEdition: ROption;
    FOrientation: ROption;
    FSensLecture: ROption;
    FNotation: Integer;
    function GetID_Editeur: TGUID; inline;
    procedure SetID_Editeur(const Value: TGUID); inline;
    function GetID_Collection: TGUID; inline;
    procedure SetID_Collection(const Value: TGUID); inline;
    procedure SetTitre(const Value: string); inline;
    procedure SetSiteWeb(const Value: string); inline;

  class var
    FGetDefaultDone: Boolean;
    FDefaultEtat: ROption;
    FDefaultReliure: ROption;
    FDefaultFormatEdition: ROption;
    FDefaultTypeEdition: ROption;
    FDefaultOrientation: ROption;
    FDefaultSensLecture: ROption;
    class procedure GetDefaultValues;
  public
    constructor Create(const Reference, IdAuteur: TGUID); reintroduce; overload;
    constructor Create(const Reference, IdAuteur: TGUID; Force: Boolean); reintroduce; overload;
    destructor Destroy; override;
    procedure Fill(const Reference: TGUID); overload; override;
    procedure Fill(const Reference, IdAuteur: TGUID); reintroduce; overload;
    procedure Fill(const Reference, IdAuteur: TGUID; Force: Boolean); reintroduce; overload;
    procedure Clear; override;
    procedure PrepareInstance; override;
    procedure SaveToDatabase(UseTransaction: TUIBTransaction); override;
    function ChaineAffichage: string; reintroduce; overload;
    function ChaineAffichage(Simple: Boolean): string; overload; override;
    procedure ChangeNotation(Note: Integer);
  published
    property ID_Serie: TGUID read FID write FID;
    property ID_Editeur: TGUID read GetID_Editeur write SetID_Editeur;
    property ID_Collection: TGUID read GetID_Collection write SetID_Collection;
    property Titre: string read FTitre write SetTitre;
    property Terminee: Integer read FTerminee write FTerminee;
    property Genres: TStringList read FGenres;
    property Sujet: TStringList read FSujet;
    property Notes: TStringList read FNotes;
    property Editeur: TEditeurComplet read FEditeur;
    property Collection: TCollection read FCollection;
    property SiteWeb: string read FSiteWeb write SetSiteWeb;
    property Complete: Boolean read FComplete write FComplete;
    property SuivreManquants: Boolean read FSuivreManquants write FSuivreManquants;
    property SuivreSorties: Boolean read FSuivreSorties write FSuivreSorties;
    property NbAlbums: Integer read FNbAlbums write FNbAlbums;
    property Albums: TObjectList<TAlbum>read FAlbums;
    property ParaBD: TObjectList<TParaBD>read FParaBD;
    property Scenaristes: TObjectList<TAuteur>read FScenaristes;
    property Dessinateurs: TObjectList<TAuteur>read FDessinateurs;
    property Coloristes: TObjectList<TAuteur>read FColoristes;
    property VO: Integer read FVO write FVO;
    property Couleur: Integer read FCouleur write FCouleur;
    property Etat: ROption read FEtat write FEtat;
    property Reliure: ROption read FReliure write FReliure;
    property TypeEdition: ROption read FTypeEdition write FTypeEdition;
    property FormatEdition: ROption read FFormatEdition write FFormatEdition;
    property Orientation: ROption read FOrientation write FOrientation;
    property SensLecture: ROption read FSensLecture write FSensLecture;
    property Notation: Integer read FNotation write FNotation;
  end;

  TAuteurComplet = class(TObjetComplet)
  strict private
    FBiographie: TStringList;
    FNomAuteur: string;
    FSiteWeb: string;
    FSeries: TObjectList<TSerieComplete>;
    procedure SetNomAuteur(const Value: string); inline;
    procedure SetSiteWeb(const Value: string); inline;
  public
    destructor Destroy; override;
    procedure Fill(const Reference: TGUID); override;
    procedure Clear; override;
    procedure PrepareInstance; override;
    procedure SaveToDatabase(UseTransaction: TUIBTransaction); override;
    function ChaineAffichage(dummy: Boolean = True): string; override;
  published
    property ID_Auteur: TGUID read FID write FID;
    property NomAuteur: string read FNomAuteur write SetNomAuteur;
    property SiteWeb: string read FSiteWeb write SetSiteWeb;
    property Biographie: TStringList read FBiographie;
    property Series: TObjectList<TSerieComplete>read FSeries;
  end;

  TEditionComplete = class(TObjetComplet)
  strict private
    FStock: Boolean;
    FCouvertures: TMyObjectList<TCouverture>;
    FPrix: Currency;
    FAnneeCote: Integer;
    FISBN: string;
    FGratuit: Boolean;
    FPrete: Boolean;
    FNombreDePages: Integer;
    FNumeroPerso: string;
    FNotes: TStringList;
    FReliure: ROption;
    FAnneeEdition: Integer;
    FDedicace: Boolean;
    FCouleur: Boolean;
    FEtat: ROption;
    FCollection: TCollection;
    FFormatEdition: ROption;
    FTypeEdition: ROption;
    FEmprunts: TEmpruntsComplet;
    FPrixCote: Currency;
    FOrientation: ROption;
    FDateAchat: TDateTime;
    FOffert: Boolean;
    FSensLecture: ROption;
    FEditeur: TEditeurComplet;
    FID_Album: TGUID;
    FVO: Boolean;
    function Get_sDateAchat: string; inline;
    procedure SetNumeroPerso(const Value: string); inline;
  strict private
  class var
    FGetDefaultDone: Boolean;
    FDefaultEtat: ROption;
    FDefaultReliure: ROption;
    FDefaultFormatEdition: ROption;
    FDefaultTypeEdition: ROption;
    FDefaultOrientation: ROption;
    FDefaultSensLecture: ROption;
    class procedure GetDefaultValues;
  public
    destructor Destroy; override;
    procedure Fill(const Reference: TGUID); override;
    procedure Clear; override;
    procedure PrepareInstance; override;
    function ChaineAffichage(dummy: Boolean = True): string; override;
    procedure SaveToDatabase(UseTransaction: TUIBTransaction); override;
    procedure FusionneInto(Dest: TEditionComplete);
  published
    property ID_Edition: TGUID read FID write FID;
    property ID_Album: TGUID read FID_Album write FID_Album;
    property Editeur: TEditeurComplet read FEditeur;
    property Collection: TCollection read FCollection;
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
    property ISBN: string read FISBN write FISBN;
    property DateAchat: TDateTime read FDateAchat write FDateAchat;
    property sDateAchat: string read Get_sDateAchat;
    property Notes: TStringList read FNotes;
    property NumeroPerso: string { [25] } read FNumeroPerso write SetNumeroPerso;
    property Emprunts: TEmpruntsComplet read FEmprunts;
    property Couvertures: TMyObjectList<TCouverture>read FCouvertures;
  end;

  TEditionsCompletes = class(TListComplet)
  strict private
    FEditions: TObjectList<TEditionComplete>;
  public
    procedure Fill(const Reference: TGUID; Stock: Integer = -1); reintroduce;
    procedure PrepareInstance; override;
    procedure Clear; override;
    constructor Create(const Reference: TGUID; Stock: Integer = -1); reintroduce; overload;
    destructor Destroy; override;
    procedure FusionneInto(Dest: TEditionsCompletes);
  published
    property Editions: TObjectList<TEditionComplete>read FEditions;
  end;

  TAlbumComplet = class(TObjetComplet)
  strict private
    FTitre: string;
    FSerie: TSerieComplete;
    FSujet: TStringList;
    FHorsSerie: Boolean;
    FMoisParution: Integer;
    FTomeFin: Integer;
    FColoristes: TObjectList<TAuteur>;
    FNotes: TStringList;
    FAnneeParution: Integer;
    FScenaristes: TObjectList<TAuteur>;
    FIntegrale: Boolean;
    FDessinateurs: TObjectList<TAuteur>;
    FTomeDebut: Integer;
    FTome: Integer;
    FEditions: TEditionsCompletes;
    FComplet: Boolean;
    FReadyToFusion: Boolean;
    FFusionneEditions: Boolean;
    FNotation: Integer;
    FDefaultSearch: string;
    function GetID_Serie: TGUID; inline;
    procedure SetID_Serie(const Value: TGUID); inline;
    procedure SetTitre(const Value: string); inline;
  public
    procedure Fill(const Reference: TGUID); override;
    procedure Clear; override;
    procedure PrepareInstance; override;
    destructor Destroy; override;
    procedure SaveToDatabase(UseTransaction: TUIBTransaction); override;
    procedure Acheter(Prevision: Boolean);
    function ChaineAffichage(AvecSerie: Boolean): string; overload; override;
    function ChaineAffichage(Simple, AvecSerie: Boolean): string; reintroduce; overload;
    procedure ChangeNotation(Note: Integer);

    procedure FusionneInto(Dest: TAlbumComplet);
    property ReadyToFusion: Boolean read FReadyToFusion write FReadyToFusion;
    property FusionneEditions: Boolean read FFusionneEditions write FFusionneEditions;
    property DefaultSearch: string read FDefaultSearch write FDefaultSearch;
  published
    property Complet: Boolean read FComplet;
    property ID_Album: TGUID read FID write FID;
    property ID_Serie: TGUID read GetID_Serie write SetID_Serie;
    property Titre: string read FTitre write SetTitre;
    property Serie: TSerieComplete read FSerie;
    property MoisParution: Integer read FMoisParution write FMoisParution;
    property AnneeParution: Integer read FAnneeParution write FAnneeParution;
    property Tome: Integer read FTome write FTome;
    property TomeDebut: Integer read FTomeDebut write FTomeDebut;
    property TomeFin: Integer read FTomeFin write FTomeFin;
    property HorsSerie: Boolean read FHorsSerie write FHorsSerie;
    property Integrale: Boolean read FIntegrale write FIntegrale;
    property Scenaristes: TObjectList<TAuteur>read FScenaristes;
    property Dessinateurs: TObjectList<TAuteur>read FDessinateurs;
    property Coloristes: TObjectList<TAuteur>read FColoristes;
    property Sujet: TStringList read FSujet;
    property Notes: TStringList read FNotes;
    property Editions: TEditionsCompletes read FEditions;
    property Notation: Integer read FNotation write FNotation;
  end;

  TEmprunteurComplet = class(TObjetComplet)
  strict private
    FNom: string;
    FEmprunts: TEmpruntsComplet;
    FAdresse: TStringList;
    procedure SetNom(const Value: string); inline;
  public
    procedure Fill(const Reference: TGUID); override;
    procedure Clear; override;
    procedure PrepareInstance; override;
    destructor Destroy; override;
    procedure SaveToDatabase(UseTransaction: TUIBTransaction); override;
    function ChaineAffichage(dummy: Boolean = True): string; override;
  published
    property ID_Emprunteur: TGUID read FID write FID;
    property Nom: string { [100] } read FNom write SetNom;
    property Adresse: TStringList read FAdresse;
    property Emprunts: TEmpruntsComplet read FEmprunts;
  end;

  TStats = class(TInfoComplet)
  strict private
    FNbAlbumsGratuit: Integer;
    FListEmprunteursMin: TObjectList<TEmprunteur>;
    FMoyEmpruntes: Integer;
    FNbAlbumsNB: Integer;
    FPrixAlbumMaximun: Currency;
    FNbEmprunteurs: Integer;
    FMinEmprunteurs: Integer;
    FMaxEmpruntes: Integer;
    FPrixAlbumMoyen: Currency;
    FValeurConnue: Currency;
    FNbAlbumsIntegrale: Integer;
    FMaxAnnee: Integer;
    FNbAlbumsDedicace: Integer;
    FListAlbumsMax: TObjectList<TAlbum>;
    FNbSeries: Integer;
    FListEditeurs: TObjectList<TStats>;
    FPrixAlbumMinimun: Currency;
    FNbEmpruntes: Integer;
    FMinEmpruntes: Integer;
    FValeurEstimee: Currency;
    FMinAnnee: Integer;
    FNbAlbumsOffert: Integer;
    FNbSeriesTerminee: Integer;
    FListAlbumsMin: TObjectList<TAlbum>;
    FMoyEmprunteurs: Integer;
    FListEmprunteursMax: TObjectList<TEmprunteur>;
    FNbAlbumsVO: Integer;
    FNbAlbumsSansPrix: Integer;
    FNbAlbums: Integer;
    FNbAlbumsHorsSerie: Integer;
    FNbAlbumsStock: Integer;
    FEditeur: string;
    FListGenre: TObjectList<TGenre>;
    FMaxEmprunteurs: Integer;
  strict private
    procedure CreateStats(Stats: TStats); overload;
    procedure CreateStats(Stats: TStats; const ID_Editeur: TGUID; const Editeur: string); overload;
  public
    constructor Create(Complete: Boolean); reintroduce; overload;
    destructor Destroy; override;
    procedure Fill(Complete: Boolean); reintroduce;
    procedure Clear; override;
    procedure PrepareInstance; override;
  published
    property Editeur: string read FEditeur;
    property NbAlbums: Integer read FNbAlbums;
    property NbSeries: Integer read FNbSeries;
    property NbSeriesTerminee: Integer read FNbSeriesTerminee;
    property NbAlbumsNB: Integer read FNbAlbumsNB;
    property NbAlbumsVO: Integer read FNbAlbumsVO;
    property NbAlbumsStock: Integer read FNbAlbumsStock;
    property NbAlbumsIntegrale: Integer read FNbAlbumsIntegrale;
    property NbAlbumsHorsSerie: Integer read FNbAlbumsHorsSerie;
    property NbAlbumsDedicace: Integer read FNbAlbumsDedicace;
    property NbAlbumsOffert: Integer read FNbAlbumsOffert;
    property NbAlbumsGratuit: Integer read FNbAlbumsGratuit;
    property MinAnnee: Integer read FMinAnnee;
    property MaxAnnee: Integer read FMaxAnnee;
    property NbEmprunteurs: Integer read FNbEmprunteurs;
    property MoyEmprunteurs: Integer read FMoyEmprunteurs;
    property MinEmprunteurs: Integer read FMinEmprunteurs;
    property MaxEmprunteurs: Integer read FMaxEmprunteurs;
    property NbEmpruntes: Integer read FNbEmpruntes;
    property MoyEmpruntes: Integer read FMoyEmpruntes;
    property MinEmpruntes: Integer read FMinEmpruntes;
    property MaxEmpruntes: Integer read FMaxEmpruntes;
    property NbAlbumsSansPrix: Integer read FNbAlbumsSansPrix;
    property ValeurConnue: Currency read FValeurConnue;
    property ValeurEstimee: Currency read FValeurEstimee;
    property PrixAlbumMinimun: Currency read FPrixAlbumMinimun;
    property PrixAlbumMoyen: Currency read FPrixAlbumMoyen;
    property PrixAlbumMaximun: Currency read FPrixAlbumMaximun;
    property ListAlbumsMin: TObjectList<TAlbum>read FListAlbumsMin;
    property ListAlbumsMax: TObjectList<TAlbum>read FListAlbumsMax;
    property ListEmprunteursMin: TObjectList<TEmprunteur>read FListEmprunteursMin;
    property ListEmprunteursMax: TObjectList<TEmprunteur>read FListEmprunteursMax;
    property ListGenre: TObjectList<TGenre>read FListGenre;
    property ListEditeurs: TObjectList<TStats>read FListEditeurs;
  end;

  TSerieIncomplete = class(TInfoComplet)
  strict private
    FSerie: TSerie;
    FNumerosManquants: TStringList;
  public
    procedure PrepareInstance; override;
    destructor Destroy; override;
    function ChaineAffichage: string;
  published
    property Serie: TSerie read FSerie;
    property NumerosManquants: TStringList read FNumerosManquants;
  end;

  TSeriesIncompletes = class(TListComplet)
  strict private
    FSeries: TObjectList<TSerieIncomplete>;
  public
    constructor Create(AvecIntegrales, AvecAchats: Boolean); reintroduce; overload;
    constructor Create(const ID_Serie: TGUID); reintroduce; overload;
    destructor Destroy; override;
    procedure Fill(const Reference: TGUID); overload; override;
    procedure Fill(AvecIntegrales, AvecAchats: Boolean; const ID_Serie: TGUID); reintroduce; overload;
    procedure Clear; override;
    procedure PrepareInstance; override;
  published
    property Series: TObjectList<TSerieIncomplete>read FSeries;
  end;

  TPrevisionSortie = class(TInfoComplet)
  strict private
    FMois: Integer;
    FAnnee: Integer;
    FSerie: TSerie;
    FTome: Integer;
    function GetsAnnee: string; inline;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property Serie: TSerie read FSerie;
    property Tome: Integer read FTome write FTome;
    property Annee: Integer read FAnnee write FAnnee;
    property Mois: Integer read FMois write FMois;
    property sAnnee: string read GetsAnnee;
  end;

  TPrevisionsSorties = class(TListComplet)
  strict private
    FAnneesPassees: TObjectList<TPrevisionSortie>;
    FAnneesProchaines: TObjectList<TPrevisionSortie>;
    FAnneeEnCours: TObjectList<TPrevisionSortie>;
  public
    constructor Create(AvecAchats: Boolean); reintroduce; overload;
    constructor Create(const ID_Serie: TGUID); reintroduce; overload;
    destructor Destroy; override;
    procedure Fill(const Reference: TGUID); overload; override;
    procedure Fill(AvecAchats: Boolean); reintroduce; overload;
    procedure Fill(AvecAchats: Boolean; const ID_Serie: TGUID); reintroduce; overload;
    procedure PrepareInstance; override;
    procedure Clear; override;
  published
    property AnneesPassees: TObjectList<TPrevisionSortie>read FAnneesPassees;
    property AnneeEnCours: TObjectList<TPrevisionSortie>read FAnneeEnCours;
    property AnneesProchaines: TObjectList<TPrevisionSortie>read FAnneesProchaines;
  end;

  TParaBDComplet = class(TObjetComplet)
  strict private
    OldHasImage, OldImageStockee: Boolean;
    OldFichierImage: string;
    FAuteurs: TObjectList<TAuteur>;
    FStock: Boolean;
    FTitre: string;
    FPrix: Currency;
    FAnneeCote: Integer;
    FGratuit: Boolean;
    FCategorieParaBD: ROption;
    FSerie: TSerieComplete;
    FAnneeEdition: Integer;
    FDedicace: Boolean;
    FDescription: TStringList;
    FPrixCote: Currency;
    FNumerote: Boolean;
    FDateAchat: TDateTime;
    FOffert: Boolean;
    FFichierImage: string;
    FImageStockee: Boolean;
    FHasImage: Boolean;
    function Get_sDateAchat: string;
    procedure SetTitre(const Value: string); inline;
  public
    procedure Fill(const Reference: TGUID); override;
    procedure Clear; override;
    procedure PrepareInstance; override;
    destructor Destroy; override;

    procedure SaveToDatabase(UseTransaction: TUIBTransaction); override;
    procedure Acheter(Prevision: Boolean);

    function ChaineAffichage(AvecSerie: Boolean): string; overload; override;
    function ChaineAffichage(Simple, AvecSerie: Boolean): string; reintroduce; overload;
  published
    property ID_ParaBD: TGUID read FID write FID;
    property AnneeEdition: Integer read FAnneeEdition write FAnneeEdition;
    property CategorieParaBD: ROption read FCategorieParaBD write FCategorieParaBD;
    property AnneeCote: Integer read FAnneeCote write FAnneeCote;
    property Titre: string { [150] } read FTitre write SetTitre;
    property Auteurs: TObjectList<TAuteur>read FAuteurs;
    property Description: TStringList read FDescription;
    property Serie: TSerieComplete read FSerie;
    property Prix: Currency read FPrix write FPrix;
    property PrixCote: Currency read FPrixCote write FPrixCote;
    property Dedicace: Boolean read FDedicace write FDedicace;
    property Numerote: Boolean read FNumerote write FNumerote;
    property Stock: Boolean read FStock write FStock;
    property Offert: Boolean read FOffert write FOffert;
    property Gratuit: Boolean read FGratuit write FGratuit;
    property DateAchat: TDateTime read FDateAchat write FDateAchat;
    property sDateAchat: string read Get_sDateAchat;
    property HasImage: Boolean read FHasImage write FHasImage;
    property ImageStockee: Boolean read FImageStockee write FImageStockee;
    property FichierImage: string read FFichierImage write FFichierImage;
  end;

  TGroupOption = (goEt, goOu);

const
  TLblGroupOption: array [TGroupOption] of string = ('ET', 'OU');

type
  TGroupCritere = class;

  TBaseCritere = class
    Level: Integer;
    Parent: TGroupCritere;
    constructor Create(AParent: TGroupCritere); virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
  end;

  TCritere = class(TBaseCritere)
    // affichage
    Champ, Test: string;
    // sql
    NomTable: string;
    TestSQL: string;
    // fenêtre
    iChamp: Integer;
    iSignes, iCritere2: Integer;
    valeurText: string;

    procedure Assign(S: TCritere);
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromStream(Stream: TStream); override;
  end;

  TGroupCritere = class(TBaseCritere)
    SousCriteres: TObjectList<TBaseCritere>;
    GroupOption: TGroupOption;

    constructor Create(Parent: TGroupCritere); override;
    destructor Destroy; override;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromStream(Stream: TStream); override;
  end;

  TCritereTri = class
    // sql
    Champ, NomTable: string;
    Asc: Boolean;
    NullsFirst, NullsLast: Boolean;
    // fenêtre
    iChamp: Integer;
    // impression
    LabelChamp: string;
    Imprimer: Boolean;

    // valeur de travail
    _Champ: PChamp;

    procedure Assign(S: TCritereTri);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
  end;

  TTypeRecherche = (trAucune, trSimple, trComplexe);
  TRechercheSimple = (rsAuteur, rsSerie, rsEditeur, rsGenre, rsCollection);

const
  TLblRechercheSimple: array [TRechercheSimple] of string = ('Auteur', 'Serie', 'Editeur', 'Genre', 'Collection');

type
  TRecherche = class(TBaseComplet)
  public
    TypeRecherche: TTypeRecherche;
    Resultats: TObjectList<TAlbum>;
    ResultatsInfos: TStrings;
    Criteres: TGroupCritere;
    SortBy: TObjectList<TCritereTri>;
    RechercheSimple: TRechercheSimple;
    FLibelle: string;

    procedure PrepareInstance; override;
    procedure Clear; override;
    procedure ClearCriteres;
    procedure Fill; reintroduce; overload;
    procedure Fill(Recherche: TRechercheSimple; const ID: TGUID; const Libelle: string); reintroduce; overload;

    function AddCritere(Parent: TGroupCritere): TCritere;
    function AddGroup(Parent: TGroupCritere): TGroupCritere;
    function AddSort: TCritereTri;
    procedure Delete(Item: TBaseCritere); overload;
    procedure Delete(Item: TCritereTri); overload;

    constructor Create; overload; override;
    constructor Create(Recherche: TRechercheSimple; const ID: TGUID; const Libelle: string); reintroduce; overload;
    destructor Destroy; override;

    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
  end;

implementation

uses UIBLib, Divers, StdCtrls, Procedures, Textes, StrUtils, UMetadata, Controls, UfrmFusionEditions;

function MakeOption(Value: Integer; const Caption: string): ROption;
begin
  Result.Value := Value;
  Result.Caption := Caption;
end;

{ TBaseComplet }

procedure TBaseComplet.BeforeDestruction;
begin
  inherited;
  Clear;
end;

procedure TBaseComplet.Clear;
begin
  // nettoyage de toutes les listes et autres
  // et reset aux valeurs par défaut
end;

constructor TBaseComplet.Create;
begin
  inherited;
  PrepareInstance;
  Clear;
end;

procedure TBaseComplet.Fill(const Reference: TGUID);
begin
  Clear;
end;

procedure TBaseComplet.PrepareInstance;
begin

end;

class procedure TBaseComplet.WriteString(Stream: TStream; const Chaine: string);
begin
  Stream.write(Chaine[1], Length(Chaine));
end;

class procedure TBaseComplet.WriteStringLN(Stream: TStream; const Chaine: string);
begin
  WriteString(Stream, Chaine + #13#10);
end;

procedure TBaseComplet.WriteXMLToStream(Stream: TStream);
begin

end;

{ TAlbumComplet }

procedure TAlbumComplet.Acheter(Prevision: Boolean);
begin
  if IsEqualGUID(ID_Album, GUID_NULL) then
    Exit;
  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'UPDATE ALBUMS SET ACHAT = :Achat WHERE ID_Album = ?';
      Params.AsBoolean[0] := Prevision;
      Params.AsString[1] := GUIDToString(ID_Album);
      Execute;
      Transaction.Commit;
    finally
      Transaction.Free;
      Free;
    end;
end;

function TAlbumComplet.ChaineAffichage(AvecSerie: Boolean): string;
begin
  Result := ChaineAffichage(False, AvecSerie);
end;

function TAlbumComplet.ChaineAffichage(Simple, AvecSerie: Boolean): string;
begin
  Result := FormatTitreAlbum(Simple, AvecSerie, Titre, Serie.Titre, Tome, TomeDebut, TomeFin, Integrale, HorsSerie);
end;

procedure TAlbumComplet.ChangeNotation(Note: Integer);
begin
  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'update albums set notation = ? where id_album = ?';
      Params.AsSmallint[0] := Note;
      Params.AsString[1] := GUIDToString(ID_Album);
      ExecSQL;
      Transaction.Commit;

      FNotation := Note;
    finally
      Transaction.Free;
      Free;
    end;
end;

procedure TAlbumComplet.Clear;
begin
  inherited;
  FReadyToFusion := False;
  // le statut doit être conservé même si on fait un clear
  // FFusionneEditions := True;

  ID_Album := GUID_NULL;
  Titre := '';

  FComplet := False;
  MoisParution := 0;
  AnneeParution := 0;
  Tome := 0;
  TomeDebut := 0;
  TomeFin := 0;
  HorsSerie := False;
  Integrale := False;
  Notation := -1;

  Scenaristes.Clear;
  Dessinateurs.Clear;
  Coloristes.Clear;
  Sujet.Clear;
  Notes.Clear;
  Serie.Clear;

  Editions.Clear;
end;

destructor TAlbumComplet.Destroy;
begin
  FreeAndNil(FScenaristes);
  FreeAndNil(FDessinateurs);
  FreeAndNil(FColoristes);
  FreeAndNil(FSujet);
  FreeAndNil(FNotes);
  FreeAndNil(FSerie);
  FreeAndNil(FEditions);
  inherited;
end;

procedure TAlbumComplet.Fill(const Reference: TGUID);
var
  q: TUIBQuery;
begin
  inherited;
  if IsEqualGUID(Reference, GUID_NULL) then
    Exit;
  Self.ID_Album := Reference;
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      FetchBlobs := True;
      SQL.Clear;
      SQL.Add('select');
      SQL.Add('  titrealbum, moisparution, anneeparution, id_serie, tome, tomedebut, tomefin, sujetalbum,');
      SQL.Add('  remarquesalbum, horsserie, integrale, complet, notation');
      SQL.Add('from');
      SQL.Add('  albums');
      SQL.Add('where');
      SQL.Add('  id_album = ?');
      Params.AsString[0] := GUIDToString(Reference);
      Open;
      RecInconnu := Eof;

      if not RecInconnu then
      begin
        Self.Titre := Fields.ByNameAsString['titrealbum'];
        Self.AnneeParution := Fields.ByNameAsInteger['anneeparution'];
        Self.MoisParution := Fields.ByNameAsInteger['moisparution'];
        Self.Sujet.Text := Fields.ByNameAsString['sujetalbum'];
        Self.Notes.Text := Fields.ByNameAsString['remarquesalbum'];
        Self.Tome := Fields.ByNameAsInteger['tome'];
        Self.TomeDebut := Fields.ByNameAsInteger['tomedebut'];
        Self.TomeFin := Fields.ByNameAsInteger['tomefin'];
        Self.Integrale := Fields.ByNameAsBoolean['integrale'];
        Self.HorsSerie := Fields.ByNameAsBoolean['horsserie'];
        Self.Notation := Fields.ByNameAsSmallint['notation'];

        Self.Serie.Fill(StringToGUIDDef(Fields.ByNameAsString['id_serie'], GUID_NULL));

        FComplet := Fields.ByNameAsBoolean['complet'];

        Close;
        SQL.Text := 'select * from proc_auteurs(?, null, null)';
        Params.AsString[0] := GUIDToString(Reference);
        Open;
        TAuteur.Prepare(q);
        try
          while not Eof do
          begin
            case TMetierAuteur(Fields.ByNameAsInteger['metier']) of
              maScenariste:
                Self.Scenaristes.Add(TAuteur.Make(q));
              maDessinateur:
                Self.Dessinateurs.Add(TAuteur.Make(q));
              maColoriste:
                Self.Coloristes.Add(TAuteur.Make(q));
            end;
            Next;
          end;
        finally
          TAuteur.Unprepare;
        end;

        Self.Editions.Fill(Self.ID_Album);
      end;
    finally
      q.Transaction.Free;
      q.Free;
    end;
end;

procedure TAlbumComplet.FusionneInto(Dest: TAlbumComplet);

  function NotInList(Auteur: TAuteur; List: TObjectList<TAuteur>): Boolean; inline;
  var
    i: Integer;
  begin
    i := 0;
    Result := True;
    while Result and (i <= Pred(List.Count)) do
    begin
      Result := not IsEqualGUID(List[i].Personne.ID, Auteur.Personne.ID);
      Inc(i);
    end;
  end;

var
  DefaultAlbum: TAlbumComplet;
  Auteur: TAuteur;
begin
  DefaultAlbum := TAlbumComplet.Create;
  try
    // Album
    if not SameText(Titre, DefaultAlbum.Titre) then
      Dest.Titre := Titre;
    if MoisParution <> DefaultAlbum.MoisParution then
      Dest.MoisParution := MoisParution;
    if AnneeParution <> DefaultAlbum.AnneeParution then
      Dest.AnneeParution := AnneeParution;
    if Tome <> DefaultAlbum.Tome then
      Dest.Tome := Tome;
    if TomeDebut <> DefaultAlbum.TomeDebut then
      Dest.TomeDebut := TomeDebut;
    if TomeFin <> DefaultAlbum.TomeFin then
      Dest.TomeFin := TomeFin;
    if HorsSerie <> DefaultAlbum.HorsSerie then
      Dest.HorsSerie := HorsSerie;
    if Integrale <> DefaultAlbum.Integrale then
      Dest.Integrale := Integrale;

    for Auteur in Scenaristes do
      if NotInList(Auteur, Dest.Scenaristes) then
        Dest.Scenaristes.Add(TAuteur.Duplicate(Auteur) as TAuteur);
    for Auteur in Dessinateurs do
      if NotInList(Auteur, Dest.Dessinateurs) then
        Dest.Dessinateurs.Add(TAuteur.Duplicate(Auteur) as TAuteur);
    for Auteur in Coloristes do
      if NotInList(Auteur, Dest.Coloristes) then
        Dest.Coloristes.Add(TAuteur.Duplicate(Auteur) as TAuteur);

    if not SameText(Sujet.Text, DefaultAlbum.Sujet.Text) then
      Dest.Sujet.Assign(Sujet);
    if not SameText(Notes.Text, DefaultAlbum.Notes.Text) then
      Dest.Notes.Assign(Notes);

    // Série
    if not IsEqualGUID(ID_Serie, DefaultAlbum.ID_Serie) and not IsEqualGUID(ID_Serie, Dest.ID_Serie) then
      Dest.ID_Serie := ID_Serie;

    if FusionneEditions then
      Editions.FusionneInto(Dest.Editions);
  finally
    DefaultAlbum.Free;
  end;
end;

function TAlbumComplet.GetID_Serie: TGUID;
begin
  Result := Serie.ID_Serie;
end;

procedure TAlbumComplet.PrepareInstance;
begin
  inherited;
  FFusionneEditions := True;
  FDefaultSearch := '';
  FScenaristes := TObjectList<TAuteur>.Create;
  FDessinateurs := TObjectList<TAuteur>.Create;
  FColoristes := TObjectList<TAuteur>.Create;
  FSujet := TStringList.Create;
  FNotes := TStringList.Create;
  FSerie := TSerieComplete.Create;
  FEditions := TEditionsCompletes.Create;
end;

procedure TAlbumComplet.SaveToDatabase(UseTransaction: TUIBTransaction);
var
  S: string;
  q: TUIBQuery;
  Auteur: TAuteur;
  hg: IHourGlass;
  Edition: TEditionComplete;
begin
  inherited;
  hg := THourGlass.Create;
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := UseTransaction;

      SQL.Clear;
      SQL.Add('update or insert into albums (');
      SQL.Add('  id_album, titrealbum, moisparution, anneeparution, id_serie, tome, tomedebut, tomefin,');
      SQL.Add('  horsserie, integrale, sujetalbum, remarquesalbum');
      SQL.Add(') values (');
      SQL.Add('  :id_album, :titrealbum, :moisparution, :anneeparution, :id_serie, :tome, :tomedebut, :tomefin,');
      SQL.Add('  :horsserie, :integrale, :sujetalbum, :remarquesalbum');
      SQL.Add(')');
      Prepare(True);

      if IsEqualGUID(GUID_NULL, ID_Album) then
        Params.ByNameIsNull['id_album'] := True
      else
        Params.ByNameAsString['id_album'] := GUIDToString(ID_Album);
      S := Trim(Titre);
      if S = '' then
        Params.ByNameIsNull['titrealbum'] := True
      else
        Params.ByNameAsString['titrealbum'] := S;
      if AnneeParution = 0 then
      begin
        Params.ByNameIsNull['anneeparution'] := True;
        Params.ByNameIsNull['moisparution'] := True;
      end
      else
      begin
        Params.ByNameAsInteger['anneeparution'] := AnneeParution;
        if MoisParution = 0 then
          Params.ByNameIsNull['moisparution'] := True
        else
          Params.ByNameAsInteger['moisparution'] := MoisParution;
      end;
      if Tome = 0 then
        Params.ByNameIsNull['tome'] := True
      else
        Params.ByNameAsInteger['tome'] := Tome;
      if (not Integrale) or (TomeDebut = 0) then
        Params.ByNameIsNull['tomedebut'] := True
      else
        Params.ByNameAsInteger['tomedebut'] := TomeDebut;
      if (not Integrale) or (TomeFin = 0) then
        Params.ByNameIsNull['tomefin'] := True
      else
        Params.ByNameAsInteger['tomefin'] := TomeFin;
      Params.ByNameAsBoolean['integrale'] := Integrale;
      Params.ByNameAsBoolean['horsserie'] := HorsSerie;
      S := Sujet.Text;
      if S <> '' then
        ParamsSetBlob('sujetalbum', S)
      else
        Params.ByNameIsNull['sujetalbum'] := True;
      S := Notes.Text;
      if S <> '' then
        ParamsSetBlob('remarquesalbum', S)
      else
        Params.ByNameIsNull['remarquesalbum'] := True;
      if Serie.RecInconnu or IsEqualGUID(ID_Serie, GUID_NULL) then
        Params.ByNameIsNull['ID_SERIE'] := True
      else
        Params.ByNameAsString['id_serie'] := GUIDToString(ID_Serie);
      ExecSQL;

      SupprimerToutDans('', 'auteurs', 'id_album', ID_Album);
      SQL.Clear;
      SQL.Add('insert into auteurs (');
      SQL.Add('  id_album, metier, id_personne');
      SQL.Add(') values (');
      SQL.Add('  :id_album, :metier, :id_personne');
      SQL.Add(')');
      for Auteur in Scenaristes do
      begin
        Params.AsString[0] := GUIDToString(ID_Album);
        Params.AsInteger[1] := 0;
        Params.AsString[2] := GUIDToString(Auteur.Personne.ID);
        ExecSQL;
      end;
      for Auteur in Dessinateurs do
      begin
        Params.AsString[0] := GUIDToString(ID_Album);
        Params.AsInteger[1] := 1;
        Params.AsString[2] := GUIDToString(Auteur.Personne.ID);
        ExecSQL;
      end;
      for Auteur in Coloristes do
      begin
        Params.AsString[0] := GUIDToString(ID_Album);
        Params.AsInteger[1] := 2;
        Params.AsString[2] := GUIDToString(Auteur.Personne.ID);
        ExecSQL;
      end;

      S := '';
      for Edition in Editions.Editions do
        if not Edition.RecInconnu then
          AjoutString(S, QuotedStr(GUIDToString(Edition.ID_Edition)), ',');

      // éditions supprimées
      SQL.Clear;
      SQL.Add('delete from editions');
      SQL.Add('where');
      SQL.Add('  id_album = ?');
      if S <> '' then
        SQL.Add('  and id_edition not in (' + S + ')');
      Params.AsString[0] := GUIDToString(ID_Album);
      ExecSQL;
      SQL.Clear;
      SQL.Add('delete from couvertures');
      SQL.Add('where');
      SQL.Add('  id_album = ? and id_edition is not null');
      if S <> '' then
        SQL.Add('  and id_edition not in (' + S + ')');
      Params.AsString[0] := GUIDToString(ID_Album);
      ExecSQL;

      for Edition in Editions.Editions do
      begin
        Edition.ID_Album := ID_Album;
        Edition.SaveToDatabase(Transaction);
      end;

      Transaction.Commit;
    finally
      Free;
    end;
end;

procedure TAlbumComplet.SetID_Serie(const Value: TGUID);
begin
  Serie.Fill(Value);
end;

procedure TAlbumComplet.SetTitre(const Value: string);
begin
  FTitre := Copy(Value, 1, LengthTitreAlbum);
end;

{ TEditionComplete }

class procedure TEditionComplete.GetDefaultValues;
begin
  if FGetDefaultDone then
    Exit;

  FDefaultEtat := MakeOption(-1, '');
  FDefaultReliure := MakeOption(-1, '');
  FDefaultTypeEdition := MakeOption(-1, '');
  FDefaultOrientation := MakeOption(-1, '');
  FDefaultFormatEdition := MakeOption(-1, '');
  FDefaultSensLecture := MakeOption(-1, '');

  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'select categorie, ref, libelle from listes where defaut = 1 and categorie in (1,2,3,4,5,8)';
      Open;
      while not Eof do
      begin
        case Fields.AsInteger[0] of
          1:
            FDefaultEtat := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
          2:
            FDefaultReliure := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
          3:
            FDefaultTypeEdition := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
          4:
            FDefaultOrientation := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
          5:
            FDefaultFormatEdition := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
          8:
            FDefaultSensLecture := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
        end;
        Next;
      end;
      Transaction.Commit;
    finally
      Transaction.Free;
      Free;
    end;
end;

procedure TEditionComplete.Clear;
begin
  inherited;
  ID_Edition := GUID_NULL;
  Editeur.Clear;
  Collection.Clear;
  Emprunts.Clear;
  Couvertures.Clear;
  Notes.Clear;

  GetDefaultValues;

  TypeEdition := FDefaultTypeEdition;
  AnneeEdition := 0;
  Etat := FDefaultEtat;
  Reliure := FDefaultReliure;
  NombreDePages := 0;
  FormatEdition := FDefaultFormatEdition;
  Orientation := FDefaultOrientation;
  AnneeCote := 0;
  SensLecture := FDefaultSensLecture;
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

destructor TEditionComplete.Destroy;
begin
  FreeAndNil(FCouvertures);
  FreeAndNil(FEditeur);
  FreeAndNil(FCollection);
  FreeAndNil(FEmprunts);
  FreeAndNil(FNotes);
  inherited;
end;

procedure TEditionComplete.Fill(const Reference: TGUID);
var
  q: TUIBQuery;
begin
  inherited Fill(Reference);
  if IsEqualGUID(Reference, GUID_NULL) then
    Exit;
  Self.ID_Edition := Reference;
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Clear;
      SQL.Add('select');
      SQL.Add('  id_edition, id_album, e.id_editeur, e.id_collection, nomcollection, anneeedition, prix, vo,');
      SQL.Add('  couleur, isbn, dedicace, prete, stock, offert, gratuit, nombredepages, dateachat, notes,');
      SQL.Add('  anneecote, prixcote, numeroperso, etat, le.libelle as setat, reliure, lr.libelle as sreliure,');
      SQL.Add('  orientation, lo.libelle as sorientation, formatedition, lf.libelle as sformatedition,');
      SQL.Add('  typeedition, lte.libelle as stypeedition, senslecture, lsl.libelle as ssenslecture');
      SQL.Add('from');
      SQL.Add('  editions e');
      SQL.Add('  left join collections c on');
      SQL.Add('    e.id_collection = c.id_collection');
      SQL.Add('  left join listes le on');
      SQL.Add('    (le.ref = e.etat and le.categorie = 1)');
      SQL.Add('  left join listes lr on');
      SQL.Add('    (lr.ref = e.reliure and lr.categorie = 2)');
      SQL.Add('  left join listes lte on');
      SQL.Add('    (lte.ref = e.typeedition and lte.categorie = 3)');
      SQL.Add('  left join listes lo on');
      SQL.Add('    (lo.ref = e.orientation and lo.categorie = 4)');
      SQL.Add('  left join listes lf on');
      SQL.Add('    (lf.ref = e.formatedition and lf.categorie = 5)');
      SQL.Add('  left join listes lsl on');
      SQL.Add('    (lsl.ref = e.senslecture and lsl.categorie = 8)');
      SQL.Add('where');
      SQL.Add('  id_edition = ?');
      Params.AsString[0] := GUIDToString(Reference);
      FetchBlobs := True;
      Open;
      RecInconnu := Eof;

      if not RecInconnu then
      begin
        Self.ID_Album := StringToGUIDDef(Fields.ByNameAsString['id_album'], GUID_NULL);
        Self.Editeur.Fill(StringToGUIDDef(Fields.ByNameAsString['id_editeur'], GUID_NULL));
        Self.Collection.Fill(q);
        Self.AnneeEdition := Fields.ByNameAsInteger['anneeedition'];
        Self.Prix := Fields.ByNameAsCurrency['prix'];
        Self.VO := Fields.ByNameAsBoolean['vo'];
        Self.Couleur := Fields.ByNameAsBoolean['couleur'];
        Self.Dedicace := Fields.ByNameAsBoolean['dedicace'];
        Self.Offert := Fields.ByNameAsBoolean['offert'];
        Self.Gratuit := Fields.ByNameAsBoolean['gratuit'];
        Self.Prete := Fields.ByNameAsBoolean['prete'];
        Self.Stock := Fields.ByNameAsBoolean['stock'];
        Self.ISBN := FormatISBN(Trim(Fields.ByNameAsString['isbn']));
        Self.TypeEdition := MakeOption(Fields.ByNameAsInteger['typeedition'], Trim(Fields.ByNameAsString['stypeedition']));
        Self.NombreDePages := Fields.ByNameAsInteger['nombredepages'];
        Self.Etat := MakeOption(Fields.ByNameAsInteger['etat'], Trim(Fields.ByNameAsString['setat']));
        Self.Reliure := MakeOption(Fields.ByNameAsInteger['reliure'], Trim(Fields.ByNameAsString['sreliure']));
        Self.Orientation := MakeOption(Fields.ByNameAsInteger['orientation'], Trim(Fields.ByNameAsString['sorientation']));
        Self.FormatEdition := MakeOption(Fields.ByNameAsInteger['formatedition'], Trim(Fields.ByNameAsString['sformatedition']));
        Self.SensLecture := MakeOption(Fields.ByNameAsInteger['senslecture'], Trim(Fields.ByNameAsString['ssenslecture']));
        Self.DateAchat := Fields.ByNameAsDate['dateachat'];
        Self.Notes.Text := Fields.ByNameAsString['notes'];
        Self.AnneeCote := Fields.ByNameAsInteger['anneecote'];
        Self.PrixCote := Fields.ByNameAsCurrency['prixcote'];
        Self.NumeroPerso := Fields.ByNameAsString['numeroperso'];

        Self.Emprunts.Fill(Self.ID_Edition, seAlbum);

        Close;
        SQL.Clear;
        SQL.Add('select');
        SQL.Add('  id_couverture, fichiercouverture, stockagecouverture, categorieimage, l.libelle as scategorieimage');
        SQL.Add('from');
        SQL.Add('  couvertures c');
        SQL.Add('  left join listes l on');
        SQL.Add('    (c.categorieimage = l.ref and l.categorie = 6)');
        SQL.Add('where');
        SQL.Add('  id_edition = ?');
        SQL.Add('order by');
        SQL.Add('  c.categorieimage nulls first, c.ordre');
        Params.AsString[0] := GUIDToString(Self.ID_Edition);
        Open;
        TCouverture.FillList(TList<TBasePointeur>(Self.Couvertures), q);
      end;
    finally
      q.Transaction.Free;
      q.Free;
    end;
end;

procedure TEditionComplete.FusionneInto(Dest: TEditionComplete);
var
  DefaultEdition: TEditionComplete;
  Couverture: TCouverture;
begin
  DefaultEdition := TEditionComplete.Create;
  try
    if not IsEqualGUID(Editeur.ID_Editeur, DefaultEdition.Editeur.ID_Editeur) and not IsEqualGUID(Editeur.ID_Editeur, Dest.Editeur.ID_Editeur) then
      Dest.Editeur.Fill(Editeur.ID_Editeur);
    if not IsEqualGUID(Collection.ID, DefaultEdition.Collection.ID) and not IsEqualGUID(Collection.ID, Dest.Collection.ID) then
      Dest.Collection.Fill(Collection.ID);

    if TypeEdition.Value <> DefaultEdition.TypeEdition.Value then
      Dest.TypeEdition := TypeEdition;
    if Etat.Value <> DefaultEdition.Etat.Value then
      Dest.Etat := Etat;
    if Reliure.Value <> DefaultEdition.Reliure.Value then
      Dest.Reliure := Reliure;
    if FormatEdition.Value <> DefaultEdition.FormatEdition.Value then
      Dest.FormatEdition := FormatEdition;
    if Orientation.Value <> DefaultEdition.Orientation.Value then
      Dest.Orientation := Orientation;
    if SensLecture.Value <> DefaultEdition.SensLecture.Value then
      Dest.SensLecture := SensLecture;

    if AnneeEdition <> DefaultEdition.AnneeEdition then
      Dest.AnneeEdition := AnneeEdition;
    if NombreDePages <> DefaultEdition.NombreDePages then
      Dest.NombreDePages := NombreDePages;
    if AnneeCote <> DefaultEdition.AnneeCote then
      Dest.AnneeCote := AnneeCote;
    if Prix <> DefaultEdition.Prix then
      Dest.Prix := Prix;
    if PrixCote <> DefaultEdition.PrixCote then
      Dest.PrixCote := PrixCote;
    if Couleur <> DefaultEdition.Couleur then
      Dest.Couleur := Couleur;
    if VO <> DefaultEdition.VO then
      Dest.VO := VO;
    if Dedicace <> DefaultEdition.Dedicace then
      Dest.Dedicace := Dedicace;
    if Stock <> DefaultEdition.Stock then
      Dest.Stock := Stock;
    if Prete <> DefaultEdition.Prete then
      Dest.Prete := Prete;
    if Offert <> DefaultEdition.Offert then
      Dest.Offert := Offert;
    if Gratuit <> DefaultEdition.Gratuit then
      Dest.Gratuit := Gratuit;
    if ISBN <> DefaultEdition.ISBN then
      Dest.ISBN := ISBN;
    if DateAchat <> DefaultEdition.DateAchat then
      Dest.DateAchat := DateAchat;
    if not SameText(Notes.Text, DefaultEdition.Notes.Text) then
      Dest.Notes.Assign(Notes);
    if NumeroPerso <> DefaultEdition.NumeroPerso then
      Dest.NumeroPerso := NumeroPerso;

    for Couverture in Couvertures do
      Dest.Couvertures.Add(TCouverture.Duplicate(Couverture) as TCouverture);
  finally
    DefaultEdition.Free;
  end;
end;

function TEditionComplete.Get_sDateAchat: string;
begin
  if Self.DateAchat > 0 then
    Result := DateToStr(Self.DateAchat)
  else
    Result := '';
end;

function TEditionComplete.ChaineAffichage(dummy: Boolean = True): string;
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

procedure TEditionComplete.SaveToDatabase(UseTransaction: TUIBTransaction);
var
  PC: TCouverture;
  hg: IHourGlass;
  q: TUIBQuery;
  S: string;
  i: Integer;
  Stream: TStream;
  q1, q2, q3, q4, q5, q6: TUIBQuery;
  FichiersImages: TStringList;
begin
  inherited;
  FichiersImages := TStringList.Create;
  hg := THourGlass.Create;
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := UseTransaction;

      SQL.Clear;
      SQL.Add('update or insert into editions (');
      SQL.Add('  id_edition, id_album, id_editeur, id_collection, anneeedition, prix, vo, typeedition,');
      SQL.Add('  couleur, isbn, stock, dedicace, offert, gratuit, etat, reliure, orientation, formatedition,');
      SQL.Add('  dateachat, notes, nombredepages, anneecote, prixcote, numeroperso, senslecture');
      SQL.Add(') values (');
      SQL.Add('  :id_edition, :id_album, :id_editeur, :id_collection, :anneeedition, :prix, :vo, :typeedition,');
      SQL.Add('  :couleur, :isbn, :stock, :dedicace, :offert, :gratuit, :etat, :reliure, :orientation, :formatedition,');
      SQL.Add('  :dateachat, :notes, :nombredepages, :anneecote, :prixcote, :numeroperso, :senslecture');
      SQL.Add(')');

      if IsEqualGUID(GUID_NULL, ID_Edition) then
        Params.ByNameIsNull['id_edition'] := True
      else
        Params.ByNameAsString['id_edition'] := GUIDToString(ID_Edition);
      Params.ByNameAsString['id_album'] := GUIDToString(ID_Album);
      Params.ByNameAsString['id_editeur'] := GUIDToString(Editeur.ID_Editeur);
      Params.ByNameAsString['id_collection'] := GUIDToString(Collection.ID);
      if AnneeEdition = 0 then
        Params.ByNameIsNull['anneeedition'] := True
      else
        Params.ByNameAsInteger['anneeedition'] := AnneeEdition;
      if NombreDePages = 0 then
        Params.ByNameIsNull['nombredepages'] := True
      else
        Params.ByNameAsInteger['nombredepages'] := NombreDePages;
      if Prix = 0 then
        Params.ByNameIsNull['prix'] := True
      else
        Params.ByNameAsCurrency['prix'] := Prix;
      Params.ByNameAsBoolean['vo'] := VO;
      Params.ByNameAsBoolean['couleur'] := Couleur;
      Params.ByNameAsString['isbn'] := ClearISBN(ISBN);
      Params.ByNameAsBoolean['stock'] := Stock;
      Params.ByNameAsBoolean['dedicace'] := Dedicace;
      Params.ByNameAsBoolean['gratuit'] := Gratuit;
      Params.ByNameAsBoolean['offert'] := Offert;
      Params.ByNameAsInteger['typeedition'] := TypeEdition.Value;
      Params.ByNameAsInteger['etat'] := Etat.Value;
      Params.ByNameAsInteger['reliure'] := Reliure.Value;
      Params.ByNameAsInteger['orientation'] := Orientation.Value;
      Params.ByNameAsInteger['formatedition'] := FormatEdition.Value;
      Params.ByNameAsInteger['senslecture'] := SensLecture.Value;
      if DateAchat = 0 then
        Params.ByNameIsNull['dateachat'] := True
      else
        Params.ByNameAsDate['dateachat'] := Trunc(DateAchat);
      if (AnneeCote = 0) or (PrixCote = 0) then
      begin
        Params.ByNameIsNull['anneecote'] := True;
        Params.ByNameIsNull['prixcote'] := True;
      end
      else
      begin
        Params.ByNameAsInteger['anneecote'] := AnneeCote;
        Params.ByNameAsCurrency['prixcote'] := PrixCote;
      end;
      Params.ByNameAsString['numeroperso'] := NumeroPerso;

      S := Notes.Text;
      if S <> '' then
        ParamsSetBlob('notes', S)
      else
        Params.ByNameIsNull['notes'] := True;
      ExecSQL;

      S := '';
      for PC in Couvertures do
        if not IsEqualGUID(PC.ID, GUID_NULL) then
          AjoutString(S, QuotedStr(GUIDToString(PC.ID)), ',');

      SQL.Clear;
      SQL.Add('delete from couvertures');
      SQL.Add('where');
      SQL.Add('  id_edition = ?');
      if S <> '' then
        SQL.Add(' and id_couverture not in (' + S + ')');
      Params.AsString[0] := GUIDToString(ID_Edition);
      ExecSQL;

      q1 := TUIBQuery.Create(nil);
      q2 := TUIBQuery.Create(nil);
      q3 := TUIBQuery.Create(nil);
      q4 := TUIBQuery.Create(nil);
      q5 := TUIBQuery.Create(nil);
      q6 := TUIBQuery.Create(nil);
      try
        q1.Transaction := Transaction;
        q2.Transaction := Transaction;
        q3.Transaction := Transaction;
        q4.Transaction := Transaction;
        q5.Transaction := Transaction;
        q6.Transaction := Transaction;

        q1.SQL.Clear;
        q1.SQL.Add('insert into couvertures (');
        q1.SQL.Add('  id_edition, id_album, fichiercouverture, stockagecouverture, ordre, categorieimage');
        q1.SQL.Add(') values (');
        q1.SQL.Add('  :id_edition, :id_album, :fichiercouverture, 0, :ordre, :categorieimage');
        q1.SQL.Add(')');

        q6.SQL.Text := 'select result from saveblobtofile(:Chemin, :Fichier, :BlobContent)';

        q2.SQL.Clear;
        q2.SQL.Add('insert into couvertures (');
        q2.SQL.Add('  id_edition, id_album, fichiercouverture, stockagecouverture, ordre, imagecouverture, categorieimage');
        q2.SQL.Add(') values (');
        q2.SQL.Add('  :id_edition, :id_album, :fichiercouverture, 1, :ordre, :imagecouverture, :categorieimage');
        q2.SQL.Add(')');

        q3.SQL.Text := 'update couvertures set imagecouverture = :imagecouverture, stockagecouverture = 1 where id_couverture = :id_couverture';

        q4.SQL.Text := 'update couvertures set imagecouverture = null, stockagecouverture = 0 where id_couverture = :id_couverture';

        q5.SQL.Clear;
        q5.SQL.Add('update couvertures set');
        q5.SQL.Add('  fichiercouverture = :fichiercouverture, ordre = :ordre, categorieimage = :categorieimage');
        q5.SQL.Add('where');
        q5.SQL.Add('  id_couverture = :id_couverture');

        for PC in Couvertures do
          if IsEqualGUID(PC.ID, GUID_NULL) then
          begin // nouvelles couvertures
            if (not PC.NewStockee) then
            begin // couvertures liées (q1)
              PC.OldNom := PC.NewNom;
              PC.NewNom := SearchNewFileName(RepImages, ExtractFileName(PC.NewNom), True);
              q6.Params.ByNameAsString['chemin'] := RepImages;
              q6.Params.ByNameAsString['fichier'] := PC.NewNom;
              Stream := GetCouvertureStream(PC.OldNom, -1, -1, False);
              try
                q6.ParamsSetBlob('blobcontent', Stream);
              finally
                Stream.Free;
              end;
              q6.Open;

              q1.Params.ByNameAsString['id_edition'] := GUIDToString(ID_Edition);
              q1.Params.ByNameAsString['id_album'] := GUIDToString(ID_Album);
              q1.Params.ByNameAsString['fichiercouverture'] := PC.NewNom;
              q1.Params.ByNameAsInteger['ordre'] := Couvertures.IndexOf(PC);
              q1.Params.ByNameAsInteger['categorieimage'] := PC.Categorie;
              q1.ExecSQL;
            end
            else if FileExists(PC.NewNom) then
            begin // couvertures stockées (q2)
              q2.Params.ByNameAsString['id_edition'] := GUIDToString(ID_Edition);
              q2.Params.ByNameAsString['id_album'] := GUIDToString(ID_Album);
              q2.Params.ByNameAsString['fichiercouverture'] := ChangeFileExt(ExtractFileName(PC.NewNom), '');
              q2.Params.ByNameAsInteger['ordre'] := Couvertures.IndexOf(PC);
              Stream := GetJPEGStream(PC.NewNom);
              try
                q2.ParamsSetBlob('imagecouverture', Stream);
              finally
                Stream.Free;
              end;
              q2.Params.ByNameAsInteger['categorieimage'] := PC.Categorie;
              q2.ExecSQL;
            end;
          end
          else
          begin // ancienne couverture
            if PC.OldStockee <> PC.NewStockee then
            begin // changement de stockage
              Stream := GetCouvertureStream(False, PC.ID, -1, -1, False);
              try
                if (PC.NewStockee) then
                begin // conversion couvertures liées en stockées (q3)
                  q3.ParamsSetBlob('imagecouverture', Stream);
                  q3.Params.ByNameAsString['id_couverture'] := GUIDToString(PC.ID);
                  q3.ExecSQL;
                  if ExtractFilePath(PC.NewNom) = '' then
                    FichiersImages.Add(RepImages + PC.NewNom)
                  else
                    FichiersImages.Add(PC.NewNom);
                  PC.NewNom := ChangeFileExt(ExtractFileName(PC.NewNom), '');
                end
                else
                begin // conversion couvertures stockées en liées
                  PC.NewNom := SearchNewFileName(RepImages, PC.NewNom + '.jpg', True);
                  q6.Params.ByNameAsString['chemin'] := RepImages;
                  q6.Params.ByNameAsString['fichier'] := PC.NewNom;
                  q6.ParamsSetBlob('blobcontent', Stream);
                  q6.Open;

                  q4.Params.ByNameAsString['id_couverture'] := GUIDToString(PC.ID);
                  q4.ExecSQL;
                end;
              finally
                Stream.Free;
              end;
            end;
            // couvertures renommées, réordonnées, changée de catégorie, etc (q5)
            // obligatoire pour les changement de stockage
            q5.Params.ByNameAsString['fichiercouverture'] := PC.NewNom;
            q5.Params.ByNameAsInteger['ordre'] := Couvertures.IndexOf(PC);
            q5.Params.ByNameAsInteger['categorieimage'] := PC.Categorie;
            q5.Params.ByNameAsString['id_couverture'] := GUIDToString(PC.ID);
            q5.ExecSQL;
          end;
      finally
        FreeAndNil(q1);
        FreeAndNil(q2);
        FreeAndNil(q3);
        FreeAndNil(q4);
        FreeAndNil(q5);
        FreeAndNil(q6);
      end;
      Transaction.Commit;

      if FichiersImages.Count > 0 then
      begin
        Transaction.StartTransaction;
        SQL.Text := 'select * from deletefile(:fichier)';
        Prepare(True);
        for i := 0 to Pred(FichiersImages.Count) do
        begin
          Params.AsString[0] := Copy(FichiersImages[i], 1, Params.SQLLen[0]);
          Open;
          if Fields.AsInteger[0] <> 0 then
            ShowMessage(FichiersImages[i] + #13#13 + SysErrorMessage(Fields.AsInteger[0]));
        end;
        Transaction.Commit;
      end;
    finally
      FichiersImages.Free;
      Free;
    end;
end;

procedure TEditionComplete.SetNumeroPerso(const Value: string);
begin
  FNumeroPerso := Copy(Value, 1, LengthNumPerso);
end;

procedure TEditionComplete.PrepareInstance;
begin
  inherited;
  FEditeur := TEditeurComplet.Create;
  FCollection := TCollection.Create;
  FEmprunts := TEmpruntsComplet.Create;
  FCouvertures := TMyObjectList<TCouverture>.Create;
  FNotes := TStringList.Create;
end;

{ TEditionsComplet }

procedure TEditionsCompletes.Clear;
begin
  inherited;
  Editions.Clear;
end;

constructor TEditionsCompletes.Create(const Reference: TGUID; Stock: Integer);
begin
  inherited Create;
  Fill(Reference, Stock);
end;

destructor TEditionsCompletes.Destroy;
begin
  FreeAndNil(FEditions);
  inherited;
end;

procedure TEditionsCompletes.Fill(const Reference: TGUID; Stock: Integer = -1);
begin
  inherited Fill(Reference);
  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'select id_edition from editions where id_album = ?';
      if Stock in [0, 1] then
        SQL.Add('  and e.stock = :stock');
      Params.AsString[0] := GUIDToString(Reference);
      if Stock in [0, 1] then
        Params.AsInteger[1] := Stock;
      Open;
      while not Eof do
      begin
        Editions.Add(TEditionComplete.Create(StringToGUID(Fields.AsString[0])));
        Next;
      end;
    finally
      Transaction.Free;
      Free;
    end;
end;

type
  OptionFusion = record
    ImporterImages: Boolean;
    RemplacerImages: Boolean;
  end;

procedure TEditionsCompletes.FusionneInto(Dest: TEditionsCompletes);
var
  FusionsGUID: array of TGUID;
  OptionsFusion: array of OptionFusion;
  Edition: TEditionComplete;
  i, j: Integer;
begin
  if Editions.Count = 0 then
    Exit;

  SetLength(FusionsGUID, Editions.Count);
  ZeroMemory(FusionsGUID, SizeOf(FusionsGUID));
  SetLength(OptionsFusion, Editions.Count);
  ZeroMemory(OptionsFusion, SizeOf(FusionsGUID));
  // même si la destination n'a aucune données, on peut choisir de ne rien y importer
  // if Dest.Editions.Count > 0 then
  for i := 0 to Pred(Editions.Count) do
    with TfrmFusionEditions.Create(nil) do
      try
        SetEditionSrc(Editions[i]);
        // SetEditions doit être fait après SetEditionSrc
        SetEditions(Dest.Editions, FusionsGUID);

        case ShowModal of
          mrCancel:
            FusionsGUID[i] := GUID_FULL;
          mrOk:
            if CheckBox1.Checked then
              FusionsGUID[i] := GUID_NULL
            else
              FusionsGUID[i] := TEditionComplete(lbEditions.Items.Objects[lbEditions.ItemIndex]).ID_Edition;
        end;
        OptionsFusion[i].ImporterImages := CheckBox2.Checked and (Editions[i].Couvertures.Count > 0);
        OptionsFusion[i].RemplacerImages := CheckBox3.Checked and OptionsFusion[i].ImporterImages;
      finally
        Free;
      end;

  for i := 0 to Pred(Editions.Count) do
  begin
    if IsEqualGUID(FusionsGUID[i], GUID_FULL) then
      Continue;
    if IsEqualGUID(FusionsGUID[i], GUID_NULL) then
    begin
      Edition := TEditionComplete.Create;
      Edition.New;
      Dest.Editions.Add(Edition);
    end
    else
    begin
      Edition := nil;
      for j := 0 to Pred(Dest.Editions.Count) do
        if IsEqualGUID(Dest.Editions[j].ID_Edition, FusionsGUID[i]) then
        begin
          Edition := Dest.Editions[j];
          Break;
        end;
    end;
    if Assigned(Edition) then
    begin
      if not OptionsFusion[i].ImporterImages then
        Editions[i].Couvertures.Clear
      else if OptionsFusion[i].RemplacerImages then
        Edition.Couvertures.Clear;

      Editions[i].FusionneInto(Edition);
    end;
  end;
end;

procedure TEditionsCompletes.PrepareInstance;
begin
  inherited;
  FEditions := TObjectList<TEditionComplete>.Create;
end;

{ TEmprunteurComplet }

function TEmprunteurComplet.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := FormatTitre(Nom);
end;

procedure TEmprunteurComplet.Clear;
begin
  inherited;
  ID_Emprunteur := GUID_NULL;
  Nom := '';
  Adresse.Clear;
  Emprunts.Clear;
end;

destructor TEmprunteurComplet.Destroy;
begin
  FreeAndNil(FAdresse);
  FreeAndNil(FEmprunts);
  inherited;
end;

procedure TEmprunteurComplet.Fill(const Reference: TGUID);
var
  q: TUIBQuery;
begin
  inherited;
  if IsEqualGUID(Reference, GUID_NULL) then
    Exit;
  Self.ID_Emprunteur := Reference;
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'select nomemprunteur, adresseemprunteur from emprunteurs where id_emprunteur = ?';
      Params.AsString[0] := GUIDToString(Reference);
      FetchBlobs := True;
      Open;
      RecInconnu := Eof;
      if not RecInconnu then
      begin
        Self.Nom := Fields.ByNameAsString['nomemprunteur'];
        Self.Adresse.Text := Fields.ByNameAsString['adresseemprunteur'];

        Self.Emprunts.Fill(Self.ID_Emprunteur, seEmprunteur);

        Close;
      end;
    finally
      q.Transaction.Free;
      q.Free;
    end;
end;

procedure TEmprunteurComplet.PrepareInstance;
begin
  inherited;
  FAdresse := TStringList.Create;
  FEmprunts := TEmpruntsComplet.Create;
end;

procedure TEmprunteurComplet.SaveToDatabase(UseTransaction: TUIBTransaction);
var
  S: string;
begin
  inherited;
  with TUIBQuery.Create(nil) do
    try
      Transaction := UseTransaction;

      SQL.Clear;
      SQL.Add('update or insert into emprunteurs (');
      SQL.Add('  id_emprunteur, nomemprunteur, adresseemprunteur');
      SQL.Add(') values (');
      SQL.Add('  :id_emprunteur, :nomemprunteur, :adresseemprunteur');
      SQL.Add(')');

      if IsEqualGUID(GUID_NULL, ID_Emprunteur) then
        Params.ByNameIsNull['id_emprunteur'] := True
      else
        Params.ByNameAsString['id_emprunteur'] := GUIDToString(ID_Emprunteur);
      Params.ByNameAsString['nomemprunteur'] := Trim(Nom);
      S := Self.Adresse.Text;
      ParamsSetBlob('adresseemprunteur', S);

      ExecSQL;
      Transaction.Commit;
    finally
      Free;
    end;
end;

procedure TEmprunteurComplet.SetNom(const Value: string);
begin
  FNom := Copy(Value, 1, LengthNomEmprunteur);
end;

{ TSerieComplete }

class procedure TSerieComplete.GetDefaultValues;
begin
  if FGetDefaultDone then
    Exit;

  FDefaultEtat := MakeOption(-1, '');
  FDefaultReliure := MakeOption(-1, '');
  FDefaultTypeEdition := MakeOption(-1, '');
  FDefaultOrientation := MakeOption(-1, '');
  FDefaultFormatEdition := MakeOption(-1, '');
  FDefaultSensLecture := MakeOption(-1, '');

  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'select categorie, ref, libelle from listes where defaut = 1 and categorie in (1,2,3,4,5,8)';
      Open;
      while not Eof do
      begin
        case Fields.AsInteger[0] of
          1:
            FDefaultEtat := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
          2:
            FDefaultReliure := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
          3:
            FDefaultTypeEdition := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
          4:
            FDefaultOrientation := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
          5:
            FDefaultFormatEdition := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
          8:
            FDefaultSensLecture := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
        end;
        Next;
      end;
      Transaction.Commit;
    finally
      Transaction.Free;
      Free;
    end;
end;

function TSerieComplete.ChaineAffichage: string;
begin
  Result := ChaineAffichage(False);
end;

function TSerieComplete.ChaineAffichage(Simple: Boolean): string;
var
  S: string;
begin
  if Simple then
    Result := Titre
  else
    Result := FormatTitre(Titre);
  S := '';
  AjoutString(S, FormatTitre(Editeur.NomEditeur), ' ');
  AjoutString(S, FormatTitre(Collection.NomCollection), ' - ');
  AjoutString(Result, S, ' ', '(', ')');
end;

procedure TSerieComplete.ChangeNotation(Note: Integer);
begin
  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'update series set notation = ? where id_serie = ?';
      Params.AsSmallint[0] := Note;
      Params.AsString[1] := GUIDToString(ID_Serie);
      ExecSQL;
      Transaction.Commit;

      FNotation := Note;
    finally
      Transaction.Free;
      Free;
    end;
end;

procedure TSerieComplete.Clear;
begin
  inherited;
  ID_Serie := GUID_NULL;
  Titre := '';
  Albums.Clear;
  ParaBD.Clear;
  Genres.Clear;
  Sujet.Clear;
  Notes.Clear;
  Editeur.Clear;
  Collection.Clear;
  Scenaristes.Clear;
  Dessinateurs.Clear;
  Coloristes.Clear;

  GetDefaultValues;

  TypeEdition := FDefaultTypeEdition;
  Etat := FDefaultEtat;
  Reliure := FDefaultReliure;
  FormatEdition := FDefaultFormatEdition;
  Orientation := FDefaultOrientation;
  SensLecture := FDefaultSensLecture;
  Couleur := Integer(cbGrayed);
  VO := Integer(cbGrayed);
  Terminee := Integer(cbGrayed);
  SiteWeb := '';
  Complete := False;
  SuivreManquants := True;
  SuivreSorties := True;
  NbAlbums := 0;
  Notation := -1;
end;

constructor TSerieComplete.Create(const Reference, IdAuteur: TGUID);
begin
  inherited Create;
  Fill(Reference, IdAuteur);
end;

constructor TSerieComplete.Create(const Reference, IdAuteur: TGUID; Force: Boolean);
begin
  inherited Create;
  Fill(Reference, IdAuteur, Force);
end;

destructor TSerieComplete.Destroy;
begin
  FreeAndNil(FAlbums);
  FreeAndNil(FParaBD);
  FreeAndNil(FGenres);
  FreeAndNil(FSujet);
  FreeAndNil(FNotes);
  FreeAndNil(FEditeur);
  FreeAndNil(FCollection);
  FreeAndNil(FScenaristes);
  FreeAndNil(FDessinateurs);
  FreeAndNil(FColoristes);
  inherited;
end;

procedure TSerieComplete.Fill(const Reference: TGUID);
var
  q: TUIBQuery;
begin
  inherited;
  if IsEqualGUID(Reference, GUID_NULL) and (not FForce) then
    Exit;
  Self.ID_Serie := Reference;
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      FetchBlobs := True;
      SQL.Clear;
      SQL.Add('select');
      SQL.Add('  titreserie, coalesce(terminee, -1) as terminee, sujetserie, remarquesserie, siteweb, complete,');
      SQL.Add('  nb_albums, s.id_editeur, s.id_collection , nomcollection, suivresorties, suivremanquants,');
      SQL.Add('  coalesce(vo, -1) as vo, coalesce(couleur, -1) as couleur,');
      SQL.Add('  coalesce(etat, -1) as etat, le.libelle as setat, coalesce(reliure, -1) as reliure,');
      SQL.Add('  lr.libelle as sreliure, coalesce(orientation, -1) as orientation, lo.libelle as sorientation,');
      SQL.Add('  coalesce(formatedition, -1) as formatedition, lf.libelle as sformatedition,');
      SQL.Add('  coalesce(typeedition, -1) as typeedition, lte.libelle as stypeedition,');
      SQL.Add('  coalesce(senslecture, -1) as senslecture, lsl.libelle as ssenslecture, notation');
      SQL.Add('from');
      SQL.Add('  series s');
      SQL.Add('  left join collections c on');
      SQL.Add('    s.id_collection = c.id_collection');
      SQL.Add('  left join listes le on');
      SQL.Add('    (le.ref = s.etat and le.categorie = 1)');
      SQL.Add('  left join listes lr on');
      SQL.Add('    (lr.ref = s.reliure and lr.categorie = 2)');
      SQL.Add('  left join listes lte on');
      SQL.Add('    (lte.ref = s.typeedition and lte.categorie = 3)');
      SQL.Add('  left join listes lo on');
      SQL.Add('    (lo.ref = s.orientation and lo.categorie = 4)');
      SQL.Add('  left join listes lf on');
      SQL.Add('    (lf.ref = s.formatedition and lf.categorie = 5)');
      SQL.Add('  left join listes lsl on');
      SQL.Add('    (lsl.ref = s.senslecture and lsl.categorie = 8)');
      SQL.Add('where');
      SQL.Add('  id_serie = ?');
      Params.AsString[0] := GUIDToString(Reference);
      Open;
      RecInconnu := Eof;

      if not RecInconnu then
      begin
        Self.Titre := Fields.ByNameAsString['titreserie'];
        Self.Notation := Fields.ByNameAsSmallint['notation'];
        Self.Terminee := Fields.ByNameAsInteger['terminee'];
        Self.VO := Fields.ByNameAsInteger['vo'];
        Self.Couleur := Fields.ByNameAsInteger['couleur'];
        Self.SuivreSorties := RecInconnu or Fields.ByNameAsBoolean['suivresorties'];
        Self.Complete := Fields.ByNameAsBoolean['complete'];
        Self.SuivreManquants := RecInconnu or Fields.ByNameAsBoolean['suivremanquants'];
        Self.NbAlbums := Fields.ByNameAsInteger['nb_albums'];
        Self.Sujet.Text := Fields.ByNameAsString['sujetserie'];
        Self.Notes.Text := Fields.ByNameAsString['remarquesserie'];
        Self.SiteWeb := Trim(Fields.ByNameAsString['siteweb']);

        Self.TypeEdition := MakeOption(Fields.ByNameAsInteger['typeedition'], Trim(Fields.ByNameAsString['stypeedition']));
        Self.Etat := MakeOption(Fields.ByNameAsInteger['etat'], Trim(Fields.ByNameAsString['setat']));
        Self.Reliure := MakeOption(Fields.ByNameAsInteger['reliure'], Trim(Fields.ByNameAsString['sreliure']));
        Self.Orientation := MakeOption(Fields.ByNameAsInteger['orientation'], Trim(Fields.ByNameAsString['sorientation']));
        Self.FormatEdition := MakeOption(Fields.ByNameAsInteger['formatedition'], Trim(Fields.ByNameAsString['sformatedition']));
        Self.SensLecture := MakeOption(Fields.ByNameAsInteger['senslecture'], Trim(Fields.ByNameAsString['ssenslecture']));

        Self.Editeur.Fill(StringToGUIDDef(Fields.ByNameAsString['id_editeur'], GUID_NULL));
        Self.Collection.Fill(q);
        FetchBlobs := False;

        Close;
        SQL.Clear;
        SQL.Add('select');
        SQL.Add('  id_album, titrealbum, integrale, horsserie, tome, tomedebut, tomefin, id_serie, notation');
        SQL.Add('from');
        SQL.Add('  albums');
        SQL.Add('where');
        if IsEqualGUID(Reference, GUID_NULL) then
          SQL.Add('  (id_serie is null or id_serie = ?)')
        else
          SQL.Add('  id_serie = ?');
        if not IsEqualGUID(FIdAuteur, GUID_NULL) then
          SQL.Add('  and id_album in (select id_album from auteurs where id_personne = ?)');
        SQL.Add('order by');
        SQL.Add('  horsserie nulls first, integrale nulls first, tome nulls first, anneeparution, moisparution');
        Params.AsString[0] := GUIDToString(Reference);
        if not IsEqualGUID(FIdAuteur, GUID_NULL) then
          Params.AsString[1] := GUIDToString(FIdAuteur);
        Open;
        TAlbum.FillList(TList<TBasePointeur>(Self.Albums), q);

        Close;
        SQL.Clear;
        SQL.Add('select');
        SQL.Add('  id_parabd, titreparabd, id_serie, titreserie, achat, complet, scategorie');
        SQL.Add('from');
        SQL.Add('  vw_liste_parabd');
        SQL.Add('where');
        if IsEqualGUID(Reference, GUID_NULL) then
          SQL.Add('  (id_serie is null or id_serie = ?)')
        else
          SQL.Add('  id_serie = ?');
        if not IsEqualGUID(FIdAuteur, GUID_NULL) then
          SQL.Add('and id_parabd in (select id_parabd from auteurs_parabd where id_personne = ?)');
        SQL.Add('order by');
        SQL.Add('  titreparabd');
        Params.AsString[0] := GUIDToString(Reference);
        if not IsEqualGUID(FIdAuteur, GUID_NULL) then
          Params.AsString[1] := GUIDToString(FIdAuteur);
        Open;
        TParaBD.FillList(TList<TBasePointeur>(Self.ParaBD), q);

        Close;
        SQL.Clear;
        SQL.Add('select');
        SQL.Add('  g.id_genre, g.genre');
        SQL.Add('from');
        SQL.Add('  genreseries s');
        SQL.Add('  inner join genres g on');
        SQL.Add('    g.id_genre = s.id_genre');
        SQL.Add('where');
        SQL.Add('  s.id_serie = ?');
        SQL.Add('order by');
        SQL.Add('  g.genre');
        Params.AsString[0] := GUIDToString(Reference);
        Open;
        while not Eof do
        begin
          Self.Genres.Values[Fields.AsString[0]] := Fields.AsString[1];
          Next;
        end;

        Close;
        SQL.Text := 'select * from proc_auteurs(null, ?, null)';
        Params.AsString[0] := GUIDToString(Reference);
        Open;
        TAuteur.Prepare(q);
        try
          while not Eof do
          begin
            case TMetierAuteur(Fields.ByNameAsInteger['metier']) of
              maScenariste:
                Self.Scenaristes.Add(TAuteur.Make(q));
              maDessinateur:
                Self.Dessinateurs.Add(TAuteur.Make(q));
              maColoriste:
                Self.Coloristes.Add(TAuteur.Make(q));
            end;
            Next;
          end;
        finally
          TAuteur.Unprepare;
        end;
      end;
    finally
      q.Transaction.Free;
      q.Free;
    end;
end;

procedure TSerieComplete.Fill(const Reference, IdAuteur: TGUID);
begin
  FIdAuteur := IdAuteur;
  Fill(Reference);
end;

procedure TSerieComplete.Fill(const Reference, IdAuteur: TGUID; Force: Boolean);
begin
  FForce := Force;
  Fill(Reference, IdAuteur);
end;

function TSerieComplete.GetID_Collection: TGUID;
begin
  Result := Collection.ID;
end;

function TSerieComplete.GetID_Editeur: TGUID;
begin
  Result := Editeur.ID_Editeur;
end;

procedure TSerieComplete.PrepareInstance;
begin
  inherited;
  FIdAuteur := GUID_NULL;
  FForce := False;
  FAlbums := TObjectList<TAlbum>.Create(True);
  FParaBD := TObjectList<TParaBD>.Create(True);
  FGenres := TStringList.Create;
  FSujet := TStringList.Create;
  FNotes := TStringList.Create;
  FEditeur := TEditeurComplet.Create;
  FCollection := TCollection.Create;
  FScenaristes := TObjectList<TAuteur>.Create(True);
  FDessinateurs := TObjectList<TAuteur>.Create(True);
  FColoristes := TObjectList<TAuteur>.Create(True);
end;

procedure TSerieComplete.SaveToDatabase(UseTransaction: TUIBTransaction);
var
  S: string;
  i: Integer;
  Auteur: TAuteur;
begin
  inherited;
  with TUIBQuery.Create(nil) do
    try
      Transaction := UseTransaction;

      SQL.Clear;
      SQL.Add('update or insert into series (');
      SQL.Add('  id_serie, titreserie, terminee, suivresorties, complete, suivremanquants, siteweb, id_editeur,');
      SQL.Add('  id_collection, sujetserie, remarquesserie, nb_albums, vo, couleur, etat, reliure, typeedition,');
      SQL.Add('  orientation, formatedition, senslecture');
      SQL.Add(') values (');
      SQL.Add('  :id_serie, :titreserie, :terminee, :suivresorties, :complete, :suivremanquants, :siteweb, :id_editeur,');
      SQL.Add('  :id_collection, :sujetserie, :remarquesserie, :nb_albums, :vo, :couleur, :etat, :reliure, :typeedition,');
      SQL.Add('  :orientation, :formatedition, :senslecture');
      SQL.Add(')');

      if IsEqualGUID(GUID_NULL, ID_Serie) then
        Params.ByNameIsNull['id_serie'] := True
      else
        Params.ByNameAsString['id_serie'] := GUIDToString(ID_Serie);
      Params.ByNameAsString['titreserie'] := Trim(Self.Titre);
      if TCheckBoxState(Self.Terminee) = cbGrayed then
        Params.ByNameIsNull['terminee'] := True
      else
        Params.ByNameAsInteger['terminee'] := Self.Terminee;
      if TCheckBoxState(Self.VO) = cbGrayed then
        Params.ByNameIsNull['vo'] := True
      else
        Params.ByNameAsInteger['vo'] := Self.VO;
      if TCheckBoxState(Self.Couleur) = cbGrayed then
        Params.ByNameIsNull['couleur'] := True
      else
        Params.ByNameAsInteger['couleur'] := Self.Couleur;
      Params.ByNameAsInteger['typeedition'] := TypeEdition.Value;
      Params.ByNameAsInteger['etat'] := Etat.Value;
      Params.ByNameAsInteger['reliure'] := Reliure.Value;
      Params.ByNameAsInteger['orientation'] := Orientation.Value;
      Params.ByNameAsInteger['formatedition'] := FormatEdition.Value;
      Params.ByNameAsInteger['senslecture'] := SensLecture.Value;
      Params.ByNameAsBoolean['suivresorties'] := Self.SuivreSorties;
      Params.ByNameAsBoolean['complete'] := Self.Complete;
      Params.ByNameAsBoolean['suivremanquants'] := Self.SuivreManquants;
      if Self.NbAlbums > 0 then
        Params.ByNameAsInteger['nb_albums'] := Self.NbAlbums
      else
        Params.ByNameIsNull['nb_albums'] := True;
      Params.ByNameAsString['siteweb'] := Trim(Self.SiteWeb);
      if IsEqualGUID(Self.ID_Editeur, GUID_NULL) then
      begin
        Params.ByNameIsNull['id_editeur'] := True;
        Params.ByNameIsNull['id_collection'] := True;
      end
      else
      begin
        Params.ByNameAsString['id_editeur'] := GUIDToString(Self.ID_Editeur);
        if IsEqualGUID(Self.ID_Collection, GUID_NULL) then
          Params.ByNameIsNull['id_collection'] := True
        else
          Params.ByNameAsString['id_collection'] := GUIDToString(Self.ID_Collection);
      end;
      S := Self.Sujet.Text;
      if S <> '' then
        ParamsSetBlob('sujetserie', S)
      else
        Params.ByNameIsNull['sujetserie'] := True;
      S := Self.Notes.Text;
      if S <> '' then
        ParamsSetBlob('remarquesserie', S)
      else
        Params.ByNameIsNull['remarquesserie'] := True;

      ExecSQL;

      SupprimerToutDans('', 'genreseries', 'id_serie', ID_Serie);
      SQL.Clear;
      SQL.Add('insert into genreseries (id_serie, id_genre) values (:id_serie, :id_genre)');
      Prepare(True);
      for i := 0 to Pred(Genres.Count) do
      begin
        Params.AsString[0] := GUIDToString(ID_Serie);
        Params.AsString[1] := Copy(Genres.Names[i], 1, Params.SQLLen[1]);
        ExecSQL;
      end;

      SupprimerToutDans('', 'auteurs_series', 'id_serie', ID_Serie);
      SQL.Clear;
      SQL.Add('insert into auteurs_series (');
      SQL.Add('  id_serie, metier, id_personne');
      SQL.Add(') values (');
      SQL.Add('  :id_serie, :metier, :id_personne');
      SQL.Add(')');
      for Auteur in Scenaristes do
      begin
        Params.AsString[0] := GUIDToString(ID_Serie);
        Params.AsInteger[1] := 0;
        Params.AsString[2] := GUIDToString(Auteur.Personne.ID);
        ExecSQL;
      end;
      for Auteur in Dessinateurs do
      begin
        Params.AsString[0] := GUIDToString(ID_Serie);
        Params.AsInteger[1] := 1;
        Params.AsString[2] := GUIDToString(Auteur.Personne.ID);
        ExecSQL;
      end;
      for Auteur in Coloristes do
      begin
        Params.AsString[0] := GUIDToString(ID_Serie);
        Params.AsInteger[1] := 2;
        Params.AsString[2] := GUIDToString(Auteur.Personne.ID);
        ExecSQL;
      end;

      Transaction.Commit;
    finally
      Free;
    end;
end;

procedure TSerieComplete.SetID_Collection(const Value: TGUID);
begin
  Collection.Fill(Value);
end;

procedure TSerieComplete.SetID_Editeur(const Value: TGUID);
begin
  Editeur.Fill(Value);
end;

procedure TSerieComplete.SetSiteWeb(const Value: string);
begin
  FSiteWeb := Copy(Value, 1, LengthURL);
end;

procedure TSerieComplete.SetTitre(const Value: string);
begin
  FTitre := Copy(Value, 1, LengthTitreSerie);
end;

{ TEditeurComplet }

procedure TEditeurComplet.Clear;
begin
  inherited;
  ID_Editeur := GUID_NULL;
  FNomEditeur := '';
  FSiteWeb := '';
end;

procedure TEditeurComplet.Fill(const Reference: TGUID);
var
  q: TUIBQuery;
begin
  inherited;
  if IsEqualGUID(Reference, GUID_NULL) then
    Exit;
  Self.ID_Editeur := Reference;
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'select nomediteur, siteweb from editeurs where id_editeur = ?';
      Params.AsString[0] := GUIDToString(Reference);
      Open;
      RecInconnu := Eof;

      if not RecInconnu then
      begin
        Self.NomEditeur := Fields.ByNameAsString['nomediteur'];
        Self.SiteWeb := Trim(Fields.ByNameAsString['siteweb']);
      end;
    finally
      q.Transaction.Free;
      q.Free;
    end;
end;

procedure TEditeurComplet.SaveToDatabase(UseTransaction: TUIBTransaction);
begin
  inherited;
  with TUIBQuery.Create(nil) do
    try
      Transaction := UseTransaction;

      SQL.Clear;
      SQL.Add('update or insert into editeurs (');
      SQL.Add('  id_editeur, nomediteur, siteweb');
      SQL.Add(') values (');
      SQL.Add('  :id_editeur, :nomediteur, :siteweb');
      SQL.Add(')');

      if IsEqualGUID(GUID_NULL, ID_Editeur) then
        Params.ByNameIsNull['id_editeur'] := True
      else
        Params.ByNameAsString['id_editeur'] := GUIDToString(ID_Editeur);
      Params.ByNameAsString['nomediteur'] := Trim(NomEditeur);
      Params.ByNameAsString['siteweb'] := Trim(SiteWeb);
      ExecSQL;
      Transaction.Commit;
    finally
      Free;
    end;
end;

procedure TEditeurComplet.SetNomEditeur(const Value: string);
begin
  FNomEditeur := Copy(Value, 1, LengthNomEditeur);
end;

procedure TEditeurComplet.SetSiteWeb(const Value: string);
begin
  FSiteWeb := Copy(Value, 1, LengthURL);
end;

{ TStats }

procedure TStats.Clear;
begin
  inherited;
  ListEmprunteursMax.Clear;
  ListEmprunteursMin.Clear;
  ListAlbumsMax.Clear;
  ListAlbumsMin.Clear;
  ListGenre.Clear;
  ListEditeurs.Clear;
  ListEditeurs.Clear;
end;

constructor TStats.Create(Complete: Boolean);
begin
  inherited Create;
  Fill(Complete);
end;

procedure TStats.CreateStats(Stats: TStats);
begin
  CreateStats(Stats, GUID_NULL, '');
end;

procedure TStats.CreateStats(Stats: TStats; const ID_Editeur: TGUID; const Editeur: string);
var
  q: TUIBQuery;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  Stats.FEditeur := Editeur;
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Add('select count(a.id_album) from albums a inner join editions e on a.id_album = e.id_album');
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('and e.id_editeur = ' + QuotedStr(GUIDToString(ID_Editeur)))
      else
        SQL.Add('');
      SQL.Add('');
      Open;
      Stats.FNbAlbums := Fields.AsInteger[0];
      Close;
      SQL[2] := 'where e.couleur = 0';
      Open;
      Stats.FNbAlbumsNB := Fields.AsInteger[0];
      Close;
      SQL[2] := 'where e.vo = 1';
      Open;
      Stats.FNbAlbumsVO := Fields.AsInteger[0];
      Close;
      SQL[2] := 'where e.stock = 1';
      Open;
      Stats.FNbAlbumsStock := Fields.AsInteger[0];
      Close;
      SQL[2] := 'where e.dedicace = 1';
      Open;
      Stats.FNbAlbumsDedicace := Fields.AsInteger[0];
      Close;
      SQL[2] := 'where e.offert = 1';
      Open;
      Stats.FNbAlbumsOffert := Fields.AsInteger[0];
      Close;
      SQL[2] := 'where e.gratuit = 1';
      Open;
      Stats.FNbAlbumsGratuit := Fields.AsInteger[0];
      Close;
      SQL[2] := 'where a.integrale = 1';
      Open;
      Stats.FNbAlbumsIntegrale := Fields.AsInteger[0];
      Close;
      SQL[2] := 'where a.horsserie = 1';
      Open;
      Stats.FNbAlbumsHorsSerie := Fields.AsInteger[0];
      Close;

      SQL.Clear;
      SQL.Add('select count(distinct a.id_serie) from albums a');
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('inner join editions e on e.id_album = a.id_album and e.id_editeur=' + QuotedStr(GUIDToString(ID_Editeur)))
      else
        SQL.Add('');
      Open;
      Stats.FNbSeries := Fields.AsInteger[0];
      Close;
      SQL.Add('left join series s on a.id_serie = s.id_serie');
      SQL.Add('');
      SQL[3] := 'where s.terminee = 1';
      Open;
      Stats.FNbSeriesTerminee := Fields.AsInteger[0];
      Close;

      SQL.Text := 'select min(a.anneeparution) as minannee, max(a.anneeparution) as maxannee from albums a';
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('inner join editions e on e.id_album = a.id_album and e.id_editeur=' + QuotedStr(GUIDToString(ID_Editeur)));
      Open;
      Stats.FMinAnnee := 0;
      Stats.FMaxAnnee := 0;
      if not Eof then
      begin
        Stats.FMinAnnee := Fields.ByNameAsInteger['minannee'];
        Stats.FMaxAnnee := Fields.ByNameAsInteger['maxannee'];
      end;

      Close;
      SQL.Clear;
      SQL.Add('select');
      SQL.Add('  count(g.id_genre) as quantitegenre, g.id_genre, g.genre');
      SQL.Add('from');
      SQL.Add('  genreseries gs');
      SQL.Add('  inner join genres g on');
      SQL.Add('    gs.id_genre = g.id_genre');
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
      begin
        SQL.Add('  inner join albums a on');
        SQL.Add('    a.id_serie = gs.id_serie');
        SQL.Add('  inner join editions e on');
        SQL.Add('    e.id_album = a.id_album');
        SQL.Add('    and e.id_editeur=' + QuotedStr(GUIDToString(ID_Editeur)));
      end;
      SQL.Add('group by');
      SQL.Add('  g.genre, g.id_genre');
      SQL.Add('order by');
      SQL.Add('  1 desc');
      Open;
      TGenre.FillList(TList<TBasePointeur>(Stats.ListGenre), q);

      Close;
      SQL.Clear;
      SQL.Add('select');
      SQL.Add('  sum(prix) as sumprix, count(prix) as countprix, min(prix) as minprix, max(prix) as maxprix');
      SQL.Add('from');
      SQL.Add('  editions');
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('where id_editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
      Open;
      Stats.FValeurConnue := Fields.ByNameAsCurrency['sumprix'];
      Stats.FPrixAlbumMoyen := 0;
      Stats.FPrixAlbumMinimun := 0;
      Stats.FPrixAlbumMaximun := 0;
      if not Eof and Fields.ByNameAsBoolean['countprix'] then
      begin
        Stats.FPrixAlbumMoyen := Fields.ByNameAsCurrency['sumprix'] / Fields.ByNameAsInteger['countprix'];
        Stats.FPrixAlbumMinimun := Fields.ByNameAsCurrency['minprix'];
        Stats.FPrixAlbumMaximun := Fields.ByNameAsCurrency['maxprix'];
      end;

      Close;
      SQL.Clear;
      SQL.Add('select');
      SQL.Add('  count(id_edition) as countref');
      SQL.Add('from');
      SQL.Add('  editions');
      SQL.Add('where');
      SQL.Add('  prix is null');
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('  and id_editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
      Open;
      Stats.FNbAlbumsSansPrix := 0;
      if not Eof then
        Stats.FNbAlbumsSansPrix := Fields.ByNameAsInteger['countref'] - Stats.NbAlbumsGratuit;
      Stats.FValeurEstimee := Stats.ValeurConnue + Stats.NbAlbumsSansPrix * Stats.PrixAlbumMoyen;

      Close;
      SQL.Text := 'select count(distinct st.id_emprunteur) from statut st';
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('inner join editions e on e.id_edition = st.id_edition and e.id_editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
      Open;
      Stats.FNbEmprunteurs := Fields.AsInteger[0];

      Close;
      SQL.Text := 'select count(st.id_emprunteur)/' + IntToStr(Stats.NbEmprunteurs) + ' as moy from statut st';
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('inner join editions e on e.id_edition = st.id_edition and e.id_editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
      SQL.Add('where st.pretemprunt = 1');
      Stats.FMoyEmprunteurs := 0;
      if LongBool(Stats.FNbEmprunteurs) then
      begin
        Open;
        Stats.FMoyEmprunteurs := Fields.ByNameAsInteger['moy'];
      end;

      Close;
      SQL.Clear;
      SQL.Add('select');
      SQL.Add('  count(e.id_emprunteur) as countnumero, e.nomemprunteur, e.id_emprunteur');
      SQL.Add('from');
      SQL.Add('  statut st');
      SQL.Add('  inner join emprunteurs e on');
      SQL.Add('    e.id_emprunteur = st.id_emprunteur');
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('  inner join editions ed on ed.id_edition = st.id_edition and ed.id_editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
      SQL.Add('where');
      SQL.Add('  (st.pretemprunt = 1)');
      SQL.Add('group by');
      SQL.Add('  e.id_emprunteur, e.nomemprunteur');
      SQL.Add('order by');
      SQL.Add('  1 desc, e.nomemprunteur desc');
      Open;
      Stats.FMinEmprunteurs := 0;
      Stats.FMaxEmprunteurs := 0;
      if not Eof then
      begin
        Stats.FMaxEmprunteurs := Fields.ByNameAsInteger['countnumero'];
        while not Eof do
          Next; // last;
        Stats.FMinEmprunteurs := Fields.ByNameAsInteger['countnumero'];
        if Stats.FMinEmprunteurs = Stats.FMaxEmprunteurs then
          Stats.FMinEmprunteurs := 0;
        Close;
        Open;
        repeat
          if Fields.ByNameAsInteger['countnumero'] in [Stats.MinEmprunteurs, Stats.MaxEmprunteurs] then
          begin
            if Fields.ByNameAsInteger['countnumero'] = Stats.MinEmprunteurs then
              Stats.ListEmprunteursMin.Insert(0, TEmprunteur.Make(q))
            else
              Stats.ListEmprunteursMax.Insert(0, TEmprunteur.Make(q));
          end;
          Next;
        until Eof;
      end;

      Close;
      SQL.Clear;
      SQL.Add('select count(distinct st.id_edition) from statut st');
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('inner join editions e on e.id_edition = st.id_edition and e.id_editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
      Open;
      Stats.FNbEmpruntes := Fields.AsInteger[0];

      Close;
      SQL.Text := 'select count(st.id_edition)/' + IntToStr(Stats.FNbEmpruntes) + ' as moy from statut st';
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('inner join editions e on e.id_edition = st.id_edition and e.id_editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
      SQL.Add('where st.pretemprunt = 1');
      Stats.FMoyEmpruntes := 0;
      if LongBool(Stats.FNbEmpruntes) then
      begin
        Open;
        Stats.FMoyEmpruntes := Fields.ByNameAsInteger['moy'];
      end;

      Close;
      SQL.Clear;
      SQL.Add('select distinct');
      SQL.Add('  count(id_edition)');
      SQL.Add('from');
      SQL.Add('  vw_emprunts');
      SQL.Add('where');
      SQL.Add('  (pretemprunt = 1)');
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('  and id_editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
      SQL.Add('group by');
      SQL.Add('  id_edition');
      SQL.Add('order by');
      SQL.Add('  1');
      Open;
      Stats.FMinEmpruntes := 0;
      Stats.FMaxEmpruntes := 0;
      if not Eof then
      begin
        Stats.FMaxEmpruntes := Fields.AsInteger[0];
        while not Eof do
          Next; // Last;
        Stats.FMinEmpruntes := Fields.AsInteger[0];
        if Stats.FMinEmpruntes = Stats.MaxEmpruntes then
          Stats.FMinEmpruntes := 0;

        Close;
        SQL.Clear;
        SQL.Add('select');
        SQL.Add('  *');
        SQL.Add('from');
        SQL.Add('  vw_emprunts');
        SQL.Add('where');
        SQL.Add('  (pretemprunt = 1)');
        if not IsEqualGUID(ID_Editeur, GUID_NULL) then
          SQL.Add('and id_editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
        SQL.Add('  and id_edition in (select id_edition from statut where pretemprunt = 1 group by id_edition having count(id_edition) = :countedition)');
        Params.AsInteger[0] := Stats.MaxEmpruntes;
        Open;
        while not Eof do
        begin
          Stats.ListAlbumsMax.Insert(0, TAlbum.Make(q));
          Next;
        end;
        if (Stats.MinEmpruntes > 0) and (Stats.MinEmpruntes <> Stats.MaxEmpruntes) then
        begin
          Close;
          Params.AsInteger[0] := Stats.MinEmpruntes;
          Open;
          while not Eof do
          begin
            Stats.ListAlbumsMin.Insert(0, TAlbum.Make(q));
            Next;
          end;
        end;
      end;
    finally
      Transaction.Free;
      Free;
    end;
end;

destructor TStats.Destroy;
begin
  FreeAndNil(FListEmprunteursMax);
  FreeAndNil(FListEmprunteursMin);
  FreeAndNil(FListAlbumsMax);
  FreeAndNil(FListAlbumsMin);
  FreeAndNil(FListGenre);
  FreeAndNil(FListEditeurs);
  inherited;
end;

procedure TStats.Fill(Complete: Boolean);
var
  PS: TStats;
  q: TUIBQuery;
  hg: IHourGlass;
begin
  inherited Fill(GUID_NULL);
  hg := THourGlass.Create;
  CreateStats(Self);
  if Complete then
  begin
    q := TUIBQuery.Create(nil);
    with q do
      try
        Transaction := GetTransaction(DMPrinc.UIBDataBase);
        Close;
        SQL.Clear;
        SQL.Add('select distinct');
        SQL.Add('  ed.id_editeur, e.nomediteur');
        SQL.Add('from');
        SQL.Add('  editions ed');
        SQL.Add('  inner join editeurs e on');
        SQL.Add('    ed.id_editeur = e.id_editeur');
        SQL.Add('order by');
        SQL.Add('  e.nomediteur');
        Open;
        while not Eof do
        begin
          PS := TStats.Create;
          ListEditeurs.Add(PS);
          CreateStats(PS, StringToGUID(Fields.AsString[0]), Trim(Fields.AsString[1]));
          Next;
        end;
      finally
        Transaction.Free;
        Free;
      end;
  end;
end;

procedure TStats.PrepareInstance;
begin
  inherited;
  FListEmprunteursMax := TObjectList<TEmprunteur>.Create;
  FListAlbumsMax := TObjectList<TAlbum>.Create;
  FListEmprunteursMin := TObjectList<TEmprunteur>.Create;
  FListAlbumsMin := TObjectList<TAlbum>.Create;
  FListGenre := TObjectList<TGenre>.Create;
  FListEditeurs := TObjectList<TStats>.Create;
end;

{ TEmpruntsComplet }

procedure TEmpruntsComplet.Clear;
begin
  inherited;
  FNBEmprunts := 0;
  Emprunts.Clear;
end;

constructor TEmpruntsComplet.Create(const Reference: TGUID; Source: TSrcEmprunt; Sens: TSensEmprunt; Apres, Avant: TDateTime;
  EnCours, Stock: Boolean);
begin
  inherited Create;
  Fill(Reference, Source, Sens, Apres, Avant, EnCours, Stock);
end;

destructor TEmpruntsComplet.Destroy;
begin
  FreeAndNil(FEmprunts);
  inherited;
end;

procedure TEmpruntsComplet.Fill(const Reference: TGUID; Source: TSrcEmprunt; Sens: TSensEmprunt; Apres, Avant: TDateTime; EnCours, Stock: Boolean);
var
  q: TUIBQuery;

  procedure MakeQuery;
  var
    i: Integer;
  begin
    q.SQL.Text := 'select * from vw_emprunts';

    with TStringList.Create do
      try
        case Source of
          seAlbum: Add('id_edition = ' + QuotedStr(GUIDToString(Reference)));
          seEmprunteur: Add('id_emprunteur = ' + QuotedStr(GUIDToString(Reference)));
          seTous: ;
        end;
        if EnCours then
          Add('prete = 1');
        case Sens of
          ssPret: Add('pretemprunt = 1');
          ssRetour: Add('pretemprunt = 0');
          ssTous: ;
        end;
        if Apres >= 0 then
          Add('dateemprunt >= :dateapres');
        if Avant >= 0 then
          Add('dateemprunt <= :dateavant');

        for i := 0 to Count - 1 do
        begin
          if i = 0 then
            q.SQL.Add('where')
          else
            q.SQL.Add('and');
          q.SQL.Add(Strings[i]);
        end;
        q.SQL.Add('order by dateemprunt desc, id_statut asc'); // le dernier saisi a priorité en cas de "même date"
      finally
        Free;
      end;
    if Apres >= 0 then
      q.Params.ByNameAsDateTime['dateapres'] := Apres;
    if Avant >= 0 then
      q.Params.ByNameAsDateTime['dateavant'] := Avant;
  end;

var
  PE: TEmprunt;
  S: TStringList;
  Ref: string;
begin
  inherited Fill(GUID_NULL);
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      S := TStringList.Create;
      Self.NBEmprunts := 0;
      try
        MakeQuery;
        Open;
        S.Clear;
        while not Eof do
        begin
          Ref := Fields.ByNameAsString['id_edition'];
          if not Stock or (S.IndexOf(Ref) = -1) then
          begin
            S.Add(Ref);
            PE := TEmprunt(TEmprunt.Make(q));
            if PE.Pret then
              Inc(Self.FNBEmprunts);
            Self.Emprunts.Add(PE);
          end;
          Next;
        end;
      finally
        S.Free;
      end;
    finally
      Transaction.Free;
      Free;
    end;
end;

procedure TEmpruntsComplet.PrepareInstance;
begin
  inherited;
  FEmprunts := TObjectList<TEmprunt>.Create;
end;

{ TSeriesIncompletes }

procedure TSeriesIncompletes.Clear;
begin
  inherited;
  Series.Clear;
end;

constructor TSeriesIncompletes.Create(AvecIntegrales, AvecAchats: Boolean);
begin
  inherited Create;
  Fill(AvecIntegrales, AvecAchats, GUID_NULL);
end;

constructor TSeriesIncompletes.Create(const ID_Serie: TGUID);
begin
  inherited Create;
  Fill(ID_Serie);
end;

destructor TSeriesIncompletes.Destroy;
begin
  FreeAndNil(FSeries);
  inherited;
end;

procedure TSeriesIncompletes.Fill(AvecIntegrales, AvecAchats: Boolean; const ID_Serie: TGUID);
var
  q: TUIBQuery;
  CurrentSerie, dummy: TGUID;
  iDummy, FirstTome, CurrentTome: Integer;

  procedure UpdateSerie;
  var
    i: Integer;
  begin
    with Self.Series[Pred(Self.Series.Count)] do
      if CurrentTome > FirstTome + 1 then
        NumerosManquants.Add(Format('%d<>%d', [FirstTome, CurrentTome]))
      else
        for i := FirstTome to CurrentTome do
          NumerosManquants.Add(IntToStr(i));
  end;

var
  Incomplete: TSerieIncomplete;
begin
  inherited Fill(GUID_NULL);
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'select * from albums_manquants(:withintegrales, :withachats, :id_serie) order by titreserie, tome';
      Params.AsBoolean[0] := AvecIntegrales;
      Params.AsBoolean[1] := AvecAchats;
      if not IsEqualGUID(ID_Serie, GUID_NULL) then
        Params.AsString[2] := GUIDToString(ID_Serie);
      Open;
      CurrentSerie := GUID_NULL;
      FirstTome := -1;
      CurrentTome := -1;
      while not Eof do
      begin
        dummy := StringToGUID(Fields.ByNameAsString['id_serie']);
        if not IsEqualGUID(dummy, CurrentSerie) then
        begin
          if not IsEqualGUID(CurrentSerie, GUID_NULL) then
            UpdateSerie;
          Incomplete := TSerieIncomplete.Create;
          Self.Series.Add(Incomplete);
          Incomplete.Serie.Fill(q);
          CurrentSerie := dummy;
          FirstTome := Fields.ByNameAsInteger['tome'];
          CurrentTome := FirstTome;
        end
        else
        begin
          iDummy := Fields.ByNameAsInteger['tome'];
          if iDummy <> CurrentTome + 1 then
          begin
            UpdateSerie;
            FirstTome := iDummy;
          end;
          CurrentTome := iDummy;
        end;
        Next;
      end;
      if not IsEqualGUID(CurrentSerie, GUID_NULL) then
        UpdateSerie;
    finally
      Transaction.Free;
      Free;
    end;
end;

procedure TSeriesIncompletes.Fill(const Reference: TGUID);
begin
  Fill(True, True, Reference);
end;

procedure TSeriesIncompletes.PrepareInstance;
begin
  inherited;
  FSeries := TObjectList<TSerieIncomplete>.Create(True);
end;

{ TPrevisionsSorties }

procedure TPrevisionsSorties.Clear;
begin
  inherited;
  AnneesPassees.Clear;
  AnneeEnCours.Clear;
  AnneesProchaines.Clear;
end;

constructor TPrevisionsSorties.Create(AvecAchats: Boolean);
begin
  inherited Create;
  Fill(AvecAchats);
end;

constructor TPrevisionsSorties.Create(const ID_Serie: TGUID);
begin
  inherited Create;
  Fill(ID_Serie);
end;

destructor TPrevisionsSorties.Destroy;
begin
  FreeAndNil(FAnneesPassees);
  FreeAndNil(FAnneeEnCours);
  FreeAndNil(FAnneesProchaines);
  inherited;
end;

procedure TPrevisionsSorties.Fill(AvecAchats: Boolean; const ID_Serie: TGUID);
var
  q: TUIBQuery;
  Annee, CurrentAnnee: Integer;
  Prevision: TPrevisionSortie;
begin
  inherited Fill(GUID_NULL);
  CurrentAnnee := YearOf(Now);
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Clear;
      SQL.Add('select');
      SQL.Add('  *');
      SQL.Add('from');
      SQL.Add('  previsions_sorties(:withachats, :id_serie)');
      SQL.Add('order by');
      SQL.Add('  anneeparution,');
      SQL.Add('  case');
      SQL.Add('    when moisparution between 1 and 4 then 1');
      SQL.Add('    when moisparution between 5 and 8 then 2');
      SQL.Add('    when moisparution between 9 and 12 then 3');
      SQL.Add('    else 0');
      SQL.Add('  end,');
      SQL.Add('  titreserie');
      Params.AsBoolean[0] := AvecAchats;
      if not IsEqualGUID(ID_Serie, GUID_NULL) then
        Params.AsString[1] := GUIDToString(ID_Serie);
      Open;
      while not Eof do
      begin
        Annee := Fields.ByNameAsInteger['anneeparution'];
        Prevision := TPrevisionSortie.Create;
        Prevision.Serie.Fill(q);
        Prevision.Tome := Fields.ByNameAsInteger['tome'];
        Prevision.Annee := Annee;
        Prevision.Mois := Fields.ByNameAsInteger['moisparution'];
        if Annee < CurrentAnnee then
          Self.AnneesPassees.Add(Prevision)
        else if Annee > CurrentAnnee then
          Self.AnneesProchaines.Add(Prevision)
        else
          Self.AnneeEnCours.Add(Prevision);
        Next;
      end;
    finally
      Transaction.Free;
      Free;
    end;
end;

procedure TPrevisionsSorties.Fill(const Reference: TGUID);
begin
  Fill(True, Reference);
end;

procedure TPrevisionsSorties.Fill(AvecAchats: Boolean);
begin
  Fill(AvecAchats, GUID_NULL);
end;

procedure TPrevisionsSorties.PrepareInstance;
begin
  inherited;
  FAnneesPassees := TObjectList<TPrevisionSortie>.Create(True);
  FAnneeEnCours := TObjectList<TPrevisionSortie>.Create(True);
  FAnneesProchaines := TObjectList<TPrevisionSortie>.Create(True);
end;

{ TPrevisionSortie }

constructor TPrevisionSortie.Create;
begin
  inherited;
  FSerie := TSerie.Create;
end;

destructor TPrevisionSortie.Destroy;
begin
  FreeAndNil(FSerie);
  inherited;
end;

function TPrevisionSortie.GetsAnnee: string;
begin
  Result := IntToStr(Annee);
  if Mois > 0 then
    Result := Choose(Mois - 1, ['début', 'début', 'début', 'début', 'mi', 'mi', 'mi', 'mi', 'fin', 'fin', 'fin', 'fin']) + ' ' + Result;
end;

{ TSerieIncomplete }

function TSerieIncomplete.ChaineAffichage: string;
var
  S: string;
  i: Integer;
begin
  Result := '';
  for i := 0 to NumerosManquants.Count - 1 do
  begin
    S := NumerosManquants[i];
    if Pos('<>', S) <> 0 then
      S := StringReplace(S, '<>', ' à ', []);
    AjoutString(Result, S, ', ');
  end;
end;

destructor TSerieIncomplete.Destroy;
begin
  FreeAndNil(FSerie);
  FreeAndNil(FNumerosManquants);
  inherited;
end;

procedure TSerieIncomplete.PrepareInstance;
begin
  inherited;
  FNumerosManquants := TStringList.Create;
  FSerie := TSerie.Create;
end;

{ TAuteurComplet }

function TAuteurComplet.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := FormatTitre(NomAuteur);
end;

procedure TAuteurComplet.Clear;
begin
  inherited;
  Series.Clear;
end;

destructor TAuteurComplet.Destroy;
begin
  FreeAndNil(FSeries);
  FreeAndNil(FBiographie);
  inherited;
end;

procedure TAuteurComplet.Fill(const Reference: TGUID);
var
  q: TUIBQuery;
begin
  inherited;
  if IsEqualGUID(Reference, GUID_NULL) then
    Exit;
  Self.ID_Auteur := Reference;
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'select nompersonne, siteweb, biographie from personnes where id_personne = ?';
      Params.AsString[0] := GUIDToString(Reference);
      FetchBlobs := True;
      Open;
      RecInconnu := Eof;

      if not RecInconnu then
      begin
        Self.NomAuteur := Fields.ByNameAsString['nompersonne'];
        Self.Biographie.Text := Fields.ByNameAsString['biographie'];
        Self.SiteWeb := Trim(Fields.ByNameAsString['siteweb']);
        FetchBlobs := False;

        SQL.Clear;
        // TitreSerie en premier pour forcer l'union à trier sur le titre
        SQL.Add('select');
        SQL.Add('  titreserie, al.id_serie');
        SQL.Add('from');
        SQL.Add('  vw_liste_albums al');
        SQL.Add('  inner join auteurs au on');
        SQL.Add('    al.id_album = au.id_album and au.id_personne = :id_personne');
        SQL.Add('union');
        SQL.Add('select');
        SQL.Add('  titreserie, s.id_serie');
        SQL.Add('from');
        SQL.Add('  auteurs_series au');
        SQL.Add('  inner join series s on');
        SQL.Add('    s.id_serie = au.id_serie and au.id_personne = :id_personne');
        SQL.Add('union');
        SQL.Add('select');
        SQL.Add('  titreserie, p.id_serie');
        SQL.Add('from');
        SQL.Add('  auteurs_parabd ap');
        SQL.Add('  inner join vw_liste_parabd p on');
        SQL.Add('    ap.id_parabd = p.id_parabd and ap.id_personne = :id_personne');
        Params.ByNameAsString['id_personne'] := GUIDToString(Reference);
        Open;
        while not Eof do
        begin
          if Fields.IsNull[1] then
            Series.Insert(0, TSerieComplete.Create(GUID_NULL, ID_Auteur, True))
          else
            Series.Add(TSerieComplete.Create(StringToGUID(Fields.AsString[1]), ID_Auteur, True));
          Next;
        end;
      end;
    finally
      q.Transaction.Free;
      q.Free;
    end;
end;

procedure TAuteurComplet.PrepareInstance;
begin
  inherited;
  FSeries := TObjectList<TSerieComplete>.Create(True);
  FBiographie := TStringList.Create;
end;

procedure TAuteurComplet.SaveToDatabase(UseTransaction: TUIBTransaction);
var
  S: string;
  q: TUIBQuery;
begin
  inherited;
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := UseTransaction;

      SQL.Clear;
      SQL.Add('update or insert into personnes (id_');
      SQL.Add('  personne, nompersonne, siteweb, biographie');
      SQL.Add(') values (');
      SQL.Add('  :id_personne, :nompersonne, :siteweb, :biographie');
      SQL.Add(')');

      if IsEqualGUID(GUID_NULL, ID_Auteur) then
        Params.ByNameIsNull['id_personne'] := True
      else
        Params.ByNameAsString['id_personne'] := GUIDToString(ID_Auteur);
      Params.ByNameAsString['nompersonne'] := Trim(NomAuteur);
      Params.ByNameAsString['siteweb'] := Trim(SiteWeb);
      S := Biographie.Text;
      ParamsSetBlob('biographie', S);
      ExecSQL;

      Transaction.Commit;
    finally
      Free;
    end;
end;

procedure TAuteurComplet.SetNomAuteur(const Value: string);
begin
  FNomAuteur := Copy(Value, 1, LengthNomAuteur);
end;

procedure TAuteurComplet.SetSiteWeb(const Value: string);
begin
  FSiteWeb := Copy(Value, 1, LengthURL);
end;

{ TParaBDComplet }

function TParaBDComplet.ChaineAffichage(AvecSerie: Boolean): string;
begin
  Result := ChaineAffichage(False, AvecSerie);
end;

procedure TParaBDComplet.Acheter(Prevision: Boolean);
begin
  if IsEqualGUID(ID_ParaBD, GUID_NULL) then
    Exit;
  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'update parabd set achat = :achat where id_parabd = ?';
      Params.AsBoolean[0] := Prevision;
      Params.AsString[1] := GUIDToString(ID_ParaBD);
      Execute;
      Transaction.Commit;
    finally
      Transaction.Free;
      Free;
    end;
end;

function TParaBDComplet.ChaineAffichage(Simple, AvecSerie: Boolean): string;
var
  S: string;
begin
  if Simple then
    Result := Titre
  else
    Result := FormatTitre(Titre);
  S := '';
  if AvecSerie then
    if Result = '' then
      Result := FormatTitre(Serie.Titre)
    else
      AjoutString(S, FormatTitre(Serie.Titre), ' - ');
  AjoutString(S, CategorieParaBD.Caption, ' - ');
  if Result = '' then
    Result := S
  else
    AjoutString(Result, S, ' ', '(', ')');
end;

procedure TParaBDComplet.Clear;
begin
  inherited;
  ID_ParaBD := GUID_NULL;
  Titre := '';

  Auteurs.Clear;
  Description.Clear;
  Serie.Clear;
end;

destructor TParaBDComplet.Destroy;
begin
  FreeAndNil(FAuteurs);
  FreeAndNil(FSerie);
  FreeAndNil(FDescription);
  inherited;
end;

procedure TParaBDComplet.Fill(const Reference: TGUID);
var
  q: TUIBQuery;
  Serie: TGUID;
begin
  inherited;
  if IsEqualGUID(Reference, GUID_NULL) then
    Exit;
  Self.ID_ParaBD := Reference;
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      FetchBlobs := True;
      SQL.Clear;
      SQL.Add('select');
      SQL.Add('  titreparabd, annee, id_serie, achat, description, dedicace, numerote, anneecote, prixcote,');
      SQL.Add('  gratuit, offert, dateachat, prix, stock, categorieparabd, lc.libelle as scategorieparabd,');
      SQL.Add('  fichierparabd, stockageparabd, case when imageparabd is null then 0 else 1 end as hasblobimage');
      SQL.Add('from');
      SQL.Add('  parabd p');
      SQL.Add('  left join listes lc on');
      SQL.Add('    (lc.ref = p.categorieparabd and lc.categorie = 7)');
      SQL.Add('where');
      SQL.Add('  id_parabd = ?');

      Params.AsString[0] := GUIDToString(Reference);
      Open;
      RecInconnu := Eof;

      if not RecInconnu then
      begin
        Self.Titre := Fields.ByNameAsString['titreparabd'];
        Self.AnneeEdition := Fields.ByNameAsInteger['annee'];
        Self.Description.Text := Fields.ByNameAsString['description'];
        Self.CategorieParaBD := MakeOption(Fields.ByNameAsInteger['categorieparabd'], Fields.ByNameAsString['scategorieparabd']);
        Self.Prix := Fields.ByNameAsCurrency['prix'];
        Self.Dedicace := Fields.ByNameAsBoolean['dedicace'];
        Self.Numerote := Fields.ByNameAsBoolean['numerote'];
        Self.Offert := Fields.ByNameAsBoolean['offert'];
        Self.Gratuit := Fields.ByNameAsBoolean['gratuit'];
        Self.Stock := Fields.ByNameAsBoolean['stock'];
        Self.DateAchat := Fields.ByNameAsDate['dateachat'];
        Self.AnneeCote := Fields.ByNameAsInteger['anneecote'];
        Self.PrixCote := Fields.ByNameAsCurrency['prixcote'];

        Serie := StringToGUIDDef(Fields.ByNameAsString['id_serie'], GUID_NULL);

        ImageStockee := Fields.ByNameAsBoolean['stockageparabd'];
        FichierImage := Fields.ByNameAsString['fichierparabd'];
        HasImage := (Fields.ByNameAsSmallint['hasblobimage'] = 1) or (FichierImage <> '');

        OldImageStockee := ImageStockee;
        OldFichierImage := FichierImage;
        OldHasImage := HasImage;

        Close;
        SQL.Text := 'select * from proc_auteurs(null, null, ?)';
        Params.AsString[0] := GUIDToString(Reference);
        Open;
        TAuteur.FillList(TList<TBasePointeur>(Self.Auteurs), q);

        Self.Serie.Fill(Serie);
      end;
    finally
      q.Transaction.Free;
      q.Free;
    end;
end;

function TParaBDComplet.Get_sDateAchat: string;
begin
  if Self.DateAchat > 0 then
    Result := DateToStr(Self.DateAchat)
  else
    Result := '';
end;

procedure TParaBDComplet.SaveToDatabase(UseTransaction: TUIBTransaction);
var
  S: string;
  q: TUIBQuery;
  hg: IHourGlass;
  Stream: TStream;
  Auteur: TAuteur;
begin
  inherited;
  hg := THourGlass.Create;
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := UseTransaction;

      SQL.Clear;
      SQL.Add('update or insert into parabd (');
      SQL.Add('  id_parabd, titreparabd, annee, id_serie, categorieparabd, dedicace, numerote, anneecote,');
      SQL.Add('  prixcote, gratuit, offert, dateachat, prix, stock, description, complet');
      SQL.Add(') values (');
      SQL.Add('  :id_parabd, :titreparabd, :annee, :id_serie, :categorieparabd, :dedicace, :numerote, :anneecote,');
      SQL.Add('  :prixcote, :gratuit, :offert, :dateachat, :prix, :stock, :description, 1');
      SQL.Add(')');

      if IsEqualGUID(GUID_NULL, ID_ParaBD) then
        Params.ByNameIsNull['id_parabd'] := True
      else
        Params.ByNameAsString['id_parabd'] := GUIDToString(ID_ParaBD);
      S := Trim(Titre);
      if S = '' then
        Params.ByNameIsNull['titreparabd'] := True
      else
        Params.ByNameAsString['titreparabd'] := S;
      if AnneeEdition = 0 then
        Params.ByNameIsNull['annee'] := True
      else
        Params.ByNameAsInteger['annee'] := AnneeEdition;
      Params.ByNameAsInteger['categorieparabd'] := CategorieParaBD.Value;
      Params.ByNameAsBoolean['dedicace'] := Dedicace;
      Params.ByNameAsBoolean['numerote'] := Numerote;
      S := Description.Text;
      if S <> '' then
        ParamsSetBlob('description', S)
      else
        Params.ByNameIsNull['description'] := True;
      Params.ByNameAsBoolean['gratuit'] := Gratuit;
      Params.ByNameAsBoolean['offert'] := Offert;

      if DateAchat = 0 then
        Params.ByNameIsNull['dateachat'] := True
      else
        Params.ByNameAsDate['dateachat'] := Trunc(DateAchat);
      if Prix = 0 then
        Params.ByNameIsNull['prix'] := True
      else
        Params.ByNameAsCurrency['prix'] := Prix;
      if (AnneeCote = 0) or (PrixCote = 0) then
      begin
        Params.ByNameIsNull['anneecote'] := True;
        Params.ByNameIsNull['prixcote'] := True;
      end
      else
      begin
        Params.ByNameAsInteger['anneecote'] := AnneeCote;
        Params.ByNameAsCurrency['prixcote'] := PrixCote;
      end;
      Params.ByNameAsBoolean['stock'] := Stock;

      if Serie.RecInconnu or IsEqualGUID(Serie.ID_Serie, GUID_NULL) then
        Params.ByNameIsNull['id_serie'] := True
      else
        Params.ByNameAsString['id_serie'] := GUIDToString(Serie.ID_Serie);
      ExecSQL;

      SupprimerToutDans('', 'auteurs_parabd', 'id_parabd', ID_ParaBD);
      SQL.Clear;
      SQL.Add('insert into auteurs_parabd (');
      SQL.Add('  id_parabd, id_personne');
      SQL.Add(') values (');
      SQL.Add('  :id_album, :id_personne');
      SQL.Add(')');
      for Auteur in Auteurs do
      begin
        Params.AsString[0] := GUIDToString(ID_ParaBD);
        Params.AsString[1] := GUIDToString(Auteur.Personne.ID);
        ExecSQL;
      end;

      if not HasImage then
      begin
        SQL.Text := 'update parabd set imageparabd = null, stockageparabd = 0, fichierparabd = null where id_parabd = :id_parabd';
        Params.ByNameAsString['id_parabd'] := GUIDToString(ID_ParaBD);
        ExecSQL;
      end
      else if (OldFichierImage <> FichierImage) or (OldImageStockee <> ImageStockee) then
      begin
        if ImageStockee then
        begin
          SQL.Text := 'update parabd set imageparabd = :imageparabd, stockageparabd = 1, fichierparabd = :fichierparabd where id_parabd = :id_parabd';
          if ExtractFilePath(FichierImage) = '' then
            FichierImage := IncludeTrailingPathDelimiter(RepImages) + FichierImage;
          Stream := GetCouvertureStream(FichierImage, -1, -1, False);
          try
            ParamsSetBlob('imageparabd', Stream);
          finally
            Stream.Free;
          end;
          Params.ByNameAsString['fichierparabd'] := ExtractFileName(FichierImage);
        end
        else
        begin
          SQL.Text := 'select result from saveblobtofile(:chemin, :fichier, :blobcontent)';
          if ExtractFilePath(FichierImage) = '' then
            Stream := GetCouvertureStream(True, ID_ParaBD, -1, -1, False)
          else
            Stream := GetCouvertureStream(FichierImage, -1, -1, False);
          try
            FichierImage := SearchNewFileName(RepImages, ExtractFileName(FichierImage), True);
            Params.ByNameAsString['chemin'] := RepImages;
            Params.ByNameAsString['fichier'] := FichierImage;
            ParamsSetBlob('blobcontent', Stream);
          finally
            Stream.Free;
          end;
          Open;

          SQL.Text := 'update parabd set imageparabd = null, stockageparabd = 0, fichierparabd = :fichierparabd where id_parabd = :id_parabd';
          Params.ByNameAsString['fichierparabd'] := FichierImage;
        end;
        Params.ByNameAsString['id_parabd'] := GUIDToString(ID_ParaBD);
        ExecSQL;
      end;

      Transaction.Commit;
    finally
      Free;
    end;
end;

procedure TParaBDComplet.SetTitre(const Value: string);
begin
  FTitre := Copy(Value, 1, LengthTitreParaBD);
end;

procedure TParaBDComplet.PrepareInstance;
begin
  inherited;
  FDescription := TStringList.Create;
  FAuteurs := TObjectList<TAuteur>.Create;
  FSerie := TSerieComplete.Create;
end;

{ TCollectionComplete }

procedure TCollectionComplete.Clear;
begin
  inherited;
  Editeur.Clear;
end;

destructor TCollectionComplete.Destroy;
begin
  FreeAndNil(FEditeur);
  inherited;
end;

procedure TCollectionComplete.Fill(const Reference: TGUID);
var
  q: TUIBQuery;
begin
  inherited;
  if IsEqualGUID(Reference, GUID_NULL) then
    Exit;
  Self.ID_Collection := Reference;
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'select nomcollection, id_editeur from collections where id_collection = ?';
      Params.AsString[0] := GUIDToString(Reference);
      Open;
      RecInconnu := Eof;

      if not RecInconnu then
      begin
        Self.NomCollection := Fields.ByNameAsString['nomcollection'];
        Self.ID_Editeur := StringToGUIDDef(Fields.ByNameAsString['id_editeur'], GUID_NULL);
      end;
    finally
      Transaction.Free;
      Free;
    end;
end;

function TCollectionComplete.GetID_Editeur: TGUID;
begin
  Result := Editeur.ID;
end;

procedure TCollectionComplete.PrepareInstance;
begin
  inherited;
  FEditeur := TEditeur.Create;
end;

procedure TCollectionComplete.SaveToDatabase(UseTransaction: TUIBTransaction);
begin
  inherited;
  with TUIBQuery.Create(nil) do
    try
      Transaction := UseTransaction;

      SQL.Clear;
      SQL.Add('update or insert into collections (');
      SQL.Add('  id_collection, nomcollection, id_editeur');
      SQL.Add(') values (');
      SQL.Add('  :id_collection, :nomcollection, :id_editeur');
      SQL.Add(')');

      if IsEqualGUID(GUID_NULL, ID_Collection) then
        Params.ByNameIsNull['id_collection'] := True
      else
        Params.ByNameAsString['id_collection'] := GUIDToString(ID_Collection);
      Params.ByNameAsString['nomcollection'] := Trim(NomCollection);
      Params.ByNameAsString['id_editeur'] := GUIDToString(ID_Editeur);
      ExecSQL;
      Transaction.Commit;
    finally
      Free;
    end;
end;

procedure TCollectionComplete.SetID_Editeur(const Value: TGUID);
begin
  Editeur.Fill(Value);
end;

procedure TCollectionComplete.SetNomCollection(const Value: string);
begin
  FNomCollection := Copy(Value, 1, LengthNomCollection);
end;

{ TObjetComplet }

function TObjetComplet.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := '';
end;

procedure TObjetComplet.Clear;
begin
  inherited;
  FID := GUID_NULL;
  RecInconnu := True;
  FAssociations.Clear;
end;

constructor TObjetComplet.Create(const Reference: TGUID);
begin
  inherited Create;
  Fill(Reference);
end;

destructor TObjetComplet.Destroy;
begin
  FAssociations.Free;
  inherited;
end;

procedure TObjetComplet.FillAssociations(TypeData: TVirtualMode);
begin
  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'select chaine, always from import_associations where typedata = :typedata and id = :id and always = 1';
      Params.AsInteger[0] := Integer(TypeData);
      Params.AsString[1] := GUIDToString(ID);
      Open;
      while not Eof do
      begin
        FAssociations.Add(Fields.AsString[0]);
        Next;
      end;
    finally
      Transaction.Free;
      Free;
    end;
end;

procedure TObjetComplet.New(ClearInstance: Boolean = True);
var
  newId: TGUID;
begin
  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'select udf_createguid() from rdb$database';
      Open;
      newId := StringToGUIDDef(Fields.AsString[0], GUID_NULL);
      FID := newId;
      RecInconnu := True;
    finally
      Transaction.Free;
      Free;
    end;

  // utilisation d'une variable temporaire à cause du const dans la déclaration de Fill:
  // effet de bord TRES TRES indésirable
  if ClearInstance then
    Fill(newId);
end;

procedure TObjetComplet.PrepareInstance;
begin
  inherited;
  FAssociations := TStringList.Create;
end;

procedure TObjetComplet.SaveToDatabase;
var
  Transaction: TUIBTransaction;
begin
  Assert(not IsEqualGUID(ID, GUID_NULL), 'L''ID ne peut être GUID_NULL');

  Transaction := GetTransaction(DMPrinc.UIBDataBase);
  try
    SaveToDatabase(Transaction);
    Transaction.Commit;
    RecInconnu := False;
  finally
    Transaction.Free;
  end;
end;

procedure TObjetComplet.SaveAssociations(TypeData: TVirtualMode; const ParentID: TGUID);
var
  i: Integer;
begin
  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'delete from import_associations where typedata = :typedata and id = :id and always = 1';
      Params.AsInteger[0] := Integer(TypeData);
      Params.AsString[1] := GUIDToString(ID);
      Execute;

      SQL.Text := 'update or insert into import_associations (chaine, id, parentid, typedata, always) values (:chaine, :id, :parentid, :typedata, 1)';
      Prepare(True);
      for i := 0 to Pred(FAssociations.Count) do
      begin
        if Trim(FAssociations[i]) <> '' then
        begin
          Params.AsString[0] := Copy(Trim(FAssociations[i]), 1, Params.SQLLen[0]);
          Params.AsString[1] := GUIDToString(ID);
          Params.AsString[2] := GUIDToString(ParentID);
          Params.AsInteger[3] := Integer(TypeData);
          Execute;
        end;
        Next;
      end;
    finally
      Transaction.Free;
      Free;
    end;
end;

procedure TObjetComplet.SaveToDatabase(UseTransaction: TUIBTransaction);
begin
  Assert(not IsEqualGUID(ID, GUID_NULL), 'L''ID ne peut être GUID_NULL');
end;

{ TRecherche }

procedure TRecherche.Clear;
begin
  inherited;
  Resultats.Clear;
  ResultatsInfos.Clear;
  TypeRecherche := trAucune;
end;

constructor TRecherche.Create;
begin
  inherited;
end;

procedure TRecherche.ClearCriteres;
begin
  Criteres.SousCriteres.Clear;
  SortBy.Clear;
  TypeRecherche := trAucune;
end;

constructor TRecherche.Create(Recherche: TRechercheSimple; const ID: TGUID; const Libelle: string);
begin
  inherited Create;
  PrepareInstance;
  Fill(Recherche, ID, Libelle);
end;

procedure TRecherche.Fill;
var
  slFrom, slWhere: TStringList;

  function ProcessTables: string;
  var
    i: Integer;
  begin
    // Tables possibles:
    // ALBUMS
    // SERIES
    // EDITIONS
    // GENRESERIES

    Result := 'albums inner join editions on albums.id_album = editions.id_album left join series on albums.id_serie = series.id_serie';
    slFrom.Delete(slFrom.IndexOf('albums'));
    slFrom.Delete(slFrom.IndexOf('series'));
    slFrom.Delete(slFrom.IndexOf('editions'));
    i := slFrom.IndexOf('genreseries');
    if i <> -1 then
    begin
      Result := Result + ' left outer join genreseries on genreseries.id_serie = albums.id_serie';
      slFrom.Delete(i);
    end;
  end;

  function ProcessSort(out sOrderBy: string): string;
  var
    Critere: TCritereTri;
    S: string;
  begin
    sOrderBy := '';
    Result := '';
    for Critere in SortBy do
    begin
      Critere._Champ := ChampByID(Critere.iChamp);
      S := Critere.NomTable + '.' + Critere.Champ;
      Result := Result + ', ' + S;
      if not Critere.Asc then
        S := S + ' desc';
      if Critere.NullsFirst then
        S := S + ' nulls first'
      else if Critere.NullsLast then
        S := S + ' nulls last';
      sOrderBy := sOrderBy + S + ', ';
      slFrom.Add(Critere.NomTable);
    end;
  end;

  function ProcessCritere(ItemCritere: TGroupCritere): string;
  var
    p: TBaseCritere;
    sBool: string;
  begin
    Result := '';
    if ItemCritere.GroupOption = goOu then
      sBool := ' or '
    else
      sBool := ' and ';
    for p in ItemCritere.SousCriteres do
      if p is TCritere then
      begin
        if Result = '' then
          Result := '(' + TCritere(p).TestSQL + ')'
        else
          Result := Result + sBool + '(' + TCritere(p).TestSQL + ')';
        slFrom.Add(TCritere(p).NomTable);
      end
      else
      begin
        if Result = '' then
          Result := '(' + ProcessCritere(p as TGroupCritere) + ')'
        else
          Result := Result + sBool + '(' + ProcessCritere(p as TGroupCritere) + ')';
      end;
  end;

var
  Album: TAlbum;
  q: TUIBQuery;
  sWhere, sOrderBy, S: string;
  CritereTri: TCritereTri;
begin
  inherited Fill(GUID_NULL);

  q := TUIBQuery.Create(nil);
  slFrom := TStringList.Create;
  slFrom.Sorted := True;
  slFrom.Duplicates := dupIgnore;
  slFrom.Delimiter := ',';
  slWhere := TStringList.Create;
  with q do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Clear;
      SQL.Add('select distinct');
      SQL.Add('  albums.id_album, albums.titrealbum, albums.tome, albums.tomedebut, albums.tomefin,');
      SQL.Add('  albums.horsserie, albums.integrale, albums.moisparution, albums.anneeparution, albums.id_serie,');
      SQL.Add('  series.titreserie');
      SQL.Add(ProcessSort(sOrderBy));
      slFrom.Add('albums');
      slFrom.Add('series');
      slFrom.Add('editions');
      sWhere := ProcessCritere(Criteres);

      SQL.Add('from ' + ProcessTables);

      if sWhere <> '' then
        SQL.Add('where ' + sWhere);

      SQL.Add('order by');
      SQL.Add('  ' + sOrderBy);
      SQL.Add('  coalesce(albums.titrealbum, series.titreserie), series.titreserie, albums.horsserie nulls first,');
      SQL.Add('  albums.integrale nulls first, albums.tome nulls first, albums.tomedebut nulls first,');
      SQL.Add('  albums.tomefin nulls first, albums.anneeparution nulls first, albums.moisparution nulls first');

      Open;
      while not Eof do
      begin
        Album := TAlbum.Create;
        Album.Fill(q);
        Resultats.Add(Album);
        S := '';
        for CritereTri in SortBy do
          if CritereTri.Imprimer then
          begin
            AjoutString(S, CritereTri.LabelChamp + ' : ', #13#10);
            if Fields.ByNameIsNull[CritereTri.Champ] then
              S := S + '<vide>'
            else if CritereTri._Champ.Booleen then
              S := S + IIf(Fields.ByNameAsBoolean[CritereTri.Champ], 'Oui', 'Non')
            else
              case CritereTri._Champ.Special of
                csISBN: S := S + FormatISBN(Fields.ByNameAsString[CritereTri.Champ]);
                csTitre: S := S + FormatTitre(Fields.ByNameAsString[CritereTri.Champ]);
                csMonnaie: S := S + FormatCurr(FormatMonnaie, Fields.ByNameAsCurrency[CritereTri.Champ]);
                else case CritereTri._Champ.TypeData of
                    uftDate: S := S + FormatDateTime('dd mmm yyyy', Fields.ByNameAsDate[CritereTri.Champ]);
                    uftTime: S := S + FormatDateTime('hh:mm:ss', Fields.ByNameAsTime[CritereTri.Champ]);
                    uftTimestamp: S := S + FormatDateTime('dd mmm yyyy, hh:mm:ss', Fields.ByNameAsDateTime[CritereTri.Champ]);
                    else S := S + StringReplace(AdjustLineBreaks(Fields.ByNameAsString[CritereTri.Champ], tlbsCRLF), #13#10, '\n', [rfReplaceAll]);
                    end;
                end;
          end;
        ResultatsInfos.Add(S);
        Next;
      end;
      if Resultats.Count > 0 then
        TypeRecherche := trComplexe
      else
        TypeRecherche := trAucune;
    finally
      Transaction.Free;
      Free;
      slFrom.Free;
      slWhere.Free;
    end;
end;

destructor TRecherche.Destroy;
begin
  ClearCriteres;
  FreeAndNil(ResultatsInfos);
  FreeAndNil(Resultats);
  FreeAndNil(Criteres);
  FreeAndNil(SortBy);
  inherited;
end;

procedure TRecherche.Fill(Recherche: TRechercheSimple; const ID: TGUID; const Libelle: string);
const
  Proc: array [0 .. 4] of string = ('albums_by_auteur(?, null)', 'albums_by_serie(?, null)', 'albums_by_editeur(?, null)',
    'albums_by_genre(?, null)', 'albums_by_collection(?, null)');
var
  q: TUIBQuery;
  S: string;
  Album: TAlbum;
  oldID_Album: TGUID;
  oldIndex: Integer;
begin
  inherited Fill(GUID_NULL);
  if not IsEqualGUID(ID, GUID_NULL) then
  begin
    q := TUIBQuery.Create(nil);
    with q do
      try
        Transaction := GetTransaction(DMPrinc.UIBDataBase);
        SQL.Text := 'select * from ' + Proc[Integer(Recherche)];
        Params.AsString[0] := GUIDToString(ID);
        FLibelle := Libelle;
        Open;
        oldID_Album := GUID_NULL;
        oldIndex := -1;
        S := '';
        while not Eof do
        begin
          if IsEqualGUID(oldID_Album, StringToGUID(Fields.ByNameAsString['id_album'])) and (oldIndex <> -1) then
          begin
            if Recherche = rsAuteur then
            begin
              S := ResultatsInfos[oldIndex];
              case TMetierAuteur(Fields.ByNameAsInteger['metier']) of
                maScenariste: AjoutString(S, rsTransScenario, ', ');
                maDessinateur: AjoutString(S, rsTransDessins, ', ');
                maColoriste: AjoutString(S, rsTransCouleurs, ', ');
              end;
              ResultatsInfos[oldIndex] := S;
            end;
          end
          else
          begin
            Album := TAlbum.Create;
            Album.Fill(q);
            Resultats.Add(Album);
            if Recherche = rsAuteur then
              case TMetierAuteur(Fields.ByNameAsInteger['metier']) of
                maScenariste: oldIndex := ResultatsInfos.Add(rsTransScenario);
                maDessinateur: oldIndex := ResultatsInfos.Add(rsTransDessins);
                maColoriste: oldIndex := ResultatsInfos.Add(rsTransCouleurs);
              end
            else
              ResultatsInfos.Add('');
          end;
          oldID_Album := StringToGUID(Fields.ByNameAsString['id_album']);
          Next;
        end;
        if Resultats.Count > 0 then
          TypeRecherche := trSimple
        else
          TypeRecherche := trAucune;
      finally
        Transaction.Free;
        Free;
      end;
  end;
end;

procedure TRecherche.PrepareInstance;
begin
  inherited;
  Resultats := TObjectList<TAlbum>.Create(True);
  ResultatsInfos := TStringList.Create;
  Criteres := TGroupCritere.Create(nil);
  SortBy := TObjectList<TCritereTri>.Create(True);
end;

function TRecherche.AddCritere(Parent: TGroupCritere): TCritere;
begin
  if not Assigned(Parent) then
    Parent := Criteres;
  Result := TCritere.Create(Parent);
  TypeRecherche := trAucune;
end;

function TRecherche.AddGroup(Parent: TGroupCritere): TGroupCritere;
begin
  if not Assigned(Parent) then
    Parent := Criteres;
  Result := TGroupCritere.Create(Parent);
  TypeRecherche := trAucune;
end;

procedure TRecherche.Delete(Item: TBaseCritere);
begin
  if Item = Criteres then
    ClearCriteres
  else
    Item.Parent.SousCriteres.Remove(Item);
  TypeRecherche := trAucune;
end;

procedure TRecherche.LoadFromStream(Stream: TStream);

  function ReadInteger: Integer;
  begin
    Stream.read(Result, SizeOf(Integer));
  end;

  function ReadString: string;
  var
    l: Integer;
  begin
    l := ReadInteger;
    SetLength(Result, l);
    Stream.read(Result[1], l);
  end;

  function CreateCritere(CritereType: Integer; ParentCritere: TBaseCritere): TBaseCritere;
  begin
    Assert(not Assigned(ParentCritere) or (ParentCritere is TGroupCritere), 'Architecture des critères incorrecte.');
    case CritereType of
      0: Result := AddGroup(ParentCritere as TGroupCritere);
      1: Result := AddCritere(ParentCritere as TGroupCritere);
      else raise Exception.Create('Type de critère inconnu: ' + IntToStr(CritereType));
      end;
    Result.LoadFromStream(Stream);
  end;

var
  lvl, CritereType, i: Integer;
  ACritere, NextCritere: TBaseCritere;
begin
  ClearCriteres;
  Stream.Position := 0;

  for i := 1 to ReadInteger do
    AddSort.LoadFromStream(Stream);

  ReadInteger; // level de la racine
  ReadInteger; // type de la racine
  Criteres.LoadFromStream(Stream);
  ACritere := Criteres;
  while Stream.Position < Stream.Size do
  begin
    lvl := ReadInteger;
    CritereType := ReadInteger;
    if ACritere = nil then
      ACritere := CreateCritere(CritereType, nil)
    else if ACritere.Level = lvl then
      ACritere := CreateCritere(CritereType, ACritere.Parent)
    else if ACritere.Level = (lvl - 1) then
      ACritere := CreateCritere(CritereType, ACritere)
    else if ACritere.Level > lvl then
    begin
      NextCritere := ACritere.Parent;
      while NextCritere.Level > lvl do
        NextCritere := NextCritere.Parent;
      ACritere := CreateCritere(CritereType, NextCritere.Parent);
    end;
  end;
end;

procedure TRecherche.SaveToStream(Stream: TStream);

  procedure WriteInteger(Value: Integer);
  begin
    Stream.write(Value, SizeOf(Integer));
  end;

  procedure WriteCritere(Critere: TBaseCritere);
  begin
    WriteInteger(Critere.Level);
    if Critere is TGroupCritere then
      WriteInteger(0)
    else if Critere is TCritere then
      WriteInteger(1)
    else
      raise Exception.Create('Type de critère inconnu: ' + Critere.ClassName);
    Critere.SaveToStream(Stream);
  end;

  procedure ProcessSousCriteres(ACritere: TGroupCritere);
  var
    Critere: TBaseCritere;
  begin
    for Critere in ACritere.SousCriteres do
    begin
      WriteCritere(Critere);
      if (Critere is TGroupCritere) then
        ProcessSousCriteres(TGroupCritere(Critere));
    end;
  end;

  procedure WriteSortBy;
  var
    CritereTri: TCritereTri;
  begin
    WriteInteger(SortBy.Count);
    for CritereTri in SortBy do
      CritereTri.SaveToStream(Stream);
  end;

begin
  Stream.Size := 0;
  WriteSortBy;
  WriteCritere(Criteres);
  ProcessSousCriteres(Criteres);
end;

procedure TRecherche.Delete(Item: TCritereTri);
begin
  SortBy.Remove(Item);
  TypeRecherche := trAucune;
end;

function TRecherche.AddSort: TCritereTri;
begin
  Result := TCritereTri.Create;
  SortBy.Add(Result);
  TypeRecherche := trAucune;
end;

{ TCritere }

procedure TCritere.Assign(S: TCritere);
begin
  Champ := S.Champ;
  Test := S.Test;
  NomTable := S.NomTable;
  TestSQL := S.TestSQL;
  iChamp := S.iChamp;
  iSignes := S.iSignes;
  iCritere2 := S.iCritere2;
  valeurText := S.valeurText;
end;

procedure TCritere.LoadFromStream(Stream: TStream);

  function ReadInteger: Integer;
  begin
    Stream.read(Result, SizeOf(Integer));
  end;

  function ReadString: string;
  var
    l: Integer;
  begin
    l := ReadInteger;
    SetLength(Result, l);
    Stream.read(Result[1], l * SizeOf(Char));
  end;

begin
  inherited;
  Champ := ReadString;
  Test := ReadString;
  NomTable := ReadString;
  TestSQL := ReadString;
  iChamp := ReadInteger;
  iSignes := ReadInteger;
  iCritere2 := ReadInteger;
  valeurText := ReadString;
end;

procedure TCritere.SaveToStream(Stream: TStream);

  procedure WriteInteger(Value: Integer);
  begin
    Stream.write(Value, SizeOf(Integer));
  end;

  procedure WriteString(const Value: string);
  var
    l: Integer;
  begin
    l := Length(Value);
    WriteInteger(l);
    Stream.WriteBuffer(Value[1], l * SizeOf(Char));
  end;

begin
  inherited;
  WriteString(Champ);
  WriteString(Test);
  WriteString(NomTable);
  WriteString(TestSQL);
  WriteInteger(iChamp);
  WriteInteger(iSignes);
  WriteInteger(iCritere2);
  WriteString(valeurText);
end;

{ TGroupCritere }

constructor TGroupCritere.Create(Parent: TGroupCritere);
begin
  inherited;
  SousCriteres := TObjectList<TBaseCritere>.Create(True);
end;

destructor TGroupCritere.Destroy;
begin
  FreeAndNil(SousCriteres);
  inherited;
end;

procedure TGroupCritere.LoadFromStream(Stream: TStream);
begin
  inherited;
  Stream.read(GroupOption, SizeOf(Byte));
end;

procedure TGroupCritere.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.write(Byte(GroupOption), SizeOf(Byte));
end;

{ TBaseCritere }

{ TBaseCritere }

constructor TBaseCritere.Create(AParent: TGroupCritere);
begin
  inherited Create;
  Parent := AParent;
  if Assigned(AParent) then
  begin
    Level := AParent.Level + 1;
    Parent.SousCriteres.Add(Self);
  end
  else
    Level := 0;
end;

procedure TBaseCritere.LoadFromStream(Stream: TStream);
begin

end;

procedure TBaseCritere.SaveToStream(Stream: TStream);
begin

end;

{ TCritereTri }

procedure TCritereTri.Assign(S: TCritereTri);
begin
  Champ := S.Champ;
  LabelChamp := S.LabelChamp;
  NomTable := S.NomTable;
  Asc := S.Asc;
  NullsFirst := S.NullsFirst;
  NullsLast := S.NullsLast;
  iChamp := S.iChamp;
  Imprimer := S.Imprimer;
end;

procedure TCritereTri.LoadFromStream(Stream: TStream);

  function ReadInteger: Integer;
  begin
    Stream.read(Result, SizeOf(Integer));
  end;

  function ReadBool: Boolean;
  var
    dummy: Byte;
  begin
    Stream.read(dummy, SizeOf(Byte));
    Result := dummy = 1;
  end;

  function ReadString: string;
  var
    l: Integer;
  begin
    l := ReadInteger;
    SetLength(Result, l);
    Stream.read(Result[1], l * SizeOf(Char));
  end;

begin
  inherited;
  LabelChamp := ReadString;
  Champ := ReadString;
  NomTable := ReadString;
  iChamp := ReadInteger;
  Asc := ReadBool;
  NullsFirst := ReadBool;
  NullsLast := ReadBool;
  Imprimer := ReadBool;
end;

procedure TCritereTri.SaveToStream(Stream: TStream);

  procedure WriteInteger(Value: Integer);
  begin
    Stream.write(Value, SizeOf(Integer));
  end;

  procedure WriteBool(Value: Boolean);
  var
    dummy: Byte;
  begin
    if Value then
      dummy := 1
    else
      dummy := 0;
    Stream.write(dummy, SizeOf(Byte));
  end;

  procedure WriteString(const Value: string);
  var
    l: Integer;
  begin
    l := Length(Value);
    WriteInteger(l);
    Stream.WriteBuffer(Value[1], l * SizeOf(Char));
  end;

begin
  WriteString(LabelChamp);
  WriteString(Champ);
  WriteString(NomTable);
  WriteInteger(iChamp);
  WriteBool(Asc);
  WriteBool(NullsFirst);
  WriteBool(NullsLast);
  WriteBool(Imprimer);
end;

end.
