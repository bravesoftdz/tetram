unit UMAJ1_1_0_0;

interface

implementation

uses UIB, Updates;

procedure MAJ1_1_0_0(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add('alter table editions add ANNEECOTE SMALLINT, add PRIXCOTE NUMERIC(15,2);');

  Query.Script.Add('CREATE TABLE COTES (');
  Query.Script.Add('    ID_COTES    T_GUID_NOTNULL,');
  Query.Script.Add('    REFEDITION  T_REFNOTNULL NOT NULL,');
  Query.Script.Add('    ANNEECOTE   SMALLINT NOT NULL,');
  Query.Script.Add('    PRIXCOTE    NUMERIC(15,2) NOT NULL,');
  Query.Script.Add('    DC_COTES    T_TIMESTAMP_NOTNULL,');
  Query.Script.Add('    DM_COTES    T_TIMESTAMP_NOTNULL');
  Query.Script.Add(');');

  Query.Script.Add('ALTER TABLE COTES ADD CONSTRAINT COTES_UNQ1 UNIQUE (ID_COTES);');
  Query.Script.Add('ALTER TABLE COTES ADD CONSTRAINT COTES_PK PRIMARY KEY (ANNEECOTE, REFEDITION);');
  Query.Script.Add('ALTER TABLE COTES ADD CONSTRAINT COTES_FK1 FOREIGN KEY (REFEDITION) REFERENCES EDITIONS (REFEDITION) ON DELETE CASCADE ON UPDATE CASCADE;');

  Query.Script.Add('CREATE TRIGGER COTES_UNIQID_BIU0 FOR COTES');
  Query.Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  if (new.ID_COTES is null) then new.ID_COTES = old.ID_COTES;');
  Query.Script.Add('  if (new.ID_COTES is null) then new.ID_COTES = UDF_CREATEGUID();');
  Query.Script.Add('');
  Query.Script.Add('  if (new.DC_COTES is null) then new.DC_COTES = old.DC_COTES;');
  Query.Script.Add('');
  Query.Script.Add('  new.DM_COTES = cast(''now'' as timestamp);');
  Query.Script.Add('  if (inserting or new.DC_COTES is null) then new.DC_COTES = new.DM_COTES;');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER EDITIONS_COTE_BIU1 FOR EDITIONS');
  Query.Script.Add('ACTIVE AFTER INSERT OR UPDATE POSITION 1');
  Query.Script.Add('AS');
  Query.Script.Add('declare variable existPRIX numeric(15,2);');
  Query.Script.Add('begin');
  Query.Script.Add('  if (new.anneecote is not null and new.prixcote is not null) then begin');
  Query.Script.Add('    select PRIXCOTE from COTES where REFEDITION = new.refedition AND ANNEECOTE = new.anneecote INTO :existPRIX;');
  Query.Script.Add('    if (existPRIX is null) then');
  Query.Script.Add('      INSERT INTO COTES (REFEDITION, ANNEECOTE, PRIXCOTE) VALUES (new.refedition, new.anneecote, new.prixcote);');
  Query.Script.Add('    else');
  Query.Script.Add('      UPDATE COTES SET PRIXCOTE = new.prixcote WHERE REFEDITION = new.refedition AND ANNEECOTE = new.anneecote;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER TABLE COUVERTURES ADD CATEGORIEIMAGE SMALLINT, ALTER TYPECOUVERTURE TO STOCKAGECOUVERTURE, ALTER COUVERTURE TO IMAGECOUVERTURE;');

  Query.Script.Add('INSERT INTO LISTES (REF, CATEGORIE, LIBELLE, ORDRE, DEFAUT) VALUES (0, 6, ''Couverture'', 1, 1);');
  Query.Script.Add('INSERT INTO LISTES (REF, CATEGORIE, LIBELLE, ORDRE, DEFAUT) VALUES (1, 6, ''Planche'', 4, 0);');
  Query.Script.Add('INSERT INTO LISTES (REF, CATEGORIE, LIBELLE, ORDRE, DEFAUT) VALUES (2, 6, ''4ème de couverture'', 5, 0);');
  Query.Script.Add('INSERT INTO LISTES (REF, CATEGORIE, LIBELLE, ORDRE, DEFAUT) VALUES (3, 6, ''Page de garde'', 3, 0);');
  Query.Script.Add('INSERT INTO LISTES (REF, CATEGORIE, LIBELLE, ORDRE, DEFAUT) VALUES (4, 6, ''Dédicace'', 10, 0);');

  Query.Script.Add('INSERT INTO LISTES (REF, CATEGORIE, LIBELLE, ORDRE, DEFAUT) VALUES (0, 7, ''Ex-Libris'', 1, 1);');
  Query.Script.Add('INSERT INTO LISTES (REF, CATEGORIE, LIBELLE, ORDRE, DEFAUT) VALUES (1, 7, ''Objet'', 2, 0);');

  Query.Script.Add('update couvertures set categorieimage = case ordre when 0 then 0 else 1 end;');

  Query.Script.Add('CREATE GENERATOR AI_REFParaBD;');

  Query.Script.Add('CREATE TABLE ParaBD (');
  Query.Script.Add('    ID_ParaBD        T_GUID_NOTNULL,');
  Query.Script.Add('    REFParaBD        T_REFNOTNULL,');
  Query.Script.Add('    TITREPARABD      VARCHAR(150),');
  Query.Script.Add('    REFSERIE         T_REFNOTNULL_BASE0,');
  Query.Script.Add('    CATEGORIEPARABD  SMALLINT,');
  Query.Script.Add('    ACHAT            T_YESNO_BASENO,');
  Query.Script.Add('    COMPLET          INTEGER,');
  Query.Script.Add('    DEDICACE         T_YESNO_BASENO,');
  Query.Script.Add('    NUMEROTE         T_YESNO_BASENO,');
  Query.Script.Add('    ANNEE            SMALLINT,');
  Query.Script.Add('    ANNEECOTE        SMALLINT,');
  Query.Script.Add('    PRIXCOTE         NUMERIC(15,2),');
  Query.Script.Add('    PRETE            T_YESNO_BASENO,');
  Query.Script.Add('    STOCK            T_YESNO_BASEYES,');
  Query.Script.Add('    DATEACHAT        DATE,');
  Query.Script.Add('    PRIX             NUMERIC(15,2),');
  Query.Script.Add('    GRATUIT          T_YESNO_BASENO,');
  Query.Script.Add('    OFFERT           T_YESNO_BASENO,');
  Query.Script.Add('    STOCKAGEPARABD   SMALLINT,');
  Query.Script.Add('    IMAGEPARABD      BLOB SUB_TYPE 0 SEGMENT SIZE 80,');
  Query.Script.Add('    FICHIERParaBD    VARCHAR(255),');
  Query.Script.Add('    TITREINITIALESPARABD  VARCHAR(15),');
  Query.Script.Add('    UPPERTITREPARABD      VARCHAR(150),');
  Query.Script.Add('    SOUNDEXTITREPARABD    VARCHAR(30),');
  Query.Script.Add('    INITIALETITREPARABD   CHAR(1),');
  Query.Script.Add('    DESCRIPTION           BLOB SUB_TYPE 1 SEGMENT SIZE 80,');
  Query.Script.Add('    UPPERDESCRIPTION      BLOB SUB_TYPE 1 SEGMENT SIZE 80,');
  Query.Script.Add('    DC_ParaBD        T_TIMESTAMP_NOTNULL,');
  Query.Script.Add('    DM_ParaBD        T_TIMESTAMP_NOTNULL');
  Query.Script.Add(');');

  Query.Script.Add('ALTER TABLE ParaBD ADD CONSTRAINT ParaBD_UNQID UNIQUE (ID_ParaBD);');
  Query.Script.Add('ALTER TABLE ParaBD ADD CONSTRAINT ParaBD_PK PRIMARY KEY (REFParaBD);');
  Query.Script.Add('ALTER TABLE ParaBD ADD CONSTRAINT ParaBD_FK1 FOREIGN KEY (REFSERIE) REFERENCES SERIES (REFSERIE) ON DELETE CASCADE ON UPDATE CASCADE;');

  Query.Script.Add('CREATE TRIGGER ParaBD_AI FOR ParaBD');
  Query.Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  if (new.refParaBD is null) then new.refParaBD = gen_id(ai_refParaBD, 1);');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER ParaBD_UNIQID_BIU0 FOR ParaBD');
  Query.Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  if (new.ID_ParaBD is null) then new.ID_ParaBD = old.ID_ParaBD;');
  Query.Script.Add('  if (new.ID_ParaBD is null) then new.ID_ParaBD = UDF_CREATEGUID();');
  Query.Script.Add('');
  Query.Script.Add('  if (new.DC_ParaBD is null) then new.DC_ParaBD = old.DC_ParaBD;');
  Query.Script.Add('');
  Query.Script.Add('  new.DM_ParaBD = cast(''now'' as timestamp);');
  Query.Script.Add('  if (inserting or new.DC_ParaBD is null) then new.DC_ParaBD = new.DM_ParaBD;');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TABLE COTES_PARABD (');
  Query.Script.Add('    ID_COTES_PARABD    T_GUID_NOTNULL,');
  Query.Script.Add('    REFPARABD          T_REFNOTNULL NOT NULL,');
  Query.Script.Add('    ANNEECOTE          SMALLINT NOT NULL,');
  Query.Script.Add('    PRIXCOTE           NUMERIC(15,2) NOT NULL,');
  Query.Script.Add('    DC_COTES_PARABD    T_TIMESTAMP_NOTNULL,');
  Query.Script.Add('    DM_COTES_PARABD    T_TIMESTAMP_NOTNULL');
  Query.Script.Add(');');

  Query.Script.Add('ALTER TABLE COTES_PARABD ADD CONSTRAINT COTES_PARABD_UNQ1 UNIQUE (ID_COTES_PARABD);');
  Query.Script.Add('ALTER TABLE COTES_PARABD ADD CONSTRAINT COTES_PARABD_PK PRIMARY KEY (ANNEECOTE, REFPARABD);');
  Query.Script.Add
    ('ALTER TABLE COTES_PARABD ADD CONSTRAINT COTES_PARABD_FK1 FOREIGN KEY (REFPARABD) REFERENCES PARABD (REFPARABD) ON DELETE CASCADE ON UPDATE CASCADE;');

  Query.Script.Add('CREATE TRIGGER COTES_PARABD_UNIQID_BIU0 FOR COTES_PARABD');
  Query.Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  if (new.ID_COTES_PARABD is null) then new.ID_COTES_PARABD = old.ID_COTES_PARABD;');
  Query.Script.Add('  if (new.ID_COTES_PARABD is null) then new.ID_COTES_PARABD = UDF_CREATEGUID();');
  Query.Script.Add('');
  Query.Script.Add('  if (new.DC_COTES_PARABD is null) then new.DC_COTES_PARABD = old.DC_COTES_PARABD;');
  Query.Script.Add('');
  Query.Script.Add('  new.DM_COTES_PARABD = cast(''now'' as timestamp);');
  Query.Script.Add('  if (inserting or new.DC_COTES_PARABD is null) then new.DC_COTES_PARABD = new.DM_COTES_PARABD;');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER PARABD_COTE_BIU1 FOR PARABD');
  Query.Script.Add('ACTIVE AFTER INSERT OR UPDATE POSITION 1');
  Query.Script.Add('AS');
  Query.Script.Add('declare variable existPRIX numeric(15,2);');
  Query.Script.Add('begin');
  Query.Script.Add('  if (new.anneecote is not null and new.prixcote is not null) then begin');
  Query.Script.Add('    select PRIXCOTE from COTES_PARABD where REFPARABD = new.refparabd AND ANNEECOTE = new.anneecote INTO :existPRIX;');
  Query.Script.Add('    if (existPRIX is null) then');
  Query.Script.Add('      INSERT INTO COTES_PARABD (REFPARABD, ANNEECOTE, PRIXCOTE) VALUES (new.refparabd, new.anneecote, new.prixcote);');
  Query.Script.Add('    else');
  Query.Script.Add('      UPDATE COTES_PARABD SET PRIXCOTE = new.prixcote WHERE REFPARABD = new.refparabd AND ANNEECOTE = new.anneecote;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE VIEW VW_LISTE_PARABD(');
  Query.Script.Add('    REFPARABD,');
  Query.Script.Add('    TITREPARABD,');
  Query.Script.Add('    REFSERIE,');
  Query.Script.Add('    TITRESERIE,');
  Query.Script.Add('    UPPERTITREPARABD,');
  Query.Script.Add('    UPPERTITRESERIE,');
  Query.Script.Add('    ACHAT,');
  Query.Script.Add('    COMPLET,');
  Query.Script.Add('    SCATEGORIE)');
  Query.Script.Add('AS');
  Query.Script.Add('select a.REFPARABD,');
  Query.Script.Add('       a.TITREPARABD,');
  Query.Script.Add('       a.REFSERIE,');
  Query.Script.Add('       s.TITRESERIE,');
  Query.Script.Add('       a.UPPERTITREPARABD,');
  Query.Script.Add('       s.UPPERTITRESERIE,');
  Query.Script.Add('       a.ACHAT,');
  Query.Script.Add('       a.COMPLET,');
  Query.Script.Add('       lc.LIBELLE');
  Query.Script.Add('FROM PARABD a INNER JOIN SERIES s ON s.refserie = a.refserie');
  Query.Script.Add('LEFT JOIN LISTES lc on (lc.ref = a.CATEGORIEPARABD and lc.categorie = 7);');

  Query.Script.Add('CREATE PROCEDURE SERIES_PARABD (');
  Query.Script.Add('    FILTRE VARCHAR(125))');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    TITRESERIE VARCHAR(150),');
  Query.Script.Add('    COUNTSERIE INTEGER,');
  Query.Script.Add('    REFSERIE INTEGER)');
  Query.Script.Add('AS');
  Query.Script.Add('DECLARE VARIABLE SWHERE VARCHAR(132);');
  Query.Script.Add('begin');
  Query.Script.Add('  swhere = '''';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''AND '' || filtre;');
  Query.Script.Add('');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('     ''select');
  Query.Script.Add('             -1,');
  Query.Script.Add('             RefSerie,');
  Query.Script.Add('             Count(REFPARABD)');
  Query.Script.Add('      from vw_liste_parabd');
  Query.Script.Add('      where TITRESerie is null '' || SWHERE ||');
  Query.Script.Add('    '' group by UPPERTITRESERIE, TITRESerie, RefSerie''');
  Query.Script.Add('  into :TITRESerie,');
  Query.Script.Add('       :RefSerie,');
  Query.Script.Add('       :countSerie');
  Query.Script.Add('  do');
  Query.Script.Add('    suspend;');
  Query.Script.Add('');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('     ''select');
  Query.Script.Add('             TITRESerie,');
  Query.Script.Add('             RefSerie,');
  Query.Script.Add('             Count(REFPARABD)');
  Query.Script.Add('      from vw_liste_parabd');
  Query.Script.Add('      where TITRESerie is not null '' || SWHERE ||');
  Query.Script.Add('    '' group by UPPERTITRESERIE, TITRESerie, RefSerie''');
  Query.Script.Add('  into :TITRESerie,');
  Query.Script.Add('       :RefSerie,');
  Query.Script.Add('       :countSerie');
  Query.Script.Add('  do');
  Query.Script.Add('    suspend;');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE PROCEDURE PARABD_BY_SERIE (');
  Query.Script.Add('    SERIE INTEGER,');
  Query.Script.Add('    FILTRE VARCHAR(125))');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    REFPARABD INTEGER,');
  Query.Script.Add('    TITREPARABD VARCHAR(150),');
  Query.Script.Add('    REFSERIE INTEGER,');
  Query.Script.Add('    TITRESERIE VARCHAR(150),');
  Query.Script.Add('    ACHAT SMALLINT,');
  Query.Script.Add('    COMPLET INTEGER,');
  Query.Script.Add('    SCATEGORIE VARCHAR(50))');
  Query.Script.Add('AS');
  Query.Script.Add('DECLARE VARIABLE SWHERE VARCHAR(130);');
  Query.Script.Add('BEGIN');
  Query.Script.Add('  swhere = '''';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''and '' || filtre || '' '';');
  Query.Script.Add('  FOR execute statement');
  Query.Script.Add('      ''SELECT REFPARABD,');
  Query.Script.Add('             TITREPARABD,');
  Query.Script.Add('             REFPARABD,');
  Query.Script.Add('             TITRESERIE,');
  Query.Script.Add('             ACHAT,');
  Query.Script.Add('             COMPLET,');
  Query.Script.Add('             SCATEGORIE');
  Query.Script.Add('      FROM vw_liste_PARABD');
  Query.Script.Add('      WHERE refserie = '''''' || :serie || '''''' '' || swhere ||');
  Query.Script.Add('      ''ORDER BY UPPERTITREPARABD''');
  Query.Script.Add('      INTO :REFPARABD,');
  Query.Script.Add('           :TITREPARABD,');
  Query.Script.Add('           :REFSERIE,');
  Query.Script.Add('           :TITRESERIE,');
  Query.Script.Add('           :ACHAT,');
  Query.Script.Add('           :COMPLET,');
  Query.Script.Add('           :SCATEGORIE');
  Query.Script.Add('  DO');
  Query.Script.Add('  BEGIN');
  Query.Script.Add('    SUSPEND;');
  Query.Script.Add('  END');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TABLE AUTEURS_PARABD (');
  Query.Script.Add('    ID_AUTEURS_PARABD  T_GUID_NOTNULL,');
  Query.Script.Add('    REFPARABD          T_REFNOTNULL,');
  Query.Script.Add('    REFPERSONNE        T_REFNOTNULL,');
  Query.Script.Add('    DC_AUTEURS_PARABD  T_TIMESTAMP_NOTNULL,');
  Query.Script.Add('    DM_AUTEURS_PARABD  T_TIMESTAMP_NOTNULL');
  Query.Script.Add(');');

  Query.Script.Add('ALTER TABLE AUTEURS_PARABD ADD CONSTRAINT AUTEURS_PARABD_UNQID UNIQUE (ID_AUTEURS_PARABD);');
  Query.Script.Add('ALTER TABLE AUTEURS_PARABD ADD CONSTRAINT AUTEURS_PARABD_PK PRIMARY KEY (REFPARABD, REFPERSONNE);');
  Query.Script.Add
    ('ALTER TABLE AUTEURS_PARABD ADD CONSTRAINT AUTEURS_PARABD_FK1 FOREIGN KEY (REFPARABD) REFERENCES PARABD (REFPARABD) ON DELETE CASCADE ON UPDATE CASCADE;');
  Query.Script.Add
    ('ALTER TABLE AUTEURS_PARABD ADD CONSTRAINT AUTEURS_PARABD_FK2 FOREIGN KEY (REFPERSONNE) REFERENCES PERSONNES (REFPERSONNE) ON DELETE CASCADE ON UPDATE CASCADE;');

  Query.Script.Add('CREATE TRIGGER AUTEURS_PARABD_UNIQID_BIU0 FOR AUTEURS_PARABD');
  Query.Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  if (new.ID_AUTEURS_PARABD is null) then new.ID_AUTEURS_PARABD = old.ID_AUTEURS_PARABD;');
  Query.Script.Add('  if (new.ID_AUTEURS_PARABD is null) then new.ID_AUTEURS_PARABD = UDF_CREATEGUID();');
  Query.Script.Add('');
  Query.Script.Add('  if (new.DC_AUTEURS_PARABD is null) then new.DC_AUTEURS_PARABD = old.DC_AUTEURS_PARABD;');
  Query.Script.Add('');
  Query.Script.Add('  new.DM_AUTEURS_PARABD = cast(''now'' as timestamp);');
  Query.Script.Add('  if (inserting or new.DC_AUTEURS_PARABD is null) then new.DC_AUTEURS_PARABD = new.DM_AUTEURS_PARABD;');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER PROCEDURE PROC_AUTEURS (');
  Query.Script.Add('    ALBUM INTEGER,');
  Query.Script.Add('    SERIE INTEGER,');
  Query.Script.Add('    PARABD INTEGER)');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    REFPERSONNE INTEGER,');
  Query.Script.Add('    NOMPERSONNE VARCHAR(150),');
  Query.Script.Add('    REFALBUM INTEGER,');
  Query.Script.Add('    REFSERIE INTEGER,');
  Query.Script.Add('    REFPARABD INTEGER,');
  Query.Script.Add('    METIER SMALLINT)');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  if (Album is not null) then');
  Query.Script.Add('    for select p.refpersonne,');
  Query.Script.Add('               p.nompersonne,');
  Query.Script.Add('               a.refalbum,');
  Query.Script.Add('               NULL,');
  Query.Script.Add('               NULL,');
  Query.Script.Add('               a.metier');
  Query.Script.Add('        from personnes p inner join auteurs a on a.refpersonne = p.refpersonne');
  Query.Script.Add('        where a.refalbum = :ALBUM');
  Query.Script.Add('        order by a.metier, p.uppernompersonne');
  Query.Script.Add('        into :REFPERSONNE,');
  Query.Script.Add('             :NOMPERSONNE,');
  Query.Script.Add('             :REFALBUM,');
  Query.Script.Add('             :REFSERIE,');
  Query.Script.Add('             :REFPARABD,');
  Query.Script.Add('             :METIER');
  Query.Script.Add('    do');
  Query.Script.Add('      suspend;');
  Query.Script.Add('');
  Query.Script.Add('  if (Serie is not null) then');
  Query.Script.Add('    for select p.refpersonne,');
  Query.Script.Add('               p.nompersonne,');
  Query.Script.Add('               NULL,');
  Query.Script.Add('               a.refserie,');
  Query.Script.Add('               NULL,');
  Query.Script.Add('               a.metier');
  Query.Script.Add('        from personnes p inner join auteurs_series a on a.refpersonne = p.refpersonne');
  Query.Script.Add('        where a.refserie = :SERIE');
  Query.Script.Add('        order by a.metier, p.uppernompersonne');
  Query.Script.Add('        into :REFPERSONNE,');
  Query.Script.Add('             :NOMPERSONNE,');
  Query.Script.Add('             :REFALBUM,');
  Query.Script.Add('             :REFSERIE,');
  Query.Script.Add('             :REFPARABD,');
  Query.Script.Add('             :METIER');
  Query.Script.Add('    do');
  Query.Script.Add('      suspend;');
  Query.Script.Add('');
  Query.Script.Add('  if (ParaBD is not null) then');
  Query.Script.Add('    for select p.refpersonne,');
  Query.Script.Add('               p.nompersonne,');
  Query.Script.Add('               NULL,');
  Query.Script.Add('               NULL,');
  Query.Script.Add('               a.refparabd,');
  Query.Script.Add('               NULL');
  Query.Script.Add('        from personnes p inner join auteurs_parabd a on a.refpersonne = p.refpersonne');
  Query.Script.Add('        where a.refparabd = :PARABD');
  Query.Script.Add('        order by p.uppernompersonne');
  Query.Script.Add('        into :REFPERSONNE,');
  Query.Script.Add('             :NOMPERSONNE,');
  Query.Script.Add('             :REFALBUM,');
  Query.Script.Add('             :REFSERIE,');
  Query.Script.Add('             :REFPARABD,');
  Query.Script.Add('             :METIER');
  Query.Script.Add('    do');
  Query.Script.Add('      suspend;');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER PARABD_DV FOR PARABD');
  Query.Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  if (inserting or new.TitrePARABD <> old.TitrePARABD) then begin');
  Query.Script.Add('    new.UpperTitrePARABD = UDF_UPPER(new.TitrePARABD);');
  Query.Script.Add('    new.SoundexTitrePARABD = UDF_SOUNDEX(new.TitrePARABD, 1);');
  Query.Script.Add('    select initiale from get_initiale(new.UpperTitrePARABD) into new.initialetitrePARABD;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('1.1.0.0', @MAJ1_1_0_0);

end.
