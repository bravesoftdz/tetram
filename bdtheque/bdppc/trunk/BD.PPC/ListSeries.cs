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
	/// Description r�sum�e de ListS�ries.
	/// </summary>
	public class ListS�ries : ArrayList
	{
		public ListS�ries() : base()
		{
			ChargeDonn�es(null);
		}

		public ListS�ries(string[] titreCommencePar) : base()
		{
			ChargeDonn�es(titreCommencePar);
		}
			
		public void ChargeDonn�es(string[] titreCommencePar)
		{
			using(new WaitingCursor())
			using(IDbCommand cmd = BDPPCDatabase.GetCommand())
			{
				StringBuilder SQL = new StringBuilder();
        cmd.Parameters.Clear();
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
				using (BaseDataReader<S�rie> dataReader = new BaseDataReader<S�rie>(result))
					if (result != null)
						dataReader.FillList(this);
			}
		}
	}
}
