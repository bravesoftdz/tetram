﻿unit BDTK.GUI.DataModules.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.UITypes, System.SyncObjs, Vcl.Imaging.jpeg, Vcl.Menus, uib,
  Vcl.AppEvnts, Vcl.ImgList, PngImageList, BD.DB.Connection,
  System.ImageList;

const
  DBPageSize = 16384;

type
  TAffiche_act = procedure(const Texte: string) of object;

  TdmPrinc = class(TDataModule)
    ApplicationEvents1: TApplicationEvents;
    UIBBackup: TUIBBackup;
    UIBRestore: TUIBRestore;
    ShareImageList: TPngImageList;
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  strict private
    FUILock: TCriticalSection;
    FDBConnection: IDBConnection;
    procedure MakeJumpList;
  public
    procedure PrepareDBConnexion;
    function OuvreSession(doConnect: Boolean): Boolean;

    procedure doBackup(const backupFile: TFileName; AutoClose: Boolean = True);
    procedure doRestore(const backupFile: TFileName; AutoClose: Boolean = True; fixMetadata: Boolean = False);

    function CheckDBVersion(Affiche_act: TAffiche_act; Force: Boolean = True): Boolean;
    function CheckExeVersion(Force: Boolean): Boolean;

    property DBConnection: IDBConnection read FDBConnection;
  end;

procedure BdtkInitProc;
procedure AnalyseLigneCommande(cmdLine: string);

var
  dmPrinc: TdmPrinc;

implementation

{$R *.DFM}

uses
  System.IOUtils, BD.Common, BD.Utils.StrUtils, BD.Strings, BDTK.GUI.DataModules.Search, UIBLib, Divers, System.IniFiles, BD.Utils.GUIUtils, UHistorique, System.Math, UIBase, BDTK.Updates, BDTK.GUI.Forms.Main, CheckVersionNet,
  System.DateUtils, BDTK.Updates.ODS, JumpList, BD.GUI.Forms.Splash, Proc_Gestions, System.Generics.Collections,
  BD.GUI.Forms.Verbose, BD.GUI.Forms.Console, BDTK.GUI.Utils, JclCompression,
  BD.Entities.Dao.Lambda, System.TypInfo, BD.Entities.Full,
  BD.Entities.Dao.Common, BD.GUI.DataModules.Common;

const
  FinBackup = 'gbak:closing file, committing, and finishing.';
  FinRestore = 'gbak:    committing metadata';

function TdmPrinc.CheckDBVersion(Affiche_act: TAffiche_act; Force: Boolean): Boolean;
var
  CurrentVersion: TVersionNumber;
type
  TProcedure = procedure(Query: TUIBScript);

  procedure ProcessUpdate(const Version: TVersionNumber; ProcMAJ: TProcedure);
  var
    Script: TUIBScript;
  begin
    if (Version > CurrentVersion) and (Version <= TGlobalVar.ExeVersion) then
    begin
      Affiche_act('Mise à jour ' + Version + '...');
      Script := TUIBScript.Create(nil);
      try
        Script.Transaction := DBConnection.GetTransaction;
        ProcMAJ(Script);

        Script.Script.Text := 'update options set valeur = ' + QuotedStr(Version) + ' where nom_option = ''Version'';';
        Script.ExecuteScript;
        Script.Transaction.Commit;
        CurrentVersion := Version;
      finally
        Script.Transaction.Free;
        Script.Free;
      end;
    end;
  end;

  procedure CheckIndex;
  var
    i: Integer;
    sl: TList<string>;
    qry: TUIBQuery;
  begin
    qry := dmPrinc.DBConnection.GetQuery;
    try
      qry.SQL.Text := 'select rdb$index_name from rdb$indices where coalesce(rdb$system_flag, 0) <> 1';
      qry.Open;
      sl := TList<string>.Create;
      try
        while not qry.Eof do
        begin
          sl.Add(qry.Fields.AsString[0]);
          qry.Next;
        end;
        qry.Close;

        qry.SQL.Clear;
        for i := 0 to Pred(sl.Count) do
          qry.SQL.Add('set statistics index ' + sl[i] + ';');
      finally
        sl.Free;
      end;
      qry.QuickScript := True;
      qry.ExecSQL;
      qry.Transaction.Commit;
    finally
      qry.Free;
    end;
  end;

