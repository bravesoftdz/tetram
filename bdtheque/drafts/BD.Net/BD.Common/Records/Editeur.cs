using System;
using System.Data;
using TetramCorp.Database;
using TetramCorp.Utilities;
using BD.Common.Database;

namespace BD.Common.Records
{
    /// <summary>
    /// Description résumée de Editeur.
    /// </summary>
    public class Editeur : BaseRecord
    {
        [SQLDataField]
        [IsReference]
        public Guid ID_Editeur;

        [SQLDataField]
        public FormatedTitle NomEditeur
        {
            get { return fNomEditeur; }
            set { fNomEditeur = value; }
        }
        private FormatedTitle fNomEditeur = new FormatedTitle(string.Empty);

        public override string ToString()
        {
            return NomEditeur.ToString();
        }
    }

    public class EditeurComplet : BaseRecordComplet
    {
        [SQLDataField]
        [IsReference]
        public Guid ID_Editeur;
        
        [SQLDataField]
        public FormatedTitle NomEditeur
        {
            get { return fNomEditeur; }
            set { fNomEditeur = value; }
        }
        private FormatedTitle fNomEditeur = new FormatedTitle(string.Empty);

        [SQLDataField]
        public string SiteWeb
        {
            get { return fSiteWeb; }
            set { fSiteWeb = value; }
        }
        private string fSiteWeb;

        public override void Fill(params object[] references)
        {
            if (references.Length < 1)
                return;
            Guid reference = (Guid)references[0];
            if (reference.Equals(Guid.Empty))
                return;
            using (new WaitingCursor())
            using (IDbCommand cmd = BDDatabase.Database.GetCommand())
            {
                cmd.CommandText = "SELECT ID_EDITEUR, NOMEDITEUR, SITEWEB FROM EDITEURS WHERE ID_EDITEUR = ?";
                cmd.Parameters.Clear();
                cmd.Parameters.Add(BDDatabase.Database.GetParameter("@ID_editeur", StringUtils.GuidToString(reference)));
                using (IDataReader result = cmd.ExecuteReader())
                using (BaseDataReader<EditeurComplet> dataReader = new BaseDataReader<EditeurComplet>(result))
                    if (result != null && result.Read())
                        dataReader.LoadData(this);
            }
        }

        public override string ToString()
        {
            return NomEditeur.ToString();
        }
    }

}