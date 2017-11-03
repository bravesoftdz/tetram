using System.Windows.Forms;
using System.Drawing;
using System;
using System.Text;
using System.Data;
using BD.PPC.Database;
using System.Reflection;
using System.Data.SqlServerCe;

namespace BD.PPC.Application
{
	internal class ClassMain
	{
		private static SplashForm splash = null;
		public static Repertoire mainform;

		private static void CloseSplash()
		{
			if (splash == null) return;
			splash.Invoke(new EventHandler(splash.KillMe));
			splash.Dispose();
			splash = null;
		}

		static void Main() 
		{
			try
			{
				splash = new SplashForm();
				splash.Show();

				splash.Label = "Connexion � la base...";
				splash.Label = "V�rification des versions...";
				if (!checkVersion()) throw new Exception("Erreur de version");
				splash.Label = "Cr�ation de la fen�tre principale...";
				mainform = new Repertoire(); 

				System.Threading.Thread splashClose = new System.Threading.Thread(new System.Threading.ThreadStart(CloseSplash));
				splashClose.Start();
				System.Windows.Forms.Application.Run(mainform);
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

		public static IDbConnection Database
		{
			get 
			{
				return BDPPCDatabase.DBConnection.Connection;
			}
		}

		public static bool checkVersion()
		{
			return checkVersion(true);
		}

		public static bool checkVersion(bool Force)
		{
			using(IDbCommand cmd = BDPPCDatabase.getCommand())
			{
				cmd.CommandText = "SELECT VALEUR FROM OPTIONS WHERE Nom_option = 'Version'";
				string version = (string) cmd.ExecuteScalar();
				Assembly assembly = Assembly.GetExecutingAssembly();
				if (version == null)
				{
					version = "0.0.0.0";
					cmd.CommandText = "INSERT INTO OPTIONS (Nom_Option, Valeur) VALUES ('Version', ?)";
					cmd.Parameters.Add(BDPPCDatabase.getParameter("@version", version));
					try
					{
						cmd.ExecuteNonQuery();
					}
					catch
					{
					}
				}

				string msg = "BDth�que ne peut pas utiliser cette base de donn�es.\nVersion de la base de donn�es: " + version;
			
				int compareValue = assembly.GetName().Version.CompareTo(new Version(version));
				if (compareValue < 0)
				{
					MessageBox.Show(msg);
					return false;
				}

				if (compareValue > 0) 
				{
					if (!(Force || MessageBox.Show(msg + "\nVoulez-vous la mettre � jour?", "BDPPC", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button1) == DialogResult.Yes)) 
						return false;

					// process de mise � jour � mettre ici

					cmd.CommandText = "UPDATE OPTIONS SET Valeur = ? WHERE Nom_Option = 'Version'";
					cmd.Parameters.Add(BDPPCDatabase.getParameter("@version", assembly.GetName().Version.ToString()));
					cmd.ExecuteNonQuery();
					if (!Force) MessageBox.Show("Mise � jour termin�e");
				}
			}
			return true;
		}
}
}
