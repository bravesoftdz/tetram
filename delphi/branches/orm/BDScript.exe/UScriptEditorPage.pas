unit UScriptEditorPage;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, System.UITypes,
  Vcl.Controls, Vcl.ComCtrls, Vcl.Dialogs,
  Generics.Collections,
  SynEdit, SynEditKeyCmds, SynEditSearch, SynMacroRecorder,
  PngImageList,
  UScriptEngineIntf,
  UScriptList, UScriptEditor;

const
  ecOpenFileUnderCursor = ecUserFirst;
  ecToggleDeclImpl = ecUserFirst + 1;

type
  TEditorPage = class;

  IFrmScriptsEditor = interface
    function GetMasterEngine: IMasterEngine;
    property MasterEngine: IMasterEngine read GetMasterEngine;

    function GetSynEditSearch: TSynEditSearch;
    property SynEditSearch: TSynEditSearch read GetSynEditSearch;

    procedure AddEditor(Page: TEditorPage);
    procedure RemoveEditor(Page: TEditorPage);

    function GetseScript1Change: TNotifyEvent;
    property seScript1Change: TNotifyEvent read GetseScript1Change;

    function LoadScript(const ScriptUnitName: string): TEditorPage;

    function GetlstDebugImages: TPngImageList;
    property lstDebugImages: TPngImageList read GetlstDebugImages;

    function GetSynMacroRecorder: TSynMacroRecorder;
    property SynMacroRecorder: TSynMacroRecorder read GetSynMacroRecorder;
  end;

  TLineChangedState = (csOriginal, csModified, csSaved);
  TLinesChangedStates = array of TLineChangedState;

  TEditorPage = class(TWinControl)
  private
    FScript: TScript;
    FTabSheet: TTabSheet;
    FEditor: TScriptEditor;
    FSB: TStatusBar;
    FMasterEngine: IMasterEngine;
    FfrmScriptsEditor: IFrmScriptsEditor;
    FExecutableLines: TBits;
    FLineChangedState: TLinesChangedStates;
    procedure SetModifie(const Value: Boolean);
    function GetModifie: Boolean;
  public
    constructor Create(AOwner: TPageControl; aFrmScriptsEditor: IFrmScriptsEditor; AScript: TScript); reintroduce;
    destructor Destroy; override;

    procedure DoOnEditorChange(ASender: TObject);
    procedure SynEditorGutterClick(Sender: TObject; Button: TMouseButton; X, Y, Line: Integer; Mark: TSynEditMark);
    procedure SynEditGutterPaint(Sender: TObject; aLine, X, Y: Integer);
    procedure SynEditorSpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);
    procedure SynEditorReplaceText(Sender: TObject; const ASearch, AReplace: string; Line, Column: Integer; var Action: TSynReplaceAction);
    procedure SynEditorCommandProcessed(Sender: TObject; var Command: TSynEditorCommand; var AChar: Char; Data: Pointer);

    procedure UpdateStatusBarPanels;

    procedure ShowExecutableLines;
    procedure ClearExecutableLines;
    procedure InitExecutableLines;
    function IsExecutableLine(aLine: Integer): Boolean; inline;

    procedure ClearLineChangeStates;
    procedure InitLineChangeStates;
    function GetLineChangeState(aLine: Integer): TLineChangedState; inline;

    procedure GotoLineNumber;
    procedure OpenFileUnderCursor;

    procedure LinesInserted(FirstLine, Count: Integer);
    procedure LinesDeleted(FirstLine, Count: Integer);
  published
    property frmScriptsEditor: IFrmScriptsEditor read FfrmScriptsEditor;
    property MasterEngine: IMasterEngine read FMasterEngine;

    // property ExecutableLines: TBits read FExecutableLines;
    // property LineChangedState: TLinesChangedStates read FLineChangedState;

    property Script: TScript read FScript;
    property TabSheet: TTabSheet read FTabSheet write FTabSheet;
    property Editor: TScriptEditor read FEditor write FEditor;
    property SB: TStatusBar read FSB write FSB;
    property Modifie: Boolean read GetModifie write SetModifie;
  end;

  TEditorPagesList = class(TObjectList<TEditorPage>)
  public
    function EditorByUnitName(const ScriptUnitName: string): TScriptEditor;
    function EditorByScript(Script: TScript): TScriptEditor;

    function PageByScript(Script: TScript): TEditorPage;
    function PageByUnitName(const ScriptUnitName: string): TEditorPage;
  end;

