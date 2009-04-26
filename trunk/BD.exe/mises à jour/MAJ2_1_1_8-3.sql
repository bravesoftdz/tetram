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
     'A', a.dc_albums, a.dm_albums, a.id_album, a.titrealbum, a.tome,
     a.tomedebut, a.tomefin, a.integrale, a.horsserie, s.titreserie,
     null , null , null
  from
    albums a
    left join series s on
      a.id_serie = s.id_serie

  union

  select
    'S', s.dc_series, s.dm_series, s.id_serie, null, null, null, null, null,
    null, s.titreserie, e.nomediteur, c.nomcollection, null
  from
    series s
    left join editeurs e on
      e.id_editeur = s.id_editeur
    left join collections c on
      c.id_collection = s.id_collection

  union

  select
    'P', p.dc_personnes, p.dm_personnes, p.id_personne, null, null, null, null,
    null, null, null, null, null, p.nompersonne
  from
    personnes p
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
      when a.tomedebut is null then 1
      when a.tomefin is null then 1
      when a.tomefin < a.tomedebut then 1
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
    horsserie, id_serie, id_editeur,
    avg(prix / nbalbums) as prixunitaire
  from vw_prixalbums
  where
    prix is not null
  group by
    id_serie,
    horsserie,
    id_editeur
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
  select
    a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie,
    a.integrale, a.moisparution, a.anneeparution, a.id_serie, s.titreserie,
    a.achat, a.complet, coalesce(a.initialetitrealbum, s.initialetitreserie),
    s.initialetitreserie
  from
    albums a
    left join series s on
      s.id_serie = a.id_serie
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
  select
    a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie,
    a.integrale, a.moisparution, a.anneeparution, a.id_serie, a.titreserie,
    g.id_genre, g.genre, a.achat, a.complet
  from
    vw_liste_albums a
    left join genreseries gs on
      gs.id_serie = a.id_serie
    left join genres g on
      gs.id_genre = g.id_genre
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
  select
    a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie,
    a.integrale, a.moisparution, a.anneeparution, a.id_serie, a.titreserie,
    e.id_editeur, e.nomediteur, a.achat, a.complet
  from
    vw_liste_albums a
    left join editions ed on
      ed.id_album = a.id_album
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
    id_serie,
    titreserie,
    id_editeur,
    nomediteur,
    achat,
    complet)
as
  select
    a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie,
    a.integrale, a.moisparution, a.anneeparution, a.id_serie, a.titreserie,
    e.id_editeur, e.nomediteur, a.achat, a.complet
  from
    vw_liste_albums a
    left join series s on
      s.id_serie = a.id_serie
    left join editeurs e on
      e.id_editeur = s.id_editeur
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
    id_editeur,
    nomediteur,
    id_collection,
    nomcollection,
    achat,
    complet)
