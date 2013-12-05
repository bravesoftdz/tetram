unit UDWUnit;

interface

uses
  System.SysUtils, System.Classes, dwsComp, dwsExprs, dwsSymbols, Generics.Collections, Variants, dwsUnitSymbols, dwsOperators, dwsUtils, UScriptEngineIntf;

type
{$M+}
  TDW_Unit = class(TdwsUnit)
  private
    FExternalInstances: TDictionary<IScriptObj, TObject>;
    FScriptObjInstances: TDictionary<TObject, IScriptObj>;
    // l'utilisation du type Pointer est impérative pour ne pas déclencher le comptage de référence
    FMasterEngine: Pointer;

    function RegisterMethod(m: TdwsMethods; Kind: TMethodKind; const MethodName, ResultType: string; Params: array of String; Event: TMethodEvalEvent;
      Visibility: TdwsVisibility = cvPublic; Attributes: TMethodAttributes = []): TdwsMethod; overload;
    procedure HandleDestroy(info: TProgramInfo; ExternalObject: TObject);
    function GetMethod(MethodName: string): TMethod;
    function GetMasterEngine: IMasterEngine;
  protected
    procedure InitUnitTable(systemTable: TSystemSymbolTable; unitSyms: TUnitMainSymbols; operators: TOperators; UnitTable: TUnitSymbolTable); override;
    procedure OnCleanClass(ExternalObject: TObject);
    function GetScriptObjFromExternal(info: TProgramInfo; AObject: TObject): IScriptObj;
    function GetExternalFromScriptObj(ScriptObj: IScriptObj): TObject;
  public
    constructor Create(const MasterEngine: IMasterEngine); reintroduce; virtual;
    destructor Destroy; override;

    procedure ConvertFuncParams(Params: TdwsParameters; const funcParams: array of string);

    function RegisterInterface(const Name: string; const AncestorName: string = ''): TdwsInterface;
    function RegisterClass(const Name: string; const AncestorName: string = ''): TdwsClass;
    function RegisterConstructor(c: TdwsClass; Params: array of String; Visibility: TdwsVisibility = cvPublic; Attributes: TMethodAttributes = [])
      : TdwsConstructor;
    procedure RegisterDestructor(c: TdwsClass);

    function RegisterMethod(c: TdwsClass; const MethodName, ResultType: string; Params: array of String; Visibility: TdwsVisibility = cvPublic;
      Attributes: TMethodAttributes = []): TdwsMethod; overload;
    function RegisterMethod(c: TdwsClass; const MethodName: string; Params: array of String; Visibility: TdwsVisibility = cvPublic;
      Attributes: TMethodAttributes = []): TdwsMethod; overload;

    function RegisterMethod(i: TdwsInterface; const MethodName, ResultType: string; Params: array of String): TdwsMethod; overload;
    function RegisterMethod(i: TdwsInterface; const MethodName: string; Params: array of String): TdwsMethod; overload;

    function RegisterProperty(c: TdwsClass; const PropertyName, PropertyType: string; ReadWrite: Boolean): TdwsProperty; overload;
    function RegisterProperty(c: TdwsClass; const PropertyName, PropertyType: string; EvalRead: TMethodEvalEvent; EvalWrite: TMethodEvalEvent = nil)
      : TdwsProperty; overload;
    function RegisterProperty(c: TdwsClass; const PropertyName, PropertyType: string; Params: array of String; EvalRead: TMethodEvalEvent;
      EvalWrite: TMethodEvalEvent = nil): TdwsProperty; overload;

    function RegisterType(const AliasName, TypeName: string): TdwsSynonym;
    function RegisterFunction(const FunctionName, ResultType: string; Params: array of String; EvalFunc: TFuncEvalEvent): TdwsFunction;
    function RegisterProcedure(const FunctionName: string; Params: array of String; EvalFunc: TFuncEvalEvent): TdwsFunction;

    property MasterEngine: IMasterEngine read GetMasterEngine;
  end;

implementation

{ TDW_Unit }

constructor TDW_Unit.Create(const MasterEngine: IMasterEngine);
begin
  inherited Create(nil);
  FMasterEngine := Pointer(MasterEngine);
  FExternalInstances := TDictionary<IScriptObj, TObject>.Create;
  FScriptObjInstances := TDictionary<TObject, IScriptObj>.Create;
end;

destructor TDW_Unit.Destroy;
begin
  FExternalInstances.Free;
  FScriptObjInstances.Free;
  inherited;
end;

function TDW_Unit.GetExternalFromScriptObj(ScriptObj: IScriptObj): TObject;
begin
  FExternalInstances.TryGetValue(ScriptObj, Result);
end;

function TDW_Unit.GetMasterEngine: IMasterEngine;
begin
  Result := IMasterEngine(FMasterEngine);
end;

