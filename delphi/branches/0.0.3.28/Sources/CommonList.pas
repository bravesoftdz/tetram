unit CommonList;

interface

{$WARN UNIT_PLATFORM OFF}

uses SysUtils, Windows, Classes, TypeRec, DB, Graphics, JvUIB;

type
  TListAlbum = class(TList)
  protected
    function Get(Index: Integer): TAlbum;
    procedure Put(Index: Integer; Item: TAlbum);
  public
    property Items[Index: Integer]: TAlbum read Get write Put; default;
  end;

  TListAlbumAdd = class(TListAlbum)
  public
    procedure Clear; override;
    function AddQ(Q: TJvUIBQuery): Integer;
  end;

implementation

uses FileCtrl;

procedure TListAlbumAdd.Clear;
begin
  TAlbum.VideListe(Self, False);
  inherited;
end;

function TListAlbumAdd.AddQ(Q: TJvUIBQuery): Integer;
begin
  Result := inherited Add(TAlbum.Make(Q));
end;

function TListAlbum.Get(Index: Integer): TAlbum;
begin
  Result := TAlbum(inherited Get(Index));
end;

procedure TListAlbum.Put(Index: Integer; Item: TAlbum);
begin
  inherited Put(Index, Item);
end;

end.
