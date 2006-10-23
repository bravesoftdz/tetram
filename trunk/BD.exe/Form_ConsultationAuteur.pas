unit Form_ConsultationAuteur;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Db, ExtCtrls, DBCtrls, StdCtrls, Menus, ComCtrls, ProceduresBDtk, 
  VDTButton, ActnList, Spin, Buttons, ReadOnlyCheckBox, ToolWin, VirtualTrees, jpeg, Procedures, ShellAPI, VirtualTree, LoadComplet;

type
  TFrmConsultationAuteur = class(TForm, IImpressionApercu)
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
    procedure lvScenaristesDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Imprimer1Click(Sender: TObject);
    procedure vstSeriesDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edNomClick(Sender: TObject);
    procedure vstSeriesInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstSeriesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vstSeriesInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
    procedure vstSeriesPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure FicheApercuExecute(Sender: TObject);
  private
    { Déclarations privées }
    FAuteur: TAuteurComplet;
    procedure ImpressionExecute(Sender: TObject);
    procedure ApercuExecute(Sender: TObject);
    function ImpressionUpdate: Boolean;
    function ApercuUpdate: Boolean;
    function GetID_Auteur: TGUID;
    procedure SetID_Auteur(const Value: TGUID);
    procedure ClearForm;
  public
    { Déclarations publiques }
    property Auteur: TAuteurComplet read FAuteur;
    property ID_Auteur: TGUID read GetID_Auteur write SetID_Auteur;
  end;

implementation

{$R *.DFM}

uses Commun, TypeRec, Impression, DateUtils, UHistorique;

type
  PNodeInfo = ^RNodeInfo;
  RNodeInfo = record
    Serie: TSerieComplete;
    Album: TAlbum;
    ParaBD: TParaBD;
  end;

procedure TFrmConsultationAuteur.lvScenaristesDblClick(Sender: TObject);
begin
  if Assigned(TListView(Sender).Selected) then Historique.AddWaiting(fcRecherche, TAuteur(TListView(Sender).Selected.Data).Personne.ID, 0);
end;

procedure TFrmConsultationAuteur.FormCreate(Sender: TObject);
begin
  FAuteur := TAuteurComplet.Create;
  vstSeries.NodeDataSize := SizeOf(RNodeInfo);
  PrepareLV(Self);
end;

procedure TFrmConsultationAuteur.FormDestroy(Sender: TObject);
begin
  ClearForm;
  FAuteur.Free;
end;

procedure TFrmConsultationAuteur.ClearForm;
begin
  vstSeries.RootNodeCount := 0;
end;

procedure TFrmConsultationAuteur.Imprimer1Click(Sender: TObject);
begin
  ImpressionEmpruntsAlbum(ID_Auteur, TComponent(Sender).Tag = 1);
end;

procedure TFrmConsultationAuteur.vstSeriesDblClick(Sender: TObject);
var
  NodeInfo: PNodeInfo;
begin
  NodeInfo := vstSeries.GetNodeData(vstSeries.GetFirstSelected);
  if Assigned(NodeInfo) then begin
    if Assigned(NodeInfo.Album) then Historique.AddWaiting(fcAlbum, NodeInfo.Album.ID);
    if Assigned(NodeInfo.ParaBD) then Historique.AddWaiting(fcParaBD, NodeInfo.ParaBD.ID);
  end;
end;

procedure TFrmConsultationAuteur.FormShow(Sender: TObject);
begin
  Resize;
end;

procedure TFrmConsultationAuteur.ApercuExecute(Sender: TObject);
begin
  FicheApercuExecute(Sender);
end;

function TFrmConsultationAuteur.ApercuUpdate: Boolean;
begin
  Result := True;
end;

procedure TFrmConsultationAuteur.ImpressionExecute(Sender: TObject);
begin
  FicheApercuExecute(Sender);
end;

function TFrmConsultationAuteur.ImpressionUpdate: Boolean;
begin
  Result := True;
end;

procedure TFrmConsultationAuteur.edNomClick(Sender: TObject);
var
  s: string;
