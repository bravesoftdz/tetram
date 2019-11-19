unit BD.Entities.Dao.Common;

interface

uses
  System.SysUtils, System.Classes, System.Rtti, System.Generics.Collections, BD.Entities.Common, BD.Entities.Factory.Common,
  BD.DB.Connection;

type
  TDaoEntity = class abstract
  protected
    class function FactoryClass: TFactoryClass; virtual; abstract;
  public
    class function getInstance: TEntity;
  end;

  TDaoGenericEntity<T: TEntity> = class abstract(TDaoEntity)
    class function getInstance: T; reintroduce;
  end;

  TDaoDBEntity = class abstract(TDaoEntity)
  private
    class var FDBConnection: IDBConnection;
    class procedure SetDBConnection(const Value: IDBConnection); static;
  protected
    class procedure LoadEntity(Entity: TDBEntity; const Reference: TGUID; UseTransaction: TManagedTransaction); virtual; abstract;
    class procedure SaveEntity(Entity: TDBEntity; UseTransaction: TManagedTransaction); virtual; abstract;
  public
    class function BuildID: TGUID;

    class function getInstance(const Reference: TGUID): TDBEntity; reintroduce; overload;
    class procedure Fill(Entity: TDBEntity; const Reference: TGUID; UseTransaction: TManagedTransaction);
    class procedure SaveToDatabase(Entity: TDBEntity; UseTransaction: TManagedTransaction = nil);

    class property DBConnection: IDBConnection read FDBConnection write SetDBConnection;
  end;

  TDaoGenericDBEntity<T: TDBEntity> = class abstract(TDaoDBEntity)
    class function getInstance: T; reintroduce; overload;
    class function getInstance(const Reference: TGUID): TDBEntity; reintroduce; overload;
  end;

implementation

uses
  uib, BDTK.GUI.DataModules.Main, BD.Utils.StrUtils;

{ TDaoEntity }

class function TDaoEntity.getInstance: TEntity;
begin
  Result := FactoryClass.getInstance;
end;

{ TDaoDBEntity }

class function TDaoDBEntity.BuildID: TGUID;
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

class procedure TDaoDBEntity.Fill(Entity: TDBEntity; const Reference: TGUID; UseTransaction: TManagedTransaction);
var
  Transaction: TManagedTransaction;
begin
  if Assigned(UseTransaction) then
    Transaction := UseTransaction
  else
    Transaction := DBConnection.GetTransaction;
  try
    Entity.Clear;
    LoadEntity(Entity, Reference, Transaction);
  finally
    if not Assigned(UseTransaction) then
      Transaction.Free;
  end;
end;

class function TDaoDBEntity.getInstance(const Reference: TGUID): TDBEntity;
begin
  Result := FactoryClass.getInstance as TDBEntity;
  Fill(Result, Reference, nil);
end;

class procedure TDaoDBEntity.SaveToDatabase(Entity: TDBEntity; UseTransaction: TManagedTransaction);
var
  Transaction: TManagedTransaction;
begin
  // Assert(not IsEqualGUID(Entity.ID, GUID_NULL), 'L''ID ne peut être GUID_NULL');
  if Assigned(UseTransaction) then
    Transaction := UseTransaction
  else
    Transaction := DBConnection.GetTransaction;
  try
    SaveEntity(Entity, Transaction);
    Transaction.Commit;
  finally
    if not Assigned(UseTransaction) then
      Transaction.Free;
  end;
end;

class procedure TDaoDBEntity.SetDBConnection(const Value: IDBConnection);
begin
  FDBConnection := Value;
end;

{ TDaoGenericEntity<T> }

class function TDaoGenericEntity<T>.getInstance: T;
begin
  Result := inherited getInstance as T;
end;

{ TDaoGenericDBEntity<T> }

class function TDaoGenericDBEntity<T>.getInstance: T;
begin
  Result := inherited getInstance as T;
end;

class function TDaoGenericDBEntity<T>.getInstance(const Reference: TGUID): TDBEntity;
begin
  Result := inherited getInstance(Reference) as T;
end;

end.
