unit LoadComplet;

interface

uses
  SysUtils, Windows, Classes, Dialogs, TypeRec, Commun, CommonConst, DM_Princ, JvUIB, DateUtils, ListOfTypeRec, Contnrs;

type
  TBaseComplet = class(TObject)
  protected
    procedure WriteString(Stream: TStream; const Chaine: string);
    procedure WriteStringLN(Stream: TStream; const Chaine: string);
  public
    procedure Fill(const Reference: TGUID); virtual;
    procedure BeforeDestruction; override;
    procedure Clear; virtual;

    procedure PrepareInstance; virtual;
    constructor Create; virtual;

    procedure WriteXMLToStream(Stream: TStream); virtual;
  end;

  TObjetComplet = class(TBaseComplet)
  protected
    function GetReference: TGUID; virtual;
  public
    RecInconnu: Boolean;

    procedure Clear; override;

    constructor Create(const Reference: TGUID); reintroduce; overload; virtual;

    procedure SaveToDatabase; overload;
    procedure SaveToDatabase(UseTransaction: TJvUIBTransaction); overload; virtual;
    procedure New;

    function ChaineAffichage(dummy: Boolean = True): string; virtual;

    property Reference: TGUID read GetReference;
  end;

  TInfoComplet = class(TBaseComplet)
  end;

  TListComplet = class(TBaseComplet)
  end;

  TSrcEmprunt = (seTous, seAlbum, seEmprunteur);
  TSensEmprunt = (ssTous, ssPret, ssRetour);

  TEmpruntsComplet = class(TListComplet)
    Emprunts: TListOfTEmprunt;
    NBEmprunts: Integer;

    procedure Fill(const Reference: TGUID; Source: TSrcEmprunt = seTous; Sens: TSensEmprunt = ssTous; Apres: TDateTime = -1; Avant: TDateTime = -1; EnCours: Boolean = False; Stock: Boolean = False); reintroduce;
    procedure Clear; override;
    procedure PrepareInstance; override;
    constructor Create(const Reference: TGUID; Source: TSrcEmprunt = seTous; Sens: TSensEmprunt = ssTous; Apres: TDateTime = -1; Avant: TDateTime = -1; EnCours: Boolean = False; Stock: Boolean = False); reintroduce; overload;
    destructor Destroy; override;
  end;

  TEditeurComplet = class(TObjetComplet)
    ID_Editeur: TGUID;
    NomEditeur: string[50];
    SiteWeb: string[255];

    procedure Fill(const Reference: TGUID); override;
    procedure Clear; override;

    procedure SaveToDatabase(UseTransaction: TJvUIBTransaction); override;

  protected
    function GetReference: TGUID; override;
  end;

  TCollectionComplete = class(TObjetComplet)
  private
    function GetID_Editeur: TGUID;
    procedure SetID_Editeur(const Value: TGUID);
  protected
    function GetReference: TGUID; override;
  public
    ID_Collection: TGUID;
    NomCollection: string[50];
    Editeur: TEditeur;

    procedure Fill(const Reference: TGUID); override;
    procedure Clear; override;
    constructor Create; override;
    destructor Destroy; override;

    procedure SaveToDatabase(UseTransaction: TJvUIBTransaction); override;

    property ID_Editeur: TGUID read GetID_Editeur write SetID_Editeur;
  end;

  TSerieComplete = class(TObjetComplet)
  private
    function GetID_Editeur: TGUID;
    procedure SetID_Editeur(const Value: TGUID);
    function GetID_Collection: TGUID;
    procedure SetID_Collection(const Value: TGUID);
  protected
    function GetReference: TGUID; override;
  public
    ID_Serie: TGUID;
    Titre: string[150];
    Terminee: Integer;
    Complete: Boolean;
    SuivreManquants, SuivreSorties: Boolean;
    Albums: TListOfTAlbum;
    ParaBD: TListOfTParaBD;
    Genres: TStringList;
    Sujet, Notes: TStringList;
    Editeur: TEditeurComplet;
    Collection: TCollection;
    SiteWeb: string[255];
    Scenaristes, Dessinateurs, Coloristes: TListOfTAuteur;

    FIdAuteur: TGUID;
    FForce: Boolean;

    procedure Fill(const Reference: TGUID); overload; override;
    procedure Fill(const Reference, IdAuteur: TGUID); reintroduce; overload;
    procedure Fill(const Reference, IdAuteur: TGUID; Force: Boolean); reintroduce; overload;
    procedure Clear; override;
    procedure PrepareInstance; override;
    constructor Create(const Reference, IdAuteur: TGUID); reintroduce; overload;
    constructor Create(const Reference, IdAuteur: TGUID; Force: Boolean); reintroduce; overload;
    destructor Destroy; override;

    procedure SaveToDatabase(UseTransaction: TJvUIBTransaction); override;

    function ChaineAffichage: string; reintroduce; overload;
    function ChaineAffichage(Simple: Boolean): string; overload; override;

    property ID_Editeur: TGUID read GetID_Editeur write SetID_Editeur;
    property ID_Collection: TGUID read GetID_Collection write SetID_Collection;
  end;

  TListOfTSerieComplete = class(TObjectList)
  protected
    function GetItem(Index: Integer): TSerieComplete;
  public
    function Add(AObject: TSerieComplete): Integer;
    procedure Insert(Index: Integer; AObject: TSerieComplete);
    property Items[Index: Integer]: TSerieComplete read GetItem; default;
  end;

  TAuteurComplet = class(TObjetComplet)
    ID_Auteur: TGUID;
    NomAuteur: string[50];
    SiteWeb: string[255];
    Biographie: TStringList;
    Series: TListOfTSerieComplete;

    procedure Fill(const Reference: TGUID); override;
    procedure Clear; override;
    procedure PrepareInstance; override;
    destructor Destroy; override;

    procedure SaveToDatabase(UseTransaction: TJvUIBTransaction); override;

    function ChaineAffichage(dummy: Boolean = True): string; override;
  protected
    function GetReference: TGUID; override;
  end;

  TEditionComplete = class(TObjetComplet)
  private
    function Get_sDateAchat: string;
  protected
    function GetReference: TGUID; override;
  public
    ID_Edition, ID_Album: TGUID;
    Editeur: TEditeurComplet;
    Collection: TCollection;
    TypeEdition, AnneeEdition, Etat, Reliure, NombreDePages, FormatEdition, Orientation, AnneeCote: Integer;
    Prix, PrixCote: Currency;
    Couleur, VO, Dedicace, Stock, Prete, Offert, Gratuit: Boolean;
    ISBN, sEtat, sReliure, sTypeEdition, sFormatEdition, sOrientation: string;
    DateAchat: TDateTime;
    Notes: TStringList;
    Emprunts: TEmpruntsComplet;
    Couvertures: TListOfTCouverture;

    procedure Fill(const Reference: TGUID); override;
    procedure Clear; override;
    procedure PrepareInstance; override;
    destructor Destroy; override;
    function ChaineAffichage(dummy: Boolean = True): string; override;

    procedure SaveToDatabase(UseTransaction: TJvUIBTransaction); override;

    property sDateAchat: string read Get_sDateAchat;
  end;

  TListOfTEditionComplete = class(TObjectList)
  protected
    function GetItem(Index: Integer): TEditionComplete;
  public
    function Add(AObject: TEditionComplete): Integer;
    procedure Insert(Index: Integer; AObject: TEditionComplete);
    property Items[Index: Integer]: TEditionComplete read GetItem; default;
  end;

  TEditionsComplet = class(TListComplet)
    Editions: TListOfTEditionComplete;

    procedure Fill(const Reference: TGUID; Stock: Integer = -1); reintroduce;
    procedure PrepareInstance; override;
    procedure Clear; override;
    constructor Create(const Reference: TGUID; Stock: Integer = -1); reintroduce; overload;
    destructor Destroy; override;
  end;

  TAlbumComplet = class(TObjetComplet)
  private
    function GetID_Serie: TGUID;
    procedure SetID_Serie(const Value: TGUID);
  protected
    function GetReference: TGUID; override;
  public
    ID_Album: TGUID;
    MoisParution, AnneeParution, Tome, TomeDebut, TomeFin: Integer;
    Titre: string[150];
    HorsSerie, Integrale: Boolean;
    Scenaristes, Dessinateurs, Coloristes: TListOfTAuteur;
    Sujet, Notes: TStringList;
    Serie: TSerieComplete;
    Editions: TEditionsComplet;

    Complet: Boolean;

    procedure Fill(const Reference: TGUID); override;
    procedure Clear; override;
    procedure PrepareInstance; override;
    destructor Destroy; override;

    procedure SaveToDatabase(UseTransaction: TJvUIBTransaction); override;
    procedure Acheter(Prevision: Boolean);

    function ChaineAffichage(AvecSerie: Boolean): string; overload; override;
    function ChaineAffichage(Simple, AvecSerie: Boolean): string; reintroduce; overload;

    property ID_Serie: TGUID read GetID_Serie write SetID_Serie;
  end;

  TEmprunteurComplet = class(TObjetComplet)
    ID_Emprunteur: TGUID;
    Nom: string[100];
    Adresse: TStringList;
    Emprunts: TEmpruntsComplet;

    procedure Fill(const Reference: TGUID); override;
    procedure Clear; override;
    procedure PrepareInstance; override;
    destructor Destroy; override;

    procedure SaveToDatabase(UseTransaction: TJvUIBTransaction); override;

    function ChaineAffichage(dummy: Boolean = True): string; override;
  protected
    function GetReference: TGUID; override;
  end;

  TStats = class;

  TListOfTStats = class(TObjectList)
  protected
    function GetItem(Index: Integer): TStats;
  public
    function Add(AObject: TStats): Integer;
    procedure Insert(Index: Integer; AObject: TStats);
    property Items[Index: Integer]: TStats read GetItem; default;
  end;

  TStats = class(TInfoComplet)
    Editeur: string;
    NbAlbums, NbSeries, NbSeriesTerminee,
      NbAlbumsNB, NbAlbumsVO, NbAlbumsStock, NbAlbumsIntegrale, NbAlbumsHorsSerie, NbAlbumsDedicace, NbAlbumsOffert, NbAlbumsGratuit,
      MinAnnee, MaxAnnee,
      NbEmprunteurs, MoyEmprunteurs, MinEmprunteurs, MaxEmprunteurs,
      NbEmpruntes, MoyEmpruntes, MinEmpruntes, MaxEmpruntes,
      NbAlbumsSansPrix: Integer;
    ValeurConnue, ValeurEstimee,
      PrixAlbumMinimun, PrixAlbumMoyen, PrixAlbumMaximun: Currency;
    ListAlbumsMin, ListAlbumsMax: TListOfTAlbum;
    ListEmprunteursMin, ListEmprunteursMax: TListOfTEmprunteur;
    ListGenre: TListOfTGenre;
    ListEditeurs: TListOfTStats;

    procedure Fill(Complete: Boolean); reintroduce;
    procedure Clear; override;
    procedure PrepareInstance; override;
    constructor Create(Complete: Boolean); reintroduce; overload;
    destructor Destroy; override;

  private
    procedure CreateStats(Stats: TStats); overload;
    procedure CreateStats(Stats: TStats; const ID_Editeur: TGUID; const Editeur: string); overload;
  end;

  TSerieIncomplete = class(TInfoComplet)
    Serie: TSerie;
    NumerosManquants: TStringList;

    procedure PrepareInstance; override;

    destructor Destroy; override;
    function ChaineAffichage: string;
  end;

  TListOfTSerieIncomplete = class(TObjectList)
  protected
    function GetItem(Index: Integer): TSerieIncomplete;
  public
    function Add(AObject: TSerieIncomplete): Integer;
    procedure Insert(Index: Integer; AObject: TSerieIncomplete);
    property Items[Index: Integer]: TSerieIncomplete read GetItem; default;
  end;

  TSeriesIncompletes = class(TListComplet)
    Series: TListOfTSerieIncomplete;

    procedure Fill(const Reference: TGUID); overload; override;
    procedure Fill(AvecIntegrales, AvecAchats: Boolean; const ID_Serie: TGUID); reintroduce; overload;
    procedure Clear; override;
    procedure PrepareInstance; override;
    constructor Create(AvecIntegrales, AvecAchats: Boolean); reintroduce; overload;
    constructor Create(const ID_Serie: TGUID); reintroduce; overload;
    destructor Destroy; override;
  end;

  TPrevisionSortie = class(TInfoComplet)
    Serie: TSerie;
    Tome, Annee, Mois: Integer;

    constructor Create; override;
    destructor Destroy; override;
    function sAnnee: string;
  end;

  TListOfTPrevisionSortie = class(TObjectList)
  protected
    function GetItem(Index: Integer): TPrevisionSortie;
  public
    function Add(AObject: TPrevisionSortie): Integer;
    procedure Insert(Index: Integer; AObject: TPrevisionSortie);
    property Items[Index: Integer]: TPrevisionSortie read GetItem; default;
  end;

  TPrevisionsSorties = class(TListComplet)
    AnneesPassees, AnneeEnCours, AnneesProchaines: TListOfTPrevisionSortie;

    procedure Fill(const Reference: TGUID); overload; override;
    procedure Fill(AvecAchats: Boolean); reintroduce; overload;
    procedure Fill(AvecAchats: Boolean; const ID_Serie: TGUID); reintroduce; overload;
    procedure PrepareInstance; override;
    procedure Clear; override;
    constructor Create(AvecAchats: Boolean); reintroduce; overload;
    constructor Create(const ID_Serie: TGUID); reintroduce; overload;
    destructor Destroy; override;
  end;

  TParaBDComplet = class(TObjetComplet)
  private
    OldHasImage, OldImageStockee: Boolean;
    OldFichierImage: string;

    function Get_sDateAchat: string;
  protected
    function GetReference: TGUID; override;
  public
    ID_ParaBD: TGUID;
    AnneeEdition, CategorieParaBD, AnneeCote: Integer;
    Titre: string[150];
    sCategorieParaBD: string;
    Auteurs: TListOfTAuteur;
    Description: TStringList;
    Serie: TSerieComplete;

    Prix, PrixCote: Currency;
    Dedicace, Numerote, Stock, Offert, Gratuit: Boolean;
    DateAchat: TDateTime;

    HasImage, ImageStockee: Boolean;
    FichierImage: string;

    procedure Fill(const Reference: TGUID); override;
    procedure Clear; override;
    procedure PrepareInstance; override;
    destructor Destroy; override;

    procedure SaveToDatabase(UseTransaction: TJvUIBTransaction); override;
    procedure Acheter(Prevision: Boolean);

    function ChaineAffichage(AvecSerie: Boolean): string; overload; override;
    function ChaineAffichage(Simple, AvecSerie: Boolean): string; reintroduce; overload;

    property sDateAchat: string read Get_sDateAchat;
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

  TTypeRecherche = (trAucune, trSimple, trComplexe);
  TRechercheSimple = (rsAuteur, rsSerie, rsEditeur, rsGenre, rsCollection);
