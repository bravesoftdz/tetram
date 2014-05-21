unit ORM.Core.Dao;

interface

uses
  System.SysUtils, System.Classes, System.Rtti, System.Generics.Collections, ORM.Core.Entities, ORM.Core.Factories,
  ORM.Core.DBConnection, UFichierLog, System.SyncObjs;

type
  TabstractDao<T: TabstractEntity> = class abstract
  public
    class constructor Create;

    class function Supports(AClass: TEntityClass): Boolean;

    function getInstance: T;
    procedure FusionneInto(Source, Dest: T); overload; virtual; abstract;
    procedure FusionneInto(Source, Dest: TObjectList<T>); overload; virtual; abstract;
  end;

  TabstractDaoDB<T: TabstractDBEntity> = class abstract(TabstractDao<T>)
  private
    class var FDBConnection: IDBConnection;
  protected
    function getPreparedQuery: TManagedQuery;
    function GetFieldIndex(const Name: string): Integer;
    procedure GetFieldIndices; virtual;
  public
    procedure Prepare(Query: TManagedQuery);
    procedure Unprepare(Query: TManagedQuery);

    function getInstance(const Reference: TGUID): T; reintroduce; overload;
    function getInstance(Query: TManagedQuery): T; reintroduce; overload;
    class function BuildID: TGUID;

    class function NonNull(Query: TManagedQuery; const Champ: string; Default: Integer): Integer; overload;
    class function NonNull(Query: TManagedQuery; const Champ: string): TGUID; overload;
    class function NonNull(Query: TManagedQuery; Champ, Default: Integer): Integer; overload;
    class function NonNull(Query: TManagedQuery; Champ: Integer): TGUID; overload;

    procedure Fill(Entity: T; Query: TManagedQuery); overload; virtual; abstract;
    procedure Fill(Entity: T; const Reference: TGUID); overload; virtual; abstract;

    procedure FillEntity(Entity: T; Query: TManagedQuery); overload;
    procedure FillEntity(Entity: T; const Reference: TGUID; UseTransaction: TManagedTransaction = nil); overload;
    procedure FillExtra(Entity: T; UseTransaction: TManagedTransaction); virtual;

    procedure FillList(List: TList<T>; Query: TManagedQuery);

    procedure SaveToDatabase(Entity: T); overload;
    procedure SaveToDatabase(Entity: T; UseTransaction: TManagedTransaction); overload; virtual;

    class property DBConnection: IDBConnection read FDBConnection write FDBConnection;
  end;

  TabstractDao = TabstractDao<TabstractEntity>;
  TabstractDaoDB = TabstractDaoDB<TabstractDBEntity>;

  TDaoFactory = class abstract
  private
    class var RttiContext: TRttiContext;
    class var FDao: TList<TabstractDao>;
    class procedure SearchDao;
    // class var FDaoClasses: TList<TDaoEntity>;
    // class var cs: TCriticalSection;
    // class var FPreparedQueries: TDictionary<TDaoDBEntity, TManagedQuery>;
  public
    class constructor Create;
    class destructor Destroy;

    class function getDaoDB<T: TabstractDBEntity>: TabstractDaoDB<T>;
    class function getDao<T: TabstractEntity>: TabstractDao<T>;
  end;

implementation

uses
  System.TypInfo, ORM.Core.Attributes, System.Types, System.StrUtils,
  ORM.Core.Types;

{ TDaoEntity }

class constructor TabstractDao<T>.Create;
begin
  // TDaoFactory.FDaoClasses.Add(TDaoEntity(TDaoEntity<T>.Create));
end;

// class function TDaoEntity<T>.getDao(AClass: TEntityClass): TDaoEntity<T>;
// var
// CandidateDao: TDaoEntity;
// begin
(*
  for CandidateDao in TDaoFactory.FDaoClasses do
  if CandidateDao.Supports(AClass) then
  exit(TDaoEntity<T>(CandidateDao));
  Result := nil;
*)
// end;

// class function TDaoEntity<T>.getDao: TDaoEntity<T>;
// var
// CandidateDao: TDaoEntity;
// begin
(*
  for CandidateDao in TDaoFactory.FDaoClasses do
  if CandidateDao.Supports(T) then
  exit(TDaoEntity<T>(CandidateDao));
  Result := nil;
*)
// end;

