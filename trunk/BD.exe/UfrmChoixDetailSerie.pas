unit UfrmChoixDetailSerie;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UframBoutons, StdCtrls, ComboCheck, ProceduresBDtk, UBdtForms;

type
  TfrmChoixDetailSerie = class(TbdtForm)
    CheckBox1: TCheckBox;
    Frame11: TframBoutons;
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

procedure TfrmChoixDetailSerie.SetMaxNiveauDetail(const Value: TDetailSerieOption);
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

