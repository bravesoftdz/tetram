unit Form_Recherche;

interface

uses
  SysUtils, Windows, Messages, Classes, Forms, Graphics, Controls, Menus, StdCtrls, Buttons, ComCtrls, ExtCtrls, ToolWin, Commun,
  CommonList, VirtualTrees, VirtualTree, ActnList, VDTButton, JvUIB, ComboCheck, ProceduresBDtk,
  Frame_RechercheRapide, LoadComplet;

type
  TFrmRecherche = class(TForm, IImpressionApercu)
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
    TreeView1: TTreeView;
    vtPersonnes: TVirtualStringTree;
    VTResult: TVirtualStringTree;
    LightComboCheck1: TLightComboCheck;
    MainMenu1: TMainMenu;
    Recherche1: TMenuItem;
    Exporter1: TMenuItem;
    Imprimer1: TMenuItem;
    lbResult: TLabel;
    FrameRechercheRapide1: TFrameRechercheRapide;
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
    procedure VTResultGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure VTResultPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure VTResultHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure LightComboCheck1Change(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
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
  public
    { Déclarations publiques }
    CritereSimple: TGUID;
    property TypeRecherche: TTypeRecherche read FTypeRecherche write SetTypeRecherche;
    function ImpressionEnabled: Boolean;
    function TransChamps(const Champ: string): string;
    function ValChamps(const Champ: string): Integer;
    function IsValChampBoolean(ValChamp: Integer): Boolean;
    procedure LoadRechFromStream(Stream: TStream);
  end;

implementation

uses
  Textes, DM_Princ, TypeRec, Impression, Math, Form_EditCritere, UHistorique, Procedures,
  Main;

{$R *.DFM}

var
  FSortColumn: Integer;
  FSortDirection: TSortDirection;

function TFrmRecherche.TransChamps(const Champ: string): string;
begin
  Result := '';
  if SameText(Champ, 'titrealbum') then Result := rsTransAlbum;
  if SameText(Champ, 'anneeparution') then Result := rsTransAnneeParution;
  if SameText(Champ, 'tome') then Result := rsTransTome;
  if SameText(Champ, 'horsserie') then Result := rsTransHorsSerie;
  if SameText(Champ, 'integrale') then Result := rsTransIntegrale;
  if SameText(Champ, 'uppersujetalbum') then Result := rsTransHistoire + ' ' + rsTransAlbum;
  if SameText(Champ, 'upperremarquesalbum') then Result := rsTransNotes + ' ' + rsTransAlbum;

  if SameText(Champ, 'titreserie') then Result := rsTransSerie;
  if SameText(Champ, 'uppersujetserie') then Result := rsTransHistoire + ' ' + rsTransSerie;
  if SameText(Champ, 'upperremarquesserie') then Result := rsTransNotes + ' ' + rsTransSerie;
  if SameText(Champ, 'terminee') then Result := rsTransSerieTerminee;
  if SameText(Champ, 'complete') then Result := rsTransSerieComplete;
  if SameText(Champ, 'suivremanquants') then Result := rsTransSerieChercherManquants;
  if SameText(Champ, 'suivresorties') then Result := rsTransSerieSuivreSorties;

  if SameText(Champ, 'anneeedition') then Result := rsTransAnneeEdition;
  if SameText(Champ, 'prix') then Result := rsTransPrix;
  if SameText(Champ, 'vo') then Result := rsTransVO;
  if SameText(Champ, 'couleur') then Result := rsTransCouleur;
  if SameText(Champ, 'isbn') then Result := rsTransISBN;
  if SameText(Champ, 'prete') then Result := rsTransPrete;
  if SameText(Champ, 'stock') then Result := rsTransStock;
  if SameText(Champ, 'typeedition') then Result := rsTransEdition;
  if SameText(Champ, 'dedicace') then Result := rsTransDedicace;
  if SameText(Champ, 'etat') then Result := rsTransEtat;
  if SameText(Champ, 'reliure') then Result := rsTransReliure;
  if SameText(Champ, 'orientation') then Result := rsTransOrientation;
  if SameText(Champ, 'formatedition') then Result := rsTransFormatEdition;
  if SameText(Champ, 'typeedition') then Result := rsTransTypeEdition;
  if SameText(Champ, 'dateachat') then Result := rsTransDateAchat;
  if SameText(Champ, 'gratuit') then Result := rsTransGratuit;
  if SameText(Champ, 'offert') then Result := rsTransOffert;
  if SameText(Champ, 'nombredepages') then Result := rsTransNombreDePages;
  if SameText(Champ, 'anneecote') then Result := rsTransCote + ' (' + rsTransAnnee + ')';
  if SameText(Champ, 'prixcote') then Result := rsTransCote + ' (' + rsTransPrix + ')';

  if SameText(Champ, 'genreserie') then Result := rsTransGenre + ' *';
end;

function TFrmRecherche.ValChamps(const Champ: string): Integer;
begin
  Result := 0;
  if (Champ = rsTransAlbum) or (SameText(Champ, 'titrealbum')) then Result := 1;
  if (Champ = rsTransAnneeParution) or (SameText(Champ, 'anneeparution')) then Result := 2;
  if (Champ = rsTransTome) or (SameText(Champ, 'tome')) then Result := 3;
  if (Champ = rsTransHorsSerie) or (SameText(Champ, 'horsserie')) then Result := 4;
  if (Champ = rsTransIntegrale) or (SameText(Champ, 'integrale')) then Result := 5;
  if (Champ = rsTransHistoire + ' ' + rsTransAlbum) or (SameText(Champ, 'sujetalbum')) then Result := 6;
  if (Champ = rsTransNotes + ' ' + rsTransAlbum) or (SameText(Champ, 'remarquesalbum')) then Result := 7;

  if (Champ = rsTransSerie) or (SameText(Champ, 'titreserie')) then Result := 8;
  if (Champ = rsTransHistoire + ' ' + rsTransSerie) or (SameText(Champ, 'sujetserie')) then Result := 9;
  if (Champ = rsTransNotes + ' ' + rsTransSerie) or (SameText(Champ, 'remarquesserie')) then Result := 10;
  if (Champ = rsTransSerieTerminee) or (SameText(Champ, 'terminee')) then Result := 11;
  if (Champ = rsTransSerieComplete) or (SameText(Champ, 'complete')) then Result := 33;
  if (Champ = rsTransSerieChercherManquants) or (SameText(Champ, 'suivremanquants')) then Result := 34;
  if (Champ = rsTransSerieSuivreSorties) or (SameText(Champ, 'suivresorties')) then Result := 35;

  if (Champ = rsTransAnneeEdition) or (SameText(Champ, 'anneeedition')) then Result := 12;
  if (Champ = rsTransPrix) or (SameText(Champ, 'prix')) then Result := 13;
  if (Champ = rsTransVO) or (SameText(Champ, 'vo')) then Result := 14;
  if (Champ = rsTransCouleur) or (SameText(Champ, 'couleur')) then Result := 15;
  if (Champ = rsTransISBN) or (SameText(Champ, 'isbn')) then Result := 16;
  if (Champ = rsTransPrete) or (SameText(Champ, 'prete')) then Result := 17;
  if (Champ = rsTransStock) or (SameText(Champ, 'stock')) then Result := 18;
  if (Champ = rsTransEdition) or (SameText(Champ, 'typeedition')) then Result := 19;
  if (Champ = rsTransDedicace) or (SameText(Champ, 'dedicace')) then Result := 20;
  if (Champ = rsTransEtat) or (SameText(Champ, 'etat')) then Result := 21;
  if (Champ = rsTransReliure) or (SameText(Champ, 'reliure')) then Result := 22;
  if (Champ = rsTransOrientation) or (SameText(Champ, 'orientation')) then Result := 24;
  if (Champ = rsTransFormatEdition) or (SameText(Champ, 'formatedition')) then Result := 25;
  if (Champ = rsTransTypeEdition) or (SameText(Champ, 'typeedition')) then Result := 26;
  if (Champ = rsTransDateAchat) or (SameText(Champ, 'dateachat')) then Result := 27;
  if (Champ = rsTransGratuit) or (SameText(Champ, 'gratuit')) then Result := 28;
  if (Champ = rsTransOffert) or (SameText(Champ, 'offert')) then Result := 29;
  if (Champ = rsTransNombreDePages) or (SameText(Champ, 'nombredepages')) then Result := 30;
  if (Champ = rsTransCote + ' (' + rsTransAnnee + ')') or (SameText(Champ, 'anneecote')) then Result := 31;
  if (Champ = rsTransCote + ' (' + rsTransPrix + ')') or (SameText(Champ, 'prixcote')) then Result := 32;

  if (Champ = rsTransGenre + ' *') or (SameText(Champ, 'ID_Genre')) then Result := 23;
end;

function TFrmRecherche.IsValChampBoolean(ValChamp: Integer): Boolean;
begin
  Result := ValChamp in [4, 5, 11, 14, 15, 17, 18, 19, 20, 28, 29, 33, 34, 35];
end;

procedure TFrmRecherche.SetTypeRecherche(Value: TTypeRecherche);
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
    trComplexe: PageControl2.ActivePageIndex := 1;
    trSimple: PageControl2.ActivePageIndex := 0;
  end;
  FTypeRecherche := Value;
  Fond.Impression.Update;
  Fond.ApercuImpression.Update;
end;

procedure TFrmRecherche.FormCreate(Sender: TObject);
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
  ChargeImage(VTPersonnes.Background, 'FONDVT');
  ChargeImage(VTResult.Background, 'FONDVT');
  FrameRechercheRapide1.VirtualTreeView := vtPersonnes;
  FrameRechercheRapide1.ShowNewButton := False;

  PageControl2.ActivePageIndex := 0;

  VTResult.TreeOptions.PaintOptions := VTResult.TreeOptions.PaintOptions - [toShowButtons, toShowDropmark, toShowRoot];

  btnRecherche.Font.Style := btnRecherche.Font.Style + [fsBold];
  VTPersonnes.Mode := vmPersonnes;
  TypeRecherche := Recherche.TypeRecherche;
  TreeView1.Items.AddChild(nil, 'Critères').Data := Recherche.Criteres;
  methode.ItemIndex := Integer(Recherche.Criteres.GroupOption);
end;

procedure TFrmRecherche.ModifClick(Sender: TObject);
var
  ToModif: TTreeNode;
  p: TCritere;
begin
  ToModif := TreeView1.Selected;
  if not (Assigned(ToModif) and (Integer(ToModif.Data) > 0)) then Exit;
  p := ToModif.Data;
  with TFrmEditCritere.Create(Self) do
  begin
    try
      Critere := p;
      if ShowModal <> mrOk then Exit;
      p.Assign(Critere);
      if TypeRecherche = trComplexe then TypeRecherche := trAucune;
      ReconstructLabels(ToModif.Parent);
    finally
      Free;
    end;
  end;
end;

procedure TFrmRecherche.plusClick(Sender: TObject);
var
  p: TPoint;
begin
  if Assigned(TreeView1.Selected) then
  begin
    p := plus.ClientToScreen(Point(0, plus.Height));
    PopupMenu1.Popup(p.x, p.y);
  end
  else
    Groupedecritre1.Click;
end;

procedure TFrmRecherche.moinsClick(Sender: TObject);
var
  p: TBaseCritere;
  ParentNode: TTreeNode;
begin
  if TypeRecherche = trComplexe then TypeRecherche := trAucune;
  if Assigned(TreeView1.Selected) and (TreeView1.Selected <> TreeView1.Items.GetFirstNode) then
  begin
    p := TreeView1.Selected.Data;
    ParentNode := TreeView1.Selected.Parent;
    TreeView1.Selected.Delete;
    Recherche.Delete(p);
    ReconstructLabels(ParentNode);
  end;
end;

procedure TFrmRecherche.FormDestroy(Sender: TObject);
begin
  VTResult.RootNodeCount := 0;
  lbResult.Caption := '';
  Recherche.Free;
end;

procedure TFrmRecherche.RechPrint(Sender: TObject);
begin
  ImpressionRecherche(Recherche, TComponent(Sender).Tag = 1);
end;

procedure TFrmRecherche.SpeedButton1Click(Sender: TObject);
begin
  if not IsEqualGUID(VTPersonnes.CurrentValue, GUID_NULL) then
  begin
    CritereSimple := VTPersonnes.CurrentValue;
    PageControl2.ActivePageIndex := 0;
    VTResult.RootNodeCount := 0;
    lbResult.Caption := '';

    Recherche.Fill(TRechercheSimple(LightComboCheck1.Value), vtPersonnes.CurrentValue, vtPersonnes.Caption);

    TypeRecherche := Recherche.TypeRecherche;

    Historique.EditConsultation(CritereSimple, LightComboCheck1.Value);
    VTResult.RootNodeCount := Recherche.Resultats.Count;
    lbResult.Caption := IntToStr(VTResult.RootNodeCount) + ' résultat(s) trouvé(s)';
  end;
end;

procedure TFrmRecherche.VTResultDblClick(Sender: TObject);
begin
  if Assigned(VTResult.FocusedNode) then Historique.AddWaiting(fcAlbum, Recherche.Resultats[VTResult.FocusedNode.Index].ID);
end;

procedure TFrmRecherche.methodeChange(Sender: TObject);
begin
  if (TypeRecherche = trComplexe) then TypeRecherche := trAucune;
  TGroupCritere(TreeView1.Selected.Parent.Data).GroupOption := TGroupOption(methode.ItemIndex);
  ReconstructLabels(TreeView1.Selected.Parent);
end;

function TFrmRecherche.ImpressionEnabled: Boolean;
begin
  Result := RechercheImprime.Enabled;
end;

procedure TFrmRecherche.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
  Modif.Enabled := Assigned(Node) and (TBaseCritere(Node.Data) is TCritere);
  moins.Enabled := Assigned(Node);
  methode.Visible := Assigned(Node) and Assigned(Node.Parent) and (TBaseCritere(Node.Parent.Data) is TGroupCritere);
  if methode.Visible then methode.ItemIndex := Integer(TGroupCritere(Node.Parent.Data).GroupOption);
end;

procedure TFrmRecherche.TreeView1Collapsing(Sender: TObject; Node: TTreeNode; var AllowCollapse: Boolean);
begin
  AllowCollapse := False;
end;

procedure TFrmRecherche.Critre1Click(Sender: TObject);
var
  p: TCritere;
  ParentNode: TTreeNode;
begin
  if not Assigned(TreeView1.Selected) then Exit;
  with TFrmEditCritere.Create(Self) do
  begin
    try
      if ShowModal <> mrOk then Exit;
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
      if TypeRecherche = trComplexe then TypeRecherche := trAucune;
    finally
      Free;
    end;
  end;
end;

procedure TFrmRecherche.Groupedecritre1Click(Sender: TObject);
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

procedure TFrmRecherche.btnRechercheClick(Sender: TObject);
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

procedure TFrmRecherche.VTResultGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
begin
  CellText := '';
  if TextType = ttNormal then
    case Column of
      0: CellText := FormatTitre(Recherche.Resultats[Node.Index].Titre);
      1: CellText := NonZero(IntToStr(Recherche.Resultats[Node.Index].Tome));
      2: CellText := FormatTitre(Recherche.Resultats[Node.Index].Serie);
    end
  else if (Recherche.TypeRecherche = trSimple) and (Recherche.ResultatsInfos.Count > 0) then
    case Column of
      0: AjoutString(CellText, Recherche.ResultatsInfos[Node.Index], '', '(', ')');
    end;
end;

procedure TFrmRecherche.VTResultPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
begin
  if TextType = ttStatic then TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsItalic];
