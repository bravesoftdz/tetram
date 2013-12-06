unit ItemList;
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
  Classes;

type
  TListItem = class
  end;

  TItemList = class(TList)
  public
    procedure Clear; override;
  end;

  TItemID = packed record
    Size: word;
    List: TItemList;
    Item: TListItem;
  end;
  PItemID = ^TItemID;

implementation

{ TItemList }

procedure TItemList.Clear;
var
  i: integer;
begin
  for i := 0 to Count do
    TObject(List[i]).Free;
  inherited;
end;

end.

