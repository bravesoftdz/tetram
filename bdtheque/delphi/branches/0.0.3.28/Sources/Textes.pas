unit Textes;

interface

const
  rsTransAbrvNB = 'N&B';
  rsTransAcheteLe = 'Achet� le';
  rsTransAlbum = 'Album';
  rsTransAlbums = 'Albums';
  rsTransAlbumsEmpruntes = 'Albums emprunt�s';
  rsTransAlbumsManquants = 'Albums manquants';
  rsTransAnneeEdition = 'Ann�e d''�dition';
  rsTransAnneeParution = 'Ann�e de parution';
  //  rsTransApercu = 'Aper�u avant impression';
  //  rsTransAvec = 'Avec';
  rsTransBiographie = 'Biographie';
  rsTransCollection = 'Collection';
  rsTransConfig = 'Configuration';
  rsTransCoordonnees = 'Coordonn�es';
  rsTransCouleur = 'Couleur';
  rsTransCouleurs = 'Couleurs';
  rsTransDedicace = 'D�dicac�';
  rsTransDessins = 'Dessins';
  rsTransEditeur = 'Editeur';
  rsTransEdition = 'Edition';
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
  //  rsTransNationalite = 'Nationalit�';
  rsTransNotes = 'Notes';
  rsTransOrientation = 'Orientation';
  //  rsTransOui = 'Oui';
  rsTransOffert = 'Offert';
  rsTransOffertLe = 'Offert le';
  rsTransPage = 'Page';
  rsTransPages = 'Pages';
  rsTransPret = 'Pr�t';
  rsTransPrete = 'Pr�t�';
  rsTransPrix = 'Prix';
  //  rsTransRealisateur = 'R�alisateur';
  rsTransReliure = 'Type de reliure';
  //  rsTransReperes = 'Rep�res';
  rsTransRetour = 'Retour';
  rsTransScenario = 'Sc�nario';
  rsTransSerie = 'S�rie';
  rsTransSerieEnCours = 'S�rie en cours';
  rsTransSeries = 'S�ries';
  rsTransSerieTerminee = 'S�rie termin�e';
  rsTransStock = 'Stock';
  //  rsTransSupport = 'Support';
  rsTransTerminee = 'Termin�e';
  //  rsTransTitre = 'Titre';
  rsTransTome = 'Tome';
  //  rsTransTotal = 'Total';
  //  rsTransTranche = 'Tranche';
  rsTransTypeEdition = 'Type d''�dition';
  rsTransVO = 'VO';

  rsAlbumsNB = 'Albums N&B';
  rsAlbumsStock = 'Albums en stock';
  //  rsAlbumsTrouves = 'albums trouv�s';
  rsAlbumsVO = 'Albums en VO';
  rsAlbumsIntegrales = 'Int�grales';
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
  rsTitreObligatoire = 'Le titre est obligatoire !';
  rsNomObligatoire = 'Le nom est obligatoire !';
  rsSerieObligatoire = 'La s�rie est obligatoire !';
  rsEditeurObligatoire = 'L''�diteur est obligatoire !';
  rsMoisParutionIncorrect = 'Le mois de parution doit �tre compris entre 1 et 12 !';

  rsLienAlbum = 'Attention, les personnes et les emprunteurs qui ont un lien avec cet album en seront d�tach�es.';
  rsSupprimerAlbum = '�tes-vous s�r de vouloir supprimer cet album ?';

  rsNewTitre = 'Nouveau %s';
  rsEntrerNewTitre = 'Entrez le nouveau nom de %s:';
  rsEntrerModifyTitre = 'Entrez le nouveau nom de %s:';
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

  rsLienSerie = 'Attention, les albums qui ont un lien avec cette s�rie seront supprim�s.';
  rsSupprimerSerie = '�tes-vous s�r de vouloir supprimer cette s�rie ?';

  rsOperationEnCours = 'Operation en cours';

implementation

end.
