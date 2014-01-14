unit UfrmSynchroniser;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, UBdtForms;

type
  TfrmSynchroniser = class(TBdtForm)
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    Button1: TButton;
    Memo1: TMemo;
    CheckBox1: TCheckBox;
    Label8: TLabel;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton3: TRadioButton;
    procedure Button1Click(Sender: TObject);
  private
  public
    { Déclarations publiques }
  end;

implementation

uses
  CommonConst, System.IOUtils, UNet, JclMime, UWeb, dwsJSON;

{$R *.dfm}

type
  TSynchoWeb = class(TWeb)
  private
    FDeviceID: string;
    procedure SetDeviceID(const Value: string);
  public const
    ActionAskSynchro = 4;
    ActionEndSynchro = 5;

  protected
    function GetParamLengthMin: Integer; override;

    procedure SendOption(const cle, Valeur: string); override;
  public
    constructor Create; reintroduce;

    procedure AskForSynchro;
    procedure EndSynchro;

    property DeviceID: string read FDeviceID write SetDeviceID;
  end;

procedure TfrmSynchroniser.Button1Click(Sender: TObject);
var
  UpgradeFromDate: TDate;
  web: TSynchoWeb;
  StartTime: TDateTime;
begin
  StartTime := Now;

  web := TSynchoWeb.Create;
  try
    web.AskForSynchro;
    try
      web.CheckVersions;
      web.UpgradeDB;

      if RadioButton1.Checked then
        UpgradeFromDate := StrToDateDef(web.GetOption('lastsynchro'), -1, TGlobalVar.SQLSettings)
      else
        UpgradeFromDate := -1;

      web.SendOption('lastsynchro', DateToStr(StartTime, TGlobalVar.SQLSettings));
    finally
      web.EndSynchro;
    end;
  finally
    web.Free;
  end;
end;

{ TSynchoWeb }

procedure TSynchoWeb.AskForSynchro;
var
  s: string;
  i: Integer;
begin
  SendData(ActionAskSynchro);
  i := 0;
  s := GetLabel(i);
  if s = 'KO' then
    raise Exception.Create('Une synchronisation est déjà en cours. Veuillez patienter.');
  DeviceID := s;
end;

constructor TSynchoWeb.Create;
begin
  inherited Create(TGlobalVar.Utilisateur.Options.ServerSynchro, 'synchro.php');
  FParam[inherited GetParamLengthMin + 0].Nom := 'deviceid';
  FParam[inherited GetParamLengthMin + 0].Valeur := '';
end;

procedure TSynchoWeb.EndSynchro;
begin
  if DeviceID = '' then
    Exit;

  SetLength(FParam, ParamLengthMin + 1);
  FParam[ParamLengthMin + 0].Nom := 'done';
  FParam[ParamLengthMin + 0].Valeur := 'KO';
  SendData(ActionEndSynchro);
end;

function TSynchoWeb.GetParamLengthMin: Integer;
begin
  Result := inherited GetParamLengthMin + 1;
end;

procedure TSynchoWeb.SendOption(const cle, Valeur: string);
var
  obj, rec, data: TdwsJSONObject;
begin
  obj := TdwsJSONObject.Create;
  try
    obj.AddValue('table', 'options');
    obj.AddValue('primarykey', 'cle');
    rec := obj.AddArray('records').AddObject;
    data := rec.AddObject('data');
    data.AddValue('cle', cle);
    data.AddValue('valeur', Valeur);
    SendData(ActionSendOption, obj.ToString);
  finally
    obj.Free;
  end;
end;

procedure TSynchoWeb.SetDeviceID(const Value: string);
begin
  FDeviceID := Value;
  FParam[inherited GetParamLengthMin + 0].Valeur := FDeviceID;
end;

end.
