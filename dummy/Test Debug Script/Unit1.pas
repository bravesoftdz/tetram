unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SynEditHighlighter, SynHighlighterPas, SynEdit, ImgList, StrUtils,
  uPSComponent, uPSDebugger, SynEditMiscClasses, SynEditSearch, StdActns, ActnList, uPSDisassembly,
  Menus, SynEditTypes, Unit5, ComCtrls, uPSCompiler,
  uPSRuntime, VirtualTrees, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    SynPasSyn1: TSynPasSyn;
    lstDebugImages: TImageList;
    PSScriptDebugger1: TPSScriptDebugger;
    SynEditSearch1: TSynEditSearch;
    ActionList1: TActionList;
    EditCut1: TAction;
    EditCopy1: TAction;
    EditPaste1: TAction;
    EditSelectAll1: TAction;
    EditUndo1: TAction;
    SearchFind1: TAction;
    SearchFindNext1: TAction;
    MainMenu1: TMainMenu;
    Edition1: TMenuItem;
    Remplacer1: TMenuItem;
    Chercher1: TMenuItem;
    N2: TMenuItem;
    Coller1: TMenuItem;
    Copier1: TMenuItem;
    Couper1: TMenuItem;
    N3: TMenuItem;
    Dfaire1: TMenuItem;
    Copier2: TMenuItem;
    outslectionner1: TMenuItem;
    SearchReplace1: TAction;
    EditRedo1: TAction;
    Refaire1: TMenuItem;
    Chercher2: TMenuItem;
    Splitter1: TSplitter;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    actRun: TAction;
    actCompile: TAction;
    actStepOver: TAction;
    actStepInto: TAction;
    actReset: TAction;
    actDecompile: TAction;
    a1: TMenuItem;
    actBreakpoint: TAction;
    N4: TMenuItem;
    Basculerpointdarrt1: TMenuItem;
    Panel2: TPanel;
    EScript: TSynEdit;
    actAddSuivi: TAction;
    actAddSuivi1: TMenuItem;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    vstMessages: TVirtualStringTree;
    actRunToCursor: TAction;
    Jusquaucurseur1: TMenuItem;
    vstSuivis: TVirtualStringTree;
    TabSheet3: TTabSheet;
    vstBreakpoints: TVirtualStringTree;
    procedure EScriptGutterClick(Sender: TObject; Button: TMouseButton; X, Y, Line: Integer; Mark: TSynEditMark);
    procedure EScriptGutterPaint(Sender: TObject; aLine, X, Y: Integer);
    procedure EScriptSpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);
    procedure EScriptStatusChange(Sender: TObject; Changes: TSynStatusChanges);
    procedure SearchFind1Execute(Sender: TObject);
    procedure SearchFindNext1Execute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure EditCut1Execute(Sender: TObject);
    procedure EditCopy1Execute(Sender: TObject);
    procedure EditPaste1Execute(Sender: TObject);
    procedure EditSelectAll1Execute(Sender: TObject);
    procedure EditUndo1Execute(Sender: TObject);
    procedure EditRedo1Execute(Sender: TObject);
    procedure EScriptReplaceText(Sender: TObject; const ASearch, AReplace: string; Line, Column: Integer; var Action: TSynReplaceAction);
    procedure PSScriptDebugger1Execute(Sender: TPSScript);
    procedure Button3Click(Sender: TObject);
    procedure actCompileExecute(Sender: TObject);
    procedure actRunExecute(Sender: TObject);
    procedure PSScriptDebugger1Compile(Sender: TPSScript);
    procedure PSScriptDebugger1Breakpoint(Sender: TObject; const FileName: string; Position, Row, Col: Cardinal);
    procedure PSScriptDebugger1Idle(Sender: TObject);
    procedure PSScriptDebugger1AfterExecute(Sender: TPSScript);
    procedure PSScriptDebugger1LineInfo(Sender: TObject; const FileName: string; Position, Row, Col: Cardinal);
    function PSScriptDebugger1NeedFile(Sender: TObject; const OrginFileName: string; var FileName, Output: string): Boolean;
    procedure actStepOverExecute(Sender: TObject);
    procedure actStepIntoExecute(Sender: TObject);
    procedure actResetExecute(Sender: TObject);
    procedure actDecompileExecute(Sender: TObject);
    procedure actBreakpointExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actAddSuiviExecute(Sender: TObject);
    procedure actRunToCursorExecute(Sender: TObject);
    procedure vstSuivisNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
    procedure vstSuivisEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vstSuivisInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstSuivisChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstSuivisGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vstSuivisPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure lbBreakpointsData(Control: TWinControl; Index: Integer; var Data: string);
    procedure vstMessagesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vstMessagesDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EScriptChange(Sender: TObject);
    procedure vstBreakpointsDblClick(Sender: TObject);
    procedure vstBreakpointsChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstBreakpointsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vstBreakpointsInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstBreakpointsPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure EScriptMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  private
    { Déclarations privées }
    FLastSearch, FLastReplace: string;
    FSearchOptions: TSynSearchOptions;
    FActiveLine, FRunToCursor, FErrorLine: Cardinal;
    FDebugPlugin: TDebugPlugin;
    procedure SetResultat(const Chaine: string);
    function Compile: Boolean;
    function Execute: Boolean;
    function GetVariableValue(const VarName: string; Actif: Boolean): string;
    procedure WMSyscommand(var msg: TWmSysCommand); message WM_SYSCOMMAND;
    function GetVar(const Name: string; out s: string): PIFVariant;
    procedure GoToPosition(Line, Char: Cardinal);
    procedure GoToMessage(Msg: TMessageInfo);
    procedure GoToBreakpoint(Msg: TBreakpointInfo);
    procedure ToggleBreakPoint(Line: Cardinal; Keep: Boolean);
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses Unit2, Unit3, Unit4, uPSUtils;

