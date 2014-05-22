unit ORM.Core.Types;

interface

uses
  System.SysUtils;

type
  RGUIDEx = record
  private
    GUID: TGUID;
  public
    class operator Implicit(a: RGUIDEx): TGUID;
    class operator Implicit(a: RGUIDEx): string;
    class operator Implicit(a: TGUID): RGUIDEx;
    class operator Implicit(a: string): RGUIDEx;
  end;

const
  GUID_FULL: TGUID = '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}';
  sGUID_FULL = '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}';
  GUID_NULL: TGUID = '{00000000-0000-0000-0000-000000000000}';
  sGUID_NULL = '{00000000-0000-0000-0000-000000000000}';

function StringToGUIDDef(const GUID: string; const Default: TGUID): TGUID; inline;

implementation

function StringToGUIDDef(const GUID: string; const Default: TGUID): TGUID;
begin
  try
    Result := StringToGUID(GUID);
  except
    Result := Default;
  end;
end;

{ RGUIDEx }

class operator RGUIDEx.Implicit(a: RGUIDEx): string;
begin
  Result := GUIDToString(a);
end;

class operator RGUIDEx.Implicit(a: RGUIDEx): TGUID;
begin
  Result := a.GUID;
end;

class operator RGUIDEx.Implicit(a: string): RGUIDEx;
begin
  Result := StringToGUID(a);
end;

class operator RGUIDEx.Implicit(a: TGUID): RGUIDEx;
begin
  Result.GUID := a;
end;

end.
