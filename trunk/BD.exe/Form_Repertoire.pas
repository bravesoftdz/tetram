unit Form_Repertoire;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Db, StdCtrls, DBCtrls, Menus, Buttons, ComCtrls, ExtCtrls,
  ScanEdit, Main, VDTButton, Commun, VirtualTrees, ActnList, VirtualTree, jpeg, DBEditLabeled, ComboCheck,
  Frame_RechercheRapide;

type
  TFrmRepertoire = class(TForm)
    PageRep: TPageControl;
    TabEmprunteurs: TTabSheet;
    TabAlbums: TTabSheet;
    vstAlbums: TVirtualStringTree;
    vstEmprunteurs: TVirtualStringTree;
    LightComboCheck1: TLightComboCheck;
    Label1: TLabel;
    TabAuteurs: TTabSheet;
    vstAuteurs: TVirtualStringTree;
    TabSeries: TTabSheet;
    TabParaBD: TTabSheet;
    vstParaBD: TVirtualStringTree;
    vstSeries: TVirtualStringTree;
    FrameRechercheRapideAlbums: TFrameRechercheRapide;
    FrameRechercheRapideEmprunteurs: TFrameRechercheRapide;
    FrameRechercheRapideAuteurs: TFrameRechercheRapide;
    FrameRechercheRapideSeries: TFrameRechercheRapide;
    FrameRechercheRapideParaBD: TFrameRechercheRapide;
    procedure FormCreate(Sender: TObject);
    procedure vstAlbumsDblClick(Sender: TObject);
    procedure LightComboCheck1Change(Sender: TObject);
    procedure FrameRechercheRapideedSearchKeyPress(Sender: TObject;
      var Key: Char);
  private
    { Déclarations privées }
    procedure ChangeAlbumMode(Mode: TVirtualMode);
  public
    { Déclarations publiques }
  end;

var
  FrmRepertoire: TFrmRepertoire;

implementation

uses
  MAJ, CommonConst, IniFiles, Procedures, UHistorique;

{$R *.DFM}

const
  PosAlbums = 0;
  PosSeries = 1;
  PosAuteurs = 2;
  PosParaBD = 3;
  PosEmprunteurs = 4;

procedure TFrmRepertoire.FormCreate(Sender: TObject);
begin
  Mode_en_cours := mdConsult;
  PrepareLV(Self);
  TabAlbums.PageIndex := PosAlbums;
  TabEmprunteurs.PageIndex := PosEmprunteurs;
  TabAuteurs.PageIndex := PosAuteurs;
  TabSeries.PageIndex := PosSeries;
  TabParaBD.PageIndex := PosParaBD;

  ChargeImage(vstAlbums.Background, 'FONDVT');
  ChargeImage(vstEmprunteurs.Background, 'FONDVT');
  ChargeImage(vstAuteurs.Background, 'FONDVT');
  ChargeImage(vstSeries.Background, 'FONDVT');
  ChargeImage(vstParaBD.Background, 'FONDVT');

  FrameRechercheRapideAlbums.VirtualTreeView := vstAlbums;
  FrameRechercheRapideAlbums.ShowNewButton := False;
  FrameRechercheRapideEmprunteurs.VirtualTreeView := vstEmprunteurs;
  FrameRechercheRapideEmprunteurs.ShowNewButton := False;
  FrameRechercheRapideAuteurs.VirtualTreeView := vstAuteurs;
  FrameRechercheRapideAuteurs.ShowNewButton := False;
  FrameRechercheRapideSeries.VirtualTreeView := vstSeries;
  FrameRechercheRapideSeries.ShowNewButton := False;
  FrameRechercheRapideParaBD.VirtualTreeView := vstParaBD;
  FrameRechercheRapideParaBD.ShowNewButton := False;

  PageRep.ActivePageIndex := 0;

  vstAlbums.Mode := vmNone;
  with TIniFile.Create(FichierIni) do try
    LightComboCheck1.OnChange := nil;
    LightComboCheck1.Value := -1;
    LightComboCheck1.OnChange := LightComboCheck1Change;
    LightComboCheck1.Value := ReadInteger('Options', 'GroupBy', 1);
  finally
    Free;
  end;
  vstEmprunteurs.Mode := vmEmprunteurs;
  vstAuteurs.Mode := vmPersonnes;
  vstSeries.Mode := vmSeries;
  vstParaBD.Mode := vmParaBDSerie;
end;

procedure TFrmRepertoire.vstAlbumsDblClick(Sender: TObject);
begin
  case PageRep.ActivePageIndex of
    PosAlbums: with vstAlbums do
        if GetNodeLevel(FocusedNode) > 0 then Historique.AddWaiting(fcAlbum, CurrentValue);
    PosEmprunteurs: with vstEmprunteurs do
        if GetNodeLevel(FocusedNode) > 0 then Historique.AddWaiting(fcEmprunteur, CurrentValue);
    PosAuteurs: with vstAuteurs do
        if GetNodeLevel(FocusedNode) > 0 then Historique.AddWaiting(fcAuteur, CurrentValue);
    PosSeries: with vstSeries do
        if GetNodeLevel(FocusedNode) > 0 then Historique.AddWaiting(fcSerie, CurrentValue);
    PosParaBD: with vstParaBD do
        if GetNodeLevel(FocusedNode) > 0 then Historique.AddWaiting(fcParaBD, CurrentValue);
  end;
end;

procedure TFrmRepertoire.ChangeAlbumMode(Mode: TVirtualMode);
var
  i: TGUID;
const
  FirstTime: Boolean = True;
begin
  if (vstAlbums.Mode <> Mode) or FirstTime then begin
    i := vstAlbums.CurrentValue;
    vstAlbums.Mode := Mode;
    vstAlbums.CurrentValue := i;
  end;
  FirstTime := False;
end;

procedure TFrmRepertoire.LightComboCheck1Change(Sender: TObject);
const
  NewMode: array[0..5] of TVirtualMode = (vmAlbums, vmAlbumsSerie, vmAlbumsEditeur, vmAlbumsGenre, vmAlbumsAnnee, vmAlbumsCollection);
begin
  ChangeAlbumMode(NewMode[LightComboCheck1.Value]);
  with TIniFile.Create(FichierIni) do try
    WriteInteger('Options', 'GroupBy', LightComboCheck1.Value);
  finally
    Free;
  end
end;

procedure TFrmRepertoire.FrameRechercheRapideedSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    Key := #0;
    TFrameRechercheRapide(TWinControl(Sender).Parent).VirtualTreeView.OnDblClick(nil);
  end;
end;

end.

