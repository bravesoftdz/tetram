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
        [SQLDataField]
        [IsReference]
        public Guid ID_Collection;

        [SQLDataField]
        public FormatedTitle NomCollection
        {
            get { return fNomCollection; }
            set { fNomCollection = value; }
        }
        private FormatedTitle fNomCollection = new FormatedTitle(string.Empty);
		
        [SQLDataClass]
        public Editeur EditeurCollection
        {
            get { return fEditeurCollection; }
            set { fEditeurCollection = value; }
        }
        private Editeur fEditeurCollection = new Editeur();

		public override string ToString()
		{
			return NomCollection.ToString();
		}

	}

}
