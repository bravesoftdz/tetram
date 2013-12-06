using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using BD.Common.Records;

namespace BD.Common.Lists
{
    public abstract class StoredProcedures
    {
        public static StoredProcedures PS;

        public abstract void ProcAuteurs(ListeAuteurs list, Guid ID_Album, Guid ID_Série, Guid ID_ParaBD);
    }
}
