unit UfrmGallerie;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, LoadComplet, Generics.Collections, Contnrs, TypeRec,
  UBdtForms, ListOfTypeRec;

type
  TfrmGallerie = class(TBdtForm)
    ScrollBox1: TPanel;
    ScrollBarV: TScrollBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ScrollBarVChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    type
      TMyPanel = class(TPanel)
      private
        FControlList: TMyObjectList<TControl>;
      public
        procedure CMControlListChanging(var Message: TCMControlListChanging); message CM_CONTROLLISTCHANGING;
        procedure SetBounds(Left, Top, Width, Height: Integer); override;
        procedure PositionneControles;
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
      end;

      TThumbList = class(TPanel)

        type
          TThumb = class(TPanel)
          public
            ID_Album, ID_Couverture: TGUID;
            FImage: TImage;
            procedure ImageClick(Sender: TObject);
            constructor Create(AOwner: TCOmponent); override;
            destructor Destroy; override;
          end;

      public
        FLblAlbum, FLblEdition: TLabel;
        FThumbs: TObjectList<TThumb>;
        FThumbsCntnr: TMyPanel;

        constructor Create(AOwner: TCOmponent); override;
        destructor Destroy; override;
      end;

  private
    FAlbum: TGUID;
    FThumbs: TObjectList<TThumbList>;
    FEdition: TGUID;
    FSerie: TGUID;
    FTitreAlbum: string;
    function HeightThumbs: Integer;
    procedure SetAlbum(const Value: TGUID);
    procedure SetEdition(const Value: TGUID);
    procedure SetSerie(const Value: TGUID);

    procedure ShowSerie(Serie: TSerieComplete);
    procedure ShowAlbum(Album: TAlbum);
    procedure ShowEdition(Edition: TEditionComplete);
    { Déclarations privées }
  public
    { Déclarations publiques }
    property ID_Serie: TGUID read FSerie write SetSerie;
    property ID_Album: TGUID read FAlbum write SetAlbum;
    property ID_Edition: TGUID read FEdition write SetEdition;
  end;

implementation

{$R *.dfm}

uses
  Procedures, CommonConst, jpeg, UHistorique, Commun;

{ TThumbList.TThumb }

constructor TfrmGallerie.TThumbList.TThumb.Create(AOwner: TCOmponent);
begin
  inherited;
  BorderWidth := 4;
  Visible := True;
  ShowCaption := False;
  BevelOuter := bvNone;
  ParentColor := True;
  ParentBackground := False;

  FImage := TImage.Create(nil);
  FImage.Visible := True;
  FImage.Parent := Self;
  FImage.AutoSize := True;
  FImage.Cursor := crHandPoint;
  FImage.OnClick := ImageClick;
end;

destructor TfrmGallerie.TThumbList.TThumb.Destroy;
begin
  FImage.Free;
  inherited;
end;

procedure TfrmGallerie.TThumbList.TThumb.ImageClick(Sender: TObject);
begin
  Historique.AddWaiting(fcCouverture, ID_Album, ID_Couverture);
end;

{ TThumbList }

constructor TfrmGallerie.TThumbList.Create(AOwner: TCOmponent);
begin
  FThumbsCntnr := nil;
  inherited;
  Align := alTop;
  ShowCaption := False;
  Visible := True;
  ParentColor := True;
  ParentBackground := False;

  FLblAlbum := TLabel.Create(nil);
  FLblAlbum.Parent := Self;
  FLblAlbum.Visible := True;
  FLblAlbum.Align := alTop;
  FLblAlbum.Font.Style := FLblAlbum.Font.Style + [fsBold];

  FLblEdition := TLabel.Create(nil);
  FLblEdition.Parent := Self;
  FLblEdition.Visible := True;
  FLblEdition.Align := alTop;

  FThumbsCntnr := TMyPanel.Create(nil);
  FThumbsCntnr.Parent := Self;
  FThumbsCntnr.Visible := True;
  FThumbsCntnr.Align := alTop;
  FThumbsCntnr.ShowCaption := False;
  FThumbsCntnr.BevelOuter := bvNone;

  FThumbs := TObjectList<TThumb>.Create(True);
end;

