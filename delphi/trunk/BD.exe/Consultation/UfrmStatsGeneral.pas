unit UfrmStatsGeneral;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, EntitiesStats, UBdtForms;

type
  TfrmStatsGenerales = class(TbdtForm)
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    Spshtinter: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    fermer: TButton;
    nb_Albums: TLabel;
    AlbumsNB: TLabel;
    AlbumsVO: TLabel;
    AlbumsStock: TLabel;
    PrixMoy: TLabel;
    min_emprunteurs: TLabel;
    max_emprunteurs: TLabel;
    moy_emprunteurs: TLabel;
    min_empruntee: TLabel;
    max_empruntee: TLabel;
    moy_empruntee: TLabel;
    TotalEstime: TLabel;
    TotalConnu: TLabel;
    PrixMax: TLabel;
    PrixMin: TLabel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    Label1: TLabel;
    nb_Series: TLabel;
    Label9: TLabel;
    AlbumsIntegrales: TLabel;
    Label6: TLabel;
    AlbumsHorsSerie: TLabel;
    procedure listeExit(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function TStatsGeneralesCreate(AOwner: TComponent; Info: TStats): TfrmStatsGenerales;

implementation

uses CommonConst, Entities.Lite, Math, Divers, Commun;

{$R *.DFM}

function TStatsGeneralesCreate(AOwner: TComponent; Info: TStats): TFrmStatsGenerales;
var
  i: Integer;
begin
  Result := TFrmStatsGenerales.Create(AOwner);
  with Result do begin
    nb_Albums.Caption := IntToStr(Info.NbAlbums);
    nb_Series.Caption := IntToStr(Info.NbSeries);
    AlbumsNB.Caption := Format(FormatPourcent, [Info.NbAlbumsNB, MulDiv(Info.NbAlbumsNB, 100, Info.NbAlbums)]);
    AlbumsVO.Caption := Format(FormatPourcent, [Info.NbAlbumsVO, MulDiv(Info.NbAlbumsVO, 100, Info.NbAlbums)]);
    AlbumsStock.Caption := Format(FormatPourcent, [Info.NbAlbumsStock, MulDiv(Info.NbAlbumsStock, 100, Info.NbAlbums)]);
    AlbumsIntegrales.Caption := Format(FormatPourcent, [Info.NbAlbumsIntegrale, MulDiv(Info.NbAlbumsIntegrale, 100, Info.NbAlbums)]);
    AlbumsHorsSerie.Caption := Format(FormatPourcent, [Info.NbAlbumsHorsSerie, MulDiv(Info.NbAlbumsHorsSerie, 100, Info.NbAlbums)]);

    PrixMoy.Caption := BDCurrencyToStr(Info.PrixAlbumMoyen);

    PrixMax.Caption := BDCurrencyToStr(Info.PrixAlbumMaximun);
    PrixMin.Caption := BDCurrencyToStr(Info.PrixAlbumMinimun);
    TotalConnu.Caption := BDCurrencyToStr(Info.ValeurConnue);
    TotalEstime.Caption := BDCurrencyToStr(Info.ValeurEstimee);

    i := Max(totalestime.Left + totalestime.Width, totalconnu.Left + totalconnu.Width);
    PrixMoy.Left := i - PrixMoy.Width;
    totalestime.Left := i - totalestime.Width;
    totalconnu.Left := i - totalconnu.Width;
  end;
end;

procedure TfrmStatsGenerales.listeExit(Sender: TObject);
begin
  TListBox(Sender).ItemIndex := -1;
end;

end.