end;

function ResultListCompare(Item1, Item2: Pointer): Integer;
begin
  case FSortColumn of
    0: Result := CompareText(TAlbum(Item1).Titre, TAlbum(Item2).Titre);
    1: Result := CompareValue(TAlbum(Item1).Tome, TAlbum(Item2).Tome);
    2:
      begin
        Result := CompareText(TAlbum(Item1).Serie, TAlbum(Item2).Serie);
        if Result = 0 then
          Result := CompareValue(TAlbum(Item1).Tome, TAlbum(Item2).Tome);
      end;
    else
      Result := 0;
  end;
  if FSortDirection = sdDescending then Result := -Result;
end;

procedure TFrmRecherche.VTResultHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // attention: resultatsinfos n'est pas trié!!!!
  Exit;

  if Column <> FSortColumn then
    FSortDirection := sdAscending
  else if FSortDirection = sdAscending then
    FSortDirection := sdDescending
  else
    FSortDirection := sdAscending;
  if FSortColumn <> -1 then VTResult.Header.Columns[FSortColumn].ImageIndex := -1;
  FSortColumn := Column;
  if FSortDirection = sdAscending then
    VTResult.Header.Columns[FSortColumn].ImageIndex := 0
  else
    VTResult.Header.Columns[FSortColumn].ImageIndex := 1;
  VTResult.Header.SortColumn := FSortColumn;
  Recherche.Resultats.Sort(@ResultListCompare);
  VTResult.ReinitNode(VTResult.RootNode, True);
  VTResult.Invalidate;
  VTResult.Refresh;
