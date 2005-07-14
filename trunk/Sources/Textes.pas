unit Textes;

interface

const
  rsTransAbrvNB = 'N&B';
  rsTransAcheteLe = 'Acheté le';
  rsTransAlbum = 'Album';
  rsTransAlbums = 'Albums';
  rsTransAlbumsEmpruntes = 'Albums empruntés';
  rsTransAlbumsManquants = 'Albums manquants';
  rsTransAnneeEdition = 'Année d''édition';
  rsTransAnneeParution = 'Année de parution';
  //  rsTransApercu = 'Aperçu avant impression';
  //  rsTransAvec = 'Avec';
  rsTransBiographie = 'Biographie';
  rsTransCollection = 'Collection';
  rsTransConfig = 'Configuration';
  rsTransCoordonnees = 'Coordonnées';
  rsTransCouleur = 'Couleur';
  rsTransCouleurs = 'Couleurs';
  rsTransDedicace = 'Dédicacé';
  rsTransDessins = 'Dessins';
  rsTransEditeur = 'Editeur';
  rsTransEdition = 'Edition';
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
  //  rsTransNationalite = 'Nationalité';
  rsTransNotes = 'Notes';
  rsTransOrientation = 'Orientation';
  //  rsTransOui = 'Oui';
  rsTransOffert = 'Offert';
  rsTransOffertLe = 'Offert le';
  rsTransPage = 'Page';
  rsTransPages = 'Pages';
  rsTransPret = 'Prêt';
  rsTransPrete = 'Prêté';
  rsTransPrevisionsSorties = 'Prévisions de sorties';
  rsTransPrix = 'Prix';
  //  rsTransRealisateur = 'Réalisateur';
  rsTransReliure = 'Type de reliure';
  //  rsTransReperes = 'Repères';
  rsTransRetour = 'Retour';
  rsTransScenario = 'Scénario';
  rsTransSerie = 'Série';
  rsTransSerieEnCours = 'Série en cours';
  rsTransSeries = 'Séries';
  rsTransSerieTerminee = 'Série terminée';
  rsTransStock = 'Stock';
  //  rsTransSupport = 'Support';
  rsTransTerminee = 'Terminée';
  //  rsTransTitre = 'Titre';
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
  rsTitreObligatoire = 'Le titre est obligatoire !';
  rsNomObligatoire = 'Le nom est obligatoire !';
  rsSerieObligatoire = 'La série est obligatoire !';
  rsEditeurObligatoire = 'L''éditeur est obligatoire !';
  rsMoisParutionIncorrect = 'Le mois de parution doit être compris entre 1 et 12 !';

  rsLienAlbum = 'Attention, les personnes et les emprunteurs qui ont un lien avec cet album en seront détachées.';
  rsSupprimerAlbum = 'Êtes-vous sûr de vouloir supprimer cet album ?';

  rsNewTitre = 'Nouveau %s';
  rsEntrerNewTitre = 'Entrez le nouveau nom de %s:';
  rsEntrerModifyTitre = 'Entrez le nouveau nom de %s:';
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

  rsOperationEnCours = 'Operation en cours';

implementation

end.
