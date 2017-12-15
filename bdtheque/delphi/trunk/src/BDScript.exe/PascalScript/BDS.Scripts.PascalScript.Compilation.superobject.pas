unit BDS.Scripts.PascalScript.Compilation.superobject;

interface

uses uPSCompiler;

procedure SIRegister_ISuperObject(CL: TPSPascalCompiler);
// procedure SIRegister_TSuperEnumerator(CL: TPSPascalCompiler);
// procedure SIRegister_TSuperTokenizer(CL: TPSPascalCompiler);
// procedure SIRegister_TSuperWriterSock(CL: TPSPascalCompiler);
// procedure SIRegister_TSuperWriterFake(CL: TPSPascalCompiler);
// procedure SIRegister_TSuperUnicodeWriterStream(CL: TPSPascalCompiler);
// procedure SIRegister_TSuperAnsiWriterStream(CL: TPSPascalCompiler);
// procedure SIRegister_TSuperWriterStream(CL: TPSPascalCompiler);
// procedure SIRegister_TSuperWriterString(CL: TPSPascalCompiler);
// procedure SIRegister_TSuperWriter(CL: TPSPascalCompiler);
// procedure SIRegister_TSuperArray(CL: TPSPascalCompiler);
// procedure SIRegister_TSuperAvlIterator(CL: TPSPascalCompiler);
// procedure SIRegister_TSuperTableString(CL: TPSPascalCompiler);
// procedure SIRegister_TSuperAvlTree(CL: TPSPascalCompiler);
// procedure SIRegister_TSuperAvlEntry(CL: TPSPascalCompiler);
procedure SIRegister_superobject(CL: TPSPascalCompiler);

implementation

uses Sysutils, superobject, uPSUtils;

procedure SIRegister_ISuperObject(CL: TPSPascalCompiler);
begin
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'), ISuperObject, 'ISuperObject') do
  begin
    RegisterMethod('Function GetEnumerator : TSuperEnumerator', cdRegister);
    RegisterMethod('Function GetDataType : TSuperType', cdRegister);
    RegisterMethod('Function GetProcessing : boolean', cdRegister);
    RegisterMethod('Procedure SetProcessing( value : boolean)', cdRegister);
    RegisterMethod('Function ForcePath( const path : SOString; dataType : TSuperType) : ISuperObject', cdRegister);
    RegisterMethod('Function Format( const str : SOString; BeginSep : SOChar; EndSep : SOChar) : SOString', cdRegister);
    RegisterMethod('Function GetO( const path : SOString) : ISuperObject', cdRegister);
    RegisterMethod('Procedure PutO( const path : SOString; const Value : ISuperObject)', cdRegister);
    RegisterMethod('Function GetB( const path : SOString) : Boolean', cdRegister);
    RegisterMethod('Procedure PutB( const path : SOString; Value : Boolean)', cdRegister);
    RegisterMethod('Function GetI( const path : SOString) : SuperInt', cdRegister);
    RegisterMethod('Procedure PutI( const path : SOString; Value : SuperInt)', cdRegister);
    RegisterMethod('Function GetD( const path : SOString) : Double', cdRegister);
    RegisterMethod('Procedure PutC( const path : SOString; Value : Currency)', cdRegister);
    RegisterMethod('Function GetC( const path : SOString) : Currency', cdRegister);
    RegisterMethod('Procedure PutD( const path : SOString; Value : Double)', cdRegister);
    RegisterMethod('Function GetS( const path : SOString) : SOString', cdRegister);
    RegisterMethod('Procedure PutS( const path : SOString; const Value : SOString)', cdRegister);
    RegisterMethod('Function GetM( const path : SOString) : TSuperMethod', cdRegister);
    RegisterMethod('Procedure PutM( const path : SOString; Value : TSuperMethod)', cdRegister);
    RegisterMethod('Function GetA( const path : SOString) : TSuperArray', cdRegister);
    RegisterMethod('Function GetN( const path : SOString) : ISuperObject', cdRegister);
    RegisterMethod('Procedure PutN( const path : SOString; const Value : ISuperObject)', cdRegister);
    RegisterMethod('Function Write( writer : TSuperWriter; indent : boolean; escape : boolean; level : integer) : Integer', cdRegister);
    RegisterMethod('Function SaveTo4( stream : TStream; indent : boolean; escape : boolean) : integer;', cdRegister);
    RegisterMethod('Function SaveTo5( const FileName : string; indent : boolean; escape : boolean) : integer;', cdRegister);
    RegisterMethod('Function SaveTo6( socket : longint; indent : boolean; escape : boolean) : integer;', cdRegister);
    RegisterMethod('Function CalcSize( indent : boolean; escape : boolean) : integer', cdRegister);
    RegisterMethod('Function AsBoolean : Boolean', cdRegister);
    RegisterMethod('Function AsInteger : SuperInt', cdRegister);
    RegisterMethod('Function AsDouble : Double', cdRegister);
    RegisterMethod('Function AsCurrency : Currency', cdRegister);
    RegisterMethod('Function AsString : SOString', cdRegister);
    RegisterMethod('Function AsArray : TSuperArray', cdRegister);
    RegisterMethod('Function AsObject : TSuperTableString', cdRegister);
    RegisterMethod('Function AsMethod : TSuperMethod', cdRegister);
    RegisterMethod('Function AsJSon( indent : boolean; escape : boolean) : SOString', cdRegister);
    RegisterMethod('Procedure Clear( all : boolean)', cdRegister);
    RegisterMethod('Procedure Pack( all : boolean)', cdRegister);
    RegisterMethod('Function call7( const path : SOString; const param : ISuperObject) : ISuperObject;', cdRegister);
    RegisterMethod('Function call8( const path, param : SOString) : ISuperObject;', cdRegister);
    RegisterMethod('Function Clone : ISuperObject', cdRegister);
    RegisterMethod('Function Delete( const path : SOString) : ISuperObject', cdRegister);
    RegisterMethod('Procedure Merge9( const obj : ISuperObject; reference : boolean);', cdRegister);
    RegisterMethod('Procedure Merge10( const str : SOString);', cdRegister);
    RegisterMethod(
      'Function Validate11( const rules : SOString; const defs : SOString; callback : TSuperOnValidateError; sender : Pointer) : boolean;',
      cdRegister);
    RegisterMethod(
      'Function Validate12( const rules : ISuperObject; const defs : ISuperObject; callback : TSuperOnValidateError; sender : Pointer) : boolean;',
      cdRegister);
    RegisterMethod('Function Compare13( const obj : ISuperObject) : TSuperCompareResult;', cdRegister);
    RegisterMethod('Function Compare14( const str : SOString) : TSuperCompareResult;', cdRegister);
    RegisterMethod('Function IsType( AType : TSuperType) : boolean', cdRegister);
    RegisterMethod('Function GetDataPtr : Pointer', cdRegister);
    RegisterMethod('Procedure SetDataPtr( const Value : Pointer)', cdRegister);
  end;
