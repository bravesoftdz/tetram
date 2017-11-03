unit Entities.Types;

interface

uses
  System.SysUtils, Vcl.StdCtrls;

type
  PAutoTrimString = ^RAutoTrimString;

  RAutoTrimString = record
  private
    Value: string;
  public
    class operator Implicit(a: string): RAutoTrimString;
    class operator Implicit(a: RAutoTrimString): string;
    class operator Equal(a, b: RAutoTrimString): Boolean;
    class operator NotEqual(a, b: RAutoTrimString): Boolean;
  end;

  PLongString = ^RLongString;

  RLongString = record
  private
    Value: string;
  public
    class operator Implicit(a: string): RLongString;
    class operator Implicit(a: RLongString): string;
  end;

  PTriStateValue = ^RTriStateValue;

  RTriStateValue = record
  private
    Value: Integer;
    function IsUndefined: Boolean;
    function GetAsBoolean(DefaultIfUndefined: Boolean): Boolean;
  public
    class operator Implicit(a: Boolean): RTriStateValue;
    class operator Implicit(a: RTriStateValue): Integer;
    class operator Implicit(a: TCheckBoxState): RTriStateValue;
    class operator Implicit(a: RTriStateValue): TCheckBoxState;
    class operator Equal(a, b: RTriStateValue): Boolean;
    class operator NotEqual(a, b: RTriStateValue): Boolean;

    class function FromInteger(a: Integer): RTriStateValue; static;
    class function Default: RTriStateValue; static;

    procedure SetUndefined;
    property Undefined: Boolean read IsUndefined;
    // des propriétés plutôt que des Implicit pour declencher des erreurs de compilation
    property AsBoolean[DefaultIfUndefined: Boolean]: Boolean read GetAsBoolean;
  end;

  POption = ^ROption;

  ROption = record
    Value: Integer;
    Caption: RAutoTrimString;
    constructor Create(Value: Integer; const Caption: RAutoTrimString);
    class operator Implicit(a: ROption): Integer;
    class operator Implicit(a: Integer): ROption;
  end;

implementation

{ AutoTrimString }

class operator RAutoTrimString.Implicit(a: string): RAutoTrimString;
begin
  Result.Value := a.Trim;
end;

class operator RAutoTrimString.Equal(a, b: RAutoTrimString): Boolean;
begin
  Result := CompareStr(a.Value, b.Value) = 0;
end;

class operator RAutoTrimString.Implicit(a: RAutoTrimString): string;
begin
  Result := a.Value;
end;

class operator RAutoTrimString.NotEqual(a, b: RAutoTrimString): Boolean;
begin
  Result := CompareStr(a.Value, b.Value) <> 0;
end;

{ LongString }

class operator RLongString.Implicit(a: string): RLongString;
begin
  Result.Value := a.Trim([' ', #13, #10]);
end;

class operator RLongString.Implicit(a: RLongString): string;
begin
  Result := a.Value;
end;

{ RTriStateValue }

class function RTriStateValue.Default: RTriStateValue;
begin
  Result.SetUndefined;
end;

class operator RTriStateValue.Equal(a, b: RTriStateValue): Boolean;
begin
  Result := a.Value = b.Value;
end;

class function RTriStateValue.FromInteger(a: Integer): RTriStateValue;
begin
  if (a = -1) or (a in [0 .. 1]) then
    Result.Value := a
  else
    Result.SetUndefined;
end;

class operator RTriStateValue.Implicit(a: Boolean): RTriStateValue;
begin
  if a then
    Result.Value := 1
  else
    Result.Value := 0;
end;

class operator RTriStateValue.Implicit(a: RTriStateValue): Integer;
begin
  Result := a.Value;
end;

function RTriStateValue.IsUndefined: Boolean;
begin
  Result := Value = -1;
end;

class operator RTriStateValue.NotEqual(a, b: RTriStateValue): Boolean;
begin
  Result := not(a = b);
end;

procedure RTriStateValue.SetUndefined;
begin
  Value := -1;
end;

class operator RTriStateValue.Implicit(a: TCheckBoxState): RTriStateValue;
begin
  case a of
    cbUnchecked:
      Result := False;
    cbChecked:
      Result := True;
    cbGrayed:
      Result.SetUndefined;
  end;
end;

function RTriStateValue.GetAsBoolean(DefaultIfUndefined: Boolean): Boolean;
begin
  if Undefined then
    Result := DefaultIfUndefined
  else
    Result := Value = 1;
end;

class operator RTriStateValue.Implicit(a: RTriStateValue): TCheckBoxState;
begin
  if a.Value = 1 then
    Result := cbChecked
  else if a.Value = 0 then
    Result := cbUnchecked
  else
    Result := cbGrayed;
end;

{ ROption }

constructor ROption.Create(Value: Integer; const Caption: RAutoTrimString);
begin
  Self.Value := Value;
  Self.Caption := Caption;
end;

class operator ROption.Implicit(a: ROption): Integer;
begin
  Result := a.Value;
end;

class operator ROption.Implicit(a: Integer): ROption;
begin
  Result.Value := a;
  Result.Caption := '';
end;

end.
