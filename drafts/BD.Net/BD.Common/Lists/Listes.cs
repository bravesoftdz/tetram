using System;
using System.Collections.Generic;
using System.Text;
using BD.Common.Records;
using TetramCorp.Database;
using TetramCorp.Utilities;
using System.Data;
using BD.Common.Database;

namespace BD.Common.Lists
{
    public class ListeAlbums : List<Album>
    {
        public ListeAlbums()
            : base()
        {
            //ChargeDonnées(null);
        }

        public ListeAlbums(string[] titreCommencePar)
            : base()
        {
            ChargeDonnées(titreCommencePar);
        }

        public void ChargeDonnées(string[] titreCommencePar)
        {
            using (new WaitingCursor())
            using (IDbCommand cmd = BDDatabase.Database.GetCommand())
            {
                StringBuilder SQL = new StringBuilder();
                cmd.Parameters.Clear();
                SQL.Append("SELECT * FROM ALBUMS A INNER JOIN SERIES S ON A.ID_SERIE = S.ID_SERIE");
                if (titreCommencePar != null && titreCommencePar.Length > 0)
                {
                    SQL.Append("\nWHERE");
                    for (int i = 0; i < titreCommencePar.Length; i++)
                    {
                        SQL.Append((i == 0 ? "" : "\nOR") + "\nUPPERTITREALBUM LIKE ?");
                        cmd.Parameters.Add(BDDatabase.Database.GetParameter("@P" + i.ToString(), titreCommencePar[i].ToUpper() + "%"));
                    }
                }
                SQL.Append("\nORDER BY A.UPPERTITREALBUM");
                cmd.CommandText = SQL.ToString();
                using (IDataReader result = cmd.ExecuteReader())
                using (BaseDataReader<Album> dataReader = new BaseDataReader<Album>(result))
                    if (result != null)
                        dataReader.FillList(this);
            }
        }
    }

    public class ListeAuteurs : List<Auteur>
    {
        public ListeAuteurs()
            : base()
        {
            //ChargeDonnées(null);
        }

        public ListeAuteurs(string[] titreCommencePar)
            : base()
        {
            ChargeDonnées(titreCommencePar);
        }

        public void ChargeDonnées(string[] titreCommencePar)
        {
            using (new WaitingCursor())
            using (IDbCommand cmd = BDDatabase.Database.GetCommand())
            {
                StringBuilder SQL = new StringBuilder();
                cmd.Parameters.Clear();
                SQL.Append("SELECT ID_PERSONNE, NOMPERSONNE FROM PERSONNES");
                if (titreCommencePar != null && titreCommencePar.Length > 0)
                {
                    SQL.Append("\nWHERE");
                    for (int i = 0; i < titreCommencePar.Length; i++)
                    {
                        SQL.Append((i == 0 ? "" : "\nOR") + "\nUPPERNOMPERSONNE LIKE ?");
                        cmd.Parameters.Add(BDDatabase.Database.GetParameter("@P" + i.ToString(), titreCommencePar[i].ToUpper() + "%"));
                    }
                }
                SQL.Append("\nORDER BY UPPERNOMPERSONNE");
                cmd.CommandText = SQL.ToString();
                using (IDataReader result = cmd.ExecuteReader())
                using (BaseDataReader<Auteur> dataReader = new BaseDataReader<Auteur>(result))
                    if (result != null)
                        dataReader.FillList(this);
            }
        }
    }

    public class ListePersonnes : List<Personnage>
    {
        public ListePersonnes()
            : base()
        {
            //ChargeDonnées(null);
        }

        public ListePersonnes(string[] titreCommencePar)
            : base()
        {
            ChargeDonnées(titreCommencePar);
        }

        public void ChargeDonnées(string[] titreCommencePar)
        {
            using (new WaitingCursor())
            using (IDbCommand cmd = BDDatabase.Database.GetCommand())
            {
                StringBuilder SQL = new StringBuilder();
                cmd.Parameters.Clear();
                SQL.Append("SELECT ID_PERSONNE, NOMPERSONNE FROM PERSONNES");
                if (titreCommencePar != null && titreCommencePar.Length > 0)
                {
                    SQL.Append("\nWHERE");
                    for (int i = 0; i < titreCommencePar.Length; i++)
                    {
                        SQL.Append((i == 0 ? "" : "\nOR") + "\nUPPERNOMPERSONNE LIKE ?");
                        cmd.Parameters.Add(BDDatabase.Database.GetParameter("@P" + i.ToString(), titreCommencePar[i].ToUpper() + "%"));
                    }
                }
                SQL.Append("\nORDER BY UPPERNOMPERSONNE");
                cmd.CommandText = SQL.ToString();
                using (IDataReader result = cmd.ExecuteReader())
                using (BaseDataReader<Personnage> dataReader = new BaseDataReader<Personnage>(result))
                    if (result != null)
                        dataReader.FillList(this);
            }
        }
    }

