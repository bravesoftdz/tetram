unit UdmDWScript;

interface

uses
  System.SysUtils, Winapi.Windows, Forms, System.Classes, UScriptList, Variants,
  UScriptUtils, LoadComplet, LoadCompletImport, dwsComp, dwsDebugger, dwsCompiler, dwsExprs, dwsFunctions,
  UdmScripts, UScriptEditor, SynHighlighterDWS, UDW_BdtkRegEx, UDW_BdtkObjects, dwsClassesLibModule, UDW_CommonFunctions,
  dwsErrors;

type
  TDWScriptEngineFactory = class(TEngineFactory)
  private
    FMasterEngine: IMasterEngine;
  public
    constructor Create(MasterEngine: IMasterEngine); override;
    function GetInstance: IEngineInterface; override;
  end;

  TdmDWScript = class(TInterfacedObject, IEngineInterface)
  private
    FScript: string;
    FProgram: IdwsProgram;
    FMasterEngine: IMasterEngine;
    DWScript: TDelphiWebScript;
    DWDebugger: TdwsDebugger;
    dwsUnit: TdwsUnit;
    bdRegEx: TDW_BdtkRegExUnit;
    bdObjects: TDW_BdtkObjectsUnit;
    dwsClassesLib: TdwsClassesLib;
    bdCommonFunctions: TDW_CommonFunctionsUnit;
    SynDWSSyn: TSynDWSSyn;
    FActiveLine, FRunToCursor, FErrorLine: Cardinal;
    FActiveFile, FRunToCursorFile, FErrorFile: string;
    FRunningScript: TScript;
    FListTypesImages: TStringList;
    FUseDebugInfo: Boolean;

    procedure OnIncludeEvent(const scriptName: UnicodeString; var scriptSource: UnicodeString);
    function dwsOnNeedUnitEvent(const unitName: UnicodeString; var unitSource: UnicodeString): IdwsUnit;
    procedure dwsUnitFunctionsGetOptionValueEval(info: TProgramInfo);
    procedure dwsUnitFunctionsCheckOptionValueEval(info: TProgramInfo);
    procedure dwsUnitFunctionsGetOptionValueIndexEval(info: TProgramInfo);
    procedure AfterInitbdObjects(Sender: TObject);
    procedure DebuggerStateChanged(Sender: TObject);

    function FillMessages(Msgs: TdwsMessageList): TMessageInfo;
    function CorrectScriptName(const Script: String): String;
  public
    constructor Create(MasterEngine: IMasterEngine);
    destructor Destroy; override;

    procedure AssignScript(Script: TStrings);

    procedure ResetBreakpoints;
    procedure ResetWatches;

    function Compile(ABuild: Boolean; out Msg: TMessageInfo): Boolean; overload;
    function Compile(Script: TScript; out Msg: TMessageInfo): Boolean; overload;
    function Run: Boolean;

    function GetRunning: Boolean;
    function GetMainSpecialName: string;

    function GetDebugMode: TDebugMode;

    function GetActiveLine: Cardinal;
    procedure SetActiveLine(const Value: Cardinal);

    function GetActiveFile: string;
    procedure SetActiveFile(const Value: string);

    function GetErrorLine: Cardinal;
    procedure SetErrorLine(const Value: Cardinal);

    function GetErrorFile: string;
    procedure SetErrorFile(const Value: string);

    function GetUseDebugInfo: Boolean;
    procedure SetUseDebugInfo(Value: Boolean);

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

implementation

uses UDWScriptEditor, Procedures, dwsSymbols;

{ TDWScriptEngineFactory }

constructor TDWScriptEngineFactory.Create(MasterEngine: IMasterEngine);
begin
  inherited;
  FMasterEngine := MasterEngine;
end;

function TDWScriptEngineFactory.GetInstance: IEngineInterface;
begin
  Result := TdmDWScript.Create(FMasterEngine);
end;

{ TdmDWScript }

