unit LoadComplet;

interface

uses
  SysUtils, Windows, Classes, TypeRec, Commun, CommonConst, DM_Princ, JvUIB, DateUtils, Contnrs;

type
  TBaseComplet = class
  private
    procedure WriteString(Stream: TStream; const Chaine: string);
    procedure WriteStringLN(Stream: TStream; const Chaine: string);
  public
    RecInconnu: Boolean;

    procedure Fill(const Reference: TGUID); virtual;
    procedure BeforeDestruction; override;
    procedure Clear; virtual;

    constructor Create; overload; virtual;
    constructor Create(const Reference: TGUID); overload;

    procedure WriteXMLToStream(Stream: TStream); virtual;
  end;

  TSrcEmprunt = (seTous, seAlbum, seEmprunteur);
  TSensEmprunt = (ssTous, ssPret, ssRetour);

  TEmpruntsComplet = class(TBaseComplet)
    Emprunts: TList;
    NBEmprunts: Integer;

    procedure Fill(Reference: TGUID; Source: TSrcEmprunt = seTous; Sens: TSensEmprunt = ssTous; Apres: TDateTime = -1; Avant: TDateTime = -1; EnCours: Boolean = False; Stock: Boolean = False); reintroduce;
    procedure Clear; override;
    constructor Create; override;
    constructor Create(Reference: TGUID; Source: TSrcEmprunt = seTous; Sens: TSensEmprunt = ssTous; Apres: TDateTime = -1; Avant: TDateTime = -1; EnCours: Boolean = False; Stock: Boolean = False); reintroduce; overload;
    destructor Destroy; override;
  end;

  TEditeurComplet = class(TBaseComplet)
    ID_Editeur: TGUID;
    NomEditeur: string[50];
    SiteWeb: string[255];

    procedure Fill(const Reference: TGUID); override;
    procedure Clear; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TAuteurComplet = class(TBaseComplet)
    ID_Auteur: TGUID;
    NomAuteur: string[50];
    SiteWeb: string[255];
    Biographie: TStringList;
    Series: TObjectList;

    procedure Fill(const Reference: TGUID); override;
    procedure Clear; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TSerieComplete = class(TBaseComplet)
    ID_Serie: TGUID;
    Titre: string;
    Terminee: Integer;
    Albums, ParaBD: TList;
    Genres: TStringList;
    Sujet, Notes: TStringList;
    Editeur: TEditeurComplet;
    Collection: TCollection;
    SiteWeb: string[255];
    Scenaristes, Dessinateurs, Coloristes: TList;

    FIdAuteur: TGUID;

    procedure Fill(const Reference: TGUID); override;
    procedure Clear; override;
    constructor Create; override;
    constructor Create(const Reference, IdAuteur: TGUID); overload;
    destructor Destroy; override;
  end;

  TEditionComplete = class(TBaseComplet)
  private
    function Get_sDateAchat: string;
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
    Couvertures: TList;

    procedure Fill(const Reference: TGUID); override;
    procedure Clear; override;
    constructor Create; override;
    destructor Destroy; override;
  published
    property sDateAchat: string read Get_sDateAchat;
  end;

  TEditionsComplet = class(TBaseComplet)
    Editions: TList;

    procedure Fill(Reference: TGUID; Stock: Integer = -1); reintroduce;
    procedure Clear; override;
    constructor Create; override;
    constructor Create(Reference: TGUID; Stock: Integer = -1); reintroduce; overload;
    destructor Destroy; override;
  end;

  TAlbumComplet = class(TBaseComplet)
    ID_Album: TGUID;
    MoisParution, AnneeParution, Tome, TomeDebut, TomeFin: Integer;
    Titre: string[50];
    HorsSerie, Integrale: Boolean;
    Scenaristes, Dessinateurs, Coloristes: TList;
    Sujet, Notes: TStringList;
    Serie: TSerieComplete;
    Editions: TEditionsComplet;

    procedure Fill(const Reference: TGUID); override;
    procedure Clear; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TEmprunteurComplet = class(TBaseComplet)
    ID_Emprunteur: TGUID;
    Nom: string[100];
    Adresse: TStringList;
    Emprunts: TEmpruntsComplet;

    procedure Fill(const Reference: TGUID); override;
    procedure Clear; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TStats = class(TBaseComplet)
    Editeur: string;
    NbAlbums, NbSeries, NbSeriesTerminee,
      NbAlbumsNB, NbAlbumsVO, NbAlbumsStock, NbAlbumsIntegrale, NbAlbumsHorsSerie, NbAlbumsDedicace, NbAlbumsOffert, NbAlbumsGratuit,
      MinAnnee, MaxAnnee,
      NbEmprunteurs, MoyEmprunteurs, MinEmprunteurs, MaxEmprunteurs,
      NbEmpruntes, MoyEmpruntes, MinEmpruntes, MaxEmpruntes,
      NbAlbumsSansPrix: Integer;
    ValeurConnue, ValeurEstimee,
      PrixAlbumMinimun, PrixAlbumMoyen, PrixAlbumMaximun: Currency;
    ListAlbumsMin, ListEmprunteursMin,
      ListAlbumsMax, ListEmprunteursMax,
      ListGenre: TList;
    ListEditeurs: TList;

    procedure Fill(Complete: Boolean); reintroduce;
    procedure Clear; override;
    constructor Create; override;
    constructor Create(Complete: Boolean); reintroduce; overload;
    destructor Destroy; override;

  private
    procedure CreateStats(var Stats: TStats); overload;
    procedure CreateStats(var Stats: TStats; ID_Editeur: TGUID; Editeur: string); overload;
  end;

  TSerieIncomplete = class
    Serie: TSerie;
    NumerosManquants: TStringList;

    constructor Create;
    destructor Destroy; override;
    function ChaineAffichage: string;
  end;

  TSeriesIncompletes = class(TBaseComplet)
    Series: TObjectList;

    procedure Fill(const Reference: TGUID); overload; override;
    procedure Fill(AvecIntegrales, AvecAchats: Boolean; ID_Serie: TGUID); reintroduce; overload;
    procedure Clear; override;
    constructor Create; override;
    constructor Create(AvecIntegrales, AvecAchats: Boolean); reintroduce; overload;
    destructor Destroy; override;
  end;

  TPrevisionSortie = class
    Serie: TSerie;
    Tome, Annee, Mois: Integer;

    constructor Create;
    destructor Destroy; override;
    function sAnnee: string;
  end;

  TPrevisionsSorties = class(TBaseComplet)
    AnneesPassees: TObjectList;
    AnneeEnCours: TObjectList;
    AnneesProchaines: TObjectList;

    procedure Fill(const Reference: TGUID); overload; override;
    procedure Fill(AvecAchats: Boolean); reintroduce; overload;
    procedure Fill(AvecAchats: Boolean; ID_Serie: TGUID); reintroduce; overload;
    procedure Clear; override;
    constructor Create; override;
    constructor Create(AvecAchats: Boolean); reintroduce; overload;
    destructor Destroy; override;
  end;

  TParaBDComplet = class(TBaseComplet)
    ID_ParaBD: TGUID;
    AnneeEdition, CategorieParaBD, AnneeCote: Integer;
    Titre: string[50];
    sCategorieParaBD: string;
    Auteurs: TList;
    Description: TStringList;
    Serie: TSerieComplete;

    Prix, PrixCote: Currency;
    Dedicace, Numerote, Stock, Offert, Gratuit, HasImage: Boolean;
    DateAchat: TDateTime;

    procedure Fill(const Reference: TGUID); override;
    procedure Clear; override;
    constructor Create; override;
    destructor Destroy; override;
  private
    function Get_sDateAchat: string;
  published
    property sDateAchat: string read Get_sDateAchat;
  end;

