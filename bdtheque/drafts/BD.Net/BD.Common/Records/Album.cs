using System;
using System.Text;
using TetramCorp.Database;
using TetramCorp.Utilities;
using System.Collections;
using System.Data;
using BD.Common.Database;
using BD.Common.Lists;
using System.Globalization;

namespace BD.Common.Records
{
    public class Album : BaseRecord
    {
        [SQLDataField]
        [IsReference]
        public Guid ID_Album;
        private int fTome;

        [SQLDataField()]
        public int Tome
        {
            get { return fTome; }
            set { fTome = value; }
        }
        private int fTomeDebut;

        [SQLDataField()]
        public int TomeDebut
        {
            get { return fTomeDebut; }
            set { fTomeDebut = value; }
        }
        private int fTomeFin;

        [SQLDataField()]
        public int TomeFin
        {
            get { return fTomeFin; }
            set { fTomeFin = value; }
        }
        private FormatedTitle fTitre = new FormatedTitle(string.Empty);

        [SQLDataField("TitreAlbum")]
        public FormatedTitle Titre
        {
            get { return fTitre; }
            set { fTitre = value; }
        }
        [SQLDataField("ID_Serie")]
        public Guid ID_Série;
        private FormatedTitle fSérie = new FormatedTitle(string.Empty);

        [SQLDataField("TitreSerie")]
        public FormatedTitle Série
        {
            get { return fSérie; }
            set { fSérie = value; }
        }
        [SQLDataField]
        public Guid ID_Editeur;
        private FormatedTitle fEditeur = new FormatedTitle(string.Empty);

        [SQLDataField()]
        public FormatedTitle Editeur
        {
            get { return fEditeur; }
            set { fEditeur = value; }
        }
        private int fAnnéeEdition;

        [SQLDataField("AnneeEdition")]
        public int AnnéeEdition
        {
            get { return fAnnéeEdition; }
            set { fAnnéeEdition = value; }
        }
        private bool fStock;

        [SQLDataField()]
        public bool Stock
        {
            get { return fStock; }
            set { fStock = value; }
        }
        private bool fIntegrale;

        [SQLDataField()]
        public bool Integrale
        {
            get { return fIntegrale; }
            set { fIntegrale = value; }
        }
        private bool fHorsSérie;

        [SQLDataField("HorsSerie")]
        public bool HorsSérie
        {
            get { return fHorsSérie; }
            set { fHorsSérie = value; }
        }
        private bool fAchat;

        [SQLDataField()]
        public bool Achat
        {
            get { return fAchat; }
            set { fAchat = value; }
        }
        private bool fComplet;

        [SQLDataField()]
        public bool Complet
        {
            get { return fComplet; }
            set { fComplet = value; }
        }

        public override string ToString()
        {
            return ToString(false);
        }

        public string ToString(bool simple)
        {
            StringBuilder result = new StringBuilder();
            if (simple)
                result.Append(fTitre.RawTitle);
            else
                result.Append(fTitre.ToString());

            StringBuilder dummy = new StringBuilder();
            StringUtils.AjoutString(dummy, fSérie.ToString(), " - ");
            if (fIntegrale)
            {
                StringBuilder dummy2 = new StringBuilder(StringUtils.NotZero(fTomeDebut.ToString()));
                StringUtils.AjoutString(dummy2, StringUtils.NotZero(fTomeFin.ToString()), " - ");
                StringUtils.AjoutString(dummy, (result.Length > 0 ? Properties.Resources.IntégraleAbrégé : Properties.Resources.Intégrale), " - ", string.Empty, (" " + StringUtils.NotZero(fTome.ToString())).Trim());
                StringUtils.AjoutString(dummy, dummy2, " ", "[", "]");
            }
            else if (fHorsSérie)
                StringUtils.AjoutString(dummy, (result.Length > 0 ? Properties.Resources.HorsSérieAbrégé : Properties.Resources.HorsSérie), " - ", String.Empty, (" " + StringUtils.NotZero(fTome.ToString())).Trim());
            else
                StringUtils.AjoutString(dummy, StringUtils.NotZero(fTome.ToString()), " - ", (result.Length > 0 ? Properties.Resources.TomeAbrégé : Properties.Resources.Tome)+" ");
            if (result.Length > 0)
                StringUtils.AjoutString(result, dummy, " ", "(", ")");
            else
                result = dummy;
            if (result.Length > 0)
                return result.ToString();
            else
                return Properties.Resources.SansTitre;
        }
    }

    public class AlbumComplet : BaseRecordComplet
    {
        [SQLDataField]
        [IsReference]
        public Guid ID_Album;

        [SQLDataField]
        public int Tome
        {
            get { return fTome; }
            set { fTome = value; }
        }
        private int fTome;
        public string consultTome
        { get { return StringUtils.NotZero(fTome.ToString()); } }

        [SQLDataField]
        public int TomeDebut
        {
            get { return fTomeDebut; }
            set { fTomeDebut = value; }
        }
        private int fTomeDebut;

        [SQLDataField]
        public int TomeFin
        {
            get { return fTomeFin; }
            set { fTomeFin = value; }
        }
        private int fTomeFin;

