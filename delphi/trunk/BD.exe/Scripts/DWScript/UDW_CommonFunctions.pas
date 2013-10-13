unit UDW_CommonFunctions;

interface

uses
  System.Classes, System.SysUtils, UDWUnit, Variants, StrUtils, dwsSymbols, dwsMagicExprs, dwsExprs, dwsFunctions, dwsExprList;

type
  TDW_CommonFunctionsUnit = class(TDW_Unit)
  private
    procedure GetPageEval(info: TProgramInfo);
    procedure GetPageWithHeadersEval(info: TProgramInfo);
    procedure PostPageEval(info: TProgramInfo);
    procedure PostPageWithHeadersEval(info: TProgramInfo);
    procedure AskSearchEntryEval(info: TProgramInfo);
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TShowMessageFunc = class(TInternalMagicProcedure)
    procedure DoEvalProc(const args: TExprBaseListExec); override;
  end;

  TStringReplaceFuncURL = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args: TExprBaseListExec; var Result: UnicodeString); override;
  end;

  TCombineURL = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args: TExprBaseListExec; var Result: UnicodeString); override;
  end;

  TGetPage = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args: TExprBaseListExec; var Result: UnicodeString); override;
  end;

  TGetPageWithHeaders = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args: TExprBaseListExec; var Result: UnicodeString); override;
  end;

  THTMLDecode = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args: TExprBaseListExec; var Result: UnicodeString); override;
  end;

  THTMLText = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args: TExprBaseListExec; var Result: UnicodeString); override;
  end;

implementation

uses
  dwsUnitSymbols, Dialogs, UScriptsFonctions, UScriptUtils, UNet,
  UScriptsHTMLFunctions, dwsUtils;

const // type constants
  cFloat = 'Float';
  cInteger = 'Integer';
  cString = 'String';
  cBoolean = 'Boolean';
  cVariant = 'Variant';

const
  rfReplaceAllVal = Ord(rfReplaceAll) + 1;
  rfIgnoreCaseVal = Ord(rfIgnoreCase) + 1;

procedure InitEnum(systemTable: TSystemSymbolTable; unitSyms: TUnitMainSymbols; unitTable: TSymbolTable);
var
  E: TTypeSymbol;
begin
  E := TEnumerationSymbol.Create('TReplaceFlags', systemTable.TypInteger, enumClassic);
  unitTable.AddSymbol(E);
  unitTable.AddSymbol(TElementSymbol.Create('rfReplaceAll', E, rfReplaceAllVal, False));
  unitTable.AddSymbol(TElementSymbol.Create('rfIgnoreCase', E, rfIgnoreCaseVal, False));
end;

{ TCombineURL }

procedure TCombineURL.DoEvalAsString(const args: TExprBaseListExec; var Result: UnicodeString);
begin
  Result := CombineURL(args.AsString[0], args.AsString[1]);
end;

{ TGetPage }

procedure TGetPage.DoEvalAsString(const args: TExprBaseListExec; var Result: UnicodeString);
begin
  Result := GetPage(args.AsString[0], args.AsBoolean[1]);
end;

{ TGetPageWithHeaders }

procedure TGetPageWithHeaders.DoEvalAsString(const args: TExprBaseListExec; var Result: UnicodeString);
begin
  Result := GetPageWithHeaders(args.AsString[0], args.AsBoolean[1]);
end;

{ THTMLText }

procedure THTMLText.DoEvalAsString(const args: TExprBaseListExec; var Result: UnicodeString);
begin
  Result := HTMLText(args.AsString[0]);
end;

{ THTMLDecode }

procedure THTMLDecode.DoEvalAsString(const args: TExprBaseListExec; var Result: UnicodeString);
begin
  Result := HTMLDecode(args.AsString[0]);
end;

{ TShowMessageFunc }

procedure TShowMessageFunc.DoEvalProc(const args: TExprBaseListExec);
begin
  ShowMessage(args.AsString[0]);
end;

{ TDW_CommonFunctionsUnit }

procedure TDW_CommonFunctionsUnit.AskSearchEntryEval(info: TProgramInfo);
var
  obj: IScriptObj;
  dyn: TScriptDynamicArray;

  search: string;
  index: Integer;
  a: array of string;
  i: Integer;
