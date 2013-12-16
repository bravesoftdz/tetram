unit DaoLite;

interface

uses
  System.SysUtils, uib, EntitiesLite, UMetadata, System.Generics.Collections,
  System.SyncObjs, Vcl.ComCtrls, Vcl.StdCtrls, System.Classes;

type
  // ce serait trop facile si XE4 acceptait cette syntaxe....
  // TClassDaoLite = class of TDaoLite<>;
  // je suis donc obligé de faire des classes "classique"
  TDaoLiteClass = class of TDaoLite;

  TDaoLite = class abstract
  private
    class var cs: TCriticalSection;
    class var FPreparedQuery: TUIBQuery;

    class function NonNull(Query: TUIBQuery; const Champ: string; Default: Integer): Integer; overload; inline;
    class function NonNull(Query: TUIBQuery; const Champ: string): TGUID; overload; inline;
    class function NonNull(Query: TUIBQuery; Champ, Default: Integer): Integer; overload; inline;
    class function NonNull(Query: TUIBQuery; Champ: Integer): TGUID; overload; inline;

    class procedure GetFieldIndices; virtual;
    class function GetFieldIndex(const Name: string): Integer;

    class function EntityClass: TBasePointeurClass; virtual; abstract;
  public
    class constructor Create;
    class destructor Destroy;

    class procedure Prepare(Query: TUIBQuery);
    class procedure Unprepare;

    class function Make(Query: TUIBQuery): TBasePointeur;
    class function Duplicate(Ps: TBasePointeur): TBasePointeur;

    class procedure Fill(Entity: TBasePointeur; Query: TUIBQuery); virtual; abstract;
    class procedure FillList(List: TList<TBasePointeur>; Query: TUIBQuery);

    class procedure VideListe(LV: TListView; DoClear: Boolean = True); overload;
    class procedure VideListe(List: TList<TBasePointeur>; DoClear: Boolean = True); overload;
    class procedure VideListe(ListBox: TListBox; DoClear: Boolean = True); overload;
  end;

  TDaoLiteEntity<T: TBasePointeur> = class abstract(TDaoLite)
    class function Make(Query: TUIBQuery): T; reintroduce;
    class function Duplicate(Ps: T): T; reintroduce;

    class procedure Fill(Entity: TBasePointeur; Query: TUIBQuery); overload; override;
    class procedure Fill(Entity: T; Query: TUIBQuery); reintroduce; overload; virtual; abstract;
    class procedure FillList(List: TList<T>; Query: TUIBQuery);
    class procedure VideListe(List: TList<T>; DoClear: Boolean = True); overload;
  end;

  TDaoAlbumLite = class(TDaoLiteEntity<TAlbumLite>)
  strict private
    class var IndexID_Album: Integer;
    class var IndexTome: Integer;
    class var IndexTomeDebut: Integer;
    class var IndexTomeFin: Integer;
    class var IndexTitreAlbum: Integer;
    class var IndexID_Serie: Integer;
    class var IndexTitreSerie: Integer;
    class var IndexID_Editeur: Integer;
    class var IndexNomEditeur: Integer;
    class var IndexAnneeParution, IndexMoisParution: Integer;
    class var IndexStock: Integer;
    class var IndexIntegrale: Integer;
    class var IndexHorsSerie: Integer;
    class var IndexAchat: Integer;
    class var IndexComplet: Integer;
    class var IndexNotation: Integer;
  private
    class function EntityClass: TBasePointeurClass; override;
    class procedure GetFieldIndices; override;
  public
    class procedure Fill(Entity: TAlbumLite; Query: TUIBQuery); overload; override;
    class procedure Fill(Entity: TAlbumLite; const ID_Album: TGUID); overload;
    class procedure Fill(Entity: TAlbumLite; const ID_Album, ID_Edition: TGUID); overload;
  end;

  TDaoParaBDLite = class(TDaoLiteEntity<TParaBDLite>)
  private
    class function EntityClass: TBasePointeurClass; override;
  public
    class procedure Fill(Entity: TParaBDLite; Query: TUIBQuery); override;
  end;

  TDaoSerieLite = class(TDaoLiteEntity<TSerieLite>)
  private
    class function EntityClass: TBasePointeurClass; override;
  public
    class procedure Fill(Entity: TSerieLite; Query: TUIBQuery); overload; override;
    class procedure Fill(Entity: TSerieLite; const ID_Serie: TGUID); overload;
  end;

  TDaoEditionLite = class(TDaoLiteEntity<TEditionLite>)
  private
    class function EntityClass: TBasePointeurClass; override;
  public
    class procedure Fill(Entity: TEditionLite; Query: TUIBQuery); override;
  end;

  TDaoEditeurLite = class(TDaoLiteEntity<TEditeurLite>)
  private
    class function EntityClass: TBasePointeurClass; override;
  public
    class procedure Fill(Entity: TEditeurLite; Query: TUIBQuery); overload; override;
    class procedure Fill(Entity: TEditeurLite; const ID_Editeur: TGUID); overload;
  end;

  TDaoCollectionLite = class(TDaoLiteEntity<TCollectionLite>)
  private
    class function EntityClass: TBasePointeurClass; override;
  public
    class procedure Fill(Entity: TCollectionLite; Query: TUIBQuery); overload; override;
    class procedure Fill(Entity: TCollectionLite; const ID_Collection: TGUID); overload;
  end;

  TDaoPersonnageLite = class(TDaoLiteEntity<TPersonnageLite>)
  private
    class function EntityClass: TBasePointeurClass; override;
  public
    class procedure Fill(Entity: TPersonnageLite; Query: TUIBQuery); overload; override;
    class procedure Fill(Entity: TPersonnageLite; const ID_Personne: TGUID); overload;
  end;

  TDaoAuteurLite = class(TDaoLiteEntity<TAuteurLite>)
  private
    class function EntityClass: TBasePointeurClass; override;
  public
    class procedure Fill(Entity: TAuteurLite; Query: TUIBQuery); overload; override;
    class procedure Fill(Entity: TAuteurLite; Pe: TPersonnageLite; const ReferenceAlbum, ReferenceSerie: TGUID; Metier: TMetierAuteur); overload;
  end;

  TDaoUniversLite = class(TDaoLiteEntity<TUniversLite>)
  private
    class function EntityClass: TBasePointeurClass; override;
  public
    class procedure Fill(Entity: TUniversLite; Query: TUIBQuery); overload; override;
    class procedure Fill(Entity: TUniversLite; const ID_Univers: TGUID); overload;
  end;

  TDaoCouvertureLite = class(TDaoLiteEntity<TCouvertureLite>)
  private
    class function EntityClass: TBasePointeurClass; override;
  public
    class procedure Fill(Entity: TCouvertureLite; Query: TUIBQuery); override;
  end;

  TDaoGenreLite = class(TDaoLiteEntity<TGenreLite>)
  private
    class function EntityClass: TBasePointeurClass; override;
  public
    class procedure Fill(Entity: TGenreLite; Query: TUIBQuery); override;
  end;

  TDaoConversionLite = class(TDaoLiteEntity<TConversionLite>)
  private
    class function EntityClass: TBasePointeurClass; override;
  public
    class procedure Fill(Entity: TConversionLite; Query: TUIBQuery); override;
  end;

