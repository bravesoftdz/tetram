using System;
using System.Collections.Generic;
using System.Text;

namespace BD.Common
{
    public class WSFramework
    {
        public static void InitFramework()
        {
            BD.Common.Database.BDDatabase.Database = new BD.Workstation.Database.BDWSDatabase();
            BD.Common.Lists.StoredProcedures.PS = new BD.Workstation.Lists.StoredProceduresWS();
        }
    }
}
