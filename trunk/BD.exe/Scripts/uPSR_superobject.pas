unit uPSR_superobject;

interface

uses uPSRuntime;

procedure RIRegister_superobject_Routines(S: TPSExec);
procedure RIRegister_TSuperObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSuperEnumerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSuperTokenizer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSuperWriterSock(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSuperWriterFake(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSuperUnicodeWriterStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSuperAnsiWriterStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSuperWriterStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSuperWriterString(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSuperWriter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSuperArray(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSuperAvlIterator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSuperTableString(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSuperAvlTree(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSuperAvlEntry(CL: TPSRuntimeClassImporter);
procedure RIRegister_superobject(CL: TPSRuntimeClassImporter);

implementation

uses Classes, superobject;

// function SA36_P(const Args: array of const ): ISuperObject;
// begin
// Result := ParserU.SA(Args);
// end;

// function SO35_P(const Args: array of const ): ISuperObject;
// begin
// Result := ParserU.SO(Args);
// end;

// function SO34_P(const value: Variant): ISuperObject;
// begin
// Result := ParserU.SO(value);
// end;

// function SO33_P(const S: SOString): ISuperObject;
// begin
// Result := ParserU.SO(S);
// end;

procedure TSuperObjectProcessing_R(Self: TSuperObject; var T: boolean);
begin
  T := Self.Processing;
end;

procedure TSuperObjectDataPtr_W(Self: TSuperObject; const T: Pointer);
begin
  Self.DataPtr := T;
end;

procedure TSuperObjectDataPtr_R(Self: TSuperObject; var T: Pointer);
begin
  T := Self.DataPtr;
end;

procedure TSuperObjectDataType_R(Self: TSuperObject; var T: TSuperType);
begin
  T := Self.DataType;
end;

function TSuperObjectCompare32_P(Self: TSuperObject; const str: SOString): TSuperCompareResult;
begin
  Result := Self.Compare(str);
end;

function TSuperObjectCompare31_P(Self: TSuperObject; const obj: ISuperObject): TSuperCompareResult;
begin
  Result := Self.Compare(obj);
end;

function TSuperObjectValidate30_P(Self: TSuperObject; const rules: ISuperObject; const defs: ISuperObject; callback: TSuperOnValidateError;
  sender: Pointer): boolean;
begin
  Result := Self.Validate(rules, defs, callback, sender);
end;

function TSuperObjectValidate29_P(Self: TSuperObject; const rules: SOString; const defs: SOString; callback: TSuperOnValidateError; sender: Pointer)
  : boolean;
begin
  Result := Self.Validate(rules, defs, callback, sender);
end;

procedure TSuperObjectMerge28_P(Self: TSuperObject; const str: SOString);
begin
  Self.Merge(str);
end;

procedure TSuperObjectMerge27_P(Self: TSuperObject; const obj: ISuperObject; reference: boolean);
begin
  Self.Merge(obj, reference);
end;

function TSuperObjectcall26_P(Self: TSuperObject; const path, param: SOString): ISuperObject;
begin
  Result := Self.call(path, param);
end;

function TSuperObjectcall25_P(Self: TSuperObject; const path: SOString; const param: ISuperObject): ISuperObject;
begin
  Result := Self.call(path, param);
end;

procedure TSuperObjectA_R(Self: TSuperObject; var T: TSuperArray; const t1: SOString);
begin
  T := Self.A[t1];
end;

procedure TSuperObjectM_W(Self: TSuperObject; const T: TSuperMethod; const t1: SOString);
begin
  Self.M[t1] := T;
end;

procedure TSuperObjectM_R(Self: TSuperObject; var T: TSuperMethod; const t1: SOString);
begin
  T := Self.M[t1];
end;

procedure TSuperObjectS_W(Self: TSuperObject; const T: SOString; const t1: SOString);
begin
  Self.S[t1] := T;
end;

procedure TSuperObjectS_R(Self: TSuperObject; var T: SOString; const t1: SOString);
begin
  T := Self.S[t1];
end;

procedure TSuperObjectC_W(Self: TSuperObject; const T: Currency; const t1: SOString);
begin
  Self.C[t1] := T;
end;

procedure TSuperObjectC_R(Self: TSuperObject; var T: Currency; const t1: SOString);
begin
  T := Self.C[t1];
end;

procedure TSuperObjectD_W(Self: TSuperObject; const T: Double; const t1: SOString);
begin
  Self.D[t1] := T;
end;

procedure TSuperObjectD_R(Self: TSuperObject; var T: Double; const t1: SOString);
begin
  T := Self.D[t1];
end;

procedure TSuperObjectI_W(Self: TSuperObject; const T: SuperInt; const t1: SOString);
begin
  Self.I[t1] := T;
end;

procedure TSuperObjectI_R(Self: TSuperObject; var T: SuperInt; const t1: SOString);
begin
  T := Self.I[t1];
end;

procedure TSuperObjectB_W(Self: TSuperObject; const T: boolean; const t1: SOString);
begin
  Self.B[t1] := T;
end;

procedure TSuperObjectB_R(Self: TSuperObject; var T: boolean; const t1: SOString);
begin
  T := Self.B[t1];
end;

procedure TSuperObjectO_W(Self: TSuperObject; const T: ISuperObject; const t1: SOString);
begin
  Self.O[t1] := T;
end;

procedure TSuperObjectO_R(Self: TSuperObject; var T: ISuperObject; const t1: SOString);
begin
  T := Self.O[t1];
end;

procedure TSuperObjectN_W(Self: TSuperObject; const T: ISuperObject; const t1: SOString);
begin
  Self.N[t1] := T;
end;

procedure TSuperObjectN_R(Self: TSuperObject; var T: ISuperObject; const t1: SOString);
begin
  T := Self.N[t1];
end;

function TSuperObjectCreate24_P(Self: TClass; CreateNewInstance: boolean; M: TSuperMethod): TObject;
begin
  Result := TSuperObject.Create(M);
end;

function TSuperObjectCreate23_P(Self: TClass; CreateNewInstance: boolean; const S: SOString): TObject;
begin
  Result := TSuperObject.Create(S);
end;

function TSuperObjectCreateCurrency22_P(Self: TClass; CreateNewInstance: boolean; C: Currency): TObject;
begin
  Result := TSuperObject.CreateCurrency(C);
end;

function TSuperObjectCreate21_P(Self: TClass; CreateNewInstance: boolean; D: Double): TObject;
begin
  Result := TSuperObject.Create(D);
end;

function TSuperObjectCreate20_P(Self: TClass; CreateNewInstance: boolean; I: SuperInt): TObject;
begin
  Result := TSuperObject.Create(I);
end;

function TSuperObjectCreate19_P(Self: TClass; CreateNewInstance: boolean; B: boolean): TObject;
begin
  Result := TSuperObject.Create(B);
end;

function TSuperObjectCreate18_P(Self: TClass; CreateNewInstance: boolean; jt: TSuperType): TObject;
begin
  Result := TSuperObject.Create(jt);
end;

function TSuperObjectSaveTo17_P(Self: TSuperObject; socket: longint; indent: boolean; escape: boolean): integer;
begin
  Result := Self.SaveTo(socket, indent, escape);
end;

function TSuperObjectSaveTo16_P(Self: TSuperObject; const FileName: string; indent: boolean; escape: boolean): integer;
begin
  Result := Self.SaveTo(FileName, indent, escape);
end;

function TSuperObjectSaveTo15_P(Self: TSuperObject; stream: TStream; indent: boolean; escape: boolean): integer;
begin
  Result := Self.SaveTo(stream, indent, escape);
end;

procedure TSuperObjectRefCount_R(Self: TSuperObject; var T: integer);
begin
  T := Self.RefCount;
end;

function ISuperObjectCompare14_P(Self: ISuperObject; const str: SOString): TSuperCompareResult;
begin
  Result := Self.Compare(str);
end;

function ISuperObjectCompare13_P(Self: ISuperObject; const obj: ISuperObject): TSuperCompareResult;
begin
  Result := Self.Compare(obj);
end;

function ISuperObjectValidate12_P(Self: ISuperObject; const rules: ISuperObject; const defs: ISuperObject; callback: TSuperOnValidateError;
  sender: Pointer): boolean;
begin
  Result := Self.Validate(rules, defs, callback, sender);
end;

function ISuperObjectValidate11_P(Self: ISuperObject; const rules: SOString; const defs: SOString; callback: TSuperOnValidateError; sender: Pointer)
  : boolean;
begin
  Result := Self.Validate(rules, defs, callback, sender);
end;

procedure ISuperObjectMerge10_P(Self: ISuperObject; const str: SOString);
begin
  Self.Merge(str);
end;

procedure ISuperObjectMerge9_P(Self: ISuperObject; const obj: ISuperObject; reference: boolean);
begin
  Self.Merge(obj, reference);
end;

function ISuperObjectcall8_P(Self: ISuperObject; const path, param: SOString): ISuperObject;
begin
  Result := Self.call(path, param);
end;

function ISuperObjectcall7_P(Self: ISuperObject; const path: SOString; const param: ISuperObject): ISuperObject;
begin
  Result := Self.call(path, param);
end;

function ISuperObjectSaveTo6_P(Self: ISuperObject; socket: longint; indent: boolean; escape: boolean): integer;
begin
  Result := Self.SaveTo(socket, indent, escape);
end;

function ISuperObjectSaveTo5_P(Self: ISuperObject; const FileName: string; indent: boolean; escape: boolean): integer;
begin
  Result := Self.SaveTo(FileName, indent, escape);
end;

function ISuperObjectSaveTo4_P(Self: ISuperObject; stream: TStream; indent: boolean; escape: boolean): integer;
begin
  Result := Self.SaveTo(stream, indent, escape);
end;

procedure TSuperEnumeratorCurrent_R(Self: TSuperEnumerator; var T: ISuperObject);
begin
  T := Self.Current;
end;

procedure TSuperTokenizercol_W(Self: TSuperTokenizer; const T: integer);
begin
  Self.col := T;
end;

procedure TSuperTokenizercol_R(Self: TSuperTokenizer; var T: integer);
begin
  T := Self.col;
end;

procedure TSuperTokenizerline_W(Self: TSuperTokenizer; const T: integer);
begin
  Self.line := T;
end;

procedure TSuperTokenizerline_R(Self: TSuperTokenizer; var T: integer);
begin
  T := Self.line;
end;

procedure TSuperTokenizerstack_W(Self: TSuperTokenizer; const T: Pointer);
begin
  // Self.stack := T;
end;

procedure TSuperTokenizerstack_R(Self: TSuperTokenizer; var T: Pointer);
begin
  // T := Self.stack;
end;

procedure TSuperTokenizerquote_char_W(Self: TSuperTokenizer; const T: SOChar);
begin
  Self.quote_char := T;
end;

procedure TSuperTokenizerquote_char_R(Self: TSuperTokenizer; var T: SOChar);
begin
  T := Self.quote_char;
end;

procedure TSuperTokenizerucs_char_W(Self: TSuperTokenizer; const T: Word);
begin
  Self.ucs_char := T;
end;

procedure TSuperTokenizerucs_char_R(Self: TSuperTokenizer; var T: Word);
begin
  T := Self.ucs_char;
end;

procedure TSuperTokenizererr_W(Self: TSuperTokenizer; const T: TSuperTokenizerError);
begin
  Self.err := T;
end;

procedure TSuperTokenizererr_R(Self: TSuperTokenizer; var T: TSuperTokenizerError);
begin
  T := Self.err;
end;

procedure TSuperTokenizerchar_offset_W(Self: TSuperTokenizer; const T: integer);
begin
  Self.char_offset := T;
end;

procedure TSuperTokenizerchar_offset_R(Self: TSuperTokenizer; var T: integer);
begin
  T := Self.char_offset;
end;

procedure TSuperTokenizerst_pos_W(Self: TSuperTokenizer; const T: integer);
begin
  Self.st_pos := T;
end;

procedure TSuperTokenizerst_pos_R(Self: TSuperTokenizer; var T: integer);
begin
  T := Self.st_pos;
end;

procedure TSuperTokenizerfloatcount_W(Self: TSuperTokenizer; const T: integer);
begin
  Self.floatcount := T;
end;

procedure TSuperTokenizerfloatcount_R(Self: TSuperTokenizer; var T: integer);
begin
  T := Self.floatcount;
end;

procedure TSuperTokenizeris_double_W(Self: TSuperTokenizer; const T: integer);
begin
  Self.is_double := T;
end;

procedure TSuperTokenizeris_double_R(Self: TSuperTokenizer; var T: integer);
begin
  T := Self.is_double;
end;

procedure TSuperTokenizerdepth_W(Self: TSuperTokenizer; const T: integer);
begin
  Self.depth := T;
end;

procedure TSuperTokenizerdepth_R(Self: TSuperTokenizer; var T: integer);
begin
  T := Self.depth;
end;

procedure TSuperTokenizerpb_W(Self: TSuperTokenizer; const T: TSuperWriterString);
begin
  Self.pb := T;
end;

procedure TSuperTokenizerpb_R(Self: TSuperTokenizer; var T: TSuperWriterString);
begin
  T := Self.pb;
end;

procedure TSuperTokenizerstr_W(Self: TSuperTokenizer; const T: PSOChar);
begin
  Self.str := T;
end;

procedure TSuperTokenizerstr_R(Self: TSuperTokenizer; var T: PSOChar);
begin
  T := Self.str;
end;

procedure TSuperWriterSockSize_R(Self: TSuperWriterSock; var T: integer);
begin
  T := Self.Size;
end;

procedure TSuperWriterSockSocket_R(Self: TSuperWriterSock; var T: longint);
begin
  T := Self.socket;
end;

procedure TSuperWriterFakesize_R(Self: TSuperWriterFake; var T: integer);
begin
  T := Self.Size;
end;

procedure TSuperWriterStringPosition_R(Self: TSuperWriterString; var T: integer);
begin
  T := Self.Position;
end;

procedure TSuperWriterStringSize_R(Self: TSuperWriterString; var T: integer);
begin
  T := Self.Size;
end;

procedure TSuperWriterStringData_R(Self: TSuperWriterString; var T: PSOChar);
begin
  T := Self.Data;
end;

function TSuperWriterStringAppend3_P(Self: TSuperWriterString; buf: PSOChar): integer;
begin
  Result := Self.Append(buf);
end;

function TSuperWriterStringAppend2_P(Self: TSuperWriterString; buf: PSOChar; Size: integer): integer;
begin
  Result := Self.Append(buf, Size);
end;

function TSuperWriterAppend1_P(Self: TSuperWriter; buf: PSOChar): integer;
begin
  Result := Self.Append(buf);
end;

function TSuperWriterAppend0_P(Self: TSuperWriter; buf: PSOChar; Size: integer): integer;
begin
  Result := Self.Append(buf, Size);
end;

procedure TSuperArrayM_W(Self: TSuperArray; const T: TSuperMethod; const t1: integer);
begin
  Self.M[t1] := T;
end;

procedure TSuperArrayM_R(Self: TSuperArray; var T: TSuperMethod; const t1: integer);
begin
  T := Self.M[t1];
end;

procedure TSuperArrayS_W(Self: TSuperArray; const T: SOString; const t1: integer);
begin
  Self.S[t1] := T;
end;

procedure TSuperArrayS_R(Self: TSuperArray; var T: SOString; const t1: integer);
begin
  T := Self.S[t1];
end;

procedure TSuperArrayC_W(Self: TSuperArray; const T: Currency; const t1: integer);
begin
  Self.C[t1] := T;
end;

procedure TSuperArrayC_R(Self: TSuperArray; var T: Currency; const t1: integer);
begin
  T := Self.C[t1];
end;

procedure TSuperArrayD_W(Self: TSuperArray; const T: Double; const t1: integer);
begin
  Self.D[t1] := T;
end;

procedure TSuperArrayD_R(Self: TSuperArray; var T: Double; const t1: integer);
begin
  T := Self.D[t1];
end;

procedure TSuperArrayI_W(Self: TSuperArray; const T: SuperInt; const t1: integer);
begin
  Self.I[t1] := T;
end;

procedure TSuperArrayI_R(Self: TSuperArray; var T: SuperInt; const t1: integer);
begin
  T := Self.I[t1];
end;

procedure TSuperArrayB_W(Self: TSuperArray; const T: boolean; const t1: integer);
begin
  Self.B[t1] := T;
end;

procedure TSuperArrayB_R(Self: TSuperArray; var T: boolean; const t1: integer);
begin
  T := Self.B[t1];
end;

procedure TSuperArrayO_W(Self: TSuperArray; const T: ISuperObject; const t1: integer);
begin
  Self.O[t1] := T;
end;

procedure TSuperArrayO_R(Self: TSuperArray; var T: ISuperObject; const t1: integer);
begin
  T := Self.O[t1];
end;

procedure TSuperArrayN_W(Self: TSuperArray; const T: ISuperObject; const t1: integer);
begin
  Self.N[t1] := T;
end;

procedure TSuperArrayN_R(Self: TSuperArray; var T: ISuperObject; const t1: integer);
begin
  T := Self.N[t1];
end;

procedure TSuperArrayLength_R(Self: TSuperArray; var T: integer);
begin
  T := Self.Length;
end;

procedure TSuperAvlIteratorCurrent_R(Self: TSuperAvlIterator; var T: TSuperAvlEntry);
begin
  T := Self.Current;
end;

procedure TSuperTableStringC_W(Self: TSuperTableString; const T: Currency; const t1: SOString);
begin
  Self.C[t1] := T;
end;

procedure TSuperTableStringC_R(Self: TSuperTableString; var T: Currency; const t1: SOString);
begin
  T := Self.C[t1];
end;

procedure TSuperTableStringN_W(Self: TSuperTableString; const T: ISuperObject; const t1: SOString);
begin
  Self.N[t1] := T;
end;

procedure TSuperTableStringN_R(Self: TSuperTableString; var T: ISuperObject; const t1: SOString);
begin
  T := Self.N[t1];
end;

procedure TSuperTableStringM_W(Self: TSuperTableString; const T: TSuperMethod; const t1: SOString);
begin
  Self.M[t1] := T;
end;

procedure TSuperTableStringM_R(Self: TSuperTableString; var T: TSuperMethod; const t1: SOString);
begin
  T := Self.M[t1];
end;

procedure TSuperTableStringB_W(Self: TSuperTableString; const T: boolean; const t1: SOString);
begin
  Self.B[t1] := T;
end;

procedure TSuperTableStringB_R(Self: TSuperTableString; var T: boolean; const t1: SOString);
begin
  T := Self.B[t1];
end;

procedure TSuperTableStringD_W(Self: TSuperTableString; const T: Double; const t1: SOString);
begin
  Self.D[t1] := T;
end;

procedure TSuperTableStringD_R(Self: TSuperTableString; var T: Double; const t1: SOString);
begin
  T := Self.D[t1];
end;

procedure TSuperTableStringI_W(Self: TSuperTableString; const T: SuperInt; const t1: SOString);
begin
  Self.I[t1] := T;
end;

procedure TSuperTableStringI_R(Self: TSuperTableString; var T: SuperInt; const t1: SOString);
begin
  T := Self.I[t1];
end;

procedure TSuperTableStringS_W(Self: TSuperTableString; const T: SOString; const t1: SOString);
begin
  Self.S[t1] := T;
end;

procedure TSuperTableStringS_R(Self: TSuperTableString; var T: SOString; const t1: SOString);
begin
  T := Self.S[t1];
end;

procedure TSuperTableStringO_W(Self: TSuperTableString; const T: ISuperObject; const t1: SOString);
begin
  Self.O[t1] := T;
end;

procedure TSuperTableStringO_R(Self: TSuperTableString; var T: ISuperObject; const t1: SOString);
begin
  T := Self.O[t1];
end;

procedure TSuperAvlTreecount_R(Self: TSuperAvlTree; var T: integer);
begin
  T := Self.count;
end;

procedure TSuperAvlEntryValue_W(Self: TSuperAvlEntry; const T: ISuperObject);
begin
  Self.value := T;
end;

procedure TSuperAvlEntryValue_R(Self: TSuperAvlEntry; var T: ISuperObject);
begin
  T := Self.value;
end;

procedure TSuperAvlEntryPtr_R(Self: TSuperAvlEntry; var T: Pointer);
begin
  T := Self.Ptr;
end;

procedure TSuperAvlEntryName_R(Self: TSuperAvlEntry; var T: SOString);
begin
  T := Self.name;
end;

procedure RIRegister_superobject_Routines(S: TPSExec);
begin
  // S.RegisterDelphiFunction(@ObjectIsError, 'ObjectIsError', cdRegister);
  S.RegisterDelphiFunction(@ObjectIsType, 'ObjectIsType', cdRegister);
  S.RegisterDelphiFunction(@ObjectGetType, 'ObjectGetType', cdRegister);
  S.RegisterDelphiFunction(@ObjectFindFirst, 'ObjectFindFirst', cdRegister);
  S.RegisterDelphiFunction(@ObjectFindNext, 'ObjectFindNext', cdRegister);
  S.RegisterDelphiFunction(@ObjectFindClose, 'ObjectFindClose', cdRegister);
  S.RegisterDelphiFunction(@SO, 'SO', cdRegister);
  // S.RegisterDelphiFunction(@SO34, 'SO34', cdRegister);
  // S.RegisterDelphiFunction(@SO35, 'SO35', cdRegister);
  // S.RegisterDelphiFunction(@SA36, 'SA36', cdRegister);
  S.RegisterDelphiFunction(@JavaToDelphiDateTime, 'JavaToDelphiDateTime', cdRegister);
  S.RegisterDelphiFunction(@DelphiToJavaDateTime, 'DelphiToJavaDateTime', cdRegister);
  S.RegisterDelphiFunction(@TryObjectToDate, 'TryObjectToDate', cdRegister);
  S.RegisterDelphiFunction(@ISO8601DateToJavaDateTime, 'ISO8601DateToJavaDateTime', cdRegister);
  S.RegisterDelphiFunction(@ISO8601DateToDelphiDateTime, 'ISO8601DateToDelphiDateTime', cdRegister);
  S.RegisterDelphiFunction(@DelphiDateTimeToISO8601Date, 'DelphiDateTimeToISO8601Date', cdRegister);
end;

procedure RIRegister_TSuperObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSuperObject) do
  begin
    RegisterMethod(@TSuperObject.GetEnumerator, 'GetEnumerator');
    RegisterPropertyHelper(@TSuperObjectRefCount_R, nil, 'RefCount');
    RegisterMethod(@TSuperObject.GetProcessing, 'GetProcessing');
    RegisterMethod(@TSuperObject.SetProcessing, 'SetProcessing');
    RegisterMethod(@TSuperObjectSaveTo15_P, 'SaveTo15');
    RegisterMethod(@TSuperObjectSaveTo16_P, 'SaveTo16');
    RegisterMethod(@TSuperObjectSaveTo17_P, 'SaveTo17');
    RegisterMethod(@TSuperObject.CalcSize, 'CalcSize');
    RegisterMethod(@TSuperObject.AsJSon, 'AsJSon');
    RegisterMethod(@TSuperObject.ParseString, 'ParseString');
    RegisterMethod(@TSuperObject.ParseStream, 'ParseStream');
    RegisterMethod(@TSuperObject.ParseFile, 'ParseFile');
    RegisterMethod(@TSuperObject.ParseEx, 'ParseEx');
    RegisterVirtualConstructor(@TSuperObjectCreate18_P, 'Create18');
    RegisterVirtualConstructor(@TSuperObjectCreate19_P, 'Create19');
    RegisterVirtualConstructor(@TSuperObjectCreate20_P, 'Create20');
    RegisterVirtualConstructor(@TSuperObjectCreate21_P, 'Create21');
    RegisterVirtualConstructor(@TSuperObjectCreateCurrency22_P, 'CreateCurrency22');
    RegisterVirtualConstructor(@TSuperObjectCreate23_P, 'Create23');
    RegisterVirtualConstructor(@TSuperObjectCreate24_P, 'Create24');
    RegisterVirtualMethod(@TSuperObject.AsBoolean, 'AsBoolean');
    RegisterVirtualMethod(@TSuperObject.AsInteger, 'AsInteger');
    RegisterVirtualMethod(@TSuperObject.AsDouble, 'AsDouble');
    RegisterVirtualMethod(@TSuperObject.AsCurrency, 'AsCurrency');
    RegisterVirtualMethod(@TSuperObject.AsString, 'AsString');
    RegisterVirtualMethod(@TSuperObject.AsArray, 'AsArray');
    RegisterVirtualMethod(@TSuperObject.AsObject, 'AsObject');
    RegisterVirtualMethod(@TSuperObject.AsMethod, 'AsMethod');
    RegisterVirtualMethod(@TSuperObject.Clear, 'Clear');
    RegisterVirtualMethod(@TSuperObject.Pack, 'Pack');
    RegisterMethod(@TSuperObject.GetN, 'GetN');
    RegisterMethod(@TSuperObject.PutN, 'PutN');
    RegisterMethod(@TSuperObject.ForcePath, 'ForcePath');
    RegisterMethod(@TSuperObject.Format, 'Format');
    RegisterPropertyHelper(@TSuperObjectN_R, @TSuperObjectN_W, 'N');
    RegisterPropertyHelper(@TSuperObjectO_R, @TSuperObjectO_W, 'O');
    RegisterPropertyHelper(@TSuperObjectB_R, @TSuperObjectB_W, 'B');
    RegisterPropertyHelper(@TSuperObjectI_R, @TSuperObjectI_W, 'I');
    RegisterPropertyHelper(@TSuperObjectD_R, @TSuperObjectD_W, 'D');
    RegisterPropertyHelper(@TSuperObjectC_R, @TSuperObjectC_W, 'C');
    RegisterPropertyHelper(@TSuperObjectS_R, @TSuperObjectS_W, 'S');
    RegisterPropertyHelper(@TSuperObjectM_R, @TSuperObjectM_W, 'M');
    RegisterPropertyHelper(@TSuperObjectA_R, nil, 'A');
    RegisterVirtualMethod(@TSuperObjectcall25_P, 'call25');
    RegisterVirtualMethod(@TSuperObjectcall26_P, 'call26');
    RegisterVirtualMethod(@TSuperObject.Clone, 'Clone');
    RegisterMethod(@TSuperObject.Delete, 'Delete');
    RegisterMethod(@TSuperObjectMerge27_P, 'Merge27');
    RegisterMethod(@TSuperObjectMerge28_P, 'Merge28');
    RegisterMethod(@TSuperObjectValidate29_P, 'Validate29');
    RegisterMethod(@TSuperObjectValidate30_P, 'Validate30');
    RegisterMethod(@TSuperObjectCompare31_P, 'Compare31');
    RegisterMethod(@TSuperObjectCompare32_P, 'Compare32');
    RegisterMethod(@TSuperObject.IsType, 'IsType');
    RegisterPropertyHelper(@TSuperObjectDataType_R, nil, 'DataType');
    RegisterPropertyHelper(@TSuperObjectDataPtr_R, @TSuperObjectDataPtr_W, 'DataPtr');
    RegisterPropertyHelper(@TSuperObjectProcessing_R, nil, 'Processing');
  end;
end;

procedure RIRegister_TSuperEnumerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSuperEnumerator) do
  begin
    RegisterVirtualConstructor(@TSuperEnumerator.Create, 'Create');
    RegisterMethod(@TSuperEnumerator.MoveNext, 'MoveNext');
    RegisterMethod(@TSuperEnumerator.GetCurrent, 'GetCurrent');
    RegisterPropertyHelper(@TSuperEnumeratorCurrent_R, nil, 'Current');
  end;
end;

procedure RIRegister_TSuperTokenizer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSuperTokenizer) do
  begin
    RegisterPropertyHelper(@TSuperTokenizerstr_R, @TSuperTokenizerstr_W, 'str');
    RegisterPropertyHelper(@TSuperTokenizerpb_R, @TSuperTokenizerpb_W, 'pb');
    RegisterPropertyHelper(@TSuperTokenizerdepth_R, @TSuperTokenizerdepth_W, 'depth');
    RegisterPropertyHelper(@TSuperTokenizeris_double_R, @TSuperTokenizeris_double_W, 'is_double');
    RegisterPropertyHelper(@TSuperTokenizerfloatcount_R, @TSuperTokenizerfloatcount_W, 'floatcount');
    RegisterPropertyHelper(@TSuperTokenizerst_pos_R, @TSuperTokenizerst_pos_W, 'st_pos');
    RegisterPropertyHelper(@TSuperTokenizerchar_offset_R, @TSuperTokenizerchar_offset_W, 'char_offset');
    RegisterPropertyHelper(@TSuperTokenizererr_R, @TSuperTokenizererr_W, 'err');
    RegisterPropertyHelper(@TSuperTokenizerucs_char_R, @TSuperTokenizerucs_char_W, 'ucs_char');
    RegisterPropertyHelper(@TSuperTokenizerquote_char_R, @TSuperTokenizerquote_char_W, 'quote_char');
    RegisterPropertyHelper(@TSuperTokenizerstack_R, @TSuperTokenizerstack_W, 'stack');
    RegisterPropertyHelper(@TSuperTokenizerline_R, @TSuperTokenizerline_W, 'line');
    RegisterPropertyHelper(@TSuperTokenizercol_R, @TSuperTokenizercol_W, 'col');
    RegisterVirtualConstructor(@TSuperTokenizer.Create, 'Create');
    RegisterMethod(@TSuperTokenizer.ResetLevel, 'ResetLevel');
    RegisterMethod(@TSuperTokenizer.Reset, 'Reset');
  end;
end;

procedure RIRegister_TSuperWriterSock(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSuperWriterSock) do
  begin
    RegisterVirtualConstructor(@TSuperWriterSock.Create, 'Create');
    RegisterPropertyHelper(@TSuperWriterSockSocket_R, nil, 'Socket');
    RegisterPropertyHelper(@TSuperWriterSockSize_R, nil, 'Size');
  end;
end;

procedure RIRegister_TSuperWriterFake(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSuperWriterFake) do
  begin
    RegisterVirtualConstructor(@TSuperWriterFake.Create, 'Create');
    RegisterPropertyHelper(@TSuperWriterFakesize_R, nil, 'size');
  end;
end;

procedure RIRegister_TSuperUnicodeWriterStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSuperUnicodeWriterStream) do
  begin
  end;
end;

procedure RIRegister_TSuperAnsiWriterStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSuperAnsiWriterStream) do
  begin
  end;
end;

procedure RIRegister_TSuperWriterStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSuperWriterStream) do
  begin
    RegisterVirtualConstructor(@TSuperWriterStream.Create, 'Create');
  end;
