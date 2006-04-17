unit Form_EditSerie;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Db, StdCtrls, ExtCtrls, DBCtrls, Mask,
  Buttons, VDTButton, ComCtrls, DBEditLabeled, VirtualTrees, VirtualTree,
  Menus, ExtDlgs, Frame_RechercheRapide;

type
  TFrmEditSerie = class(TForm)
    Bevel1: TBevel;
    Panel1: TPanel;
    btnOK: TBitBtn;
    btnAnnuler: TBitBtn;
    ScrollBox2: TScrollBox;
    Label5: TLabel;
    Label8: TLabel;
    vtEditeurs: TVirtualStringTree;
    vtCollections: TVirtualStringTree;
    Label2: TLabel;
    edTitre: TEditLabeled;
    Label17: TLabel;
    vtGenres: TVirtualStringTree;
    Label15: TLabel;
    Bevel3: TBevel;
    Bevel2: TBevel;
    Label6: TLabel;
    histoire: TMemoLabeled;
    Label7: TLabel;
    remarques: TMemoLabeled;
    cbTerminee: TCheckBoxLabeled;
    cbComplete: TCheckBoxLabeled;
    vtAlbums: TVirtualStringTree;
    VDTButton13: TVDTButton;
    edSite: TEditLabeled;
    Label1: TLabel;
    btScenariste: TVDTButton;
    btDessinateur: TVDTButton;
    Label19: TLabel;
    btColoriste: TVDTButton;
    lvScenaristes: TVDTListViewLabeled;
    lvDessinateurs: TVDTListViewLabeled;
    vtPersonnes: TVirtualStringTree;
    lvColoristes: TVDTListViewLabeled;
    vtParaBD: TVirtualStringTree;
    Bevel5: TBevel;
    Label3: TLabel;
    Label4: TLabel;
    FrameRechercheRapidePersonnes: TFrameRechercheRapide;
    FrameRechercheRapideGenre: TFrameRechercheRapide;
    FrameRechercheRapideCollection: TFrameRechercheRapide;
    FrameRechercheRapideEditeur: TFrameRechercheRapide;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Frame11btnOKClick(Sender: TObject);
    procedure btnAnnulerClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OnNewCollection(Sender: TObject);
    procedure edTitreChange(Sender: TObject);
    procedure vtEditeursChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtGenresInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vtGenresChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtEditeursDblClick(Sender: TObject);
    procedure vtCollectionsDblClick(Sender: TObject);
    procedure vtGenresDblClick(Sender: TObject);
    procedure vtAlbumsDblClick(Sender: TObject);
    procedure VDTButton13Click(Sender: TObject);
    procedure edSiteChange(Sender: TObject);
    procedure vtPersonnesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtPersonnesDblClick(Sender: TObject);
    procedure btColoristeClick(Sender: TObject);
    procedure lvColoristesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ScanEditKeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
    FCreation: Boolean;
    FRefSerie: Integer;
    FLstGenre: TStringList;
    procedure SetRefSerie(Value: Integer);
  public
    { Déclarations publiques }
    property RefSerie: Integer read FRefSerie write SetRefSerie;
  end;

implementation

uses
  Commun, Proc_Gestions, TypeRec, DM_Princ, JvUIB, Procedures, Divers, Textes, StdConvs, ShellAPI, CommonConst, JPEG;

{$R *.DFM}

const
  RemplacerValeur = 'Remplacer %s par %s ?';
  PasModifier = 'Impossible de modifier le support !';
  PasAjouter = 'Impossible d''ajouter le support !';

