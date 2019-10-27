unit BDTK.Updates.v2_1_1_10;

interface

implementation

uses
  UIB, BDTK.Updates;

procedure MAJ2_1_1_10(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add('create or alter procedure achatalbums_by_editeur (');
  Query.Script.Add('    id_editeur t_guid,');
  Query.Script.Add('    filtre varchar(125))');
  Query.Script.Add('returns (');
  Query.Script.Add('    id_album t_guid,');
  Query.Script.Add('    titrealbum t_titre,');
  Query.Script.Add('    tome smallint,');
  Query.Script.Add('    tomedebut smallint,');
  Query.Script.Add('    tomefin smallint,');
  Query.Script.Add('    horsserie t_yesno,');
  Query.Script.Add('    integrale t_yesno,');
  Query.Script.Add('    moisparution smallint,');
  Query.Script.Add('    anneeparution smallint,');
  Query.Script.Add('    id_serie t_guid,');
  Query.Script.Add('    titreserie t_titre,');
  Query.Script.Add('    achat t_yesno,');
  Query.Script.Add('    complet integer)');
  Query.Script.Add('as');
  Query.Script.Add('declare variable swhere varchar(133);');
  Query.Script.Add('begin');
  Query.Script.Add('  if (:id_editeur = cast('''' as char(38))) then');
  Query.Script.Add('    swhere = ''s.id_editeur is null '';');
  Query.Script.Add('  else');
  Query.Script.Add('    swhere = ''s.id_editeur = '''''' || :id_editeur || '''''' '';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then');
  Query.Script.Add('    swhere = swhere || ''and '' || filtre || '' '';');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('    ''select');
  Query.Script.Add('      a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie,');
  Query.Script.Add('      a.integrale, a.moisparution, a.anneeparution, a.id_serie, s.titreserie,');
  Query.Script.Add('      a.achat, a.complet');
  Query.Script.Add('    from');
  Query.Script.Add('      albums a');
  Query.Script.Add('      left join series s on');
  Query.Script.Add('        a.id_serie = s.id_serie');
  Query.Script.Add('    where');
  Query.Script.Add('      '' || :swhere || ''');
  Query.Script.Add('    order by');
  Query.Script.Add('      coalesce(titrealbum, titreserie), titreserie, horsserie nulls first,');
  Query.Script.Add('      integrale nulls first, tome nulls first, tomedebut nulls first,');
  Query.Script.Add('      tomefin nulls first, anneeparution nulls first, moisparution nulls first''');
  Query.Script.Add('    into');
  Query.Script.Add('      :id_album, :titrealbum, :tome, :tomedebut, :tomefin, :horsserie,');
  Query.Script.Add('      :integrale, :moisparution, :anneeparution, :id_serie, :titreserie,');
  Query.Script.Add('      :achat, :complet');
  Query.Script.Add('  do');
  Query.Script.Add('  begin');
  Query.Script.Add('    suspend;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.Script.Add('create or alter procedure albums_by_editeur (');
  Query.Script.Add('    id_editeur t_guid,');
  Query.Script.Add('    filtre varchar(125))');
  Query.Script.Add('returns (');
  Query.Script.Add('    id_album t_guid,');
  Query.Script.Add('    titrealbum t_titre,');
  Query.Script.Add('    tome smallint,');
  Query.Script.Add('    tomedebut smallint,');
  Query.Script.Add('    tomefin smallint,');
  Query.Script.Add('    horsserie t_yesno,');
  Query.Script.Add('    integrale t_yesno,');
  Query.Script.Add('    moisparution smallint,');
  Query.Script.Add('    anneeparution smallint,');
  Query.Script.Add('    id_serie t_guid,');
  Query.Script.Add('    titreserie t_titre,');
  Query.Script.Add('    achat t_yesno,');
  Query.Script.Add('    complet integer)');
  Query.Script.Add('as');
  Query.Script.Add('declare variable swhere varchar(133);');
  Query.Script.Add('begin');
  Query.Script.Add('  if (:id_editeur = cast('''' as char(38))) then');
  Query.Script.Add('    swhere = ''e.id_editeur is null '';');
  Query.Script.Add('  else');
  Query.Script.Add('    swhere = ''e.id_editeur = '''''' || :id_editeur || '''''' '';');
  Query.Script.Add('  if (filtre is not null and filtre <> '''') then');
  Query.Script.Add('    swhere = swhere || ''and '' || filtre || '' '';');
  Query.Script.Add('  for execute statement');
  Query.Script.Add('    ''select');
  Query.Script.Add('      a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie,');
  Query.Script.Add('      a.integrale, a.moisparution, a.anneeparution, a.id_serie, s.titreserie,');
  Query.Script.Add('      a.achat, a.complet');
  Query.Script.Add('    from');
  Query.Script.Add('      albums a');
  Query.Script.Add('      left join editions e on');
  Query.Script.Add('        a.id_album = e.id_album');
  Query.Script.Add('      left join series s on');
  Query.Script.Add('        a.id_serie = s.id_serie');
  Query.Script.Add('    where');
  Query.Script.Add('      '' || swhere || ''');
  Query.Script.Add('    order by');
  Query.Script.Add('      coalesce(titrealbum, titreserie), titreserie, horsserie nulls first,');
  Query.Script.Add('      integrale nulls first, tome nulls first, tomedebut nulls first,');
  Query.Script.Add('      tomefin nulls first, anneeparution nulls first, moisparution nulls first''');
  Query.Script.Add('    into');
  Query.Script.Add('      :id_album, :titrealbum, :tome, :tomedebut, :tomefin, :horsserie,');
  Query.Script.Add('      :integrale, :moisparution, :anneeparution, :id_serie, :titreserie,');
  Query.Script.Add('      :achat, :complet');
  Query.Script.Add('  do');
  Query.Script.Add('  begin');
  Query.Script.Add('    suspend;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('2.1.1.10', @MAJ2_1_1_10);

end.
