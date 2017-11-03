{**********************************************************************}
{                                                                      }
{    "The contents of this file are subject to the Mozilla Public      }
{    License Version 1.1 (the "License"); you may not use this         }
{    file except in compliance with the License. You may obtain        }
{    a copy of the License at http://www.mozilla.org/MPL/              }
{                                                                      }
{    Software distributed under the License is distributed on an       }
{    "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express       }
{    or implied. See the License for the specific language             }
{    governing rights and limitations under the License.               }
{                                                                      }
{    Copyright Creative IT.                                            }
{    Current maintainer: Eric Grange                                   }
{                                                                      }
{**********************************************************************}
unit dwsCaseNormalizer;

{$I ../dws.inc}

interface

uses
   Classes, SysUtils,
   dwsUtils,
   dwsErrors, dwsExprs, dwsSymbols;

type
   TCaseNormalizerEvent = procedure (line, col : Integer; const name : String) of object;


procedure NormalizeSymbolsCase(sourceLines : TStrings; sourceFile : TSourceFile;
                               symbolDictionary : TdwsSymbolDictionary;
                               const onNormalize : TCaseNormalizerEvent = nil);

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
implementation
// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

type

   TSymbolLocation = class (TRefCountedObject)
      Line, Col : Integer;
      Symbol : TSymbol;
   end;

   TSymbolLocations = class(TObjectList<TSymbolLocation>)
      function CompareLocations(a, b : Integer) : Integer;
      procedure Swap(a, b : Integer);
   end;

// CompareLocations
//
function TSymbolLocations.CompareLocations(a, b : Integer) : Integer;
var
   locA, locB : TSymbolLocation;
begin
   locA:=Items[a];
   locB:=Items[b];
   Result:=locB.Line-locA.Line;
   if Result=0 then
      Result:=locB.Col-locA.Col;
end;

// Swap
//
procedure TSymbolLocations.Swap(a, b : Integer);
var
   tmp : TSymbolLocation;
begin
   tmp:=Items[a];
   Items[a]:=Items[b];
   Items[b]:=tmp;
end;

// NormalizeSymbolsCase
//
procedure NormalizeSymbolsCase(sourceLines : TStrings; sourceFile : TSourceFile;
                               symbolDictionary : TdwsSymbolDictionary;
                               const onNormalize : TCaseNormalizerEvent = nil);
var
   i, j : Integer;
   symPosList : TSymbolPositionList;
   symPos : TSymbolPosition;
   locations : TSymbolLocations;
   location : TSymbolLocation;
   sorter : TQuickSort;
   symbol : TSymbol;
   line, occurence : String;
begin
   locations:=TSymbolLocations.Create;
   try
      // collect all symbol locations in the file
      for i:=0 to symbolDictionary.Count-1 do begin
         symPosList:=symbolDictionary[i];
         for j:=0 to symPosList.Count-1 do begin
            symPos:=symPosList[j];
            if suImplicit in symPos.SymbolUsages then continue;
            if symPos.ScriptPos.SourceFile<>sourceFile then continue;
            if symPosList.Symbol.Name='' then continue;

            symbol:=symPosList.Symbol;
            occurence:=Copy(sourceLines[symPos.ScriptPos.Line-1], symPos.ScriptPos.Col, Length(symbol.Name));
            if occurence<>symbol.Name then begin
               Assert(UnicodeSameText(symbol.Name, occurence));
               location:=TSymbolLocation.Create;
               location.Line:=symPos.ScriptPos.Line;
               location.Col:=symPos.ScriptPos.Col;
               location.Symbol:=symbol;
               locations.Add(location);
            end;
         end;
      end;
      // sort first to last
      sorter.CompareMethod:=locations.CompareLocations;
      sorter.SwapMethod:=locations.Swap;
      sorter.Sort(0, locations.Count-1);
      // replace
      for i:=locations.Count-1 downto 0 do begin
         location:=locations[i];
         line:=sourceLines[location.Line-1];
         symbol:=location.Symbol;
         if Assigned(onNormalize) then
            onNormalize(location.Line, location.Col, symbol.Name);
         line:=Copy(line, 1, location.Col-1)+symbol.Name+Copy(line, location.Col+Length(symbol.Name));
         sourceLines[location.Line-1]:=line;
      end;
   finally
      locations.Free;
   end;
end;

end.