end;

procedure RIRegister_TSuperWriterString(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSuperWriterString) do
  begin
    RegisterMethod(@TSuperWriterString.TrimRight, 'TrimRight');
    RegisterVirtualConstructor(@TSuperWriterString.Create, 'Create');
    RegisterMethod(@TSuperWriterString.GetString, 'GetString');
    RegisterPropertyHelper(@TSuperWriterStringData_R, nil, 'Data');
    RegisterPropertyHelper(@TSuperWriterStringSize_R, nil, 'Size');
    RegisterPropertyHelper(@TSuperWriterStringPosition_R, nil, 'Position');
  end;
end;

procedure RIRegister_TSuperWriter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSuperWriter) do
  begin
    // RegisterVirtualAbstractMethod(@TSuperWriter, @!.Append0, 'Append0');
    // RegisterVirtualAbstractMethod(@TSuperWriter, @!.Append1, 'Append1');
    // RegisterVirtualAbstractMethod(@TSuperWriter, @!.Reset, 'Reset');
  end;
end;

procedure RIRegister_TSuperArray(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSuperArray) do
  begin
    RegisterVirtualConstructor(@TSuperArray.Create, 'Create');
    RegisterMethod(@TSuperArray.Add, 'Add');
    RegisterMethod(@TSuperArray.Delete, 'Delete');
    RegisterMethod(@TSuperArray.Insert, 'Insert');
    RegisterMethod(@TSuperArray.Clear, 'Clear');
    RegisterMethod(@TSuperArray.Pack, 'Pack');
    RegisterPropertyHelper(@TSuperArrayLength_R, nil, 'Length');
    RegisterPropertyHelper(@TSuperArrayN_R, @TSuperArrayN_W, 'N');
    RegisterPropertyHelper(@TSuperArrayO_R, @TSuperArrayO_W, 'O');
    RegisterPropertyHelper(@TSuperArrayB_R, @TSuperArrayB_W, 'B');
    RegisterPropertyHelper(@TSuperArrayI_R, @TSuperArrayI_W, 'I');
    RegisterPropertyHelper(@TSuperArrayD_R, @TSuperArrayD_W, 'D');
    RegisterPropertyHelper(@TSuperArrayC_R, @TSuperArrayC_W, 'C');
    RegisterPropertyHelper(@TSuperArrayS_R, @TSuperArrayS_W, 'S');
    RegisterPropertyHelper(@TSuperArrayM_R, @TSuperArrayM_W, 'M');
  end;
