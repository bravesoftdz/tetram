unit Commun;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  SysUtils, Windows, Dialogs, Classes, UIB, Controls, StrUtils;

const
  GUID_FULL: TGUID = '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}';
  sGUID_FULL = '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}';
  GUID_NULL: TGUID = '{00000000-0000-0000-0000-000000000000}';
  sGUID_NULL = '{00000000-0000-0000-0000-000000000000}';

function IIf(Test: Boolean; const BackTrue, BackFalse: string): string; overload; inline;
function IIf(Test: Boolean; BackTrue, BackFalse: Integer): Integer; overload; inline;

procedure AjoutString(var Chaine: string; const Ajout, Espace: string; const Avant: string = ''; const Apres: string = ''); overload; inline;
procedure AjoutString(var Chaine: WideString; const Ajout, Espace: WideString; const Avant: WideString = ''; const Apres: WideString = ''); overload; inline;
procedure AjoutString(var Chaine: AnsiString; const Ajout, Espace: AnsiString; const Avant: AnsiString = ''; const Apres: AnsiString = ''); overload; inline;

function StringToGUIDDef(const GUID: string; const Default: TGUID): TGUID; inline;

function NonZero(const S: string): string; inline;

function VerifieEAN(var Valeur: string): Boolean;
function VerifieISBN(var Valeur: string; LongueurISBN: Integer = 10): Boolean;
function FormatISBN(const Code: string): string;
function ClearISBN(const Code: string): string;

function FormatTitre(const Titre: string): string; inline;
function FormatTitreAlbum(Simple, AvecSerie: Boolean; const Titre, Serie: string; Tome, TomeDebut, TomeFin: Integer; Integrale, HorsSerie: Boolean): string;

function GetTransaction(Database: TUIBDataBase): TUIBTransaction; inline;

type
  IHourGlass = interface
  end;

  THourGlass = class(TInterfacedObject, IHourGlass)
  private
    FOldCursor: TCursor;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  Forms, CommonConst;

function StringToGUIDDef(const GUID: string; const Default: TGUID): TGUID;
begin
  try
    Result := StringToGUID(GUID);
  except
    Result := Default;
  end;
end;

procedure AjoutString(var Chaine: AnsiString; const Ajout, Espace: AnsiString; const Avant: AnsiString = ''; const Apres: AnsiString = '');
var
  s: AnsiString;
begin
  s := Ajout;
  if (Ajout <> '') then
  begin
    s := Avant + Ajout + Apres;
    if (Chaine <> '') then Chaine := Chaine + Espace;
  end;
  Chaine := Chaine + s;
end;

procedure AjoutString(var Chaine: string; const Ajout, Espace: string; const Avant: string = ''; const Apres: string = '');
var
  s: string;
begin
  s := Ajout;
  if (Ajout <> '') then
  begin
    s := Avant + Ajout + Apres;
    if (Chaine <> '') then Chaine := Chaine + Espace;
  end;
  Chaine := Chaine + s;
end;

procedure AjoutString(var Chaine: WideString; const Ajout, Espace: WideString; const Avant: WideString = ''; const Apres: WideString = '');
var
  s: string;
begin
  s := Ajout;
  if (Ajout <> '') then
  begin
    s := Avant + Ajout + Apres;
    if (Chaine <> '') then Chaine := Chaine + Espace;
  end;
  Chaine := Chaine + s;
end;

function NonZero(const S: string): string;
begin
  Result := s;
  if Trim(s) = '0' then Result := '';
end;

function IIf(Test: Boolean; const BackTrue, BackFalse: string): string;
begin
  if Test then
    Result := BackTrue
  else
    Result := BackFalse;
end;

function IIf(Test: Boolean; BackTrue, BackFalse: Integer): Integer;
begin
  if Test then
    Result := BackTrue
  else
    Result := BackFalse;
end;

function VerifieEAN(var Valeur: string): Boolean;
var
  i, fak, sum: Integer;
  tmp: string;
begin
  sum := 0;
  tmp := Copy(Valeur + '0000000000000', 1, 12);
  fak := Length(tmp);
  for i := 1 to Length(tmp) do
  begin
    if (fak mod 2) = 0 then
      sum := sum + (StrToInt(tmp[i]) * 1)
    else
      sum := sum + (StrToInt(tmp[i]) * 3);
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
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(Code) do
    if CharInSet(Code[i], ['0'..'9', 'X', 'x']) then Result := Result + UpCase(Code[i]);
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
      //    M := StrToInt(tmp[Length(tmp)]);
    end;

    if LongueurISBN = 13 then
      Result := VerifieEAN(tmp)
    else
    begin
      C := 0;
      for X := 1 to Pred(Length(tmp)) do
        //    C := C + StrToInt(tmp[X]) * X;
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

