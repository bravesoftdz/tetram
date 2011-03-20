unit UMAJODS;

interface

uses SysUtils, Windows, Classes, Forms;

procedure MAJ_ODS(FullRebuild: Boolean);

implementation

uses CommonConst, UfrmVerbose, UdmPrinc, Divers, UIB, UIBLib, UIBMetadata, UIBConst;

const
  FB_ODS = '11.2';

procedure MAJ_ODS_BackupRestore;
const
  FinBackup = 'gbak:closing file, committing, and finishing.';
  FinRestore = 'gbak:    committing metadata';
var
  FichierBackup, s: string;
  Done, pre25: Boolean;
begin
  FichierBackup := IncludeTrailingBackslash(TempPath) + 'bdtk-upgrade.fbk';
  DeleteFile(PChar(FichierBackup));
  DeleteFile(PChar(IncludeTrailingBackslash(TempPath) + ExtractFileName(DMPrinc.UIBDataBase.InfoDbFileName)));
  CopyFile(PChar(DMPrinc.UIBDataBase.InfoDbFileName), PChar(IncludeTrailingBackslash(TempPath) + ExtractFileName(DMPrinc.UIBDataBase.InfoDbFileName))
      , False);

  pre25 := Format('%d.%d', [DMPrinc.UIBDataBase.InfoOdsVersion, DMPrinc.UIBDataBase.InfoOdsMinorVersion]) < TVersionNumber('11.2'); // ODS11.2 = FB2.5

  Done := False;
  with TFrmVerbose.Create(nil) do
    try
      Application.ProcessMessages;
      DMPrinc.UIBBackup.OnVerbose := UIBVerbose;
      DMPrinc.UIBBackup.Verbose := True;
      DMPrinc.UIBBackup.BackupFiles.Text := FichierBackup;
      DMPrinc.UIBBackup.Run;
      s := Copy(Memo1.Lines[Memo1.Lines.Count - 1], 1, Length(FinBackup));
      if not SameText(s, FinBackup) then
        raise Exception.Create('Erreur durant le backup');

      DMPrinc.UIBDataBase.Connected := False;
      Application.ProcessMessages;
      DMPrinc.UIBRestore.OnVerbose := UIBVerbose;
      DMPrinc.UIBRestore.Verbose := True;
      DMPrinc.UIBRestore.BackupFiles.Text := FichierBackup;
      if pre25 then
      begin
        DMPrinc.UIBRestore.FixMetadataCharset := 'WIN1252';
        DMPrinc.UIBRestore.FixDataCharset := 'WIN1252';
      end;
      DMPrinc.UIBRestore.Run;
      s := Copy(Memo1.Lines[Memo1.Lines.Count - 2], 1, Length(FinRestore));
      if not SameText(s, FinRestore) then
        raise Exception.Create('Erreur durant le restore');

      DMPrinc.UIBDataBase.Connected := True;
      DeleteFile(PChar(FichierBackup));
      Done := True;
    finally
      // pas de free, c'est la fenêtre qui va s'auto-libérer
      if Done then
        Free
      else
        Fin;
    end;
end;

var
  UIBDBSrc: TUIBDataBase;
  UIBTransaction1: TUIBTransaction;
  UIBDBDst: TUIBDataBase;
  UIBQuerySrc: TUIBQuery;
  UIBQueryDst: TUIBQuery;
  UIBScriptDst: TUIBScript;
  MD: TMetaDataBase;
  frmVerbose: TFrmVerbose;

function Log(const Line: string; iLigne: Integer = -1): Integer;
begin
  Result := frmVerbose.Log(Line, iLigne);
  Application.ProcessMessages;
end;

procedure InitializeParametres;
begin
  with UIBDBSrc do
  begin
    LibraryName := 'fbembed.dll';
    name := 'UIBDBSrc';
    Params.Clear;
    Params.Add('sql_dialect=3');
    Params.Add('lc_ctype=NONE');
    UserName := 'SYSDBA';
    PassWord := 'masterkey';
  end;
  with UIBDBDst do
  begin
    LibraryName := 'fbembed.dll';
    name := 'UIBDBDst';
    Params.Clear;
    Params.Add('sql_dialect=3');
    Params.Add('lc_ctype=UTF8');
    UserName := 'SYSDBA';
    PassWord := 'masterkey';
  end;
  with UIBTransaction1 do
  begin
    name := 'UIBTransaction1';
    DataBase := UIBDBDst;
    AddDatabase(UIBDBSrc);
  end;
  with UIBQuerySrc do
  begin
    name := 'UIBQuerySrc';
    Transaction := UIBTransaction1;
    DataBase := UIBDBSrc;
    FetchBlobs := True;
  end;
  with UIBQueryDst do
  begin
    name := 'UIBQueryDst';
    Transaction := UIBTransaction1;
    DataBase := UIBDBDst;
  end;
  with UIBScriptDst do
  begin
    name := 'UIBScriptDst';
    DataBase := UIBDBDst;
    Transaction := UIBTransaction1;
  end;
end;