        [SQLDataField("TitreAlbum")]
        public FormatedTitle Titre
        {
            get { return TitreAlbum; }
            set { TitreAlbum = value; }
        }
        private FormatedTitle TitreAlbum = new FormatedTitle(string.Empty);

        [SQLDataField("AnneeParution")]
        public int AnnéeParution
        {
            get { return fAnnéeParution; }
            set { fAnnéeParution = value; }
        }
        private int fAnnéeParution;

        [SQLDataField]
        public int MoisParution
        {
            get { return fMoisParution; }
            set { fMoisParution = value; }
        }
        private int fMoisParution;
        public string Parution
        {
            get
            {
                if (fMoisParution > 0)
                    return CultureInfo.CurrentUICulture.DateTimeFormat.AbbreviatedMonthNames[fMoisParution] + ' ' + StringUtils.NotZero(fAnnéeParution.ToString());
                else
                    return StringUtils.NotZero(fAnnéeParution.ToString());
            }
        }

        [SQLDataField]
        public bool Integrale
        {
            get { return fIntegrale; }
            set { fIntegrale = value; }
        }
        private bool fIntegrale;
        public string consultIntegrale
        {
            get
            {
                if (!fIntegrale) return null;
                StringBuilder result = new StringBuilder(StringUtils.NotZero(fTomeDebut.ToString()));
                StringUtils.AjoutString(result, StringUtils.NotZero(fTomeFin.ToString()), " à ");
                if (result.Length > 0)
                    return '[' + result.ToString() + ']';
                else
                    return null;
            }
        }

        [SQLDataField("HorsSerie")]
        public bool HorsSérie
        {
            get { return fHorsSérie; }
            set { fHorsSérie = value; }
        }
        private bool fHorsSérie;

        [SQLDataField("SUJETALBUM")]
        public string Sujet
        {
            get { return fSujet; }
            set { fSujet = value; }
        }
        private string fSujet;
        public string consultSujet
        {
            get
            {
                if (!string.IsNullOrEmpty(fSujet)) return fSujet;
                if (Serie.ID_Série.Equals(Guid.Empty) && !string.IsNullOrEmpty(Serie.Sujet)) return Serie.Sujet;
                return null;
            }
        }

        [SQLDataField("REMARQUESALBUM")]
        public string Notes
        {
            get { return fNotes; }
            set { fNotes = value; }
        }
        private string fNotes;
        public string consultNote
        {
            get
            {
                if (!string.IsNullOrEmpty(fNotes)) return fNotes;
                if (!Serie.ID_Série.Equals(Guid.Empty) && !string.IsNullOrEmpty(Serie.Notes)) return Serie.Notes;
                return null;
            }
        }

        [SQLDataField]
        public bool Complet;

        public ListeAuteurs Scénaristes 
        { get { return fScénaristes; } }
        private ListeAuteurs fScénaristes = new ListeAuteurs();

        public ListeAuteurs Dessinateurs 
        { get { return fDessinateurs; } }
        private ListeAuteurs fDessinateurs = new ListeAuteurs();

        public ListeAuteurs Coloristes 
        { get { return fColoristes; } }
        private ListeAuteurs fColoristes = new ListeAuteurs();

        public ListeEditionComplet Editions
        { get { return fEditions; } }
        private ListeEditionComplet fEditions = new ListeEditionComplet();

        public SérieComplet Serie
        {
            get { return fSerie; }
        }
        private SérieComplet fSerie = new SérieComplet();

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
                cmd.CommandText = "SELECT ID_ALBUM, TITREALBUM, MOISPARUTION, ANNEEPARUTION, ID_Serie, TOME, TOMEDEBUT, TOMEFIN, SUJETALBUM, REMARQUESALBUM, HORSSERIE, INTEGRALE, COMPLET "
                                + "FROM ALBUMS "
                                + "WHERE ID_Album = ?";
                cmd.Parameters.Clear();
                cmd.Parameters.Add(BDDatabase.Database.GetParameter("@ID_album", StringUtils.GuidToString(reference)));
                using (IDataReader result = cmd.ExecuteReader())
                using (BaseDataReader<AlbumComplet> dataReader = new BaseDataReader<AlbumComplet>(result))
                    if (result != null && result.Read())
                    {
                        dataReader.LoadData(this);
                        fSerie.Fill(dataReader.GetGuid("ID_Serie"));
                    }

                ListeAuteurs Auteurs = new ListeAuteurs();
                StoredProcedures.PS.ProcAuteurs(Auteurs, reference, Guid.Empty, Guid.Empty);
                this.Scénaristes.Clear();
                this.Dessinateurs.Clear();
                this.Coloristes.Clear();
                foreach (Auteur auteur in Auteurs)
                    switch (auteur.Metier)
                    {
                        case 0:
                            {
                                this.Scénaristes.Add(auteur);
                                break;
                            }
                        case 1:
                            {
                                this.Dessinateurs.Add(auteur);
                                break;
                            }
                        case 2:
                            {
                                this.Coloristes.Add(auteur);
                                break;
                            }

                    }

                this.Editions.Fill(ID_Album);
            }
        }
    }

}