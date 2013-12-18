unit EntitiesFull;

interface

uses
  SysUtils, Windows, Classes, Dialogs, EntitiesLite, Commun, CommonConst, UdmPrinc, UIB, DateUtils, UChampsRecherche, Generics.Collections,
  Generics.Defaults, VirtualTree, superobject;

type
  AutoTrimString = record
  private
    Value: string;
  public
    class operator Implicit(a: string): AutoTrimString;
    class operator Implicit(a: AutoTrimString): string;
    class operator Equal(a, b: AutoTrimString): Boolean;
    class operator NotEqual(a, b: AutoTrimString): Boolean;
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
  TBaseCompletClass = class of TBaseComplet;

{$TYPEINFO ON}
{$RTTI EXPLICIT PROPERTIES([vcPublished]) METHODS([]) FIELDS([])}

  TBaseComplet = class(TPersistent)
  protected
    class procedure WriteString(Stream: TStream; const Chaine: string);
    class procedure WriteStringLN(Stream: TStream; const Chaine: string);
  public
    constructor Create; virtual;
    procedure BeforeDestruction; override;
    procedure Clear; virtual;
    procedure AfterConstruction; override;
    procedure WriteXMLToStream(Stream: TStream); virtual;

    function ToJson(Indent: Boolean = False; Escape: Boolean = True): string;
    procedure WriteJsonToSuperobect(o: ISuperObject);
  end;

  TObjetCompletClass = class of TObjetFull;

{$RTTI INHERIT}

  TObjetFull = class(TBaseComplet)
  strict private
    FAssociations: TStringList;
  private
    FID: TGUID;
  public
    RecInconnu: Boolean;
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;
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

  TEditeurFull = class(TObjetFull)
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

  TCollectionFull = class(TObjetFull)
  strict private
    FNomCollection: AutoTrimString;
    FEditeur: TEditeurLite;
    function GetID_Editeur: TGUID; inline;
    procedure SetNomCollection(const Value: AutoTrimString); inline;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;
  published
    property ID_Collection: TGUID read FID write FID;
    property NomCollection: AutoTrimString read FNomCollection write SetNomCollection;
    property Editeur: TEditeurLite read FEditeur;
    property ID_Editeur: TGUID read GetID_Editeur;
  end;

  TUniversFull = class(TObjetFull)
  strict private
    FNomUnivers: AutoTrimString;
    FUniversParent: TUniversLite;
    FDescription: LongString;
    FSiteWeb: AutoTrimString;
    procedure SetNomUnivers(const Value: AutoTrimString); inline;
    function GetID_UniversParent: TGUID; inline;
    procedure SetSiteWeb(const Value: AutoTrimString);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;
    function ChaineAffichage(dummy: Boolean = True): string; override;
  published
    property ID_Univers: TGUID read FID write FID;
    property NomUnivers: AutoTrimString read FNomUnivers write SetNomUnivers;
    property SiteWeb: AutoTrimString read FSiteWeb write SetSiteWeb;
    property Description: LongString read FDescription write FDescription;
    property UniversParent: TUniversLite read FUniversParent;
    property ID_UniversParent: TGUID read GetID_UniversParent;
  end;

  TSerieFull = class(TObjetFull)
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
    function GetID_Collection: TGUID; inline;
    procedure SetTitreSerie(const Value: AutoTrimString); inline;
    procedure SetSiteWeb(const Value: AutoTrimString); inline;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;
    function ChaineAffichage: string; reintroduce; overload;
    function ChaineAffichage(Simple: Boolean): string; overload; override;
  published
    property ID_Serie: TGUID read FID write FID;
    property ID_Editeur: TGUID read GetID_Editeur;
    property ID_Collection: TGUID read GetID_Collection;
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

  TAuteurFull = class(TObjetFull)
  strict private
    FBiographie: LongString;
    FNomAuteur: AutoTrimString;
    FSiteWeb: AutoTrimString;
    FSeries: TObjectList<TSerieFull>;
    procedure SetNomAuteur(const Value: AutoTrimString); inline;
    procedure SetSiteWeb(const Value: AutoTrimString); inline;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;
    function ChaineAffichage(dummy: Boolean = True): string; override;
  published
    property ID_Auteur: TGUID read FID write FID;
    property NomAuteur: AutoTrimString read FNomAuteur write SetNomAuteur;
    property SiteWeb: AutoTrimString read FSiteWeb write SetSiteWeb;
    property Biographie: LongString read FBiographie write FBiographie;
    property Series: TObjectList<TSerieFull> read FSeries;
  end;

  TEditionFull = class(TObjetFull)
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
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;
    function ChaineAffichage(dummy: Boolean = True): string; override;
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

  TEditionsFull = class(TListComplet)
  strict private
    FEditions: TObjectList<TEditionFull>;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;
  published
    property Editions: TObjectList<TEditionFull> read FEditions;
  end;

