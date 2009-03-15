DROP VIEW VW_EMPRUNTS;
CREATE VIEW VW_EMPRUNTS(
    ID_STATUT,
    ID_EDITION,
    ID_ALBUM,
    TITREALBUM,
    UPPERTITREALBUM,
    ID_SERIE,
    TOME,
    INTEGRALE,
    TOMEDEBUT,
    TOMEFIN,
    HORSSERIE,
    TITRESERIE,
    ID_EDITEUR,
    NOMEDITEUR,
    ID_COLLECTION,
    NOMCOLLECTION,
    PRETE,
    ANNEEEDITION,
    ISBN,
    ID_EMPRUNTEUR,
    NOMEMPRUNTEUR,
    PRETEMPRUNT,
    DATEEMPRUNT)
AS
SELECT S.id_statut,
       Ed.ID_EDITION,
       A.ID_ALBUM,
       A.titrealbum,
       A.uppertitrealbum,
       A.id_serie,
       A.Tome,
       A.Integrale,
       A.TomeDebut,
       A.TomeFin,
       A.HorsSerie,
       Se.titreserie,
       E.ID_EDITEUR,
       E.NomEditeur,
       C.ID_COLLECTION,
       C.NomCollection,
       Ed.prete,
       Ed.AnneeEdition,
       Ed.ISBN,
       Em.ID_EMPRUNTEUR,
       Em.NomEmprunteur,
       S.PretEmprunt,
       S.DateEmprunt
FROM ALBUMS A INNER JOIN EDITIONS Ed ON A.ID_ALBUM = Ed.id_album
              INNER JOIN EDITEURS e ON e.ID_EDITEUR = ed.id_editeur
              LEFT JOIN COLLECTIONS C ON C.ID_COLLECTION = ed.id_collection
              INNER JOIN STATUT S ON Ed.ID_EDITION = S.id_edition
              INNER JOIN EMPRUNTEURS Em ON Em.ID_EMPRUNTEUR = S.id_emprunteur
              INNER JOIN SERIES Se ON A.id_serie = Se.ID_SERIE;

DROP VIEW VW_LISTE_GENRES_ALBUMS;
DROP VIEW VW_LISTE_EDITEURS_ALBUMS;
DROP VIEW VW_LISTE_COLLECTIONS_ALBUMS;
DROP VIEW VW_LISTE_ALBUMS;

CREATE VIEW VW_LISTE_ALBUMS(
    ID_ALBUM,
    TITREALBUM,
    TOME,
    TOMEDEBUT,
    TOMEFIN,
    HORSSERIE,
    INTEGRALE,
    MOISPARUTION,
    ANNEEPARUTION,
    ID_SERIE,
    TITRESERIE,
    UPPERTITREALBUM,
    UPPERTITRESERIE,
    ACHAT,
    COMPLET)
AS
select a.ID_ALBUM,
       a.TITREALBUM,
       a.TOME,
       a.TOMEDEBUT,
       a.TOMEFIN,
       a.HORSSERIE,
       a.INTEGRALE,
       a.MOISPARUTION,
       a.ANNEEPARUTION,
       a.ID_SERIE,
       s.TITRESERIE,
       a.UPPERTITREALBUM,
       s.UPPERTITRESERIE,
       a.ACHAT,
       a.COMPLET
FROM ALBUMS a INNER JOIN SERIES s ON s.ID_SERIE = a.id_serie;

CREATE VIEW VW_LISTE_COLLECTIONS_ALBUMS(
    ID_ALBUM,
    TITREALBUM,
    TOME,
    TOMEDEBUT,
    TOMEFIN,
    HORSSERIE,
    INTEGRALE,
    MOISPARUTION,
    ANNEEPARUTION,
    ID_SERIE,
    TITRESERIE,
    UPPERTITREALBUM,
    ID_COLLECTION,
    NOMCOLLECTION,
    UPPERNOMCOLLECTION,
    UPPERTITRESERIE,
    ACHAT,
    COMPLET)
AS
select a.ID_ALBUM,
       a.TITREALBUM,
       a.TOME,
       a.TOMEDEBUT,
       a.TOMEFIN,
       a.HORSSERIE,
       a.INTEGRALE,
       a.MOISPARUTION,
       a.ANNEEPARUTION,
       a.ID_SERIE,
       a.TITRESERIE,
       a.UPPERTITREALBUM,
       c.ID_COLLECTION,
       c.NOMCOLLECTION,
       c.UPPERNOMCOLLECTION,
       a.UPPERTITRESERIE,
       a.ACHAT,
       a.COMPLET
FROM VW_LISTE_ALBUMS a LEFT JOIN EDITIONS e ON e.id_album = a.id_album
                       LEFT JOIN COLLECTIONS c ON e.id_collection = c.ID_COLLECTION;

CREATE VIEW VW_LISTE_EDITEURS_ALBUMS(
    ID_ALBUM,
    TITREALBUM,
    TOME,
    TOMEDEBUT,
    TOMEFIN,
    HORSSERIE,
    INTEGRALE,
    MOISPARUTION,
    ANNEEPARUTION,
    ID_SERIE,
    TITRESERIE,
    UPPERTITREALBUM,
    ID_EDITEUR,
    NOMEDITEUR,
    UPPERNOMEDITEUR,
    UPPERTITRESERIE,
    ACHAT,
    COMPLET)
AS
select a.ID_ALBUM,
       a.TITREALBUM,
       a.TOME,
       a.TOMEDEBUT,
       a.TOMEFIN,
       a.HORSSERIE,
       a.INTEGRALE,
       a.MOISPARUTION,
       a.ANNEEPARUTION,
       a.ID_SERIE,
       a.TITRESERIE,
       a.UPPERTITREALBUM,
       e.ID_EDITEUR,
       e.NOMEDITEUR,
       e.UPPERNOMEDITEUR,
       a.UPPERTITRESERIE,
       a.ACHAT,
       a.COMPLET
FROM VW_LISTE_ALBUMS a LEFT JOIN EDITIONS ed ON ed.id_album = a.id_album
                       LEFT JOIN EDITEURS e ON e.ID_EDITEUR = ed.id_editeur;

CREATE VIEW VW_LISTE_GENRES_ALBUMS(
    ID_ALBUM,
    TITREALBUM,
    TOME,
    TOMEDEBUT,
    TOMEFIN,
    HORSSERIE,
    INTEGRALE,
    MOISPARUTION,
    ANNEEPARUTION,
    ID_SERIE,
    TITRESERIE,
    UPPERTITREALBUM,
    ID_GENRE,
    GENRE,
    UPPERGENRE,
    UPPERTITRESERIE,
    ACHAT,
    COMPLET)
AS
select a.ID_ALBUM,
       a.TITREALBUM,
       a.TOME,
       a.TOMEDEBUT,
       a.TOMEFIN,
       a.HORSSERIE,
       a.INTEGRALE,
       a.MOISPARUTION,
       a.ANNEEPARUTION,
       a.ID_SERIE,
       a.TITRESERIE,
       a.UPPERTITREALBUM,
       g.ID_GENRE,
       g.GENRE,
       g.UPPERGENRE,
       a.UPPERTITRESERIE,
       a.ACHAT,
       a.COMPLET
FROM VW_LISTE_ALBUMS a LEFT JOIN GENRESERIES gs ON gs.id_serie = a.id_serie
                       LEFT JOIN GENRES g ON gs.id_genre = g.ID_GENRE;

DROP VIEW VW_PRIXUNITAIRES;
DROP VIEW VW_PRIXALBUMS;

CREATE VIEW VW_PRIXALBUMS(
    ID_ALBUM,
    HORSSERIE,
    TOME,
    INTEGRALE,
    TOMEDEBUT,
    TOMEFIN,
    NBALBUMS,
    ID_SERIE,
    ID_EDITION,
    ID_EDITEUR,
    PRIX)
