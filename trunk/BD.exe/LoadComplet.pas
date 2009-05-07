unit LoadComplet;

interface

uses
  SysUtils, Windows, Classes, Dialogs, TypeRec, Commun, CommonConst, UdmPrinc, UIB, DateUtils, ListOfTypeRec, Contnrs, UChampsRecherche,
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
    procedure WriteString(Stream: TStream; const Chaine: string);
    procedure WriteStringLN(Stream: TStream; const Chaine: string);
  public
    constructor Create; virtual;
    procedure Fill(const Reference: TGUID); virtual;
    procedure BeforeDestruction; override;
    procedure Clear; virtual;
    procedure PrepareInstance; virtual;
    procedure WriteXMLToStream(Stream: TStream); virtual;
  end;

  TObjetComplet = class(TBaseComplet)
  private
    FAssociations: TStringList;
  protected
    FID: TGUID;
  published
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
    procedure SaveAssociations(TypeData: TVirtualMode; ParentID: TGUID);
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
  private
    FNBEmprunts: Integer;
    FEmprunts: TObjectList<TEmprunt>;
  public
    constructor Create(const Reference: TGUID; Source: TSrcEmprunt = seTous; Sens: TSensEmprunt = ssTous; Apres: TDateTime = -1; Avant: TDateTime = -1; EnCours: Boolean = False; Stock: Boolean = False); reintroduce; overload;
    destructor Destroy; override;
    procedure Fill(const Reference: TGUID; Source: TSrcEmprunt = seTous; Sens: TSensEmprunt = ssTous; Apres: TDateTime = -1; Avant: TDateTime = -1; EnCours: Boolean = False; Stock: Boolean = False); reintroduce;
    procedure Clear; override;
    procedure PrepareInstance; override;
  published
    property Emprunts: TObjectList<TEmprunt> read FEmprunts;
    property NBEmprunts: Integer read FNBEmprunts write FNBEmprunts;
  end;

  TEditeurComplet = class(TObjetComplet)
  private
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
  private
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
  private
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
    function GetID_Editeur: TGUID; inline;
    procedure SetID_Editeur(const Value: TGUID); inline;
    function GetID_Collection: TGUID; inline;
    procedure SetID_Collection(const Value: TGUID); inline;
    procedure SetTitre(const Value: string); inline;
    procedure SetSiteWeb(const Value: string); inline;
  strict private
    class var FGetDefaultDone: Boolean;
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
    property Albums: TObjectList<TAlbum> read FAlbums;
    property ParaBD: TObjectList<TParaBD> read FParaBD;
    property Scenaristes: TObjectList<TAuteur> read FScenaristes;
    property Dessinateurs: TObjectList<TAuteur> read FDessinateurs;
    property Coloristes: TObjectList<TAuteur> read FColoristes;
    property VO: Integer read FVO write FVO;
    property Couleur: Integer read FCouleur write FCouleur;
    property Etat: ROption read FEtat write FEtat;
    property Reliure: ROption read FReliure write FReliure;
    property TypeEdition: ROption read FTypeEdition write FTypeEdition;
    property FormatEdition: ROption read FFormatEdition write FFormatEdition;
    property Orientation: ROption read FOrientation write FOrientation;
    property SensLecture: ROption read FSensLecture write FSensLecture;
  end;

  TAuteurComplet = class(TObjetComplet)
  private
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
    property Series: TObjectList<TSerieComplete> read FSeries;
  end;

  TEditionComplete = class(TObjetComplet)
  private
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
    class var FGetDefaultDone: Boolean;
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
    property NumeroPerso: string{[25]} read FNumeroPerso write SetNumeroPerso;
    property Emprunts: TEmpruntsComplet read FEmprunts;
    property Couvertures: TMyObjectList<TCouverture> read FCouvertures;
  end;

  TEditionsCompletes = class(TListComplet)
  private
    FEditions: TObjectList<TEditionComplete>;
  public
    procedure Fill(const Reference: TGUID; Stock: Integer = -1); reintroduce;
    procedure PrepareInstance; override;
    procedure Clear; override;
    constructor Create(const Reference: TGUID; Stock: Integer = -1); reintroduce; overload;
    destructor Destroy; override;
    procedure FusionneInto(Dest: TEditionsCompletes);
  published
    property Editions: TObjectList<TEditionComplete> read FEditions;
  end;

  TAlbumComplet = class(TObjetComplet)
  private
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

    procedure FusionneInto(Dest: TAlbumComplet);
    property ReadyToFusion: Boolean read FReadyToFusion write FReadyToFusion;
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
    property Scenaristes: TObjectList<TAuteur> read FScenaristes;
    property Dessinateurs: TObjectList<TAuteur> read FDessinateurs;
    property Coloristes: TObjectList<TAuteur> read FColoristes;
    property Sujet: TStringList read FSujet;
    property Notes: TStringList read FNotes;
    property Editions: TEditionsCompletes read FEditions;
  end;

  TEmprunteurComplet = class(TObjetComplet)
  private
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
    property Nom: string{[100]} read FNom write SetNom;
    property Adresse: TStringList read FAdresse;
    property Emprunts: TEmpruntsComplet read FEmprunts;
  end;

  TStats = class(TInfoComplet)
  private
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
    property ListAlbumsMin: TObjectList<TAlbum> read FListAlbumsMin;
    property ListAlbumsMax: TObjectList<TAlbum> read FListAlbumsMax;
    property ListEmprunteursMin: TObjectList<TEmprunteur> read FListEmprunteursMin;
    property ListEmprunteursMax: TObjectList<TEmprunteur> read FListEmprunteursMax;
    property ListGenre: TObjectList<TGenre> read FListGenre;
    property ListEditeurs: TObjectList<TStats> read FListEditeurs;
  end;

  TSerieIncomplete = class(TInfoComplet)
  private
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
  private
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
    property Series: TObjectList<TSerieIncomplete> read FSeries;
  end;

  TPrevisionSortie = class(TInfoComplet)
  private
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
  private
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
    property AnneesPassees: TObjectList<TPrevisionSortie> read FAnneesPassees;
    property AnneeEnCours: TObjectList<TPrevisionSortie> read FAnneeEnCours;
    property AnneesProchaines: TObjectList<TPrevisionSortie> read FAnneesProchaines;
  end;

  TParaBDComplet = class(TObjetComplet)
  private
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
    property Titre: string{[150]} read FTitre write SetTitre;
    property Auteurs: TObjectList<TAuteur> read FAuteurs;
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
  TLblGroupOption: array[TGroupOption] of string = ('ET', 'OU');

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
    SousCriteres: TList;
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
  TLblRechercheSimple: array[TRechercheSimple] of string = ('Auteur', 'Serie', 'Editeur', 'Genre', 'Collection');

type
  TRecherche = class(TBaseComplet)
  public
    TypeRecherche: TTypeRecherche;
    Resultats: TObjectList<TAlbum>;
    ResultatsInfos: TStrings;
    Criteres: TGroupCritere;
    SortBy: TList;
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

uses
  UIBLib, Divers, StdCtrls, Procedures, Textes, StrUtils, UMetadata, Controls,
  UfrmFusionEditions;

function MakeOption(Value: integer; const Caption: string): ROption;
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

procedure TBaseComplet.WriteString(Stream: TStream; const Chaine: string);
begin
  Stream.Write(Chaine[1], Length(Chaine));
end;

