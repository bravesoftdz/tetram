unit Form_EditAchatAlbum;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, DBEditLabeled, VirtualTrees, ComCtrls, VDTButton,
  JvUIB, ExtCtrls, Buttons, Fram_Boutons, VirtualTree, TypeRec, Frame_RechercheRapide, LoadComplet;

type
  TFrmEditAchatAlbum = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label3: TLabel;
    Bevel3: TBevel;
    Label16: TLabel;
    Label17: TLabel;
    edAnneeParution: TEditLabeled;
    edTitre: TEditLabeled;
    vtSeries: TVirtualStringTree;
    cbIntegrale: TCheckBoxLabeled;
    edTome: TEditLabeled;
    cbHorsSerie: TCheckBoxLabeled;
    edTomeDebut: TEditLabeled;
    edTomeFin: TEditLabeled;
    Label20: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    vstAlbums: TVirtualStringTree;
    Label4: TLabel;
    Frame11: TFrame1;
    btScenariste: TVDTButton;
    btDessinateur: TVDTButton;
    Label19: TLabel;
    btColoriste: TVDTButton;
    lvScenaristes: TVDTListViewLabeled;
    lvDessinateurs: TVDTListViewLabeled;
    vtPersonnes: TVirtualStringTree;
    lvColoristes: TVDTListViewLabeled;
    edMoisParution: TEditLabeled;
    remarques: TMemoLabeled;
    Label7: TLabel;
    histoire: TMemoLabeled;
    Label6: TLabel;
    FrameRechercheRapidePersonnes: TFrameRechercheRapide;
    FrameRechercheRapideSerie: TFrameRechercheRapide;
    FrameRechercheRapideAlbums: TFrameRechercheRapide;
    procedure FormCreate(Sender: TObject);
    procedure cbIntegraleClick(Sender: TObject);
    procedure Frame11btnOKClick(Sender: TObject);
    procedure vtPersonnesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtPersonnesDblClick(Sender: TObject);
    procedure btScenaristeClick(Sender: TObject);
    procedure lvColoristesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure vtSeriesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtSeriesDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvScenaristesData(Sender: TObject; Item: TListItem);
    procedure lvDessinateursData(Sender: TObject; Item: TListItem);
    procedure lvColoristesData(Sender: TObject; Item: TListItem);
  private
    FAlbum: TAlbumComplet;
    FScenaristesSelected, FDessinateursSelected, FColoristesSelected: Boolean;
    procedure SetID_Album(const Value: TGUID);
    procedure AjouteAuteur(List: TList; lvList: TVDTListViewLabeled; Auteur: TPersonnage; var FlagAuteur: Boolean); overload;
    procedure AjouteAuteur(List: TList; lvList: TVDTListViewLabeled; Auteur: TPersonnage); overload;
    function GetID_Album: TGUID;
    { Déclarations privées }
  public
    { Déclarations publiques }
    property ID_Album: TGUID read GetID_Album write SetID_Album;
  end;

implementation

uses Math, CommonConst, Proc_Gestions, DM_Princ, Commun, Procedures, Textes, Divers, jvuiblib;

{$R *.dfm}

procedure TFrmEditAchatAlbum.AjouteAuteur(List: TList; lvList: TVDTListViewLabeled; Auteur: TPersonnage);
var
  dummy: Boolean;
begin
  AjouteAuteur(List, lvList, Auteur, dummy);
end;

procedure TFrmEditAchatAlbum.AjouteAuteur(List: TList; lvList: TVDTListViewLabeled; Auteur: TPersonnage; var FlagAuteur: Boolean);
var
  PA: TAuteur;
begin
  PA := TAuteur.Create;
  PA.Fill(Auteur, ID_Album, GUID_NULL, 0);
  List.Add(PA);
  lvList.Items.Count := List.Count;
  lvList.Invalidate;

  FlagAuteur := True;
end;

procedure TFrmEditAchatAlbum.FormCreate(Sender: TObject);
begin
  PrepareLV(Self);
  FAlbum := TAlbumComplet.Create;

  FrameRechercheRapidePersonnes.VirtualTreeView := vtPersonnes;
  FrameRechercheRapideSerie.VirtualTreeView := vtSeries;
  FrameRechercheRapideAlbums.VirtualTreeView := vstAlbums;
  FrameRechercheRapideAlbums.ShowNewButton := False;
  if Mode_en_cours = mdConsult then begin
    Frame11.Align := alBottom;
    Frame11.btnOK.Caption := 'Ok';
  end
  else begin
    Frame11.Align := alTop;
    Frame11.btnOK.Caption := 'Enregistrer';
  end;
  PageControl1.ActivePageIndex := 0;
  vtPersonnes.Mode := vmPersonnes;
  vtSeries.Mode := vmSeries;
  vstAlbums.Mode := vmAlbumsSerie;
  FScenaristesSelected := False;
  FDessinateursSelected := False;
  FColoristesSelected := False;
