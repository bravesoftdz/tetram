unit Form_Publier;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmPublier = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    DateTimePicker1: TDateTimePicker;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    GroupBox2: TGroupBox;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    ComboBox1: TComboBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Label6: TLabel;
    Edit6: TEdit;
    Label5: TLabel;
    Edit5: TEdit;
    Label7: TLabel;
    ComboBox2: TComboBox;
    Memo1: TMemo;
    CheckBox1: TCheckBox;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    Label8: TLabel;
    Button1: TButton;
    Label9: TLabel;
    CheckBox2: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

{$R *.dfm}

uses
  UNet, Divers, Updates, DIMime, DIMimeStreams, JvUIB, JvUIBLib, DM_Princ, Commun, DateUtils,
  Procedures, CommonConst, VarUtils;

type
  TSynchroSpecial = (tsNone, tsImages);

  RInfoTable = record
    TableName: string;
    ID: string;
    version_mini, version_maxi: string;
    TypeSynchro: TSynchroSpecial;
    SkipFields: string;
  end;

const
  TablesSynchro: array[1..11] of RInfoTable = (
    (TableName: 'PERSONNES'; ID: 'id_personne'),
    (TableName: 'EDITEURS'; ID: 'id_editeur'),
    (TableName: 'COLLECTIONS'; ID: 'id_collection'),
    (TableName: 'SERIES'; ID: 'id_serie'),
    (TableName: 'ALBUMS'; ID: 'id_album'),
    (TableName: 'EDITIONS'; ID: 'id_edition'),
    (TableName: 'AUTEURS'; ID: 'id_auteur'),
    (TableName: 'GENRES'; ID: 'id_genre'),
    (TableName: 'GENRESERIES'; ID: 'id_genreseries'),
    (TableName: 'LISTES'; ID: 'id_liste'),
    (TableName: 'COUVERTURES'; ID: 'id_couverture'; TypeSynchro: tsImages; SkipFields: '@stockagecouverture@imagecouverture@fichiercouverture@'));

procedure TfrmPublier.Button1Click(Sender: TObject);
const
  ParamLengthMin = 2;
