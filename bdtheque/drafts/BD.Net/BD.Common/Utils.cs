using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using BD.Common.Database;
using System.Data;
using TetramCorp.Utilities;
using System.IO;

namespace BD.Common
{
    public sealed class Utils
    {
        public static Image LoadCouverture(bool isParaBD, Guid ID_Couverture)
        {
            using (IDbCommand cmd = BDDatabase.Database.GetCommand())
            {
                IDataReader result;

                if (isParaBD)
                    cmd.CommandText = "SELECT IMAGEPARABD, STOCKAGEPARABD, FichierParaBD FROM ParaBD WHERE ID_ParaBD = ?";
                else
                    cmd.CommandText = "SELECT IMAGECOUVERTURE, STOCKAGECOUVERTURE, FichierCouverture FROM Couvertures WHERE ID_Couverture = ?";
                cmd.Parameters.Clear();
                cmd.Parameters.Add(BDDatabase.Database.GetParameter("@ID_Image", StringUtils.GuidToString(ID_Couverture)));
                result = cmd.ExecuteReader();

                if (result == null || !result.Read() || result.IsDBNull(0)) return null;
                if (!result.GetBoolean(0))
                {
                    string fichier = Path.GetFileName(result.GetString(2));
                    string chemin = Path.GetFullPath(result.GetString(2));
                    if (chemin.Equals(string.Empty)) chemin = ""; // repimages

                    cmd.CommandText = "SELECT BlobContent FROM LOADBLOBFROMFILE(?, ?)";
                    cmd.Parameters.Clear();
                    cmd.Parameters.Add(BDDatabase.Database.GetParameter("@Chemin", chemin));
                    cmd.Parameters.Add(BDDatabase.Database.GetParameter("@Fichier", fichier));
                    result = cmd.ExecuteReader();

                    if (result == null || !result.Read() || result.IsDBNull(0)) return null;
                }

                Stream stream = new MemoryStream();
                long len = result.GetBytes(0, 0, null, 0, 0);
                Byte[] buffer = new Byte[len];
                result.GetBytes(0, 0, buffer, 0, (int)len);
                return Image.FromStream(new MemoryStream(buffer));
            }
        }

    }
}
