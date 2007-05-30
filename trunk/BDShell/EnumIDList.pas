unit EnumIDList;
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

interface

uses
  Windows, ActiveX, ShlObj,
  ClassFactory, ShellFolder;

type
  TEnumIDList = class(TUnknown
      , IEnumIDList // 000214F2-0000-0000-C000-000000000046
      )
  private
    fFolder: TShellFolder;
    fIndex: cardinal;
    fFlags: cardinal;
  protected
    property Flags: cardinal read fFlags;
  public
    constructor Create(AFolder: TShellFolder; AFlags: cardinal);
    // IEnumIDList
    function Next(celt: ULONG; out rgelt: PItemIDList; var pceltFetched: ULONG): HResult; stdcall;
    function Skip(celt: ULONG): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out ppenum: IEnumIDList): HResult; stdcall;
  end;

implementation

{ TEnumIDList }

constructor TEnumIDList.Create(AFolder: TShellFolder; AFlags: cardinal);
begin
  fFolder := AFolder;
  fFlags := AFlags;
end;

function TEnumIDList.Clone(out ppenum: IEnumIDList): HResult;
begin
  // this method is rarely used and it's acceptable to not implement it.
{$IFDEF LOG}WriteLn(ClassName, '.IEnumIDList.Clone');
{$ENDIF}
  Result := E_NOTIMPL;
end;

function TEnumIDList.Next(celt: ULONG; out rgelt: PItemIDList;
  var pceltFetched: ULONG): HResult;
var
  count: cardinal;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IEnumIDList.Next(', celt, ',...)');
{$ENDIF}
  if (@pceltFetched = nil) and (celt > 1) then
    Result := E_INVALIDARG
  else
  begin
    count := 0;
    rgelt := nil;
    while (count < celt) and fFolder.GetItem(count, celt, fIndex, rgelt) do
    begin
      inc(count);
      inc(fIndex);
    end;
    if (@pceltFetched <> nil) then pceltFetched := count;
    if count = celt then
      Result := S_OK
    else
      Result := S_FALSE;
{$IFDEF LOG}WriteLn(' ', count, ' items, ', Result);
{$ENDIF}
  end;
end;

function TEnumIDList.Reset: HResult;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IEnumIDList.Reset');
{$ENDIF}
  fIndex := 0;
  Result := S_OK;
end;

function TEnumIDList.Skip(celt: ULONG): HResult;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IEnumIDList.Skip');
{$ENDIF}
  inc(fIndex, celt);
  Result := S_OK;
end;

end.

