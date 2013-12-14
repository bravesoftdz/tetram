unit UdmDWScript;

interface

uses
  System.SysUtils, Winapi.Windows, Forms, System.Classes, UScriptList, Variants,
  UScriptUtils, EntitiesFull, LoadCompletImport, dwsComp, dwsDebugger, dwsCompiler, dwsExprs, dwsFunctions,
  UMasterEngine, UScriptEngineIntf, UScriptEditor, SynHighlighterDWS, UDW_BdtkRegEx, UDW_BdtkObjects, dwsClassesLibModule, UDW_CommonFunctions,
  dwsErrors, UDWUnit, Vcl.Graphics, dwsJSONConnector;

type
  TDWScriptEngineFactory = class(TEngineFactory)
  private
    FMasterEngine: IMasterEngine;
  public
    constructor Create(MasterEngine: IMasterEngine); override;
    destructor Destroy; override;
    function GetInstance: IEngineInterface; override;
  end;

  TdmDWScript = class(TInterfacedObject, IEngineInterface)
  private
    FScript: string;
    FProgram: IdwsProgram;
    FMasterEngine: IMasterEngine;
    DWScript: TDelphiWebScript;
    DWDebugger: TdwsDebugger;
    dwsUnit: TDW_Unit;
    bdRegEx: TDW_BdtkRegExUnit;
    bdObjects: TDW_BdtkObjectsUnit;
    dwsClassesLib: TdwsClassesLib;
    dwsJSONLib: TdwsJSONLibModule;
    bdCommonFunctions: TDW_CommonFunctionsUnit;
    SynDWSSyn: TSynDWSSyn;
    FActiveLine, FRunToCursorLine, FErrorLine: Cardinal;
    FActiveUnitName, FRunToCursorUnitName, FErrorUnitName: string;
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

    function FillMessages(Msgs: TdwsMessageList): IMessageInfo;
  public
    constructor Create(MasterEngine: IMasterEngine);
    destructor Destroy; override;

    procedure AssignScript(Script: TStrings);

    procedure ResetBreakpoints;
    procedure ResetWatches;

    function Compile(ABuild: Boolean; out Msg: IMessageInfo): Boolean; overload;
    function Compile(Script: TScript; out Msg: IMessageInfo): Boolean; overload;
    function Run: Boolean;

    function GetRunning: Boolean;
    function GetSpecialMainUnitName: string;

    function GetDebugMode: TDebugMode;

    function GetActiveLine: Cardinal;
    procedure SetActiveLine(const Value: Cardinal);
    property ActiveLine: Cardinal read GetActiveLine write SetActiveLine;

    function GetActiveUnitName: string;
    procedure SetActiveUnitName(const Value: string);
    property ActiveUnitName: string read GetActiveUnitName write SetActiveUnitName;

    function GetErrorLine: Cardinal;
    procedure SetErrorLine(const Value: Cardinal);
    property ErrorLine: Cardinal read GetErrorLine write SetErrorLine;

    function GetErrorUnitName: string;
    procedure SetErrorUnitName(const Value: string);
    property ErrorUnitName: string read GetErrorUnitName write SetErrorUnitName;

    function GetUseDebugInfo: Boolean;
    procedure SetUseDebugInfo(Value: Boolean);

    function GetExecutableLines(const AUnitName: string): TLineNumbers;
    function TranslatePosition(out Proc, Position: Cardinal; Row: Cardinal; const Fn: string): Boolean;
    function GetVariableValue(const VarName: string): string;
    function GetWatchValue(const VarName: string): string;
    function GetCompletionProposal(Proposal, Code: TStrings; CurrentEditor: TScriptEditor): Boolean;
    function GetParametersProposal(Proposal, Code: TStrings; CurrentEditor: TScriptEditor; out BestProposal: Integer): Boolean;

    procedure Pause;
    procedure StepInto;
    procedure StepOver;
    procedure Resume;
    procedure Stop;

    procedure GetUncompiledCode(Lines: TStrings);
    procedure SetRunTo(Position: Integer; const Filename: string);

    function GetNewEditor(AOwner: TComponent): TScriptEditor;
    function isTokenIdentifier(TokenType: Integer): Boolean;
  end;

implementation

uses UDWScriptEditor, Procedures, dwsSymbols, dwsSuggestions, dwsUtils;

{ TDWScriptEngineFactory }

constructor TDWScriptEngineFactory.Create(MasterEngine: IMasterEngine);
begin
  inherited;
  FMasterEngine := MasterEngine;
end;

