unit Form_Progression;
{$D-}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ComCtrls, ProgressBar;

type
  IHourGlass = interface
  end;
  THourGlass = class(TInterfacedObject, IHourGlass)
  private
    FOldCursor: TCursor;
  published
    constructor Create;
    destructor Destroy; override;
  end;

  TFrmProgression = class(TForm)
    op: TLabel;
    ProgressBar1: TProgressBar;
    procedure FormCreate(Sender: TObject);
  private
    hg: IHourGlass;
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

implementation

{$R *.DFM}

{ THourGlass }

constructor THourGlass.Create;
begin
  inherited;
  FOldCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
end;

destructor THourGlass.Destroy;
begin
  Screen.Cursor := FOldCursor;
  inherited;
end;

procedure TFrmProgression.FormCreate(Sender: TObject);
begin
  hg := THourGlass.Create;
end;

end.
