unit BD.Utils.Serializer.JSON;

interface

uses
  System.SysUtils, System.Classes, System.Rtti, System.Generics.Collections, BD.Utils.StrUtils,
  BD.Entities.Full, BD.Entities.Lite, BD.Entities.Metadata, dwsJSON, System.TypInfo, BD.Entities.Common;

type
  SerializationOption = (soIndent, soFull, soSkipNullValues);
  SerializationOptions = set of SerializationOption;

type
{$TYPEINFO ON}
{$RTTI EXPLICIT METHODS([vcPrivate, vcPublic, vcProtected])}
  TJsonSerializer = class
  strict private
    class var RttiContext: TRttiContext;
    class var FJsonWriters: TDictionary<PTypeInfo, TRttiMethod>;
    class procedure EnsureJsonWritersCache;
  protected
    class procedure WriteStringListToJSON(list: TStrings; json: TdwsJSONArray);
    class procedure WriteStringListWithValuesToJSON(list: TStrings; json: TdwsJSONArray);
    class procedure WriteListEntityToJSON<T: TDBEntity>(list: TList<T>; json: TdwsJSONArray; Options: SerializationOptions);
  public
    class procedure WriteValueToJSON(const Name, Value: string; json: TdwsJSONObject; Options: SerializationOptions); overload; inline;
    class procedure WriteValueToJSON(const Name: string; Value: Integer; json: TdwsJSONObject; Options: SerializationOptions); overload; inline;
    class procedure WriteValueToJSON(const Name: string; Value: Currency; json: TdwsJSONObject; Options: SerializationOptions); overload; inline;
    class procedure WriteValueToJSON(const Name: string; Value: Boolean; json: TdwsJSONObject; Options: SerializationOptions); overload; inline;
    class procedure WriteValueToJSON(const Name: string; Value: TStrings; json: TdwsJSONObject; Options: SerializationOptions; ItemsHasValues: Boolean = False);
      overload; inline;

    class constructor Create;
    class destructor Destroy;

    class function AsJson(Entity: TObject; Options: SerializationOptions = []): string;

    class procedure WriteToJSON(obj: TObject; json: TdwsJSONObject; Options: SerializationOptions = []);
  end;

implementation

{ TJsonSerializer }

class function TJsonSerializer.AsJson(Entity: TObject; Options: SerializationOptions): string;
var
  o: TdwsJSONObject;
begin
  o := TdwsJSONObject.Create;
  try
    WriteToJSON(Entity, o, Options);
    if soIndent in Options then
      Result := o.ToBeautifiedString
    else
      Result := o.ToString;
  finally
    o.Free;
  end;
end;

class constructor TJsonSerializer.Create;
begin
  FJsonWriters := TDictionary<PTypeInfo, TRttiMethod>.Create;
end;

class destructor TJsonSerializer.Destroy;
begin
  FJsonWriters.Free;
end;

class procedure TJsonSerializer.EnsureJsonWritersCache;
var
  m: TRttiMethod;
begin
  if FJsonWriters.Count > 0 then
    Exit;

  for m in RttiContext.GetType(Self).GetMethods('ProcessWriteToJSON') do
    FJsonWriters.Add(m.GetParameters[0].ParamType.Handle, m);
end;

class procedure TJsonSerializer.WriteToJSON(obj: TObject; json: TdwsJSONObject; Options: SerializationOptions = []);
var
  params: TArray<TValue>;
  m: TRttiMethod;
  c: TClass;
  listMethods: TList<TRttiMethod>;
begin
  EnsureJsonWritersCache;

  listMethods := TList<TRttiMethod>.Create;
  try
    c := obj.ClassType;
    while c.ClassParent <> nil do
    begin
      if FJsonWriters.TryGetValue(c.ClassInfo, m) then
        listMethods.Add(m);
      c := c.ClassParent;
    end;

    listMethods.Reverse;

    for m in listMethods do
    begin
      SetLength(params, Length(m.GetParameters));
      TValue.Make(@obj, c.ClassInfo, params[0]);
      TValue.Make(@json, json.ClassInfo, params[1]);
      if Length(m.GetParameters) > 2 then
        TValue.Make(@Options, TypeInfo(SerializationOptions), params[2]);
      m.Invoke(Self, params);
    end;
  finally
    listMethods.Free;
  end;
end;

class procedure TJsonSerializer.WriteValueToJSON(const Name: string; Value: Currency; json: TdwsJSONObject; Options: SerializationOptions);
begin
  if (not(soSkipNullValues in Options)) or (Value <> Default (Currency)) then
    json.AddValue(Name, Value);
end;

class procedure TJsonSerializer.WriteValueToJSON(const Name: string; Value: Integer; json: TdwsJSONObject; Options: SerializationOptions);
begin
  if (not(soSkipNullValues in Options)) or (Value <> Default (Integer)) then
    json.AddValue(Name, Value);
end;

class procedure TJsonSerializer.WriteListEntityToJSON<T>(list: TList<T>; json: TdwsJSONArray; Options: SerializationOptions);
var
  o: T;
begin
  for o in list do
    WriteToJSON(o, json.AddObject, Options);
end;

class procedure TJsonSerializer.WriteStringListToJSON(list: TStrings; json: TdwsJSONArray);
var
  s: string;
begin
  for s in list do
    json.Add(s);
end;

class procedure TJsonSerializer.WriteStringListWithValuesToJSON(list: TStrings; json: TdwsJSONArray);
var
  i: Integer;
begin
  for i := 0 to Pred(list.Count) do
    if list.Names[i] <> '' then
      json.AddObject.AddValue(list.Names[i], list.ValueFromIndex[i]);
end;

class procedure TJsonSerializer.WriteValueToJSON(const Name, Value: string; json: TdwsJSONObject; Options: SerializationOptions);
begin
  if (not(soSkipNullValues in Options)) or (Value <> Default (string)) then
    json.AddValue(Name, Value);
end;

class procedure TJsonSerializer.WriteValueToJSON(const Name: string; Value: Boolean; json: TdwsJSONObject; Options: SerializationOptions);
begin
  if (not(soSkipNullValues in Options)) or Value then
    json.AddValue(Name, Value);
end;

class procedure TJsonSerializer.WriteValueToJSON(const Name: string; Value: TStrings; json: TdwsJSONObject; Options: SerializationOptions;
  ItemsHasValues: Boolean);
begin
  if (not(soSkipNullValues in Options)) or (Value.Count > 0) then
    if ItemsHasValues then
      WriteStringListWithValuesToJSON(Value, json.AddArray(Name))
    else
      WriteStringListToJSON(Value, json.AddArray(Name))
end;

end.
