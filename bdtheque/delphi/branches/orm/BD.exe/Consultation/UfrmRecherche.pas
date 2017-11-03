unit UfrmRecherche;

interface

uses
  SysUtils, Windows, Messages, Classes, Forms, Graphics, Controls, Menus, StdCtrls, System.UITypes, System.Types, Buttons, ComCtrls, ExtCtrls, ToolWin, Commun,
  VirtualTrees, VirtualTreeBdtk, ActnList, VDTButton, ComboCheck, ProceduresBDtk,
  UframRechercheRapide, Entities.Full, EntitiesRecherche, UBdtForms, Generics.Defaults,
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
    procedure SpeedButton1Click(Sender: TObject);
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
    { D�clarations priv�es }
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
    { D�clarations publiques }
    CritereSimple: TGUID;
    property TypeRecherche: TTypeRecherche read FTypeRecherche write SetTypeRecherche;
    function ImpressionEnabled: Boolean;
    procedure LoadRechFromStream(Stream: TStream);
  end;

implementation

uses
  Textes, UdmPrinc, Entities.Lite, Impression, Math, UfrmEditCritere, UHistorique, Procedures, StrUtils,
  UfrmFond, UfrmEditCritereTri, Divers, ORM.Core.Entities;

{$R *.DFM}

var
  FSortColumn: Integer;
  FSortDirection: TSortDirection;

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
  TreeView1.Selected := TreeView1.Items.AddChild(nil, 'Crit�res');
  TreeView1.Selected.Data := Recherche.Criteres;
  methode.ItemIndex := Integer(Recherche.Criteres.GroupOption);
end;

procedure TfrmRecherche.ModifClick(Sender: TObject);
var
  ToModif: TTreeNode;
  p: TCritere;
  p2: TCritereTri;
begin
  if PageControl1.ActivePage = TabSheet1 then
  begin
    ToModif := TreeView1.Selected;
    if not(Assigned(ToModif) and (Integer(ToModif.Data) > 0)) then
      Exit;
    p := ToModif.Data;
    with TFrmEditCritere.Create(Self) do
    begin
      try
        Critere := p;
        if ShowModal <> mrOk then
          Exit;
        p.Assign(Critere);
        if TypeRecherche = trComplexe then
          TypeRecherche := trAucune;
        ReconstructLabels(ToModif.Parent);
      finally
        Free;
      end;
    end;
  end
  else
  begin
    ToModif := TreeView2.Selected;
    if not Assigned(ToModif) then
      Exit;
    p2 := ToModif.Data;
    with TFrmEditCritereTri.Create(Self) do
    begin
      try
        Critere := p2;
        if ShowModal <> mrOk then
          Exit;
        p2.Assign(Critere);
        if TypeRecherche = trComplexe then
          TypeRecherche := trAucune;
        ReconstructSortLabel(ToModif);
      finally
        Free;
      end;
    end;
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
  if TypeRecherche = trComplexe then
    TypeRecherche := trAucune;
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
  FSortColumn := 2;
  FSortDirection := sdDescending;
  VTResult.Header.Columns[0].ImageIndex := -1;
  VTResult.Header.Columns[1].ImageIndex := -1;
  VTResult.Header.Columns[2].ImageIndex := -1;
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

procedure TfrmRecherche.SpeedButton1Click(Sender: TObject);
begin
  if not IsEqualGUID(vtPersonnes.CurrentValue, GUID_NULL) then
  begin
    CritereSimple := vtPersonnes.CurrentValue;
    PageControl2.ActivePageIndex := 0;
    VTResult.RootNodeCount := 0;
    lbResult.Caption := '';

    Recherche.Fill(TRechercheSimple(LightComboCheck1.Value), vtPersonnes.CurrentValue, vtPersonnes.Caption);

    TypeRecherche := Recherche.TypeRecherche;

    Historique.EditConsultation(CritereSimple, LightComboCheck1.Value);
    VTResult.RootNodeCount := Recherche.Resultats.Count;
    lbResult.Caption := IntToStr(VTResult.RootNodeCount) + ' r�sultat(s) trouv�(s)';
  end;
end;

procedure TfrmRecherche.VTResultDblClick(Sender: TObject);
begin
  if Assigned(VTResult.FocusedNode) then
    Historique.AddWaiting(fcAlbum, Recherche.Resultats[VTResult.FocusedNode.Index].ID);
end;

