unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UInterfacePlugIn, Dialogs, UInterfaceChange, Spin, StdCtrls;

type
  TFMain = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    RadioButton2: TRadioButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    RadioButton1: TRadioButton;
    Label5: TLabel;
    procedure RadioButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FWriter: IOptionsWriter;
  public
    { Déclarations publiques }
  end;

  TPlugin = class(TInterfacedObject, IPlugin, IConfiguration, IForceImage, IEvenements)
  private
    // interface IPlugin
    function GetName: ShortString; stdcall;
    function GetDescription: ShortString; stdcall;
    function GetAuthor: ShortString; stdcall;
    function GetAuthorContact: ShortString; stdcall;

    // interface IConfiguration
    function Configure(Writer: IOptionsWriter): Boolean; stdcall;
    procedure RelireOptions(Writer: IOptionsWriter); stdcall;

    // interface IForceImage
    function ForceImage(var Image, Archive: ShortString; out UtiliserHistorique: Boolean): Boolean; stdcall;

    // interface IEvenements
    procedure DemarrageWP; stdcall;
    procedure FermetureWP; stdcall;
    procedure DebutRechercheFond; stdcall;
    procedure FinRechercheFond; stdcall;
    procedure DebutDessinFond(Dessineur: IDessineur); stdcall;
    procedure FinDessinFond(Dessineur: IDessineur); stdcall;
    procedure AvantApplicationNouveauFond; stdcall;
    procedure ApresApplicationNouveauFond; stdcall;
  public
    FMainProg: IMainProg;
    FTemp, FTempFileName: string;
    constructor Create(MainProg: IMainProg);
    destructor Destroy; override;

    function RechercheImage: string;
    function TelechargerImage(Adresse, Fichier: string): Boolean;
  end;

var
  Plugin: TPlugin;

implementation

{$R *.dfm}

uses WinInet;

type
  ROptions = record
    Adresse: string;
    Debut, Fin, Remplissage: Integer;
    AdresseFixe: Boolean;
  end;

procedure LoadOptions(Writer: IOptionsWriter; var Options: ROptions);
begin
  with Writer do begin
    Options.Adresse := ReadString('Options', 'Adresse', '');
    Options.Debut := ReadInteger('Options', 'Debut', 0);
    Options.Fin := ReadInteger('Options', 'Fin', 0);
    Options.Remplissage := ReadInteger('Options', 'Remplissage', 1);
    Options.AdresseFixe := ReadBool('Options', 'AdresseFixe', True);
  end;
end;

procedure SaveOptions(Writer: IOptionsWriter; Options: ROptions);
begin
  with Writer do begin
    WriteString('Options', 'Adresse', Options.Adresse);
    WriteInteger('Options', 'Debut', Options.Debut);
    WriteInteger('Options', 'Fin', Options.Fin);
    WriteInteger('Options', 'Remplissage', Options.Remplissage);
    WriteBool('Options', 'AdresseFixe', Options.AdresseFixe);
  end;
end;

{ TPlugin }

procedure TPlugin.ApresApplicationNouveauFond;
begin
  DeleteFile(FTempFileName);
end;

procedure TPlugin.AvantApplicationNouveauFond;
begin

end;

function TPlugin.Configure(Writer: IOptionsWriter): Boolean;
begin
  with TFMain.Create(nil) do try
    FWriter := Writer;
    Result := ShowModal = mrOk;
  finally
    Free;
  end;
end;

constructor TPlugin.Create(MainProg: IMainProg);
var
  buffer: array[0..MAX_PATH] of Char;
begin
  FMainProg := MainProg;
  ZeroMemory(@buffer, SizeOf(buffer));
  GetTempPath(MAX_PATH, @buffer);
  FTemp := buffer;
end;

procedure TPlugin.DebutDessinFond(Dessineur: IDessineur);
begin

end;

procedure TPlugin.DebutRechercheFond;
begin

end;

procedure TPlugin.DemarrageWP;
begin

end;

destructor TPlugin.Destroy;
begin
  FMainProg := nil;
  inherited;
end;

procedure TPlugin.FermetureWP;
begin

end;

procedure TPlugin.FinDessinFond(Dessineur: IDessineur);
begin

end;

procedure TPlugin.FinRechercheFond;
begin

end;

function TPlugin.ForceImage(var Image, Archive: ShortString; out UtiliserHistorique: Boolean): Boolean;
begin
  UtiliserHistorique := False;
  Archive := '';
  Image := RechercheImage;
  Result := Image <> '';
end;

function TPlugin.GetAuthor: ShortString;
begin
  Result := 'Teträm Corp';
end;

function TPlugin.GetAuthorContact: ShortString;
begin
  Result := 'http://www.tetram.org';
end;

function TPlugin.GetDescription: ShortString;
begin
  Result := 'Ce plugin permet d''utiliser Internet comme source d''images.'
end;

function TPlugin.GetName: ShortString;
begin
  Result := 'SourceNet';
end;

function TPlugin.RechercheImage: string;
var
  bFileName: array[0..MAX_PATH] of Char;
  Adresse: string;
  Options: ROptions;
  i: Integer;
  boucle: Integer;
  s: string;
