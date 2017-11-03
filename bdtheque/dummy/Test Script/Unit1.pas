unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uPSComponent, StdCtrls, ActnList;

type
  TForm1 = class(TForm)
    PSScriptDebugger1: TPSScriptDebugger;
    mScript: TMemo;
    mResultat: TMemo;
    Button1: TButton;
    ActionList1: TActionList;
    actCompile: TAction;
    actRun: TAction;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure actCompileExecute(Sender: TObject);
    procedure actRunExecute(Sender: TObject);
    procedure mScriptChange(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure PSScriptDebugger1Compile(Sender: TPSScript);
  private
    { D�clarations priv�es }
    FCompiled: Boolean;
    procedure SetResultat(const Chaine: string);
  public
    { D�clarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses WinInet, StrUtils, Math;

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

procedure TForm1.SetResultat(const Chaine: string);
begin
  mResultat.Lines.Text := Chaine;
  Application.ProcessMessages;
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

procedure TForm1.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
begin
  Handled := True;
  actRun.Enabled := FCompiled;
end;

procedure TForm1.actCompileExecute(Sender: TObject);
var
  s: string;
  i: Integer;
begin
  PSScriptDebugger1.Script.Assign(mScript.Lines);
  FCompiled := PSScriptDebugger1.Compile;
  if not FCompiled then
  begin
    for i := 0 to Pred(PSScriptDebugger1.CompilerMessageCount) do
    begin
      s := PSScriptDebugger1.CompilerErrorToStr(i);
      if i < Pred(PSScriptDebugger1.CompilerMessageCount) then
        s := s + #13#10;
    end;
    mResultat.Lines.Text := 'Compilation error:'#13#10#13#10 + s;
  end
  else
    mResultat.Lines.Text := 'Compilation succedded';
end;

procedure TForm1.actRunExecute(Sender: TObject);
begin
  PSScriptDebugger1.Execute;
end;

procedure TForm1.mScriptChange(Sender: TObject);
begin
  FCompiled := False;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  actCompile.Execute;
  actRun.Execute;
end;

procedure TForm1.PSScriptDebugger1Compile(Sender: TPSScript);
begin
  PSScriptDebugger1.AddFunction(@GetPage, 'function GetPage(const url: string): string;');
  PSScriptDebugger1.AddMethod(Self, @TForm1.SetResultat, 'procedure SetHTML(const Chaine: string);');
  PSScriptDebugger1.AddFunction(@Format, 'function Format(const Format: string; const Args: array of const): string;');
  PSScriptDebugger1.AddFunction(@findInfo, 'function findInfo(const sDebut, sFin, sChaine, sDefault: string): string;');
  PSScriptDebugger1.AddFunction(@ShowMessage, 'procedure ShowMessage(const Msg: string);');
  PSScriptDebugger1.AddFunction(@PosEx, 'function PosEx(const SubStr, S: string; Offset: Cardinal): Integer;');
end;

end.

