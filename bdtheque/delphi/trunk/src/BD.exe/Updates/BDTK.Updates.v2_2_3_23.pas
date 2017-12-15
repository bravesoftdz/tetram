unit BDTK.Updates.v2_2_3_23;

interface

uses
  SysUtils, UIB, UIBLib, BDTK.Updates;

implementation

uses
  dwsJSON, BD.Scripts, BD.Common, System.IOUtils;

procedure MAJ2_2_3_23(Query: TUIBScript);

  procedure ExtractScriptsOptions;
  var
    oo, os: TdwsJSONObject;
    ov: TdwsJSONValue;
    qry: TUIBQuery;
    ScriptName, prevScript, Libelle, ChooseValue: string;
  begin
    os := nil;
    prevScript := '';

    oo := ReadScriptsOptions;
    try
      qry := TUIBQuery.Create(nil);
      try
        qry.Transaction := Query.Transaction;
        qry.SQL.Text := 'select script, nom_option, valeur from options_scripts order by script, nom_option';
        qry.Open;
        while not qry.Eof do
        begin
          ScriptName := TPath.GetFileNameWithoutExtension(qry.Fields.AsString[0]);
          if prevScript <> ScriptName then
            os := oo.Items[ScriptName] as TdwsJSONObject;
          if os = nil then
            os := oo.AddObject(ScriptName);

          Libelle := qry.Fields.AsString[1];
          ChooseValue := qry.Fields.AsString[2];
          ov := os.Items[Libelle];
          if ov = nil then
            os.AddValue(Libelle, ChooseValue)
          else
            ov.AsString := ChooseValue;

          prevScript := ScriptName;
          qry.Next;
        end;
      finally
        qry.Free;
      end;

      SaveScriptsOptions(oo);
    finally
      oo.Free;
    end;
  end;

begin
  Query.Script.Clear;

  Query.Script.Add('alter trigger albums_dv position 1;');
  Query.Script.Add('alter trigger albums_uniqid_biu0 position 0;');
  Query.Script.Add('alter trigger albums_univers_uniqid_biu0 position 0;');
  Query.Script.Add('alter trigger auteurs_parabd_uniqid_biu0 position 0;');
  Query.Script.Add('alter trigger auteurs_series_uniqid_biu0 position 0;');
  Query.Script.Add('alter trigger auteurs_uniqid_biu0 position 0;');
  Query.Script.Add('alter trigger collections_dv position 1;');
  Query.Script.Add('alter trigger collections_uniqid_biu0 position 0;');
  Query.Script.Add('alter trigger conversions_uniqid_biu0 position 0;');
  Query.Script.Add('alter trigger cotes_parabd_uniqid_biu0 position 0;');
  Query.Script.Add('alter trigger cotes_uniqid_biu0 position 0;');
  Query.Script.Add('alter trigger couvertures_uniqid_biu0 position 0;');
  Query.Script.Add('alter trigger editeurs_dv position 1;');
  Query.Script.Add('alter trigger editeurs_uniqid_biu0 position 0;');
  Query.Script.Add('alter trigger editions_uniqid_biu0 position 0;');
  Query.Script.Add('alter trigger emprunteurs_dv position 1;');
  Query.Script.Add('alter trigger emprunteurs_uniqid_biu0 position 0;');
  Query.Script.Add('alter trigger genres_dv position 1;');
  Query.Script.Add('alter trigger genres_uniqid_biu0 position 0;');
  Query.Script.Add('alter trigger genreseries_uniqid_biu0 position 0;');
  Query.Script.Add('alter trigger listes_uniqid_biu0 position 0;');
  Query.Script.Add('alter trigger options_scripts_uniqid_biu0 position 0;');
  Query.Script.Add('alter trigger options_uniqid_biu0 position 0;');
  Query.Script.Add('alter trigger parabd_dv position 1;');
  Query.Script.Add('alter trigger parabd_uniqid_biu0 position 0;');
  Query.Script.Add('alter trigger parabd_univers_uniqid_biu0 position 0;');
  Query.Script.Add('alter trigger personnes_dv position 1;');
  Query.Script.Add('alter trigger personnes_uniqid_biu0 position 0;');
  Query.Script.Add('alter trigger series_dv position 1;');
  Query.Script.Add('alter trigger series_uniqid_biu0 position 0;');
  Query.Script.Add('alter trigger series_univers_uniqid_biu0 position 0;');
  Query.Script.Add('alter trigger statut_uniqid_biu0 position 0;');
  Query.Script.Add('alter trigger suppressions_uniqid_biu0 position 0;');
  Query.Script.Add('alter trigger univers_dv position 1;');
  Query.Script.Add('alter trigger univers_uniqid_biu0 position 0;');

  Query.ExecuteScript;

  ExtractScriptsOptions;
end;

initialization

RegisterFBUpdate('2.2.3.23', @MAJ2_2_3_23);

end.