begin
  Result := '';
  ZeroMemory(@bFileName, SizeOf(bFileName));
  GetTempFileName(PChar(FTemp), 'wp', 0, @bFileName);
  FTempFileName := bFileName;

  LoadOptions(FMainProg.OptionsWriter, Options);
  boucle := 0;
  repeat
    Adresse := Options.Adresse;
    if not Options.AdresseFixe then begin
      i := Pos('%#%', Adresse);
      if i <> 0 then begin
        s := Format('%d', [Round(Random(Options.Fin - Options.Debut + 1))]);
        while Length(s) < Options.Remplissage do
          s := '0' + s;
        Adresse := Copy(Adresse, 1, i - 1) + s + Copy(Adresse, i + 3, Length(Adresse));
      end;
    end;

    if TelechargerImage(Adresse, FTempFileName) then begin
      Result := ChangeFileExt(FTempFileName, ExtractFileExt(Adresse));
      RenameFile(FTempFileName, Result);
      FTempFileName := Result;
    end;
    Inc(boucle);
  until (not Options.AdresseFixe) and ((Result <> '') or (boucle > 10));
end;

procedure TPlugin.RelireOptions(Writer: IOptionsWriter);
begin
  // les options sont relues au moment de la recherche de l'image
end;

function TPlugin.TelechargerImage(Adresse, Fichier: string): Boolean;

  procedure RaiseLastInternetError;
  var
    Buffer: array of Char;
    lBuffer: Cardinal;
    ErrorCode: DWord;
  begin
    lBuffer := 1024;
    SetLength(Buffer, lBuffer);
    if not InternetGetLastResponseInfo(ErrorCode, @Buffer, lBuffer) then begin
      if GetLastError = ERROR_INSUFFICIENT_BUFFER then begin
        SetLength(Buffer, lBuffer);
        if not InternetGetLastResponseInfo(ErrorCode, @Buffer, lBuffer) then RaiseLastOsError;
      end
      else
        RaiseLastOsError;
    end;
    raise EOSError.Create(PChar(@Buffer));
  end;

const
  FLAG_ICC_FORCE_CONNECTION = 1;
var
  Buffer: array of Char;
  lBuffer, dDummy: Cardinal;
  hISession, hRequest: HINTERNET;
  BytesRead: Cardinal;
  f: TFileStream;
  ss: TStringStream;
begin
  Result := False;
  hISession := InternetOpen(PChar('WallPepper-SourceNet'), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if (hISession = nil) then RaiseLastOsError;
  try
    hRequest := InternetOpenUrl(hISession, PChar(Adresse), nil, 0, INTERNET_FLAG_PRAGMA_NOCACHE or INTERNET_FLAG_RELOAD or INTERNET_FLAG_RESYNCHRONIZE, 0);
    if (hRequest = nil) then RaiseLastInternetError;
    try
      f := TFileStream.Create(Fichier, fmOpenWrite or fmShareExclusive);
      ss := TStringStream.Create('');
      try
        lBuffer := 1024;
        SetLength(Buffer, lBuffer);
        dDummy := 0;
        if not HttpQueryInfo(hRequest, HTTP_QUERY_STATUS_CODE, Buffer, lBuffer, dDummy) then
          if GetLastError = ERROR_INSUFFICIENT_BUFFER then begin
            SetLength(Buffer, lBuffer);
            if not HttpQueryInfo(hRequest, HTTP_QUERY_STATUS_CODE, Buffer, lBuffer, dDummy) then RaiseLastOsError;
          end
          else
            RaiseLastOsError;

        ss.Size := 0;
        ss.Write(Buffer[0], lBuffer);
        if ss.DataString <> '200' then begin
//          ss.WriteString(#13#10);
//          lBuffer := 1024;
//          SetLength(Buffer, lBuffer);
//          if not HttpQueryInfo(hRequest, HTTP_QUERY_STATUS_TEXT, Buffer, lBuffer, dDummy) then
//            if GetLastError = ERROR_INSUFFICIENT_BUFFER then begin
//              SetLength(Buffer, lBuffer);
//              if not HttpQueryInfo(hRequest, HTTP_QUERY_STATUS_TEXT, Buffer, lBuffer, dDummy) then RaiseLastOsError;
//            end
//            else
//              RaiseLastOsError;
//          ss.Write(Buffer[0], lBuffer);
//          raise EOSError.Create(ss.DataString);
          Exit;
        end;

        lBuffer := 4096;
        SetLength(Buffer, lBuffer);
        f.Size := 0;
        while InternetReadFile(hRequest, Buffer, lBuffer, BytesRead) do begin
          f.Write(Buffer[0], BytesRead);
          if BytesRead < lBuffer then Break;
        end;

        Result := True;
      finally
        ss.Free;
        f.Free;
      end;
    finally
      InternetCloseHandle(hRequest);
    end;
  finally
    InternetCloseHandle(hISession);
  end;
end;

procedure TFMain.RadioButton2Click(Sender: TObject);
begin
  GroupBox1.Enabled := RadioButton2.Checked;
  SpinEdit1.Enabled := GroupBox1.Enabled;
  SpinEdit2.Enabled := GroupBox1.Enabled;
  SpinEdit3.Enabled := GroupBox1.Enabled;
end;

procedure TFMain.FormShow(Sender: TObject);
var
  Options: ROptions;
begin
  LoadOptions(FWriter, Options);
  Edit1.Text := Options.Adresse;
  RadioButton2.Checked := not Options.AdresseFixe;
  SpinEdit1.Value := Options.Debut;
  SpinEdit2.Value := Options.Fin;
  SpinEdit3.Value := Options.Remplissage;
  RadioButton2Click(nil);
end;

procedure TFMain.Button1Click(Sender: TObject);
var
  Options: ROptions;
begin
  Options.Adresse := Edit1.Text;
  Options.AdresseFixe := RadioButton1.Checked;
  Options.Debut := SpinEdit1.Value;
  Options.Fin := SpinEdit2.Value;
  Options.Remplissage := SpinEdit3.Value;
  SaveOptions(FWriter, Options);
end;

initialization
  Randomize;

end.