procedure TForm1.WMSyscommand(var msg: TWmSysCommand);
begin
  case (msg.CmdType and $FFF0) of
    SC_CLOSE: if not PSScriptDebugger1.Running then inherited;
    else
      inherited;
  end;
end;

procedure TForm1.SetResultat(const Chaine: string);
begin
  debugoutput.Output.Lines.Text := Chaine;
  Application.ProcessMessages;
end;

const
  imgGutterBREAK = 0;
  imgGutterBREAKVALID = 1;
  imgGutterBREAKINVAL = 2;
  imgGutterCOMPLINE = 3;
  imgGutterEXECLINECL = 4;
  imgGutterEXECLINEBP = 5;
  imgGutterEXECLINE = 6;
  imgGutterBREAKDISABLED = 7;

procedure TForm1.EScriptGutterClick(Sender: TObject; Button: TMouseButton; X, Y, Line: Integer; Mark: TSynEditMark);
begin
  if X <= EScript.Gutter.LeftOffset then
    ToggleBreakPoint(Line, False);
end;

procedure TForm1.EScriptGutterPaint(Sender: TObject; aLine, X, Y: Integer);
var
  IconIndex: Integer;
  i: Integer;
begin
  IconIndex := -1;
  i := FDebugPlugin.Breakpoints.IndexOf(aLine);
  if i <> -1 then
  begin
    if not PSScriptDebugger1.Running then
      if FDebugPlugin.Breakpoints[i].Active then
        IconIndex := imgGutterBREAK
      else
        IconIndex := imgGutterBREAKDISABLED
    else
    begin
      if FActiveLine = Cardinal(aLine) then
        IconIndex := imgGutterEXECLINEBP
      else if FDebugPlugin.Breakpoints[i].Active then
        IconIndex := imgGutterBREAKVALID
      else
        IconIndex := imgGutterBREAKDISABLED
    end;
  end
  else
  begin
    if (PSScriptDebugger1.Exec.DebugMode = dmPaused) and (FActiveLine = Cardinal(ALine)) then
      IconIndex := imgGutterEXECLINE;
  end;
  if IconIndex <> -1 then
    lstDebugImages.Draw(EScript.Canvas, X, Y, IconIndex);
end;

procedure TForm1.EScriptSpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);
var
  i: Integer;
