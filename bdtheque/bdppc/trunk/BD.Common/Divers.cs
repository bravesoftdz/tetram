using System.Collections;
using System.Text;

namespace BD.Common.Records
{
	public class GenreCollection : ArrayList
	{
		new public string this[int index]
		{
			get 
			{
				return (string) ((IList)this)[index];
			}
			set 
			{
				((IList)this)[index] =  value;
			}
		}

		public int Add(string value)
		{
			return ((IList)this).Add ((object) value);
		}

		public bool Contains(string value) 
		{
			return ((IList)this).Contains((object) value);
		}

		public void Insert(int index, string value) 
		{
			((IList)this).Insert(index, (object) value);
		}

		public void Remove(string value) 
		{
			((IList)this).Remove((object) value);
		}

		public int IndexOf(string value) 
		{
			return ((IList)this).IndexOf((object) value);
		}

		public void CopyTo(string[] array, int index)
		{
			((ICollection)this).CopyTo(array, index);
		}

		public override string ToString()
		{
			StringBuilder result = new StringBuilder();
			for(int i = 0; i < this.Count; i++)
				result.Append((i == 0? "" : ", ") + this[i]);
							
			return result.ToString ();
		}

	}
}
 

 