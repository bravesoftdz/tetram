unit DM_Scripts;

interface

uses
  SysUtils, Classes, uPSComponent, uPSComponent_StdCtrls,
  uPSComponent_Controls, uPSComponent_Forms, uPSComponent_DB,
  uPSComponent_COM, uPSComponent_Default;

type
  TDMScripts = class(TDataModule)
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  DMScripts: TDMScripts;

implementation

{$R *.dfm}

end.
