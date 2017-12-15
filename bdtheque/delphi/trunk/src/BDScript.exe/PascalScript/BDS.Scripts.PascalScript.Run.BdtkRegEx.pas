unit BDS.Scripts.PascalScript.Run.BdtkRegEx;

{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis.
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

}
interface

uses
  uPSRuntime;

procedure RIRegister_BdtkRegEx_Routines(S: TPSExec);
procedure RIRegister_TBdtkRegEx(CL: TPSRuntimeClassImporter);
procedure RIRegister_BdtkRegEx(CL: TPSRuntimeClassImporter);

implementation

uses
  SysUtils, Classes, BD.Utils.RegEx;

procedure RIRegister_BdtkRegEx_Routines(S: TPSExec);
begin
  S.RegisterDelphiFunction(@MatchRegEx, 'MatchRegEx', cdRegister);
  S.RegisterDelphiFunction(@ExtractRegEx, 'ExtractRegEx', cdRegister);
  S.RegisterDelphiFunction(@ExtractRegExGroup, 'ExtractRegExGroup', cdRegister);
end;

procedure RIRegister_TBdtkRegEx(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBdtkRegEx) do
  begin
    RegisterConstructor(@TBdtkRegEx.Create, 'Create');
    RegisterMethod(@TBdtkRegEx.BeginSearch, 'BeginSearch');
    RegisterMethod(@TBdtkRegEx.Find, 'Find');
    RegisterMethod(@TBdtkRegEx.Next, 'Next');
    RegisterMethod(@TBdtkRegEx.Match, 'Match');
    RegisterMethod(@TBdtkRegEx.GetCaptureByName, 'GetCaptureByName');
  end;
end;

procedure RIRegister_BdtkRegEx(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TBdtkRegEx(CL);
end;

end.