unit UfrmConsultationAuteur;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, System.UITypes, Db, ExtCtrls, DBCtrls, StdCtrls, Menus, ComCtrls, ProceduresBDtk,
  VDTButton, ActnList, Buttons, ToolWin, VirtualTrees, jpeg, Procedures, ShellAPI, VirtualTree, Entities.Full, UBdtForms, StrUtils,
  System.Actions;

type
  TfrmConsultationAuteur = class(TBdtForm, IImpressionApercu, IFicheEditable)
    Popup3: TPopupMenu;
    Informations1: TMenuItem;
    Emprunts1: TMenuItem;
    MenuItem1: TMenuItem;
    Adresse1: TMenuItem;
    ActionList1: TActionList;
    FicheImprime: TAction;
    FicheApercu: TAction;
    ScrollBox2: TScrollBox;
    l_sujet: TLabel;
    l_annee: TLabel;
    edBiographie: TMemo;
    vstSeries: TVirtualStringTree;
    Label5: TLabel;
    edNom: TLabel;
    Bevel1: TBevel;
    MainMenu1: TMainMenu;
    Fiche1: TMenuItem;
    Aperuavantimpression1: TMenuItem;
    Aperuavantimpression2: TMenuItem;
    FicheModifier: TAction;
    Modifier1: TMenuItem;
    N1: TMenuItem;
    procedure lvScenaristesDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure vstSeriesDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edNomClick(Sender: TObject);
    procedure vstSeriesInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstSeriesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstSeriesInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
    procedure vstSeriesPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure FicheApercuExecute(Sender: TObject);
    procedure FicheModifierExecute(Sender: TObject);
    procedure vstSeriesAfterItemPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
  strict private
    FAuteur: TAuteurFull;
    procedure ImpressionExecute(Sender: TObject);
    procedure ApercuExecute(Sender: TObject);
    function ImpressionUpdate: Boolean;
    function ApercuUpdate: Boolean;
    function GetID_Auteur: TGUID;
    procedure SetID_Auteur(const Value: TGUID);
    procedure ClearForm;
    procedure ModificationExecute(Sender: TObject);
    function ModificationUpdate: Boolean;
  public
    { Déclarations publiques }
    property Auteur: TAuteurFull read FAuteur;
    property ID_Auteur: TGUID read GetID_Auteur write SetID_Auteur;
  end;

implementation

{$R *.DFM}

uses Commun, Entities.Lite, Impression, DateUtils, UHistorique, Proc_Gestions, UfrmFond,
  Entities.DaoFull, Entities.Common, Entities.FactoriesFull;

type
  PNodeInfo = ^RNodeInfo;

  RNodeInfo = record
    Serie: TSerieFull;
    Album: TAlbumLite;
    ParaBD: TParaBDLite;
  end;

procedure TfrmConsultationAuteur.lvScenaristesDblClick(Sender: TObject);
begin
  if Assigned(TListView(Sender).Selected) then
    Historique.AddWaiting(fcRecherche, TAuteurLite(TListView(Sender).Selected.Data).Personne.ID, 0);
end;

procedure TfrmConsultationAuteur.FormCreate(Sender: TObject);
begin
  FAuteur := TFactoryAuteurFull.getInstance;
  vstSeries.NodeDataSize := SizeOf(RNodeInfo);
  PrepareLV(Self);
end;

procedure TfrmConsultationAuteur.FormDestroy(Sender: TObject);
begin
  ClearForm;
  FAuteur.Free;
end;

procedure TfrmConsultationAuteur.ClearForm;
begin
  vstSeries.RootNodeCount := 0;
end;

procedure TfrmConsultationAuteur.vstSeriesAfterItemPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
var
  NodeInfo: PNodeInfo;
begin
  NodeInfo := Sender.GetNodeData(Node);
  if NodeInfo.Album <> nil then
    frmFond.DessineNote(TargetCanvas, ItemRect, NodeInfo.Album.Notation);
end;

procedure TfrmConsultationAuteur.vstSeriesDblClick(Sender: TObject);
var
  NodeInfo: PNodeInfo;
begin
  NodeInfo := vstSeries.GetNodeData(vstSeries.GetFirstSelected);
  if Assigned(NodeInfo) then
  begin
    if Assigned(NodeInfo.Album) then
      Historique.AddWaiting(fcAlbum, NodeInfo.Album.ID);
    if Assigned(NodeInfo.ParaBD) then
      Historique.AddWaiting(fcParaBD, NodeInfo.ParaBD.ID);
  end;
end;

procedure TfrmConsultationAuteur.FormShow(Sender: TObject);
begin
  Resize;
end;

procedure TfrmConsultationAuteur.ApercuExecute(Sender: TObject);
begin
  FicheApercuExecute(Sender);
end;

function TfrmConsultationAuteur.ApercuUpdate: Boolean;
begin
  Result := True;
