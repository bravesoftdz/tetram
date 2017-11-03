unit UInterfaceDessinCalendrier;

interface

type
  IDessinCalendrier = interface // WP-2.1.0.18
  ['{EF4103E0-5330-4E73-BBBF-F7303335C88F}']
    // doit renvoyer False si la couleur pass�e en param�tre va �tre utiliser par le plugin pour dessiner
    function CouleurTransparence(Couleur: Integer): Boolean; stdcall;
    // doit renvoyer la taille de l'image finale dans Largeur et Hauteur
    // peut �tre appel�e plusieurs fois si le buffer pr�vu par WP n'est pas
    // assez grand pour contenir la taille finale
    procedure DessinMois(Mois, Annee: Word; hHandle: THandle; var Largeur, Hauteur: Integer; CouleurTransparence: Integer); stdcall;
    procedure DessinTitreMois(Mois, Annee: Word; hHandle: THandle; var Largeur, Hauteur: Integer; CouleurTransparence: Integer); stdcall;
  end;

implementation

end.
