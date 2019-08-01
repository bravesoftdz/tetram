unit BD.Utils.Net;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, VCL.Forms, Winapi.Messages;

type
  RAttachement = packed record
    Nom, Valeur: string;
    IsFichier: Boolean;
  end;

function GetPage(const URL: string; UTF8: Boolean = True): string;
function GetPageWithHeaders(const URL: string; UTF8: Boolean = True): string;
function PostPage(const URL: string; const Pieces: array of RAttachement; UTF8: Boolean = True): string;
function PostPageWithHeaders(const URL: string; const Pieces: array of RAttachement; UTF8: Boolean = True): string;

function LoadStreamURL(URL: string; const Pieces: array of RAttachement; StreamAnswer: TStream; ShowProgress: Boolean = True; IncludeHeaders: Boolean = False)
  : Word; overload;
function LoadStreamURL(URL: string; const Pieces: array of RAttachement; StreamAnswer: TStream; out DocName: string; ShowProgress: Boolean = True;
  IncludeHeaders: Boolean = False): Word; overload;

function DateTimeToRFC822(T: TDateTime): string;
function TryRFC822ToDateTime(const S: string; out Value: TDateTime): Boolean;
function RFC822ToDateTime(const S: string): TDateTime;
function RFC822ToDateTimeDef(const S: string; default: TDateTime): TDateTime;

implementation

uses
  System.IOUtils, OverbyteIcsHttpProt, OverbyteIcsLogger, BD.Utils.GUIUtils, System.AnsiStrings, OverbyteIcsWSocket, OverbyteIcsLIBEAY,
  System.SysConst, Winapi.WinInet, BD.Utils.Net.ICS;

function GetFileNameFromURL(const URL: string): string;
var
  URLComponents: TURLComponents;
  chemin: string;
  p: Integer;
begin
  ZeroMemory(@URLComponents, SizeOf(URLComponents));
  URLComponents.dwStructSize := SizeOf(URLComponents);
  URLComponents.dwHostNameLength := 1;
  URLComponents.dwSchemeLength := 1;
  URLComponents.dwUserNameLength := 1;
  URLComponents.dwPasswordLength := 1;
  URLComponents.dwUrlPathLength := 1;
  if not InternetCrackUrl(PChar(URL), Length(URL), 0, URLComponents) then
    RaiseLastOSError;
  chemin := Copy(URLComponents.lpszUrlPath, 0, URLComponents.dwUrlPathLength);
  chemin := chemin.Split(['?','#'])[0];
  p := chemin.LastIndexOf('/');
  if p > 0 then
    Result := chemin.Substring(p + 1)
  else
    Result := '';
end;

function URLEncode(const URL: string): string;
var
  URLComponents: TURLComponents;
  lbuffer: Cardinal;
begin
  ZeroMemory(@URLComponents, SizeOf(URLComponents));
  URLComponents.dwStructSize := SizeOf(URLComponents);
  URLComponents.dwHostNameLength := 1;
  URLComponents.dwSchemeLength := 1;
  URLComponents.dwUserNameLength := 1;
  URLComponents.dwPasswordLength := 1;
  URLComponents.dwUrlPathLength := 1;
  if not InternetCrackUrl(PChar(URL), Length(URL), 0, URLComponents) then
    RaiseLastOSError;

  lbuffer := 1024;
  SetLength(Result, lbuffer);
  if not InternetCreateUrl(URLComponents, ICU_ESCAPE, @Result[1], lbuffer) then
    if GetLastError = ERROR_INSUFFICIENT_BUFFER then
    begin
      SetLength(Result, lbuffer);
      if InternetCreateUrl(URLComponents, ICU_ESCAPE, @Result[1], lbuffer) then
        RaiseLastOSError;
    end
    else
      RaiseLastOSError;
  SetLength(Result, lbuffer);
end;

function GetInfoVersion(const NameExe: string): string;
var
  FileName: string;
  InfoSize, Wnd: DWORD;
  VerBuf: Pointer;
  FI: PVSFixedFileInfo;
  VerSize: DWORD;
