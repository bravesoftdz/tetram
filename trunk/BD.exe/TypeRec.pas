unit TypeRec;

interface

uses
  Windows, SysUtils, DB, Classes, ComCtrls, UIB, StdCtrls, Commun, UMetaData;

//  IMPORTANT: Ref doit TOUJOURS être le premier champ des records
//  Les strings DOIVENT être limités pour pouvoir utiliser CopyMemory(Pd, Ps, SizeOf(Ps^));

type
  TEditionsEmpruntees = array of array[0..1] of TGUID;

  TBasePointeur = class(TObject)
  private
    class function NonNull(Query: TUIBQuery; const Champ: string; Default: Integer): Integer; overload;
    class function NonNull(Query: TUIBQuery; const Champ: string): TGUID; overload;

  public
    ID: TGUID;

    procedure Assign(Ps: TBasePointeur); virtual;

    procedure AfterConstruction; override;
    constructor Create; virtual;

    class function Duplicate(Ps: TBasePointeur): TBasePointeur;
    class function Make(Query: TUIBQuery): TBasePointeur;
    class procedure VideListe(LV: TListView; DoClear: Boolean = True); overload;
    class procedure VideListe(List: TList; DoClear: Boolean = True); overload;
    class procedure VideListe(ListBox: TListBox; DoClear: Boolean = True); overload;

    procedure Clear; virtual;
    procedure Fill(Query: TUIBQuery); virtual; abstract;
    function ChaineAffichage(dummy: Boolean = True): string; virtual; abstract;
  end;

  TCouverture = class(TBasePointeur)
  public
    OldNom, NewNom: string{[255]};
    OldStockee, NewStockee: Boolean;
    Categorie: Smallint;
    sCategorie: string{[50]};

    procedure Assign(Ps: TBasePointeur); override;

    procedure Fill(Query: TUIBQuery); override;
    function ChaineAffichage(dummy: Boolean = True): string; override;

    class function Make(Query: TUIBQuery): TCouverture;
  end;

  TParaBD = class(TBasePointeur)
  public
    Titre: string{[150]};
    ID_Serie: TGUID;
    Serie: string{[150]};
    sCategorie: string{[50]};
    Achat: Boolean;
    Complet: Boolean;

    procedure Assign(Ps: TBasePointeur); override;

    procedure Fill(Query: TUIBQuery); override;
    function ChaineAffichage(AvecSerie: Boolean): string; overload; override;
    function ChaineAffichage(Simple: Boolean; AvecSerie: Boolean): string; reintroduce; overload;

    class function Make(Query: TUIBQuery): TParaBD;
  end;

  TPersonnage = class(TBasePointeur)
  public
    Nom: string{[150]};

    procedure Assign(Ps: TBasePointeur); override;

    procedure Fill(Query: TUIBQuery); override;
    function ChaineAffichage(dummy: Boolean = True): string; override;
    procedure Clear; override;
  end;

  TAuteur = class(TBasePointeur)
  public
    Personne: TPersonnage;
    ID_Album, ID_Serie: TGUID;
    Metier: TMetierAuteur;

    procedure Assign(Ps: TBasePointeur); override;

    constructor Create; override;
    destructor Destroy; override;

    procedure Fill(Query: TUIBQuery); overload; override;
    procedure Fill(Pe: TPersonnage; const ReferenceAlbum, ReferenceSerie: TGUID; Metier: TMetierAuteur); reintroduce; overload;
    procedure Clear; override;
    function ChaineAffichage(dummy: Boolean = True): string; override;

    class function Make(Query: TUIBQuery): TAuteur;
  end;

  TEditeur = class(TBasePointeur)
  public
    NomEditeur: string{[50]};

    procedure Assign(Ps: TBasePointeur); override;

    procedure Fill(const ID_Editeur: TGUID); reintroduce; overload;
    procedure Fill(Query: TUIBQuery); overload; override;
    function ChaineAffichage(dummy: Boolean = True): string; override;
    procedure Clear; override;
    class function Duplicate(Ps: TEditeur): TEditeur; reintroduce;
  end;

  TAlbum = class(TBasePointeur)
  public
    Tome: Integer;
    TomeDebut: Integer;
    TomeFin: Integer;
    Titre: string{[150]};
    ID_Serie: TGUID;
    Serie: string{[150]};
    ID_Editeur: TGUID;
    Editeur: string{[50]};
    AnneeParution, MoisParution: Integer;
    Stock: Boolean;
    Integrale: Boolean;
    HorsSerie: Boolean;
    Achat: Boolean;
    Complet: Boolean;

    procedure Assign(Ps: TBasePointeur); override;

    procedure Fill(Query: TUIBQuery); overload; override;
    procedure Fill(const ID_Album: TGUID); reintroduce; overload;
    procedure Fill(const ID_Album, ID_Edition: TGUID); reintroduce; overload;
    function ChaineAffichage(AvecSerie: Boolean): string; overload; override;
    function ChaineAffichage(Simple, AvecSerie: Boolean): string; reintroduce; overload;
    class function Duplicate(Ps: TAlbum): TAlbum; reintroduce;
    class function Make(Query: TUIBQuery): TAlbum; reintroduce;
  end;

  TCollection = class(TBasePointeur)
  public
    NomCollection: string{[50]};
    Editeur: TEditeur;

    procedure Assign(Ps: TBasePointeur); override;

    constructor Create; override;
    destructor Destroy; override;

    procedure Fill(Query: TUIBQuery); overload; override;
    procedure Fill(const ID_Collection: TGUID); reintroduce; overload;
    function ChaineAffichage(dummy: Boolean = True): string; override;
    procedure Clear; override;
    class function Duplicate(Ps: TCollection): TCollection; reintroduce;
  end;

  TSerie = class(TBasePointeur)
  public
    TitreSerie: string{[150]};
    Editeur: TEditeur;
    Collection: TCollection;

    procedure Assign(Ps: TBasePointeur); override;

    constructor Create; override;
    destructor Destroy; override;

    procedure Fill(Query: TUIBQuery); overload; override;
    procedure Fill(const ID_Serie: TGUID); reintroduce; overload;
    function ChaineAffichage(Simple: Boolean): string; override;
    procedure Clear; override;
    class function Duplicate(Ps: TSerie): TSerie; reintroduce;
  end;

  TEdition = class(TBasePointeur)
  public
    AnneeEdition: Integer;
    ISBN: string{[17]};
    Editeur: TEditeur;
    Collection: TCollection;

    procedure Assign(Ps: TBasePointeur); override;

    constructor Create; override;
    destructor Destroy; override;

    procedure Fill(Query: TUIBQuery); override;
    function ChaineAffichage(dummy: Boolean = True): string; override;
    procedure Clear; override;
    class function Duplicate(Ps: TEdition): TEdition;
  end;

  TEmprunteur = class(TBasePointeur)
  public
    Nom: string{[100]};

    procedure Assign(Ps: TBasePointeur); override;

    procedure Fill(Query: TUIBQuery); overload; override;
    procedure Fill(const ID_Emprunteur: TGUID); reintroduce; overload;
    function ChaineAffichage(dummy: Boolean = True): string; override;
    procedure Clear; override;
    class function Duplicate(Ps: TEmprunteur): TEmprunteur;
    class function Make(Query: TUIBQuery): TEmprunteur;
  end;

  TConversion = class(TBasePointeur)
    Monnaie1, Monnaie2: string{[5]};
    Taux: Double;

    procedure Fill(Query: TUIBQuery); override;
    function ChaineAffichage(dummy: Boolean = True): string; override;
  end;

  TGenre = class(TBasePointeur)
  public
    Genre: string{[50]};
    Quantite: Integer;

    procedure Assign(Ps: TBasePointeur); override;

    procedure Fill(Query: TUIBQuery); override;
    function ChaineAffichage(dummy: Boolean = True): string; override;
    procedure Clear; override;

    class function Make(Query: TUIBQuery): TGenre;
  end;

  TEmprunt = class(TBasePointeur)
  public
    Emprunteur: TEmprunteur;
    Album: TAlbum;
    Edition: TEdition;
    Date: TDateTime;
    Pret: Boolean;

    procedure Assign(Ps: TBasePointeur); override;

    constructor Create; override;
    destructor Destroy; override;

    procedure Fill(Query: TUIBQuery); override;
    function ChaineAffichage(dummy: Boolean = True): string; override;
    procedure Clear; override;
    class function Duplicate(Ps: TEmprunt): TEmprunt;
  end;

