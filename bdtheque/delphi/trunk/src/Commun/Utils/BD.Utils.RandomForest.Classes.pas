unit BD.Utils.RandomForest.Classes;

interface

uses
  System.SysUtils, System.Math, System.Generics.Defaults, System.Generics.Collections,
  XALGLIB;

type
  TRFCriteria = class
  private
    FNaNValue: Double;
    FName: string;
  protected
    function GetNVars: Integer; virtual;
  public
    constructor Create(const AName: string; ANaNValue: Double = NaN); virtual;

    procedure WriteData(const AValue: Variant; var AVars: TArray<Double>; APosition: Integer); virtual;
    function Dump(const AVars: array of Double; APosition: Integer): string; virtual;

    property Name: string read FName;
    property NVars: Integer read GetNVars;
    property NaNValue: Double read FNaNValue write FNaNValue;
  end;

  TRFNominalCriteria = class(TRFCriteria)
  private
    FValues: TArray<Integer>;
  protected
    function GetNVars: Integer; override;
  public
    class function CreateFromList(const AName: string; ACategorie: Integer): TRFNominalCriteria;
  public
    constructor Create(const AName: string; const AValues: TArray<Integer>); reintroduce;
    destructor Destroy; override;

    procedure AddValue(const AValue: Integer);
    procedure WriteData(const AValue: Variant; var AVars: TArray<Double>; APosition: Integer); override;
    function Dump(const AVars: array of Double; APosition: Integer): string; override;
  end;

  TRFCriterias = class(TObjectList<TRFCriteria>)
  private
    function GetNVars: Integer;
  public
    property NVars: Integer read GetNVars;
  end;

  TRFDataLine = class
  public
//    constructor Create(AData: array of const);
  end;

  TRFData = class
  private
    FCriterias: TRFCriterias;
    function GetNVars: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    function GetDatas(const AData: TArray<TArray<Variant>>): TMatrix;
    function Dump(const AData: array of Double): string;

    property Criterias: TRFCriterias read FCriterias;
    property NVars: Integer read GetNVars;
  end;

implementation

uses
  Variants, BDTK.GUI.DataModules.Main, BD.DB.Connection;

{ TRFCriteria }

constructor TRFCriteria.Create(const AName: string; ANaNValue: Double);
begin
  FName := AName;
  FNaNValue := ANaNValue;
end;

function TRFCriteria.GetNVars: Integer;
begin
  Result := 1;
end;

procedure TRFCriteria.WriteData(const AValue: Variant; var AVars: TArray<Double>; APosition: Integer);
begin
  if VarIsNull(AValue) or IsNaN(AValue) then
    AVars[APosition] := FNaNValue
  else
    AVars[APosition] := AValue;
end;

function TRFCriteria.Dump(const AVars: array of Double; APosition: Integer): string;
begin
  Result := FloatToStr(AVars[APosition]);
end;

{ TRFNominalCriteria }

class function TRFNominalCriteria.CreateFromList(const AName: string; ACategorie: Integer): TRFNominalCriteria;
var
  q: TManagedQuery;
  Valeurs: TArray<Integer>;
begin
  q := dmPrinc.DBConnection.GetQuery;
  try
    q.SQL.Text := 'SELECT REF FROM LISTES WHERE CATEGORIE = :Categorie';
    q.Params.AsInteger[0] := ACategorie;
    q.Open;
    Valeurs := nil;
    while not q.Eof do
    begin
      Valeurs := Valeurs + [q.Fields.AsInteger[0]];
      q.Next;
    end;
    Result := TRFNominalCriteria.Create(AName, [0] + Valeurs);
  finally
    q.Free;
  end;
end;

constructor TRFNominalCriteria.Create(const AName: string; const AValues: TArray<Integer>);
begin
  inherited Create(AName, NaN);
  FValues := AValues;
end;

destructor TRFNominalCriteria.Destroy;
begin
  FValues := nil;
  inherited;
end;

procedure TRFNominalCriteria.AddValue(const AValue: Integer);
begin
  SetLength(FValues, Length(FValues) + 1);
  FValues[Length(FValues) - 1] := AValue;
end;

function TRFNominalCriteria.GetNVars: Integer;
begin
  Result := Length(FValues);
end;

procedure TRFNominalCriteria.WriteData(const AValue: Variant; var AVars: TArray<Double>; APosition: Integer);
var
  i: Integer;
begin
  for i := Low(FValues) to High(FValues) do
    if ((i = 0) and (VarIsNull(AValue) or IsNaN(AValue))) or (not (VarIsNull(AValue) or IsNaN(AValue)) and (AValue = FValues[i])) then
      AVars[APosition + i] := 1
    else
      AVars[APosition + i] := 0;
end;

function TRFNominalCriteria.Dump(const AVars: array of Double; APosition: Integer): string;
var
  i: Integer;
begin
  for i := Low(FValues) to High(FValues) do
    if SameValue(FValues[i], 1) then
      if (i = 0) then
        Exit(FloatToStr(NaN))
      else
        Exit(FloatToStr(FValues[i]));
  Result := FloatToStr(NaN);
end;

{ TRFData }

constructor TRFData.Create;
begin
  FCriterias := TRFCriterias.Create;
end;

destructor TRFData.Destroy;
begin
  FCriterias.Free;
  inherited;
end;

function TRFData.GetDatas(const AData: TArray<TArray<Variant>>): TMatrix;
var
  Criteria: TRFCriteria;
  PLine: ^TArray<Double>;
  a: ^TArray<Variant>;
  i, n, c: Integer;
begin
  SetLength(Result, Length(AData));

  for i := Low(AData) to High(AData) do
  begin
    a := @AData[i];
    PLine := @Result[i];
    SetLength(PLine^, NVars);
    n := 0;
    c := 0;
    for Criteria in FCriterias do
    begin
      if c > Length(a^) then
        Criteria.WriteData(Criteria.NaNValue, PLine^, n)
      else
        Criteria.WriteData(a^[c], PLine^, n);

      Inc(n, Criteria.NVars);
      Inc(c);
    end;
  end;
end;

function TRFData.Dump(const AData: array of Double): string;
var
  Criteria: TRFCriteria;
  n: Integer;
begin
  Result := '';
  n := 0;
  for Criteria in FCriterias do
  begin
    Result := Result + Criteria.Dump(AData, n) + #9;
    Inc(n, Criteria.NVars);
  end;
  Result := Result.Substring(0, Result.Length - 1);
end;

function TRFData.GetNVars: Integer;
begin
  Result := FCriterias.NVars;
end;

{ TRFCriterias }

function TRFCriterias.GetNVars: Integer;
var
  Criteria: TRFCriteria;
begin
  Result := 0;
  for Criteria in Self do
    Inc(Result, Criteria.NVars);
end;

end.