var
  Reponse: TStringStream;
  slReponse: TStringList;
  Param: array of RAttachement;
  db_version, UpgradeTodb_version: string;
  UpgradeFromDate: TDate;
  s1, s2: string;
  qry: TJvUIBQuery;
  StartTime: TDateTime;
  SQLSettings: TFormatSettings;
  URL: string;

  function GetCode(Index: Integer): string;
  begin
    Result := slReponse[Index];
    if Pos(':', Result) > 0 then Result := Copy(Result, 1, Pos(':', Result) - 1);
  end;

  function GetLabel(var Index: Integer): string;
  var
    Code, Ligne: string;
  begin
    Code := GetCode(Index);
    Ligne := slReponse[Index];
    Result := Copy(Ligne, Length(Code) + 3, Length(Ligne));
    Inc(Index);
    while (slReponse.Count > Index) and (GetCode(Index) = '') do
    begin
      Ligne := slReponse[Index];
      Result := Result + #13#10 + Copy(Ligne, Length(Code) + 3, Length(Ligne));
      Inc(Index);
    end;
    Dec(Index);
  end;

  function IsError(Index: Integer): Boolean;
  begin
    Result := GetCode(Index) = 'ERROR';
  end;

  procedure Decoupe(Index: Integer; out s1, s2: string);
  var
    s: string;
  begin
    s := GetLabel(Index);
    s1 := Copy(s, 1, Pos('=', s) - 1);
    s2 := Copy(s, Pos('=', s) + 1, MaxInt);
  end;

  procedure PostHTTP;
  var
    l: Integer;
    s: string;
  begin
    if LoadStreamURL(URL, Param, Reponse) <> 200 then
      raise Exception.Create('Impossible d''accéder au site:'#13#10'- vérifier le paramétrage de l''adresse'#13#10'- Assurez-vous que le modèle est bien chargé sur le site');
    slReponse.LoadFromStream(Reponse);
    memo1.Lines.Text := Reponse.DataString;
    l := 0;
    s := GetLabel(l);
    Inc(l);
    if IsError(0) then raise Exception.Create('Erreur inattendue : ' + s + #13#10 + GetLabel(l));
  end;

  procedure SendData(Action: Integer; const Data: string = '');
  begin
    if Data <> '' then
      SetLength(Param, ParamLengthMin + 2)
    else
      SetLength(Param, ParamLengthMin + 1);

    Param[ParamLengthMin + 0].Nom := 'action';
    Param[ParamLengthMin + 0].Valeur := IntToStr(Action);
    if Data <> '' then
    begin
      Param[ParamLengthMin + 1].Nom := 'data';
      Param[ParamLengthMin + 1].Valeur := MimeEncodeString(Data);
    end;
    PostHTTP;
  end;

  procedure CheckVersions;
  var
    i: Integer;
  begin
    SendData(0);

    Decoupe(0, s1, s2);
    if s1 <> 'intf_version' then raise Exception.Create('Erreur inattendue: '#13#10 + slReponse.Text);
    if CompareVersionNum('1', s2) > 0 then raise Exception.Create('Version d''interface non supportée.'#13#10'Veuillez mettre à jour BDThèque.');

    Decoupe(1, s1, s2);
    if s1 <> 'php_version' then raise Exception.Create('Erreur inattendue: '#13#10 + slReponse.Text);
    if Copy(s2, Length(s2) - 2, 2) <> 'OK' then raise Exception.Create('La version de php disponible sur le serveur est insuffisante.'#13#10'Veuillez utiliser un autre hébergeur.');

    Decoupe(2, s1, s2);
    if s1 <> 'XML' then raise Exception.Create('Erreur inattendue: '#13#10 + slReponse.Text);
    if Copy(s2, Length(s2) - 2, 2) <> 'OK' then raise Exception.Create('Le support XML n''est pas présent dans le moteur php du serveur.'#13#10'Veuillez utiliser un autre hébergeur.');

    // Decoupe(3, s1, s2); // support JSON

    i := 5;
    if IsError(4) then raise Exception.Create('Impossible de se connecter à la base de données MySQL:'#13#10'- vérifier le paramétrage de la base de données'#13#10'- Assurez-vous que le modèle est bien chargé sur le site après avoir regénéré le site'#13#10#13#10 + GetLabel(i));
    Decoupe(4, s1, s2);
    if s1 <> 'mysql_version' then raise Exception.Create('Erreur inattendue: '#13#10 + slReponse.Text);
    if Copy(s2, Length(s2) - 2, 2) <> 'OK' then raise Exception.Create('La version de MySQL disponible sur le serveur est insuffisante.'#13#10'Veuillez utiliser un autre hébergeur.');

    Decoupe(5, s1, db_version);
    if s1 <> 'db_version' then raise Exception.Create('Erreur inattendue: '#13#10 + slReponse.Text);
  end;

  procedure SendOption(const cle, valeur: string);
  begin
    SendData(2, '<data><table>options</table><primarykey>cle</primarykey><records><record><cle>' + cle + '</cle><valeur>' + valeur + '</valeur></record></records></data>');
  end;

  function GetOption(const cle: string): string;
  var
    i: Integer;
  begin
    SetLength(Param, ParamLengthMin + 2);
    Param[ParamLengthMin + 0].Nom := 'action';
    Param[ParamLengthMin + 0].Valeur := '3';
    Param[ParamLengthMin + 1].Nom := 'cle';
    Param[ParamLengthMin + 1].Valeur := cle;
    PostHTTP;
    i := 0;
    Result := GetLabel(i);
  end;

  procedure Upgrade;
  var
    i: Integer;
    SQL: TStringList;
  begin
    if RadioButton5.Checked then
      UpgradeTodb_version := TMySQLUpdate(ListMySQLUpdates[Pred(ListMySQLUpdates.Count)]).Version
    else
      UpgradeTodb_version := ComboBox1.Text;

    if CompareVersionNum(UpgradeTodb_version, db_version) > 0 then
      for i := 0 to Pred(ListMySQLUpdates.Count) do
        with TMySQLUpdate(ListMySQLUpdates[i]) do
        begin
          if CompareVersionNum(UpgradeTodb_version, Version) < 0 then Break;
          if (CompareVersionNum(Version, db_version) > 0) then
          begin
            SQL := TStringList.Create;
            try
              UpdateCallback(SQL);

              SendData(1, SQL.Text);
              SendOption('version', Version);
              db_version := Version;
            finally
              SQL.Free;
            end;

          end;
        end;
  end;

  function CleanHTTP(Valeur: string): string;
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
          '0'..'9', 'a'..'z', 'A'..'Z': Result := Result + c^;
          else
            Result := Result + '&#' + IntToStr(Ord(c^)) + ';';
        end;
        Inc(c);
      end;
    end;
  end;

  procedure RefreshProgressBar;
  var
    moyExecTime: Cardinal;
  begin
    ProgressBar1.StepBy(1);
    ProgressBar2.StepBy(1);
    moyExecTime := MilliSecondsBetween(Now, StartTime) div Cardinal(ProgressBar2.Position);
    if moyExecTime < 10 then moyExecTime := 10; // au départ la moyenne n'est pas forcément très juste: par tatonnement, il faut au moins 10ms par enregistrement

    Label9.Caption := 'Fin estimée : ' + FormatDateTime('HH:mm:ss', IncMilliSecond(Now, moyExecTime * Cardinal(ProgressBar2.Max - ProgressBar2.Position)));
    Application.ProcessMessages;
  end;

  procedure SendDataset(InfoTable: RInfoTable; Query: TJvUIBQuery; isDelete: Boolean = False);

    procedure SendXML(const XML: string);
    var
      i: Integer;
    begin
      SendData(2, XML);

      i := 0;
      if GetLabel(i) <> 'done' then
      begin
        CheckBox1.Checked := False;
        while not CheckBox1.Checked do
          Application.HandleMessage;
      end;
    end;
  const
    MaxBodySize = 4096;
  var
    enteteXML, bodyXML, recordXML, champ, contenuChamp: string;
    i, l: Integer;
    //    ms: TMemoryStream;
    //    ss: TStringStream;
    listFields: TList;
  begin
    listFields := TList.Create;
    try
      enteteXML := '<table>' + LowerCase(InfoTable.TableName) + '</table>';
      AjoutString(enteteXML, LowerCase(InfoTable.ID), '', '<primarykey>', '</primarykey>');
      with Query do
      begin
        for i := 0 to Pred(Fields.FieldCount) do
          if Pos('@' + LowerCase(Fields.AliasName[i]) + '@', InfoTable.SkipFields) = 0 then listFields.Add(Pointer(i));
        bodyXML := '';
        while not Eof do
        begin
          recordXML := '';
          for l := 0 to Pred(listFields.Count) do
          begin
            i := Integer(listFields[l]);
            champ := LowerCase(Fields.AliasName[i]);
            if Fields.IsNull[i] then
              AjoutString(recordXML, Format('<%s null="T" />', [champ]), '')
            else
            begin
              case Fields.FieldType[i] of
                uftDate: contenuChamp := DateToStr(Fields.AsDate[i], SQLSettings);
                uftTimestamp: contenuChamp := DateToStr(Fields.AsDateTime[i], SQLSettings) + ' ' + TimeToStr(Fields.AsDateTime[i], SQLSettings);
                //            uftBlob:
                //              begin
                //                ms := TMemoryStream.Create;
                //                ss := TStringStream.Create('');
                //                try
                //                  Fields.ReadBlob(i, ms);
                //                  ms.Position := 0;
                //                  MimeEncodeStream(ms, ss);
                //                  champ := ss.DataString;
                //                finally
                //                  ms.Free;
                //                  ss.Free;
                //                end;
                //              end;
                else
                  contenuChamp := Fields.AsString[i];
              end;
              //          if Fields.FieldType[i] = uftBlob then
              //            contenuChamp := champ
              //          else
              contenuChamp := CleanHTTP(contenuChamp);
              AjoutString(recordXML, contenuChamp, '', Format('<%s%s>', [champ, IIf(Fields.FieldType[i] = uftBlob, {' type="B"'} '', '')]), Format('</%s>', [champ]));
            end;
          end;
          AjoutString(bodyXML, recordXML, '', '<record' + IIf(isDelete, ' action="D"', '') + '>', '</record>');
          if Length(bodyXML) > MaxBodySize then
          begin
            SendXML(Format('<data>%s<records>%s</records></data>', [enteteXML, bodyXML]));
            bodyXML := '';
          end;

          Next;
          RefreshProgressBar;
        end;
        if Length(bodyXML) > 0 then SendXML(Format('<data>%s<records>%s</records></data>', [enteteXML, bodyXML]));
      end;
    finally
      listFields.Free;
    end;
  end;

  function CompteUpdates(InfoTable: RInfoTable): Integer;
  begin
    with qry do
    begin
      SQL.Text := Format('select count(*) from %0:s where dm_%0:s >= :UpgradeFromDate', [InfoTable.TableName]);
      Params.AsDate[0] := Trunc(UpgradeFromDate);
      Open;
      Result := Fields.AsInteger[0];
      Close;

      if InfoTable.ID <> '' then
      begin
        SQL.Text := 'select count(*) from suppressions where tablename = :table and dm_suppressions >= :UpgradeFromDate';
        Params.AsString[0] := InfoTable.TableName;
        Params.AsDate[1] := Trunc(UpgradeFromDate);
        Open;
        Inc(Result, Fields.AsInteger[0]);
        Close;
      end;
    end;
  end;

  procedure SendDonnees(InfoTable: RInfoTable);
  begin
    with qry do
    begin
      ProgressBar1.Position := 0;
      ProgressBar1.Max := CompteUpdates(InfoTable);

      SQL.Text := Format('select * from %0:s where dm_%0:s >= :UpgradeFromDate order by dm_%0:s', [InfoTable.TableName]);
      Params.AsDate[0] := Trunc(UpgradeFromDate);
      Open;
      SendDataset(InfoTable, qry);
      Close;

      if InfoTable.ID <> '' then
      begin
        SQL.Text := 'select ID as ' + InfoTable.ID + ' from suppressions where tablename = :table and dm_suppressions >= :UpgradeFromDate order by dm_suppressions';
        Params.AsString[0] := InfoTable.TableName;
        Params.AsDate[1] := Trunc(UpgradeFromDate);
        Open;
        SendDataset(InfoTable, qry, True);
        Close;
      end;
    end;
    SendData(1, 'OPTIMIZE TABLE /*DB_PREFIX*/' + InfoTable.TableName);
  end;

  procedure SendImages(InfoTable: RInfoTable);
  var
    ms: TStream;
    es: TStringStream;
  begin
    with qry do
    begin
      ProgressBar1.Position := 0;
      ProgressBar1.Max := CompteUpdates(InfoTable);

      SQL.Text := Format('select * from %0:s where dm_%0:s >= :UpgradeFromDate order by dm_%0:s', [InfoTable.TableName]);
      Params.AsDate[0] := Trunc(UpgradeFromDate);
      Open;
      while not Eof do
      begin
        ms := GetCouvertureStream(False, StringToGUIDDef(Fields.ByNameAsString[InfoTable.ID], GUID_NULL), 400, 500, Utilisateur.Options.AntiAliasing);
        if Assigned(ms) then
        begin
          es := TStringStream.Create('');
          try
            MimeEncodeStream(ms, es);
            SetLength(Param, ParamLengthMin + 3);
            Param[ParamLengthMin + 0].Nom := 'action';
            Param[ParamLengthMin + 0].Valeur := '7';
            Param[ParamLengthMin + 1].Nom := 'image';
            Param[ParamLengthMin + 1].Valeur := es.DataString;
            Param[ParamLengthMin + 2].Nom := 'ID';
            Param[ParamLengthMin + 2].Valeur := CleanHTTP(Fields.ByNameAsString[InfoTable.ID]);
            PostHTTP;
          finally
            es.Free;
            ms.Free;
          end;
        end;
        Next;
        RefreshProgressBar;
      end;
    end;
  end;

var
  i: Integer;
  rc: Integer;
begin
  SQLSettings.ShortDateFormat := 'YYYY-MM-DD';
  SQLSettings.ShortTimeFormat := 'HH:mm:ss:zzz';
  SQLSettings.LongTimeFormat := 'HH:mm:ss:zzz';
  SQLSettings.DateSeparator := '-';
  SQLSettings.TimeSeparator := ':';

  URL := Edit1.Text;
  if (URL <> '') and (URL[Length(URL)] <> '/') then URL := URL + '/';
  URL := URL + 'interface.php';

  Reponse := TStringStream.Create('');
  slReponse := TStringList.Create;
  try
    SetLength(Param, ParamLengthMin);
    Param[0].Nom := 'auth_key';
    Param[0].Valeur := Edit2.Text;
    Param[1].Nom := 'isExe';
    Param[1].Valeur := '';

    CheckVersions;

    Upgrade;

    if RadioButton1.Checked then
      UpgradeFromDate := StrToDateDef(GetOption('lastsynchro'), -1, SQLSettings)
    else if RadioButton2.Checked then
      UpgradeFromDate := Trunc(DateTimePicker1.Date)
    else
      UpgradeFromDate := -1;

    StartTime := Now;
    qry := TJvUIBQuery.Create(nil);
    with qry do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      FetchBlobs := True;

      rc := 0;
      for i := Low(TablesSynchro) to High(TablesSynchro) do
        with TablesSynchro[i] do
          if ((version_mini = '') or (CompareVersionNum(db_version, version_mini) >= 0))
            and ((version_maxi = '') or (CompareVersionNum(version_maxi, db_version) >= 0)) then
            case TypeSynchro of
              tsImages:
                if CheckBox2.Checked then Inc(rc, CompteUpdates(TablesSynchro[i]) * 2); // la synchro des images est faite en 2 fois
              else
                Inc(rc, CompteUpdates(TablesSynchro[i]));
            end;

      if rc = 0 then
        ShowMessage('Rien à publier')
      else
      begin
        ProgressBar2.Position := 0;
        ProgressBar2.Max := rc;
        ProgressBar1.Position := 0;
        ProgressBar1.Max := 1;

        for i := Low(TablesSynchro) to High(TablesSynchro) do
          with TablesSynchro[i] do
            if ((version_mini = '') or (CompareVersionNum(db_version, version_mini) >= 0))
              and ((version_maxi = '') or (CompareVersionNum(version_maxi, db_version) >= 0)) then
            begin
              Label8.Caption := 'Synchronisation de ' + TableName;
              case TypeSynchro of
                tsNone:
                  begin
                    if RadioButton3.Checked then SendData(1, 'TRUNCATE TABLE /*DB_PREFIX*/' + LowerCase(TableName));
                    SendDonnees(TablesSynchro[i]);
                  end;
                tsImages:
                  if CheckBox2.Checked then
                  begin
                    SendData(4); // création du répertoire
                    if RadioButton3.Checked then
                    begin
                      SendData(6);
                      SendData(1, 'TRUNCATE TABLE /*DB_PREFIX*/' + LowerCase(TableName));
                    end;
                    SendImages(TablesSynchro[i]);
                    SendDonnees(TablesSynchro[i]);
                  end;
              end;
            end;

        ShowMessage('Publication terminée');
      end;

      SendOption('lastsynchro', DateToStr(StartTime, SQLSettings));
    finally
      Transaction.Free;
      Free;
    end;
  finally
    ProgressBar2.Position := 0;
    ProgressBar1.Position := 0;
    slReponse.Free;
    Reponse.Free;
  end;
end;

procedure TfrmPublier.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  for i := Pred(ListMySQLUpdates.Count) downto 0 do
    ComboBox1.Items.Add(TMySQLUpdate(ListMySQLUpdates[i]).Version);
  ComboBox1.ItemIndex := 0;
  DateTimePicker1.DateTime := IncMonth(Now, -1);
end;

end.