{$RTTI INHERIT}

  TAlbumFull = class(TObjetFull)
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
    FEditions: TEditionsFull;
    FComplet: Boolean;
    FReadyToFusion: Boolean;
    FFusionneEditions: Boolean;
    FNotation: Integer;
    FDefaultSearch: AutoTrimString;
    FUnivers: TObjectList<TUniversLite>;
    FUniversFull: TList<TUniversLite>;
    function GetID_Serie: TGUID; inline;
    procedure SetTitreAlbum(const Value: AutoTrimString); inline;
  private
    function GetDefaultSearch: string;
    procedure SetDefaultSearch(const Value: string);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;
    function ChaineAffichage(AvecSerie: Boolean): string; overload; override;
    function ChaineAffichage(Simple, AvecSerie: Boolean): string; reintroduce; overload;

    property ReadyToFusion: Boolean read FReadyToFusion write FReadyToFusion;
    property FusionneEditions: Boolean read FFusionneEditions write FFusionneEditions;
    property DefaultSearch: string read GetDefaultSearch write SetDefaultSearch;
  published
    property Complet: Boolean read FComplet write FComplet;
    property ID_Album: TGUID read FID write FID;
    property ID_Serie: TGUID read GetID_Serie;
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
    property Editions: TEditionsFull read FEditions;
    property Notation: Integer read FNotation write FNotation;
    property Univers: TObjectList<TUniversLite> read FUnivers;
    property UniversFull: TList<TUniversLite> read FUniversFull;

    // pour rétrocompatibilité pour les scripts
    property Titre: AutoTrimString read FTitreAlbum write SetTitreAlbum;
  end;

  TParaBDFull = class(TObjetFull)
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
  public
    OldHasImage, OldImageStockee: Boolean;
    OldFichierImage: string;

    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;

    function ChaineAffichage(AvecSerie: Boolean): string; overload; override;
    function ChaineAffichage(Simple, AvecSerie: Boolean): string; reintroduce; overload;
  published
    property ID_ParaBD: TGUID read FID write FID;
    property ID_Serie: TGUID read GetID_Serie;
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
  UfrmConsole, System.Rtti, System.TypInfo, supertypes;

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

class operator AutoTrimString.Equal(a, b: AutoTrimString): Boolean;
begin
  Result := CompareStr(a.Value, b.Value) = 0;
end;

class operator AutoTrimString.Implicit(a: AutoTrimString): string;
begin
  Result := a.Value;
end;

class operator AutoTrimString.NotEqual(a, b: AutoTrimString): Boolean;
begin
  Result := CompareStr(a.Value, b.Value) <> 0;
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
end;

function TBaseComplet.ToJson(Indent: Boolean = False; Escape: Boolean = True): string;
var
  o: ISuperObject;
begin
  o := SO;
  WriteJsonToSuperobect(o);
  Result := o.AsJSon(Indent, Escape);
end;

procedure TBaseComplet.AfterConstruction;
begin
  inherited;
  Clear;
end;

procedure TBaseComplet.WriteJsonToSuperobect(o: ISuperObject);
type
  PAutoTrimString = ^AutoTrimString;
  PLongString = ^LongString;
  POption = ^ROption;

var
  Context: TSuperRttiContext;
  p: TRttiProperty;
  Value: TValue;
  s: string;
begin
  Context := TSuperRttiContext.Create;
  try
    for p in Context.Context.GetType(Self.ClassType).GetProperties do
    begin
      Value := p.GetValue(Self);
      case p.PropertyType.TypeKind of
        tkClass:
          if Value.IsInstanceOf(TBaseComplet) then
          begin
            o.o[p.Name] := TSuperObject.Create(stObject);
            TBaseComplet(Value.AsObject).WriteJsonToSuperobect(o.o[p.Name]);
          end;
        tkRecord:
          if Value.TypeInfo = TypeInfo(AutoTrimString) then
            o.o[p.Name] := TSuperObject.Create(SOString(PAutoTrimString(Value.GetReferenceToRawData).Value))
          else if (Value.TypeInfo = TypeInfo(LongString)) then
            o.o[p.Name] := TSuperObject.Create(SOString(PLongString(Value.GetReferenceToRawData).Value))
          else if (Value.TypeInfo = TypeInfo(ROption)) then
          begin
            o.o[p.Name + '.Value'] := TSuperObject.Create(POption(Value.GetReferenceToRawData).Value);
            o.o[p.Name + '.Caption'] := TSuperObject.Create(SOString(POption(Value.GetReferenceToRawData).Caption));
          end
          else
            o.o[p.Name] := Context.ToJson(Value, nil);
      else
        o.o[p.Name] := Context.ToJson(Value, nil);
      end;
    end;
  finally
    Context.Free;
  end;
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

function TObjetFull.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := '';
end;

procedure TObjetFull.Clear;
begin
  inherited;
  FID := GUID_NULL;
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