destructor TDWScriptEngineFactory.Destroy;
begin
  FMasterEngine := nil;
  inherited;
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
    if not FMasterEngine.GetScriptLines(scriptName, SL) then
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
    if not FMasterEngine.GetScriptLines(unitName, SL) then
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

function TdmDWScript.FillMessages(Msgs: TdwsMessageList): IMessageInfo;
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

function TdmDWScript.Compile(Script: TScript; out Msg: IMessageInfo): Boolean;
var
  SL: TStringList;
begin
  FRunningScript := Script;
  SL := TStringList.Create;
  try
    FMasterEngine.GetScriptLines(Script, SL);
    FScript := SL.Text;
  finally
    SL.Free;
  end;
  Result := Compile(True, Msg);
end;

function TdmDWScript.Compile(ABuild: Boolean; out Msg: IMessageInfo): Boolean;
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
  dwsJSONLib := TdwsJSONLibModule.Create(nil);
  dwsUnit := TDW_Unit.Create(FMasterEngine);
  dwsUnit.unitName := 'Options';
  dwsUnit.RegisterFunction('GetOptionValue', 'String', ['OptionName', 'String', 'Default', 'String'], dwsUnitFunctionsGetOptionValueEval);
  dwsUnit.RegisterFunction('GetOptionValueIndex', 'Integer', ['OptionName', 'String', 'Default', 'Integer'], dwsUnitFunctionsGetOptionValueIndexEval);
  dwsUnit.RegisterFunction('CheckOptionValue', 'Boolean', ['OptionName', 'String', 'Default', 'String'], dwsUnitFunctionsCheckOptionValueEval);

  DWDebugger := TdwsDebugger.Create(nil);
  DWDebugger.OnStateChanged := DebuggerStateChanged;

  DWScript := TDelphiWebScript.Create(nil);
  DWScript.AddUnit(dwsClassesLib.dwsUnit);
  DWScript.AddUnit(dwsUnit);
  DWScript.AddUnit(bdRegEx);
  DWScript.AddUnit(bdObjects);
  DWScript.AddUnit(bdCommonFunctions);
  dwsJSONLib.Script := DWScript;
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
        ActiveUnitName := TdwsDebugger(Sender).CurrentScriptPos.SourceFile.Name;
        ActiveLine := TdwsDebugger(Sender).CurrentScriptPos.Line;
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
  DWDebugger.Watches.Clean;
  DWDebugger.Breakpoints.Clean;
  DWDebugger.Free;
  DWScript.Free;
  dwsJSONLib.Free;
  bdCommonFunctions.Free;
  bdRegEx.Free;
  bdObjects.Free;
  dwsUnit.Free;
  dwsClassesLib.Free;
  FListTypesImages.Free;
  inherited;
end;

function TdmDWScript.GetActiveUnitName: string;
begin
  Result := FActiveUnitName;
end;

function TdmDWScript.GetCompletionProposal(Proposal, Code: TStrings; CurrentEditor: TScriptEditor): Boolean;
var
  Msg: IMessageInfo;
  SourceFile: TSourceFile;
  ScriptPos: TScriptPos;
  Suggestions: IdwsSuggestions;
  SuggestionIndex: Integer;
  Item, AddOn: string;
begin
  Result := False;

  // get script program
  if not Compile(FMasterEngine.ProjectScript, Msg) then
    Exit;

  // ok, get the compiled "program" from DWS
  SourceFile := FProgram.SourceList.MainScript.SourceFile;
  ScriptPos := TScriptPos.Create(SourceFile, CurrentEditor.CaretY, CurrentEditor.CaretX);
  Suggestions := TDWSSuggestions.Create(FProgram, ScriptPos, [soNoReservedWords]);

  // now populate the suggestion box
  for SuggestionIndex := 0 to Suggestions.Count - 1 do
  begin
    // discard empty suggestions
    if Suggestions.Caption[SuggestionIndex] = '' then
      Continue;

    with CurrentEditor.Highlighter.KeywordAttribute do
      Item := '\color{' + ColorToString(Foreground) + '}';

    case Suggestions.Category[SuggestionIndex] of
      scUnit:
        Item := Item + 'unit';
      scType:
        Item := Item + 'type';
      scClass:
        Item := Item + 'class';
      scRecord:
        Item := Item + 'record';
      scInterface:
        Item := Item + 'interface';
      scFunction:
        Item := Item + 'function';
      scProcedure:
        Item := Item + 'procedure';
      scMethod:
        Item := Item + 'method';
      scConstructor:
        Item := Item + 'constructor';
      scDestructor:
        Item := Item + 'destructor';
      scProperty:
        Item := Item + 'property';
      scEnum:
        Item := Item + 'enum';
      scElement:
        Item := Item + 'element';
      scParameter:
        Item := Item + 'param';
      scVariable:
        Item := Item + 'var';
      scConst:
        Item := Item + 'const';
      scReservedWord:
        Item := Item + 'reserved';
    end;

    Item := Item + ' \column{}';
    with CurrentEditor.Highlighter.IdentifierAttribute do
      Item := Item + '\color{' + ColorToString(Foreground) + '}';
    Item := Item + Suggestions.Code[SuggestionIndex];
    AddOn := Suggestions.Caption[SuggestionIndex];
    Delete(AddOn, 1, Length(Suggestions.Code[SuggestionIndex]));
    Item := Item + '\style{-B}' + AddOn;
    Proposal.Add(Item);
    Code.Add(Suggestions.Code[SuggestionIndex]);
  end;

  Result := True;
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

