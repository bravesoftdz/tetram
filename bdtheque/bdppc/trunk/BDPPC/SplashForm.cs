using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Drawing.Imaging;
using System.Reflection;

namespace BD.PPC
{
  internal partial class SplashForm : System.Windows.Forms.Form
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
      System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(SplashForm));
      this.label1 = new System.Windows.Forms.Label();
      this.pictureBox1 = new System.Windows.Forms.PictureBox();
      this.label2 = new System.Windows.Forms.Label();
      this.label3 = new System.Windows.Forms.Label();
      this.SuspendLayout();
      // 
      // label1
      // 
      this.label1.Location = new System.Drawing.Point(16, 224);
      this.label1.Name = "label1";
      this.label1.Size = new System.Drawing.Size(208, 16);
      this.label1.Text = "label1";
      // 
      // pictureBox1
      // 
      this.pictureBox1.Image = ((System.Drawing.Image)(resources.GetObject("pictureBox1.Image")));
      this.pictureBox1.Location = new System.Drawing.Point(16, 80);
      this.pictureBox1.Name = "pictureBox1";
      this.pictureBox1.Size = new System.Drawing.Size(208, 209);
      // 
      // label2
      // 
      this.label2.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Bold);
      this.label2.ForeColor = System.Drawing.Color.SkyBlue;
      this.label2.Location = new System.Drawing.Point(128, 48);
      this.label2.Name = "label2";
      this.label2.Size = new System.Drawing.Size(100, 20);
      this.label2.Text = "BDThèque";
      this.label2.TextAlign = System.Drawing.ContentAlignment.TopRight;
      // 
      // label3
      // 
      this.label3.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Regular);
      this.label3.ForeColor = System.Drawing.Color.SkyBlue;
      this.label3.Location = new System.Drawing.Point(128, 72);
      this.label3.Name = "label3";
      this.label3.Size = new System.Drawing.Size(100, 20);
      this.label3.Text = "BDThèque";
      this.label3.TextAlign = System.Drawing.ContentAlignment.TopRight;
      // 
      // SplashForm
      // 
      this.ClientSize = new System.Drawing.Size(240, 320);
      this.ControlBox = false;
      this.Controls.Add(this.label3);
      this.Controls.Add(this.label2);
      this.Controls.Add(this.label1);
      this.Controls.Add(this.pictureBox1);
      this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
      this.Location = new System.Drawing.Point(0, 0);
      this.MaximizeBox = false;
      this.MinimizeBox = false;
      this.Name = "SplashForm";
      this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
      this.ResumeLayout(false);

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