function TabstractDao<T>.getInstance: T;
begin
  Result := TFactories.getFactory<T>.getInstance;
end;

class function TabstractDao<T>.Supports(AClass: TEntityClass): Boolean;
begin
  Result := T.InheritsFrom(AClass);
end;

{ TDaoDBEntity }

class function TabstractDaoDB<T>.BuildID: TGUID;
var
  qry: TManagedQuery;
begin
  qry := DBConnection.GetQuery;
  try
    qry.SQL.Text := 'select udf_createguid() from rdb$database';
    qry.Open;
    Result := StringToGUIDDef(qry.Fields.AsString[0], GUID_NULL);
  finally
    qry.Free;
  end;
end;

procedure TabstractDaoDB<T>.FillEntity(Entity: T; const Reference: TGUID; UseTransaction: TManagedTransaction = nil);
var
  mi: TEntityMetadataCache.TMetadataInfo;
  qry: TManagedQuery;
begin
  Entity.Clear;
  if IsEqualGUID(Reference, GUID_NULL) then
    exit;

  mi := TEntityMetadataCache.PrepareRTTI(TDBEntityClass(Entity.ClassType));

  qry := DBConnection.GetQuery(UseTransaction);
  try
    qry.SQL.Text := mi.getSelectSQL;
    qry.Params.ByNameAsString[mi.PrimaryKeyDesc.FieldName] := GUIDToString(Reference);
    qry.Open;

    if not qry.Eof then
      FillEntity(Entity, qry);
  finally
    qry.Free;
  end;
end;

procedure TabstractDaoDB<T>.FillEntity(Entity: T; Query: TManagedQuery);
(*
  procedure SetProperty(PropDesc: EntityFieldAttribute; qry: TManagedQuery); overload;
  begin
  if PropDesc.IsClass(TabstractDBEntity) then
  begin
  TDaoGenericDBEntity.getDao(TDBEntityClass(TEntityClass(PropDesc.c.ClassType)));
  FillEntity(PropDesc.GetValue<TabstractDBEntity>(Entity), NonNull(qry, PropDesc.FieldName), qry.Transaction)
  end
  else if PropDesc.T = TypeInfo(Boolean) then
  PropDesc.SetValue(Entity, TValue.From<Boolean>(qry.Fields.ByNameAsBoolean[PropDesc.FieldName]))
  else
  PropDesc.SetValue(Entity, qry.Fields.AsTValue[qry.Fields.GetFieldIndex(AnsiString(PropDesc.FieldName))]);
  end;
*)
var
  mi: TEntityMetadataCache.TMetadataInfo;
  f: EntityFieldAttribute;
begin
  (*
    mi := TEntityMetadataCache.PrepareRTTI(TDBEntityClass(Entity.ClassType));
    SetProperty(mi.PrimaryKeyDesc, Query);
    for f in mi.FieldsDesc do
    SetProperty(f, Query);
  *)
  FillExtra(Entity, Query.Transaction);
end;

procedure TabstractDaoDB<T>.FillExtra(Entity: T; UseTransaction: TManagedTransaction);
begin

end;

procedure TabstractDaoDB<T>.FillList(List: TList<T>; Query: TManagedQuery);
begin
  Prepare(Query);
  try
    while not Query.Eof do
    begin
      List.Add(getInstance(Query));
      Query.Next;
    end;
  finally
    Unprepare(Query);
  end;
end;

function TabstractDaoDB<T>.GetFieldIndex(const Name: string): Integer;
var
  q: TManagedQuery;
begin
  q := getPreparedQuery;
  for Result := 0 to Pred(q.Fields.FieldCount) do
    if SameText(q.Fields.AliasName[Result], Name) then
      exit;
  Result := -1;
end;

procedure TabstractDaoDB<T>.GetFieldIndices;
begin
  Assert(getPreparedQuery <> nil, 'Doit être préparé avant');
end;

function TabstractDaoDB<T>.getInstance(const Reference: TGUID): T;
begin
  // Result := FactoryClass.getInstance as T;
  FillEntity(Result, Reference);
end;

