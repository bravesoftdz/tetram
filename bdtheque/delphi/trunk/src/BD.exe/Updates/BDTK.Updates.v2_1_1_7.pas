unit BDTK.Updates.v2_1_1_7;

interface

implementation

uses
  UIB, BDTK.Updates;

procedure MAJ2_1_1_7(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add('create domain t_ident50 as varchar(50) character set iso8859_1 collate fr_fr_ci_ai;');
  Query.Script.Add('create domain t_initiale as char(1) character set iso8859_1 collate fr_fr_ci_ai;');

  Query.Script.Add('drop view vw_liste_editeurs_albums;');
  Query.Script.Add('create view vw_liste_editeurs_albums(');
  Query.Script.Add('    id_album,');
  Query.Script.Add('    titrealbum,');
  Query.Script.Add('    tome,');
  Query.Script.Add('    tomedebut,');
  Query.Script.Add('    tomefin,');
  Query.Script.Add('    horsserie,');
  Query.Script.Add('    integrale,');
  Query.Script.Add('    moisparution,');
  Query.Script.Add('    anneeparution,');
  Query.Script.Add('    id_serie,');
  Query.Script.Add('    titreserie,');
  Query.Script.Add('    id_editeur,');
  Query.Script.Add('    nomediteur,');
  Query.Script.Add('    achat,');
  Query.Script.Add('    complet)');
  Query.Script.Add('as');
  Query.Script.Add('select a.id_album,');
  Query.Script.Add('       a.titrealbum,');
  Query.Script.Add('       a.tome,');
  Query.Script.Add('       a.tomedebut,');
  Query.Script.Add('       a.tomefin,');
  Query.Script.Add('       a.horsserie,');
  Query.Script.Add('       a.integrale,');
  Query.Script.Add('       a.moisparution,');
  Query.Script.Add('       a.anneeparution,');
  Query.Script.Add('       a.id_serie,');
  Query.Script.Add('       a.titreserie,');
  Query.Script.Add('       e.id_editeur,');
  Query.Script.Add('       e.nomediteur,');
  Query.Script.Add('       a.achat,');
  Query.Script.Add('       a.complet');
  Query.Script.Add('from vw_liste_albums a left join editions ed on ed.id_album = a.id_album');
  Query.Script.Add('                       left join editeurs e on e.id_editeur = ed.id_editeur');
  Query.Script.Add(';');

  Query.Script.Add('drop view vw_liste_collections_albums;');
  Query.Script.Add('create view vw_liste_collections_albums(');
  Query.Script.Add('    id_album,');
  Query.Script.Add('    titrealbum,');
  Query.Script.Add('    tome,');
  Query.Script.Add('    tomedebut,');
  Query.Script.Add('    tomefin,');
  Query.Script.Add('    horsserie,');
  Query.Script.Add('    integrale,');
  Query.Script.Add('    moisparution,');
  Query.Script.Add('    anneeparution,');
  Query.Script.Add('    id_serie,');
  Query.Script.Add('    titreserie,');
  Query.Script.Add('    id_editeur,');
  Query.Script.Add('    nomediteur,');
  Query.Script.Add('    id_collection,');
  Query.Script.Add('    nomcollection,');
  Query.Script.Add('    achat,');
  Query.Script.Add('    complet)');
  Query.Script.Add('as');
  Query.Script.Add('select a.id_album,');
  Query.Script.Add('       a.titrealbum,');
  Query.Script.Add('       a.tome,');
  Query.Script.Add('       a.tomedebut,');
  Query.Script.Add('       a.tomefin,');
  Query.Script.Add('       a.horsserie,');
  Query.Script.Add('       a.integrale,');
  Query.Script.Add('       a.moisparution,');
  Query.Script.Add('       a.anneeparution,');
  Query.Script.Add('       a.id_serie,');
  Query.Script.Add('       a.titreserie,');
  Query.Script.Add('       e.id_editeur,');
  Query.Script.Add('       e.nomediteur,');
  Query.Script.Add('       c.id_collection,');
  Query.Script.Add('       c.nomcollection,');
  Query.Script.Add('       a.achat,');
  Query.Script.Add('       a.complet');
  Query.Script.Add('from vw_liste_albums a left join editions ed on ed.id_album = a.id_album');
  Query.Script.Add('                       left join collections c on ed.id_collection = c.id_collection');
  Query.Script.Add('                       left join editeurs e on e.id_editeur = ed.id_editeur');
  Query.Script.Add(';');

  Query.Script.Add('create or alter procedure collections_albums (');
  Query.Script.Add('    filtre varchar(125))');
  Query.Script.Add('returns (');
  Query.Script.Add('    nomcollection type of t_ident50,');
  Query.Script.Add('    countcollection integer,');
  Query.Script.Add('    id_collection type of t_guid,');
  Query.Script.Add('    nomediteur type of t_ident50,');
  Query.Script.Add('    id_editeur type of t_guid)');
  Query.Script.Add('as');
  Query.Script.Add('declare variable swhere varchar(133);');
  Query.Script.Add('begin');
  Query.Script.Add('  swhere = '''';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''and '' || filtre;');
  Query.Script.Add('');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('     ''select');
  Query.Script.Add('             cast(''''-1'''' as varchar(50)),');
  Query.Script.Add('             count(id_album),');
  Query.Script.Add('             null,');
  Query.Script.Add('             null,');
  Query.Script.Add('             null');
  Query.Script.Add('      from vw_liste_collections_albums');
  Query.Script.Add('      where id_collection is null '' || swhere ||');
  Query.Script.Add('     ''group by nomcollection, id_collection''');
  Query.Script.Add('  into :nomcollection,');
  Query.Script.Add('       :countcollection,');
  Query.Script.Add('       :id_collection,');
  Query.Script.Add('       :nomediteur,');
  Query.Script.Add('       :id_editeur');
  Query.Script.Add('  do begin');
  Query.Script.Add('    suspend;');
  Query.Script.Add('  end');
  Query.Script.Add('');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('     ''select');
  Query.Script.Add('             nomcollection,');
  Query.Script.Add('             count(id_album),');
  Query.Script.Add('             id_collection,');
  Query.Script.Add('             nomediteur,');
  Query.Script.Add('             id_editeur');
  Query.Script.Add('      from vw_liste_collections_albums');
  Query.Script.Add('      where id_collection is not null '' || swhere ||');
  Query.Script.Add('     ''group by nomcollection, id_collection, nomediteur, id_editeur''');
  Query.Script.Add('  into :nomcollection,');
  Query.Script.Add('       :countcollection,');
  Query.Script.Add('       :id_collection,');
  Query.Script.Add('       :nomediteur,');
  Query.Script.Add('       :id_editeur');
  Query.Script.Add('  do begin');
  Query.Script.Add('    suspend;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.Script.Add('create view vw_liste_collections (');
  Query.Script.Add('  id_collection,');
  Query.Script.Add('  nomcollection,');
  Query.Script.Add('  initialenomcollection,');
  Query.Script.Add('  id_editeur,');
  Query.Script.Add('  nomediteur )');
  Query.Script.Add('as');
  Query.Script.Add('select');
  Query.Script.Add('  c.id_collection,');
  Query.Script.Add('  c.nomcollection,');
  Query.Script.Add('  c.initialenomcollection,');
  Query.Script.Add('  e.id_editeur,');
  Query.Script.Add('  e.nomediteur');
  Query.Script.Add('from');
  Query.Script.Add('  collections c');
  Query.Script.Add('  inner join editeurs e on');
  Query.Script.Add('    e.id_editeur = c.id_editeur;');

  Query.Script.Add('create or alter procedure collections_by_initiale (');
  Query.Script.Add('    initiale char(1),');
  Query.Script.Add('    filtre varchar(125))');
  Query.Script.Add('returns (');
  Query.Script.Add('    id_collection type of t_guid,');
  Query.Script.Add('    nomcollection type of t_ident50,');
  Query.Script.Add('    id_editeur type of t_guid,');
  Query.Script.Add('    nomediteur type of t_ident50)');
  Query.Script.Add('as');
  Query.Script.Add('declare variable swhere varchar(133);');
  Query.Script.Add('begin');
  Query.Script.Add('  swhere = '''';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''and '' || filtre || '' '';');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('     ''select');
  Query.Script.Add('        id_collection,');
  Query.Script.Add('        nomcollection,');
  Query.Script.Add('        id_editeur,');
  Query.Script.Add('        nomediteur');
  Query.Script.Add('      from vw_liste_collections');
  Query.Script.Add('      where initialenomcollection = '''''' || :initiale || '''''' '' || swhere ||');
  Query.Script.Add('      ''order by nomcollection''');
  Query.Script.Add('      into');
  Query.Script.Add('        :id_collection,');
  Query.Script.Add('        :nomcollection,');
  Query.Script.Add('        :id_editeur,');
  Query.Script.Add('        :nomediteur');
  Query.Script.Add('  do');
  Query.Script.Add('  begin');
  Query.Script.Add('    suspend;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('2.1.1.7', @MAJ2_1_1_7);

end.
