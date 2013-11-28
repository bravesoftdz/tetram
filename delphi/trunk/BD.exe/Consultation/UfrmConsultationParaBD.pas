unit UfrmConsultationParaBD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, StrUtils,
  Dialogs, LoadComplet, StdCtrls, VirtualTrees, ExtCtrls, UfrmFond, Procedures,
  ComCtrls, VDTButton, Buttons, ActnList, Menus, ProceduresBDtk, UBdtForms,
  LabeledCheckBox, System.Actions;

type
  TfrmConsultationParaBD = class(TBdtForm, IImpressionApercu, IFicheEditable)
    ScrollBox2: TScrollBox;
    lbNoImage: TLabel;
    l_sujet: TLabel;
    l_annee: TLabel;
    l_realisation: TLabel;
    TitreParaBD: TLabel;
    Label6: TLabel;
    Label11: TLabel;
    AnneeEdition: TLabel;
    TitreSerie: TLabel;
    Bevel1: TBevel;
    lbInvalidImage: TLabel;
    ImageParaBD: TImage;
    Description: TMemo;
    lvAuteurs: TVDTListView;
    MainMenu1: TMainMenu;
    ActionList1: TActionList;
    ImageApercu: TAction;
    ImageImprime: TAction;
    FicheApercu: TAction;
    FicheImprime: TAction;
    Fiche1: TMenuItem;
    Aperuavantimpression1: TMenuItem;
    Imprimer1: TMenuItem;
    Image1: TMenuItem;
    Aperuavantimpression2: TMenuItem;
    Imprimer2: TMenuItem;
    Prix: TLabel;
    Label3: TLabel;
    Label12: TLabel;
    AcheteLe: TLabel;
    TypeParaBD: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    lbCote: TLabel;
    FicheModifier: TAction;
    Modifier1: TMenuItem;
    N1: TMenuItem;
    cbDedicace: TLabeledCheckBox;
    cbNumerote: TLabeledCheckBox;
    cbOffert: TLabeledCheckBox;
    cbStock: TLabeledCheckBox;
    lvUnivers: TVDTListView;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvAuteursDblClick(Sender: TObject);
    procedure TitreSerieClick(Sender: TObject);
    procedure TitreSerieDblClick(Sender: TObject);
    procedure ImageApercuExecute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure FicheApercuExecute(Sender: TObject);
    procedure FicheModifierExecute(Sender: TObject);
    procedure lvAuteursData(Sender: TObject; Item: TListItem);
    procedure lvUniversData(Sender: TObject; Item: TListItem);
    procedure lvUniversDblClick(Sender: TObject);
  private
    FParaBD: TParaBDComplet;
    function GetID_ParaBD: TGUID;
    procedure SetID_ParaBD(const Value: TGUID);
    procedure ClearForm;
    procedure CouvertureDblClick(Sender: TObject);
    procedure ImpRep(Sender: TObject);
    procedure ApercuExecute(Sender: TObject);
    function ApercuUpdate: Boolean;
    procedure ImpressionExecute(Sender: TObject);
    function ImpressionUpdate: Boolean;
    procedure ModificationExecute(Sender: TObject);
    function ModificationUpdate: Boolean;
    { Déclarations privées }
  public
    { Déclarations publiques }
    property ParaBD: TParaBDComplet read FParaBD;
    property ID_ParaBD: TGUID read GetID_ParaBD write SetID_ParaBD;
  end;

implementation

uses Commun, TypeRec, UHistorique, Divers, ShellAPI, Textes, CommonConst, jpeg, Impression,
  Proc_Gestions;

{$R *.dfm}
{ TFrmConsultationParaBD }

function TfrmConsultationParaBD.GetID_ParaBD: TGUID;
begin
  Result := FParaBD.ID_ParaBD;
end;

procedure TfrmConsultationParaBD.SetID_ParaBD(const Value: TGUID);
var
  ms: TStream;
  jpg: TJPEGImage;