implementation

uses DM_Princ, UIBLib, StrUtils;

{ TBasePointeur }

procedure TBasePointeur.AfterConstruction;
begin
  inherited;
  Clear;
end;

procedure TBasePointeur.Assign(Ps: TBasePointeur);
begin
  ID := Ps.ID;
end;

class function TBasePointeur.Duplicate(Ps: TBasePointeur): TBasePointeur;
begin
  Result := Create;
  Result.Assign(Ps);
end;

procedure TBasePointeur.Clear;
begin
  ID := GUID_NULL;
end;

class function TBasePointeur.Make(Query: TUIBQuery): TBasePointeur;
begin
  Result := Self.Create;
  Result.Fill(Query);
end;

class procedure TBasePointeur.VideListe(LV: TListView; DoClear: Boolean = True);
var
  i: Integer;
begin
  LV.Items.BeginUpdate;
  try
    for i := LV.Items.Count - 1 downto 0 do
    begin
      TBasePointeur(LV.Items[i].Data).Free;
      LV.Items.Delete(i);
    end;
  finally
    if DoClear then LV.Items.Clear;
    LV.Items.EndUpdate;
  end;
end;

class procedure TBasePointeur.VideListe(List: TList; DoClear: Boolean = True);
var
  i: Integer;
begin
  try
    for i := 0 to Pred(List.Count) do
    begin
      TBasePointeur(List[i]).Free;
    end;
  finally
    if DoClear then List.Clear;
  end;
