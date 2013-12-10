alter table albums add notation smallint;
alter table series add notation smallint;

insert into listes (id_liste, ref, categorie, ordre, defaut, libelle) values ('{A773AB5C-1605-4096-A3C3-18864F37E19C}', 0, 9, 1, 1, 'Pas noté');
insert into listes (id_liste, ref, categorie, ordre, defaut, libelle) values ('{E5A68997-3492-4E26-A026-9F3857B62322}', 1, 9, 2, 0, 'Très mauvais');
insert into listes (id_liste, ref, categorie, ordre, defaut, libelle) values ('{8CB56F5D-E08E-460E-B234-0AE67E279DF3}', 2, 9, 3, 0, 'Mauvais');
insert into listes (id_liste, ref, categorie, ordre, defaut, libelle) values ('{CA13548A-79FD-4212-8763-4AA67834B5B4}', 3, 9, 4, 0, 'Moyen');
insert into listes (id_liste, ref, categorie, ordre, defaut, libelle) values ('{99FE9442-96E4-4389-B6A0-30DFF4609A72}', 4, 9, 5, 0, 'Bien');
insert into listes (id_liste, ref, categorie, ordre, defaut, libelle) values ('{C1FFC725-83E3-4766-A1E7-AC3F9360C96E}', 5, 9, 6, 0, 'Très bien');

alter procedure proc_emprunts
returns (
    id_edition t_guid,
    id_album t_guid,
    titrealbum t_titre,
    id_serie t_guid,
    titreserie t_titre,
    prete t_yesno_baseno,
    id_emprunteur t_guid,
    nomemprunteur t_nom,
    pretemprunt t_yesno,
    dateemprunt timestamp)
as
begin
  suspend;
end;

drop view vw_liste_genres_albums;
drop view vw_liste_editeurs_albums;
drop view vw_liste_editeurs_achatalbums;
drop view vw_liste_collections_albums;
drop view vw_emprunts;
drop view vw_liste_albums;

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
    notation,
    initialetitrealbum,
    initialetitreserie)
as
select
    a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie,
    a.integrale, a.moisparution, a.anneeparution, a.id_serie, s.titreserie,
    a.achat, a.complet, a.notation,
    coalesce(a.initialetitrealbum, s.initialetitreserie), s.initialetitreserie
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
    notation,
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
select
    s.id_statut, ed.id_edition,
    a.id_album, a.titrealbum, a.id_serie, a.tome, a.integrale, a.tomedebut,
    a.tomefin, a.horsserie, a.notation, a.titreserie,
    e.id_editeur, e.nomediteur,
    c.id_collection, c.nomcollection,
    ed.prete, ed.anneeedition, ed.isbn,
    em.id_emprunteur, em.nomemprunteur,
    s.pretemprunt, s.dateemprunt
  from
    vw_liste_albums a
    inner join editions ed on
      a.id_album = ed.id_album
    inner join editeurs e on
      e.id_editeur = ed.id_editeur
    left join collections c on
      c.id_collection = ed.id_collection
    inner join statut s on
      ed.id_edition = s.id_edition
    inner join emprunteurs em on
      em.id_emprunteur = s.id_emprunteur
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
    notation,
    id_serie,
    titreserie,
    id_editeur,
    nomediteur,
    id_collection,
    nomcollection,
    achat,
    complet)
as
select
    a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie,
    a.integrale, a.moisparution, a.anneeparution, a.notation, a.id_serie,
    a.titreserie,
    e.id_editeur, e.nomediteur, c.id_collection, c.nomcollection, a.achat,
    a.complet
  from
    vw_liste_albums a
    left join editions ed on
      ed.id_album = a.id_album
    left join collections c on
      ed.id_collection = c.id_collection
    left join editeurs e on
      e.id_editeur = ed.id_editeur
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
    notation,
    id_serie,
    titreserie,
    id_editeur,
    nomediteur,
    achat,
    complet)
as
select
    a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie,
    a.integrale, a.moisparution, a.anneeparution, a.notation, a.id_serie,
    a.titreserie,
    e.id_editeur, e.nomediteur, a.achat, a.complet
  from
    vw_liste_albums a
    left join series s on
      s.id_serie = a.id_serie
    left join editeurs e on
      e.id_editeur = s.id_editeur
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
    notation,
    id_serie,
    titreserie,
    id_editeur,
    nomediteur,
    achat,
    complet)
as
select
    a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie,
    a.integrale, a.moisparution, a.anneeparution, a.notation, a.id_serie,
    a.titreserie,
    e.id_editeur, e.nomediteur, a.achat, a.complet
  from
    vw_liste_albums a
    left join editions ed on
      ed.id_album = a.id_album
    left join editeurs e on
      e.id_editeur = ed.id_editeur
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
    notation,
    id_serie,
    titreserie,
    id_genre,
    genre,
    achat,
    complet)
