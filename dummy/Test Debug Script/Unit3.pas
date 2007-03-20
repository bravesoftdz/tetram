unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  Tdebugoutput = class(TForm)
    Output: TMemo;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  debugoutput: Tdebugoutput;

implementation

{$R *.dfm}

end.
