unit UfrmScriptChoix;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, System.UITypes,
  Dialogs, VirtualTrees, UframBoutons, UScriptsFonctions, Generics.Collections, UbdtForms;

type
  TVirtualStringTree = class(VirtualTrees.TVirtualStringTree)
  protected
    procedure DoAfterPaint(Canvas: TCanvas); override;
  end;

  TfrmScriptChoix = class(TbdtForm)
    framBoutons1: TframBoutons;
    VirtualStringTree1: TVirtualStringTree;
    procedure VirtualStringTree1GetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure VirtualStringTree1InitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure FormCreate(Sender: TObject);
    procedure VirtualStringTree1InitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
    procedure VirtualStringTree1PaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure VirtualStringTree1MeasureItem(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
    procedure VirtualStringTree1AfterCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect);
    procedure VirtualStringTree1DblClick(Sender: TObject);
  private
    FList: TObjectList<TScriptChoix.TCategorie>;
  public
    procedure SetList(List: TObjectList<TScriptChoix.TCategorie>);
  end;

implementation

{$R *.dfm}

procedure TVirtualStringTree.DoAfterPaint(Canvas: TCanvas);
const
  s = 'Pas d''éléments à afficher.';
var
  Ext: TSize;
  p: TPoint;
begin
  inherited;
  if RootNodeCount = 0 then
  begin
    Ext := Canvas.TextExtent(s);
    p.X := (Width - Ext.cx) div 2;
    p.Y := (Height - Ext.cy) div 2;
    if p.X < 0 then
      p.X := 0;
    if p.Y < 0 then
      p.Y := 0;
    Canvas.Font.Assign(Font);
    Canvas.Brush.Style := bsClear;
    Canvas.TextOut(p.X, p.Y, s);
  end;
end;

procedure TfrmScriptChoix.SetList(List: TObjectList<TScriptChoix.TCategorie>);
begin
  VirtualStringTree1.BeginUpdate;
  try
    VirtualStringTree1.RootNodeCount := 0;
    FList := List;
    case FList.Count of
      0: VirtualStringTree1.RootNodeCount := 0;
      1: VirtualStringTree1.RootNodeCount := FList[0].Choix.Count;
      else
        VirtualStringTree1.RootNodeCount := FList.Count;
    end;
  finally
    VirtualStringTree1.EndUpdate;
  end;
end;

procedure TfrmScriptChoix.FormCreate(Sender: TObject);
begin
  VirtualStringTree1.NodeDataSize := 0;
end;

procedure TfrmScriptChoix.VirtualStringTree1AfterCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect);
begin
  if (FList.Count = 1) or (Sender.GetNodeLevel(Node) > 0) then
  begin
    // noeud classique
    if (Column = 2) and Assigned(FList[Node.Parent.Index].Choix[Node.Index].FImage) then
      TargetCanvas.Draw(CellRect.Left, CellRect.Top, FList[Node.Parent.Index].Choix[Node.Index].FImage);
  end;
end;

procedure TfrmScriptChoix.VirtualStringTree1DblClick(Sender: TObject);
begin
  framBoutons1.btnOk.Click;
end;

procedure TfrmScriptChoix.VirtualStringTree1GetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
begin
  if (FList.Count = 1) or (Sender.GetNodeLevel(Node) > 0) then
  begin
    // noeud classique
    case column of
      0: CellText := FList[Node.Parent.Index].Choix[Node.Index].FLibelle;
      1: CellText := FList[Node.Parent.Index].Choix[Node.Index].FCommentaire;
      2: if Assigned(FList[Node.Parent.Index].Choix[Node.Index].FImage) then
          CellText := ' '
        else
          CellText := '';
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

procedure TfrmScriptChoix.VirtualStringTree1MeasureItem(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
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
  NodeHeight := 4 + DrawText(TargetCanvas.Handle, PChar(s), Length(s), r, DT_CALCRECT or DT_WORDBREAK);
  if (FList.Count = 1) or (Sender.GetNodeLevel(Node) > 0) then
    if Assigned(FList[Node.Parent.Index].Choix[Node.Index].FImage) then
      if NodeHeight < 4 + FList[Node.Parent.Index].Choix[Node.Index].FImage.Height then
        NodeHeight := 4 + FList[Node.Parent.Index].Choix[Node.Index].FImage.Height;

  if oldBottom <> r.Bottom then
    Include(Node.States, vsMultiline);
end;

procedure TfrmScriptChoix.VirtualStringTree1PaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
begin
  if (FList.Count > 1) and (Sender.GetNodeLevel(Node) = 0) then
    TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsBold];
end;

end.

