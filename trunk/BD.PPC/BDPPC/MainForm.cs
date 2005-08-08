using System;
using System.Drawing;
using System.Collections;
using System.Threading;
using System.Windows.Forms;
using TetramCorp.Components;
using TetramCorp.Utilities;
using TetramCorp.Database;
using BD.PPC.Lists;
using BD.PPC.Records;

namespace BD.PPC.Application
{
	/// <summary>
	/// Description résumée de Form1.
	/// </summary>
	public class Répertoire : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Panel panel1;
		private System.Windows.Forms.Button button1;
		private System.Windows.Forms.Button button2;
		private System.Windows.Forms.Button button3;
		private System.Windows.Forms.Button button4;
		private System.Windows.Forms.Button button5;
		private System.Windows.Forms.Button button6;
		private System.Windows.Forms.Button button7;
		private System.Windows.Forms.Button button8;
		private System.Windows.Forms.Button button9;
		private System.Windows.Forms.Button button10;
		private System.Windows.Forms.ListView listView1;
		private System.Windows.Forms.MainMenu mainMenu1;
		private System.Windows.Forms.ColumnHeader columnHeader1;

		private ComboCheck cmFiltre;

		public Répertoire()
		{
			//
			// Requis pour la prise en charge du Concepteur Windows Forms
			//
			InitializeComponent();

#if (DEBUG)
			this.MinimizeBox = false;
#endif

			cmFiltre = new ComboCheck();
			cmFiltre.Items.Add(new ComboItems("Séries", 1, typeof(ListSéries), typeof(FicheSérie)));
			cmFiltre.Items.Add(new ComboItems("Albums", 2, typeof(ListAlbums), null));
			cmFiltre.Items.Add(new ComboItems("Auteurs", 3, typeof(ListPersonnes), typeof(FicheAuteur)));
			cmFiltre.Items.Add(new ComboItems("Emprunteurs", 4, typeof(ListEmprunteurs), null));
			cmFiltre.Location = new Point(0, 0);
			cmFiltre.Size = new Size(100, 15);
			cmFiltre.OnChangedItem += new EventHandler(this.ClickComboItem);
			this.Controls.Add(cmFiltre);

			Fonts.ChangeFont(this, Fonts.Small);
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
			this.mainMenu1 = new System.Windows.Forms.MainMenu();
			this.panel1 = new System.Windows.Forms.Panel();
			this.listView1 = new System.Windows.Forms.ListView();
			this.columnHeader1 = new System.Windows.Forms.ColumnHeader();
			this.button8 = new System.Windows.Forms.Button();
			this.button9 = new System.Windows.Forms.Button();
			this.button10 = new System.Windows.Forms.Button();
			this.button5 = new System.Windows.Forms.Button();
			this.button6 = new System.Windows.Forms.Button();
			this.button7 = new System.Windows.Forms.Button();
			this.button3 = new System.Windows.Forms.Button();
			this.button2 = new System.Windows.Forms.Button();
			this.button1 = new System.Windows.Forms.Button();
			this.button4 = new System.Windows.Forms.Button();
			// 
			// panel1
			// 
			this.panel1.Controls.Add(this.listView1);
			this.panel1.Controls.Add(this.button8);
			this.panel1.Controls.Add(this.button9);
			this.panel1.Controls.Add(this.button10);
			this.panel1.Controls.Add(this.button5);
			this.panel1.Controls.Add(this.button6);
			this.panel1.Controls.Add(this.button7);
			this.panel1.Controls.Add(this.button3);
			this.panel1.Controls.Add(this.button2);
			this.panel1.Controls.Add(this.button1);
			this.panel1.Location = new System.Drawing.Point(0, 24);
			this.panel1.Size = new System.Drawing.Size(240, 216);
			// 
			// listView1
			// 
			this.listView1.Columns.Add(this.columnHeader1);
			this.listView1.FullRowSelect = true;
			this.listView1.HeaderStyle = System.Windows.Forms.ColumnHeaderStyle.None;
			this.listView1.Location = new System.Drawing.Point(0, 15);
			this.listView1.Size = new System.Drawing.Size(240, 200);
			this.listView1.View = System.Windows.Forms.View.Details;
			this.listView1.ItemActivate += new System.EventHandler(this.listView1_ItemActivate);
			// 
			// columnHeader1
			// 
			this.columnHeader1.Text = "ColumnHeader";
			this.columnHeader1.Width = 240;
			// 
			// button8
			// 
			this.button8.Location = new System.Drawing.Point(214, 0);
			this.button8.Size = new System.Drawing.Size(26, 16);
			this.button8.Text = "xyz";
			this.button8.Click += new System.EventHandler(this.button8_Click);
			// 
			// button9
			// 
			this.button9.Location = new System.Drawing.Point(187, 0);
			this.button9.Size = new System.Drawing.Size(28, 16);
			this.button9.Text = "uvw";
			this.button9.Click += new System.EventHandler(this.button8_Click);
			// 
			// button10
			// 
			this.button10.Location = new System.Drawing.Point(161, 0);
			this.button10.Size = new System.Drawing.Size(27, 16);
			this.button10.Text = "rst";
			this.button10.Click += new System.EventHandler(this.button8_Click);
			// 
			// button5
			// 
			this.button5.Location = new System.Drawing.Point(134, 0);
			this.button5.Size = new System.Drawing.Size(28, 16);
			this.button5.Text = "opq";
			this.button5.Click += new System.EventHandler(this.button8_Click);
			// 
			// button6
			// 
			this.button6.Location = new System.Drawing.Point(107, 0);
			this.button6.Size = new System.Drawing.Size(28, 16);
			this.button6.Text = "lmn";
			this.button6.Click += new System.EventHandler(this.button8_Click);
			// 
			// button7
			// 
			this.button7.Location = new System.Drawing.Point(81, 0);
			this.button7.Size = new System.Drawing.Size(27, 16);
			this.button7.Text = "ijk";
			this.button7.Click += new System.EventHandler(this.button8_Click);
			// 
			// button3
			// 
			this.button3.Location = new System.Drawing.Point(54, 0);
			this.button3.Size = new System.Drawing.Size(28, 16);
			this.button3.Text = "fgh";
			this.button3.Click += new System.EventHandler(this.button8_Click);
			// 
			// button2
			// 
			this.button2.Location = new System.Drawing.Point(27, 0);
			this.button2.Size = new System.Drawing.Size(28, 16);
			this.button2.Text = "cde";
			this.button2.Click += new System.EventHandler(this.button8_Click);
			// 
			// button1
			// 
			this.button1.Size = new System.Drawing.Size(28, 16);
			this.button1.Text = "#ab";
			this.button1.Click += new System.EventHandler(this.button8_Click);
			// 
			// Repertoire
			// 
			this.Controls.Add(this.panel1);
			this.Menu = this.mainMenu1;
			this.Text = "BDPPC";
			this.Load += new System.EventHandler(this.Form1_Load);

		}
		#endregion