AS
select
  a.ID_ALBUM,
  a.horsserie,
  a.tome,
  a.integrale,
  a.tomedebut,
  a.tomefin,
  case
    when a.integrale = 0 then 1
    when a.tomedebut is null
    then 1 when a.tomefin is null
    then 1 when a.tomefin < a.tomedebut then 1
    else a.tomefin - a.tomedebut + 1
  end as nbalbums,
  a.id_serie,
  e.ID_EDITION,
  e.id_editeur,
  e.prix
from albums a
  inner join editions e on a.ID_ALBUM = e.id_album;

CREATE VIEW VW_PRIXUNITAIRES(
    HORSSERIE,
    ID_SERIE,
    ID_EDITEUR,
    PRIXUNITAIRE)
AS
select
  horsserie,
  id_serie,
  id_editeur,
  avg(prix / nbalbums) as prixunitaire
from vw_prixalbums
where
  prix is not null
group by
  id_serie,
  horsserie,
  id_editeur;

ALTER PROCEDURE PROC_EMPRUNTS
RETURNS (
    ID_EDITION CHAR(38) CHARACTER SET NONE,
    ID_ALBUM CHAR(38) CHARACTER SET NONE,
    TITREALBUM VARCHAR(150),
    ID_SERIE CHAR(38) CHARACTER SET NONE,
    TITRESERIE VARCHAR(150),
    PRETE SMALLINT,
    ID_EMPRUNTEUR CHAR(38) CHARACTER SET NONE,
    NOMEMPRUNTEUR VARCHAR(150),
    PRETEMPRUNT SMALLINT,
    DATEEMPRUNT TIMESTAMP)
AS
BEGIN
  FOR SELECT Ed.ID_EDITION,
             A.ID_ALBUM,
             A.titrealbum,
             A.id_serie,
             Se.titreserie,
             Ed.prete,
             E.ID_EMPRUNTEUR,
             E.NomEmprunteur,
             S.PretEmprunt,
             S.DateEmprunt
      FROM ALBUMS A INNER JOIN EDITIONS Ed ON A.ID_ALBUM = Ed.id_album
                    INNER JOIN STATUT S ON Ed.ID_EDITION = S.id_edition
                    INNER JOIN EMPRUNTEURS E ON E.ID_EMPRUNTEUR = S.id_emprunteur
                    INNER JOIN SERIES Se ON A.id_serie = Se.ID_SERIE
      ORDER BY S.DateEmprunt DESC
      INTO :ID_EDITION,
           :ID_ALBUM,
           :TITREALBUM,
           :ID_SERIE,
           :TITRESERIE,
           :PRETE,
           :ID_Emprunteur,
           :NomEmprunteur,
           :PretEmprunt,
           :DateEmprunt
  DO
  BEGIN
    SUSPEND;
  END
END;

ALTER PROCEDURE PREVISIONS_SORTIES (
    WITHACHAT SMALLINT,
    IN_ID_SERIE CHAR(38) CHARACTER SET NONE)
RETURNS (
    ID_SERIE CHAR(38) CHARACTER SET NONE,
    TITRESERIE VARCHAR(150),
    UPPERTITRESERIE VARCHAR(150),
    TOME INTEGER,
    ANNEEPARUTION INTEGER,
    MOISPARUTION INTEGER,
    ID_EDITEUR CHAR(38) CHARACTER SET NONE,
    NOMEDITEUR VARCHAR(50),
    ID_COLLECTION CHAR(38) CHARACTER SET NONE,
    NOMCOLLECTION VARCHAR(50))
AS
begin
  --
end;

ALTER PROCEDURE CALCUL_ANNEE_SORTIE (
    WITHACHAT SMALLINT,
    IN_IDSERIE CHAR(38) CHARACTER SET NONE,
    SOMMEPONDEREE INTEGER,
    COMPTEALBUM INTEGER,
    MAXTOME INTEGER,
    MAXANNEE INTEGER,
    MAXMOIS INTEGER)
RETURNS (
    ID_SERIE CHAR(38) CHARACTER SET NONE,
    TITRESERIE VARCHAR(150),
    UPPERTITRESERIE VARCHAR(150),
    TOME INTEGER,
    ANNEEPARUTION INTEGER,
    MOISPARUTION INTEGER,
    ID_EDITEUR CHAR(38) CHARACTER SET NONE,
    NOMEDITEUR VARCHAR(50),
    ID_COLLECTION CHAR(38) CHARACTER SET NONE,
    NOMCOLLECTION VARCHAR(50))
AS
DECLARE VARIABLE MAXTOME2 INTEGER;
begin
  tome = maxtome + 1;

  select max(tomefin) + 1 from albums
  where horsserie = 0 and integrale = 1 and id_serie = :in_idserie and (:withachat = 1 or achat = 0)
  into
    :MAXTOME2;

  if (maxtome2 > tome) then tome = maxtome2;

  select s.ID_SERIE, s.TitreSerie, s.UpperTitreSerie, e.ID_EDITEUR, e.NomEditeur, c.ID_COLLECTION, c.NomCollection from
    series s left join editeurs e on e.ID_EDITEUR = s.id_editeur
             left join collections c on c.ID_COLLECTION = s.id_collection
  where s.ID_SERIE = :in_idserie
  into
    :ID_SERIE,
    :TITRESERIE,
    :UPPERTITRESERIE,
    :ID_EDITEUR,
    :NOMEDITEUR,
    :ID_COLLECTION,
    :NOMCOLLECTION;

  if (maxmois is null) then begin
    ANNEEPARUTION = maxannee + ((tome - maxtome) * ((sommeponderee / 12) / comptealbum));
    MOISPARUTION = null;
  end else begin
    MOISPARUTION = maxmois + ((tome - maxtome) * (sommeponderee / comptealbum));
    ANNEEPARUTION = maxannee;
    while (MOISPARUTION > 12) do begin
      MOISPARUTION = MOISPARUTION - 12;
      ANNEEPARUTION = ANNEEPARUTION + 1;
    end
  end
  suspend;
end;

ALTER PROCEDURE PREVISIONS_SORTIES (
    WITHACHAT SMALLINT,
    IN_ID_SERIE CHAR(38) CHARACTER SET NONE)
RETURNS (
    ID_SERIE CHAR(38) CHARACTER SET NONE,
    TITRESERIE VARCHAR(150),
    UPPERTITRESERIE VARCHAR(150),
    TOME INTEGER,
    ANNEEPARUTION INTEGER,
    MOISPARUTION INTEGER,
    ID_EDITEUR CHAR(38) CHARACTER SET NONE,
    NOMEDITEUR VARCHAR(50),
    ID_COLLECTION CHAR(38) CHARACTER SET NONE,
    NOMCOLLECTION VARCHAR(50))
