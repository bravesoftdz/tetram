using System;
using System.Collections.Generic;
using System.Text;
using TetramCorp.Database;
using TetramCorp.Utilities;
using System.Data;
using BD.Common.Database;
using BD.Common.Lists;

namespace BD.Common.Records
{
    public class Edition : BaseRecord
    {
        [SQLDataField]
        [IsReference]
        public Guid ID_Edition;
        private int fAnnéeEdition;

        [SQLDataField("AnneeEdition")]
        public int AnnéeEdition
        {
            get { return fAnnéeEdition; }
            set { fAnnéeEdition = value; }
        }
        private string fISBN;

        [SQLDataField()]
        public string ISBN
        {
            get { return fISBN; }
            set { fISBN = value; }
        }
        private Editeur fEditeurEdition = new Editeur();

        [SQLDataClass()]
        public Editeur EditeurEdition
        {
            get { return fEditeurEdition; }
            set { fEditeurEdition = value; }
        }
        private Collection fCollectionEdition = new Collection();

        [SQLDataClass()]
        public Collection CollectionEdition
        {
            get { return fCollectionEdition; }
            set { fCollectionEdition = value; }
        }

        public override System.String ToString()
        {
            StringBuilder result = new StringBuilder("");
            StringUtils.AjoutString(result, fEditeurEdition.NomEditeur.ToString(), " ");
            StringUtils.AjoutString(result, fCollectionEdition.NomCollection.ToString(), " ", "(", ")");
            StringUtils.AjoutString(result, StringUtils.NotZero(fAnnéeEdition.ToString()), " ", "[", "]");
            StringUtils.AjoutString(result, StringUtils.FormatISBN(fISBN), " - ", "ISBN ");
            return result.ToString();
        }
    }

    public class EditionComplet : BaseRecordComplet
    {
        [SQLDataField]
        [IsReference]
        public Guid ID_Edition;

        [SQLDataField]
        public Guid ID_Album;

        private EditeurComplet fEditeur = new EditeurComplet();
        public EditeurComplet Editeur
        {
            get { return fEditeur; }
        }

        private Collection fCollection = new Collection();
        public Collection Collection
        {
            get { return fCollection; }
        }

        [SQLDataField]
        public int TypeEdition
        {
            get { return fTypeEdition; }
            set { fTypeEdition = value; }
        }
        private int fTypeEdition;
        [SQLDataField]
        public string sTypeEdition
        {
            get { return fsTypeEdition; }
            set { fsTypeEdition = value; }
        }
        private string fsTypeEdition;

        [SQLDataField("AnneeEdition")]
        public int AnnéeEdition
        {
            get { return fAnnéeEdition; }
            set { fAnnéeEdition = value; }
        }
        private int fAnnéeEdition;
        public string consultAnnéeEdition
        {
            get { return StringUtils.NotZero(fAnnéeEdition.ToString()); }
        }

        [SQLDataField]
        public int Etat
        {
            get { return fEtat; }
            set { fEtat = value; }
        }
        private int fEtat;
        [SQLDataField]
        public string sEtat
        {
            get { return fsEtat; }
            set { fsEtat = value; }
        }
        private string fsEtat;

        [SQLDataField]
        public int Reliure
        {
            get { return fReliure; }
            set { fReliure = value; }
        }
        private int fReliure;
        [SQLDataField]
        public string sReliure
        {
            get { return fsReliure; }
            set { fsReliure = value; }
        }
        private string fsReliure;

        [SQLDataField]
        public int FormatEdition
        {
            get { return fFormatEdition; }
            set { fFormatEdition = value; }
        }
        private int fFormatEdition;
        [SQLDataField]
        public string sFormatEdition
        {
            get { return fsFormatEdition; }
            set { fsFormatEdition = value; }
        }
        private string fsFormatEdition;

        [SQLDataField]
        public int Orientation
        {
            get { return fOrientation; }
            set { fOrientation = value; }
        }
        private int fOrientation;
        [SQLDataField]
        public string sOrientation
        {
            get { return fsOrientation; }
            set { fsOrientation = value; }
        }
        private string fsOrientation;

        [SQLDataField]
        public int NombreDePages
        {
            get { return fNombreDePages; }
            set { fNombreDePages = value; }
        }
        private int fNombreDePages;
        public string consultNombreDePages
        { get { return StringUtils.NotZero(NombreDePages.ToString()); } }

        [SQLDataField]
        public decimal PrixCote
        {
            get { return fPrixCote; }
            set { fPrixCote = value; }
        }
        private decimal fPrixCote;

        [SQLDataField]
        public int AnneeCote
        {
            get { return fAnneeCote; }
            set { fAnneeCote = value; }
        }
        private int fAnneeCote;
        public string consultCote
        {
            get
            {
                if (PrixCote > 0)
                    return string.Format("{0} ({1})", PrixCote.ToString("c"), AnneeCote);
                else
                    return null;
            }
        }

        [SQLDataField]
        public decimal Prix
        {
            get { return fPrix; }
            set { fPrix = value; }
        }
        private decimal fPrix;
        public string consultPrix
        {
            get
            {
                if (Gratuit)
                    return Properties.Resources.Gratuit;
                if (Prix > 0)
                    return Prix.ToString("c");
                else
                    return null;
            }
        }

        [SQLDataField]
        public bool Couleur
        {
            get { return fCouleur; }
            set { fCouleur = value; }
        }
        private bool fCouleur;

