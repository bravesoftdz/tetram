using System;
using System.IO;
using System.Drawing;
using System.Collections;
using System.Windows.Forms;
using System.Data;
using System.Data.SqlServerCe;
using BD.PPC.Database;
using System.Reflection;

namespace CreateStructureBDPPC
{
	/// <summary>
	/// Description résumée de Form1.
	/// </summary>
	public class Form1 : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Button button1;
		private System.Windows.Forms.Button button2;
		private System.Windows.Forms.Button button3;
		private System.Windows.Forms.ProgressBar progressBar1;
		private System.Windows.Forms.MainMenu mainMenu1;

		public Form1()
		{
			//
			// Requis pour la prise en charge du Concepteur Windows Forms
			//
			InitializeComponent();

			//
			// TODO : ajoutez le code du constructeur après l'appel à InitializeComponent
			//
#if (DEBUG)
			this.MinimizeBox = false;
#endif
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
			this.button1 = new System.Windows.Forms.Button();
			this.button2 = new System.Windows.Forms.Button();
			this.button3 = new System.Windows.Forms.Button();
			this.progressBar1 = new System.Windows.Forms.ProgressBar();
			// 
			// button1
			// 
			this.button1.Location = new System.Drawing.Point(8, 32);
			this.button1.Text = "Données";
			this.button1.Click += new System.EventHandler(this.button1_Click);
			// 
			// button2
			// 
			this.button2.Location = new System.Drawing.Point(8, 8);
			this.button2.Text = "Tables";
			this.button2.Click += new System.EventHandler(this.button2_Click);
			// 
			// button3
			// 
			this.button3.Location = new System.Drawing.Point(88, 8);
			this.button3.Text = "Vider";
			this.button3.Click += new System.EventHandler(this.button3_Click);
			// 
			// progressBar1
			// 
			this.progressBar1.Location = new System.Drawing.Point(40, 240);
			// 
			// Form1
			// 
			this.Controls.Add(this.progressBar1);
			this.Controls.Add(this.button3);
			this.Controls.Add(this.button2);
			this.Controls.Add(this.button1);
			this.Menu = this.mainMenu1;
			this.Text = "Form1";

		}
		#endregion

		private ArrayList GetTextRessource(string strName)
		{
			Assembly assembly = Assembly.GetExecutingAssembly();
			Stream stream = assembly.GetManifestResourceStream(assembly.GetName().Name + '.' + strName);
			StreamReader reader = new StreamReader(stream);
			ArrayList result = new ArrayList();
  		while (reader.BaseStream.Position < reader.BaseStream.Length)
				result.Add(reader.ReadLine());
			return result;
		}

		
		private void button1_Click(object sender, System.EventArgs e)
		{
			ExecuteScript(GetTextRessource("ScriptData.sql"));
		}

		private bool ExcuteSQL(string sql)
		{
			if (sql == null || sql.Length == 0) return true;
#if (DEBUG)
			using (IDbCommand _command = BDPPCDatabase.DebugDBConnection().Connection.CreateCommand())
#else
			using (IDbCommand _command = BDPPCDatabase.DBConnection.Connection.CreateCommand())
#endif
			{
				_command.CommandText = sql;
				_command.ExecuteNonQuery();
			}
			return true;
		}

		private void ExecuteScript(string[] script)
		{
			progressBar1.Minimum = 0; 
			progressBar1.Maximum = script.Length;
#if (DEBUG)
			using (IDbCommand _command = BDPPCDatabase.DebugDBConnection().Connection.CreateCommand())
#else
			using (IDbCommand _command = BDPPCDatabase.DBConnection.Connection.CreateCommand())
#endif
			{
				foreach(string sql in script)
				{
					_command.CommandText = sql;
					_command.ExecuteNonQuery();
					progressBar1.Value++;
					if (progressBar1.Value % 100 == 0) progressBar1.Update();
				}
			}
			MessageBox.Show("Ok");
		}
		
		private void ExecuteScript(ArrayList script)
		{
			progressBar1.Minimum = 0; 
			progressBar1.Maximum = script.Count;
#if (DEBUG)
			using (IDbCommand _command = BDPPCDatabase.DebugDBConnection().Connection.CreateCommand())
#else
			using (IDbCommand _command = BDPPCDatabase.DBConnection.Connection.CreateCommand())
#endif
			{
				for(int i = 0; i < script.Count; i++)
				{
					_command.CommandText = (string)script[i];
					_command.ExecuteNonQuery();
			
					if (i % 100 == 0) progressBar1.Value = i;
				}
			}
			MessageBox.Show("Ok");
		}
		
