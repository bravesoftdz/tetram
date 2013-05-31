using System;
using System.Text;
using System.Collections;
using TetramCorp.Utilities;
using TetramCorp.Database;
using System.Data;
using BD.Common.Database;
using BD.Common.Lists;

namespace BD.Common.Records
{
    public class Série : BaseRecord
    {
        [SQLDataField("ID_Serie")]
        [IsReference]
        public Guid ID_Série;
        
        private FormatedTitle fTitreSérie = new FormatedTitle(string.Empty);
        [SQLDataField("TitreSerie")]
        public FormatedTitle TitreSérie 
        {
            get { return fTitreSérie; }
            set { fTitreSérie = value; }
        }

        [SQLDataClass]
        public Editeur EditeurSérie = new Editeur();
        [SQLDataClass]
        public Collection CollectionSérie = new Collection();

        public override string ToString()
        {
            return ToString(false);
        }

        public string ToString(bool simple)
        {
            try
            {
                StringBuilder result = new StringBuilder();
                if (simple)
                    result.Append(TitreSérie.RawTitle);
                else
                    result.Append(TitreSérie.ToString());

                StringBuilder dummy = new StringBuilder();
                StringUtils.AjoutString(dummy, EditeurSérie.NomEditeur.ToString(), " ");
                StringUtils.AjoutString(dummy, CollectionSérie.NomCollection.ToString(), " - ");
                StringUtils.AjoutString(result, dummy, " ", "(", ")");
                return result.ToString();
            }
            catch (Exception Ex)
            {
                return string.Format("Erreur dans {0}.ToString(): {1}", Ex.GetType().Name, Ex.Message);
            }
        }
    }

    public class SérieComplet : BaseRecordComplet
    {
        [SQLDataField("ID_Serie")]
        public Guid ID_Série;
        
        private FormatedTitle Titre = new FormatedTitle();
        [SQLDataField("TITRESERIE")]
        public FormatedTitle TitreSerie
        {
            get { return Titre; }
            set { Titre = value; }
        }
        private int fTerminée;

        [SQLDataField("Terminee")]
        public int Terminée
        {
            get { return fTerminée; }
            set { fTerminée = value; }
        }
        
        public ListeAlbums Albums
        { get { return fAlbums; } }
        private ListeAlbums fAlbums = new ListeAlbums();

        private GenreSerie fGenres = new GenreSerie();
        public string Genres
        {
            get { return fGenres.ToString(); }
        }
        private string fSujet;

        [SQLDataField("SUJETSERIE")]
        public string Sujet
        {
            get { return fSujet; }
            set { fSujet = value; }
        }
        private string fNotes;

        [SQLDataField("REMARQUESSERIE")]
        public string Notes
        {
            get { return fNotes; }
            set { fNotes = value; }
        }
        [SQLDataClass]
        public EditeurComplet Editeur = new EditeurComplet();
        [SQLDataClass]
        public Collection Collection = new Collection();
        private string fSiteWeb;

        [SQLDataField()]
        public string SiteWeb
        {
            get { return fSiteWeb; }
            set { fSiteWeb = value; }
        }

        public ListeAuteurs Scénaristes
        { get { return fScénaristes; } }
        private ListeAuteurs fScénaristes = new ListeAuteurs();

        public ListeAuteurs Dessinateurs
        { get { return fDessinateurs; } }
        private ListeAuteurs fDessinateurs = new ListeAuteurs();

        public ListeAuteurs Coloristes
        { get { return fColoristes; } }
        private ListeAuteurs fColoristes = new ListeAuteurs();

        public Guid fID_Auteur = Guid.Empty;

        public override string ToString()
        {
            return Titre.ToString();
        }

        public override void Fill(params object[] references)
        {
            if (references.Length < 1)
                return;
            Guid reference = (Guid)references[0];
            if (reference.Equals(Guid.Empty))
                return;
            if (references.Length > 1)
                this.fID_Auteur = (Guid)references[1];
            else
                this.fID_Auteur = Guid.Empty;
            using (new WaitingCursor())
            using (IDbCommand cmd = BDDatabase.Database.GetCommand())
            {
                cmd.CommandText = "SELECT ID_SERIE, TITRESERIE, TERMINEE, SUJETSERIE, REMARQUESSERIE, SITEWEB, S.ID_EDITEUR, S.ID_COLLECTION, NOMCOLLECTION "
                  + "FROM SERIES S LEFT JOIN COLLECTIONS C ON S.ID_COLLECTION = C.ID_COLLECTION "
                  + "WHERE ID_SERIE = ?";
                cmd.Parameters.Clear();
                cmd.Parameters.Add(BDDatabase.Database.GetParameter("@ID_serie", StringUtils.GuidToString(reference)));
                using (IDataReader result = cmd.ExecuteReader())
                using (BaseDataReader<SérieComplet> dataReader = new BaseDataReader<SérieComplet>(result))
                    if (result != null && result.Read())
                    {
                        dataReader.LoadData(this);
                        this.fTerminée = dataReader.GetInt(2, -1);
                        this.Editeur.Fill(this.Editeur.Reference);
                    }

                cmd.CommandText = "SELECT ID_ALBUM, TITREALBUM, INTEGRALE, HORSSERIE, TOME, TOMEDEBUT, TOMEFIN, ID_SERIE "
                  + "FROM ALBUMS "
                  + "WHERE ID_SERIE = ? ";
                if (!this.fID_Auteur.Equals(Guid.Empty))
                    cmd.CommandText += "AND ID_ALBUM IN (SELECT ID_ALBUM FROM AUTEURS WHERE ID_PERSONNE = ?) ";
                cmd.CommandText += "ORDER BY COALESCE(HORSSERIE, -1), COALESCE(INTEGRALE, -1), COALESCE(TOME, -1)";
                cmd.Parameters.Clear();
                cmd.Parameters.Add(BDDatabase.Database.GetParameter("@ID_Serie", StringUtils.GuidToString(reference)));
                if (!this.fID_Auteur.Equals(Guid.Empty))
                    cmd.Parameters.Add(BDDatabase.Database.GetParameter("@FIdAuteur", StringUtils.GuidToString(this.fID_Auteur)));

                using (IDataReader result = cmd.ExecuteReader())
                using (BaseDataReader<Album> dataReader = new BaseDataReader<Album>(result))
                    if (result != null)
                        dataReader.FillList(this.Albums);

                cmd.CommandText = "SELECT Genre "
                  + "FROM GenreSeries s INNER JOIN Genres g ON g.ID_Genre = s.ID_Genre "
                  + "WHERE ID_Serie = ?";
                cmd.Parameters.Clear();
                cmd.Parameters.Add(BDDatabase.Database.GetParameter("@ID_Serie", StringUtils.GuidToString(reference)));
                this.fGenres.Clear();
                using (IDataReader result = cmd.ExecuteReader())
                using (BaseDataReader<object> dataReader = new BaseDataReader<object>(result))
                    while (result != null && result.Read())
                        this.fGenres.Add(dataReader.GetString(0, string.Empty));

                ListeAuteurs Auteurs = new ListeAuteurs();
                StoredProcedures.PS.ProcAuteurs(Auteurs, Guid.Empty, reference, Guid.Empty);
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
            }
        }
    }

}