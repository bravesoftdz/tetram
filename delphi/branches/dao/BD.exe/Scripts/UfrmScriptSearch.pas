unit UfrmScriptSearch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, SynEditTypes, UBdtForms;

type
  TfrmScriptSearch = class(TbdtForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    TabControl1: TTabControl;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    RadioGroup3: TRadioGroup;
    ComboBox1: TComboBox;
    GroupBox2: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioGroup2: TRadioGroup;
    ComboBox2: TComboBox;
    Label2: TLabel;
    Label1: TLabel;
    procedure TabControl1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    class function Execute(var ASearch, AReplace: string; var AOptions: TSynSearchOptions): Boolean;
  end;

implementation

{$R *.dfm}

const
  FLastSearch: string = '';
  FLastReplace: string = '';

class function TfrmScriptSearch.Execute(var ASearch, AReplace: string; var AOptions: TSynSearchOptions): Boolean;
begin
  with TfrmScriptSearch.Create(nil) do
  try
    if ASearch = '' then
      ComboBox1.ItemIndex := 0
    else
      ComboBox1.Text := ASearch;

    if AReplace = '' then
      ComboBox2.ItemIndex := 0
    else
      ComboBox2.Text := AReplace;

    CheckBox1.Checked := ssoMatchCase in AOptions;
    CheckBox2.Checked := ssoWholeWord in AOptions;
    CheckBox3.Checked := ssoPrompt in AOptions;

    RadioButton2.Checked := ssoBackwards in AOptions;
    if not (ssoSelectedOnly in AOptions) then RadioGroup3.ItemIndex := 1;
    if ssoEntireScope in AOptions then RadioGroup2.ItemIndex := 1;

    if ssoReplace in AOptions then TabControl1.TabIndex := 1;
    TabControl1Change(nil);

    Result := (ShowModal in [mrOk, mrYesToAll]) and (ComboBox1.Text <> '');
    if Result then
    begin
      AOptions := [];
      ASearch := ComboBox1.Text;

      if CheckBox1.Checked then Include(AOptions, ssoMatchCase);
      if CheckBox2.Checked then Include(AOptions, ssoWholeWord);
      if CheckBox3.Checked then Include(AOptions, ssoPrompt);

      if RadioButton2.Checked then Include(AOptions, ssoBackwards);
      if RadioGroup3.ItemIndex = 0 then Include(AOptions, ssoSelectedOnly);
      if RadioGroup2.ItemIndex = 1 then Include(AOptions, ssoEntireScope);

      if TabControl1.TabIndex = 1 then
      begin
        AReplace := ComboBox2.Text;
        if ModalResult = mrOk then
          Include(AOptions, ssoReplace)
        else
          Include(AOptions, ssoReplaceAll);
      end;
    end;
  finally
    Free;
  end;
end;

procedure TfrmScriptSearch.TabControl1Change(Sender: TObject);
begin
  ComboBox2.Visible := TabControl1.TabIndex = 1;
  Label2.Visible := ComboBox2.Visible;
  CheckBox3.Visible := ComboBox2.Visible;
  Button3.Visible := ComboBox2.Visible;
end;

procedure TfrmScriptSearch.FormCreate(Sender: TObject);
begin
  TabControl1Change(nil);
  ComboBox1.Items.Text := FLastSearch;
  ComboBox2.Items.Text := FLastReplace;
end;

procedure TfrmScriptSearch.Button3Click(Sender: TObject);

  function AddCombo(Combo: TComboBox): string;
  var
    i: Integer;
  begin
    Result := '';
    i := Combo.Items.IndexOf(Combo.Text);
    if i = -1 then
      Combo.Items.Insert(0, Combo.Text)
    else
      Combo.Items.Move(i, 0);
    Result := Combo.Items.Text;
  end;

begin
  FLastSearch := AddCombo(ComboBox1);
  FLastReplace := AddCombo(ComboBox2);
end;

procedure TfrmScriptSearch.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 9) and (ssCtrl in Shift) then
  begin
    TabControl1.TabIndex := 1 - TabControl1.TabIndex;
    TabControl1Change(TabControl1);
  end;
end;

end.

