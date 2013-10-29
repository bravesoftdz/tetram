unit UMasterEngine;

interface

uses
  System.SysUtils, System.Classes, UScriptList, System.Generics.Collections,
  UScriptUtils, LoadComplet, UScriptEditor, UScriptEngineIntf;

type
  TEngineFactory = class
  public
    constructor Create(MasterEngine: IMasterEngine); virtual; abstract;
    function GetInstance: IEngineInterface; virtual; abstract;
  end;

  TEngineFactoryClass = class of TEngineFactory;

  TMasterEngine = class(TInterfacedObject, IMasterEngine)
  strict private
    FOnBreakPoint: TBreakPointEvent;
    FScriptList: TScriptList;
    FProjectScript: TScript;
    FDebugPlugin: TDebugInfos;
    FTypeEngine: TScriptEngine;
    FEngine: IEngineInterface;
    FInternalAlbumToImport, FAlbumToImport: TAlbumComplet;
    FConsole: TStrings;
    FOnAfterExecute: TAfterExecuteEvent;
    FCompiled: Boolean;
    function GetAlbumToImport: TAlbumComplet;
    procedure SetAlbumToImport(const Value: TAlbumComplet);
    function GetDebugPlugin: IDebugInfos;
    function GetScriptList: TScriptList;
    function GetEngine: IEngineInterface;
    function GetTypeEngine: TScriptEngine;
    procedure SetTypeEngine(const Value: TScriptEngine);
    function GetConsole: TStrings;
    procedure SetConsole(const Value: TStrings);
    function GetOnAfterExecute: TAfterExecuteEvent;
    procedure SetOnAfterExecute(const Value: TAfterExecuteEvent);
    procedure AfterExecute;
    procedure ToggleBreakPoint(const UnitName: string; Line: Cardinal; Keep: Boolean);
    function GetOnBreakPoint: TBreakPointEvent;
    procedure SetOnBreakPoint(const Value: TBreakPointEvent);
    procedure SelectProjectScript(ProjectScript: TScript);
    function GetProjectScript: TScript;
    procedure SetCompiled(const Value: Boolean);
    function GetCompiled: Boolean;
    function GetInternalUnitName(Script: TScript): string;
  public
    constructor Create;
    destructor Destroy; override;

    procedure WriteToConsole(const Chaine: string);

    function GetAlbumToUpdate: Boolean;
    property AlbumToImport: TAlbumComplet read GetAlbumToImport write SetAlbumToImport;

    property ScriptList: TScriptList read GetScriptList;
  end;

procedure RegisterEngineScript(Engine: TScriptEngine; const EngineFactoryClass: TEngineFactoryClass);

implementation

{ %CLASSGROUP 'System.Classes.TPersistent' }

var
  Engines: TDictionary<TScriptEngine, TEngineFactoryClass> = nil;

procedure RegisterEngineScript(Engine: TScriptEngine; const EngineFactoryClass: TEngineFactoryClass);
begin
  if not Assigned(Engines) then
    Engines := TDictionary<TScriptEngine, TEngineFactoryClass>.Create;
  Engines.AddOrSetValue(Engine, EngineFactoryClass);
end;

{ TdmScripts }

function TMasterEngine.GetAlbumToUpdate: Boolean;
begin
  Result := FAlbumToImport <> FInternalAlbumToImport;
end;

function TMasterEngine.GetCompiled: Boolean;
begin
  Result := FCompiled;
end;

function TMasterEngine.GetConsole: TStrings;
begin
  Result := FConsole;
end;

function TMasterEngine.GetProjectScript: TScript;
begin
  Result := FProjectScript;
end;

procedure TMasterEngine.AfterExecute;
begin
  if Assigned(FOnAfterExecute) then
    FOnAfterExecute;
end;

constructor TMasterEngine.Create;
begin
  FDebugPlugin := TDebugInfos.Create;
  FInternalAlbumToImport := TAlbumComplet.Create;
  FAlbumToImport := FInternalAlbumToImport;
  FScriptList := TScriptList.Create;
