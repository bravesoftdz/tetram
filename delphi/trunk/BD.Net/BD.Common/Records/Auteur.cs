using System;
using System.Collections;
using System.Data;
using TetramCorp.Database;
using TetramCorp.Utilities;
using BD.Common.Database;
using BD.Common.Lists;

namespace BD.Common.Records
{
    public class Personnage : BaseRecord
    {
        [SQLDataField]
        [IsReference]
        public Guid ID_Personne;
        [SQLDataField]
        public FormatedTitle NomPersonne = new FormatedTitle();
        public string Nom
        { get { return NomPersonne.ToString(); } }

        public override string ToString()
        {
            return NomPersonne.ToString();
        }
    }

    public class Auteur : BaseRecord
    {
        [SQLDataField]
        [IsReference]
        public Guid ID_Auteur;
        [SQLDataClass]
        public Personnage Personne = new Personnage();
        public Personnage fPersonne
        {
            get { return Personne; }
        }

        [SQLDataField]
        public Guid ID_Album;
        [SQLDataField("ID_Serie")]
        public Guid ID_Série;
        [SQLDataField]
        public int Metier;

        public override string ToString()
        {
            return Personne.ToString();
        }
    }

    public class AuteurComplet : BaseRecordComplet
    {
        [SQLDataField("ID_Personne")]
        [IsReference]
        public Guid ID_Auteur;
        private FormatedTitle fNomAuteur = new FormatedTitle();

        [SQLDataField("NomPersonne")]
        public FormatedTitle NomAuteur
        {
            get { return fNomAuteur; }
            set { fNomAuteur = value; }
        }
        private string fSiteWeb;

        [SQLDataField()]
        public string SiteWeb
        {
            get { return fSiteWeb; }
            set { fSiteWeb = value; }
        }
        private string fBiographie;

        [SQLDataField()]
        public string Biographie
        {
            get { return fBiographie; }
            set { fBiographie = value; }
        }
        public ListeSériesCompletes Séries = new ListeSériesCompletes();

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
                cmd.CommandText = "SELECT ID_PERSONNE, NOMPERSONNE, SITEWEB, BIOGRAPHIE FROM PERSONNES WHERE ID_PERSONNE = ?";
                cmd.Parameters.Clear();
                cmd.Parameters.Add(BDDatabase.Database.GetParameter("@ID_personne", StringUtils.GuidToString(reference)));
                using (IDataReader result = cmd.ExecuteReader())
                using (BaseDataReader<AuteurComplet> dataReader = new BaseDataReader<AuteurComplet>(result))
                    if (result != null && result.Read())
                        dataReader.LoadData(this);

                // UpperTitreSerie en premier pour forcer l'union à trier sur le titre
                cmd.CommandText = "SELECT UPPERTITRESERIE, s.ID_SERIE";
                cmd.CommandText += " FROM ALBUMS al";
                cmd.CommandText += "  INNER JOIN AUTEURS au ON al.ID_album = au.ID_album AND au.ID_personne = ?";
                cmd.CommandText += "  INNER JOIN SERIES s ON s.ID_serie = al.ID_serie";
                cmd.CommandText += " union ";
                cmd.CommandText += "SELECT UPPERTITRESERIE, s.ID_SERIE";
                cmd.CommandText += " FROM auteurs_series au";
                cmd.CommandText += "  INNER JOIN SERIES s ON s.ID_serie = au.ID_serie AND au.ID_personne = ?";
                cmd.Parameters.Clear();
                cmd.Parameters.Add(BDDatabase.Database.GetParameter("@ID_personne1", StringUtils.GuidToString(reference)));
                cmd.Parameters.Add(BDDatabase.Database.GetParameter("@ID_personne2", StringUtils.GuidToString(reference)));
                this.Séries.Clear();
                using (IDataReader result = cmd.ExecuteReader())
                using (BaseDataReader<object> dataReader = new BaseDataReader<object>(result))
                    if (result != null)
                        while (result.Read())
                            this.Séries.Add(BaseRecord.Create<SérieComplet>(dataReader.GetGuid(1), this.ID_Auteur));
            }
        }
    }
}