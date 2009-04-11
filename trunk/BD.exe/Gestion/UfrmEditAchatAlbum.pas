unit UfrmEditAchatAlbum;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, EditLabeled, VirtualTrees, ComCtrls, VDTButton,
  ExtCtrls, Buttons, UframBoutons, VirtualTree, TypeRec, UframRechercheRapide, LoadComplet,
  CRFurtif, UBdtForms, Generics.Collections, PngSpeedButton, UframVTEdit;

type
  TfrmEditAchatAlbum = class(TbdtForm)
    Frame11: TframBoutons;
    rbAlbumExistant: TRadioButton;
    rbNouvelAlbum: TRadioButton;
    pnAlbumExistant: TPanel;
    pnNouvelAlbum: TPanel;
    vtEditAlbums: TframVTEdit;
    Label2: TLabel;
    edTitre: TEditLabeled;
    vtEditSeries: TframVTEdit;
    Label20: TLabel;
    Label1: TLabel;
    edTome: TEditLabeled;
    Label3: TLabel;
    edMoisParution: TEditLabeled;
    edAnneeParution: TEditLabeled;
    cbHorsSerie: TCheckBoxLabeled;
    cbIntegrale: TCheckBoxLabeled;
    Label17: TLabel;
    edTomeDebut: TEditLabeled;
    edTomeFin: TEditLabeled;
    Label6: TLabel;
    histoire: TMemoLabeled;
    Label7: TLabel;
    remarques: TMemoLabeled;
    btScenariste: TVDTButton;
    lvScenaristes: TVDTListViewLabeled;
    btDessinateur: TVDTButton;
    lvDessinateurs: TVDTListViewLabeled;
    btColoriste: TVDTButton;
    lvColoristes: TVDTListViewLabeled;
    vtEditPersonnes: TframVTEdit;
    Label19: TLabel;
    Label16: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cbIntegraleClick(Sender: TObject);
    procedure Frame11btnOKClick(Sender: TObject);
    procedure btScenaristeClick(Sender: TObject);
    procedure lvColoristesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure lvScenaristesData(Sender: TObject; Item: TListItem);
    procedure lvDessinateursData(Sender: TObject; Item: TListItem);
    procedure lvColoristesData(Sender: TObject; Item: TListItem);
    procedure rbNouvelAlbumClick(Sender: TObject);
    procedure vtEditSeriesVTEditChange(Sender: TObject);
    procedure vtEditPersonnesVTEditChange(Sender: TObject);
    procedure OnEditAuteurs(Sender: TObject);
  private
    FAlbum: TAlbumComplet;
    FScenaristesSelected, FDessinateursSelected, FColoristesSelected: Boolean;
    procedure SetID_Album(const Value: TGUID);
    procedure AjouteAuteur(List: TObjectList<TAuteur>; lvList: TVDTListViewLabeled; Auteur: TPersonnage; var FlagAuteur: Boolean); overload;
    procedure AjouteAuteur(List: TObjectList<TAuteur>; lvList: TVDTListViewLabeled; Auteur: TPersonnage); overload;
    function GetID_Album: TGUID;
    { Déclarations privées }
  public
    { Déclarations publiques }
    property ID_Album: TGUID read GetID_Album write SetID_Album;
  end;

implementation

uses
  Math, CommonConst, Proc_Gestions, Commun, Procedures, Textes, Divers,
  UHistorique, UMetadata;

{$R *.dfm}

procedure TfrmEditAchatAlbum.AjouteAuteur(List: TObjectList<TAuteur>; lvList: TVDTListViewLabeled; Auteur: TPersonnage);
var
  dummy: Boolean;
begin
  AjouteAuteur(List, lvList, Auteur, dummy);
end;

procedure TfrmEditAchatAlbum.AjouteAuteur(List: TObjectList<TAuteur>; lvList: TVDTListViewLabeled; Auteur: TPersonnage; var FlagAuteur: Boolean);
var
  PA: TAuteur;
begin
  PA := TAuteur.Create;
  PA.Fill(Auteur, ID_Album, GUID_NULL, TMetierAuteur(0));
  List.Add(PA);
  lvList.Items.Count := List.Count;
  lvList.Invalidate;

  FlagAuteur := True;
end;

