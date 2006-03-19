unit TypeRec;

interface

uses
  Windows, SysUtils, DB, Classes, ComCtrls, JvUIB, StdCtrls;

//  IMPORTANT: Ref doit TOUJOURS être le premier champ des records
//  Les strings DOIVENT être limités pour pouvoir utiliser CopyMemory(Pd, Ps, SizeOf(Ps^));

type
  TEditionsEmpruntees = array of array[0..1] of Integer;

  TBasePointeur = class(TObject)
  private
    class function NonNull(Query: TJvUIBQuery; const Champ: string; Default: Integer = -1): Integer;

  public
    Reference: Integer;

    procedure Assign(Ps: TBasePointeur); virtual;

    procedure AfterConstruction; override;
    constructor Create; virtual;

    class function Duplicate(Ps: TBasePointeur): TBasePointeur;
    class function Make(Query: TJvUIBQuery): TBasePointeur;
    class procedure VideListe(LV: TListView; DoClear: Boolean = True); overload;
    class procedure VideListe(List: TList; DoClear: Boolean = True); overload;
    class procedure VideListe(ListBox: TListBox; DoClear: Boolean = True); overload;

    procedure Clear; virtual;
    procedure Fill(Query: TJvUIBQuery); virtual; abstract;
    function ChaineAffichage: string; virtual; abstract;
  end;

  TCouverture = class(TBasePointeur)
  public
    OldNom, NewNom: string[255];
    OldStockee, NewStockee: Boolean;
    Categorie: Smallint;
    sCategorie: string[50];

    procedure Assign(Ps: TBasePointeur); override;

    procedure Fill(Query: TJvUIBQuery); override;
    function ChaineAffichage: string; override;
  end;

  TParaBD = class(TBasePointeur)
  public
    Titre: string[150];
    RefSerie: Integer;
    Serie: string[150];
    Achat: Boolean;
    Complet: Boolean;

    procedure Assign(Ps: TBasePointeur); override;

    procedure Fill(Query: TJvUIBQuery); override;
    function ChaineAffichage: string; overload; override;
    function ChaineAffichage(Simple: Boolean): string; reintroduce; overload;
  end;

  TPersonnage = class(TBasePointeur)
  public
    Nom: string[150];

    procedure Assign(Ps: TBasePointeur); override;

    procedure Fill(Query: TJvUIBQuery); override;
    function ChaineAffichage: string; override;
    procedure Clear; override;
  end;

  TAuteur = class(TBasePointeur)
  public
    Personne: TPersonnage;
    RefAlbum, RefSerie: Integer;
    Metier: Integer;

    procedure Assign(Ps: TBasePointeur); override;

    constructor Create; override;
    destructor Destroy; override;

    procedure Fill(Query: TJvUIBQuery); overload; override;
    procedure Fill(Pe: TPersonnage; ReferenceAlbum, ReferenceSerie, Metier: Integer); reintroduce; overload;
    procedure Clear; override;
    function ChaineAffichage: string; override;
  end;

  TEditeur = class(TBasePointeur)
  public
    NomEditeur: string[50];

    procedure Assign(Ps: TBasePointeur); override;

    procedure Fill(Query: TJvUIBQuery); override;
    function ChaineAffichage: string; override;
    procedure Clear; override;
    class function Duplicate(Ps: TEditeur): TEditeur; reintroduce;
  end;

  TAlbum = class(TBasePointeur)
  public
    Tome: Integer;
    TomeDebut: Integer;
    TomeFin: Integer;
    Titre: string[150];
    RefSerie: Integer;
    Serie: string[150];
    RefEditeur: Integer;
    Editeur: string[50];
    AnneeParution, MoisParution: Integer;
    Stock: Boolean;
    Integrale: Boolean;
    HorsSerie: Boolean;
    Achat: Boolean;
    Complet: Boolean;

    procedure Assign(Ps: TBasePointeur); override;

    procedure Fill(Query: TJvUIBQuery); overload; override;
    procedure Fill(RefAlbum: Integer; RefEdition: Integer = -1); reintroduce; overload;
    function ChaineAffichage: string; overload; override;
    function ChaineAffichage(Simple: Boolean): string; reintroduce; overload;
    class function Duplicate(Ps: TAlbum): TAlbum; reintroduce;
  end;

  TCollection = class(TBasePointeur)
  public
    NomCollection: string[50];
    Editeur: TEditeur;

    procedure Assign(Ps: TBasePointeur); override;

    constructor Create; override;
    destructor Destroy; override;

    procedure Fill(Query: TJvUIBQuery); override;
    function ChaineAffichage: string; override;
    procedure Clear; override;
    class function Duplicate(Ps: TCollection): TCollection; reintroduce;
  end;

  TSerie = class(TBasePointeur)
  public
    TitreSerie: string[150];
    Editeur: TEditeur;
    Collection: TCollection;

    procedure Assign(Ps: TBasePointeur); override;

    constructor Create; override;
    destructor Destroy; override;

    procedure Fill(Query: TJvUIBQuery); overload; override;
    procedure Fill(RefSerie: Integer); reintroduce; overload;
    function ChaineAffichage: string; overload; override;
    function ChaineAffichage(Simple: Boolean): string; reintroduce; overload;
    procedure Clear; override;
    class function Duplicate(Ps: TSerie): TSerie; reintroduce;
  end;

  TEdition = class(TBasePointeur)
  public
    AnneeEdition: Integer;
    ISBN: string[17];
    Editeur: TEditeur;
    Collection: TCollection;

    procedure Assign(Ps: TBasePointeur); override;

    constructor Create; override;
    destructor Destroy; override;

    procedure Fill(Query: TJvUIBQuery); override;
    function ChaineAffichage: string; override;
    procedure Clear; override;
    class function Duplicate(Ps: TEdition): TEdition;
  end;

  TEmprunteur = class(TBasePointeur)
  public
    Nom: string[100];

    procedure Assign(Ps: TBasePointeur); override;

    procedure Fill(Query: TJvUIBQuery); overload; override;
    procedure Fill(RefEmprunteur: Integer); reintroduce; overload;
    function ChaineAffichage: string; override;
    procedure Clear; override;
    class function Duplicate(Ps: TEmprunteur): TEmprunteur;
  end;

  TConversion = class(TBasePointeur)
    Monnaie1, Monnaie2: string[5];
    Taux: Double;

    procedure Fill(Query: TJvUIBQuery); override;
    function ChaineAffichage: string; override;
  end;

  TGenre = class(TBasePointeur)
  public
    Genre: string[50];
    Quantite: Integer;

    procedure Assign(Ps: TBasePointeur); override;

    procedure Fill(Query: TJvUIBQuery); override;
    function ChaineAffichage: string; override;
    procedure Clear; override;
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

    procedure Fill(Query: TJvUIBQuery); override;
    function ChaineAffichage: string; override;
    procedure Clear; override;
    class function Duplicate(Ps: TEmprunt): TEmprunt;
  end;

