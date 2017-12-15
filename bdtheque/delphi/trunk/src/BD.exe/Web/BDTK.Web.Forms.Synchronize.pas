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
    { Déclarations publiques }
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
    raise Exception.Create('Une synchronisation est déjà en cours. Veuillez patienter.');
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
    * le serveur ne fait aucune résolution de conflit: elles sont faites par les applis, le serveur accepte tout ce qu'on lui envoie
    * l'appli applique les modifs distantes et résoud les conflits
      et envoie ses modifs locales restantes
    * la synchro peut être annulée pendant la résolution de conflit: on applique toutes les modifs ou on n'en applique aucune
    * un élément (par ex un album) est en conflit si un élément dont il dépend (par ex un auteur) est en conflit ou supprimé
    * si un élément n'est plus en conflit, tous les éléments qui en dépendent en conflit uniquement à cause de lui ne sont plus en conflit
      donc le conflit d'un élément à cause d'un élément supprimé ne peut être résolu que manuellement
    * un conflit se résoud sur un élément dans son intégralité (et non propriété par propriété)
      mais si le conflit porte sur des propriétés différentes, la résolution est automatique
    * le serveur conserve les différentes versions (nécessaire pour la résolution de conflit)

  implementation (cf svn):
    * update (recupération des modifs du serveur)
    * resolution des conflits
    * commit des modifs restantes
  nécessite d'avoir
    - la date de dernière synchro (ok),
    - et l'état "modifié localement" (soit par comparaison avec une copie de ce qu'a le serveur, soit par un flag, soit...)

  Avant update:
    Date synchro = Null -> jamais synchronisé, création à envoyer
    Date synchro < Date modif -> modifié, modifications à envoyer
    Date synchro > Date modif -> non modifié, rien à faire

  Pendant update:
    Date synchro < Date modif -> modifié, conflit à résoudre
    Date synchro > Date modif -> non modifié, mettre à jour -> Date synchro := Now
    Element supprimé -> conflit à résoudre

  Resolution du conflit:
/!\ la différence de date n'implique pas une différence réelle de données !!
/!\ Appliquer le revert complet dans le cas où il n'y a aucune modif réelle
    Revert complet: Date modif := old Date synchro, Date synchro := Now
    Revert partiel: eventuellement Date modif := Now
    Aucun revert: eventuellement Date modif := Now

  Après résolution de conflit:
    Date synchro = Null -> jamais synchronisé, création à envoyer
    Date synchro < Date modif -> modifié, pas/plus de conflit, modifications à envoyer
    Date synchro > Date modif -> non modifié, rien à faire

  pour la résolution de conflit:
    - récupération de la dernière version synchronisée (le serveur a toutes les versions)
    - comparer à la version locale pour connaitre les modifs locales
    - comparer à la version distante pour connaitre les modifs à intégrer

*)

  try

  finally
    SendOption('lastsynchro', DateToStr(FStartTime, TGlobalVar.SQLSettings)); // ??
  end;
end;

end.
