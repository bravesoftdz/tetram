unit ORM.Core.Entities;

interface

uses
  System.SysUtils, System.Classes, System.Rtti, ORM.Core.Types, System.Generics.Collections;

type
  TabstractEntity = class;
  TEntityClass = class of TabstractEntity;
  TDBEntityClass = class of TabstractDBEntity;

  TInitEvent = procedure(Entity: TabstractEntity) of object;

{$RTTI EXPLICIT METHODS([vcPublic, vcProtected])}

  TabstractEntity = class abstract(TPersistent)
  private
    class var FInitEvents: TDictionary<TClass, TList<TInitEvent>>;
    class procedure InitClass;
    procedure TriggerInitEvents;
  protected
    procedure DoClear; virtual;
    constructor Create; virtual;
  public
    class constructor Create;
    class destructor Destroy;

    procedure BeforeDestruction; override;
    procedure AfterConstruction; override;

    procedure Clear;

    class procedure RegisterInitEvent(InitEvent: TInitEvent);
    class procedure UnregisterInitEvent(InitEvent: TInitEvent);
  end;

  TabstractDBEntity = class abstract(TabstractEntity)
  private
    FID: RGUIDEx;
  protected
    constructor Create; override;
    procedure DoClear; override;
    function GetID: RGUIDEx;
    procedure SetID(const Value: RGUIDEx);
  public
    procedure Assign(Source: TPersistent); override;

    property ID: RGUIDEx read GetID write SetID;
  end;

implementation

{ TabstractEntity }

uses ORM.Core;

procedure TabstractEntity.AfterConstruction;
begin
  inherited;
  Clear;
end;

procedure TabstractEntity.BeforeDestruction;
begin
  inherited;
  Clear;
end;

procedure TabstractEntity.DoClear;
begin
end;

class procedure TabstractEntity.InitClass;
begin
  if FInitEvents = nil then
    FInitEvents := TObjectDictionary < TClass, TList < TInitEvent >>.Create([doOwnsValues]);
end;

class constructor TabstractEntity.Create;
begin
  InitClass;
end;

constructor TabstractEntity.Create;
begin

end;

class destructor TabstractEntity.Destroy;
begin
  FInitEvents.Free;
end;

procedure TabstractEntity.Clear;
begin
  DoClear;
  TriggerInitEvents;
end;

class procedure TabstractEntity.RegisterInitEvent(InitEvent: TInitEvent);
var
  initEvents: TList<TInitEvent>;
begin
  InitClass;
  if not FInitEvents.TryGetValue(Self, initEvents) then
  begin
    initEvents := TList<TInitEvent>.Create;
    FInitEvents.Add(Self, initEvents);
  end;
  if not initEvents.Contains(InitEvent) then
    initEvents.Add(InitEvent);
end;

procedure TabstractEntity.TriggerInitEvents;
var
  initEvents: TList<TInitEvent>;
  InitEvent: TInitEvent;
begin
  if FInitEvents.TryGetValue(Self.ClassType, initEvents) then
    for InitEvent in initEvents do
      InitEvent(Self);
end;

class procedure TabstractEntity.UnregisterInitEvent(InitEvent: TInitEvent);
var
  initEvents: TList<TInitEvent>;
begin
  if FInitEvents.TryGetValue(Self, initEvents) then
    initEvents.Remove(InitEvent);
end;

{ TabstractDBEntity }

procedure TabstractDBEntity.Assign(Source: TPersistent);
begin
  if Source is TabstractDBEntity then
    Self.ID := TabstractDBEntity(Source).ID
  else
    inherited;
end;

procedure TabstractDBEntity.DoClear;
begin
  inherited;
  FID := GUID_NULL;
end;

constructor TabstractDBEntity.Create;
begin
  TEntityMetadataCache.PrepareRTTI(TDBEntityClass(Self.ClassType));
  inherited;
end;

function TabstractDBEntity.GetID: RGUIDEx;
begin
  Result := FID;
end;

procedure TabstractDBEntity.SetID(const Value: RGUIDEx);
begin
  FID := Value;
end;

end.
