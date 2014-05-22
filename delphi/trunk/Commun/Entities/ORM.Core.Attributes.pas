unit ORM.Core.Attributes;

interface

uses System.SysUtils, System.Rtti, System.TypInfo, ORM.Core.Entities;

type
  TRelatedAttribute = class abstract(TCustomAttribute)
  private
    Fm: TRttiMethod;
    Fc: TRttiType;
    Ff: TRttiField;
    Fp: TRttiProperty;
    Ft: PTypeInfo;
    procedure Setc(const Value: TRttiType);
    procedure Setf(const Value: TRttiField);
    procedure Setm(const Value: TRttiMethod);
    procedure Setp(const Value: TRttiProperty);
  public
    procedure SetValue(Instance: Pointer; const AValue: TValue); overload;
    procedure SetValue(Instance: Pointer; const AValue); overload;
    function GetValue(Instance: Pointer): TValue; overload;
    function GetValue<T>(Instance: Pointer): T; overload;
    function IsClass(c: TClass): Boolean;

    property c: TRttiType read Fc write Setc;
    property f: TRttiField read Ff write Setf;
    property p: TRttiProperty read Fp write Setp;
    property m: TRttiMethod read Fm write Setm;
    property T: PTypeInfo read Ft;
  end;

  EntityAttribute = class(TRelatedAttribute)
  private
    FTableName: string;
    function GetTableName: string;
  public
    constructor Create(const TableName: string = '');

    property TableName: string read GetTableName;
  end;

  EntityFieldAttribute = class(TRelatedAttribute)
  private
    FFieldName: string;
    function GetFieldName: string;
  public
    constructor Create(const FieldName: string = '');

    property FieldName: string read GetFieldName;
  end;

  PrimaryKeyAttribute = class(EntityFieldAttribute)

  end;

  EntityListAttribute = class(TRelatedAttribute)
  private
    FDaoClass: TClass;
  public
    constructor Create(DaoClass: TClass);
    property DaoClass: TClass read FDaoClass;
  end;

  DaoAttribute = class(TRelatedAttribute)
  private
    FEntityClass: TEntityClass;
  public
    constructor Create(EntityClass: TEntityClass);
  published
    property EntityClass: TEntityClass read FEntityClass;
  end;

implementation

uses
  ORM.Core.Dao, ORM.Core.Factories;

{ TRelatedAttribute }

function TRelatedAttribute.GetValue(Instance: Pointer): TValue;
begin
  if f <> nil then
    Result := f.GetValue(Instance)
  else if p <> nil then
    Result := p.GetValue(Instance)
  else
    Result := TValue.Empty;
end;

function TRelatedAttribute.GetValue<T>(Instance: Pointer): T;
begin
  Result := GetValue(Instance).AsType<T>;
end;

function TRelatedAttribute.IsClass(c: TClass): Boolean;
begin
  Result := (T.Kind = tkClass) and T.TypeData.ClassType.InheritsFrom(c);
end;

procedure TRelatedAttribute.Setc(const Value: TRttiType);
begin
  Assert(Value.AsInstance.MetaclassType.InheritsFrom(TabstractDBEntity), 'TRelatedAttribute ne peut être attaché qu''à des TabstractDBEntity');
  Fc := Value;
  Ft := Value.Handle;
end;

procedure TRelatedAttribute.Setf(const Value: TRttiField);
begin
  Ff := Value;
  Ft := Value.FieldType.Handle;
end;

procedure TRelatedAttribute.Setm(const Value: TRttiMethod);
begin
  Fm := Value;
end;

procedure TRelatedAttribute.Setp(const Value: TRttiProperty);
begin
  Assert(Value.IsReadable and (Value.IsWritable or Value.PropertyType.IsInstance),
    'TRelatedAttribute ne peut être attaché qu''à des propriétés en lecture/ecriture');
  Fp := Value;
  Ft := Value.PropertyType.Handle;
end;

procedure TRelatedAttribute.SetValue(Instance: Pointer; const AValue);
var
  v: TValue;
begin
  TValue.Make(@AValue, T, v);
  SetValue(Instance, v);
end;

procedure TRelatedAttribute.SetValue(Instance: Pointer; const AValue: TValue);
begin
  if f <> nil then
    f.SetValue(Instance, AValue)
  else if p <> nil then
    p.SetValue(Instance, AValue);
end;

{ EntityAttribute }

constructor EntityAttribute.Create(const TableName: string);
begin
  inherited Create;
  FTableName := TableName;
end;

function EntityAttribute.GetTableName: string;
begin
  if FTableName.Equals(string.Empty) and (c <> nil) then
    Result := c.Name
  else
    Result := FTableName;
end;

{ EntityFieldAttribute }

constructor EntityFieldAttribute.Create(const FieldName: string = '');
begin
  FFieldName := FieldName;
end;

function EntityFieldAttribute.GetFieldName: string;
begin
  if FFieldName.Equals(string.Empty) and (f <> nil) then
    Result := f.Name
  else if FFieldName.Equals(string.Empty) and (p <> nil) then
    Result := p.Name
  else
    Result := FFieldName;
end;

{ EntityListAttribute }

// on ne peut pas utiliser TDaoDBEntityClass dans la déclaration, ça provoque une référence circulaire
constructor EntityListAttribute.Create(DaoClass: TClass);
begin
  // Assert(DaoClass.InheritsFrom(TDaoDBEntity), 'DaoClass doit hérité de TDaoDBEntity');
  inherited Create;
  FDaoClass := DaoClass;
end;

{ DaoAttribute }

constructor DaoAttribute.Create(EntityClass: TEntityClass);
begin
  FEntityClass := EntityClass;
end;

end.
