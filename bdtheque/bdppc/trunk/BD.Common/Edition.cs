using System;
using System.Collections.Generic;
using System.Text;
using TetramCorp.Database;
using TetramCorp.Utilities;

namespace BD.Common.Records
{
  public class Edition : BaseRecord
  {
    [SQLDataField]
    [IsReference]
    public int RefEdition;
    [SQLDataField("AnneeEdition")]
    public int AnnéeEdition;
    [SQLDataField]
    public string ISBN;
    [SQLDataClass]
    public Editeur EditeurEdition = new Editeur();
    [SQLDataClass]
    public Collection CollectionEdition = new Collection();

    public override System.String ToString()
    {
      StringBuilder result = new StringBuilder("");
      StringUtils.AjoutString(result, EditeurEdition.NomEditeur.ToString(), " ");
      StringUtils.AjoutString(result, CollectionEdition.NomCollection.ToString(), " ", "(", ")");
      StringUtils.AjoutString(result, StringUtils.NotZero(AnnéeEdition.ToString()), " ", "[", "]");
      StringUtils.AjoutString(result, StringUtils.FormatISBN(ISBN), " - ", "ISBN ");
      return result.ToString();
    }
  }

  public class EditionComplet : BaseRecordComplet
  {
    [SQLDataField]
    [IsReference]
    public int RefEdition;
    [SQLDataField]
    public int RefAlbum;
    public EditeurComplet Editeur;
    public Collection Collection;
    [SQLDataField]
    public int TypeEdition;
    [SQLDataField("AnneeEdition")]
    public int AnnéeEdition;
    [SQLDataField]
    public int Etat;
    [SQLDataField]
    public int Reliure;
    [SQLDataField]
    public int NombreDePages;
    [SQLDataField]
    public int FormatEdition;
    [SQLDataField]
    public int Orientation;
    [SQLDataField]
    public decimal Prix;
    [SQLDataField]
    public bool Couleur;
    [SQLDataField]
    public bool VO;
    [SQLDataField]
    public bool Dedicace;
    [SQLDataField]
    public bool Stock;
    [SQLDataField]
    public bool Prete;
    [SQLDataField]
    public bool Offert;
    [SQLDataField]
    public bool Gratuit;
    [SQLDataField("ISBN")]
    public string fISBN;
    [SQLDataField]
    public string sEtat;
    [SQLDataField]
    public string sReliure;
    [SQLDataField]
    public string sTypeEdition;
    [SQLDataField]
    public string sFormatEdition;
    [SQLDataField]
    public string sOrientation;
    [SQLDataField]
    public DateTime DateAchat;
    [SQLDataField]
    public string Notes;
    //Emprunts: TEmpruntsComplet;
    //Couvertures: TList;

    public string dateAchat
    {
      get
      {
        if (!DateAchat.Equals(new DateTime(0)))
          return DateAchat.ToString();
        else
          return string.Empty;
      }
    }

    public string ISBN
    {
      get
      {
        return StringUtils.FormatISBN(fISBN);
      }
    }

  }
}
