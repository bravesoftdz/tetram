unit Form_PrevisionsSorties;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, LoadComplet, VirtualTrees, VirtualTree, ToolWin,
  Procedures, StdCtrls, ExtCtrls, Menus, ActnList;

type
  TfrmPrevisionsSorties = class(TForm, IImpressionApercu)
    vstPrevisionsSorties: TVirtualStringTree;
    ActionList1: TActionList;
    ListeApercu: TAction;
    ListeImprime: TAction;
    Panel1: TPanel;
    CheckBox1: TCheckBox;
    MainMenu1: TMainMenu;
    Liste1: TMenuItem;
    Aperuavantimpression1: TMenuItem;
    Imprimer1: TMenuItem;
    procedure vstPrevisionsSortiesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure vstPrevisionsSortiesInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure ListeApercuExecute(Sender: TObject);
    procedure vstPrevisionsSortiesAfterItemPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
    procedure vstPrevisionsSortiesResize(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    procedure ImpressionExecute(Sender: TObject);
    procedure ApercuExecute(Sender: TObject);
    function ImpressionUpdate: Boolean;
    function ApercuUpdate: Boolean;
    procedure LoadListe;
  public
    Liste: TPrevisionsSorties;
  end;

implementation

uses Impression, DateUtils, IniFiles, CommonConst;

{$R *.dfm}

type
  RNodeInfo = record
    Annee: Integer;
    Serie, PrevisionSortie: string;
  end;

procedure TfrmPrevisionsSorties.FormDestroy(Sender: TObject);
begin
  vstPrevisionsSorties.Clear;
  Liste.Free;
end;

procedure TfrmPrevisionsSorties.FormCreate(Sender: TObject);
begin
  ChargeImage(vstPrevisionsSorties.Background, 'FONDVT');
  vstPrevisionsSorties.NodeDataSize := SizeOf(RNodeInfo);

  CheckBox1.OnClick := nil;
  with TIniFile.Create(FichierIni) do try
    CheckBox1.Checked := ReadBool('Options', 'PrevisionsAchats', True);
  finally
    Free;
  end;
  CheckBox1.OnClick := CheckBox1Click;

  Liste := TPrevisionsSorties.Create;
  LoadListe;
end;

procedure TfrmPrevisionsSorties.vstPrevisionsSortiesInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  NodeInfo: ^RNodeInfo;
  PS: TPrevisionSortie;
begin
  NodeInfo := Sender.GetNodeData(Node);
  if Assigned(NodeInfo) then begin
    if Node.Index in [Liste.AnneesPassees.Count, Liste.AnneesPassees.Count + Liste.AnneeEnCours.Count + 1] then begin
      NodeInfo.Serie := '-'; // sÚparateur
    end
    else begin
      if Node.Index < Cardinal(Liste.AnneesPassees.Count) then
        PS := TPrevisionSortie(Liste.AnneesPassees[Node.Index])
      else if Node.Index < Cardinal(Liste.AnneesPassees.Count + Liste.AnneeEnCours.Count) + 1 then
        PS := TPrevisionSortie(Liste.AnneeEnCours[Node.Index - Cardinal(Liste.AnneesPassees.Count) - 1])
      else
        PS := TPrevisionSortie(Liste.AnneesProchaines[Node.Index - Cardinal(Liste.AnneesPassees.Count + Liste.AnneeEnCours.Count) - 2]);

      with PS do begin
        NodeInfo.Serie := Serie.ChaineAffichage;
        NodeInfo.Annee := Annee;
        NodeInfo.PrevisionSortie := Format('Tome %d - %s', [Tome, sAnnee]);
      end;
    end;
  end;
end;

procedure TfrmPrevisionsSorties.vstPrevisionsSortiesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var
  NodeInfo: ^RNodeInfo;
begin
  NodeInfo := Sender.GetNodeData(Node);
  if (TextType = ttNormal) and Assigned(NodeInfo) and (NodeInfo.Serie <> '-') then
    case Column of
      0: CellText := NodeInfo.Serie;
      1: CellText := NodeInfo.PrevisionSortie;
    end;
end;

procedure TfrmPrevisionsSorties.ApercuExecute(Sender: TObject);
begin
  ListeApercu.Execute;
end;

function TfrmPrevisionsSorties.ApercuUpdate: Boolean;
begin
  Result := ListeApercu.Enabled;
end;

procedure TfrmPrevisionsSorties.ImpressionExecute(Sender: TObject);
begin
  ListeImprime.Execute;
end;

function TfrmPrevisionsSorties.ImpressionUpdate: Boolean;
begin
  Result := ListeImprime.Enabled;
end;

procedure TfrmPrevisionsSorties.ListeApercuExecute(Sender: TObject);
begin
  ImpressionListePrevisions(Liste, TComponent(Sender).Tag = 1);
end;

procedure ChangeLight(Value: Integer; Canvas: TCanvas; R: TRect; Seuil: TColor = clWhite);

  function Min(a, b: integer): integer;
  begin
    if a < b then
      result := a
    else
      result := b;
  end;

  function Max(a, b: integer): integer;
  begin
    if a > b then
      result := a
    else
      result := b;
  end;

var
  i, j: Integer;
  c: TColor;
  rc, gc, bc,
    rp, gp, bp: Integer;
begin
  rc := GetRValue(Seuil);
  gc := GetGValue(Seuil);
  bc := GetBValue(Seuil);
  if Value <> 0 then
    for i := R.Left to R.Right - 1 do begin
      for j := R.Top to R.Bottom - 1 do begin
        c := Canvas.Pixels[i, j];

        rp := GetRValue(c);
        rp := rp + ((rc - rp) * Value div 100);
        gp := GetGValue(c);
        gp := gp + ((gc - gp) * Value div 100);
        bp := GetBValue(c);
        bp := bp + ((bc - bp) * Value div 100);

        c := RGB(Max(0, Min(255, rp)),
          Max(0, Min(255, gp)),
          Max(0, Min(255, bp)));
        Canvas.Pixels[i, j] := c;
      end;
    end;
end;

procedure TfrmPrevisionsSorties.vstPrevisionsSortiesAfterItemPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
var
  NodeInfo: ^RNodeInfo;
  i, w: Integer;
begin
  NodeInfo := Sender.GetNodeData(Node);
  if Assigned(NodeInfo) and (NodeInfo.Serie = '-') then begin
    w := Trunc(Width * 0.8);
    ItemRect.Left := 4;
    ItemRect.Top := ItemRect.Top + (Integer(vstPrevisionsSorties.DefaultNodeHeight) - 4) div 2;
    for i := 100 downto 1 do begin
      ChangeLight(i, TargetCanvas, Rect(ItemRect.Left + (100 - i) * (w div 100), ItemRect.Top + 2, ItemRect.Left + (101 - i) * (w div 100), ItemRect.Top + 6), clRed);
    end;
  end;
end;

procedure TfrmPrevisionsSorties.vstPrevisionsSortiesResize(Sender: TObject);
begin
  vstPrevisionsSorties.Invalidate;
end;

procedure TfrmPrevisionsSorties.LoadListe;
begin
  vstPrevisionsSorties.BeginUpdate;
  try
    Liste.Fill(CheckBox1.Checked);
    vstPrevisionsSorties.RootNodeCount := Liste.AnneesPassees.Count + Liste.AnneeEnCours.Count + Liste.AnneesProchaines.Count + 2;
    vstPrevisionsSorties.ReinitNode(vstPrevisionsSorties.RootNode, True);
  finally
    vstPrevisionsSorties.EndUpdate;
  end;
end;

procedure TfrmPrevisionsSorties.CheckBox1Click(Sender: TObject);
begin
  with TIniFile.Create(FichierIni) do try
    WriteBool('Options', 'PrevisionsAchats', CheckBox1.Checked);
  finally
    Free;
  end;
  LoadListe;
end;

end.