function TabstractDaoDB<T>.getInstance(Query: TManagedQuery): T;
begin
  // Result := FactoryClass.getInstance as T;
  // FillEntity(Result, Query);
  Fill(Result, Query);
end;

function TabstractDaoDB<T>.getPreparedQuery: TManagedQuery;
begin
  // TDaoFactory.FPreparedQueries.TryGetValue(TDaoDBEntity(Self), Result);
end;

class function TabstractDaoDB<T>.NonNull(Query: TManagedQuery; const Champ: string): TGUID;
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

class function TabstractDaoDB<T>.NonNull(Query: TManagedQuery; const Champ: string; Default: Integer): Integer;
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

class function TabstractDaoDB<T>.NonNull(Query: TManagedQuery; Champ: Integer): TGUID;
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

class function TabstractDaoDB<T>.NonNull(Query: TManagedQuery; Champ, Default: Integer): Integer;
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

procedure TabstractDaoDB<T>.Prepare(Query: TManagedQuery);
var
  p: TManagedQuery;
begin
  // Ne peut pas être préparée plusieurs fois
  p := getPreparedQuery;
  if (p <> nil) or (p = Query) then
    exit;
  (*
    if not Assigned(TDaoFactory.cs) then
    TDaoFactory.cs := TCriticalSection.Create;
    TDaoFactory.cs.Enter;
    TDaoFactory.FPreparedQueries.Add(TDaoDBEntity(Self), Query);
    GetFieldIndices;
  *)
end;

procedure TabstractDaoDB<T>.SaveToDatabase(Entity: T);
var
  Transaction: TManagedTransaction;
begin
  // Assert(not IsEqualGUID(Entity.ID, GUID_NULL), 'L''ID ne peut être GUID_NULL');

  Transaction := DBConnection.GetTransaction;
  try
    SaveToDatabase(Entity, Transaction);
    Transaction.Commit;
  finally
    Transaction.Free;
  end;
end;

procedure TabstractDaoDB<T>.SaveToDatabase(Entity: T; UseTransaction: TManagedTransaction);
begin
  // Assert(not IsEqualGUID(Entity.ID, GUID_NULL), 'L''ID ne peut être GUID_NULL');
end;

procedure TabstractDaoDB<T>.Unprepare(Query: TManagedQuery);
// var
// p: TPair<TDaoDBEntity, TManagedQuery>;
begin
  if getPreparedQuery <> Query then
    exit;
  (*
    for p in TDaoFactory.FPreparedQueries do
    if p.Value = Query then
    TDaoFactory.FPreparedQueries.Remove(p.Key);

    TDaoFactory.cs.Release;
  *)
end;

{ TDaoFactory }

class constructor TDaoFactory.Create;
begin
  // on ne construit pas maintenant: la présence de l'instance sera à dire si on a déjà cherché les DAO
  // FDao := TObjectList<TabstractDao>.Create(True);

  // cs := nil;
  // FPreparedQueries := TDictionary<TDaoDBEntity, TManagedQuery>.Create;
end;

class destructor TDaoFactory.Destroy;
begin
  FDao.Free;
  // FPreparedQueries.Free;
  // cs.Free;
end;

class function TDaoFactory.getDao<T>: TabstractDao<T>;
var
  CandidateDao: TabstractDao;
begin
  SearchDao;
  for CandidateDao in FDao do
    if CandidateDao.Supports(T) then
      exit(TabstractDao<T>(CandidateDao));
  Result := nil;
end;

class function TDaoFactory.getDaoDB<T>: TabstractDaoDB<T>;
var
  CandidateDao: TabstractDao;
begin
  CandidateDao := TabstractDao(getDao<T>);
  if CandidateDao <> nil then
    exit(TabstractDaoDB<T>(CandidateDao));

  Result := nil;
end;

class procedure TDaoFactory.SearchDao;
var
  T: TRttiType;
  attr: TCustomAttribute;
begin
  if Assigned(FDao) then
    exit;

  FDao := TObjectList<TabstractDao>.Create(True);

  for T in RttiContext.GetTypes do
    if T.IsInstance then
      for attr in T.GetAttributes do
        if attr is DaoAttribute then
          FDao.Add(TabstractDao(T.ClassType.Create));
end;

end.