        [SQLDataField]
        public bool VO
        {
            get { return fVO; }
            set { fVO = value; }
        }
        private bool fVO;

        [SQLDataField]
        public bool Dedicace
        {
            get { return fDedicace; }
            set { fDedicace = value; }
        }
        private bool fDedicace;

        [SQLDataField]
        public bool Stock
        {
            get { return fStock; }
            set { fStock = value; }
        }
        private bool fStock;

        [SQLDataField]
        public bool Prete
        {
            get { return fPrete; }
            set { fPrete = value; }
        }
        private bool fPrete;

        [SQLDataField]
        public bool Offert
        {
            get { return fOffert; }
            set { fOffert = value; }
        }
        private bool fOffert;

        [SQLDataField]
        public bool Gratuit
        {
            get { return fGratuit; }
            set { fGratuit = value; }
        }
        private bool fGratuit;

        private string fISBN;
        [SQLDataField]
        public string ISBN
        {
            get
            {
                if (string.IsNullOrEmpty(fISBN))
                    return null;
                else
                    return StringUtils.FormatISBN(fISBN);
            }
            set
            {
                fISBN = value;
            }
        }

        [SQLDataField]
        public DateTime DateAchat;
        public string consultDateAchat
        {
            get
            {
                if (!DateAchat.Equals(new DateTime(0)))
                    return DateAchat.ToString("D");
                else
                    return null;
            }
        }

        [SQLDataField]
        public string Notes
        {
            get { return fNotes; }
            set { fNotes = value; }
        }
        private string fNotes;

        public EmpruntComplet Emprunts
        { get { return fEmprunts; } }
        private EmpruntComplet fEmprunts = new EmpruntComplet();


        public ListeCouvertures Couvertures
        {
            get { return fCouvertures; }
            set { fCouvertures = value; }
        }
        private ListeCouvertures fCouvertures = new ListeCouvertures();

        public override string ToString()
        {
            StringBuilder result = new StringBuilder();
            StringUtils.AjoutString(result, Editeur.NomEditeur.ToString(), " ");
            StringUtils.AjoutString(result, Collection.NomCollection.ToString(), " ", "(", ")");
            StringUtils.AjoutString(result, StringUtils.NotZero(AnnéeEdition.ToString()), " ", "[", "]");
            StringUtils.AjoutString(result, ISBN, " - ", "ISBN ");

            return result.ToString();
        }

        public override void Fill(params System.Object[] references)
        {
            if (references.Length < 1)
                return;
            Guid reference = (Guid)references[0];
            if (reference.Equals(Guid.Empty))
                return;
            using (new WaitingCursor())
            using (IDbCommand cmd = BDDatabase.Database.GetCommand())
            {
                cmd.CommandText = "SELECT ID_EDITION, ID_Album, e.ID_Editeur, e.ID_Collection, NOMCOLLECTION, ANNEEEDITION, PRIX, VO, COULEUR, ISBN, DEDICACE, PRETE,"
                                + "STOCK, Offert, Gratuit, NombreDePages, etat, le.libelle as setat, reliure, lr.libelle as sreliure, orientation, lo.libelle as sorientation,"
                                + "FormatEdition, lf.libelle as sFormatEdition, typeedition, lte.libelle as stypeedition, DateAchat, Notes, AnneeCote, PrixCote "
                                + "FROM EDITIONS e LEFT JOIN COLLECTIONS c ON e.ID_Collection = c.ID_Collection "
                                + "LEFT JOIN LISTES le on (le.ref = e.etat and le.categorie = 1) "
                                + "LEFT JOIN LISTES lr on (lr.ref = e.reliure and lr.categorie = 2) "
                                + "LEFT JOIN LISTES lte on (lte.ref = e.typeedition and lte.categorie = 3) "
                                + "LEFT JOIN LISTES lo on (lo.ref = e.orientation and lo.categorie = 4) "
                                + "LEFT JOIN LISTES lf on (lf.ref = e.formatedition and lf.categorie = 5) "
                                + "WHERE ID_Edition = ?";
                cmd.Parameters.Clear();
                cmd.Parameters.Add(BDDatabase.Database.GetParameter("@ID_Edition", StringUtils.GuidToString(reference)));
                using (IDataReader result = cmd.ExecuteReader())
                using (BaseDataReader<EditionComplet> dataReader = new BaseDataReader<EditionComplet>(result))
                    if (result != null && result.Read())
                    {
                        dataReader.LoadData(this);
                        Editeur.Fill(dataReader.GetGuid("ID_EDITEUR"));
                        // Self.Collection.Fill(q);
                    }

                Emprunts.Fill(reference, srcEmprunt.Album);

                cmd.CommandText = "SELECT ID_Couverture, FichierCouverture, STOCKAGECOUVERTURE, CategorieImage, l.Libelle as sCategorieImage";
                cmd.CommandText += " FROM Couvertures c LEFT JOIN Listes l ON (c.categorieimage = l.ref and l.categorie = 6)";
                cmd.CommandText += " WHERE ID_Edition = ? ORDER BY c.categorieimage NULLS FIRST, c.Ordre";
                cmd.Parameters.Add(BDDatabase.Database.GetParameter("@ID_Edition", StringUtils.GuidToString(reference)));
                using (IDataReader result = cmd.ExecuteReader())
                using (BaseDataReader<Couverture> dataReader = new BaseDataReader<Couverture>(result))
                    if (result != null)
                        dataReader.FillList(fCouvertures);
            }
        }
    }
}