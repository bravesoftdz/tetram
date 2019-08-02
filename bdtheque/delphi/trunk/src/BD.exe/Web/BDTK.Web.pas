unit BDTK.Web;

interface

uses
  System.SysUtils, System.Classes, BD.Common, BD.Utils.Net, Divers;

const
  ActionServerInfos = 0;
  ActionUpdateScript = 1;
  ActionSendOption = 2;
  ActionGetOption = 3;

type
  TWeb = class abstract
  private
    FURL: string;
    FReponse: TStringStream;
    FslReponse: TStringList;
    FDBVersion: TVersionNumber;

    FSite: TSiteWeb;
    FScript: string;
    FAddXMLHeader: Boolean;
    procedure SetSite(const Value: TSiteWeb);
    procedure SetScript(const Value: string);

    procedure BuildURL;
    procedure SetAddXMLHeader(const Value: Boolean);
  protected
    FParam: array of RAttachement;

    function GetParamLengthMin: Integer; virtual;

    function CleanHTTP(Valeur: string): string;
    function GetCode(index: Integer): string;
    function GetLabel(var index: Integer): string;
    function IsError(index: Integer): Boolean;
    procedure Decoupe(index: Integer; out s1, s2: string);
    procedure PostHTTP;

    procedure SendOption(const cle, Valeur: string); virtual; abstract;
    function GetOption(const cle: string): string;
  public
    constructor Create(Site: TSiteWeb; const Script: string); virtual;
    destructor Destroy; override;

    procedure SendData(Action: Integer; const Data: string = '');
    procedure CheckVersions;
    procedure UpgradeDB;

    property ParamLengthMin: Integer read GetParamLengthMin;

    property AddXMLHeader: Boolean read FAddXMLHeader write SetAddXMLHeader;

    property Site: TSiteWeb read FSite write SetSite;
    property Script: string read FScript write SetScript;

    property DBVersion: TVersionNumber read FDBVersion;
  end;

implementation

uses
  JclMime, BDTK.Updates;

{ TWeb }

procedure TWeb.BuildURL;
begin
  FURL := FSite.Adresse;
  if (FURL <> '') and (FURL[Length(FURL)] <> '/') then
    FURL := FURL + '/';
  FURL := FURL + FScript;
end;

procedure TWeb.CheckVersions;
type
  TCheckConf = reference to function(const confCode: string): Boolean;
var
  i: Integer;
  lstValues: TStringList;
  CheckConf: TCheckConf;
  s1, s2: string;