procedure TfrmEditAchatAlbum.FormCreate(Sender: TObject);
begin
  PrepareLV(Self);
  FAlbum := TAlbumComplet.Create;

  vtEditPersonnes.VTEdit.LinkControls.Add(Label19);
  vtEditSeries.VTEdit.LinkControls.Add(Label20);

  vtEditPersonnes.AfterEdit := OnEditAuteurs;
  vtEditSeries.AfterEdit := vtEditSeriesVTEditChange;
  vtEditAlbums.CanCreate := False;
  vtEditAlbums.CanEdit := False;
  if TGlobalVar.Mode_en_cours = mdConsult then
  begin
    Frame11.Align := alBottom;
    Frame11.btnOK.Caption := 'Ok';
  end
  else
  begin
    Frame11.Align := alTop;
    Frame11.btnOK.Caption := 'Enregistrer';
  end;
  rbNouvelAlbum.Checked := True;
  vtEditPersonnes.Mode := vmPersonnes;
  vtEditSeries.Mode := vmSeries;
  vtEditAlbums.Mode := vmAlbumsSerie;
  FScenaristesSelected := False;
  FDessinateursSelected := False;
  FColoristesSelected := False;
end;

procedure TfrmEditAchatAlbum.SetID_Album(const Value: TGUID);
begin
  FAlbum.Fill(Value);

  rbNouvelAlbum.Enabled := FAlbum.RecInconnu;
  rbAlbumExistant.Enabled := FAlbum.RecInconnu;

  if FAlbum.Complet then
  begin
    rbAlbumExistant.Checked := True;
    vtEditAlbums.CurrentValue := FAlbum.ID_Album;
  end
  else
  begin
    rbNouvelAlbum.Checked := True;
    edTitre.Text := FAlbum.Titre;
    edMoisParution.Text := NonZero(IntToStr(FAlbum.MoisParution));
    edAnneeParution.Text := NonZero(IntToStr(FAlbum.AnneeParution));
    edTome.Text := NonZero(IntToStr(FAlbum.Tome));
    edTomeDebut.Text := NonZero(IntToStr(FAlbum.TomeDebut));
    edTomeFin.Text := NonZero(IntToStr(FAlbum.TomeFin));
    cbIntegrale.Checked := FAlbum.Integrale;
    cbHorsSerie.Checked := FAlbum.HorsSerie;
    histoire.Lines.Assign(FAlbum.Sujet);
    remarques.Lines.Assign(FAlbum.Notes);
    cbIntegraleClick(cbIntegrale);

    lvScenaristes.Items.BeginUpdate;
    lvDessinateurs.Items.BeginUpdate;
    lvColoristes.Items.BeginUpdate;

    lvScenaristes.Items.Count := FAlbum.Scenaristes.Count;
    lvDessinateurs.Items.Count := FAlbum.Dessinateurs.Count;
    lvColoristes.Items.Count := FAlbum.Coloristes.Count;

    FScenaristesSelected := lvScenaristes.Items.Count > 0;
    FDessinateursSelected := lvDessinateurs.Items.Count > 0;
    FColoristesSelected := lvColoristes.Items.Count > 0;

    lvScenaristes.Items.EndUpdate;
    lvDessinateurs.Items.EndUpdate;
    lvColoristes.Items.EndUpdate;

    vtEditSeries.VTEdit.OnChange := nil;
    vtEditSeries.CurrentValue := FAlbum.ID_Serie;
    vtEditSeries.VTEdit.OnChange := vtEditSeriesVTEditChange;
  end;
  rbNouvelAlbumClick(nil);
end;

procedure TfrmEditAchatAlbum.cbIntegraleClick(Sender: TObject);
var
  cl: TColor;
begin
  edTomeDebut.Enabled := cbIntegrale.Checked;
  edTomeFin.Enabled := cbIntegrale.Checked;
  if cbIntegrale.Checked then
    cl := clWindowText
  else
    cl := clInactiveCaptionText;
  Label16.Font.Color := cl;
  Label17.Font.Color := cl;
end;

