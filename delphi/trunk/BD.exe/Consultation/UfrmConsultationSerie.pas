unit UfrmConsultationSerie;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, LoadComplet, StdCtrls, VirtualTrees, ExtCtrls,
  ComCtrls, VDTButton, Buttons, VirtualTree, Procedures, ProceduresBDtk, UBdtForms, StrUtils,
  ActnList, Menus, PngSpeedButton, LabeledCheckBox, System.Actions;

type
  TfrmConsultationSerie = class(TBdtForm, IImpressionApercu, IFicheEditable)
    ScrollBox2: TScrollBox;
    l_remarques: TLabel;
    l_sujet: TLabel;
    l_acteurs: TLabel;
    l_realisation: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    TitreSerie: TLabel;
    Bevel1: TBevel;
    edRemarques: TMemo;
    edSujet: TMemo;
    lvScenaristes: TVDTListView;
    lvDessinateurs: TVDTListView;
    lvColoristes: TVDTListView;
    vtAlbums: TVirtualStringTree;
    vtParaBD: TVirtualStringTree;
    Label4: TLabel;
    Label3: TLabel;
    Lbl_type: TLabel;
    Editeur: TLabel;
    Label9: TLabel;
    Collection: TLabel;
    MainMenu1: TMainMenu;
    Fiche1: TMenuItem;
    Modifier1: TMenuItem;
    N1: TMenuItem;
    Aperuavantimpression1: TMenuItem;
    Imprimer1: TMenuItem;
    ActionList1: TActionList;
    FicheApercu: TAction;
    FicheImprime: TAction;
    FicheModifier: TAction;
    VDTButton1: TVDTButton;
    PopupMenu1: TPopupMenu;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    Image1: TImage;
    cbTerminee: TLabeledCheckBox;
    Label2: TLabel;
    lvUnivers: TVDTListView;
    Label1: TLabel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TitreSerieClick(Sender: TObject);
    procedure EditeurClick(Sender: TObject);
    procedure vtAlbumsDblClick(Sender: TObject);
    procedure vtParaBDDblClick(Sender: TObject);
    procedure lvScenaristesDblClick(Sender: TObject);
    procedure FicheApercuExecute(Sender: TObject);
    procedure FicheModifierExecute(Sender: TObject);
    procedure VDTButton1Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure vtAlbumsAfterItemPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
    procedure lvUniversDblClick(Sender: TObject);
    procedure lvScenaristesData(Sender: TObject; Item: TListItem);
    procedure lvDessinateursData(Sender: TObject; Item: TListItem);
    procedure lvColoristesData(Sender: TObject; Item: TListItem);
    procedure lvUniversData(Sender: TObject; Item: TListItem);
  private
    FSerie: TSerieComplete;
    function GetID_Serie: TGUID;
    procedure SetID_Serie(const Value: TGUID);
    procedure ClearForm;

    procedure ImpressionExecute(Sender: TObject);
    procedure ApercuExecute(Sender: TObject);
    function ImpressionUpdate: Boolean;
    function ApercuUpdate: Boolean;
    procedure ImpRep(Sender: TObject);
    procedure ModificationExecute(Sender: TObject);
    function ModificationUpdate: Boolean;
  public
    property Serie: TSerieComplete read FSerie;
    property ID_Serie: TGUID read GetID_Serie write SetID_Serie;
  end;

implementation

uses Commun, Divers, TypeRec, ShellAPI, UHistorique, Impression, Proc_Gestions,
  UfrmFond;

{$R *.dfm}
{ TFrmConsultationSerie }

function TfrmConsultationSerie.GetID_Serie: TGUID;
begin
  Result := FSerie.ID_Serie;
end;

procedure TfrmConsultationSerie.SetID_Serie(const Value: TGUID);
var
  s: string;
  i: Integer;
