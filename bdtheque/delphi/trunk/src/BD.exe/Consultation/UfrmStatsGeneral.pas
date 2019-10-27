unit UfrmStatsGeneral;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, BDTK.Entities.Stats, BD.GUI.Forms;

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
    TotalEstimeMoyenne: TLabel;
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
    Label7: TLabel;
    PrixMedian: TLabel;
    Label10: TLabel;
    TotalEstimeMediane: TLabel;
    Label14: TLabel;
    TotalEstimeRF: TLabel;
    Label16: TLabel;
    procedure listeExit(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function TStatsGeneralesCreate(AOwner: TComponent; Info: TStats): TfrmStatsGenerales;

implementation

uses
  BD.Common, BD.Entities.Lite, System.Math, Divers, BD.Utils.StrUtils;

{$R *.DFM}

function TStatsGeneralesCreate(AOwner: TComponent; Info: TStats): TFrmStatsGenerales;
var
  maxWidth: Integer;
begin
  Result := TFrmStatsGenerales.Create(AOwner);

  Result.nb_Albums.Caption := IntToStr(Info.NbAlbums);
  Result.nb_Series.Caption := IntToStr(Info.NbSeries);
  Result.AlbumsNB.Caption := Format(TGlobalVar.FormatPourcent, [Info.NbAlbumsNB, MulDiv(Info.NbAlbumsNB, 100, Info.NbAlbums)]);
  Result.AlbumsVO.Caption := Format(TGlobalVar.FormatPourcent, [Info.NbAlbumsVO, MulDiv(Info.NbAlbumsVO, 100, Info.NbAlbums)]);
  Result.AlbumsStock.Caption := Format(TGlobalVar.FormatPourcent, [Info.NbAlbumsStock, MulDiv(Info.NbAlbumsStock, 100, Info.NbAlbums)]);
  Result.AlbumsIntegrales.Caption := Format(TGlobalVar.FormatPourcent, [Info.NbAlbumsIntegrale, MulDiv(Info.NbAlbumsIntegrale, 100, Info.NbAlbums)]);
  Result.AlbumsHorsSerie.Caption := Format(TGlobalVar.FormatPourcent, [Info.NbAlbumsHorsSerie, MulDiv(Info.NbAlbumsHorsSerie, 100, Info.NbAlbums)]);

  Result.PrixMoy.Caption := BDCurrencyToStr(Info.PrixAlbumMoyenMoyenne);
  Result.PrixMedian.Caption := BDCurrencyToStr(Info.PrixAlbumMoyenMediane);

  Result.PrixMax.Caption := BDCurrencyToStr(Info.PrixAlbumMaximun);
  Result.PrixMin.Caption := BDCurrencyToStr(Info.PrixAlbumMinimun);
  Result.TotalConnu.Caption := BDCurrencyToStr(Info.ValeurConnue);
  Result.TotalEstimeMoyenne.Caption := BDCurrencyToStr(Info.ValeurEstimeeMoyenne);
  Result.TotalEstimeMediane.Caption := BDCurrencyToStr(Info.ValeurEstimeeMediane);
  Result.TotalEstimeRF.Caption := BDCurrencyToStr(Info.ValeurEstimeeRegression);

  maxWidth := Result.TotalConnu.Left + Result.TotalConnu.Width;
  maxWidth := Max(maxWidth, Result.PrixMoy.Left + Result.PrixMoy.Width);
  maxWidth := Max(maxWidth, Result.PrixMedian.Left + Result.PrixMedian.Width);
  maxWidth := Max(maxWidth, Result.TotalEstimeMoyenne.Left + Result.TotalEstimeMoyenne.Width);
  maxWidth := Max(maxWidth, Result.TotalEstimeMediane.Left + Result.TotalEstimeMediane.Width);
  maxWidth := Max(maxWidth, Result.TotalEstimeRF.Left + Result.TotalEstimeRF.Width);
  Result.PrixMoy.Left := maxWidth - Result.PrixMoy.Width;
  Result.PrixMedian.Left := maxWidth - Result.PrixMedian.Width;
  Result.TotalEstimeMoyenne.Left := maxWidth - Result.TotalEstimeMoyenne.Width;
  Result.Label10.Left := Result.TotalEstimeMoyenne.Left + Result.TotalEstimeMoyenne.Width + 8;
  Result.TotalEstimeMediane.Left := maxWidth - Result.TotalEstimeMediane.Width;
  Result.Label14.Left := Result.TotalEstimeMediane.Left + Result.TotalEstimeMediane.Width + 8;
  Result.TotalEstimeRF.Left := maxWidth - Result.TotalEstimeRF.Width;
  Result.Label16.Left := Result.TotalEstimeRF.Left + Result.TotalEstimeRF.Width + 8;
  Result.TotalConnu.Left := maxWidth - Result.TotalConnu.Width;
end;

procedure TfrmStatsGenerales.listeExit(Sender: TObject);
begin
  TListBox(Sender).ItemIndex := -1;
end;

end.
