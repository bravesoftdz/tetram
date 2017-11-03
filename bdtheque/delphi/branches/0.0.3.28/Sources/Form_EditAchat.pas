unit Form_EditAchat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBEditLabeled, VirtualTrees, ComCtrls, VDTButton, JvUIB,
  ExtCtrls, Buttons, Fram_Boutons, VirtualTree, TypeRec;

type
  TFrmEditAchat = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label3: TLabel;
    VDTButton12: TVDTButton;
    VDTButton11: TVDTButton;
    Bevel3: TBevel;
    Label16: TLabel;
    Label17: TLabel;
    edAnneeParution: TEditLabeled;
    edTitre: TEditLabeled;
    Edit3: TEditLabeled;
    vtSeries: TVirtualStringTree;
    cbIntegrale: TCheckBoxLabeled;
    edTome: TEditLabeled;
    cbHorsSerie: TCheckBoxLabeled;
    edTomeDebut: TEditLabeled;
    edTomeFin: TEditLabeled;
    Label20: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    ScanEditAlbum: TEdit;
    VDTButton1: TVDTButton;
    vstAlbums: TVirtualStringTree;
    Label4: TLabel;
    Frame11: TFrame1;
    btScenariste: TVDTButton;
    btDessinateur: TVDTButton;
    VDTButton7: TVDTButton;
    VDTButton8: TVDTButton;
    Label19: TLabel;
    btColoriste: TVDTButton;
    lvScenaristes: TVDTListViewLabeled;
    lvDessinateurs: TVDTListViewLabeled;
    vtPersonnes: TVirtualStringTree;
    Edit2: TEditLabeled;
    lvColoristes: TVDTListViewLabeled;
    edMoisParution: TEditLabeled;
    procedure FormCreate(Sender: TObject);
    procedure VDTButton12Click(Sender: TObject);
    procedure VDTButton11Click(Sender: TObject);
    procedure ScanEditAlbumClick(Sender: TObject);
    procedure cbIntegraleClick(Sender: TObject);
    procedure Frame11btnOKClick(Sender: TObject);
    procedure VDTButton8Click(Sender: TObject);
    procedure VDTButton7Click(Sender: TObject);
    procedure vtPersonnesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtPersonnesDblClick(Sender: TObject);
    procedure btScenaristeClick(Sender: TObject);
    procedure lvColoristesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure vtSeriesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtSeriesDblClick(Sender: TObject);
  private
    FRefAlbum: Integer;
    FCreation: Boolean;
    FScenaristesSelected, FDessinateursSelected, FColoristesSelected: Boolean;
    procedure SetRefAlbum(const Value: Integer);
    procedure AjouteAuteur(List: TVDTListViewLabeled; Auteur: TPersonnage; var FlagAuteur: Boolean);
    procedure AjouteAuteur2(List: TVDTListViewLabeled; Auteur: TPersonnage);
    { D�clarations priv�es }
  public
    { D�clarations publiques }
    property RefAlbum: Integer read FRefAlbum write SetRefAlbum;
  end;

implementation

uses Math, CommonConst, Proc_Gestions, DM_Princ, Commun, Procedures,
  Textes, Divers, LoadComplet, jvuiblib;

{$R *.dfm}

procedure TFrmEditAchat.AjouteAuteur2(List: TVDTListViewLabeled; Auteur: TPersonnage);
var
  dummy: Boolean;
begin
  AjouteAuteur(List, Auteur, dummy);
end;

procedure TFrmEditAchat.AjouteAuteur(List: TVDTListViewLabeled; Auteur: TPersonnage; var FlagAuteur: Boolean);
var
  PA: TAuteur;
begin
  PA := TAuteur.Create;
  PA.Fill(Auteur, RefAlbum, -1, 0);
  with List.Items.Add do begin
    Data := PA;
    Caption := PA.ChaineAffichage;
  end;
  FlagAuteur := True;
end;

procedure TFrmEditAchat.FormCreate(Sender: TObject);
begin
  PrepareLV(Self);
  FRefAlbum := -1;
  FCreation := True;

  vtSeries.LinkLabel.Assign(Edit3.LinkLabel);
  vtPersonnes.LinkLabel.Assign(Edit2.LinkLabel);
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

procedure TFrmEditAchat.VDTButton12Click(Sender: TObject);
begin
  vtSeries.Find(Edit3.Text, Sender = VDTButton12);
end;

procedure TFrmEditAchat.VDTButton11Click(Sender: TObject);
begin
  AjouterSeries(vtSeries, Edit3.Text);
