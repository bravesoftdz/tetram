unit UScriptList;

interface

uses Windows, AnsiStrings, SysUtils, Classes, Generics.Collections, JclSimpleXML, Divers, Dialogs;

const
  ExtMainScript = '.bds';
  ExtUnit = '.bdu';

type
  TScriptKind = (skMain, skUnit);
  TScriptKinds = set of TScriptKind;

  TScriptInfos = class
    Auteur, Description: string;
    ScriptVersion, BDVersion: TVersionNumber;
    LastUpdate: TDateTime;
  end;

  TOption = class
    FLibelle: string;
    FValues, FDefaultValue: string;
    FChooseValue: string;
  end;

  TScriptClass = class of TScript;

  TScript = class
  strict private
    FCode: TStringList;
    FOptions: TObjectList<TOption>;
    FFileName: string;
    FScriptName: AnsiString;
    FScriptKind: TScriptKind;
    FLoaded: Boolean;
  private
    FAlias: TStringList;
    FScriptInfos: TScriptInfos;
    procedure SetAlias(const Value: TStringList);
    function GetScriptInfos: TScriptInfos;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure SetFileName(const Value: string); virtual;

    procedure Load;
    procedure SaveToFile(const aFileName: string); virtual;
    procedure Save;
    function OptionByName(const OptionName: string): TOption;
    function OptionValue(const OptionName, default: string): string;
    function OptionValueIndex(const OptionName: string; default: Integer): Integer;
    procedure GetScriptLines(Lines: TStrings); virtual;

    property ScriptInfos: TScriptInfos read GetScriptInfos write FScriptInfos;
    property FileName: string read FFileName write SetFileName;
    property ScriptName: AnsiString read FScriptName;
    property ScriptKind: TScriptKind read FScriptKind;
    property Code: TStringList read FCode;
    property Options: TObjectList<TOption>read FOptions;
    property Loaded: Boolean read FLoaded write FLoaded;
    property Alias: TStringList read FAlias write SetAlias;
  end;

  TScriptList = class(TObjectList<TScript>)
  private
    FScriptClass: TScriptClass;
  public
    constructor Create(ScriptClass: TScriptClass); reintroduce;
    procedure LoadDir(const Dir: string);
    function FindScript(const ScriptName: AnsiString; ScriptKinds: TScriptKinds = [skUnit]): TScript;
    function FindScriptAlias(const AliasName: AnsiString; ScriptKinds: TScriptKinds = [skUnit]): TScript;
    function GetScriptLines(const ScriptName: AnsiString; Output: TStrings; ScriptKinds: TScriptKinds = [skUnit]): Boolean; virtual;
  end;

implementation

uses StrUtils, CommonConst, UScriptsFonctions, JclStreams;

constructor TScript.Create;
begin
  inherited;
  FScriptInfos := TScriptInfos.Create;
  FCode := TStringList.Create;
  FOptions := TObjectList<TOption>.Create(True);
  FFileName := '';
  FAlias := TStringList.Create;
  FAlias.Sorted := True;
  FAlias.Duplicates := dupIgnore;
  FAlias.CaseSensitive := False;
  FLoaded := False;
end;

destructor TScript.Destroy;
begin
  FCode.Free;
  FOptions.Free;
  FAlias.Free;
  FScriptInfos.Free;
  inherited;
end;

function TScript.GetScriptInfos: TScriptInfos;
begin
  if not FLoaded then
    Load;
  Result := FScriptInfos;
end;

procedure TScript.GetScriptLines(Lines: TStrings);
begin
  if not FLoaded then
    Load;
  Lines.Assign(FCode);
end;

procedure TScript.Load;
var
  i: Integer;
  s: string;
  Option: TOption;
begin
  with TJclSimpleXML.Create do
    try
      LoadFromFile(FFileName);
      Options := Options + [sxoAutoCreate];

      with Root.Items.ItemNamed['Infos'] do
      begin
        FScriptInfos.Auteur := Items.ItemNamed['Auteur'].Value;
        FScriptInfos.Description := Items.ItemNamed['Description'].Value;
        FScriptInfos.ScriptVersion := Items.ItemNamed['ScriptVersion'].Value;
        FScriptInfos.BDVersion := Items.ItemNamed['BDVersion'].Value;
        FScriptInfos.LastUpdate := RFC822ToDateTimeDef(Items.ItemNamed['LastUpdate'].Value, 0);

        FAlias.Clear;
        for i := 0 to Pred(Items.Count) do
          if SameText(Items[i].name, 'Alias') then
          begin
            s := trim(Items[i].Properties.Value('aka'));
            if s <> '' then
              FAlias.Add(s);
          end;
      end;

      FOptions.Clear;
      with Root.Items.ItemNamed['Options'] do
        for i := 0 to Pred(Items.Count) do
          if SameText(Items[i].name, 'Option') then
          begin
            Option := TOption.Create;
            FOptions.Add(Option);
            Option.FLibelle := Items[i].Properties.Value('Label');
            Option.FValues := Items[i].Properties.Value('Values');
            Option.FDefaultValue := Items[i].Properties.Value('Default');
            Option.FChooseValue := Option.FDefaultValue;
          end;

      FCode.Text := Root.Items.ItemNamed['Code'].Value;
    finally
      Free;
    end;

  FLoaded := True;
end;

