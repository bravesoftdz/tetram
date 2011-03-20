unit UMAJ2_1_1_7;

interface

implementation

uses UIB, Updates;

procedure MAJ2_1_1_7(Query: TUIBScript);
begin
  with Query do
  begin
    Script.Clear;

    Script.Add('create domain t_ident50 as varchar(50) character set iso8859_1 collate fr_fr_ci_ai;');
    Script.Add('create domain t_initiale as char(1) character set iso8859_1 collate fr_fr_ci_ai;');

    Script.Add('drop view vw_liste_editeurs_albums;');
    Script.Add('create view vw_liste_editeurs_albums(');
    Script.Add('    id_album,');
    Script.Add('    titrealbum,');
    Script.Add('    tome,');
    Script.Add('    tomedebut,');
    Script.Add('    tomefin,');
    Script.Add('    horsserie,');
    Script.Add('    integrale,');
    Script.Add('    moisparution,');
    Script.Add('    anneeparution,');
    Script.Add('    id_serie,');
    Script.Add('    titreserie,');
    Script.Add('    id_editeur,');
    Script.Add('    nomediteur,');
    Script.Add('    achat,');
    Script.Add('    complet)');
    Script.Add('as');
    Script.Add('select a.id_album,');
    Script.Add('       a.titrealbum,');
    Script.Add('       a.tome,');
    Script.Add('       a.tomedebut,');
    Script.Add('       a.tomefin,');
    Script.Add('       a.horsserie,');
    Script.Add('       a.integrale,');
    Script.Add('       a.moisparution,');
    Script.Add('       a.anneeparution,');
    Script.Add('       a.id_serie,');
    Script.Add('       a.titreserie,');
    Script.Add('       e.id_editeur,');
    Script.Add('       e.nomediteur,');
    Script.Add('       a.achat,');
    Script.Add('       a.complet');
    Script.Add('from vw_liste_albums a left join editions ed on ed.id_album = a.id_album');
    Script.Add('                       left join editeurs e on e.id_editeur = ed.id_editeur');
    Script.Add(';');

    Script.Add('drop view vw_liste_collections_albums;');
    Script.Add('create view vw_liste_collections_albums(');
    Script.Add('    id_album,');
    Script.Add('    titrealbum,');
    Script.Add('    tome,');
    Script.Add('    tomedebut,');
    Script.Add('    tomefin,');
    Script.Add('    horsserie,');
    Script.Add('    integrale,');
    Script.Add('    moisparution,');
    Script.Add('    anneeparution,');
    Script.Add('    id_serie,');
    Script.Add('    titreserie,');
    Script.Add('    id_editeur,');
    Script.Add('    nomediteur,');
    Script.Add('    id_collection,');
    Script.Add('    nomcollection,');
    Script.Add('    achat,');
    Script.Add('    complet)');
    Script.Add('as');
    Script.Add('select a.id_album,');
    Script.Add('       a.titrealbum,');
    Script.Add('       a.tome,');
    Script.Add('       a.tomedebut,');
    Script.Add('       a.tomefin,');
    Script.Add('       a.horsserie,');
    Script.Add('       a.integrale,');
    Script.Add('       a.moisparution,');
    Script.Add('       a.anneeparution,');
    Script.Add('       a.id_serie,');
    Script.Add('       a.titreserie,');
    Script.Add('       e.id_editeur,');
    Script.Add('       e.nomediteur,');
    Script.Add('       c.id_collection,');
    Script.Add('       c.nomcollection,');
    Script.Add('       a.achat,');
    Script.Add('       a.complet');
    Script.Add('from vw_liste_albums a left join editions ed on ed.id_album = a.id_album');
    Script.Add('                       left join collections c on ed.id_collection = c.id_collection');
    Script.Add('                       left join editeurs e on e.id_editeur = ed.id_editeur');
    Script.Add(';');

    Script.Add('create or alter procedure collections_albums (');
    Script.Add('    filtre varchar(125))');
    Script.Add('returns (');
    Script.Add('    nomcollection type of t_ident50,');
    Script.Add('    countcollection integer,');
    Script.Add('    id_collection type of t_guid,');
    Script.Add('    nomediteur type of t_ident50,');
    Script.Add('    id_editeur type of t_guid)');
    Script.Add('as');
    Script.Add('declare variable swhere varchar(133);');
    Script.Add('begin');
    Script.Add('  swhere = '''';');
    Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''and '' || filtre;');
    Script.Add('');
    Script.Add('  for execute statement');
    Script.Add('     ''select');
    Script.Add('             cast(''''-1'''' as varchar(50)),');
    Script.Add('             count(id_album),');
    Script.Add('             null,');
    Script.Add('             null,');
    Script.Add('             null');
    Script.Add('      from vw_liste_collections_albums');
    Script.Add('      where id_collection is null '' || swhere ||');
    Script.Add('     ''group by nomcollection, id_collection''');
    Script.Add('  into :nomcollection,');
    Script.Add('       :countcollection,');
    Script.Add('       :id_collection,');
    Script.Add('       :nomediteur,');
    Script.Add('       :id_editeur');
    Script.Add('  do begin');
    Script.Add('    suspend;');
    Script.Add('  end');
    Script.Add('');
    Script.Add('  for execute statement');
    Script.Add('     ''select');
    Script.Add('             nomcollection,');
    Script.Add('             count(id_album),');
    Script.Add('             id_collection,');
    Script.Add('             nomediteur,');
    Script.Add('             id_editeur');
    Script.Add('      from vw_liste_collections_albums');
    Script.Add('      where id_collection is not null '' || swhere ||');
    Script.Add('     ''group by nomcollection, id_collection, nomediteur, id_editeur''');
    Script.Add('  into :nomcollection,');
    Script.Add('       :countcollection,');
    Script.Add('       :id_collection,');
    Script.Add('       :nomediteur,');
    Script.Add('       :id_editeur');
    Script.Add('  do begin');
    Script.Add('    suspend;');
    Script.Add('  end');
    Script.Add('end;');

    Script.Add('create view vw_liste_collections (');
    Script.Add('  id_collection,');
    Script.Add('  nomcollection,');
    Script.Add('  initialenomcollection,');
    Script.Add('  id_editeur,');
    Script.Add('  nomediteur )');
    Script.Add('as');
    Script.Add('select');
    Script.Add('  c.id_collection,');
    Script.Add('  c.nomcollection,');
    Script.Add('  c.initialenomcollection,');
    Script.Add('  e.id_editeur,');
    Script.Add('  e.nomediteur');
    Script.Add('from');
    Script.Add('  collections c');
    Script.Add('  inner join editeurs e on');
    Script.Add('    e.id_editeur = c.id_editeur;');

    Script.Add('create or alter procedure collections_by_initiale (');
    Script.Add('    initiale char(1),');
    Script.Add('    filtre varchar(125))');
    Script.Add('returns (');
    Script.Add('    id_collection type of t_guid,');
    Script.Add('    nomcollection type of t_ident50,');
    Script.Add('    id_editeur type of t_guid,');
    Script.Add('    nomediteur type of t_ident50)');
    Script.Add('as');
    Script.Add('declare variable swhere varchar(133);');
    Script.Add('begin');
    Script.Add('  swhere = '''';');
    Script.Add('  if (filtre is not null and filtre <> '''') then swhere = ''and '' || filtre || '' '';');
    Script.Add('  for execute statement');
    Script.Add('     ''select');
    Script.Add('        id_collection,');
    Script.Add('        nomcollection,');
    Script.Add('        id_editeur,');
    Script.Add('        nomediteur');
    Script.Add('      from vw_liste_collections');
    Script.Add('      where initialenomcollection = '''''' || :initiale || '''''' '' || swhere ||');
    Script.Add('      ''order by nomcollection''');
    Script.Add('      into');
    Script.Add('        :id_collection,');
    Script.Add('        :nomcollection,');
    Script.Add('        :id_editeur,');
    Script.Add('        :nomediteur');
    Script.Add('  do');
    Script.Add('  begin');
    Script.Add('    suspend;');
    Script.Add('  end');
    Script.Add('end;');

    ExecuteScript;
  end;
end;

initialization

RegisterFBUpdate('2.1.1.7', @MAJ2_1_1_7);

end.
