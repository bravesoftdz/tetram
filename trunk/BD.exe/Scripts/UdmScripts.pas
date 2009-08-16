unit UdmScripts;

interface

uses
  SysUtils, Windows, Forms, Classes, uPSComponent, uPSComponent_COM, uPSComponent_Default, UScriptList, UScriptUtils,
  LoadComplet, LoadCompletImport, uPSRuntime, uPSDebugger, uPSI_BdtkRegEx, uPSI_BdtkObjects;

type
  TdmScripts = class(TDataModule)
    PSImport_DateUtils1: TPSImport_DateUtils;
    PSImport_Classes1: TPSImport_Classes;
    PSImport_ComObj1: TPSImport_ComObj;
    PSDllPlugin1: TPSDllPlugin;
    PSScriptDebugger1: TPSScriptDebugger;
    function PSScriptDebugger1NeedFile(Sender: TObject; const OrginFileName: AnsiString; var FileName, Output: AnsiString): Boolean;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure PSScriptDebugger1Compile(Sender: TPSScript);
    procedure PSScriptDebugger1Execute(Sender: TPSScript);
    procedure PSScriptDebugger1AfterExecute(Sender: TPSScript);
    procedure PSScriptDebugger1Breakpoint(Sender: TObject; const FileName: AnsiString; Position, Row, Col: Cardinal);
    procedure PSScriptDebugger1LineInfo(Sender: TObject; const FileName: AnsiString; Position, Row, Col: Cardinal);
    procedure PSScriptDebugger1Idle(Sender: TObject);
  private
    FActiveLine, FRunToCursor, FErrorLine: Cardinal;
    FActiveFile, FRunToCursorFile, FErrorFile: AnsiString;
    FScriptList: TScriptList;
    FListTypesImages: TStringList;
    FDebugPlugin: TDebugInfos;
    FConsole: TStrings;
    FInternalAlbumToImport, FAlbumToImport: TAlbumComplet;
    FOnAfterExecute: TPSEvent;
    FOnBreakpoint: TPSOnLineInfo;
    FOnLineInfo: TPSOnLineInfo;
    FOnIdle: TNotifyEvent;
    FPSImport_RegExpr: TPSImport_BdtkRegEx;
    FPSImport_BdtkObjects: TPSImport_BdtkObjects;
    FRunningScript: TScript;

    procedure SetActiveFile(const Value: AnsiString);
    procedure SetRunToCursorFile(const Value: AnsiString);
    procedure SetErrorFile(const Value: AnsiString);
    function GetRunning: Boolean;
    function GetDebugMode: TDebugMode;
    function CorrectScriptName(const Script: AnsiString): AnsiString;
    procedure SetAlbumToImport(Value: TAlbumComplet);
    procedure WriteToFile(const Chaine, FileName: string);
  public
    frmScripts: TForm;

    function AlbumToUpdate: Boolean;

    function Compile(Script: TScript; out Msg: TMessageInfo): Boolean;
    function Execute: Boolean;

    function TranslatePositionEx(out Proc, Position: Cardinal; Row: Cardinal; const Fn: AnsiString): Boolean;
    procedure GetUncompiledCode(Lines: TStrings);
    procedure WriteToConsole(const Chaine: string);
    function GetVar(const Name: AnsiString; out s: AnsiString): PIFVariant;
    function GetVariableValue(const VarName: AnsiString; Actif: Boolean): AnsiString;

    property ScriptList: TScriptList read FScriptList write FScriptList;

    property ActiveLine: Cardinal read FActiveLine write FActiveLine;
    property ActiveFile: AnsiString read FActiveFile write SetActiveFile;
    property RunToCursor: Cardinal read FRunToCursor write FRunToCursor;
    property RunToCursorFile: AnsiString read FRunToCursorFile write SetRunToCursorFile;
    property ErrorLine: Cardinal read FErrorLine write FErrorLine;
    property ErrorFile: AnsiString read FErrorFile write SetErrorFile;
    property Running: Boolean read GetRunning;
    property DebugMode: TDebugMode read GetDebugMode;

    property DebugPlugin: TDebugInfos read FDebugPlugin;
    property AlbumToImport: TAlbumComplet read FAlbumToImport write SetAlbumToImport;
    property Console: TStrings read FConsole write FConsole;

    procedure ToggleBreakPoint(const Script: AnsiString; Line: Cardinal; Keep: Boolean);

    property OnAfterExecute: TPSEvent read FOnAfterExecute write FOnAfterExecute;
    property OnBreakpoint: TPSOnLineInfo read FOnBreakpoint write FOnBreakpoint;
    property OnLineInfo: TPSOnLineInfo read FOnLineInfo write FOnLineInfo;
    property OnIdle: TNotifyEvent read FOnIdle write FOnIdle;
  end;

