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
	/// Description résumée de Proc_Auteurs.
	/// </summary>
	public class StoredProcedures
	{
		public static void Proc_Auteurs(ArrayList list, int RefAlbum, int RefSerie)
		{
			using(new WaitCursor())
			using(IDbCommand cmd = BDPPCDatabase.getCommand())
			{
				if (RefAlbum != -1) 
				{
					cmd.CommandText = "select p.refpersonne, p.nompersonne, a.refalbum, NULL as refserie, a.metier "
						+ "from personnes p inner join auteurs a on a.refpersonne = p.refpersonne "
						+ "where a.refalbum = ? "
						+ "order by a.metier, p.uppernompersonne";
					cmd.Parameters.Add(BDPPCDatabase.getParameter("@RefAlbum", RefAlbum));

					using (IDataReader result = cmd.ExecuteReader())
					using (BaseDataReader dataReader = new BaseDataReader(result, typeof(Auteur)))
						if (result != null)
							dataReader.fillList(list);
				}
			
				if (RefSerie != -1) 
				{
					cmd.CommandText = "select p.refpersonne, p.nompersonne, NULL as refalbum, a.refserie, a.metier "
						+ "from personnes p inner join auteurs_series a on a.refpersonne = p.refpersonne "
						+ "where a.refserie = ? "
						+ "order by a.metier, p.uppernompersonne";
					cmd.Parameters.Add(BDPPCDatabase.getParameter("@RefSerie", RefSerie));

					using (IDataReader result = cmd.ExecuteReader())
					using (BaseDataReader dataReader = new BaseDataReader(result, typeof(Auteur)))
						if (result != null)
							dataReader.fillList(list);
				}
			}
		}
	}
}
