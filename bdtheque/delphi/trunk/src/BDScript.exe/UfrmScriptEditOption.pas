unit UfrmScriptEditOption;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BD.GUI.Frames.Buttons, StdCtrls, ExtCtrls, BD.GUI.Forms, EditLabeled;

type
  TfrmScriptEditOption = class(TBdtForm)
    framBoutons1: TframBoutons;
    Label2: TLabel;
    MemoLabeled1: TMemoLabeled;
    Label1: TLabel;
    EditLabeled1: TEditLabeled;
    Label3: TLabel;
    EditLabeled2: TEditLabeled;
    procedure MemoLabeled1Change(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

{$R *.dfm}

procedure TfrmScriptEditOption.MemoLabeled1Change(Sender: TObject);
begin
  framBoutons1.btnOK.Enabled := (EditLabeled1.Text <> '') and ((EditLabeled2.Text = '') or (MemoLabeled1.Lines.IndexOf(EditLabeled2.Text) <> -1));
end;

end.
