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
unit dwsRelExprs;

{$I dws.inc}

interface

uses dwsExprs, dwsSymbols, dwsErrors, Variants;

type

   TRelOpExpr = class(TBinaryOpExpr)
      constructor Create(Prog: TdwsProgram; const aScriptPos : TScriptPos; aLeft, aRight : TTypedExpr); override;
      procedure EvalAsVariant(exec : TdwsExecution; var result : Variant); override;
   end;
   TRelOpExprClass = class of TRelOpExpr;

   // boolean rel ops

   TBoolRelOpExpr = class(TRelOpExpr)
   end;

   TRelEqualBoolExpr = class(TBoolRelOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;
   TRelNotEqualBoolExpr = class(TBoolRelOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;

   // integer rel ops

   TIntegerRelOpExpr = class(TRelOpExpr)
   end;

   TRelEqualIntExpr = class(TIntegerRelOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
     function Optimize(prog : TdwsProgram; exec : TdwsExecution) : TProgramExpr; override;
   end;
   TRelNotEqualIntExpr = class(TIntegerRelOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
     function Optimize(prog : TdwsProgram; exec : TdwsExecution) : TProgramExpr; override;
   end;
   TRelLessIntExpr = class(TIntegerRelOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;
   TRelLessEqualIntExpr = class(TIntegerRelOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;
   TRelGreaterIntExpr = class(TIntegerRelOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;
   TRelGreaterEqualIntExpr = class(TIntegerRelOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;

   TRelIntIsZeroExpr = class(TUnaryOpBoolExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;
   TRelIntIsNotZeroExpr = class(TUnaryOpBoolExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;

   // float rel ops

   TFloatRelOpExpr = class(TRelOpExpr)
     function Optimize(prog : TdwsProgram; exec : TdwsExecution) : TProgramExpr; override;
   end;

   TRelEqualFloatExpr = class(TFloatRelOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;
   TRelNotEqualFloatExpr = class(TFloatRelOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;
   TRelLessFloatExpr = class(TFloatRelOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;
   TRelLessEqualFloatExpr = class(TFloatRelOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;
   TRelGreaterFloatExpr = class(TFloatRelOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;
   TRelGreaterEqualFloatExpr = class(TFloatRelOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;

   // string rel ops

   TRelStringOpExpr = class(TRelOpExpr)
   end;

   TRelEqualStringExpr = class(TRelStringOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;
   TRelNotEqualStringExpr = class(TRelStringOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;
   TRelLessStringExpr = class(TRelStringOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;
   TRelLessEqualStringExpr = class(TRelStringOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;
   TRelGreaterStringExpr = class(TRelStringOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;
   TRelGreaterEqualStringExpr = class(TRelStringOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;

   // variant rel ops

   TRelVariantOpExpr = class(TRelOpExpr)
   end;

   TRelEqualVariantExpr = class(TRelVariantOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;
   TRelNotEqualVariantExpr = class(TRelVariantOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;
   TRelLessVariantExpr = class(TRelVariantOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;
   TRelLessEqualVariantExpr = class(TRelVariantOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;
   TRelGreaterVariantExpr = class(TRelVariantOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;
   TRelGreaterEqualVariantExpr = class(TRelVariantOpExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;

   TRelVarEqualNilExpr = class(TUnaryOpBoolExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;
   TRelVarNotEqualNilExpr = class(TRelVarEqualNilExpr)
     function EvalAsBoolean(exec : TdwsExecution) : Boolean; override;
   end;

   // metaclass rel ops

   TRelEqualMetaExpr = class(TRelEqualIntExpr)
   end;
   TRelNotEqualMetaExpr = class(TRelNotEqualIntExpr)
   end;

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
implementation
// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

// ------------------
// ------------------ TRelOpExpr ------------------
// ------------------

// Create
//
constructor TRelOpExpr.Create(Prog: TdwsProgram; const aScriptPos : TScriptPos; aLeft, aRight : TTypedExpr);
begin
   inherited;
   FTyp:=Prog.TypBoolean;
end;

// EvalAsVariant
//
procedure TRelOpExpr.EvalAsVariant(exec : TdwsExecution; var result : Variant);
begin
   Result:=EvalAsBoolean(exec);
end;

// ------------------
// ------------------ TRelEqualBoolExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelEqualBoolExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
begin
   Result:=(FLeft.EvalAsBoolean(exec)=FRight.EvalAsBoolean(exec));
end;

// ------------------
// ------------------ TRelNotEqualBoolExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelNotEqualBoolExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
begin
   Result:=(FLeft.EvalAsBoolean(exec)<>FRight.EvalAsBoolean(exec));
end;

// ------------------
// ------------------ TRelEqualIntExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelEqualIntExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
begin
   Result:=(FLeft.EvalAsInteger(exec)=FRight.EvalAsInteger(exec));
end;

// Optimize
//
function TRelEqualIntExpr.Optimize(prog : TdwsProgram; exec : TdwsExecution) : TProgramExpr;
begin
   if FLeft.IsConstant and (FLeft.EvalAsInteger(exec)=0) then begin
      Result:=TRelIntIsZeroExpr.Create(prog, FRight);
      FRight:=nil;
      Free;
   end else if FRight.IsConstant and (FRight.EvalAsInteger(exec)=0) then begin
      Result:=TRelIntIsZeroExpr.Create(prog, FLeft);
      FLeft:=nil;
      Free;
   end else Result:=Self;
end;

// ------------------
// ------------------ TRelNotEqualIntExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelNotEqualIntExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
begin
   Result:=(FLeft.EvalAsInteger(exec)<>FRight.EvalAsInteger(exec));
end;

// Optimize
//
function TRelNotEqualIntExpr.Optimize(prog : TdwsProgram; exec : TdwsExecution) : TProgramExpr;
begin
   if FLeft.IsConstant and (FLeft.EvalAsInteger(exec)=0) then begin
      Result:=TRelIntIsNotZeroExpr.Create(prog, FRight);
      FRight:=nil;
      Free;
   end else if FRight.IsConstant and (FRight.EvalAsInteger(exec)=0) then begin
      Result:=TRelIntIsNotZeroExpr.Create(prog, FLeft);
      FLeft:=nil;
      Free;
   end else Result:=Self;
end;

// ------------------
// ------------------ TRelLessIntExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelLessIntExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
begin
   Result:=(FLeft.EvalAsInteger(exec)<FRight.EvalAsInteger(exec));
end;

// ------------------
// ------------------ TRelLessEqualIntExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelLessEqualIntExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
begin
   Result:=(FLeft.EvalAsInteger(exec)<=FRight.EvalAsInteger(exec));
end;

// ------------------
// ------------------ TRelGreaterIntExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelGreaterIntExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
begin
   Result:=(FLeft.EvalAsInteger(exec)>FRight.EvalAsInteger(exec));
end;

// ------------------
// ------------------ TRelGreaterEqualIntExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelGreaterEqualIntExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
begin
   Result:=(FLeft.EvalAsInteger(exec)>=FRight.EvalAsInteger(exec));
end;

// ------------------
// ------------------ TFloatRelOpExpr ------------------
// ------------------

// Optimize
//
function TFloatRelOpExpr.Optimize(prog : TdwsProgram; exec : TdwsExecution) : TProgramExpr;
begin
   OptimizeConstantOperandsToFloats(prog, exec);
   Result:=inherited;
end;

// ------------------
// ------------------ TRelEqualFloatExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelEqualFloatExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
begin
   Result:=(FLeft.EvalAsFloat(exec)=FRight.EvalAsFloat(exec));
end;

// ------------------
// ------------------ TRelNotEqualFloatExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelNotEqualFloatExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
begin
   Result:=(FLeft.EvalAsFloat(exec)<>FRight.EvalAsFloat(exec));
end;

// ------------------
// ------------------ TRelLessFloatExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelLessFloatExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
begin
   Result:=(FLeft.EvalAsFloat(exec)<FRight.EvalAsFloat(exec));
end;

// ------------------
// ------------------ TRelLessEqualFloatExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelLessEqualFloatExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
begin
   Result:=(FLeft.EvalAsFloat(exec)<=FRight.EvalAsFloat(exec));
end;

// ------------------
// ------------------ TRelGreaterFloatExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelGreaterFloatExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
begin
   Result:=(FLeft.EvalAsFloat(exec)>FRight.EvalAsFloat(exec));
end;

// ------------------
// ------------------ TRelGreaterEqualFloatExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelGreaterEqualFloatExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
begin
   Result:=(FLeft.EvalAsFloat(exec)>=FRight.EvalAsFloat(exec));
end;

// ------------------
// ------------------ TRelEqualStringExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelEqualStringExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
var
   a, b : UnicodeString;
begin
   FLeft.EvalAsString(exec, a);
   FRight.EvalAsString(exec, b);
   Result:=(a=b);
end;

// ------------------
// ------------------ TRelNotEqualStringExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelNotEqualStringExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
var
   a, b : UnicodeString;
begin
   FLeft.EvalAsString(exec, a);
   FRight.EvalAsString(exec, b);
   Result:=(a<>b);
end;

// ------------------
// ------------------ TRelLessStringExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelLessStringExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
var
   a, b : UnicodeString;
begin
   FLeft.EvalAsString(exec, a);
   FRight.EvalAsString(exec, b);
   Result:=(a<b);
end;

// ------------------
// ------------------ TRelLessEqualStringExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelLessEqualStringExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
var
   a, b : UnicodeString;
begin
   FLeft.EvalAsString(exec, a);
   FRight.EvalAsString(exec, b);
   Result:=(a<=b);
end;

// ------------------
// ------------------ TRelGreaterStringExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelGreaterStringExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
var
   a, b : UnicodeString;
begin
   FLeft.EvalAsString(exec, a);
   FRight.EvalAsString(exec, b);
   Result:=(a>b);
end;

// ------------------
// ------------------ TRelGreaterEqualStringExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelGreaterEqualStringExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
var
   a, b : UnicodeString;
begin
   FLeft.EvalAsString(exec, a);
   FRight.EvalAsString(exec, b);
   Result:=(a>=b);
end;

// ------------------
// ------------------ TRelEqualVariantExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelEqualVariantExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
var
   lv, rv : Variant;
begin
   FLeft.EvalAsVariant(exec, lv);
   FRight.EvalAsVariant(exec, rv);
   Result:=(lv=rv);
end;

// ------------------
// ------------------ TRelNotEqualVariantExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelNotEqualVariantExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
var
   lv, rv : Variant;
begin
   FLeft.EvalAsVariant(exec, lv);
   FRight.EvalAsVariant(exec, rv);
   Result:=(lv<>rv);
end;

// ------------------
// ------------------ TRelLessVariantExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelLessVariantExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
var
   lv, rv : Variant;
begin
   FLeft.EvalAsVariant(exec, lv);
   FRight.EvalAsVariant(exec, rv);
   Result:=(lv<rv);
end;

// ------------------
// ------------------ TRelLessEqualVariantExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelLessEqualVariantExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
var
   lv, rv : Variant;
begin
   FLeft.EvalAsVariant(exec, lv);
   FRight.EvalAsVariant(exec, rv);
   Result:=(lv<=rv);
end;

// ------------------
// ------------------ TRelGreaterVariantExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelGreaterVariantExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
var
   lv, rv : Variant;
begin
   FLeft.EvalAsVariant(exec, lv);
   FRight.EvalAsVariant(exec, rv);
   Result:=(lv>rv);
end;

// ------------------
// ------------------ TRelGreaterEqualVariantExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelGreaterEqualVariantExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
var
   lv, rv : Variant;
begin
   FLeft.EvalAsVariant(exec, lv);
   FRight.EvalAsVariant(exec, rv);
   Result:=(lv>=rv);
end;

// ------------------
// ------------------ TRelIntIsZeroExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelIntIsZeroExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
begin
   Result:=(Expr.EvalAsInteger(exec)=0);
end;

// ------------------
// ------------------ TRelIntIsNotZeroExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelIntIsNotZeroExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
begin
   Result:=(Expr.EvalAsInteger(exec)<>0);
end;

// ------------------
// ------------------ TRelVarEqualNilExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelVarEqualNilExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
var
   v : Variant;
begin
   FExpr.EvalAsVariant(exec, v);
   case VarType(v) of
      varNull, varEmpty : Result := True;
      varDispatch : Result := (TVarData(v).VDispatch=nil);
   else
      Result := False;
   end;
end;

// ------------------
// ------------------ TRelVarNotEqualNilExpr ------------------
// ------------------

// EvalAsBoolean
//
function TRelVarNotEqualNilExpr.EvalAsBoolean(exec : TdwsExecution) : Boolean;
begin
   Result := not inherited EvalAsBoolean(exec);
end;

end.
