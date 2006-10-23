unit UMAJ1_2_3_3;

interface

implementation

uses JvUIB, Updates;

procedure MAJ1_2_3_3(Query: TJvUIBScript);
begin
  with Query do begin
    Script.Clear;
    Script.Add('ALTER TABLE SERIES ALTER TITRESERIE TYPE VARCHAR(255), UPPERTITRESERIE TYPE VARCHAR(255);');
    Script.Add('ALTER TABLE ALBUMS ALTER TITREALBUM TYPE VARCHAR(255), UPPERTITREALBUM TYPE VARCHAR(255);');
    Script.Add('ALTER TABLE PARABD ALTER TITREPARABD TYPE VARCHAR(255), UPPERTITREPARABD TYPE VARCHAR(255);');

    ExecuteScript;
  end;
end;

initialization
  RegisterUpdate('1.2.3.3', @MAJ1_2_3_3);

end.