AS
DECLARE VARIABLE CURRENTIDSERIE CHAR(38) CHARACTER SET NONE;
DECLARE VARIABLE OLDIDSERIE CHAR(38) CHARACTER SET NONE;
DECLARE VARIABLE CURRENTTOME INTEGER;
DECLARE VARIABLE SOMMEPONDEREE INTEGER;
DECLARE VARIABLE COMPTEALBUM INTEGER;
DECLARE VARIABLE CURRENTANNEE INTEGER;
DECLARE VARIABLE CURRENTMOIS INTEGER;
DECLARE VARIABLE TOMEPRECEDENT INTEGER;
DECLARE VARIABLE ANNEEPRECEDENTE INTEGER;
DECLARE VARIABLE MOISPRECEDENT INTEGER;
DECLARE VARIABLE DIFFMOIS INTEGER;
begin
  if (withachat is Null) then withachat = 1;
  oldidserie = NULL;
  tomeprecedent = -1;
  anneeprecedente = -1;
  moisprecedent = null;
  for select TOME, ANNEEPARUTION, MOISPARUTION, s.ID_SERIE
      from albums a inner join series s on s.ID_SERIE = a.id_serie
      where (s.terminee is null or s.terminee <> 1)
            and a.horsserie = 0 and a.integrale = 0 and a.anneeparution is not null
            and (:in_id_serie is null or s.ID_SERIE = :in_id_serie)
            and (:withachat = 1 or achat = 0)
      order by s.ID_SERIE, TOME
      into :CURRENTTOME, :CURRENTANNEE, :CURRENTMOIS, :currentidserie
  do begin
    if (oldidserie is null or currentidserie <> oldidserie) then begin

      if (oldidserie IS NOT NULL and comptealbum > 0) then begin
        select ID_SERIE, TITRESERIE, UPPERTITRESERIE,
               TOME, ANNEEPARUTION, MOISPARUTION,
               ID_EDITEUR, NOMEDITEUR,
               ID_COLLECTION, NOMCOLLECTION
        from CALCUL_ANNEE_SORTIE(:withachat, :oldidserie, :sommeponderee, :comptealbum, :tomeprecedent, :anneeprecedente, :moisprecedent)
        into :ID_SERIE, :TITRESERIE, :UPPERTITRESERIE,
             :TOME, :ANNEEPARUTION, :MOISPARUTION,
             :ID_EDITEUR, :NOMEDITEUR,
             :ID_COLLECTION, :NOMCOLLECTION;
        suspend;
      end

      oldidserie = currentidserie;
      sommeponderee = 0;
      comptealbum = 0;
      tomeprecedent = -1;
      anneeprecedente = -1;
      moisprecedent = -1;
    end
    if (tomeprecedent <> -1 and CURRENTTOME - TOMEPRECEDENT <> 0) then begin
      if (CURRENTMOIS is null or MOISPRECEDENT is null) then
        diffmois = 0;
      else
        diffmois = CURRENTMOIS - MOISPRECEDENT;
      /* non pondéré: sommeponderee = sommeponderee + (((CURRENTANNEE - ANNEEPRECEDENTE) * 12 + (COALESCE(CURRENTMOIS, 1) - COALESCE(MOISPRECEDENT, 1))) / (CURRENTTOME - TOMEPRECEDENT)); */
      sommeponderee = sommeponderee + (((CURRENTANNEE - ANNEEPRECEDENTE) * 12 + diffmois) / (CURRENTTOME - TOMEPRECEDENT)) * CURRENTTOME;
      /* non pondéré: comptealbum = comptealbum + 1;*/
      comptealbum = comptealbum + CURRENTTOME;
    end
    tomeprecedent = CURRENTTOME;
    anneeprecedente = CURRENTANNEE;
    moisprecedent = CURRENTMOIS;
  end

  if (oldidserie IS NOT NULL and comptealbum > 0) then begin
    select ID_SERIE, TITRESERIE, UPPERTITRESERIE,
           TOME, ANNEEPARUTION, MOISPARUTION,
           ID_EDITEUR, NOMEDITEUR,
           ID_COLLECTION, NOMCOLLECTION
    from CALCUL_ANNEE_SORTIE(:withachat, :oldidserie, :sommeponderee, :comptealbum, :tomeprecedent, :anneeprecedente, :moisprecedent)
    into :ID_SERIE, :TITRESERIE, :UPPERTITRESERIE,
         :TOME, :ANNEEPARUTION, :MOISPARUTION,
         :ID_EDITEUR, :NOMEDITEUR,
         :ID_COLLECTION, :NOMCOLLECTION;
    suspend;
  end
end;

ALTER PROCEDURE LISTE_TOMES (
    WITHINTEGRALE SMALLINT,
    IN_IDSERIE CHAR(38) CHARACTER SET NONE)
RETURNS (
    ID_SERIE CHAR(38) CHARACTER SET NONE,
    TOME SMALLINT,
    INTEGRALE SMALLINT,
    ACHAT SMALLINT)
AS
DECLARE VARIABLE TOMEDEBUT INTEGER;
DECLARE VARIABLE TOMEFIN INTEGER;
begin
  for
    select id_serie, tome, integrale, achat
    from albums
    where TOME is not null and integrale = 0 and horsserie = 0
          and (:in_idserie is null or id_serie = :in_idserie)
    order by id_serie, tome
    into :id_serie, :TOME, :INTEGRALE, :ACHAT
    do
      suspend;

  if (withintegrale is null) then withintegrale = 1;
  if (withintegrale = 1) then
    for
      select id_serie, tomedebut, tomefin, integrale, achat
      from albums
      where TOMEDEBUT is not null and TOMEFIN is not null and integrale = 1 and horsserie = 0
            and (:in_idserie is null or id_serie = :in_idserie)
      order by id_serie, tomedebut, tomefin
      into :ID_SERIE, :TOMEDEBUT, :TOMEFIN, :INTEGRALE, :ACHAT
      do begin
        TOME = TOMEDEBUT - 1;
        while (TOME <> TOMEFIN) do begin
          TOME = TOME + 1;
          suspend;
        end
      end
end;

ALTER PROCEDURE PROC_AUTEURS (
    ALBUM CHAR(38) CHARACTER SET NONE,
    SERIE CHAR(38) CHARACTER SET NONE,
    PARABD CHAR(38) CHARACTER SET NONE)
RETURNS (
    ID_PERSONNE CHAR(38) CHARACTER SET NONE,
    NOMPERSONNE VARCHAR(150),
    ID_ALBUM CHAR(38) CHARACTER SET NONE,
    ID_SERIE CHAR(38) CHARACTER SET NONE,
    ID_PARABD CHAR(38) CHARACTER SET NONE,
    METIER SMALLINT)
AS
begin
  if (Album is not null) then
    for select p.ID_PERSONNE,
               p.nompersonne,
               a.id_album,
               NULL,
               NULL,
               a.metier
        from personnes p inner join auteurs a on a.id_personne = p.ID_PERSONNE
        where a.id_album = :ALBUM
        order by a.metier, p.uppernompersonne
        into :ID_PERSONNE,
             :NOMPERSONNE,
             :ID_ALBUM,
             :ID_SERIE,
             :ID_PARABD,
             :METIER
    do
      suspend;

  if (Serie is not null) then
    for select p.ID_PERSONNE,
               p.nompersonne,
               NULL,
               a.id_serie,
               NULL,
               a.metier
        from personnes p inner join auteurs_series a on a.id_personne = p.ID_PERSONNE
        where a.id_serie = :SERIE
        order by a.metier, p.uppernompersonne
        into :ID_PERSONNE,
             :NOMPERSONNE,
             :ID_ALBUM,
             :ID_SERIE,
             :ID_PARABD,
             :METIER
    do
      suspend;

  if (ParaBD is not null) then
    for select p.ID_PERSONNE,
               p.nompersonne,
               NULL,
               NULL,
               a.id_parabd,
               NULL
        from personnes p inner join auteurs_parabd a on a.id_personne = p.ID_PERSONNE
        where a.id_parabd = :PARABD
        order by p.uppernompersonne
        into :ID_PERSONNE,
             :NOMPERSONNE,
             :ID_ALBUM,
             :ID_SERIE,
             :ID_PARABD,
             :METIER
    do
      suspend;
end;

ALTER PROCEDURE ALBUMS_MANQUANTS (
    WITHINTEGRALE SMALLINT,
    WITHACHAT SMALLINT,
    IN_IDSERIE CHAR(38) CHARACTER SET NONE)
RETURNS (
    ID_SERIE CHAR(38) CHARACTER SET NONE,
    COUNTSERIE INTEGER,
    TITRESERIE VARCHAR(150),
    UPPERTITRESERIE VARCHAR(150),
    TOME INTEGER,
    ID_EDITEUR CHAR(38) CHARACTER SET NONE,
    NOMEDITEUR VARCHAR(50),
    ID_COLLECTION CHAR(38) CHARACTER SET NONE,
    NOMCOLLECTION VARCHAR(50))
