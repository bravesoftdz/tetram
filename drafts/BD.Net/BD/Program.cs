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