unit UMySQLMAJ1_0_0_2;

interface

uses Classes, Updates;

implementation

procedure MAJ1_0_0_2(Script: TStrings);
begin
  Script.Clear;
  Script.Add('drop view if exists /*DB_PREFIX*/vw_dernieres_modifs;');
  Script.Add('@@');

  Script.Add('CREATE VIEW /*DB_PREFIX*/vw_dernieres_modifs(');
  Script.Add('  typedata,');
  Script.Add('  date_creation,');
  Script.Add('  date_modif,');
  Script.Add('  id,');
  Script.Add('  titrealbum,');
  Script.Add('  tome,');
  Script.Add('  tomedebut,');
  Script.Add('  tomefin,');
  Script.Add('  integrale,');
  Script.Add('  horsserie,');
  Script.Add('  titreserie,');
  Script.Add('  nomediteur,');
  Script.Add('  nomcollection,');
  Script.Add('  nompersonne');
  Script.Add(') AS');
  Script.Add('SELECT');
  Script.Add('  ''A'', dc_albums, dm_albums, id_album, titrealbum, tome, tomedebut, tomefin, integrale, horsserie, titreserie, NULL , NULL , NULL');
  Script.Add('FROM');
  Script.Add('  /*DB_PREFIX*/albums a');
  Script.Add('  LEFT JOIN /*DB_PREFIX*/series s ON');
  Script.Add('    a.id_serie = s.id_serie');
  Script.Add('');
  Script.Add('UNION');
  Script.Add('');
  Script.Add('SELECT');
  Script.Add('  ''S'', dc_series, dm_series, id_serie, NULL , NULL , NULL , NULL , NULL , NULL , titreserie, e.nomediteur, c.nomcollection, NULL');
  Script.Add('FROM');
  Script.Add('  /*DB_PREFIX*/series s');
  Script.Add('  LEFT JOIN /*DB_PREFIX*/editeurs e ON');
  Script.Add('    e.id_editeur = s.id_editeur');
  Script.Add('  LEFT JOIN /*DB_PREFIX*/collections c ON');
  Script.Add('    c.id_collection = s.id_collection');
  Script.Add('');
  Script.Add('UNION');
  Script.Add('');
  Script.Add('SELECT');
  Script.Add('  ''P'', dc_personnes, dm_personnes, id_personne, NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , nompersonne');
  Script.Add('FROM');
  Script.Add('  /*DB_PREFIX*/personnes;');
  Script.Add('@@');
end;

initialization

RegisterMySQLUpdate('1.0.0.2', @MAJ1_0_0_2);

end.