		private void button2_Click(object sender, System.EventArgs e)
		{
			string[] SQLScriptCreate = new string[14] 	{
																										@"CREATE TABLE ALBUMS (
    ID_ALBUMS            nCHAR(38),
    REFALBUM             INTEGER,
    TITREALBUM           nVARCHAR(150),
    ANNEEPARUTION        SMALLINT,
    REFSERIE             INTEGER,
    TOME                 SMALLINT,
    TOMEDEBUT            SMALLINT,
    TOMEFIN              SMALLINT,
    HORSSERIE            SMALLINT,
    INTEGRALE            SMALLINT,
    SUJETALBUM           ntext,
    REMARQUESALBUM       ntext,
    TITREINITIALESALBUM  nVARCHAR(15),
    UPPERTITREALBUM      nVARCHAR(150),
    UPPERSUJETALBUM      ntext,
    UPPERREMARQUESALBUM  ntext,
    SOUNDEXTITREALBUM    nVARCHAR(30),
    INITIALETITREALBUM   nCHAR(1),
    ACHAT                SMALLINT,
    NBEDITIONS           INTEGER,
    DC_ALBUMS            datetime,
    DM_ALBUMS            datetime
);",
																										@"CREATE TABLE AUTEURS (
    ID_AUTEURS   nCHAR(38),
    REFALBUM     INTEGER,
    REFPERSONNE  INTEGER,
    METIER       SMALLINT,
    DC_AUTEURS   datetime,
    DM_AUTEURS   datetime
);",
																										@"CREATE TABLE AUTEURS_SERIES (
    ID_AUTEURS_SERIES  nCHAR(38),
    REFSERIE           INTEGER,
    REFPERSONNE        INTEGER,
    METIER             SMALLINT,
    DC_AUTEURS_SERIES  datetime,
    DM_AUTEURS_SERIES  datetime
);",
																										@"CREATE TABLE COLLECTIONS (
    ID_COLLECTIONS         nCHAR(38),
    REFCOLLECTION          INTEGER,
    NOMCOLLECTION          nVARCHAR(50),
    REFEDITEUR             INTEGER,
    UPPERNOMCOLLECTION     nVARCHAR(50),
    INITIALENOMCOLLECTION  nCHAR(1),
    DC_COLLECTIONS         datetime,
    DM_COLLECTIONS         datetime
);",
																										@"CREATE TABLE EDITEURS (
    ID_EDITEURS         nCHAR(38),
    REFEDITEUR          INTEGER,
    NOMEDITEUR          nVARCHAR(50),
    UPPERNOMEDITEUR     nVARCHAR(50),
    INITIALENOMEDITEUR  nCHAR(1),
    SITEWEB             nVARCHAR(255),
    DC_EDITEURS         datetime,
    DM_EDITEURS         datetime
);",
																										@"CREATE TABLE EDITIONS (
    ID_EDITIONS    nCHAR(38),
    REFEDITION     INTEGER,
    REFALBUM       INTEGER,
    REFEDITEUR     INTEGER,
    REFCOLLECTION  INTEGER,
    ANNEEEDITION   SMALLINT,
    PRIX           NUMERIC(15,2),
    VO             SMALLINT,
    COULEUR        SMALLINT,
    ISBN           nCHAR(13),
    PRETE          SMALLINT,
    STOCK          SMALLINT,
    DEDICACE       SMALLINT,
    ETAT           INTEGER,
    RELIURE        INTEGER,
    TYPEEDITION    INTEGER,
    NOTES          ntext,
    DATEACHAT      DATEtime,
    GRATUIT        SMALLINT,
    OFFERT         SMALLINT,
    NOMBREDEPAGES  INTEGER,
    ORIENTATION    SMALLINT,
    FORMATEDITION  SMALLINT,
    DC_EDITIONS    datetime,
    DM_EDITIONS    datetime
);",
																										@"CREATE TABLE EMPRUNTEURS (
    ID_EMPRUNTEURS         nCHAR(38),
    REFEMPRUNTEUR          INTEGER,
    NOMEMPRUNTEUR          nvarchar(150),
    ADRESSEEMPRUNTEUR      ntext,
    UPPERNOMEMPRUNTEUR     nvarchar(150),
    INITIALENOMEMPRUNTEUR  nCHAR(1),
    DC_EMPRUNTEURS         datetime,
    DM_EMPRUNTEURS         datetime
);",
																										@"CREATE TABLE GENRES (
    ID_GENRES      nCHAR(38),
    REFGENRE       INTEGER,
    GENRE          nVARCHAR(30),
    UPPERGENRE     nVARCHAR(30),
    INITIALEGENRE  nCHAR(1),
    DC_GENRES      datetime,
    DM_GENRES      datetime
);",
																										@"CREATE TABLE GENRESERIES (
    ID_GENRESERIES  nCHAR(38),
    REFSERIE        INTEGER,
    REFGENRE        INTEGER,
    DC_GENRESERIES  datetime,
    DM_GENRESERIES  datetime
);",
																										@"CREATE TABLE LISTES (
    ID_LISTES  nCHAR(38),
    REF        INTEGER,
    CATEGORIE  INTEGER,
    LIBELLE    nVARCHAR(50),
    ORDRE      INTEGER,
    DEFAUT     SMALLINT,
    DC_LISTES  datetime,
    DM_LISTES  datetime
);",
																										@"CREATE TABLE OPTIONS (
    ID_OPTIONS  nCHAR(38),
    NOM_OPTION  nVARCHAR(15),
    VALEUR      nVARCHAR(255),
    DC_OPTIONS  datetime,
    DM_OPTIONS  datetime
);",
																										@"CREATE TABLE PERSONNES (
    ID_PERSONNES         nCHAR(38),
    REFPERSONNE          INTEGER,
    NOMPERSONNE          nvarchar(150),
    UPPERNOMPERSONNE     nvarchar(150),
    INITIALENOMPERSONNE  nCHAR(1),
    BIOGRAPHIE           ntext,
    SITEWEB              nVARCHAR(255),
    DC_PERSONNES         datetime,
    DM_PERSONNES         datetime
);",
																										@"CREATE TABLE SERIES (
    ID_SERIES            nCHAR(38),
    REFSERIE             INTEGER,
    TITRESERIE           nVARCHAR(150),
    UPPERTITRESERIE      nVARCHAR(150),
    INITIALETITRESERIE   nCHAR(1),
    REFEDITEUR           INTEGER,
    REFCOLLECTION        INTEGER,
    SUJETSERIE           ntext,
    REMARQUESSERIE       ntext,
    UPPERSUJETSERIE      ntext,
    UPPERREMARQUESSERIE  ntext,
    TERMINEE             SMALLINT,
    COMPLETE             SMALLINT,
    SOUNDEXTITRESERIE    nVARCHAR(30),
    SITEWEB              nVARCHAR(255),
    DC_SERIES            datetime,
    DM_SERIES            datetime
);",
																										@"CREATE TABLE STATUT (
    ID_STATUT      nCHAR(38),
    REFEMPRUNT     INTEGER,
    DATEEMPRUNT    datetime,
    REFEDITION     INTEGER,
    PRETEMPRUNT    SMALLINT,
    REFEMPRUNTEUR  INTEGER,
    DC_STATUT      datetime,
    DM_STATUT      datetime
);"};
			ExecuteScript(SQLScriptCreate);
		}

		private void button3_Click(object sender, System.EventArgs e)
		{
			string[] SQLScriptDelete = new string[14] 	{
																										@"DELETE FROM ALBUMS;",
																										@"DELETE FROM AUTEURS;",
																										@"DELETE FROM AUTEURS_SERIES;",
																										@"DELETE FROM COLLECTIONS;",
																										@"DELETE FROM EDITEURS;",
																										@"DELETE FROM EDITIONS;",
																										@"DELETE FROM EMPRUNTEURS;",
																										@"DELETE FROM GENRES;",
																										@"DELETE FROM GENRESERIES;",
																										@"DELETE FROM LISTES;",
																										@"DELETE FROM OPTIONS;",
																										@"DELETE FROM PERSONNES;",
																										@"DELETE FROM SERIES;",
																										@"DELETE FROM STATUT;"};
			ExecuteScript(SQLScriptDelete);
		}

	}
}