begin
  obj := IScriptObj(IUnknown(info.ParamAsVariant[0]));
  dyn := obj.ExternalObject as TScriptDynamicArray;

  search := info.ValueAsString['search'];
  index := info.ValueAsInteger['index'];

  SetLength(a, dyn.DataLength);
  for i := 0 to Pred(dyn.DataLength) do
    a[i] := VarToStr(dyn.AsVariant[i]);

  info.ResultAsBoolean := AskSearchEntry(a, search, index);
  info.ValueAsString['search'] := search;
  info.ValueAsInteger['index'] := index;
end;

constructor TDW_CommonFunctionsUnit.Create(AOwner: TComponent);
begin
  inherited;
  UnitName := 'BDCommon';

  with Records.Add do
  begin
    Name := 'RAttachement';
    with Members.Add do
    begin
      Name := 'Nom';
      DataType := 'String';
    end;
    with Members.Add do
    begin
      Name := 'Valeur';
      DataType := 'String';
    end;
    with Members.Add do
    begin
      Name := 'IsFichier';
      DataType := 'Boolean';
    end;
  end;

  with Functions.Add do
  begin
    Name := 'GetPage';
    ResultType := 'String';
    ConvertFuncParams(Parameters, ['url', cString, 'UTF8', cBoolean]);
    OnEval := GetPageEval;
  end;
  with Functions.Add do
  begin
    Name := 'GetPageWithHeaders';
    ResultType := 'String';
    ConvertFuncParams(Parameters, ['url', cString, 'UTF8', cBoolean]);
    OnEval := GetPageWithHeadersEval;
  end;
  with Arrays.Add do
  begin
    Name := 'ArrayOfAttachement';
    DataType := 'RAttachement';
    IsDynamic := True;
  end;
  with Functions.Add do
  begin
    Name := 'PostPage';
    ResultType := 'String';
    ConvertFuncParams(Parameters, ['url', cString, 'Pieces', 'ArrayOfAttachement', 'UTF8', cBoolean]);
    OnEval := PostPageEval;
  end;
  with Functions.Add do
  begin
    Name := 'PostPageWithHeaders';
    ResultType := 'String';
    ConvertFuncParams(Parameters, ['url', cString, 'Pieces', 'ArrayOfAttachement', 'UTF8', cBoolean]);
    OnEval := PostPageWithHeadersEval;
  end;
  with Functions.Add do
  begin
    Name := 'AskSearchEntry';
    ResultType := 'Boolean';
    ConvertFuncParams(Parameters, ['Labels', 'array of string', '@Search', 'string', '@Index', 'Integer']);
    OnEval := AskSearchEntryEval;
  end;
end;

procedure TDW_CommonFunctionsUnit.GetPageEval(info: TProgramInfo);
begin
  info.ResultAsString := GetPage(info.ParamAsString[0], info.ParamAsBoolean[1]);
end;

procedure TDW_CommonFunctionsUnit.GetPageWithHeadersEval(info: TProgramInfo);
begin
  info.ResultAsString := GetPageWithHeaders(info.ParamAsString[0], info.ParamAsBoolean[1]);
end;

procedure TDW_CommonFunctionsUnit.PostPageEval(info: TProgramInfo);
const
  nbFields = 3;
var
  obj: IScriptObj;
  dyn: TScriptDynamicArray;
  a: array of RAttachement;
  i: Integer;
begin
  obj := IScriptObj(IUnknown(info.ParamAsVariant[1]));
  dyn := obj.ExternalObject as TScriptDynamicArray;
  SetLength(a, dyn.DataLength div nbFields);
  for i := 0 to Pred(dyn.DataLength div nbFields) do
  begin
    a[i].Nom := dyn.AsString[i * nbFields];
    a[i].Valeur := dyn.AsString[i * nbFields + 1];
    a[i].IsFichier := dyn.AsBoolean[i * nbFields + 2];
  end;
  info.ResultAsString := PostPage(info.ParamAsString[0], a, info.ParamAsBoolean[2]);
end;

procedure TDW_CommonFunctionsUnit.PostPageWithHeadersEval(info: TProgramInfo);
const
  nbFields = 3;
var
  obj: IScriptObj;
  dyn: TScriptDynamicArray;
  a: array of RAttachement;
  i: Integer;
