unit UfrmSaisieEmpruntAlbum;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, ComCtrls, ExtCtrls, UframBoutons, VDTButton,
  ScanEdit, Menus, Buttons, Commun, DBEditLabeled, VirtualTrees, VirtualTree,
  ComboCheck, LoadComplet, UframRechercheRapide, UBdtForms;

type
  TfrmSaisieEmpruntAlbum = class(TbdtForm)
    Frame11: TframBoutons;
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
    FID_Album: TGUID;
    FEdition: TEditionComplete;
    FEditions: TEditionsComplet;
    procedure SetID_Album(const Value: TGUID);
    procedure SetID_Emprunteur(const Value: TGUID);
    function GetID_Emprunteur: TGUID;
    procedure SetID_Edition(const Value: TGUID);
    function GetID_Edition: TGUID;
  public
    { Déclarations publiques }
    property ID_Album: TGUID read FID_Album write SetID_Album;
    property ID_Edition: TGUID read GetID_Edition write SetID_Edition;
    property ID_Emprunteur: TGUID read GetID_Emprunteur write SetID_Emprunteur;
  end;

implementation

uses CommonConst, TypeRec, ProceduresBDtk, Procedures;

{$R *.DFM}

const
  ErrorSaveMvt = 'Impossible d''enregistrer le mouvement !';
  TitreListeEmprunts = 'Liste des emprunts';
  NoEmprunts = 'Pas d''emprunts.';
  NotThisEntryHere = 'Impossible d''ajouter ce mouvement dans cette fenêtre';

procedure TfrmSaisieEmpruntAlbum.SetID_Album(const Value: TGUID);
var
  i: Integer;
  PEd: TEditionComplete;
  PA: TAlbum;
  PS: TSerie;
begin
  if IsEqualGUID(Value, FID_Album) then Exit;
  FID_Album := Value;
  PA := TAlbum.Create;
  PS := TSerie.Create;
  try
    PA.Fill(FID_Album);
    Label2.Caption := PA.ChaineAffichage;
    PS.Fill(PA.ID_Serie);
    Label5.Caption := PS.ChaineAffichage(False);
  finally
    PA.Free;
    PS.Free;
  end;
  lccEditions.Items.Clear;
  FEditions.Fill(FID_Album);
  for i := 0 to Pred(FEditions.Editions.Count) do begin
    PEd := FEditions.Editions[i];
    with lccEditions.Items.Add do begin
      Caption := PEd.ChaineAffichage;
      Valeur := i;
    end;
  end;
  lccEditions.DefaultValueChecked := 0;
end;

procedure TfrmSaisieEmpruntAlbum.SetID_Emprunteur(const Value: TGUID);
begin
  VTreeEmprunteur.CurrentValue := Value;
end;

function TfrmSaisieEmpruntAlbum.GetID_Emprunteur: TGUID;
begin
  Result := VTreeEmprunteur.CurrentValue;
end;

procedure TfrmSaisieEmpruntAlbum.FormCreate(Sender: TObject);
begin
  PrepareLV(Self);
  FrameRechercheRapide1.VirtualTreeView := VTreeEmprunteur;
  FrameRechercheRapide1.ShowNewButton := False;
  VTreeEmprunteur.Mode := vmEmprunteurs;
  FEditions := TEditionsComplet.Create;
  FEdition := nil;
  date_pret.Date := Date;
  ChargeImage(VTreeEmprunteur.Background, 'FONDVT');
end;

procedure TfrmSaisieEmpruntAlbum.okClick(Sender: TObject);
begin
  if IsEqualGUID(ID_Emprunteur, GUID_NULL) then begin
    ModalResult := mrNone;
    Exit;
  end;
  if (TGlobalVar.Utilisateur.Options.AvertirPret and FEdition.Prete and pret.Checked) and (MessageDlg('Cette édition est déjà prêtée.'#13#10'Continuer?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes) then begin
    ModalResult := mrNone;
    Exit;
  end;
  AjoutMvt(ID_Emprunteur, ID_Edition, Date_Pret.Date, Pret.Checked);
end;

procedure TfrmSaisieEmpruntAlbum.VTreeEmprunteurChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  Frame11.btnOK.Enabled := not IsEqualGUID(ID_Emprunteur, GUID_NULL) and not IsEqualGUID(ID_Edition, GUID_NULL);
end;

procedure TfrmSaisieEmpruntAlbum.SetID_Edition(const Value: TGUID);
var
  i, lccEditionValue: Integer;
begin
  lccEditionValue := -1;
  for i := 0 to Pred(FEditions.Editions.Count) do
    if IsEqualGUID(Value, TEdition(FEditions.Editions[i]).ID) then begin
      lccEditionValue := i;
      Break;
    end;

  if lccEditions.ValidValue(lccEditionValue) then begin
    lccEditions.Value := lccEditionValue;
    lccEditions.DefaultValueChecked := lccEditionValue;
    if not IsEqualGUID(ID_Edition, Value) then lccEditionsChange(nil);
  end;
end;

procedure TfrmSaisieEmpruntAlbum.lccEditionsChange(Sender: TObject);
begin
  FEdition := FEditions.Editions[lccEditions.Value];
end;

procedure TfrmSaisieEmpruntAlbum.FormDestroy(Sender: TObject);
begin
  FEdition := nil;
  FEditions.Free;
end;

function TfrmSaisieEmpruntAlbum.GetID_Edition: TGUID;
begin
  if Assigned(FEdition) then
    Result := FEdition.ID_Edition
  else
    Result := GUID_NULL;
end;

end.