AS
DECLARE VARIABLE MAXSERIE INTEGER;
DECLARE VARIABLE CURRENTTOME INTEGER;
DECLARE VARIABLE OWNEDTOME INTEGER;
DECLARE VARIABLE ACHAT SMALLINT;
DECLARE VARIABLE SUMACHAT INTEGER;
begin
  if (WITHINTEGRALE is null) then WITHINTEGRALE = 1;
  if (WITHACHAT is null) then WITHACHAT = 1;
  for select
        A.id_serie,
        max(TOME),
        count(distinct TOME),
        sum(ACHAT),
        S.id_editeur,
        NOMEDITEUR,
        S.id_collection,
        NOMCOLLECTION
      from liste_tomes(:WITHINTEGRALE, :in_idserie) A
         inner join SERIES S on A.ID_SERIE = S.ID_SERIE
         left join EDITEURS E on S.ID_EDITEUR = E.ID_EDITEUR
         left join COLLECTIONS C on S.id_collection = C.ID_COLLECTION
      where S.COMPLETE = 0
      group by A.id_serie, UPPERTITRESERIE, UPPERNOMEDITEUR, UPPERNOMCOLLECTION,
               S.id_editeur, NOMEDITEUR, S.id_collection, NOMCOLLECTION
      order by UPPERTITRESERIE, UPPERNOMEDITEUR, UPPERNOMCOLLECTION
      into
        :ID_SERIE,
        :MAXSERIE,
        :COUNTSERIE,
        :SUMACHAT,
        :ID_EDITEUR,
        :NOMEDITEUR,
        :ID_COLLECTION,
        :NOMCOLLECTION
  do begin
    if (WITHACHAT = 0) then
      COUNTSERIE = COUNTSERIE - SUMACHAT;
    if (COUNTSERIE <> MAXSERIE) then begin
      CURRENTTOME = 0;
      for select distinct
            UPPERTITRESERIE,
            TITRESERIE,
            TOME,
            ACHAT
          from liste_tomes(:WITHINTEGRALE, :ID_SERIE) A inner join SERIES S on A.ID_SERIE = S.ID_SERIE
          order by TOME
          into
            :UPPERTITRESERIE,
            :TITRESERIE,
            :OWNEDTOME,
            :ACHAT
      do begin
        CURRENTTOME = CURRENTTOME + 1;
        while ((CURRENTTOME <> OWNEDTOME) and (CURRENTTOME < MAXSERIE)) do begin
          TOME = CURRENTTOME;
          suspend;
          CURRENTTOME = CURRENTTOME + 1;
        end
        if ((WITHACHAT = 0) AND (ACHAT = 1)) then begin
          TOME = OWNEDTOME;
          suspend;
        end
      end
    end
  end
end;

ALTER PROCEDURE SERIES_BY_INITIALE (
    INITIALE CHAR(1))
RETURNS (
    ID_SERIE CHAR(38) CHARACTER SET NONE,
    TITRESERIE VARCHAR(150),
    ID_EDITEUR CHAR(38) CHARACTER SET NONE,
    NOMEDITEUR VARCHAR(50),
    ID_COLLECTION CHAR(38) CHARACTER SET NONE,
    NOMCOLLECTION VARCHAR(50))
AS
begin
  FOR SELECT ID_SERIE,
             TITRESERIE,
             S.ID_EDITEUR,
             NOMEDITEUR,
             S.ID_COLLECTION,
             NOMCOLLECTION
      FROM SERIES S LEFT JOIN EDITEURS E ON S.id_editeur = E.ID_EDITEUR
                    LEFT JOIN COLLECTIONS C ON S.id_collection = C.ID_COLLECTION
      WHERE INITIALETITRESERIE = :INITIALE
      ORDER BY UPPERTITRESERIE, UPPERNOMEDITEUR, UPPERNOMCOLLECTION
      INTO :ID_SERIE,
           :TITRESERIE,
           :ID_EDITEUR,
           :NOMEDITEUR,
           :ID_COLLECTION,
           :NOMCOLLECTION
  DO
  BEGIN
    SUSPEND;
  END
end;

ALTER TRIGGER COLLECTIONS_EDITIONS_REF
ACTIVE AFTER UPDATE OR DELETE POSITION 0
AS
begin
  if (deleting) then update EDITIONS set ID_Collection = NULL where ID_Collection = old.ID_COLLECTION;
  if (updating) then update EDITIONS set ID_Collection = new.ID_COLLECTION, ID_Editeur = new.id_editeur where ID_Collection = old.ID_COLLECTION;
end;

ALTER TRIGGER COLLECTIONS_SERIE_REF
ACTIVE AFTER UPDATE OR DELETE POSITION 0
AS
begin
  if (deleting) then update SERIES set ID_Collection = NULL where ID_Collection = old.ID_COLLECTION;
  if (updating) then update SERIES set ID_Collection = new.ID_COLLECTION, ID_Editeur = new.id_editeur where ID_Collection = old.ID_COLLECTION;
end;

ALTER TRIGGER EDITIONS_COTE_BIU1
ACTIVE AFTER INSERT OR UPDATE POSITION 1
AS
declare variable existPRIX INTEGER;
begin
  if (new.anneecote is not null and new.prixcote is not null) then begin
    select COUNT(PRIXCOTE) from COTES where ID_EDITION = new.ID_EDITION AND ANNEECOTE = new.anneecote INTO :existPRIX;
    if (existPRIX = 0) then
      INSERT INTO COTES (ID_EDITION, ANNEECOTE, PRIXCOTE) VALUES (new.ID_EDITION, new.anneecote, new.prixcote);
    else
      UPDATE COTES SET PRIXCOTE = new.prixcote WHERE ID_EDITION = new.ID_EDITION AND ANNEECOTE = new.anneecote;
  end
end;

ALTER TRIGGER PARABD_COTE_BIU1
ACTIVE AFTER INSERT OR UPDATE POSITION 1
AS
declare variable existPRIX INTEGER;
begin
  if (new.anneecote is not null and new.prixcote is not null) then begin
    select COUNT(PRIXCOTE) from COTES_PARABD where ID_PARABD = new.id_parabd AND ANNEECOTE = new.anneecote INTO :existPRIX;
    if (existPRIX = 0) then
      INSERT INTO COTES_PARABD (ID_PARABD, ANNEECOTE, PRIXCOTE) VALUES (new.id_parabd, new.anneecote, new.prixcote);
    else
      UPDATE COTES_PARABD SET PRIXCOTE = new.prixcote WHERE ID_PARABD = new.id_parabd AND ANNEECOTE = new.anneecote;
  end
end;

ALTER TRIGGER EDITIONS_AD0
ACTIVE AFTER DELETE POSITION 0
AS
begin
  delete from couvertures where ID_album is null and ID_edition = old.ID_EDITION;
  update couvertures set ID_edition = null where ID_edition = old.ID_EDITION;

  update albums set nbeditions = nbeditions - 1 where ID_ALBUM = old.id_album;
end;

ALTER TRIGGER EDITIONS_AU0
ACTIVE AFTER UPDATE POSITION 0
AS
begin
  if (new.ID_EDITION <> old.ID_EDITION) then begin
    update couvertures set ID_edition = new.ID_EDITION where ID_edition = old.ID_EDITION;
  end

  if (new.id_album <> old.id_album) then begin
    update albums set nbeditions = nbeditions - 1 where ID_ALBUM = old.id_album;
    update albums set nbeditions = nbeditions + 1 where ID_ALBUM = new.id_album;
  end
end;

DROP VIEW VW_INITIALES_EDITEURS;
CREATE VIEW VW_INITIALES_EDITEURS(
    INITIALENOMEDITEUR,
    COUNTINITIALE)
AS
select
    initialenomediteur,
    Count(ID_EDITEUR)
from EDITEURS
group by initialenomediteur;

ALTER PROCEDURE EDITEURS_BY_INITIALE (
    INITIALE CHAR(1))
RETURNS (
    ID_EDITEUR CHAR(38) CHARACTER SET NONE,
    NOMEDITEUR VARCHAR(50))
