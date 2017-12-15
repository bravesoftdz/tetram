unit UfrmExportation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, IOUtils, System.UITypes,
  Vcl.Dialogs, ActnList, StdActns, VirtualTrees, StdCtrls, Buttons, BDTK.GUI.Utils,
  VDTButton, ExtCtrls, BDTK.GUI.Controls.VirtualTree, BD.Utils.GUIUtils, BD.GUI.Forms, PngSpeedButton;

type
  TFileStream = class(Classes.TFileStream)
    procedure WriteString(const Chaine: string);
    procedure WriteStringLN(const Chaine: string);
  end;

  TfrmExportation = class(TbdtForm)
    Panel14: TPanel;
    VDTButton20: TVDTButton;
    vstExportation: TVirtualStringTree;
    vstAlbums: TVirtualStringTree;
    VDTButton1: TVDTButton;
    VDTButton2: TVDTButton;
    VDTButton3: TVDTButton;
    SaveDialog1: TSaveDialog;
    VDTButton4: TVDTButton;
    procedure FormCreate(Sender: TObject);
    procedure VDTButton20Click(Sender: TObject);
    procedure VDTButton1Click(Sender: TObject);
    procedure vstExportationGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstExportationPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure vstExportationFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VDTButton2Click(Sender: TObject);
    procedure VDTButton3Click(Sender: TObject);
  private
    { Déclarations privées }
    fWaiting: IWaiting;
    fAbort: Integer;
    procedure AjouterAlbum(Source, NodeSerie: PVirtualNode);
    function AjouterSerie(Source: PVirtualNode; Complete: Boolean): PVirtualNode;
    procedure WriteNode(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
  public
    { Déclarations publiques }
  end;

implementation

uses BD.Common, BD.Entities.Lite, BD.Utils.StrUtils, BD.Entities.Full, BDTK.Entities.Dao.Lite, BDTK.Entities.Dao.Full,
  BD.Entities.Utils.Serializer, BD.Utils.Serializer.JSON, BD.Entities.Common, BD.Entities.Factory.Lite;

{$R *.dfm}
{ TFileStream }

procedure TFileStream.WriteString(const Chaine: string);
begin
  WriteBuffer(Chaine[1], Length(Chaine));
end;

procedure TFileStream.WriteStringLN(const Chaine: string);
begin
  WriteString(Chaine + #13#10);
end;

procedure TfrmExportation.FormCreate(Sender: TObject);
begin
  TGlobalVar.Mode_en_cours := mdExportation;

  PrepareLV(Self);

  ChargeImage(vstAlbums.Background, 'FONDVT');
  ChargeImage(vstExportation.Background, 'FONDVT');

  vstAlbums.Mode := vmAlbumsSerie;
  vstExportation.NodeDataSize := SizeOf(RNodeInfo);
end;

procedure TfrmExportation.VDTButton20Click(Sender: TObject);
begin
  ModalResult := mrCancel;
  Release;
end;

procedure TfrmExportation.VDTButton1Click(Sender: TObject);
begin
  case vstAlbums.GetNodeLevel(vstAlbums.FocusedNode) of
    0:
      AjouterSerie(vstAlbums.FocusedNode, True);
    1:
      AjouterAlbum(vstAlbums.FocusedNode, AjouterSerie(vstAlbums.FocusedNode.Parent, False));
  end;
end;

function TfrmExportation.AjouterSerie(Source: PVirtualNode; Complete: Boolean): PVirtualNode;
var
  NodeAlbum: PVirtualNode;
  NewInitialeInfo, InitialeInfo: PInitialeInfo;
  NodeInfo: ^RNodeInfo;
begin
  Result := nil;
  if not Assigned(Source) then
    Exit;
  NodeInfo := vstAlbums.GetNodeData(Source);
  InitialeInfo := NodeInfo.InitialeInfo;

  Result := vstExportation.GetFirst;
  while Assigned(Result) do
  begin
    NodeInfo := vstExportation.GetNodeData(Result);
    if RInitialeInfo(NodeInfo.InitialeInfo^).sValue = InitialeInfo.sValue then
      Break;
    Result := vstExportation.GetNextSibling(Result);
  end;

  if not Assigned(Result) then
  begin
    Result := vstExportation.AddChild(nil);
    NodeInfo := vstExportation.GetNodeData(Result);
    New(NewInitialeInfo);
    NewInitialeInfo.Initiale := InitialeInfo.Initiale;
    NewInitialeInfo.Count := InitialeInfo.Count;
    NewInitialeInfo.sValue := InitialeInfo.sValue;
    NodeInfo.InitialeInfo := NewInitialeInfo;
  end;

  if Assigned(Result) and Complete then
  begin
    NodeAlbum := vstAlbums.GetFirstChild(Source);
    while Assigned(NodeAlbum) do
    begin
      AjouterAlbum(NodeAlbum, Result);
      NodeAlbum := vstAlbums.GetNextSibling(NodeAlbum);
    end;
  end;
end;

procedure TfrmExportation.AjouterAlbum(Source, NodeSerie: PVirtualNode);
var
  NodeInfo: ^RNodeInfo;
  PA: TAlbumLite;
  Node: PVirtualNode;
begin
  if not Assigned(Source) then
    Exit;
  if not Assigned(NodeSerie) then
    Exit;
  NodeInfo := vstAlbums.GetNodeData(Source);
  PA := NodeInfo.Detail as TAlbumLite;

  Node := vstExportation.GetFirstChild(NodeSerie);
  while Assigned(Node) do
  begin
    NodeInfo := vstExportation.GetNodeData(Node);
    if IsEqualGUID(TAlbumLite(NodeInfo.Detail).ID, PA.ID) then
      Exit;
    Node := vstExportation.GetNextSibling(Node);
  end;

  NodeInfo := vstExportation.GetNodeData(vstExportation.AddChild(NodeSerie));
  NodeInfo.Detail := TFactoryAlbumLite.Duplicate(PA);
end;

procedure TfrmExportation.vstExportationGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  InitialeInfo: PInitialeInfo;
  NodeInfo: ^RNodeInfo;
begin
  CellText := '';
  NodeInfo := Sender.GetNodeData(Node);
  if Sender.GetNodeLevel(Node) > 0 then
  begin
    if TextType = ttStatic then
      Exit;
    CellText := NodeInfo.Detail.ChaineAffichage;
  end
  else
  begin
    InitialeInfo := NodeInfo.InitialeInfo;
    if TextType = ttNormal then
      CellText := InitialeInfo.Initiale
    else
      AjoutString(CellText, NonZero(IntToStr(Node.ChildCount)), '', ' - (', ')');
  end;
end;

procedure TfrmExportation.vstExportationPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  if (Sender.GetNodeLevel(Node) = 0) and (TextType = ttNormal) then
  begin
    TargetCanvas.Font.Height := -11;
    TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsBold];
  end;
end;

procedure TfrmExportation.vstExportationFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  NodeInfo: ^RNodeInfo;
begin
  NodeInfo := Sender.GetNodeData(Node);
  case Sender.GetNodeLevel(Node) of
    0:
      Dispose(NodeInfo.InitialeInfo);
    1:
      NodeInfo.Detail.Free;
  end;
end;

procedure TfrmExportation.VDTButton2Click(Sender: TObject);
begin
  vstExportation.DeleteSelectedNodes;
end;

procedure TfrmExportation.VDTButton3Click(Sender: TObject);
var
  Fichier: string;
  FFichierExport: TFileStream;
  Count: Integer;
  Node: PVirtualNode;
  vstExport: TVirtualStringTree;
begin
  if SaveDialog1.Execute then
  begin
    if Sender = VDTButton4 then
      vstExport := vstAlbums
    else
      vstExport := vstExportation;

    Fichier := SaveDialog1.FileName;
    TDirectory.CreateDirectory(TPath.GetDirectoryName(Fichier));

    fAbort := 0;
    fWaiting := TWaiting.Create('Exportation...', 2000, @fAbort);

    Count := 0;
    Node := vstExport.GetFirst;
    while Assigned(Node) do
    begin
      Inc(Count, Node.ChildCount + 1); // +1 pour le noeud trouvé
      Node := vstExport.GetNextSibling(Node);
    end;

    fWaiting.ShowProgression('Exportation...', 0, Count);
    FFichierExport := TFileStream.Create(Fichier, fmCreate, fmShareExclusive);
    try
      FFichierExport.WriteString('[');
      vstExport.IterateSubtree(nil, WriteNode, FFichierExport, [], True);
      FFichierExport.WriteString(']');
      fWaiting.ShowProgression('Exportation...', epFin);
    finally
      FreeAndNil(FFichierExport);
      fWaiting := nil;
    end;
  end;
end;

procedure TfrmExportation.WriteNode(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
var
  FFichierExport: TFileStream;
  NodeInfo: ^RNodeInfo;
  album: TAlbumFull;
begin
  if Sender.GetNodeLevel(Node) = 1 then
  begin
    FFichierExport := Data;
    NodeInfo := Sender.GetNodeData(Node);
    album := TDaoAlbumFull.getInstance(TAlbumLite(NodeInfo.Detail).ID);
    try
      FFichierExport.WriteString(TEntitesSerializer.AsJson(album, [soFull]) + ',');
    finally
      album.Free;
    end;
  end;
  fWaiting.ShowProgression('Exportation...', epNext);
  Abort := fAbort <> 0;
end;

end.