end;

procedure TFrmEditAchat.ScanEditAlbumClick(Sender: TObject);
begin
  vstAlbums.Find(ScanEditAlbum.Text, Sender = VDTButton1);
end;

procedure TFrmEditAchat.SetRefAlbum(const Value: Integer);
var
  q: TJvUIBQuery;
  RefSerie: Integer;
begin
  FRefAlbum := Value;

  q := TJvUIBQuery.Create(nil);
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);

    SQL.Text := 'SELECT COMPLET, TITREALBUM, MOISPARUTION, ANNEEPARUTION, REFSERIE, TOME, TOMEDEBUT, TOMEFIN, HORSSERIE, INTEGRALE FROM ALBUMS WHERE RefAlbum = ?';
    Params.AsInteger[0] := FRefAlbum;
    Open;

    FCreation := Eof;
    TabSheet1.TabVisible := FCreation;
    TabSheet2.TabVisible := FCreation;
    if not FCreation then begin
      if Fields.AsInteger[0] = 1 then begin
        PageControl1.ActivePage := TabSheet2;
        vstAlbums.CurrentValue := FRefAlbum;
      end
      else begin
        PageControl1.ActivePage := TabSheet1;
        edTitre.Text := Fields.ByNameAsString['TITREALBUM'];
        edAnneeParution.Text := Fields.ByNameAsString['ANNEEPARUTION'];
        edMoisParution.Text := Fields.ByNameAsString['MOISPARUTION'];
        edTome.Text := Fields.ByNameAsString['TOME'];
        edTomeDebut.Text := Fields.ByNameAsString['TOMEDEBUT'];
        edTomeFin.Text := Fields.ByNameAsString['TOMEFIN'];
        cbIntegrale.Checked := Fields.ByNameAsBoolean['INTEGRALE'];
        cbHorsSerie.Checked := Fields.ByNameAsBoolean['HORSSERIE'];
        cbIntegraleClick(cbIntegrale);
        RefSerie := Fields.ByNameAsInteger['REFSERIE'];

        lvScenaristes.Items.BeginUpdate;
        lvDessinateurs.Items.BeginUpdate;
        lvColoristes.Items.BeginUpdate;
        SQL.Text := 'SELECT * FROM PROC_AUTEURS(?, NULL)';
        Params.AsInteger[0] := FRefAlbum;
        Open;
        while not Eof do begin
          case Fields.ByNameAsInteger['Metier'] of
            0: begin
                with LVScenaristes.Items.Add do begin
                  Data := TAuteur.Make(q);
                  Caption := TAuteur(Data).ChaineAffichage;
                end;
                FScenaristesSelected := True;
              end;
            1: begin
                with LVDessinateurs.Items.Add do begin
                  Data := TAuteur.Make(q);
                  Caption := TAuteur(Data).ChaineAffichage;
                end;
                FDessinateursSelected := True;
              end;
            2: begin
                with LVColoristes.Items.Add do begin
                  Data := TAuteur.Make(q);
                  Caption := TAuteur(Data).ChaineAffichage;
                end;
                FColoristesSelected := True;
              end;
          end;
          Next;
        end;

        vtSeries.CurrentValue := RefSerie;
      end;
    end;
  finally
    Transaction.Free;
    Free;
  end;
end;

procedure TFrmEditAchat.cbIntegraleClick(Sender: TObject);
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

