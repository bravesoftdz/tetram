using System;
using System.Data;
using System.Collections;
using BD.Common.Records;
using BD.PPC.Database;
using TetramCorp.Database;
using TetramCorp.Utilities;

namespace BD.PPC.Records
{
  //public class AuteurCompletFactoryPPC : AuteurCompletFactory
  //{
  //  public override void Fill(BaseRecord record, int reference) 
  //  {
  //    if (reference == 0) return;
  //    AuteurComplet auteur = (AuteurComplet)record;
  //    using(new WaitingCursor())
  //    using(IDbCommand cmd = BDPPCDatabase.GetCommand())
  //    {
  //      cmd.CommandText = "SELECT REFPERSONNE, NOMPERSONNE, SITEWEB, BIOGRAPHIE FROM PERSONNES WHERE REFPERSONNE = ?";
  //      cmd.Parameters.Clear();
  //      cmd.Parameters.Add(BDPPCDatabase.GetParameter("@refpersonne", reference));
  //      using (IDataReader result = cmd.ExecuteReader())
  //      using (BaseDataReader dataReader = new BaseDataReader(result, auteur.GetType()))
  //        if (result != null && result.Read())
  //          dataReader.LoadData(auteur);

  //      // UpperTitreSerie en premier pour forcer l'union à trier sur le titre
  //      cmd.CommandText = "SELECT UPPERTITRESERIE, s.REFSERIE";
  //      cmd.CommandText += " FROM ALBUMS al";
  //      cmd.CommandText += "  INNER JOIN AUTEURS au ON al.refalbum = au.refalbum AND au.refpersonne = ?";
  //      cmd.CommandText += "  INNER JOIN SERIES s ON s.refserie = al.refserie";
  //      cmd.CommandText += " union ";
  //      cmd.CommandText += "SELECT UPPERTITRESERIE, s.REFSERIE";
  //      cmd.CommandText += " FROM auteurs_series au";
  //      cmd.CommandText += "  INNER JOIN SERIES s ON s.refserie = au.refserie AND au.refpersonne = ?";
  //      cmd.Parameters.Clear();
  //      cmd.Parameters.Add(BDPPCDatabase.GetParameter("@refpersonne1", reference));
  //      cmd.Parameters.Add(BDPPCDatabase.GetParameter("@refpersonne2", reference));
  //      auteur.Séries.Clear();
  //      using (IDataReader result = cmd.ExecuteReader())
  //      using (BaseDataReader dataReader = new BaseDataReader(result, null))
  //        if (result != null)
  //          while(result.Read())
  //            auteur.Séries.Add((new SérieCompletFactoryPPC()).NewInstance(dataReader.GetInt(1), auteur.RefAuteur));
  //    }
  //  }
  //}

  //[ClassFactory(typeof(SérieCompletPPC))]
  //public class SérieCompletFactoryPPC : SérieCompletFactory
  //{
  //  public override void Fill(BaseRecord record, int reference)
  //  {
  //    if (reference == 0) return;
  //    SérieComplet serie = (SérieComplet)record;
  //    using(new WaitingCursor())
  //    using(IDbCommand cmd = BDPPCDatabase.GetCommand())
  //    {
  //      cmd.CommandText = "SELECT REFSERIE, TITRESERIE, TERMINEE, SUJETSERIE, REMARQUESSERIE, SITEWEB, S.REFEDITEUR, S.REFCOLLECTION, NOMCOLLECTION "
  //        + "FROM SERIES S LEFT JOIN COLLECTIONS C ON S.REFCOLLECTION = C.REFCOLLECTION "
  //        + "WHERE REFSERIE = ?";
  //      cmd.Parameters.Clear();
  //      cmd.Parameters.Add(BDPPCDatabase.GetParameter("@refserie", reference));
  //      using (IDataReader result = cmd.ExecuteReader())
  //      using (BaseDataReader dataReader = new BaseDataReader(result, serie.GetType()))
  //        if (result != null && result.Read())
  //        {
  //          dataReader.LoadData(serie);
  //          serie.Terminée = dataReader.GetInt(2, -1);
  //          (new EditeurCompletFactoryPPC()).Fill(serie.Editeur, serie.Editeur.Reference);
  //        }

