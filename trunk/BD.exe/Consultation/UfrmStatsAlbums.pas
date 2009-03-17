unit UfrmStatsAlbums;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, LoadComplet, UBdtForms;

type
  TfrmStatsAlbums = class(TbdtForm)
    Label7: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    genre: TListBox;
    listmaxempruntee: TListBox;
    listminempruntee: TListBox;
    nb_empruntee: TLabel;
    max_empruntee: TLabel;
    moy_empruntee: TLabel;
    min_empruntee: TLabel;
    minannee: TLabel;
    maxannee: TLabel;
    fermer: TButton;
    Bevel5: TBevel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel6: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    nb_Albums: TLabel;
    AlbumsNB: TLabel;
    AlbumsVO: TLabel;
    AlbumsStock: TLabel;
    Label1: TLabel;
    nb_Series: TLabel;
    Label9: TLabel;
    AlbumsIntegrales: TLabel;
    Label6: TLabel;
    AlbumsHorsSerie: TLabel;
    procedure listeExit(Sender: TObject);
    procedure genreDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function TStatsAlbumsCreate(AOwner: TComponent; Info: TStats): TfrmStatsAlbums;

implementation

uses CommonConst, TypeRec, Divers;

{$R *.DFM}

procedure TfrmStatsAlbums.listeExit(Sender: TObject);
begin
  TListBox(Sender).ItemIndex := -1;
end;

function TStatsAlbumsCreate(AOwner: TComponent; Info: TStats): TFrmStatsAlbums;
var
  i: Integer;
begin
  Result := TFrmStatsAlbums.Create(AOwner);
  with Result do begin
    nb_Albums.Caption := IntToStr(Info.NbAlbums);
    nb_Series.Caption := IntToStr(Info.NbSeries);
    AlbumsNB.Caption := Format(FormatPourcent, [Info.NbAlbumsNB, MulDiv(Info.NbAlbumsNB, 100, Info.NbAlbums)]);
    AlbumsVO.Caption := Format(FormatPourcent, [Info.NbAlbumsVO, MulDiv(Info.NbAlbumsVO, 100, Info.NbAlbums)]);
    AlbumsStock.Caption := Format(FormatPourcent, [Info.NbAlbumsStock, MulDiv(Info.NbAlbumsStock, 100, Info.NbAlbums)]);
    AlbumsIntegrales.Caption := Format(FormatPourcent, [Info.NbAlbumsIntegrale, MulDiv(Info.NbAlbumsIntegrale, 100, Info.NbAlbums)]);
    AlbumsHorsSerie.Caption := Format(FormatPourcent, [Info.NbAlbumsHorsSerie, MulDiv(Info.NbAlbumsHorsSerie, 100, Info.NbAlbums)]);
    minannee.Caption := IntToStr(Info.MinAnnee);
    maxannee.Caption := IntToStr(Info.MaxAnnee);

    for i := 0 to Info.ListGenre.Count - 1 do
      with TGenre(Info.ListGenre[i]) do
        Result.genre.Items.Add(Format('%s - ' + FormatPourcent, [ChaineAffichage, Quantite, MulDiv(Quantite, 100, Info.NbAlbums)]));

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

procedure TfrmStatsAlbums.genreDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  txt: string;
begin
  txt := (Control as TListBox).Items[Index];
  with (Control as TListBox).Canvas do begin
    FillRect(Rect);
    TextOut((Rect.Left + Rect.Right - TextWidth(txt)) div 2, Rect.Top, txt)
  end;
end;

end.
