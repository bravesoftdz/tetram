unit UframVTEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, VDTButton, StdCtrls, Mask, JvExMask,
  JvToolEdit, BDTK.GUI.Controls.VirtualTreeEdit, BDTK.GUI.Controls.VirtualTree, UHistorique, PngSpeedButton, BDTK.GUI.Forms.Main,
  Vcl.ExtCtrls;

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
  BD.Utils.StrUtils, Proc_Gestions;

constructor TframVTEdit.Create(AOwner: TComponent);
begin
  inherited;
  FParentValue := GUID_NULL;
  VTEdit.InternalValueChanged := InternalValueChanged;
end;

procedure TframVTEdit.RefreshFiltre;
var
  tv: TVirtualStringTree;
begin
  tv := VTEdit.PopupWindow.TreeView;
  if not IsEqualGUID(ParentValue, GUID_NULL) then
    case Mode of
      vmCollections:
        tv.Filtre := 'id_editeur = ' + QuotedStr(GUIDToString(ParentValue));
      vmUnivers:
        tv.Filtre := 'branche_univers not containing ' + QuotedStr('|' + GUIDToString(ParentValue) + '|');
      else
        tv.Filtre := '';
    end
  else
    tv.Filtre := '';
  tv.UseFiltre := tv.Filtre <> '';
end;

procedure callbackAfterEdit(Data: TObject);
var
  framVTEdit: TframVTEdit;
begin
  framVTEdit := Data as TframVTEdit;

  framVTEdit.VTEdit.CurrentValue := framVTEdit.VTEdit.PopupWindow.TreeView.CurrentValue;
  if Assigned(framVTEdit.FAfterEdit) then
    framVTEdit.FAfterEdit(framVTEdit);
end;

procedure TframVTEdit.btEditClick(Sender: TObject);
var
  VT: TVirtualStringTree;
begin
  VT := VTEdit.PopupWindow.TreeView;
  case Mode of
    vmAlbums, vmAlbumsAnnee, vmAlbumsCollection, vmAlbumsEditeur, vmAlbumsGenre, vmAlbumsSerie:
      Historique.AddWaiting(fcGestionModif, callbackAfterEdit, Self, @ModifierAlbums, VT, '');
    vmAchatsAlbumsEditeur:
      Historique.AddWaiting(fcGestionModif, callbackAfterEdit, Self, @ModifierAchatsAlbum, VT, '');
    vmCollections:
      Historique.AddWaiting(fcGestionModif, callbackAfterEdit, Self, @ModifierCollections, VT, '');
    vmEditeurs:
      Historique.AddWaiting(fcGestionModif, callbackAfterEdit, Self, @ModifierEditeurs, VT, '');
    vmUnivers:
      Historique.AddWaiting(fcGestionModif, callbackAfterEdit, Self, @ModifierUnivers, VT, '');
    vmGenres:
      Historique.AddWaiting(fcGestionModif, callbackAfterEdit, Self, @ModifierGenres, VT, '');
    vmPersonnes:
      Historique.AddWaiting(fcGestionModif, callbackAfterEdit, Self, @ModifierAuteurs, VT, '');
    vmSeries:
      Historique.AddWaiting(fcGestionModif, callbackAfterEdit, Self, @ModifierSeries, VT, '');
    vmParaBDSerie:
      Historique.AddWaiting(fcGestionModif, callbackAfterEdit, Self, @ModifierParaBD, VT, '');
  else
    Exit;
  end;
end;

procedure callbackAfterAppend(Data: TObject);
var
  framVTEdit: TframVTEdit;
begin
  framVTEdit := Data as TframVTEdit;

  framVTEdit.VTEdit.CurrentValue := framVTEdit.VTEdit.PopupWindow.TreeView.CurrentValue;
  if Assigned(framVTEdit.FAfterAppend) then
    framVTEdit.FAfterAppend(framVTEdit);
end;

procedure TframVTEdit.btNewClick(Sender: TObject);
var
  VT: TVirtualStringTree;
  newText: string;
begin
  VT := VTEdit.PopupWindow.TreeView;
  if VTEdit.Text = '' then
    newText := VTEdit.LastSearch
  else
    newText := VTEdit.Text;
  case Mode of
    vmAlbums, vmAlbumsAnnee, vmAlbumsCollection, vmAlbumsEditeur, vmAlbumsGenre, vmAlbumsSerie:
      Historique.AddWaiting(fcGestionAjout, @callbackAfterAppend, Self, @AjouterAlbums, VT, newText);
    vmAchatsAlbumsEditeur:
      Historique.AddWaiting(fcGestionAjout, @callbackAfterAppend, Self, @AjouterAchatsAlbum, VT, newText);
    vmCollections:
      if IsEqualGUID(FParentValue, GUID_NULL) then
        Historique.AddWaiting(fcGestionAjout, @callbackAfterAppend, Self, @AjouterCollections, VT, newText)
      else
        Historique.AddWaiting(fcGestionAjout, @callbackAfterAppend, Self, @AjouterCollections2, VT, FParentValue, newText);
    vmEditeurs:
      Historique.AddWaiting(fcGestionAjout, @callbackAfterAppend, Self, @AjouterEditeurs, VT, newText);
    vmUnivers:
      Historique.AddWaiting(fcGestionAjout, @callbackAfterAppend, Self, @AjouterUnivers, VT, newText);
    vmGenres:
      Historique.AddWaiting(fcGestionAjout, @callbackAfterAppend, Self, @AjouterGenres, VT, newText);
    vmPersonnes:
      Historique.AddWaiting(fcGestionAjout, @callbackAfterAppend, Self, @AjouterAuteurs, VT, newText);
    vmSeries:
      Historique.AddWaiting(fcGestionAjout, @callbackAfterAppend, Self, @AjouterSeries, VT, newText);
    vmParaBDSerie:
      Historique.AddWaiting(fcGestionAjout, @callbackAfterAppend, Self, @AjouterParaBD, VT, newText);
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
  if Mode <> Value then
  begin
    VTEdit.Mode := Value;
    RefreshFiltre;
  end;
end;

procedure TframVTEdit.SetParentValue(const Value: TGUID);
begin
  FParentValue := Value;
  RefreshFiltre;
end;

end.
