unit BDShell1;
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
  Windows, ComObj, ActiveX, SysUtils, ShlObj, CommCtrl, Classes, Variants,
  ClassFactory, ShellFolder, EnumIDList, ExtractIcon, Columns;

const
  MyGUID: TGUID = '{4746A99A-7572-4BCD-B501-F11D5677C163}';

type
  TBDShell = class(TShellFolder)
  private
    fItems: TEnumIDList;
  public
    function GetClassID(out classID: TCLSID): HResult; override; stdcall;
    function GetAttributesOf(cidl: UINT; var apidl: PItemIDList; var rgfInOut: UINT): HResult; override; stdcall;
    function EnumObjects(hwndOwner: HWND; grfFlags: DWORD; out EnumIDList: IEnumIDList): HResult; override; stdcall;
    function GetItem(Index, Count, Base: cardinal; var List: PItemIDList): boolean; override;
    function CompareIDs(lParam: LPARAM; pidl1, pidl2: PItemIDList): HResult; override; stdcall;
    function GetDisplayNameOf(pidl: PItemIDList; uFlags: DWORD; var lpName: TStrRet): HResult; override; stdcall;
    function GetIconOf(pidl: PItemIDList; flags: UINT; out IconIndex: Integer): HResult; override; stdcall;
    function GetExtractIcon(apidl: PItemIDList; var ppvOut): HResult; override;
    function GetDetailsEx(pidl: PItemIDList; const pscid: SHCOLUMNID; out pv: OleVariant): HResult; override; stdcall;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

  TItemID = packed record
    Size: word;
    Name: ShortString;
    Attr: integer;
  end;
  PItemID = ^TItemID;
  TItemIDs = array[word] of TItemID;
  PItemIDs = ^TItemIDs;

var
  ShellCount: integer = 0;

implementation

{ TBDShell }

