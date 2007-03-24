unit Unit5;

interface

uses
  SysUtils, Classes, Graphics, Types, StdCtrls, SynEdit, Controls, VirtualTrees, Contnrs;

type
  TDebugList = class(TObjectList)
  private
    FView: TVirtualStringTree;
    procedure SetView(const Value: TVirtualStringTree);
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    procedure UpdateView;
    procedure DeleteCurrent;
    property View: TVirtualStringTree read FView write SetView;
  end;

  TBreakpointInfo = class
  private
    FActive: Boolean;
    FEditor: TCustomSynEdit;
    procedure SetActive(const Value: Boolean);
  public
    Line: Cardinal;
    constructor Create(Editor: TCustomSynEdit);
  published
    property Active: Boolean read FActive write SetActive;
  end;

  TCategoryMessage = (cmInfo, cmCompileError, cmRuntimeError);
  TTypeMessage = (tmUnknown, tmError, tmHint, tmWarning);

  TMessageInfo = class
    TypeMessage, Text: string;
    Line, Char: Cardinal;
    Category: TCategoryMessage;
  end;

  TWatchInfo = class
    Name: string;
    Active: Boolean;
  end;

  TWatchList = class(TDebugList)
  private
    function GetInfo(Index: Integer): TWatchInfo;
    procedure PutInfo(Index: Integer; const Value: TWatchInfo);
  public
    property Items[Index: Integer]: TWatchInfo read GetInfo write PutInfo; default;
  published
    function IndexOfName(const VarName: string): Integer;
    procedure AddWatch(const VarName: string);
  end;

  TMessageList = class(TDebugList)
  private
    function GetInfo(Index: Integer): TMessageInfo;
    procedure PutInfo(Index: Integer; const Value: TMessageInfo);
  public
    property Items[Index: Integer]: TMessageInfo read GetInfo write PutInfo; default;
  published
    function AddCompileErrorMessage(const Text: string; TypeMessage: TTypeMessage; Line, Char: Cardinal): Integer;
    function AddRuntimeErrorMessage(const Text: string; Line, Char: Cardinal): Integer;
    function AddInfoMessage(const Text: string; Line: Cardinal = 0; Char: Cardinal = 0): Integer;
    function Current: TMessageInfo;
    function Last: TMessageInfo;
  end;

  TBreakpointList = class(TDebugList)
  private
    FEditor: TCustomSynEdit;
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
    function GetInfo(Index: Integer): TBreakpointInfo;
    procedure PutInfo(Index: Integer; const Value: TBreakpointInfo);
  public
    function IndexOf(const ALine: Cardinal): Integer;
    function Exists(const ALine: Cardinal): Boolean;
    procedure AddBreakpoint(const ALine: Cardinal);
    function Toggle(const ALine: Cardinal): Boolean;
    property Items[Index: Integer]: TBreakpointInfo read GetInfo write PutInfo; default;
    function Current: TBreakpointInfo;

    property Editor: TCustomSynEdit read FEditor write FEditor;
  end;

  TDebugPlugin = class(TSynEditPlugin)
  private
    FCurrentLine: Integer;
    FCursorLine: Integer;
    FErrorLine: Integer;

    FBreakpointsList: TBreakpointList;
    FWatchesList: TWatchList;
    FMessagesList: TMessageList;
  protected
    procedure AfterPaint(ACanvas: TCanvas; const AClip: TRect; FirstLine, LastLine: Integer); override;
    procedure LinesInserted(FirstLine, Count: Integer); override;
    procedure LinesDeleted(FirstLine, Count: Integer); override;
  public
    constructor Create(AOwner: TCustomSynEdit);
    destructor Destroy; override;

    property CurrentLine: Integer read FCurrentLine write FCurrentLine;
    property CursorLine: Integer read FCursorLine write FCursorLine;
    property ErrorLine: Integer read FErrorLine write FErrorLine;

    property Breakpoints: TBreakpointList read FBreakpointsList;
    property Watches: TWatchList read FWatchesList;
    property Messages: TMessageList read FMessagesList;
  end;

implementation

{ TBreakpointList }

function TBreakpointList.IndexOf(const ALine: Cardinal): Integer;
begin
  Result := 0;
  while (Result < Count) and (TBreakpointInfo(Items[Result]).Line <> ALine) do
    Inc(Result);
  if Result = Count then
    Result := -1;
end;

