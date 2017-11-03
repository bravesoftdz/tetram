unit Frame_Convertisseur;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DBEditLabeled;

type
  TConvertisseur = class(TFrame)
    Label2: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    Edit1: TEditLabeled;
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    FTaux: Currency;
  end;

implementation

uses Commun, CommonConst, Form_Convertisseur;

{$R *.DFM}

const
  travail: Boolean = False;

procedure TConvertisseur.Edit1Change(Sender: TObject);
var
  val: Currency;
  Position: Integer;
begin
  Position := Edit1.SelStart;
  Label2.Caption := '';
  val := StrToCurrDef(Edit1.Text, 0) * FTaux;
  Label2.Caption := FormatCurr(FormatMonnaie, val);
  if not travail then begin
    travail := True;
    TFrmConvers(Owner).Valeur := val;
    Edit1.SelStart := Position;
    travail := False;
  end;
end;

procedure TConvertisseur.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8, DecimalSeparator, '.', ',']) then Key := #0;
  if Key in ['.', ','] then Key := DecimalSeparator;
  if (Pos(DecimalSeparator, Edit1.Text) <> 0) and (Key = DecimalSeparator) then Key := #0;
end;

end.
