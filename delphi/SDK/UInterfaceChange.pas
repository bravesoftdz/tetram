unit UInterfaceChange;

interface

type
//  ctAutomatique: changement à intervales réguliés
//  ctProgramme: changement à horaire fixe
//  ctManuel: changement demandé par l'utilisateur
  TChangeType = (ctAutomatique, ctProgramme, ctManuel);

  IChange = interface // WP-2.1.0.17
  ['{0912F25A-257F-4683-8E5A-9C24BAD135C2}']
    // Renvoyer False pour refuser le changement de fond d'écran
    // Exclusion = True si un élément exclu est détecté
    function CanChange(Declenchement: TChangeType; Exclusion: Boolean): Boolean; stdcall;
    // Renvoyer True pour forcer le changement de fond d'écran
    // Exclusion = True si un élément exclu est détecté
    function ForceChange(Declenchement: TChangeType; Exclusion: Boolean): Boolean; stdcall;
  end;

  IValideImage = interface // WP-2.1.0.17
  ['{A842F591-9E6A-4FD7-B89A-A1BB696EF27B}']
    // Image contient le chemin d'accès complet à l'image
    // Archive contient le nom de l'archive où stockée l'image le cas échéant
    // Renvoyer False pour refuser l'image choisie par WallPepper
    // Mettre AutreImage à False si vous ne voulez pas que WallPepper en propose une autre.
    // Dans ce cas, WallPepper ne changera pas le fond.
    // IsValide est appelée après CanChange et ForceChange de l'interface IChange 
    function IsValide(Image, Archive: PChar; var AutreImage: Boolean): Boolean; stdcall;
  end;

  IForceImage = interface // WP-2.1.0.18
  ['{7B391BA6-9CD7-4B75-9F39-EFF9442333E0}']
    // Image et Archive contiennent le chemin d'accès complet à l'archive/image qu'on tente de réapliquer
    // si vide: on demande une nouvelle image
    // Renvoyer True pour indiquer qu'on a renseigné ou qu'on accepte les valeurs présentes dans Archive/Image
    // Mettre UtiliserHistorique à True si vous voulez que WallPepper contrôle si l'image est présente dans l'historique ou non
    function ForceImage(var Image, Archive: ShortString; out UtiliserHistorique: Boolean): Boolean; stdcall;
  end;

implementation

end.