implementation

uses JvUIBLib, Divers;

{ TBaseComplet }

procedure TBaseComplet.BeforeDestruction;
begin
  inherited;
  Clear;
end;

procedure TBaseComplet.Clear;
begin
  // nettoyage de toutes les listes et autres
  RecInconnu := True;
end;

constructor TBaseComplet.Create(const Reference: TGUID);
begin
  Create;
  Fill(Reference);
end;

constructor TBaseComplet.Create;
begin

end;

procedure TBaseComplet.Fill(const Reference: TGUID);
begin
  Clear;
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

procedure TAlbumComplet.Clear;
begin
  inherited;
  ID_Album := GUID_NULL;
  Titre := '';

  TAuteur.VideListe(Scenaristes);
  TAuteur.VideListe(Dessinateurs);
  TAuteur.VideListe(Coloristes);

  Sujet.Clear;
  Notes.Clear;
  Serie.Clear;
  Editions.Clear;
end;

constructor TAlbumComplet.Create;
begin
  Scenaristes := TList.Create;
  Dessinateurs := TList.Create;
  Coloristes := TList.Create;
  Sujet := TStringList.Create;
  Notes := TStringList.Create;
  Serie := TSerieComplete.Create;
  Editions := TEditionsComplet.Create;
end;

destructor TAlbumComplet.Destroy;
begin
  FreeAndNil(Scenaristes);
  FreeAndNil(Dessinateurs);
  FreeAndNil(Coloristes);

  Sujet.Free;
  Notes.Free;
  Serie.Free;
  Editions.Free;
  inherited;
