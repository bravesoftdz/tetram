﻿unit BDTK.Updates.v2_0_0_5;

interface

implementation

uses
  UIB, BDTK.Updates;

procedure MAJ2_0_0_5(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add('ALTER TABLE SERIES ADD NB_ALBUMS INTEGER;');

  Query.Script.Add('ALTER PROCEDURE ALBUMS_MANQUANTS (');
  Query.Script.Add('    withintegrale smallint,');
  Query.Script.Add('    withachat smallint,');
  Query.Script.Add('    in_idserie char(38))');
  Query.Script.Add('returns (');
  Query.Script.Add('    id_serie char(38),');
  Query.Script.Add('    countserie integer,');
  Query.Script.Add('    titreserie varchar(150),');
  Query.Script.Add('    uppertitreserie varchar(150),');
  Query.Script.Add('    tome integer,');
  Query.Script.Add('    id_editeur char(38),');
  Query.Script.Add('    nomediteur varchar(50),');
  Query.Script.Add('    id_collection char(38),');
  Query.Script.Add('    nomcollection varchar(50))');
  Query.Script.Add('as');
  Query.Script.Add('declare variable maxserie integer;');
  Query.Script.Add('declare variable nb_albums integer;');
  Query.Script.Add('declare variable currenttome integer;');
  Query.Script.Add('declare variable ownedtome integer;');
  Query.Script.Add('declare variable achat smallint;');
  Query.Script.Add('declare variable sumachat integer;');
  Query.Script.Add('begin');
  Query.Script.Add('  if (withintegrale is null) then withintegrale = 1;');
  Query.Script.Add('  if (withachat is null) then withachat = 1;');
  Query.Script.Add('  for');
  Query.Script.Add('    select');
  Query.Script.Add('      s.id_serie,');
  Query.Script.Add('      s.nb_albums,');
  Query.Script.Add('      max(a.tome),');
  Query.Script.Add('      count(distinct a.tome),');
  Query.Script.Add('      cast(sum(a.achat) as integer),');
  Query.Script.Add('      e.id_editeur,');
  Query.Script.Add('      e.nomediteur,');
  Query.Script.Add('      c.id_collection,');
  Query.Script.Add('      c.nomcollection');
  Query.Script.Add('    from');
  Query.Script.Add('      liste_tomes(:withintegrale, :in_idserie) a');
  Query.Script.Add('      /* pas de left join: on cherche les manquants pour compléter les séries */');
  Query.Script.Add('      inner join series s on');
  Query.Script.Add('        a.id_serie = s.id_serie');
  Query.Script.Add('      left join editeurs e on');
  Query.Script.Add('        s.id_editeur = e.id_editeur');
  Query.Script.Add('      left join collections c on');
  Query.Script.Add('        s.id_collection = c.id_collection');
  Query.Script.Add('    where');
  Query.Script.Add('      s.suivremanquants = 1');
  Query.Script.Add('    group by');
  Query.Script.Add('      s.id_serie, s.uppertitreserie, e.uppernomediteur, c.uppernomcollection,');
  Query.Script.Add('      e.id_editeur, e.nomediteur, c.id_collection, c.nomcollection, s.nb_albums');
  Query.Script.Add('    order by');
  Query.Script.Add('      s.uppertitreserie, e.uppernomediteur, c.uppernomcollection');
  Query.Script.Add('    into');
  Query.Script.Add('      :id_serie,');
  Query.Script.Add('      :nb_albums,');
  Query.Script.Add('      :maxserie,');
  Query.Script.Add('      :countserie,');
  Query.Script.Add('      :sumachat,');
  Query.Script.Add('      :id_editeur,');
  Query.Script.Add('      :nomediteur,');
  Query.Script.Add('      :id_collection,');
  Query.Script.Add('      :nomcollection');
  Query.Script.Add('  do begin');
  Query.Script.Add('    if (withachat = 0) then');
  Query.Script.Add('      countserie = :countserie - :sumachat;');
  Query.Script.Add('    if (nb_albums is not null and nb_albums > 0 and nb_albums > maxserie) then');
  Query.Script.Add('      maxserie = :nb_albums;');
  Query.Script.Add('    if (countserie <> maxserie) then begin');
  Query.Script.Add('      currenttome = 0;');
  Query.Script.Add('      for');
  Query.Script.Add('        select distinct');
  Query.Script.Add('          uppertitreserie,');
  Query.Script.Add('          titreserie,');
  Query.Script.Add('          tome,');
  Query.Script.Add('          achat');
  Query.Script.Add('        from');
  Query.Script.Add('          liste_tomes(:withintegrale, :id_serie) a');
  Query.Script.Add('          inner join series s on');
  Query.Script.Add('            a.id_serie = s.id_serie');
  Query.Script.Add('        order by');
  Query.Script.Add('          tome');
  Query.Script.Add('        into');
  Query.Script.Add('          :uppertitreserie,');
  Query.Script.Add('          :titreserie,');
  Query.Script.Add('          :ownedtome,');
  Query.Script.Add('          :achat');
  Query.Script.Add('      do begin');
  Query.Script.Add('        currenttome = currenttome + 1;');
  Query.Script.Add('        while ((currenttome <> ownedtome) and (currenttome < maxserie)) do begin');
  Query.Script.Add('          tome = currenttome;');
  Query.Script.Add('          suspend;');
  Query.Script.Add('          currenttome = currenttome + 1;');
  Query.Script.Add('        end');
  Query.Script.Add('        if ((withachat = 0) and (achat = 1)) then begin');
  Query.Script.Add('          tome = ownedtome;');
  Query.Script.Add('          suspend;');
  Query.Script.Add('        end');
  Query.Script.Add('      end');
  Query.Script.Add('      currenttome = currenttome + 1;');
  Query.Script.Add('      while (currenttome <= maxserie) do begin');
  Query.Script.Add('        tome = currenttome;');
  Query.Script.Add('        suspend;');
  Query.Script.Add('        currenttome = currenttome + 1;');
  Query.Script.Add('      end');
  Query.Script.Add('    end');
  Query.Script.Add('  end');
  Query.Script.Add('');
  Query.Script.Add('  /* on ne peut pas utiliser un "union": le order by de la première requête');
  Query.Script.Add('     est impératif */');
  Query.Script.Add('  countserie = 0;');
  Query.Script.Add('  for');
  Query.Script.Add('    select');
  Query.Script.Add('      s.id_serie,');
  Query.Script.Add('      s.titreserie,');
  Query.Script.Add('      s.uppertitreserie,');
  Query.Script.Add('      s.nb_albums,');
  Query.Script.Add('      e.id_editeur,');
  Query.Script.Add('      e.nomediteur,');
  Query.Script.Add('      c.id_collection,');
  Query.Script.Add('      c.nomcollection');
  Query.Script.Add('    from');
  Query.Script.Add('      series s');
  Query.Script.Add('      left join editeurs e on');
  Query.Script.Add('        s.id_editeur = e.id_editeur');
  Query.Script.Add('      left join collections c on');
  Query.Script.Add('        s.id_collection = c.id_collection');
  Query.Script.Add('    where');
  Query.Script.Add('      not exists (select 1 from liste_tomes(:withintegrale, s.id_serie))');
  Query.Script.Add('      and s.suivremanquants = 1 and s.nb_albums is not null');
  Query.Script.Add('      and (:in_idserie is null or id_serie = :in_idserie)');
  Query.Script.Add('    into');
  Query.Script.Add('      :id_serie,');
  Query.Script.Add('      :titreserie,');
  Query.Script.Add('      :uppertitreserie,');
  Query.Script.Add('      :nb_albums,');
  Query.Script.Add('      :id_editeur,');
  Query.Script.Add('      :nomediteur,');
  Query.Script.Add('      :id_collection,');
  Query.Script.Add('      :nomcollection');
  Query.Script.Add('  do begin');
  Query.Script.Add('    currenttome = 1;');
  Query.Script.Add('    while (currenttome <= nb_albums) do begin');
  Query.Script.Add('      tome = currenttome;');
  Query.Script.Add('      suspend;');
  Query.Script.Add('      currenttome = currenttome + 1;');
  Query.Script.Add('    end');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.Script.Add('alter table editions add numeroperso varchar(25);');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('2.0.0.5', @MAJ2_0_0_5);

end.
