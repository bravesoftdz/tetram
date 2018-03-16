unit BDS.Scripts.MasterEngine;

interface

uses
  System.SysUtils, System.Classes, BD.Scripts, System.Generics.Collections, Dialogs,
  BDS.Scripts.Utils, BD.Entities.Full, BDS.GUI.Controls.ScriptEditor, BDS.Scripts.Engine.Intf;

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
    FDebugPlugin: IDebugInfos;
    FTypeEngine: TScriptEngine;
    FEngine: IEngineInterface;
    FInternalAlbumToImport, FAlbumToImport: TAlbumFull;
    FConsole: TStrings;
    FOnAfterExecute: TAfterExecuteEvent;
    FCompiled: Boolean;
    function GetAlbumToImport: TAlbumFull;
    procedure SetAlbumToImport(const Value: TAlbumFull);
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
    procedure ToggleBreakPoint(Script: TScript; Line: Cardinal; Keep: Boolean);
    function GetOnBreakPoint: TBreakPointEvent;
    procedure SetOnBreakPoint(const Value: TBreakPointEvent);
    procedure SelectProjectScript(ProjectScript: TScript);
    function GetProjectScript: TScript;
    procedure SetCompiled(const Value: Boolean);
    function GetCompiled: Boolean;
    function GetInternalUnitName(Script: TScript): string; overload;
    function GetInternalUnitName(const ScriptUnitName: string): string; overload;
    function GetScriptUnitName(const InternalUnitName: string): string;
    function GetScriptLines(const UnitName: string; Output: TStrings; ScriptKinds: TScriptKinds = [skUnit]): Boolean; overload;
    function GetScriptLines(Script: TScript; Lines: TStrings): Boolean; overload;
  public
    constructor Create;
    destructor Destroy; override;

    procedure WriteToConsole(const Chaine: string);

    function GetAlbumToUpdate: Boolean;
    property AlbumToImport: TAlbumFull read GetAlbumToImport write SetAlbumToImport;

    property ScriptList: TScriptList read GetScriptList;
  end;

procedure RegisterEngineScript(Engine: TScriptEngine; const EngineFactoryClass: TEngineFactoryClass);

implementation

{ %CLASSGROUP 'System.Classes.TPersistent' }

uses BD.Common, BD.Entities.Factory.Full, dwsJSON;

var
  Engines: TDictionary<TScriptEngine, TEngineFactoryClass> = nil;

procedure RegisterEngineScript(Engine: TScriptEngine; const EngineFactoryClass: TEngineFactoryClass);
begin
  if not Assigned(Engines) then
    Engines := TDictionary<TScriptEngine, TEngineFactoryClass>.Create;
  Engines.AddOrSetValue(Engine, EngineFactoryClass);
end;

{ TMasterEngine }

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
  FDebugPlugin := TDebugInfos.Create(Self);
  FInternalAlbumToImport := TFactoryAlbumFull.GetInstance;
  FAlbumToImport := FInternalAlbumToImport;
  FScriptList := TScriptList.Create;
end;

destructor TMasterEngine.Destroy;
begin
  SetTypeEngine(seNone);
  FInternalAlbumToImport.Free;
  FDebugPlugin := nil;
  FScriptList.Free;
  inherited;
end;

function TMasterEngine.GetAlbumToImport: TAlbumFull;
begin
  Result := FAlbumToImport;
end;

function TMasterEngine.GetDebugPlugin: IDebugInfos;
begin
  Result := FDebugPlugin;
end;

function TMasterEngine.GetEngine: IEngineInterface;
begin
  Result := FEngine;
end;

function TMasterEngine.GetInternalUnitName(const ScriptUnitName: string): string;
begin
  Result := ScriptUnitName;
  if (Result = '') or (Result = GetProjectScript.ScriptUnitName) then
    Result := GetEngine.GetSpecialMainUnitName;
end;

function TMasterEngine.GetInternalUnitName(Script: TScript): string;
begin
  Result := GetInternalUnitName(Script.ScriptUnitName);
end;

function TMasterEngine.GetOnAfterExecute: TAfterExecuteEvent;
begin
  Result := FOnAfterExecute;
end;

function TMasterEngine.GetOnBreakPoint: TBreakPointEvent;
begin
  Result := FOnBreakPoint;
end;

function TMasterEngine.GetScriptLines(const UnitName: string; Output: TStrings; ScriptKinds: TScriptKinds = [skUnit]): Boolean;
var
  Script: TScript;
begin
  Result := False;
  Output.Clear;
  Script := FScriptList.FindScriptByUnitName(UnitName, ScriptKinds);
  if Assigned(Script) then
    Result := GetScriptLines(Script, Output);
end;

function TMasterEngine.GetScriptLines(Script: TScript; Lines: TStrings): Boolean;
var
  Editor: TScriptEditor;
begin
  Result := False;
  Lines.Clear;
  Editor := nil;
  if Assigned(FDebugPlugin.OnGetScriptEditor) then
    Editor := FDebugPlugin.OnGetScriptEditor(Script);
  if Editor <> nil then
  begin
    with Script.ScriptInfos do
      if ((BDVersion = '') or (BDVersion <= TGlobalVar.Utilisateur.ExeVersion)) then
      begin
        Lines.Assign(Editor.Lines);
        Result := True;
      end
      else
        ShowMessage('Le script "' + Script.ScriptUnitName + '" n''est pas compatible avec cette version de BDthèque.')
  end
  else
  begin
    Script.GetScriptLines(Lines);
    Result := True;
  end;
end;

function TMasterEngine.GetScriptList: TScriptList;
begin
  Result := FScriptList;
end;

function TMasterEngine.GetScriptUnitName(const InternalUnitName: string): string;
begin
  Result := InternalUnitName;
  if InternalUnitName = GetEngine.GetSpecialMainUnitName then
    Result := FProjectScript.ScriptUnitName;
end;

function TMasterEngine.GetTypeEngine: TScriptEngine;
begin
  Result := FTypeEngine;
end;

procedure TMasterEngine.SelectProjectScript(ProjectScript: TScript);
var
  Option: TOption;
  oo, os: TdwsJSONObject;
begin
  if FProjectScript = ProjectScript then
    Exit;

  FProjectScript := ProjectScript;
  if Assigned(FProjectScript) then
  begin
    SetTypeEngine(FProjectScript.ScriptInfos.Engine);

    if FProjectScript.Options.Count > 0 then
    begin
      oo := ReadScriptsOptions;
      try
        os := oo.Items[FProjectScript.ScriptUnitName] as TdwsJSONObject;
        if os <> nil then
          for Option in FProjectScript.Options do
            Option.Read(os);
      finally
        oo.Free;
      end;
    end;
  end;
end;

procedure TMasterEngine.SetAlbumToImport(const Value: TAlbumFull);
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

procedure TMasterEngine.ToggleBreakPoint(Script: TScript; Line: Cardinal; Keep: Boolean);
var
  i: Integer;
begin
  i := FDebugPlugin.Breakpoints.IndexOf(Script, Line);
  if i = -1 then // nouveau point d'arrêt
    FDebugPlugin.Breakpoints.AddBreakpoint(Script, Line)
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
