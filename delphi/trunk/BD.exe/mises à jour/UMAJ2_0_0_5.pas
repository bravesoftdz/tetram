unit UMAJ2_0_0_5;

interface

implementation

uses UIB, Updates;

procedure MAJ2_0_0_5(Query: TUIBScript);
begin
  with Query do begin
    Script.Clear;

    Script.Add('ALTER TABLE SERIES ADD NB_ALBUMS INTEGER;');

    Script.Add('ALTER PROCEDURE ALBUMS_MANQUANTS (');
    Script.Add('    withintegrale smallint,');
    Script.Add('    withachat smallint,');
    Script.Add('    in_idserie char(38))');
    Script.Add('returns (');
    Script.Add('    id_serie char(38),');
    Script.Add('    countserie integer,');
    Script.Add('    titreserie varchar(150),');
    Script.Add('    uppertitreserie varchar(150),');
    Script.Add('    tome integer,');
    Script.Add('    id_editeur char(38),');
    Script.Add('    nomediteur varchar(50),');
    Script.Add('    id_collection char(38),');
    Script.Add('    nomcollection varchar(50))');
    Script.Add('as');
    Script.Add('declare variable maxserie integer;');
    Script.Add('declare variable nb_albums integer;');
    Script.Add('declare variable currenttome integer;');
    Script.Add('declare variable ownedtome integer;');
    Script.Add('declare variable achat smallint;');
    Script.Add('declare variable sumachat integer;');
    Script.Add('begin');
    Script.Add('  if (withintegrale is null) then withintegrale = 1;');
    Script.Add('  if (withachat is null) then withachat = 1;');
    Script.Add('  for');
    Script.Add('    select');
    Script.Add('      s.id_serie,');
    Script.Add('      s.nb_albums,');
    Script.Add('      max(a.tome),');
    Script.Add('      count(distinct a.tome),');
    Script.Add('      cast(sum(a.achat) as integer),');
    Script.Add('      e.id_editeur,');
    Script.Add('      e.nomediteur,');
    Script.Add('      c.id_collection,');
    Script.Add('      c.nomcollection');
    Script.Add('    from');
    Script.Add('      liste_tomes(:withintegrale, :in_idserie) a');
    Script.Add('      /* pas de left join: on cherche les manquants pour compléter les séries */');
    Script.Add('      inner join series s on');
    Script.Add('        a.id_serie = s.id_serie');
    Script.Add('      left join editeurs e on');
    Script.Add('        s.id_editeur = e.id_editeur');
    Script.Add('      left join collections c on');
    Script.Add('        s.id_collection = c.id_collection');
    Script.Add('    where');
    Script.Add('      s.suivremanquants = 1');
    Script.Add('    group by');
    Script.Add('      s.id_serie, s.uppertitreserie, e.uppernomediteur, c.uppernomcollection,');
    Script.Add('      e.id_editeur, e.nomediteur, c.id_collection, c.nomcollection, s.nb_albums');
    Script.Add('    order by');
    Script.Add('      s.uppertitreserie, e.uppernomediteur, c.uppernomcollection');
    Script.Add('    into');
    Script.Add('      :id_serie,');
    Script.Add('      :nb_albums,');
    Script.Add('      :maxserie,');
    Script.Add('      :countserie,');
    Script.Add('      :sumachat,');
    Script.Add('      :id_editeur,');
    Script.Add('      :nomediteur,');
    Script.Add('      :id_collection,');
    Script.Add('      :nomcollection');
    Script.Add('  do begin');
    Script.Add('    if (withachat = 0) then');
    Script.Add('      countserie = :countserie - :sumachat;');
    Script.Add('    if (nb_albums is not null and nb_albums > 0 and nb_albums > maxserie) then');
    Script.Add('      maxserie = :nb_albums;');
    Script.Add('    if (countserie <> maxserie) then begin');
    Script.Add('      currenttome = 0;');
    Script.Add('      for');
    Script.Add('        select distinct');
    Script.Add('          uppertitreserie,');
    Script.Add('          titreserie,');
    Script.Add('          tome,');
    Script.Add('          achat');
    Script.Add('        from');
    Script.Add('          liste_tomes(:withintegrale, :id_serie) a');
    Script.Add('          inner join series s on');
    Script.Add('            a.id_serie = s.id_serie');
    Script.Add('        order by');
    Script.Add('          tome');
    Script.Add('        into');
    Script.Add('          :uppertitreserie,');
    Script.Add('          :titreserie,');
    Script.Add('          :ownedtome,');
    Script.Add('          :achat');
    Script.Add('      do begin');
    Script.Add('        currenttome = currenttome + 1;');
    Script.Add('        while ((currenttome <> ownedtome) and (currenttome < maxserie)) do begin');
    Script.Add('          tome = currenttome;');
    Script.Add('          suspend;');
    Script.Add('          currenttome = currenttome + 1;');
    Script.Add('        end');
    Script.Add('        if ((withachat = 0) and (achat = 1)) then begin');
    Script.Add('          tome = ownedtome;');
    Script.Add('          suspend;');
    Script.Add('        end');
    Script.Add('      end');
    Script.Add('      currenttome = currenttome + 1;');
    Script.Add('      while (currenttome <= maxserie) do begin');
    Script.Add('        tome = currenttome;');
    Script.Add('        suspend;');
    Script.Add('        currenttome = currenttome + 1;');
    Script.Add('      end');
    Script.Add('    end');
    Script.Add('  end');
    Script.Add('');
    Script.Add('  /* on ne peut pas utiliser un "union": le order by de la première requête');
    Script.Add('     est impératif */');
    Script.Add('  countserie = 0;');
    Script.Add('  for');
    Script.Add('    select');
    Script.Add('      s.id_serie,');
    Script.Add('      s.titreserie,');
    Script.Add('      s.uppertitreserie,');
    Script.Add('      s.nb_albums,');
    Script.Add('      e.id_editeur,');
    Script.Add('      e.nomediteur,');
    Script.Add('      c.id_collection,');
    Script.Add('      c.nomcollection');
    Script.Add('    from');
    Script.Add('      series s');
    Script.Add('      left join editeurs e on');
    Script.Add('        s.id_editeur = e.id_editeur');
    Script.Add('      left join collections c on');
    Script.Add('        s.id_collection = c.id_collection');
    Script.Add('    where');
    Script.Add('      not exists (select 1 from liste_tomes(:withintegrale, s.id_serie))');
    Script.Add('      and s.suivremanquants = 1 and s.nb_albums is not null');
    Script.Add('      and (:in_idserie is null or id_serie = :in_idserie)');
    Script.Add('    into');
    Script.Add('      :id_serie,');
    Script.Add('      :titreserie,'); 
    Script.Add('      :uppertitreserie,');
    Script.Add('      :nb_albums,');
    Script.Add('      :id_editeur,');
    Script.Add('      :nomediteur,');
    Script.Add('      :id_collection,');
    Script.Add('      :nomcollection');
    Script.Add('  do begin');
    Script.Add('    currenttome = 1;');
    Script.Add('    while (currenttome <= nb_albums) do begin');
    Script.Add('      tome = currenttome;');
    Script.Add('      suspend;');
    Script.Add('      currenttome = currenttome + 1;');
    Script.Add('    end');
    Script.Add('  end');
    Script.Add('end;');

    Script.Add('alter table editions add numeroperso varchar(25);');

    ExecuteScript;
  end;
end;

initialization
  RegisterFBUpdate('2.0.0.5', @MAJ2_0_0_5);

end.