end;

class procedure TBasePointeur.VideListe(ListBox: TListBox; DoClear: Boolean = True);
var
  i: Integer;
begin
  try
    for i := 0 to Pred(ListBox.Items.Count) do
    begin
      ListBox.Items.Objects[i].Free;
    end;
  finally
    if DoClear then ListBox.Items.Clear;
  end;
end;

constructor TBasePointeur.Create;
begin
  inherited;
  ID := GUID_NULL;
end;

class function TBasePointeur.NonNull(Query: TUIBQuery; const Champ: string; Default: Integer): Integer;
begin
  try
    if Query.Fields.ByNameIsNull[Champ] then
      Result := Default
    else
      Result := Query.Fields.ByNameAsInteger[Champ];
  except
    Result := Default;
  end;
end;

class function TBasePointeur.NonNull(Query: TUIBQuery; const Champ: string): TGUID;
begin
  try
    if Query.Fields.ByNameIsNull[Champ] then
      Result := GUID_NULL
    else
      Result := StringToGUID(Query.Fields.ByNameAsString[Champ]);
  except
    Result := GUID_NULL;
  end;
end;

{ TConversion }

function TConversion.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := Format('1 %s = %.2f %s', [Monnaie1, Taux, Monnaie2]);
end;

procedure TConversion.Fill(Query: TUIBQuery);
begin
  ID := NonNull(Query, 'ID_Conversion');
  Monnaie1 := Query.Fields.ByNameAsString['Monnaie1'];
  Monnaie2 := Query.Fields.ByNameAsString['Monnaie2'];
  Taux := Query.Fields.ByNameAsDouble['Taux'];
end;

{ TCouverture }