as
  select
    a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie,
    a.integrale, a.moisparution, a.anneeparution, a.id_serie, a.titreserie,
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
  select
    s.id_statut, ed.id_edition,
    a.id_album, a.titrealbum, a.id_serie, a.tome, a.integrale, a.tomedebut,
    a.tomefin, a.horsserie, a.titreserie,
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
declare variable currentidserie t_guid;
declare variable oldidserie t_guid;
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
  for
    select
      tome, anneeparution, moisparution, s.id_serie
    from
      albums a
      /* pas de left join: on calcul les prévisions de sorties des nouveautés des séries */
      inner join series s on
        s.id_serie = a.id_serie
    where
      s.suivresorties = 1
      and a.horsserie = 0 and a.integrale = 0 and a.anneeparution is not null
      and (:in_id_serie is null or s.id_serie = :in_id_serie)
      and (:withachat = 1 or achat = 0)
    order by
      s.id_serie, tome
    into
      :currenttome, :currentannee, :currentmois, :currentidserie
  do
  begin
    if (oldidserie is null or currentidserie <> oldidserie) then
    begin

      if (oldidserie is not null and comptealbum > 0) then
      begin
        select
          id_serie, titreserie, tome, anneeparution, moisparution,
          id_editeur, nomediteur, id_collection, nomcollection
        from
          calcul_annee_sortie(
            :withachat, :oldidserie, :sommeponderee, :comptealbum,
            :tomeprecedent, :anneeprecedente, :moisprecedent
          )
        into
          :id_serie, :titreserie, :tome, :anneeparution, :moisparution,
          :id_editeur, :nomediteur, :id_collection, :nomcollection;

        suspend;
      end

      oldidserie = currentidserie;
      sommeponderee = 0;
      comptealbum = 0;
      tomeprecedent = -1;
      anneeprecedente = -1;
      moisprecedent = -1;
    end
    if (tomeprecedent <> -1 and currenttome - tomeprecedent <> 0) then
    begin
      if (currentmois is null or moisprecedent is null) then
        diffmois = 0;
      else
        diffmois = currentmois - moisprecedent;
      /* non pondéré: sommeponderee = sommeponderee + (((currentannee - anneeprecedente) * 12 + (coalesce(currentmois, 1) - coalesce(moisprecedent, 1))) / (currenttome - tomeprecedent)); */
      sommeponderee = sommeponderee + (((currentannee - anneeprecedente) * 12 + diffmois) / (currenttome - tomeprecedent)) * currenttome;
      /* non pondéré: comptealbum = comptealbum + 1;*/
      comptealbum = comptealbum + currenttome;
    end
    tomeprecedent = currenttome;
    anneeprecedente = currentannee;
    moisprecedent = currentmois;
  end

  if (oldidserie is not null and comptealbum > 0) then
  begin
    select
      id_serie, titreserie, tome, anneeparution, moisparution,
      id_editeur, nomediteur, id_collection, nomcollection
    from
      calcul_annee_sortie(
        :withachat, :oldidserie, :sommeponderee, :comptealbum, :tomeprecedent,
        :anneeprecedente, :moisprecedent
      )
    into
      :id_serie, :titreserie, :tome, :anneeparution, :moisparution,
      :id_editeur, :nomediteur, :id_collection, :nomcollection;

    suspend;
  end
end;

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
declare variable maxtome2 integer;
begin
  tome = maxtome + 1;

  select
    cast(max(tomefin) + 1 as integer)
  from
    albums
  where
    horsserie = 0 and integrale = 1
    and id_serie = :in_idserie and (:withachat = 1 or achat = 0)
  into
    :maxtome2;

  if (maxtome2 > tome) then tome = maxtome2;

  select
    s.id_serie, s.titreserie,
    e.id_editeur, e.nomediteur,
    c.id_collection, c.nomcollection
  from
    series s
    left join editeurs e on
      e.id_editeur = s.id_editeur
    left join collections c on
      c.id_collection = s.id_collection
  where
    s.id_serie = :in_idserie
  into
    :id_serie, :titreserie,
    :id_editeur, :nomediteur,
    :id_collection, :nomcollection;

  if (maxmois is null) then
  begin
    anneeparution = maxannee + ((tome - maxtome) * ((sommeponderee / 12) / comptealbum));
    moisparution = null;
  end
  else
  begin
    moisparution = maxmois + ((tome - maxtome) * (sommeponderee / comptealbum));
    anneeparution = maxannee;
    while (moisparution > 12) do
    begin
      moisparution = moisparution - 12;
      anneeparution = anneeparution + 1;
    end
  end

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
      s.id_serie, s.nb_albums, max(a.tome), count(distinct a.tome),
      cast(sum(a.achat) as integer),
      e.id_editeur, e.nomediteur, c.id_collection, c.nomcollection
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
      :id_serie, :nb_albums, :maxserie, :countserie,
      :sumachat,
      :id_editeur, :nomediteur, :id_collection, :nomcollection
  do
  begin
    if (withachat = 0) then
      countserie = :countserie - :sumachat;
    if (nb_albums is not null and nb_albums > 0 and nb_albums > maxserie) then
      maxserie = :nb_albums;
    if (countserie <> maxserie) then
    begin
      currenttome = 0;
      for
        select distinct
          titreserie, tome, achat
        from
          liste_tomes(:withintegrale, :id_serie) a
          inner join series s on
            a.id_serie = s.id_serie
        order by
          tome
        into
          :titreserie, :ownedtome, :achat
      do
      begin
        currenttome = currenttome + 1;
        while ((currenttome <> ownedtome) and (currenttome < maxserie)) do
        begin
          tome = currenttome;
          suspend;
          currenttome = currenttome + 1;
        end
        if ((withachat = 0) and (achat = 1)) then
        begin
          tome = ownedtome;
          suspend;
        end
      end
      currenttome = currenttome + 1;
      while (currenttome <= maxserie) do
      begin
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
      s.id_serie, s.titreserie, s.nb_albums,
      e.id_editeur, e.nomediteur, c.id_collection, c.nomcollection
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
      :id_serie, :titreserie, :nb_albums,
      :id_editeur, :nomediteur, :id_collection, :nomcollection
  do begin
    currenttome = 1;
    while (currenttome <= nb_albums) do
    begin
      tome = currenttome;
      suspend;
      currenttome = currenttome + 1;
    end
  end
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
declare variable tomedebut integer;
declare variable tomefin integer;
begin
  for
    select
      id_serie, tome, integrale, achat
    from
      albums
    where
      tome is not null and integrale = 0 and horsserie = 0
      and (:in_idserie is null or id_serie = :in_idserie)
    order by
      id_serie, tome
    into
      :id_serie, :tome, :integrale, :achat
    do
      suspend;

  if (withintegrale is null) then withintegrale = 1;
  if (withintegrale = 1) then
    for
      select
        id_serie, tomedebut, tomefin, integrale, achat
      from
        albums
      where
        tomedebut is not null and tomefin is not null
        and integrale = 1 and horsserie = 0
        and (:in_idserie is null or id_serie = :in_idserie)
      order by
        id_serie, tomedebut, tomefin
      into
        :id_serie, :tomedebut, :tomefin, :integrale, :achat
      do
      begin
        tome = tomedebut - 1;
        while (tome <> tomefin) do
        begin
          tome = tome + 1;
          suspend;
        end
      end
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

