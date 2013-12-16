unit EntitiesFull;

interface

uses
  SysUtils, Windows, Classes, Dialogs, EntitiesLite, Commun, CommonConst, UdmPrinc, UIB, DateUtils, UChampsRecherche, Generics.Collections,
  Generics.Defaults, VirtualTree;

type
  AutoTrimString = record
  private
    Value: string;
  public
    class operator Implicit(a: string): AutoTrimString;
    class operator Implicit(a: AutoTrimString): string;
  end;

  LongString = record
  private
    Value: string;
  public
    class operator Implicit(a: string): LongString;
    class operator Implicit(a: LongString): string;
  end;

  ROption = record
    Value: Integer;
    Caption: AutoTrimString;
  end;

function MakeOption(Value: Integer; const Caption: AutoTrimString): ROption; inline;

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

  TObjetCompletClass = class of TObjetComplet;

  TObjetComplet = class(TBaseComplet)
  strict private
    FAssociations: TStringList;
  private
    FID: TGUID;
  public
    RecInconnu: Boolean;
    destructor Destroy; override;
    procedure Clear; override;
    procedure PrepareInstance; override;
    procedure SaveToDatabase; overload;
    procedure SaveToDatabase(UseTransaction: TUIBTransaction); overload; virtual;
    procedure New(ClearInstance: Boolean = True);
    function ChaineAffichage(dummy: Boolean = True): string; virtual;
  published
    property ID: TGUID read FID;
    property Associations: TStringList read FAssociations;
  end;

  TInfoComplet = class(TBaseComplet)
  end;

  TListComplet = class(TBaseComplet)
  end;

  TEditeurFull = class(TObjetComplet)
  strict private
    FNomEditeur: AutoTrimString;
    FSiteWeb: AutoTrimString;
    procedure SetNomEditeur(const Value: AutoTrimString); inline;
    procedure SetSiteWeb(const Value: AutoTrimString); inline;
  public
    procedure Clear; override;
  published
    property ID_Editeur: TGUID read FID write FID;
    property NomEditeur: AutoTrimString read FNomEditeur write SetNomEditeur;
    property SiteWeb: AutoTrimString read FSiteWeb write SetSiteWeb;
  end;

  TCollectionFull = class(TObjetComplet)
  strict private
    FNomCollection: AutoTrimString;
    FEditeur: TEditeurLite;
    function GetID_Editeur: TGUID; inline;
    procedure SetID_Editeur(const Value: TGUID); inline;
    procedure SetNomCollection(const Value: AutoTrimString); inline;
  public
    destructor Destroy; override;
    procedure Clear; override;
    procedure PrepareInstance; override;
  published
    property ID_Collection: TGUID read FID write FID;
    property NomCollection: AutoTrimString read FNomCollection write SetNomCollection;
    property Editeur: TEditeurLite read FEditeur;
    property ID_Editeur: TGUID read GetID_Editeur write SetID_Editeur;
  end;

  TUniversFull = class(TObjetComplet)
  strict private
    FNomUnivers: AutoTrimString;
    FUniversParent: TUniversLite;
    FDescription: LongString;
    FSiteWeb: AutoTrimString;
    procedure SetNomUnivers(const Value: AutoTrimString); inline;
    function GetID_UniversParent: TGUID; inline;
    procedure SetID_UniversParent(const Value: TGUID); inline;
    procedure SetSiteWeb(const Value: AutoTrimString);
  public
    destructor Destroy; override;
    procedure Clear; override;
    procedure PrepareInstance; override;
    function ChaineAffichage(dummy: Boolean = True): string; override;
  published
    property ID_Univers: TGUID read FID write FID;
    property NomUnivers: AutoTrimString read FNomUnivers write SetNomUnivers;
    property SiteWeb: AutoTrimString read FSiteWeb write SetSiteWeb;
    property Description: LongString read FDescription write FDescription;
    property UniversParent: TUniversLite read FUniversParent;
    property ID_UniversParent: TGUID read GetID_UniversParent write SetID_UniversParent;
  end;

  TSerieFull = class(TObjetComplet)
  strict private
    FTitreSerie: AutoTrimString;
    FTerminee: Integer;
    FSujet: LongString;
    FNotes: LongString;
    FCollection: TCollectionLite;
    FSiteWeb: AutoTrimString;
    FGenres: TStringList;
    FEditeur: TEditeurFull;
    FSuivreManquants: Boolean;
    FColoristes: TObjectList<TAuteurLite>;
    FComplete: Boolean;
    FScenaristes: TObjectList<TAuteurLite>;
    FSuivreSorties: Boolean;
    FCouleur: Integer;
    FDessinateurs: TObjectList<TAuteurLite>;
    FAlbums: TObjectList<TAlbumLite>;
    FParaBD: TObjectList<TParaBDLite>;
    FNbAlbums: Integer;
    FVO: Integer;
    FReliure: ROption;
    FEtat: ROption;
    FFormatEdition: ROption;
    FTypeEdition: ROption;
    FOrientation: ROption;
    FSensLecture: ROption;
    FNotation: Integer;
    FUnivers: TObjectList<TUniversLite>;
    function GetID_Editeur: TGUID; inline;
    procedure SetID_Editeur(const Value: TGUID); inline;
    function GetID_Collection: TGUID; inline;
    procedure SetID_Collection(const Value: TGUID); inline;
    procedure SetTitreSerie(const Value: AutoTrimString); inline;
    procedure SetSiteWeb(const Value: AutoTrimString); inline;

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
    procedure Clear; override;
    procedure PrepareInstance; override;
    function ChaineAffichage: string; reintroduce; overload;
    function ChaineAffichage(Simple: Boolean): string; overload; override;
  published
    property ID_Serie: TGUID read FID write FID;
    property ID_Editeur: TGUID read GetID_Editeur write SetID_Editeur;
    property ID_Collection: TGUID read GetID_Collection write SetID_Collection;
    property TitreSerie: AutoTrimString read FTitreSerie write SetTitreSerie;
    property Terminee: Integer read FTerminee write FTerminee;
    property Genres: TStringList read FGenres;
    property Sujet: LongString read FSujet write FSujet;
    property Notes: LongString read FNotes write FNotes;
    property Editeur: TEditeurFull read FEditeur;
    property Collection: TCollectionLite read FCollection;
    property SiteWeb: AutoTrimString read FSiteWeb write SetSiteWeb;
    property Complete: Boolean read FComplete write FComplete;
    property SuivreManquants: Boolean read FSuivreManquants write FSuivreManquants;
    property SuivreSorties: Boolean read FSuivreSorties write FSuivreSorties;
    property NbAlbums: Integer read FNbAlbums write FNbAlbums;
    property Albums: TObjectList<TAlbumLite> read FAlbums;
    property ParaBD: TObjectList<TParaBDLite> read FParaBD;
    property Scenaristes: TObjectList<TAuteurLite> read FScenaristes;
    property Dessinateurs: TObjectList<TAuteurLite> read FDessinateurs;
    property Coloristes: TObjectList<TAuteurLite> read FColoristes;
    property VO: Integer read FVO write FVO;
    property Couleur: Integer read FCouleur write FCouleur;
    property Etat: ROption read FEtat write FEtat;
    property Reliure: ROption read FReliure write FReliure;
    property TypeEdition: ROption read FTypeEdition write FTypeEdition;
    property FormatEdition: ROption read FFormatEdition write FFormatEdition;
    property Orientation: ROption read FOrientation write FOrientation;
    property SensLecture: ROption read FSensLecture write FSensLecture;
    property Notation: Integer read FNotation write FNotation;
    property Univers: TObjectList<TUniversLite> read FUnivers;

    // pour rétrocompatibilité pour les scripts
    property Titre: AutoTrimString read FTitreSerie write SetTitreSerie;
  end;

  TAuteurFull = class(TObjetComplet)
  strict private
    FBiographie: LongString;
    FNomAuteur: AutoTrimString;
    FSiteWeb: AutoTrimString;
    FSeries: TObjectList<TSerieFull>;
    procedure SetNomAuteur(const Value: AutoTrimString); inline;
    procedure SetSiteWeb(const Value: AutoTrimString); inline;
  public
    destructor Destroy; override;
    procedure Clear; override;
    procedure PrepareInstance; override;
    function ChaineAffichage(dummy: Boolean = True): string; override;
  published
    property ID_Auteur: TGUID read FID write FID;
    property NomAuteur: AutoTrimString read FNomAuteur write SetNomAuteur;
    property SiteWeb: AutoTrimString read FSiteWeb write SetSiteWeb;
    property Biographie: LongString read FBiographie write FBiographie;
    property Series: TObjectList<TSerieFull> read FSeries;
  end;

  TEditionFull = class(TObjetComplet)
  strict private
    FStock: Boolean;
    FCouvertures: TObjectList<TCouvertureLite>;
    FPrix: Currency;
    FAnneeCote: Integer;
    FISBN: AutoTrimString;
    FGratuit: Boolean;
    FPrete: Boolean;
    FNombreDePages: Integer;
    FNumeroPerso: AutoTrimString;
    FNotes: LongString;
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
    FID_Album: TGUID;
    FVO: Boolean;
    function Get_sDateAchat: string; inline;
    procedure SetNumeroPerso(const Value: AutoTrimString); inline;

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
    procedure Clear; override;
    procedure PrepareInstance; override;
    function ChaineAffichage(dummy: Boolean = True): string; override;
    procedure FusionneInto(Dest: TEditionFull);
  published
    property ID_Edition: TGUID read FID write FID;
    property ID_Album: TGUID read FID_Album write FID_Album;
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
    property ISBN: AutoTrimString read FISBN write FISBN;
    property DateAchat: TDateTime read FDateAchat write FDateAchat;
    property sDateAchat: string read Get_sDateAchat;
    property Notes: LongString read FNotes write FNotes;
    property NumeroPerso: AutoTrimString { [25] } read FNumeroPerso write SetNumeroPerso;
    property Couvertures: TObjectList<TCouvertureLite> read FCouvertures;
  end;

  TEditionsCompletes = class(TListComplet)
  strict private
    FEditions: TObjectList<TEditionFull>;
  public
    procedure Fill(const Reference: TGUID; Stock: Integer = -1); reintroduce;
    procedure PrepareInstance; override;
    procedure Clear; override;
    constructor Create(const Reference: TGUID; Stock: Integer = -1); reintroduce; overload;
    destructor Destroy; override;
    procedure FusionneInto(Dest: TEditionsCompletes);
  published
    property Editions: TObjectList<TEditionFull> read FEditions;
  end;

  TAlbumFull = class(TObjetComplet)
  strict private
    FTitreAlbum: AutoTrimString;
    FSerie: TSerieFull;
    FSujet: LongString;
    FHorsSerie: Boolean;
    FMoisParution: Integer;
    FTomeFin: Integer;
    FColoristes: TObjectList<TAuteurLite>;
    FNotes: LongString;
    FAnneeParution: Integer;
    FScenaristes: TObjectList<TAuteurLite>;
    FIntegrale: Boolean;
    FDessinateurs: TObjectList<TAuteurLite>;
    FTomeDebut: Integer;
    FTome: Integer;
    FEditions: TEditionsCompletes;
    FComplet: Boolean;
    FReadyToFusion: Boolean;
    FFusionneEditions: Boolean;
    FNotation: Integer;
    FDefaultSearch: AutoTrimString;
    FUnivers: TObjectList<TUniversLite>;
    FUniversFull: TList<TUniversLite>;
    function GetID_Serie: TGUID; inline;
    procedure SetID_Serie(const Value: TGUID); inline;
    procedure SetTitreAlbum(const Value: AutoTrimString); inline;
  private
    function GetDefaultSearch: string;
    procedure SetDefaultSearch(const Value: string);
  public
    procedure Clear; override;
    procedure PrepareInstance; override;
    destructor Destroy; override;
    function ChaineAffichage(AvecSerie: Boolean): string; overload; override;
    function ChaineAffichage(Simple, AvecSerie: Boolean): string; reintroduce; overload;

    procedure FusionneInto(Dest: TAlbumFull);
    property ReadyToFusion: Boolean read FReadyToFusion write FReadyToFusion;
    property FusionneEditions: Boolean read FFusionneEditions write FFusionneEditions;
    property DefaultSearch: string read GetDefaultSearch write SetDefaultSearch;
  published
    property Complet: Boolean read FComplet write FComplet;
    property ID_Album: TGUID read FID write FID;
    property ID_Serie: TGUID read GetID_Serie write SetID_Serie;
    property TitreAlbum: AutoTrimString read FTitreAlbum write SetTitreAlbum;
    property Serie: TSerieFull read FSerie;
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
    property Sujet: LongString read FSujet write FSujet;
    property Notes: LongString read FNotes write FNotes;
    property Editions: TEditionsCompletes read FEditions;
    property Notation: Integer read FNotation write FNotation;
    property Univers: TObjectList<TUniversLite> read FUnivers;
    property UniversFull: TList<TUniversLite> read FUniversFull;

    // pour rétrocompatibilité pour les scripts
    property Titre: AutoTrimString read FTitreAlbum write SetTitreAlbum;
  end;

  TParaBDFull = class(TObjetComplet)
  strict private
    FAuteurs: TObjectList<TAuteurLite>;
    FStock: Boolean;
    FTitreParaBD: AutoTrimString;
    FPrix: Currency;
    FAnneeCote: Integer;
    FGratuit: Boolean;
    FCategorieParaBD: ROption;
    FSerie: TSerieFull;
    FAnneeEdition: Integer;
    FDedicace: Boolean;
    FDescription: LongString;
    FPrixCote: Currency;
    FNumerote: Boolean;
    FDateAchat: TDateTime;
    FOffert: Boolean;
    FFichierImage: AutoTrimString;
    FImageStockee: Boolean;
    FHasImage: Boolean;
    FUnivers: TObjectList<TUniversLite>;
    FUniversFull: TList<TUniversLite>;
    function Get_sDateAchat: string;
    procedure SetTitreParaBD(const Value: AutoTrimString); inline;
  private
    function GetID_Serie: TGUID;
    procedure SetID_Serie(const Value: TGUID);
  public
    OldHasImage, OldImageStockee: Boolean;
    OldFichierImage: string;

    procedure Clear; override;
    procedure PrepareInstance; override;
    destructor Destroy; override;

    function ChaineAffichage(AvecSerie: Boolean): string; overload; override;
    function ChaineAffichage(Simple, AvecSerie: Boolean): string; reintroduce; overload;
  published
    property ID_ParaBD: TGUID read FID write FID;
    property ID_Serie: TGUID read GetID_Serie write SetID_Serie;
    property AnneeEdition: Integer read FAnneeEdition write FAnneeEdition;
    property CategorieParaBD: ROption read FCategorieParaBD write FCategorieParaBD;
    property AnneeCote: Integer read FAnneeCote write FAnneeCote;
    property TitreParaBD: AutoTrimString { [150] } read FTitreParaBD write SetTitreParaBD;
    property Auteurs: TObjectList<TAuteurLite> read FAuteurs;
    property Description: LongString read FDescription write FDescription;
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
    property HasImage: Boolean read FHasImage write FHasImage;
    property ImageStockee: Boolean read FImageStockee write FImageStockee;
    property FichierImage: AutoTrimString read FFichierImage write FFichierImage;
    property Univers: TObjectList<TUniversLite> read FUnivers;
    property UniversFull: TList<TUniversLite> read FUniversFull;
  end;

