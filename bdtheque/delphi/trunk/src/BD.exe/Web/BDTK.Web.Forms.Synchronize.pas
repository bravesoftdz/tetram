unit BDTK.Web.Forms.Synchronize;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, BD.GUI.Forms;

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
    { D�clarations publiques }
  end;

implementation

uses
  BD.Common, System.IOUtils, BD.Utils.Net, JclMime, BDTK.Web, dwsJSON;

{$R *.dfm}

type
  TSynchroWeb = class(TWeb)
  private
    FStartTime: TDateTime;
    FUpgradeFromDate: TDate;
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
    procedure Synchro;

    property DeviceID: string read FDeviceID write SetDeviceID;
  end;

procedure TfrmSynchroniser.Button1Click(Sender: TObject);
var
  UpgradeFromDate: TDate;
  web: TSynchroWeb;
begin
  web := TSynchroWeb.Create;
  try
    web.AskForSynchro;
    try
      web.CheckVersions;
      web.UpgradeDB;

      if RadioButton1.Checked then
        web.FUpgradeFromDate := StrToDateDef(web.GetOption('lastsynchro'), -1, TGlobalVar.SQLSettings)
      else
        web.FUpgradeFromDate := -1;

      web.Synchro;
    finally
      web.EndSynchro;
    end;
  finally
    web.Free;
  end;
end;

{ TSynchroWeb }

procedure TSynchroWeb.AskForSynchro;
var
  s: string;
  i: Integer;
begin
  FStartTime := Now;
  SendData(ActionAskSynchro);
  i := 0;
  s := GetLabel(i);
  if s = 'KO' then
    raise Exception.Create('Une synchronisation est d�j� en cours. Veuillez patienter.');
  DeviceID := s;
end;

constructor TSynchroWeb.Create;
begin
  inherited Create(TGlobalVar.Utilisateur.Options.ServerSynchro, 'synchro.php');
  FParam[inherited GetParamLengthMin + 0].Nom := 'deviceid';
  FParam[inherited GetParamLengthMin + 0].Valeur := '';
end;

procedure TSynchroWeb.EndSynchro;
begin
  if DeviceID = '' then
    Exit;

  SetLength(FParam, ParamLengthMin + 1);
  FParam[ParamLengthMin + 0].Nom := 'done';
  FParam[ParamLengthMin + 0].Valeur := 'KO';
  SendData(ActionEndSynchro);
end;

function TSynchroWeb.GetParamLengthMin: Integer;
begin
  Result := inherited GetParamLengthMin + 1;
end;

procedure TSynchroWeb.SendOption(const cle, Valeur: string);
var
  obj: TdwsJSONObject;
begin
  obj := TdwsJSONObject.Create;
  try
    obj.AddValue('cle', cle);
    obj.AddValue('valeur', Valeur);
    SendData(ActionSendOption, obj.ToString);
  finally
    obj.Free;
  end;
end;

procedure TSynchroWeb.SetDeviceID(const Value: string);
begin
  FDeviceID := Value;
  FParam[inherited GetParamLengthMin + 0].Valeur := FDeviceID;
end;

procedure TSynchroWeb.Synchro;
begin
(*
  principe:
    * 3 modes de synchro: classique, reset du client, reset du serveur
    * le serveur ne fait aucune r�solution de conflit: elles sont faites par les applis, le serveur accepte tout ce qu'on lui envoie
    * l'appli applique les modifs distantes et r�soud les conflits
      et envoie ses modifs locales restantes
    * la synchro peut �tre annul�e pendant la r�solution de conflit: on applique toutes les modifs ou on n'en applique aucune
    * un �l�ment (par ex un album) est en conflit si un �l�ment dont il d�pend (par ex un auteur) est en conflit ou supprim�
    * si un �l�ment n'est plus en conflit, tous les �l�ments qui en d�pendent en conflit uniquement � cause de lui ne sont plus en conflit
      donc le conflit d'un �l�ment � cause d'un �l�ment supprim� ne peut �tre r�solu que manuellement
    * un conflit se r�soud sur un �l�ment dans son int�gralit� (et non propri�t� par propri�t�)
      mais si le conflit porte sur des propri�t�s diff�rentes, la r�solution est automatique
    * le serveur conserve les diff�rentes versions (n�cessaire pour la r�solution de conflit)

  implementation (cf svn):
    * update (recup�ration des modifs du serveur)
    * resolution des conflits
    * commit des modifs restantes
  n�cessite d'avoir
    - la date de derni�re synchro (ok),
    - et l'�tat "modifi� localement" (soit par comparaison avec une copie de ce qu'a le serveur, soit par un flag, soit...)

  Avant update:
    Date synchro = Null -> jamais synchronis�, cr�ation � envoyer
    Date synchro < Date modif -> modifi�, modifications � envoyer
    Date synchro > Date modif -> non modifi�, rien � faire

  Pendant update:
    Date synchro < Date modif -> modifi�, conflit � r�soudre
    Date synchro > Date modif -> non modifi�, mettre � jour -> Date synchro := Now
    Element supprim� -> conflit � r�soudre

  Resolution du conflit:
/!\ la diff�rence de date n'implique pas une diff�rence r�elle de donn�es !!
/!\ Appliquer le revert complet dans le cas o� il n'y a aucune modif r�elle
    Revert complet: Date modif := old Date synchro, Date synchro := Now
    Revert partiel: eventuellement Date modif := Now
    Aucun revert: eventuellement Date modif := Now

  Apr�s r�solution de conflit:
    Date synchro = Null -> jamais synchronis�, cr�ation � envoyer
    Date synchro < Date modif -> modifi�, pas/plus de conflit, modifications � envoyer
    Date synchro > Date modif -> non modifi�, rien � faire

  pour la r�solution de conflit:
    - r�cup�ration de la derni�re version synchronis�e (le serveur a toutes les versions)
    - comparer � la version locale pour connaitre les modifs locales
    - comparer � la version distante pour connaitre les modifs � int�grer

*)

  try

  finally
    SendOption('lastsynchro', DateToStr(FStartTime, TGlobalVar.SQLSettings)); // ??
  end;
end;

end.