create view vw_liste_collections(
    id_collection,
    nomcollection,
    initialenomcollection,
    id_editeur,
    nomediteur)
as
  select
    c.id_collection,
    c.nomcollection,
    c.initialenomcollection,
    e.id_editeur,
    e.nomediteur
  from
    collections c
    inner join editeurs e on
      e.id_editeur = c.id_editeur
;

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
  for
    select
      id_serie, s.titreserie,
      s.id_editeur, e.nomediteur, s.id_collection, c.nomcollection
      from
        series s
        left join editeurs e on
          s.id_editeur = e.id_editeur
        left join collections c on
          s.id_collection = c.id_collection
      where
        s.initialetitreserie = :initiale
      order by
        s.titreserie, e.nomediteur, c.nomcollection
      into
        :id_serie, :titreserie,
        :id_editeur, :nomediteur, :id_collection, :nomcollection
  do
  begin
    suspend;
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

create view vw_initiales_editeurs(
    initialenomediteur,
    countinitiale)
as
  select
    initialenomediteur, count(id_editeur)
  from
    editeurs
  group by
    initialenomediteur
;

create or alter procedure editeurs_by_initiale (
    initiale t_initiale)
returns (
    id_editeur t_guid,
    nomediteur t_ident50)
as
begin
  for
    select
      id_editeur, nomediteur
    from
      editeurs
    where
      initialenomediteur = :initiale
    order by
      nomediteur
    into
      :id_editeur, :nomediteur
  do
  begin
    suspend;
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

create view vw_initiales_emprunteurs(
    initialenomemprunteur,
    countinitiale)
as
  select
    initialenomemprunteur, count(id_emprunteur)
  from
    emprunteurs
  group by
    initialenomemprunteur
;

create or alter procedure emprunteurs_by_initiale (
    initiale t_initiale)
returns (
    id_emprunteur t_guid,
    nomemprunteur t_nom)
as
begin
  for
    select
      id_emprunteur, nomemprunteur
    from
      emprunteurs
    where
      initialenomemprunteur = :initiale
    order by
      nomemprunteur
    into
      :id_emprunteur, :nomemprunteur
  do
  begin
    suspend;
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

create view vw_liste_parabd(
    id_parabd,
    titreparabd,
    id_serie,
    titreserie,
    achat,
    complet,
    scategorie)
as
  select
    p.id_parabd, p.titreparabd, p.id_serie, s.titreserie, p.achat, p.complet,
    lc.libelle
  from
    parabd p
    left join series s on
      s.id_serie = p.id_serie
    left join listes lc on
      lc.ref = p.categorieparabd and lc.categorie = 7
;

