using System;
using TetramCorp.Database;
using TetramCorp.Utilities;

namespace BD.Common.Records
{
    public class Emprunteur : BaseRecord
    {
        [SQLDataField]
        [IsReference]
        public Guid ID_Emprunteur;
        private FormatedTitle fNomEmprunteur = new FormatedTitle(string.Empty);

        [SQLDataField()]
        public FormatedTitle NomEmprunteur
        {
            get { return fNomEmprunteur; }
            set { fNomEmprunteur = value; }
        }

        public override string ToString()
        {
            return fNomEmprunteur.ToString();
        }

    }

    public class EmprunteurComplet : BaseRecordComplet
    {

    }

}