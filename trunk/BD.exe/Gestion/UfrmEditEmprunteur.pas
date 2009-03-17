unit UfrmEditEmprunteur;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, DBCtrls, Mask, Menus, ExtCtrls,
  DBEditLabeled, DB, Buttons, LoadComplet, UBdtForms,
  UframBoutons;

type
  TfrmEditEmprunteur = class(TbdtForm)
    ScrollBox1: TScrollBox;
    emprunts: TLabel;
    Label2: TLabel;
    coord: TMemo;
    edNom: TEditLabeled;
    Label3: TLabel;
    Bevel1: TBevel;
    Frame11: TframBoutons;
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

uses Commun, Procedures, Textes;

{$R *.DFM}

procedure TfrmEditEmprunteur.SetID_Emprunteur(const Value: TGUID);
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;

  FEmprunteur.Fill(Value);

  edNom.Text := FEmprunteur.Nom;
  Coord.Lines.Text := FEmprunteur.Adresse.Text;
  emprunts.Caption := IntToStr(FEmprunteur.Emprunts.NBEmprunts);
end;

procedure TfrmEditEmprunteur.Frame11btnOKClick(Sender: TObject);
begin
  if Length(Trim(edNom.Text)) = 0 then begin
    AffMessage(rsNomObligatoire, mtInformation, [mbOk], True);
    edNom.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;

  FEmprunteur.Nom := Trim(edNom.Text);
  FEmprunteur.Adresse.Text := Coord.Lines.Text;

  FEmprunteur.SaveToDatabase;

  ModalResult := mrOk;
end;

function TfrmEditEmprunteur.GetID_Emprunteur: TGUID;
begin
  Result := FEmprunteur.ID_Emprunteur;
end;

procedure TfrmEditEmprunteur.FormCreate(Sender: TObject);
begin
  FEmprunteur := TEmprunteurComplet.Create;
end;

procedure TfrmEditEmprunteur.FormDestroy(Sender: TObject);
begin
  FEmprunteur.Free;
end;

end.

