unit BD.Strings;

interface

const
  ChargementApp = 'Chargement de l''application';
  ChargementDatabase = 'Chargement des donn�es';
  ChargementOptions = 'Chargement des options';
  VerificationVersion = 'V�rification des versions';
  FinChargement = 'Fin du chargement';

  rsTransAbrvNB = 'N&B';
  rsTransAcheteLe = 'Achet� le';
  rsTransAlbum = 'Album';
  rsTransAlbumNotation = 'Notation';
  rsTransAlbums = 'Albums';
  rsTransAlbumsEmpruntes = 'Albums emprunt�s';
  rsTransAlbumsManquants = 'Albums manquants';
  rsTransAnnee = 'Ann�e';
  rsTransAnneeEdition = 'Ann�e d''�dition';
  rsTransAnneeParution = 'Ann�e de parution';
  //  rsTransApercu = 'Aper�u avant impression';
  rsTransAuteurs = 'Auteurs';
  //  rsTransAvec = 'Avec';
  rsTransBiographie = 'Biographie';
  rsTransCollection = 'Collection';
  rsTransConfig = 'Configuration';
  rsTransCoordonnees = 'Coordonn�es';
  rsTransCote = 'Cote';
  rsTransCouleur = 'Couleur';
  rsTransCouleurs = 'Couleurs';
  rsTransCreateurs = 'Cr�ateurs';
  rsTransDateAchat = 'Date d''achat';
  rsTransDedicace = 'D�dicac�';
  rsTransDescription = 'Description';
  rsTransDessins = 'Dessins';
  rsTransEditeur = 'Editeur';
  rsTransEdition = 'Edition';
  rsTransEditions = 'Editions';
  rsTransEmprunteLePar = 'Emprunt� le %s par %s';
  rsTransEmprunts = 'Emprunts';
  //  rsTransEmprunteur = 'Emprunteur';
  rsTransEmprunteurs = 'Emprunteurs';
  rsTransEtat = 'Etat';
  rsTransFiche = 'Fiche';
  rsTransFormatEdition = 'Format d''�dition';
  rsTransGenre = 'Genre';
  rsTransGenres = 'Genres';
  rsTransGratuit = 'Gratuit';
  rsTransHistoire = 'Histoire';
  rsTransHorsSerie = 'Hors s�rie';
  //  rsTransImprimer = 'Imprimer';
  rsTransImpression = 'Impression';
  rsTransImage = 'Image';
  rsTransIntegrale = 'Int�grale';
  rsTransISBN = 'Num�ro ISBN';
  rsTransListeDetail = 'Liste d�taill�e';
  rsTransListeSimple = 'Liste simplifi�e';
  rsTransLongueur = 'Longueur';
  rsTransMaximum = 'Maximum';
  rsTransMinimum = 'Minimum';
  rsTransMoisParution = 'Mois de parution';
  //  rsTransNationalite = 'Nationalit�';
  rsTransNombreDEditions = 'Nombre d''�ditions';
  rsTransNombreDePages = 'Nombre de pages';
  rsTransNomUnivers = 'Nom univers';
  rsTransNotes = 'Notes';
  rsTransNumerote = 'Num�rot�';
  rsTransNumeroPerso = 'Num�rotation personnelle';
  rsTransOrientation = 'Orientation';
  //  rsTransOui = 'Oui';
  rsTransOffert = 'Offert';
  rsTransOffertLe = 'Offert le';
  rsTransPage = 'Page';
  rsTransPages = 'Pages';
  rsTransParaDB = 'Para-BD';
  rsTransPret = 'Pr�t';
  rsTransPrete = 'Pr�t�';
  rsTransPrevisionsSorties = 'Pr�visions de sorties';
  rsTransPrix = 'Prix';
  //  rsTransRealisateur = 'R�alisateur';
  rsTransReliure = 'Type de reliure';
  //  rsTransReperes = 'Rep�res';
  rsTransRetour = 'Retour';
  rsTransScenario = 'Sc�nario';
  rsTransSensLecture = 'Sens de lecture';
  rsTransSerie = 'S�rie';
  rsTransSerieChercherManquants = 'Chercher les manquants';
  rsTransSerieComplete = 'S�rie compl�te';
  rsTransSerieEnCours = 'S�rie en cours';
  rsTransSeries = 'S�ries';
  rsTransSerieSuivreSorties = 'Suivre les sorties';
  rsTransSerieNotation = 'Notation';
  rsTransSerieTerminee = 'S�rie termin�e';
  rsTransStock = 'Stock';
  //  rsTransSupport = 'Support';
  rsTransTerminee = 'Termin�e';
  rsTransTitre = 'Titre';
  rsTransTitreAlbum = 'Titre album';
  rsTransTitreSerie = 'Titre s�rie';
  rsTransTome = 'Tome';
  //  rsTransTotal = 'Total';
  //  rsTransTranche = 'Tranche';
  rsTransTypeEdition = 'Type d''�dition';
  rsTransUnivers = 'Univers';
  rsTransVO = 'VO';

  rsAlbumsNB = 'Albums N&B';
  rsAlbumsStock = 'Albums en stock';
  //  rsAlbumsTrouves = 'albums trouv�s';
  rsAlbumsVO = 'Albums en VO';
  rsAlbumsIntegrales = 'Int�grales';
  rsAlbumsIntegrale = 'Int�grale';
  rsAlbumsHorsSerie = 'Hors s�rie';
  rsAlbumsDedicaces = 'Albums d�dicac�s';
  rsInformationsBDtheque = 'Informations sur la BDth�que';
  rsListeAchats = 'Liste des achats';
  rsListeCompleteAlbums = 'Liste compl�te des albums';
  rsResultatRecherche = 'R�sultat de recherche';
  rsListeAlbumsEmpruntes = 'Liste des albums emprunt�s';
  rsListeEmprunts = 'Liste des emprunts';
  //  rsNoCriteres = 'Aucun crit�re de d�finis !';
  rsNoEmprunts = 'Pas d''emprunts';
  rsNombreAlbums = 'Nombre d''albums';
  rsNombreSeries = 'Nombre de series';
  rsNombreMoyenEmprunts = 'Nombre moyen d''emprunts';
  //  rsSupportsAchetes = 'Supports achet�s';
  //  rsSupportsEnregistres = 'Supports enregistr�s';
  rsTitreListeEmprunts = 'Liste des emprunts';
  rsValeurConnue = 'Valeur connue';
  rsValeurEstimee = 'Valeur estim�e';
  rsValeurMoyenne = 'Valeur moyenne';

  //  rsErrorSaveCfg = 'Impossible de configurer sauver la configuration de l''imprimante';
  rsErrorCreerEnr = 'Impossible de cr�er l''enregistrement correspondant';
  rsErrorModifEnr = 'Impossible de modifier l''enregistrement correspondant';
  rsErrorSuppEnr = 'Impossible de supprimer l''enregistrement correspondant';
  rsErrorFindEnr = 'Impossible de trouver l''enregistrement correspondant';
  //  rsErrorPageTropPetite = 'La taille du papier s�lectionn� n''est pas suffisante';
  rsOuvertureSessionRate = 'L''ouverture de la base de donn�es n''a pu �tre �ffectu�e!';
  //  rsPasEnregistrer = 'Impossible d''enregistrer les modifications';

  rsAlbumObligatoire = 'Vous devez choisir un album !';
  rsTitreObligatoire = 'Le titre est obligatoire!';
  rsTitreObligatoireAlbumSansSerie = 'Le titre est obligatoire pour un album sans s�rie!';
  rsTitreObligatoireParaBDSansSerie = 'Le titre est obligatoire pour un para-bd sans s�rie!';
  rsNomObligatoire = 'Le nom est obligatoire !';
  rsSerieObligatoire = 'La s�rie est obligatoire !';
  rsEditeurObligatoire = 'L''�diteur est obligatoire !';
  rsMoisParutionIncorrect = 'Le mois de parution doit �tre compris entre 1 et 12 !';
  rsCoteIncomplete = 'Une cote doit �tre compos�e d''un prix ET d''une ann�e.';
  rsTypeParaBDObligatoire = 'Le type de para-BD est obligatoire !';

  rsLienAlbum = 'Attention, les personnes et les emprunteurs qui ont un lien avec cet album en seront d�tach�es.';
  rsSupprimerAlbum = '�tes-vous s�r de vouloir supprimer cet album ?';

  rsLienParaBD = 'Attention, les s�ries qui ont un lien avec cet objet en seront d�tach�es.';
  rsSupprimerParaBD = '�tes-vous s�r de vouloir supprimer cet objet ?';

  rsLienAchatAlbum = 'Attention, les personnes qui ont un lien avec cet album en seront d�tach�es.';
  rsLienAchatParaBD = 'Attention, les personnes qui ont un lien avec cet album en seront d�tach�es.';
  rsSupprimerAchat = '�tes-vous s�r de vouloir supprimer cet achat ?';

  rsNewTitre = 'Nouveau %s';
  rsEntrerNewTitre = 'Entrez le nouveau nom de %s :';
  rsEntrerModifyTitre = 'Entrez le nouveau nom de %s :';
  rsTitreStillUsed = 'Ce nom de %s est d�j� utilis�';

  rsLienEditeur = 'Attention, les s�ries et les �ditions qui un lien avec ce type seront class�s comme Ind�fini';
  rsSupprimerEditeur = '�tes-vous s�r de vouloir supprimer cet �diteur ?';

  rsGenre = 'genre';
  rsLienGenre = 'Attention, les s�ries qui ont un lien avec ce genre en seront d�tach�es';
  rsSupprimerGenre = '�tes-vous s�r de vouloir supprimer ce genre ?';

  rsLienCollection = 'Attention, les s�ries et les editions qui ont un lien avec cette collection seront d�tach�es.';
  rsSupprimerCollection = '�tes-vous s�r de vouloir supprimer cette collection ?';

  rsAuteur = 'auteur';
  rsLienAuteur = 'Attention, les albums qui ont un lien avec cet auteur en seront d�tach�s.';
  rsSupprimerAuteur = '�tes-vous s�r de vouloir supprimer cet auteur ?';

  rsLienEmprunteur = 'Attention, les albums qui ont un lien avec cet emprunteur en seront d�tach�s.';
  rsSupprimerEmprunteur = '�tes-vous s�r de vouloir supprimer cet emprunteur ?';

  rsLienSerie = 'Attention, les albums qui ont un lien avec cette s�rie en seront d�tach�s.';
  rsSupprimerSerie = '�tes-vous s�r de vouloir supprimer cette s�rie ?';

  rsLienUnivers = 'Attention, les s�ries et les albums qui ont un lien avec cet univers en seront d�tach�s.';
  rsSupprimerUnivers = '�tes-vous s�r de vouloir supprimer cet univers ?';

  rsLienEdition = 'Attention, les emprunts de cette �dition seront supprim�s.';
  rsSupprimerEdition = '�tes-vous s�r de vouloir supprimer cette �dition ?';

  rsOperationEnCours = 'Operation en cours';
  rsToutesCategories = '(Toutes)';

implementation

end.
