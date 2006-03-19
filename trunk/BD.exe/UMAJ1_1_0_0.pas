unit UMAJ1_1_0_0;

interface

implementation

uses JvUIB, Updates;

procedure MAJ1_1_0_0(Query: TJvUIBScript);
begin
  with Query do begin
    Script.Clear;

    Script.Add('alter table editions add ANNEECOTE SMALLINT, add PRIXCOTE NUMERIC(15,2);');

    Script.Add('CREATE TABLE COTES (');
    Script.Add('    ID_COTES    T_GUID_NOTNULL,');
    Script.Add('    REFEDITION  T_REFNOTNULL NOT NULL,');
    Script.Add('    ANNEECOTE   SMALLINT NOT NULL,');
    Script.Add('    PRIXCOTE    NUMERIC(15,2) NOT NULL,');
    Script.Add('    DC_COTES    T_TIMESTAMP_NOTNULL,');
    Script.Add('    DM_COTES    T_TIMESTAMP_NOTNULL');
    Script.Add(');');

    Script.Add('ALTER TABLE COTES ADD CONSTRAINT COTES_UNQ1 UNIQUE (ID_COTES);');
    Script.Add('ALTER TABLE COTES ADD CONSTRAINT COTES_PK PRIMARY KEY (ANNEECOTE, REFEDITION);');
    Script.Add('ALTER TABLE COTES ADD CONSTRAINT COTES_FK1 FOREIGN KEY (REFEDITION) REFERENCES EDITIONS (REFEDITION) ON DELETE CASCADE ON UPDATE CASCADE;');

    Script.Add('CREATE TRIGGER COTES_UNIQID_BIU0 FOR COTES');
    Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  if (new.ID_COTES is null) then new.ID_COTES = old.ID_COTES;');
    Script.Add('  if (new.ID_COTES is null) then new.ID_COTES = UDF_CREATEGUID();');
    Script.Add('');
    Script.Add('  if (new.DC_COTES is null) then new.DC_COTES = old.DC_COTES;');
    Script.Add('');
    Script.Add('  new.DM_COTES = cast(''now'' as timestamp);');
    Script.Add('  if (inserting or new.DC_COTES is null) then new.DC_COTES = new.DM_COTES;');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER EDITIONS_COTE_BIU1 FOR EDITIONS');
    Script.Add('ACTIVE AFTER INSERT OR UPDATE POSITION 1');
    Script.Add('AS');
    Script.Add('declare variable existPRIX numeric(15,2);');
    Script.Add('begin');
    Script.Add('  if (new.anneecote is not null and new.prixcote is not null) then begin');
    Script.Add('    select PRIXCOTE from COTES where REFEDITION = new.refedition AND ANNEECOTE = new.anneecote INTO :existPRIX;');
    Script.Add('    if (existPRIX is null) then');
    Script.Add('      INSERT INTO COTES (REFEDITION, ANNEECOTE, PRIXCOTE) VALUES (new.refedition, new.anneecote, new.prixcote);');
    Script.Add('    else');
    Script.Add('      UPDATE COTES SET PRIXCOTE = new.prixcote WHERE REFEDITION = new.refedition AND ANNEECOTE = new.anneecote;');
    Script.Add('  end');
    Script.Add('end;');

    Script.Add('ALTER TABLE COUVERTURES ADD CATEGORIEIMAGE SMALLINT;');

    Script.Add('INSERT INTO LISTES (REF, CATEGORIE, LIBELLE, ORDRE, DEFAUT) VALUES (0, 6, ''Couverture'', 1, 1);');
    Script.Add('INSERT INTO LISTES (REF, CATEGORIE, LIBELLE, ORDRE, DEFAUT) VALUES (1, 6, ''Planche'', 4, 0);');
    Script.Add('INSERT INTO LISTES (REF, CATEGORIE, LIBELLE, ORDRE, DEFAUT) VALUES (2, 6, ''4ème de couverture'', 5, 0);');
    Script.Add('INSERT INTO LISTES (REF, CATEGORIE, LIBELLE, ORDRE, DEFAUT) VALUES (3, 6, ''Page de garde'', 3, 0);');
    Script.Add('INSERT INTO LISTES (REF, CATEGORIE, LIBELLE, ORDRE, DEFAUT) VALUES (4, 6, ''Dédicace'', 10, 0);');

    Script.Add('INSERT INTO LISTES (REF, CATEGORIE, LIBELLE, ORDRE, DEFAUT) VALUES (0, 7, ''Ex-Libris'', 1, 1);');
    Script.Add('INSERT INTO LISTES (REF, CATEGORIE, LIBELLE, ORDRE, DEFAUT) VALUES (1, 7, ''Objet'', 2, 0);');

    Script.Add('update couvertures set categorieimage = case ordre when 0 then 0 else 1 end;');

    Script.Add('CREATE GENERATOR AI_REFParaBD;');

    Script.Add('CREATE TABLE ParaBD (');
    Script.Add('    ID_ParaBD        T_GUID_NOTNULL,');
    Script.Add('    REFParaBD        T_REFNOTNULL,');
    Script.Add('    REFSERIE         INTEGER,');
    Script.Add('    ORDRE            INTEGER,');
    Script.Add('    TYPEParaBD       SMALLINT,');
    Script.Add('    CATEGORIEIMAGE   SMALLINT,');
    Script.Add('    ParaBD           BLOB SUB_TYPE 0 SEGMENT SIZE 80,');
    Script.Add('    FICHIERParaBD    VARCHAR(255),');
    Script.Add('    ACHAT            T_YESNO_BASENO,');
    Script.Add('    COMPLET          INTEGER,');
    Script.Add('    TITREPARABD           VARCHAR(150),');
    Script.Add('    TITREINITIALESPARABD  VARCHAR(15),');
    Script.Add('    UPPERTITREPARABD      VARCHAR(150),');
    Script.Add('    SOUNDEXTITREPARABD    VARCHAR(30),');
    Script.Add('    INITIALETITREPARABD   CHAR(1),');
    Script.Add('    DESCRIPTION           BLOB SUB_TYPE 1 SEGMENT SIZE 80,');
    Script.Add('    UPPERDESCRIPTION      BLOB SUB_TYPE 1 SEGMENT SIZE 80,');
    Script.Add('    DC_ParaBD        T_TIMESTAMP_NOTNULL,');
    Script.Add('    DM_ParaBD        T_TIMESTAMP_NOTNULL');
    Script.Add(');');

    Script.Add('ALTER TABLE ParaBD ADD CONSTRAINT ParaBD_UNQID UNIQUE (ID_ParaBD);');
    Script.Add('ALTER TABLE ParaBD ADD CONSTRAINT ParaBD_PK PRIMARY KEY (REFParaBD);');
    Script.Add('ALTER TABLE ParaBD ADD CONSTRAINT ParaBD_FK1 FOREIGN KEY (REFSERIE) REFERENCES SERIES (REFSERIE) ON DELETE CASCADE ON UPDATE CASCADE;');
    Script.Add('CREATE INDEX ParaBD_IDX1 ON ParaBD (ORDRE);');

    Script.Add('CREATE TRIGGER ParaBD_AI FOR ParaBD');
    Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  if (new.refParaBD is null) then new.refParaBD = gen_id(ai_refParaBD, 1);');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER ParaBD_UNIQID_BIU0 FOR ParaBD');
    Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  if (new.ID_ParaBD is null) then new.ID_ParaBD = old.ID_ParaBD;');
    Script.Add('  if (new.ID_ParaBD is null) then new.ID_ParaBD = UDF_CREATEGUID();');
    Script.Add('');
    Script.Add('  if (new.DC_ParaBD is null) then new.DC_ParaBD = old.DC_ParaBD;');
    Script.Add('');
    Script.Add('  new.DM_ParaBD = cast(''now'' as timestamp);');
    Script.Add('  if (inserting or new.DC_ParaBD is null) then new.DC_ParaBD = new.DM_ParaBD;');
    Script.Add('end;');

    Script.Add('CREATE VIEW VW_LISTE_PARABD(');
    Script.Add('    REFPARABD,');
    Script.Add('    TITREPARABD,');
    Script.Add('    REFSERIE,');
    Script.Add('    TITRESERIE,');
    Script.Add('    UPPERTITREPARABD,');
    Script.Add('    UPPERTITRESERIE,');
    Script.Add('    ACHAT,');
    Script.Add('    COMPLET)');
    Script.Add('AS');
    Script.Add('select a.REFPARABD,');
    Script.Add('       a.TITREPARABD,');
    Script.Add('       a.REFSERIE,');
    Script.Add('       s.TITRESERIE,');
    Script.Add('       a.UPPERTITREPARABD,');
    Script.Add('       s.UPPERTITRESERIE,');
    Script.Add('       a.ACHAT,');
    Script.Add('       a.COMPLET');
    Script.Add('FROM PARABD a INNER JOIN SERIES s ON s.refserie = a.refserie;');

    Script.Add('CREATE PROCEDURE SERIES_PARABD (');
    Script.Add('    FILTRE VARCHAR(125))');
    Script.Add('RETURNS (');
    Script.Add('    TITRESERIE VARCHAR(150),');
    Script.Add('    COUNTSERIE INTEGER,');
    Script.Add('    REFSERIE INTEGER)');
    Script.Add('AS');
    Script.Add('DECLARE VARIABLE SWHERE VARCHAR(132);');
    Script.Add('begin');
    Script.Add('  swhere = '''';');
    Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''AND '' || filtre;');
    Script.Add('');
    Script.Add('  for execute statement');
    Script.Add('     ''select');
    Script.Add('             -1,');
    Script.Add('             RefSerie,');
    Script.Add('             Count(REFPARABD)');
    Script.Add('      from vw_liste_parabd');
    Script.Add('      where TITRESerie is null '' || SWHERE ||');
    Script.Add('    '' group by UPPERTITRESERIE, TITRESerie, RefSerie''');
    Script.Add('  into :TITRESerie,');
    Script.Add('       :RefSerie,');
    Script.Add('       :countSerie');
    Script.Add('  do');
    Script.Add('    suspend;');
    Script.Add('');
    Script.Add('  for execute statement');
    Script.Add('     ''select');
    Script.Add('             TITRESerie,');
    Script.Add('             RefSerie,');
    Script.Add('             Count(REFPARABD)');
    Script.Add('      from vw_liste_parabd');
    Script.Add('      where TITRESerie is not null '' || SWHERE ||');
    Script.Add('    '' group by UPPERTITRESERIE, TITRESerie, RefSerie''');
    Script.Add('  into :TITRESerie,');
    Script.Add('       :RefSerie,');
    Script.Add('       :countSerie');
    Script.Add('  do');
    Script.Add('    suspend;');
    Script.Add('end;');

    Script.Add('CREATE PROCEDURE PARABD_BY_SERIE (');
    Script.Add('    SERIE INTEGER,');
    Script.Add('    FILTRE VARCHAR(125))');
    Script.Add('RETURNS (');
    Script.Add('    REFPARABD INTEGER,');
    Script.Add('    TITREPARABD VARCHAR(150),');
    Script.Add('    REFSERIE INTEGER,');
    Script.Add('    TITRESERIE VARCHAR(150),');
    Script.Add('    ACHAT SMALLINT,');
    Script.Add('    COMPLET INTEGER)');
    Script.Add('AS');
    Script.Add('DECLARE VARIABLE SWHERE VARCHAR(130);');
    Script.Add('BEGIN');
    Script.Add('  swhere = '''';');
    Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''and '' || filtre || '' '';');
    Script.Add('  FOR execute statement');
    Script.Add('      ''SELECT REFPARABD,');
    Script.Add('             TITREPARABD,');
    Script.Add('             REFPARABD,');
    Script.Add('             TITREPARABD,');
    Script.Add('             ACHAT,');
    Script.Add('             COMPLET');
    Script.Add('      FROM vw_liste_PARABD');
    Script.Add('      WHERE refserie = '''''' || :serie || '''''' '' || swhere ||');
    Script.Add('      ''ORDER BY UPPERTITREPARABD''');
    Script.Add('      INTO :REFPARABD,');
    Script.Add('           :TITREPARABD,');
    Script.Add('           :REFSERIE,');
    Script.Add('           :TITRESERIE,');
    Script.Add('           :ACHAT,');
    Script.Add('           :COMPLET');
    Script.Add('  DO');
    Script.Add('  BEGIN');
    Script.Add('    SUSPEND;');
    Script.Add('  END');
    Script.Add('end;');

    ExecuteScript;
  end;
end;

initialization
  RegisterUpdate('1.1.0.0', @MAJ1_1_0_0);

end.