begin
  SendData(ActionServerInfos);

  Decoupe(0, s1, s2);
  if (s1 <> 'intf_version') then
    raise Exception.Create('Erreur inattendue: '#13#10 + FslReponse.Text);
  if (TVersionNumber(s2) < '1') then
    raise Exception.Create('Version d''interface non supportée.'#13#10'Veuillez mettre à jour BDThèque.')
  else if (TVersionNumber(s2) = '1') then
  begin
    Decoupe(1, s1, s2);
    if s1 <> 'php_version' then
      raise Exception.Create('Erreur inattendue: '#13#10 + FslReponse.Text);
    if Copy(s2, Length(s2) - 2, 2) <> 'OK' then
      raise Exception.Create('La version de php disponible sur le serveur est insuffisante.'#13#10'Veuillez utiliser un autre hébergeur.');

    Decoupe(2, s1, s2);
    if s1 <> 'XML' then
      raise Exception.Create('Erreur inattendue: '#13#10 + FslReponse.Text);
    if Copy(s2, Length(s2) - 2, 2) <> 'OK' then
      raise Exception.Create('Le support XML n''est pas présent dans le moteur php du serveur.'#13#10'Veuillez utiliser un autre hébergeur.');

    // Decoupe(3, s1, s2); // support JSON

    i := 5;
    if IsError(4) then
      raise Exception.Create
        ('Impossible de se connecter à la base de données MySQL:'#13#10'- vérifier le paramétrage de la base de données'#13#10'- Assurez-vous que le modèle est bien chargé sur le site après avoir regénéré le site'#13#10#13#10
        + GetLabel(i));
    Decoupe(4, s1, s2);
    if s1 <> 'mysql_version' then
      raise Exception.Create('Erreur inattendue: '#13#10 + FslReponse.Text);
    if Copy(s2, Length(s2) - 2, 2) <> 'OK' then
      raise Exception.Create('La version de MySQL disponible sur le serveur est insuffisante.'#13#10'Veuillez utiliser un autre hébergeur.');

    Decoupe(5, s1, s2);
    if s1 <> 'db_version' then
      raise Exception.Create('Erreur inattendue: '#13#10 + FslReponse.Text);
    FDBVersion := s2;
  end
  else
  begin
    lstValues := TStringList.Create;
    try
      for i := 0 to Pred(FslReponse.Count) do
      begin
        Decoupe(i, s1, s2);
        lstValues.Values[s1] := s2;
      end;

      CheckConf := function(const confCode: string): Boolean
        begin
          i := lstValues.IndexOfName(confCode);
          if i = -1 then
            raise Exception.Create('Erreur inattendue: '#13''#10'' + FslReponse.Text);
          Result := SameText(Copy(lstValues.ValueFromIndex[i], Length(lstValues.ValueFromIndex[i]) - 2, 2), 'OK');
        end;

      if not CheckConf('php_version') then
        raise Exception.Create('La version de php disponible sur le serveur est insuffisante.'#13''#10'Veuillez utiliser un autre hébergeur.');
      if not CheckConf('XML') then
        raise Exception.Create('Le support XML n''est pas présent dans le moteur php du serveur.'#13#10'Veuillez utiliser un autre hébergeur.');
      if not CheckConf('MYSQLI') then
        raise Exception.Create('Le support MySQLi n''est pas présent dans le moteur php du serveur.'#13#10'Veuillez utiliser un autre hébergeur.');

      if not CheckConf('DB') then
        raise Exception.Create
          ('Impossible de se connecter à la base de données MySQL:'#13#10'- vérifier le paramétrage de la base de données et que la base de données est accessible'#13#10'- Assurez-vous que le modèle est bien chargé sur le site après avoir regénéré le site'#13#10#13#10
          + lstValues.ValueFromIndex[i + 1])
      else
      begin
        if not CheckConf('mysql_version') then
          raise Exception.Create('La version de MySQL disponible sur le serveur est insuffisante.'#13#10'Veuillez utiliser un autre hébergeur.');
        FDBVersion := lstValues.Values['db_version'];
        if FDBVersion = '' then
          raise Exception.Create('Erreur inattendue: '#13#10 + FslReponse.Text);
      end;
    finally
      lstValues.Free;
    end;
  end
  // else
  // raise Exception.Create('Version d''interface non supportée.'#13#10'Veuillez mettre à jour BDThèque.');
end;

function TWeb.CleanHTTP(Valeur: string): string;
var
  c: PChar;
begin
  Result := '';
  if Length(Valeur) > 0 then
  begin
    Valeur := Valeur + #0;
    c := @Valeur[1];
    while c^ <> #0 do
    begin
      case c^ of
        ' ', '0' .. '9', 'a' .. 'z', 'A' .. 'Z':
          Result := Result + c^;
      else
        Result := Result + '&#' + IntToStr(Ord(c^)) + ';';
      end;
      Inc(c);
    end;
  end;
end;

constructor TWeb.Create(Site: TSiteWeb; const Script: string);
begin
  FReponse := TStringStream.Create('');
  FslReponse := TStringList.Create;

  AddXMLHeader := False;

  SetLength(FParam, ParamLengthMin);
  FParam[0].Nom := 'auth_key';
  FParam[0].Valeur := '';
  FParam[1].Nom := 'isExe';
  FParam[1].Valeur := '';

  Self.Site := Site;
  Self.Script := Script;
end;

procedure TWeb.Decoupe(index: Integer; out s1, s2: string);
var
  s: string;
begin
  s := GetLabel(index);
  s1 := Copy(s, 1, Pos('=', s) - 1);
  s2 := Copy(s, Pos('=', s) + 1, MaxInt);
end;

destructor TWeb.Destroy;
begin
  FReponse.Free;
  FslReponse.Free;
  inherited;
end;

function TWeb.GetCode(index: Integer): string;
begin
  if index >= FslReponse.Count then
    Exit('');

  Result := FslReponse[index];
  if Pos(':', Result) > 0 then
    Result := Copy(Result, 1, Pos(':', Result) - 1);
end;

function TWeb.GetLabel(var index: Integer): string;
var
  Code, Ligne: string;
begin
  if index >= FslReponse.Count then
    Exit('');

  Code := GetCode(index);
  Ligne := FslReponse[index];
  Result := Copy(Ligne, Length(Code) + 3, Length(Ligne));
  Inc(index);
  while (FslReponse.Count > index) and (GetCode(index) = '') do
  begin
    Ligne := FslReponse[index];
    Result := Result + #13#10 + Copy(Ligne, Length(Code) + 3, Length(Ligne));
    Inc(index);
  end;
  Dec(index);
end;

function TWeb.GetOption(const cle: string): string;
var
  i: Integer;
begin
  SetLength(FParam, ParamLengthMin + 2);
  FParam[ParamLengthMin + 0].Nom := 'action';
  FParam[ParamLengthMin + 0].Valeur := IntToStr(ActionGetOption);
  FParam[ParamLengthMin + 1].Nom := 'cle';
  FParam[ParamLengthMin + 1].Valeur := cle;
  PostHTTP;
  i := 0;
  Result := GetLabel(i);
end;

function TWeb.GetParamLengthMin: Integer;
begin
  Result := 2;
end;

function TWeb.IsError(index: Integer): Boolean;
begin
  Result := GetCode(index) = 'ERROR';
end;

procedure TWeb.PostHTTP;
var
  l: Integer;
  s: string;
begin
  FReponse.Size := 0;
  if LoadStreamURL(FURL, FParam, FReponse, False) <> 200 then
    raise Exception.Create
      ('Impossible d''accéder au site:'#13#10'- vérifiez le paramétrage de l''adresse'#13#10'- assurez-vous que le modèle est bien chargé sur le site'#13#10'- vérifiez que votre parefeu ne bloque pas la connexion');
  FReponse.Position := 0;
  FslReponse.LoadFromStream(FReponse);
  // Memo1.Lines.Text := FReponse.DataString;
  l := 0;
  s := GetLabel(l);
  Inc(l);
  if IsError(0) then
    raise Exception.Create('Erreur inattendue : ' + s + #13#10 + GetLabel(l));
end;

procedure TWeb.SendData(Action: Integer; const Data: string);
begin
  if Data <> '' then
    SetLength(FParam, ParamLengthMin + 2)
  else
    SetLength(FParam, ParamLengthMin + 1);

  FParam[ParamLengthMin + 0].Nom := 'action';
  FParam[ParamLengthMin + 0].Valeur := IntToStr(Action);
  if Data <> '' then
  begin
    FParam[ParamLengthMin + 1].Nom := 'data';
    if AddXMLHeader and (Action <> ActionUpdateScript) then
      FParam[ParamLengthMin + 1].Valeur := string(MimeEncodeString('<?xml version="1.0" encoding="ISO-8859-1"?>' + AnsiString(UTF8String(Data))))
    else
      FParam[ParamLengthMin + 1].Valeur := string(MimeEncodeString(AnsiString(UTF8String(Data))));
  end;
  PostHTTP;
end;

procedure TWeb.SetAddXMLHeader(const Value: Boolean);
begin
  FAddXMLHeader := Value;
end;

procedure TWeb.SetScript(const Value: string);
begin
  FScript := Value;
  BuildURL;
end;

procedure TWeb.SetSite(const Value: TSiteWeb);
begin
  FSite := Value;
  FParam[0].Valeur := FSite.cle;
  BuildURL;
end;

procedure TWeb.UpgradeDB;
var
  SQL: TStringList;
  MySQLUpdate: TMySQLUpdate;
  UpgradeToDBVersion: TVersionNumber;
begin
  UpgradeToDBVersion := FSite.BddVersion;
  if UpgradeToDBVersion = '' then
    UpgradeToDBVersion := TMySQLUpdate(ListMySQLUpdates[Pred(ListMySQLUpdates.Count)]).Version;

  if UpgradeToDBVersion > FDBVersion then
    for MySQLUpdate in ListMySQLUpdates do
    begin
      if UpgradeToDBVersion < MySQLUpdate.Version then
        Break;
      if MySQLUpdate.Version > FDBVersion then
      begin
        SQL := TStringList.Create;
        try
          MySQLUpdate.UpdateCallback(SQL);

          SendData(ActionUpdateScript, SQL.Text);
          SendOption('version', MySQLUpdate.Version);
          FDBVersion := MySQLUpdate.Version;
        finally
          SQL.Free;
        end;

      end;
    end;
end;

end.
