unit UVirtualTreeEdit;

interface

uses
  SysUtils, Windows, Classes, Controls, Messages, JvToolEdit, VirtualTrees, VirtualTree, Variants, EditLabeled, LinkControls, EntitiesLite, Vcl.ExtCtrls;

type
  TJvComboEdit = class(JvToolEdit.TJvComboEdit)

  type
    TJvPopupVirtualTree = class(TJvPopupWindow)
    strict private
      FTreeView: TVirtualStringTree;
      FClickedPosition: TPoint;
      procedure TreeViewMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
      procedure TreeViewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
    protected
      function GetValue: Variant; override;
      procedure SetValue(const Value: Variant); override;
    published
      property TreeView: TVirtualStringTree read FTreeView;
      property Value: Variant read GetValue write SetValue;
    end;

  strict private
  type
    TCrackWinControl = class(TWinControl);

  var
    FInternalCurrentValue: TGUID;
    FReloadValue: Boolean;
    FInternalValueChanged: TNotifyEvent;
    FLinkControls: TControlList;
    FLastSearch: string;
    FTimerDelay: TTimer;

    procedure SetLinkControls(const Value: TControlList);
    procedure SetMode(const Value: TVirtualMode);
    procedure SetCurrentValue(const Value: TGUID);
    function GetMode: TVirtualMode;
    function GetCurrentValue: TGUID;
    function GetPopupWindow: TJvPopupVirtualTree;
    procedure SetInternalCurrentValue(const Value: TGUID);
  protected
    procedure PopupCloseUp(Sender: TObject; Accept: Boolean); override;
    procedure PopupDropDown(DisableEdit: Boolean); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure SetPopupValue(const Value: Variant); override;
    procedure Change; override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure TimerDelayEvent(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Data: TBaseLite;
    procedure CloseUp;
    procedure PopupChange; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure Paint(var Msg: TWMPaint); message WM_PAINT;
  published
    property Mode: TVirtualMode read GetMode write SetMode;
    property CurrentValue: TGUID read GetCurrentValue write SetCurrentValue;
    property PopupWindow: TJvPopupVirtualTree read GetPopupWindow;
    property InternalValueChanged: TNotifyEvent read FInternalValueChanged write FInternalValueChanged;
    property LinkControls: TControlList read FLinkControls write SetLinkControls;
    property LastSearch: string read FLastSearch;
  end;

implementation

uses
  Commun, Forms, Math, Graphics;

constructor TJvComboEdit.Create(AOwner: TComponent);
begin
  inherited;

  FLinkControls := TControlList.Create;
  ImageKind := ikDropDown;
  FInternalCurrentValue := GUID_NULL;
  FReloadValue := True;
  FTimerDelay := TTimer.Create(Self);
  FTimerDelay.Enabled := False;
  FTimerDelay.Interval := 800;
  FTimerDelay.OnTimer := TimerDelayEvent;
  FPopup := TJvPopupVirtualTree.Create(Self);
  TJvPopupWindow(FPopup).OnCloseUp := PopupCloseUp;
end;

destructor TJvComboEdit.Destroy;
begin
  FTimerDelay.Free;
  TJvPopupWindow(FPopup).OnCloseUp := nil;
  FPopup.Parent := nil;
  FreeAndNil(FPopup);
  FLinkControls.Free;

  inherited;
end;

procedure TJvComboEdit.Change;
begin
  if FReloadValue then
  begin
    FTimerDelay.Enabled := False;
    FTimerDelay.Enabled := True;
  end;
  if (Screen.ActiveControl = Self) and not PopupVisible then
    PopupDropDown(False);
  inherited;
end;

procedure TJvComboEdit.CloseUp;
begin
  if PopupVisible then
    PopupCloseUp(Self, True);
end;

function TJvComboEdit.Data: TBaseLite;
begin
  Result := PopupWindow.TreeView.GetFocusedNodeData;
end;

procedure TJvComboEdit.DoEnter;
begin
  FLinkControls.DoEnter;
  inherited;
end;

procedure TJvComboEdit.DoExit;
begin
  FLinkControls.DoExit;
  inherited;
end;

procedure TJvComboEdit.PopupDropDown(DisableEdit: Boolean);
begin
  inherited PopupDropDown(False);
end;

function TJvComboEdit.GetMode: TVirtualMode;
begin
  Result := PopupWindow.TreeView.Mode;
end;

function TJvComboEdit.GetCurrentValue: TGUID;
begin
  Result := PopupWindow.TreeView.CurrentValue;
end;

function TJvComboEdit.GetPopupWindow: TJvPopupVirtualTree;
begin
  Result := TJvPopupVirtualTree(FPopup);
end;

procedure TJvComboEdit.KeyDown(var Key: Word; Shift: TShiftState);
var
  Msg: TWMKey;
begin
  if not ReadOnly then
  begin
    case Key of
      VK_PRIOR, VK_NEXT, VK_UP, VK_DOWN, VK_RETURN:
        if PopupVisible then
        begin
          with Msg do
          begin
            Msg := WM_KEYDOWN;
            CharCode := Key;
            Unused := 0;
            if ssAlt in Shift then // les autres etats du clavier ne sont pas pris dans KeyData
              KeyData := $20000000
            else
              KeyData := 0;
            Result := 0;
          end;
          TCrackWinControl(PopupWindow.TreeView).Dispatch(Msg);
          Key := 0;
        end;
      VK_F3:
        begin
          PopupWindow.TreeView.Find(Self.Text, True);
          Key := 0;
        end;
    end;
  end;
  inherited KeyDown(Key, Shift);
end;

procedure TJvComboEdit.Paint;
begin
  inherited;
  if Text = '' then
    with TControlCanvas.Create do
      try
        Control := Self;
        Font.Color := clInactiveCaptionText;
        TextRect(Self.BoundsRect, 0, 0, FLastSearch);
      finally
        Free;
      end;
end;

procedure TJvComboEdit.PopupChange;
begin
  // SetInternalCurrentValue(PopupWindow.TreeView.CurrentValue);
end;

procedure TJvComboEdit.PopupCloseUp(Sender: TObject; Accept: Boolean);
begin
  if Accept then
  begin
    SetInternalCurrentValue(PopupWindow.TreeView.CurrentValue);
    if Assigned(OnChange) then
      OnChange(Self);

    FLastSearch := Self.Text;
    Self.TextHint := FLastSearch;
  end;
  FReloadValue := False;
  try
    inherited;
  finally
    FReloadValue := True;
  end;
end;

procedure TJvComboEdit.SetCurrentValue(const Value: TGUID);
begin
  PopupWindow.TreeView.CurrentValue := Value;
  SetInternalCurrentValue(GetCurrentValue);
  FReloadValue := False;
  try
    Text := TJvPopupVirtualTree(FPopup).GetValue;
  finally
    FReloadValue := True;
  end;
  if Assigned(OnChange) then
    OnChange(Self);
end;

procedure TJvComboEdit.SetInternalCurrentValue(const Value: TGUID);
begin
  FInternalCurrentValue := Value;
  if Assigned(FInternalValueChanged) then
    FInternalValueChanged(Self);
end;

procedure TJvComboEdit.SetLinkControls(const Value: TControlList);
begin
  FLinkControls.Assign(Value);
end;

procedure TJvComboEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  if Assigned(FPopup) then
    FPopup.Width := Max(300, Width);
end;

procedure TJvComboEdit.SetMode(const Value: TVirtualMode);
begin
  PopupWindow.TreeView.Mode := Value;
end;

procedure TJvComboEdit.SetPopupValue(const Value: Variant);
begin
  PopupWindow.SetValue(GuidToString(FInternalCurrentValue));
end;

procedure TJvComboEdit.TimerDelayEvent(Sender: TObject);
begin
  FTimerDelay.Enabled := False;
  PopupWindow.SetValue(Self.Text);
end;

constructor TJvComboEdit.TJvPopupVirtualTree.Create(AOwner: TComponent);
begin
  inherited;

  Height := 150;
  Width := 300;

  FTreeView := TVirtualStringTree.Create(Self);
  FTreeView.Parent := Self;
  FTreeView.Align := alClient;
  FTreeView.BorderStyle := bsNone;
  FTreeView.ParentColor := True;
  FTreeView.OnMouseUp := TreeViewMouseUp;
  FTreeView.OnMouseDown := TreeViewMouseDown;
end;

destructor TJvComboEdit.TJvPopupVirtualTree.Destroy;
begin
  FreeAndNil(FTreeView);

  inherited;
end;

function TJvComboEdit.TJvPopupVirtualTree.GetValue: Variant;
begin
  Result := TreeView.FullCaption;
end;

procedure TJvComboEdit.TJvPopupVirtualTree.SetValue(const Value: Variant);
begin
  try
    if not VarIsStr(Value) then
      TreeView.CurrentValue := GUID_NULL
    else
      TreeView.CurrentValue := StringToGuid(Value);
  except
    on EConvertError do
      TreeView.Find(Value, False)
    else
      raise;
  end;
end;

procedure TJvComboEdit.TJvPopupVirtualTree.TreeViewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FClickedPosition.X := X - TreeView.OffsetX;
  FClickedPosition.Y := Y - TreeView.OffsetY;
end;

procedure TJvComboEdit.TJvPopupVirtualTree.TreeViewMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Node: PVirtualNode;
  dummy: Integer;
begin
  if (Button = mbLeft) and (Shift - [ssLeft] = []) then
  begin
    Node := TreeView.GetNodeAt(FClickedPosition.X, FClickedPosition.Y, False, dummy);
    if Assigned(Node) and (TreeView.GetNodeLevel(Node) > 0) and not IsEqualGUID(TreeView.CurrentValue, GUID_NULL) then
    begin
      CloseUp(True);
    end;
  end;
end;

end.
