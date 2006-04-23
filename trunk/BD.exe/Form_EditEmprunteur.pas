unit Form_EditEmprunteur;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, DBCtrls, Mask, Menus, ExtCtrls,
  DBEditLabeled, DB, Buttons, Fram_Boutons, LoadComplet;

type
  TFrmEditEmprunteur = class(TForm)
    ScrollBox1: TScrollBox;
    emprunts: TLabel;
    Label2: TLabel;
    coord: TMemo;
    edNom: TEditLabeled;
    Label3: TLabel;
    Bevel1: TBevel;
    Frame11: TFrame1;
    procedure Frame11btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
    FEmprunteur: TEmprunteurComplet;
    procedure SetID_Emprunteur(const Value: TGUID);
    function GetID_Emprunteur: TGUID;
  public
    { Déclarations publiques }
    property ID_Emprunteur: TGUID read GetID_Emprunteur write SetID_Emprunteur;
  end;

implementation

uses Commun, JvUIB, DM_Princ, Procedures, Textes;

{$R *.DFM}

procedure TFrmEditEmprunteur.SetID_Emprunteur(const Value: TGUID);
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;

  FEmprunteur.Fill(Value);

  edNom.Text := FEmprunteur.Nom;
  Coord.Lines.Assign(FEmprunteur.Adresse);
  emprunts.Caption := IntToStr(FEmprunteur.Emprunts.NBEmprunts);
end;

procedure TFrmEditEmprunteur.Frame11btnOKClick(Sender: TObject);
begin
  if Length(Trim(edNom.Text)) = 0 then begin
    AffMessage(rsNomObligatoire, mtInformation, [mbOk], True);
    edNom.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;

  FEmprunteur.Nom := Trim(edNom.Text);
  FEmprunteur.Adresse.Assign(Coord.Lines);

  FEmprunteur.SaveToDatabase;

  ModalResult := mrOk;
end;

function TFrmEditEmprunteur.GetID_Emprunteur: TGUID;
begin
  Result := FEmprunteur.ID_Emprunteur;
end;

procedure TFrmEditEmprunteur.FormCreate(Sender: TObject);
begin
  FEmprunteur := TEmprunteurComplet.Create;
end;

procedure TFrmEditEmprunteur.FormDestroy(Sender: TObject);
begin
  FEmprunteur.Free;
end;

end.

