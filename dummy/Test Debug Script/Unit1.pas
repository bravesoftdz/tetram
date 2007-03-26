unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SynEditHighlighter, SynHighlighterPas, SynEdit, ImgList, StrUtils,
  uPSComponent, uPSDebugger, SynEditMiscClasses, SynEditSearch, StdActns, ActnList, uPSDisassembly,
  Menus, SynEditTypes, Unit5, ComCtrls, uPSCompiler,
  uPSRuntime, VirtualTrees, StdCtrls, ExtCtrls, uPSComponent_StdCtrls,
  uPSComponent_Controls, uPSComponent_Forms, uPSComponent_DB,
  uPSComponent_COM, uPSComponent_Default;

type
  TSynDebugPlugin = class(TSynEditPlugin)
  private
    FDebug: TDebugInfos;
  protected
    procedure AfterPaint(ACanvas: TCanvas; const AClip: TRect; FirstLine, LastLine: Integer); override;
    procedure LinesInserted(FirstLine, Count: Integer); override;
    procedure LinesDeleted(FirstLine, Count: Integer); override;
  public
    constructor Create(AOwner: TCustomSynEdit; Debug: TDebugInfos); reintroduce;
  end;

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
    pcScripts: TPageControl;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    seScript1: TSynEdit;
    seScript2: TSynEdit;
    TabSheet6: TTabSheet;
    Output: TMemo;
    PSImport_DateUtils1: TPSImport_DateUtils;
    PSImport_Classes1: TPSImport_Classes;
    PSImport_ComObj1: TPSImport_ComObj;
    PSImport_DB1: TPSImport_DB;
    PSImport_Forms1: TPSImport_Forms;
    PSImport_Controls1: TPSImport_Controls;
    PSImport_StdCtrls1: TPSImport_StdCtrls;
    PSDllPlugin1: TPSDllPlugin;
    procedure seScript1GutterClick(Sender: TObject; Button: TMouseButton; X, Y, Line: Integer; Mark: TSynEditMark);
    procedure seScript1GutterPaint(Sender: TObject; aLine, X, Y: Integer);
    procedure seScript1SpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);
    procedure seScript1StatusChange(Sender: TObject; Changes: TSynStatusChanges);
    procedure SearchFind1Execute(Sender: TObject);
    procedure SearchFindNext1Execute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure EditCut1Execute(Sender: TObject);
    procedure EditCopy1Execute(Sender: TObject);
    procedure EditPaste1Execute(Sender: TObject);
    procedure EditSelectAll1Execute(Sender: TObject);
    procedure EditUndo1Execute(Sender: TObject);
    procedure EditRedo1Execute(Sender: TObject);
    procedure seScript1ReplaceText(Sender: TObject; const ASearch, AReplace: string; Line, Column: Integer; var Action: TSynReplaceAction);
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
    procedure vstMessagesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vstMessagesDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure seScript1Change(Sender: TObject);
    procedure vstBreakpointsDblClick(Sender: TObject);
    procedure vstBreakpointsChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstBreakpointsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vstBreakpointsInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstBreakpointsPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure seScript1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  private
    { Déclarations privées }
    FLastSearch, FLastReplace: string;
    FSearchOptions: TSynSearchOptions;
    FActiveLine, FRunToCursor, FErrorLine: Cardinal;
    FActiveFile, FRunToCursorFile, FErrorFile: string;
    FDebugPlugin: TDebugInfos;
    SynDebug1, SynDebug2: TSynDebugPlugin;
    FCompiled: Boolean;
    procedure SetResultat(const Chaine: string);
    function Compile: Boolean;
    function Execute: Boolean;
    function GetVariableValue(const VarName: string; Actif: Boolean): string;
    procedure WMSyscommand(var msg: TWmSysCommand); message WM_SYSCOMMAND;
    function GetVar(const Name: string; out s: string): PIFVariant;
    procedure GoToPosition(Editor: TSynEdit; Line, Char: Cardinal);
    procedure GoToMessage(Msg: TMessageInfo);
    procedure GoToBreakpoint(Msg: TBreakpointInfo);
    procedure ToggleBreakPoint(const Script: string; Line: Cardinal; Keep: Boolean);

    function GetScriptName(Editor: TSynEdit): string;
    function GetScript(const Fichier: string): TSynEdit;
    function GetActiveScriptName: string;
    function GetActiveScript: TSynEdit;
    function CorrectScriptName(const Fichier: string): string;
    function TranslatePositionEx(out Proc, Position: Cardinal; Row: Cardinal; Fn: string): Boolean;
    procedure SetCompiled(const Value: Boolean);
    function GetScriptLines(const Fichier: string; out Output: string): Boolean;
  public
    { Déclarations publiques }
    property Compiled: Boolean read FCompiled write SetCompiled;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses Unit2, Unit4, uPSUtils;