AS
begin
  FOR SELECT ID_EDITEUR,
             NOMEDITEUR
      FROM EDITEURS
      WHERE INITIALENOMEDITEUR = :INITIALE
      ORDER BY UPPERNOMEDITEUR
      INTO :ID_EDITEUR,
           :NOMEDITEUR
  DO
  BEGIN
    SUSPEND;
  END
end;

ALTER TRIGGER EDITEURS_SERIE_REF
ACTIVE AFTER UPDATE OR DELETE POSITION 0
AS
begin
  if (deleting) then update SERIES set ID_Editeur = NULL where ID_Editeur = old.ID_EDITEUR;
  if (updating) then update SERIES set ID_Editeur = new.ID_EDITEUR where ID_Editeur = old.ID_EDITEUR;
end;

ALTER TRIGGER EDITIONS_AI0
ACTIVE AFTER INSERT POSITION 0
AS
begin
  update albums set nbeditions = nbeditions + 1 where ID_ALBUM = new.id_album;
end;

ALTER TRIGGER LISTES_AUD0
ACTIVE AFTER UPDATE OR DELETE POSITION 0
AS
DECLARE VARIABLE newvalue INTEGER;
begin
  if (deleting) then newvalue = null;
                else newvalue = new.REF;

  if (old.categorie = 1) then update editions set etat = :newvalue where etat = old.ref;
  if (old.categorie = 2) then update editions set reliure = :newvalue where reliure = old.ref;
  if (old.categorie = 3) then update editions set typeedition = :newvalue where typeedition = old.ref;
  if (old.categorie = 4) then update editions set orientation = :newvalue where orientation = old.ref;
  if (old.categorie = 5) then update editions set FORMATEDITION = :newvalue where FORMATEDITION = old.ref;
  if (old.categorie = 6) then update couvertures set CATEGORIEIMAGE = :newvalue where CATEGORIEIMAGE = old.ref;
  if (old.categorie = 7) then update parabd set categorieparabd = :newvalue where categorieparabd = old.ref;
end;

ALTER PROCEDURE PROC_AJOUTMVT (
    ID_EDITION CHAR(38) CHARACTER SET NONE,
    ID_EMPRUNTEUR CHAR(38) CHARACTER SET NONE,
    DATEEMPRUNT TIMESTAMP,
    PRET SMALLINT)
AS
begin
  insert into STATUT ( DateEmprunt,  ID_Emprunteur,  ID_Edition,  PretEmprunt)
              values (:DateEmprunt, :ID_Emprunteur, :ID_Edition, :Pret);
  update EDITIONS set Prete = :Pret where ID_EDITION = :ID_Edition;
end;

DROP VIEW VW_INITIALES_EMPRUNTEURS;
CREATE VIEW VW_INITIALES_EMPRUNTEURS(
    INITIALENOMEMPRUNTEUR,
    COUNTINITIALE)
AS
select
    initialenomemprunteur,
    Count(ID_EMPRUNTEUR)
from EMPRUNTEURS
group by initialenomemprunteur;

ALTER PROCEDURE EMPRUNTEURS_BY_INITIALE (
    INITIALE CHAR(1))
RETURNS (
    ID_EMPRUNTEUR CHAR(38) CHARACTER SET NONE,
    NOMEMPRUNTEUR VARCHAR(150))
AS
BEGIN
  FOR SELECT ID_EMPRUNTEUR,
             NOMEMPRUNTEUR
      FROM EMPRUNTEURS
      WHERE INITIALENOMEMPRUNTEUR = :INITIALE
      ORDER BY UPPERNOMEMPRUNTEUR
      INTO :ID_EMPRUNTEUR,
           :NOMEMPRUNTEUR
  DO
  BEGIN
    SUSPEND;
  END
END;

DROP VIEW VW_INITIALES_GENRES;
CREATE VIEW VW_INITIALES_GENRES(
    INITIALEGENRE,
    COUNTINITIALE)
AS
select
    initialeGENRE,
    Count(ID_GENRE)
from GENRES
group by initialeGENRE;

ALTER PROCEDURE GENRES_BY_INITIALE (
    INITIALE CHAR(1))
RETURNS (
    ID_GENRE CHAR(38) CHARACTER SET NONE,
    GENRE VARCHAR(30))
AS
begin
  FOR SELECT ID_GENRE,
             GENRE
      FROM GENRES
      WHERE INITIALEGENRE = :INITIALE
      ORDER BY UPPERGENRE
      INTO :ID_GENRE,
           :GENRE
  DO
  BEGIN
    SUSPEND;
  END
end;

DROP VIEW VW_LISTE_PARABD;
CREATE VIEW VW_LISTE_PARABD(
    ID_PARABD,
    TITREPARABD,
    ID_SERIE,
    TITRESERIE,
    UPPERTITREPARABD,
    UPPERTITRESERIE,
    ACHAT,
    COMPLET,
    SCATEGORIE)
AS
select a.ID_PARABD,
       a.TITREPARABD,
       a.ID_SERIE,
       s.TITRESERIE,
       a.UPPERTITREPARABD,
       s.UPPERTITRESERIE,
       a.ACHAT,
       a.COMPLET,
       lc.LIBELLE
FROM PARABD a INNER JOIN SERIES s ON s.ID_SERIE = a.id_serie
LEFT JOIN LISTES lc on (lc.ref = a.CATEGORIEPARABD and lc.categorie = 7);

DROP VIEW VW_INITIALES_PERSONNES;
CREATE VIEW VW_INITIALES_PERSONNES(
    INITIALENOMPERSONNE,
    COUNTINITIALE)
AS
select
    initialenomPERSONNE,
    Count(ID_PERSONNE)
from PERSONNES
group by initialenomPERSONNE;

ALTER PROCEDURE PERSONNES_BY_INITIALE (
    INITIALE CHAR(1))
RETURNS (
    ID_PERSONNE CHAR(38) CHARACTER SET NONE,
    NOMPERSONNE VARCHAR(150))
AS
BEGIN
  FOR SELECT ID_PERSONNE,
             NOMPERSONNE
      FROM PERSONNES
      WHERE INITIALENOMPERSONNE = :INITIALE
      ORDER BY UPPERNOMPERSONNE
      INTO :ID_PERSONNE,
           :NOMPERSONNE
  DO
  BEGIN
    SUSPEND;
  END
END;

DROP VIEW VW_INITIALES_SERIES;
CREATE VIEW VW_INITIALES_SERIES(
    INITIALETITRESERIE,
    COUNTINITIALE)
AS
select
    initialetitreserie,
    Count(ID_SERIE)
from SERIES
group by initialetitreserie;

ALTER PROCEDURE ALBUMS_BY_ANNEE (
    ANNEE INTEGER,
    FILTRE VARCHAR(125))
RETURNS (
    ID_ALBUM CHAR(38) CHARACTER SET NONE,
    TITREALBUM VARCHAR(150),
    TOME SMALLINT,
    TOMEDEBUT SMALLINT,
    TOMEFIN SMALLINT,
    HORSSERIE SMALLINT,
    INTEGRALE SMALLINT,
    MOISPARUTION SMALLINT,
    ANNEEPARUTION SMALLINT,
    ID_SERIE CHAR(38) CHARACTER SET NONE,
    TITRESERIE VARCHAR(150),
    ACHAT SMALLINT,
    COMPLET INTEGER)
AS
DECLARE VARIABLE SWHERE VARCHAR(200);
BEGIN
  if (:Annee = -1) then sWhere = 'ANNEEPARUTION is null ';
                   else sWhere = 'ANNEEPARUTION = ' || :ANNEE || ' ';
  if (filtre is not null and filtre <> '') then swhere = swhere || 'and ' || filtre || ' ';
  for execute statement
      'SELECT ID_ALBUM,
             TITREALBUM,
             TOME,
             TOMEDEBUT,
             TOMEFIN,
             HORSSERIE,
             INTEGRALE,
             MOISPARUTION,
             ANNEEPARUTION,
             ID_SERIE,
             TITRESERIE,
             ACHAT,
             COMPLET
        FROM vw_liste_albums
        WHERE ' || :sWHERE ||
        'ORDER BY UPPERTITREALBUM, UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST'
        INTO :ID_ALBUM,
             :TITREALBUM,
             :TOME,
             :TOMEDEBUT,
             :TOMEFIN,
             :HORSSERIE,
             :INTEGRALE,
             :MOISPARUTION,
             :ANNEEPARUTION,
             :ID_SERIE,
             :TITRESERIE,
             :ACHAT,
             :COMPLET
      DO
      BEGIN
        SUSPEND;
      END
