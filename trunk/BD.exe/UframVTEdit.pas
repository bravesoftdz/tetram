unit UframVTEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, VDTButton, CRFurtif, StdCtrls, Mask, JvExMask,
  JvToolEdit, UVirtualTreeEdit, VirtualTree, UHistorique, PngSpeedButton, UfrmFond;

type
  TframVTEdit = class(TFrame)
    VTEdit: TJvComboEdit;
    btReset: TVDTButton;
    btNew: TVDTButton;
    btEdit: TVDTButton;
    procedure btResetClick(Sender: TObject);
    procedure btNewClick(Sender: TObject);
    procedure btEditClick(Sender: TObject);
  private

    FAfterEdit: TNotifyEvent;
    FAfterAppend: TNotifyEvent;
    FParentValue: TGUID;
    function GetMode: TVirtualMode;
    function GetCurrentValue: TGUID;
    function GetCanCreate: Boolean;
    procedure SetCanCreate(const Value: Boolean);
    function GetCanEdit: Boolean;
    procedure SetCanEdit(const Value: Boolean);
    procedure SetMode(const Value: TVirtualMode);
    procedure SetCurrentValue(const Value: TGUID);
    procedure InternalValueChanged(Sender: TObject);
    procedure SetParentValue(const Value: TGUID);
    procedure RefreshFiltre;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Mode: TVirtualMode read GetMode write SetMode;
    property CurrentValue: TGUID read GetCurrentValue write SetCurrentValue;
    property ParentValue: TGUID read FParentValue write SetParentValue;
    property AfterEdit: TNotifyEvent read FAfterEdit write FAfterEdit;
    property AfterAppend: TNotifyEvent read FAfterAppend write FAfterAppend;

    property CanCreate: Boolean read GetCanCreate write SetCanCreate;
    property CanEdit: Boolean read GetCanEdit write SetCanEdit;
  end;

implementation


{$R *.dfm}

uses
  Commun, Proc_Gestions;

constructor TframVTEdit.Create(AOwner: TComponent);
begin
  inherited;
  FParentValue := GUID_NULL;
  VTEdit.InternalValueChanged := InternalValueChanged;
end;

procedure TframVTEdit.RefreshFiltre;
begin
  with VTEdit.PopupWindow.TreeView do begin
    if not IsEqualGUID(ParentValue, GUID_NULL) then
      case Mode of
        vmCollections: Filtre := 'id_editeur = ' + QuotedStr(GUIDToString(ParentValue));
        else
          Filtre := '';
      end
    else
      Filtre := '';
    UseFiltre := Filtre <> '';
  end;
end;

procedure callbackAfterEdit(Data: Pointer);
begin
  TframVTEdit(Data).VTEdit.CurrentValue := TframVTEdit(Data).VTEdit.PopupWindow.TreeView.CurrentValue;
  if Assigned(TframVTEdit(Data).FAfterEdit) then
    TframVTEdit(Data).FAfterEdit(TframVTEdit(Data));
end;

procedure TframVTEdit.btEditClick(Sender: TObject);
var
  VT: TVirtualStringTree;
begin
  VT := VTEdit.PopupWindow.TreeView;
  case Mode of
    vmAlbums,
    vmAlbumsAnnee,
    vmAlbumsCollection,
    vmAlbumsEditeur,
    vmAlbumsGenre,
    vmAlbumsSerie:
      Historique.AddWaiting(fcGestionModif, @callbackAfterEdit, Self, @ModifierAlbums, VT, '');
    vmAchatsAlbumsEditeur:
      Historique.AddWaiting(fcGestionModif, @callbackAfterEdit, Self, @ModifierAchatsAlbum, VT, '');
    vmCollections:
      Historique.AddWaiting(fcGestionModif, @callbackAfterEdit, Self, @ModifierCollections, VT, '');
    vmEditeurs:
      Historique.AddWaiting(fcGestionModif, @callbackAfterEdit, Self, @ModifierEditeurs, VT, '');
    vmEmprunteurs:
      Historique.AddWaiting(fcGestionModif, @callbackAfterEdit, Self, @ModifierEmprunteurs, VT, '');
    vmGenres:
      Historique.AddWaiting(fcGestionModif, @callbackAfterEdit, Self, @ModifierGenres, VT, '');
    vmPersonnes:
      Historique.AddWaiting(fcGestionModif, @callbackAfterEdit, Self, @ModifierAuteurs, VT, '');
    vmSeries:
      Historique.AddWaiting(fcGestionModif, @callbackAfterEdit, Self, @ModifierSeries, VT, '');
    vmParaBDSerie:
      Historique.AddWaiting(fcGestionModif, @callbackAfterEdit, Self, @ModifierParaBD, VT, '');
    else
      Exit;
  end;
end;


