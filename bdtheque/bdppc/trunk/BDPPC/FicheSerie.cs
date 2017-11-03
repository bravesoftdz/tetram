using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using TetramCorp.Utilities;
using BD.PPC.Records;
using BD.Common.Records;

namespace BD.PPC.Application
{
  public partial class FicheS�rie : System.Windows.Forms.Form
  {
    public FicheS�rie()
    {
      InitializeComponent();

      Fonts.ChangeFont(this, Fonts.Small);
      Fonts.ChangeFont(label1, Fonts.Normal);
    }

    public FicheS�rie(int refS�rie)
      : this()
    {
      RefS�rie = refS�rie;
    }

    private void FicheS�rie_Load(object sender, System.EventArgs e)
    {
      ClassMain.mainform.Visible = false;
    }

    private void FicheS�rie_Closed(object sender, System.EventArgs e)
    {
      ClassMain.mainform.Visible = true;
    }

    private int refS�rie;
    public int RefS�rie
    {
      get
      {
        return refS�rie;
      }
      set
      {
        refS�rie = value;
        S�rieComplet serie = BaseRecordComplet.Create<S�rieCompletPPC>(refS�rie) as S�rieComplet;
        label1.Text = serie.Titre.ToString();
        if (serie.SiteWeb != null && serie.SiteWeb.Length != 0)
          label2.Text = serie.SiteWeb;
        else
          label2.Hide();
        lblGenre.Text = serie.Genres.ToString();
        foreach (Auteur auteur in serie.Sc�naristes)
          lbSc�naristes.Items.Add(auteur);
        foreach (Auteur auteur in serie.Dessinateurs)
          lbDessinateurs.Items.Add(auteur);
        foreach (Auteur auteur in serie.Coloristes)
          lbColoristes.Items.Add(auteur);
        if (serie.Editeur != null)
          lblEditeur.Text = serie.Editeur.ToString();
        if (serie.Collection != null)
          lblCollection.Text = serie.Collection.ToString();
        tbHistoire.Text = serie.Sujet;
        tbNotes.Text = serie.Notes;
        foreach (Album album in serie.Albums)
          lbAlbums.Items.Add(album);
      }
    }

  }
}