end;

procedure TFrmRecherche.LightComboCheck1Change(Sender: TObject);
const
  NewMode: array[0..4] of TVirtualMode = (vmPersonnes,
    vmSeries,
    vmEditeurs,
    vmGenres,
    vmCollections);
var
  Mode: TVirtualMode;
begin
  Mode := NewMode[LightComboCheck1.Value];
  if (VTPersonnes.Mode <> Mode) then
    VTPersonnes.Mode := Mode;
end;

procedure TFrmRecherche.ApercuExecute(Sender: TObject);
begin
  RechPrint(Sender);
end;

function TFrmRecherche.ApercuUpdate: Boolean;
begin
  Result := ImpressionEnabled;
end;

procedure TFrmRecherche.ImpressionExecute(Sender: TObject);
begin
  RechPrint(Sender);
end;

function TFrmRecherche.ImpressionUpdate: Boolean;
begin
  Result := ImpressionEnabled;
end;

procedure TFrmRecherche.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    vtPersonnes.OnDblClick(nil);
  end;
end;

procedure TFrmRecherche.LoadRechFromStream(Stream: TStream);

  procedure Process(Critere: TGroupCritere; ParentNode: TTreeNode = nil);
  var
    i: Integer;
    ANode: TTreeNode;
    aCritere: TBaseCritere;
  begin
    ANode := TreeView1.Items.AddChild(ParentNode, methode.Items[Integer(Critere.GroupOption)]);
    ANode.Data := Critere;
    for i := 0 to Pred(Critere.SousCriteres.Count) do
    begin
      aCritere := Critere.SousCriteres[i];
      if aCritere is TGroupCritere then
        Process(aCritere as TGroupCritere, ANode)
      else
        TreeView1.Items.AddChild(ANode, TCritere(aCritere).Champ + ' ' + TCritere(aCritere).Test).Data := aCritere;
    end;
    ReconstructLabels(ANode);
  end;

begin
  Recherche.LoadFromStream(Stream);

  TreeView1.Items.BeginUpdate;
  try
    TreeView1.Items.Clear;
    Process(Recherche.Criteres);
    TreeView1.Items[0].Expand(True);
  finally
    TreeView1.Items.EndUpdate;
  end;
end;

procedure TFrmRecherche.ReconstructLabels(ParentNode: TTreeNode);
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

end.

