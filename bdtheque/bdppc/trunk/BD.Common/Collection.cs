using System;
using TetramCorp.Database;
using TetramCorp.Utilities;

namespace BD.Common.Records
{
	/// <summary>
	/// Description résumée de Collection.
	/// </summary>
	public class Collection: BaseRecord
	{
		[SQLDataField] [IsReference] public int RefCollection;
		[SQLDataField] public FormatedTitle NomCollection = new FormatedTitle(string.Empty);
		[SQLDataClass] public Editeur EditeurCollection = new Editeur();

		public override string ToString()
		{
			return NomCollection.ToString();
		}

	}

}
