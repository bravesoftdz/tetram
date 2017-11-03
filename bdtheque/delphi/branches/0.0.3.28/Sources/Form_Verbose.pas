unit Form_Verbose;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvUIB;

type
  TFrmVerbose = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
    procedure Fin;
    procedure UIBVerbose(Sender: TObject; Message: string);
  end;

implementation

{$R *.dfm}

{ TFrmVerbose }

procedure TFrmVerbose.UIBVerbose(Sender: TObject; Message: string);
begin
  Memo1.Lines.Add(Message);
  Memo1.Perform(EM_SCROLLCARET, 0, 0);
end;

procedure TFrmVerbose.Fin;
begin
  Button1.Enabled := True;
end;

procedure TFrmVerbose.Button1Click(Sender: TObject);
begin
  Release;
end;

end.