implementation

uses
  UfrmScriptGotoLine;

const
  imgGutterBREAK = 0;
  imgGutterBREAKVALID = 1;
  imgGutterBREAKINVAL = 2;
  imgGutterCOMPLINE = 3;
  imgGutterEXECLINECL = 4;
  imgGutterEXECLINEBP = 5;
  imgGutterEXECLINE = 6;
  imgGutterBREAKDISABLED = 7;

  { TEditorPagesList }

function TEditorPagesList.EditorByScript(Script: TScript): TScriptEditor;
var
  Page: TEditorPage;
begin
  Page := PageByScript(Script);
  if Assigned(Page) then
    Result := Page.Editor
  else
    Result := nil;
end;

function TEditorPagesList.EditorByUnitName(const ScriptUnitName: string): TScriptEditor;
var
  Page: TEditorPage;
begin
  Page := PageByUnitName(ScriptUnitName);
  if Assigned(Page) then
    Result := Page.Editor
  else
    Result := nil;
end;

function TEditorPagesList.PageByScript(Script: TScript): TEditorPage;
var
  Page: TEditorPage;
begin
  for Page in Self do
    if Page.Script = Script then
      Exit(Page);
  Result := nil;
end;

function TEditorPagesList.PageByUnitName(const ScriptUnitName: string): TEditorPage;
var
  Page: TEditorPage;
begin
  for Page in Self do
    if Page.Script.ScriptUnitName = ScriptUnitName then
      Exit(Page);
  Result := nil;
end;

{ TEditorPageSynEditPlugin }

type
  TEditorPageSynEditPlugin = class(TSynEditPlugin)
  protected
    FPage: TEditorPage;
    procedure LinesInserted(FirstLine, Count: Integer); override;
    procedure LinesDeleted(FirstLine, Count: Integer); override;
  public
    constructor Create(APage: TEditorPage);
  end;

constructor TEditorPageSynEditPlugin.Create(APage: TEditorPage);
begin
  inherited Create(APage.Editor);
  FPage := APage;
end;

type
  TCallback<II: IPositionnedDebugItem> = reference to procedure(list: IDebugList<II>);

procedure TEditorPageSynEditPlugin.LinesInserted(FirstLine, Count: Integer);
var
  cb: TCallback<IPositionnedDebugItem>;
begin
  // Track the executable lines
  FPage.LinesInserted(FirstLine, Count);

  // Track the breakpoint lines in the debugger
  cb := procedure(list: IDebugList<IPositionnedDebugItem>)
    var
      Item: IPositionnedDebugItem;
    begin
      for Item in list do
        if Item.Script = FPage.Script then
          if Item.Line >= Cardinal(FirstLine) then
            Item.Line := Item.Line + Cardinal(Count);
      list.UpdateView;
    end;

  TCallback<IBreakpointInfo>(cb)(FPage.MasterEngine.DebugPlugin.Breakpoints);
  TCallback<IMessageInfo>(cb)(FPage.MasterEngine.DebugPlugin.Messages);

  // Redraw the gutter for updated icons.
  FPage.Editor.InvalidateGutter;
  FPage.Editor.InvalidateLines(FirstLine, FPage.Editor.Lines.Count);
end;

procedure TEditorPageSynEditPlugin.LinesDeleted(FirstLine, Count: Integer);
var
  cb: TCallback<IPositionnedDebugItem>;
begin
  // Track the executable lines
  FPage.LinesDeleted(FirstLine, Count);

  // Track the breakpoint lines in the debugger
  cb := procedure(list: IDebugList<IPositionnedDebugItem>)
    var
      Item: IPositionnedDebugItem;
      i: Integer;
    begin
      for i := Pred(list.ItemCount) downto 0 do
      begin
        Item := list[i];
        if Item.Script = FPage.Script then
          if Item.Line in [FirstLine .. FirstLine + Count - 1] then
            list.Delete(i)
          else if Item.Line >= Cardinal(FirstLine) then
            Item.Line := Item.Line - Cardinal(Count);
      end;
      list.UpdateView;
    end;

  TCallback<IBreakpointInfo>(cb)(FPage.MasterEngine.DebugPlugin.Breakpoints);
  TCallback<IMessageInfo>(cb)(FPage.MasterEngine.DebugPlugin.Messages);

  // Redraw the gutter for updated icons.
  FPage.Editor.InvalidateGutter;
  FPage.Editor.InvalidateLines(FirstLine, FPage.Editor.Lines.Count);
