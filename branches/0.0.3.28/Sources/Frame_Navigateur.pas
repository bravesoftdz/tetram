unit Frame_Navigateur;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, VDTButton;

type
  TFramNavigateur = class(TFrame)
    VDTButton1: TVDTButton;
    VDTButton2: TVDTButton;
    VDTButton3: TVDTButton;
    VDTButton4: TVDTButton;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

{$R *.dfm}

end.
