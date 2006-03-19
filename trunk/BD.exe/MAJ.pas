unit MAJ;

interface

uses
  Windows, SysUtils, Forms, Controls, ComCtrls, TypeRec, LoadComplet, Textes, Classes;

function MAJConsultationAlbum(Reference: Integer): Boolean;
function MAJConsultationEmprunteur(Reference: Integer): Boolean;
function MAJConsultationAuteur(Reference: Integer): Boolean;
function MAJConsultationParaBD(Reference: Integer): Boolean;
function MAJConsultationSerie(Reference: Integer): Boolean;
procedure MAJStock;
procedure MAJSeriesIncompletes;
procedure MAJPrevisionsSorties;
procedure MAJPrevisionsAchats;
procedure MAJRecherche(Reference: Integer; TypeSimple: Integer = -1);
function ZoomCouverture(isParaBD: Boolean; RefItem, RefCouverture: Integer): Boolean;

function SaisieMouvementAlbum(MvtRefAlbum, MvtRefEdition: Integer; MvtPret: Boolean; MvtRefEmprunteur: Integer = -1): Boolean;
function SaisieMouvementEmprunteur(MvtRefEmprunteur: Integer; MvtRefAlbum: TEditionsEmpruntees): Boolean;

implementation

uses
  Commun, CommonConst, DM_Princ, Form_Stock, Main, DM_Commun, DB, StdCtrls, JvUIB, JvUIBLib, Divers, Procedures, Form_SeriesIncompletes,
  Form_PrevisionsSorties, Graphics, Form_ConsultationAlbum, Form_ConsultationEmprunteur, Form_SaisieEmpruntAlbum, Form_SaisieEmpruntEmprunteur, Form_Recherche,
  Form_ZoomCouverture, Form_ConsultationAuteur, Form_PrevisionAchats, UHistorique,
  Form_ConsultationParaBD, Form_ConsultationSerie;

function MAJConsultationAuteur(Reference: Integer): Boolean;
var
  FDest: TFrmConsultationAuteur;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  //  if not (Mode_en_cours in [mdEdit, mdConsult]) then Exit;
  FDest := TFrmConsultationAuteur.Create(Fond);
  try
    FDest.RefAuteur := Reference;
    Historique.SetDescription(FDest.Caption);
    Result := not FDest.Auteur.RecInconnu;
  finally
    Fond.SetChildForm(FDest);
  end;
end;

function MAJConsultationAlbum(Reference: Integer): Boolean;
var
  FDest: TFrmConsultationAlbum;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  //  if not (Mode_en_cours in [mdEdit, mdConsult]) then Exit;
  FDest := TFrmConsultationAlbum.Create(Fond);
  try
    FDest.RefAlbum := Reference;
    Historique.SetDescription(FDest.Caption);
    Result := not FDest.Album.RecInconnu;
  finally
    Fond.SetChildForm(FDest);
  end;
end;

function MAJConsultationSerie(Reference: Integer): Boolean;
var
  FDest: TFrmConsultationSerie;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  //  if not (Mode_en_cours in [mdEdit, mdConsult]) then Exit;
  FDest := TFrmConsultationSerie.Create(Fond);
  try
    FDest.RefSerie := Reference;
    Historique.SetDescription(FDest.Caption);
    Result := not FDest.Serie.RecInconnu;
  finally
    Fond.SetChildForm(FDest);
  end;
end;

function MAJConsultationParaBD(Reference: Integer): Boolean;
var
  FDest: TFrmConsultationParaBD;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  //  if not (Mode_en_cours in [mdEdit, mdConsult]) then Exit;
  FDest := TFrmConsultationParaBD.Create(Fond);
  try
    FDest.RefParaBD := Reference;
    Historique.SetDescription(FDest.Caption);
    Result := not FDest.ParaBD.RecInconnu;
  finally
    Fond.SetChildForm(FDest);
  end;
end;

function MAJConsultationEmprunteur(Reference: Integer): Boolean;
var
  FDest: TFrmConsultationEmprunteur;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  //  if not (Mode_en_cours in [mdEdit, mdConsult]) then Exit;
  FDest := TFrmConsultationEmprunteur.Create(Fond);
  try
    FDest.RefEmprunteur := Reference;
    Historique.SetDescription(FDest.Caption);
    Result := not FDest.Emprunteur.RecInconnu;
  finally
    Fond.SetChildForm(FDest);
  end;
end;

function SaisieMouvementAlbum(MvtRefAlbum, MvtRefEdition: Integer; MvtPret: Boolean; MvtRefEmprunteur: Integer = -1): Boolean;
begin
  Result := False;
  if Mode_en_cours <> mdConsult then Exit;

  with TFrmSaisie_EmpruntAlbum.Create(Fond) do try
    pret.Checked := MvtPret;
    RefAlbum := MvtRefAlbum;
    RefEdition := MvtRefEdition;
    RefEmprunteur := MvtRefEmprunteur;
    Result := ShowModal = mrOk;
  finally
    Free;
  end;
end;

function SaisieMouvementEmprunteur(MvtRefEmprunteur: Integer; MvtRefAlbum: TEditionsEmpruntees): Boolean;
var
  i: Integer;
begin
  Result := False;
  if Mode_en_cours <> mdConsult then Exit;
  with TFrmSaisie_EmpruntEmprunteur.Create(Fond) do try
    RefEmprunteur := MvtRefEmprunteur;
    for i := Low(MvtRefAlbum) to High(MvtRefAlbum) do
      AjouteAlbum(MvtRefAlbum[i][0], MvtRefAlbum[i][1]);
    Result := ShowModal = mrOk;
  finally
    Free;
  end;
end;

procedure _MAJFenetre(FormClass: TFormClass);
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  Fond.SetChildForm(FormClass.Create(Fond));
  Historique.SetDescription(Fond.FCurrentForm.Caption);
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

procedure MAJStock;
begin
  _MAJFenetre(TFrmStock);
end;

procedure MAJRecherche(Reference, TypeSimple: Integer); overload;
var
  FDest: TFrmRecherche;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  if not (Mode_en_cours in [mdEdit, mdConsult]) then Exit;
  FDest := TFrmRecherche.Create(Fond);
  with FDest do begin
    if LightComboCheck1.ValidValue(TypeSimple) then begin
      LightComboCheck1.Value := TypeSimple;
      VTPersonnes.CurrentValue := Reference;
      SpeedButton1Click(nil);
    end;
    Fond.SetChildForm(FDest);
  end;
  if Historique.CurrentConsultation = 0 then
    Historique.SetDescription('Accueil')
  else
    Historique.SetDescription(FDest.Caption);
end;

function ZoomCouverture(isParaBD: Boolean; RefItem, RefCouverture: Integer): Boolean;
var
  FDest: TFrmZoomCouverture;
begin
  FDest := TFrmZoomCouverture.Create(Fond);
  with FDest do try
    Result := LoadCouverture(isParaBD, RefItem, RefCouverture);
    Historique.SetDescription(FDest.Caption);
  finally
    Fond.SetChildForm(FDest);
  end;
end;

end.

