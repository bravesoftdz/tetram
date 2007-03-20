unit Unit4;

interface

uses Windows, SysUtils, Classes, Dialogs, WinInet, StrUtils, Math;

function GetPage(const url: string): string;
function findInfo(const sDebut, sFin, sChaine, sDefault: string): string;

implementation

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
    if iFin = 0 then iFin := Length(sChaine);
    Result := Copy(sChaine, iDebut, iFin - iDebut);
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

function GetPage(const url: string): string;
const
  FLAG_ICC_FORCE_CONNECTION = 1;
var
  hISession, hRequest: HINTERNET;
  ss: TStringStream;
  BytesRead: Cardinal;
  Buffer: array of Char;
  lBuffer, dDummy: Cardinal;
  //  hPSession: HINTERNET;
  //  _url: URL_COMPONENTS;
begin
  try
    Result := '';
    hISession := InternetOpen(PChar(Format('%s/%s', ['test', 'script'])), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
    if (hISession = nil) then
      RaiseLastOsError;
    try
      //      ZeroMemory(@_url, SizeOf(_url));
      //      _url.dwStructSize := SizeOf(_url);
      //      _url.dwSchemeLength := 1;
      //      _url.dwHostNameLength := 1;
      //      _url.dwUserNameLength := 1;
      //      _url.dwPasswordLength := 1;
      //      _url.dwUrlPathLength := 1;
      //      _url.dwExtraInfoLength := 1;
      //
      //      InternetCrackUrl(PChar(url), 0, 0, _url);
      //      hPSession := InternetConnect(hISession, _url.lpszUrlPath, _url.nPort, _url.lpszUserName, _url.lpszPassword, ifthen(_url.nPort = 80, INTERNET_SERVICE_HTTP, INTERNET_SERVICE_FTP), 0, 0);
      //      hPSession := InternetConnect(hISession, 'www.encyclobd.com', _url.nPort, _url.lpszUserName, _url.lpszPassword, ifthen(_url.nPort = 80, INTERNET_SERVICE_HTTP, INTERNET_SERVICE_FTP), 0, 0);
      //      if (hPSession = nil) then RaiseLastOsError;
      //      try
      hRequest := InternetOpenUrl(hISession, PChar(url), nil, 0, INTERNET_FLAG_PRAGMA_NOCACHE or INTERNET_FLAG_RELOAD or INTERNET_FLAG_RESYNCHRONIZE, 0);
      //        hRequest := HttpOpenRequest(hPSession, 'GET', _url.lpszUrlPath, nil, nil, nil, INTERNET_FLAG_KEEP_CONNECTION, 0);
      //        hRequest := HttpOpenRequest(hPSession, 'GET', '/biblio/find.html?query=Lanfeust&submit.x=0&submit.y=0', nil, nil, nil, INTERNET_FLAG_KEEP_CONNECTION or INTERNET_FLAG_NO_CACHE_WRITE, 0);

      if (hRequest = nil) then
        RaiseLastInternetError;
      try
        //          if not HttpSendRequest(hRequest, nil, 0, nil, 0) then RaiseLastOSError;

        ss := TStringStream.Create('');
        try
          lBuffer := 1024;
          SetLength(Buffer, lBuffer);
          dDummy := 0;
          if not HttpQueryInfo(hRequest, HTTP_QUERY_STATUS_CODE, Buffer, lBuffer, dDummy) then
            if GetLastError = ERROR_INSUFFICIENT_BUFFER then
            begin
              SetLength(Buffer, lBuffer);
              if not HttpQueryInfo(hRequest, HTTP_QUERY_STATUS_CODE, Buffer, lBuffer, dDummy) then RaiseLastOsError;
            end
            else
              RaiseLastOsError;
          ss.Size := 0;
          ss.Write(Buffer[0], lBuffer);
          if ss.DataString <> '200' then
          begin
            ss.WriteString(#13#10);
            lBuffer := 1024;
            SetLength(Buffer, lBuffer);
            if not HttpQueryInfo(hRequest, HTTP_QUERY_STATUS_TEXT, Buffer, lBuffer, dDummy) then
              if GetLastError = ERROR_INSUFFICIENT_BUFFER then
              begin
                SetLength(Buffer, lBuffer);
                if not HttpQueryInfo(hRequest, HTTP_QUERY_STATUS_TEXT, Buffer, lBuffer, dDummy) then RaiseLastOsError;
              end
              else
                RaiseLastOsError;
            ss.Write(Buffer[0], lBuffer);
            raise EOSError.Create(ss.DataString);
          end;

          lBuffer := 4096;
          SetLength(Buffer, lBuffer);
          ss.Size := 0;
          while InternetReadFile(hRequest, Buffer, lBuffer, BytesRead) and (BytesRead > 0) do
          begin
            ss.Write(Buffer[0], BytesRead);
            //          if BytesRead < lBuffer then Break;
          end;

          Result := ss.DataString;
        finally
          ss.Free;
        end;
      finally
        InternetCloseHandle(hRequest);
      end;
      //      finally
      //        InternetCloseHandle(hPSession);
      //      end;
    finally
      InternetCloseHandle(hISession);
    end;
  except
    showmessage(exception(exceptobject).message);
  end;
end;


end.
 