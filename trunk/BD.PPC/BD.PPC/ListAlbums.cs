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
  public class ListAlbums : ArrayList
	{
		public ListAlbums() : base()
		{
			ChargeDonnées(null);
		}

		public ListAlbums(string[] titreCommencePar) : base()
		{
			ChargeDonnées(titreCommencePar);
		}
			
		public void ChargeDonnées(string[] titreCommencePar)
		{
			using(new WaitingCursor())
			using(IDbCommand cmd = BDPPCDatabase.GetCommand())
			{
				StringBuilder SQL = new StringBuilder();
        cmd.Parameters.Clear();
        SQL.Append("SELECT * FROM ALBUMS A INNER JOIN SERIES S ON A.REFSERIE = S.REFSERIE");
				if (titreCommencePar != null && titreCommencePar.Length > 0) 
				{
					SQL.Append("\nWHERE");
					for(int i = 0; i < titreCommencePar.Length; i++)
					{
						SQL.Append((i == 0 ? "" : "\nOR") + "\nUPPERTITREALBUM LIKE ?");
						cmd.Parameters.Add(BDPPCDatabase.GetParameter("@P" + i.ToString(), titreCommencePar[i].ToUpper() + "%"));
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
}
