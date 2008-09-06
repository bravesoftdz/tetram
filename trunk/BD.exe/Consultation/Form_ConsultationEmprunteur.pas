unit Form_ConsultationEmprunteur;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Db, DBCtrls, StdCtrls, Menus, ComCtrls, ExtCtrls, ActnList,
  ToolWin, VirtualTrees, ProceduresBDtk, LoadComplet, UBdtForms;

type
  TFrmConsultationEmprunteur = class(TBdtForm, IImpressionApercu)
    ActionList1: TActionList;
    FicheImprime: TAction;
    FicheApercu: TAction;
    EmpruntApercu: TAction;
    EmpruntImprime: TAction;
    l_emprunts: TLabel;
    emprunts: TLabel;
    Bevel4: TBevel;
    Adresse: TMemo;
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
    FEmprunteur: TEmprunteurComplet;
    { Déclarations privées }
    procedure ImpressionExecute(Sender: TObject);
    procedure ApercuExecute(Sender: TObject);
    function ImpressionUpdate: Boolean;
    function ApercuUpdate: Boolean;
    function GetID_Emprunteur: TGUID;
    procedure SetID_Emprunteur(const Value: TGUID);
    procedure ClearForm;
  public
    { Déclarations publiques }
    property Emprunteur: TEmprunteurComplet read FEmprunteur;
    property ID_Emprunteur: TGUID read GetID_Emprunteur write SetID_Emprunteur;
  end;

implementation

uses TypeRec, Main, MAJ, Impression, DateUtils, Math, UHistorique, Procedures;

{$R *.DFM}

var
  FSortColumn: Integer;
  FSortDirection: TSortDirection;

procedure TFrmConsultationEmprunteur.FormCreate(Sender: TObject);
begin
  FEmprunteur := TEmprunteurComplet.Create;
  PrepareLV(Self);
  ListeEmprunts.Header.Columns[0].Width := Trunc(ListeEmprunts.Header.Columns[0].Width * 1.5) + Fond.ImageList1.Width + 4;
  FSortColumn := 0;
  FSortDirection := sdDescending;
  ListeEmprunts.Header.Columns[0].ImageIndex := 1;
end;

procedure TFrmConsultationEmprunteur.FormDestroy(Sender: TObject);
begin
  ClearForm;
  FEmprunteur.Free;
end;

procedure TFrmConsultationEmprunteur.btAjouterClick(Sender: TObject);
var
  a: TEditionsEmpruntees;
begin
  SetLength(a, 0);
  if SaisieMouvementEmprunteur(ID_Emprunteur, a) then Historique.Refresh;
end;

procedure TFrmConsultationEmprunteur.Imprimer1Click(Sender: TObject);
begin
  ImpressionEmpruntsEmprunteur(ID_Emprunteur, TComponent(Sender).Tag = 1);
end;

procedure TFrmConsultationEmprunteur.Imprimer2Click(Sender: TObject);
begin
  ImpressionFicheEmprunteur(ID_Emprunteur, TComponent(Sender).Tag = 1);
end;

procedure TFrmConsultationEmprunteur.ListeEmpruntsDblClick(Sender: TObject);
begin
  if Assigned(ListeEmprunts.FocusedNode) then Historique.AddWaiting(fcAlbum, TEmprunt(FEmprunteur.Emprunts.Emprunts[ListeEmprunts.FocusedNode.Index]).Album.ID);
end;

procedure TFrmConsultationEmprunteur.Button1Click(Sender: TObject);
begin
  if ActiveControl = ListeEmprunts then begin
    ListeEmpruntsDblClick(ListeEmprunts);
    Exit;
  end;
end;

procedure TFrmConsultationEmprunteur.ListeEmpruntsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
begin
  case Column of
    0: CellText := DateToStr(TEmprunt(FEmprunteur.Emprunts.Emprunts[Node.Index]).Date);
    1: CellText := TEmprunt(FEmprunteur.Emprunts.Emprunts[Node.Index]).Album.ChaineAffichage;
    2: CellText := TEmprunt(FEmprunteur.Emprunts.Emprunts[Node.Index]).Edition.ChaineAffichage;
  end;
end;

procedure TFrmConsultationEmprunteur.ListeEmpruntsGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
begin
  if Column = 0 then
    if TEmprunt(FEmprunteur.Emprunts.Emprunts[Node.Index]).Pret then
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

procedure TFrmConsultationEmprunteur.ListeEmpruntsHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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
  FEmprunteur.Emprunts.Emprunts.Sort(@ListeEmpruntsCompare);
  ListeEmprunts.Invalidate;
end;

procedure TFrmConsultationEmprunteur.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
begin
  Retour1.Enabled := Bool(ListeEmprunts.SelectedCount);
end;

procedure TFrmConsultationEmprunteur.Retour1Execute(Sender: TObject);
var
  i: Integer;
  a: TEditionsEmpruntees;
  Node: PVirtualNode;
begin
  SetLength(a, ListeEmprunts.SelectedCount);
  i := 0;
  Node := ListeEmprunts.GetFirstSelected;
  while Assigned(Node) do begin
    a[i][0] := TEmprunt(FEmprunteur.Emprunts.Emprunts[Node.Index]).Album.ID;
    a[i][1] := TEmprunt(FEmprunteur.Emprunts.Emprunts[Node.Index]).Edition.ID;
    Inc(i);
    Node := ListeEmprunts.GetNextSelected(Node);
  end;
  if SaisieMouvementEmprunteur(ID_Emprunteur, a) then Historique.Refresh;
end;

procedure TFrmConsultationEmprunteur.ApercuExecute(Sender: TObject);
begin
  Imprimer1Click(Sender);
end;

function TFrmConsultationEmprunteur.ApercuUpdate: Boolean;
begin
  Result := True;
end;

procedure TFrmConsultationEmprunteur.ImpressionExecute(Sender: TObject);
begin
  Imprimer1Click(Sender);
end;

function TFrmConsultationEmprunteur.ImpressionUpdate: Boolean;
begin
  Result := True;
end;

function TFrmConsultationEmprunteur.GetID_Emprunteur: TGUID;
begin
  Result := FEmprunteur.ID_Emprunteur;
end;

procedure TFrmConsultationEmprunteur.SetID_Emprunteur(const Value: TGUID);
begin
  ClearForm;
  FEmprunteur.Fill(Value);

  Caption := 'Fiche d''emprunteur - ' + FEmprunteur.ChaineAffichage;
  nom.Caption := FEmprunteur.Nom;
  Adresse.Text := FEmprunteur.Adresse.Text;

  ListeEmprunts.RootNodeCount := FEmprunteur.Emprunts.Emprunts.Count;
  Emprunts.Caption := IntToStr(FEmprunteur.Emprunts.NBEmprunts);
end;

procedure TFrmConsultationEmprunteur.ClearForm;
begin
  ListeEmprunts.Clear;
end;

end.

