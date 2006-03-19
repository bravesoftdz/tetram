unit Form_ConsultationSerie;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, LoadComplet, StdCtrls, VirtualTrees, ExtCtrls, ReadOnlyCheckBox,
  ComCtrls, VDTButton, Buttons, VirtualTree, Procedures;

type
  TFrmConsultationSerie = class(TForm, IImpressionApercu)
    ScrollBox2: TScrollBox;
    l_remarques: TLabel;
    l_sujet: TLabel;
    Label1: TLabel;
    l_acteurs: TLabel;
    l_realisation: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    TitreSerie: TLabel;
    Bevel1: TBevel;
    remarques: TMemo;
    sujet: TMemo;
    lvScenaristes: TVDTListView;
    lvDessinateurs: TVDTListView;
    Memo1: TMemo;
    lvColoristes: TVDTListView;
    vtAlbums: TVirtualStringTree;
    vtParaBD: TVirtualStringTree;
    Label4: TLabel;
    Label3: TLabel;
    Lbl_type: TLabel;
    Editeur: TLabel;
    Label9: TLabel;
    Collection: TLabel;
    cbTerminee: TReadOnlyCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TitreSerieClick(Sender: TObject);
    procedure EditeurClick(Sender: TObject);
    procedure vtAlbumsDblClick(Sender: TObject);
    procedure vtParaBDDblClick(Sender: TObject);
  private
    FSerie: TSerieComplete;
    function GetRefSerie: Integer;
    procedure SetRefSerie(const Value: Integer);
    procedure ClearForm;

    procedure ImpressionExecute(Sender: TObject);
    procedure ApercuExecute(Sender: TObject);
    function ImpressionUpdate: Boolean;
    function ApercuUpdate: Boolean;
  public
    property Serie: TSerieComplete read FSerie;
    property RefSerie: Integer read GetRefSerie write SetRefSerie;
  end;

implementation

uses Commun, Divers, TypeRec, ShellAPI, UHistorique, Impression;

{$R *.dfm}

{ TFrmConsultationSerie }

function TFrmConsultationSerie.GetRefSerie: Integer;
begin
  Result := FSerie.RefSerie;
end;

procedure TFrmConsultationSerie.SetRefSerie(const Value: Integer);
var
  s: string;
  i: Integer;
begin
  ClearForm;
  FSerie.Fill(Value);

  Caption := 'Fiche de série - "' + FormatTitre(FSerie.Titre) + '"';
  TitreSerie.Caption := FSerie.Titre;
  if FSerie.SiteWeb <> '' then begin
    TitreSerie.Font.Color := clBlue;
    TitreSerie.Font.Style := TitreSerie.Font.Style + [fsUnderline];
    TitreSerie.Cursor := crHandPoint;
  end
  else begin
    TitreSerie.Font.Color := clWindowText;
    TitreSerie.Font.Style := TitreSerie.Font.Style - [fsUnderline];
    TitreSerie.Cursor := crDefault;
  end;

  Editeur.Caption := FormatTitre(FSerie.Editeur.NomEditeur);
  if FSerie.Editeur.SiteWeb <> '' then begin
    Editeur.Font.Color := clBlue;
    Editeur.Font.Style := [fsUnderline];
    Editeur.Cursor := crHandPoint;
  end
  else begin
    Editeur.Font.Color := clWindowText;
    Editeur.Font.Style := [];
    Editeur.Cursor := crDefault;
  end;
  Collection.Caption := FSerie.Collection.ChaineAffichage;
  cbTerminee.State := TCheckBoxState(FSerie.Terminee);

  Sujet.Text := FSerie.Sujet.Text;
  Remarques.Text := FSerie.Notes.Text;

  if Bool(FSerie.Genres.Count) then begin
    s := FSerie.Genres.Text;
    FSerie.Genres.Sort;
    Collapse(s, ', ');
    s := Copy(s, 1, Length(s) - 2);
  end
  else
    s := '';
  Memo1.Lines.Text := s;

  lvScenaristes.Items.BeginUpdate;
  for i := 0 to Pred(FSerie.Scenaristes.Count) do begin
    with lvScenaristes.Items.Add do begin
      Data := FSerie.Scenaristes[i];
      Caption := TAuteur(Data).ChaineAffichage;
    end;
  end;
  lvScenaristes.Items.EndUpdate;

  lvDessinateurs.Items.BeginUpdate;
  for i := 0 to Pred(FSerie.Dessinateurs.Count) do begin
    with lvDessinateurs.Items.Add do begin
      Data := FSerie.Dessinateurs[i];
      Caption := TAuteur(Data).ChaineAffichage;
    end;
  end;
  lvDessinateurs.Items.EndUpdate;

  lvColoristes.Items.BeginUpdate;
  for i := 0 to Pred(FSerie.Coloristes.Count) do begin
    with lvColoristes.Items.Add do begin
      Data := FSerie.Coloristes[i];
      Caption := TAuteur(Data).ChaineAffichage;
    end;
  end;
  lvColoristes.Items.EndUpdate;

  vtAlbums.Filtre := 'RefSerie = ' + IntToStr(RefSerie);
  vtAlbums.Mode := vmAlbumsSerie;
  vtAlbums.FullExpand;

  vtParaBD.Filtre := 'RefSerie = ' + IntToStr(RefSerie);
  vtParaBD.Mode := vmParaBDSerie;
  vtParaBD.FullExpand;
end;

procedure TFrmConsultationSerie.ClearForm;
begin
  lvScenaristes.Items.Count := 0;
  lvDessinateurs.Items.Count := 0;
  lvColoristes.Items.Count := 0;

  vtAlbums.Mode := vmNone;
  vtAlbums.UseFiltre := True;
  vtParaBD.Mode := vmNone;
  vtParaBD.UseFiltre := True;
end;

procedure TFrmConsultationSerie.FormCreate(Sender: TObject);
begin
  FSerie := TSerieComplete.Create;
end;

procedure TFrmConsultationSerie.FormDestroy(Sender: TObject);
begin
  ClearForm;
  FSerie.Free;
end;

procedure TFrmConsultationSerie.TitreSerieClick(Sender: TObject);
var
  s: string;
begin
  s := FSerie.SiteWeb;
  if s <> '' then
    ShellExecute(Application.DialogHandle, nil, PChar(s), nil, nil, SW_NORMAL);
end;

procedure TFrmConsultationSerie.EditeurClick(Sender: TObject);
var
  s: string;
begin
  s := FSerie.Editeur.SiteWeb;
  if s <> '' then
    ShellExecute(Application.DialogHandle, nil, PChar(s), nil, nil, SW_NORMAL);
end;

procedure TFrmConsultationSerie.vtAlbumsDblClick(Sender: TObject);
begin
  Historique.AddWaiting(fcAlbum, vtAlbums.CurrentValue);
end;

procedure TFrmConsultationSerie.vtParaBDDblClick(Sender: TObject);
begin
  Historique.AddWaiting(fcParaBD, vtParaBD.CurrentValue);
end;

procedure TFrmConsultationSerie.ApercuExecute(Sender: TObject);
begin
  ImpressionSerie(RefSerie, TComponent(Sender).Tag = 1);
end;

function TFrmConsultationSerie.ApercuUpdate: Boolean;
begin
  Result := True;
end;

procedure TFrmConsultationSerie.ImpressionExecute(Sender: TObject);
begin
  ImpressionSerie(RefSerie, TComponent(Sender).Tag = 1);
end;

function TFrmConsultationSerie.ImpressionUpdate: Boolean;
begin
  Result := True;
end;

end.