implementation

uses
  AnsiStrings, Procedures, UfrmScripts, Divers, UScriptsFonctions,
  UScriptsHTMLFunctions, Dialogs, StrUtils, uPSUtils, uPSDisassembly, uPSCompiler;

{$R *.dfm}

type
  PPositionData = ^TPositionData;

  TPositionData = packed record
    FileName: AnsiString;
    Position,
    Row,
    Col,
    SourcePosition: Cardinal;
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

procedure TdmScripts.DataModuleCreate(Sender: TObject);
begin
  FListTypesImages := TStringList.Create;
  LoadStrings(6, FListTypesImages);
  FInternalAlbumToImport := TAlbumComplet.Create;
  FAlbumToImport := FInternalAlbumToImport;
  FDebugPlugin := TDebugInfos.Create;

  FPSImport_RegExpr := TPSImport_BdtkRegEx.Create(Self);
  TPSPluginItem(PSScriptDebugger1.Plugins.Add).Plugin := FPSImport_RegExpr;
  FPSImport_BdtkObjects := TPSImport_BdtkObjects.Create(Self);
  TPSPluginItem(PSScriptDebugger1.Plugins.Add).Plugin := FPSImport_BdtkObjects;
end;

procedure TdmScripts.DataModuleDestroy(Sender: TObject);
begin
  FListTypesImages.Free;
  FInternalAlbumToImport.Free;
  FDebugPlugin.Free;
end;

function TdmScripts.CorrectScriptName(const Script: AnsiString): AnsiString;
begin
  if Script = '' then
    Result := PSScriptDebugger1.MainFileName
  else
    Result := Script;
end;

function TdmScripts.GetRunning: Boolean;
begin
  Result := PSScriptDebugger1.Running;
end;

function TdmScripts.GetDebugMode: TDebugMode;
begin
  Result := PSScriptDebugger1.Exec.DebugMode;
end;

procedure TdmScripts.PSScriptDebugger1AfterExecute(Sender: TPSScript);
begin
  ActiveLine := 0;
  ActiveFile := '';
  RunToCursor := 0;
  RunToCursorFile := '';
  PSScriptDebugger1.ClearBreakPoints;
  DebugPlugin.Watches.UpdateView;

  if Assigned(FOnAfterExecute) then
    FOnAfterExecute(Sender);
end;

procedure TdmScripts.PSScriptDebugger1Breakpoint(Sender: TObject; const FileName: AnsiString; Position, Row, Col: Cardinal);
begin
  ActiveLine := Row;
  ActiveFile := FileName;
  DebugPlugin.Watches.UpdateView;

  if Assigned(FOnBreakpoint) then
    FOnBreakpoint(Sender, ActiveFile, Position, ActiveLine, Col);
end;

procedure TdmScripts.PSScriptDebugger1Compile(Sender: TPSScript);
var
  i: Integer;
