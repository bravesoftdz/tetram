unit BD.Utils.StrUtils;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  System.SysUtils, Winapi.Windows, VCL.Dialogs, System.Classes, VCL.Controls, System.StrUtils;

type
  RGUIDEx = record
  private
    GUID: TGUID;
  public
    class operator Implicit(a: RGUIDEx): TGUID;
    class operator Implicit(a: RGUIDEx): string;
    class operator Implicit(a: TGUID): RGUIDEx;
    class operator Implicit(a: string): RGUIDEx;
  end;

const
  GUID_FULL: TGUID = '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}';
  sGUID_FULL = '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}';
  GUID_NULL: TGUID = '{00000000-0000-0000-0000-000000000000}';
  sGUID_NULL = '{00000000-0000-0000-0000-000000000000}';

procedure AjoutString(var Chaine: string; const Ajout, Espace: string; const Avant: string = ''; const Apres: string = ''); overload; inline;
procedure AjoutString(var Chaine: WideString; const Ajout, Espace: WideString; const Avant: WideString = ''; const Apres: WideString = ''); overload; inline;
procedure AjoutString(var Chaine: AnsiString; const Ajout, Espace: AnsiString; const Avant: AnsiString = ''; const Apres: AnsiString = ''); overload; inline;

function StringToGUIDDef(const GUID: string; const Default: TGUID): TGUID; inline;

function NonZero(const S: string): string; inline; overload;
function NonZero(const I: Integer): string; inline; overload;

function VerifieEAN(var Valeur: string): Boolean;
function VerifieISBN(var Valeur: string; LongueurISBN: Integer = 10): Boolean;
function FormatISBN(isbn: string): string;
function ClearISBN(const Code: string): string;

function FormatTitre(const Titre: string): string; inline;
function FormatTitreAlbum(Simple, AvecSerie: Boolean; const Titre, Serie: string; Tome, TomeDebut, TomeFin: Integer; Integrale, HorsSerie: Boolean): string;
function PrepareTitre(Titre: string): string;

function BDCurrencyToStr(const Value: Double): string;
function BDDoubleToStr(const Value: Double): string;
function BDStrToDouble(const Value: string): Double;
function BDStrToDoubleDef(const Value: string; const Default: Double): Double;

implementation

uses
  VCL.Forms, BD.Common, System.Generics.Collections, JclSimpleXML, System.Math, ICUNumberFormatter, _uloc, icu_globals;

function StringToGUIDDef(const GUID: string; const Default: TGUID): TGUID;
begin
  try
    if GUID.Trim.IsEmpty then
      Exit(Default);
    Result := StringToGUID(GUID);
  except
    Result := Default;
  end;
end;

procedure AjoutString(var Chaine: AnsiString; const Ajout, Espace: AnsiString; const Avant: AnsiString = ''; const Apres: AnsiString = '');
var
  S: AnsiString;
begin
  S := Ajout;
  if (Ajout <> '') then
  begin
    S := Avant + Ajout + Apres;
    if (Chaine <> '') then
      Chaine := Chaine + Espace;
  end;
  Chaine := Chaine + S;
end;

procedure AjoutString(var Chaine: string; const Ajout, Espace: string; const Avant: string = ''; const Apres: string = '');
var
  S: string;
begin
  S := Ajout;
  if (Ajout <> '') then
  begin
    S := Avant + Ajout + Apres;
    if (Chaine <> '') then
      Chaine := Chaine + Espace;
  end;
  Chaine := Chaine + S;
end;

procedure AjoutString(var Chaine: WideString; const Ajout, Espace: WideString; const Avant: WideString = ''; const Apres: WideString = '');
var
  S: WideString;
begin
  S := Ajout;
  if (Ajout <> '') then
  begin
    S := Avant + Ajout + Apres;
    if (Chaine <> '') then
      Chaine := Chaine + Espace;
  end;
  Chaine := Chaine + S;
end;

function NonZero(const S: string): string;
begin
  Result := S;
  if Trim(S) = '0' then
    Result := '';
