using System;
using System.Collections.Generic;
using System.Text;
using BD.Common.Records;
using System.Data;
using BD.Common.Database;
using TetramCorp.Utilities;
using TetramCorp.Database;
using System.ComponentModel;

namespace BD.Common.Lists
{
    public class ListeEdition : List<Edition>
    { }

    public class ListeEditionComplet : List<EditionComplet>
    {
        public void Fill(Guid ID_Album)
        {
            Fill(ID_Album, -1);
        }

        public void Fill(Guid ID_Album, int Stock)
        {
            Clear();
            using (IDbCommand cmd = BDDatabase.Database.GetCommand())
            {
                cmd.CommandText = "SELECT ID_Edition FROM EDITIONS WHERE ID_Album = ?";
                if (Stock == 0 || Stock == 1) cmd.CommandText += "AND e.STOCK = ?";
                cmd.Parameters.Clear();
                cmd.Parameters.Add(BDDatabase.Database.GetParameter("@ID_album", StringUtils.GuidToString(ID_Album)));
                if (Stock == 0 || Stock == 1)
                    cmd.Parameters.Add(BDDatabase.Database.GetParameter("@Stock", Stock));

                using (IDataReader result = cmd.ExecuteReader())
                using (BaseDataReader<EditionComplet> dataReader = new BaseDataReader<EditionComplet>(result))
                    while (result != null && result.Read())
                        Add(BaseRecordComplet.Create<EditionComplet>(dataReader.GetGuid(0)) as EditionComplet);
            }
        }

    }

}
