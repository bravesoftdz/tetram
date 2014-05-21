unit ORM.Core.Entities;

interface

uses
  System.SysUtils, System.Classes, System.Rtti, Commun, System.Generics.Collections, ORM.Core.Attributes;

type
  TEntity = class;
  TEntityClass = class of TEntity;
  TDBEntityClass = class of TDBEntity;

  TInitEvent = procedure(Entity: TEntity) of object;

{$RTTI EXPLICIT METHODS([vcPublic, vcProtected])}

  TEntity = class abstract(TPersistent)
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

  TDBEntity = class abstract(TEntity)
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

  TEntityMetadataCache = class
  public type
    TMetadataInfo = class
    public
      EntityDesc: EntityAttribute;
      PrimaryKeyDesc: PrimaryKeyAttribute;
      FieldsDesc: TList<EntityFieldAttribute>;
      constructor Create;
      destructor Destroy; override;
      function getSelectSQL: string;
      function getDeleteSQL: string;
      function getUpdateInsertSQL: string;
    end;

  private
    class var RttiContext: TRttiContext;
    class var FRTTIPrepared: TDictionary<TDBEntityClass, TMetadataInfo>;
  public
    class constructor Create;
    class destructor Destroy;

    class function PrepareRTTI(c: TDBEntityClass): TMetadataInfo;
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
  TEntityMetadataCache.PrepareRTTI(TDBEntityClass(Self.ClassType));
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

{ TEntityMetadataCache.TMetadataInfo }

constructor TEntityMetadataCache.TMetadataInfo.Create;
begin
  FieldsDesc := TList<EntityFieldAttribute>.Create;
end;

destructor TEntityMetadataCache.TMetadataInfo.Destroy;
begin
  FieldsDesc.Free;
  inherited;
end;

function TEntityMetadataCache.TMetadataInfo.getDeleteSQL: string;
begin
  Result := 'delete from ' + EntityDesc.TableName + ' where ' + PrimaryKeyDesc.FieldName + ' = :' + PrimaryKeyDesc.FieldName;
end;

function TEntityMetadataCache.TMetadataInfo.getSelectSQL: string;
var
  f: EntityFieldAttribute;
begin
  Result := 'select ' + PrimaryKeyDesc.FieldName;
  for f in FieldsDesc do
    Result := Result + ', ' + f.FieldName;
  Result := Result + ' from ' + EntityDesc.TableName;
  Result := Result + ' where ' + PrimaryKeyDesc.FieldName + ' = :' + PrimaryKeyDesc.FieldName;
end;

function TEntityMetadataCache.TMetadataInfo.getUpdateInsertSQL: string;
var
  f: EntityFieldAttribute;
begin
  Result := 'update or insert into ' + EntityDesc.TableName + ' (';
  Result := Result + PrimaryKeyDesc.FieldName;
  for f in FieldsDesc do
    Result := Result + ', ' + f.FieldName;
  Result := Result + ') values (';
  Result := Result + ':' + PrimaryKeyDesc.FieldName;
  for f in FieldsDesc do
    Result := Result + ', :' + f.FieldName;
  Result := Result + ') returning ' + PrimaryKeyDesc.FieldName;
end;

{ TEntityMetadataCache }

class constructor TEntityMetadataCache.Create;
begin
  FRTTIPrepared := TObjectDictionary<TDBEntityClass, TMetadataInfo>.Create([doOwnsValues]);
end;

class destructor TEntityMetadataCache.Destroy;
begin
  FRTTIPrepared.Free;
end;

class function TEntityMetadataCache.PrepareRTTI(c: TDBEntityClass): TMetadataInfo;
var
  attr: TCustomAttribute;
  RC: TRttiType;
  f: TRttiField;
  p: TRttiProperty;
  m: TRttiMethod;
begin
  if FRTTIPrepared.TryGetValue(c, Result) then
    Exit;

  Result := TMetadataInfo.Create;
  FRTTIPrepared.Add(c, Result);

  RC := RttiContext.GetType(c);

  for attr in RC.GetAttributes do
    if attr is TRelatedAttribute then
    begin
      TRelatedAttribute(attr).c := RC;
      if attr is EntityAttribute then
        Result.EntityDesc := EntityAttribute(attr);
    end;

  for f in RC.GetFields do
    for attr in f.GetAttributes do
      if attr is TRelatedAttribute then
      begin
        TRelatedAttribute(attr).c := RC;
        TRelatedAttribute(attr).f := f;
        if attr is PrimaryKeyAttribute then
          Result.PrimaryKeyDesc := PrimaryKeyAttribute(attr)
        else if attr is EntityFieldAttribute then
          Result.FieldsDesc.Add(EntityFieldAttribute(attr));
      end;

  for p in RC.GetProperties do
    for attr in p.GetAttributes do
      if attr is TRelatedAttribute then
      begin
        TRelatedAttribute(attr).c := RC;
        TRelatedAttribute(attr).p := p;
        if attr is PrimaryKeyAttribute then
          Result.PrimaryKeyDesc := PrimaryKeyAttribute(attr)
        else if attr is EntityFieldAttribute then
          Result.FieldsDesc.Add(EntityFieldAttribute(attr));
      end;

  for m in RC.GetMethods do
    for attr in m.GetAttributes do
      if attr is TRelatedAttribute then
      begin
        TRelatedAttribute(attr).c := RC;
        TRelatedAttribute(attr).m := m;
      end;
end;

end.