begin
  i := FDebugPlugin.Breakpoints.IndexOf(Line);
  if Cardinal(Line) = FActiveLine then
  begin
    Special := True;
    FG := clWhite;
    BG := clNavy;
  end
  else if i <> -1 then
  begin
    Special := True;
    if FDebugPlugin.Breakpoints[i].Active then
    begin
      FG := clWhite;
      BG := clRed;
    end
    else
    begin
      FG := clRed;
      BG := clLime;
    end;
  end
  else if (FErrorLine > 0) and (Cardinal(Line) = FErrorLine) then
  begin
    Special := True;
    FG := clWhite;
    BG := clMaroon;
  end

  else
    Special := False;
end;

procedure TForm1.EScriptStatusChange(Sender: TObject; Changes: TSynStatusChanges);
begin
  if (scCaretX in Changes) or (scCaretY in Changes) then
  begin
    //    sbEditor.Panels[pnlEditorPos].Caption := Format('%d:%d', [EScript.CaretX, EScript.CaretY]);
  end;
  if (scModified in Changes) then
  begin
    //    FCurrentFile.Modified := EScript.Modified;
  end;
end;

procedure TForm1.SearchFind1Execute(Sender: TObject);
var
  dummyReplace: string;
begin
  if EScript.SelAvail and (EScript.BlockBegin.Line = EScript.BlockEnd.Line) then
  begin
    FLastSearch := EScript.SelText;
    Include(FSearchOptions, ssoSelectedOnly);
  end
  else
  begin
    FLastSearch := EScript.WordAtCursor;
    Exclude(FSearchOptions, ssoSelectedOnly);
  end;

  if Sender = SearchFind1 then
  begin
    // chercher
    Exclude(FSearchOptions, ssoReplace);
    Exclude(FSearchOptions, ssoReplaceAll);

    if not TForm2.Execute(FLastSearch, dummyReplace, FSearchOptions) then Exit;
  end
  else
  begin
    // remplacer
    Include(FSearchOptions, ssoReplace);
    Exclude(FSearchOptions, ssoReplaceAll);

    if not TForm2.Execute(FLastSearch, FLastReplace, FSearchOptions) then Exit;
  end;

  SearchFindNext1Execute(Sender);
end;

procedure TForm1.SearchFindNext1Execute(Sender: TObject);
begin
  if FLastSearch = '' then
    SearchFind1Execute(SearchFind1)
  else if EScript.SearchReplace(FLastSearch, FLastReplace, FSearchOptions) = 0 then
    ShowMEssage('Texte non trouvé');
end;

procedure TForm1.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
begin
  Handled := True;
  EditCut1.Enabled := EScript.SelAvail;
  EditCopy1.Enabled := EScript.SelAvail;
  EditPaste1.Enabled := EScript.CanPaste;
  EditUndo1.Enabled := EScript.CanUndo;
  EditRedo1.Enabled := EScript.CanRedo;
  actRun.Enabled := True; // FCompiled;
end;

procedure TForm1.EditCut1Execute(Sender: TObject);
begin
  EScript.CutToClipboard;
end;

procedure TForm1.EditCopy1Execute(Sender: TObject);
begin
  EScript.CopyToClipboard;
end;

procedure TForm1.EditPaste1Execute(Sender: TObject);
begin
  EScript.PasteFromClipboard;
end;

procedure TForm1.EditSelectAll1Execute(Sender: TObject);
begin
  EScript.SelectAll;
end;

procedure TForm1.EditUndo1Execute(Sender: TObject);
begin
  EScript.Undo;
end;

procedure TForm1.EditRedo1Execute(Sender: TObject);
begin
  EScript.Redo;
end;

procedure TForm1.EScriptReplaceText(Sender: TObject; const ASearch, AReplace: string; Line, Column: Integer; var Action: TSynReplaceAction);
begin
  case MessageDlg('Remplacer cette occurence ?', mtConfirmation, [mbYes, mbNo, mbCancel, mbYesToAll], 0) of
    mrYes: Action := raReplace;
    mrNo: Action := raSkip;
    mrCancel: Action := raCancel;
    mrYesToAll: Action := raReplaceAll;
  end;
