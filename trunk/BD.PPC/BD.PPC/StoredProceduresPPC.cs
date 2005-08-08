using System;
using System.Collections;
using System.Data;
using BD.PPC.Database;
using BD.Common.Records;
using TetramCorp.Database;
using TetramCorp.Utilities;

namespace BD.PPC.Records
{
	/// <summary>
	/// Emule les procédures stockées qui ne sont pas disponibles avec SQLServerCE.
	/// </summary>
	public sealed class StoredProceduresPPC
	{
		private StoredProceduresPPC() {}

		public static void ProcAuteurs(ArrayList list, int refAlbum, int refSérie)
		{
			using(new WaitingCursor())
			using(IDbCommand cmd = BDPPCDatabase.GetCommand())
			{
				if (refAlbum != -1) 
				{
					cmd.CommandText = "select p.refpersonne, p.nompersonne, a.refalbum, NULL as refserie, a.metier "
						+ "from personnes p inner join auteurs a on a.refpersonne = p.refpersonne "
						+ "where a.refalbum = ? "
						+ "order by a.metier, p.uppernompersonne";
					cmd.Parameters.Add(BDPPCDatabase.GetParameter("@RefAlbum", refAlbum));

					using (IDataReader result = cmd.ExecuteReader())
					using (BaseDataReader dataReader = new BaseDataReader(result, typeof(Auteur)))
						if (result != null)
							dataReader.FillList(list);
				}
			
				if (refSérie != -1) 
				{
					cmd.CommandText = "select p.refpersonne, p.nompersonne, NULL as refalbum, a.refserie, a.metier "
						+ "from personnes p inner join auteurs_series a on a.refpersonne = p.refpersonne "
						+ "where a.refserie = ? "
						+ "order by a.metier, p.uppernompersonne";
					cmd.Parameters.Add(BDPPCDatabase.GetParameter("@RefSerie", refSérie));

					using (IDataReader result = cmd.ExecuteReader())
					using (BaseDataReader dataReader = new BaseDataReader(result, typeof(Auteur)))
						if (result != null)
							dataReader.FillList(list);
				}
			}
		}
	}
}
