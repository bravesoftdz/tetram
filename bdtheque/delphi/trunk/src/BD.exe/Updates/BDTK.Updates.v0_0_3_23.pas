﻿unit BDTK.Updates.v0_0_3_23;

interface

implementation

uses
  UIB, BDTK.Updates;

procedure MAJ0_0_3_23(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add('ALTER PROCEDURE ALBUMS_BY_ANNEE (');
  Query.Script.Add('    ANNEE INTEGER,');
  Query.Script.Add('    FILTRE VARCHAR(125))');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    REFALBUM INTEGER,');
  Query.Script.Add('    TITREALBUM VARCHAR(150),');
  Query.Script.Add('    TOME SMALLINT,');
  Query.Script.Add('    TOMEDEBUT SMALLINT,');
  Query.Script.Add('    TOMEFIN SMALLINT,');
  Query.Script.Add('    HORSSERIE SMALLINT,');
  Query.Script.Add('    INTEGRALE SMALLINT,');
  Query.Script.Add('    ANNEEPARUTION SMALLINT,');
  Query.Script.Add('    REFSERIE INTEGER,');
  Query.Script.Add('    TITRESERIE VARCHAR(150),');
  Query.Script.Add('    ACHAT SMALLINT,');
  Query.Script.Add('    COMPLET INTEGER)');
  Query.Script.Add('AS');
  Query.Script.Add('DECLARE VARIABLE SWHERE VARCHAR(200);');
  Query.Script.Add('BEGIN');
  Query.Script.Add('  if (:Annee = -1) then sWhere = ''ANNEEPARUTION is null '';');
  Query.Script.Add('                   else sWhere = ''ANNEEPARUTION = '' || :ANNEE || '' '';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then swhere = swhere || ''and '' || filtre || '' '';');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('      ''SELECT REFALBUM,');
  Query.Script.Add('             TITREALBUM,');
  Query.Script.Add('             TOME,');
  Query.Script.Add('             TOMEDEBUT,');
  Query.Script.Add('             TOMEFIN,');
  Query.Script.Add('             HORSSERIE,');
  Query.Script.Add('             INTEGRALE,');
  Query.Script.Add('             ANNEEPARUTION,');
  Query.Script.Add('             REFSERIE,');
  Query.Script.Add('             TITRESERIE,');
  Query.Script.Add('             ACHAT,');
  Query.Script.Add('             COMPLET');
  Query.Script.Add('        FROM vw_liste_albums');
  Query.Script.Add('        WHERE '' || :sWHERE ||');
  Query.Script.Add
    ('        ''ORDER BY UPPERTITREALBUM, UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST''');
  Query.Script.Add('        INTO :REFALBUM,');
  Query.Script.Add('             :TITREALBUM,');
  Query.Script.Add('             :TOME,');
  Query.Script.Add('             :TOMEDEBUT,');
  Query.Script.Add('             :TOMEFIN,');
  Query.Script.Add('             :HORSSERIE,');
  Query.Script.Add('             :INTEGRALE,');
  Query.Script.Add('             :ANNEEPARUTION,');
  Query.Script.Add('             :REFSERIE,');
  Query.Script.Add('             :TITRESERIE,');
  Query.Script.Add('             :ACHAT,');
  Query.Script.Add('             :COMPLET');
  Query.Script.Add('      DO');
  Query.Script.Add('      BEGIN');
  Query.Script.Add('        SUSPEND;');
  Query.Script.Add('      END');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER PROCEDURE ALBUMS_BY_AUTEUR(');
  Query.Script.Add('    REFAUTEUR INTEGER)');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    REFALBUM INTEGER,');
  Query.Script.Add('    TITREALBUM VARCHAR(150),');
  Query.Script.Add('    TOME SMALLINT,');
  Query.Script.Add('    TOMEDEBUT SMALLINT,');
  Query.Script.Add('    TOMEFIN SMALLINT,');
  Query.Script.Add('    HORSSERIE SMALLINT,');
  Query.Script.Add('    INTEGRALE SMALLINT,');
  Query.Script.Add('    ANNEEPARUTION SMALLINT,');
  Query.Script.Add('    REFSERIE INTEGER,');
  Query.Script.Add('    TITRESERIE VARCHAR(150),');
  Query.Script.Add('    METIER SMALLINT)');
  Query.Script.Add('AS');
  Query.Script.Add('BEGIN');
  Query.Script.Add('  EXIT;');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER PROCEDURE ANNEES_ALBUMS');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    ANNEEPARUTION INTEGER,');
  Query.Script.Add('    COUNTANNEE INTEGER)');
  Query.Script.Add('AS');
  Query.Script.Add('BEGIN');
  Query.Script.Add('  EXIT;');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER PROCEDURE COLLECTIONS_ALBUMS');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    NOMCOLLECTION VARCHAR(50),');
  Query.Script.Add('    COUNTCOLLECTION INTEGER,');
  Query.Script.Add('    REFCOLLECTION INTEGER)');
  Query.Script.Add('AS');
  Query.Script.Add('BEGIN');
  Query.Script.Add('  EXIT;');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER PROCEDURE EDITEURS_ALBUMS');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    NOMEDITEUR VARCHAR(50),');
  Query.Script.Add('    COUNTEDITEUR INTEGER,');
  Query.Script.Add('    REFEDITEUR INTEGER)');
  Query.Script.Add('AS');
  Query.Script.Add('BEGIN');
  Query.Script.Add('  EXIT;');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER PROCEDURE GENRES_ALBUMS');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    GENRE VARCHAR(30),');
  Query.Script.Add('    COUNTGENRE INTEGER,');
  Query.Script.Add('    REFGENRE INTEGER)');
  Query.Script.Add('AS');
  Query.Script.Add('BEGIN');
  Query.Script.Add('  EXIT;');
  Query.Script.Add('end;');

  Query.Script.Add('DROP VIEW VW_LISTE_GENRES_ALBUMS;');
  Query.Script.Add('DROP VIEW VW_LISTE_EDITEURS_ALBUMS;');
  Query.Script.Add('DROP VIEW VW_LISTE_COLLECTIONS_ALBUMS;');
  Query.Script.Add('DROP VIEW VW_LISTE_ALBUMS;');

  Query.Script.Add('CREATE VIEW VW_LISTE_ALBUMS(');
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
  Query.Script.Add('       s.TITRESERIE,');
  Query.Script.Add('       a.UPPERTITREALBUM,');
  Query.Script.Add('       s.UPPERTITRESERIE,');
  Query.Script.Add('       a.ACHAT,');
  Query.Script.Add('       a.COMPLET');
  Query.Script.Add('FROM ALBUMS a INNER JOIN SERIES s ON s.refserie = a.refserie;');

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
  Query.Script.Add('       a.ACHAT,');
  Query.Script.Add('       a.COMPLET');
  Query.Script.Add('FROM VW_LISTE_ALBUMS a LEFT JOIN EDITIONS e ON e.refalbum = a.refalbum');
  Query.Script.Add('                       LEFT JOIN COLLECTIONS c ON e.refcollection = c.refcollection;');

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
  Query.Script.Add('       a.ACHAT,');
  Query.Script.Add('       a.COMPLET');
  Query.Script.Add('FROM VW_LISTE_ALBUMS a LEFT JOIN EDITIONS ed ON ed.refalbum = a.refalbum');
  Query.Script.Add('                       LEFT JOIN EDITEURS e ON e.refediteur = ed.refediteur;');

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
  Query.Script.Add('       a.ACHAT,');
  Query.Script.Add('       a.COMPLET');
  Query.Script.Add('FROM VW_LISTE_ALBUMS a LEFT JOIN GENRESERIES gs ON gs.refserie = a.refserie');
  Query.Script.Add('                       LEFT JOIN GENRES g ON gs.refgenre = g.refgenre;');

  Query.Script.Add('ALTER PROCEDURE ALBUMS_BY_AUTEUR (');
  Query.Script.Add('    REFAUTEUR INTEGER,');
  Query.Script.Add('    FILTRE VARCHAR(125))');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    REFALBUM INTEGER,');
  Query.Script.Add('    TITREALBUM VARCHAR(150),');
  Query.Script.Add('    TOME SMALLINT,');
  Query.Script.Add('    TOMEDEBUT SMALLINT,');
  Query.Script.Add('    TOMEFIN SMALLINT,');
  Query.Script.Add('    HORSSERIE SMALLINT,');
  Query.Script.Add('    INTEGRALE SMALLINT,');
  Query.Script.Add('    ANNEEPARUTION SMALLINT,');
  Query.Script.Add('    REFSERIE INTEGER,');
  Query.Script.Add('    TITRESERIE VARCHAR(150),');
  Query.Script.Add('    METIER SMALLINT,');
  Query.Script.Add('    ACHAT SMALLINT,');
  Query.Script.Add('    COMPLET INTEGER)');
  Query.Script.Add('AS');
  Query.Script.Add('DECLARE VARIABLE SWHERE VARCHAR(200);');
  Query.Script.Add('BEGIN');
  Query.Script.Add('  swhere = '''';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''and '' || filtre || '' '';');
  Query.Script.Add('  FOR execute statement');
  Query.Script.Add('     ''SELECT A.REFALBUM,');
  Query.Script.Add('             A.TITREALBUM,');
  Query.Script.Add('             A.TOME,');
  Query.Script.Add('             A.TOMEDEBUT,');
  Query.Script.Add('             A.TOMEFIN,');
  Query.Script.Add('             A.HORSSERIE,');
  Query.Script.Add('             A.INTEGRALE,');
  Query.Script.Add('             A.ANNEEPARUTION,');
  Query.Script.Add('             A.REFSERIE,');
  Query.Script.Add('             A.TITRESERIE,');
  Query.Script.Add('             AU.metier,');
  Query.Script.Add('             A.ACHAT,');
  Query.Script.Add('             A.COMPLET');
  Query.Script.Add('      FROM vw_liste_albums A INNER JOIN auteurs au on a.refalbum = au.refalbum');
  Query.Script.Add('      WHERE au.refpersonne = '''''' || :RefAuteur || '''''' '' || swhere ||');
  Query.Script.Add
    ('      ''ORDER BY UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, ANNEEPARUTION NULLS FIRST, UPPERTITREALBUM, METIER''');
  Query.Script.Add('      INTO :REFALBUM,');
  Query.Script.Add('           :TITREALBUM,');
  Query.Script.Add('           :TOME,');
  Query.Script.Add('           :TOMEDEBUT,');
  Query.Script.Add('           :TOMEFIN,');
  Query.Script.Add('           :HORSSERIE,');
  Query.Script.Add('           :INTEGRALE,');
  Query.Script.Add('           :ANNEEPARUTION,');
  Query.Script.Add('           :REFSERIE,');
  Query.Script.Add('           :TITRESERIE,');
  Query.Script.Add('           :METIER,');
  Query.Script.Add('           :ACHAT,');
  Query.Script.Add('           :COMPLET');
  Query.Script.Add('      DO');
  Query.Script.Add('      BEGIN');
  Query.Script.Add('        SUSPEND;');
  Query.Script.Add('      END');
  Query.Script.Add('END;');

  Query.Script.Add('ALTER PROCEDURE ANNEES_ALBUMS (');
  Query.Script.Add('    FILTRE VARCHAR(125))');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    ANNEEPARUTION SMALLINT,');
  Query.Script.Add('    COUNTANNEE INTEGER)');
  Query.Script.Add('AS');
  Query.Script.Add('DECLARE VARIABLE SWHERE VARCHAR(133);');
  Query.Script.Add('begin');
  Query.Script.Add('  swhere = '''';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''AND '' || filtre;');
  Query.Script.Add('');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('     ''select');
  Query.Script.Add('             CAST(-1 AS SMALLINT),');
  Query.Script.Add('             Count(REFALBUM)');
  Query.Script.Add('      from vw_liste_albums');
  Query.Script.Add('      where AnneeParution is null '' || SWHERE ||');
  Query.Script.Add('     ''group by AnneeParution''');
  Query.Script.Add('  into :AnneeParution,');
  Query.Script.Add('       :countannee');
  Query.Script.Add('  do begin');
  Query.Script.Add('    suspend;');
  Query.Script.Add('  end');
  Query.Script.Add('');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('     ''select');
  Query.Script.Add('             AnneeParution,');
  Query.Script.Add('             Count(REFALBUM)');
  Query.Script.Add('      from vw_liste_albums');
  Query.Script.Add('      where AnneeParution is not null '' || SWHERE ||');
  Query.Script.Add('     ''group by AnneeParution''');
  Query.Script.Add('  into :AnneeParution,');
  Query.Script.Add('       :countannee');
  Query.Script.Add('  do begin');
  Query.Script.Add('    suspend;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER PROCEDURE COLLECTIONS_ALBUMS (');
  Query.Script.Add('    FILTRE VARCHAR(125))');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    NOMCOLLECTION VARCHAR(50),');
  Query.Script.Add('    COUNTCOLLECTION INTEGER,');
  Query.Script.Add('    REFCOLLECTION INTEGER)');
  Query.Script.Add('AS');
  Query.Script.Add('DECLARE VARIABLE SWHERE VARCHAR(133);');
  Query.Script.Add('begin');
  Query.Script.Add('  swhere = '''';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''AND '' || filtre;');
  Query.Script.Add('');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('     ''select');
  Query.Script.Add('             CAST(''''-1'''' AS VARCHAR(50)),');
  Query.Script.Add('             Count(REFALBUM),');
  Query.Script.Add('             -1');
  Query.Script.Add('      from vw_liste_collections_albums');
  Query.Script.Add('      where REFCOLLECTION is null '' || SWHERE ||');
  Query.Script.Add('     ''group by uppernomcollection, nomCOLLECTION, refCOLLECTION''');
  Query.Script.Add('  into :nomCOLLECTION,');
  Query.Script.Add('       :countCOLLECTION,');
  Query.Script.Add('       :RefCOLLECTION');
  Query.Script.Add('  do begin');
  Query.Script.Add('    suspend;');
  Query.Script.Add('  end');
  Query.Script.Add('');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('     ''select');
  Query.Script.Add('             nomCOLLECTION,');
  Query.Script.Add('             Count(REFALBUM),');
  Query.Script.Add('             RefCOLLECTION');
  Query.Script.Add('      from vw_liste_collections_albums');
  Query.Script.Add('      where REFCOLLECTION is not null '' || SWHERE ||');
  Query.Script.Add('     ''group by uppernomcollection, nomCOLLECTION, refCOLLECTION''');
  Query.Script.Add('  into :nomCOLLECTION,');
  Query.Script.Add('       :countCOLLECTION,');
  Query.Script.Add('       :RefCOLLECTION');
  Query.Script.Add('  do begin');
  Query.Script.Add('    suspend;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER PROCEDURE EDITEURS_ALBUMS (');
  Query.Script.Add('    FILTRE VARCHAR(125))');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    NOMEDITEUR VARCHAR(50),');
  Query.Script.Add('    COUNTEDITEUR INTEGER,');
  Query.Script.Add('    REFEDITEUR INTEGER)');
  Query.Script.Add('AS');
  Query.Script.Add('DECLARE VARIABLE SWHERE VARCHAR(133);');
  Query.Script.Add('begin');
  Query.Script.Add('  swhere = '''';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''AND '' || filtre;');
  Query.Script.Add('');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('     ''select');
  Query.Script.Add('             CAST(''''-1'''' AS VARCHAR(50)),');
  Query.Script.Add('             Count(REFALBUM),');
  Query.Script.Add('             -1');
  Query.Script.Add('      from vw_liste_editeurs_albums');
  Query.Script.Add('      where REFEDITEUR is null '' || SWHERE ||');
  Query.Script.Add('     ''group by uppernomediteur, nomediteur, refediteur''');
  Query.Script.Add('  into :nomediteur,');
  Query.Script.Add('       :countediteur,');
  Query.Script.Add('       :RefEditeur');
  Query.Script.Add('  do begin');
  Query.Script.Add('    suspend;');
  Query.Script.Add('  end');
  Query.Script.Add('');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('     ''select');
  Query.Script.Add('             nomediteur,');
  Query.Script.Add('             Count(REFALBUM),');
  Query.Script.Add('             RefEditeur');
  Query.Script.Add('      from vw_liste_editeurs_albums');
  Query.Script.Add('      where REFEDITEUR is not null '' || SWHERE ||');
  Query.Script.Add('     ''group by uppernomediteur, nomediteur, refediteur''');
  Query.Script.Add('  into :nomediteur,');
  Query.Script.Add('       :countediteur,');
  Query.Script.Add('       :RefEditeur');
  Query.Script.Add('  do begin');
  Query.Script.Add('    suspend;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER PROCEDURE GENRES_ALBUMS (');
  Query.Script.Add('    FILTRE VARCHAR(125))');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    GENRE VARCHAR(30),');
  Query.Script.Add('    COUNTGENRE INTEGER,');
  Query.Script.Add('    REFGENRE INTEGER)');
  Query.Script.Add('AS');
  Query.Script.Add('DECLARE VARIABLE SWHERE VARCHAR(132);');
  Query.Script.Add('begin');
  Query.Script.Add('  swhere = '''';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''AND '' || filtre;');
  Query.Script.Add('');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('     ''select');
  Query.Script.Add('             CAST(''''-1'''' AS VARCHAR(30)),');
  Query.Script.Add('             Count(REFALBUM),');
  Query.Script.Add('             -1');
  Query.Script.Add('      from vw_liste_genres_albums');
  Query.Script.Add('      where REFGENRE is null '' || SWHERE ||');
  Query.Script.Add('     ''group by uppergenre, Genre, refgenre''');
  Query.Script.Add('  into :genre,');
  Query.Script.Add('       :countgenre,');
  Query.Script.Add('       :refgenre');
  Query.Script.Add('  do begin');
  Query.Script.Add('    suspend;');
  Query.Script.Add('  end');
  Query.Script.Add('');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('     ''select');
  Query.Script.Add('             Genre,');
  Query.Script.Add('             Count(REFALBUM),');
  Query.Script.Add('             refgenre');
  Query.Script.Add('      from vw_liste_genres_albums');
  Query.Script.Add('      where REFGENRE is not null '' || SWHERE ||');
  Query.Script.Add('     ''group by uppergenre, Genre, refgenre''');
  Query.Script.Add('  into :genre,');
  Query.Script.Add('       :countgenre,');
  Query.Script.Add('       :refgenre');
  Query.Script.Add('  do begin');
  Query.Script.Add('    suspend;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER PROCEDURE ALBUMS_BY_COLLECTION (');
  Query.Script.Add('    REFCOLLECTION INTEGER,');
  Query.Script.Add('    FILTRE VARCHAR(125))');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    REFALBUM INTEGER,');
  Query.Script.Add('    TITREALBUM VARCHAR(150),');
  Query.Script.Add('    TOME SMALLINT,');
  Query.Script.Add('    TOMEDEBUT SMALLINT,');
  Query.Script.Add('    TOMEFIN SMALLINT,');
  Query.Script.Add('    HORSSERIE SMALLINT,');
  Query.Script.Add('    INTEGRALE SMALLINT,');
  Query.Script.Add('    ANNEEPARUTION SMALLINT,');
  Query.Script.Add('    REFSERIE INTEGER,');
  Query.Script.Add('    TITRESERIE VARCHAR(150),');
  Query.Script.Add('    ACHAT SMALLINT,');
  Query.Script.Add('    COMPLET INTEGER)');
  Query.Script.Add('AS');
  Query.Script.Add('DECLARE VARIABLE SWHERE VARCHAR(200);');
  Query.Script.Add('BEGIN');
  Query.Script.Add('  if (:refCOLLECTION = -1) then sWhere = ''e.refCOLLECTION is null '';');
  Query.Script.Add('                           else sWhere = ''e.refCOLLECTION = '' || :refCOLLECTION || '' '';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then swhere = swhere || ''and '' || filtre || '' '';');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('      ''SELECT a.REFALBUM,');
  Query.Script.Add('             a.TITREALBUM,');
  Query.Script.Add('             a.TOME,');
  Query.Script.Add('             a.TOMEDEBUT,');
  Query.Script.Add('             a.TOMEFIN,');
  Query.Script.Add('             a.HORSSERIE,');
  Query.Script.Add('             a.INTEGRALE,');
  Query.Script.Add('             a.ANNEEPARUTION,');
  Query.Script.Add('             a.REFSERIE,');
  Query.Script.Add('             s.TITRESERIE,');
  Query.Script.Add('             a.ACHAT,');
  Query.Script.Add('             a.COMPLET');
  Query.Script.Add('      from albums a left join editions e on a.refalbum = e.refalbum');
  Query.Script.Add('                    left join series s on a.refserie = s.refserie');
  Query.Script.Add('      WHERE '' || :sWHERE ||');
  Query.Script.Add
    ('     ''ORDER BY UPPERTITREALBUM, UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST''');
  Query.Script.Add('      INTO :REFALBUM,');
  Query.Script.Add('           :TITREALBUM,');
  Query.Script.Add('           :TOME,');
  Query.Script.Add('           :TOMEDEBUT,');
  Query.Script.Add('           :TOMEFIN,');
  Query.Script.Add('           :HORSSERIE,');
  Query.Script.Add('           :INTEGRALE,');
  Query.Script.Add('           :ANNEEPARUTION,');
  Query.Script.Add('           :REFSERIE,');
  Query.Script.Add('           :TITRESERIE,');
  Query.Script.Add('           :ACHAT,');
  Query.Script.Add('           :COMPLET');
  Query.Script.Add('      DO');
  Query.Script.Add('      BEGIN');
  Query.Script.Add('        SUSPEND;');
  Query.Script.Add('      END');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER PROCEDURE ALBUMS_BY_EDITEUR (');
  Query.Script.Add('    REFEDITEUR INTEGER,');
  Query.Script.Add('    FILTRE VARCHAR(125))');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    REFALBUM Integer,');
  Query.Script.Add('    TITREALBUM VARCHAR(150),');
  Query.Script.Add('    TOME Smallint,');
  Query.Script.Add('    TOMEDEBUT Smallint,');
  Query.Script.Add('    TOMEFIN Smallint,');
  Query.Script.Add('    HORSSERIE Smallint,');
  Query.Script.Add('    INTEGRALE Smallint,');
  Query.Script.Add('    ANNEEPARUTION Smallint,');
  Query.Script.Add('    REFSERIE Integer,');
  Query.Script.Add('    TITRESERIE VARCHAR(150),');
  Query.Script.Add('    ACHAT Smallint,');
  Query.Script.Add('    COMPLET INTEGER)');
  Query.Script.Add('AS');
  Query.Script.Add('DECLARE VARIABLE SWHERE VARCHAR(133);');
  Query.Script.Add('BEGIN');
  Query.Script.Add('  swhere = '''';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''and '' || filtre || '' '';');
  Query.Script.Add('  FOR execute statement');
  Query.Script.Add('     ''SELECT a.REFALBUM,');
  Query.Script.Add('             a.TITREALBUM,');
  Query.Script.Add('             a.TOME,');
  Query.Script.Add('             a.TOMEDEBUT,');
  Query.Script.Add('             a.TOMEFIN,');
  Query.Script.Add('             a.HORSSERIE,');
  Query.Script.Add('             a.INTEGRALE,');
  Query.Script.Add('             a.ANNEEPARUTION,');
  Query.Script.Add('             a.REFSERIE,');
  Query.Script.Add('             s.TITRESERIE,');
  Query.Script.Add('             a.ACHAT,');
  Query.Script.Add('             a.COMPLET');
  Query.Script.Add('      from albums a LEFT join editions e on a.refalbum = e.refalbum');
  Query.Script.Add('                    LEFT join series s on a.refserie = s.refserie');
  Query.Script.Add('      WHERE e.refediteur = '''''' || :refediteur || '''''' '' || swhere ||');
  Query.Script.Add
    ('      ''ORDER BY UPPERTITREALBUM, UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST''');
  Query.Script.Add('      INTO :REFALBUM,');
  Query.Script.Add('           :TITREALBUM,');
  Query.Script.Add('           :TOME,');
  Query.Script.Add('           :TOMEDEBUT,');
  Query.Script.Add('           :TOMEFIN,');
  Query.Script.Add('           :HORSSERIE,');
  Query.Script.Add('           :INTEGRALE,');
  Query.Script.Add('           :ANNEEPARUTION,');
  Query.Script.Add('           :REFSERIE,');
  Query.Script.Add('           :TITRESERIE,');
  Query.Script.Add('           :ACHAT,');
  Query.Script.Add('           :COMPLET');
  Query.Script.Add('  DO');
  Query.Script.Add('  BEGIN');
  Query.Script.Add('    SUSPEND;');
  Query.Script.Add('  END');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER PROCEDURE ALBUMS_BY_GENRE (');
  Query.Script.Add('    REFGENRE INTEGER,');
  Query.Script.Add('    FILTRE VARCHAR(125))');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    REFALBUM INTEGER,');
  Query.Script.Add('    TITREALBUM VARCHAR(150),');
  Query.Script.Add('    TOME SMALLINT,');
  Query.Script.Add('    TOMEDEBUT SMALLINT,');
  Query.Script.Add('    TOMEFIN SMALLINT,');
  Query.Script.Add('    HORSSERIE SMALLINT,');
  Query.Script.Add('    INTEGRALE SMALLINT,');
  Query.Script.Add('    ANNEEPARUTION SMALLINT,');
  Query.Script.Add('    REFSERIE INTEGER,');
  Query.Script.Add('    TITRESERIE VARCHAR(150),');
  Query.Script.Add('    ACHAT SMALLINT,');
  Query.Script.Add('    COMPLET INTEGER)');
  Query.Script.Add('AS');
  Query.Script.Add('DECLARE VARIABLE SWHERE VARCHAR(200);');
  Query.Script.Add('BEGIN');
  Query.Script.Add('  if (:RefGenre = -1) then sWhere = ''RefGenre is null '';');
  Query.Script.Add('                      else sWhere = ''refgenre = '' || :refgenre || '' '';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then swhere = swhere || ''and '' || filtre || '' '';');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('      ''SELECT REFALBUM,');
  Query.Script.Add('             TITREALBUM,');
  Query.Script.Add('             TOME,');
  Query.Script.Add('             TOMEDEBUT,');
  Query.Script.Add('             TOMEFIN,');
  Query.Script.Add('             HORSSERIE,');
  Query.Script.Add('             INTEGRALE,');
  Query.Script.Add('             ANNEEPARUTION,');
  Query.Script.Add('             a.REFSERIE,');
  Query.Script.Add('             TITRESERIE,');
  Query.Script.Add('             ACHAT,');
  Query.Script.Add('             COMPLET');
  Query.Script.Add('       FROM VW_LISTE_ALBUMS a LEFT JOIN GENRESERIES gs ON gs.refserie = a.refserie');
  Query.Script.Add('                              LEFT JOIN GENRES g ON gs.refgenre = g.refgenre');
  Query.Script.Add('       WHERE '' || :sWHERE ||');
  Query.Script.Add
    ('      ''ORDER BY UPPERTITREALBUM, UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST''');
  Query.Script.Add('       INTO :REFALBUM,');
  Query.Script.Add('            :TITREALBUM,');
  Query.Script.Add('            :TOME,');
  Query.Script.Add('            :TOMEDEBUT,');
  Query.Script.Add('            :TOMEFIN,');
  Query.Script.Add('            :HORSSERIE,');
  Query.Script.Add('            :INTEGRALE,');
  Query.Script.Add('            :ANNEEPARUTION,');
  Query.Script.Add('            :REFSERIE,');
  Query.Script.Add('            :TITRESERIE,');
  Query.Script.Add('            :ACHAT,');
  Query.Script.Add('            :COMPLET');
  Query.Script.Add('      DO');
  Query.Script.Add('      BEGIN');
  Query.Script.Add('        SUSPEND;');
  Query.Script.Add('      END');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER PROCEDURE ALBUMS_BY_INITIALE (');
  Query.Script.Add('    INITIALE CHAR(1),');
  Query.Script.Add('    FILTRE VARCHAR(125))');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    REFALBUM INTEGER,');
  Query.Script.Add('    TITREALBUM VARCHAR(150),');
  Query.Script.Add('    TOME SMALLINT,');
  Query.Script.Add('    TOMEDEBUT SMALLINT,');
  Query.Script.Add('    TOMEFIN SMALLINT,');
  Query.Script.Add('    HORSSERIE SMALLINT,');
  Query.Script.Add('    INTEGRALE SMALLINT,');
  Query.Script.Add('    ANNEEPARUTION SMALLINT,');
  Query.Script.Add('    REFSERIE INTEGER,');
  Query.Script.Add('    TITRESERIE VARCHAR(150),');
  Query.Script.Add('    ACHAT SMALLINT,');
  Query.Script.Add('    COMPLET INTEGER)');
  Query.Script.Add('AS');
  Query.Script.Add('DECLARE VARIABLE SWHERE VARCHAR(133);');
  Query.Script.Add('BEGIN');
  Query.Script.Add('  swhere = '''';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''and '' || filtre || '' '';');
  Query.Script.Add('  FOR execute statement');
  Query.Script.Add('     ''SELECT a.REFALBUM,');
  Query.Script.Add('             a.TITREALBUM,');
  Query.Script.Add('             a.TOME,');
  Query.Script.Add('             a.TOMEDEBUT,');
  Query.Script.Add('             a.TOMEFIN,');
  Query.Script.Add('             a.HORSSERIE,');
  Query.Script.Add('             a.INTEGRALE,');
  Query.Script.Add('             a.ANNEEPARUTION,');
  Query.Script.Add('             a.REFSERIE,');
  Query.Script.Add('             s.TITRESERIE,');
  Query.Script.Add('             a.ACHAT,');
  Query.Script.Add('             a.COMPLET');
  Query.Script.Add('      FROM ALBUMS a INNER JOIN SERIES s ON s.refserie = a.refserie');
  Query.Script.Add('      WHERE a.initialetitrealbum = '''''' || :INITIALE || '''''' '' || swhere ||');
  Query.Script.Add
    ('      ''ORDER BY UPPERTITREALBUM, UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST''');
  Query.Script.Add('      INTO :REFALBUM,');
  Query.Script.Add('           :TITREALBUM,');
  Query.Script.Add('           :TOME,');
  Query.Script.Add('           :TOMEDEBUT,');
  Query.Script.Add('           :TOMEFIN,');
  Query.Script.Add('           :HORSSERIE,');
  Query.Script.Add('           :INTEGRALE,');
  Query.Script.Add('           :ANNEEPARUTION,');
  Query.Script.Add('           :REFSERIE,');
  Query.Script.Add('           :TITRESERIE,');
  Query.Script.Add('           :ACHAT,');
  Query.Script.Add('           :COMPLET');
  Query.Script.Add('  DO');
  Query.Script.Add('  BEGIN');
  Query.Script.Add('    SUSPEND;');
  Query.Script.Add('  END');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER PROCEDURE ALBUMS_BY_SERIE (');
  Query.Script.Add('    SERIE INTEGER,');
  Query.Script.Add('    FILTRE VARCHAR(125))');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    REFALBUM INTEGER,');
  Query.Script.Add('    TITREALBUM VARCHAR(150),');
  Query.Script.Add('    TOME SMALLINT,');
  Query.Script.Add('    TOMEDEBUT SMALLINT,');
  Query.Script.Add('    TOMEFIN SMALLINT,');
  Query.Script.Add('    HORSSERIE SMALLINT,');
  Query.Script.Add('    INTEGRALE SMALLINT,');
  Query.Script.Add('    ANNEEPARUTION SMALLINT,');
  Query.Script.Add('    REFSERIE INTEGER,');
  Query.Script.Add('    TITRESERIE VARCHAR(150),');
  Query.Script.Add('    ACHAT SMALLINT,');
  Query.Script.Add('    COMPLET INTEGER)');
  Query.Script.Add('AS');
  Query.Script.Add('DECLARE VARIABLE SWHERE VARCHAR(130);');
  Query.Script.Add('BEGIN');
  Query.Script.Add('  swhere = '''';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''and '' || filtre || '' '';');
  Query.Script.Add('  FOR execute statement');
  Query.Script.Add('      ''SELECT REFALBUM,');
  Query.Script.Add('             TITREALBUM,');
  Query.Script.Add('             TOME,');
  Query.Script.Add('             TOMEDEBUT,');
  Query.Script.Add('             TOMEFIN,');
  Query.Script.Add('             HORSSERIE,');
  Query.Script.Add('             INTEGRALE,');
  Query.Script.Add('             ANNEEPARUTION,');
  Query.Script.Add('             REFSERIE,');
  Query.Script.Add('             TITRESERIE,');
  Query.Script.Add('             ACHAT,');
  Query.Script.Add('             COMPLET');
  Query.Script.Add('      FROM vw_liste_albums');
  Query.Script.Add('      WHERE refserie = '''''' || :serie || '''''' '' || swhere ||');
  Query.Script.Add('      ''ORDER BY HORSSERIE NULLS FIRST, INTEGRALE NULLS First, TOME NULLS FIRST, ANNEEPARUTION NULLS FIRST, UPPERTITREALBUM''');
  Query.Script.Add('      INTO :REFALBUM,');
  Query.Script.Add('           :TITREALBUM,');
  Query.Script.Add('           :TOME,');
  Query.Script.Add('           :TOMEDEBUT,');
  Query.Script.Add('           :TOMEFIN,');
  Query.Script.Add('           :HORSSERIE,');
  Query.Script.Add('           :INTEGRALE,');
  Query.Script.Add('           :ANNEEPARUTION,');
  Query.Script.Add('           :REFSERIE,');
  Query.Script.Add('           :TITRESERIE,');
  Query.Script.Add('           :ACHAT,');
  Query.Script.Add('           :COMPLET');
  Query.Script.Add('  DO');
  Query.Script.Add('  BEGIN');
  Query.Script.Add('    SUSPEND;');
  Query.Script.Add('  END');
  Query.Script.Add('end;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('0.0.3.23', @MAJ0_0_3_23);

end.
