create view vw_dernieres_modifs(
    typedata,
    date_creation,
    date_modif,
    id,
    titrealbum,
    tome,
    tomedebut,
    tomefin,
    integrale,
    horsserie,
    titreserie,
    nomediteur,
    nomcollection,
    nompersonne)
as
select
  'A', a.dc_albums, a.dm_albums, a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.integrale, a.horsserie, s.titreserie, null , null , null
from
  albums a
  left join series s on
    a.id_serie = s.id_serie

union

select
  'S', s.dc_series, s.dm_series, s.id_serie, null , null , null , null , null , null , s.titreserie, e.nomediteur, c.nomcollection, null
from
  series s
  left join editeurs e on
    e.id_editeur = s.id_editeur
  left join collections c on
    c.id_collection = s.id_collection

union

select
  'P', p.dc_personnes, p.dm_personnes, p.id_personne, null , null , null , null , null , null , null , null , null , p.nompersonne
from
  personnes p
;

create view vw_liste_albums(
    id_album,
    titrealbum,
    tome,
    tomedebut,
    tomefin,
    horsserie,
    integrale,
    moisparution,
    anneeparution,
    id_serie,
    titreserie,
    achat,
    complet,
    initialetitrealbum,
    initialetitreserie)
as
select a.id_album,
       a.titrealbum,
       a.tome,
       a.tomedebut,
       a.tomefin,
       a.horsserie,
       a.integrale,
       a.moisparution,
       a.anneeparution,
       a.id_serie,
       s.titreserie,
       a.achat,
       a.complet,
       coalesce(a.initialetitrealbum, s.initialetitreserie),
       s.initialetitreserie
from 
  albums a 
  left join series s on 
    s.id_serie = a.id_serie
;

create view vw_emprunts(
    id_statut,
    id_edition,
    id_album,
    titrealbum,
    id_serie,
    tome,
    integrale,
    tomedebut,
    tomefin,
    horsserie,
    titreserie,
    id_editeur,
    nomediteur,
    id_collection,
    nomcollection,
    prete,
    anneeedition,
    isbn,
    id_emprunteur,
    nomemprunteur,
    pretemprunt,
    dateemprunt)
as
select s.id_statut,
       ed.id_edition,
       a.id_album,
       a.titrealbum,
       a.id_serie,
       a.tome,
       a.integrale,
       a.tomedebut,
       a.tomefin,
       a.horsserie,
       a.titreserie,
       e.id_editeur,
       e.nomediteur,
       c.id_collection,
       c.nomcollection,
       ed.prete,
       ed.anneeedition,
       ed.isbn,
       em.id_emprunteur,
       em.nomemprunteur,
       s.pretemprunt,
       s.dateemprunt
from 
  vw_liste_albums a
  inner join editions ed on a.id_album = ed.id_album
  inner join editeurs e on e.id_editeur = ed.id_editeur
  left join collections c on c.id_collection = ed.id_collection
  inner join statut s on ed.id_edition = s.id_edition
  inner join emprunteurs em on em.id_emprunteur = s.id_emprunteur
;

create view vw_initiales_editeurs(
    initialenomediteur,
    countinitiale)
as
select
    initialenomediteur,
    count(id_editeur)
from editeurs
group by initialenomediteur
;

create view vw_initiales_emprunteurs(
    initialenomemprunteur,
    countinitiale)
as
select
    initialenomemprunteur,
    count(id_emprunteur)
from emprunteurs
group by initialenomemprunteur
;

create view vw_initiales_genres(
    initialegenre,
    countinitiale)
as
select
    initialegenre,
    count(id_genre)
from genres
group by initialegenre
;

create view vw_initiales_personnes(
    initialenompersonne,
    countinitiale)
as
select
    initialenompersonne,
    count(id_personne)
from personnes
group by initialenompersonne
;

create view vw_initiales_series(
    initialetitreserie,
    countinitiale)
as
select
    initialetitreserie,
    count(id_serie)
from series
group by initialetitreserie
;

create view vw_liste_collections_albums(
    id_album,
    titrealbum,
    tome,
    tomedebut,
    tomefin,
    horsserie,
    integrale,
    moisparution,
    anneeparution,
    id_serie,
    titreserie,
    id_collection,
    nomcollection,
    achat,
    complet)
as
select a.id_album,
       a.titrealbum,
       a.tome,
       a.tomedebut,
       a.tomefin,
       a.horsserie,
       a.integrale,
       a.moisparution,
       a.anneeparution,
       a.id_serie,
       a.titreserie,
       c.id_collection,
       c.nomcollection,
       a.achat,
       a.complet
from vw_liste_albums a left join editions e on e.id_album = a.id_album
                       left join collections c on e.id_collection = c.id_collection
;

create view vw_liste_editeurs_achatalbums(
    id_album,
    titrealbum,
    tome,
    tomedebut,
    tomefin,
    horsserie,
    integrale,
    moisparution,
    anneeparution,
    id_serie,
    titreserie,
    id_editeur,
    nomediteur,
    achat,
    complet)
as
select a.id_album,
       a.titrealbum,
       a.tome,
       a.tomedebut,
       a.tomefin,
       a.horsserie,
       a.integrale,
       a.moisparution,
       a.anneeparution,
       a.id_serie,
       a.titreserie,
       e.id_editeur,
       e.nomediteur,
       a.achat,
       a.complet
from vw_liste_albums a left join series s on s.id_serie = a.id_serie
                       left join editeurs e on e.id_editeur = s.id_editeur
;

create view vw_liste_editeurs_albums(
    id_album,
    titrealbum,
    tome,
    tomedebut,
    tomefin,
    horsserie,
    integrale,
    moisparution,
    anneeparution,
    id_serie,
    titreserie,
    id_editeur,
    nomediteur,
    achat,
    complet)
as
select a.id_album,
       a.titrealbum,
       a.tome,
       a.tomedebut,
       a.tomefin,
       a.horsserie,
       a.integrale,
       a.moisparution,
       a.anneeparution,
       a.id_serie,
       a.titreserie,
       e.id_editeur,
       e.nomediteur,
       a.achat,
       a.complet
from vw_liste_albums a left join editions ed on ed.id_album = a.id_album
                       left join editeurs e on e.id_editeur = ed.id_editeur
;

create view vw_liste_genres_albums(
    id_album,
    titrealbum,
    tome,
    tomedebut,
    tomefin,
    horsserie,
    integrale,
    moisparution,
    anneeparution,
    id_serie,
    titreserie,
    id_genre,
    genre,
    achat,
    complet)
as
select a.id_album,
       a.titrealbum,
       a.tome,
       a.tomedebut,
       a.tomefin,
       a.horsserie,
       a.integrale,
       a.moisparution,
       a.anneeparution,
       a.id_serie,
       a.titreserie,
       g.id_genre,
       g.genre,
       a.achat,
       a.complet
from vw_liste_albums a left join genreseries gs on gs.id_serie = a.id_serie
                       left join genres g on gs.id_genre = g.id_genre
;

create view vw_liste_parabd(
    id_parabd,
    titreparabd,
    id_serie,
    titreserie,
    achat,
    complet,
    scategorie)
as
select a.id_parabd,
       a.titreparabd,
       a.id_serie,
       s.titreserie,
       a.achat,
       a.complet,
       lc.libelle
from parabd a left join series s on s.id_serie = a.id_serie
left join listes lc on (lc.ref = a.categorieparabd and lc.categorie = 7)
;

create view vw_prixalbums(
    id_album,
    horsserie,
    tome,
    integrale,
    tomedebut,
    tomefin,
    nbalbums,
    id_serie,
    id_edition,
    id_editeur,
    prix)
as
select
  a.id_album,
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
  e.id_edition,
  e.id_editeur,
  e.prix
from albums a
  inner join editions e on a.id_album = e.id_album
;

create view vw_prixunitaires(
    horsserie,
    id_serie,
    id_editeur,
    prixunitaire)
as
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
  id_editeur
;


create or alter procedure achatalbums_by_editeur (
    id_editeur char(38),
    filtre varchar(125))
returns (
    id_album char(38),
    titrealbum varchar(150),
    tome smallint,
    tomedebut smallint,
    tomefin smallint,
    horsserie smallint,
    integrale smallint,
    moisparution smallint,
    anneeparution smallint,
    id_serie char(38),
    titreserie varchar(150),
    achat smallint,
    complet integer)
