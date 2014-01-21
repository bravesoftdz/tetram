library BDT_UDF;

uses
  Windows,
  SysUtils,
  Classes,
  IBExternals,
  IBUtils,
  Divers,
  ib_util in 'ib_util.pas',
  Math,
  AnsiStrings,
  StrUtils,
  unum in 'icu\lib\unum.pas',
  icu_globals in 'icu\lib\icu_globals.pas',
  utypes in 'icu\lib\utypes.pas',
  umachine in 'icu\lib\umachine.pas',
  umisc in 'icu\lib\umisc.pas',
  parseerr in 'icu\lib\parseerr.pas';

{$R *.res}

function CreateResult(const Chaine: AnsiString): PAnsiChar;
var
  s: AnsiString;
begin
  s := Chaine + #0;
  Result := ib_util_malloc(Length(s));
  AnsiStrings.StrCopy(Result, PAnsiChar(s));
end;

function Trim(Chaine: PAnsiChar): PAnsiChar; cdecl; export;
begin
  Result := CreateResult(AnsiStrings.Trim(Chaine));
end;

function Soundex(Chaine: PAnsiChar; var OrigineTitre: Integer): PAnsiChar; cdecl; export;
var
  s: string;
begin
  case OrigineTitre of
    1:
      s := BaseSoundex(string(Chaine), 'FR');
    2:
      s := BaseSoundex(string(Chaine), 'EN');
  else
    s := '';
  end;
  Result := CreateResult(AnsiString(s));
end;

function Upper(Chaine: PAnsiChar): PAnsiChar; cdecl; export;
begin
  Result := CreateResult(AnsiString(UpperCase(SansAccents(string(Chaine)))));
end;

procedure UpperBlob(BlobIn, BlobOut: PBlob); cdecl; export;
var
  buffer: array of Char;
  LongueurLue, i: Integer;
begin
  try
    if Assigned(BlobIn.BlobHandle) and (BlobIn.SegmentCount > 0) then
    begin
      SetLength(buffer, BlobIn.MaxSegmentLength);
      while LongBool(BlobIn.GetSegment(BlobIn.BlobHandle, @buffer[0], BlobIn.MaxSegmentLength, LongueurLue)) do
      begin
        for i := 0 to LongueurLue - 1 do
          buffer[i] := UpperCase(SansAccents(buffer[i]))[1];
        BlobOut.PutSegment(BlobOut.BlobHandle, @buffer[0], LongueurLue);
      end;
    end;
  except
  end; // pour être sûr de ne pas faire planter le serveur !!!!
end;

function SubString(Chaine: PAnsiChar; var Position, Longueur: Integer): PAnsiChar; cdecl; export;
begin
  Result := CreateResult(Copy(Chaine, Position, Longueur));
end;

function FormatTitre(const Titre: AnsiString): AnsiString;
var
  i, j: Integer;
  Dummy: AnsiString;
