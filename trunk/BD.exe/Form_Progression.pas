unit Form_Progression;
{$D-}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ComCtrls, ProgressBar, Commun, UBdtForms;

type
  TFrmProgression = class(TbdtForm)
    ProgressBar1: TMKProgressBar;
    op: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    hg: IHourGlass;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

{$R *.DFM}

procedure TFrmProgression.FormCreate(Sender: TObject);
begin
  hg := THourGlass.Create;
end;

end.