procedure TCouverture.Assign(Ps: TBasePointeur);
begin
  inherited;
  OldNom := TCouverture(Ps).OldNom;
  NewNom := TCouverture(Ps).NewNom;
  OldStockee := TCouverture(Ps).OldStockee;
  NewStockee := TCouverture(Ps).NewStockee;
  Categorie := TCouverture(Ps).Categorie;
  sCategorie := TCouverture(Ps).sCategorie;
end;

function TCouverture.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := NewNom;
end;

procedure TCouverture.Fill(Query: TUIBQuery);
begin
  ID := NonNull(Query, 'ID_Couverture');
  OldNom := Query.Fields.ByNameAsString['FichierCouverture'];
  NewNom := OldNom;
  OldStockee := Query.Fields.ByNameAsBoolean['STOCKAGECOUVERTURE'];
  NewStockee := OldStockee;
  Categorie := Query.Fields.ByNameAsSmallint['CategorieImage'];
  sCategorie := Query.Fields.ByNameAsString['sCategorieImage'];
end;

class function TCouverture.Make(Query: TUIBQuery): TCouverture;
begin
  Result := TCouverture(inherited Make(Query));
end;

{ TEditeur }

procedure TEditeur.Assign(Ps: TBasePointeur);
begin
  inherited Assign(Ps);
  NomEditeur := TEditeur(Ps).NomEditeur;
end;

function TEditeur.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := FormatTitre(NomEditeur);
end;

class function TEditeur.Duplicate(Ps: TEditeur): TEditeur;
begin
  Result := TEditeur(inherited Duplicate(Ps));
end;

procedure TEditeur.Clear;
begin
  inherited;
  NomEditeur := '';
end;

procedure TEditeur.Fill(Query: TUIBQuery);
begin
  inherited;
  ID := NonNull(Query, 'ID_Editeur');
  NomEditeur := Query.Fields.ByNameAsString['NomEditeur'];
end;

procedure TEditeur.Fill(const ID_Editeur: TGUID);
var
  q: TUIBQuery;
begin
  q := TUIBQuery.Create(nil);
  with q do
  try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT NOMEDITEUR, ID_Editeur FROM EDITEURS WHERE ID_Editeur = ?';
    Params.AsString[0] := GUIDToString(ID_Editeur);
    Open;
    Fill(q);
  finally
    Transaction.Free;
    Free;
  end;
end;

{ TPersonnage }

procedure TPersonnage.Assign(Ps: TBasePointeur);
begin
  inherited;
  Nom := TPersonnage(Ps).Nom;
end;

function TPersonnage.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := FormatTitre(Nom);
end;

procedure TPersonnage.Clear;
begin
  inherited;
  Nom := '';
end;

procedure TPersonnage.Fill(Query: TUIBQuery);
begin
  inherited;
  ID := NonNull(Query, 'ID_Personne');
  Nom := Query.Fields.ByNameAsString['NomPersonne'];
end;

{ TAuteur }

procedure TAuteur.Assign(Ps: TBasePointeur);
begin
  inherited;
  ID_Album := TAuteur(Ps).ID_Album;
  Metier := TAuteur(Ps).Metier;
  Personne.Assign(TAuteur(Ps).Personne);
end;

function TAuteur.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := Personne.ChaineAffichage;
end;

constructor TAuteur.Create;
begin
  inherited;
  Personne := TPersonnage.Create;
end;

destructor TAuteur.Destroy;
begin
  FreeAndNil(Personne);
  inherited;
end;

procedure TAuteur.Clear;
begin
  inherited;
  Personne.Clear;
end;

procedure TAuteur.Fill(Query: TUIBQuery);
var
  PPersonne: TPersonnage;
begin
  inherited;
  PPersonne := TPersonnage(TPersonnage.Make(Query));
  try
    Fill(PPersonne, NonNull(Query, 'ID_Album'), NonNull(Query, 'ID_Serie'), TMetierAuteur(Query.Fields.ByNameAsInteger['Metier']));
  finally
    PPersonne.Free;
  end;
