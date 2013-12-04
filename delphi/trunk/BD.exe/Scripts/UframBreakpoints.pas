unit UframBreakpoints;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VirtualTrees, UScriptEngineIntf;

type
  TframBreakpoints = class(TFrame)
    vstBreakpoints: TVirtualStringTree;
    procedure vstBreakpointsChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstBreakpointsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstBreakpointsPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure vstBreakpointsInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
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

procedure TframBreakpoints.Invalidate;
begin
  inherited;
  vstBreakpoints.Invalidate;
end;

procedure TframBreakpoints.SetMasterEngine(const Value: IMasterEngine);
begin
  if FMasterEngine <> nil then
    FMasterEngine.DebugPlugin.Breakpoints.View := nil;
  FMasterEngine := Value;
  if FMasterEngine <> nil then
    FMasterEngine.DebugPlugin.Breakpoints.View := vstBreakpoints;
end;

procedure TframBreakpoints.vstBreakpointsChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  msg: IBreakPointInfo;
begin
  msg := MasterEngine.DebugPlugin.Breakpoints[Node.Index];
  MasterEngine.ToggleBreakPoint(msg.ScriptUnitName, msg.Line, True);
  MasterEngine.DebugPlugin.Breakpoints.View.InvalidateNode(Node);
end;

procedure TframBreakpoints.vstBreakpointsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  msg: IBreakPointInfo;
begin
  if Column = -1 then
    Column := 0;
  msg := MasterEngine.DebugPlugin.Breakpoints[Node.Index];
  case Column of
    0:
      CellText := 'Ligne ' + IntToStr(msg.Line);
    1:
      if msg.ScriptUnitName = MasterEngine.Engine.GetSpecialMainUnitName then
        CellText := MasterEngine.ProjectScript.ScriptUnitName
      else
        CellText := string(msg.ScriptUnitName);
  end;
end;

procedure TframBreakpoints.vstBreakpointsInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  Node.CheckType := ctCheckBox;
  if MasterEngine.DebugPlugin.Breakpoints[Node.Index].Active then
    Node.CheckState := csCheckedNormal
  else
    Node.CheckState := csUncheckedNormal;
end;

procedure TframBreakpoints.vstBreakpointsPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  if Node.CheckState = csCheckedNormal then
    TargetCanvas.Font.Color := clWindowText
  else
    TargetCanvas.Font.Color := clGrayText;
end;

end.