end;

procedure TForm1.PSScriptDebugger1Execute(Sender: TPSScript);
var
  i: Integer;
begin
  PSScriptDebugger1.ClearBreakPoints;
  for i := 0 to Pred(FDebugPlugin.Breakpoints.Count) do
    with FDebugPlugin.Breakpoints[i] do
      if Active then
        PSScriptDebugger1.SetBreakPoint(PSScriptDebugger1.MainFileName, Line);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  actCompile.Execute;
  actRun.Execute;
end;

procedure TForm1.actCompileExecute(Sender: TObject);
begin
  if not PSScriptDebugger1.Running then
    Compile;
end;

procedure TForm1.actRunExecute(Sender: TObject);
begin
  if PSScriptDebugger1.Running then
  begin
    PSScriptDebugger1.Resume;
    FActiveLine := 0;
    EScript.Refresh;
  end
  else
  begin
    if Compile then
      Execute;
  end;
end;

function TForm1.Execute: Boolean;
begin
  debugoutput.Output.Clear;
  debugoutput.Show;
  PageControl1.ActivePage := TTabSheet(vstSuivis.Parent);
  if PSScriptDebugger1.Execute then
  begin
    //    AddMessage('Succesfully Execute');
    FErrorLine := 0;
    Result := True;
  end
  else
  begin
    FDebugPlugin.Messages.AddRuntimeErrorMessage(
      Format('%s (Bytecode %d:%d)', [PSScriptDebugger1.ExecErrorToString, PSScriptDebugger1.ExecErrorProcNo, PSScriptDebugger1.ExecErrorByteCodePosition]),
      PSScriptDebugger1.ExecErrorRow,
      PSScriptDebugger1.ExecErrorCol);
    FErrorLine := PSScriptDebugger1.ExecErrorRow;
    GoToMessage(FDebugPlugin.Messages.Last);
    Result := False;
    try
      PSScriptDebugger1.Exec.RaiseCurrentException;
    except
      on e: EPSException do Application.HandleException(nil);
      else
        raise;
    end;
  end;
end;

procedure TForm1.PSScriptDebugger1Compile(Sender: TPSScript);
begin
  PSScriptDebugger1.AddFunction(@GetPage, 'function GetPage(const url: string): string;');
  PSScriptDebugger1.AddMethod(Self, @TForm1.SetResultat, 'procedure SetHTML(const Chaine: string);');
  PSScriptDebugger1.AddFunction(@Format, 'function Format(const Format: string; const Args: array of const): string;');
  PSScriptDebugger1.AddFunction(@findInfo, 'function findInfo(const sDebut, sFin, sChaine, sDefault: string): string;');
  PSScriptDebugger1.AddFunction(@ShowMessage, 'procedure ShowMessage(const Msg: string);');
  PSScriptDebugger1.AddFunction(@PosEx, 'function PosEx(const SubStr, S: string; Offset: Cardinal): Integer;');
end;

procedure TForm1.PSScriptDebugger1Breakpoint(Sender: TObject; const FileName: string; Position, Row, Col: Cardinal);
begin
  FActiveLine := Row;
  if (FActiveLine < Cardinal(EScript.TopLine + 2)) or (FActiveLine > Cardinal(EScript.TopLine + EScript.LinesInWindow - 2)) then
  begin
    EScript.TopLine := FActiveLine - Cardinal(EScript.LinesInWindow div 2);
  end;
  EScript.CaretY := FActiveLine;
  EScript.CaretX := 1;

  EScript.Refresh;
  FDebugPlugin.Watches.UpdateView;
end;

procedure TForm1.PSScriptDebugger1Idle(Sender: TObject);
begin
  Application.HandleMessage;
end;

procedure TForm1.PSScriptDebugger1AfterExecute(Sender: TPSScript);
begin
  FActiveLine := 0;
  FRunToCursor := 0;
  PSScriptDebugger1.ClearBreakPoints;
  EScript.Refresh;
  vstSuivis.Invalidate;
end;