const
  TLblRechercheSimple: array[TRechercheSimple] of string = ('Auteur', 'Serie', 'Editeur', 'Genre', 'Collection');

type
  TRecherche = class(TBaseComplet)
    TypeRecherche: TTypeRecherche;
    Resultats: TListOfTAlbum;
    ResultatsInfos: TStrings;
    Criteres: TGroupCritere;
    RechercheSimple: TRechercheSimple;
    FLibelle: string;

    procedure PrepareInstance; override;
    procedure Clear; override;
    procedure ClearCriteres;
    procedure Fill; reintroduce; overload;
    procedure Fill(Recherche: TRechercheSimple; const ID: TGUID; const Libelle: string); reintroduce; overload;

    function AddCritere(Parent: TGroupCritere): TCritere;
    function AddGroup(Parent: TGroupCritere): TGroupCritere;
    procedure Delete(Item: TBaseCritere);

    constructor Create; overload; override;
    constructor Create(Recherche: TRechercheSimple; const ID: TGUID; const Libelle: string); reintroduce; overload;
    destructor Destroy; override;

    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
  end;

implementation

uses JvUIBLib, Divers, StdCtrls, Procedures, Textes;

{ TBaseComplet }

procedure TBaseComplet.BeforeDestruction;
begin
  inherited;
  Clear;
end;

procedure TBaseComplet.Clear;
begin
  // nettoyage de toutes les listes et autres
end;

constructor TBaseComplet.Create;
begin
  inherited;
  PrepareInstance;
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
  q: TJvUIBQuery;
begin
  if IsEqualGUID(Reference, GUID_NULL) then Exit;
  q := TJvUIBQuery.Create(nil);
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
const
  resTome: array[False..True] of string = ('T. ', 'Tome ');
  resHS: array[False..True] of string = ('HS', 'Hors-série');
  resIntegrale: array[False..True] of string = ('INT.', 'Intégrale');
var
  s, s2: string;
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
  if Integrale then
  begin
    s2 := NonZero(IntToStr(TomeDebut));
    AjoutString(s2, NonZero(IntToStr(TomeFin)), ' à ');
    AjoutString(s, resIntegrale[Result = ''], ' - ', '', TrimRight(' ' + NonZero(IntToStr(Tome))));
    AjoutString(s, s2, ' ', '[', ']');
  end
  else if HorsSerie then
    AjoutString(s, resHS[Result = ''], ' - ', '', TrimRight(' ' + NonZero(IntToStr(Tome))))
  else
    AjoutString(s, NonZero(IntToStr(Tome)), ' - ', resTome[Result = '']);
  if Result = '' then
    Result := s
  else
    AjoutString(Result, s, ' ', '(', ')');
  if Result = '' then Result := '<Sans titre>';
end;

procedure TAlbumComplet.Clear;
begin
  inherited;
  ID_Album := GUID_NULL;
  Titre := '';

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
  Scenaristes.Free;
  Dessinateurs.Free;
  Coloristes.Free;

  Sujet.Free;
  Notes.Free;
  Serie.Free;
  Editions.Free;
  inherited;
end;

procedure TAlbumComplet.Fill(const Reference: TGUID);
var
  q: TJvUIBQuery;
begin
  inherited;
  if IsEqualGUID(Reference, GUID_NULL) then Exit;
  Self.ID_Album := Reference;
  q := TJvUIBQuery.Create(nil);
  with q do
  try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    FetchBlobs := True;
    SQL.Text := 'SELECT TITREALBUM, MOISPARUTION, ANNEEPARUTION, ID_Serie, TOME, TOMEDEBUT, TOMEFIN, SUJETALBUM, REMARQUESALBUM, HORSSERIE, INTEGRALE, COMPLET FROM ALBUMS WHERE ID_Album = ?';
    Params.AsString[0] := GUIDToString(Reference);
    Open;
    RecInconnu := Eof;
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

    Complet := Fields.ByNameAsBoolean['COMPLET'];

    Close;
    SQL.Text := 'SELECT * FROM PROC_AUTEURS(?, NULL, NULL)';
    Params.AsString[0] := GUIDToString(Reference);
    Open;
    while not Eof do
    begin
      case Fields.ByNameAsInteger['Metier'] of
        0: Self.Scenaristes.Add(TAuteur.Make(q));
        1: Self.Dessinateurs.Add(TAuteur.Make(q));
        2: Self.Coloristes.Add(TAuteur.Make(q));
      end;
      Next;
    end;

    Self.Editions.Fill(Self.ID_Album);
  finally
    q.Transaction.Free;
    q.Free;
  end;