implementation

uses
  Commun, UdmPrinc, uiblib;

{ TDaoLite<T> }

class function TDaoLite.NonNull(Query: TUIBQuery; const Champ: string): TGUID;
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

class function TDaoLite.NonNull(Query: TUIBQuery; const Champ: string; Default: Integer): Integer;
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

class constructor TDaoLite.Create;
begin
  cs := nil;
end;

class destructor TDaoLite.Destroy;
begin
  cs.Free;
end;

class function TDaoLite.Duplicate(Ps: TBasePointeur): TBasePointeur;
begin
  Assert(Ps is EntityClass);
  Result := EntityClass.Create;
  Result.Assign(Ps);
end;

class procedure TDaoLite.FillList(List: TList<TBasePointeur>; Query: TUIBQuery);
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

class function TDaoLite.GetFieldIndex(const Name: string): Integer;
begin
  for Result := 0 to Pred(FPreparedQuery.Fields.FieldCount) do
    if SameText(FPreparedQuery.Fields.AliasName[Result], Name) then
      Exit;
  Result := -1;
end;

class procedure TDaoLite.GetFieldIndices;
begin
  Assert(FPreparedQuery <> nil, 'Doit être préparé avant');
end;

class function TDaoLite.Make(Query: TUIBQuery): TBasePointeur;
begin
  Result := EntityClass.Create;
  Fill(Result, Query);
end;

class function TDaoLite.NonNull(Query: TUIBQuery; Champ: Integer): TGUID;
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

class procedure TDaoLite.Prepare(Query: TUIBQuery);
begin
  Assert(FPreparedQuery = nil, 'Ne peut pas être préparée plusieurs fois');
  if not Assigned(cs) then
    cs := TCriticalSection.Create;
  cs.Enter;
  FPreparedQuery := Query;
  GetFieldIndices;
