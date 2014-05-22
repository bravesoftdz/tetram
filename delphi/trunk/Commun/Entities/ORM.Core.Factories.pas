unit ORM.Core.Factories;

interface

uses
  System.Rtti, System.Generics.Collections, ORM.Core.Entities;

type
  TAbstractFactory<T: TabstractEntity> = class abstract
  private
    class function BuildInstance: T;
  public
    class constructor Create;

    class function Supports(AClass: TEntityClass): Boolean;

    function getInstance: T;
    function Duplicate(Source: T): T;
  end;

  TAbstractFactory = TAbstractFactory<TabstractEntity>;

  TFactories = class abstract
  private
    class var RttiContext: TRttiContext;
    class var FEntitiesBuilders: TDictionary<TEntityClass, TRttiMethod>;
    class var FFactories: TList<TAbstractFactory>;
    class function getBuilder(c: TEntityClass): TRttiMethod;
    class function BuildInstance<T: TabstractEntity>: T;
  public
    class constructor Create;
    class destructor Destroy;

    class function getFactory<T: TabstractEntity>: TAbstractFactory<T>; overload;
    class function getFactory(T: TEntityClass): TAbstractFactory; overload;

    class function getInstance<T: TabstractEntity>: T;
    class function Duplicate<T: TabstractEntity>(Source: T): T;
  end;

implementation

{ TDaoEntity }

class function TAbstractFactory<T>.BuildInstance: T;
begin
  Result := TFactories.getBuilder(T).Invoke(T, []).AsObject as T;
end;

class constructor TAbstractFactory<T>.Create;
begin
  TFactories.FFactories.Add(TAbstractFactory(TAbstractFactory<T>.Create));
end;

function TAbstractFactory<T>.Duplicate(Source: T): T;
begin
  Result := getInstance;
  Result.Assign(Source);
end;

function TAbstractFactory<T>.getInstance: T;
begin
  Result := BuildInstance;
end;

class function TAbstractFactory<T>.Supports(AClass: TEntityClass): Boolean;
begin
  Result := T.InheritsFrom(AClass);  // do not use "is" operator, it compiles but does not work because it considers T as an instance
end;

{ TFactoriesInitializer }

class function TFactories.BuildInstance<T>: T;
begin
  Result := getBuilder(T).Invoke(T, []).AsObject as T;
end;

class constructor TFactories.Create;
begin
  FFactories := TObjectList<TAbstractFactory>.Create(True);
  FEntitiesBuilders := TDictionary<TEntityClass, TRttiMethod>.Create;
end;

class destructor TFactories.Destroy;
begin
  FFactories.Free;
  FEntitiesBuilders.Free;
end;

class function TFactories.Duplicate<T>(Source: T): T;
begin
  Result := getInstance<T>;
  Result.Assign(Source);
end;

class function TFactories.getBuilder(c: TEntityClass): TRttiMethod;
begin
  if not FEntitiesBuilders.TryGetValue(c, Result) then
  begin
    Result := RttiContext.GetType(c).GetMethod('Create');
    FEntitiesBuilders.Add(c, Result);
  end;
end;

class function TFactories.getFactory(T: TEntityClass): TAbstractFactory;
var
  CandidateFactory: TAbstractFactory;
begin
  for CandidateFactory in FFactories do
    if CandidateFactory.Supports(T) then
      Exit(TAbstractFactory(CandidateFactory));
  Result := nil;
end;

class function TFactories.getFactory<T>: TAbstractFactory<T>;
var
  CandidateFactory: TAbstractFactory;
begin
  for CandidateFactory in FFactories do
    if CandidateFactory.Supports(T) then
      Exit(TAbstractFactory<T>(CandidateFactory));
  Result := nil;
end;

class function TFactories.getInstance<T>: T;
begin
  Result := BuildInstance<T>;
end;

end.
