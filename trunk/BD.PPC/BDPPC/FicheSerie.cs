using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using TetramCorp.Utilities;
using BD.PPC.Records;
using BD.Common.Records;

namespace BD.PPC.Application
{
	/// <summary>
	/// Description résumée de FicheSérie.
	/// </summary>
	public class FicheSérie : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Label label1;
	
		public FicheSérie()
		{
			InitializeComponent();

			Fonts.ChangeFont(this, Fonts.Small);
			Fonts.ChangeFont(label1, Fonts.Normal);
		}

		public FicheSérie(int refSérie) : this()
		{
			RefSérie = refSérie;
		}
			
		/// <summary>
		/// Nettoyage des ressources utilisées.
		/// </summary>
		protected override void Dispose( bool disposing )
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
			this.label1 = new System.Windows.Forms.Label();
			this.panel1 = new System.Windows.Forms.Panel();
			this.tabControl1 = new System.Windows.Forms.TabControl();
			this.tabDescription = new System.Windows.Forms.TabPage();
			this.lblGenre = new System.Windows.Forms.Label();
			this.label9 = new System.Windows.Forms.Label();
			this.lblCollection = new System.Windows.Forms.Label();
			this.lblEditeur = new System.Windows.Forms.Label();
			this.label7 = new System.Windows.Forms.Label();
			this.label6 = new System.Windows.Forms.Label();
			this.lbColoristes = new System.Windows.Forms.ListBox();
			this.lbDessinateurs = new System.Windows.Forms.ListBox();
			this.lbScénaristes = new System.Windows.Forms.ListBox();
			this.label2 = new System.Windows.Forms.Label();
			this.label5 = new System.Windows.Forms.Label();
			this.label4 = new System.Windows.Forms.Label();
			this.label3 = new System.Windows.Forms.Label();
			this.tabHistoire = new System.Windows.Forms.TabPage();
			this.tbNotes = new System.Windows.Forms.TextBox();
			this.tbHistoire = new System.Windows.Forms.TextBox();
			this.tabAlbums = new System.Windows.Forms.TabPage();
			this.lbAlbums = new System.Windows.Forms.ListBox();
			// 
			// label1
			// 
			this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold);
			this.label1.Location = new System.Drawing.Point(8, 8);
			this.label1.Size = new System.Drawing.Size(224, 32);
			this.label1.Text = "label1";
			this.label1.TextAlign = System.Drawing.ContentAlignment.TopCenter;
			// 
			// panel1
			// 
			this.panel1.Controls.Add(this.tabControl1);
			this.panel1.Location = new System.Drawing.Point(0, 40);
			this.panel1.Size = new System.Drawing.Size(240, 232);
			// 
			// tabControl1
			// 
			this.tabControl1.Controls.Add(this.tabDescription);
			this.tabControl1.Controls.Add(this.tabHistoire);
			this.tabControl1.Controls.Add(this.tabAlbums);
			this.tabControl1.SelectedIndex = 0;
			this.tabControl1.Size = new System.Drawing.Size(240, 232);
			// 
			// tabDescription
			// 
			this.tabDescription.Controls.Add(this.lblGenre);
			this.tabDescription.Controls.Add(this.label9);
			this.tabDescription.Controls.Add(this.lblCollection);
			this.tabDescription.Controls.Add(this.lblEditeur);
			this.tabDescription.Controls.Add(this.label7);
			this.tabDescription.Controls.Add(this.label6);
			this.tabDescription.Controls.Add(this.lbColoristes);
			this.tabDescription.Controls.Add(this.lbDessinateurs);
			this.tabDescription.Controls.Add(this.lbScénaristes);
			this.tabDescription.Controls.Add(this.label2);
			this.tabDescription.Controls.Add(this.label5);
			this.tabDescription.Controls.Add(this.label4);
			this.tabDescription.Controls.Add(this.label3);
			this.tabDescription.Location = new System.Drawing.Point(4, 4);
			this.tabDescription.Size = new System.Drawing.Size(232, 206);
			this.tabDescription.Text = "Description";
			// 
			// lblGenre
			// 
			this.lblGenre.Location = new System.Drawing.Point(68, 8);
			this.lblGenre.Size = new System.Drawing.Size(156, 29);
			// 
			// label9
			// 
			this.label9.Font = new System.Drawing.Font("Microsoft Sans Serif", 6.75F, System.Drawing.FontStyle.Italic);
			this.label9.Location = new System.Drawing.Point(4, 8);
			this.label9.Size = new System.Drawing.Size(56, 16);
			this.label9.Text = "Genre";
			// 
			// lblCollection
			// 
			this.lblCollection.Location = new System.Drawing.Point(68, 160);
			this.lblCollection.Size = new System.Drawing.Size(156, 16);
			// 
			// lblEditeur
			// 
			this.lblEditeur.Location = new System.Drawing.Point(68, 144);
			this.lblEditeur.Size = new System.Drawing.Size(156, 16);
			// 
			// label7
			// 
			this.label7.Font = new System.Drawing.Font("Microsoft Sans Serif", 6.75F, System.Drawing.FontStyle.Italic);
			this.label7.Location = new System.Drawing.Point(4, 160);
			this.label7.Size = new System.Drawing.Size(56, 16);
			this.label7.Text = "Collection";
			// 
			// label6
			// 
			this.label6.Font = new System.Drawing.Font("Microsoft Sans Serif", 6.75F, System.Drawing.FontStyle.Italic);
			this.label6.Location = new System.Drawing.Point(4, 144);
			this.label6.Size = new System.Drawing.Size(56, 16);
			this.label6.Text = "Editeur";
			// 
			// lbColoristes
			// 
			this.lbColoristes.Location = new System.Drawing.Point(68, 104);
			this.lbColoristes.Size = new System.Drawing.Size(156, 41);
			// 
			// lbDessinateurs
			// 
			this.lbDessinateurs.Location = new System.Drawing.Point(68, 72);
			this.lbDessinateurs.Size = new System.Drawing.Size(156, 41);
			// 
			// lbScénaristes
			// 
			this.lbScénaristes.Location = new System.Drawing.Point(68, 40);
			this.lbScénaristes.Size = new System.Drawing.Size(156, 41);
			// 
			// label2
			// 
			this.label2.ForeColor = System.Drawing.Color.Blue;
			this.label2.Location = new System.Drawing.Point(4, 184);
			this.label2.Size = new System.Drawing.Size(220, 20);
			this.label2.Text = "label2";
			// 
			// label5
			// 
			this.label5.Font = new System.Drawing.Font("Microsoft Sans Serif", 6.75F, System.Drawing.FontStyle.Italic);
			this.label5.Location = new System.Drawing.Point(4, 104);
			this.label5.Size = new System.Drawing.Size(72, 16);
			this.label5.Text = "Coloriste";
			// 
			// label4
			// 
			this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 6.75F, System.Drawing.FontStyle.Italic);
			this.label4.Location = new System.Drawing.Point(4, 40);
			this.label4.Size = new System.Drawing.Size(72, 16);
			this.label4.Text = "Scénariste";
			// 
			// label3
			// 
			this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 6.75F, System.Drawing.FontStyle.Italic);
			this.label3.Location = new System.Drawing.Point(4, 72);
			this.label3.Size = new System.Drawing.Size(72, 16);
			this.label3.Text = "Dessinateur";
			// 
			// tabHistoire
			// 
			this.tabHistoire.Controls.Add(this.tbNotes);
			this.tabHistoire.Controls.Add(this.tbHistoire);
			this.tabHistoire.Location = new System.Drawing.Point(4, 4);
			this.tabHistoire.Size = new System.Drawing.Size(232, 206);
			this.tabHistoire.Text = "Histoire";
			// 
			// tbNotes
			// 
			this.tbNotes.AcceptsReturn = true;
			this.tbNotes.Location = new System.Drawing.Point(8, 120);
			this.tbNotes.Multiline = true;
			this.tbNotes.ReadOnly = true;
			this.tbNotes.ScrollBars = System.Windows.Forms.ScrollBars.Horizontal;
			this.tbNotes.Size = new System.Drawing.Size(216, 80);
			this.tbNotes.Text = "";
			// 
			// tbHistoire
			// 
			this.tbHistoire.AcceptsReturn = true;
			this.tbHistoire.Location = new System.Drawing.Point(8, 8);
			this.tbHistoire.Multiline = true;
			this.tbHistoire.ReadOnly = true;
			this.tbHistoire.ScrollBars = System.Windows.Forms.ScrollBars.Horizontal;
			this.tbHistoire.Size = new System.Drawing.Size(216, 104);
			this.tbHistoire.Text = "";
			// 
			// tabAlbums
			// 
			this.tabAlbums.Controls.Add(this.lbAlbums);
			this.tabAlbums.Location = new System.Drawing.Point(4, 4);
			this.tabAlbums.Size = new System.Drawing.Size(232, 206);
			this.tabAlbums.Text = "Albums";
			// 
			// lbAlbums
			// 
			this.lbAlbums.Location = new System.Drawing.Point(8, 8);
			this.lbAlbums.Size = new System.Drawing.Size(216, 184);
			// 
			// FicheSérie
			// 
			this.Controls.Add(this.panel1);
			this.Controls.Add(this.label1);
			this.Text = "FicheSérie";
			this.Load += new System.EventHandler(this.FicheSérie_Load);
			this.Closed += new System.EventHandler(this.FicheSérie_Closed);

		}
		#endregion

		private void FicheSérie_Load(object sender, System.EventArgs e)
		{
			ClassMain.mainform.Visible = false;
		}

		private void FicheSérie_Closed(object sender, System.EventArgs e)
		{
			ClassMain.mainform.Visible = true;
		}

		private System.Windows.Forms.Panel panel1;
		private System.Windows.Forms.TabControl tabControl1;
		private System.Windows.Forms.TabPage tabDescription;
		private System.Windows.Forms.TabPage tabAlbums;
		private System.Windows.Forms.Label lblGenre;
		private System.Windows.Forms.Label label9;
		private System.Windows.Forms.Label lblCollection;
		private System.Windows.Forms.Label lblEditeur;
		private System.Windows.Forms.Label label7;
		private System.Windows.Forms.Label label6;
		private System.Windows.Forms.ListBox lbColoristes;
		private System.Windows.Forms.ListBox lbDessinateurs;
		private System.Windows.Forms.ListBox lbScénaristes;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.Label label5;
		private System.Windows.Forms.Label label4;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.ListBox lbAlbums;
		private System.Windows.Forms.TabPage tabHistoire;
		private System.Windows.Forms.TextBox tbHistoire;
		private System.Windows.Forms.TextBox tbNotes;

		private int refSérie;
		public int RefSérie
		{
			get
			{
				return refSérie;
			}
			set
			{
				refSérie = value;
        SérieComplet serie = BaseRecordComplet.Create<SérieCompletPPC>(refSérie) as SérieComplet;
				label1.Text = serie.Titre.ToString();
				if (serie.SiteWeb != null && serie.SiteWeb.Length != 0)
					label2.Text = serie.SiteWeb;
				else
					label2.Hide();
				lblGenre.Text = serie.Genres.ToString();
				foreach(Auteur auteur in serie.Scénaristes)
					lbScénaristes.Items.Add(auteur);
				foreach(Auteur auteur in serie.Dessinateurs)
					lbDessinateurs.Items.Add(auteur);
				foreach(Auteur auteur in serie.Coloristes)
					lbColoristes.Items.Add(auteur);
				if (serie.Editeur != null)
					lblEditeur.Text = serie.Editeur.ToString();
				if (serie.Collection != null)
					lblCollection.Text = serie.Collection.ToString();
				tbHistoire.Text = serie.Sujet;
				tbNotes.Text = serie.Notes;
				foreach(Album album in serie.Albums)
					lbAlbums.Items.Add(album);
			}
		}

	}
}
