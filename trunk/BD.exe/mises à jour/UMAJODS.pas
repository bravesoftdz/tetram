unit UMAJODS;

interface

procedure MAJ_ODS;

implementation

uses CommonConst, SysUtils, Windows, UfrmVerbose, Forms, UdmPrinc;

procedure MAJ_ODS;
const
  FinBackup = 'gbak:closing file, committing, and finishing.';
  FinRestore = 'gbak:    committing metadata';
var
  FichierBackup, s: string;
  AvailableSpace, TotalSpace: Int64;
  Done: Boolean;
begin
  if (DMPrinc.UIBDataBase.InfoOdsVersion < 11) or (DMPrinc.UIBDataBase.InfoOdsMinorVersion < 1) then
  begin
    GetDiskFreeSpaceEx(PChar(TempPath), AvailableSpace, TotalSpace, nil);
    if AvailableSpace < 2 * (DMPrinc.UIBDataBase.InfoDbSizeInPages * DMPrinc.UIBDataBase.InfoPageSize) then
      raise Exception.CreateFmt('Espace insuffisant sur le disque "%s" pour procéder à la mise à jour', [ExtractFileDrive(TempPath)]);

    FichierBackup := IncludeTrailingBackslash(TempPath) + 'bdtk-upgrade.fbk';
    DeleteFile(PChar(FichierBackup));
    DeleteFile(PChar(IncludeTrailingBackslash(TempPath) + ExtractFileName(DMPrinc.UIBDataBase.InfoDbFileName)));
    CopyFile(PChar(DMPrinc.UIBDataBase.InfoDbFileName),
      PChar(IncludeTrailingBackslash(TempPath) + ExtractFileName(DMPrinc.UIBDataBase.InfoDbFileName)),
      False);

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
end;

end.

