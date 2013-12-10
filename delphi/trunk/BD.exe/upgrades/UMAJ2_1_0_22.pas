unit UMAJ2_1_0_22;

interface

implementation

uses UIB, Updates;

procedure MAJ2_1_0_22(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add('create view vw_dernieres_modifs(');
  Query.Script.Add('  typedata,');
  Query.Script.Add('  date_creation,');
  Query.Script.Add('  date_modif,');
  Query.Script.Add('  id,');
  Query.Script.Add('  titrealbum,');
  Query.Script.Add('  tome,');
  Query.Script.Add('  tomedebut,');
  Query.Script.Add('  tomefin,');
  Query.Script.Add('  integrale,');
  Query.Script.Add('  horsserie,');
  Query.Script.Add('  titreserie,');
  Query.Script.Add('  nomediteur,');
  Query.Script.Add('  nomcollection,');
  Query.Script.Add('  nompersonne');
  Query.Script.Add(') as');
  Query.Script.Add('select');
  Query.Script.Add('  ''A'', a.dc_albums, a.dm_albums, a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.integrale, a.horsserie, s.titreserie, null , null , null');
  Query.Script.Add('from');
  Query.Script.Add('  albums a');
  Query.Script.Add('  left join series s on');
  Query.Script.Add('    a.id_serie = s.id_serie');
  Query.Script.Add('');
  Query.Script.Add('union');
  Query.Script.Add('');
  Query.Script.Add('select');
  Query.Script.Add('  ''S'', s.dc_series, s.dm_series, s.id_serie, null , null , null , null , null , null , s.titreserie, e.nomediteur, c.nomcollection, null');
  Query.Script.Add('from');
  Query.Script.Add('  series s');
  Query.Script.Add('  left join editeurs e on');
  Query.Script.Add('    e.id_editeur = s.id_editeur');
  Query.Script.Add('  left join collections c on');
  Query.Script.Add('    c.id_collection = s.id_collection');
  Query.Script.Add('');
  Query.Script.Add('union');
  Query.Script.Add('');
  Query.Script.Add('select');
  Query.Script.Add('  ''P'', p.dc_personnes, p.dm_personnes, p.id_personne, null , null , null , null , null , null , null , null , null , p.nompersonne');
  Query.Script.Add('from');
  Query.Script.Add('  personnes p;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('2.1.0.22', @MAJ2_1_0_22);

end.
