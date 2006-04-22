unit Form_EditSerie;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Db, StdCtrls, ExtCtrls, DBCtrls, Mask,
  Buttons, VDTButton, ComCtrls, DBEditLabeled, VirtualTrees, VirtualTree,
  Menus, ExtDlgs, Frame_RechercheRapide, CRFurtif, Fram_Boutons;

type
  TFrmEditSerie = class(TForm)
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
    btScenariste: TCRFurtifLight;
    btDessinateur: TCRFurtifLight;
    Label19: TLabel;
    btColoriste: TCRFurtifLight;
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
    Bevel1: TBevel;
    Frame11: TFrame1;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Frame11btnOKClick(Sender: TObject);
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
    FID_Serie: TGUID;
    FLstGenre: TStringList;
    procedure SetID_Serie(Value: TGUID);
  public
    { Déclarations publiques }
    property ID_Serie: TGUID read FID_Serie write SetID_Serie;
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
  ID_Editeur, ID_Collection: TGUID;
  i: Integer;
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
      SQL.Text := 'INSERT INTO SERIES (ID_Serie, TitreSerie, Terminee, Complete, SITEWEB, ID_Editeur, ID_Collection, SUJETserie, REMARQUESserie, UPPERSUJETserie, UPPERREMARQUESserie)';
      SQL.Add('VALUES');
      SQL.Add('(:ID_Serie, :TitreSerie, :Terminee, :Complete, :SITEWEB, :ID_Editeur, :ID_Collection, :SUJETserie, :REMARQUESserie, :UPPERSUJETserie, :UPPERREMARQUESserie)');
    end
    else begin
      SQL.Text := 'UPDATE SERIES SET TitreSerie = :TitreSerie, Terminee = :Terminee, Complete = :Complete, SITEWEB = :SITEWEB, ID_Editeur = :ID_Editeur, ID_Collection = :ID_Collection,';
      SQL.Add('SUJETserie = :SUJETserie, REMARQUESserie = :REMARQUESserie, UPPERSUJETserie = :UPPERSUJETserie,');
      SQL.Add('UPPERREMARQUESserie = :UPPERREMARQUESserie WHERE ID_Serie = :ID_Serie');
    end;
    Params.ByNameAsString['TitreSerie'] := Trim(edTitre.Text);
    if cbTerminee.State = cbGrayed then
      Params.ByNameIsNull['TERMINEE'] := True
    else
      Params.ByNameAsInteger['TERMINEE'] := Integer(cbTerminee.State);
    Params.ByNameAsBoolean['COMPLETE'] := cbComplete.Checked;
    Params.ByNameAsString['SITEWEB'] := Trim(edSite.Text);
    ID_Editeur := vtEditeurs.CurrentValue;
    ID_Collection := vtCollections.CurrentValue;
    if IsEqualGUID(ID_Editeur, GUID_NULL) then begin
      Params.ByNameIsNull['ID_Editeur'] := True;
      Params.ByNameIsNull['ID_Collection'] := True;
    end
    else begin
      Params.ByNameAsString['ID_Editeur'] := GUIDToString(ID_Editeur);
      if IsEqualGUID(ID_Collection, GUID_NULL) then
        Params.ByNameIsNull['ID_Collection'] := True
      else
        Params.ByNameAsString['ID_Collection'] := GUIDToString(ID_Collection);
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

    Params.ByNameAsString['ID_Serie'] := GUIDToString(ID_Serie);
    ExecSQL;

    SupprimerToutDans('', 'GENRESERIES', 'ID_Serie', ID_Serie);
    SQL.Clear;
    SQL.Add('INSERT INTO GENRESERIES (ID_Serie, ID_Genre)');
    SQL.Add('SELECT ' + QuotedStr(GUIDToString(ID_Serie)) + ', ID_Genre FROM GENRES WHERE Genre = :Genre');
    for i := 0 to Pred(FLstGenre.Count) do begin
      Params.AsString[0] := FLstGenre[i];
      ExecSQL;
    end;

    SupprimerToutDans('', 'AUTEURS_SERIES', 'ID_Serie', ID_Serie);
    SQL.Clear;
    SQL.Add('INSERT INTO AUTEURS_SERIES (ID_Serie, METIER, ID_Personne)');
    SQL.Add('VALUES (:ID_Serie, :METIER, :ID_Personne)');
    for i := 0 to lvScenaristes.Items.Count - 1 do begin
      Params.AsString[0] := GUIDToString(ID_Serie);
      Params.AsInteger[1] := 0;
      Params.AsString[2] := GUIDToString(TAuteur(lvScenaristes.Items[i].Data).Personne.ID);
      ExecSQL;
    end;
    for i := 0 to lvDessinateurs.Items.Count - 1 do begin
      Params.AsString[0] := GUIDToString(ID_Serie);
      Params.AsInteger[1] := 1;
      Params.AsString[2] := GUIDToString(TAuteur(lvDessinateurs.Items[i].Data).Personne.ID);
      ExecSQL;
    end;
    for i := 0 to lvColoristes.Items.Count - 1 do begin
      Params.AsString[0] := GUIDToString(ID_Serie);
      Params.AsInteger[1] := 2;
      Params.AsString[2] := GUIDToString(TAuteur(lvColoristes.Items[i].Data).Personne.ID);
      ExecSQL;
    end;

    Transaction.Commit;
  finally
    Transaction.Free;
    Free;
  end;
  ModalResult := mrOk;