  //      cmd.CommandText = "SELECT REFALBUM, TITREALBUM, INTEGRALE, HORSSERIE, TOME, TOMEDEBUT, TOMEFIN, REFSERIE "
  //        + "FROM ALBUMS "
  //        + "WHERE REFSERIE = ? ";
  //      if (serie.FIdAuteur != -1) 
  //        cmd.CommandText += "AND REFALBUM IN (SELECT REFALBUM FROM AUTEURS WHERE REFPERSONNE = ?) ";
  //      cmd.CommandText += "ORDER BY COALESCE(HORSSERIE, -1), COALESCE(INTEGRALE, -1), COALESCE(TOME, -1)";
  //      cmd.Parameters.Clear();
  //      cmd.Parameters.Add(BDPPCDatabase.GetParameter("@RefSerie", reference));
  //      if (serie.FIdAuteur != -1) 
  //        cmd.Parameters.Add(BDPPCDatabase.GetParameter("@FIdAuteur", serie.FIdAuteur));

  //      using (IDataReader result = cmd.ExecuteReader())
  //      using (BaseDataReader dataReader = new BaseDataReader(result, typeof(Album)))
  //        if (result != null)
  //          dataReader.FillList(serie.Albums);

  //      cmd.CommandText = "SELECT Genre "
  //        + "FROM GenreSeries s INNER JOIN Genres g ON g.RefGenre = s.RefGenre "
  //        + "WHERE RefSerie = ?";
  //      cmd.Parameters.Clear();
  //      cmd.Parameters.Add(BDPPCDatabase.GetParameter("@RefSerie", reference));
  //      serie.Genres.Clear();
  //      using (IDataReader result = cmd.ExecuteReader())
  //      using (BaseDataReader dataReader = new BaseDataReader(result, null))
  //        while(result.Read())
  //          serie.Genres.Add(dataReader.GetString(0, string.Empty));

  //      ArrayList Auteurs = new ArrayList();
  //      StoredProceduresPPC.ProcAuteurs(Auteurs, -1, reference);
  //      serie.Scénaristes.Clear();
  //      serie.Dessinateurs.Clear();
  //      serie.Coloristes.Clear();
  //      foreach(Auteur auteur in Auteurs) 
  //        switch (auteur.Metier)
  //        {
  //          case 0:
  //          { 
  //            serie.Scénaristes.Add(auteur);
  //            break;
  //          }
  //          case 1:
  //          {
  //            serie.Dessinateurs.Add(auteur);
  //            break;
  //          }
  //          case 2:
  //          { 
  //            serie.Coloristes.Add(auteur);
  //            break;
  //          }
  //        }
  //    }
  //  }
  //}
	
  //public class EditeurCompletFactoryPPC : EditeurCompletFactory
  //{
  //  public override void Fill(BaseRecord record, int reference) 
  //  {
  //    if (reference == 0) return;
  //    EditeurComplet editeur = (EditeurComplet)record;
  //    using(new WaitingCursor())
  //    using(IDbCommand cmd = BDPPCDatabase.GetCommand())
  //    {
  //      cmd.CommandText = "SELECT REFEDITEUR, NOMEDITEUR, SITEWEB FROM EDITEURS WHERE REFEDITEUR = ?";
  //      cmd.Parameters.Clear();
  //      cmd.Parameters.Add(BDPPCDatabase.GetParameter("@refediteur", reference));
  //      using (IDataReader result = cmd.ExecuteReader())
  //      using (BaseDataReader dataReader = new BaseDataReader(result, editeur.GetType()))
  //        if (result != null && result.Read())
  //          dataReader.LoadData(editeur);
  //    }
  //  }
  //}

}