implementation

uses DM_Princ, JvUIBLib, Commun;

{ TBasePointeur }

procedure TBasePointeur.AfterConstruction;
begin
  inherited;
  Clear;
end;

procedure TBasePointeur.Assign(Ps: TBasePointeur);
begin
  Reference := Ps.Reference;
end;

class function TBasePointeur.Duplicate(Ps: TBasePointeur): TBasePointeur;
begin
  Result := Create;
  Result.Assign(Ps);
end;

procedure TBasePointeur.Clear;
begin
  Reference := -1;
end;

class function TBasePointeur.Make(Query: TJvUIBQuery): TBasePointeur;
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
    for i := LV.Items.Count - 1 downto 0 do begin
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
    for i := 0 to Pred(List.Count) do begin
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
    for i := 0 to Pred(ListBox.Items.Count) do begin
      ListBox.Items.Objects[i].Free;
    end;
  finally
    if DoClear then ListBox.Items.Clear;
  end;
end;

constructor TBasePointeur.Create;
begin

end;

class function TBasePointeur.NonNull(Query: TJvUIBQuery; const Champ: string; Default: Integer): Integer;
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

{ TConversion }

function TConversion.ChaineAffichage: string;
begin
  Result := Format('1 %s = %.2f %s', [Monnaie1, Taux, Monnaie2]);
end;

procedure TConversion.Fill(Query: TJvUIBQuery);
begin
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

function TCouverture.ChaineAffichage: string;
begin
  Result := NewNom;
end;

procedure TCouverture.Fill(Query: TJvUIBQuery);
begin
  Reference := Query.Fields.ByNameAsInteger['RefCouverture'];
  OldNom := Query.Fields.ByNameAsString['FichierCouverture'];
  NewNom := OldNom;
  OldStockee := Query.Fields.ByNameAsBoolean['TypeCouverture'];
  NewStockee := OldStockee;
  Categorie := Query.Fields.ByNameAsSmallint['CategorieImage'];
  sCategorie := Query.Fields.ByNameAsString['sCategorieImage'];
end;

{ TEditeur }

procedure TEditeur.Assign(Ps: TBasePointeur);
begin
  inherited Assign(Ps);
  NomEditeur := TEditeur(Ps).NomEditeur;
end;

function TEditeur.ChaineAffichage: string;
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

procedure TEditeur.Fill(Query: TJvUIBQuery);
begin
  inherited;
  Reference := NonNull(Query, 'RefEditeur');
  NomEditeur := Query.Fields.ByNameAsString['NomEditeur'];