end;

procedure TFrmEditSerie.SetID_Serie(Value: TGUID);
var
  Query: TJvUIBQuery;
  hg: IHourGlass;
  s: string;
begin
  hg := THourGlass.Create;
  FID_Serie := Value;
  lvScenaristes.Items.BeginUpdate;
  lvDessinateurs.Items.BeginUpdate;
  lvColoristes.Items.BeginUpdate;
  Query := TJvUIBQuery.Create(Self);
  with Query do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT TITRESERIE, TERMINEE, COMPLETE, SITEWEB, ID_Editeur, ID_Collection, SUJETserie, REMARQUESserie FROM SERIES WHERE ID_Serie = :ID_Serie';
    Params.AsString[0] := GUIDToString(FID_Serie);
    FetchBlobs := True;
    Open;
    FCreation := Eof;
    if not FCreation then begin
      edTitre.Text := Fields.ByNameAsString['TITRESERIE'];
      if not Fields.ByNameIsNull['TERMINEE'] then
        cbTerminee.State := TCheckBoxState(Fields.ByNameAsInteger['TERMINEE']);
      if not Fields.ByNameIsNull['ID_EDITEUR'] then begin
        vtEditeurs.CurrentValue := StringToGUID(Fields.ByNameAsString['ID_EDITEUR']);
        if not Fields.ByNameIsNull['ID_COLLECTION'] then
          vtCollections.CurrentValue := StringToGUID(Fields.ByNameAsString['ID_COLLECTION']);
      end;
      cbComplete.Checked := Fields.ByNameAsBoolean['COMPLETE'];
      histoire.Lines.Text := Fields.ByNameAsString['SUJETserie'];
      remarques.Lines.Text := Fields.ByNameAsString['REMARQUESserie'];
      edSite.Text := Fields.ByNameAsString['SITEWEB'];

      SQL.Text := 'SELECT * FROM PROC_AUTEURS(NULL, ?, NULL)';
      Params.AsString[0] := GUIDToString(FID_Serie);
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

    SQL.Text := 'SELECT g.Genre FROM GENRESERIES s INNER JOIN GENRES g ON s.ID_Genre = g.ID_Genre WHERE s.ID_Serie = :ID_Serie';
    Params.AsString[0] := GUIDToString(FID_Serie);
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

    vtAlbums.Filtre := 'ID_Serie = ' + QuotedStr(GUIDToString(FID_Serie));
    vtAlbums.Mode := vmAlbumsSerie;
    vtAlbums.FullExpand;

    vtParaBD.Filtre := 'ID_Serie = ' + QuotedStr(GUIDToString(FID_Serie));
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
  ID_Editeur: TGUID;
begin
  ID_Editeur := vtEditeurs.CurrentValue;
  if IsEqualGUID(ID_Editeur, GUID_NULL) then begin
    vtCollections.Mode := vmNone;
  end
  else begin
    vtCollections.Filtre := 'ID_Editeur = ' + QuotedStr(GUIDToString(ID_Editeur));
    if vtCollections.Mode <> vmCollections then vtCollections.Mode := vmCollections;
  end;
  FrameRechercheRapideCollection.btNew.Enabled := not IsEqualGUID(ID_Editeur, GUID_NULL);
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

procedure TFrmEditSerie.vtPersonnesDblClick(Sender: TObject);
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

procedure TFrmEditSerie.btColoristeClick(Sender: TObject);
var
  PA: TAuteur;
begin
  if IsEqualGUID(vtPersonnes.CurrentValue, GUID_NULL) then Exit;
  case TSpeedButton(Sender).Tag of
    1: begin
        PA := TAuteur.Create;
        PA.Fill(TPersonnage(vtPersonnes.GetFocusedNodeData), GUID_NULL, ID_Serie, 0);
        with lvScenaristes.Items.Add do begin
          Data := PA;
          Caption := PA.ChaineAffichage;
        end;
      end;
    2: begin
        PA := TAuteur.Create;
        PA.Fill(TPersonnage(vtPersonnes.GetFocusedNodeData), GUID_NULL, ID_Serie, 1);
        with lvDessinateurs.Items.Add do begin
          Data := PA;
          Caption := PA.ChaineAffichage;
        end;
      end;
    3: begin
        PA := TAuteur.Create;
        PA.Fill(TPersonnage(vtPersonnes.GetFocusedNodeData), GUID_NULL, ID_Serie, 2);
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

