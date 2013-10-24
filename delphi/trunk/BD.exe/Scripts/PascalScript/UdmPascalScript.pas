unit UdmPascalScript;

interface

uses
  System.SysUtils, Winapi.Windows, Forms, System.Classes, uPSComponent, uPSComponent_COM, uPSComponent_Default, UScriptList, UScriptUtils, LoadComplet, IDHashMap,
  LoadCompletImport, uPSRuntime, uPSDebugger, uPSI_BdtkRegEx, uPSI_BdtkObjects, uPSI_superobject, UdmScripts, UScriptEditor, SynCompletionProposal,
  SynEditHighlighter, SynHighlighterPas;

type
  TPascalScriptEngineFactory = class(TEngineFactory)
  private
    FMasterEngine: IMasterEngine;
  public
    constructor Create(MasterEngine: IMasterEngine); override;
    function GetInstance: IEngineInterface; override;
  end;

  TdmPascalScript = class(TInterfacedObject, IEngineInterface)
    PSImport_DateUtils1: TPSImport_DateUtils;
    PSImport_Classes1: TPSImport_Classes;
    PSImport_ComObj1: TPSImport_ComObj;
    PSDllPlugin1: TPSDllPlugin;
    PSScriptDebugger1: TPSScriptDebugger;
    SynPasSyn1: TSynPasSyn;
    function PSScriptDebugger1NeedFile(Sender: TObject; const OrginFileName: AnsiString; var FileName, Output: AnsiString): Boolean;
    procedure PSScriptDebugger1Compile(Sender: TPSScript);
    procedure PSScriptDebugger1Execute(Sender: TPSScript);
    procedure PSScriptDebugger1AfterExecute(Sender: TPSScript);
    procedure PSScriptDebugger1Breakpoint(Sender: TObject; const FileName: AnsiString; Position, Row, Col: Cardinal);
    procedure PSScriptDebugger1LineInfo(Sender: TObject; const FileName: AnsiString; Position, Row, Col: Cardinal);
    procedure PSScriptDebugger1Idle(Sender: TObject);
  strict private
    FMasterEngine: IMasterEngine;
    FActiveLine, FRunToCursor, FErrorLine: Cardinal;
    FActiveFile, FRunToCursorFile, FErrorFile: string;
    FListTypesImages: TStringList;
    FOnBreakpoint: TPSOnLineInfo;
    FOnLineInfo: TPSOnLineInfo;
    FOnIdle: TNotifyEvent;
    FPSImport_RegExpr: TPSImport_BdtkRegEx;
    FPSImport_BdtkObjects: TPSImport_BdtkObjects;
    FPSImport_superobject: TPSImport_superobject;
    FRunningScript: TScript;

    procedure SetMasterEngine(Value: IMasterEngine);
    function GetMasterEngine: IMasterEngine;
    function GetNewEditor(AOwner: TComponent): TScriptEditor;

    procedure SetRunToCursorFile(const Value: string);
    function GetRunning: Boolean;
    function GetDebugMode: TDebugMode;
    function CorrectScriptName(const Script: AnsiString): AnsiString;
    procedure WriteToFile(const Chaine, FileName: string);

    function GetActiveLine: Cardinal;
    procedure SetActiveLine(const Value: Cardinal);
    function GetActiveFile: string;
    procedure SetActiveFile(const Value: string);
    function GetErrorFile: string;
    procedure SetErrorFile(const Value: string);
    function GetErrorLine: Cardinal;
    procedure SetErrorLine(const Value: Cardinal);
  public
    frmScripts: TForm;

    constructor Create(MasterEngine: IMasterEngine);
    destructor Destroy; override;

    function Compile(Script: TScript; out Msg: TMessageInfo): Boolean; overload;
    function Execute: Boolean;
    function GetMainSpecialName: string;

    function GetExecutableLines(const AUnitName: string): TLineNumbers;
    function TranslatePosition(out Proc, Position: Cardinal; Row: Cardinal; const Fn: string): Boolean;
    procedure GetUncompiledCode(Lines: TStrings);
    procedure setRunTo(Position: Integer; const FileName: string);
    procedure WriteToConsole(const Chaine: string);
    function GetVar(const name: AnsiString; out s: AnsiString): PIFVariant;
    function GetVariableValue(const VarName: string): string;
    function GetWatchValue(const VarName: string): string;

    property ActiveLine: Cardinal read GetActiveLine write SetActiveLine;
    property ActiveFile: string read GetActiveFile write SetActiveFile;
    property RunToCursor: Cardinal read FRunToCursor write FRunToCursor;
    property RunToCursorFile: string read FRunToCursorFile write SetRunToCursorFile;
    property ErrorLine: Cardinal read GetErrorLine write SetErrorLine;
    property ErrorFile: string read GetErrorFile write SetErrorFile;
    property Running: Boolean read GetRunning;
    property DebugMode: TDebugMode read GetDebugMode;

    procedure ResetBreakpoints;

    property OnBreakpoint: TPSOnLineInfo read FOnBreakpoint write FOnBreakpoint;
    property OnLineInfo: TPSOnLineInfo read FOnLineInfo write FOnLineInfo;
    property OnIdle: TNotifyEvent read FOnIdle write FOnIdle;

    function GetUseDebugInfo: Boolean;
    procedure SetUseDebugInfo(Value: Boolean);

    procedure AssignScript(Script: TStrings);

    property MasterEngine: IMasterEngine read GetMasterEngine write SetMasterEngine;

    function Run: Boolean;
    procedure Pause;
    procedure StepInto;
    procedure StepOver;
    procedure Resume;
    procedure Stop;
  end;

