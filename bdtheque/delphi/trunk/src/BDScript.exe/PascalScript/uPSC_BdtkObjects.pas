unit uPSC_BdtkObjects;

interface

uses
  SysUtils, Classes, uPSCompiler;

{ compile-time registration functions }
procedure SIRegister_TStringList(CL: TPSPascalCompiler);
procedure SIRegister_TObjectList(CL: TPSPascalCompiler);
procedure SIRegister_TObjectListOfUnivers(CL: TPSPascalCompiler);
procedure SIRegister_TObjectListOfAuteur(CL: TPSPascalCompiler);
procedure SIRegister_TObjectListOfEditionFull(CL: TPSPascalCompiler);

procedure SIRegister_TUnivers(CL: TPSPascalCompiler);
procedure SIRegister_TAuteur(CL: TPSPascalCompiler);
procedure SIRegister_TAlbumFull(CL: TPSPascalCompiler);
procedure SIRegister_TEditionFull(CL: TPSPascalCompiler);
procedure SIRegister_TSerieFull(CL: TPSPascalCompiler);
procedure SIRegister_TEditeurFull(CL: TPSPascalCompiler);

procedure SIRegister_TScriptChoix(CL: TPSPascalCompiler);

procedure SIRegister_BdtkObjects(CL: TPSPascalCompiler);

implementation

uses
  Windows, Dialogs, Entities.Lite, Commun, CommonConst, UdmPrinc, DateUtils, Entities.Full;

(* === compile-time registration functions === *)

procedure SIRegister_TStringList(CL: TPSPascalCompiler);
begin
  with CL.FindClass('TStringList') do
  begin
    RegisterMethod('procedure Split(const Chaine: string; const Sep: string)');
  end;
end;

procedure SIRegister_TObjectList(CL: TPSPascalCompiler);
begin
  with CL.AddClassN(CL.FindClass('TObject' { TObjectList<> } ), 'TObjectList') do
  begin
    RegisterMethod('procedure Delete(Index: Integer)');
    RegisterProperty('Count', 'Integer', iptR);
  end;
end;

procedure SIRegister_TObjectListOfUnivers(CL: TPSPascalCompiler);
begin
  with CL.AddClassN(CL.FindClass('TObjectList' { TObjectList<> } ), 'TObjectListOfUnivers') do
  begin
    RegisterMethod('function Add(AObject: TUnivers): Integer');
    RegisterMethod('procedure Insert(Index: Integer; AObject: TUnivers)');
    RegisterProperty('Items', 'TUnivers Integer', iptRW);
    SetDefaultPropery('Items');
  end;
end;

procedure SIRegister_TObjectListOfAuteur(CL: TPSPascalCompiler);
begin
  with CL.AddClassN(CL.FindClass('TObjectList' { TObjectList<> } ), 'TObjectListOfAuteurSerie') do
  begin
    RegisterMethod('function Add(AObject: TAuteur): Integer');
    RegisterMethod('procedure Insert(Index: Integer; AObject: TAuteur)');
    RegisterProperty('Items', 'TAuteur Integer', iptRW);
    SetDefaultPropery('Items');
  end;
  with CL.AddClassN(CL.FindClass('TObjectList' { TObjectList<> } ), 'TObjectListOfAuteurAlbum') do
  begin
    RegisterMethod('function Add(AObject: TAuteur): Integer');
    RegisterMethod('procedure Insert(Index: Integer; AObject: TAuteur)');
    RegisterProperty('Items', 'TAuteur Integer', iptRW);
    SetDefaultPropery('Items');
  end;
end;

procedure SIRegister_TObjectListOfEditionFull(CL: TPSPascalCompiler);
begin
  with CL.AddClassN(CL.FindClass('TObjectList' { TObjectList<> } ), 'TObjectListOfEditionFull') do
  begin
    RegisterMethod('function Add(AObject: TEditionFull): Integer');
    RegisterMethod('procedure Insert(Index: Integer; AObject: TEditionFull)');
    RegisterProperty('Items', 'TEditionFull Integer', iptRW);
    SetDefaultPropery('Items');
  end;