procedure TSynDebugPlugin.AfterPaint(ACanvas: TCanvas; const AClip: TRect; FirstLine, LastLine: Integer);
begin
  inherited;
end;

constructor TSynDebugPlugin.Create(AOwner: TCustomSynEdit; Debug: TDebugInfos);
begin
  inherited Create(AOwner);
  FDebug := Debug;
end;

procedure TSynDebugPlugin.LinesDeleted(FirstLine, Count: Integer);
var
  i: Integer;
begin
  inherited;
  for i := Pred(FDebug.Breakpoints.Count) downto 0 do
    if FDebug.Breakpoints[i].Line in [FirstLine..FirstLine + Count] then
      FDebug.Breakpoints.Delete(i)
    else if FDebug.Breakpoints[i].Line > Cardinal(FirstLine) then
    begin
      Editor.InvalidateGutterLine(FDebug.Breakpoints[i].Line);
      FDebug.Breakpoints[i].Line := FDebug.Breakpoints[i].Line - Cardinal(Count);
    end;

  for i := Pred(FDebug.Messages.Count) downto 0 do
    if FDebug.Messages[i].Line in [FirstLine..FirstLine + Count] then
      FDebug.Messages.Delete(i)
    else if FDebug.Messages[i].Line > Cardinal(FirstLine) then
      FDebug.Messages[i].Line := FDebug.Messages[i].Line - Cardinal(Count);
end;

procedure TSynDebugPlugin.LinesInserted(FirstLine, Count: Integer);
var
  i: Integer;
begin
  inherited;
  for i := 0 to FDebug.Breakpoints.Count - 1 do
    if FDebug.Breakpoints[i].Line >= Cardinal(FirstLine) then
    begin
      Editor.InvalidateGutterLine(FDebug.Breakpoints[i].Line);
      FDebug.Breakpoints[i].Line := FDebug.Breakpoints[i].Line + Cardinal(Count);
    end;
  for i := 0 to FDebug.Messages.Count - 1 do
    if FDebug.Messages[i].Line >= Cardinal(FirstLine) then
    begin
      Editor.InvalidateGutterLine(FDebug.Messages[i].Line);
      FDebug.Messages[i].Line := FDebug.Messages[i].Line + Cardinal(Count);
    end;
end;

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
  Output.Lines.Text := Chaine;
  if (PageControl1.ActivePage <> TTabSheet(vstSuivis.Parent)) or (FDebugPlugin.Watches.CountActive = 0) then
    PageControl1.ActivePage := TTabSheet(Output.Parent);
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

procedure TForm1.seScript1GutterClick(Sender: TObject; Button: TMouseButton; X, Y, Line: Integer; Mark: TSynEditMark);
begin
  if X <= TSynEdit(Sender).Gutter.LeftOffset then
    ToggleBreakPoint(GetScriptName(TSynEdit(Sender)), Line, False);
end;

procedure TForm1.seScript1GutterPaint(Sender: TObject; aLine, X, Y: Integer);
var
  IconIndex: Integer;
  i: Integer;
  Script: string;
  Proc, Pos: Cardinal;
