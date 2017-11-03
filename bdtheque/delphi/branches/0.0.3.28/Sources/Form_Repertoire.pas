unit Form_Repertoire;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Db, StdCtrls, DBCtrls, Menus, Buttons, ComCtrls, ExtCtrls,
  ScanEdit, Main, VDTButton, Commun, VirtualTrees, ActnList, VirtualTree, jpeg, DBEditLabeled, ComboCheck;

type
  TFrmRepertoire = class(TForm)
    PageRep: TPageControl;
    TabEmprunteurs: TTabSheet;
    TabAlbums: TTabSheet;
    vstAlbums: TVirtualStringTree;
    vstEmprunteurs: TVirtualStringTree;
    LightComboCheck1: TLightComboCheck;
    Label1: TLabel;
    ScanEditAlbum: TEdit;
    VDTButton1: TVDTButton;
    ScanEditEmprunteur: TEdit;
    VDTButton2: TVDTButton;
    TabAuteurs: TTabSheet;
    vstAuteurs: TVirtualStringTree;
    Edit1: TEdit;
    VDTButton3: TVDTButton;
    procedure FormCreate(Sender: TObject);
    procedure VDTButton1Click(Sender: TObject);
    procedure VDTButton2Click(Sender: TObject);
    procedure vstAlbumsDblClick(Sender: TObject);
    procedure LightComboCheck1Change(Sender: TObject);
    procedure VDTButton3Click(Sender: TObject);
    procedure ScanEditAlbumKeyPress(Sender: TObject; var Key: Char);
    procedure ScanEditEmprunteurKeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
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
  PosAuteurs = 1;
  PosEmprunteurs = 2;

procedure TFrmRepertoire.FormCreate(Sender: TObject);
begin
  Mode_en_cours := mdConsult;
  PrepareLV(Self);
  TabAlbums.PageIndex := PosAlbums;
  TabEmprunteurs.PageIndex := PosEmprunteurs;
  TabAuteurs.PageIndex := PosAuteurs;

  ChargeImage(vstAlbums.Background, 'FONDVT');
  ChargeImage(vstEmprunteurs.Background, 'FONDVT');
  ChargeImage(vstAuteurs.Background, 'FONDVT');
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
end;

procedure TFrmRepertoire.VDTButton1Click(Sender: TObject);
begin
  vstAlbums.Find(ScanEditAlbum.Text, Sender = VDTButton1);
end;

procedure TFrmRepertoire.VDTButton2Click(Sender: TObject);
begin
  vstEmprunteurs.Find(ScanEditEmprunteur.Text, Sender = VDTButton2);
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
  end;
end;

procedure TFrmRepertoire.ChangeAlbumMode(Mode: TVirtualMode);
var
  i: Integer;
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

procedure TFrmRepertoire.VDTButton3Click(Sender: TObject);
begin
  vstAuteurs.Find(Edit1.Text, Sender = VDTButton3);
end;

procedure TFrmRepertoire.ScanEditAlbumKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    Key := #0;
    vstAlbums.OnDblClick(vstAlbums);
  end;
end;

procedure TFrmRepertoire.ScanEditEmprunteurKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    Key := #0;
    vstEmprunteurs.OnDblClick(nil);
  end;
end;

procedure TFrmRepertoire.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    Key := #0;
    vstEmprunteurs.OnDblClick(nil);
  end;
end;

end.
