using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;
using BD.Common.Records;
using System.Diagnostics;
using System.Drawing.Imaging;
using BD.Divers;
using TetramCorp.Utilities;
using System.IO;

namespace BD
{
    public partial class FicheAlbum : UserControl
    {
        private AlbumComplet album;
        private int CurrentCouverture = -1;

        public static FicheAlbum ShowAlbum(Guid ID_Album)
        {
            FicheAlbum f = new FicheAlbum();
            f.ID_Album = ID_Album;
            //f.Dock = DockStyle.Fill;
            return f;
        }
        
        public FicheAlbum()
        {
            InitializeComponent();
            lvSerie.SmallImageList = Dummy.smallImages;
            lvEmprunts.SmallImageList = Dummy.smallImages;
        }

        public Guid ID_Album
        {
            get
            {
                return album.ID_Album;
            }
            set
            {
                album = BaseRecordComplet.Create<AlbumComplet>(value) as AlbumComplet;
                albumCompletBindingSource.DataSource = album;
            }
        }

        private void lbSerie_DoubleClick(object sender, EventArgs e)
        {
            Album album = (Album)((ListBox)sender).SelectedItem;
            ID_Album = album.Reference;
        }

        private void lbEditionEditeur_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Process.Start((string)e.Link.LinkData, null);
        }

        private void lbSerie_DrawItem(object sender, DrawItemEventArgs e)
        {
            if (e.Index >= 0)
            {
                ListBox lb = (ListBox)sender;
                Album album = (Album)lb.Items[e.Index];
                Rectangle rect = e.Bounds;

                e.DrawBackground();
                if (album.Reference.Equals(this.album.ID_Album))
                {
                    e.Graphics.DrawImage(Properties.Resources.AlbumActif, rect.Left, rect.Top, lb.ItemHeight, lb.ItemHeight);
                    rect.Location = new Point(rect.Left + lb.ItemHeight, rect.Top);
                }
                e.Graphics.DrawString(album.ToString(), e.Font, new SolidBrush(lb.ForeColor), rect, StringFormat.GenericDefault);
                e.DrawFocusRectangle();
            }
        }

        private void editionsBindingSource_CurrentChanged(object sender, EventArgs e)
        {
            EditionComplet edition = (EditionComplet)((BindingSource)sender).Current;
            label30.Text = (edition.Offert ? Properties.Resources.OffertLe : Properties.Resources.AcheteLe) + " :";
            lbEditionEditeur.LinkArea = new LinkArea(0, string.IsNullOrEmpty(edition.Editeur.SiteWeb) ? 0 : edition.Editeur.SiteWeb.Length);
            if (lbEditionEditeur.Links.Count > 0)
                lbEditionEditeur.Links[0].LinkData = edition.Editeur.SiteWeb;

            lvEmprunts.Items.Clear();
            foreach (Emprunt emprunt in edition.Emprunts.Emprunts)
            {
                ListViewItem li = new BDListViewItem(emprunt);
                lvEmprunts.Items.Add(li);
                if (emprunt.Pret)
                    li.ImageKey = "Emprunt";
                else
                    li.ImageKey = "Retour";
                li.Text = emprunt.sDate;
                li.SubItems.Add(emprunt.Emprunteur.ToString());
            }
            
            ShowCouverture(0);
        }

        private void albumCompletBindingSource_DataSourceChanged(object sender, EventArgs e)
        {
            lbTitreSerie.LinkArea = new LinkArea(0, string.IsNullOrEmpty(album.Serie.SiteWeb) ? 0 : album.Serie.SiteWeb.Length);
            if (lbTitreSerie.Links.Count > 0)
                lbTitreSerie.Links[0].LinkData = album.Serie.SiteWeb;

            // on utilise pas de BindingSource pour ces listes: 
            // le curseur de position est affiché en permanence et c'est moche!
            lbScénaristes.Items.Clear();
            foreach (Auteur a in album.Scénaristes)
                lbScénaristes.Items.Add(a);
            lbDessinateurs.Items.Clear();
            foreach (Auteur a in album.Dessinateurs)
                lbDessinateurs.Items.Add(a);
            lbColoristes.Items.Clear();
            foreach (Auteur a in album.Coloristes)
                lbColoristes.Items.Add(a);

            lvSerie.Items.Clear();
            foreach (Album a in album.Serie.Albums)
            {
                ListViewItem li = new BDListViewItem(a);
                lvSerie.Items.Add(li);
                if (a.Reference.Equals(album.ID_Album))
                    li.ImageKey = "AlbumActif";
            }

            lbEditions.Items.Clear();
            foreach (EditionComplet edition in album.Editions)
                lbEditions.Items.Add(edition);

            if (album.Editions.Count > 0)
                lbEditions.SelectedItem = album.Editions[0];

            lbEditions.Visible = album.Editions.Count > 1;
            pnEditions.Visible = album.Editions.Count > 0;
        }

        private void lbEditions_SelectedIndexChanged(object sender, EventArgs e)
        {
            editionCompletBindingSource.DataSource = (EditionComplet)((ListBox)sender).SelectedItem;
        }

        private void lvSerie_Resize(object sender, EventArgs e)
        {
            columnHeader1.Width = lvSerie.Width - SystemInformation.VerticalScrollBarWidth;
        }

        private void lvEmprunts_Resize(object sender, EventArgs e)
        {
            columnHeader3.Width = lvEmprunts.Width - columnHeader2.Width - SystemInformation.VerticalScrollBarWidth;
        }

        private void ShowCouverture(int index)
        {
            if (CurrentCouverture == index) return; // on passe trois fois dans cette procédure à l'initialisation des BindingSource
            EditionComplet edition = (EditionComplet)editionCompletBindingSource.Current;
            lbPasDimage.Visible = edition.Couvertures.Count == 0;
            btImgPrec.Enabled = edition.Couvertures.Count > 1;
            btImgSuiv.Enabled = edition.Couvertures.Count > 1;

            if (edition.Couvertures.Count > 0)
                using (new WaitingCursor())
                {
                    if (index < 0) index = edition.Couvertures.Count - 1;
                    if (index > edition.Couvertures.Count - 1) index = 0;
                    CurrentCouverture = index;
                    Stream strm = Dummy.getImageStream(false, edition.Couvertures[CurrentCouverture].ID_Couverture, pictureBox1.Height, pictureBox1.Width, true);
                    pictureBox1.Image = null;
                    if (strm != null)
                        pictureBox1.Image = Image.FromStream(strm);

                    lbErreurChargement.Visible = pictureBox1.Image == null;
                    pictureBox1.DoubleClick -= pictureBox1_DoubleClick;
                    if (lbErreurChargement.Visible)
                    {
                        pictureBox1.Image = Properties.Resources.brokenimage;
                    }
                    else
                    {
                        pictureBox1.DoubleClick += pictureBox1_DoubleClick;
                    }
                }
        }

        private void pictureBox1_DoubleClick(object sender, EventArgs e)
        {
            MessageBox.Show("Zoom picture");
        }

        private void button1_Click_1(object sender, EventArgs e)
        {
            ShowCouverture(CurrentCouverture + 1);
        }

        private void button2_Click_1(object sender, EventArgs e)
        {
            ShowCouverture(CurrentCouverture - 1);
        }

    }

}