begin
  Script := GetScriptName(TSynEdit(Sender));
  IconIndex := -1;
  i := FDebugPlugin.Breakpoints.IndexOf(Script, aLine);
  if i <> -1 then
  begin
    if not PSScriptDebugger1.Running then
      if FDebugPlugin.Breakpoints[i].Active then
        IconIndex := imgGutterBREAK
      else
        IconIndex := imgGutterBREAKDISABLED
    else
    begin
      if (Cardinal(aLine) = FActiveLine) and SameText(FActiveFile, Script) then
        IconIndex := imgGutterEXECLINEBP
      else if FDebugPlugin.Breakpoints[i].Active then
        IconIndex := imgGutterBREAKVALID
      else
        IconIndex := imgGutterBREAKDISABLED
    end;
  end
  else
  begin
    if (PSScriptDebugger1.Exec.DebugMode = dmPaused) and (Cardinal(aLine) = FActiveLine) and SameText(FActiveFile, Script) then
      IconIndex := imgGutterEXECLINE;
  end;

  if Compiled then
    if TranslatePositionEx(Proc, Pos, aLine, Script) then
      case IconIndex of
        -1: IconIndex := imgGutterCOMPLINE;
        // imgGutterBREAKDISABLED: IconIndex := imgGutterCOMPLINE;
        // imgGutterBREAK: IconIndex := imgGutterCOMPLINE;
        // imgGutterBREAKVALID: IconIndex := imgGutterCOMPLINE;
        imgGutterEXECLINE: IconIndex := imgGutterEXECLINECL;
      end
    else
      case IconIndex of
        imgGutterBREAK: IconIndex := imgGutterBREAKINVAL;
        imgGutterBREAKVALID: IconIndex := imgGutterBREAKINVAL;
      end;

  if IconIndex <> -1 then
    lstDebugImages.Draw(TSynEdit(Sender).Canvas, X, Y, IconIndex);
end;

procedure TForm1.seScript1SpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);
var
  i: Integer;
  Script: string;
  Proc, Pos: Cardinal;
begin
  Script := GetScriptName(TSynEdit(Sender));
  i := FDebugPlugin.Breakpoints.IndexOf(Script, Line);

  if (Cardinal(Line) = FActiveLine) and SameText(FActiveFile, Script) then
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
      if Compiled and not TranslatePositionEx(Proc, Pos, Line, Script) then
      begin
        FG := clWhite;
        BG := clOlive;
      end
      else
      begin
        FG := clWhite;
        BG := clRed;
      end;
    end
    else
    begin
      FG := clRed;
      BG := clLime;
    end;
  end
  else if (FErrorLine > 0) and (Cardinal(Line) = FErrorLine) and SameText(FErrorFile, Script) then
  begin
    Special := True;
    FG := clWhite;
    BG := clMaroon;
  end

  else
    Special := False;
end;

procedure TForm1.seScript1StatusChange(Sender: TObject; Changes: TSynStatusChanges);
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
  if GetActiveScript.SelAvail and (GetActiveScript.BlockBegin.Line = GetActiveScript.BlockEnd.Line) then
  begin
    FLastSearch := GetActiveScript.SelText;
    Include(FSearchOptions, ssoSelectedOnly);
  end
  else
  begin
    FLastSearch := GetActiveScript.WordAtCursor;
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
  else if GetActiveScript.SearchReplace(FLastSearch, FLastReplace, FSearchOptions) = 0 then
    ShowMessage('Texte non trouvé');
end;

procedure TForm1.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
begin
  Handled := True;
  EditCut1.Enabled := GetActiveScript.SelAvail;
  EditCopy1.Enabled := GetActiveScript.SelAvail;
  EditPaste1.Enabled := GetActiveScript.CanPaste;
  EditUndo1.Enabled := GetActiveScript.CanUndo;
  EditRedo1.Enabled := GetActiveScript.CanRedo;
  actRun.Enabled := True; // Compiled;
end;

procedure TForm1.EditCut1Execute(Sender: TObject);
begin
  GetActiveScript.CutToClipboard;
end;

procedure TForm1.EditCopy1Execute(Sender: TObject);
begin
  GetActiveScript.CopyToClipboard;
end;

procedure TForm1.EditPaste1Execute(Sender: TObject);
begin
  GetActiveScript.PasteFromClipboard;
end;

procedure TForm1.EditSelectAll1Execute(Sender: TObject);
begin
  GetActiveScript.SelectAll;
end;

