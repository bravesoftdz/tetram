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
{    The Initial Developer of the Original Code is Matthias            }
{    Ackermann. For other initial contributors, see contributors.txt   }
{    Subsequent portions Copyright Creative IT.                        }
{                                                                      }
{    Current maintainer: Eric Grange                                   }
{                                                                      }
{**********************************************************************}
unit dwsStringFunctions;

{$I dws.inc}

interface

uses
   Classes, SysUtils, Variants, StrUtils, Math, Masks,
   dwsXPlatform, dwsUtils, dwsStrings,
   dwsFunctions, dwsSymbols, dwsExprs, dwsCoreExprs, dwsExprList,
   dwsConstExprs, dwsMagicExprs, dwsDataContext, dwsWebUtils;

type

  EChrConvertError = class (Exception);

  TChrFunc = class sealed (TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TIntToStrFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TStrToIntFunc = class(TInternalMagicIntFunction)
    function DoEvalAsInteger(const args : TExprBaseListExec) : Int64; override;
  end;

  TStrToIntDefFunc = class(TInternalMagicIntFunction)
    function DoEvalAsInteger(const args : TExprBaseListExec) : Int64; override;
  end;

  TIntToHexFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  THexToIntFunc = class(TInternalMagicIntFunction)
    function DoEvalAsInteger(const args : TExprBaseListExec) : Int64; override;
  end;

  TIntToBinFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TBoolToStrFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TStrToBoolFunc = class(TInternalMagicBoolFunction)
    function DoEvalAsBoolean(const args : TExprBaseListExec) : Boolean; override;
  end;

  TFloatToStrFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;
  TFloatToStrPFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TStrToFloatFunc = class(TInternalMagicFloatFunction)
    procedure DoEvalAsFloat(const args : TExprBaseListExec; var Result : Double); override;
  end;

  TStrToFloatDefFunc = class(TInternalMagicFloatFunction)
    procedure DoEvalAsFloat(const args : TExprBaseListExec; var Result : Double); override;
  end;

  TStrToHtmlFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TFormatFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TCharAtFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TCopyFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TLeftStrFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TRightStrFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TSubStrFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TSubStringFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TStrDeleteLeftFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TStrDeleteRightFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TStrReplaceFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TDeleteFunc = class(TInternalMagicProcedure)
    procedure DoEvalProc(const args : TExprBaseListExec); override;
  end;

  TInsertFunc = class(TInternalMagicProcedure)
    procedure DoEvalProc(const args : TExprBaseListExec); override;
  end;

  TLowerCaseFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TAnsiLowerCaseFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TUpperCaseFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TAnsiUpperCaseFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TPosFunc = class(TInternalMagicIntFunction)
    function DoEvalAsInteger(const args : TExprBaseListExec) : Int64; override;
  end;

  TPosExFunc = class(TInternalMagicIntFunction)
    function DoEvalAsInteger(const args : TExprBaseListExec) : Int64; override;
  end;

  TRevPosFunc = class(TInternalMagicIntFunction)
    function DoEvalAsInteger(const args : TExprBaseListExec) : Int64; override;
  end;

  TSetLengthFunc = class(TInternalMagicProcedure)
    procedure DoEvalProc(const args : TExprBaseListExec); override;
  end;

  TTrimLeftFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TTrimRightFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TTrimFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TTrimNbFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TSameTextFunc = class(TInternalMagicBoolFunction)
    function DoEvalAsBoolean(const args : TExprBaseListExec) : Boolean; override;
  end;

  TCompareTextFunc = class(TInternalMagicIntFunction)
    function DoEvalAsInteger(const args : TExprBaseListExec) : Int64; override;
  end;

  TAnsiCompareTextFunc = class(TInternalMagicIntFunction)
    function DoEvalAsInteger(const args : TExprBaseListExec) : Int64; override;
  end;

  TCompareStrFunc = class(TInternalMagicIntFunction)
    function DoEvalAsInteger(const args : TExprBaseListExec) : Int64; override;
  end;

  TAnsiCompareStrFunc = class(TInternalMagicIntFunction)
    function DoEvalAsInteger(const args : TExprBaseListExec) : Int64; override;
  end;

  TMatchesStrFunc = class(TInternalMagicBoolFunction)
    function DoEvalAsBoolean(const args : TExprBaseListExec) : Boolean; override;
  end;

  TIsDelimiterFunc = class(TInternalMagicBoolFunction)
    function DoEvalAsBoolean(const args : TExprBaseListExec) : Boolean; override;
  end;

  TLastDelimiterFunc = class(TInternalMagicIntFunction)
    function DoEvalAsInteger(const args : TExprBaseListExec) : Int64; override;
  end;

  TFindDelimiterFunc = class(TInternalMagicIntFunction)
    function DoEvalAsInteger(const args : TExprBaseListExec) : Int64; override;
  end;

  TQuotedStrFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TStringOfCharFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TStringOfStringFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TStrBeginsWithFunc = class(TInternalMagicBoolFunction)
    function DoEvalAsBoolean(const args : TExprBaseListExec) : Boolean; override;
  end;

  TStrEndsWithFunc = class(TInternalMagicBoolFunction)
    function DoEvalAsBoolean(const args : TExprBaseListExec) : Boolean; override;
  end;

  TStrContainsFunc = class(TInternalMagicBoolFunction)
    function DoEvalAsBoolean(const args : TExprBaseListExec) : Boolean; override;
  end;

  TStrAfterFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TStrBeforeFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TStrSplitFunc = class(TInternalMagicVariantFunction)
    procedure DoEvalAsVariant(const args : TExprBaseListExec; var result : Variant); override;
  end;

  TStrJoinFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TReverseStringFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

  TGetTextFunc = class(TInternalMagicStringFunction)
    procedure DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString); override;
  end;

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
implementation
// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

