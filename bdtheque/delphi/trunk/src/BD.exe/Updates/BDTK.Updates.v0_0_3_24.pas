unit BDTK.Updates.v0_0_3_24;

interface

implementation

uses UIB, BDTK.Updates, SysUtils;

procedure MAJ0_0_3_24(Query: TUIBScript);
var
  idfieldname, currenttable, dcfieldname, dmfieldname: string;
  qry: TUIBQuery;
begin
  Query.Script.Clear;

  Query.Script.Add('CREATE DOMAIN T_GUID CHAR(38);');
  Query.Script.Add('CREATE DOMAIN T_GUID_NOTNULL CHAR(38) NOT NULL;');
  Query.Script.Add('CREATE DOMAIN T_TIMESTAMP_NOTNULL TIMESTAMP NOT NULL;');

  Query.Script.Add('DECLARE EXTERNAL FUNCTION UDF_CREATEGUID RETURNS CSTRING(38) FREE_IT ENTRY_POINT ''CreateGUID'' MODULE_NAME ''BDT_UDF.dll'';');
  Query.Script.Add('DECLARE EXTERNAL FUNCTION UDF_TRIM CSTRING(32767) RETURNS CSTRING(32767) FREE_IT ENTRY_POINT ''Trim'' MODULE_NAME ''BDT_UDF.dll'';');

  qry := TUIBQuery.Create(Query.Transaction);
  try
    qry.SQL.Text := 'select rdb$relation_name from rdb$relations where rdb$system_flag = 0 and rdb$view_blr is null';
    qry.Open;
    while not qry.Eof do
    begin
      currenttable := Trim(qry.Fields.AsString[0]);
      idfieldname := 'ID_' + currenttable;
      dcfieldname := 'DC_' + currenttable;
      dmfieldname := 'DM_' + currenttable;

      Query.Script.Add('alter table ' + currenttable + ' add ' + idfieldname + ' T_GUID_NOTNULL;');
      Query.Script.Add('alter table ' + currenttable + ' add ' + dcfieldname + ' T_TIMESTAMP_NOTNULL;');
      Query.Script.Add('alter table ' + currenttable + ' add ' + dmfieldname + ' T_TIMESTAMP_NOTNULL;');
      Query.Script.Add('alter table ' + currenttable + ' alter ' + idfieldname + ' POSITION 1;');
      Query.Script.Add('alter table ' + currenttable + ' add constraint ' + currenttable + '_UNQID unique (' + idfieldname + ');');
      Query.Script.Add('CREATE TRIGGER ' + currenttable + '_UNIQID_BIU0 FOR ' + currenttable);
      Query.Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
      Query.Script.Add('AS');
      Query.Script.Add('begin');
      Query.Script.Add('  if (new.' + idfieldname + ' is null) then new.' + idfieldname + ' = old.' + idfieldname + ';');
      Query.Script.Add('  if (new.' + idfieldname + ' is null) then new.' + idfieldname + ' = UDF_CREATEGUID();');
      Query.Script.Add('');
      Query.Script.Add('  if (new.' + dcfieldname + ' is null) then new.' + dcfieldname + ' = old.' + dcfieldname + ';');
      Query.Script.Add('');
      Query.Script.Add('  new.' + dmfieldname + ' = cast(''now'' as timestamp);');
      Query.Script.Add('  if (inserting or new.' + dcfieldname + ' is null) then new.' + dcfieldname + ' = new.' + dmfieldname + ';');
      Query.Script.Add('end;');

      qry.Next;
    end;
  finally
    qry.Free;
  end;

  Query.Script.Add('CREATE PROCEDURE TEMP_PROCEDURE');
  Query.Script.Add('AS');
  Query.Script.Add('DECLARE VARIABLE CURRENTTABLE VARCHAR(31);');
  Query.Script.Add('DECLARE VARIABLE IDFIELDNAME VARCHAR(31);');
  Query.Script.Add('begin');
  Query.Script.Add('  for');
  Query.Script.Add('    select udf_trim(rdb$relation_name) from rdb$relations where rdb$system_flag = 0 and rdb$view_blr is null');
  Query.Script.Add('    into :currenttable do begin');
  Query.Script.Add('    idfieldname = ''ID_'' || :currenttable;');
  Query.Script.Add('    execute statement ''update '' || :currenttable || '' set '' || :idfieldname || '' = null;'';');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.Script.Add('execute procedure TEMP_PROCEDURE;');
  Query.Script.Add('drop procedure TEMP_PROCEDURE;');

  Query.Script.Add('DROP INDEX ALBUMS_IDX_ANNEE;');
  Query.Script.Add('DROP INDEX ALBUMS_IDX_INITIALETITREALBUM;');
  Query.Script.Add('DROP INDEX ALBUMS_TITRE;');
  Query.Script.Add('DROP INDEX COUVERTURES_IDX1;');
  Query.Script.Add('DROP INDEX EDITEURS_IDX1;');
  Query.Script.Add('DROP INDEX EMPRUNTEURS_INITIALENOM;');
  Query.Script.Add('DROP INDEX EMPRUNTEURS_NOMS;');
  Query.Script.Add('DROP INDEX GENRES_GENRE;');
  Query.Script.Add('DROP INDEX GENRES_UPPERGENRE;');
  Query.Script.Add('DROP INDEX LISTES_IDX1;');
  Query.Script.Add('DROP INDEX LISTES_IDX2;');
  Query.Script.Add('DROP INDEX PERSONNES_NOM;');

  Query.Script.Add('ALTER TABLE ALBUMS DROP CONSTRAINT ALBUMS_FK1;');
  Query.Script.Add('ALTER TABLE AUTEURS DROP CONSTRAINT FK_AUTEURS_REFFILM;');
  Query.Script.Add('ALTER TABLE AUTEURS DROP CONSTRAINT FK_AUTEURS_REFPERSONNE;');
  Query.Script.Add('ALTER TABLE AUTEURS_SERIES DROP CONSTRAINT FK_AUTEURS_SERIES_REFFILM;');
  Query.Script.Add('ALTER TABLE AUTEURS_SERIES DROP CONSTRAINT FK_AUTEURS_SERIES_REFPERSONNE;');
  Query.Script.Add('ALTER TABLE COLLECTIONS DROP CONSTRAINT COLLECTIONS_FK1;');
  Query.Script.Add('ALTER TABLE COUVERTURES DROP CONSTRAINT COUVERTURES_FK1;');
  Query.Script.Add('ALTER TABLE EDITIONS DROP CONSTRAINT EDITIONS_FK1;');
  Query.Script.Add('ALTER TABLE EDITIONS DROP CONSTRAINT EDITIONS_FK3;');
  Query.Script.Add('ALTER TABLE GENRESERIES DROP CONSTRAINT FK_GENRESERIES_REFGENRE;');
  Query.Script.Add('ALTER TABLE GENRESERIES DROP CONSTRAINT FK_GENRESERIES_REFSERIE;');
  Query.Script.Add('ALTER TABLE STATUT DROP CONSTRAINT STATUT_FK1;');
  Query.Script.Add('ALTER TABLE STATUT DROP CONSTRAINT STATUT_FK2;');

  Query.Script.Add('ALTER TABLE ALBUMS DROP CONSTRAINT PK_ALBUMS;');
  Query.Script.Add('ALTER TABLE AUTEURS DROP CONSTRAINT PK_AUTEURS;');
  Query.Script.Add('ALTER TABLE AUTEURS_SERIES DROP CONSTRAINT PK_AUTEURS_SERIES;');
  Query.Script.Add('ALTER TABLE COLLECTIONS DROP CONSTRAINT COLLECTIONS_PK;');
  Query.Script.Add('ALTER TABLE COUVERTURES DROP CONSTRAINT COUVERTURES_PK;');
  Query.Script.Add('ALTER TABLE EDITEURS DROP CONSTRAINT EDITEURS_PK;');
  Query.Script.Add('ALTER TABLE EDITIONS DROP CONSTRAINT EDITIONS_PK;');
  Query.Script.Add('ALTER TABLE EMPRUNTEURS DROP CONSTRAINT PK_EMPRUNTEURS;');
  Query.Script.Add('ALTER TABLE ENTRETIENT DROP CONSTRAINT PK_ENTRETIENT;');
  Query.Script.Add('ALTER TABLE GENRES DROP CONSTRAINT PK_GENRES;');
  Query.Script.Add('ALTER TABLE LISTES DROP CONSTRAINT LISTES_PK;');
  Query.Script.Add('ALTER TABLE OPTIONS DROP CONSTRAINT OPTIONS_PK;');
  Query.Script.Add('ALTER TABLE PERSONNES DROP CONSTRAINT PK_PERSONNES;');
  Query.Script.Add('ALTER TABLE SERIES DROP CONSTRAINT SERIES_PK;');
  Query.Script.Add('ALTER TABLE STATUT DROP CONSTRAINT PK_STATUT;');

  Query.Script.Add('ALTER TABLE ALBUMS ADD CONSTRAINT ALBUMS_PK PRIMARY KEY (REFALBUM);');
  Query.Script.Add('ALTER TABLE AUTEURS ADD CONSTRAINT AUTEURS_PK PRIMARY KEY (REFALBUM, REFPERSONNE, METIER);');
  Query.Script.Add('ALTER TABLE AUTEURS_SERIES ADD CONSTRAINT AUTEURS_SERIES_PK PRIMARY KEY (REFSERIE, REFPERSONNE, METIER);');
  Query.Script.Add('ALTER TABLE COLLECTIONS ADD CONSTRAINT COLLECTIONS_PK PRIMARY KEY (REFCOLLECTION);');
  Query.Script.Add('ALTER TABLE COUVERTURES ADD CONSTRAINT COUVERTURES_PK PRIMARY KEY (REFCOUVERTURE);');
  Query.Script.Add('ALTER TABLE EDITEURS ADD CONSTRAINT EDITEURS_PK PRIMARY KEY (REFEDITEUR);');
  Query.Script.Add('ALTER TABLE EDITIONS ADD CONSTRAINT EDITIONS_PK PRIMARY KEY (REFEDITION);');
  Query.Script.Add('ALTER TABLE EMPRUNTEURS ADD CONSTRAINT EMPRUNTEURS_PK PRIMARY KEY (REFEMPRUNTEUR);');
  Query.Script.Add('ALTER TABLE ENTRETIENT ADD CONSTRAINT ENTRETIENT_PK PRIMARY KEY (REF);');
  Query.Script.Add('ALTER TABLE GENRES ADD CONSTRAINT GENRES_PK PRIMARY KEY (REFGENRE);');
  Query.Script.Add('ALTER TABLE LISTES ADD CONSTRAINT LISTES_PK PRIMARY KEY (CATEGORIE, REF);');
  Query.Script.Add('ALTER TABLE OPTIONS ADD CONSTRAINT OPTIONS_PK PRIMARY KEY (NOM_OPTION);');
  Query.Script.Add('ALTER TABLE PERSONNES ADD CONSTRAINT PERSONNES_PK PRIMARY KEY (REFPERSONNE);');
  Query.Script.Add('ALTER TABLE SERIES ADD CONSTRAINT SERIES_PK PRIMARY KEY (REFSERIE);');
  Query.Script.Add('ALTER TABLE STATUT ADD CONSTRAINT STATUT_PK PRIMARY KEY (REFEMPRUNT);');

  Query.Script.Add('ALTER TABLE ALBUMS ADD CONSTRAINT ALBUMS_FK1 FOREIGN KEY (REFSERIE) REFERENCES SERIES (REFSERIE) ON DELETE CASCADE ON UPDATE CASCADE;');
  Query.Script.Add('ALTER TABLE AUTEURS ADD CONSTRAINT AUTEURS_FK1 FOREIGN KEY (REFALBUM) REFERENCES ALBUMS (REFALBUM) ON DELETE CASCADE ON UPDATE CASCADE;');
  Query.Script.Add
    ('ALTER TABLE AUTEURS ADD CONSTRAINT AUTEURS_FK2 FOREIGN KEY (REFPERSONNE) REFERENCES PERSONNES (REFPERSONNE) ON DELETE CASCADE ON UPDATE CASCADE;');
  Query.Script.Add
    ('ALTER TABLE AUTEURS_SERIES ADD CONSTRAINT AUTEURS_SERIES_FK1 FOREIGN KEY (REFSERIE) REFERENCES SERIES (REFSERIE) ON DELETE CASCADE ON UPDATE CASCADE;');
  Query.Script.Add
    ('ALTER TABLE AUTEURS_SERIES ADD CONSTRAINT AUTEURS_SERIES_FK2 FOREIGN KEY (REFPERSONNE) REFERENCES PERSONNES (REFPERSONNE) ON DELETE CASCADE ON UPDATE CASCADE;');
  Query.Script.Add
    ('ALTER TABLE COLLECTIONS ADD CONSTRAINT COLLECTIONS_FK1 FOREIGN KEY (REFEDITEUR) REFERENCES EDITEURS (REFEDITEUR) ON DELETE CASCADE ON UPDATE CASCADE;');
  Query.Script.Add
    ('ALTER TABLE COUVERTURES ADD CONSTRAINT COUVERTURES_FK1 FOREIGN KEY (REFALBUM) REFERENCES ALBUMS (REFALBUM) ON DELETE CASCADE ON UPDATE CASCADE;');
  Query.Script.Add
    ('ALTER TABLE EDITIONS ADD CONSTRAINT EDITIONS_FK1 FOREIGN KEY (REFEDITEUR) REFERENCES EDITEURS (REFEDITEUR) ON DELETE CASCADE ON UPDATE CASCADE;');
  Query.Script.Add('ALTER TABLE EDITIONS ADD CONSTRAINT EDITIONS_FK2 FOREIGN KEY (REFALBUM) REFERENCES ALBUMS (REFALBUM) ON DELETE CASCADE ON UPDATE CASCADE;');
  Query.Script.Add
    ('ALTER TABLE GENRESERIES ADD CONSTRAINT GENRESERIES_FK1 FOREIGN KEY (REFGENRE) REFERENCES GENRES (REFGENRE) ON DELETE CASCADE ON UPDATE CASCADE;');
  Query.Script.Add
    ('ALTER TABLE GENRESERIES ADD CONSTRAINT GENRESERIES_FK2 FOREIGN KEY (REFSERIE) REFERENCES SERIES (REFSERIE) ON DELETE CASCADE ON UPDATE CASCADE;');
  Query.Script.Add
    ('ALTER TABLE STATUT ADD CONSTRAINT STATUT_FK1 FOREIGN KEY (REFEDITION) REFERENCES EDITIONS (REFEDITION) ON DELETE CASCADE ON UPDATE CASCADE;');
  Query.Script.Add
    ('ALTER TABLE STATUT ADD CONSTRAINT STATUT_FK2 FOREIGN KEY (REFEMPRUNTEUR) REFERENCES EMPRUNTEURS (REFEMPRUNTEUR) ON DELETE CASCADE ON UPDATE CASCADE;');

  Query.Script.Add('CREATE INDEX ALBUMS_IDX1 ON ALBUMS (ANNEEPARUTION);');
  Query.Script.Add('CREATE INDEX ALBUMS_IDX2 ON ALBUMS (INITIALETITREALBUM);');
  Query.Script.Add('CREATE INDEX ALBUMS_IDX3 ON ALBUMS (UPPERTITREALBUM);');
  Query.Script.Add('CREATE INDEX COUVERTURES_IDX1 ON COUVERTURES (ORDRE);');
  Query.Script.Add('CREATE INDEX EDITEURS_IDX1 ON EDITEURS (UPPERNOMEDITEUR);');
  Query.Script.Add('CREATE INDEX EMPRUNTEURS_IDX1 ON EMPRUNTEURS (INITIALENOMEMPRUNTEUR);');
  Query.Script.Add('CREATE INDEX EMPRUNTEURS_IDX2 ON EMPRUNTEURS (UPPERNOMEMPRUNTEUR);');
  Query.Script.Add('CREATE INDEX GENRES_IDX1 ON GENRES (GENRE);');
  Query.Script.Add('CREATE INDEX GENRES_IDX2 ON GENRES (UPPERGENRE);');
  Query.Script.Add('CREATE INDEX LISTES_IDX1 ON LISTES (REF);');
  Query.Script.Add('CREATE INDEX LISTES_IDX2 ON LISTES (CATEGORIE);');
  Query.Script.Add('CREATE INDEX PERSONNES_IDX1 ON PERSONNES (UPPERNOMPERSONNE);');

  Query.Script.Add('DROP VIEW VW_LISTE_EDITEURS_ALBUMS;');
  Query.Script.Add('CREATE VIEW VW_LISTE_EDITEURS_ALBUMS(');
  Query.Script.Add('    REFALBUM,');
  Query.Script.Add('    TITREALBUM,');
  Query.Script.Add('    TOME,');
  Query.Script.Add('    TOMEDEBUT,');
  Query.Script.Add('    TOMEFIN,');
  Query.Script.Add('    HORSSERIE,');
  Query.Script.Add('    INTEGRALE,');
  Query.Script.Add('    ANNEEPARUTION,');
  Query.Script.Add('    REFSERIE,');
  Query.Script.Add('    TITRESERIE,');
  Query.Script.Add('    UPPERTITREALBUM,');
  Query.Script.Add('    REFEDITEUR,');
  Query.Script.Add('    NOMEDITEUR,');
  Query.Script.Add('    UPPERNOMEDITEUR,');
  Query.Script.Add('    UPPERTITRESERIE,');
  Query.Script.Add('    ACHAT,');
  Query.Script.Add('    COMPLET)');
  Query.Script.Add('AS');
  Query.Script.Add('select a.REFALBUM,');
  Query.Script.Add('       a.TITREALBUM,');
  Query.Script.Add('       a.TOME,');
  Query.Script.Add('       a.TOMEDEBUT,');
  Query.Script.Add('       a.TOMEFIN,');
  Query.Script.Add('       a.HORSSERIE,');
  Query.Script.Add('       a.INTEGRALE,');
  Query.Script.Add('       a.ANNEEPARUTION,');
  Query.Script.Add('       a.REFSERIE,');
  Query.Script.Add('       a.TITRESERIE,');
  Query.Script.Add('       a.UPPERTITREALBUM,');
  Query.Script.Add('       e.REFEDITEUR,');
  Query.Script.Add('       e.NOMEDITEUR,');
  Query.Script.Add('       e.UPPERNOMEDITEUR,');
  Query.Script.Add('       a.UPPERTITRESERIE,');
  Query.Script.Add('       a.ACHAT,');
  Query.Script.Add('       a.COMPLET');
  Query.Script.Add('FROM VW_LISTE_ALBUMS a LEFT JOIN EDITIONS ed ON ed.refalbum = a.refalbum');
  Query.Script.Add('                       LEFT JOIN EDITEURS e ON e.refediteur = ed.refediteur;');

  Query.Script.Add('DROP VIEW VW_LISTE_GENRES_ALBUMS;');
  Query.Script.Add('CREATE VIEW VW_LISTE_GENRES_ALBUMS(');
  Query.Script.Add('    REFALBUM,');
  Query.Script.Add('    TITREALBUM,');
  Query.Script.Add('    TOME,');
  Query.Script.Add('    TOMEDEBUT,');
  Query.Script.Add('    TOMEFIN,');
  Query.Script.Add('    HORSSERIE,');
  Query.Script.Add('    INTEGRALE,');
  Query.Script.Add('    ANNEEPARUTION,');
  Query.Script.Add('    REFSERIE,');
  Query.Script.Add('    TITRESERIE,');
  Query.Script.Add('    UPPERTITREALBUM,');
  Query.Script.Add('    REFGENRE,');
  Query.Script.Add('    GENRE,');
  Query.Script.Add('    UPPERGENRE,');
  Query.Script.Add('    UPPERTITRESERIE,');
  Query.Script.Add('    ACHAT,');
  Query.Script.Add('    COMPLET)');
  Query.Script.Add('AS');
  Query.Script.Add('select a.REFALBUM,');
  Query.Script.Add('       a.TITREALBUM,');
  Query.Script.Add('       a.TOME,');
  Query.Script.Add('       a.TOMEDEBUT,');
  Query.Script.Add('       a.TOMEFIN,');
  Query.Script.Add('       a.HORSSERIE,');
  Query.Script.Add('       a.INTEGRALE,');
  Query.Script.Add('       a.ANNEEPARUTION,');
  Query.Script.Add('       a.REFSERIE,');
  Query.Script.Add('       a.TITRESERIE,');
  Query.Script.Add('       a.UPPERTITREALBUM,');
  Query.Script.Add('       g.REFGENRE,');
  Query.Script.Add('       g.GENRE,');
  Query.Script.Add('       g.UPPERGENRE,');
  Query.Script.Add('       a.UPPERTITRESERIE,');
  Query.Script.Add('       a.ACHAT,');
  Query.Script.Add('       a.COMPLET');
  Query.Script.Add('FROM VW_LISTE_ALBUMS a LEFT JOIN GENRESERIES gs ON gs.refserie = a.refserie');
  Query.Script.Add('                       LEFT JOIN GENRES g ON gs.refgenre = g.refgenre;');

  Query.Script.Add('DROP VIEW VW_LISTE_COLLECTIONS_ALBUMS;');
  Query.Script.Add('CREATE VIEW VW_LISTE_COLLECTIONS_ALBUMS(');
  Query.Script.Add('    REFALBUM,');
  Query.Script.Add('    TITREALBUM,');
  Query.Script.Add('    TOME,');
  Query.Script.Add('    TOMEDEBUT,');
  Query.Script.Add('    TOMEFIN,');
  Query.Script.Add('    HORSSERIE,');
  Query.Script.Add('    INTEGRALE,');
  Query.Script.Add('    ANNEEPARUTION,');
  Query.Script.Add('    REFSERIE,');
  Query.Script.Add('    TITRESERIE,');
  Query.Script.Add('    UPPERTITREALBUM,');
  Query.Script.Add('    REFCOLLECTION,');
  Query.Script.Add('    NOMCOLLECTION,');
  Query.Script.Add('    UPPERNOMCOLLECTION,');
  Query.Script.Add('    UPPERTITRESERIE,');
  Query.Script.Add('    ACHAT,');
  Query.Script.Add('    COMPLET)');
  Query.Script.Add('AS');
  Query.Script.Add('select a.REFALBUM,');
  Query.Script.Add('       a.TITREALBUM,');
  Query.Script.Add('       a.TOME,');
  Query.Script.Add('       a.TOMEDEBUT,');
  Query.Script.Add('       a.TOMEFIN,');
  Query.Script.Add('       a.HORSSERIE,');
  Query.Script.Add('       a.INTEGRALE,');
  Query.Script.Add('       a.ANNEEPARUTION,');
  Query.Script.Add('       a.REFSERIE,');
  Query.Script.Add('       a.TITRESERIE,');
  Query.Script.Add('       a.UPPERTITREALBUM,');
  Query.Script.Add('       c.REFCOLLECTION,');
  Query.Script.Add('       c.NOMCOLLECTION,');
  Query.Script.Add('       c.UPPERNOMCOLLECTION,');
  Query.Script.Add('       a.UPPERTITRESERIE,');
  Query.Script.Add('       a.ACHAT,');
  Query.Script.Add('       a.COMPLET');
  Query.Script.Add('FROM VW_LISTE_ALBUMS a LEFT JOIN EDITIONS e ON e.refalbum = a.refalbum');
  Query.Script.Add('                       LEFT JOIN COLLECTIONS c ON e.refcollection = c.refcollection;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('0.0.3.24', @MAJ0_0_3_24);

end.