procedure TForm1.EditUndo1Execute(Sender: TObject);
begin
  GetActiveScript.Undo;
end;

procedure TForm1.EditRedo1Execute(Sender: TObject);
begin
  GetActiveScript.Redo;
end;

procedure TForm1.seScript1ReplaceText(Sender: TObject; const ASearch, AReplace: string; Line, Column: Integer; var Action: TSynReplaceAction);
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
        if Fichier = PSScriptDebugger1.MainFileName then
          PSScriptDebugger1.SetBreakPoint('', Line)
        else
          PSScriptDebugger1.SetBreakPoint(Fichier, Line);
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
    FActiveFile := '';
    GetActiveScript.Refresh;
  end
  else
  begin
    if Compile then
      Execute;
  end;
end;

function TForm1.Execute: Boolean;
begin
  Output.Clear;
  PageControl1.ActivePage := TTabSheet(vstSuivis.Parent);
  if PSScriptDebugger1.Execute then
  begin
    //    AddMessage('Succesfully Execute');
    FErrorLine := 0;
    Result := True;
  end
  else
  begin
    FErrorLine := PSScriptDebugger1.ExecErrorRow;
    FErrorFile := CorrectScriptName(PSScriptDebugger1.ExecErrorFileName);
    FDebugPlugin.Messages.AddRuntimeErrorMessage(
      FErrorFile,
      Format('%s (Bytecode %d:%d)', [PSScriptDebugger1.ExecErrorToString, PSScriptDebugger1.ExecErrorProcNo, PSScriptDebugger1.ExecErrorByteCodePosition]),
      PSScriptDebugger1.ExecErrorRow,
      PSScriptDebugger1.ExecErrorCol);
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
  FActiveFile := CorrectScriptName(FileName);
  GoToPosition(GetScript(FActiveFile), FActiveLine, 1);
  FDebugPlugin.Watches.UpdateView;
end;

procedure TForm1.PSScriptDebugger1Idle(Sender: TObject);
begin
  Application.HandleMessage;
end;

procedure TForm1.PSScriptDebugger1AfterExecute(Sender: TPSScript);
begin
  FActiveLine := 0;
  FActiveFile := '';
  FRunToCursor := 0;
  FRunToCursorFile := '';
  PSScriptDebugger1.ClearBreakPoints;
  GetActiveScript.Refresh;
  vstSuivis.Invalidate;
  PageControl1.ActivePage := TTabSheet(Output.Parent);
end;

procedure TForm1.PSScriptDebugger1LineInfo(Sender: TObject; const FileName: string; Position, Row, Col: Cardinal);
begin
  if (Row = FRunToCursor) and SameText(CorrectScriptName(FileName), FRunToCursorFile) and (PSScriptDebugger1.Exec.DebugMode = dmRun) then
    PSScriptDebugger1.Pause;

  if PSScriptDebugger1.Exec.DebugMode <> dmRun then
  begin
    FActiveLine := Row;
    FActiveFile := CorrectScriptName(FileName);
    GoToPosition(GetScript(FActiveFile), FActiveLine, 1);
    FDebugPlugin.Watches.UpdateView;
  end;
end;

function TForm1.PSScriptDebugger1NeedFile(Sender: TObject; const OrginFileName: string; var FileName, Output: string): Boolean;
begin
  Result := GetScriptLines(FileName, Output);
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
  PSScriptDebugger1.Script.Assign(GetScript(PSScriptDebugger1.MainFileName).Lines);
  Result := PSScriptDebugger1.Compile;
  FDebugPlugin.Messages.Clear;
  for i := 0 to PSScriptDebugger1.CompilerMessageCount - 1 do
    with PSScriptDebugger1.CompilerMessages[i] do
      if ClassType = TPSPascalCompilerWarning then
        FDebugPlugin.Messages.AddCompileErrorMessage(ModuleName, ShortMessageToString, tmWarning, Row, Col)
      else if ClassType = TPSPascalCompilerHint then
        FDebugPlugin.Messages.AddCompileErrorMessage(ModuleName, ShortMessageToString, tmHint, Row, Col)
      else if ClassType = TPSPascalCompilerError then
        FDebugPlugin.Messages.AddCompileErrorMessage(ModuleName, ShortMessageToString, tmError, Row, Col)
      else
        FDebugPlugin.Messages.AddCompileErrorMessage(ModuleName, ShortMessageToString, tmUnknown, Row, Col);

  if FDebugPlugin.Messages.Count > 0 then
    GoToMessage(FDebugPlugin.Messages[0]);
  Compiled := Result;