destructor TfrmGallerie.TThumbList.Destroy;
begin
  FThumbs.Free;
  FThumbsCntnr.Free;
  FLblAlbum.Free;
  FLblEdition.Free;
  inherited;
end;

{ TfrmGallerie }

procedure TfrmGallerie.FormCreate(Sender: TObject);
begin
  FThumbs:= TObjectList<TThumbList>.Create(True);
end;

procedure TfrmGallerie.FormDestroy(Sender: TObject);
begin
  FThumbs.Free;
end;

procedure TfrmGallerie.FormResize(Sender: TObject);
begin
  ScrollBarV.Left := ClientWidth - ScrollBarV.Width;
  ScrollBarV.Height := ClientHeight;
  ScrollBarV.Top := 0;
  ScrollBox1.Left := 0;
  ScrollBox1.Width := ClientWidth - ScrollBarV.Width;
  ScrollBox1.Height := HeightThumbs;

  ScrollBarV.Visible := ScrollBox1.Height > ClientHeight;
  if ScrollBarV.Visible then
  begin
    ScrollBarV.Position := -ScrollBox1.Top;
    ScrollBarV.Max := ScrollBox1.Height - ClientHeight;
    ScrollBarV.LargeChange := ClientHeight;
    ScrollBarV.SmallChange := ClientHeight div 5;
  end
  else
    ScrollBox1.Top := 0;
end;

function TfrmGallerie.HeightThumbs: Integer;
var
  Thumb: TThumbList;
begin
  Result := 0;
  for Thumb in FThumbs do
    Inc(Result, Thumb.Height);
end;

procedure TfrmGallerie.ScrollBarVChange(Sender: TObject);
begin
  ScrollBox1.Top := -ScrollBarV.Position;
end;

procedure TfrmGallerie.SetAlbum(const Value: TGUID);
var
  Album: TAlbum;
begin
  FAlbum := Value;
  FSerie := GUID_NULL;
  FEdition := GUID_NULL;

  FThumbs.Clear;

  Album := TAlbum.Create;
  try
    Album.Fill(Value);
    Caption := 'Gallerie - ' + Album.ChaineAffichage(True);
    ShowAlbum(Album);
  finally
    Album.Free;
  end;

  ScrollBox1.Top := 0;
  OnResize(nil);
end;

procedure TfrmGallerie.SetEdition(const Value: TGUID);
var
  Edition: TEditionComplete;
begin
  FAlbum := GUID_NULL;
  FSerie := GUID_NULL;
  FEdition := Value;

  FThumbs.Clear;

  Edition := TEditionComplete.Create(Value);
  try
    ShowEdition(Edition);
    Caption := 'Gallerie - ' + Edition.ChaineAffichage;
  finally
    Edition.Free;
  end;

  ScrollBox1.Top := 0;
  OnResize(nil);
end;

procedure TfrmGallerie.SetSerie(const Value: TGUID);
var
  Serie: TSerieComplete;
begin
  FAlbum := GUID_NULL;
  FSerie := Value;
  FEdition := GUID_NULL;

  FThumbs.Clear;

  Serie := TSerieComplete.Create(Value);
  try
    ShowSerie(Serie);
    Caption := 'Gallerie - ' + Serie.ChaineAffichage;
  finally
    Serie.Free;
  end;

  ScrollBox1.Top := 0;
  OnResize(nil);
end;

procedure TfrmGallerie.ShowAlbum(Album: TAlbum);
var
  i: Integer;
begin
  FTitreAlbum := Album.ChaineAffichage(True);

  with TEditionsCompletes.Create(Album.ID) do
  try
    for i := Pred(Editions.Count) downto 0 do
      ShowEdition(Editions[i]);
  finally
    Free;
  end;
end;

procedure TfrmGallerie.ShowEdition(Edition: TEditionComplete);
var
  AlbumThumbs: TThumbList;
  Thumb: TThumbList.TThumb;
  Couverture: TCouverture;
  ms: TStream;
  jpg: TJPEGImage;