as
declare variable swhere varchar(133);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'and ' || filtre || ' ';
  for execute statement
     'select a.id_album,
             a.titrealbum,
             a.tome,
             a.tomedebut,
             a.tomefin,
             a.horsserie,
             a.integrale,
             a.moisparution,
             a.anneeparution,
             a.id_serie,
             s.titreserie,
             a.achat,
             a.complet
      from albums a left join series s on a.id_serie = s.id_serie
      where coalesce(s.id_editeur, -1) = ''' || :id_editeur || ''' ' || swhere ||
      'order by coalesce(titrealbum, titreserie), titreserie, horsserie nulls first, integrale nulls first, tome nulls first, tomedebut nulls first, tomefin nulls first, anneeparution nulls first, moisparution nulls first'
      into :id_album,
           :titrealbum,
           :tome,
           :tomedebut,
           :tomefin,
           :horsserie,
           :integrale,
           :moisparution,
           :anneeparution,
           :id_serie,
           :titreserie,
           :achat,
           :complet
  do
  begin
    suspend;
  end
end;

create or alter procedure albums_by_annee (
    annee integer,
    filtre varchar(125))
returns (
    id_album char(38),
    titrealbum varchar(150),
    tome smallint,
    tomedebut smallint,
    tomefin smallint,
    horsserie smallint,
    integrale smallint,
    moisparution smallint,
    anneeparution smallint,
    id_serie char(38),
    titreserie varchar(150),
    achat smallint,
    complet integer)
as
declare variable swhere varchar(200);
begin
  if (:annee = -1) then swhere = 'anneeparution is null ';
                   else swhere = 'anneeparution = ' || :annee || ' ';
  if (filtre is not null and filtre <> '') then swhere = swhere || 'and ' || filtre || ' ';
  for execute statement
      'select id_album,
             titrealbum,
             tome,
             tomedebut,
             tomefin,
             horsserie,
             integrale,
             moisparution,
             anneeparution,
             id_serie,
             titreserie,
             achat,
             complet
        from vw_liste_albums
        where ' || :swhere ||
        'order by coalesce(titrealbum, titreserie), titreserie, horsserie nulls first, integrale nulls first, tome nulls first, tomedebut nulls first, tomefin nulls first, anneeparution nulls first, moisparution nulls first'
        into :id_album,
             :titrealbum,
             :tome,
             :tomedebut,
             :tomefin,
             :horsserie,
             :integrale,
             :moisparution,
             :anneeparution,
             :id_serie,
             :titreserie,
             :achat,
             :complet
      do
      begin
        suspend;
      end
end;

create or alter procedure albums_by_auteur (
    id_auteur char(38),
    filtre varchar(125))
returns (
    id_album char(38),
    titrealbum varchar(150),
    tome smallint,
    tomedebut smallint,
    tomefin smallint,
    horsserie smallint,
    integrale smallint,
    moisparution smallint,
    anneeparution smallint,
    id_serie char(38),
    titreserie varchar(150),
    metier smallint,
    achat smallint,
    complet integer)
as
declare variable swhere varchar(200);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'and ' || filtre || ' ';
  for execute statement
     'select a.id_album,
             a.titrealbum,
             a.tome,
             a.tomedebut,
             a.tomefin,
             a.horsserie,
             a.integrale,
             a.moisparution,
             a.anneeparution,
             a.id_serie,
             a.titreserie,
             au.metier,
             a.achat,
             a.complet
      from vw_liste_albums a inner join auteurs au on a.id_album = au.id_album
      where au.id_personne = ''' || :id_auteur || ''' ' || swhere ||
      'order by titreserie, horsserie nulls first, integrale nulls first, tome nulls first, anneeparution nulls first, moisparution nulls first, coalesce(titrealbum, titreserie), metier'
      into :id_album,
           :titrealbum,
           :tome,
           :tomedebut,
           :tomefin,
           :horsserie,
           :integrale,
           :moisparution,
           :anneeparution,
           :id_serie,
           :titreserie,
           :metier,
           :achat,
           :complet
      do
      begin
        suspend;
      end
end;

create or alter procedure albums_by_collection (
    id_collection char(38),
    filtre varchar(125))
returns (
    id_album char(38),
    titrealbum varchar(150),
    tome smallint,
    tomedebut smallint,
    tomefin smallint,
    horsserie smallint,
    integrale smallint,
    moisparution smallint,
    anneeparution smallint,
    id_serie char(38),
    titreserie varchar(150),
    achat smallint,
    complet integer)
