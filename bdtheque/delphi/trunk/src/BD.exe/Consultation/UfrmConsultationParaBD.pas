unit UfrmConsultationParaBD;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, System.UITypes, System.StrUtils,
  Vcl.Dialogs, BD.Entities.Full, Vcl.StdCtrls, VirtualTrees, Vcl.ExtCtrls, BDTK.GUI.Forms.Main, BD.Utils.GUIUtils,
  Vcl.ComCtrls, VDTButton, Vcl.Buttons, Vcl.ActnList, Vcl.Menus, BDTK.GUI.Utils, BD.GUI.Forms,
  LabeledCheckBox, System.Actions, PngSpeedButton;

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
    VDTButton3: TVDTButton;
    VDTButton4: TVDTButton;
    Notes: TMemo;
    l_notes: TLabel;
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
    procedure VDTButton3Click(Sender: TObject);
    procedure VDTButton4Click(Sender: TObject);
  strict private
    CurrentPhoto: Integer;
    FParaBD: TParaBDFull;
    function GetID_ParaBD: TGUID;
    procedure SetID_ParaBD(const Value: TGUID);
    procedure ClearForm;
    procedure ImageParaBDDblClick(Sender: TObject);
    procedure ImpRep(Sender: TObject);
    procedure ApercuExecute(Sender: TObject);
    function ApercuUpdate: Boolean;
    procedure ImpressionExecute(Sender: TObject);
    function ImpressionUpdate: Boolean;
    procedure ModificationExecute(Sender: TObject);
    function ModificationUpdate: Boolean;
    procedure ShowPhoto(Num: Integer);
  public
    { Déclarations publiques }
    property ParaBD: TParaBDFull read FParaBD;
    property ID_ParaBD: TGUID read GetID_ParaBD write SetID_ParaBD;
  end;

implementation

uses
  BD.Utils.StrUtils, BD.Entities.Lite, UHistorique, Divers, Winapi.ShellAPI, BD.Strings, BD.Common, Vcl.Imaging.jpeg, Impression,
  Proc_Gestions, BDTK.Entities.Dao.Full, BD.Entities.Common, BD.Entities.Factory.Full,
  BD.GUI.Forms.Console;

{$R *.dfm}
{ TFrmConsultationParaBD }

function TfrmConsultationParaBD.GetID_ParaBD: TGUID;
begin
  Result := FParaBD.ID_ParaBD;
end;

procedure TfrmConsultationParaBD.SetID_ParaBD(const Value: TGUID);
begin
  ClearForm;
  TDaoParaBDFull.Fill(FParaBD, Value, nil);

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

  if FParaBD.CategorieParaBD.Value = 700 then
    l_realisation.Caption := rsTransAuteurs
  else
    l_realisation.Caption := rsTransCreateurs;

  lvUnivers.Items.BeginUpdate;
  lvAuteurs.Items.BeginUpdate;

  lvUnivers.Items.Count := FParaBD.UniversFull.Count;
  lvAuteurs.Items.Count := FParaBD.Auteurs.Count;

  lvUnivers.Items.EndUpdate;
  lvAuteurs.Items.EndUpdate;

  Description.Text := FParaBD.Description;
  Notes.Text := FParaBD.Notes;

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
    Prix.Caption := BDCurrencyToStr(FParaBD.Prix);

  if FParaBD.PrixCote > 0 then
    lbCote.Caption := Format('%s (%d)', [BDCurrencyToStr(FParaBD.PrixCote), FParaBD.AnneeCote])
  else
    lbCote.Caption := '';

  ShowPhoto(0);
  VDTButton3.Visible := FParaBD.Photos.Count > 1;
  VDTButton4.Visible := VDTButton3.Visible;
end;

procedure TfrmConsultationParaBD.ShowPhoto(Num: Integer);
var
  hg: IHourGlass;
  ms: TStream;
  jpg: TJPEGImage;
