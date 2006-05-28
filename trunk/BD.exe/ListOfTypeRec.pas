unit ListOfTypeRec;

interface

uses TypeRec, Contnrs;

type
  TListOfTBasePointer = class(TObjectList)
  end;

  TListOfTEmprunt = class(TListOfTBasePointer)
  protected
    function GetItem(Index: Integer): TEmprunt;
  public
    function Add(AObject: TEmprunt): Integer;
    procedure Insert(Index: Integer; AObject: TEmprunt);
    property Items[Index: Integer]: TEmprunt read GetItem; default;
  end;

  TListOfTAuteur = class(TListOfTBasePointer)
  protected
    function GetItem(Index: Integer): TAuteur;
  public
    function Add(AObject: TAuteur): Integer;
    procedure Insert(Index: Integer; AObject: TAuteur);
    property Items[Index: Integer]: TAuteur read GetItem; default;
  end;

  TListOfTAlbum = class(TListOfTBasePointer)
  protected
    function GetItem(Index: Integer): TAlbum;
  public
    function Add(AObject: TAlbum): Integer;
    procedure Insert(Index: Integer; AObject: TAlbum);
    property Items[Index: Integer]: TAlbum read GetItem; default;
  end;

  TListOfTParaBD = class(TListOfTBasePointer)
  protected
    function GetItem(Index: Integer): TParaBD;
  public
    function Add(AObject: TParaBD): Integer;
    procedure Insert(Index: Integer; AObject: TParaBD);
    property Items[Index: Integer]: TParaBD read GetItem; default;
  end;

  TListOfTCouverture = class(TListOfTBasePointer)
  protected
    function GetItem(Index: Integer): TCouverture;
  public
    function Add(AObject: TCouverture): Integer;
    procedure Insert(Index: Integer; AObject: TCouverture);
    property Items[Index: Integer]: TCouverture read GetItem; default;
  end;

  TListOfTGenre = class(TListOfTBasePointer)
  protected
    function GetItem(Index: Integer): TGenre;
  public
    function Add(AObject: TGenre): Integer;
    procedure Insert(Index: Integer; AObject: TGenre);
    property Items[Index: Integer]: TGenre read GetItem; default;
  end;

  TListOfTEmprunteur = class(TListOfTBasePointer)
  protected
    function GetItem(Index: Integer): TEmprunteur;
  public
    function Add(AObject: TEmprunteur): Integer;
    procedure Insert(Index: Integer; AObject: TEmprunteur);
    property Items[Index: Integer]: TEmprunteur read GetItem; default;
  end;

implementation

{ TListOfTEmprunt }

function TListOfTEmprunt.Add(AObject: TEmprunt): Integer;
begin
  Result := inherited Add(AObject);
end;

function TListOfTEmprunt.GetItem(Index: Integer): TEmprunt;
begin
  Result := TEmprunt(inherited GetItem(Index));
end;

procedure TListOfTEmprunt.Insert(Index: Integer; AObject: TEmprunt);
begin
  inherited Insert(Index, AObject);
end;

{ TListOfTAuteur }

function TListOfTAuteur.Add(AObject: TAuteur): Integer;
begin
  Result := inherited Add(AObject);
end;

function TListOfTAuteur.GetItem(Index: Integer): TAuteur;
begin
  Result := TAuteur(inherited GetItem(Index));
end;

procedure TListOfTAuteur.Insert(Index: Integer; AObject: TAuteur);
begin
  inherited Insert(Index, AObject);
end;

{ TListOfTAlbum }

function TListOfTAlbum.Add(AObject: TAlbum): Integer;
begin
  Result := inherited Add(AObject);
end;

function TListOfTAlbum.GetItem(Index: Integer): TAlbum;
begin
  Result := TAlbum(inherited GetItem(Index));
end;

procedure TListOfTAlbum.Insert(Index: Integer; AObject: TAlbum);
begin
  inherited Insert(Index, AObject);
end;

{ TListOfTParaBD }

function TListOfTParaBD.Add(AObject: TParaBD): Integer;
begin
  Result := inherited Add(AObject);
end;

function TListOfTParaBD.GetItem(Index: Integer): TParaBD;
begin
  Result := TParaBD(inherited GetItem(Index));
end;

procedure TListOfTParaBD.Insert(Index: Integer; AObject: TParaBD);
begin
  inherited Insert(Index, AObject);
end;

{ TListOfTCouverture }

function TListOfTCouverture.Add(AObject: TCouverture): Integer;
begin
  Result := inherited Add(AObject);
end;

function TListOfTCouverture.GetItem(Index: Integer): TCouverture;
begin
  Result := TCouverture(inherited GetItem(Index));
end;

procedure TListOfTCouverture.Insert(Index: Integer; AObject: TCouverture);
begin
  inherited Insert(Index, AObject);
end;

{ TListOfTGenre }

function TListOfTGenre.Add(AObject: TGenre): Integer;
begin
  Result := inherited Add(AObject);
end;

function TListOfTGenre.GetItem(Index: Integer): TGenre;
begin
  Result := TGenre(inherited GetItem(Index));
end;

procedure TListOfTGenre.Insert(Index: Integer; AObject: TGenre);
begin
  inherited Insert(Index, AObject);
end;

{ TListOfTEmprunteur }

function TListOfTEmprunteur.Add(AObject: TEmprunteur): Integer;
begin
  Result := inherited Add(AObject);
end;

function TListOfTEmprunteur.GetItem(Index: Integer): TEmprunteur;
begin
  Result := TEmprunteur(inherited GetItem(Index));
end;

procedure TListOfTEmprunteur.Insert(Index: Integer; AObject: TEmprunteur);
begin
  inherited Insert(Index, AObject);
end;

end.