end;

procedure TfrmConsultationAuteur.ImpressionExecute(Sender: TObject);
begin
  FicheApercuExecute(Sender);
end;

function TfrmConsultationAuteur.ImpressionUpdate: Boolean;
begin
  Result := True;
end;

procedure TfrmConsultationAuteur.edNomClick(Sender: TObject);
var
  s: string;
begin
  s := FAuteur.SiteWeb;
  if s <> '' then
    ShellExecute(Application.DialogHandle, nil, PChar(s), nil, nil, SW_NORMAL);
end;

function TfrmConsultationAuteur.GetID_Auteur: TGUID;
begin
  Result := FAuteur.ID_Auteur;
end;

procedure TfrmConsultationAuteur.SetID_Auteur(const Value: TGUID);
begin
  ClearForm;
  TDaoAuteurFull.Fill(FAuteur, Value, nil);

  edNom.Caption := FormatTitre(FAuteur.NomAuteur);
  Caption := 'Fiche d''auteur - ' + FAuteur.ChaineAffichage;
  if FAuteur.SiteWeb <> '' then
  begin
    edNom.Font.Color := clBlue;
    edNom.Font.Style := edNom.Font.Style + [fsUnderline];
    edNom.Cursor := crHandPoint;
  end
  else
  begin
    edNom.Font.Color := clWindowText;
    edNom.Font.Style := edNom.Font.Style - [fsUnderline];
    edNom.Cursor := crDefault;
  end;
  edBiographie.Text := FAuteur.Biographie;

  vstSeries.RootNodeCount := FAuteur.Series.Count;
end;

procedure TfrmConsultationAuteur.vstSeriesInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  NodeInfo, ParentNodeInfo: PNodeInfo;
begin
  NodeInfo := Sender.GetNodeData(Node);
  NodeInfo.Album := nil;
  NodeInfo.ParaBD := nil;
  if Sender.GetNodeLevel(Node) = 0 then
  begin
    NodeInfo.Serie := FAuteur.Series[Node.index];
    if (NodeInfo.Serie.Albums.Count + NodeInfo.Serie.ParaBD.Count) > 0 then
      Include(InitialStates, ivsHasChildren)
    else
      Exclude(InitialStates, ivsHasChildren);
  end
  else
  begin
    ParentNodeInfo := Sender.GetNodeData(ParentNode);

    NodeInfo.Serie := nil;

    if Integer(Node.index) < ParentNodeInfo.Serie.Albums.Count then
      NodeInfo.Album := ParentNodeInfo.Serie.Albums[Node.index]
    else
      NodeInfo.ParaBD := ParentNodeInfo.Serie.ParaBD[Integer(Node.index) - ParentNodeInfo.Serie.Albums.Count];
  end;
end;

procedure TfrmConsultationAuteur.vstSeriesInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
var
  NodeInfo: PNodeInfo;
begin
  NodeInfo := Sender.GetNodeData(Node);
  if Sender.GetNodeLevel(Node) = 0 then
  begin
    ChildCount := NodeInfo.Serie.Albums.Count + NodeInfo.Serie.ParaBD.Count;
  end;
end;

procedure TfrmConsultationAuteur.vstSeriesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeInfo: PNodeInfo;
begin
  CellText := '';
  if TextType = ttNormal then
  begin
    NodeInfo := Sender.GetNodeData(Node);
    if Assigned(NodeInfo.Serie) then
    begin
      CellText := FormatTitre(NodeInfo.Serie.TitreSerie);
      if CellText = '' then
        CellText := '<Sans série>';
    end
    else
    begin
      if Assigned(NodeInfo.Album) then
        CellText := NodeInfo.Album.ChaineAffichage;
      if Assigned(NodeInfo.ParaBD) then
        CellText := NodeInfo.ParaBD.ChaineAffichage;
    end;
  end;
end;

procedure TfrmConsultationAuteur.vstSeriesPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  if Sender.GetNodeLevel(Node) = 0 then
    TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsBold]
  else
    TargetCanvas.Font.Style := TargetCanvas.Font.Style - [fsBold];
end;

procedure TfrmConsultationAuteur.FicheApercuExecute(Sender: TObject);
begin
  ImpressionFicheAuteur(ID_Auteur, TComponent(Sender).Tag = 1);
end;

procedure TfrmConsultationAuteur.FicheModifierExecute(Sender: TObject);
begin
  Historique.AddWaiting(fcGestionModif, RefreshCallBack, nil, @ModifierAuteurs2, nil, ID_Auteur);
end;

procedure TfrmConsultationAuteur.ModificationExecute(Sender: TObject);
begin
  FicheModifierExecute(Sender);
end;

function TfrmConsultationAuteur.ModificationUpdate: Boolean;
begin
  Result := True;
end;

end.
