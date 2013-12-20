unit UScriptUtils;

interface

uses
  SysUtils, Classes, Graphics, Types, StdCtrls, SynEdit, Controls, VirtualTrees, uPSCompiler, uPSUtils,
  Generics.Collections, Generics.Defaults, UScriptEditor, UScriptEngineIntf, UScriptList;

type
  TDebugList<I: IDebugItem> = class(TList<I>, IDebugList<I>)
  private
    FGetScriptEditorCallback: TGetScriptEditorCallback;
    FView: TVirtualStringTree;
    FDebugInfos: Pointer;
    function GetView: TVirtualStringTree;
    procedure SetView(const Value: TVirtualStringTree);
    function ItemCount: Integer;
    function GetDebugInfos: IDebugInfos;
  protected
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function GetItemInterface(Index: Integer): I;
    procedure Notify(const Value: I; Action: TCollectionNotification); override;
  public
    constructor Create(DebugInfos: IDebugInfos);
    destructor Destroy; override;
    procedure Clear; reintroduce;
    procedure UpdateView;
    procedure DeleteCurrent;
    function Current: I;
    function Last: I;

    property GetScriptEditorCallback: TGetScriptEditorCallback read FGetScriptEditorCallback write FGetScriptEditorCallback;
    property DebugInfos: IDebugInfos read GetDebugInfos;
  end;

  TDebugItem<I: IDebugItem> = class abstract(TInterfacedObject)
  public
    List: TDebugList<I>;
    constructor Create(List: TDebugList<I>);
  end;

  TPositionnedDebugItem<I: IPositionnedDebugItem> = class(TDebugItem<I>)
  private
    FScript: TScript;
    FLine: Cardinal;
    function GetScript: TScript;
    procedure SetScript(const Value: TScript);
    function GetLine: Cardinal;
    procedure SetLine(const Value: Cardinal);
  public
    property Script: TScript read GetScript write SetScript;
    property Line: Cardinal read GetLine write SetLine;
  end;

  TBreakpointInfo = class(TPositionnedDebugItem<IBreakpointInfo>, IBreakpointInfo)
  private
    FActive: Boolean;
    procedure UpdateEditor;
    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
  public
    destructor Destroy; override;

    property Active: Boolean read GetActive write SetActive;
  end;

  TMessageInfo = class(TPositionnedDebugItem<IMessageInfo>, IMessageInfo)
  private
    FTypeMessage, FText: string;
    FChar: Cardinal;
    FCategory: TCategoryMessage;

    function GetTypeMessage: string;
    procedure SetTypeMessage(const Value: string);
    function GetText: string;
    procedure SetText(const Value: string);
    function GetChar: Cardinal;
    procedure SetChar(const Value: Cardinal);
    function GetCategory: TCategoryMessage;
    procedure SetCategory(const Value: TCategoryMessage);
  public
    property TypeMessage: string read GetTypeMessage write SetTypeMessage;
    property Text: string read GetText write SetText;
    property Char: Cardinal read GetChar write SetChar;
    property Category: TCategoryMessage read GetCategory write SetCategory;
  end;

  TWatchInfo = class(TDebugItem<IWatchInfo>, IWatchInfo)
  private
    FName: string;
    FActive: Boolean;
    function GetName: string;
    procedure SetName(const Value: string);
    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
  public
    property Name: string read GetName write SetName;
    property Active: Boolean read GetActive write SetActive;
  end;

  TWatchList = class(TDebugList<IWatchInfo>, IWatchList)
  public
    function IndexOfName(const VarName: string): Integer;
    function CountActive: Integer;
    procedure AddWatch(const VarName: string);
  end;

  TMessageList = class(TDebugList<IMessageInfo>, IMessageList)
  public
    function AddCompileErrorMessage(const Fichier, Text: string; TypeMessage: TTypeMessage; Line, Char: Cardinal): Integer;
    function AddRuntimeErrorMessage(const Fichier, Text: string; Line, Char: Cardinal): Integer;
    function AddInfoMessage(const Fichier, Text: string; Line: Cardinal = 0; Char: Cardinal = 0): Integer;
  end;

  TBreakpointList = class(TDebugList<IBreakpointInfo>, IBreakpointList)
  protected
    procedure Notify(const Value: IBreakpointInfo; Action: TCollectionNotification); override;
  public
    function IndexOf(Script: TScript; const ALine: Cardinal): Integer;
    function Exists(Script: TScript; const ALine: Cardinal): Boolean;
    procedure AddBreakpoint(Script: TScript; const ALine: Cardinal);
    function Toggle(Script: TScript; const ALine: Cardinal): Boolean;
  end;

  TDebugInfos = class(TInterfacedObject, IDebugInfos)
  private
    FMasterEngine: Pointer;

    FCurrentLine: Integer;
    FCursorLine: Integer;
    FErrorLine: Integer;

    FBreakpointsList: TBreakpointList;
    FWatchesList: TWatchList;
    FMessagesList: TMessageList;

    procedure SetCurrentLine(const Value: Integer);
    function GetCurrentLine: Integer;
    procedure SetCursorLine(const Value: Integer);
    function GetCursorLine: Integer;
    procedure SetErrorLine(const Value: Integer);
    function GetErrorLine: Integer;

    function GetBreakpointsList: IBreakpointList;
    function GetWatchesList: IWatchList;
    function GetMessagesList: IMessageList;

    function GetOnGetScriptEditor: TGetScriptEditorCallback;
    procedure SetOnGetScriptEditor(const Value: TGetScriptEditorCallback);

    function GetMasterEngine: IMasterEngine;
  public
    constructor Create(MasterEngine: IMasterEngine);
    destructor Destroy; override;

    property MasterEngine: IMasterEngine read GetMasterEngine;

    property CurrentLine: Integer read GetCurrentLine write SetCurrentLine;
    property CursorLine: Integer read GetCursorLine write SetCursorLine;
    property ErrorLine: Integer read GetErrorLine write SetErrorLine;

    property Breakpoints: IBreakpointList read GetBreakpointsList;
    property Watches: IWatchList read GetWatchesList;
    property Messages: IMessageList read GetMessagesList;
    property OnGetScriptEditor: TGetScriptEditorCallback read GetOnGetScriptEditor write SetOnGetScriptEditor;
  end;

