unit MAJ;

interface

uses
  Windows, SysUtils, Forms, Controls, ComCtrls, BD.Entities.Lite, BD.Entities.Full, Classes, BD.Utils.StrUtils;

function MAJConsultationAlbum(const Reference: TGUID): Boolean;
function MAJConsultationAuteur(const Reference: TGUID): Boolean;
function MAJConsultationUnivers(const Reference: TGUID): Boolean;
function MAJConsultationParaBD(const Reference: TGUID): Boolean;
function MAJConsultationSerie(const Reference: TGUID): Boolean;
procedure MAJSeriesIncompletes;
procedure MAJPrevisionsSorties;
procedure MAJPrevisionsAchats;
function MAJRunScript(AlbumToImport: TAlbumFull): Boolean;
procedure MAJRecherche(const Reference: TGUID; TypeSimple: Integer = -1; Stream: TMemoryStream = nil);
function MAJGallerie(TypeGallerie: Integer; const Reference: TGUID): Boolean;
function ZoomCouverture(isParaBD: Boolean; const ID_Item, ID_Couverture: TGUID): Boolean;

implementation

uses
  BD.Common, BD.Utils.GUIUtils, BDTK.GUI.Forms.Main, DB, StdCtrls, UfrmSeriesIncompletes, UfrmPrevisionsSorties, Graphics, UfrmConsultationAlbum, UfrmRecherche, UfrmZoomCouverture,
  UfrmConsultationAuteur, UfrmPrevisionAchats, UHistorique, UfrmConsultationParaBD, UfrmConsultationSerie, UfrmGallerie, UfrmConsultationUnivers,
  JclCompression, System.IOUtils, BD.Entities.Utils.Serializer, BDTK.GUI.Utils, BD.Utils.Serializer.JSON, dwsJSON, BD.Entities.Dao.Lambda, UfrmChoixScript, JclSysUtils,
  BD.Entities.Utils.Deserializer, LoadCompletImport, Divers;

function MAJConsultationAuteur(const Reference: TGUID): Boolean;
var
  FDest: TFrmConsultationAuteur;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  // if not (Mode_en_cours in [mdEdit, mdConsult]) then Exit;
  Result := not IsEqualGUID(Reference, GUID_NULL);
  if not Result then
    Exit;
  FDest := TFrmConsultationAuteur.Create(frmFond);
  try
    FDest.ID_Auteur := Reference;
    Historique.SetDescription(FDest.Caption);
    Result := not FDest.Auteur.RecInconnu;
  finally
    frmFond.SetChildForm(FDest);
  end;
end;

function MAJConsultationAlbum(const Reference: TGUID): Boolean;
var
  FDest: TFrmConsultationAlbum;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  // if not (Mode_en_cours in [mdEdit, mdConsult]) then Exit;
  Result := not IsEqualGUID(Reference, GUID_NULL);
  if not Result then
    Exit;
  FDest := TFrmConsultationAlbum.Create(frmFond);
  try
    FDest.ID_Album := Reference;
    Historique.SetDescription(FDest.Caption);
    Result := not FDest.Album.RecInconnu;
  finally
    frmFond.SetChildForm(FDest);
  end;
end;

function MAJConsultationSerie(const Reference: TGUID): Boolean;
var
  FDest: TFrmConsultationSerie;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  // if not (Mode_en_cours in [mdEdit, mdConsult]) then Exit;
  Result := not IsEqualGUID(Reference, GUID_NULL);
  if not Result then
    Exit;
  FDest := TFrmConsultationSerie.Create(frmFond);
  try
    FDest.ID_Serie := Reference;
    Historique.SetDescription(FDest.Caption);
    Result := not FDest.Serie.RecInconnu;
  finally
    frmFond.SetChildForm(FDest);
  end;
end;

