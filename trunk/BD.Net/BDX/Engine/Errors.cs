using System;
using System.Collections.Generic;
using System.Text;

namespace BDX.Engine
{
    public class D3DException : System.ApplicationException { }

    public class NoCompatibleDevicesException : D3DException
    {
        public override string Message
        {
            get
            {
                return
                      "Impossible de trouver un mode grahique à utiliser.\n"
                    + "Changez vos paramètres d'affichage et réessayez.";
            }
        }
    }
}
