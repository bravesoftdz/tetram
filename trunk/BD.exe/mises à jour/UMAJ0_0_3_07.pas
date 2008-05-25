unit UMAJ0_0_3_07;

interface

implementation

uses JvUIB, Updates;

procedure MAJ0_0_3_07(Query: TJvUIBScript);
begin
  with Query do begin
    Script.Clear;

    Script.Add('alter table options alter valeur type varchar(255);');

    Script.Add('DECLARE EXTERNAL FUNCTION UDF_FINDFILEFIRST');
    Script.Add('    CSTRING(32767),');
    Script.Add('    INTEGER');
    Script.Add('RETURNS INTEGER BY VALUE');
    Script.Add('ENTRY_POINT ''FindFileFirst'' MODULE_NAME ''BDT_UDF.dll'';');

    Script.Add('DECLARE EXTERNAL FUNCTION UDF_FINDFILENEXT');
    Script.Add('    INTEGER');
    Script.Add('RETURNS INTEGER BY VALUE');
    Script.Add('ENTRY_POINT ''FindFileNext'' MODULE_NAME ''BDT_UDF.dll'';');

    Script.Add('DECLARE EXTERNAL FUNCTION UDF_EXTRACTFILESIZE');
    Script.Add('    INTEGER');
    Script.Add('RETURNS INTEGER BY VALUE');
    Script.Add('ENTRY_POINT ''ExtractFileSize'' MODULE_NAME ''BDT_UDF.dll'';');

    Script.Add('DECLARE EXTERNAL FUNCTION UDF_EXTRACTFILENAME');
    Script.Add('    INTEGER');
    Script.Add('RETURNS CSTRING(32767) FREE_IT');
    Script.Add('ENTRY_POINT ''ExtractFileName'' MODULE_NAME ''BDT_UDF.dll'';');

    Script.Add('DECLARE EXTERNAL FUNCTION UDF_EXTRACTFILEATTR');
    Script.Add('    INTEGER');
    Script.Add('RETURNS INTEGER BY VALUE');
    Script.Add('ENTRY_POINT ''ExtractFileAttr'' MODULE_NAME ''BDT_UDF.dll'';');

    Script.Add('DECLARE EXTERNAL FUNCTION UDF_SEARCHFILENAME');
    Script.Add('    CSTRING(32767),');
    Script.Add('    CSTRING(32767),');
    Script.Add('    INTEGER');
    Script.Add('RETURNS CSTRING(32767) FREE_IT');
    Script.Add('ENTRY_POINT ''SearchFileName'' MODULE_NAME ''BDT_UDF.dll'';');

    Script.Add('CREATE PROCEDURE SEARCHFILENAME (');
    Script.Add('    CHEMIN VARCHAR(255),');
    Script.Add('    OLD_FILENAME VARCHAR(255),');
    Script.Add('    RESERVE INTEGER)');
    Script.Add('RETURNS (');
    Script.Add('    NEW_FILENAME VARCHAR(255))');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  select udf_searchfilename(:chemin, :old_filename, :reserve) from rdb$database into :NEW_FILENAME;');
    Script.Add('  suspend;');
    Script.Add('end;');

    Script.Add('CREATE PROCEDURE DIRECTORYCONTENT (');
    Script.Add('    CHEMIN VARCHAR(255),');
    Script.Add('    SEARCHATTR INTEGER)');
    Script.Add('RETURNS (');
    Script.Add('    SEARCHREC INTEGER,');
    Script.Add('    FILENAME VARCHAR(255),');
    Script.Add('    FILESIZE INTEGER,');
    Script.Add('    FILEATTR INTEGER)');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  select udf_findfilefirst(:chemin, :searchattr) from rdb$database into :searchrec;');
    Script.Add('  if (searchrec < 0) then');
    Script.Add('    suspend;');
    Script.Add('  else while (searchrec > 0) do begin');
    Script.Add('    select');
    Script.Add('      udf_extractfilename(:searchrec),');
    Script.Add('      udf_extractfilesize(:searchrec),');
    Script.Add('      udf_extractfileattr(:searchrec)');
    Script.Add('    from rdb$database');
    Script.Add('    into');
    Script.Add('      :FileName,');
    Script.Add('      :FileSIZE,');
    Script.Add('      :FileATTR;');
    Script.Add('    select udf_findfilenext(:searchrec) from rdb$database into :searchrec;');
    Script.Add('    suspend;');
    Script.Add('  end');
    Script.Add('end;');

    Script.Add('ALTER PROCEDURE SAVEBLOBTOFILE (');
    Script.Add('    CHEMIN VARCHAR(255),');
    Script.Add('    FICHIER VARCHAR(255),');
    Script.Add('    BLOBCONTENT BLOB SUB_TYPE 0 SEGMENT SIZE 80)');
    Script.Add('RETURNS (');
    Script.Add('    RESULT INTEGER)');
    Script.Add('AS');
    Script.Add('BEGIN');
    Script.Add('  select udf_saveblobtofile(:chemin, :fichier, :blobcontent) from rdb$database into :result;');
    Script.Add('  suspend;');
    Script.Add('END;');

    Script.Add('CREATE TABLE AUTEURS_SERIES (');
    Script.Add('    REFSERIE     T_REFNOTNULL,');
    Script.Add('    REFPERSONNE  T_REFNOTNULL,');
    Script.Add('    METIER       SMALLINT NOT NULL');
    Script.Add(');');

    Script.Add('ALTER TABLE AUTEURS_SERIES ADD CONSTRAINT PK_AUTEURS_SERIES PRIMARY KEY (REFSERIE, REFPERSONNE, METIER);');
    Script.Add('ALTER TABLE AUTEURS_SERIES ADD CONSTRAINT FK_AUTEURS_SERIES_REFFILM FOREIGN KEY (REFSERIE) REFERENCES SERIES (REFSERIE) ON DELETE CASCADE ON UPDATE CASCADE;');
    Script.Add('ALTER TABLE AUTEURS_SERIES ADD CONSTRAINT FK_AUTEURS_SERIES_REFPERSONNE FOREIGN KEY (REFPERSONNE) REFERENCES PERSONNES (REFPERSONNE) ON DELETE CASCADE ON UPDATE CASCADE;');

    Script.Add('ALTER PROCEDURE PROC_AUTEURS (');
    Script.Add('    ALBUM INTEGER,');
    Script.Add('    SERIE INTEGER)');
    Script.Add('RETURNS (');
    Script.Add('    REFPERSONNE INTEGER,');
    Script.Add('    NOMPERSONNE VARCHAR(150),');
    Script.Add('    REFALBUM INTEGER,');
    Script.Add('    REFSERIE INTEGER,');
    Script.Add('    METIER SMALLINT)');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  if (Album is not null) then');
    Script.Add('    for select p.refpersonne,');
    Script.Add('               p.nompersonne,');
    Script.Add('               a.refalbum,');
    Script.Add('               NULL,');
    Script.Add('               a.metier');
    Script.Add('        from personnes p inner join auteurs a on a.refpersonne = p.refpersonne');
    Script.Add('        where a.refalbum = :ALBUM');
    Script.Add('        order by a.metier, p.uppernompersonne');
    Script.Add('        into :REFPERSONNE,');
    Script.Add('             :NOMPERSONNE,');
    Script.Add('             :REFALBUM,');
    Script.Add('             :REFSERIE,');
    Script.Add('             :METIER');
    Script.Add('    do');
    Script.Add('      suspend;');
    Script.Add('');
    Script.Add('  if (Serie is not null) then');
    Script.Add('    for select p.refpersonne,');
    Script.Add('               p.nompersonne,');
    Script.Add('               NULL,');
    Script.Add('               a.refserie,');
    Script.Add('               a.metier');
    Script.Add('        from personnes p inner join auteurs_series a on a.refpersonne = p.refpersonne');
    Script.Add('        where a.refserie = :SERIE');
    Script.Add('        order by a.metier, p.uppernompersonne');
    Script.Add('        into :REFPERSONNE,');
    Script.Add('             :NOMPERSONNE,');
    Script.Add('             :REFALBUM,');
    Script.Add('             :REFSERIE,');
    Script.Add('             :METIER');
    Script.Add('    do');
    Script.Add('      suspend;');
    Script.Add('end;');

    Script.Add('alter table personnes add BIOGRAPHIE blob sub_type text, add siteweb varchar(255);');

    Script.Add('alter table editions add NombreDePages integer, add orientation smallint, add formatedition smallint;');

    Script.Add('INSERT INTO LISTES (REF,CATEGORIE,LIBELLE,ORDRE,DEFAUT) VALUES (1,4,''Portrait'',1,1);');
    Script.Add('INSERT INTO LISTES (REF,CATEGORIE,LIBELLE,ORDRE,DEFAUT) VALUES (2,4,''Italienne'',2,0);');
    Script.Add('INSERT INTO LISTES (REF,CATEGORIE,LIBELLE,ORDRE,DEFAUT) VALUES (1,5,''Poche'',1,0);');
    Script.Add('INSERT INTO LISTES (REF,CATEGORIE,LIBELLE,ORDRE,DEFAUT) VALUES (3,5,''Moyen (A5)'',2,0);');
    Script.Add('INSERT INTO LISTES (REF,CATEGORIE,LIBELLE,ORDRE,DEFAUT) VALUES (4,5,''Normal (A4)'',3,1);');
    Script.Add('INSERT INTO LISTES (REF,CATEGORIE,LIBELLE,ORDRE,DEFAUT) VALUES (5,5,''Grand (A3)'',4,0);');
    Script.Add('INSERT INTO LISTES (REF,CATEGORIE,LIBELLE,ORDRE,DEFAUT) VALUES (6,5,''Très grand (A2)'',5,0);');
    Script.Add('INSERT INTO LISTES (REF,CATEGORIE,LIBELLE,ORDRE,DEFAUT) VALUES (10,5,''Spécial'',6,0);');

    ExecuteScript;
  end;
end;

initialization
  RegisterFBUpdate('0.0.3.7', @MAJ0_0_3_07);

end.
