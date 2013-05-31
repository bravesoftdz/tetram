unit ShellFolder;
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

// http://www.codebot.org/print/?doctype=doc&doc=9418
// http://www.codeproject.com/shell/NamespaceExtImpl.asp
// http://www.codeproject.com/shell/shlext.asp

interface

uses
  Windows, ActiveX, ShlObj, SysUtils,
  ClassFactory, ExtractIcon, Columns;

type
  TShellFolder = class(TClassFactory
      , IShellFolder // 000214E6-0000-0000-C000-000000000046
      , IShellFolder2 // B82C5AA8-A41B-11D2-BE32-00C04FB93661
      , IShellIcon // 000214E5-0000-0000-C000-000000000046
      , IShellIconOverlay // 7D688A70-C613-11D0-999B-00C04FD655E1
      , IShellDetails // 000214EC-0000-0000-C000-000000000046
      , IPersist // 0000010C-0000-0000-C000-000000000046
      , IPersistFolder // 000214EA-0000-0000-C000-000000000046
      )
  private
    fRoot: PItemIDList;
    fPath: string;
    fColumns: TColumns;
    // fItems  :TItemList;
  public
    function GetItem(Index, Count, Base: cardinal; var List: PItemIDList): boolean; virtual; abstract;
    function GetExtractIcon(apidl: PItemIDList; var ppvOut): HResult; virtual;
    // IShellFolder
    function ParseDisplayName(hwndOwner: HWND; pbcReserved: Pointer; lpszDisplayName: POLESTR; out pchEaten: ULONG; out ppidl: PItemIDList; var dwAttributes: ULONG): HResult; stdcall;
    function EnumObjects(hwndOwner: HWND; grfFlags: DWORD; out EnumIDList: IEnumIDList): HResult; virtual; stdcall;
    function BindToObject(pidl: PItemIDList; pbcReserved: Pointer; const riid: TIID; out ppvOut): HResult; stdcall;
    function BindToStorage(pidl: PItemIDList; pbcReserved: Pointer; const riid: TIID; out ppvObj): HResult; stdcall;
    function CompareIDs(lParam: LPARAM; pidl1, pidl2: PItemIDList): HResult; virtual; stdcall;
    function CreateViewObject(hwndOwner: HWND; const riid: TIID; out ppvOut): HResult; stdcall;
    function GetAttributesOf(cidl: UINT; var apidl: PItemIDList; var rgfInOut: UINT): HResult; virtual; stdcall;
    function GetUIObjectOf(hwndOwner: HWND; cidl: UINT; var apidl: PItemIDList; const riid: TIID; prgfInOut: Pointer; out ppvOut): HResult; stdcall;
    function GetDisplayNameOf(pidl: PItemIDList; uFlags: DWORD; var lpName: TStrRet): HResult; virtual; stdcall;
    function SetNameOf(hwndOwner: HWND; pidl: PItemIDList; lpszName: POLEStr; uFlags: DWORD; var ppidlOut: PItemIDList): HResult; stdcall;
    // IShellFolder2
    function GetDefaultSearchGUID(out pguid: TGUID): HResult; stdcall;
    function EnumSearches(out ppEnum: IEnumExtraSearch): HResult; stdcall;
    function GetDefaultColumn(dwRes: DWORD; var pSort: ULONG; var pDisplay: ULONG): HResult; stdcall;
    function GetDefaultColumnState(iColumn: UINT; var pcsFlags: DWORD): HResult; virtual; stdcall;
    function GetDetailsEx(pidl: PItemIDList; const pscid: SHCOLUMNID; out pv: OleVariant): HResult; virtual; stdcall;
    // IShellIcon
    function GetIconOf(pidl: PItemIDList; flags: UINT; out IconIndex: Integer): HResult; virtual; stdcall;
    // IShellIconOverlay
    function GetOverlayIndex(pidl: PItemIDList; out pIndex: Integer): HResult; stdcall;
    function GetOverlayIconIndex(pidl: PItemIDList; out pIconIndex: Integer): HResult; stdcall;
    //  function GetDetailsOf(pidl: PItemIDList; iColumn: UINT; var pds: TShellDetails): HResult; stdcall;
    function MapNameToSCID(pwszName: LPCWSTR; var pscid: TShColumnID): HResult; stdcall;
    // IShellDetails
    function GetDetailsOf(pidl: PItemIDList; iColumn: UINT; var pDetails: TShellDetails): HResult; stdcall;
    function ColumnClick(iColumn: UINT): HResult; stdcall;
    // IPersist
    function GetClassID(out classID: TCLSID): HResult; virtual; stdcall;
    // IPersistFolder
    function Initialize(pidl: PItemIDList): HResult; stdcall;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property Path: string read fPath write fPath;
    property Columns: TColumns read fColumns;
    // property Items:TItemList read fItems;
  end;

function RegisterShellFolder(const Name: string; const CLSID: TGUID; Flags: cardinal): HResult;
function UnRegisterShellFolder(const CLSID: TGUID): HResult;

