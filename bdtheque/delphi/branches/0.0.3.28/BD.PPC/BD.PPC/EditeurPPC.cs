using System;
using System.Data;
using BD.Common.Records;
using TetramCorp.Utilities;
using TetramCorp.Database;
using BD.PPC.Database;

namespace BD.PPC.Records
{
	public class EditeurCompletPPC : BD.Common.Records.EditeurComplet
	{
		public EditeurCompletPPC(int Reference) : base(Reference) {}
		public EditeurCompletPPC() : base(0) {}

		public override void Fill(int Reference)
		{
			if (Reference == 0) return;
			using(new WaitCursor())
			using(IDbCommand cmd = BDPPCDatabase.getCommand())
			{
				cmd.CommandText = "SELECT REFEDITEUR, NOMEDITEUR, SITEWEB FROM EDITEURS WHERE REFEDITEUR = ?";
				cmd.Parameters.Add(BDPPCDatabase.getParameter("@refediteur", Reference));
				using (IDataReader result = cmd.ExecuteReader())
				using (BaseDataReader dataReader = new BaseDataReader(result, this.GetType()))
					if (result != null && result.Read())
						dataReader.loadData(this);
			}
		}

	}
}