implementation

{ TBreakpointList }

function TBreakpointList.Exists(Script: TScript; const ALine: Cardinal): Boolean;
begin
  Result := IndexOf(Script, ALine) <> -1;
end;

procedure TBreakpointList.AddBreakpoint(Script: TScript; const ALine: Cardinal);
var
  BP: TBreakpointInfo;
begin
  if (IndexOf(Script, ALine) = -1) then
  begin
    BP := TBreakpointInfo.Create(Self);
    BP.Line := ALine;
    BP.Script := Script;
    BP.Active := True;
    Add(BP);
  end;
end;

function TBreakpointList.IndexOf(Script: TScript; const ALine: Cardinal): Integer;
begin
  Result := 0;
  while (Result < Count) and ((Items[Result].Line <> ALine) or (Items[Result].Script <> Script)) do
    Inc(Result);
  if Result = Count then
    Result := -1;
end;

procedure TBreakpointList.Notify(const Value: IBreakpointInfo; Action: TCollectionNotification);
var
  Editor: TScriptEditor;
begin
  inherited;
  case Action of
    cnAdded, cnExtracted:
      begin
        Editor := nil;
        // InvalidateLine et InvalidateGutterLine bizarrement insuffisants dans certains cas
        if Assigned(GetScriptEditorCallback) then
          Editor := GetScriptEditorCallback(Value.Script);
        if Assigned(Editor) then
        begin
          Editor.Invalidate;
          // Editor.InvalidateLine(Value.Line);
          // Editor.InvalidateGutterLine(Value.Line);
        end;
      end;
    cnRemoved:
      ;
  end;

  if Action = cnAdded then
    Sort(TComparer<IBreakpointInfo>.Construct(
      function(const Left, Right: IBreakpointInfo): Integer
      begin
        Result := CompareText(Left.Script.ScriptUnitName, Right.Script.ScriptUnitName);
        if Result = 0 then
          Result := Left.Line - Right.Line;
      end));
end;

function TBreakpointList.Toggle(Script: TScript; const ALine: Cardinal): Boolean;
var
  I: Integer;
begin
  I := IndexOf(Script, ALine);
  if I = -1 then
  begin
    AddBreakpoint(Script, ALine);
    Result := True;
  end
  else
  begin
    Delete(I);
    Result := False;
  end;
end;

{ TDebugInfos }

constructor TDebugInfos.Create(MasterEngine: IMasterEngine);
begin
  inherited Create;
  FMasterEngine := Pointer(MasterEngine);
  FBreakpointsList := TBreakpointList.Create(Self);
  FWatchesList := TWatchList.Create(Self);
  FMessagesList := TMessageList.Create(Self);
end;

destructor TDebugInfos.Destroy;
begin
  FBreakpointsList.Free;
  FWatchesList.Free;
  FMessagesList.Free;
  inherited;
end;

function TDebugInfos.GetBreakpointsList: IBreakpointList;
begin
  Result := FBreakpointsList;
