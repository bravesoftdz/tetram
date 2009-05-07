unit UfrmConsultationEmprunteur;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Db, DBCtrls, StdCtrls, Menus, ComCtrls, ExtCtrls, ActnList,
  ToolWin, VirtualTrees, ProceduresBDtk, LoadComplet, UBdtForms, Generics.Defaults;

type
  TfrmConsultationEmprunteur = class(TBdtForm, IImpressionApercu, IFicheEditable)
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
    FicheModifier: TAction;
    Modifier1: TMenuItem;
    N1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btAjouterClick(Sender: TObject);
    procedure Imprimer1Click(Sender: TObject);
    //    procedure Impression(Sender: TObject);
    procedure Imprimer2Click(Sender: TObject);
    procedure ListeEmpruntsDblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ListeEmpruntsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure ListeEmpruntsGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
    procedure ListeEmpruntsHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure Retour1Execute(Sender: TObject);
    procedure FicheModifierExecute(Sender: TObject);
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
    procedure ModificationExecute(Sender: TObject);
    function ModificationUpdate: Boolean;
  public
    { Déclarations publiques }
    property Emprunteur: TEmprunteurComplet read FEmprunteur;
    property ID_Emprunteur: TGUID read GetID_Emprunteur write SetID_Emprunteur;
  end;

implementation

uses TypeRec, UfrmFond, MAJ, Impression, DateUtils, Math, UHistorique, Procedures,
  Proc_Gestions;

{$R *.DFM}

var
  FSortColumn: Integer;
  FSortDirection: TSortDirection;

procedure TfrmConsultationEmprunteur.FicheModifierExecute(Sender: TObject);
begin
  Historique.AddWaiting(fcGestionModif, @RefreshCallBack, nil, @ModifierEmprunteurs2, nil, FEmprunteur.ID);
end;

procedure TfrmConsultationEmprunteur.FormCreate(Sender: TObject);
begin
  FEmprunteur := TEmprunteurComplet.Create;
  PrepareLV(Self);
  ListeEmprunts.Header.Columns[0].Width := Trunc(ListeEmprunts.Header.Columns[0].Width * 1.5) + frmFond.ImageList1.Width + 4;
  FSortColumn := 0;
  FSortDirection := sdDescending;
  ListeEmprunts.Header.Columns[0].ImageIndex := 1;
end;

procedure TfrmConsultationEmprunteur.FormDestroy(Sender: TObject);
begin
  ClearForm;
  FEmprunteur.Free;
end;

procedure TfrmConsultationEmprunteur.btAjouterClick(Sender: TObject);
var
  a: TEditionsEmpruntees;
begin
  SetLength(a, 0);
  if SaisieMouvementEmprunteur(ID_Emprunteur, a) then Historique.Refresh;
end;

procedure TfrmConsultationEmprunteur.Imprimer1Click(Sender: TObject);
begin
  ImpressionEmpruntsEmprunteur(ID_Emprunteur, TComponent(Sender).Tag = 1);
end;

procedure TfrmConsultationEmprunteur.Imprimer2Click(Sender: TObject);
begin
  ImpressionFicheEmprunteur(ID_Emprunteur, TComponent(Sender).Tag = 1);
end;

procedure TfrmConsultationEmprunteur.ListeEmpruntsDblClick(Sender: TObject);
begin
  if Assigned(ListeEmprunts.FocusedNode) then Historique.AddWaiting(fcAlbum, TEmprunt(FEmprunteur.Emprunts.Emprunts[ListeEmprunts.FocusedNode.Index]).Album.ID);
end;

procedure TfrmConsultationEmprunteur.Button1Click(Sender: TObject);
begin
  if ActiveControl = ListeEmprunts then begin
    ListeEmpruntsDblClick(ListeEmprunts);
    Exit;
  end;
end;