end;

procedure SIRegister_TAlbumFull(CL: TPSPascalCompiler);
begin
  with CL.AddClassN(CL.FindClass('TObject' { TObjetFull } ), 'TAlbumFull') do
  begin
    RegisterProperty('DefaultSearch', 'string', iptR);

    RegisterProperty('Titre', 'string', iptRW);
    RegisterProperty('Serie', 'TSerieFull', iptR);
    RegisterProperty('MoisParution', 'Integer', iptRW);
    RegisterProperty('AnneeParution', 'Integer', iptRW);
    RegisterProperty('Tome', 'Integer', iptRW);
    RegisterProperty('TomeDebut', 'Integer', iptRW);
    RegisterProperty('TomeFin', 'Integer', iptRW);
    RegisterProperty('HorsSerie', 'Boolean', iptRW);
    RegisterProperty('Integrale', 'Boolean', iptRW);
    RegisterProperty('Scenaristes', 'TObjectListOfAuteurAlbum' { TObjectList<TAuteur> } , iptR);
    RegisterProperty('Dessinateurs', 'TObjectListOfAuteurAlbum' { TObjectList<TAuteur> } , iptR);
    RegisterProperty('Coloristes', 'TObjectListOfAuteurAlbum' { TObjectList<TAuteur> } , iptR);
    RegisterProperty('Sujet', 'LongString', iptRW);
    RegisterProperty('Notes', 'LongString', iptRW);
    RegisterProperty('Edition', 'TEditionFull', iptR);
    RegisterProperty('Univers', 'TObjectListOfUnivers' { TObjectList<TUnivers> } , iptR);

    RegisterMethod('procedure Clear;');
    RegisterMethod('procedure Import;');
  end;
end;

procedure SIRegister_TSerieFull(CL: TPSPascalCompiler);
begin
  with CL.AddClassN(CL.FindClass('TObject' { TObjetFull } ), 'TSerieFull') do
  begin
    RegisterProperty('Titre', 'string', iptRW);
    RegisterProperty('Terminee', 'Integer', iptRW);
    RegisterProperty('Genres', 'TStringList', iptR);
    RegisterProperty('Sujet', 'LongString', iptRW);
    RegisterProperty('Notes', 'LongString', iptRW);
    RegisterProperty('Editeur', 'TEditeurFull', iptR);
    RegisterProperty('Collection', 'string', iptRW);
    RegisterProperty('SiteWeb', 'string', iptRW);
    RegisterProperty('NbAlbums', 'Integer', iptRW);
    RegisterProperty('Scenaristes', 'TObjectListOfAuteurSerie' { TObjectList<TAuteur> } , iptR);
    RegisterProperty('Dessinateurs', 'TObjectListOfAuteurSerie' { TObjectList<TAuteur> } , iptR);
    RegisterProperty('Coloristes', 'TObjectListOfAuteurSerie' { TObjectList<TAuteur> } , iptR);
    RegisterProperty('Univers', 'TObjectListOfUnivers' { TObjectList<TUnivers> } , iptR);
  end;
end;

