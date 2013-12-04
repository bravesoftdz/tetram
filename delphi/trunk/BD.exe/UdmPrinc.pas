unit UdmPrinc;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, AppEvnts, SyncObjs, jpeg, Menus, uib;

const
  AntiAliasing = True;

type
  TAffiche_act = procedure(const Texte: string) of object;

  TdmPrinc = class(TDataModule)
    UIBDataBase: TUIBDataBase;
    ApplicationEvents1: TApplicationEvents;
    UIBBackup: TUIBBackup;
    UIBRestore: TUIBRestore;
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  strict private
    FUILock: TCriticalSection;
    procedure MakeJumpList;
  public
    function CheckVersions(Affiche_act: TAffiche_act; Force: Boolean = True): Boolean;
    function CheckVersion(Force: Boolean): Boolean;
  end;

function OuvreSession: Boolean;
procedure BdtkInitProc;
procedure AnalyseLigneCommande(cmdLine: string);

function dmPrinc: TdmPrinc;

implementation

{$R *.DFM}

uses CommonConst, Commun, Textes, UdmCommun, UIBLib, Divers, IniFiles, Procedures, UHistorique, Math, UIBase, Updates, UfrmFond, CheckVersionNet,
  DateUtils, UMAJODS, JumpList, UfrmSplash, Proc_Gestions, Generics.Collections;

var
  FDMPrinc: TdmPrinc = nil;

function dmPrinc: TdmPrinc;
var
  cs: TCriticalSection;
begin
  if not Assigned(FDMPrinc) then
  begin
    cs := TCriticalSection.Create;
    cs.Enter;
    try
      Application.CreateForm(TdmPrinc, FDMPrinc);
    finally
      cs.Leave;
      cs.Free;
    end;
  end;
  Result := FDMPrinc;
end;

