unit UNet;

interface

uses
  Windows, SysUtils, Classes, Forms, Messages;

type
  RAttachement = record
    Nom, Valeur: string;
    IsFichier: Boolean;
  end;

function LoadStreamURL(URL: string; const Pieces: array of RAttachement; StreamAnswer: TStream): Word; overload;
function LoadStreamURL(URL: string; const Pieces: array of RAttachement; StreamAnswer: TStream; out DocName: string): Word; overload;

implementation

uses
  WinInet, OverbyteIcsHttpProt, ProceduresBDtk, AnsiStrings;

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
          Result := Format('%d.%d.%d.%d', [FI.dwFileVersionMS shr 16,
            FI.dwFileVersionMS and $FFFF,
            FI.dwFileVersionLS shr 16,
            FI.dwFileVersionLS and $FFFF]);
    finally
      FreeMem(VerBuf);
    end;
  end;
end;

procedure RaiseLastInternetError;
var
  Buffer: array of Char;
  lBuffer: Cardinal;
  ErrorCode: DWord;
begin
  lBuffer := 1024;
  SetLength(Buffer, lBuffer);
  if not InternetGetLastResponseInfo(ErrorCode, @Buffer, lBuffer) then
  begin
    if GetLastError = ERROR_INSUFFICIENT_BUFFER then
    begin
      SetLength(Buffer, lBuffer);
      if not InternetGetLastResponseInfo(ErrorCode, @Buffer, lBuffer) then
        RaiseLastOsError;
    end
    else
      RaiseLastOsError;
  end;
  raise EOSError.Create(PChar(@Buffer));
end;

function GetAnwser(hRequest: HINTERNET; Stream: TStream): Word;
var
  Buffer: array of Char;
  lBuffer, dDummy: Cardinal;
  ss: TStringStream;
