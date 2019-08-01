unit UfrmSeriesIncompletes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, BDTK.Entities.Stats, VirtualTrees, BD.GUI.Controls.VirtualTree, ToolWin,
  BDTK.GUI.Utils, StdCtrls, ExtCtrls, Menus, ActnList, BD.GUI.Forms, System.Actions;

type
  TfrmSeriesIncompletes = class(TBdtForm, IImpressionApercu)
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
    procedure vstAlbumsManquantsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure vstAlbumsManquantsInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure ListeApercuExecute(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure vstAlbumsManquantsFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
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

uses BD.Entities.Lite, BD.Common, Impression, IniFiles, BD.Utils.StrUtils, BD.Utils.GUIUtils,
  BDTK.Entities.Dao.Full;

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
var
  ini: TIniFile;
begin
  ChargeImage(vstAlbumsManquants.Background, 'FONDVT');
  vstAlbumsManquants.NodeDataSize := SizeOf(RNodeInfo);

  CheckBox1.OnClick := nil;
  CheckBox2.OnClick := nil;
  ini := TIniFile.Create(FichierIni);
  try
    CheckBox1.Checked := ini.ReadBool('Options', 'ManquantsIntegrales', True);
    CheckBox2.Checked := ini.ReadBool('Options', 'ManquantsAchats', True);
  finally
    ini.Free;
  end;
  CheckBox1.OnClick := CheckBox1Click;
  CheckBox2.OnClick := CheckBox1Click;

  Liste := TSeriesIncompletes.Create(GUID_NULL);
  LoadListe;
end;

procedure TfrmSeriesIncompletes.vstAlbumsManquantsInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  NodeInfo: ^RNodeInfo;
  SerieIncomplete: TSerieIncomplete;
begin
  NodeInfo := Sender.GetNodeData(Node);
  if Assigned(NodeInfo) then
  begin
    Initialize(NodeInfo^);
    SerieIncomplete := Liste.Series[Node.Index];
    NodeInfo.Serie := SerieIncomplete.Serie.ChaineAffichage(False);
    NodeInfo.AlbumsManquants := SerieIncomplete.ChaineAffichage;
  end;
end;

procedure TfrmSeriesIncompletes.vstAlbumsManquantsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
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
    Liste.Fill(CheckBox1.Checked, CheckBox2.Checked, GUID_NULL);
    vstAlbumsManquants.RootNodeCount := Liste.Series.Count;
    vstAlbumsManquants.ReinitNode(vstAlbumsManquants.RootNode, True);
  finally
    vstAlbumsManquants.EndUpdate;
  end;
end;

procedure TfrmSeriesIncompletes.CheckBox1Click(Sender: TObject);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(FichierIni);
  try
    ini.WriteBool('Options', 'ManquantsIntegrales', CheckBox1.Checked);
    ini.WriteBool('Options', 'ManquantsAchats', CheckBox2.Checked);
  finally
    ini.Free;
  end;
  LoadListe;
end;

procedure TfrmSeriesIncompletes.vstAlbumsManquantsFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  NodeInfo: ^RNodeInfo;
begin
  NodeInfo := Sender.GetNodeData(Node);
  Finalize(NodeInfo^);
end;

end.

