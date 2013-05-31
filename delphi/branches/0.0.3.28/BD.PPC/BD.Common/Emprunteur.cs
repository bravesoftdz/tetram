using System;
using TetramCorp.Database;
using TetramCorp.Utilities;

namespace BD.Common.Records
{
	public class Emprunteur : BaseRecord
	{
		[SQLDataField] [IsReference] public int RefEmprunteur;
		[SQLDataField] public FormatedTitle NomEmprunteur = new FormatedTitle(string.Empty);

		public override string ToString()
		{
			return NomEmprunteur.ToString();
		}

	}

	public abstract class EmprunteurComplet : BaseRecordComplet
	{
		public EmprunteurComplet(int Reference) : base()
		{
		}
	}

}
