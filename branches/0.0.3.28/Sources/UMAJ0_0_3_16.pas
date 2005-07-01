unit UMAJ0_0_3_16;

interface

implementation

uses JvUIB, Updates;

procedure MAJ0_0_3_16(Query: TJvUIBScript);
begin
  with Query do begin
    Script.Clear;

    Script.Add('DECLARE EXTERNAL FUNCTION UDF_DELETEFILE');
    Script.Add('    CSTRING(32767)');
    Script.Add('RETURNS INTEGER BY VALUE');
    Script.Add('ENTRY_POINT ''DeleteFile'' MODULE_NAME ''BDT_UDF.dll'';');

    Script.Add('CREATE PROCEDURE DELETEFILE (');
    Script.Add('    FICHIER VARCHAR(255) CHARACTER SET NONE)');
    Script.Add('RETURNS (');
    Script.Add('    RESULT INTEGER)');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  select UDF_DELETEFILE(:Fichier) from rdb$database into :Result;');
    Script.Add('  suspend;');
    Script.Add('end;');

    ExecuteScript;
  end;
end;

initialization
  RegisterUpdate('0.0.3.16', @MAJ0_0_3_16);

end.
