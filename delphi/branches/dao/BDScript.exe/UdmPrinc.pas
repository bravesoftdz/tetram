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
  System.DateUtils, System.UITypes, Divers, UfrmScripts, System.IOUtils,
  UScriptEngineIntf, UMasterEngine, UScriptList, dwsJSON, Entities.Full,
  JclCompression, Entities.Deserializer, Entities.FactoriesFull,
  Entities.DaoLambdaJSON;

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

procedure ReadExternalData;
var
  fileName: TFileName;
  Archive: TJcl7zDecompressArchive;
  s: TStringStream;
begin
  fileName := TPath.ChangeExtension(CommonConst.DatabasePath, '.mtd');
  if not TFile.Exists(fileName) then
    Exit;
  s := TStringStream.Create;
  Archive := TJcl7zDecompressArchive.Create(fileName);
  try
    Archive.ListFiles;
    Archive.Items[0].Stream := s;
    Archive.Items[0].OwnsStream := False;
    Archive.Items[0].Selected := True;
    Archive.ExtractSelected;
    TDaoListeJSON.json := s.DataString;
  finally
    Archive.Free;
    s.Free;
  end;
end;

procedure AutoRun(DataFile: TFileName);
var
  masterEngine: IMasterEngine;
  Script: TScript;
  AlbumToImport: TAlbumFull;
  o: TdwsJSONObject;
  js: TStringStream;
  Archive: TJcl7zDecompressArchive;
begin
  js := TStringStream.Create;
  Archive := TJcl7zDecompressArchive.Create(DataFile);
  try
    Archive.ListFiles;
    Archive.Items[0].Stream := js;
    Archive.Items[0].OwnsStream := False;
    Archive.Items[0].Selected := True;
    Archive.ExtractSelected;

    o := TdwsJSONObject.ParseString(js.DataString) as TdwsJSONObject;
  finally
    Archive.Free;
    js.Free;
  end;

  AlbumToImport := TEntitesDeserializer.BuildEntityFromJson<TAlbumFull, TFactoryAlbumFull>(o.Items['album'] as TdwsJSONObject);
  try
    Script := masterEngine.ScriptList.FindScriptByUnitName(o.Items['options'].Items['script'].AsString, [skMain]);
    if Assigned(Script) then
    begin
      masterEngine := TMasterEngine.Create;
      masterEngine.SelectProjectScript(Script);
      masterEngine.AlbumToImport := AlbumToImport;
      if masterEngine.Engine.Run then
      begin

      end;
    end;
  finally
    AlbumToImport.Free;
  end;
end;

procedure BdtkInitProc;
var
  Debut: TDateTime;
  hdl: THandle;
  data: RMSGSendData;
  CD: TCopyDataStruct;
  s, scriptAutoRun: string;
  frmSplash: TfrmSplash;
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
    ReadExternalData;
    AutoRun(scriptAutoRun);
  end
  else
  begin
    Application.MainFormOnTaskbar := True;
    frmSplash := TfrmSplash.Create(nil);
    try
      frmSplash.fileName := TPath.Combine(TPath.GetLibraryPath, 'bd.exe');
      frmSplash.Show;
      Application.ProcessMessages;
      Debut := Now;

      ChangeCurseur(crHandPoint, 'CUR_HANDPOINT', RT_RCDATA);

      frmSplash.Affiche_act(ChargementApp + '...');
      ReadExternalData;
      Application.CreateForm(TfrmScripts, frmScripts);
      AnalyseLigneCommande(GetCommandLine);

      frmSplash.Affiche_act(FinChargement + '...');
      while SecondsBetween(Now, Debut) < 1 do // au moins 1 seconde d'affichage du splash
      begin
        frmSplash.Show;
        frmSplash.Update;
      end;
    finally
      frmSplash.Free;
    end;
  end;
  if Assigned(Application.MainForm) then
    Application.MainForm.Show;
end;

initialization

InitProc := @BdtkInitProc;

end.
