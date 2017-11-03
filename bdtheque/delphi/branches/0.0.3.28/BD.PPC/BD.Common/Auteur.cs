using System;
using System.Collections;
using System.Data;
using TetramCorp.Database;
using TetramCorp.Utilities;

namespace BD.Common.Records
{
	public class Personnage : BaseRecord
	{
		[SQLDataField] [IsReference] public int RefPersonne;
		[SQLDataField] public FormatedTitle NomPersonne = new FormatedTitle();

		public override string ToString()
		{
			return NomPersonne.ToString();
		}
	}

	public class Auteur : BaseRecord
	{
		[SQLDataField] [IsReference] public int RefAuteur;
		[SQLDataClass] public Personnage Personne = new Personnage();
		[SQLDataField] public int RefAlbum;
		[SQLDataField] public int RefSerie;
		[SQLDataField] public int Metier;

		public override string ToString()
		{
			return Personne.ToString();
		}
	}

	public abstract class AuteurComplet : BaseRecordComplet
	{
		[SQLDataField("RefPersonne")] [IsReference] public int RefAuteur;
		[SQLDataField("NomPersonne")] public FormatedTitle NomAuteur = new FormatedTitle();
		[SQLDataField] public string SiteWeb;
		[SQLDataField] public string Biographie;
		public ArrayList Series = new ArrayList();

		public AuteurComplet(int Reference) : base(Reference) {}

	}
}
