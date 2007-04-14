using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using FirebirdSql.Data.FirebirdClient;
using BD.Common.Database;

namespace BD.Workstation.Database
{
    internal class BDWSDatabase : BDDatabase
    {
        private FbConnection _DBConnection = new FbConnection();
        private FbConnectionStringBuilder DBConnectionString = new FbConnectionStringBuilder(Properties.Settings.Default.bdConnectionString);

        public BDWSDatabase()
		{
		}

        public override IDataParameter GetParameter(string nomParamètre, object value)
        {
            return new FbParameter(nomParamètre, value);
        }

        public override IDbCommand GetCommand()
        {
            return Connection.CreateCommand();
        }
        
        public override void RefreshConnection()
        {
            _DBConnection.Close();
            DBConnectionString.Database = Properties.Settings.Default.database;
            DBConnectionString.DataSource = Properties.Settings.Default.dbserver;
            DBConnectionString.ServerType = Properties.Settings.Default.dbservertype;
            DBConnectionString.UserID = Properties.Settings.Default.dbusername;
            DBConnectionString.Password = Properties.Settings.Default.dbuserpassword;
            _DBConnection.ConnectionString = DBConnectionString.ToString();
            _DBConnection.Open();
        }

        public IDbConnection Connection
        {
            get 
            {
                if ((_DBConnection.State == System.Data.ConnectionState.Broken) || (_DBConnection.State == System.Data.ConnectionState.Closed))
                    RefreshConnection();
                return _DBConnection; 
            }
        }
    
    }
}
