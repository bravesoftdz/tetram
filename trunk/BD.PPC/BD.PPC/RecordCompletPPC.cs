using System;
using System.Data;
using System.Collections;
using BD.Common.Records;
using BD.PPC.Database;
using TetramCorp.Utilities;
using TetramCorp.Database;

namespace BD.PPC.Records
{
  public class EditeurCompletPPC : BD.Common.Records.EditeurComplet
	{
    public override void Fill(params object[] references)
    {
      if (references.Length < 1) return;
      int reference = (int)references[0];
      if (reference == 0) return;
      using (new WaitingCursor())
      using (IDbCommand cmd = BDPPCDatabase.GetCommand())
      {
        cmd.CommandText = "SELECT REFEDITEUR, NOMEDITEUR, SITEWEB FROM EDITEURS WHERE REFEDITEUR = ?";
        cmd.Parameters.Clear();
        cmd.Parameters.Add(BDPPCDatabase.GetParameter("@refediteur", reference));
        using (IDataReader result = cmd.ExecuteReader())
        using (BaseDataReader<EditeurComplet> dataReader = new BaseDataReader<EditeurComplet>(result))
          if (result != null && result.Read())
            dataReader.LoadData(this);
      }
    }
  }

	public class AuteurCompletPPC : BD.Common.Records.AuteurComplet
	{
    public override void Fill(params object[] references)
    {
      if (references.Length < 1) return;
      int reference = (int)references[0];
      if (reference == 0) return;
      using (new WaitingCursor())
      using (IDbCommand cmd = BDPPCDatabase.GetCommand())
      {
        cmd.CommandText = "SELECT REFPERSONNE, NOMPERSONNE, SITEWEB, BIOGRAPHIE FROM PERSONNES WHERE REFPERSONNE = ?";
        cmd.Parameters.Clear();
        cmd.Parameters.Add(BDPPCDatabase.GetParameter("@refpersonne", reference));
        using (IDataReader result = cmd.ExecuteReader())
        using (BaseDataReader<AuteurComplet> dataReader = new BaseDataReader<AuteurComplet>(result))
          if (result != null && result.Read())
            dataReader.LoadData(this);

        // UpperTitreSerie en premier pour forcer l'union à trier sur le titre
        cmd.CommandText = "SELECT UPPERTITRESERIE, s.REFSERIE";
        cmd.CommandText += " FROM ALBUMS al";
        cmd.CommandText += "  INNER JOIN AUTEURS au ON al.refalbum = au.refalbum AND au.refpersonne = ?";
        cmd.CommandText += "  INNER JOIN SERIES s ON s.refserie = al.refserie";
        cmd.CommandText += " union ";
        cmd.CommandText += "SELECT UPPERTITRESERIE, s.REFSERIE";
        cmd.CommandText += " FROM auteurs_series au";
        cmd.CommandText += "  INNER JOIN SERIES s ON s.refserie = au.refserie AND au.refpersonne = ?";
        cmd.Parameters.Clear();
        cmd.Parameters.Add(BDPPCDatabase.GetParameter("@refpersonne1", reference));
        cmd.Parameters.Add(BDPPCDatabase.GetParameter("@refpersonne2", reference));
        this.Séries.Clear();
        using (IDataReader result = cmd.ExecuteReader())
        using (BaseDataReader<object> dataReader = new BaseDataReader<object>(result))
          if (result != null)
            while (result.Read())
              this.Séries.Add(BaseRecord.Create<SérieCompletPPC>(dataReader.GetInt(1), this.RefAuteur));
      }
    }
	}

	public class SérieCompletPPC : BD.Common.Records.SérieComplet
	{
    public override void Fill(params object[] references)
    {
      if (references.Length < 1) return;
      int reference = (int)references[0];
      if (reference == 0) return;
      if (references.Length > 1)
        this.FIdAuteur = (int)references[1];
      else
        this.FIdAuteur = -1;
      using (new WaitingCursor())
      using (IDbCommand cmd = BDPPCDatabase.GetCommand())
      {
        cmd.CommandText = "SELECT REFSERIE, TITRESERIE, TERMINEE, SUJETSERIE, REMARQUESSERIE, SITEWEB, S.REFEDITEUR, S.REFCOLLECTION, NOMCOLLECTION "
          + "FROM SERIES S LEFT JOIN COLLECTIONS C ON S.REFCOLLECTION = C.REFCOLLECTION "
          + "WHERE REFSERIE = ?";
        cmd.Parameters.Clear();
        cmd.Parameters.Add(BDPPCDatabase.GetParameter("@refserie", reference));
        using (IDataReader result = cmd.ExecuteReader())
        using (BaseDataReader<SérieComplet> dataReader = new BaseDataReader<SérieComplet>(result))
          if (result != null && result.Read())
          {
            dataReader.LoadData(this);
            this.Terminée = dataReader.GetInt(2, -1);
            this.Editeur.Fill(this.Editeur.Reference);
          }

        cmd.CommandText = "SELECT REFALBUM, TITREALBUM, INTEGRALE, HORSSERIE, TOME, TOMEDEBUT, TOMEFIN, REFSERIE "
          + "FROM ALBUMS "
          + "WHERE REFSERIE = ? ";
        if (this.FIdAuteur != -1)
          cmd.CommandText += "AND REFALBUM IN (SELECT REFALBUM FROM AUTEURS WHERE REFPERSONNE = ?) ";
        cmd.CommandText += "ORDER BY COALESCE(HORSSERIE, -1), COALESCE(INTEGRALE, -1), COALESCE(TOME, -1)";
        cmd.Parameters.Clear();
        cmd.Parameters.Add(BDPPCDatabase.GetParameter("@RefSerie", reference));
        if (this.FIdAuteur != -1)
          cmd.Parameters.Add(BDPPCDatabase.GetParameter("@FIdAuteur", this.FIdAuteur));

        using (IDataReader result = cmd.ExecuteReader())
        using (BaseDataReader<Album> dataReader = new BaseDataReader<Album>(result))
          if (result != null)
            dataReader.FillList(this.Albums);

        cmd.CommandText = "SELECT Genre "
          + "FROM GenreSeries s INNER JOIN Genres g ON g.RefGenre = s.RefGenre "
          + "WHERE RefSerie = ?";
        cmd.Parameters.Clear();
        cmd.Parameters.Add(BDPPCDatabase.GetParameter("@RefSerie", reference));
        this.Genres.Clear();
        using (IDataReader result = cmd.ExecuteReader())
        using (BaseDataReader<object> dataReader = new BaseDataReader<object>(result))
          while (result.Read())
            this.Genres.Add(dataReader.GetString(0, string.Empty));

        ArrayList Auteurs = new ArrayList();
        StoredProceduresPPC.ProcAuteurs(Auteurs, -1, reference);
        this.Scénaristes.Clear();
        this.Dessinateurs.Clear();
        this.Coloristes.Clear();
        foreach (Auteur auteur in Auteurs)
          switch (auteur.Metier)
          {
            case 0:
              {
                this.Scénaristes.Add(auteur);
                break;
              }
            case 1:
              {
                this.Dessinateurs.Add(auteur);
                break;
              }
            case 2:
              {
                this.Coloristes.Add(auteur);
                break;
              }
          }
      }
    }
  }
}
