{**********************************************************************}
{                                                                      }
{    "The contents of this file are subject to the Mozilla Public      }
{    License Version 1.1 (the "License"); you may not use this         }
{    file except in compliance with the License. You may obtain        }
{    a copy of the License at                                          }
{                                                                      }
{    http://www.mozilla.org/MPL/                                       }
{                                                                      }
{    Software distributed under the License is distributed on an       }
{    "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express       }
{    or implied. See the License for the specific language             }
{    governing rights and limitations under the License.               }
{                                                                      }
{    The Original Code is DelphiWebScriptII source code, released      }
{    January 1, 2001                                                   }
{                                                                      }
{    The Initial Developer of the Original Code is Matthias            }
{    Ackermann. For other initial contributors, see contributors.txt   }
{    Subsequent portions Copyright Creative IT.                        }
{                                                                      }
{    Current maintainer: Eric Grange                                   }
{                                                                      }
{    Contributor(s): Daniele Teti <d.teti@bittime.it>                  }
{                                                                      }
{**********************************************************************}
unit dwsHtmlFilter;

{$I dws.inc}

interface

uses
   Variants, Classes, SysUtils, StrUtils,
   dwsComp, dwsExprs, dwsFunctions, dwsSymbols, dwsExprList,
   dwsErrors, dwsCompiler, dwsStrings, dwsUtils, dwsMagicExprs,
   dwsResultFunctions;

type

   TCheckPatternEvalFunc = function (p : PWideChar) : Integer of object;

   // TdwsHtmlFilter
   //
   TdwsHtmlFilter = class(TdwsFilter)
      private
         FPatternOpen : UnicodeString;
         FPatternOpenLength : Integer;
         FPatternClose : UnicodeString;
         FPatternCloseLength : Integer;
         FPatternEval : UnicodeString;
         FPatternEvalLength : Integer;
         FCheckPatternEval : TCheckPatternEvalFunc;

      protected
         procedure SetPatternOpen(const val : UnicodeString);
         procedure SetPatternClose(const val : UnicodeString);
         procedure SetPatternEval(const val : UnicodeString);

      public
         constructor Create(AOwner: TComponent); override;

         procedure CheckPatterns;
         function CheckEvalLong(p : PWideChar) : Integer;
         function CheckEvalChar(p : PWideChar) : Integer;

         function Process(const aText : UnicodeString; msgs: TdwsMessageList) : UnicodeString; override;

      published
         property PatternOpen : UnicodeString read FPatternOpen write SetPatternOpen;
         property PatternClose : UnicodeString read FPatternClose write SetPatternClose;
         property PatternEval : UnicodeString read FPatternEval write SetPatternEval;
   end;

   TdwsHtmlUnit = class(TdwsUnitComponent)
      protected
         procedure AddUnitSymbols(SymbolTable: TSymbolTable); override;

      public
         constructor Create(AOwner: TComponent); override;
   end;

   EHTMLFilterException = class (Exception) end;

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
implementation
// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

{ TdwsHtmlFilter }

constructor TdwsHtmlFilter.Create(AOwner: TComponent);
begin
   inherited;

   PatternOpen:='<?pas';
   PatternClose:='?>';
   PatternEval:='=';
end;

// Process
//
function TdwsHtmlFilter.Process(const aText : UnicodeString; msgs : TdwsMessageList) : UnicodeString;
var
   endQuote : array [0..1] of WideChar;
   output : TWriteOnlyBlockStream;

   procedure StuffString(const input : UnicodeString; start, stop : Integer);
   const
      // Truth table for #13, #10, #9 and ''''
      cSpecial : array [#0..''''] of Byte =
         (0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1);
   var
      isQuoted: Boolean;
      i, k, lineCount: Integer;
      c : WideChar;
   begin
      if start>stop then Exit;

      output.WriteString('Print(');
      isQuoted:=False;
      lineCount:=0;
      i:=start;
      while i<=stop do begin
         if isQuoted then begin
            k:=i;
            repeat
               c:=input[i];
               if (c<=High(cSpecial)) and (cSpecial[c]<>0) then
                  break
               else Inc(i);
            until i>stop;
            if i>k then begin
               output.Write(input[k], (i-k)*SizeOf(WideChar));
               if i>stop then break;
            end;
            case input[i] of
               '''':
                  output.WriteString('''''');
               #10: begin
                  output.WriteString('''#10');
                  isQuoted:=False;
                  Inc(lineCount);
               end;
               #13: begin
                  output.WriteString('''#13');
                  isQuoted:=False;
               end;
               #9: begin
                  output.WriteString('''#9');
                  isQuoted:=False;
               end;
            else
               output.WriteChar(input[i]);
            end
         end else begin
            case input[i] of
               '''': begin
                  output.WriteString('''''''');
                  isQuoted:=True;
               end;
               #10: begin
                  output.WriteString('#10');
                  Inc(lineCount);
               end;
               #13: output.WriteString('#13');
               #9: output.WriteString('#9');
            else
               endQuote[1]:=input[i];
               output.Write(endQuote, SizeOf(endQuote));
               isQuoted:=True;
            end;
         end;
         Inc(i);
      end;

      if isQuoted then
         output.WriteString(''');')
      else output.WriteString(');');

      for i:=1 to lineCount do
         output.WriteCRLF;
   end;

var
   p, start, stop : Integer;
   isEval : Integer;
   input : UnicodeString;
   inputPtr : PWideChar;
begin
   CheckPatterns;

   endQuote[0]:='''';

   input:=inherited Process(aText, Msgs);
   inputPtr:=PWideChar(Pointer(input));

   output:=TWriteOnlyBlockStream.AllocFromPool;
   try

      stop:=1;
      p:=1;
      repeat
         start:=PosEx(PatternOpen, input, p);
         if start<=0 then begin
            StuffString(input, p, Length(input));
            Break;
         end else StuffString(input, p, start-1);
         start:=start+FPatternOpenLength;

         isEval:=FCheckPatternEval(@inputPtr[start-1]);
         if isEval=0 then begin
            output.WriteString('Print(');
            start:=start+FPatternEvalLength;
         end;

         stop:=PosEx(PatternClose, input, start);
         if stop<=0 then
            output.WriteSubString(input, start)
         else begin
            output.Write(inputPtr[start-1], (stop-start)*SizeOf(WideChar));
            p:=stop+FPatternCloseLength;
         end;

         if isEval=0 then
            output.WriteString(');');
      until (stop<=0);

      Result:=output.ToString;

   finally
      output.ReturnToPool;
   end;
end;

procedure TdwsHtmlFilter.CheckPatterns;
begin
   if FPatternOpen='' then
      raise EHTMLFilterException.Create('Property "PatternOpen" must be set!');
   if FPatternClose='' then
      raise EHTMLFilterException.Create('Property "PatternClose" must be set!');
   if FPatternEval='' then
      raise EHTMLFilterException.Create('Property "PatternEval" must be set!');
end;

// CheckEvalLong
//
function TdwsHtmlFilter.CheckEvalLong(p : PWideChar) : Integer;
begin
   Result:=Ord(not CompareMem(p, Pointer(FPatternEval), FPatternEvalLength));
end;

// CheckEvalChar
//
function TdwsHtmlFilter.CheckEvalChar(p : PWideChar) : Integer;
begin
   Result:=(Ord(FPatternEval[1])-Ord(p^));
end;

// SetPatternOpen
//
procedure TdwsHtmlFilter.SetPatternOpen(const val : UnicodeString);
begin
   FPatternOpen:=val;
   FPatternOpenLength:=Length(val);
end;

// SetPatternClose
//
procedure TdwsHtmlFilter.SetPatternClose(const val : UnicodeString);
begin
   FPatternClose:=val;
   FPatternCloseLength:=Length(val);
end;

// SetPatternEval
//
procedure TdwsHtmlFilter.SetPatternEval(const val : UnicodeString);
begin
   FPatternEval:=val;
   FPatternEvalLength:=Length(val);
   if FPatternEvalLength=1 then
      FCheckPatternEval:=CheckEvalChar
   else FCheckPatternEval:=CheckEvalLong;
end;

{ TdwsHtmlUnit }

procedure TdwsHtmlUnit.AddUnitSymbols(SymbolTable: TSymbolTable);
begin
   TPrintFunction.Create(SymbolTable, 'Send', ['s', SYS_VARIANT], '', [iffDeprecated]);
   TPrintLnFunction.Create(SymbolTable, 'SendLn', ['s', SYS_VARIANT], '', [iffDeprecated]);

   RegisterStandardResultFunctions(SymbolTable);
end;

constructor TdwsHtmlUnit.Create(AOwner: TComponent);
begin
  inherited;
  FUnitName := 'HTML';
end;

end.