end;

procedure TAlbumComplet.Fill(const Reference: TGUID);
var
  serie: TGUID;
  q: TJvUIBQuery;
begin
  inherited;
  if IsEqualGUID(Reference, GUID_NULL) then Exit;
  Self.ID_Album := Reference;
  q := TJvUIBQuery.Create(nil);
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    FetchBlobs := True;
    SQL.Text := 'SELECT TITREALBUM, MOISPARUTION, ANNEEPARUTION, ID_Serie, TOME, TOMEDEBUT, TOMEFIN, SUJETALBUM, REMARQUESALBUM, HORSSERIE, INTEGRALE FROM ALBUMS WHERE ID_Album = ?';
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

    serie := StringToGUID(Fields.ByNameAsString['ID_SERIE']);

    Close;
    SQL.Text := 'SELECT * FROM PROC_AUTEURS(?, NULL, NULL)';
    Params.AsString[0] := GUIDToString(Reference);
    Open;
    while not Eof do begin
      case Fields.ByNameAsInteger['Metier'] of
        0: Self.Scenaristes.Add(TAuteur.Make(q));
        1: Self.Dessinateurs.Add(TAuteur.Make(q));
        2: Self.Coloristes.Add(TAuteur.Make(q));
      end;
      Next;
    end;

    Self.Serie.Fill(serie);

    Self.Editions.Fill(Self.ID_Album);
  finally
    q.Transaction.Free;
    q.Free;
  end;
end;

{ TEditionComplete }

constructor TEditionComplete.Create;
begin
  Editeur := TEditeurComplet.Create;
  Collection := TCollection.Create;
  Emprunts := TEmpruntsComplet.Create;
  Couvertures := TList.Create;
  Notes := TStringList.Create;
end;

procedure TEditionComplete.Clear;
begin
  inherited;
  ID_Edition := GUID_NULL;
  Editeur.Clear;
  Collection.Clear;
  Emprunts.Clear;
  TCouverture.VideListe(Couvertures);
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
  q := TJvUIBQuery.Create(nil);
  with q do try
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

    Self.ID_Edition := StringToGUID(Fields.ByNameAsString['ID_EDITION']);
    Self.ID_Album := StringToGUID(Fields.ByNameAsString['ID_Album']);
    Self.Editeur.Fill(StringToGUID(Fields.ByNameAsString['ID_EDITEUR']));
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
    while not Eof do begin
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

{ TEditionsComplet }

procedure TEditionsComplet.Clear;
begin
  inherited;
  TEdition.VideListe(Editions);
end;

constructor TEditionsComplet.Create;
begin
  inherited;
  Editions := TList.Create;
end;

constructor TEditionsComplet.Create(Reference: TGUID; Stock: Integer);
begin
  Create;
  Fill(Reference, Stock);
end;

destructor TEditionsComplet.Destroy;
begin
  Editions.Free;
  inherited;
end;

procedure TEditionsComplet.Fill(Reference: TGUID; Stock: Integer = -1);
var
  q: TJvUIBQuery;
