using System.Windows.Forms;
using System;
using System.Data.SqlServerCe;
using System.Text;

namespace CreateStructureBDPPC
{
	public class ClassMain
	{

		/// <summary>
		/// Point d'entrée principal de l'application.
		/// </summary>
		static void Main() 
		{
			try
			{
				Application.Run(new Form1());
			}
			catch (SqlCeException e) 
			{
				SqlCeErrorCollection errorCollection = e.Errors;

				StringBuilder bld = new StringBuilder();
				Exception   inner = e.InnerException;

				if (null != inner) 
				{
					MessageBox.Show("Inner Exception: " + inner.ToString());
				}

				foreach (SqlCeError err in errorCollection) 
				{
					bld.Append("\n Error Code: " + err.HResult.ToString("X"));
					bld.Append("\n Message   : " + err.Message);
					bld.Append("\n Minor Err.: " + err.NativeError);
					bld.Append("\n Source    : " + err.Source);
            
					foreach (int numPar in err.NumericErrorParameters) 
					{
						if (0 != numPar) bld.Append("\n Num. Par. : " + numPar);
					}
            
					foreach (string errPar in err.ErrorParameters) 
					{
						if (String.Empty != errPar) bld.Append("\n Err. Par. : " + errPar);
					}

					MessageBox.Show(bld.ToString());
					bld.Remove(0, bld.Length);
				}
			}
			catch (Exception ex)
			{
				MessageBox.Show(ex.Message);
			}
		}
	}
}
