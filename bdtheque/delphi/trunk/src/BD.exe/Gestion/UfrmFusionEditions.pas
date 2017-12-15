unit UfrmFusionEditions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BD.GUI.Forms, StdCtrls, ExtCtrls, BD.GUI.Frames.Buttons, BD.Entities.Full,
  Generics.Collections, LabeledCheckBox;

type
  TfrmFusionEditions = class(TBdtForm)
    lbEditions: TListBox;
    CheckBox1: TCheckBox;
    pnEditionSrc: TPanel;
    ISBN: TLabel;
    Editeur: TLabel;
    Prix: TLabel;
    Lbl_numero: TLabel;
    Lbl_type: TLabel;
    Label3: TLabel;
    Label9: TLabel;
    Collection: TLabel;
    Label16: TLabel;
    AnneeEdition: TLabel;
    Etat: TLabel;
    Label10: TLabel;
    Reliure: TLabel;
    Label13: TLabel;
    TypeEdition: TLabel;
    Label8: TLabel;
    Label12: TLabel;
    AcheteLe: TLabel;
    Label15: TLabel;
    Pages: TLabel;
    Label17: TLabel;
    lbOrientation: TLabel;
    Label19: TLabel;
    lbFormat: TLabel;
    lbCote: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    lbSensLecture: TLabel;
    Label22: TLabel;
    lbNumeroPerso: TLabel;
    cbVO: TLabeledCheckBox;
    cbCouleur: TLabeledCheckBox;
    cbStock: TLabeledCheckBox;
    edNotes: TMemo;
    cbOffert: TLabeledCheckBox;
    cbDedicace: TLabeledCheckBox;
    pnEditionDst: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label11: TLabel;
    Label14: TLabel;
    Label18: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    ReadOnlyCheckBox1: TLabeledCheckBox;
    ReadOnlyCheckBox2: TLabeledCheckBox;
    ReadOnlyCheckBox3: TLabeledCheckBox;
    Memo1: TMemo;
    ReadOnlyCheckBox4: TLabeledCheckBox;
    ReadOnlyCheckBox5: TLabeledCheckBox;
    framBoutons1: TframBoutons;
    Label44: TLabel;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    procedure CheckBox1Click(Sender: TObject);
    procedure lbEditionsClick(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
  private
    procedure UpdateBtnOk;
  public
    procedure SetEditionDst(Edition: TEditionFull);
    procedure SetEditionSrc(Edition: TEditionFull);
    procedure SetEditions(Editions: TList<TEditionFull>; const Exclure: array of TEditionFull);
  end;

implementation

uses
  BD.Strings, BD.Utils.StrUtils, BD.Common, StrUtils, BD.Entities.Common;

{$R *.dfm}

procedure TfrmFusionEditions.CheckBox1Click(Sender: TObject);
begin
  lbEditions.Enabled := not CheckBox1.Checked;
  if CheckBox1.Checked then
    SetEditionDst(nil)
  else
    lbEditionsClick(nil);
  UpdateBtnOk;
end;

procedure TfrmFusionEditions.CheckBox2Click(Sender: TObject);
begin
  CheckBox3.Enabled := CheckBox2.Enabled;
end;

procedure TfrmFusionEditions.lbEditionsClick(Sender: TObject);
begin
  if lbEditions.ItemIndex = -1 then
    SetEditionDst(nil)
  else
    SetEditionDst(TEditionFull(lbEditions.Items.Objects[lbEditions.ItemIndex]));
  UpdateBtnOk;
end;

procedure TfrmFusionEditions.SetEditionDst(Edition: TEditionFull);
begin
  if not Assigned(Edition) then
  begin
    Label1.Caption := '';
    Label2.Caption := '';
    Label14.Caption := '';
    ReadOnlyCheckBox3.Checked := False;
    Label23.Caption := '';
    ReadOnlyCheckBox1.Checked := False;
    ReadOnlyCheckBox4.Checked := False;
    ReadOnlyCheckBox2.Checked := False;
    ReadOnlyCheckBox5.Checked := False;
    Label28.Caption := '';
    Label26.Caption := '';
    Label24.Caption := '';
    Label33.Caption := '';
    Label35.Caption := '';
    Label37.Caption := '';
    Label41.Caption := '';
    Label43.Caption := '';
    Label30.Caption := '';
    Label31.Caption := '';
    Memo1.Lines.Clear;
    Label4.Caption := '';
    Label38.Caption := '';
  end
  else
  begin
    Label1.Caption := FormatISBN(Edition.ISBN);
    Label2.Caption := FormatTitre(Edition.Editeur.NomEditeur);
    Label14.Caption := Edition.Collection.ChaineAffichage;
    ReadOnlyCheckBox3.Checked := Edition.Stock;
    Label23.Caption := NonZero(IntToStr(Edition.AnneeEdition));
    ReadOnlyCheckBox1.Checked := Edition.VO;
    ReadOnlyCheckBox4.Checked := Edition.Offert;
    ReadOnlyCheckBox2.Checked := Edition.Couleur;
    ReadOnlyCheckBox5.Checked := Edition.Dedicace;
    Label28.Caption := Edition.TypeEdition.Caption;
    Label26.Caption := Edition.Reliure.Caption;
    Label24.Caption := Edition.Etat.Caption;
    Label33.Caption := NonZero(IntToStr(Edition.NombreDePages));
    Label35.Caption := Edition.Orientation.Caption;
    Label37.Caption := Edition.FormatEdition.Caption;
    Label41.Caption := Edition.SensLecture.Caption;
    Label43.Caption := Edition.NumeroPerso;
    if ReadOnlyCheckBox4.Checked then
      Label30.Caption := rsTransOffertLe + ' :'
    else
      Label30.Caption := rsTransAcheteLe + ' :';
    Label31.Caption := Edition.sDateAchat;
    Memo1.Text := Edition.Notes;

    if Edition.Gratuit then
      Label4.Caption := rsTransGratuit
    else if Edition.Prix = 0 then
      Label4.Caption := ''
    else
      Label4.Caption := BDCurrencyToStr(Edition.Prix);

    if Edition.PrixCote > 0 then
      Label38.Caption := Format('%s (%d)', [BDCurrencyToStr(Edition.PrixCote), Edition.AnneeCote])
    else
      Label38.Caption := '';
  end;
end;

procedure TfrmFusionEditions.SetEditions(Editions: TList<TEditionFull>; const Exclure: array of TEditionFull);

  function NotInExclusion(const ID: TGUID): Boolean;
  var
    i: Integer;
  begin
    i := 0;
    Result := True;
    while Result and (i <= Pred(Length(Exclure))) do
    begin
      Result := not Assigned(Exclure[i]) or not IsEqualGUID(Exclure[i].ID_Edition, ID);
      Inc(i);
    end;
  end;

var
  dummy, iiIsbn, iiInconnu: Integer;
  Edition: TEditionFull;
begin
  lbEditions.Clear;
  iiIsbn := -1;
  iiInconnu := -1;
  for Edition in Editions do
    if NotInExclusion(Edition.ID_Edition) then
    begin
      dummy := lbEditions.Items.AddObject(Edition.ChaineAffichage, Edition);
      if (iiIsbn = -1) and SameText(FormatISBN(Edition.ISBN), ISBN.Caption) then iiIsbn := dummy;
      if Edition.RecInconnu then iiInconnu := dummy;
    end;

  if iiInconnu <> -1 then
    lbEditions.ItemIndex := iiInconnu
  else if iiIsbn <> -1 then
    lbEditions.ItemIndex := iiIsbn
  else
    lbEditions.ItemIndex := -1;

  CheckBox1.Checked := lbEditions.Items.Count = 0;
  CheckBox1.Enabled := not CheckBox1.Checked;
  lbEditions.Enabled := CheckBox1.Enabled;
  CheckBox1Click(nil);
end;

procedure TfrmFusionEditions.SetEditionSrc(Edition: TEditionFull);
begin
  ISBN.Caption := FormatISBN(Edition.ISBN);
  Editeur.Caption := FormatTitre(Edition.Editeur.NomEditeur);
  Collection.Caption := Edition.Collection.ChaineAffichage;
  cbStock.Checked := Edition.Stock;
  AnneeEdition.Caption := NonZero(IntToStr(Edition.AnneeEdition));
  cbVO.Checked := Edition.VO;
  cbOffert.Checked := Edition.Offert;
  cbCouleur.Checked := Edition.Couleur;
  cbDedicace.Checked := Edition.Dedicace;
  TypeEdition.Caption := Edition.TypeEdition.Caption;
  Reliure.Caption := Edition.Reliure.Caption;
  Etat.Caption := Edition.Etat.Caption;
  Pages.Caption := NonZero(IntToStr(Edition.NombreDePages));
  lbOrientation.Caption := Edition.Orientation.Caption;
  lbFormat.Caption := Edition.FormatEdition.Caption;
  lbSensLecture.Caption := Edition.SensLecture.Caption;
  lbNumeroPerso.Caption := Edition.NumeroPerso;
  if cbOffert.Checked then
    Label12.Caption := rsTransOffertLe + ' :'
  else
    Label12.Caption := rsTransAcheteLe + ' :';
  AcheteLe.Caption := Edition.sDateAchat;
  edNotes.Lines.Text := Edition.Notes;

  if Edition.Gratuit then
    Prix.Caption := rsTransGratuit
  else if Edition.Prix = 0 then
    Prix.Caption := ''
  else
    Prix.Caption := BDCurrencyToStr(Edition.Prix);

  if Edition.PrixCote > 0 then
    lbCote.Caption := Format('%s (%d)', [BDCurrencyToStr(Edition.PrixCote), Edition.AnneeCote])
  else
    lbCote.Caption := '';
end;

procedure TfrmFusionEditions.UpdateBtnOk;
begin
  framBoutons1.btnOK.Enabled := CheckBox1.Checked or (lbEditions.ItemIndex <> -1);
end;

end.