function TdmDWScript.GetErrorUnitName: string;
begin
  Result := FErrorUnitName;
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

function TdmDWScript.GetParametersProposal(Proposal, Code: TStrings; CurrentEditor: TScriptEditor; out BestProposal: Integer): Boolean;

  procedure GetParameterInfosForCursor(const AProgram: IdwsProgram; Col, Line: Integer; var ParameterInfos: TStrings; InfoPosition: Integer = 0);

    procedure ParamsToInfo(const AParams: TParamsSymbolTable);
    var
      Y: Integer;
      ParamsStr: string;
    begin
      ParamsStr := '';
      if (AParams <> nil) and (AParams.Count > 0) then
      begin
        if InfoPosition >= AParams.Count then
          Exit;

        ParamsStr := '"' + AParams[0].Description + ';"';
        for Y := 1 to AParams.Count - 1 do
          ParamsStr := ParamsStr + ',"' + AParams[Y].Description + ';"';
      end
      else if InfoPosition > 0 then
        Exit;

      if (ParameterInfos.IndexOf(ParamsStr) < 0) then
        ParameterInfos.Add(ParamsStr);
    end;

  var
    Overloads: TFuncSymbolList;

    procedure CollectMethodOverloads(methSym: TMethodSymbol);
    var
      Member: TSymbol;
      Struct: TCompositeTypeSymbol;
      LastOverloaded: TMethodSymbol;
    begin
      LastOverloaded := methSym;
      Struct := methSym.StructSymbol;
      repeat
        for Member in Struct.Members do
        begin
          if not UnicodeSameText(Member.Name, methSym.Name) then
            Continue;
          if not(Member is TMethodSymbol) then
            Continue;

          LastOverloaded := TMethodSymbol(Member);
          if not Overloads.ContainsChildMethodOf(LastOverloaded) then
            Overloads.Add(LastOverloaded);
        end;

        Struct := Struct.Parent;
      until (Struct = nil) or not LastOverloaded.IsOverloaded;
    end;

  var
    ItemIndex: Integer;
    FuncSymbol: TFuncSymbol;

    SymbolDictionary: TdwsSymbolDictionary;
    Symbol, TestSymbol: TSymbol;
  begin
    SymbolDictionary := AProgram.SymbolDictionary;
    Symbol := SymbolDictionary.FindSymbolAtPosition(Col, Line, GetSpecialMainUnitName);

    if (Symbol is TSourceMethodSymbol) then
    begin
      Overloads := TFuncSymbolList.Create;
      try
        CollectMethodOverloads(TSourceMethodSymbol(Symbol));
        for ItemIndex := 0 to Overloads.Count - 1 do
        begin
          FuncSymbol := Overloads[ItemIndex];
          ParamsToInfo(FuncSymbol.Params);
        end;
      finally
        Overloads.Free;
      end;
    end
    else if (Symbol is TFuncSymbol) then
    begin
      ParamsToInfo(TFuncSymbol(Symbol).Params);

      if TFuncSymbol(Symbol).IsOverloaded then
      begin
        for ItemIndex := 0 to SymbolDictionary.Count - 1 do
        begin
          TestSymbol := SymbolDictionary.Items[ItemIndex].Symbol;

          if (TestSymbol.ClassType = Symbol.ClassType) and SameText(TFuncSymbol(TestSymbol).Name, TFuncSymbol(Symbol).Name) and (TestSymbol <> Symbol) then
            ParamsToInfo(TFuncSymbol(TestSymbol).Params);
        end;
      end
    end;

    // check if no parameters at all is an option, if so: replace and move to top
    ItemIndex := ParameterInfos.IndexOf('');
    if ItemIndex >= 0 then
    begin
      ParameterInfos.Delete(ItemIndex);
      ParameterInfos.Insert(0, '"<pas de paramètres requis>"');
    end;
  end;

