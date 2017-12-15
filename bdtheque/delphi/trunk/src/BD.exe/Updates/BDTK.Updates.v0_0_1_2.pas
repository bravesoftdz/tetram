unit BDTK.Updates.v0_0_1_2;

interface

implementation

uses UIB, BDTK.Updates;

procedure MAJ0_0_1_2(Query: TUIBScript);
begin
  Query.Script.Clear;
  Query.Script.Add('ALTER PROCEDURE LOADBLOBFROMFILE (');
  Query.Script.Add('    CHEMIN VARCHAR(255),');
  Query.Script.Add('    FICHIER VARCHAR(255))');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    BLOBCONTENT BLOB SUB_TYPE 0 SEGMENT SIZE 80)');
  Query.Script.Add('AS');
  Query.Script.Add('BEGIN');
  Query.Script.Add('END;');

  Query.Script.Add('DROP EXTERNAL FUNCTION UDF_LOADBLOBFROMFILE;');
  Query.Script.Add('DECLARE EXTERNAL FUNCTION UDF_LOADBLOBFROMFILE');
  Query.Script.Add('    CSTRING(32767),');
  Query.Script.Add('    CSTRING(32767),');
  Query.Script.Add('    BLOB');
  Query.Script.Add('RETURNS PARAMETER 3');
  Query.Script.Add('ENTRY_POINT ''LoadBlobFromFile'' MODULE_NAME ''BDT_UDF.dll'';');

  Query.Script.Add('ALTER PROCEDURE LOADBLOBFROMFILE (');
  Query.Script.Add('    CHEMIN VARCHAR(255),');
  Query.Script.Add('    FICHIER VARCHAR(255))');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    BLOBCONTENT BLOB SUB_TYPE 0 SEGMENT SIZE 80)');
  Query.Script.Add('AS');
  Query.Script.Add('BEGIN');
  Query.Script.Add('  select udf_loadblobfromfile(:chemin, :fichier) from rdb$database into :blobcontent;');
  Query.Script.Add('  suspend;');
  Query.Script.Add('END;');

  Query.Script.Add('ALTER PROCEDURE SAVEBLOBTOFILE (');
  Query.Script.Add('    CHEMIN VARCHAR(255),');
  Query.Script.Add('    FICHIER VARCHAR(255),');
  Query.Script.Add('    BLOBCONTENT BLOB SUB_TYPE 0 SEGMENT SIZE 80)');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    RESULT BLOB SUB_TYPE 0 SEGMENT SIZE 80)');
  Query.Script.Add('AS');
  Query.Script.Add('BEGIN');
  Query.Script.Add('END;');

  Query.Script.Add('DROP EXTERNAL FUNCTION UDF_SAVEBLOBTOFILE;');
  Query.Script.Add('DECLARE EXTERNAL FUNCTION UDF_SAVEBLOBTOFILE');
  Query.Script.Add('    CSTRING(32767),');
  Query.Script.Add('    CSTRING(32767),');
  Query.Script.Add('    BLOB');
  Query.Script.Add('RETURNS INTEGER BY VALUE');
  Query.Script.Add('ENTRY_POINT ''SaveBlobToFile'' MODULE_NAME ''BDT_UDF.dll'';');

  Query.Script.Add('ALTER PROCEDURE SAVEBLOBTOFILE (');
  Query.Script.Add('    CHEMIN VARCHAR(255),');
  Query.Script.Add('    FICHIER VARCHAR(255),');
  Query.Script.Add('    BLOBCONTENT BLOB SUB_TYPE 0 SEGMENT SIZE 80)');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    RESULT BLOB SUB_TYPE 0 SEGMENT SIZE 80)');
  Query.Script.Add('AS');
  Query.Script.Add('BEGIN');
  Query.Script.Add('  select udf_saveblobtofile(:chemin, :fichier, :blobcontent) from rdb$database into :result;');
  Query.Script.Add('  suspend;');
  Query.Script.Add('END;');

  Query.Script.Add('DROP EXTERNAL FUNCTION UDF_SUBSTRING;');
  Query.Script.Add('DECLARE EXTERNAL FUNCTION UDF_SUBSTRING');
  Query.Script.Add('    CSTRING(32767),');
  Query.Script.Add('    INTEGER,');
  Query.Script.Add('    INTEGER');
  Query.Script.Add('RETURNS CSTRING(32767) FREE_IT');
  Query.Script.Add('ENTRY_POINT ''SubString'' MODULE_NAME ''BDT_UDF.dll'';');

  Query.Script.Add('ALTER TRIGGER SERIES_DV');
  Query.Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER TRIGGER PERSONNES_DV');
  Query.Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER TRIGGER GENRES_DV');
  Query.Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER TRIGGER EMPRUNTEURS_DV');
  Query.Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER TRIGGER EDITEURS_DV');
  Query.Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER TRIGGER COLLECTIONS_DV');
  Query.Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER TRIGGER ALBUMS_DV');
  Query.Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER TABLE SERIES ADD SOUNDEXTITRESERIE VARCHAR(30);');
  Query.Script.Add('ALTER TABLE ALBUMS ALTER TITRESOUNDEXALBUM TO SOUNDEXTITREALBUM;');

  Query.Script.Add('DROP EXTERNAL FUNCTION UDF_SOUNDEX;');
  Query.Script.Add('DECLARE EXTERNAL FUNCTION UDF_SOUNDEX');
  Query.Script.Add('    CSTRING(32767),');
  Query.Script.Add('    INTEGER');
  Query.Script.Add('RETURNS CSTRING(32767) FREE_IT');
  Query.Script.Add('ENTRY_POINT ''Soundex'' MODULE_NAME ''BDT_UDF.dll'';');

  Query.Script.Add('DROP EXTERNAL FUNCTION UDF_UPPER;');
  Query.Script.Add('DECLARE EXTERNAL FUNCTION UDF_UPPER');
  Query.Script.Add('    CSTRING(32767)');
  Query.Script.Add('RETURNS CSTRING(32767) FREE_IT');
  Query.Script.Add('ENTRY_POINT ''Upper'' MODULE_NAME ''BDT_UDF.dll'';');

  Query.Script.Add('ALTER TRIGGER SERIES_DV');
  Query.Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  if (inserting or new.titreserie <> old.titreserie) then begin');
  Query.Script.Add('    new.uppertitreserie = UDF_UPPER(new.titreserie);');
  Query.Script.Add('    new.SoundexTitreSerie = UDF_SOUNDEX(new.TitreSerie, 1);');
  Query.Script.Add('    select initiale from get_initiale(new.uppertitreserie) into new.initialetitreserie;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER TRIGGER PERSONNES_DV');
  Query.Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  if (inserting or New.NomPersonne <> Old.NomPersonne) then begin');
  Query.Script.Add('    New.UpperNomPersonne = UDF_UPPER(New.NomPersonne);');
  Query.Script.Add('    select initiale from get_initiale(new.UpperNomPersonne) into new.initialenompersonne;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER TRIGGER GENRES_DV');
  Query.Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  if (INSERTING or New.Genre <> Old.Genre) then begin');
  Query.Script.Add('    New.UpperGenre = UDF_UPPER(New.Genre);');
  Query.Script.Add('    select initiale from get_initiale(new.UpperGenre) into new.initialeGenre;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER TRIGGER EMPRUNTEURS_DV');
  Query.Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  if (inserting or new.NomEmprunteur <> old.NomEmprunteur) then begin');
  Query.Script.Add('    New.UpperNomEmprunteur = UDF_UPPER(New.NomEmprunteur);');
  Query.Script.Add('    select initiale from get_initiale(new.UpperNomEmprunteur) into new.initialenomemprunteur;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER TRIGGER EDITEURS_DV');
  Query.Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  if (inserting or new.nomediteur <> old.nomediteur) then begin');
  Query.Script.Add('    new.uppernomediteur = UDF_UPPER(new.nomediteur);');
  Query.Script.Add('    select initiale from get_initiale(new.uppernomediteur) into new.initialenomediteur;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER TRIGGER COLLECTIONS_DV');
  Query.Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  if (inserting or new.nomcollection <> old.nomcollection) then begin');
  Query.Script.Add('    new.uppernomcollection = UDF_UPPER(new.nomcollection);');
  Query.Script.Add('    select initiale from get_initiale(new.uppernomcollection) into new.initialenomcollection;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER TRIGGER ALBUMS_DV');
  Query.Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  if (inserting or new.TitreAlbum <> old.TitreAlbum) then begin');
  Query.Script.Add('    new.UpperTitreAlbum = UDF_UPPER(new.TitreAlbum);');
  Query.Script.Add('    new.SoundexTitreAlbum = UDF_SOUNDEX(new.TitreAlbum, 1);');
  Query.Script.Add('    select initiale from get_initiale(new.UpperTitreAlbum) into new.initialetitreAlbum;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.Script.Add('UPDATE SERIES SET SoundexTitreSerie = UDF_SOUNDEX(TitreSerie, 1);');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('0.0.1.2', @MAJ0_0_1_2);

end.