end;

function NonZero(const I: Integer): string;
begin
  Result := '';
  if I <> 0 then
    Result := IntToStr(I);
end;

function VerifieEAN(var Valeur: string): Boolean;
var
  I, fak, sum: Integer;
  tmp: string;
begin
  sum := 0;
  tmp := Copy(Valeur + '0000000000000', 1, 12);
  fak := Length(tmp);
  for I := 1 to Length(tmp) do
  begin
    if (fak mod 2) = 0 then
      sum := sum + (StrToInt(tmp[I]) * 1)
    else
      sum := sum + (StrToInt(tmp[I]) * 3);
    Dec(fak);
  end;
  if (sum mod 10) = 0 then
    tmp := tmp + '0'
  else
    tmp := tmp + IntToStr(10 - (sum mod 10));
  Result := Valeur = tmp;
  Valeur := tmp;
end;

function ClearISBN(const Code: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(Code) do
    if CharInSet(Code[I], ['0' .. '9', 'X', 'x']) then
      Result := Result + UpCase(Code[I]);
end;

function VerifieISBN(var Valeur: string; LongueurISBN: Integer = 10): Boolean;
var
  X, M, C, v: Integer;
  tmp: string;
begin
  tmp := ClearISBN(Valeur);
  Result := True;
  if tmp <> '' then
  begin
    if tmp[Length(tmp)] = 'X' then
    begin
      while Length(tmp) < LongueurISBN do
        Insert('0', tmp, Length(tmp) - 1);
      M := 10;
    end
    else
    begin
      while Length(tmp) < LongueurISBN do
        tmp := tmp + '0';
      M := Ord(tmp[Length(tmp)]) - Ord('0');
      // M := StrToInt(tmp[Length(tmp)]);
    end;

    if LongueurISBN = 13 then
      Result := VerifieEAN(tmp)
    else
    begin
      C := 0;
      for X := 1 to Pred(Length(tmp)) do
        // C := C + StrToInt(tmp[X]) * X;
        C := C + (Ord(tmp[X]) - Ord('0')) * X;
      v := C mod 11;
      Result := v = M;

      if v = 10 then
        tmp[Length(tmp)] := 'X'
      else
        tmp[Length(tmp)] := IntToStr(v)[1];
    end;
  end;
  Valeur := tmp;
end;

type
  TISBNRule = class
    valueLower, valueUpper, Length: Integer;
    constructor Create(valueLower, valueUpper, Length: Integer);
  end;

  { ISBNRule }

constructor TISBNRule.Create(valueLower, valueUpper, Length: Integer);
begin
  Self.valueLower := valueLower;
  Self.valueUpper := valueUpper;
  Self.Length := Length;
end;

var
  isbnPrefixes: TDictionary < string, TList < TISBNRule >> = nil;
  isbnGroups: TDictionary < string, TList < TISBNRule >> = nil;

procedure DecodeISBNRules;

  function LoadNode(Node: TJclSimpleXMLElem; const ListNodeName: string): TDictionary<string, TList<TISBNRule>>;
  var
    xmlPrefix, xmlRule: TJclSimpleXMLElem;
    p: Integer;
    prefix, range: string;
    rule: TISBNRule;
    list: TList<TISBNRule>;
  begin
    Result := TObjectDictionary < string, TList < TISBNRule >>.Create([doOwnsValues]);

    for xmlPrefix in Node.Items do
      if SameText(xmlPrefix.Name, ListNodeName) then
      begin
        prefix := xmlPrefix.Items.ItemNamed['prefix'].Value;
        for xmlRule in xmlPrefix.Items.ItemNamed['Rules'].Items do
        begin
          range := xmlRule.Items.ItemNamed['range'].Value;
          p := range.IndexOf('-');

          if not Result.TryGetValue(prefix, list) then
          begin
            list := TObjectList<TISBNRule>.Create(True);
            Result.Add(prefix, list);
          end;
          rule := TISBNRule.Create(range.Substring(0, p).ToInteger, range.Substring(p + 1).ToInteger, xmlRule.Items.ItemNamed['length'].IntValue);
          list.Add(rule);
        end;
      end;
  end;

var
  xml: TJclSimpleXML;
begin
  if (isbnPrefixes <> nil) then
    Exit;

  xml := TJclSimpleXML.Create;
  try
    xml.LoadFromResourceName(HInstance, 'ISBN_RANGES');

    isbnPrefixes := LoadNode(xml.Root.Items.ItemNamed['EAN.UCCPrefixes'], 'EAN.UCC');
    isbnGroups := LoadNode(xml.Root.Items.ItemNamed['RegistrationGroups'], 'Group');
  finally
    xml.Free;
  end;
end;

function getLengthForPrefix(map: TDictionary<String, TList<TISBNRule>>; const prefix: String; Value, Default: Integer): Integer;
var
  rules: TList<TISBNRule>;
  rule: TISBNRule;
begin
  if (not map.TryGetValue(prefix, rules)) or (rules.Count = 0) then
    Exit(Default);

  for rule in rules do
    if (rule.valueLower <= Value) and (rule.valueUpper >= Value) then
      Exit(rule.Length);

  Exit(Default);
end;

function FormatISBN(isbn: string): string;
var
  S: string;
  groupSize, publisherSize: Integer;
  prefix, group, publisher, s1: string;
begin
  isbn := ClearISBN(isbn);
  isbn := isbn.ToUpper.Substring(0, System.Math.Min(isbn.Length, 13));
  S := isbn;
  if (S.Length > 10) then
  begin
    prefix := S.Substring(0, 3);
    S := S.Substring(3, System.Math.Min(S.Length, 13));
  end
  else
    prefix := '978';

  if (S.Length < 10) then
    Exit(isbn);

  DecodeISBNRules;

  s1 := S.Substring(0, 7);
  groupSize := getLengthForPrefix(isbnPrefixes, prefix, s1.ToInteger, 1);
  group := S.Substring(0, groupSize);

  s1 := S.Substring(groupSize, 7);
  publisherSize := getLengthForPrefix(isbnGroups, prefix + '-' + group, s1.ToInteger, 2);
  publisher := S.Substring(groupSize, publisherSize);

  Result := '';
  if (isbn.Length > 10) then
  begin
    Result := Result + prefix;
    Result := Result + '-';
  end;
  Result := Result + group;
  Result := Result + '-';
  Result := Result + publisher;
  Result := Result + '-';
  Result := Result + S.Substring(groupSize + publisherSize, 9 - groupSize - publisherSize);
  Result := Result + '-';
  Result := Result + S.Substring(S.Length - 1, 1);
end;

function FormatTitre(const Titre: string): string;
var
  I, j: Integer;
  Dummy: string;
begin
  Result := Titre;
  try
    I := Pos('[', Titre);
    if I > 0 then
    begin
      j := PosEx(']', Titre, I);
      if j = 0 then
        Exit;
      Dummy := Copy(Titre, I + 1, j - I - 1);
      if Length(Dummy) > 0 then
        if Dummy[Length(Dummy)] <> '''' then
          Dummy := Dummy + ' ';
      Result := Dummy + Copy(Titre, 1, I - 1) + Copy(Titre, j + 1, Length(Titre));
    end;
  finally
    Result := Trim(Result);
  end;
end;

function FormatTitreAlbum(Simple, AvecSerie: Boolean; const Titre, Serie: string; Tome, TomeDebut, TomeFin: Integer; Integrale, HorsSerie: Boolean): string;
const
  resTome: array [False .. True] of string = ('T. ', 'Tome ');
  resHS: array [False .. True] of string = ('HS', 'Hors-série');
  resIntegrale: array [False .. True] of string = ('INT.', 'Intégrale');
var
  sSerie, sAlbum, s2, sTome: string;
begin
  sAlbum := Titre;
  if not Simple then
    sAlbum := FormatTitre(sAlbum);

  sSerie := '';
  if AvecSerie then
    if sAlbum = '' then
      sAlbum := FormatTitre(Serie)
    else
      sSerie := FormatTitre(Serie);

  sTome := '';
  if Integrale then
  begin
    s2 := NonZero(IntToStr(TomeDebut));
    AjoutString(s2, NonZero(IntToStr(TomeFin)), ' à ');
    AjoutString(sTome, resIntegrale[sAlbum = ''], ' - ', '', TrimRight(' ' + NonZero(IntToStr(Tome))));
    AjoutString(sTome, s2, ' ', '[', ']');
  end
  else if HorsSerie then
    AjoutString(sTome, resHS[sAlbum = ''], ' - ', '', TrimRight(' ' + NonZero(IntToStr(Tome))))
  else
    AjoutString(sTome, NonZero(IntToStr(Tome)), ' - ', resTome[sAlbum = '']);

  case TGlobalVar.Options.FormatTitreAlbum of
    0: // Album (Serie - Tome)
      begin
        AjoutString(sSerie, sTome, ' - ');
        if sAlbum = '' then
          Result := sSerie
        else
        begin
          AjoutString(sAlbum, sSerie, ' ', '(', ')');
          Result := sAlbum;
        end;
      end;
    1: // Tome - Album (Serie)
      begin
        if sAlbum = '' then
          sAlbum := sSerie
        else
          AjoutString(sAlbum, sSerie, ' ', '(', ')');
        AjoutString(sTome, sAlbum, ' - ');
        Result := sTome;
      end;
  end;

  if Result = '' then
    Result := '<Sans titre>';
end;

function PrepareTitre(Titre: string): string;
var
  pEspace, pApostrophe: Integer;
  PremierMot: string;
  i: Integer;
begin
  Titre := Titre.Trim;
  Result := Titre;
  if Result.IsEmpty or Result.EndsWith(']') then
    Exit;

  pEspace := Result.IndexOf(' ');
  pApostrophe := Result.IndexOf('''');
  if (pApostrophe > -1) and ((pEspace = -1) or (pApostrophe < pEspace)) then
    pEspace := pApostrophe + 1; // + 1 pour prendre l'apostrophe dans le mot
  if pEspace = -1 then
    Exit;
  PremierMot := Result.Substring(0, pEspace);
  if TArray.BinarySearch(['l''', 'un', 'une', 'des', 'le', 'la', 'les'], PremierMot.ToLowerInvariant, i) then
    Result := Result.Substring(pEspace).Trim + ' [' + PremierMot + ']';
end;

{ RGUIDEx }

class operator RGUIDEx.Implicit(a: RGUIDEx): string;
begin
  Result := GUIDToString(a);
end;

class operator RGUIDEx.Implicit(a: RGUIDEx): TGUID;
begin
  Result := a.GUID;
end;

class operator RGUIDEx.Implicit(a: string): RGUIDEx;
begin
  Result := StringToGUID(a);
end;

class operator RGUIDEx.Implicit(a: TGUID): RGUIDEx;
begin
  Result.GUID := a;
end;

function BDCurrencyToStr(const Value: Double): string;
begin
  Result := ICUCurrencyToStr(Value, uloc_getDefault, TGlobalVar.Options.SymboleMonnetaire);
end;

function BDDoubleToStr(const Value: Double): string;
begin
  Result := ICUDoubleToStr(Value, uloc_getDefault);
end;

function BDStrToDouble(const Value: string): Double;
begin
  Result := ICUStrToDouble(StringReplace(Value, TGlobalVar.Options.SymboleMonnetaire, '', []), uloc_getDefault);
end;

function BDStrToDoubleDef(const Value: string; const Default: Double): Double;
begin
  Result := ICUStrToDoubleDef(StringReplace(Value, TGlobalVar.Options.SymboleMonnetaire, '', []), Default, uloc_getDefault);
end;

initialization

LoadICU;

finalization

isbnPrefixes.Free;
isbnGroups.Free;

end.