begin
  for i := 0 to Pred(FListTypesImages.Count) do
    PSScriptDebugger1.Comp.AddConstantN('cti' + AnsiStrings.StringReplace(AnsiString(SansAccents(FListTypesImages.ValueFromIndex[i])), ' ', '_', [rfReplaceAll]), 'integer').SetInt(StrToInt(AnsiString(FListTypesImages.Names[i])));

  PSScriptDebugger1.AddMethod(Self, @TdmScripts.WriteToConsole, 'procedure WriteToConsole(const Chaine: string);');
  PSScriptDebugger1.AddMethod(Self, @TdmScripts.WriteToFile, 'procedure WriteToFile(const Chaine, FileName: string);');
  PSScriptDebugger1.AddMethod(FRunningScript, @TScript.OptionValue, 'function GetOptionValue(const OptionName, Default: string): string;');
  PSScriptDebugger1.AddMethod(FRunningScript, @TScript.OptionValueIndex, 'function GetOptionValueIndex(const OptionName: string; Default: Integer): Integer;');

  PSScriptDebugger1.AddFunction(@GetPage, 'function GetPage(const url: string; UTF8: Boolean): string;');
  PSScriptDebugger1.Comp.AddTypeS('RAttachement', 'record Nom, Valeur: string; IsFichier: Boolean; end');
  PSScriptDebugger1.AddFunction(@PostPage, 'function PostPage(const url: string; const Pieces: array of RAttachement; UTF8: Boolean): string;');
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

  PSScriptDebugger1.AddFunction(@SysUtils.Format, 'function Format(const Format: string; const Args: array of const): string;');

  PSScriptDebugger1.AddFunction(@SysUtils.SameText, 'function SameText(const S1, S2: string): Boolean;');
  PSScriptDebugger1.AddFunction(@ShowMessage, 'procedure ShowMessage(const Msg: string);');
  PSScriptDebugger1.AddFunction(@StrUtils.PosEx, 'function PosEx(const SubStr, S: string; Offset: Cardinal): Integer;');

  PSScriptDebugger1.Comp.AddTypeS('TReplaceFlag', '(rfReplaceAll, rfIgnoreCase)');
  PSScriptDebugger1.Comp.AddTypeS('TReplaceFlags', 'set of TReplaceFlag');
  PSScriptDebugger1.AddFunction(@SysUtils.StringReplace, 'function StringReplace(const S, OldPattern, NewPattern: string; Flags: TReplaceFlags): string;');
  PSScriptDebugger1.AddFunction(@ScriptStrToFloatDef, 'function StrToFloatDef(const S: string; const Default: Extended): Extended;');

  PSScriptDebugger1.AddRegisteredVariable('AlbumToImport', 'TAlbumComplet');
end;

procedure TdmScripts.PSScriptDebugger1Execute(Sender: TPSScript);
var
  bp: TBreakpointInfo;
begin
  PSScriptDebugger1.ClearBreakPoints;
  if PSScriptDebugger1.UseDebugInfo then
    for bp in FDebugPlugin.Breakpoints do
      if bp.Active then
        if bp.Fichier = PSScriptDebugger1.MainFileName then
          PSScriptDebugger1.SetBreakPoint(bp.Fichier, bp.Line)
        else
          PSScriptDebugger1.SetBreakPoint(AnsiStrings.UpperCase(bp.Fichier), bp.Line);

  Sender.SetVarToInstance('AlbumToImport', FAlbumToImport);
end;

procedure TdmScripts.PSScriptDebugger1Idle(Sender: TObject);
begin
  Application.HandleMessage;

  if Assigned(FOnIdle) then
    FOnIdle(Sender);
end;

procedure TdmScripts.PSScriptDebugger1LineInfo(Sender: TObject; const FileName: AnsiString; Position, Row, Col: Cardinal);
begin
  ActiveLine := Row;
  ActiveFile := FileName;

  if (ActiveLine = RunToCursor) and SameText(ActiveFile, RunToCursorFile) and (PSScriptDebugger1.Exec.DebugMode = dmRun) then
    PSScriptDebugger1.Pause;

  if PSScriptDebugger1.Exec.DebugMode in [dmPaused, dmStepInto] then
    DebugPlugin.Watches.UpdateView;

  if Assigned(FOnLineInfo) then
    FOnLineInfo(Sender, ActiveFile, Position, ActiveLine, Col);
end;

