using System;
using System.Data;
using System.Collections;
using BD.Common.Records;
using BD.PPC.Database;
using TetramCorp.Utilities;
using TetramCorp.Database;

namespace BD.PPC.Records
{

	public class SerieCompletPPC : BD.Common.Records.SerieComplet
	{
		public SerieCompletPPC(int Reference) : base(Reference)
		{
		}

		public SerieCompletPPC(int refSerie, int refAuteur) : base(refSerie, refAuteur)
		{
		}

		public override void InitializeInstance() 
		{
			base.InitializeInstance ();
			Editeur = new EditeurCompletPPC();
		}


		public override void Fill(int Reference)
		{
			if (Reference == 0) return;
			using(new WaitCursor())
			using(IDbCommand cmd = BDPPCDatabase.getCommand())
			{
				cmd.CommandText = "SELECT REFSERIE, TITRESERIE, TERMINEE, SUJETSERIE, REMARQUESSERIE, SITEWEB, S.REFEDITEUR, S.REFCOLLECTION, NOMCOLLECTION "
					+ "FROM SERIES S LEFT JOIN COLLECTIONS C ON S.REFCOLLECTION = C.REFCOLLECTION "
					+ "WHERE REFSERIE = ?";
				cmd.Parameters.Add(BDPPCDatabase.getParameter("@refserie", Reference));
				using (IDataReader result = cmd.ExecuteReader())
				using (BaseDataReader dataReader = new BaseDataReader(result, this.GetType()))
					if (result != null && result.Read())
					{
						dataReader.loadData(this);
						Terminee = dataReader.GetInt(2, -1);
						Editeur.Fill();
					}

				cmd.CommandText = "SELECT REFALBUM, TITREALBUM, INTEGRALE, HORSSERIE, TOME, TOMEDEBUT, TOMEFIN, REFSERIE "
					+ "FROM ALBUMS "
					+ "WHERE REFSERIE = ? ";
				if (FIdAuteur != -1) 
					cmd.CommandText += "AND REFALBUM IN (SELECT REFALBUM FROM AUTEURS WHERE REFPERSONNE = ?) ";
				cmd.CommandText += "ORDER BY COALESCE(HORSSERIE, -1), COALESCE(INTEGRALE, -1), COALESCE(TOME, -1)";
				cmd.Parameters.Clear();
				cmd.Parameters.Add(BDPPCDatabase.getParameter("@RefSerie", Reference));
				if (FIdAuteur != -1) 
					cmd.Parameters.Add(BDPPCDatabase.getParameter("@FIdAuteur", FIdAuteur));

				using (IDataReader result = cmd.ExecuteReader())
				using (BaseDataReader dataReader = new BaseDataReader(result, typeof(Album)))
					if (result != null)
						dataReader.fillList(Albums);

				cmd.CommandText = "SELECT Genre "
					+ "FROM GenreSeries s INNER JOIN Genres g ON g.RefGenre = s.RefGenre "
					+ "WHERE RefSerie = ?";
				cmd.Parameters.Clear();
				cmd.Parameters.Add(BDPPCDatabase.getParameter("@RefSerie", Reference));
				Genres.Clear();
				using (IDataReader result = cmd.ExecuteReader())
				using (BaseDataReader dataReader = new BaseDataReader(result, null))
					while(result.Read())
						Genres.Add(dataReader.GetString(0, string.Empty));

				ArrayList Auteurs = new ArrayList();
				StoredProcedures.Proc_Auteurs(Auteurs, -1, Reference);
				Scenaristes.Clear();
				Dessinateurs.Clear();
				Coloristes.Clear();
				foreach(Auteur auteur in Auteurs) 
					switch (auteur.Metier)
					{
						case 0:
						{ 
							Scenaristes.Add(auteur);
							break;
						}
						case 1:
						{
							Dessinateurs.Add(auteur);
							break;
						}
						case 2:
						{ 
							Coloristes.Add(auteur);
							break;
						}
					}
			}
		}
	}
}
