using System;
using System.Text;
using System.Collections;
using TetramCorp.Utilities;
using TetramCorp.Database;

namespace BD.Common.Records
{
	public class Série: BaseRecord
	{
		[SQLDataField] [IsReference] public int RefSérie;
		[SQLDataField] public FormatedTitle TitreSérie = new FormatedTitle(string.Empty);
		[SQLDataClass] public Editeur EditeurSérie = new Editeur();
		[SQLDataClass] public Collection CollectionSérie = new Collection();
		
		public override string ToString()
		{
			return ToString(false);
		}

		public string ToString(bool simple)
		{
			try
			{
				StringBuilder result = new StringBuilder();
				if (simple)
					result.Append(TitreSérie.RawTitle);
				else
					result.Append(TitreSérie.ToString());

				StringBuilder dummy = new StringBuilder();
				StringUtils.AjoutString(dummy, EditeurSérie.NomEditeur.ToString(), " ");
				StringUtils.AjoutString(dummy, CollectionSérie.NomCollection.ToString(), " - ");
				StringUtils.AjoutString(result, dummy, " ", "(", ")");
				return result.ToString();
			}
			catch (Exception Ex)
			{
				return string.Format("Erreur dans {0}.ToString(): {1}", Ex.GetType().Name, Ex.Message);
			}
		}
	}

	[ClassFactory(typeof(SérieComplet))]
	public class SérieCompletFactory : RecordCompletFactory
	{
		public SérieComplet NewInstance(int refSérie, int refAuteur)
		{
			SérieComplet result = Activator.CreateInstance(Classe) as SérieComplet;
			result.FIdAuteur = refAuteur;
			Fill(result, refSérie);
			return result;
		}	
	}

	public class SérieComplet : BaseRecordComplet
	{
		[SQLDataField] public int RefSérie;
		[SQLDataField("TITRESERIE")] public FormatedTitle Titre = new FormatedTitle();
		[SQLDataField] public int Terminée;
		public ArrayList Albums = new ArrayList();
		public GenreCollection Genres = new GenreCollection();
		[SQLDataField("SUJETSERIE")] public string Sujet;
		[SQLDataField("REMARQUESSERIE")] public string Notes;
		[SQLDataClass] public EditeurComplet Editeur = new EditeurComplet();
		[SQLDataClass] public Collection Collection = new Collection();
		[SQLDataField] public string SiteWeb;
		public ArrayList Scénaristes = new ArrayList();
		public ArrayList Dessinateurs = new ArrayList();
		public ArrayList Coloristes = new ArrayList();

		public int FIdAuteur = -1;

		public override string ToString()
		{
			return Titre.ToString ();
		}
	}

}