create or alter trigger parabd_dv for parabd
active before insert or update position 0
as
begin
  if (new.titreparabd is null) then 
  begin
    new.soundextitreparabd = null;
    new.initialetitreparabd = null;
  end else
  if (inserting or old.titreparabd is null or new.titreparabd <> old.titreparabd) then 
  begin
    new.soundextitreparabd = udf_soundex(new.titreparabd, 1);
    select initiale from get_initiale(new.titreparabd) into new.initialetitreparabd;
  end
end;

create view vw_initiales_personnes(
    initialenompersonne,
    countinitiale)
as
  select
    initialenompersonne, count(id_personne)
  from
    personnes
  group by
    initialenompersonne
;

create or alter procedure personnes_by_initiale (
    initiale t_initiale)
returns (
    id_personne t_guid,
    nompersonne t_nom)
as
begin
  for
    select
      id_personne, nompersonne
    from
      personnes
    where
      initialenompersonne = :initiale
    order by
      nompersonne
    into
      :id_personne, :nompersonne
  do
  begin
    suspend;
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
  if (album is not null) then
    for
      select
        p.id_personne, p.nompersonne,
        a.id_album, null, null, a.metier
      from
        personnes p
        inner join auteurs a on
          a.id_personne = p.id_personne
      where
        a.id_album = :album
      order by
        a.metier, p.nompersonne
      into
        :id_personne, :nompersonne,
        :id_album, :id_serie, :id_parabd, :metier
    do
      suspend;

  if (serie is not null) then
    for
      select
        p.id_personne, p.nompersonne,
        null, a.id_serie, null, a.metier
      from
        personnes p
        inner join auteurs_series a on
          a.id_personne = p.id_personne
      where
        a.id_serie = :serie
      order by
        a.metier, p.nompersonne
      into
        :id_personne, :nompersonne,
        :id_album, :id_serie, :id_parabd, :metier
    do
      suspend;

  if (parabd is not null) then
    for
      select
        p.id_personne, p.nompersonne,
        null, null, a.id_parabd, cast(null as smallint)
      from
        personnes p
        inner join auteurs_parabd a on
          a.id_personne = p.id_personne
      where
        a.id_parabd = :parabd
      order by
        p.nompersonne
      into
        :id_personne, :nompersonne,
        :id_album, :id_serie, :id_parabd, :metier
    do
      suspend;
end;

create view vw_initiales_series(
    initialetitreserie,
    countinitiale)
as
  select
    initialetitreserie, count(id_serie)
  from
    series
  group by
    initialetitreserie
;

create or alter trigger series_dv for series
active before insert or update position 0
as
begin
  if (inserting or new.titreserie <> old.titreserie) then begin
    new.soundextitreserie = udf_soundex(new.titreserie, 1);
    select initiale from get_initiale(new.titreserie) into new.initialetitreserie;
  end
end;

create view vw_initiales_genres(
    initialegenre,
    countinitiale)
as
  select
    initialegenre, count(id_genre)
  from
    genres
  group by
    initialegenre
;

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
    id_serie t_guid,
    titreserie t_titre,
    achat t_yesno,
    complet integer)
as
declare variable swhere varchar(133);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then 
    swhere = 'and ' || filtre || ' ';
  for execute statement
    'select
      a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie,
      a.integrale, a.moisparution, a.anneeparution, a.id_serie, s.titreserie,
      a.achat, a.complet
    from
      albums a
      left join series s on
        a.id_serie = s.id_serie
    where
      coalesce(s.id_editeur, -1) = ''' || :id_editeur || ''' ' || swhere || '
    order by
      coalesce(titrealbum, titreserie), titreserie, horsserie nulls first,
      integrale nulls first, tome nulls first, tomedebut nulls first,
      tomefin nulls first, anneeparution nulls first,
      moisparution nulls first'
    into
      :id_album, :titrealbum, :tome, :tomedebut, :tomefin, :horsserie,
      :integrale, :moisparution, :anneeparution, :id_serie, :titreserie,
      :achat, :complet
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
      integrale, moisparution, anneeparution, id_serie, titreserie,
      achat, complet
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
      :integrale, :moisparution, :anneeparution, :id_serie, :titreserie,
      :achat, :complet
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
      a.integrale, a.moisparution, a.anneeparution, a.id_serie, a.titreserie,
      au.metier, a.achat, a.complet
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
      :integrale, :moisparution, :anneeparution, :id_serie, :titreserie,
      :metier, :achat, :complet
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
      a.integrale, a.moisparution, a.anneeparution, a.id_serie, s.titreserie,
      a.achat, a.complet
    from
      albums a
      left join editions e on
        a.id_album = e.id_album
      left join series s on
        a.id_serie = s.id_serie
    where
      ' || :swhere || '
    order by
      coalesce(titrealbum, titreserie), titreserie, horsserie nulls first,
      integrale nulls first, tome nulls first, tomedebut nulls first,
      tomefin nulls first, anneeparution nulls first, moisparution nulls first'
    into
      :id_album, :titrealbum, :tome, :tomedebut, :tomefin, :horsserie,
      :integrale, :moisparution, :anneeparution, :id_serie, :titreserie,
      :achat, :complet
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
    id_serie t_guid,
    titreserie t_titre,
    achat t_yesno,
    complet integer)
