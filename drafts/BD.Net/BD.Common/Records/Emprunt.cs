using System;
using System.Collections.Generic;
using System.Text;
using TetramCorp.Database;
using BD.Common.Lists;
using TetramCorp.Utilities;
using System.Data;
using BD.Common.Database;

namespace BD.Common.Records
{
    public class Emprunt : BaseRecord
    {
        [SQLDataClass]
        public Emprunteur Emprunteur
        {
            get { return fEmprunteur; }
            set { fEmprunteur = value; }
        }
        private Emprunteur fEmprunteur = new Emprunteur();

        [SQLDataClass]
        public Album Album
        {
            get { return fAlbum; }
            set { fAlbum = value; }
        }
        private Album fAlbum = new Album();

        [SQLDataClass]
        public Edition Edition
        {
            get { return fEdition; }
            set { fEdition = value; }
        }
        private Edition fEdition = new Edition();

        [SQLDataField("DateEmprunt")]
        public DateTime Date
        {
            get { return fDate; }
            set { fDate = value; }
        }
        private DateTime fDate;
        public string sDate
        { get { return fDate.ToString("d"); } }

        [SQLDataField("PretEmprunt")]
        public Boolean Pret
        {
            get { return fPret; }
            set { fPret = value; }
        }
        private Boolean fPret;
    }

    public class EmpruntComplet : BaseRecordComplet
    {
        public ListeEmprunts Emprunts
        {
            get { return fEmprunts; }
        }

        public int NbEmprunts
        { get { return fNBEmprunts; } }
        private int fNBEmprunts;

        private ListeEmprunts fEmprunts = new ListeEmprunts();

        public override void Fill(params object[] references)
        // Fill(const Reference: TGUID; Source: TSrcEmprunt = seTous; Sens: TSensEmprunt = ssTous; Apres: TDateTime = -1; Avant: TDateTime = -1; EnCours: Boolean = False; Stock: Boolean = False); 
        {
            if (references.Length < 1) return;

            Guid reference = Guid.Empty;
            srcEmprunt Source = srcEmprunt.Tous;
            sensEmprunt Sens = sensEmprunt.Tous;
            DateTime Apres = new DateTime(0);
            DateTime Avant = new DateTime(0);
            bool EnCours = false;
            bool Stock = false;

            switch (references.Length)
            {
                case 1: { reference = (Guid)references[0]; break; }
                case 2: { Source = (srcEmprunt)references[1]; goto case 1; }
                case 3: { Sens = (sensEmprunt)references[2]; goto case 2; }
                case 4: { Apres = (DateTime)references[3]; goto case 3; }
                case 5: { Avant = (DateTime)references[4]; goto case 4; }
                case 6: { EnCours = (bool)references[5]; goto case 5; }
                case 7: { Stock = (bool)references[6]; goto case 6; }
            }
            if (reference.Equals(Guid.Empty)) return;

            using (new WaitingCursor())
            using (IDbCommand cmd = BDDatabase.Database.GetCommand())
            {
                cmd.CommandText = "SELECT * FROM VW_EMPRUNTS";

                List<string> s = new List<string>();
                if (Source == srcEmprunt.Album) s.Add("ID_Edition = " + StringUtils.QuotedStr(StringUtils.GuidToString(reference)));
                if (Source == srcEmprunt.Emprunteur) s.Add("ID_Emprunteur = " + StringUtils.QuotedStr(StringUtils.GuidToString(reference)));

                if (EnCours) s.Add("Prete = 1");
                if (Sens == sensEmprunt.Pret) s.Add("PretEmprunt = 1");
                if (Sens == sensEmprunt.Retour) s.Add("PretEmprunt = 0");

                if (Apres > new DateTime(0)) s.Add("DateEmprunt >= ?");
                if (Avant > new DateTime(0)) s.Add("DateEmprunt <= ?");

                if (s.Count > 0)
                {
                    cmd.CommandText += " WHERE 1=1";
                    foreach (string tmp in s)
                        cmd.CommandText += " AND " + tmp;
                }
                
                cmd.CommandText += " ORDER BY DateEmprunt DESC, ID_STATUT ASC"; // le dernier saisi a priorité en cas de "même date"

                cmd.Parameters.Clear();
                if (Apres > new DateTime(0)) cmd.Parameters.Add(BDDatabase.Database.GetParameter("@DateApres", Apres));
                if (Avant > new DateTime(0)) cmd.Parameters.Add(BDDatabase.Database.GetParameter("@DateAvant", Avant));

                Guid Ref = Guid.Empty;
                List<Guid> lRef = new List<Guid>();
                fEmprunts.Clear();
                using (IDataReader result = cmd.ExecuteReader())
                using (BaseDataReader<Emprunt> dataReader = new BaseDataReader<Emprunt>(result))
                    while (result != null && result.Read())
                    {
                        Ref = dataReader.GetGuid("ID_Edition");
                        if (!Stock || lRef.IndexOf(Ref) == -1)
                        {
                            lRef.Add(Ref);
                            Emprunt emprunt = dataReader.NextObject();
                            if (emprunt.Pret) fNBEmprunts++;
                            fEmprunts.Add(emprunt);
                        }
                    }
            }
        }
    }

    public enum srcEmprunt
    {
        Tous,
        Album,
        Emprunteur,
    }
    public enum sensEmprunt
    {
        Tous,
        Pret,
        Retour,
    }
}
