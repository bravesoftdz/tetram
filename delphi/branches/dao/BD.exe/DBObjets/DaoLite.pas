unit DaoLite;

interface

uses
  System.SysUtils, uib, EntitiesLite, UMetadata, System.Generics.Collections,
  System.SyncObjs, Vcl.ComCtrls, Vcl.StdCtrls, System.Classes;

type
  // ce serait trop facile si XE4 acceptait cette syntaxe....
  // TClassDaoLite = class of TDaoLite;
  // je suis donc obligé de faire des classes "classique"
  TClassDaoLite = class of TDaoLite;

  TDaoLite = class
  private
    cs: TCriticalSection;
    FPreparedQuery: TUIBQuery;

    function NonNull(Query: TUIBQuery; const Champ: string; Default: Integer): Integer; overload; inline;
    function NonNull(Query: TUIBQuery; const Champ: string): TGUID; overload; inline;
    function NonNull(Query: TUIBQuery; Champ, Default: Integer): Integer; overload; inline;
    function NonNull(Query: TUIBQuery; Champ: Integer): TGUID; overload; inline;

    procedure GetFieldIndices; virtual;
    function GetFieldIndex(const Name: string): Integer;

    function EntityClass: TBasePointeurClass; virtual; abstract;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Prepare(Query: TUIBQuery);
    procedure Unprepare;

    function Make(Query: TUIBQuery): TBasePointeur; virtual;
    function Duplicate(Ps: TBasePointeur): TBasePointeur; virtual;

    procedure Fill(Entity: TBasePointeur; Query: TUIBQuery); virtual;
    procedure FillList<T: TBasePointeur>(List: TList<T>; Query: TUIBQuery);

    procedure VideListe(LV: TListView; DoClear: Boolean = True); overload;
    procedure VideListe(List: TList<TBasePointeur>; DoClear: Boolean = True); overload;
    procedure VideListe(ListBox: TListBox; DoClear: Boolean = True); overload;
  end;

  TDaoAlbumLite = class(TDaoLite)
  strict private
    IndexID_Album: Integer;
    IndexTome: Integer;
    IndexTomeDebut: Integer;
    IndexTomeFin: Integer;
    IndexTitreAlbum: Integer;
    IndexID_Serie: Integer;
    IndexTitreSerie: Integer;
    IndexID_Editeur: Integer;
    IndexNomEditeur: Integer;
    IndexAnneeParution, IndexMoisParution: Integer;
    IndexStock: Integer;
    IndexIntegrale: Integer;
    IndexHorsSerie: Integer;
    IndexAchat: Integer;
    IndexComplet: Integer;
    IndexNotation: Integer;
  private
    function EntityClass: TBasePointeurClass; override;
    procedure GetFieldIndices; override;
  public
    function Make(Query: TUIBQuery): TAlbumLite; reintroduce;
    function Duplicate(Ps: TAlbumLite): TAlbumLite; reintroduce;

    procedure Fill(Entity: TAlbumLite; Query: TUIBQuery); reintroduce;

    procedure FillEx(Entity: TAlbumLite; const ID_Album: TGUID); overload;
    procedure FillEx(Entity: TAlbumLite; const ID_Album, ID_Edition: TGUID); overload;
    procedure FillList(List: TList<TAlbumLite>; Query: TUIBQuery); reintroduce;
  end;

  TDaoParaBDLite = class(TDaoLite)
  private
    function EntityClass: TBasePointeurClass; override;
  public
    function Make(Query: TUIBQuery): TParaBDLite; reintroduce;
    function Duplicate(Ps: TParaBDLite): TParaBDLite; reintroduce;

    procedure Fill(Entity: TParaBDLite; Query: TUIBQuery); reintroduce;
    procedure FillList(List: TList<TParaBDLite>; Query: TUIBQuery); reintroduce;
  end;

  TDaoSerieLite = class(TDaoLite)
  private
    function EntityClass: TBasePointeurClass; override;
  public
    function Make(Query: TUIBQuery): TSerieLite; reintroduce;
    function Duplicate(Ps: TSerieLite): TSerieLite; reintroduce;

    procedure Fill(Entity: TSerieLite; Query: TUIBQuery); reintroduce;
    procedure FillEx(Entity: TSerieLite; const ID_Serie: TGUID);
    procedure FillList(List: TList<TSerieLite>; Query: TUIBQuery); reintroduce;
  end;

  TDaoEditionLite = class(TDaoLite)
  private
    function EntityClass: TBasePointeurClass; override;
  public
    function Make(Query: TUIBQuery): TEditionLite; reintroduce;
    function Duplicate(Ps: TEditionLite): TEditionLite; reintroduce;

    procedure Fill(Entity: TEditionLite; Query: TUIBQuery); reintroduce;
    procedure FillList(List: TList<TEditionLite>; Query: TUIBQuery); reintroduce;
  end;

  TDaoEditeurLite = class(TDaoLite)
  private
    function EntityClass: TBasePointeurClass; override;
  public
    function Make(Query: TUIBQuery): TEditeurLite; reintroduce;
    function Duplicate(Ps: TEditeurLite): TEditeurLite; reintroduce;

    procedure Fill(Entity: TEditeurLite; Query: TUIBQuery); reintroduce;
    procedure FillEx(Entity: TEditeurLite; const ID_Editeur: TGUID);
    procedure FillList(List: TList<TEditeurLite>; Query: TUIBQuery); reintroduce;
  end;

  TDaoCollectionLite = class(TDaoLite)
  private
    function EntityClass: TBasePointeurClass; override;
  public
    function Make(Query: TUIBQuery): TCollectionLite; reintroduce;
    function Duplicate(Ps: TCollectionLite): TCollectionLite; reintroduce;

    procedure Fill(Entity: TCollectionLite; Query: TUIBQuery); reintroduce;
    procedure FillEx(Entity: TCollectionLite; const ID_Collection: TGUID);
    procedure FillList(List: TList<TCollectionLite>; Query: TUIBQuery); reintroduce;
  end;

  TDaoPersonnageLite = class(TDaoLite)
  private
    function EntityClass: TBasePointeurClass; override;
  public
    function Make(Query: TUIBQuery): TPersonnageLite; reintroduce;
    function Duplicate(Ps: TPersonnageLite): TPersonnageLite; reintroduce;

    procedure Fill(Entity: TPersonnageLite; Query: TUIBQuery); reintroduce;
    procedure FillEx(Entity: TPersonnageLite; const ID_Personne: TGUID);
    procedure FillList(List: TList<TPersonnageLite>; Query: TUIBQuery); reintroduce;
  end;

  TDaoAuteurLite = class(TDaoLite)
  private
    function EntityClass: TBasePointeurClass; override;
  public
    function Make(Query: TUIBQuery): TAuteurLite; reintroduce;
    function Duplicate(Ps: TAuteurLite): TAuteurLite; reintroduce;

    procedure Fill(Entity: TAuteurLite; Query: TUIBQuery); reintroduce;
    procedure FillEx(Entity: TAuteurLite; Pe: TPersonnageLite; const ReferenceAlbum, ReferenceSerie: TGUID; Metier: TMetierAuteur);
    procedure FillList(List: TList<TAuteurLite>; Query: TUIBQuery); reintroduce;
  end;

  TDaoUniversLite = class(TDaoLite)
  private
    function EntityClass: TBasePointeurClass; override;
  public
    function Make(Query: TUIBQuery): TUniversLite; reintroduce;
    function Duplicate(Ps: TUniversLite): TUniversLite; reintroduce;

    procedure Fill(Entity: TUniversLite; Query: TUIBQuery); reintroduce;
    procedure FillEx(Entity: TUniversLite; const ID_Univers: TGUID);
    procedure FillList(List: TList<TUniversLite>; Query: TUIBQuery); reintroduce;
  end;

  TDaoCouvertureLite = class(TDaoLite)
  private
    function EntityClass: TBasePointeurClass; override;
  public
    function Make(Query: TUIBQuery): TCouvertureLite; reintroduce;
    function Duplicate(Ps: TCouvertureLite): TCouvertureLite; reintroduce;

    procedure Fill(Entity: TCouvertureLite; Query: TUIBQuery); reintroduce;
    procedure FillList(List: TList<TCouvertureLite>; Query: TUIBQuery); reintroduce;
  end;

  TDaoGenreLite = class(TDaoLite)
  private
    function EntityClass: TBasePointeurClass; override;
  public
    function Make(Query: TUIBQuery): TGenreLite; reintroduce;
    function Duplicate(Ps: TGenreLite): TGenreLite; reintroduce;

    procedure Fill(Entity: TGenreLite; Query: TUIBQuery); reintroduce;
    procedure FillList(List: TList<TGenreLite>; Query: TUIBQuery); reintroduce;
  end;

  TDaoConversionLite = class(TDaoLite)
  private
    function EntityClass: TBasePointeurClass; override;
  public
    function Make(Query: TUIBQuery): TConversionLite; reintroduce;
    function Duplicate(Ps: TConversionLite): TConversionLite; reintroduce;

    procedure Fill(Entity: TConversionLite; Query: TUIBQuery); reintroduce;
    procedure FillList(List: TList<TConversionLite>; Query: TUIBQuery); reintroduce;
  end;

  TDaoLiteFactory = class sealed
  strict private
    class var FDaoInstances: TDictionary<TClassDaoLite, TDaoLite>;
  public
    class constructor Create;
    class destructor Destroy;

    class function getInstance(c: TClassDaoLite): TDaoLite;

    class function AlbumLite: TDaoAlbumLite;
    class function ParaBDLite: TDaoParaBDLite;
    class function SerieLite: TDaoSerieLite;
    class function PersonnageLite: TDaoPersonnageLite;
    class function AuteurLite: TDaoAuteurLite;
    class function EditeurLite: TDaoEditeurLite;
    class function CollectionLite: TDaoCollectionLite;
    class function UniversLite: TDaoUniversLite;
    class function GenreLite: TDaoGenreLite;
    class function CouvertureLite: TDaoCouvertureLite;
    class function ConversionLite: TDaoConversionLite;
  end;

