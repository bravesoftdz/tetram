unit Form_Preview;
{.$D-}
{$B-}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, ToolWin, Menus, Printers, PrintObject, ImgList;

type
  TFrmPreview = class(TForm, IPrintObjectPreview)
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton8: TToolButton;
    ImageList1: TImageList;
    Label1: TLabel;
    ToolButton11: TToolButton;
    ToolButton13: TToolButton;
    PopupMenu1: TPopupMenu;
    ToolButton14: TToolButton;
    Panel: TPanel;
    ScrollBarV: TScrollBar;
    Image: TImage;
    ScrollBarH: TScrollBar;
    Panel1: TPanel;
    Zoom: TComboBox;
    Panel2: TPanel;
    Image3: TImage;
    Label2: TLabel;
    Panel3: TPanel;
    Image2: TImage;
    Panel4: TPanel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure PopupClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ScrollBarVChange(Sender: TObject);
    procedure ScrollBarHChange(Sender: TObject);
    procedure ZoomChange(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Image3MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Déclarations privées }
    procedure ShowNoPage;
    function ShowPage(Page: Integer): Boolean;
    function Maximum: Integer;
    function PWidth: Integer;
    function PHeight: Integer;
  public
    { Déclarations publiques }
    HeightMM: Single;
    WidthMM: Single;
    FPages: TList;
    numeropage: Integer;
    PosClick: TPoint;
    Moving: Boolean;
    procedure Abort; safecall;
    procedure Quit; safecall;
    function Pages: TList; safecall;
    procedure SetHeightMM(const Value: Single); safecall;
    procedure SetWidthMM(const Value: Single); safecall;
    procedure SetCaption(const Title: string); safecall;
    procedure Start; safecall;
  end;

implementation

uses MMSystem, UHistorique;

resourcestring
  zoompleinepage = 'Pleine page';
  zoomecran = 'Largeur de fenêtre';
  listezoom = '';
  premiere = 'Première page';
  suivante = 'Page suivante';
  precedente = 'Page précédente';
  derniere = 'Dernière page';
  allera = 'Aller à la page...';
  numpage = 'Numéro de page';
  nbpages = 'Nombre de pages';
  quitter = 'Fermer l''aperçu';

const
  CurHand = 300;

{$R *.DFM}
{$R *.res}

function Max(a, b: Integer): Integer;
begin
  if a > b then
    Result := a
  else
    Result := b;
end;

function Min(a, b: Integer): Integer;
begin
  if a < b then
    Result := a
  else
    Result := b;
end;

procedure TFrmPreview.Start;
begin
end;

function TFrmPreview.Maximum;
begin
  Result := Pages.Count;
end;

procedure TFrmPreview.ShowNoPage;
begin
  Label2.Caption := Format('%.*d', [Length(Label1.Caption), numeropage]);
end;

procedure AddNewItem(M: TPopupMenu; c: Integer; F: TFrmPreview);
var
  t: TMenuItem;
begin
  t := TMenuItem.Create(M);
  t.Caption := IntToStr(c);
  t.Tag := c;
  t.OnClick := F.PopupClick;
  M.Items.Add(t);
end;

procedure TFrmPreview.FormCreate(Sender: TObject);
begin
  Zoom.Items.Add(zoompleinepage);
  Zoom.Items.Add(zoomecran);
  Zoom.Items.Add('25%');
  Zoom.Items.Add('50%');
  Zoom.Items.Add('75%');
  Zoom.Items.Add('100%');
  Zoom.Items.Add('125%');
  Zoom.Items.Add('150%');
  Zoom.Items.Add('175%');
  Zoom.Items.Add('200%');
  Zoom.ItemIndex := 0;
  Zoom.Hint := listezoom;
  ToolButton1.Hint := premiere;
  ToolButton2.Hint := suivante;
  ToolButton3.Hint := precedente;
  ToolButton4.Hint := derniere;
  Label2.Hint := numpage;
  Image3.Hint := numpage;
  Label1.Hint := nbpages;
  Image2.Hint := nbpages;
  ToolButton8.Hint := quitter;
  numeropage := 0;
  Icon := TApplication(Owner).Icon;
  FPages := TList.Create;
  ScrollBarV.Top := 0;
  ScrollBarV.Height := Panel.Height;
  ScrollBarV.Left := Panel.Width - ScrollBarV.Width;
  ScrollBarH.Left := 0;
  ScrollBarH.Width := Panel.Width;
  ScrollBarH.Top := Panel.Height - ScrollBarH.Height;
  Panel1.Height := ScrollBarH.Height;
  Panel1.Width := ScrollBarV.Width;
  Panel1.Top := ScrollBarH.Top;
  Panel1.Left := ScrollBarV.Left;
  Image.Cursor := CurHand;