{ TChrFunc }

// DoEvalAsString
//
procedure TChrFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
var
   c : Integer;
begin
   c:=args.AsInteger[0];
   case c of
      0..$FFFF :
         Result:=WideChar(c);
      $10000..$10FFFF : begin
         c:=c-$10000;
         Result:=WideChar($D800+(c shr 10))+WideChar($DC00+(c and $3FF));
      end;
   else
      raise EChrConvertError.CreateFmt('Invalid codepoint: %d', [c]);
   end;
end;

{ TIntToStrFunc }

// DoEvalAsString
//
procedure TIntToStrFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
begin
   FastInt64ToStr(args.AsInteger[0], Result);
end;

{ TStrToIntFunc }

function TStrToIntFunc.DoEvalAsInteger(const args : TExprBaseListExec) : Int64;
var
   s : UnicodeString;
begin
   s:=args.AsString[0];
   Result:=StrToInt64(s);
end;

{ TStrToIntDefFunc }

function TStrToIntDefFunc.DoEvalAsInteger(const args : TExprBaseListExec) : Int64;
var
   s : UnicodeString;
begin
   s:=args.AsString[0];
   Result:=StrToInt64Def(s, args.AsInteger[1]);
end;

{ TIntToHexFunc }

// DoEvalAsString
//
procedure TIntToHexFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
begin
   FastInt64ToHex(args.AsInteger[0], args.AsInteger[1], Result);
end;

{ THexToIntFunc }

function THexToIntFunc.DoEvalAsInteger(const args : TExprBaseListExec) : Int64;
var
   buf : UnicodeString;
   err : Integer;
begin
   buf:=args.AsString[0];
   Val('$'+buf, Result, err);
   if err<>0 then
      raise EConvertError.CreateFmt('''''%s'''' is not a valid hexadecimal value', [buf]);
end;

{ TIntToBinFunc }

// DoEvalAsString
//
procedure TIntToBinFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
var
   v : Int64;
   n : Integer;
begin
   v:=args.AsInteger[0];
   n:=args.AsInteger[1];
   Result:='';
   while (v<>0) or (n>0) do begin
      if (v and 1)=1 then
         Result:='1'+Result
      else Result:='0'+Result;
      v:=v shr 1;
      Dec(n);
   end;
end;

{ TBoolToStrFunc }

procedure TBoolToStrFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
const
   cBoolToStr : array [False..True] of UnicodeString = ( 'False', 'True' );
begin
   Result:=cBoolToStr[args.AsBoolean[0]];
end;

{ TStrToBoolFunc }

function TStrToBoolFunc.DoEvalAsBoolean(const args : TExprBaseListExec) : Boolean;
var
   s : UnicodeString;
begin
   s:=args.AsString[0];

   case Length(s) of
      1 : begin
         case s[1] of
            '1', 'T', 't', 'Y', 'y' : Result:=True;
         else
            Result:=False;
         end;
      end;
      3 : Result:=UnicodeSameText(s, 'Yes');
      4 : Result:=UnicodeSameText(s, 'True');
   else
      Result:=False;
   end;
end;

{ TFloatToStrFunc }

procedure TFloatToStrFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
begin
   {$ifdef FPC}
   Result:=UTF8Decode(FloatToStr(args.AsFloat[0]))
   {$else}
   Result:=FloatToStr(args.AsFloat[0])
   {$endif}
end;

{ TFloatToStrPFunc }

procedure TFloatToStrPFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
var
   p : Integer;
   v, p10 : Double;
begin
   p:=args.AsInteger[1];
   if p=99 then
      {$ifdef FPC}
      Result:=UTF8Decode(FloatToStr(args.AsFloat[0]))
      {$else}
      Result:=FloatToStr(args.AsFloat[0])
      {$endif}
   else begin
      v:=args.AsFloat[0];
      if p<0 then begin
         p10:=Power(10, p);
         v:=Round(v*p10)/p10;
         Result:=UnicodeFormat('%.0f', [v]);
      end else Result:=UnicodeFormat('%.*f', [p, v]);
   end;