procedure TfrmEditAchatAlbum.Frame11btnOKClick(Sender: TObject);
begin
  if rbNouvelAlbum.Checked then
  begin
    if TGlobalVar.Utilisateur.Options.SerieObligatoireAlbums and IsEqualGUID(vtEditSeries.CurrentValue, GUID_NULL) then
    begin
      AffMessage(rsSerieObligatoire, mtInformation, [mbOk], True);
      vtEditSeries.SetFocus;
      ModalResult := mrNone;
      Exit;
    end;
    if (Length(Trim(edTitre.Text)) = 0) and IsEqualGUID(vtEditSeries.CurrentValue, GUID_NULL) then
    begin
      AffMessage(rsTitreObligatoireAlbumSansSerie, mtInformation, [mbOk], True);
      edTitre.SetFocus;
      ModalResult := mrNone;
      Exit;
    end;
    if not (StrToIntDef(edMoisParution.Text, 1) in [1..12]) then
    begin
      AffMessage(rsMoisParutionIncorrect, mtInformation, [mbOk], True);
      edMoisParution.SetFocus;
      ModalResult := mrNone;
      Exit;
    end;
  end
  else if IsEqualGUID(vtEditAlbums.CurrentValue, GUID_NULL) then
  begin
    AffMessage(rsAlbumObligatoire, mtInformation, [mbOk], True);
    vtEditAlbums.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;

  if rbAlbumExistant.Checked then
  begin
    if (not IsEqualGUID(vtEditAlbums.CurrentValue, ID_Album)) and (not IsEqualGUID(ID_Album, GUID_NULL)) then
    begin
      FAlbum.Acheter(False);
      FAlbum.Fill(vtEditAlbums.CurrentValue);
    end;
    FAlbum.Acheter(True);
  end
  else
  begin
    FAlbum.Titre := Trim(edTitre.Text);
    if edAnneeParution.Text = '' then
    begin
      FAlbum.AnneeParution := 0;
      FAlbum.MoisParution := 0;
    end
    else
    begin
      FAlbum.AnneeParution := StrToInt(edAnneeParution.Text);
      if edMoisParution.Text = '' then
        FAlbum.MoisParution := 0
      else
        FAlbum.MoisParution := StrToInt(edMoisParution.Text);
    end;
    FAlbum.Tome := StrToIntDef(edTome.Text, 0);
    if (not cbIntegrale.Checked) or (edTomeDebut.Text = '') then
      FAlbum.TomeDebut := 0
    else
      FAlbum.TomeDebut := StrToInt(edTomeDebut.Text);
    if (not cbIntegrale.Checked) or (edTomeFin.Text = '') then
      FAlbum.TomeFin := 0
    else
      FAlbum.TomeFin := StrToInt(edTomeFin.Text);
    FAlbum.Integrale := cbIntegrale.Checked;
    FAlbum.HorsSerie := cbHorsSerie.Checked;
    FAlbum.Sujet.Assign(histoire.Lines);
    FAlbum.Notes.Assign(remarques.Lines);

    FAlbum.SaveToDatabase;
    FAlbum.Acheter(True);
  end;
  ModalResult := mrOk;
end;

procedure TfrmEditAchatAlbum.vtEditPersonnesVTEditChange(Sender: TObject);
var
  IdPersonne: TGUID;

  function NotIn(LV: TListView): Boolean;
  var
    i: Integer;
  begin
    // PRealisateur peut être utilisé pour transtyper un PActeur
    i := 0;
    Result := True;
    while Result and (i <= Pred(LV.Items.Count)) do
    begin
      Result := not IsEqualGUID(TAuteur(LV.Items[i].Data).Personne.ID, IdPersonne);
      Inc(i);
    end;
  end;

begin
  IdPersonne := vtEditPersonnes.CurrentValue;
  btScenariste.Enabled := (not IsEqualGUID(IdPersonne, GUID_NULL)) and NotIn(LVScenaristes);
  btDessinateur.Enabled := (not IsEqualGUID(IdPersonne, GUID_NULL)) and NotIn(LVDessinateurs);
  btColoriste.Enabled := (not IsEqualGUID(IdPersonne, GUID_NULL)) and NotIn(LVColoristes);
end;

procedure TfrmEditAchatAlbum.vtEditSeriesVTEditChange(Sender: TObject);
var
  i: Integer;
begin
  FAlbum.ID_Serie := vtEditSeries.CurrentValue;
  if not IsEqualGUID(FAlbum.ID_Serie, GUID_NULL) then
  begin
    if not (FScenaristesSelected and FDessinateursSelected and FColoristesSelected) then
      try
        lvScenaristes.Items.BeginUpdate;
        lvDessinateurs.Items.BeginUpdate;
        lvColoristes.Items.BeginUpdate;
        if not FScenaristesSelected then
        begin
          lvScenaristes.Items.Count := 0;
          FAlbum.Scenaristes.Clear;
          for i := 0 to Pred(FAlbum.Serie.Scenaristes.Count) do
            AjouteAuteur(FAlbum.Scenaristes, lvScenaristes, TAuteur(FAlbum.Serie.Scenaristes[i]).Personne);
        end;
        if not FDessinateursSelected then
        begin
          lvDessinateurs.Items.Count := 0;
          FAlbum.Dessinateurs.Clear;
          for i := 0 to Pred(FAlbum.Serie.Dessinateurs.Count) do
            AjouteAuteur(FAlbum.Dessinateurs, lvDessinateurs, TAuteur(FAlbum.Serie.Dessinateurs[i]).Personne);
        end;
        if not FColoristesSelected then
        begin
          lvColoristes.Items.Count := 0;
          FAlbum.Coloristes.Clear;
          for i := 0 to Pred(FAlbum.Serie.Coloristes.Count) do
            AjouteAuteur(FAlbum.Coloristes, lvColoristes, TAuteur(FAlbum.Serie.Coloristes[i]).Personne);
        end;
      finally
        lvScenaristes.Items.EndUpdate;
        lvDessinateurs.Items.EndUpdate;
        lvColoristes.Items.EndUpdate;
      end;
  end;
