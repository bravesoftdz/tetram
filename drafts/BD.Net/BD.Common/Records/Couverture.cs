using System;
using System.Collections.Generic;
using System.Text;
using TetramCorp.Database;

namespace BD.Common.Records
{
    public class Couverture : BaseRecord
    {
        [SQLDataField]
        [IsReference]
        public Guid ID_Couverture;

        [SQLDataField("FichierCouverture")]
        private string fOldNom;
        public string OldNom
        {
            get { return fOldNom; }
        }

        [SQLDataField("FichierCouverture")]
        private string fNewNom;
        public string NewNom
        {
            get { return fNewNom; }
            set { fNewNom = value; }
        }

        [SQLDataField("STOCKAGECOUVERTURE")]
        private bool fOldStockee;
        public bool OldStockee
        {
            get { return fOldStockee; }
        }

        [SQLDataField("STOCKAGECOUVERTURE")]
        private bool fNewStockee;
        public bool NewStockee
        {
            get { return fNewStockee; }
            set { fNewStockee = value; }
        }

        [SQLDataField("CategorieImage")]
        private int fCategorie;
        public int Categorie
        {
            get { return fCategorie; }
            set { fCategorie = value; }
        }

        [SQLDataField("sCategorieImage")]
        private string fsCategorie;
        public string sCategorie
        {
            get { return fsCategorie; }
        }

        public override string ToString()
        {
            return NewNom.ToString();
        }

    }
}