end;

class procedure TDaoLite.Unprepare;
begin
  FPreparedQuery := nil;
  cs.Release;
end;

class procedure TDaoLite.VideListe(LV: TListView; DoClear: Boolean);
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

class procedure TDaoLite.VideListe(List: TList<TBasePointeur>; DoClear: Boolean);
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

class procedure TDaoLite.VideListe(ListBox: TListBox; DoClear: Boolean);
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

class function TDaoLite.NonNull(Query: TUIBQuery; Champ, Default: Integer): Integer;
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

{ TDaoLiteEntity<T> }

class function TDaoLiteEntity<T>.Duplicate(Ps: T): T;
begin
  Result := inherited Duplicate(Ps) as T;
end;

class procedure TDaoLiteEntity<T>.Fill(Entity: TBasePointeur; Query: TUIBQuery);
begin
  Fill(T(Entity), Query);
end;

class procedure TDaoLiteEntity<T>.FillList(List: TList<T>; Query: TUIBQuery);
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

class function TDaoLiteEntity<T>.Make(Query: TUIBQuery): T;
begin
  Result := T(inherited Make(Query));
end;

class procedure TDaoLiteEntity<T>.VideListe(List: TList<T>; DoClear: Boolean);
begin
  inherited VideListe(TList<TBasePointeur>(List), DoClear);
end;

{ TDaoCouvertureLite }

class function TDaoCouvertureLite.EntityClass: TBasePointeurClass;
begin
  Result := TCouvertureLite;
end;