procedure TObjetFull.New(ClearInstance: Boolean = True);
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
    // Fill(newId);
    Clear;
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

constructor TAlbumFull.Create;
begin
  inherited;
  FFusionneEditions := True;
  FDefaultSearch := '';
  FScenaristes := TObjectList<TAuteurLite>.Create;
  FDessinateurs := TObjectList<TAuteurLite>.Create;
  FColoristes := TObjectList<TAuteurLite>.Create;
  FSerie := TSerieFull.Create;
  FEditions := TEditionsFull.Create;
  FUnivers := TObjectList<TUniversLite>.Create;
  FUniversFull := TList<TUniversLite>.Create;
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

function TAlbumFull.GetDefaultSearch: string;
begin
  Result := FDefaultSearch;
end;

function TAlbumFull.GetID_Serie: TGUID;
begin
  Result := Serie.ID_Serie;
end;

procedure TAlbumFull.SetDefaultSearch(const Value: string);
begin
  FDefaultSearch := Value;
end;

procedure TAlbumFull.SetTitreAlbum(const Value: AutoTrimString);
begin
  FTitreAlbum := Copy(Value, 1, LengthTitreAlbum);
end;

{ TEditionComplete }

procedure TEditionFull.Clear;
begin
  inherited;
  ID_Edition := GUID_NULL;
  Editeur.Clear;
  Collection.Clear;
  Couvertures.Clear;
  Notes := '';

  // TODO: voir comment remplir ces valeurs sans utiliser TDaoListe
  // TypeEdition := FDefaultTypeEdition;
  // Etat := FDefaultEtat;
  // Reliure := FDefaultReliure;
  // FormatEdition := FDefaultFormatEdition;
  // Orientation := FDefaultOrientation;
  // SensLecture := FDefaultSensLecture;
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
  FEditeur := TEditeurFull.Create;
  FCollection := TCollectionLite.Create;
  FCouvertures := TObjectList<TCouvertureLite>.Create;
end;

destructor TEditionFull.Destroy;
begin
  FreeAndNil(FCouvertures);
  FreeAndNil(FEditeur);
  FreeAndNil(FCollection);
  FreeAndNil(FNotes);
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

procedure TEditionFull.SetNumeroPerso(const Value: AutoTrimString);
begin
  FNumeroPerso := Copy(Value, 1, LengthNumPerso);
end;

{ TEditionsComplet }

procedure TEditionsFull.Clear;
begin
  inherited;
  Editions.Clear;
end;

constructor TEditionsFull.Create;
begin
  inherited;
  FEditions := TObjectList<TEditionFull>.Create;
end;

destructor TEditionsFull.Destroy;
begin
  FreeAndNil(FEditions);
  inherited;
end;

{ TSerieComplete }

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
  Editeur.Clear;
  Collection.Clear;
  Scenaristes.Clear;
  Dessinateurs.Clear;
  Coloristes.Clear;
  Univers.Clear;

  // TODO: voir comment renseigner ces valeurs sans faire appel à TDaoListe
  // TypeEdition := FDefaultTypeEdition;
  // Etat := FDefaultEtat;
  // Reliure := FDefaultReliure;
  // FormatEdition := FDefaultFormatEdition;
  // Orientation := FDefaultOrientation;
  // SensLecture := FDefaultSensLecture;
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

constructor TSerieFull.Create;
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

constructor TAuteurFull.Create;
begin
  inherited;
  FSeries := TObjectList<TSerieFull>.Create(True);
end;

destructor TAuteurFull.Destroy;
begin
  FreeAndNil(FSeries);
  FreeAndNil(FBiographie);
  inherited;
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
  TitreParaBD := '';

  Auteurs.Clear;
  Description := '';
  Serie.Clear;
  Univers.Clear;
  UniversFull.Clear;
end;

constructor TParaBDFull.Create;
begin
  inherited;
  FAuteurs := TObjectList<TAuteurLite>.Create;
  FSerie := TSerieFull.Create;
  FUnivers := TObjectList<TUniversLite>.Create;
  FUniversFull := TList<TUniversLite>.Create;
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

procedure TParaBDFull.SetTitreParaBD(const Value: AutoTrimString);
begin
  FTitreParaBD := Copy(Value, 1, LengthTitreParaBD);
end;

{ TCollectionComplete }

procedure TCollectionFull.Clear;
begin
  inherited;
  FEditeur.Clear;
end;

constructor TCollectionFull.Create;
begin
  inherited;
  FEditeur := TEditeurLite.Create;
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

constructor TUniversFull.Create;
begin
  inherited;
  FUniversParent := TUniversLite.Create;
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

procedure TUniversFull.SetNomUnivers(const Value: AutoTrimString);
begin
  FNomUnivers := Copy(Value, 1, LengthNomUnivers);
end;

procedure TUniversFull.SetSiteWeb(const Value: AutoTrimString);
begin
  FSiteWeb := Value;
end;

end.