procedure PrepareMigration;
begin
  UIBDBSrc := TUIBDataBase.Create(nil);
  UIBDBDst := TUIBDataBase.Create(nil);
  UIBTransaction1 := TUIBTransaction.Create(nil);
  UIBQuerySrc := TUIBQuery.Create(nil);
  UIBQueryDst := TUIBQuery.Create(nil);
  UIBScriptDst := TUIBScript.Create(nil);

  InitializeParametres;
end;

procedure FinalizeMigration;
begin
  UIBQuerySrc.Free;
  UIBQueryDst.Free;
  UIBTransaction1.Free;
  UIBDBSrc.Free;
  UIBDBDst.Free;
end;

procedure VerifieMigration;
begin
  Log('Vérification de la migration');

  UIBDBSrc.Connected := True;
  if UIBDBSrc.InfoDbSqlDialect <> 1 then
    raise Exception.Create('La base de données est déjà en Dialect 3');

  // Vérifier les mots clés
  // mais comment faire
end;

procedure CreationNouvelleBase;
var
  script: string;
  NewBase: string;
begin
  Log('Création de la nouvelle base');

  NewBase := UIBDBSrc.DatabaseName;
  NewBase := ChangeFileExt(NewBase, '') + '_D3' + ExtractFileExt(NewBase);

  Log(NewBase);

  UIBDBDst.DatabaseName := NewBase;
  try
    UIBDBDst.CreateDatabase(csUTF8);
  except
    UIBDBDst.DropDatabase;

    InitializeParametres;
    UIBDBDst.DatabaseName := NewBase;
    UIBDBDst.CreateDatabase(csUTF8);
  end;

  UIBDBSrc.MetaDataOptions.Tables := UIBDBSrc.MetaDataOptions.Tables - [OIDPrimary, OIDForeign, OIDTableTrigger, OIDUnique, OIDIndex, OIDCheck,
    OIDTableGrant, OIDTableFieldGrant];
  MD := TMetaDataBase(UIBDBSrc.GetMetadata(True));
  script := MD.AsDDL;
  script := StringReplace(script, 'DEFAULT "T"', 'DEFAULT ''T''', [rfReplaceAll, rfIgnoreCase]);
  script := StringReplace(script, 'DEFAULT "F"', 'DEFAULT ''F''', [rfReplaceAll, rfIgnoreCase]);
  script := StringReplace(script, 'CSTRING(32767)', 'CSTRING(8191)', [rfReplaceAll, rfIgnoreCase]);

  try
    UIBScriptDst.script.Text := script;

    UIBScriptDst.Transaction := UIBTransaction1;
    UIBScriptDst.ExecuteScript;
  except
    Log(script);
    raise ;
  end;
end;

procedure TransfertDonnees;
var
  LstTables: TStringList;
  i, j, lRecords, lTable, nbChamps, nbRecords, nbRecordsTable, maxRecords: Integer;
  sqlSelect, sqlInsert: string;
  ms: TMemoryStream;
begin
  Log('Transfert des données');

  nbRecords := 0;
  LstTables := TStringList.Create;
  try
    UIBQuerySrc.SQL.Text := 'select rdb$relation_name from rdb$relations where rdb$view_blr is null and coalesce(rdb$system_flag, 0) = 0';
    UIBQuerySrc.Open;
    LstTables.Clear;
    while not UIBQuerySrc.Eof do
    begin
      LstTables.Add(Trim(UIBQuerySrc.Fields.AsString[0]));
      UIBQuerySrc.Next;
    end;

    lRecords := -1;
    lTable := -1;
    for i := 0 to Pred(LstTables.Count) do
    begin
      lTable := Log(Format('Table %s (%d / %d)', [LstTables[i], i + 1, LstTables.Count]), lTable);
      UIBQuerySrc.SQL.Text :=
        'select rf.rdb$field_name from rdb$relation_fields rf inner join rdb$fields f on rf.rdb$field_source = f.rdb$field_name where rf.rdb$relation_name = :TableName and f.rdb$computed_blr is null';
      UIBQuerySrc.Params.AsString[0] := LstTables[i];
      UIBQuerySrc.Open;
      sqlSelect := '';
      nbChamps := 0;
      while not UIBQuerySrc.Eof do
      begin
        sqlSelect := sqlSelect + Trim(UIBQuerySrc.Fields.AsString[0]) + ',';
        Inc(nbChamps);
        UIBQuerySrc.Next;
      end;
      Delete(sqlSelect, Length(sqlSelect), 1);
      sqlInsert := 'insert into ' + LstTables[i] + ' (' + sqlSelect + ') values (:' + StringReplace(sqlSelect, ',', ',:', [rfReplaceAll]) + ')';
      sqlSelect := 'select ' + sqlSelect + ' from ' + LstTables[i];

      UIBQueryDst.SQL.Text := sqlInsert;

      UIBQuerySrc.SQL.Text := 'select count(*) from ' + LstTables[i]; ;
      UIBQuerySrc.Open;
      maxRecords := UIBQuerySrc.Fields.AsInteger[0];

      UIBQuerySrc.SQL.Text := sqlSelect;
      UIBQuerySrc.Open;
      nbRecordsTable := 0;
      while not UIBQuerySrc.Eof do
      begin
        for j := 0 to Pred(nbChamps) do
          if UIBQuerySrc.Fields.IsBlob[j] then
          begin
            ms := TMemoryStream.Create;
            try
              UIBQuerySrc.Fields.ReadBlob(j, ms);
              ms.Position := 0;
              UIBQueryDst.ParamsSetBlob(j, ms);
            finally
              ms.Free;
            end;
          end
          else
            UIBQueryDst.Params.AsVariant[j] := UIBQuerySrc.Fields.AsVariant[j];
        UIBQueryDst.Execute;

        Inc(nbRecords);
        Inc(nbRecordsTable);
        if nbRecords mod 1000 = 0 then
          UIBTransaction1.CommitRetaining;
        if nbRecordsTable mod 1000 = 0 then
          lRecords := Log(Format('  %d / %d records', [nbRecordsTable, maxRecords]), lRecords);
        UIBQuerySrc.Next;
      end;
      UIBTransaction1.CommitRetaining;
      lRecords := Log('  ' + IntToStr(nbRecordsTable) + ' records', lRecords);
    end;
  finally
    LstTables.Free;
  end;