implementation

type
  TShellViewCreate = packed record
    dwSize: DWORD;
    pShellFolder: IShellFolder;
    psvOuter: IShellView;
    pfnCallback: IUnknown; //IShellFolderViewCB;
  end;

var
  SHCreateShellFolderView: function(var psvcbi: TShellViewCreate; out ppv): HRESULT; stdcall;

constructor TShellFolder.Create;
begin
  inherited;
  fColumns := TColumns.Create;
end;

destructor TShellFolder.Destroy;
begin
  fColumns.Free;
  inherited;
end;

function TShellFolder.GetExtractIcon(apidl: PItemIDList; var ppvOut): HResult;
begin
  Result := S_FALSE;
end;

// IShellFolder

function TShellFolder.ParseDisplayName(hwndOwner: HWND;
  pbcReserved: Pointer; lpszDisplayName: POLESTR; out pchEaten: ULONG;
  out ppidl: PItemIDList; var dwAttributes: ULONG): HResult; stdcall;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellFolder.ParseDisplayName');
{$ENDIF}
  Result := E_NOTIMPL;
end;

function TShellFolder.EnumObjects(hwndOwner: HWND; grfFlags: DWORD;
  out EnumIDList: IEnumIDList): HResult; stdcall;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellFolder.EnumObjects');
{$ENDIF}
  Result := E_UNEXPECTED;
end;

function TShellFolder.BindToObject(pidl: PItemIDList; pbcReserved: Pointer;
  const riid: TIID; out ppvOut): HResult; stdcall;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellFolder.BindToObject');
{$ENDIF}
  Result := E_UNEXPECTED;
end;

function TShellFolder.BindToStorage(pidl: PItemIDList; pbcReserved: Pointer;
  const riid: TIID; out ppvObj): HResult; stdcall;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellFolder.BindToStorage');
{$ENDIF}
  Result := E_UNEXPECTED;
end;

function TShellFolder.CompareIDs(lParam: LPARAM;
  pidl1, pidl2: PItemIDList): HResult; stdcall;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellFolder.CompareIDs');
{$ENDIF}
  Result := E_UNEXPECTED;
end;

function TShellFolder.CreateViewObject(hwndOwner: HWND; const riid: TIID; out ppvOut): HResult; stdcall;
var
  svc: TShellViewCreate;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellFolder.CreateViewObject(', hwndOwner, ',', GUIDToSTring(riid), ')');
{$ENDIF}
  // Result:=E_NOINTERFACE;
  if IsEqualGUID(riid, IShellView) then
  begin
    FillChar(svc, SizeOf(svc), 0);
    svc.dwSize := SizeOf(svc);
    svc.pShellFolder := Self as IShellFolder;
    Result := SHCreateShellFolderView(svc, ppvOut);
  end
  else
  begin
    Result := QueryInterface(riid, ppvOut);
  end;
end;

function TShellFolder.GetAttributesOf(cidl: UINT; var apidl: PItemIDList;
  var rgfInOut: UINT): HResult; stdcall;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellFolder.GetAttributesOf');
{$ENDIF}
  Result := E_UNEXPECTED;
end;

function TShellFolder.GetUIObjectOf(hwndOwner: HWND; cidl: UINT; var apidl: PItemIDList;
  const riid: TIID; prgfInOut: Pointer; out ppvOut): HResult; stdcall;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellFolder.GetUIObjectOf(', hwndOwner, ',', cidl, ',', cardinal(apidl), ',', GUIDToString(riid), ',...)');
{$ENDIF}
  Result := E_UNEXPECTED;
  if IsEqualGUID(riid, IExtractIconA) then
  begin
    Result := GetExtractIcon(apidl, ppvOut);
  end;
end;

function TShellFolder.GetDisplayNameOf(pidl: PItemIDList; uFlags: DWORD;
  var lpName: TStrRet): HResult; stdcall;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellFolder.GetDisplayNameOf');
{$ENDIF}
  Result := E_UNEXPECTED;
end;

function TShellFolder.SetNameOf(hwndOwner: HWND; pidl: PItemIDList; lpszName: POLEStr;
  uFlags: DWORD; var ppidlOut: PItemIDList): HResult; stdcall;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellFolder.SetNameOf');
{$ENDIF}
  Result := E_UNEXPECTED;
end;

// IShellFolder2

function TShellFolder.EnumSearches(out ppEnum: IEnumExtraSearch): HResult;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellFolder2.EnumSearches()');
{$ENDIF}
  Result := E_UNEXPECTED;
end;

function TShellFolder.GetDefaultColumn(dwRes: DWORD; var pSort,
  pDisplay: ULONG): HResult;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellFolder2.GetDefaultColumn(', dwRes, ',', pSort, ',', pDisplay, ')');
{$ENDIF}
  Result := E_UNEXPECTED;
end;