function TDW_Unit.GetMethod(MethodName: string): TMethod;
begin
  Result.Data := Self;
  Result.Code := Self.MethodAddress(MethodName);
  Assert(Result.Code <> nil, 'Method ' + MethodName + ' not found');
end;

function TDW_Unit.GetScriptObjFromExternal(info: TProgramInfo; AObject: TObject): IScriptObj;
begin
  Result := nil;
  if not FScriptObjInstances.TryGetValue(AObject, Result) then
  begin
    Result := info.RegisterExternalObject(AObject, False, False);
    FScriptObjInstances.Add(AObject, Result);
    FExternalInstances.Add(Result, AObject);
  end;
end;

procedure TDW_Unit.HandleDestroy(info: TProgramInfo; ExternalObject: TObject);
var
  o: IScriptObj;
begin
  if FScriptObjInstances.TryGetValue(ExternalObject, o) then
  begin
    FExternalInstances.Remove(o);
    FScriptObjInstances.Remove(ExternalObject);
  end;
  ExternalObject.Free;
end;

procedure TDW_Unit.InitUnitTable(systemTable: TSystemSymbolTable; unitSyms: TUnitMainSymbols; operators: TOperators; UnitTable: TUnitSymbolTable);
begin
  inherited;
  FExternalInstances.Clear;
  FScriptObjInstances.Clear;
end;

procedure TDW_Unit.OnCleanClass(ExternalObject: TObject);
// var
// v: variant;
begin
  // if FScriptObjInstances.TryGetValue(ExternalObject, v) then
  // begin
  // FExternalInstances.Remove(v);
  // FScriptObjInstances.Remove(ExternalObject);
  // end;
end;

procedure TDW_Unit.ConvertFuncParams(Params: TdwsParameters; const funcParams: array of string);

  procedure ParamSpecifier(c: WideChar; paramRec: TdwsParameter);
  begin
    paramRec.IsVarParam := (c = '@');
    // paramRec.IsConstParam := (c = '&');
    paramRec.Name := Copy(paramRec.Name, 2, MaxInt)
  end;

  procedure ParamDefaultValue(p: Integer; paramRec: TdwsParameter);
  begin
    paramRec.DefaultValue := Trim(Copy(paramRec.DataType, p + 1, MaxInt));
    paramRec.HasDefaultValue := True;
    paramRec.DataType := Trim(Copy(paramRec.DataType, 1, p - 1));
  end;

var
  x, p: Integer;
  c: WideChar;
  paramRec: TdwsParameter;
begin
  x := 0;
  while x < Length(funcParams) - 1 do
  begin
    paramRec := Params.Add;

    paramRec.Name := funcParams[x];
    c := #0;
    if paramRec.Name <> '' then
      c := paramRec.Name[1];

    case c of
      '@', '&':
        ParamSpecifier(c, paramRec);
    else
      paramRec.IsVarParam := False;
      // paramRec.IsConstParam := False;
    end;

    paramRec.DataType := funcParams[x + 1];

    p := Pos('=', paramRec.DataType);
    if p > 0 then
      ParamDefaultValue(p, paramRec);

    Inc(x, 2);
  end;
end;

function TDW_Unit.RegisterClass(const Name, AncestorName: string): TdwsClass;
begin
  Result := Classes.Add;
  Result.Name := Name;
  Result.Ancestor := AncestorName;
  Forwards.Add.Name := Result.Name;
  Result.OnCleanUp := OnCleanClass;
end;

function TDW_Unit.RegisterConstructor(c: TdwsClass; Params: array of String; Visibility: TdwsVisibility; Attributes: TMethodAttributes): TdwsConstructor;
begin
  Result := c.Constructors.Add;
  Result.Name := 'Create';
  ConvertFuncParams(Result.Parameters, Params);
  Result.OnEval := TAssignExternalObjectEvent(GetMethod('On' + c.Name + '_CreateEval'));
  Result.Attributes := Attributes;
  if c.Methods.IndexOf('Destroy') = -1 then
    RegisterMethod(c.Methods, mkDestructor, 'Destroy', '', [], HandleDestroy, cvPublic, [maOverride]);
end;

procedure TDW_Unit.RegisterDestructor(c: TdwsClass);
begin
  c.OnCleanUp := TObjectDestroyEvent(GetMethod('On' + c.Name + '_DestroyEval'));
end;

function TDW_Unit.RegisterFunction(const FunctionName, ResultType: string; Params: array of String; EvalFunc: TFuncEvalEvent): TdwsFunction;
begin
  Result := Functions.Add;

  Result.Name := FunctionName;
  Result.ResultType := ResultType;
  ConvertFuncParams(Result.Parameters, Params);
  Result.OnEval := EvalFunc;
end;

