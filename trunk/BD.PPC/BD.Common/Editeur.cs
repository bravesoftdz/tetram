using System;
using System.Data;
using TetramCorp.Database;
using TetramCorp.Utilities;

namespace BD.Common.Records
{
	/// <summary>
	/// Description résumée de Editeur.
	/// </summary>
	public class Editeur: BaseRecord
	{
		[SQLDataField] [IsReference] public int RefEditeur;
		[SQLDataField] public FormatedTitle NomEditeur = new FormatedTitle(string.Empty);

		public override string ToString()
		{
			return NomEditeur.ToString();
		}
	}

	public abstract class EditeurComplet : BaseRecordComplet
	{
		[SQLDataField] [IsReference] public int RefEditeur;
		[SQLDataField] public FormatedTitle NomEditeur = new FormatedTitle(string.Empty);
		[SQLDataField] public string SiteWeb;

		public EditeurComplet(int Reference) : base(Reference) {}

		public override string ToString()
		{
			return NomEditeur.ToString ();
		}

		public void Fill()
		{
			Fill(RefEditeur);	
		}

	}

}
