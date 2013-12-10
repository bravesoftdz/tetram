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
begin
  suspend;
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
begin
  suspend;
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
begin
  suspend;
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
begin
  suspend;
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
begin
  suspend;
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
begin
  suspend;
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
begin
  suspend;
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
begin
  suspend;
end;

create or alter procedure albums_manquants (
    withintegrale smallint,
    withachat smallint,
    in_idserie char(38))
returns (
    id_serie char(38),
    countserie integer,
    titreserie varchar(150),
    uppertitreserie varchar(150),
    tome integer,
    id_editeur char(38),
    nomediteur varchar(50),
    id_collection char(38),
    nomcollection varchar(50),
    achat smallint)
as
begin
  suspend;
end;

create or alter procedure annees_albums (
    filtre varchar(125))
returns (
    anneeparution smallint,
    countannee integer)
as
begin
  suspend;
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
    uppertitreserie varchar(150),
    tome integer,
    anneeparution integer,
    moisparution integer,
    id_editeur char(38),
    nomediteur varchar(50),
    id_collection char(38),
    nomcollection varchar(50))
as
begin
  suspend;
end;

create or alter procedure collections_albums (
    filtre varchar(125))
returns (
    nomcollection varchar(50),
    countcollection integer,
    id_collection char(38))
as
begin
  suspend;
end;

create or alter procedure collections_by_initiale (
    initiale char(1),
    filtre varchar(125))
returns (
    id_collection char(38),
    nomcollection varchar(50))
as
begin
  suspend;
end;

create or alter procedure deletefile (
    fichier varchar(255))
returns (
    result integer)
as
begin
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
  suspend;
end;

create or alter procedure editeurs_achatalbums (
    filtre varchar(125))
returns (
    nomediteur varchar(50),
    countediteur integer,
    id_editeur char(38))
as
begin
  suspend;
end;

create or alter procedure editeurs_albums (
    filtre varchar(125))
returns (
    nomediteur varchar(50),
    countediteur integer,
    id_editeur char(38))
as
begin
  suspend;
end;

create or alter procedure editeurs_by_initiale (
    initiale char(1))
returns (
    id_editeur char(38),
    nomediteur varchar(50))
as
begin
  suspend;
end;

create or alter procedure emprunteurs_by_initiale (
    initiale char(1))
returns (
    id_emprunteur char(38),
    nomemprunteur varchar(150))
as
begin
  suspend;
end;

create or alter procedure genres_albums (
    filtre varchar(125))
returns (
    genre varchar(30),
    countgenre integer,
    id_genre char(38))
as
begin
  suspend;
end;

create or alter procedure genres_by_initiale (
    initiale char(1))
returns (
    id_genre char(38),
    genre varchar(30))
as
begin
  suspend;
end;

create or alter procedure get_initiale (
    chaine varchar(150))
returns (
    initiale char(1))
as
begin
  suspend;
end;

create or alter procedure initiales_albums (
    filtre varchar(125))
returns (
    initialetitrealbum char(1),
    countinitiale integer)
as
begin
  suspend;
end;

create or alter procedure initiales_collections (
    filtre varchar(125))
returns (
    initialenomcollection char(1),
    countinitiale integer)
as
begin
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
begin
  suspend;
end;

create or alter procedure loadblobfromfile (
    chemin varchar(255),
    fichier varchar(255))
returns (
    blobcontent blob sub_type 0 segment size 80)
as
begin
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
begin
  suspend;
end;

create or alter procedure personnes_by_initiale (
    initiale char(1))
returns (
    id_personne char(38),
    nompersonne varchar(150))
as
begin
  suspend;
end;

create or alter procedure previsions_sorties (
    withachat smallint,
    in_id_serie char(38))
returns (
    id_serie char(38),
    titreserie varchar(150),
    uppertitreserie varchar(150),
    tome integer,
    anneeparution integer,
    moisparution integer,
    id_editeur char(38),
    nomediteur varchar(50),
    id_collection char(38),
    nomcollection varchar(50))
as
begin
  suspend;
end;

create or alter procedure proc_ajoutmvt (
    id_edition char(38),
    id_emprunteur char(38),
    dateemprunt timestamp,
    pret smallint)
as
begin
  exit;
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
  suspend;
end;

create or alter procedure saveblobtofile (
    chemin varchar(255),
    fichier varchar(255),
    blobcontent blob sub_type 0 segment size 80)
returns (
    result integer)