function TdmScripts.PSScriptDebugger1NeedFile(Sender: TObject; const OrginFileName: AnsiString; var FileName, Output: AnsiString): Boolean;
var
  tmp: TStringList;
begin
  tmp := TStringList.Create;
  try
    Result := FScriptList.GetScriptLines(FileName, tmp, [skMain, skUnit]);
    Output := AnsiString(tmp.Text);
  finally
    tmp.Free;
  end;
end;

procedure TdmScripts.SetActiveFile(const Value: AnsiString);
begin
  FActiveFile := CorrectScriptName(Value);
end;

procedure TdmScripts.SetErrorFile(const Value: AnsiString);
begin
  FErrorFile := CorrectScriptName(Value);
end;

procedure TdmScripts.SetRunToCursorFile(const Value: AnsiString);
begin
  FRunToCursorFile := CorrectScriptName(Value);
end;

function TdmScripts.TranslatePositionEx(out Proc, Position: Cardinal; Row: Cardinal; const Fn: AnsiString): Boolean;
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
      if not AnsiSameText(r^.FileName, Fn) then
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

procedure TdmScripts.GetUncompiledCode(Lines: TStrings);
var
  s: AnsiString;
  script: string;
  i, j: LongInt;
  fi: PFunctionInfo;
  pt: TIfList;
  r: PPositionData;
begin
  PSScriptDebugger1.GetCompiled(s);
  IFPS3DataToText(s, script);
  Lines.Text := script;

  Lines.Add('[DEBUG DATA]');
  for i := 0 to TCrackPSDebugExec(PSScriptDebugger1.Exec).FDebugDataForProcs.Count - 1 do
  begin
    fi := TCrackPSDebugExec(PSScriptDebugger1.Exec).FDebugDataForProcs[i];
    pt := fi^.FPositionTable;
    if fi^.Func is TPSExternalProcRec then
      with TPSExternalProcRec(fi^.Func) do
        Lines.Add(Format('ExternalProc: %s %s', [Name, Decl]))
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

procedure TdmScripts.WriteToFile(const Chaine, FileName: string);
var
  Buffer, Preamble: TBytes;
  fs: TFileStream;
begin
  Buffer := TEncoding.Default.GetBytes(Chaine);
  Preamble := TEncoding.Default.GetPreamble;

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

procedure TdmScripts.WriteToConsole(const Chaine: string);
begin
  if Assigned(FConsole) then
    FConsole.Add(Chaine);
end;

function TdmScripts.GetVar(const Name: AnsiString; out s: AnsiString): PIFVariant;
var
  i: Longint;
  s1: AnsiString;
begin
  s := UpperCase(Name);
  if AnsiStrings.AnsiPos('.', s) > 0 then
  begin
    s1 := AnsiString(Copy(string(s), 1, AnsiStrings.AnsiPos('.', s) - 1));
    delete(s, 1, AnsiStrings.AnsiPos('.', Name));
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
        if Uppercase(Exec.CurrentProcParams[i]) = s1 then
        begin
          Result := Exec.GetProcParam(i);
          break;
        end;
    end;
    if Result = nil then
    begin
      for i := 0 to Exec.GlobalVarNames.Count - 1 do
        if Uppercase(Exec.GlobalVarNames[i]) = s1 then
        begin
          Result := Exec.GetGlobalVar(i);
          break;
        end;
    end;
  end;
end;

function TdmScripts.GetVariableValue(const VarName: AnsiString; Actif: Boolean): AnsiString;
var
  pv: PIFVariant;
  Prefix: AnsiString;
begin
  if Actif then
    if PSScriptDebugger1.Running then
    begin
      pv := GetVar(VarName, Prefix);
      if pv = nil then
        Result := '{Expression inconnue}'
      else
        Result := PSVariantToString(NewTPSVariantIFC(pv, False), Prefix);
    end
    else
      Result := '{Valeur inaccessible}'
  else
    Result := '<désactivé>';
end;

function TdmScripts.Compile(Script: TScript; out Msg: TMessageInfo): Boolean;
var
  i: Longint;