    public class ListeSéries : List<Série>
    {
        public ListeSéries()
            : base()
        {
            //ChargeDonnées(null);
        }

        public ListeSéries(string[] titreCommencePar)
            : base()
        {
            ChargeDonnées(titreCommencePar);
        }

        public void ChargeDonnées(string[] titreCommencePar)
        {
            using (new WaitingCursor())
            using (IDbCommand cmd = BDDatabase.Database.GetCommand())
            {
                StringBuilder SQL = new StringBuilder();
                cmd.Parameters.Clear();
                SQL.Append("SELECT * FROM SERIES S LEFT JOIN EDITEURS E ON S.ID_EDITEUR = E.ID_EDITEUR LEFT JOIN COLLECTIONS C ON S.ID_COLLECTION=C.ID_COLLECTION");
                if (titreCommencePar != null && titreCommencePar.Length > 0)
                {
                    SQL.Append("\nWHERE");
                    for (int i = 0; i < titreCommencePar.Length; i++)
                    {
                        SQL.Append((i == 0 ? "" : "\nOR") + "\nUPPERTITRESERIE LIKE ?");
                        cmd.Parameters.Add(BDDatabase.Database.GetParameter("@P" + i.ToString(), titreCommencePar[i].ToUpper() + "%"));
                    }
                }
                SQL.Append("\nORDER BY S.UPPERTITRESERIE");
                cmd.CommandText = SQL.ToString();
                using (IDataReader result = cmd.ExecuteReader())
                using (BaseDataReader<Série> dataReader = new BaseDataReader<Série>(result))
                    if (result != null)
                        dataReader.FillList(this);
            }
        }
    }

    public class ListEmprunteurs : List<Emprunteur>
    {
        public ListEmprunteurs()
            : base()
        {
            //ChargeDonnées(null);
        }

        public ListEmprunteurs(string[] titreCommencePar)
            : base()
        {
            ChargeDonnées(titreCommencePar);
        }

        public void ChargeDonnées(string[] titreCommencePar)
        {
            using (new WaitingCursor())
            using (IDbCommand cmd = BDDatabase.Database.GetCommand())
            {
                StringBuilder SQL = new StringBuilder();
                cmd.Parameters.Clear();
                SQL.Append("SELECT ID_EMPRUNTEUR, NOMEMPRUNTEUR FROM EMPRUNTEURS");
                if (titreCommencePar != null && titreCommencePar.Length > 0)
                {
                    SQL.Append("\nWHERE");
                    for (int i = 0; i < titreCommencePar.Length; i++)
                    {
                        SQL.Append((i == 0 ? "" : "\nOR") + "\nUPPERNOMEMPRUNTEUR LIKE ?");
                        cmd.Parameters.Add(BDDatabase.Database.GetParameter("@P" + i.ToString(), titreCommencePar[i].ToUpper() + "%"));
                    }
                }
                SQL.Append("\nORDER BY UPPERNOMEMPRUNTEUR");
                cmd.CommandText = SQL.ToString();
                using (IDataReader result = cmd.ExecuteReader())
                using (BaseDataReader<Emprunteur> dataReader = new BaseDataReader<Emprunteur>(result))
                    if (result != null)
                        dataReader.FillList(this);
            }
        }
    }

    public class ListeEmprunts : List<Emprunt>
    {
        public ListeEmprunts()
            : base()
        {
            //ChargeDonnées(null);
        }

        public ListeEmprunts(string[] titreCommencePar)
            : base()
        {
            ChargeDonnées(titreCommencePar);
        }

        public void ChargeDonnées(string[] titreCommencePar)
        {
            throw new NotImplementedException();
        }
    }

    public class ListeCouvertures : List<Couverture>
    {
        public ListeCouvertures()
            : base()
        {
            //ChargeDonnées(null);
        }

        public ListeCouvertures(string[] titreCommencePar)
            : base()
        {
            ChargeDonnées(titreCommencePar);
        }

        public void ChargeDonnées(string[] titreCommencePar)
        {
            throw new NotImplementedException();
        }
    }
}