implementation

uses
  Commun, UdmPrinc, uiblib;

{ TDaoLite<T> }

function TDaoLite.NonNull(Query: TUIBQuery; const Champ: string): TGUID;
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

function TDaoLite.NonNull(Query: TUIBQuery; const Champ: string; Default: Integer): Integer;
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

constructor TDaoLite.Create;
begin
  cs := nil;
end;

destructor TDaoLite.Destroy;
begin
  cs.Free;
  inherited;
end;

function TDaoLite.Duplicate(Ps: TBasePointeur): TBasePointeur;
begin
  Assert(Ps is EntityClass);
  Result := EntityClass.Create;
  Result.Assign(Ps);
end;

procedure TDaoLite.Fill(Entity: TBasePointeur; Query: TUIBQuery);
begin

end;

procedure TDaoLite.FillList<T>(List: TList<T>; Query: TUIBQuery);
begin
  Prepare(Query);
  try
    while not Query.Eof do
    begin
      List.Add(Make(Query));
      Query.Next;
    end;
  finally
    Unprepare;
  end;
end;

function TDaoLite.GetFieldIndex(const Name: string): Integer;
begin
  for Result := 0 to Pred(FPreparedQuery.Fields.FieldCount) do
    if SameText(FPreparedQuery.Fields.AliasName[Result], Name) then
      Exit;
  Result := -1;
