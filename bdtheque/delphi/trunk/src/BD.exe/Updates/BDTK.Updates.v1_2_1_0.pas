unit BDTK.Updates.v1_2_1_0;

interface

implementation

uses UIB, BDTK.Updates;

procedure MAJ1_2_1_0(Query: TUIBScript);
begin
  Query.Script.Clear;

  Query.Script.Add('ALTER TABLE PARABD DROP TITREINITIALESPARABD;');
  Query.Script.Add('ALTER TABLE ALBUMS DROP TITREINITIALESALBUM;');

  Query.Script.Add('DECLARE EXTERNAL FUNCTION UDF_UPPERBLOB BLOB, BLOB RETURNS PARAMETER 2 ENTRY_POINT ''UpperBlob'' MODULE_NAME ''BDT_UDF.dll'';');

  Query.Script.Add('ALTER TRIGGER ALBUMS_DV');
  Query.Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  if (new.TitreAlbum is null) then begin');
  Query.Script.Add('    new.UpperTitreAlbum = null;');
  Query.Script.Add('    new.SoundexTitreAlbum = null;');
  Query.Script.Add('    new.initialetitreAlbum = null;');
  Query.Script.Add('  end else');
  Query.Script.Add('  if (inserting or old.TitreAlbum is null or new.TitreAlbum <> old.TitreAlbum) then begin');
  Query.Script.Add('    new.UpperTitreAlbum = UDF_UPPER(new.TitreAlbum);');
  Query.Script.Add('    new.SoundexTitreAlbum = UDF_SOUNDEX(new.TitreAlbum, 1);');
  Query.Script.Add('    select initiale from get_initiale(new.UpperTitreAlbum) into new.initialetitreAlbum;');
  Query.Script.Add('  end');
  Query.Script.Add('  if (new.sujetalbum is null) then');
  Query.Script.Add('    new.UPPERsujetAlbum = null;');
  Query.Script.Add('  else');
  Query.Script.Add('    new.UPPERsujetAlbum = UDF_UPPERBLOB(new.sujetalbum);');
  Query.Script.Add('  if (new.remarquesalbum is null) then');
  Query.Script.Add('    new.UPPERRemarquesAlbum = null;');
  Query.Script.Add('  else');
  Query.Script.Add('    new.UPPERRemarquesAlbum = UDF_UPPERBLOB(new.remarquesalbum);');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER TRIGGER PARABD_DV');
  Query.Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  if (new.TitreParaBD is null) then begin');
  Query.Script.Add('    new.UpperTitreParaBD = null;');
  Query.Script.Add('    new.SoundexTitreParaBD = null;');
  Query.Script.Add('    new.initialetitreParaBD = null;');
  Query.Script.Add('  end else');
  Query.Script.Add('  if (inserting or old.TitreParaBD is null or new.TitreParaBD <> old.TitreParaBD) then begin');
  Query.Script.Add('    new.UpperTitrePARABD = UDF_UPPER(new.TitrePARABD);');
  Query.Script.Add('    new.SoundexTitrePARABD = UDF_SOUNDEX(new.TitrePARABD, 1);');
  Query.Script.Add('    select initiale from get_initiale(new.UpperTitrePARABD) into new.initialetitrePARABD;');
  Query.Script.Add('  end');
  Query.Script.Add('  if (new.description is null) then');
  Query.Script.Add('    new.upperdescription = null;');
  Query.Script.Add('  else');
  Query.Script.Add('    new.upperdescription = UDF_UPPERBLOB(new.description);');
  Query.Script.Add('end;');

  Query.Script.Add('ALTER TRIGGER SERIES_DV');
  Query.Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
  Query.Script.Add('AS');
  Query.Script.Add('begin');
  Query.Script.Add('  if (inserting or new.titreserie <> old.titreserie) then begin');
  Query.Script.Add('    new.uppertitreserie = UDF_UPPER(new.titreserie);');
  Query.Script.Add('    new.SoundexTitreSerie = UDF_SOUNDEX(new.TitreSerie, 1);');
  Query.Script.Add('    select initiale from get_initiale(new.uppertitreserie) into new.initialetitreserie;');
  Query.Script.Add('  end');
  Query.Script.Add('  if (new.sujetserie is null) then');
  Query.Script.Add('    new.UPPERsujetserie = null;');
  Query.Script.Add('  else');
  Query.Script.Add('    new.UPPERsujetserie = UDF_UPPERBLOB(new.sujetserie);');
  Query.Script.Add('  if (new.remarquesserie is null) then');
  Query.Script.Add('    new.UPPERRemarquesserie = null;');
  Query.Script.Add('  else');
  Query.Script.Add('    new.UPPERRemarquesserie = UDF_UPPERBLOB(new.remarquesserie);');
  Query.Script.Add('end;');

  Query.ExecuteScript;
end;

initialization

RegisterFBUpdate('1.2.1.0', @MAJ1_2_1_0);

end.