procedure TFrmEditAchat.Frame11btnOKClick(Sender: TObject);
var
  s: string;
  q: TJvUIBQuery;
  hg: IHourGlass;
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
    if vtSeries.CurrentValue = -1 then begin
      AffMessage(rsSerieObligatoire, mtInformation, [mbOk], True);
      Edit3.SetFocus;
      ModalResult := mrNone;
      Exit;
    end;
  end
  else if (vstAlbums.CurrentValue = -1) then begin
    AffMessage(rsAlbumObligatoire, mtInformation, [mbOk], True);
    ScanEditAlbum.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;

  hg := THourGlass.Create;
  q := TJvUIBQuery.Create(nil);
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);

    if PageControl1.ActivePage = TabSheet2 then begin
      if (vstAlbums.CurrentValue <> FRefAlbum) and (FRefAlbum <> -1) then begin
        SQL.Text := 'UPDATE ALBUMS SET ACHAT = 0 WHERE REFALBUM = ?';
        Params.AsInteger[0] := FRefAlbum;
        Execute;
        FRefAlbum := -1;
      end;
      SQL.Text := 'UPDATE ALBUMS SET ACHAT = 1 WHERE REFALBUM = ?';
      Params.AsInteger[0] := vstAlbums.CurrentValue;
      Execute;
      FRefAlbum := vstAlbums.CurrentValue;
    end
    else begin
      if FCreation then begin
        if FRefAlbum = -1 then begin
          SQL.Text := 'SELECT GEN_ID(AI_REFALBUM, 1) FROM RDB$DATABASE';
          Open;
          FRefAlbum := Fields.AsInteger[0];
        end;

        SQL.Text := 'INSERT INTO ALBUMS (REFALBUM, TITREALBUM, MOISPARUTION, ANNEEPARUTION, REFSERIE, TOME, TOMEDEBUT, TOMEFIN, HORSSERIE, INTEGRALE, TITREINITIALESALBUM, ACHAT)';
        SQL.Add('VALUES');
        SQL.Add('(:REFALBUM, :TITREALBUM, :MOISPARUTION, :ANNEEPARUTION, :REFSERIE, :TOME, :TOMEDEBUT, :TOMEFIN, :HORSSERIE, :INTEGRALE, :TITREINITIALESALBUM, 1)');
      end
      else begin
        SQL.Text := 'UPDATE ALBUMS SET';
        SQL.Add('TITREALBUM = :TITREALBUM, MOISPARUTION = :MOISPARUTION, ANNEEPARUTION = :ANNEEPARUTION, REFSERIE = :REFSERIE, TOME = :TOME, TOMEDEBUT = :TOMEDEBUT, TOMEFIN = :TOMEFIN,');
        SQL.Add('HORSSERIE = :HORSSERIE, INTEGRALE = :INTEGRALE,');
        SQL.Add('TITREINITIALESALBUM = :TITREINITIALESALBUM');
        SQL.Add('WHERE REFALBUM = :REFALBUM');
      end;

      Params.ByNameAsInteger['REFALBUM'] := FRefAlbum;
      s := Trim(edTitre.Text);
      Params.ByNameAsString['TITREALBUM'] := s;
      Params.ByNameAsString['TITREINITIALESALBUM'] := MakeInitiales(UpperCase(SansAccents(s)));
      if edAnneeParution.Text = '' then begin
        Params.ByNameIsNull['ANNEEPARUTION'] := True;
        Params.ByNameIsNull['MOISPARUTION'] := True;
      end
      else begin
        Params.ByNameAsString['ANNEEPARUTION'] := edAnneeParution.Text;
        if edMoisParution.Text = '' then
          Params.ByNameIsNull['MOISPARUTION'] := True
        else
          Params.ByNameAsString['MOISPARUTION'] := edMoisParution.Text;
      end;
      if edTome.Text = '' then
        Params.ByNameIsNull['TOME'] := True
      else
        Params.ByNameAsString['TOME'] := edTome.Text;
      if (not cbIntegrale.Checked) or (edTomeDebut.Text = '') then
        Params.ByNameIsNull['TOMEDEBUT'] := True
      else
        Params.ByNameAsString['TOMEDEBUT'] := edTomeDebut.Text;
      if (not cbIntegrale.Checked) or (edTomeFin.Text = '') then
        Params.ByNameIsNull['TOMEFIN'] := True
      else
        Params.ByNameAsString['TOMEFIN'] := edTomeFin.Text;
      Params.ByNameAsBoolean['INTEGRALE'] := cbIntegrale.Checked;
      Params.ByNameAsBoolean['HORSSERIE'] := cbHorsSerie.Checked;
      Params.ByNameAsInteger['REFSERIE'] := vtSeries.CurrentValue;
      ExecSQL;
      Transaction.Commit;
    end;
  finally
    Transaction.Free;
    Free;
  end;
  ModalResult := mrOk;
end;

procedure TFrmEditAchat.VDTButton8Click(Sender: TObject);
begin
  AjouterAuteurs(vtPersonnes, Edit2.Text);
end;

procedure TFrmEditAchat.VDTButton7Click(Sender: TObject);
begin
  vtPersonnes.Find(Edit2.Text, Sender = VDTButton7);
end;

procedure TFrmEditAchat.vtPersonnesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  IdPersonne: Integer;

  function NotIn(LV: TListView): Boolean;
  var
    i: Integer;
  begin
    // PRealisateur peut �tre utilis� pour transtyper un PActeur
    i := 0;
    Result := True;
    while Result and (i <= Pred(LV.Items.Count)) do begin
      Result := TAuteur(LV.Items[i].Data).Personne.Reference <> IdPersonne;
      Inc(i);
    end;
  end;

