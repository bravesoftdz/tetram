unit Procedures;

interface

function HTMLPrepare(const AStr: string): string;

implementation

uses
  Divers, CommonConst, HTTPApp;

function HTMLPrepare(const AStr: string): string;
begin
  Result := HTMLEncode(AStr);
  ReplaceString(Result, #13, '<br>');
end;

end.

