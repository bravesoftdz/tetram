unit ExtractSQLInfos;

interface

uses
  SysUtils, Classes, Divers, CommonConst;


function ExtractSQLRequest(CurrentList: TStringList; LinkTable: TTable): TStringList;

implementation

function LinearFieldValue(CurrentTable : TTable): TStringList;
var
  Etat : Boolean;
begin
  Result := TStringList.Create;
  Etat := CurrentTable.Active;
  try
    CurrentTable.Open;
    CurrentTable.First;
    while not CurrentTable.Eof do begin
      Result.Add(CurrentTable.FieldByName('RefChamp').AsString);
      CurrentTable.Next;
    end;
  finally
    CurrentTable.Active := Etat;
  end;
end;

function ExtractCommonField(name, path: string; StrIDlist: TStringList): TStringList;
var
  index: Integer;
  AnalyseTable: TTable;
  AnalyseField: string;
begin
  Result := TStringList.Create;
  AnalyseTable := TTable.Create(nil);
  try
//    AnalyseTable.SessionName := AppSessionName;
//    AnalyseTable.DatabaseName := AppDatabaseName;
    AnalyseTable.TableName := name;
    AnalyseTable.Open;
    for index := 0 to AnalyseTable.FieldCount - 1 do begin
      AnalyseField := AnalyseTable.Fields.Fields[index].FieldName;
      if StrIDList.IndexOf(AnalyseField) <> -1 then Result.Add(AnalyseField);
    end;
  finally
    AnalyseTable.Free;
  end;
end;

function ExtractSQLRequest(CurrentList: TStringList; LinkTable: TTable): TStringList;
var
  indice ,x ,y : Integer;
  StringListArray : array of TStringList;
  StringList : TStringList;
begin
  Result := TStringList.Create;
  Stringlist := LinearFieldValue(LinkTable);
  try
    SetLength(StringListArray, CurrentList.Count);
    for indice := 0 to Currentlist.Count -1 do
      StringListArray[indice] := ExtractCommonField(CurrentList.Names[indice], LinkTable.DatabaseName, Stringlist);
    try
      for indice := Low(StringListArray) to High(StringListArray) - 1 do begin
        for x := indice + 1 to High(StringListArray) do begin
          for y := 0 to StringListArray[x].Count -1 do begin
            if StringListArray[indice].IndexOf(StringListArray[x][y]) > -1 then
              Result.Add(CurrentList.Values[CurrentList.Names[indice]] + '.' + StringListArray[x][y] + '=' + CurrentList.Values[CurrentList.Names[x]] + '.' + StringListArray[x][y]);
          end;
        end;
      end;
    finally
      for indice := Low(StringListArray) to High(StringListArray) - 1 do
        StringListArray[indice].Free;
    end;
  except
  end;
  StringList.free;
end;

end.