function TDW_Unit.RegisterInterface(const Name, AncestorName: string): TdwsInterface;
begin
  Result := Interfaces.Add;
  Result.Name := Name;
  Result.Ancestor := AncestorName;
  Forwards.Add.Name := Result.Name;
end;

function TDW_Unit.RegisterMethod(c: TdwsClass; const MethodName, ResultType: string; Params: array of String; Visibility: TdwsVisibility;
  Attributes: TMethodAttributes): TdwsMethod;
begin
  Result := RegisterMethod(c.Methods, mkFunction, MethodName, ResultType, Params, TMethodEvalEvent(GetMethod('On' + c.Name + '_' + MethodName + 'Eval')),
    Visibility, Attributes);
end;

function TDW_Unit.RegisterMethod(c: TdwsClass; const MethodName: string; Params: array of String; Visibility: TdwsVisibility; Attributes: TMethodAttributes)
  : TdwsMethod;
begin
  Result := RegisterMethod(c.Methods, mkProcedure, MethodName, '', Params, TMethodEvalEvent(GetMethod('On' + c.Name + '_' + MethodName + 'Eval')), Visibility,
    Attributes);
end;

function TDW_Unit.RegisterMethod(m: TdwsMethods; Kind: TMethodKind; const MethodName, ResultType: string; Params: array of String; Event: TMethodEvalEvent;
  Visibility: TdwsVisibility = cvPublic; Attributes: TMethodAttributes = []): TdwsMethod;
begin
  Result := m.Add;
  Result.Name := MethodName;
  Result.ResultType := ResultType;
  Result.OnEval := Event;
  Result.Kind := Kind;
  Result.Attributes := Attributes;
  Result.Visibility := Visibility;
  ConvertFuncParams(Result.Parameters, Params);
end;

function TDW_Unit.RegisterProcedure(const FunctionName: string; Params: array of String; EvalFunc: TFuncEvalEvent): TdwsFunction;
begin
  Result := RegisterFunction(FunctionName, '', Params, EvalFunc);
end;

function TDW_Unit.RegisterProperty(c: TdwsClass; const PropertyName, PropertyType: string; Params: array of String; EvalRead, EvalWrite: TMethodEvalEvent)
  : TdwsProperty;
var
  aRead, aWrite: string;
  p: array of string;
  i: Integer;
begin
  aRead := 'Get' + PropertyName;
  aWrite := '';
  RegisterMethod(c.Methods, mkFunction, aRead, PropertyType, Params, EvalRead, cvPrivate);
  if Assigned(EvalWrite) then
  begin
    aWrite := 'Set' + PropertyName;
    SetLength(p, Length(Params) + 2);
    for i := 0 to Pred(Length(Params)) do
      p[i] := Params[i];
    p[Length(p) - 2] := 'Value';
    p[Length(p) - 1] := PropertyType;
    RegisterMethod(c.Methods, mkProcedure, aWrite, '', p, EvalWrite, cvPrivate);
  end;
  Result := c.Properties.Add;
  with Result do
  begin
    Name := PropertyName;
    DataType := PropertyType;
    ReadAccess := aRead;
    WriteAccess := aWrite;
    ConvertFuncParams(Parameters, Params);
  end;
end;

function TDW_Unit.RegisterType(const AliasName, TypeName: string): TdwsSynonym;
begin
  Result := Synonyms.Add;
  with Result do
  begin
    Name := AliasName;
    DataType := TypeName;
  end;
end;

function TDW_Unit.RegisterProperty(c: TdwsClass; const PropertyName, PropertyType: string; EvalRead, EvalWrite: TMethodEvalEvent): TdwsProperty;
begin
  Result := RegisterProperty(c, PropertyName, PropertyType, [], EvalRead, EvalWrite);
end;

function TDW_Unit.RegisterProperty(c: TdwsClass; const PropertyName, PropertyType: string; ReadWrite: Boolean): TdwsProperty;
begin
  with c.Fields.Add do
  begin
    Name := 'F' + PropertyName;
    DataType := PropertyType;
    Visibility := cvPrivate;
  end;
  Result := c.Properties.Add;
  with Result do
  begin
    Name := PropertyName;
    DataType := PropertyType;
    ReadAccess := 'F' + PropertyName;
    if ReadWrite then
      WriteAccess := ReadAccess;
  end;
end;

function TDW_Unit.RegisterMethod(i: TdwsInterface; const MethodName, ResultType: string; Params: array of String): TdwsMethod;
begin
  Result := RegisterMethod(i.Methods, mkFunction, MethodName, ResultType, Params, TMethodEvalEvent(nil), cvPublic, []);
end;

function TDW_Unit.RegisterMethod(i: TdwsInterface; const MethodName: string; Params: array of String): TdwsMethod;
begin
  Result := RegisterMethod(i.Methods, mkProcedure, MethodName, '', Params, TMethodEvalEvent(nil), cvPublic, []);
end;

end.