end;

procedure SIRegister_TSuperEnumerator(CL: TPSPascalCompiler);
begin
  with CL.AddClass(CL.FindClass('TOBJECT'), TSuperEnumerator) do
  begin
    RegisterPublishedProperties;
    RegisterMethod('Constructor Create( const obj : ISuperObject)');
    RegisterMethod('Function MoveNext : Boolean');
    RegisterMethod('Function GetCurrent : ISuperObject');
    RegisterProperty('Current', 'ISuperObject', iptr);
  end;
end;

procedure SIRegister_TSuperTokenizer(CL: TPSPascalCompiler);
begin
  with CL.AddClass(CL.FindClass('TOBJECT'), TSuperTokenizer) do
  begin
    RegisterPublishedProperties;
    RegisterProperty('str', 'PSOChar', iptrw);
    RegisterProperty('pb', 'TSuperWriterString', iptrw);
    RegisterProperty('depth', 'Integer', iptrw);
    RegisterProperty('is_double', 'Integer', iptrw);
    RegisterProperty('floatcount', 'Integer', iptrw);
    RegisterProperty('st_pos', 'Integer', iptrw);
    RegisterProperty('char_offset', 'Integer', iptrw);
    RegisterProperty('err', 'TSuperTokenizerError', iptrw);
    RegisterProperty('ucs_char', 'Word', iptrw);
    RegisterProperty('quote_char', 'SOChar', iptrw);
    RegisterProperty('stack', '', iptrw);
    RegisterProperty('line', 'Integer', iptrw);
    RegisterProperty('col', 'Integer', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure ResetLevel( adepth : integer)');
    RegisterMethod('Procedure Reset');
  end;
end;

procedure SIRegister_TSuperWriterSock(CL: TPSPascalCompiler);
begin
  with CL.AddClass(CL.FindClass('TSuperWriter'), TSuperWriterSock) do
  begin
    RegisterPublishedProperties;
    RegisterMethod('Constructor Create( ASocket : longint)');
    RegisterProperty('Socket', 'longint', iptr);
    RegisterProperty('Size', 'Integer', iptr);
  end;
end;

procedure SIRegister_TSuperWriterFake(CL: TPSPascalCompiler);
begin
  with CL.AddClass(CL.FindClass('TSuperWriter'), TSuperWriterFake) do
  begin
    RegisterPublishedProperties;
    RegisterMethod('Constructor Create');
    RegisterProperty('size', 'integer', iptr);
  end;
end;

procedure SIRegister_TSuperUnicodeWriterStream(CL: TPSPascalCompiler);
begin
  with CL.AddClass(CL.FindClass('TSuperWriterStream'), TSuperUnicodeWriterStream) do
  begin
    RegisterPublishedProperties;
  end;
end;

procedure SIRegister_TSuperAnsiWriterStream(CL: TPSPascalCompiler);
begin
  with CL.AddClass(CL.FindClass('TSuperWriterStream'), TSuperAnsiWriterStream) do
  begin
    RegisterPublishedProperties;
  end;
end;

procedure SIRegister_TSuperWriterStream(CL: TPSPascalCompiler);
begin
  with CL.AddClass(CL.FindClass('TSuperWriter'), TSuperWriterStream) do
  begin
    RegisterPublishedProperties;
    RegisterMethod('Constructor Create( AStream : TStream)');
  end;
end;

procedure SIRegister_TSuperWriterString(CL: TPSPascalCompiler);
begin
  with CL.AddClass(CL.FindClass('TSuperWriter'), TSuperWriterString) do
  begin
    RegisterPublishedProperties;
    RegisterMethod('Procedure TrimRight');
    RegisterMethod('Constructor Create');
    RegisterMethod('Function GetString : SOString');
    RegisterProperty('Data', 'PSOChar', iptr);
    RegisterProperty('Size', 'Integer', iptr);
    RegisterProperty('Position', 'integer', iptr);
  end;
end;

procedure SIRegister_TSuperWriter(CL: TPSPascalCompiler);
begin
  with CL.AddClass(CL.FindClass('TOBJECT'), TSuperWriter) do
  begin
    RegisterPublishedProperties;
    RegisterMethod('Function Append0( buf : PSOChar; Size : Integer) : Integer;');
    RegisterMethod('Function Append1( buf : PSOChar) : Integer;');
    RegisterMethod('Procedure Reset');
  end;
end;

procedure SIRegister_TSuperArray(CL: TPSPascalCompiler);
begin
  with CL.AddClass(CL.FindClass('TOBJECT'), TSuperArray) do
  begin
    RegisterPublishedProperties;
    RegisterMethod('Constructor Create');
    RegisterMethod('Function Add( const Data : ISuperObject) : Integer');
    RegisterMethod('Function Delete( index : Integer) : ISuperObject');
    RegisterMethod('Procedure Insert( index : Integer; const value : ISuperObject)');
    RegisterMethod('Procedure Clear( all : boolean)');
    RegisterMethod('Procedure Pack( all : boolean)');
    RegisterProperty('Length', 'Integer', iptr);
    RegisterProperty('N', 'ISuperObject integer', iptrw);
    RegisterProperty('O', 'ISuperObject integer', iptrw);
    SetDefaultPropery('O');
    RegisterProperty('B', 'boolean integer', iptrw);
    RegisterProperty('I', 'SuperInt integer', iptrw);
    RegisterProperty('D', 'Double integer', iptrw);
    RegisterProperty('C', 'Currency integer', iptrw);
    RegisterProperty('S', 'SOString integer', iptrw);
    RegisterProperty('M', 'TSuperMethod integer', iptrw);
  end;
end;

procedure SIRegister_TSuperAvlIterator(CL: TPSPascalCompiler);
begin
  with CL.AddClass(CL.FindClass('TOBJECT'), TSuperAvlIterator) do
  begin
    RegisterPublishedProperties;
    RegisterMethod('Constructor Create( tree : TSuperAvlTree)');
    RegisterMethod('Procedure Search( const k : SOString; st : TSuperAvlSearchTypes)');
    RegisterMethod('Procedure First');
    RegisterMethod('Procedure Last');
    RegisterMethod('Function GetIter : TSuperAvlEntry');
    RegisterMethod('Procedure Next');
    RegisterMethod('Procedure Prior');
    RegisterMethod('Function MoveNext : Boolean');
    RegisterProperty('Current', 'TSuperAvlEntry', iptr);
  end;
end;

procedure SIRegister_TSuperTableString(CL: TPSPascalCompiler);
begin
  with CL.AddClass(CL.FindClass('TSuperAvlTree'), TSuperTableString) do
  begin
    RegisterPublishedProperties;
    RegisterProperty('O', 'ISuperObject SOString', iptrw);
    SetDefaultPropery('O');
    RegisterProperty('S', 'SOString SOString', iptrw);
    RegisterProperty('I', 'SuperInt SOString', iptrw);
    RegisterProperty('D', 'Double SOString', iptrw);
    RegisterProperty('B', 'Boolean SOString', iptrw);
    RegisterProperty('M', 'TSuperMethod SOString', iptrw);
    RegisterProperty('N', 'ISuperObject SOString', iptrw);
    RegisterProperty('C', 'Currency SOString', iptrw);
    RegisterMethod('Function GetValues : ISuperObject');
    RegisterMethod('Function GetNames : ISuperObject');
    RegisterMethod('Function Find( const k : SOString; var value : ISuperObject) : Boolean');
  end;
end;

procedure SIRegister_TSuperAvlTree(CL: TPSPascalCompiler);
begin
  with CL.AddClass(CL.FindClass('TOBJECT'), TSuperAvlTree) do
  begin
    RegisterPublishedProperties;
    RegisterMethod('Constructor Create');
    RegisterMethod('Function IsEmpty : boolean');
    RegisterMethod('Procedure Clear( all : boolean)');
    RegisterMethod('Procedure Pack( all : boolean)');
    RegisterMethod('Function Delete( const k : SOString) : ISuperObject');
    RegisterMethod('Function GetEnumerator : TSuperAvlIterator');
    RegisterProperty('count', 'Integer', iptr);
  end;
end;

procedure SIRegister_TSuperAvlEntry(CL: TPSPascalCompiler);
begin
  with CL.AddClass(CL.FindClass('TOBJECT'), TSuperAvlEntry) do
  begin
    RegisterPublishedProperties;
    RegisterMethod('Function Hash( const k : SOString) : Cardinal');
    RegisterMethod('Constructor Create( const AName : SOString; Obj : Pointer)');
    RegisterProperty('Name', 'SOString', iptr);
    RegisterProperty('Ptr', 'Pointer', iptr);
    RegisterProperty('Value', 'ISuperObject', iptrw);
  end;
end;

procedure SIRegister_superobject(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('PtrInt', 'longint');
  CL.AddTypeS('PtrUInt', 'Longword');
  CL.AddTypeS('SuperInt', 'Int64');
  CL.AddTypeS('SOChar', 'Char');
  CL.AddTypeS('SOIChar', 'Word');
  CL.AddTypeS('PSOChar', 'PChar');
  CL.AddTypeS('SOString', 'string');
  // PascalScript ne connait pas cette syntaxe
  // CL.AddTypeS('TSuperMethod', 'procedure(const This, Params: ISuperObject; var Result: ISuperObject)');
  CL.AddTypeS('TSuperMethod', 'PtrInt');
  // CL.AddConstantN('SUPER_ARRAY_LIST_DEFAULT_SIZE', 'LongInt').SetInt(SUPER_ARRAY_LIST_DEFAULT_SIZE);
  // CL.AddConstantN('SUPER_TOKENER_MAX_DEPTH', 'LongInt').SetInt(SUPER_TOKENER_MAX_DEPTH);
  // CL.AddConstantN('SUPER_AVL_MAX_DEPTH', 'LongInt').SetInt(SUPER_AVL_MAX_DEPTH);
  // CL.AddConstantN('SUPER_AVL_MASK_HIGH_BIT', 'LongInt').SetInt(SUPER_AVL_MASK_HIGH_BIT);
  CL.AddClass(CL.FindClass('TOBJECT'), TSuperObject);
  CL.AddInterface(CL.FindInterface('IUNKNOWN'), ISuperObject, 'ISuperObject');
  // CL.AddTypeS('TSuperAvlBitArray', 'set of Integer');
  CL.AddTypeS('TSuperAvlSearchType', '( stEQual, stLess, stGreater )');
  CL.AddTypeS('TSuperAvlSearchTypes', 'set of TSuperAvlSearchType');
  SIRegister_TSuperAvlEntry(CL);
  SIRegister_TSuperAvlTree(CL);
  SIRegister_TSuperTableString(CL);
  SIRegister_TSuperAvlIterator(CL);
  // CL.AddTypeS('PSuperObjectArray', '^TSuperObjectArray // will not work');
  SIRegister_TSuperArray(CL);
  // SIRegister_TSuperWriter(CL);
  // SIRegister_TSuperWriterString(CL);
  // SIRegister_TSuperWriterStream(CL);
  // SIRegister_TSuperAnsiWriterStream(CL);
  // SIRegister_TSuperUnicodeWriterStream(CL);
  // SIRegister_TSuperWriterFake(CL);
  // SIRegister_TSuperWriterSock(CL);
  // CL.AddTypeS('TSuperTokenizerError', '( teSuccess, teContinue, teDepth, tePars' +
  // 'eEof, teParseUnexpected, teParseNull, teParseBoolean, teParseNumber, tePar' +
  // 'seArray, teParseObjectKeyName, teParseObjectKeySep, teParseObjectValueSep,' +
  // ' teParseString, teParseComment, teEvalObject, teEvalArray, teEvalMethod, t' + 'eEvalInt )');
  // CL.AddTypeS('TSuperTokenerState', '( tsEatws, tsStart, tsFinish, tsNull, tsCo' +
  // 'mmentStart, tsComment, tsCommentEol, tsCommentEnd, tsString, tsStringEscap' +
  // 'e, tsIdentifier, tsEscapeUnicode, tsEscapeHexadecimal, tsBoolean, tsNumber' +
  // ', tsArray, tsArrayAdd, tsArraySep, tsObjectFieldStart, tsObjectField, tsOb' +
  // 'jectUnquotedField, tsObjectFieldEnd, tsObjectValue, tsObjectValueAdd, tsOb' +
  // 'jectSep, tsEvalProperty, tsEvalArray, tsEvalMethod, tsParamValue, tsParamP' + 'ut, tsMethodValue, tsMethodPut )');
  // CL.AddTypeS('PSuperTokenerSrec', '^TSuperTokenerSrec // will not work');
  // CL.AddTypeS('TSuperTokenerSrec', 'record state : TSuperTokenerState; saved_st' +
  // 'ate : TSuperTokenerState; obj : ISuperObject; current : ISuperObject; fiel' +
  // 'd_name : SOString; parent : ISuperObject; gparent : ISuperObject; end');
  // SIRegister_TSuperTokenizer(CL);
  CL.AddTypeS('TSuperType', '( stNull, stBoolean, stDouble, stCurrency, stInt, stObject, stArray, stString, stMethod )');
  // CL.AddTypeS('TSuperValidateError', '( veRuleMalformated, veFieldIsRequired, v' +
  // 'eInvalidDataType, veFieldNotFound, veUnexpectedField, veDuplicateEntry, ve' + 'ValueNotInEnum, veInvalidLength, veInvalidRange )');
  // CL.AddTypeS('TSuperFindOption', '( foCreatePath, foPutValue, foDelete, foCall' + 'Method )');
  // CL.AddTypeS('TSuperFindOptions', 'set of TSuperFindOption');
  // CL.AddTypeS('TSuperCompareResult', '( cpLess, cpEqu, cpGreat, cpError )');
  SIRegister_TSuperEnumerator(CL);
  SIRegister_ISuperObject(CL);

  CL.AddTypeS('TSuperObjectIter', 'record key : SOString; val : ISuperObject; Ite : TSuperAvlIterator; end');
  // CL.AddDelphiFunction('Function ObjectIsError( obj : TSuperObject) : boolean');
  CL.AddDelphiFunction('Function ObjectIsType( const obj : ISuperObject; typ : TSuperType) : boolean');
  CL.AddDelphiFunction('Function ObjectGetType( const obj : ISuperObject) : TSuperType');
  CL.AddDelphiFunction('Function ObjectFindFirst( const obj : ISuperObject; var F : TSuperObjectIter) : boolean');
  CL.AddDelphiFunction('Function ObjectFindNext( var F : TSuperObjectIter) : boolean');
  CL.AddDelphiFunction('Procedure ObjectFindClose( var F : TSuperObjectIter)');
  CL.AddDelphiFunction('function SO( const s : SOString) : ISuperObject;');
  // CL.AddDelphiFunction('Function SO34( const value : Variant) : ISuperObject;');
  // CL.AddDelphiFunction('Function SO35( const Args : array of const) : ISuperObject;');
  // CL.AddDelphiFunction('Function SA36( const Args : array of const) : ISuperObject;');
  CL.AddDelphiFunction('Function JavaToDelphiDateTime( const dt : int64) : TDateTime');
  CL.AddDelphiFunction('Function DelphiToJavaDateTime( const dt : TDateTime) : int64');
  CL.AddDelphiFunction('Function TryObjectToDate( const obj : ISuperObject; var dt : TDateTime) : Boolean');
  CL.AddDelphiFunction('Function ISO8601DateToJavaDateTime( const str : SOString; var ms : Int64) : Boolean');
  CL.AddDelphiFunction('Function ISO8601DateToDelphiDateTime( const str : SOString; var dt : TDateTime) : Boolean');
  CL.AddDelphiFunction('Function DelphiDateTimeToISO8601Date( dt : TDateTime) : SOString');
end;

end.
