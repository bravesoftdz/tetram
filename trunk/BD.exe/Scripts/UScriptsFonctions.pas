unit UScriptsFonctions;

interface

uses Windows, SysUtils, Classes, Dialogs, WinInet, StrUtils, Math;

function GetPage(const url: string): string;
function findInfo(const sDebut, sFin, sChaine, sDefault: string): string;

implementation

uses ProceduresBDtk;

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
    case GetLastError of
      ERROR_INSUFFICIENT_BUFFER:
        begin
          SetLength(Buffer, lBuffer);
          if not InternetGetLastResponseInfo(ErrorCode, @Buffer, lBuffer) then
            RaiseLastOsError;
        end;
    else
      RaiseLastOsError;
    end;
  if lBuffer = 0 then
    RaiseLastOSError
  else
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

  procedure GetInfo(Code: DWord);
  begin
    lBuffer := 1024;
    SetLength(Buffer, lBuffer);
    ZeroMemory(Buffer, lBuffer);
    dDummy := 0;
    if not HttpQueryInfo(hRequest, Code, Buffer, lBuffer, dDummy) then
      case GetLastError of
        ERROR_INSUFFICIENT_BUFFER:
          begin
            SetLength(Buffer, lBuffer);
            if not HttpQueryInfo(hRequest, Code, Buffer, lBuffer, dDummy) then RaiseLastOsError;
          end;
        ERROR_HTTP_HEADER_NOT_FOUND: // Header HTTP inconnu
      else
        RaiseLastOsError;
      end;
  end;

var
  Waiting: IWaiting;
  UserCancel, PageSize: Integer;
begin
  Waiting := TWaiting.Create('', 50, @UserCancel);
  try
    Result := '';
    Waiting.ShowProgression('Ouverture de la connexion internet...', 0, 0);
    hISession := InternetOpen(PChar(Format('%s/%s', ['test', 'script'])), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
    if UserCancel > 0 then Exit;
    if (hISession = nil) then
      RaiseLastOsError;
    try
      Waiting.ShowProgression('Recherche de la page...', 0, 0);
      hRequest := InternetOpenUrl(hISession, PChar(url), nil, 0, INTERNET_FLAG_PRAGMA_NOCACHE or INTERNET_FLAG_RELOAD or INTERNET_FLAG_RESYNCHRONIZE, 0);
      if UserCancel > 0 then Exit;

      if (hRequest = nil) then
        RaiseLastInternetError;
      try
        ss := TStringStream.Create('');
        try
          GetInfo(HTTP_QUERY_STATUS_CODE);
          ss.Size := 0;
          ss.Write(Buffer[0], lBuffer);
          if ss.DataString <> '200' then
          begin
            ss.WriteString(#13#10);
            GetInfo(HTTP_QUERY_STATUS_TEXT);
            ss.Write(Buffer[0], lBuffer);
            raise EOSError.Create(ss.DataString);
          end;

          GetInfo(HTTP_QUERY_CONTENT_LENGTH);
          ss.Size := 0;
          ss.Write(Buffer[0], lBuffer);
          PageSize := StrToIntDef(ss.DataString, 1);
          if PageSize = 0 then PageSize := 1;

          lBuffer := 4096;
          SetLength(Buffer, lBuffer);
          ss.Size := 0;
          Waiting.ShowProgression('Chargement de la page...', 0, PageSize);
          while InternetReadFile(hRequest, Buffer, lBuffer, BytesRead) and (BytesRead > 0) and (UserCancel = 0) do
          begin
            ss.Write(Buffer[0], BytesRead);
            if PageSize = 1 then
              Waiting.ShowProgression('Chargement de la page...', ss.Size mod (lBuffer * 10), lBuffer * 10)
            else
              Waiting.ShowProgression('Chargement de la page...', ss.Size, PageSize);
          end;
          if UserCancel > 0 then Exit;

          Result := ss.DataString;
        finally
          ss.Free;
        end;
      finally
        InternetCloseHandle(hRequest);
      end;
    finally
      InternetCloseHandle(hISession);
    end;
  except
    ShowMessage(Exception(ExceptObject).Message);
  end;
end;

end.