implementation

uses AnsiStrings, Procedures, UfrmScripts, Divers, UScriptsFonctions, UScriptsHTMLFunctions, Dialogs, StrUtils, uPSUtils, uPSDisassembly, uPSCompiler,
  UPascalScriptEditor;

type
  PPositionData = ^TPositionData;

  TPositionData = packed record
    FileName: AnsiString;
    Position, Row, Col, SourcePosition: Cardinal;
  end;

  PFunctionInfo = ^TFunctionInfo;

  TFunctionInfo = packed record
    Func: TPSProcRec;
    FParamNames: TIfStringList;
    FVariableNames: TIfStringList;
    FPositionTable: TIfList;
  end;

  TCrackPSDebugExec = class(TPSDebugExec)
  end;

function TdmPascalScript.CorrectScriptName(const Script: AnsiString): AnsiString;
begin
  if Script = '' then
    Result := PSScriptDebugger1.MainFileName
  else
    Result := Script;
end;

constructor TdmPascalScript.Create(MasterEngine: IMasterEngine);
begin
  SetMasterEngine(MasterEngine);

  FListTypesImages := TStringList.Create;
  LoadStrings(6, FListTypesImages);

  PSImport_DateUtils1 := TPSImport_DateUtils.Create(nil);
  PSImport_Classes1 := TPSImport_Classes.Create(nil);
  PSImport_Classes1.EnableStreams := True;
  PSImport_Classes1.EnableClasses := True;
  PSImport_ComObj1 := TPSImport_ComObj.Create(nil);
  PSDllPlugin1 := TPSDllPlugin.Create(nil);

  FPSImport_RegExpr := TPSImport_BdtkRegEx.Create(nil);
  FPSImport_BdtkObjects := TPSImport_BdtkObjects.Create(nil);
  FPSImport_BdtkObjects.MasterEngine := FMasterEngine;
  FPSImport_superobject := TPSImport_superobject.Create(nil);

  PSScriptDebugger1 := TPSScriptDebugger.Create(nil);
  PSScriptDebugger1.CompilerOptions := [icAllowUnit, icBooleanShortCircuit];
  PSScriptDebugger1.OnCompile := PSScriptDebugger1Compile;
  PSScriptDebugger1.OnExecute := PSScriptDebugger1Execute;
  PSScriptDebugger1.OnAfterExecute := PSScriptDebugger1AfterExecute;
  PSScriptDebugger1.MainFileName := 'Main';
  PSScriptDebugger1.UsePreProcessor := True;
  PSScriptDebugger1.OnNeedFile := PSScriptDebugger1NeedFile;
  PSScriptDebugger1.OnFindUnknownFile := PSScriptDebugger1NeedFile;
  PSScriptDebugger1.OnIdle := PSScriptDebugger1Idle;
  PSScriptDebugger1.OnLineInfo := PSScriptDebugger1LineInfo;
  PSScriptDebugger1.OnBreakpoint := PSScriptDebugger1Breakpoint;

  TPSPluginItem(PSScriptDebugger1.Plugins.Add).Plugin := PSImport_DateUtils1;
  TPSPluginItem(PSScriptDebugger1.Plugins.Add).Plugin := PSImport_Classes1;
  TPSPluginItem(PSScriptDebugger1.Plugins.Add).Plugin := PSDllPlugin1;
  TPSPluginItem(PSScriptDebugger1.Plugins.Add).Plugin := PSImport_ComObj1;
  TPSPluginItem(PSScriptDebugger1.Plugins.Add).Plugin := FPSImport_RegExpr;
  TPSPluginItem(PSScriptDebugger1.Plugins.Add).Plugin := FPSImport_BdtkObjects;
  TPSPluginItem(PSScriptDebugger1.Plugins.Add).Plugin := FPSImport_superobject;

  SynPasSyn1 := TSynPasSyn.Create(nil);
  SynPasSyn1.PackageSource := False;
  // force à reprendre les params de delphi s'il est installé sur la machine
  SynPasSyn1.UseUserSettings(0);