function MAJConsultationUnivers(const Reference: TGUID): Boolean;
var
  FDest: TFrmConsultationUnivers;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  // if not (Mode_en_cours in [mdEdit, mdConsult]) then Exit;
  Result := not IsEqualGUID(Reference, GUID_NULL);
  if not Result then
    Exit;
  FDest := TFrmConsultationUnivers.Create(frmFond);
  try
    FDest.ID_Univers := Reference;
    Historique.SetDescription(FDest.Caption);
    Result := not FDest.Univers.RecInconnu;
  finally
    frmFond.SetChildForm(FDest);
  end;
end;

function MAJConsultationParaBD(const Reference: TGUID): Boolean;
var
  FDest: TFrmConsultationParaBD;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  // if not (Mode_en_cours in [mdEdit, mdConsult]) then Exit;
  Result := not IsEqualGUID(Reference, GUID_NULL);
  if not Result then
    Exit;
  FDest := TFrmConsultationParaBD.Create(frmFond);
  try
    FDest.ID_ParaBD := Reference;
    Historique.SetDescription(FDest.Caption);
    Result := not FDest.ParaBD.RecInconnu;
  finally
    frmFond.SetChildForm(FDest);
  end;
end;

procedure _MAJFenetre(FormClass: TFormClass);
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  frmFond.SetChildForm(FormClass.Create(frmFond));
  Historique.SetDescription(frmFond.FCurrentForm.Caption);
end;

procedure MAJPrevisionsAchats;
begin
  _MAJFenetre(TfrmPrevisionsAchats);
end;

procedure MAJPrevisionsSorties;
begin
  _MAJFenetre(TfrmPrevisionsSorties);
end;

procedure MAJSeriesIncompletes;
begin
  _MAJFenetre(TfrmSeriesIncompletes);
end;

procedure MAJRecherche(const Reference: TGUID; TypeSimple: Integer; Stream: TMemoryStream);
var
  FDest: TFrmRecherche;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  if not(TGlobalVar.Mode_en_cours in [mdEdit, mdConsult]) then
    Exit;
  FDest := TFrmRecherche.Create(frmFond);
  with FDest do
  begin
    // le TTreeView est une merde! si on fait la création de noeud avec Data
    // avant l'assignation du Handle, les Data risquent de partir dans la nature

    // TreeView1.HandleNeeded n'est d'aucune utilité!!!!

    // du coup, obligation de faire le SetChildForm AVANT de recréer les critères de recherche

    // conclusion:
    // virer le TTreeView!!!!!!!

    // 16/05/2009: Etait vrai avec D7, semble plus le cas avec D2009: on verra à le changer pour homogénéiser

    frmFond.SetChildForm(FDest);

    if Assigned(Stream) and (Stream.Size > 0) then
    begin
      LoadRechFromStream(Stream);
      btnRecherche.Click;
    end
    else if LightComboCheck1.ValidValue(TypeSimple) then
    begin
      PageControl1.ActivePageIndex := 0;
      LightComboCheck1.Value := TypeSimple;
      VTPersonnes.CurrentValue := Reference;
      SpeedButton1Click(nil);
    end;
  end;
  if Historique.CurrentConsultation = 0 then
    Historique.SetDescription('Accueil')
  else
    Historique.SetDescription(FDest.Caption);
end;

function ZoomCouverture(isParaBD: Boolean; const ID_Item, ID_Couverture: TGUID): Boolean;
var
  FDest: TFrmZoomCouverture;
begin
  Result := not(IsEqualGUID(ID_Item, GUID_NULL) or IsEqualGUID(ID_Couverture, GUID_NULL));
  if not Result then
    Exit;
  FDest := TFrmZoomCouverture.Create(frmFond);
  with FDest do
    try
      Result := LoadCouverture(isParaBD, ID_Item, ID_Couverture);
      Historique.SetDescription(FDest.Caption);
    finally
      frmFond.SetChildForm(FDest);
    end;
end;