begin
  TfrmConsole.AddEvent(UnitName, 'ShowPhoto ' + IntToStr(Num));
  lbNoImage.Visible := FParaBD.Photos.Count = 0;

  if FParaBD.Photos.Count > 0 then
  begin
    hg := THourGlass.Create;
    if Num < 0 then
      Num := Pred(FParaBD.Photos.Count);
    if Num > Pred(FParaBD.Photos.Count) then
      Num := 0;
    CurrentPhoto := Num;
    ImageParaBD.Picture := nil;
    try
      TfrmConsole.AddEvent(UnitName, '> GetCouvertureStream');
      ms := GetCouvertureStream(True, FParaBD.Photos[Num].ID, ImageParaBD.Height, ImageParaBD.Width, TGlobalVar.Options.AntiAliasing);
      TfrmConsole.AddEvent(UnitName, '< GetCouvertureStream');

      if Assigned(ms) then
        try
          jpg := TJPEGImage.Create;
          try
            jpg.LoadFromStream(ms);
            ImageParaBD.Picture.Assign(jpg);
            ImageParaBD.Transparent := False;
          finally
            jpg.Free;
          end;
        finally
          ms.Free;
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
      ImageParaBD.OnDblClick := ImageParaBDDblClick;
      ImageParaBD.Cursor := crHandPoint;
    end;
  end
  else
    ImageParaBD.Picture.Assign(nil);

  TfrmConsole.AddEvent(UnitName, 'ShowPhoto done ' + IntToStr(Num));
end;

procedure TfrmConsultationParaBD.ImageParaBDDblClick(Sender: TObject);
begin
  Historique.AddWaiting(fcImageParaBD, ID_ParaBD, FParaBD.Photos[CurrentPhoto].ID);
end;

procedure TfrmConsultationParaBD.ClearForm;
begin
  lvUnivers.Items.Count := 0;
  lvAuteurs.Items.Count := 0;
end;

procedure TfrmConsultationParaBD.FormCreate(Sender: TObject);
begin
  FParaBD := TFactoryParaBDFull.getInstance;
  PrepareLV(Self);
  CurrentPhoto := 0;
  ImageParaBD.Picture := nil;
end;

procedure TfrmConsultationParaBD.FormDestroy(Sender: TObject);
begin
  ClearForm;
  FParaBD.Free;
end;

procedure TfrmConsultationParaBD.lvAuteursData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FParaBD.Auteurs[Item.Index];
  Item.Caption := TAuteurLite(Item.Data).ChaineAffichage;
end;

procedure TfrmConsultationParaBD.lvAuteursDblClick(Sender: TObject);
begin
  if Assigned(TListView(Sender).Selected) then
    Historique.AddWaiting(fcAuteur, TAuteurLite(TListView(Sender).Selected.Data).Personne.ID, 0);
end;

procedure TfrmConsultationParaBD.lvUniversData(Sender: TObject; Item: TListItem);
begin
  Item.Data := FParaBD.UniversFull[Item.Index];
  Item.Caption := TUniversLite(Item.Data).ChaineAffichage;
end;

procedure TfrmConsultationParaBD.lvUniversDblClick(Sender: TObject);
begin
  if Assigned(TListView(Sender).Selected) then
    Historique.AddWaiting(fcUnivers, TUniversLite(TListView(Sender).Selected.Data).ID, 0);
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

procedure TfrmConsultationParaBD.VDTButton3Click(Sender: TObject);
begin
  ShowPhoto(Pred(CurrentPhoto));
end;

procedure TfrmConsultationParaBD.VDTButton4Click(Sender: TObject);
begin
  ShowPhoto(Succ(CurrentPhoto));
end;

procedure TfrmConsultationParaBD.ImageApercuExecute(Sender: TObject);
begin
  ImpressionImageParaBD(ID_ParaBD, FParaBD.Photos[CurrentPhoto].ID, TComponent(Sender).Tag = 1);
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
  Historique.AddWaiting(fcGestionModif, RefreshCallBack, nil, @ModifierParaBD2, nil, FParaBD.ID);
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
