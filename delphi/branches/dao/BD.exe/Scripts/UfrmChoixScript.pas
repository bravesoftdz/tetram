unit UfrmChoixScript;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UBdtForms, UScriptList, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, UframBoutons;

type
  TfrmChoixScript = class(TbdtForm)
    framBoutons1: TframBoutons;
    Panel4: TPanel;
    Splitter3: TSplitter;
    ListBox2: TListBox;
    ListView1: TListView;
    Panel5: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Memo1: TMemo;
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure ListBox2Data(Control: TWinControl; Index: Integer; var Data: string);
    procedure ListBox2DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FCurrentScript: TScript;
    FScriptList: TScriptList;
    procedure LoadScripts;
    procedure RefreshOptions;
    procedure SetCurrentScript(const Value: TScript);
  public
    property CurrentScript: TScript read FCurrentScript write SetCurrentScript;
  end;

implementation

uses
  UfrmScriptOption, CommonConst;

{$R *.dfm}

procedure TfrmChoixScript.FormCreate(Sender: TObject);
begin
  FScriptList := TScriptList.Create;
  LoadScripts;
end;

procedure TfrmChoixScript.FormDestroy(Sender: TObject);
begin
  FScriptList.Free;
end;

procedure TfrmChoixScript.ListBox2Data(Control: TWinControl; Index: Integer; var Data: string);
begin
  Data := FCurrentScript.Options[index].FLibelle + ': ' + FCurrentScript.Options[index].ChooseValue;
end;

procedure TfrmChoixScript.ListBox2DblClick(Sender: TObject);
var
  Option: TOption;
begin
  if TListBox(Sender).ItemIndex = -1 then
    Exit;
  Option := FCurrentScript.Options[TListBox(Sender).ItemIndex];
  if TfrmScriptOption.AskForOption(FCurrentScript.ScriptUnitName, Option) = mrOk then
    RefreshOptions;
end;

procedure TfrmChoixScript.ListView1SelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  if Selected and Assigned(Item) then
    CurrentScript := TScript(Item.Data)
  else
    CurrentScript := nil;
end;

procedure TfrmChoixScript.LoadScripts;
var
  Script: TScript;
  li: TListItem;
begin
  ListView1.Items.BeginUpdate;
  try
    ListView1.Items.Clear;
    FScriptList.LoadDir(RepScripts);
    for Script in FScriptList do
      if Script.ScriptKind = skMain then
      begin
        li := ListView1.Items.Add;
        li.Data := Script;
        li.Caption := Script.ScriptUnitName;
      end;
  finally
    ListView1.Items.EndUpdate;
  end;
  ListView1.OnSelectItem(ListView1, nil, False);
end;

procedure TfrmChoixScript.RefreshOptions;
begin
  if Assigned(FCurrentScript) then
    ListBox2.Count := FCurrentScript.Options.Count
  else
    ListBox2.Count := 0;
  ListBox2.Invalidate;
end;

procedure TfrmChoixScript.SetCurrentScript(const Value: TScript);
begin
  FCurrentScript := Value;
  if Assigned(FCurrentScript) then
  begin
    FCurrentScript.Load;
    Label5.Caption := FCurrentScript.ScriptInfos.Auteur;
    if FCurrentScript.ScriptInfos.LastUpdate > 0 then
      Label6.Caption := DateTimeToStr(FCurrentScript.ScriptInfos.LastUpdate)
    else
      Label6.Caption := '';
    Label8.Caption := FCurrentScript.ScriptInfos.ScriptVersion;
    Label10.Caption := FCurrentScript.ScriptInfos.BDVersion;
    Memo1.Lines.Text := FCurrentScript.ScriptInfos.Description;
  end
  else
  begin
    Label5.Caption := '';
    Label6.Caption := '';
    Label8.Caption := '';
    Label10.Caption := '';
    Memo1.Lines.Clear;
  end;
  RefreshOptions;
  framBoutons1.btnOK.Enabled := Assigned(FCurrentScript);
end;

end.
