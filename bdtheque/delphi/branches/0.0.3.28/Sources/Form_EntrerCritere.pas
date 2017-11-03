unit Form_EntrerCritere;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls;

type
  TValue = (tvString, tvInt);

  TEntrerCritere = class(TForm)
    Panel1: TPanel;
    Edit2: TEdit;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    TypeValeur: TValue;
  end;

var
  EntrerCritere: TEntrerCritere;

implementation

{$R *.DFM}

procedure TEntrerCritere.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if (TypeValeur = tvInt) then
    if not (Key in [#8, '0'..'9', DecimalSeparator]) or ((Key=DecimalSeparator) and (Pos(DecimalSeparator, TEdit(Sender).Text) > 0)) then Key := #0;
end;

end.
