unit UfrmChoixDetail;
{$D-}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, BD.GUI.Forms, BD.GUI.Frames.Buttons;

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
  end;

implementation

{$R *.DFM}

end.
