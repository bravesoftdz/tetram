unit UfrmStatsAlbums;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, BDTK.Entities.Stats, BD.GUI.Forms;

type
  TfrmStatsAlbums = class(TbdtForm)
    Label7: TLabel;
    genre: TListBox;
    max_empruntee: TLabel;
    moy_empruntee: TLabel;
    min_empruntee: TLabel;
    minannee: TLabel;
    maxannee: TLabel;
    fermer: TButton;
    Bevel5: TBevel;
    Bevel1: TBevel;
    Bevel2: TBevel;
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

uses BD.Common, BD.Entities.Lite, Divers;

{$R *.DFM}

procedure TfrmStatsAlbums.listeExit(Sender: TObject);
begin
  TListBox(Sender).ItemIndex := -1;
end;

function TStatsAlbumsCreate(AOwner: TComponent; Info: TStats): TFrmStatsAlbums;
var
  genre: TGenreLite;
begin
  Result := TFrmStatsAlbums.Create(AOwner);
  Result.nb_Albums.Caption := IntToStr(Info.NbAlbums);
  Result.nb_Series.Caption := IntToStr(Info.NbSeries);
  Result.AlbumsNB.Caption := Format(FormatPourcent, [Info.NbAlbumsNB, MulDiv(Info.NbAlbumsNB, 100, Info.NbAlbums)]);
  Result.AlbumsVO.Caption := Format(FormatPourcent, [Info.NbAlbumsVO, MulDiv(Info.NbAlbumsVO, 100, Info.NbAlbums)]);
  Result.AlbumsStock.Caption := Format(FormatPourcent, [Info.NbAlbumsStock, MulDiv(Info.NbAlbumsStock, 100, Info.NbAlbums)]);
  Result.AlbumsIntegrales.Caption := Format(FormatPourcent, [Info.NbAlbumsIntegrale, MulDiv(Info.NbAlbumsIntegrale, 100, Info.NbAlbums)]);
  Result.AlbumsHorsSerie.Caption := Format(FormatPourcent, [Info.NbAlbumsHorsSerie, MulDiv(Info.NbAlbumsHorsSerie, 100, Info.NbAlbums)]);
  Result.minannee.Caption := IntToStr(Info.MinAnnee);
  Result.maxannee.Caption := IntToStr(Info.MaxAnnee);

  for genre in Info.ListGenre do
    Result.genre.Items.Add(Format('%s - ' + FormatPourcent, [genre.ChaineAffichage, genre.Quantite, MulDiv(genre.Quantite, 100, Info.NbAlbums)]));
end;

procedure TfrmStatsAlbums.genreDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  ListBox: TListBox absolute Control;
  txt: string;
begin
  if Control is TListBox then
  begin
    txt := ListBox.Items[Index];
    ListBox.Canvas.FillRect(Rect);
    ListBox.Canvas.TextOut((Rect.Left + Rect.Right - ListBox.Canvas.TextWidth(txt)) div 2, Rect.Top, txt)
  end;
end;

end.
