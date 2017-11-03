unit UInterfaceChange;

interface

type
//  ctAutomatique: changement � intervales r�guli�s
//  ctProgramme: changement � horaire fixe
//  ctManuel: changement demand� par l'utilisateur
  TChangeType = (ctAutomatique, ctProgramme, ctManuel);

  IChange = interface // WP-2.1.0.17
  ['{0912F25A-257F-4683-8E5A-9C24BAD135C2}']
    // Renvoyer False pour refuser le changement de fond d'�cran
    // Exclusion = True si un �l�ment exclu est d�tect�
    function CanChange(Declenchement: TChangeType; Exclusion: Boolean): Boolean; stdcall;
    // Renvoyer True pour forcer le changement de fond d'�cran
    // Exclusion = True si un �l�ment exclu est d�tect�
    function ForceChange(Declenchement: TChangeType; Exclusion: Boolean): Boolean; stdcall;
  end;

  IValideImage = interface // WP-2.1.0.17
  ['{A842F591-9E6A-4FD7-B89A-A1BB696EF27B}']
    // Image contient le chemin d'acc�s complet � l'image
    // Archive contient le nom de l'archive o� stock�e l'image le cas �ch�ant
    // Renvoyer False pour refuser l'image choisie par WallPepper
    // Mettre AutreImage � False si vous ne voulez pas que WallPepper en propose une autre.
    // Dans ce cas, WallPepper ne changera pas le fond.
    // IsValide est appel�e apr�s CanChange et ForceChange de l'interface IChange 
    function IsValide(Image, Archive: PChar; var AutreImage: Boolean): Boolean; stdcall;
  end;

  IForceImage = interface // WP-2.1.0.18
  ['{7B391BA6-9CD7-4B75-9F39-EFF9442333E0}']
    // Image et Archive contiennent le chemin d'acc�s complet � l'archive/image qu'on tente de r�apliquer
    // si vide: on demande une nouvelle image
    // Renvoyer True pour indiquer qu'on a renseign� ou qu'on accepte les valeurs pr�sentes dans Archive/Image
    // Mettre UtiliserHistorique � True si vous voulez que WallPepper contr�le si l'image est pr�sente dans l'historique ou non
    function ForceImage(var Image, Archive: ShortString; out UtiliserHistorique: Boolean): Boolean; stdcall;
  end;

implementation

end.