end;

destructor TdmPascalScript.Destroy;
begin
  SynPasSyn1.Free;
  PSScriptDebugger1.Free;
  FPSImport_RegExpr.Free;
  FPSImport_BdtkObjects.Free;
  FPSImport_superobject.Free;
  PSImport_DateUtils1.Free;
  PSImport_Classes1.Free;
  PSImport_ComObj1.Free;
  PSDllPlugin1.Free;

  FListTypesImages.Free;

  FMasterEngine := nil;

  inherited;
end;

function TdmPascalScript.GetRunning: Boolean;
begin
  Result := PSScriptDebugger1.Running;
end;

function TdmPascalScript.GetActiveFile: string;
begin
  Result := FActiveFile;
end;

function TdmPascalScript.GetActiveLine: Cardinal;
begin
  Result := FActiveLine;
end;

function TdmPascalScript.GetDebugMode: TDebugMode;
begin
  Result := UdmScripts.TDebugMode(PSScriptDebugger1.Exec.DebugMode);
end;

function TdmPascalScript.GetNewEditor(AOwner: TComponent): TScriptEditor;
begin
  Result := TPascalScriptEditor.Create(AOwner);
  Result.Highlighter := SynPasSyn1;
end;

function TdmPascalScript.GetErrorFile: string;
begin
  Result := FErrorFile;
end;

function TdmPascalScript.GetErrorLine: Cardinal;
begin
  Result := FErrorLine;
end;

function TdmPascalScript.GetExecutableLines(const AUnitName: string): TLineNumbers;
begin
  // Result := [];
end;

function TdmPascalScript.GetMainSpecialName: string;
begin
  Result := string(PSScriptDebugger1.MainFileName);
end;

function TdmPascalScript.GetMasterEngine: IMasterEngine;
begin
  Result := FMasterEngine;
end;

procedure TdmPascalScript.Pause;
begin
  PSScriptDebugger1.Pause;
end;

procedure TdmPascalScript.PSScriptDebugger1AfterExecute(Sender: TPSScript);
begin
  ActiveLine := 0;
  ActiveFile := '';
  RunToCursor := 0;
  RunToCursorFile := '';
  PSScriptDebugger1.ClearBreakPoints;
  FMasterEngine.DebugPlugin.Watches.UpdateView;

  MasterEngine.AfterExecute;
end;

procedure TdmPascalScript.PSScriptDebugger1Breakpoint(Sender: TObject; const FileName: AnsiString; Position, Row, Col: Cardinal);
begin
  ActiveLine := Row;
  ActiveFile := string(FileName);
  FMasterEngine.DebugPlugin.Watches.UpdateView;

  if Assigned(FOnBreakpoint) then
    FOnBreakpoint(Sender, AnsiString(ActiveFile), Position, ActiveLine, Col);
end;

procedure TdmPascalScript.PSScriptDebugger1Compile(Sender: TPSScript);
var
  i: Integer;
