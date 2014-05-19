unit Entities.DaoCommon;

interface

uses
  System.SysUtils, System.Classes, System.Rtti, System.Generics.Collections, Entities.Common, Entities.FactoriesCommon, Entities.Attributes, Entities.DBConnection;

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
    class procedure FillEntity(Entity: TDBEntity; const Reference: TGUID);
    class procedure FillExtra(Entity: TDBEntity); virtual;
    class function getInstance(const Reference: TGUID): TDBEntity; reintroduce; overload;

    class property DBConnection: IDBConnection read FDBConnection write FDBConnection;
  end;

  TDaoGenericDBEntity<T: TDBEntity> = class abstract(TDaoDBEntity)
    class function getInstance: T; reintroduce; overload;
    class function getInstance(const Reference: TGUID): TDBEntity; reintroduce; overload;
  end;

implementation

uses
  Commun;

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

class procedure TDaoDBEntity.FillEntity(Entity: TDBEntity; const Reference: TGUID);

  procedure SetProperty(PropDesc: EntityFieldAttribute; const Value);
  var
    v: TValue;
  begin
    if PropDesc.f <> nil then
    begin
      TValue.Make(@Value, PropDesc.f.FieldType.Handle, v);
      PropDesc.f.SetValue(Entity, v)
    end
    else
    begin
      TValue.Make(@Value, PropDesc.p.PropertyType.Handle, v);
      PropDesc.p.SetValue(Entity, v);
    end;
  end;

var
  mi: TEntityMetadataCache.TMetadataInfo;
begin
  if IsEqualGUID(Reference, GUID_NULL) then
    Exit;

  mi := TEntityMetadataCache.PrepareRTTI(TDBEntityClass(Entity.ClassType));

  SetProperty(mi.PrimaryKeyDesc, Reference);

  // Entity.ID_Album := Reference;
  // qry := TUIBQuery.Create(nil);

  FillExtra(Entity);
end;

class procedure TDaoDBEntity.FillExtra(Entity: TDBEntity);
begin

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
