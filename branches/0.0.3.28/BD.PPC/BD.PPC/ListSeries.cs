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
	/// Description résumée de ListSeries.
	/// </summary>
	public class ListSeries : ArrayList
	{
		public ListSeries() : base()
		{
			loadData(null);
		}

		public ListSeries(string[] TitleStartWith) : base()
		{
			loadData(TitleStartWith);
		}
			
		public void loadData(string[] TitleStartWith)
		{
			using(new WaitCursor())
			using(IDbCommand cmd = BDPPCDatabase.getCommand())
			{
			
				StringBuilder SQL = new StringBuilder();
				SQL.Append("SELECT * FROM SERIES S LEFT JOIN EDITEURS E ON S.REFEDITEUR = E.REFEDITEUR LEFT JOIN COLLECTIONS C ON S.REFCOLLECTION=C.REFCOLLECTION");
				if (TitleStartWith != null && TitleStartWith.Length > 0) 
				{
					SQL.Append("\nWHERE");
					for(int i = 0; i < TitleStartWith.Length; i++)
					{
						SQL.Append((i == 0 ? "" : "\nOR") + "\nUPPERTITRESERIE LIKE ?");
						cmd.Parameters.Add(BDPPCDatabase.getParameter("@P" + i.ToString(), TitleStartWith[i].ToUpper() + "%"));
					}
				}
				SQL.Append("\nORDER BY S.UPPERTITRESERIE");
				cmd.CommandText = SQL.ToString();
				using (IDataReader result = cmd.ExecuteReader())
				using (BaseDataReader dataReader = new BaseDataReader(result, typeof(Serie)))
					if (result != null)
						dataReader.fillList(this);
			}
		}
	}
}