end;

{ TPersonnage }

procedure TPersonnage.Assign(Ps: TBasePointeur);
begin
  inherited;
  Nom := TPersonnage(Ps).Nom;
end;

function TPersonnage.ChaineAffichage: string;
begin
  Result := FormatTitre(Nom);
end;

procedure TPersonnage.Clear;
begin
  inherited;
  Nom := '';
end;

procedure TPersonnage.Fill(Query: TJvUIBQuery);
begin
  inherited;
  Reference := NonNull(Query, 'RefPersonne');
  Nom := Query.Fields.ByNameAsString['NomPersonne'];
end;

{ TAuteur }

procedure TAuteur.Assign(Ps: TBasePointeur);
begin
  inherited;
  RefAlbum := TAuteur(Ps).RefAlbum;
  Metier := TAuteur(Ps).Metier;
  Personne.Assign(TAuteur(Ps).Personne);
end;

function TAuteur.ChaineAffichage: string;
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

procedure TAuteur.Fill(Query: TJvUIBQuery);
var
  PPersonne: TPersonnage;
begin
  inherited;
  PPersonne := TPersonnage(TPersonnage.Make(Query));
  try
    Fill(PPersonne, NonNull(Query, 'RefAlbum'), NonNull(Query, 'RefSerie'), Query.Fields.ByNameAsInteger['Metier']);
  finally
    PPersonne.Free;
  end;
end;

procedure TAuteur.Fill(Pe: TPersonnage; ReferenceAlbum, ReferenceSerie, Metier: Integer);
begin
  Personne.Assign(Pe);
  RefAlbum := ReferenceAlbum;
  Self.Metier := Metier;
end;

{ TAlbum }

procedure TAlbum.Assign(Ps: TBasePointeur);
begin
  inherited;
  Titre := TAlbum(Ps).Titre;
  Tome := TAlbum(Ps).Tome;
  TomeDebut := TAlbum(Ps).TomeDebut;
  TomeFin := TAlbum(Ps).TomeFin;
  RefSerie := TAlbum(Ps).RefSerie;
  Integrale := TAlbum(Ps).Integrale;
  HorsSerie := TAlbum(Ps).HorsSerie;
  RefEditeur := TAlbum(Ps).RefEditeur;
  Serie := TAlbum(Ps).Serie;
  Editeur := TAlbum(Ps).Editeur;
  AnneeParution := TAlbum(Ps).AnneeParution;
  MoisParution := TAlbum(Ps).MoisParution;
  Stock := TAlbum(Ps).Stock;
end;

function TAlbum.ChaineAffichage(Simple: Boolean): string;
var
  s, s2: string;
begin
  if Simple then
    Result := Titre
  else
    Result := FormatTitre(Titre);
  s := '';
  AjoutString(s, FormatTitre(Serie), ' - ');
  if Integrale then begin
    s2 := NonZero(IntToStr(TomeDebut));
    AjoutString(s2, NonZero(IntToStr(TomeFin)), ' à ');
    AjoutString(s, 'INT.', ' - ', '', TrimRight(' ' + NonZero(IntToStr(Tome))));
    AjoutString(s, s2, ' ', '[', ']');
  end
  else if HorsSerie then
    AjoutString(s, 'HS', ' - ', '', TrimRight(' ' + NonZero(IntToStr(Tome))))
  else
    AjoutString(s, NonZero(IntToStr(Tome)), ' - ', 'T. ');
  AjoutString(Result, s, ' ', '(', ')');
end;

procedure TAlbum.Fill(Query: TJvUIBQuery);
begin
  inherited;
  Reference := NonNull(Query, 'RefAlbum');
  Titre := Query.Fields.ByNameAsString['TitreAlbum'];
  Tome := Query.Fields.ByNameAsInteger['Tome'];
  TomeDebut := Query.Fields.ByNameAsInteger['TomeDebut'];
  TomeFin := Query.Fields.ByNameAsInteger['TomeFin'];
  RefSerie := Query.Fields.ByNameAsInteger['RefSerie'];
  Integrale := Query.Fields.ByNameAsBoolean['Integrale'];
  HorsSerie := Query.Fields.ByNameAsBoolean['HorsSerie'];
  try
    RefEditeur := Query.Fields.ByNameAsInteger['RefEditeur'];
  except
    RefEditeur := -1;
  end;
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

procedure TAlbum.Fill(RefAlbum, RefEdition: Integer);
var
  q: TJvUIBQuery;