begin
  for i := 0 to Pred(FListTypesImages.Count) do
    PSScriptDebugger1.Comp.AddConstantN('cti' + AnsiStrings.StringReplace(AnsiString(SansAccents(FListTypesImages.ValueFromIndex[i])), ' ', '_', [rfReplaceAll]), 'integer').SetInt(StrToInt(AnsiString(FListTypesImages.Names[i])));

  PSScriptDebugger1.AddMethod(Self, @TdmPascalScript.WriteToConsole, 'procedure WriteToConsole(const Chaine: string);');
  PSScriptDebugger1.AddMethod(Self, @TdmPascalScript.WriteToFile, 'procedure WriteToFile(const Chaine, FileName: string);');
  PSScriptDebugger1.AddMethod(FRunningScript, @TScript.OptionValue, 'function GetOptionValue(const OptionName, Default: string): string;');
  PSScriptDebugger1.AddMethod(FRunningScript, @TScript.OptionValueIndex, 'function GetOptionValueIndex(const OptionName: string; Default: Integer): Integer;');
  PSScriptDebugger1.AddMethod(FRunningScript, @TScript.CheckOptionValue, 'function CheckOptionValue(const OptionName, Value: string): Boolean;');

  PSScriptDebugger1.AddFunction(@GetPage, 'function GetPage(const url: string; UTF8: Boolean): string;');
  PSScriptDebugger1.AddFunction(@GetPageWithHeaders, 'function GetPageWithHeaders(const url: string; UTF8: Boolean): string;');
  PSScriptDebugger1.Comp.AddTypeS('RAttachement', 'record Nom, Valeur: string; IsFichier: Boolean; end');
  PSScriptDebugger1.AddFunction(@PostPage, 'function PostPage(const url: string; const Pieces: array of RAttachement; UTF8: Boolean): string;');
  PSScriptDebugger1.AddFunction(@PostPageWithHeaders, 'function PostPageWithHeaders(const url: string; const Pieces: array of RAttachement; UTF8: Boolean): string;');
  PSScriptDebugger1.AddFunction(@findInfo, 'function findInfo(const sDebut, sFin, sChaine, sDefault: string): string;');
  PSScriptDebugger1.AddFunction(@MakeAuteur, 'function MakeAuteur(const Nom: string; Metier: TMetierAuteur): TAuteur;');
  PSScriptDebugger1.AddFunction(@AskSearchEntry, 'function AskSearchEntry(const Labels: array of string; var Search: string; var Index: Integer): Boolean');
  PSScriptDebugger1.AddFunction(@CombineURL, 'function CombineURL(const Root, URL: string): string;');
  PSScriptDebugger1.AddFunction(@HTMLDecode, 'function HTMLDecode(const Chaine: string): string;');
  PSScriptDebugger1.AddFunction(@HTMLText, 'function HTMLText(const Chaine: string): string;');

  PSScriptDebugger1.AddFunction(@ScriptChangeFileExt, 'function ChangeFileExt(const URL, Extension: string): string;');
  PSScriptDebugger1.AddFunction(@ScriptChangeFilePath, 'function ChangeFilePath(const URL, Path: string): string;');
  PSScriptDebugger1.AddFunction(@ScriptExtractFilePath, 'function ExtractFilePath(const URL: string): string;');
  PSScriptDebugger1.AddFunction(@ScriptExtractFileDir, 'function ExtractFileDir(const URL: string): string;');
  PSScriptDebugger1.AddFunction(@ScriptExtractFileName, 'function ExtractFileName(const URL: string): string;');
  PSScriptDebugger1.AddFunction(@ScriptExtractFileExt, 'function ExtractFileExt(const URL: string): string;');
  PSScriptDebugger1.AddFunction(@ScriptIncludeTrailingPathDelimiter, 'function IncludeTrailingPathDelimiter(const URL: string): string;');
  PSScriptDebugger1.AddFunction(@ScriptExcludeTrailingPathDelimiter, 'function ExcludeTrailingPathDelimiter(const URL: string): string;');

  PSScriptDebugger1.AddFunction(@System.SysUtils.Format, 'function Format(const Format: string; const Args: array of const): string;');

  PSScriptDebugger1.AddFunction(@System.SysUtils.SameText, 'function SameText(const S1, S2: string): Boolean;');
  PSScriptDebugger1.AddFunction(@ShowMessage, 'procedure ShowMessage(const Msg: string);');
  PSScriptDebugger1.AddFunction(@StrUtils.PosEx, 'function PosEx(const SubStr, S: string; Offset: Cardinal): Integer;');

  PSScriptDebugger1.Comp.AddTypeS('TReplaceFlag', '(rfReplaceAll, rfIgnoreCase)');
  PSScriptDebugger1.Comp.AddTypeS('TReplaceFlags', 'set of TReplaceFlag');
  PSScriptDebugger1.AddFunction(@System.SysUtils.StringReplace, 'function StringReplace(const S, OldPattern, NewPattern: string; Flags: TReplaceFlags): string;');
  PSScriptDebugger1.AddFunction(@ScriptStrToFloatDef, 'function StrToFloatDef(const S: string; const Default: Extended): Extended;');

  PSScriptDebugger1.AddRegisteredVariable('AlbumToImport', 'TAlbumComplet');