as
begin
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
  suspend;
end;

create or alter procedure series_albums (
    filtre varchar(125))
returns (
    titreserie varchar(150),
    countserie integer,
    id_serie char(38))
as
begin
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
  suspend;
end;

create or alter procedure series_parabd (
    filtre varchar(125))
returns (
    titreserie varchar(150),
    countserie integer,
    id_serie char(38))
as
begin
  suspend;
end;

drop view vw_dernieres_modifs;
drop view vw_emprunts;
drop view vw_initiales_editeurs;
drop view vw_initiales_emprunteurs;
drop view vw_initiales_genres;
drop view vw_initiales_personnes;
drop view vw_initiales_series;
drop view vw_liste_collections_albums;
drop view vw_liste_editeurs_achatalbums;
drop view vw_liste_editeurs_albums;
drop view vw_liste_genres_albums;
drop view vw_liste_parabd;
drop view vw_prixunitaires;
drop view vw_prixalbums;
drop view vw_liste_albums;

drop trigger albums_dv;
drop trigger collections_dv;
drop trigger editeurs_dv;
drop trigger emprunteurs_dv;
drop trigger genres_dv;
drop trigger parabd_dv;
drop trigger personnes_dv;
drop trigger series_dv;
drop trigger albums_idserie_biu;
drop trigger albums_logsup_ad0;
drop trigger albums_uniqid_biu0;
drop trigger auteurs_logsup_ad0;
drop trigger auteurs_parabd_logsup_ad0;
drop trigger auteurs_parabd_uniqid_biu0;
drop trigger auteurs_series_logsup_ad0;
drop trigger auteurs_series_uniqid_biu0;
drop trigger auteurs_uniqid_biu0;
drop trigger collections_editions_ref;
drop trigger collections_logsup_ad0;
drop trigger collections_serie_ref;
drop trigger collections_uniqid_biu0;
drop trigger conversions_logsup_ad0;
drop trigger conversions_uniqid_biu0;
drop trigger cotes_logsup_ad0;
drop trigger cotes_parabd_logsup_ad0;
drop trigger cotes_parabd_uniqid_biu0;
drop trigger cotes_uniqid_biu0;
drop trigger couvertures_logsup_ad0;
drop trigger couvertures_uniqid_biu0;
drop trigger criteres_biu0;
drop trigger criteres_logsup_ad0;
drop trigger editeurs_logsup_ad0;
drop trigger editeurs_serie_ref;
drop trigger editeurs_uniqid_biu0;
drop trigger editions_ad0;
drop trigger editions_ai0;
drop trigger editions_au0;
drop trigger editions_bu0;
drop trigger editions_cote_biu1;
drop trigger editions_logsup_ad0;
drop trigger editions_uniqid_biu0;
drop trigger emprunteurs_logsup_ad0;
drop trigger emprunteurs_uniqid_biu0;
drop trigger entretient_logsup_ad0;
drop trigger entretient_uniqid_biu0;
drop trigger genreseries_logsup_ad0;
drop trigger genreseries_uniqid_biu0;
drop trigger genres_logsup_ad0;
drop trigger genres_uniqid_biu0;
drop trigger listes_aud0;
drop trigger listes_logsup_ad0;
drop trigger listes_uniqid_biu0;
drop trigger options_logsup_ad0;
drop trigger options_uniqid_biu0;
drop trigger parabd_cote_biu1;
drop trigger parabd_logsup_ad0;
drop trigger parabd_uniqid_biu0;
drop trigger personnes_logsup_ad0;
drop trigger personnes_uniqid_biu0;
drop trigger series_ad0;
drop trigger series_au0;
drop trigger series_logsup_ad0;
drop trigger series_uniqid_biu0;
drop trigger statut_logsup_ad0;
drop trigger statut_uniqid_biu0;
drop trigger suppressions_uniqid_biu0;

alter domain t_nom to t_nom2;
create domain t_nom varchar(150) character set iso8859_1 collate fr_fr_ci_ai;
create domain t_titre varchar(150) character set iso8859_1 collate fr_fr_ci_ai;
create domain t_description blob sub_type text character set iso8859_1 collate fr_fr_ci_ai;

drop table entretient;

drop index albums_idx3;
drop index editeurs_idx1;
drop index emprunteurs_idx2;
drop index genres_idx2;
drop index genres_idx1;
drop index parabd_idx4;
drop index personnes_idx1;
drop index series_idx5;
