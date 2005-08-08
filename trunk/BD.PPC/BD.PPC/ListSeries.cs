using System;
using System.Collections;
using System.Data;
using System.Text;
using BD.PPC.Database;
using BD.Common.Records;
using TetramCorp.Database;
using TetramCorp.Utilities;

namespace BD.PPC.Lists
{
	/// <summary>
	/// Description résumée de ListSéries.
	/// </summary>
	public class ListSéries : ArrayList
	{
		public ListSéries() : base()
		{
			ChargeDonnées(null);
		}

		public ListSéries(string[] titreCommencePar) : base()
		{
			ChargeDonnées(titreCommencePar);
		}
			
		public void ChargeDonnées(string[] titreCommencePar)
		{
			using(new WaitingCursor())
			using(IDbCommand cmd = BDPPCDatabase.GetCommand())
			{
			
				StringBuilder SQL = new StringBuilder();
				SQL.Append("SELECT * FROM SERIES S LEFT JOIN EDITEURS E ON S.REFEDITEUR = E.REFEDITEUR LEFT JOIN COLLECTIONS C ON S.REFCOLLECTION=C.REFCOLLECTION");
				if (titreCommencePar != null && titreCommencePar.Length > 0) 
				{
					SQL.Append("\nWHERE");
					for(int i = 0; i < titreCommencePar.Length; i++)
					{
						SQL.Append((i == 0 ? "" : "\nOR") + "\nUPPERTITRESERIE LIKE ?");
						cmd.Parameters.Add(BDPPCDatabase.GetParameter("@P" + i.ToString(), titreCommencePar[i].ToUpper() + "%"));
					}
				}
				SQL.Append("\nORDER BY S.UPPERTITRESERIE");
				cmd.CommandText = SQL.ToString();
				using (IDataReader result = cmd.ExecuteReader())
				using (BaseDataReader dataReader = new BaseDataReader(result, typeof(Série)))
					if (result != null)
						dataReader.FillList(this);
			}
		}
	}
}