begin
  obj := IScriptObj(IUnknown(info.ParamAsVariant[1]));
  dyn := obj.ExternalObject as TScriptDynamicArray;
  SetLength(a, dyn.DataLength div nbFields);
  for i := 0 to Pred(dyn.DataLength div nbFields) do
  begin
    a[i].Nom := dyn.AsString[i * nbFields];
    a[i].Valeur := dyn.AsString[i * nbFields + 1];
    a[i].IsFichier := dyn.AsBoolean[i * nbFields + 2];
  end;
  info.ResultAsString := PostPageWithHeaders(info.ParamAsString[0], a, info.ParamAsBoolean[2]);
end;

{ TStringReplaceFuncURL }

procedure TStringReplaceFuncURL.DoEvalAsString(const args: TExprBaseListExec; var Result: UnicodeString);
var
  v: TReplaceFlags;
begin
  v := [];
  if (args.AsInteger[3] and rfReplaceAllVal) = rfReplaceAllVal then
    Include(v, rfReplaceAll);
  if (args.AsInteger[3] and rfIgnoreCaseVal) = rfIgnoreCaseVal then
    Include(v, rfIgnoreCase);
  Result := StringReplace(args.AsString[0], args.AsString[1], args.AsString[2], v);
end;

initialization

RegisterInternalSymbolsProc(InitEnum);

(*
  PSScriptDebugger1.AddMethod(Self, @TdmPascalScript.WriteToConsole, 'procedure WriteToConsole(const Chaine: string);');
  PSScriptDebugger1.AddMethod(Self, @TdmPascalScript.WriteToFile, 'procedure WriteToFile(const Chaine, FileName: string);');
*)

(*
  PSScriptDebugger1.AddFunction(@findInfo, 'function findInfo(const sDebut, sFin, sChaine, sDefault: string): string;');
*)
RegisterInternalStringFunction(TCombineURL, 'CombineURL', ['Root', cString, 'URL', cString], [iffStateLess]);
RegisterInternalStringFunction(THTMLDecode, 'HTMLDecode', ['Chaine', cString], [iffStateLess]);
RegisterInternalStringFunction(THTMLText, 'HTMLText', ['Chaine', cString], [iffStateLess]);

(*
  PSScriptDebugger1.AddFunction(@ScriptChangeFileExt, 'function ChangeFileExt(const URL, Extension: string): string;');
  PSScriptDebugger1.AddFunction(@ScriptChangeFilePath, 'function ChangeFilePath(const URL, Path: string): string;');
  PSScriptDebugger1.AddFunction(@ScriptExtractFilePath, 'function ExtractFilePath(const URL: string): string;');
  PSScriptDebugger1.AddFunction(@ScriptExtractFileDir, 'function ExtractFileDir(const URL: string): string;');
  PSScriptDebugger1.AddFunction(@ScriptExtractFileName, 'function ExtractFileName(const URL: string): string;');
  PSScriptDebugger1.AddFunction(@ScriptExtractFileExt, 'function ExtractFileExt(const URL: string): string;');
  PSScriptDebugger1.AddFunction(@ScriptIncludeTrailingPathDelimiter, 'function IncludeTrailingPathDelimiter(const URL: string): string;');
  PSScriptDebugger1.AddFunction(@ScriptExcludeTrailingPathDelimiter, 'function ExcludeTrailingPathDelimiter(const URL: string): string;');

  PSScriptDebugger1.AddFunction(@System.SysUtils.Format, 'function Format(const Format: string; const Args: array of const): string;');

  PSScriptDebugger1.AddFunction(@System.SysUtils.SameText, 'function SameText(const S1, S2: string): Boolean;');
  PSScriptDebugger1.AddFunction(@StrUtils.PosEx, 'function PosEx(const SubStr, S: string; Offset: Cardinal): Integer;');
*)

RegisterInternalProcedure(TShowMessageFunc, 'ShowMessage', ['Msg', 'string']);
RegisterInternalStringFunction(TStringReplaceFuncURL, 'StringReplace', ['S', 'string', 'OldPattern', 'string', 'NewPattern', 'string', 'Flags', 'TReplaceFlags']);

(*
  PSScriptDebugger1.AddFunction(@ScriptStrToFloatDef, 'function StrToFloatDef(const S: string; const Default: Extended): Extended;');
*)

end.