procedure TFrmEditSerie.FormCreate(Sender: TObject);
begin
  PrepareLV(Self);
  FrameRechercheRapidePersonnes.VirtualTreeView := vtPersonnes;
  FrameRechercheRapideEditeur.VirtualTreeView := vtEditeurs;
  FrameRechercheRapideCollection.VirtualTreeView := vtCollections;
  FrameRechercheRapideCollection.OnNew := OnNewCollection;
  FrameRechercheRapideGenre.VirtualTreeView := vtGenres;
  FLstGenre := TStringList.Create;
  FLstGenre.Sorted := True;
  vtGenres.Mode := vmGenres;
  vtGenres.CheckImageKind := ckXP;
  vtGenres.TreeOptions.MiscOptions := vtGenres.TreeOptions.MiscOptions + [toCheckSupport];
  vtPersonnes.Mode := vmPersonnes;
  vtEditeurs.Mode := vmEditeurs;
  vtCollections.Mode := vmNone;
  vtCollections.UseFiltre := True;
  vtAlbums.Mode := vmNone;
  vtAlbums.UseFiltre := True;
end;

procedure TFrmEditSerie.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FLstGenre);
end;

procedure TFrmEditSerie.Frame11btnOKClick(Sender: TObject);
var
  RefEditeur, RefCollection, i: Integer;
  s: string;
begin
  if Length(Trim(edTitre.Text)) = 0 then begin
    AffMessage(rsTitreObligatoire, mtInformation, [mbOk], True);
    edTitre.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;

  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    if FCreation then begin
      SQL.Text := 'INSERT INTO SERIES (RefSerie, TitreSerie, Terminee, Complete, SITEWEB, RefEditeur, RefCollection, SUJETserie, REMARQUESserie, UPPERSUJETserie, UPPERREMARQUESserie)';
      SQL.Add('VALUES');
      SQL.Add('(:RefSerie, :TitreSerie, :Terminee, :Complete, :SITEWEB, :RefEditeur, :RefCollection, :SUJETserie, :REMARQUESserie, :UPPERSUJETserie, :UPPERREMARQUESserie)');
    end
    else begin
      SQL.Text := 'UPDATE SERIES SET TitreSerie = :TitreSerie, Terminee = :Terminee, Complete = :Complete, SITEWEB = :SITEWEB, RefEditeur = :RefEditeur, RefCollection = :RefCollection,';
      SQL.Add('SUJETserie = :SUJETserie, REMARQUESserie = :REMARQUESserie, UPPERSUJETserie = :UPPERSUJETserie,');
      SQL.Add('UPPERREMARQUESserie = :UPPERREMARQUESserie WHERE RefSerie = :RefSerie');
    end;
    Params.ByNameAsString['TitreSerie'] := Trim(edTitre.Text);
    if cbTerminee.State = cbGrayed then
      Params.ByNameIsNull['TERMINEE'] := True
    else
      Params.ByNameAsInteger['TERMINEE'] := Integer(cbTerminee.State);
    Params.ByNameAsBoolean['COMPLETE'] := cbComplete.Checked;
    Params.ByNameAsString['SITEWEB'] := Trim(edSite.Text);
    RefEditeur := vtEditeurs.CurrentValue;
    RefCollection := vtCollections.CurrentValue;
    if RefEditeur = -1 then begin
      Params.ByNameIsNull['REFEDITEUR'] := True;
      Params.ByNameIsNull['REFCOLLECTION'] := True;
    end
    else begin
      Params.ByNameAsInteger['REFEDITEUR'] := RefEditeur;
      if RefCollection = -1 then
        Params.ByNameIsNull['REFCOLLECTION'] := True
      else
        Params.ByNameAsInteger['REFCOLLECTION'] := RefCollection;
    end;
    s := histoire.Lines.Text;
    if s <> '' then begin
      ParamsSetBlob('SUJETserie', s);
      s := UpperCase(SansAccents(s));
      ParamsSetBlob('UPPERSUJETserie', s);
    end
    else begin
      Params.ByNameIsNull['SUJETserie'] := True;
      Params.ByNameIsNull['UPPERSUJETserie'] := True;
    end;
    s := remarques.Lines.Text;
    if s <> '' then begin
      ParamsSetBlob('REMARQUESserie', s);
      s := UpperCase(SansAccents(s));
      ParamsSetBlob('UPPERREMARQUESserie', s);
    end
    else begin
      Params.ByNameIsNull['REMARQUESserie'] := True;
      Params.ByNameIsNull['UPPERREMARQUESserie'] := True;
    end;

    Params.ByNameAsInteger['RefSerie'] := RefSerie;
    ExecSQL;

    SupprimerToutDans('', 'GENRESERIES', 'REFSERIE', RefSerie);
    SQL.Clear;
    SQL.Add('INSERT INTO GENRESERIES (RefSerie, RefGenre)');
    SQL.Add('SELECT ' + IntToStr(RefSerie) + ', RefGenre FROM GENRES WHERE Genre = :Genre');
    for i := 0 to Pred(FLstGenre.Count) do begin
      Params.AsString[0] := FLstGenre[i];
      ExecSQL;
    end;

    SupprimerToutDans('', 'AUTEURS_SERIES', 'REFSERIE', RefSerie);
    SQL.Clear;
    SQL.Add('INSERT INTO AUTEURS_SERIES (REFSERIE, METIER, REFPERSONNE)');
    SQL.Add('VALUES (:REFSERIE, :METIER, :REFPERSONNE)');
    for i := 0 to lvScenaristes.Items.Count - 1 do begin
      Params.AsInteger[0] := RefSerie;
      Params.AsInteger[1] := 0;
      Params.AsInteger[2] := TAuteur(lvScenaristes.Items[i].Data).Personne.Reference;
      ExecSQL;
    end;
    for i := 0 to lvDessinateurs.Items.Count - 1 do begin
      Params.AsInteger[0] := RefSerie;
      Params.AsInteger[1] := 1;
      Params.AsInteger[2] := TAuteur(lvDessinateurs.Items[i].Data).Personne.Reference;
      ExecSQL;
    end;
    for i := 0 to lvColoristes.Items.Count - 1 do begin
      Params.AsInteger[0] := RefSerie;
      Params.AsInteger[1] := 2;
      Params.AsInteger[2] := TAuteur(lvColoristes.Items[i].Data).Personne.Reference;
      ExecSQL;
    end;

    Transaction.Commit;
  finally
    Transaction.Free;
    Free;
  end;
  ModalResult := mrOk;
