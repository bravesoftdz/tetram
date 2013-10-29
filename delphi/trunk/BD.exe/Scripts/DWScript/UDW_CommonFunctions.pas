unit UDW_CommonFunctions;

interface

uses
  System.Classes, System.SysUtils, UDWUnit, Variants, StrUtils, dwsSymbols, dwsMagicExprs, dwsExprs, dwsFunctions, dwsExprList, UScriptEngineIntf;

type
  TDW_CommonFunctionsUnit = class(TDW_Unit)
  private
    procedure GetPageEval(info: TProgramInfo);
    procedure GetPageWithHeadersEval(info: TProgramInfo);
    procedure PostPageEval(info: TProgramInfo);
    procedure PostPageWithHeadersEval(info: TProgramInfo);
    procedure AskSearchEntryEval(info: TProgramInfo);

    procedure StringReplaceEval(info: TProgramInfo);
    procedure CombineURLEval(info: TProgramInfo);
    procedure HTMLDecodeEval(info: TProgramInfo);
    procedure HTMLTextEval(info: TProgramInfo);
    procedure ChangeFileExtEval(info: TProgramInfo);
    procedure ChangeFilePathEval(info: TProgramInfo);
    procedure ExtractFilePathEval(info: TProgramInfo);
    procedure ExtractFileDirEval(info: TProgramInfo);
    procedure ExtractFileNameEval(info: TProgramInfo);
    procedure ExtractFileExtEval(info: TProgramInfo);
    procedure IncludeTrailingPathDelimiterEval(info: TProgramInfo);
    procedure ExcludeTrailingPathDelimiterEval(info: TProgramInfo);
    procedure ShowMessageEval(info: TProgramInfo);
    procedure WriteToFileEval(info: TProgramInfo);
    procedure WriteToConsoleEval(info: TProgramInfo);
    procedure findInfoEval(info: TProgramInfo);
  public
    constructor Create(MasterEngine: IMasterEngine); override;
  end;

implementation

uses
  dwsUnitSymbols, Dialogs, UScriptsFonctions, UScriptUtils, UNet, UScriptsHTMLFunctions, dwsUtils;

const // type constants
  cFloat = 'Float';
  cInteger = 'Integer';
  cString = 'String';
  cBoolean = 'Boolean';
  cVariant = 'Variant';

const
  rfReplaceAllVal = Ord(rfReplaceAll) + 1;
  rfIgnoreCaseVal = Ord(rfIgnoreCase) + 1;

  { TDW_CommonFunctionsUnit }

procedure TDW_CommonFunctionsUnit.AskSearchEntryEval(info: TProgramInfo);
var
  obj: IScriptObj;
  search: string;
  index: Integer;
  a: array of string;
  i: Integer;
begin
  search := info.ValueAsString['search'];
  index := info.ValueAsInteger['index'];

  obj := info.Params[0].ScriptObj;
  SetLength(a, obj.DataLength);
  for i := 0 to Pred(obj.DataLength) do
    a[i] := VarToStr(obj.AsVariant[i]);

  info.ResultAsBoolean := AskSearchEntry(a, search, index);
  info.ValueAsString['search'] := search;
  info.ValueAsInteger['index'] := index;
end;

procedure TDW_CommonFunctionsUnit.ChangeFileExtEval(info: TProgramInfo);
begin
  info.ResultAsString := ScriptChangeFileExt(info.ParamAsString[0], info.ParamAsString[1]);
end;

procedure TDW_CommonFunctionsUnit.ChangeFilePathEval(info: TProgramInfo);
begin
  info.ResultAsString := ScriptChangeFilePath(info.ParamAsString[0], info.ParamAsString[1]);
end;

procedure TDW_CommonFunctionsUnit.CombineURLEval(info: TProgramInfo);
begin
  info.ResultAsString := CombineURL(info.ParamAsString[0], info.ParamAsString[1]);
end;

