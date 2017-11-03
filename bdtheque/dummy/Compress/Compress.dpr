program Compress;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Classes,
  Masks,
  ShellApi,
  ZipMstr;

var
  Zip: TZipMaster;
  i, j: Integer;
  p: string;
  hasRemove: Boolean;

begin
  Zip := TZipMaster.Create(nil);
  hasRemove := False;
  try
    i := 1;
    while i < ParamCount do
    begin
      p := ParamStr(i);
      if p = '-o' then
      begin
        Inc(i);
        Zip.ZipFileName := ParamStr(i);
      end
      else if p = '-x' then
      begin
        Inc(i);
        Zip.FSpecArgsExcl.Add(ParamStr(i));
      end
      else if p = '-i' then
      begin
        Inc(i);
        Zip.FSpecArgs.Add(ParamStr(i));
      end
      else if p = '-rd' then
      begin
        Inc(i);
        Zip.RootDir := ParamStr(i);
      end
      else if p = '-r' then
      begin
        with Zip do
          AddOptions := AddOptions + [AddRecurseDirs, AddDirNames];
      end
      else if p = '-rm' then
      begin
        hasRemove := True;
      end
      else if p = '-l' then
      begin
        with TStringList.Create do
        try
          Inc(i);
          LoadFromFile(ParamStr(i));
          for j := 0 to Pred(Count) do
            ShelleXecute(0, nil, PChar(ParamStr(0)), PChar(Strings[j]), nil, 0);
        finally
          Free;
        end;
      end;

      Inc(i);
    end;

    if Zip.FSpecArgs.Count > 0 then
    begin
      if hasRemove then DeleteFile(Zip.ZipFileName);
      Zip.Add;
    end;
  finally
    Zip.Free;
  end;
end.

