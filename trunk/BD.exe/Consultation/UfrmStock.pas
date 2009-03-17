unit UfrmStock;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Db, StdCtrls, DBCtrls, Menus, ExtCtrls, ComCtrls, Commun,
  VDTButton, VirtualTrees, ActnList, ComboCheck, DBEditLabeled, ProceduresBDtk, ToolWin, UBdtForms;

type
  TfrmStock = class(TBdtForm, IImpressionApercu)
    PopupMenu1: TPopupMenu;
    Item2: TMenuItem;
    Item1: TMenuItem;
    N2: TMenuItem;
    MnuRetour: TMenuItem;
    Image1: TImage;
    Button1: TButton;
    ActionList1: TActionList;
    Retour1: TAction;
    ListeEmprunts: TVirtualStringTree;
    LightComboCheck1: TLightComboCheck;
    LightComboCheck2: TLightComboCheck;
    EditLabeled1: TEditLabeled;
    Button2: TButton;
    actFiltrer: TAction;
    Bevel1: TBevel;
    Retour2: TAction;
    MainMenu1: TMainMenu;
    Emprunts1: TMenuItem;
    Aperuavantimpression1: TMenuItem;
    Imprimer1: TMenuItem;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Item2Click(Sender: TObject);
    procedure ListeEmpruntsGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
    procedure ListeEmpruntsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure ListeEmpruntsHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ListeEmpruntsDblClick(Sender: TObject);
    procedure ListeEmpruntsGetPopupMenu(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; const P: TPoint; var AskParent: Boolean; var PopupMenu: TPopupMenu);
    procedure Retour1Execute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure LightComboCheck1Change(Sender: TObject);
    procedure actFiltrerExecute(Sender: TObject);
    procedure Imprimer1Click(Sender: TObject);
    procedure Retour2Execute(Sender: TObject);
  private
    { Déclarations privées }
    FListEmprunts: TList;
    DateAvant, DateApres: TDateTime;
    function ZoneMove: Integer;
    function SameEmprunteur: Boolean;
    procedure ClearForm;

    // Interface IImpressionAppercu
    procedure ImpressionExecute(Sender: TObject);
    procedure ApercuExecute(Sender: TObject);
    function ImpressionUpdate: Boolean;
    function ApercuUpdate: Boolean;
    procedure PrepareFiltre(var DateAvant, DateApres: TDateTime);
    procedure OpenSaisie(ZoneMove: Integer);
  public
    { Déclarations publiques }
    procedure LoadEmprunts;
  end;

implementation

uses UfrmFond, TypeRec, MAJ, DateUtils, Math, UHistorique, Procedures,
  LoadComplet, Impression;

{$R *.DFM}

var
  FSortColumn: Integer;
  FSortDirection: TSortDirection;

procedure TfrmStock.FormDestroy(Sender: TObject);
begin
  ClearForm;
end;

procedure TfrmStock.FormCreate(Sender: TObject);
begin
  ChargeImage(Image1, 'Stock');
  FListEmprunts := TList.Create;
  LightComboCheck1.Value := 0;
  LightComboCheck2.Value := 0;
  DateAvant := -1;
  DateApres := -1;
  PrepareLV(Self);
  ListeEmprunts.Header.Columns[0].Width := Trunc(ListeEmprunts.Header.Columns[0].Width * 1.5) + frmFond.ImageList1.Width + 4;
  ListeEmprunts.Header.Columns[1].Width := 150;
  FSortColumn := 0;
  FSortDirection := sdDescending;
  ListeEmprunts.Header.Columns[0].ImageIndex := 1;
end;

procedure TfrmStock.PopupMenu1Popup(Sender: TObject);
begin
  Item1.Caption := TEmprunt(FListEmprunts[ListeEmprunts.FocusedNode.Index]).Album.ChaineAffichage(True);
  Item2.Caption := TEmprunt(FListEmprunts[ListeEmprunts.FocusedNode.Index]).Emprunteur.ChaineAffichage;
  MnuRetour.Enabled := ((ListeEmprunts.SelectedCount = 1) and (ZoneMove in [0, 10])) or
    ((ListeEmprunts.SelectedCount >= 1) and (ZoneMove in [1, 11]) and SameEmprunteur);
end;

function TfrmStock.SameEmprunteur: Boolean;
var
  e: TGUID;
  Node: PVirtualNode;
