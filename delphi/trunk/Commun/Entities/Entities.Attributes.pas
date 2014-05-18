unit Entities.Attributes;

interface

uses System.SysUtils, System.Rtti;

type
  TRelatedAttribute = class(TCustomAttribute)
  private
    Fm: TRttiMethod;
    Fc: TRttiType;
    Ff: TRttiField;
    Fp: TRttiProperty;
    procedure Setc(const Value: TRttiType);
    procedure Setf(const Value: TRttiField);
    procedure Setm(const Value: TRttiMethod);
    procedure Setp(const Value: TRttiProperty);
  public
    property c: TRttiType read Fc write Setc;
    property f: TRttiField read Ff write Setf;
    property p: TRttiProperty read Fp write Setp;
    property m: TRttiMethod read Fm write Setm;
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
    constructor Create(const FieldName: string = ''); overload;

    property FieldName: string read GetFieldName;
  end;

  PrimaryKeyAttribute = class(EntityFieldAttribute)

  end;

implementation

uses
  Entities.Common;

{ TRelatedAttribute }

procedure TRelatedAttribute.Setc(const Value: TRttiType);
begin
  Assert(Value.AsInstance.MetaclassType.InheritsFrom(TDBEntity), 'TRelatedAttribute ne peut être attaché qu''à des TDBEntity');
  Fc := Value;
end;

procedure TRelatedAttribute.Setf(const Value: TRttiField);
begin
  Ff := Value;
end;

procedure TRelatedAttribute.Setm(const Value: TRttiMethod);
begin
  Fm := Value;
end;

procedure TRelatedAttribute.Setp(const Value: TRttiProperty);
begin
  Fp := Value;
end;

{ EntityAttribute }

constructor EntityAttribute.Create(const TableName: string);
begin
  FTableName := TableName;
end;

function EntityAttribute.GetTableName: string;
begin
  if FTableName.Equals(string.Empty) and not c.Equals(nil) then
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
  if FFieldName.Equals(string.Empty) and not f.Equals(nil) then
    Result := f.Name
  else if FFieldName.Equals(string.Empty) and not p.Equals(nil) then
    Result := p.Name
  else
    Result := FFieldName;
end;

end.
