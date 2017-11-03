unit Form_CreateExclu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFCreateExclu = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    RadioGroup1: TRadioGroup;
    CheckBox1: TCheckBox;
    Button5: TButton;
    Button3: TButton;
    OpenDialogExclu: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FCreateExclu: TFCreateExclu;

implementation

uses Form_SelectWindow;

{$R *.dfm}

procedure TFCreateExclu.Button1Click(Sender: TObject);
begin
  case RadioGroup1.ItemIndex of
    0: begin
      if not OpenDialogExclu.Execute then Exit;
      Edit1.Text := OpenDialogExclu.FileName;
    end;
    1:
      with TFSelectWindow.Create(Self) do try
        if ShowModal = mrOk then
          Edit1.Text := TreeView1.Selected.Text;
      finally
        Free;
      end;
  end;
end;

procedure TFCreateExclu.RadioGroup1Click(Sender: TObject);
begin
  CheckBox1.Enabled := RadioGroup1.ItemIndex = 1;
end;

end.