end;

procedure RIRegister_TSuperAvlIterator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSuperAvlIterator) do
  begin
    RegisterVirtualConstructor(@TSuperAvlIterator.Create, 'Create');
    RegisterMethod(@TSuperAvlIterator.Search, 'Search');
    RegisterMethod(@TSuperAvlIterator.First, 'First');
    RegisterMethod(@TSuperAvlIterator.Last, 'Last');
    RegisterMethod(@TSuperAvlIterator.GetIter, 'GetIter');
    RegisterMethod(@TSuperAvlIterator.Next, 'Next');
    RegisterMethod(@TSuperAvlIterator.Prior, 'Prior');
    RegisterMethod(@TSuperAvlIterator.MoveNext, 'MoveNext');
    RegisterPropertyHelper(@TSuperAvlIteratorCurrent_R, nil, 'Current');
  end;
end;

procedure RIRegister_TSuperTableString(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSuperTableString) do
  begin
    RegisterPropertyHelper(@TSuperTableStringO_R, @TSuperTableStringO_W, 'O');
    RegisterPropertyHelper(@TSuperTableStringS_R, @TSuperTableStringS_W, 'S');
    RegisterPropertyHelper(@TSuperTableStringI_R, @TSuperTableStringI_W, 'I');
    RegisterPropertyHelper(@TSuperTableStringD_R, @TSuperTableStringD_W, 'D');
    RegisterPropertyHelper(@TSuperTableStringB_R, @TSuperTableStringB_W, 'B');
    RegisterPropertyHelper(@TSuperTableStringM_R, @TSuperTableStringM_W, 'M');
    RegisterPropertyHelper(@TSuperTableStringN_R, @TSuperTableStringN_W, 'N');
    RegisterPropertyHelper(@TSuperTableStringC_R, @TSuperTableStringC_W, 'C');
    RegisterMethod(@TSuperTableString.GetValues, 'GetValues');
    RegisterMethod(@TSuperTableString.GetNames, 'GetNames');
    RegisterMethod(@TSuperTableString.Find, 'Find');
  end;
