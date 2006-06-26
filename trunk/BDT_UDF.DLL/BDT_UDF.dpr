library BDT_UDF;

uses
  Windows,
  SysUtils,
  Classes,
  //  IBHeader,
  IBExternals,
  Divers in '..\..\..\Common\Divers.pas',
  ib_util in 'D:\Program Files\Firebird\Firebird_1_5\include\ib_util.pas';

{$R *.res}

function Trim(Chaine: PChar): PChar; cdecl; export;
var
  s: string;
begin
  s := SysUtils.Trim(Chaine) + #0;
  Result := ib_util_malloc(Length(s));
  StrCopy(Result, PChar(s));
end;

function Soundex(Chaine: PChar; var OrigineTitre: Integer): PChar; cdecl; export;
var
  s: string;
begin
  case OrigineTitre of
    1: s := BaseSoundex(Chaine, 'FR');
    2: s := BaseSoundex(Chaine, 'EN');
    else
      s := '';
  end;
  s := s + #0;
  Result := ib_util_malloc(Length(s));
  StrCopy(Result, PChar(s));
end;

function Upper(Chaine: PChar): PChar; cdecl; export;
var
  s: string;
begin
  s := UpperCase(SansAccents(Chaine)) + #0;
  Result := ib_util_malloc(Length(Chaine) + 1);
  StrCopy(Result, PChar(s));
end;

procedure UpperBlob(BlobIn, BlobOut: PBlob); cdecl; export;
var
  buffer: array of Char;
  LongueurLue, i: Integer;
begin
  try
    if Assigned(BlobIn.BlobHandle) and (BlobIn.SegmentCount > 0) then begin
      SetLength(buffer, BlobIn.MaxSegmentLength);
      while LongBool(BlobIn.GetSegment(BlobIn.BlobHandle, @buffer[0], BlobIn.MaxSegmentLength, LongueurLue)) do begin
        for i := 0 to LongueurLue - 1 do
          buffer[i] := UpperCase(SansAccents(buffer[i]))[1];
        BlobOut.PutSegment(BlobOut.BlobHandle, @buffer[0], LongueurLue);
      end;
    end;
  except
  end; // pour être sûr de ne pas faire planter le serveur !!!!
end;

function SubString(Chaine: PChar; var Position, Longueur: Integer): PChar; cdecl; export;
var
  s: string;
begin
  s := Copy(Chaine, Position, Longueur) + #0;
  Result := ib_util_malloc(Length(Chaine) + 1);
  StrCopy(Result, PChar(s));
end;