begin
  inherited Fill(Reference);
  q := TJvUIBQuery.Create(nil);
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT ID_Edition, e.ID_Editeur, ed.nomediteur, e.ID_Collection, c.nomcollection, ANNEEEDITION, ISBN';
    SQL.Add('FROM EDITIONS e LEFT JOIN editeurs ed on e.ID_Editeur = ed.ID_Editeur LEFT JOIN collections c on e.ID_Collection = c.ID_Collection');
    SQL.Add('WHERE ID_Album = ?');
    if Stock in [0, 1] then SQL.Add('AND e.STOCK = :Stock');
    Params.AsString[0] := GUIDToString(Reference);
    if Stock in [0, 1] then Params.AsInteger[1] := Stock;
    Open;
    while not Eof do begin
      Editions.Add(TEdition.Make(q));
      Next;
    end;
  finally
    q.Transaction.Free;
    q.Free;
  end;
end;

{ TEmprunteurComplet }

procedure TEmprunteurComplet.Clear;
begin
  inherited;
  ID_Emprunteur := GUID_NULL;
  Nom := '';
  Adresse.Clear;
  Emprunts.Clear;
end;

constructor TEmprunteurComplet.Create;
begin
  inherited;
  Adresse := TStringList.Create;
  Emprunts := TEmpruntsComplet.Create;
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
  with q do try
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

{ TSerieComplete }

procedure TSerieComplete.Clear;
begin
  inherited;
  ID_Serie := GUID_NULL;
  Titre := '';
  TAlbum.VideListe(Albums);
  TParaBD.VideListe(ParaBD);
  Genres.Clear;
  Sujet.Clear;
  Notes.Clear;
  Editeur.Clear;
  Collection.Clear;
  TAuteur.VideListe(Scenaristes);
  TAuteur.VideListe(Dessinateurs);
  TAuteur.VideListe(Coloristes);
end;

constructor TSerieComplete.Create;
begin
  inherited;
  FIdAuteur := GUID_NULL;
  Albums := TList.Create;
  ParaBD := TList.Create;
  Genres := TStringList.Create;
  Sujet := TStringList.Create;
  Notes := TStringList.Create;
  Editeur := TEditeurComplet.Create;
  Collection := TCollection.Create;
  Scenaristes := TList.Create;
  Dessinateurs := TList.Create;
  Coloristes := TList.Create;
end;

