unit BdtkRegEx;

interface

uses
  SysUtils, Classes, JclPCRE;

type
  TBdtkRegEx = class
  private
    FRegEx: TJclAnsiRegEx;
  public
    constructor Create;
    destructor Destroy; override;
  end;

function ExtractRegEx(const Chaine, aRegEx: string): string;
function ExtractRegExGroup(const Chaine, aRegEx, Group: string): string;

implementation

function ExtractRegEx(const Chaine, aRegEx: string): string;
begin
  with TBdtkRegEx.Create do
    try
      FRegEx.Compile(aRegEx, false);
      if FRegEx.Match(Chaine) and (FRegEx.CaptureCount > 0) then
        Result := FRegEx.Captures[1]
      else
        Result := '';
    finally
      Free;
    end;
end;

function ExtractRegExGroup(const Chaine, aRegEx, Group: string): string;
var
  i: Integer;
begin
  with TBdtkRegEx.Create do
    try
      FRegEx.Compile(aRegEx, false);
      if FRegEx.Match(Chaine) and (FRegEx.CaptureCount > 0) then
      begin
        if Group = '' then
          Result := FRegEx.Captures[1]
        else
        begin
          i := FRegEx.IndexOfName(Group);
          if (i > 0) then
            Result := FRegEx.Captures[i]
          else
            Result := '';
        end;
      end
      else
        Result := '';
    finally
      Free;
    end;
end;

{ TBdtkRegEx }

constructor TBdtkRegEx.Create;
begin
  FRegEx := TJclAnsiRegEx.Create;
end;

destructor TBdtkRegEx.Destroy;
begin
  FRegEx.Free;
  inherited;
end;

end.