begin
  FRunningScript := Script;
  PSScriptDebugger1.MainFileName := FRunningScript.ScriptName;
  FRunningScript.GetScriptLines(PSScriptDebugger1.Script);
  Result := PSScriptDebugger1.Compile;
  FDebugPlugin.Messages.Clear;
  Msg := nil;
  for i := 0 to PSScriptDebugger1.CompilerMessageCount - 1 do
    with PSScriptDebugger1.CompilerMessages[i] do
      if ClassType = TPSPascalCompilerWarning then
        DebugPlugin.Messages.AddCompileErrorMessage(ModuleName, ShortMessageToString, tmWarning, Row, Col)
      else if ClassType = TPSPascalCompilerHint then
        DebugPlugin.Messages.AddCompileErrorMessage(ModuleName, ShortMessageToString, tmHint, Row, Col)
      else if ClassType = TPSPascalCompilerError then
      begin
        Msg := DebugPlugin.Messages[DebugPlugin.Messages.AddCompileErrorMessage(ModuleName, ShortMessageToString, tmError, Row, Col)];
      end
      else
        DebugPlugin.Messages.AddCompileErrorMessage(ModuleName, ShortMessageToString, tmUnknown, Row, Col);
end;

function TdmScripts.Execute: Boolean;
begin
  FAlbumToImport.Clear;
  FConsole.Clear;
  if PSScriptDebugger1.Execute then
  begin
    ErrorLine := 0;
    Result := True;
  end
  else
  begin
    ErrorLine := PSScriptDebugger1.ExecErrorRow;
    ErrorFile := PSScriptDebugger1.ExecErrorFileName;
    DebugPlugin.Messages.AddRuntimeErrorMessage(
      ErrorFile,
      AnsiString(Format('%s (Bytecode %d:%d)', [PSScriptDebugger1.ExecErrorToString, PSScriptDebugger1.ExecErrorProcNo, PSScriptDebugger1.ExecErrorByteCodePosition])),
      PSScriptDebugger1.ExecErrorRow,
      PSScriptDebugger1.ExecErrorCol);
    Result := False;
  end;
end;

procedure TdmScripts.ToggleBreakPoint(const Script: AnsiString; Line: Cardinal; Keep: Boolean);
var
  i: Integer;
begin
  i := DebugPlugin.Breakpoints.IndexOf(Script, Line);
  if i = -1 then // nouveau point d'arrêt
  begin
    DebugPlugin.Breakpoints.AddBreakpoint(Script, Line);
    if Running then
      if Script = PSScriptDebugger1.MainFileName then
        PSScriptDebugger1.SetBreakPoint('', Line)
      else
        PSScriptDebugger1.SetBreakPoint(Script, Line);
  end
  else if Keep then // changement d'état du point d'arrêt
  begin
    DebugPlugin.Breakpoints[i].Active := not DebugPlugin.Breakpoints[i].Active;
    if Running then
      if DebugPlugin.Breakpoints[i].Active then
        if Script = PSScriptDebugger1.MainFileName then
          PSScriptDebugger1.SetBreakPoint('', Line)
        else
          PSScriptDebugger1.SetBreakPoint(Script, Line)
      else if Script = PSScriptDebugger1.MainFileName then
        PSScriptDebugger1.ClearBreakPoint('', Line)
      else
        PSScriptDebugger1.ClearBreakPoint(Script, Line);
  end
  else
  begin // suppression du point d'arrêt
    DebugPlugin.Breakpoints.Delete(i);
    if Running then
      PSScriptDebugger1.ClearBreakPoint(Script, Line);
  end;
end;

procedure TdmScripts.SetAlbumToImport(Value: TAlbumComplet);
begin
  if not Running then
  begin
    if Value = nil then
      FAlbumToImport := FInternalAlbumToImport
    else
      FAlbumToImport := Value;
  end;
end;

function TdmScripts.AlbumToUpdate: Boolean;
begin
  Result := FAlbumToImport <> FInternalAlbumToImport;
end;

end.