end;

ALTER PROCEDURE ALBUMS_BY_AUTEUR (
    ID_AUTEUR CHAR(38) CHARACTER SET NONE,
    FILTRE VARCHAR(125))
RETURNS (
    ID_ALBUM CHAR(38) CHARACTER SET NONE,
    TITREALBUM VARCHAR(150),
    TOME SMALLINT,
    TOMEDEBUT SMALLINT,
    TOMEFIN SMALLINT,
    HORSSERIE SMALLINT,
    INTEGRALE SMALLINT,
    MOISPARUTION SMALLINT,
    ANNEEPARUTION SMALLINT,
    ID_SERIE CHAR(38) CHARACTER SET NONE,
    TITRESERIE VARCHAR(150),
    METIER SMALLINT,
    ACHAT SMALLINT,
    COMPLET INTEGER)
AS
DECLARE VARIABLE SWHERE VARCHAR(200);
BEGIN
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'and ' || filtre || ' ';
  FOR execute statement
     'SELECT A.ID_ALBUM,
             A.TITREALBUM,
             A.TOME,
             A.TOMEDEBUT,
             A.TOMEFIN,
             A.HORSSERIE,
             A.INTEGRALE,
             A.MOISPARUTION,
             A.ANNEEPARUTION,
             A.ID_SERIE,
             A.TITRESERIE,
             AU.metier,
             A.ACHAT,
             A.COMPLET
      FROM vw_liste_albums A INNER JOIN auteurs au on a.ID_album = au.ID_album
      WHERE au.ID_personne = ''' || :id_auteur || ''' ' || swhere ||
      'ORDER BY UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST, UPPERTITREALBUM, METIER'
      INTO :ID_ALBUM,
           :TITREALBUM,
           :TOME,
           :TOMEDEBUT,
           :TOMEFIN,
           :HORSSERIE,
           :INTEGRALE,
           :MOISPARUTION,
           :ANNEEPARUTION,
           :ID_SERIE,
           :TITRESERIE,
           :METIER,
           :ACHAT,
           :COMPLET
      DO
      BEGIN
        SUSPEND;
      END
end;

ALTER PROCEDURE ALBUMS_BY_COLLECTION (
    ID_COLLECTION CHAR(38) CHARACTER SET NONE,
    FILTRE VARCHAR(125))
RETURNS (
    ID_ALBUM CHAR(38) CHARACTER SET NONE,
    TITREALBUM VARCHAR(150),
    TOME SMALLINT,
    TOMEDEBUT SMALLINT,
    TOMEFIN SMALLINT,
    HORSSERIE SMALLINT,
    INTEGRALE SMALLINT,
    MOISPARUTION SMALLINT,
    ANNEEPARUTION SMALLINT,
    ID_SERIE CHAR(38) CHARACTER SET NONE,
    TITRESERIE VARCHAR(150),
    ACHAT SMALLINT,
    COMPLET INTEGER)
