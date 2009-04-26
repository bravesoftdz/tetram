unit BdtkRegEx;

interface

uses
  SysUtils, Classes, JclPCRE;

type
  TBdtkRegEx = class
  private
    FRegEx: TJclRegEx;
    FLastFoundPos: Integer;
    FSearchString: string;
  public
    constructor Create;
    destructor Destroy; override;

    function BeginSearch(const Chaine, aRegEx: string): Boolean;
    function Find(var Chaine: string): Boolean;
    function Next: Boolean;
    function Match: Boolean;
    function GetCaptureByName(const Group: string): string;
  end;

function MatchRegEx(const Chaine, aRegEx: string): Boolean;
function ExtractRegEx(const Chaine, aRegEx: string): string;
function ExtractRegExGroup(const Chaine, aRegEx, Group: string): string;

implementation

function MatchRegEx(const Chaine, aRegEx: string): Boolean;
begin
  with TBdtkRegEx.Create do
    try
      Result := FRegEx.Compile(aRegEx, True) and FRegEx.Match(Chaine);
    finally
      Free;
    end;
end;

function ExtractRegEx(const Chaine, aRegEx: string): string;
begin
  with TBdtkRegEx.Create do
    try
      FRegEx.Compile(aRegEx, True);
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
      if not FRegEx.Compile(aRegEx, True) then Exit;
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
  FRegEx := TJclRegEx.Create;
  FRegEx.Options := [roMultiLine, roIgnoreCase, roUTF8, roNewLineAny];
end;

destructor TBdtkRegEx.Destroy;
begin
  FRegEx.Free;
  inherited;
end;

function TBdtkRegEx.BeginSearch(const Chaine, aRegEx: string): Boolean;
begin
  Result := FRegEx.Compile(aRegEx, True);
  FSearchString := Chaine;
  FLastFoundPos := 1;
end;

function TBdtkRegEx.Find(var Chaine: string): Boolean;
begin
  Result := Next;
  if Result then
    Chaine := FRegEx.Captures[1];
end;

function TBdtkRegEx.Match: Boolean;
begin
  Result := FRegEx.Match(FSearchString, FLastFoundPos);
end;

function TBdtkRegEx.Next: Boolean;
begin
  Result := Match;
  FLastFoundPos := FRegEx.CaptureRanges[0].LastPos + 1;
end;

function TBdtkRegEx.GetCaptureByName(const Group: string): string;
var
  i: Integer;
begin
  i := FRegEx.IndexOfName(Group);
  if (i > 0) and (i < FRegEx.CaptureCount) then
    Result := FRegEx.Captures[i]
  else
    Result := '';
end;

end.