constructor TSerieComplete.Create(const Reference, IdAuteur: TGUID);
begin
  Create;
  FIdAuteur := IdAuteur;
  Fill(Reference);
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
  if IsEqualGUID(Reference, GUID_NULL) then Exit;
  Self.ID_Serie := Reference;
  q := TJvUIBQuery.Create(nil);
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    FetchBlobs := True;
    SQL.Text := 'SELECT TITRESERIE, TERMINEE, SUJETSERIE, REMARQUESSERIE, SITEWEB, S.ID_Editeur, S.ID_Collection, NOMCOLLECTION '
      + 'FROM SERIES S LEFT JOIN COLLECTIONS C ON S.ID_Collection = C.ID_Collection '
      + 'WHERE ID_Serie = ?';
    Params.AsString[0] := GUIDToString(Reference);
    Open;
    RecInconnu := Eof;
    Self.Titre := FormatTitre(Fields.ByNameAsString['TITRESERIE']);
    if Fields.ByNameIsNull['TERMINEE'] then
      Self.Terminee := -1
    else
      Self.Terminee := Fields.ByNameAsInteger['TERMINEE'];
    Self.Sujet.Text := Fields.ByNameAsString['SUJETSERIE'];
    Self.Notes.Text := Fields.ByNameAsString['REMARQUESSERIE'];
    Self.SiteWeb := Trim(Fields.ByNameAsString['SITEWEB']);
    Self.Editeur.Fill(StringToGUID(Fields.ByNameAsString['ID_EDITEUR']));
    Self.Collection.Fill(q);
    FetchBlobs := False;

    Close;
    SQL.Text := 'SELECT ID_Album, TITREALBUM, INTEGRALE, HORSSERIE, TOME, TOMEDEBUT, TOMEFIN, ID_Serie '
      + 'FROM ALBUMS '
      + 'WHERE ID_Serie = ? ';
    if not IsEqualGUID(FIdAuteur, GUID_NULL) then
      SQL.Text := SQL.Text
        + 'AND ID_Album IN (SELECT ID_Album FROM AUTEURS WHERE ID_Personne = ?) ';
    SQL.Text := SQL.Text
      + 'ORDER BY HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST';
    Params.AsString[0] := GUIDToString(Reference);
    if not IsEqualGUID(FIdAuteur, GUID_NULL) then
      Params.AsString[1] := GUIDToString(FIdAuteur);
    Open;
    while not Eof do begin
      Self.Albums.Add(TAlbum.Make(q));
      Next;
    end;

    Close;
    SQL.Text := 'SELECT ID_ParaBD, TITREPARABD, ID_Serie, TITRESERIE, ACHAT, COMPLET, SCATEGORIE '
      + 'FROM VW_LISTE_PARABD '
      + 'WHERE ID_Serie = ? ';
    if not IsEqualGUID(FIdAuteur, GUID_NULL) then
      SQL.Text := SQL.Text
        + 'AND ID_ParaBD IN (SELECT ID_ParaBD FROM AUTEURS_PARABD WHERE ID_Personne = ?) ';
    SQL.Text := SQL.Text
      + 'ORDER BY TITREPARABD';
    Params.AsString[0] := GUIDToString(Reference);
    if not IsEqualGUID(FIdAuteur, GUID_NULL) then
      Params.AsString[1] := GUIDToString(FIdAuteur);
    Open;
    while not Eof do begin
      Self.ParaBD.Add(TParaBD.Make(q));
      Next;
    end;

    Close;
    SQL.Text := 'SELECT Genre '
      + 'FROM GenreSeries s INNER JOIN Genres g ON g.ID_Genre = s.ID_Genre '
      + 'WHERE ID_Serie = ?';
    Params.AsString[0] := GUIDToString(Reference);
    Open;
    while not Eof do begin
      Self.Genres.Add(Fields.AsString[0]);
      Next;
    end;

    Close;
    SQL.Text := 'SELECT * FROM PROC_AUTEURS(NULL, ?, NULL)';
    Params.AsString[0] := GUIDToString(Reference);
    Open;
    while not Eof do begin
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

{ TEditeurComplet }

procedure TEditeurComplet.Clear;
begin
  inherited;
  ID_Editeur := GUID_NULL;
  NomEditeur := '';
  SiteWeb := '';
end;

constructor TEditeurComplet.Create;
begin
  inherited;

end;

destructor TEditeurComplet.Destroy;
begin

  inherited;
end;

procedure TEditeurComplet.Fill(const Reference: TGUID);
var
  q: TJvUIBQuery;
begin
  inherited;
  if IsEqualGUID(Reference, GUID_NULL) then Exit;
  Self.ID_Editeur := Reference;
  q := TJvUIBQuery.Create(nil);
  with q do try
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

{ TStats }

procedure TStats.Clear;
var
  i: Integer;
begin
  inherited;
  TEmprunteur.VideListe(ListEmprunteursMax);
  TEmprunteur.VideListe(ListEmprunteursMin);
  TAlbum.VideListe(ListAlbumsMax);
  TAlbum.VideListe(ListAlbumsMin);
  TGenre.VideListe(ListGenre);
  for i := 0 to Pred(ListEditeurs.Count) do
    TStats(ListEditeurs[i]).Free;
  ListEditeurs.Clear;
end;

constructor TStats.Create;
begin
  inherited;
  ListEmprunteursMax := TList.Create;
  ListAlbumsMax := TList.Create;
  ListEmprunteursMin := TList.Create;
  ListAlbumsMin := TList.Create;
  ListGenre := TList.Create;
  ListEditeurs := TList.Create;
end;

constructor TStats.Create(Complete: Boolean);
begin
  Create;
  Fill(Complete);
end;

procedure TStats.CreateStats(var Stats: TStats);
begin
  CreateStats(Stats, GUID_NULL, '');
end;