begin
  IdPersonne := vtPersonnes.CurrentValue;
  btScenariste.Enabled := (IdPersonne <> -1) and NotIn(LVScenaristes);
  btDessinateur.Enabled := (IdPersonne <> -1) and NotIn(LVDessinateurs);
  btColoriste.Enabled := (IdPersonne <> -1) and NotIn(LVColoristes);
end;

procedure TFrmEditAchat.vtPersonnesDblClick(Sender: TObject);
var
  i, iCurrentAuteur: Integer;
  Auteur: TAuteur;
  CurrentAuteur: TPersonnage;
begin
  iCurrentAuteur := vtPersonnes.CurrentValue;
  if ModifierAuteurs(vtPersonnes) then begin
    CurrentAuteur := vtPersonnes.GetFocusedNodeData;
    for i := 0 to Pred(lvScenaristes.Items.Count) do begin
      Auteur := lvScenaristes.Items[i].Data;
      if Auteur.Personne.Reference = iCurrentAuteur then begin
        Auteur.Personne.Assign(CurrentAuteur);
        lvScenaristes.Items[i].Caption := Auteur.ChaineAffichage;
      end;
    end;
    lvScenaristes.Invalidate;
    for i := 0 to Pred(lvDessinateurs.Items.Count) do begin
      Auteur := lvDessinateurs.Items[i].Data;
      if Auteur.Personne.Reference = iCurrentAuteur then begin
        Auteur.Personne.Assign(CurrentAuteur);
        lvDessinateurs.Items[i].Caption := Auteur.ChaineAffichage;
      end;
    end;
    lvDessinateurs.Invalidate;
    for i := 0 to Pred(lvColoristes.Items.Count) do begin
      Auteur := lvColoristes.Items[i].Data;
      if Auteur.Personne.Reference = iCurrentAuteur then begin
        Auteur.Personne.Assign(CurrentAuteur);
        lvColoristes.Items[i].Caption := Auteur.ChaineAffichage;
      end;
    end;
    lvColoristes.Invalidate;
  end;
end;

procedure TFrmEditAchat.btScenaristeClick(Sender: TObject);
begin
  if vtPersonnes.CurrentValue = -1 then Exit;
  case TSpeedButton(Sender).Tag of
    1: AjouteAuteur(lvScenaristes, vtPersonnes.GetFocusedNodeData, FScenaristesSelected);
    2: AjouteAuteur(lvDessinateurs, vtPersonnes.GetFocusedNodeData, FDessinateursSelected);
    3: AjouteAuteur(lvColoristes, vtPersonnes.GetFocusedNodeData, FColoristesSelected);
  end;
  vtPersonnesChange(vtPersonnes, vtPersonnes.FocusedNode);
end;

procedure TFrmEditAchat.lvColoristesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TFrmEditAchat.vtSeriesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  PS: TSerie;
  SC: TSerieComplete;
  i: Integer;
begin
  PS := vtSeries.GetFocusedNodeData;
  if Assigned(PS) then begin
    if not (FScenaristesSelected and FDessinateursSelected and FColoristesSelected) then begin
      SC := TSerieComplete.Create(PS.Reference);
      try
        if not FScenaristesSelected then begin
          TAuteur.VideListe(lvScenaristes);
          for i := 0 to Pred(SC.Scenaristes.Count) do
            AjouteAuteur2(lvScenaristes, TAuteur(SC.Scenaristes[i]).Personne);
        end;
        if not FDessinateursSelected then begin
          TAuteur.VideListe(lvDessinateurs);
          for i := 0 to Pred(SC.Dessinateurs.Count) do
            AjouteAuteur2(lvDessinateurs, TAuteur(SC.Dessinateurs[i]).Personne);
        end;
        if not FColoristesSelected then begin
          TAuteur.VideListe(lvColoristes);
          for i := 0 to Pred(SC.Coloristes.Count) do
            AjouteAuteur2(lvColoristes, TAuteur(SC.Coloristes[i]).Personne);
        end;
      finally
        SC.Free;
      end;
    end;
  end;
end;

procedure TFrmEditAchat.vtSeriesDblClick(Sender: TObject);
begin
  if (vtSeries.GetFirstSelected <> nil) then begin
    ModifierSeries(vtSeries);
    vtSeriesChange(vtSeries, vtSeries.GetFirstSelected);
  end;
end;

end.

