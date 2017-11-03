unit UdmPrinc;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, Vcl.Dialogs, Winapi.Messages,
  Vcl.ImgList, Vcl.Controls, PngImageList;

const
  MSG_COMMANDELINE = WM_USER + 1;
  MSG_ACTIVATE = WM_USER + 2;

type
  RMSGSendData = record
    l: Integer;
    a: array [0 .. 2047] of Char;
  end;

  TdmPrinc = class(TDataModule)
    ShareImageList: TPngImageList;
  private
    class function getInstance: TdmPrinc;
  strict private
    class var _instance: TdmPrinc;
  public

  end;

function dmPrinc: TdmPrinc;

implementation

uses
  System.SyncObjs, Vcl.Forms, System.StrUtils, UfrmSplash, CommonConst, Textes, System.DateUtils, System.UITypes, Divers, UfrmScripts, System.IOUtils,
  UScriptEngineIntf, UMasterEngine, UScriptList, dwsJSON, Entities.Full, JclCompression, Entities.Deserializer, Entities.FactoriesFull, Entities.DaoLambdaJSON,
  Entities.Serializer, JsonSerializer, Entities.Lite, Commun,
  System.Generics.Collections;

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
  // // je force en mode gestion quand on demande la cr�ation d'un nouvel �l�ment
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
  Archive: TJcl7zDecompressArchive;
  s: TStringStream;
begin
  if not TFile.Exists(FileScriptsMetadata) then
    Exit;
  s := TStringStream.Create;
  Archive := TJcl7zDecompressArchive.Create(FileScriptsMetadata);
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

procedure BuildResult(AlbumToImport: TAlbumFull; DataFile: TFileName);
var
  Archive: TJcl7zCompressArchive;
  o: TdwsJSONObject;
  i: Integer;
  Edition: TEditionFull;
  Couverture: TCouvertureLite;
  ListFiles: TList<TFileName>;
  fileName: string;
begin
  if TFile.Exists(DataFile) then
    TFile.Delete(DataFile);

  ListFiles := TList<TFileName>.Create;
  try
    Archive := TJcl7zCompressArchive.Create(DataFile);
    o := TdwsJSONObject.Create;
    try
      for i := 0 to Pred(AlbumToImport.Serie.Genres.Count) do
        if AlbumToImport.Serie.Genres.Names[i] = '' then
          AlbumToImport.Serie.Genres[i] := sGUID_NULL + '=' + AlbumToImport.Serie.Genres[i];

      for Edition in AlbumToImport.Editions do
        for Couverture in Edition.Couvertures do
        begin
          Archive.AddFile(TPath.GetFileName(Couverture.NewNom), Couverture.NewNom);
          ListFiles.Add(Couverture.NewNom);
          Couverture.NewNom := TPath.GetFileName(Couverture.NewNom);
          Couverture.OldNom := Couverture.NewNom;
        end;

      TEntitesSerializer.WriteToJSON(AlbumToImport, o.AddObject('album'), [soSkipNullValues]);
      Archive.AddFile('data.json', TStringStream.Create({$IFNDEF DEBUG}o.ToString{$ELSE}o.ToBeautifiedString{$ENDIF}), True);

      Archive.Compress;
    finally
      o.Free;
      Archive.Free;
    end;

    for fileName in ListFiles do
      TFile.Delete(fileName);
  finally
    ListFiles.Free;
  end;
end;

procedure AutoRun(DataFile: TFileName);
var
  scriptName: string;
  masterEngine: IMasterEngine;
  Script: TScript;
  AlbumToImport: TAlbumFull;
  o: TdwsJSONObject;
  js: TStringStream;
  Archive: TJcl7zDecompressArchive;
  Msg: IMessageInfo;
  params: TdwsJSONValue;
  defaultSearch: TdwsJSONValue;
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
{$IFNDEF DEBUG}
  TFile.Delete(DataFile);
{$ENDIF}
  masterEngine := TMasterEngine.Create;
  AlbumToImport := TEntitesDeserializer.BuildEntityFromJson<TAlbumFull, TFactoryAlbumFull>(o.Items['album'] as TdwsJSONObject);
  try
    params := o.Items['params'];
    defaultSearch := params.Items['defaultSearch'];
    if defaultSearch.IsDefined then
      AlbumToImport.defaultSearch := params.Items['defaultSearch'].AsString;
    scriptName := params.Items['script'].AsString;

    masterEngine.ScriptList.LoadDir(RepScripts);
    Script := masterEngine.ScriptList.FindScriptByUnitName(scriptName, [skMain]);
    if Assigned(Script) then
    begin
      masterEngine.SelectProjectScript(Script);
      masterEngine.Engine.UseDebugInfo := False;
      masterEngine.AlbumToImport := AlbumToImport;
      if masterEngine.Engine.Compile(Script, Msg) then
      begin
        if masterEngine.Engine.Run then
        begin
          if AlbumToImport.ReadyToImport then
          begin
            BuildResult(AlbumToImport, DataFile);
            ExitCode := ScriptRunOK;
          end
          else
            ExitCode := ScriptRunOKNoImport;
        end
        else
        begin
          ExitCode := ScriptRunError;
          if (masterEngine.DebugPlugin.Messages.ItemCount > 0) then
            ShowMessageFmt('Erreur d''ex�cution du script "%s" :'#13#10'%s', [scriptName, masterEngine.DebugPlugin.Messages[0]])
          else
            ShowMessageFmt('Erreur inconnue d''ex�cution du script "%s"', [scriptName]);
        end;
      end
      else
      begin
        ExitCode := ScriptCompileError;
        if Assigned(Msg) then
          ShowMessageFmt('Impossible de compiler le script "%s" :'#13#10'%s', [scriptName, Msg.Text])
        else
          ShowMessageFmt('Impossible de compiler le script "%s"', [scriptName]);
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
  Application.Title := '� Tetr�mCorp ' + TitreApplication + ' ' + TGlobalVar.Utilisateur.AppVersion;
  if not LongBool(CreateMutex(nil, True, 'TetramCorpBDScriptMutex')) then
    RaiseLastOSError
  else if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    hdl := GetHandleOtherInstance;
    if hdl = 0 then
      // c'est pas vrai mais bon... comme on devrait jamais passer l�...
      ShowMEssage('Une instance de BDth�que est d�j� ouverte!')
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

  // l'instance de dmPrinc doit exister pour que les images des boutons s'affichent correctement
  dmPrinc;

  if FindCmdLineSwitch('run', scriptAutoRun, True, [clstValueNextParam]) then
  begin
    if TFile.Exists(scriptAutoRun) then
    begin
      Application.MainFormOnTaskbar := False;
      // if FindCmdLineSwitch('dh', s, True, [clstValueNextParam]) then
      // Application.DialogHandle := StrToIntDef(s, Application.DialogHandle);
      ReadExternalData;
      AutoRun(scriptAutoRun);
    end;
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