end;

{ TEditorPage }

procedure TEditorPage.ClearExecutableLines;
var
  i: Integer;
begin
  for i := 0 to FExecutableLines.Size do
    FExecutableLines[i] := False;

  Editor.InvalidateGutter;
end;

procedure TEditorPage.ClearLineChangeStates;
var
  i: Integer;
begin
  for i := 0 to Length(FLineChangedState) do
    FLineChangedState[i] := csOriginal;

  Editor.InvalidateGutter;
end;

constructor TEditorPage.Create(AOwner: TPageControl; aFrmScriptsEditor: IFrmScriptsEditor; AScript: TScript);
begin
  inherited Create(AOwner);

  FExecutableLines := TBits.Create;

  FfrmScriptsEditor := aFrmScriptsEditor;
  FMasterEngine := FfrmScriptsEditor.MasterEngine;
  FScript := AScript;

  TabSheet := TTabSheet.Create(AOwner);
  TabSheet.PageControl := AOwner;
  TabSheet.Caption := Script.ScriptUnitName;

  Editor := MasterEngine.Engine.GetNewEditor(TabSheet);
  Editor.Parent := TabSheet;

  Editor.SearchEngine := FfrmScriptsEditor.SynEditSearch;

  Editor.OnChange := DoOnEditorChange;

  Editor.OnGutterClick := SynEditorGutterClick;
  Editor.OnGutterPaint := SynEditGutterPaint;
  Editor.OnReplaceText := SynEditorReplaceText;
  Editor.OnSpecialLineColors := SynEditorSpecialLineColors;
  Editor.OnProcessUserCommand := SynEditorCommandProcessed;

  // *******************************
  // FEditor.OnKeyDown := SynEditorKeyDown;
  // *******************************

  Editor.AddKey(ecGotoXY, 47, [ssAlt]);
  Editor.AddKey(ecOpenFileUnderCursor, VK_RETURN, [ssCtrl]);
  // Editor.AddKey(ecToggleDeclImpl, VK_UP, [ssCtrl, ssShift]);
  // Editor.AddKey(ecToggleDeclImpl, VK_DOWN, [ssCtrl, ssShift]);

  FfrmScriptsEditor.AddEditor(Self);

  TEditorPageSynEditPlugin.Create(Self);
  Editor.Lines.Assign(Script.Code);
  InitExecutableLines;
  InitLineChangeStates;

  SB := TStatusBar.Create(TabSheet);
  SB.Parent := TabSheet;
  SB.Panels.Add.Width := 50;
  SB.Panels.Add.Width := 50;
  SB.Panels.Add.Width := 50;

  TabSheet.Visible := True;
end;

destructor TEditorPage.Destroy;
begin
  FfrmScriptsEditor.RemoveEditor(Self);
  FExecutableLines.Free;

  FEditor.Free;
  SB.Free;

  TabSheet.Free;

  FMasterEngine := nil;

  inherited;
end;

procedure TEditorPage.DoOnEditorChange(ASender: TObject);
begin
  FLineChangedState[FEditor.CaretY - 1] := csModified;
  Modifie := True;
  FfrmScriptsEditor.seScript1Change(ASender);
end;

function TEditorPage.GetLineChangeState(aLine: Integer): TLineChangedState;
begin
  if aLine < Length(FLineChangedState) then
    Result := FLineChangedState[aLine]
  else
    Result := csOriginal;
end;

function TEditorPage.GetModifie: Boolean;
begin
  if Assigned(FScript) then
    Result := FScript.Modifie
  else
    Result := True;
end;

procedure TEditorPage.GotoLineNumber;
begin
  with TfrmScriptGotoLine.Create(nil) do
    try
      if ShowModal = mrOk then
        FEditor.GotoLineAndCenter(LineNumber);
    finally
      Free;
    end;
end;

procedure TEditorPage.InitExecutableLines;
begin
  FExecutableLines.Size := 0;
  FExecutableLines.Size := Editor.Lines.Count;
end;

procedure TEditorPage.InitLineChangeStates;
begin
  SetLength(FLineChangedState, 0);
  SetLength(FLineChangedState, Editor.Lines.Count);
