unit UfrmVerbose;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UBdtForms;

type
  TfrmVerbose = class(TbdtForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure Fin;
    procedure UIBVerbose(Sender: TObject; Message: string);
  end;

implementation

{$R *.dfm}

{ TFrmVerbose }

procedure TfrmVerbose.UIBVerbose(Sender: TObject; Message: string);
begin
  Memo1.Lines.Add(Message);
  Memo1.Perform(EM_SCROLLCARET, 0, 0);
end;

procedure TfrmVerbose.Fin;
begin
  Button1.Enabled := True;
end;

procedure TfrmVerbose.Button1Click(Sender: TObject);
begin
  Release;
end;

end.
