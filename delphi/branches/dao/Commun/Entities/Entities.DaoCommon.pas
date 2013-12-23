unit Entities.DaoCommon;

interface

uses
  System.Rtti, System.Generics.Collections, Entities.Common;

type
  TDaoEntity = class abstract
  private
    class var RttiContext: TRttiContext;
    class var FEntitiesBuilders: TDictionary<TEntityClass, TRttiMethod>;
    class function getBuilder(c: TEntityClass): TRttiMethod;

    class function BuildInstance: TEntity;
  protected
    class function EntityClass: TEntityClass; virtual; abstract;
  public
    class constructor Create;
    class destructor Destroy;

    class function getInstance: TEntity; overload;
  end;

  TDaoDBEntity = class abstract(TDaoEntity)
  public
    class procedure Fill(Entity: TDBEntity; const Reference: TGUID); virtual; abstract;
    class function getInstance(const Reference: TGUID): TDBEntity; reintroduce; overload;
  end;

implementation

{ TDaoEntity }

class function TDaoEntity.BuildInstance: TEntity;
begin
  Result := getBuilder(EntityClass).Invoke(EntityClass, []).AsObject as TEntity;
end;

class constructor TDaoEntity.Create;
begin
  FEntitiesBuilders := TDictionary<TEntityClass, TRttiMethod>.Create;
end;

class destructor TDaoEntity.Destroy;
begin
  FEntitiesBuilders.Free;
end;

class function TDaoEntity.getBuilder(c: TEntityClass): TRttiMethod;
begin
  if not FEntitiesBuilders.TryGetValue(c, Result) then
  begin
    Result := RttiContext.GetType(c).GetMethod('Create');
    FEntitiesBuilders.Add(c, Result);
  end;
end;

class function TDaoEntity.getInstance: TEntity;
begin
  Result := BuildInstance;
end;

{ TDaoDBEntity }

class function TDaoDBEntity.getInstance(const Reference: TGUID): TDBEntity;
begin
  Result := BuildInstance as TDBEntity;
  Fill(Result, Reference);
end;

end.