procedure TStats.CreateStats(var Stats: TStats; ID_Editeur: TGUID; Editeur: string);
var
  q: TJvUIBQuery;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  Stats.Editeur := Editeur;
  q := TJvUIBQuery.Create(nil);
  with q do try
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
    SQL.Add('inner join Series s on a.ID_Serie = s.ID_Serie');
    SQL.Add('');
    SQL[3] := 'WHERE s.Terminee = 1'; Open; Stats.NbSeriesTerminee := Fields.AsInteger[0]; Close;

    SQL.Text := 'SELECT Min(a.AnneeParution) AS MinAnnee, Max(a.AnneeParution) AS MaxAnnee FROM Albums a';
    if not IsEqualGUID(ID_Editeur, GUID_NULL) then SQL.Add('INNER JOIN Editions e ON e.ID_Album = a.ID_Album and e.ID_Editeur=' + QuotedStr(GUIDToString(ID_Editeur)));
    Open;
    Stats.MinAnnee := 0;
    Stats.MaxAnnee := 0;
    if not EOF then begin
      Stats.MinAnnee := Fields.ByNameAsInteger['MinAnnee'];
      Stats.MaxAnnee := Fields.ByNameAsInteger['MaxAnnee'];
    end;

    Close;
    SQL.Text := 'SELECT COUNT(g.ID_Genre) AS QuantiteGenre, g.ID_Genre, g.Genre, g.UpperGenre FROM GenreSeries gs INNER JOIN Genres g ON gs.ID_Genre = g.ID_Genre';
    if not IsEqualGUID(ID_Editeur, GUID_NULL) then begin
      SQL.Add('INNER JOIN Albums a ON a.ID_Serie = gs.ID_Serie');
      SQL.Add('INNER JOIN Editions e ON e.ID_Album = a.ID_Album and e.ID_Editeur=' + QuotedStr(GUIDToString(ID_Editeur)));
    end;
    SQL.Add('GROUP BY g.Genre, g.ID_Genre, g.UpperGenre ORDER BY 1 desc, g.UpperGenre');
    Open;
    while not (EOF) do begin
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
    if not EOF and Fields.ByNameAsBoolean['CountPrix'] then begin
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
    if Bool(Stats.NbEmprunteurs) then begin
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
    if not EOF then begin
      Stats.MaxEmprunteurs := Fields.ByNameAsInteger['CountNumero'];
      while not Eof do
        Next; // Last;
      Stats.MinEmprunteurs := Fields.ByNameAsInteger['CountNumero'];
      if Stats.MinEmprunteurs = Stats.MaxEmprunteurs then Stats.MinEmprunteurs := 0;
      Close;
      Open;
      repeat
        if Fields.ByNameAsInteger['CountNumero'] in [Stats.MinEmprunteurs, Stats.MaxEmprunteurs] then begin
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
    if Bool(Stats.NbEmpruntes) then begin
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
    if not EOF then begin
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
      while not Eof do begin
        Stats.ListAlbumsMax.Insert(0, TAlbum.Make(Q));
        Next;
      end;
      if (Stats.MinEmpruntes > 0) and (Stats.MinEmpruntes <> Stats.MaxEmpruntes) then begin
        Close;
        Params.AsInteger[0] := Stats.MinEmpruntes;
        Open;
        while not Eof do begin
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
  if Complete then begin
    q := TJvUIBQuery.Create(nil);
    with q do try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      Close;
      SQL.Clear;
      SQL.Add('SELECT DISTINCT ed.ID_Editeur, e.NomEditeur FROM Editions ed');
      SQL.Add('INNER JOIN Editeurs e ON ed.ID_Editeur = e.ID_Editeur');
      SQL.Add('ORDER BY e.UpperNomEditeur');
      Open;
      while not Eof do begin
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

{ TEmpruntsComplet }

procedure TEmpruntsComplet.Clear;
begin
  inherited;
  NBEmprunts := 0;
  TEmprunt.VideListe(Emprunts);
end;

constructor TEmpruntsComplet.Create;
begin
  inherited;
  Emprunts := TList.Create;
end;

