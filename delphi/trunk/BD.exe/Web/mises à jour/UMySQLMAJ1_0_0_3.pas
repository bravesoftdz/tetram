unit UMySQLMAJ1_0_0_3;

interface

uses Classes, Updates;

implementation

procedure MAJ1_0_0_3(Script: TStrings);
begin
  with Script do
  begin
    Clear;
    Add('CREATE TABLE IF NOT EXISTS /*DB_PREFIX*/univers (');
    Add('  id_univers char(38) NOT NULL,');
    Add('  nomunivers varchar(150) NOT NULL,');
    Add('  uppernomunivers varchar(150) default NULL,');
    Add('  id_univers_parent char(38),');
    Add('  id_univers_racine char(38),');
    Add('  description longtext,');
    Add('  siteweb varchar(255) default NULL,');
    Add('  initialenomunivers char(1) NOT NULL,');
    Add('  branche_univers varchar(2000) NOT NULL,');
    Add('  dc_univers timestamp,');
    Add('  dm_univers timestamp,');
    Add('  PRIMARY KEY  (id_univers),');
    Add('  KEY id_univers_parent (id_univers_parent),');
    Add('  KEY id_univers_racine (id_univers_racine),');
    Add('  FULLTEXT KEY uppernomunivers (uppernomunivers),');
    Add('  FULLTEXT KEY branche_univers (branche_univers)');
    Add(') DEFAULT CHARSET=utf8;');
    Add('@@');

    Add('CREATE TABLE IF NOT EXISTS /*DB_PREFIX*/series_univers (');
    Add('  id_serie_univers char(38) NOT NULL,');
    Add('  id_serie char(38) NOT NULL,');
    Add('  id_univers char(38) NOT NULL,');
    Add('  dc_series_univers timestamp,');
    Add('  dm_series_univers timestamp,');
    Add('  PRIMARY KEY  (id_serie,id_univers),');
    Add('  KEY id_serie_univers (id_serie_univers)');
    Add(') DEFAULT CHARSET=utf8;');
    Add('@@');

    Add('CREATE TABLE IF NOT EXISTS /*DB_PREFIX*/albums_univers (');
    Add('  id_album_univers char(38) NOT NULL,');
    Add('  id_album char(38) NOT NULL,');
    Add('  id_univers char(38) NOT NULL,');
    Add('  source_album smallint(6) default 0,');
    Add('  source_serie smallint(6) default 0,');
    Add('  dc_albums_univers timestamp,');
    Add('  dm_albums_univers timestamp,');
    Add('  PRIMARY KEY  (id_album,id_univers),');
    Add('  KEY id_album_univers (id_album_univers)');
    Add(') DEFAULT CHARSET=utf8;');
    Add('@@');

    Add('create view /*DB_PREFIX*/vw_liste_albums_univers(');
    Add('  id_album,');
    Add('  titrealbum,');
    Add('  tome,');
    Add('  tomedebut,');
    Add('  tomefin,');
    Add('  horsserie,');
    Add('  integrale,');
    Add('  moisparution,');
    Add('  anneeparution,');
    Add('  id_serie,');
    Add('  titreserie,');
    Add('  uppertitrealbum,');
    Add('  uppertitreserie,');
    Add('  achat,');
    Add('  complet,');
    Add('  initialetitrealbum,');
    Add('  initialetitreserie,');
    Add('  id_univers,');
    Add('  nomunivers,');
    Add('  id_univers_racine,');
    Add('  id_univers_parent,');
    Add('  branche_univers)');
    Add('as');
    Add('select');
    Add('  a.id_album,');
    Add('  a.titrealbum,');
    Add('  a.tome,');
    Add('  a.tomedebut,');
    Add('  a.tomefin,');
    Add('  a.horsserie,');
    Add('  a.integrale,');
    Add('  a.moisparution,');
    Add('  a.anneeparution,');
    Add('  a.id_serie,');
    Add('  s.titreserie,');
    Add('  a.uppertitrealbum,');
    Add('  s.uppertitreserie,');
    Add('  a.achat,');
    Add('  a.complet,');
    Add('  coalesce(a.initialetitrealbum, s.initialetitreserie),');
    Add('  s.initialetitreserie,');
    Add('  au.id_univers,');
    Add('  u.nomunivers,');
    Add('  u.id_univers_racine,');
    Add('  u.id_univers_parent,');
    Add('  u.branche_univers');
     Add('from');
    Add('  /*DB_PREFIX*/albums a');
    Add('  left join /*DB_PREFIX*/series s on');
    Add('    s.id_serie = a.id_serie');
    Add('  left join /*DB_PREFIX*/albums_univers au on');
    Add('    au.id_album = a.id_album');
    Add('  left join /*DB_PREFIX*/univers u on');
    Add('    u.id_univers = au.id_univers');
    Add(';');
    Add('@@');

  end;
end;

initialization

RegisterMySQLUpdate('1.0.0.3', @MAJ1_0_0_3);

end.