function FormatISBN(const Code: string): string;
var
  s, CleanCode: string;
  l: integer;
begin
  CleanCode := Copy(ClearISBN(Code), 1, 13); // une fois nettoyé, le code ne peut contenir que 13 caractères
  s := CleanCode;
  if Length(s) > 10 then s := Copy(CleanCode, 4, 10); // ISBN13 = 3 premiers car de l'isbn13 + '-' + ISBN
  if Length(s) < 10 then Exit;

  l := -1;
  case StrToInt(s[1]) of
    0, 3, 4, 5: // codes anglophones
      case StrToInt(Copy(s, 2, 2)) of
        00..19: l := 2;
        20..69: l := 3;
        70..84: l := 4;
        85..89: l := 5;
        90..94: l := 6;
        95..99: l := 7;
      end;
    2: // codes francophones
      case StrToInt(Copy(s, 2, 2)) of
        01..19: l := 2;
        20..34, 40..69: l := 3;
        70..83: l := 4;
        84..89, 35..39: l := 5;
        90..94: l := 6;
        95..99: l := 7;
      end;
    1:
      case StrToInt(Copy(s, 2, 6)) of
        550000..869799: l := 5;
        869800..926429: l := 6;
      end;
    7:
      case StrToInt(Copy(s, 2, 2)) of
        00..09: l := 2;
        10..49: l := 3;
        50..79: l := 4;
        80..89: l := 5;
        90..99: l := 6;
      end;
    8:
      case StrToInt(Copy(s, 2, 1)) of
        1, 3, 4, 5, 8:
          case StrToInt(Copy(s, 3, 2)) of
            00..19: l := 2;
            20..69: l := 3;
            70..84: l := 4;
            85..89: l := 5;
            90..99: l := 6;
          end;
      end;
    9:
      case StrToInt(Copy(s, 2, 1)) of
        0:
          case StrToInt(Copy(s, 3, 2)) of
            00..19: l := 3;
            20..49: l := 4;
            50..69: l := 5;
            70..79: l := 6;
            80..89: l := 7;
          end;
        2:
          case StrToInt(Copy(s, 3, 2)) of
            00..05: l := 2;
            06..07: l := 3;
            80..89: l := 4;
            90..99: l := 5;
          end;
      end;
  end;

  if l = -1 then Exit;
  Result := Format('%s-%s-%s-%s', [Copy(s, 1, 1), Copy(s, 2, l), Copy(s, 2 + l, 8 - l), Copy(s, 10, 1)]);
  if Length(CleanCode) > 10 then
    Result := Copy(CleanCode, 1, 3) + '-' + Result;
end;

function FormatTitre(const Titre: string): string;
var
  i, j: Integer;
  Dummy: string;
begin
  Result := Titre;
  try
    i := Pos('[', Titre);
    if i > 0 then
    begin
      j := PosEx(']', Titre, i);
      if j = 0 then Exit;
      Dummy := Copy(Titre, i + 1, j - i - 1);
      if Length(Dummy) > 0 then
        if Dummy[Length(Dummy)] <> '''' then Dummy := Dummy + ' ';
      Result := Dummy + Copy(Titre, 1, i - 1) + Copy(Titre, j + 1, Length(Titre));
    end;
  finally
    Result := Trim(Result);
  end;
end;

function FormatTitreAlbum(Simple, AvecSerie: Boolean; const Titre, Serie: string; Tome, TomeDebut, TomeFin: Integer; Integrale, HorsSerie: Boolean): string;
const
  resTome: array[False..True] of string = ('T. ', 'Tome ');
  resHS: array[False..True] of string = ('HS', 'Hors-série');
  resIntegrale: array[False..True] of string = ('INT.', 'Intégrale');
var
  sSerie, sAlbum, s2, sTome: string;
begin
  sAlbum := Titre;
  if not Simple then sAlbum := FormatTitre(sAlbum);

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

  case TGlobalVar.Utilisateur.Options.FormatTitreAlbum of
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

  if Result = '' then Result := '<Sans titre>';
end;

{ THourGlass }

constructor THourGlass.Create;
begin
  inherited;
  FOldCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
end;

destructor THourGlass.Destroy;
begin
  Screen.Cursor := FOldCursor;
  inherited;
end;

function GetTransaction(Database: TUIBDataBase): TUIBTransaction;
begin
  Result := TUIBTransaction.Create(nil);
  Result.DataBase := Database;
end;

end.

