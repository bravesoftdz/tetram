unit Entities.FactoriesCommon;

interface

uses
  System.Rtti, System.Generics.Collections, Entities.Common;

type
  TFactoryClass = class of TFactoryEntity;

  TFactoryEntity = class abstract
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

    class function getInstance: TEntity;
    class function Duplicate(Source: TEntity): TEntity;
  end;

  TFactoryGenericEntity<T: TEntity> = class abstract(TFactoryEntity)
    class function Duplicate(Source: T): T; reintroduce;
  end;

  TFactoryDBEntity = class abstract(TFactoryEntity)
  public
  end;

  TFactoryGenericDBEntity<T: TDBEntity> = class abstract(TFactoryDBEntity)
    class function Duplicate(Source: T): T; reintroduce;
  end;

implementation

{ TDaoEntity }

class function TFactoryEntity.BuildInstance: TEntity;
begin
  Result := getBuilder(EntityClass).Invoke(EntityClass, []).AsObject as TEntity;
end;

class constructor TFactoryEntity.Create;
begin
  FEntitiesBuilders := TDictionary<TEntityClass, TRttiMethod>.Create;
end;

class destructor TFactoryEntity.Destroy;
begin
  FEntitiesBuilders.Free;
end;

class function TFactoryEntity.Duplicate(Source: TEntity): TEntity;
begin
  Result := getInstance;
  Result.Assign(Source);
end;

class function TFactoryEntity.getBuilder(c: TEntityClass): TRttiMethod;
begin
  if not FEntitiesBuilders.TryGetValue(c, Result) then
  begin
    Result := RttiContext.GetType(c).GetMethod('Create');
    FEntitiesBuilders.Add(c, Result);
  end;
end;

class function TFactoryEntity.getInstance: TEntity;
begin
  Result := BuildInstance;
end;

{ TFactoryGenericEntity<T> }

class function TFactoryGenericEntity<T>.Duplicate(Source: T): T;
begin
  Result := inherited Duplicate(Source) as T;
end;

{ TFactoryGenericDBEntity<T> }

class function TFactoryGenericDBEntity<T>.Duplicate(Source: T): T;
begin
  Result := inherited Duplicate(Source) as T;
end;

end.
