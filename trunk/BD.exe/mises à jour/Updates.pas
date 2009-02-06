unit Updates;

interface

uses
  Contnrs, Classes, UIB;

type
  TUpdateFBCallback = procedure(Query: TUIBScript);
  TUpdateMySQLCallback = procedure (Script: TStrings);

  TFBUpdate = class
    Version: string;
    UpdateCallback: TUpdateFBCallback;
  end;

  TMySQLUpdate = class
    Version: string;
    UpdateCallback: TUpdateMySQLCallback;
  end;

const
  ListFBUpdates: TObjectList = nil;
  ListMySQLUpdates: TObjectList = nil;

procedure RegisterFBUpdate(Version: string; ProcMAJ: TUpdateFBCallback);
procedure RegisterMySQLUpdate(Version: string; ProcMAJ: TUpdateMySQLCallback);
procedure LoadScript(const resName: string; Script: TStrings);

implementation

uses Divers;

function CompareFBUpdate(Item1, Item2: Pointer): Integer;
begin
  Result := CompareVersionNum(TFBUpdate(Item1).Version, TFBUpdate(Item2).Version);
end;

function CompareMySQLUpdate(Item1, Item2: Pointer): Integer;
begin
  Result := CompareVersionNum(TMySQLUpdate(Item1).Version, TMySQLUpdate(Item2).Version);
end;

procedure RegisterFBUpdate(Version: string; ProcMAJ: TUpdateFBCallback);
var
  Update: TFBUpdate;
begin
  Update := TFBUpdate.Create;
  Update.Version := Version;
  Update.UpdateCallback := ProcMAJ;
  ListFBUpdates.Add(Update);
  ListFBUpdates.Sort(CompareFBUpdate);
end;

procedure RegisterMySQLUpdate(Version: string; ProcMAJ: TUpdateMySQLCallback);
var
  Update: TMySQLUpdate;
begin
  Update := TMySQLUpdate.Create;
  Update.Version := Version;
  Update.UpdateCallback := ProcMAJ;
  ListMySQLUpdates.Add(Update);
  ListMySQLUpdates.Sort(CompareMySQLUpdate);
end;

procedure LoadScript(const resName: string; Script: TStrings);
var
  s: TResourceStream;
begin
  s := TResourceStream.Create(HInstance, resName, 'ScriptsUpdate');
  with s do try
    Script.LoadFromStream(s);
  finally
    Free;
  end;
end;

initialization
  ListFBUpdates := TObjectList.Create(True);
  ListMySQLUpdates := TObjectList.Create(True);

finalization
  ListFBUpdates.Free;
  ListMySQLUpdates.Free;

end.
