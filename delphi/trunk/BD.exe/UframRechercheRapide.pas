unit UframRechercheRapide;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTree, Buttons, VDTButton, StdCtrls, EditLabeled,
  PngSpeedButton;

type
  TOnSearchEvent = procedure(Sender: TObject; NextSearch: Boolean) of object;
  TOnNewEvent = procedure(Sender: TObject) of object;

  TframRechercheRapide = class(TFrame)
    edSearch: TEditLabeled;
    btNext: TVDTButton;
    btNew: TVDTButton;
    procedure edSearchChange(Sender: TObject);
    procedure edSearchKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btNewClick(Sender: TObject);
  private
    FVirtualTreeView: TVirtualStringTree;
    FOnSearch: TOnSearchEvent;
    FOnNew: TOnNewEvent;
    procedure SetVirtualTreeView(const Value: TVirtualStringTree);
    procedure SetShowNewButton(const Value: Boolean);
    function GetShowNewButton: Boolean;
    procedure DoSearch(NextSearch: Boolean);
  protected
    procedure DoOnSearch(NextSearch: Boolean);
    procedure DoOnNew;
    procedure SetEnabled(Value: Boolean); override;
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent); override;
    property VirtualTreeView: TVirtualStringTree read FVirtualTreeView write SetVirtualTreeView;
    property ShowNewButton: Boolean read GetShowNewButton write SetShowNewButton;
    property OnSearch: TOnSearchEvent read FOnSearch write FOnSearch;
    property OnNew: TOnNewEvent read FOnNew write FOnNew;
  end;

implementation

uses
  Proc_Gestions, UHistorique;

{$R *.dfm}

constructor TframRechercheRapide.Create(AOwner: TComponent);
begin
  inherited;
  ShowNewButton := True;
end;

procedure TframRechercheRapide.DoOnNew;
begin
  if Assigned(FOnNew) then FOnNew(Self);
end;

procedure TframRechercheRapide.DoOnSearch(NextSearch: Boolean);
begin
  if Assigned(FOnSearch) then FOnSearch(Self, NextSearch);
end;

procedure TframRechercheRapide.DoSearch(NextSearch: Boolean);
begin
  if Assigned(FVirtualTreeView) then
  begin
    FVirtualTreeView.Find(edSearch.Text, NextSearch);
    DoOnSearch(NextSearch);
  end;
end;

procedure TframRechercheRapide.edSearchChange(Sender: TObject);
begin
  DoSearch(Sender = btNext);
end;

procedure TframRechercheRapide.edSearchKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F3 then DoSearch(True);
end;

function TframRechercheRapide.GetShowNewButton: Boolean;
begin
  Result := btNew.Visible;
end;

procedure TframRechercheRapide.SetShowNewButton(const Value: Boolean);
begin
  btNew.Visible := Value;
  if Value then
  begin
    btNew.Left := Self.Width - btNew.Width;
    btNext.Left := btNew.Left - btNext.Width - 1;
    edSearch.Width := btNext.Left - 1;
  end
  else
  begin
    btNext.Left := Self.Width - btNext.Width;
    edSearch.Width := btNext.Left - 1;
  end;
end;

procedure TframRechercheRapide.SetVirtualTreeView(const Value: TVirtualStringTree);
begin
  FVirtualTreeView := Value;
  if Assigned(FVirtualTreeView) then
  begin
    try
      edSearch.LinkControls.Add(btNext);
    except
      // y est peut-être déjà
    end;
    try
      edSearch.LinkControls.Add(btNew);
    except
      // y est peut-être déjà
    end;
    FVirtualTreeView.LinkControls.Assign(edSearch.LinkControls);
  end;
  edSearch.Enabled := Assigned(FVirtualTreeView);
  btNext.Enabled := edSearch.Enabled;
  btNew.Enabled := edSearch.Enabled;
end;

procedure TframRechercheRapide.btNewClick(Sender: TObject);
begin
  if Assigned(FOnNew) then
    FOnNew(Self)
  else if Assigned(FVirtualTreeView) then
    case FVirtualTreeView.Mode of
      vmNone: ;
      vmEditeurs: Historique.AddWaiting(fcGestionAjout, nil, nil, @AjouterEditeurs, FVirtualTreeView, edSearch.Text);
      vmCollections: Historique.AddWaiting(fcGestionAjout, nil, nil, @AjouterCollections, FVirtualTreeView, edSearch.Text);
      vmPersonnes: Historique.AddWaiting(fcGestionAjout, nil, nil, @AjouterAuteurs, FVirtualTreeView, edSearch.Text);
      vmSeries: Historique.AddWaiting(fcGestionAjout, nil, nil, @AjouterSeries, FVirtualTreeView, edSearch.Text);
      vmAlbums,
        vmAlbumsAnnee,
        vmAlbumsCollection,
        vmAlbumsEditeur,
        vmAlbumsGenre,
        vmAlbumsSerie: Historique.AddWaiting(fcGestionAjout, nil, nil, @AjouterAlbums, FVirtualTreeView, edSearch.Text);
      vmGenres: Historique.AddWaiting(fcGestionAjout, nil, nil, @AjouterGenres, FVirtualTreeView, edSearch.Text);
      vmParaBDSerie: Historique.AddWaiting(fcGestionAjout, nil, nil, @AjouterParaBD, FVirtualTreeView, edSearch.Text);
      else
        Assert(True, 'Mode non prévu dans l''ajout')
    end;
end;

procedure TframRechercheRapide.SetEnabled(Value: Boolean);
begin
  inherited;
  edSearch.Enabled := Value;
  btNext.Enabled := Value;
  btNew.Enabled := Value;
end;

end.