implementation

uses
  UIBLib, Divers, StdCtrls, Procedures, Textes, StrUtils, UMetadata, Controls, UfrmFusionEditions, IOUtils,
  UfrmConsole, DaoLite;

function MakeOption(Value: Integer; const Caption: AutoTrimString): ROption;
begin
  Result.Value := Value;
  Result.Caption := Caption;
end;

{ AutoTrimString }

class operator AutoTrimString.Implicit(a: string): AutoTrimString;
begin
  Result.Value := a.Trim;
end;

class operator AutoTrimString.Implicit(a: AutoTrimString): string;
begin
  Result := a.Value;
end;

{ LongString }

class operator LongString.Implicit(a: string): LongString;
begin
  Result.Value := a.Trim([' ', #13, #10]);
end;

class operator LongString.Implicit(a: LongString): string;
begin
  Result := a.Value;
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

destructor TObjetComplet.Destroy;
begin
  FAssociations.Free;
  inherited;
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

procedure TObjetComplet.SaveToDatabase(UseTransaction: TUIBTransaction);
begin
  Assert(not IsEqualGUID(ID, GUID_NULL), 'L''ID ne peut être GUID_NULL');
end;

{ TAlbumComplet }

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
  Serie.Clear;
  Univers.Clear;
  UniversFull.Clear;

  Editions.Clear;
end;

destructor TAlbumFull.Destroy;
begin
  FreeAndNil(FScenaristes);
  FreeAndNil(FDessinateurs);
  FreeAndNil(FColoristes);
  FreeAndNil(FSujet);
  FreeAndNil(FNotes);
  FreeAndNil(FSerie);
  FreeAndNil(FEditions);
  FreeAndNil(FUnivers);
  FreeAndNil(FUniversFull);
  inherited;
end;

procedure TAlbumFull.FusionneInto(Dest: TAlbumFull);

  function NotInList(Auteur: TAuteurLite; List: TObjectList<TAuteurLite>): Boolean; inline; overload;
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

  function NotInList(Univers: TUniversLite; List: TObjectList<TUniversLite>): Boolean; inline; overload;
  var
    i: Integer;
  begin
    i := 0;
    Result := True;
    while Result and (i <= Pred(List.Count)) do
    begin
      Result := not IsEqualGUID(List[i].ID, Univers.ID);
      Inc(i);
    end;
  end;

var
  DefaultAlbum: TAlbumFull;
  Auteur: TAuteurLite;
  Univers: TUniversLite;
begin
  DefaultAlbum := TAlbumFull.Create;
  try
    // Album
    if not SameText(TitreAlbum, DefaultAlbum.TitreAlbum) then
      Dest.TitreAlbum := TitreAlbum;
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
        Dest.Scenaristes.Add(TDaoAuteurLite.Duplicate(Auteur));
    for Auteur in Dessinateurs do
      if NotInList(Auteur, Dest.Dessinateurs) then
        Dest.Dessinateurs.Add(TDaoAuteurLite.Duplicate(Auteur));
    for Auteur in Coloristes do
      if NotInList(Auteur, Dest.Coloristes) then
        Dest.Coloristes.Add(TDaoAuteurLite.Duplicate(Auteur));

    if not SameText(Sujet, DefaultAlbum.Sujet) then
      Dest.Sujet := Sujet;
    if not SameText(Notes, DefaultAlbum.Notes) then
      Dest.Notes := Notes;

    // Série
    if not IsEqualGUID(ID_Serie, DefaultAlbum.ID_Serie) and not IsEqualGUID(ID_Serie, Dest.ID_Serie) then
      Dest.ID_Serie := ID_Serie;

    // Univers
    for Univers in Self.Univers do
      if NotInList(Univers, Dest.Univers) then
        Dest.Univers.Add(TDaoUniversLite.Duplicate(Univers));

    if FusionneEditions then
      Editions.FusionneInto(Dest.Editions);
  finally
    DefaultAlbum.Free;
  end;
end;

function TAlbumFull.GetDefaultSearch: string;
begin
  Result := FDefaultSearch;
end;

function TAlbumFull.GetID_Serie: TGUID;
begin
  Result := Serie.ID_Serie;
end;

procedure TAlbumFull.PrepareInstance;
begin
  inherited;
  FFusionneEditions := True;
  FDefaultSearch := '';
  FScenaristes := TObjectList<TAuteurLite>.Create;
  FDessinateurs := TObjectList<TAuteurLite>.Create;
  FColoristes := TObjectList<TAuteurLite>.Create;
  FSerie := TSerieFull.Create;
  FEditions := TEditionsCompletes.Create;
  FUnivers := TObjectList<TUniversLite>.Create;
  FUniversFull := TList<TUniversLite>.Create;
end;

procedure TAlbumFull.SetDefaultSearch(const Value: string);
begin
  FDefaultSearch := Value;
end;

procedure TAlbumFull.SetID_Serie(const Value: TGUID);
begin
  Serie.Fill(Value);
end;

procedure TAlbumFull.SetTitreAlbum(const Value: AutoTrimString);
begin
  FTitreAlbum := Copy(Value, 1, LengthTitreAlbum);
end;

{ TEditionComplete }

class procedure TEditionFull.GetDefaultValues;
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

procedure TEditionFull.Clear;
begin
  inherited;
  ID_Edition := GUID_NULL;
  Editeur.Clear;
  Collection.Clear;
  Couvertures.Clear;
  Notes := '';

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

destructor TEditionFull.Destroy;
begin
  FreeAndNil(FCouvertures);
  FreeAndNil(FEditeur);
  FreeAndNil(FCollection);
  FreeAndNil(FNotes);
  inherited;
end;

procedure TEditionFull.FusionneInto(Dest: TEditionFull);
var
  DefaultEdition: TEditionFull;
  Couverture: TCouvertureLite;
begin
  DefaultEdition := TEditionFull.Create;
  try
    if not IsEqualGUID(Editeur.ID_Editeur, DefaultEdition.Editeur.ID_Editeur) and not IsEqualGUID(Editeur.ID_Editeur, Dest.Editeur.ID_Editeur) then
      Dest.Editeur.Fill(Editeur.ID_Editeur);
    if not IsEqualGUID(Collection.ID, DefaultEdition.Collection.ID) and not IsEqualGUID(Collection.ID, Dest.Collection.ID) then
      TDaoCollectionLite.Fill(Dest.Collection, Collection.ID);

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
    if ISBN.Value <> DefaultEdition.ISBN.Value then
      Dest.ISBN := ISBN;
    if DateAchat <> DefaultEdition.DateAchat then
      Dest.DateAchat := DateAchat;
    if not SameText(Notes, DefaultEdition.Notes) then
      Dest.Notes := Notes;
    if NumeroPerso.Value <> DefaultEdition.NumeroPerso.Value then
      Dest.NumeroPerso := NumeroPerso;

    for Couverture in Couvertures do
      Dest.Couvertures.Add(TDaoCouvertureLite.Duplicate(Couverture));
  finally
    DefaultEdition.Free;
  end;
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

procedure TEditionFull.SetNumeroPerso(const Value: AutoTrimString);
begin
  FNumeroPerso := Copy(Value, 1, LengthNumPerso);
end;

procedure TEditionFull.PrepareInstance;
begin
  inherited;
  FEditeur := TEditeurFull.Create;
  FCollection := TCollectionLite.Create;
  FCouvertures := TObjectList<TCouvertureLite>.Create;
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

      TfrmConsole.AddEvent(Self.UnitName, '> TEditionsCompletes.Fill - ' + GUIDToString(Reference));
      SQL.Text := 'select id_edition from editions where id_album = ?';
      if Stock in [0, 1] then
        SQL.Add('  and e.stock = :stock');
      Params.AsString[0] := GUIDToString(Reference);
      if Stock in [0, 1] then
        Params.AsInteger[1] := Stock;
      Open;
      while not Eof do
      begin
        Editions.Add(TDaoEditionFull.getInstance(StringToGUID(Fields.AsString[0])));
        Next;
      end;
      TfrmConsole.AddEvent(Self.UnitName, '< TEditionsCompletes.Fill - ' + GUIDToString(Reference));
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
  Edition: TEditionFull;
  i, j: Integer;
begin
  if Editions.Count = 0 then
    Exit;

  SetLength(FusionsGUID, Editions.Count);
  ZeroMemory(FusionsGUID, Length(FusionsGUID) * SizeOf(TGUID));
  SetLength(OptionsFusion, Editions.Count);
  ZeroMemory(OptionsFusion, Length(OptionsFusion) * SizeOf(OptionFusion));
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
              FusionsGUID[i] := TEditionFull(lbEditions.Items.Objects[lbEditions.ItemIndex]).ID_Edition;
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
      Edition := TEditionFull.Create;
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
  FEditions := TObjectList<TEditionFull>.Create;
end;

{ TSerieComplete }

class procedure TSerieFull.GetDefaultValues;
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

function TSerieFull.ChaineAffichage: string;
begin
  Result := ChaineAffichage(False);
end;

function TSerieFull.ChaineAffichage(Simple: Boolean): string;
var
  S: string;
begin
  if Simple then
    Result := TitreSerie
  else
    Result := FormatTitre(TitreSerie);
  S := '';
  AjoutString(S, FormatTitre(Editeur.NomEditeur), ' ');
  AjoutString(S, FormatTitre(Collection.NomCollection), ' - ');
  AjoutString(Result, S, ' ', '(', ')');
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
  Editeur.Clear;
  Collection.Clear;
  Scenaristes.Clear;
  Dessinateurs.Clear;
  Coloristes.Clear;
  Univers.Clear;

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
  Notation := 900;
end;

destructor TSerieFull.Destroy;
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
  FreeAndNil(FUnivers);
  inherited;
end;

function TSerieFull.GetID_Collection: TGUID;
begin
  Result := Collection.ID;
end;

function TSerieFull.GetID_Editeur: TGUID;
begin
  Result := Editeur.ID_Editeur;
end;

procedure TSerieFull.PrepareInstance;
begin
  inherited;
  FAlbums := TObjectList<TAlbumLite>.Create(True);
  FParaBD := TObjectList<TParaBDLite>.Create(True);
  FGenres := TStringList.Create;
  FEditeur := TEditeurFull.Create;
  FCollection := TCollectionLite.Create;
  FUnivers := TObjectList<TUniversLite>.Create(True);
  FScenaristes := TObjectList<TAuteurLite>.Create(True);
  FDessinateurs := TObjectList<TAuteurLite>.Create(True);
  FColoristes := TObjectList<TAuteurLite>.Create(True);
end;

procedure TSerieFull.SetID_Collection(const Value: TGUID);
begin
  TDaoCollectionLite.Fill(Collection, Value);
end;

procedure TSerieFull.SetID_Editeur(const Value: TGUID);
begin
  Editeur.Fill(Value);
end;

procedure TSerieFull.SetSiteWeb(const Value: AutoTrimString);
begin
  FSiteWeb := Copy(Value, 1, LengthURL);
end;

procedure TSerieFull.SetTitreSerie(const Value: AutoTrimString);
begin
  FTitreSerie := Copy(Value, 1, LengthTitreSerie);
end;

{ TEditeurComplet }

procedure TEditeurFull.Clear;
begin
  inherited;
  ID_Editeur := GUID_NULL;
  FNomEditeur := '';
  FSiteWeb := '';
end;

procedure TEditeurFull.SetNomEditeur(const Value: AutoTrimString);
begin
  FNomEditeur := Copy(Value, 1, LengthNomEditeur);
end;

procedure TEditeurFull.SetSiteWeb(const Value: AutoTrimString);
begin
  FSiteWeb := Copy(Value, 1, LengthURL);
end;

{ TAuteurComplet }

function TAuteurFull.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := FormatTitre(NomAuteur);
end;

procedure TAuteurFull.Clear;
begin
  inherited;
  Series.Clear;
end;

destructor TAuteurFull.Destroy;
begin
  FreeAndNil(FSeries);
  FreeAndNil(FBiographie);
  inherited;
end;

procedure TAuteurFull.PrepareInstance;
begin
  inherited;
  FSeries := TObjectList<TSerieFull>.Create(True);
end;

procedure TAuteurFull.SetNomAuteur(const Value: AutoTrimString);
begin
  FNomAuteur := Copy(Value, 1, LengthNomAuteur);
end;

procedure TAuteurFull.SetSiteWeb(const Value: AutoTrimString);
begin
  FSiteWeb := Copy(Value, 1, LengthURL);
end;

{ TParaBDComplet }

function TParaBDFull.ChaineAffichage(AvecSerie: Boolean): string;
begin
  Result := ChaineAffichage(False, AvecSerie);
end;

function TParaBDFull.ChaineAffichage(Simple, AvecSerie: Boolean): string;
var
  S: string;
begin
  if Simple then
    Result := TitreParaBD
  else
    Result := FormatTitre(TitreParaBD);
  S := '';
  if AvecSerie then
    if Result = '' then
      Result := FormatTitre(Serie.TitreSerie)
    else
      AjoutString(S, FormatTitre(Serie.TitreSerie), ' - ');
  AjoutString(S, CategorieParaBD.Caption, ' - ');
  if Result = '' then
    Result := S
  else
    AjoutString(Result, S, ' ', '(', ')');
end;

procedure TParaBDFull.Clear;
begin
  inherited;
  ID_ParaBD := GUID_NULL;
  TitreParaBD := '';

  Auteurs.Clear;
  Description := '';
  Serie.Clear;
  Univers.Clear;
  UniversFull.Clear;
end;

destructor TParaBDFull.Destroy;
begin
  FreeAndNil(FAuteurs);
  FreeAndNil(FSerie);
  FreeAndNil(FDescription);
  inherited;
end;

function TParaBDFull.GetID_Serie: TGUID;
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

procedure TParaBDFull.SetID_Serie(const Value: TGUID);
begin
  Serie.Fill(Value);
end;

procedure TParaBDFull.SetTitreParaBD(const Value: AutoTrimString);
begin
  FTitreParaBD := Copy(Value, 1, LengthTitreParaBD);
end;

procedure TParaBDFull.PrepareInstance;
begin
  inherited;
  FAuteurs := TObjectList<TAuteurLite>.Create;
  FSerie := TSerieFull.Create;
  FUnivers := TObjectList<TUniversLite>.Create;
  FUniversFull := TList<TUniversLite>.Create;
end;

{ TCollectionComplete }

procedure TCollectionFull.Clear;
begin
  inherited;
  FEditeur.Clear;
end;

destructor TCollectionFull.Destroy;
begin
  FreeAndNil(FEditeur);
  inherited;
end;

function TCollectionFull.GetID_Editeur: TGUID;
begin
  Result := Editeur.ID;
end;

procedure TCollectionFull.PrepareInstance;
begin
  inherited;
  FEditeur := TEditeurLite.Create;
end;

procedure TCollectionFull.SetID_Editeur(const Value: TGUID);
begin
  TDaoEditeurLite.Fill(FEditeur, Value);
end;

procedure TCollectionFull.SetNomCollection(const Value: AutoTrimString);
begin
  FNomCollection := Copy(Value, 1, LengthNomCollection);
end;

{ TUniversComplet }

function TUniversFull.ChaineAffichage(dummy: Boolean): string;
begin
  Result := FormatTitre(NomUnivers);
end;

procedure TUniversFull.Clear;
begin
  inherited;
  UniversParent.Clear;
end;

destructor TUniversFull.Destroy;
begin
  FreeAndNil(FUniversParent);
  FreeAndNil(FDescription);
  inherited;
end;

function TUniversFull.GetID_UniversParent: TGUID;
begin
  Result := UniversParent.ID;
end;

procedure TUniversFull.PrepareInstance;
begin
  inherited;
  FUniversParent := TUniversLite.Create;
end;

procedure TUniversFull.SetID_UniversParent(const Value: TGUID);
begin
  TDaoUniversLite.Fill(UniversParent, Value);
end;

procedure TUniversFull.SetNomUnivers(const Value: AutoTrimString);
begin
  FNomUnivers := Copy(Value, 1, LengthNomUnivers);
end;

procedure TUniversFull.SetSiteWeb(const Value: AutoTrimString);
begin
  FSiteWeb := Value;
end;

end.
