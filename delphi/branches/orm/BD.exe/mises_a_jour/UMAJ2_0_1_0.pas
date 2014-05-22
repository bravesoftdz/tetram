unit UMAJ2_0_1_0;

interface

implementation

uses UIB, Updates;

procedure MAJ2_0_1_0(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add('alter table editions add senslecture smallint;');

  Query.Script.Add('ALTER TRIGGER listes_aud0');
  Query.Script.Add('active after update or delete position 0');
  Query.Script.Add('as');
  Query.Script.Add('declare variable newvalue integer;');
  Query.Script.Add('begin');
  Query.Script.Add('  if (deleting) then newvalue = null;');
  Query.Script.Add('                else newvalue = new.ref;');
  Query.Script.Add('');
  Query.Script.Add('  if (old.categorie = 1) then update editions set etat = :newvalue where etat = old.ref;');
  Query.Script.Add('  if (old.categorie = 2) then update editions set reliure = :newvalue where reliure = old.ref;');
  Query.Script.Add('  if (old.categorie = 3) then update editions set typeedition = :newvalue where typeedition = old.ref;');
  Query.Script.Add('  if (old.categorie = 4) then update editions set orientation = :newvalue where orientation = old.ref;');
  Query.Script.Add('  if (old.categorie = 5) then update editions set formatedition = :newvalue where formatedition = old.ref;');
  Query.Script.Add('  if (old.categorie = 6) then update couvertures set categorieimage = :newvalue where categorieimage = old.ref;');
  Query.Script.Add('  if (old.categorie = 7) then update parabd set categorieparabd = :newvalue where categorieparabd = old.ref;');
  Query.Script.Add('  if (old.categorie = 8) then update editions set senslecture = :newvalue where senslecture = old.ref;');
  Query.Script.Add('end;');

  Query.Script.Add('INSERT INTO LISTES (REF, CATEGORIE, LIBELLE, ORDRE, DEFAUT) VALUES (1, 8, ''Gauche à droite'', 1, 1);');
  Query.Script.Add('INSERT INTO LISTES (REF, CATEGORIE, LIBELLE, ORDRE, DEFAUT) VALUES (2, 8, ''Droite à gauche'', 2, 0);');

  Query.Script.Add('create table criteres (');
  Query.Script.Add('    id_critere    t_guid_notnull,');
  Query.Script.Add('    type_critere  varchar(20),');
  Query.Script.Add('    refcritere    t_refnotnull,');
  Query.Script.Add('    critere       t_critere,');
  Query.Script.Add('    dc_critere    t_timestamp_notnull,');
  Query.Script.Add('    dm_critere    t_timestamp_notnull');
  Query.Script.Add(');');

  Query.Script.Add('create trigger criteres_biu0 for criteres');
  Query.Script.Add('active before insert or update position 0');
  Query.Script.Add('as');
  Query.Script.Add('begin');
  Query.Script.Add('  if (new.id_critere is null) then new.id_critere = old.id_critere;');
  Query.Script.Add('  if (new.id_critere is null) then new.id_critere = udf_createguid();');
  Query.Script.Add('');
  Query.Script.Add('  if (new.dc_critere is null) then new.dc_critere = old.dc_critere;');
  Query.Script.Add('');
  Query.Script.Add('  new.dm_critere = cast(''now'' as timestamp);');
  Query.Script.Add('  if (inserting or new.dc_critere is null) then new.dc_critere = new.dm_critere;');
  Query.Script.Add('end;');

  Query.Script.Add('delete from criteres;');
  Query.Script.Add('insert into criteres (id_critere, type_critere, refcritere, critere) select id_criteretitre, ''TITRE'', refcritere, critere from criteretitre;');
  Query.Script.Add('insert into criteres (id_critere, type_critere, refcritere, critere) select id_critereboolean, ''BOOL'', refcritere, critere from critereboolean;');
  Query.Script.Add('insert into criteres (id_critere, type_critere, refcritere, critere) select id_critereimage, ''IMAGE'', refcritere, critere from critereimage;');
  Query.Script.Add('insert into criteres (id_critere, type_critere, refcritere, critere) select id_criterelanguetitre, ''LANGUETITRE'', refcritere, critere from criterelanguetitre;');
  Query.Script.Add('insert into criteres (id_critere, type_critere, refcritere, critere) select id_critereliste, ''LISTE'', refcritere, critere from critereliste;');
  Query.Script.Add('insert into criteres (id_critere, type_critere, refcritere, critere) select id_criterenumeral, ''NUMERIC'', refcritere, critere from criterenumeral;');
  Query.Script.Add('insert into criteres (id_critere, type_critere, refcritere, critere) select id_criterestring, ''STRING'', refcritere, critere from criterestring;');

  Query.Script.Add('drop table criteretitre;');
  Query.Script.Add('drop table critereboolean;');
  Query.Script.Add('drop table critereimage;');
  Query.Script.Add('drop table criterelanguetitre;');
  Query.Script.Add('drop table critereliste;');
  Query.Script.Add('drop table criterenumeral;');
  Query.Script.Add('drop table criterestring;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('2.0.1.0', @MAJ2_0_1_0);

end.
