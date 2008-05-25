unit Form_Choix;
{$D-}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, UBdtForms;

type
  TFrmChoix = class(TbdtForm)
    BtnChoix1: TButton;
    BtnChoix2: TButton;
    BtnAnnuler: TBitBtn;
    Bevel1: TBevel;
    Bevel2: TBevel;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

{$R *.DFM}

end.
