unit UfrmProgression;
{$D-}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ComCtrls, ProgressBar, Commun, UBdtForms;

type
  TfrmProgression = class(TbdtForm)
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

procedure TfrmProgression.FormCreate(Sender: TObject);
begin
  hg := THourGlass.Create;
end;

end.