end;

destructor TMasterEngine.Destroy;
begin
  SetTypeEngine(seNone);
  FInternalAlbumToImport.Free;
  FDebugPlugin.Free;
  FScriptList.Free;
  inherited;
end;

function TMasterEngine.GetAlbumToImport: TAlbumComplet;
begin
  Result := FInternalAlbumToImport;
end;

function TMasterEngine.GetDebugPlugin: IDebugInfos;
begin
  Result := FDebugPlugin;
end;

function TMasterEngine.GetEngine: IEngineInterface;
begin
  Result := FEngine;
end;

function TMasterEngine.GetInternalUnitName(Script: TScript): string;
begin
  Result := Script.ScriptUnitName;
  if Result = GetProjectScript.ScriptUnitName then
    Result := GetEngine.GetSpecialMainUnitName;
end;

function TMasterEngine.GetOnAfterExecute: TAfterExecuteEvent;
begin
  Result := FOnAfterExecute;
end;

function TMasterEngine.GetOnBreakPoint: TBreakPointEvent;
begin
  Result := FOnBreakPoint;
end;

function TMasterEngine.GetScriptList: TScriptList;
begin
  Result := FScriptList;
end;

function TMasterEngine.GetTypeEngine: TScriptEngine;
begin
  Result := FTypeEngine;
end;

procedure TMasterEngine.SelectProjectScript(ProjectScript: TScript);
begin
  if FProjectScript = ProjectScript then
    Exit;

  FProjectScript := ProjectScript;
  SetTypeEngine(FProjectScript.ScriptInfos.Engine);
end;

procedure TMasterEngine.SetAlbumToImport(const Value: TAlbumComplet);
begin
  if (GetEngine = nil) or (not GetEngine.Running) then
  begin
    if Value = nil then
      FAlbumToImport := FInternalAlbumToImport
    else
      FAlbumToImport := Value;
  end;
end;

procedure TMasterEngine.SetCompiled(const Value: Boolean);
begin
  FCompiled := Value;
end;

procedure TMasterEngine.SetConsole(const Value: TStrings);
begin
  FConsole := Value;
end;

procedure TMasterEngine.SetOnAfterExecute(const Value: TAfterExecuteEvent);
begin
  FOnAfterExecute := Value;
end;

procedure TMasterEngine.SetOnBreakPoint(const Value: TBreakPointEvent);
begin
  FOnBreakPoint := Value;
end;

procedure TMasterEngine.SetTypeEngine(const Value: TScriptEngine);
var
  EngineFactoryClass: TEngineFactoryClass;
begin
  FTypeEngine := Value;

  if (Value <> seNone) and Engines.TryGetValue(Value, EngineFactoryClass) then
    with EngineFactoryClass.Create(Self) do
      try
        FEngine := GetInstance;
      finally
        Free;
      end
  else
    FEngine := nil;
end;

procedure TMasterEngine.ToggleBreakPoint(const UnitName: string; Line: Cardinal; Keep: Boolean);
var
  i: Integer;
begin
  i := FDebugPlugin.Breakpoints.IndexOf(UnitName, Line);
  if i = -1 then // nouveau point d'arrêt
    FDebugPlugin.Breakpoints.AddBreakpoint(UnitName, Line)
  else if Keep then // changement d'état du point d'arrêt
    FDebugPlugin.Breakpoints[i].Active := not FDebugPlugin.Breakpoints[i].Active
  else // suppression du point d'arrêt
    FDebugPlugin.Breakpoints.Delete(i);
  if Assigned(FEngine) and FEngine.Running then
    FEngine.ResetBreakpoints;
end;

procedure TMasterEngine.WriteToConsole(const Chaine: string);
begin
  if Assigned(FConsole) then
    FConsole.Add(Chaine);
end;

initialization

finalization

if Assigned(Engines) then
  Engines.Free;

end.
