using System;
using System.Text;
using TetramCorp.Database;
using TetramCorp.Utilities;

namespace BD.Common.Records
{
	/// <summary>
	/// 
	/// </summary>
	public class Album: BaseRecord
	{
		[SQLDataField] [IsReference] public int RefAlbum;
		[SQLDataField] public int Tome;
		[SQLDataField] public int TomeDebut;
		[SQLDataField] public int TomeFin;
		[SQLDataField("TitreAlbum")] public FormatedTitle Titre = new FormatedTitle(string.Empty);
		[SQLDataField] public int RefSerie;
		[SQLDataField("TitreSerie")] public FormatedTitle Serie = new FormatedTitle(string.Empty);
		[SQLDataField] public int RefEditeur;
		[SQLDataField] public FormatedTitle Editeur = new FormatedTitle(string.Empty);
		[SQLDataField] public int AnneeEdition;
		[SQLDataField] public bool Stock;
		[SQLDataField] public bool Integrale;
		[SQLDataField] public bool HorsSerie;
		[SQLDataField] public bool Achat;
		[SQLDataField] public bool Complet;

		public override string ToString()
		{
			return ToString(false);
		}

		public string ToString(bool Simple)
		{
			StringBuilder result = new StringBuilder();
			if (Simple)
				result.Append(Titre.RawTitle);
			else
				result.Append(Titre.ToString());

			StringBuilder dummy = new StringBuilder();
			StringUtils.AjoutString(dummy, Serie.ToString(), " - ");
			if (Integrale)
			{
				StringBuilder dummy2 = new StringBuilder(StringUtils.NonZero(TomeDebut.ToString()));
				StringUtils.AjoutString(dummy2, StringUtils.NonZero(TomeFin.ToString()), " à ");
				StringUtils.AjoutString(dummy, "INT.", " - ", string.Empty, (" " + StringUtils.NonZero(Tome.ToString())).Trim());
				StringUtils.AjoutString(dummy, dummy2, " ", "[", "]");
			} 
			else if (HorsSerie)
				StringUtils.AjoutString(dummy, "HS", " - ", String.Empty, (" " + StringUtils.NonZero(Tome.ToString())).Trim());
			else
				StringUtils.AjoutString(dummy, StringUtils.NonZero(Tome.ToString()), " - ", "T. ");
			StringUtils.AjoutString(result, dummy, " ", "(", ")");
			return result.ToString();
		}
	}

	public abstract class AlbumComplet : BaseRecordComplet
	{
		public AlbumComplet(int Reference) : base(Reference) {}
	}

}
