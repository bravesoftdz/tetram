unit UfrmChoixDetailSerie;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UframBoutons, StdCtrls, ComboCheck, ProceduresBDtk, UBdtForms;

type
  TfrmChoixDetailSerie = class(TbdtForm)
    CheckBox1: TCheckBox;
    framBoutons1: TframBoutons;
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
  nbButtons: Integer;
begin
  FMaxNiveauDetail := Value;

  nbButtons := 0;
  for i := Low(TDetailSerieOption) to High(TDetailSerieOption) do
    if i >= FMaxNiveauDetail then
      with TButton.Create(Self) do
      begin
        Parent := Self;
        Left := 22;
        Top := 23 + Integer(nbButtons) * 47;
        Width := 350;
        Height := 42;
        Cursor := crHandPoint;
        Style := bsCommandLink;
        Caption := LibelleDetailSerieOption[FMaxNiveauDetail][i];
        Default := i = FMaxNiveauDetail;
        ModalResult := 110 + Integer(i);
        Inc(nbButtons);
      end;
  CheckBox1.Top := 23 + Integer(nbButtons) * 47 + 23;
  ClientHeight := CheckBox1.Top + framBoutons1.Height;
  if CheckBox1.Visible then
    ClientHeight := ClientHeight + CheckBox1.Height + 6;
end;

end.

