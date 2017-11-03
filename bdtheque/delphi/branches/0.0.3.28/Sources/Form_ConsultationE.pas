unit Form_ConsultationE;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Db, DBCtrls, StdCtrls, Menus, ComCtrls, ExtCtrls, ActnList,
  ToolWin, VirtualTrees, Procedures;

type
  TFrmConsultationE = class(TForm, IImpressionApercu)
    ActionList1: TActionList;
    FicheImprime: TAction;
    FicheApercu: TAction;
    EmpruntApercu: TAction;
    EmpruntImprime: TAction;
    l_emprunts: TLabel;
    emprunts: TLabel;
    Bevel4: TBevel;
    adresse: TMemo;
    Bevel2: TBevel;
    btAjouter: TButton;
    ListeEmprunts: TVirtualStringTree;
    Label6: TLabel;
    nom: TLabel;
    Label1: TLabel;
    Button1: TButton;
    Retour1: TAction;
    MainMenu1: TMainMenu;
    Fiche1: TMenuItem;
    Emprunts1: TMenuItem;
    Aperuavantimpression1: TMenuItem;
    Aperuavantimpression2: TMenuItem;
    Aperuavantimpression3: TMenuItem;
    Aperuavantimpression4: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btAjouterClick(Sender: TObject);
    procedure Imprimer1Click(Sender: TObject);
    //    procedure Impression(Sender: TObject);
    procedure Imprimer2Click(Sender: TObject);
    procedure ListeEmpruntsDblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ListeEmpruntsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure ListeEmpruntsGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
    procedure ListeEmpruntsHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure Retour1Execute(Sender: TObject);
  private
    { Déclarations privées }
    procedure ImpressionExecute(Sender: TObject);
    procedure ApercuExecute(Sender: TObject);
    function ImpressionUpdate: Boolean;
    function ApercuUpdate: Boolean;
  public
    { Déclarations publiques }
    FListEmprunts: TList;
    RefEmprunteur: Integer;
  end;

implementation

uses TypeRec, Main, MAJ, Impression, DateUtils, Math, UHistorique;

{$R *.DFM}

var
  FSortColumn: Integer;
  FSortDirection: TSortDirection;

procedure TFrmConsultationE.FormCreate(Sender: TObject);
begin
  FListEmprunts := TList.Create;
  PrepareLV(Self);
  ListeEmprunts.Header.Columns[0].Width := Trunc(ListeEmprunts.Header.Columns[0].Width * 1.5) + Fond.ImageList1.Width + 4;
  FSortColumn := 0;
  FSortDirection := sdDescending;
  ListeEmprunts.Header.Columns[0].ImageIndex := 1;
end;

procedure TFrmConsultationE.FormDestroy(Sender: TObject);
begin
  ListeEmprunts.Clear;
  TEmprunt.VideListe(FListEmprunts);
end;

procedure TFrmConsultationE.btAjouterClick(Sender: TObject);
var
  a: TEditionsEmpruntees;
begin
  SetLength(a, 0);
  if SaisieMouvementEmprunteur(RefEmprunteur, a) then Historique.Refresh;
end;

procedure TFrmConsultationE.Imprimer1Click(Sender: TObject);
begin
  ImpressionEmpruntsEmprunteur(RefEmprunteur, TComponent(Sender).Tag = 1);
end;

procedure TFrmConsultationE.Imprimer2Click(Sender: TObject);
begin
  ImpressionFicheEmprunteur(RefEmprunteur, TComponent(Sender).Tag = 1);
end;

procedure TFrmConsultationE.ListeEmpruntsDblClick(Sender: TObject);
begin
  if Assigned(ListeEmprunts.FocusedNode) then Historique.AddWaiting(fcAlbum, TEmprunt(FListEmprunts[ListeEmprunts.FocusedNode.Index]).Album.Reference);
end;

procedure TFrmConsultationE.Button1Click(Sender: TObject);
begin
  if ActiveControl = ListeEmprunts then begin
    ListeEmpruntsDblClick(ListeEmprunts);
    Exit;
  end;
end;

procedure TFrmConsultationE.ListeEmpruntsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
begin
  case Column of
    0: CellText := DateToStr(TEmprunt(FListEmprunts[Node.Index]).Date);
    1: CellText := TEmprunt(FListEmprunts[Node.Index]).Album.ChaineAffichage;
    2: CellText := TEmprunt(FListEmprunts[Node.Index]).Edition.ChaineAffichage;
  end;
end;

procedure TFrmConsultationE.ListeEmpruntsGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
begin
  if Column = 0 then
    if TEmprunt(FListEmprunts[Node.Index]).Pret then
      ImageIndex := 3
    else
      ImageIndex := 2;
end;

function ListeEmpruntsCompare(Item1, Item2: Pointer): Integer;
begin
  case FSortColumn of
    0: Result := CompareDate(TEmprunt(Item1).Date, TEmprunt(Item2).Date);
    1: Result := CompareText(TEmprunt(Item1).Album.ChaineAffichage, TEmprunt(Item2).Album.ChaineAffichage);
    2: Result := CompareText(TEmprunt(Item1).Edition.ChaineAffichage, TEmprunt(Item2).Edition.ChaineAffichage);
    else
      Result := 0;
  end;
  if FSortDirection = sdDescending then Result := -Result;
end;

procedure TFrmConsultationE.ListeEmpruntsHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Column <> FSortColumn then
    if Column = 0 then
      FSortDirection := sdDescending
    else
      FSortDirection := sdAscending
  else begin
    if FSortDirection = sdAscending then
      FSortDirection := sdDescending
    else
      FSortDirection := sdAscending;
  end;
  if FSortColumn <> -1 then ListeEmprunts.Header.Columns[FSortColumn].ImageIndex := -1;
  FSortColumn := Column;
  if FSortDirection = sdAscending then
    ListeEmprunts.Header.Columns[FSortColumn].ImageIndex := 0
  else
    ListeEmprunts.Header.Columns[FSortColumn].ImageIndex := 1;
  FListEmprunts.Sort(@ListeEmpruntsCompare);
  ListeEmprunts.Invalidate;
end;

procedure TFrmConsultationE.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
begin
  Retour1.Enabled := Bool(ListeEmprunts.SelectedCount);
end;

procedure TFrmConsultationE.Retour1Execute(Sender: TObject);
var
  i: Integer;
  a: TEditionsEmpruntees;
  Node: PVirtualNode;
begin
  SetLength(a, ListeEmprunts.SelectedCount);
  i := 0;
  Node := ListeEmprunts.GetFirstSelected;
  while Assigned(Node) do begin
    a[i][0] := TEmprunt(FListEmprunts[Node.Index]).Album.Reference;
    a[i][1] := TEmprunt(FListEmprunts[Node.Index]).Edition.Reference;
    Inc(i);
    Node := ListeEmprunts.GetNextSelected(Node);
  end;
  if SaisieMouvementEmprunteur(RefEmprunteur, a) then Historique.Refresh;
end;

procedure TFrmConsultationE.ApercuExecute(Sender: TObject);
begin
  Imprimer1Click(Sender);
end;

function TFrmConsultationE.ApercuUpdate: Boolean;
begin
  Result := True;
end;

procedure TFrmConsultationE.ImpressionExecute(Sender: TObject);
begin
  Imprimer1Click(Sender);
end;

function TFrmConsultationE.ImpressionUpdate: Boolean;
begin
  Result := True;
end;

end.

