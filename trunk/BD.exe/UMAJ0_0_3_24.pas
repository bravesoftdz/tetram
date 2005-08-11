unit UMAJ0_0_3_24;

interface

implementation

uses JvUIB, Updates, SysUtils;

procedure MAJ0_0_3_24(Query: TJvUIBScript);
var
  idfieldname, currenttable, dcfieldname, dmfieldname: string;
begin
  with Query do begin
    Script.Clear;

    Script.Add('CREATE DOMAIN T_GUID CHAR(38);');
    Script.Add('CREATE DOMAIN T_GUID_NOTNULL CHAR(38) NOT NULL;');
    Script.Add('CREATE DOMAIN T_TIMESTAMP_NOTNULL TIMESTAMP NOT NULL;');

    Script.Add('DECLARE EXTERNAL FUNCTION UDF_CREATEGUID RETURNS CSTRING(38) FREE_IT ENTRY_POINT ''CreateGUID'' MODULE_NAME ''BDT_UDF.dll'';');
    Script.Add('DECLARE EXTERNAL FUNCTION UDF_TRIM CSTRING(32767) RETURNS CSTRING(32767) FREE_IT ENTRY_POINT ''Trim'' MODULE_NAME ''BDT_UDF.dll'';');

    with TJvUIBQuery.Create(Query.Transaction) do try
      SQL.Text := 'select rdb$relation_name from rdb$relations where rdb$system_flag = 0 and rdb$view_blr is null';
      Open;
      while not Eof do begin
        currenttable := Trim(Fields.AsString[0]);
        idfieldname := 'ID_' + currenttable;
        dcfieldname := 'DC_' + currenttable;
        dmfieldname := 'DM_' + currenttable;
        Script.Add('alter table ' + currenttable + ' add ' + idfieldname + ' T_GUID_NOTNULL;');
        Script.Add('alter table ' + currenttable + ' add ' + dcfieldname + ' T_TIMESTAMP_NOTNULL;');
        Script.Add('alter table ' + currenttable + ' add ' + dmfieldname + ' T_TIMESTAMP_NOTNULL;');
        Script.Add('alter table ' + currenttable + ' alter ' + idfieldname + ' POSITION 1;');
        Script.Add('alter table ' + currenttable + ' add constraint ' + currenttable + '_UNQID unique (' + idfieldname + ');');
        Script.Add('CREATE TRIGGER ' + currenttable + '_UNIQID_BIU0 FOR ' + currenttable);
        Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
        Script.Add('AS');
        Script.Add('begin');
        Script.Add('  if (new.' + idfieldname + ' is null) then new.' + idfieldname + ' = old.' + idfieldname + ';');
        Script.Add('  if (new.' + idfieldname + ' is null) then new.' + idfieldname + ' = UDF_CREATEGUID();');
        Script.Add('');
        Script.Add('  if (new.' + dcfieldname + ' is null) then new.' + dcfieldname + ' = old.' + dcfieldname + ';');
        Script.Add('');
        Script.Add('  new.' + dmfieldname + ' = cast(''now'' as timestamp);');
        Script.Add('  if (inserting or new.' + dcfieldname + ' is null) then new.' + dcfieldname + ' = new.' + dmfieldname + ';');
        Script.Add('end;');
        Next;
      end;
    finally
      Free;
    end;

    Script.Add('CREATE PROCEDURE TEMP_PROCEDURE');
    Script.Add('AS');
    Script.Add('DECLARE VARIABLE CURRENTTABLE VARCHAR(31);');
    Script.Add('DECLARE VARIABLE IDFIELDNAME VARCHAR(31);');
    Script.Add('begin');
    Script.Add('  for');
    Script.Add('    select udf_trim(rdb$relation_name) from rdb$relations where rdb$system_flag = 0 and rdb$view_blr is null');
    Script.Add('    into :currenttable do begin');
    Script.Add('    idfieldname = ''ID_'' || :currenttable;');
    Script.Add('    execute statement ''update '' || :currenttable || '' set '' || :idfieldname || '' = null;'';');
    Script.Add('  end');
    Script.Add('end;');

    Script.Add('execute procedure TEMP_PROCEDURE;');
    Script.Add('drop procedure TEMP_PROCEDURE;');

    Script.Add('DROP INDEX ALBUMS_IDX_ANNEE;');
    Script.Add('DROP INDEX ALBUMS_IDX_INITIALETITREALBUM;');
    Script.Add('DROP INDEX ALBUMS_TITRE;');
    Script.Add('DROP INDEX COUVERTURES_IDX1;');
    Script.Add('DROP INDEX EDITEURS_IDX1;');
    Script.Add('DROP INDEX EMPRUNTEURS_INITIALENOM;');
    Script.Add('DROP INDEX EMPRUNTEURS_NOMS;');
    Script.Add('DROP INDEX GENRES_GENRE;');
    Script.Add('DROP INDEX GENRES_UPPERGENRE;');
    Script.Add('DROP INDEX LISTES_IDX1;');
    Script.Add('DROP INDEX LISTES_IDX2;');
    Script.Add('DROP INDEX PERSONNES_NOM;');

    Script.Add('ALTER TABLE ALBUMS DROP CONSTRAINT ALBUMS_FK1;');
    Script.Add('ALTER TABLE AUTEURS DROP CONSTRAINT FK_AUTEURS_REFFILM;');
    Script.Add('ALTER TABLE AUTEURS DROP CONSTRAINT FK_AUTEURS_REFPERSONNE;');
    Script.Add('ALTER TABLE AUTEURS_SERIES DROP CONSTRAINT FK_AUTEURS_SERIES_REFFILM;');
    Script.Add('ALTER TABLE AUTEURS_SERIES DROP CONSTRAINT FK_AUTEURS_SERIES_REFPERSONNE;');
    Script.Add('ALTER TABLE COLLECTIONS DROP CONSTRAINT COLLECTIONS_FK1;');
    Script.Add('ALTER TABLE COUVERTURES DROP CONSTRAINT COUVERTURES_FK1;');
    Script.Add('ALTER TABLE EDITIONS DROP CONSTRAINT EDITIONS_FK1;');
    Script.Add('ALTER TABLE EDITIONS DROP CONSTRAINT EDITIONS_FK3;');
    Script.Add('ALTER TABLE GENRESERIES DROP CONSTRAINT FK_GENRESERIES_REFGENRE;');
    Script.Add('ALTER TABLE GENRESERIES DROP CONSTRAINT FK_GENRESERIES_REFSERIE;');
    Script.Add('ALTER TABLE STATUT DROP CONSTRAINT STATUT_FK1;');
    Script.Add('ALTER TABLE STATUT DROP CONSTRAINT STATUT_FK2;');

    Script.Add('ALTER TABLE ALBUMS DROP CONSTRAINT PK_ALBUMS;');
    Script.Add('ALTER TABLE AUTEURS DROP CONSTRAINT PK_AUTEURS;');
    Script.Add('ALTER TABLE AUTEURS_SERIES DROP CONSTRAINT PK_AUTEURS_SERIES;');
    Script.Add('ALTER TABLE COLLECTIONS DROP CONSTRAINT COLLECTIONS_PK;');
    Script.Add('ALTER TABLE COUVERTURES DROP CONSTRAINT COUVERTURES_PK;');
    Script.Add('ALTER TABLE EDITEURS DROP CONSTRAINT EDITEURS_PK;');
    Script.Add('ALTER TABLE EDITIONS DROP CONSTRAINT EDITIONS_PK;');
    Script.Add('ALTER TABLE EMPRUNTEURS DROP CONSTRAINT PK_EMPRUNTEURS;');
    Script.Add('ALTER TABLE ENTRETIENT DROP CONSTRAINT PK_ENTRETIENT;');
    Script.Add('ALTER TABLE GENRES DROP CONSTRAINT PK_GENRES;');
    Script.Add('ALTER TABLE LISTES DROP CONSTRAINT LISTES_PK;');
    Script.Add('ALTER TABLE OPTIONS DROP CONSTRAINT OPTIONS_PK;');
    Script.Add('ALTER TABLE PERSONNES DROP CONSTRAINT PK_PERSONNES;');
    Script.Add('ALTER TABLE SERIES DROP CONSTRAINT SERIES_PK;');
    Script.Add('ALTER TABLE STATUT DROP CONSTRAINT PK_STATUT;');

    Script.Add('ALTER TABLE ALBUMS ADD CONSTRAINT ALBUMS_PK PRIMARY KEY (REFALBUM);');
    Script.Add('ALTER TABLE AUTEURS ADD CONSTRAINT AUTEURS_PK PRIMARY KEY (REFALBUM, REFPERSONNE, METIER);');
    Script.Add('ALTER TABLE AUTEURS_SERIES ADD CONSTRAINT AUTEURS_SERIES_PK PRIMARY KEY (REFSERIE, REFPERSONNE, METIER);');
    Script.Add('ALTER TABLE COLLECTIONS ADD CONSTRAINT COLLECTIONS_PK PRIMARY KEY (REFCOLLECTION);');
    Script.Add('ALTER TABLE COUVERTURES ADD CONSTRAINT COUVERTURES_PK PRIMARY KEY (REFCOUVERTURE);');
    Script.Add('ALTER TABLE EDITEURS ADD CONSTRAINT EDITEURS_PK PRIMARY KEY (REFEDITEUR);');
    Script.Add('ALTER TABLE EDITIONS ADD CONSTRAINT EDITIONS_PK PRIMARY KEY (REFEDITION);');
    Script.Add('ALTER TABLE EMPRUNTEURS ADD CONSTRAINT EMPRUNTEURS_PK PRIMARY KEY (REFEMPRUNTEUR);');
    Script.Add('ALTER TABLE ENTRETIENT ADD CONSTRAINT ENTRETIENT_PK PRIMARY KEY (REF);');
    Script.Add('ALTER TABLE GENRES ADD CONSTRAINT GENRES_PK PRIMARY KEY (REFGENRE);');
    Script.Add('ALTER TABLE LISTES ADD CONSTRAINT LISTES_PK PRIMARY KEY (CATEGORIE, REF);');
    Script.Add('ALTER TABLE OPTIONS ADD CONSTRAINT OPTIONS_PK PRIMARY KEY (NOM_OPTION);');
    Script.Add('ALTER TABLE PERSONNES ADD CONSTRAINT PERSONNES_PK PRIMARY KEY (REFPERSONNE);');
    Script.Add('ALTER TABLE SERIES ADD CONSTRAINT SERIES_PK PRIMARY KEY (REFSERIE);');
    Script.Add('ALTER TABLE STATUT ADD CONSTRAINT STATUT_PK PRIMARY KEY (REFEMPRUNT);');

    Script.Add('ALTER TABLE ALBUMS ADD CONSTRAINT ALBUMS_FK1 FOREIGN KEY (REFSERIE) REFERENCES SERIES (REFSERIE) ON DELETE CASCADE ON UPDATE CASCADE;');
    Script.Add('ALTER TABLE AUTEURS ADD CONSTRAINT AUTEURS_FK1 FOREIGN KEY (REFALBUM) REFERENCES ALBUMS (REFALBUM) ON DELETE CASCADE ON UPDATE CASCADE;');
    Script.Add('ALTER TABLE AUTEURS ADD CONSTRAINT AUTEURS_FK2 FOREIGN KEY (REFPERSONNE) REFERENCES PERSONNES (REFPERSONNE) ON DELETE CASCADE ON UPDATE CASCADE;');
    Script.Add('ALTER TABLE AUTEURS_SERIES ADD CONSTRAINT AUTEURS_SERIES_FK1 FOREIGN KEY (REFSERIE) REFERENCES SERIES (REFSERIE) ON DELETE CASCADE ON UPDATE CASCADE;');
    Script.Add('ALTER TABLE AUTEURS_SERIES ADD CONSTRAINT AUTEURS_SERIES_FK2 FOREIGN KEY (REFPERSONNE) REFERENCES PERSONNES (REFPERSONNE) ON DELETE CASCADE ON UPDATE CASCADE;');
    Script.Add('ALTER TABLE COLLECTIONS ADD CONSTRAINT COLLECTIONS_FK1 FOREIGN KEY (REFEDITEUR) REFERENCES EDITEURS (REFEDITEUR) ON DELETE CASCADE ON UPDATE CASCADE;');
    Script.Add('ALTER TABLE COUVERTURES ADD CONSTRAINT COUVERTURES_FK1 FOREIGN KEY (REFALBUM) REFERENCES ALBUMS (REFALBUM) ON DELETE CASCADE ON UPDATE CASCADE;');
    Script.Add('ALTER TABLE EDITIONS ADD CONSTRAINT EDITIONS_FK1 FOREIGN KEY (REFEDITEUR) REFERENCES EDITEURS (REFEDITEUR) ON DELETE CASCADE ON UPDATE CASCADE;');
    Script.Add('ALTER TABLE EDITIONS ADD CONSTRAINT EDITIONS_FK2 FOREIGN KEY (REFALBUM) REFERENCES ALBUMS (REFALBUM) ON DELETE CASCADE ON UPDATE CASCADE;');
    Script.Add('ALTER TABLE GENRESERIES ADD CONSTRAINT GENRESERIES_FK1 FOREIGN KEY (REFGENRE) REFERENCES GENRES (REFGENRE) ON DELETE CASCADE ON UPDATE CASCADE;');
    Script.Add('ALTER TABLE GENRESERIES ADD CONSTRAINT GENRESERIES_FK2 FOREIGN KEY (REFSERIE) REFERENCES SERIES (REFSERIE) ON DELETE CASCADE ON UPDATE CASCADE;');
    Script.Add('ALTER TABLE STATUT ADD CONSTRAINT STATUT_FK1 FOREIGN KEY (REFEDITION) REFERENCES EDITIONS (REFEDITION) ON DELETE CASCADE ON UPDATE CASCADE;');
    Script.Add('ALTER TABLE STATUT ADD CONSTRAINT STATUT_FK2 FOREIGN KEY (REFEMPRUNTEUR) REFERENCES EMPRUNTEURS (REFEMPRUNTEUR) ON DELETE CASCADE ON UPDATE CASCADE;');

    Script.Add('CREATE INDEX ALBUMS_IDX1 ON ALBUMS (ANNEEPARUTION);');
    Script.Add('CREATE INDEX ALBUMS_IDX2 ON ALBUMS (INITIALETITREALBUM);');
    Script.Add('CREATE INDEX ALBUMS_IDX3 ON ALBUMS (UPPERTITREALBUM);');
    Script.Add('CREATE INDEX COUVERTURES_IDX1 ON COUVERTURES (ORDRE);');
    Script.Add('CREATE INDEX EDITEURS_IDX1 ON EDITEURS (UPPERNOMEDITEUR);');
    Script.Add('CREATE INDEX EMPRUNTEURS_IDX1 ON EMPRUNTEURS (INITIALENOMEMPRUNTEUR);');
    Script.Add('CREATE INDEX EMPRUNTEURS_IDX2 ON EMPRUNTEURS (UPPERNOMEMPRUNTEUR);');
    Script.Add('CREATE INDEX GENRES_IDX1 ON GENRES (GENRE);');
    Script.Add('CREATE INDEX GENRES_IDX2 ON GENRES (UPPERGENRE);');
    Script.Add('CREATE INDEX LISTES_IDX1 ON LISTES (REF);');
    Script.Add('CREATE INDEX LISTES_IDX2 ON LISTES (CATEGORIE);');
    Script.Add('CREATE INDEX PERSONNES_IDX1 ON PERSONNES (UPPERNOMPERSONNE);');

    Script.Add('DROP VIEW VW_LISTE_EDITEURS_ALBUMS;');
    Script.Add('CREATE VIEW VW_LISTE_EDITEURS_ALBUMS(');
    Script.Add('    REFALBUM,');
    Script.Add('    TITREALBUM,');
    Script.Add('    TOME,');
    Script.Add('    TOMEDEBUT,');
    Script.Add('    TOMEFIN,');
    Script.Add('    HORSSERIE,');
    Script.Add('    INTEGRALE,');
    Script.Add('    ANNEEPARUTION,');
    Script.Add('    REFSERIE,');
    Script.Add('    TITRESERIE,');
    Script.Add('    UPPERTITREALBUM,');
    Script.Add('    REFEDITEUR,');
    Script.Add('    NOMEDITEUR,');
    Script.Add('    UPPERNOMEDITEUR,');
    Script.Add('    UPPERTITRESERIE,');
    Script.Add('    ACHAT,');
    Script.Add('    COMPLET)');
    Script.Add('AS');
    Script.Add('select a.REFALBUM,');
    Script.Add('       a.TITREALBUM,');
    Script.Add('       a.TOME,');
    Script.Add('       a.TOMEDEBUT,');
    Script.Add('       a.TOMEFIN,');
    Script.Add('       a.HORSSERIE,');
    Script.Add('       a.INTEGRALE,');
    Script.Add('       a.ANNEEPARUTION,');
    Script.Add('       a.REFSERIE,');
    Script.Add('       a.TITRESERIE,');
    Script.Add('       a.UPPERTITREALBUM,');
    Script.Add('       e.REFEDITEUR,');
    Script.Add('       e.NOMEDITEUR,');
    Script.Add('       e.UPPERNOMEDITEUR,');
    Script.Add('       a.UPPERTITRESERIE,');
    Script.Add('       a.ACHAT,');
    Script.Add('       a.COMPLET');
    Script.Add('FROM VW_LISTE_ALBUMS a LEFT JOIN EDITIONS ed ON ed.refalbum = a.refalbum');
    Script.Add('                       LEFT JOIN EDITEURS e ON e.refediteur = ed.refediteur;');

    Script.Add('DROP VIEW VW_LISTE_GENRES_ALBUMS;');
    Script.Add('CREATE VIEW VW_LISTE_GENRES_ALBUMS(');
    Script.Add('    REFALBUM,');
    Script.Add('    TITREALBUM,');
    Script.Add('    TOME,');
    Script.Add('    TOMEDEBUT,');
    Script.Add('    TOMEFIN,');
    Script.Add('    HORSSERIE,');
    Script.Add('    INTEGRALE,');
    Script.Add('    ANNEEPARUTION,');
    Script.Add('    REFSERIE,');
    Script.Add('    TITRESERIE,');
    Script.Add('    UPPERTITREALBUM,');
    Script.Add('    REFGENRE,');
    Script.Add('    GENRE,');
    Script.Add('    UPPERGENRE,');
    Script.Add('    UPPERTITRESERIE,');
    Script.Add('    ACHAT,');
    Script.Add('    COMPLET)');
    Script.Add('AS');
    Script.Add('select a.REFALBUM,');
    Script.Add('       a.TITREALBUM,');
    Script.Add('       a.TOME,');
    Script.Add('       a.TOMEDEBUT,');
    Script.Add('       a.TOMEFIN,');
    Script.Add('       a.HORSSERIE,');
    Script.Add('       a.INTEGRALE,');
    Script.Add('       a.ANNEEPARUTION,');
    Script.Add('       a.REFSERIE,');
    Script.Add('       a.TITRESERIE,');
    Script.Add('       a.UPPERTITREALBUM,');
    Script.Add('       g.REFGENRE,');
    Script.Add('       g.GENRE,');
    Script.Add('       g.UPPERGENRE,');
    Script.Add('       a.UPPERTITRESERIE,');
    Script.Add('       a.ACHAT,');
    Script.Add('       a.COMPLET');
    Script.Add('FROM VW_LISTE_ALBUMS a LEFT JOIN GENRESERIES gs ON gs.refserie = a.refserie');
    Script.Add('                       LEFT JOIN GENRES g ON gs.refgenre = g.refgenre;');

    Script.Add('DROP VIEW VW_LISTE_COLLECTIONS_ALBUMS;');
    Script.Add('CREATE VIEW VW_LISTE_COLLECTIONS_ALBUMS(');
    Script.Add('    REFALBUM,');
    Script.Add('    TITREALBUM,');
    Script.Add('    TOME,');
    Script.Add('    TOMEDEBUT,');
    Script.Add('    TOMEFIN,');
    Script.Add('    HORSSERIE,');
    Script.Add('    INTEGRALE,');
    Script.Add('    ANNEEPARUTION,');
    Script.Add('    REFSERIE,');
    Script.Add('    TITRESERIE,');
    Script.Add('    UPPERTITREALBUM,');
    Script.Add('    REFCOLLECTION,');
    Script.Add('    NOMCOLLECTION,');
    Script.Add('    UPPERNOMCOLLECTION,');
    Script.Add('    UPPERTITRESERIE,');
    Script.Add('    ACHAT,');
    Script.Add('    COMPLET)');
    Script.Add('AS');
    Script.Add('select a.REFALBUM,');
    Script.Add('       a.TITREALBUM,');
    Script.Add('       a.TOME,');
    Script.Add('       a.TOMEDEBUT,');
    Script.Add('       a.TOMEFIN,');
    Script.Add('       a.HORSSERIE,');
    Script.Add('       a.INTEGRALE,');
    Script.Add('       a.ANNEEPARUTION,');
    Script.Add('       a.REFSERIE,');
    Script.Add('       a.TITRESERIE,');
    Script.Add('       a.UPPERTITREALBUM,');
    Script.Add('       c.REFCOLLECTION,');
    Script.Add('       c.NOMCOLLECTION,');
    Script.Add('       c.UPPERNOMCOLLECTION,');
    Script.Add('       a.UPPERTITRESERIE,');
    Script.Add('       a.ACHAT,');
    Script.Add('       a.COMPLET');
    Script.Add('FROM VW_LISTE_ALBUMS a LEFT JOIN EDITIONS e ON e.refalbum = a.refalbum');
    Script.Add('                       LEFT JOIN COLLECTIONS c ON e.refcollection = c.refcollection;');

    ExecuteScript;
  end;
end;

initialization
  RegisterUpdate('0.0.3.24', @MAJ0_0_3_24);

end.

