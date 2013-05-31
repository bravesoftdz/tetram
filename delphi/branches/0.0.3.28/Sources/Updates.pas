unit Updates;

interface

uses
  Contnrs, JvUIB;

type
  TUpdateCallback = procedure(Query: TJvUIBScript);

  TUpdate = class
    Version: string;
    UpdateCallback: TUpdateCallback;
  end;

const
  ListUpdates: TObjectList = nil;

procedure RegisterUpdate(Version: string; ProcMAJ: TUpdateCallback);

implementation

uses Divers;

function CompareUpdate(Item1, Item2: Pointer): Integer;
begin
  Result := CompareVersionNum(TUpdate(Item1).Version, TUpdate(Item2).Version);
end;

procedure RegisterUpdate(Version: string; ProcMAJ: TUpdateCallback);
var
  Update: TUpdate;
begin
  Update := TUpdate.Create;
  Update.Version := Version;
  Update.UpdateCallback := ProcMAJ;
  ListUpdates.Add(Update);
  ListUpdates.Sort(CompareUpdate);
end;

initialization
  ListUpdates := TObjectList.Create(True);

finalization
  ListUpdates.Free;

end.
