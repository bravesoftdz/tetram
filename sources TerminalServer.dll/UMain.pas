unit UMain;

interface

uses UInterfacePlugIn, UInterfaceChange;

type
  TPlugin = class(TInterfacedObject, IPlugin, IChange)
  private
    // interface IPlugin
    function GetName: ShortString; stdcall;
    function GetDescription: ShortString; stdcall;
    function GetAuthor: ShortString; stdcall;
    function GetAuthorContact: ShortString; stdcall;

    // interface IChange  
    function CanChange(Declenchement: TChangeType; Exclusion: Boolean): Boolean; stdcall;
    function ForceChange(Declenchement: TChangeType; Exclusion: Boolean): Boolean; stdcall;
  end;

var
  Plugin: IPlugin;

implementation

uses SysUtils, Windows;

{ Plugin }

function IsRemoteSession: Boolean;
const
  SM_REMOTESESSION = $1000;
begin
  Result := LongBool(GetSystemMetrics(SM_REMOTESESSION));
end;

function TPlugin.CanChange(Declenchement: TChangeType; Exclusion: Boolean): Boolean;
begin
  Result := not IsRemoteSession;
end;

function TPlugin.ForceChange(Declenchement: TChangeType; Exclusion: Boolean): Boolean;
begin
  Result := False;
end;

function TPlugin.GetAuthor: ShortString;
begin
  Result := 'Teträm Corp';
end;

function TPlugin.GetAuthorContact: ShortString;
begin
  Result := 'http://www.tetram.info';
end;

function TPlugin.GetDescription: ShortString;
begin
  Result := 'Ce plugin empêche le changement de fond d''écran lors d''une session Terminal Server.';
end;

function TPlugin.GetName: ShortString;
begin
  Result := 'Remote Terminal Server.';
end;

initialization
  Plugin := nil;

end.
