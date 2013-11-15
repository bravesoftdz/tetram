unit UDW_BdtkRegEx;

interface

uses
  UDWUnit, System.Classes, dwsComp, dwsExprs, dwsSymbols, UScriptEngineIntf;

type
  TDW_BdtkRegExUnit = class(TDW_Unit)
  private
    procedure MatchRegExEval(info: TProgramInfo);
    procedure ExtractRegExEval(info: TProgramInfo);
    procedure ExtractRegExGroupEval(info: TProgramInfo);
  public
    constructor Create(const MasterEngine: IMasterEngine); override;
  published
    procedure OnTBdtkRegEx_CreateEval(info: TProgramInfo; var ExtObject: TObject);
    procedure OnTBdtkRegEx_BeginSearchEval(info: TProgramInfo; ExtObject: TObject);
    procedure OnTBdtkRegEx_FindEval(info: TProgramInfo; ExtObject: TObject);
    procedure OnTBdtkRegEx_NextEval(info: TProgramInfo; ExtObject: TObject);
    procedure OnTBdtkRegEx_MatchEval(info: TProgramInfo; ExtObject: TObject);
    procedure OnTBdtkRegEx_GetCaptureByNameEval(info: TProgramInfo; ExtObject: TObject);
  end;

implementation

uses
  BdtkRegEx;

{ TDW_BdtkRegExUnit }

constructor TDW_BdtkRegExUnit.Create(const MasterEngine: IMasterEngine);
var
  c: TdwsClass;
begin
  inherited;
  UnitName := 'RegEx';
  c := RegisterClass('TBdtkRegEx');

  RegisterConstructor(c, []);

  RegisterMethod(c, 'BeginSearch', 'Boolean', ['&Chaine', 'string', '&aRegEx', 'string']);
  RegisterMethod(c, 'Find', 'Boolean', ['@Chaine', 'string']);
  RegisterMethod(c, 'Next', 'Boolean', []);
  RegisterMethod(c, 'Match', 'Boolean', []);
  RegisterMethod(c, 'GetCaptureByName', 'string', ['&Group', 'string']);

  RegisterFunction('MatchRegEx', 'Boolean', ['&Chaine', 'string', '&aRegEx', 'string'], MatchRegExEval);
  RegisterFunction('ExtractRegEx', 'String', ['&Chaine', 'string', '&aRegEx', 'string'], ExtractRegExEval);
  RegisterFunction('ExtractRegExGroup', 'String', ['&Chaine', 'string', '&aRegEx', 'string', '&Group', 'string'], ExtractRegExGroupEval);
end;

procedure TDW_BdtkRegExUnit.ExtractRegExEval(info: TProgramInfo);
begin
  info.ResultAsString := ExtractRegEx(info.ParamAsString[0], info.ParamAsString[1]);
end;

procedure TDW_BdtkRegExUnit.ExtractRegExGroupEval(info: TProgramInfo);
begin
  info.ResultAsString := ExtractRegExGroup(info.ParamAsString[0], info.ParamAsString[1], info.ParamAsString[2]);
end;

procedure TDW_BdtkRegExUnit.MatchRegExEval(info: TProgramInfo);
begin
  info.ResultAsBoolean := MatchRegEx(info.ParamAsString[0], info.ParamAsString[1]);
end;

procedure TDW_BdtkRegExUnit.OnTBdtkRegEx_BeginSearchEval(info: TProgramInfo; ExtObject: TObject);
begin
  info.ResultAsBoolean := (ExtObject as TBdtkRegEx).BeginSearch(info.ParamAsString[0], info.ParamAsString[1]);
end;

procedure TDW_BdtkRegExUnit.OnTBdtkRegEx_CreateEval(info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TBdtkRegEx.Create;
end;

procedure TDW_BdtkRegExUnit.OnTBdtkRegEx_FindEval(info: TProgramInfo; ExtObject: TObject);
var
  Chaine: string;
begin
  Chaine := info.ValueAsString['Chaine'];
  info.ResultAsBoolean := (ExtObject as TBdtkRegEx).Find(Chaine);
  info.ValueAsString['Chaine'] := Chaine;
end;

procedure TDW_BdtkRegExUnit.OnTBdtkRegEx_GetCaptureByNameEval(info: TProgramInfo; ExtObject: TObject);
begin
  info.ResultAsString := (ExtObject as TBdtkRegEx).GetCaptureByName(info.ParamAsString[0]);
end;

procedure TDW_BdtkRegExUnit.OnTBdtkRegEx_MatchEval(info: TProgramInfo; ExtObject: TObject);
begin
  info.ResultAsBoolean := (ExtObject as TBdtkRegEx).Match;
end;

procedure TDW_BdtkRegExUnit.OnTBdtkRegEx_NextEval(info: TProgramInfo; ExtObject: TObject);
begin
  info.ResultAsBoolean := (ExtObject as TBdtkRegEx).Next;
end;

end.
