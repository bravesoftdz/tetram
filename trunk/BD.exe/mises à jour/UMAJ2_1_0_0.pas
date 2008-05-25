unit UMAJ2_1_0_0;

interface

implementation

uses JvUIB, Updates;

procedure MAJ2_1_0_0(Query: TJvUIBScript);
begin
  with Query do
  begin
    Script.Clear;

    Script.Add('CREATE TABLE SUPPRESSIONS (');
    Script.Add('    id_suppression T_GUID_NOTNULL,');
    Script.Add('    TABLENAME VARCHAR(31),');
    Script.Add('    FIELDNAME VARCHAR(31),');
    Script.Add('    ID T_GUID_NOTNULL,');
    Script.Add('    DC_SUPPRESSIONS T_TIMESTAMP_NOTNULL,');
    Script.Add('    DM_SUPPRESSIONS T_TIMESTAMP_NOTNULL);');

    Script.Add('CREATE trigger suppressions_UNIQID_BIU0 for suppressions');
    Script.Add('active before insert or update position 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  if (new.id_suppression is null) then new.id_suppression = old.id_suppression;');
    Script.Add('  if (new.id_suppression is null) then new.id_suppression = UDF_CREATEGUID();');
    Script.Add('');
    Script.Add('  if (new.dc_suppressions is null) then new.dc_suppressions = old.dc_suppressions;');
    Script.Add('');
    Script.Add('  new.dm_suppressions = cast(''now'' as timestamp);');
    Script.Add('  if (inserting or new.dc_suppressions is null) then new.dc_suppressions = new.dm_suppressions;');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER ALBUMS_LOGSUP_AD0 FOR ALBUMS');
    Script.Add('ACTIVE AFTER DELETE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  insert into suppressions(tablename, fieldname, id) values (''ALBUMS'', ''id_album'', old.id_album);');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER AUTEURS_LOGSUP_AD0 FOR AUTEURS');
    Script.Add('ACTIVE AFTER DELETE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  insert into suppressions(tablename, fieldname, id) values (''AUTEURS'', ''id_auteur'', old.id_auteur);');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER AUTEURS_PARABD_LOGSUP_AD0 FOR AUTEURS_PARABD');
    Script.Add('ACTIVE AFTER DELETE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  insert into suppressions(tablename, fieldname, id) values (''AUTEURS_PARABD'', ''id_auteur_parabd'', old.id_auteur_parabd);');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER AUTEURS_SERIES_LOGSUP_AD0 FOR AUTEURS_SERIES');
    Script.Add('ACTIVE AFTER DELETE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  insert into suppressions(tablename, fieldname, id) values (''AUTEURS_SERIES'', ''id_auteur_series'', old.id_auteur_series);');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER COLLECTIONS_LOGSUP_AD0 FOR COLLECTIONS');
    Script.Add('ACTIVE AFTER DELETE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  insert into suppressions(tablename, fieldname, id) values (''COLLECTIONS'', ''id_collection'', old.id_collection);');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER CONVERSIONS_LOGSUP_AD0 FOR CONVERSIONS');
    Script.Add('ACTIVE AFTER DELETE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  insert into suppressions(tablename, fieldname, id) values (''CONVERSIONS'', ''id_conversion'', old.id_conversion);');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER COTES_LOGSUP_AD0 FOR COTES');
    Script.Add('ACTIVE AFTER DELETE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  insert into suppressions(tablename, fieldname, id) values (''COTES'', ''id_cote'', old.id_cote);');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER COTES_PARABD_LOGSUP_AD0 FOR COTES_PARABD');
    Script.Add('ACTIVE AFTER DELETE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  insert into suppressions(tablename, fieldname, id) values (''COTES_PARABD'', ''id_cote_parabd'', old.id_cote_parabd);');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER COUVERTURES_LOGSUP_AD0 FOR COUVERTURES');
    Script.Add('ACTIVE AFTER DELETE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  insert into suppressions(tablename, fieldname, id) values (''COUVERTURES'', ''id_couverture'', old.id_couverture);');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER CRITERES_LOGSUP_AD0 FOR CRITERES');
    Script.Add('ACTIVE AFTER DELETE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  insert into suppressions(tablename, fieldname, id) values (''CRITERES'', ''id_critere'', old.id_critere);');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER EDITEURS_LOGSUP_AD0 FOR EDITEURS');
    Script.Add('ACTIVE AFTER DELETE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  insert into suppressions(tablename, fieldname, id) values (''EDITEURS'', ''id_editeur'', old.id_editeur);');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER EDITIONS_LOGSUP_AD0 FOR EDITIONS');
    Script.Add('ACTIVE AFTER DELETE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  insert into suppressions(tablename, fieldname, id) values (''EDITIONS'', ''id_edition'', old.id_edition);');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER EMPRUNTEURS_LOGSUP_AD0 FOR EMPRUNTEURS');
    Script.Add('ACTIVE AFTER DELETE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  insert into suppressions(tablename, fieldname, id) values (''EMPRUNTEURS'', ''id_emprunteur'', old.id_emprunteur);');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER ENTRETIENT_LOGSUP_AD0 FOR ENTRETIENT');
    Script.Add('ACTIVE AFTER DELETE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  insert into suppressions(tablename, fieldname, id) values (''ENTRETIENT'', ''id_entretient'', old.id_entretient);');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER GENRES_LOGSUP_AD0 FOR GENRES');
    Script.Add('ACTIVE AFTER DELETE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  insert into suppressions(tablename, fieldname, id) values (''GENRES'', ''id_genre'', old.id_genre);');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER GENRESERIES_LOGSUP_AD0 FOR GENRESERIES');
    Script.Add('ACTIVE AFTER DELETE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  insert into suppressions(tablename, fieldname, id) values (''GENRESERIES'', ''id_genreseries'', old.id_genreseries);');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER LISTES_LOGSUP_AD0 FOR LISTES');
    Script.Add('ACTIVE AFTER DELETE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  insert into suppressions(tablename, fieldname, id) values (''LISTES'', ''id_liste'', old.id_liste);');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER OPTIONS_LOGSUP_AD0 FOR OPTIONS');
    Script.Add('ACTIVE AFTER DELETE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  insert into suppressions(tablename, fieldname, id) values (''OPTIONS'', ''id_option'', old.id_option);');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER PARABD_LOGSUP_AD0 FOR PARABD');
    Script.Add('ACTIVE AFTER DELETE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  insert into suppressions(tablename, fieldname, id) values (''PARABD'', ''id_parabd'', old.id_parabd);');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER PERSONNES_LOGSUP_AD0 FOR PERSONNES');
    Script.Add('ACTIVE AFTER DELETE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  insert into suppressions(tablename, fieldname, id) values (''PERSONNES'', ''id_personne'', old.id_personne);');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER SERIES_LOGSUP_AD0 FOR SERIES');
    Script.Add('ACTIVE AFTER DELETE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  insert into suppressions(tablename, fieldname, id) values (''SERIES'', ''id_serie'', old.id_serie);');
    Script.Add('end;');

    Script.Add('CREATE TRIGGER STATUT_LOGSUP_AD0 FOR STATUT');
    Script.Add('ACTIVE AFTER DELETE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  insert into suppressions(tablename, fieldname, id) values (''STATUT'', ''id_statut'', old.id_statut);');
    Script.Add('end;');

    ExecuteScript;
  end;
end;

initialization
  RegisterFBUpdate('2.1.0.0', @MAJ2_1_0_0);

end.

