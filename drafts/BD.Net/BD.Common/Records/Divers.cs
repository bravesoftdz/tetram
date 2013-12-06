using System.Collections;
using System.Text;
using System.Collections.Generic;

namespace BD.Common.Records
{
	public class GenreSerie : List<string>
	{
		public override string ToString()
		{
			StringBuilder result = new StringBuilder();
			for(int i = 0; i < this.Count; i++)
				result.Append((i == 0 ? "" : ", ") + this[i]);
							
			return result.ToString ();
		}

        public string Genres
        {
            get { return ToString(); }
        }

	}
}
 

 