var
  LineText: string;
  LocLine: string;
  TmpX: Integer;
  StartX, ParenCounter: Integer;
  Msg: IMessageInfo;
begin
  Result := False;

  // get script program
  if not Compile(FMasterEngine.ProjectScript, Msg) then
    Exit;

  // get current line
  LineText := CurrentEditor.LineText;

  with CurrentEditor do
  begin
    LocLine := LineText;

    // go back from the cursor and find the first open paren
    TmpX := CaretX;
    if TmpX > Length(LocLine) then
      TmpX := Length(LocLine)
    else
      Dec(TmpX);
    BestProposal := 0;

    while (TmpX > 0) and not Result do
    begin
      if LocLine[TmpX] = ',' then
      begin
        Inc(BestProposal);
        Dec(TmpX);
      end
      else if LocLine[TmpX] = ')' then
      begin
        // we found a close, go till it's opening paren
        ParenCounter := 1;
        Dec(TmpX);
        while (TmpX > 0) and (ParenCounter > 0) do
        begin
          if LocLine[TmpX] = ')' then
            Inc(ParenCounter)
          else if LocLine[TmpX] = '(' then
            Dec(ParenCounter);
          Dec(TmpX);
        end;
        if TmpX > 0 then
          Dec(TmpX); // eat the open paren
      end
      else if LocLine[TmpX] = '(' then
      begin
        // we have a valid open paren, lets see what the word before it is
        StartX := TmpX;
        while (TmpX > 0) and not IsIdentChar(LocLine[TmpX]) do
          Dec(TmpX);
        if TmpX > 0 then
        begin
          while (TmpX > 0) and IsIdentChar(LocLine[TmpX]) do
            Dec(TmpX);
          Inc(TmpX);

          GetParameterInfosForCursor(FProgram, TmpX, CurrentEditor.CaretY, Proposal, BestProposal);

          Result := Proposal.Count > 0;

          if not Result then
          begin
            TmpX := StartX;
            Dec(TmpX);
          end;
        end;
      end
      else
        Dec(TmpX)
    end;
  end;
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
  Msg: IMessageInfo;
  Lines: TBits;
begin
  SetLength(Result, 0);

  if not Compile(False, Msg) then
    Exit;

  Breakpointables := TdwsBreakpointableLines.Create(FProgram);
  try
    Lines := Breakpointables.SourceLines[FMasterEngine.GetInternalUnitName(AUnitName)];
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

function TdmDWScript.GetSpecialMainUnitName: string;
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
        Result := QuotedStr(Result);
    end;
    dwsW.ClearEvaluator;
  end;
end;

function TdmDWScript.isTokenIdentifier(TokenType: Integer): Boolean;
begin
  Result := TtkTokenKind(TokenType) = tkIdentifier;
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
    ErrorLine := exec.Msgs.LastMessagePos.Line;
    ErrorUnitName := exec.Msgs.LastMessagePos.SourceFile.Name;
  end;
end;

procedure TdmDWScript.SetActiveUnitName(const Value: string);
begin
  FActiveUnitName := FMasterEngine.GetInternalUnitName(Value);
end;

procedure TdmDWScript.SetActiveLine(const Value: Cardinal);
begin
  FActiveLine := Value;
end;

procedure TdmDWScript.SetErrorUnitName(const Value: string);
begin
  FErrorUnitName := FMasterEngine.GetInternalUnitName(Value);
end;

procedure TdmDWScript.SetErrorLine(const Value: Cardinal);
begin
  FErrorLine := Value;
end;

procedure TdmDWScript.SetRunTo(Position: Integer; const Filename: string);
begin
  FRunToCursorLine := Position;
  FRunToCursorUnitName := FMasterEngine.GetInternalUnitName(Filename);
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

procedure TdmDWScript.ResetBreakpoints;
var
  bp: IBreakpointInfo;
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
      dwsBP.SourceName := FMasterEngine.GetInternalUnitName(bp.Script.ScriptUnitName);
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
  wi: IWatchInfo;
  dwsW: TdwsDebuggerWatch;
  // i: Integer;
  added: Boolean;
begin
  DWDebugger.Watches.Clean;
  if FUseDebugInfo then
    for wi in FMasterEngine.DebugPlugin.Watches do
    begin
      dwsW := TdwsDebuggerWatch.Create;
      dwsW.ExpressionText := wi.Name;
      { i := } DWDebugger.Watches.AddOrFind(dwsW, added);
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
