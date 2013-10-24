unit UMasterEngine;

interface

uses
  System.SysUtils, System.Classes, UScriptList, System.Generics.Collections,
  UScriptUtils, LoadComplet, UScriptEditor;

type
  TDebugMode = (dmRun, dmStepOver, dmStepInto, dmPaused);
  TLineNumbers = array of Integer;

  IEngineInterface = interface
    ['{640DAE0F-93CC-40A1-922C-E884D5F0F19C}']
    procedure AssignScript(Script: TStrings);

    procedure ResetBreakpoints;

    function Compile(Script: TScript; out Msg: TMessageInfo): Boolean;
    function Run: Boolean;

    function GetRunning: Boolean;
    property Running: Boolean read GetRunning;

    function GetSpecialMainUnitName: string;

    function GetDebugMode: TDebugMode;
    property DebugMode: TDebugMode read GetDebugMode;

    function GetActiveLine: Cardinal;
    procedure SetActiveLine(const Value: Cardinal);
    property ActiveLine: Cardinal read GetActiveLine write SetActiveLine;

    function GetActiveFile: string;
    procedure SetActiveFile(const Value: string);
    property ActiveFile: string read GetActiveFile write SetActiveFile;

    function GetErrorLine: Cardinal;
    procedure SetErrorLine(const Value: Cardinal);
    property ErrorLine: Cardinal read GetErrorLine write SetErrorLine;

    function GetErrorFile: string;
    procedure SetErrorFile(const Value: string);
    property ErrorFile: string read GetErrorFile write SetErrorFile;

    function GetUseDebugInfo: Boolean;
    procedure SetUseDebugInfo(Value: Boolean);
    property UseDebugInfo: Boolean read GetUseDebugInfo write SetUseDebugInfo;

    function GetExecutableLines(const AUnitName: string): TLineNumbers;
    function TranslatePosition(out Proc, Position: Cardinal; Row: Cardinal; const Fn: string): Boolean;
    function GetVariableValue(const VarName: string): string;
    function GetWatchValue(const VarName: string): string;

    procedure Pause;
    procedure StepInto;
    procedure StepOver;
    procedure Resume;
    procedure Stop;

    procedure GetUncompiledCode(Lines: TStrings);
    procedure setRunTo(Position: Integer; const Filename: string);

    function GetNewEditor(AOwner: TComponent): TScriptEditor;
  end;

  TAfterExecuteEvent = procedure of object;
  TBreakPointEvent = procedure of object;

  IMasterEngine = interface
    ['{C093B526-5485-4059-8516-5CBF1A3808AE}']
    function GetTypeEngine: TScriptEngine;
    procedure SetTypeEngine(const Value: TScriptEngine);
    property TypeEngine: TScriptEngine read GetTypeEngine write SetTypeEngine;

    function GetEngine: IEngineInterface;
    property Engine: IEngineInterface read GetEngine;

    function GetAlbumToUpdate: Boolean;
    property AlbumToUpdate: Boolean read GetAlbumToUpdate;

    function GetAlbumToImport: TAlbumComplet;
    procedure SetAlbumToImport(const Value: TAlbumComplet);
    property AlbumToImport: TAlbumComplet read GetAlbumToImport write SetAlbumToImport;

    function GetDebugPlugin: TDebugInfos;
    property DebugPlugin: TDebugInfos read GetDebugPlugin;

    function GetScriptList: TScriptList;
    property ScriptList: TScriptList read GetScriptList;

    procedure SelectProjectScript(ProjectScript: TScript);
    function GetProjectScript: TScript;
    property ProjectScript: TScript read GetProjectScript;

    function GetConsole: TStrings;
    procedure SetConsole(const Value: TStrings);
    property Console: TStrings read GetConsole write SetConsole;

    function GetOnAfterExecute: TAfterExecuteEvent;
    procedure SetOnAfterExecute(const Value: TAfterExecuteEvent);
    property OnAfterExecute: TAfterExecuteEvent read GetOnAfterExecute write SetOnAfterExecute;
    procedure AfterExecute;

    procedure ToggleBreakPoint(const Script: string; Line: Cardinal; Keep: Boolean);

    function GetOnBreakPoint: TBreakPointEvent;
    procedure SetOnBreakPoint(const Value: TBreakPointEvent);
    property OnBreakPoint: TBreakPointEvent read GetOnBreakPoint write SetOnBreakPoint;

    procedure WriteToConsole(const Chaine: string);
  end;

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
    function GetAlbumToImport: TAlbumComplet;
    procedure SetAlbumToImport(const Value: TAlbumComplet);
    function GetDebugPlugin: TDebugInfos;
    function GetScriptList: TScriptList;
    function GetEngine: IEngineInterface;
    function GetTypeEngine: TScriptEngine;
    procedure SetTypeEngine(const Value: TScriptEngine);
    function GetConsole: TStrings;
    procedure SetConsole(const Value: TStrings);
    function GetOnAfterExecute: TAfterExecuteEvent;
    procedure SetOnAfterExecute(const Value: TAfterExecuteEvent);
    procedure AfterExecute;
    procedure ToggleBreakPoint(const Script: string; Line: Cardinal; Keep: Boolean);
    function GetOnBreakPoint: TBreakPointEvent;
    procedure SetOnBreakPoint(const Value: TBreakPointEvent);
    procedure SelectProjectScript(ProjectScript: TScript);
    function GetProjectScript: TScript;
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

function TMasterEngine.GetDebugPlugin: TDebugInfos;
begin
  Result := FDebugPlugin;
end;

function TMasterEngine.GetEngine: IEngineInterface;
begin
  Result := FEngine;
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

procedure TMasterEngine.ToggleBreakPoint(const Script: string; Line: Cardinal; Keep: Boolean);
var
  i: Integer;
begin
  i := FDebugPlugin.Breakpoints.IndexOf(Script, Line);
  if i = -1 then // nouveau point d'arrêt
    FDebugPlugin.Breakpoints.AddBreakpoint(Script, Line)
  else if Keep then // changement d'état du point d'arrêt
    FDebugPlugin.Breakpoints[i].Active := not FDebugPlugin.Breakpoints[i].Active
  else // suppression du point d'arrêt
    FDebugPlugin.Breakpoints.delete(i);
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
