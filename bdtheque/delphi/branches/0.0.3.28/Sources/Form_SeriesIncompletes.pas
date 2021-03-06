unit Form_SeriesIncompletes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, LoadComplet, VirtualTrees, VirtualTree, ToolWin,
  Procedures, StdCtrls, ExtCtrls, Menus, ActnList;

type
  TfrmSeriesIncompletes = class(TForm, IImpressionApercu)
    vstAlbumsManquants: TVirtualStringTree;
    ActionList1: TActionList;
    ListeApercu: TAction;
    ListeImprime: TAction;
    Panel1: TPanel;
    CheckBox1: TCheckBox;
    MainMenu1: TMainMenu;
    Liste1: TMenuItem;
    Aperuavantimpression1: TMenuItem;
    Imprimer1: TMenuItem;
    CheckBox2: TCheckBox;
    procedure vstAlbumsManquantsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure vstAlbumsManquantsInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure ListeApercuExecute(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    procedure ImpressionExecute(Sender: TObject);
    procedure ApercuExecute(Sender: TObject);
    function ImpressionUpdate: Boolean;
    function ApercuUpdate: Boolean;
    procedure LoadListe;
  public
    Liste: TSeriesIncompletes;
  end;

implementation

uses TypeRec, Commun, Impression, IniFiles, CommonConst;

{$R *.dfm}

type
  RNodeInfo = record
    Serie, AlbumsManquants: string;
  end;

procedure TfrmSeriesIncompletes.FormDestroy(Sender: TObject);
begin
  vstAlbumsManquants.Clear;
  Liste.Free;
end;

procedure TfrmSeriesIncompletes.FormCreate(Sender: TObject);
begin
  ChargeImage(vstAlbumsManquants.Background, 'FONDVT');
  vstAlbumsManquants.NodeDataSize := SizeOf(RNodeInfo);

  CheckBox1.OnClick := nil;
  CheckBox2.OnClick := nil;
  with TIniFile.Create(FichierIni) do try
    CheckBox1.Checked := ReadBool('Options', 'ManquantsIntegrales', True);
    CheckBox2.Checked := ReadBool('Options', 'ManquantsAchats', True);
  finally
    Free;
  end;
  CheckBox1.OnClick := CheckBox1Click;
  CheckBox2.OnClick := CheckBox1Click;

  Liste := TSeriesIncompletes.Create;
  LoadListe;
end;

procedure TfrmSeriesIncompletes.vstAlbumsManquantsInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  NodeInfo: ^RNodeInfo;
begin
  NodeInfo := Sender.GetNodeData(Node);
  if Assigned(NodeInfo) then
    with TSerieIncomplete(Liste.Series[Node.Index]) do begin
      NodeInfo.Serie := Serie.ChaineAffichage;
      NodeInfo.AlbumsManquants := ChaineAffichage;
    end;
end;

procedure TfrmSeriesIncompletes.vstAlbumsManquantsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var
  NodeInfo: ^RNodeInfo;
begin
  NodeInfo := Sender.GetNodeData(Node);
  if (TextType = ttNormal) and Assigned(NodeInfo) then
    case Column of
      0: CellText := NodeInfo.Serie;
      1: CellText := NodeInfo.AlbumsManquants;
    end;
end;

procedure TfrmSeriesIncompletes.ApercuExecute(Sender: TObject);
begin
  ListeApercu.Execute;
end;

function TfrmSeriesIncompletes.ApercuUpdate: Boolean;
begin
  Result := ListeApercu.Enabled;
end;

procedure TfrmSeriesIncompletes.ImpressionExecute(Sender: TObject);
begin
  ListeImprime.Execute;
end;

function TfrmSeriesIncompletes.ImpressionUpdate: Boolean;
begin
  Result := ListeImprime.Enabled;
end;

procedure TfrmSeriesIncompletes.ListeApercuExecute(Sender: TObject);
begin
  ImpressionListeManquants(Liste, TComponent(Sender).Tag = 1);
end;

procedure TfrmSeriesIncompletes.LoadListe;
begin
  vstAlbumsManquants.BeginUpdate;
  try
    Liste.Fill(CheckBox1.Checked, CheckBox2.Checked, -1);
    vstAlbumsManquants.RootNodeCount := Liste.Series.Count;
    vstAlbumsManquants.ReinitNode(vstAlbumsManquants.RootNode, True);
  finally
    vstAlbumsManquants.EndUpdate;
  end;
end;

procedure TfrmSeriesIncompletes.CheckBox1Click(Sender: TObject);
begin
  with TIniFile.Create(FichierIni) do try
    WriteBool('Options', 'ManquantsIntegrales', CheckBox1.Checked);
    WriteBool('Options', 'ManquantsAchats', CheckBox2.Checked);
  finally
    Free;
  end;
  LoadListe;
end;

end.

