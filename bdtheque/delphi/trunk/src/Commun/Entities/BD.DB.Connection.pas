unit BD.DB.Connection;

interface

uses
  System.Classes, System.SysUtils, System.TypInfo, UIB, UIBLib, UFichierLog;

type
  TManagedQuery = class;
  TManagedTransaction = class;
  TManagedDatabase = class;

  IDBConnection = interface
    ['{F9F4EAE7-A0AB-4154-A479-DA7105788FC4}']
    function GetDatabase: TManagedDatabase;
    function GetTransaction: TManagedTransaction;
    function GetQuery(useTransaction: TManagedTransaction = nil): TManagedQuery;
    // function This: IDBConnection;

    function GetDead: Boolean;
    procedure SetDead(const Value: Boolean);
    property Dead: Boolean read GetDead write SetDead;
  end;

  TManagedDatabase = class(TUIBDatabase)

  end;

  TManagedTransaction = class(TUIBTransaction)
  end;

  TManagedQuery = class(TUIBQuery)
  private
    FConnection: IDBConnection;
    FOwnTransaction: Boolean;
    function GetTransaction: TManagedTransaction;

    // FDoLog: Boolean;

    property Database;
  protected
    procedure BeginExecute; override;
    procedure BeginPrepare(describeParams: Boolean = False); override;
    procedure SetTransaction(const Value: TManagedTransaction); reintroduce;

  public
    constructor Create(const Connection: IDBConnection); reintroduce;
    destructor Destroy; override;

    function GetFieldIndex(const AName: string): Integer;

    function NotNull(const AFieldName: string; ADefault: Boolean): Boolean; overload; inline;
    function NotNull(const AFieldName: string; ADefault: Integer): Integer; overload; inline;
    function NotNull(const AFieldName: string; ADefault: string): string; overload; inline;
    function NotNull(const AFieldName: string): TGUID; overload; inline;
    function NotNull(AFieldIndex: Integer; ADefault: Boolean): Boolean; overload;
    function NotNull(AFieldIndex: Integer; ADefault: Integer): Integer; overload;
    function NotNull(AFieldIndex: Integer; ADefault: string): string; overload;
    function NotNull(AFieldIndex: Integer): TGUID; overload;

    // property DoLog: Boolean read FDoLog write FDoLog;
    property Connection: IDBConnection read FConnection;
    property Transaction: TManagedTransaction read GetTransaction write SetTransaction;
  end;

  TDBConnection = class(TInterfacedObject, IDBConnection)
  private
    FDatabase: TManagedDatabase;
    FDead: Boolean;
    function GetDatabase: TManagedDatabase;
    function GetTransaction: TManagedTransaction;
    function GetQuery(useTransaction: TManagedTransaction = nil): TManagedQuery;
    // function This: IDBConnection;
    function GetDead: Boolean;
    procedure SetDead(const Value: Boolean);
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

implementation

{ TDBConnection }

uses
  BD.Utils.StrUtils;

procedure TDBConnection.AfterConstruction;
begin
  inherited;
  FDatabase := TManagedDatabase.Create(nil);
  FDead := False;
end;

procedure TDBConnection.BeforeDestruction;
begin
  inherited;
  FDatabase.Free;
end;

function TDBConnection.GetDatabase: TManagedDatabase;
begin
  Result := FDatabase;
end;

function TDBConnection.GetDead: Boolean;
begin
  Result := FDead;
end;

function TDBConnection.GetQuery(useTransaction: TManagedTransaction): TManagedQuery;
begin
  Result := TManagedQuery.Create(Self);
  Result.Database := FDatabase;
  if useTransaction = nil then
  begin
    Result.Transaction := GetTransaction;
    Result.FOwnTransaction := True;
  end
  else
    Result.Transaction := useTransaction;
  // Result.DoLog := Result.DoLog or (AppOption.DEBUGLevel > 0);
  Result.FetchBlobs := True;
end;

function TDBConnection.GetTransaction: TManagedTransaction;
begin
  Result := TManagedTransaction.Create(nil);
  Result.Database := FDatabase;
  Result.Options := [tpNowait, tpReadCommitted, tpRecVersion];
end;

procedure TDBConnection.SetDead(const Value: Boolean);
begin
  FDead := Value;
end;

{ TManagedQuery }

procedure TManagedQuery.BeginExecute;
var
  st: TDateTime;
  s: string;
  i: Integer;
