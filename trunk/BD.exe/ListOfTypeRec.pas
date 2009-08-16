unit ListOfTypeRec;

interface

uses
  Generics.Collections, Generics.Defaults;

type
  TMyObjectList<T: class> = class(TObjectList<T>)
    constructor Create(AOwnsObjects: Boolean = True);
    procedure Move(oldIndex, newIndex: Integer);
  end;

implementation

{ TMyObjectList<T> }

constructor TMyObjectList<T>.Create(AOwnsObjects: Boolean);
begin
  inherited Create(TComparer<T>.Construct(
      function(const Left, Right: T): Integer
      begin
        if Left = Right then
          Result := 0
        else
          Result := -1;
      end
    ), AOwnsObjects);
end;

procedure TMyObjectList<T>.Move(oldIndex, newIndex: Integer);
var
  savOwnsObject: Boolean;
  A: T;
begin
  savOwnsObject := OwnsObjects;
  try
    OwnsObjects := False; // sinon l'affectation des nouvelles places détruira les objets remplacés

    A := Items[oldIndex];
    Items[oldIndex] := Items[newIndex];
    Items[newIndex] := A;
  finally
    OwnsObjects := savOwnsObject;
  end;
end;

end.
