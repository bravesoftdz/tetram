unit UScriptsFonctions;

interface

uses Windows, SysUtils, Classes, Dialogs, WinInet, StrUtils, Math, UMetadata, TypeRec, Generics.Collections, UNet, jpeg;

type
  TScriptChoix = class

  type
    TChoix = class
      FLibelle, FCommentaire, FData: string;
      FImage: TJPEGImage;

      constructor Create;
      destructor Destroy; override;
    end;

  type
    TCategorie = class
      FNom: string;
      Choix: TObjectList<TChoix>;

      constructor Create;
      destructor Destroy; override;
    end;

  strict private
    FList: TObjectList<TCategorie>;
    FTitre: string;
    function GetCategorie(const name: string): TCategorie;
  public
    constructor Create;
    destructor Destroy; override;

    procedure ResetList;
    procedure AjoutChoix(const Categorie, Libelle, Commentaire, Data: string);
    procedure AjoutChoixWithThumb(const Categorie, Libelle, Commentaire, Data, URL: string);
    function Show: string;

    function CategorieCount: Integer;
    function ChoixCount: Integer;
    function CategorieChoixCount(const name: string): Integer;

    property Categorie[const name: string]: TCategorie read GetCategorie;
    property Titre: string read FTitre write FTitre;
  end;

function GetPage(const URL: string; UTF8: Boolean = True): string;
function GetPageWithHeaders(const URL: string; UTF8: Boolean = True): string;
function PostPage(const URL: string; const Pieces: array of RAttachement; UTF8: Boolean = True): string;
function PostPageWithHeaders(const URL: string; const Pieces: array of RAttachement; UTF8: Boolean = True): string;
function findInfo(const sDebut, sFin, sChaine, sDefault: string): string;
function MakeAuteur(const Nom: string; Metier: TMetierAuteur): TAuteur;
function AskSearchEntry(const Labels: array of string; var Search: string; var index: Integer): Boolean;
procedure Split(SL: TStringList; const Chaine: string; Sep: Char);
function CombineURL(const Root, URL: string): string;
function ScriptStrToFloatDef(const S: string; const default: Extended): Extended;

function ScriptChangeFileExt(const FileName, Extension: string): string;
function ScriptChangeFilePath(const FileName, Path: string): string;
function ScriptExtractFilePath(const FileName: string): string;
function ScriptExtractFileDir(const FileName: string): string;
function ScriptExtractFileName(const FileName: string): string;
function ScriptExtractFileExt(const FileName: string): string;
function ScriptIncludeTrailingPathDelimiter(const S: string): string;
function ScriptExcludeTrailingPathDelimiter(const S: string): string;

function DateTimeToRFC822(T: TDateTime): string;
function TryRFC822ToDateTime(const S: string; out Value: TDateTime): Boolean;
function RFC822ToDateTime(const S: string): TDateTime;
function RFC822ToDateTimeDef(const S: string; default: TDateTime): TDateTime;

implementation

uses ProceduresBDtk, UBdtForms, EditLabeled, StdCtrls, Controls, Forms, UframBoutons, UfrmScriptChoix, OverbyteIcsHttpProt, CommonConst, Procedures,
  SysConst, Graphics;

const
  PathDelim = '/';
  DriveDelim = '';

constructor TScriptChoix.Create;
begin
  inherited;
  FTitre := 'Choisir parmi ces éléments';
  FList := TObjectList<TCategorie>.Create(True);
end;

destructor TScriptChoix.Destroy;
begin
  FList.Free;
  inherited;
end;

procedure TScriptChoix.AjoutChoixWithThumb(const Categorie, Libelle, Commentaire, Data, URL: string);
var
  Stream: TFileStream;
  P: PChar;
  tmpFile, docType: string;
  LoadImage: Boolean;
  Choix: TChoix;
  ms: TStream;
