unit UMain;

interface

uses UInterfacePlugIn, UInterfaceJoursFeries;

type
  TPlugin = class(TInterfacedObject, IPlugin, IJoursFeries)
  private
    // interface IPlugin
    function GetName: ShortString; stdcall;
    function GetDescription: ShortString; stdcall;
    function GetAuthor: ShortString; stdcall;
    function GetAuthorContact: ShortString; stdcall;

    // interface IJoursFeries
    function IsFerie(Jour: TDateTime): Boolean; stdcall;

  protected
    function IsPaques(Jour: TDateTime): Boolean;
    function IsPentecote(Jour: TDateTime): Boolean;
    function IsAscension(Jour: TDateTime): Boolean;
    function IsDay(Jour: TDateTime; Day, Month: Word): Boolean;
  end;

var
  Plugin: IPlugin;

implementation

uses DateUtils, SysUtils;

function Paques(Annee : Integer) : TDateTime;
var
  Y,G,C,X,Z,D,E,N,P,J,M : Integer;
begin
  {Algorithme valable pour les dates comprises entre 1583 et 4099}
  Y := Annee;
  G := (Y mod 19) + 1;
  C := Trunc((Y/100)) + 1;
  X := Trunc(3 * C / 4) - 12;
  Z := Trunc(((8 * C) + 5) / 25) - 5;
  D := Trunc(((5 * Y) / 4) - X - 10);
  E := ((11 * G)+ 20 + Z - X) mod 30;
  if ((E = 25) and (G > 11)) or (E = 24) then
    E := E + 1;
  N := 44 - E;
  if N <= 21 then
    N := N + 30;
  P := N + 7 - ((D + N) mod 7);
  if P > 31 then
    J := P - 31
  else
    J := P;
  if J = P then
    M := 3
  else
    M := 4;
  Result := EncodeDate(Annee, M, J);
end;

{ Plugin }

function TPlugin.GetAuthor: ShortString;
begin
  Result := 'Teträm Corp';
end;

function TPlugin.GetAuthorContact: ShortString;
begin
  Result := 'http://www.tetram.org';
end;

function TPlugin.GetDescription: ShortString;
begin
  Result := 'Jours feriés Français.';
end;

function TPlugin.GetName: ShortString;
begin
  Result := 'Jours feriés Français.';
end;

function TPlugin.IsAscension(Jour: TDateTime): Boolean;
begin
  Result := SameDate(Jour, IncDay(Paques(YearOf(Jour)), 39));
end;

function TPlugin.IsDay(Jour: TDateTime; Day, Month: Word): Boolean;
begin
  Result := (DayOf(Jour) = Day) and (MonthOf(Jour) = Month);
end;

function TPlugin.IsFerie(Jour: TDateTime): Boolean;
begin
// Lundi de Pâques = Pâques + 1 jour
// Ascension = Pâques + 39 jours
// Pentecôte = Pâques + 49 jours
// Lundi de Pentecôte = Pâques + 50 jours

  Result := IsDay(Jour, 01, 01) // Jour de l'an
         or IsPaques(Jour)      // Lundi de Paques
         or IsAscension(Jour)   // Ascension
         or IsDay(Jour, 01, 05) // Fête du travail
         or IsDay(Jour, 08, 05) // Victoire 1945
         or IsPentecote(Jour)   // Lundi de Pentecote  //................. en voie de suppression !!!! ((YearOf(Jour) < 2005) and IsPentecote(Jour))
         or IsDay(Jour, 14, 07) // Fête Nationale
         or IsDay(Jour, 15, 08) // Assomption
         or IsDay(Jour, 01, 11) // Toussaint
         or IsDay(Jour, 11, 11) // Armistice 1918
         or IsDay(Jour, 25, 12);// Noël
end;

function TPlugin.IsPaques(Jour: TDateTime): Boolean;
begin
  Result := SameDate(Jour, IncDay(Paques(YearOf(Jour)), 1));
end;

function TPlugin.IsPentecote(Jour: TDateTime): Boolean;
begin
  Result := SameDate(Jour, IncDay(Paques(YearOf(Jour)), 50));
end;

initialization
  Plugin := nil;

end.
