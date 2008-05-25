unit UMAJ0_0_1_2;

interface

implementation

uses JvUIB, Updates;

procedure MAJ0_0_1_2(Query: TJvUIBScript);
begin
  with Query do begin
    Script.Clear;
    Script.Add('ALTER PROCEDURE LOADBLOBFROMFILE (');
    Script.Add('    CHEMIN VARCHAR(255),');
    Script.Add('    FICHIER VARCHAR(255))');
    Script.Add('RETURNS (');
    Script.Add('    BLOBCONTENT BLOB SUB_TYPE 0 SEGMENT SIZE 80)');
    Script.Add('AS');
    Script.Add('BEGIN');
    Script.Add('END;');

    Script.Add('DROP EXTERNAL FUNCTION UDF_LOADBLOBFROMFILE;');
    Script.Add('DECLARE EXTERNAL FUNCTION UDF_LOADBLOBFROMFILE');
    Script.Add('    CSTRING(32767),');
    Script.Add('    CSTRING(32767),');
    Script.Add('    BLOB');
    Script.Add('RETURNS PARAMETER 3');
    Script.Add('ENTRY_POINT ''LoadBlobFromFile'' MODULE_NAME ''BDT_UDF.dll'';');

    Script.Add('ALTER PROCEDURE LOADBLOBFROMFILE (');
    Script.Add('    CHEMIN VARCHAR(255),');
    Script.Add('    FICHIER VARCHAR(255))');
    Script.Add('RETURNS (');
    Script.Add('    BLOBCONTENT BLOB SUB_TYPE 0 SEGMENT SIZE 80)');
    Script.Add('AS');
    Script.Add('BEGIN');
    Script.Add('  select udf_loadblobfromfile(:chemin, :fichier) from rdb$database into :blobcontent;');
    Script.Add('  suspend;');
    Script.Add('END;');

    Script.Add('ALTER PROCEDURE SAVEBLOBTOFILE (');
    Script.Add('    CHEMIN VARCHAR(255),');
    Script.Add('    FICHIER VARCHAR(255),');
    Script.Add('    BLOBCONTENT BLOB SUB_TYPE 0 SEGMENT SIZE 80)');
    Script.Add('RETURNS (');
    Script.Add('    RESULT BLOB SUB_TYPE 0 SEGMENT SIZE 80)');
    Script.Add('AS');
    Script.Add('BEGIN');
    Script.Add('END;');

    Script.Add('DROP EXTERNAL FUNCTION UDF_SAVEBLOBTOFILE;');
    Script.Add('DECLARE EXTERNAL FUNCTION UDF_SAVEBLOBTOFILE');
    Script.Add('    CSTRING(32767),');
    Script.Add('    CSTRING(32767),');
    Script.Add('    BLOB');
    Script.Add('RETURNS INTEGER BY VALUE');
    Script.Add('ENTRY_POINT ''SaveBlobToFile'' MODULE_NAME ''BDT_UDF.dll'';');

    Script.Add('ALTER PROCEDURE SAVEBLOBTOFILE (');
    Script.Add('    CHEMIN VARCHAR(255),');
    Script.Add('    FICHIER VARCHAR(255),');
    Script.Add('    BLOBCONTENT BLOB SUB_TYPE 0 SEGMENT SIZE 80)');
    Script.Add('RETURNS (');
    Script.Add('    RESULT BLOB SUB_TYPE 0 SEGMENT SIZE 80)');
    Script.Add('AS');
    Script.Add('BEGIN');
    Script.Add('  select udf_saveblobtofile(:chemin, :fichier, :blobcontent) from rdb$database into :result;');
    Script.Add('  suspend;');
    Script.Add('END;');

    Script.Add('DROP EXTERNAL FUNCTION UDF_SUBSTRING;');
    Script.Add('DECLARE EXTERNAL FUNCTION UDF_SUBSTRING');
    Script.Add('    CSTRING(32767),');
    Script.Add('    INTEGER,');
    Script.Add('    INTEGER');
    Script.Add('RETURNS CSTRING(32767) FREE_IT');
    Script.Add('ENTRY_POINT ''SubString'' MODULE_NAME ''BDT_UDF.dll'';');

    Script.Add('ALTER TRIGGER SERIES_DV');
    Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('end;');

    Script.Add('ALTER TRIGGER PERSONNES_DV');
    Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('end;');

    Script.Add('ALTER TRIGGER GENRES_DV');
    Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('end;');

    Script.Add('ALTER TRIGGER EMPRUNTEURS_DV');
    Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('end;');

    Script.Add('ALTER TRIGGER EDITEURS_DV');
    Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('end;');

    Script.Add('ALTER TRIGGER COLLECTIONS_DV');
    Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('end;');

    Script.Add('ALTER TRIGGER ALBUMS_DV');
    Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('end;');

    Script.Add('ALTER TABLE SERIES ADD SOUNDEXTITRESERIE VARCHAR(30);');
    Script.Add('ALTER TABLE ALBUMS ALTER TITRESOUNDEXALBUM TO SOUNDEXTITREALBUM;');

    Script.Add('DROP EXTERNAL FUNCTION UDF_SOUNDEX;');
    Script.Add('DECLARE EXTERNAL FUNCTION UDF_SOUNDEX');
    Script.Add('    CSTRING(32767),');
    Script.Add('    INTEGER');
    Script.Add('RETURNS CSTRING(32767) FREE_IT');
    Script.Add('ENTRY_POINT ''Soundex'' MODULE_NAME ''BDT_UDF.dll'';');

    Script.Add('DROP EXTERNAL FUNCTION UDF_UPPER;');
    Script.Add('DECLARE EXTERNAL FUNCTION UDF_UPPER');
    Script.Add('    CSTRING(32767)');
    Script.Add('RETURNS CSTRING(32767) FREE_IT');
    Script.Add('ENTRY_POINT ''Upper'' MODULE_NAME ''BDT_UDF.dll'';');

    Script.Add('ALTER TRIGGER SERIES_DV');
    Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  if (inserting or new.titreserie <> old.titreserie) then begin');
    Script.Add('    new.uppertitreserie = UDF_UPPER(new.titreserie);');
    Script.Add('    new.SoundexTitreSerie = UDF_SOUNDEX(new.TitreSerie, 1);');
    Script.Add('    select initiale from get_initiale(new.uppertitreserie) into new.initialetitreserie;');
    Script.Add('  end');
    Script.Add('end;');

    Script.Add('ALTER TRIGGER PERSONNES_DV');
    Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  if (inserting or New.NomPersonne <> Old.NomPersonne) then begin');
    Script.Add('    New.UpperNomPersonne = UDF_UPPER(New.NomPersonne);');
    Script.Add('    select initiale from get_initiale(new.UpperNomPersonne) into new.initialenompersonne;');
    Script.Add('  end');
    Script.Add('end;');

    Script.Add('ALTER TRIGGER GENRES_DV');
    Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  if (INSERTING or New.Genre <> Old.Genre) then begin');
    Script.Add('    New.UpperGenre = UDF_UPPER(New.Genre);');
    Script.Add('    select initiale from get_initiale(new.UpperGenre) into new.initialeGenre;');
    Script.Add('  end');
    Script.Add('end;');

    Script.Add('ALTER TRIGGER EMPRUNTEURS_DV');
    Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  if (inserting or new.NomEmprunteur <> old.NomEmprunteur) then begin');
    Script.Add('    New.UpperNomEmprunteur = UDF_UPPER(New.NomEmprunteur);');
    Script.Add('    select initiale from get_initiale(new.UpperNomEmprunteur) into new.initialenomemprunteur;');
    Script.Add('  end');
    Script.Add('end;');

    Script.Add('ALTER TRIGGER EDITEURS_DV');
    Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  if (inserting or new.nomediteur <> old.nomediteur) then begin');
    Script.Add('    new.uppernomediteur = UDF_UPPER(new.nomediteur);');
    Script.Add('    select initiale from get_initiale(new.uppernomediteur) into new.initialenomediteur;');
    Script.Add('  end');
    Script.Add('end;');

    Script.Add('ALTER TRIGGER COLLECTIONS_DV');
    Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  if (inserting or new.nomcollection <> old.nomcollection) then begin');
    Script.Add('    new.uppernomcollection = UDF_UPPER(new.nomcollection);');
    Script.Add('    select initiale from get_initiale(new.uppernomcollection) into new.initialenomcollection;');
    Script.Add('  end');
    Script.Add('end;');

    Script.Add('ALTER TRIGGER ALBUMS_DV');
    Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  if (inserting or new.TitreAlbum <> old.TitreAlbum) then begin');
    Script.Add('    new.UpperTitreAlbum = UDF_UPPER(new.TitreAlbum);');
    Script.Add('    new.SoundexTitreAlbum = UDF_SOUNDEX(new.TitreAlbum, 1);');
    Script.Add('    select initiale from get_initiale(new.UpperTitreAlbum) into new.initialetitreAlbum;');
    Script.Add('  end');
    Script.Add('end;');

    Script.Add('UPDATE SERIES SET SoundexTitreSerie = UDF_SOUNDEX(TitreSerie, 1);');

    ExecuteScript;
  end;
end;

initialization
  RegisterFBUpdate('0.0.1.2', @MAJ0_0_1_2);

end.
