unit Entities.DaoLambdaJSON;

interface

uses
  System.SysUtils, System.Classes, BD.Entities.Dao.Lambda;

type
  // surcharge de TDaoListe pour pouvoir accéder aux elements protected
  // mais dans ce type de classe, ce n'est pas possible de surcharger les méthodes (donc Create/Destroy)
  // donc obligation d'utiliser les sections initialization/finalization
  TDaoListeJSON = class(TDaoListe)
  private
    class var Fjson: string;
    class procedure SetJSON(const Value: string); static;
  protected
    class procedure DoEnsureDefaultValues;
    class procedure DoEnsureLists;
  public
    class property json: string read Fjson write SetJSON;
  end;

implementation

uses
  dwsJSON, BD.Utils.Deserializer.JSON, System.TypInfo, BD.Entities.Full;

{ TDaoListeJSON }

class procedure TDaoListeJSON.DoEnsureDefaultValues;
var
  o: TdwsJSONObject;
  c: TDaoListe.CategorieIndex;
  s: string;
begin
  if FDefaultValuesLoaded then
    Exit;

  o := TdwsJSONObject.ParseString(json) as TdwsJSONObject;
  try
    for c := Succ(TDaoListe.CategorieIndex.piNOTUSED) to High(TDaoListe.CategorieIndex) do
    begin
      s := GetEnumName(TypeInfo(TDaoListe.CategorieIndex), Integer(c)).Substring(2);
      TDaoListe.FDefaultValues[c] := TJsonDeserializer.ReadValueFromJSON('default' + s, TDaoListe.FDefaultValues[c], o);
    end;

  finally
    o.Free;
  end;

  FDefaultValuesLoaded := True;
end;

class procedure TDaoListeJSON.DoEnsureLists;
var
  o: TdwsJSONObject;
  c: TDaoListe.CategorieIndex;
  s: string;
begin
  if FListsLoaded then
    Exit;

  o := TdwsJSONObject.ParseString(json) as TdwsJSONObject;
  try
    for c := Succ(TDaoListe.CategorieIndex.piNOTUSED) to High(TDaoListe.CategorieIndex) do
    begin
      s := GetEnumName(TypeInfo(TDaoListe.CategorieIndex), Integer(c)).Substring(2);
      TJsonDeserializer.ReadValueFromJSON('list' + s, TDaoListe.FLists[c], o, True);
    end;

  finally
    o.Free;
  end;

  FListsLoaded := True;
end;

class procedure TDaoListeJSON.SetJSON(const Value: string);
begin
  Fjson := Value;
  FDefaultValuesLoaded := False;
  FListsLoaded := False;
end;

initialization

TDaoListe.EnsureDefaultValues := TDaoListeJSON.DoEnsureDefaultValues;
TDaoListe.EnsureLists := TDaoListeJSON.DoEnsureLists;

finalization

TDaoListe.EnsureDefaultValues := nil;
TDaoListe.EnsureLists := nil;

end.
