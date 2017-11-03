unit Form_Exportation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdActns, VirtualTrees, StdCtrls, Buttons,
  VDTButton, ExtCtrls, VirtualTree, Procedures;

type
  TFileStream = class(Classes.TFileStream)
    procedure WriteString(const Chaine: string);
    procedure WriteStringLN(const Chaine: string);
  end;

  TFrmExportation = class(TForm)
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
    procedure vstExportationGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vstExportationPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure vstExportationFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VDTButton2Click(Sender: TObject);
    procedure VDTButton3Click(Sender: TObject);
  private
    { D�clarations priv�es }
    fWaiting: IWaiting;
    fAbort: Integer;
    procedure AjouterAlbum(Source, NodeSerie: PVirtualNode);
    function AjouterSerie(Source: PVirtualNode; Complete: Boolean): PVirtualNode;
    procedure WriteNode(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
  public
    { D�clarations publiques }
  end;

implementation

uses CommonConst, TypeRec, Commun, LoadComplet;

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

procedure TFrmExportation.FormCreate(Sender: TObject);
begin
  Mode_en_cours := mdExportation;

  PrepareLV(Self);

  ChargeImage(vstAlbums.Background, 'FONDVT');
  ChargeImage(vstExportation.Background, 'FONDVT');

  vstAlbums.Mode := vmAlbumsSerie;
  vstExportation.NodeDataSize := SizeOf(RNodeInfo);
end;

procedure TFrmExportation.VDTButton20Click(Sender: TObject);
begin
  ModalResult := mrCancel;
  Release;
end;

procedure TFrmExportation.VDTButton1Click(Sender: TObject);
begin
  case vstAlbums.GetNodeLevel(vstAlbums.FocusedNode) of
    0: AjouterSerie(vstAlbums.FocusedNode, True);
    1: AjouterAlbum(vstAlbums.FocusedNode, AjouterSerie(vstAlbums.FocusedNode.Parent, False));
  end;
end;

function TFrmExportation.AjouterSerie(Source: PVirtualNode; Complete: Boolean): PVirtualNode;
var
  NodeAlbum: PVirtualNode;
  NewInitialeInfo, InitialeInfo: PInitialeInfo;
  NodeInfo: ^RNodeInfo;
begin
  Result := nil;
  if not Assigned(Source) then Exit;
  NodeInfo := vstAlbums.GetNodeData(Source);
  InitialeInfo := NodeInfo.InitialeInfo;

  Result := vstExportation.GetFirst;
  while Assigned(Result) do begin
    NodeInfo := vstExportation.GetNodeData(Result);
    if RInitialeInfo(NodeInfo.InitialeInfo^).iValue = InitialeInfo.iValue then Break;
    Result := vstExportation.GetNextSibling(Result);
  end;

  if not Assigned(Result) then begin
    Result := vstExportation.AddChild(nil);
    NodeInfo := vstExportation.GetNodeData(Result);
    New(NewInitialeInfo);
    CopyMemory(NewInitialeInfo, InitialeInfo, SizeOf(RInitialeInfo));
    NodeInfo.InitialeInfo := NewInitialeInfo;
  end;

  if Assigned(Result) and Complete then begin
    NodeAlbum := vstAlbums.GetFirstChild(Source);
    while Assigned(NodeAlbum) do begin
      AjouterAlbum(NodeAlbum, Result);
      NodeAlbum := vstAlbums.GetNextSibling(NodeAlbum);
    end;
  end;
end;

procedure TFrmExportation.AjouterAlbum(Source, NodeSerie: PVirtualNode);
var
  NodeInfo: ^RNodeInfo;
  PA: TAlbum;
  Node: PVirtualNode;
begin
  if not Assigned(Source) then Exit;
  if not Assigned(NodeSerie) then Exit;
  NodeInfo := vstAlbums.GetNodeData(Source);
  PA := NodeInfo.Detail as TAlbum;

  Node := vstExportation.GetFirstChild(NodeSerie);
  while Assigned(Node) do begin
    NodeInfo := vstExportation.GetNodeData(Node);
    if TAlbum(NodeInfo.Detail).Reference = PA.Reference then Exit;
    Node := vstExportation.GetNextSibling(Node);
  end;

  NodeInfo := vstExportation.GetNodeData(vstExportation.AddChild(NodeSerie));
  NodeInfo.Detail := TAlbum.Duplicate(PA);
end;

procedure TFrmExportation.vstExportationGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var
  InitialeInfo: PInitialeInfo;
  NodeInfo: ^RNodeInfo;
begin
  CellText := '';
  NodeInfo := Sender.GetNodeData(Node);
  if Sender.GetNodeLevel(Node) > 0 then begin
    if TextType = ttStatic then Exit;
    CellText := NodeInfo.Detail.ChaineAffichage;
  end
  else begin
    InitialeInfo := NodeInfo.InitialeInfo;
    if TextType = ttNormal then
      CellText := InitialeInfo.Initiale
    else
      AjoutString(CellText, NonZero(IntToStr(Node.ChildCount)), '', ' - (', ')');
  end;
end;

procedure TFrmExportation.vstExportationPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
begin
  if (Sender.GetNodeLevel(Node) = 0) and (TextType = ttNormal) then begin
    TargetCanvas.Font.Height := -11;
    TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsBold];
  end;
