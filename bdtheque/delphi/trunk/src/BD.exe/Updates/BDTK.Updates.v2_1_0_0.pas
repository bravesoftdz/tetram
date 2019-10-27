unit BDTK.Updates.v2_1_0_0;

interface

implementation

uses
  UIB, BDTK.Updates;

procedure MAJ2_1_0_0(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add('CREATE TABLE SUPPRESSIONS (');
  Query.Script.Add('    id_suppression T_GUID_NOTNULL,');
  Query.Script.Add('    TABLENAME VARCHAR(31),');
  Query.Script.Add('    FIELDNAME VARCHAR(31),');
  Query.Script.Add('    ID T_GUID_NOTNULL,');
  Query.Script.Add('    DC_SUPPRESSIONS T_TIMESTAMP_NOTNULL,');
  Query.Script.Add('    DM_SUPPRESSIONS T_TIMESTAMP_NOTNULL);');

  Query.Script.Add('CREATE trigger suppressions_UNIQID_BIU0 for suppressions');
  Query.Script.Add('active before insert or update position 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  if (new.id_suppression is null) then new.id_suppression = old.id_suppression;');
  Query.Script.Add('  if (new.id_suppression is null) then new.id_suppression = UDF_CREATEGUID();');
  Query.Script.Add('');
  Query.Script.Add('  if (new.dc_suppressions is null) then new.dc_suppressions = old.dc_suppressions;');
  Query.Script.Add('');
  Query.Script.Add('  new.dm_suppressions = cast(''now'' as timestamp);');
  Query.Script.Add('  if (inserting or new.dc_suppressions is null) then new.dc_suppressions = new.dm_suppressions;');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER ALBUMS_LOGSUP_AD0 FOR ALBUMS');
  Query.Script.Add('ACTIVE AFTER DELETE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''ALBUMS'', ''id_album'', old.id_album);');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER AUTEURS_LOGSUP_AD0 FOR AUTEURS');
  Query.Script.Add('ACTIVE AFTER DELETE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''AUTEURS'', ''id_auteur'', old.id_auteur);');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER AUTEURS_PARABD_LOGSUP_AD0 FOR AUTEURS_PARABD');
  Query.Script.Add('ACTIVE AFTER DELETE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''AUTEURS_PARABD'', ''id_auteur_parabd'', old.id_auteur_parabd);');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER AUTEURS_SERIES_LOGSUP_AD0 FOR AUTEURS_SERIES');
  Query.Script.Add('ACTIVE AFTER DELETE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''AUTEURS_SERIES'', ''id_auteur_series'', old.id_auteur_series);');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER COLLECTIONS_LOGSUP_AD0 FOR COLLECTIONS');
  Query.Script.Add('ACTIVE AFTER DELETE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''COLLECTIONS'', ''id_collection'', old.id_collection);');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER CONVERSIONS_LOGSUP_AD0 FOR CONVERSIONS');
  Query.Script.Add('ACTIVE AFTER DELETE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''CONVERSIONS'', ''id_conversion'', old.id_conversion);');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER COTES_LOGSUP_AD0 FOR COTES');
  Query.Script.Add('ACTIVE AFTER DELETE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''COTES'', ''id_cote'', old.id_cote);');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER COTES_PARABD_LOGSUP_AD0 FOR COTES_PARABD');
  Query.Script.Add('ACTIVE AFTER DELETE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''COTES_PARABD'', ''id_cote_parabd'', old.id_cote_parabd);');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER COUVERTURES_LOGSUP_AD0 FOR COUVERTURES');
  Query.Script.Add('ACTIVE AFTER DELETE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''COUVERTURES'', ''id_couverture'', old.id_couverture);');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER CRITERES_LOGSUP_AD0 FOR CRITERES');
  Query.Script.Add('ACTIVE AFTER DELETE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''CRITERES'', ''id_critere'', old.id_critere);');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER EDITEURS_LOGSUP_AD0 FOR EDITEURS');
  Query.Script.Add('ACTIVE AFTER DELETE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''EDITEURS'', ''id_editeur'', old.id_editeur);');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER EDITIONS_LOGSUP_AD0 FOR EDITIONS');
  Query.Script.Add('ACTIVE AFTER DELETE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''EDITIONS'', ''id_edition'', old.id_edition);');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER EMPRUNTEURS_LOGSUP_AD0 FOR EMPRUNTEURS');
  Query.Script.Add('ACTIVE AFTER DELETE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''EMPRUNTEURS'', ''id_emprunteur'', old.id_emprunteur);');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER ENTRETIENT_LOGSUP_AD0 FOR ENTRETIENT');
  Query.Script.Add('ACTIVE AFTER DELETE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''ENTRETIENT'', ''id_entretient'', old.id_entretient);');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER GENRES_LOGSUP_AD0 FOR GENRES');
  Query.Script.Add('ACTIVE AFTER DELETE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''GENRES'', ''id_genre'', old.id_genre);');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER GENRESERIES_LOGSUP_AD0 FOR GENRESERIES');
  Query.Script.Add('ACTIVE AFTER DELETE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''GENRESERIES'', ''id_genreseries'', old.id_genreseries);');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER LISTES_LOGSUP_AD0 FOR LISTES');
  Query.Script.Add('ACTIVE AFTER DELETE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''LISTES'', ''id_liste'', old.id_liste);');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER OPTIONS_LOGSUP_AD0 FOR OPTIONS');
  Query.Script.Add('ACTIVE AFTER DELETE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''OPTIONS'', ''id_option'', old.id_option);');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER PARABD_LOGSUP_AD0 FOR PARABD');
  Query.Script.Add('ACTIVE AFTER DELETE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''PARABD'', ''id_parabd'', old.id_parabd);');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER PERSONNES_LOGSUP_AD0 FOR PERSONNES');
  Query.Script.Add('ACTIVE AFTER DELETE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''PERSONNES'', ''id_personne'', old.id_personne);');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER SERIES_LOGSUP_AD0 FOR SERIES');
  Query.Script.Add('ACTIVE AFTER DELETE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''SERIES'', ''id_serie'', old.id_serie);');
  Query.Script.Add('end;');

  Query.Script.Add('CREATE TRIGGER STATUT_LOGSUP_AD0 FOR STATUT');
  Query.Script.Add('ACTIVE AFTER DELETE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  insert into suppressions(tablename, fieldname, id) values (''STATUT'', ''id_statut'', old.id_statut);');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER PROCEDURE ALBUMS_BY_GENRE (');
  Query.Script.Add('    id_genre char(38),');
  Query.Script.Add('    filtre varchar(125))');
  Query.Script.Add('returns (');
  Query.Script.Add('    id_album char(38),');
  Query.Script.Add('    titrealbum varchar(150),');
  Query.Script.Add('    tome smallint,');
  Query.Script.Add('    tomedebut smallint,');
  Query.Script.Add('    tomefin smallint,');
  Query.Script.Add('    horsserie smallint,');
  Query.Script.Add('    integrale smallint,');
  Query.Script.Add('    moisparution smallint,');
  Query.Script.Add('    anneeparution smallint,');
  Query.Script.Add('    id_serie char(38),');
  Query.Script.Add('    titreserie varchar(150),');
  Query.Script.Add('    achat smallint,');
  Query.Script.Add('    complet integer)');
  Query.Script.Add('as');
  Query.Script.Add('declare variable swhere varchar(200);');
  Query.Script.Add('begin');
  Query.Script.Add('  if (:id_genre = cast('''' as char(38))) then swhere = ''g.id_Genre is null '';');
  Query.Script.Add('                      else swhere = ''g.id_genre = '''''' || :id_genre || '''''' '';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then swhere = swhere || ''and '' || filtre || '' '';');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('      ''select id_album,');
  Query.Script.Add('             titrealbum,');
  Query.Script.Add('             tome,');
  Query.Script.Add('             tomedebut,');
  Query.Script.Add('             tomefin,');
  Query.Script.Add('             horsserie,');
  Query.Script.Add('             integrale,');
  Query.Script.Add('             moisparution,');
  Query.Script.Add('             anneeparution,');
  Query.Script.Add('             a.id_serie,');
  Query.Script.Add('             titreserie,');
  Query.Script.Add('             achat,');
  Query.Script.Add('             complet');
  Query.Script.Add('       from vw_liste_albums a left join genreseries gs on gs.id_serie = a.id_serie');
  Query.Script.Add('                              left join genres g on gs.id_genre = g.id_genre');
  Query.Script.Add('       where '' || :swhere ||');
  Query.Script.Add
    ('      ''order by coalesce(uppertitrealbum, uppertitreserie), uppertitreserie, horsserie nulls first, integrale nulls first, tome nulls first, tomedebut nulls first, tomefin nulls first, anneeparution nulls first, moisparution nulls first''');
  Query.Script.Add('       into :id_album,');
  Query.Script.Add('            :titrealbum,');
  Query.Script.Add('            :tome,');
  Query.Script.Add('            :tomedebut,');
  Query.Script.Add('            :tomefin,');
  Query.Script.Add('            :horsserie,');
  Query.Script.Add('            :integrale,');
  Query.Script.Add('            :moisparution,');
  Query.Script.Add('            :anneeparution,');
  Query.Script.Add('            :id_serie,');
  Query.Script.Add('            :titreserie,');
  Query.Script.Add('            :achat,');
  Query.Script.Add('            :complet');
  Query.Script.Add('      do');
  Query.Script.Add('      begin');
  Query.Script.Add('        suspend;');
  Query.Script.Add('      end');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER PROCEDURE ALBUMS_MANQUANTS (');
  Query.Script.Add('    withintegrale smallint,');
  Query.Script.Add('    withachat smallint,');
  Query.Script.Add('    in_idserie char(38))');
  Query.Script.Add('returns (');
  Query.Script.Add('    id_serie char(38),');
  Query.Script.Add('    countserie integer,');
  Query.Script.Add('    titreserie varchar(150),');
  Query.Script.Add('    uppertitreserie varchar(150),');
  Query.Script.Add('    tome integer,');
  Query.Script.Add('    id_editeur char(38),');
  Query.Script.Add('    nomediteur varchar(50),');
  Query.Script.Add('    id_collection char(38),');
  Query.Script.Add('    nomcollection varchar(50),');
  Query.Script.Add('    achat smallint)');
  Query.Script.Add('as');
  Query.Script.Add('declare variable maxserie integer;');
  Query.Script.Add('declare variable nb_albums integer;');
  Query.Script.Add('declare variable currenttome integer;');
  Query.Script.Add('declare variable ownedtome integer;');
  Query.Script.Add('declare variable sumachat integer;');
  Query.Script.Add('begin');
  Query.Script.Add('  if (withintegrale is null) then withintegrale = 1;');
  Query.Script.Add('  if (withachat is null) then withachat = 1;');
  Query.Script.Add('  for');
  Query.Script.Add('    select');
  Query.Script.Add('      s.id_serie,');
  Query.Script.Add('      s.nb_albums,');
  Query.Script.Add('      max(a.tome),');
  Query.Script.Add('      count(distinct a.tome),');
  Query.Script.Add('      cast(sum(a.achat) as integer),');
  Query.Script.Add('      e.id_editeur,');
  Query.Script.Add('      e.nomediteur,');
  Query.Script.Add('      c.id_collection,');
  Query.Script.Add('      c.nomcollection');
  Query.Script.Add('    from');
  Query.Script.Add('      liste_tomes(:withintegrale, :in_idserie) a');
  Query.Script.Add('      /* pas de left join: on cherche les manquants pour compl�ter les s�ries */');
  Query.Script.Add('      inner join series s on');
  Query.Script.Add('        a.id_serie = s.id_serie');
  Query.Script.Add('      left join editeurs e on');
  Query.Script.Add('        s.id_editeur = e.id_editeur');
  Query.Script.Add('      left join collections c on');
  Query.Script.Add('        s.id_collection = c.id_collection');
  Query.Script.Add('    where');
  Query.Script.Add('      s.suivremanquants = 1');
  Query.Script.Add('    group by');
  Query.Script.Add('      s.id_serie, s.uppertitreserie, e.uppernomediteur, c.uppernomcollection,');
  Query.Script.Add('      e.id_editeur, e.nomediteur, c.id_collection, c.nomcollection, s.nb_albums');
  Query.Script.Add('    order by');
  Query.Script.Add('      s.uppertitreserie, e.uppernomediteur, c.uppernomcollection');
  Query.Script.Add('    into');
  Query.Script.Add('      :id_serie,');
  Query.Script.Add('      :nb_albums,');
  Query.Script.Add('      :maxserie,');
  Query.Script.Add('      :countserie,');
  Query.Script.Add('      :sumachat,');
  Query.Script.Add('      :id_editeur,');
  Query.Script.Add('      :nomediteur,');
  Query.Script.Add('      :id_collection,');
  Query.Script.Add('      :nomcollection');
  Query.Script.Add('  do begin');
  Query.Script.Add('    if (withachat = 0) then');
  Query.Script.Add('      countserie = :countserie - :sumachat;');
  Query.Script.Add('    if (nb_albums is not null and nb_albums > 0 and nb_albums > maxserie) then');
  Query.Script.Add('      maxserie = :nb_albums;');
  Query.Script.Add('    if (countserie <> maxserie) then begin');
  Query.Script.Add('      currenttome = 0;');
  Query.Script.Add('      for');
  Query.Script.Add('        select distinct');
  Query.Script.Add('          uppertitreserie,');
  Query.Script.Add('          titreserie,');
  Query.Script.Add('          tome,');
  Query.Script.Add('          achat');
  Query.Script.Add('        from');
  Query.Script.Add('          liste_tomes(:withintegrale, :id_serie) a');
  Query.Script.Add('          inner join series s on');
  Query.Script.Add('            a.id_serie = s.id_serie');
  Query.Script.Add('        order by');
  Query.Script.Add('          tome');
  Query.Script.Add('        into');
  Query.Script.Add('          :uppertitreserie,');
  Query.Script.Add('          :titreserie,');
  Query.Script.Add('          :ownedtome,');
  Query.Script.Add('          :achat');
  Query.Script.Add('      do begin');
  Query.Script.Add('        currenttome = currenttome + 1;');
  Query.Script.Add('        while ((currenttome <> ownedtome) and (currenttome < maxserie)) do begin');
  Query.Script.Add('          tome = currenttome;');
  Query.Script.Add('          suspend;');
  Query.Script.Add('          currenttome = currenttome + 1;');
  Query.Script.Add('        end');
  Query.Script.Add('        if ((withachat = 0) and (achat = 1)) then begin');
  Query.Script.Add('          tome = ownedtome;');
  Query.Script.Add('          suspend;');
  Query.Script.Add('        end');
  Query.Script.Add('      end');
  Query.Script.Add('      currenttome = currenttome + 1;');
  Query.Script.Add('      while (currenttome <= maxserie) do begin');
  Query.Script.Add('        tome = currenttome;');
  Query.Script.Add('        suspend;');
  Query.Script.Add('        currenttome = currenttome + 1;');
  Query.Script.Add('      end');
  Query.Script.Add('    end');
  Query.Script.Add('  end');
  Query.Script.Add('');
  Query.Script.Add('  /* on ne peut pas utiliser un "union": le order by de la premi�re requ�te');
  Query.Script.Add('     est imp�ratif */');
  Query.Script.Add('  countserie = 0;');
  Query.Script.Add('  achat = null;');
  Query.Script.Add('  for');
  Query.Script.Add('    select');
  Query.Script.Add('      s.id_serie,');
  Query.Script.Add('      s.titreserie,');
  Query.Script.Add('      s.uppertitreserie,');
  Query.Script.Add('      s.nb_albums,');
  Query.Script.Add('      e.id_editeur,');
  Query.Script.Add('      e.nomediteur,');
  Query.Script.Add('      c.id_collection,');
  Query.Script.Add('      c.nomcollection');
  Query.Script.Add('    from');
  Query.Script.Add('      series s');
  Query.Script.Add('      left join editeurs e on');
  Query.Script.Add('        s.id_editeur = e.id_editeur');
  Query.Script.Add('      left join collections c on');
  Query.Script.Add('        s.id_collection = c.id_collection');
  Query.Script.Add('    where');
  Query.Script.Add('      not exists (select 1 from liste_tomes(:withintegrale, s.id_serie))');
  Query.Script.Add('      and s.suivremanquants = 1 and s.nb_albums is not null');
  Query.Script.Add('      and (:in_idserie is null or id_serie = :in_idserie)');
  Query.Script.Add('    into');
  Query.Script.Add('      :id_serie,');
  Query.Script.Add('      :titreserie,');
  Query.Script.Add('      :uppertitreserie,');
  Query.Script.Add('      :nb_albums,');
  Query.Script.Add('      :id_editeur,');
  Query.Script.Add('      :nomediteur,');
  Query.Script.Add('      :id_collection,');
  Query.Script.Add('      :nomcollection');
  Query.Script.Add('  do begin');
  Query.Script.Add('    currenttome = 1;');
  Query.Script.Add('    while (currenttome <= nb_albums) do begin');
  Query.Script.Add('      tome = currenttome;');
  Query.Script.Add('      suspend;');
  Query.Script.Add('      currenttome = currenttome + 1;');
  Query.Script.Add('    end');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER PROCEDURE PREVISIONS_SORTIES (');
  Query.Script.Add('    withachat smallint,');
  Query.Script.Add('    in_id_serie char(38))');
  Query.Script.Add('returns (');
  Query.Script.Add('    id_serie char(38),');
  Query.Script.Add('    titreserie varchar(150),');
  Query.Script.Add('    uppertitreserie varchar(150),');
  Query.Script.Add('    tome integer,');
  Query.Script.Add('    anneeparution integer,');
  Query.Script.Add('    moisparution integer,');
  Query.Script.Add('    id_editeur char(38),');
  Query.Script.Add('    nomediteur varchar(50),');
  Query.Script.Add('    id_collection char(38),');
  Query.Script.Add('    nomcollection varchar(50))');
  Query.Script.Add('as');
  Query.Script.Add('declare variable currentidserie char(38) character set none;');
  Query.Script.Add('declare variable oldidserie char(38) character set none;');
  Query.Script.Add('declare variable currenttome integer;');
  Query.Script.Add('declare variable sommeponderee integer;');
  Query.Script.Add('declare variable comptealbum integer;');
  Query.Script.Add('declare variable currentannee integer;');
  Query.Script.Add('declare variable currentmois integer;');
  Query.Script.Add('declare variable tomeprecedent integer;');
  Query.Script.Add('declare variable anneeprecedente integer;');
  Query.Script.Add('declare variable moisprecedent integer;');
  Query.Script.Add('declare variable diffmois integer;');
  Query.Script.Add('begin');
  Query.Script.Add('  if (withachat is null) then withachat = 1;');
  Query.Script.Add('  oldidserie = null;');
  Query.Script.Add('  tomeprecedent = -1;');
  Query.Script.Add('  anneeprecedente = -1;');
  Query.Script.Add('  moisprecedent = null;');
  Query.Script.Add('  for select tome, anneeparution, moisparution, s.id_serie');
  Query.Script.Add('      /* pas de left join: on calcul les pr�visions de sorties des nouveaut�s des s�ries */');
  Query.Script.Add('      from albums a inner join series s on s.id_serie = a.id_serie');
  Query.Script.Add('      where s.suivresorties = 1');
  Query.Script.Add('            and a.horsserie = 0 and a.integrale = 0 and a.anneeparution is not null');
  Query.Script.Add('            and (:in_id_serie is null or s.id_serie = :in_id_serie)');
  Query.Script.Add('            and (:withachat = 1 or achat = 0)');
  Query.Script.Add('      order by s.id_serie, tome');
  Query.Script.Add('      into :currenttome, :currentannee, :currentmois, :currentidserie');
  Query.Script.Add('  do begin');
  Query.Script.Add('    if (oldidserie is null or currentidserie <> oldidserie) then begin');
  Query.Script.Add('');
  Query.Script.Add('      if (oldidserie is not null and comptealbum > 0) then begin');
  Query.Script.Add('        select id_serie, titreserie, uppertitreserie,');
  Query.Script.Add('               tome, anneeparution, moisparution,');
  Query.Script.Add('               id_editeur, nomediteur,');
  Query.Script.Add('               id_collection, nomcollection');
  Query.Script.Add('        from calcul_annee_sortie(:withachat, :oldidserie, :sommeponderee, :comptealbum, :tomeprecedent, :anneeprecedente, :moisprecedent)');
  Query.Script.Add('        into :id_serie, :titreserie, :uppertitreserie,');
  Query.Script.Add('             :tome, :anneeparution, :moisparution,');
  Query.Script.Add('             :id_editeur, :nomediteur,');
  Query.Script.Add('             :id_collection, :nomcollection;');
  Query.Script.Add('        suspend;');
  Query.Script.Add('      end');
  Query.Script.Add('');
  Query.Script.Add('      oldidserie = currentidserie;');
  Query.Script.Add('      sommeponderee = 0;');
  Query.Script.Add('      comptealbum = 0;');
  Query.Script.Add('      tomeprecedent = -1;');
  Query.Script.Add('      anneeprecedente = -1;');
  Query.Script.Add('      moisprecedent = -1;');
  Query.Script.Add('    end');
  Query.Script.Add('    if (tomeprecedent <> -1 and currenttome - tomeprecedent <> 0) then begin');
  Query.Script.Add('      if (currentmois is null or moisprecedent is null) then');
  Query.Script.Add('        diffmois = 0;');
  Query.Script.Add('      else');
  Query.Script.Add('        diffmois = currentmois - moisprecedent;');
  Query.Script.Add('      /* non pond�r�: sommeponderee = sommeponderee + (((CURRENTANNEE - ANNEEPRECEDENTE) * 12 + (COALESCE(CURRENTMOIS, 1) - COALESCE(MOISPRECEDENT, 1))) / (CURRENTTOME - TOMEPRECEDENT)); */');
  Query.Script.Add('      sommeponderee = sommeponderee + (((currentannee - anneeprecedente) * 12 + diffmois) / (currenttome - tomeprecedent)) * currenttome;');
  Query.Script.Add('      /* non pond�r�: comptealbum = comptealbum + 1;*/');
  Query.Script.Add('      comptealbum = comptealbum + currenttome;');
  Query.Script.Add('    end');
  Query.Script.Add('    tomeprecedent = currenttome;');
  Query.Script.Add('    anneeprecedente = currentannee;');
  Query.Script.Add('    moisprecedent = currentmois;');
  Query.Script.Add('  end');
  Query.Script.Add('');
  Query.Script.Add('  if (oldidserie is not null and comptealbum > 0) then begin');
  Query.Script.Add('    select id_serie, titreserie, uppertitreserie,');
  Query.Script.Add('           tome, anneeparution, moisparution,');
  Query.Script.Add('           id_editeur, nomediteur,');
  Query.Script.Add('           id_collection, nomcollection');
  Query.Script.Add('    from calcul_annee_sortie(:withachat, :oldidserie, :sommeponderee, :comptealbum, :tomeprecedent, :anneeprecedente, :moisprecedent)');
  Query.Script.Add('    into :id_serie, :titreserie, :uppertitreserie,');
  Query.Script.Add('         :tome, :anneeparution, :moisparution,');
  Query.Script.Add('         :id_editeur, :nomediteur,');
  Query.Script.Add('         :id_collection, :nomcollection;');
  Query.Script.Add('    suspend;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('2.1.0.0', @MAJ2_1_0_0);

end.