as
declare variable swhere varchar(133);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then
    swhere = 'and ' || filtre || ' ';
  for execute statement
    'select
      a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie,
      a.integrale, a.moisparution, a.anneeparution, a.id_serie, s.titreserie,
      a.achat, a.complet
    from
      albums a
      left join editions e on
        a.id_album = e.id_album
      left join series s on
        a.id_serie = s.id_serie
    where
      coalesce(e.id_editeur, -1) = ''' || :id_editeur || ''' ' || swhere || '
    order by
      coalesce(titrealbum, titreserie), titreserie, horsserie nulls first,
      integrale nulls first, tome nulls first, tomedebut nulls first,
      tomefin nulls first, anneeparution nulls first, moisparution nulls first'
    into
      :id_album, :titrealbum, :tome, :tomedebut, :tomefin, :horsserie,
      :integrale, :moisparution, :anneeparution, :id_serie, :titreserie,
      :achat, :complet
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
      id_album, titrealbum, tome, tomedebut, tomefin, horsserie,
      integrale, moisparution, anneeparution, a.id_serie, titreserie,
      achat, complet
    from
      vw_liste_albums a
      left join genreseries gs on
        gs.id_serie = a.id_serie
      left join genres g on
        gs.id_genre = g.id_genre
    where ' || :swhere || '
    order by
      coalesce(titrealbum, titreserie), titreserie, horsserie nulls first,
      integrale nulls first, tome nulls first, tomedebut nulls first,
      tomefin nulls first, anneeparution nulls first, moisparution nulls first'
    into
      :id_album, :titrealbum, :tome, :tomedebut, :tomefin, :horsserie,
      :integrale, :moisparution, :anneeparution, :id_serie, :titreserie,
      :achat, :complet
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
      a.integrale, a.moisparution, a.anneeparution, a.id_serie, s.titreserie,
      a.achat, a.complet
    from
      albums a
      left join series s on
        s.id_serie = a.id_serie
    where
      coalesce(a.initialetitrealbum, s.initialetitreserie) = ''' ||: initiale || ''' ' || swhere || '
    order by
      coalesce(titrealbum, titreserie), titreserie, horsserie nulls first,
      integrale nulls first, tome nulls first, tomedebut nulls first,
      tomefin nulls first, anneeparution nulls first, moisparution nulls first'
    into
      :id_album, :titrealbum, :tome, :tomedebut, :tomefin, :horsserie,
      :integrale, :moisparution, :anneeparution, :id_serie, :titreserie,
      :achat, :complet
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
      integrale, moisparution, anneeparution, id_serie, titreserie,
      achat, complet
    from
      vw_liste_albums
    where
      ' || :swhere || '
    order by
      horsserie nulls first, integrale nulls first, tome nulls first,
      anneeparution nulls first, moisparution nulls first, titrealbum'
    into
      :id_album, :titrealbum, :tome, :tomedebut, :tomefin, :horsserie,
      :integrale, :moisparution, :anneeparution, :id_serie, :titreserie,
      :achat, :complet
  do
  begin
    suspend;
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
  if (filtre is not null and filtre <> '') then
    swhere = 'and ' || filtre;

  for execute statement
    'select
      cast(-1 as smallint), count(id_album)
    from
      vw_liste_albums
    where
      anneeparution is null ' || swhere || '
    group by
      anneeparution'
  into
    :anneeparution, :countannee
  do
    suspend;

  for execute statement
    'select
      anneeparution, count(id_album)
    from
      vw_liste_albums
    where
      anneeparution is not null ' || swhere || '
    group by
      anneeparution'
  into
    :anneeparution, :countannee
  do
    suspend;
