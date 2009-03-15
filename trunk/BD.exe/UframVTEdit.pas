unit UframVTEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, VDTButton, CRFurtif, StdCtrls, Mask, JvExMask,
  JvToolEdit, UVirtualTreeEdit, VirtualTree, UHistorique;

type
  TframVTEdit = class(TFrame)
    VTEdit: TJvComboEdit;
    btReset: TVDTButton;
    btNew: TVDTButton;
    btEdit: TVDTButton;
    procedure btResetClick(Sender: TObject);
    procedure btNewClick(Sender: TObject);
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
    procedure TriggerEdit(TypeAction: TActionConsultation);
    procedure InternalValueChanged(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Mode: TVirtualMode read GetMode write SetMode;
    property CurrentValue: TGUID read GetCurrentValue write SetCurrentValue;
    property ParentValue: TGUID read FParentValue write FParentValue;
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

procedure TframVTEdit.btNewClick(Sender: TObject);
begin
  TriggerEdit(fcGestionAjout);
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
end;

procedure TframVTEdit.TriggerEdit(TypeAction: TActionConsultation);
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
      Historique.AddWaiting(TypeAction, nil, nil, @AjouterAlbums, VT, '');
    vmAchatsAlbumsEditeur:
      Historique.AddWaiting(TypeAction, nil, nil, @AjouterAchatsAlbum, VT, '');
    vmCollections:
      if IsEqualGUID(FParentValue, GUID_NULL) then
        Historique.AddWaiting(TypeAction, nil, nil, @AjouterCollections, VT, '')
      else
        Historique.AddWaiting(TypeAction, nil, nil, @AjouterCollections2, VT, FParentValue, '');
    vmEditeurs:
      Historique.AddWaiting(TypeAction, nil, nil, @AjouterEditeurs, VT, '');
    vmEmprunteurs:
      Historique.AddWaiting(TypeAction, nil, nil, @AjouterEmprunteurs, VT, '');
    vmGenres:
      Historique.AddWaiting(TypeAction, nil, nil, @AjouterGenres, VT, '');
    vmPersonnes:
      Historique.AddWaiting(TypeAction, nil, nil, @AjouterAuteurs, VT, '');
    vmSeries:
      Historique.AddWaiting(TypeAction, nil, nil, @AjouterSeries, VT, '');
    vmParaBDSerie:
      Historique.AddWaiting(TypeAction, nil, nil, @AjouterParaBD, VT, '');
    else
      Exit;
  end;

  if TypeAction = fcGestionAjout then
  begin
    if Assigned(FAfterAppend) then
      FAfterAppend(Self);
  end
  else
  begin
    if Assigned(FAfterEdit) then
      FAfterEdit(Self);
  end;
end;

end.