function TBreakpointList.Exists(const ALine: Cardinal): Boolean;
begin
  Result := IndexOf(ALine) <> -1;
end;

function TBreakpointList.GetInfo(Index: Integer): TBreakpointInfo;
begin
  Result := TBreakpointInfo(inherited Items[Index]);
end;

procedure TBreakpointList.PutInfo(Index: Integer; const Value: TBreakpointInfo);
begin
  Put(Index, Pointer(Value));
end;

function TBreakpointList.Toggle(const ALine: Cardinal): Boolean;
var
  i: Integer;
begin
  i := IndexOf(ALine);
  if i = -1 then
  begin
    AddBreakpoint(ALine);
    Result := True;
  end
  else
  begin
    Delete(i);
    Result := False;
  end;
end;

function TBreakpointList.Current: TBreakpointInfo;
begin
  Result := nil;
  if not Assigned(FView) or (FView.GetFirstSelected = nil) then Exit;
  Result := Items[FView.GetFirstSelected.Index];
end;

procedure TBreakpointList.AddBreakpoint(const ALine: Cardinal);
var
  BP: TBreakpointInfo;
begin
  if (IndexOf(ALine) = -1) then
  begin
    BP := TBreakpointInfo.Create(Editor);
    BP.Line := ALine;
    BP.Active := True;
    Add(BP);
  end;
end;

function CompareBreakpoint(Item1, Item2: Pointer): Integer;
begin
  Result := TBreakpointInfo(Item1).Line - TBreakpointInfo(Item2).Line;
end;

procedure TBreakpointList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  inherited;
  case Action of
    lnAdded, lnExtracted, lnDeleted:
      begin
        // même sur lnDeleted on peut encore accéder à Ptr
        //Editor.InvalidateLine(TBreakpointInfo(Ptr).Line);
        //Editor.InvalidateGutterLine(TBreakpointInfo(Ptr).Line);
        // InvalidateLine et InvalidateGutterLine bizarrement insuffisants dans certains cas 
        Editor.Invalidate;
      end;
  end;
  if Action = lnAdded then
    Sort(CompareBreakpoint);
end;

{ TDebugPlugin }

constructor TDebugPlugin.Create(AOwner: TCustomSynEdit);
begin
  inherited Create(AOwner);
  FBreakpointsList := TBreakpointList.Create(True);
  FBreakpointsList.Editor := AOwner;
  FWatchesList := TWatchList.Create(True);
  FMessagesList := TMessageList.Create(True);
end;

destructor TDebugPlugin.Destroy;
begin
  FBreakpointsList.Free;
  FWatchesList.Free;
  FMessagesList.Free;
  inherited;
end;

procedure TDebugPlugin.AfterPaint(ACanvas: TCanvas; const AClip: TRect; FirstLine, LastLine: Integer);
begin
  inherited;
end;

procedure TDebugPlugin.LinesDeleted(FirstLine, Count: Integer);
var
  i: Integer;
begin
  inherited;
  for i := Pred(FBreakpointsList.Count) downto 0 do
    if FBreakpointsList[i].Line in [FirstLine..FirstLine + Count] then
      FBreakpointsList.Delete(i)
    else if FBreakpointsList[i].Line > Cardinal(FirstLine) then
    begin
      Editor.InvalidateGutterLine(FBreakpointsList[i].Line);
      FBreakpointsList[i].Line := FBreakpointsList[i].Line - Cardinal(Count);
    end;

  for i := Pred(FMessagesList.Count) downto 0 do
    if FMessagesList[i].Line in [FirstLine..FirstLine + Count] then
      FMessagesList.Delete(i)
    else if FMessagesList[i].Line > Cardinal(FirstLine) then
      FMessagesList[i].Line := FMessagesList[i].Line - Cardinal(Count);
end;

procedure TDebugPlugin.LinesInserted(FirstLine, Count: Integer);
var
  i: Integer;
begin
  inherited;
  for i := 0 to FBreakpointsList.Count - 1 do
    if FBreakpointsList[i].Line >= Cardinal(FirstLine) then
    begin
      Editor.InvalidateGutterLine(FBreakpointsList[i].Line);
      FBreakpointsList[i].Line := FBreakpointsList[i].Line + Cardinal(Count);
    end;
  for i := 0 to FMessagesList.Count - 1 do
    if FMessagesList[i].Line >= Cardinal(FirstLine) then
    begin
      Editor.InvalidateGutterLine(FMessagesList[i].Line);
      FMessagesList[i].Line := FMessagesList[i].Line + Cardinal(Count);
    end;
