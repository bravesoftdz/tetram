unit Entities.DaoLambda;

interface

uses
  System.Classes, Entities.Full;

type
  TDaoListe = class
  private
    class var FDefaultEtat: ROption;
    class var FDefaultReliure: ROption;
    class var FDefaultFormatEdition: ROption;
    class var FDefaultTypeEdition: ROption;
    class var FDefaultOrientation: ROption;
    class var FDefaultSensLecture: ROption;

    class var FDefaultValuesLoaded: Boolean;
    class function GetDefaultEtat: ROption; static;
    class function GetDefaultFormatEdition: ROption; static;
    class function GetDefaultOrientation: ROption; static;
    class function GetDefaultReliure: ROption; static;
    class function GetDefaultSensLecture: ROption; static;
    class function GetDefaultTypeEdition: ROption; static;
  public
    class constructor Create;

    class procedure EnsureDefaultValues;

    class property DefaultEtat: ROption read GetDefaultEtat;
    class property DefaultReliure: ROption read GetDefaultReliure;
    class property DefaultFormatEdition: ROption read GetDefaultFormatEdition;
    class property DefaultTypeEdition: ROption read GetDefaultTypeEdition;
    class property DefaultOrientation: ROption read GetDefaultOrientation;
    class property DefaultSensLecture: ROption read GetDefaultSensLecture;
  end;

implementation

uses
  uib, UdmPrinc, Commun;

{ TDaoListe }

class constructor TDaoListe.Create;
begin
  FDefaultValuesLoaded := False;
end;

class procedure TDaoListe.EnsureDefaultValues;
var
  qry: TUIBQuery;
begin
  if FDefaultValuesLoaded then
    Exit;
  FDefaultEtat := MakeOption(-1, '');
  FDefaultReliure := MakeOption(-1, '');
  FDefaultTypeEdition := MakeOption(-1, '');
  FDefaultOrientation := MakeOption(-1, '');
  FDefaultFormatEdition := MakeOption(-1, '');
  FDefaultSensLecture := MakeOption(-1, '');

  qry := TUIBQuery.Create(nil);
  try
    qry.Transaction := GetTransaction(dmPrinc.UIBDataBase);
    qry.SQL.Text := 'select categorie, ref, libelle from listes where defaut = 1 and categorie in (1,2,3,4,5,8)';
    qry.Open;
    while not qry.Eof do
    begin
      case qry.Fields.AsInteger[0] of
        1:
          FDefaultEtat := MakeOption(qry.Fields.AsInteger[1], qry.Fields.AsString[2]);
        2:
          FDefaultReliure := MakeOption(qry.Fields.AsInteger[1], qry.Fields.AsString[2]);
        3:
          FDefaultTypeEdition := MakeOption(qry.Fields.AsInteger[1], qry.Fields.AsString[2]);
        4:
          FDefaultOrientation := MakeOption(qry.Fields.AsInteger[1], qry.Fields.AsString[2]);
        5:
          FDefaultFormatEdition := MakeOption(qry.Fields.AsInteger[1], qry.Fields.AsString[2]);
        8:
          FDefaultSensLecture := MakeOption(qry.Fields.AsInteger[1], qry.Fields.AsString[2]);
      end;
      qry.Next;
    end;
    qry.Transaction.Commit;
  finally
    qry.Transaction.Free;
    qry.Free;
  end;
  FDefaultValuesLoaded := True;
end;

class function TDaoListe.GetDefaultEtat: ROption;
begin
  EnsureDefaultValues;
  Result := FDefaultEtat;
end;

class function TDaoListe.GetDefaultFormatEdition: ROption;
begin
  EnsureDefaultValues;
  Result := FDefaultFormatEdition;
end;

class function TDaoListe.GetDefaultOrientation: ROption;
begin
  EnsureDefaultValues;
  Result := FDefaultOrientation;
end;

class function TDaoListe.GetDefaultReliure: ROption;
begin
  EnsureDefaultValues;
  Result := FDefaultReliure;
end;

class function TDaoListe.GetDefaultSensLecture: ROption;
begin
  EnsureDefaultValues;
  Result := FDefaultSensLecture;
end;

class function TDaoListe.GetDefaultTypeEdition: ROption;
begin
  EnsureDefaultValues;
  Result := FDefaultTypeEdition;
end;

end.