end;

procedure RIRegister_TSuperAvlTree(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSuperAvlTree) do
  begin
    RegisterVirtualConstructor(@TSuperAvlTree.Create, 'Create');
    RegisterMethod(@TSuperAvlTree.IsEmpty, 'IsEmpty');
    RegisterVirtualMethod(@TSuperAvlTree.Clear, 'Clear');
    RegisterMethod(@TSuperAvlTree.Pack, 'Pack');
    RegisterMethod(@TSuperAvlTree.Delete, 'Delete');
    RegisterMethod(@TSuperAvlTree.GetEnumerator, 'GetEnumerator');
    RegisterPropertyHelper(@TSuperAvlTreecount_R, nil, 'count');
  end;
end;

procedure RIRegister_TSuperAvlEntry(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSuperAvlEntry) do
  begin
    RegisterVirtualMethod(@TSuperAvlEntry.Hash, 'Hash');
    RegisterVirtualConstructor(@TSuperAvlEntry.Create, 'Create');
    RegisterPropertyHelper(@TSuperAvlEntryName_R, nil, 'Name');
    RegisterPropertyHelper(@TSuperAvlEntryPtr_R, nil, 'Ptr');
    RegisterPropertyHelper(@TSuperAvlEntryValue_R, @TSuperAvlEntryValue_W, 'Value');
  end;
end;

procedure RIRegister_superobject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSuperObject) do
    with CL.Add(TSuperArray) do
      with CL.Add(TSuperAvlIterator) do
        RIRegister_TSuperAvlEntry(CL);

  RIRegister_TSuperAvlTree(CL);
  RIRegister_TSuperTableString(CL);
  RIRegister_TSuperAvlIterator(CL);
  RIRegister_TSuperArray(CL);
  // RIRegister_TSuperWriter(CL);
  // RIRegister_TSuperWriterString(CL);
  // RIRegister_TSuperWriterStream(CL);
  // RIRegister_TSuperAnsiWriterStream(CL);
  // RIRegister_TSuperUnicodeWriterStream(CL);
  // RIRegister_TSuperWriterFake(CL);
  // RIRegister_TSuperWriterSock(CL);
  // RIRegister_TSuperTokenizer(CL);
  RIRegister_TSuperEnumerator(CL);
  // RIRegister_TSuperObject(CL);
end;

end.