procedure SIRegister_TEditionFull(CL: TPSPascalCompiler);
begin
  with CL.AddClassN(CL.FindClass('TObject' { TObjetFull } ), 'TEditionFull') do
  begin
    RegisterMethod('constructor Create');

    RegisterProperty('Editeur', 'TEditeurFull', iptR);
    RegisterProperty('Collection', 'string', iptRW);
    RegisterProperty('TypeEdition', 'Integer' { ROption } , iptRW);
    RegisterProperty('AnneeEdition', 'Integer', iptRW);
    RegisterProperty('Etat', 'Integer' { ROption } , iptRW);
    RegisterProperty('Reliure', 'Integer' { ROption } , iptRW);
    RegisterProperty('NombreDePages', 'Integer', iptRW);
    RegisterProperty('FormatEdition', 'Integer' { ROption } , iptRW);
    RegisterProperty('Orientation', 'Integer' { ROption } , iptRW);
    RegisterProperty('AnneeCote', 'Integer', iptRW);
    RegisterProperty('SensLecture', 'Integer' { ROption } , iptRW);
    RegisterProperty('Prix', 'Currency', iptRW);
    RegisterProperty('PrixCote', 'Currency', iptRW);
    RegisterProperty('Couleur', 'Boolean', iptRW);
    RegisterProperty('VO', 'Boolean', iptRW);
    // RegisterProperty('Dedicace', 'Boolean', iptRW);
    // RegisterProperty('Stock', 'Boolean', iptRW);
    // RegisterProperty('Prete', 'Boolean', iptRW);
    // RegisterProperty('Offert', 'Boolean', iptRW);
    RegisterProperty('Gratuit', 'Boolean', iptRW);
    RegisterProperty('ISBN', 'string', iptRW);
    // RegisterProperty('DateAchat', 'TDateTime', iptRW);
    // RegisterProperty('Notes', 'LongString', iptRW);
    // RegisterProperty('NumeroPerso', 'string', iptRW);
    // RegisterProperty('Couvertures', 'TMyObjectList<TCouverture>', iptR);
    RegisterMethod('function AddImageFromURL(const URL: string; TypeImage: Integer): Integer;');
  end;
end;

procedure SIRegister_TEditeurFull(CL: TPSPascalCompiler);
begin
  with CL.AddClassN(CL.FindClass('TObject' { TObjetFull } ), 'TEditeurFull') do
  begin
    RegisterProperty('NomEditeur', 'string', iptRW);
    RegisterProperty('SiteWeb', 'string', iptRW);
  end;
end;

procedure SIRegister_TUnivers(CL: TPSPascalCompiler);
begin
  with CL.AddClassN(CL.FindClass('TObject' { TBaseRec } ), 'TUnivers') do
  begin
    RegisterProperty('NomUnivers', 'string', iptRW);
  end;
end;

procedure SIRegister_TAuteur(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TMetierAuteur', '(maScenariste, maDessinateur, maColoriste)');
  with CL.AddClassN(CL.FindClass('TObject' { TBaseRec } ), 'TAuteur') do
  begin
    RegisterProperty('NomAuteur', 'string', iptRW);
    RegisterProperty('Metier', 'TMetierAuteur', iptRW);
  end;

  CL.AddClassN(CL.FindClass('TAuteur'), 'TAuteurSerie');
  CL.AddClassN(CL.FindClass('TAuteur'), 'TAuteurAlbum');
end;

procedure SIRegister_TScriptChoix(CL: TPSPascalCompiler);
begin
  with CL.AddClassN(CL.FindClass('TObject'), 'TScriptChoix') do
  begin
    RegisterMethod('constructor Create');

    RegisterMethod('function Show: string;');
    RegisterMethod('procedure ResetList;');
    RegisterMethod('procedure AjoutChoix(const Categorie, Libelle, Commentaire, Data: string);');
    RegisterMethod('procedure AjoutChoixWithThumb(const Categorie, Libelle, Commentaire, Data, URL: string);');
    RegisterMethod('function CategorieCount: Integer;');
    RegisterMethod('function ChoixCount: Integer;');
    RegisterMethod('function CategorieChoixCount(const Name: string): Integer;');
    RegisterProperty('Titre', 'string', iptRW);
  end;
end;

procedure SIRegister_BdtkObjects(CL: TPSPascalCompiler);
begin
  CL.AddTypeCopyN('LongString', 'string');

  SIRegister_TStringList(CL);
  SIRegister_TObjectList(CL);

  // les univers sont exposés en chaine
  SIRegister_TUnivers(CL);
  // la liste des univers est exposée en stringlist
  SIRegister_TObjectListOfUnivers(CL);
  SIRegister_TAuteur(CL);
  SIRegister_TObjectListOfAuteur(CL);
  SIRegister_TEditeurFull(CL);
  SIRegister_TSerieFull(CL);
  SIRegister_TEditionFull(CL);
  SIRegister_TAlbumFull(CL);

  SIRegister_TScriptChoix(CL);
end;

end.
