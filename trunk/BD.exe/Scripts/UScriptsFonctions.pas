unit UScriptsFonctions;

interface

uses
  Windows, SysUtils, Classes, Dialogs, WinInet, StrUtils, Math, UMetadata, TypeRec;

function GetPage(const url: string): string;
function findInfo(const sDebut, sFin, sChaine, sDefault: string): string;
function MakeAuteur(const Nom: string; Metier: TMetierAuteur): TAuteur;
function AskSearchEntry(const Labels: array of string; out Search: string; out Index: Integer): Boolean;
function MyFormat(const Fmt: string; Args: array of const): string;
function MyFormatString(const Fmt: string; const Args: array of string): string;

implementation

uses
  ProceduresBDtk, UBdtForms, DBEditLabeled, StdCtrls, Controls, Forms, UframBoutons;

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
          if not HttpQueryInfo(hRequest, Code, Buffer, lBuffer, dDummy) then
            RaiseLastOsError;
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
  PageSize := 1;
  Waiting := TWaiting.Create('', 50, @UserCancel);
  try
    Result := '';
    Waiting.ShowProgression('Ouverture de la connexion internet...', 0, 0);
    hISession := InternetOpen(PChar(Format('%s/%s', ['test', 'script'])), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
    if UserCancel > 0 then
      Exit;
    if (hISession = nil) then
      RaiseLastOsError;
    try
      Waiting.ShowProgression('Recherche de la page...', 0, 0);
      hRequest := InternetOpenUrl(hISession, PChar(string(url)), nil, 0, INTERNET_FLAG_PRAGMA_NOCACHE or INTERNET_FLAG_RELOAD or INTERNET_FLAG_RESYNCHRONIZE, 0);
      if UserCancel > 0 then
        Exit;

      if (hRequest = nil) then
        RaiseLastInternetError;
      try
        ss := TStringStream.Create('', TEncoding.Unicode);
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
          if PageSize = 0 then
            PageSize := 1;
        finally
          ss.Free;
        end;

        ss := TStringStream.Create('', TEncoding.UTF8);
        try
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
          if UserCancel > 0 then
            Exit;

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

function AskSearchEntry(const Labels: array of string; out Search: string; out Index: Integer): Boolean;
var
  F: TdummyForm;
  E: TEditLabeled;
  L: TLabel;
  i, t: Integer;
begin
  Result := False;
  if Length(Labels) = 0 then
    Exit;
  t := 0;
  F := TdummyForm.Create(nil);
  try
    F.Position := poMainFormCenter;
    E := nil;

    for i := Low(Labels) to High(Labels) do
    begin
      E := TEditLabeled.Create(F);
      E.Parent := F;
      E.Tag := i;
      L := TLabel.Create(F);
      L.Parent := F;

      L.WordWrap := True;
      L.Caption := Labels[i];
      L.Left := 0;
      L.Width := 150;
      L.AutoSize := False;
      L.Visible := True;

      E.BevelKind := bkTile;
      E.BorderStyle := bsNone;
      E.LinkControls.Add(L);
      E.Left := L.Left + L.Width + 8;
      E.Width := 250;
      E.Visible := True;
      E.OnChange := F.editChange;

      if E.Height > L.Height then
      begin
        E.Top := t;
        t := t + E.Height + 8;
        L.Top := E.Top + (E.Height - L.Height) div 2;
      end
      else
      begin
        L.Top := t;
        t := t + L.Height + 8;
        E.Top := L.Top + (L.Height - E.Height) div 2;
      end;
    end;

    with TframBoutons.Create(F) do
    begin
      Align := alNone;
      Parent := F;
      Top := t + 8;
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
          with F.Controls[i] as TEditLabeled do begin
            Search := Trim(Text);
            Index := Tag;
          end;
      Result := Search <> '';
    end;
  finally
    F.Free;
  end;
end;

function MyFormat(const Fmt: string; Args: array of const): string;
begin
  result := format(Fmt, args);
end;

function MyFormatString(const Fmt: string; const Args: array of string): string;
begin
  result := format(fmt, [args[0], args[1]]);
end;

end.

