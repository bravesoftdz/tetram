unit BDTK.GUI.DataModules.Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, System.UITypes, SyncObjs, jpeg, Menus, uib,
  Vcl.AppEvnts, Vcl.ImgList, PngImageList, BD.DB.Connection,
  System.ImageList;

const
  AntiAliasing = True;
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
    class var _instance: TdmPrinc;
  private
    class function getInstance: TdmPrinc;
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

function dmPrinc: TdmPrinc;

implementation

{$R *.DFM}

uses
  IOUtils, BD.Common, BD.Utils.StrUtils, BD.Strings, BDTK.GUI.DataModules.Search, UIBLib, Divers, IniFiles, BD.Utils.GUIUtils, UHistorique, Math, UIBase, BDTK.Updates, BDTK.GUI.Forms.Main, CheckVersionNet,
  DateUtils, BDTK.Updates.ODS, JumpList, BD.GUI.Forms.Splash, Proc_Gestions, Generics.Collections,
  BD.GUI.Forms.Verbose, BD.GUI.Forms.Console, BDTK.GUI.Utils, JclCompression, dwsJSON,
  BD.Utils.Serializer.JSON, BD.Entities.Dao.Lambda, System.TypInfo, BD.Entities.Full,
  BD.Entities.Dao.Common;

const
  FinBackup = 'gbak:closing file, committing, and finishing.';
  FinRestore = 'gbak:    committing metadata';

function dmPrinc: TdmPrinc;
begin
  Result := TdmPrinc.getInstance;
end;

function TdmPrinc.CheckDBVersion(Affiche_act: TAffiche_act; Force: Boolean): Boolean;
var
  CurrentVersion: TVersionNumber;
