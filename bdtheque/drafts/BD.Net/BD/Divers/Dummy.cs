using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using TetramCorp.Database;
using System.IO;
using System.Drawing;
using BD.Common;
using System.Drawing.Imaging;

namespace BD.Divers
{
    internal class Dummy
    {
        internal static ImageList _smallImages;
        internal static ImageList smallImages
        {
            get
            {
                if (_smallImages == null)
                {
                    _smallImages = new ImageList();
                    _smallImages.Images.Add("AlbumActif", Properties.Resources.AlbumActif);
                    _smallImages.Images.Add("sortAsc", Properties.Resources.sortAsc);
                    _smallImages.Images.Add("sortDesc", Properties.Resources.sortDesc);
                    _smallImages.Images.Add("Emprunt", Properties.Resources.emprunt);
                    _smallImages.Images.Add("Retour", Properties.Resources.retour);
                }
                return _smallImages;
            }
        }

        internal static Stream getImageStream(bool isParaBD, Guid ID_Couverture, int Hauteur, int Largeur, bool AntiAliasing)
        { return getImageStream(isParaBD, ID_Couverture, Hauteur, Largeur, AntiAliasing, false, 0); }

        internal static Stream getImageStream(bool isParaBD, Guid ID_Couverture, int Hauteur, int Largeur, bool AntiAliasing, bool Cadre)
        { return getImageStream(isParaBD, ID_Couverture, Hauteur, Largeur, AntiAliasing, Cadre, 0); }

        internal static Stream getImageStream(bool isParaBD, Guid ID_Couverture, int Hauteur, int Largeur, bool AntiAliasing, bool Cadre, int Effet3D)
        {
            return ResizePicture(Utils.LoadCouverture(isParaBD, ID_Couverture), Hauteur, Largeur, AntiAliasing, Cadre, Effet3D);
        }

        internal static ImageCodecInfo GetEncoderInfo(String mimeType)
        {
            int j;
            ImageCodecInfo[] encoders;
            encoders = ImageCodecInfo.GetImageEncoders();
            for (j = 0; j < encoders.Length; ++j)
            {
                if (encoders[j].MimeType == mimeType)
                    return encoders[j];
            }
            return null;
        }
        
        internal static Stream ResizePicture(Image image, int Hauteur, int Largeur, bool AntiAliasing, bool Cadre, int Effet3D)
        {
            int NewLargeur, NewHauteur;
            Stream result = new MemoryStream();

            if (image == null) return null;

            if (Hauteur != -1 || Largeur != -1)
            {
                if (Hauteur == -1)
                {
                    NewLargeur = Largeur;
                    NewHauteur = NewLargeur * image.Height / image.Width;
                }
                else
                {
                    NewHauteur = Hauteur;
                    NewLargeur = NewHauteur * image.Width / image.Height;
                    if (Largeur != -1 && NewLargeur > Largeur)
                    {
                        NewLargeur = Largeur;
                        NewHauteur = NewLargeur * image.Height / image.Width;
                    }
                }

                Bitmap bmp = new Bitmap(NewLargeur, NewHauteur);
                NewLargeur -= Effet3D;
                NewHauteur -= Effet3D;
                Graphics grphx = Graphics.FromImage(bmp);
                grphx.DrawImage(image, 0, 0, NewLargeur - Effet3D, NewHauteur - Effet3D);

                if (Cadre)
                    grphx.DrawRectangle(Pens.Black, new Rectangle(0, 0, NewLargeur, NewHauteur));

                if (Effet3D > 0)
                {
                    Point[] poly = new Point[6];
                    poly[0] = new Point(0, NewHauteur);
                    poly[1] = new Point(0 + Effet3D, bmp.Height);
                    poly[2] = new Point(bmp.Width, bmp.Height);
                    poly[3] = new Point(bmp.Width, 0 + Effet3D);
                    poly[4] = new Point(NewLargeur, 0);
                    poly[5] = new Point(NewLargeur, NewHauteur);
                    grphx.DrawPolygon(Pens.Black, poly);
                    grphx.FillPolygon(Brushes.Gray, poly);
                }

                EncoderParameters myEncoderParameters = new EncoderParameters(2);
                myEncoderParameters.Param[0] = new EncoderParameter(System.Drawing.Imaging.Encoder.Quality, 70L);
                myEncoderParameters.Param[1] = new EncoderParameter(System.Drawing.Imaging.Encoder.ColorDepth, 24L);
                bmp.Save(result, GetEncoderInfo("image/jpeg"), myEncoderParameters);
            }
            else
                image.Save(result, ImageFormat.Jpeg);

            return result;
        }

    }

    internal class BDListViewItem : ListViewItem
    {
        private BaseRecord data;

        public BDListViewItem(BaseRecord Data)
            : base(Data.ToString())
        {
            data = Data;
        }

        public BaseRecord Data
        {
            get
            {
                return data;
            }
            set
            {
                data = value;
            }
        }
    }


}