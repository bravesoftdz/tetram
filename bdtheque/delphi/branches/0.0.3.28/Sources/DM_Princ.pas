unit DM_Princ;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, JvUIB, AppEvnts, IdComponent, IdTCPServer,
  TrayIcon, IdCustomHTTPServer, IdHTTPServer, IdBaseComponent, SyncObjs, jpeg, Menus, Main, IdISAPIRunner;

const
  AntiAliasing = True;

type
  TAffiche_act = procedure(Texte: string) of object;

  TDMPrinc = class(TDataModule)
    UIBDataBase: TJvUIBDataBase;
    ApplicationEvents1: TApplicationEvents;
    HTTPServer: TIdHTTPServer;
    UIBBackup: TJvUIBBackup;
    UIBRestore: TJvUIBRestore;
    TrayIcon: TTrayIcon;
    PopupMenu: TPopupMenu;
    Quitter1: TMenuItem;
    N1: TMenuItem;
    Afficher1: TMenuItem;
    WebServer1: TMenuItem;
    N2: TMenuItem;
    Apropos1: TMenuItem;
    Dmarrer1: TMenuItem;
    DchargerISAPI1: TMenuItem;
    Apropos2: TMenuItem;
    Cheminbase1: TMenuItem;
    N3: TMenuItem;
    ISAPIRunner: TidISAPIRunner;
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
    procedure DataModuleCreate(Sender: TObject);
    procedure HTTPServerCommandGet(AThread: TIdPeerThread; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure DataModuleDestroy(Sender: TObject);
    procedure ISAPIRunnerLogServerMessage(Sender: TObject; RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo; AMessage: string);
    procedure HTTPServerCommandOther(Thread: TIdPeerThread; const asCommand, asData, asVersion: string);
    procedure HTTPServerConnect(AThread: TIdPeerThread);
    procedure HTTPServerDisconnect(AThread: TIdPeerThread);
    procedure HTTPServerExecute(AThread: TIdPeerThread);
    procedure HTTPServerStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
    procedure TrayIconDblClick(Sender: TObject; Shift: TShiftState);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure ApplicationEvents1Restore(Sender: TObject);
    procedure Afficher1Click(Sender: TObject);
    procedure TrayIconMouseUp(Sender: TObject; Shift: TShiftState);
  private
    { D�clarations priv�es }
    FUILock: TCriticalSection;
    FActiveIcon: TIcon;
    FConnected: Integer;
    procedure DisplayMessage(const Msg: string);
  public
    { D�clarations publiques }
    function CheckVersions(Affiche_act: TAffiche_act; Force: Boolean = True): Boolean;
    function ActiveHTTPServer(Value: Boolean): Boolean;
  end;

function OuvreSession: Boolean;

function DMPrinc: TDMPrinc;

implementation

{$R *.DFM}

uses
  CommonConst, Commun, Textes, DM_Commun, JvUIBLib, Divers, IniFiles, Procedures, UHistorique, Math,
  Updates;

var
  FDMPrinc: TDMPrinc = nil;

function DMPrinc: TDMPrinc;
var
  cs: TCriticalSection;
begin
  if not Assigned(FDMPrinc) then begin
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
    with DMPrinc do begin
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
    if not Assigned(DataCommun) then Application.CreateForm(TDataCommun, DataCommun);
  except
    AffMessage(rsOuvertureSessionRate + #13#13 + Exception(ExceptObject).Message, mtError, [mbOk], True);
    Result := False;
  end;
end;

function TDMPrinc.CheckVersions(Affiche_act: TAffiche_act; Force: Boolean): Boolean;
var
  CurrentVersion: string;
  Query: TJvUIBQuery;

type
  TProcedure = procedure(Query: TJvUIBScript);

  procedure ProcessUpdate(const Version: string; ProcMAJ: TProcedure);
  var
    Script: TJvUIBScript;
  begin
    if CompareVersionNum(Version, CurrentVersion) > 0 then
      with Query do begin
        Affiche_act('Mise � jour ' + Version + '...');
        Script := TJvUIBScript.Create(nil);
        try
          Script.Transaction := Query.Transaction;
          ProcMAJ(Script);
        finally
          Script.Free;
        end;
        SQL.Text := 'UPDATE OPTIONS SET Valeur = ? WHERE Nom_Option = ''Version''';
        Params.AsString[0] := Version;
        ExecSQL;
        Transaction.Commit;
        CurrentVersion := Version;
      end;
  end;

var
  Compare, i: Integer;
  msg: string;
begin
  Result := False;
  Utilisateur.ExeVersion := GetFichierVersion(Application.ExeName);
  Query := TJvUIBQuery.Create(nil);
  with Query do try
    Transaction := GetTransaction(UIBDataBase);
    SQL.Text := 'SELECT VALEUR FROM OPTIONS WHERE Nom_option = ''Version''';
    Open;
    if not Eof then
      CurrentVersion := Fields.AsString[0]
    else begin
      CurrentVersion := '0.0.0.0';
      try
        SQL.Text := 'INSERT INTO OPTIONS (Nom_Option, Valeur) VALUES (''Version'', ?)';
        Params.AsString[0] := CurrentVersion;
        ExecSQL;
      except
        // Pour s'assurer qu'il y'a la ligne dans la table options
      end;
    end;
    msg := 'BDth�que ne peut pas utiliser cette base de donn�es.'#13#10'Version de la base de donn�es: ' + CurrentVersion;

    Compare := CompareVersionNum(Utilisateur.ExeVersion, CurrentVersion);
    if Compare < 0 then begin // CurrentVersion > Utilisateur.ExeVersion
      ShowMessage(msg);
      Exit;
    end;

    if Compare > 0 then begin // Utilisateur.ExeVersion > CurrentVersion
      if not (Force or (MessageDlg(msg + #13#10'Voulez-vous la mettre � jour?', mtConfirmation, [mbYes, mbNo], 0) = mrYes)) then Exit;
      for i := 0 to Pred(ListUpdates.Count) do
        with TUpdate(ListUpdates[i]) do
          ProcessUpdate(Version, UpdateCallback);

      SQL.Text := 'UPDATE OPTIONS SET Valeur = ? WHERE Nom_Option = ''Version''';
      Params.AsString[0] := Utilisateur.ExeVersion;
      ExecSQL;
      Transaction.Commit;
      if not Force then ShowMessage('Mise � jour termin�e.');
    end;
    Result := True;
  finally
    Transaction.Free;
    Free;
  end;
end;

procedure TDMPrinc.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  Done := not Historique.Waiting;
  if Historique.Waiting then
    Historique.ProcessNext;
end;

procedure TDMPrinc.ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
begin
  if (Msg.message = WM_SYSCOMMAND) and (Msg.wParam = SC_CLOSE) and Assigned(Fond) then begin
    Handled := True;
    Fond.Quitter.Execute;
  end;
end;

procedure TDMPrinc.DataModuleCreate(Sender: TObject);
begin
  FUILock := TCriticalSection.Create;
  FActiveIcon := TIcon.Create;
  FActiveIcon.Handle := LoadIcon(HInstance, 'ServerWorking');
  HTTPServer.ServerSoftware := Application.Title;
end;

procedure TDMPrinc.DataModuleDestroy(Sender: TObject);
begin
  ActiveHTTPServer(False);
  FreeAndNil(FActiveIcon);
  UIBDataBase.Connected := False;
  FreeAndnil(FUILock);
end;

function TDMPrinc.ActiveHTTPServer(Value: Boolean): Boolean;
var
  Info: IInformation;
begin
  Info := TInformation.Create;
  Result := False;
  //  lbSessionList.Items.Clear;
  if not HTTPServer.Active then begin
    HTTPServer.Bindings.Clear;
    HTTPServer.DefaultPort := Utilisateur.Options.WebServerPort;
    HTTPServer.Bindings.Add;
  end;

  if Value then begin
    try
      Info.ShowInfo('D�marrage du WebServer...');
      //      EnableLog := cbEnableLog.Checked;
      HTTPServer.Active := True;
      DisplayMessage(Format('Listening for HTTP connections on %s:%d.', [HTTPServer.Bindings[0].IP, HTTPServer.Bindings[0].Port]));
      FConnected := 0;
      TrayIcon.Tip := Application.Title;
      TrayIcon.Active := True;
      Result := True;
    except
      on e: exception do begin
        DisplayMessage(Format('Exception %s in Activate. Error is:"%s".', [e.ClassName, e.Message]));
      end;
    end;
  end
  else begin
    Info.ShowInfo('Arr�t du WebServer...');
    TrayIcon.Active := False or IsIconic(Application.Handle);
    HTTPServer.Active := False;
    DisplayMessage('Stop listening.');
    Result := True;
  end;
end;

procedure TDMPrinc.DisplayMessage(const Msg: string);
begin
  //  if EnableLog then begin
  //    FUILock.Acquire;
  //    try
  //      lbLog.ItemIndex := lbLog.Items.Add(Msg);
  //    finally
  //      FUILock.Release;
  //    end;
  //  end;
end;

const
  sauthenticationrealm = 'BDtheque http server';

procedure TDMPrinc.HTTPServerCommandGet(AThread: TIdPeerThread; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);

  procedure AuthFailed;
  begin
    AResponseInfo.ContentText := '<html><head><title>Error</title></head><body><h1>Authentication failed</h1>'#13 +
      'Check the demo source code to discover the password:<br><ul><li>Search for <b>AuthUsername</b> in <b>Main.pas</b>!</ul></body></html>';
    AResponseInfo.AuthRealm := sauthenticationrealm;
  end;

  procedure AccessDenied;
  begin
    AResponseInfo.ContentText := '<html><head><title>Error</title></head><body><h1>Access denied</h1>'#13 +
      'You do not have sufficient priviligies to access this document.</body></html>';
    AResponseInfo.ResponseNo := 403;
  end;

var
  LocalDoc: string;
  ByteSent: Cardinal;
  ResultFile: TStream;
  Action: string;
  p: Integer;
begin
  // Log the request
  DisplayMessage(Format('Command %s %s received from %s:%d', [ARequestInfo.Command,
    ARequestInfo.Document,
      AThread.Connection.Socket.Binding.PeerIP,
      AThread.Connection.Socket.Binding.PeerPort]));

  LocalDoc := '';
  if (ARequestInfo.Document = '') or (ARequestInfo.Document = '/') then begin
    AResponseInfo.Redirect('http://' + ARequestInfo.Host + '/WebServer/');
    Exit;
  end;
  p := Pos('webserver', LowerCase(ARequestInfo.Document));
  if p in [1, 2] then begin
    LocalDoc := ARequestInfo.Document;
    Action := Copy(LocalDoc, p + Length('WebServer'), Length(LocalDoc));
    //    LocalDoc := WebServerDLL;
    LocalDoc := Application.ExeName;
  end;

  if LocalDoc <> '' then begin
    //    LocalDoc := ExpandFileName(ExtractFilePath(Application.ExeName) + LocalDoc);
    if Action = '' then begin
      AResponseInfo.Redirect('http://' + ARequestInfo.Host + '/WebServer/');
      Exit;
    end
    else
      Action := Copy(Action, 2, Length(Action));
    if FileExists(LocalDoc) then begin
      ISAPIRunner.Execute(LocalDoc, AThread, ARequestInfo, AResponseInfo, WebServerPath, False, Action);
    end
    else begin
      AResponseInfo.ContentText := '<H1><center>Script not found</center></H1>';
      AResponseInfo.ResponseNo := 404; // Not found
    end;
  end
  else begin
    LocalDoc := ExpandFileName(WebServerPath + ARequestInfo.Document);

    if AnsiSameText(Copy(LocalDoc, 1, Length(WebServerPath)), WebServerPath) then begin // File down in dir structure
      if AnsiSameText(Copy(LocalDoc, 1, Length(WebServerPath + 'Couverture')), WebServerPath + 'Couverture') then
        ResultFile := GetCouvertureStream(StrToIntDef(ARequestInfo.Params.Values['RefCouverture'], -1),
          StrToIntDef(ARequestInfo.Params.Values['Height'], -1),
          StrToIntDef(ARequestInfo.Params.Values['Width'], -1),
          Utilisateur.Options.WebServerAntiAliasing);

      if FileExists(LocalDoc) or Assigned(ResultFile) then begin // File exists
        if AnsiSameText(ARequestInfo.Command, 'HEAD') then begin
          // HEAD request, don't send the document but still send back it's size
          if not Assigned(ResultFile) then begin
            ResultFile := TFileStream.Create(LocalDoc, fmOpenRead or fmShareDenyWrite);
            AResponseInfo.ContentType := HTTPServer.MIMETable.GetFileMIMEType(LocalDoc);
          end
          else
            AResponseInfo.ContentType := HTTPServer.MIMETable.GetFileMIMEType('.jpg');

          try
            AResponseInfo.ResponseNo := 200;
            AResponseInfo.ContentLength := ResultFile.Size;
          finally
            FreeAndNil(ResultFile); // We must free this file since it won't be done by the web server component
          end;
        end
        else begin
          // Normal document request
          // Send the document back
          if Assigned(ResultFile) then begin
            AResponseInfo.ContentType := HTTPServer.MIMETable.GetFileMIMEType('.jpg');
            AResponseInfo.ContentStream := ResultFile;
            AResponseInfo.FreeContentStream := True;
            ByteSent := ResultFile.Size;
          end
          else begin
            AResponseInfo.ContentType := '';
            ByteSent := HTTPServer.ServeFile(AThread, AResponseInfo, LocalDoc);
          end;
          DisplayMessage(Format('Serving file %s (%d bytes / %d bytes sent) to %s:%d', [LocalDoc,
            ByteSent,
              ResultFile.Size,
              AThread.Connection.Socket.Binding.PeerIP,
              AThread.Connection.Socket.Binding.PeerPort]));
        end;
      end
      else begin
        AResponseInfo.ResponseNo := 404; // Not found
        AResponseInfo.ContentText := '<html><head><title>Error</title></head><body><h1>' + AResponseInfo.ResponseText + '</h1>' + ARequestInfo.Document + '</body></html>';
      end;
    end
    else
      AccessDenied;
  end;
end;

procedure TDMPrinc.ISAPIRunnerLogServerMessage(Sender: TObject; RequestInfo: TIdHTTPRequestInfo; ResponseInfo: TIdHTTPResponseInfo; AMessage: string);
begin
  DisplayMessage(Amessage);
end;

procedure TDMPrinc.HTTPServerCommandOther(Thread: TIdPeerThread; const asCommand, asData, asVersion: string);
begin
  DisplayMessage('Command other: ' + asCommand);
end;

procedure TDMPrinc.HTTPServerConnect(AThread: TIdPeerThread);
begin
  FUILock.Acquire;
  try
    if FConnected = 0 then
      TrayIcon.Icon.Assign(FActiveIcon);
    Inc(FConnected);
  finally
    FUILock.Release;
  end;
  DisplayMessage('User logged in');
end;

procedure TDMPrinc.HTTPServerDisconnect(AThread: TIdPeerThread);
begin
  FUILock.Acquire;
  try
    FConnected := Max(0, Pred(FConnected));
    if FConnected = 0 then
      TrayIcon.Icon.Assign(Application.Icon);
  finally
    FUILock.Release;
  end;
  DisplayMessage('User logged out');
end;

procedure TDMPrinc.HTTPServerExecute(AThread: TIdPeerThread);
begin
  DisplayMessage('Execute');
end;

procedure TDMPrinc.HTTPServerStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
begin
  DisplayMessage('Status: ' + aStatusText);
end;

procedure TDMPrinc.TrayIconDblClick(Sender: TObject; Shift: TShiftState);
begin
  Application.Restore;
end;

procedure TDMPrinc.ApplicationEvents1Minimize(Sender: TObject);
begin
  if HTTPServer.Active then ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TDMPrinc.ApplicationEvents1Restore(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_SHOWNORMAL);
  SetForegroundWindow(Application.Handle);
  TrayIcon.Active := HTTPServer.Active;
end;

procedure TDMPrinc.Afficher1Click(Sender: TObject);
begin
  Application.Restore;
end;

procedure TDMPrinc.TrayIconMouseUp(Sender: TObject; Shift: TShiftState);
begin
  SetForegroundWindow(Application.Handle);
  if IsIconic(Application.Handle) then PopupMenu.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y);
end;

end.
