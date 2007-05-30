unit Columns;
{
 (c)2007 by Paul TOTH <tothpaul@free.fr>
 http://tothpaul.free.fr
}
{
This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}

interface

uses
  Classes, ShlObj;

type
  TDataType = (dtString, dtInteger, dtDate);

  TColumn = class
  private
    fName: string;
    fWidth: integer;
    fAlign: TAlignment;
    fDataType: TDataType;
  public
    procedure SetDetail(var Details: TShellDetails);
    property DataType: TDataType read fDataType;
  end;

  TColumns = class(TList)
  private
    function GetColumn(Index: integer): TColumn;
  public
    procedure Clear; override;
    function Add(const AName: string; AWidth: integer; AAlign: TAlignment = taLeftJustify; ADataType: TDataType = dtString): TColumn;
    property Columns[Index: integer]: TColumn read GetColumn; default;
  end;

implementation

{ TColumn }

procedure TColumn.SetDetail(var Details: TShellDetails);
begin
  Details.fmt := ord(fAlign);
  Details.cxChar := fWidth;
  Details.str.uType := STRRET_CSTR;
  Move(fName[1], Details.str.cStr, Length(fName) + 1);
end;

{ TColumns }

function TColumns.Add(const AName: string; AWidth: integer;
  AAlign: TAlignment = taLeftJustify; ADataType: TDataType = dtString): TColumn;
begin
  Result := TColumn.Create;
  Result.fName := AName;
  Result.fWidth := AWidth;
  Result.fAlign := AAlign;
  Result.fDataType := ADataType;
  inherited Add(Result);
end;

procedure TColumns.Clear;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    TObject(List[i]).Free;
  inherited;
end;

function TColumns.GetColumn(Index: integer): TColumn;
begin
  Result := List[Index];
end;

end.

