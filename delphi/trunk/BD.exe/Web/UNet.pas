unit UNet;

interface

uses
  Windows, SysUtils, Classes, Forms, Messages;

type
  RAttachement = packed record
    Nom, Valeur: string;
    IsFichier: Boolean;
  end;

function LoadStreamURL(URL: string; const Pieces: array of RAttachement; StreamAnswer: TStream; ShowProgress: Boolean = True; IncludeHeaders: Boolean = False)
  : Word; overload;
function LoadStreamURL(URL: string; const Pieces: array of RAttachement; StreamAnswer: TStream; out DocName: string; ShowProgress: Boolean = True;
  IncludeHeaders: Boolean = False): Word; overload;

implementation

uses
  IOUtils, WinInet, OverbyteIcsHttpProt, OverbyteIcsLogger, ProceduresBDtk, AnsiStrings, OverbyteIcsWSocket, OverbyteIcsLIBEAY;

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
  httpHeader, s: RawByteString;
  dl: TDownloader;
begin
  Result := 0;
  idRequete := '---------------------------26846888314793'; // valeur arbitraire: voir s'il faut la changer à chaque requête mais il semble que non
  MemoryStream := TMemoryStream.Create;
  dl := TDownloader.Create;
  with dl do
    try
      if Pos('%', URL) > 0 then
        FHttpCli.URL := URL
      else
        FHttpCli.URL := URLEncode(URL);
      FHttpCli.SendStream := MemoryStream;
      FHttpCli.RcvdStream := StreamAnswer;

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
              httpHeader := httpHeader + 'Content-Disposition: form-data; name="' + UTF8Encode(Pieces[i].Nom) + '"; filename="' +
                UTF8Encode(ExtractFileName(Pieces[i].Valeur)) + '"'#13#10;
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

        FHttpCli.ContentTypePost := 'multipart/form-data; charset=UTF-8; boundary=' + idRequete;
      end;

      MemoryStream.Position := 0;

      if ShowProgress then
      begin
        FWaiting := TWaiting.Create('Chargement des données...', 1, @FUserCancel, False);
        // pour forcer la fenêtre à afficher des choses dès son apparition
        FWaiting.ShowProgression(URL, FHttpCli.RcvdCount, FHttpCli.ContentLength);
      end;
      try
        if Length(Pieces) > 0 then
          FHttpCli.Post
        else
          FHttpCli.Get;
      except
        on E: EHttpException do
        else
          raise;
      end;

      Result := FHttpCli.StatusCode;
      // à remplacer pas la valeur du header 'filename' ou equivalent
      for i := 0 to Pred(FHttpCli.RcvdHeader.Count) do
        if SameText('filename: ', Copy(FHttpCli.RcvdHeader[i], 1, 10)) then
        begin
          DocName := Copy(FHttpCli.RcvdHeader[i], 11, MaxInt);
          Break;
        end;

      if IncludeHeaders then
      begin
        MemoryStream.Size := 0;
        StreamAnswer.Position := 0;
        MemoryStream.CopyFrom(StreamAnswer, 0);

        FHttpCli.RcvdHeader.Add('X-URL-Origin: ' + FHttpCli.URL);
        FHttpCli.RcvdHeader.Add('X-URL-Final: ' + FHttpCli.Location);
        s := RawByteString(FHttpCli.RcvdHeader.Text) + #13#10;
        StreamAnswer.Size := 0;
        StreamAnswer.WriteBuffer(s[1], Length(s));
        MemoryStream.Position := 0;
        StreamAnswer.CopyFrom(MemoryStream, 0);
      end;
    finally
      MemoryStream.Free;
      Free;
    end;
end;

end.
