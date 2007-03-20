unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SynEditHighlighter, SynHighlighterPas, SynEdit, ImgList, StrUtils,
  uPSComponent, uPSDebugger, SynEditMiscClasses, SynEditSearch, StdActns, ActnList, uPSDisassembly,
  Menus, SynEditTypes, ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    EScript: TSynEdit;
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
    Messages: TListBox;
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
  private
    { Déclarations privées }
    FLastSearch, FLastReplace: string;
    FSearchOptions: TSynSearchOptions;
    FCurrentLine: Integer;
    FActiveLine: Cardinal;
    FResume: Boolean;
    procedure SetResultat(const Chaine: string);
    procedure ToggleBreakPoint(Line: Integer);
    function Compile: Boolean;
    function Execute: Boolean;
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses Unit2, uPSRuntime, Unit3, Unit4;


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

procedure TForm1.ToggleBreakPoint(Line: Integer);
begin
  if PSScriptDebugger1.HasBreakPoint(PSScriptDebugger1.MainFileName, Line) then
    PSScriptDebugger1.ClearBreakPoint(PSScriptDebugger1.MainFileName, Line)
  else
    PSScriptDebugger1.SetBreakPoint(PSScriptDebugger1.MainFileName, Line);
  EScript.InvalidateLine(Line);
  EScript.InvalidateGutterLine(Line);
end;

procedure TForm1.EScriptGutterClick(Sender: TObject; Button: TMouseButton; X, Y, Line: Integer; Mark: TSynEditMark);
begin
  if X <= EScript.Gutter.LeftOffset then
    ToggleBreakpoint(Line);
end;

procedure TForm1.EScriptGutterPaint(Sender: TObject; aLine, X, Y: Integer);
var
  IconIndex: Integer;
begin
  IconIndex := -1;
  //  if DebugPlugin.IsBreakpoint(ALine) then
  if PSScriptDebugger1.HasBreakPoint('', ALine) then
  begin
    //    if FScriptStatus = iStopped then
    if not PSScriptDebugger1.Running then
      IconIndex := imgGutterBREAK
    else
    begin
      //      if DebugPlugin.CurrentLine = ALine then
      if FActiveLine = ALine then
        IconIndex := imgGutterEXECLINEBP
      else
        IconIndex := imgGutterBREAKVALID
    end;
  end
  else
  begin
    //    if (FScriptStatus = iStepoverWaiting) and (DebugPlugin.CurrentLine = ALine) then
    if (PSScriptDebugger1.Exec.Status = isPaused) and (FActiveLine = ALine) then
      IconIndex := imgGutterEXECLINE;
  end;
  if IconIndex <> -1 then
    lstDebugImages.Draw(EScript.Canvas, X, Y, IconIndex);
end;

procedure TForm1.EScriptSpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);
begin
  if PSScriptDebugger1.HasBreakPoint(PSScriptDebugger1.MainFileName, Line) then
  begin
    Special := True;
    if Line = FActiveLine then
    begin
      FG := clWhite;
      BG := clNavy;
    end
    else
    begin
      FG := clWhite;
      BG := clRed;
    end;
  end
  else if Line = FActiveLine then
  begin
    Special := True;
    FG := clWhite;
    BG := clNavy;
  end
  else
    Special := False;

  //  if (PSScriptDebugger1.Exec.Status = isPaused) and (Line = GetExecutionLine) then
  //    //  if (FScriptStatus in [iStepOver, iStepOverWaiting]) and (Line = DebugPlugin.CurrentLine) then
  //  begin
  //    Special := True;
  //    FG := clWhite;
  //    BG := clNavy;
  //  end
  //  else if PSScriptDebugger1.HasBreakPoint('', Line) then
  //    //  if FDebugPlugin.IsBreakpoint(Line) then
  //  begin
  //    Special := True;
  //    FG := clWhite;
  //    BG := clRed;
  //  end
  //  else if (PSScriptDebugger1.Exec.ExceptionPos <> Cardinal(-1)) and (Line = PSScriptDebugger1.Exec.ExceptionPos) then
  //    //  if (DebugPlugin.ErrorLine <> -1) and (Line = DebugPlugin.ErrorLine) then
  //  begin
  //    Special := True;
  //    FG := clWhite;
  //    BG := clMaroon;
  //  end