end;

procedure TdmPascalScript.PSScriptDebugger1Execute(Sender: TPSScript);
begin
  ResetBreakpoints;
  Sender.SetVarToInstance('AlbumToImport', FMasterEngine.AlbumToImport);
end;

procedure TdmPascalScript.PSScriptDebugger1Idle(Sender: TObject);
begin
  Application.HandleMessage;

  if Assigned(FOnIdle) then
    FOnIdle(Sender);
end;

procedure TdmPascalScript.PSScriptDebugger1LineInfo(Sender: TObject; const FileName: AnsiString; Position, Row, Col: Cardinal);
begin
  ActiveLine := Row;
  ActiveFile := string(FileName);

  if (ActiveLine = RunToCursor) and SameText(ActiveFile, RunToCursorFile) and (PSScriptDebugger1.Exec.DebugMode = uPSDebugger.dmRun) then
    PSScriptDebugger1.Pause;

  if PSScriptDebugger1.Exec.DebugMode in [uPSDebugger.dmPaused, uPSDebugger.dmStepInto] then
    FMasterEngine.DebugPlugin.Watches.UpdateView;

  if Assigned(FOnLineInfo) then
    FOnLineInfo(Sender, AnsiString(ActiveFile), Position, ActiveLine, Col);
end;

function TdmPascalScript.PSScriptDebugger1NeedFile(Sender: TObject; const OrginFileName: AnsiString; var FileName, Output: AnsiString): Boolean;
var
  tmp: TStringList;
begin
  tmp := TStringList.Create;
  try
    Result := FMasterEngine.ScriptList.GetScriptLines(string(FileName), tmp, [skMain, skUnit]);
    Output := AnsiString(tmp.Text);
  finally
    tmp.Free;
  end;
end;

procedure TdmPascalScript.Resume;
begin
  PSScriptDebugger1.Resume;
end;

function TdmPascalScript.Run: Boolean;
begin
  Result := PSScriptDebugger1.Execute;
end;

procedure TdmPascalScript.SetActiveFile(const Value: string);
begin
  FActiveFile := string(CorrectScriptName(AnsiString(Value)));
end;

procedure TdmPascalScript.SetActiveLine(const Value: Cardinal);
begin
  FActiveLine := Value;
end;

procedure TdmPascalScript.SetErrorFile(const Value: string);
begin
  FErrorFile := string(CorrectScriptName(AnsiString(Value)));
end;

procedure TdmPascalScript.SetErrorLine(const Value: Cardinal);
begin
  FErrorLine := Value;
end;

procedure TdmPascalScript.SetMasterEngine(Value: IMasterEngine);
begin
  FMasterEngine := Value;
end;

procedure TdmPascalScript.setRunTo(Position: Integer; const FileName: string);
begin
  RunToCursor := Position;;
  RunToCursorFile := FileName;
end;

procedure TdmPascalScript.SetRunToCursorFile(const Value: string);
begin
  FRunToCursorFile := string(CorrectScriptName(AnsiString(Value)));
end;

procedure TdmPascalScript.SetUseDebugInfo(Value: Boolean);
begin
  PSScriptDebugger1.UseDebugInfo := Value;
end;

procedure TdmPascalScript.StepInto;
begin
  PSScriptDebugger1.StepInto;
end;

procedure TdmPascalScript.StepOver;
begin
  PSScriptDebugger1.StepOver;
end;

procedure TdmPascalScript.Stop;
begin
  PSScriptDebugger1.Stop;
end;

function TdmPascalScript.TranslatePosition(out Proc, Position: Cardinal; Row: Cardinal; const Fn: string): Boolean;
var
  i, j: LongInt;
  fi: PFunctionInfo;
  pt: TIfList;
  r: PPositionData;
