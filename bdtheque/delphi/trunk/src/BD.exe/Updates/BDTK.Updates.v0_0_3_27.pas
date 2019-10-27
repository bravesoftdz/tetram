unit BDTK.Updates.v0_0_3_27;

interface

implementation

uses
  UIB, BDTK.Updates;

procedure MAJ0_0_3_27(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add('ALTER TABLE ALBUMS ADD MOISPARUTION SMALLINT, ALTER MOISPARUTION POSITION 4;');

  Query.Script.Add('ALTER PROCEDURE PREVISIONS_SORTIES (');
  Query.Script.Add('    WITHACHAT SMALLINT,');
  Query.Script.Add('    IN_REFSERIE INTEGER)');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    REFSERIE INTEGER,');
  Query.Script.Add('    TITRESERIE VARCHAR(150),');
  Query.Script.Add('    UPPERTITRESERIE VARCHAR(150),');
  Query.Script.Add('    TOME INTEGER,');
  Query.Script.Add('    ANNEEPARUTION INTEGER,');
  Query.Script.Add('    MOISPARUTION INTEGER,');
  Query.Script.Add('    REFEDITEUR INTEGER,');
  Query.Script.Add('    NOMEDITEUR VARCHAR(50),');
  Query.Script.Add('    REFCOLLECTION INTEGER,');
  Query.Script.Add('    NOMCOLLECTION VARCHAR(50))');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  suspend;');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER PROCEDURE CALCUL_ANNEE_SORTIE (');
  Query.Script.Add('    WITHACHAT SMALLINT,');
  Query.Script.Add('    IN_REFSERIE INTEGER,');
  Query.Script.Add('    SOMMEPONDEREE INTEGER,');
  Query.Script.Add('    COMPTEALBUM INTEGER,');
  Query.Script.Add('    MAXTOME INTEGER,');
  Query.Script.Add('    MAXANNEE INTEGER,');
  Query.Script.Add('    MAXMOIS INTEGER)');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    REFSERIE INTEGER,');
  Query.Script.Add('    TITRESERIE VARCHAR(150),');
  Query.Script.Add('    UPPERTITRESERIE VARCHAR(150),');
  Query.Script.Add('    TOME INTEGER,');
  Query.Script.Add('    ANNEEPARUTION INTEGER,');
  Query.Script.Add('    MOISPARUTION INTEGER,');
  Query.Script.Add('    REFEDITEUR INTEGER,');
  Query.Script.Add('    NOMEDITEUR VARCHAR(50),');
  Query.Script.Add('    REFCOLLECTION INTEGER,');
  Query.Script.Add('    NOMCOLLECTION VARCHAR(50))');
  Query.Script.Add('AS');
  Query.Script.Add('DECLARE VARIABLE MAXTOME2 INTEGER;');
  Query.Script.Add('begin');
  Query.Script.Add('  tome = maxtome + 1;');
  Query.Script.Add('');
  Query.Script.Add('  select max(tomefin) + 1 from albums');
  Query.Script.Add('  where horsserie = 0 and integrale = 1 and refserie = :in_refserie and (:withachat = 1 or achat = 0)');
  Query.Script.Add('  into');
  Query.Script.Add('    :MAXTOME2;');
  Query.Script.Add('');
  Query.Script.Add('  if (maxtome2 > tome) then tome = maxtome2;');
  Query.Script.Add('');
  Query.Script.Add('  select s.RefSerie, s.TitreSerie, s.UpperTitreSerie, e.RefEditeur, e.NomEditeur, c.RefCollection, c.NomCollection from');
  Query.Script.Add('    series s left join editeurs e on e.refediteur = s.refediteur');
  Query.Script.Add('             left join collections c on c.refcollection = s.refcollection');
  Query.Script.Add('  where s.RefSerie = :in_refserie');
  Query.Script.Add('  into');
  Query.Script.Add('    :REFSERIE,');
  Query.Script.Add('    :TITRESERIE,');
  Query.Script.Add('    :UPPERTITRESERIE,');
  Query.Script.Add('    :REFEDITEUR,');
  Query.Script.Add('    :NOMEDITEUR,');
  Query.Script.Add('    :REFCOLLECTION,');
  Query.Script.Add('    :NOMCOLLECTION;');
  Query.Script.Add('');
  Query.Script.Add('  if (maxmois is null) then begin');
  Query.Script.Add('    ANNEEPARUTION = maxannee + ((tome - maxtome) * ((sommeponderee / 12) / comptealbum));');
  Query.Script.Add('    MOISPARUTION = null;');
  Query.Script.Add('  end else begin');
  Query.Script.Add('    MOISPARUTION = maxmois + ((tome - maxtome) * (sommeponderee / comptealbum));');
  Query.Script.Add('    ANNEEPARUTION = maxannee;');
  Query.Script.Add('    while (MOISPARUTION > 12) do begin');
  Query.Script.Add('      MOISPARUTION = MOISPARUTION - 12;');
  Query.Script.Add('      ANNEEPARUTION = ANNEEPARUTION + 1;');
  Query.Script.Add('    end');
  Query.Script.Add('  end');
  Query.Script.Add('  suspend;');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER PROCEDURE PREVISIONS_SORTIES (');
  Query.Script.Add('    WITHACHAT SMALLINT,');
  Query.Script.Add('    IN_REFSERIE INTEGER)');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    REFSERIE INTEGER,');
  Query.Script.Add('    TITRESERIE VARCHAR(150),');
  Query.Script.Add('    UPPERTITRESERIE VARCHAR(150),');
  Query.Script.Add('    TOME INTEGER,');
  Query.Script.Add('    ANNEEPARUTION INTEGER,');
  Query.Script.Add('    MOISPARUTION INTEGER,');
  Query.Script.Add('    REFEDITEUR INTEGER,');
  Query.Script.Add('    NOMEDITEUR VARCHAR(50),');
  Query.Script.Add('    REFCOLLECTION INTEGER,');
  Query.Script.Add('    NOMCOLLECTION VARCHAR(50))');
  Query.Script.Add('AS');
  Query.Script.Add('DECLARE VARIABLE CURRENTREFSERIE INTEGER;');
  Query.Script.Add('DECLARE VARIABLE OLDREFSERIE INTEGER;');
  Query.Script.Add('DECLARE VARIABLE CURRENTTOME INTEGER;');
  Query.Script.Add('DECLARE VARIABLE SOMMEPONDEREE INTEGER;');
  Query.Script.Add('DECLARE VARIABLE COMPTEALBUM INTEGER;');
  Query.Script.Add('DECLARE VARIABLE CURRENTANNEE INTEGER;');
  Query.Script.Add('DECLARE VARIABLE CURRENTMOIS INTEGER;');
  Query.Script.Add('DECLARE VARIABLE TOMEPRECEDENT INTEGER;');
  Query.Script.Add('DECLARE VARIABLE ANNEEPRECEDENTE INTEGER;');
  Query.Script.Add('DECLARE VARIABLE MOISPRECEDENT INTEGER;');
  Query.Script.Add('begin');
  Query.Script.Add('  if (withachat is Null) then withachat = 1;');
  Query.Script.Add('  oldrefserie = -1;');
  Query.Script.Add('  tomeprecedent = -1;');
  Query.Script.Add('  anneeprecedente = -1;');
  Query.Script.Add('  moisprecedent = null;');
  Query.Script.Add('  for select TOME, ANNEEPARUTION, MOISPARUTION, s.RefSerie');
  Query.Script.Add('      from albums a inner join series s on s.refserie = a.refserie');
  Query.Script.Add('      where (s.terminee is null or s.terminee <> 1)');
  Query.Script.Add('            and a.horsserie = 0 and a.integrale = 0 and a.anneeparution is not null');
  Query.Script.Add('            and (:in_refserie is null or s.refserie = :in_refserie)');
  Query.Script.Add('            and (:withachat = 1 or achat = 0)');
  Query.Script.Add('      order by s.refserie, TOME');
  Query.Script.Add('      into :CURRENTTOME, :CURRENTANNEE, :CURRENTMOIS, :CURRENTREFSERIE');
  Query.Script.Add('  do begin');
  Query.Script.Add('    if (currentrefserie <> oldrefserie) then begin');
  Query.Script.Add('');
  Query.Script.Add('      if (oldrefserie <> -1 and comptealbum > 0) then begin');
  Query.Script.Add('        select REFSERIE, TITRESERIE, UPPERTITRESERIE,');
  Query.Script.Add('               TOME, ANNEEPARUTION, MOISPARUTION,');
  Query.Script.Add('               REFEDITEUR, NOMEDITEUR,');
  Query.Script.Add('               REFCOLLECTION, NOMCOLLECTION');
  Query.Script.Add
    ('        from CALCUL_ANNEE_SORTIE(:withachat, :oldrefserie, :sommeponderee, :comptealbum, :tomeprecedent, :anneeprecedente, :moisprecedent)');
  Query.Script.Add('        into :REFSERIE, :TITRESERIE, :UPPERTITRESERIE,');
  Query.Script.Add('             :TOME, :ANNEEPARUTION, :MOISPARUTION,');
  Query.Script.Add('             :REFEDITEUR, :NOMEDITEUR,');
  Query.Script.Add('             :REFCOLLECTION, :NOMCOLLECTION;');
  Query.Script.Add('        suspend;');
  Query.Script.Add('      end');
  Query.Script.Add('');
  Query.Script.Add('      oldrefserie = currentrefserie;');
  Query.Script.Add('      sommeponderee = 0;');
  Query.Script.Add('      comptealbum = 0;');
  Query.Script.Add('      tomeprecedent = -1;');
  Query.Script.Add('      anneeprecedente = -1;');
  Query.Script.Add('      moisprecedent = -1;');
  Query.Script.Add('    end');
  Query.Script.Add('    if (tomeprecedent <> -1) then begin');
  Query.Script.Add
    ('      /* non pond�r�: sommeponderee = sommeponderee + (((CURRENTANNEE - ANNEEPRECEDENTE) * 12 + (COALESCE(CURRENTMOIS, 1) - COALESCE(MOISPRECEDENT, 1))) / (CURRENTTOME - TOMEPRECEDENT)); */');
  Query.Script.Add
    ('      sommeponderee = sommeponderee + (((CURRENTANNEE - ANNEEPRECEDENTE) * 12 + (COALESCE(CURRENTMOIS, 1) - COALESCE(MOISPRECEDENT, 1))) / (CURRENTTOME - TOMEPRECEDENT)) * CURRENTTOME;');
  Query.Script.Add('      /* non pond�r�: comptealbum = comptealbum + 1;*/');
  Query.Script.Add('      comptealbum = comptealbum + CURRENTTOME;');
  Query.Script.Add('    end');
  Query.Script.Add('    tomeprecedent = CURRENTTOME;');
  Query.Script.Add('    anneeprecedente = CURRENTANNEE;');
  Query.Script.Add('    moisprecedent = CURRENTMOIS;');
  Query.Script.Add('  end');
  Query.Script.Add('');
  Query.Script.Add('  if (oldrefserie <> -1 and comptealbum > 0) then begin');
  Query.Script.Add('    select REFSERIE, TITRESERIE, UPPERTITRESERIE,');
  Query.Script.Add('           TOME, ANNEEPARUTION, MOISPARUTION,');
  Query.Script.Add('           REFEDITEUR, NOMEDITEUR,');
  Query.Script.Add('           REFCOLLECTION, NOMCOLLECTION');
  Query.Script.Add('    from CALCUL_ANNEE_SORTIE(:withachat, :oldrefserie, :sommeponderee, :comptealbum, :tomeprecedent, :anneeprecedente, :moisprecedent)');
  Query.Script.Add('    into :REFSERIE, :TITRESERIE, :UPPERTITRESERIE,');
  Query.Script.Add('         :TOME, :ANNEEPARUTION, :MOISPARUTION,');
  Query.Script.Add('         :REFEDITEUR, :NOMEDITEUR,');
  Query.Script.Add('         :REFCOLLECTION, :NOMCOLLECTION;');
  Query.Script.Add('    suspend;');
  Query.Script.Add('  end');
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
  Query.Script.Add('    MOISPARUTION,');
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
  Query.Script.Add('       a.MOISPARUTION,');
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
  Query.Script.Add('    MOISPARUTION,');
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
  Query.Script.Add('       a.MOISPARUTION,');
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

  Query.Script.Add('CREATE VIEW VW_LISTE_EDITEURS_ALBUMS(');
  Query.Script.Add('    REFALBUM,');
  Query.Script.Add('    TITREALBUM,');
  Query.Script.Add('    TOME,');
  Query.Script.Add('    TOMEDEBUT,');
  Query.Script.Add('    TOMEFIN,');
  Query.Script.Add('    HORSSERIE,');
  Query.Script.Add('    INTEGRALE,');
  Query.Script.Add('    MOISPARUTION,');
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
  Query.Script.Add('       a.MOISPARUTION,');
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

  Query.Script.Add('CREATE VIEW VW_LISTE_GENRES_ALBUMS(');
  Query.Script.Add('    REFALBUM,');
  Query.Script.Add('    TITREALBUM,');
  Query.Script.Add('    TOME,');
  Query.Script.Add('    TOMEDEBUT,');
  Query.Script.Add('    TOMEFIN,');
  Query.Script.Add('    HORSSERIE,');
  Query.Script.Add('    INTEGRALE,');
  Query.Script.Add('    MOISPARUTION,');
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
  Query.Script.Add('       a.MOISPARUTION,');
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
  Query.Script.Add('    MOISPARUTION SMALLINT,');
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
  Query.Script.Add('             MOISPARUTION,');
  Query.Script.Add('             ANNEEPARUTION,');
  Query.Script.Add('             REFSERIE,');
  Query.Script.Add('             TITRESERIE,');
  Query.Script.Add('             ACHAT,');
  Query.Script.Add('             COMPLET');
  Query.Script.Add('        FROM vw_liste_albums');
  Query.Script.Add('        WHERE '' || :sWHERE ||');
  Query.Script.Add
    ('        ''ORDER BY UPPERTITREALBUM, UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST''');
  Query.Script.Add('        INTO :REFALBUM,');
  Query.Script.Add('             :TITREALBUM,');
  Query.Script.Add('             :TOME,');
  Query.Script.Add('             :TOMEDEBUT,');
  Query.Script.Add('             :TOMEFIN,');
  Query.Script.Add('             :HORSSERIE,');
  Query.Script.Add('             :INTEGRALE,');
  Query.Script.Add('             :MOISPARUTION,');
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

  Query.Script.Add('ALTER procedure ALBUMS_BY_AUTEUR (');
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
  Query.Script.Add('    MOISPARUTION SMALLINT,');
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
  Query.Script.Add('             A.MOISPARUTION,');
  Query.Script.Add('             A.ANNEEPARUTION,');
  Query.Script.Add('             A.REFSERIE,');
  Query.Script.Add('             A.TITRESERIE,');
  Query.Script.Add('             AU.metier,');
  Query.Script.Add('             A.ACHAT,');
  Query.Script.Add('             A.COMPLET');
  Query.Script.Add('      FROM vw_liste_albums A INNER JOIN auteurs au on a.refalbum = au.refalbum');
  Query.Script.Add('      WHERE au.refpersonne = '''''' || :RefAuteur || '''''' '' || swhere ||');
  Query.Script.Add
    ('      ''ORDER BY UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST, UPPERTITREALBUM, METIER''');
  Query.Script.Add('      INTO :REFALBUM,');
  Query.Script.Add('           :TITREALBUM,');
  Query.Script.Add('           :TOME,');
  Query.Script.Add('           :TOMEDEBUT,');
  Query.Script.Add('           :TOMEFIN,');
  Query.Script.Add('           :HORSSERIE,');
  Query.Script.Add('           :INTEGRALE,');
  Query.Script.Add('           :MOISPARUTION,');
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
  Query.Script.Add('end;');

  Query.Script.Add('ALTER procedure ALBUMS_BY_COLLECTION (');
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
  Query.Script.Add('    MOISPARUTION SMALLINT,');
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
  Query.Script.Add('             a.MOISPARUTION,');
  Query.Script.Add('             a.ANNEEPARUTION,');
  Query.Script.Add('             a.REFSERIE,');
  Query.Script.Add('             s.TITRESERIE,');
  Query.Script.Add('             a.ACHAT,');
  Query.Script.Add('             a.COMPLET');
  Query.Script.Add('      from albums a left join editions e on a.refalbum = e.refalbum');
  Query.Script.Add('                    left join series s on a.refserie = s.refserie');
  Query.Script.Add('      WHERE '' || :sWHERE ||');
  Query.Script.Add
    ('     ''ORDER BY UPPERTITREALBUM, UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST''');
  Query.Script.Add('      INTO :REFALBUM,');
  Query.Script.Add('           :TITREALBUM,');
  Query.Script.Add('           :TOME,');
  Query.Script.Add('           :TOMEDEBUT,');
  Query.Script.Add('           :TOMEFIN,');
  Query.Script.Add('           :HORSSERIE,');
  Query.Script.Add('           :INTEGRALE,');
  Query.Script.Add('           :MOISPARUTION,');
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

  Query.Script.Add('ALTER procedure ALBUMS_BY_EDITEUR (');
  Query.Script.Add('    REFEDITEUR INTEGER,');
  Query.Script.Add('    FILTRE VARCHAR(125))');
  Query.Script.Add('RETURNS (');
  Query.Script.Add('    REFALBUM INTEGER,');
  Query.Script.Add('    TITREALBUM VARCHAR(150),');
  Query.Script.Add('    TOME SMALLINT,');
  Query.Script.Add('    TOMEDEBUT SMALLINT,');
  Query.Script.Add('    TOMEFIN SMALLINT,');
  Query.Script.Add('    HORSSERIE SMALLINT,');
  Query.Script.Add('    INTEGRALE SMALLINT,');
  Query.Script.Add('    MOISPARUTION SMALLINT,');
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
  Query.Script.Add('             a.MOISPARUTION,');
  Query.Script.Add('             a.ANNEEPARUTION,');
  Query.Script.Add('             a.REFSERIE,');
  Query.Script.Add('             s.TITRESERIE,');
  Query.Script.Add('             a.ACHAT,');
  Query.Script.Add('             a.COMPLET');
  Query.Script.Add('      from albums a LEFT join editions e on a.refalbum = e.refalbum');
  Query.Script.Add('                    LEFT join series s on a.refserie = s.refserie');
  Query.Script.Add('      WHERE coalesce(e.refediteur, -1) = '''''' || :refediteur || '''''' '' || swhere ||');
  Query.Script.Add
    ('      ''ORDER BY UPPERTITREALBUM, UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST''');
  Query.Script.Add('      INTO :REFALBUM,');
  Query.Script.Add('           :TITREALBUM,');
  Query.Script.Add('           :TOME,');
  Query.Script.Add('           :TOMEDEBUT,');
  Query.Script.Add('           :TOMEFIN,');
  Query.Script.Add('           :HORSSERIE,');
  Query.Script.Add('           :INTEGRALE,');
  Query.Script.Add('           :MOISPARUTION,');
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
  Query.Script.Add('    MOISPARUTION SMALLINT,');
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
  Query.Script.Add('             MOISPARUTION,');
  Query.Script.Add('             ANNEEPARUTION,');
  Query.Script.Add('             a.REFSERIE,');
  Query.Script.Add('             TITRESERIE,');
  Query.Script.Add('             ACHAT,');
  Query.Script.Add('             COMPLET');
  Query.Script.Add('       FROM VW_LISTE_ALBUMS a LEFT JOIN GENRESERIES gs ON gs.refserie = a.refserie');
  Query.Script.Add('                              LEFT JOIN GENRES g ON gs.refgenre = g.refgenre');
  Query.Script.Add('       WHERE '' || :sWHERE ||');
  Query.Script.Add
    ('      ''ORDER BY UPPERTITREALBUM, UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST''');
  Query.Script.Add('       INTO :REFALBUM,');
  Query.Script.Add('            :TITREALBUM,');
  Query.Script.Add('            :TOME,');
  Query.Script.Add('            :TOMEDEBUT,');
  Query.Script.Add('            :TOMEFIN,');
  Query.Script.Add('            :HORSSERIE,');
  Query.Script.Add('            :INTEGRALE,');
  Query.Script.Add('            :MOISPARUTION,');
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
  Query.Script.Add('    MOISPARUTION SMALLINT,');
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
  Query.Script.Add('             a.MOISPARUTION,');
  Query.Script.Add('             a.ANNEEPARUTION,');
  Query.Script.Add('             a.REFSERIE,');
  Query.Script.Add('             s.TITRESERIE,');
  Query.Script.Add('             a.ACHAT,');
  Query.Script.Add('             a.COMPLET');
  Query.Script.Add('      FROM ALBUMS a INNER JOIN SERIES s ON s.refserie = a.refserie');
  Query.Script.Add('      WHERE a.initialetitrealbum = '''''' || :INITIALE || '''''' '' || swhere ||');
  Query.Script.Add
    ('      ''ORDER BY UPPERTITREALBUM, UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST''');
  Query.Script.Add('      INTO :REFALBUM,');
  Query.Script.Add('           :TITREALBUM,');
  Query.Script.Add('           :TOME,');
  Query.Script.Add('           :TOMEDEBUT,');
  Query.Script.Add('           :TOMEFIN,');
  Query.Script.Add('           :HORSSERIE,');
  Query.Script.Add('           :INTEGRALE,');
  Query.Script.Add('           :MOISPARUTION,');
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
  Query.Script.Add('    MOISPARUTION SMALLINT,');
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
  Query.Script.Add('             MOISPARUTION,');
  Query.Script.Add('             ANNEEPARUTION,');
  Query.Script.Add('             REFSERIE,');
  Query.Script.Add('             TITRESERIE,');
  Query.Script.Add('             ACHAT,');
  Query.Script.Add('             COMPLET');
  Query.Script.Add('      FROM vw_liste_albums');
  Query.Script.Add('      WHERE refserie = '''''' || :serie || '''''' '' || swhere ||');
  Query.Script.Add
    ('      ''ORDER BY HORSSERIE NULLS FIRST, INTEGRALE NULLS First, TOME NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST, UPPERTITREALBUM''');
  Query.Script.Add('      INTO :REFALBUM,');
  Query.Script.Add('           :TITREALBUM,');
  Query.Script.Add('           :TOME,');
  Query.Script.Add('           :TOMEDEBUT,');
  Query.Script.Add('           :TOMEFIN,');
  Query.Script.Add('           :HORSSERIE,');
  Query.Script.Add('           :INTEGRALE,');
  Query.Script.Add('           :MOISPARUTION,');
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

RegisterFBUpdate('0.0.3.27', @MAJ0_0_3_27);

end.
