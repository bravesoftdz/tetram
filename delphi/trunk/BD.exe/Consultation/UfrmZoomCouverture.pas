unit UfrmZoomCouverture;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, ActnList, ToolWin, StdCtrls,
  Procedures, Menus, ProceduresBDtk, UBdtForms;

type
  TfrmZoomCouverture = class(TBdtForm, IImpressionApercu)
    ImageApercu: TAction;
    ImageImprimer: TAction;
    Panel: TPanel;
    Image: TImage;
    ScrollBarV: TScrollBar;
    ScrollBarH: TScrollBar;
    Panel1: TPanel;
    ActionList1: TActionList;
    MainMenu1: TMainMenu;
    Image1: TMenuItem;
    Aperuavantimpression1: TMenuItem;
    Imprimer1: TMenuItem;
    procedure FormResize(Sender: TObject);
    procedure ImageApercuExecute(Sender: TObject);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImageDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
    FisParaBD: Boolean;
    FID_Item, FID_Couverture: TGUID;
    PosClick: TPoint;
    Moving: Boolean;
    function PHeight: Integer;
    function PWidth: Integer;
    procedure ImpressionExecute(Sender: TObject);
    procedure ApercuExecute(Sender: TObject);
    function ImpressionUpdate: Boolean;
    function ApercuUpdate: Boolean;
  public
    { Déclarations publiques }
    function LoadCouverture(isParaBD: Boolean; const ID_Item, ID_Couverture: TGUID): Boolean;
  end;

implementation

uses Impression, UHistorique, jpeg, Math;

{$R *.DFM}

procedure TfrmZoomCouverture.FormResize(Sender: TObject);
begin
  ScrollBarV.Top := 0;
  ScrollBarV.Height := Panel.Height;
  ScrollBarV.Left := Panel.Width - ScrollBarV.Width;

  ScrollBarH.Left := 0;
  ScrollBarH.Width := Panel.Width;
  ScrollBarH.Top := Panel.Height - ScrollBarH.Height;

  Panel1.Top := ScrollBarH.Top;
  Panel1.Left := ScrollBarV.Left;

  LoadCouverture(FisParaBD, FID_Item, FID_Couverture);
end;

function TfrmZoomCouverture.PWidth: Integer;
begin
  Result := Panel.Width;
  if ScrollBarV.Visible then Result := Panel.Width - ScrollBarV.Width;
end;

function TfrmZoomCouverture.PHeight: Integer;
begin
  Result := Panel.Height;
  if ScrollBarH.Visible then Result := Panel.Height - ScrollBarH.Height;
end;

procedure TfrmZoomCouverture.ImageApercuExecute(Sender: TObject);
begin
  if FisParaBD then
    ImpressionCouvertureAlbum(FID_Item, FID_Couverture, TComponent(Sender).Tag = 1);
end;

procedure TfrmZoomCouverture.ImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  MonRect: TRect;
begin
  GetWindowRect(Panel.Handle, MonRect);
  ClipCursor(@MonRect);
  PosClick := Point(X, Y);
end;

procedure TfrmZoomCouverture.ImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
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

procedure TfrmZoomCouverture.ImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Moving := False;
  ClipCursor(nil);
end;

procedure TfrmZoomCouverture.ApercuExecute(Sender: TObject);
begin
  ImageApercuExecute(Sender);
end;

function TfrmZoomCouverture.ApercuUpdate: Boolean;
begin
  Result := not FisParaBD;
end;

procedure TfrmZoomCouverture.ImpressionExecute(Sender: TObject);
begin
  ImageApercuExecute(Sender);
end;

function TfrmZoomCouverture.ImpressionUpdate: Boolean;
begin
  Result := True;
end;

function TfrmZoomCouverture.LoadCouverture(isParaBD: Boolean; const ID_Item, ID_Couverture: TGUID): Boolean;
var
  ms: TStream;
  jpg: TJPEGImage;
begin
  FisParaBD := isParaBD;
  FID_Item := ID_Item;
  FID_Couverture := ID_Couverture;
  ms := GetCouvertureStream(isParaBD, ID_Couverture, -1, -1, False);
  if Assigned(ms) then begin
    jpg := TJPEGImage.Create;
    try
      jpg.LoadFromStream(ms);
      Image.Picture.Assign(jpg);
    finally
      FreeAndNil(jpg);
      FreeAndNil(ms);
    end;
    Result := True;
  end
  else begin
    Image.Picture.Assign(nil);
    Result := False;
  end;

  ScrollBarV.Visible := Image.Height > (Panel.Height - ScrollBarH.Height);
  ScrollBarH.Visible := Image.Width > (Panel.Width - ScrollBarV.Width);
  ScrollBarV.Height := PHeight;
  ScrollBarH.Width := PWidth;
  Panel1.Visible := ScrollBarV.Visible and ScrollBarH.Visible;

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
end;

procedure TfrmZoomCouverture.ImageDblClick(Sender: TObject);
begin
  Historique.BackWaiting;
end;

procedure TfrmZoomCouverture.FormDestroy(Sender: TObject);
begin
  ClipCursor(nil);
end;

end.