begin
  ClearForm;
  FSerie.Fill(Value);

  Caption := 'Fiche de série - ' + FSerie.ChaineAffichage;
  TitreSerie.Caption := FormatTitre(FSerie.TitreSerie);
  if FSerie.SiteWeb <> '' then
  begin
    TitreSerie.Font.Color := clBlue;
    TitreSerie.Font.Style := TitreSerie.Font.Style + [fsUnderline];
    TitreSerie.Cursor := crHandPoint;
  end
  else
  begin
    TitreSerie.Font.Color := clWindowText;
    TitreSerie.Font.Style := TitreSerie.Font.Style - [fsUnderline];
    TitreSerie.Cursor := crDefault;
  end;
  Image1.Picture.Assign(frmFond.imlNotation_32x32.PngImages[FSerie.Notation - 900].PngImage);

  Editeur.Caption := FormatTitre(FSerie.Editeur.NomEditeur);
  if FSerie.Editeur.SiteWeb <> '' then
  begin
    Editeur.Font.Color := clBlue;
    Editeur.Font.Style := [fsUnderline];
    Editeur.Cursor := crHandPoint;
  end
  else
  begin
    Editeur.Font.Color := clWindowText;
    Editeur.Font.Style := [];
    Editeur.Cursor := crDefault;
  end;
  Collection.Caption := FSerie.Collection.ChaineAffichage;
  cbTerminee.State := TCheckBoxState(FSerie.Terminee);

  edSujet.Text := FSerie.Sujet;
  edRemarques.Text := FSerie.Notes;

  s := '';
  for i := 0 to Pred(FSerie.Genres.Count) do
    AjoutString(s, FSerie.Genres.ValueFromIndex[i], ', ');
  Memo1.Text := s;

  lvUnivers.Items.BeginUpdate;
  lvScenaristes.Items.BeginUpdate;
  lvDessinateurs.Items.BeginUpdate;
  lvColoristes.Items.BeginUpdate;

  lvUnivers.Items.Count := FSerie.Univers.Count;
  lvScenaristes.Items.Count := FSerie.Scenaristes.Count;
  lvDessinateurs.Items.Count := FSerie.Dessinateurs.Count;
  lvColoristes.Items.Count := FSerie.Coloristes.Count;

  lvUnivers.Items.EndUpdate;
  lvScenaristes.Items.EndUpdate;
  lvDessinateurs.Items.EndUpdate;
  lvColoristes.Items.EndUpdate;

  vtAlbums.Filtre := 'ID_Serie = ' + QuotedStr(GUIDToString(ID_Serie));
  vtAlbums.Mode := vmAlbumsSerie;
  vtAlbums.FullExpand;

  vtParaBD.Filtre := 'ID_Serie = ' + QuotedStr(GUIDToString(ID_Serie));
  vtParaBD.Mode := vmParaBDSerie;
  vtParaBD.FullExpand;
end;

procedure TfrmConsultationSerie.ClearForm;
begin
  lvUnivers.Items.Count := 0;
  lvScenaristes.Items.Count := 0;
  lvDessinateurs.Items.Count := 0;
  lvColoristes.Items.Count := 0;

  vtAlbums.Mode := vmNone;
  vtAlbums.UseFiltre := True;
  vtParaBD.Mode := vmNone;
  vtParaBD.UseFiltre := True;
end;

procedure TfrmConsultationSerie.FicheApercuExecute(Sender: TObject);
begin
  ImpRep(Sender);
end;

procedure TfrmConsultationSerie.FicheModifierExecute(Sender: TObject);
begin
  Historique.AddWaiting(fcGestionModif, @RefreshCallBack, nil, @ModifierSeries2, nil, FSerie.ID);
end;

procedure TfrmConsultationSerie.FormCreate(Sender: TObject);
begin
  PrepareLV(Self);
  FSerie := TSerieComplete.Create;
end;

procedure TfrmConsultationSerie.FormDestroy(Sender: TObject);
begin
  ClearForm;
  FSerie.Free;
end;