end;

procedure TFrmEditSerie.SetRefSerie(Value: Integer);
var
  Query: TJvUIBQuery;
  hg: IHourGlass;
  s: string;
begin
  hg := THourGlass.Create;
  FRefSerie := Value;
  lvScenaristes.Items.BeginUpdate;
  lvDessinateurs.Items.BeginUpdate;
  lvColoristes.Items.BeginUpdate;
  Query := TJvUIBQuery.Create(Self);
  with Query do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT TITRESERIE, TERMINEE, COMPLETE, SITEWEB, REFEDITEUR, REFCOLLECTION, SUJETserie, REMARQUESserie FROM SERIES WHERE REFSERIE = :REFSERIE';
    Params.AsInteger[0] := FRefSerie;
    FetchBlobs := True;
    Open;
    FCreation := Eof;
    if not FCreation then begin
      edTitre.Text := Fields.ByNameAsString['TITRESERIE'];
      if not Fields.ByNameIsNull['TERMINEE'] then
        cbTerminee.State := TCheckBoxState(Fields.ByNameAsInteger['TERMINEE']);
      if not Fields.ByNameIsNull['REFEDITEUR'] then begin
        vtEditeurs.CurrentValue := Fields.ByNameAsInteger['REFEDITEUR'];
        if not Fields.ByNameIsNull['REFCOLLECTION'] then
          vtCollections.CurrentValue := Fields.ByNameAsInteger['REFCOLLECTION'];
      end;
      cbComplete.Checked := Fields.ByNameAsBoolean['COMPLETE'];
      histoire.Lines.Text := Fields.ByNameAsString['SUJETserie'];
      remarques.Lines.Text := Fields.ByNameAsString['REMARQUESserie'];
      edSite.Text := Fields.ByNameAsString['SITEWEB'];

      SQL.Text := 'SELECT * FROM PROC_AUTEURS(NULL, ?, NULL)';
      Params.AsInteger[0] := FRefSerie;
      Open;
      while not Eof do begin
        case Fields.ByNameAsInteger['Metier'] of
          0: begin
              with LVScenaristes.Items.Add do begin
                Data := TAuteur.Make(Query);
                Caption := TAuteur(Data).ChaineAffichage;
              end;
            end;
          1: begin
              with LVDessinateurs.Items.Add do begin
                Data := TAuteur.Make(Query);
                Caption := TAuteur(Data).ChaineAffichage;
              end;
            end;
          2: begin
              with LVColoristes.Items.Add do begin
                Data := TAuteur.Make(Query);
                Caption := TAuteur(Data).ChaineAffichage;
              end;
            end;
        end;
        Next;
      end;
    end;

    SQL.Text := 'SELECT g.Genre FROM GENRESERIES s INNER JOIN GENRES g ON s.RefGenre = g.RefGenre WHERE s.RefSerie = :RefSerie';
    Params.AsInteger[0] := FRefSerie;
    FLstGenre.Clear;
    Open;
    while not Eof do begin
      FLstGenre.Add(Fields.AsString[0]);
      Next;
    end;
    if Bool(FLstGenre.Count) then begin
      s := FLstGenre.Text;
      Collapse(s, ', ');
      s := Copy(s, 1, Length(s) - 2);
    end
    else
      s := '';
    Label15.Caption := s;

    vtAlbums.Filtre := 'RefSerie = ' + IntToStr(FRefSerie);
    vtAlbums.Mode := vmAlbumsSerie;
    vtAlbums.FullExpand;

    vtParaBD.Filtre := 'RefSerie = ' + IntToStr(FRefSerie);
    vtParaBD.Mode := vmParaBDSerie;
    vtParaBD.FullExpand;
  finally
    lvScenaristes.Items.EndUpdate;
    lvDessinateurs.Items.EndUpdate;
    lvColoristes.Items.EndUpdate;
    Transaction.Free;
    Free;
  end;