end;

procedure TFrmExportation.vstExportationFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  NodeInfo: ^RNodeInfo;
begin
  NodeInfo := Sender.GetNodeData(Node);
  case Sender.GetNodeLevel(Node) of
    0: Dispose(NodeInfo.InitialeInfo);
    1: NodeInfo.Detail.Free;
  end;
end;

procedure TFrmExportation.VDTButton2Click(Sender: TObject);
begin
  vstExportation.DeleteSelectedNodes;
end;

procedure TFrmExportation.VDTButton3Click(Sender: TObject);
var
  Fichier: string;
  FFichierExport: TFileStream;
  Count: Integer;
  Node: PVirtualNode;
  vstExport: TVirtualStringTree;
begin
  if SaveDialog1.Execute then begin
    if Sender = VDTButton4 then
      vstExport := vstAlbums
    else
      vstExport := vstExportation;

    Fichier := SaveDialog1.FileName;
    ForceDirectories(ExtractFilePath(Fichier));

    fAbort := 0;
    fWaiting := TWaiting.Create('Exportation...', 2000, @fAbort);

    Count := 0;
    Node := vstExport.GetFirst;
    while Assigned(Node) do begin
      Inc(Count, Node.ChildCount + 1); // +1 pour le noeud trouv�
      Node := vstExport.GetNextSibling(Node);
    end;

    fWaiting.ShowProgression('Exportation...', 0, Count);
    FFichierExport := TFileStream.Create(Fichier, fmCreate, fmShareExclusive);
    try
      //      FFichierExport.WriteStringLN('<?xml version="1.0" encoding="ISO-8859-1"?><!DOCTYPE Albums SYSTEM "http://www.tetram.info/bdtheque/albums.dtd">');
      FFichierExport.WriteStringLN('<?xml version="1.0" encoding="ISO-8859-1"?>');
      FFichierExport.WriteStringLN('<Data>');

      vstExport.IterateSubtree(nil, WriteNode, FFichierExport, [], True);

      FFichierExport.WriteStringLN('</Data>');
      fWaiting.ShowProgression('Exportation...', epFin);
    finally
      FreeAndNil(FFichierExport);
      fWaiting := nil;
    end;
  end;
end;

procedure TFrmExportation.WriteNode(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
var
  FFichierExport: TFileStream;
  NodeInfo: ^RNodeInfo;
begin
  if Sender.GetNodeLevel(Node) = 1 then begin
    FFichierExport := Data;
    NodeInfo := Sender.GetNodeData(Node);
    with TAlbumComplet.Create(TAlbum(NodeInfo.Detail).Reference) do try
      WriteXMLToStream(FFichierExport);
    finally
      Free;
    end;
  end;
  fWaiting.ShowProgression('Exportation...', epNext);
  Abort := fAbort <> 0;
end;

end.
