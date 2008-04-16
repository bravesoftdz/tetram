unit Form_EditCritereTri;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Fram_Boutons, StdCtrls, DBCtrls, Form_Recherche,
  ActnList, DBEditLabeled, ComboCheck, ComCtrls, LoadComplet;

type
  TFrmEditCritereTri = class(TForm)
    champs: TLightComboCheck;
    Frame11: TFrame1;
    ActionList1: TActionList;
    ActOk: TAction;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ActOkExecute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure champsChange(Sender: TObject);
  private
    { Déclarations privées }
    FRecherche: TFrmRecherche;
    FChampValeurs: TStringList;
    FCritere: TCritereTri;
    procedure SetCritere(Value: TCritereTri);
    function GetCritere: TCritereTri;
  public
    { Déclarations publiques }
    property Critere: TCritereTri read GetCritere write SetCritere;
  end;

implementation

uses JvUIB, DM_Commun, Commun, DM_Princ, JvUIBLib, Divers,
  UChampsRecherche;

{$R *.DFM}

function TFrmEditCritereTri.GetCritere: TCritereTri;
var
  Champ: PChamp;
begin
  Result := FCritere;

  Champ := PChamp(champs.LastItemData);

  Result.iChamp := champs.Value;
  Result.Asc := RadioButton1.Checked;
  Result.NullsFirst := CheckBox1.Checked;
  Result.NullsLast := CheckBox2.Checked;
  Result.NomTable := Champ.NomTable;
  Result.Champ := Champ.NomChamp;
  Result.LabelChamp := champs.Caption;
  Result.Imprimer := Champ.ChampImpressionTri and CheckBox3.Checked;
end;

procedure TFrmEditCritereTri.SetCritere(Value: TCritereTri);
begin
  FCritere.Assign(Value);
  champs.Value := FCritere.iChamp;
  if FCritere.Asc then
    RadioButton1.Checked := True
  else
    RadioButton2.Checked := True;
  CheckBox1.Checked := FCritere.NullsFirst;
  CheckBox2.Checked := FCritere.NullsLast;
  CheckBox3.Checked := FCritere.Imprimer;
end;

procedure TFrmEditCritereTri.FormCreate(Sender: TObject);
var
  i, j: Integer;
  pt: TPoint;
  hg: IHourGlass;
  ParentItem: TSubItem;
begin
  hg := THourGlass.Create;
  FRecherche := TFrmRecherche(Owner);
  FChampValeurs := TStringList.Create;
  FCritere := TCritereTri.Create;
  pt := FRecherche.ClientToScreen(Point((FRecherche.Width - Width) div 2, (FRecherche.Height - Height) div 2));
  SetBounds(pt.x, pt.y, Width, Height);
  champs.Items.Clear;
  for j := Low(Groupes) to High(Groupes) do
  begin
    ParentItem := champs.Items.Add(Groupes[j]);
    for i := 1 to High(ChampsRecherche^) do
      if j = ChampsRecherche^[i].Groupe then
        with ParentItem.SubItems.Add(ChampsRecherche^[i].LibelleChamp) do
        begin
          Valeur := ChampsRecherche^[i].ID;
          Data := TObject(@ChampsRecherche^[i]);
        end;
  end;
end;

procedure TFrmEditCritereTri.FormDestroy(Sender: TObject);
begin
  FChampValeurs.Free;
  FCritere.Free;
end;

procedure TFrmEditCritereTri.ActOkExecute(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFrmEditCritereTri.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
begin
  ActOk.Enabled := (champs.Checked);
end;

procedure TFrmEditCritereTri.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then CheckBox2.Checked := False;
end;

procedure TFrmEditCritereTri.CheckBox2Click(Sender: TObject);
begin
  if CheckBox2.Checked then CheckBox1.Checked := False;
end;

procedure TFrmEditCritereTri.champsChange(Sender: TObject);
begin
  if PChamp(champs.LastItemData).Booleen then begin
    RadioButton1.Caption := 'Non puis Oui';
    RadioButton2.Caption := 'Oui puis Non';
  end else begin
    RadioButton1.Caption := 'Croissant';
    RadioButton2.Caption := 'Décroissant';
  end;
  CheckBox3.Enabled := PChamp(champs.LastItemData).ChampImpressionTri;
end;

end.