begin
  Result := '';
  // GetFileVersionInfo modifies the filename parameter data while parsing.
  // Copy the string const into a local variable to create a writeable copy.
  FileName := NameExe;
  UniqueString(FileName);
  InfoSize := GetFileVersionInfoSize(PChar(FileName), Wnd);
  if InfoSize <> 0 then
  begin
    GetMem(VerBuf, InfoSize);
    try
      if GetFileVersionInfo(PChar(FileName), Wnd, InfoSize, VerBuf) then
        if VerQueryValue(VerBuf, '\', Pointer(FI), VerSize) then
          Result := Format('%d.%d.%d.%d', [FI.dwFileVersionMS shr 16, FI.dwFileVersionMS and $FFFF, FI.dwFileVersionLS shr 16, FI.dwFileVersionLS and $FFFF]);
    finally
      FreeMem(VerBuf);
    end;
  end;
end;

procedure RaiseLastInternetError;
var
  Buffer: array of Char;
  lbuffer: Cardinal;
  ErrorCode: DWORD;
begin
  lbuffer := 1024;
  SetLength(Buffer, lbuffer);
  if not InternetGetLastResponseInfo(ErrorCode, @Buffer, lbuffer) then
  begin
    if GetLastError = ERROR_INSUFFICIENT_BUFFER then
    begin
      SetLength(Buffer, lbuffer);
      if not InternetGetLastResponseInfo(ErrorCode, @Buffer, lbuffer) then
        RaiseLastOSError;
    end
    else
      RaiseLastOSError;
  end;
  raise EOSError.Create(PChar(@Buffer));
end;

function GetAnwser(hRequest: HINTERNET; Stream: TStream): Word;
var
  Buffer: array of Char;
  lbuffer, dDummy: Cardinal;
  ss: TStringStream;
begin
  lbuffer := 1024;
  SetLength(Buffer, lbuffer);
  dDummy := 0;
  if not HttpQueryInfo(hRequest, HTTP_QUERY_STATUS_CODE, Buffer, lbuffer, dDummy) then
    if GetLastError = ERROR_INSUFFICIENT_BUFFER then
    begin
      SetLength(Buffer, lbuffer);
      if not HttpQueryInfo(hRequest, HTTP_QUERY_STATUS_CODE, Buffer, lbuffer, dDummy) then
        RaiseLastOSError;
    end
    else
      RaiseLastOSError;

  ss := TStringStream.Create('', TEncoding.Unicode);
  try
    ss.Size := 0;
    ss.write(Buffer[0], lbuffer);
    Result := StrToIntDef(ss.DataString, 400);
    if Result <> 200 then
    begin
      ss.WriteString(#13#10);
      lbuffer := 1024;
      SetLength(Buffer, lbuffer);
      if not HttpQueryInfo(hRequest, HTTP_QUERY_STATUS_TEXT, Buffer, lbuffer, dDummy) then
        if GetLastError = ERROR_INSUFFICIENT_BUFFER then
        begin
          SetLength(Buffer, lbuffer);
          if not HttpQueryInfo(hRequest, HTTP_QUERY_STATUS_TEXT, Buffer, lbuffer, dDummy) then
            RaiseLastOSError;
        end
        else
          RaiseLastOSError;
      ss.write(Buffer[0], lbuffer);
      if Assigned(Stream) then
        Stream.CopyFrom(ss, 0);
    end;
  finally
    ss.Free;
  end;
end;

function LoadStreamURL2(URL: string; const Pieces: array of RAttachement; StreamAnswer: TStream): Word;
const
  FLAG_ICC_FORCE_CONNECTION = 1;
var
  fs: TFileStream;
  MemoryStream: TMemoryStream;
  hISession, hConnect, hRequest: HINTERNET;
  URLComponents: TURLComponents;
  httpHeader: string;
  Buffer: array of Char;
  BytesRead, lbuffer: Cardinal;
  i: Integer;
  idRequete, Serveur, Agent, Action: string;
begin
  idRequete := '---------------------------26846888314793'; // valeur arbitraire: voir s'il faut la changer à chaque requête mais il semble que non
  Result := 0;
  Agent := Format('%s/%s', [TPath.GetFileNameWithoutExtension(Application.ExeName), GetInfoVersion(Application.ExeName)]);
  hISession := InternetOpen(PChar(Agent), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if (hISession = nil) then
    RaiseLastOSError;
  try
    ZeroMemory(@URLComponents, SizeOf(URLComponents));
    URLComponents.dwStructSize := SizeOf(URLComponents);
    URLComponents.dwHostNameLength := 1;
    URLComponents.dwSchemeLength := 1;
    URLComponents.dwUserNameLength := 1;
    URLComponents.dwPasswordLength := 1;
    URLComponents.dwUrlPathLength := 1;
    if not InternetCrackUrl(PChar(URL), Length(URL), 0, URLComponents) then
      RaiseLastOSError;
    if not(URLComponents.nScheme in [INTERNET_SERVICE_HTTP, INTERNET_SERVICE_FTP]) then
      raise Exception.Create('Type d''adresse non supporté:'#13#10 + URL);
    Serveur := Copy(URLComponents.lpszHostName, 1, Pos('/', string(URLComponents.lpszHostName) + '/') - 1);
    Serveur := Copy(Serveur, 1, Pos(':', Serveur + ':') - 1);
    hConnect := InternetConnect(hISession, PChar(Serveur), URLComponents.nPort, URLComponents.lpszUserName, URLComponents.lpszPassword,
      URLComponents.nScheme, 0, 0);
    if (hConnect = nil) then
      RaiseLastInternetError;
    try
      if Length(Pieces) = 0 then
        Action := 'GET'
      else
        Action := 'POST';
      hRequest := HttpOpenRequest(hConnect, PChar(Action), URLComponents.lpszUrlPath, nil, nil, nil, INTERNET_FLAG_NO_CACHE_WRITE or INTERNET_FLAG_RELOAD, 0);
      if (hRequest = nil) then
        RaiseLastOSError;
      try
        MemoryStream := TMemoryStream.Create;
        try
          MemoryStream.Position := 0;

          httpHeader := '';

          if Length(Pieces) > 0 then
          begin
            for i := low(Pieces) to high(Pieces) do
              if Pieces[i].IsFichier then
              begin
                fs := TFileStream.Create(Pieces[i].Valeur, fmOpenRead or fmShareDenyWrite);
                try
                  httpHeader := '--' + idRequete + #13#10;
                  httpHeader := httpHeader + 'Content-Disposition: form-data; name="' + Pieces[i].Nom + '"; filename="' + ExtractFileName(Pieces[i].Valeur) +
                    '"'#13#10;
                  httpHeader := httpHeader + 'Content-Type: application/octet-stream'#13#10;
                  httpHeader := httpHeader + 'Content-Length: ' + IntToStr(fs.Size) + #13#10;
                  httpHeader := httpHeader + #13#10;
                  MemoryStream.WriteBuffer(httpHeader[1], Length(httpHeader) * SizeOf(Char));
                  MemoryStream.CopyFrom(fs, fs.Size);
                  httpHeader := #13#10;
                  MemoryStream.WriteBuffer(httpHeader[1], Length(httpHeader) * SizeOf(Char));
                finally
                  fs.Free;
                end;
              end
              else
              begin
                httpHeader := '--' + idRequete + #13#10;
                httpHeader := httpHeader + 'Content-Disposition: form-data; name="' + Pieces[i].Nom + '"'#13#10;
                httpHeader := httpHeader + #13#10;
                httpHeader := httpHeader + Pieces[i].Valeur + #13#10;
                MemoryStream.WriteBuffer(httpHeader[1], Length(httpHeader) * SizeOf(Char));
              end;
            httpHeader := '--' + idRequete + '--'#13#10;
            MemoryStream.WriteBuffer(httpHeader[1], Length(httpHeader) * SizeOf(Char));

            httpHeader := 'Content-Type: multipart/form-data; boundary=' + idRequete + #13#10;
          end;

          // httpHeader := httpHeader + 'Accept: text/*'#13#10;
          httpHeader := httpHeader + 'Accept-Language: fr'#13#10;
          httpHeader := httpHeader + 'Accept-Encoding: deflate'#13#10;
          httpHeader := httpHeader + 'Accept-Charset: ISO-8859-1'#13#10;

          if not HttpSendRequest(hRequest, PChar(httpHeader), Length(httpHeader), MemoryStream.Memory, MemoryStream.Size) then
            RaiseLastOSError;

          Result := GetAnwser(hRequest, MemoryStream);
          if Result = 200 then
          begin
            lbuffer := 16384;
            SetLength(Buffer, lbuffer);
            if Assigned(StreamAnswer) then
              StreamAnswer.Size := 0;
            while InternetReadFile(hRequest, Buffer, lbuffer, BytesRead) do
            begin
              if Assigned(StreamAnswer) then
                StreamAnswer.write(Buffer[0], BytesRead);
              if BytesRead < lbuffer then
                Break;
            end;
            if Assigned(StreamAnswer) then
              StreamAnswer.Seek(0, soFromBeginning);
          end;
        finally
          MemoryStream.Free;
        end;
      finally
        InternetCloseHandle(hRequest);
      end;
    finally
      InternetCloseHandle(hConnect);
    end;
  finally
    InternetCloseHandle(hISession);
  end;
end;

type
  TDownloader = class
    FSslContext: TSslContext;
    FHttpCli: TSslHttpCli;
    FUserCancel: Integer;
    FWaiting: IWaiting;

    constructor Create;
    destructor Destroy; override;

    procedure RequestDone(Sender: TObject; RqType: THttpRequest; ErrCode: Word);
    procedure DocData(Sender: TObject; Buffer: Pointer; Len: Integer);
    procedure SendData(Sender: TObject; Buffer: Pointer; Len: Integer);
  end;

constructor TDownloader.Create;
begin
  inherited;
  FUserCancel := 0;

  FSslContext := TSslContext.Create(nil);

  FHttpCli := TSslHttpCli.Create(nil);
  FHttpCli.SslContext := FSslContext;
  // 09/06/2011 dans certains cas particuliers, la redirection ne fonctionne pas si on est en 1.1
  // FHttpCli.RequestVer := '1.1';
  FHttpCli.RequestVer := '1.0';
  FHttpCli.Agent := Format('%s/%s', [TPath.GetFileNameWithoutExtension(Application.ExeName), GetInfoVersion(Application.ExeName)]);
  FHttpCli.AcceptLanguage := 'fr';
  FHttpCli.Options := FHttpCli.Options + [httpoEnableContentCoding, httpoUseQuality];
  FHttpCli.FollowRelocation := True;
  FHttpCli.OnRequestDone := RequestDone;
  FHttpCli.OnDocData := DocData;
  FHttpCli.OnSendData := SendData;

  // FHttpCli.IcsLogger := TIcsLogger.Create(FHttpCli);
  // FHttpCli.IcsLogger.LogOptions := [loDestFile, loAddStamp, loWsockErr, loWsockInfo, loWsockDump, loSslErr, loSslInfo, loSslDump, loProtSpecErr,
  // loProtSpecInfo, loProtSpecDump];
  // FHttpCli.IcsLogger.LogFileName := 'd:\icslog.log';
  // FHttpCli.IcsLogger.LogFileOption := lfoOverwrite;

  FHttpCli.MultiThreaded := True;
end;

destructor TDownloader.Destroy;
begin
  FWaiting := nil;
  FHttpCli.Free;
  FSslContext.Free;
  inherited;
end;

procedure TDownloader.DocData(Sender: TObject; Buffer: Pointer; Len: Integer);
begin
  if FUserCancel > 0 then
    FHttpCli.Abort;
  if Assigned(FWaiting) then
    FWaiting.ShowProgression('', FHttpCli.RcvdCount, FHttpCli.ContentLength);
end;

procedure TDownloader.SendData(Sender: TObject; Buffer: Pointer; Len: Integer);
begin
  if FUserCancel > 0 then
    FHttpCli.Abort;
  // les ICS ne permettent pas de gérer une progressbar en envoi
  // if Assigned(FWaiting) then
  // FWaiting.ShowProgression('', FHttpCli.RcvdCount, FHttpCli.ContentLength);
end;

procedure TDownloader.RequestDone(Sender: TObject; RqType: THttpRequest; ErrCode: Word);
begin
  if Assigned(FWaiting) then
    FWaiting.ShowProgression('', epFin);
end;

function LoadStreamURL(URL: string; const Pieces: array of RAttachement; StreamAnswer: TStream; ShowProgress, IncludeHeaders: Boolean): Word;
var
  dummy: string;
begin
  Result := LoadStreamURL(URL, Pieces, StreamAnswer, dummy, ShowProgress, IncludeHeaders);
end;

function LoadStreamURL(URL: string; const Pieces: array of RAttachement; StreamAnswer: TStream; out DocName: string;
  ShowProgress, IncludeHeaders: Boolean): Word;
var
  MemoryStream: TMemoryStream;
  fs: TFileStream;
  i: Integer;
  idRequete: string;
  httpHeader, S: RawByteString;
  dl: TDownloader;
begin
  Result := 0;
  idRequete := '---------------------------26846888314793'; // valeur arbitraire: voir s'il faut la changer à chaque requête mais il semble que non
  MemoryStream := TMemoryStream.Create;
  dl := TDownloader.Create;
  try
    if Pos('%', URL) > 0 then
      dl.FHttpCli.URL := URL
    else
      dl.FHttpCli.URL := URLEncode(URL);
    dl.FHttpCli.SendStream := MemoryStream;
    dl.FHttpCli.RcvdStream := StreamAnswer;

    MemoryStream.Position := 0;

    httpHeader := '';

    if Length(Pieces) > 0 then
    begin
      for i := low(Pieces) to high(Pieces) do
        if Pieces[i].IsFichier then
        begin
          fs := TFileStream.Create(Pieces[i].Valeur, fmOpenRead or fmShareDenyWrite);
          try
            httpHeader := '--' + UTF8Encode(idRequete) + #13#10;
            httpHeader := httpHeader + 'Content-Disposition: form-data; name="' + UTF8Encode(Pieces[i].Nom) + '"; filename="' + UTF8Encode(ExtractFileName(Pieces[i].Valeur)) + '"'#13#10;
            httpHeader := httpHeader + 'Content-Type: application/octet-stream'#13#10;
            httpHeader := httpHeader + 'Content-Length: ' + UTF8Encode(IntToStr(fs.Size)) + #13#10;
            httpHeader := httpHeader + #13#10;
            MemoryStream.WriteBuffer(httpHeader[1], Length(httpHeader));
            MemoryStream.CopyFrom(fs, fs.Size);
            httpHeader := #13#10;
            MemoryStream.WriteBuffer(httpHeader[1], Length(httpHeader));
          finally
            fs.Free;
          end;
        end
        else
        begin
          httpHeader := '--' + UTF8Encode(idRequete) + #13#10;
          httpHeader := httpHeader + 'Content-Disposition: form-data; name="' + UTF8Encode(Pieces[i].Nom) + '"'#13#10;
          httpHeader := httpHeader + #13#10;
          httpHeader := httpHeader + UTF8Encode(Pieces[i].Valeur) + #13#10;
          MemoryStream.WriteBuffer(httpHeader[1], Length(httpHeader));
        end;

      httpHeader := '--' + UTF8Encode(idRequete) + '--'#13#10;
      MemoryStream.WriteBuffer(httpHeader[1], Length(httpHeader));

      dl.FHttpCli.ContentTypePost := 'multipart/form-data; charset=UTF-8; boundary=' + idRequete;
    end;

    MemoryStream.Position := 0;

    if ShowProgress then
    begin
      dl.FWaiting := TWaiting.Create('Chargement des données...', 1, @(dl.FUserCancel), False);
      // pour forcer la fenêtre à afficher des choses dès son apparition
      dl.FWaiting.ShowProgression(URL, dl.FHttpCli.RcvdCount, dl.FHttpCli.ContentLength);
    end;
    try
      if Length(Pieces) > 0 then
        dl.FHttpCli.Post
      else
        dl.FHttpCli.Get;
    except
      on E: EHttpException do ;
    end;

    Result := dl.FHttpCli.StatusCode;
    // à remplacer par la valeur du header 'filename' ou equivalent
    for i := 0 to Pred(dl.FHttpCli.RcvdHeader.Count) do
      if SameText('filename: ', Copy(dl.FHttpCli.RcvdHeader[i], 1, 10)) then
      begin
        DocName := Copy(dl.FHttpCli.RcvdHeader[i], 11, MaxInt);
        Break;
      end;
    if DocName = '' then
      DocName := GetFileNameFromURL(URL);

    if IncludeHeaders then
    begin
      MemoryStream.Size := 0;
      StreamAnswer.Position := 0;
      MemoryStream.CopyFrom(StreamAnswer, 0);

      dl.FHttpCli.RcvdHeader.Add('X-URL-Origin: ' + dl.FHttpCli.URL);
      dl.FHttpCli.RcvdHeader.Add('X-URL-Final: ' + dl.FHttpCli.Location);
      S := RawByteString(dl.FHttpCli.RcvdHeader.Text) + #13#10;
      StreamAnswer.Size := 0;
      StreamAnswer.WriteBuffer(S[1], Length(S));
      MemoryStream.Position := 0;
      StreamAnswer.CopyFrom(MemoryStream, 0);
    end;
  finally
    MemoryStream.Free;
    dl.Free;
  end;
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
  Result := Format('%s, %d %s %4d %02.2d:%02.2d:%02.2d %s', [RFC822_Days[DayOfWeek(T)], Day, RFC822_Months[Month], Year, Hour, Min, Sec, TimeZoneBias]);
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
    P2 := PosEx('-', AnsiString(ADateStr), P2);
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

    aFormatSettings := TFormatSettings.Create;
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

    if (Length(aTimeZoneStr) >= 5) and CharInSet(aTimeZoneStr[1], ['+', '-']) and CharInSet(aTimeZoneStr[2], ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'])
      and CharInSet(aTimeZoneStr[3], ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) and
      CharInSet(aTimeZoneStr[4], ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) and
      CharInSet(aTimeZoneStr[5], ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) then
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

end.
