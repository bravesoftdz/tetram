unit BDTK.GUI.Frames.Converter;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, EditLabeled;

type
  TframConvertisseur = class(TFrame)
    Label2: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    Edit1: TEditLabeled;
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  public
    FTaux: Currency;
  end;

implementation

uses
  BD.Utils.StrUtils, BD.Common, BDTK.GUI.Forms.Converter;

{$R *.DFM}

procedure TframConvertisseur.Edit1Change(Sender: TObject);
const
  travail: Boolean = False;
var
  val: Currency;
  Position: Integer;
begin
  Position := Edit1.SelStart;
  Label2.Caption := '';
  val := BDStrToDoubleDef(Edit1.Text, 0) * FTaux;
  Label2.Caption := BDCurrencyToStr(val);
  if not travail then
  begin
    travail := True;
    TFrmConvers(Owner).Valeur := val;
    Edit1.SelStart := Position;
    travail := False;
  end;
end;

procedure TframConvertisseur.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0' .. '9', #8, FormatSettings.DecimalSeparator, '.',
    ',']) then
    Key := #0;
  if CharInSet(Key, ['.', ',']) then
    Key := FormatSettings.DecimalSeparator;
  if (Pos(FormatSettings.DecimalSeparator, Edit1.Text) <> 0) and
    (Key = FormatSettings.DecimalSeparator) then
    Key := #0;
end;

end.
