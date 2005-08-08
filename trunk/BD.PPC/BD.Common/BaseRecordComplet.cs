using System;
using TetramCorp.Database;

namespace BD.Common.Records
{
//  on ne met pas le paramètre pour que NewInstance retourne null = equivalent d'une classe abstract
//	[ClassFactory(typeof(BaseRecordComplet))]
	public class RecordCompletFactory : BaseRecordFactory	{	}
	
	public class BaseRecordComplet : BaseRecord	{	}
}
