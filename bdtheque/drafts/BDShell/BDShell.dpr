library BDShell;

{
 (c)2007 by Paul TOTH <tothpaul@free.fr>
 http://tothpaul.free.fr
}
{
This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}

uses
  Windows,
  SysUtils,
  ShlObj,
  BDShell1 in 'BDShell1.pas',
  ClassFactory in 'ClassFactory.pas',
  ShellFolder in 'ShellFolder.pas',
  EnumIDList in 'EnumIDList.pas',
  ExtractIcon in 'ExtractIcon.pas',
  Columns in 'Columns.pas',
  ItemList in 'ItemList.pas';

function DllGetClassObject(const CLSID, IID: TGUID; var Obj): HResult; stdcall;
var
  shell: TBDShell;
begin
{$IFDEF LOG}WriteLn('DllGetClassObject(', GUIDToString(CLSID), ',', GUIDToString(IID), ')');
{$ENDIF}
  if IsEqualGUID(CLSID, MyGUID) then
  begin
    shell := TBDShell.Create;
    Result := shell.QueryInterface(iid, obj);
    if Result = E_NOINTERFACE then shell.Free;
  end
  else
  begin
    Pointer(Obj) := nil;
    Result := CLASS_E_CLASSNOTAVAILABLE;
  end;
end;

function DllCanUnloadNow: HResult; stdcall;
begin
{$IFDEF LOG}WriteLn('DllCanUnloadNow');
{$ENDIF}
  if ShellCount = 0 then
    Result := S_OK
  else
    Result := S_FALSE;
end;

function DllRegisterServer: HResult; stdcall;
begin
{$IFDEF LOG}WriteLn('DllRegisterServer');
{$ENDIF}
  Result := RegisterShellFolder(
    'BDShell', MyGUID,
    SFGAO_FOLDER // you can open it from "MyComputer"
    or SFGAO_FILESYSTEM // you can open it in File/Open
    //SFGAO_FILESYSTEM or SFGAO_BROWSABLE or
  //     SFGAO_CANLINK or SFGAO_CANRENAME
  //  or SFGAO_DROPTARGET
  //  or SFGAO_HASSUBFOLDER or SFGAO_BROWSABLE or SFGAO_FILESYSTEM or SFGAO_FILESYSANCESTOR or SFGAO_FOLDER
    );
end;

function DllUnregisterServer: HResult; stdcall;
begin
{$IFDEF LOG}WriteLn('DllUnregisterServer');
{$ENDIF}
  Result := UnRegisterShellFolder(MyGUID);
end;

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.res}

begin
{$IFDEF LOG}
  AllocConsole;
  // AssignFile(Output,'C:\BDShell_log.txt');
  WriteLn(ParamStr(0), ' chargée');
{$ENDIF}
end.

