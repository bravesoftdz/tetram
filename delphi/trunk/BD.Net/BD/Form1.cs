using System;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using TetramCorp.Utilities;

namespace BD
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.panel1.SuspendLayout();
            try
            {
                if (panel1.Controls.Count > 0)
                {
                    panel1.Controls.RemoveAt(0);
                    FicheAlbum.ShowAlbum(StringUtils.StringToGuid("{023BD595-6CEE-42FF-A852-2432C18A2952}")).Parent = this.panel1;
                }
                else
                {
                    FicheAlbum.ShowAlbum(StringUtils.StringToGuid("{02B4F98D-3697-4CE8-B04D-028A9CFCD4C0}")).Parent = this.panel1;
                }
            }
            finally
            {
                panel1.Controls[0].Dock = DockStyle.Fill;
                this.panel1.ResumeLayout();
            }
        }

    }
}