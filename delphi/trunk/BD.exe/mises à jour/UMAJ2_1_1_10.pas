unit UMAJ2_1_1_10;

interface

implementation

uses UIB, Updates;

procedure MAJ2_1_1_10(Query: TUIBScript);
begin
  with Query do begin
    Script.Clear;

    Script.Add('create or alter procedure achatalbums_by_editeur (');
    Script.Add('    id_editeur t_guid,');
    Script.Add('    filtre varchar(125))');
    Script.Add('returns (');
    Script.Add('    id_album t_guid,');
    Script.Add('    titrealbum t_titre,');
    Script.Add('    tome smallint,');
    Script.Add('    tomedebut smallint,');
    Script.Add('    tomefin smallint,');
    Script.Add('    horsserie t_yesno,');
    Script.Add('    integrale t_yesno,');
    Script.Add('    moisparution smallint,');
    Script.Add('    anneeparution smallint,');
    Script.Add('    id_serie t_guid,');
    Script.Add('    titreserie t_titre,');
    Script.Add('    achat t_yesno,');
    Script.Add('    complet integer)');
    Script.Add('as');
    Script.Add('declare variable swhere varchar(133);');
    Script.Add('begin');
    Script.Add('  if (:id_editeur = cast('''' as char(38))) then');
    Script.Add('    swhere = ''s.id_editeur is null '';');
    Script.Add('  else');
    Script.Add('    swhere = ''s.id_editeur = '''''' || :id_editeur || '''''' '';');
    Script.Add('  if (filtre is not null and filtre <> '''') then');
    Script.Add('    swhere = swhere || ''and '' || filtre || '' '';');
    Script.Add('  for execute statement');
    Script.Add('    ''select');
    Script.Add('      a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie,');
    Script.Add('      a.integrale, a.moisparution, a.anneeparution, a.id_serie, s.titreserie,');
    Script.Add('      a.achat, a.complet');
    Script.Add('    from');
    Script.Add('      albums a');
    Script.Add('      left join series s on');
    Script.Add('        a.id_serie = s.id_serie');
    Script.Add('    where');
    Script.Add('      '' || :swhere || ''');
    Script.Add('    order by');
    Script.Add('      coalesce(titrealbum, titreserie), titreserie, horsserie nulls first,');
    Script.Add('      integrale nulls first, tome nulls first, tomedebut nulls first,');
    Script.Add('      tomefin nulls first, anneeparution nulls first, moisparution nulls first''');
    Script.Add('    into');
    Script.Add('      :id_album, :titrealbum, :tome, :tomedebut, :tomefin, :horsserie,');
    Script.Add('      :integrale, :moisparution, :anneeparution, :id_serie, :titreserie,');
    Script.Add('      :achat, :complet');
    Script.Add('  do');
    Script.Add('  begin');
    Script.Add('    suspend;');
    Script.Add('  end');
    Script.Add('end;');

    Script.Add('create or alter procedure albums_by_editeur (');
    Script.Add('    id_editeur t_guid,');
    Script.Add('    filtre varchar(125))');
    Script.Add('returns (');
    Script.Add('    id_album t_guid,');
    Script.Add('    titrealbum t_titre,');
    Script.Add('    tome smallint,');
    Script.Add('    tomedebut smallint,');
    Script.Add('    tomefin smallint,');
    Script.Add('    horsserie t_yesno,');
    Script.Add('    integrale t_yesno,');
    Script.Add('    moisparution smallint,');
    Script.Add('    anneeparution smallint,');
    Script.Add('    id_serie t_guid,');
    Script.Add('    titreserie t_titre,');
    Script.Add('    achat t_yesno,');
    Script.Add('    complet integer)');
    Script.Add('as');
    Script.Add('declare variable swhere varchar(133);');
    Script.Add('begin');
    Script.Add('  if (:id_editeur = cast('''' as char(38))) then');
    Script.Add('    swhere = ''e.id_editeur is null '';');
    Script.Add('  else');
    Script.Add('    swhere = ''e.id_editeur = '''''' || :id_editeur || '''''' '';');
    Script.Add('  if (filtre is not null and filtre <> '''') then');
    Script.Add('    swhere = swhere || ''and '' || filtre || '' '';');
    Script.Add('  for execute statement');
    Script.Add('    ''select');
    Script.Add('      a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie,');
    Script.Add('      a.integrale, a.moisparution, a.anneeparution, a.id_serie, s.titreserie,');
    Script.Add('      a.achat, a.complet');
    Script.Add('    from');
    Script.Add('      albums a');
    Script.Add('      left join editions e on');
    Script.Add('        a.id_album = e.id_album');
    Script.Add('      left join series s on');
    Script.Add('        a.id_serie = s.id_serie');
    Script.Add('    where');
    Script.Add('      '' || swhere || ''');
    Script.Add('    order by');
    Script.Add('      coalesce(titrealbum, titreserie), titreserie, horsserie nulls first,');
    Script.Add('      integrale nulls first, tome nulls first, tomedebut nulls first,');
    Script.Add('      tomefin nulls first, anneeparution nulls first, moisparution nulls first''');
    Script.Add('    into');
    Script.Add('      :id_album, :titrealbum, :tome, :tomedebut, :tomefin, :horsserie,');
    Script.Add('      :integrale, :moisparution, :anneeparution, :id_serie, :titreserie,');
    Script.Add('      :achat, :complet');
    Script.Add('  do');
    Script.Add('  begin');
    Script.Add('    suspend;');
    Script.Add('  end');
    Script.Add('end;');

    ExecuteScript;
  end;
end;

initialization
  RegisterFBUpdate('2.1.1.10', @MAJ2_1_1_10);

end.

