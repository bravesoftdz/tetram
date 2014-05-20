unit Entities.DaoCommon;

interface

uses
  System.SysUtils, System.Classes, System.Rtti, System.Generics.Collections, Entities.Common, Entities.FactoriesCommon,
  Entities.DBConnection, Vcl.Dialogs, UFichierLog, System.SyncObjs;

type
  TDaoEntity<T: TEntity> = class abstract
  public
    class constructor Create;

    class function Supports(AClass: TEntityClass): Boolean;
    class function getDao(AClass: TEntityClass): TDaoEntity<T>; overload;
    class function getDao: TDaoEntity<T>; overload;

    class function FactoryClass: TFactoryClass; virtual;

    function getInstance: T;
  end;

  TDaoDBEntity<T: TDBEntity> = class abstract(TDaoEntity<T>)
  private
    class var FDBConnection: IDBConnection;
  protected
    class function getPreparedQuery: TManagedQuery;
    class function GetFieldIndex(const Name: string): Integer;
    class procedure GetFieldIndices; virtual;
  public
    class procedure Prepare(Query: TManagedQuery);
    class procedure Unprepare(Query: TManagedQuery);

    class function getInstance(const Reference: TGUID): T; reintroduce; overload;
    class function BuildID: TGUID;

    class function NonNull(Query: TManagedQuery; const Champ: string; Default: Integer): Integer; overload; inline;
    class function NonNull(Query: TManagedQuery; const Champ: string): TGUID; overload; inline;
    class function NonNull(Query: TManagedQuery; Champ, Default: Integer): Integer; overload; inline;
    class function NonNull(Query: TManagedQuery; Champ: Integer): TGUID; overload; inline;

    class procedure Fill(Entity: TDBEntity; Query: TManagedQuery); overload; virtual; abstract;
    class procedure Fill(Entity: TDBEntity; const Reference: TGUID); overload; virtual; abstract;

    class procedure FillEntity(Entity: TDBEntity; Query: TManagedQuery); overload;
    class procedure FillEntity(Entity: TDBEntity; const Reference: TGUID; UseTransaction: TManagedTransaction = nil); overload;
    class procedure FillExtra(Entity: TDBEntity; UseTransaction: TManagedTransaction); virtual;

    class property DBConnection: IDBConnection read FDBConnection write FDBConnection;
  end;

  TDaoEntity = TDaoEntity<TEntity>;
  TDaoDBEntity = TDaoDBEntity<TDBEntity>;

  TDaoFactory = class abstract
  private
    class var FDaoClasses: TList<TDaoEntity>;
    class var cs: TCriticalSection;
    class var FPreparedQueries: TDictionary<TDaoDBEntity, TManagedQuery>;
  public
    class constructor Create;
    class destructor Destroy;
  end;

implementation

uses
  Commun, System.TypInfo, Entities.Attributes, System.Types, System.StrUtils;

{ TDaoEntity }

class constructor TDaoEntity<T>.Create;
begin
  TDaoFactory.FDaoClasses.Add(TDaoEntity(TDaoEntity<T>.Create));
end;

class function TDaoEntity<T>.getDao(AClass: TEntityClass): TDaoEntity<T>;
var
  CandidateDao: TDaoEntity;
begin
  for CandidateDao in TDaoFactory.FDaoClasses do
    if CandidateDao.Supports(AClass) then
      exit(TDaoEntity<T>(CandidateDao));
  Result := nil;
end;

class function TDaoEntity<T>.FactoryClass: TFactoryClass;
begin

end;

class function TDaoEntity<T>.getDao: TDaoEntity<T>;
var
  CandidateDao: TDaoEntity;
begin
  for CandidateDao in TDaoFactory.FDaoClasses do
    if CandidateDao.Supports(T) then
      exit(TDaoEntity<T>(CandidateDao));
  Result := nil;
end;

function TDaoEntity<T>.getInstance: T;
begin
  Result := FactoryClass.getInstance;
