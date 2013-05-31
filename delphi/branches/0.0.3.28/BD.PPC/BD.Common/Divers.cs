using System.Collections;
using System.Text;

namespace BD.Common.Records
{
	public class GenreList : ArrayList
	{
		public override string ToString()
		{
			StringBuilder result = new StringBuilder();
			for(int i = 0; i < this.Count; i++)
				result.Append((i == 0? "" : ", ") + this[i]);
							
			return result.ToString ();
		}

	}
}
 

 