procedure TBaseComplet.WriteStringLN(Stream: TStream; const Chaine: string);
begin
  WriteString(Stream, Chaine + #13#10);
end;

procedure TBaseComplet.WriteXMLToStream(Stream: TStream);
begin

end;

{ TAlbumComplet }

procedure TAlbumComplet.Acheter(Prevision: Boolean);
var
  q: TUIBQuery;
begin
  if IsEqualGUID(ID_Album, GUID_NULL) then
    Exit;
  q := TUIBQuery.Create(nil);
  with q do
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

procedure TAlbumComplet.Clear;
begin
  inherited;
  FReadyToFusion := False;

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
      SQL.Text := 'SELECT TITREALBUM, MOISPARUTION, ANNEEPARUTION, ID_Serie, TOME, TOMEDEBUT, TOMEFIN, SUJETALBUM, REMARQUESALBUM, HORSSERIE, INTEGRALE, COMPLET FROM ALBUMS WHERE ID_Album = ?';
      Params.AsString[0] := GUIDToString(Reference);
      Open;
      RecInconnu := Eof;

      if not RecInconnu then
      begin
        Self.Titre := Fields.ByNameAsString['TITREALBUM'];
        Self.AnneeParution := Fields.ByNameAsInteger['ANNEEPARUTION'];
        Self.MoisParution := Fields.ByNameAsInteger['MOISPARUTION'];
        Self.Sujet.Text := Fields.ByNameAsString['SUJETALBUM'];
        Self.Notes.Text := Fields.ByNameAsString['REMARQUESALBUM'];
        Self.Tome := Fields.ByNameAsInteger['TOME'];
        Self.TomeDebut := Fields.ByNameAsInteger['TOMEDEBUT'];
        Self.TomeFin := Fields.ByNameAsInteger['TOMEFIN'];
        Self.Integrale := Fields.ByNameAsBoolean['INTEGRALE'];
        Self.HorsSerie := Fields.ByNameAsBoolean['HORSSERIE'];

        Self.Serie.Fill(StringToGUIDDef(Fields.ByNameAsString['ID_SERIE'], GUID_NULL));

        FComplet := Fields.ByNameAsBoolean['COMPLET'];

        Close;
        SQL.Text := 'SELECT * FROM PROC_AUTEURS(?, NULL, NULL)';
        Params.AsString[0] := GUIDToString(Reference);
        Open;
        TAuteur.Prepare(q);
        try
        while not Eof do
        begin
          case TMetierAuteur(Fields.ByNameAsInteger['Metier']) of
            maScenariste: Self.Scenaristes.Add(TAuteur.Make(q));
            maDessinateur: Self.Dessinateurs.Add(TAuteur.Make(q));
            maColoriste: Self.Coloristes.Add(TAuteur.Make(q));
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
    //Album
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
      if NotInList(Auteur, Dest.Scenaristes) then Dest.Scenaristes.Add(TAuteur.Duplicate(Auteur) as TAuteur);
    for Auteur in Dessinateurs do
      if NotInList(Auteur, Dest.Dessinateurs) then Dest.Dessinateurs.Add(TAuteur.Duplicate(Auteur) as TAuteur);
    for Auteur in Coloristes do
      if NotInList(Auteur, Dest.Coloristes) then Dest.Coloristes.Add(TAuteur.Duplicate(Auteur) as TAuteur);

    if not SameText(Sujet.Text, DefaultAlbum.Sujet.Text) then
      Dest.Sujet.Assign(Sujet);
    if not SameText(Notes.Text, DefaultAlbum.Notes.Text) then
      Dest.Notes.Assign(Notes);

    //Série
    if not IsEqualGUID(ID_Serie, DefaultAlbum.ID_Serie) and
      not IsEqualGUID(ID_Serie, Dest.ID_Serie)
    then
      Dest.ID_Serie := ID_Serie;

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
  s: string;
  q: TUIBQuery;
  i: Integer;
  hg: IHourGlass;
  Edition: TEditionComplete;
begin
  inherited;
  hg := THourGlass.Create;
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := UseTransaction;

      SQL.Text := 'UPDATE OR INSERT INTO ALBUMS (ID_Album, TITREALBUM, MOISPARUTION, ANNEEPARUTION, ID_Serie, TOME, TOMEDEBUT, TOMEFIN, HORSSERIE, INTEGRALE, SUJETALBUM, REMARQUESALBUM)';
      SQL.Add('VALUES');
      SQL.Add('(:ID_Album, :TITREALBUM, :MOISPARUTION, :ANNEEPARUTION, :ID_Serie, :TOME, :TOMEDEBUT, :TOMEFIN, :HORSSERIE, :INTEGRALE, :SUJETALBUM, :REMARQUESALBUM)');
      Prepare(True);

      if IsEqualGUID(GUID_NULL, ID_Album) then
        Params.ByNameIsNull['ID_Album'] := True
      else
        Params.ByNameAsString['ID_ALBUM'] := GUIDToString(ID_Album);
      s := Trim(Titre);
      if s = '' then
        Params.ByNameIsNull['TITREALBUM'] := True
      else
        Params.ByNameAsString['TITREALBUM'] := s;
      if AnneeParution = 0 then
      begin
        Params.ByNameIsNull['ANNEEPARUTION'] := True;
        Params.ByNameIsNull['MOISPARUTION'] := True;
      end
      else
      begin
        Params.ByNameAsInteger['ANNEEPARUTION'] := AnneeParution;
        if MoisParution = 0 then
          Params.ByNameIsNull['MOISPARUTION'] := True
        else
          Params.ByNameAsInteger['MOISPARUTION'] := MoisParution;
      end;
      if Tome = 0 then
        Params.ByNameIsNull['TOME'] := True
      else
        Params.ByNameAsInteger['TOME'] := Tome;
      if (not Integrale) or (TomeDebut = 0) then
        Params.ByNameIsNull['TOMEDEBUT'] := True
      else
        Params.ByNameAsInteger['TOMEDEBUT'] := TomeDebut;
      if (not Integrale) or (TomeFin = 0) then
        Params.ByNameIsNull['TOMEFIN'] := True
      else
        Params.ByNameAsInteger['TOMEFIN'] := TomeFin;
      Params.ByNameAsBoolean['INTEGRALE'] := Integrale;
      Params.ByNameAsBoolean['HORSSERIE'] := HorsSerie;
      s := Sujet.Text;
      if s <> '' then
        ParamsSetBlob('SUJETALBUM', s)
      else
        Params.ByNameIsNull['SUJETALBUM'] := True;
      s := Notes.Text;
      if s <> '' then
        ParamsSetBlob('REMARQUESALBUM', s)
      else
        Params.ByNameIsNull['REMARQUESALBUM'] := True;
      if Serie.RecInconnu or IsEqualGUID(Id_Serie, GUID_NULL) then
        Params.ByNameIsNull['ID_SERIE'] := True
      else
        Params.ByNameAsString['ID_SERIE'] := GUIDToString(ID_Serie);
      ExecSQL;

      SupprimerToutDans('', 'AUTEURS', 'ID_Album', ID_Album);
      SQL.Clear;
      SQL.Add('INSERT INTO AUTEURS (ID_Album, METIER, ID_Personne)');
      SQL.Add('VALUES (:ID_Album, :METIER, :ID_Personne)');
      for i := 0 to Pred(Scenaristes.Count) do
      begin
        Params.AsString[0] := GUIDToString(ID_Album);
        Params.AsInteger[1] := 0;
        Params.AsString[2] := GUIDToString(TAuteur(Scenaristes[i]).Personne.ID);
        ExecSQL;
      end;
      for i := 0 to Pred(Dessinateurs.Count) do
      begin
        Params.AsString[0] := GUIDToString(ID_Album);
        Params.AsInteger[1] := 1;
        Params.AsString[2] := GUIDToString(TAuteur(Dessinateurs[i]).Personne.ID);
        ExecSQL;
      end;
      for i := 0 to Pred(Coloristes.Count) do
      begin
        Params.AsString[0] := GUIDToString(ID_Album);
        Params.AsInteger[1] := 2;
        Params.AsString[2] := GUIDToString(TAuteur(Coloristes[i]).Personne.ID);
        ExecSQL;
      end;

      s := '';
      for i := 0 to Pred(Editions.Editions.Count) do
      begin
        Edition := Editions.Editions[i];
        if not Edition.RecInconnu then
          AjoutString(s, QuotedStr(GUIDToString(Edition.ID_Edition)), ',');
      end;

      // éditions supprimées
      SQL.Text := 'DELETE FROM EDITIONS WHERE ID_ALBUM = ?';
      if s <> '' then
        SQL.Add('AND ID_EDITION NOT IN (' + s + ')');
      Params.AsString[0] := GUIDToString(ID_Album);
      ExecSQL;
      SQL.Text := 'DELETE FROM COUVERTURES WHERE ID_ALBUM = ? AND ID_EDITION IS NOT NULL';
      if s <> '' then
        SQL.Add('AND ID_EDITION NOT IN (' + s + ')');
      Params.AsString[0] := GUIDToString(ID_Album);
      ExecSQL;

      for i := 0 to Pred(Editions.Editions.Count) do
      begin
        Edition := Editions.Editions[i];
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
          1: FDefaultEtat := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
          2: FDefaultReliure := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
          3: FDefaultTypeEdition := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
          4: FDefaultOrientation := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
          5: FDefaultFormatEdition := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
          8: FDefaultSensLecture := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
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
      SQL.Text := 'SELECT ID_EDITION, ID_Album, e.ID_Editeur, e.ID_Collection, NOMCOLLECTION, ANNEEEDITION, PRIX, VO, COULEUR, ISBN, DEDICACE, PRETE,';
      SQL.Add('STOCK, Offert, Gratuit, NombreDePages, DateAchat, Notes, AnneeCote, PrixCote, NumeroPerso,');
      SQL.Add('etat, le.libelle as setat, reliure, lr.libelle as sreliure, orientation, lo.libelle as sorientation,');
      SQL.Add('FormatEdition, lf.libelle as sFormatEdition, typeedition, lte.libelle as stypeedition,');
      SQL.Add('SensLecture, lsl.libelle as sSensLecture');
      SQL.Add('FROM EDITIONS e LEFT JOIN COLLECTIONS c ON e.ID_Collection = c.ID_Collection');
      SQL.Add('LEFT JOIN LISTES le on (le.ref = e.etat and le.categorie = 1)');
      SQL.Add('LEFT JOIN LISTES lr on (lr.ref = e.reliure and lr.categorie = 2)');
      SQL.Add('LEFT JOIN LISTES lte on (lte.ref = e.typeedition and lte.categorie = 3)');
      SQL.Add('LEFT JOIN LISTES lo on (lo.ref = e.orientation and lo.categorie = 4)');
      SQL.Add('LEFT JOIN LISTES lf on (lf.ref = e.formatedition and lf.categorie = 5)');
      SQL.Add('LEFT JOIN LISTES lsl on (lsl.ref = e.senslecture and lsl.categorie = 8)');
      SQL.Add('WHERE ID_Edition = ?');
      Params.AsString[0] := GUIDToString(Reference);
      FetchBlobs := True;
      Open;
      RecInconnu := Eof;

      if not RecInconnu then
      begin
        Self.ID_Album := StringToGUIDDef(Fields.ByNameAsString['ID_Album'], GUID_NULL);
        Self.Editeur.Fill(StringToGUIDDef(Fields.ByNameAsString['ID_EDITEUR'], GUID_NULL));
        Self.Collection.Fill(q);
        Self.AnneeEdition := Fields.ByNameAsInteger['ANNEEEDITION'];
        Self.Prix := Fields.ByNameAsCurrency['PRIX'];
        Self.VO := Fields.ByNameAsBoolean['VO'];
        Self.Couleur := Fields.ByNameAsBoolean['COULEUR'];
        Self.Dedicace := Fields.ByNameAsBoolean['DEDICACE'];
        Self.Offert := Fields.ByNameAsBoolean['OFFERT'];
        Self.Gratuit := Fields.ByNameAsBoolean['GRATUIT'];
        Self.Prete := Fields.ByNameAsBoolean['PRETE'];
        Self.Stock := Fields.ByNameAsBoolean['STOCK'];
        Self.ISBN := FormatISBN(Trim(Fields.ByNameAsString['ISBN']));
        Self.TypeEdition := MakeOption(Fields.ByNameAsInteger['TypeEdition'], Trim(Fields.ByNameAsString['sTypeEdition']));
        Self.NombreDePages := Fields.ByNameAsInteger['NombreDePages'];
        Self.Etat := MakeOption(Fields.ByNameAsInteger['Etat'], Trim(Fields.ByNameAsString['sEtat']));
        Self.Reliure := MakeOption(Fields.ByNameAsInteger['Reliure'], Trim(Fields.ByNameAsString['sReliure']));
        Self.Orientation := MakeOption(Fields.ByNameAsInteger['Orientation'], Trim(Fields.ByNameAsString['sOrientation']));
        Self.FormatEdition := MakeOption(Fields.ByNameAsInteger['FormatEdition'], Trim(Fields.ByNameAsString['sFormatEdition']));
        Self.SensLecture := MakeOption(Fields.ByNameAsInteger['SensLecture'], Trim(Fields.ByNameAsString['sSensLecture']));
        Self.DateAchat := Fields.ByNameAsDate['DateAchat'];
        Self.Notes.Text := Fields.ByNameAsString['Notes'];
        Self.AnneeCote := Fields.ByNameAsInteger['ANNEECOTE'];
        Self.PrixCote := Fields.ByNameAsCurrency['PRIXCOTE'];
        Self.NumeroPerso := Fields.ByNameAsString['NUMEROPERSO'];

        Self.Emprunts.Fill(Self.ID_Edition, seAlbum);

        Close;
        SQL.Text := 'SELECT ID_Couverture, FichierCouverture, STOCKAGECOUVERTURE, CategorieImage, l.Libelle as sCategorieImage';
        SQL.Add('FROM Couvertures c LEFT JOIN Listes l ON (c.categorieimage = l.ref and l.categorie = 6)');
        SQL.Add('WHERE ID_Edition = ? ORDER BY c.categorieimage NULLS FIRST, c.Ordre');
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
    if not IsEqualGUID(Editeur.ID_Editeur, DefaultEdition.Editeur.ID_Editeur)
      and not IsEqualGUID(Editeur.ID_Editeur, Dest.Editeur.ID_Editeur) then
      Dest.Editeur.Fill(Editeur.ID_Editeur);
    if not IsEqualGUID(Collection.ID, DefaultEdition.Collection.ID)
      and not IsEqualGUID(Collection.ID, Dest.Collection.ID) then
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
  s: string;
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

      SQL.Text := 'UPDATE OR INSERT INTO EDITIONS (';
      SQL.Add('ID_Edition, ID_Album, ID_Editeur, ID_Collection, ANNEEEDITION, PRIX, VO, TYPEEDITION, COULEUR, ISBN, STOCK, DEDICACE, OFFERT, GRATUIT,');
      SQL.Add('ETAT, RELIURE, ORIENTATION, FormatEdition, DATEACHAT, NOTES, NOMBREDEPAGES, ANNEECOTE, PRIXCOTE, NumeroPerso, SensLecture');
      SQL.Add(') VALUES (');
      SQL.Add(':ID_Edition, :ID_Album, :ID_Editeur, :ID_Collection, :ANNEEEDITION, :PRIX, :VO, :TYPEEDITION, :COULEUR, :ISBN, :STOCK, :DEDICACE, :OFFERT, :GRATUIT,');
      SQL.Add(':ETAT, :RELIURE, :ORIENTATION, :FormatEdition, :DATEACHAT, :NOTES, :NOMBREDEPAGES, :ANNEECOTE, :PRIXCOTE, :NumeroPerso, :SensLecture');
      SQL.Add(')');

      if IsEqualGUID(GUID_NULL, ID_Edition) then
        Params.ByNameIsNull['ID_Edition'] := True
      else
        Params.ByNameAsString['ID_Edition'] := GUIDToString(ID_Edition);
      Params.ByNameAsString['ID_Album'] := GUIDToString(ID_Album);
      Params.ByNameAsString['ID_Editeur'] := GUIDToString(Editeur.ID_Editeur);
      Params.ByNameAsString['ID_Collection'] := GUIDToString(Collection.ID);
      if AnneeEdition = 0 then
        Params.ByNameIsNull['ANNEEEDITION'] := True
      else
        Params.ByNameAsInteger['ANNEEEDITION'] := AnneeEdition;
      if NombreDePages = 0 then
        Params.ByNameIsNull['NombreDePages'] := True
      else
        Params.ByNameAsInteger['NombreDePages'] := NombreDePages;
      if Prix = 0 then
        Params.ByNameIsNull['PRIX'] := True
      else
        Params.ByNameAsCurrency['PRIX'] := Prix;
      Params.ByNameAsBoolean['VO'] := VO;
      Params.ByNameAsBoolean['COULEUR'] := Couleur;
      Params.ByNameAsString['ISBN'] := ClearISBN(ISBN);
      Params.ByNameAsBoolean['STOCK'] := Stock;
      Params.ByNameAsBoolean['DEDICACE'] := Dedicace;
      Params.ByNameAsBoolean['GRATUIT'] := Gratuit;
      Params.ByNameAsBoolean['OFFERT'] := Offert;
      Params.ByNameAsInteger['TYPEEDITION'] := TypeEdition.Value;
      Params.ByNameAsInteger['ETAT'] := Etat.Value;
      Params.ByNameAsInteger['RELIURE'] := Reliure.Value;
      Params.ByNameAsInteger['Orientation'] := Orientation.Value;
      Params.ByNameAsInteger['FormatEdition'] := FormatEdition.Value;
      Params.ByNameAsInteger['SensLecture'] := SensLecture.Value;
      if DateAchat = 0 then
        Params.ByNameIsNull['DATEACHAT'] := True
      else
        Params.ByNameAsDate['DATEACHAT'] := Trunc(DateAchat);
      if (AnneeCote = 0) or (PrixCote = 0) then
      begin
        Params.ByNameIsNull['ANNEECOTE'] := True;
        Params.ByNameIsNull['PRIXCOTE'] := True;
      end
      else
      begin
        Params.ByNameAsInteger['ANNEECOTE'] := AnneeCote;
        Params.ByNameAsCurrency['PRIXCOTE'] := PrixCote;
      end;
      Params.ByNameAsString['NUMEROPERSO'] := NumeroPerso;

      s := Notes.Text;
      if s <> '' then
        ParamsSetBlob('NOTES', s)
      else
        Params.ByNameIsNull['NOTES'] := True;
      ExecSQL;

      s := '';
      for i := 0 to Pred(Couvertures.Count) do
      begin
        PC := Couvertures[i];
        if not IsEqualGUID(PC.ID, GUID_NULL) then
          AjoutString(s, QuotedStr(GUIDToString(PC.ID)), ',');
      end;

      SQL.Text := 'DELETE FROM COUVERTURES WHERE ID_EDITION = ?';
      if s <> '' then
        SQL.Add('AND ID_COUVERTURE NOT IN (' + s + ')');
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
        q1.SQL.Add('INSERT INTO COUVERTURES (ID_Edition, ID_Album, FichierCouverture, STOCKAGECOUVERTURE, Ordre, CategorieImage)');
        q1.SQL.Add('VALUES (:ID_Edition, :ID_Album, :FichierCouverture, 0, :Ordre, :CategorieImage)');

        q6.SQL.Text := 'SELECT Result FROM SAVEBLOBTOFILE(:Chemin, :Fichier, :BlobContent)';

        q2.SQL.Clear;
        q2.SQL.Add('INSERT INTO COUVERTURES (ID_Edition, ID_Album, FichierCouverture, STOCKAGECOUVERTURE, Ordre, IMAGECOUVERTURE, CategorieImage)');
        q2.SQL.Add('VALUES (:ID_Edition, :ID_Album, :FichierCouverture, 1, :Ordre, :IMAGECOUVERTURE, :CategorieImage)');

        q3.SQL.Text := 'UPDATE COUVERTURES SET IMAGECOUVERTURE = :IMAGECOUVERTURE, STOCKAGECOUVERTURE = 1 WHERE ID_Couverture = :ID_Couverture';

        q4.SQL.Text := 'UPDATE COUVERTURES SET IMAGECOUVERTURE = NULL, STOCKAGECOUVERTURE = 0 WHERE ID_Couverture = :ID_Couverture';

        q5.SQL.Text := 'UPDATE COUVERTURES SET FichierCouverture = :FichierCouverture, Ordre = :Ordre, CategorieImage = :CategorieImage WHERE ID_Couverture = :ID_Couverture';

        for i := 0 to Pred(Couvertures.Count) do
        begin
          PC := Couvertures[i];
          if IsEqualGUID(PC.ID, GUID_NULL) then
          begin // nouvelles couvertures
            if (not PC.NewStockee) then
            begin // couvertures liées (q1)
              PC.OldNom := PC.NewNom;
              PC.NewNom := SearchNewFileName(RepImages, ExtractFileName(PC.NewNom), True);
              q6.Params.ByNameAsString['Chemin'] := RepImages;
              q6.Params.ByNameAsString['Fichier'] := PC.NewNom;
              Stream := GetCouvertureStream(PC.OldNom, -1, -1, False);
              try
                q6.ParamsSetBlob('BlobContent', Stream);
              finally
                Stream.Free;
              end;
              q6.Open;

              q1.Params.ByNameAsString['ID_Edition'] := GUIDToString(ID_Edition);
              q1.Params.ByNameAsString['ID_Album'] := GUIDToString(ID_Album);
              q1.Params.ByNameAsString['FichierCouverture'] := PC.NewNom;
              q1.Params.ByNameAsInteger['Ordre'] := i;
              q1.Params.ByNameAsInteger['CategorieImage'] := PC.Categorie;
              q1.ExecSQL;
            end
            else if FileExists(PC.NewNom) then
            begin // couvertures stockées (q2)
              q2.Params.ByNameAsString['ID_Edition'] := GUIDToString(ID_Edition);
              q2.Params.ByNameAsString['ID_Album'] := GUIDToString(ID_Album);
              q2.Params.ByNameAsString['FichierCouverture'] := ChangeFileExt(ExtractFileName(PC.NewNom), '');
              q2.Params.ByNameAsInteger['Ordre'] := i;
              Stream := GetJPEGStream(PC.NewNom);
              try
                q2.ParamsSetBlob('IMAGECOUVERTURE', Stream);
              finally
                Stream.Free;
              end;
              q2.Params.ByNameAsInteger['CategorieImage'] := PC.Categorie;
              q2.ExecSQL;
            end;
          end
          else
          begin // ancienne couverture
            if PC.OldStockee <> PC.NewStockee then
            begin // changement de stockage
              if (PC.NewStockee) then
              begin // conversion couvertures liées en stockées (q3)
                Stream := GetCouvertureStream(False, PC.ID, -1, -1, False);
                try
                  q3.ParamsSetBlob('IMAGECOUVERTURE', Stream);
                finally
                  Stream.Free;
                end;
                q3.Params.ByNameAsString['ID_Couverture'] := GUIDToString(PC.ID);
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
                q6.Params.ByNameAsString['Chemin'] := RepImages;
                q6.Params.ByNameAsString['Fichier'] := PC.NewNom;
                Stream := GetCouvertureStream(False, PC.ID, -1, -1, False);
                try
                  q6.ParamsSetBlob('BlobContent', Stream);
                finally
                  Stream.Free;
                end;
                q6.Open;

                q4.Params.ByNameAsString['ID_Couverture'] := GUIDToString(PC.ID);
                q4.ExecSQL;
              end;
            end;
            // couvertures renommées, réordonnées, changée de catégorie, etc (q5)
            // obligatoire pour les changement de stockage
            q5.Params.ByNameAsString['FichierCouverture'] := PC.NewNom;
            q5.Params.ByNameAsInteger['Ordre'] := i;
            q5.Params.ByNameAsInteger['CategorieImage'] := PC.Categorie;
            q5.Params.ByNameAsString['ID_Couverture'] := GUIDToString(PC.ID);
            q5.ExecSQL;
          end;
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
        SQL.Text := 'SELECT * FROM DELETEFILE(:Fichier)';
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
      SQL.Text := 'SELECT ID_Edition FROM EDITIONS WHERE ID_Album = ?';
      if Stock in [0, 1] then
        SQL.Add('AND e.STOCK = :Stock');
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
  if Editions.Count = 0 then Exit;

  SetLength(FusionsGUID, Editions.Count);
  ZeroMemory(FusionsGUID, SizeOf(FusionsGUID));
  SetLength(OptionsFusion, Editions.Count);
  ZeroMemory(OptionsFusion, SizeOf(FusionsGUID));
  // même si la destination n'a aucune données, on peut choisir de ne rien y importer
  //  if Dest.Editions.Count > 0 then
  for i := 0 to Pred(Editions.Count) do
    with TfrmFusionEditions.Create(nil) do
    try
      SetEditionSrc(Editions[i]);
      // SetEditions doit être fait après SetEditionSrc
      SetEditions(Dest.Editions, FusionsGUID);

      case ShowModal of
        mrCancel: FusionsGUID[i] := GUID_FULL;
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
    if IsEqualGUID(FusionsGUID[i], GUID_FULL) then Continue;
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
    if Assigned(Edition) then begin
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
      SQL.Text := 'SELECT NomEmprunteur, AdresseEmprunteur FROM Emprunteurs WHERE ID_Emprunteur = ?';
      Params.AsString[0] := GUIDToString(Reference);
      FetchBlobs := True;
      Open;
      RecInconnu := Eof;
      if not RecInconnu then
      begin
        Self.Nom := Fields.ByNameAsString['NomEmprunteur'];
        Self.Adresse.Text := Fields.ByNameAsString['AdresseEmprunteur'];

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
  s: string;
begin
  inherited;
  with TUIBQuery.Create(nil) do
    try
      Transaction := UseTransaction;

      SQL.Text := 'UPDATE OR INSERT INTO EMPRUNTEURS (ID_Emprunteur, NOMEMPRUNTEUR, ADRESSEEMPRUNTEUR) VALUES (:ID_Emprunteur, :NOMEMPRUNTEUR, :ADRESSEEMPRUNTEUR)';

      if IsEqualGUID(GUID_NULL, ID_Emprunteur) then
        Params.ByNameIsNull['ID_Emprunteur'] := True
      else
        Params.ByNameAsString['ID_Emprunteur'] := GUIDToString(ID_Emprunteur);
      Params.ByNameAsString['NOMEMPRUNTEUR'] := Trim(Nom);
      s := Self.Adresse.Text;
      ParamsSetBlob('ADRESSEEMPRUNTEUR', s);

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
          1: FDefaultEtat := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
          2: FDefaultReliure := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
          3: FDefaultTypeEdition := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
          4: FDefaultOrientation := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
          5: FDefaultFormatEdition := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
          8: FDefaultSensLecture := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
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
  s: string;
begin
  if Simple then
    Result := Titre
  else
    Result := FormatTitre(Titre);
  s := '';
  AjoutString(s, FormatTitre(Editeur.NomEditeur), ' ');
  AjoutString(s, FormatTitre(Collection.NomCollection), ' - ');
  AjoutString(Result, s, ' ', '(', ')');
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
      SQL.Text := 'select titreserie, coalesce(terminee, -1) as terminee, sujetserie, remarquesserie, siteweb, complete, nb_albums, s.id_editeur, s.id_collection , nomcollection, suivresorties, suivremanquants, coalesce(vo, -1) as vo, coalesce(couleur, -1) as couleur,';
      SQL.Add('coalesce(etat, -1) as etat, le.libelle as setat, coalesce(reliure, -1) as reliure, lr.libelle as sreliure, coalesce(orientation, -1) as orientation, lo.libelle as sorientation,');
      SQL.Add('coalesce(formatedition, -1) as formatedition, lf.libelle as sformatedition, coalesce(typeedition, -1) as typeedition, lte.libelle as stypeedition,');
      SQL.Add('coalesce(senslecture, -1) as senslecture, lsl.libelle as ssenslecture');
      SQL.Add('from series s left join collections c on s.id_collection = c.id_collection');
      SQL.Add('left join listes le on (le.ref = s.etat and le.categorie = 1)');
      SQL.Add('left join listes lr on (lr.ref = s.reliure and lr.categorie = 2)');
      SQL.Add('left join listes lte on (lte.ref = s.typeedition and lte.categorie = 3)');
      SQL.Add('left join listes lo on (lo.ref = s.orientation and lo.categorie = 4)');
      SQL.Add('left join listes lf on (lf.ref = s.formatedition and lf.categorie = 5)');
      SQL.Add('left join listes lsl on (lsl.ref = s.senslecture and lsl.categorie = 8)');
      SQL.Add('where id_serie = ?');
      Params.AsString[0] := GUIDToString(Reference);
      Open;
      RecInconnu := Eof;

      if not RecInconnu then
      begin
        Self.Titre := Fields.ByNameAsString['TITRESERIE'];
        Self.Terminee := Fields.ByNameAsInteger['TERMINEE'];
        Self.VO := Fields.ByNameAsInteger['VO'];
        Self.Couleur := Fields.ByNameAsInteger['COULEUR'];
        Self.SuivreSorties := RecInconnu or Fields.ByNameAsBoolean['SUIVRESORTIES'];
        Self.Complete := Fields.ByNameAsBoolean['COMPLETE'];
        Self.SuivreManquants := RecInconnu or Fields.ByNameAsBoolean['SUIVREMANQUANTS'];
        Self.NbAlbums := Fields.ByNameAsInteger['NB_ALBUMS'];
        Self.Sujet.Text := Fields.ByNameAsString['SUJETSERIE'];
        Self.Notes.Text := Fields.ByNameAsString['REMARQUESSERIE'];
        Self.SiteWeb := Trim(Fields.ByNameAsString['SITEWEB']);

        Self.TypeEdition := MakeOption(Fields.ByNameAsInteger['TypeEdition'], Trim(Fields.ByNameAsString['sTypeEdition']));
        Self.Etat := MakeOption(Fields.ByNameAsInteger['Etat'], Trim(Fields.ByNameAsString['sEtat']));
        Self.Reliure := MakeOption(Fields.ByNameAsInteger['Reliure'], Trim(Fields.ByNameAsString['sReliure']));
        Self.Orientation := MakeOption(Fields.ByNameAsInteger['Orientation'], Trim(Fields.ByNameAsString['sOrientation']));
        Self.FormatEdition := MakeOption(Fields.ByNameAsInteger['FormatEdition'], Trim(Fields.ByNameAsString['sFormatEdition']));
        Self.SensLecture := MakeOption(Fields.ByNameAsInteger['SensLecture'], Trim(Fields.ByNameAsString['sSensLecture']));

        Self.Editeur.Fill(StringToGUIDDef(Fields.ByNameAsString['ID_EDITEUR'], GUID_NULL));
        Self.Collection.Fill(q);
        FetchBlobs := False;

        Close;
        SQL.Text := 'select id_album, titrealbum, integrale, horsserie, tome, tomedebut, tomefin, id_serie from albums';
        if IsEqualGUID(Reference, GUID_NULL) then
          SQL.Add('where (id_serie is null or id_serie = ?)')
        else
          SQL.Add('where id_serie = ?');
        if not IsEqualGUID(FIdAuteur, GUID_NULL) then
          SQL.Add('and id_album in (select id_album from auteurs where id_personne = ?)');
        SQL.Add('order by horsserie nulls first, integrale nulls first, tome nulls first');
        Params.AsString[0] := GUIDToString(Reference);
        if not IsEqualGUID(FIdAuteur, GUID_NULL) then
          Params.AsString[1] := GUIDToString(FIdAuteur);
        Open;
        TAlbum.FillList(TList<TBasePointeur>(Self.Albums), q);

        Close;
        SQL.Text := 'select id_parabd, titreparabd, id_serie, titreserie, achat, complet, scategorie from vw_liste_parabd';
        if IsEqualGUID(Reference, GUID_NULL) then
          SQL.Add('where (id_serie is null or id_serie = ?)')
        else
          SQL.Add('where id_serie = ?');
        if not IsEqualGUID(FIdAuteur, GUID_NULL) then
          SQL.Add('and id_parabd in (select id_parabd from auteurs_parabd where id_personne = ?)');
        SQL.Add('order by titreparabd');
        Params.AsString[0] := GUIDToString(Reference);
        if not IsEqualGUID(FIdAuteur, GUID_NULL) then
          Params.AsString[1] := GUIDToString(FIdAuteur);
        Open;
        TParaBD.FillList(TList<TBasePointeur>(Self.ParaBD), q);

        Close;
        SQL.Text := 'select g.id_genre, genre ' + 'from genreseries s inner join genres g on g.id_genre = s.id_genre ' + 'where id_serie = ?' + 'order by genre';
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
              maScenariste: Self.Scenaristes.Add(TAuteur.Make(q));
              maDessinateur: Self.Dessinateurs.Add(TAuteur.Make(q));
              maColoriste: Self.Coloristes.Add(TAuteur.Make(q));
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
  s: string;
  i: Integer;
begin
  inherited;
  with TUIBQuery.Create(nil) do
    try
      Transaction := UseTransaction;

      SQL.Text := 'update or insert into series (';
      SQL.Add('id_serie, titreserie, terminee, suivresorties, complete, suivremanquants, siteweb, id_editeur,');
      SQL.Add('id_collection, sujetserie, remarquesserie, nb_albums, vo, couleur, etat, reliure, typeedition,');
      SQL.Add('orientation, formatedition, senslecture');
      SQL.Add(') values (');
      SQL.Add(':id_serie, :titreserie, :terminee, :suivresorties, :complete, :suivremanquants, :siteweb, :id_editeur,');
      SQL.Add(':id_collection, :sujetserie, :remarquesserie, :nb_albums, :vo, :couleur, :etat, :reliure, :typeedition,');
      SQL.Add(':orientation, :formatedition, :senslecture');
      SQL.Add(')');

      if IsEqualGUID(GUID_NULL, ID_Serie) then
        Params.ByNameIsNull['ID_Serie'] := True
      else
        Params.ByNameAsString['ID_Serie'] := GUIDToString(ID_Serie);
      Params.ByNameAsString['TitreSerie'] := Trim(Self.Titre);
      if TCheckBoxState(Self.Terminee) = cbGrayed then
        Params.ByNameIsNull['TERMINEE'] := True
      else
        Params.ByNameAsInteger['TERMINEE'] := Self.Terminee;
      if TCheckBoxState(Self.VO) = cbGrayed then
        Params.ByNameIsNull['VO'] := True
      else
        Params.ByNameAsInteger['VO'] := Self.VO;
      if TCheckBoxState(Self.Couleur) = cbGrayed then
        Params.ByNameIsNull['COULEUR'] := True
      else
        Params.ByNameAsInteger['COULEUR'] := Self.Couleur;
      Params.ByNameAsInteger['TYPEEDITION'] := TypeEdition.Value;
      Params.ByNameAsInteger['ETAT'] := Etat.Value;
      Params.ByNameAsInteger['RELIURE'] := Reliure.Value;
      Params.ByNameAsInteger['Orientation'] := Orientation.Value;
      Params.ByNameAsInteger['FormatEdition'] := FormatEdition.Value;
      Params.ByNameAsInteger['SensLecture'] := SensLecture.Value;
      Params.ByNameAsBoolean['SUIVRESORTIES'] := Self.SuivreSorties;
      Params.ByNameAsBoolean['COMPLETE'] := Self.Complete;
      Params.ByNameAsBoolean['SUIVREMANQUANTS'] := Self.SuivreManquants;
      if Self.NbAlbums > 0 then
        Params.ByNameAsInteger['NB_ALBUMS'] := Self.NbAlbums
      else
        Params.ByNameIsNull['NB_ALBUMS'] := True;
      Params.ByNameAsString['SITEWEB'] := Trim(Self.SiteWeb);
      if IsEqualGUID(Self.ID_Editeur, GUID_NULL) then
      begin
        Params.ByNameIsNull['ID_Editeur'] := True;
        Params.ByNameIsNull['ID_Collection'] := True;
      end
      else
      begin
        Params.ByNameAsString['ID_Editeur'] := GUIDToString(Self.ID_Editeur);
        if IsEqualGUID(Self.ID_Collection, GUID_NULL) then
          Params.ByNameIsNull['ID_Collection'] := True
        else
          Params.ByNameAsString['ID_Collection'] := GUIDToString(Self.ID_Collection);
      end;
      s := Self.Sujet.Text;
      if s <> '' then
        ParamsSetBlob('sujetserie', s)
      else
        Params.ByNameIsNull['sujetserie'] := True;
      s := Self.Notes.Text;
      if s <> '' then
        ParamsSetBlob('remarquesserie', s)
      else
        Params.ByNameIsNull['remarquesserie'] := True;

      ExecSQL;

      SupprimerToutDans('', 'GENRESERIES', 'ID_Serie', ID_Serie);
      SQL.Clear;
      SQL.Add('INSERT INTO GENRESERIES (ID_Serie, ID_Genre) VALUES (:ID_Serie, :ID_Genre)');
      Prepare(True);
      for i := 0 to Pred(Genres.Count) do
      begin
        Params.AsString[0] := GUIDToString(ID_Serie);
        Params.AsString[1] := Copy(Genres.Names[i], 1, Params.SQLLen[1]);
        ExecSQL;
      end;

      SupprimerToutDans('', 'AUTEURS_SERIES', 'ID_Serie', ID_Serie);
      SQL.Clear;
      SQL.Add('INSERT INTO AUTEURS_SERIES (ID_Serie, METIER, ID_Personne)');
      SQL.Add('VALUES (:ID_Serie, :METIER, :ID_Personne)');
      for i := 0 to Pred(Scenaristes.Count) do
      begin
        Params.AsString[0] := GUIDToString(ID_Serie);
        Params.AsInteger[1] := 0;
        Params.AsString[2] := GUIDToString(TAuteur(Scenaristes[i]).Personne.ID);
        ExecSQL;
      end;
      for i := 0 to Pred(Dessinateurs.Count) do
      begin
        Params.AsString[0] := GUIDToString(ID_Serie);
        Params.AsInteger[1] := 1;
        Params.AsString[2] := GUIDToString(TAuteur(Dessinateurs[i]).Personne.ID);
        ExecSQL;
      end;
      for i := 0 to Pred(Coloristes.Count) do
      begin
        Params.AsString[0] := GUIDToString(ID_Serie);
        Params.AsInteger[1] := 2;
        Params.AsString[2] := GUIDToString(TAuteur(Coloristes[i]).Personne.ID);
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
  NomEditeur := '';
  SiteWeb := '';
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
      SQL.Text := 'SELECT NOMEDITEUR, SITEWEB FROM EDITEURS WHERE ID_Editeur = ?';
      Params.AsString[0] := GUIDToString(Reference);
      Open;
      RecInconnu := Eof;

      if not RecInconnu then
      begin
        Self.NomEditeur := Fields.ByNameAsString['NOMEDITEUR'];
        Self.SiteWeb := Trim(Fields.ByNameAsString['SITEWEB']);
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

      SQL.Text := 'UPDATE OR INSERT INTO EDITEURS (ID_Editeur, NOMEDITEUR, SITEWEB) VALUES (:ID_Editeur, :NOMEDITEUR, :SITEWEB)';

      if IsEqualGUID(GUID_NULL, ID_Editeur) then
        Params.ByNameIsNull['ID_Editeur'] := True
      else
        Params.ByNameAsString['ID_Editeur'] := GUIDToString(ID_Editeur);
      Params.ByNameAsString['NOMEDITEUR'] := Trim(NomEditeur);
      Params.ByNameAsString['SITEWEB'] := Trim(SiteWeb);
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
      SQL.Add('SELECT COUNT(a.ID_Album) FROM Albums a INNER JOIN Editions e ON a.ID_Album = e.ID_Album');
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('AND e.ID_Editeur = ' + QuotedStr(GUIDToString(ID_Editeur)))
      else
        SQL.Add('');
      SQL.Add('');
      Open;
      Stats.FNbAlbums := Fields.AsInteger[0];
      Close;
      SQL[2] := 'WHERE e.Couleur = 0';
      Open;
      Stats.FNbAlbumsNB := Fields.AsInteger[0];
      Close;
      SQL[2] := 'WHERE e.VO = 1';
      Open;
      Stats.FNbAlbumsVO := Fields.AsInteger[0];
      Close;
      SQL[2] := 'WHERE e.Stock = 1';
      Open;
      Stats.FNbAlbumsStock := Fields.AsInteger[0];
      Close;
      SQL[2] := 'WHERE e.Dedicace = 1';
      Open;
      Stats.FNbAlbumsDedicace := Fields.AsInteger[0];
      Close;
      SQL[2] := 'WHERE e.Offert = 1';
      Open;
      Stats.FNbAlbumsOffert := Fields.AsInteger[0];
      Close;
      SQL[2] := 'WHERE e.Gratuit = 1';
      Open;
      Stats.FNbAlbumsGratuit := Fields.AsInteger[0];
      Close;
      SQL[2] := 'WHERE a.Integrale = 1';
      Open;
      Stats.FNbAlbumsIntegrale := Fields.AsInteger[0];
      Close;
      SQL[2] := 'WHERE a.HorsSerie = 1';
      Open;
      Stats.FNbAlbumsHorsSerie := Fields.AsInteger[0];
      Close;

      SQL.Clear;
      SQL.Add('select count(distinct a.ID_Serie) from albums a');
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('inner join editions e on e.ID_Album = a.ID_Album and e.ID_Editeur=' + QuotedStr(GUIDToString(ID_Editeur)))
      else
        SQL.Add('');
      Open;
      Stats.FNbSeries := Fields.AsInteger[0];
      Close;
      SQL.Add('left join Series s on a.ID_Serie = s.ID_Serie');
      SQL.Add('');
      SQL[3] := 'WHERE s.Terminee = 1';
      Open;
      Stats.FNbSeriesTerminee := Fields.AsInteger[0];
      Close;

      SQL.Text := 'SELECT Min(a.AnneeParution) AS MinAnnee, Max(a.AnneeParution) AS MaxAnnee FROM Albums a';
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('INNER JOIN Editions e ON e.ID_Album = a.ID_Album and e.ID_Editeur=' + QuotedStr(GUIDToString(ID_Editeur)));
      Open;
      Stats.FMinAnnee := 0;
      Stats.FMaxAnnee := 0;
      if not EOF then
      begin
        Stats.FMinAnnee := Fields.ByNameAsInteger['MinAnnee'];
        Stats.FMaxAnnee := Fields.ByNameAsInteger['MaxAnnee'];
      end;

      Close;
      SQL.Text := 'SELECT COUNT(g.ID_Genre) AS QuantiteGenre, g.ID_Genre, g.Genre FROM GenreSeries gs INNER JOIN Genres g ON gs.ID_Genre = g.ID_Genre';
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
      begin
        SQL.Add('INNER JOIN Albums a ON a.ID_Serie = gs.ID_Serie');
        SQL.Add('INNER JOIN Editions e ON e.ID_Album = a.ID_Album and e.ID_Editeur=' + QuotedStr(GUIDToString(ID_Editeur)));
      end;
      SQL.Add('GROUP BY g.Genre, g.ID_Genre ORDER BY 1 desc');
      Open;
      TGenre.FillList(TList<TBasePointeur>(Stats.ListGenre), Q);

      Close;
      SQL.Text := 'SELECT Sum(Prix) AS SumPrix, COUNT(Prix) AS CountPrix, Min(Prix) AS MinPrix, Max(Prix) AS MaxPrix FROM Editions';
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('WHERE ID_Editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
      Open;
      Stats.FValeurConnue := Fields.ByNameAsCurrency['SumPrix'];
      Stats.FPrixAlbumMoyen := 0;
      Stats.FPrixAlbumMinimun := 0;
      Stats.FPrixAlbumMaximun := 0;
      if not EOF and Fields.ByNameAsBoolean['CountPrix'] then
      begin
        Stats.FPrixAlbumMoyen := Fields.ByNameAsCurrency['SumPrix'] / Fields.ByNameAsInteger['CountPrix'];
        Stats.FPrixAlbumMinimun := Fields.ByNameAsCurrency['MinPrix'];
        Stats.FPrixAlbumMaximun := Fields.ByNameAsCurrency['MaxPrix'];
      end;

      Close;
      SQL.Clear;
      SQL.Add('SELECT COUNT(ID_Edition) AS CountRef FROM Editions WHERE Prix IS NULL');
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('AND ID_Editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
      Open;
      Stats.FNbAlbumsSansPrix := 0;
      if not Eof then
        Stats.FNbAlbumsSansPrix := Fields.ByNameAsInteger['countref'] - Stats.NbAlbumsGratuit;
      Stats.FValeurEstimee := Stats.ValeurConnue + Stats.NbAlbumsSansPrix * Stats.PrixAlbumMoyen;

      Close;
      SQL.Text := 'SELECT COUNT(DISTINCT st.ID_Emprunteur) FROM Statut st';
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('INNER JOIN Editions e ON e.ID_Edition = st.ID_Edition AND e.ID_Editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
      Open;
      Stats.FNbEmprunteurs := Fields.AsInteger[0];

      Close;
      SQL.Text := 'SELECT COUNT(st.ID_Emprunteur)/' + IntToStr(Stats.NbEmprunteurs) + ' AS moy FROM Statut st';
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('INNER JOIN Editions e ON e.ID_Edition = st.ID_Edition AND e.ID_Editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
      SQL.Add('WHERE st.PretEmprunt = 1');
      Stats.FMoyEmprunteurs := 0;
      if Bool(Stats.FNbEmprunteurs) then
      begin
        Open;
        Stats.FMoyEmprunteurs := Fields.ByNameAsInteger['moy'];
      end;

      Close;
      SQL.Clear;
      SQL.Add('SELECT COUNT(e.ID_Emprunteur) AS CountNumero, e.NomEmprunteur, e.ID_Emprunteur');
      SQL.Add('FROM Statut st INNER JOIN Emprunteurs e ON e.ID_Emprunteur = st.ID_Emprunteur');
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('INNER JOIN Editions ed ON ed.ID_Edition = st.ID_Edition AND ed.ID_Editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
      SQL.Add('WHERE (st.PretEmprunt = 1)');
      SQL.Add('GROUP BY e.ID_Emprunteur, e.NomEmprunteur');
      SQL.Add('ORDER BY 1 DESC, e.NomEmprunteur DESC');
      Open;
      Stats.FMinEmprunteurs := 0;
      Stats.FMaxEmprunteurs := 0;
      if not Eof then
      begin
        Stats.FMaxEmprunteurs := Fields.ByNameAsInteger['CountNumero'];
        while not Eof do
          Next; // Last;
        Stats.FMinEmprunteurs := Fields.ByNameAsInteger['CountNumero'];
        if Stats.FMinEmprunteurs = Stats.FMaxEmprunteurs then
          Stats.FMinEmprunteurs := 0;
        Close;
        Open;
        repeat
          if Fields.ByNameAsInteger['CountNumero'] in [Stats.MinEmprunteurs, Stats.MaxEmprunteurs] then
          begin
            if Fields.ByNameAsInteger['CountNumero'] = Stats.MinEmprunteurs then
              Stats.ListEmprunteursMin.Insert(0, TEmprunteur.Make(Q))
            else
              Stats.ListEmprunteursMax.Insert(0, TEmprunteur.Make(Q));
          end;
          Next;
        until EOF;
      end;

      Close;
      SQL.Clear;
      SQL.Add('SELECT COUNT(DISTINCT st.ID_Edition) FROM Statut st');
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('INNER JOIN Editions e ON e.ID_Edition = st.ID_Edition AND e.ID_Editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
      Open;
      Stats.FNbEmpruntes := Fields.AsInteger[0];

      Close;
      SQL.Text := 'SELECT COUNT(st.ID_Edition)/' + IntToStr(Stats.FNbEmpruntes) + ' AS moy FROM Statut st';
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('INNER JOIN Editions e ON e.ID_Edition = st.ID_Edition AND e.ID_Editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
      SQL.Add('WHERE st.PretEmprunt = 1');
      Stats.FMoyEmpruntes := 0;
      if Bool(Stats.FNbEmpruntes) then
      begin
        Open;
        Stats.FMoyEmpruntes := Fields.ByNameAsInteger['moy'];
      end;

      Close;
      SQL.Clear;
      SQL.Add('SELECT distinct count(ID_Edition) FROM VW_EMPRUNTS WHERE (PretEmprunt = 1)');
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then
        SQL.Add('AND ID_Editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
      SQL.Add('group by ID_Edition');
      SQL.Add('ORDER BY 1');
      Open;
      Stats.FMinEmpruntes := 0;
      Stats.FMaxEmpruntes := 0;
      if not EOF then
      begin
        Stats.FMaxEmpruntes := Fields.AsInteger[0];
        while not Eof do
          Next; // Last;
        Stats.FMinEmpruntes := Fields.AsInteger[0];
        if Stats.FMinEmpruntes = Stats.MaxEmpruntes then
          Stats.FMinEmpruntes := 0;

        Close;
        SQL.Clear;
        SQL.Add('SELECT *');
        SQL.Add('FROM VW_EMPRUNTS');
        SQL.Add('WHERE (PretEmprunt = 1)');
        if not IsEqualGUID(ID_Editeur, GUID_NULL) then
          SQL.Add('AND ID_Editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
        SQL.Add('AND ID_Edition in (SELECT ID_Edition FROM STATUT WHERE PretEmprunt = 1 GROUP BY ID_Edition HAVING Count(ID_Edition) = :CountEdition)');
        Params.AsInteger[0] := Stats.MaxEmpruntes;
        Open;
        while not Eof do
        begin
          Stats.ListAlbumsMax.Insert(0, TAlbum.Make(Q));
          Next;
        end;
        if (Stats.MinEmpruntes > 0) and (Stats.MinEmpruntes <> Stats.MaxEmpruntes) then
        begin
          Close;
          Params.AsInteger[0] := Stats.MinEmpruntes;
          Open;
          while not Eof do
          begin
            Stats.ListAlbumsMin.Insert(0, TAlbum.Make(Q));
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
        SQL.Add('SELECT DISTINCT ed.ID_Editeur, e.NomEditeur FROM Editions ed');
        SQL.Add('INNER JOIN Editeurs e ON ed.ID_Editeur = e.ID_Editeur');
        SQL.Add('ORDER BY e.nomediteur');
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
  NBEmprunts := 0;
  Emprunts.Clear;
end;

constructor TEmpruntsComplet.Create(const Reference: TGUID; Source: TSrcEmprunt; Sens: TSensEmprunt; Apres, Avant: TDateTime; EnCours, Stock: Boolean);
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
    q.SQL.Text := 'SELECT * FROM VW_EMPRUNTS';

    with TStringList.Create do
      try
        case Source of
          seAlbum: Add('ID_Edition = ' + QuotedStr(GUIDToString(Reference)));
          seEmprunteur: Add('ID_Emprunteur = ' + QuotedStr(GUIDToString(Reference)));
        end;
        if EnCours then
          Add('Prete = 1');
        case Sens of
          ssPret: Add('PretEmprunt = 1');
          ssRetour: Add('PretEmprunt = 0');
        end;
        if Apres >= 0 then
          Add('DateEmprunt >= :DateApres');
        if Avant >= 0 then
          Add('DateEmprunt <= :DateAvant');

        for i := 0 to Count - 1 do
        begin
          if i = 0 then
            q.SQL.Add('WHERE')
          else
            q.SQL.Add('and');
          q.SQL.Add(Strings[i]);
        end;
        q.SQL.Add('ORDER BY DateEmprunt DESC, ID_STATUT ASC'); // le dernier saisi a priorité en cas de "même date"
      finally
        Free;
      end;
    if Apres >= 0 then
      q.Params.ByNameAsDateTime['DateApres'] := Apres;
    if Avant >= 0 then
      q.Params.ByNameAsDateTime['DateAvant'] := Avant;
  end;

var
  PE: TEmprunt;
  s: TStringList;
  Ref: string;
begin
  inherited Fill(GUID_NULL);
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      s := TStringList.Create;
      Self.NBEmprunts := 0;
      try
        MakeQuery;
        Open;
        s.Clear;
        while not Eof do
        begin
          Ref := Fields.ByNameAsString['ID_Edition'];
          if not Stock or (s.IndexOf(Ref) = -1) then
          begin
            s.Add(Ref);
            PE := TEmprunt(TEmprunt.Make(q));
            if PE.Pret then
              Inc(Self.FNBEmprunts);
            Self.Emprunts.Add(PE);
          end;
          Next;
        end;
      finally
        s.Free;
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
      SQL.Text := 'SELECT * FROM Albums_MANQUANTS(:WithIntegrales, :WithAchats, :ID_Serie) order by TITRESERIE, TOME';
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
        dummy := StringToGUID(Fields.ByNameAsString['ID_Serie']);
        if not IsEqualGUID(dummy, CurrentSerie) then
        begin
          if not IsEqualGUID(CurrentSerie, GUID_NULL) then
            UpdateSerie;
          Incomplete := TSerieIncomplete.Create;
          Self.Series.Add(Incomplete);
          Incomplete.Serie.Fill(q);
          CurrentSerie := dummy;
          FirstTome := Fields.ByNameAsInteger['TOME'];
          CurrentTome := FirstTome;
        end
        else
        begin
          iDummy := Fields.ByNameAsInteger['TOME'];
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
      SQL.Text := 'SELECT * FROM PREVISIONS_SORTIES(:WithAchats, :ID_Serie) order by ANNEEPARUTION, CASE WHEN MOISPARUTION BETWEEN 1 AND 4 THEN 1 WHEN MOISPARUTION BETWEEN 5 AND 8 THEN 2 WHEN MOISPARUTION BETWEEN 9 AND 12 THEN 3 ELSE 0 END, TITRESERIE';
      Params.AsBoolean[0] := AvecAchats;
      if not IsEqualGUID(ID_Serie, GUID_NULL) then
        Params.AsString[1] := GUIDToString(ID_Serie);
      Open;
      while not Eof do
      begin
        Annee := Fields.ByNameAsInteger['ANNEEPARUTION'];
        Prevision := TPrevisionSortie.Create;
        Prevision.Serie.Fill(q);
        Prevision.Tome := Fields.ByNameAsInteger['TOME'];
        Prevision.Annee := Annee;
        Prevision.Mois := Fields.ByNameAsInteger['MOISPARUTION'];
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
  s: string;
  i: Integer;
begin
  Result := '';
  for i := 0 to NumerosManquants.Count - 1 do
  begin
    s := NumerosManquants[i];
    if Pos('<>', s) <> 0 then
      s := StringReplace(s, '<>', ' à ', []);
    AjoutString(Result, s, ', ');
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
      SQL.Text := 'SELECT NOMPERSONNE, SITEWEB, BIOGRAPHIE FROM PERSONNES WHERE ID_Personne = ?';
      Params.AsString[0] := GUIDToString(Reference);
      FetchBlobs := True;
      Open;
      RecInconnu := Eof;

      if not RecInconnu then
      begin
        Self.NomAuteur := Fields.ByNameAsString['NOMPERSONNE'];
        Self.Biographie.Text := Fields.ByNameAsString['BIOGRAPHIE'];
        Self.SiteWeb := Trim(Fields.ByNameAsString['SITEWEB']);
        FetchBlobs := False;

        SQL.Clear;
        // TitreSerie en premier pour forcer l'union à trier sur le titre
        SQL.Add('SELECT TITRESERIE, al.ID_Serie');
        SQL.Add('FROM VW_LISTE_ALBUMS al');
        SQL.Add('  INNER JOIN AUTEURS au ON al.ID_Album = au.ID_Album AND au.ID_Personne = :ID_Personne');
        SQL.Add('union');
        SQL.Add('SELECT TITRESERIE, s.ID_Serie');
        SQL.Add('FROM auteurs_series au');
        SQL.Add('  INNER JOIN SERIES s ON s.ID_Serie = au.ID_Serie AND au.ID_Personne = :ID_Personne');
        SQL.Add('union');
        SQL.Add('SELECT TITRESERIE, p.ID_Serie');
        SQL.Add('FROM auteurs_parabd ap');
        SQL.Add('  INNER JOIN VW_LISTE_PARABD p ON ap.ID_PARABD = p.ID_PARABD and ap.ID_Personne = :ID_Personne');
        Params.ByNameAsString['ID_Personne'] := GUIDToString(Reference);
        Open;
        while not Eof do
        begin
          if Fields.IsNull[1] then
            Series.Insert(0, TSerieComplete.Create(GUID_NULL, Reference, True))
          else
            Series.Add(TSerieComplete.Create(StringToGUID(Fields.AsString[1]), Reference, True));
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
  s: string;
  q: TUIBQuery;
begin
  inherited;
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := UseTransaction;

      SQL.Text := 'update or insert into personnes (id_personne, nompersonne, siteweb, biographie) values (:id_personne, :nompersonne, :siteweb, :biographie)';

      if IsEqualGUID(GUID_NULL, ID_Auteur) then
        Params.ByNameIsNull['id_personne'] := True
      else
        Params.ByNameAsString['id_personne'] := GUIDToString(ID_Auteur);
      Params.ByNameAsString['nompersonne'] := Trim(NomAuteur);
      Params.ByNameAsString['siteweb'] := Trim(SiteWeb);
      s := Biographie.Text;
      ParamsSetBlob('biographie', s);
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
var
  q: TUIBQuery;
begin
  if IsEqualGUID(ID_ParaBD, GUID_NULL) then
    Exit;
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'UPDATE PARABD SET ACHAT = :Achat WHERE ID_ParaBD = ?';
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
  s: string;
begin
  if Simple then
    Result := Titre
  else
    Result := FormatTitre(Titre);
  s := '';
  if AvecSerie then
    if Result = '' then
      Result := FormatTitre(Serie.Titre)
    else
      AjoutString(s, FormatTitre(Serie.Titre), ' - ');
  AjoutString(s, CategorieParaBD.Caption, ' - ');
  if Result = '' then
    Result := s
  else
    AjoutString(Result, s, ' ', '(', ')');
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
  serie: TGUID;
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
      SQL.Text := 'SELECT TITREPARABD, ANNEE, ID_Serie, ACHAT, DESCRIPTION, DEDICACE, NUMEROTE, ANNEECOTE, PRIXCOTE, GRATUIT, OFFERT, DATEACHAT, PRIX, STOCK, CATEGORIEPARABD, lc.Libelle AS sCATEGORIEPARABD,';
      SQL.Add('FICHIERPARABD, STOCKAGEPARABD, case when IMAGEPARABD is null then 0 else 1 end as HASBLOBIMAGE');
      SQL.Add('FROM PARABD p');
      SQL.Add('LEFT JOIN LISTES lc on (lc.ref = p.CATEGORIEPARABD and lc.categorie = 7)');
      SQL.Add('WHERE ID_ParaBD = ?');

      Params.AsString[0] := GUIDToString(Reference);
      Open;
      RecInconnu := Eof;

      if not RecInconnu then
      begin
        Self.Titre := Fields.ByNameAsString['TITREPARABD'];
        Self.AnneeEdition := Fields.ByNameAsInteger['ANNEE'];
        Self.Description.Text := Fields.ByNameAsString['DESCRIPTION'];
        Self.CategorieParaBD := MakeOption(Fields.ByNameAsInteger['CategorieParaBD'], Fields.ByNameAsString['sCategorieParaBD']);
        Self.Prix := Fields.ByNameAsCurrency['PRIX'];
        Self.Dedicace := Fields.ByNameAsBoolean['DEDICACE'];
        Self.Numerote := Fields.ByNameAsBoolean['Numerote'];
        Self.Offert := Fields.ByNameAsBoolean['OFFERT'];
        Self.Gratuit := Fields.ByNameAsBoolean['GRATUIT'];
        Self.Stock := Fields.ByNameAsBoolean['STOCK'];
        Self.DateAchat := Fields.ByNameAsDate['DateAchat'];
        Self.AnneeCote := Fields.ByNameAsInteger['ANNEECOTE'];
        Self.PrixCote := Fields.ByNameAsCurrency['PRIXCOTE'];

        serie := StringToGUIDDef(Fields.ByNameAsString['ID_SERIE'], GUID_NULL);

        ImageStockee := Fields.ByNameAsBoolean['STOCKAGEPARABD'];
        FichierImage := Fields.ByNameAsString['FICHIERPARABD'];
        HasImage := (Fields.ByNameAsSmallint['HASBLOBIMAGE'] = 1) or (FichierImage <> '');

        OldImageStockee := ImageStockee;
        OldFichierImage := FichierImage;
        OldHasImage := HasImage;

        Close;
        SQL.Text := 'SELECT * FROM PROC_AUTEURS(NULL, NULL, ?)';
        Params.AsString[0] := GUIDToString(Reference);
        Open;
        TAuteur.FillList(TList<TBasePointeur>(Self.Auteurs), q);

        Self.Serie.Fill(serie);
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
  s: string;
  q: TUIBQuery;
  i: Integer;
  hg: IHourGlass;
  Stream: TStream;
begin
  inherited;
  hg := THourGlass.Create;
  q := TUIBQuery.Create(nil);
  with q do
    try
      Transaction := UseTransaction;

      SQL.Text := 'UPDATE OR INSERT INTO PARABD (ID_ParaBD, TITREPARABD, ANNEE, ID_Serie, CATEGORIEPARABD, DEDICACE, NUMEROTE, ANNEECOTE, PRIXCOTE, GRATUIT, OFFERT, DATEACHAT, PRIX, STOCK, DESCRIPTION, COMPLET)';
      SQL.Add('VALUES');
      SQL.Add('(:ID_ParaBD, :TITREPARABD, :ANNEE, :ID_Serie, :CATEGORIEPARABD, :DEDICACE, :NUMEROTE, :ANNEECOTE, :PRIXCOTE, :GRATUIT, :OFFERT, :DATEACHAT, :PRIX, :STOCK, :DESCRIPTION, 1)');

      if IsEqualGUID(GUID_NULL, ID_ParaBD) then
        Params.ByNameIsNull['ID_ParaBD'] := True
      else
        Params.ByNameAsString['ID_ParaBD'] := GUIDToString(ID_ParaBD);
      s := Trim(Titre);
      if s = '' then
        Params.ByNameIsNull['TITREPARABD'] := True
      else
        Params.ByNameAsString['TITREPARABD'] := s;
      if AnneeEdition = 0 then
        Params.ByNameIsNull['ANNEE'] := True
      else
        Params.ByNameAsInteger['ANNEE'] := AnneeEdition;
      Params.ByNameAsInteger['CATEGORIEPARABD'] := CategorieParaBD.Value;
      Params.ByNameAsBoolean['DEDICACE'] := Dedicace;
      Params.ByNameAsBoolean['NUMEROTE'] := Numerote;
      s := description.Text;
      if s <> '' then
        ParamsSetBlob('DESCRIPTION', s)
      else
        Params.ByNameIsNull['DESCRIPTION'] := True;
      Params.ByNameAsBoolean['GRATUIT'] := Gratuit;
      Params.ByNameAsBoolean['OFFERT'] := Offert;

      if DateAchat = 0 then
        Params.ByNameIsNull['DATEACHAT'] := True
      else
        Params.ByNameAsDate['DATEACHAT'] := Trunc(DateAchat);
      if Prix = 0 then
        Params.ByNameIsNull['PRIX'] := True
      else
        Params.ByNameAsCurrency['PRIX'] := Prix;
      if (AnneeCote = 0) or (PrixCote = 0) then
      begin
        Params.ByNameIsNull['ANNEECOTE'] := True;
        Params.ByNameIsNull['PRIXCOTE'] := True;
      end
      else
      begin
        Params.ByNameAsInteger['ANNEECOTE'] := AnneeCote;
        Params.ByNameAsCurrency['PRIXCOTE'] := PrixCote;
      end;
      Params.ByNameAsBoolean['STOCK'] := Stock;

      if Serie.RecInconnu or IsEqualGUID(Serie.ID_Serie, GUID_NULL) then
        Params.ByNameIsNull['ID_SERIE'] := True
      else
        Params.ByNameAsString['ID_SERIE'] := GUIDToString(Serie.ID_Serie);
      ExecSQL;

      SupprimerToutDans('', 'AUTEURS_PARABD', 'ID_ParaBD', ID_ParaBD);
      SQL.Clear;
      SQL.Add('INSERT INTO AUTEURS_PARABD (ID_ParaBD, ID_Personne)');
      SQL.Add('VALUES (:ID_Album, :ID_Personne)');
      for i := 0 to Pred(Auteurs.Count) do
      begin
        Params.AsString[0] := GUIDToString(ID_ParaBD);
        Params.AsString[1] := GUIDToString(TAuteur(Auteurs[i]).Personne.ID);
        ExecSQL;
      end;

      if not HasImage then
      begin
        SQL.Text := 'UPDATE PARABD SET IMAGEPARABD = NULL, STOCKAGEPARABD = 0, FICHIERPARABD = NULL WHERE ID_ParaBD = :ID_ParaBD';
        Params.ByNameAsString['ID_ParaBD'] := GUIDToString(ID_ParaBD);
        ExecSQL;
      end
      else if (OldFichierImage <> FichierImage) or (OldImageStockee <> ImageStockee) then
      begin
        if ImageStockee then
        begin
          SQL.Text := 'UPDATE PARABD SET IMAGEPARABD = :IMAGEPARABD, STOCKAGEPARABD = 1, FICHIERPARABD = :FICHIERPARABD WHERE ID_ParaBD = :ID_ParaBD';
          if ExtractFilePath(FichierImage) = '' then
            FichierImage := IncludeTrailingPathDelimiter(RepImages) + FichierImage;
          Stream := GetCouvertureStream(FichierImage, -1, -1, False);
          try
            ParamsSetBlob('IMAGEPARABD', Stream);
          finally
            Stream.Free;
          end;
          Params.ByNameAsString['FICHIERPARABD'] := ExtractFileName(FichierImage);
          Params.ByNameAsString['ID_ParaBD'] := GUIDToString(ID_ParaBD);
          ExecSQL;
        end
        else
        begin
          SQL.Text := 'SELECT Result FROM SAVEBLOBTOFILE(:Chemin, :Fichier, :BlobContent)';
          if ExtractFilePath(FichierImage) = '' then
            Stream := GetCouvertureStream(True, ID_ParaBD, -1, -1, False)
          else
            Stream := GetCouvertureStream(FichierImage, -1, -1, False);
          try
            FichierImage := SearchNewFileName(RepImages, ExtractFileName(FichierImage), True);
            Params.ByNameAsString['Chemin'] := RepImages;
            Params.ByNameAsString['Fichier'] := FichierImage;
            ParamsSetBlob('BlobContent', Stream);
          finally
            Stream.Free;
          end;
          Open;

          SQL.Text := 'UPDATE PARABD SET IMAGEPARABD = NULL, STOCKAGEPARABD = 0, FICHIERPARABD = :FICHIERPARABD WHERE ID_ParaBD = :ID_ParaBD';
          Params.ByNameAsString['FICHIERPARABD'] := FichierImage;
          Params.ByNameAsString['ID_ParaBD'] := GUIDToString(ID_ParaBD);
          ExecSQL;
        end;
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
      SQL.Text := 'SELECT NOMCOLLECTION, ID_EDITEUR FROM COLLECTIONS WHERE ID_COLLECTION = ?';
      Params.AsString[0] := GUIDToString(Reference);
      Open;
      RecInconnu := Eof;

      if not RecInconnu then
      begin
        Self.NomCollection := Fields.ByNameAsString['NOMCOLLECTION'];
        Self.ID_Editeur := StringToGUIDDef(Fields.ByNameAsString['ID_EDITEUR'], GUID_NULL);
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

      SQL.Text := 'UPDATE OR INSERT INTO COLLECTIONS (ID_Collection, NOMCOLLECTION, ID_Editeur) VALUES (:ID_Collection, :NOMCOLLECTION, :ID_Editeur)';

      if IsEqualGUID(GUID_NULL, ID_Collection) then
        Params.ByNameIsNull['ID_Collection'] := True
      else
        Params.ByNameAsString['ID_Collection'] := GUIDToString(ID_Collection);
      Params.ByNameAsString['NOMCOLLECTION'] := Trim(NomCollection);
      Params.ByNameAsString['ID_EDITEUR'] := GUIDToString(ID_Editeur);
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

procedure TObjetComplet.SaveAssociations(TypeData: TVirtualMode; ParentID: TGUID);
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
        if Trim(FAssociations[i]) <> '' then begin
          Params.AsString[0] := Copy(Trim(FAssociations[i]), 1, Params.SQLLen[0]);
          Params.AsString[1] := GuidToString(ID);
          Params.AsString[2] := GuidToString(ParentID);
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

    Result := 'ALBUMS INNER JOIN EDITIONS ON ALBUMS.ID_Album = EDITIONS.ID_Album LEFT JOIN SERIES ON ALBUMS.ID_Serie = SERIES.ID_Serie';
    slFrom.Delete(slFrom.IndexOf('ALBUMS'));
    slFrom.Delete(slFrom.IndexOf('SERIES'));
    slFrom.Delete(slFrom.IndexOf('EDITIONS'));
    i := slFrom.IndexOf('GENRESERIES');
    if i <> -1 then
    begin
      Result := Result + ' LEFT OUTER JOIN GENRESERIES ON GENRESERIES.ID_Serie = ALBUMS.ID_Serie';
      slFrom.Delete(i);
    end;
  end;

  function ProcessSort(out sOrderBy: string): string;
  var
    i: Integer;
    Critere: TCritereTri;
    s: string;
  begin
    sOrderBy := '';
    Result := '';
    for i := 0 to Pred(SortBy.Count) do
    begin
      Critere := TCritereTri(SortBy[i]);
      Critere._Champ := ChampByID(Critere.iChamp);
      s := string(Critere.NomTable + '.' + Critere.Champ);
      Result := Result + ', ' + s;
      if not Critere.Asc then
        s := s + ' DESC';
      if Critere.NullsFirst then
        s := s + ' NULLS FIRST'
      else if Critere.NullsLast then
        s := s + ' NULLS LAST';
      sOrderBy := sOrderBy + s + ', ';
      slFrom.Add(string(Critere.NomTable));
    end;
  end;

  function ProcessCritere(ItemCritere: TGroupCritere): string;
  var
    p: TBaseCritere;
    i: Integer;
    sBool: string;
  begin
    Result := '';
    if ItemCritere.GroupOption = goOu then
      sBool := ' OR '
    else
      sBool := ' AND ';
    for i := 0 to Pred(ItemCritere.SousCriteres.Count) do
    begin
      p := ItemCritere.SousCriteres[i];
      if p is TCritere then
      begin
        if Result = '' then
          Result := '(' + TCritere(p).TestSQL + ')'
        else
          Result := Result + sBool + '(' + TCritere(p).TestSQL + ')';
        slFrom.Add(string(TCritere(p).NomTable));
      end
      else
      begin
        if Result = '' then
          Result := '(' + ProcessCritere(p as TGroupCritere) + ')'
        else
          Result := Result + sBool + '(' + ProcessCritere(p as TGroupCritere) + ')';
      end;
    end;
  end;

var
  Album: TAlbum;
  i: Integer;
  q: TUIBQuery;
  sWhere, sOrderBy, s: string;
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
      SQL.Text := 'SELECT DISTINCT ALBUMS.ID_Album, ALBUMS.TITREALBUM, ALBUMS.TOME, ALBUMS.TOMEDEBUT, ALBUMS.TOMEFIN, ALBUMS.HORSSERIE, ALBUMS.INTEGRALE, ALBUMS.MOISPARUTION, ALBUMS.ANNEEPARUTION, ALBUMS.ID_Serie, SERIES.TITRESERIE';
      SQL.Add(ProcessSort(sOrderBy));
      slFrom.Add('ALBUMS');
      slFrom.Add('SERIES');
      slFrom.Add('EDITIONS');
      sWhere := ProcessCritere(Criteres);

      SQL.Add('FROM ' + ProcessTables);

      if sWhere <> '' then
        SQL.Add('WHERE ' + sWhere);

      SQL.Add('ORDER BY ' + sOrderBy + 'COALESCE(ALBUMS.TITREALBUM, SERIES.TITRESERIE), SERIES.TITRESERIE, ALBUMS.HORSSERIE NULLS FIRST, ALBUMS.INTEGRALE NULLS FIRST,');
      SQL.Add('ALBUMS.TOME NULLS FIRST, ALBUMS.TOMEDEBUT NULLS FIRST, ALBUMS.TOMEFIN NULLS FIRST, ALBUMS.ANNEEPARUTION NULLS FIRST, ALBUMS.MOISPARUTION NULLS FIRST');

      Open;
      while not EOF do
      begin
        Album := TAlbum.Create;
        Album.Fill(q);
        Resultats.Add(Album);
        s := '';
        for i := 0 to Pred(SortBy.Count) do
        begin
          CritereTri := TCritereTri(SortBy[i]);
          if CritereTri.Imprimer then
          begin
            AjoutString(s, CritereTri.LabelChamp + ' : ', #13#10);
            if Fields.ByNameIsNull[CritereTri.Champ] then
              s := s + '<vide>'
            else if CritereTri._Champ.Booleen then
              s := s + IIf(Fields.ByNameAsBoolean[CritereTri.Champ], 'Oui', 'Non')
            else
              case CritereTri._Champ.Special of
                csISBN: s := s + FormatISBN(Fields.ByNameAsString[CritereTri.Champ]);
                csTitre: s := s + FormatTitre(Fields.ByNameAsString[CritereTri.Champ]);
                csMonnaie: s := s + FormatCurr(FormatMonnaie, Fields.ByNameAsCurrency[CritereTri.Champ]);
                else
                  case CritereTri._Champ.TypeData of
                    uftDate: s := s + FormatDateTime('dd mmm yyyy', Fields.ByNameAsDate[CritereTri.Champ]);
                    uftTime: s := s + FormatDateTime('hh:mm:ss', Fields.ByNameAsTime[CritereTri.Champ]);
                    uftTimestamp: s := s + FormatDateTime('dd mmm yyyy, hh:mm:ss', Fields.ByNameAsDateTime[CritereTri.Champ]);
                    else
                      s := s + StringReplace(AdjustLineBreaks(Fields.ByNameAsString[CritereTri.Champ], tlbsCRLF), #13#10, '\n', [rfReplaceAll]);
                  end;
              end;
          end;
        end;
        ResultatsInfos.Add(s);
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
  Proc: array[0..4] of string = ('ALBUMS_BY_AUTEUR(?, NULL)',
    'ALBUMS_BY_SERIE(?, NULL)',
    'ALBUMS_BY_EDITEUR(?, NULL)',
    'ALBUMS_BY_GENRE(?, NULL)',
    'ALBUMS_BY_COLLECTION(?, NULL)');
var
  q: TUIBQuery;
  s: string;
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
        SQL.Text := 'SELECT * FROM ' + Proc[Integer(Recherche)];
        Params.AsString[0] := GUIDToString(ID);
        FLibelle := Libelle;
        Open;
        oldID_Album := GUID_NULL;
        oldIndex := -1;
        s := '';
        while not EOF do
        begin
          if isEqualGUID(oldID_Album, StringToGUID(Fields.ByNameAsString['ID_Album'])) and (oldIndex <> -1) then
          begin
            if Recherche = rsAuteur then
            begin
              s := ResultatsInfos[oldIndex];
              case TMetierAuteur(Fields.ByNameAsInteger['Metier']) of
                maScenariste: AjoutString(s, rsTransScenario, ', ');
                maDessinateur: AjoutString(s, rsTransDessins, ', ');
                maColoriste: AjoutString(s, rsTransCouleurs, ', ');
              end;
              ResultatsInfos[oldIndex] := s;
            end;
          end
          else
          begin
            Album := TAlbum.Create;
            Album.Fill(q);
            Resultats.Add(Album);
            if Recherche = rsAuteur then
              case TMetierAuteur(Fields.ByNameAsInteger['Metier']) of
                maScenariste: oldIndex := ResultatsInfos.Add(rsTransScenario);
                maDessinateur: oldIndex := ResultatsInfos.Add(rsTransDessins);
                maColoriste: oldIndex := ResultatsInfos.Add(rsTransCouleurs);
              end
            else
              ResultatsInfos.Add('');
          end;
          oldID_Album := StringToGUID(Fields.ByNameAsString['ID_Album']);
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
  SortBy := TObjectList.Create(True);
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
    Stream.Read(Result, SizeOf(Integer));
  end;

  function ReadString: string;
  var
    l: Integer;
  begin
    l := ReadInteger;
    SetLength(Result, l);
    Stream.Read(Result[1], l);
  end;

  function CreateCritere(CritereType: Integer; ParentCritere: TBaseCritere; const Text: string): TBaseCritere;
  begin
    Assert(not Assigned(ParentCritere) or (ParentCritere is TGroupCritere), 'Architecture des critères incorrecte.');
    case CritereType of
      0: Result := AddGroup(ParentCritere as TGroupCritere);
      1: Result := AddCritere(ParentCritere as TGroupCritere);
      else
        raise Exception.Create('Type de critère inconnu: ' + IntToStr(CritereType));
    end;
    Result.LoadFromStream(Stream);
  end;

var
  lvl, CritereType, i: Integer;
  str: string;
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
      ACritere := CreateCritere(CritereType, nil, str)
    else if ACritere.Level = lvl then
      ACritere := CreateCritere(CritereType, ACritere.Parent, str)
    else if ACritere.Level = (lvl - 1) then
      ACritere := CreateCritere(CritereType, ACritere, str)
    else if ACritere.Level > lvl then
    begin
      NextCritere := ACritere.Parent;
      while NextCritere.Level > lvl do
        NextCritere := NextCritere.Parent;
      ACritere := CreateCritere(CritereType, NextCritere.Parent, str);
    end;
  end;
end;

procedure TRecherche.SaveToStream(Stream: TStream);

  procedure WriteInteger(Value: Integer);
  begin
    Stream.Write(Value, SizeOf(Integer));
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

  procedure ProcessSousCriteres(aCritere: TGroupCritere);
  var
    i: Integer;
    Critere: TBaseCritere;
  begin
    for i := 0 to Pred(aCritere.SousCriteres.Count) do
    begin
      Critere := aCritere.SousCriteres[i];
      WriteCritere(Critere);
      if (Critere is TGroupCritere) then
        ProcessSousCriteres(TGroupCritere(Critere));
    end;
  end;

  procedure WriteSortBy;
  var
    i: Integer;
  begin
    WriteInteger(SortBy.Count);
    for i := 0 to Pred(SortBy.Count) do
      TCritereTri(SortBy[i]).SaveToStream(Stream);
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
    Stream.Read(Result, SizeOf(Integer));
  end;

  function ReadString: string;
  var
    l: Integer;
  begin
    l := ReadInteger;
    SetLength(Result, l);
    Stream.Read(Result[1], l);
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
    Stream.Write(Value, SizeOf(Integer));
  end;

  procedure WriteString(const Value: string);
  var
    l: Integer;
  begin
    l := Length(Value);
    WriteInteger(l);
    Stream.WriteBuffer(Value[1], l);
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
  SousCriteres := TObjectList.Create(True);
end;

destructor TGroupCritere.Destroy;
begin
  FreeAndNil(SousCriteres);
  inherited;
end;

procedure TGroupCritere.LoadFromStream(Stream: TStream);
begin
  inherited;
  Stream.Read(GroupOption, SizeOf(Byte));
end;

procedure TGroupCritere.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(Byte(GroupOption), SizeOf(Byte));
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
    Stream.Read(Result, SizeOf(Integer));
  end;

  function ReadBool: Boolean;
  var
    dummy: Byte;
  begin
    Stream.Read(dummy, SizeOf(Byte));
    Result := dummy = 1;
  end;

  function ReadString: string;
  var
    l: Integer;
  begin
    l := ReadInteger;
    SetLength(Result, l);
    Stream.Read(Result[1], l);
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
    Stream.Write(Value, SizeOf(Integer));
  end;

  procedure WriteBool(Value: Boolean);
  var
    dummy: Byte;
  begin
    if Value then
      dummy := 1
    else
      dummy := 0;
    Stream.Write(dummy, SizeOf(Byte));
  end;

  procedure WriteString(const Value: string);
  var
    l: Integer;
  begin
    l := Length(Value);
    WriteInteger(l);
    Stream.WriteBuffer(Value[1], l);
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
