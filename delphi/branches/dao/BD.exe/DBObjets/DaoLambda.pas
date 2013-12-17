unit DaoLambda;

interface

uses
  EntitiesFull;

type
  TDaoListe = class
  private
    class var FDefaultEtat: ROption;
    class var FDefaultReliure: ROption;
    class var FDefaultFormatEdition: ROption;
    class var FDefaultTypeEdition: ROption;
    class var FDefaultOrientation: ROption;
    class var FDefaultSensLecture: ROption;

    class procedure GetDefaultValues;
  public
    class constructor Create;

    class property DefaultEtat: ROption read FDefaultEtat;
    class property DefaultReliure: ROption read FDefaultReliure;
    class property DefaultFormatEdition: ROption read FDefaultFormatEdition;
    class property DefaultTypeEdition: ROption read FDefaultTypeEdition;
    class property DefaultOrientation: ROption read FDefaultOrientation;
    class property DefaultSensLecture: ROption read FDefaultSensLecture;
  end;

implementation

uses
  uib, UdmPrinc, Commun;

{ TDaoListe }

class constructor TDaoListe.Create;
begin
  GetDefaultValues;
end;

class procedure TDaoListe.GetDefaultValues;
begin
  FDefaultEtat := MakeOption(-1, '');
  FDefaultReliure := MakeOption(-1, '');
  FDefaultTypeEdition := MakeOption(-1, '');
  FDefaultOrientation := MakeOption(-1, '');
  FDefaultFormatEdition := MakeOption(-1, '');
  FDefaultSensLecture := MakeOption(-1, '');

  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(dmPrinc.UIBDataBase);
      SQL.Text := 'select categorie, ref, libelle from listes where defaut = 1 and categorie in (1,2,3,4,5,8)';
      Open;
      while not Eof do
      begin
        case Fields.AsInteger[0] of
          1:
            FDefaultEtat := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
          2:
            FDefaultReliure := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
          3:
            FDefaultTypeEdition := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
          4:
            FDefaultOrientation := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
          5:
            FDefaultFormatEdition := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
          8:
            FDefaultSensLecture := MakeOption(Fields.AsInteger[1], Fields.AsString[2]);
        end;
        Next;
      end;
      Transaction.Commit;
    finally
      Transaction.Free;
      Free;
    end;
end;

end.
