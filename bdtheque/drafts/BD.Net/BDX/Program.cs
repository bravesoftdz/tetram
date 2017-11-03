using System;
using System.Collections.Generic;
using System.Windows.Forms;

namespace BDX
{
    static class Program
    {
        static Form1 frm;
        /// <summary>
        /// Point d'entrée principal de l'application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            frm = new Form1();
            frm.loading = true;
            frm.InitializeGraphics();
            frm.Show();
            frm.loading = false;
            Application.Run(frm);
        }
    }
}