end;

procedure TAuteur.Fill(Pe: TPersonnage; const ReferenceAlbum, ReferenceSerie: TGUID; Metier: TMetierAuteur);
begin
  Personne.Assign(Pe);
  ID_Album := ReferenceAlbum;
  Self.Metier := Metier;
end;

class function TAuteur.Make(Query: TUIBQuery): TAuteur;
begin
  Result := TAuteur(inherited Make(Query));
end;

{ TAlbum }

procedure TAlbum.Assign(Ps: TBasePointeur);
begin
  inherited;
  Titre := TAlbum(Ps).Titre;
  Tome := TAlbum(Ps).Tome;
  TomeDebut := TAlbum(Ps).TomeDebut;
  TomeFin := TAlbum(Ps).TomeFin;
  ID_Serie := TAlbum(Ps).ID_Serie;
  Integrale := TAlbum(Ps).Integrale;
  HorsSerie := TAlbum(Ps).HorsSerie;
  ID_Editeur := TAlbum(Ps).ID_Editeur;
  Serie := TAlbum(Ps).Serie;
  Editeur := TAlbum(Ps).Editeur;
  AnneeParution := TAlbum(Ps).AnneeParution;
  MoisParution := TAlbum(Ps).MoisParution;
  Stock := TAlbum(Ps).Stock;
end;

function TAlbum.ChaineAffichage(Simple, AvecSerie: Boolean): string;
begin
  Result := FormatTitreAlbum(Simple, AvecSerie, Titre, Serie, Tome, TomeDebut, TomeFin, Integrale, HorsSerie);
end;

procedure TAlbum.Fill(Query: TUIBQuery);
begin
  inherited;
  ID := NonNull(Query, 'ID_Album');
  Titre := Query.Fields.ByNameAsString['TitreAlbum'];
  Tome := Query.Fields.ByNameAsInteger['Tome'];
  TomeDebut := Query.Fields.ByNameAsInteger['TomeDebut'];
  TomeFin := Query.Fields.ByNameAsInteger['TomeFin'];
  ID_Serie := NonNull(Query, 'ID_Serie');
  Integrale := Query.Fields.ByNameAsBoolean['Integrale'];
  HorsSerie := Query.Fields.ByNameAsBoolean['HorsSerie'];
  ID_Editeur := NonNull(Query, 'ID_Editeur');
  try
    Serie := Query.Fields.ByNameAsString['TitreSerie'];
  except
    Serie := '';
  end;
  try
    Editeur := Query.Fields.ByNameAsString['NomEditeur'];
  except
    Editeur := '';
  end;
  try
    MoisParution := Query.Fields.ByNameAsInteger['MoisParution'];
  except
    MoisParution := 0;
  end;
  try
    AnneeParution := Query.Fields.ByNameAsInteger['AnneeParution'];
  except
    AnneeParution := 0;
  end;
  try
    Stock := Query.Fields.ByNameAsBoolean['Stock'];
  except
    Stock := True;
  end;
  try
    Achat := Query.Fields.ByNameAsBoolean['Achat'];
  except
    Achat := False;
  end;
  try
    Complet := Query.Fields.ByNameAsBoolean['Complet'];
  except
    Complet := True;
  end;
end;

class function TAlbum.Duplicate(Ps: TAlbum): TAlbum;
begin
  Result := TAlbum(inherited Duplicate(Ps));
end;

procedure TAlbum.Fill(const ID_Album: TGUID);
begin
  Fill(ID_Album, GUID_NULL);
end;

procedure TAlbum.Fill(const ID_Album, ID_Edition: TGUID);
var
  q: TUIBQuery;
