unit UframScriptInfos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, EditLabeled,
  Vcl.ComCtrls, UScriptList, Vcl.Menus, System.Actions, Vcl.ActnList, UScriptEngineIntf;

type
  TframScriptInfos = class(TFrame)
    Panel3: TPageControl;
    TabSheet4: TTabSheet;
    ListBox1: TListBox;
    TabSheet5: TTabSheet;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    EditLabeled1: TEditLabeled;
    MemoLabeled1: TMemoLabeled;
    EditLabeled2: TEditLabeled;
    EditLabeled3: TEditLabeled;
    Alias: TTabSheet;
    Memo2: TMemo;
    PopupMenu2: TPopupMenu;
    Creruneoption1: TMenuItem;
    Modifieruneoption1: TMenuItem;
    Retireruneoption1: TMenuItem;
    ActionList1: TActionList;
    actCreerOption: TAction;
    actRetirerOption: TAction;
    actModifierOption: TAction;
    procedure ListBox1Data(Control: TWinControl; Index: Integer; var Data: string);
    procedure ListBox1DblClick(Sender: TObject);
    procedure MemoLabeled1Change(Sender: TObject);
    procedure actCreerOptionExecute(Sender: TObject);
    procedure actRetirerOptionExecute(Sender: TObject);
    procedure actModifierOptionExecute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
  private
    FMasterEngine: IMasterEngine;
    FRefreshingDescription: Boolean;
    procedure SetMasterEngine(const Value: IMasterEngine);
  public
    function EditOption(Option: TOption): Boolean;
    procedure RefreshOptions;
    procedure RefreshDescription;
    property MasterEngine: IMasterEngine read FMasterEngine write SetMasterEngine;
  end;

implementation

{$R *.dfm}

uses
  UIB, UfrmScriptOption, UdmPrinc, Commun, UfrmScriptEditOption, StrUtils;

procedure TframScriptInfos.actCreerOptionExecute(Sender: TObject);
var
  Option: TOption;
begin
  Option := TOption.Create;
  if EditOption(Option) then
  begin
    Option.ChooseValue := Option.FDefaultValue;
    MasterEngine.ProjectScript.Options.Add(Option);
    RefreshOptions;
  end
  else
    Option.Free;
end;

procedure TframScriptInfos.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
// 2013/10/24: en attendant mieux... ou de voir si c'est toujours utile de tester "projet ouvert"
const
  FProjetOuvert = True;
begin
  actCreerOption.Visible := FProjetOuvert;
  actCreerOption.Enabled := FProjetOuvert;
  actRetirerOption.Visible := FProjetOuvert;
  actRetirerOption.Enabled := FProjetOuvert and (ListBox1.ItemIndex <> -1);
  actModifierOption.Visible := FProjetOuvert;
  actModifierOption.Enabled := FProjetOuvert and (ListBox1.ItemIndex <> -1);
end;

procedure TframScriptInfos.actModifierOptionExecute(Sender: TObject);
begin
  if EditOption(MasterEngine.ProjectScript.Options[ListBox1.ItemIndex]) then
    RefreshOptions;
end;

procedure TframScriptInfos.actRetirerOptionExecute(Sender: TObject);
begin
  MasterEngine.ProjectScript.Options.Delete(ListBox1.ItemIndex);
  MasterEngine.ProjectScript.Modifie := True;
  RefreshOptions;
end;

function TframScriptInfos.EditOption(Option: TOption): Boolean;
var
  s: string;
  frm: TfrmScriptEditOption;
begin
  frm := TfrmScriptEditOption.Create(nil);
  try
    frm.EditLabeled1.Text := Option.FLibelle;
    frm.MemoLabeled1.Lines.Text := StringReplace(Option.FValues, '|', sLineBreak, [rfReplaceAll]);
    frm.EditLabeled2.Text := Option.FDefaultValue;

    Result := frm.ShowModal = mrOk;
    if Result then
    begin
      Option.FLibelle := frm.EditLabeled1.Text;
      s := frm.MemoLabeled1.Lines.Text;
      while EndsText(sLineBreak, s) do
        Delete(s, Length(s) - Length(sLineBreak) + 1, Length(sLineBreak));
      s := StringReplace(s, sLineBreak, '|', [rfReplaceAll]);
      Option.FValues := s;
      Option.FDefaultValue := frm.EditLabeled2.Text;

      MasterEngine.ProjectScript.Modifie := True;
    end;
  finally
    frm.Free;
  end;