procedure TdmDWScript.AfterInitbdObjects(Sender: TObject);
begin
  bdObjects.ExposeInstanceToUnit('AlbumToImport', 'TAlbumComplet', FMasterEngine.AlbumToImport);
end;

procedure TdmDWScript.AssignScript(Script: TStrings);
begin
  FProgram := nil;
  FScript := Script.Text;
end;

procedure TdmDWScript.OnIncludeEvent(const scriptName: UnicodeString; var scriptSource: UnicodeString);
var
  SL: TStrings;
begin
  SL := TStringList.Create;
  try
    if not FMasterEngine.ScriptList.GetScriptLines(scriptName, SL) then
      raise Exception.CreateFmt('Script file name not found "%s"', [scriptName]);

    scriptSource := SL.Text;
  finally
    SL.Free;
  end;
end;

function TdmDWScript.dwsOnNeedUnitEvent(const unitName: UnicodeString; var unitSource: UnicodeString): IdwsUnit;
var
  SL: TStrings;
begin
  SL := TStringList.Create;
  try
    if not FMasterEngine.ScriptList.GetScriptLines(unitName, SL) then
      raise Exception.CreateFmt('Unit file name not found "%s"', [unitName]);

    unitSource := SL.Text;
  finally
    SL.Free;
  end;
end;

procedure TdmDWScript.dwsUnitFunctionsGetOptionValueEval(info: TProgramInfo);
begin
  info.ResultAsString := FRunningScript.OptionValue(info.ValueAsString['OptionName'], info.ValueAsString['Default']);
end;

procedure TdmDWScript.dwsUnitFunctionsGetOptionValueIndexEval(info: TProgramInfo);
begin
  info.ResultAsInteger := FRunningScript.OptionValueIndex(info.ValueAsString['OptionName'], info.ValueAsInteger['Default']);
end;

function TdmDWScript.FillMessages(Msgs: TdwsMessageList): TMessageInfo;
var
  i: Integer;
  m: TdwsMessage;
  Filename: string;
begin
  Result := nil;
  if Msgs.Count > 0 then
  begin
    for i := 0 to Pred(Msgs.Count) do
    begin
      m := Msgs[i];
      if m is TScriptMessage then
        with TScriptMessage(m) do
        begin
          if ScriptPos.SourceFile = nil then
            Filename := ''
          else
            Filename := ScriptPos.SourceFile.Name;
          if m is TWarningMessage then
            FMasterEngine.DebugPlugin.Messages.AddCompileErrorMessage(Filename, Text, tmWarning, ScriptPos.Line, ScriptPos.Col)
          else if m is THintMessage then
            FMasterEngine.DebugPlugin.Messages.AddCompileErrorMessage(Filename, Text, tmHint, ScriptPos.Line, ScriptPos.Col)
          else if m is TRuntimeErrorMessage then
            FMasterEngine.DebugPlugin.Messages.AddRuntimeErrorMessage(Filename, Text, ScriptPos.Line, ScriptPos.Col)
          else if (m is TCompilerErrorMessage) or (m is TSyntaxErrorMessage) then
            Result := FMasterEngine.DebugPlugin.Messages[FMasterEngine.DebugPlugin.Messages.AddCompileErrorMessage(Filename, Text, tmError, ScriptPos.Line,
              ScriptPos.Col)]
          else
            FMasterEngine.DebugPlugin.Messages.AddCompileErrorMessage(Filename, Text, tmUnknown, ScriptPos.Line, ScriptPos.Col);
        end
      else
        FMasterEngine.DebugPlugin.Messages.AddInfoMessage('', m.AsInfo, 0, 0);
    end;
  end;
end;

procedure TdmDWScript.dwsUnitFunctionsCheckOptionValueEval(info: TProgramInfo);
begin
  info.ResultAsBoolean := FRunningScript.CheckOptionValue(info.ValueAsString['OptionName'], info.ValueAsString['Default']);
end;

function TdmDWScript.Compile(Script: TScript; out Msg: TMessageInfo): Boolean;
var
  SL: TStringList;