end;

create or alter procedure collections_albums (
    filtre varchar(125))
returns (
    nomcollection t_ident50,
    countcollection integer,
    id_collection t_guid,
    nomediteur t_ident50,
    id_editeur t_guid)
as
declare variable swhere varchar(133);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then
    swhere = 'and ' || filtre;

  for execute statement
    'select
      cast(''-1'' as varchar(50)), count(id_album), null, null, null
    from
      vw_liste_collections_albums
    where
      id_collection is null ' || swhere || '
    group by
      nomcollection, id_collection'
    into
      :nomcollection, :countcollection, :id_collection, :nomediteur, :id_editeur
  do
    suspend;

  for execute statement
    'select
      nomcollection, count(id_album), id_collection, nomediteur, id_editeur
    from
      vw_liste_collections_albums
    where
      id_collection is not null ' || swhere || '
    group by
      nomcollection, id_collection, nomediteur, id_editeur'
    into
      :nomcollection, :countcollection, :id_collection, :nomediteur, :id_editeur
  do
    suspend;
end;

create or alter procedure collections_by_initiale (
    initiale t_initiale,
    filtre varchar(125))
returns (
    id_collection t_guid,
    nomcollection t_ident50,
    id_editeur t_guid,
    nomediteur t_ident50)
as
declare variable swhere varchar(133);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then
    swhere = 'and ' || filtre || ' ';
  for execute statement
    'select
      id_collection, nomcollection, id_editeur, nomediteur
    from
      vw_liste_collections
    where
      initialenomcollection = ''' || :initiale || ''' ' || swhere || '
    order by
      nomcollection'
    into
      :id_collection, :nomcollection, :id_editeur, :nomediteur
  do
    suspend;
end;

create or alter procedure editeurs_achatalbums (
    filtre varchar(125))
returns (
    nomediteur t_ident50,
    countediteur integer,
    id_editeur t_guid)
as
declare variable swhere varchar(133);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then
    swhere = 'and ' || filtre;

  for execute statement
    'select
      cast(''-1'' as varchar(50)), count(id_album), null
    from
      vw_liste_editeurs_achatalbums
    where
      id_editeur is null ' || swhere || '
    group by
      nomediteur, id_editeur'
    into
      :nomediteur, :countediteur, :id_editeur
  do
    suspend;

  for execute statement
    'select
      nomediteur, count(id_album), id_editeur
    from
      vw_liste_editeurs_achatalbums
    where
      id_editeur is not null ' || swhere || '
    group by
      nomediteur, id_editeur'
    into
      :nomediteur, :countediteur, :id_editeur
  do
    suspend;
end;

create or alter procedure editeurs_albums (
    filtre varchar(125))
returns (
    nomediteur t_ident50,
    countediteur integer,
    id_editeur t_guid)
as
declare variable swhere varchar(133);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then
    swhere = 'and ' || filtre;

  for execute statement
    'select
      cast(''-1'' as varchar(50)), count(id_album), null
    from
      vw_liste_editeurs_albums
    where
      id_editeur is null ' || swhere || '
    group by
      nomediteur, id_editeur'
    into
      :nomediteur, :countediteur, :id_editeur
  do
    suspend;

  for execute statement
    'select
      nomediteur, count(id_album), id_editeur
    from
      vw_liste_editeurs_albums
    where
      id_editeur is not null ' || swhere || '
    group by
      nomediteur, id_editeur'
    into
      :nomediteur, :countediteur, :id_editeur
  do
    suspend;
end;

create or alter procedure genres_albums (
    filtre varchar(125))
returns (
    genre varchar(30),
    countgenre integer,
    id_genre t_guid)
as
declare variable swhere varchar(132);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then
    swhere = 'and ' || filtre;

  for execute statement
    'select
      cast(''-1'' as varchar(30)), count(id_album), null
    from
      vw_liste_genres_albums
    where
      id_genre is null ' || swhere || '
    group by
      genre, id_genre'
    into
      :genre, :countgenre, :id_genre
  do
    suspend;

  for execute statement
    'select
      genre, count(id_album), id_genre
    from
      vw_liste_genres_albums
    where
      id_genre is not null ' || swhere || '
    group by
      genre, id_genre'
    into
      :genre, :countgenre, :id_genre
  do
    suspend;
end;

create or alter procedure genres_by_initiale (
    initiale t_initiale)
