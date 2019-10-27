unit BDTK.Updates.v0_0_3_07;

interface

implementation

uses
  UIB, BDTK.Updates;

procedure MAJ0_0_3_07(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add('alter table options alter valeur type varchar(255);');

  Query.Script.Add('DECLARE EXTERNAL FUNCTION UDF_FINDFILEFIRST');
  Query.Script.Add('    CSTRING(32767),');
  Query.Script.Add('    INTEGER');
  Query.Script.Add('RETURNS INTEGER BY VALUE');
  Query.Script.Add('ENTRY_POINT ''FindFileFirst'' MODULE_NAME ''BDT_UDF.dll'';');

  Query.Script.Add('DECLARE EXTERNAL FUNCTION UDF_FINDFILENEXT');
  Query.Script.Add('    INTEGER');
  Query.Script.Add('RETURNS INTEGER BY VALUE');
  Query.Script.Add('ENTRY_POINT ''FindFileNext'' MODULE_NAME ''BDT_UDF.dll'';');

  Query.Script.Add('DECLARE EXTERNAL FUNCTION UDF_EXTRACTFILESIZE');
  Query.Script.Add('    INTEGER');
  Query.Script.Add('RETURNS INTEGER BY VALUE');
  Query.Script.Add('ENTRY_POINT ''ExtractFileSize'' MODULE_NAME ''BDT_UDF.dll'';');

  Query.Script.Add('DECLARE EXTERNAL FUNCTION UDF_EXTRACTFILENAME');
  Query.Script.Add('    INTEGER');
  Query.Script.Add('RETURNS CSTRING(32767) FREE_IT');
  Query.Script.Add('ENTRY_POINT ''ExtractFileName'' MODULE_NAME ''BDT_UDF.dll'';');

  Query.Script.Add('DECLARE EXTERNAL FUNCTION UDF_EXTRACTFILEATTR');
  Query.Script.Add('    INTEGER');
  Query.Script.Add('RETURNS INTEGER BY VALUE');
  Query.Script.Add('ENTRY_POINT ''ExtractFileAttr'' MODULE_NAME ''BDT_UDF.dll'';');

  Query.Script.Add('DECLARE EXTERNAL FUNCTION UDF_SEARCHFILENAME');
  Query.Script.Add('    CSTRING(32767),');
  Query.Script.Add('    CSTRING(32767),');
  Query.Script.Add('    INTEGER');
  Query.Script.Add('RETURNS CSTRING(32767) FREE_IT');
  Query.Script.Add('ENTRY_POINT ''SearchFileName'' MODULE_NAME ''BDT_UDF.dll'';');

  Query.Script.Add('CREATE PROCEDURE SEARCHFILENAME (');
  Query.Script.Add('    CHEMIN VARCHAR(255),');
  Query.Script.Add('    OLD_FILENAME VARCHAR(255),');
  Query.Script.Add('    RESERVE INTEGER)');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    NEW_FILENAME VARCHAR(255))');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  select udf_searchfilename(:chemin, :old_filename, :reserve) from rdb$database into :NEW_FILENAME;');
  Query.Script.Add('  suspend;');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE PROCEDURE DIRECTORYCONTENT (');
  Query.Script.Add('    CHEMIN VARCHAR(255),');
  Query.Script.Add('    SEARCHATTR INTEGER)');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    SEARCHREC INTEGER,');
  Query.Script.Add('    FILENAME VARCHAR(255),');
  Query.Script.Add('    FILESIZE INTEGER,');
  Query.Script.Add('    FILEATTR INTEGER)');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  select udf_findfilefirst(:chemin, :searchattr) from rdb$database into :searchrec;');
  Query.Script.Add('  if (searchrec < 0) then');
  Query.Script.Add('    suspend;');
  Query.Script.Add('  else while (searchrec > 0) do begin');
  Query.Script.Add('    select');
  Query.Script.Add('      udf_extractfilename(:searchrec),');
  Query.Script.Add('      udf_extractfilesize(:searchrec),');
  Query.Script.Add('      udf_extractfileattr(:searchrec)');
  Query.Script.Add('    from rdb$database');
  Query.Script.Add('    into');
  Query.Script.Add('      :FileName,');
  Query.Script.Add('      :FileSIZE,');
  Query.Script.Add('      :FileATTR;');
  Query.Script.Add('    select udf_findfilenext(:searchrec) from rdb$database into :searchrec;');
  Query.Script.Add('    suspend;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER PROCEDURE SAVEBLOBTOFILE (');
  Query.Script.Add('    CHEMIN VARCHAR(255),');
  Query.Script.Add('    FICHIER VARCHAR(255),');
  Query.Script.Add('    BLOBCONTENT BLOB SUB_TYPE 0 SEGMENT SIZE 80)');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    RESULT INTEGER)');
  Query.Script.Add('AS');
  Query.Script.Add('BEGIN');
  Query.Script.Add('  select udf_saveblobtofile(:chemin, :fichier, :blobcontent) from rdb$database into :result;');
  Query.Script.Add('  suspend;');
  Query.Script.Add('END;');

  Query.Script.Add('CREATE TABLE AUTEURS_SERIES (');
  Query.Script.Add('    REFSERIE     T_REFNOTNULL,');
  Query.Script.Add('    REFPERSONNE  T_REFNOTNULL,');
  Query.Script.Add('    METIER       SMALLINT NOT NULL');
  Query.Script.Add(');');

  Query.Script.Add('ALTER TABLE AUTEURS_SERIES ADD CONSTRAINT PK_AUTEURS_SERIES PRIMARY KEY (REFSERIE, REFPERSONNE, METIER);');
  Query.Script.Add
    ('ALTER TABLE AUTEURS_SERIES ADD CONSTRAINT FK_AUTEURS_SERIES_REFFILM FOREIGN KEY (REFSERIE) REFERENCES SERIES (REFSERIE) ON DELETE CASCADE ON UPDATE CASCADE;');
  Query.Script.Add
    ('ALTER TABLE AUTEURS_SERIES ADD CONSTRAINT FK_AUTEURS_SERIES_REFPERSONNE FOREIGN KEY (REFPERSONNE) REFERENCES PERSONNES (REFPERSONNE) ON DELETE CASCADE ON UPDATE CASCADE;');

  Query.Script.Add('ALTER PROCEDURE PROC_AUTEURS (');
  Query.Script.Add('    ALBUM INTEGER,');
  Query.Script.Add('    SERIE INTEGER)');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    REFPERSONNE INTEGER,');
  Query.Script.Add('    NOMPERSONNE VARCHAR(150),');
  Query.Script.Add('    REFALBUM INTEGER,');
  Query.Script.Add('    REFSERIE INTEGER,');
  Query.Script.Add('    METIER SMALLINT)');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  if (Album is not null) then');
  Query.Script.Add('    for select p.refpersonne,');
  Query.Script.Add('               p.nompersonne,');
  Query.Script.Add('               a.refalbum,');
  Query.Script.Add('               NULL,');
  Query.Script.Add('               a.metier');
  Query.Script.Add('        from personnes p inner join auteurs a on a.refpersonne = p.refpersonne');
  Query.Script.Add('        where a.refalbum = :ALBUM');
  Query.Script.Add('        order by a.metier, p.uppernompersonne');
  Query.Script.Add('        into :REFPERSONNE,');
  Query.Script.Add('             :NOMPERSONNE,');
  Query.Script.Add('             :REFALBUM,');
  Query.Script.Add('             :REFSERIE,');
  Query.Script.Add('             :METIER');
  Query.Script.Add('    do');
  Query.Script.Add('      suspend;');
  Query.Script.Add('');
  Query.Script.Add('  if (Serie is not null) then');
  Query.Script.Add('    for select p.refpersonne,');
  Query.Script.Add('               p.nompersonne,');
  Query.Script.Add('               NULL,');
  Query.Script.Add('               a.refserie,');
  Query.Script.Add('               a.metier');
  Query.Script.Add('        from personnes p inner join auteurs_series a on a.refpersonne = p.refpersonne');
  Query.Script.Add('        where a.refserie = :SERIE');
  Query.Script.Add('        order by a.metier, p.uppernompersonne');
  Query.Script.Add('        into :REFPERSONNE,');
  Query.Script.Add('             :NOMPERSONNE,');
  Query.Script.Add('             :REFALBUM,');
  Query.Script.Add('             :REFSERIE,');
  Query.Script.Add('             :METIER');
  Query.Script.Add('    do');
  Query.Script.Add('      suspend;');
  Query.Script.Add('end;');

  Query.Script.Add('alter table personnes add BIOGRAPHIE blob sub_type text, add siteweb varchar(255);');

  Query.Script.Add('alter table editions add NombreDePages integer, add orientation smallint, add formatedition smallint;');

  Query.Script.Add('INSERT INTO LISTES (REF,CATEGORIE,LIBELLE,ORDRE,DEFAUT) VALUES (1,4,''Portrait'',1,1);');
  Query.Script.Add('INSERT INTO LISTES (REF,CATEGORIE,LIBELLE,ORDRE,DEFAUT) VALUES (2,4,''Italienne'',2,0);');
  Query.Script.Add('INSERT INTO LISTES (REF,CATEGORIE,LIBELLE,ORDRE,DEFAUT) VALUES (1,5,''Poche'',1,0);');
  Query.Script.Add('INSERT INTO LISTES (REF,CATEGORIE,LIBELLE,ORDRE,DEFAUT) VALUES (3,5,''Moyen (A5)'',2,0);');
  Query.Script.Add('INSERT INTO LISTES (REF,CATEGORIE,LIBELLE,ORDRE,DEFAUT) VALUES (4,5,''Normal (A4)'',3,1);');
  Query.Script.Add('INSERT INTO LISTES (REF,CATEGORIE,LIBELLE,ORDRE,DEFAUT) VALUES (5,5,''Grand (A3)'',4,0);');
  Query.Script.Add('INSERT INTO LISTES (REF,CATEGORIE,LIBELLE,ORDRE,DEFAUT) VALUES (6,5,''Très grand (A2)'',5,0);');
  Query.Script.Add('INSERT INTO LISTES (REF,CATEGORIE,LIBELLE,ORDRE,DEFAUT) VALUES (10,5,''Spécial'',6,0);');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('0.0.3.7', @MAJ0_0_3_07);

end.