end;

function TDebugInfos.GetCurrentLine: Integer;
begin
  Result := FCurrentLine;
end;

function TDebugInfos.GetCursorLine: Integer;
begin
  Result := FCursorLine;
end;

function TDebugInfos.GetErrorLine: Integer;
begin
  Result := FErrorLine;
end;

function TDebugInfos.GetMasterEngine: IMasterEngine;
begin
  Result := IMasterEngine(FMasterEngine);
end;

function TDebugInfos.GetMessagesList: IMessageList;
begin
  Result := FMessagesList;
end;

function TDebugInfos.GetOnGetScriptEditor: TGetScriptEditorCallback;
begin
  Result := FBreakpointsList.GetScriptEditorCallback;
end;

function TDebugInfos.GetWatchesList: IWatchList;
begin
  Result := FWatchesList;
end;

procedure TDebugInfos.SetCurrentLine(const Value: Integer);
begin
  FCurrentLine := Value;
end;

procedure TDebugInfos.SetCursorLine(const Value: Integer);
begin
  FCursorLine := Value;
end;

procedure TDebugInfos.SetErrorLine(const Value: Integer);
begin
  FErrorLine := Value;
end;

procedure TDebugInfos.SetOnGetScriptEditor(const Value: TGetScriptEditorCallback);
begin
  FBreakpointsList.GetScriptEditorCallback := Value;
  FWatchesList.GetScriptEditorCallback := Value;
  FMessagesList.GetScriptEditorCallback := Value;
end;

{ TDebugList }

procedure TDebugList<I>.Clear;
begin
  if Assigned(FView) then
    FView.BeginUpdate;
  try
    inherited;
  finally
    UpdateView;
    if Assigned(FView) then
      FView.EndUpdate;
  end;
end;

constructor TDebugList<I>.Create(DebugInfos: IDebugInfos);
begin
  inherited Create;
  FDebugInfos := Pointer(DebugInfos);
end;

function TDebugList<I>.Current: I;
begin
  Result := nil;
  if not Assigned(FView) or (FView.GetFirstSelected = nil) then
    Exit;
  Result := GetItemInterface(FView.GetFirstSelected.Index);
end;

procedure TDebugList<I>.DeleteCurrent;
begin
  if Assigned(FView) then
  begin
    Delete(FView.GetFirstSelected.Index);
    UpdateView;
  end;
end;

destructor TDebugList<I>.Destroy;
begin
  SetView(nil);
  inherited;
end;

function TDebugList<I>.GetDebugInfos: IDebugInfos;
begin
  Result := IDebugInfos(FDebugInfos);
end;

function TDebugList<I>.GetItemInterface(Index: Integer): I;
begin
  Result := Items[Index];
end;

function TDebugList<I>.GetView: TVirtualStringTree;
begin
  Result := FView;
end;

function TDebugList<I>.ItemCount: Integer;
begin
  Result := Count;
end;

function TDebugList<I>.Last: I;
begin
  if Count > 0 then
    Result := GetItemInterface(Count - 1)
  else
    Result := nil;
end;

procedure TDebugList<I>.Notify(const Value: I; Action: TCollectionNotification);
begin
  inherited;
  case Action of
    cnAdded, cnExtracted, cnRemoved:
      UpdateView;
  end;
end;

function TDebugList<I>.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

procedure TDebugList<I>.SetView(const Value: TVirtualStringTree);
begin
  if Assigned(FView) then
    FView.RootNodeCount := 0;
  FView := Value;
  if Assigned(FView) then
    FView.RootNodeCount := Count;
end;

procedure TDebugList<I>.UpdateView;
begin
  if not Assigned(FView) then
    Exit;
  FView.RootNodeCount := Count;
  FView.Invalidate;
end;

function TDebugList<I>._AddRef: Integer;
begin
  Result := 1;
end;

function TDebugList<I>._Release: Integer;
begin
  Result := 0;
end;

{ TWatchList }

procedure TWatchList.AddWatch(const VarName: string);
var
  Watch: TWatchInfo;
begin
  if (VarName <> '') and (IndexOfName(VarName) = -1) then
  begin
    Watch := TWatchInfo.Create(Self);
    Watch.FName := VarName;
    Watch.FActive := True;
    Add(Watch);
  end;
end;

function TWatchList.CountActive: Integer;
var
  Watch: IWatchInfo;
begin
  Result := 0;
  for Watch in Self do
    if Watch.Active then
      Inc(Result);
end;

function TWatchList.IndexOfName(const VarName: string): Integer;
begin
  Result := 0;
  while (Result < Count) and not SameText(Items[Result].Name, VarName) do
    Inc(Result);
  if Result = Count then
    Result := -1;
