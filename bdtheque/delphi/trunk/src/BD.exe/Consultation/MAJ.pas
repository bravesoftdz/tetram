unit MAJ;

interface

uses
  Winapi.Windows, System.SysUtils, Vcl.Forms, Vcl.Controls, Vcl.ComCtrls, BD.Entities.Lite, BD.Entities.Full, System.Classes, BD.Utils.StrUtils;

function MAJConsultationAlbum(const Reference: TGUID): Boolean;
function MAJConsultationAuteur(const Reference: TGUID): Boolean;
function MAJConsultationUnivers(const Reference: TGUID): Boolean;
function MAJConsultationParaBD(const Reference: TGUID): Boolean;
function MAJConsultationSerie(const Reference: TGUID): Boolean;
procedure MAJSeriesIncompletes;
procedure MAJPrevisionsSorties;
procedure MAJPrevisionsAchats;
procedure MAJRecherche(const Reference: TGUID; TypeSimple: Integer = -1; Stream: TMemoryStream = nil);
function MAJGallerie(TypeGallerie: Integer; const Reference: TGUID): Boolean;
function ZoomCouverture(isParaBD: Boolean; const ID_Item, ID_Couverture: TGUID): Boolean;

implementation

uses
  BD.Common, BD.Utils.GUIUtils, BDTK.GUI.Forms.Main, Data.DB, Vcl.StdCtrls, UfrmSeriesIncompletes, UfrmPrevisionsSorties, Vcl.Graphics, UfrmConsultationAlbum, UfrmRecherche, UfrmZoomCouverture,
  UfrmConsultationAuteur, UfrmPrevisionAchats, UHistorique, UfrmConsultationParaBD, UfrmConsultationSerie, UfrmGallerie, UfrmConsultationUnivers,
  JclCompression, System.IOUtils, BDTK.GUI.Utils, BD.Entities.Dao.Lambda, JclSysUtils, Divers;

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
    FDest.LoadRechFromStream(Stream);
    FDest.btnRecherche.Click;
  end
  else if FDest.LightComboCheck1.ValidValue(TypeSimple) then
  begin
    FDest.PageControl1.ActivePageIndex := 0;
    FDest.LightComboCheck1.Value := TypeSimple;
    FDest.VTPersonnes.CurrentValue := Reference;
    FDest.VTResultDblClick(nil);
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
  try
    Result := FDest.LoadCouverture(isParaBD, ID_Item, ID_Couverture);
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

end.