begin
  s := FAuteur.SiteWeb;
  if s <> '' then
    ShellExecute(Application.DialogHandle, nil, PChar(s), nil, nil, SW_NORMAL);
end;

function TFrmConsultationAuteur.GetID_Auteur: TGUID;
begin
  Result := FAuteur.ID_Auteur;
end;

procedure TFrmConsultationAuteur.SetID_Auteur(const Value: TGUID);
begin
  ClearForm;
  FAuteur.Fill(Value);

  edNom.Caption := FormatTitre(FAuteur.NomAuteur);
  Caption := 'Fiche d''auteur - ' + FAuteur.ChaineAffichage;
  if FAuteur.SiteWeb <> '' then begin
    edNom.Font.Color := clBlue;
    edNom.Font.Style := edNom.Font.Style + [fsUnderline];
    edNom.Cursor := crHandPoint;
  end
  else begin
    edNom.Font.Color := clWindowText;
    edNom.Font.Style := edNom.Font.Style - [fsUnderline];
    edNom.Cursor := crDefault;
  end;
  edBiographie.Lines.Text := FAuteur.Biographie.Text;

  vstSeries.RootNodeCount := FAuteur.Series.Count;
end;

procedure TFrmConsultationAuteur.vstSeriesInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  NodeInfo, ParentNodeInfo: PNodeInfo;
begin
  NodeInfo := Sender.GetNodeData(Node);
  if Sender.GetNodeLevel(Node) = 0 then begin
    NodeInfo.Serie := TSerieComplete(FAuteur.Series[Node.Index]);
    NodeInfo.Album := nil;
    NodeInfo.ParaBD := nil;
    if (NodeInfo.Serie.Albums.Count + NodeInfo.Serie.ParaBD.Count) > 0 then
      Include(InitialStates, ivsHasChildren)
    else
      Exclude(InitialStates, ivsHasChildren);
  end
  else begin
    ParentNodeInfo := Sender.GetNodeData(ParentNode);

    NodeInfo.Serie := nil;
    NodeInfo.Album := nil;
    NodeInfo.ParaBD := nil;

    if Integer(Node.Index) < ParentNodeInfo.Serie.Albums.Count then
      NodeInfo.Album := TAlbum(ParentNodeInfo.Serie.Albums[Node.Index])
    else
      NodeInfo.ParaBD := TParaBD(ParentNodeInfo.Serie.ParaBD[Integer(Node.Index) - ParentNodeInfo.Serie.Albums.Count]);
  end;
end;

procedure TFrmConsultationAuteur.vstSeriesInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
var
  NodeInfo: PNodeInfo;
begin
  NodeInfo := Sender.GetNodeData(Node);
  if Sender.GetNodeLevel(Node) = 0 then begin
    ChildCount := NodeInfo.Serie.Albums.Count + NodeInfo.Serie.ParaBD.Count;
  end;
end;

procedure TFrmConsultationAuteur.vstSeriesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var
  NodeInfo: PNodeInfo;
begin
  CellText := '';
  if TextType = ttNormal then begin
    NodeInfo := Sender.GetNodeData(Node);
    if Assigned(NodeInfo.Serie) then begin
      CellText := FormatTitre(NodeInfo.Serie.Titre);
      if CellText = '' then CellText := '<Sans série>';
    end
    else begin
      if Assigned(NodeInfo.Album) then CellText := NodeInfo.Album.ChaineAffichage;
      if Assigned(NodeInfo.ParaBD) then CellText := NodeInfo.ParaBD.ChaineAffichage;
    end;
  end;
end;

procedure TFrmConsultationAuteur.vstSeriesPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
begin
  if Sender.GetNodeLevel(Node) = 0 then
    TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsBold]
  else
    TargetCanvas.Font.Style := TargetCanvas.Font.Style - [fsBold];
end;

procedure TFrmConsultationAuteur.FicheApercuExecute(Sender: TObject);
begin
  ImpressionFicheAuteur(ID_Auteur, TComponent(Sender).Tag = 1);
end;

end.

