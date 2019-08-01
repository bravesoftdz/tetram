unit BD.Utils.RegEx;

interface

uses
  SysUtils, Classes, JclPCRE;

type
  TBdtkRegEx = class
  private
    FRegEx: TJclAnsiRegEx;
  strict private
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
var
  r: TBdtkRegEx;
begin
  r := TBdtkRegEx.Create;
  try
    Result := r.FRegEx.Compile(aRegEx, True) and r.FRegEx.Match(Chaine);
  finally
    r.Free;
  end;
end;

function ExtractRegEx(const Chaine, aRegEx: string): string;
var
  r: TBdtkRegEx;
begin
  r := TBdtkRegEx.Create;
  try
    r.FRegEx.Compile(aRegEx, True);
    if r.FRegEx.Match(Chaine) and (r.FRegEx.CaptureCount > 0) then
      Result := r.FRegEx.Captures[1]
    else
      Result := '';
  finally
    r.Free;
  end;
end;

function ExtractRegExGroup(const Chaine, aRegEx, Group: string): string;
var
  i: Integer;
  r: TBdtkRegEx;
begin
  r := TBdtkRegEx.Create;
  try
    if not r.FRegEx.Compile(aRegEx, True) then
      Exit;
    if r.FRegEx.Match(Chaine) and (r.FRegEx.CaptureCount > 0) then
    begin
      if Group = '' then
        Result := r.FRegEx.Captures[1]
      else
      begin
        i := r.FRegEx.IndexOfName(Group);
        if (i > 0) then
          Result := r.FRegEx.Captures[i]
        else
          Result := '';
      end;
    end
    else
      Result := '';
  finally
    r.Free;
  end;
end;

{ TBdtkRegEx }

constructor TBdtkRegEx.Create;
begin
  inherited;
  FRegEx := TJclAnsiRegEx.Create;
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