end;

class function TDaoEntity<T>.Supports(AClass: TEntityClass): Boolean;
begin
  Result := T.InheritsFrom(AClass);
end;

{ TDaoDBEntity }

class function TDaoDBEntity<T>.BuildID: TGUID;
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

class procedure TDaoDBEntity<T>.FillEntity(Entity: TDBEntity; const Reference: TGUID; UseTransaction: TManagedTransaction = nil);
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

class procedure TDaoDBEntity<T>.FillEntity(Entity: TDBEntity; Query: TManagedQuery);
(*
  procedure SetProperty(PropDesc: EntityFieldAttribute; qry: TManagedQuery); overload;
  begin
    if PropDesc.IsClass(TDBEntity) then
    begin
      TDaoGenericDBEntity.getDao(TDBEntityClass(TEntityClass(PropDesc.c.ClassType)));
      FillEntity(PropDesc.GetValue<TDBEntity>(Entity), NonNull(qry, PropDesc.FieldName), qry.Transaction)
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

class procedure TDaoDBEntity<T>.FillExtra(Entity: TDBEntity; UseTransaction: TManagedTransaction);
begin

end;

class function TDaoDBEntity<T>.GetFieldIndex(const Name: string): Integer;
var
  q: TManagedQuery;
begin
  q := getPreparedQuery;
  for Result := 0 to Pred(q.Fields.FieldCount) do
    if SameText(q.Fields.AliasName[Result], Name) then
      exit;
  Result := -1;
end;

class procedure TDaoDBEntity<T>.GetFieldIndices;
begin
  Assert(getPreparedQuery <> nil, 'Doit être préparé avant');
end;

class function TDaoDBEntity<T>.getInstance(const Reference: TGUID): T;
begin
  Result := FactoryClass.getInstance as T;
  FillEntity(Result, Reference);
end;

class function TDaoDBEntity<T>.getPreparedQuery: TManagedQuery;
begin
  TDaoFactory.FPreparedQueries.TryGetValue(TDaoDBEntity(Self), Result);
end;

class function TDaoDBEntity<T>.NonNull(Query: TManagedQuery; const Champ: string): TGUID;
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

class function TDaoDBEntity<T>.NonNull(Query: TManagedQuery; const Champ: string; Default: Integer): Integer;
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

class function TDaoDBEntity<T>.NonNull(Query: TManagedQuery; Champ: Integer): TGUID;
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

class function TDaoDBEntity<T>.NonNull(Query: TManagedQuery; Champ, Default: Integer): Integer;
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

class procedure TDaoDBEntity<T>.Prepare(Query: TManagedQuery);
var
  p: TManagedQuery;
begin
  // Ne peut pas être préparée plusieurs fois
  p := getPreparedQuery;
  if (p <> nil) or (p = Query) then
    exit;

  if not Assigned(TDaoFactory.cs) then
    TDaoFactory.cs := TCriticalSection.Create;
  TDaoFactory.cs.Enter;
  TDaoFactory.FPreparedQueries.Add(TDaoDBEntity(Self), Query);
  GetFieldIndices;
end;

class procedure TDaoDBEntity<T>.Unprepare(Query: TManagedQuery);
var
  p: TPair<TDaoDBEntity, TManagedQuery>;
begin
  if getPreparedQuery <> Query then
    exit;

  for p in TDaoFactory.FPreparedQueries do
    if p.Value = Query then
      TDaoFactory.FPreparedQueries.Remove(p.Key);

  TDaoFactory.cs.Release;
end;

{ TDaoFactory }

class constructor TDaoFactory.Create;
begin
  FDaoClasses := TObjectList<TDaoEntity>.Create(True);
  cs := nil;
  FPreparedQueries := TDictionary<TDaoDBEntity, TManagedQuery>.Create;
end;

class destructor TDaoFactory.Destroy;
begin
  FDaoClasses.Free;
  FPreparedQueries.Free;
  cs.Free;
end;

end.