function MAJGallerie(TypeGallerie: Integer; const Reference: TGUID): Boolean;
var
  FDest: TfrmGallerie;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  // if not (Mode_en_cours in [mdEdit, mdConsult]) then Exit;
  Result := not IsEqualGUID(Reference, GUID_NULL);
  if not Result then
    Exit;
  FDest := TfrmGallerie.Create(frmFond);
  try
    case TypeGallerie of
      1:
        FDest.ID_Serie := Reference;
      2:
        FDest.ID_Album := Reference;
      3:
        FDest.ID_Edition := Reference;
    else
      Exit;
    end;
    Historique.SetDescription(FDest.Caption);
    Result := True;
  finally
    frmFond.SetChildForm(FDest);
  end;
end;

function MAJRunScript(AlbumToImport: TAlbumFull): Boolean;
var
  archCompress: TJcl7zCompressArchive;
  archDecompress: TJcl7zDecompressArchive;
  archiveName, scriptName: string;
  o, album, options, params: TdwsJSONObject;
  frmChoixScript: TfrmChoixScript;
  cmdLine: RCommandLine;
  dummy, errResult: string;
  item: TJclCompressionItem;
  i: Integer;
  js: TStringStream;
  Edition: TEditionFull;
  Couverture: TCouvertureLite;
begin
  Result := False;

  frmChoixScript := TfrmChoixScript.Create(nil);
  try
    if frmFond.SetModalChildForm(frmChoixScript) = mrCancel then
      Exit(False);
    scriptName := frmChoixScript.CurrentScript.ScriptUnitName;
  finally
    frmChoixScript.Free;
  end;

  archiveName := TPath.GetTempFileName;
  try
    archCompress := TJcl7zCompressArchive.Create(archiveName, 0, False);
    o := TdwsJSONObject.Create;
    try
      album := o.AddObject('album');
      TEntitesSerializer.WriteToJSON(AlbumToImport, album, [soSkipNullValues]);
      options := o.AddObject('options');
      params := o.AddObject('params');
      params.AddValue('script', scriptName);
      params.AddValue('defaultSearch', AlbumToImport.DefaultSearch);

      archCompress.AddFile('data.json', TStringStream.Create({$IFNDEF DEBUG}o.ToString{$ELSE}o.ToBeautifiedString{$ENDIF}), True);
      archCompress.Compress;
    finally
      o.Free;
      archCompress.Free;
    end;

    cmdLine := '';
    cmdLine.Add(TPath.Combine(TPath.GetLibraryPath, 'BDScript.exe'));
    cmdLine.Add('/run');
    cmdLine.Add(archiveName);
    cmdLine.Add('/dh');
    cmdLine.Add(IntToStr(Application.MainFormHandle));

    if Execute(cmdLine, dummy, errResult) = ScriptRunOK then
    begin
      archDecompress := TJcl7zDecompressArchive.Create(archiveName);
      js := TStringStream.Create;
      try
        archDecompress.ListFiles;
        for i := 0 to Pred(archDecompress.ItemCount) do
        begin
          item := archDecompress.Items[i];
          if SameText(item.PackedName, 'data.json') then
          begin
            item.OwnsStream := False;
            item.Stream := js;
            item.Selected := True;
            archDecompress.ExtractSelected;
            o := TdwsJSONObject.ParseString(js.DataString) as TdwsJSONObject;
            try
              album := o.Items['album'] as TdwsJSONObject;
              AlbumToImport.Clear;
              TEntitesDeserializer.ReadFromJSON(AlbumToImport, album);
            finally
              o.Free;
            end;
          end;
        end;

        for i := 0 to Pred(archDecompress.ItemCount) do
        begin
          item := archDecompress.Items[i];
          item.Selected := not item.Selected;
        end;
        archDecompress.ExtractAll(TempPath);
        for Edition in AlbumToImport.Editions do
          for Couverture in Edition.Couvertures do
          begin
            Couverture.NewNom := TPath.Combine(TempPath, Couverture.NewNom);
            Couverture.OldNom := Couverture.NewNom;
          end;
      finally
        js.Free;
        archDecompress.Free;
      end;
      Import(AlbumToImport);
      Result := True;
    end;
  finally
{$IFNDEF DEBUG}
    if TFile.Exists(archiveName) then
      TFile.Delete(archiveName);
{$ENDIF}
  end;
end;

end.