begin
  q := TUIBQuery.Create(nil);
  with q do
  try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT a.ID_Album, a.TitreAlbum, a.HorsSerie, a.Integrale, a.Tome, a.TomeDebut, a.TomeFin, a.ID_Serie, a.Achat, a.Complet, a.TitreSerie';
    SQL.Add('FROM VW_LISTE_ALBUMS a');
    SQL.Add('WHERE a.ID_ALBUM = :ID_Album');
    if not IsEqualGUID(ID_Edition, GUID_NULL) then
    begin
      SQL[0] := SQL[0] + ', e.Stock';
      SQL[1] := SQL[1] + ' INNER JOIN Editions e ON a.ID_Album = e.ID_Album';
      SQL.Add('AND e.ID_Edition = :ID_Edition');
    end;
    Params.AsString[0] := GUIDToString(ID_Album);
    if not IsEqualGUID(ID_Edition, GUID_NULL) then Params.AsString[1] := GUIDToString(ID_Edition);
    Open;
    Fill(q);
  finally
    Transaction.Free;
    Free;
  end;
end;

function TAlbum.ChaineAffichage(AvecSerie: Boolean): string;
begin
  Result := ChaineAffichage(False, AvecSerie);
end;

class function TAlbum.Make(Query: TUIBQuery): TAlbum;
begin
  Result := TAlbum(inherited Make(Query));
end;

{ TCollection }

procedure TCollection.Assign(Ps: TBasePointeur);
begin
  inherited;
  NomCollection := TCollection(Ps).NomCollection;
  Editeur.Assign(TCollection(Ps).Editeur);
end;

function TCollection.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := FormatTitre(NomCollection);
end;

constructor TCollection.Create;
begin
  inherited;
  Editeur := TEditeur.Create;
end;

destructor TCollection.Destroy;
begin
  FreeAndNil(Editeur);
  inherited;
end;

class function TCollection.Duplicate(Ps: TCollection): TCollection;
begin
  Result := TCollection(inherited Duplicate(Ps));
end;

procedure TCollection.Clear;
begin
  inherited;
  NomCollection := '';
  Editeur.Clear;
end;

procedure TCollection.Fill(Query: TUIBQuery);
begin
  inherited;
  ID := NonNull(Query, 'ID_Collection');
  NomCollection := Query.Fields.ByNameAsString['NomCollection'];
  try
    Editeur.Fill(Query);
  except
    Editeur.Clear;
  end;
end;

procedure TCollection.Fill(const ID_Collection: TGUID);
var
  q: TUIBQuery;
begin
  q := TUIBQuery.Create(nil);
  with q do
  try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT ID_Collection, NomCollection';
    SQL.Add('FROM COLLECTIONS');
    SQL.Add('WHERE ID_COLLECTION = :ID_COLLECTION');
    Params.AsString[0] := GUIDToString(ID_Collection);
    Open;
    Fill(q);
  finally
    Transaction.Free;
    Free;
  end;
end;

{ TSerie }

procedure TSerie.Assign(Ps: TBasePointeur);
begin
  inherited;
  TitreSerie := TSerie(Ps).TitreSerie;
  Editeur.Assign(TSerie(Ps).Editeur);
  Collection.Assign(TSerie(Ps).Collection);
end;

function TSerie.ChaineAffichage(Simple: Boolean): string;
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

class function TSerie.Duplicate(Ps: TSerie): TSerie;
begin
  Result := TSerie(inherited Duplicate(Ps));
end;

constructor TSerie.Create;
begin
  inherited;
  Editeur := TEditeur.Create;
  Collection := TCollection.Create;
end;

destructor TSerie.Destroy;
begin
  FreeAndNil(Collection);
  FreeAndNil(Editeur);
  inherited;
end;

procedure TSerie.Fill(Query: TUIBQuery);
begin
  inherited;
  ID := NonNull(Query, 'ID_Serie');
  TitreSerie := Query.Fields.ByNameAsString['TitreSerie'];
  try
    Editeur.Fill(Query);
  except
    Editeur.Clear;
  end;
  try
    Collection.Fill(Query);
  except
    Collection.Clear;
  end;
