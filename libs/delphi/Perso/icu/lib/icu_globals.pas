unit icu_globals;

{$I icu.inc}

interface

uses
  System.SysUtils, Winapi.Windows;

const
  ICU_DEFAULT_VERSION = '52';
  ICU_FILE_VERSION = ICU_DEFAULT_VERSION;

  ICU_DEFAULT_COMMON_MODULE_NAME = 'icuuc' + ICU_FILE_VERSION + '.dll';
  ICU_DEFAULT_I18N_MODULE_NAME = 'icuin' + ICU_FILE_VERSION + '.dll';
  ICU_DEFAULT_DATA_MODULE_NAME = 'icudt' + ICU_FILE_VERSION + '.dll';

  ICU_DEFAULT_EXPORT_SUFFIX = '_' + ICU_DEFAULT_VERSION;

{$IFDEF ICU_LINKONREQUEST}

var
  ICU_VERSION: string = ICU_DEFAULT_VERSION;

  ICU_COMMON_MODULE_NAME: string = ICU_DEFAULT_COMMON_MODULE_NAME;
  ICU_I18N_MODULE_NAME: string = ICU_DEFAULT_I18N_MODULE_NAME;
  ICU_DATA_MODULE_NAME: string = ICU_DEFAULT_DATA_MODULE_NAME;

  ICU_EXPORT_SUFFIX: string = ICU_DEFAULT_EXPORT_SUFFIX;
{$ENDIF ~ICU_LINKONREQUEST}
function LoadICU: Boolean;
function IsICULoaded: Boolean;
procedure UnloadICU;

{$IFDEF ICU_LINKONREQUEST}
type
{$IFDEF MSWINDOWS}
  TModuleHandle = HINST;
{$ENDIF MSWINDOWS}
{$IFDEF LINUX}
  TModuleHandle = Pointer;
{$ENDIF LINUX}

const
  INVALID_MODULEHANDLE_VALUE = TModuleHandle(0);

var
  ICU_COMMON_LibraryHandle: TModuleHandle = INVALID_MODULEHANDLE_VALUE;
  ICU_I18N_LibraryHandle: TModuleHandle = INVALID_MODULEHANDLE_VALUE;
  ICU_DATA_LibraryHandle: TModuleHandle = INVALID_MODULEHANDLE_VALUE;

type
  TLoadFunction = function: Boolean;
  TUnloadProcedure = procedure;
procedure RegisterLoadICUProc(LoadProc: TLoadFunction; UnloadProc: TUnloadProcedure);

function GetModuleSymbol(Module: TModuleHandle; SymbolName: string): Pointer;
{$ENDIF ~ICU_LINKONREQUEST}

const
  DEFAULT_BUFFER_SIZE = 256;

implementation

uses
  System.Generics.Collections;

{$IFDEF ICU_LINKONREQUEST}

var
  LoadProcs: TList<TLoadFunction> = nil;
  UnloadProcs: TList<TUnloadProcedure> = nil;

procedure RegisterLoadICUProc(LoadProc: TLoadFunction; UnloadProc: TUnloadProcedure);
begin
  LoadProcs.Add(LoadProc);
  UnloadProcs.Add(UnloadProc);
end;

function LoadModule(var Module: TModuleHandle; FileName: string): Boolean;
begin
  if Module = INVALID_MODULEHANDLE_VALUE then
    Module := SafeLoadLibrary(FileName);
  Result := Module <> INVALID_MODULEHANDLE_VALUE;
end;

procedure UnloadModule(var Module: TModuleHandle);
begin
  if Module <> INVALID_MODULEHANDLE_VALUE then
    FreeLibrary(Module);
  Module := INVALID_MODULEHANDLE_VALUE;
end;

function GetModuleSymbol(Module: TModuleHandle; SymbolName: string): Pointer;
begin
  Result := nil;
  if Module <> INVALID_MODULEHANDLE_VALUE then
    Result := GetProcAddress(Module, PChar(SymbolName));
end;
{$ENDIF ~ICU_LINKONREQUEST}

function LoadICU: Boolean;
{$IFDEF ICU_LINKONREQUEST}
var
  LoadProc: TLoadFunction;
begin
  if IsICULoaded then
    Exit(True);

  Result :=
    LoadModule(ICU_COMMON_LibraryHandle, ICU_COMMON_MODULE_NAME)
    and LoadModule(ICU_I18N_LibraryHandle, ICU_I18N_MODULE_NAME)
    and LoadModule(ICU_DATA_LibraryHandle, ICU_DATA_MODULE_NAME);

  if Result then
    for LoadProc in LoadProcs do
      Result := LoadProc and Result;
end;
{$ELSE ~ICU_LINKONREQUEST}

begin
  Result := True;
end;
{$ENDIF ~ICU_LINKONREQUEST}

function IsICULoaded: Boolean;
begin
{$IFDEF ICU_LINKONREQUEST}
  Result :=
    (ICU_COMMON_LibraryHandle <> INVALID_MODULEHANDLE_VALUE)
    and (ICU_I18N_LibraryHandle <> INVALID_MODULEHANDLE_VALUE)
    and (ICU_DATA_LibraryHandle <> INVALID_MODULEHANDLE_VALUE);
{$ELSE ~ICU_LINKONREQUEST}
  Result := True;
{$ENDIF ~ICU_LINKONREQUEST}
end;

procedure UnloadICU;
{$IFDEF ICU_LINKONREQUEST}
var
  UnloadProc: TUnloadProcedure;
begin
  for UnloadProc in UnloadProcs do
    UnloadProc;
  UnloadModule(ICU_DATA_LibraryHandle);
  UnloadModule(ICU_I18N_LibraryHandle);
  UnloadModule(ICU_COMMON_LibraryHandle);
end;
{$ELSE ~ICU_LINKONREQUEST}

begin
end;
{$ENDIF ~ICU_LINKONREQUEST}

initialization

{$IFDEF ICU_LINKONREQUEST}
  LoadProcs := TList<TLoadFunction>.Create;
  UnloadProcs := TList<TUnloadProcedure>.Create;
{$ENDIF ~ICU_LINKONREQUEST}

finalization

  UnloadICU;
{$IFDEF ICU_LINKONREQUEST}
  LoadProcs.Free;
  UnloadProcs.Free;
{$ENDIF ~ICU_LINKONREQUEST}

end.
