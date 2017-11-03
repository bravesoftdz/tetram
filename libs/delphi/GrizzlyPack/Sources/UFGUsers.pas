unit UFGUsers;

{This unit contains all the const that will help you
to localize UserManager components}

interface

Const
  msgNoDatasetDefined = 'Dataset absent, pas d''identification possible !';
  msgNoAccessDatasetDefined = 'AccessDataset absent, utilisation des niveaux d''acc�s impossible !';
  msgBadPasswordEmptyString = 'Mot de passe incorrect (chaine vide)';
  msgGoodPassword = 'Mot de passe correct';
  msgBadPassword = 'Mot de passe incorrect';
  msgTriesSinceLastGood = '%s essais infructueux depuis le dernier r�ussi';
  msgUnknownUser = 'Utilisateur inconnu';
  msgIdentification = 'Identification';
  msgPassword = 'Mot de passe';
  msgSupervisorPassword = 'Mot de passe Superviseur';
  msgCantModifySupervisorLevel = 'Le niveau du superviseur n''est pas modifiable';
  msgCantSaveWithoutPassword = 'Impossible de sauver si le mot de passe est ind�fini !';
  msgCantDeleteSupervisor = 'Superviseur non effacable !';
  msgIdApplication = 'Application : %s';
  msgBadConfirmation = 'La confirmation ne correspond pas';
  msgUserShortName = 'Identifiant de l''utilisateur';
  msgUserPassword = 'Mot de passe';
  msgOk = 'OK';
  msgCancel = 'Annuler';
  msgModifyPassword = 'Modifier un mot de passe';
  msgOldPassword = 'Ancien mot de passe';
  msgNewPassword = 'Nouveau mot de passe';
  msgConfirmationPassword = 'Confirmation';
  msgUsersFile = 'Fichier des Utilisateurs';
  msgLongName = 'N&om de l''utilisateur';
  msgShortName = '&Identifiant de l''utilisateur';
  msgUserLevel = 'Ni&veau de l''utilisateur (1, 2 ou 3)';
  msgChangePassword = '&Changer le mot de passe';
  msgChangeLevel = 'N&iveau...';
  msgClose = '&Fermer';
  msgYes = '&Oui';
  msgNo = '&Non';

  msgAccessElemDoesNotExist = 'L''�l�ment d''acc�s "%s" ' + 'n''existe pas !';
  msgAccessDenied = 'Droits d''acc�s insuffisants pour acc�der � : %s';

    { Access Rights messages }
  msgAccessKindLevel = 'Par n&iveau';
  msgAccessKindUser = 'Par &utilisateur';
  msgAccessKindBoth = 'Par les &deux';
  msgEnterElement = 'Entrer dans un �l�ment de l''application';
  msgElementName = 'Nom de l''�l�ment';

    { Window EditElements }
  msgAccessManagement = 'Gestion des droits d''acc�s';
  msgPerLevel = 'Par n&iveau';
  msgShortLevel = 'N';
  msgPerUser = 'Par &utilisateur';
  msgShortUser = 'U';
  msgPerBoth = 'Par les &deux';
  msgShortBoth = 'D';
  msgShortElemName = 'Nom �l�ment';
  msgRequiredAccessRight = 'Niveau d''acc�s requis';
  msgRequiredPassword = 'Mot de passe requis';
  msgBtnModifyPassword = 'Modifier mot de &passe';
  msgShortUsersFile = 'Fichier utilisateurs';
  msgUsersRights = 'Droits utilisateurs';
  msgAccessFieldElem = 'El�ment';
  msgAccessFieldAccessKind = 'Type';
  msgAccessFieldLevel = 'Niveau';
  msgAccessRightIncorrect = 'Le droit d''acc�s requis doit �tre compris entre 1 et 4 !';
  msgNoUserLimitedElement = 'Il n''y a aucun �l�ment ayant un droit d''acc�s sur les ' +
    'utilisateurs !';

    { CrossEditing }
  msgUsers = 'Utilisateurs';
  msgUser = 'Utilisateur';
  msgSelectedElem = 'El�ment s�lectionn�';
  msgAccessEnabled = 'Acc�s autoris�';
  msgSearch = 'Rechercher';
  msgAUser = 'Un utilisateur';
  msgAnElem = 'Un �l�ment';
  msgTypeSearchString = 'Saisissez la cha�ne � rechercher';
  

implementation

end.