begin
  lBuffer := 1024;
  SetLength(Buffer, lBuffer);
  dDummy := 0;
  if not HttpQueryInfo(hRequest, HTTP_QUERY_STATUS_CODE, Buffer, lBuffer, dDummy) then
    if GetLastError = ERROR_INSUFFICIENT_BUFFER then
    begin
      SetLength(Buffer, lBuffer);
      if not HttpQueryInfo(hRequest, HTTP_QUERY_STATUS_CODE, Buffer, lBuffer, dDummy) then
        RaiseLastOsError;
    end
    else
      RaiseLastOsError;

  ss := TStringStream.Create('', TEncoding.Unicode);
  try
    ss.Size := 0;
    ss.Write(Buffer[0], lBuffer);
    Result := StrToIntDef(ss.DataString, 400);
    if Result <> 200 then
    begin
      ss.WriteString(#13#10);
      lBuffer := 1024;
      SetLength(Buffer, lBuffer);
      if not HttpQueryInfo(hRequest, HTTP_QUERY_STATUS_TEXT, Buffer, lBuffer, dDummy) then
        if GetLastError = ERROR_INSUFFICIENT_BUFFER then
        begin
          SetLength(Buffer, lBuffer);
          if not HttpQueryInfo(hRequest, HTTP_QUERY_STATUS_TEXT, Buffer, lBuffer, dDummy) then
            RaiseLastOsError;
        end
        else
          RaiseLastOsError;
      ss.Write(Buffer[0], lBuffer);
      if Assigned(Stream) then
        Stream.CopyFrom(ss, 0);
    end
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
  BytesRead, lBuffer: Cardinal;
  i: Integer;
  idRequete, Serveur, Agent, Action: string;
begin
  idRequete := '26846888314793'; // valeur arbitraire: voir s'il faut la changer à chaque requête mais il semble que non
  Result := 0;
  Agent := Format('%s/%s', [ChangeFileExt(ExtractFileName(Application.ExeName), ''), GetInfoVersion(Application.ExeName)]);
  hISession := InternetOpen(PChar(Agent), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if (hISession = nil) then
    RaiseLastOsError;
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
    if not (URLComponents.nScheme in [INTERNET_SERVICE_HTTP, INTERNET_SERVICE_FTP]) then
      raise Exception.Create('Type d''adresse non supporté:'#13#10 + URL);
    Serveur := Copy(URLComponents.lpszHostName, 1, Pos('/', string(URLComponents.lpszHostName) + '/') - 1);
    Serveur := Copy(Serveur, 1, Pos(':', Serveur + ':') - 1);
    hConnect := InternetConnect(hISession, PChar(Serveur), URLComponents.nPort, URLComponents.lpszUserName, URLComponents.lpszPassword, URLComponents.nScheme, 0, 0);
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
            for i := Low(Pieces) to High(Pieces) do
              if Pieces[i].IsFichier then
              begin
                fs := TFileStream.Create(Pieces[i].Valeur, fmOpenRead or fmShareDenyWrite);
                try
                  httpHeader := '-----------------------------' + idRequete + #13#10;
                  httpHeader := httpHeader + 'Content-Disposition: form-data; name="' + Pieces[i].Nom + '"; filename="' + ExtractFileName(Pieces[i].Valeur) + '"'#13#10;
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
                httpHeader := '-----------------------------' + idRequete + #13#10;
                httpHeader := httpHeader + 'Content-Disposition: form-data; name="' + Pieces[i].Nom + '"'#13#10;
                httpHeader := httpHeader + #13#10;
                httpHeader := httpHeader + Pieces[i].Valeur + #13#10;
                MemoryStream.WriteBuffer(httpHeader[1], Length(httpHeader) * SizeOf(Char));
              end;
            httpHeader := '-----------------------------' + idRequete + '--'#13#10;
            MemoryStream.WriteBuffer(httpHeader[1], Length(httpHeader) * SizeOf(Char));

            httpHeader := 'Content-Type: multipart/form-data; boundary=---------------------------' + idRequete + #13#10;
          end;

          //httpHeader := httpHeader + 'Accept: text/*'#13#10;
          httpHeader := httpHeader + 'Accept-Language: fr'#13#10;
          httpHeader := httpHeader + 'Accept-Encoding: deflate'#13#10;
          httpHeader := httpHeader + 'Accept-Charset: ISO-8859-1'#13#10;

          if not HttpSendRequest(hRequest, PChar(httpHeader), Length(httpHeader), MemoryStream.Memory, MemoryStream.Size) then
            RaiseLastOSError;

          Result := GetAnwser(hRequest, MemoryStream);
          if Result = 200 then
          begin
            lBuffer := 16384;
            SetLength(Buffer, lBuffer);
            if Assigned(StreamAnswer) then
              StreamAnswer.Size := 0;
            while InternetReadFile(hRequest, Buffer, lBuffer, BytesRead) do
            begin
              if Assigned(StreamAnswer) then
                StreamAnswer.Write(Buffer[0], BytesRead);
              if BytesRead < lBuffer then
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
    FHttpCli: THttpCli;
    FUserCancel: Integer;
    FWaiting: IWaiting;

    constructor Create;
    destructor Destroy; override;

    procedure RequestDone(Sender: TObject; RqType: THttpRequest; ErrCode: Word);
    procedure DocData(Sender: TObject; Buffer: Pointer; Len: Integer);

  end;

constructor TDownloader.Create;
begin
  inherited;
  FUserCancel := 0;
  FHttpCli := THttpCli.Create(nil);
  FHttpCli.Agent := Format('%s/%s', [ChangeFileExt(ExtractFileName(Application.ExeName), ''), GetInfoVersion(Application.ExeName)]);
  FHttpCli.AcceptLanguage := 'fr';
  FHttpCli.OnRequestDone := RequestDone;
  FHttpCli.OnDocData := DocData;
end;

destructor TDownloader.Destroy;
begin
  FWaiting := nil;
  FHttpCli.Free;
  inherited;
end;

procedure TDownloader.DocData(Sender: TObject; Buffer: Pointer; Len: Integer);
begin
  if FUserCancel > 0 then
    FHttpCli.Abort;
  if Assigned(FWaiting) then
    FWaiting.ShowProgression('', FHttpCli.RcvdCount, FHttpCli.ContentLength);
end;

procedure TDownloader.RequestDone(Sender: TObject; RqType: THttpRequest; ErrCode: Word);
begin
  // arrête le MessageLoop
  PostMessage(FHttpCli.CtrlSocket.Handle, WM_QUIT, 0, 0);
  FWaiting := nil;
end;

function LoadStreamURL(URL: string; const Pieces: array of RAttachement; StreamAnswer: TStream): Word;
var
  dummy: string;
begin
  Result := LoadStreamURL(URL, Pieces, StreamAnswer, dummy);
end;

function LoadStreamURL(URL: string; const Pieces: array of RAttachement; StreamAnswer: TStream; out DocName: string): Word;
var
  MemoryStream: TMemoryStream;
  fs: TFileStream;
  i: Integer;
  idRequete: string;
  httpHeader: RawByteString;
  dl: TDownloader;
begin
  idRequete := '26846888314793'; // valeur arbitraire: voir s'il faut la changer à chaque requête mais il semble que non
  MemoryStream := TMemoryStream.Create;
  dl := TDownloader.Create;
  with dl do
    try
      if Pos('%', URL) > 0 then
        FHttpCli.URL := URL
      else
        FHttpCli.URL := UrlEncode(URL);
      FHttpCli.SendStream := MemoryStream;
      FHttpCli.RcvdStream := StreamAnswer;

      MemoryStream.Position := 0;

      httpHeader := '';

      if Length(Pieces) > 0 then
      begin
        for i := Low(Pieces) to High(Pieces) do
          if Pieces[i].IsFichier then
          begin
            fs := TFileStream.Create(Pieces[i].Valeur, fmOpenRead or fmShareDenyWrite);
            try
              httpHeader := '-----------------------------' + UTF8Encode(idRequete) + #13#10;
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
            httpHeader := '-----------------------------' + UTF8Encode(idRequete) + #13#10;
            httpHeader := httpHeader + 'Content-Disposition: form-data; name="' + UTF8Encode(Pieces[i].Nom) + '"'#13#10;
            httpHeader := httpHeader + #13#10;
            httpHeader := httpHeader + UTF8Encode(Pieces[i].Valeur) + #13#10;
            MemoryStream.WriteBuffer(httpHeader[1], Length(httpHeader));
          end;

        httpHeader := '-----------------------------' + UTF8Encode(idRequete) + '--'#13#10;
        MemoryStream.WriteBuffer(httpHeader[1], Length(httpHeader));

        FHttpCli.ContentTypePost := 'multipart/form-data; charset=UTF-8; boundary=---------------------------' + idRequete;
      end;

      MemoryStream.Position := 0;

      FWaiting := TWaiting.Create('Chargement des données...', 1, @FUserCancel);
      // pour forcer la fenêtre à afficher des choses dès son apparition
      FWaiting.ShowProgression(URL, FHttpCli.RcvdCount, FHttpCli.ContentLength);
      if Length(Pieces) > 0 then
        FHttpCli.PostASync
      else
        FHttpCli.GetASync;

      FHttpCli.CtrlSocket.MessageLoop;
      Result := FHttpCli.StatusCode;
      // à remplacer pas la valeur du header 'filename' ou equivalent
      DocName := FHttpCli.ContentType;
    finally
      MemoryStream.Free;
      Free;
    end;
end;

end.