end;

procedure TSerie.Clear;
begin
  inherited;
  Editeur.Clear;
  Collection.Clear;
end;

procedure TSerie.Fill(const ID_Serie: TGUID);
var
  q: TUIBQuery;
begin
  q := TUIBQuery.Create(nil);
  with q do
  try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT ID_Serie, TitreSerie FROM SERIES WHERE ID_Serie = :ID_Serie';
    Params.AsString[0] := GUIDToString(ID_Serie);
    Open;
    Fill(q);
  finally
    Transaction.Free;
    Free;
  end;
end;

{ TEdition }

procedure TEdition.Assign(Ps: TBasePointeur);
begin
  inherited;
  AnneeEdition := TEdition(Ps).AnneeEdition;
  ISBN := TEdition(Ps).ISBN;
  Collection.Assign(TEdition(Ps).Collection);
  Editeur.Assign(TEdition(Ps).Editeur);
end;

function TEdition.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := '';
  AjoutString(Result, FormatTitre(Editeur.NomEditeur), ' ');
  AjoutString(Result, FormatTitre(Collection.NomCollection), ' ', '(', ')');
  AjoutString(Result, NonZero(IntToStr(AnneeEdition)), ' ', '[', ']');
  AjoutString(Result, FormatISBN(ISBN), ' - ', 'ISBN ');
end;

class function TEdition.Duplicate(Ps: TEdition): TEdition;
begin
  Result := TEdition(inherited Duplicate(Ps));
end;

constructor TEdition.Create;
begin
  inherited;
  Editeur := TEditeur.Create;
  Collection := TCollection.Create;
end;

destructor TEdition.Destroy;
begin
  FreeAndNil(Editeur);
  FreeAndNil(Collection);
  inherited;
end;

procedure TEdition.Clear;
begin
  inherited;
  Editeur.Clear;
  Collection.Clear;
end;

procedure TEdition.Fill(Query: TUIBQuery);
begin
  inherited;
  ID := NonNull(Query, 'ID_Edition');
  AnneeEdition := Query.Fields.ByNameAsInteger['AnneeEdition'];
  try
    ISBN := Trim(Query.Fields.ByNameAsString['ISBN']);
  except
    ISBN := '';
  end;
  Editeur.Fill(Query);
  Collection.Fill(Query);
end;

{ TEmprunteur }

procedure TEmprunteur.Assign(Ps: TBasePointeur);
begin
  inherited;
  Nom := TEmprunteur(Ps).Nom;
end;

function TEmprunteur.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := FormatTitre(Nom);
end;

class function TEmprunteur.Duplicate(Ps: TEmprunteur): TEmprunteur;
begin
  Result := TEmprunteur(inherited Duplicate(Ps));
end;

procedure TEmprunteur.Clear;
begin
  inherited;
  Nom := '';
end;

procedure TEmprunteur.Fill(Query: TUIBQuery);
begin
  inherited;
  ID := NonNull(Query, 'ID_Emprunteur');
  Nom := Query.Fields.ByNameAsString['NomEmprunteur'];
end;

procedure TEmprunteur.Fill(const ID_Emprunteur: TGUID);
var
  q: TUIBQuery;
begin
  q := TUIBQuery.Create(nil);
  with q do
  try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT ID_Emprunteur, NomEmprunteur FROM Emprunteurs WHERE ID_Emprunteur = ?';
    Params.AsString[0] := GUIDToString(ID_Emprunteur);
    Open;
    Fill(q);
  finally
    Transaction.Free;
    Free;
  end;
end;

class function TEmprunteur.Make(Query: TUIBQuery): TEmprunteur;
begin
  Result := TEmprunteur(inherited Make(Query));
end;

{ TGenre }

procedure TGenre.Assign(Ps: TBasePointeur);
begin
  inherited;
  Genre := TGenre(Ps).Genre;
  Quantite := TGenre(Ps).Quantite;
end;