end;

procedure TframScriptInfos.ListBox1Data(Control: TWinControl; Index: Integer; var Data: string);
begin
  Data := MasterEngine.ProjectScript.Options[index].FLibelle + ': ' + MasterEngine.ProjectScript.Options[index].ChooseValue;
end;

procedure TframScriptInfos.ListBox1DblClick(Sender: TObject);
var
  Option: TOption;
  qry: TUIBQuery;
  frm: TfrmScriptOption;
begin
  if TListBox(Sender).ItemIndex = -1 then
    Exit;
  Option := MasterEngine.ProjectScript.Options[TListBox(Sender).ItemIndex];

  frm := TfrmScriptOption.Create(nil);
  try
    frm.RadioGroup1.Caption := Option.FLibelle;
    frm.RadioGroup1.Items.Text := StringReplace(Option.FValues, '|', sLineBreak, [rfReplaceAll]);
    frm.RadioGroup1.ItemIndex := frm.RadioGroup1.Items.IndexOf(Option.ChooseValue);
    frm.RadioGroup1.Height := 21 + 20 * frm.RadioGroup1.Items.Count;
    ClientHeight := frm.RadioGroup1.Height + frm.framBoutons1.Height + 4;
    if frm.ShowModal = mrOk then
    begin
      Option.ChooseValue := frm.RadioGroup1.Items[frm.RadioGroup1.ItemIndex];

      qry := TUIBQuery.Create(nil);
      try
        qry.Transaction := GetTransaction(dmPrinc.UIBDataBase);
        qry.SQL.Text := 'update or insert into options_scripts (script, nom_option, valeur) values (:script, :nom_option, :valeur)';
        qry.Prepare(True);
        qry.Params.AsString[0] := Copy(string(MasterEngine.ProjectScript.ScriptUnitName), 1, qry.Params.MaxStrLen[0]);
        qry.Params.AsString[1] := Copy(Option.FLibelle, 1, qry.Params.MaxStrLen[1]);
        qry.Params.AsString[2] := Copy(Option.ChooseValue, 1, qry.Params.MaxStrLen[2]);
        qry.Execute;
        qry.Transaction.Commit;
      finally
        qry.Transaction.Free;
        qry.Free;
      end;

      RefreshOptions;
      RefreshDescription;
    end;
  finally
    Free;
  end;
end;

procedure TframScriptInfos.MemoLabeled1Change(Sender: TObject);
begin
  if FRefreshingDescription then
    Exit;
  if Sender = EditLabeled1 then
    MasterEngine.ProjectScript.ScriptInfos.Auteur := EditLabeled1.Text;
  if Sender = EditLabeled2 then
    MasterEngine.ProjectScript.ScriptInfos.ScriptVersion := EditLabeled2.Text;
  if Sender = EditLabeled3 then
    MasterEngine.ProjectScript.ScriptInfos.BDVersion := EditLabeled3.Text;
  if Sender = MemoLabeled1 then
    MasterEngine.ProjectScript.ScriptInfos.Description := MemoLabeled1.Text;
  if Sender = Memo2 then
    MasterEngine.ProjectScript.Alias.Assign(Memo2.Lines);
  MasterEngine.ProjectScript.Modifie := True;
end;

procedure TframScriptInfos.RefreshDescription;
begin
  FRefreshingDescription := True;
  try
    if Assigned(MasterEngine.ProjectScript) then
    begin
      EditLabeled1.Text := MasterEngine.ProjectScript.ScriptInfos.Auteur;
      EditLabeled2.Text := MasterEngine.ProjectScript.ScriptInfos.ScriptVersion;
      EditLabeled3.Text := MasterEngine.ProjectScript.ScriptInfos.BDVersion;
      MemoLabeled1.Text := MasterEngine.ProjectScript.ScriptInfos.Description;
      Memo2.Lines.Assign(MasterEngine.ProjectScript.Alias);
    end;
  finally
    FRefreshingDescription := False;
  end;
end;

procedure TframScriptInfos.RefreshOptions;
begin
  if Assigned(MasterEngine.ProjectScript) then
    ListBox1.Count := MasterEngine.ProjectScript.Options.Count
  else
    ListBox1.Count := 0;
  ListBox1.Invalidate;
end;

procedure TframScriptInfos.SetMasterEngine(const Value: IMasterEngine);
begin
  FMasterEngine := Value;
end;

end.