begin
  ClearForm;
  FParaBD.Fill(Value);

  Caption := 'Fiche de para-BD - ' + FParaBD.ChaineAffichage;
  TitreSerie.Caption := FormatTitre(FParaBD.Serie.TitreSerie);
  if FParaBD.Serie.SiteWeb <> '' then
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
  TitreParaBD.Caption := FormatTitre(FParaBD.TitreParaBD);
  TypeParaBD.Caption := FParaBD.CategorieParaBD.Caption;
  AnneeEdition.Caption := NonZero(IntToStr(FParaBD.AnneeEdition));
  cbDedicace.Checked := FParaBD.Dedicace;
  cbNumerote.Checked := FParaBD.Numerote;

  if FParaBD.CategorieParaBD.Value = 0 then
    l_realisation.Caption := rsTransAuteurs
  else
    l_realisation.Caption := rsTransCreateurs;

  lvUnivers.Items.BeginUpdate;
  lvAuteurs.Items.BeginUpdate;

  lvUnivers.Items.Count := FParaBD.UniversFull.Count;
  lvAuteurs.Items.Count := FParaBD.Auteurs.Count;

  lvUnivers.Items.EndUpdate;
  lvAuteurs.Items.EndUpdate;

  Description.Text := FParaBD.Description.Text;

  cbStock.Checked := FParaBD.Stock;
  cbOffert.Checked := FParaBD.Offert;
  if cbOffert.Checked then
    Label12.Caption := rsTransOffertLe + ' :'
  else
    Label12.Caption := rsTransAcheteLe + ' :';
  AcheteLe.Caption := FParaBD.sDateAchat;
  if FParaBD.Gratuit then
    Prix.Caption := rsTransGratuit
  else if FParaBD.Prix = 0 then
    Prix.Caption := ''
  else
    Prix.Caption := FormatCurr(FormatMonnaie, FParaBD.Prix);

  if FParaBD.PrixCote > 0 then
    lbCote.Caption := Format('%s (%d)', [FormatCurr(FormatMonnaie, FParaBD.PrixCote), FParaBD.AnneeCote])
  else
    lbCote.Caption := '';

  lbNoImage.Visible := not FParaBD.HasImage;

  if FParaBD.HasImage then
  begin
    ImageParaBD.Picture := nil;
    try
      ms := GetCouvertureStream(True, ID_ParaBD, ImageParaBD.Height, ImageParaBD.Width, TGlobalVar.Utilisateur.Options.AntiAliasing);
      if Assigned(ms) then
        try
          jpg := TJPEGImage.Create;
          try
            jpg.LoadFromStream(ms);
            ImageParaBD.Picture.Assign(jpg);
            ImageParaBD.Transparent := False;
          finally
            FreeAndNil(jpg);
          end;
        finally
          FreeAndNil(ms);
        end
      else
        ImageParaBD.Picture.Assign(nil);
    except
      ImageParaBD.Picture.Assign(nil);
    end;

    lbInvalidImage.Visible := not Assigned(ImageParaBD.Picture.Graphic);
    if lbInvalidImage.Visible then
    begin
      ImageParaBD.OnDblClick := nil;
      ImageParaBD.Cursor := crDefault;
      ms := TResourceStream.Create(HInstance, 'IMAGENONVALIDE', RT_RCDATA);
      jpg := TJPEGImage.Create;
      try
        jpg.LoadFromStream(ms);
        ImageParaBD.Picture.Assign(jpg);
        ImageParaBD.Transparent := True;
      finally
        jpg.Free;
        ms.Free;
      end;
    end
    else
    begin
      ImageParaBD.OnDblClick := CouvertureDblClick;
      ImageParaBD.Cursor := crHandPoint;
    end;
  end
  else
    ImageParaBD.Picture.Assign(nil);
end;