end;

procedure TForm1.EScriptStatusChange(Sender: TObject; Changes: TSynStatusChanges);
//var
//  i: Integer;
begin
  //  if (scCaretX in Changes) or (scCaretY in Changes) then
  //  begin
  //    sbEditor.Panels[pnlEditorPos].Caption := Format('%d:%d', [EScript.CaretX, EScript.CaretY]);
  //    if DebugPlugin.ErrorLine <> -1 then
  //    begin
  //      i := DebugPlugin.ErrorLine;
  //      DebugPlugin.ErrorLine := -1;
  //      EScript.InvalidateGutterLine(i);
  //      EScript.InvalidateLine(i);
  //    end;
  //  end;
  //  if (scModified in Changes) then
  //  begin
  //    FCurrentFile.Modified := EScript.Modified;
  //  end;
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
begin
  FCurrentLine := -1;
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
    FResume := True
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
  if PSScriptDebugger1.Execute then
  begin
    Messages.Items.Add('Succesfully Execute');
    Result := True;
  end
  else
  begin
    messages.Items.Add('Runtime Error: ' + PSScriptDebugger1.ExecErrorToString + ' at [' + IntToStr(PSScriptDebugger1.ExecErrorRow) + ':' + IntToStr(PSScriptDebugger1.ExecErrorCol) + '] bytecode pos:' + IntToStr(PSScriptDebugger1.ExecErrorProcNo) + ':' + IntToStr(PSScriptDebugger1.ExecErrorByteCodePosition));
    Result := False;
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
  if (FActiveLine < EScript.TopLine + 2) or (FActiveLine > EScript.TopLine + EScript.LinesInWindow - 2) then
  begin
    EScript.TopLine := FActiveLine - (EScript.LinesInWindow div 2);
  end;
  EScript.CaretY := FActiveLine;
  EScript.CaretX := 1;

  EScript.Refresh;
end;

procedure TForm1.PSScriptDebugger1Idle(Sender: TObject);
begin
  Application.HandleMessage;
  if FResume then
  begin
    FResume := False;
    PSScriptDebugger1.Resume;
    FActiveLine := 0;
    EScript.Refresh;
  end;
end;

procedure TForm1.PSScriptDebugger1AfterExecute(Sender: TPSScript);
begin
  FActiveLine := 0;
  EScript.Refresh;
end;

procedure TForm1.PSScriptDebugger1LineInfo(Sender: TObject; const FileName: string; Position, Row, Col: Cardinal);
begin
  if PSScriptDebugger1.Exec.DebugMode <> dmRun then
  begin
    FActiveLine := Row;
    if (FActiveLine < EScript.TopLine + 2) or (FActiveLine > EScript.TopLine + EScript.LinesInWindow - 2) then
    begin
      EScript.TopLine := FActiveLine - (EScript.LinesInWindow div 2);
    end;
    EScript.CaretY := FActiveLine;
    EScript.CaretX := 1;

    EScript.Refresh;
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
  messages.Clear;
  for i := 0 to PSScriptDebugger1.CompilerMessageCount - 1 do
  begin
    Messages.Items.Add(PSScriptDebugger1.CompilerMessages[i].MessageToString);
  end;
  if Result then
    Messages.Items.Add('Succesfully compiled');
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
    debugoutput.visible := true;
  end;
end;

procedure TForm1.actBreakpointExecute(Sender: TObject);
begin
  ToggleBreakPoint(EScript.CaretY);
end;

end.