procedure TForm1.PSScriptDebugger1LineInfo(Sender: TObject; const FileName: string; Position, Row, Col: Cardinal);
begin
  if (Row = FRunToCursor) and (PSScriptDebugger1.Exec.DebugMode = dmRun) then
    PSScriptDebugger1.Pause;

  if PSScriptDebugger1.Exec.DebugMode <> dmRun then
  begin
    FActiveLine := Row;
    if (FActiveLine < Cardinal(EScript.TopLine + 2)) or (FActiveLine > Cardinal(EScript.TopLine + EScript.LinesInWindow - 2)) then
    begin
      EScript.TopLine := FActiveLine - Cardinal(EScript.LinesInWindow div 2);
    end;
    EScript.CaretY := FActiveLine;
    EScript.CaretX := 1;

    EScript.Refresh;
    FDebugPlugin.Watches.UpdateView;
  end;
end;

function TForm1.PSScriptDebugger1NeedFile(Sender: TObject; const OrginFileName: string; var FileName, Output: string): Boolean;
var
  path: string;
  f: TFileStream;
begin
  //  if aFile <> '' then
  //    Path := ExtractFilePath(aFile)
  //  else
  Path := ExtractFilePath(ParamStr(0));
  Path := Path + FileName;
  try
    F := TFileStream.Create(Path, fmOpenRead or fmShareDenyWrite);
  except
    Result := False;
    Exit;
  end;
  try
    SetLength(Output, f.Size);
    f.Read(Output[1], Length(Output));
  finally
    f.Free;
  end;
  Result := True;
end;

procedure TForm1.actStepOverExecute(Sender: TObject);
begin
  if PSScriptDebugger1.Exec.Status = isRunning then
    PSScriptDebugger1.StepOver
  else
  begin
    if Compile then
    begin
      PSScriptDebugger1.StepInto;
      Execute;
    end;
  end;
end;

procedure TForm1.actStepIntoExecute(Sender: TObject);
begin
  if PSScriptDebugger1.Exec.Status = isRunning then
    PSScriptDebugger1.StepInto
  else
  begin
    if Compile then
    begin
      PSScriptDebugger1.StepInto;
      Execute;
    end;
  end;
end;

procedure TForm1.actResetExecute(Sender: TObject);
begin
  if PSScriptDebugger1.Exec.Status = isRunning then
    PSScriptDebugger1.Stop;
end;

function TForm1.Compile: Boolean;
var
  i: Longint;
begin
  PSScriptDebugger1.Script.Assign(EScript.Lines);
  Result := PSScriptDebugger1.Compile;
  FDebugPlugin.Messages.Clear;
  for i := 0 to PSScriptDebugger1.CompilerMessageCount - 1 do
    with PSScriptDebugger1.CompilerMessages[i] do
      if ClassType = TPSPascalCompilerWarning then
        FDebugPlugin.Messages.AddCompileErrorMessage(ShortMessageToString, tmWarning, Row, Col)
      else if ClassType = TPSPascalCompilerHint then
        FDebugPlugin.Messages.AddCompileErrorMessage(ShortMessageToString, tmHint, Row, Col)
      else if ClassType = TPSPascalCompilerError then
        FDebugPlugin.Messages.AddCompileErrorMessage(ShortMessageToString, tmError, Row, Col)
      else
        FDebugPlugin.Messages.AddCompileErrorMessage(ShortMessageToString, tmUnknown, Row, Col);

  if FDebugPlugin.Messages.Count > 0 then
    GoToMessage(FDebugPlugin.Messages[0]);
end;

procedure TForm1.actDecompileExecute(Sender: TObject);
var
  s: string;
begin
  if Compile then
  begin
    PSScriptDebugger1.GetCompiled(s);
    IFPS3DataToText(s, s);
    debugoutput.output.Lines.Text := s;
    debugoutput.Visible := True;
  end;
end;

procedure TForm1.actBreakpointExecute(Sender: TObject);
begin
  ToggleBreakPoint(EScript.CaretY, False);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FDebugPlugin := TDebugPlugin.Create(EScript);
  FDebugPlugin.Watches.View := vstSuivis;
  FDebugPlugin.Messages.View := vstMessages;
  FDebugPlugin.Breakpoints.View := vstBreakpoints;
  // force à reprendre les params de delphi s'il est installé sur la machine
  SynPasSyn1.UseUserSettings(0);
