drop view vw_dernieres_modifs;
drop view vw_prixunitaires;
drop view vw_prixalbums;

create or alter procedure proc_emprunts
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

drop view vw_emprunts;
drop view vw_liste_collections_albums;
drop view vw_liste_editeurs_achatalbums;
drop view vw_liste_editeurs_albums;
drop view vw_liste_genres_albums;
drop view vw_liste_albums;

create or alter procedure calcul_annee_sortie (
    withachat t_yesno,
    in_idserie t_guid,
    sommeponderee integer,
    comptealbum integer,
    maxtome integer,
    maxannee integer,
    maxmois integer)
returns (
    id_serie t_guid,
    titreserie t_titre,
    tome integer,
    anneeparution integer,
    moisparution integer,
    id_editeur t_guid,
    nomediteur t_ident50,
    id_collection t_guid,
    nomcollection t_ident50)
as
begin
  suspend;
end;

create or alter procedure previsions_sorties (
    withachat t_yesno,
    in_id_serie t_guid)
returns (
    id_serie t_guid,
    titreserie t_titre,
    tome integer,
    anneeparution integer,
    moisparution integer,
    id_editeur t_guid,
    nomediteur t_ident50,
    id_collection t_guid,
    nomcollection t_ident50)
as
begin
  suspend;
end;

create or alter procedure liste_tomes (
    withintegrale t_yesno,
    in_idserie t_guid)
returns (
    id_serie t_guid,
    tome smallint,
    integrale t_yesno,
    achat t_yesno)
as
begin
  suspend;
end;

create or alter procedure albums_manquants (
    withintegrale type of t_yesno,
    withachat type of t_yesno,
    in_idserie type of t_guid)
returns (
    id_serie t_guid,
    countserie integer,
    titreserie t_titre,
    tome integer,
    id_editeur t_guid,
    nomediteur t_ident50,
    id_collection t_guid,
    nomcollection t_ident50,
    achat t_yesno)
as
begin
  suspend;
end;

create or alter trigger albums_dv for albums
active before insert or update position 0
as
begin
  exit;
end;

drop view vw_liste_collections;

create or alter procedure series_by_initiale (
    initiale t_initiale)
returns (
    id_serie t_guid,
    titreserie t_titre,
    id_editeur t_guid,
    nomediteur t_ident50,
    id_collection t_guid,
    nomcollection t_ident50)
as
begin
  suspend;
end;

create or alter trigger collections_dv for collections
active before insert or update position 0
as
begin
  exit;
end;

drop view vw_initiales_editeurs;

create or alter procedure editeurs_by_initiale (
    initiale t_initiale)
returns (
    id_editeur t_guid,
    nomediteur t_ident50)
as
begin
  suspend;
end;

create or alter trigger editeurs_dv for editeurs
active before insert or update position 0
as
begin
  exit;
end;

drop view vw_initiales_emprunteurs;

create or alter procedure emprunteurs_by_initiale (
    initiale t_initiale)
returns (
    id_emprunteur t_guid,
    nomemprunteur t_nom)
as
begin
  exit;
end;

create or alter trigger emprunteurs_dv for emprunteurs
active before insert or update position 0
as
begin
  exit;
end;

drop view vw_liste_parabd;

create or alter trigger parabd_dv for parabd
active before insert or update position 0
as
begin
  exit;
end;

drop view vw_initiales_personnes;

create or alter procedure personnes_by_initiale (
    initiale t_initiale)
returns (
    id_personne t_guid,
    nompersonne t_nom)
as
begin
  suspend;
end;

create or alter trigger personnes_dv for personnes
active before insert or update position 0
as
begin
  exit;
end;

create or alter procedure proc_auteurs (
    album t_guid,
    serie t_guid,
    parabd t_guid)
returns (
    id_personne t_guid,
    nompersonne t_nom,
    id_album t_guid,
    id_serie t_guid,
    id_parabd t_guid,
    metier smallint)
as
begin
  suspend;
end;

drop view vw_initiales_series;

create or alter trigger series_dv for series
active before insert or update position 0
as
begin
  exit;
end;

drop view vw_initiales_genres;