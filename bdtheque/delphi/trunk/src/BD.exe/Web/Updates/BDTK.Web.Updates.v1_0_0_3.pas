unit BDTK.Web.Updates.v1_0_0_3;

interface

uses
  System.Classes, BDTK.Updates;

implementation

procedure MAJ1_0_0_3(Script: TStrings);
begin
  Script.Clear;
  Script.Add('CREATE TABLE IF NOT EXISTS /*DB_PREFIX*/univers (');
  Script.Add('  id_univers char(38) NOT NULL,');
  Script.Add('  nomunivers varchar(150) NOT NULL,');
  Script.Add('  uppernomunivers varchar(150) default NULL,');
  Script.Add('  id_univers_parent char(38),');
  Script.Add('  id_univers_racine char(38),');
  Script.Add('  description longtext,');
  Script.Add('  siteweb varchar(255) default NULL,');
  Script.Add('  initialenomunivers char(1) NOT NULL,');
  Script.Add('  branche_univers varchar(2000) NOT NULL,');
  Script.Add('  dc_univers timestamp,');
  Script.Add('  dm_univers timestamp,');
  Script.Add('  PRIMARY KEY  (id_univers),');
  Script.Add('  KEY id_univers_parent (id_univers_parent),');
  Script.Add('  KEY id_univers_racine (id_univers_racine),');
  Script.Add('  FULLTEXT KEY uppernomunivers (uppernomunivers),');
  Script.Add('  FULLTEXT KEY branche_univers (branche_univers)');
  Script.Add(') DEFAULT CHARSET=utf8;');
  Script.Add('@@');

  Script.Add('CREATE TABLE IF NOT EXISTS /*DB_PREFIX*/series_univers (');
  Script.Add('  id_serie_univers char(38) NOT NULL,');
  Script.Add('  id_serie char(38) NOT NULL,');
  Script.Add('  id_univers char(38) NOT NULL,');
  Script.Add('  dc_series_univers timestamp,');
  Script.Add('  dm_series_univers timestamp,');
  Script.Add('  PRIMARY KEY  (id_serie,id_univers),');
  Script.Add('  KEY id_serie_univers (id_serie_univers)');
  Script.Add(') DEFAULT CHARSET=utf8;');
  Script.Add('@@');

  Script.Add('CREATE TABLE IF NOT EXISTS /*DB_PREFIX*/albums_univers (');
  Script.Add('  id_album_univers char(38) NOT NULL,');
  Script.Add('  id_album char(38) NOT NULL,');
  Script.Add('  id_univers char(38) NOT NULL,');
  Script.Add('  source_album smallint(6) default 0,');
  Script.Add('  source_serie smallint(6) default 0,');
  Script.Add('  dc_albums_univers timestamp,');
  Script.Add('  dm_albums_univers timestamp,');
  Script.Add('  PRIMARY KEY  (id_album,id_univers),');
  Script.Add('  KEY id_album_univers (id_album_univers)');
  Script.Add(') DEFAULT CHARSET=utf8;');
  Script.Add('@@');

  Script.Add('create view /*DB_PREFIX*/vw_liste_albums_univers(');
  Script.Add('  id_album,');
  Script.Add('  titrealbum,');
  Script.Add('  tome,');
  Script.Add('  tomedebut,');
  Script.Add('  tomefin,');
  Script.Add('  horsserie,');
  Script.Add('  integrale,');
  Script.Add('  moisparution,');
  Script.Add('  anneeparution,');
  Script.Add('  id_serie,');
  Script.Add('  titreserie,');
  Script.Add('  uppertitrealbum,');
  Script.Add('  uppertitreserie,');
  Script.Add('  achat,');
  Script.Add('  complet,');
  Script.Add('  initialetitrealbum,');
  Script.Add('  initialetitreserie,');
  Script.Add('  id_univers,');
  Script.Add('  nomunivers,');
  Script.Add('  id_univers_racine,');
  Script.Add('  id_univers_parent,');
  Script.Add('  branche_univers)');
  Script.Add('as');
  Script.Add('select');
  Script.Add('  a.id_album,');
  Script.Add('  a.titrealbum,');
  Script.Add('  a.tome,');
  Script.Add('  a.tomedebut,');
  Script.Add('  a.tomefin,');
  Script.Add('  a.horsserie,');
  Script.Add('  a.integrale,');
  Script.Add('  a.moisparution,');
  Script.Add('  a.anneeparution,');
  Script.Add('  a.id_serie,');
  Script.Add('  s.titreserie,');
  Script.Add('  a.uppertitrealbum,');
  Script.Add('  s.uppertitreserie,');
  Script.Add('  a.achat,');
  Script.Add('  a.complet,');
  Script.Add('  coalesce(a.initialetitrealbum, s.initialetitreserie),');
  Script.Add('  s.initialetitreserie,');
  Script.Add('  au.id_univers,');
  Script.Add('  u.nomunivers,');
  Script.Add('  u.id_univers_racine,');
  Script.Add('  u.id_univers_parent,');
  Script.Add('  u.branche_univers');
  Script.Add('from');
  Script.Add('  /*DB_PREFIX*/albums a');
  Script.Add('  left join /*DB_PREFIX*/series s on');
  Script.Add('    s.id_serie = a.id_serie');
  Script.Add('  left join /*DB_PREFIX*/albums_univers au on');
  Script.Add('    au.id_album = a.id_album');
  Script.Add('  left join /*DB_PREFIX*/univers u on');
  Script.Add('    u.id_univers = au.id_univers');
  Script.Add(';');
  Script.Add('@@');
end;

initialization

RegisterMySQLUpdate('1.0.0.3', @MAJ1_0_0_3);

end.