begin
  FRunningScript := Script;
  SL := TStringList.Create;
  try
    Script.GetScriptLines(SL);
    FScript := SL.Text;
  finally
    SL.Free;
  end;
  Result := Compile(True, Msg);
end;

function TdmDWScript.Compile(ABuild: Boolean; out Msg: TMessageInfo): Boolean;
begin
  if ABuild or not Assigned(FProgram) then
  begin
    // si la comile plante, on est au moins sûr d'avoir remis à nil
    FProgram := nil;
    FProgram := DWScript.Compile(FScript);
    FMasterEngine.DebugPlugin.Messages.Clear;
    Msg := FillMessages(FProgram.Msgs);
  end;
  Result := (FProgram <> nil) and not FProgram.Msgs.HasErrors;
end;

constructor TdmDWScript.Create(MasterEngine: IMasterEngine);
begin
  FMasterEngine := MasterEngine;

  FListTypesImages := TStringList.Create;
  LoadStrings(6, FListTypesImages);

  FUseDebugInfo := True;
  SynDWSSyn := TSynDWSSyn.Create(nil);
  dwsClassesLib := TdwsClassesLib.Create(nil);
  bdRegEx := TDW_BdtkRegExUnit.Create(FMasterEngine);
  bdObjects := TDW_BdtkObjectsUnit.Create(FMasterEngine);
  bdObjects.OnAfterInitUnitTable := AfterInitbdObjects;
  bdCommonFunctions := TDW_CommonFunctionsUnit.Create(FMasterEngine);
  dwsUnit := TdwsUnit.Create(nil);
  dwsUnit.unitName := 'Options';
  with dwsUnit.Functions.Add do
  begin
    Name := 'GetOptionValue';
    ResultType := 'String';
    with Parameters.Add do
    begin
      Name := 'OptionName';
      DataType := 'String';
    end;
    with Parameters.Add do
    begin
      Name := 'Default';
      DataType := 'String';
    end;
    OnEval := dwsUnitFunctionsGetOptionValueEval;
  end;

  with dwsUnit.Functions.Add do
  begin
    Name := 'GetOptionValueIndex';
    ResultType := 'Integer';
    with Parameters.Add do
    begin
      Name := 'OptionName';
      DataType := 'String';
    end;
    with Parameters.Add do
    begin
      Name := 'Default';
      DataType := 'Integer';
    end;
    OnEval := dwsUnitFunctionsGetOptionValueIndexEval;
  end;

  with dwsUnit.Functions.Add do
  begin
    Name := 'CheckOptionValue';
    ResultType := 'Boolean';
    with Parameters.Add do
    begin
      Name := 'OptionName';
      DataType := 'String';
    end;
    with Parameters.Add do
    begin
      Name := 'Default';
      DataType := 'String';
    end;
    OnEval := dwsUnitFunctionsCheckOptionValueEval;
  end;

  DWDebugger := TdwsDebugger.Create(nil);
  DWDebugger.OnStateChanged := DebuggerStateChanged;

  DWScript := TDelphiWebScript.Create(nil);
  DWScript.AddUnit(dwsClassesLib.dwsUnit);
  DWScript.AddUnit(dwsUnit);
  DWScript.AddUnit(bdRegEx);
  DWScript.AddUnit(bdObjects);
  DWScript.AddUnit(bdCommonFunctions);
  DWScript.Config.CompilerOptions := DWScript.Config.CompilerOptions + [coSymbolDictionary];
  DWScript.Config.OnNeedUnit := Self.dwsOnNeedUnitEvent;
  DWScript.Config.OnInclude := Self.OnIncludeEvent;
end;

procedure TdmDWScript.DebuggerStateChanged(Sender: TObject);
begin
  case DWDebugger.State of
    dsIdle:
      ;
    dsDebugRun:
      ;
    dsDebugSuspending:
      ;
    dsDebugSuspended:
      begin
        SetActiveFile(TdwsDebugger(Sender).CurrentScriptPos.SourceFile.Name);
        SetActiveLine(TdwsDebugger(Sender).CurrentScriptPos.Line);
        FMasterEngine.OnBreakPoint;
      end;
    dsDebugResuming:
      ;
    dsDebugDone:
      TdwsDebugger(Sender).Breakpoints.Clean;
  end;
