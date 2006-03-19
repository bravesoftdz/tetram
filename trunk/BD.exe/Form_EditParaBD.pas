unit Form_EditParaBD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBEditLabeled, VirtualTrees, ComCtrls, VDTButton,
  ComboCheck, ExtCtrls, Buttons;

type
  TFrmEditParaBD = class(TForm)
    Panel2: TPanel;
    btnOK: TBitBtn;
    btnAnnuler: TBitBtn;
    ScrollBox: TScrollBox;
    imgVisu: TImage;
    Label3: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    btScenariste: TVDTButton;
    btDessinateur: TVDTButton;
    VDTButton7: TVDTButton;
    VDTButton8: TVDTButton;
    Label19: TLabel;
    ChoixImage: TVDTButton;
    VDTButton4: TVDTButton;
    VDTButton5: TVDTButton;
    Bevel1: TBevel;
    Label20: TLabel;
    VDTButton12: TVDTButton;
    btColoriste: TVDTButton;
    Label1: TLabel;
    VDTButton11: TVDTButton;
    Label5: TLabel;
    VDTButton1: TVDTButton;
    Label8: TLabel;
    VDTButton2: TVDTButton;
    Label4: TLabel;
    VDTButton3: TVDTButton;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    VDTButton9: TVDTButton;
    VDTButton10: TVDTButton;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    PanelEdition: TPanel;
    SpeedButton3: TVDTButton;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    VDTButton6: TVDTButton;
    Label12: TLabel;
    Label13: TLabel;
    cbxEtat: TLightComboCheck;
    cbxReliure: TLightComboCheck;
    Label14: TLabel;
    cbxEdition: TLightComboCheck;
    Label18: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    cbxOrientation: TLightComboCheck;
    Label23: TLabel;
    cbxFormat: TLightComboCheck;
    VDTButton13: TVDTButton;
    Label24: TLabel;
    Label25: TLabel;
    VDTButton14: TVDTButton;
    edPrix: TEditLabeled;
    edAnneeEdition: TEditLabeled;
    edISBN: TEditLabeled;
    cbVO: TCheckBoxLabeled;
    cbCouleur: TCheckBoxLabeled;
    cbStock: TCheckBoxLabeled;
    cbDedicace: TCheckBoxLabeled;
    dtpAchat: TDateTimePickerLabeled;
    cbGratuit: TCheckBoxLabeled;
    cbOffert: TCheckBoxLabeled;
    edNombreDePages: TEditLabeled;
    edAnneeCote: TEditLabeled;
    edPrixCote: TEditLabeled;
    edAnneeParution: TEditLabeled;
    edTitre: TEditLabeled;
    histoire: TMemoLabeled;
    remarques: TMemoLabeled;
    lvScenaristes: TVDTListViewLabeled;
    lvDessinateurs: TVDTListViewLabeled;
    vtPersonnes: TVirtualStringTree;
    Edit2: TEditLabeled;
    vstImages: TVirtualStringTree;
    Edit3: TEditLabeled;
    vtSeries: TVirtualStringTree;
    lvColoristes: TVDTListViewLabeled;
    cbIntegrale: TCheckBoxLabeled;
    edTome: TEditLabeled;
    EditLabeled1: TEditLabeled;
    vtEditeurs: TVirtualStringTree;
    EditLabeled2: TEditLabeled;
    vtCollections: TVirtualStringTree;
    vtEditions: TListBoxLabeled;
    cbHorsSerie: TCheckBoxLabeled;
    edNotes: TMemoLabeled;
    edTomeDebut: TEditLabeled;
    edTomeFin: TEditLabeled;
    edMoisParution: TEditLabeled;
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

{$R *.dfm}

{ TFrmEditParaBD }

procedure TFrmEditParaBD.SetRefParaBD(const Value: Integer);
begin
  FRefParaBD := Value;
end;

{ TFrmEditAchatParaBD }

constructor TFrmEditAchatParaBD.Create(AOwner: TComponent);
begin
  inherited;
  FisAchat := True;
end;

end.
