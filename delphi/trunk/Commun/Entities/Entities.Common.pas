unit Entities.Common;

interface

uses
  System.SysUtils, System.Classes, System.Rtti, Commun, System.Generics.Collections;

type
  TEntity = class;
  TEntityClass = class of TEntity;
  TDBEntityClass = class of TDBEntity;

  TInitEvent = procedure(Entity: TEntity) of object;

{$RTTI EXPLICIT METHODS([vcPublic, vcProtected])}

  TEntity = class(TPersistent)
  private
    class var FInitEvents: TDictionary<TClass, TList<TInitEvent>>;
    procedure TriggerInitEvents;
  protected
    constructor Create; virtual;
  public
    class constructor Create;
    class destructor Destroy;

    procedure BeforeDestruction; override;
    procedure DoClear;
    procedure Clear; virtual;
    procedure AfterConstruction; override;

    class procedure RegisterInitEvent(InitEvent: TInitEvent);
    class procedure UnregisterInitEvent(InitEvent: TInitEvent);
  end;

  TDBEntity = class(TEntity)
  private
    FID: RGUIDEx;
  protected
    constructor Create; override;
  public
    function GetID: RGUIDEx; inline;
    procedure SetID(const Value: RGUIDEx); inline;
    procedure Assign(Source: TPersistent); override;
    procedure Clear; override;

    property ID: RGUIDEx read GetID write SetID;
  end;

implementation

{ TEntity }

procedure TEntity.AfterConstruction;
begin
  inherited;
  DoClear;
end;

procedure TEntity.BeforeDestruction;
begin
  inherited;
  DoClear;
end;

procedure TEntity.Clear;
begin
end;

class constructor TEntity.Create;
begin
  FInitEvents := TObjectDictionary < TClass, TList < TInitEvent >>.Create([doOwnsValues]);
end;

constructor TEntity.Create;
begin

end;

class destructor TEntity.Destroy;
begin
  FInitEvents.Free;
end;

procedure TEntity.DoClear;
begin
  Clear;
  TriggerInitEvents;
end;

class procedure TEntity.RegisterInitEvent(InitEvent: TInitEvent);
var
  initEvents: TList<TInitEvent>;
begin
  if not FInitEvents.TryGetValue(Self, initEvents) then
  begin
    initEvents := TList<TInitEvent>.Create;
    FInitEvents.Add(Self, initEvents);
  end;
  if not initEvents.Contains(InitEvent) then
    initEvents.Add(InitEvent);
end;

procedure TEntity.TriggerInitEvents;
var
  initEvents: TList<TInitEvent>;
  InitEvent: TInitEvent;
begin
  if FInitEvents.TryGetValue(Self.ClassType, initEvents) then
    for InitEvent in initEvents do
      InitEvent(Self);
end;

class procedure TEntity.UnregisterInitEvent(InitEvent: TInitEvent);
var
  initEvents: TList<TInitEvent>;
begin
  if FInitEvents.TryGetValue(Self, initEvents) then
    initEvents.Remove(InitEvent);
end;

{ TDBEntity }

procedure TDBEntity.Assign(Source: TPersistent);
begin
  if Source is TDBEntity then
    Self.ID := TDBEntity(Source).ID
  else
    inherited;
end;

procedure TDBEntity.Clear;
begin
  inherited;
  FID := GUID_NULL;
end;

constructor TDBEntity.Create;
begin
  inherited;
end;

function TDBEntity.GetID: RGUIDEx;
begin
  Result := FID;
end;

procedure TDBEntity.SetID(const Value: RGUIDEx);
begin
  FID := Value;
end;

end.
