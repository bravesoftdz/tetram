unit Form_EditParaBD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBEditLabeled, VirtualTrees, ComCtrls, VDTButton, VirtualTree,
  ComboCheck, ExtCtrls, Buttons, Frame_RechercheRapide;

type
  TFrmEditParaBD = class(TForm)
    Panel2: TPanel;
    btnOK: TBitBtn;
    btnAnnuler: TBitBtn;
    ScrollBox: TScrollBox;
    Label2: TLabel;
    Label6: TLabel;
    btCreateur: TVDTButton;
    Label19: TLabel;
    Bevel1: TBevel;
    Label20: TLabel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    edTitre: TEditLabeled;
    description: TMemoLabeled;
    lvAuteurs: TVDTListViewLabeled;
    vtPersonnes: TVirtualStringTree;
    vtSeries: TVirtualStringTree;
    Label24: TLabel;
    edAnneeCote: TEditLabeled;
    Label25: TLabel;
    edPrixCote: TEditLabeled;
    VDTButton14: TVDTButton;
    Label10: TLabel;
    edAnneeEdition: TEditLabeled;
    cbStock: TCheckBoxLabeled;
    cbGratuit: TCheckBoxLabeled;
    cbOffert: TCheckBoxLabeled;
    dtpAchat: TDateTimePickerLabeled;
    Label18: TLabel;
    Label9: TLabel;
    edPrix: TEditLabeled;
    SpeedButton3: TVDTButton;
    cbDedicace: TCheckBoxLabeled;
    Label12: TLabel;
    cbxType: TLightComboCheck;
    Panel1: TPanel;
    imgVisu: TImage;
    cbNumerote: TCheckBoxLabeled;
    Panel3: TPanel;
    ChoixImage: TVDTButton;
    FrameRechercheRapideSerie: TFrameRechercheRapide;
    FrameRechercheRapideAuteur: TFrameRechercheRapide;
    procedure cbOffertClick(Sender: TObject);
    procedure cbGratuitClick(Sender: TObject);
    procedure edPrixChange(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure VDTButton14Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    FCreation: Boolean;
    FisAchat: Boolean;
    FRefParaBD: Integer;
    procedure SetRefParaBD(const Value: Integer);
    { Déclarations privées }
  public
    { Déclarations publiques }
    property isCreation: Boolean read FCreation;
    property isAchat: Boolean read FisAchat write FisAchat;
    property RefParaBD: Integer read FRefParaBD write SetRefParaBD;
  end;

  TFrmEditAchatParaBD = class(TFrmEditParaBD)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses DM_Princ, JvUIB, Commun, jvuiblib, CommonConst, Textes, Procedures,
  Proc_Gestions;

{$R *.dfm}

{ TFrmEditAchatParaBD }

constructor TFrmEditAchatParaBD.Create(AOwner: TComponent);
begin
  inherited;
  FisAchat := True;
end;

{ TFrmEditParaBD }

procedure TFrmEditParaBD.SetRefParaBD(const Value: Integer);
var
  q: TJvUIBQuery;
begin
  FRefParaBD := Value;

  q := TJvUIBQuery.Create(nil);
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);

    SQL.Text := 'SELECT TITREPARABD, ANNEE, REFSERIE, TYPEPARABD, ACHAT, DESCRIPTION, DEDICACE, NUMEROTE, ANNEECOTE, PRIXCOTE, GRATUIT, OFFERT,';
    SQL.Add('DATEACHAT, PRIX, STOCK');
    SQL.Add('FROM PARABD WHERE RefParaBD = ?');
    Params.AsInteger[0] := FRefParaBD;
    FetchBlobs := True;
    Open;

    FCreation := Eof;
    if not FCreation then begin
      edTitre.Text := Fields.ByNameAsString['TITREPARABD'];
      edAnneeEdition.Text := Fields.ByNameAsString['ANNEE'];
      cbDedicace.Checked := Fields.ByNameAsBoolean['DEDICACE'];
      cbNumerote.Checked := Fields.ByNameAsBoolean['NUMEROTE'];
      description.Lines.Text := Fields.ByNameAsString['DESCRIPTION'];

      cbGratuit.Checked := Fields.ByNameAsBoolean['GRATUIT'];
      cbOffert.Checked := Fields.ByNameAsBoolean['OFFERT'];
      cbOffertClick(nil);
      cbxType.Value := Fields.ByNameAsInteger['TYPEPARABD'];

      cbStock.Checked := Fields.ByNameAsBoolean['STOCK'];
      dtpAchat.Date := Now;
      dtpAchat.Checked := Fields.ByNameIsNull['DateAchat'];
      if dtpAchat.Checked then dtpAchat.Date := Fields.ByNameAsDate['DateAchat'];
      if Fields.ByNameIsNull['PRIX'] then
        edPrix.Text := ''
      else
        edPrix.Text := FormatCurr(FormatMonnaie, Fields.ByNameAsCurrency['PRIX']);
      edAnneeCote.Text := Fields.ByNameAsString['ANNEECOTE'];
      if Fields.ByNameIsNull['PRIXCOTE'] then
        edPrixCote.Text := ''
      else
        edPrixCote.Text := FormatCurr(FormatMonnaie, Fields.ByNameAsCurrency['PRIXCOTE']);

      vtSeries.CurrentValue := Fields.ByNameAsInteger['REFSERIE'];
    end;
  finally
    lvAuteurs.Items.EndUpdate;
    Transaction.Free;
    Free;
  end;
end;

procedure TFrmEditParaBD.cbOffertClick(Sender: TObject);
begin
  if cbOffert.Checked then
    Label18.Caption := rsTransOffertLe
  else
    Label18.Caption := rsTransAcheteLe;
end;

procedure TFrmEditParaBD.cbGratuitClick(Sender: TObject);
begin
  if cbGratuit.Checked then edPrix.Text := '';
end;

procedure TFrmEditParaBD.edPrixChange(Sender: TObject);
begin
  if edPrix.Text <> '' then cbGratuit.Checked := False;
end;

procedure TFrmEditParaBD.SpeedButton3Click(Sender: TObject);
var
  c: Currency;
begin
  c := StrToCurrDef(StringReplace(edPrix.Text, Utilisateur.Options.SymboleMonnetaire, '', []), 0);
  if Convertisseur(SpeedButton3, c) then
    if edPrix.Focused then
      edPrix.Text := FormatCurr(FormatMonnaieSimple, c)
    else
      edPrix.Text := FormatCurr(FormatMonnaie, c);
end;

procedure TFrmEditParaBD.VDTButton14Click(Sender: TObject);
var
  c: Currency;
begin
  c := StrToCurrDef(StringReplace(edPrixCote.Text, Utilisateur.Options.SymboleMonnetaire, '', []), 0);
  if Convertisseur(SpeedButton3, c) then
    if edPrixCote.Focused then
      edPrixCote.Text := FormatCurr(FormatMonnaieSimple, c)
    else
      edPrixCote.Text := FormatCurr(FormatMonnaie, c);
end;

procedure TFrmEditParaBD.FormActivate(Sender: TObject);
begin
  Invalidate;
end;

end.

