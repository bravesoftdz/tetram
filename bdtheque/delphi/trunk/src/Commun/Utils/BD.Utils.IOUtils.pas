unit BD.Utils.IOUtils;

interface

uses
  System.SysUtils, Winapi.Windows, Classes, WinAPI.ActiveX, ComObj;

procedure GetFileListFromExplorerDropObj(const DataObj: IDataObject; FileList: TStrings);

function SplitMasks(const AMask: string): TArray<string>;
function MatchesMasks(const AFilename: string; const AMasks: TArray<string>): Boolean;

implementation

uses
  ShellAPI, Masks;

function SplitMasks(const AMask: string): TArray<string>;
var
  Masks: TStringList;
  i: integer;
begin
  Result := [];

  Masks := TStringList.Create;
  try
    Masks.Delimiter := '|';
    Masks.StrictDelimiter := True;
    Masks.DelimitedText := AMask;
    i := 1;
    while i < Masks.Count do
    begin
      Result := Result + Masks[i].Split([';']);
      Inc(i, 2);
    end;

    Masks.Clear;
    Masks.Duplicates := dupIgnore;
    Masks.Sorted := True;
    Masks.AddStrings(Result);
    Result := Masks.ToStringArray;
  finally
    Masks.Free;
  end;
end;

function MatchesMasks(const AFilename: string; const AMasks: TArray<string>): Boolean;
var
  Mask: string;
begin
  for Mask in AMasks do
    if MatchesMask(AFilename, Mask) then
      Exit(True);
  Result := False;
end;

procedure GetFileListFromExplorerDropObj(const DataObj: IDataObject; FileList: TStrings);
var
  FmtEtc: TFormatEtc; // specifies required data format
  Medium: TStgMedium; // storage medium containing file list
  DroppedFileCount: Integer; // number of dropped files
  i: Integer; // loops thru dropped files
  FileNameLength: Integer; // length of a dropped file name
  FileName: string; // name of a dropped file
begin
  // Get required storage medium from data object
  FmtEtc.cfFormat := CF_HDROP;
  FmtEtc.ptd := nil;
  FmtEtc.dwAspect := DVASPECT_CONTENT;
  FmtEtc.lindex := -1;
  FmtEtc.tymed := TYMED_HGLOBAL;
  OleCheck(DataObj.GetData(FmtEtc, Medium));
  try
    try
      // Get count of files dropped
      DroppedFileCount := DragQueryFile(Medium.hGlobal, $FFFFFFFF, nil, 0);
      // Get name of each file dropped and process it
      for i := 0 to Pred(DroppedFileCount) do
      begin
        // get length of file name, then name itself
        FileNameLength := DragQueryFile(Medium.hGlobal, i, nil, 0);
        SetLength(FileName, FileNameLength);
        DragQueryFileW(Medium.hGlobal, i, PWideChar(FileName),
          FileNameLength + 1);
        // add file name to list
        FileList.Append(FileName);
      end;
    finally
      // Tidy up - release the drop handle
      // don't use DropH again after this
      DragFinish(Medium.hGlobal);
    end;
  finally
    ReleaseStgMedium(Medium);
  end;
end;

end.