end;

procedure TDaoLite.GetFieldIndices;
begin
  Assert(FPreparedQuery <> nil, 'Doit être préparé avant');
end;

function TDaoLite.Make(Query: TUIBQuery): TBasePointeur;
begin
  Result := EntityClass.Create;
  Fill(Result, Query);
end;

function TDaoLite.NonNull(Query: TUIBQuery; Champ: Integer): TGUID;
begin
  try
    if (Champ = -1) or Query.Fields.IsNull[Champ] then
      Result := GUID_NULL
    else
      Result := StringToGUID(Query.Fields.AsString[Champ]);
  except
    Result := GUID_NULL;
  end;
end;

procedure TDaoLite.Prepare(Query: TUIBQuery);
begin
  Assert(FPreparedQuery = nil, 'Ne peut pas être préparée plusieurs fois');
  if not Assigned(cs) then
    cs := TCriticalSection.Create;
  cs.Enter;
  FPreparedQuery := Query;
  GetFieldIndices;
end;

procedure TDaoLite.Unprepare;
begin
  FPreparedQuery := nil;
  cs.Release;
end;

procedure TDaoLite.VideListe(LV: TListView; DoClear: Boolean);
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
    if DoClear then
      LV.Items.Clear;
    LV.Items.EndUpdate;
  end;
end;

procedure TDaoLite.VideListe(List: TList<TBasePointeur>; DoClear: Boolean);
var
  i: Integer;
begin
  try
    for i := 0 to Pred(List.Count) do
      List[i].Free;
  finally
    if DoClear then
      List.Clear;
  end;
end;

procedure TDaoLite.VideListe(ListBox: TListBox; DoClear: Boolean);
var
  i: Integer;
begin
  try
    for i := 0 to Pred(ListBox.Items.Count) do
    begin
      ListBox.Items.Objects[i].Free;
    end;
  finally
    if DoClear then
      ListBox.Items.Clear;
  end;
end;

function TDaoLite.NonNull(Query: TUIBQuery; Champ, Default: Integer): Integer;
begin
  try
    if (Champ = -1) or Query.Fields.IsNull[Champ] then
      Result := Default
    else
      Result := Query.Fields.AsInteger[Champ];
  except
    Result := Default;
  end;
end;

{ TDaoCouvertureLite }

function TDaoCouvertureLite.Duplicate(Ps: TCouvertureLite): TCouvertureLite;
begin
  Result := inherited Duplicate(Ps) as TCouvertureLite;
end;

function TDaoCouvertureLite.EntityClass: TBasePointeurClass;
begin
  Result := TCouvertureLite;
end;

