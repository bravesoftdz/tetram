unit UMySQLMAJ1_0_0_2;

interface

uses Classes, Updates;

implementation

procedure MAJ1_0_0_2(Script: TStrings);
begin
  with Script do
  begin
    Clear;
    Add('drop view if exists /*DB_PREFIX*/vw_dernieres_modifs;');
    Add('@@');

    Add('CREATE VIEW /*DB_PREFIX*/vw_dernieres_modifs(');
    Add('  typedata,');
    Add('  date_creation,');
    Add('  date_modif,');
    Add('  id,');
    Add('  titrealbum,');
    Add('  tome,');
    Add('  tomedebut,');
    Add('  tomefin,');
    Add('  integrale,');
    Add('  horsserie,');
    Add('  titreserie,');
    Add('  nomediteur,');
    Add('  nomcollection,');
    Add('  nompersonne');
    Add(') AS');
    Add('SELECT');
    Add('  ''A'', dc_albums, dm_albums, id_album, titrealbum, tome, tomedebut, tomefin, integrale, horsserie, titreserie, NULL , NULL , NULL');
    Add('FROM');
    Add('  /*DB_PREFIX*/albums a');
    Add('  LEFT JOIN /*DB_PREFIX*/series s ON');
    Add('    a.id_serie = s.id_serie');
    Add('');
    Add('UNION');
    Add('');
    Add('SELECT');
    Add('  ''S'', dc_series, dm_series, id_serie, NULL , NULL , NULL , NULL , NULL , NULL , titreserie, e.nomediteur, c.nomcollection, NULL');
    Add('FROM');
    Add('  /*DB_PREFIX*/series s');
    Add('  LEFT JOIN /*DB_PREFIX*/editeurs e ON');
    Add('    e.id_editeur = s.id_editeur');
    Add('  LEFT JOIN /*DB_PREFIX*/collections c ON');
    Add('    c.id_collection = s.id_collection');
    Add('');
    Add('UNION');
    Add('');
    Add('SELECT');
    Add('  ''P'', dc_personnes, dm_personnes, id_personne, NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , nompersonne');
    Add('FROM');
    Add('  /*DB_PREFIX*/personnes;');
    Add('@@');
  end;
end;

initialization
  RegisterMySQLUpdate('1.0.0.2', @MAJ1_0_0_2);

end.