end;

procedure TFrmEditAchatAlbum.SetID_Album(const Value: TGUID);
begin
  FAlbum.Fill(Value);

  TabSheet1.TabVisible := FAlbum.RecInconnu;
  TabSheet2.TabVisible := FAlbum.RecInconnu;

  if FAlbum.Complet then begin
    PageControl1.ActivePage := TabSheet2;
    vstAlbums.CurrentValue := FAlbum.ID_Album;
  end
  else begin
    PageControl1.ActivePage := TabSheet1;
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

    lvScenaristes.Items.EndUpdate;
    lvDessinateurs.Items.EndUpdate;
    lvColoristes.Items.EndUpdate;

    FScenaristesSelected := not FAlbum.RecInconnu;
    FDessinateursSelected := not FAlbum.RecInconnu;
    FColoristesSelected := not FAlbum.RecInconnu;

    vtSeries.OnChange := nil;
    vtSeries.CurrentValue := FAlbum.ID_Serie;
    vtSeries.OnChange := vtSeriesChange;
  end;
end;

procedure TFrmEditAchatAlbum.cbIntegraleClick(Sender: TObject);
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

procedure TFrmEditAchatAlbum.Frame11btnOKClick(Sender: TObject);
begin
  if PageControl1.ActivePage = TabSheet1 then begin
    //    if Length(Trim(edTitre.Text)) = 0 then begin
    //      AffMessage(rsTitreObligatoire, mtInformation, [mbOk], True);
    //      edTitre.SetFocus;
    //      ModalResult := mrNone;
    //      Exit;
    //    end;
    if not (StrToIntDef(edMoisParution.Text, 1) in [1..12]) then begin
      AffMessage(rsMoisParutionIncorrect, mtInformation, [mbOk], True);
      edMoisParution.SetFocus;
      ModalResult := mrNone;
      Exit;
    end;
    if IsEqualGUID(vtSeries.CurrentValue, GUID_NULL) then begin
      AffMessage(rsSerieObligatoire, mtInformation, [mbOk], True);
      FrameRechercheRapideSerie.edSearch.SetFocus;
      ModalResult := mrNone;
      Exit;
    end;
  end
  else if IsEqualGUID(vstAlbums.CurrentValue, GUID_NULL) then begin
    AffMessage(rsAlbumObligatoire, mtInformation, [mbOk], True);
    FrameRechercheRapideAlbums.edSearch.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;

  if PageControl1.ActivePage = TabSheet2 then begin
    if (not IsEqualGUID(vstAlbums.CurrentValue, ID_Album)) and (not IsEqualGUID(ID_Album, GUID_NULL)) then begin
      FAlbum.Acheter(False);
      FAlbum.Fill(vstAlbums.CurrentValue);
    end;
    FAlbum.Acheter(True);
  end
  else begin
    FAlbum.Titre := Trim(edTitre.Text);
    if edAnneeParution.Text = '' then begin
      FAlbum.AnneeParution := 0;
      FAlbum.MoisParution := 0;
    end
    else begin
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

procedure TFrmEditAchatAlbum.vtPersonnesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  IdPersonne: TGUID;

  function NotIn(LV: TListView): Boolean;
  var
    i: Integer;
  begin
    // PRealisateur peut être utilisé pour transtyper un PActeur
    i := 0;
    Result := True;
    while Result and (i <= Pred(LV.Items.Count)) do begin
      Result := not IsEqualGUID(TAuteur(LV.Items[i].Data).Personne.ID, IdPersonne);
      Inc(i);
    end;
  end;

begin
  IdPersonne := vtPersonnes.CurrentValue;
  btScenariste.Enabled := (not IsEqualGUID(IdPersonne, GUID_NULL)) and NotIn(LVScenaristes);
  btDessinateur.Enabled := (not IsEqualGUID(IdPersonne, GUID_NULL)) and NotIn(LVDessinateurs);
  btColoriste.Enabled := (not IsEqualGUID(IdPersonne, GUID_NULL)) and NotIn(LVColoristes);
end;

procedure TFrmEditAchatAlbum.vtPersonnesDblClick(Sender: TObject);
var
  i: Integer;
  iCurrentAuteur: TGUID;
  Auteur: TAuteur;
  CurrentAuteur: TPersonnage;
