unit Form_Progression;
{$D-}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ComCtrls, ProgressBar, Commun;

type
  TFrmProgression = class(TForm)
    ProgressBar1: TMKProgressBar;
    op: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    hg: IHourGlass;
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

var
  FrmProgression: TFrmProgression;

implementation

{$R *.DFM}

procedure TFrmProgression.FormCreate(Sender: TObject);
begin
  hg := THourGlass.Create;
end;

end.