end;

destructor TdmDWScript.Destroy;
begin
  FProgram := nil;
  FMasterEngine := nil;
  SynDWSSyn.Free;
  DWScript.Free;
  DWDebugger.Watches.Clean;
  DWDebugger.Breakpoints.Clean;
  DWDebugger.Free;
  bdCommonFunctions.Free;
  bdRegEx.Free;
  bdObjects.Free;
  dwsUnit.Free;
  dwsClassesLib.Free;
  FListTypesImages.Free;
  inherited;
end;

function TdmDWScript.GetActiveFile: string;
begin
  Result := FActiveFile;
end;

function TdmDWScript.GetActiveLine: Cardinal;
begin
  Result := FActiveLine;
end;

function TdmDWScript.GetDebugMode: TDebugMode;
begin
  if DWDebugger.State = dsDebugSuspended then
    Result := dmPaused
  else
    Result := dmRun;
end;

function TdmDWScript.GetErrorFile: string;
begin
  Result := FErrorFile;
end;

function TdmDWScript.GetErrorLine: Cardinal;
begin
  Result := FErrorLine;
end;

function TdmDWScript.GetNewEditor(AOwner: TComponent): TScriptEditor;
begin
  Result := TDWScriptEditor.Create(AOwner);
  Result.Highlighter := SynDWSSyn;
end;

function TdmDWScript.GetExecutableLines(const AUnitName: string): TLineNumbers;

  procedure AppendLineNum(ALineNum: Integer);
  begin
    SetLength(Result, Length(Result) + 1);
    Result[Length(Result) - 1] := ALineNum;
  end;

var
  i: Integer;
  Breakpointables: TdwsBreakpointableLines;
  Msg: TMessageInfo;
  Lines: Tbits;
begin
  SetLength(Result, 0);

  Compile(False, Msg);
  if not Assigned(FProgram) then
    Exit;

  Breakpointables := TdwsBreakpointableLines.Create(FProgram);
  try
    Lines := Breakpointables.SourceLines[AUnitName];
    if Lines <> nil then
    begin
      for i := 1 to Lines.Size - 1 do
        if Lines[i] then
          AppendLineNum(i);
    end;
  finally
    Breakpointables.Free;
  end;
end;

function TdmDWScript.GetMainSpecialName: string;
begin
  Result := '*MainModule*';
end;

function TdmDWScript.GetRunning: Boolean;
begin
  Result := not(DWDebugger.State in [dsDebugDone, dsIdle]);
end;

procedure TdmDWScript.GetUncompiledCode(Lines: TStrings);
begin

end;

function TdmDWScript.GetUseDebugInfo: Boolean;
begin
  Result := FUseDebugInfo;
end;

function TdmDWScript.GetVariableValue(const VarName: string): string;
begin
  Result := DWDebugger.EvaluateAsString(VarName);
end;

function TdmDWScript.GetWatchValue(const VarName: string): string;
var
  dwsW: TdwsDebuggerWatch;
  i: Integer;
  v: variant;
begin
  dwsW := TdwsDebuggerWatch.Create;
  try
    dwsW.ExpressionText := VarName;
    i := DWDebugger.Watches.IndexOf(dwsW);
  finally
    dwsW.Free;
  end;
  Result := '{Expression inconnue}';
  if i > -1 then
  begin
    dwsW := DWDebugger.Watches[i];
    if dwsW.ValueInfo = nil then
      Result := '{Valeur inaccessible}'
    else
    begin
      v := dwsW.ValueInfo.Value;
      Result := VarToStr(v);
      if VarIsStr(v) then
        Result := '''' + Result + '''';
    end;
    dwsW.ClearEvaluator;
  end;
end;

procedure TdmDWScript.Pause;
begin
  DWDebugger.Suspend;