constructor TEmpruntsComplet.Create(Reference: TGUID; Source: TSrcEmprunt; Sens: TSensEmprunt; Apres, Avant: TDateTime; EnCours, Stock: Boolean);
begin
  Create;
  Fill(Reference, Source, Sens, Apres, Avant, EnCours, Stock);
end;

destructor TEmpruntsComplet.Destroy;
begin
  Emprunts.Free;
  inherited;
end;

procedure TEmpruntsComplet.Fill(Reference: TGUID; Source: TSrcEmprunt; Sens: TSensEmprunt; Apres, Avant: TDateTime; EnCours, Stock: Boolean);
var
  q: TJvUIBQuery;

  procedure MakeQuery;
  var
    i: Integer;
  begin
    q.SQL.Text := 'SELECT * FROM VW_EMPRUNTS';

    with TStringList.Create do try
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

      for i := 0 to Count - 1 do begin
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
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    s := TStringList.Create;
    Self.NBEmprunts := 0;
    try
      MakeQuery;
      Open;
      s.Clear;
      while not Eof do begin
        Ref := Fields.ByNameAsString['ID_Edition'];
        if not Stock or (s.IndexOf(Ref) = -1) then begin
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

{ TSeriesIncompletes }

procedure TSeriesIncompletes.Clear;
begin
  inherited;
  Series.Clear;
end;

constructor TSeriesIncompletes.Create;
begin
  inherited;
  Series := TObjectList.Create(True);
end;

constructor TSeriesIncompletes.Create(AvecIntegrales, AvecAchats: Boolean);
begin
  Create;
  Fill(AvecIntegrales, AvecAchats, GUID_NULL);
end;

destructor TSeriesIncompletes.Destroy;
begin

  inherited;
end;

procedure TSeriesIncompletes.Fill(AvecIntegrales, AvecAchats: Boolean; ID_Serie: TGUID);
var
  q: TJvUIBQuery;
  CurrentSerie, dummy: TGUID;
  iDummy, FirstTome, CurrentTome: Integer;

  procedure UpdateSerie;
  var
    i: Integer;
  begin
    with TSerieIncomplete(Self.Series[Pred(Self.Series.Count)]) do
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
  with q do try
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
    while not Eof do begin
      dummy := StringToGUID(Fields.ByNameAsString['ID_Serie']);
      if not IsEqualGUID(dummy, CurrentSerie) then begin
        if not IsEqualGUID(CurrentSerie, GUID_NULL) then UpdateSerie;
        Incomplete := TSerieIncomplete.Create;
        Self.Series.Add(Incomplete);
        Incomplete.Serie.Fill(q);
        CurrentSerie := dummy;
        FirstTome := Fields.ByNameAsInteger['TOME'];
        CurrentTome := FirstTome;
      end
      else begin
        iDummy := Fields.ByNameAsInteger['TOME'];
        if iDummy <> CurrentTome + 1 then begin
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

{ TPrevisionsSorties }

procedure TPrevisionsSorties.Clear;
begin
  inherited;
  AnneesPassees.Clear;
  AnneeEnCours.Clear;
  AnneesProchaines.Clear;
end;

constructor TPrevisionsSorties.Create;
begin
  inherited;
  AnneesPassees := TObjectList.Create(True);
  AnneeEnCours := TObjectList.Create(True);
  AnneesProchaines := TObjectList.Create(True);
end;

constructor TPrevisionsSorties.Create(AvecAchats: Boolean);
begin
  Create;
  Fill(AvecAchats);
end;

destructor TPrevisionsSorties.Destroy;
begin
  AnneesPassees.Free;
  AnneeEnCours.Free;
  AnneesProchaines.Free;
  inherited;
end;

procedure TPrevisionsSorties.Fill(AvecAchats: Boolean; ID_Serie: TGUID);
var
  q: TJvUIBQuery;
  Annee, CurrentAnnee: Integer;
  Prevision: TPrevisionSortie;