end;

procedure TFrmEditSerie.btnAnnulerClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmEditSerie.FormShow(Sender: TObject);
begin
  edTitre.SetFocus;
end;

procedure TFrmEditSerie.OnNewCollection(Sender: TObject);
begin
  AjouterCollections(vtCollections, vtEditeurs.CurrentValue, FrameRechercheRapideCollection.edSearch.Text);
end;

procedure TFrmEditSerie.edTitreChange(Sender: TObject);
begin
  Caption := 'Saisie de série - ' + FormatTitre(edTitre.Text);
end;

procedure TFrmEditSerie.vtEditeursChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  RefEditeur: Integer;
begin
  RefEditeur := vtEditeurs.CurrentValue;
  if RefEditeur = -1 then begin
    vtCollections.Mode := vmNone;
  end
  else begin
    vtCollections.Filtre := 'RefEditeur = ' + IntToStr(RefEditeur);
    if vtCollections.Mode <> vmCollections then vtCollections.Mode := vmCollections;
  end;
  FrameRechercheRapideCollection.btNew.Enabled := RefEditeur <> -1;
end;

procedure TFrmEditSerie.vtGenresInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  if Sender.GetNodeLevel(Node) > 0 then begin
    Node.CheckType := ctCheckBox;
    if Assigned(FLstGenre) and (FLstGenre.IndexOf(TGenre(RNodeInfo(vtGenres.GetNodeData(Node)^).Detail).Genre) <> -1) then
      Node.CheckState := csCheckedNormal
    else
      Node.CheckState := csUncheckedNormal;
  end;
