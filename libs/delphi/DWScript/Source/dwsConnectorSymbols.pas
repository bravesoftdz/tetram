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
unit dwsConnectorSymbols;

{$I dws.inc}

interface

uses
   dwsUtils, dwsDataContext, dwsSymbols, dwsExprList, dwsExprs, dwsErrors;

type

   IConnectorType = interface;

   IConnector = interface
      ['{8D534D1A-4C6B-11D5-8DCB-0000216D9E86}']
      function ConnectorCaption: UnicodeString;
      function ConnectorName: UnicodeString;
      function GetUnit(const UnitName: UnicodeString): IConnectorType;
   end;

   TConnectorArgs = array of TData;

   IConnectorCall = interface (IGetSelf)
      ['{F9D86D4E-B48C-4B0A-8CB9-988D46278A19}']
   end;

   IConnectorArgsCall = interface (IConnectorCall)
      ['{8D534D1B-4C6B-11D5-8DCB-0000216D9E86}']
      function Call(const base : Variant; const args : TConnectorArgs) : TData;
      function NeedDirectReference : Boolean;
   end;

   IConnectorFastCall = interface (IConnectorCall)
      ['{64CE8F29-6FC3-4595-BB42-B7FDB84582C2}']
      procedure FastCall(const args : TExprBaseListExec; var result : Variant);
   end;

   IConnectorMember = interface (IGetSelf)
      ['{10BB11D1-557B-4EAC-B9C2-6D45FCB8FAB6}']
   end;

   IConnectorDataMember = interface (IConnectorMember)
      ['{8D534D1C-4C6B-11D5-8DCB-0000216D9E86}']
      function Read(const base : Variant) : TData;
      procedure Write(const base : Variant; const data : TData);
   end;

   IConnectorFastMember = interface (IConnectorMember)
      ['{857F6EE6-347E-45FB-BC49-0557960F8381}']
      procedure FastRead(const exec : TdwsExecution; const base : TExprBase; var result : Variant);
      procedure FastWrite(const exec : TdwsExecution; const base, value : TExprBase);
   end;

   IConnectorEnumerator = interface (IGetSelf)
      ['{13223223-94F0-42FC-89FB-D413DAD670B7}']
      function NewEnumerator(const base : Variant; const args : TConnectorArgs) : IUnknown;
      function Step(const enumerator : IInterface; var data : TData) : Boolean;
   end;

   IConnectorCast = interface (IGetSelf)
      ['{DCFCCC15-585C-4F48-99E1-547628C55696}']
      function CastVariant(const base : Variant) : Variant;
   end;

   TConnectorParam = record
      IsVarParam : Boolean;
      TypSym : TTypeSymbol;
   end;

   TConnectorParamArray = array of TConnectorParam;

   IConnectorType = interface
     ['{8D534D1D-4C6B-11D5-8DCB-0000216D9E86}']
     function ConnectorCaption: UnicodeString;
     function AutoVarParams : Boolean;
     function AcceptsParams(const params: TConnectorParamArray) : Boolean;
     function HasMethod(const MethodName: UnicodeString; const Params: TConnectorParamArray;
                        var TypSym: TTypeSymbol): IConnectorCall;
     function HasMember(const MemberName: UnicodeString; var TypSym: TTypeSymbol; IsWrite: Boolean): IConnectorMember;
     function HasIndex(const PropName: UnicodeString; const Params: TConnectorParamArray;
                       var TypSym: TTypeSymbol; IsWrite: Boolean): IConnectorCall;
     function HasEnumerator(var typSym: TTypeSymbol) : IConnectorEnumerator;
     function HasCast(typSym: TTypeSymbol) : IConnectorCast;
   end;

   TConnectorSymbol = class (TBaseVariantSymbol)
      private
         FConnectorType : IConnectorType;

      protected
         function DoIsOfType(typSym : TTypeSymbol) : Boolean; override;

      public
         constructor Create(const name : UnicodeString; const connectorType : IConnectorType);

         function Specialize(table : TSymbolTable; const qualifier : UnicodeString) : TConnectorSymbol; virtual;
         function CreateAssignExpr(prog : TdwsProgram; const aScriptPos: TScriptPos;
                                   exec : TdwsExecution;
                                   left : TDataExpr; right : TTypedExpr) : TProgramExpr; virtual;


         property ConnectorType : IConnectorType read FConnectorType write FConnectorType;
   end;

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
implementation
// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

uses dwsCoreExprs;

// ------------------
// ------------------ TConnectorSymbol ------------------
// ------------------

// Create
//
constructor TConnectorSymbol.Create(const name : UnicodeString; const connectorType : IConnectorType);
begin
   inherited Create(name);
   FConnectorType:=ConnectorType;
end;

// DoIsOfType
//
function TConnectorSymbol.DoIsOfType(typSym : TTypeSymbol) : Boolean;
begin
   Result:=   (inherited DoIsOfType(typSym))
           or (typSym is TBaseVariantSymbol);
end;

// Specialize
//
function TConnectorSymbol.Specialize(table : TSymbolTable; const qualifier : UnicodeString) : TConnectorSymbol;
begin
   Result:=Self;
end;

// CreateAssignExpr
//
function TConnectorSymbol.CreateAssignExpr(prog : TdwsProgram; const aScriptPos: TScriptPos;
                                           exec : TdwsExecution;
                                           left : TDataExpr; right : TTypedExpr) : TProgramExpr;
begin
   Result:=TAssignExpr.Create(prog, aScriptPos, exec, left, right);
end;

end.
