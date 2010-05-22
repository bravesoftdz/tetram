unit UScriptEdition;

interface

uses
  AnsiStrings, SysUtils, Windows, Classes, UScriptList, SynEdit, ComCtrls;

type
  TScriptEdition = class(TScript)
  strict private
    FTabSheet: TTabSheet;
    FEditor: TSynEdit;
    FSB: TStatusBar;
    FModifie: Boolean;
    procedure SetModifie(const Value: Boolean);
  public
    constructor Create; override;

    procedure SetFileName(const Value: String); override;
    procedure SaveToFile(const FileName: string); override;
    procedure GetScriptLines(Lines: TStrings); override;

    property TabSheet: TTabSheet read FTabSheet write FTabSheet;
    property Editor: TSynEdit read FEditor write FEditor;
    property SB: TStatusBar read FSB write FSB;
    property Modifie: Boolean read FModifie write SetModifie;
  end;

  TScriptListEdition = class(TScriptList)
    function InfoScript(Index: Integer): TScriptEdition; overload;
    function InfoScript(TabSheet: TTabSheet): TScriptEdition; overload;
    function InfoScript(Editor: TSynEdit): TScriptEdition; overload;
    function InfoScriptByScriptName(const Script: AnsiString): TScriptEdition;

    function ScriptName(Index: Integer): AnsiString; overload;
    function ScriptName(TabSheet: TTabSheet): AnsiString; overload;
    function ScriptName(Editor: TSynEdit): AnsiString; overload;

    function ScriptFileName(Index: Integer): string; overload;
    function ScriptFileName(TabSheet: TTabSheet): string; overload;
    function ScriptFileName(Editor: TSynEdit): string; overload;

    function EditorByIndex(Index: Integer): TSynEdit;
    function EditorByScriptName(const Script: AnsiString): TSynEdit;
  end;

implementation

constructor TScriptEdition.Create;
begin
  inherited;
  FModifie := False;
end;

procedure TScriptEdition.GetScriptLines(Lines: TStrings);
begin
  if Assigned(Editor) then
    Lines.Assign(Editor.Lines)
  else
    inherited;
end;

procedure TScriptEdition.SaveToFile(const FileName: string);
begin
  inherited;
  Modifie := False;
end;

procedure TScriptEdition.SetFileName(const Value: String);
begin
  inherited;
  if Assigned(FTabSheet) then FTabSheet.Caption := string(ScriptName);
end;

procedure TScriptEdition.SetModifie(const Value: Boolean);
begin
  FModifie := Value;
  if Assigned(SB) and (SB.Panels.Count >= 2) then
    if FModifie then
    begin
      SB.Panels[1].Text := 'Modifié';
      ScriptInfos.LastUpdate := Now;
    end
    else
      SB.Panels[1].Text := '';
end;

function TScriptListEdition.ScriptName(Index: Integer): AnsiString;
var
  info: TScriptEdition;
begin
  info := InfoScript(Index);
  if Assigned(info) then
    Result := info.ScriptName
  else
    Result := '';
end;

function TScriptListEdition.ScriptName(TabSheet: TTabSheet): AnsiString;
var
  info: TScriptEdition;
begin
  info := InfoScript(TabSheet);
  if Assigned(info) then
    Result := info.ScriptName
  else
    Result := '';
end;

function TScriptListEdition.ScriptName(Editor: TSynEdit): AnsiString;
var
  info: TScriptEdition;
begin
  info := InfoScript(Editor);
  if Assigned(info) then
    Result := info.ScriptName
  else
    Result := '';
end;

function TScriptListEdition.ScriptFileName(Index: Integer): string;
var
  info: TScriptEdition;
begin
  info := InfoScript(Index);
  if Assigned(info) then
    Result := info.FileName
  else
    Result := '';
end;

function TScriptListEdition.ScriptFileName(TabSheet: TTabSheet): string;
var
  info: TScriptEdition;
begin
  info := InfoScript(TabSheet);
  if Assigned(info) then
    Result := info.FileName
  else
    Result := '';
end;

function TScriptListEdition.ScriptFileName(Editor: TSynEdit): string;
var
  info: TScriptEdition;
begin
  info := InfoScript(Editor);
  if Assigned(info) then
    Result := info.FileName
  else
    Result := '';
end;

function TScriptListEdition.InfoScript(Index: Integer): TScriptEdition;
begin
  if (Index >= 0) and (Index <= Count - 1) then
    Result := TScriptEdition(Items[Index])
  else
    Result := nil;
end;

function TScriptListEdition.InfoScript(TabSheet: TTabSheet): TScriptEdition;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Pred(Count) do
    if TScriptEdition(Items[i]).TabSheet = TabSheet then
    begin
      Result := TScriptEdition(Items[i]);
      Exit;
    end;
end;

function TScriptListEdition.InfoScript(Editor: TSynEdit): TScriptEdition;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Pred(Count) do
    if TScriptEdition(Items[i]).Editor = Editor then
    begin
      Result := TScriptEdition(Items[i]);
      Exit;
    end;
end;

function TScriptListEdition.InfoScriptByScriptName(const Script: AnsiString): TScriptEdition;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Pred(Count) do
    if AnsiSameText(Items[i].ScriptName, Script) then
    begin
      Result := TScriptEdition(Items[i]);
      Exit;
    end;
end;

function TScriptListEdition.EditorByIndex(Index: Integer): TSynEdit;
var
  info: TScriptEdition;
begin
  info := InfoScript(Index);
  if Assigned(info) then
    Result := info.Editor
  else
    Result := nil;
end;

function TScriptListEdition.EditorByScriptName(const Script: AnsiString): TSynEdit;
var
  info: TScriptEdition;
begin
  info := InfoScriptByScriptName(Script);
  if Assigned(info) then
    Result := info.Editor
  else
    Result := nil;
end;

end.