procedure TDaoCouvertureLite.Fill(Entity: TCouvertureLite; Query: TUIBQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Couverture');
  Entity.OldNom := Query.Fields.ByNameAsString['FichierCouverture'];
  Entity.NewNom := Entity.OldNom;
  Entity.OldStockee := Query.Fields.ByNameAsBoolean['STOCKAGECOUVERTURE'];
  Entity.NewStockee := Entity.OldStockee;
  Entity.Categorie := Query.Fields.ByNameAsSmallint['CategorieImage'];
  Entity.sCategorie := Query.Fields.ByNameAsString['sCategorieImage'];
end;

procedure TDaoCouvertureLite.FillList(List: TList<TCouvertureLite>; Query: TUIBQuery);
begin
  inherited FillList<TCouvertureLite>(List, Query);
end;

function TDaoCouvertureLite.Make(Query: TUIBQuery): TCouvertureLite;
begin
  Result := inherited Make(Query) as TCouvertureLite;
end;

{ TDaoConversionLite }

function TDaoConversionLite.Duplicate(Ps: TConversionLite): TConversionLite;
begin
  Result := inherited Duplicate(Ps) as TConversionLite;
end;

function TDaoConversionLite.EntityClass: TBasePointeurClass;
begin
  Result := TConversionLite;
end;

procedure TDaoConversionLite.Fill(Entity: TConversionLite; Query: TUIBQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Conversion');
  Entity.Monnaie1 := Query.Fields.ByNameAsString['Monnaie1'];
  Entity.Monnaie2 := Query.Fields.ByNameAsString['Monnaie2'];
  Entity.Taux := Query.Fields.ByNameAsDouble['Taux'];
end;

procedure TDaoConversionLite.FillList(List: TList<TConversionLite>; Query: TUIBQuery);
begin
  inherited FillList<TConversionLite>(List, Query);
end;

function TDaoConversionLite.Make(Query: TUIBQuery): TConversionLite;
begin
  Result := inherited Make(Query) as TConversionLite;
end;

{ TDaoEditeurLite }

function TDaoEditeurLite.Duplicate(Ps: TEditeurLite): TEditeurLite;
begin
  Result := inherited Duplicate(Ps) as TEditeurLite;
end;

function TDaoEditeurLite.EntityClass: TBasePointeurClass;
begin
  Result := TEditeurLite;
end;

procedure TDaoEditeurLite.FillEx(Entity: TEditeurLite; const ID_Editeur: TGUID);
var
  qry: TUIBQuery;
begin
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := GetTransaction(dmPrinc.UIBDataBase);
    qry.SQL.Text := 'SELECT NOMEDITEUR, ID_Editeur FROM EDITEURS WHERE ID_Editeur = ?';
    qry.Params.AsString[0] := GUIDToString(ID_Editeur);
    qry.Open;
    Fill(Entity, qry);
  finally
    qry.Transaction.Free;
    qry.Free;
  end;
end;

procedure TDaoEditeurLite.FillList(List: TList<TEditeurLite>; Query: TUIBQuery);
begin
  inherited FillList<TEditeurLite>(List, Query);
end;

function TDaoEditeurLite.Make(Query: TUIBQuery): TEditeurLite;
begin
  Result := inherited Make(Query) as TEditeurLite;
end;

procedure TDaoEditeurLite.Fill(Entity: TEditeurLite; Query: TUIBQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Editeur');
  Entity.NomEditeur := Query.Fields.ByNameAsString['NomEditeur'];
end;

{ TDaoPersonnageLite }

procedure TDaoPersonnageLite.Fill(Entity: TPersonnageLite; Query: TUIBQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Personne');
  Entity.Nom := Query.Fields.ByNameAsString['NomPersonne'];
end;

function TDaoPersonnageLite.Duplicate(Ps: TPersonnageLite): TPersonnageLite;
begin
  Result := inherited Duplicate(Ps) as TPersonnageLite;
end;

function TDaoPersonnageLite.EntityClass: TBasePointeurClass;
begin
  Result := TPersonnageLite;
end;

procedure TDaoPersonnageLite.FillEx(Entity: TPersonnageLite; const ID_Personne: TGUID);
var
  qry: TUIBQuery;
begin
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := GetTransaction(dmPrinc.UIBDataBase);
    qry.SQL.Text := 'select nompersonne, id_personne from personnes where id_personne = ?';
    qry.Params.AsString[0] := GUIDToString(ID_Personne);
    qry.Open;
    Fill(Entity, qry);
  finally
    qry.Transaction.Free;
    qry.Free;
  end;
end;

procedure TDaoPersonnageLite.FillList(List: TList<TPersonnageLite>; Query: TUIBQuery);
begin
  inherited FillList<TPersonnageLite>(List, Query);
end;

function TDaoPersonnageLite.Make(Query: TUIBQuery): TPersonnageLite;
begin
  Result := inherited Make(Query) as TPersonnageLite;
end;

{ TDaoAuteurLite }

procedure TDaoAuteurLite.Fill(Entity: TAuteurLite; Query: TUIBQuery);
var
  PPersonne: TPersonnageLite;
begin
  PPersonne := TDaoLiteFactory.PersonnageLite.Make(Query);
  try
    FillEx(Entity, PPersonne, NonNull(Query, 'ID_Album'), NonNull(Query, 'ID_Serie'), TMetierAuteur(Query.Fields.ByNameAsInteger['Metier']));
  finally
    PPersonne.Free;
  end;
end;

function TDaoAuteurLite.Duplicate(Ps: TAuteurLite): TAuteurLite;
begin
  Result := inherited Duplicate(Ps) as TAuteurLite;
end;

function TDaoAuteurLite.EntityClass: TBasePointeurClass;
begin
  Result := TAuteurLite;
end;

procedure TDaoAuteurLite.FillEx(Entity: TAuteurLite; Pe: TPersonnageLite; const ReferenceAlbum, ReferenceSerie: TGUID; Metier: TMetierAuteur);
begin
  Entity.Personne.Assign(Pe);
  Entity.ID_Album := ReferenceAlbum;
  Entity.Metier := Metier;
end;

procedure TDaoAuteurLite.FillList(List: TList<TAuteurLite>; Query: TUIBQuery);
begin
  inherited FillList<TAuteurLite>(List, Query);
end;

function TDaoAuteurLite.Make(Query: TUIBQuery): TAuteurLite;
begin
  Result := inherited Make(Query) as TAuteurLite;
end;

{ TDaoAlbumLite }

procedure TDaoAlbumLite.Fill(Entity: TAlbumLite; Query: TUIBQuery);
begin
  TAlbumLite(Entity).Serie := '';
  TAlbumLite(Entity).Editeur := '';
  TAlbumLite(Entity).MoisParution := 0;
  TAlbumLite(Entity).AnneeParution := 0;
  TAlbumLite(Entity).Stock := True;
  TAlbumLite(Entity).Achat := False;
  TAlbumLite(Entity).Complet := True;
  TAlbumLite(Entity).Notation := 900;

  if Assigned(FPreparedQuery) then
  begin
    TAlbumLite(Entity).ID := NonNull(Query, IndexID_Album);
    TAlbumLite(Entity).Titre := Query.Fields.AsString[IndexTitreAlbum];
    TAlbumLite(Entity).Tome := Query.Fields.AsInteger[IndexTome];
    TAlbumLite(Entity).TomeDebut := Query.Fields.AsInteger[IndexTomeDebut];
    TAlbumLite(Entity).TomeFin := Query.Fields.AsInteger[IndexTomeFin];
    TAlbumLite(Entity).ID_Serie := NonNull(Query, IndexID_Serie);
    TAlbumLite(Entity).Integrale := Query.Fields.AsBoolean[IndexIntegrale];
    TAlbumLite(Entity).HorsSerie := Query.Fields.AsBoolean[IndexHorsSerie];
    TAlbumLite(Entity).ID_Editeur := NonNull(Query, IndexID_Editeur);
    if IndexTitreSerie <> -1 then
      TAlbumLite(Entity).Serie := Query.Fields.AsString[IndexTitreSerie];
    if IndexNomEditeur <> -1 then
      TAlbumLite(Entity).Editeur := Query.Fields.AsString[IndexNomEditeur];
    if IndexMoisParution <> -1 then
      TAlbumLite(Entity).MoisParution := Query.Fields.AsInteger[IndexMoisParution];
    if IndexAnneeParution <> -1 then
      TAlbumLite(Entity).AnneeParution := Query.Fields.AsInteger[IndexAnneeParution];
    if IndexStock <> -1 then
      TAlbumLite(Entity).Stock := Query.Fields.AsBoolean[IndexStock];
    if IndexAchat <> -1 then
      TAlbumLite(Entity).Achat := Query.Fields.AsBoolean[IndexAchat];
    if IndexComplet <> -1 then
      TAlbumLite(Entity).Complet := Query.Fields.AsBoolean[IndexComplet];
    if IndexNotation <> -1 then
      TAlbumLite(Entity).Notation := Query.Fields.AsSmallint[IndexNotation];
  end
  else
  begin
    TAlbumLite(Entity).ID := NonNull(Query, 'ID_Album');
    TAlbumLite(Entity).Titre := Query.Fields.ByNameAsString['TitreAlbum'];
    TAlbumLite(Entity).Tome := Query.Fields.ByNameAsInteger['Tome'];
    TAlbumLite(Entity).TomeDebut := Query.Fields.ByNameAsInteger['TomeDebut'];
    TAlbumLite(Entity).TomeFin := Query.Fields.ByNameAsInteger['TomeFin'];
    TAlbumLite(Entity).ID_Serie := NonNull(Query, 'ID_Serie');
    TAlbumLite(Entity).Integrale := Query.Fields.ByNameAsBoolean['Integrale'];
    TAlbumLite(Entity).HorsSerie := Query.Fields.ByNameAsBoolean['HorsSerie'];
    TAlbumLite(Entity).ID_Editeur := NonNull(Query, 'ID_Editeur');
    try
      TAlbumLite(Entity).Serie := Query.Fields.ByNameAsString['TitreSerie'];
    except
    end;
    try
      TAlbumLite(Entity).Editeur := Query.Fields.ByNameAsString['NomEditeur'];
    except
    end;
    try
      TAlbumLite(Entity).MoisParution := Query.Fields.ByNameAsInteger['MoisParution'];
    except
    end;
    try
      TAlbumLite(Entity).AnneeParution := Query.Fields.ByNameAsInteger['AnneeParution'];
    except
    end;
    try
      TAlbumLite(Entity).Stock := Query.Fields.ByNameAsBoolean['Stock'];
    except
    end;
    try
      TAlbumLite(Entity).Achat := Query.Fields.ByNameAsBoolean['Achat'];
    except
    end;
    try
      TAlbumLite(Entity).Complet := Query.Fields.ByNameAsBoolean['Complet'];
    except
    end;
    try
      TAlbumLite(Entity).Notation := Query.Fields.ByNameAsSmallint['Notation'];
    except
    end;
  end;

  if TAlbumLite(Entity).Notation = 0 then
    TAlbumLite(Entity).Notation := 900;
end;

procedure TDaoAlbumLite.FillEx(Entity: TAlbumLite; const ID_Album: TGUID);
begin
  FillEx(Entity, ID_Album, GUID_NULL);
end;

function TDaoAlbumLite.Duplicate(Ps: TAlbumLite): TAlbumLite;
begin
  Result := inherited Duplicate(Ps) as TAlbumLite;
end;

function TDaoAlbumLite.EntityClass: TBasePointeurClass;
begin
  Result := TAlbumLite;
end;

procedure TDaoAlbumLite.FillEx(Entity: TAlbumLite; const ID_Album, ID_Edition: TGUID);
var
  qry: TUIBQuery;
begin
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := GetTransaction(dmPrinc.UIBDataBase);
    qry.SQL.Text := 'select a.id_album, a.titrealbum, a.horsserie, a.integrale, a.tome, a.tomedebut, a.tomefin, a.id_serie, a.achat, a.complet, a.titreserie';
    qry.SQL.Add('from vw_liste_albums a');
    qry.SQL.Add('where a.id_album = :id_album');
    if not IsEqualGUID(ID_Edition, GUID_NULL) then
    begin
      qry.SQL[0] := qry.SQL[0] + ', e.stock';
      qry.SQL[1] := qry.SQL[1] + ' inner join editions e on a.id_album = e.id_album';
      qry.SQL.Add('and e.id_edition = :id_edition');
    end;
    qry.Params.AsString[0] := GUIDToString(ID_Album);
    if not IsEqualGUID(ID_Edition, GUID_NULL) then
      qry.Params.AsString[1] := GUIDToString(ID_Edition);
    qry.Open;
    Fill(Entity, qry);
  finally
    qry.Transaction.Free;
    qry.Free;
  end;
end;

procedure TDaoAlbumLite.FillList(List: TList<TAlbumLite>; Query: TUIBQuery);
begin
  inherited FillList<TAlbumLite>(List, Query);
end;

procedure TDaoAlbumLite.GetFieldIndices;
begin
  inherited;
  IndexID_Album := GetFieldIndex('ID_Album');
  IndexTitreAlbum := GetFieldIndex('TitreAlbum');
  IndexTome := GetFieldIndex('Tome');
  IndexTomeDebut := GetFieldIndex('TomeDebut');
  IndexTomeFin := GetFieldIndex('TomeFin');
  IndexID_Serie := GetFieldIndex('ID_Serie');
  IndexIntegrale := GetFieldIndex('Integrale');
  IndexHorsSerie := GetFieldIndex('HorsSerie');
  IndexID_Editeur := GetFieldIndex('ID_Editeur');
  IndexTitreSerie := GetFieldIndex('TitreSerie');
  IndexNomEditeur := GetFieldIndex('NomEditeur');
  IndexMoisParution := GetFieldIndex('MoisParution');
  IndexAnneeParution := GetFieldIndex('AnneeParution');
  IndexStock := GetFieldIndex('Stock');
  IndexAchat := GetFieldIndex('Achat');
  IndexComplet := GetFieldIndex('Complet');
  IndexNotation := GetFieldIndex('Notation');
end;

function TDaoAlbumLite.Make(Query: TUIBQuery): TAlbumLite;
begin
  Result := inherited Make(Query) as TAlbumLite;
end;

{ TDaoCollectionLite }

procedure TDaoCollectionLite.Fill(Entity: TCollectionLite; Query: TUIBQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Collection');
  Entity.NomCollection := Query.Fields.ByNameAsString['NomCollection'];
  try
    TDaoLiteFactory.EditeurLite.Fill(Entity.Editeur, Query);
  except
    Entity.Editeur.Clear;
  end;
end;

function TDaoCollectionLite.Duplicate(Ps: TCollectionLite): TCollectionLite;
begin
  Result := inherited Duplicate(Ps) as TCollectionLite;
end;

function TDaoCollectionLite.EntityClass: TBasePointeurClass;
begin
  Result := TCollectionLite;
end;

procedure TDaoCollectionLite.FillEx(Entity: TCollectionLite; const ID_Collection: TGUID);
var
  qry: TUIBQuery;
begin
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := GetTransaction(dmPrinc.UIBDataBase);
    qry.SQL.Text := 'select id_collection, nomcollection from collections where id_collection = ?';
    qry.Params.AsString[0] := GUIDToString(ID_Collection);
    qry.Open;
    Fill(Entity, qry);
  finally
    qry.Transaction.Free;
    qry.Free;
  end;
end;

procedure TDaoCollectionLite.FillList(List: TList<TCollectionLite>; Query: TUIBQuery);
begin
  inherited FillList<TCollectionLite>(List, Query);
end;

function TDaoCollectionLite.Make(Query: TUIBQuery): TCollectionLite;
begin
  Result := inherited Make(Query) as TCollectionLite;
end;

{ TDaoSerieLite }

procedure TDaoSerieLite.Fill(Entity: TSerieLite; Query: TUIBQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Serie');
  Entity.TitreSerie := Query.Fields.ByNameAsString['TitreSerie'];
  try
    TDaoLiteFactory.EditeurLite.Fill(Entity.Editeur, Query);
  except
    Entity.Editeur.Clear;
  end;
  try
    TDaoLiteFactory.CollectionLite.Fill(Entity.Collection, Query);
  except
    Entity.Collection.Clear;
  end;
end;

function TDaoSerieLite.Duplicate(Ps: TSerieLite): TSerieLite;
begin
  Result := inherited Duplicate(Ps) as TSerieLite;
end;

function TDaoSerieLite.EntityClass: TBasePointeurClass;
begin
  Result := TSerieLite;
end;

procedure TDaoSerieLite.FillEx(Entity: TSerieLite; const ID_Serie: TGUID);
var
  qry: TUIBQuery;
begin
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := GetTransaction(dmPrinc.UIBDataBase);
    qry.SQL.Text := 'select id_serie, titreserie from series where id_serie = :id_serie';
    qry.Params.AsString[0] := GUIDToString(ID_Serie);
    qry.Open;
    Fill(Entity, qry);
  finally
    qry.Transaction.Free;
    qry.Free;
  end;
end;

procedure TDaoSerieLite.FillList(List: TList<TSerieLite>; Query: TUIBQuery);
begin
  inherited FillList<TSerieLite>(List, Query);
end;

function TDaoSerieLite.Make(Query: TUIBQuery): TSerieLite;
begin
  Result := inherited Make(Query) as TSerieLite;
end;

{ TDaoEditionLite }

function TDaoEditionLite.Duplicate(Ps: TEditionLite): TEditionLite;
begin
  Result := inherited Duplicate(Ps) as TEditionLite;
end;

function TDaoEditionLite.EntityClass: TBasePointeurClass;
begin
  Result := TEditionLite;
end;

procedure TDaoEditionLite.Fill(Entity: TEditionLite; Query: TUIBQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Edition');
  Entity.AnneeEdition := Query.Fields.ByNameAsInteger['AnneeEdition'];
  try
    Entity.ISBN := Trim(Query.Fields.ByNameAsString['ISBN']);
  except
    Entity.ISBN := '';
  end;
  TDaoLiteFactory.EditeurLite.Fill(Entity.Editeur, Query);
  TDaoLiteFactory.CollectionLite.Fill(Entity.Collection, Query);
end;

procedure TDaoEditionLite.FillList(List: TList<TEditionLite>; Query: TUIBQuery);
begin
  inherited FillList<TEditionLite>(List, Query);
end;

function TDaoEditionLite.Make(Query: TUIBQuery): TEditionLite;
begin
  Result := inherited Make(Query) as TEditionLite;
end;

{ TDaoGenreLite }

function TDaoGenreLite.Duplicate(Ps: TGenreLite): TGenreLite;
begin
  Result := inherited Duplicate(Ps) as TGenreLite;
end;

function TDaoGenreLite.EntityClass: TBasePointeurClass;
begin
  Result := TGenreLite;
end;

procedure TDaoGenreLite.Fill(Entity: TGenreLite; Query: TUIBQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Genre');
  Entity.Genre := Query.Fields.ByNameAsString['Genre'];
  try
    Entity.Quantite := Query.Fields.ByNameAsInteger['QuantiteGenre'];
  except
    Entity.Quantite := 0;
  end;
end;

procedure TDaoGenreLite.FillList(List: TList<TGenreLite>; Query: TUIBQuery);
begin
  inherited FillList<TGenreLite>(List, Query);
end;

function TDaoGenreLite.Make(Query: TUIBQuery): TGenreLite;
begin
  Result := inherited Make(Query) as TGenreLite;
end;

{ TDaoParaBDLite }

function TDaoParaBDLite.Duplicate(Ps: TParaBDLite): TParaBDLite;
begin
  Result := inherited Duplicate(Ps) as TParaBDLite;
end;

function TDaoParaBDLite.EntityClass: TBasePointeurClass;
begin
  Result := TParaBDLite;
end;

procedure TDaoParaBDLite.Fill(Entity: TParaBDLite; Query: TUIBQuery);
begin
  Entity.ID := NonNull(Query, 'ID_ParaBD');
  Entity.Titre := Query.Fields.ByNameAsString['TitreParaBD'];
  Entity.ID_Serie := NonNull(Query, 'ID_Serie');
  try
    Entity.Serie := Query.Fields.ByNameAsString['TitreSerie'];
  except
    Entity.Serie := '';
  end;
  try
    Entity.Achat := Query.Fields.ByNameAsBoolean['Achat'];
  except
    Entity.Achat := False;
  end;
  try
    Entity.Complet := Query.Fields.ByNameAsBoolean['Complet'];
  except
    Entity.Complet := True;
  end;
  try
    Entity.sCategorie := Query.Fields.ByNameAsString['sCategorie'];
  except
    Entity.sCategorie := '';
  end;
end;

procedure TDaoParaBDLite.FillList(List: TList<TParaBDLite>; Query: TUIBQuery);
begin
  inherited FillList<TParaBDLite>(List, Query);
end;

function TDaoParaBDLite.Make(Query: TUIBQuery): TParaBDLite;
begin
  Result := inherited Make(Query) as TParaBDLite;
end;

{ TDaoUniversLite }

procedure TDaoUniversLite.Fill(Entity: TUniversLite; Query: TUIBQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Univers');
  Entity.NomUnivers := Query.Fields.ByNameAsString['NomUnivers'];
end;

function TDaoUniversLite.Duplicate(Ps: TUniversLite): TUniversLite;
begin
  Result := inherited Duplicate(Ps) as TUniversLite;
end;

function TDaoUniversLite.EntityClass: TBasePointeurClass;
begin
  Result := TUniversLite;
end;

procedure TDaoUniversLite.FillEx(Entity: TUniversLite; const ID_Univers: TGUID);
var
  qry: TUIBQuery;
begin
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := GetTransaction(dmPrinc.UIBDataBase);
    qry.SQL.Text := 'select nomunivers, id_univers from univers where id_univers = ?';
    qry.Params.AsString[0] := GUIDToString(ID_Univers);
    qry.Open;
    Fill(Entity, qry);
  finally
    qry.Transaction.Free;
    qry.Free;
  end;
end;

procedure TDaoUniversLite.FillList(List: TList<TUniversLite>; Query: TUIBQuery);
begin
  inherited FillList<TUniversLite>(List, Query);
end;

function TDaoUniversLite.Make(Query: TUIBQuery): TUniversLite;
begin
  Result := inherited Make(Query) as TUniversLite;
end;

{ TDaoLiteFactory }

class function TDaoLiteFactory.AlbumLite: TDaoAlbumLite;
begin
  Result := getInstance(TDaoAlbumLite) as TDaoAlbumLite;
end;

class function TDaoLiteFactory.AuteurLite: TDaoAuteurLite;
begin
  Result := getInstance(TDaoAuteurLite) as TDaoAuteurLite;
end;

class function TDaoLiteFactory.CollectionLite: TDaoCollectionLite;
begin
  Result := getInstance(TDaoCollectionLite) as TDaoCollectionLite;
end;

class function TDaoLiteFactory.ConversionLite: TDaoConversionLite;
begin
  Result := getInstance(TDaoConversionLite) as TDaoConversionLite;
end;

class function TDaoLiteFactory.CouvertureLite: TDaoCouvertureLite;
begin
  Result := getInstance(TDaoCouvertureLite) as TDaoCouvertureLite;
end;

class constructor TDaoLiteFactory.Create;
begin
  FDaoInstances := TDictionary<TClassDaoLite, TDaoLite>.Create;
end;

class destructor TDaoLiteFactory.Destroy;
begin
  FDaoInstances.Free;
end;

class function TDaoLiteFactory.EditeurLite: TDaoEditeurLite;
begin
  Result := getInstance(TDaoEditeurLite) as TDaoEditeurLite;
end;

class function TDaoLiteFactory.GenreLite: TDaoGenreLite;
begin
  Result := getInstance(TDaoGenreLite) as TDaoGenreLite;
end;

class function TDaoLiteFactory.getInstance(c: TClassDaoLite): TDaoLite;
begin
  if not FDaoInstances.TryGetValue(c, Result) then
  begin
    Result := c.Create;
    FDaoInstances.AddOrSetValue(c, Result);
  end;
end;

class function TDaoLiteFactory.ParaBDLite: TDaoParaBDLite;
begin
  Result := getInstance(TDaoParaBDLite) as TDaoParaBDLite;
end;

class function TDaoLiteFactory.PersonnageLite: TDaoPersonnageLite;
begin
  Result := getInstance(TDaoPersonnageLite) as TDaoPersonnageLite;
end;

class function TDaoLiteFactory.SerieLite: TDaoSerieLite;
begin
  Result := getInstance(TDaoSerieLite) as TDaoSerieLite;
end;

class function TDaoLiteFactory.UniversLite: TDaoUniversLite;
begin
  Result := getInstance(TDaoUniversLite) as TDaoUniversLite;
end;

end.
