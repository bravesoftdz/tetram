unit UInterfaceJoursFeries;

interface

type
  IJoursFeries = interface // WP-2.1.0.4
  ['{42014044-D04D-4A4F-B88F-C078176440A1}']
    // doit renvoyer True si le jour pass� en param�tre est � consid�r� comme f�rie
    function IsFerie(Jour: TDateTime): Boolean; stdcall;
  end;

implementation

end.
 