end;

{ TStrToFloatFunc }

procedure TStrToFloatFunc.DoEvalAsFloat(const args : TExprBaseListExec; var Result : Double);
begin
   {$ifdef FPC}
   Result:=StrToFloat(UTF8Encode(args.AsString[0]));
   {$else}
   Result:=StrToFloat(args.AsString[0]);
   {$endif}
end;

{ TStrToFloatDefFunc }

procedure TStrToFloatDefFunc.DoEvalAsFloat(const args : TExprBaseListExec; var Result : Double);
begin
   {$ifdef FPC}
   Result:=StrToFloatDef(UTF8Encode(args.AsString[0]), args.AsFloat[1]);
   {$else}
   Result:=StrToFloatDef(args.AsString[0], args.AsFloat[1]);
   {$endif}
end;

{ TStrToHtmlFunc }

procedure TStrToHtmlFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
begin
   Result:=WebUtils.HTMLTextEncode(args.AsString[0]);
end;

{ TCopyFunc }

procedure TCopyFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
begin
   Result:=Copy(args.AsString[0], args.AsInteger[1], args.AsInteger[2]);
end;

{ TLeftStrFunc }

procedure TLeftStrFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
begin
   Result:=Copy(args.AsString[0], 1, args.AsInteger[1]);
end;

{ TRightStrFunc }

procedure TRightStrFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
var
   buf : UnicodeString;
   n : Integer;
begin
   buf:=args.AsString[0];
   n:=args.AsInteger[1];
   Result:=Copy(buf, Length(buf)+1-n, n);
end;

{ TSubStrFunc }

procedure TSubStrFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
begin
   Result:=Copy(args.AsString[0], args.AsInteger[1], MaxInt);
end;

{ TSubStringFunc }

procedure TSubStringFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
var
   s, e : Integer;
begin
   s:=args.AsInteger[1];
   e:=args.AsInteger[2];
   if s<1 then s:=1;
   Result:=Copy(args.AsString[0], s, e-s);
end;

{ TStrDeleteLeftFunc }

procedure TStrDeleteLeftFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
begin
   Result:=StrDeleteLeft(args.AsString[0], args.AsInteger[1]);
end;

{ TStrDeleteRightFunc }

procedure TStrDeleteRightFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
begin
   Result:=StrDeleteRight(args.AsString[0], args.AsInteger[1]);
end;

{ TStrReplaceFunc }

procedure TStrReplaceFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
begin
   Result:=args.AsString[0];
   FastStringReplace(Result, args.AsString[1], args.AsString[2]);
end;

{ TDeleteFunc }

procedure TDeleteFunc.DoEvalProc(const args : TExprBaseListExec);
var
   s : UnicodeString;
begin
   s:=args.AsString[0];
   Delete(s, args.AsInteger[1], args.AsInteger[2]);
   args.AsString[0]:=s;
end;

{ TInsertFunc }

procedure TInsertFunc.DoEvalProc(const args : TExprBaseListExec);
var
   s : UnicodeString;
begin
   s:=args.AsString[1];
   Insert(args.AsString[0], s, args.AsInteger[2]);
   args.AsString[1]:=s;
end;

{ TLowerCaseFunc }

procedure TLowerCaseFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
var
   p : PWideChar;
   i : Integer;
   c : WideChar;
begin
   args.ExprBase[0].EvalAsString(args.Exec, Result);
   if Result='' then Exit;
   UniqueString(Result);
   p:=PWideChar(Pointer(Result));
   for i:=0 to Length(Result)-1 do begin
      c:=p[i];
      case c of
        'A'..'Z':
           p[i]:=WideChar(Word(c)+(Ord('a')-Ord('A')));
      end;
   end;
end;

{ TAnsiLowerCaseFunc }

procedure TAnsiLowerCaseFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
begin
   Result:=UnicodeLowerCase(args.AsString[0]);
end;

{ TUpperCaseFunc }

procedure TUpperCaseFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
var
   p : PWideChar;
   i : Integer;
   c : WideChar;
begin
   args.ExprBase[0].EvalAsString(args.Exec, Result);
   if Result='' then Exit;
   UniqueString(Result);
   p:=PWideChar(Pointer(Result));
   for i:=0 to Length(Result)-1 do begin
      c:=p[i];
      case c of
        'a'..'z':
           p[i]:=WideChar(Word(c)-(Ord('a')-Ord('A')));
      end;
   end;
end;

{ TAnsiUpperCaseFunc }

procedure TAnsiUpperCaseFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
begin
   Result:=UnicodeUpperCase(args.AsString[0]);
end;

{ TPosFunc }

function TPosFunc.DoEvalAsInteger(const args : TExprBaseListExec) : Int64;
begin
   Result:=Pos(args.AsString[0], args.AsString[1]);
end;

{ TPosExFunc }