procedure TfrmConsultationParaBD.CouvertureDblClick(Sender: TObject);
begin
  Historique.AddWaiting(fcImageParaBD, ID_ParaBD, ID_ParaBD);
end;

procedure TfrmConsultationParaBD.ClearForm;
begin
  lvUnivers.Items.Count := 0;
  lvAuteurs.Items.Count := 0;
end;

procedure TfrmConsultationParaBD.FormCreate(Sender: TObject);
begin
  PrepareLV(Self);
  FParaBD := TParaBDComplet.Create;
end;

procedure TfrmConsultationParaBD.FormDestroy(Sender: TObject);
begin
  ClearForm;
  FParaBD.Free;
end;

procedure TfrmConsultationParaBD.lvAuteursData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FParaBD.Auteurs[Item.Index];
  Item.Caption := TAuteur(Item.Data).ChaineAffichage;
end;

procedure TfrmConsultationParaBD.lvAuteursDblClick(Sender: TObject);
begin
  if Assigned(TListView(Sender).Selected) then
    Historique.AddWaiting(fcAuteur, TAuteur(TListView(Sender).Selected.Data).Personne.ID, 0);
end;

procedure TfrmConsultationParaBD.lvUniversData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FParaBD.UniversFull[Item.Index];
  Item.Caption := TUnivers(Item.Data).ChaineAffichage;
end;

procedure TfrmConsultationParaBD.lvUniversDblClick(Sender: TObject);
begin
  if Assigned(TListView(Sender).Selected) then
    Historique.AddWaiting(fcUnivers, TUnivers(TListView(Sender).Selected.Data).ID, 0);
end;

procedure TfrmConsultationParaBD.TitreSerieClick(Sender: TObject);
var
  s: string;
begin
  if not IsDownKey(VK_CONTROL) then
  begin
    s := FParaBD.Serie.SiteWeb;
    if s <> '' then
      ShellExecute(Application.DialogHandle, nil, PChar(s), nil, nil, SW_NORMAL);
  end;
end;

procedure TfrmConsultationParaBD.TitreSerieDblClick(Sender: TObject);
begin
  if IsDownKey(VK_CONTROL) then
    Historique.AddWaiting(fcSerie, FParaBD.Serie.ID_Serie);
end;

procedure TfrmConsultationParaBD.ImageApercuExecute(Sender: TObject);
begin
  ImpressionImageParaBD(ID_ParaBD, TComponent(Sender).Tag = 1);
end;

procedure TfrmConsultationParaBD.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
begin
  ImageImprime.Enabled := Assigned(ImageParaBD.Picture.Graphic);
  ImageApercu.Enabled := ImageImprime.Enabled;
end;

procedure TfrmConsultationParaBD.FicheApercuExecute(Sender: TObject);
begin
  ImpRep(Sender);
end;

procedure TfrmConsultationParaBD.FicheModifierExecute(Sender: TObject);
begin
  Historique.AddWaiting(fcGestionModif, @RefreshCallBack, nil, @ModifierParaBD2, nil, FParaBD.ID);
end;

procedure TfrmConsultationParaBD.ImpRep(Sender: TObject);
begin
  ImpressionFicheParaBD(ID_ParaBD, TComponent(Sender).Tag = 1)
end;

procedure TfrmConsultationParaBD.ApercuExecute(Sender: TObject);
begin
  FicheApercuExecute(Sender);
end;

function TfrmConsultationParaBD.ApercuUpdate: Boolean;
begin
  Result := True;
end;

procedure TfrmConsultationParaBD.ImpressionExecute(Sender: TObject);
begin
  FicheApercuExecute(Sender);
end;

function TfrmConsultationParaBD.ImpressionUpdate: Boolean;
begin
  Result := True;
end;

procedure TfrmConsultationParaBD.ModificationExecute(Sender: TObject);
begin
  FicheModifierExecute(Sender);
end;

function TfrmConsultationParaBD.ModificationUpdate: Boolean;
begin
  Result := True;
end;

end.
