unit BD.Entities.Factory.Lite;

interface

uses
  BD.Entities.Factory.Common, BD.Entities.Lite, BD.Entities.Common;

type
  TFactoryAlbumLite = class(TFactoryGenericDBEntity<TAlbumLite>)
  protected
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryParaBDLite = class(TFactoryGenericDBEntity<TParaBDLite>)
  protected
    class function EntityClass: TEntityClass; override;
  end;

  TFactorySerieLite = class(TFactoryGenericDBEntity<TSerieLite>)
  protected
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryEditionLite = class(TFactoryGenericDBEntity<TEditionLite>)
  protected
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryEditeurLite = class(TFactoryGenericDBEntity<TEditeurLite>)
  protected
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryCollectionLite = class(TFactoryGenericDBEntity<TCollectionLite>)
  protected
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryPersonnageLite = class(TFactoryGenericDBEntity<TPersonnageLite>)
  protected
    class function EntityClass: TEntityClass; override;
  end;

//  TFactoryAuteurLite = class(TFactoryGenericDBEntity<TAuteurLite>)
//  protected
//    class function EntityClass: TEntityClass; override;
//  end;

  TFactoryAuteurSerieLite = class(TFactoryGenericDBEntity<TAuteurSerieLite>)
  protected
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryAuteurAlbumLite = class(TFactoryGenericDBEntity<TAuteurAlbumLite>)
  protected
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryAuteurParaBDLite = class(TFactoryGenericDBEntity<TAuteurParaBDLite>)
  protected
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryUniversLite = class(TFactoryGenericDBEntity<TUniversLite>)
  protected
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryPhotoLite = class(TFactoryGenericDBEntity<TPhotoLite>)
  protected
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryCouvertureLite = class(TFactoryGenericDBEntity<TCouvertureLite>)
  protected
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryGenreLite = class(TFactoryGenericDBEntity<TGenreLite>)
  protected
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryConversionLite = class(TFactoryGenericDBEntity<TConversionLite>)
  protected
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

{ TFactoryAuteurLite }

//class function TFactoryAuteurLite.EntityClass: TEntityClass;
//begin
//  Result := TAuteurLite;
//end;

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

{ TFactoryAuteurParaBDLite }

class function TFactoryAuteurParaBDLite.EntityClass: TEntityClass;
begin
  Result := TAuteurParaBDLite;
end;

{ TFactoryAuteurAlbumLite }

class function TFactoryAuteurAlbumLite.EntityClass: TEntityClass;
begin
  Result := TAuteurAlbumLite;
end;

{ TFactoryAuteurSerieLite }

class function TFactoryAuteurSerieLite.EntityClass: TEntityClass;
begin
  Result := TAuteurSerieLite;
end;

end.
