unit UMAJ2_2_2_233;

interface

implementation

uses SysUtils, UIB, UIBLib, Updates;

procedure MAJ2_2_2_233(Query: TUIBScript);
var
  qrySrc, qryDst: TUIBQuery;
  dbNone: TUIBDatabase;

  procedure ProcessData(const TableName, FieldName, KeyFieldName: string);
  begin
    // vu que la connexion principale est en NONE,
    // la routine ne sert pas à grand chose: un simple update suffirait
    // la routine devient utile si on passe la connexion principale en ISO8859_1 ou autre chose...
    // mais dans ce cas on ne peut plus stocker de symbole €
    // et on ne peut pas passer en utf8: des index sont trop gros pour exister en utf8
    qrySrc.SQL.Text := Format('select old_%1:s, %2:s from %0:s where nullif(trim(old_%1:s), '''') is not null', [TableName, FieldName, KeyFieldName]);
    qryDst.SQL.Text := Format('update %0:s set %1:s = :value where %2:s = :key', [TableName, FieldName, KeyFieldName]);
    Query.Script.Add(Format('alter table %s drop old_%s;', [TableName, FieldName]));

    qrySrc.Open;
    while not qrySrc.Eof do
    begin
      qryDst.Params.AsString[0] := qrySrc.Fields.AsString[0];
      qryDst.Params.AsString[1] := qrySrc.Fields.AsString[1];
      qryDst.ExecSQL;
      qrySrc.Next;
    end;
    Query.Transaction.Commit;
  end;

begin
exit;
  with Query do
  begin
    Script.Clear;

    Script.Add('');

    Script.Add('alter character set iso8859_1 set default collation fr_fr_ci_ai;');

    Script.Add('drop view vw_emprunts;');
    Script.Add('drop view vw_initiales_genres;');

    Script.Add('create or alter trigger genres_dv for genres');
    Script.Add('active before insert or update position 0');
    Script.Add('as');
    Script.Add('begin');
    Script.Add('  exit;');
    Script.Add('end;');

    Script.Add('create or alter procedure genres_by_initiale (');
    Script.Add('  initiale t_initiale)');
    Script.Add('returns (');
    Script.Add('  id_genre char(38),');
    Script.Add('  genre varchar(30) character set iso8859_1)');
    Script.Add('as');
    Script.Add('begin');
    Script.Add('  suspend;');
    Script.Add('end;');

    Script.Add('alter table couvertures');
    Script.Add('  alter fichiercouverture to old_fichiercouverture,');
    Script.Add('  add fichiercouverture varchar(255);');

    Script.Add('alter table editeurs');
    Script.Add('  alter siteweb to old_siteweb,');
    Script.Add('  add siteweb varchar(255);');

    Script.Add('alter table editions');
    Script.Add('  alter isbn to old_isbn,');
    Script.Add('  alter numeroperso to old_numeroperso,');
    Script.Add('  add isbn char(13),');
    Script.Add('  add numeroperso varchar(25);');

    Script.Add('alter table genres');
    Script.Add('  alter initialegenre to old_initialegenre,');
    Script.Add('  add initialegenre t_initiale;');

    Script.Add('drop index genres_idx3;');
    Script.Add('create index genres_idx3 on genres (initialegenre, id_genre);');

    Script.Add('alter table options');
    Script.Add('  alter valeur to old_valeur,');
    Script.Add('  add valeur varchar(255);');

    Script.Add('alter table options_scripts');
    Script.Add('  alter valeur to old_valeur,');
    Script.Add('  add valeur varchar(255);');

    Script.Add('alter table parabd');
    Script.Add('  alter fichierparabd to old_fichierparabd,');
    Script.Add('  add fichierparabd varchar(255);');

    Script.Add('alter table personnes');
    Script.Add('  alter siteweb to old_siteweb,');
    Script.Add('  add siteweb varchar(255);');

    Script.Add('alter table series');
    Script.Add('  alter siteweb to old_siteweb,');
    Script.Add('  add siteweb varchar(255);');

    Script.Add('alter table suppressions');
    Script.Add('  alter tablename type rdb$relation_name,');
    Script.Add('  alter fieldname type rdb$field_name;');

    Script.Add('create or alter view vw_emprunts (');
    Script.Add('  id_statut,');
    Script.Add('  id_edition,');
    Script.Add('  id_album,');
    Script.Add('  titrealbum,');
    Script.Add('  id_serie,');
    Script.Add('  tome,');
    Script.Add('  integrale,');
    Script.Add('  tomedebut,');
    Script.Add('  tomefin,');
    Script.Add('  horsserie,');
    Script.Add('  notation,');
    Script.Add('  titreserie,');
    Script.Add('  id_editeur,');
    Script.Add('  nomediteur,');
    Script.Add('  id_collection,');
    Script.Add('  nomcollection,');
    Script.Add('  prete,');
    Script.Add('  anneeedition,');
    Script.Add('  isbn,');
    Script.Add('  id_emprunteur,');
    Script.Add('  nomemprunteur,');
    Script.Add('  pretemprunt,');
    Script.Add('  dateemprunt)');
    Script.Add('as');
    Script.Add('select');
    Script.Add('  s.id_statut, ed.id_edition, a.id_album, a.titrealbum, a.id_serie, a.tome, a.integrale, a.tomedebut, a.tomefin,');
    Script.Add('  a.horsserie, a.notation, a.titreserie, e.id_editeur, e.nomediteur, c.id_collection, c.nomcollection, ed.prete,');
    Script.Add('  ed.anneeedition, ed.isbn, em.id_emprunteur, em.nomemprunteur, s.pretemprunt, s.dateemprunt');
    Script.Add('from');
    Script.Add('  vw_liste_albums a');
    Script.Add('  inner join editions ed on a.id_album = ed.id_album');
    Script.Add('  inner join editeurs e on e.id_editeur = ed.id_editeur');
    Script.Add('  left join collections c on c.id_collection = ed.id_collection');
    Script.Add('  inner join statut s on ed.id_edition = s.id_edition');
    Script.Add('  inner join emprunteurs em on em.id_emprunteur = s.id_emprunteur');
    Script.Add(';');

    Script.Add('create or alter view vw_initiales_genres (');
    Script.Add('  initialegenre,');
    Script.Add('  countinitiale)');
    Script.Add('as');
    Script.Add('select');
    Script.Add('  initialegenre, count(id_genre)');
    Script.Add('from');
    Script.Add('  genres');
    Script.Add('group by');
    Script.Add('  initialegenre');
    Script.Add(';');

    Script.Add('create or alter trigger genres_dv for genres');
    Script.Add('active before insert or update position 0');
    Script.Add('as');
    Script.Add('begin');
    Script.Add('  if (inserting or new.genre <> old.genre) then');
    Script.Add('  begin');
    Script.Add('    select');
    Script.Add('      initiale');
    Script.Add('    from');
    Script.Add('      get_initiale(new.genre)');
    Script.Add('    into');
    Script.Add('      new.initialegenre;');
    Script.Add('  end');
    Script.Add('end;');

    Script.Add('create or alter procedure genres_by_initiale (');
    Script.Add('  initiale t_initiale)');
    Script.Add('returns (');
    Script.Add('  id_genre type of column genres.id_genre,');
    Script.Add('  genre type of column genres.genre)');
    Script.Add('as');
    Script.Add('begin');
    Script.Add('  for');
    Script.Add('    select');
    Script.Add('      id_genre, genre');
    Script.Add('    from');
    Script.Add('      genres');
    Script.Add('    where');
    Script.Add('      initialegenre = :initiale');
    Script.Add('    order by');
    Script.Add('      genre');
    Script.Add('    into');
    Script.Add('      :id_genre, :genre');
    Script.Add('  do');
    Script.Add('    suspend;');
    Script.Add('end;');

    Script.Add('create or alter view vw_dernieres_modifs (');
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
    Script.Add('  nompersonne)');
    Script.Add('as');
    Script.Add('select');
    Script.Add('  ''A'', a.dc_albums, a.dm_albums, a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.integrale, a.horsserie,');
    Script.Add('  s.titreserie, null, null, null');
    Script.Add('from');
    Script.Add('  albums a');
    Script.Add('  left join series s on a.id_serie = s.id_serie');
    Script.Add('');
    Script.Add('union');
    Script.Add('');
    Script.Add('select');
    Script.Add('  ''S'', s.dc_series, s.dm_series, s.id_serie, null, null, null, null, null, null, s.titreserie, e.nomediteur,');
    Script.Add('  c.nomcollection, null');
    Script.Add('from');
    Script.Add('  series s');
    Script.Add('  left join editeurs e on e.id_editeur = s.id_editeur');
    Script.Add('  left join collections c on c.id_collection = s.id_collection');
    Script.Add('');
    Script.Add('union');
    Script.Add('');
    Script.Add('select');
    Script.Add('  ''P'', p.dc_personnes, p.dm_personnes, p.id_personne, null, null, null, null, null, null, null, null, null,');
    Script.Add('  p.nompersonne');
    Script.Add('from');
    Script.Add('  personnes p');
    Script.Add(';');

    ExecuteScript;
  end;

  Query.Transaction.Commit;

  dbNone := TUIBDatabase.Create(nil);
  qrySrc := TUIBQuery.Create(Query.Transaction);
  qryDst := TUIBQuery.Create(Query.Transaction);
  try
    with dbNone do
    begin
      LibraryName := Query.Database.LibraryName;
      DatabaseName := Query.Database.DatabaseName;
      Params.Assign(Query.Database.Params);
      CharacterSet := csNONE;

      Connected := True;
    end;

    Query.Transaction.AddDataBase(dbNone);

    qrySrc.Database := dbNone;
    qryDst.Database := Query.Database;

    Query.Script.Clear;

    ProcessData('COUVERTURES', 'FICHIERCOUVERTURE', 'ID_COUVERTURE');
    ProcessData('EDITEURS', 'SITEWEB', 'ID_EDITEUR');
    ProcessData('EDITIONS', 'ISBN', 'ID_EDITION');
    ProcessData('EDITIONS', 'NUMEROPERSO', 'ID_EDITION');
    ProcessData('GENRES', 'INITIALEGENRE', 'ID_GENRE');
    ProcessData('OPTIONS', 'VALEUR', 'ID_OPTION');
    ProcessData('OPTIONS_SCRIPTS', 'VALEUR', 'ID_OPTION');
    ProcessData('PARABD', 'FICHIERPARABD', 'ID_PARABD');
    ProcessData('PERSONNES', 'SITEWEB', 'ID_PERSONNE');
    ProcessData('SERIES', 'SITEWEB', 'ID_SERIE');

    Query.ExecuteScript;
  finally
    Query.Transaction.RemoveDatabase(dbNone);
    qrySrc.Free;
    qryDst.Free;
    dbNone.Free;
  end;
end;

initialization

RegisterFBUpdate('2.2.2.233', @MAJ2_2_2_233);

end.