function ValidFileName(const FileName: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(FileName) do
    if FileName[i] in ['/', '\', ':', '*', '?', '"', '<', '>', '|'] then
      Result := Result + '_'
    else
      Result := Result + FileName[i];
end;

procedure WriteLog(chaine: string);
begin
  with tstringlist.create do try
    if FileExists('G:\Programmation\MEDIA.KIT\BDthèque 1.0\UDF\bdt_udf.log') then loadfromfile('G:\Programmation\MEDIA.KIT\BDthèque 1.0\UDF\bdt_udf.log');
    Add('-- ' + DateTimeToStr(Now) + ' --');
    Add(chaine);
    SaveToFile('G:\Programmation\MEDIA.KIT\BDthèque 1.0\UDF\bdt_udf.log');
  finally
    free;
  end;
end;

function SaveBlobToFile(Path, FileName: PChar; Blob: PBlob): Integer; cdecl; export;
var
  buffer: array of Char;
  LongueurLue: Integer;
  BlobS: TMemoryStream;
begin
  try
    FileName := PChar(Path + ValidFileName(FileName));
    BlobS := TMemoryStream.Create;
    with BlobS do try
      Seek(0, soBeginning);
      if Assigned(Blob.BlobHandle) and (Blob.SegmentCount > 0) then begin
        SetLength(buffer, Blob.MaxSegmentLength);
        while LongBool(Blob.GetSegment(Blob.BlobHandle, @buffer[0], Blob.MaxSegmentLength, LongueurLue)) do
          BlobS.Write(buffer[0], LongueurLue);

        ForceDirectories(Path);
        if FileExists(FileName) then DeleteFile(FileName);
        BlobS.SaveToFile(FileName);
      end;
      Result := BlobS.Size;
    finally
      Free;
    end;
  except Result := 0;
  end; // pour être sûr de ne pas faire planter le serveur !!!!
end;

procedure LoadBlobFromFile(Path, FileName: PChar; Blob: PBlob); cdecl; export;
var
  buffer: array[0..4095] of Char;
  FS: TFileStream;
begin
  try
    FileName := PChar(Path + ValidFileName(FileName));
    if not FileExists(FileName) then Exit;

    FS := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    with FS do try
      while Position < Size do
        Blob.PutSegment(Blob.BlobHandle, @buffer[0], Read(buffer, Length(buffer)));
    finally
      Free;
    end;
  except
  end; // pour être sûr de ne pas faire planter le serveur !!!!
end;

type
  PSearchRec = ^TSearchRec;

function FindFileFirst(Path: PChar; var Attr: Integer): PSearchRec; cdecl; export;
var
  i: Integer;
begin
  New(Result);
  i := FindFirst(Path, Attr, Result^);
  if i <> 0 then begin
    FindClose(Result^);
    Dispose(Result);
    Result := PSearchRec(-i);
  end;
end;

function FindFileNext(var Sr: PSearchRec): PSearchRec; cdecl; export;
var
  i: Integer;
begin
  Result := sr;
  i := FindNext(Result^);
  if i <> 0 then begin
    FindClose(Result^);
    Dispose(Result);
    Result := PSearchRec(-i);
  end;
end;

function ExtractFileName(var Sr: PSearchRec): PChar; cdecl; export;
var
  s: string;
begin
  s := sr^.Name + #0;
  Result := ib_util_malloc(Length(s));
  StrCopy(Result, PChar(s));
end;

function ExtractFileAttr(var Sr: PSearchRec): Integer; cdecl; export;
begin
  Result := sr^.Attr;
end;

function ExtractFileSize(var Sr: PSearchRec): Integer; cdecl; export;
begin
  Result := sr^.Size;
end;

function SearchFileName(Path, FileName: PChar; var Reserve: Integer): PChar; cdecl; export;
var
  toAdd, Fichier, ext: string;
  Index: Integer;
begin
  ext := ExtractFileExt(FileName);
  Fichier := IncludeTrailingPathDelimiter(Path) + ChangeFileExt(FileName, '');
  Index := 0;
  toAdd := ext;
  while FileExists(Fichier + toAdd) do begin
    Inc(Index);
    toAdd := Format(' (%d)%s', [Index, ext]);
  end;
  if Reserve <> 0 then begin
    ForceDirectories(Path);
    TFileStream.Create(Fichier + toAdd, fmCreate).Free;
  end;
  Fichier := Fichier + toAdd + #0;
  Result := ib_util_malloc(Length(Fichier));
  StrCopy(Result, PChar(Fichier));
end;

function DeleteFile(FileName: PChar): Integer; cdecl; export;
begin
  if Windows.DeleteFile(FileName) then
    Result := 0
  else
    Result := GetLastError;
end;

function CreateGUID: PChar; cdecl; export;
var
  s: string;
  GUID: TGUID;
begin
  if SysUtils.CreateGUID(GUID) = S_OK then begin
    s := GUIDToString(GUID) + #0;
    Result := ib_util_malloc(Length(s));
    StrCopy(Result, PChar(s));
  end
  else
    Result := nil;
end;

exports
  Soundex, Upper, UpperBlob, SubString,
  SaveBlobToFile, LoadBlobFromFile,
  DeleteFile,
  FindFileFirst, FindFileNext,
  SearchFileName,
  ExtractFileName, ExtractFileAttr, ExtractFileSize,
  CreateGUID, Trim;

begin
end.