function TPosExFunc.DoEvalAsInteger(const args : TExprBaseListExec) : Int64;
begin
   Result:=PosEx(args.AsString[0], args.AsString[1], args.AsInteger[2]);
end;

{ TRevPosFunc }

function TRevPosFunc.DoEvalAsInteger(const args : TExprBaseListExec) : Int64;

   function StrRevFind(const stringSearched, stringToFind : UnicodeString; startPos : Integer = 0) : Integer;
   var
      i : Integer;
   begin
      if (stringToFind='') or (stringSearched='') then begin
         Result:=0;
         Exit;
      end;
      if startPos<=0 then
         startPos:=Length(stringSearched);
      for i:=startPos-Length(stringToFind)+1 downto 1 do begin
         if stringSearched[i]=stringToFind[1] then begin
            if CompareMem(@stringSearched[i], @stringToFind[1], Length(stringToFind)*SizeOf(WideChar)) then begin
               Result:=i;
               Exit;
            end;
         end;
      end;
      Result:=0;
   end;

begin
   Result:=StrRevFind(args.AsString[1], args.AsString[0]);
end;

{ TTrimLeftFunc }

// DoEvalAsString
//
procedure TTrimLeftFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
begin
   Result:=TrimLeft(args.AsString[0]);
end;

{ TTrimRightFunc }

// DoEvalAsString
//
procedure TTrimRightFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
begin
   Result:=TrimRight(args.AsString[0]);
end;

{ TTrimFunc }

procedure TTrimFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
begin
   Result:=Trim(args.AsString[0]);
end;

{ TTrimNbFunc }

procedure TTrimNbFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
var
   nbLeft, nbRight : Integer;
begin
   Result:=args.AsString[0];
   nbLeft:=args.AsInteger[1];
   nbRight:=args.AsInteger[2];
   if Result<>'' then begin
      if nbLeft<0 then nbLeft:=0;
      if nbRight<0 then nbRight:=0;
      Result:=Copy(Result, nbLeft+1, Length(Result)-nbRight-nbLeft);
   end;
end;

{ TSameTextFunc }

function TSameTextFunc.DoEvalAsBoolean(const args : TExprBaseListExec) : Boolean;
begin
   Result:=UnicodeSameText(args.AsString[0], args.AsString[1]);
end;

{ TCompareTextFunc }

function TCompareTextFunc.DoEvalAsInteger(const args : TExprBaseListExec) : Int64;
begin
   {$ifdef FPC}
   Result:=CompareText(UTF8Encode(args.AsString[0]), UTF8Encode(args.AsString[1]));
   {$else}
   Result:=CompareText(args.AsString[0], args.AsString[1]);
   {$endif}
end;

{ TAnsiCompareTextFunc }

function TAnsiCompareTextFunc.DoEvalAsInteger(const args : TExprBaseListExec) : Int64;
begin
   Result:=UnicodeCompareText(args.AsString[0], args.AsString[1]);
end;

{ TCompareStrFunc }

function TCompareStrFunc.DoEvalAsInteger(const args : TExprBaseListExec) : Int64;
begin
   Result:=UnicodeCompareStr(args.AsString[0], args.AsString[1]);
end;

{ TAnsiCompareStrFunc }

function TAnsiCompareStrFunc.DoEvalAsInteger(const args : TExprBaseListExec) : Int64;
begin
   Result:=dwsXPlatform.AnsiCompareStr(args.AsString[0], args.AsString[1]);
end;

{ TMatchesStrFunc }

function TMatchesStrFunc.DoEvalAsBoolean(const args : TExprBaseListExec) : Boolean;
begin
   Result:=StrMatches(args.AsString[0], args.AsString[1]);
end;

{ TIsDelimiterFunc }

function TIsDelimiterFunc.DoEvalAsBoolean(const args : TExprBaseListExec) : Boolean;
begin
   Result:=IsDelimiter(args.AsString[0], args.AsString[1], args.AsInteger[2]);
end;

{ TLastDelimiterFunc }

function TLastDelimiterFunc.DoEvalAsInteger(const args : TExprBaseListExec) : Int64;
begin
   Result:=LastDelimiter(args.AsString[0], args.AsString[1]);
end;

{ TFindDelimiterFunc }

function TFindDelimiterFunc.DoEvalAsInteger(const args : TExprBaseListExec) : Int64;
begin
   Result:=FindDelimiter(args.AsString[0], args.AsString[1], args.AsInteger[2]);
end;

{ TQuotedStrFunc }

// DoEvalAsString
//
procedure TQuotedStrFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
var
   quoteChar : UnicodeString;
