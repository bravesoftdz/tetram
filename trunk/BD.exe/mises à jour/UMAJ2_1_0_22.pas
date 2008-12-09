unit UMAJ2_1_0_22;

interface

implementation

uses UIB, Updates;

procedure MAJ2_1_0_22(Query: TUIBScript);
begin
  with Query do
  begin
    Script.Clear;

    Script.Add('create view vw_dernieres_modifs(');
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
    Script.Add(') as');
    Script.Add('select');
    Script.Add('  ''A'', a.dc_albums, a.dm_albums, a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.integrale, a.horsserie, s.titreserie, null , null , null');
    Script.Add('from');
    Script.Add('  albums a');
    Script.Add('  left join series s on');
    Script.Add('    a.id_serie = s.id_serie');
    Script.Add('');
    Script.Add('union');
    Script.Add('');
    Script.Add('select');
    Script.Add('  ''S'', s.dc_series, s.dm_series, s.id_serie, null , null , null , null , null , null , s.titreserie, e.nomediteur, c.nomcollection, null');
    Script.Add('from');
    Script.Add('  series s');
    Script.Add('  left join editeurs e on');
    Script.Add('    e.id_editeur = s.id_editeur');
    Script.Add('  left join collections c on');
    Script.Add('    c.id_collection = s.id_collection');
    Script.Add('');
    Script.Add('union');
    Script.Add('');
    Script.Add('select');
    Script.Add('  ''P'', p.dc_personnes, p.dm_personnes, p.id_personne, null , null , null , null , null , null , null , null , null , p.nompersonne');
    Script.Add('from');
    Script.Add('  personnes p;');

    ExecuteScript;
  end;
end;

initialization
  RegisterFBUpdate('2.1.0.22', @MAJ2_1_0_22);

end.