end;

{ TMessageList }

function TMessageList.AddCompileErrorMessage(const Fichier, Text: string; TypeMessage: TTypeMessage; Line, Char: Cardinal): Integer;
var
  Msg: TMessageInfo;
begin
  Msg := TMessageInfo.Create(Self);
  Result := Add(Msg);
  case TypeMessage of
    tmError:
      Msg.FTypeMessage := 'Erreur';
    tmWarning:
      Msg.FTypeMessage := 'Avertissement';
    tmHint:
      Msg.FTypeMessage := 'Conseil';
  end;
  Msg.FScript := DebugInfos.MasterEngine.ScriptList.FindScriptByUnitName(Fichier);
  Msg.FText := Text;
  Msg.FLine := Line;
  Msg.FChar := Char;
  Msg.FCategory := cmCompileError;
end;

function TMessageList.AddInfoMessage(const Fichier, Text: string; Line, Char: Cardinal): Integer;
var
  Msg: TMessageInfo;
begin
  Msg := TMessageInfo.Create(Self);
  Result := Add(Msg);
  Msg.FTypeMessage := 'Information';
  Msg.FScript := DebugInfos.MasterEngine.ScriptList.FindScriptByUnitName(Fichier);
  Msg.FText := Text;
  Msg.FLine := Line;
  Msg.FChar := Char;
  Msg.FCategory := cmInfo;
end;

function TMessageList.AddRuntimeErrorMessage(const Fichier, Text: string; Line, Char: Cardinal): Integer;
var
  Msg: TMessageInfo;
begin
  Msg := TMessageInfo.Create(Self);
  Result := Add(Msg);
  Msg.FTypeMessage := 'Erreur';
  Msg.FScript := DebugInfos.MasterEngine.ScriptList.FindScriptByUnitName(Fichier);
  Msg.FText := Text;
  Msg.FLine := Line;
  Msg.FChar := Char;
  Msg.FCategory := cmRuntimeError;
end;

{ TBreakpointInfo }

destructor TBreakpointInfo.Destroy;
begin
  UpdateEditor;
  inherited;
end;

function TBreakpointInfo.GetActive: Boolean;
begin
  Result := FActive;
end;

procedure TBreakpointInfo.SetActive(const Value: Boolean);
begin
  FActive := Value;
  UpdateEditor;
end;

{ TDebugItem }

constructor TDebugItem<I>.Create(List: TDebugList<I>);
begin
  // inherited;
  Self.List := List;
end;

procedure TBreakpointInfo.UpdateEditor;
var
  Editor: TScriptEditor;
begin
  Editor := nil;
  if Assigned(List.GetScriptEditorCallback) then
    Editor := List.GetScriptEditorCallback(Script);
  if Editor <> nil then
  begin
    Editor.InvalidateLine(Line);
    Editor.InvalidateGutterLine(Line);
  end;
end;

{ TMessageInfo }

function TMessageInfo.GetCategory: TCategoryMessage;
begin
  Result := FCategory;
end;

function TMessageInfo.GetChar: Cardinal;
begin
  Result := FChar;
end;

function TMessageInfo.GetText: string;
begin
  Result := FText;
end;

function TMessageInfo.GetTypeMessage: string;
begin
  Result := FTypeMessage;
end;

procedure TMessageInfo.SetCategory(const Value: TCategoryMessage);
begin
  FCategory := Value;
end;

procedure TMessageInfo.SetChar(const Value: Cardinal);
begin
  FChar := Value;
end;

procedure TMessageInfo.SetText(const Value: string);
begin
  FText := Value;
end;

procedure TMessageInfo.SetTypeMessage(const Value: string);
begin
  FTypeMessage := Value;
end;

{ TWatchInfo }

function TWatchInfo.GetActive: Boolean;
begin
  Result := FActive;
end;

function TWatchInfo.GetName: string;
begin
  Result := FName;
end;

procedure TWatchInfo.SetActive(const Value: Boolean);
begin
  FActive := Value;
end;

procedure TWatchInfo.SetName(const Value: string);
begin
  FName := Value;
end;

{ TPositionnedDebugItem<I> }

function TPositionnedDebugItem<I>.GetLine: Cardinal;
begin
  Result := FLine;
end;

function TPositionnedDebugItem<I>.GetScript: TScript;
begin
  Result := FScript;
end;

procedure TPositionnedDebugItem<I>.SetLine(const Value: Cardinal);
begin
  FLine := Value;
end;

procedure TPositionnedDebugItem<I>.SetScript(const Value: TScript);
begin
  FScript := Value;
end;

end.