as
select
    a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie,
    a.integrale, a.moisparution, a.anneeparution, a.notation, a.id_serie,
    a.titreserie,
    g.id_genre, g.genre, a.achat, a.complet
  from
    vw_liste_albums a
    left join genreseries gs on
      gs.id_serie = a.id_serie
    left join genres g on
      gs.id_genre = g.id_genre
;

alter procedure proc_emprunts
returns (
    id_edition t_guid,
    id_album t_guid,
    titrealbum t_titre,
    id_serie t_guid,
    titreserie t_titre,
    prete t_yesno_baseno,
    id_emprunteur t_guid,
    nomemprunteur t_nom,
    pretemprunt t_yesno,
    dateemprunt timestamp)
as
begin
  for
    select
      ed.id_edition, a.id_album, a.titrealbum, a.id_serie, a.titreserie,
      ed.prete, e.id_emprunteur, e.nomemprunteur, s.pretemprunt,
      s.dateemprunt
    from
      vw_liste_albums a
      inner join editions ed on
        a.id_album = ed.id_album
      inner join statut s on
        ed.id_edition = s.id_edition
      inner join emprunteurs e on
        e.id_emprunteur = s.id_emprunteur
    order by
      s.dateemprunt desc
    into
      :id_edition, :id_album, :titrealbum, :id_serie, :titreserie,
      :prete, :id_emprunteur, :nomemprunteur, :pretemprunt,
      :dateemprunt
  do
  begin
    suspend;
  end
end;

create or alter procedure achatalbums_by_editeur (
    id_editeur t_guid,
    filtre varchar(125))
returns (
    id_album t_guid,
    titrealbum t_titre,
    tome smallint,
    tomedebut smallint,
    tomefin smallint,
    horsserie t_yesno,
    integrale t_yesno,
    moisparution smallint,
    anneeparution smallint,
    notation smallint,
    id_serie t_guid,
    titreserie t_titre,
    achat t_yesno,
    complet integer)