end;

procedure TForm1.actDecompileExecute(Sender: TObject);
var
  s: string;
begin
  if Compile then
  begin
    PSScriptDebugger1.GetCompiled(s);
    IFPS3DataToText(s, s);
    output.Lines.Text := s;
    PageControl1.ActivePage := TTabSheet(Output.Parent);
  end;
end;

procedure TForm1.actBreakpointExecute(Sender: TObject);
begin
  ToggleBreakPoint(GetActiveScriptName, GetActiveScript.CaretY, False);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
  FDebugPlugin := TDebugInfos.Create;
  FDebugPlugin.OnGetScript := GetScript;
  FDebugPlugin.Watches.View := vstSuivis;
  FDebugPlugin.Messages.View := vstMessages;
  FDebugPlugin.Breakpoints.View := vstBreakpoints;
  SynDebug1 := TSynDebugPlugin.Create(seScript1, FDebugPlugin);
  SynDebug2 := TSynDebugPlugin.Create(seScript2, FDebugPlugin);

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
  FDebugPlugin.Watches.AddWatch(GetActiveScript.WordAtCursor);
end;

procedure TForm1.actRunToCursorExecute(Sender: TObject);
begin
  FRunToCursor := GetActiveScript.CaretY;
  FRunToCursorFile := GetActiveScriptName;
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

procedure TForm1.GoToMessage(Msg: TMessageInfo);
begin
  GoToPosition(GetScript(Msg.Fichier), Msg.Line, Msg.Char);
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
      2: CellText := Fichier;
      3: CellText := Text;
    end;
end;

procedure TForm1.vstMessagesDblClick(Sender: TObject);
begin
  GoToMessage(FDebugPlugin.Messages.Current);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  SynDebug1.Free; // doit être libéré avant FDebugPlugin
  SynDebug2.Free; // doit être libéré avant FDebugPlugin
  FDebugPlugin.Free;
end;

procedure TForm1.seScript1Change(Sender: TObject);
begin
  Compiled := False;
  if (FErrorLine > 0) then
  begin
    GetScript(FErrorFile).InvalidateLine(FErrorLine);
    GetScript(FErrorFile).InvalidateGutterLine(FErrorLine);
    FErrorLine := 0;
    FErrorFile := '';
  end;
end;

procedure TForm1.vstBreakpointsDblClick(Sender: TObject);
begin
  GoToBreakpoint(FDebugPlugin.Breakpoints.Current);
end;

procedure TForm1.GoToBreakpoint(Msg: TBreakpointInfo);
begin
  GoToPosition(GetScript(Msg.Fichier), Msg.Line, 0);
  PageControl1.ActivePage := TTabSheet(vstBreakpoints.Parent);
end;

procedure TForm1.GoToPosition(Editor: TSynEdit; Line, Char: Cardinal);
begin
  if (Line < Cardinal(Editor.TopLine + 2)) or (Line > Cardinal(Editor.TopLine + Editor.LinesInWindow - 2)) then
    Editor.TopLine := Line - Cardinal(Editor.LinesInWindow div 2);

  Editor.CaretY := Line;
  Editor.CaretX := Char;
  Editor.Invalidate; // Line et GutterLine sont insuffisants pour certains cas
  pcScripts.ActivePage := TTabSheet(Editor.Parent);
  Editor.SetFocus;
end;

procedure TForm1.vstBreakpointsChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  with FDebugPlugin.Breakpoints[Node.Index] do
    ToggleBreakPoint(Fichier, Line, True);
  FDebugPlugin.Breakpoints.View.InvalidateNode(Node);
end;

procedure TForm1.vstBreakpointsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
begin
  if Column = -1 then Column := 0;
  with FDebugPlugin.Breakpoints[Node.Index] do
    case Column of
      0: CellText := 'Ligne ' + IntToStr(Line);
      1: CellText := Fichier;
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