as
declare variable swhere varchar(200);
begin
  if (:id_collection = cast('' as char(38))) then swhere = 'e.id_collection is null ';
                           else swhere = 'e.id_collection = ''' || :id_collection || ''' ';
  if (filtre is not null and filtre <> '') then swhere = swhere || 'and ' || filtre || ' ';
  for execute statement
      'select a.id_album,
             a.titrealbum,
             a.tome,
             a.tomedebut,
             a.tomefin,
             a.horsserie,
             a.integrale,
             a.moisparution,
             a.anneeparution,
             a.id_serie,
             s.titreserie,
             a.achat,
             a.complet
      from albums a left join editions e on a.id_album = e.id_album
                    left join series s on a.id_serie = s.id_serie
      where ' || :swhere ||
     'order by coalesce(titrealbum, titreserie), titreserie, horsserie nulls first, integrale nulls first, tome nulls first, tomedebut nulls first, tomefin nulls first, anneeparution nulls first, moisparution nulls first'
      into :id_album,
           :titrealbum,
           :tome,
           :tomedebut,
           :tomefin,
           :horsserie,
           :integrale,
           :moisparution,
           :anneeparution,
           :id_serie,
           :titreserie,
           :achat,
           :complet
      do
      begin
        suspend;
      end
end;

create or alter procedure albums_by_editeur (
    id_editeur char(38),
    filtre varchar(125))
returns (
    id_album char(38),
    titrealbum varchar(150),
    tome smallint,
    tomedebut smallint,
    tomefin smallint,
    horsserie smallint,
    integrale smallint,
    moisparution smallint,
    anneeparution smallint,
    id_serie char(38),
    titreserie varchar(150),
    achat smallint,
    complet integer)
as
declare variable swhere varchar(133);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'and ' || filtre || ' ';
  for execute statement
     'select a.id_album,
             a.titrealbum,
             a.tome,
             a.tomedebut,
             a.tomefin,
             a.horsserie,
             a.integrale,
             a.moisparution,
             a.anneeparution,
             a.id_serie,
             s.titreserie,
             a.achat,
             a.complet
      from albums a left join editions e on a.id_album = e.id_album
                    left join series s on a.id_serie = s.id_serie
      where coalesce(e.id_editeur, -1) = ''' || :id_editeur || ''' ' || swhere ||
      'order by coalesce(titrealbum, titreserie), titreserie, horsserie nulls first, integrale nulls first, tome nulls first, tomedebut nulls first, tomefin nulls first, anneeparution nulls first, moisparution nulls first'
      into :id_album,
           :titrealbum,
           :tome,
           :tomedebut,
           :tomefin,
           :horsserie,
           :integrale,
           :moisparution,
           :anneeparution,
           :id_serie,
           :titreserie,
           :achat,
           :complet
  do
  begin
    suspend;
  end
end;

create or alter procedure albums_by_genre (
    id_genre char(38),
    filtre varchar(125))
returns (
    id_album char(38),
    titrealbum varchar(150),
    tome smallint,
    tomedebut smallint,
    tomefin smallint,
    horsserie smallint,
    integrale smallint,
    moisparution smallint,
    anneeparution smallint,
    id_serie char(38),
    titreserie varchar(150),
    achat smallint,
    complet integer)
as
declare variable swhere varchar(200);
begin
  if (:id_genre = cast('' as char(38))) then swhere = 'g.id_genre is null ';
                      else swhere = 'g.id_genre = ''' || :id_genre || ''' ';
  if (filtre is not null and filtre <> '') then swhere = swhere || 'and ' || filtre || ' ';
  for execute statement
      'select id_album,
             titrealbum,
             tome,
             tomedebut,
             tomefin,
             horsserie,
             integrale,
             moisparution,
             anneeparution,
             a.id_serie,
             titreserie,
             achat,
             complet
       from vw_liste_albums a left join genreseries gs on gs.id_serie = a.id_serie
                              left join genres g on gs.id_genre = g.id_genre
       where ' || :swhere ||
      'order by coalesce(titrealbum, titreserie), titreserie, horsserie nulls first, integrale nulls first, tome nulls first, tomedebut nulls first, tomefin nulls first, anneeparution nulls first, moisparution nulls first'
       into :id_album,
            :titrealbum,
            :tome,
            :tomedebut,
            :tomefin,
            :horsserie,
            :integrale,
            :moisparution,
            :anneeparution,
            :id_serie,
            :titreserie,
            :achat,
            :complet
      do
      begin
        suspend;
      end
end;

create or alter procedure albums_by_initiale (
    initiale char(1),
    filtre varchar(125))
returns (
    id_album char(38),
    titrealbum varchar(150),
    tome smallint,
    tomedebut smallint,
    tomefin smallint,
    horsserie smallint,
    integrale smallint,
    moisparution smallint,
    anneeparution smallint,
    id_serie char(38),
    titreserie varchar(150),
    achat smallint,
    complet integer)
as
declare variable swhere varchar(133);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = ' and ' || filtre || ' ';
  for execute statement
     'select a.id_album,
             a.titrealbum,
             a.tome,
             a.tomedebut,
             a.tomefin,
             a.horsserie,
             a.integrale,
             a.moisparution,
             a.anneeparution,
             a.id_serie,
             s.titreserie,
             a.achat,
             a.complet
      from albums a left join series s on s.id_serie = a.id_serie
      where coalesce(a.initialetitrealbum, s.initialetitreserie) = ''' ||: initiale || ''' ' || swhere ||
      'order by coalesce(titrealbum, titreserie), titreserie, horsserie nulls first, integrale nulls first, tome nulls first, tomedebut nulls first, tomefin nulls first, anneeparution nulls first, moisparution nulls first '
      into :id_album,
           :titrealbum,
           :tome,
           :tomedebut,
           :tomefin,
           :horsserie,
           :integrale,
           :moisparution,
           :anneeparution,
           :id_serie,
           :titreserie,
           :achat,
           :complet
  do
  begin
    suspend;
  end
end;

create or alter procedure albums_by_serie (
    in_id_serie char(38),
    filtre varchar(125))
returns (
    id_album char(38),
    titrealbum varchar(150),
    tome smallint,
    tomedebut smallint,
    tomefin smallint,
    horsserie smallint,
    integrale smallint,
    moisparution smallint,
    anneeparution smallint,
    id_serie char(38),
    titreserie varchar(150),
    achat smallint,
    complet integer)
as
declare variable swhere varchar(130);
begin
  if (:in_id_serie = cast('' as char(38))) then swhere = 'id_serie is null ';
                           else swhere = 'id_serie = ''' || :in_id_serie || ''' ';
  if (filtre is not null and filtre <> '') then swhere = swhere || 'and ' || filtre || ' ';
  for execute statement
      'select id_album,
             titrealbum,
             tome,
             tomedebut,
             tomefin,
             horsserie,
             integrale,
             moisparution,
             anneeparution,
             id_serie,
             titreserie,
             achat,
             complet
      from vw_liste_albums
      where ' || :swhere ||
      'order by horsserie nulls first, integrale nulls first, tome nulls first, anneeparution nulls first, moisparution nulls first, titrealbum'
      into :id_album,
           :titrealbum,
           :tome,
           :tomedebut,
           :tomefin,
           :horsserie,
           :integrale,
           :moisparution,
           :anneeparution,
           :id_serie,
           :titreserie,
           :achat,
           :complet
  do
  begin
    suspend;
  end
end;

create or alter procedure albums_manquants (
    withintegrale smallint,
    withachat smallint,
    in_idserie char(38))
returns (
    id_serie char(38),
    countserie integer,
    titreserie varchar(150),
    tome integer,
    id_editeur char(38),
    nomediteur varchar(50),
    id_collection char(38),
    nomcollection varchar(50),
    achat smallint)
as
declare variable maxserie integer;
declare variable nb_albums integer;
declare variable currenttome integer;
declare variable ownedtome integer;
declare variable sumachat integer;
begin
  if (withintegrale is null) then withintegrale = 1;
  if (withachat is null) then withachat = 1;
  for
    select
      s.id_serie,
      s.nb_albums,
      max(a.tome),
      count(distinct a.tome),
      cast(sum(a.achat) as integer),
      e.id_editeur,
      e.nomediteur,
      c.id_collection,
      c.nomcollection
    from
      liste_tomes(:withintegrale, :in_idserie) a
      /* pas de left join: on cherche les manquants pour compléter les séries */
      inner join series s on
        a.id_serie = s.id_serie
      left join editeurs e on
        s.id_editeur = e.id_editeur
      left join collections c on
        s.id_collection = c.id_collection
    where
      s.suivremanquants = 1
    group by
      s.id_serie, s.titreserie, e.nomediteur, c.nomcollection,
      e.id_editeur, c.id_collection, s.nb_albums
    order by
      s.titreserie, e.nomediteur, c.nomcollection
    into
      :id_serie,
      :nb_albums,
      :maxserie,
      :countserie,
      :sumachat,
      :id_editeur,
      :nomediteur,
      :id_collection,
      :nomcollection
  do begin
    if (withachat = 0) then
      countserie = :countserie - :sumachat;
    if (nb_albums is not null and nb_albums > 0 and nb_albums > maxserie) then
      maxserie = :nb_albums;
    if (countserie <> maxserie) then begin
      currenttome = 0;
      for
        select distinct
          titreserie,
          tome,
          achat
        from
          liste_tomes(:withintegrale, :id_serie) a
          inner join series s on
            a.id_serie = s.id_serie
        order by
          tome
        into
          :titreserie,
          :ownedtome,
          :achat
      do begin
        currenttome = currenttome + 1;
        while ((currenttome <> ownedtome) and (currenttome < maxserie)) do begin
          tome = currenttome;
          suspend;
          currenttome = currenttome + 1;
        end
        if ((withachat = 0) and (achat = 1)) then begin
          tome = ownedtome;
          suspend;
        end
      end
      currenttome = currenttome + 1;
      while (currenttome <= maxserie) do begin
        tome = currenttome;
        suspend;
        currenttome = currenttome + 1;
      end
    end
  end

  /* on ne peut pas utiliser un "union": le order by de la première requête
     est impératif */
  countserie = 0;
  achat = null;
  for
    select
      s.id_serie,
      s.titreserie,
      s.nb_albums,
      e.id_editeur,
      e.nomediteur,
      c.id_collection,
      c.nomcollection
    from
      series s
      left join editeurs e on
        s.id_editeur = e.id_editeur
      left join collections c on
        s.id_collection = c.id_collection
    where
      not exists (select 1 from liste_tomes(:withintegrale, s.id_serie))
      and s.suivremanquants = 1 and s.nb_albums is not null
      and (:in_idserie is null or id_serie = :in_idserie)
    into
      :id_serie,
      :titreserie,
      :nb_albums,
      :id_editeur,
      :nomediteur,
      :id_collection,
      :nomcollection
  do begin
    currenttome = 1;
    while (currenttome <= nb_albums) do begin
      tome = currenttome;
      suspend;
      currenttome = currenttome + 1;
    end
  end
end;

create or alter procedure annees_albums (
    filtre varchar(125))
returns (
    anneeparution smallint,
    countannee integer)
as
declare variable swhere varchar(133);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'and ' || filtre;

  for execute statement
     'select
             cast(-1 as smallint),
             count(id_album)
      from vw_liste_albums
      where anneeparution is null ' || swhere ||
     'group by anneeparution'
  into :anneeparution,
       :countannee
  do begin
    suspend;
  end

  for execute statement
     'select
             anneeparution,
             count(id_album)
      from vw_liste_albums
      where AnneeParution is not null ' || swhere ||
     'group by anneeparution'
  into :anneeparution,
       :countannee
  do begin
    suspend;
  end
end;

create or alter procedure calcul_annee_sortie (
    withachat smallint,
    in_idserie char(38),
    sommeponderee integer,
    comptealbum integer,
    maxtome integer,
    maxannee integer,
    maxmois integer)
returns (
    id_serie char(38),
    titreserie varchar(150),
    tome integer,
    anneeparution integer,
    moisparution integer,
    id_editeur char(38),
    nomediteur varchar(50),
    id_collection char(38),
    nomcollection varchar(50))
as
declare variable maxtome2 integer;
begin
  tome = maxtome + 1;

  select cast(max(tomefin) + 1 as integer) from albums
  where horsserie = 0 and integrale = 1 and id_serie = :in_idserie and (:withachat = 1 or achat = 0)
  into
    :maxtome2;

  if (maxtome2 > tome) then tome = maxtome2;

  select s.id_serie, s.titreserie, e.id_editeur, e.nomediteur, c.id_collection, c.nomcollection from
    series s left join editeurs e on e.id_editeur = s.id_editeur
             left join collections c on c.id_collection = s.id_collection
  where s.id_serie = :in_idserie
  into
    :id_serie,
    :titreserie,
    :id_editeur,
    :nomediteur,
    :id_collection,
    :nomcollection;

  if (maxmois is null) then begin
    anneeparution = maxannee + ((tome - maxtome) * ((sommeponderee / 12) / comptealbum));
    moisparution = null;
  end else begin
    moisparution = maxmois + ((tome - maxtome) * (sommeponderee / comptealbum));
    anneeparution = maxannee;
    while (moisparution > 12) do begin
      moisparution = moisparution - 12;
      anneeparution = anneeparution + 1;
    end
  end
  suspend;
end;

create or alter procedure collections_albums (
    filtre varchar(125))
returns (
    nomcollection varchar(50),
    countcollection integer,
    id_collection char(38))
as
declare variable swhere varchar(133);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'and ' || filtre;

  for execute statement
     'select
             cast(''-1'' as varchar(50)),
             count(id_album),
             null
      from vw_liste_collections_albums
      where id_collection is null ' || swhere ||
     'group by nomcollection, id_collection'
  into :nomcollection,
       :countcollection,
       :id_collection
  do begin
    suspend;
  end

  for execute statement
     'select
             nomcollection,
             count(id_album),
             id_collection
      from vw_liste_collections_albums
      where id_collection is not null ' || swhere ||
     'group by nomcollection, id_collection'
  into :nomcollection,
       :countcollection,
       :id_collection
  do begin
    suspend;
  end
end;

create or alter procedure collections_by_initiale (
    initiale char(1),
    filtre varchar(125))
returns (
    id_collection char(38),
    nomcollection varchar(50))
as
declare variable swhere varchar(133);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'and ' || filtre || ' ';
  for execute statement
     'select id_collection,
             nomcollection
      from collections
      where initialenomcollection = ''' || :initiale || ''' ' || swhere ||
      'order by nomcollection'
      into :id_collection,
           :nomcollection
  do
  begin
    suspend;
  end
end;

create or alter procedure deletefile (
    fichier varchar(255))
returns (
    result integer)
as
begin
  select udf_deletefile(:fichier) from rdb$database into :result;
  suspend;
end;

create or alter procedure directorycontent (
    chemin varchar(255),
    searchattr integer)
returns (
    searchrec integer,
    filename varchar(255),
    filesize integer,
    fileattr integer)
as
begin
  select udf_findfilefirst(:chemin, :searchattr) from rdb$database into :searchrec;
  if (searchrec < 0) then
    suspend;
  else while (searchrec > 0) do begin
    select
      cast(udf_extractfilename(:searchrec) as varchar(255)),
      udf_extractfilesize(:searchrec),
      udf_extractfileattr(:searchrec)
    from rdb$database
    into
      :filename,
      :filesize,
      :fileattr;
    select udf_findfilenext(:searchrec) from rdb$database into :searchrec;
    suspend;
  end
end;

create or alter procedure editeurs_achatalbums (
    filtre varchar(125))
returns (
    nomediteur varchar(50),
    countediteur integer,
    id_editeur char(38))
as
declare variable swhere varchar(133);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'and ' || filtre;

  for execute statement
     'select
             cast(''-1'' as varchar(50)),
             count(id_album),
             null
      from vw_liste_editeurs_achatalbums
      where id_editeur is null ' || swhere ||
     'group by nomediteur, id_editeur'
  into :nomediteur,
       :countediteur,
       :id_editeur
  do begin
    suspend;
  end

  for execute statement
     'select
             nomediteur,
             count(id_album),
             id_editeur
      from vw_liste_editeurs_achatalbums
      where id_editeur is not null ' || swhere ||
     'group by nomediteur, id_editeur'
  into :nomediteur,
       :countediteur,
       :id_editeur
  do begin
    suspend;
  end
end;

create or alter procedure editeurs_albums (
    filtre varchar(125))
returns (
    nomediteur varchar(50),
    countediteur integer,
    id_editeur char(38))
as
declare variable swhere varchar(133);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'and ' || filtre;

  for execute statement
     'select
             cast(''-1'' as varchar(50)),
             count(id_album),
             null
      from vw_liste_editeurs_albums
      where id_editeur is null ' || swhere ||
     'group by nomediteur, id_editeur'
  into :nomediteur,
       :countediteur,
       :id_editeur
  do begin
    suspend;
  end

  for execute statement
     'select
             nomediteur,
             count(id_album),
             id_editeur
      from vw_liste_editeurs_albums
      where id_editeur is not null ' || swhere ||
     'group by nomediteur, id_editeur'
  into :nomediteur,
       :countediteur,
       :id_editeur
  do begin
    suspend;
  end
end;

create or alter procedure editeurs_by_initiale (
    initiale char(1))
returns (
    id_editeur char(38),
    nomediteur varchar(50))
as
begin
  for select id_editeur,
             nomediteur
      from editeurs
      where initialenomediteur = :initiale
      order by nomediteur
      into :id_editeur,
           :nomediteur
  do
  begin
    suspend;
  end
end;

create or alter procedure emprunteurs_by_initiale (
    initiale char(1))
returns (
    id_emprunteur char(38),
    nomemprunteur varchar(150))
as
begin
  for select id_emprunteur,
             nomemprunteur
      from emprunteurs
      where initialenomemprunteur = :initiale
      order by nomemprunteur
      into :id_emprunteur,
           :nomemprunteur
  do
  begin
    suspend;
  end
end;

create or alter procedure genres_albums (
    filtre varchar(125))
returns (
    genre varchar(30),
    countgenre integer,
    id_genre char(38))
as
declare variable swhere varchar(132);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'and ' || filtre;

  for execute statement
     'select
             cast(''-1'' as varchar(30)),
             count(id_album),
             null
      from vw_liste_genres_albums
      where id_genre is null ' || swhere ||
     'group by genre, id_genre'
  into :genre,
       :countgenre,
       :id_genre
  do begin
    suspend;
  end

  for execute statement
     'select
             genre,
             count(id_album),
             id_genre
      from vw_liste_genres_albums
      where id_genre is not null ' || swhere ||
     'group by genre, id_genre'
  into :genre,
       :countgenre,
       :id_genre
  do begin
    suspend;
  end
end;

create or alter procedure genres_by_initiale (
    initiale char(1))
returns (
    id_genre char(38),
    genre varchar(30))
as
begin
  for select id_genre,
             genre
      from genres
      where initialegenre = :initiale
      order by genre
      into :id_genre,
           :genre
  do
  begin
    suspend;
  end
end;

create or alter procedure get_initiale (
    chaine varchar(150))
returns (
    initiale char(1))
as
begin
  initiale = upper(cast(substring(:chaine from 1 for 1) as char(1)));
  if (not (initiale between 'A' and 'Z' or initiale between '0' and '9')) then initiale = '#';
  suspend;
end;

create or alter procedure initiales_albums (
    filtre varchar(125))
returns (
    initialetitrealbum char(1),
    countinitiale integer)
as
declare variable swhere varchar(133);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'where ' || filtre;
  for execute statement
      'select coalesce(initialetitrealbum, initialetitreserie),
               count(id_album)
      from albums left join series on albums.id_serie = series.id_serie ' || swhere ||
      ' group by 1'
      into :initialetitrealbum,
           :countinitiale
  do
    suspend;
end;

create or alter procedure initiales_collections (
    filtre varchar(125))
returns (
    initialenomcollection char(1),
    countinitiale integer)
as
declare variable swhere varchar(133);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'where ' || filtre;
  for execute statement
      'select initialenomcollection,
               count(id_collection)
      from collections ' || swhere ||
      ' group by initialenomcollection'
      into :initialenomcollection,
           :countinitiale
  do
    suspend;
end;

create or alter procedure liste_tomes (
    withintegrale smallint,
    in_idserie char(38))
returns (
    id_serie char(38),
    tome smallint,
    integrale smallint,
    achat smallint)
as
declare variable tomedebut integer;
declare variable tomefin integer;
begin
  for
    select id_serie, tome, integrale, achat
    from albums
    where tome is not null and integrale = 0 and horsserie = 0
          and (:in_idserie is null or id_serie = :in_idserie)
    order by id_serie, tome
    into :id_serie, :tome, :integrale, :achat
    do
      suspend;

  if (withintegrale is null) then withintegrale = 1;
  if (withintegrale = 1) then
    for
      select id_serie, tomedebut, tomefin, integrale, achat
      from albums
      where tomedebut is not null and tomefin is not null and integrale = 1 and horsserie = 0
            and (:in_idserie is null or id_serie = :in_idserie)
      order by id_serie, tomedebut, tomefin
      into :id_serie, :tomedebut, :tomefin, :integrale, :achat
      do begin
        tome = tomedebut - 1;
        while (tome <> tomefin) do begin
          tome = tome + 1;
          suspend;
        end
      end
end;

create or alter procedure loadblobfromfile (
    chemin varchar(255),
    fichier varchar(255))
returns (
    blobcontent blob sub_type 0 segment size 80)
as
begin
  select udf_loadblobfromfile(:chemin, :fichier) from rdb$database into :blobcontent;
  suspend;
end;

create or alter procedure parabd_by_serie (
    in_id_serie char(38),
    filtre varchar(125))
returns (
    id_parabd char(38),
    titreparabd varchar(150),
    id_serie char(38),
    titreserie varchar(150),
    achat smallint,
    complet integer,
    scategorie varchar(50))
as
declare variable swhere varchar(130);
begin
  if (:in_id_serie = cast('' as char(38))) then swhere = 'id_serie is null ';
                           else swhere = 'id_serie = ''' || :in_id_serie || ''' ';
  if (filtre is not null and filtre <> '') then swhere = swhere || 'and ' || filtre || ' ';
  for execute statement
      'select id_parabd,
             titreparabd,
             id_parabd,
             titreserie,
             achat,
             complet,
             scategorie
      from vw_liste_parabd
      where ' || :swhere ||
      'order by titreparabd'
      into :id_parabd,
           :titreparabd,
           :id_serie,
           :titreserie,
           :achat,
           :complet,
           :scategorie
  do
  begin
    suspend;
  end
end;

create or alter procedure personnes_by_initiale (
    initiale char(1))
returns (
    id_personne char(38),
    nompersonne varchar(150))
as
begin
  for select id_personne,
             nompersonne
      from personnes
      where initialenompersonne = :initiale
      order by nompersonne
      into :id_personne,
           :nompersonne
  do
  begin
    suspend;
  end
end;

create or alter procedure previsions_sorties (
    withachat smallint,
    in_id_serie char(38))
returns (
    id_serie char(38),
    titreserie varchar(150),
    tome integer,
    anneeparution integer,
    moisparution integer,
    id_editeur char(38),
    nomediteur varchar(50),
    id_collection char(38),
    nomcollection varchar(50))
as
declare variable currentidserie char(38) character set none;
declare variable oldidserie char(38) character set none;
declare variable currenttome integer;
declare variable sommeponderee integer;
declare variable comptealbum integer;
declare variable currentannee integer;
declare variable currentmois integer;
declare variable tomeprecedent integer;
declare variable anneeprecedente integer;
declare variable moisprecedent integer;
declare variable diffmois integer;
begin
  if (withachat is null) then withachat = 1;
  oldidserie = null;
  tomeprecedent = -1;
  anneeprecedente = -1;
  moisprecedent = null;
  for select tome, anneeparution, moisparution, s.id_serie
      /* pas de left join: on calcul les prévisions de sorties des nouveautés des séries */
      from albums a inner join series s on s.id_serie = a.id_serie
      where s.suivresorties = 1
            and a.horsserie = 0 and a.integrale = 0 and a.anneeparution is not null
            and (:in_id_serie is null or s.id_serie = :in_id_serie)
            and (:withachat = 1 or achat = 0)
      order by s.id_serie, tome
      into :currenttome, :currentannee, :currentmois, :currentidserie
  do begin
    if (oldidserie is null or currentidserie <> oldidserie) then begin

      if (oldidserie is not null and comptealbum > 0) then begin
        select id_serie, titreserie,
               tome, anneeparution, moisparution,
               id_editeur, nomediteur,
               id_collection, nomcollection
        from calcul_annee_sortie(:withachat, :oldidserie, :sommeponderee, :comptealbum, :tomeprecedent, :anneeprecedente, :moisprecedent)
        into :id_serie, :titreserie,
             :tome, :anneeparution, :moisparution,
             :id_editeur, :nomediteur,
             :id_collection, :nomcollection;
        suspend;
      end

      oldidserie = currentidserie;
      sommeponderee = 0;
      comptealbum = 0;
      tomeprecedent = -1;
      anneeprecedente = -1;
      moisprecedent = -1;
    end
    if (tomeprecedent <> -1 and currenttome - tomeprecedent <> 0) then begin
      if (currentmois is null or moisprecedent is null) then
        diffmois = 0;
      else
        diffmois = currentmois - moisprecedent;
      /* non pondéré: sommeponderee = sommeponderee + (((CURRENTANNEE - ANNEEPRECEDENTE) * 12 + (COALESCE(CURRENTMOIS, 1) - COALESCE(MOISPRECEDENT, 1))) / (CURRENTTOME - TOMEPRECEDENT)); */
      sommeponderee = sommeponderee + (((currentannee - anneeprecedente) * 12 + diffmois) / (currenttome - tomeprecedent)) * currenttome;
      /* non pondéré: comptealbum = comptealbum + 1;*/
      comptealbum = comptealbum + currenttome;
    end
    tomeprecedent = currenttome;
    anneeprecedente = currentannee;
    moisprecedent = currentmois;
  end

  if (oldidserie is not null and comptealbum > 0) then begin
    select id_serie, titreserie,
           tome, anneeparution, moisparution,
           id_editeur, nomediteur,
           id_collection, nomcollection
    from calcul_annee_sortie(:withachat, :oldidserie, :sommeponderee, :comptealbum, :tomeprecedent, :anneeprecedente, :moisprecedent)
    into :id_serie, :titreserie,
         :tome, :anneeparution, :moisparution,
         :id_editeur, :nomediteur,
         :id_collection, :nomcollection;
    suspend;
  end
end;

create or alter procedure proc_ajoutmvt (
    id_edition char(38),
    id_emprunteur char(38),
    dateemprunt timestamp,
    pret smallint)
as
begin
  insert into statut ( dateemprunt,  id_emprunteur,  id_edition,  pretemprunt)
              values (:dateemprunt, :id_emprunteur, :id_edition, :pret);
  update editions set prete = :pret where id_edition = :id_edition;
end;

create or alter procedure proc_auteurs (
    album char(38),
    serie char(38),
    parabd char(38))
returns (
    id_personne char(38),
    nompersonne varchar(150),
    id_album char(38),
    id_serie char(38),
    id_parabd char(38),
    metier smallint)
as
begin
  if (album is not null) then
    for select p.id_personne,
               p.nompersonne,
               a.id_album,
               null,
               null,
               a.metier
        from personnes p inner join auteurs a on a.id_personne = p.id_personne
        where a.id_album = :album
        order by a.metier, p.nompersonne
        into :id_personne,
             :nompersonne,
             :id_album,
             :id_serie,
             :id_parabd,
             :metier
    do
      suspend;

  if (serie is not null) then
    for select p.id_personne,
               p.nompersonne,
               null,
               a.id_serie,
               null,
               a.metier
        from personnes p inner join auteurs_series a on a.id_personne = p.id_personne
        where a.id_serie = :serie
        order by a.metier, p.nompersonne
        into :id_personne,
             :nompersonne,
             :id_album,
             :id_serie,
             :id_parabd,
             :metier
    do
      suspend;

  if (parabd is not null) then
    for select p.id_personne,
               p.nompersonne,
               null,
               null,
               a.id_parabd,
               cast(null as smallint)
        from personnes p inner join auteurs_parabd a on a.id_personne = p.id_personne
        where a.id_parabd = :parabd
        order by p.nompersonne
        into :id_personne,
             :nompersonne,
             :id_album,
             :id_serie,
             :id_parabd,
             :metier
    do
      suspend;
end;

create or alter procedure proc_emprunts
returns (
    id_edition char(38),
    id_album char(38),
    titrealbum varchar(150),
    id_serie char(38),
    titreserie varchar(150),
    prete smallint,
    id_emprunteur char(38),
    nomemprunteur varchar(150),
    pretemprunt smallint,
    dateemprunt timestamp)
as
begin
  for select ed.id_edition,
             a.id_album,
             a.titrealbum,
             a.id_serie,
             a.titreserie,
             ed.prete,
             e.id_emprunteur,
             e.nomemprunteur,
             s.pretemprunt,
             s.dateemprunt
      from vw_liste_albums a
        inner join editions ed on a.id_album = ed.id_album
        inner join statut s on ed.id_edition = s.id_edition
        inner join emprunteurs e on e.id_emprunteur = s.id_emprunteur
      order by s.dateemprunt desc
      into :id_edition,
           :id_album,
           :titrealbum,
           :id_serie,
           :titreserie,
           :prete,
           :id_emprunteur,
           :nomemprunteur,
           :pretemprunt,
           :dateemprunt
  do
  begin
    suspend;
  end
end;

create or alter procedure saveblobtofile (
    chemin varchar(255),
    fichier varchar(255),
    blobcontent blob sub_type 0 segment size 80)
returns (
    result integer)
as
begin
  select udf_saveblobtofile(:chemin, :fichier, :blobcontent) from rdb$database into :result;
  suspend;
end;

create or alter procedure searchfilename (
    chemin varchar(255),
    old_filename varchar(255),
    reserve integer)
returns (
    new_filename varchar(255))
as
begin
  select udf_searchfilename(:chemin, :old_filename, :reserve) from rdb$database into :new_filename;
  suspend;
end;

create or alter procedure series_albums (
    filtre varchar(125))
returns (
    titreserie varchar(150),
    countserie integer,
    id_serie char(38))
as
declare variable swhere varchar(132);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'and ' || filtre;

  for execute statement
     'select
             cast(''-1'' as varchar(150)),
             id_serie,
             count(id_album)
      from vw_liste_albums
      where titreserie is null ' || swhere ||
    ' group by titreserie, id_serie'
  into :titreserie,
       :id_serie,
       :countserie
  do
    suspend;

  for execute statement
     'select
             titreserie,
             id_serie,
             count(id_album)
      from vw_liste_albums
      where titreserie is not null ' || swhere ||
    ' group by titreserie, id_serie'
  into :titreserie,
       :id_serie,
       :countserie
  do
    suspend;
end;

create or alter procedure series_by_initiale (
    initiale char(1))
returns (
    id_serie char(38),
    titreserie varchar(150),
    id_editeur char(38),
    nomediteur varchar(50),
    id_collection char(38),
    nomcollection varchar(50))
as
begin
  for select id_serie,
             titreserie,
             s.id_editeur,
             nomediteur,
             s.id_collection,
             nomcollection
      from series s left join editeurs e on s.id_editeur = e.id_editeur
                    left join collections c on s.id_collection = c.id_collection
      where initialetitreserie = :initiale
      order by titreserie, nomediteur, nomcollection
      into :id_serie,
           :titreserie,
           :id_editeur,
           :nomediteur,
           :id_collection,
           :nomcollection
  do
  begin
    suspend;
  end
end;

create or alter procedure series_parabd (
    filtre varchar(125))
returns (
    titreserie varchar(150),
    countserie integer,
    id_serie char(38))
as
declare variable swhere varchar(132);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then swhere = 'and ' || filtre;

  for execute statement
     'select
             cast(''-1'' as varchar(150)),
             id_serie,
             count(id_parabd)
      from vw_liste_parabd
      where titreserie is null ' || swhere ||
    ' group by titreserie, id_serie'
  into :titreserie,
       :id_serie,
       :countserie
  do
    suspend;

  for execute statement
     'select
             titreserie,
             id_serie,
             count(id_parabd)
      from vw_liste_parabd
      where titreserie is not null ' || swhere ||
    ' group by titreserie, id_serie'
  into :titreserie,
       :id_serie,
       :countserie
  do
    suspend;
end;


create or alter trigger albums_dv for albums
active before insert or update position 0
as
begin
  if (new.titrealbum is null) then begin
    new.soundextitrealbum = null;
    new.initialetitrealbum = null;
  end else
  if (inserting or old.titrealbum is null or new.titrealbum <> old.titrealbum) then begin
    new.soundextitrealbum = udf_soundex(new.titrealbum, 1);
    select initiale from get_initiale(new.titrealbum) into new.initialetitrealbum;
  end
end;

create or alter trigger collections_dv for collections
active before insert or update position 0
as
begin
  if (inserting or new.nomcollection <> old.nomcollection) then begin
    select initiale from get_initiale(new.nomcollection) into new.initialenomcollection;
  end
end;

create or alter trigger editeurs_dv for editeurs
active before insert or update position 0
as
begin
  if (inserting or new.nomediteur <> old.nomediteur) then begin
    select initiale from get_initiale(new.nomediteur) into new.initialenomediteur;
  end
end;

create or alter trigger emprunteurs_dv for emprunteurs
active before insert or update position 0
as
begin
  if (inserting or new.nomemprunteur <> old.nomemprunteur) then begin
    select initiale from get_initiale(new.nomemprunteur) into new.initialenomemprunteur;
  end
end;

create or alter trigger genres_dv for genres
active before insert or update position 0
as
begin
  if (inserting or new.genre <> old.genre) then begin
    select initiale from get_initiale(new.genre) into new.initialegenre;
  end
end;

create or alter trigger parabd_dv for parabd
active before insert or update position 0
as
begin
  if (new.titreparabd is null) then begin
    new.soundextitreparabd = null;
    new.initialetitreparabd = null;
  end else
  if (inserting or old.titreparabd is null or new.titreparabd <> old.titreparabd) then begin
    new.soundextitreparabd = udf_soundex(new.titreparabd, 1);
    select initiale from get_initiale(new.titreparabd) into new.initialetitreparabd;
  end
end;

create or alter trigger personnes_dv for personnes
active before insert or update position 0
as
begin
  if (inserting or new.nompersonne <> old.nompersonne) then begin
    select initiale from get_initiale(new.nompersonne) into new.initialenompersonne;
  end
end;

create or alter trigger series_dv for series
active before insert or update position 0
as
begin
  if (inserting or new.titreserie <> old.titreserie) then begin
    new.soundextitreserie = udf_soundex(new.titreserie, 1);
    select initiale from get_initiale(new.titreserie) into new.initialetitreserie;
  end
end;

create or alter trigger albums_idserie_biu for albums
active before insert or update position 0
as
declare variable serieexists integer;
begin
  if (new.id_serie is not null) then begin
    select count(*) from series where id_serie = new.id_serie into :serieexists;
    if ((serieexists is null) or (serieexists = 0)) then
      exception idserie_unknown;
  end
end;

create or alter trigger albums_logsup_ad0 for albums
active after delete position 0
as
begin
  insert into suppressions(tablename, fieldname, id) values ('ALBUMS', 'id_album', old.id_album);
end;

create or alter trigger albums_uniqid_biu0 for albums
active before insert or update position 0
as
begin
  if (new.id_album is null) then new.id_album = old.id_album;
  if (new.id_album is null) then new.id_album = udf_createguid();

  if (new.dc_albums is null) then new.dc_albums = old.dc_albums;

  new.dm_albums = cast('now' as timestamp);
  if (inserting or new.dc_albums is null) then new.dc_albums = new.dm_albums;
end;

create or alter trigger auteurs_logsup_ad0 for auteurs
active after delete position 0
as
begin
  insert into suppressions(tablename, fieldname, id) values ('AUTEURS', 'id_auteur', old.id_auteur);
end;

create or alter trigger auteurs_parabd_logsup_ad0 for auteurs_parabd
active after delete position 0
as
begin
  insert into suppressions(tablename, fieldname, id) values ('AUTEURS_PARABD', 'id_auteur_parabd', old.id_auteur_parabd);
end;

create or alter trigger auteurs_parabd_uniqid_biu0 for auteurs_parabd
active before insert or update position 0
as
begin
  if (new.id_auteur_parabd is null) then new.id_auteur_parabd = old.id_auteur_parabd;
  if (new.id_auteur_parabd is null) then new.id_auteur_parabd = udf_createguid();

  if (new.dc_auteurs_parabd is null) then new.dc_auteurs_parabd = old.dc_auteurs_parabd;

  new.dm_auteurs_parabd = cast('now' as timestamp);
  if (inserting or new.dc_auteurs_parabd is null) then new.dc_auteurs_parabd = new.dm_auteurs_parabd;
end;

create or alter trigger auteurs_series_logsup_ad0 for auteurs_series
active after delete position 0
as
begin
  insert into suppressions(tablename, fieldname, id) values ('AUTEURS_SERIES', 'id_auteur_series', old.id_auteur_series);
end;

create or alter trigger auteurs_series_uniqid_biu0 for auteurs_series
active before insert or update position 0
as
begin
  if (new.id_auteur_series is null) then new.id_auteur_series = old.id_auteur_series;
  if (new.id_auteur_series is null) then new.id_auteur_series = udf_createguid();

  if (new.dc_auteurs_series is null) then new.dc_auteurs_series = old.dc_auteurs_series;

  new.dm_auteurs_series = cast('now' as timestamp);
  if (inserting or new.dc_auteurs_series is null) then new.dc_auteurs_series = new.dm_auteurs_series;
end;

create or alter trigger auteurs_uniqid_biu0 for auteurs
active before insert or update position 0
as
begin
  if (new.id_auteur is null) then new.id_auteur = old.id_auteur;
  if (new.id_auteur is null) then new.id_auteur = udf_createguid();

  if (new.dc_auteurs is null) then new.dc_auteurs = old.dc_auteurs;

  new.dm_auteurs = cast('now' as timestamp);
  if (inserting or new.dc_auteurs is null) then new.dc_auteurs = new.dm_auteurs;
end;

create or alter trigger collections_editions_ref for collections
active after update or delete position 0
as
begin
  if (deleting) then update editions set id_collection = null where id_collection = old.id_collection;
  if (updating) then update editions set id_collection = new.id_collection, id_editeur = new.id_editeur where id_collection = old.id_collection;
end;

create or alter trigger collections_logsup_ad0 for collections
active after delete position 0
as
begin
  insert into suppressions(tablename, fieldname, id) values ('COLLECTIONS', 'id_collection', old.id_collection);
end;

create or alter trigger collections_serie_ref for collections
active after update or delete position 0
as
begin
  if (deleting) then update series set id_collection = null where id_collection = old.id_collection;
  if (updating) then update series set id_collection = new.id_collection, id_editeur = new.id_editeur where id_collection = old.id_collection;
end;

create or alter trigger collections_uniqid_biu0 for collections
active before insert or update position 0
as
begin
  if (new.id_collection is null) then new.id_collection = old.id_collection;
  if (new.id_collection is null) then new.id_collection = udf_createguid();

  if (new.dc_collections is null) then new.dc_collections = old.dc_collections;

  new.dm_collections = cast('now' as timestamp);
  if (inserting or new.dc_collections is null) then new.dc_collections = new.dm_collections;
end;

create or alter trigger conversions_logsup_ad0 for conversions
active after delete position 0
as
begin
  insert into suppressions(tablename, fieldname, id) values ('CONVERSIONS', 'id_conversion', old.id_conversion);
end;

create or alter trigger conversions_uniqid_biu0 for conversions
active before insert or update position 0
as
begin
  if (new.id_conversion is null) then new.id_conversion = old.id_conversion;
  if (new.id_conversion is null) then new.id_conversion = udf_createguid();

  if (new.dc_conversions is null) then new.dc_conversions = old.dc_conversions;

  new.dm_conversions = cast('now' as timestamp);
  if (inserting or new.dc_conversions is null) then new.dc_conversions = new.dm_conversions;
end;

create or alter trigger cotes_logsup_ad0 for cotes
active after delete position 0
as
begin
  insert into suppressions(tablename, fieldname, id) values ('COTES', 'id_cote', old.id_cote);
end;

create or alter trigger cotes_parabd_logsup_ad0 for cotes_parabd
active after delete position 0
as
begin
  insert into suppressions(tablename, fieldname, id) values ('COTES_PARABD', 'id_cote_parabd', old.id_cote_parabd);
end;

create or alter trigger cotes_parabd_uniqid_biu0 for cotes_parabd
active before insert or update position 0
as
begin
  if (new.id_cote_parabd is null) then new.id_cote_parabd = old.id_cote_parabd;
  if (new.id_cote_parabd is null) then new.id_cote_parabd = udf_createguid();

  if (new.dc_cotes_parabd is null) then new.dc_cotes_parabd = old.dc_cotes_parabd;

  new.dm_cotes_parabd = cast('now' as timestamp);
  if (inserting or new.dc_cotes_parabd is null) then new.dc_cotes_parabd = new.dm_cotes_parabd;
end;

create or alter trigger cotes_uniqid_biu0 for cotes
active before insert or update position 0
as
begin
  if (new.id_cote is null) then new.id_cote = old.id_cote;
  if (new.id_cote is null) then new.id_cote = udf_createguid();

  if (new.dc_cotes is null) then new.dc_cotes = old.dc_cotes;

  new.dm_cotes = cast('now' as timestamp);
  if (inserting or new.dc_cotes is null) then new.dc_cotes = new.dm_cotes;
end;

create or alter trigger couvertures_logsup_ad0 for couvertures
active after delete position 0
as
begin
  insert into suppressions(tablename, fieldname, id) values ('COUVERTURES', 'id_couverture', old.id_couverture);
end;

create or alter trigger couvertures_uniqid_biu0 for couvertures
active before insert or update position 0
as
begin
  if (new.id_couverture is null) then new.id_couverture = old.id_couverture;
  if (new.id_couverture is null) then new.id_couverture = udf_createguid();

  if (new.dc_couvertures is null) then new.dc_couvertures = old.dc_couvertures;

  new.dm_couvertures = cast('now' as timestamp);
  if (inserting or new.dc_couvertures is null) then new.dc_couvertures = new.dm_couvertures;
end;

create or alter trigger criteres_biu0 for criteres
active before insert or update position 0
as
begin
  if (new.id_critere is null) then new.id_critere = old.id_critere;
  if (new.id_critere is null) then new.id_critere = udf_createguid();

  if (new.dc_critere is null) then new.dc_critere = old.dc_critere;

  new.dm_critere = cast('now' as timestamp);
  if (inserting or new.dc_critere is null) then new.dc_critere = new.dm_critere;
end;

create or alter trigger criteres_logsup_ad0 for criteres
active after delete position 0
as
begin
  insert into suppressions(tablename, fieldname, id) values ('CRITERES', 'id_critere', old.id_critere);
end;

create or alter trigger editeurs_logsup_ad0 for editeurs
active after delete position 0
as
begin
  insert into suppressions(tablename, fieldname, id) values ('EDITEURS', 'id_editeur', old.id_editeur);
end;

create or alter trigger editeurs_serie_ref for editeurs
active after update or delete position 0
as
begin
  if (deleting) then update series set id_editeur = null where id_editeur = old.id_editeur;
  if (updating) then update series set id_editeur = new.id_editeur where id_editeur = old.id_editeur;
end;

create or alter trigger editeurs_uniqid_biu0 for editeurs
active before insert or update position 0
as
begin
  if (new.id_editeur is null) then new.id_editeur = old.id_editeur;
  if (new.id_editeur is null) then new.id_editeur = udf_createguid();

  if (new.dc_editeurs is null) then new.dc_editeurs = old.dc_editeurs;

  new.dm_editeurs = cast('now' as timestamp);
  if (inserting or new.dc_editeurs is null) then new.dc_editeurs = new.dm_editeurs;
end;

create or alter trigger editions_ad0 for editions
active after delete position 0
as
begin
  delete from couvertures where id_album is null and id_edition = old.id_edition;
  update couvertures set id_edition = null where id_edition = old.id_edition;

  update albums set nbeditions = nbeditions - 1 where id_album = old.id_album;
end;

create or alter trigger editions_ai0 for editions
active after insert position 0
as
begin
  update albums set nbeditions = nbeditions + 1 where id_album = new.id_album;
end;

create or alter trigger editions_au0 for editions
active after update position 0
as
begin
  if (new.id_edition <> old.id_edition) then begin
    update couvertures set id_edition = new.id_edition where id_edition = old.id_edition;
  end

  if (new.id_album <> old.id_album) then begin
    update albums set nbeditions = nbeditions - 1 where id_album = old.id_album;
    update albums set nbeditions = nbeditions + 1 where id_album = new.id_album;
  end
end;

create or alter trigger editions_bu0 for editions
active before update position 0
as
begin
  if (updating and new.prete <> old.prete) then new.stock = 1 - new.prete;
end;

create or alter trigger editions_cote_biu1 for editions
active after insert or update position 1
as
declare variable existprix integer;
begin
  if (new.anneecote is not null and new.prixcote is not null) then begin
    select count(prixcote) from cotes where id_edition = new.id_edition and anneecote = new.anneecote into :existprix;
    if (existprix = 0) then
      insert into cotes (id_edition, anneecote, prixcote) values (new.id_edition, new.anneecote, new.prixcote);
    else
      update cotes set prixcote = new.prixcote where id_edition = new.id_edition and anneecote = new.anneecote;
  end
end;

create or alter trigger editions_logsup_ad0 for editions
active after delete position 0
as
begin
  insert into suppressions(tablename, fieldname, id) values ('EDITIONS', 'id_edition', old.id_edition);
end;

create or alter trigger editions_uniqid_biu0 for editions
active before insert or update position 0
as
begin
  if (new.id_edition is null) then new.id_edition = old.id_edition;
  if (new.id_edition is null) then new.id_edition = udf_createguid();

  if (new.dc_editions is null) then new.dc_editions = old.dc_editions;

  new.dm_editions = cast('now' as timestamp);
  if (inserting or new.dc_editions is null) then new.dc_editions = new.dm_editions;
end;

create or alter trigger emprunteurs_logsup_ad0 for emprunteurs
active after delete position 0
as
begin
  insert into suppressions(tablename, fieldname, id) values ('EMPRUNTEURS', 'id_emprunteur', old.id_emprunteur);
end;

create or alter trigger emprunteurs_uniqid_biu0 for emprunteurs
active before insert or update position 0
as
begin
  if (new.id_emprunteur is null) then new.id_emprunteur = old.id_emprunteur;
  if (new.id_emprunteur is null) then new.id_emprunteur = udf_createguid();

  if (new.dc_emprunteurs is null) then new.dc_emprunteurs = old.dc_emprunteurs;

  new.dm_emprunteurs = cast('now' as timestamp);
  if (inserting or new.dc_emprunteurs is null) then new.dc_emprunteurs = new.dm_emprunteurs;
end;

create or alter trigger genreseries_logsup_ad0 for genreseries
active after delete position 0
as
begin
  insert into suppressions(tablename, fieldname, id) values ('GENRESERIES', 'id_genreseries', old.id_genreseries);
end;

create or alter trigger genreseries_uniqid_biu0 for genreseries
active before insert or update position 0
as
begin
  if (new.id_genreseries is null) then new.id_genreseries = old.id_genreseries;
  if (new.id_genreseries is null) then new.id_genreseries = udf_createguid();

  if (new.dc_genreseries is null) then new.dc_genreseries = old.dc_genreseries;

  new.dm_genreseries = cast('now' as timestamp);
  if (inserting or new.dc_genreseries is null) then new.dc_genreseries = new.dm_genreseries;
end;

create or alter trigger genres_logsup_ad0 for genres
active after delete position 0
as
begin
  insert into suppressions(tablename, fieldname, id) values ('GENRES', 'id_genre', old.id_genre);
end;

create or alter trigger genres_uniqid_biu0 for genres
active before insert or update position 0
as
begin
  if (new.id_genre is null) then new.id_genre = old.id_genre;
  if (new.id_genre is null) then new.id_genre = udf_createguid();

  if (new.dc_genres is null) then new.dc_genres = old.dc_genres;

  new.dm_genres = cast('now' as timestamp);
  if (inserting or new.dc_genres is null) then new.dc_genres = new.dm_genres;
end;

create or alter trigger listes_aud0 for listes
active after update or delete position 0
as
declare variable newvalue integer;
begin
  if (deleting) then newvalue = null;
                else newvalue = new.ref;

  if (old.categorie = 1) then begin
    update editions set etat = :newvalue where etat = old.ref;
    update series set etat = :newvalue where etat = old.ref;
  end
  if (old.categorie = 2) then begin
    update editions set reliure = :newvalue where reliure = old.ref;
    update series set reliure = :newvalue where reliure = old.ref;
  end
  if (old.categorie = 3) then begin
    update editions set typeedition = :newvalue where typeedition = old.ref;
    update series set typeedition = :newvalue where typeedition = old.ref;
  end
  if (old.categorie = 4) then begin
    update editions set orientation = :newvalue where orientation = old.ref;
    update series set orientation = :newvalue where orientation = old.ref;
  end
  if (old.categorie = 5) then begin
    update editions set formatedition = :newvalue where formatedition = old.ref;
    update series set formatedition = :newvalue where formatedition = old.ref;
  end
  if (old.categorie = 6) then update couvertures set categorieimage = :newvalue where categorieimage = old.ref;
  if (old.categorie = 7) then update parabd set categorieparabd = :newvalue where categorieparabd = old.ref;
  if (old.categorie = 8) then begin
    update editions set senslecture = :newvalue where senslecture = old.ref;
    update series set senslecture = :newvalue where senslecture = old.ref;
  end
end;

create or alter trigger listes_logsup_ad0 for listes
active after delete position 0
as
begin
  insert into suppressions(tablename, fieldname, id) values ('LISTES', 'id_liste', old.id_liste);
end;

create or alter trigger listes_uniqid_biu0 for listes
active before insert or update position 0
as
begin
  if (new.id_liste is null) then new.id_liste = old.id_liste;
  if (new.id_liste is null) then new.id_liste = udf_createguid();

  if (new.dc_listes is null) then new.dc_listes = old.dc_listes;

  new.dm_listes = cast('now' as timestamp);
  if (inserting or new.dc_listes is null) then new.dc_listes = new.dm_listes;
end;

create or alter trigger options_logsup_ad0 for options
active after delete position 0
as
begin
  insert into suppressions(tablename, fieldname, id) values ('OPTIONS', 'id_option', old.id_option);
end;

create or alter trigger options_uniqid_biu0 for options
active before insert or update position 0
as
begin
  if (new.id_option is null) then new.id_option = old.id_option;
  if (new.id_option is null) then new.id_option = udf_createguid();

  if (new.dc_options is null) then new.dc_options = old.dc_options;

  new.dm_options = cast('now' as timestamp);
  if (inserting or new.dc_options is null) then new.dc_options = new.dm_options;
end;

create or alter trigger parabd_cote_biu1 for parabd
active after insert or update position 1
as
declare variable existprix integer;
begin
  if (new.anneecote is not null and new.prixcote is not null) then begin
    select count(prixcote) from cotes_parabd where id_parabd = new.id_parabd and anneecote = new.anneecote into :existprix;
    if (existprix = 0) then
      insert into cotes_parabd (id_parabd, anneecote, prixcote) values (new.id_parabd, new.anneecote, new.prixcote);
    else
      update cotes_parabd set prixcote = new.prixcote where id_parabd = new.id_parabd and anneecote = new.anneecote;
  end
end;

create or alter trigger parabd_logsup_ad0 for parabd
active after delete position 0
as
begin
  insert into suppressions(tablename, fieldname, id) values ('PARABD', 'id_parabd', old.id_parabd);
end;

create or alter trigger parabd_uniqid_biu0 for parabd
active before insert or update position 0
as
begin
  if (new.id_parabd is null) then new.id_parabd = old.id_parabd;
  if (new.id_parabd is null) then new.id_parabd = udf_createguid();

  if (new.dc_parabd is null) then new.dc_parabd = old.dc_parabd;

  new.dm_parabd = cast('now' as timestamp);
  if (inserting or new.dc_parabd is null) then new.dc_parabd = new.dm_parabd;
end;

create or alter trigger personnes_logsup_ad0 for personnes
active after delete position 0
as
begin
  insert into suppressions(tablename, fieldname, id) values ('PERSONNES', 'id_personne', old.id_personne);
end;

create or alter trigger personnes_uniqid_biu0 for personnes
active before insert or update position 0
as
begin
  if (new.id_personne is null) then new.id_personne = old.id_personne;
  if (new.id_personne is null) then new.id_personne = udf_createguid();

  if (new.dc_personnes is null) then new.dc_personnes = old.dc_personnes;

  new.dm_personnes = cast('now' as timestamp);
  if (inserting or new.dc_personnes is null) then new.dc_personnes = new.dm_personnes;
end;

create or alter trigger series_ad0 for series
active after delete position 0
as
begin
  delete from albums where id_serie = old.id_serie;
  delete from parabd where id_serie = old.id_serie;
end;

create or alter trigger series_au0 for series
active after update position 0
as
begin
  if (new.id_serie <> old.id_serie) then begin
    update albums set id_serie = new.id_serie where id_serie = old.id_serie;
    update parabd set id_serie = new.id_serie where id_serie = old.id_serie;
  end
end;

create or alter trigger series_logsup_ad0 for series
active after delete position 0
as
begin
  insert into suppressions(tablename, fieldname, id) values ('SERIES', 'id_serie', old.id_serie);
end;

create or alter trigger series_uniqid_biu0 for series
active before insert or update position 0
as
begin
  if (new.id_serie is null) then new.id_serie = old.id_serie;
  if (new.id_serie is null) then new.id_serie = udf_createguid();

  if (new.dc_series is null) then new.dc_series = old.dc_series;

  new.dm_series = cast('now' as timestamp);
  if (inserting or new.dc_series is null) then new.dc_series = new.dm_series;
end;

create or alter trigger statut_logsup_ad0 for statut
active after delete position 0
as
begin
  insert into suppressions(tablename, fieldname, id) values ('STATUT', 'id_statut', old.id_statut);
end;

create or alter trigger statut_uniqid_biu0 for statut
active before insert or update position 0
as
begin
  if (new.id_statut is null) then new.id_statut = old.id_statut;
  if (new.id_statut is null) then new.id_statut = udf_createguid();

  if (new.dc_statut is null) then new.dc_statut = old.dc_statut;

  new.dm_statut = cast('now' as timestamp);
  if (inserting or new.dc_statut is null) then new.dc_statut = new.dm_statut;
end;

create or alter trigger suppressions_uniqid_biu0 for suppressions
active before insert or update position 0
as
begin
  if (new.id_suppression is null) then new.id_suppression = old.id_suppression;
  if (new.id_suppression is null) then new.id_suppression = udf_createguid();

  if (new.dc_suppressions is null) then new.dc_suppressions = old.dc_suppressions;

  new.dm_suppressions = cast('now' as timestamp);
  if (inserting or new.dc_suppressions is null) then new.dc_suppressions = new.dm_suppressions;
end;

drop domain t_critere;
drop domain t_nom2;

create index albums_idx3 on albums (titrealbum);
create index editeurs_idx1 on editeurs (nomediteur);
create index emprunteurs_idx2 on emprunteurs (nomemprunteur);
create index genres_idx2 on genres (genre);
create index parabd_idx4 on parabd (titreparabd);
create index personnes_idx1 on personnes (nompersonne);
create index series_idx5 on series (titreserie);
