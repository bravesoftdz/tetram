unit UdmPrinc;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, Vcl.Dialogs,
  Winapi.Messages;

const
  MSG_COMMANDELINE = WM_USER + 1;
  MSG_ACTIVATE = WM_USER + 2;

type
  RMSGSendData = record
    l: Integer;
    a: array [0 .. 2047] of Char;
  end;

  TdmPrinc = class(TDataModule)
  private
    class function getInstance: TdmPrinc;
  strict private
    class var _instance: TdmPrinc;
  public

  end;

function dmPrinc: TdmPrinc;

implementation

uses
  System.SyncObjs, Vcl.Forms, System.StrUtils, UfrmSplash, CommonConst, Textes,
  System.DateUtils, System.UITypes, Divers, UfrmScripts;

{$R *.dfm}

function dmPrinc: TdmPrinc;
begin
  Result := TdmPrinc.getInstance;
end;

{ TdmPrinc }

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

procedure AnalyseLigneCommande(cmdLine: string);
// var
// gestAdd: TActionGestionAdd;
// ForceGestion: Boolean;
// PageToOpen: TActionConsultation;
// ModeToOpen: TActionConsultation;
// ParamValue: string;
// GuidToOpen: TGUID;
begin
  // if TGlobalVar.Mode_en_cours <> mdEditing then
  // begin
  // ModeToOpen := fcModeConsultation;
  // PageToOpen := fcActionBack;
  // gestAdd := nil;
  // if Procedures.FindCmdLineSwitch(cmdLine, 'album', ParamValue) then
  // begin
  // PageToOpen := fcAlbum;
  // gestAdd := AjouterAlbums;
  // end
  // else if Procedures.FindCmdLineSwitch(cmdLine, 'serie', ParamValue) then
  // begin
  // PageToOpen := fcSerie;
  // gestAdd := AjouterSeries;
  // end
  // else if Procedures.FindCmdLineSwitch(cmdLine, 'auteur', ParamValue) then
  // begin
  // PageToOpen := fcAuteur;
  // gestAdd := AjouterAuteurs;
  // end;
  // ForceGestion := SameText(ParamValue, 'new');
  // if not ForceGestion and (PageToOpen <> fcActionBack) then
  // GuidToOpen := StringToGUID(ParamValue);
  // // je force en mode gestion quand on demande la création d'un nouvel élément
  // // mais rien n'y oblige
  // if not TGlobalVar.Utilisateur.Options.ModeDemarrage or ForceGestion then
  // ModeToOpen := fcModeGestion;
  // if Procedures.FindCmdLineSwitch(cmdLine, 'scripts') then
  // begin
  // ModeToOpen := fcModeGestion;
  // PageToOpen := fcScripts;
  // ForceGestion := False;
  // end;
  // Historique.AddWaiting(ModeToOpen);
  // // if ModeToOpen <> fcModeScript then
  // if ForceGestion then
  // Historique.AddWaiting(fcGestionAjout, nil, nil, @gestAdd, nil, '')
  // else
  // Historique.AddWaiting(PageToOpen, GuidToOpen);
  // end;
end;

procedure BdtkInitProc;
var
  Debut: TDateTime;
  hdl: THandle;
  data: RMSGSendData;
  CD: TCopyDataStruct;
  s, scriptAutoRun: string;
begin
  TGlobalVar.Mode_en_cours := mdLoad;
  Application.Title := '© TeträmCorp ' + TitreApplication + ' ' + TGlobalVar.Utilisateur.AppVersion;
  if not LongBool(CreateMutex(nil, True, 'TetramCorpBDScriptMutex')) then
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

  if FindCmdLineSwitch('run', scriptAutoRun, True, [clstValueNextParam]) then
  begin
    Application.MainFormOnTaskbar := False;
    if FindCmdLineSwitch('dh', s, True, [clstValueNextParam]) then
      Application.DialogHandle := StrToIntDef(s, Application.DialogHandle);
  end
  else
  begin
    Application.MainFormOnTaskbar := True;
    FrmSplash := TFrmSplash.Create(nil);
    try
      FrmSplash.Show;
      Application.ProcessMessages;
      Debut := Now;

      FrmSplash.Affiche_act(ChargementApp + '...');
      Application.CreateForm(TfrmScripts, frmScripts);
      AnalyseLigneCommande(GetCommandLine);

      FrmSplash.Affiche_act(FinChargement + '...');
      ChangeCurseur(crHandPoint, 'CUR_HANDPOINT', RT_RCDATA);
      while SecondsBetween(Now, Debut) < 1 do // au moins 1 seconde d'affichage du splash
      begin
        FrmSplash.Show;
        FrmSplash.Update;
      end;
    finally
      FrmSplash.Free;
    end;
    if Assigned(Application.MainForm) then
      Application.MainForm.Show;
  end;
end;

initialization

InitProc := @BdtkInitProc;

end.