begin
  iCurrentAuteur := vtPersonnes.CurrentValue;
  if ModifierAuteurs(vtPersonnes) then begin
    CurrentAuteur := vtPersonnes.GetFocusedNodeData;
    for i := 0 to Pred(lvScenaristes.Items.Count) do begin
      Auteur := lvScenaristes.Items[i].Data;
      if IsEqualGUID(Auteur.Personne.ID, iCurrentAuteur) then begin
        Auteur.Personne.Assign(CurrentAuteur);
        lvScenaristes.Items[i].Caption := Auteur.ChaineAffichage;
      end;
    end;
    lvScenaristes.Invalidate;
    for i := 0 to Pred(lvDessinateurs.Items.Count) do begin
      Auteur := lvDessinateurs.Items[i].Data;
      if IsEqualGUID(Auteur.Personne.ID, iCurrentAuteur) then begin
        Auteur.Personne.Assign(CurrentAuteur);
        lvDessinateurs.Items[i].Caption := Auteur.ChaineAffichage;
      end;
    end;
    lvDessinateurs.Invalidate;
    for i := 0 to Pred(lvColoristes.Items.Count) do begin
      Auteur := lvColoristes.Items[i].Data;
      if IsEqualGUID(Auteur.Personne.ID, iCurrentAuteur) then begin
        Auteur.Personne.Assign(CurrentAuteur);
        lvColoristes.Items[i].Caption := Auteur.ChaineAffichage;
      end;
    end;
    lvColoristes.Invalidate;
  end;
end;

procedure TFrmEditAchatAlbum.btScenaristeClick(Sender: TObject);
begin
  if IsEqualGUID(vtPersonnes.CurrentValue, GUID_NULL) then Exit;
  case TSpeedButton(Sender).Tag of
    1: AjouteAuteur(FAlbum.Scenaristes, lvScenaristes, TPersonnage(vtPersonnes.GetFocusedNodeData), FScenaristesSelected);
    2: AjouteAuteur(FAlbum.Dessinateurs, lvDessinateurs, TPersonnage(vtPersonnes.GetFocusedNodeData), FDessinateursSelected);
    3: AjouteAuteur(FAlbum.Coloristes, lvColoristes, TPersonnage(vtPersonnes.GetFocusedNodeData), FColoristesSelected);
  end;
  vtPersonnesChange(vtPersonnes, vtPersonnes.FocusedNode);
end;

procedure TFrmEditAchatAlbum.lvColoristesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  src: TListView;
  PA: TAuteur;
begin
  if Key <> VK_DELETE then Exit;
  src := TListView(Sender);
  PA := src.Selected.Data;
  PA.Free;
  src.Selected.Delete;
  vtPersonnesChange(vtPersonnes, vtPersonnes.FocusedNode);
end;

procedure TFrmEditAchatAlbum.vtSeriesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  i: Integer;
begin
  FAlbum.ID_Serie := vtSeries.CurrentValue;
  if not IsEqualGUID(FAlbum.ID_Serie, GUID_NULL) then begin
    if not (FScenaristesSelected and FDessinateursSelected and FColoristesSelected) then try
      lvScenaristes.Items.BeginUpdate;
      lvDessinateurs.Items.BeginUpdate;
      lvColoristes.Items.BeginUpdate;
      if not FScenaristesSelected then begin
        lvScenaristes.Items.Count := 0;
        FAlbum.Scenaristes.Clear;
        for i := 0 to Pred(FAlbum.Serie.Scenaristes.Count) do
          AjouteAuteur(FAlbum.Scenaristes, lvScenaristes, TAuteur(FAlbum.Serie.Scenaristes[i]).Personne);
      end;
      if not FDessinateursSelected then begin
        lvDessinateurs.Items.Count := 0;
        FAlbum.Dessinateurs.Clear;
        for i := 0 to Pred(FAlbum.Serie.Dessinateurs.Count) do
          AjouteAuteur(FAlbum.Dessinateurs, lvDessinateurs, TAuteur(FAlbum.Serie.Dessinateurs[i]).Personne);
      end;
      if not FColoristesSelected then begin
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

procedure TFrmEditAchatAlbum.vtSeriesDblClick(Sender: TObject);
begin
  if (vtSeries.GetFirstSelected <> nil) then begin
    ModifierSeries(vtSeries);
    vtSeriesChange(vtSeries, vtSeries.GetFirstSelected);
  end;
end;

function TFrmEditAchatAlbum.GetID_Album: TGUID;
begin
  Result := FAlbum.ID_Album;
end;

procedure TFrmEditAchatAlbum.FormDestroy(Sender: TObject);
begin
  FAlbum.Free;
end;

procedure TFrmEditAchatAlbum.lvScenaristesData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FAlbum.Scenaristes[Item.Index];
  Item.Caption := TAuteur(Item.Data).ChaineAffichage;
end;

procedure TFrmEditAchatAlbum.lvDessinateursData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FAlbum.Dessinateurs[Item.Index];
  Item.Caption := TAuteur(Item.Data).ChaineAffichage;
end;

procedure TFrmEditAchatAlbum.lvColoristesData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FAlbum.Coloristes[Item.Index];
  Item.Caption := TAuteur(Item.Data).ChaineAffichage;
end;

end.

