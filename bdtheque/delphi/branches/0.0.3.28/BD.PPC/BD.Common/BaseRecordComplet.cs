using System;
using TetramCorp.Database;

namespace BD.Common.Records
{
	public class BaseRecordComplet : BaseRecord
	{
		public BaseRecordComplet()
		{
			InitializeInstance();
		}

		public BaseRecordComplet(int Reference) : this()
		{
			Fill(Reference);
		}

		public virtual void InitializeInstance()
		{
		}

		public virtual void Fill(int Reference)
		{
		}

		public static void test()
		{
		}

	}
}
