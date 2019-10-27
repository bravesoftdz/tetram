unit BDTK.Updates.v1_2_3_14;

interface

implementation

uses
  UIB, BDTK.Updates;

procedure MAJ1_2_3_14(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add
    ('DECLARE EXTERNAL FUNCTION UDF_IDENTICALSTRING CSTRING(32767), CSTRING(32767) RETURNS FLOAT BY VALUE ENTRY_POINT ''IdenticalString'' MODULE_NAME ''BDT_UDF.dll'';');
  Query.Script.Add
    ('DECLARE EXTERNAL FUNCTION UDF_IDENTICALSTRING1 CSTRING(32767), CSTRING(32767) RETURNS FLOAT BY VALUE ENTRY_POINT ''IdenticalString1'' MODULE_NAME ''BDT_UDF.dll'';');
  Query.Script.Add
    ('DECLARE EXTERNAL FUNCTION UDF_IDENTICALSTRING2 CSTRING(32767), CSTRING(32767) RETURNS FLOAT BY VALUE ENTRY_POINT ''IdenticalString2'' MODULE_NAME ''BDT_UDF.dll'';');
  Query.Script.Add('DECLARE EXTERNAL FUNCTION UDF_LENGTH CSTRING(32767) RETURNS INTEGER BY VALUE ENTRY_POINT ''Length'' MODULE_NAME ''BDT_UDF.dll'';');
  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('1.2.3.14', @MAJ1_2_3_14);

end.