end;

procedure TFrmEditSerie.vtGenresChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  s: string;
  i: Integer;
  PG: TGenre;
  NodeInfo: PNodeInfo;
begin
  NodeInfo := vtGenres.GetNodeData(Node);
  if Assigned(NodeInfo) and Assigned(NodeInfo.Detail) then begin
    PG := NodeInfo.Detail as TGenre;
    i := FLstGenre.IndexOf(PG.Genre);
    if i = -1 then
      FLstGenre.Add(PG.Genre)
    else
      FLstGenre.Delete(i);
    if Bool(FLstGenre.Count) then begin
      s := FLstGenre.Text;
      Collapse(s, ', ');
      s := Copy(s, 1, Length(s) - 2);
    end
    else
      s := '';
    Label15.Caption := s;
  end;
end;

procedure TFrmEditSerie.vtEditeursDblClick(Sender: TObject);
begin
  ModifierEditeurs(vtEditeurs);
end;

procedure TFrmEditSerie.vtCollectionsDblClick(Sender: TObject);
begin
  ModifierCollections(vtCollections);
end;

procedure TFrmEditSerie.vtGenresDblClick(Sender: TObject);
begin
  ModifierGenres(vtGenres);
end;

procedure TFrmEditSerie.vtAlbumsDblClick(Sender: TObject);
begin
  ModifierAlbums(vtAlbums);
end;

procedure TFrmEditSerie.VDTButton13Click(Sender: TObject);
begin
  ShellExecute(Application.DialogHandle, nil, PChar(edSite.Text), nil, nil, SW_NORMAL);
end;

procedure TFrmEditSerie.edSiteChange(Sender: TObject);
begin
  VDTButton13.Enabled := Copy(LowerCase(edSite.Text), 1, 7) = 'http://';
end;

procedure TFrmEditSerie.vtPersonnesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  IdPersonne: Integer;

  function NotIn(LV: TListView): Boolean;
  var
    i: Integer;
  begin
    // PRealisateur peut être utilisé pour transtyper un PActeur
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

procedure TFrmEditSerie.vtPersonnesDblClick(Sender: TObject);
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

procedure TFrmEditSerie.btColoristeClick(Sender: TObject);
var
  PA: TAuteur;
begin
  if vtPersonnes.CurrentValue = -1 then Exit;
  case TSpeedButton(Sender).Tag of
    1: begin
        PA := TAuteur.Create;
        PA.Fill(TPersonnage(vtPersonnes.GetFocusedNodeData), -1, RefSerie, 0);
        with lvScenaristes.Items.Add do begin
          Data := PA;
          Caption := PA.ChaineAffichage;
        end;
      end;
    2: begin
        PA := TAuteur.Create;
        PA.Fill(TPersonnage(vtPersonnes.GetFocusedNodeData), -1, RefSerie, 1);
        with lvDessinateurs.Items.Add do begin
          Data := PA;
          Caption := PA.ChaineAffichage;
        end;
      end;
    3: begin
        PA := TAuteur.Create;
        PA.Fill(TPersonnage(vtPersonnes.GetFocusedNodeData), -1, RefSerie, 2);
        with lvColoristes.Items.Add do begin
          Data := PA;
          Caption := PA.ChaineAffichage;
        end;
      end;
  end;
  vtPersonnesChange(vtPersonnes, vtPersonnes.FocusedNode);
end;

procedure TFrmEditSerie.lvColoristesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TFrmEditSerie.ScanEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    Key := #0;
    if vtGenres.GetFirstSelected <> nil then
      if vtGenres.CheckState[vtGenres.GetFirstSelected] = csCheckedNormal then
        vtGenres.CheckState[vtGenres.GetFirstSelected] := csUncheckedNormal
      else
        vtGenres.CheckState[vtGenres.GetFirstSelected] := csCheckedNormal;
  end;
end;

end.