constructor TDW_CommonFunctionsUnit.Create(MasterEngine: IMasterEngine);
begin
  inherited;
  UnitName := 'BDCommon';

  with Enumerations.Add do
  begin
    Name := 'TReplaceFlags';
    Style := enumClassic;
    with Elements.Add do
    begin
      Name := 'rfReplaceAll';
      UserDefValue := rfReplaceAllVal;
    end;
    with Elements.Add do
    begin
      Name := 'rfIgnoreCase';
      UserDefValue := rfIgnoreCaseVal;
    end;
  end;

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

  with Arrays.Add do
  begin
    Name := 'ArrayOfAttachement';
    DataType := 'RAttachement';
    IsDynamic := True;
  end;

  RegisterFunction('GetPage', cString, ['url', cString, 'UTF8', cBoolean], GetPageEval);
  RegisterFunction('GetPageWithHeaders', cString, ['url', cString, 'UTF8', cBoolean], GetPageWithHeadersEval);
  RegisterFunction('PostPage', cString, ['url', cString, 'Pieces', 'ArrayOfAttachement', 'UTF8', cBoolean], PostPageEval);
  RegisterFunction('PostPageWithHeaders', cString, ['url', cString, 'Pieces', 'ArrayOfAttachement', 'UTF8', cBoolean], PostPageWithHeadersEval);
  RegisterFunction('AskSearchEntry', cBoolean, ['Labels', 'array of string', '@Search', 'string', '@Index', 'Integer'], AskSearchEntryEval);

  RegisterProcedure('WriteToConsole', ['Chaine', cString], WriteToConsoleEval);
  RegisterProcedure('WriteToFile', ['Chaine', cString, 'FileName', cString], WriteToFileEval);

  RegisterFunction('findInfo', cString, ['sDebut', cString, 'sFin', cString, 'sChaine', cString, 'sDefault', cString], findInfoEval);

  RegisterFunction('CombineURL', cString, ['Root', cString, 'URL', cString], CombineURLEval);
  RegisterFunction('HTMLDecode', cString, ['Chaine', cString], HTMLDecodeEval);
  RegisterFunction('HTMLText', cString, ['Chaine', cString], HTMLTextEval);

  RegisterFunction('ChangeFileExt', cString, ['URL', cString, 'Extension', cString], ChangeFileExtEval);
  RegisterFunction('ChangeFilePath', cString, ['URL', cString, 'Path', cString], ChangeFilePathEval);
  RegisterFunction('ExtractFilePath', cString, ['URL', cString], ExtractFilePathEval);
  RegisterFunction('ExtractFileDir', cString, ['URL', cString], ExtractFileDirEval);
  RegisterFunction('ExtractFileName', cString, ['URL', cString], ExtractFileNameEval);
  RegisterFunction('ExtractFileExt', cString, ['URL', cString], ExtractFileExtEval);
  RegisterFunction('IncludeTrailingPathDelimiter', cString, ['URL', cString], IncludeTrailingPathDelimiterEval);
  RegisterFunction('ExcludeTrailingPathDelimiter', cString, ['URL', cString], ExcludeTrailingPathDelimiterEval);

  RegisterProcedure('ShowMessage', ['Msg', cString], ShowMessageEval);
  RegisterFunction('StringReplace', cString, ['S', cString, 'OldPattern', cString, 'NewPattern', cString, 'Flags', 'TReplaceFlags'], StringReplaceEval);
end;

procedure TDW_CommonFunctionsUnit.ExcludeTrailingPathDelimiterEval(info: TProgramInfo);
begin
  info.ResultAsString := ScriptExcludeTrailingPathDelimiter(info.ParamAsString[0]);
end;

procedure TDW_CommonFunctionsUnit.ExtractFileDirEval(info: TProgramInfo);
begin
  info.ResultAsString := ScriptExtractFileDir(info.ParamAsString[0]);
end;

procedure TDW_CommonFunctionsUnit.ExtractFileExtEval(info: TProgramInfo);
begin
  info.ResultAsString := ScriptExtractFileExt(info.ParamAsString[0]);
end;

procedure TDW_CommonFunctionsUnit.ExtractFileNameEval(info: TProgramInfo);
begin
  info.ResultAsString := ScriptExtractFileName(info.ParamAsString[0]);
end;

procedure TDW_CommonFunctionsUnit.ExtractFilePathEval(info: TProgramInfo);
begin
  info.ResultAsString := ScriptExtractFilePath(info.ParamAsString[0]);
end;

procedure TDW_CommonFunctionsUnit.findInfoEval(info: TProgramInfo);
begin
  info.ResultAsString := findInfo(info.ParamAsString[0], info.ParamAsString[1], info.ParamAsString[2], info.ParamAsString[3]);
end;

