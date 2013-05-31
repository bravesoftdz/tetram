unit UMAJ2_0_1_0;

interface

implementation

uses UIB, Updates;

procedure MAJ2_0_1_0(Query: TUIBScript);
begin
  with Query do begin
    Script.Clear;

    Script.Add('alter table editions add senslecture smallint;');

    Script.Add('ALTER TRIGGER listes_aud0');
    Script.Add('active after update or delete position 0');
    Script.Add('as');
    Script.Add('declare variable newvalue integer;');
    Script.Add('begin');
    Script.Add('  if (deleting) then newvalue = null;');
    Script.Add('                else newvalue = new.ref;');
    Script.Add('');
    Script.Add('  if (old.categorie = 1) then update editions set etat = :newvalue where etat = old.ref;');
    Script.Add('  if (old.categorie = 2) then update editions set reliure = :newvalue where reliure = old.ref;');
    Script.Add('  if (old.categorie = 3) then update editions set typeedition = :newvalue where typeedition = old.ref;');
    Script.Add('  if (old.categorie = 4) then update editions set orientation = :newvalue where orientation = old.ref;');
    Script.Add('  if (old.categorie = 5) then update editions set formatedition = :newvalue where formatedition = old.ref;');
    Script.Add('  if (old.categorie = 6) then update couvertures set categorieimage = :newvalue where categorieimage = old.ref;');
    Script.Add('  if (old.categorie = 7) then update parabd set categorieparabd = :newvalue where categorieparabd = old.ref;');
    Script.Add('  if (old.categorie = 8) then update editions set senslecture = :newvalue where senslecture = old.ref;');
    Script.Add('end;');

    Script.Add('INSERT INTO LISTES (REF, CATEGORIE, LIBELLE, ORDRE, DEFAUT) VALUES (1, 8, ''Gauche à droite'', 1, 1);');
    Script.Add('INSERT INTO LISTES (REF, CATEGORIE, LIBELLE, ORDRE, DEFAUT) VALUES (2, 8, ''Droite à gauche'', 2, 0);');

    Script.Add('create table criteres (');
    Script.Add('    id_critere    t_guid_notnull,');
    Script.Add('    type_critere  varchar(20),');
    Script.Add('    refcritere    t_refnotnull,');
    Script.Add('    critere       t_critere,');
    Script.Add('    dc_critere    t_timestamp_notnull,');
    Script.Add('    dm_critere    t_timestamp_notnull');
    Script.Add(');');

    Script.Add('create trigger criteres_biu0 for criteres');
    Script.Add('active before insert or update position 0');
    Script.Add('as');
    Script.Add('begin');
    Script.Add('  if (new.id_critere is null) then new.id_critere = old.id_critere;');
    Script.Add('  if (new.id_critere is null) then new.id_critere = udf_createguid();');
    Script.Add('');
    Script.Add('  if (new.dc_critere is null) then new.dc_critere = old.dc_critere;');
    Script.Add('');
    Script.Add('  new.dm_critere = cast(''now'' as timestamp);');
    Script.Add('  if (inserting or new.dc_critere is null) then new.dc_critere = new.dm_critere;');
    Script.Add('end;');

    Script.Add('delete from criteres;');
    Script.Add('insert into criteres (id_critere, type_critere, refcritere, critere) select id_criteretitre, ''TITRE'', refcritere, critere from criteretitre;');
    Script.Add('insert into criteres (id_critere, type_critere, refcritere, critere) select id_critereboolean, ''BOOL'', refcritere, critere from critereboolean;');
    Script.Add('insert into criteres (id_critere, type_critere, refcritere, critere) select id_critereimage, ''IMAGE'', refcritere, critere from critereimage;');
    Script.Add('insert into criteres (id_critere, type_critere, refcritere, critere) select id_criterelanguetitre, ''LANGUETITRE'', refcritere, critere from criterelanguetitre;');
    Script.Add('insert into criteres (id_critere, type_critere, refcritere, critere) select id_critereliste, ''LISTE'', refcritere, critere from critereliste;');
    Script.Add('insert into criteres (id_critere, type_critere, refcritere, critere) select id_criterenumeral, ''NUMERIC'', refcritere, critere from criterenumeral;');
    Script.Add('insert into criteres (id_critere, type_critere, refcritere, critere) select id_criterestring, ''STRING'', refcritere, critere from criterestring;');

    Script.Add('drop table criteretitre;');
    Script.Add('drop table critereboolean;');
    Script.Add('drop table critereimage;');
    Script.Add('drop table criterelanguetitre;');
    Script.Add('drop table critereliste;');
    Script.Add('drop table criterenumeral;');
    Script.Add('drop table criterestring;');

    ExecuteScript;
  end;
end;

initialization
  RegisterFBUpdate('2.0.1.0', @MAJ2_0_1_0);

end.