class procedure TDaoCouvertureLite.Fill(Entity: TCouvertureLite; Query: TUIBQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Couverture');
  Entity.OldNom := Query.Fields.ByNameAsString['FichierCouverture'];
  Entity.NewNom := Entity.OldNom;
  Entity.OldStockee := Query.Fields.ByNameAsBoolean['STOCKAGECOUVERTURE'];
  Entity.NewStockee := Entity.OldStockee;
  Entity.Categorie := Query.Fields.ByNameAsSmallint['CategorieImage'];
  Entity.sCategorie := Query.Fields.ByNameAsString['sCategorieImage'];
end;

{ TDaoConversionLite }

class function TDaoConversionLite.EntityClass: TBasePointeurClass;
begin
  Result := TConversionLite;
end;

class procedure TDaoConversionLite.Fill(Entity: TConversionLite; Query: TUIBQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Conversion');
  Entity.Monnaie1 := Query.Fields.ByNameAsString['Monnaie1'];
  Entity.Monnaie2 := Query.Fields.ByNameAsString['Monnaie2'];
  Entity.Taux := Query.Fields.ByNameAsDouble['Taux'];
end;

{ TDaoEditeurLite }

class function TDaoEditeurLite.EntityClass: TBasePointeurClass;
begin
  Result := TEditeurLite;
end;

class procedure TDaoEditeurLite.Fill(Entity: TEditeurLite; const ID_Editeur: TGUID);
var
  qry: TUIBQuery;
begin
  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := GetTransaction(dmPrinc.UIBDataBase);
    qry.SQL.Text := 'select nomediteur, id_editeur from editeurs where id_editeur = ?';
    qry.Params.AsString[0] := GUIDToString(ID_Editeur);
    qry.Open;
    Fill(Entity, qry);
  finally
    qry.Transaction.Free;
    qry.Free;
  end;
end;

class procedure TDaoEditeurLite.Fill(Entity: TEditeurLite; Query: TUIBQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Editeur');
  Entity.NomEditeur := Query.Fields.ByNameAsString['NomEditeur'];
end;

{ TDaoPersonnageLite }

class procedure TDaoPersonnageLite.Fill(Entity: TPersonnageLite; Query: TUIBQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Personne');
  Entity.Nom := Query.Fields.ByNameAsString['NomPersonne'];
end;

class function TDaoPersonnageLite.EntityClass: TBasePointeurClass;
begin
  Result := TPersonnageLite;
end;

class procedure TDaoPersonnageLite.Fill(Entity: TPersonnageLite; const ID_Personne: TGUID);
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

{ TDaoAuteurLite }

class procedure TDaoAuteurLite.Fill(Entity: TAuteurLite; Query: TUIBQuery);
var
  PPersonne: TPersonnageLite;
begin
  PPersonne := TDaoPersonnageLite.Make(Query);
  try
    Fill(Entity, PPersonne, NonNull(Query, 'ID_Album'), NonNull(Query, 'ID_Serie'), TMetierAuteur(Query.Fields.ByNameAsInteger['Metier']));
  finally
    PPersonne.Free;
  end;
end;

class function TDaoAuteurLite.EntityClass: TBasePointeurClass;
begin
  Result := TAuteurLite;
end;

class procedure TDaoAuteurLite.Fill(Entity: TAuteurLite; Pe: TPersonnageLite; const ReferenceAlbum, ReferenceSerie: TGUID; Metier: TMetierAuteur);
begin
  Entity.Personne.Assign(Pe);
  Entity.ID_Album := ReferenceAlbum;
  Entity.Metier := Metier;
end;

{ TDaoAlbumLite }

class procedure TDaoAlbumLite.Fill(Entity: TAlbumLite; Query: TUIBQuery);
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

class procedure TDaoAlbumLite.Fill(Entity: TAlbumLite; const ID_Album: TGUID);
begin
  Fill(Entity, ID_Album, GUID_NULL);
end;

class function TDaoAlbumLite.EntityClass: TBasePointeurClass;
begin
  Result := TAlbumLite;
end;

class procedure TDaoAlbumLite.Fill(Entity: TAlbumLite; const ID_Album, ID_Edition: TGUID);
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

class procedure TDaoAlbumLite.GetFieldIndices;
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

{ TDaoCollectionLite }

class procedure TDaoCollectionLite.Fill(Entity: TCollectionLite; Query: TUIBQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Collection');
  Entity.NomCollection := Query.Fields.ByNameAsString['NomCollection'];
  try
    TDaoEditeurLite.Fill(Entity.Editeur, Query);
  except
    Entity.Editeur.Clear;
  end;
end;

class function TDaoCollectionLite.EntityClass: TBasePointeurClass;
begin
  Result := TCollectionLite;
end;

class procedure TDaoCollectionLite.Fill(Entity: TCollectionLite; const ID_Collection: TGUID);
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

{ TDaoSerieLite }

class procedure TDaoSerieLite.Fill(Entity: TSerieLite; Query: TUIBQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Serie');
  Entity.TitreSerie := Query.Fields.ByNameAsString['TitreSerie'];
  try
    TDaoEditeurLite.Fill(Entity.Editeur, Query);
  except
    Entity.Editeur.Clear;
  end;
  try
    TDaoCollectionLite.Fill(Entity.Collection, Query);
  except
    Entity.Collection.Clear;
  end;
end;

class function TDaoSerieLite.EntityClass: TBasePointeurClass;
begin
  Result := TSerieLite;
end;

class procedure TDaoSerieLite.Fill(Entity: TSerieLite; const ID_Serie: TGUID);
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

{ TDaoEditionLite }

class function TDaoEditionLite.EntityClass: TBasePointeurClass;
begin
  Result := TEditionLite;
end;

class procedure TDaoEditionLite.Fill(Entity: TEditionLite; Query: TUIBQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Edition');
  Entity.AnneeEdition := Query.Fields.ByNameAsInteger['AnneeEdition'];
  try
    Entity.ISBN := Trim(Query.Fields.ByNameAsString['ISBN']);
  except
    Entity.ISBN := '';
  end;
  TDaoEditeurLite.Fill(Entity.Editeur, Query);
  TDaoCollectionLite.Fill(Entity.Collection, Query);
end;

{ TDaoGenreLite }

class function TDaoGenreLite.EntityClass: TBasePointeurClass;
begin
  Result := TGenreLite;
end;

class procedure TDaoGenreLite.Fill(Entity: TGenreLite; Query: TUIBQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Genre');
  Entity.Genre := Query.Fields.ByNameAsString['Genre'];
  try
    Entity.Quantite := Query.Fields.ByNameAsInteger['QuantiteGenre'];
  except
    Entity.Quantite := 0;
  end;
end;

{ TDaoParaBDLite }

class function TDaoParaBDLite.EntityClass: TBasePointeurClass;
begin
  Result := TParaBDLite;
end;

class procedure TDaoParaBDLite.Fill(Entity: TParaBDLite; Query: TUIBQuery);
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

{ TDaoUniversLite }

class procedure TDaoUniversLite.Fill(Entity: TUniversLite; Query: TUIBQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Univers');
  Entity.NomUnivers := Query.Fields.ByNameAsString['NomUnivers'];
end;

class function TDaoUniversLite.EntityClass: TBasePointeurClass;
begin
  Result := TUniversLite;
end;

class procedure TDaoUniversLite.Fill(Entity: TUniversLite; const ID_Univers: TGUID);
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

end.
