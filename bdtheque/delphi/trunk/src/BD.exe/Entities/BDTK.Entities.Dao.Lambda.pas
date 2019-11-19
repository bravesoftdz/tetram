unit BDTK.Entities.Dao.Lambda;

interface

uses
  System.Classes, BD.Entities.Dao.Lambda;

type
  // surcharge de TDaoListe pour pouvoir accéder aux elements protected
  // mais dans ce type de classe, ce n'est pas possible de surcharger les méthodes (dont Create/Destroy)
  // donc obligation d'utiliser les sections initialization/finalization
  TDaoListeDB = class(TDaoListe)
  protected
    class procedure DoEnsureDefaultValues;
    class procedure DoEnsureLists;
  end;

implementation

uses
  uib, BD.Entities.Full, BDTK.GUI.DataModules.Main, BD.Entities.Types;

class procedure TDaoListeDB.DoEnsureDefaultValues;
var
  qry: TUIBQuery;
begin
  if FDefaultValuesLoaded then
    Exit;

  qry := dmPrinc.DBConnection.GetQuery;
  try
    qry.SQL.Text := 'select categorie, ref, libelle from listes where defaut = 1';
    qry.Open;
    while not qry.Eof do
    begin
      if CategorieIndex(qry.Fields.AsInteger[0]) in [Low(CategorieIndex) .. High(CategorieIndex)] then
        FDefaultValues[CategorieIndex(qry.Fields.AsInteger[0])] := ROption.Create(qry.Fields.AsInteger[1], qry.Fields.AsString[2]);
      qry.Next;
    end;
    qry.Transaction.Commit;
  finally
    qry.Free;
  end;
  FDefaultValuesLoaded := True;
end;

class procedure TDaoListeDB.DoEnsureLists;
var
  qry: TUIBQuery;
  sl: TStrings;
  prevCategorie: Integer;
begin
  if FListsLoaded then
    Exit;

  qry := dmPrinc.DBConnection.GetQuery;
  try
    qry.SQL.Text := 'select categorie, ref, libelle from listes order by ordre';

    qry.Open;

    sl := nil;
    prevCategorie := -1;
    while not qry.Eof do
    begin
      if (sl = nil) or (prevCategorie <> qry.Fields.AsInteger[0]) then
      begin
        prevCategorie := qry.Fields.AsInteger[0];
        FLists.TryGetValue(CategorieIndex(prevCategorie), sl);
      end;
      if sl <> nil then
        sl.Add(qry.Fields.AsString[1] + '=' + qry.Fields.AsString[2]);
      qry.Next;
    end;
  finally
    qry.Free;
  end;

  FListsLoaded := True;
end;

initialization

TDaoListe.EnsureDefaultValues := TDaoListeDB.DoEnsureDefaultValues;
TDaoListe.EnsureLists := TDaoListeDB.DoEnsureLists;

finalization

TDaoListe.EnsureDefaultValues := nil;
TDaoListe.EnsureLists := nil;

end.