AS
DECLARE VARIABLE SWHERE VARCHAR(200);
BEGIN
  if (:ID_COLLECTION = CAST('' AS CHAR(38))) then sWhere = 'e.ID_COLLECTION is null ';
                           else sWhere = 'e.ID_COLLECTION = ''' || :ID_COLLECTION || ''' ';
  if (filtre is not null and filtre <> '') then swhere = swhere || 'and ' || filtre || ' ';
  for execute statement
      'SELECT a.ID_ALBUM,
             a.TITREALBUM,
             a.TOME,
             a.TOMEDEBUT,
             a.TOMEFIN,
             a.HORSSERIE,
             a.INTEGRALE,
             a.MOISPARUTION,
             a.ANNEEPARUTION,
             a.ID_SERIE,
             s.TITRESERIE,
             a.ACHAT,
             a.COMPLET
      from albums a left join editions e on a.ID_ALBUM = e.id_album
                    left join series s on a.id_serie = s.ID_SERIE
      WHERE ' || :sWHERE ||
     'ORDER BY UPPERTITREALBUM, UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST'
      INTO :ID_ALBUM,
           :TITREALBUM,
           :TOME,
           :TOMEDEBUT,
           :TOMEFIN,
           :HORSSERIE,
           :INTEGRALE,
           :MOISPARUTION,
           :ANNEEPARUTION,
           :ID_SERIE,
           :TITRESERIE,
           :ACHAT,
           :COMPLET
      DO
      BEGIN
        SUSPEND;
      END
end;

ALTER PROCEDURE ALBUMS_BY_EDITEUR (
    ID_EDITEUR CHAR(38) CHARACTER SET NONE,
    FILTRE VARCHAR(125))
RETURNS (
    ID_ALBUM CHAR(38) CHARACTER SET NONE,
    TITREALBUM VARCHAR(150),
    TOME SMALLINT,
    TOMEDEBUT SMALLINT,
    TOMEFIN SMALLINT,
    HORSSERIE SMALLINT,
    INTEGRALE SMALLINT,
    MOISPARUTION SMALLINT,
    ANNEEPARUTION SMALLINT,
    ID_SERIE CHAR(38) CHARACTER SET NONE,
    TITRESERIE VARCHAR(150),
    ACHAT SMALLINT,
    COMPLET INTEGER)
AS
DECLARE VARIABLE SWHERE VARCHAR(133);
BEGIN
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'and ' || filtre || ' ';
  FOR execute statement
     'SELECT a.ID_ALBUM,
             a.TITREALBUM,
             a.TOME,
             a.TOMEDEBUT,
             a.TOMEFIN,
             a.HORSSERIE,
             a.INTEGRALE,
             a.MOISPARUTION,
             a.ANNEEPARUTION,
             a.ID_SERIE,
             s.TITRESERIE,
             a.ACHAT,
             a.COMPLET
      from albums a LEFT join editions e on a.ID_ALBUM = e.id_album
                    LEFT join series s on a.id_serie = s.ID_SERIE
      WHERE coalesce(e.id_editeur, -1) = ''' || :id_editeur || ''' ' || swhere ||
      'ORDER BY UPPERTITREALBUM, UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST'
      INTO :ID_ALBUM,
           :TITREALBUM,
           :TOME,
           :TOMEDEBUT,
           :TOMEFIN,
           :HORSSERIE,
           :INTEGRALE,
           :MOISPARUTION,
           :ANNEEPARUTION,
           :ID_SERIE,
           :TITRESERIE,
           :ACHAT,
           :COMPLET
  DO
  BEGIN
    SUSPEND;
  END
end;

ALTER PROCEDURE ALBUMS_BY_GENRE (
    ID_GENRE CHAR(38) CHARACTER SET NONE,
    FILTRE VARCHAR(125))
RETURNS (
    ID_ALBUM CHAR(38) CHARACTER SET NONE,
    TITREALBUM VARCHAR(150),
    TOME SMALLINT,
    TOMEDEBUT SMALLINT,
    TOMEFIN SMALLINT,
    HORSSERIE SMALLINT,
    INTEGRALE SMALLINT,
    MOISPARUTION SMALLINT,
    ANNEEPARUTION SMALLINT,
    ID_SERIE CHAR(38) CHARACTER SET NONE,
    TITRESERIE VARCHAR(150),
    ACHAT SMALLINT,
    COMPLET INTEGER)
AS
DECLARE VARIABLE SWHERE VARCHAR(200);
BEGIN
  if (:ID_Genre = CAST('' AS CHAR(38))) then sWhere = 'ID_Genre is null ';
                      else sWhere = 'ID_genre = ''' || :ID_genre || ''' ';
  if (filtre is not null and filtre <> '') then swhere = swhere || 'and ' || filtre || ' ';
  for execute statement
      'SELECT ID_ALBUM,
             TITREALBUM,
             TOME,
             TOMEDEBUT,
             TOMEFIN,
             HORSSERIE,
             INTEGRALE,
             MOISPARUTION,
             ANNEEPARUTION,
             a.ID_SERIE,
             TITRESERIE,
             ACHAT,
             COMPLET
       FROM VW_LISTE_ALBUMS a LEFT JOIN GENRESERIES gs ON gs.id_serie = a.id_serie
                              LEFT JOIN GENRES g ON gs.id_genre = g.ID_GENRE
       WHERE ' || :sWHERE ||
      'ORDER BY UPPERTITREALBUM, UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST'
       INTO :ID_ALBUM,
            :TITREALBUM,
            :TOME,
            :TOMEDEBUT,
            :TOMEFIN,
            :HORSSERIE,
            :INTEGRALE,
            :MOISPARUTION,
            :ANNEEPARUTION,
            :ID_SERIE,
            :TITRESERIE,
            :ACHAT,
            :COMPLET
      DO
      BEGIN
        SUSPEND;
      END
end;

ALTER PROCEDURE ALBUMS_BY_INITIALE (
    INITIALE CHAR(1),
    FILTRE VARCHAR(125))
RETURNS (
    ID_ALBUM CHAR(38) CHARACTER SET NONE,
    TITREALBUM VARCHAR(150),
    TOME SMALLINT,
    TOMEDEBUT SMALLINT,
    TOMEFIN SMALLINT,
    HORSSERIE SMALLINT,
    INTEGRALE SMALLINT,
    MOISPARUTION SMALLINT,
    ANNEEPARUTION SMALLINT,
    ID_SERIE CHAR(38) CHARACTER SET NONE,
    TITRESERIE VARCHAR(150),
    ACHAT SMALLINT,
    COMPLET INTEGER)
AS
DECLARE VARIABLE SWHERE VARCHAR(133);
BEGIN
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'and ' || filtre || ' ';
  FOR execute statement
     'SELECT a.ID_ALBUM,
             a.TITREALBUM,
             a.TOME,
             a.TOMEDEBUT,
             a.TOMEFIN,
             a.HORSSERIE,
             a.INTEGRALE,
             a.MOISPARUTION,
             a.ANNEEPARUTION,
             a.ID_SERIE,
             s.TITRESERIE,
             a.ACHAT,
             a.COMPLET
      FROM ALBUMS a INNER JOIN SERIES s ON s.ID_SERIE = a.id_serie
      WHERE a.initialetitrealbum = ''' || :INITIALE || ''' ' || swhere ||
      'ORDER BY UPPERTITREALBUM, UPPERTITRESERIE, HORSSERIE NULLS FIRST, INTEGRALE NULLS FIRST, TOME NULLS FIRST, TOMEDEBUT NULLS FIRST, TOMEFIN NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST'
      INTO :ID_ALBUM,
           :TITREALBUM,
           :TOME,
           :TOMEDEBUT,
           :TOMEFIN,
           :HORSSERIE,
           :INTEGRALE,
           :MOISPARUTION,
           :ANNEEPARUTION,
           :ID_SERIE,
           :TITRESERIE,
           :ACHAT,
           :COMPLET
  DO
  BEGIN
    SUSPEND;
  END
end;

ALTER PROCEDURE ALBUMS_BY_SERIE (
    IN_ID_SERIE CHAR(38) CHARACTER SET NONE,
    FILTRE VARCHAR(125))
RETURNS (
    ID_ALBUM CHAR(38) CHARACTER SET NONE,
    TITREALBUM VARCHAR(150),
    TOME SMALLINT,
    TOMEDEBUT SMALLINT,
    TOMEFIN SMALLINT,
    HORSSERIE SMALLINT,
    INTEGRALE SMALLINT,
    MOISPARUTION SMALLINT,
    ANNEEPARUTION SMALLINT,
    ID_SERIE CHAR(38) CHARACTER SET NONE,
    TITRESERIE VARCHAR(150),
    ACHAT SMALLINT,
    COMPLET INTEGER)
AS
DECLARE VARIABLE SWHERE VARCHAR(130);
BEGIN
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'and ' || filtre || ' ';
  FOR execute statement
      'SELECT ID_ALBUM,
             TITREALBUM,
             TOME,
             TOMEDEBUT,
             TOMEFIN,
             HORSSERIE,
             INTEGRALE,
             MOISPARUTION,
             ANNEEPARUTION,
             ID_SERIE,
             TITRESERIE,
             ACHAT,
             COMPLET
      FROM vw_liste_albums
      WHERE ID_serie = ''' || :in_id_serie || ''' ' || swhere ||
      'ORDER BY HORSSERIE NULLS FIRST, INTEGRALE NULLS First, TOME NULLS FIRST, ANNEEPARUTION NULLS FIRST, MOISPARUTION NULLS FIRST, UPPERTITREALBUM'
      INTO :ID_ALBUM,
           :TITREALBUM,
           :TOME,
           :TOMEDEBUT,
           :TOMEFIN,
           :HORSSERIE,
           :INTEGRALE,
           :MOISPARUTION,
           :ANNEEPARUTION,
           :ID_SERIE,
           :TITRESERIE,
           :ACHAT,
           :COMPLET
  DO
  BEGIN
    SUSPEND;
  END
end;

ALTER PROCEDURE COLLECTIONS_ALBUMS (
    FILTRE VARCHAR(125))
RETURNS (
    NOMCOLLECTION VARCHAR(50),
    COUNTCOLLECTION INTEGER,
    ID_COLLECTION CHAR(38) CHARACTER SET NONE)
AS
DECLARE VARIABLE SWHERE VARCHAR(133);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'AND ' || filtre;

  for execute statement
     'select
             CAST(''-1'' AS VARCHAR(50)),
             Count(ID_ALBUM),
             NULL
      from vw_liste_collections_albums
      where ID_COLLECTION is null ' || SWHERE ||
     'group by uppernomcollection, nomCOLLECTION, ID_COLLECTION'
  into :nomCOLLECTION,
       :countCOLLECTION,
       :ID_COLLECTION
  do begin
    suspend;
  end

  for execute statement
     'select
             nomCOLLECTION,
             Count(ID_ALBUM),
             ID_COLLECTION
      from vw_liste_collections_albums
      where ID_COLLECTION is not null ' || SWHERE ||
     'group by uppernomcollection, nomCOLLECTION, ID_COLLECTION'
  into :nomCOLLECTION,
       :countCOLLECTION,
       :ID_COLLECTION
  do begin
    suspend;
  end
end;

ALTER PROCEDURE COLLECTIONS_BY_INITIALE (
    INITIALE CHAR(1),
    FILTRE VARCHAR(125))
RETURNS (
    ID_COLLECTION CHAR(38) CHARACTER SET NONE,
    NOMCOLLECTION VARCHAR(50))
AS
DECLARE VARIABLE SWHERE VARCHAR(133);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'and ' || filtre || ' ';
  FOR execute statement
     'SELECT ID_COLLECTION,
             NOMCOLLECTION
      FROM COLLECTIONS
      WHERE INITIALENOMCOLLECTION = ''' || :INITIALE || ''' ' || swhere ||
      'ORDER BY UPPERNOMCOLLECTION'
      INTO :ID_COLLECTION,
           :NOMCOLLECTION
  DO
  BEGIN
    SUSPEND;
  END
end;

ALTER PROCEDURE EDITEURS_ALBUMS (
    FILTRE VARCHAR(125))
RETURNS (
    NOMEDITEUR VARCHAR(50),
    COUNTEDITEUR INTEGER,
    ID_EDITEUR CHAR(38) CHARACTER SET NONE)
AS
DECLARE VARIABLE SWHERE VARCHAR(133);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'AND ' || filtre;

  for execute statement
     'select
             CAST(''-1'' AS VARCHAR(50)),
             Count(ID_ALBUM),
             NULL
      from vw_liste_editeurs_albums
      where ID_EDITEUR is null ' || SWHERE ||
     'group by uppernomediteur, nomediteur, ID_editeur'
  into :nomediteur,
       :countediteur,
       :ID_Editeur
  do begin
    suspend;
  end

  for execute statement
     'select
             nomediteur,
             Count(ID_ALBUM),
             ID_Editeur
      from vw_liste_editeurs_albums
      where ID_EDITEUR is not null ' || SWHERE ||
     'group by uppernomediteur, nomediteur, ID_editeur'
  into :nomediteur,
       :countediteur,
       :ID_Editeur
  do begin
    suspend;
  end
end;

ALTER PROCEDURE GENRES_ALBUMS (
    FILTRE VARCHAR(125))
RETURNS (
    GENRE VARCHAR(30),
    COUNTGENRE INTEGER,
    ID_GENRE CHAR(38) CHARACTER SET NONE)
AS
DECLARE VARIABLE SWHERE VARCHAR(132);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'AND ' || filtre;

  for execute statement
     'select
             CAST(''-1'' AS VARCHAR(30)),
             Count(ID_ALBUM),
             NULL
      from vw_liste_genres_albums
      where ID_GENRE is null ' || SWHERE ||
     'group by uppergenre, Genre, ID_genre'
  into :genre,
       :countgenre,
       :ID_genre
  do begin
    suspend;
  end

  for execute statement
     'select
             Genre,
             Count(ID_ALBUM),
             ID_genre
      from vw_liste_genres_albums
      where ID_GENRE is not null ' || SWHERE ||
     'group by uppergenre, Genre, ID_genre'
  into :genre,
       :countgenre,
       :ID_genre
  do begin
    suspend;
  end
end;

ALTER PROCEDURE INITIALES_ALBUMS (
    FILTRE VARCHAR(125))
RETURNS (
    INITIALETITREALBUM CHAR(1),
    COUNTINITIALE INTEGER)
AS
DECLARE VARIABLE SWHERE VARCHAR(133);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'WHERE ' || filtre;
  for execute statement
      'select initialetitrealbum,
               Count(ID_ALBUM)
      from ALBUMS ' || SWHERE ||
      ' group by initialetitrealbum'
      into :INITIALETITREALBUM,
           :COUNTINITIALE
  do
    suspend;
end;

ALTER PROCEDURE INITIALES_COLLECTIONS (
    FILTRE VARCHAR(125))
RETURNS (
    INITIALENOMCOLLECTION CHAR(1),
    COUNTINITIALE INTEGER)
AS
DECLARE VARIABLE SWHERE VARCHAR(133);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'WHERE ' || filtre;
  for execute statement
      'select initialenomCOLLECTION,
               Count(ID_COLLECTION)
      from COLLECTIONS ' || SWHERE ||
      ' group by initialenomCOLLECTION'
      into :INITIALENOMCOLLECTION,
           :COUNTINITIALE
  do
    suspend;
end;

ALTER PROCEDURE PARABD_BY_SERIE (
    IN_ID_SERIE CHAR(38) CHARACTER SET NONE,
    FILTRE VARCHAR(125))
RETURNS (
    ID_PARABD CHAR(38) CHARACTER SET NONE,
    TITREPARABD VARCHAR(150),
    ID_SERIE CHAR(38) CHARACTER SET NONE,
    TITRESERIE VARCHAR(150),
    ACHAT SMALLINT,
    COMPLET INTEGER,
    SCATEGORIE VARCHAR(50))
AS
DECLARE VARIABLE SWHERE VARCHAR(130);
BEGIN
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'and ' || filtre || ' ';
  FOR execute statement
      'SELECT ID_PARABD,
             TITREPARABD,
             ID_PARABD,
             TITRESERIE,
             ACHAT,
             COMPLET,
             SCATEGORIE
      FROM vw_liste_PARABD
      WHERE ID_serie = ''' || :in_id_serie || ''' ' || swhere ||
      'ORDER BY UPPERTITREPARABD'
      INTO :ID_PARABD,
           :TITREPARABD,
           :ID_SERIE,
           :TITRESERIE,
           :ACHAT,
           :COMPLET,
           :SCATEGORIE
  DO
  BEGIN
    SUSPEND;
  END
end;

ALTER PROCEDURE SERIES_ALBUMS (
    FILTRE VARCHAR(125))
RETURNS (
    TITRESERIE VARCHAR(150),
    COUNTSERIE INTEGER,
    ID_SERIE CHAR(38) CHARACTER SET NONE)
AS
DECLARE VARIABLE SWHERE VARCHAR(132);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'AND ' || filtre;

  for execute statement
     'select
             -1,
             ID_Serie,
             Count(ID_ALBUM)
      from vw_liste_albums
      where TITRESerie is null ' || SWHERE ||
    ' group by UPPERTITRESERIE, TITRESerie, ID_Serie'
  into :TITRESerie,
       :ID_Serie,
       :countSerie
  do
    suspend;

  for execute statement
     'select
             TITRESerie,
             ID_Serie,
             Count(ID_ALBUM)
      from vw_liste_albums
      where TITRESerie is not null ' || SWHERE ||
    ' group by UPPERTITRESERIE, TITRESerie, ID_Serie'
  into :TITRESerie,
       :ID_Serie,
       :countSerie
  do
    suspend;
end;

ALTER PROCEDURE SERIES_PARABD (
    FILTRE VARCHAR(125))
RETURNS (
    TITRESERIE VARCHAR(150),
    COUNTSERIE INTEGER,
    ID_SERIE CHAR(38) CHARACTER SET NONE)
AS
DECLARE VARIABLE SWHERE VARCHAR(132);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'AND ' || filtre;

  for execute statement
     'select
             -1,
             ID_Serie,
             Count(ID_PARABD)
      from vw_liste_parabd
      where TITRESerie is null ' || SWHERE ||
    ' group by UPPERTITRESERIE, TITRESerie, ID_Serie'
  into :TITRESerie,
       :ID_Serie,
       :countSerie
  do
    suspend;

  for execute statement
     'select
             TITRESerie,
             ID_Serie,
             Count(ID_PARABD)
      from vw_liste_parabd
      where TITRESerie is not null ' || SWHERE ||
    ' group by UPPERTITRESERIE, TITRESerie, ID_Serie'
  into :TITRESerie,
       :ID_Serie,
       :countSerie
  do
    suspend;
end;

ALTER PROCEDURE ANNEES_ALBUMS (
    FILTRE VARCHAR(125))
RETURNS (
    ANNEEPARUTION SMALLINT,
    COUNTANNEE INTEGER)
AS
DECLARE VARIABLE SWHERE VARCHAR(133);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'AND ' || filtre;

  for execute statement
     'select
             CAST(-1 AS SMALLINT),
             Count(ID_ALBUM)
      from vw_liste_albums
      where AnneeParution is null ' || SWHERE ||
     'group by AnneeParution'
  into :AnneeParution,
       :countannee
  do begin
    suspend;
  end

  for execute statement
     'select
             AnneeParution,
             Count(ID_ALBUM)
      from vw_liste_albums
      where AnneeParution is not null ' || SWHERE ||
     'group by AnneeParution'
  into :AnneeParution,
       :countannee
  do begin
    suspend;
  end
end;

DROP TRIGGER ALBUMS_AI;
DROP TRIGGER COLLECTIONS_AI;
DROP TRIGGER COUVERTURES_AI;
DROP TRIGGER EDITEURS_AI;
DROP TRIGGER EDITIONS_AI;
DROP TRIGGER EMPRUNTEURS_AI;
DROP TRIGGER GENRES_AI;
DROP TRIGGER PARABD_AI;
DROP TRIGGER PERSONNES_AI;
DROP TRIGGER SERIES_AI;
DROP TRIGGER STATUT_AI;