procedure TfrmConsultationSerie.TitreSerieClick(Sender: TObject);
var
  s: string;
begin
  s := FSerie.SiteWeb;
  if s <> '' then
    ShellExecute(Application.DialogHandle, nil, PChar(s), nil, nil, SW_NORMAL);
end;

procedure TfrmConsultationSerie.VDTButton1Click(Sender: TObject);
begin
  Historique.AddWaiting(fcGallerie, Serie.ID_Serie, 1);
end;

procedure TfrmConsultationSerie.EditeurClick(Sender: TObject);
var
  s: string;
begin
  s := FSerie.Editeur.SiteWeb;
  if s <> '' then
    ShellExecute(Application.DialogHandle, nil, PChar(s), nil, nil, SW_NORMAL);
end;

procedure TfrmConsultationSerie.vtAlbumsAfterItemPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
begin
  if vtAlbums.GetNodeLevel(Node) > 0 then
    frmFond.DessineNote(TargetCanvas, ItemRect, TAlbum(vtAlbums.GetNodeBasePointer(Node)).Notation);
end;

procedure TfrmConsultationSerie.vtAlbumsDblClick(Sender: TObject);
begin
  Historique.AddWaiting(fcAlbum, vtAlbums.CurrentValue);
end;

procedure TfrmConsultationSerie.vtParaBDDblClick(Sender: TObject);
begin
  Historique.AddWaiting(fcParaBD, vtParaBD.CurrentValue);
end;

procedure TfrmConsultationSerie.ApercuExecute(Sender: TObject);
begin
  FicheApercuExecute(Sender);
end;

function TfrmConsultationSerie.ApercuUpdate: Boolean;
begin
  Result := True;
end;

procedure TfrmConsultationSerie.ImpRep(Sender: TObject);
begin
  ImpressionFicheSerie(ID_Serie, TComponent(Sender).Tag = 1);
end;

procedure TfrmConsultationSerie.ImpressionExecute(Sender: TObject);
begin
  FicheApercuExecute(Sender);
end;

function TfrmConsultationSerie.ImpressionUpdate: Boolean;
begin
  Result := True;
end;

procedure TfrmConsultationSerie.lvColoristesData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FSerie.Coloristes[Item.Index];
  Item.Caption := TAuteur(Item.Data).ChaineAffichage;
end;

procedure TfrmConsultationSerie.lvDessinateursData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FSerie.Dessinateurs[Item.Index];
  Item.Caption := TAuteur(Item.Data).ChaineAffichage;
end;

procedure TfrmConsultationSerie.lvScenaristesData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FSerie.Scenaristes[Item.Index];
  Item.Caption := TAuteur(Item.Data).ChaineAffichage;
end;

procedure TfrmConsultationSerie.lvScenaristesDblClick(Sender: TObject);
begin
  if Assigned(TListView(Sender).Selected) then
    Historique.AddWaiting(fcAuteur, TAuteur(TListView(Sender).Selected.Data).Personne.ID, 0);
end;

procedure TfrmConsultationSerie.lvUniversData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FSerie.Univers[Item.Index];
  Item.Caption := TUnivers(Item.Data).ChaineAffichage;
end;

procedure TfrmConsultationSerie.lvUniversDblClick(Sender: TObject);
begin
  if Assigned(TListView(Sender).Selected) then
    Historique.AddWaiting(fcUnivers, TUnivers(TListView(Sender).Selected.Data).ID, 0);
end;

procedure TfrmConsultationSerie.ModificationExecute(Sender: TObject);
begin
  FicheModifierExecute(Sender);
end;

function TfrmConsultationSerie.ModificationUpdate: Boolean;
begin
  Result := True;
end;

procedure TfrmConsultationSerie.N7Click(Sender: TObject);
begin
  FSerie.ChangeNotation(TMenuItem(Sender).Tag);
  Image1.Picture.Assign(frmFond.imlNotation_32x32.PngImages[FSerie.Notation - 900].PngImage);
end;

end.