end;

procedure TdmDWScript.Resume;
begin
  DWDebugger.Resume;
end;

function TdmDWScript.Run: Boolean;
var
  exec: IdwsProgramExecution;
begin
  ResetWatches;
  ResetBreakpoints;
  if not FUseDebugInfo then
    exec := FProgram.Execute
  else
  begin
    exec := FProgram.CreateNewExecution;
    try
      DWDebugger.BeginDebug(exec);
    finally
      DWDebugger.EndDebug;
    end;
  end;
  FillMessages(exec.Msgs);
  Result := not exec.Msgs.HasErrors;
  if not Result then
  begin
    FErrorLine := exec.Msgs.LastMessagePos.Line;
    FErrorFile := CorrectScriptName(exec.Msgs.LastMessagePos.SourceFile.Name);
  end;
end;

procedure TdmDWScript.SetActiveFile(const Value: string);
begin
  FActiveFile := CorrectScriptName(Value);
end;

procedure TdmDWScript.SetActiveLine(const Value: Cardinal);
begin
  FActiveLine := Value;
end;

procedure TdmDWScript.SetErrorFile(const Value: string);
begin
  FErrorFile := CorrectScriptName(Value);
end;

procedure TdmDWScript.SetErrorLine(const Value: Cardinal);
begin
  FErrorLine := Value;
end;

procedure TdmDWScript.setRunTo(Position: Integer; const Filename: string);
begin
  FRunToCursor := Position;
  FRunToCursorFile := CorrectScriptName(Filename);
end;

procedure TdmDWScript.SetUseDebugInfo(Value: Boolean);
begin
  FUseDebugInfo := Value;
end;

procedure TdmDWScript.StepInto;
begin
  DWDebugger.StepDetailed;
end;

procedure TdmDWScript.StepOver;
begin
  DWDebugger.StepOver;
end;

procedure TdmDWScript.Stop;
begin
  DWDebugger.EndDebug;
end;

function TdmDWScript.CorrectScriptName(const Script: String): String;
begin
  if Script = '' then
    Result := GetMainSpecialName
  else
    Result := Script;
end;

procedure TdmDWScript.ResetBreakpoints;
var
  bp: TBreakpointInfo;
  dwsBP: TdwsDebuggerBreakpoint;
  i: Integer;
  added: Boolean;
begin
  DWDebugger.Breakpoints.Clean;
  if FUseDebugInfo then
    for bp in FMasterEngine.DebugPlugin.Breakpoints do
    begin
      dwsBP := TdwsDebuggerBreakpoint.Create;
      dwsBP.Line := bp.Line;
      dwsBP.SourceName := CorrectScriptName(bp.Fichier);
      i := DWDebugger.Breakpoints.AddOrFind(dwsBP, added);
      if not added then
        dwsBP.Free
      else
      begin
        dwsBP := DWDebugger.Breakpoints[i];
        dwsBP.Enabled := bp.Active;
      end;
    end;
  DWDebugger.Breakpoints.BreakPointsChanged;
end;

procedure TdmDWScript.ResetWatches;
var
  wi: TWatchInfo;
  dwsW: TdwsDebuggerWatch;
  i: Integer;
  added: Boolean;
begin
  DWDebugger.Watches.Clean;
  if FUseDebugInfo then
    for wi in FMasterEngine.DebugPlugin.Watches do
    begin
      dwsW := TdwsDebuggerWatch.Create;
      dwsW.ExpressionText := wi.Name;
      i := DWDebugger.Watches.AddOrFind(dwsW, added);
      if not added then
        dwsW.Free
      else
      begin
        // dwsW := DWDebugger.Watches[i];
        // dwsW.Enabled := wi.Active;
      end;
    end;
end;

function TdmDWScript.TranslatePosition(out Proc, Position: Cardinal; Row: Cardinal; const Fn: string): Boolean;
begin
  Result := False;
end;

initialization

RegisterEngineScript(seDWScript, TDWScriptEngineFactory);

end.
