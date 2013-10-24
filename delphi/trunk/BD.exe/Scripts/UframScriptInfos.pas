unit UframScriptInfos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, EditLabeled,
  Vcl.ComCtrls, UScriptList, Vcl.Menus;

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
    procedure ListBox1Data(Control: TWinControl; Index: Integer; var Data: string);
    procedure ListBox1DblClick(Sender: TObject);
    procedure MemoLabeled1Change(Sender: TObject);
  private
    FScript: TScript;
    FRefreshingDescription: Boolean;
    procedure SetScript(const Value: TScript);
  public
    procedure RefreshOptions;
    procedure RefreshDescription;
    property Script: TScript read FScript write SetScript;
  end;

implementation

{$R *.dfm}

uses
  UIB, UfrmScriptOption, UdmPrinc, Commun;

procedure TframScriptInfos.ListBox1Data(Control: TWinControl; Index: Integer; var Data: string);
begin
  Data := FScript.Options[index].FLibelle + ': ' + FScript.Options[index].ChooseValue;
end;

procedure TframScriptInfos.ListBox1DblClick(Sender: TObject);
var
  Option: TOption;
begin
  if TListBox(Sender).ItemIndex = -1 then
    Exit;
  Option := FScript.Options[TListBox(Sender).ItemIndex];

  with TfrmScriptOption.Create(nil) do
    try
      RadioGroup1.Caption := Option.FLibelle;
      RadioGroup1.Items.Text := StringReplace(Option.FValues, '|', sLineBreak, [rfReplaceAll]);
      RadioGroup1.ItemIndex := RadioGroup1.Items.IndexOf(Option.ChooseValue);
      RadioGroup1.Height := 21 + 20 * RadioGroup1.Items.Count;
      ClientHeight := RadioGroup1.Height + framBoutons1.Height + 4;
      if ShowModal = mrOk then
      begin
        Option.ChooseValue := RadioGroup1.Items[RadioGroup1.ItemIndex];

        with TUIBQuery.Create(nil) do
          try
            Transaction := GetTransaction(dmPrinc.UIBDataBase);
            SQL.Text := 'update or insert into options_scripts (script, nom_option, valeur) values (:script, :nom_option, :valeur)';
            Prepare(True);
            Params.AsString[0] := Copy(string(FScript.ScriptName), 1, Params.MaxStrLen[0]);
            Params.AsString[1] := Copy(Option.FLibelle, 1, Params.MaxStrLen[1]);
            Params.AsString[2] := Copy(Option.ChooseValue, 1, Params.MaxStrLen[2]);
            Execute;
            Transaction.Commit;
          finally
            Transaction.Free;
            Free;
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
    FScript.ScriptInfos.Auteur := EditLabeled1.Text;
  if Sender = EditLabeled2 then
    FScript.ScriptInfos.ScriptVersion := EditLabeled2.Text;
  if Sender = EditLabeled3 then
    FScript.ScriptInfos.BDVersion := EditLabeled3.Text;
  if Sender = MemoLabeled1 then
    FScript.ScriptInfos.Description := MemoLabeled1.Text;
  if Sender = Memo2 then
    FScript.Alias.Assign(Memo2.Lines);
  FScript.Modifie := True;
end;

procedure TframScriptInfos.RefreshDescription;
begin
  FRefreshingDescription := True;
  try
    if Assigned(FScript) then
    begin
      EditLabeled1.Text := Script.ScriptInfos.Auteur;
      EditLabeled2.Text := Script.ScriptInfos.ScriptVersion;
      EditLabeled3.Text := Script.ScriptInfos.BDVersion;
      MemoLabeled1.Text := Script.ScriptInfos.Description;
      Memo2.Lines.Assign(Script.Alias);
    end;
  finally
    FRefreshingDescription := False;
  end;
end;

procedure TframScriptInfos.RefreshOptions;
begin
  if Assigned(FScript) then
    ListBox1.Count := FScript.Options.Count
  else
    ListBox1.Count := 0;
  ListBox1.Invalidate;
end;

procedure TframScriptInfos.SetScript(const Value: TScript);
begin
  FScript := Value;
end;

end.
