unit UfrmScriptOption;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UframBoutons, StdCtrls, ExtCtrls, UbdtForms, UScriptList;

type
  TfrmScriptOption = class(TBdtForm)
    RadioGroup1: TRadioGroup;
    framBoutons1: TframBoutons;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    class function AskForOption(const ScriptName: string; Option: TOption): Integer;
  end;

implementation

{$R *.dfm}
{ TfrmScriptOption }

class function TfrmScriptOption.AskForOption(const ScriptName: string; Option: TOption): Integer;
var
  frm: TfrmScriptOption;
begin
  frm := TfrmScriptOption.Create(nil);
  try
    frm.RadioGroup1.Caption := Option.FLibelle;
    frm.RadioGroup1.Items.Text := StringReplace(Option.FValues, '|', sLineBreak, [rfReplaceAll]);
    frm.RadioGroup1.ItemIndex := frm.RadioGroup1.Items.IndexOf(Option.ChooseValue);
    frm.RadioGroup1.Height := 21 + 20 * frm.RadioGroup1.Items.Count;
    frm.ClientHeight := frm.RadioGroup1.Height + frm.framBoutons1.Height + 4;
    Result := frm.ShowModal;
    if Result = mrOk then
    begin
      Option.ChooseValue := frm.RadioGroup1.Items[frm.RadioGroup1.ItemIndex];
      Option.Save(ScriptName, nil);
    end;
  finally
    frm.Free;
  end;
end;

end.
