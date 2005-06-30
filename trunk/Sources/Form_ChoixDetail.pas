unit Form_ChoixDetail;
{$D-}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TFrmChoixDetail = class(TForm)
    BtnChoix1: TButton;
    BtnChoix2: TButton;
    BtnAnnuler: TButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    cbDessins: TCheckBox;
    cbHistoire: TCheckBox;
    cbNotes: TCheckBox;
    cbScenario: TCheckBox;
    cbCouleurs: TCheckBox;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FrmChoixDetail: TFrmChoixDetail;

implementation

{$R *.DFM}

end.
