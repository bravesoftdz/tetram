using System;
using System.Collections.Generic;
using System.Windows.Forms;
using System.Drawing;
using TetramCorp.Database;
using System.ComponentModel;

namespace BD
{
    static class Program
    {
        /// <summary>
        /// Point d'entrée principal de l'application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            BD.Common.WSFramework.InitFramework();
            Application.Run(new Form1());
        }
    }
}

namespace BD.Properties
{
    internal class myResources : Resources
    {
        internal static Bitmap MakeTransparent(Bitmap bm)
        {
            Bitmap bmp = new Bitmap(bm);
            bmp.MakeTransparent(bm.GetPixel(1, 1));
            return bmp;
        }

        new internal static System.Drawing.Bitmap AlbumActif
        { get { return MakeTransparent(Resources.AlbumActif); } }

        new internal static System.Drawing.Bitmap sortAsc
        { get { return MakeTransparent(Resources.sortAsc); } }

        new internal static System.Drawing.Bitmap sortDesc
        { get { return MakeTransparent(Resources.sortDesc); } }

        new internal static System.Drawing.Bitmap emprunt
        { get { return MakeTransparent(Resources.emprunt); } }

        new internal static System.Drawing.Bitmap retour
        { get { return MakeTransparent(Resources.retour); } }

        new internal static System.Drawing.Bitmap brokenimage
        { get { return MakeTransparent(Resources.brokenimage); } }
    }
}