procedure TForm1.ToggleBreakPoint(const Script: string; Line: Cardinal; Keep: Boolean);
var
  i: Integer;
begin
  i := FDebugPlugin.Breakpoints.IndexOf(Script, Line);
  if i = -1 then // nouveau point d'arrêt
  begin
    FDebugPlugin.Breakpoints.AddBreakpoint(Script, Line);
    if PSScriptDebugger1.Running then
      if Script = PSScriptDebugger1.MainFileName then
        PSScriptDebugger1.SetBreakPoint('', Line)
      else
        PSScriptDebugger1.SetBreakPoint(Script, Line);
  end
  else if Keep then // changement d'état du point d'arrêt
  begin
    FDebugPlugin.Breakpoints[i].Active := not FDebugPlugin.Breakpoints[i].Active;
    if PSScriptDebugger1.Running then
      if FDebugPlugin.Breakpoints[i].Active then
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
    FDebugPlugin.Breakpoints.Delete(i);
    if PSScriptDebugger1.Running then
      if Script = PSScriptDebugger1.MainFileName then
        PSScriptDebugger1.ClearBreakPoint('', Line)
      else
        PSScriptDebugger1.ClearBreakPoint(Script, Line);
  end;
end;

procedure TForm1.seScript1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
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
    GetActiveScript.ShowHint := False;
    Exit;
  end;
  s := GetActiveScript.WordAtMouse;
  if s <> WordVar then Application.CancelHint;
  WordVar := s;

  pv := GetVar(WordVar, Prefix);
  if pv = nil then
  begin
    GetActiveScript.Hint := '';
    GetActiveScript.ShowHint := False;
  end
  else
  begin
    GetActiveScript.Hint := PSVariantToString(NewTPSVariantIFC(pv, False), Prefix);
    GetActiveScript.ShowHint := True;
  end;
end;

function TForm1.GetActiveScriptName: string;
begin
  Result := pcScripts.ActivePage.Caption;
end;

function TForm1.GetActiveScript: TSynEdit;
begin
  Result := TSynEdit(pcScripts.ActivePage.Controls[0]);
end;

function TForm1.GetScriptName(Editor: TSynEdit): string;
begin
  Result := TTabSheet(Editor.Parent).Caption;
end;

function TForm1.GetScript(const Fichier: string): TSynEdit;
var
  i: Integer;
  s: string;
begin
  if Fichier = '' then
    s := PSScriptDebugger1.MainFileName
  else
    s := Fichier;
  for i := 0 to Pred(pcScripts.PageCount) do
    with pcScripts.Pages[i] do
      if SameText(Caption, s) then
      begin
        Result := TSynEdit(Controls[0]);
        Exit;
      end;
  Result := nil;
end;

function TForm1.CorrectScriptName(const Fichier: string): string;
begin
  if Fichier = '' then
    Result := PSScriptDebugger1.MainFileName
  else
    Result := Fichier;
end;

type
  PPositionData = ^TPositionData;
  TPositionData = packed record
    FileName: string;
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

function TForm1.TranslatePositionEx(out Proc, Position: Cardinal; Row: Cardinal; Fn: string): Boolean;
var
  i, j: LongInt;
  fi: PFunctionInfo;
  pt: TIfList;
  r: PPositionData;
begin
  if Fn = PSScriptDebugger1.MainFileName then Fn := '';

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
      if not SameText(r^.FileName, Fn) then Continue;
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

procedure TForm1.SetCompiled(const Value: Boolean);
begin
  FCompiled := Value;
  GetActiveScript.Invalidate;
end;

function TForm1.GetScriptLines(const Fichier: string; out Output: string): Boolean;
var
  path: string;
  f: TFileStream;
  Editor: TSynEdit;
begin
  Editor := GetScript(Fichier);
  if Assigned(Editor) then
  begin
    Output := Editor.Lines.Text;
    Result := True;
    Exit;
  end;

  //  if aFile <> '' then
  //    Path := ExtractFilePath(aFile)
  //  else
  Path := ExtractFilePath(ParamStr(0));
  Path := Path + Fichier;
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

end.

