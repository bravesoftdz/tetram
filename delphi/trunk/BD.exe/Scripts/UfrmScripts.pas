unit UfrmScripts;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, SynEditHighlighter, SynEdit, ImgList,
  StrUtils, SynEditMiscClasses, SynEditSearch, StdActns, ActnList, Menus, SynEditTypes, ComCtrls, UScriptUtils, VirtualTrees, StdCtrls,
  ExtCtrls, LoadComplet, SynEditKeyCmds, UBdtForms, Generics.Collections, ToolWin, UfrmFond, UScriptEditor,
  PngImageList, UdmScripts, UScriptList, UScriptDebug, UframBoutons, EditLabeled,
  System.Actions;

type
  TfrmScripts = class(TbdtForm)
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
    actAddSuivi: TAction;
    actAddSuivi1: TMenuItem;
    actRunToCursor: TAction;
    Jusquaucurseur1: TMenuItem;
    PopupMenu1: TPopupMenu;
    actFermer: TAction;
    actEnregistrer: TAction;
    Fermer1: TMenuItem;
    N6: TMenuItem;
    Enregistrer1: TMenuItem;
    PageControl2: TPageControl;
    tbEdition: TTabSheet;
    ToolBar2: TToolBar;
    Splitter1: TSplitter;
    pcScripts: TPageControl;
    tbScripts: TTabSheet;
    actRunWithoutDebug: TAction;
    Excutersansdbuguer1: TMenuItem;
    actEdit: TAction;
    PopupMenu2: TPopupMenu;
    actCreerOption: TAction;
    actRetirerOption: TAction;
    Creruneoption1: TMenuItem;
    Retireruneoption1: TMenuItem;
    actModifierOption: TAction;
    Modifieruneoption1: TMenuItem;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    Panel2: TPanel;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    lstDebugImages: TPngImageList;
    ToolButton7: TToolButton;
    actPause: TAction;
    framBoutons1: TframBoutons;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    vstMessages: TVirtualStringTree;
    TabSheet2: TTabSheet;
    vstSuivis: TVirtualStringTree;
    TabSheet3: TTabSheet;
    vstBreakpoints: TVirtualStringTree;
    TabSheet6: TTabSheet;
    mmConsole: TMemo;
    Splitter2: TSplitter;
    Panel3: TPageControl;
    TabSheet4: TTabSheet;
    ListBox1: TListBox;
    Panel4: TPanel;
    ListBox2: TListBox;
    Splitter3: TSplitter;
    ListView1: TListView;
    Label1: TLabel;
    Panel5: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Memo1: TMemo;
    TabSheet5: TTabSheet;
    EditLabeled1: TEditLabeled;
    MemoLabeled1: TMemoLabeled;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    EditLabeled2: TEditLabeled;
    EditLabeled3: TEditLabeled;
    Button1: TButton;
    Alias: TTabSheet;
    Memo2: TMemo;
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
    procedure actCompileExecute(Sender: TObject);
    procedure actRunExecute(Sender: TObject);
    procedure actStepOverExecute(Sender: TObject);
    procedure actStepIntoExecute(Sender: TObject);
    procedure actResetExecute(Sender: TObject);
    procedure actDecompileExecute(Sender: TObject);
    procedure actBreakpointExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actAddSuiviExecute(Sender: TObject);
    procedure actRunToCursorExecute(Sender: TObject);
    procedure vstSuivisNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
    procedure vstSuivisEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vstSuivisInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstSuivisChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstSuivisGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstSuivisPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure vstMessagesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstMessagesDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure seScript1Change(Sender: TObject);
    procedure vstBreakpointsDblClick(Sender: TObject);
    procedure vstBreakpointsChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstBreakpointsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstBreakpointsInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstBreakpointsPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure actFermerExecute(Sender: TObject);
    procedure actEnregistrerExecute(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure seScript1ProcessUserCommand(Sender: TObject; var Command: TSynEditorCommand; var AChar: Char; Data: Pointer);
    procedure actRunWithoutDebugExecute(Sender: TObject);
    procedure pcScriptsChange(Sender: TObject);
    procedure seScript1KeyPress(Sender: TObject; var Key: Char);
    procedure PageControl2Change(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure ListBox1Data(Control: TWinControl; index: Integer; var Data: string);
    procedure ListBox1DblClick(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure actCreerOptionExecute(Sender: TObject);
    procedure actRetirerOptionExecute(Sender: TObject);
    procedure actModifierOptionExecute(Sender: TObject);
    procedure actPauseExecute(Sender: TObject);
    procedure mmConsoleChange(Sender: TObject);
    procedure framBoutons1btnAnnulerClick(Sender: TObject);
    procedure EditLabeled1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FLastSearch, FLastReplace: string;
    FSearchOptions: TSynSearchOptions;
    FCompiled: Boolean;
    FProjetOuvert: Boolean;
    FForceClose: Boolean;

    FCurrentScript, FProjetScript: TScript;
    FOpenedScript: TObjectList<TScript>;
    FRefreshingDescription: Boolean;
{$REGION 'Exécution'}
    function Compile: Boolean;
    function Execute: Boolean;
    procedure PSScriptDebugger1Idle(Sender: TObject);
{$ENDREGION}
    procedure WMSyscommand(var msg: TWmSysCommand); message WM_SYSCOMMAND;
{$REGION 'Débuggage'}
    procedure GoToPosition(Editor: TSynEdit; Line, Char: Cardinal); overload;
    procedure GoToPosition(Script: string; Line, Char: Cardinal); overload; inline;
    procedure GoToMessage(msg: TMessageInfo);
    procedure GoToBreakpoint(msg: TBreakpointInfo);
{$ENDREGION}
    function GetScript(const Script: string): TScriptEditor;
    procedure SetCompiled(const Value: Boolean);
    function GetProjet: string;
    procedure SetProjet(const Value: string);
    procedure LoadScript(const Script: string);
    procedure RefreshOptions;
    procedure RefreshDescription(Script: TScript);
    function EditOption(Option: TOption): Boolean;
    procedure ClearPages;
    procedure SetProjetOuvert(const Value: Boolean);
    procedure LoadScripts;
    procedure AfterExecute;
    procedure ClearExecutableLines;
    procedure InitExecutableLines;
    procedure ShowExecutableLines;
    function IsExecutableLine(aLine: Integer): Boolean;
    procedure OnBreakPoint;
  public
    dmScripts: IMasterEngineInterface;
    property Compiled: Boolean read FCompiled write SetCompiled;
    property Projet: string read GetProjet write SetProjet;
    property ProjetOuvert: Boolean read FProjetOuvert write SetProjetOuvert;
  end;

var
  frmScripts: TfrmScripts;

implementation

{$R *.dfm}

uses
  UfrmScriptSearch, UScriptsFonctions, CommonConst, UIB, Procedures, BdtkRegEx, Commun, Divers,
  UScriptsHTMLFunctions, JclSimpleXML, UdmPrinc, UfrmScriptOption, UfrmScriptEditOption, UfrmScriptsUpdate,
  UdmPascalScript;

function TfrmScripts.GetScript(const Script: string): TScriptEditor;
begin
  if (Script = '') or (Script = dmScripts.Engine.GetMainSpecialName) then
    Result := dmScripts.ScriptList.EditorByScriptName(Projet)
  else
    Result := dmScripts.ScriptList.EditorByScriptName(Script);
end;

procedure TfrmScripts.Button1Click(Sender: TObject);
begin
  with TfrmScriptsUpdate.Create(nil) do
    try
      dmScripts := Self.dmScripts;
      ShowModal;
    finally
      Free;
    end;
  LoadScripts;
end;

procedure TfrmScripts.mmConsoleChange(Sender: TObject);
begin
  if (PageControl1.ActivePage <> TTabSheet(vstSuivis.Parent)) or (dmScripts.DebugPlugin.Watches.CountActive = 0) then
    PageControl1.ActivePage := TTabSheet(mmConsole.Parent);
  Application.ProcessMessages;
end;

procedure TfrmScripts.PageControl2Change(Sender: TObject);
begin
  if PageControl2.ActivePageIndex = 0 then
    ProjetOuvert := False;
  RefreshOptions;
  RefreshDescription(FProjetScript);
  Panel3.ActivePageIndex := 0;
end;

{$REGION 'Edition'}

const
  imgGutterBREAK = 0;
  imgGutterBREAKVALID = 1;
  imgGutterBREAKINVAL = 2;
  imgGutterCOMPLINE = 3;
  imgGutterEXECLINECL = 4;
  imgGutterEXECLINEBP = 5;
  imgGutterEXECLINE = 6;
  imgGutterBREAKDISABLED = 7;

procedure TfrmScripts.seScript1GutterClick(Sender: TObject; Button: TMouseButton; X, Y, Line: Integer; Mark: TSynEditMark);
var
  ScriptName: string;
begin
  if X <= TSynEdit(Sender).Gutter.LeftOffset then
  begin
    ScriptName := dmScripts.ScriptList.ScriptName(TScriptEditor(Sender));
    if ScriptName = FProjetScript.ScriptName then
      ScriptName := dmScripts.Engine.GetMainSpecialName;
    dmScripts.ToggleBreakPoint(ScriptName, Line, False);
  end;
end;

procedure TfrmScripts.seScript1GutterPaint(Sender: TObject; aLine, X, Y: Integer);
var
  IconIndex: Integer;
  i: Integer;
  Script: string;
  Proc, Pos: Cardinal;
begin
  Script := dmScripts.ScriptList.ScriptName(TScriptEditor(Sender));
  if Script = FProjetScript.ScriptName then
    Script := dmScripts.Engine.GetMainSpecialName;
  IconIndex := -1;
  i := dmScripts.DebugPlugin.Breakpoints.IndexOf(Script, aLine);
  if i <> -1 then
  begin
    if not dmScripts.Engine.Running then
      if dmScripts.DebugPlugin.Breakpoints[i].Active then
        IconIndex := imgGutterBREAK
      else
        IconIndex := imgGutterBREAKDISABLED
    else
    begin
      if (Cardinal(aLine) = dmScripts.Engine.ActiveLine) and SameText(dmScripts.Engine.ActiveFile, Script) then
        IconIndex := imgGutterEXECLINEBP
      else if dmScripts.DebugPlugin.Breakpoints[i].Active then
        IconIndex := imgGutterBREAKVALID
      else
        IconIndex := imgGutterBREAKDISABLED;
    end;
  end
  else
  begin
    if (dmScripts.Engine.DebugMode = UdmScripts.dmPaused) and (Cardinal(aLine) = dmScripts.Engine.ActiveLine) and SameText(dmScripts.Engine.ActiveFile, Script) then
      IconIndex := imgGutterEXECLINE;
  end;

  if Compiled then
    if IsExecutableLine(aLine) or dmScripts.Engine.TranslatePosition(Proc, Pos, aLine, Script) then
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
    lstDebugImages.Draw(TSynEdit(Sender).Canvas, X, Y, IconIndex);
end;

procedure TfrmScripts.seScript1SpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);
var
  i: Integer;
  Script: string;
  Proc, Pos: Cardinal;
begin
  Script := dmScripts.ScriptList.ScriptName(TScriptEditor(Sender));
  if Script = FProjetScript.ScriptName then
    Script := dmScripts.Engine.GetMainSpecialName;
  i := dmScripts.DebugPlugin.Breakpoints.IndexOf(Script, Line);

  if (Cardinal(Line) = dmScripts.Engine.ActiveLine) and SameText(dmScripts.Engine.ActiveFile, Script) then
  begin
    Special := True;
    FG := clWhite;
    BG := clNavy;
  end
  else if i <> -1 then
  begin
    Special := True;
    if dmScripts.DebugPlugin.Breakpoints[i].Active then
    begin
      if Compiled and not(IsExecutableLine(Line) or dmScripts.Engine.TranslatePosition(Proc, Pos, Line, Script)) then
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
  else if (dmScripts.Engine.ErrorLine > 0) and (Cardinal(Line) = dmScripts.Engine.ErrorLine) and SameText(dmScripts.Engine.ErrorFile, Script) then
  begin
    Special := True;
    FG := clWhite;
    BG := clMaroon;
  end

  else
    Special := False;
end;

procedure TfrmScripts.seScript1StatusChange(Sender: TObject; Changes: TSynStatusChanges);
var
  Attri: TSynHighlighterAttributes;
  Token: string;
  SB: TStatusBar;
  Editor: TScriptEditor;
begin
  if (scCaretX in Changes) or (scCaretY in Changes) then
  begin
    Editor := TScriptEditor(Sender);
    SB := dmScripts.ScriptList.InfoScript(Editor).SB;
    SB.Panels[0].Text := Format('%.3d : %.3d', [Editor.CaretY, Editor.CaretX]);
    if Editor.GetHighlighterAttriAtRowCol(Editor.CaretXY, Token, Attri) then
    begin
      SB.Panels[2].Text := Attri.name;
    end
    else
      SB.Panels[2].Text := '';
  end;
  if (scModified in Changes) then
  begin
    // FCurrentFile.Modified := EScript.Modified;
  end;
end;

procedure TfrmScripts.SearchFind1Execute(Sender: TObject);
var
  dummyReplace: string;
begin
  with FCurrentScript.Editor do
    if SelAvail and (BlockBegin.Line = BlockEnd.Line) then
    begin
      FLastSearch := SelText;
      Include(FSearchOptions, ssoSelectedOnly);
    end
    else
    begin
      FLastSearch := WordAtCursor;
      Exclude(FSearchOptions, ssoSelectedOnly);
    end;

  if Sender = SearchFind1 then
  begin
    // chercher
    Exclude(FSearchOptions, ssoReplace);
    Exclude(FSearchOptions, ssoReplaceAll);

    if not TfrmScriptSearch.Execute(FLastSearch, dummyReplace, FSearchOptions) then
      Exit;
  end
  else
  begin
    // remplacer
    Include(FSearchOptions, ssoReplace);
    Exclude(FSearchOptions, ssoReplaceAll);

    if not TfrmScriptSearch.Execute(FLastSearch, FLastReplace, FSearchOptions) then
      Exit;
  end;

  SearchFindNext1Execute(Sender);
end;

procedure TfrmScripts.SearchFindNext1Execute(Sender: TObject);
begin
  if FLastSearch = '' then
    SearchFind1Execute(SearchFind1)
  else if FCurrentScript.Editor.SearchReplace(FLastSearch, FLastReplace, FSearchOptions) = 0 then
    ShowMessage('Texte non trouvé');
end;

procedure TfrmScripts.EditCut1Execute(Sender: TObject);
begin
  FCurrentScript.Editor.CutToClipboard;
end;

procedure TfrmScripts.EditLabeled1Change(Sender: TObject);
begin
  if FRefreshingDescription or not ProjetOuvert then
    Exit;
  if Sender = EditLabeled1 then
    FCurrentScript.ScriptInfos.Auteur := EditLabeled1.Text;
  if Sender = EditLabeled2 then
    FCurrentScript.ScriptInfos.ScriptVersion := EditLabeled2.Text;
  if Sender = EditLabeled3 then
    FCurrentScript.ScriptInfos.BDVersion := EditLabeled3.Text;
  if Sender = MemoLabeled1 then
    FCurrentScript.ScriptInfos.Description := MemoLabeled1.Text;
  if Sender = Memo2 then
    FCurrentScript.Alias.Assign(Memo2.Lines);
  FCurrentScript.Modifie := True;
end;

procedure TfrmScripts.EditCopy1Execute(Sender: TObject);
begin
  FCurrentScript.Editor.CopyToClipboard;
end;

procedure TfrmScripts.EditPaste1Execute(Sender: TObject);
begin
  FCurrentScript.Editor.PasteFromClipboard;
end;

procedure TfrmScripts.EditSelectAll1Execute(Sender: TObject);
begin
  FCurrentScript.Editor.SelectAll;
end;

procedure TfrmScripts.EditUndo1Execute(Sender: TObject);
begin
  FCurrentScript.Editor.Undo;
end;

procedure TfrmScripts.EditRedo1Execute(Sender: TObject);
begin
  FCurrentScript.Editor.Redo;
end;

procedure TfrmScripts.seScript1ReplaceText(Sender: TObject; const ASearch, AReplace: string; Line, Column: Integer; var Action: TSynReplaceAction);
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

procedure TfrmScripts.seScript1Change(Sender: TObject);
var
  Script: TScript;
  Editor: TScriptEditor;
begin
  Compiled := False;
  Script := dmScripts.ScriptList.InfoScript(TScriptEditor(Sender));
  Script.Modifie := True;

  if (dmScripts.Engine.ErrorLine > 0) then
  begin
    Editor := dmScripts.ScriptList.EditorByScriptName(dmScripts.Engine.ErrorFile);
    if Editor <> nil then
    begin
      Editor.InvalidateLine(dmScripts.Engine.ErrorLine);
      Editor.InvalidateGutterLine(dmScripts.Engine.ErrorLine);
    end;
    dmScripts.Engine.ErrorLine := 0;
  end;
end;

procedure TfrmScripts.actFermerExecute(Sender: TObject);
begin
  if not FForceClose and (FCurrentScript.ScriptName = Projet) then
    Exit;

  if FCurrentScript.Modifie then
  begin
    case MessageDlg('L''unité "' + string(FCurrentScript.ScriptName) + '" a été modifiée, voulez-vous l''enregistrer?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
      mrYes:
        actEnregistrer.Execute;
      mrNo:
        ;
      mrCancel:
        Abort;
    end;
  end;
  FOpenedScript.Delete(pcScripts.ActivePageIndex);
  pcScripts.ActivePage.Free;
  FCurrentScript.TabSheet := nil;
  FCurrentScript.Editor := nil;
  FCurrentScript.SB := nil;
  FCurrentScript.Modifie := False;
  FCurrentScript.Loaded := False;
  pcScriptsChange(nil);
end;

procedure TfrmScripts.actEditExecute(Sender: TObject);
begin
  Projet := ListView1.Selected.Caption;
end;

procedure TfrmScripts.actEnregistrerExecute(Sender: TObject);
begin
  with FOpenedScript[pcScripts.ActivePageIndex] do
  begin
    Code.Assign(Editor.Lines);
    Save;
  end;
end;

procedure TfrmScripts.ListBox1Data(Control: TWinControl; index: Integer; var Data: string);
begin
  Data := FProjetScript.Options[index].FLibelle + ': ' + FProjetScript.Options[index].ChooseValue;
end;

procedure TfrmScripts.ListBox1DblClick(Sender: TObject);
var
  Option: TOption;
begin
  if TListBox(Sender).ItemIndex = -1 then
    Exit;
  Option := FProjetScript.Options[TListBox(Sender).ItemIndex];

  with TfrmScriptOption.Create(nil) do
    try
      RadioGroup1.Caption := Option.FLibelle;
      RadioGroup1.Items.Text := StringReplace(Option.FValues, '|', sLineBreak, [rfReplaceAll]);
      RadioGroup1.ItemIndex := RadioGroup1.Items.IndexOf(Option.ChooseValue);
      RadioGroup1.Height := 21 + 20 * RadioGroup1.Items.Count;
      ClientHeight := RadioGroup1.Height + framBoutons1.Height + 4;
      if ShowModal = mrOk then
      begin
        Option.ChooseValue := RadioGroup1.Items[RadioGroup1.ItemIndex];

        with TUIBQuery.Create(nil) do
          try
            Transaction := GetTransaction(dmPrinc.UIBDataBase);
            SQL.Text := 'update or insert into options_scripts (script, nom_option, valeur) values (:script, :nom_option, :valeur)';
            Prepare(True);
            Params.AsString[0] := Copy(string(FProjetScript.ScriptName), 1, Params.MaxStrLen[0]);
            Params.AsString[1] := Copy(Option.FLibelle, 1, Params.MaxStrLen[1]);
            Params.AsString[2] := Copy(Option.ChooseValue, 1, Params.MaxStrLen[2]);
            Execute;
            Transaction.Commit;
          finally
            Transaction.Free;
            Free;
          end;

        RefreshOptions;
        RefreshDescription(FProjetScript);
      end;
    finally
      Free;
    end;
end;

procedure TfrmScripts.ListView1DblClick(Sender: TObject);
begin
  if not Assigned(ListView1.Selected) then
    Exit;
  if actRunWithoutDebug.Enabled then
    actRunWithoutDebug.Execute
  else
    actEdit.Execute;
end;

procedure TfrmScripts.ListView1SelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
  Option: TOption;
begin
  if Selected and Assigned(Item) then
  begin
    FProjetScript := TScript(Item.Data);

    FProjetScript.Load;
    dmScripts.TypeEngine := FProjetScript.ScriptInfos.Engine;
    if FProjetScript.Options.Count > 0 then
      with TUIBQuery.Create(nil) do
        try
          Transaction := GetTransaction(dmPrinc.UIBDataBase);
          SQL.Text := 'select nom_option, valeur from options_scripts where script = :script';
          Prepare(True);
          Params.AsString[0] := Copy(string(FProjetScript.ScriptName), 1, Params.MaxStrLen[0]);
          Open;
          while not Eof do
          begin
            Option := FProjetScript.OptionByName(Fields.AsString[0]);
            if Assigned(Option) then
              Option.ChooseValue := Fields.AsString[1];
            Next;
          end;
        finally
          Transaction.Free;
          Free;
        end;
  end
  else
  begin
    // pour forcer la fermeture des onglets tant que le projet est potentiellement ouvert :
    // la destruction de la fenêtre déselectionne l'item du listview avant de commencer la chaine des Destroy
    // et donc les passage dans FormDestroy et ClearPages
    // la question à 100 balles est "pourquoi ça ne se produit que lorsqu'on a fait un actEnregistrer.Execute"
    // ou dans certains cas quand l'exécution du script à généré une erreur de script
    ProjetOuvert := False;
    dmScripts.TypeEngine := seNone;
    FProjetScript := nil;
  end;
  RefreshOptions;
  RefreshDescription(FProjetScript);
end;

procedure TfrmScripts.seScript1ProcessUserCommand(Sender: TObject; var Command: TSynEditorCommand; var AChar: Char; Data: Pointer);
begin
  case Command - ecUserFirst of
    1:
      LoadScript(FCurrentScript.Editor.WordAtCursor);
  end;
end;

procedure TfrmScripts.pcScriptsChange(Sender: TObject);
begin
  if pcScripts.ActivePageIndex > -1 then
  begin
    FCurrentScript := FOpenedScript[pcScripts.ActivePageIndex];
    InitExecutableLines;
    ShowExecutableLines;
  end
  else
    FCurrentScript := nil;
  TabSheet4.TabVisible := FCurrentScript = FProjetScript;
  RefreshDescription(FCurrentScript);
end;

procedure TfrmScripts.seScript1KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = ' ') and ((GetKeyState(VK_CONTROL) < 0) or (GetKeyState(VK_SHIFT) < 0)) then
    Key := #0;
end;
{$ENDREGION}

procedure TfrmScripts.WMSyscommand(var msg: TWmSysCommand);
begin
  case (msg.CmdType and $FFF0) of
    SC_CLOSE:
      if not dmScripts.Engine.Running then
        inherited;
    else
      inherited;
  end;
end;

procedure TfrmScripts.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
var
  Editor: TSynEdit;
begin
  if Assigned(FCurrentScript) then
    Editor := FCurrentScript.Editor
  else
    Editor := nil;
  Handled := True;
  actEdit.Enabled := Assigned(ListView1.Selected);

  EditCut1.Enabled := Assigned(Editor) and Editor.Focused and Editor.SelAvail;
  EditCopy1.Enabled := Assigned(Editor) and Editor.Focused and Editor.SelAvail;
  EditPaste1.Enabled := Assigned(Editor) and Editor.Focused and Editor.CanPaste;
  EditUndo1.Enabled := Assigned(Editor) and Editor.Focused and Editor.CanUndo;
  EditRedo1.Enabled := Assigned(Editor) and Editor.Focused and Editor.CanRedo;
  actRun.Enabled := (FProjetOuvert or actEdit.Enabled) and ((dmScripts.Engine = nil) or not dmScripts.Engine.Running or (dmScripts.Engine.DebugMode = UdmScripts.dmPaused));
  actRunWithoutDebug.Visible := dmScripts.AlbumToUpdate;
  actRunWithoutDebug.Enabled := actRunWithoutDebug.Visible and actRun.Enabled and not dmScripts.Engine.Running;
  actPause.Enabled := (dmScripts.Engine <> nil) and dmScripts.Engine.Running and (dmScripts.Engine.DebugMode = UdmScripts.dmRun);
  actCreerOption.Visible := FProjetOuvert;
  actCreerOption.Enabled := FProjetOuvert;
  actRetirerOption.Visible := FProjetOuvert;
  actRetirerOption.Enabled := FProjetOuvert and (ListBox1.ItemIndex <> -1);
  actModifierOption.Visible := FProjetOuvert;
  actModifierOption.Enabled := FProjetOuvert and (ListBox1.ItemIndex <> -1);
  actFermer.Enabled := Assigned(Editor) and (FForceClose or (FCurrentScript <> FProjetScript));
  actEnregistrer.Enabled := Assigned(Editor);
  actReset.Enabled := (dmScripts.Engine <> nil) and dmScripts.Engine.Running and (dmScripts.Engine.DebugMode in [UdmScripts.dmPaused]);
  actCompile.Enabled := (dmScripts.Engine <> nil) and not dmScripts.Engine.Running;

  // sinon les actions court-circuitent les raccouris sur les autres composants
  // mettre les actions enabled := False n'est pas suffisant
  if Assigned(Editor) and Editor.Focused then
  begin
    EditCut1.ShortCut := ShortCut(Ord('X'), [ssCtrl]);
    EditCopy1.ShortCut := ShortCut(Ord('C'), [ssCtrl]);
    EditPaste1.ShortCut := ShortCut(Ord('V'), [ssCtrl]);
    EditUndo1.ShortCut := ShortCut(Ord('Z'), [ssCtrl]);
    EditRedo1.ShortCut := ShortCut(Ord('Y'), [ssCtrl]);
    EditSelectAll1.ShortCut := ShortCut(Ord('A'), [ssCtrl]);
  end
  else
  begin
    EditCut1.ShortCut := 0;
    EditCopy1.ShortCut := 0;
    EditPaste1.ShortCut := 0;
    EditUndo1.ShortCut := 0;
    EditRedo1.ShortCut := 0;
    EditSelectAll1.ShortCut := 0;
  end;
end;

function TfrmScripts.GetProjet: string;
begin
  Result := FProjetScript.ScriptName;
end;

procedure TfrmScripts.SetProjet(const Value: string);
begin
  ProjetOuvert := False;
  LoadScript(Value);
  ProjetOuvert := True;
end;

procedure TfrmScripts.SetProjetOuvert(const Value: Boolean);
begin
  if not Value then
  begin
    FForceClose := True;
    try
      ClearPages;
      Compiled := False;
      dmScripts.DebugPlugin.Messages.Clear;
    finally
      FForceClose := False;
    end;
  end;
  FProjetOuvert := Value;
  tbEdition.TabVisible := Value;
end;

procedure TfrmScripts.SetCompiled(const Value: Boolean);
begin
  FCompiled := Value;
  if Assigned(FCurrentScript) and Assigned(FCurrentScript.Editor) then
  begin
    ClearExecutableLines;
    FCurrentScript.Editor.Invalidate;
  end;
end;

procedure TfrmScripts.FormCreate(Sender: TObject);
begin
  if TGlobalVar.Utilisateur.Options.GrandesIconesBarre then
  begin
    ToolBar1.Images := frmFond.boutons_32x32_norm;
    ToolBar1.HotImages := frmFond.boutons_32x32_hot;
    ToolBar2.Images := frmFond.boutons_32x32_norm;
    ToolBar2.HotImages := frmFond.boutons_32x32_hot;
  end
  else
  begin
    ToolBar1.Images := frmFond.boutons_16x16_norm;
    ToolBar1.HotImages := frmFond.boutons_16x16_hot;
    ToolBar2.Images := frmFond.boutons_16x16_norm;
    ToolBar2.HotImages := frmFond.boutons_16x16_hot;
  end;

  FOpenedScript := TObjectList<TScript>.Create(False);
  dmScripts := TdmScripts.Create;
  dmScripts.Console := mmConsole.Lines;
  dmScripts.DebugPlugin.OnGetScript := GetScript;
  dmScripts.DebugPlugin.Watches.View := vstSuivis;
  dmScripts.DebugPlugin.Messages.View := vstMessages;
  dmScripts.DebugPlugin.Breakpoints.View := vstBreakpoints;
  dmScripts.OnAfterExecute := AfterExecute;
  dmScripts.OnBreakPoint := OnBreakPoint;
  // dmScripts.OnIdle := PSScriptDebugger1Idle;

  FForceClose := False;
  PageControl1.ActivePageIndex := 0;

  LoadScripts;

  PageControl2.ActivePage := tbScripts;
  ProjetOuvert := False;
end;

procedure TfrmScripts.FormDestroy(Sender: TObject);
begin
  ProjetOuvert := False;
  dmScripts.TypeEngine := seNone;
  ClearPages;
  FOpenedScript.Free;
  dmScripts := nil;
end;

procedure TfrmScripts.framBoutons1btnAnnulerClick(Sender: TObject);
begin
  framBoutons1.btnAnnulerClick(Sender);
  if not dmScripts.AlbumToUpdate then
    Release;
end;

procedure TfrmScripts.RefreshDescription(Script: TScript);
begin
  FRefreshingDescription := True;
  try
    if Assigned(Script) then
    begin
      Label5.Caption := Script.ScriptInfos.Auteur;
      EditLabeled1.Text := Script.ScriptInfos.Auteur;

      if Script.ScriptInfos.LastUpdate > 0 then
        Label6.Caption := DateTimeToStr(Script.ScriptInfos.LastUpdate)
      else
        Label6.Caption := '';

      Label8.Caption := Script.ScriptInfos.ScriptVersion;
      EditLabeled2.Text := Script.ScriptInfos.ScriptVersion;

      Label10.Caption := Script.ScriptInfos.BDVersion;
      EditLabeled3.Text := Script.ScriptInfos.BDVersion;

      Memo1.Lines.Text := Script.ScriptInfos.Description;
      MemoLabeled1.Text := Script.ScriptInfos.Description;

      Memo2.Lines.Assign(Script.Alias);
    end
    else
    begin
      Label5.Caption := '';
      Label6.Caption := '';
      Label8.Caption := '';
      Label10.Caption := '';
      Memo1.Lines.Clear;
    end;
  finally
    FRefreshingDescription := False;
  end;
end;

procedure TfrmScripts.RefreshOptions;
begin
  if Assigned(FProjetScript) then
    ListBox1.Count := FProjetScript.Options.Count
  else
    ListBox1.Count := 0;
  ListBox1.Invalidate;
  ListBox2.Count := ListBox1.Count;
  ListBox2.Invalidate;
end;

procedure TfrmScripts.LoadScript(const Script: string);
var
  LockWindow: ILockWindow;
  Info: TScript;
begin
  Info := dmScripts.ScriptList.InfoScriptByScriptName(Script);
  // doit être fait avant la création de page pour s'assurer de l'existence du fichier
  if not Assigned(Info) then
    raise Exception.Create('Impossible de trouver l''unité ' + string(Script) + '.');

  if not Assigned(Info.Editor) then
  begin
    // if not Info.Loaded then
    Info.Load; // on force le rechargement pour être sûr de bien avoir la dernière version

    LockWindow := TLockWindow.Create(pcScripts);

    FOpenedScript.Add(Info);

    Info.TabSheet := TTabSheet.Create(pcScripts);
    Info.TabSheet.PageControl := pcScripts;
    Info.TabSheet.Caption := string(Info.ScriptName);

    Info.Editor := dmScripts.Engine.GetNewEditor(Info.TabSheet);
    Info.Editor.Parent := Info.TabSheet;
    Info.Editor.Align := alClient;
    Info.Editor.Color := clWhite;
    Info.Editor.ActiveLineColor := 16314351;
    Info.Editor.Font.Color := clWindowText;
    Info.Editor.Font.Height := -13;
    Info.Editor.Font.name := 'Courier New';
    Info.Editor.Font.Style := [];
    Info.Editor.Gutter.AutoSize := True;
    Info.Editor.Gutter.DigitCount := 3;
    Info.Editor.Gutter.Font.Color := clWindowText;
    Info.Editor.Gutter.Font.Height := -11;
    Info.Editor.Gutter.Font.name := 'Terminal';
    Info.Editor.Gutter.Font.Style := [];
    Info.Editor.Gutter.LeftOffset := 27;
    Info.Editor.Gutter.ShowLineNumbers := True;
    Info.Editor.Gutter.Width := 0;
    Info.Editor.BorderStyle := bsNone;
    Info.Editor.BevelKind := bkTile;
    Info.Editor.Options := [eoAutoIndent, eoTabIndent, eoSmartTabs, eoAutoSizeMaxScrollWidth, eoDragDropEditing, eoGroupUndo, eoRightMouseMovesCursor, eoScrollPastEol, eoShowScrollHint, eoSmartTabDelete, eoTabIndent, eoTabsToSpaces, eoTrimTrailingSpaces];
    Info.Editor.ScrollHintFormat := shfTopToBottom;
    Info.Editor.SearchEngine := SynEditSearch1;
    Info.Editor.TabWidth := 2;
    Info.Editor.WantTabs := True;
    Info.Editor.OnChange := seScript1Change;
    Info.Editor.OnGutterClick := seScript1GutterClick;
    Info.Editor.OnGutterPaint := seScript1GutterPaint;
    Info.Editor.OnReplaceText := seScript1ReplaceText;
    Info.Editor.OnSpecialLineColors := seScript1SpecialLineColors;
    Info.Editor.OnStatusChange := seScript1StatusChange;
    Info.Editor.OnProcessUserCommand := seScript1ProcessUserCommand;
    Info.Editor.OnKeyPress := seScript1KeyPress;
    Info.Editor.AddKey(ecUserFirst + 1, VK_RETURN, [ssCtrl]);

    TSynDebugPlugin.Create(Info.Editor, dmScripts.DebugPlugin);
    Info.Editor.Lines.Assign(Info.Code);

    Info.SB := TStatusBar.Create(Info.TabSheet);
    Info.SB.Parent := Info.TabSheet;
    Info.SB.Panels.Add.Width := 50;
    Info.SB.Panels.Add.Width := 50;
    Info.SB.Panels.Add.Width := 50;

    Info.TabSheet.Visible := True;
  end;
  GoToPosition(Info.Editor, 1, 1);
end;

procedure TfrmScripts.LoadScripts;
var
  Script: TScript;
begin
  ListView1.Items.BeginUpdate;
  try
    ListView1.Items.Clear;
    dmScripts.ScriptList.LoadDir(RepScripts);
    for Script in dmScripts.ScriptList do
      if Script.ScriptKind = skMain then
        with ListView1.Items.Add do
        begin
          Data := Script;
          Caption := string(Script.ScriptName);
        end;
  finally
    ListView1.Items.EndUpdate;
  end;
  ListView1.OnSelectItem(ListView1, nil, False);
end;

procedure TfrmScripts.ClearPages;
var
  i: Integer;
begin
  for i := 0 to Pred(pcScripts.PageCount) do
    actFermer.Execute;
end;
{$REGION 'Débuggage'}

procedure TfrmScripts.actStepOverExecute(Sender: TObject);
begin
  // if dmScripts.PSScriptDebugger1.Exec.Status = isRunning then
  if dmScripts.Engine.Running then
    dmScripts.Engine.StepOver
  else
  begin
    if Compile then
    begin
      dmScripts.Engine.StepInto;
      Execute;
    end;
  end;
end;

procedure TfrmScripts.actStepIntoExecute(Sender: TObject);
begin
  if dmScripts.Engine.Running then
    dmScripts.Engine.StepInto
  else
  begin
    if Compile then
    begin
      dmScripts.Engine.StepInto;
      Execute;
    end;
  end;
end;

procedure TfrmScripts.actModifierOptionExecute(Sender: TObject);
begin
  if EditOption(FProjetScript.Options[ListBox1.ItemIndex]) then
    RefreshOptions;
end;

procedure TfrmScripts.actPauseExecute(Sender: TObject);
begin
  dmScripts.Engine.Pause;
  GoToPosition(dmScripts.Engine.ActiveFile, dmScripts.Engine.ActiveLine, 1);
end;

procedure TfrmScripts.actResetExecute(Sender: TObject);
begin
  if dmScripts.Engine.Running then
    dmScripts.Engine.Stop;
end;

procedure TfrmScripts.actRetirerOptionExecute(Sender: TObject);
begin
  FProjetScript.Options.Delete(ListBox1.ItemIndex);
  FProjetScript.Modifie := True;
  RefreshOptions;
end;

procedure TfrmScripts.actDecompileExecute(Sender: TObject);
begin
  if Compile then
  begin
    dmScripts.Engine.GetUncompiledCode(mmConsole.Lines);
    PageControl1.ActivePage := TTabSheet(mmConsole.Parent);
  end;
end;

procedure TfrmScripts.actBreakpointExecute(Sender: TObject);
begin
  dmScripts.ToggleBreakPoint(FCurrentScript.ScriptName, FCurrentScript.Editor.CaretY, False);
end;

procedure TfrmScripts.actAddSuiviExecute(Sender: TObject);
begin
  dmScripts.DebugPlugin.Watches.AddWatch(FCurrentScript.Editor.WordAtCursor);
end;

procedure TfrmScripts.actRunToCursorExecute(Sender: TObject);
begin
  dmScripts.Engine.setRunTo(FCurrentScript.Editor.CaretY, FCurrentScript.ScriptName);
  actRun.Execute;
end;

procedure TfrmScripts.vstSuivisNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: UnicodeString);
begin
  dmScripts.DebugPlugin.Watches[Node.index].name := NewText;
  dmScripts.DebugPlugin.Watches.View.InvalidateNode(Node);
end;

procedure TfrmScripts.vstSuivisEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := Column = 0;
end;

procedure TfrmScripts.vstSuivisInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  Node.CheckType := ctCheckBox;
  if dmScripts.DebugPlugin.Watches[Node.index].Active then
    Node.CheckState := csCheckedNormal
  else
    Node.CheckState := csUncheckedNormal;
end;

procedure TfrmScripts.vstSuivisChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  dmScripts.DebugPlugin.Watches[Node.index].Active := Node.CheckState = csCheckedNormal;
  dmScripts.DebugPlugin.Watches.View.InvalidateNode(Node);
end;

procedure TfrmScripts.vstSuivisGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
begin
  if Column = -1 then
    Column := 0;
  with dmScripts.DebugPlugin.Watches[Node.index] do
    case Column of
      0:
        CellText := string(name);
      1:
        if not Active then
          CellText := '<désactivé>'
        else
          CellText := dmScripts.Engine.GetVariableValue(name);
    end;
end;

procedure TfrmScripts.vstSuivisPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
begin
  if Node.CheckState = csCheckedNormal then
    TargetCanvas.Font.Color := clWindowText
  else
    TargetCanvas.Font.Color := clGrayText;
end;

procedure TfrmScripts.GoToMessage(msg: TMessageInfo);
var
  Editor: TSynEdit;
begin
  if msg = nil then
    Exit;

  Editor := GetScript(msg.Fichier);
  if not Assigned(Editor) then
    LoadScript(msg.Fichier);
  GoToPosition(msg.Fichier, msg.Line, msg.Char);
  PageControl1.ActivePage := TTabSheet(vstMessages.Parent);
end;

procedure TfrmScripts.vstMessagesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
begin
  if Column = -1 then
    Column := 0;
  with dmScripts.DebugPlugin.Messages[Node.index] do
    case Column of
      0:
        case Category of
          cmInfo:
            CellText := 'Information';
          cmCompileError:
            CellText := 'Compilation';
          cmRuntimeError:
            CellText := 'Exécution';
          else
            CellText := '';
        end;
      1:
        CellText := string(TypeMessage);
      2:
        if Fichier = dmScripts.Engine.GetMainSpecialName then
          CellText := Projet
        else
          CellText := string(Fichier);
      3:
        CellText := string(Text);
    end;
end;

procedure TfrmScripts.vstMessagesDblClick(Sender: TObject);
begin
  GoToMessage(dmScripts.DebugPlugin.Messages.Current);
end;

procedure TfrmScripts.vstBreakpointsDblClick(Sender: TObject);
begin
  GoToBreakpoint(dmScripts.DebugPlugin.Breakpoints.Current);
end;

procedure TfrmScripts.GoToBreakpoint(msg: TBreakpointInfo);
var
  Editor: TSynEdit;
begin
  Editor := GetScript(msg.Fichier);
  if not Assigned(Editor) then
    LoadScript(msg.Fichier);
  GoToPosition(msg.Fichier, msg.Line, 0);
  PageControl1.ActivePage := TTabSheet(vstBreakpoints.Parent);
end;

procedure TfrmScripts.GoToPosition(Script: string; Line, Char: Cardinal);
var
  Editor: TSynEdit;
begin
  Editor := GetScript(Script);
  if not Assigned(Editor) then
  begin
    // pas besoin de convertir ActiveFile puisque si Script = GetMainSpecialName, GetScript aura forcément trouvé l'editeur du projet
    LoadScript(dmScripts.Engine.ActiveFile);
    Editor := GetScript(dmScripts.Engine.ActiveFile);
  end;
  GoToPosition(Editor, Line, Char);
end;

procedure TfrmScripts.GoToPosition(Editor: TSynEdit; Line, Char: Cardinal);
begin
  if not Assigned(Editor) then
    Exit;

  if (Line < Cardinal(Editor.TopLine + 2)) or (Line > Cardinal(Editor.TopLine + Editor.LinesInWindow - 2)) then
    Editor.TopLine := Line - Cardinal(Editor.LinesInWindow div 2);

  Editor.CaretY := Line;
  Editor.CaretX := Char;
  Editor.Invalidate; // Line et GutterLine sont insuffisants pour certains cas
  PageControl2.ActivePage := tbEdition;
  pcScripts.ActivePage := TTabSheet(Editor.Parent);
  pcScriptsChange(nil);
  Editor.SetFocus;
end;

procedure TfrmScripts.vstBreakpointsChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  with dmScripts.DebugPlugin.Breakpoints[Node.index] do
    dmScripts.ToggleBreakPoint(Fichier, Line, True);
  dmScripts.DebugPlugin.Breakpoints.View.InvalidateNode(Node);
end;

procedure TfrmScripts.vstBreakpointsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
begin
  if Column = -1 then
    Column := 0;
  with dmScripts.DebugPlugin.Breakpoints[Node.index] do
    case Column of
      0:
        CellText := 'Ligne ' + SysUtils.IntToStr(Line);
      1:
        if Fichier = dmScripts.Engine.GetMainSpecialName then
          CellText := Projet
        else
          CellText := string(Fichier);
    end;
end;

procedure TfrmScripts.vstBreakpointsInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  Node.CheckType := ctCheckBox;
  if dmScripts.DebugPlugin.Breakpoints[Node.index].Active then
    Node.CheckState := csCheckedNormal
  else
    Node.CheckState := csUncheckedNormal;
end;

procedure TfrmScripts.vstBreakpointsPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
begin
  if Node.CheckState = csCheckedNormal then
    TargetCanvas.Font.Color := clWindowText
  else
    TargetCanvas.Font.Color := clGrayText;
end;

{$ENDREGION}
{$REGION 'Exécution'}

procedure TfrmScripts.actCompileExecute(Sender: TObject);
begin
  if not dmScripts.Engine.Running then
    Compile;
end;

function TfrmScripts.EditOption(Option: TOption): Boolean;
var
  s: string;
begin
  with TfrmScriptEditOption.Create(nil) do
    try
      EditLabeled1.Text := Option.FLibelle;
      MemoLabeled1.Lines.Text := StringReplace(Option.FValues, '|', sLineBreak, [rfReplaceAll]);
      EditLabeled2.Text := Option.FDefaultValue;

      Result := ShowModal = mrOk;
      if Result then
      begin
        Option.FLibelle := EditLabeled1.Text;
        s := MemoLabeled1.Lines.Text;
        while EndsText(sLineBreak, s) do
          Delete(s, Length(s) - Length(sLineBreak) + 1, Length(sLineBreak));
        s := StringReplace(s, sLineBreak, '|', [rfReplaceAll]);
        Option.FValues := s;
        Option.FDefaultValue := EditLabeled2.Text;

        FProjetScript.Modifie := True;
      end;
    finally
      Free;
    end;
end;

procedure TfrmScripts.actCreerOptionExecute(Sender: TObject);
var
  Option: TOption;
begin
  Option := TOption.Create;
  if EditOption(Option) then
  begin
    Option.ChooseValue := Option.FDefaultValue;
    FProjetScript.Options.Add(Option);
    RefreshOptions;
  end
  else
    Option.Free;
end;

procedure TfrmScripts.actRunExecute(Sender: TObject);
begin
  if dmScripts.Engine.Running then
  begin
    dmScripts.Engine.ActiveLine := 0;
    dmScripts.Engine.ActiveFile := '';
    FCurrentScript.Editor.Refresh;
    dmScripts.Engine.Resume;
  end
  else
  begin
    if Compile then
      Execute;
  end;
end;

function TfrmScripts.Execute: Boolean;
begin
  Result := dmScripts.Engine.Run;
  if (dmScripts.DebugPlugin.Messages.Count > 0) then
    GoToMessage(dmScripts.DebugPlugin.Messages.Last);
  if not Result then
  begin
    (*
      try
      dmScripts.PSScriptDebugger1.Exec.RaiseCurrentException;
      except
      on e: EPSException do
      Application.HandleException(nil);
      else
      raise;
      end;
    *)
  end;
end;

procedure TfrmScripts.PSScriptDebugger1Idle(Sender: TObject);
begin
  frmFond.MergeMenu(Menu);
end;

procedure TfrmScripts.AfterExecute;
begin
  if pcScripts.PageCount > 0 then
    FCurrentScript.Editor.Refresh;
  PageControl1.ActivePage := TTabSheet(mmConsole.Parent);
  frmFond.MergeMenu(Menu);
  if dmScripts.AlbumToUpdate then
    ModalResult := mrOk;
end;

function TfrmScripts.Compile: Boolean;
var
  msg: TMessageInfo;
begin
  Result := dmScripts.Engine.Compile(FProjetScript, msg);
  Compiled := Result;
  if Assigned(msg) then
    GoToMessage(msg);
  ShowExecutableLines;
end;

procedure TfrmScripts.actRunWithoutDebugExecute(Sender: TObject);
begin
  dmScripts.Engine.UseDebugInfo := False;
  try
    if Compile then
      Execute;
  finally
    dmScripts.Engine.UseDebugInfo := True;
  end;
end;
{$ENDREGION}

function TfrmScripts.IsExecutableLine(aLine: Integer): Boolean;
begin
  if aLine < Length(FCurrentScript.Editor.FExecutableLines) then
    Result := FCurrentScript.Editor.FExecutableLines[aLine]
  else
    Result := False;
end;

procedure TfrmScripts.ClearExecutableLines;
var
  i: Integer;
begin
  for i := 0 to Length(FCurrentScript.Editor.FExecutableLines) - 1 do
    FCurrentScript.Editor.FExecutableLines[i] := False;
  FCurrentScript.Editor.InvalidateGutter;
end;

procedure TfrmScripts.InitExecutableLines;
begin
  SetLength(FCurrentScript.Editor.FExecutableLines, 0);
  SetLength(FCurrentScript.Editor.FExecutableLines, FCurrentScript.Editor.Lines.Count);
end;

procedure TfrmScripts.ShowExecutableLines;
var
  LineNumbers: TLineNumbers;
  i: Integer;
begin
  ClearExecutableLines;
  if Compiled then
  begin
    if PageControl1.ActivePageIndex = 0 then
      LineNumbers := dmScripts.Engine.GetExecutableLines(dmScripts.Engine.GetMainSpecialName)
    else
      LineNumbers := dmScripts.Engine.GetExecutableLines(FCurrentScript.ScriptName);
    for i := 0 to Length(LineNumbers) - 1 do
      FCurrentScript.Editor.FExecutableLines[LineNumbers[i]] := True;
  end;
  FCurrentScript.Editor.InvalidateGutter;
end;

procedure TfrmScripts.OnBreakPoint;
begin
  vstSuivis.Invalidate;
  GoToPosition(dmScripts.Engine.ActiveFile, dmScripts.Engine.ActiveLine, 0);
end;

end.
