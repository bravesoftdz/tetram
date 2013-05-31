using System;
using System.Collections;
using System.Data;
using BD.Workstation.Database;
using BD.Common.Records;
using BD.Common;
using TetramCorp.Database;
using TetramCorp.Utilities;
using System.Collections.Generic;
using BD.Common.Database;
using BD.Common.Lists;

namespace BD.Workstation.Lists
{
    sealed class StoredProceduresWS : StoredProcedures
    {
        public StoredProceduresWS() { }

        public override void ProcAuteurs(ListeAuteurs list, Guid ID_Album, Guid ID_Série, Guid ID_ParaBD)
        {
            using (new WaitingCursor())
            using (IDbCommand cmd = BDDatabase.Database.GetCommand())
            {
                    cmd.CommandText = "select id_personne, nompersonne, id_album, id_serie, id_parabd, metier from proc_auteurs(?, ?, ?)";
                    cmd.Parameters.Clear();
                    cmd.Parameters.Add(BDDatabase.Database.GetParameter("@ID_Album", StringUtils.GuidToString(ID_Album)));
                    cmd.Parameters.Add(BDDatabase.Database.GetParameter("@ID_Serie", StringUtils.GuidToString(ID_Série)));
                    cmd.Parameters.Add(BDDatabase.Database.GetParameter("@ID_ParaBD", StringUtils.GuidToString(ID_ParaBD)));

                    using (IDataReader result = cmd.ExecuteReader())
                    using (BaseDataReader<Auteur> dataReader = new BaseDataReader<Auteur>(result))
                        if (result != null)
                            dataReader.FillList(list);
            }
        }
    }
}
