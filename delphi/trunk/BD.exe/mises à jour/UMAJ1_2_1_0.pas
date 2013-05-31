unit UMAJ1_2_1_0;

interface

implementation

uses UIB, Updates;

procedure MAJ1_2_1_0(Query: TUIBScript);
begin
  with Query do begin
    Script.Clear;

    Script.Add('ALTER TABLE PARABD DROP TITREINITIALESPARABD;');
    Script.Add('ALTER TABLE ALBUMS DROP TITREINITIALESALBUM;');

    Script.Add('DECLARE EXTERNAL FUNCTION UDF_UPPERBLOB BLOB, BLOB RETURNS PARAMETER 2 ENTRY_POINT ''UpperBlob'' MODULE_NAME ''BDT_UDF.dll'';');

    Script.Add('ALTER TRIGGER ALBUMS_DV');
    Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  if (new.TitreAlbum is null) then begin');
    Script.Add('    new.UpperTitreAlbum = null;');
    Script.Add('    new.SoundexTitreAlbum = null;');
    Script.Add('    new.initialetitreAlbum = null;');
    Script.Add('  end else');
    Script.Add('  if (inserting or old.TitreAlbum is null or new.TitreAlbum <> old.TitreAlbum) then begin');
    Script.Add('    new.UpperTitreAlbum = UDF_UPPER(new.TitreAlbum);');
    Script.Add('    new.SoundexTitreAlbum = UDF_SOUNDEX(new.TitreAlbum, 1);');
    Script.Add('    select initiale from get_initiale(new.UpperTitreAlbum) into new.initialetitreAlbum;');
    Script.Add('  end');
    Script.Add('  if (new.sujetalbum is null) then');
    Script.Add('    new.UPPERsujetAlbum = null;');
    Script.Add('  else');
    Script.Add('    new.UPPERsujetAlbum = UDF_UPPERBLOB(new.sujetalbum);');
    Script.Add('  if (new.remarquesalbum is null) then');
    Script.Add('    new.UPPERRemarquesAlbum = null;');
    Script.Add('  else');
    Script.Add('    new.UPPERRemarquesAlbum = UDF_UPPERBLOB(new.remarquesalbum);');
    Script.Add('end;');

    Script.Add('ALTER TRIGGER PARABD_DV');
    Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  if (new.TitreParaBD is null) then begin');
    Script.Add('    new.UpperTitreParaBD = null;');
    Script.Add('    new.SoundexTitreParaBD = null;');
    Script.Add('    new.initialetitreParaBD = null;');
    Script.Add('  end else');
    Script.Add('  if (inserting or old.TitreParaBD is null or new.TitreParaBD <> old.TitreParaBD) then begin');
    Script.Add('    new.UpperTitrePARABD = UDF_UPPER(new.TitrePARABD);');
    Script.Add('    new.SoundexTitrePARABD = UDF_SOUNDEX(new.TitrePARABD, 1);');
    Script.Add('    select initiale from get_initiale(new.UpperTitrePARABD) into new.initialetitrePARABD;');
    Script.Add('  end');
    Script.Add('  if (new.description is null) then');
    Script.Add('    new.upperdescription = null;');
    Script.Add('  else');
    Script.Add('    new.upperdescription = UDF_UPPERBLOB(new.description);');
    Script.Add('end;');

    Script.Add('ALTER TRIGGER SERIES_DV');
    Script.Add('ACTIVE BEFORE INSERT OR UPDATE POSITION 0');
    Script.Add('AS');
    Script.Add('begin');
    Script.Add('  if (inserting or new.titreserie <> old.titreserie) then begin');
    Script.Add('    new.uppertitreserie = UDF_UPPER(new.titreserie);');
    Script.Add('    new.SoundexTitreSerie = UDF_SOUNDEX(new.TitreSerie, 1);');
    Script.Add('    select initiale from get_initiale(new.uppertitreserie) into new.initialetitreserie;');
    Script.Add('  end');
    Script.Add('  if (new.sujetserie is null) then');
    Script.Add('    new.UPPERsujetserie = null;');
    Script.Add('  else');
    Script.Add('    new.UPPERsujetserie = UDF_UPPERBLOB(new.sujetserie);');
    Script.Add('  if (new.remarquesserie is null) then');
    Script.Add('    new.UPPERRemarquesserie = null;');
    Script.Add('  else');
    Script.Add('    new.UPPERRemarquesserie = UDF_UPPERBLOB(new.remarquesserie);');
    Script.Add('end;');

    ExecuteScript;
  end;
end;

initialization
  RegisterFBUpdate('1.2.1.0', @MAJ1_2_1_0);

end.

