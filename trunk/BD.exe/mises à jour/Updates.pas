unit Updates;

interface

uses
  Contnrs, Classes, UIB, Divers, Generics.Collections, Generics.Defaults;

type
  TUpdateFBCallback = procedure(Query: TUIBScript);
  TUpdateMySQLCallback = procedure(Script: TStrings);

  TBdtkUpdate = class
    Version: TFileVersion;

    type TBdtkUpdateComparer<T: TBdtkUpdate> = class(TComparer<T>)
      function Compare(const Left, Right: T): Integer; override;
    end;
  end;

  TFBUpdate = class(TBdtkUpdate)
    UpdateCallback: TUpdateFBCallback;
  end;

  TMySQLUpdate = class(TBdtkUpdate)
    UpdateCallback: TUpdateMySQLCallback;
  end;

var
  ListFBUpdates: TObjectList<TFBUpdate> = nil;
  ListMySQLUpdates: TObjectList<TMySQLUpdate> = nil;

procedure RegisterFBUpdate(Version: string; ProcMAJ: TUpdateFBCallback);
procedure RegisterMySQLUpdate(Version: string; ProcMAJ: TUpdateMySQLCallback);
procedure LoadScript(const resName: string; Script: TStrings);

implementation

procedure RegisterFBUpdate(Version: string; ProcMAJ: TUpdateFBCallback);
var
  Update: TFBUpdate;
  comp: IComparer<TFBUpdate>;
begin
  Update := TFBUpdate.Create;
  Update.Version := Version;
  Update.UpdateCallback := ProcMAJ;
  ListFBUpdates.Add(Update);
  // on passe par une variable temporaire pour b�n�ficier du comptage de r�f�rence: le const du Sort bypass le comptage
  comp := TBdtkUpdate.TBdtkUpdateComparer<TFBUpdate>.Create;
  ListFBUpdates.Sort(comp);
end;

procedure RegisterMySQLUpdate(Version: string; ProcMAJ: TUpdateMySQLCallback);
var
  Update: TMySQLUpdate;
  comp: IComparer<TMySQLUpdate>;
begin
  Update := TMySQLUpdate.Create;
  Update.Version := Version;
  Update.UpdateCallback := ProcMAJ;
  ListMySQLUpdates.Add(Update);
  // on passe par une variable temporaire pour b�n�ficier du comptage de r�f�rence: le const du Sort bypass le comptage
  comp := TBdtkUpdate.TBdtkUpdateComparer<TMySQLUpdate>.Create;
  ListMySQLUpdates.Sort(comp);
end;

procedure LoadScript(const resName: string; Script: TStrings);
var
  s: TResourceStream;
begin
  s := TResourceStream.Create(HInstance, resName, 'ScriptsUpdate');
  with s do
    try
      Script.LoadFromStream(s);
    finally
      Free;
    end;
end;

{ TBdtkUpdate.TBdtkUpdateComparer<T> }

function TBdtkUpdate.TBdtkUpdateComparer<T>.Compare(const Left, Right: T): Integer;
begin
  Result := Left.Version - Right.Version;
end;

initialization
  ListFBUpdates := TObjectList<TFBUpdate>.Create(True);
  ListMySQLUpdates := TObjectList<TMySQLUpdate>.Create(True);

finalization
  ListFBUpdates.Free;
  ListMySQLUpdates.Free;

end.