procedure TfrmRecherche.methodeChange(Sender: TObject);
begin
  if (TypeRecherche = trComplexe) then
    TypeRecherche := trAucune;
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
begin
  if not Assigned(TreeView1.Selected) then
    Exit;
  with TFrmEditCritere.Create(Self) do
  begin
    try
      if ShowModal <> mrOk then
        Exit;
      if TBaseCritere(TreeView1.Selected.Data) is TGroupCritere then
        ParentNode := TreeView1.Selected
      else
        ParentNode := TreeView1.Selected.Parent;

      p := Recherche.AddCritere(TGroupCritere(ParentNode.Data));
      p.Assign(Critere);
      with TreeView1.Items.AddChild(ParentNode, '') do
      begin
        Data := p;
        ReconstructLabels(ParentNode);
        Selected := True;
      end;
      if TypeRecherche = trComplexe then
        TypeRecherche := trAucune;
    finally
      Free;
    end;
  end;
end;

procedure TfrmRecherche.Groupedecritre1Click(Sender: TObject);
var
  ParentNode: TTreeNode;
begin
  if not Assigned(TreeView1.Selected) then
    ParentNode := nil
  else if TBaseCritere(TreeView1.Selected.Data) is TGroupCritere then
    ParentNode := TreeView1.Selected
  else
    ParentNode := TreeView1.Selected.Parent;

  with TreeView1.Items.AddChild(ParentNode, methode.Items[0]) do
  begin
    if Assigned(ParentNode) then
    begin
      Data := Recherche.AddGroup(TGroupCritere(ParentNode.Data));
      ReconstructLabels(ParentNode);
    end
    else
      Data := Recherche.AddGroup(nil);
    Selected := True;
  end;
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
  lbResult.Caption := IntToStr(VTResult.RootNodeCount) + ' r�sultat(s) trouv�(s)';
end;

procedure TfrmRecherche.VTResultGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
begin
  CellText := '';
  if TextType = ttNormal then
    case Column of
      0:
        CellText := FormatTitre(Recherche.Resultats[Node.Index].Titre);
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

type
  TAlbumCompare = class(TComparer<TAlbumLite>)
    function Compare(const Left, Right: TAlbumLite): Integer; override;
  end;

function TAlbumCompare.Compare(const Left, Right: TAlbumLite): Integer;
begin
  case FSortColumn of
    0:
      Result := CompareText(TAlbumLite(Left).Titre, TAlbumLite(Right).Titre);
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

procedure TfrmRecherche.VTResultHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
begin
  // attention: resultatsinfos n'est pas tri�!!!!
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
  Recherche.Resultats.Sort(TAlbumCompare.Create);
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

  procedure Process(Critere: TGroupCritere; ParentNode: TTreeNode = nil);
  var
    ANode: TTreeNode;
    aCritere: TBaseCritere;
  begin
    ANode := TreeView1.Items.AddChild(ParentNode, methode.Items[Integer(Critere.GroupOption)]);
    ANode.Data := Critere;
    for aCritere in Critere.SousCriteres do
      if aCritere is TGroupCritere then
        Process(aCritere as TGroupCritere, ANode)
      else
        TreeView1.Items.AddChild(ANode, TCritere(aCritere).Champ + ' ' + TCritere(aCritere).Test).Data := aCritere;
    ReconstructLabels(ANode);
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
begin
  with ParentNode do
    for i := 0 to Count - 1 do
      with Item[i] do
        if TObject(Data) is TGroupCritere then
          Text := methode.Text + '...'
        else
          with TCritere(Data) do
            if i = 0 then
              Text := Champ + ' ' + Test
            else
              Text := methode.Text + ' ' + Champ + ' ' + Test;
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
begin
  if not Assigned(TreeView1.Selected) then
    Exit;
  with TFrmEditCritereTri.Create(Self) do
  begin
    try
      if ShowModal <> mrOk then
        Exit;

      p := Recherche.AddSort;
      p.Assign(Critere);
      Node := TreeView2.Items.Add(nil, '');
      with Node do
      begin
        Data := p;
        ReconstructSortLabel(Node);
        Selected := True;
      end;
      if TypeRecherche = trComplexe then
        TypeRecherche := trAucune;
    finally
      Free;
    end;
  end;
end;

procedure TfrmRecherche.ReconstructSortLabel(Node: TTreeNode);
begin
  with TCritereTri(Node.Data) do
    Node.Text := '(' + IIf(NullsFirst, '*', '') + IIf(Asc, '+', '-') + IIf(NullsLast, '*', '') + ') ' + LabelChamp;
end;

procedure TfrmRecherche.TreeView2Change(Sender: TObject; Node: TTreeNode);
begin
  Modif.Enabled := Assigned(Node);
  moins.Enabled := Assigned(Node);
end;

end.
