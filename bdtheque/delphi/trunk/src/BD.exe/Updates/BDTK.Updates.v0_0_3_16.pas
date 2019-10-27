unit BDTK.Updates.v0_0_3_16;

interface

implementation

uses
  UIB, BDTK.Updates;

procedure MAJ0_0_3_16(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add('DECLARE EXTERNAL FUNCTION UDF_DELETEFILE');
  Query.Script.Add('    CSTRING(32767)');
  Query.Script.Add('RETURNS INTEGER BY VALUE');
  Query.Script.Add('ENTRY_POINT ''DeleteFile'' MODULE_NAME ''BDT_UDF.dll'';');

  Query.Script.Add('CREATE PROCEDURE DELETEFILE (');
  Query.Script.Add('    FICHIER VARCHAR(255) CHARACTER SET NONE)');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    RESULT INTEGER)');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  select UDF_DELETEFILE(:Fichier) from rdb$database into :Result;');
  Query.Script.Add('  suspend;');
  Query.Script.Add('end;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('0.0.3.16', @MAJ0_0_3_16);

end.