end;

function TEditorPage.IsExecutableLine(aLine: Integer): Boolean;
begin
  Result := (aLine < FExecutableLines.Size) and FExecutableLines[aLine];
end;

procedure TEditorPage.LinesDeleted(FirstLine, Count: Integer);
var
  i: Integer;
begin
  for i := FirstLine - 1 to FExecutableLines.Size - Count - 1 do
    FExecutableLines[i] := FExecutableLines[i + Count];
  FExecutableLines.Size := FExecutableLines.Size - Count;

  // Track the executable lines
  for i := FirstLine - 1 to Length(FLineChangedState) - Count - 1 do
    FLineChangedState[i] := FLineChangedState[i + Count];
  SetLength(FLineChangedState, Length(FLineChangedState) - Count);
end;

procedure TEditorPage.LinesInserted(FirstLine, Count: Integer);
var
  i, iLineCount: Integer;
begin
  iLineCount := Editor.Lines.Count;
  FExecutableLines.Size := iLineCount;
  for i := iLineCount - 1 downto FirstLine + Count do
    FExecutableLines[i] := FExecutableLines[i - Count];
  for i := FirstLine + Count - 1 downto FirstLine do
    FExecutableLines[i] := False;

  SetLength(FLineChangedState, iLineCount);
  for i := iLineCount - 1 downto FirstLine + Count do
    FLineChangedState[i] := FLineChangedState[i - Count];
  for i := FirstLine + Count - 1 downto FirstLine - 1 do
    FLineChangedState[i] := csModified;
end;

procedure TEditorPage.OpenFileUnderCursor;
begin
  FfrmScriptsEditor.LoadScript(Editor.WordAtCursor);
end;

procedure TEditorPage.SetModifie(const Value: Boolean);
begin
  if Assigned(FScript) then
    FScript.Modifie := Value;
end;

procedure TEditorPage.ShowExecutableLines;
var
  LineNumbers: TLineNumbers;
  i: Integer;
begin
  ClearExecutableLines;
  LineNumbers := MasterEngine.Engine.GetExecutableLines(FScript.ScriptUnitName);
  for i := 0 to Length(LineNumbers) - 1 do
    FExecutableLines[LineNumbers[i]] := True;
  Editor.InvalidateGutter;
end;

procedure TEditorPage.SynEditGutterPaint(Sender: TObject; aLine, X, Y: Integer);
var
  IconIndex: Integer;
  i: Integer;
  Proc, Pos: Cardinal;
begin
  IconIndex := -1;
  i := MasterEngine.DebugPlugin.Breakpoints.IndexOf(FScript, aLine);
  if i <> -1 then
  begin
    if not MasterEngine.Engine.Running then
      if MasterEngine.DebugPlugin.Breakpoints[i].Active then
        IconIndex := imgGutterBREAK
      else
        IconIndex := imgGutterBREAKDISABLED
    else
    begin
      if (Cardinal(aLine) = MasterEngine.Engine.ActiveLine) and SameText(MasterEngine.GetScriptUnitName(MasterEngine.Engine.ActiveUnitName),
        FScript.ScriptUnitName) then
        IconIndex := imgGutterEXECLINEBP
      else if MasterEngine.DebugPlugin.Breakpoints[i].Active then
        IconIndex := imgGutterBREAKVALID
      else
        IconIndex := imgGutterBREAKDISABLED;
    end;
  end
  else
  begin
    if (MasterEngine.Engine.DebugMode = UScriptEngineIntf.dmPaused) and (Cardinal(aLine) = MasterEngine.Engine.ActiveLine) and
      SameText(MasterEngine.GetScriptUnitName(MasterEngine.Engine.ActiveUnitName), FScript.ScriptUnitName) then
      IconIndex := imgGutterEXECLINE;
  end;

  if MasterEngine.Compiled then
    if IsExecutableLine(aLine) or MasterEngine.Engine.TranslatePosition(Proc, Pos, aLine, FScript.ScriptUnitName) then
      case IconIndex of
        - 1:
          IconIndex := imgGutterCOMPLINE;
        // imgGutterBREAKDISABLED: IconIndex := imgGutterCOMPLINE;
        // imgGutterBREAK: IconIndex := imgGutterCOMPLINE;
        // imgGutterBREAKVALID: IconIndex := imgGutterCOMPLINE;
        imgGutterEXECLINE:
          IconIndex := imgGutterEXECLINECL;
      end
    else
      case IconIndex of
        imgGutterBREAK:
          IconIndex := imgGutterBREAKINVAL;
        imgGutterBREAKVALID:
          IconIndex := imgGutterBREAKINVAL;
      end;

  if IconIndex <> -1 then
    FfrmScriptsEditor.lstDebugImages.Draw(TSynEdit(Sender).Canvas, X, Y, IconIndex);
