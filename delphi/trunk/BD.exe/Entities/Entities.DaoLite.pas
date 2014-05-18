unit Entities.DaoLite;

interface

uses
  System.SysUtils, uib, Entities.Lite, UMetadata, System.Generics.Collections,
  System.SyncObjs, Vcl.ComCtrls, Vcl.StdCtrls, System.Classes, Entities.DaoCommon,
  Entities.Common, Entities.FactoriesCommon;

type
  // ce serait trop facile si XE4 acceptait cette syntaxe....
  // TClassEntities.DaoLite = class of TDaoLite<>;
  // je suis donc obligé de faire des classes "classique"
  TDaoLiteClass = class of TDaoLite;

  TDaoLite = class abstract(TDaoDBEntity)
  private
    class var cs: TCriticalSection;
    class var FPreparedQueries: TDictionary<TDaoLiteClass, TUIBQuery>;
    class function getPreparedQuery: TUIBQuery;

    class function NonNull(Query: TUIBQuery; const Champ: string; Default: Integer): Integer; overload; inline;
    class function NonNull(Query: TUIBQuery; const Champ: string): TGUID; overload; inline;
    class function NonNull(Query: TUIBQuery; Champ, Default: Integer): Integer; overload; inline;
    class function NonNull(Query: TUIBQuery; Champ: Integer): TGUID; overload; inline;

    class procedure GetFieldIndices; virtual;
    class function GetFieldIndex(const Name: string): Integer;
  public
    class constructor Create;
    class destructor Destroy;

    class procedure Prepare(Query: TUIBQuery);
    class procedure Unprepare(Query: TUIBQuery);

    class function Make(Query: TUIBQuery): TBaseLite;

    class procedure Fill(Entity: TBaseLite; Query: TUIBQuery); reintroduce; virtual; abstract;
    class procedure FillList(List: TList<TBaseLite>; Query: TUIBQuery);

    class procedure VideListe(LV: TListView; DoClear: Boolean = True); overload;
    class procedure VideListe(List: TList<TBaseLite>; DoClear: Boolean = True); overload;
    class procedure VideListe(ListBox: TListBox; DoClear: Boolean = True); overload;
  end;

  TDaoLiteEntity<T: TBaseLite> = class abstract(TDaoLite)
  public
    class function Make(Query: TUIBQuery): T; reintroduce;

    class procedure Fill(Entity: TBaseLite; Query: TUIBQuery); overload; override;
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
  protected
    class function FactoryClass: TFactoryClass; override;
  private
    class procedure GetFieldIndices; override;
  public
    class procedure Fill(Entity: TAlbumLite; Query: TUIBQuery); overload; override;
    class procedure Fill(Entity: TAlbumLite; const ID_Album: TGUID); overload;
    class procedure Fill(Entity: TAlbumLite; const ID_Album, ID_Edition: TGUID); overload;
  end;

  TDaoParaBDLite = class(TDaoLiteEntity<TParaBDLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class procedure Fill(Entity: TParaBDLite; Query: TUIBQuery); override;
  end;

  TDaoSerieLite = class(TDaoLiteEntity<TSerieLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class procedure Fill(Entity: TSerieLite; Query: TUIBQuery); overload; override;
    class procedure Fill(Entity: TSerieLite; const ID_Serie: TGUID); overload;
  end;

  TDaoEditionLite = class(TDaoLiteEntity<TEditionLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  private
    class procedure GetFieldIndices; override;
  public
    class procedure Fill(Entity: TEditionLite; Query: TUIBQuery); override;
  end;

  TDaoEditeurLite = class(TDaoLiteEntity<TEditeurLite>)
  strict private
    class var IndexID_Editeur: Integer;
    class var IndexNomEditeur: Integer;
  protected
    class function FactoryClass: TFactoryClass; override;
  private
    class procedure GetFieldIndices; override;
  public
    class procedure Fill(Entity: TEditeurLite; Query: TUIBQuery); overload; override;
    class procedure Fill(Entity: TEditeurLite; const ID_Editeur: TGUID); overload;
  end;

  TDaoCollectionLite = class(TDaoLiteEntity<TCollectionLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  private
    class procedure GetFieldIndices; override;
  public
    class procedure Fill(Entity: TCollectionLite; Query: TUIBQuery); overload; override;
    class procedure Fill(Entity: TCollectionLite; const ID_Collection: TGUID); overload;
  end;

  TDaoPersonnageLite = class(TDaoLiteEntity<TPersonnageLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class procedure Fill(Entity: TPersonnageLite; Query: TUIBQuery); overload; override;
    class procedure Fill(Entity: TPersonnageLite; const ID_Personne: TGUID); overload;
  end;

  TDaoAuteurSerieLite = class(TDaoLiteEntity<TAuteurSerieLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class procedure Fill(Entity: TAuteurSerieLite; Query: TUIBQuery); overload; override;
    class procedure Fill(Entity: TAuteurSerieLite; Pe: TPersonnageLite; const ReferenceSerie: TGUID; Metier: TMetierAuteur); overload;
  end;

  TDaoAuteurAlbumLite = class(TDaoLiteEntity<TAuteurAlbumLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class procedure Fill(Entity: TAuteurAlbumLite; Query: TUIBQuery); overload; override;
    class procedure Fill(Entity: TAuteurAlbumLite; Pe: TPersonnageLite; const ReferenceAlbum, ReferenceSerie: TGUID; Metier: TMetierAuteur); overload;
  end;

  TDaoAuteurParaBDLite = class(TDaoLiteEntity<TAuteurParaBDLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class procedure Fill(Entity: TAuteurParaBDLite; Query: TUIBQuery); overload; override;
    class procedure Fill(Entity: TAuteurParaBDLite; Pe: TPersonnageLite; const ReferenceParaBD: TGUID); overload;
  end;

  TDaoUniversLite = class(TDaoLiteEntity<TUniversLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class procedure Fill(Entity: TUniversLite; Query: TUIBQuery); overload; override;
    class procedure Fill(Entity: TUniversLite; const ID_Univers: TGUID); overload;
  end;

  TDaoPhotoLite = class(TDaoLiteEntity<TPhotoLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class procedure Fill(Entity: TPhotoLite; Query: TUIBQuery); override;
  end;

  TDaoCouvertureLite = class(TDaoLiteEntity<TCouvertureLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class procedure Fill(Entity: TCouvertureLite; Query: TUIBQuery); override;
  end;

  TDaoGenreLite = class(TDaoLiteEntity<TGenreLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class procedure Fill(Entity: TGenreLite; Query: TUIBQuery); override;
  end;

  TDaoConversionLite = class(TDaoLiteEntity<TConversionLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  public
    class procedure Fill(Entity: TConversionLite; Query: TUIBQuery); override;
  end;

implementation

uses
  Commun, UdmPrinc, uiblib, Entities.FactoriesLite;

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
  FPreparedQueries := TDictionary<TDaoLiteClass, TUIBQuery>.Create;
end;

class destructor TDaoLite.Destroy;
begin
  FPreparedQueries.Free;
  cs.Free;
end;

class procedure TDaoLite.FillList(List: TList<TBaseLite>; Query: TUIBQuery);
begin
  Prepare(Query);
  try
    while not Query.Eof do
    begin
      List.Add(Make(Query));
      Query.Next;
    end;
  finally
    Unprepare(Query);
  end;
end;

class function TDaoLite.GetFieldIndex(const Name: string): Integer;
var
  q: TUIBQuery;
begin
  q := getPreparedQuery;
  for Result := 0 to Pred(q.Fields.FieldCount) do
    if SameText(q.Fields.AliasName[Result], Name) then
      Exit;
  Result := -1;
end;

class procedure TDaoLite.GetFieldIndices;
begin
  Assert(getPreparedQuery <> nil, 'Doit être préparé avant');
end;

class function TDaoLite.getPreparedQuery: TUIBQuery;
begin
  FPreparedQueries.TryGetValue(Self, Result);
end;

class function TDaoLite.Make(Query: TUIBQuery): TBaseLite;
begin
  Result := getInstance as TBaseLite;
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
var
  p: TUIBQuery;
begin
  // Ne peut pas être préparée plusieurs fois
  p := getPreparedQuery;
  if (p <> nil) or (p = Query) then
    Exit;

  if not Assigned(cs) then
    cs := TCriticalSection.Create;
  cs.Enter;
  FPreparedQueries.Add(Self, Query);
  GetFieldIndices;
end;

class procedure TDaoLite.Unprepare(Query: TUIBQuery);
var
  p: TPair<TDaoLiteClass, TUIBQuery>;
begin
  if getPreparedQuery <> Query then
    Exit;

  for p in FPreparedQueries do
    if p.Value = Query then
      FPreparedQueries.Remove(p.Key);

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
      TBaseLite(LV.Items[i].Data).Free;
      LV.Items.Delete(i);
    end;
  finally
    if DoClear then
      LV.Items.Clear;
    LV.Items.EndUpdate;
  end;
end;

class procedure TDaoLite.VideListe(List: TList<TBaseLite>; DoClear: Boolean);
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

class procedure TDaoLiteEntity<T>.Fill(Entity: TBaseLite; Query: TUIBQuery);
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
    Unprepare(Query);
  end;
end;

class function TDaoLiteEntity<T>.Make(Query: TUIBQuery): T;
begin
  Result := T(inherited Make(Query));
end;

class procedure TDaoLiteEntity<T>.VideListe(List: TList<T>; DoClear: Boolean);
begin
  inherited VideListe(TList<TBaseLite>(List), DoClear);
end;

{ TDaoPhotoLite }

class function TDaoPhotoLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryPhotoLite;
end;

class procedure TDaoPhotoLite.Fill(Entity: TPhotoLite; Query: TUIBQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Photo');
  Entity.OldNom := Query.Fields.ByNameAsString['FichierPhoto'];
  Entity.NewNom := Entity.OldNom;
  Entity.OldStockee := Query.Fields.ByNameAsBoolean['StockagePhoto'];
  Entity.NewStockee := Entity.OldStockee;
  Entity.Categorie := Query.Fields.ByNameAsSmallint['CategorieImage'];
  Entity.sCategorie := Query.Fields.ByNameAsString['sCategorieImage'];
end;

{ TDaoCouvertureLite }

class function TDaoCouvertureLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryCouvertureLite;
end;

class procedure TDaoCouvertureLite.Fill(Entity: TCouvertureLite; Query: TUIBQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Couverture');
  Entity.OldNom := Query.Fields.ByNameAsString['FichierCouverture'];
  Entity.NewNom := Entity.OldNom;
  Entity.OldStockee := Query.Fields.ByNameAsBoolean['StockageCouverture'];
  Entity.NewStockee := Entity.OldStockee;
  Entity.Categorie := Query.Fields.ByNameAsSmallint['CategorieImage'];
  Entity.sCategorie := Query.Fields.ByNameAsString['sCategorieImage'];
end;

{ TDaoConversionLite }

class function TDaoConversionLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryConversionLite;
end;

class procedure TDaoConversionLite.Fill(Entity: TConversionLite; Query: TUIBQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Conversion');
  Entity.Monnaie1 := Query.Fields.ByNameAsString['Monnaie1'];
  Entity.Monnaie2 := Query.Fields.ByNameAsString['Monnaie2'];
  Entity.Taux := Query.Fields.ByNameAsDouble['Taux'];
end;

{ TDaoEditeurLite }

class function TDaoEditeurLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryEditeurLite;
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

class procedure TDaoEditeurLite.GetFieldIndices;
begin
  inherited;
  IndexID_Editeur := GetFieldIndex('ID_Editeur');
  IndexNomEditeur := GetFieldIndex('NomEditeur');
end;

class procedure TDaoEditeurLite.Fill(Entity: TEditeurLite; Query: TUIBQuery);
begin
  Entity.NomEditeur := '';

  if getPreparedQuery = Query then
  begin
    Entity.ID := NonNull(Query, IndexID_Editeur);
    if IndexNomEditeur <> -1 then
      Entity.NomEditeur := Query.Fields.AsString[IndexNomEditeur];
  end
  else
  begin
    Entity.ID := NonNull(Query, 'ID_Editeur');
    try
      Entity.NomEditeur := Query.Fields.ByNameAsString['NomEditeur'];
    except
    end;
  end;
end;

{ TDaoPersonnageLite }

class procedure TDaoPersonnageLite.Fill(Entity: TPersonnageLite; Query: TUIBQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Personne');
  Entity.Nom := Query.Fields.ByNameAsString['NomPersonne'];
end;

class function TDaoPersonnageLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryPersonnageLite;
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

{ TDaoAuteurSerieLite }

class function TDaoAuteurSerieLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryAuteurSerieLite;
end;

class procedure TDaoAuteurSerieLite.Fill(Entity: TAuteurSerieLite; Query: TUIBQuery);
var
  PPersonne: TPersonnageLite;
begin
  PPersonne := TDaoPersonnageLite.Make(Query);
  try
    Fill(Entity, PPersonne, NonNull(Query, 'ID_Serie'), TMetierAuteur(Query.Fields.ByNameAsInteger['Metier']));
  finally
    PPersonne.Free;
  end;
end;

class procedure TDaoAuteurSerieLite.Fill(Entity: TAuteurSerieLite; Pe: TPersonnageLite; const ReferenceSerie: TGUID; Metier: TMetierAuteur);
begin
  Entity.Personne.Assign(Pe);
  Entity.ID_Serie := ReferenceSerie;
  Entity.Metier := Metier;
end;

{ TDaoAuteurAlbumLite }

class procedure TDaoAuteurAlbumLite.Fill(Entity: TAuteurAlbumLite; Query: TUIBQuery);
begin
  TDaoAuteurSerieLite.Fill(Entity, Query);
  Entity.ID_Album := NonNull(Query, 'ID_Album');
end;

class function TDaoAuteurAlbumLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryAuteurAlbumLite;
end;

class procedure TDaoAuteurAlbumLite.Fill(Entity: TAuteurAlbumLite; Pe: TPersonnageLite; const ReferenceAlbum, ReferenceSerie: TGUID; Metier: TMetierAuteur);
begin
  TDaoAuteurSerieLite.Fill(Entity, Pe, ReferenceSerie, Metier);
  Entity.ID_Album := ReferenceAlbum;
end;

{ TDaoAuteurParaBDLite }

class function TDaoAuteurParaBDLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryAuteurParaBDLite;
end;

class procedure TDaoAuteurParaBDLite.Fill(Entity: TAuteurParaBDLite; Query: TUIBQuery);
var
  PPersonne: TPersonnageLite;
begin
  PPersonne := TDaoPersonnageLite.Make(Query);
  try
    Fill(Entity, PPersonne, NonNull(Query, 'ID_ParaBD'));
  finally
    PPersonne.Free;
  end;
end;

class procedure TDaoAuteurParaBDLite.Fill(Entity: TAuteurParaBDLite; Pe: TPersonnageLite; const ReferenceParaBD: TGUID);
begin
  Entity.Personne.Assign(Pe);
  Entity.ID_ParaBD := ReferenceParaBD;
end;

{ TDaoAlbumLite }

class procedure TDaoAlbumLite.Fill(Entity: TAlbumLite; Query: TUIBQuery);
begin
  Entity.Serie := '';
  Entity.Editeur := '';
  Entity.MoisParution := 0;
  Entity.AnneeParution := 0;
  Entity.Stock := True;
  Entity.Achat := False;
  Entity.Complet := True;
  Entity.Notation := 900;

  if getPreparedQuery = Query then
  begin
    Entity.ID := NonNull(Query, IndexID_Album);
    Entity.Titre := Query.Fields.AsString[IndexTitreAlbum];
    Entity.Tome := Query.Fields.AsInteger[IndexTome];
    Entity.TomeDebut := Query.Fields.AsInteger[IndexTomeDebut];
    Entity.TomeFin := Query.Fields.AsInteger[IndexTomeFin];
    Entity.ID_Serie := NonNull(Query, IndexID_Serie);
    Entity.Integrale := Query.Fields.AsBoolean[IndexIntegrale];
    Entity.HorsSerie := Query.Fields.AsBoolean[IndexHorsSerie];
    Entity.ID_Editeur := NonNull(Query, IndexID_Editeur);
    if IndexTitreSerie <> -1 then
      Entity.Serie := Query.Fields.AsString[IndexTitreSerie];
    if IndexNomEditeur <> -1 then
      Entity.Editeur := Query.Fields.AsString[IndexNomEditeur];
    if IndexMoisParution <> -1 then
      Entity.MoisParution := Query.Fields.AsInteger[IndexMoisParution];
    if IndexAnneeParution <> -1 then
      Entity.AnneeParution := Query.Fields.AsInteger[IndexAnneeParution];
    if IndexStock <> -1 then
      Entity.Stock := Query.Fields.AsBoolean[IndexStock];
    if IndexAchat <> -1 then
      Entity.Achat := Query.Fields.AsBoolean[IndexAchat];
    if IndexComplet <> -1 then
      Entity.Complet := Query.Fields.AsBoolean[IndexComplet];
    if IndexNotation <> -1 then
      Entity.Notation := Query.Fields.AsSmallint[IndexNotation];
  end
  else
  begin
    Entity.ID := NonNull(Query, 'ID_Album');
    Entity.Titre := Query.Fields.ByNameAsString['TitreAlbum'];
    Entity.Tome := Query.Fields.ByNameAsInteger['Tome'];
    Entity.TomeDebut := Query.Fields.ByNameAsInteger['TomeDebut'];
    Entity.TomeFin := Query.Fields.ByNameAsInteger['TomeFin'];
    Entity.ID_Serie := NonNull(Query, 'ID_Serie');
    Entity.Integrale := Query.Fields.ByNameAsBoolean['Integrale'];
    Entity.HorsSerie := Query.Fields.ByNameAsBoolean['HorsSerie'];
    Entity.ID_Editeur := NonNull(Query, 'ID_Editeur');
    try
      Entity.Serie := Query.Fields.ByNameAsString['TitreSerie'];
    except
    end;
    try
      Entity.Editeur := Query.Fields.ByNameAsString['NomEditeur'];
    except
    end;
    try
      Entity.MoisParution := Query.Fields.ByNameAsInteger['MoisParution'];
    except
    end;
    try
      Entity.AnneeParution := Query.Fields.ByNameAsInteger['AnneeParution'];
    except
    end;
    try
      Entity.Stock := Query.Fields.ByNameAsBoolean['Stock'];
    except
    end;
    try
      Entity.Achat := Query.Fields.ByNameAsBoolean['Achat'];
    except
    end;
    try
      Entity.Complet := Query.Fields.ByNameAsBoolean['Complet'];
    except
    end;
    try
      Entity.Notation := Query.Fields.ByNameAsSmallint['Notation'];
    except
    end;
  end;

  if Entity.Notation = 0 then
    Entity.Notation := 900;
end;

class procedure TDaoAlbumLite.Fill(Entity: TAlbumLite; const ID_Album: TGUID);
begin
  Fill(Entity, ID_Album, GUID_NULL);
end;

class function TDaoAlbumLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryAlbumLite;
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
    Prepare(qry);
    try
      Fill(Entity, qry);
    finally
      Unprepare(qry);
    end;
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
    Entity.Editeur.DoClear;
  end;
end;

class function TDaoCollectionLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryCollectionLite;
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

class procedure TDaoCollectionLite.GetFieldIndices;
begin
  inherited;
  TDaoEditeurLite.Prepare(getPreparedQuery);
end;

{ TDaoSerieLite }

class procedure TDaoSerieLite.Fill(Entity: TSerieLite; Query: TUIBQuery);
begin
  Entity.ID := NonNull(Query, 'ID_Serie');
  Entity.TitreSerie := Query.Fields.ByNameAsString['TitreSerie'];
  try
    TDaoEditeurLite.Fill(Entity.Editeur, Query);
  except
    Entity.Editeur.DoClear;
  end;
  try
    TDaoCollectionLite.Fill(Entity.Collection, Query);
  except
    Entity.Collection.DoClear;
  end;
end;

class function TDaoSerieLite.FactoryClass: TFactoryClass;
begin
  Result := TFactorySerieLite;
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

class function TDaoEditionLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryEditionLite;
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

class procedure TDaoEditionLite.GetFieldIndices;
begin
  inherited;
  // le TDaoEditeurLite.Prepare(getPreparedQuery) sera appelé par TDaoCollectionLite.Prepare(getPreparedQuery)
  // TDaoEditeurLite.Prepare(getPreparedQuery);
  TDaoCollectionLite.Prepare(getPreparedQuery);
end;

{ TDaoGenreLite }

class function TDaoGenreLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryGenreLite;
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

class function TDaoParaBDLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryParaBDLite;
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

class function TDaoUniversLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryUniversLite;
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