end;

procedure TFrmPreview.Quit;
begin
  Label1.Caption := IntToStr(maximum);
  ToolButton1.Click;
  Label1.AutoSize := False;
  Label2.AutoSize := False;
  Zoom.ItemIndex := Zoom.Items.IndexOf('100%'); // 5
  Historique.AddWaiting(fcPreview, Integer(Self));
end;

procedure TFrmPreview.ToolButton8Click(Sender: TObject);
begin
  ModalResult := mrOk;
  Release;
end;

procedure TFrmPreview.ToolButton1Click(Sender: TObject);
begin
  if (numeropage <> 1) and ShowPage(1) then numeropage := 1;
  ShowNoPage;
end;

procedure TFrmPreview.ToolButton2Click(Sender: TObject);
begin
  if (numeropage > 1) and ShowPage(numeropage - 1) then dec(numeropage);
  ShowNoPage;
end;

procedure TFrmPreview.ToolButton3Click(Sender: TObject);
begin
  if (numeropage < maximum) and ShowPage(numeropage + 1) then inc(numeropage);
  ShowNoPage;
end;

procedure TFrmPreview.ToolButton4Click(Sender: TObject);
begin
  if (numeropage <> maximum) and ShowPage(maximum) then numeropage := maximum;
  ShowNoPage;
end;

procedure TFrmPreview.PopupClick(Sender: TObject);
var
  dummy: Integer;
begin
  if TComponent(Sender).Tag = 0 then
    dummy := StrToInt(InputBox(AllerA, AllerA, IntToStr(numeropage)))
  else
    dummy := TComponent(Sender).Tag;
  if (dummy in [1..maximum]) and (dummy <> numeropage) and ShowPage(dummy) then numeropage := dummy;
  ShowNoPage;
end;

procedure TFrmPreview.FormResize(Sender: TObject);
begin
  ScrollBarV.Top := 0;
  ScrollBarV.Height := Panel.Height;
  ScrollBarV.Left := Panel.Width - ScrollBarV.Width;

  ScrollBarH.Left := 0;
  ScrollBarH.Width := Panel.Width;
  ScrollBarH.Top := Panel.Height - ScrollBarH.Height;

  Panel1.Top := ScrollBarH.Top;
  Panel1.Left := ScrollBarV.Left;

  ShowPage(numeropage);
end;

function TFrmPreview.PWidth;
begin
  Result := Panel.Width;
  if ScrollBarV.Visible then Result := Panel.Width - ScrollBarV.Width;
end;

function TFrmPreview.PHeight;
begin
  Result := Panel.Height;
  if ScrollBarH.Visible then Result := Panel.Height - ScrollBarH.Height;
end;

function TFrmPreview.ShowPage;
var
  Dest, Source: TBitmap;
  Rapport: Double;
begin
  try
    Source := TBitmap(Pages[Page - 1]);
    Dest := Image.Picture.Bitmap;
    case Zoom.ItemIndex + 1 of
      1: begin
          Rapport := Source.Width / Source.Height;
          Image.SetBounds(Image.Left, 0, Round(Panel.Height * Rapport), Panel.Height);
          ScrollBarV.Visible := False;
          ScrollBarH.Visible := False;
          Panel1.Visible := False;
        end;
      2: begin
          Rapport := Source.Height / Source.Width;
          ScrollBarV.Visible := Rapport > (Panel.Height / Panel.Width);
          ScrollBarV.Height := Panel.Height;
          ScrollBarH.Visible := False;
          Panel1.Visible := False;
          Image.SetBounds(Image.Left, Image.Top, PWidth, Round(PWidth * Rapport));
        end;
      else begin
          Rapport := StrToInt(Copy(Zoom.Items[Zoom.ItemIndex], 1, Length(Zoom.Items[Zoom.ItemIndex]) - 1)) / 100;
          Image.SetBounds(Image.Left, Image.Top, Round(WidthMM * Screen.PixelsPerInch * 56.7 / 1440 * Rapport), Round(HeightMM * Screen.PixelsPerInch * 56.7 / 1440 * Rapport));
          ScrollBarV.Visible := Image.Height > (Panel.Height - ScrollBarH.Height);
          ScrollBarH.Visible := Image.Width > (Panel.Width - ScrollBarV.Width);
          ScrollBarV.Height := PHeight;
          ScrollBarH.Width := PWidth;
          Panel1.Visible := ScrollBarV.Visible and ScrollBarH.Visible;
        end;
    end;
    Dest.Assign(Source);
    OnResize := FormResize;

    ScrollBarV.Min := 0;
    ScrollBarV.Max := Abs(Image.Height - PHeight);
    ScrollBarV.LargeChange := PHeight;
    ScrollBarV.SmallChange := PHeight div 5;

    ScrollBarH.Min := 0;
    ScrollBarH.Max := Abs(Image.Width - PWidth);
    ScrollBarH.LargeChange := PWidth;
    ScrollBarH.SmallChange := PWidth div 5;

    if not ScrollBarH.Visible then
      Image.Left := (PWidth - Image.Width) div 2
    else if (Image.Left > 0) then
      Image.Left := 0;
    if not ScrollBarV.Visible then
      Image.Top := (PHeight - Image.Height) div 2
    else if (Image.Top > 0) then
      Image.Top := 0;
    if Image.Top <= 0 then ScrollBarV.Position := -Image.Top;
    if Image.Left <= 0 then ScrollBarH.Position := -Image.Left;

    Result := True;