end;

procedure TEditorPage.SynEditorCommandProcessed(Sender: TObject; var Command: TSynEditorCommand; var AChar: Char; Data: Pointer);
begin
  case Command of
    ecGotoXY:
      GotoLineNumber;
    ecOpenFileUnderCursor:
      OpenFileUnderCursor;
    ecToggleDeclImpl:
      // ToggleDeclImpl;
      ;
  end;
end;

procedure TEditorPage.SynEditorGutterClick(Sender: TObject; Button: TMouseButton; X, Y, Line: Integer; Mark: TSynEditMark);
var
  iLine: Integer;
begin
  iLine := Editor.RowToLine(Line);

  if (X <= Editor.Gutter.LeftOffset) and (iLine < FExecutableLines.Size) then
  begin
    MasterEngine.ToggleBreakPoint(FScript, iLine, False);
    Editor.Repaint;
  end;
end;

procedure TEditorPage.SynEditorReplaceText(Sender: TObject; const ASearch, AReplace: string; Line, Column: Integer; var Action: TSynReplaceAction);
begin
  case MessageDlg('Remplacer cette occurence ?', mtConfirmation, [mbYes, mbNo, mbCancel, mbYesToAll], 0) of
    mrYes:
      Action := raReplace;
    mrNo:
      Action := raSkip;
    mrCancel:
      Action := raCancel;
    mrYesToAll:
      Action := raReplaceAll;
  end;
end;

procedure TEditorPage.SynEditorSpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);
var
  i: Integer;
  Proc, Pos: Cardinal;
begin
  i := MasterEngine.DebugPlugin.Breakpoints.IndexOf(FScript, Line);

  if (Cardinal(Line) = MasterEngine.Engine.ActiveLine) and SameText(MasterEngine.GetScriptUnitName(MasterEngine.Engine.ActiveUnitName), FScript.ScriptUnitName)
  then
  begin
    Special := True;
    FG := clWhite;
    BG := clNavy;
  end
  else if i <> -1 then
  begin
    Special := True;
    if MasterEngine.DebugPlugin.Breakpoints[i].Active then
    begin
      if MasterEngine.Compiled and not(IsExecutableLine(Line) or MasterEngine.Engine.TranslatePosition(Proc, Pos, Line, FScript.ScriptUnitName)) then
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
  else if (MasterEngine.Engine.ErrorLine > 0) and (Cardinal(Line) = MasterEngine.Engine.ErrorLine) and
    SameText(MasterEngine.GetScriptUnitName(MasterEngine.Engine.ErrorUnitName), FScript.ScriptUnitName) then
  begin
    Special := True;
    FG := clWhite;
    BG := clMaroon;
  end

  else
    Special := False;
end;

procedure TEditorPage.UpdateStatusBarPanels;
const
  MacroRecorderStates: array [TSynMacroState] of string = ('Arrêté', 'Enregistrement...', 'Exécution...', 'En pause');
var
  ptCaret: TPoint;
begin
  ptCaret := TPoint(Editor.CaretXY);
  if (ptCaret.X > 0) and (ptCaret.Y > 0) then
    SB.Panels[0].Text := Format(' %6d:%3d ', [ptCaret.Y, ptCaret.X])
  else
    SB.Panels[0].Text := '';

  if Editor.Modified then
    SB.Panels[1].Text := 'Modifié'
  else
    SB.Panels[1].Text := '';

  if Editor.ReadOnly then
    SB.Panels[2].Text := 'Lecture seule'
  else if Editor.InsertMode then
  begin
    if FfrmScriptsEditor.SynMacroRecorder.State <> msStopped then
      SB.Panels[2].Text := UpperCase(MacroRecorderStates[FfrmScriptsEditor.SynMacroRecorder.State])
    else
      SB.Panels[2].Text := 'Insertion'
  end
  else
    SB.Panels[2].Text := 'Remplacer';
end;

end.