end;

function TAlbumComplet.GetID_Serie: TGUID;
begin
  Result := Serie.ID_Serie;
end;

function TAlbumComplet.GetReference: TGUID;
begin
  Result := ID_Album;
end;

procedure TAlbumComplet.PrepareInstance;
begin
  inherited;
  Scenaristes := TListOfTAuteur.Create;
  Dessinateurs := TListOfTAuteur.Create;
  Coloristes := TListOfTAuteur.Create;
  Sujet := TStringList.Create;
  Notes := TStringList.Create;
  Serie := TSerieComplete.Create;
  Editions := TEditionsComplet.Create;
end;

procedure TAlbumComplet.SaveToDatabase(UseTransaction: TJvUIBTransaction);
var
  s: string;
  q: TJvUIBQuery;
  i: Integer;
  hg: IHourGlass;
  Edition: TEditionComplete;
begin
  inherited;
  hg := THourGlass.Create;
  q := TJvUIBQuery.Create(nil);
  with q do
  try
    Transaction := UseTransaction;

    if RecInconnu then
    begin
      SQL.Text := 'INSERT INTO ALBUMS (ID_Album, TITREALBUM, MOISPARUTION, ANNEEPARUTION, ID_Serie, TOME, TOMEDEBUT, TOMEFIN, HORSSERIE, INTEGRALE, SUJETALBUM, REMARQUESALBUM)';
      SQL.Add('VALUES');
      SQL.Add('(:ID_Album, :TITREALBUM, :MOISPARUTION, :ANNEEPARUTION, :ID_Serie, :TOME, :TOMEDEBUT, :TOMEFIN, :HORSSERIE, :INTEGRALE, :SUJETALBUM, :REMARQUESALBUM)');
    end
    else
    begin
      SQL.Text := 'UPDATE ALBUMS SET';
      SQL.Add('TITREALBUM = :TITREALBUM, MOISPARUTION = :MOISPARUTION, ANNEEPARUTION = :ANNEEPARUTION, ID_Serie = :ID_Serie, TOME = :TOME, TOMEDEBUT = :TOMEDEBUT, TOMEFIN = :TOMEFIN,');
      SQL.Add('HORSSERIE = :HORSSERIE, INTEGRALE = :INTEGRALE,');
      SQL.Add('SUJETALBUM = :SUJETALBUM, REMARQUESALBUM = :REMARQUESALBUM');
      SQL.Add('WHERE (ID_Album = :ID_Album)');
    end;

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
    if s <> '' then
    begin
      SQL.Text := 'DELETE FROM EDITIONS WHERE ID_ALBUM = ? AND ID_EDITION NOT IN (' + s + ')';
      Params.AsString[0] := GUIDToString(ID_Album);
      ExecSQL;
      SQL.Text := 'DELETE FROM COUVERTURES WHERE ID_ALBUM = ? AND ID_EDITION IS NOT NULL AND ID_EDITION NOT IN (' + s + ')';
      Params.AsString[0] := GUIDToString(ID_Album);
      ExecSQL;
    end;

    for i := 0 to Pred(Editions.Editions.Count) do
    begin
      Edition := Editions.Editions[i];
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

{ TEditionComplete }

procedure TEditionComplete.Clear;
begin
  inherited;
  ID_Edition := GUID_NULL;
  Editeur.Clear;
  Collection.Clear;
  Emprunts.Clear;
  Couvertures.Clear;
  Notes.Clear;
end;

destructor TEditionComplete.Destroy;
begin
  Couvertures.Free;
  Editeur.Free;
  FreeAndNil(Collection);
  FreeAndNil(Emprunts);
  FreeAndNil(Notes);
  inherited;
end;

procedure TEditionComplete.Fill(const Reference: TGUID);
var
  q: TJvUIBQuery;
begin
  inherited;
  if IsEqualGUID(Reference, GUID_NULL) then Exit;
  Self.ID_Edition := Reference;
  q := TJvUIBQuery.Create(nil);
  with q do
  try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT ID_EDITION, ID_Album, e.ID_Editeur, e.ID_Collection, NOMCOLLECTION, ANNEEEDITION, PRIX, VO, COULEUR, ISBN, DEDICACE, PRETE,';
    SQL.Add('STOCK, Offert, Gratuit, NombreDePages, etat, le.libelle as setat, reliure, lr.libelle as sreliure, orientation, lo.libelle as sorientation,');
    SQL.Add('FormatEdition, lf.libelle as sFormatEdition, typeedition, lte.libelle as stypeedition, DateAchat, Notes, AnneeCote, PrixCote');
    SQL.Add('FROM EDITIONS e LEFT JOIN COLLECTIONS c ON e.ID_Collection = c.ID_Collection');
    SQL.Add('LEFT JOIN LISTES le on (le.ref = e.etat and le.categorie = 1)');
    SQL.Add('LEFT JOIN LISTES lr on (lr.ref = e.reliure and lr.categorie = 2)');
    SQL.Add('LEFT JOIN LISTES lte on (lte.ref = e.typeedition and lte.categorie = 3)');
    SQL.Add('LEFT JOIN LISTES lo on (lo.ref = e.orientation and lo.categorie = 4)');
    SQL.Add('LEFT JOIN LISTES lf on (lf.ref = e.formatedition and lf.categorie = 5)');
    SQL.Add('WHERE ID_Edition = ?');
    Params.AsString[0] := GUIDToString(Reference);
    FetchBlobs := True;
    Open;
    RecInconnu := Eof;

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
    Self.TypeEdition := Fields.ByNameAsInteger['TypeEdition'];
    Self.sTypeEdition := Trim(Fields.ByNameAsString['sTypeEdition']);
    Self.NombreDePages := Fields.ByNameAsInteger['NombreDePages'];
    Self.Etat := Fields.ByNameAsInteger['Etat'];
    Self.sEtat := Trim(Fields.ByNameAsString['sEtat']);
    Self.Reliure := Fields.ByNameAsInteger['Reliure'];
    Self.sReliure := Trim(Fields.ByNameAsString['sReliure']);
    Self.Orientation := Fields.ByNameAsInteger['Orientation'];
    Self.sOrientation := Trim(Fields.ByNameAsString['sOrientation']);
    Self.FormatEdition := Fields.ByNameAsInteger['FormatEdition'];
    Self.sFormatEdition := Trim(Fields.ByNameAsString['sFormatEdition']);
    Self.DateAchat := Fields.ByNameAsDate['DateAchat'];
    Self.Notes.Text := Fields.ByNameAsString['Notes'];
    Self.AnneeCote := Fields.ByNameAsInteger['ANNEECOTE'];
    Self.PrixCote := Fields.ByNameAsCurrency['PRIXCOTE'];

    Self.Emprunts.Fill(Self.ID_Edition, seAlbum);

    Close;
    SQL.Text := 'SELECT ID_Couverture, FichierCouverture, STOCKAGECOUVERTURE, CategorieImage, l.Libelle as sCategorieImage';
    SQL.Add('FROM Couvertures c LEFT JOIN Listes l ON (c.categorieimage = l.ref and l.categorie = 6)');
    SQL.Add('WHERE ID_Edition = ? ORDER BY c.categorieimage NULLS FIRST, c.Ordre');
    Params.AsString[0] := GUIDToString(Self.ID_Edition);
    Open;
    while not Eof do
    begin
      Self.Couvertures.Add(TCouverture.Make(q));
      Next;
    end;
  finally
    q.Transaction.Free;
    q.Free;
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

function TEditionComplete.GetReference: TGUID;
begin
  Result := ID_Edition;
end;

procedure TEditionComplete.SaveToDatabase(UseTransaction: TJvUIBTransaction);
var
  PC: TCouverture;
  hg: IHourGlass;
  q: TJvUIBQuery;
  s: string;
  i: Integer;
  Stream: TStream;
  q1, q2, q3, q4, q5, q6: TJvUIBQuery;
  FichiersImages: TStringList;
begin
  inherited;
  FichiersImages := TStringList.Create;
  hg := THourGlass.Create;
  q := TJvUIBQuery.Create(nil);
  with q do
  try
    Transaction := UseTransaction;

    if RecInconnu then
    begin
      SQL.Text := 'INSERT INTO EDITIONS (ID_Edition, ID_Album, ID_Editeur, ID_Collection, ANNEEEDITION, PRIX, VO, TYPEEDITION, COULEUR, ISBN, STOCK, DEDICACE, OFFERT, GRATUIT, ETAT, RELIURE, ORIENTATION, FormatEdition, DATEACHAT, NOTES, NOMBREDEPAGES, ANNEECOTE, PRIXCOTE)';
      SQL.Add('VALUES');
      SQL.Add('(:ID_Edition, :ID_Album, :ID_Editeur, :ID_Collection, :ANNEEEDITION, :PRIX, :VO, :TYPEEDITION, :COULEUR, :ISBN, :STOCK, :DEDICACE, :OFFERT, :GRATUIT, :ETAT, :RELIURE, :ORIENTATION, :FormatEdition, :DATEACHAT, :NOTES, :NOMBREDEPAGES, :ANNEECOTE, :PRIXCOTE)');
    end
    else
    begin
      SQL.Text := 'UPDATE EDITIONS SET';
      SQL.Add('ID_Album = :ID_Album, ID_Editeur = :ID_Editeur, ID_Collection = :ID_Collection, ANNEEEDITION = :ANNEEEDITION,');
      SQL.Add('PRIX = :PRIX, VO = :VO, TYPEEDITION = :TYPEEDITION, COULEUR = :COULEUR, ISBN = :ISBN, STOCK = :STOCK, ETAT = :ETAT, RELIURE = :RELIURE,');
      SQL.Add('DEDICACE = :DEDICACE, OFFERT = :OFFERT, GRATUIT = :GRATUIT, DATEACHAT = :DATEACHAT, NOTES = :NOTES, ORIENTATION = :ORIENTATION,');
      SQL.Add('ANNEECOTE = :ANNEECOTE, PRIXCOTE = :PRIXCOTE,');
      SQL.Add('FormatEdition = :FormatEdition, NOMBREDEPAGES = :NOMBREDEPAGES WHERE (ID_Edition = :ID_Edition)');
    end;

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
    Params.ByNameAsInteger['TYPEEDITION'] := TypeEdition;
    Params.ByNameAsInteger['ETAT'] := Etat;
    Params.ByNameAsInteger['RELIURE'] := Reliure;
    Params.ByNameAsInteger['Orientation'] := Orientation;
    Params.ByNameAsInteger['FormatEdition'] := FormatEdition;
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
    if s <> '' then
    begin
      SQL.Text := 'DELETE FROM COUVERTURES WHERE ID_EDITION = ? AND ID_COUVERTURE NOT IN (' + s + ')';
      Params.AsString[0] := GUIDToString(ID_Edition);
      ExecSQL;
    end;

    q1 := TJvUIBQuery.Create(nil);
    q2 := TJvUIBQuery.Create(nil);
    q3 := TJvUIBQuery.Create(nil);
    q4 := TJvUIBQuery.Create(nil);
    q5 := TJvUIBQuery.Create(nil);
    q6 := TJvUIBQuery.Create(nil);
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
      for i := 0 to Pred(FichiersImages.Count) do
      begin
        Params.AsString[0] := FichiersImages[i];
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

