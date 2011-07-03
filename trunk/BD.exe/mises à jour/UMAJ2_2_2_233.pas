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
  with Query do
  begin
    Script.Clear;

    Script.Add('create collation utf8_fr for utf8 from unicode ''LOCALE=fr_FR'';');
    Script.Add('create collation utf8_fr_ci for utf8 from unicode_ci ''LOCALE=fr_FR'';');
    Script.Add('create collation utf8_fr_ci_ai for utf8 from unicode_ci_ai ''LOCALE=fr_FR'';');

    Script.Add('alter character set utf8 set default collation utf8_fr_ci_ai;');

    Script.Add('update rdb$database set rdb$character_set_name = ''UTF8'';');
    ExecuteScript;
    Transaction.Commit;

    Database.Connected := False;
    Database.Connected := True;

    // exit;

    Script.Clear;

    Script.Add('create domain t_titre_utf8 as varchar (150) character set utf8 collate utf8_fr_ci_ai;');
    Script.Add('create domain t_nom_utf8 as varchar (150) character set utf8 collate utf8_fr_ci_ai;');
    Script.Add('create domain t_ident50_utf8 as varchar (50) character set utf8 collate utf8_fr_ci_ai;');
    Script.Add('create domain t_description_utf8 as blob sub_type 1 segment size 80 character set utf8 collate utf8_fr_ci_ai;');
    Script.Add('create domain t_initiale_utf8 as char (1) character set utf8 collate utf8_fr_ci_ai;');
    Script.Add('create domain t_soundex_utf8 as varchar (30) character set utf8 collate utf8_fr_ci_ai;');

    Script.Add('alter table albums alter initialetitrealbum type t_initiale_utf8;');
    Script.Add('alter table albums alter soundextitrealbum type t_soundex_utf8;');
    Script.Add('alter table albums alter titrealbum type t_titre_utf8;');
    Script.Add('alter table collections alter initialenomcollection type t_initiale_utf8;');
    Script.Add('alter table collections alter nomcollection type t_ident50_utf8;');
    Script.Add('alter table editeurs alter initialenomediteur type t_initiale_utf8;');
    Script.Add('alter table editeurs alter nomediteur type t_ident50_utf8;');
    Script.Add('alter table emprunteurs alter initialenomemprunteur type t_initiale_utf8;');
    Script.Add('alter table emprunteurs alter nomemprunteur type t_nom_utf8;');
    Script.Add('alter table genres alter initialegenre type t_initiale_utf8;');
    Script.Add('alter table parabd alter initialetitreparabd type t_initiale_utf8;');
    Script.Add('alter table parabd alter titreparabd type t_titre_utf8;');
    Script.Add('alter table parabd alter soundextitreparabd type t_soundex_utf8;');
    Script.Add('alter table personnes alter initialenompersonne type t_initiale_utf8;');
    Script.Add('alter table personnes alter nompersonne type t_titre_utf8;');
    Script.Add('alter table series alter initialetitreserie type t_initiale_utf8;');
    Script.Add('alter table series alter titreserie type t_titre_utf8;');
    Script.Add('alter table series alter soundextitreserie type t_soundex_utf8;');

    Script.Add('create or alter procedure parabd_by_serie (');
    Script.Add('  in_id_serie char(38) character set none,');
    Script.Add('  filtre varchar(125) character set none)');
    Script.Add('returns (');
    Script.Add('  id_parabd char(38) character set none,');
    Script.Add('  titreparabd varchar(150),');
    Script.Add('  id_serie char(38) character set none,');
    Script.Add('  titreserie varchar(150),');
    Script.Add('  achat smallint,');
    Script.Add('  complet integer,');
    Script.Add('  scategorie varchar(50) character set iso8859_1)');
    Script.Add('as');
    Script.Add('declare variable swhere varchar(130);');
    Script.Add('begin');
    Script.Add('  suspend;');
    Script.Add('end;');

    Script.Add('create or alter trigger genres_dv for genres');
    Script.Add('active before insert or update position 0');
    Script.Add('as');
    Script.Add('begin');
    Script.Add('  exit;');
    Script.Add('end;');

    Script.Add('create or alter procedure genres_by_initiale (');
    Script.Add('  initiale t_initiale)');
    Script.Add('returns (');
    Script.Add('  id_genre char(38) character set none,');
    Script.Add('  genre varchar(30) character set iso8859_1)');
    Script.Add('as');
    Script.Add('begin');
    Script.Add('  suspend;');
    Script.Add('end;');

    Script.Add('create or alter procedure genres_albums (');
    Script.Add('  filtre varchar(125) character set none)');
    Script.Add('returns (');
    Script.Add('  genre varchar(30) character set iso8859_1,');
    Script.Add('  countgenre integer,');
    Script.Add('  id_genre char(38) character set none)');
    Script.Add('as');
    Script.Add('declare variable swhere varchar(132);');
    Script.Add('begin');
    Script.Add('  suspend;');
    Script.Add('end;');

    Script.Add('create or alter procedure proc_emprunts');
    Script.Add('returns (');
    Script.Add('  id_edition char(38),');
    Script.Add('  id_album char(38),');
    Script.Add('  titrealbum varchar(150),');
    Script.Add('  id_serie char(38),');
    Script.Add('  titreserie varchar(150),');
    Script.Add('  prete smallint,');
    Script.Add('  id_emprunteur char(38),');
    Script.Add('  nomemprunteur varchar(150),');
    Script.Add('  pretemprunt smallint,');
    Script.Add('  dateemprunt timestamp)');
    Script.Add('as');
    Script.Add('begin');
    Script.Add('  suspend;');
    Script.Add('end;');

    Script.Add('drop view vw_dernieres_modifs;');
    Script.Add('drop view vw_initiales_genres;');
    Script.Add('drop view vw_liste_parabd;');

    Script.Add('drop view vw_liste_genres_albums;');
    Script.Add('drop view vw_liste_editeurs_albums;');
    Script.Add('drop view vw_liste_editeurs_achatalbums;');
    Script.Add('drop view vw_liste_collections_albums;');
    Script.Add('drop view vw_emprunts;');
    Script.Add('drop view vw_liste_albums;');

    Script.Add('alter table albums');
    Script.Add('  alter sujetalbum to old_sujetalbum,');
    Script.Add('  add sujetalbum t_description_utf8,');
    Script.Add('  alter remarquesalbum to old_remarquesalbum,');
    Script.Add('  add remarquesalbum t_description_utf8;');
    Script.Add('update albums set sujetalbum = old_sujetalbum, remarquesalbum = old_remarquesalbum;');
    Script.Add('alter table albums drop old_sujetalbum, drop old_remarquesalbum;');

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
    Script.Add('  add numeroperso varchar(25),');
    Script.Add('  alter notes to old_notes,');
    Script.Add('  add notes t_description_utf8;');
    Script.Add('update editions set notes = old_notes;');
    Script.Add('alter table editions drop old_notes;');

    Script.Add('alter table emprunteurs');
    Script.Add('  alter adresseemprunteur to old_adresseemprunteur,');
    Script.Add('  add adresseemprunteur t_description_utf8;');
    Script.Add('update emprunteurs set adresseemprunteur = old_adresseemprunteur;');
    Script.Add('alter table emprunteurs drop old_adresseemprunteur;');

    Script.Add('alter table genres');
    Script.Add('  alter initialegenre to old_initialegenre,');
    Script.Add('  add initialegenre t_initiale_utf8,');
    Script.Add('  alter genre to old_genre,');
    Script.Add('  add genre varchar(30);');
    Script.Add('update genres set genre = old_genre;');
    Script.Add('drop index genres_idx2;');
    Script.Add('create index genres_idx2 on genres (genre);');
    Script.Add('drop index genres_idx3;');
    Script.Add('create index genres_idx3 on genres (initialegenre, id_genre);');
    Script.Add('alter table genres drop old_genre;');

    Script.Add('alter table options drop constraint options_pk;');
    Script.Add('alter table options');
    Script.Add('  alter valeur to old_valeur,');
    Script.Add('  add valeur varchar(255),');
    Script.Add('  alter nom_option to old_nom_option,');
    Script.Add('  add nom_option varchar (15) not null;');
    Script.Add('update options set nom_option = old_nom_option;');
    Script.Add('alter table options drop old_nom_option;');
    Script.Add('alter table options add constraint options_pk primary key(nom_option) using index options_pk;');

    Script.Add('alter table conversions');
    Script.Add('  alter monnaie1 to old_monnaie1,');
    Script.Add('  alter monnaie2 to old_monnaie2,');
    Script.Add('  add monnaie1 varchar(5),');
    Script.Add('  add monnaie2 varchar(5);');

    Script.Add('alter table options_scripts drop constraint options_scripts_pk;');
    Script.Add('alter table options_scripts');
    Script.Add('  alter valeur to old_valeur,');
    Script.Add('  add valeur varchar(255),');
    Script.Add('  alter nom_option to old_nom_option,');
    Script.Add('  add nom_option varchar (50) not null,');
    Script.Add('  alter script to old_script,');
    Script.Add('  add script varchar (50) not null;');
    Script.Add('update options_scripts set');
    Script.Add('  script = old_script,');
    Script.Add('  nom_option = old_nom_option;');
    Script.Add('alter table options_scripts drop old_nom_option, drop old_script;');
    Script.Add('alter table options_scripts add constraint options_scripts_pk primary key(script, nom_option) using index options_scripts_pk;');

    Script.Add('alter table parabd');
    Script.Add('  alter fichierparabd to old_fichierparabd,');
    Script.Add('  add fichierparabd varchar(255),');
    Script.Add('  alter description to old_description,');
    Script.Add('  add description t_description_utf8;');
    Script.Add('update parabd set description = old_description;');
    Script.Add('alter table parabd drop old_description;');

    Script.Add('alter table personnes');
    Script.Add('  alter siteweb to old_siteweb,');
    Script.Add('  add siteweb varchar(255),');
    Script.Add('  alter biographie to old_biographie,');
    Script.Add('  add biographie t_description_utf8;');
    Script.Add('update personnes set biographie = old_biographie;');
    Script.Add('alter table personnes drop old_biographie;');

    Script.Add('alter table series');
    Script.Add('  alter siteweb to old_siteweb,');
    Script.Add('  add siteweb varchar(255),');
    Script.Add('  alter sujetserie to old_sujetserie,');
    Script.Add('  add sujetserie t_description_utf8,');
    Script.Add('  alter remarquesserie to old_remarquesserie,');
    Script.Add('  add remarquesserie t_description_utf8;');
    Script.Add('update series set sujetserie = old_sujetserie, remarquesserie = old_remarquesserie;');
    Script.Add('alter table series drop old_sujetserie, drop old_remarquesserie;');

    Script.Add('alter table suppressions');
    Script.Add('  alter tablename type rdb$relation_name,');
    Script.Add('  alter fieldname type rdb$field_name;');

    Script.Add('alter table criteres');
    Script.Add('  alter critere to old_critere,');
    Script.Add('  add critere varchar(20);');
    Script.Add('update criteres set critere = old_critere;');
    Script.Add('alter table criteres');
    Script.Add('  drop old_critere;');

    Script.Add('alter table listes');
    Script.Add('  alter libelle to old_libelle,');
    Script.Add('  add libelle varchar(50);');
    Script.Add('update listes set libelle = old_libelle;');
    Script.Add('alter table listes');
    Script.Add('  drop old_libelle;');

    Script.Add('alter table import_associations drop constraint pk_import_associations;');
    Script.Add('alter table import_associations alter chaine to old_chaine, add chaine varchar (100) not null;');
    Script.Add('update import_associations set');
    Script.Add('  chaine = substring(old_chaine from 1 for 100);');
    Script.Add('alter table import_associations drop old_chaine;');
    Script.Add('alter table import_associations add constraint pk_import_associations primary key(chaine, typedata, parentid) using index pk_import_associations;');

    Script.Add('create or alter view vw_liste_albums (');
    Script.Add('  id_album,');
    Script.Add('  titrealbum,');
    Script.Add('  tome,');
    Script.Add('  tomedebut,');
    Script.Add('  tomefin,');
    Script.Add('  horsserie,');
    Script.Add('  integrale,');
    Script.Add('  moisparution,');
    Script.Add('  anneeparution,');
    Script.Add('  id_serie,');
    Script.Add('  titreserie,');
    Script.Add('  achat,');
    Script.Add('  complet,');
    Script.Add('  notation,');
    Script.Add('  initialetitrealbum,');
    Script.Add('  initialetitreserie)');
    Script.Add('as');
    Script.Add('select');
    Script.Add('  a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie, a.integrale, a.moisparution, a.anneeparution,');
    Script.Add('  a.id_serie, s.titreserie, a.achat, a.complet, a.notation, coalesce(a.initialetitrealbum, s.initialetitreserie),');
    Script.Add('  s.initialetitreserie');
    Script.Add('from');
    Script.Add('  albums a');
    Script.Add('  left join series s on s.id_serie = a.id_serie');
    Script.Add(';');

    Script.Add('create view vw_emprunts (');
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

    Script.Add('create view vw_liste_collections_albums (');
    Script.Add('  id_album,');
    Script.Add('  titrealbum,');
    Script.Add('  tome,');
    Script.Add('  tomedebut,');
    Script.Add('  tomefin,');
    Script.Add('  horsserie,');
    Script.Add('  integrale,');
    Script.Add('  moisparution,');
    Script.Add('  anneeparution,');
    Script.Add('  notation,');
    Script.Add('  id_serie,');
    Script.Add('  titreserie,');
    Script.Add('  id_editeur,');
    Script.Add('  nomediteur,');
    Script.Add('  id_collection,');
    Script.Add('  nomcollection,');
    Script.Add('  achat,');
    Script.Add('  complet)');
    Script.Add('as');
    Script.Add('select');
    Script.Add('  a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie, a.integrale, a.moisparution, a.anneeparution,');
    Script.Add('  a.notation, a.id_serie, a.titreserie, e.id_editeur, e.nomediteur, c.id_collection, c.nomcollection, a.achat,');
    Script.Add('  a.complet');
    Script.Add('from');
    Script.Add('  vw_liste_albums a');
    Script.Add('  left join editions ed on ed.id_album = a.id_album');
    Script.Add('  left join collections c on ed.id_collection = c.id_collection');
    Script.Add('  left join editeurs e on e.id_editeur = ed.id_editeur');
    Script.Add(';');

    Script.Add('create view vw_liste_editeurs_achatalbums (');
    Script.Add('  id_album,');
    Script.Add('  titrealbum,');
    Script.Add('  tome,');
    Script.Add('  tomedebut,');
    Script.Add('  tomefin,');
    Script.Add('  horsserie,');
    Script.Add('  integrale,');
    Script.Add('  moisparution,');
    Script.Add('  anneeparution,');
    Script.Add('  notation,');
    Script.Add('  id_serie,');
    Script.Add('  titreserie,');
    Script.Add('  id_editeur,');
    Script.Add('  nomediteur,');
    Script.Add('  achat,');
    Script.Add('  complet)');
    Script.Add('as');
    Script.Add('select');
    Script.Add('  a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie, a.integrale, a.moisparution, a.anneeparution,');
    Script.Add('  a.notation, a.id_serie, a.titreserie, e.id_editeur, e.nomediteur, a.achat, a.complet');
    Script.Add('from');
    Script.Add('  vw_liste_albums a');
    Script.Add('  left join series s on s.id_serie = a.id_serie');
    Script.Add('  left join editeurs e on e.id_editeur = s.id_editeur');
    Script.Add(';');

    Script.Add('create view vw_liste_editeurs_albums (');
    Script.Add('  id_album,');
    Script.Add('  titrealbum,');
    Script.Add('  tome,');
    Script.Add('  tomedebut,');
    Script.Add('  tomefin,');
    Script.Add('  horsserie,');
    Script.Add('  integrale,');
    Script.Add('  moisparution,');
    Script.Add('  anneeparution,');
    Script.Add('  notation,');
    Script.Add('  id_serie,');
    Script.Add('  titreserie,');
    Script.Add('  id_editeur,');
    Script.Add('  nomediteur,');
    Script.Add('  achat,');
    Script.Add('  complet)');
    Script.Add('as');
    Script.Add('select');
    Script.Add('  a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie, a.integrale, a.moisparution, a.anneeparution,');
    Script.Add('  a.notation, a.id_serie, a.titreserie, e.id_editeur, e.nomediteur, a.achat, a.complet');
    Script.Add('from');
    Script.Add('  vw_liste_albums a');
    Script.Add('  left join editions ed on ed.id_album = a.id_album');
    Script.Add('  left join editeurs e on e.id_editeur = ed.id_editeur');
    Script.Add(';');

    Script.Add('create or alter view vw_liste_genres_albums (');
    Script.Add('  id_album,');
    Script.Add('  titrealbum,');
    Script.Add('  tome,');
    Script.Add('  tomedebut,');
    Script.Add('  tomefin,');
    Script.Add('  horsserie,');
    Script.Add('  integrale,');
    Script.Add('  moisparution,');
    Script.Add('  anneeparution,');
    Script.Add('  notation,');
    Script.Add('  id_serie,');
    Script.Add('  titreserie,');
    Script.Add('  id_genre,');
    Script.Add('  genre,');
    Script.Add('  achat,');
    Script.Add('  complet)');
    Script.Add('as');
    Script.Add('select');
    Script.Add('  a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie, a.integrale, a.moisparution, a.anneeparution,');
    Script.Add('  a.notation, a.id_serie, a.titreserie, g.id_genre, g.genre, a.achat, a.complet');
    Script.Add('from');
    Script.Add('  vw_liste_albums a');
    Script.Add('  left join genreseries gs on gs.id_serie = a.id_serie');
    Script.Add('  left join genres g on gs.id_genre = g.id_genre');
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

    Script.Add('create or alter view vw_liste_parabd (');
    Script.Add('  id_parabd,');
    Script.Add('  titreparabd,');
    Script.Add('  id_serie,');
    Script.Add('  titreserie,');
    Script.Add('  achat,');
    Script.Add('  complet,');
    Script.Add('  scategorie)');
    Script.Add('as');
    Script.Add('select');
    Script.Add('  p.id_parabd, p.titreparabd, p.id_serie, s.titreserie, p.achat, p.complet, lc.libelle');
    Script.Add('from');
    Script.Add('  parabd p');
    Script.Add('  left join series s on s.id_serie = p.id_serie');
    Script.Add('  left join listes lc on lc.ref = p.categorieparabd and lc.categorie = 7');
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
    Script.Add('  initiale t_initiale_utf8)');
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

    Script.Add('create or alter procedure genres_albums (');
    Script.Add('  filtre varchar(125))');
    Script.Add('returns (');
    Script.Add('  genre type of column genres.genre,');
    Script.Add('  countgenre integer,');
    Script.Add('  id_genre type of column genres.id_genre)');
    Script.Add('as');
    Script.Add('declare variable swhere varchar(132);');
    Script.Add('begin');
    Script.Add('  swhere = '''';');
    Script.Add('  if (coalesce(filtre, '''') <> '''') then');
    Script.Add('    swhere = ''and '' || filtre;');
    Script.Add('');
    Script.Add('  for execute statement ''select');
    Script.Add('      cast(''''-1'''' as varchar(30)), count(id_album), null');
    Script.Add('    from');
    Script.Add('      vw_liste_genres_albums');
    Script.Add('    where');
    Script.Add('      id_genre is null '' || swhere || ''');
    Script.Add('    group by');
    Script.Add('      genre, id_genre''');
    Script.Add('        into :genre, :countgenre, :id_genre');
    Script.Add('  do');
    Script.Add('    suspend;');
    Script.Add('');
    Script.Add('  for execute statement ''select');
    Script.Add('      genre, count(id_album), id_genre');
    Script.Add('    from');
    Script.Add('      vw_liste_genres_albums');
    Script.Add('    where');
    Script.Add('      id_genre is not null '' || swhere || ''');
    Script.Add('    group by');
    Script.Add('      genre, id_genre''');
    Script.Add('        into :genre, :countgenre, :id_genre');
    Script.Add('  do');
    Script.Add('    suspend;');
    Script.Add('end;');

    Script.Add('create or alter procedure parabd_by_serie (');
    Script.Add('  in_id_serie type of column series.id_serie,');
    Script.Add('  filtre varchar(125))');
    Script.Add('returns (');
    Script.Add('  id_parabd type of column parabd.id_parabd,');
    Script.Add('  titreparabd type of column parabd.titreparabd,');
    Script.Add('  id_serie type of column series.id_serie,');
    Script.Add('  titreserie type of column series.titreserie,');
    Script.Add('  achat type of column albums.achat,');
    Script.Add('  complet type of column albums.complet,');
    Script.Add('  scategorie type of column listes.libelle)');
    Script.Add('as');
    Script.Add('declare variable swhere varchar(130);');
    Script.Add('begin');
    Script.Add('  if (:in_id_serie = cast('''' as t_guid)) then');
    Script.Add('    swhere = ''id_serie is null '';');
    Script.Add('  else');
    Script.Add('    swhere = ''id_serie = '''''' || :in_id_serie || '''''' '';');
    Script.Add('  if (coalesce(filtre, '''') <> '''') then');
    Script.Add('    swhere = swhere || ''and '' || filtre || '' '';');
    Script.Add('  for');
    Script.Add('    execute statement ''select');
    Script.Add('      id_parabd, titreparabd, id_parabd, titreserie, achat, complet, scategorie');
    Script.Add('    from');
    Script.Add('      vw_liste_parabd');
    Script.Add('    where');
    Script.Add('      '' || :swhere || ''');
    Script.Add('    order by');
    Script.Add('      titreparabd''');
    Script.Add('    into');
    Script.Add('      :id_parabd, :titreparabd, :id_serie, :titreserie, :achat, :complet, :scategorie');
    Script.Add('  do');
    Script.Add('    suspend;');
    Script.Add('end;');

    Script.Add('create or alter procedure proc_emprunts');
    Script.Add('returns (');
    Script.Add('  id_edition type of column editions.id_edition,');
    Script.Add('  id_album type of column albums.id_album,');
    Script.Add('  titrealbum type of column albums.titrealbum,');
    Script.Add('  id_serie type of column series.id_serie,');
    Script.Add('  titreserie type of column series.titreserie,');
    Script.Add('  prete type of column editions.prete,');
    Script.Add('  id_emprunteur type of column emprunteurs.id_emprunteur,');
    Script.Add('  nomemprunteur type of column emprunteurs.nomemprunteur,');
    Script.Add('  pretemprunt type of column statut.pretemprunt,');
    Script.Add('  dateemprunt type of column statut.dateemprunt)');
    Script.Add('as');
    Script.Add('begin');
    Script.Add('  for');
    Script.Add('    select');
    Script.Add('      ed.id_edition, a.id_album, a.titrealbum, a.id_serie, a.titreserie, ed.prete, e.id_emprunteur, e.nomemprunteur,');
    Script.Add('      s.pretemprunt, s.dateemprunt');
    Script.Add('    from');
    Script.Add('      vw_liste_albums a');
    Script.Add('      inner join editions ed on a.id_album = ed.id_album');
    Script.Add('      inner join statut s on ed.id_edition = s.id_edition');
    Script.Add('      inner join emprunteurs e on e.id_emprunteur = s.id_emprunteur');
    Script.Add('    order by');
    Script.Add('      s.dateemprunt desc');
    Script.Add('    into');
    Script.Add('      :id_edition, :id_album, :titrealbum, :id_serie, :titreserie, :prete, :id_emprunteur, :nomemprunteur, :pretemprunt,');
    Script.Add('      :dateemprunt');
    Script.Add('  do');
    Script.Add('  begin');
    Script.Add('    suspend;');
    Script.Add('  end');
    Script.Add('end;');

    Script.Add('create or alter view vw_liste_collections (');
    Script.Add('  id_collection,');
    Script.Add('  nomcollection,');
    Script.Add('  initialenomcollection,');
    Script.Add('  id_editeur,');
    Script.Add('  nomediteur)');
    Script.Add('as');
    Script.Add('select');
    Script.Add('  c.id_collection, c.nomcollection, c.initialenomcollection, e.id_editeur, e.nomediteur');
    Script.Add('from');
    Script.Add('  collections c');
    Script.Add('  inner join editeurs e on e.id_editeur = c.id_editeur');
    Script.Add(';');

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

    Script.Add('drop view vw_initiales_series;');
    Script.Add('create or alter view vw_initiales_series (');
    Script.Add('  initialetitreserie,');
    Script.Add('  countinitiale)');
    Script.Add('as');
    Script.Add('select');
    Script.Add('  initialetitreserie, count(id_serie)');
    Script.Add('from');
    Script.Add('  series');
    Script.Add('group by');
    Script.Add('  initialetitreserie');
    Script.Add(';');

    Script.Add('drop view vw_initiales_personnes;');
    Script.Add('create or alter view vw_initiales_personnes (');
    Script.Add('  initialenompersonne,');
    Script.Add('  countinitiale)');
    Script.Add('as');
    Script.Add('select');
    Script.Add('  initialenompersonne, count(id_personne)');
    Script.Add('from');
    Script.Add('  personnes');
    Script.Add('group by');
    Script.Add('  initialenompersonne');
    Script.Add(';');

    Script.Add('drop view vw_initiales_emprunteurs;');
    Script.Add('create or alter view vw_initiales_emprunteurs (');
    Script.Add('  initialenomemprunteur,');
    Script.Add('  countinitiale)');
    Script.Add('as');
    Script.Add('select');
    Script.Add('  initialenomemprunteur, count(id_emprunteur)');
    Script.Add('from');
    Script.Add('  emprunteurs');
    Script.Add('group by');
    Script.Add('  initialenomemprunteur');
    Script.Add(';');

    Script.Add('drop view vw_initiales_editeurs;');
    Script.Add('create or alter view vw_initiales_editeurs (');
    Script.Add('  initialenomediteur,');
    Script.Add('  countinitiale)');
    Script.Add('as');
    Script.Add('select');
    Script.Add('  initialenomediteur, count(id_editeur)');
    Script.Add('from');
    Script.Add('  editeurs');
    Script.Add('group by');
    Script.Add('  initialenomediteur');
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
    ProcessData('CONVERSIONS', 'MONNAIE1', 'ID_CONVERSION');
    ProcessData('CONVERSIONS', 'MONNAIE2', 'ID_CONVERSION');
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
