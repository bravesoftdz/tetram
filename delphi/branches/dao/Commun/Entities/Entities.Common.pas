unit Entities.Common;

interface

uses
  System.Classes, Commun;

type
  TEntityClass = class of TEntity;
  TDBEntityClass = class of TDBEntity;

{$RTTI EXPLICIT METHODS([vcPublic, vcProtected])}

  TEntity = class(TPersistent)
  protected
    constructor Create; virtual;
  public
    procedure BeforeDestruction; override;
    procedure Clear; virtual;
    procedure AfterConstruction; override;
  end;

  TDBEntity = class(TEntity)
  private
    FID: RGUIDEx;
  public
    function GetID: RGUIDEx; inline;
    procedure SetID(const Value: RGUIDEx); inline;
    procedure Assign(Source: TPersistent); override;
    procedure Clear; override;
  published
    property ID: RGUIDEx read GetID write SetID;
  end;

implementation

{ TEntity }

procedure TEntity.AfterConstruction;
begin
  inherited;
  Clear;
end;

procedure TEntity.BeforeDestruction;
begin
  inherited;
  Clear;
end;

procedure TEntity.Clear;
begin
  // nettoyage de toutes les listes et autres
  // et reset aux valeurs par défaut
end;

constructor TEntity.Create;
begin

end;

{ TDBEntity }

procedure TDBEntity.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TDBEntity then
    Self.ID := TDBEntity(Source).ID;
end;

procedure TDBEntity.Clear;
begin
  inherited;
  FID := GUID_NULL;
end;

function TDBEntity.GetID: RGUIDEx;
begin
  Result := FID;
end;

procedure TDBEntity.SetID(const Value: RGUIDEx);
begin
  FID := Value;
end;

end.
