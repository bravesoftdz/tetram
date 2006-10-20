unit CommonList;

interface

{$WARN UNIT_PLATFORM OFF}

uses SysUtils, Windows, Classes, TypeRec, DB, Graphics, JvUIB;

type
  TListAlbum = class(TList)
  protected
    function GetItem(Index: Integer): TAlbum;
    procedure SetItem(Index: Integer; Item: TAlbum);
  public
    property Items[Index: Integer]: TAlbum read GetItem write SetItem; default;
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

function TListAlbum.GetItem(Index: Integer): TAlbum;
begin
  Result := TAlbum(inherited Get(Index));
end;

procedure TListAlbum.SetItem(Index: Integer; Item: TAlbum);
begin
  inherited Put(Index, Item);
end;

end.
