unit Entities.FactoriesLite;

interface

uses
  ORM.Core.Factories, Entities.Lite, ORM.Core.Entities;

type
  TFactoryAlbumLite = class(TFactoryGenericDBEntity<TAlbumLite>)
  public
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryParaBDLite = class(TFactoryGenericDBEntity<TParaBDLite>)
  public
    class function EntityClass: TEntityClass; override;
  end;

  TFactorySerieLite = class(TFactoryGenericDBEntity<TSerieLite>)
  public
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryEditionLite = class(TFactoryGenericDBEntity<TEditionLite>)
  public
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryEditeurLite = class(TFactoryGenericDBEntity<TEditeurLite>)
  public
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryCollectionLite = class(TFactoryGenericDBEntity<TCollectionLite>)
  public
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryPersonnageLite = class(TFactoryGenericDBEntity<TPersonnageLite>)
  public
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryAuteurSerieLite = class(TFactoryGenericDBEntity<TAuteurSerieLite>)
  public
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryAuteurAlbumLite = class(TFactoryGenericDBEntity<TAuteurAlbumLite>)
  public
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryAuteurParaBDLite = class(TFactoryGenericDBEntity<TAuteurParaBDLite>)
  public
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryUniversLite = class(TFactoryGenericDBEntity<TUniversLite>)
  public
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryPhotoLite = class(TFactoryGenericDBEntity<TPhotoLite>)
  public
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryCouvertureLite = class(TFactoryGenericDBEntity<TCouvertureLite>)
  public
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryGenreLite = class(TFactoryGenericDBEntity<TGenreLite>)
  public
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryConversionLite = class(TFactoryGenericDBEntity<TConversionLite>)
  public
    class function EntityClass: TEntityClass; override;
  end;

implementation

{ TFactoryAlbumLite }

class function TFactoryAlbumLite.EntityClass: TEntityClass;
begin
  Result := TAlbumLite;
end;

{ TFactoryParaBDLite }

class function TFactoryParaBDLite.EntityClass: TEntityClass;
begin
  Result := TParaBDLite;
end;

{ TFactorySerieLite }

class function TFactorySerieLite.EntityClass: TEntityClass;
begin
  Result := TSerieLite;
end;

{ TFactoryEditionLite }

class function TFactoryEditionLite.EntityClass: TEntityClass;
begin
  Result := TEditionLite;
end;

{ TFactoryEditeurLite }

class function TFactoryEditeurLite.EntityClass: TEntityClass;
begin
  Result := TEditeurLite;
end;

{ TFactoryCollectionLite }

class function TFactoryCollectionLite.EntityClass: TEntityClass;
begin
  Result := TCollectionLite;
end;

{ TFactoryPersonnageLite }

class function TFactoryPersonnageLite.EntityClass: TEntityClass;
begin
  Result := TPersonnageLite;
end;

{ TFactoryAuteurSerieLite }

class function TFactoryAuteurSerieLite.EntityClass: TEntityClass;
begin
  Result := TAuteurSerieLite;
end;

{ TFactoryAuteurAlbumLite }

class function TFactoryAuteurAlbumLite.EntityClass: TEntityClass;
begin
  Result := TAuteurAlbumLite;
end;

{ TFactoryAuteurParaBDLite }

class function TFactoryAuteurParaBDLite.EntityClass: TEntityClass;
begin
  Result := TAuteurParaBDLite;
end;

{ TFactoryUniversLite }

class function TFactoryUniversLite.EntityClass: TEntityClass;
begin
  Result := TUniversLite;
end;

{ TFactoryCouvertureLite }

class function TFactoryCouvertureLite.EntityClass: TEntityClass;
begin
  Result := TCouvertureLite;
end;

{ TFactoryGenreLite }

class function TFactoryGenreLite.EntityClass: TEntityClass;
begin
  Result := TGenreLite;
end;

{ TFactoryConversionLite }

class function TFactoryConversionLite.EntityClass: TEntityClass;
begin
  Result := TConversionLite;
end;

{ TFactoryPhotoLite }

class function TFactoryPhotoLite.EntityClass: TEntityClass;
begin
  Result := TPhotoLite;
end;

end.