begin
  Choix := TChoix.Create;
  GetCategorie(Categorie).Choix.Add(Choix);
  Choix.FLibelle := Libelle;
  Choix.FCommentaire := Commentaire;
  Choix.FData := Data;

  if URL <> '' then
    try
      SetLength(tmpFile, MAX_PATH + 1);
      ZeroMemory(@tmpFile[1], Length(tmpFile) * SizeOf(Char));
      GetTempFileName(PChar(TempPath), 'bdk', 0, @tmpFile[1]);
      P := @tmpFile[1];
      while P^ <> #0 do
        Inc(P);
      SetLength(tmpFile, (Integer(P) - Integer(@tmpFile[1])) div SizeOf(Char));

      Stream := TFileStream.Create(tmpFile, fmOpenReadWrite, fmShareExclusive);
      try
        try
          LoadImage := LoadStreamURL(URL, [], Stream, docType) = 200;
        finally
          Stream.Free;
        end;

        if LoadImage then
        begin
          ms := GetCouvertureStream(tmpFile, 70, 70, TGlobalVar.Utilisateur.Options.AntiAliasing);
          if Assigned(ms) then
            try
              Choix.FImage := TJPEGImage.Create;
              try
                Choix.FImage.LoadFromStream(ms);
              except
                FreeAndNil(Choix.FImage);
              end;
            finally
              FreeAndNil(ms);
            end;
        end;
      finally
        DeleteFile(tmpFile);
      end;
    except
      //
    end;
end;

procedure TScriptChoix.AjoutChoix(const Categorie, Libelle, Commentaire, Data: string);
begin
  AjoutChoixWithThumb(Categorie, Libelle, Commentaire, Data, '');
end;

function TScriptChoix.CategorieCount: Integer;
begin
  Result := FList.Count;
end;

function TScriptChoix.CategorieChoixCount(const name: string): Integer;
var
  Categorie: TCategorie;
begin
  Categorie := GetCategorie(name);
  if Assigned(Categorie) then
    Result := Categorie.Choix.Count
  else
    Result := 0;
end;

function TScriptChoix.ChoixCount: Integer;
var
  Categorie: TCategorie;
begin
  Result := 0;
  for Categorie in FList do
    Inc(Result, Categorie.Choix.Count);
end;

function TScriptChoix.GetCategorie(const name: string): TCategorie;
begin
  for Result in FList do
    if SameText(Result.FNom, name) then
      Exit;

  Result := TCategorie.Create;
  FList.Add(Result);
  Result.FNom := name;
end;

procedure TScriptChoix.ResetList;
begin
  FList.Clear;
end;

function TScriptChoix.Show: string;
begin
  Result := '';
  if FList.Count = 0 then
    Exit;

  with TfrmScriptChoix.Create(nil) do
    try
      Caption := FTitre;
      SetList(Self.FList);
      if ShowModal <> mrOk then
        Exit;
      Result := FList[VirtualStringTree1.GetFirstSelected.Parent.index].Choix[VirtualStringTree1.GetFirstSelected.index].FData;
    finally
      Free;
    end;
end;

constructor TScriptChoix.TChoix.Create;
begin
  inherited;
  FImage := nil;
end;

destructor TScriptChoix.TChoix.Destroy;
begin
  FImage.Free;
  inherited;
end;

constructor TScriptChoix.TCategorie.Create;
begin
  inherited;
  Choix := TObjectList<TChoix>.Create(True);
end;

destructor TScriptChoix.TCategorie.Destroy;
begin
  Choix.Free;
  inherited;
end;

function findInfo(const sDebut, sFin, sChaine, sDefault: string): string;
var
  iDebut, iFin: Integer;
begin
  Result := sDefault;
  if sDebut = '' then
    iDebut := 1
  else
    iDebut := Pos(sDebut, sChaine);
  if iDebut > 0 then
  begin
    Inc(iDebut, Length(sDebut));
    if sFin = '' then
      iFin := Length(sChaine)
    else
      iFin := PosEx(sFin, sChaine, iDebut);
    if iFin = 0 then
      iFin := Length(sChaine);
    Result := Copy(sChaine, iDebut, iFin - iDebut);
  end;
end;

function _PostPage(const URL: string; const Pieces: array of RAttachement; UTF8, IncludeHeaders: Boolean): string;
var
  ss: TStringStream;
begin
  if UTF8 then
    ss := TStringStream.Create('', TEncoding.UTF8)
  else
    ss := TStringStream.Create('', TEncoding.default);
  try
    if LoadStreamURL(URL, Pieces, ss, True, IncludeHeaders) = 200 then
      Result := ss.DataString
    else
      Result := '';
  finally
    ss.Free;
  end;
end;

function PostPage(const URL: string; const Pieces: array of RAttachement; UTF8: Boolean): string;
begin
  Result := _PostPage(URL, Pieces, UTF8, False);
