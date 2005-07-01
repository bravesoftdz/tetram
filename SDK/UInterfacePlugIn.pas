unit UInterfacePlugIn;

interface

type
  IOptionsWriter = interface // WP-2.1.0.18
  ['{D5BD7B76-3D79-4CDC-9F50-0736E2DABF1D}']
    function SectionExists(const Section: ShortString): Boolean; stdcall;
    function ReadString(const Section, Ident, Default: ShortString): ShortString; stdcall;
    procedure WriteString(const Section, Ident, Value: ShortString); stdcall;
    function ReadInteger(const Section, Ident: ShortString; Default: Longint): Longint; stdcall;
    procedure WriteInteger(const Section, Ident: ShortString; Value: Longint); stdcall;
    function ReadBool(const Section, Ident: ShortString; Default: Boolean): Boolean; stdcall;
    procedure WriteBool(const Section, Ident: ShortString; Value: Boolean); stdcall;
//    function ReadBinaryStream(const Section, Name: ShortString; Value: TStream): Integer; stdcall;
    function ReadDate(const Section, Name: ShortString; Default: TDateTime): TDateTime; stdcall;
    function ReadDateTime(const Section, Name: ShortString; Default: TDateTime): TDateTime; stdcall;
    function ReadFloat(const Section, Name: ShortString; Default: Double): Double; stdcall;
    function ReadTime(const Section, Name: ShortString; Default: TDateTime): TDateTime; stdcall;
//    procedure WriteBinaryStream(const Section, Name: ShortString; Value: TStream); stdcall;
    procedure WriteDate(const Section, Name: ShortString; Value: TDateTime); stdcall;
    procedure WriteDateTime(const Section, Name: ShortString; Value: TDateTime); stdcall;
    procedure WriteFloat(const Section, Name: ShortString; Value: Double); stdcall;
    procedure WriteTime(const Section, Name: ShortString; Value: TDateTime); stdcall;
//    procedure ReadSection(const Section: ShortString; Strings: TStrings); stdcall;
//    procedure ReadSections(Strings: TStrings); stdcall;
//    procedure ReadSectionValues(const Section: ShortString; Strings: TStrings); stdcall;
    procedure EraseSection(const Section: ShortString); stdcall;
    procedure DeleteKey(const Section, Ident: ShortString); stdcall;
    function ValueExists(const Section, Ident: ShortString): Boolean; stdcall;
    function FileName: ShortString; stdcall;
 end;

  IMainProg = interface // WP-2.1.0.18
  ['{F71577A0-2485-4C5B-986B-3199FDC5B370}']
    // renvoit une interface permettant de lire et enregistrer les options d'un plugin dans son propre NameSpace
    // Comprendre: pas besoin de gérer la différenciation des rubriques d'options entre 2 plugins, WP s'en charge
    // ne permet pas à un plugin de lire/ecrire les options d'un autre plugin
    function OptionsWriter: IOptionsWriter; stdcall;
    // procedure permettant de forcer WP à relire sa configuration
    // PluginsInclus = True permet de demander aussi aux plugins de relire leurs options (y compris celui qui en a fait la demande)
    procedure RelireOptions(PluginsInclus: Boolean); stdcall;
    // Force WP à changer de fond
    // cette procédure revient à cliquer sur l'item "Changer maintenant" du menu de WP
    // Exclusions = False: ne tient pas compte des exclusions
    procedure ChangerFond(Exclusions: Boolean); stdcall;
    // Force WP à "rafraichir" le fond (recalculer les calendrier, etc)
    // Si le fond n'a jamais été changé, alors il le sera
    // Exclusions = False: ne tient pas compte des exclusions
    procedure RafraichirFond(Exclusions: Boolean); stdcall;
    // Force WP à changer de fond
    // cette procédure revient à cliquer sur l'item "Selectionner une image" du menu de WP
    // Exclusions = False: ne tient pas compte des exclusions
    procedure ForcerFond(Archive, Image: ShortString; Exclusions: Boolean); stdcall;
  end;

  IDessineur = interface // WP-2.1.0.18
  ['{E301D8A3-F82C-43A5-A27C-6DFA69D688DA}']
    // ces fonctions permettent aux plugins de savoir si un jour est considéré
    // comme jour férié (ou week end) par l'utilisateur (en fonction du paramétrage de WP ET des plugins)
    function IsFerie(Date: TDateTime): Boolean; stdcall;
    function IsWeekEnd(Date: TDateTime): Boolean; stdcall;
  end;

// ********************************
// Interface DEVANT être exportée par un plugin
// Une dll est considérée comme un plugin si les fonctions GetPlugin ou GetPlugin2
// retournent une instance valide de cette interface 
// ********************************

  IPlugin = interface // WP-2.1.0.17
  ['{BE4838F4-97DA-45A9-976D-D0C0A5A237C4}']
    // Nom du plugin = description "courte"
    // *OBLIGATOIRE*
    function GetName: ShortString; stdcall;

    // description "longue" du plugin
    // Peut être sur plusieurs lignes
    function GetDescription: ShortString; stdcall;

    // nom de l'auteur du plugin
    // *OBLIGATOIRE*
    function GetAuthor: ShortString; stdcall;

    // mail/site web/autre de l'auteur
    // *CONSEILLE*
    function GetAuthorContact: ShortString; stdcall;
  end;

// ********************************
// Interface POUVANT être exportée par un plugin
// ********************************

  IConfiguration = interface // WP-2.1.0.18
  ['{E83DA5BB-DE26-4E49-9591-31B227CD6EBC}']
    // doit retourner Vrai si la configuration a changé
    function Configure(Writer: IOptionsWriter): Boolean; stdcall;
    // procedure appelée pour forcer le plugin à relire sa configuration
    // cette procédure est aussi appelée après validation de la fenêtre des options de WP
    procedure RelireOptions(Writer: IOptionsWriter); stdcall;
  end;

  IEvenements = interface // WP-2.1.0.18
  ['{02996AE6-1CBC-43A8-9902-58034AA89F8E}']
    // si l'utilisateur a choisi l'option de changer le fond au démarrage, le fond a déjà été changé
    procedure DemarrageWP; stdcall;
    procedure FermetureWP; stdcall;
    // ces 2 evenements ne sont déclenchés que si aucun plugins ne force l'image
    procedure DebutRechercheFond; stdcall;
    procedure FinRechercheFond; stdcall;
    procedure DebutDessinFond(Dessineur: IDessineur); stdcall;
    procedure FinDessinFond(Dessineur: IDessineur); stdcall;
    procedure AvantApplicationNouveauFond; stdcall;
    procedure ApresApplicationNouveauFond; stdcall;
  end;

implementation

end.

