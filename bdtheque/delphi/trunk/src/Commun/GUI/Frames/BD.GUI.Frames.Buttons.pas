unit BD.GUI.Frames.Buttons;
{$D-}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, BD.GUI.DataModules.Common;

type
  TframBoutons = class(TFrame)
    btnOK: TButton;
    btnAnnuler: TButton;
    procedure FrameResize(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnAnnulerClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure Loaded; override;
  end;

implementation

{$R *.DFM}

procedure TframBoutons.FrameResize(Sender: TObject);
begin
  btnOK.Top := (ClientHeight - btnOK.Height) div 2;
  btnAnnuler.Top := btnOK.Top;
end;

procedure TframBoutons.Loaded;
begin
  inherited;
  // code nécessaire pour faire afficher correctement les boutons pour le premier affichage de l'instance
  btnOK.HandleNeeded;
  btnAnnuler.HandleNeeded;
end;

procedure TframBoutons.btnOKClick(Sender: TObject);
begin
  if Owner is TCustomForm then
  begin
    TCustomForm(Owner).ActiveControl.Perform(CM_EXIT, 0, 0);
    TCustomForm(Owner).ModalResult := mrOk;
  end;
end;

procedure TframBoutons.btnAnnulerClick(Sender: TObject);
begin
  if Owner is TCustomForm then
    TCustomForm(Owner).ModalResult := mrCancel;
end;

end.