type
  TProcedure = procedure(Query: TUIBScript);

  procedure ProcessUpdate(const Version: TVersionNumber; ProcMAJ: TProcedure);
  var
    Script: TUIBScript;
  begin
    if (Version > CurrentVersion) and (Version <= TGlobalVar.Utilisateur.ExeVersion) then
    begin
      Affiche_act('Mise � jour ' + Version + '...');
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

  procedure BuildExternalData;
  var
    Archive: TJcl7zCompressArchive;
    o: TdwsJSONObject;
    c: TDaoListe.CategorieIndex;
    s: string;
  begin
    o := TdwsJSONObject.Create;
    try
      for c := Succ(TDaoListe.CategorieIndex.piNOTUSED) to High(TDaoListe.CategorieIndex) do
      begin
        s := GetEnumName(TypeInfo(TDaoListe.CategorieIndex), Integer(c)).Substring(2);
        TJsonSerializer.WriteValueToJSON('default' + s, TDaoListe.DefaultValues[c], o, []);
        TJsonSerializer.WriteValueToJSON('list' + s, TDaoListe.Lists[c], o, [], True);
      end;

      if TFile.Exists(FileScriptsMetadata) then
        TFile.Delete(FileScriptsMetadata);
      Archive := TJcl7zCompressArchive.Create(FileScriptsMetadata);
      try
        Archive.AddFile('data.json', TStringStream.Create({$IFNDEF DEBUG}o.ToString{$ELSE}o.ToBeautifiedString{$ENDIF}), True);
        Archive.Compress;
      finally
        Archive.Free;
      end;
    finally
      o.Free;
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
      // on va chercher un champ texte pour forcer FB � verifier la pr�sence des collations
      // donc v�rifier que la version des ICU sur disque correspondent � ceux utilis�s par la base
      qry.Prepare;
    except
      on E: EUIBError do
      begin
        // 335544855 = collation not installed
        if E.GDSCode = 335544855 then
        begin
          backupFile := TPath.Combine(TempPath, 'bdtk-upgrade.fbk');
          if TFile.Exists(backupFile) then
            TFile.Delete(backupFile);
          TFile.Copy(DBConnection.GetDatabase.InfoDbFileName, TPath.Combine(TempPath, TPath.GetFileName(DBConnection.GetDatabase.InfoDbFileName)), True);
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

  Msg := 'BDth�que ne peut pas utiliser cette base de donn�es.'#13#10'Version de la base de donn�es: ' + CurrentVersion;

  if (CurrentVersion > ListFBUpdates.Last.Version) and (CurrentVersion > TGlobalVar.Utilisateur.ExeVersion) then
  begin
    ShowMessage('Base de donn�es trop r�cente.'#13#10 + Msg);
    Exit;
  end;

  if (ListFBUpdates.Last.Version > CurrentVersion) or (DBConnection.GetDatabase.InfoPageSize < DBPageSize) then
  begin
    if not(Force or (MessageDlg(Msg + #13#10'Voulez-vous la mettre � jour?', mtConfirmation, [mbYes, mbNo], 0) = mrYes)) then
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
  BuildExternalData;

  if (ListFBUpdates.Last.Version > CurrentVersion) and not Force then
    ShowMessage('Mise � jour termin�e.');
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

class function TdmPrinc.getInstance: TdmPrinc;
var
  cs: TCriticalSection;
begin
  if not Assigned(_instance) then
  begin
    cs := TCriticalSection.Create;
    cs.Enter;
    try
      Application.CreateForm(TdmPrinc, _instance);
    finally
      cs.Leave;
      cs.Free;
    end;
  end;
  Result := _instance;
end;

procedure TdmPrinc.MakeJumpList;
var
  jl: TJumpList;
begin
  // pas besoin de v�rifier si on est au moins en Windows 7, TJumpList le fait
  jl := TJumpList.Create(nil);
  try
    jl.Tasks.AddShellLink('Ajouter un nouvel album', '/album=new', '', '', 2);
    jl.Tasks.AddShellLink('Ajouter une nouvelle s�rie', '/serie=new', '', '', 2);
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
  DBConnection.GetDatabase.DatabaseName := DatabasePath;
  DBConnection.GetDatabase.UserName := DatabaseUserName;
  DBConnection.GetDatabase.PassWord := DatabasePassword;
  DBConnection.GetDatabase.LibraryName := DataBaseLibraryName;
  DBConnection.GetDatabase.Params.Values['sql_role_name'] := DatabaseRole;

  UIBBackup.Database := DatabasePath;
  UIBBackup.UserName := DatabaseUserName;
  UIBBackup.PassWord := DatabasePassword;
  UIBBackup.LibraryName := DataBaseLibraryName;

  UIBRestore.Database := DatabasePath;
  UIBRestore.UserName := DatabaseUserName;
  UIBRestore.PassWord := DatabasePassword;
  UIBRestore.LibraryName := DataBaseLibraryName;
end;

function TdmPrinc.CheckExeVersion(Force: Boolean): Boolean;
// Valeurs de retour:
// False: pas de mise � jour ou mise � jour "report�e"
// True: mise � jour et utilisateur demande � fermer l'appli
var
  doVerif: Boolean;
begin
  if Force then
    doVerif := True
  else
    case TGlobalVar.Utilisateur.Options.VerifMAJDelai of
      0: // jamais de verification
        doVerif := False;
      1: // � chaque d�marrage
        doVerif := True;
      2: // une fois par jour
        doVerif := DaysBetween(Now, TGlobalVar.Utilisateur.Options.LastVerifMAJ) > 0;
      3: // une fois par semaine
        doVerif := WeeksBetween(Now, TGlobalVar.Utilisateur.Options.LastVerifMAJ) > 0;
    else // une fois par mois
      doVerif := MonthsBetween(Now, TGlobalVar.Utilisateur.Options.LastVerifMAJ) > 0;
    end;

  if not doVerif then
    Result := False
  else
  begin
    try
      Result := CheckVersionNet.CheckVersion('TetramCorpBDTheque', 'bdtheque', TGlobalVar.Utilisateur.ExeVersion, Force, not Force) = 1;
      with TIniFile.Create(FichierIni) do
        try
          WriteInteger('Divers', 'LastVerifMAJ', Trunc(Now));
        finally
          Free;
        end;
    except
      Result := False;
    end;
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
    // je force en mode gestion quand on demande la cr�ation d'un nouvel �l�ment
    // mais rien n'y oblige
    if not TGlobalVar.Utilisateur.Options.ModeDemarrage or ForceGestion then
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
  Application.Title := ''; // on change le titre car sinon, on trouverait toujours une Application d�j� lanc�e (la notre!)
  try
    try
      Result := FindWindow('TfrmFond', PChar(TitreApplication));
      // renvoie le Handle de la premi�re fen�tre de Class (type) ClassName et de titre TitreApplication (0 s'il n'y en a pas)
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
  Application.Title := '� Tetr�mCorp ' + TitreApplication + ' ' + TGlobalVar.Utilisateur.AppVersion;
  if not LongBool(CreateMutex(nil, True, 'TetramCorpBDMutex')) then
    RaiseLastOSError
  else if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    hdl := GetHandleOtherInstance;
    if hdl = 0 then
      // c'est pas vrai mais bon... comme on devrait jamais passer l�...
      ShowMessage('Une instance de BDth�que est d�j� ouverte!')
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
