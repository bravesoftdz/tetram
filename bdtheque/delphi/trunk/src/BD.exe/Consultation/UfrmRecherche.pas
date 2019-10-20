unit UfrmRecherche;

interface

uses
  SysUtils, Windows, Messages, Classes, Forms, Graphics, Controls, Menus, StdCtrls, System.UITypes, System.Types, Buttons, ComCtrls, ExtCtrls, ToolWin, BD.Utils.StrUtils,
  VirtualTrees, BDTK.GUI.Controls.VirtualTree, ActnList, VDTButton, ComboCheck, BDTK.GUI.Utils,
  BDTK.GUI.Frames.QuickSearch, BD.Entities.Full, BDTK.Entities.Search, BD.GUI.Forms, Generics.Defaults,
  System.Actions;

type
  TfrmRecherche = class(TBdtForm, IImpressionApercu)
    PopupMenu1: TPopupMenu;
    Critre1: TMenuItem;
    Groupedecritre1: TMenuItem;
    ActionList1: TActionList;
    RechercheApercu: TAction;
    RechercheImprime: TAction;
    PageControl2: TPageControl;
    TabSheet4: TTabSheet;
    plus: TButton;
    Modif: TButton;
    moins: TButton;
    methode: TComboBox;
    btnRecherche: TButton;
    TabSheet3: TTabSheet;
    Splitter1: TSplitter;
    vtPersonnes: TVirtualStringTree;
    VTResult: TVirtualStringTree;
    LightComboCheck1: TLightComboCheck;
    MainMenu1: TMainMenu;
    Recherche1: TMenuItem;
    Exporter1: TMenuItem;
    Imprimer1: TMenuItem;
    lbResult: TLabel;
    FrameRechercheRapide1: TFramRechercheRapide;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TreeView1: TTreeView;
    TreeView2: TTreeView;
    procedure plusClick(Sender: TObject);
    procedure moinsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RechPrint(Sender: TObject);
    procedure vtPersonnesDblClick(Sender: TObject);
    procedure VTResultDblClick(Sender: TObject);
    procedure ModifClick(Sender: TObject);
    procedure methodeChange(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure TreeView1Collapsing(Sender: TObject; Node: TTreeNode; var AllowCollapse: Boolean);
    procedure Critre1Click(Sender: TObject);
    procedure Groupedecritre1Click(Sender: TObject);
    procedure btnRechercheClick(Sender: TObject);
    procedure VTResultGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure VTResultPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure VTResultHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
    procedure LightComboCheck1Change(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure PageControl1Change(Sender: TObject);
    procedure TreeView2Change(Sender: TObject; Node: TTreeNode);
  private
    { Déclarations privées }
    Recherche: TRecherche;
    FTypeRecherche: TTypeRecherche;
    procedure SetTypeRecherche(Value: TTypeRecherche);
    procedure ImpressionExecute(Sender: TObject);
    procedure ApercuExecute(Sender: TObject);
    function ImpressionUpdate: Boolean;
    function ApercuUpdate: Boolean;
    procedure ReconstructLabels(ParentNode: TTreeNode);
    procedure ReconstructSortLabel(Node: TTreeNode);
    procedure AddCritereTri;
  public
    { Déclarations publiques }
    CritereSimple: TGUID;
    property TypeRecherche: TTypeRecherche read FTypeRecherche write SetTypeRecherche;
    function ImpressionEnabled: Boolean;
    procedure LoadRechFromStream(Stream: TStream);
  end;

implementation

uses
  BD.Strings, BDTK.GUI.DataModules.Main, BD.Entities.Lite, Impression, Math, UfrmEditCritere, UHistorique, BD.Utils.GUIUtils, StrUtils,
  BDTK.GUI.Forms.Main, UfrmEditCritereTri, Divers, BD.Entities.Common;

{$R *.DFM}

var
  FSortColumn: Integer;
  FSortDirection: TSortDirection;

function AlbumCompare(const Left, Right: TAlbumLite): Integer;
begin
  case FSortColumn of
    0:
      if not TAlbumLite(Left).Titre.IsEmpty and not TAlbumLite(Right).Titre.IsEmpty then
        Result := CompareText(TAlbumLite(Left).Titre, TAlbumLite(Right).Titre)
      else if not TAlbumLite(Left).Titre.IsEmpty and TAlbumLite(Right).Titre.IsEmpty then
        Result := CompareText(TAlbumLite(Left).Titre, TAlbumLite(Right).Serie)
      else if TAlbumLite(Left).Titre.IsEmpty and not TAlbumLite(Right).Titre.IsEmpty then
        Result := CompareText(TAlbumLite(Left).Serie, TAlbumLite(Right).Titre)
      else
        Result := CompareText(TAlbumLite(Left).Serie, TAlbumLite(Right).Serie);
    1:
      Result := CompareValue(TAlbumLite(Left).Tome, TAlbumLite(Right).Tome);
    2:
      begin
        Result := CompareText(TAlbumLite(Left).Serie, TAlbumLite(Right).Serie);
        if Result = 0 then
          Result := CompareValue(TAlbumLite(Left).Tome, TAlbumLite(Right).Tome);
      end;
    else
      Result := 0;
  end;
  if FSortDirection = sdDescending then
    Result := -Result;
end;

procedure TfrmRecherche.FormCreate(Sender: TObject);
var
  hg: IHourGlass;
  i: TRechercheSimple;
begin
  hg := THourGlass.Create;
  PrepareLV(Self);

  Recherche := TRecherche.Create;

  LightComboCheck1.Items.Clear;
  for i := Low(TRechercheSimple) to High(TRechercheSimple) do
    LightComboCheck1.Items.Add(TLblRechercheSimple[i]).Valeur := Ord(i);
  LightComboCheck1.Value := 0;
  ChargeImage(vtPersonnes.Background, 'FONDVT');
  ChargeImage(VTResult.Background, 'FONDVT');
  FrameRechercheRapide1.VirtualTreeView := vtPersonnes;
  FrameRechercheRapide1.ShowNewButton := False;

  PageControl2.ActivePageIndex := 0;
  PageControl1.ActivePageIndex := 0;

  VTResult.TreeOptions.PaintOptions := VTResult.TreeOptions.PaintOptions - [toShowButtons, toShowDropmark, toShowRoot];

  btnRecherche.Font.Style := btnRecherche.Font.Style + [fsBold];
  vtPersonnes.Mode := vmPersonnes;
  TypeRecherche := Recherche.TypeRecherche;
  TreeView1.Selected := TreeView1.Items.AddChildObject(nil, 'Critères', Recherche.Criteres);
  methode.ItemIndex := Integer(Recherche.Criteres.GroupOption);
end;

procedure TfrmRecherche.ModifClick(Sender: TObject);
var
  ToModif: TTreeNode;
  p: TCritere;
  p2: TCritereTri;
  frm: TfrmEditCritere;
  frmTri: TfrmEditCritereTri;
begin
  if PageControl1.ActivePage = TabSheet1 then
  begin
    ToModif := TreeView1.Selected;
    if not(Assigned(ToModif) and (Integer(ToModif.Data) > 0)) then
      Exit;
    p := ToModif.Data;
    frm := TFrmEditCritere.Create(Self);
    try
      frm.Critere := p;
      if frm.ShowModal <> mrOk then
        Exit;
      p.Assign(frm.Critere);
    finally
      frm.Free;
    end;
    ReconstructLabels(ToModif.Parent);
  end
  else
  begin
    ToModif := TreeView2.Selected;
    if not Assigned(ToModif) then
      Exit;
    p2 := ToModif.Data;
    frmTri := TfrmEditCritereTri.Create(Self);
    try
      frmTri.Critere := p2;
      if frmTri.ShowModal <> mrOk then
        Exit;
      p2.Assign(frmTri.Critere);
    finally
      frmTri.Free;
    end;
    ReconstructSortLabel(ToModif);
  end;
end;

procedure TfrmRecherche.plusClick(Sender: TObject);
var
  p: TPoint;
begin
  if PageControl1.ActivePage = TabSheet1 then
  begin
    if Assigned(TreeView1.Selected) then
    begin
      p := plus.ClientToScreen(Point(0, plus.Height));
      PopupMenu1.Popup(p.x, p.y);
    end
    else
      Groupedecritre1.Click;
  end
  else
  begin
    AddCritereTri;
  end;
end;

procedure TfrmRecherche.moinsClick(Sender: TObject);
var
  p: TBaseCritere;
  Critere: TCritereTri;
  ParentNode: TTreeNode;
begin
  if PageControl1.ActivePage = TabSheet1 then
  begin
    if Assigned(TreeView1.Selected) and (TreeView1.Selected <> TreeView1.Items.GetFirstNode) then
    begin
      p := TreeView1.Selected.Data;
      ParentNode := TreeView1.Selected.Parent;
      TreeView1.Selected.Delete;
      Recherche.Delete(p);
      ReconstructLabels(ParentNode);
    end;
  end
  else
  begin
    if Assigned(TreeView2.Selected) then
    begin
      Critere := TreeView2.Selected.Data;
      TreeView2.Selected.Delete;
      Recherche.Delete(Critere);
    end;
  end;
end;

procedure TfrmRecherche.FormDestroy(Sender: TObject);
begin
  VTResult.RootNodeCount := 0;
  lbResult.Caption := '';
  Recherche.Free;
end;

procedure TfrmRecherche.RechPrint(Sender: TObject);
begin
  ImpressionRecherche(Recherche, TComponent(Sender).Tag = 1);
end;

procedure TfrmRecherche.SetTypeRecherche(Value: TTypeRecherche);
begin
  VTResult.Header.Columns[0].ImageIndex := -1;
  VTResult.Header.Columns[1].ImageIndex := -1;
  VTResult.Header.Columns[2].ImageIndex := -1;
  if (Value = trSimple) or (Recherche.SortBy.Count = 0) then
    if FSortDirection = sdAscending then
      VTResult.Header.Columns[FSortColumn].ImageIndex := 0
    else
      VTResult.Header.Columns[FSortColumn].ImageIndex := 1;
  if Value = trSimple then
    VTResult.TreeOptions.StringOptions := VTResult.TreeOptions.StringOptions + [toShowStaticText]
  else
    VTResult.TreeOptions.StringOptions := VTResult.TreeOptions.StringOptions - [toShowStaticText];
  RechercheApercu.Enabled := Value <> trAucune;
  RechercheImprime.Enabled := RechercheApercu.Enabled;
  case Value of
    trComplexe:
      PageControl2.ActivePageIndex := 1;
    trSimple:
      PageControl2.ActivePageIndex := 0;
  end;
  FTypeRecherche := Value;
  frmFond.actImpression.Update;
  frmFond.actApercuImpression.Update;
end;

procedure TfrmRecherche.vtPersonnesDblClick(Sender: TObject);
begin
  if not IsEqualGUID(vtPersonnes.CurrentValue, GUID_NULL) then
  begin
    CritereSimple := vtPersonnes.CurrentValue;
    PageControl2.ActivePageIndex := 0;
    VTResult.RootNodeCount := 0;
    lbResult.Caption := '';

    Recherche.Fill(TRechercheSimple(LightComboCheck1.Value), vtPersonnes.CurrentValue, vtPersonnes.Caption);
    Recherche.Resultats.Sort(TComparer<TAlbumLite>.Construct(AlbumCompare));

    TypeRecherche := Recherche.TypeRecherche;

    Historique.EditConsultation(CritereSimple, LightComboCheck1.Value);
    VTResult.RootNodeCount := Recherche.Resultats.Count;
    lbResult.Caption := IntToStr(VTResult.RootNodeCount) + ' résultat(s) trouvé(s)';
  end;
end;

procedure TfrmRecherche.VTResultDblClick(Sender: TObject);
begin
  if Assigned(VTResult.FocusedNode) then
    Historique.AddWaiting(fcAlbum, Recherche.Resultats[VTResult.FocusedNode.Index].ID);
end;

procedure TfrmRecherche.methodeChange(Sender: TObject);
begin
  TGroupCritere(TreeView1.Selected.Parent.Data).GroupOption := TGroupOption(methode.ItemIndex);
  ReconstructLabels(TreeView1.Selected.Parent);
end;

function TfrmRecherche.ImpressionEnabled: Boolean;
begin
  Result := RechercheImprime.Enabled;
end;

procedure TfrmRecherche.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
  Modif.Enabled := Assigned(Node) and (TBaseCritere(Node.Data) is TCritere);
  moins.Enabled := Assigned(Node);
  methode.Visible := Assigned(Node) and Assigned(Node.Parent) and (TBaseCritere(Node.Parent.Data) is TGroupCritere);
  if methode.Visible then
    methode.ItemIndex := Integer(TGroupCritere(Node.Parent.Data).GroupOption);
end;

procedure TfrmRecherche.TreeView1Collapsing(Sender: TObject; Node: TTreeNode; var AllowCollapse: Boolean);
begin
  AllowCollapse := False;
end;

procedure TfrmRecherche.Critre1Click(Sender: TObject);
var
  p: TCritere;
  ParentNode: TTreeNode;
  frm: TfrmEditCritere;
  Node: TTreeNode;
begin
  if not Assigned(TreeView1.Selected) then
    Exit;

  frm := TfrmEditCritere.Create(Self);
  try
    if frm.ShowModal <> mrOk then
      Exit;
    if TBaseCritere(TreeView1.Selected.Data) is TGroupCritere then
      ParentNode := TreeView1.Selected
    else
      ParentNode := TreeView1.Selected.Parent;

    p := Recherche.AddCritere(TGroupCritere(ParentNode.Data));
    p.Assign(frm.Critere);
  finally
    frm.Free;
  end;

  Node := TreeView1.Items.AddChildObject(ParentNode, '', p);
  ReconstructLabels(ParentNode);
  Node.Selected := True;
end;

procedure TfrmRecherche.Groupedecritre1Click(Sender: TObject);
var
  ParentNode, Node: TTreeNode;
begin
  if not Assigned(TreeView1.Selected) then
    ParentNode := nil
  else if TBaseCritere(TreeView1.Selected.Data) is TGroupCritere then
    ParentNode := TreeView1.Selected
  else
    ParentNode := TreeView1.Selected.Parent;

  Node := TreeView1.Items.AddChild(ParentNode, methode.Items[0]);
  if Assigned(ParentNode) then
  begin
    Node.Data := Recherche.AddGroup(TGroupCritere(ParentNode.Data));
    ReconstructLabels(ParentNode);
  end
  else
    Node.Data := Recherche.AddGroup(nil);
  Node.Selected := True;
end;

procedure TfrmRecherche.btnRechercheClick(Sender: TObject);
var
  RechStream: TMemoryStream;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  VTResult.RootNodeCount := 0;
  lbResult.Caption := '';
  RechStream := TMemoryStream.Create;
  try
    Recherche.Fill;
    TypeRecherche := Recherche.TypeRecherche;
    Recherche.SaveToStream(RechStream);
    Historique.EditConsultation(RechStream);
  finally
    RechStream.Free;
  end;
  VTResult.RootNodeCount := Recherche.Resultats.Count;
  lbResult.Caption := IntToStr(VTResult.RootNodeCount) + ' résultat(s) trouvé(s)';
end;

procedure TfrmRecherche.VTResultGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
begin
  CellText := '';
  if TextType = ttNormal then
    case Column of
      0:
        CellText := Recherche.Resultats[Node.Index].ChaineAffichage(Recherche.Resultats[Node.Index].Titre.IsEmpty);
      1:
        CellText := NonZero(IntToStr(Recherche.Resultats[Node.Index].Tome));
      2:
        CellText := FormatTitre(Recherche.Resultats[Node.Index].Serie);
    end
  else if (Recherche.TypeRecherche = trSimple) and (Recherche.ResultatsInfos.Count > 0) then
    case Column of
      0:
        AjoutString(CellText, Recherche.ResultatsInfos[Node.Index], '', '(', ')');
    end;
end;

procedure TfrmRecherche.VTResultPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  if TextType = ttStatic then
    TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsItalic];
end;

procedure TfrmRecherche.VTResultHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
begin
  // si on n'affiche pas le tri en cours, c'est qu'on est en recherche avancée avec critère de tri : on ne peut donc pas changer le tri
  if (VTResult.Header.Columns[FSortColumn].ImageIndex = -1) then
    Exit;

  if HitInfo.Column <> FSortColumn then
    FSortDirection := sdAscending
  else if FSortDirection = sdAscending then
    FSortDirection := sdDescending
  else
    FSortDirection := sdAscending;
  if FSortColumn <> -1 then
    VTResult.Header.Columns[FSortColumn].ImageIndex := -1;
  FSortColumn := HitInfo.Column;
  if FSortDirection = sdAscending then
    VTResult.Header.Columns[FSortColumn].ImageIndex := 0
  else
    VTResult.Header.Columns[FSortColumn].ImageIndex := 1;
  VTResult.Header.SortColumn := FSortColumn;
  Recherche.Resultats.Sort(TComparer<TAlbumLite>.Construct(AlbumCompare));
  VTResult.ReinitNode(VTResult.RootNode, True);
  VTResult.Invalidate;
  VTResult.Refresh;
end;

procedure TfrmRecherche.LightComboCheck1Change(Sender: TObject);
const
  NewMode: array [0 .. 5] of TVirtualMode = (vmPersonnes, vmUnivers, vmSeries, vmEditeurs, vmGenres, vmCollections);
var
  Mode: TVirtualMode;
begin
  Mode := NewMode[LightComboCheck1.Value];
  if (vtPersonnes.Mode <> Mode) then
    vtPersonnes.Mode := Mode;
end;

procedure TfrmRecherche.ApercuExecute(Sender: TObject);
begin
  RechPrint(Sender);
end;

function TfrmRecherche.ApercuUpdate: Boolean;
begin
  Result := ImpressionEnabled;
end;

procedure TfrmRecherche.ImpressionExecute(Sender: TObject);
begin
  RechPrint(Sender);
end;

function TfrmRecherche.ImpressionUpdate: Boolean;
begin
  Result := ImpressionEnabled;
end;

procedure TfrmRecherche.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    vtPersonnes.OnDblClick(nil);
  end;
end;

procedure TfrmRecherche.LoadRechFromStream(Stream: TStream);

  procedure Process(ACritere: TGroupCritere; AParentNode: TTreeNode = nil);
  var
    Node: TTreeNode;
    SousCritere: TBaseCritere;
  begin
    Node := TreeView1.Items.AddChildObject(AParentNode, '', ACritere);
    for SousCritere in ACritere.SousCriteres do
      if SousCritere is TGroupCritere then
        Process(TGroupCritere(SousCritere), Node)
      else
        TreeView1.Items.AddChildObject(Node, '', SousCritere);
    ReconstructLabels(Node);
  end;

begin
  Recherche.LoadFromStream(Stream);
  Recherche.TypeRecherche := trComplexe;

  TreeView1.Items.BeginUpdate;
  try
    TreeView1.Items.Clear;
    Process(Recherche.Criteres);
    TreeView1.Items[0].Expand(True);
  finally
    TreeView1.Items.EndUpdate;
  end;
end;

procedure TfrmRecherche.ReconstructLabels(ParentNode: TTreeNode);
var
  i: Integer;
  Data: TObject;
begin
  for i := 0 to ParentNode.Count - 1 do
  begin
    Data := TObject(ParentNode.Item[i].Data);
    if Data is TGroupCritere then
      ParentNode.Item[i].Text := methode.Text + '...'
    else if i = 0 then
      ParentNode.Item[i].Text := TCritere(Data).Champ + ' ' + TCritere(Data).Test
    else
      ParentNode.Item[i].Text := methode.Text + ' ' + TCritere(Data).Champ + ' ' + TCritere(Data).Test;
  end;
end;

procedure TfrmRecherche.PageControl1Change(Sender: TObject);
begin
  methode.Visible := PageControl1.ActivePage = TabSheet1;
  if PageControl1.ActivePage = TabSheet1 then
    TreeView1Change(TreeView1, TreeView1.Selected)
  else
    TreeView2Change(TreeView2, TreeView2.Selected);
end;

procedure TfrmRecherche.AddCritereTri;
var
  p: TCritereTri;
  Node: TTreeNode;
  frm: TfrmEditCritereTri;
begin
  if not Assigned(TreeView1.Selected) then
    Exit;
  frm := TFrmEditCritereTri.Create(Self);
  try
    if frm.ShowModal <> mrOk then
      Exit;

    p := Recherche.AddSort;
    p.Assign(frm.Critere);
  finally
    frm.Free;
  end;

  Node := TreeView2.Items.AddObject(nil, '', p);
  ReconstructSortLabel(Node);
  Node.Selected := True;
end;

procedure TfrmRecherche.ReconstructSortLabel(Node: TTreeNode);
var
  Critere: TCritereTri;
begin
  Critere := TCritereTri(Node.Data);
  Node.Text := '(' + IIf(Critere.NullsFirst, '*', '') + IIf(Critere.Asc, '+', '-') + IIf(Critere.NullsLast, '*', '') + ') ' + Critere.LabelChamp;
end;

procedure TfrmRecherche.TreeView2Change(Sender: TObject; Node: TTreeNode);
begin
  Modif.Enabled := Assigned(Node);
  moins.Enabled := Assigned(Node);
end;

initialization
  FSortColumn := 2;
  FSortDirection := sdDescending;

end.