constructor TBDShell.Create;
begin
  inherited;
{$IFDEF LOG}WriteLn('TBDShell.Create (ShellCount=', ShellCount, ')'#13#10'----------------');
{$ENDIF}
  InterlockedIncrement(ShellCount);
  Columns.Add('Nom', 40);
  Columns.Add('Taille', 20, taRightJustify, dtInteger);
  Columns.Add('Type', 20);
  Columns.Add('Modifié le', 20, taLeftJustify, dtDate);
  Columns.Add('Propriétaire', 40);
  Path := '\\BDShell\';
end;

destructor TBDShell.Destroy;
begin
  InterlockedDecrement(ShellCount);
{$IFDEF LOG}WriteLn('TBDShell.Destroy (ShellCount=', ShellCount, ')'#13#10'----------------');
{$ENDIF}
  inherited;
end;

// IShellFolder

function TBDShell.GetClassID(out classID: TCLSID): HResult; stdcall;
begin
{$IFDEF LOG}WriteLn(ClassName, '.GetClassID');
{$ENDIF}
  classID := MyGUID;
  Result := S_OK;
end;

function TBDShell.GetAttributesOf(cidl: UINT; var apidl: PItemIDList; var rgfInOut: UINT): HResult;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellFolder.GetAttributesOf(', cidl, ',', cardinal(@apidl), ',', rgfInOut, ')');
{$ENDIF}
  if cidl = 0 then
  begin
    rgfInOut := rgfInOut and (SFGAO_FOLDER {or SFGAO_FILESYSTEM});
    Result := S_OK;
    exit;
  end;
{$IFDEF LOG}if @apidl <> nil then WriteLn('Item.Size=', PItemID(apidl).Size);
  Flush(Output);
{$ENDIF}
  if (@apidl = nil) or (PItemID(apidl).Size <> SizeOf(TItemID)) then
    Result := E_INVALIDARG
  else
  begin
{$IFDEF LOG}
    WriteLn('Item.Name=', PItemID(apidl).Name);
    Flush(Output);
    WriteLn('Item.Attr=', PItemID(apidl).Attr);
    Flush(Output);
{$ENDIF}
    case PItemID(apidl).Attr of
      0: rgfInOut := rgfInOut or SFGAO_FOLDER or SFGAO_HASSUBFOLDER or SFGAO_BROWSABLE;
      1: rgfInOut := rgfInOut or SFGAO_HASPROPSHEET or SFGAO_NEWCONTENT;
    end;
    rgfInOut := rgfInOut and (not SFGAO_GHOSTED);
    Result := S_OK;
  end;
end;

function TBDShell.EnumObjects(hwndOwner: HWND; grfFlags: DWORD; out EnumIDList: IEnumIDList): HResult;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellFolder.EnumObjects(', hwndOwner, ',', grfFlags, ',...)');
{$ENDIF}
  if fItems <> nil then
  begin
    EnumIDList := nil;
    Result := S_FALSE;
  end
  else
  begin
    fItems := TEnumIDList.Create(Self, grfFlags);
    EnumIDList := fItems;
    Result := S_OK;
  end;
end;

function TBDShell.GetItem(Index, Count, Base: cardinal; var List: PItemIDList): boolean;
var
  i: integer;
  p: PItemIDs;
begin
{$IFDEF LOG}WriteLn('TBDShell.getItem(', Index, ',', Count, ',', Base, ',List)');
  Flush(Output);
{$ENDIF}
  Result := False;
  if Index + Base > 2 then exit;
  if Count + Base > 2 then Count := 2 - Base;
  if Count = 0 then exit;
  if List = nil then
  begin
    p := CoTaskMemAlloc(Count * SizeOf(TItemID) + 2);
    for i := 0 to Count - 1 do
    begin
      p[i].Size := SizeOf(TItemID);
      p[i].Name := '';
      p[i].Attr := 0;
    end;
    p[Count].Size := 0;
    List := PItemIDList(p);
  end
  else
  begin
    p := PItemIDs(List);
  end;
  with p[Index] do
  begin
    Name := 'Hello ' + IntToStr(Index + Base) + '.txt'#0;
    Attr := Index + Base;
  end;
  Result := True;
end;

function TBDShell.CompareIDs(lParam: LPARAM; pidl1, pidl2: PItemIDList): HResult;
var
  i: integer;
begin
{$IFDEF LOG}WriteLn('TBDShell.CompareIDs(', lParam, ',', cardinal(pidl1), ',', cardinal(pidl2), ');');
{$ENDIF}
  i := PItemID(pidl1).Attr - PItemID(pidl1).Attr;
  if i = 0 then
  begin
    i := AnsiCompareStr(PItemID(pidl1).Name, PItemID(pidl1).Name);
    if i = 0 then i := cardinal(pidl1) - cardinal(pidl2);
  end;
  if i < 0 then
    i := $FFFF
  else if i > 0 then
    i := 1;
  Result := i;
end;

function TBDShell.GetDisplayNameOf(pidl: PItemIDList; uFlags: DWORD; var lpName: TStrRet): HResult;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellFolder.GetDisplayNameOf(pidl,', uFlags, ',lpName)');
{$ENDIF}
  if PItemID(pidl).Size <> SizeOf(TItemID) then
  begin
    Result := E_INVALIDARG;
  end
  else
  begin
    lpName.uType := STRRET_CSTR;
    with PItemID(pidl)^ do
      move(Name[1], lpName.cStr, Length(Name) + 1);
    Result := S_OK;
  end;
end;

function TBDShell.GetIconOf(pidl: PItemIDList; flags: UINT; out IconIndex: Integer): HResult;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellIcon.GetIconOf(', cardinal(pidl), ',', flags, ',IconIndex)');
{$ENDIF}
  if (pidl <> nil) and (PItemID(pidl).Attr = 0) then
  begin
    IconIndex := 3;
    Result := NOERROR
  end
  else
  begin
    Result := S_FALSE;
  end;
end;

function TBDShell.GetExtractIcon(apidl: PItemIDList; var ppvOut): HResult;
var
  e: TExtractIcon;
begin
  e := TFileIcons.Create('shell32.dll', SI_DEF_DOCUMENT);
  Result := e.QueryInterface(IExtractIconA, ppvOut);
  if Result <> S_OK then e.Free;
end;

function TBDShell.GetDetailsEx(pidl: PItemIDList; const pscid: SHCOLUMNID;
  out pv: OleVariant): HResult;
begin
{$IFDEF LOG}WriteLn(ClassName, '.IShellFolder2.GetDetailsEx(', cardinal(pidl), ',{', GUIDToString(pscid.fmtid), ',', pscid.pid, '},pv)');
{$ENDIF}
  Result := E_FAIL;
  if IsEqualGUID(pscid.fmtid, FMTID_Summary_Information) then
  begin
    case pscid.pid of
      6: pv := 'Comment for ' + PItemID(pidl).Name;
      else
        begin
{$IFDEF LOG}WriteLn('can''t find info');
{$ENDIF}
          exit;
        end;
    end;
    Result := S_OK;
  end;
  (*
  if IsEqualGUID(pscid.fmtid,FMTID_Shell_Details) then begin
   case pscid.pid of
    2 : if PItemID(pidl).Attr=1 then
         pv:=VarArrayOf([SHDID_FS_FILE,fGUID]);
        else
         pv:=VarArrayOf([SHDID_FS_DIRECTORY,fGUID]);
   end:
  end;
  *)
end;

initialization
  AllocConsole;
  WriteLn('Press CTRL+C to kill BDShell');
  WriteLn(DLLName);
end.

