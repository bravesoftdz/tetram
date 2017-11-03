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
			loadData(null);
		}

		public ListAuteurs(string[] TitleStartWith) : base()
		{
			loadData(TitleStartWith);
		}
			
		public void loadData(string[] TitleStartWith)
		{
			using(new WaitCursor())
			using(IDbCommand cmd = BDPPCDatabase.getCommand())
			{
				StringBuilder SQL = new StringBuilder();
				SQL.Append("SELECT REFPERSONNE, NOMPERSONNE FROM PERSONNES");
				if (TitleStartWith != null && TitleStartWith.Length > 0) 
				{
					SQL.Append("\nWHERE");
					for(int i = 0; i < TitleStartWith.Length; i++)
					{
						SQL.Append((i == 0 ? "" : "\nOR") + "\nUPPERNOMPERSONNE LIKE ?");
						cmd.Parameters.Add(BDPPCDatabase.getParameter("@P" + i.ToString(), TitleStartWith[i].ToUpper() + "%"));
					}
				}
				SQL.Append("\nORDER BY UPPERNOMPERSONNE");
				cmd.CommandText = SQL.ToString();
				using (IDataReader result = cmd.ExecuteReader())
				using (BaseDataReader dataReader = new BaseDataReader(result, typeof(Auteur)))
					if (result != null)
						dataReader.fillList(this);
			}
		}
	}
}