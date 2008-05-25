unit Form_StatsEmprunteurs;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, LoadComplet, ExtCtrls, UBdtForms;

type
  TFrmStatsEmprunteurs = class(TbdtForm)
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    min_emprunteurs: TLabel;
    max_emprunteurs: TLabel;
    moy_emprunteurs: TLabel;
    nb_emprunteurs: TLabel;
    listmaxemprunteurs: TListBox;
    listminemprunteurs: TListBox;
    Label2: TLabel;
    Label5: TLabel;
    nb_Albums: TLabel;
    AlbumsStock: TLabel;
    fermer: TButton;
    Bevel5: TBevel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    procedure listeExit(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function TStatsEmprunteursCreate(AOwner: TComponent; Info: TStats): TFrmStatsEmprunteurs;

implementation

uses CommonConst, TypeRec, Divers;

{$R *.DFM}

function TStatsEmprunteursCreate(AOwner: TComponent; Info: TStats): TFrmStatsEmprunteurs;
var
  i: Integer;
begin
  Result := TFrmStatsEmprunteurs.Create(AOwner);
  with Result do begin
    nb_Albums.Caption := IntToStr(Info.NbAlbums);
    AlbumsStock.Caption := Format(FormatPourcent, [Info.NbAlbumsStock, MulDiv(Info.NbAlbumsStock, 100, Info.NbAlbums)]);

    nb_emprunteurs.Caption := IntToStr(Info.NbEmprunteurs);
    moy_emprunteurs.Caption := IntToStr(Info.MoyEmprunteurs);
    max_emprunteurs.Caption := IntToStr(Info.MaxEmprunteurs);
    for i := 0 to Info.ListEmprunteursMax.Count - 1 do
      listmaxemprunteurs.Items.Add(TEmprunteur(Info.ListEmprunteursMax[i]).ChaineAffichage);
    min_emprunteurs.Caption := IntToStr(Info.MinEmprunteurs);
    for i := 0 to Info.ListEmprunteursMin.Count - 1 do
      listminemprunteurs.Items.Add(TEmprunteur(Info.ListEmprunteursMin[i]).ChaineAffichage);
  end;
end;

procedure TFrmStatsEmprunteurs.listeExit(Sender: TObject);
begin
  TListBox(Sender).ItemIndex := -1;
end;

end.