begin
  Result := Titre;
  try
    i := AnsiStrings.LastDelimiter('[', Titre);
    if i > 0 then
    begin
      j := AnsiStrings.PosEx(']', Titre, i);
      if j = 0 then
        Exit;
      Dummy := Copy(Titre, i + 1, j - i - 1);
      if Length(Dummy) > 0 then
        if Dummy[Length(Dummy)] <> '''' then
          Dummy := Dummy + ' ';
      Result := Dummy + Copy(Titre, 1, i - 1) + Copy(Titre, j + 1, Length(Titre));
    end;
  finally
    Result := AnsiStrings.Trim(Result);
  end;
end;

function FormatTitle(Titre: PAnsiChar): PAnsiChar; cdecl; export;
begin
  Result := CreateResult(FormatTitre(Titre));
end;

function LevenshteinDistance(s1, s2: PAnsiChar): Integer; cdecl; export;
const
  cost_ins = 1;
  cost_del = 1;
  cost_sub = 1;
var
  n1, n2: Integer;
  p, q, r: array of Integer;
  i, j: Integer;
var
  d_del, d_ins, d_sub: Integer;
begin
  n1 := Length(s1);
  n2 := Length(s2);

  SetLength(p, n2 + 1);
  SetLength(q, n2 + 1);

  p[0] := 0;
  for j := 1 to n2 do
    p[j] := p[j - 1] + cost_ins;

  for i := 1 to n1 do
  begin
    q[0] := p[0] + cost_del;
    for j := 1 to n2 do
    begin
      d_del := p[j] + cost_del;
      d_ins := q[j - 1] + cost_ins;
      d_sub := p[j - 1];
      if s1[i - 1] <> s2[j - 1] then
        Inc(d_sub, cost_sub);
      q[j] := Min(Min(d_del, d_ins), d_sub);
    end;
    r := p;
    p := q;
    q := r;
  end;

  Result := p[n2];
end;

function CompareChaines1(Chaine1, Chaine2: PAnsiChar): Float; cdecl; export;

  function DoCompare(const s1, s2: AnsiString): Float;
  var
    i, l: Integer;
    Str1, Str2: AnsiString;
  begin
    Result := 0;
    if s1 = s2 then
      Result := 100
    else
      try
        if Length(s1) > Length(s2) then
        begin
          Str1 := s2;
          Str2 := s1;
        end
        else
        begin
          Str1 := s1;
          Str2 := s2;
        end;

        for l := Length(Str1) downto 1 do
          for i := 1 to Length(Str2) - l + 1 do
            if Pos(Copy(Str2, i, l), Str1) > 0 then
            begin
              Result := l;
              Exit;
            end;
      finally
        // on converti en %
        Result := Result / Length(Str2) * 100;
      end;
  end;

  function ChercheMeilleurTaux(const Str1, Str2: AnsiString): Float;
  var
    s1, s2, F1, F2: AnsiString;
    r: Float;
  begin
    F1 := FormatTitre(Str1);
    F2 := FormatTitre(Str2);

    s1 := AnsiString(OnlyAlphaNum(string(Str1)));
    s2 := AnsiString(OnlyAlphaNum(string(Str2)));
    Result := DoCompare(s1, s2);
    if Result = 100 then
      Exit;

    if F2 <> Str2 then
    begin
      s2 := AnsiString(OnlyAlphaNum(string(F2)));
      r := DoCompare(s1, s2);
      if r > Result then
        Result := r;
      if Result = 100 then
        Exit;
    end;

    if F1 <> Str1 then
    begin
      s1 := AnsiString(OnlyAlphaNum(string(F1)));
      s2 := AnsiString(OnlyAlphaNum(string(Str2)));
      r := DoCompare(s1, s2);
      if r > Result then
        Result := r;
      if Result = 100 then
        Exit;

      if F2 <> Str2 then
      begin
        s2 := AnsiString(OnlyAlphaNum(string(F2)));
        r := DoCompare(s1, s2);
        if r > Result then
          Result := r;
        if Result = 100 then
          Exit;
      end;
    end;
  end;

begin
  Result := ChercheMeilleurTaux(AnsiString(UpperCase(SansAccents(string(Chaine1)))), AnsiString(UpperCase(SansAccents(string(Chaine2)))));
end;

function CompareChaines2(Chaine1, Chaine2: PAnsiChar): Float; cdecl; export;

  function DoCompare(const s1, s2: AnsiString): Float;
  var
    c, i, l, L1, L2: Integer;
    Str1, Str2: AnsiString;
  begin
    Result := 0;
    if s1 = s2 then
      Result := 100
    else
      try
        if Length(s1) > Length(s2) then
        begin
          Str1 := s2;
          Str2 := s1;
        end
        else
        begin
          Str1 := s1;
          Str2 := s2;
        end;

        L1 := Length(Str1);
        L2 := Length(Str2);

        for i := 1 - L1 to L2 - 1 do
        begin
          // si on n'a plus assez de caractères pour faire mieux on s'arrête
          if Result >= L2 - i then
            Exit;

          c := 0;
          for l := Max(1, 1 - i) to Min(L1, L2 - i) do
            if Str1[l] = Str2[i + l] then
              Inc(c);
          if c > Result then
          begin
            Result := c;
            // si on a retrouvé la chaine complète, on ne pourra pas faire mieux
            if Result = L1 then
              Exit;
          end;
        end;
      finally
        // on converti en %
        Result := Result / Length(Str2) * 100;
      end;
  end;

  function ChercheMeilleurTaux(const Str1, Str2: AnsiString): Float;
  var
    s1, s2, F1, F2: AnsiString;
    r: Float;
  begin
    F1 := FormatTitre(Str1);
    F2 := FormatTitre(Str2);

    s1 := AnsiString(OnlyAlphaNum(string(Str1)));
    s2 := AnsiString(OnlyAlphaNum(string(Str2)));
    Result := DoCompare(s1, s2);
    if Result = 100 then
      Exit;

    if F2 <> Str2 then
    begin
      s2 := AnsiString(OnlyAlphaNum(string(F2))); // OnlyAlphaNum(FormatTitre(Str2));
      r := DoCompare(s1, s2);
      if r > Result then
        Result := r;
      if Result = 100 then
        Exit;
    end;

    if F1 <> Str1 then
    begin
      s1 := AnsiString((string(F1)));
      s2 := AnsiString((string(Str2)));
      r := DoCompare(s1, s2);
      if r > Result then
        Result := r;
      if Result = 100 then
        Exit;

      if F2 <> Str2 then
      begin
        s2 := AnsiString(OnlyAlphaNum(string(F2))); // OnlyAlphaNum(FormatTitre(Str2));
        r := DoCompare(s1, s2);
        if r > Result then
          Result := r;
        if Result = 100 then
          Exit;
      end;
    end;
  end;

begin
  Result := ChercheMeilleurTaux(AnsiString(UpperCase(SansAccents(string(Chaine1)))), AnsiString(UpperCase(SansAccents(string(Chaine2)))));
end;

function CompareChaines(Chaine1, Chaine2: PAnsiChar): Float; cdecl; export;
begin
  Result := (CompareChaines1(Chaine1, Chaine2) + CompareChaines2(Chaine1, Chaine2)) / 2;
end;

function ValidFileName(const FileName: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(FileName) do
    if CharInSet(FileName[i], ['/', '\', ':', '*', '?', '"', '<', '>', '|']) then
      Result := Result + '_'
    else
      Result := Result + FileName[i];
end;

procedure WriteLog(Chaine: string);
begin
  with TStringList.Create do
    try
      if FileExists('G:\Programmation\MEDIA.KIT\BDthèque 1.0\UDF\bdt_udf.log') then
        LoadFromFile('G:\Programmation\MEDIA.KIT\BDthèque 1.0\UDF\bdt_udf.log');
      Add('-- ' + DateTimeToStr(Now) + ' --');
      Add(Chaine);
      SaveToFile('G:\Programmation\MEDIA.KIT\BDthèque 1.0\UDF\bdt_udf.log');
    finally
      free;
    end;
end;

function SaveBlobToFile(Path, FileName: PAnsiChar; Blob: PBlob): Integer; cdecl; export;
var
  buffer: array of AnsiChar;
  LongueurLue: Integer;
  BlobS: TMemoryStream;
begin
  try
    FileName := PAnsiChar(Path + AnsiString(ValidFileName(string(FileName))));
    BlobS := TMemoryStream.Create;
    with BlobS do
      try
        Seek(0, soBeginning);
        if Assigned(Blob.BlobHandle) and (Blob.SegmentCount > 0) then
        begin
          SetLength(buffer, Blob.MaxSegmentLength);
          while LongBool(Blob.GetSegment(Blob.BlobHandle, @buffer[0], Blob.MaxSegmentLength, LongueurLue)) do
            BlobS.Write(buffer[0], LongueurLue);

          ForceDirectories(string(Path));
          if FileExists(string(FileName)) then
            DeleteFileA(FileName);
          BlobS.SaveToFile(string(FileName));
        end;
        Result := BlobS.Size;
      finally
        free;
      end;
  except
    Result := 0;
  end; // pour être sûr de ne pas faire planter le serveur !!!!
end;

procedure LoadBlobFromFile(Path, FileName: PAnsiChar; Blob: PBlob); cdecl; export;
var
  buffer: array [0 .. 4095] of Char;
  FS: TFileStream;
begin
  try
    FileName := PAnsiChar(Path + AnsiString(ValidFileName(string(FileName))));
    if not FileExists(string(FileName)) then
      Exit;

    FS := TFileStream.Create(string(FileName), fmOpenRead or fmShareDenyWrite);
    with FS do
      try
        while Position < Size do
          Blob.PutSegment(Blob.BlobHandle, @buffer[0], Read(buffer, Length(buffer)));
      finally
        free;
      end;
  except
  end; // pour être sûr de ne pas faire planter le serveur !!!!
end;

type
  PSearchRec = ^TSearchRec;

function FindFileFirst(Path: PAnsiChar; var Attr: Integer): PSearchRec; cdecl; export;
var
  i: Integer;
begin
  New(Result);
  i := FindFirst(string(Path), Attr, Result^);
  if i <> 0 then
  begin
    FindClose(Result^);
    Dispose(Result);
    Result := PSearchRec(-i);
  end;
end;

function FindFileNext(var Sr: PSearchRec): PSearchRec; cdecl; export;
var
  i: Integer;
begin
  Result := Sr;
  i := FindNext(Result^);
  if i <> 0 then
  begin
    FindClose(Result^);
    Dispose(Result);
    Result := PSearchRec(-i);
  end;
end;

function ExtractFileName(var Sr: PSearchRec): PAnsiChar; cdecl; export;
begin
  Result := CreateResult(AnsiString(Sr^.Name));
end;

function ExtractFileAttr(var Sr: PSearchRec): Integer; cdecl; export;
begin
  Result := Sr^.Attr;
end;

function ExtractFileSize(var Sr: PSearchRec): Integer; cdecl; export;
begin
  Result := Sr^.Size;
end;

function SearchFileName(Path, FileName: PAnsiChar; var Reserve: Integer): PAnsiChar; cdecl; export;
var
  toAdd, Fichier, ext: string;
  Index: Integer;
begin
  ext := ExtractFileExt(string(FileName));
  Fichier := IncludeTrailingPathDelimiter(string(Path)) + ChangeFileExt(string(FileName), '');
  Index := 0;
  toAdd := ext;
  while FileExists(Fichier + toAdd) do
  begin
    Inc(Index);
    toAdd := Format(' (%d)%s', [Index, ext]);
  end;
  if Reserve <> 0 then
  begin
    ForceDirectories(string(Path));
    TFileStream.Create(Fichier + toAdd, fmCreate).free;
  end;
  Result := CreateResult(AnsiString(Fichier + toAdd));
end;

function DeleteFile(FileName: PAnsiChar): Integer; cdecl; export;
begin
  if Windows.DeleteFileA(FileName) then
    Result := 0
  else
    Result := GetLastError;
end;

function CreateGUID: PAnsiChar; cdecl; export;
var
  GUID: TGUID;
begin
  if SysUtils.CreateGUID(GUID) = S_OK then
    Result := CreateResult(AnsiString(GUIDToString(GUID)))
  else
    Result := nil;
end;

function UDFLength(Chaine: PAnsiChar): Integer; cdecl; export;
begin
  Result := AnsiStrings.StrLen(Chaine);
end;

exports
  Soundex, Upper, UpperBlob, SubString,
  SaveBlobToFile, LoadBlobFromFile,
  DeleteFile,
  FindFileFirst, FindFileNext,
  SearchFileName,
  ExtractFileName, ExtractFileAttr, ExtractFileSize,
  CreateGUID, Trim,
  CompareChaines name 'IdenticalString',
  CompareChaines1 name 'IdenticalString1',
  CompareChaines2 name 'IdenticalString2',
  FormatTitle,
  UDFLength name 'Length',
  LevenshteinDistance;

begin

end.
