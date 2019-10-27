unit UImportXML;

interface

uses
  Xml.XMLDoc;

type
  TImportXML = class
    procedure ParseFichier(const FichierXML: string);
  end;

implementation

{ TImportXML }

procedure TImportXML.ParseFichier(const FichierXML: string);
var
  Document: TXMLDocument;
begin
  Document := TXMLDocument.Create(nil);
  try
    Document.LoadFromFile(FichierXML);

  finally
    Document.Free;
  end;
end;

end.
