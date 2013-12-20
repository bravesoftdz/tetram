unit JsonSerializer;

interface

uses
  System.SysUtils, System.Classes, System.Rtti, System.Generics.Collections, Commun,
  EntitiesFull, EntitiesLite, UMetadata, dwsJSON, System.TypInfo;

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
    class procedure WriteListLiteToJSON<T: TBaseLite>(list: TList<T>; json: TdwsJSONArray);
    class procedure WriteListFullToJSON<T: TBaseFull>(list: TList<T>; json: TdwsJSONArray);

    class procedure WriteValueToJSON(const Name, Value: string; json: TdwsJSONObject); overload; inline;
    class procedure WriteValueToJSON(const Name: string; Value: Integer; json: TdwsJSONObject); overload; inline;
    class procedure WriteValueToJSON(const Name: string; Value: Currency; json: TdwsJSONObject); overload; inline;
    class procedure WriteValueToJSON(const Name: string; Value: Boolean; json: TdwsJSONObject); overload; inline;
    class procedure WriteValueToJSON(const Name: string; Value: ROption; json: TdwsJSONObject); overload; inline;
    class procedure WriteValueToJSON(const Name: string; Value: RGUIDEx; json: TdwsJSONObject); overload; inline;
    class procedure WriteValueToJSON(const Name: string; Value: TMetierAuteur; json: TdwsJSONObject); overload; inline;
    class procedure WriteValueToJSON(const Name: string; Value: TStrings; json: TdwsJSONObject; ItemsHasValues: Boolean = False); overload; inline;
  public
    class constructor Create;
    class destructor Destroy;

    class function AsJson(Entity: TObject; Indent: Boolean): string;

    class procedure WriteToJSON(obj: TObject; json: TdwsJSONObject);
  end;

implementation

{ TJsonSerializer }

class function TJsonSerializer.AsJson(Entity: TObject; Indent: Boolean): string;
var
  o: TdwsJSONObject;
begin
  o := TdwsJSONObject.Create;
  try
    WriteToJSON(Entity, o);
    if Indent then
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

class procedure TJsonSerializer.WriteToJSON(obj: TObject; json: TdwsJSONObject);
var
  params: array [0 .. 1] of TValue;
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
      TValue.Make(@obj, c.ClassInfo, params[0]);
      TValue.Make(@json, json.ClassInfo, params[1]);
      m.Invoke(Self, params);
    end;
  finally
    listMethods.Free;
  end;
end;

class procedure TJsonSerializer.WriteValueToJSON(const Name: string; Value: Currency; json: TdwsJSONObject);
begin
  // if Value <> 0 then
  json.AddValue(Name, Value);
end;

class procedure TJsonSerializer.WriteValueToJSON(const Name: string; Value: Integer; json: TdwsJSONObject);
begin
  // if Value <> 0 then
  json.AddValue(Name, Value);
end;

class procedure TJsonSerializer.WriteListFullToJSON<T>(list: TList<T>; json: TdwsJSONArray);
var
  o: T;
begin
  for o in list do
    WriteToJSON(o, json.AddObject);
end;

class procedure TJsonSerializer.WriteListLiteToJSON<T>(list: TList<T>; json: TdwsJSONArray);
var
  o: T;
begin
  for o in list do
    WriteToJSON(o, json.AddObject);
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
    json.AddObject.AddValue(list.Names[i], list.ValueFromIndex[i]);
end;

class procedure TJsonSerializer.WriteValueToJSON(const Name, Value: string; json: TdwsJSONObject);
begin
  // if Value <> '' then
  json.AddValue(Name, Value);
end;

class procedure TJsonSerializer.WriteValueToJSON(const Name: string; Value: TMetierAuteur; json: TdwsJSONObject);
begin
  // if Value in [Low(TMetierAuteur) .. High(TMetierAuteur)] then
  json.AddObject(Name).AddValue(IntToStr(Ord(Value)), GetEnumName(TypeInfo(TMetierAuteur), Ord(Value)).Substring(2));
end;

class procedure TJsonSerializer.WriteValueToJSON(const Name: string; Value: Boolean; json: TdwsJSONObject);
begin
  // if Value then
  json.AddValue(Name, Value);
end;

class procedure TJsonSerializer.WriteValueToJSON(const Name: string; Value: RGUIDEx; json: TdwsJSONObject);
begin
  // if not IsEqualGUID(Value, GUID_NULL) then
  json.AddValue(Name, Value);
end;

class procedure TJsonSerializer.WriteValueToJSON(const Name: string; Value: ROption; json: TdwsJSONObject);
begin
  // if Value.Value > -1 then
  json.AddObject(Name).AddValue(IntToStr(Value.Value), Value.Caption);
end;

class procedure TJsonSerializer.WriteValueToJSON(const Name: string; Value: TStrings; json: TdwsJSONObject; ItemsHasValues: Boolean);
begin
  // if Value.Count > 0 then
  if ItemsHasValues then
    WriteStringListWithValuesToJSON(Value, json.AddArray(Name))
  else
    WriteStringListToJSON(Value, json.AddArray(Name))
end;

end.
