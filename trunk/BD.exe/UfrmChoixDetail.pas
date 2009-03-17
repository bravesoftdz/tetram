unit UfrmChoixDetail;
{$D-}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, UBdtForms;

type
  TfrmChoixDetail = class(TbdtForm)
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
  frmChoixDetail: TfrmChoixDetail;

implementation

{$R *.DFM}

end.