begin
  st := Now;
  try
    inherited;
  except
    s := #13#10'/*';
    if Params.FieldCount > 0 then
    begin
      s := s + #13#10'Paramètres :';
      for i := 0 to Pred(Params.FieldCount) do
        if Params.IsNull[i] then
          s := s + Format(#13#10'  > %s = < null > (%s)', [Params.FieldName[i], GetEnumName(TypeInfo(TUIBFieldType), Ord(Params.FieldType[i]))])
        else if Params.IsBlob[i] then
          s := s + Format(#13#10'  > %s = [BLOB] (%s)', [Params.FieldName[i], GetEnumName(TypeInfo(TUIBFieldType), Ord(Params.FieldType[i]))])
        else
          s := s + Format(#13#10'  > %s = %s (%s)', [Params.FieldName[i], Params.AsString[i], GetEnumName(TypeInfo(TUIBFieldType), Ord(Params.FieldType[i]))]);
    end;
    if (CurrentState >= qsPrepare) then
      case StatementType of
        stInsert, stUpdate, stDelete:
          s := s + #13#10 + 'RowAffected : ' + IntToStr(RowsAffected);
        stSelect:
          s := s + #13#10'Empty : ' + BoolToStr(Eof and Bof, True);
      end;
    s := s + #13#10'Execution : ' + FormatDateTime('hh:mm:ss:zzz', Now - st);
    s := s + #13#10'*/';

    TFichierLog.Instance.AppendLog(s, tmErreur);
    TFichierLog.Instance.AppendCallStack;
    raise;
  end;
end;

procedure TManagedQuery.BeginPrepare(describeParams: Boolean);
var
  s: string;
  // i: Integer;
begin
  try
    // ne peut pas être utilisé tant que le describe réinitiolise les paramètres
    // describeParams := True;
    inherited;
  except
    s := #13#10'/*';
    s := s + #13#10'Connexion : ' + IntToHex(Integer(Pointer(FConnection)), 8);
    s := s + #13#10 + SQL.Text;
    if CurrentState >= qsPrepare then
      s := s + #13#10 + Plan;
    s := s + #13#10'*/';

    TFichierLog.Instance.AppendLog(s, tmErreur);
    TFichierLog.Instance.AppendCallStack;
    raise;
  end;
end;

constructor TManagedQuery.Create(const Connection: IDBConnection);
begin
  inherited Create(nil);
  FOwnTransaction := False;
  FConnection := Connection;
  // FDoLog := {$IFDEF DEV}True{$ELSE}False{$ENDIF};
end;

destructor TManagedQuery.Destroy;
begin
  if FOwnTransaction and (Transaction <> nil) then
  begin
    Transaction.Free;
    Transaction := nil;
  end;
  FConnection := nil;
  inherited;
end;

function TManagedQuery.GetFieldIndex(const AName: string): Integer;
begin
  for Result := 0 to Pred(Fields.FieldCount) do
    if SameText(Fields.AliasName[Result], AName) then
      Exit;
  Result := -1;
end;

function TManagedQuery.GetTransaction: TManagedTransaction;
begin
  Result := (inherited Transaction) as TManagedTransaction
end;

function TManagedQuery.NotNull(const AFieldName: string): TGUID;
begin
  Result := NotNull(GetFieldIndex(AFieldName));
end;

function TManagedQuery.NotNull(const AFieldName: string; ADefault: string): string;
begin
  Result := NotNull(GetFieldIndex(AFieldName), ADefault);
end;

function TManagedQuery.NotNull(const AFieldName: string; ADefault: Integer): Integer;
begin
  Result := NotNull(GetFieldIndex(AFieldName), ADefault);
end;

function TManagedQuery.NotNull(const AFieldName: string; ADefault: Boolean): Boolean;
begin
  Result := NotNull(GetFieldIndex(AFieldName), ADefault);
end;

function TManagedQuery.NotNull(AFieldIndex: Integer): TGUID;
begin
  if (AFieldIndex = -1) or Fields.IsNull[AFieldIndex] or Fields.AsString[AFieldIndex].Trim.IsEmpty then
    Exit(GUID_NULL);
  Result := StringToGUID(Fields.AsString[AFieldIndex].Trim);
end;

function TManagedQuery.NotNull(AFieldIndex: Integer; ADefault: string): string;
begin
  if (AFieldIndex = -1) or Fields.IsNull[AFieldIndex] then
    Exit(ADefault);
  Result := Fields.AsString[AFieldIndex];
end;

function TManagedQuery.NotNull(AFieldIndex, ADefault: Integer): Integer;
begin
  if (AFieldIndex = -1) or Fields.IsNull[AFieldIndex] then
    Exit(ADefault);
  Result := Fields.AsInteger[AFieldIndex];
end;

function TManagedQuery.NotNull(AFieldIndex: Integer; ADefault: Boolean): Boolean;
begin
  if (AFieldIndex = -1) or Fields.IsNull[AFieldIndex] then
    Exit(ADefault);
  Result := Fields.AsBoolean[AFieldIndex];
end;

procedure TManagedQuery.SetTransaction(const Value: TManagedTransaction);
begin
  inherited SetTransaction(Value);
  FOwnTransaction := False;
end;

end.
