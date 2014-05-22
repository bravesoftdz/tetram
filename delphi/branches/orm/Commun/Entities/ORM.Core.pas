unit ORM.Core;

interface

uses System.SysUtils, System.Classes, System.Rtti, System.Generics.Collections, ORM.Core.Attributes, ORM.Core.Entities;

type
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
