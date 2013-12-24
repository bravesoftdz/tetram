unit UScriptList;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Generics.Collections, JclSimpleXML, Divers, VCL.Dialogs, System.Types,
  System.AnsiStrings;

const
  ExtMainScript = '.bds';
  ExtUnit = '.bdu';

type
  TScriptKind = (skMain, skUnit);
  TScriptKinds = set of TScriptKind;

const
  AllScripts = [skMain, skUnit];

type
  TScriptEngine = (seNone, sePascalScript, seDWScript);

  TScriptInfos = class
    Auteur, Description: string;
    ScriptVersion, BDVersion: TVersionNumber;
    LastUpdate: TDateTime;
    Engine: TScriptEngine;
  end;

  TOption = class
  private
    FChooseValue: string;
    function GetChooseValue: string;
  public
    FLibelle: string;
    FValues, FDefaultValue: string;

    function IsValidValue(const Value: string): Boolean;
    property ChooseValue: string read GetChooseValue write FChooseValue;
  end;

  TScriptClass = class of TScript;

  TScript = class
  strict private
    FCode: TStringList;
    FOptions: TObjectList<TOption>;
    FFileName: string;
    FScriptUnitName: string;
    FScriptKind: TScriptKind;
    FLoaded: Boolean;
    FModifie: Boolean;
    procedure SetModifie(const Value: Boolean);
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
    function CheckOptionValue(const OptionName, Value: string): Boolean;
    function OptionValueIndex(const OptionName: string; default: Integer): Integer;
    procedure GetScriptLines(Lines: TStrings); virtual;

    property ScriptInfos: TScriptInfos read GetScriptInfos write FScriptInfos;
    property FileName: string read FFileName write SetFileName;
    property ScriptUnitName: string read FScriptUnitName;
    property ScriptKind: TScriptKind read FScriptKind;
    property Code: TStringList read FCode;
    property Options: TObjectList<TOption> read FOptions;
    property Loaded: Boolean read FLoaded write FLoaded;
    property Alias: TStringList read FAlias write SetAlias;

    property Modifie: Boolean read FModifie write SetModifie;
  end;

  TScriptList = class(TObjectList<TScript>)
  public
    constructor Create; reintroduce;
    procedure LoadDir(const Dir: string);

    function FindScriptByUnitName(const UnitName: string; ScriptKinds: TScriptKinds = AllScripts): TScript;
    function FindScriptByAlias(const AliasName: string; ScriptKinds: TScriptKinds = AllScripts): TScript;

    function InfoScriptByUnitName(const UnitName: string): TScript;
  end;

implementation

uses System.StrUtils, CommonConst, JclStreams, System.TypInfo, System.IOUtils, UNet;

function TScript.CheckOptionValue(const OptionName, Value: string): Boolean;
begin
  Result := SameText(OptionValue(OptionName, ''), Value);
end;

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
  FModifie := False;
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
  Lines.Clear;
  if not FLoaded then
    Load;

  with ScriptInfos do
    if ((BDVersion = '') or (BDVersion <= TGlobalVar.Utilisateur.ExeVersion)) then
      Lines.Assign(FCode)
    else
      ShowMessage('Le script "' + string(ScriptUnitName) + '" n''est pas compatible avec cette version de BDthèque.')
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
        FScriptInfos.Engine := TScriptEngine(GetEnumValue(TypeInfo(TScriptEngine), 'se' + Items.ItemNamed['Engine'].Value));
        if not(FScriptInfos.Engine in [Succ(seNone) .. High(TScriptEngine)]) then
          FScriptInfos.Engine := sePascalScript;

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
  sl: TStringList;
begin
  Option := OptionByName(OptionName);
  if Assigned(Option) then
  begin
    sl := TStringList.Create;
    try
      sl.Text := StringReplace(Option.FValues, '|', sLineBreak, [rfReplaceAll]);
      Result := sl.IndexOf(Option.FChooseValue);
    finally
      sl.Free;
    end;
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
        Items.Add('Engine').Value := Copy(GetEnumName(TypeInfo(TScriptEngine), Ord(ScriptInfos.Engine)), 3, MaxInt);

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
      Modifie := False;
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
  FScriptUnitName := TPath.GetFileNameWithoutExtension(FFileName);
  if SameText(TPath.GetExtension(FFileName), ExtMainScript) then
    FScriptKind := skMain
  else
    FScriptKind := skUnit;
end;

procedure TScript.SetModifie(const Value: Boolean);
begin
  FModifie := Value;
  if FModifie then
    ScriptInfos.LastUpdate := Now;
end;

constructor TScriptList.Create;
begin
  inherited Create(True);
end;

function TScriptList.FindScriptByUnitName(const UnitName: string; ScriptKinds: TScriptKinds): TScript;
begin
  for Result in Self do
    if (Result.ScriptKind in ScriptKinds) and SameText(Result.ScriptUnitName, UnitName) then
      Exit;
  Result := nil;
end;

function TScriptList.FindScriptByAlias(const AliasName: string; ScriptKinds: TScriptKinds): TScript;
begin
  for Result in Self do
    if (Result.ScriptKind in ScriptKinds) and (Result.Alias.IndexOf(string(AliasName)) <> -1) then
      Exit;
  Result := nil;

end;

function TScriptList.InfoScriptByUnitName(const UnitName: string): TScript;
begin
  Result := FindScriptByUnitName(UnitName, AllScripts);
end;

procedure TScriptList.LoadDir(const Dir: string);

  procedure GetFiles(const Path, Ext: string);
  var
    Script: TScript;
    FileName: string;
  begin
    for FileName in TDirectory.GetFiles(Path, '*' + Ext) do
    begin
      Script := TScript.Create;
      Script.FileName := FileName;
      Add(Script);
    end;
  end;

begin
  Clear;
  GetFiles(Dir, ExtMainScript);
  GetFiles(Dir, ExtUnit);
end;

{ TOption }

function TOption.GetChooseValue: string;
begin
  if IsValidValue(FChooseValue) then
    Result := FChooseValue
  else
    Result := FDefaultValue;
end;

function TOption.IsValidValue(const Value: string): Boolean;
begin
  Result := string('|' + FValues + '|').Contains('|' + Value + '|');
end;

end.