begin
  Result := True;
  e := GUID_NULL;
  if ListeEmprunts.SelectedCount = 0 then Exit;
  Node := ListeEmprunts.GetFirstSelected;
  while Assigned(Node) do begin
    if IsEqualGUID(e, GUID_NULL) then
      e := TEmprunt(FListEmprunts[Node.Index]).Emprunteur.ID
    else if not IsEqualGUID(e, TEmprunt(FListEmprunts[Node.Index]).Emprunteur.ID) then begin
      Result := False;
      Exit;
    end;
    Node := ListeEmprunts.GetNextSelected(Node);
  end;
end;

procedure TfrmStock.Item2Click(Sender: TObject);
begin
  if Assigned(ListeEmprunts.FocusedNode) then begin
    if Sender = Item1 then Historique.AddWaiting(fcAlbum, TEmprunt(FListEmprunts[ListeEmprunts.FocusedNode.Index]).Album.ID);
    if Sender = Item2 then Historique.AddWaiting(fcEmprunteur, TEmprunt(FListEmprunts[ListeEmprunts.FocusedNode.Index]).Emprunteur.ID);
  end;
end;

procedure TfrmStock.ListeEmpruntsGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
begin
  if Column = 0 then
    if TEmprunt(FListEmprunts[Node.Index]).Pret then
      ImageIndex := 3
    else
      ImageIndex := 2;
end;

procedure TfrmStock.ListeEmpruntsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
begin
  case Column of
    0: CellText := DateToStr(TEmprunt(FListEmprunts[Node.Index]).Date);
    1: CellText := TEmprunt(FListEmprunts[Node.Index]).Emprunteur.ChaineAffichage;
    2: CellText := TEmprunt(FListEmprunts[Node.Index]).Album.ChaineAffichage;
    3: CellText := TEmprunt(FListEmprunts[Node.Index]).Edition.ChaineAffichage;
  end;
end;

function ListeEmpruntsCompare(Item1, Item2: Pointer): Integer;
begin
  case FSortColumn of
    0: Result := CompareDate(TEmprunt(Item1).Date, TEmprunt(Item2).Date);
    1: Result := CompareText(TEmprunt(Item1).Emprunteur.Nom, TEmprunt(Item2).Emprunteur.Nom);
    2: Result := CompareText(TEmprunt(Item1).Album.ChaineAffichage, TEmprunt(Item2).Album.ChaineAffichage);
    3: Result := CompareText(TEmprunt(Item1).Edition.ChaineAffichage, TEmprunt(Item2).Edition.ChaineAffichage);
    else
      Result := 0;
  end;
  if FSortDirection = sdDescending then Result := -Result;
end;

procedure TfrmStock.ListeEmpruntsHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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

procedure TfrmStock.ListeEmpruntsDblClick(Sender: TObject);
begin
  if Assigned(ListeEmprunts.FocusedNode) then
    case ZoneMove of
      1: Historique.AddWaiting(fcEmprunteur, TEmprunt(FListEmprunts[ListeEmprunts.FocusedNode.Index]).Emprunteur.ID);
      0: Historique.AddWaiting(fcAlbum, TEmprunt(FListEmprunts[ListeEmprunts.FocusedNode.Index]).Album.ID);
    end;
end;

procedure TfrmStock.ListeEmpruntsGetPopupMenu(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; const P: TPoint; var AskParent: Boolean; var PopupMenu: TPopupMenu);
begin
  if Sender.GetFirstSelected <> nil then
    PopupMenu := PopupMenu1
  else
    PopupMenu := nil;
end;

procedure TfrmStock.Retour1Execute(Sender: TObject);
begin
  OpenSaisie(ZoneMove);
end;

procedure TfrmStock.OpenSaisie(ZoneMove: Integer);
var
  i: Integer;
  a: TEditionsEmpruntees;
  Node: PVirtualNode;
  PE: TEmprunt;
begin
  case ZoneMove of
    0: begin
        PE := FListEmprunts[ListeEmprunts.GetFirstSelected.Index];
        if SaisieMouvementAlbum(PE.Album.ID, PE.Edition.ID, False, GUIDToString(PE.Emprunteur.ID)) then Historique.Refresh;
      end;
    1: begin
        SetLength(a, ListeEmprunts.SelectedCount);
        i := 0;
        Node := ListeEmprunts.GetFirstSelected;
        while Assigned(Node) do begin
          a[i][0] := TEmprunt(FListEmprunts[Node.Index]).Album.ID;
          a[i][1] := TEmprunt(FListEmprunts[Node.Index]).Edition.ID;
          Inc(i);
          Node := ListeEmprunts.GetNextSelected(Node);
        end;
        if SaisieMouvementEmprunteur(TEmprunt(FListEmprunts[ListeEmprunts.GetFirstSelected.Index]).Emprunteur.ID, a) then Historique.Refresh;
      end;
  end;