begin
  AlbumThumbs := TThumbList.Create(Self);
  FThumbs.Add(AlbumThumbs);
  AlbumThumbs.Visible := True;
  AlbumThumbs.Parent := ScrollBox1;
  AlbumThumbs.FLblAlbum.Caption := FTitreAlbum;
  AlbumThumbs.FLblEdition.Caption := Edition.ChaineAffichage(True);
  AlbumThumbs.HandleNeeded;
  AlbumThumbs.FThumbsCntnr.HandleNeeded;

  for Couverture in Edition.Couvertures do
  begin
    Thumb := TThumbList.TThumb.Create(nil);
    Thumb.Parent := AlbumThumbs.FThumbsCntnr;
    Thumb.ID_Album := Edition.ID_Album;
    Thumb.ID_Couverture := Couverture.ID;
    Thumb.HandleNeeded;

    AlbumThumbs.FThumbs.Add(Thumb);

    Thumb.FImage.Picture.Assign(nil);
    try
      ms := GetCouvertureStream(False, Couverture.ID, 150, -1, TGlobalVar.Utilisateur.Options.AntiAliasing);
      if Assigned(ms) then try
        jpg := TJPEGImage.Create;
        try
          jpg.LoadFromStream(ms);
          Thumb.FImage.Picture.Assign(jpg);
          Thumb.FImage.Transparent := False;
        finally
          jpg.Free;
        end;
      finally
        ms.Free;
      end
      else
        Thumb.FImage.Picture.Assign(nil);
    except
      Thumb.FImage.Picture.Assign(nil);
    end;

    if not Assigned(Thumb.FImage.Picture.Graphic) then begin
      ms := TResourceStream.Create(HInstance, 'IMAGENONVALIDE', RT_RCDATA);
      jpg := TJPEGImage.Create;
      try
        jpg.LoadFromStream(ms);
        Thumb.FImage.Picture.Assign(jpg);
        Thumb.FImage.Transparent := True;
        Thumb.FImage.Cursor := crDefault;
        Thumb.FImage.OnClick := nil;
      finally
        jpg.Free;
        ms.Free;
      end;
    end;

    Thumb.AutoSize := True;
  end;
  //AlbumThumbs.FThumbsCntnr.AutoSize := True;
  AlbumThumbs.AutoSize := True;
end;

procedure TfrmGallerie.ShowSerie(Serie: TSerieComplete);
var
  i: Integer;
begin
  for i := Pred(Serie.Albums.Count) downto 0 do
    ShowAlbum(Serie.Albums[i]);
end;

{ TfrmGallerie.TMyPanel }

procedure TfrmGallerie.TMyPanel.CMControlListChanging(var Message: TCMControlListChanging);
begin
  inherited;
  if Message.Inserting and (Message.ControlListItem.Parent = Self) then
  begin
    if FControlList.IndexOf(Message.ControlListItem.Control) < 0 then
      FControlList.Add(Message.ControlListItem.Control);
  end else
    FControlList.Remove(Message.ControlListItem.Control);
  PositionneControles;
end;

constructor TfrmGallerie.TMyPanel.Create(AOwner: TComponent);
begin
  inherited;
  ParentColor := True;
  ParentBackground := False;
  FControlList := TMyObjectList<TControl>.Create(False);
end;

destructor TfrmGallerie.TMyPanel.Destroy;
begin
  FControlList.Free;
  inherited;
end;

procedure TfrmGallerie.TMyPanel.PositionneControles;
const
  PositionnementEnCours: Boolean = False;
var
  Ctrl: TControl;
  l, t, CtrlHeight: Integer;
begin
  if PositionnementEnCours or not Assigned(FControlList) then Exit;
  try
    PositionnementEnCours := True;
    l := 0;
    t := 0;
    CtrlHeight := 0;
    for Ctrl in FControlList do
    begin
      if not Ctrl.Visible then Continue;
      CtrlHeight := Ctrl.Height;
      if l + Ctrl.Width > Self.Width then
      begin
        l := 0;
        Inc(t, CtrlHeight); // on considère que tous les controles ont la même hauteur
      end;
      Ctrl.SetBounds(l, t, Ctrl.Width, Ctrl.Height);
      Inc(l, Ctrl.Width);
    end;
    Height := t + CtrlHeight;
  finally
    PositionnementEnCours := False;
  end;
end;

procedure TfrmGallerie.TMyPanel.SetBounds(Left, Top, Width, Height: Integer);
begin
  inherited;
  PositionneControles;
end;

end.