procedure callbackAfterAppend(Data: Pointer);
begin
  TframVTEdit(Data).VTEdit.CurrentValue := TframVTEdit(Data).VTEdit.PopupWindow.TreeView.CurrentValue;
  if Assigned(TframVTEdit(Data).FAfterAppend) then
    TframVTEdit(Data).FAfterAppend(TframVTEdit(Data));
end;

procedure TframVTEdit.btNewClick(Sender: TObject);
var
  VT: TVirtualStringTree;
begin
  VT := VTEdit.PopupWindow.TreeView;
  case Mode of
    vmAlbums,
    vmAlbumsAnnee,
    vmAlbumsCollection,
    vmAlbumsEditeur,
    vmAlbumsGenre,
    vmAlbumsSerie:
      Historique.AddWaiting(fcGestionAjout, @callbackAfterAppend, Self, @AjouterAlbums, VT, VTEdit.Text);
    vmAchatsAlbumsEditeur:
      Historique.AddWaiting(fcGestionAjout, @callbackAfterAppend, Self, @AjouterAchatsAlbum, VT, VTEdit.Text);
    vmCollections:
      if IsEqualGUID(FParentValue, GUID_NULL) then
        Historique.AddWaiting(fcGestionAjout, @callbackAfterAppend, Self, @AjouterCollections, VT, VTEdit.Text)
      else
        Historique.AddWaiting(fcGestionAjout, @callbackAfterAppend, Self, @AjouterCollections2, VT, FParentValue, VTEdit.Text);
    vmEditeurs:
      Historique.AddWaiting(fcGestionAjout, @callbackAfterAppend, Self, @AjouterEditeurs, VT, VTEdit.Text);
    vmEmprunteurs:
      Historique.AddWaiting(fcGestionAjout, @callbackAfterAppend, Self, @AjouterEmprunteurs, VT, VTEdit.Text);
    vmGenres:
      Historique.AddWaiting(fcGestionAjout, @callbackAfterAppend, Self, @AjouterGenres, VT, VTEdit.Text);
    vmPersonnes:
      Historique.AddWaiting(fcGestionAjout, @callbackAfterAppend, Self, @AjouterAuteurs, VT, VTEdit.Text);
    vmSeries:
      Historique.AddWaiting(fcGestionAjout, @callbackAfterAppend, Self, @AjouterSeries, VT, VTEdit.Text);
    vmParaBDSerie:
      Historique.AddWaiting(fcGestionAjout, @callbackAfterAppend, Self, @AjouterParaBD, VT, VTEdit.Text);
    else
      Exit;
  end;
end;

procedure TframVTEdit.btResetClick(Sender: TObject);
begin
  CurrentValue := GUID_NULL;
  VTEdit.CloseUp;
end;

function TframVTEdit.GetCanCreate: Boolean;
begin
  Result := btNew.Visible;
end;

function TframVTEdit.GetCanEdit: Boolean;
begin
  Result := btEdit.Visible;
end;

function TframVTEdit.GetCurrentValue: TGUID;
begin
  Result := VTEdit.CurrentValue;
end;

function TframVTEdit.GetMode: TVirtualMode;
begin
  Result := VTEdit.Mode;
end;

procedure TframVTEdit.InternalValueChanged(Sender: TObject);
begin
  btReset.Enabled := not IsEqualGUID(CurrentValue, GUID_NULL);
  btEdit.Enabled := not IsEqualGUID(CurrentValue, GUID_NULL);
end;

procedure TframVTEdit.SetCanCreate(const Value: Boolean);
begin
  if Value = CanCreate then
    Exit;
  btNew.Visible := Value;
  if Value then
  begin
    btEdit.Left := btEdit.Left - btNew.Width;

    btReset.Left := btReset.Left - btNew.Width;
    VTEdit.Width := VTEdit.Width - btNew.Width;
  end
  else
  begin
    btEdit.Left := btEdit.Left + btNew.Width;

    btReset.Left := btReset.Left + btNew.Width;
    VTEdit.Width := VTEdit.Width + btNew.Width;
  end;
end;

procedure TframVTEdit.SetCanEdit(const Value: Boolean);
begin
  if Value = CanEdit then
    Exit;
  btEdit.Visible := Value;
  if Value then
  begin
    btReset.Left := btReset.Left - btEdit.Width;
    VTEdit.Width := VTEdit.Width - btEdit.Width;
  end
  else
  begin
    btReset.Left := btReset.Left + btEdit.Width;
    VTEdit.Width := VTEdit.Width + btEdit.Width;
  end;
end;

procedure TframVTEdit.SetCurrentValue(const Value: TGUID);
begin
  VTEdit.CurrentValue := Value;
end;

procedure TframVTEdit.SetMode(const Value: TVirtualMode);
begin
  VTEdit.Mode := Value;
  RefreshFiltre;
end;

procedure TframVTEdit.SetParentValue(const Value: TGUID);
begin
  FParentValue := Value;
  RefreshFiltre;
end;

end.
