unit ClassFactory;
{
 IClassFactory (c)2007 by Paul TOTH <tothpaul@free.fr>
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
  Windows, ActiveX, ShlObj, SysUtils;

const
  FMTID_Shell_Details: TGUID = '{28636AA6-953D-11D2-B5D6-00C04FD918D0}';
  FMTID_Summary_Information: TGUID = '{F29F85E0-4FF9-1068-AB91-08002B27B3D9}';

type
  TUnknown = class(TObject
      , IUnknown // 00000000-0000-0000-C000-000000000046
      )
  public
    fRefCount: integer;
    // IUnknown
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
  end;

  TClassFactory = class(TUnknown
      , IClassFactory // 00000001-0000-0000-C000-000000000046
      )
  public
    // IClassFactory
    function CreateInstance(const unkOuter: IUnknown; const iid: TIID; out obj): HResult; stdcall;
    function LockServer(fLock: BOOL): HResult; stdcall;
  end;

  IShellFolder2 = interface(IShellFolder)
    ['{93F2F68C-1D1B-11D3-A30E-00C04F79ABD1}'] // bug Report #:  1335
    function GetDefaultSearchGUID(out pguid: TGUID): HResult; stdcall;
    function EnumSearches(out ppEnum: IEnumExtraSearch): HResult; stdcall;
    function GetDefaultColumn(dwRes: DWORD; var pSort: ULONG;
      var pDisplay: ULONG): HResult; stdcall;
    function GetDefaultColumnState(iColumn: UINT; var pcsFlags: DWORD): HResult; stdcall;
    function GetDetailsEx(pidl: PItemIDList; const pscid: SHCOLUMNID;
      out pv: OleVariant): HResult; stdcall;
    function GetDetailsOf(pidl: PItemIDList; iColumn: UINT;
      var psd: TShellDetails): HResult; stdcall;
    function MapNameToSCID(pwszName: LPCWSTR; var pscid: TShColumnID): HResult; stdcall;
  end;

function GUIDToString(const GUID: TGUID): string;
function DLLName: string;

function WriteRegString(Key: HKEY; const Path, Value, Data: string): boolean;
function WriteRegBinary(Key: HKEY; const Path, Value: string; const Data; Size: integer): boolean;
function DeleteRegKey(Key: HKEY; const Path: string): boolean;
function DeleteRegString(Key: HKEY; const Path, Value: string): boolean;

function RegisterInprocServer(const Name, GUID: string): boolean;
function DeleteInprocServer(const GUID: string): boolean;

implementation

function GUIDToString(const GUID: TGUID): string;
const
  IPersistFreeThreadedObject: TGUID = '{C7264BF0-EDB6-11D1-8546-006008059368}';
  IBrowserFrameOptions: TGUID = '{10DF43C8-1DBE-11D3-8B34-006097DF5BD4}';
  IInternetSecurityManager: TGUID = '{79EAC9EE-BAF9-11CE-8C82-00AA004BA90B}';
  IShellFolderViewCB: TGUID = '{2047E320-F2A9-11CE-AE65-08002B2E1262}';
  IColumnProvider: TGUID = '{E8025004-1C42-11d2-BE2C-00A0C9A83DA1}';
begin
  if IsEqualGUID(GUID, IUnknown) then
    Result := 'IUnknown'
  else if IsEqualGUID(GUID, IClassFactory) then
    Result := 'IClassFactory'
  else if IsEqualGUID(GUID, IShellIcon) then
    Result := 'IShellIcon'
  else if IsEqualGUID(GUID, IBrowserFrameOptions) then
    Result := 'IBrowserFrameOptions'
  else if IsEqualGUID(GUID, IShellFolder) then
    Result := 'IShellFolder'
  else if IsEqualGUID(GUID, IShellFolder2) then
    Result := 'IShellFolder2'
  else if IsEqualGUID(GUID, IPersist) then
    Result := 'IPersist'
  else if IsEqualGUID(GUID, IPersistFolder) then
    Result := 'IPersistFolder'
  else if IsEqualGUID(GUID, IPersistFolder2) then
    Result := 'IPersistFolder2'
  else if IsEqualGUID(GUID, IPersistFreeThreadedObject) then
    Result := 'IPersistFreeThreadedObject'
  else if IsEqualGUID(GUID, IShellView) then
    Result := 'IShellView'
  else if IsEqualGUID(GUID, IObjectWithSite) then
    Result := 'IObjectWithSite'
  else if IsEqualGUID(GUID, IInternetSecurityManager) then
    Result := 'IInternetSecurityManager'
  else if IsEqualGUID(GUID, IShellView2) then
    Result := 'IShellView2'
  else if IsEqualGUID(GUID, IOleCommandTarget) then
    Result := 'IOleCommandTarget'
  else if IsEqualGUID(GUID, IViewObject) then
    Result := 'IViewObject'
  else if IsEqualGUID(GUID, IShellLinkW) then
    Result := 'IShellLinkW'
  else if IsEqualGUID(GUID, IDropTarget) then
    Result := 'IDropTarget'
  else if IsEqualGUID(GUID, IDispatch) then
    Result := 'IDispatch'
  else if IsEqualGUID(GUID, IShellFolderViewCB) then
    Result := 'IShellFolderViewCB'
  else if IsEqualGUID(GUID, IShellDetails) then
    Result := 'IShellDetails'
  else if IsEqualGUID(GUID, IQueryInfo) then
    Result := 'IQueryInfo'
  else if IsEqualGUID(GUID, IExtractIconA) then
    Result := 'IExtractIconA'
  else if IsEqualGUID(GUID, IExtractIconW) then
    Result := 'IExtractIconW'
  else if IsEqualGUID(GUID, IShellIconOverlay) then
    Result := 'IShellIconOverlay'
  else if IsEqualGUID(GUID, IContextMenu) then
    Result := 'IContextMenu'
  else if IsEqualGUID(GUID, IColumnProvider) then
    Result := 'IColumnProvider'
  else if IsEqualGUID(GUID, FMTID_Summary_Information) then
    Result := 'FMTID_Summary_Information'
  else
    Result := SysUtils.GUIDToString(GUID)
end;

function DLLName: string;
var
  name: array[0..1024] of char;
begin
  GetModuleFileName(hInstance, name, SizeOf(name));
  Result := name;
end;

{ TUnknown }

function TUnknown._AddRef: Integer;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IUnknow.AddRef ', fRefCount, '+1');
{$ENDIF}
  Result := InterlockedIncrement(fRefCount);
end;

function TUnknown._Release: Integer;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IUnknow.Release ', fRefCount, '-1');
{$ENDIF}
  Result := InterlockedDecrement(fRefCount);
  if Result = 0 then Destroy;
end;

function TUnknown.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := S_OK
  else
    Result := E_NOINTERFACE;
{$IFDEF LOG}
  Write(ClassName, '.IUnknow.QueryInterface(', GUIDToString(IID), ') ');
  if Result = S_OK then
    WriteLn('OK')
  else
    WriteLn('NOINTERFACE');
{$ENDIF}
end;

{ TClassFactory }

function TClassFactory.CreateInstance(const unkOuter: IInterface;
  const iid: TIID; out obj): HResult;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IClassFactory.CreateInstance(', GUIDToString(iid), ')');
{$ENDIF}
  if @obj = nil then
    Result := E_POINTER
  else if unkOuter <> nil then
    Result := CLASS_E_NOAGGREGATION
  else
    Result := QueryInterface(iid, obj);
end;

function TClassFactory.LockServer(fLock: BOOL): HResult;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IClassFactory.LockServer(', fLock, ')');
{$ENDIF}
  Result := CoLockObjectExternal(Self, fLock, True);
end;

function WriteRegString(Key: HKEY; const Path, Value, Data: string): boolean;
var
  Handle: HKEY;
  Disposition: integer;
begin
  Result := (RegCreateKeyEx(Key, pchar(Path), 0, nil, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, nil, Handle, @Disposition) = ERROR_SUCCESS);
  if Result then
  begin
    Result := (RegSetValueEx(Handle, pchar(Value), 0, REG_SZ, pchar(Data), Length(Data)) = ERROR_SUCCESS);
    RegCloseKey(Handle);
  end;
end;

function WriteRegBinary(Key: HKEY; const Path, Value: string; const Data; Size: integer): boolean;
var
  Handle: HKEY;
  Disposition: integer;
begin
  Result := (RegCreateKeyEx(Key, pchar(Path), 0, nil, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, nil, Handle, @Disposition) = ERROR_SUCCESS);
  if Result then
  begin
    Result := (RegSetValueEx(Handle, pchar(Value), 0, REG_BINARY, pchar(@Data), Size) = ERROR_SUCCESS);
    RegCloseKey(Handle);
  end;
end;

function DeleteRegKey(Key: HKEY; const Path: string): boolean;
begin
  Result := RegDeleteKey(HKEY_CLASSES_ROOT, pchar(Path)) = ERROR_SUCCESS;
end;

function DeleteRegString(Key: HKEY; const Path, Value: string): boolean;
var
  Handle: HKEY;
begin
  Result := (RegOpenKeyEx(Key, pchar(Path), 0, KEY_ALL_ACCESS, Handle) = ERROR_SUCCESS);
  if Result then
  begin
    Result := (RegDeleteValue(Handle, pchar(Value)) = ERROR_SUCCESS);
    RegCloseKey(Handle);
  end;
end;

function RegisterInprocServer(const Name, GUID: string): boolean;
begin
  Result := WriteRegString(HKEY_CLASSES_ROOT, 'CLSID\' + GUID, '', Name)
    and WriteRegString(HKEY_CLASSES_ROOT, 'CLSID\' + GUID + '\InprocServer32', '', DLLName)
    and WriteRegString(HKEY_CLASSES_ROOT, 'CLSID\' + GUID + '\InprocServer32', 'ThreadingModel', 'Apartment');
end;

function DeleteInprocServer(const GUID: string): boolean;
begin
  Result := DeleteRegKey(HKEY_CLASSES_ROOT, 'CLSID\' + GUID + '\InprocServer32')
    and DeleteRegKey(HKEY_CLASSES_ROOT, 'CLSID\' + GUID);
end;

end.

