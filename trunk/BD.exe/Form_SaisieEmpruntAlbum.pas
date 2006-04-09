unit Form_SaisieEmpruntAlbum;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, ComCtrls, ExtCtrls, Fram_Boutons, VDTButton,
  ScanEdit, Menus, Buttons, Commun, DBEditLabeled, VirtualTrees, VirtualTree,
  ComboCheck, LoadComplet, Frame_RechercheRapide;

type
  TFrmSaisie_EmpruntAlbum = class(TForm)
    Frame11: TFrame1;
    Label1: TLabel;
    date_pret: TDateTimePickerLabeled;
    pret: TCheckBoxLabeled;
    VTreeEmprunteur: TVirtualStringTree;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lccEditions: TLightComboCheck;
    FrameRechercheRapide1: TFrameRechercheRapide;
    procedure FormCreate(Sender: TObject);
    procedure okClick(Sender: TObject);
    procedure VTreeEmprunteurChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure lccEditionsChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
    FRefAlbum: Integer;
    FEdition: TEditionComplete;
    procedure SetRefAlbum(Value: Integer);
    procedure SetRefEmprunteur(Value: Integer);
    function GetRefEmprunteur: Integer;
    procedure SetRefEdition(const Value: Integer);
    function GetRefEdition: Integer;
  public
    { Déclarations publiques }
    property RefAlbum: Integer read FRefAlbum write SetRefAlbum;
    property RefEdition: Integer read GetRefEdition write SetRefEdition;
    property RefEmprunteur: Integer read GetRefEmprunteur write SetRefEmprunteur;
  end;

var
  FrmSaisie_EmpruntAlbum: TFrmSaisie_EmpruntAlbum;

implementation

uses DM_Princ, CommonConst, TypeRec, CommonList, Procedures;

{$R *.DFM}

const
  ErrorSaveMvt = 'Impossible d''enregistrer le mouvement !';
  TitreListeEmprunts = 'Liste des emprunts';
  NoEmprunts = 'Pas d''emprunts.';
  NotThisEntryHere = 'Impossible d''ajouter ce mouvement dans cette fenêtre';

procedure TFrmSaisie_EmpruntAlbum.SetRefAlbum(Value: Integer);
var
  i: Integer;
  Editions: TEditionsComplet;
  PEd: TEdition;
  PA: TAlbum;
  PS: TSerie;
begin
  if Value = FRefAlbum then Exit;
  FRefAlbum := Value;
  PA := TAlbum.Create;
  PS := TSerie.Create;
  try
    PA.Fill(FRefAlbum);
    Label2.Caption := PA.ChaineAffichage;
    PS.Fill(PA.RefSerie);
    Label5.Caption := PS.ChaineAffichage;
  finally
    PA.Free;
    PS.Free;
  end;
  lccEditions.Items.Clear;
  Editions := TEditionsComplet.Create(FRefAlbum);
  try
    for i := 0 to Pred(Editions.Editions.Count) do begin
      PEd := Editions.Editions[i];
      with lccEditions.Items.Add do begin
        Caption := PEd.ChaineAffichage;
        Valeur := PEd.Reference;
      end;
      if i = 0 then lccEditions.DefaultValueChecked := PEd.Reference;
    end;
  finally
    Editions.Free;
  end;
end;

procedure TFrmSaisie_EmpruntAlbum.SetRefEmprunteur(Value: Integer);
begin
  VTreeEmprunteur.CurrentValue := Value;
end;

function TFrmSaisie_EmpruntAlbum.GetRefEmprunteur: Integer;
begin
  Result := VTreeEmprunteur.CurrentValue;
end;

procedure TFrmSaisie_EmpruntAlbum.FormCreate(Sender: TObject);
begin
  PrepareLV(Self);
  FrameRechercheRapide1.VirtualTreeView := VTreeEmprunteur;
  FrameRechercheRapide1.ShowNewButton := False;
  FEdition := TEditionComplete.Create;
  VTreeEmprunteur.Mode := vmEmprunteurs;
  date_pret.Date := Date;
  ChargeImage(VTreeEmprunteur.Background, 'FONDVT');
end;

procedure TFrmSaisie_EmpruntAlbum.okClick(Sender: TObject);
begin
  if RefEmprunteur = -1 then begin
    ModalResult := mrNone;
    Exit;
  end;
  if (Utilisateur.Options.AvertirPret and FEdition.Prete and pret.Checked) and (MessageDlg('Cette édition est déjà prêtée.'#13#10'Continuer?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes) then begin
    ModalResult := mrNone;
    Exit;
  end;
  AjoutMvt(RefEmprunteur, RefEdition, Date_Pret.Date, Pret.Checked);
end;

procedure TFrmSaisie_EmpruntAlbum.VTreeEmprunteurChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  Frame11.btnOK.Enabled := RefEmprunteur <> -1;
end;

procedure TFrmSaisie_EmpruntAlbum.SetRefEdition(const Value: Integer);
begin
  if lccEditions.ValidValue(Value) then begin
    lccEditions.Value := Value;
    lccEditions.DefaultValueChecked := Value;
    if RefEdition <> Value then lccEditionsChange(nil);
  end;
end;

procedure TFrmSaisie_EmpruntAlbum.lccEditionsChange(Sender: TObject);
begin
  FEdition.Fill(lccEditions.Value);
end;

procedure TFrmSaisie_EmpruntAlbum.FormDestroy(Sender: TObject);
begin
  FEdition.Free;
end;

function TFrmSaisie_EmpruntAlbum.GetRefEdition: Integer;
begin
  Result := FEdition.RefEdition;
end;

end.

