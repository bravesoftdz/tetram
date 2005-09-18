unit MAJ;

interface

uses
  Windows, SysUtils, Forms, Controls, ComCtrls, TypeRec, LoadComplet, Textes, Form_Consultation, Form_ConsultationE,
  Form_SaisieEmpruntAlbum, Form_SaisieEmpruntEmprunteur, Form_Recherche, Form_ZoomCouverture, Classes;

function MAJConsultation(Reference: Integer): Boolean;
function MAJConsultationE(Reference: Integer): Boolean;
function MAJConsultationAuteur(Reference: Integer): Boolean;
procedure MAJStock;
procedure MAJSeriesIncompletes;
procedure MAJPrevisionsSorties;
procedure MAJPrevisionsAchats;
procedure MAJRecherche(Reference: Integer; TypeSimple: Integer = -1);
function ZoomCouverture(RefAlbum, RefCouverture: Integer): Boolean;

function SaisieMouvementAlbum(MvtRefAlbum, MvtRefEdition: Integer; MvtPret: Boolean; MvtRefEmprunteur: Integer = -1): Boolean;
function SaisieMouvementEmprunteur(MvtRefEmprunteur: Integer; MvtRefAlbum: TEditionsEmpruntees): Boolean;

implementation

uses
  Commun, CommonConst, DM_Princ, Form_Stock, Main, DM_Commun, DB, StdCtrls, JvUIB, JvUIBLib, Divers,
  Procedures, Form_SeriesIncompletes, Form_PrevisionsSorties, Graphics,
  Form_ConsultationAuteur, Form_PrevisionAchats, UHistorique;

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

function MAJConsultation(Reference: Integer): Boolean;
var
  FDest: TFrmConsultation;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  //  if not (Mode_en_cours in [mdEdit, mdConsult]) then Exit;
  FDest := TFrmConsultation.Create(Fond);
  try
    FDest.RefAlbum := Reference;
    Historique.SetDescription(FDest.Caption);
    Result := not FDest.Album.RecInconnu;
  finally
    Fond.SetChildForm(FDest);
  end;
end;

function MAJConsultationE(Reference: Integer): Boolean;
var
  R: TEmprunteurComplet;
  i: Integer;
  FDest: TFrmConsultationE;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  //  if not (Mode_en_cours in [mdEdit, mdConsult]) then Exit;
  R := TEmprunteurComplet.Create(Reference);
  FDest := TFrmConsultationE.Create(Fond);
  try
    with FDest do begin
      RefEmprunteur := R.RefEmprunteur;
      Caption := 'Fiche d''emprunteur - "' + R.Nom + '"';
      nom.Caption := R.Nom;
      Adresse.Text := R.Adresse.Text;

      for i := 0 to R.Emprunts.Emprunts.Count - 1 do
        FListEmprunts.Add(TEmprunt.Duplicate(R.Emprunts.Emprunts[i]));
      ListeEmprunts.RootNodeCount := FListEmprunts.Count;
      Emprunts.Caption := IntToStr(R.Emprunts.NBEmprunts);
    end;

    Historique.SetDescription(FDest.Caption);
    Result := not R.RecInconnu;
  finally
    R.Free;
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

function ZoomCouverture(RefAlbum, RefCouverture: Integer): Boolean;
var
  FDest: TFrmZoomCouverture;
begin
  FDest := TFrmZoomCouverture.Create(Fond);
  with FDest do try
    Result := LoadCouverture(RefAlbum, RefCouverture);
    Historique.SetDescription(FDest.Caption);
  finally
    Fond.SetChildForm(FDest);
  end;
end;

end.

