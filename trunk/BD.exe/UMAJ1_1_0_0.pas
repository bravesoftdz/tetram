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

    Script.Add('ALTER TABLE COUVERTURES ADD CATEGORIEIMAGE SMALLINT, ALTER TYPECOUVERTURE TO STOCKAGECOUVERTURE, ALTER COUVERTURE TO IMAGECOUVERTURE;');

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
    Script.Add('    TITREPARABD      VARCHAR(150),');
    Script.Add('    REFSERIE         T_REFNOTNULL_BASE0,');
    Script.Add('    CATEGORIEPARABD  SMALLINT,');
    Script.Add('    ACHAT            T_YESNO_BASENO,');
    Script.Add('    COMPLET          INTEGER,');
    Script.Add('    DEDICACE         T_YESNO_BASENO,');
    Script.Add('    NUMEROTE         T_YESNO_BASENO,');
    Script.Add('    ANNEE            SMALLINT,');
    Script.Add('    ANNEECOTE        SMALLINT,');
    Script.Add('    PRIXCOTE         NUMERIC(15,2),');
    Script.Add('    PRETE            T_YESNO_BASENO,');
    Script.Add('    STOCK            T_YESNO_BASEYES,');
    Script.Add('    DATEACHAT        DATE,');
    Script.Add('    PRIX             NUMERIC(15,2),');
    Script.Add('    GRATUIT          T_YESNO_BASENO,');
    Script.Add('    OFFERT           T_YESNO_BASENO,');
    Script.Add('    STOCKAGEPARABD   SMALLINT,');
    Script.Add('    IMAGEPARABD      BLOB SUB_TYPE 0 SEGMENT SIZE 80,');
    Script.Add('    FICHIERParaBD    VARCHAR(255),');
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

    Script.Add('CREATE TABLE COTES_PARABD (');
    Script.Add('    ID_COTES_PARABD    T_GUID_NOTNULL,');
    Script.Add('    REFPARABD          T_REFNOTNULL NOT NULL,');
    Script.Add('    ANNEECOTE          SMALLINT NOT NULL,');
    Script.Add('    PRIXCOTE           NUMERIC(15,2) NOT NULL,');
    Script.Add('    DC_COTES_PARABD    T_TIMESTAMP_NOTNULL,');
    Script.Add('    DM_COTES_PARABD    T_TIMESTAMP_NOTNULL');
    Script.Add(');');

    Script.Add('ALTER TABLE COTES_PARABD ADD CONSTRAINT COTES_PARABD_UNQ1 UNIQUE (ID_COTES_PARABD);');
    Script.Add('ALTER TABLE COTES_PARABD ADD CONSTRAINT COTES_PARABD_PK PRIMARY KEY (ANNEECOTE, REFPARABD);');
    Script.Add('ALTER TABLE COTES_PARABD ADD CONSTRAINT COTES_PARABD_FK1 FOREIGN KEY (REFPARABD) REFERENCES PARABD (REFPARABD) ON DELETE CASCADE ON UPDATE CASCADE;');

    Script.Add('CREATE TRIGGER COTES_PARABD_UNIQID_BIU0 FOR COTES_PARABD');
    Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  if (new.ID_COTES_PARABD is null) then new.ID_COTES_PARABD = old.ID_COTES_PARABD;');
    Script.Add('  if (new.ID_COTES_PARABD is null) then new.ID_COTES_PARABD = UDF_CREATEGUID();');
    Script.Add('');
    Script.Add('  if (new.DC_COTES_PARABD is null) then new.DC_COTES_PARABD = old.DC_COTES_PARABD;');
    Script.Add('');
    Script.Add('  new.DM_COTES_PARABD = cast(''now'' as timestamp);');
    Script.Add('  if (inserting or new.DC_COTES_PARABD is null) then new.DC_COTES_PARABD = new.DM_COTES_PARABD;');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER PARABD_COTE_BIU1 FOR PARABD');
    Script.Add('ACTIVE AFTER INSERT OR UPDATE POSITION 1');
    Script.Add('AS');
    Script.Add('declare variable existPRIX numeric(15,2);');
    Script.Add('begin');
    Script.Add('  if (new.anneecote is not null and new.prixcote is not null) then begin');
    Script.Add('    select PRIXCOTE from COTES_PARABD where REFPARABD = new.refparabd AND ANNEECOTE = new.anneecote INTO :existPRIX;');
    Script.Add('    if (existPRIX is null) then');
    Script.Add('      INSERT INTO COTES_PARABD (REFPARABD, ANNEECOTE, PRIXCOTE) VALUES (new.refparabd, new.anneecote, new.prixcote);');
    Script.Add('    else');
    Script.Add('      UPDATE COTES_PARABD SET PRIXCOTE = new.prixcote WHERE REFPARABD = new.refparabd AND ANNEECOTE = new.anneecote;');
    Script.Add('  end');
    Script.Add('end;');

    Script.Add('CREATE VIEW VW_LISTE_PARABD(');
    Script.Add('    REFPARABD,');
    Script.Add('    TITREPARABD,');
    Script.Add('    REFSERIE,');
    Script.Add('    TITRESERIE,');
    Script.Add('    UPPERTITREPARABD,');
    Script.Add('    UPPERTITRESERIE,');
    Script.Add('    ACHAT,');
    Script.Add('    COMPLET,');
    Script.Add('    SCATEGORIE)');
    Script.Add('AS');
    Script.Add('select a.REFPARABD,');
    Script.Add('       a.TITREPARABD,');
    Script.Add('       a.REFSERIE,');
    Script.Add('       s.TITRESERIE,');
    Script.Add('       a.UPPERTITREPARABD,');
    Script.Add('       s.UPPERTITRESERIE,');
    Script.Add('       a.ACHAT,');
    Script.Add('       a.COMPLET,');
    Script.Add('       lc.LIBELLE,');
    Script.Add('FROM PARABD a INNER JOIN SERIES s ON s.refserie = a.refserie');
    Script.Add('LEFT JOIN LISTES lc on (lc.ref = a.CATEGORIEPARABD and lc.categorie = 7);');

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
    Script.Add('    COMPLET INTEGER,');
    Script.Add('    SCATEGORIE VARCHAR(50))');
    Script.Add('AS');
    Script.Add('DECLARE VARIABLE SWHERE VARCHAR(130);');
    Script.Add('BEGIN');
    Script.Add('  swhere = '''';');
    Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''and '' || filtre || '' '';');
    Script.Add('  FOR execute statement');
    Script.Add('      ''SELECT REFPARABD,');
    Script.Add('             TITREPARABD,');
    Script.Add('             REFPARABD,');
    Script.Add('             TITRESERIE,');
    Script.Add('             ACHAT,');
    Script.Add('             COMPLET,');
    Script.Add('             SCATEGORIE');
    Script.Add('      FROM vw_liste_PARABD');
    Script.Add('      WHERE refserie = '''''' || :serie || '''''' '' || swhere ||');
    Script.Add('      ''ORDER BY UPPERTITREPARABD''');
    Script.Add('      INTO :REFPARABD,');
    Script.Add('           :TITREPARABD,');
    Script.Add('           :REFSERIE,');
    Script.Add('           :TITRESERIE,');
    Script.Add('           :ACHAT,');
    Script.Add('           :COMPLET,');
    Script.Add('           :SCATEGORIE');
    Script.Add('  DO');
    Script.Add('  BEGIN');
    Script.Add('    SUSPEND;');
    Script.Add('  END');
    Script.Add('end;');

    Script.Add('CREATE TABLE AUTEURS_PARABD (');
    Script.Add('    ID_AUTEURS_PARABD  T_GUID_NOTNULL,');
    Script.Add('    REFPARABD          T_REFNOTNULL,');
    Script.Add('    REFPERSONNE        T_REFNOTNULL,');
    Script.Add('    DC_AUTEURS_PARABD  T_TIMESTAMP_NOTNULL,');
    Script.Add('    DM_AUTEURS_PARABD  T_TIMESTAMP_NOTNULL');
    Script.Add(');');

    Script.Add('ALTER TABLE AUTEURS_PARABD ADD CONSTRAINT AUTEURS_PARABD_UNQID UNIQUE (ID_AUTEURS_PARABD);');
    Script.Add('ALTER TABLE AUTEURS_PARABD ADD CONSTRAINT AUTEURS_PARABD_PK PRIMARY KEY (REFPARABD, REFPERSONNE);');
    Script.Add('ALTER TABLE AUTEURS_PARABD ADD CONSTRAINT AUTEURS_PARABD_FK1 FOREIGN KEY (REFPARABD) REFERENCES PARABD (REFPARABD) ON DELETE CASCADE ON UPDATE CASCADE;');
    Script.Add('ALTER TABLE AUTEURS_PARABD ADD CONSTRAINT AUTEURS_PARABD_FK2 FOREIGN KEY (REFPERSONNE) REFERENCES PERSONNES (REFPERSONNE) ON DELETE CASCADE ON UPDATE CASCADE;');

    Script.Add('CREATE TRIGGER AUTEURS_PARABD_UNIQID_BIU0 FOR AUTEURS_PARABD');
    Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  if (new.ID_AUTEURS_PARABD is null) then new.ID_AUTEURS_PARABD = old.ID_AUTEURS_PARABD;');
    Script.Add('  if (new.ID_AUTEURS_PARABD is null) then new.ID_AUTEURS_PARABD = UDF_CREATEGUID();');
    Script.Add('');
    Script.Add('  if (new.DC_AUTEURS_PARABD is null) then new.DC_AUTEURS_PARABD = old.DC_AUTEURS_PARABD;');
    Script.Add('');
    Script.Add('  new.DM_AUTEURS_PARABD = cast(''now'' as timestamp);');
    Script.Add('  if (inserting or new.DC_AUTEURS_PARABD is null) then new.DC_AUTEURS_PARABD = new.DM_AUTEURS_PARABD;');
    Script.Add('end;');

    Script.Add('ALTER PROCEDURE PROC_AUTEURS (');
    Script.Add('    ALBUM INTEGER,');
    Script.Add('    SERIE INTEGER,');
    Script.Add('    PARABD INTEGER)');
    Script.Add('RETURNS (');
    Script.Add('    REFPERSONNE INTEGER,');
    Script.Add('    NOMPERSONNE VARCHAR(150),');
    Script.Add('    REFALBUM INTEGER,');
    Script.Add('    REFSERIE INTEGER,');
    Script.Add('    REFPARABD INTEGER,');
    Script.Add('    METIER SMALLINT)');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  if (Album is not null) then');
    Script.Add('    for select p.refpersonne,');
    Script.Add('               p.nompersonne,');
    Script.Add('               a.refalbum,');
    Script.Add('               NULL,');
    Script.Add('               NULL,');
    Script.Add('               a.metier');
    Script.Add('        from personnes p inner join auteurs a on a.refpersonne = p.refpersonne');
    Script.Add('        where a.refalbum = :ALBUM');
    Script.Add('        order by a.metier, p.uppernompersonne');
    Script.Add('        into :REFPERSONNE,');
    Script.Add('             :NOMPERSONNE,');
    Script.Add('             :REFALBUM,');
    Script.Add('             :REFSERIE,');
    Script.Add('             :REFPARABD,');
    Script.Add('             :METIER');
    Script.Add('    do');
    Script.Add('      suspend;');
    Script.Add('');
    Script.Add('  if (Serie is not null) then');
    Script.Add('    for select p.refpersonne,');
    Script.Add('               p.nompersonne,');
    Script.Add('               NULL,');
    Script.Add('               a.refserie,');
    Script.Add('               NULL,');
    Script.Add('               a.metier');
    Script.Add('        from personnes p inner join auteurs_series a on a.refpersonne = p.refpersonne');
    Script.Add('        where a.refserie = :SERIE');
    Script.Add('        order by a.metier, p.uppernompersonne');
    Script.Add('        into :REFPERSONNE,');
    Script.Add('             :NOMPERSONNE,');
    Script.Add('             :REFALBUM,');
    Script.Add('             :REFSERIE,');
    Script.Add('             :REFPARABD,');
    Script.Add('             :METIER');
    Script.Add('    do');
    Script.Add('      suspend;');
    Script.Add('');
    Script.Add('  if (ParaBD is not null) then');
    Script.Add('    for select p.refpersonne,');
    Script.Add('               p.nompersonne,');
    Script.Add('               NULL,');
    Script.Add('               NULL,');
    Script.Add('               a.refparabd,');
    Script.Add('               NULL');
    Script.Add('        from personnes p inner join auteurs_parabd a on a.refpersonne = p.refpersonne');
    Script.Add('        where a.refparabd = :PARABD');
    Script.Add('        order by p.uppernompersonne');
    Script.Add('        into :REFPERSONNE,');
    Script.Add('             :NOMPERSONNE,');
    Script.Add('             :REFALBUM,');
    Script.Add('             :REFSERIE,');
    Script.Add('             :REFPARABD,');
    Script.Add('             :METIER');
    Script.Add('    do');
    Script.Add('      suspend;');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER PARABD_DV FOR PARABD');
    Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  if (inserting or new.TitrePARABD <> old.TitrePARABD) then begin');
    Script.Add('    new.UpperTitrePARABD = UDF_UPPER(new.TitrePARABD);');
    Script.Add('    new.SoundexTitrePARABD = UDF_SOUNDEX(new.TitrePARABD, 1);');
    Script.Add('    select initiale from get_initiale(new.UpperTitrePARABD) into new.initialetitrePARABD;');
    Script.Add('  end');
    Script.Add('end;');

    ExecuteScript;
  end;
end;

initialization
  RegisterUpdate('1.1.0.0', @MAJ1_1_0_0);

end.

