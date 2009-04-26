unit Textes;

interface

const
  ChargementApp = 'Chargement de l''application';
  ChargementDatabase = 'Chargement des données';
  ChargementOptions = 'Chargement des options';
  VerificationVersion = 'Vérification des versions';
  FinChargement = 'Fin du chargement';

  rsTransAbrvNB = 'N&B';
  rsTransAcheteLe = 'Acheté le';
  rsTransAlbum = 'Album';
  rsTransAlbums = 'Albums';
  rsTransAlbumsEmpruntes = 'Albums empruntés';
  rsTransAlbumsManquants = 'Albums manquants';
  rsTransAnnee = 'Année';
  rsTransAnneeEdition = 'Année d''édition';
  rsTransAnneeParution = 'Année de parution';
  //  rsTransApercu = 'Aperçu avant impression';
  rsTransAuteurs = 'Auteurs';
  //  rsTransAvec = 'Avec';
  rsTransBiographie = 'Biographie';
  rsTransCollection = 'Collection';
  rsTransConfig = 'Configuration';
  rsTransCoordonnees = 'Coordonnées';
  rsTransCote = 'Cote';
  rsTransCouleur = 'Couleur';
  rsTransCouleurs = 'Couleurs';
  rsTransCreateurs = 'Créateurs';
  rsTransDateAchat = 'Date d''achat';
  rsTransDedicace = 'Dédicacé';
  rsTransDescription = 'Description';
  rsTransDessins = 'Dessins';
  rsTransEditeur = 'Editeur';
  rsTransEdition = 'Edition';
  rsTransEditions = 'Editions';
  rsTransEmprunteLePar = 'Emprunté le %s par %s';
  rsTransEmprunts = 'Emprunts';
  //  rsTransEmprunteur = 'Emprunteur';
  rsTransEmprunteurs = 'Emprunteurs';
  rsTransEtat = 'Etat';
  rsTransFiche = 'Fiche';
  rsTransFormatEdition = 'Format d''édition';
  rsTransGenre = 'Genre';
  rsTransGenres = 'Genres';
  rsTransGratuit = 'Gratuit';
  rsTransHistoire = 'Histoire';
  rsTransHorsSerie = 'Hors série';
  //  rsTransImprimer = 'Imprimer';
  rsTransImpression = 'Impression';
  rsTransImage = 'Image';
  rsTransIntegrale = 'Intégrale';
  rsTransISBN = 'Numéro ISBN';
  rsTransListeDetail = 'Liste détaillée';
  rsTransListeSimple = 'Liste simplifiée';
  rsTransLongueur = 'Longueur';
  rsTransMaximum = 'Maximum';
  rsTransMinimum = 'Minimum';
  rsTransMoisParution = 'Mois de parution';
  //  rsTransNationalite = 'Nationalité';
  rsTransNombreDEditions = 'Nombre d''éditions';
  rsTransNombreDePages = 'Nombre de pages';
  rsTransNotes = 'Notes';
  rsTransNumerote = 'Numéroté';
  rsTransNumeroPerso = 'Numérotation personnelle';
  rsTransOrientation = 'Orientation';
  //  rsTransOui = 'Oui';
  rsTransOffert = 'Offert';
  rsTransOffertLe = 'Offert le';
  rsTransPage = 'Page';
  rsTransPages = 'Pages';
  rsTransParaDB = 'Para-BD';
  rsTransPret = 'Prêt';
  rsTransPrete = 'Prêté';
  rsTransPrevisionsSorties = 'Prévisions de sorties';
  rsTransPrix = 'Prix';
  //  rsTransRealisateur = 'Réalisateur';
  rsTransReliure = 'Type de reliure';
  //  rsTransReperes = 'Repères';
  rsTransRetour = 'Retour';
  rsTransScenario = 'Scénario';
  rsTransSensLecture = 'Sens de lecture';
  rsTransSerie = 'Série';
  rsTransSerieChercherManquants = 'Chercher les manquants';
  rsTransSerieComplete = 'Série complète';
  rsTransSerieEnCours = 'Série en cours';
  rsTransSeries = 'Séries';
  rsTransSerieSuivreSorties = 'Suivre les sorties';
  rsTransSerieTerminee = 'Série terminée';
  rsTransStock = 'Stock';
  //  rsTransSupport = 'Support';
  rsTransTerminee = 'Terminée';
  rsTransTitre = 'Titre';
  rsTransTitreAlbum = 'Titre album';
  rsTransTitreSerie = 'Titre série';
  rsTransTome = 'Tome';
  //  rsTransTotal = 'Total';
  //  rsTransTranche = 'Tranche';
  rsTransTypeEdition = 'Type d''édition';
  rsTransVO = 'VO';

  rsAlbumsNB = 'Albums N&B';
  rsAlbumsStock = 'Albums en stock';
  //  rsAlbumsTrouves = 'albums trouvés';
  rsAlbumsVO = 'Albums en VO';
  rsAlbumsIntegrales = 'Intégrales';
  rsAlbumsHorsSerie = 'Hors série';
  rsAlbumsDedicaces = 'Albums dédicacés';
  rsInformationsBDtheque = 'Informations sur la BDthèque';
  rsListeAchats = 'Liste des achats';
  rsListeCompleteAlbums = 'Liste complète des albums';
  rsResultatRecherche = 'Résultat de recherche';
  rsListeAlbumsEmpruntes = 'Liste des albums empruntés';
  rsListeEmprunts = 'Liste des emprunts';
  //  rsNoCriteres = 'Aucun critère de définis !';
  rsNoEmprunts = 'Pas d''emprunts';
  rsNombreAlbums = 'Nombre d''albums';
  rsNombreSeries = 'Nombre de series';
  rsNombreMoyenEmprunts = 'Nombre moyen d''emprunts';
  //  rsSupportsAchetes = 'Supports achetés';
  //  rsSupportsEnregistres = 'Supports enregistrés';
  rsTitreListeEmprunts = 'Liste des emprunts';
  rsValeurConnue = 'Valeur connue';
  rsValeurEstimee = 'Valeur estimée';
  rsValeurMoyenne = 'Valeur moyenne';

  //  rsErrorSaveCfg = 'Impossible de configurer sauver la configuration de l''imprimante';
  rsErrorCreerEnr = 'Impossible de créer l''enregistrement correspondant';
  rsErrorModifEnr = 'Impossible de modifier l''enregistrement correspondant';
  rsErrorSuppEnr = 'Impossible de supprimer l''enregistrement correspondant';
  rsErrorFindEnr = 'Impossible de trouver l''enregistrement correspondant';
  //  rsErrorPageTropPetite = 'La taille du papier sélectionné n''est pas suffisante';
  rsOuvertureSessionRate = 'L''ouverture de la base de données n''a pu être éffectuée!';
  //  rsPasEnregistrer = 'Impossible d''enregistrer les modifications';

  rsAlbumObligatoire = 'Vous devez choisir un album !';
  rsTitreObligatoire = 'Le titre est obligatoire!';
  rsTitreObligatoireAlbumSansSerie = 'Le titre est obligatoire pour un album sans série!';
  rsTitreObligatoireParaBDSansSerie = 'Le titre est obligatoire pour un para-bd sans série!';
  rsNomObligatoire = 'Le nom est obligatoire !';
  rsSerieObligatoire = 'La série est obligatoire !';
  rsEditeurObligatoire = 'L''éditeur est obligatoire !';
  rsMoisParutionIncorrect = 'Le mois de parution doit être compris entre 1 et 12 !';
  rsCoteIncomplete = 'Une cote doit être composée d''un prix ET d''une année.';
  rsTypeParaBDObligatoire = 'Le type de para-BD est obligatoire !';

  rsLienAlbum = 'Attention, les personnes et les emprunteurs qui ont un lien avec cet album en seront détachées.';
  rsSupprimerAlbum = 'Êtes-vous sûr de vouloir supprimer cet album ?';

  rsLienParaBD = 'Attention, les séries qui ont un lien avec cet objet en seront détachées.';
  rsSupprimerParaBD = 'Êtes-vous sûr de vouloir supprimer cet objet ?';

  rsLienAchatAlbum = 'Attention, les personnes qui ont un lien avec cet album en seront détachées.';
  rsLienAchatParaBD = 'Attention, les personnes qui ont un lien avec cet album en seront détachées.';
  rsSupprimerAchat = 'Êtes-vous sûr de vouloir supprimer cet achat ?';

  rsNewTitre = 'Nouveau %s';
  rsEntrerNewTitre = 'Entrez le nouveau nom de %s :';
  rsEntrerModifyTitre = 'Entrez le nouveau nom de %s :';
  rsTitreStillUsed = 'Ce nom de %s est déjà utilisé';

  rsLienEditeur = 'Attention, les séries et les éditions qui un lien avec ce type seront classés comme Indéfini';
  rsSupprimerEditeur = 'Êtes-vous sûr de vouloir supprimer cet éditeur ?';

  rsGenre = 'genre';
  rsLienGenre = 'Attention, les séries qui ont un lien avec ce genre en seront détachées';
  rsSupprimerGenre = 'Êtes-vous sûr de vouloir supprimer ce genre ?';

  rsLienCollection = 'Attention, les séries et les editions qui ont un lien avec cette collection seront détachées.';
  rsSupprimerCollection = 'Êtes-vous sûr de vouloir supprimer cette collection ?';

  rsAuteur = 'auteur';
  rsLienAuteur = 'Attention, les albums qui ont un lien avec cet auteur en seront détachés.';
  rsSupprimerAuteur = 'Êtes-vous sûr de vouloir supprimer cet auteur ?';

  rsLienEmprunteur = 'Attention, les albums qui ont un lien avec cet emprunteur en seront détachés.';
  rsSupprimerEmprunteur = 'Êtes-vous sûr de vouloir supprimer cet emprunteur ?';

  rsLienSerie = 'Attention, les albums qui ont un lien avec cette série seront supprimés.';
  rsSupprimerSerie = 'Êtes-vous sûr de vouloir supprimer cette série ?';

  rsLienEdition = 'Attention, les emprunts de cette édition seront supprimés.';
  rsSupprimerEdition = 'Êtes-vous sûr de vouloir supprimer cette édition ?';

  rsOperationEnCours = 'Operation en cours';

implementation

end.