		internal void ClickComboItem(object sender, EventArgs e)
		{
			RechargeDonnées();
		}

		private void button8_Click(object sender, System.EventArgs e)
		{
			Button btn = (Button)sender;
			criteres = new string[] {btn.Text.Substring(0, 1), btn.Text.Substring(1, 1), btn.Text.Substring(2, 1)};
			RechargeDonnées();
		}

		private string[] criteres;
		public bool RechargeDonnées()
		{
			if (criteres == null || cmFiltre.LastSelected == null) return false;

			listView1.BeginUpdate();
			try
			{
				listView1.Items.Clear();
				Type listClass = ((ComboItems)cmFiltre.LastSelected).listClass;
				System.Reflection.ConstructorInfo construc = listClass.GetConstructor(new Type[] {typeof(string[])});
				object Items = construc.Invoke(new object[] {criteres});
				foreach(BaseRecord item in Items as ArrayList)
					listView1.Items.Add(new RepertoireListViewItem(item));
				return true;
			}
			finally
			{
				listView1.EndUpdate();
			}
		}

		private void Form1_Load(object sender, System.EventArgs e)
		{
			cmFiltre.Value = 1;
			button8_Click(button1, new EventArgs());
		}

		private void listView1_ItemActivate(object sender, System.EventArgs e)
		{
			if (listView1.FocusedItem != null) 
			{
				Type formClass = ((ComboItems)cmFiltre.LastSelected).formClass;
				System.Reflection.ConstructorInfo construc = formClass.GetConstructor(new Type[] {typeof(int)});
				object form = construc.Invoke(new object[] {(listView1.Items[listView1.FocusedItem.Index] as RepertoireListViewItem).Data.Reference});
				(form as Form).ShowDialog();
			}
		}
	}

	internal class ComboItems: ComboCheckSimpleString
	{
		public Type listClass;
		public Type formClass;

		public ComboItems(string Item, int value, Type ListClass, Type FormClass) : base (Item, value)
		{
			listClass = ListClass;
			formClass = FormClass;
		}
	}

	internal class RepertoireListViewItem: ListViewItem
	{
		private BaseRecord data;

		public RepertoireListViewItem(BaseRecord Data) : base(Data.ToString())
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