function TShellFolder.GetDefaultColumnState(iColumn: UINT;
  var pcsFlags: DWORD): HResult;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellFolder2.GetDefaultColumnState(', iColumn, ',', pcsFlags, ')');
{$ENDIF}
  Result := E_FAIL;
  if integer(iColumn) < fColumns.Count then
  begin
    pcsFlags := pcsFlags or SHCOLSTATE_ONBYDEFAULT + cardinal(fColumns[iColumn].DataType) + 1;
    Result := S_OK;
  end;
end;

function TShellFolder.GetDefaultSearchGUID(out pguid: TGUID): HResult;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellFolder2.GetDefaultSearchGUID()');
{$ENDIF}
  Result := E_UNEXPECTED;
end;

function TShellFolder.GetDetailsEx(pidl: PItemIDList;
  const pscid: SHCOLUMNID; out pv: OleVariant): HResult;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellFolder2.GetDetailsEx(', cardinal(pidl), ',{', GUIDToString(pscid.fmtid), ',', pscid.pid, '},pv)');
{$ENDIF}
  Result := E_UNEXPECTED;
end;

function TShellFolder.MapNameToSCID(pwszName: LPCWSTR;
  var pscid: TShColumnID): HResult;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellFolder2.MapNameToSCID()');
{$ENDIF}
  Result := E_UNEXPECTED;
end;

// IShellIcon

function TShellFolder.GetIconOf(pidl: PItemIDList; flags: UINT;
  out IconIndex: Integer): HResult;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellIcon.GetIconOf');
{$ENDIF}
  Result := S_FALSE;
end;

// IShellIconOverlay

function TShellFolder.GetOverlayIconIndex(pidl: PItemIDList;
  out pIconIndex: Integer): HResult;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellIconOverlay.GetOverlayIconIndex');
{$ENDIF}
  Result := S_FALSE;
end;

function TShellFolder.GetOverlayIndex(pidl: PItemIDList;
  out pIndex: Integer): HResult;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellIconOverlay.GetOverlayIndex');
{$ENDIF}
  Result := S_FALSE;
end;

// IShellDetails

function TShellFolder.ColumnClick(iColumn: UINT): HResult;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellDetails.ColumnClick(', iColumn, ')');
{$ENDIF}
  Result := E_UNEXPECTED;
end;

function TShellFolder.GetDetailsOf(pidl: PItemIDList; iColumn: UINT;
  var pDetails: TShellDetails): HResult;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellDetails.GetDetailsOf(', cardinal(pidl), ',', iColumn, ',pDetails)');
{$ENDIF}
  Result := E_FAIL;
  if (pidl = nil) then
  begin
    if integer(iColumn) < fColumns.Count then
    begin
      fColumns[iColumn].SetDetail(pDetails);
      Result := S_OK;
    end;
  end;
end;

// IPersist

function TShellFolder.GetClassID(out classID: TCLSID): HResult; stdcall;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IPersist.GetClassID');
{$ENDIF}
  Result := E_UNEXPECTED;
end;

// IPersistFolder

function TShellFolder.Initialize(pidl: PItemIDList): HResult; stdcall;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IPersistFolder.Initialize(', cardinal(pidl), ')');
{$ENDIF}
  if pidl = nil then
    Result := E_INVALIDARG
  else
  begin
    fRoot := CoTaskMemAlloc(pidl.mkid.cb);
    move(pidl^, fRoot^, pidl.mkid.cb);
    Result := S_OK;
  end;
end;

function RegisterShellFolder(const Name: string; const CLSID: TGUID; Flags: cardinal): HResult;
var
  GUID: string;
begin
  Result := E_FAIL;

  guid := SysUtils.GUIDToString(CLSID);
  if not RegisterInprocServer(Name, GUID) then exit;
  // Attributs du dossier
  if not WriteRegBinary(HKEY_CLASSES_ROOT, 'CLSID\' + GUID + '\ShellFolder', 'Attributes', Flags, SizeOf(Flags)) then exit;
  // L'ajouter au NameSpace
  if not WriteRegString(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\Namespace\' + GUID, '', Name) then exit;

  Result := S_OK;
end;

function UnRegisterShellFolder(const CLSID: TGUID): HResult;
var
  GUID: string;
begin
  WriteLn('UNREGISTER');
  GUID := SysUtils.GUIDToString(CLSID);
  if DeleteRegKey(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\Namespace\' + GUID) = False then
  begin
    WriteLn(SysErrorMessage(GetLastError));
    Result := E_FAIL;
    exit;
  end;
  if DeleteRegKey(HKEY_CLASSES_ROOT, 'CLSID\' + GUID + '\ShellFolder')
    and DeleteInprocServer(GUID) then
    Result := S_OK
  else
    Result := E_FAIL;
end;

initialization
  SHCreateShellFolderView := GetProcAddress(GetModuleHandle('shell32.dll'), 'SHCreateShellFolderView');
  if @SHCreateShellFolderView = nil then
    SHCreateShellFolderView := GetProcAddress(GetModuleHandle('shell32.dll'), PChar(256));
end.