function OuvreSession: Boolean;
begin
  try
    Result := True;
    with dmPrinc do
    begin
      UIBDataBase.Connected := False;
      UIBDataBase.DatabaseName := DatabasePath;
      UIBDataBase.UserName := DatabaseUserName;
      UIBDataBase.PassWord := DatabasePassword;
      UIBDataBase.LibraryName := DataBaseLibraryName;
      UIBDataBase.Params.Values['sql_role_name'] := DatabaseRole;

      UIBBackup.Database := DatabasePath;
      UIBBackup.UserName := DatabaseUserName;
      UIBBackup.PassWord := DatabasePassword;
      UIBBackup.LibraryName := DataBaseLibraryName;

      UIBRestore.Database := DatabasePath;
      UIBRestore.UserName := DatabaseUserName;
      UIBRestore.PassWord := DatabasePassword;
      UIBRestore.LibraryName := DataBaseLibraryName;

      UIBDataBase.Connected := True;
    end;
    if not Assigned(dmCommun) then
      Application.CreateForm(TdmCommun, dmCommun);
  except
    AffMessage(rsOuvertureSessionRate + #13#13 + Exception(ExceptObject).message, mtError, [mbOk], True);
    Result := False;
  end;
end;

function TdmPrinc.CheckVersions(Affiche_act: TAffiche_act; Force: Boolean): Boolean;
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
      Affiche_act('Mise à jour ' + Version + '...');
      Script := TUIBScript.Create(nil);
      try
        Script.Transaction := GetTransaction(UIBDataBase);
        ProcMAJ(Script);

        Script.Script.Text := 'UPDATE OPTIONS SET Valeur = ' + QuotedStr(Version) + ' WHERE Nom_Option = ''Version'';';
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
    qry := TUIBQuery.Create(nil);
    try
      qry.Transaction := GetTransaction(UIBDataBase);
      qry.SQL.Text := 'SELECT RDB$INDEX_NAME FROM RDB$INDICES WHERE COALESCE(RDB$SYSTEM_FLAG, 0) <> 1';
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
          qry.SQL.Add('SET STATISTICS INDEX ' + sl[i] + ';');
      finally
        sl.Free;
      end;
      qry.QuickScript := True;
      qry.ExecSQL;
      qry.Transaction.Commit;
    finally
      qry.Transaction.Free;
      qry.Free;
    end;
  end;

var
  FBUpdate: TFBUpdate;
  Msg: string;
  qry: TUIBQuery;
begin
  Result := False;

  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := GetTransaction(UIBDataBase);

    qry.SQL.Text := 'SELECT VALEUR FROM OPTIONS WHERE Nom_option = ?';
    qry.Params.AsString[0] := 'Version';
    qry.Open;
    if not qry.Eof then
      CurrentVersion := qry.Fields.AsString[0]
    else
    begin
      CurrentVersion := '0.0.0.0';
      try
        qry.SQL.Text := 'INSERT INTO OPTIONS (Nom_Option, Valeur) VALUES (?, ?)';
        qry.Prepare(True);
        qry.Params.AsString[0] := 'Version';
        qry.Params.AsString[1] := Copy(CurrentVersion, 1, qry.Params.MaxStrLen[0]);
        qry.ExecSQL;
      except
        // Pour s'assurer qu'il y'a la ligne dans la table options
      end;
    end;

  finally
    qry.Transaction.Free;
    qry.Free;
  end;

  Msg := 'BDthèque ne peut pas utiliser cette base de données.'#13#10'Version de la base de données: ' + CurrentVersion;

  if (CurrentVersion > ListFBUpdates.Last.Version) and (CurrentVersion > TGlobalVar.Utilisateur.ExeVersion) then
  begin
    ShowMessage('Base de données trop récente.'#13#10 + Msg);
    Exit;
  end;

  if (ListFBUpdates.Last.Version > CurrentVersion) or (UIBDataBase.InfoPageSize < DBPageSize) then
  begin
    if not(Force or (MessageDlg(Msg + #13#10'Voulez-vous la mettre à jour?', mtConfirmation, [mbYes, mbNo], 0) = mrYes)) then
      Exit;

    MAJ_ODS(False);

    for FBUpdate in ListFBUpdates do
      ProcessUpdate(FBUpdate.Version, FBUpdate.UpdateCallback);

    qry := TUIBQuery.Create(nil);
    try
      qry.Transaction := GetTransaction(UIBDataBase);

      qry.SQL.Text := 'UPDATE OPTIONS SET Valeur = ? WHERE Nom_Option = ?';
      qry.Params.AsString[0] := ListFBUpdates.Last.Version;
      qry.Params.AsString[1] := 'Version';
      qry.ExecSQL;
      qry.Transaction.Commit;
    finally
      qry.Transaction.Free;
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
  Done := not Historique.Waiting;
  if Historique.Waiting then
    Historique.ProcessNext;
end;

procedure TdmPrinc.ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
begin
  if (Msg.message = WM_SYSCOMMAND) and (Msg.wParam = SC_CLOSE) and Assigned(frmFond) then
  begin
    Handled := True;
    frmFond.actQuitter.Execute;
  end;
end;

procedure TdmPrinc.DataModuleCreate(Sender: TObject);
begin
  FUILock := TCriticalSection.Create;
  MakeJumpList;
end;

procedure TdmPrinc.DataModuleDestroy(Sender: TObject);
begin
  UIBDataBase.Connected := False;
  FUILock.Free;
end;

procedure TdmPrinc.MakeJumpList;
var
  jl: TJumpList;
begin
  // pas besoin de vérifier si on est au moins en Windows 7, TJumpList le fait
  jl := TJumpList.Create(nil);
  try
    jl.Tasks.AddShellLink('Ajouter un nouvel album', '/album=new', '', '', 2);
    jl.Tasks.AddShellLink('Ajouter une nouvelle série', '/serie=new', '', '', 2);
    jl.Tasks.AddShellLink('Ajouter un nouvel auteur', '/auteur=new', '', '', 2);
    jl.DisplayKnowCategories := [jlkcRecent];
    jl.Commit;
  finally
    jl.Free;
  end;
end;

function TdmPrinc.CheckVersion(Force: Boolean): Boolean;
// Valeurs de retour:
// False: pas de mise à jour ou mise à jour "reportée"
// True: mise à jour et utilisateur demande à fermer l'appli
var
  doVerif: Boolean;
begin
  if Force then
    doVerif := True
  else
    case TGlobalVar.Utilisateur.Options.VerifMAJDelai of
      0: // jamais de verification
        doVerif := False;
      1: // à chaque démarrage
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
    if Procedures.FindCmdLineSwitch(cmdLine, 'album', ParamValue) then
    begin
      PageToOpen := fcAlbum;
      gestAdd := AjouterAlbums;
    end
    else if Procedures.FindCmdLineSwitch(cmdLine, 'serie', ParamValue) then
    begin
      PageToOpen := fcSerie;
      gestAdd := AjouterSeries;
    end
    else if Procedures.FindCmdLineSwitch(cmdLine, 'auteur', ParamValue) then
    begin
      PageToOpen := fcAuteur;
      gestAdd := AjouterAuteurs;
    end;
    ForceGestion := SameText(ParamValue, 'new');
    if not ForceGestion and (PageToOpen <> fcActionBack) then
      GuidToOpen := StringToGUID(ParamValue);
    // je force en mode gestion quand on demande la création d'un nouvel élément
    // mais rien n'y oblige
    if not TGlobalVar.Utilisateur.Options.ModeDemarrage or ForceGestion then
      ModeToOpen := fcModeGestion;
    if Procedures.FindCmdLineSwitch(cmdLine, 'scripts') then
    begin
      ModeToOpen := fcModeGestion;
      PageToOpen := fcScripts;
      ForceGestion := False;
    end;
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
begin
  TGlobalVar.Mode_en_cours := mdLoad;
  Application.Title := '© TeträmCorp ' + TitreApplication + ' ' + TGlobalVar.Utilisateur.AppVersion;
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

  FrmSplash := TFrmSplash.Create(nil);
  try
    FrmSplash.Show;
    Application.ProcessMessages;
    Debut := Now;

    FrmSplash.Affiche_act(VerificationVersion + '...');
    if dmPrinc.CheckVersion(False) then
      Exit;
    if not OuvreSession then
      Exit;
    if not dmPrinc.CheckVersions(FrmSplash.Affiche_act) then
      Exit;

    FrmSplash.Affiche_act(ChargementOptions + '...');
    LitOptions;

    FrmSplash.Affiche_act(ChargementApp + '...');
    Application.CreateForm(TfrmFond, frmFond);
    FrmSplash.Affiche_act(ChargementDatabase + '...');
    Historique.AddConsultation(fcRecherche);
    AnalyseLigneCommande(GetCommandLine);

    FrmSplash.Affiche_act(FinChargement + '...');
    ChangeCurseur(crHandPoint, 'MyHandPoint', 'MyCursor');
    while SecondsBetween(Now, Debut) < 1 do // au moins 1 seconde d'affichage du splash
    begin
      FrmSplash.Show;
      FrmSplash.Update;
    end;
  finally
    FrmSplash.Free;
  end;
  Application.MainForm.Show;
end;

end.