end;

function TForm1.GetVar(const Name: string; out s: string): PIFVariant;
var
  i: Longint;
  s1: string;
begin
  s := Uppercase(Name);
  if pos('.', s) > 0 then
  begin
    s1 := copy(s, 1, pos('.', s) - 1);
    delete(s, 1, pos('.', Name));
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
    begin
      if UpperCase(Exec.CurrentProcVars[i]) = s1 then
      begin
        Result := Exec.GetProcVar(i);
        break;
      end;
    end;
    if Result = nil then
    begin
      for i := 0 to Exec.CurrentProcParams.Count - 1 do
      begin
        if Uppercase(Exec.CurrentProcParams[i]) = s1 then
        begin
          Result := Exec.GetProcParam(i);
          break;
        end;
      end;
    end;
    if Result = nil then
    begin
      for i := 0 to Exec.GlobalVarNames.Count - 1 do
      begin
        if Uppercase(Exec.GlobalVarNames[i]) = s1 then
        begin
          Result := Exec.GetGlobalVar(i);
          break;
        end;
      end;
    end;
  end;
end;

function TForm1.GetVariableValue(const VarName: string; Actif: Boolean): string;
var
  pv: PIFVariant;
  Prefix: string;
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

procedure TForm1.actAddSuiviExecute(Sender: TObject);
begin
  FDebugPlugin.Watches.AddWatch(EScript.WordAtCursor);
end;

procedure TForm1.actRunToCursorExecute(Sender: TObject);
begin
  FRunToCursor := EScript.CaretY;
  actRun.Execute;
end;

procedure TForm1.vstSuivisNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
begin
  FDebugPlugin.Watches[Node.Index].Name := NewText;
  FDebugPlugin.Watches.View.InvalidateNode(Node);
end;

procedure TForm1.vstSuivisEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := Column = 0;
end;

procedure TForm1.vstSuivisInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  Node.CheckType := ctCheckBox;
  if FDebugPlugin.Watches[Node.Index].Active then
    Node.CheckState := csCheckedNormal
  else
    Node.CheckState := csUncheckedNormal;
end;

procedure TForm1.vstSuivisChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  FDebugPlugin.Watches[Node.Index].Active := Node.CheckState = csCheckedNormal;
  FDebugPlugin.Watches.View.InvalidateNode(Node);
end;

procedure TForm1.vstSuivisGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
begin
  if Column = -1 then Column := 0;
  with FDebugPlugin.Watches[Node.Index] do
    case Column of
      0: CellText := Name;
      1: CellText := GetVariableValue(Name, Active);
    end;
end;

procedure TForm1.vstSuivisPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
begin
  if Node.CheckState = csCheckedNormal then
    TargetCanvas.Font.Color := clWindowText
  else
    TargetCanvas.Font.Color := clGrayText;
end;

procedure TForm1.lbBreakpointsData(Control: TWinControl; Index: Integer; var Data: string);
begin
  Data := Format('Ligne %d', [FDebugPlugin.Breakpoints[Index]]);
end;

procedure TForm1.GoToMessage(Msg: TMessageInfo);
begin
  GoToPosition(Msg.Line, Msg.Char);
  PageControl1.ActivePage := TTabSheet(vstMessages.Parent);
end;

procedure TForm1.vstMessagesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
begin
  if Column = -1 then Column := 0;
  with FDebugPlugin.Messages[Node.Index] do
    case Column of
      0:
        case Category of
          cmInfo: CellText := 'Information';
          cmCompileError: CellText := 'Compilation';
          cmRuntimeError: CellText := 'Exécution';
          else
            CellText := '';
        end;
      1: CellText := TypeMessage;
      2: CellText := Text;
    end;
end;

procedure TForm1.vstMessagesDblClick(Sender: TObject);
begin
  GoToMessage(FDebugPlugin.Messages.Current);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FDebugPlugin.Free;
end;