as
declare variable swhere varchar(133);
begin
  if (:id_editeur = cast('' as char(38))) then
    swhere = 's.id_editeur is null ';
  else
    swhere = 's.id_editeur = ''' || :id_editeur || ''' ';
  if (filtre is not null and filtre <> '') then
    swhere = swhere || 'and ' || filtre || ' ';
  for execute statement
    'select
      a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie,
      a.integrale, a.moisparution, a.anneeparution, a.notation, a.id_serie,
      s.titreserie, a.achat, a.complet
    from
      albums a
      left join series s on
        a.id_serie = s.id_serie
    where
      ' || :swhere || '
    order by
      coalesce(a.titrealbum, s.titreserie), s.titreserie,
      a.horsserie nulls first, a.integrale nulls first, a.tome nulls first,
      a.tomedebut nulls first, a.tomefin nulls first,
      a.anneeparution nulls first, a.moisparution nulls first'
    into
      :id_album, :titrealbum, :tome, :tomedebut, :tomefin, :horsserie,
      :integrale, :moisparution, :anneeparution, :notation, :id_serie,
      :titreserie, :achat, :complet
  do
  begin
    suspend;
  end
end;

create or alter procedure albums_by_annee (
    annee integer,
    filtre varchar(125))
returns (
    id_album t_guid,
    titrealbum t_titre,
    tome smallint,
    tomedebut smallint,
    tomefin smallint,
    horsserie t_yesno,
    integrale t_yesno,
    moisparution smallint,
    anneeparution smallint,
    notation smallint,
    id_serie t_guid,
    titreserie t_titre,
    achat t_yesno,
    complet integer)
as
declare variable swhere varchar(200);
begin
  if (:annee = -1) then swhere = 'anneeparution is null ';
                   else swhere = 'anneeparution = ' || :annee || ' ';
  if (filtre is not null and filtre <> '') then
    swhere = swhere || 'and ' || filtre || ' ';
  for execute statement
    'select
      id_album, titrealbum, tome, tomedebut, tomefin, horsserie,
      integrale, moisparution, anneeparution, notation, id_serie,
      titreserie, achat, complet
    from
      vw_liste_albums
    where
      ' || :swhere || '
    order by
      coalesce(titrealbum, titreserie), titreserie, horsserie nulls first,
      integrale nulls first, tome nulls first, tomedebut nulls first,
      tomefin nulls first, anneeparution nulls first, moisparution nulls first'
    into
      :id_album, :titrealbum, :tome, :tomedebut, :tomefin, :horsserie,
      :integrale, :moisparution, :anneeparution, :notation, :id_serie,
      :titreserie, :achat, :complet
  do
  begin
    suspend;
  end
end;

create or alter procedure albums_by_auteur (
    id_auteur t_guid,
    filtre varchar(125))
returns (
    id_album t_guid,
    titrealbum t_titre,
    tome smallint,
    tomedebut smallint,
    tomefin smallint,
    horsserie t_yesno,
    integrale t_yesno,
    moisparution smallint,
    anneeparution smallint,
    notation smallint,
    id_serie t_guid,
    titreserie t_titre,
    metier smallint,
    achat t_yesno,
    complet integer)
as
declare variable swhere varchar(200);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then
    swhere = 'and ' || filtre || ' ';
  for execute statement
    'select
      a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie,
      a.integrale, a.moisparution, a.anneeparution, a.notation, a.id_serie,
      a.titreserie, au.metier, a.achat, a.complet
    from
      vw_liste_albums a
      inner join auteurs au on
        a.id_album = au.id_album
    where
      au.id_personne = ''' || :id_auteur || ''' ' || swhere || '
    order by
      titreserie, horsserie nulls first, integrale nulls first,
      tome nulls first, anneeparution nulls first, moisparution nulls first,
      coalesce(titrealbum, titreserie), metier'
    into
      :id_album, :titrealbum, :tome, :tomedebut, :tomefin, :horsserie,
      :integrale, :moisparution, :anneeparution, :notation, :id_serie,
      :titreserie, :metier, :achat, :complet
  do
  begin
    suspend;
  end
end;

create or alter procedure albums_by_collection (
    id_collection t_guid,
    filtre varchar(125))
returns (
    id_album t_guid,
    titrealbum t_titre,
    tome smallint,
    tomedebut smallint,
    tomefin smallint,
    horsserie t_yesno,
    integrale t_yesno,
    moisparution smallint,
    anneeparution smallint,
    notation smallint,
    id_serie t_guid,
    titreserie t_titre,
    achat t_yesno,
    complet integer)
as
declare variable swhere varchar(200);
begin
  if (:id_collection = cast('' as char(38))) then
    swhere = 'e.id_collection is null ';
  else
    swhere = 'e.id_collection = ''' || :id_collection || ''' ';
  if (filtre is not null and filtre <> '') then
    swhere = swhere || 'and ' || filtre || ' ';
  for execute statement
    'select
      a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie,
      a.integrale, a.moisparution, a.anneeparution, a.notation, a.id_serie,
      s.titreserie, a.achat, a.complet
    from
      albums a
      left join editions e on
        a.id_album = e.id_album
      left join series s on
        a.id_serie = s.id_serie
    where
      ' || :swhere || '
    order by
      coalesce(a.titrealbum, s.titreserie), s.titreserie,
      a.horsserie nulls first, a.integrale nulls first, a.tome nulls first,
      a.tomedebut nulls first, a.tomefin nulls first,
      a.anneeparution nulls first, a.moisparution nulls first'
    into
      :id_album, :titrealbum, :tome, :tomedebut, :tomefin, :horsserie,
      :integrale, :moisparution, :anneeparution, :notation, :id_serie,
      :titreserie, :achat, :complet
  do
  begin
    suspend;
  end
end;

create or alter procedure albums_by_editeur (
    id_editeur t_guid,
    filtre varchar(125))
returns (
    id_album t_guid,
    titrealbum t_titre,
    tome smallint,
    tomedebut smallint,
    tomefin smallint,
    horsserie t_yesno,
    integrale t_yesno,
    moisparution smallint,
    anneeparution smallint,
    notation smallint,
    id_serie t_guid,
    titreserie t_titre,
    achat t_yesno,
    complet integer)
as
declare variable swhere varchar(133);
begin
  if (:id_editeur = cast('' as char(38))) then
    swhere = 'e.id_editeur is null ';
  else
    swhere = 'e.id_editeur = ''' || :id_editeur || ''' ';
  if (filtre is not null and filtre <> '') then
    swhere = swhere || 'and ' || filtre || ' ';
  for execute statement
    'select
      a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie,
      a.integrale, a.moisparution, a.anneeparution, a.notation, a.id_serie,
      s.titreserie, a.achat, a.complet
    from
      albums a
      left join editions e on
        a.id_album = e.id_album
      left join series s on
        a.id_serie = s.id_serie
    where
      ' || swhere || '
    order by
      coalesce(a.titrealbum, s.titreserie), s.titreserie,
      a.horsserie nulls first, a.integrale nulls first, a.tome nulls first,
      a.tomedebut nulls first, a.tomefin nulls first,
      a.anneeparution nulls first, a.moisparution nulls first'
    into
      :id_album, :titrealbum, :tome, :tomedebut, :tomefin, :horsserie,
      :integrale, :moisparution, :anneeparution, :notation, :id_serie,
      :titreserie, :achat, :complet
  do
  begin
    suspend;
  end
end;

create or alter procedure albums_by_genre (
    id_genre t_guid,
    filtre varchar(125))
returns (
    id_album t_guid,
    titrealbum t_titre,
    tome smallint,
    tomedebut smallint,
    tomefin smallint,
    horsserie t_yesno,
    integrale t_yesno,
    moisparution smallint,
    anneeparution smallint,
    notation smallint,
    id_serie t_guid,
    titreserie t_titre,
    achat t_yesno,
    complet integer)
as
declare variable swhere varchar(200);
begin
  if (:id_genre = cast('' as char(38))) then
    swhere = 'g.id_genre is null ';
  else
    swhere = 'g.id_genre = ''' || :id_genre || ''' ';
  if (filtre is not null and filtre <> '') then
    swhere = swhere || 'and ' || filtre || ' ';
  for execute statement
    'select
      a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie,
      a.integrale, a.moisparution, a.anneeparution, a.notation, a.id_serie,
      a.titreserie, a.achat, a.complet
    from
      vw_liste_albums a
      left join genreseries gs on
        gs.id_serie = a.id_serie
      left join genres g on
        gs.id_genre = g.id_genre
    where ' || :swhere || '
    order by
      coalesce(a.titrealbum, a.titreserie), a.titreserie,
      a.horsserie nulls first, a.integrale nulls first, a.tome nulls first,
      a.tomedebut nulls first, a.tomefin nulls first,
      a.anneeparution nulls first, a.moisparution nulls first'
    into
      :id_album, :titrealbum, :tome, :tomedebut, :tomefin, :horsserie,
      :integrale, :moisparution, :anneeparution, :notation, :id_serie,
      :titreserie, :achat, :complet
  do
  begin
    suspend;
  end
end;

create or alter procedure albums_by_initiale (
    initiale t_initiale,
    filtre varchar(125))
returns (
    id_album t_guid,
    titrealbum t_titre,
    tome smallint,
    tomedebut smallint,
    tomefin smallint,
    horsserie t_yesno,
    integrale t_yesno,
    moisparution smallint,
    anneeparution smallint,
    notation smallint,
    id_serie t_guid,
    titreserie t_titre,
    achat t_yesno,
    complet integer)
as
declare variable swhere varchar(133);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then
    swhere = ' and ' || filtre || ' ';
  for execute statement
    'select
      a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie,
      a.integrale, a.moisparution, a.anneeparution, a.notation, a.id_serie,
      s.titreserie, a.achat, a.complet
    from
      albums a
      left join series s on
        s.id_serie = a.id_serie
    where
      coalesce(a.initialetitrealbum, s.initialetitreserie) = ''' ||: initiale || ''' ' || swhere || '
    order by
      coalesce(a.titrealbum, s.titreserie), s.titreserie,
      a.horsserie nulls first, a.integrale nulls first, a.tome nulls first,
      a.tomedebut nulls first, a.tomefin nulls first,
      a.anneeparution nulls first, a.moisparution nulls first'
    into
      :id_album, :titrealbum, :tome, :tomedebut, :tomefin, :horsserie,
      :integrale, :moisparution, :anneeparution, :notation, :id_serie,
      :titreserie, :achat, :complet
  do
  begin
    suspend;
  end
end;

create or alter procedure albums_by_serie (
    in_id_serie t_guid,
    filtre varchar(125))
returns (
    id_album t_guid,
    titrealbum t_titre,
    tome smallint,
    tomedebut smallint,
    tomefin smallint,
    horsserie t_yesno,
    integrale t_yesno,
    moisparution smallint,
    anneeparution smallint,
    notation smallint,
    id_serie t_guid,
    titreserie t_titre,
    achat t_yesno,
    complet integer)
as
declare variable swhere varchar(130);
begin
  if (:in_id_serie = cast('' as char(38))) then
    swhere = 'id_serie is null ';
  else
    swhere = 'id_serie = ''' || :in_id_serie || ''' ';
  if (filtre is not null and filtre <> '') then
    swhere = swhere || 'and ' || filtre || ' ';
  for execute statement
    'select
      id_album, titrealbum, tome, tomedebut, tomefin, horsserie,
      integrale, moisparution, anneeparution, notation, id_serie,
      titreserie, achat, complet
    from
      vw_liste_albums
    where
      ' || :swhere || '
    order by
      horsserie nulls first, integrale nulls first, tome nulls first,
      anneeparution nulls first, moisparution nulls first, titrealbum'
    into
      :id_album, :titrealbum, :tome, :tomedebut, :tomefin, :horsserie,
      :integrale, :moisparution, :anneeparution, :notation, :id_serie,
      :titreserie, :achat, :complet
  do
  begin
    suspend;
  end
end;