function TScript.OptionByName(const OptionName: string): TOption;
begin
  for Result in FOptions do
    if SameText(Result.FLibelle, OptionName) then
      Exit;
  Result := nil;
end;

function TScript.OptionValue(const OptionName, default: string): string;
var
  Option: TOption;
begin
  Option := OptionByName(OptionName);
  if Assigned(Option) then
    Result := Option.FChooseValue
  else
    Result := default;
end;

function TScript.OptionValueIndex(const OptionName: string; default: Integer): Integer;
var
  Option: TOption;
begin
  Option := OptionByName(OptionName);
  if Assigned(Option) then
    with TStringList.Create do
      try
        Text := StringReplace(Option.FValues, '|', sLineBreak, [rfReplaceAll]);
        Result := IndexOf(Option.FChooseValue);
      finally
        Free;
      end
    else
      Result := default;
end;

procedure TScript.Save;
begin
  SaveToFile(FFileName);
end;

procedure TScript.SaveToFile(const aFileName: string);
var
  s: string;
  i: Integer;
  Option: TOption;
begin
  with TJclSimpleXML.Create do
    try
      Options := Options + [sxoAutoCreate];
      Root.name := 'Script';

      with Root.Items.ItemNamed['Infos'] do
      begin
        Clear;
        Items.Add('Auteur').Value := ScriptInfos.Auteur;
        Items.Add('Description').Value := ScriptInfos.Description;
        Items.Add('ScriptVersion').Value := ScriptInfos.ScriptVersion;
        Items.Add('BDVersion').Value := ScriptInfos.BDVersion;
        if ScriptInfos.LastUpdate > 0 then
          Items.Add('LastUpdate').Value := DateTimeToRFC822(ScriptInfos.LastUpdate);

        for i := 0 to Pred(FAlias.Count) do
          Items.Add('Alias').Properties.Add('aka', FAlias[i]);
      end;

      with Root.Items.ItemNamed['Options'] do
      begin
        Clear;
        for Option in FOptions do
          with Items.Add('Option') do
          begin
            Properties.ItemNamed['Label'].Value := Option.FLibelle;
            Properties.ItemNamed['Values'].Value := Option.FValues;
            Properties.ItemNamed['Default'].Value := Option.FDefaultValue;
          end;
      end;

      s := FCode.Text;
      while EndsText(sLineBreak, s) do
        Delete(s, Length(s) - Length(sLineBreak) + 1, Length(sLineBreak));
      Root.Items.ItemNamed['Code'].Value := s;

      SaveToFile(aFileName, seUTF8);
    finally
      Free;
    end;
end;

procedure TScript.SetAlias(const Value: TStringList);
begin
  FAlias.Assign(Value);
end;

procedure TScript.SetFileName(const Value: string);
begin
  FFileName := Value;
  FScriptName := AnsiString(ChangeFileExt(ExtractFileName(FFileName), ''));
  if SameText(ExtractFileExt(FFileName), ExtMainScript) then
    FScriptKind := skMain
  else
    FScriptKind := skUnit;
end;

constructor TScriptList.Create(ScriptClass: TScriptClass);
begin
  inherited Create(True);
  FScriptClass := ScriptClass;
end;

function TScriptList.FindScript(const ScriptName: AnsiString; ScriptKinds: TScriptKinds = [skUnit]): TScript;
begin
  for Result in Self do
    if (Result.ScriptKind in ScriptKinds) and AnsiStrings.SameText(Result.ScriptName, ScriptName) then
      Exit;
  Result := nil;
end;

function TScriptList.FindScriptAlias(const AliasName: AnsiString; ScriptKinds: TScriptKinds): TScript;
begin
  for Result in Self do
    if (Result.ScriptKind in ScriptKinds) and (Result.Alias.IndexOf(string(AliasName)) <> -1) then
      Exit;
  Result := nil;

end;

function TScriptList.GetScriptLines(const ScriptName: AnsiString; Output: TStrings; ScriptKinds: TScriptKinds = [skUnit]): Boolean;
var
  Script: TScript;
begin
  Result := False;
  Output.Clear;
  Script := FindScript(ScriptName, ScriptKinds);
  if Assigned(Script) then
  begin
    with Script.ScriptInfos do
      if ((BDVersion = '') or (BDVersion <= TGlobalVar.Utilisateur.ExeVersion)) then
      begin
        Script.GetScriptLines(Output);
        Result := True;
      end
      else
        ShowMessage('Le script "' + string(Script.ScriptName) + '" n''est pas compatible avec cette version de BDthèque.');
  end;
end;

procedure TScriptList.LoadDir(const Dir: string);

  procedure GetFiles(const Path, Ext: string);
  var
    i: Integer;
    sr: TSearchRec;
    Script: TScript;
  begin
    i := FindFirst(Path + '*' + Ext, faAnyFile, sr);
    if i = 0 then
      try
        while i = 0 do
        begin
          if (sr.Attr and faDirectory) = 0 then
          begin
            Script := FScriptClass.Create;
            Script.FileName := Path + sr.name;
            Add(Script);
          end;
          i := FindNext(sr);
        end;
      finally
        FindClose(sr);
      end;
  end;

var
  Path: string;
begin
  Path := IncludeTrailingPathDelimiter(Dir);
  Clear;
  GetFiles(Path, ExtMainScript);
  GetFiles(Path, ExtUnit);
end;

end.
