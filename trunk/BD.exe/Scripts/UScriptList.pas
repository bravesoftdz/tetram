unit UScriptList;

interface

uses
  AnsiStrings, SysUtils, Classes, Generics.Collections, JclSimpleXML;

const
  ExtMainScript = '.bds';
  ExtUnit = '.bdu';

type
  TScriptKind = (skMain, skUnit);
  TScriptKinds = set of TScriptKind;

  TOption = class
    FLibelle: string;
    FValues, FDefaultValue: string;
    FChooseValue: string;
  end;

  TScriptClass = class of TScript;

  TScript = class
  private
    FCode: TStringList;
    FOptions: TObjectList<TOption>;
    FFileName: string;
    FScriptName: AnsiString;
    FScriptKing: TScriptKind;
    FLoaded: Boolean;
    procedure SetFileName(const Value: String);
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Load;
    procedure SaveToFile(const aFileName: string); virtual;
    procedure Save;
    function OptionByName(const OptionName: string): TOption;
    function OptionValue(const OptionName, Default: string): string;
    function OptionValueIndex(const OptionName: string; Default: Integer): Integer;
    procedure GetScriptLines(Lines: TStrings); virtual;

    property FileName: string read FFileName write SetFileName;
    property ScriptName: AnsiString read FScriptName;
    property ScriptKing: TScriptKind read FScriptKing;
    property Code: TStringList read FCode;
    property Options: TObjectList<TOption> read FOptions;
    property Loaded: Boolean read FLoaded;
  end;

  TScriptList = class(TObjectList<TScript>)
  private
    FScriptClass: TScriptClass;
  public
    constructor Create(ScriptClass: TScriptClass); reintroduce;
    procedure LoadDir(const Dir: string);
    function FindScript(const ScriptName: AnsiString; ScriptKinds: TScriptKinds = [skUnit]): TScript;
    function GetScriptLines(const ScriptName: AnsiString; Output: TStrings; ScriptKinds: TScriptKinds = [skUnit]): Boolean; virtual;
  end;

implementation

uses
  StrUtils;

constructor TScript.Create;
begin
  FCode := TStringList.Create;
  FOptions := TObjectList<TOption>.Create(True);
  FFileName := '';
  FLoaded := False;
end;

destructor TScript.Destroy;
begin
  FCode.Free;
  FOptions.Free;
  inherited;
end;

procedure TScript.GetScriptLines(Lines: TStrings);
begin
  if not FLoaded then Load;
  Lines.Assign(FCode);
end;

procedure TScript.Load;
var
  i: Integer;
  f: TFileStream;
  Option: TOption;
begin
  f := TFileStream.Create(FFileName, fmOpenRead or fmShareDenyWrite);
  try
    case FScriptKing of
      skMain:
        with TJclSimpleXML.Create do
          try
            LoadFromStream(f);
            Options := Options + [sxoAutoCreate];

            FOptions.Clear;
            with Root.Items.ItemNamed['Options'] do
              for i := 0 to Pred(Items.Count) do
                if SameText(Items[i].Name, 'Option') then
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
      skUnit:
        FCode.LoadFromStream(f);
    end;

    FLoaded := True;
  finally
    f.Free;
  end;
end;

function TScript.OptionByName(const OptionName: string): TOption;
var
  i: Integer;
begin
  for i := 0 to Pred(FOptions.Count) do
  begin
    Result := FOptions[i];
    if SameText(Result.FLibelle, OptionName) then
      Exit;
  end;
  Result := nil;
end;

function TScript.OptionValue(const OptionName, Default: string): string;
var
  Option: TOption;
begin
  Option := OptionByName(OptionName);
  if Assigned(Option) then
    Result := Option.FChooseValue
  else
    Result := Default;
end;

function TScript.OptionValueIndex(const OptionName: string; Default: Integer): Integer;
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
    Result := Default;
end;

procedure TScript.Save;
begin
  SaveToFile(FFileName);
end;

procedure TScript.SaveToFile(const aFileName: string);
var
  s: string;
  i: Integer;
begin
  case FScriptKing of
    skMain:
      with TJclSimpleXML.Create do
        try
          Options := Options + [sxoAutoCreate];
          Root.Name := 'Script';

          with Root.Items.ItemNamed['Options'] do
          begin
            Clear;
            for i := 0 to Pred(FOptions.Count) do
              with Items.Add('Option') do
              begin
                Properties.ItemNamed['Label'].Value := FOptions[i].FLibelle;
                Properties.ItemNamed['Values'].Value := FOptions[i].FValues;
                Properties.ItemNamed['Default'].Value := FOptions[i].FDefaultValue;
              end;
          end;

          s := FCode.Text;
          while EndsText(sLineBreak, s) do
            Delete(s, Length(s) - Length(sLineBreak) + 1, Length(sLineBreak));
          Root.Items.ItemNamed['Code'].Value := s;

          SaveToFile(aFileName);
        finally
          Free;
        end;
    skUnit:
      FCode.SaveToFile(FileName);
  end;
end;

procedure TScript.SetFileName(const Value: string);
begin
  FFileName := Value;
  FScriptName := AnsiString(ChangeFileExt(ExtractFileName(FFileName), ''));
  if SameText(ExtractFileExt(FFileName), ExtMainScript) then
    FScriptKing := skMain
  else
    FScriptKing := skUnit;
end;

constructor TScriptList.Create(ScriptClass: TScriptClass);
begin
  inherited Create(True);
  FScriptClass := ScriptClass;
end;

function TScriptList.FindScript(const ScriptName: AnsiString; ScriptKinds: TScriptKinds = [skUnit]): TScript;
var
  i: Integer;
begin
  for i := 0 to Pred(Count) do
  begin
    Result := Items[i];
    if (Result.ScriptKing in ScriptKinds) and AnsiStrings.SameText(Result.ScriptName, ScriptName) then
      Exit;
  end;
  Result := nil;
end;

function TScriptList.GetScriptLines(const ScriptName: AnsiString; Output: TStrings; ScriptKinds: TScriptKinds = [skUnit]): Boolean;
var
  Script: TScript;
begin
  Output.Clear;
  Script := FindScript(ScriptName, ScriptKinds);
  Result := Assigned(Script);
  if Result then
    Script.GetScriptLines(Output);
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
            Script.FileName := Path + sr.Name;
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
