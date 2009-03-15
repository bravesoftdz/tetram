unit DM_Princ;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, AppEvnts,
  SyncObjs, jpeg, Menus, uib;

const
  AntiAliasing = True;

type
  TAffiche_act = procedure(const Texte: string) of object;

  TDMPrinc = class(TDataModule)
    UIBDataBase: TUIBDataBase;
    ApplicationEvents1: TApplicationEvents;
    UIBBackup: TUIBBackup;
    UIBRestore: TUIBRestore;
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Déclarations privées }
    FUILock: TCriticalSection;
  public
    { Déclarations publiques }
    function CheckVersions(Affiche_act: TAffiche_act; Force: Boolean = True): Boolean;
    function CheckVersion(Force: Boolean): Boolean;
  end;

function OuvreSession: Boolean;

function DMPrinc: TDMPrinc;

implementation

{$R *.DFM}

uses
  CommonConst, Commun, Textes, DM_Commun, UIBLib, Divers, IniFiles, Procedures, UHistorique, Math, UIBase, Updates,
  UfrmFond, CheckVersionNet, DateUtils, UMAJODS;

var
  FDMPrinc: TDMPrinc = nil;

function DMPrinc: TDMPrinc;
var
  cs: TCriticalSection;
begin
  if not Assigned(FDMPrinc) then
  begin
    cs := TCriticalSection.Create;
    cs.Enter;
    try
      Application.CreateForm(TDMPrinc, FDMPrinc);
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
    with DMPrinc do
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
    if not Assigned(DataCommun) then
      Application.CreateForm(TDataCommun, DataCommun);
  except
    AffMessage(rsOuvertureSessionRate + #13#13 + Exception(ExceptObject).Message, mtError, [mbOk], True);
    Result := False;
  end;
end;

function TDMPrinc.CheckVersions(Affiche_act: TAffiche_act; Force: Boolean): Boolean;
var
  CurrentVersion: TFileVersion;
type
  TProcedure = procedure(Query: TUIBScript);

  procedure ProcessUpdate(Version: TFileVersion; ProcMAJ: TProcedure);
  var
    Script: TUIBScript;
  begin
    if (Version > CurrentVersion) and (Version <= TGlobalVar.Utilisateur.ExeVersion) then
    begin
      Affiche_act('Mise à jour ' + Version + '...');
      Script := TUIBScript.Create(nil);
      try
        Script.Transaction := GetTransaction(UIBDatabase);
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
  begin
    with TUIBQuery.Create(nil) do
      try
        Transaction := GetTransaction(UIBDataBase);
        SQL.Text := 'SELECT RDB$INDEX_NAME FROM RDB$INDICES WHERE COALESCE(RDB$SYSTEM_FLAG, 0) <> 1';
        Open;
        with TStringList.Create do
          try
            while not Eof do
            begin
              Add(Fields.AsString[0]);
              Next;
            end;
            Close;

            SQL.Clear;
            for i := 0 to Pred(Count) do
              SQL.Add('SET STATISTICS INDEX ' + Strings[i] + ';');
          finally
            Free;
          end;
        QuickScript := True;
        ExecSQL;
        Transaction.Commit;
      finally
        Transaction.Free;
        Free;
      end;
  end;

var
  i: Integer;
  msg: string;
begin
  Result := False;

  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(UIBDataBase);

      SQL.Text := 'SELECT VALEUR FROM OPTIONS WHERE Nom_option = ''Version''';
      Open;
      if not Eof then
        CurrentVersion := Fields.AsString[0]
      else
      begin
        CurrentVersion := '0.0.0.0';
        try
          SQL.Text := 'INSERT INTO OPTIONS (Nom_Option, Valeur) VALUES (''Version'', ?)';
          Params.AsString[0] := CurrentVersion;
          ExecSQL;
        except
          // Pour s'assurer qu'il y'a la ligne dans la table options
        end;
      end;

    finally
      Transaction.Free;
      Free;
    end;

  msg := 'BDthèque ne peut pas utiliser cette base de données.'#13#10'Version de la base de données: ' + CurrentVersion;

  if CurrentVersion > TGlobalVar.Utilisateur.ExeVersion then
  begin
    ShowMessage('Base de données trop récente.'#13#10 + msg);
    Exit;
  end;

  if TGlobalVar.Utilisateur.ExeVersion > CurrentVersion then
  begin
    if not (Force or (MessageDlg(msg + #13#10'Voulez-vous la mettre à jour?', mtConfirmation, [mbYes, mbNo], 0) = mrYes)) then
      Exit;

    MAJ_ODS;

    for i := 0 to Pred(ListFBUpdates.Count) do
      with TFBUpdate(ListFBUpdates[i]) do
        ProcessUpdate(Version, UpdateCallback);

    with TUIBQuery.Create(nil) do
      try
        Transaction := GetTransaction(UIBDataBase);

        SQL.Text := 'UPDATE OPTIONS SET Valeur = ' + QuotedStr(TGlobalVar.Utilisateur.ExeVersion) + ' WHERE Nom_Option = ''Version'';';
        ExecSQL;
        Transaction.Commit;
      finally
        Transaction.Free;
        Free;
      end;
  end;

  CheckIndex;

  if (TGlobalVar.Utilisateur.ExeVersion > CurrentVersion) and not Force then
    ShowMessage('Mise à jour terminée.');
  Result := True;
end;

procedure TDMPrinc.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  Done := not Historique.Waiting;
  if Historique.Waiting then
    Historique.ProcessNext;
end;

procedure TDMPrinc.ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
begin
  if (Msg.message = WM_SYSCOMMAND) and (Msg.wParam = SC_CLOSE) and Assigned(frmFond) then
  begin
    Handled := True;
    frmFond.actQuitter.Execute;
  end;
end;

procedure TDMPrinc.DataModuleCreate(Sender: TObject);
begin
  FUILock := TCriticalSection.Create;
end;

procedure TDMPrinc.DataModuleDestroy(Sender: TObject);
begin
  UIBDataBase.Connected := False;
  FUILock.Free;
end;

function TDMPrinc.CheckVersion(Force: Boolean): Boolean;
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
    Result := CheckVersionNet.CheckVersion(SansAccents(Application.Title), 'bdtheque', TGlobalVar.Utilisateur.ExeVersion, Force, not Force) = 1;
    with TIniFile.Create(FichierIni) do
      try
        WriteInteger('Divers', 'LastVerifMAJ', Trunc(Now));
      finally
        Free;
      end;
  end;
end;

end.