procedure TForm1.EScriptChange(Sender: TObject);
begin
  if FErrorLine > 0 then
  begin
    EScript.InvalidateLine(FErrorLine);
    EScript.InvalidateGutterLine(FErrorLine);
    FErrorLine := 0;
  end;
end;

procedure TForm1.vstBreakpointsDblClick(Sender: TObject);
begin
  GoToBreakpoint(FDebugPlugin.Breakpoints.Current);
end;

procedure TForm1.GoToBreakpoint(Msg: TBreakpointInfo);
begin
  GoToPosition(Msg.Line, 0);
  PageControl1.ActivePage := TTabSheet(vstBreakpoints.Parent);
end;

procedure TForm1.GoToPosition(Line, Char: Cardinal);
begin
  if (Line < Cardinal(EScript.TopLine + 2)) or (Line > Cardinal(EScript.TopLine + EScript.LinesInWindow - 2)) then
    EScript.TopLine := Line - Cardinal(EScript.LinesInWindow div 2);

  EScript.CaretY := Line;
  EScript.CaretX := Char;
  EScript.InvalidateGutterLine(Line);
  EScript.InvalidateLine(Line);
  EScript.SetFocus;
end;

procedure TForm1.vstBreakpointsChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  ToggleBreakPoint(FDebugPlugin.Breakpoints[Node.Index].Line, True);
  FDebugPlugin.Breakpoints.View.InvalidateNode(Node);
end;

procedure TForm1.vstBreakpointsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
begin
  if Column = -1 then Column := 0;
  with FDebugPlugin.Breakpoints[Node.Index] do
    case Column of
      0: CellText := 'Ligne ' + IntToStr(Line);
    end;
end;

procedure TForm1.vstBreakpointsInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  Node.CheckType := ctCheckBox;
  if FDebugPlugin.Breakpoints[Node.Index].Active then
    Node.CheckState := csCheckedNormal
  else
    Node.CheckState := csUncheckedNormal;
end;

procedure TForm1.vstBreakpointsPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
begin
  if Node.CheckState = csCheckedNormal then
    TargetCanvas.Font.Color := clWindowText
  else
    TargetCanvas.Font.Color := clGrayText;
end;

procedure TForm1.ToggleBreakPoint(Line: Cardinal; Keep: Boolean);
var
  i: Integer;
begin
  i := FDebugPlugin.Breakpoints.IndexOf(Line);
  if i = -1 then // nouveau point d'arrêt
  begin
    FDebugPlugin.Breakpoints.AddBreakpoint(Line);
    if PSScriptDebugger1.Running then
      PSScriptDebugger1.SetBreakPoint(PSScriptDebugger1.MainFileName, Line);
  end
  else if Keep then // changement d'état du point d'arrêt
  begin
    FDebugPlugin.Breakpoints[i].Active := not FDebugPlugin.Breakpoints[i].Active;
    if PSScriptDebugger1.Running then
      if FDebugPlugin.Breakpoints[i].Active then
        PSScriptDebugger1.SetBreakPoint(PSScriptDebugger1.MainFileName, Line)
      else
        PSScriptDebugger1.ClearBreakPoint(PSScriptDebugger1.MainFileName, Line);
  end
  else
  begin // suppression du point d'arrêt
    FDebugPlugin.Breakpoints.Delete(i);
    if PSScriptDebugger1.Running then
      PSScriptDebugger1.ClearBreakPoint(PSScriptDebugger1.MainFileName, Line);
  end;
end;

procedure TForm1.EScriptMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
const
  WordVar: string = '';
var
  pv: PIFVariant;
  Prefix: string;
  s: string;
begin
  if not PSScriptDebugger1.Running then
  begin
    WordVar := '';
    EScript.ShowHint := False;
    Exit;
  end;
  s := EScript.WordAtMouse;
  if s <> WordVar then Application.CancelHint;
  WordVar := s;

  pv := GetVar(WordVar, Prefix);
  if pv = nil then
  begin
    EScript.Hint := '';
    EScript.ShowHint := False;
  end
  else
  begin
    EScript.Hint := PSVariantToString(NewTPSVariantIFC(pv, False), Prefix);
    EScript.ShowHint := True;
  end;
end;

end.