end;

{ TDebugList }

procedure TDebugList.Clear;
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

procedure TDebugList.DeleteCurrent;
begin
  if Assigned(FView) then
  begin
    Delete(FView.GetFirstSelected.Index);
    UpdateView;
  end;
end;

destructor TDebugList.Destroy;
begin
  SetView(nil);
  inherited;
end;

procedure TDebugList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  inherited;
  case Action of
    lnAdded, lnExtracted, lnDeleted: UpdateView;
  end;
end;

procedure TDebugList.SetView(const Value: TVirtualStringTree);
begin
  if Assigned(FView) then
    FView.RootNodeCount := 0;
  FView := Value;
  if Assigned(FView) then
    FView.RootNodeCount := Count;
end;

procedure TDebugList.UpdateView;
begin
  if not Assigned(FView) then Exit;
  FView.RootNodeCount := Count;
  FView.Invalidate;
end;

{ TWatchList }

procedure TWatchList.AddWatch(const VarName: string);
var
  Watch: TWatchInfo;
begin
  if (VarName <> '') and (IndexOfName(VarName) = -1) then
  begin
    Watch := TWatchInfo.Create;
    Watch.Name := VarName;
    Watch.Active := True;
    Add(Watch);
  end;
end;

function TWatchList.GetInfo(Index: Integer): TWatchInfo;
begin
  Result := TWatchInfo(inherited Items[Index]);
end;

function TWatchList.IndexOfName(const VarName: string): Integer;
begin
  Result := 0;
  while (Result < Count) and not SameText(TWatchInfo(Items[Result]).Name, VarName) do
    Inc(Result);
  if Result = Count then
    Result := -1;
end;

procedure TWatchList.PutInfo(Index: Integer; const Value: TWatchInfo);
begin
  Put(Index, Pointer(Value));
end;

{ TMessageList }

function TMessageList.AddCompileErrorMessage(const Text: string; TypeMessage: TTypeMessage; Line, Char: Cardinal): Integer;
var
  Msg: TMessageInfo;
begin
  Msg := TMessageInfo.Create;
  Result := Add(Msg);
  case TypeMessage of
    tmError: Msg.TypeMessage := 'Erreur';
    tmWarning: Msg.TypeMessage := 'Avertissement';
    tmHint: Msg.TypeMessage := 'Conseil';
  end;
  Msg.Text := Text;
  Msg.Line := Line;
  Msg.Char := Char;
  Msg.Category := cmCompileError;
end;

function TMessageList.AddInfoMessage(const Text: string; Line, Char: Cardinal): Integer;
var
  Msg: TMessageInfo;
begin
  Msg := TMessageInfo.Create;
  Result := Add(Msg);
  Msg.TypeMessage := 'Information';
  Msg.Text := Text;
  Msg.Line := Line;
  Msg.Char := Char;
  Msg.Category := cmInfo;
end;

function TMessageList.AddRuntimeErrorMessage(const Text: string; Line, Char: Cardinal): Integer;
var
  Msg: TMessageInfo;
begin
  Msg := TMessageInfo.Create;
  Result := Add(Msg);
  Msg.TypeMessage := 'Erreur';
  Msg.Text := Text;
  Msg.Line := Line;
  Msg.Char := Char;
  Msg.Category := cmRuntimeError;
end;

function TMessageList.Current: TMessageInfo;
begin
  Result := nil;
  if not Assigned(FView) or (FView.GetFirstSelected = nil) then Exit;
  Result := Items[FView.GetFirstSelected.Index];
end;

function TMessageList.GetInfo(Index: Integer): TMessageInfo;
begin
  Result := TMessageInfo(inherited Items[Index]);
end;

function TMessageList.Last: TMessageInfo;
begin
  Result := TMessageInfo(inherited Last);
end;

procedure TMessageList.PutInfo(Index: Integer; const Value: TMessageInfo);
begin
  Put(Index, Pointer(Value));
end;

{ TBreakpointInfo }

constructor TBreakpointInfo.Create(Editor: TCustomSynEdit);
begin
  inherited Create;
  FEditor := Editor;
end;

procedure TBreakpointInfo.SetActive(const Value: Boolean);
begin
  FActive := Value;
  FEditor.InvalidateLine(Line);
  FEditor.InvalidateGutterLine(Line);
end;

end.