procedure TEditionComplete.PrepareInstance;
begin
  inherited;
  Editeur := TEditeurComplet.Create;
  Collection := TCollection.Create;
  Emprunts := TEmpruntsComplet.Create;
  Couvertures := TListOfTCouverture.Create;
  Notes := TStringList.Create;
end;

{ TEditionsComplet }

procedure TEditionsComplet.Clear;
begin
  inherited;
  Editions.Clear;
end;

constructor TEditionsComplet.Create(const Reference: TGUID; Stock: Integer);
begin
  inherited Create;
  Fill(Reference, Stock);
end;

destructor TEditionsComplet.Destroy;
begin
  Editions.Free;
  inherited;
end;

procedure TEditionsComplet.Fill(const Reference: TGUID; Stock: Integer = -1);
begin
  inherited Fill(Reference);
  with TJvUIBQuery.Create(nil) do
  try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT ID_Edition FROM EDITIONS WHERE ID_Album = ?';
    if Stock in [0, 1] then SQL.Add('AND e.STOCK = :Stock');
    Params.AsString[0] := GUIDToString(Reference);
    if Stock in [0, 1] then Params.AsInteger[1] := Stock;
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

procedure TEditionsComplet.PrepareInstance;
begin
  inherited;
  Editions := TListOfTEditionComplete.Create;
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
  FreeAndNil(Adresse);
  FreeAndNil(Emprunts);
  inherited;
end;

procedure TEmprunteurComplet.Fill(const Reference: TGUID);
var
  q: TJvUIBQuery;
begin
  inherited;
  if IsEqualGUID(Reference, GUID_NULL) then Exit;
  Self.ID_Emprunteur := Reference;
  q := TJvUIBQuery.Create(nil);
  with q do
  try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT NomEmprunteur, AdresseEmprunteur FROM Emprunteurs WHERE ID_Emprunteur = ?';
    Params.AsString[0] := GUIDToString(Reference);
    FetchBlobs := True;
    Open;
    RecInconnu := Eof;
    Self.Nom := Fields.ByNameAsString['NomEmprunteur'];
    Self.Adresse.Text := Fields.ByNameAsString['AdresseEmprunteur'];

    Self.Emprunts.Fill(Self.ID_Emprunteur, seEmprunteur);

    Close;
  finally
    q.Transaction.Free;
    q.Free;
  end;
end;

function TEmprunteurComplet.GetReference: TGUID;
begin
  Result := ID_Emprunteur;
end;

procedure TEmprunteurComplet.PrepareInstance;
begin
  inherited;
  Adresse := TStringList.Create;
  Emprunts := TEmpruntsComplet.Create;
end;

procedure TEmprunteurComplet.SaveToDatabase(UseTransaction: TJvUIBTransaction);
var
  s: string;
begin
  inherited;
  with TJvUIBQuery.Create(nil) do
  try
    Transaction := UseTransaction;

    if RecInconnu then
      SQL.Text := 'INSERT INTO EMPRUNTEURS (ID_Emprunteur, NOMEMPRUNTEUR, ADRESSEEMPRUNTEUR) VALUES (:ID_Emprunteur, :NOMEMPRUNTEUR, :ADRESSEEMPRUNTEUR)'
    else
      SQL.Text := 'UPDATE EMPRUNTEURS SET NOMEMPRUNTEUR = :NOMEMPRUNTEUR, ADRESSEEMPRUNTEUR = :ADRESSEEMPRUNTEUR WHERE ID_Emprunteur = :ID_Emprunteur';

    Params.ByNameAsString['NOMEMPRUNTEUR'] := Trim(Nom);
    s := Self.Adresse.Text;
    ParamsSetBlob('ADRESSEEMPRUNTEUR', s);

    Params.ByNameAsString['ID_Emprunteur'] := GUIDToString(ID_Emprunteur);
    ExecSQL;
    Transaction.Commit;
  finally
    Free;
  end;
end;

{ TSerieComplete }

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
  FreeAndNil(Albums);
  FreeAndNil(ParaBD);
  Genres.Free;
  Sujet.Free;
  Notes.Free;
  Editeur.Free;
  FreeAndNil(Collection);
  FreeAndNil(Scenaristes);
  FreeAndNil(Dessinateurs);
  FreeAndNil(Coloristes);
  inherited;
end;

procedure TSerieComplete.Fill(const Reference: TGUID);
var
  q: TJvUIBQuery;
begin
  inherited;
  if IsEqualGUID(Reference, GUID_NULL) and (not FForce) then Exit;
  Self.ID_Serie := Reference;
  q := TJvUIBQuery.Create(nil);
  with q do
  try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    FetchBlobs := True;
    SQL.Text := 'SELECT TITRESERIE, TERMINEE, SUJETSERIE, REMARQUESSERIE, SITEWEB, COMPLETE, S.ID_Editeur, S.ID_Collection, NOMCOLLECTION, SUIVRESORTIES, SUIVREMANQUANTS '
      + 'FROM SERIES S LEFT JOIN COLLECTIONS C ON S.ID_Collection = C.ID_Collection '
      + 'WHERE ID_Serie = ?';
    Params.AsString[0] := GUIDToString(Reference);
    Open;
    RecInconnu := Eof;
    Self.Titre := Fields.ByNameAsString['TITRESERIE'];
    if Fields.ByNameIsNull['TERMINEE'] then
      Self.Terminee := -1
    else
      Self.Terminee := Fields.ByNameAsInteger['TERMINEE'];
    Self.SuivreSorties := RecInconnu or Fields.ByNameAsBoolean['SUIVRESORTIES'];
    Self.Complete := Fields.ByNameAsBoolean['COMPLETE'];
    Self.SuivreManquants := RecInconnu or Fields.ByNameAsBoolean['SUIVREMANQUANTS'];
    Self.Sujet.Text := Fields.ByNameAsString['SUJETSERIE'];
    Self.Notes.Text := Fields.ByNameAsString['REMARQUESSERIE'];
    Self.SiteWeb := Trim(Fields.ByNameAsString['SITEWEB']);
    Self.Editeur.Fill(StringToGUIDDef(Fields.ByNameAsString['ID_EDITEUR'], GUID_NULL));
    Self.Collection.Fill(q);
    FetchBlobs := False;

    Close;
    SQL.Text := 'SELECT ID_Album, TITREALBUM, INTEGRALE, HORSSERIE, TOME, TOMEDEBUT, TOMEFIN, ID_Serie FROM ALBUMS';
    if IsEqualGUID(Reference, GUID_NULL) then
      SQL.Add('WHERE (ID_Serie IS NULL OR ID_Serie = ?)')
    else
      SQL.Add('WHERE ID_Serie = ?');
    if not IsEqualGUID(FIdAuteur, GUID_NULL) then
      SQL.Add('AND ID_Album IN (SELECT ID_Album FROM AUTEURS WHERE ID_Personne = ?)');
    SQL.Add('ORDER BY HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST');
    Params.AsString[0] := GUIDToString(Reference);
    if not IsEqualGUID(FIdAuteur, GUID_NULL) then
      Params.AsString[1] := GUIDToString(FIdAuteur);
    Open;
    while not Eof do
    begin
      Self.Albums.Add(TAlbum.Make(q));
      Next;
    end;

    Close;
    SQL.Text := 'SELECT ID_ParaBD, TITREPARABD, ID_Serie, TITRESERIE, ACHAT, COMPLET, SCATEGORIE FROM VW_LISTE_PARABD';
    if IsEqualGUID(Reference, GUID_NULL) then
      SQL.Add('WHERE (ID_Serie IS NULL OR ID_Serie = ?)')
    else
      SQL.Add('WHERE ID_Serie = ?');
    if not IsEqualGUID(FIdAuteur, GUID_NULL) then
      SQL.Add('AND ID_ParaBD IN (SELECT ID_ParaBD FROM AUTEURS_PARABD WHERE ID_Personne = ?)');
    SQL.Add('ORDER BY TITREPARABD');
    Params.AsString[0] := GUIDToString(Reference);
    if not IsEqualGUID(FIdAuteur, GUID_NULL) then
      Params.AsString[1] := GUIDToString(FIdAuteur);
    Open;
    while not Eof do
    begin
      Self.ParaBD.Add(TParaBD.Make(q));
      Next;
    end;

    Close;
    SQL.Text := 'SELECT g.ID_Genre, Genre '
      + 'FROM GenreSeries s INNER JOIN Genres g ON g.ID_Genre = s.ID_Genre '
      + 'WHERE ID_Serie = ?'
      + 'ORDER BY GENRE';
    Params.AsString[0] := GUIDToString(Reference);
    Open;
    while not Eof do
    begin
      Self.Genres.Values[Fields.AsString[0]] := Fields.AsString[1];
      Next;
    end;

    Close;
    SQL.Text := 'SELECT * FROM PROC_AUTEURS(NULL, ?, NULL)';
    Params.AsString[0] := GUIDToString(Reference);
    Open;
    while not Eof do
    begin
      case Fields.ByNameAsInteger['Metier'] of
        0: Self.Scenaristes.Add(TAuteur.Make(q));
        1: Self.Dessinateurs.Add(TAuteur.Make(q));
        2: Self.Coloristes.Add(TAuteur.Make(q));
      end;
      Next;
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

