unit UMySQLMAJ1_0_0_0;

interface

uses Classes, Updates;

implementation

procedure MAJ1_0_0_0(Script: TStrings);
begin
  with Script do
  begin
    Script.Clear;
    Add('CREATE TABLE IF NOT EXISTS /*DB_PREFIX*/options (');
    Add('  cle varchar(20) NOT NULL,');
    Add('  valeur varchar(100) default NULL,');
    Add('  PRIMARY KEY  (cle)');
    Add(');');
    Add('@@');

    Add('CREATE TABLE IF NOT EXISTS /*DB_PREFIX*/albums (');
    Add('  id_album char(38) NOT NULL,');
    Add('  titrealbum varchar(150) default NULL,');
    Add('  moisparution smallint(6) default NULL,');
    Add('  anneeparution smallint(6) default NULL,');
    Add('  id_serie char(38) default NULL,');
    Add('  tome smallint(6) default NULL,');
    Add('  tomedebut smallint(6) default NULL,');
    Add('  tomefin smallint(6) default NULL,');
    Add('  horsserie smallint(6) default ''0'',');
    Add('  integrale smallint(6) default ''0'',');
    Add('  sujetalbum longtext,');
    Add('  remarquesalbum longtext,');
    Add('  achat smallint(6) default ''0'',');
    Add('  nbeditions int(11) default ''0'',');
    Add('  complet tinyint(4) default NULL,');
    Add('  uppertitrealbum varchar(150) default NULL,');
    Add('  uppersujetalbum longtext,');
    Add('  upperremarquesalbum longtext,');
    Add('  soundextitrealbum varchar(30) default NULL,');
    Add('  initialetitrealbum char(1) default NULL,');
    Add('  dc_albums timestamp,');
    Add('  dm_albums timestamp,');
    Add('  PRIMARY KEY (id_album),');
    Add('  KEY id_serie (id_serie),');
    Add('  FULLTEXT KEY uppertitrealbum (uppertitrealbum),');
    Add('  FULLTEXT KEY uppersujetalbum (uppersujetalbum),');
    Add('  FULLTEXT KEY upperremarquesalbum (upperremarquesalbum)');
    Add(');');
    Add('@@');

    Add('CREATE TABLE IF NOT EXISTS /*DB_PREFIX*/series (');
    Add('  id_serie char(38) NOT NULL,');
    Add('  titreserie varchar(150) NOT NULL,');
    Add('  id_editeur char(38) default NULL,');
    Add('  id_collection char(38) default NULL,');
    Add('  sujetserie longtext,');
    Add('  remarquesserie longtext,');
    Add('  terminee smallint(6) default ''0'',');
    Add('  complete smallint(6) default ''0'',');
    Add('  siteweb varchar(255) default NULL,');
    Add('  suivremanquants smallint(6) default ''1'',');
    Add('  suivresorties smallint(6) default ''1'',');
    Add('  uppertitreserie varchar(150) default NULL,');
    Add('  initialetitreserie char(1) NOT NULL,');
    Add('  soundextitreserie varchar(30) default NULL,');
    Add('  uppersujetserie longtext,');
    Add('  upperremarquesserie longtext,');
    Add('  dc_series timestamp,');
    Add('  dm_series timestamp,');
    Add('  nb_albums int(11) default NULL,');
    Add('  PRIMARY KEY  (id_serie),');
    Add('  KEY id_editeur (id_editeur),');
    Add('  KEY id_collection (id_collection),');
    Add('  FULLTEXT KEY uppertitreserie (uppertitreserie)');
    Add(');');
    Add('@@');

    Add('CREATE TABLE IF NOT EXISTS /*DB_PREFIX*/personnes (');
    Add('  id_personne char(38) NOT NULL,');
    Add('  nompersonne varchar(150) default NULL,');
    Add('  uppernompersonne varchar(150) default NULL,');
    Add('  initialenompersonne char(1) default NULL,');
    Add('  biographie longtext,');
    Add('  siteweb varchar(255) default NULL,');
    Add('  dc_personnes timestamp,');
    Add('  dm_personnes timestamp,');
    Add('  PRIMARY KEY  (id_personne),');
    Add('  FULLTEXT KEY uppernompersonne (uppernompersonne)');
    Add(');');
    Add('@@');

(*
    Add('CREATE TABLE IF NOT EXISTS /*DB_PREFIX*/couvertures (');
    Add('  id_couverture char(38) NOT NULL,');
    Add('  id_album char(38) default NULL,');
    Add('  id_edition char(38) default NULL,');
    Add('  ordre int(11) default NULL,');
    Add('  categorieimage smallint(6) default NULL,');
    Add('  stockagecouverture smallint(6) default NULL,');
    Add('  imagecouverture longblob,');
    Add('  fichiercouverture varchar(255) default NULL,');
    Add('  dc_couvertures timestamp,');
    Add('  dm_couvertures timestamp,');
    Add('  PRIMARY KEY  (id_couverture),');
    Add('  KEY id_album (id_album),');
    Add('  KEY id_edition (id_edition)');
    Add(');');
    Add('@@');
*)
  end;
end;

initialization
  RegisterMySQLUpdate('1.0.0.0', @MAJ1_0_0_0);

end.

