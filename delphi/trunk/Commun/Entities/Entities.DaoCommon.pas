unit Entities.DaoCommon;

interface

uses
  System.SysUtils, System.Classes, System.Rtti, System.Generics.Collections, Entities.Common, Entities.FactoriesCommon,
  Entities.DBConnection;

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
  public
    class function BuildID: TGUID;
    class procedure Fill(Entity: TDBEntity; const Reference: TGUID); virtual; abstract;
    class function getInstance(const Reference: TGUID): TDBEntity; reintroduce; overload;

    class property DBConnection: IDBConnection read FDBConnection write FDBConnection;
  end;

  TDaoGenericDBEntity<T: TDBEntity> = class abstract(TDaoDBEntity)
    class function getInstance: T; reintroduce; overload;
    class function getInstance(const Reference: TGUID): TDBEntity; reintroduce; overload;
  end;

implementation

uses
  Commun, uiblib;

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

class function TDaoDBEntity.getInstance(const Reference: TGUID): TDBEntity;
begin
  Result := FactoryClass.getInstance as TDBEntity;
  Fill(Result, Reference);
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
