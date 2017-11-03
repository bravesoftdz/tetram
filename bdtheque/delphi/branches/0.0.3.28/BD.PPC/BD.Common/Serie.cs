using System;
using System.Text;
using System.Collections;
using TetramCorp.Utilities;
using TetramCorp.Database;

namespace BD.Common.Records
{
	/// <summary>
	/// Description résumée de Serie.
	/// </summary>
	public class Serie: BaseRecord
	{
		[SQLDataField] [IsReference] public int RefSerie;
		[SQLDataField] public FormatedTitle TitreSerie = new FormatedTitle(string.Empty);
		[SQLDataClass] public Editeur EditeurSerie = new Editeur();
		[SQLDataClass] public Collection CollectionSerie = new Collection();
		
		public override string ToString()
		{
			return ToString(false);
		}

		public string ToString(bool Simple)
		{
			try
			{
				StringBuilder result = new StringBuilder();
				if (Simple)
					result.Append(TitreSerie.RawTitle);
				else
					result.Append(TitreSerie.ToString());

				StringBuilder dummy = new StringBuilder();
				StringUtils.AjoutString(dummy, EditeurSerie.NomEditeur.ToString(), " ");
				StringUtils.AjoutString(dummy, CollectionSerie.NomCollection.ToString(), " - ");
				StringUtils.AjoutString(result, dummy, " ", "(", ")");
				return result.ToString();
			}
			catch (Exception Ex)
			{
				return string.Format("Erreur dans {0}.ToString(): {1}", Ex.GetType().Name, Ex.Message);
			}
		}
	}

	public abstract class SerieComplet : BaseRecordComplet
	{
		[SQLDataField] public int RefSerie;
		[SQLDataField("TITRESERIE")] public FormatedTitle Titre = new FormatedTitle();
		[SQLDataField] public int Terminee;
		public ArrayList Albums = new ArrayList();
		public GenreList Genres = new GenreList();
		[SQLDataField("SUJETSERIE")] public string Sujet;
		[SQLDataField("REMARQUESSERIE")] public string Notes;
		[SQLDataClass] public EditeurComplet Editeur;
		[SQLDataClass] public Collection Collection = new Collection();
		[SQLDataField] public string SiteWeb;
		public ArrayList Scenaristes = new ArrayList();
		public ArrayList Dessinateurs = new ArrayList();
		public ArrayList Coloristes = new ArrayList();

		public int FIdAuteur = -1;

		public SerieComplet(int Reference) : this(Reference, -1) {}

		public SerieComplet(int refSerie, int refAuteur)
		{
			FIdAuteur = refAuteur;
			base.SerieComplet(refSerie);
		}

		public override string ToString()
		{
			return Titre.ToString ();
		}
	}

}
