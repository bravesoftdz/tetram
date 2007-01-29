unit Form_ChoixDetailSerie;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Fram_Boutons, StdCtrls, ComboCheck, ProceduresBDtk;

type
  TFrmChoixDetailSerie = class(TForm)
    CheckBox1: TCheckBox;
    Frame11: TFrame1;
    LightComboCheck1: TLightComboCheck;
  private
    FMaxNiveauDetail: TDetailSerieOption;
    procedure SetMaxNiveauDetail(const Value: TDetailSerieOption);
    { Déclarations privées }
  public
    { Déclarations publiques }
    property MaxNiveauDetail: TDetailSerieOption read FMaxNiveauDetail write SetMaxNiveauDetail;
  end;

implementation

{$R *.dfm}

{ TFrmChoixDetailSerie }

procedure TFrmChoixDetailSerie.SetMaxNiveauDetail(const Value: TDetailSerieOption);
var
  i: TDetailSerieOption;
begin
  FMaxNiveauDetail := Value;
  LightComboCheck1.Items.Clear;
  for i := Low(TDetailSerieOption) to High(TDetailSerieOption) do
    if i >= FMaxNiveauDetail then
      LightComboCheck1.Items.Add(LibelleDetailSerieOption[Value][i]).Valeur := Integer(i);
  LightComboCheck1.Value := Integer(FMaxNiveauDetail);
end;

end.