procedure TfrmConsultationEmprunteur.ListeEmpruntsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
begin
  case Column of
    0: CellText := DateToStr(TEmprunt(FEmprunteur.Emprunts.Emprunts[Node.Index]).Date);
    1: CellText := TEmprunt(FEmprunteur.Emprunts.Emprunts[Node.Index]).Album.ChaineAffichage;
    2: CellText := TEmprunt(FEmprunteur.Emprunts.Emprunts[Node.Index]).Edition.ChaineAffichage;
  end;
end;

procedure TfrmConsultationEmprunteur.ListeEmpruntsGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
begin
  if Column = 0 then
    if TEmprunt(FEmprunteur.Emprunts.Emprunts[Node.Index]).Pret then
      ImageIndex := 3
    else
      ImageIndex := 2;
end;

type
  TEmpruntCompare = class(TComparer<TEmprunt>)
    function Compare(const Left, Right: TEmprunt): Integer; override;
  end;

  TEmpruntCompareDesc = class(TEmpruntCompare)
    function Compare(const Left, Right: TEmprunt): Integer; override;
  end;

function TEmpruntCompare.Compare(const Left, Right: TEmprunt): Integer;
begin
  case FSortColumn of
    0: Result := CompareDate(TEmprunt(Left).Date, TEmprunt(Right).Date);
    1: Result := CompareText(TEmprunt(Left).Album.ChaineAffichage, TEmprunt(Right).Album.ChaineAffichage);
    2: Result := CompareText(TEmprunt(Left).Edition.ChaineAffichage, TEmprunt(Right).Edition.ChaineAffichage);
    else
      Result := 0;
  end;
end;

function TEmpruntCompareDesc.Compare(const Left, Right: TEmprunt): Integer;
begin
  Result := -inherited;
end;

procedure TfrmConsultationEmprunteur.ListeEmpruntsHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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
  if FSortDirection = sdDescending then
    FEmprunteur.Emprunts.Emprunts.Sort(TEmpruntCompareDesc.Create)
  else
    FEmprunteur.Emprunts.Emprunts.Sort(TEmpruntCompare.Create);
  ListeEmprunts.Invalidate;
end;

procedure TfrmConsultationEmprunteur.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
begin
  Retour1.Enabled := Bool(ListeEmprunts.SelectedCount);
end;

procedure TfrmConsultationEmprunteur.Retour1Execute(Sender: TObject);
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

procedure TfrmConsultationEmprunteur.ApercuExecute(Sender: TObject);
begin
  Imprimer1Click(Sender);
end;

function TfrmConsultationEmprunteur.ApercuUpdate: Boolean;
begin
  Result := True;
end;

procedure TfrmConsultationEmprunteur.ImpressionExecute(Sender: TObject);
begin
  Imprimer1Click(Sender);
end;

function TfrmConsultationEmprunteur.ImpressionUpdate: Boolean;
begin
  Result := True;
end;

function TfrmConsultationEmprunteur.GetID_Emprunteur: TGUID;
begin
  Result := FEmprunteur.ID_Emprunteur;
end;

procedure TfrmConsultationEmprunteur.SetID_Emprunteur(const Value: TGUID);
begin
  ClearForm;
  FEmprunteur.Fill(Value);

  Caption := 'Fiche d''emprunteur - ' + FEmprunteur.ChaineAffichage;
  nom.Caption := FEmprunteur.Nom;
  Adresse.Lines.Assign(FEmprunteur.Adresse);

  ListeEmprunts.RootNodeCount := FEmprunteur.Emprunts.Emprunts.Count;
  Emprunts.Caption := IntToStr(FEmprunteur.Emprunts.NBEmprunts);
end;

procedure TfrmConsultationEmprunteur.ClearForm;
begin
  ListeEmprunts.Clear;
end;

procedure TfrmConsultationEmprunteur.ModificationExecute(Sender: TObject);
begin
  FicheModifierExecute(Sender);
end;

function TfrmConsultationEmprunteur.ModificationUpdate: Boolean;
begin
  Result := True;
end;

end.