function TSerieComplete.GetReference: TGUID;
begin
  Result := ID_Serie;
end;

procedure TSerieComplete.PrepareInstance;
begin
  inherited;
  FIdAuteur := GUID_NULL;
  FForce := False;
  Albums := TListOfTAlbum.Create(True);
  ParaBD := TListOfTParaBD.Create(True);
  Genres := TStringList.Create;
  Sujet := TStringList.Create;
  Notes := TStringList.Create;
  Editeur := TEditeurComplet.Create;
  Collection := TCollection.Create;
  Scenaristes := TListOfTAuteur.Create(True);
  Dessinateurs := TListOfTAuteur.Create(True);
  Coloristes := TListOfTAuteur.Create(True);
end;

procedure TSerieComplete.SaveToDatabase(UseTransaction: TJvUIBTransaction);
var
  s: string;
  i: Integer;
begin
  inherited;
  with TJvUIBQuery.Create(nil) do
  try
    Transaction := UseTransaction;
    if RecInconnu then
    begin
      SQL.Text := 'INSERT INTO SERIES (ID_Serie, TitreSerie, Terminee, SuivreSorties, Complete, SuivreManquants, SITEWEB, ID_Editeur, ID_Collection, SUJETserie, REMARQUESserie)';
      SQL.Add('VALUES');
      SQL.Add('(:ID_Serie, :TitreSerie, :Terminee, :SuivreSorties, :Complete, :SuivreManquants, :SITEWEB, :ID_Editeur, :ID_Collection, :SUJETserie, :REMARQUESserie)');
    end
    else
    begin
      SQL.Text := 'UPDATE SERIES SET TitreSerie = :TitreSerie, Terminee = :Terminee, SuivreSorties = :SuivreSorties, Complete = :Complete, SuivreManquants = :SuivreManquants, SITEWEB = :SITEWEB, ID_Editeur = :ID_Editeur, ID_Collection = :ID_Collection,';
      SQL.Add('SUJETserie = :SUJETserie, REMARQUESserie = :REMARQUESserie');
      SQL.Add('WHERE ID_Serie = :ID_Serie');
    end;
    Params.ByNameAsString['TitreSerie'] := Trim(Self.Titre);
    if TCheckBoxState(Self.Terminee) = cbGrayed then
      Params.ByNameIsNull['TERMINEE'] := True
    else
      Params.ByNameAsInteger['TERMINEE'] := Self.Terminee;
    Params.ByNameAsBoolean['SUIVRESORTIES'] := Self.SuivreSorties;
    Params.ByNameAsBoolean['COMPLETE'] := Self.Complete;
    Params.ByNameAsBoolean['SUIVREMANQUANTS'] := Self.SuivreManquants;
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
      ParamsSetBlob('SUJETserie', s)
    else
      Params.ByNameIsNull['SUJETserie'] := True;
    s := Self.Notes.Text;
    if s <> '' then
      ParamsSetBlob('REMARQUESserie', s)
    else
      Params.ByNameIsNull['REMARQUESserie'] := True;

    Params.ByNameAsString['ID_Serie'] := GUIDToString(Self.ID_Serie);
    ExecSQL;

    SupprimerToutDans('', 'GENRESERIES', 'ID_Serie', ID_Serie);
    SQL.Clear;
    SQL.Add('INSERT INTO GENRESERIES (ID_Serie, ID_Genre) VALUES (:ID_Serie, :ID_Genre)');
    for i := 0 to Pred(Genres.Count) do
    begin
      Params.AsString[0] := GUIDToString(ID_Serie);
      Params.AsString[1] := Genres.Names[i];
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
  q: TJvUIBQuery;
begin
  inherited;
  if IsEqualGUID(Reference, GUID_NULL) then Exit;
  Self.ID_Editeur := Reference;
  q := TJvUIBQuery.Create(nil);
  with q do
  try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT NOMEDITEUR, SITEWEB FROM EDITEURS WHERE ID_Editeur = ?';
    Params.AsString[0] := GUIDToString(Reference);
    Open;
    RecInconnu := Eof;
    Self.NomEditeur := Fields.ByNameAsString['NOMEDITEUR'];
    Self.SiteWeb := Trim(Fields.ByNameAsString['SITEWEB']);
  finally
    q.Transaction.Free;
    q.Free;
  end;
end;

function TEditeurComplet.GetReference: TGUID;
begin
  Result := ID_Editeur;
end;

