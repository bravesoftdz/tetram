unit UfrmVerbose;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, UBdtForms;

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
    procedure UIBVerbose(Sender: TObject; message: string);
    function Log(const pChaine: string; Ligne: Integer = -1): Integer;
  end;

implementation

{$R *.dfm}
{ TFrmVerbose }

procedure TfrmVerbose.UIBVerbose(Sender: TObject; message: string);
begin
  Memo1.Lines.Add(message);
  Memo1.Perform(EM_SCROLLCARET, 0, 0);
end;

procedure TfrmVerbose.Fin;
begin
  Button1.Enabled := True;
end;

function TfrmVerbose.Log(const pChaine: string; Ligne: Integer): Integer;
begin
  Result := Ligne;
  if Ligne = -1 then
    Result := Memo1.Lines.Add(pChaine)
  else
    Memo1.Lines[Ligne] := pChaine;
  Memo1.Perform(EM_SCROLLCARET, 0, 0);
  Application.ProcessMessages;
end;

procedure TfrmVerbose.Button1Click(Sender: TObject);
begin
  Release;
end;

end.