begin
  Result := True;
  Proc := 0;
  Position := 0;
  for i := 0 to TCrackPSDebugExec(PSScriptDebugger1.Exec).FDebugDataForProcs.Count - 1 do
  begin
    Result := False;
    fi := TCrackPSDebugExec(PSScriptDebugger1.Exec).FDebugDataForProcs[i];
    pt := fi^.FPositionTable;
    for j := 0 to pt.Count - 1 do
    begin
      r := pt[j];
      if not SameText(string(r^.FileName), Fn) then
        Continue;
      if r^.Row = Row then
      begin
        Proc := TCrackPSDebugExec(PSScriptDebugger1.Exec).FProcs.IndexOf(fi^.Func);
        Position := r^.Position;
        Result := True;
        Exit;
      end;
    end;
  end;
end;

procedure TdmPascalScript.GetUncompiledCode(Lines: TStrings);
var
  s: AnsiString;
  Script: string;
  i, j: LongInt;
  fi: PFunctionInfo;
  pt: TIfList;
  r: PPositionData;
begin
  PSScriptDebugger1.GetCompiled(s);
  IFPS3DataToText(s, Script);
  Lines.Text := Script;

  Lines.Add('[DEBUG DATA]');
  for i := 0 to TCrackPSDebugExec(PSScriptDebugger1.Exec).FDebugDataForProcs.Count - 1 do
  begin
    fi := TCrackPSDebugExec(PSScriptDebugger1.Exec).FDebugDataForProcs[i];
    pt := fi^.FPositionTable;
    if fi^.Func is TPSExternalProcRec then
      with TPSExternalProcRec(fi^.Func) do
        Lines.Add(Format('ExternalProc: %s %s', [name, Decl]))
    else if fi^.Func is TPSInternalProcRec then
      with TPSInternalProcRec(fi^.Func) do
        Lines.Add(Format('InternalProc: %s %s', [ExportName, ExportDecl]))
    else
      Lines.Add('unknown proc');

    for j := 0 to pt.Count - 1 do
    begin
      r := pt[j];
      Lines.Add(Format('%s: P=%d, RxC=%dx%d, SP=%d', [r^.FileName, r^.Position, r^.Row, r^.Col, r^.SourcePosition]));
    end;
  end;
end;

function TdmPascalScript.GetUseDebugInfo: Boolean;
begin
  Result := PSScriptDebugger1.UseDebugInfo;
end;

procedure TdmPascalScript.WriteToFile(const Chaine, FileName: string);
var
  Buffer, Preamble: TBytes;
  fs: TFileStream;
begin
  Buffer := TEncoding.default.GetBytes(Chaine);
  Preamble := TEncoding.default.GetPreamble;

  if FileExists(FileName) then
    fs := TFileStream.Create(FileName, fmOpenWrite)
  else
    fs := TFileStream.Create(FileName, fmCreate or fmOpenWrite);
  try
    fs.Size := 0;

    if Length(Preamble) > 0 then
      fs.WriteBuffer(Preamble[0], Length(Preamble));
    fs.WriteBuffer(Buffer[0], Length(Buffer));
  finally
    fs.Free;
  end;
end;

procedure TdmPascalScript.WriteToConsole(const Chaine: string);
begin
  MasterEngine.WriteToConsole(Chaine);
end;

function TdmPascalScript.GetVar(const name: AnsiString; out s: AnsiString): PIFVariant;
var
  i: LongInt;
  s1: AnsiString;
begin
  s := UpperCase(name);
  if AnsiStrings.AnsiPos('.', s) > 0 then
  begin
    s1 := AnsiString(Copy(string(s), 1, AnsiStrings.AnsiPos('.', s) - 1));
    delete(s, 1, AnsiStrings.AnsiPos('.', name));
  end
  else
  begin
    s1 := s;
    s := '';
  end;
  Result := nil;
  with PSScriptDebugger1 do
  begin
    for i := 0 to Exec.CurrentProcVars.Count - 1 do
      if UpperCase(Exec.CurrentProcVars[i]) = s1 then
      begin
        Result := Exec.GetProcVar(i);
        break;
      end;
    if Result = nil then
    begin
      for i := 0 to Exec.CurrentProcParams.Count - 1 do
        if UpperCase(Exec.CurrentProcParams[i]) = s1 then
        begin
          Result := Exec.GetProcParam(i);
          break;
        end;
    end;
    if Result = nil then
    begin
      for i := 0 to Exec.GlobalVarNames.Count - 1 do
        if UpperCase(Exec.GlobalVarNames[i]) = s1 then
        begin
          Result := Exec.GetGlobalVar(i);
          break;
        end;
    end;
  end;