var
  FBUpdate: TFBUpdate;
  Msg: string;
  qry: TUIBQuery;
  backupFile: TFileName;
begin
  Result := False;

  qry := dmPrinc.DBConnection.GetQuery;
  try
    qry.SQL.Text := 'select titrealbum from albums';
    try
      // on va chercher un champ texte pour forcer FB à verifier la présence des collations
      // donc vérifier que la version des ICU sur disque correspondent à ceux utilisés par la base
      qry.Prepare;
    except
      on E: EUIBError do
      begin
        // 335544855 = collation not installed
        if E.GDSCode = 335544855 then
        begin
          backupFile := TPath.Combine(TGlobalVar.TempPath, 'bdtk-upgrade.fbk');
          if TFile.Exists(backupFile) then
            TFile.Delete(backupFile);
          TFile.Copy(DBConnection.GetDatabase.InfoDbFileName, TPath.Combine(TGlobalVar.TempPath, TPath.GetFileName(DBConnection.GetDatabase.InfoDbFileName)), True);
          doBackup(backupFile);
          doRestore(backupFile);
        end
        else
          raise;
      end
      else
        raise;
    end;

    qry.SQL.Text := 'select valeur from options where nom_option = ?';
    qry.Params.AsString[0] := 'Version';
    qry.Open;
    if not qry.Eof then
      CurrentVersion := qry.Fields.AsString[0]
    else
    begin
      CurrentVersion := '0.0.0.0';
      try
        qry.SQL.Text := 'insert into options (nom_option, valeur) values (?, ?)';
        qry.Prepare(True);
        qry.Params.AsString[0] := 'Version';
        qry.Params.AsString[1] := Copy(CurrentVersion, 1, qry.Params.MaxStrLen[0]);
        qry.Execute;
      except
        // Pour s'assurer qu'il y'a la ligne dans la table options
      end;
    end;

  finally
    qry.Free;
  end;

  Msg := 'BDthèque ne peut pas utiliser cette base de données.'#13#10'Version de la base de données: ' + CurrentVersion;

  if (CurrentVersion > ListFBUpdates.Last.Version) and (CurrentVersion > TGlobalVar.ExeVersion) then
  begin
    ShowMessage('Base de données trop récente.'#13#10 + Msg);
    Exit;
  end;

  if (ListFBUpdates.Last.Version > CurrentVersion) or (DBConnection.GetDatabase.InfoPageSize < DBPageSize) then
  begin
    if not(Force or (MessageDlg(Msg + #13#10'Voulez-vous la mettre à jour?', mtConfirmation, [mbYes, mbNo], 0) = mrYes)) then
      Exit;

    MAJ_ODS(False);

    for FBUpdate in ListFBUpdates do
      ProcessUpdate(FBUpdate.Version, FBUpdate.UpdateCallback);

    qry := dmPrinc.DBConnection.GetQuery;
    try
      qry.SQL.Text := 'update options set valeur = ? where nom_option = ?';
      qry.Params.AsString[0] := ListFBUpdates.Last.Version;
      qry.Params.AsString[1] := 'Version';
      qry.Execute;
      qry.Transaction.Commit;
    finally
      qry.Free;
    end;
  end;

  CheckIndex;

  if (ListFBUpdates.Last.Version > CurrentVersion) and not Force then
    ShowMessage('Mise à jour terminée.');
  Result := True;
end;

procedure TdmPrinc.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  TfrmConsole.AddSeparator;

  Done := not Historique.Waiting;
  if Historique.Waiting then
    Historique.ProcessNext;
end;

procedure TdmPrinc.ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
begin
  if (Msg.Message = WM_SYSCOMMAND) and (Msg.wParam = SC_CLOSE) and Assigned(frmFond) then
  begin
    Handled := True;
    frmFond.actQuitter.Execute;
  end;
end;

procedure TdmPrinc.DataModuleCreate(Sender: TObject);
begin
  FUILock := TCriticalSection.Create;
  FDBConnection := TDBConnection.Create;
  TDaoDBEntity.DBConnection := FDBConnection;
  MakeJumpList;
end;

procedure TdmPrinc.DataModuleDestroy(Sender: TObject);
begin
  DBConnection.GetDatabase.Connected := False;
  Sleep(500); // let the connection being fully closed
  TDaoDBEntity.DBConnection := nil;
  FDBConnection := nil;
  FUILock.Free;
end;

procedure TdmPrinc.doBackup(const backupFile: TFileName; AutoClose: Boolean = True);
var
  s: string;
  frmVerbose: TFrmVerbose;
begin
  frmVerbose := TFrmVerbose.Create(Application);
  try
    frmVerbose.Show;
    Application.ProcessMessages;
    UIBBackup.OnVerbose := frmVerbose.UIBVerbose;
    UIBBackup.Verbose := True;
    UIBBackup.BackupFiles.Text := backupFile;
    UIBBackup.Run;

    s := Copy(frmVerbose.Memo1.Lines[frmVerbose.Memo1.Lines.Count - 1], 1, Length(FinBackup));
    if not SameText(s, FinBackup) then
      raise Exception.Create('Erreur durant le backup');
  finally
    if AutoClose then
      frmVerbose.Free
    else
      frmVerbose.Fin;
  end;
end;

procedure TdmPrinc.doRestore(const backupFile: TFileName; AutoClose: Boolean = True; fixMetadata: Boolean = False);
var
  s: string;
  frmVerbose: TFrmVerbose;
begin
  frmVerbose := TFrmVerbose.Create(Application);
  try
    frmVerbose.Show;
    DBConnection.GetDatabase.Connected := False;
    Application.ProcessMessages;
    UIBRestore.PageSize := DBPageSize;
    UIBRestore.OnVerbose := frmVerbose.UIBVerbose;
    UIBRestore.Verbose := True;
    UIBRestore.BackupFiles.Text := backupFile;

    UIBRestore.FixMetadataCharset := csWIN1252;
    UIBRestore.FixDataCharset := csWIN1252;

    if fixMetadata then
      UIBRestore.Options := UIBRestore.Options + [roFixMetadataCharset, roFixDataCharset]
    else
      UIBRestore.Options := UIBRestore.Options - [roFixMetadataCharset, roFixDataCharset];

    UIBRestore.Run;

    s := Copy(frmVerbose.Memo1.Lines[frmVerbose.Memo1.Lines.Count - 2], 1, Length(FinRestore));
    if not SameText(s, FinRestore) then
      raise Exception.Create('Erreur durant le restore');
  finally
    if AutoClose then
      frmVerbose.Free
    else
      frmVerbose.Fin;
  end;
end;

procedure TdmPrinc.MakeJumpList;
var
  jl: TJumpList;
begin
  // pas besoin de vérifier si on est au moins en Windows 7, TJumpList le fait
  jl := TJumpList.Create(nil);
  try
    jl.AppId := Application.ExeName;
    jl.Tasks.AddShellLink('Ajouter un nouvel album', '/album=new', '', '', 2);
    jl.Tasks.AddShellLink('Ajouter une nouvelle série', '/serie=new', '', '', 2);
    jl.Tasks.AddShellLink('Ajouter un nouvel auteur', '/auteur=new', '', '', 2);
    jl.DisplayKnowCategories := [jlkcRecent];
    jl.Commit;
  finally
    jl.Free;
  end;
end;

function TdmPrinc.OuvreSession(doConnect: Boolean): Boolean;
begin
  try
    Result := True;

    PrepareDBConnexion;

    if doConnect then
      DBConnection.GetDatabase.Connected := True;

    if not Assigned(dmSearch) then
      Application.CreateForm(TdmSearch, dmSearch);
  except
    AffMessage(rsOuvertureSessionRate + #13#13 + Exception(ExceptObject).Message, mtError, [mbOk], True);
    Result := False;
  end;
end;

procedure TdmPrinc.PrepareDBConnexion;
begin
  DBConnection.GetDatabase.Connected := False;
  DBConnection.GetDatabase.DatabaseName := TGlobalVar.DatabasePath;
  DBConnection.GetDatabase.UserName := TGlobalVar.DatabaseUserName;
  DBConnection.GetDatabase.PassWord := TGlobalVar.DatabasePassword;
  DBConnection.GetDatabase.LibraryName := TGlobalVar.DataBaseLibraryName;
  DBConnection.GetDatabase.Params.Values['sql_role_name'] := TGlobalVar.DatabaseRole;

  UIBBackup.Database := TGlobalVar.DatabasePath;
  UIBBackup.UserName := TGlobalVar.DatabaseUserName;
  UIBBackup.PassWord := TGlobalVar.DatabasePassword;
  UIBBackup.LibraryName := TGlobalVar.DataBaseLibraryName;

  UIBRestore.Database := TGlobalVar.DatabasePath;
  UIBRestore.UserName := TGlobalVar.DatabaseUserName;
  UIBRestore.PassWord := TGlobalVar.DatabasePassword;
  UIBRestore.LibraryName := TGlobalVar.DataBaseLibraryName;
end;

function TdmPrinc.CheckExeVersion(Force: Boolean): Boolean;
// Valeurs de retour:
// False: pas de mise à jour ou mise à jour "reportée"
// True: mise à jour et utilisateur demande à fermer l'appli
var
  doVerif: Boolean;
  ini: TIniFile;
begin
  if Force then
    doVerif := True
  else
    case TGlobalVar.Options.VerifMAJDelai of
      0: // jamais de verification
        doVerif := False;
      1: // à chaque démarrage
        doVerif := True;
      2: // une fois par jour
        doVerif := DaysBetween(Now, TGlobalVar.Options.LastVerifMAJ) > 0;
      3: // une fois par semaine
        doVerif := WeeksBetween(Now, TGlobalVar.Options.LastVerifMAJ) > 0;
    else // une fois par mois
      doVerif := MonthsBetween(Now, TGlobalVar.Options.LastVerifMAJ) > 0;
    end;

  if not doVerif then
    Exit(False);

  try
    Result := CheckVersionNet.CheckVersion('TetramCorpBDTheque', 'bdtheque', TGlobalVar.ExeVersion, Force, not Force) = 1;
    ini := TIniFile.Create(TGlobalVar.FichierIni);
    try
      ini.WriteInteger('Divers', 'LastVerifMAJ', Trunc(Now));
    finally
      ini.Free;
    end;
  except
    Result := False;
  end;
end;

procedure AnalyseLigneCommande(cmdLine: string);
var
  gestAdd: TActionGestionAdd;
  ForceGestion: Boolean;
  PageToOpen: TActionConsultation;
  ModeToOpen: TActionConsultation;
  ParamValue: string;
  GuidToOpen: TGUID;
begin
  if TGlobalVar.Mode_en_cours <> mdEditing then
  begin
    ModeToOpen := fcModeConsultation;
    PageToOpen := fcActionBack;
    gestAdd := nil;
    if BD.Utils.GUIUtils.FindCmdLineSwitch(cmdLine, 'album', ParamValue) then
    begin
      PageToOpen := fcAlbum;
      gestAdd := AjouterAlbums;
    end
    else if BD.Utils.GUIUtils.FindCmdLineSwitch(cmdLine, 'serie', ParamValue) then
    begin
      PageToOpen := fcSerie;
      gestAdd := AjouterSeries;
    end
    else if BD.Utils.GUIUtils.FindCmdLineSwitch(cmdLine, 'auteur', ParamValue) then
    begin
      PageToOpen := fcAuteur;
      gestAdd := AjouterAuteurs;
    end;
    ForceGestion := SameText(ParamValue, 'new');
    if not ForceGestion and (PageToOpen <> fcActionBack) then
      GuidToOpen := StringToGUID(ParamValue);
    // je force en mode gestion quand on demande la création d'un nouvel élément
    // mais rien n'y oblige
    if not TGlobalVar.Options.ModeDemarrage or ForceGestion then
      ModeToOpen := fcModeGestion;
    Historique.AddWaiting(ModeToOpen);
    // if ModeToOpen <> fcModeScript then
    if ForceGestion then
      Historique.AddWaiting(fcGestionAjout, nil, nil, @gestAdd, nil, '')
    else
      Historique.AddWaiting(PageToOpen, GuidToOpen);
  end;
end;

function GetHandleOtherInstance: HWND;
var
  TitreApplication: string;
begin
  TitreApplication := Application.Title;
  Application.Title := ''; // on change le titre car sinon, on trouverait toujours une Application déjà lancée (la notre!)
  try
    try
      Result := FindWindow('TfrmFond', PChar(TitreApplication));
      // renvoie le Handle de la première fenêtre de Class (type) ClassName et de titre TitreApplication (0 s'il n'y en a pas)
    finally
      Application.Title := TitreApplication; // restauration du vrai titre
    end;
  except
    Result := 0;
  end;
end;

procedure BdtkInitProc;
var
  Debut: TDateTime;
  hdl: THandle;
  data: RMSGSendData;
  CD: TCopyDataStruct;
  s: string;
  frmSplash: TfrmSplash;
begin
  TGlobalVar.Mode_en_cours := mdLoad;
  Application.Title := '© TeträmCorp ' + TitreApplication + ' ' + TGlobalVar.AppVersion;
  if not LongBool(CreateMutex(nil, True, 'TetramCorpBDMutex')) then
    RaiseLastOSError
  else if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    hdl := GetHandleOtherInstance;
    if hdl = 0 then
      // c'est pas vrai mais bon... comme on devrait jamais passer là...
      ShowMessage('Une instance de BDthèque est déjà ouverte!')
    else
    begin
      if ParamCount > 0 then
      begin
        ZeroMemory(@data, SizeOF(RMSGSendData));
        s := GetCommandLine;
        data.l := Length(s);
        CopyMemory(@data.a, @s[1], data.l * SizeOF(Char));
        CD.dwData := MSG_COMMANDELINE;
        CD.cbData := SizeOF(data);
        CD.lpData := @data;
        SendMessage(hdl, WM_COPYDATA, wParam(INVALID_HANDLE_VALUE), LPARAM(@CD));
      end;
      SendMessage(hdl, MSG_ACTIVATE, 0, 0);
    end;
    Exit;
  end;

  // if not CheckCriticalFiles then Halt;

  Application.CreateForm(TdmCommon, dmCommon);
  Application.CreateForm(TdmPrinc, dmPrinc);

  frmSplash := TfrmSplash.Create(nil);
  try
    frmSplash.Show;
    Application.ProcessMessages;
    Debut := Now;

    ChangeCurseur(crHandPoint, 'CUR_HANDPOINT', RT_RCDATA);

    frmSplash.Affiche_act(VerificationVersion + '...');
    if dmPrinc.CheckExeVersion(False) then
      Exit;

    if not dmPrinc.OuvreSession(True) then
      Exit;
    if not dmPrinc.CheckDBVersion(frmSplash.Affiche_act) then
      Exit;

    frmSplash.Affiche_act(ChargementOptions + '...');
    LitOptions;

    frmSplash.Affiche_act(ChargementApp + '...');
    Application.CreateForm(TfrmFond, frmFond);
    frmSplash.Affiche_act(ChargementDatabase + '...');
    Historique.AddConsultation(fcRecherche);
    AnalyseLigneCommande(GetCommandLine);

{$IFDEF DEBUG}
    Historique.AddWaiting(fcConsole);
{$ENDIF DEBUG}
    frmSplash.Affiche_act(FinChargement + '...');
    while SecondsBetween(Now, Debut) < 1 do // au moins 1 seconde d'affichage du splash
    begin
      frmSplash.Show;
      frmSplash.Update;
    end;
  finally
    frmSplash.Free;
  end;
  if Assigned(Application.MainForm) then
    Application.MainForm.Show;
end;

initialization

InitProc := @BdtkInitProc;

end.