procedure TEditeurComplet.SaveToDatabase(UseTransaction: TJvUIBTransaction);
begin
  inherited;
  with TJvUIBQuery.Create(nil) do
  try
    Transaction := UseTransaction;

    if RecInconnu then
      SQL.Text := 'INSERT INTO EDITEURS (ID_Editeur, NOMEDITEUR, SITEWEB) VALUES (:ID_Editeur, :NOMEDITEUR, :SITEWEB)'
    else
      SQL.Text := 'UPDATE EDITEURS SET NOMEDITEUR = :NOMEDITEUR, SITEWEB = :SITEWEB WHERE ID_Editeur = :ID_Editeur';

    Params.ByNameAsString['NOMEDITEUR'] := Trim(NomEditeur);
    Params.ByNameAsString['SITEWEB'] := Trim(SiteWeb);
    Params.ByNameAsString['ID_Editeur'] := GUIDToString(ID_Editeur);
    ExecSQL;
    Transaction.Commit;
  finally
    Free;
  end;
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
  q: TJvUIBQuery;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  Stats.Editeur := Editeur;
  q := TJvUIBQuery.Create(nil);
  with q do
  try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Add('SELECT COUNT(a.ID_Album) FROM Albums a INNER JOIN Editions e ON a.ID_Album = e.ID_Album');
    if not IsEqualGUID(ID_Editeur, GUID_NULL) then
      SQL.Add('AND e.ID_Editeur = ' + QuotedStr(GUIDToString(ID_Editeur)))
    else
      SQL.Add('');
    SQL.Add('');
    Open; Stats.NbAlbums := Fields.AsInteger[0]; Close;
    SQL[2] := 'WHERE e.Couleur = 0'; Open; Stats.NbAlbumsNB := Fields.AsInteger[0]; Close;
    SQL[2] := 'WHERE e.VO = 1'; Open; Stats.NbAlbumsVO := Fields.AsInteger[0]; Close;
    SQL[2] := 'WHERE e.Stock = 1'; Open; Stats.NbAlbumsStock := Fields.AsInteger[0]; Close;
    SQL[2] := 'WHERE e.Dedicace = 1'; Open; Stats.NbAlbumsDedicace := Fields.AsInteger[0]; Close;
    SQL[2] := 'WHERE e.Offert = 1'; Open; Stats.NbAlbumsOffert := Fields.AsInteger[0]; Close;
    SQL[2] := 'WHERE e.Gratuit = 1'; Open; Stats.NbAlbumsGratuit := Fields.AsInteger[0]; Close;
    SQL[2] := 'WHERE a.Integrale = 1'; Open; Stats.NbAlbumsIntegrale := Fields.AsInteger[0]; Close;
    SQL[2] := 'WHERE a.HorsSerie = 1'; Open; Stats.NbAlbumsHorsSerie := Fields.AsInteger[0]; Close;

    SQL.Clear;
    SQL.Add('select count(distinct a.ID_Serie) from albums a');
    if not IsEqualGUID(ID_Editeur, GUID_NULL) then
      SQL.Add('inner join editions e on e.ID_Album = a.ID_Album and e.ID_Editeur=' + QuotedStr(GUIDToString(ID_Editeur)))
    else
      SQL.Add('');
    Open; Stats.NbSeries := Fields.AsInteger[0]; Close;
    SQL.Add('left join Series s on a.ID_Serie = s.ID_Serie');
    SQL.Add('');
    SQL[3] := 'WHERE s.Terminee = 1'; Open; Stats.NbSeriesTerminee := Fields.AsInteger[0]; Close;

    SQL.Text := 'SELECT Min(a.AnneeParution) AS MinAnnee, Max(a.AnneeParution) AS MaxAnnee FROM Albums a';
    if not IsEqualGUID(ID_Editeur, GUID_NULL) then SQL.Add('INNER JOIN Editions e ON e.ID_Album = a.ID_Album and e.ID_Editeur=' + QuotedStr(GUIDToString(ID_Editeur)));
    Open;
    Stats.MinAnnee := 0;
    Stats.MaxAnnee := 0;
    if not EOF then
    begin
      Stats.MinAnnee := Fields.ByNameAsInteger['MinAnnee'];
      Stats.MaxAnnee := Fields.ByNameAsInteger['MaxAnnee'];
    end;

    Close;
    SQL.Text := 'SELECT COUNT(g.ID_Genre) AS QuantiteGenre, g.ID_Genre, g.Genre, g.UpperGenre FROM GenreSeries gs INNER JOIN Genres g ON gs.ID_Genre = g.ID_Genre';
    if not IsEqualGUID(ID_Editeur, GUID_NULL) then
    begin
      SQL.Add('INNER JOIN Albums a ON a.ID_Serie = gs.ID_Serie');
      SQL.Add('INNER JOIN Editions e ON e.ID_Album = a.ID_Album and e.ID_Editeur=' + QuotedStr(GUIDToString(ID_Editeur)));
    end;
    SQL.Add('GROUP BY g.Genre, g.ID_Genre, g.UpperGenre ORDER BY 1 desc, g.UpperGenre');
    Open;
    while not (EOF) do
    begin
      Stats.ListGenre.Add(TGenre.Make(Q));
      Next;
    end;

    Close;
    SQL.Text := 'SELECT Sum(Prix) AS SumPrix, COUNT(Prix) AS CountPrix, Min(Prix) AS MinPrix, Max(Prix) AS MaxPrix FROM Editions';
    if not IsEqualGUID(ID_Editeur, GUID_NULL) then SQL.Add('WHERE ID_Editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
    Open;
    Stats.ValeurConnue := Fields.ByNameAsCurrency['SumPrix'];
    Stats.PrixAlbumMoyen := 0;
    Stats.PrixAlbumMinimun := 0;
    Stats.PrixAlbumMaximun := 0;
    if not EOF and Fields.ByNameAsBoolean['CountPrix'] then
    begin
      Stats.PrixAlbumMoyen := Fields.ByNameAsCurrency['SumPrix'] / Fields.ByNameAsInteger['CountPrix'];
      Stats.PrixAlbumMinimun := Fields.ByNameAsCurrency['MinPrix'];
      Stats.PrixAlbumMaximun := Fields.ByNameAsCurrency['MaxPrix'];
    end;

    Close;
    SQL.Clear;
    SQL.Add('SELECT COUNT(ID_Edition) AS CountRef FROM Editions WHERE Prix IS NULL');
    if not IsEqualGUID(ID_Editeur, GUID_NULL) then SQL.Add('AND ID_Editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
    Open;
    Stats.NbAlbumsSansPrix := 0;
    if not EOF then Stats.NbAlbumsSansPrix := Fields.ByNameAsInteger['countref'] - Stats.NbAlbumsGratuit;
    Stats.ValeurEstimee := Stats.ValeurConnue + Stats.NbAlbumsSansPrix * Stats.PrixAlbumMoyen;

    Close;
    SQL.Text := 'SELECT COUNT(DISTINCT st.ID_Emprunteur) FROM Statut st';
    if not IsEqualGUID(ID_Editeur, GUID_NULL) then SQL.Add('INNER JOIN Editions e ON e.ID_Edition = st.ID_Edition AND e.ID_Editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
    Open;
    Stats.NbEmprunteurs := Fields.AsInteger[0];

    Close;
    SQL.Text := 'SELECT COUNT(st.ID_Emprunteur)/' + IntToStr(Stats.NbEmprunteurs) + ' AS moy FROM Statut st';
    if not IsEqualGUID(ID_Editeur, GUID_NULL) then SQL.Add('INNER JOIN Editions e ON e.ID_Edition = st.ID_Edition AND e.ID_Editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
    SQL.Add('WHERE st.PretEmprunt = 1');
    Stats.MoyEmprunteurs := 0;
    if Bool(Stats.NbEmprunteurs) then
    begin
      Open;
      Stats.MoyEmprunteurs := Fields.ByNameAsInteger['moy'];
    end;

    Close;
    SQL.Clear;
    SQL.Add('SELECT COUNT(e.ID_Emprunteur) AS CountNumero, e.NomEmprunteur, e.ID_Emprunteur');
    SQL.Add('FROM Statut st INNER JOIN Emprunteurs e ON e.ID_Emprunteur = st.ID_Emprunteur');
    if not IsEqualGUID(ID_Editeur, GUID_NULL) then SQL.Add('INNER JOIN Editions ed ON ed.ID_Edition = st.ID_Edition AND ed.ID_Editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
    SQL.Add('WHERE (st.PretEmprunt = 1)');
    SQL.Add('GROUP BY e.ID_Emprunteur, e.NomEmprunteur');
    SQL.Add('ORDER BY 1 DESC, e.NomEmprunteur DESC');
    Open;
    Stats.MinEmprunteurs := 0;
    Stats.MaxEmprunteurs := 0;
    if not EOF then
    begin
      Stats.MaxEmprunteurs := Fields.ByNameAsInteger['CountNumero'];
      while not Eof do
        Next; // Last;
      Stats.MinEmprunteurs := Fields.ByNameAsInteger['CountNumero'];
      if Stats.MinEmprunteurs = Stats.MaxEmprunteurs then Stats.MinEmprunteurs := 0;
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
    if not IsEqualGUID(ID_Editeur, GUID_NULL) then SQL.Add('INNER JOIN Editions e ON e.ID_Edition = st.ID_Edition AND e.ID_Editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
    Open;
    Stats.NbEmpruntes := Fields.AsInteger[0];

    Close;
    SQL.Text := 'SELECT COUNT(st.ID_Edition)/' + IntToStr(Stats.NbEmpruntes) + ' AS moy FROM Statut st';
    if not IsEqualGUID(ID_Editeur, GUID_NULL) then SQL.Add('INNER JOIN Editions e ON e.ID_Edition = st.ID_Edition AND e.ID_Editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
    SQL.Add('WHERE st.PretEmprunt = 1');
    Stats.MoyEmpruntes := 0;
    if Bool(Stats.NbEmpruntes) then
    begin
      Open;
      Stats.MoyEmpruntes := Fields.ByNameAsInteger['moy'];
    end;

    Close;
    SQL.Clear;
    SQL.Add('SELECT distinct count(ID_Edition) FROM VW_EMPRUNTS WHERE (PretEmprunt = 1)');
    if not IsEqualGUID(ID_Editeur, GUID_NULL) then SQL.Add('AND ID_Editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
    SQL.Add('group by ID_Edition');
    SQL.Add('ORDER BY 1');
    Open;
    Stats.MinEmpruntes := 0;
    Stats.MaxEmpruntes := 0;
    if not EOF then
    begin
      Stats.MaxEmpruntes := Fields.AsInteger[0];
      while not Eof do
        Next; // Last;
      Stats.MinEmpruntes := Fields.AsInteger[0];
      if Stats.MinEmpruntes = Stats.MaxEmpruntes then Stats.MinEmpruntes := 0;

      Close;
      SQL.Clear;
      SQL.Add('SELECT *');
      SQL.Add('FROM VW_EMPRUNTS');
      SQL.Add('WHERE (PretEmprunt = 1)');
      if not IsEqualGUID(ID_Editeur, GUID_NULL) then SQL.Add('AND ID_Editeur = ' + QuotedStr(GUIDToString(ID_Editeur)));
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
  FreeAndNil(ListEmprunteursMax);
  FreeAndNil(ListEmprunteursMin);
  FreeAndNil(ListAlbumsMax);
  FreeAndNil(ListAlbumsMin);
  FreeAndNil(ListGenre);
  FreeAndNil(ListEditeurs);
  inherited;
end;

procedure TStats.Fill(Complete: Boolean);
var
  PS: TStats;
  q: TJvUIBQuery;
  hg: IHourGlass;
begin
  inherited Fill(GUID_NULL);
  hg := THourGlass.Create;
  CreateStats(Self);
  if Complete then
  begin
    q := TJvUIBQuery.Create(nil);
    with q do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      Close;
      SQL.Clear;
      SQL.Add('SELECT DISTINCT ed.ID_Editeur, e.NomEditeur FROM Editions ed');
      SQL.Add('INNER JOIN Editeurs e ON ed.ID_Editeur = e.ID_Editeur');
      SQL.Add('ORDER BY e.UpperNomEditeur');
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
  ListEmprunteursMax := TListOfTEmprunteur.Create;
  ListAlbumsMax := TListOfTAlbum.Create;
  ListEmprunteursMin := TListOfTEmprunteur.Create;
  ListAlbumsMin := TListOfTAlbum.Create;
  ListGenre := TListOfTGenre.Create;
  ListEditeurs := TListOfTStats.Create;
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
  Emprunts.Free;
  inherited;
end;

procedure TEmpruntsComplet.Fill(const Reference: TGUID; Source: TSrcEmprunt; Sens: TSensEmprunt; Apres, Avant: TDateTime; EnCours, Stock: Boolean);
var
  q: TJvUIBQuery;

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
      if EnCours then Add('Prete = 1');
      case Sens of
        ssPret: Add('PretEmprunt = 1');
        ssRetour: Add('PretEmprunt = 0');
      end;
      if Apres >= 0 then Add('DateEmprunt >= :DateApres');
      if Avant >= 0 then Add('DateEmprunt <= :DateAvant');

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
    if Apres >= 0 then q.Params.ByNameAsDateTime['DateApres'] := Apres;
    if Avant >= 0 then q.Params.ByNameAsDateTime['DateAvant'] := Avant;
  end;

var
  PE: TEmprunt;
  s: TStringList;
  Ref: string;
begin
  inherited Fill(GUID_NULL);
  q := TJvUIBQuery.Create(nil);
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
          if PE.Pret then Inc(Self.NBEmprunts);
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
  Emprunts := TListOfTEmprunt.Create;
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
  Series.Free;
  inherited;
end;

procedure TSeriesIncompletes.Fill(AvecIntegrales, AvecAchats: Boolean; const ID_Serie: TGUID);
var
  q: TJvUIBQuery;
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
  q := TJvUIBQuery.Create(nil);
  with q do
  try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT * FROM Albums_MANQUANTS(:WithIntegrales, :WithAchats, :ID_Serie) order by UPPERTITRESERIE, TOME';
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
        if not IsEqualGUID(CurrentSerie, GUID_NULL) then UpdateSerie;
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
    if not IsEqualGUID(CurrentSerie, GUID_NULL) then UpdateSerie;
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
  Series := TListOfTSerieIncomplete.Create(True);
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
  AnneesPassees.Free;
  AnneeEnCours.Free;
  AnneesProchaines.Free;
  inherited;
end;

procedure TPrevisionsSorties.Fill(AvecAchats: Boolean; const ID_Serie: TGUID);
var
  q: TJvUIBQuery;
  Annee, CurrentAnnee: Integer;
  Prevision: TPrevisionSortie;
begin
  inherited Fill(GUID_NULL);
  CurrentAnnee := YearOf(Now);
  q := TJvUIBQuery.Create(nil);
  with q do
  try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT * FROM PREVISIONS_SORTIES(:WithAchats, :ID_Serie) order by ANNEEPARUTION, CASE WHEN MOISPARUTION BETWEEN 1 AND 4 THEN 1 WHEN MOISPARUTION BETWEEN 5 AND 8 THEN 2 WHEN MOISPARUTION BETWEEN 9 AND 12 THEN 3 ELSE 0 END, UPPERTITRESERIE';
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
  AnneesPassees := TListOfTPrevisionSortie.Create(True);
  AnneeEnCours := TListOfTPrevisionSortie.Create(True);
  AnneesProchaines := TListOfTPrevisionSortie.Create(True);
end;

{ TPrevisionSortie }

constructor TPrevisionSortie.Create;
begin
  inherited;
  Serie := TSerie.Create;
end;

destructor TPrevisionSortie.Destroy;
begin
  Serie.Free;
  inherited;
end;

function TPrevisionSortie.sAnnee: string;
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
    if Pos('<>', s) <> 0 then s := StringReplace(s, '<>', ' à ', []);
    AjoutString(Result, s, ', ');
  end;
end;

destructor TSerieIncomplete.Destroy;
begin
  Serie.Free;
  NumerosManquants.Free;
  inherited;
end;

procedure TSerieIncomplete.PrepareInstance;
begin
  inherited;
  NumerosManquants := TStringList.Create;
  Serie := TSerie.Create;
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
  FreeAndNil(Series);
  FreeAndNil(Biographie);
  inherited;
end;

procedure TAuteurComplet.Fill(const Reference: TGUID);
var
  q: TJvUIBQuery;
begin
  inherited;
  if IsEqualGUID(Reference, GUID_NULL) then Exit;
  Self.ID_Auteur := Reference;
  q := TJvUIBQuery.Create(nil);
  with q do
  try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT NOMPERSONNE, SITEWEB, BIOGRAPHIE FROM PERSONNES WHERE ID_Personne = ?';
    Params.AsString[0] := GUIDToString(Reference);
    FetchBlobs := True;
    Open;
    RecInconnu := Eof;
    Self.NomAuteur := Fields.ByNameAsString['NOMPERSONNE'];
    Self.Biographie.Text := Fields.ByNameAsString['BIOGRAPHIE'];
    Self.SiteWeb := Trim(Fields.ByNameAsString['SITEWEB']);
    FetchBlobs := False;

    SQL.Clear;
    // UpperTitreSerie en premier pour forcer l'union à trier sur le titre
    SQL.Add('SELECT UPPERTITRESERIE, al.ID_Serie');
    SQL.Add('FROM VW_LISTE_ALBUMS al');
    SQL.Add('  INNER JOIN AUTEURS au ON al.ID_Album = au.ID_Album AND au.ID_Personne = :ID_Personne');
    SQL.Add('union');
    SQL.Add('SELECT UPPERTITRESERIE, s.ID_Serie');
    SQL.Add('FROM auteurs_series au');
    SQL.Add('  INNER JOIN SERIES s ON s.ID_Serie = au.ID_Serie AND au.ID_Personne = :ID_Personne');
    SQL.Add('union');
    SQL.Add('SELECT UPPERTITRESERIE, p.ID_Serie');
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
  finally
    q.Transaction.Free;
    q.Free;
  end;
end;

function TAuteurComplet.GetReference: TGUID;
begin
  Result := ID_Auteur;
end;

procedure TAuteurComplet.PrepareInstance;
begin
  inherited;
  Series := TListOfTSerieComplete.Create(True);
  Biographie := TStringList.Create;
end;

procedure TAuteurComplet.SaveToDatabase(UseTransaction: TJvUIBTransaction);
var
  s: string;
begin
  inherited;
  with TJvUIBQuery.Create(nil) do
  try
    Transaction := UseTransaction;

    if RecInconnu then
      SQL.Text := 'INSERT INTO PERSONNES (ID_Personne, NOMPERSONNE, SITEWEB, BIOGRAPHIE) VALUES (:ID_Personne, :NOMPERSONNE, :SITEWEB, :BIOGRAPHIE)'
    else
      SQL.Text := 'UPDATE PERSONNES SET NOMPERSONNE = :NOMPERSONNE, SITEWEB = :SITEWEB, BIOGRAPHIE = :BIOGRAPHIE WHERE ID_Personne = :ID_Personne';

    Params.ByNameAsString['NOMPERSONNE'] := Trim(NomAuteur);
    Params.ByNameAsString['SITEWEB'] := Trim(SiteWeb);
    s := Biographie.Text;
    ParamsSetBlob('BIOGRAPHIE', s);

    Params.ByNameAsString['ID_Personne'] := GUIDToString(ID_Auteur);
    ExecSQL;
    Transaction.Commit;
  finally
    Free;
  end;
end;

{ TParaBDComplet }

function TParaBDComplet.ChaineAffichage(AvecSerie: Boolean): string;
begin
  Result := ChaineAffichage(False, AvecSerie);
end;

procedure TParaBDComplet.Acheter(Prevision: Boolean);
var
  q: TJvUIBQuery;
begin
  if IsEqualGUID(Reference, GUID_NULL) then Exit;
  q := TJvUIBQuery.Create(nil);
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
  AjoutString(s, sCategorieParaBD, ' - ');
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
  Auteurs.Free;
  Serie.Free;
  Description.Free;
  inherited;
end;

procedure TParaBDComplet.Fill(const Reference: TGUID);
var
  q: TJvUIBQuery;
  serie: TGUID;
begin
  inherited;
  if IsEqualGUID(Reference, GUID_NULL) then Exit;
  Self.ID_ParaBD := Reference;
  q := TJvUIBQuery.Create(nil);
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

    Self.Titre := Fields.ByNameAsString['TITREPARABD'];
    Self.AnneeEdition := Fields.ByNameAsInteger['ANNEE'];
    Self.Description.Text := Fields.ByNameAsString['DESCRIPTION'];
    Self.CategorieParaBD := Fields.ByNameAsInteger['CategorieParaBD'];
    Self.sCategorieParaBD := Fields.ByNameAsString['sCategorieParaBD'];
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
    while not Eof do
    begin
      Self.Auteurs.Add(TAuteur.Make(q));
      Next;
    end;

    Self.Serie.Fill(serie);
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

procedure TParaBDComplet.SaveToDatabase(UseTransaction: TJvUIBTransaction);
var
  s: string;
  q: TJvUIBQuery;
  i: Integer;
  hg: IHourGlass;
  Stream: TStream;
begin
  inherited;
  hg := THourGlass.Create;
  q := TJvUIBQuery.Create(nil);
  with q do
  try
    Transaction := UseTransaction;

    if RecInconnu then
    begin
      SQL.Text := 'INSERT INTO PARABD (ID_ParaBD, TITREPARABD, ANNEE, ID_Serie, CATEGORIEPARABD, DEDICACE, NUMEROTE, ANNEECOTE, PRIXCOTE, GRATUIT, OFFERT, DATEACHAT, PRIX, STOCK, DESCRIPTION, COMPLET)';
      SQL.Add('VALUES');
      SQL.Add('(:ID_ParaBD, :TITREPARABD, :ANNEE, :ID_Serie, :CATEGORIEPARABD, :DEDICACE, :NUMEROTE, :ANNEECOTE, :PRIXCOTE, :GRATUIT, :OFFERT, :DATEACHAT, :PRIX, :STOCK, :DESCRIPTION, 1)');
    end
    else
    begin
      SQL.Text := 'UPDATE PARABD SET';
      SQL.Add('TITREPARABD = :TITREPARABD, ANNEE = :ANNEE, ID_Serie = :ID_Serie, CATEGORIEPARABD = :CATEGORIEPARABD, DEDICACE = :DEDICACE, NUMEROTE = :NUMEROTE, ANNEECOTE = :ANNEECOTE,');
      SQL.Add('PRIXCOTE = :PRIXCOTE, GRATUIT = :GRATUIT, OFFERT = :OFFERT, DATEACHAT = :DATEACHAT, PRIX = :PRIX, STOCK = :STOCK, COMPLET = 1,');
      SQL.Add('DESCRIPTION = :DESCRIPTION');
      SQL.Add('WHERE (ID_ParaBD = :ID_ParaBD)');
    end;

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
    Params.ByNameAsInteger['CATEGORIEPARABD'] := CategorieParaBD;
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
        if ExtractFilePath(FichierImage) = '' then FichierImage := IncludeTrailingPathDelimiter(RepImages) + FichierImage;
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

function TParaBDComplet.GetReference: TGUID;
begin
  Result := ID_ParaBD;
end;

procedure TParaBDComplet.PrepareInstance;
begin
  inherited;
  Description := TStringList.Create;
  Auteurs := TListOfTAuteur.Create;
  Serie := TSerieComplete.Create;
end;

{ TCollectionComplete }

procedure TCollectionComplete.Clear;
begin
  inherited;
  Editeur.Clear;
end;

constructor TCollectionComplete.Create;
begin
  inherited Create;
  Editeur := TEditeur.Create;
end;

destructor TCollectionComplete.Destroy;
begin
  Editeur.Free;
  inherited;
end;

procedure TCollectionComplete.Fill(const Reference: TGUID);
var
  q: TJvUIBQuery;
begin
  inherited;
  if IsEqualGUID(Reference, GUID_NULL) then Exit;
  Self.ID_Collection := Reference;
  q := TJvUIBQuery.Create(nil);
  with q do
  try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT NOMCOLLECTION, ID_EDITEUR FROM COLLECTIONS WHERE ID_COLLECTION = ?';
    Params.AsString[0] := GUIDToString(Reference);
    Open;
    RecInconnu := Eof;
    Self.NomCollection := Fields.ByNameAsString['NOMCOLLECTION'];
    Self.ID_Editeur := StringToGUIDDef(Fields.ByNameAsString['ID_EDITEUR'], GUID_NULL);
  finally
    Transaction.Free;
    Free;
  end;
end;

function TCollectionComplete.GetID_Editeur: TGUID;
begin
  Result := Editeur.ID;
end;

function TCollectionComplete.GetReference: TGUID;
begin
  Result := ID_Collection;
end;

procedure TCollectionComplete.SaveToDatabase(UseTransaction: TJvUIBTransaction);
begin
  inherited;
  with TJvUIBQuery.Create(nil) do
  try
    Transaction := UseTransaction;
    if RecInconnu then
      SQL.Text := 'INSERT INTO COLLECTIONS (ID_Collection, NOMCOLLECTION, ID_Editeur) VALUES (:ID_Collection, :NOMCOLLECTION, :ID_Editeur)'
    else
      SQL.Text := 'UPDATE COLLECTIONS SET NOMCOLLECTION = :NOMCOLLECTION, ID_Editeur = :ID_Editeur WHERE ID_Collection = :ID_Collection';
    Params.ByNameAsString['NOMCOLLECTION'] := Trim(NomCollection);
    Params.ByNameAsString['ID_EDITEUR'] := GUIDToString(ID_Editeur);
    Params.ByNameAsString['ID_COLLECTION'] := GUIDToString(ID_Collection);
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

{ TObjetComplet }

function TObjetComplet.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := '';
end;

procedure TObjetComplet.Clear;
begin
  inherited;
  RecInconnu := True;
end;

constructor TObjetComplet.Create(const Reference: TGUID);
begin
  inherited Create;
  Fill(Reference);
end;

function TObjetComplet.GetReference: TGUID;
begin
  Result := GUID_NULL;
end;

procedure TObjetComplet.New;
var
  newID: TGUID;
begin
  with TJvUIBQuery.Create(nil) do
  try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'select udf_createguid() from rdb$database';
    Open;
    newID := StringToGUIDDef(Fields.AsString[0], GUID_NULL);
  finally
    Transaction.Free;
    Free;
  end;

  Fill(newID);
end;

procedure TObjetComplet.SaveToDatabase;
var
  Transaction: TJvUIBTransaction;
begin
  Assert(not IsEqualGUID(Reference, GUID_NULL), 'L''ID ne peut être GUID_NULL');

  Transaction := GetTransaction(DMPrinc.UIBDataBase);
  try
    SaveToDatabase(Transaction);
    Transaction.Commit;
  finally
    Transaction.Free;
  end;
end;

procedure TObjetComplet.SaveToDatabase(UseTransaction: TJvUIBTransaction);
begin
  Assert(not IsEqualGUID(Reference, GUID_NULL), 'L''ID ne peut être GUID_NULL');
end;

{ TListOfTSerieComplete }

function TListOfTSerieComplete.Add(AObject: TSerieComplete): Integer;
begin
  Result := inherited Add(AObject);
end;

function TListOfTSerieComplete.GetItem(Index: Integer): TSerieComplete;
begin
  Result := TSerieComplete(inherited GetItem(Index));
end;

procedure TListOfTSerieComplete.Insert(Index: Integer; AObject: TSerieComplete);
begin
  inherited Insert(Index, AObject);
end;

{ TListOfTEditionComplete }

function TListOfTEditionComplete.Add(AObject: TEditionComplete): Integer;
begin
  Result := inherited Add(AObject);
end;

function TListOfTEditionComplete.GetItem(Index: Integer): TEditionComplete;
begin
  Result := TEditionComplete(inherited GetItem(Index));
end;

procedure TListOfTEditionComplete.Insert(Index: Integer; AObject: TEditionComplete);
begin
  inherited Insert(Index, AObject);
end;

{ TListOfTStats }

function TListOfTStats.Add(AObject: TStats): Integer;
begin
  Result := inherited Add(AObject);
end;

function TListOfTStats.GetItem(Index: Integer): TStats;
begin
  Result := TStats(inherited GetItem(Index));
end;

procedure TListOfTStats.Insert(Index: Integer; AObject: TStats);
begin
  inherited Insert(Index, AObject);
end;

{ TListOfTSerieIncomplete }

function TListOfTSerieIncomplete.Add(AObject: TSerieIncomplete): Integer;
begin
  Result := inherited Add(AObject);
end;

function TListOfTSerieIncomplete.GetItem(Index: Integer): TSerieIncomplete;
begin
  Result := TSerieIncomplete(inherited GetItem(Index));
end;

procedure TListOfTSerieIncomplete.Insert(Index: Integer; AObject: TSerieIncomplete);
begin
  inherited Insert(Index, AObject);
end;

{ TListOfTPrevisionSortie }

function TListOfTPrevisionSortie.Add(AObject: TPrevisionSortie): Integer;
begin
  Result := inherited Add(AObject);
end;

function TListOfTPrevisionSortie.GetItem(Index: Integer): TPrevisionSortie;
begin
  Result := TPrevisionSortie(inherited GetItem(Index));
end;

procedure TListOfTPrevisionSortie.Insert(Index: Integer; AObject: TPrevisionSortie);
begin
  inherited Insert(Index, AObject);
end;

{ TRecherche }

procedure TRecherche.Clear;
begin
  inherited;
  Resultats.Clear;
  TypeRecherche := trAucune;
end;

constructor TRecherche.Create;
begin
  inherited;
end;

procedure TRecherche.ClearCriteres;
begin
  Criteres.SousCriteres.Clear;
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
  end;

var
  Album: TAlbum;
  q: TJvUIBQuery;
  sWhere: string;
begin
  inherited Fill(GUID_NULL);

  q := TJvUIBQuery.Create(nil);
  slFrom := TStringList.Create;
  slFrom.Sorted := True;
  slFrom.Duplicates := dupIgnore;
  slFrom.Delimiter := ',';
  slWhere := TStringList.Create;
  with q do
  try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT DISTINCT ALBUMS.ID_Album, ALBUMS.TITREALBUM, ALBUMS.TOME, ALBUMS.TOMEDEBUT, ALBUMS.TOMEFIN, ALBUMS.HORSSERIE, ALBUMS.INTEGRALE, ALBUMS.MOISPARUTION, ALBUMS.ANNEEPARUTION, ALBUMS.ID_Serie, SERIES.TITRESERIE';

    slFrom.Add('ALBUMS');
    slFrom.Add('SERIES');
    slFrom.Add('EDITIONS');
    sWhere := ProcessCritere(Criteres);
    SQL.Add('FROM ' + ProcessTables);

    if sWhere <> '' then SQL.Add('WHERE ' + sWhere);

    SQL.Add('ORDER BY COALESCE(ALBUMS.UPPERTITREALBUM, SERIES.UPPERTITRESERIE), SERIES.UPPERTITRESERIE, ALBUMS.HORSSERIE NULLS FIRST, ALBUMS.INTEGRALE NULLS FIRST,');
    SQL.Add('ALBUMS.TOME NULLS FIRST, ALBUMS.TOMEDEBUT NULLS FIRST, ALBUMS.TOMEFIN NULLS FIRST, ALBUMS.ANNEEPARUTION NULLS FIRST, ALBUMS.MOISPARUTION NULLS FIRST');

    Open;
    while not EOF do
    begin
      Album := TAlbum.Create;
      Album.Fill(q);
      Resultats.Add(Album);
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
  ResultatsInfos.Free;
  Resultats.Free;
  Criteres.Free;
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
  q: TJvUIBQuery;
  s: string;
  Album: TAlbum;
  oldID_Album: TGUID;
  oldIndex: Integer;
begin
  inherited Fill(GUID_NULL);
  if not IsEqualGUID(ID, GUID_NULL) then
  begin
    q := TJvUIBQuery.Create(nil);
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
            case Fields.ByNameAsInteger['Metier'] of
              0: AjoutString(s, rsTransScenario, ', ');
              1: AjoutString(s, rsTransDessins, ', ');
              2: AjoutString(s, rsTransCouleurs, ', ');
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
            case Fields.ByNameAsInteger['Metier'] of
              0: oldIndex := ResultatsInfos.Add(rsTransScenario);
              1: oldIndex := ResultatsInfos.Add(rsTransDessins);
              2: oldIndex := ResultatsInfos.Add(rsTransCouleurs);
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
  Resultats := TListOfTAlbum.Create(True);
  ResultatsInfos := TStringList.Create;
  Criteres := TGroupCritere.Create(nil);
end;

function TRecherche.AddCritere(Parent: TGroupCritere): TCritere;
begin
  if not Assigned(Parent) then Parent := Criteres;
  Result := TCritere.Create(Parent);
  TypeRecherche := trAucune;
end;

function TRecherche.AddGroup(Parent: TGroupCritere): TGroupCritere;
begin
  if not Assigned(Parent) then Parent := Criteres;
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
  lvl, CritereType: Integer;
  str: string;
  ACritere, NextCritere: TBaseCritere;
begin
  ClearCriteres;
  Stream.Position := 0;

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

begin
  Stream.Size := 0;
  WriteCritere(Criteres);
  ProcessSousCriteres(Criteres);
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
  SousCriteres.Free;
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

end.