end;

function TdmPascalScript.GetVariableValue(const VarName: string): string;
var
  pv: PIFVariant;
  Prefix: AnsiString;
begin
  if PSScriptDebugger1.Running then
  begin
    pv := GetVar(AnsiString(VarName), Prefix);
    if pv = nil then
      Result := '{Expression inconnue}'
    else
      Result := string(PSVariantToString(NewTPSVariantIFC(pv, False), Prefix));
  end
  else
    Result := '{Valeur inaccessible}'
end;

function TdmPascalScript.GetWatchValue(const VarName: string): string;
begin
  Result := GetVariableValue(VarName);
end;

procedure TdmPascalScript.AssignScript(Script: TStrings);
begin
  PSScriptDebugger1.Script.Assign(Script);
end;

function TdmPascalScript.Compile(Script: TScript; out Msg: TMessageInfo): Boolean;
var
  i: LongInt;
begin
  FRunningScript := Script;
  PSScriptDebugger1.MainFileName := AnsiString(FRunningScript.ScriptName);
  FRunningScript.GetScriptLines(PSScriptDebugger1.Script);
  Result := PSScriptDebugger1.Compile;
  FMasterEngine.DebugPlugin.Messages.Clear;
  Msg := nil;
  for i := 0 to PSScriptDebugger1.CompilerMessageCount - 1 do
    with PSScriptDebugger1.CompilerMessages[i] do
      if ClassType = TPSPascalCompilerWarning then
        FMasterEngine.DebugPlugin.Messages.AddCompileErrorMessage(string(ModuleName), string(ShortMessageToString), tmWarning, Row, Col)
      else if ClassType = TPSPascalCompilerHint then
        FMasterEngine.DebugPlugin.Messages.AddCompileErrorMessage(string(ModuleName), string(ShortMessageToString), tmHint, Row, Col)
      else if ClassType = TPSPascalCompilerError then
      begin
        Msg := FMasterEngine.DebugPlugin.Messages[FMasterEngine.DebugPlugin.Messages.AddCompileErrorMessage(string(ModuleName), string(ShortMessageToString), tmError, Row, Col)];
      end
      else
        FMasterEngine.DebugPlugin.Messages.AddCompileErrorMessage(string(ModuleName), string(ShortMessageToString), tmUnknown, Row, Col);
end;

function TdmPascalScript.Execute: Boolean;
begin
  FMasterEngine.AlbumToImport.Clear;
  if Assigned(MasterEngine.Console) then
    MasterEngine.Console.Clear;
  if PSScriptDebugger1.Execute then
  begin
    ErrorLine := 0;
    Result := True;
  end
  else
  begin
    ErrorLine := PSScriptDebugger1.ExecErrorRow;
    ErrorFile := string(PSScriptDebugger1.ExecErrorFileName);
    FMasterEngine.DebugPlugin.Messages.AddRuntimeErrorMessage(ErrorFile, Format('%s (Bytecode %d:%d)', [PSScriptDebugger1.ExecErrorToString, PSScriptDebugger1.ExecErrorProcNo, PSScriptDebugger1.ExecErrorByteCodePosition]), PSScriptDebugger1.ExecErrorRow, PSScriptDebugger1.ExecErrorCol);
    Result := False;
  end;
end;

procedure TdmPascalScript.ResetBreakpoints;
var
  bp: TBreakpointInfo;
begin
  PSScriptDebugger1.ClearBreakPoints;
  if PSScriptDebugger1.UseDebugInfo then
    for bp in FMasterEngine.DebugPlugin.Breakpoints do
      if bp.Active then
        if bp.Fichier = string(PSScriptDebugger1.MainFileName) then
          PSScriptDebugger1.SetBreakPoint('', bp.Line)
        else
          PSScriptDebugger1.SetBreakPoint(AnsiString(bp.Fichier), bp.Line);
end;

{ TPascalScriptEngineFactory }

constructor TPascalScriptEngineFactory.Create(MasterEngine: IMasterEngine);
begin
  inherited;
  FMasterEngine := MasterEngine;
end;

function TPascalScriptEngineFactory.GetInstance: IEngineInterface;
begin
  Result := TdmPascalScript.Create(FMasterEngine);
end;

initialization

RegisterEngineScript(sePascalScript, TPascalScriptEngineFactory);

end.
