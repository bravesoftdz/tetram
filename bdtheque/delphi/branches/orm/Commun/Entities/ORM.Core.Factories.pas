unit ORM.Core.Factories;

interface

uses
  System.Rtti, System.Generics.Collections, ORM.Core.Entities;

type
  TAbstractFactory<T: TabstractEntity> = class sealed
  private
    function BuildInstance: T;
  private
    FEntityClass: TEntityClass;
  public
    class constructor Create;

    constructor Create;

    function Supports(AClass: TEntityClass): Boolean;

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
  public
    class constructor Create;
    class destructor Destroy;

    class function getFactory<T: TabstractEntity>: TAbstractFactory<T>; overload;
    class function getFactory(T: TEntityClass): TAbstractFactory; overload;
  end;

implementation

{ TDaoEntity }

function TAbstractFactory<T>.BuildInstance: T;
begin
  Result := TFactories.getBuilder(FEntityClass).Invoke(FEntityClass, []).AsObject as T;
end;

class constructor TAbstractFactory<T>.Create;
begin
  TFactories.FFactories.Add(TAbstractFactory(TAbstractFactory<T>.Create));
end;

constructor TAbstractFactory<T>.Create;
begin
  FEntityClass := T;
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

function TAbstractFactory<T>.Supports(AClass: TEntityClass): Boolean;
begin
  Result := (FEntityClass = AClass) or FEntityClass.InheritsFrom(AClass);  // do not use "is" operator, it compiles but does not work because it considers T as an instance
end;

{ TFactoriesInitializer }

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

end.