begin
   quoteChar:=args.AsString[1];
   if quoteChar='' then
      Result:=AnsiQuotedStr(args.AsString[0], '''')
   else Result:=AnsiQuotedStr(args.AsString[0], quoteChar[1]);
end;

{ TCharAtFunc }

// DoEvalAsString
//
procedure TCharAtFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
var
   buf : UnicodeString;
   n : Integer;
begin
   buf:=args.AsString[0];
   n:=args.AsInteger[1];
   if (n>0) and (n<=Length(buf)) then
      Result:=buf[n]
   else Result:='';
end;

{ TSetLengthFunc }

// DoEvalProc
//
procedure TSetLengthFunc.DoEvalProc(const args : TExprBaseListExec);
var
   i, n : Integer;
   s : UnicodeString;
begin
   s:=args.AsString[0];

   i:=Length(s)+1;
   n:=args.AsInteger[1];
   SetLength(s, n);
   while i<=n do begin
      s[i]:=' ';
      Inc(i);
   end;

   args.AsString[0]:=s;
end;

{ TStringOfCharFunc }

// DoEvalAsString
//
procedure TStringOfCharFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
var
   ch : UnicodeString;
   charCode : WideChar;
   p : PWideChar;
   n : Integer;
begin
   n:=args.AsInteger[1];
   if n<=0 then Exit;
   ch:=args.AsString[0];
   if ch='' then
      charCode:=' ' // default to blank if an empty String
   else charCode:=ch[1];
   SetLength(Result, n);
   p:=PWideChar(Pointer(Result));
   for n:=n downto 1 do
      p[n-1]:=charCode;
end;

{ TStringOfStringFunc }

// DoEvalAsString
//
procedure TStringOfStringFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);

   function StringOfString(const str : UnicodeString; count : Integer) : UnicodeString;
   var
      ls : Integer;
   begin
      if (str='') or (count<=0) then Exit('');
      ls:=Length(str);
      count:=ls*count;
      SetLength(Result, count);
      while count>0 do begin
         Dec(count, ls);
         Move(str[1], Result[count+1], ls*SizeOf(WideChar));
      end;
   end;

begin
   Result:=StringOfString(args.AsString[0], args.AsInteger[1]);
end;

{ TStrBeginsWithFunc }

function TStrBeginsWithFunc.DoEvalAsBoolean(const args : TExprBaseListExec) : Boolean;
var
   str, beginStr : UnicodeString;
begin
   str:=args.AsString[0];
   beginStr:=args.AsString[1];
   if Length(str)<Length(beginStr) then
      Result:=False
   else begin
      Result:=CompareMem(PChar(Pointer(str)), PChar(Pointer(beginStr)),
                         Length(beginStr)*SizeOf(Char));
   end;
end;

{ TStrEndsWithFunc }

function TStrEndsWithFunc.DoEvalAsBoolean(const args : TExprBaseListExec) : Boolean;
var
   str, endStr : UnicodeString;
begin
   str:=args.AsString[0];
   endStr:=args.AsString[1];
   if Length(str)<Length(endStr) then
      Result:=False
   else begin
      Result:=CompareMem(@str[Length(str)-Length(endStr)+1], PChar(Pointer(endStr)),
                         Length(endStr)*SizeOf(Char));
   end;
end;

{ TStrContainsFunc }

function TStrContainsFunc.DoEvalAsBoolean(const args : TExprBaseListExec) : Boolean;
begin
   Result:=StrContains(args.AsString[0], args.AsString[1]);
end;

{ TStrAfterFunc }

procedure TStrAfterFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
var
   p : Integer;
   str, delimiter : UnicodeString;
begin
   str:=args.AsString[0];
   delimiter:=args.AsString[1];
   p:=Pos(delimiter, str);
   if p>0 then
      Result:=Copy(str, p+Length(delimiter), MaxInt)
   else Result:='';
end;

{ TStrBeforeFunc }

procedure TStrBeforeFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
var
   p : Integer;
   str, delimiter : UnicodeString;
begin
   str:=args.AsString[0];
   delimiter:=args.AsString[1];
   p:=Pos(delimiter, str);
   if p>0 then
      Result:=Copy(str, 1, p-1)
   else Result:=str;
end;

{ TReverseStringFunc }

procedure TReverseStringFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
begin
   Result:=ReverseString(args.AsString[0]);
end;

{ TFormatFunc }

procedure TFormatFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
var
   expr : TExprBase;
   varRecs : TVarRecArrayContainer;
begin
   varRecs:=nil;
   expr:=args.ExprBase[1];
   if expr is TArrayConstantExpr then
      varRecs:=TArrayConstantExpr(expr).EvalAsVarRecArray(args.Exec)
   else if expr is TByRefParamExpr then begin
      if TByRefParamExpr(expr).Typ is TOpenArraySymbol then
         varRecs:=TVarRecArrayContainer.Create(TByRefParamExpr(expr).DataPtr[args.Exec].AsPData^)
   end;
   // current implementation, limitations may be relaxed later
   if varRecs=nil then raise EScriptError.Create('Constant expression or open array expected');
   try
      Result:=UnicodeFormat(args.AsString[0], varRecs.VarRecArray);
   finally
      varRecs.Free;
   end;
end;

{ TStrSplitFunc }

procedure TStrSplitFunc.DoEvalAsVariant(const args : TExprBaseListExec; var result : Variant);
var
   str, delim : UnicodeString;
   dyn : TScriptDynamicArray;
   p, pn, nDelim, k, n : Integer;
   c : Char;
begin
   str:=args.AsString[0];
   delim:=args.AsString[1];

   dyn:=TScriptDynamicArray.CreateNew((args.ExprBase[0] as TTypedExpr).Typ);

   if delim='' then begin

      // special case, split separates all characters
      pn:=Length(str);
      dyn.ArrayLength:=pn;
      for k:=1 to pn do
         dyn.AsString[k-1]:=str[k];

   end else if Length(delim)=1 then begin

      // special case of a single-character delimiter
      c:=delim[1];
      n:=0;
      for k:=1 to Length(str) do
         if str[k]=c then Inc(n);
      dyn.ArrayLength:=n+1;
      if n=0 then
         dyn.AsString[0]:=str
      else begin
         n:=0;
         p:=1;
         for k:=1 to Length(str) do begin
            if str[k]=c then begin
               dyn.AsString[n]:=Copy(str, p, k-p);
               Inc(n);
               p:=k+1;
            end;
         end;
         dyn.AsString[n]:=Copy(str, p);
      end;

   end else begin

      // general case of string delimiter
      nDelim:=Length(delim);
      p:=1;
      k:=0;
      while True do begin
         pn:=PosEx(delim, str, p);
         if pn>0 then begin
            dyn.Insert(k);
            dyn.AsString[k]:=Copy(str, p, pn-p);
            Inc(k);
            p:=pn+nDelim;
         end else break;
      end;
      dyn.Insert(k);
      dyn.AsString[k]:=Copy(str, p, Length(str)+1-p);

   end;

   Result:=IScriptDynArray(dyn);
end;

// ------------------
// ------------------ TStrJoinFunc ------------------
// ------------------

// DoEvalAsString
//
procedure TStrJoinFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
var
   delim, item : UnicodeString;
   dynIntf : IScriptDynArray;
   i : Integer;
   wobs : TWriteOnlyBlockStream;
begin
   args.ExprBase[0].EvalAsScriptDynArray(args.Exec, dynIntf);

   delim:=args.AsString[1];

   case dynIntf.ArrayLength of
      0 : Result:='';
      1..5 : begin
         dynIntf.EvalAsString(0, Result);
         for i:=1 to dynIntf.ArrayLength-1 do begin
            dynIntf.EvalAsString(i, item);
            Result:=Result+delim+item;
         end;
      end;
   else
      wobs:=TWriteOnlyBlockStream.AllocFromPool;
      try
         dynIntf.EvalAsString(0, item);
         wobs.WriteString(item);
         for i:=1 to dynIntf.ArrayLength-1 do begin
            wobs.WriteString(delim);
            dynIntf.EvalAsString(i, item);
            wobs.WriteString(item);
         end;
         Result:=wobs.ToString;
      finally
         wobs.ReturnToPool;
      end;
   end;
end;

// ------------------
// ------------------ TGetTextFunc ------------------
// ------------------

// DoEvalAsString
//
procedure TGetTextFunc.DoEvalAsString(const args : TExprBaseListExec; var Result : UnicodeString);
begin
   args.Exec.LocalizeString(args.AsString[0], Result);
end;

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
initialization
// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

   RegisterInternalStringFunction(TChrFunc, 'Chr', ['i', SYS_INTEGER], [iffStateLess]);

   RegisterInternalStringFunction(TIntToStrFunc, 'IntToStr', ['i', SYS_INTEGER], [iffStateLess], 'ToString');
   RegisterInternalIntFunction(TStrToIntFunc, 'StrToInt', ['str', SYS_STRING], [iffStateLess], 'ToInteger');
   RegisterInternalIntFunction(TStrToIntDefFunc, 'StrToIntDef', ['str', SYS_STRING, 'def', SYS_INTEGER], [iffStateLess], 'ToIntegerDef');
   RegisterInternalIntFunction(TStrToIntDefFunc, 'VarToIntDef', ['val', SYS_VARIANT, 'def', SYS_INTEGER], [iffStateLess]);

   RegisterInternalStringFunction(TIntToHexFunc, 'IntToHex', ['v', SYS_INTEGER, 'digits', SYS_INTEGER], [iffStateLess], 'ToHexString');
   RegisterInternalIntFunction(THexToIntFunc, 'HexToInt', ['hexa', SYS_STRING], [iffStateLess], 'HexToInteger');
   RegisterInternalStringFunction(TIntToBinFunc, 'IntToBin', ['v', SYS_INTEGER, 'digits', SYS_INTEGER], [iffStateLess], 'ToBin');

   RegisterInternalStringFunction(TBoolToStrFunc, 'BoolToStr', ['b', SYS_BOOLEAN], [iffStateLess], 'ToString');
   RegisterInternalBoolFunction(TStrToBoolFunc, 'StrToBool', ['str', SYS_STRING], [iffStateLess], 'ToBoolean');

   RegisterInternalStringFunction(TFloatToStrFunc, 'FloatToStr', ['f', SYS_FLOAT], [iffStateLess, iffOverloaded], 'ToString');
   RegisterInternalStringFunction(TFloatToStrPFunc, 'FloatToStr', ['f', SYS_FLOAT, 'p', SYS_INTEGER], [iffStateLess, iffOverloaded], 'ToString');
   RegisterInternalFloatFunction(TStrToFloatFunc, 'StrToFloat', ['str', SYS_STRING], [iffStateLess], 'ToFloat');
   RegisterInternalFloatFunction(TStrToFloatDefFunc, 'StrToFloatDef', ['str', SYS_STRING, 'def', SYS_FLOAT], [iffStateLess], 'ToFloatDef');
   RegisterInternalFloatFunction(TStrToFloatDefFunc, 'VarToFloatDef', ['val', SYS_VARIANT, 'def', SYS_FLOAT], [iffStateLess]);

   RegisterInternalStringFunction(TStrToHtmlFunc, 'StrToHtml', ['str', SYS_STRING], [iffStateLess], 'ToHtml');

   RegisterInternalStringFunction(TFormatFunc, 'Format', ['fmt', SYS_STRING, 'args', 'array of const'], [iffStateLess], 'Format');

   RegisterInternalStringFunction(TCharAtFunc, 'CharAt', ['s', SYS_STRING, 'x', SYS_INTEGER], [iffStateLess, iffDeprecated]);

   RegisterInternalFunction(TDeleteFunc, 'Delete', ['@S', SYS_STRING, 'index', SYS_INTEGER, 'Len', SYS_INTEGER], '');
   RegisterInternalFunction(TInsertFunc, 'Insert', ['src', SYS_STRING, '@S', SYS_STRING, 'index', SYS_INTEGER], '');

   RegisterInternalStringFunction(TLowerCaseFunc, 'LowerCase', ['str', SYS_STRING], [iffStateLess], 'LowerCase');
   RegisterInternalStringFunction(TAnsiLowerCaseFunc, 'AnsiLowerCase', ['str', SYS_STRING], [iffStateLess], 'ToLower');
   RegisterInternalStringFunction(TUpperCaseFunc, 'UpperCase', ['str', SYS_STRING], [iffStateLess], 'UpperCase');
   RegisterInternalStringFunction(TAnsiUpperCaseFunc, 'AnsiUpperCase', ['str', SYS_STRING], [iffStateLess], 'ToUpper');

   RegisterInternalIntFunction(TPosFunc, 'Pos', ['subStr', SYS_STRING, 'str', SYS_STRING], [iffStateLess]);
   RegisterInternalIntFunction(TPosExFunc, 'PosEx', ['subStr', SYS_STRING, 'str', SYS_STRING, 'offset', SYS_INTEGER], [iffStateLess]);
   RegisterInternalIntFunction(TRevPosFunc, 'RevPos', ['subStr', SYS_STRING, 'str', SYS_STRING], [iffStateLess]);

   RegisterInternalFunction(TSetLengthFunc, 'SetLength', ['@S', SYS_STRING, 'NewLength', SYS_INTEGER], '');

   RegisterInternalStringFunction(TTrimLeftFunc, 'TrimLeft', ['str', SYS_STRING], [iffStateLess], 'TrimLeft');
   RegisterInternalStringFunction(TTrimRightFunc, 'TrimRight', ['str', SYS_STRING], [iffStateLess], 'TrimRight');
   RegisterInternalStringFunction(TTrimFunc, 'Trim', ['str', SYS_STRING], [iffStateLess, iffOverloaded], 'Trim');
   RegisterInternalStringFunction(TTrimNbFunc, 'Trim', ['str', SYS_STRING, 'nbLeft', SYS_INTEGER, 'nbRight', SYS_INTEGER], [iffStateLess, iffOverloaded], 'Trim');

   RegisterInternalBoolFunction(TSameTextFunc, 'SameText', ['str1', SYS_STRING, 'str2', SYS_STRING], [iffStateLess], 'EqualsText');
   RegisterInternalIntFunction(TCompareTextFunc, 'CompareText', ['str1', SYS_STRING, 'str2', SYS_STRING], [iffStateLess], 'CompareText');
   RegisterInternalIntFunction(TAnsiCompareTextFunc, 'AnsiCompareText', ['str1', SYS_STRING, 'str2', SYS_STRING], [iffStateLess]);
   RegisterInternalIntFunction(TCompareStrFunc, 'CompareStr', ['str1', SYS_STRING, 'str2', SYS_STRING], [iffStateLess], 'CompareTo');
   RegisterInternalIntFunction(TAnsiCompareStrFunc, 'AnsiCompareStr', ['str1', SYS_STRING, 'str2', SYS_STRING], [iffStateLess]);

   RegisterInternalBoolFunction(TMatchesStrFunc, 'StrMatches', ['str', SYS_STRING, 'mask', SYS_STRING], [iffStateLess], 'Matches');

   RegisterInternalBoolFunction(TIsDelimiterFunc, 'IsDelimiter', ['delims', SYS_STRING, 'str', SYS_STRING, 'index', SYS_INTEGER], [iffStateLess]);
   RegisterInternalIntFunction(TLastDelimiterFunc, 'LastDelimiter', ['delims', SYS_STRING, 'str', SYS_STRING], [iffStateLess]);
   RegisterInternalIntFunction(TFindDelimiterFunc, 'FindDelimiter', ['delims', SYS_STRING, 'str', SYS_STRING, 'startIndex=1', SYS_INTEGER], [iffStateLess]);

   RegisterInternalStringFunction(TQuotedStrFunc, 'QuotedStr', ['str', SYS_STRING, 'quoteChar=', SYS_STRING], [iffStateLess], 'QuotedString');

   RegisterInternalStringFunction(TCopyFunc, 'Copy', ['str', SYS_STRING, 'index', SYS_INTEGER, 'Len', SYS_INTEGER], [iffStateLess]);

   RegisterInternalStringFunction(TLeftStrFunc, 'LeftStr', ['str', SYS_STRING, 'count', SYS_INTEGER], [iffStateLess], 'Left');
   RegisterInternalStringFunction(TRightStrFunc, 'RightStr', ['str', SYS_STRING, 'count', SYS_INTEGER], [iffStateLess], 'Right');
   RegisterInternalStringFunction(TCopyFunc, 'MidStr', ['str', SYS_STRING, 'start', SYS_INTEGER, 'count', SYS_INTEGER], [iffStateLess]);
   RegisterInternalStringFunction(TSubStrFunc, 'SubStr', ['str', SYS_STRING, 'start', SYS_INTEGER], [iffStateLess]);
   RegisterInternalStringFunction(TSubStringFunc, 'SubString', ['str', SYS_STRING, 'start', SYS_INTEGER, 'end', SYS_INTEGER], [iffStateLess]);
   RegisterInternalStringFunction(TStrDeleteLeftFunc, 'StrDeleteLeft', ['str', SYS_STRING, 'count', SYS_INTEGER], [iffStateLess], 'DeleteLeft');
   RegisterInternalStringFunction(TStrDeleteRightFunc, 'StrDeleteRight', ['str', SYS_STRING, 'count', SYS_INTEGER], [iffStateLess], 'DeleteRight');

   RegisterInternalStringFunction(TStrReplaceFunc, 'StrReplace', ['str', SYS_STRING, 'sub', SYS_STRING,  'newSub', SYS_STRING], [iffStateLess], 'Replace');

   RegisterInternalStringFunction(TStringOfCharFunc, 'StringOfChar', ['ch', SYS_STRING, 'count', SYS_INTEGER], []);
   RegisterInternalStringFunction(TStringOfStringFunc, 'StringOfString', ['str', SYS_STRING, 'count', SYS_INTEGER], []);
   RegisterInternalStringFunction(TStringOfStringFunc, 'DupeString', ['str', SYS_STRING, 'count', SYS_INTEGER], [], 'Dupe');

   RegisterInternalBoolFunction(TStrBeginsWithFunc, 'StrBeginsWith', ['str', SYS_STRING, 'beginStr', SYS_STRING], [iffStateLess], 'StartsWith');
   RegisterInternalBoolFunction(TStrEndsWithFunc, 'StrEndsWith', ['str', SYS_STRING, 'endStr', SYS_STRING], [iffStateLess], 'EndsWith');

   RegisterInternalBoolFunction(TStrContainsFunc, 'StrContains', ['str', SYS_STRING, 'subStr', SYS_STRING], [iffStateLess], 'Contains');

   RegisterInternalStringFunction(TStrAfterFunc, 'StrAfter', ['str', SYS_STRING, 'delimiter', SYS_STRING], [iffStateLess], 'After');
   RegisterInternalStringFunction(TStrBeforeFunc, 'StrBefore', ['str', SYS_STRING, 'delimiter', SYS_STRING], [iffStateLess], 'Before');
   RegisterInternalFunction(TStrSplitFunc, 'StrSplit', ['str', SYS_STRING, 'delimiter', SYS_STRING], 'array of string', [], 'Split');
   RegisterInternalStringFunction(TStrJoinFunc, 'StrJoin', ['strs', 'array of string', 'delimiter', SYS_STRING], [], 'Join');

   RegisterInternalStringFunction(TReverseStringFunc, 'ReverseString', ['str', SYS_STRING], [iffStateLess], 'Reverse');

   RegisterInternalStringFunction(TGetTextFunc, '_', ['str', SYS_STRING], []);

end.