end;

procedure TfrmStock.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
var
  isSameEmprunteur: Boolean;
begin
  isSameEmprunteur := SameEmprunteur;
  Retour1.Enabled := (ListeEmprunts.GetFirstSelected <> nil) and ((ZoneMove <> 1) or isSameEmprunteur);
  Retour2.Enabled := Retour1.Enabled and isSameEmprunteur;
  actFiltrer.Visible := LightComboCheck1.ValidCurrentValue;
  actFiltrer.Enabled := LightComboCheck1.ValidCurrentValue and (EditLabeled1.Text <> '');
end;

procedure TfrmStock.LightComboCheck1Change(Sender: TObject);
begin
  EditLabeled1.Visible := LightComboCheck1.ValidCurrentValue;
  LightComboCheck2.Visible := EditLabeled1.Visible;
  if LightComboCheck1.Value = LightComboCheck1.ValueMissing then LoadEmprunts;
end;

procedure TfrmStock.actFiltrerExecute(Sender: TObject);
begin
  LoadEmprunts;
end;

procedure TfrmStock.ClearForm;
begin
  ListeEmprunts.Clear;
  TEmprunt.VideListe(FListEmprunts);
end;

procedure TfrmStock.PrepareFiltre(var DateAvant, DateApres: TDateTime);

  procedure AjusteDate(var DateFiltre: TDateTime);
  begin
    case LightComboCheck2.Value of
      0: DateFiltre := IncDay(Trunc(Now), -StrToIntDef(EditLabeled1.Text, 0)); // Jours
      1: DateFiltre := IncWeek(Trunc(Now), -StrToIntDef(EditLabeled1.Text, 0)); // Semaine
      2: DateFiltre := IncMonth(Trunc(Now), -StrToIntDef(EditLabeled1.Text, 0)); // Mois
      3: DateFiltre := IncYear(Trunc(Now), -StrToIntDef(EditLabeled1.Text, 0)); // Ans
    end;
  end;

begin
  DateAvant := -1;
  DateApres := -1;
  case LightComboCheck1.Value of
    1: AjusteDate(DateApres); // Depuis plus de...
    2: AjusteDate(DateAvant); // Depuis moins de...
  end;
end;

procedure TfrmStock.LoadEmprunts;
var
  PE: TEmprunt;
  i: Integer;
  R: TEmpruntsComplet;
begin
  ClearForm;
  PrepareFiltre(DateAvant, DateApres);
  R := TEmpruntsComplet.Create(GUID_NULL, seTous, ssPret, DateAvant, DateApres, True, True);
  try
    for i := 0 to R.Emprunts.Count - 1 do begin
      PE := R.Emprunts[i];
      if not IsEqualGUID(PE.Album.ID, GUID_NULL) and not IsEqualGUID(PE.Edition.ID, GUID_NULL) and not IsEqualGUID(PE.Emprunteur.ID, GUID_NULL) then
        FListEmprunts.Add(TEmprunt.Duplicate(PE));
    end;
    ListeEmprunts.RootNodeCount := FListEmprunts.Count;
    // Caption := Format('%d Emprunts', [R.NBEmprunts]);
  finally
    R.Free;
  end;
end;

procedure TfrmStock.ApercuExecute(Sender: TObject);
begin
  Imprimer1Click(Sender);
end;

function TfrmStock.ApercuUpdate: Boolean;
begin
  Result := True;
end;

procedure TfrmStock.ImpressionExecute(Sender: TObject);
begin
  Imprimer1Click(Sender);
end;

function TfrmStock.ImpressionUpdate: Boolean;
begin
  Result := True;
end;

procedure TfrmStock.Imprimer1Click(Sender: TObject);
begin
  ImpressionEmprunts(TAction(Sender).Tag = 1, seTous, ssPret, DateAvant, DateApres, True, True);
end;

procedure TfrmStock.Retour2Execute(Sender: TObject);
begin
  OpenSaisie(1);
end;

function TfrmStock.ZoneMove: Integer;
begin
  case ListeEmprunts.Header.Columns.ColumnFromPosition(ListeEmprunts.ScreenToClient(Mouse.CursorPos)) of
    1: ZoneMove := 1;
    2, 3: ZoneMove := 0;
    else
      ZoneMove := -1;
  end;
end;

end.
