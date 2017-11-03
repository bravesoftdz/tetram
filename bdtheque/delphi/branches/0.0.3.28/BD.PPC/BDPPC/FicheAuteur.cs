using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using TetramCorp.Utilities;
using BD.PPC.Records;

namespace BD.PPC.Application
{
	/// <summary>
	/// Description r�sum�e de FicheAuteur.
	/// </summary>
	public class FicheAuteur : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Label label1;
	
		public FicheAuteur()
		{
			//
			// Requis pour la prise en charge du Concepteur Windows Forms
			//
			InitializeComponent();

			Fonts.changeFont(this, Fonts.small);
			Fonts.changeFont(label1, Fonts.normal);
		}

		public FicheAuteur(int refAuteur) : this()
		{
			RefAuteur = refAuteur;
		}
			
		/// <summary>
		/// Nettoyage des ressources utilis�es.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			base.Dispose( disposing );
		}

		#region Code g�n�r� par le Concepteur Windows Form
		/// <summary>
		/// M�thode requise pour la prise en charge du concepteur - ne modifiez pas
		/// le contenu de cette m�thode avec l'�diteur de code.
		/// </summary>
		private void InitializeComponent()
		{
			this.label1 = new System.Windows.Forms.Label();
			this.treeView1 = new System.Windows.Forms.TreeView();
			this.textBox1 = new System.Windows.Forms.TextBox();
			this.label2 = new System.Windows.Forms.Label();
			// 
			// label1
			// 
			this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold);
			this.label1.Location = new System.Drawing.Point(8, 8);
			this.label1.Size = new System.Drawing.Size(224, 32);
			this.label1.Text = "label1";
			this.label1.TextAlign = System.Drawing.ContentAlignment.TopCenter;
			// 
			// treeView1
			// 
			this.treeView1.ImageIndex = -1;
			this.treeView1.Location = new System.Drawing.Point(8, 160);
			this.treeView1.SelectedImageIndex = -1;
			this.treeView1.Size = new System.Drawing.Size(224, 104);
			// 
			// textBox1
			// 
			this.textBox1.AcceptsReturn = true;
			this.textBox1.Location = new System.Drawing.Point(8, 55);
			this.textBox1.Multiline = true;
			this.textBox1.ReadOnly = true;
			this.textBox1.ScrollBars = System.Windows.Forms.ScrollBars.Horizontal;
			this.textBox1.Size = new System.Drawing.Size(224, 97);
			this.textBox1.Text = "";
			// 
			// label2
			// 
			this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Underline);
			this.label2.ForeColor = System.Drawing.Color.Blue;
			this.label2.Location = new System.Drawing.Point(8, 39);
			this.label2.Size = new System.Drawing.Size(220, 20);
			this.label2.Text = "label2";
			// 
			// FicheAuteur
			// 
			this.Controls.Add(this.treeView1);
			this.Controls.Add(this.textBox1);
			this.Controls.Add(this.label2);
			this.Controls.Add(this.label1);
			this.Text = "FicheAuteur";
			this.Load += new System.EventHandler(this.FicheAuteur_Load);
			this.Closed += new System.EventHandler(this.FicheAuteur_Closed);

		}
		#endregion

		private System.Windows.Forms.TreeView treeView1;
		private System.Windows.Forms.TextBox textBox1;
		private System.Windows.Forms.Label label2;


		private void FicheAuteur_Load(object sender, System.EventArgs e)
		{
			ClassMain.mainform.Visible = false;
		}

		private void FicheAuteur_Closed(object sender, System.EventArgs e)
		{
			ClassMain.mainform.Visible = true;
		}
	
		private int refAuteur;
		public int RefAuteur
		{
			get
			{
				return refAuteur;
			}
			set
			{
				refAuteur = value;
				AuteurCompletPPC auteur = new AuteurCompletPPC(refAuteur);
				label1.Text = auteur.NomAuteur.ToString();
				if (auteur.SiteWeb != null && auteur.SiteWeb.Length != 0)
					label2.Text = auteur.SiteWeb;
				else
				{
					label2.Hide();
					textBox1.Height = textBox1.Height + (textBox1.Top - label2.Top);
					textBox1.Top = label2.Top;
				}
				textBox1.Text = auteur.Biographie;
				foreach(SerieCompletPPC serie in auteur.Series) 
				{
					SerieTreeNode Node =  new SerieTreeNode(serie);
					treeView1.Nodes.Add(Node);
					foreach(BD.Common.Records.Album album in serie.Albums)
						Node.Nodes.Add(new AlbumTreeNode(album));
				}
			}
		}

	}

	internal class SerieTreeNode : TreeNode
	{
		public SerieCompletPPC Serie;
		public SerieTreeNode(SerieCompletPPC serie) : base(serie.ToString())
		{
			Serie = serie;
		}
	}

	internal class AlbumTreeNode : TreeNode
	{
		public BD.Common.Records.Album Album;
		public AlbumTreeNode(BD.Common.Records.Album album) : base(album.ToString())
		{
			Album = album;
		}
	}
}
