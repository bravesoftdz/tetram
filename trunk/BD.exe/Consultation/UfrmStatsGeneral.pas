unit UfrmStatsGeneral;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, LoadComplet, UBdtForms;

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
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
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
    nb_emprunteurs: TLabel;
    nb_empruntee: TLabel;
    listmaxemprunteurs: TListBox;
    listminemprunteurs: TListBox;
    listmaxempruntee: TListBox;
    listminempruntee: TListBox;
    PrixMax: TLabel;
    PrixMin: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    Bevel7: TBevel;
    Bevel8: TBevel;
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

uses CommonConst, TypeRec, Math, Divers;

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

    PrixMoy.Caption := FormatCurr(FormatMonnaie, Info.PrixAlbumMoyen);

    PrixMax.Caption := FormatCurr(FormatMonnaie, Info.PrixAlbumMaximun);
    PrixMin.Caption := FormatCurr(FormatMonnaie, Info.PrixAlbumMinimun);
    totalconnu.Caption := FormatCurr(FormatMonnaie, Info.ValeurConnue);
    totalestime.Caption := FormatCurr(FormatMonnaie, Info.ValeurEstimee);

    i := Max(totalestime.Left + totalestime.Width, totalconnu.Left + totalconnu.Width);
    PrixMoy.Left := i - PrixMoy.Width;
    totalestime.Left := i - totalestime.Width;
    totalconnu.Left := i - totalconnu.Width;

    nb_emprunteurs.Caption := IntToStr(Info.NbEmprunteurs);
    moy_emprunteurs.Caption := IntToStr(Info.MoyEmprunteurs);
    max_emprunteurs.Caption := IntToStr(Info.MaxEmprunteurs);
    for i := 0 to Info.ListEmprunteursMax.Count - 1 do
      listmaxemprunteurs.Items.Add(TEmprunteur(Info.ListEmprunteursMax[i]).ChaineAffichage);
    min_emprunteurs.Caption := IntToStr(Info.MinEmprunteurs);
    for i := 0 to Info.ListEmprunteursMin.Count - 1 do
      listminemprunteurs.Items.Add(TEmprunteur(Info.ListEmprunteursMin[i]).ChaineAffichage);

    nb_empruntee.Caption := IntToStr(Info.NbEmpruntes);
    moy_empruntee.Caption := IntToStr(Info.MoyEmpruntes);
    max_empruntee.Caption := IntToStr(Info.MaxEmpruntes);
    for i := 0 to Info.ListAlbumsMax.Count - 1 do
      listmaxempruntee.Items.Add(TAlbum(Info.ListAlbumsMax[i]).ChaineAffichage);
    min_empruntee.Caption := IntToStr(Info.MinEmpruntes);
    for i := 0 to Info.ListAlbumsMin.Count - 1 do
      listminempruntee.Items.Add(TAlbum(Info.ListAlbumsMin[i]).ChaineAffichage);
  end;
end;

procedure TfrmStatsGenerales.listeExit(Sender: TObject);
begin
  TListBox(Sender).ItemIndex := -1;
end;

end.
