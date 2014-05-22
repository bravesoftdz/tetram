unit Entities.FactoriesFull;

interface

uses
  ORM.Core.Factories, Entities.Full, ORM.Core.Entities;

type
  TFactoryAlbumFull = class(TFactoryGenericDBEntity<TAlbumFull>)
  public
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryParaBDFull = class(TFactoryGenericDBEntity<TParaBDFull>)
  public
    class function EntityClass: TEntityClass; override;
  end;

  TFactorySerieFull = class(TFactoryGenericDBEntity<TSerieFull>)
  public
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryEditionFull = class(TFactoryGenericDBEntity<TEditionFull>)
  public
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryEditeurFull = class(TFactoryGenericDBEntity<TEditeurFull>)
  public
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryCollectionFull = class(TFactoryGenericDBEntity<TCollectionFull>)
  public
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryAuteurFull = class(TFactoryGenericDBEntity<TAuteurFull>)
  public
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryUniversFull = class(TFactoryGenericDBEntity<TUniversFull>)
  public
    class function EntityClass: TEntityClass; override;
  end;

implementation

{ TFactoryAlbumFull }

class function TFactoryAlbumFull.EntityClass: TEntityClass;
begin
  Result := TAlbumFull;
end;

{ TFactoryParaBDFull }

class function TFactoryParaBDFull.EntityClass: TEntityClass;
begin
  Result := TParaBDFull;
end;

{ TFactorySerieFull }

class function TFactorySerieFull.EntityClass: TEntityClass;
begin
  Result := TSerieFull;
end;

{ TFactoryEditionFull }

class function TFactoryEditionFull.EntityClass: TEntityClass;
begin
  Result := TEditionFull;
end;

{ TFactoryEditeurFull }

class function TFactoryEditeurFull.EntityClass: TEntityClass;
begin
  Result := TEditeurFull;
end;

{ TFactoryCollectionFull }

class function TFactoryCollectionFull.EntityClass: TEntityClass;
begin
  Result := TCollectionFull;
end;

{ TFactoryAuteurFull }

class function TFactoryAuteurFull.EntityClass: TEntityClass;
begin
  Result := TAuteurFull;
end;

{ TFactoryUniversFull }

class function TFactoryUniversFull.EntityClass: TEntityClass;
begin
  Result := TUniversFull;
end;

end.
