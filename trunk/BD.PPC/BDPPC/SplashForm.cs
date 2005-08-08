using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Drawing.Imaging;
using System.Reflection;

namespace BD.PPC
{
	internal class SplashForm : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.PictureBox pictureBox1;

		public SplashForm()
		{
			this.Visible = false;
			InitializeComponent();
			TetramCorp.Utilities.Fonts.ChangeFont(label1, TetramCorp.Utilities.Fonts.Small);
		}

		protected override void Dispose(bool disposing)
		{
			base.Dispose( disposing );
		}

		#region Code généré par le Concepteur Windows Form
		/// <summary>
		/// Méthode requise pour la prise en charge du concepteur - ne modifiez pas
		/// le contenu de cette méthode avec l'éditeur de code.
		/// </summary>
		private void InitializeComponent()
		{
			System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(SplashForm));
			this.label1 = new System.Windows.Forms.Label();
			this.pictureBox1 = new System.Windows.Forms.PictureBox();
			this.label2 = new System.Windows.Forms.Label();
			this.label3 = new System.Windows.Forms.Label();
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(16, 224);
			this.label1.Size = new System.Drawing.Size(208, 16);
			this.label1.Text = "label1";
			// 
			// pictureBox1
			// 
			this.pictureBox1.Image = ((System.Drawing.Image)(resources.GetObject("pictureBox1.Image")));
			this.pictureBox1.Location = new System.Drawing.Point(16, 80);
			this.pictureBox1.Size = new System.Drawing.Size(208, 209);
			// 
			// label2
			// 
			this.label2.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Bold);
			this.label2.ForeColor = System.Drawing.Color.SkyBlue;
			this.label2.Location = new System.Drawing.Point(128, 48);
			this.label2.Text = "BDThèque";
			this.label2.TextAlign = System.Drawing.ContentAlignment.TopRight;
			// 
			// label3
			// 
			this.label3.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Regular);
			this.label3.ForeColor = System.Drawing.Color.SkyBlue;
			this.label3.Location = new System.Drawing.Point(128, 72);
			this.label3.Text = "BDThèque";
			this.label3.TextAlign = System.Drawing.ContentAlignment.TopRight;
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
			// 
			// SplashForm
			// 
			this.ControlBox = false;
			this.Controls.Add(this.label3);
			this.Controls.Add(this.label2);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.pictureBox1);
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.WindowState = System.Windows.Forms.FormWindowState.Maximized;

		}
		#endregion

		public void KillMe(object o, EventArgs e)
		{
			this.Close();
		}

		public string Label
		{
			get
			{
				return label1.Text;
		}
			set
			{
				lock(this)
					label1.Text = value;
				Refresh();
			}
		}

	}
}