returns (
    id_genre t_guid,
    genre varchar(30))
as
begin
  for
    select
      id_genre, genre
    from
      genres
    where
      initialegenre = :initiale
    order by
      genre
    into
      :id_genre, :genre
  do
    suspend;
end;

create or alter procedure get_initiale (
    chaine varchar(150) character set iso8859_1)
returns (
    initiale t_initiale)
as
begin
  initiale = upper(cast(substring(:chaine from 1 for 1) as char(1)));
  if (not (initiale between 'A' and 'Z' or initiale between '0' and '9')) then
    initiale = '#';
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
  if (filtre is not null and filtre <> '') then
    swhere = 'where ' || filtre;
  for execute statement
    'select
      coalesce(initialetitrealbum, initialetitreserie), count(id_album)
    from
      albums
      left join series on
        albums.id_serie = series.id_serie ' || swhere || '
    group by
      1'
    into
      :initialetitrealbum, :countinitiale
  do
    suspend;
end;

create or alter procedure initiales_collections (
    filtre varchar(125))
returns (
    initialenomcollection t_initiale,
    countinitiale integer)
as
declare variable swhere varchar(133);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then
    swhere = 'where ' || filtre;
  for execute statement
    'select
      initialenomcollection, count(id_collection)
    from
      collections ' || swhere || '
    group by
      initialenomcollection'
    into
      :initialenomcollection, :countinitiale
  do
    suspend;
end;

create or alter procedure parabd_by_serie (
    in_id_serie t_guid,
    filtre varchar(125))
returns (
    id_parabd t_guid,
    titreparabd t_titre,
    id_serie t_guid,
    titreserie t_titre,
    achat t_yesno,
    complet integer,
    scategorie varchar(50))
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
      id_parabd, titreparabd, id_parabd, titreserie, achat, complet,
      scategorie
    from
      vw_liste_parabd
    where
      ' || :swhere || '
    order by
      titreparabd'
    into
      :id_parabd, :titreparabd, :id_serie, :titreserie, :achat, :complet,
      :scategorie
  do
    suspend;
end;

create or alter procedure proc_ajoutmvt (
    id_edition t_guid,
    id_emprunteur t_guid,
    dateemprunt timestamp,
    pret t_yesno)
as
begin
  insert into statut (
    dateemprunt, id_emprunteur, id_edition, pretemprunt
  ) values (
    :dateemprunt, :id_emprunteur, :id_edition, :pret
  );

  update editions set
    prete = :pret
  where
    id_edition = :id_edition;
end;

create or alter procedure series_albums (
    filtre varchar(125))
returns (
    titreserie t_titre,
    countserie integer,
    id_serie t_guid)
as
declare variable swhere varchar(132);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then
    swhere = 'and ' || filtre;

  for execute statement
    'select
      cast(''-1'' as varchar(150)), id_serie, count(id_album)
    from
      vw_liste_albums
    where
      titreserie is null ' || swhere || '
    group by
      titreserie, id_serie'
    into
      :titreserie, :id_serie, :countserie
  do
    suspend;

  for execute statement
    'select
      titreserie, id_serie, count(id_album)
    from
      vw_liste_albums
    where
      titreserie is not null ' || swhere || '
    group by
      titreserie, id_serie'
    into
      :titreserie, :id_serie, :countserie
  do
    suspend;
end;

create or alter procedure series_parabd (
    filtre varchar(125))
returns (
    titreserie t_titre,
    countserie integer,
    id_serie t_guid)
as
declare variable swhere varchar(132);
begin
  swhere = '';
  if (filtre is not null and filtre <> '') then
    swhere = 'and ' || filtre;

  for execute statement
    'select
      cast(''-1'' as varchar(150)), id_serie, count(id_parabd)
    from
      vw_liste_parabd
    where
      titreserie is null ' || swhere || '
    group by
      titreserie, id_serie'
    into
      :titreserie, :id_serie, :countserie
  do
    suspend;

  for execute statement
    'select
      titreserie, id_serie, count(id_parabd)
    from
      vw_liste_parabd
    where
      titreserie is not null ' || swhere || '
    group by
      titreserie, id_serie'
    into
      :titreserie, :id_serie, :countserie
  do
    suspend;
end;

create or alter trigger genres_ad0 for genres
active after delete position 0
as
begin
  delete from import_associations where id = old.id_genre and typedata = 5;
end;
