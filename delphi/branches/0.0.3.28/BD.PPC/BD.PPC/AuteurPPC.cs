using System;
using System.Data;
using BD.Common.Records;
using BD.PPC.Database;
using TetramCorp.Utilities;
using TetramCorp.Database;

namespace BD.PPC.Records
{
	public class AuteurCompletPPC : BD.Common.Records.AuteurComplet
	{
		public AuteurCompletPPC(int Reference) : base(Reference)
		{
		}

		public override void Fill(int Reference) 
		{
			if (Reference == 0) return;
			using(new WaitCursor())
			using(IDbCommand cmd = BDPPCDatabase.getCommand())
			{
				cmd.CommandText = "SELECT REFPERSONNE, NOMPERSONNE, SITEWEB, BIOGRAPHIE FROM PERSONNES WHERE REFPERSONNE = ?";
				cmd.Parameters.Add(BDPPCDatabase.getParameter("@refpersonne", Reference));
				using (IDataReader result = cmd.ExecuteReader())
				using (BaseDataReader dataReader = new BaseDataReader(result, this.GetType()))
					if (result != null && result.Read())
						dataReader.loadData(this);

				// UpperTitreSerie en premier pour forcer l'union à trier sur le titre
				cmd.CommandText = "SELECT UPPERTITRESERIE, s.REFSERIE";
				cmd.CommandText += " FROM ALBUMS al";
				cmd.CommandText += "  INNER JOIN AUTEURS au ON al.refalbum = au.refalbum AND au.refpersonne = ?";
				cmd.CommandText += "  INNER JOIN SERIES s ON s.refserie = al.refserie";
				cmd.CommandText += " union ";
				cmd.CommandText += "SELECT UPPERTITRESERIE, s.REFSERIE";
				cmd.CommandText += " FROM auteurs_series au";
				cmd.CommandText += "  INNER JOIN SERIES s ON s.refserie = au.refserie AND au.refpersonne = ?";
				cmd.Parameters.Add(BDPPCDatabase.getParameter("@refpersonne1", Reference));
				cmd.Parameters.Add(BDPPCDatabase.getParameter("@refpersonne2", Reference));
				Series.Clear();
				using (IDataReader result = cmd.ExecuteReader())
				using (BaseDataReader dataReader = new BaseDataReader(result, typeof(SerieComplet)))
					if (result != null)
						while(result.Read())
							Series.Add(new SerieCompletPPC(dataReader.GetInt(1), this.RefAuteur));
			}
		}
	}
}