end;

procedure FinalisationNouvelleBase;

  function GetDDL(MetaTable: TMetaTable): string;
  var
    i: Integer;
  begin
    Result := '';
    for i := 0 to Pred(MetaTable.PrimaryCount) do
      Result := Result + MetaTable.Primary[i].AsDDL + #13#10;
    for i := 0 to Pred(MetaTable.UniquesCount) do
      Result := Result + MetaTable.Uniques[i].AsDDL + #13#10;
    for i := 0 to Pred(MetaTable.ForeignCount) do
      Result := Result + MetaTable.Foreign[i].AsDDL + #13#10;
    for i := 0 to Pred(MetaTable.TriggersCount) do
      Result := Result + MetaTable.Triggers[i].AsDDL + #13#10;
    for i := 0 to Pred(MetaTable.IndicesCount) do
      Result := Result + MetaTable.Indices[i].AsDDL + #13#10;
    for i := 0 to Pred(MetaTable.ChecksCount) do
      Result := Result + MetaTable.Checks[i].AsDDL + #13#10;
    for i := 0 to Pred(MetaTable.GrantsCount) do
      Result := Result + MetaTable.Grants[i].AsDDL + #13#10;
    for i := 0 to Pred(MetaTable.FieldsGrantsCount) do
      Result := Result + MetaTable.FieldsGrants[i].AsDDL + #13#10;
  end;

var
  script: string;
  i: Integer;
begin
  Log('Finalisation de la nouvelle base');

  UIBDBSrc.MetaDataOptions.Objects := [OIDTable];
  UIBDBSrc.MetaDataOptions.Tables := ALLTables;
  MD := TMetaDataBase(UIBDBSrc.GetMetadata(True));
  script := '';
  for i := 0 to Pred(MD.SortedTablesCount) do
    script := script + #13#10 + GetDDL(MD.SortedTables[i]);

  try
    UIBScriptDst.script.Text := script;
    UIBScriptDst.ExecuteScript;
  except
    Log(script);
    raise ;
  end;
end;

procedure RebuildDB;
var
  Done: Boolean;
begin
  Done := False;
  PrepareMigration;
  frmVerbose := TFrmVerbose.Create(nil);
  try
    UIBDBSrc.DatabaseName := DMPrinc.UIBDataBase.DatabaseName;

    Log(UIBDBSrc.DatabaseName);

    try
      // VerifieMigration;
      CreationNouvelleBase;
      TransfertDonnees;
      FinalisationNouvelleBase;

      // Result := UIBDBDst.DatabaseName;

      Log('Conversion terminée');
      Done := True;
    except
      Log(Exception(exceptobject).message);
    end;
  finally
    FinalizeMigration;
    // pas de free, c'est la fenêtre qui va s'auto-libérer
    if Done then
      frmVerbose.Free
    else
      frmVerbose.Fin;
  end;
end;

procedure MAJ_ODS(FullRebuild: Boolean);
var
  AvailableSpace, TotalSpace: Int64;
begin
  if Format('%d.%d', [DMPrinc.UIBDataBase.InfoOdsVersion, DMPrinc.UIBDataBase.InfoOdsMinorVersion]) < TVersionNumber(FB_ODS) then
  begin
    GetDiskFreeSpaceEx(PChar(TempPath), AvailableSpace, TotalSpace, nil);
    if AvailableSpace < 2 * (DMPrinc.UIBDataBase.InfoDbSizeInPages * DMPrinc.UIBDataBase.InfoPageSize) then
      raise Exception.CreateFmt('Espace insuffisant sur le disque "%s" pour procéder à la mise à jour', [ExtractFileDrive(TempPath)]);

    // le fullrebuild ne peut pas être utilisé tant que l'extraction des metadata des uib ne sait pas
    // gérer les type of et les domain pour le type de paramètre/variable dans les procédures stockées

    // if FullRebuild then
    // RebuildDB
    // else
    MAJ_ODS_BackupRestore;
  end;
end;

end.