begin
  q := TJvUIBQuery.Create(nil);
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT a.RefAlbum, a.TitreAlbum, a.HorsSerie, a.Integrale, a.Tome, a.TomeDebut, a.TomeFin, a.RefSerie, a.Achat, a.Complet';
    SQL.Add('FROM ALBUMS a');
    SQL.Add('WHERE a.REFALBUM = :RefAlbum');
    if RefEdition > -1 then begin
      SQL[0] := SQL[0] + ', e.Stock';
      SQL[1] := SQL[1] + ' INNER JOIN Editions e ON a.RefAlbum = e.RefAlbum';
      SQL.Add('AND e.RefEdition = :RefEdition');
    end;
    Params.AsInteger[0] := RefAlbum;
    if RefEdition > -1 then Params.AsInteger[1] := RefEdition;
    Open;
    Fill(q);
  finally
    Transaction.Free;
    Free;
  end;
end;

function TAlbum.ChaineAffichage: string;
begin
  Result := ChaineAffichage(False);
end;

{ TCollection }

procedure TCollection.Assign(Ps: TBasePointeur);
begin
  inherited;
  NomCollection := TCollection(Ps).NomCollection;
  Editeur.Assign(TCollection(Ps).Editeur);
end;

function TCollection.ChaineAffichage: string;
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

procedure TCollection.Fill(Query: TJvUIBQuery);
begin
  inherited;
  Reference := NonNull(Query, 'RefCollection');
  NomCollection := Query.Fields.ByNameAsString['NomCollection'];
  try
    Editeur.Fill(Query);
  except
    Editeur.Clear;
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

procedure TSerie.Fill(Query: TJvUIBQuery);
begin
  inherited;
  Reference := NonNull(Query, 'RefSerie');
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

procedure TSerie.Fill(RefSerie: Integer);
var
  q: TJvUIBQuery;
begin
  q := TJvUIBQuery.Create(nil);
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT RefSerie, TitreSerie FROM SERIES WHERE REFSERIE = :RefSerie';
    Params.AsInteger[0] := RefSerie;
    Open;
    Fill(q);
  finally
    Transaction.Free;
    Free;
  end;
end;

function TSerie.ChaineAffichage: string;
begin
  Result := ChaineAffichage(False);
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

function TEdition.ChaineAffichage: string;
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

procedure TEdition.Fill(Query: TJvUIBQuery);
begin
  inherited;
  Reference := NonNull(Query, 'RefEdition');
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

function TEmprunteur.ChaineAffichage: string;
begin
  Result := Nom;
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

procedure TEmprunteur.Fill(Query: TJvUIBQuery);
begin
  inherited;
  Reference := NonNull(Query, 'RefEmprunteur');
  Nom := Query.Fields.ByNameAsString['NomEmprunteur'];
end;

procedure TEmprunteur.Fill(RefEmprunteur: Integer);
var
  q: TJvUIBQuery;
begin
  q := TJvUIBQuery.Create(nil);
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT RefEmprunteur, NomEmprunteur FROM Emprunteurs WHERE RefEmprunteur = ?';
    Params.AsInteger[0] := RefEmprunteur;
    Open;
    Fill(q);
  finally
    Transaction.Free;
    Free;
  end;
end;

{ TGenre }

procedure TGenre.Assign(Ps: TBasePointeur);
begin
  inherited;
  Genre := TGenre(Ps).Genre;
  Quantite := TGenre(Ps).Quantite;
end;

function TGenre.ChaineAffichage: string;
begin
  Result := Genre;
end;

procedure TGenre.Clear;
begin
  inherited;
  Genre := '';
end;

procedure TGenre.Fill(Query: TJvUIBQuery);
begin
  inherited;
  Reference := NonNull(Query, 'RefGenre');
  Genre := Query.Fields.ByNameAsString['Genre'];
  try
    Quantite := Query.Fields.ByNameAsInteger['QuantiteGenre'];
  except
    Quantite := 0;
  end;
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

function TEmprunt.ChaineAffichage: string;
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

procedure TEmprunt.Fill(Query: TJvUIBQuery);
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
  RefSerie := TParaBD(Ps).RefSerie;
  Serie := TParaBD(Ps).Serie;
  Achat := TParaBD(Ps).Achat;
  Complet := TParaBD(Ps).Complet;
end;

function TParaBD.ChaineAffichage: string;
begin
  Result := ChaineAffichage(False);
end;

function TParaBD.ChaineAffichage(Simple: Boolean): string;
var
  s: string;
begin
  if Simple then
    Result := Titre
  else
    Result := FormatTitre(Titre);
  s := '';
  AjoutString(s, FormatTitre(Serie), ' - ');
  AjoutString(Result, s, ' ', '(', ')');
end;

procedure TParaBD.Fill(Query: TJvUIBQuery);
begin
  Reference := NonNull(Query, 'RefParaBD');
  Titre := Query.Fields.ByNameAsString['TitreParaBD'];
  RefSerie := Query.Fields.ByNameAsInteger['RefSerie'];
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
end;

end.