end;

procedure TfrmEditAchatAlbum.OnEditAuteurs(Sender: TObject);
var
  i: Integer;
  Auteur: TAuteur;
  CurrentAuteur: TPersonnage;
begin
  CurrentAuteur := vtEditPersonnes.VTEdit.Data;
  for i := 0 to Pred(lvScenaristes.Items.Count) do
  begin
    Auteur := lvScenaristes.Items[i].Data;
    if IsEqualGUID(Auteur.Personne.ID, vtEditPersonnes.CurrentValue) then
    begin
      Auteur.Personne.Assign(CurrentAuteur);
      lvScenaristes.Invalidate;
    end;
  end;
  lvScenaristes.Invalidate;
  for i := 0 to Pred(lvDessinateurs.Items.Count) do
  begin
    Auteur := lvDessinateurs.Items[i].Data;
    if IsEqualGUID(Auteur.Personne.ID, vtEditPersonnes.CurrentValue) then
    begin
      Auteur.Personne.Assign(CurrentAuteur);
      lvDessinateurs.Invalidate;
    end;
  end;
  lvDessinateurs.Invalidate;
  for i := 0 to Pred(lvColoristes.Items.Count) do
  begin
    Auteur := lvColoristes.Items[i].Data;
    if IsEqualGUID(Auteur.Personne.ID, vtEditPersonnes.CurrentValue) then
    begin
      Auteur.Personne.Assign(CurrentAuteur);
      lvColoristes.Invalidate;
    end;
  end;
  lvColoristes.Invalidate;
end;

procedure TfrmEditAchatAlbum.btScenaristeClick(Sender: TObject);
begin
  if IsEqualGUID(vtEditPersonnes.CurrentValue, GUID_NULL) then
    Exit;
  case TSpeedButton(Sender).Tag of
    1: AjouteAuteur(FAlbum.Scenaristes, lvScenaristes, TPersonnage(vtEditPersonnes.VTEdit.Data), FScenaristesSelected);
    2: AjouteAuteur(FAlbum.Dessinateurs, lvDessinateurs, TPersonnage(vtEditPersonnes.VTEdit.Data), FDessinateursSelected);
    3: AjouteAuteur(FAlbum.Coloristes, lvColoristes, TPersonnage(vtEditPersonnes.VTEdit.Data), FColoristesSelected);
  end;
  vtEditPersonnesVTEditChange(vtEditPersonnes.VTEdit);
end;

procedure TfrmEditAchatAlbum.lvColoristesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  src: TListView;
  PA: TAuteur;
begin
  if Key <> VK_DELETE then
    Exit;
  src := TListView(Sender);
  PA := src.Selected.Data;
  PA.Free;
  src.Selected.Delete;
  vtEditPersonnesVTEditChange(vtEditPersonnes.VTEdit);
end;

function TfrmEditAchatAlbum.GetID_Album: TGUID;
begin
  Result := FAlbum.ID_Album;
end;

procedure TfrmEditAchatAlbum.FormDestroy(Sender: TObject);
begin
  FAlbum.Free;
end;

procedure TfrmEditAchatAlbum.lvScenaristesData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FAlbum.Scenaristes[Item.Index];
  Item.Caption := TAuteur(Item.Data).ChaineAffichage;
end;

procedure TfrmEditAchatAlbum.rbNouvelAlbumClick(Sender: TObject);
begin
  pnNouvelAlbum.Visible := rbNouvelAlbum.Checked;
  pnAlbumExistant.Visible := rbAlbumExistant.Checked;
end;

procedure TfrmEditAchatAlbum.lvDessinateursData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FAlbum.Dessinateurs[Item.Index];
  Item.Caption := TAuteur(Item.Data).ChaineAffichage;
end;

procedure TfrmEditAchatAlbum.lvColoristesData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FAlbum.Coloristes[Item.Index];
  Item.Caption := TAuteur(Item.Data).ChaineAffichage;
end;

end.

