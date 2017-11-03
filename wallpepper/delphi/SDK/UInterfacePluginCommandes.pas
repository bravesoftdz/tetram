unit UInterfacePluginCommandes;

interface

uses UInterfacePlugin;

type
  RInfoCommande = record
    IdCommande: Integer;
    MenuLabel: ShortString;
  end;

  IInterfacePluginCommandes = interface  // WP-2.1.0.23
  ['{FBB60A3E-F22A-48DC-B5C8-4E3A34ABA4D6}']
    // Commandes est initialisé à la taille Count
    // si la taille est insuffisante, la procedure doit indiquer dans Count la taille necessaire en retournant une valeur négative
    // dans ce cas, le contenu de Commandes n'est pas utilisé et le tableau peut être réinitialisé par l'application
    // la commande sera de nouveau appelée avec un tableau initialisé à la taille demandée
    procedure GetCommandes(var Count: Integer; var Commandes: array of RInfoCommande); stdcall;
    // IdCommande a la valeur indiquée dans le tableau retournée par GetCommandes
    procedure ExecuteCommande(IdCommande: Integer; Writer: IOptionsWriter); stdcall;
  end;

implementation

end.
