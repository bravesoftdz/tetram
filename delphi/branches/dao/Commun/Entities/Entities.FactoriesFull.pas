unit Entities.FactoriesFull;

interface

uses
  Entities.FactoriesCommon, Entities.Full, Entities.Common;

type
  TFactoryAlbumFull = class(TFactoryGenericDBEntity<TAlbumFull>)
  protected
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryParaBDFull = class(TFactoryGenericDBEntity<TParaBDFull>)
  protected
    class function EntityClass: TEntityClass; override;
  end;

  TFactorySerieFull = class(TFactoryGenericDBEntity<TSerieFull>)
  protected
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryEditionFull = class(TFactoryGenericDBEntity<TEditionFull>)
  protected
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryEditeurFull = class(TFactoryGenericDBEntity<TEditeurFull>)
  protected
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryCollectionFull = class(TFactoryGenericDBEntity<TCollectionFull>)
  protected
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryAuteurFull = class(TFactoryGenericDBEntity<TAuteurFull>)
  protected
    class function EntityClass: TEntityClass; override;
  end;

  TFactoryUniversFull = class(TFactoryGenericDBEntity<TUniversFull>)
  protected
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
  Result := TEditeurFull;
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
