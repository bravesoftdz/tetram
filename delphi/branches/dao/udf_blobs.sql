DECLARE EXTERNAL FUNCTION UDF_LOADBLOBFROMFILE
    CSTRING(32767),
    CSTRING(32767),
    BLOB
    RETURNS PARAMETER 3
    ENTRY_POINT 'LoadBlobFromFile' MODULE_NAME 'VDO_UDF.dll';


DECLARE EXTERNAL FUNCTION UDF_SAVEBLOBTOFILE
    CSTRING(32767),
    CSTRING(32767),
    BLOB
    RETURNS INTEGER BY VALUE
    ENTRY_POINT 'SaveBlobToFile' MODULE_NAME 'VDO_UDF.dll';




SET TERM ^ ; 

CREATE PROCEDURE LOADBLOBFROMFILE (
    CHEMIN VARCHAR(255),
    FICHIER VARCHAR(255))
RETURNS (
    BLOBCONTENT BLOB sub_type 0 segment size 80)
AS
BEGIN
  select udf_loadblobfromfile(:chemin, :fichier) from rdb$database into :blobcontent;
  suspend;
END^

CREATE PROCEDURE SAVEBLOBTOFILE (
    CHEMIN VARCHAR(255),
    FICHIER VARCHAR(255),
    BLOBCONTENT BLOB sub_type 0 segment size 80)
RETURNS (
    RESULT BLOB sub_type 0 segment size 80)
AS
BEGIN
  select udf_saveblobtofile(:chemin, :fichier, :blobcontent) from rdb$database into :result;
  suspend;
END^

SET TERM ; ^
