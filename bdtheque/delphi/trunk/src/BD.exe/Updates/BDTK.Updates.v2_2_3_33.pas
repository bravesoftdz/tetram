unit BDTK.Updates.v2_2_3_33;

interface

uses
  System.SysUtils;

implementation

uses
  uib, BDTK.Updates;

procedure MAJ2_2_3_33(Query: TUIBScript);
begin
  Query.Script.Add('create or alter procedure albums_by_collection (');
  Query.Script.Add('  id_collection type of column collections.id_collection,');
  Query.Script.Add('  filtre varchar(125) character set none)');
  Query.Script.Add('returns (');
  Query.Script.Add('  id_album type of column albums.id_album,');
  Query.Script.Add('  titrealbum type of column albums.titrealbum,');
  Query.Script.Add('  tome type of column albums.tome,');
  Query.Script.Add('  tomedebut type of column albums.tomedebut,');
  Query.Script.Add('  tomefin type of column albums.tomefin,');
  Query.Script.Add('  horsserie type of column albums.horsserie,');
  Query.Script.Add('  integrale type of column albums.integrale,');
  Query.Script.Add('  moisparution type of column albums.moisparution,');
  Query.Script.Add('  anneeparution type of column albums.anneeparution,');
  Query.Script.Add('  notation type of column albums.notation,');
  Query.Script.Add('  id_serie type of column series.id_serie,');
  Query.Script.Add('  titreserie type of column series.titreserie,');
  Query.Script.Add('  achat type of column albums.achat,');
  Query.Script.Add('  complet type of column albums.complet)');
  Query.Script.Add('as');
  Query.Script.Add('declare variable swhere varchar(200);');
  Query.Script.Add('begin');
  Query.Script.Add('  if (:id_collection = cast('''' as char(38))) then');
  Query.Script.Add('    swhere = ''id_collection is null '';');
  Query.Script.Add('  else');
  Query.Script.Add('    swhere = ''id_collection = '''''' || :id_collection || '''''' '';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then');
  Query.Script.Add('    swhere = swhere || ''and '' || filtre || '' '';');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('    ''select');
  Query.Script.Add('      id_album, titrealbum, tome, tomedebut, tomefin, horsserie,');
  Query.Script.Add('      integrale, moisparution, anneeparution, notation, id_serie,');
  Query.Script.Add('      titreserie, achat, complet');
  Query.Script.Add('    from');
  Query.Script.Add('      VW_LISTE_COLLECTIONS_ALBUMS');
  Query.Script.Add('    where');
  Query.Script.Add('      '' || :swhere || ''');
  Query.Script.Add('    order by');
  Query.Script.Add('      coalesce(titrealbum, titreserie), titreserie,');
  Query.Script.Add('      horsserie nulls first, integrale nulls first, tome nulls first,');
  Query.Script.Add('      tomedebut nulls first, tomefin nulls first,');
  Query.Script.Add('      anneeparution nulls first, moisparution nulls first''');
  Query.Script.Add('    into');
  Query.Script.Add('      :id_album, :titrealbum, :tome, :tomedebut, :tomefin, :horsserie,');
  Query.Script.Add('      :integrale, :moisparution, :anneeparution, :notation, :id_serie,');
  Query.Script.Add('      :titreserie, :achat, :complet');
  Query.Script.Add('  do');
  Query.Script.Add('  begin');
  Query.Script.Add('    suspend;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.Script.Add('create or alter procedure albums_by_editeur (');
  Query.Script.Add('  id_editeur type of column editeurs.id_editeur,');
  Query.Script.Add('  filtre varchar(125) character set none)');
  Query.Script.Add('returns (');
  Query.Script.Add('  id_album type of column albums.id_album,');
  Query.Script.Add('  titrealbum type of column albums.titrealbum,');
  Query.Script.Add('  tome type of column albums.tome,');
  Query.Script.Add('  tomedebut type of column albums.tomedebut,');
  Query.Script.Add('  tomefin type of column albums.tomefin,');
  Query.Script.Add('  horsserie type of column albums.horsserie,');
  Query.Script.Add('  integrale type of column albums.integrale,');
  Query.Script.Add('  moisparution type of column albums.moisparution,');
  Query.Script.Add('  anneeparution type of column albums.anneeparution,');
  Query.Script.Add('  notation type of column albums.notation,');
  Query.Script.Add('  id_serie type of column series.id_serie,');
  Query.Script.Add('  titreserie type of column series.titreserie,');
  Query.Script.Add('  achat type of column albums.achat,');
  Query.Script.Add('  complet type of column albums.complet)');
  Query.Script.Add('as');
  Query.Script.Add('declare variable swhere varchar(133);');
  Query.Script.Add('begin');
  Query.Script.Add('  if (:id_editeur = cast('''' as char(38))) then');
  Query.Script.Add('    swhere = ''id_editeur is null '';');
  Query.Script.Add('  else');
  Query.Script.Add('    swhere = ''id_editeur = '''''' || :id_editeur || '''''' '';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then');
  Query.Script.Add('    swhere = swhere || ''and '' || filtre || '' '';');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('    ''select');
  Query.Script.Add('      id_album, titrealbum, tome, tomedebut, tomefin, horsserie,');
  Query.Script.Add('      integrale, moisparution, anneeparution, notation, id_serie,');
  Query.Script.Add('      titreserie, achat, complet');
  Query.Script.Add('    from');
  Query.Script.Add('      vw_liste_editeurs_albums');
  Query.Script.Add('    where');
  Query.Script.Add('      '' || swhere || ''');
  Query.Script.Add('    order by');
  Query.Script.Add('      coalesce(titrealbum, titreserie), titreserie,');
  Query.Script.Add('      horsserie nulls first, integrale nulls first, tome nulls first,');
  Query.Script.Add('      tomedebut nulls first, tomefin nulls first,');
  Query.Script.Add('      anneeparution nulls first, moisparution nulls first''');
  Query.Script.Add('    into');
  Query.Script.Add('      :id_album, :titrealbum, :tome, :tomedebut, :tomefin, :horsserie,');
  Query.Script.Add('      :integrale, :moisparution, :anneeparution, :notation, :id_serie,');
  Query.Script.Add('      :titreserie, :achat, :complet');
  Query.Script.Add('  do');
  Query.Script.Add('  begin');
  Query.Script.Add('    suspend;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('2.2.3.33', @MAJ2_2_3_33);

end.
