unit UMAJ1_2_3_14;

interface

implementation

uses JvUIB, Updates;

procedure MAJ1_2_3_14(Query: TJvUIBScript);
begin
  with Query do begin
    Script.Clear;

    Script.Add('DECLARE EXTERNAL FUNCTION UDF_IDENTICALSTRING CSTRING(32767), CSTRING(32767) RETURNS FLOAT BY VALUE ENTRY_POINT ''IdenticalString'' MODULE_NAME ''BDT_UDF.dll'';');
    Script.Add('DECLARE EXTERNAL FUNCTION UDF_IDENTICALSTRING1 CSTRING(32767), CSTRING(32767) RETURNS FLOAT BY VALUE ENTRY_POINT ''IdenticalString1'' MODULE_NAME ''BDT_UDF.dll'';');
    Script.Add('DECLARE EXTERNAL FUNCTION UDF_IDENTICALSTRING2 CSTRING(32767), CSTRING(32767) RETURNS FLOAT BY VALUE ENTRY_POINT ''IdenticalString2'' MODULE_NAME ''BDT_UDF.dll'';');
    Script.Add('DECLARE EXTERNAL FUNCTION UDF_LENGTH CSTRING(32767) RETURNS INTEGER BY VALUE ENTRY_POINT ''Length'' MODULE_NAME ''BDT_UDF.dll'';');
    ExecuteScript;
  end;
end;

initialization
  RegisterFBUpdate('1.2.3.14', @MAJ1_2_3_14);

end.

