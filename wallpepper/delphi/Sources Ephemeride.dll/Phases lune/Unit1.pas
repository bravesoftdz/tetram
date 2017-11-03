unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    DateTimePicker1: TDateTimePicker;
    Image1: TImage;
    Image2: TImage;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

uses StAstro, StDate;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
//
end;

procedure TForm1.Button1Click(Sender: TObject);
const
  Marge = 5;
  Diametre = 90;
  Rayon = Diametre div 2;

var
  pl: Double;
  ut: TStDateTimeRec;
  rgn, rgnRond: THandle;
  rgnDroit, rgnGauche: THandle;
  r: Integer;
begin
  image2.Picture.Assign(image1.Picture);
  ut.D := DateTimeToStDate(DateTimePicker1.DateTime);
  ut.T := DateTimeToStTime(DateTimePicker1.DateTime);
  pl := LunarPhase(ut);
//  pl := LunarPhase(NextNewMoon(DateTimeToStDate(Now)));
  Caption := FloatToStr(pl);

  rgnRond := CreateEllipticRgn(Marge, Marge, Image2.Picture.Width - Marge, Image2.Picture.Height - Marge);
  rgn := CreateRectRgn(Marge + Rayon, Marge, Image2.Picture.Width - Marge, Image2.Picture.Height - Marge);
  rgnDroit := CreateRectRgn(0, 0, 0, 0);
  CombineRgn(rgnDroit, rgn, rgnRond, RGN_AND);
//  DeleteObject(rgn);
  rgn := CreateRectRgn(Marge, Marge, Marge + Rayon, Image2.Picture.Height - Marge);
  rgnGauche := CreateRectRgn(0, 0, 0, 0);
  CombineRgn(rgnGauche, rgn, rgnRond, RGN_AND);
//  DeleteObject(rgn);
//  DeleteObject(rgnRond);

  r := Round((abs(pl) - 0.5) * 2 * Rayon);
  rgnRond := CreateEllipticRgn(Marge + Rayon - r, Marge, Marge + Rayon + r, Image2.Picture.Height - Marge);
//  rgnRond := CreateEllipticRgn(Marge + Rayon div 2, Marge + Rayon div 2, Marge + Rayon div 2 + Rayon, Marge + Rayon div 2 + Rayon);

  // premier quartier : pl = 0.5
  // pleine lune : pl = 1
  // dernier quartier : pl = -0.5
  // nouvelle lune : pl = 0

  if pl > 0 then rgn := rgnGauche
            else rgn := rgnDroit;

  if Abs(pl) > 0.5 then CombineRgn(rgn, rgn, rgnRond, RGN_OR)
                   else CombineRgn(rgn, rgn, rgnRond, RGN_DIFF);

  FillRgn(Image2.Picture.Bitmap.Canvas.Handle, rgn, Image2.Picture.Bitmap.Canvas.Brush.Handle);

  DeleteObject(rgnRond);
  DeleteObject(rgnDroit);
  DeleteObject(rgnGauche);
  DeleteObject(rgn);
end;

end.
