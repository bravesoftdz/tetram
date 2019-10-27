unit BDTK.Updates.v2_2_2_233;

interface

implementation

uses
  System.SysUtils, UIB, UIBLib, BDTK.Updates;

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
      qryDst.Execute;
      qrySrc.Next;
    end;
    Query.Transaction.Commit;
  end;

begin
  Query.Script.Clear;

  Query.Script.Add('create collation utf8_fr for utf8 from unicode ''LOCALE=fr_FR'';');
  Query.Script.Add('create collation utf8_fr_ci for utf8 from unicode_ci ''LOCALE=fr_FR'';');
  Query.Script.Add('create collation utf8_fr_ci_ai for utf8 from unicode_ci_ai ''LOCALE=fr_FR'';');

  Query.Script.Add('alter character set utf8 set default collation utf8_fr_ci_ai;');

  Query.Script.Add('update rdb$database set rdb$character_set_name = ''UTF8'';');
  Query.ExecuteScript;
  Query.Transaction.Commit;

  Query.Database.Connected := False;
  Query.Database.Connected := True;

  // exit;

  Query.Script.Clear;

  Query.Script.Add('create domain t_titre_utf8 as varchar (150) character set utf8 collate utf8_fr_ci_ai;');
  Query.Script.Add('create domain t_nom_utf8 as varchar (150) character set utf8 collate utf8_fr_ci_ai;');
  Query.Script.Add('create domain t_ident50_utf8 as varchar (50) character set utf8 collate utf8_fr_ci_ai;');
  Query.Script.Add('create domain t_description_utf8 as blob sub_type 1 segment size 80 character set utf8 collate utf8_fr_ci_ai;');
  Query.Script.Add('create domain t_initiale_utf8 as char (1) character set utf8 collate utf8_fr_ci_ai;');
  Query.Script.Add('create domain t_soundex_utf8 as varchar (30) character set utf8 collate utf8_fr_ci_ai;');

  Query.Script.Add('alter table albums alter initialetitrealbum type t_initiale_utf8;');
  Query.Script.Add('alter table albums alter soundextitrealbum type t_soundex_utf8;');
  Query.Script.Add('alter table albums alter titrealbum type t_titre_utf8;');
  Query.Script.Add('alter table collections alter initialenomcollection type t_initiale_utf8;');
  Query.Script.Add('alter table collections alter nomcollection type t_ident50_utf8;');
  Query.Script.Add('alter table editeurs alter initialenomediteur type t_initiale_utf8;');
  Query.Script.Add('alter table editeurs alter nomediteur type t_ident50_utf8;');
  Query.Script.Add('alter table emprunteurs alter initialenomemprunteur type t_initiale_utf8;');
  Query.Script.Add('alter table emprunteurs alter nomemprunteur type t_nom_utf8;');
  Query.Script.Add('alter table genres alter initialegenre type t_initiale_utf8;');
  Query.Script.Add('alter table parabd alter initialetitreparabd type t_initiale_utf8;');
  Query.Script.Add('alter table parabd alter titreparabd type t_titre_utf8;');
  Query.Script.Add('alter table parabd alter soundextitreparabd type t_soundex_utf8;');
  Query.Script.Add('alter table personnes alter initialenompersonne type t_initiale_utf8;');
  Query.Script.Add('alter table personnes alter nompersonne type t_titre_utf8;');
  Query.Script.Add('alter table series alter initialetitreserie type t_initiale_utf8;');
  Query.Script.Add('alter table series alter titreserie type t_titre_utf8;');
  Query.Script.Add('alter table series alter soundextitreserie type t_soundex_utf8;');

  Query.Script.Add('create or alter procedure parabd_by_serie (');
  Query.Script.Add('  in_id_serie char(38) character set none,');
  Query.Script.Add('  filtre varchar(125) character set none)');
  Query.Script.Add('returns (');
  Query.Script.Add('  id_parabd char(38) character set none,');
  Query.Script.Add('  titreparabd varchar(150),');
  Query.Script.Add('  id_serie char(38) character set none,');
  Query.Script.Add('  titreserie varchar(150),');
  Query.Script.Add('  achat smallint,');
  Query.Script.Add('  complet integer,');
  Query.Script.Add('  scategorie varchar(50) character set iso8859_1)');
  Query.Script.Add('as');
  Query.Script.Add('declare variable swhere varchar(130);');
  Query.Script.Add('begin');
  Query.Script.Add('  suspend;');
  Query.Script.Add('end;');

  Query.Script.Add('create or alter trigger genres_dv for genres');
  Query.Script.Add('active before insert or update position 0');
  Query.Script.Add('as');
  Query.Script.Add('begin');
  Query.Script.Add('  exit;');
  Query.Script.Add('end;');

  Query.Script.Add('create or alter procedure genres_by_initiale (');
  Query.Script.Add('  initiale t_initiale)');
  Query.Script.Add('returns (');
  Query.Script.Add('  id_genre char(38) character set none,');
  Query.Script.Add('  genre varchar(30) character set iso8859_1)');
  Query.Script.Add('as');
  Query.Script.Add('begin');
  Query.Script.Add('  suspend;');
  Query.Script.Add('end;');

  Query.Script.Add('create or alter procedure genres_albums (');
  Query.Script.Add('  filtre varchar(125) character set none)');
  Query.Script.Add('returns (');
  Query.Script.Add('  genre varchar(30) character set iso8859_1,');
  Query.Script.Add('  countgenre integer,');
  Query.Script.Add('  id_genre char(38) character set none)');
  Query.Script.Add('as');
  Query.Script.Add('declare variable swhere varchar(132);');
  Query.Script.Add('begin');
  Query.Script.Add('  suspend;');
  Query.Script.Add('end;');

  Query.Script.Add('create or alter procedure proc_emprunts');
  Query.Script.Add('returns (');
  Query.Script.Add('  id_edition char(38),');
  Query.Script.Add('  id_album char(38),');
  Query.Script.Add('  titrealbum varchar(150),');
  Query.Script.Add('  id_serie char(38),');
  Query.Script.Add('  titreserie varchar(150),');
  Query.Script.Add('  prete smallint,');
  Query.Script.Add('  id_emprunteur char(38),');
  Query.Script.Add('  nomemprunteur varchar(150),');
  Query.Script.Add('  pretemprunt smallint,');
  Query.Script.Add('  dateemprunt timestamp)');
  Query.Script.Add('as');
  Query.Script.Add('begin');
  Query.Script.Add('  suspend;');
  Query.Script.Add('end;');

  Query.Script.Add('drop view vw_dernieres_modifs;');
  Query.Script.Add('drop view vw_initiales_genres;');
  Query.Script.Add('drop view vw_liste_parabd;');

  Query.Script.Add('drop view vw_liste_genres_albums;');
  Query.Script.Add('drop view vw_liste_editeurs_albums;');
  Query.Script.Add('drop view vw_liste_editeurs_achatalbums;');
  Query.Script.Add('drop view vw_liste_collections_albums;');
  Query.Script.Add('drop view vw_emprunts;');
  Query.Script.Add('drop view vw_liste_albums;');

  Query.Script.Add('alter table albums');
  Query.Script.Add('  alter sujetalbum to old_sujetalbum,');
  Query.Script.Add('  add sujetalbum t_description_utf8,');
  Query.Script.Add('  alter remarquesalbum to old_remarquesalbum,');
  Query.Script.Add('  add remarquesalbum t_description_utf8;');
  Query.Script.Add('update albums set sujetalbum = old_sujetalbum, remarquesalbum = old_remarquesalbum;');
  Query.Script.Add('alter table albums drop old_sujetalbum, drop old_remarquesalbum;');

  Query.Script.Add('alter table couvertures');
  Query.Script.Add('  alter fichiercouverture to old_fichiercouverture,');
  Query.Script.Add('  add fichiercouverture varchar(255);');

  Query.Script.Add('alter table editeurs');
  Query.Script.Add('  alter siteweb to old_siteweb,');
  Query.Script.Add('  add siteweb varchar(255);');

  Query.Script.Add('alter table editions');
  Query.Script.Add('  alter isbn to old_isbn,');
  Query.Script.Add('  alter numeroperso to old_numeroperso,');
  Query.Script.Add('  add isbn char(13),');
  Query.Script.Add('  add numeroperso varchar(25),');
  Query.Script.Add('  alter notes to old_notes,');
  Query.Script.Add('  add notes t_description_utf8;');
  Query.Script.Add('update editions set notes = old_notes;');
  Query.Script.Add('alter table editions drop old_notes;');

  Query.Script.Add('alter table emprunteurs');
  Query.Script.Add('  alter adresseemprunteur to old_adresseemprunteur,');
  Query.Script.Add('  add adresseemprunteur t_description_utf8;');
  Query.Script.Add('update emprunteurs set adresseemprunteur = old_adresseemprunteur;');
  Query.Script.Add('alter table emprunteurs drop old_adresseemprunteur;');

  Query.Script.Add('alter table genres');
  Query.Script.Add('  alter initialegenre to old_initialegenre,');
  Query.Script.Add('  add initialegenre t_initiale_utf8,');
  Query.Script.Add('  alter genre to old_genre,');
  Query.Script.Add('  add genre varchar(30);');
  Query.Script.Add('update genres set genre = old_genre;');
  Query.Script.Add('drop index genres_idx2;');
  Query.Script.Add('create index genres_idx2 on genres (genre);');
  Query.Script.Add('drop index genres_idx3;');
  Query.Script.Add('create index genres_idx3 on genres (initialegenre, id_genre);');
  Query.Script.Add('alter table genres drop old_genre;');

  Query.Script.Add('alter table options drop constraint options_pk;');
  Query.Script.Add('alter table options');
  Query.Script.Add('  alter valeur to old_valeur,');
  Query.Script.Add('  add valeur varchar(255),');
  Query.Script.Add('  alter nom_option to old_nom_option,');
  Query.Script.Add('  add nom_option varchar (15) not null;');
  Query.Script.Add('update options set nom_option = old_nom_option;');
  Query.Script.Add('alter table options drop old_nom_option;');
  Query.Script.Add('alter table options add constraint options_pk primary key(nom_option) using index options_pk;');

  Query.Script.Add('alter table conversions');
  Query.Script.Add('  alter monnaie1 to old_monnaie1,');
  Query.Script.Add('  alter monnaie2 to old_monnaie2,');
  Query.Script.Add('  add monnaie1 varchar(5),');
  Query.Script.Add('  add monnaie2 varchar(5);');

  Query.Script.Add('alter table options_scripts drop constraint options_scripts_pk;');
  Query.Script.Add('alter table options_scripts');
  Query.Script.Add('  alter valeur to old_valeur,');
  Query.Script.Add('  add valeur varchar(255),');
  Query.Script.Add('  alter nom_option to old_nom_option,');
  Query.Script.Add('  add nom_option varchar (50) not null,');
  Query.Script.Add('  alter script to old_script,');
  Query.Script.Add('  add script varchar (50) not null;');
  Query.Script.Add('update options_scripts set');
  Query.Script.Add('  script = old_script,');
  Query.Script.Add('  nom_option = old_nom_option;');
  Query.Script.Add('alter table options_scripts drop old_nom_option, drop old_script;');
  Query.Script.Add('alter table options_scripts add constraint options_scripts_pk primary key(script, nom_option) using index options_scripts_pk;');

  Query.Script.Add('alter table parabd');
  Query.Script.Add('  alter fichierparabd to old_fichierparabd,');
  Query.Script.Add('  add fichierparabd varchar(255),');
  Query.Script.Add('  alter description to old_description,');
  Query.Script.Add('  add description t_description_utf8;');
  Query.Script.Add('update parabd set description = old_description;');
  Query.Script.Add('alter table parabd drop old_description;');

  Query.Script.Add('alter table personnes');
  Query.Script.Add('  alter siteweb to old_siteweb,');
  Query.Script.Add('  add siteweb varchar(255),');
  Query.Script.Add('  alter biographie to old_biographie,');
  Query.Script.Add('  add biographie t_description_utf8;');
  Query.Script.Add('update personnes set biographie = old_biographie;');
  Query.Script.Add('alter table personnes drop old_biographie;');

  Query.Script.Add('alter table series');
  Query.Script.Add('  alter siteweb to old_siteweb,');
  Query.Script.Add('  add siteweb varchar(255),');
  Query.Script.Add('  alter sujetserie to old_sujetserie,');
  Query.Script.Add('  add sujetserie t_description_utf8,');
  Query.Script.Add('  alter remarquesserie to old_remarquesserie,');
  Query.Script.Add('  add remarquesserie t_description_utf8;');
  Query.Script.Add('update series set sujetserie = old_sujetserie, remarquesserie = old_remarquesserie;');
  Query.Script.Add('alter table series drop old_sujetserie, drop old_remarquesserie;');

  Query.Script.Add('alter table suppressions');
  Query.Script.Add('  alter tablename type rdb$relation_name,');
  Query.Script.Add('  alter fieldname type rdb$field_name;');

  Query.Script.Add('alter table criteres');
  Query.Script.Add('  alter critere to old_critere,');
  Query.Script.Add('  add critere varchar(20);');
  Query.Script.Add('update criteres set critere = old_critere;');
  Query.Script.Add('alter table criteres');
  Query.Script.Add('  drop old_critere;');

  Query.Script.Add('alter table listes');
  Query.Script.Add('  alter libelle to old_libelle,');
  Query.Script.Add('  add libelle varchar(50);');
  Query.Script.Add('update listes set libelle = old_libelle;');
  Query.Script.Add('alter table listes');
  Query.Script.Add('  drop old_libelle;');

  Query.Script.Add('alter table import_associations drop constraint pk_import_associations;');
  Query.Script.Add('alter table import_associations alter chaine to old_chaine, add chaine varchar (100) not null;');
  Query.Script.Add('update import_associations set');
  Query.Script.Add('  chaine = substring(old_chaine from 1 for 100);');
  Query.Script.Add('alter table import_associations drop old_chaine;');
  Query.Script.Add
    ('alter table import_associations add constraint pk_import_associations primary key(chaine, typedata, parentid) using index pk_import_associations;');

  Query.Script.Add('create or alter view vw_liste_albums (');
  Query.Script.Add('  id_album,');
  Query.Script.Add('  titrealbum,');
  Query.Script.Add('  tome,');
  Query.Script.Add('  tomedebut,');
  Query.Script.Add('  tomefin,');
  Query.Script.Add('  horsserie,');
  Query.Script.Add('  integrale,');
  Query.Script.Add('  moisparution,');
  Query.Script.Add('  anneeparution,');
  Query.Script.Add('  id_serie,');
  Query.Script.Add('  titreserie,');
  Query.Script.Add('  achat,');
  Query.Script.Add('  complet,');
  Query.Script.Add('  notation,');
  Query.Script.Add('  initialetitrealbum,');
  Query.Script.Add('  initialetitreserie)');
  Query.Script.Add('as');
  Query.Script.Add('select');
  Query.Script.Add('  a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie, a.integrale, a.moisparution, a.anneeparution,');
  Query.Script.Add('  a.id_serie, s.titreserie, a.achat, a.complet, a.notation, coalesce(a.initialetitrealbum, s.initialetitreserie),');
  Query.Script.Add('  s.initialetitreserie');
  Query.Script.Add('from');
  Query.Script.Add('  albums a');
  Query.Script.Add('  left join series s on s.id_serie = a.id_serie');
  Query.Script.Add(';');

  Query.Script.Add('create view vw_emprunts (');
  Query.Script.Add('  id_statut,');
  Query.Script.Add('  id_edition,');
  Query.Script.Add('  id_album,');
  Query.Script.Add('  titrealbum,');
  Query.Script.Add('  id_serie,');
  Query.Script.Add('  tome,');
  Query.Script.Add('  integrale,');
  Query.Script.Add('  tomedebut,');
  Query.Script.Add('  tomefin,');
  Query.Script.Add('  horsserie,');
  Query.Script.Add('  notation,');
  Query.Script.Add('  titreserie,');
  Query.Script.Add('  id_editeur,');
  Query.Script.Add('  nomediteur,');
  Query.Script.Add('  id_collection,');
  Query.Script.Add('  nomcollection,');
  Query.Script.Add('  prete,');
  Query.Script.Add('  anneeedition,');
  Query.Script.Add('  isbn,');
  Query.Script.Add('  id_emprunteur,');
  Query.Script.Add('  nomemprunteur,');
  Query.Script.Add('  pretemprunt,');
  Query.Script.Add('  dateemprunt)');
  Query.Script.Add('as');
  Query.Script.Add('select');
  Query.Script.Add('  s.id_statut, ed.id_edition, a.id_album, a.titrealbum, a.id_serie, a.tome, a.integrale, a.tomedebut, a.tomefin,');
  Query.Script.Add('  a.horsserie, a.notation, a.titreserie, e.id_editeur, e.nomediteur, c.id_collection, c.nomcollection, ed.prete,');
  Query.Script.Add('  ed.anneeedition, ed.isbn, em.id_emprunteur, em.nomemprunteur, s.pretemprunt, s.dateemprunt');
  Query.Script.Add('from');
  Query.Script.Add('  vw_liste_albums a');
  Query.Script.Add('  inner join editions ed on a.id_album = ed.id_album');
  Query.Script.Add('  inner join editeurs e on e.id_editeur = ed.id_editeur');
  Query.Script.Add('  left join collections c on c.id_collection = ed.id_collection');
  Query.Script.Add('  inner join statut s on ed.id_edition = s.id_edition');
  Query.Script.Add('  inner join emprunteurs em on em.id_emprunteur = s.id_emprunteur');
  Query.Script.Add(';');

  Query.Script.Add('create view vw_liste_collections_albums (');
  Query.Script.Add('  id_album,');
  Query.Script.Add('  titrealbum,');
  Query.Script.Add('  tome,');
  Query.Script.Add('  tomedebut,');
  Query.Script.Add('  tomefin,');
  Query.Script.Add('  horsserie,');
  Query.Script.Add('  integrale,');
  Query.Script.Add('  moisparution,');
  Query.Script.Add('  anneeparution,');
  Query.Script.Add('  notation,');
  Query.Script.Add('  id_serie,');
  Query.Script.Add('  titreserie,');
  Query.Script.Add('  id_editeur,');
  Query.Script.Add('  nomediteur,');
  Query.Script.Add('  id_collection,');
  Query.Script.Add('  nomcollection,');
  Query.Script.Add('  achat,');
  Query.Script.Add('  complet)');
  Query.Script.Add('as');
  Query.Script.Add('select');
  Query.Script.Add('  a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie, a.integrale, a.moisparution, a.anneeparution,');
  Query.Script.Add('  a.notation, a.id_serie, a.titreserie, e.id_editeur, e.nomediteur, c.id_collection, c.nomcollection, a.achat,');
  Query.Script.Add('  a.complet');
  Query.Script.Add('from');
  Query.Script.Add('  vw_liste_albums a');
  Query.Script.Add('  left join editions ed on ed.id_album = a.id_album');
  Query.Script.Add('  left join collections c on ed.id_collection = c.id_collection');
  Query.Script.Add('  left join editeurs e on e.id_editeur = ed.id_editeur');
  Query.Script.Add(';');

  Query.Script.Add('create view vw_liste_editeurs_achatalbums (');
  Query.Script.Add('  id_album,');
  Query.Script.Add('  titrealbum,');
  Query.Script.Add('  tome,');
  Query.Script.Add('  tomedebut,');
  Query.Script.Add('  tomefin,');
  Query.Script.Add('  horsserie,');
  Query.Script.Add('  integrale,');
  Query.Script.Add('  moisparution,');
  Query.Script.Add('  anneeparution,');
  Query.Script.Add('  notation,');
  Query.Script.Add('  id_serie,');
  Query.Script.Add('  titreserie,');
  Query.Script.Add('  id_editeur,');
  Query.Script.Add('  nomediteur,');
  Query.Script.Add('  achat,');
  Query.Script.Add('  complet)');
  Query.Script.Add('as');
  Query.Script.Add('select');
  Query.Script.Add('  a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie, a.integrale, a.moisparution, a.anneeparution,');
  Query.Script.Add('  a.notation, a.id_serie, a.titreserie, e.id_editeur, e.nomediteur, a.achat, a.complet');
  Query.Script.Add('from');
  Query.Script.Add('  vw_liste_albums a');
  Query.Script.Add('  left join series s on s.id_serie = a.id_serie');
  Query.Script.Add('  left join editeurs e on e.id_editeur = s.id_editeur');
  Query.Script.Add(';');

  Query.Script.Add('create view vw_liste_editeurs_albums (');
  Query.Script.Add('  id_album,');
  Query.Script.Add('  titrealbum,');
  Query.Script.Add('  tome,');
  Query.Script.Add('  tomedebut,');
  Query.Script.Add('  tomefin,');
  Query.Script.Add('  horsserie,');
  Query.Script.Add('  integrale,');
  Query.Script.Add('  moisparution,');
  Query.Script.Add('  anneeparution,');
  Query.Script.Add('  notation,');
  Query.Script.Add('  id_serie,');
  Query.Script.Add('  titreserie,');
  Query.Script.Add('  id_editeur,');
  Query.Script.Add('  nomediteur,');
  Query.Script.Add('  achat,');
  Query.Script.Add('  complet)');
  Query.Script.Add('as');
  Query.Script.Add('select');
  Query.Script.Add('  a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie, a.integrale, a.moisparution, a.anneeparution,');
  Query.Script.Add('  a.notation, a.id_serie, a.titreserie, e.id_editeur, e.nomediteur, a.achat, a.complet');
  Query.Script.Add('from');
  Query.Script.Add('  vw_liste_albums a');
  Query.Script.Add('  left join editions ed on ed.id_album = a.id_album');
  Query.Script.Add('  left join editeurs e on e.id_editeur = ed.id_editeur');
  Query.Script.Add(';');

  Query.Script.Add('create or alter view vw_liste_genres_albums (');
  Query.Script.Add('  id_album,');
  Query.Script.Add('  titrealbum,');
  Query.Script.Add('  tome,');
  Query.Script.Add('  tomedebut,');
  Query.Script.Add('  tomefin,');
  Query.Script.Add('  horsserie,');
  Query.Script.Add('  integrale,');
  Query.Script.Add('  moisparution,');
  Query.Script.Add('  anneeparution,');
  Query.Script.Add('  notation,');
  Query.Script.Add('  id_serie,');
  Query.Script.Add('  titreserie,');
  Query.Script.Add('  id_genre,');
  Query.Script.Add('  genre,');
  Query.Script.Add('  achat,');
  Query.Script.Add('  complet)');
  Query.Script.Add('as');
  Query.Script.Add('select');
  Query.Script.Add('  a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie, a.integrale, a.moisparution, a.anneeparution,');
  Query.Script.Add('  a.notation, a.id_serie, a.titreserie, g.id_genre, g.genre, a.achat, a.complet');
  Query.Script.Add('from');
  Query.Script.Add('  vw_liste_albums a');
  Query.Script.Add('  left join genreseries gs on gs.id_serie = a.id_serie');
  Query.Script.Add('  left join genres g on gs.id_genre = g.id_genre');
  Query.Script.Add(';');

  Query.Script.Add('create or alter view vw_initiales_genres (');
  Query.Script.Add('  initialegenre,');
  Query.Script.Add('  countinitiale)');
  Query.Script.Add('as');
  Query.Script.Add('select');
  Query.Script.Add('  initialegenre, count(id_genre)');
  Query.Script.Add('from');
  Query.Script.Add('  genres');
  Query.Script.Add('group by');
  Query.Script.Add('  initialegenre');
  Query.Script.Add(';');

  Query.Script.Add('create or alter view vw_liste_parabd (');
  Query.Script.Add('  id_parabd,');
  Query.Script.Add('  titreparabd,');
  Query.Script.Add('  id_serie,');
  Query.Script.Add('  titreserie,');
  Query.Script.Add('  achat,');
  Query.Script.Add('  complet,');
  Query.Script.Add('  scategorie)');
  Query.Script.Add('as');
  Query.Script.Add('select');
  Query.Script.Add('  p.id_parabd, p.titreparabd, p.id_serie, s.titreserie, p.achat, p.complet, lc.libelle');
  Query.Script.Add('from');
  Query.Script.Add('  parabd p');
  Query.Script.Add('  left join series s on s.id_serie = p.id_serie');
  Query.Script.Add('  left join listes lc on lc.ref = p.categorieparabd and lc.categorie = 7');
  Query.Script.Add(';');

  Query.Script.Add('create or alter trigger genres_dv for genres');
  Query.Script.Add('active before insert or update position 0');
  Query.Script.Add('as');
  Query.Script.Add('begin');
  Query.Script.Add('  if (inserting or new.genre <> old.genre) then');
  Query.Script.Add('  begin');
  Query.Script.Add('    select');
  Query.Script.Add('      initiale');
  Query.Script.Add('    from');
  Query.Script.Add('      get_initiale(new.genre)');
  Query.Script.Add('    into');
  Query.Script.Add('      new.initialegenre;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.Script.Add('create or alter procedure genres_by_initiale (');
  Query.Script.Add('  initiale t_initiale_utf8)');
  Query.Script.Add('returns (');
  Query.Script.Add('  id_genre type of column genres.id_genre,');
  Query.Script.Add('  genre type of column genres.genre)');
  Query.Script.Add('as');
  Query.Script.Add('begin');
  Query.Script.Add('  for');
  Query.Script.Add('    select');
  Query.Script.Add('      id_genre, genre');
  Query.Script.Add('    from');
  Query.Script.Add('      genres');
  Query.Script.Add('    where');
  Query.Script.Add('      initialegenre = :initiale');
  Query.Script.Add('    order by');
  Query.Script.Add('      genre');
  Query.Script.Add('    into');
  Query.Script.Add('      :id_genre, :genre');
  Query.Script.Add('  do');
  Query.Script.Add('    suspend;');
  Query.Script.Add('end;');

  Query.Script.Add('create or alter procedure genres_albums (');
  Query.Script.Add('  filtre varchar(125))');
  Query.Script.Add('returns (');
  Query.Script.Add('  genre type of column genres.genre,');
  Query.Script.Add('  countgenre integer,');
  Query.Script.Add('  id_genre type of column genres.id_genre)');
  Query.Script.Add('as');
  Query.Script.Add('declare variable swhere varchar(132);');
  Query.Script.Add('begin');
  Query.Script.Add('  swhere = '''';');
  Query.Script.Add('  if (coalesce(filtre, '''') <> '''') then');
  Query.Script.Add('    swhere = ''and '' || filtre;');
  Query.Script.Add('');
  Query.Script.Add('  for execute statement ''select');
  Query.Script.Add('      cast(''''-1'''' as varchar(30)), count(id_album), null');
  Query.Script.Add('    from');
  Query.Script.Add('      vw_liste_genres_albums');
  Query.Script.Add('    where');
  Query.Script.Add('      id_genre is null '' || swhere || ''');
  Query.Script.Add('    group by');
  Query.Script.Add('      genre, id_genre''');
  Query.Script.Add('        into :genre, :countgenre, :id_genre');
  Query.Script.Add('  do');
  Query.Script.Add('    suspend;');
  Query.Script.Add('');
  Query.Script.Add('  for execute statement ''select');
  Query.Script.Add('      genre, count(id_album), id_genre');
  Query.Script.Add('    from');
  Query.Script.Add('      vw_liste_genres_albums');
  Query.Script.Add('    where');
  Query.Script.Add('      id_genre is not null '' || swhere || ''');
  Query.Script.Add('    group by');
  Query.Script.Add('      genre, id_genre''');
  Query.Script.Add('        into :genre, :countgenre, :id_genre');
  Query.Script.Add('  do');
  Query.Script.Add('    suspend;');
  Query.Script.Add('end;');

  Query.Script.Add('create or alter procedure parabd_by_serie (');
  Query.Script.Add('  in_id_serie type of column series.id_serie,');
  Query.Script.Add('  filtre varchar(125))');
  Query.Script.Add('returns (');
  Query.Script.Add('  id_parabd type of column parabd.id_parabd,');
  Query.Script.Add('  titreparabd type of column parabd.titreparabd,');
  Query.Script.Add('  id_serie type of column series.id_serie,');
  Query.Script.Add('  titreserie type of column series.titreserie,');
  Query.Script.Add('  achat type of column albums.achat,');
  Query.Script.Add('  complet type of column albums.complet,');
  Query.Script.Add('  scategorie type of column listes.libelle)');
  Query.Script.Add('as');
  Query.Script.Add('declare variable swhere varchar(130);');
  Query.Script.Add('begin');
  Query.Script.Add('  if (:in_id_serie = cast('''' as t_guid)) then');
  Query.Script.Add('    swhere = ''id_serie is null '';');
  Query.Script.Add('  else');
  Query.Script.Add('    swhere = ''id_serie = '''''' || :in_id_serie || '''''' '';');
  Query.Script.Add('  if (coalesce(filtre, '''') <> '''') then');
  Query.Script.Add('    swhere = swhere || ''and '' || filtre || '' '';');
  Query.Script.Add('  for');
  Query.Script.Add('    execute statement ''select');
  Query.Script.Add('      id_parabd, titreparabd, id_parabd, titreserie, achat, complet, scategorie');
  Query.Script.Add('    from');
  Query.Script.Add('      vw_liste_parabd');
  Query.Script.Add('    where');
  Query.Script.Add('      '' || :swhere || ''');
  Query.Script.Add('    order by');
  Query.Script.Add('      titreparabd''');
  Query.Script.Add('    into');
  Query.Script.Add('      :id_parabd, :titreparabd, :id_serie, :titreserie, :achat, :complet, :scategorie');
  Query.Script.Add('  do');
  Query.Script.Add('    suspend;');
  Query.Script.Add('end;');

  Query.Script.Add('create or alter procedure proc_emprunts');
  Query.Script.Add('returns (');
  Query.Script.Add('  id_edition type of column editions.id_edition,');
  Query.Script.Add('  id_album type of column albums.id_album,');
  Query.Script.Add('  titrealbum type of column albums.titrealbum,');
  Query.Script.Add('  id_serie type of column series.id_serie,');
  Query.Script.Add('  titreserie type of column series.titreserie,');
  Query.Script.Add('  prete type of column editions.prete,');
  Query.Script.Add('  id_emprunteur type of column emprunteurs.id_emprunteur,');
  Query.Script.Add('  nomemprunteur type of column emprunteurs.nomemprunteur,');
  Query.Script.Add('  pretemprunt type of column statut.pretemprunt,');
  Query.Script.Add('  dateemprunt type of column statut.dateemprunt)');
  Query.Script.Add('as');
  Query.Script.Add('begin');
  Query.Script.Add('  for');
  Query.Script.Add('    select');
  Query.Script.Add('      ed.id_edition, a.id_album, a.titrealbum, a.id_serie, a.titreserie, ed.prete, e.id_emprunteur, e.nomemprunteur,');
  Query.Script.Add('      s.pretemprunt, s.dateemprunt');
  Query.Script.Add('    from');
  Query.Script.Add('      vw_liste_albums a');
  Query.Script.Add('      inner join editions ed on a.id_album = ed.id_album');
  Query.Script.Add('      inner join statut s on ed.id_edition = s.id_edition');
  Query.Script.Add('      inner join emprunteurs e on e.id_emprunteur = s.id_emprunteur');
  Query.Script.Add('    order by');
  Query.Script.Add('      s.dateemprunt desc');
  Query.Script.Add('    into');
  Query.Script.Add('      :id_edition, :id_album, :titrealbum, :id_serie, :titreserie, :prete, :id_emprunteur, :nomemprunteur, :pretemprunt,');
  Query.Script.Add('      :dateemprunt');
  Query.Script.Add('  do');
  Query.Script.Add('  begin');
  Query.Script.Add('    suspend;');
  Query.Script.Add('  end');
  Query.Script.Add('end;');

  Query.Script.Add('create or alter view vw_liste_collections (');
  Query.Script.Add('  id_collection,');
  Query.Script.Add('  nomcollection,');
  Query.Script.Add('  initialenomcollection,');
  Query.Script.Add('  id_editeur,');
  Query.Script.Add('  nomediteur)');
  Query.Script.Add('as');
  Query.Script.Add('select');
  Query.Script.Add('  c.id_collection, c.nomcollection, c.initialenomcollection, e.id_editeur, e.nomediteur');
  Query.Script.Add('from');
  Query.Script.Add('  collections c');
  Query.Script.Add('  inner join editeurs e on e.id_editeur = c.id_editeur');
  Query.Script.Add(';');

  Query.Script.Add('create or alter view vw_dernieres_modifs (');
  Query.Script.Add('  typedata,');
  Query.Script.Add('  date_creation,');
  Query.Script.Add('  date_modif,');
  Query.Script.Add('  id,');
  Query.Script.Add('  titrealbum,');
  Query.Script.Add('  tome,');
  Query.Script.Add('  tomedebut,');
  Query.Script.Add('  tomefin,');
  Query.Script.Add('  integrale,');
  Query.Script.Add('  horsserie,');
  Query.Script.Add('  titreserie,');
  Query.Script.Add('  nomediteur,');
  Query.Script.Add('  nomcollection,');
  Query.Script.Add('  nompersonne)');
  Query.Script.Add('as');
  Query.Script.Add('select');
  Query.Script.Add('  ''A'', a.dc_albums, a.dm_albums, a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.integrale, a.horsserie,');
  Query.Script.Add('  s.titreserie, null, null, null');
  Query.Script.Add('from');
  Query.Script.Add('  albums a');
  Query.Script.Add('  left join series s on a.id_serie = s.id_serie');
  Query.Script.Add('');
  Query.Script.Add('union');
  Query.Script.Add('');
  Query.Script.Add('select');
  Query.Script.Add('  ''S'', s.dc_series, s.dm_series, s.id_serie, null, null, null, null, null, null, s.titreserie, e.nomediteur,');
  Query.Script.Add('  c.nomcollection, null');
  Query.Script.Add('from');
  Query.Script.Add('  series s');
  Query.Script.Add('  left join editeurs e on e.id_editeur = s.id_editeur');
  Query.Script.Add('  left join collections c on c.id_collection = s.id_collection');
  Query.Script.Add('');
  Query.Script.Add('union');
  Query.Script.Add('');
  Query.Script.Add('select');
  Query.Script.Add('  ''P'', p.dc_personnes, p.dm_personnes, p.id_personne, null, null, null, null, null, null, null, null, null,');
  Query.Script.Add('  p.nompersonne');
  Query.Script.Add('from');
  Query.Script.Add('  personnes p');
  Query.Script.Add(';');

  Query.Script.Add('drop view vw_initiales_series;');
  Query.Script.Add('create or alter view vw_initiales_series (');
  Query.Script.Add('  initialetitreserie,');
  Query.Script.Add('  countinitiale)');
  Query.Script.Add('as');
  Query.Script.Add('select');
  Query.Script.Add('  initialetitreserie, count(id_serie)');
  Query.Script.Add('from');
  Query.Script.Add('  series');
  Query.Script.Add('group by');
  Query.Script.Add('  initialetitreserie');
  Query.Script.Add(';');

  Query.Script.Add('drop view vw_initiales_personnes;');
  Query.Script.Add('create or alter view vw_initiales_personnes (');
  Query.Script.Add('  initialenompersonne,');
  Query.Script.Add('  countinitiale)');
  Query.Script.Add('as');
  Query.Script.Add('select');
  Query.Script.Add('  initialenompersonne, count(id_personne)');
  Query.Script.Add('from');
  Query.Script.Add('  personnes');
  Query.Script.Add('group by');
  Query.Script.Add('  initialenompersonne');
  Query.Script.Add(';');

  Query.Script.Add('drop view vw_initiales_emprunteurs;');
  Query.Script.Add('create or alter view vw_initiales_emprunteurs (');
  Query.Script.Add('  initialenomemprunteur,');
  Query.Script.Add('  countinitiale)');
  Query.Script.Add('as');
  Query.Script.Add('select');
  Query.Script.Add('  initialenomemprunteur, count(id_emprunteur)');
  Query.Script.Add('from');
  Query.Script.Add('  emprunteurs');
  Query.Script.Add('group by');
  Query.Script.Add('  initialenomemprunteur');
  Query.Script.Add(';');

  Query.Script.Add('drop view vw_initiales_editeurs;');
  Query.Script.Add('create or alter view vw_initiales_editeurs (');
  Query.Script.Add('  initialenomediteur,');
  Query.Script.Add('  countinitiale)');
  Query.Script.Add('as');
  Query.Script.Add('select');
  Query.Script.Add('  initialenomediteur, count(id_editeur)');
  Query.Script.Add('from');
  Query.Script.Add('  editeurs');
  Query.Script.Add('group by');
  Query.Script.Add('  initialenomediteur');
  Query.Script.Add(';');

  Query.ExecuteScript;

  Query.Transaction.Commit;

  dbNone := TUIBDatabase.Create(nil);
  qrySrc := TUIBQuery.Create(Query.Transaction);
  qryDst := TUIBQuery.Create(Query.Transaction);
  try
    dbNone.LibraryName := Query.Database.LibraryName;
    dbNone.DatabaseName := Query.Database.DatabaseName;
    dbNone.Params.Assign(Query.Database.Params);
    dbNone.CharacterSet := csNONE;

    dbNone.Connected := True;

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
