unit Entities.DaoLite;

interface

uses
  Entities.DaoCommon, Entities.Lite, Entities.Common, Entities.FactoriesCommon;

type
  TDaoLiteFactory<T: TBaseLite> = class abstract(TDaoDBEntity)
  end;

  TDaoAlbumLite = class(TDaoLiteFactory<TAlbumLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  end;

  TDaoParaBDLite = class(TDaoLiteFactory<TParaBDLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  end;

  TDaoSerieLite = class(TDaoLiteFactory<TSerieLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  end;

  TDaoEditionLite = class(TDaoLiteFactory<TEditionLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  end;

  TDaoEditeurLite = class(TDaoLiteFactory<TEditeurLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  end;

  TDaoCollectionLite = class(TDaoLiteFactory<TCollectionLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  end;

  TDaoPersonnageLite = class(TDaoLiteFactory<TPersonnageLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  end;

  TDaoAuteurLite = class(TDaoLiteFactory<TAuteurLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  end;

  TDaoUniversLite = class(TDaoLiteFactory<TUniversLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  end;

  TDaoCouvertureLite = class(TDaoLiteFactory<TCouvertureLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  end;

  TDaoGenreLite = class(TDaoLiteFactory<TGenreLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  end;

  TDaoConversionLite = class(TDaoLiteFactory<TConversionLite>)
  protected
    class function FactoryClass: TFactoryClass; override;
  end;

implementation

uses
  Entities.FactoriesLite;

{ TDaoAlbumLite }

class function TDaoAlbumLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryAlbumLite;
end;

{ TDaoParaBDLite }

class function TDaoParaBDLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryParaBDLite;
end;

{ TDaoSerieLite }

class function TDaoSerieLite.FactoryClass: TFactoryClass;
begin
  Result := TFactorySerieLite;
end;

{ TDaoEditionLite }

class function TDaoEditionLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryEditeurLite;
end;

{ TDaoEditeurLite }

class function TDaoEditeurLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryEditeurLite;
end;

{ TDaoCollectionLite }

class function TDaoCollectionLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryCollectionLite;
end;

{ TDaoPersonnageLite }

class function TDaoPersonnageLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryPersonnageLite;
end;

{ TDaoAuteurLite }

class function TDaoAuteurLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryAuteurLite;
end;

{ TDaoUniversLite }

class function TDaoUniversLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryUniversLite;
end;

{ TDaoCouvertureLite }

class function TDaoCouvertureLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryCouvertureLite;
end;

{ TDaoGenreLite }

class function TDaoGenreLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryGenreLite;
end;

{ TDaoConversionLite }

class function TDaoConversionLite.FactoryClass: TFactoryClass;
begin
  Result := TFactoryConversionLite;
end;

end.