//    label3.Caption := Format('W %d H %d', [Source.Width, Source.Height]);
  except
    Result := False;
  end;
end;

procedure TFrmPreview.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  OnResize := nil;
  for i := 0 to Maximum - 1 do
    TImage(Pages[i]).Free;
  Pages.Free;
end;

procedure TFrmPreview.ScrollBarVChange(Sender: TObject);
begin
  if not Moving then Image.Top := -ScrollBarV.Position;
end;

procedure TFrmPreview.ScrollBarHChange(Sender: TObject);
begin
  if not Moving then Image.Left := -ScrollBarH.Position;
end;

procedure TFrmPreview.ZoomChange(Sender: TObject);
begin
  ShowPage(numeropage);
end;

procedure TFrmPreview.PopupMenu1Popup(Sender: TObject);
var
  i: Integer;
  debut, fin: Integer;
  t: TMenuItem;
begin
  for i := 0 to PopupMenu1.Items.Count - 1 do
    PopupMenu1.Items[0].Free;
  debut := Max(numeropage - 5, 1);
  fin := Min(debut + 10, maximum);
  debut := Max(fin - 10, 1);
  for i := debut to fin do
    AddNewItem(PopupMenu1, i, Self);
  if Maximum > 10 then begin
    t := TMenuItem.Create(PopupMenu1);
    t.Caption := AllerA;
    t.Tag := 0;
    t.OnClick := Self.PopupClick;
    PopupMenu1.Items.Add(t);
  end;
end;

procedure TFrmPreview.FormActivate(Sender: TObject);
begin
  ShowNoPage;
end;

procedure TFrmPreview.Image3MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  pos: TPoint;
begin
  if (Sender = Image3) or (Sender = Label2) then PopupMenu1.Alignment := paLeft;
  if (Sender = Panel4) then PopupMenu1.Alignment := paCenter;
  if (Sender = Image2) or (Sender = Label1) then PopupMenu1.Alignment := paRight;

  pos.x := X;
  pos.y := Image3.Top + Image3.Height;
  pos := TWinControl(Sender).ClientToScreen(pos);
  PopupMenu1.Popup(pos.x, pos.y);
end;

procedure TFrmPreview.ImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  oldImageLeft, oldImageTop: Integer;
  newImageLeft, newImageTop: Integer;
begin
  if Shift <> [ssLeft] then Exit;

  oldImageLeft := Image.Left;
  oldImageTop := Image.Top;

  newImageLeft := Image.Left;
  newImageTop := Image.Top;
  if ScrollBarH.Visible then newImageLeft := Max(-ScrollBarH.Max, Min(ScrollBarH.Min, Image.Left + (X - PosClick.x)));
  if ScrollBarV.Visible then newImageTop := Max(-ScrollBarV.Max, Min(ScrollBarV.Min, Image.Top + (Y - PosClick.y)));
  Image.SetBounds(newImageLeft, newImageTop, Image.Width, Image.Height);
  ScrollBarH.Position := -Image.Left;
  ScrollBarV.Position := -Image.Top;

  if oldImageLeft = Image.Left then PosClick.X := X;
  if oldImageTop = Image.Top then PosClick.Y := Y;
end;

procedure TFrmPreview.ImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  MonRect: TRect;
begin
  GetWindowRect(Panel.Handle, MonRect);
  ClipCursor(@MonRect);
  PosClick := Point(X, Y);
end;

procedure TFrmPreview.ImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Moving := False;
  ClipCursor(nil);
end;

procedure TFrmPreview.Abort;
begin
  Self.Release;
end;

function TFrmPreview.Pages: TList;
begin
  Result := FPages;
end;

procedure TFrmPreview.SetCaption(const Title: string);
begin
  Caption := Title;
end;

procedure TFrmPreview.SetHeightMM(const Value: Single);
begin
  HeightMM := Value;
end;

procedure TFrmPreview.SetWidthMM(const Value: Single);
begin
  WidthMM := Value;
end;

initialization
  Screen.Cursors[CurHand] := LoadCursor(HInstance, 'HAND');

end.
