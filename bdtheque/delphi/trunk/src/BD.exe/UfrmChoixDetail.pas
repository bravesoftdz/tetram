unit UfrmChoixDetail;
{$D-}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, BD.GUI.Forms, BD.GUI.Frames.Buttons;

type
  TfrmChoixDetail = class(TbdtForm)
    BtnChoix1: TButton;
    BtnChoix2: TButton;
    cbDessins: TCheckBox;
    cbHistoire: TCheckBox;
    cbNotes: TCheckBox;
    cbScenario: TCheckBox;
    cbCouleurs: TCheckBox;
    framBoutons1: TframBoutons;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

{$R *.DFM}

end.