end;

function PostPageWithHeaders(const URL: string; const Pieces: array of RAttachement; UTF8: Boolean): string;
begin
  Result := _PostPage(URL, Pieces, UTF8, True);
end;

function _GetPage(const URL: string; UTF8, IncludeHeaders: Boolean): string;
var
  ss: TStringStream;
begin
  if UTF8 then
    ss := TStringStream.Create('', TEncoding.UTF8)
  else
    ss := TStringStream.Create('', TEncoding.default);
  try
    if LoadStreamURL(URL, [], ss, True, IncludeHeaders) = 200 then
      Result := ss.DataString
    else
      Result := '';
  finally
    ss.Free;
  end;
end;

function GetPage(const URL: string; UTF8: Boolean): string;
begin
  Result := _GetPage(URL, UTF8, False);
end;

function GetPageWithHeaders(const URL: string; UTF8: Boolean): string;
begin
  Result := _GetPage(URL, UTF8, True);
end;

function MakeAuteur(const Nom: string; Metier: TMetierAuteur): TAuteur;
begin
  Result := TAuteur.Create;
  Result.Personne.Nom := Nom;
  Result.Metier := Metier;
end;

type
  TdummyForm = class(TbdtForm)
  public
    procedure editChange(Sender: TObject);
  end;

procedure TdummyForm.editChange(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to Pred(ControlCount) do
    if (Controls[i] is TEditLabeled) and (Controls[i] <> Sender) then
      with Controls[i] as TEditLabeled do
      begin
        OnChange := nil;
        Text := '';
        OnChange := editChange;
      end;
end;

type
  TCrackLabel = class(TLabel)
  end;

function AskSearchEntry(const Labels: array of string; var Search: string; var index: Integer): Boolean;
var
  F: TdummyForm;
  E: TEditLabeled;
  Titre, SousTitre: string;
  L, SubL: array of TLabel;
  i, T, maxW, P: Integer;
begin
  Result := False;
  if Length(Labels) = 0 then
    Exit;

  SetLength(L, Length(Labels));
  SetLength(SubL, Length(Labels));
  ZeroMemory(SubL, SizeOf(SubL));
  T := 0;
  F := TdummyForm.Create(nil);
  try
    F.Position := poMainFormCenter;
    E := nil;
    maxW := 0;

    for i := low(Labels) to high(Labels) do
    begin
      Titre := Labels[i];
      SousTitre := '';
      P := Pos('|', Titre);
      if P > 0 then
      begin
        SousTitre := Copy(Titre, P + 1, MaxInt);
        Titre := Copy(Titre, 1, P - 1);
      end;

      L[i] := TLabel.Create(F);
      L[i].Parent := F;

      L[i].WordWrap := True;
      L[i].AutoSize := True;
      L[i].Caption := Titre;
      L[i].Left := 0;
      L[i].Width := 150;
      TCrackLabel(L[i]).AdjustBounds;
      L[i].Visible := True;
      L[i].Transparent := True;

      if L[i].Width > maxW then
        maxW := L[i].Width;

      if SousTitre <> '' then
      begin
        SubL[i] := TLabel.Create(F);
        SubL[i].Parent := F;

        SubL[i].WordWrap := True;
        SubL[i].AutoSize := True;
        SubL[i].Caption := SousTitre;
        SubL[i].Left := 0;
        SubL[i].Visible := True;
        SubL[i].Transparent := True;
        SubL[i].Font.Style := SubL[i].Font.Style + [fsItalic];
      end;
    end;

    for i := low(Labels) to high(Labels) do
    begin
      E := TEditLabeled.Create(F);
      E.Parent := F;
      E.Tag := i;
      E.BevelKind := bkTile;
      E.BorderStyle := bsNone;
      E.LinkControls.Add(L[i]);
      E.Left := L[i].Left + maxW + 8;
      E.Width := 250;
      E.Visible := True;
      if (index = i) then
      begin
        F.ActiveControl := E;
        E.Text := Search;
      end;
      E.OnChange := F.editChange;

      if E.Height > L[i].Height then
      begin
        E.Top := T;
        T := T + E.Height + 8;
        L[i].Top := E.Top + (E.Height - L[i].Height) div 2;
      end
      else
      begin
        L[i].Top := T;
        T := T + L[i].Height + 8;
        E.Top := L[i].Top + (L[i].Height - E.Height) div 2;
      end;

      if Assigned(SubL[i]) then
      begin
        SubL[i].Top := T - 8;
        SubL[i].Width := E.Left + E.Width;
        TCrackLabel(SubL[i]).AdjustBounds;
        T := T + SubL[i].Height;
      end;
    end;

    with TframBoutons.Create(F) do
    begin
      Align := alNone;
      Parent := F;
      Top := T + 8;
      Left := 0;
      Width := E.Left + E.Width;
    end;

    F.AutoSize := True;
    F.BorderStyle := bsDialog;
    F.BorderWidth := 8;
    F.PopupMode := pmAuto;
    Result := F.ShowModal = mrOk;

    if Result then
    begin
      Search := '';
      for i := 0 to Pred(F.ControlCount) do
        if (F.Controls[i] is TEditLabeled) and (TEditLabeled(F.Controls[i]).Text <> '') then
          with F.Controls[i] as TEditLabeled do
          begin
            Search := Trim(Text);
            index := Tag;
          end;
      Result := Search <> '';
    end;
  finally
    F.Free;
  end;
end;

procedure Split(SL: TStringList; const Chaine: string; Sep: Char);
begin
  SL.Delimiter := Sep;
  SL.DelimitedText := Chaine;
end;

function CombineURL(const Root, URL: string): string;
var
  buffer: array of Char;
  lbuffer: Cardinal;
begin
  lbuffer := 0;
  InternetCombineUrl(PChar(Root), PChar(URL), nil, lbuffer, ICU_BROWSER_MODE);
  SetLength(buffer, lbuffer);
  ZeroMemory(buffer, Length(buffer));
  InternetCombineUrl(PChar(Root), PChar(URL), PChar(buffer), lbuffer, ICU_BROWSER_MODE);
  Result := PChar(buffer);
end;

function ScriptFormatSettings: TFormatSettings;
begin
  Result := TFormatSettings.Create(1033);
end;

function ScriptStrToFloatDef(const S: string; const default: Extended): Extended;
var
  fs: TFormatSettings;
begin
  fs := ScriptFormatSettings;
  Result := StrToFloatDef(StringReplace(S, ',', fs.DecimalSeparator, []), default, fs);
end;

function ScriptIsPathDelimiter(const S: string; index: Integer): Boolean;
begin
  Result := (index > 0) and (index <= Length(S)) and (S[index] = PathDelim) and (ByteType(S, index) = mbSingleByte);
end;

function ScriptIncludeTrailingPathDelimiter(const S: string): string;
begin
  Result := S;
  if not ScriptIsPathDelimiter(Result, Length(Result)) then
    Result := Result + PathDelim;
end;

function ScriptExcludeTrailingPathDelimiter(const S: string): string;
begin
  Result := S;
  if ScriptIsPathDelimiter(Result, Length(Result)) then
    SetLength(Result, Length(Result) - 1);
end;

function ScriptChangeFileExt(const FileName, Extension: string): string;
var
  i: Integer;
begin
  i := LastDelimiter('.' + PathDelim + DriveDelim, FileName);
  if (i = 0) or (FileName[i] <> '.') then
    i := MaxInt;
  Result := Copy(FileName, 1, i - 1) + Extension;
end;

function ScriptChangeFilePath(const FileName, Path: string): string;
begin
  Result := ScriptIncludeTrailingPathDelimiter(Path) + ScriptExtractFileName(FileName);
end;

function ScriptExtractFilePath(const FileName: string): string;
var
  i: Integer;
begin
  i := LastDelimiter(PathDelim + DriveDelim, FileName);
  Result := Copy(FileName, 1, i);
end;

function ScriptExtractFileDir(const FileName: string): string;
var
  i: Integer;
begin
  i := LastDelimiter(PathDelim + DriveDelim, FileName);
  if (i > 1) and (FileName[i] = PathDelim) and (not IsDelimiter(PathDelim + DriveDelim, FileName, i - 1)) then
    Dec(i);
  Result := Copy(FileName, 1, i);
end;

function ScriptExtractFileName(const FileName: string): string;
var
  i: Integer;
begin
  i := LastDelimiter(PathDelim + DriveDelim, FileName);
  Result := Copy(FileName, i + 1, MaxInt);
end;

function ScriptExtractFileExt(const FileName: string): string;
var
  i: Integer;
begin
  i := LastDelimiter('.' + PathDelim + DriveDelim, FileName);
  if (i > 0) and (FileName[i] = '.') then
    Result := Copy(FileName, i, MaxInt)
  else
    Result := '';
end;

function OffsetFromUTC: TDateTime;
var
  iBias: Integer;
  tmez: TTimeZoneInformation;
begin
  iBias := 0;
  case GetTimeZoneInformation(tmez) of
    TIME_ZONE_ID_UNKNOWN:
      iBias := tmez.Bias;
    TIME_ZONE_ID_DAYLIGHT:
      iBias := tmez.Bias + tmez.DaylightBias;
    TIME_ZONE_ID_STANDARD:
      iBias := tmez.Bias + tmez.StandardBias;
  end;
  { We use ABS because EncodeTime will only accept positive values }
  Result := EncodeTime(Abs(iBias) div 60, Abs(iBias) mod 60, 0, 0);
  { The GetTimeZone function returns values oriented towards converting
    a GMT time into a local time.  We wish to do the opposite by returning
    the difference between the local time and GMT.  So I just make a positive
    value negative and leave a negative value as positive }
  if iBias > 0 then
    Result := 0 - Result;
end;

function TimeZoneBias: string;

var
  TZI: TTimeZoneInformation;
  TZIResult, aBias: Integer;
begin
  TZIResult := GetTimeZoneInformation(TZI);
  if TZIResult = -1 then
    Result := 'GMT'
  else
  begin
    if TZIResult = TIME_ZONE_ID_DAYLIGHT then { 10/05/99 }
      aBias := TZI.Bias + TZI.DaylightBias
    else
      aBias := TZI.Bias + TZI.StandardBias;
    Result := Format('-%.2d%.2d', [Abs(aBias) div 60, Abs(aBias) mod 60]);
    if aBias < 0 then
      Result[1] := '+';
  end;
end;

const
  RFC822_Days: array [1 .. 7] of string = ('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat');
  RFC822_Months: array [1 .. 12] of string = ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');

function DateTimeToRFC822(T: TDateTime): string;
var
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
begin
  DecodeDate(T, Year, Month, Day);
  DecodeTime(T, Hour, Min, Sec, MSec);
  { Format is 'ddd, d mmm yyyy hh:mm:ss GMTOffset' with english names }
  Result := Format('%s, %d %s %4d %02.2d:%02.2d:%02.2d %s', [RFC822_Days[DayOfWeek(T)], Day, RFC822_Months[Month], Year, Hour, Min, Sec, TimeZoneBias]
    );
end;

function TryRFC822ToDateTime(const S: string; out Value: TDateTime): Boolean;
var
  P1, P2: Integer;
  ADateStr: string;
  aLst: TStringList;
  aMonthLabel: string;
  aFormatSettings: TFormatSettings;
  aTimeZoneStr: string;
  aTimeZoneDelta: TDateTime;

  function MonthWithLeadingChar(const AMonth: string): string;
  begin
    if Length(AMonth) = 1 then
      Result := '0' + AMonth
    else
      Result := AMonth;
  end;

begin
  Result := False;

  ADateStr := S; // 'Wdy, DD-Mon-YYYY HH:MM:SS GMT' or 'Wdy, DD-Mon-YYYY HH:MM:SS +0200' or '23 Aug 2004 06:48:46 -0700'
  P1 := Pos(',', ADateStr);
  if P1 > 0 then
    Delete(ADateStr, 1, P1); // ' DD-Mon-YYYY HH:MM:SS GMT' or ' DD-Mon-YYYY HH:MM:SS +0200' or '23 Aug 2004 06:48:46 -0700'
  ADateStr := Trim(ADateStr); // 'DD-Mon-YYYY HH:MM:SS GMT' or 'DD-Mon-YYYY HH:MM:SS +0200' or '23 Aug 2004 06:48:46 -0700'

  P1 := Pos(':', ADateStr);
  P2 := Pos('-', ADateStr);
  while (P2 > 0) and (P2 < P1) do
  begin
    Delete(ADateStr, P2, 1);
    Dec(P1);
    P2 := PosEx('-', ADateStr, P2);
  end; // 'DD Mon YYYY HH:MM:SS GMT' or 'DD Mon YYYY HH:MM:SS +0200' or '23 Aug 2004 06:48:46 -0700'
  while Pos('  ', ADateStr) > 0 do
    ADateStr := StringReplace(ADateStr, '  ', ' ', [rfReplaceAll]); // 'DD Mon YYYY HH:MM:SS GMT' or 'DD Mon YYYY HH:MM:SS +0200'
  aLst := TStringList.Create;
  try
    aLst.Text := StringReplace(ADateStr, ' ', #13#10, [rfReplaceAll]);
    if aLst.Count < 5 then
      Exit;

    aMonthLabel := Trim(aLst[1]);
    P1 := 1;
    while (P1 <= 12) and (not SameText(RFC822_Months[P1], aMonthLabel)) do
      Inc(P1);

    aFormatSettings := TFormatSettings.Create(GetSystemDefaultLCID);
    aFormatSettings.DateSeparator := '/';
    aFormatSettings.TimeSeparator := ':';
    aFormatSettings.ShortDateFormat := 'dd/mm/yyyy';
    aFormatSettings.ShortTimeFormat := 'hh:nn:zz';

    aTimeZoneStr := UpperCase(aLst[4]);
    aTimeZoneStr := StringReplace(aTimeZoneStr, '(', '', []);
    aTimeZoneStr := StringReplace(aTimeZoneStr, ')', '', []);
    aTimeZoneStr := Trim(aTimeZoneStr);
    if aTimeZoneStr = '' then
      Exit;

    if (Length(aTimeZoneStr) >= 5) and CharInSet(aTimeZoneStr[1], ['+', '-']) and CharInSet
      (aTimeZoneStr[2], ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) and CharInSet
      (aTimeZoneStr[3], ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) and CharInSet
      (aTimeZoneStr[4], ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) and CharInSet
      (aTimeZoneStr[5], ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) then
    begin
      aTimeZoneDelta := EncodeTime(StrToInt(Copy(aTimeZoneStr, 2, 2)), StrToInt(Copy(aTimeZoneStr, 4, 2)), 0, 0);
      if aTimeZoneStr[1] = '+' then
        aTimeZoneDelta := -1 * aTimeZoneDelta;
    end
    else if aTimeZoneStr = 'GMT' then
      aTimeZoneDelta := 0
    else if aTimeZoneStr = 'UTC' then
      aTimeZoneDelta := 0
    else if aTimeZoneStr = 'UT' then
      aTimeZoneDelta := 0
    else if aTimeZoneStr = 'EST' then
      aTimeZoneDelta := 5 / HoursPerDay
    else if aTimeZoneStr = 'EDT' then
      aTimeZoneDelta := 4 / HoursPerDay
    else if aTimeZoneStr = 'CST' then
      aTimeZoneDelta := 6 / HoursPerDay
    else if aTimeZoneStr = 'CDT' then
      aTimeZoneDelta := 5 / HoursPerDay
    else if aTimeZoneStr = 'MST' then
      aTimeZoneDelta := 7 / HoursPerDay
    else if aTimeZoneStr = 'MDT' then
      aTimeZoneDelta := 6 / HoursPerDay
    else if aTimeZoneStr = 'PST' then
      aTimeZoneDelta := 8 / HoursPerDay
    else if aTimeZoneStr = 'PDT' then
      aTimeZoneDelta := 7 / HoursPerDay
    else
      Exit;

    ADateStr := Trim(aLst[0]) + '/' + MonthWithLeadingChar(IntToStr(P1)) + '/' + Trim(aLst[2]) + ' ' + Trim(aLst[3]); // 'DD/MM/YYYY HH:MM:SS'
    Result := TryStrToDateTime(ADateStr, Value, aFormatSettings);
    if Result then
      Value := Value + aTimeZoneDelta + OffsetFromUTC;
  finally
    aLst.Free;
  end;
end;

function RFC822ToDateTime(const S: string): TDateTime;
begin
  if not TryRFC822ToDateTime(S, Result) then
    raise EConvertError.CreateResFmt(@SInvalidDateTime, [S]);
end;

function RFC822ToDateTimeDef(const S: string; default: TDateTime): TDateTime;
begin
  if not TryRFC822ToDateTime(S, Result) then
    Result := default;
end;

end.
