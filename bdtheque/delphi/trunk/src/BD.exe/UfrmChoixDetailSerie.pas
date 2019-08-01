unit UfrmChoixDetailSerie;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BD.GUI.Frames.Buttons, StdCtrls, ComboCheck, BDTK.GUI.Utils, BD.GUI.Forms;

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
  btn: TButton;
begin
  FMaxNiveauDetail := Value;

  nbButtons := 0;
  for i := Low(TDetailSerieOption) to High(TDetailSerieOption) do
    if i >= FMaxNiveauDetail then
    begin
      btn := TButton.Create(Self);
      btn.Parent := Self;
      btn.Left := 22;
      btn.Top := 23 + Integer(nbButtons) * 47;
      btn.Width := 350;
      btn.Height := 42;
      btn.Cursor := crHandPoint;
      btn.Style := bsCommandLink;
      btn.Caption := LibelleDetailSerieOption[FMaxNiveauDetail][i];
      btn.Default := i = FMaxNiveauDetail;
      btn.ModalResult := 110 + Integer(i);
      Inc(nbButtons);
    end;
  CheckBox1.Top := 23 + Integer(nbButtons) * 47 + 23;
  ClientHeight := CheckBox1.Top + framBoutons1.Height;
  if CheckBox1.Visible then
    ClientHeight := ClientHeight + CheckBox1.Height + 6;
end;

end.