begin
  inherited Fill(GUID_NULL);
  CurrentAnnee := YearOf(Now);
  q := TJvUIBQuery.Create(nil);
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT * FROM PREVISIONS_SORTIES(:WithAchats, :ID_Serie) order by ANNEEPARUTION, CASE WHEN MOISPARUTION BETWEEN 1 AND 4 THEN 1 WHEN MOISPARUTION BETWEEN 5 AND 8 THEN 2 WHEN MOISPARUTION BETWEEN 9 AND 12 THEN 3 ELSE 0 END, UPPERTITRESERIE';
    Params.AsBoolean[0] := AvecAchats;
    if not IsEqualGUID(ID_Serie, GUID_NULL) then
      Params.AsString[1] := GUIDToString(ID_Serie);
    Open;
    while not Eof do begin
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

{ TPrevisionSortie }

constructor TPrevisionSortie.Create;
begin
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
  for i := 0 to NumerosManquants.Count - 1 do begin
    s := NumerosManquants[i];
    if Pos('<>', s) <> 0 then s := StringReplace(s, '<>', ' à ', []);
    AjoutString(Result, s, ', ');
  end;
end;

constructor TSerieIncomplete.Create;
begin
  NumerosManquants := TStringList.Create;
  Serie := TSerie.Create;
end;

destructor TSerieIncomplete.Destroy;
begin
  Serie.Free;
  NumerosManquants.Free;
  inherited;
end;

{ TAuteurComplet }

procedure TAuteurComplet.Clear;
begin
  inherited;
  Series.Clear;
end;

constructor TAuteurComplet.Create;
begin
  inherited;
  Series := TObjectList.Create(True);
  Biographie := TStringList.Create;
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
  with q do try
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
    SQL.Add('SELECT UPPERTITRESERIE, s.ID_Serie');
    SQL.Add('FROM ALBUMS al');
    SQL.Add('  INNER JOIN AUTEURS au ON al.ID_Album = au.ID_Album AND au.ID_Personne = :ID_Personne');
    SQL.Add('  INNER JOIN SERIES s ON s.ID_Serie = al.ID_Serie');
    SQL.Add('union');
    SQL.Add('SELECT UPPERTITRESERIE, s.ID_Serie');
    SQL.Add('FROM auteurs_series au');
    SQL.Add('  INNER JOIN SERIES s ON s.ID_Serie = au.ID_Serie AND au.ID_Personne = :ID_Personne');
    SQL.Add('union');
    SQL.Add('SELECT UPPERTITRESERIE, s.ID_Serie');
    SQL.Add('FROM auteurs_parabd ap');
    SQL.Add('  INNER JOIN PARABD p ON ap.ID_PARABD = p.ID_PARABD and ap.ID_Personne = :ID_Personne');
    SQL.Add('  INNER JOIN SERIES s ON s.ID_Serie = p.ID_Serie ');
    Params.ByNameAsString['ID_Personne'] := GUIDToString(Reference);
    Open;
    while not Eof do begin
      Series.Add(TSerieComplete.Create(StringToGUID(Fields.AsString[1]), Self.ID_Auteur));
      Next;
    end;
  finally
    q.Transaction.Free;
    q.Free;
  end;
end;

{ TParaBDComplet }

procedure TParaBDComplet.Clear;
begin
  inherited;
  ID_ParaBD := GUID_NULL;
  Titre := '';

  TAuteur.VideListe(Auteurs);

  Description.Clear;
  Serie.Clear;
end;

constructor TParaBDComplet.Create;
begin
  inherited;
  Description := TStringList.Create;
  Auteurs := TList.Create;
  Serie := TSerieComplete.Create;
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
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    FetchBlobs := True;
    SQL.Text := 'SELECT TITREPARABD, ANNEE, ID_Serie, ACHAT, DESCRIPTION, DEDICACE, NUMEROTE, ANNEECOTE, PRIXCOTE, GRATUIT, OFFERT, DATEACHAT, PRIX, STOCK, CATEGORIEPARABD, lc.Libelle AS sCATEGORIEPARABD, FICHIERPARABD';
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
    Self.HasImage := not Fields.ByNameIsNull['FICHIERPARABD'];

    serie := StringToGUID(Fields.ByNameAsString['ID_SERIE']);

    Close;
    SQL.Text := 'SELECT * FROM PROC_AUTEURS(NULL, NULL, ?)';
    Params.AsString[0] := GUIDToString(Reference);
    Open;
    while not Eof do begin
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

end.

