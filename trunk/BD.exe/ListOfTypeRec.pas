unit ListOfTypeRec;

interface

uses
  Generics.Collections;

type
  TMyObjectList<T: class> = class(TObjectList<T>)
    procedure Move(oldIndex, newIndex: Integer);
  end;

implementation

{ TMyObjectList<T> }

procedure TMyObjectList<T>.Move(oldIndex, newIndex: Integer);
var
  savOwnsObject: Boolean;
  A, B: T;
begin
  savOwnsObject := OwnsObjects;
  try
    OwnsObjects := False; // sinon l'affectation des nouvelles places détruira les objets remplacés

    A := Items[oldIndex];
    B := Items[newIndex];
    Items[oldIndex] := B;
    Items[newIndex] := A;
  finally
    OwnsObjects := savOwnsObject;
  end;
end;

end.