procedure TDW_CommonFunctionsUnit.GetPageEval(info: TProgramInfo);
begin
  info.ResultAsString := GetPage(info.ParamAsString[0], info.ParamAsBoolean[1]);
end;

procedure TDW_CommonFunctionsUnit.GetPageWithHeadersEval(info: TProgramInfo);
begin
  info.ResultAsString := GetPageWithHeaders(info.ParamAsString[0], info.ParamAsBoolean[1]);
end;

procedure TDW_CommonFunctionsUnit.HTMLDecodeEval(info: TProgramInfo);
begin
  info.ResultAsString := HTMLDecode(info.ParamAsString[0]);
end;

procedure TDW_CommonFunctionsUnit.HTMLTextEval(info: TProgramInfo);
begin
  info.ResultAsString := HTMLText(info.ParamAsString[0]);
end;

procedure TDW_CommonFunctionsUnit.IncludeTrailingPathDelimiterEval(info: TProgramInfo);
begin
  info.ResultAsString := ScriptIncludeTrailingPathDelimiter(info.ParamAsString[0]);
end;

procedure TDW_CommonFunctionsUnit.PostPageEval(info: TProgramInfo);
const
  nbFields = 3;
var
  obj: IScriptObj;
  a: array of RAttachement;
  i: Integer;
begin
  obj := info.Params[1].ScriptObj;
  SetLength(a, obj.DataLength div nbFields);
  for i := 0 to Pred(obj.DataLength div nbFields) do
  begin
    a[i].Nom := obj.AsString[i * nbFields];
    a[i].Valeur := obj.AsString[i * nbFields + 1];
    a[i].IsFichier := obj.AsBoolean[i * nbFields + 2];
  end;
  info.ResultAsString := PostPage(info.ParamAsString[0], a, info.ParamAsBoolean[2]);
end;

procedure TDW_CommonFunctionsUnit.PostPageWithHeadersEval(info: TProgramInfo);
const
  nbFields = 3;
var
  obj: IScriptObj;
  a: array of RAttachement;
  i: Integer;
begin
  obj := info.Params[1].ScriptObj;
  SetLength(a, obj.DataLength div nbFields);
  for i := 0 to Pred(obj.DataLength div nbFields) do
  begin
    a[i].Nom := obj.AsString[i * nbFields];
    a[i].Valeur := obj.AsString[i * nbFields + 1];
    a[i].IsFichier := obj.AsBoolean[i * nbFields + 2];
  end;
  info.ResultAsString := PostPageWithHeaders(info.ParamAsString[0], a, info.ParamAsBoolean[2]);
end;

procedure TDW_CommonFunctionsUnit.ShowMessageEval(info: TProgramInfo);
begin
  ShowMessage(info.ParamAsString[0]);
end;

procedure TDW_CommonFunctionsUnit.StringReplaceEval(info: TProgramInfo);
var
  v: TReplaceFlags;
begin
  v := [];
  if (info.ParamAsInteger[3] and rfReplaceAllVal) = rfReplaceAllVal then
    Include(v, rfReplaceAll);
  if (info.ParamAsInteger[3] and rfIgnoreCaseVal) = rfIgnoreCaseVal then
    Include(v, rfIgnoreCase);
  info.ResultAsString := StringReplace(info.ParamAsString[0], info.ParamAsString[1], info.ParamAsString[2], v);
end;

procedure TDW_CommonFunctionsUnit.WriteToConsoleEval(info: TProgramInfo);
begin
  MasterEngine.WriteToConsole(info.ParamAsString[0]);
end;

procedure TDW_CommonFunctionsUnit.WriteToFileEval(info: TProgramInfo);
var
  Buffer, Preamble: TBytes;
  fs: TFileStream;
  FileName, Chaine: string;
begin
  Chaine := info.ParamAsString[0];
  FileName := info.ParamAsString[1];

  Buffer := TEncoding.default.GetBytes(Chaine);
  Preamble := TEncoding.default.GetPreamble;

  if FileExists(FileName) then
    fs := TFileStream.Create(FileName, fmOpenWrite)
  else
    fs := TFileStream.Create(FileName, fmCreate or fmOpenWrite);
  try
    fs.Size := 0;

    if Length(Preamble) > 0 then
      fs.WriteBuffer(Preamble[0], Length(Preamble));
    fs.WriteBuffer(Buffer[0], Length(Buffer));
  finally
    fs.Free;
  end;
end;

end.
