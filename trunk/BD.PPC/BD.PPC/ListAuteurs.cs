using System;
using System.Collections;
using System.Data;
using System.Text;
using BD.PPC.Database;
using BD.PPC.Records;
using BD.Common.Records;
using TetramCorp.Database;
using TetramCorp.Utilities;

namespace BD.PPC.Lists
{
	/// <summary>
	/// Description résumée de ListAuteurs.
	/// </summary>
	public class ListAuteurs : ArrayList
	{
		public ListAuteurs() : base()
		{
			ChargeDonnées(null);
		}

		public ListAuteurs(string[] titreCommencePar) : base()
		{
			ChargeDonnées(titreCommencePar);
		}
			
		public void ChargeDonnées(string[] titreCommencePar)
		{
			using(new WaitingCursor())
			using(IDbCommand cmd = BDPPCDatabase.GetCommand())
			{
				StringBuilder SQL = new StringBuilder();
				SQL.Append("SELECT REFPERSONNE, NOMPERSONNE FROM PERSONNES");
				if (titreCommencePar != null && titreCommencePar.Length > 0) 
				{
					SQL.Append("\nWHERE");
					for(int i = 0; i < titreCommencePar.Length; i++)
					{
						SQL.Append((i == 0 ? "" : "\nOR") + "\nUPPERNOMPERSONNE LIKE ?");
						cmd.Parameters.Add(BDPPCDatabase.GetParameter("@P" + i.ToString(), titreCommencePar[i].ToUpper() + "%"));
					}
				}
				SQL.Append("\nORDER BY UPPERNOMPERSONNE");
				cmd.CommandText = SQL.ToString();
				using (IDataReader result = cmd.ExecuteReader())
				using (BaseDataReader dataReader = new BaseDataReader(result, typeof(Auteur)))
					if (result != null)
						dataReader.FillList(this);
			}
		}
	}
}