function TGenre.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := Genre;
end;

procedure TGenre.Clear;
begin
  inherited;
  Genre := '';
end;

procedure TGenre.Fill(Query: TUIBQuery);
begin
  inherited;
  ID := NonNull(Query, 'ID_Genre');
  Genre := Query.Fields.ByNameAsString['Genre'];
  try
    Quantite := Query.Fields.ByNameAsInteger['QuantiteGenre'];
  except
    Quantite := 0;
  end;
end;

class function TGenre.Make(Query: TUIBQuery): TGenre;
begin
  Result := TGenre(inherited Make(Query));
end;

{ TEmprunt }

procedure TEmprunt.Assign(Ps: TBasePointeur);
begin
  inherited;
  Pret := TEmprunt(Ps).Pret;
  Date := TEmprunt(Ps).Date;
  Emprunteur.Assign(TEmprunt(Ps).Emprunteur);
  Album.Assign(TEmprunt(Ps).Album);
  Edition.Assign(TEmprunt(Ps).Edition);
end;

function TEmprunt.ChaineAffichage(dummy: Boolean = True): string;
begin
  Result := FormatDateTime(ShortDateFormat, Date);
end;

constructor TEmprunt.Create;
begin
  inherited;
  Album := TAlbum.Create;
  Emprunteur := TEmprunteur.Create;
  Edition := TEdition.Create;
end;

destructor TEmprunt.Destroy;
begin
  FreeAndNil(Album);
  FreeAndNil(Emprunteur);
  FreeAndNil(Edition);
  inherited;
end;

class function TEmprunt.Duplicate(Ps: TEmprunt): TEmprunt;
begin
  Result := TEmprunt(inherited Duplicate(Ps));
end;

procedure TEmprunt.Clear;
begin
  inherited;
  Album.Clear;
  Emprunteur.Clear;
  Edition.Clear;
end;

procedure TEmprunt.Fill(Query: TUIBQuery);
begin
  inherited;
  Pret := Bool(Query.Fields.ByNameAsInteger['PretEmprunt']);
  Date := Query.Fields.ByNameAsDateTime['DateEmprunt'];
  try
    Emprunteur.Fill(Query);
  except
    Emprunteur.Clear;
  end;
  try
    Album.Fill(Query);
  except
    Album.Clear;
  end;
  try
    Edition.Fill(Query);
  except
    Edition.Clear;
  end;
end;

{ TParaBD }

procedure TParaBD.Assign(Ps: TBasePointeur);
begin
  inherited;
  Titre := TParaBD(Ps).Titre;
  ID_Serie := TParaBD(Ps).ID_Serie;
  Serie := TParaBD(Ps).Serie;
  Achat := TParaBD(Ps).Achat;
  Complet := TParaBD(Ps).Complet;
end;

function TParaBD.ChaineAffichage(AvecSerie: Boolean): string;
begin
  Result := ChaineAffichage(False, AvecSerie);
end;

function TParaBD.ChaineAffichage(Simple: Boolean; AvecSerie: Boolean): string;
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

procedure TParaBD.Fill(Query: TUIBQuery);
begin
  ID := NonNull(Query, 'ID_ParaBD');
  Titre := Query.Fields.ByNameAsString['TitreParaBD'];
  ID_Serie := NonNull(Query, 'ID_Serie');
  try
    Serie := Query.Fields.ByNameAsString['TitreSerie'];
  except
    Serie := '';
  end;
  try
    Achat := Query.Fields.ByNameAsBoolean['Achat'];
  except
    Achat := False;
  end;
  try
    Complet := Query.Fields.ByNameAsBoolean['Complet'];
  except
    Complet := True;
  end;
  try
    sCategorie := Query.Fields.ByNameAsString['sCategorie'];
  except
    sCategorie := '';
  end;
end;

class function TParaBD.Make(Query: TUIBQuery): TParaBD;
begin
  Result := TParaBD(inherited Make(Query));
end;

end.

