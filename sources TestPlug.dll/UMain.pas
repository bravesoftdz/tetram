unit UMain;

interface

uses UInterfacePlugIn, UInterfaceJoursFeries, UInterfaceChange;

type
  TPlugin = class(TInterfacedObject, IPlugin, IJoursFeries, IChange, IValideImage)
  private
    // interface IPlugin
    function GetName: ShortString; stdcall;
    function GetDescription: ShortString; stdcall;
    function GetAuthor: ShortString; stdcall;
    function GetAuthorContact: ShortString; stdcall;

    // interface IJoursFeries
    function IsFerie(Jour: TDateTime): Boolean; stdcall;

    // interface IChange
    function CanChange(Declenchement: TChangeType; Exclusion: Boolean): Boolean; stdcall;
    function ForceChange(Declenchement: TChangeType; Exclusion: Boolean): Boolean; stdcall;

    // interface IValideImage
    function IsValide(Image, Archive: PChar; var AutreImage: Boolean): Boolean; stdcall;
  end;

var
  Plugin: IPlugin;

implementation

uses DateUtils, SysUtils;

{ Plugin }

// *****************
// interface IPlugin
// *****************

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
  Result := 'Plugin de démonstration.'
          + #13#10
          + #13#10
          + 'Ce plug-in présente les différentes possibilités offertes par le SDK de WallPepper.';
end;

function TPlugin.GetName: ShortString;
begin
  Result := 'Plugin de démonstration';
end;

// **********************
// interface IJoursFeries
// **********************

function TPlugin.IsFerie(Jour: TDateTime): Boolean;
begin
  Result := (DayOf(Jour) = 31) and (MonthOf(Jour) = 3);    // tous les 31 Mars
end;

// *****************
// interface IChange
// *****************

function TPlugin.CanChange(Declenchement: TChangeType; Exclusion: Boolean): Boolean;
begin
  if Declenchement in [ctAutomatique, ctProgramme] then begin
    // n'autorise les changement que de 7h00 à 19h00
    Result := HourOf(Now) in [7..19];
    // uniquement s'il n'y a pas d'exclusion
    Result := not Exclusion and Result;
  end else
    Result := True;
end;

function TPlugin.ForceChange(Declenchement: TChangeType; Exclusion: Boolean): Boolean;
begin
  if Declenchement in [ctAutomatique, ctProgramme] then begin
    // force le changement le week-end
    Result := DayOfTheWeek(Now) in [DaySaturday, DaySunday];
    // uniquement s'il n'y a pas d'exclusion
    Result := not Exclusion and Result;
  end else
    Result := False;
end;

// **********************
// interface IValideImage
// **********************

function TPlugin.IsValide(Image, Archive: PChar; var AutreImage: Boolean): Boolean;
begin
  // refuser les images contenues dans des archives de 9h à 18h
  if HourOf(Now) in [9..18] then
    Result := (Archive = nil) or (Archive = '')
  else
    Result := True;
  // autoriser la recherche d'une autre image
  AutreImage := True;
end;

initialization
  Plugin := nil;

end.
