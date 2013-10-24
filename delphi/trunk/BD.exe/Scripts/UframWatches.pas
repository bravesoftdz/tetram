unit UframWatches;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VirtualTrees, UdmScripts;

type
  TframWatches = class(TFrame)
    vstSuivis: TVirtualStringTree;
    procedure vstSuivisChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstSuivisEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vstSuivisGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstSuivisInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstSuivisNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
    procedure vstSuivisPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  private
    FMasterEngine: IMasterEngine;
    procedure SetMasterEngine(const Value: IMasterEngine);
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure Invalidate; override;
    property MasterEngine: IMasterEngine read FMasterEngine write SetMasterEngine;
  end;

implementation

{$R *.dfm}

procedure TframWatches.Invalidate;
begin
  inherited;
  vstSuivis.Invalidate;
end;

procedure TframWatches.SetMasterEngine(const Value: IMasterEngine);
begin
  if FMasterEngine <> nil then
    FMasterEngine.DebugPlugin.Watches.View := nil;
  FMasterEngine := Value;
  if FMasterEngine <> nil then
    FMasterEngine.DebugPlugin.Watches.View := vstSuivis;
end;

procedure TframWatches.vstSuivisChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  MasterEngine.DebugPlugin.Watches[Node.index].Active := Node.CheckState = csCheckedNormal;
  MasterEngine.DebugPlugin.Watches.View.InvalidateNode(Node);
end;

procedure TframWatches.vstSuivisEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := Column = 0;
end;

procedure TframWatches.vstSuivisGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
begin
  if Column = -1 then
    Column := 0;
  with MasterEngine.DebugPlugin.Watches[Node.index] do
    case Column of
      0:
        CellText := string(name);
      1:
        if not Active then
          CellText := '<désactivé>'
        else
          CellText := MasterEngine.Engine.GetWatchValue(name);
    end;
end;

procedure TframWatches.vstSuivisInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  Node.CheckType := ctCheckBox;
  if MasterEngine.DebugPlugin.Watches[Node.index].Active then
    Node.CheckState := csCheckedNormal
  else
    Node.CheckState := csUncheckedNormal;
end;

procedure TframWatches.vstSuivisNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
begin
  MasterEngine.DebugPlugin.Watches[Node.index].Name := NewText;
  MasterEngine.DebugPlugin.Watches.View.InvalidateNode(Node);
end;

procedure TframWatches.vstSuivisPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  if Node.CheckState = csCheckedNormal then
    TargetCanvas.Font.Color := clWindowText
  else
    TargetCanvas.Font.Color := clGrayText;
end;

end.
