namespace BD
{
    partial class FicheAlbum
    {
        /// <summary> 
        /// Variable nécessaire au concepteur.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary> 
        /// Nettoyage des ressources utilisées.
        /// </summary>
        /// <param name="disposing">true si les ressources managées doivent être supprimées ; sinon, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Code généré par le Concepteur de composants

        /// <summary> 
        /// Méthode requise pour la prise en charge du concepteur - ne modifiez pas 
        /// le contenu de cette méthode avec l'éditeur de code.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.label9 = new System.Windows.Forms.Label();
            this.lbColoristes = new System.Windows.Forms.ListBox();
            this.lbDessinateurs = new System.Windows.Forms.ListBox();
            this.lbScénaristes = new System.Windows.Forms.ListBox();
            this.tbNotes = new System.Windows.Forms.TextBox();
            this.tbHistoire = new System.Windows.Forms.TextBox();
            this.lbTitre = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.lbTome = new System.Windows.Forms.Label();
            this.cbIntegral = new System.Windows.Forms.CheckBox();
            this.cbHorsSerie = new System.Windows.Forms.CheckBox();
            this.lbParution = new System.Windows.Forms.Label();
            this.label11 = new System.Windows.Forms.Label();
            this.lbIntegrale = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.lbGenres = new System.Windows.Forms.Label();
            this.label13 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label12 = new System.Windows.Forms.Label();
            this.label14 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.label38 = new System.Windows.Forms.Label();
            this.tbEditionNote = new System.Windows.Forms.TextBox();
            this.lbEditionFormat = new System.Windows.Forms.Label();
            this.label36 = new System.Windows.Forms.Label();
            this.lbEditionType = new System.Windows.Forms.Label();
            this.lbEditionOrientation = new System.Windows.Forms.Label();
            this.label32 = new System.Windows.Forms.Label();
            this.lbEditionReliure = new System.Windows.Forms.Label();
            this.label34 = new System.Windows.Forms.Label();
            this.lbEditionDateAchat = new System.Windows.Forms.Label();
            this.lbEditionAnnee = new System.Windows.Forms.Label();
            this.label28 = new System.Windows.Forms.Label();
            this.cbEditionCouleur = new System.Windows.Forms.CheckBox();
            this.cbEditionVO = new System.Windows.Forms.CheckBox();
            this.cbEditionDedicace = new System.Windows.Forms.CheckBox();
            this.cbEditionStock = new System.Windows.Forms.CheckBox();
            this.cbEditionOffert = new System.Windows.Forms.CheckBox();
            this.lbEditionPages = new System.Windows.Forms.Label();
            this.label26 = new System.Windows.Forms.Label();
            this.lbEditionEtat = new System.Windows.Forms.Label();
            this.label24 = new System.Windows.Forms.Label();
            this.lbEditionCote = new System.Windows.Forms.Label();
            this.label22 = new System.Windows.Forms.Label();
            this.lbEditionPrix = new System.Windows.Forms.Label();
            this.label20 = new System.Windows.Forms.Label();
            this.lbEditionCollection = new System.Windows.Forms.Label();
            this.label18 = new System.Windows.Forms.Label();
            this.label16 = new System.Windows.Forms.Label();
            this.lbEditionISBN = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.lbEditions = new System.Windows.Forms.ListBox();
            this.lbEditionEditeur = new System.Windows.Forms.LinkLabel();
            this.lbTitreSerie = new System.Windows.Forms.LinkLabel();
            this.pnEditions = new System.Windows.Forms.Panel();
            this.lvEmprunts = new System.Windows.Forms.ListView();
            this.columnHeader2 = new System.Windows.Forms.ColumnHeader();
            this.columnHeader3 = new System.Windows.Forms.ColumnHeader();
            this.label30 = new System.Windows.Forms.Label();
            this.lvSerie = new System.Windows.Forms.ListView();
            this.columnHeader1 = new System.Windows.Forms.ColumnHeader();
            this.panel1 = new System.Windows.Forms.Panel();
            this.albumCompletBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.editionCompletBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.button2 = new System.Windows.Forms.Button();
            this.button1 = new System.Windows.Forms.Button();
            this.lbErreurChargement = new System.Windows.Forms.Label();
            this.lbPasDimage = new System.Windows.Forms.Label();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.pnEditions.SuspendLayout();
            this.panel1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.albumCompletBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.editionCompletBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.SuspendLayout();
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.ForeColor = System.Drawing.Color.SteelBlue;
            this.label9.Location = new System.Drawing.Point(21, 8);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(38, 13);
            this.label9.TabIndex = 24;
            this.label9.Text = "Série :";
            this.label9.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbColoristes
            // 
            this.lbColoristes.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.lbColoristes.Location = new System.Drawing.Point(68, 211);
            this.lbColoristes.Name = "lbColoristes";
            this.lbColoristes.Size = new System.Drawing.Size(217, 30);
            this.lbColoristes.TabIndex = 27;
            // 
            // lbDessinateurs
            // 
            this.lbDessinateurs.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.lbDessinateurs.Location = new System.Drawing.Point(68, 175);
            this.lbDessinateurs.Name = "lbDessinateurs";
            this.lbDessinateurs.Size = new System.Drawing.Size(217, 30);
            this.lbDessinateurs.TabIndex = 28;
            // 
            // lbScénaristes
            // 
            this.lbScénaristes.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.lbScénaristes.Location = new System.Drawing.Point(68, 139);
            this.lbScénaristes.Name = "lbScénaristes";
            this.lbScénaristes.Size = new System.Drawing.Size(217, 30);
            this.lbScénaristes.TabIndex = 29;
            // 
            // tbNotes
            // 
            this.tbNotes.AcceptsReturn = true;
            this.tbNotes.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.tbNotes.BackColor = System.Drawing.Color.White;
            this.tbNotes.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.albumCompletBindingSource, "consultNote", true));
            this.tbNotes.Location = new System.Drawing.Point(68, 383);
            this.tbNotes.Multiline = true;
            this.tbNotes.Name = "tbNotes";
            this.tbNotes.ReadOnly = true;
            this.tbNotes.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.tbNotes.Size = new System.Drawing.Size(447, 68);
            this.tbNotes.TabIndex = 34;
            // 
            // tbHistoire
            // 
            this.tbHistoire.AcceptsReturn = true;
            this.tbHistoire.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.tbHistoire.BackColor = System.Drawing.Color.White;
            this.tbHistoire.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.albumCompletBindingSource, "consultSujet", true));
            this.tbHistoire.Location = new System.Drawing.Point(68, 309);
            this.tbHistoire.Multiline = true;
            this.tbHistoire.Name = "tbHistoire";
            this.tbHistoire.ReadOnly = true;
            this.tbHistoire.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.tbHistoire.Size = new System.Drawing.Size(447, 68);
            this.tbHistoire.TabIndex = 35;
            // 
            // lbTitre
            // 
            this.lbTitre.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.lbTitre.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.albumCompletBindingSource, "Titre", true));
            this.lbTitre.Font = new System.Drawing.Font("Tahoma", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbTitre.Location = new System.Drawing.Point(65, 29);
            this.lbTitre.Name = "lbTitre";
            this.lbTitre.Size = new System.Drawing.Size(450, 29);
            this.lbTitre.TabIndex = 37;
            this.lbTitre.TabStop = true;
            this.lbTitre.Text = "lbTitre";
            this.lbTitre.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.ForeColor = System.Drawing.Color.SteelBlue;
            this.label1.Location = new System.Drawing.Point(23, 37);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(36, 13);
            this.label1.TabIndex = 38;
            this.label1.Text = "Titre :";
            this.label1.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.ForeColor = System.Drawing.Color.SteelBlue;
            this.label8.Location = new System.Drawing.Point(19, 62);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(40, 13);
            this.label8.TabIndex = 39;
            this.label8.Text = "Tome :";
            this.label8.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbTome
            // 
            this.lbTome.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.albumCompletBindingSource, "consultTome", true));
            this.lbTome.Location = new System.Drawing.Point(65, 62);
            this.lbTome.Name = "lbTome";
            this.lbTome.Size = new System.Drawing.Size(76, 13);
            this.lbTome.TabIndex = 40;
            this.lbTome.Text = "lbTome";
            this.lbTome.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            // 
            // cbIntegral
            // 
            this.cbIntegral.AutoCheck = false;
            this.cbIntegral.AutoSize = true;
            this.cbIntegral.DataBindings.Add(new System.Windows.Forms.Binding("Checked", this.albumCompletBindingSource, "Integrale", true));
            this.cbIntegral.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cbIntegral.ForeColor = System.Drawing.Color.SteelBlue;
            this.cbIntegral.Location = new System.Drawing.Point(150, 61);
            this.cbIntegral.Name = "cbIntegral";
            this.cbIntegral.Size = new System.Drawing.Size(67, 17);
            this.cbIntegral.TabIndex = 41;
            this.cbIntegral.Text = "Intégrale";
            this.cbIntegral.UseVisualStyleBackColor = true;
            // 
            // cbHorsSerie
            // 
            this.cbHorsSerie.AutoCheck = false;
            this.cbHorsSerie.AutoSize = true;
            this.cbHorsSerie.DataBindings.Add(new System.Windows.Forms.Binding("Checked", this.albumCompletBindingSource, "HorsSérie", true));
            this.cbHorsSerie.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cbHorsSerie.ForeColor = System.Drawing.Color.SteelBlue;
            this.cbHorsSerie.Location = new System.Drawing.Point(150, 79);
            this.cbHorsSerie.Name = "cbHorsSerie";
            this.cbHorsSerie.Size = new System.Drawing.Size(71, 17);
            this.cbHorsSerie.TabIndex = 42;
            this.cbHorsSerie.Text = "Hors série";
            this.cbHorsSerie.UseVisualStyleBackColor = true;
            // 
            // lbParution
            // 
            this.lbParution.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.albumCompletBindingSource, "Parution", true));
            this.lbParution.Location = new System.Drawing.Point(65, 81);
            this.lbParution.Name = "lbParution";
            this.lbParution.Size = new System.Drawing.Size(76, 13);
            this.lbParution.TabIndex = 44;
            this.lbParution.Text = "lbParution";
            this.lbParution.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.ForeColor = System.Drawing.Color.SteelBlue;
            this.label11.Location = new System.Drawing.Point(5, 81);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(54, 13);
            this.label11.TabIndex = 43;
            this.label11.Text = "Parution :";
            this.label11.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbIntegrale
            // 
            this.lbIntegrale.AutoSize = true;
            this.lbIntegrale.DataBindings.Add(new System.Windows.Forms.Binding("Visible", this.albumCompletBindingSource, "Integrale", true));
            this.lbIntegrale.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.albumCompletBindingSource, "consultIntegrale", true));
            this.lbIntegrale.Location = new System.Drawing.Point(226, 62);
            this.lbIntegrale.Name = "lbIntegrale";
            this.lbIntegrale.Size = new System.Drawing.Size(59, 13);
            this.lbIntegrale.TabIndex = 45;
            this.lbIntegrale.Text = "lbIntegrale";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.ForeColor = System.Drawing.Color.SteelBlue;
            this.label2.Location = new System.Drawing.Point(11, 104);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(48, 13);
            this.label2.TabIndex = 46;
            this.label2.Text = "Genres :";
            this.label2.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbGenres
            // 
            this.lbGenres.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.albumCompletBindingSource, "Serie.Genres", true));
            this.lbGenres.Location = new System.Drawing.Point(65, 104);
            this.lbGenres.Name = "lbGenres";
            this.lbGenres.Size = new System.Drawing.Size(220, 32);
            this.lbGenres.TabIndex = 47;
            this.lbGenres.Text = "lbGenres";
            // 
            // label13
            // 
            this.label13.AutoSize = true;
            this.label13.ForeColor = System.Drawing.Color.SteelBlue;
            this.label13.Location = new System.Drawing.Point(4, 139);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(55, 13);
            this.label13.TabIndex = 48;
            this.label13.Text = "Scenario :";
            this.label13.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.ForeColor = System.Drawing.Color.SteelBlue;
            this.label4.Location = new System.Drawing.Point(9, 175);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(50, 13);
            this.label4.TabIndex = 49;
            this.label4.Text = "Dessins :";
            this.label4.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // label12
            // 
            this.label12.AutoSize = true;
            this.label12.ForeColor = System.Drawing.Color.SteelBlue;
            this.label12.Location = new System.Drawing.Point(3, 211);
            this.label12.Name = "label12";
            this.label12.Size = new System.Drawing.Size(56, 13);
            this.label12.TabIndex = 50;
            this.label12.Text = "Couleurs :";
            this.label12.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // label14
            // 
            this.label14.AutoSize = true;
            this.label14.ForeColor = System.Drawing.Color.SteelBlue;
            this.label14.Location = new System.Drawing.Point(21, 247);
            this.label14.Name = "label14";
            this.label14.Size = new System.Drawing.Size(38, 13);
            this.label14.TabIndex = 52;
            this.label14.Text = "Série :";
            this.label14.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.ForeColor = System.Drawing.Color.SteelBlue;
            this.label3.Location = new System.Drawing.Point(9, 312);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(50, 13);
            this.label3.TabIndex = 53;
            this.label3.Text = "Histoire :";
            this.label3.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.ForeColor = System.Drawing.Color.SteelBlue;
            this.label5.Location = new System.Drawing.Point(17, 386);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(42, 13);
            this.label5.TabIndex = 54;
            this.label5.Text = "Notes :";
            this.label5.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.ForeColor = System.Drawing.Color.SteelBlue;
            this.label6.Location = new System.Drawing.Point(0, 169);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(59, 13);
            this.label6.TabIndex = 120;
            this.label6.Text = "Emprunts :";
            this.label6.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // label38
            // 
            this.label38.AutoSize = true;
            this.label38.ForeColor = System.Drawing.Color.SteelBlue;
            this.label38.Location = new System.Drawing.Point(17, 111);
            this.label38.Name = "label38";
            this.label38.Size = new System.Drawing.Size(42, 13);
            this.label38.TabIndex = 119;
            this.label38.Text = "Notes :";
            this.label38.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // tbEditionNote
            // 
            this.tbEditionNote.AcceptsReturn = true;
            this.tbEditionNote.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.tbEditionNote.BackColor = System.Drawing.Color.White;
            this.tbEditionNote.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.editionCompletBindingSource, "Notes", true));
            this.tbEditionNote.Location = new System.Drawing.Point(65, 111);
            this.tbEditionNote.Multiline = true;
            this.tbEditionNote.Name = "tbEditionNote";
            this.tbEditionNote.ReadOnly = true;
            this.tbEditionNote.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.tbEditionNote.Size = new System.Drawing.Size(447, 57);
            this.tbEditionNote.TabIndex = 118;
            // 
            // lbEditionFormat
            // 
            this.lbEditionFormat.AutoSize = true;
            this.lbEditionFormat.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.editionCompletBindingSource, "sFormatEdition", true));
            this.lbEditionFormat.Location = new System.Drawing.Point(410, 95);
            this.lbEditionFormat.Name = "lbEditionFormat";
            this.lbEditionFormat.Size = new System.Drawing.Size(81, 13);
            this.lbEditionFormat.TabIndex = 117;
            this.lbEditionFormat.Text = "lbEditionFormat";
            // 
            // label36
            // 
            this.label36.AutoSize = true;
            this.label36.ForeColor = System.Drawing.Color.SteelBlue;
            this.label36.Location = new System.Drawing.Point(356, 95);
            this.label36.Name = "label36";
            this.label36.Size = new System.Drawing.Size(48, 13);
            this.label36.TabIndex = 116;
            this.label36.Text = "Format :";
            this.label36.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbEditionType
            // 
            this.lbEditionType.AutoSize = true;
            this.lbEditionType.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.editionCompletBindingSource, "sTypeEdition", true));
            this.lbEditionType.Location = new System.Drawing.Point(356, 82);
            this.lbEditionType.Name = "lbEditionType";
            this.lbEditionType.Size = new System.Drawing.Size(71, 13);
            this.lbEditionType.TabIndex = 115;
            this.lbEditionType.Text = "lbEditionType";
            // 
            // lbEditionOrientation
            // 
            this.lbEditionOrientation.AutoSize = true;
            this.lbEditionOrientation.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.editionCompletBindingSource, "sOrientation", true));
            this.lbEditionOrientation.Location = new System.Drawing.Point(236, 95);
            this.lbEditionOrientation.Name = "lbEditionOrientation";
            this.lbEditionOrientation.Size = new System.Drawing.Size(101, 13);
            this.lbEditionOrientation.TabIndex = 114;
            this.lbEditionOrientation.Text = "lbEditionOrientation";
            // 
            // label32
            // 
            this.label32.AutoSize = true;
            this.label32.ForeColor = System.Drawing.Color.SteelBlue;
            this.label32.Location = new System.Drawing.Point(162, 95);
            this.label32.Name = "label32";
            this.label32.Size = new System.Drawing.Size(68, 13);
            this.label32.TabIndex = 113;
            this.label32.Text = "Orientation :";
            this.label32.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbEditionReliure
            // 
            this.lbEditionReliure.AutoSize = true;
            this.lbEditionReliure.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.editionCompletBindingSource, "sReliure", true));
            this.lbEditionReliure.Location = new System.Drawing.Point(236, 82);
            this.lbEditionReliure.Name = "lbEditionReliure";
            this.lbEditionReliure.Size = new System.Drawing.Size(80, 13);
            this.lbEditionReliure.TabIndex = 112;
            this.lbEditionReliure.Text = "lbEditionReliure";
            // 
            // label34
            // 
            this.label34.AutoSize = true;
            this.label34.ForeColor = System.Drawing.Color.SteelBlue;
            this.label34.Location = new System.Drawing.Point(183, 82);
            this.label34.Name = "label34";
            this.label34.Size = new System.Drawing.Size(47, 13);
            this.label34.TabIndex = 111;
            this.label34.Text = "Reliure :";
            this.label34.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbEditionDateAchat
            // 
            this.lbEditionDateAchat.AutoSize = true;
            this.lbEditionDateAchat.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.editionCompletBindingSource, "consultDateAchat", true));
            this.lbEditionDateAchat.Location = new System.Drawing.Point(236, 69);
            this.lbEditionDateAchat.Name = "lbEditionDateAchat";
            this.lbEditionDateAchat.Size = new System.Drawing.Size(98, 13);
            this.lbEditionDateAchat.TabIndex = 110;
            this.lbEditionDateAchat.Text = "lbEditionDateAchat";
            // 
            // lbEditionAnnee
            // 
            this.lbEditionAnnee.AutoSize = true;
            this.lbEditionAnnee.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.editionCompletBindingSource, "consultAnnéeEdition", true));
            this.lbEditionAnnee.Location = new System.Drawing.Point(303, 18);
            this.lbEditionAnnee.Name = "lbEditionAnnee";
            this.lbEditionAnnee.Size = new System.Drawing.Size(78, 13);
            this.lbEditionAnnee.TabIndex = 108;
            this.lbEditionAnnee.Text = "lbEditionAnnee";
            // 
            // label28
            // 
            this.label28.AutoSize = true;
            this.label28.ForeColor = System.Drawing.Color.SteelBlue;
            this.label28.Location = new System.Drawing.Point(252, 18);
            this.label28.Name = "label28";
            this.label28.Size = new System.Drawing.Size(45, 13);
            this.label28.TabIndex = 107;
            this.label28.Text = "Année :";
            this.label28.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // cbEditionCouleur
            // 
            this.cbEditionCouleur.AutoCheck = false;
            this.cbEditionCouleur.AutoSize = true;
            this.cbEditionCouleur.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.cbEditionCouleur.DataBindings.Add(new System.Windows.Forms.Binding("Checked", this.editionCompletBindingSource, "Couleur", true));
            this.cbEditionCouleur.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cbEditionCouleur.ForeColor = System.Drawing.Color.SteelBlue;
            this.cbEditionCouleur.Location = new System.Drawing.Point(246, 34);
            this.cbEditionCouleur.Name = "cbEditionCouleur";
            this.cbEditionCouleur.Size = new System.Drawing.Size(60, 17);
            this.cbEditionCouleur.TabIndex = 106;
            this.cbEditionCouleur.Text = "Couleur";
            this.cbEditionCouleur.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.cbEditionCouleur.UseVisualStyleBackColor = true;
            // 
            // cbEditionVO
            // 
            this.cbEditionVO.AutoCheck = false;
            this.cbEditionVO.AutoSize = true;
            this.cbEditionVO.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.cbEditionVO.DataBindings.Add(new System.Windows.Forms.Binding("Checked", this.editionCompletBindingSource, "VO", true));
            this.cbEditionVO.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cbEditionVO.ForeColor = System.Drawing.Color.SteelBlue;
            this.cbEditionVO.Location = new System.Drawing.Point(200, 16);
            this.cbEditionVO.Name = "cbEditionVO";
            this.cbEditionVO.Size = new System.Drawing.Size(37, 17);
            this.cbEditionVO.TabIndex = 105;
            this.cbEditionVO.Text = "VO";
            this.cbEditionVO.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.cbEditionVO.UseVisualStyleBackColor = true;
            // 
            // cbEditionDedicace
            // 
            this.cbEditionDedicace.AutoCheck = false;
            this.cbEditionDedicace.AutoSize = true;
            this.cbEditionDedicace.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.cbEditionDedicace.DataBindings.Add(new System.Windows.Forms.Binding("Checked", this.editionCompletBindingSource, "Dedicace", true));
            this.cbEditionDedicace.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cbEditionDedicace.ForeColor = System.Drawing.Color.SteelBlue;
            this.cbEditionDedicace.Location = new System.Drawing.Point(171, 34);
            this.cbEditionDedicace.Name = "cbEditionDedicace";
            this.cbEditionDedicace.Size = new System.Drawing.Size(66, 17);
            this.cbEditionDedicace.TabIndex = 104;
            this.cbEditionDedicace.Text = "Dédicacé";
            this.cbEditionDedicace.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.cbEditionDedicace.UseVisualStyleBackColor = true;
            // 
            // cbEditionStock
            // 
            this.cbEditionStock.AutoCheck = false;
            this.cbEditionStock.AutoSize = true;
            this.cbEditionStock.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.cbEditionStock.DataBindings.Add(new System.Windows.Forms.Binding("Checked", this.editionCompletBindingSource, "Stock", true));
            this.cbEditionStock.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cbEditionStock.ForeColor = System.Drawing.Color.SteelBlue;
            this.cbEditionStock.Location = new System.Drawing.Point(257, -2);
            this.cbEditionStock.Name = "cbEditionStock";
            this.cbEditionStock.Size = new System.Drawing.Size(49, 17);
            this.cbEditionStock.TabIndex = 103;
            this.cbEditionStock.Text = "Stock";
            this.cbEditionStock.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.cbEditionStock.UseVisualStyleBackColor = true;
            // 
            // cbEditionOffert
            // 
            this.cbEditionOffert.AutoCheck = false;
            this.cbEditionOffert.AutoSize = true;
            this.cbEditionOffert.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.cbEditionOffert.DataBindings.Add(new System.Windows.Forms.Binding("Checked", this.editionCompletBindingSource, "Offert", true));
            this.cbEditionOffert.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cbEditionOffert.ForeColor = System.Drawing.Color.SteelBlue;
            this.cbEditionOffert.Location = new System.Drawing.Point(184, -2);
            this.cbEditionOffert.Name = "cbEditionOffert";
            this.cbEditionOffert.Size = new System.Drawing.Size(53, 17);
            this.cbEditionOffert.TabIndex = 102;
            this.cbEditionOffert.Text = "Offert";
            this.cbEditionOffert.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.cbEditionOffert.UseVisualStyleBackColor = true;
            // 
            // lbEditionPages
            // 
            this.lbEditionPages.AutoSize = true;
            this.lbEditionPages.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.editionCompletBindingSource, "consultNombreDePages", true));
            this.lbEditionPages.Location = new System.Drawing.Point(65, 95);
            this.lbEditionPages.Name = "lbEditionPages";
            this.lbEditionPages.Size = new System.Drawing.Size(76, 13);
            this.lbEditionPages.TabIndex = 101;
            this.lbEditionPages.Text = "lbEditionPages";
            // 
            // label26
            // 
            this.label26.AutoSize = true;
            this.label26.ForeColor = System.Drawing.Color.SteelBlue;
            this.label26.Location = new System.Drawing.Point(16, 95);
            this.label26.Name = "label26";
            this.label26.Size = new System.Drawing.Size(43, 13);
            this.label26.TabIndex = 100;
            this.label26.Text = "Pages :";
            this.label26.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbEditionEtat
            // 
            this.lbEditionEtat.AutoSize = true;
            this.lbEditionEtat.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.editionCompletBindingSource, "sEtat", true));
            this.lbEditionEtat.Location = new System.Drawing.Point(65, 82);
            this.lbEditionEtat.Name = "lbEditionEtat";
            this.lbEditionEtat.Size = new System.Drawing.Size(67, 13);
            this.lbEditionEtat.TabIndex = 99;
            this.lbEditionEtat.Text = "lbEditionEtat";
            // 
            // label24
            // 
            this.label24.AutoSize = true;
            this.label24.ForeColor = System.Drawing.Color.SteelBlue;
            this.label24.Location = new System.Drawing.Point(25, 82);
            this.label24.Name = "label24";
            this.label24.Size = new System.Drawing.Size(34, 13);
            this.label24.TabIndex = 98;
            this.label24.Text = "Etat :";
            this.label24.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbEditionCote
            // 
            this.lbEditionCote.AutoSize = true;
            this.lbEditionCote.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.editionCompletBindingSource, "consultCote", true));
            this.lbEditionCote.Location = new System.Drawing.Point(65, 56);
            this.lbEditionCote.Name = "lbEditionCote";
            this.lbEditionCote.Size = new System.Drawing.Size(70, 13);
            this.lbEditionCote.TabIndex = 97;
            this.lbEditionCote.Text = "lbEditionCote";
            // 
            // label22
            // 
            this.label22.AutoSize = true;
            this.label22.ForeColor = System.Drawing.Color.SteelBlue;
            this.label22.Location = new System.Drawing.Point(22, 56);
            this.label22.Name = "label22";
            this.label22.Size = new System.Drawing.Size(37, 13);
            this.label22.TabIndex = 96;
            this.label22.Text = "Cote :";
            this.label22.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbEditionPrix
            // 
            this.lbEditionPrix.AutoSize = true;
            this.lbEditionPrix.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.editionCompletBindingSource, "consultPrix", true));
            this.lbEditionPrix.Location = new System.Drawing.Point(65, 69);
            this.lbEditionPrix.Name = "lbEditionPrix";
            this.lbEditionPrix.Size = new System.Drawing.Size(65, 13);
            this.lbEditionPrix.TabIndex = 95;
            this.lbEditionPrix.Text = "lbEditionPrix";
            // 
            // label20
            // 
            this.label20.AutoSize = true;
            this.label20.ForeColor = System.Drawing.Color.SteelBlue;
            this.label20.Location = new System.Drawing.Point(27, 69);
            this.label20.Name = "label20";
            this.label20.Size = new System.Drawing.Size(32, 13);
            this.label20.TabIndex = 94;
            this.label20.Text = "Prix :";
            this.label20.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbEditionCollection
            // 
            this.lbEditionCollection.AutoSize = true;
            this.lbEditionCollection.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.editionCompletBindingSource, "Collection", true));
            this.lbEditionCollection.Location = new System.Drawing.Point(65, 38);
            this.lbEditionCollection.Name = "lbEditionCollection";
            this.lbEditionCollection.Size = new System.Drawing.Size(93, 13);
            this.lbEditionCollection.TabIndex = 93;
            this.lbEditionCollection.Text = "lbEditionCollection";
            // 
            // label18
            // 
            this.label18.AutoSize = true;
            this.label18.ForeColor = System.Drawing.Color.SteelBlue;
            this.label18.Location = new System.Drawing.Point(-1, 38);
            this.label18.Name = "label18";
            this.label18.Size = new System.Drawing.Size(60, 13);
            this.label18.TabIndex = 92;
            this.label18.Text = "Collection :";
            this.label18.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // label16
            // 
            this.label16.AutoSize = true;
            this.label16.ForeColor = System.Drawing.Color.SteelBlue;
            this.label16.Location = new System.Drawing.Point(11, 20);
            this.label16.Name = "label16";
            this.label16.Size = new System.Drawing.Size(48, 13);
            this.label16.TabIndex = 90;
            this.label16.Text = "Editeur :";
            this.label16.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbEditionISBN
            // 
            this.lbEditionISBN.AutoSize = true;
            this.lbEditionISBN.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.editionCompletBindingSource, "ISBN", true));
            this.lbEditionISBN.Location = new System.Drawing.Point(65, 2);
            this.lbEditionISBN.Name = "lbEditionISBN";
            this.lbEditionISBN.Size = new System.Drawing.Size(70, 13);
            this.lbEditionISBN.TabIndex = 89;
            this.lbEditionISBN.Text = "lbEditionISBN";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.ForeColor = System.Drawing.Color.SteelBlue;
            this.label7.Location = new System.Drawing.Point(22, 2);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(37, 13);
            this.label7.TabIndex = 88;
            this.label7.Text = "ISBN :";
            this.label7.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lbEditions
            // 
            this.lbEditions.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.lbEditions.Location = new System.Drawing.Point(340, 457);
            this.lbEditions.Name = "lbEditions";
            this.lbEditions.Size = new System.Drawing.Size(175, 69);
            this.lbEditions.TabIndex = 36;
            this.lbEditions.SelectedIndexChanged += new System.EventHandler(this.lbEditions_SelectedIndexChanged);
            // 
            // lbEditionEditeur
            // 
            this.lbEditionEditeur.AutoSize = true;
            this.lbEditionEditeur.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.editionCompletBindingSource, "Editeur", true));
            this.lbEditionEditeur.Location = new System.Drawing.Point(65, 20);
            this.lbEditionEditeur.Name = "lbEditionEditeur";
            this.lbEditionEditeur.Size = new System.Drawing.Size(81, 13);
            this.lbEditionEditeur.TabIndex = 91;
            this.lbEditionEditeur.TabStop = true;
            this.lbEditionEditeur.Text = "lbEditionEditeur";
            this.lbEditionEditeur.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.lbEditionEditeur_LinkClicked);
            // 
            // lbTitreSerie
            // 
            this.lbTitreSerie.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.lbTitreSerie.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.albumCompletBindingSource, "Serie", true));
            this.lbTitreSerie.Font = new System.Drawing.Font("Tahoma", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbTitreSerie.Location = new System.Drawing.Point(65, 0);
            this.lbTitreSerie.Name = "lbTitreSerie";
            this.lbTitreSerie.Size = new System.Drawing.Size(450, 29);
            this.lbTitreSerie.TabIndex = 23;
            this.lbTitreSerie.TabStop = true;
            this.lbTitreSerie.Text = "lbTitreSerie";
            this.lbTitreSerie.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.lbTitreSerie.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.lbEditionEditeur_LinkClicked);
            // 
            // pnEditions
            // 
            this.pnEditions.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.pnEditions.Controls.Add(this.lvEmprunts);
            this.pnEditions.Controls.Add(this.label6);
            this.pnEditions.Controls.Add(this.label38);
            this.pnEditions.Controls.Add(this.tbEditionNote);
            this.pnEditions.Controls.Add(this.lbEditionFormat);
            this.pnEditions.Controls.Add(this.label36);
            this.pnEditions.Controls.Add(this.lbEditionType);
            this.pnEditions.Controls.Add(this.lbEditionOrientation);
            this.pnEditions.Controls.Add(this.label32);
            this.pnEditions.Controls.Add(this.lbEditionReliure);
            this.pnEditions.Controls.Add(this.label34);
            this.pnEditions.Controls.Add(this.lbEditionDateAchat);
            this.pnEditions.Controls.Add(this.label30);
            this.pnEditions.Controls.Add(this.lbEditionAnnee);
            this.pnEditions.Controls.Add(this.label28);
            this.pnEditions.Controls.Add(this.cbEditionCouleur);
            this.pnEditions.Controls.Add(this.cbEditionVO);
            this.pnEditions.Controls.Add(this.cbEditionDedicace);
            this.pnEditions.Controls.Add(this.cbEditionStock);
            this.pnEditions.Controls.Add(this.cbEditionOffert);
            this.pnEditions.Controls.Add(this.lbEditionPages);
            this.pnEditions.Controls.Add(this.label26);
            this.pnEditions.Controls.Add(this.lbEditionEtat);
            this.pnEditions.Controls.Add(this.label24);
            this.pnEditions.Controls.Add(this.lbEditionCote);
            this.pnEditions.Controls.Add(this.label22);
            this.pnEditions.Controls.Add(this.lbEditionPrix);
            this.pnEditions.Controls.Add(this.label20);
            this.pnEditions.Controls.Add(this.lbEditionCollection);
            this.pnEditions.Controls.Add(this.label18);
            this.pnEditions.Controls.Add(this.lbEditionEditeur);
            this.pnEditions.Controls.Add(this.label16);
            this.pnEditions.Controls.Add(this.lbEditionISBN);
            this.pnEditions.Controls.Add(this.label7);
            this.pnEditions.Location = new System.Drawing.Point(0, 457);
            this.pnEditions.Name = "pnEditions";
            this.pnEditions.Size = new System.Drawing.Size(522, 294);
            this.pnEditions.TabIndex = 88;
            // 
            // lvEmprunts
            // 
            this.lvEmprunts.Activation = System.Windows.Forms.ItemActivation.OneClick;
            this.lvEmprunts.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.lvEmprunts.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.lvEmprunts.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.columnHeader2,
            this.columnHeader3});
            this.lvEmprunts.FullRowSelect = true;
            this.lvEmprunts.HeaderStyle = System.Windows.Forms.ColumnHeaderStyle.Nonclickable;
            this.lvEmprunts.HideSelection = false;
            this.lvEmprunts.HoverSelection = true;
            this.lvEmprunts.Location = new System.Drawing.Point(0, 185);
            this.lvEmprunts.Name = "lvEmprunts";
            this.lvEmprunts.Size = new System.Drawing.Size(512, 106);
            this.lvEmprunts.TabIndex = 121;
            this.lvEmprunts.UseCompatibleStateImageBehavior = false;
            this.lvEmprunts.View = System.Windows.Forms.View.Details;
            this.lvEmprunts.Resize += new System.EventHandler(this.lvEmprunts_Resize);
            // 
            // columnHeader2
            // 
            this.columnHeader2.Text = "Date";
            this.columnHeader2.Width = 100;
            // 
            // columnHeader3
            // 
            this.columnHeader3.Text = "Emprunteur";
            this.columnHeader3.Width = 412;
            // 
            // label30
            // 
            this.label30.AutoSize = true;
            this.label30.ForeColor = System.Drawing.Color.SteelBlue;
            this.label30.Location = new System.Drawing.Point(171, 69);
            this.label30.Name = "label30";
            this.label30.Size = new System.Drawing.Size(59, 13);
            this.label30.TabIndex = 109;
            this.label30.Text = "Acheté le :";
            this.label30.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lvSerie
            // 
            this.lvSerie.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.lvSerie.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.columnHeader1});
            this.lvSerie.HeaderStyle = System.Windows.Forms.ColumnHeaderStyle.None;
            this.lvSerie.HideSelection = false;
            this.lvSerie.Location = new System.Drawing.Point(68, 247);
            this.lvSerie.Name = "lvSerie";
            this.lvSerie.Size = new System.Drawing.Size(217, 56);
            this.lvSerie.TabIndex = 90;
            this.lvSerie.UseCompatibleStateImageBehavior = false;
            this.lvSerie.View = System.Windows.Forms.View.Details;
            this.lvSerie.Resize += new System.EventHandler(this.lvSerie_Resize);
            // 
            // columnHeader1
            // 
            this.columnHeader1.Width = 213;
            // 
            // panel1
            // 
            this.panel1.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.panel1.Controls.Add(this.button2);
            this.panel1.Controls.Add(this.button1);
            this.panel1.Controls.Add(this.lbErreurChargement);
            this.panel1.Controls.Add(this.lbPasDimage);
            this.panel1.Controls.Add(this.pictureBox1);
            this.panel1.Location = new System.Drawing.Point(291, 61);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(224, 241);
            this.panel1.TabIndex = 91;
            // 
            // albumCompletBindingSource
            // 
            this.albumCompletBindingSource.DataSource = typeof(BD.Common.Records.AlbumComplet);
            this.albumCompletBindingSource.DataSourceChanged += new System.EventHandler(this.albumCompletBindingSource_DataSourceChanged);
            // 
            // editionCompletBindingSource
            // 
            this.editionCompletBindingSource.DataSource = typeof(BD.Common.Records.EditionComplet);
            this.editionCompletBindingSource.CurrentChanged += new System.EventHandler(this.editionsBindingSource_CurrentChanged);
            // 
            // button2
            // 
            this.button2.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.button2.Cursor = System.Windows.Forms.Cursors.Default;
            this.button2.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.button2.Image = global::BD.Properties.Resources.fleche_gauche;
            this.button2.Location = new System.Drawing.Point(78, 218);
            this.button2.Margin = new System.Windows.Forms.Padding(0);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(73, 23);
            this.button2.TabIndex = 100;
            this.button2.UseVisualStyleBackColor = true;
            this.button2.Click += new System.EventHandler(this.button2_Click_1);
            // 
            // button1
            // 
            this.button1.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.button1.Cursor = System.Windows.Forms.Cursors.Default;
            this.button1.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.button1.Image = global::BD.Properties.Resources.fleche_droite;
            this.button1.Location = new System.Drawing.Point(151, 218);
            this.button1.Margin = new System.Windows.Forms.Padding(0);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(73, 23);
            this.button1.TabIndex = 99;
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click_1);
            // 
            // lbErreurChargement
            // 
            this.lbErreurChargement.Font = new System.Drawing.Font("Tahoma", 13F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbErreurChargement.ForeColor = System.Drawing.Color.Red;
            this.lbErreurChargement.Location = new System.Drawing.Point(0, 135);
            this.lbErreurChargement.Name = "lbErreurChargement";
            this.lbErreurChargement.Size = new System.Drawing.Size(225, 44);
            this.lbErreurChargement.TabIndex = 97;
            this.lbErreurChargement.Text = "Impossible de\r\ncharger l\'image";
            this.lbErreurChargement.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            this.lbErreurChargement.Visible = false;
            // 
            // lbPasDimage
            // 
            this.lbPasDimage.Font = new System.Drawing.Font("Tahoma", 13F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbPasDimage.ForeColor = System.Drawing.Color.Red;
            this.lbPasDimage.Location = new System.Drawing.Point(0, 0);
            this.lbPasDimage.Name = "lbPasDimage";
            this.lbPasDimage.Size = new System.Drawing.Size(221, 198);
            this.lbPasDimage.TabIndex = 96;
            this.lbPasDimage.Text = "Pas d\'image";
            this.lbPasDimage.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            this.lbPasDimage.Visible = false;
            // 
            // pictureBox1
            // 
            this.pictureBox1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.pictureBox1.BackColor = System.Drawing.Color.Transparent;
            this.pictureBox1.ErrorImage = null;
            this.pictureBox1.InitialImage = null;
            this.pictureBox1.Location = new System.Drawing.Point(0, 0);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(222, 215);
            this.pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.CenterImage;
            this.pictureBox1.TabIndex = 98;
            this.pictureBox1.TabStop = false;
            // 
            // FicheAlbum
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.BackColor = System.Drawing.Color.White;
            this.Controls.Add(this.lvSerie);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label14);
            this.Controls.Add(this.label12);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label13);
            this.Controls.Add(this.lbGenres);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.lbIntegrale);
            this.Controls.Add(this.lbParution);
            this.Controls.Add(this.label11);
            this.Controls.Add(this.cbHorsSerie);
            this.Controls.Add(this.cbIntegral);
            this.Controls.Add(this.lbTome);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.lbTitre);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.lbEditions);
            this.Controls.Add(this.tbNotes);
            this.Controls.Add(this.tbHistoire);
            this.Controls.Add(this.lbTitreSerie);
            this.Controls.Add(this.label9);
            this.Controls.Add(this.lbColoristes);
            this.Controls.Add(this.lbDessinateurs);
            this.Controls.Add(this.lbScénaristes);
            this.Controls.Add(this.pnEditions);
            this.Controls.Add(this.panel1);
            this.DoubleBuffered = true;
            this.Font = new System.Drawing.Font("Tahoma", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Name = "FicheAlbum";
            this.Size = new System.Drawing.Size(522, 801);
            this.pnEditions.ResumeLayout(false);
            this.pnEditions.PerformLayout();
            this.panel1.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.albumCompletBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.editionCompletBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.BindingSource albumCompletBindingSource;
        private System.Windows.Forms.LinkLabel lbTitreSerie;
        private System.Windows.Forms.Panel pnEditions;
        private System.Windows.Forms.Label label30;
        private System.Windows.Forms.BindingSource editionCompletBindingSource;
        private System.Windows.Forms.LinkLabel lbEditionEditeur;
        private System.Windows.Forms.ListBox lbEditions;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.ListBox lbColoristes;
        private System.Windows.Forms.ListBox lbDessinateurs;
        private System.Windows.Forms.ListBox lbScénaristes;
        private System.Windows.Forms.TextBox tbNotes;
        private System.Windows.Forms.TextBox tbHistoire;
        private System.Windows.Forms.Label lbTitre;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Label lbTome;
        private System.Windows.Forms.CheckBox cbIntegral;
        private System.Windows.Forms.CheckBox cbHorsSerie;
        private System.Windows.Forms.Label lbParution;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.Label lbIntegrale;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label lbGenres;
        private System.Windows.Forms.Label label13;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.Label label14;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label38;
        private System.Windows.Forms.TextBox tbEditionNote;
        private System.Windows.Forms.Label lbEditionFormat;
        private System.Windows.Forms.Label label36;
        private System.Windows.Forms.Label lbEditionType;
        private System.Windows.Forms.Label lbEditionOrientation;
        private System.Windows.Forms.Label label32;
        private System.Windows.Forms.Label lbEditionReliure;
        private System.Windows.Forms.Label label34;
        private System.Windows.Forms.Label lbEditionDateAchat;
        private System.Windows.Forms.Label lbEditionAnnee;
        private System.Windows.Forms.Label label28;
        private System.Windows.Forms.CheckBox cbEditionCouleur;
        private System.Windows.Forms.CheckBox cbEditionVO;
        private System.Windows.Forms.CheckBox cbEditionDedicace;
        private System.Windows.Forms.CheckBox cbEditionStock;
        private System.Windows.Forms.CheckBox cbEditionOffert;
        private System.Windows.Forms.Label lbEditionPages;
        private System.Windows.Forms.Label label26;
        private System.Windows.Forms.Label lbEditionEtat;
        private System.Windows.Forms.Label label24;
        private System.Windows.Forms.Label lbEditionCote;
        private System.Windows.Forms.Label label22;
        private System.Windows.Forms.Label lbEditionPrix;
        private System.Windows.Forms.Label label20;
        private System.Windows.Forms.Label lbEditionCollection;
        private System.Windows.Forms.Label label18;
        private System.Windows.Forms.Label label16;
        private System.Windows.Forms.Label lbEditionISBN;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.ListView lvSerie;
        private System.Windows.Forms.ColumnHeader columnHeader1;
        private System.Windows.Forms.ListView lvEmprunts;
        private System.Windows.Forms.ColumnHeader columnHeader2;
        private System.Windows.Forms.ColumnHeader columnHeader3;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Label lbErreurChargement;
        private System.Windows.Forms.Label lbPasDimage;
        private System.Windows.Forms.PictureBox pictureBox1;

    }
}
