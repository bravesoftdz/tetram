using System;
using System.Data;
using System.Collections.Generic;
using System.Text;

namespace BD.Common.Database
{
    public abstract class BDDatabase
    {
        public static BDDatabase Database;

        public abstract IDataParameter GetParameter(string nomParamètre, object value);
        public abstract IDbCommand GetCommand();
        public abstract void RefreshConnection();
    }
}
