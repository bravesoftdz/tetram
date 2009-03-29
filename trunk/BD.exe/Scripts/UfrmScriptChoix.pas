unit UfrmScriptChoix;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, UframBoutons, UScriptsFonctions, Generics.Collections, UbdtForms;

type
  TfrmScriptChoix = class(TbdtForm)
    framBoutons1: TframBoutons;
    VirtualStringTree1: TVirtualStringTree;
    procedure VirtualStringTree1GetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure VirtualStringTree1InitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure FormCreate(Sender: TObject);
    procedure VirtualStringTree1InitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
    procedure VirtualStringTree1PaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure VirtualStringTree1MeasureItem(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
  private
    FList: TObjectList<TScriptChoix.TCategorie>;
  public
    procedure SetList(List: TObjectList<TScriptChoix.TCategorie>);
  end;

implementation

{$R *.dfm}

procedure TfrmScriptChoix.SetList(List: TObjectList<TScriptChoix.TCategorie>);
begin
  VirtualStringTree1.BeginUpdate;
  try
    VirtualStringTree1.RootNodeCount := 0;
    FList := List;
    if FList.Count > 1 then
      VirtualStringTree1.RootNodeCount := FList.Count
    else
      VirtualStringTree1.RootNodeCount := FList[0].Choix.Count;
  finally
    VirtualStringTree1.EndUpdate;
  end;
end;

procedure TfrmScriptChoix.FormCreate(Sender: TObject);
begin
  VirtualStringTree1.NodeDataSize := 0;
end;

procedure TfrmScriptChoix.VirtualStringTree1GetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
begin
  if (FList.Count = 1) or (Sender.GetNodeLevel(Node) > 0) then
  begin
    // noeud classique
    case column of
      0: CellText := FList[Node.Parent.Index].Choix[Node.Index].FLibelle;
      1: CellText := FList[Node.Parent.Index].Choix[Node.Index].FCommentaire;
    end;
  end
  else
  begin
    // catégorie
    case Column of
      0: CellText := FList[Node.Index].FNom;
      else CellText := '';
    end;
  end;
end;

procedure TfrmScriptChoix.VirtualStringTree1InitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
begin
  ChildCount := FList[Node.Index].Choix.Count;
end;

procedure TfrmScriptChoix.VirtualStringTree1InitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  Include(InitialStates, ivsExpanded);

  if (FList.Count > 1) and (Sender.GetNodeLevel(Node) = 0) then
    Include(InitialStates, ivsHasChildren);
end;

procedure TfrmScriptChoix.VirtualStringTree1MeasureItem(  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;  var NodeHeight: Integer);
var
  s: string;
  r: TRect;
  oldBottom: Integer;
begin
  VirtualStringTree1GetText(Sender, Node, 1, ttNormal, s);
  r := Rect(0, 0, VirtualStringTree1.Header.Columns[1].Width, 15);
  if s = '' then
  begin
    VirtualStringTree1GetText(Sender, Node, 0, ttNormal, s);
    r := Rect(0, 0, VirtualStringTree1.Header.Columns[0].Width, 15);
  end;
  oldBottom := r.Bottom;
  NodeHeight := 4+DrawText(TargetCanvas.Handle, PChar(s), Length(s), r, DT_CALCRECT or DT_WORDBREAK);
  if oldBottom <> r.Bottom then Include(Node.States, vsMultiline);
end;

procedure TfrmScriptChoix.VirtualStringTree1PaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
begin
  if (FList.Count > 1) and (Sender.GetNodeLevel(Node) = 0) then
    TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsBold];
end;

end.

