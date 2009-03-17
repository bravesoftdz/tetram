unit Fram_Boutons;
{$D-}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, UfrmFond;

type
  TFrame1 = class(TFrame)
    btnOK: TButton;
    btnAnnuler: TButton;
    procedure FrameResize(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnAnnulerClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

{$R *.DFM}

procedure TFrame1.FrameResize(Sender: TObject);
begin
  btnOK.Top := (ClientHeight - btnOK.Height) div 2;
  btnAnnuler.Top := btnOK.Top;
end;

procedure TFrame1.btnOKClick(Sender: TObject);
begin
  if Owner is TCustomForm then
    with TCustomForm(Owner) do begin
      ActiveControl.Perform(CM_EXIT, 0, 0);
      ModalResult := mrOk;
    end;
end;

procedure TFrame1.btnAnnulerClick(Sender: TObject);
begin
  if Owner is TCustomForm then
    with TCustomForm(Owner) do begin
      ModalResult := mrCancel;
    end;
end;

end.
