unit UfrmPublier;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ComCtrls, ExtCtrls, UframBoutons, UBdtForms;

type
  TfrmPublier = class(TBdtForm)
    GroupBox1: TGroupBox;
    DateTimePicker1: TDateTimePicker;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    CheckBox2: TCheckBox;
    Button1: TButton;
    Label8: TLabel;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    Label9: TLabel;
    CheckBox1: TCheckBox;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DateTimePicker1Change(Sender: TObject);
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

implementation

{$R *.dfm}

uses Math, UNet, Divers, Updates, UIB, UIBLib, UdmPrinc, Commun, DateUtils, Procedures, CommonConst, VarUtils, StrUtils,
  Generics.Collections, JclMime;

type
  TSynchroSpecial = (tsNone, tsImages);

  RInfoTable = record
    TableName: string;
    ID: string;
    version_mini, version_maxi: string;
    TypeSynchro: TSynchroSpecial;
    SkipFields, UpperFields: string;
    ProcedureStockee: string;
  end;

const
  TablesSynchro: array [1 .. 16] of RInfoTable = ((TableName: 'PERSONNES'; ID: 'id_personne'; UpperFields: 'nompersonne'), (TableName: 'EDITEURS';
    ID: 'id_editeur'; UpperFields: 'nomediteur'), (TableName: 'COLLECTIONS'; ID: 'id_collection'; UpperFields: 'nomcollection'), (TableName: 'SERIES';
    ID: 'id_serie';
    SkipFields
    : 'etat=1.0.0.1@reliure=1.0.0.1@typeedition=1.0.0.1@orientation=1.0.0.1@formatedition=1.0.0.1@senslecture=1.0.0.1@vo=1.0.0.1@couleur=1.0.0.1@notation';
    UpperFields: 'titreserie@sujetserie@remarquesserie'), (TableName: 'ALBUMS'; ID: 'id_album'; SkipFields: 'notation';
    UpperFields: 'titrealbum@sujetalbum@remarquesalbum'), (TableName: 'EDITIONS'; ID: 'id_edition'), (TableName: 'AUTEURS'; ID: 'id_auteur'),
    (TableName: 'GENRES'; ID: 'id_genre'; UpperFields: 'genre'), (TableName: 'GENRESERIES'; ID: 'id_genreseries'), (TableName: 'LISTES'; ID: 'id_liste'),
    (TableName: 'ALBUMS_MANQUANTS'; UpperFields: 'titreserie'; ProcedureStockee: 'ALBUMS_MANQUANTS(1, 1, NULL)'), (TableName: 'PREVISIONS_SORTIES';
    UpperFields: 'titreserie'; ProcedureStockee: 'PREVISIONS_SORTIES(1, NULL)'), (TableName: 'COUVERTURES'; ID: 'id_couverture'; TypeSynchro: tsImages;
    SkipFields: 'stockagecouverture@imagecouverture@fichiercouverture'), (TableName: 'UNIVERS'; ID: 'id_univers'; UpperFields: 'nomunivers'),
    (TableName: 'SERIES_UNIVERS'; ID: 'id_serie_univers'), (TableName: 'ALBUMS_UNIVERS'; ID: 'id_album_univers'));

procedure TfrmPublier.Button1Click(Sender: TObject);
const
  ParamLengthMin = 2;
var
  Reponse: TStringStream;
  slReponse: TStringList;
  Param: array of RAttachement;
  db_version, UpgradeTodb_version: TVersionNumber;
  UpgradeFromDate: TDate;
  s1, s2: string;
  qry: TUIBQuery;
  StartTime, StartTimeTable: TDateTime;
  SQLSettings: TFormatSettings;
  URL: string;
  MaxBodySize: Integer;

  function GetCode(index: Integer): string;
  begin
    Result := slReponse[index];
    if Pos(':', Result) > 0 then
      Result := Copy(Result, 1, Pos(':', Result) - 1);
  end;

  function GetLabel(var index: Integer): string;
  var
    Code, Ligne: string;
  begin
    Code := GetCode(index);
    Ligne := slReponse[index];
    Result := Copy(Ligne, Length(Code) + 3, Length(Ligne));
    Inc(index);
    while (slReponse.Count > index) and (GetCode(index) = '') do
    begin
      Ligne := slReponse[index];
      Result := Result + #13#10 + Copy(Ligne, Length(Code) + 3, Length(Ligne));
      Inc(index);
    end;
    Dec(index);
  end;

  function IsError(index: Integer): Boolean;
  begin
    Result := GetCode(index) = 'ERROR';
  end;

  procedure Decoupe(index: Integer; out s1, s2: string);
  var
    s: string;
  begin
    s := GetLabel(index);
    s1 := Copy(s, 1, Pos('=', s) - 1);
    s2 := Copy(s, Pos('=', s) + 1, MaxInt);
  end;

  procedure PostHTTP;
  var
    l: Integer;
    s: string;
  begin
    Reponse.Size := 0;
    if LoadStreamURL(URL, Param, Reponse, False) <> 200 then
      raise Exception.Create
        ('Impossible d''acc�der au site:'#13#10'- v�rifiez le param�trage de l''adresse'#13#10'- Assurez-vous que le mod�le est bien charg� sur le site');
    Reponse.Position := 0;
    slReponse.LoadFromStream(Reponse);
    Memo1.Lines.Text := Reponse.DataString;
    l := 0;
    s := GetLabel(l);
    Inc(l);
    if IsError(0) then
      raise Exception.Create('Erreur inattendue : ' + s + #13#10 + GetLabel(l));
  end;

  procedure SendData(Action: Integer; const Data: string = ''; isXML: Boolean = True);
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
      if isXML then
        Param[ParamLengthMin + 1].Valeur := string(MimeEncodeString('<?xml version="1.0" encoding="ISO-8859-1"?>' + AnsiString(UTF8String(Data))))
      else
        Param[ParamLengthMin + 1].Valeur := string(MimeEncodeString(AnsiString(UTF8String(Data))));
    end;
    PostHTTP;
  end;

  procedure CheckVersions;
  type
    TCheckConf = reference to function(const confCode: string): Boolean;
  var
    i: Integer;
    lstValues: TStringList;
    CheckConf: TCheckConf;
  begin
    SendData(0);

    Decoupe(0, s1, s2);
    if (s1 <> 'intf_version') then
      raise Exception.Create('Erreur inattendue: '#13#10 + slReponse.Text);
    if (TVersionNumber(s2) < '1') then
      raise Exception.Create('Version d''interface non support�e.'#13#10'Veuillez mettre � jour BDTh�que.')
    else if (TVersionNumber(s2) = '1') then
    begin
      Decoupe(1, s1, s2);
      if s1 <> 'php_version' then
        raise Exception.Create('Erreur inattendue: '#13#10 + slReponse.Text);
      if Copy(s2, Length(s2) - 2, 2) <> 'OK' then
        raise Exception.Create('La version de php disponible sur le serveur est insuffisante.'#13#10'Veuillez utiliser un autre h�bergeur.');

      Decoupe(2, s1, s2);
      if s1 <> 'XML' then
        raise Exception.Create('Erreur inattendue: '#13#10 + slReponse.Text);
      if Copy(s2, Length(s2) - 2, 2) <> 'OK' then
        raise Exception.Create('Le support XML n''est pas pr�sent dans le moteur php du serveur.'#13#10'Veuillez utiliser un autre h�bergeur.');

      // Decoupe(3, s1, s2); // support JSON

      i := 5;
      if IsError(4) then
        raise Exception.Create
          ('Impossible de se connecter � la base de donn�es MySQL:'#13#10'- v�rifier le param�trage de la base de donn�es'#13#10'- Assurez-vous que le mod�le est bien charg� sur le site apr�s avoir reg�n�r� le site'#13#10#13#10
          + GetLabel(i));
      Decoupe(4, s1, s2);
      if s1 <> 'mysql_version' then
        raise Exception.Create('Erreur inattendue: '#13#10 + slReponse.Text);
      if Copy(s2, Length(s2) - 2, 2) <> 'OK' then
        raise Exception.Create('La version de MySQL disponible sur le serveur est insuffisante.'#13#10'Veuillez utiliser un autre h�bergeur.');

      Decoupe(5, s1, s2);
      if s1 <> 'db_version' then
        raise Exception.Create('Erreur inattendue: '#13#10 + slReponse.Text);
      db_version := s2;
    end
    else
    begin
      lstValues := TStringList.Create;
      try
        for i := 0 to Pred(slReponse.Count) do
        begin
          Decoupe(i, s1, s2);
          lstValues.Values[s1] := s2;
        end;

        CheckConf := function(const confCode: string): Boolean
          begin
            i := lstValues.IndexOfName(confCode);
            if i = -1 then
              raise Exception.Create('Erreur inattendue: '#13''#10'' + slReponse.Text);
            Result := SameText(Copy(lstValues.ValueFromIndex[i], Length(lstValues.ValueFromIndex[i]) - 2, 2), 'OK');
          end;

        if not CheckConf('php_version') then
          raise Exception.Create('La version de php disponible sur le serveur est insuffisante.'#13''#10'Veuillez utiliser un autre h�bergeur.');
        if not CheckConf('XML') then
          raise Exception.Create('Le support XML n''est pas pr�sent dans le moteur php du serveur.'#13#10'Veuillez utiliser un autre h�bergeur.');
        if not CheckConf('MYSQLI') then
          raise Exception.Create('Le support MySQLi n''est pas pr�sent dans le moteur php du serveur.'#13#10'Veuillez utiliser un autre h�bergeur.');

        if not CheckConf('DB') then
          raise Exception.Create
            ('Impossible de se connecter � la base de donn�es MySQL:'#13#10'- v�rifier le param�trage de la base de donn�es et que la base de donn�es est accessible'#13#10'- Assurez-vous que le mod�le est bien charg� sur le site apr�s avoir reg�n�r� le site'#13#10#13#10
            + lstValues.ValueFromIndex[i + 1])
        else
        begin
          if not CheckConf('mysql_version') then
            raise Exception.Create('La version de MySQL disponible sur le serveur est insuffisante.'#13#10'Veuillez utiliser un autre h�bergeur.');
          db_version := lstValues.Values['db_version'];
          if db_version = '' then
            raise Exception.Create('Erreur inattendue: '#13#10 + slReponse.Text);
        end;
      finally
        lstValues.Free;
      end;
    end
    // else
    // raise Exception.Create('Version d''interface non support�e.'#13#10'Veuillez mettre � jour BDTh�que.');
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
          ' ', '0' .. '9', 'a' .. 'z', 'A' .. 'Z':
            Result := Result + c^;
        else
          Result := Result + '&#' + IntToStr(Ord(c^)) + ';';
        end;
        Inc(c);
      end;
    end;
  end;

  procedure SendOption(const cle, Valeur: string);
  begin
    SendData(2, '<data><table>options</table><primarykey>cle</primarykey><records><record><cle>' + CleanHTTP(cle) + '</cle><valeur>' + CleanHTTP(Valeur) +
      '</valeur></record></records></data>');
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
    SQL: TStringList;
    MySQLUpdate: TMySQLUpdate;
  begin
    UpgradeTodb_version := TGlobalVar.Utilisateur.Options.SiteWeb.BddVersion;
    if UpgradeTodb_version = '' then
      UpgradeTodb_version := TMySQLUpdate(ListMySQLUpdates[Pred(ListMySQLUpdates.Count)]).Version;

    if UpgradeTodb_version > db_version then
      for MySQLUpdate in ListMySQLUpdates do
      begin
        if UpgradeTodb_version < MySQLUpdate.Version then
          Break;
        if MySQLUpdate.Version > db_version then
        begin
          SQL := TStringList.Create;
          try
            MySQLUpdate.UpdateCallback(SQL);

            SendData(1, SQL.Text, False);
            SendOption('version', MySQLUpdate.Version);
            db_version := MySQLUpdate.Version;
          finally
            SQL.Free;
          end;

        end;
      end;
  end;

  procedure RefreshProgressBar;
  var
    OperationAFaireTotal, OperationAFaireTable, OperationAFaireAutresTables: Cardinal;
    OperationFaitesTotal, OperationFaitesTable, OperationFaitesAutresTables: Cardinal;
    OperationRestantTotal, OperationRestantTable, OperationRestantAutresTables: Cardinal;

    ExecTimeTotal, ExecTimeTable, ExecTimeAutresTables: Cardinal;
    moyExecTimeTable, moyExecTimeAutresTables: Cardinal;
    TempsRestantTotal, TempsRestantTable, TempsRestantAutresTables: Cardinal;
  begin
    ProgressBar1.StepBy(1);
    ProgressBar2.StepBy(1);

    OperationAFaireTable := Cardinal(ProgressBar1.Max);
    OperationAFaireTotal := Cardinal(ProgressBar2.Max);
    OperationAFaireAutresTables := OperationAFaireTotal - OperationAFaireTable;

    OperationFaitesTable := Cardinal(ProgressBar1.Position);
    OperationFaitesTotal := Cardinal(ProgressBar2.Position);
    OperationFaitesAutresTables := OperationFaitesTotal - OperationFaitesTable;

    OperationRestantTable := OperationAFaireTable - OperationFaitesTable;
    OperationRestantTotal := OperationAFaireTotal - OperationFaitesTotal;
    OperationRestantAutresTables := OperationRestantTotal - OperationRestantTable;

    ExecTimeTable := MilliSecondsBetween(Now, StartTimeTable);
    ExecTimeTotal := MilliSecondsBetween(Now, StartTime);
    ExecTimeAutresTables := ExecTimeTotal - ExecTimeTable;

    if OperationFaitesTable = 0 then
      moyExecTimeTable := 0
    else
      moyExecTimeTable := ExecTimeTable div OperationFaitesTable;
    if moyExecTimeTable < 10 then
      moyExecTimeTable := 10; // au d�part la moyenne n'est pas forc�ment tr�s juste: par tatonnement, il faut au moins 10ms par enregistrement
    if OperationFaitesAutresTables = 0 then
      moyExecTimeAutresTables := moyExecTimeTable
    else
      moyExecTimeAutresTables := ExecTimeAutresTables div OperationFaitesAutresTables;
    if moyExecTimeAutresTables < 10 then
      moyExecTimeAutresTables := 10; // au d�part la moyenne n'est pas forc�ment tr�s juste: par tatonnement, il faut au moins 10ms par enregistrement

    TempsRestantTable := moyExecTimeTable * OperationRestantTable;
    TempsRestantAutresTables := moyExecTimeAutresTables * OperationRestantAutresTables;
    TempsRestantTotal := TempsRestantTable + TempsRestantAutresTables;

    Label9.Caption := Format('Fin estim�e : %s (%s)', [FormatDateTime('HH:mm:ss', IncMilliSecond(Now, TempsRestantTotal)),
      TimeToStr(IncMilliSecond(0, TempsRestantTotal))]);
    Application.ProcessMessages;
  end;

  procedure SendDataset(const InfoTable: RInfoTable; Query: TUIBQuery; isDelete: Boolean = False);

    procedure SendXML(const XML: string);
    var
      i: Integer;
    begin
      SendData(2, XML);

      i := 0;
      if GetLabel(i) <> 'done' then
      begin
        CheckBox1.Checked := False;
        CheckBox1.Visible := True;
        Memo1.Visible := True;
        try
          while not CheckBox1.Checked do
            Application.HandleMessage;
        finally
          CheckBox1.Visible := False;
          Memo1.Visible := False;
        end;
      end;
    end;

  var
    enteteXML, bodyXML, recordXML, champ, s: string;
    contenuChamp: WideString;
    i, l: Integer;
    // ms: TMemoryStream;
    // ss: TStringStream;
    listFields, listUpperFields: TList<Integer>;
  begin
    listFields := TList<Integer>.Create;
    listUpperFields := TList<Integer>.Create;
    try
      enteteXML := '<table>' + LowerCase(InfoTable.TableName) + '</table>';
      AjoutString(enteteXML, LowerCase(InfoTable.ID), '', '<primarykey>', '</primarykey>');
      with Query do
      begin
        for i := 0 to Pred(Fields.FieldCount) do
        begin
          champ := LowerCase(Fields.AliasName[i]);

          // champ � passer ?
          s := '@' + InfoTable.SkipFields + '@';
          l := Pos('@' + champ + '=', s);
          if l > 0 then
          begin
            l := l + Length(champ) + 2;
            if db_version >= Copy(s, l, PosEx('@', s, l) - l) then
              listFields.Add(i);
            Continue; // ce n'est pas grave si on ne fait pas le test du champ � upper: si on l'a pass� c'est qu'il ne l'est pas
          end;
          if Pos('@' + champ + '@', s) = 0 then
            listFields.Add(i);

          s := '@' + InfoTable.UpperFields + '@';
          l := Pos('@' + champ + '=', s);
          if l > 0 then
          begin
            l := l + Length(champ) + 2;
            if db_version >= Copy(s, l, PosEx('@', s, l) - l) then
              listUpperFields.Add(i);
            Continue;
          end;
          if Pos('@' + champ + '@', s) > 0 then
            listUpperFields.Add(i);
        end;
        bodyXML := '';
        while not Eof do
        begin
          recordXML := '';
          for l := 0 to Pred(listFields.Count) do
          begin
            i := listFields[l];
            champ := LowerCase(Fields.AliasName[i]);
            if Fields.IsNull[i] then
              contenuChamp := ''
            else
            begin
              case Fields.FieldType[i] of
                uftDate:
                  contenuChamp := DateToStr(Fields.AsDate[i], SQLSettings);
                uftTimestamp:
                  contenuChamp := DateToStr(Fields.AsDateTime[i], SQLSettings) + ' ' + TimeToStr(Fields.AsDateTime[i], SQLSettings);
                // uftBlob:
                // begin
                // ms := TMemoryStream.Create;
                // ss := TStringStream.Create('');
                // try
                // Fields.ReadBlob(i, ms);
                // ms.Position := 0;
                // MimeEncodeStream(ms, ss);
                // champ := ss.DataString;
                // finally
                // ms.Free;
                // ss.Free;
                // end;
                // end;
                uftNumeric:
                  contenuChamp := StringReplace(Fields.AsString[i], FormatSettings.DecimalSeparator, '.', []);
              else
                contenuChamp := Trim(Fields.AsString[i]);
              end;
              // if Fields.FieldType[i] <> uftBlob then

            end;

            if contenuChamp = '' then
            begin
              AjoutString(recordXML, Format('<%s null="T" />', [champ]), '');
              if listUpperFields.IndexOf(i) <> -1 then
                AjoutString(recordXML, Format('<%s null="T" />', ['upper' + champ]), '');
            end
            else
            begin
              AjoutString(recordXML, CleanHTTP(contenuChamp), '', Format('<%s%s>', [champ, IIf(Fields.FieldType[i] = uftBlob,
                { ' type="B"' } '', '')]), Format('</%s>', [champ]));
              if listUpperFields.IndexOf(i) <> -1 then
                AjoutString(recordXML, CleanHTTP(UpperCase(SansAccents(contenuChamp))), '',
                  Format('<%s%s>', ['upper' + champ, IIf(Fields.FieldType[i] = uftBlob, { ' type="B"' } '', '')]), Format('</%s>', ['upper' + champ]));
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
        if Length(bodyXML) > 0 then
          SendXML(Format('<data>%s<records>%s</records></data>', [enteteXML, bodyXML]));
      end;
    finally
      listFields.Free;
      listUpperFields.Free;
    end;
  end;

  function GetSQL(const InfoTable: RInfoTable; withCount: Boolean): string;
  var
    champ: string;
  begin
    if withCount then
      champ := 'count(*)'
    else
      champ := '*';
    if InfoTable.ProcedureStockee <> '' then
      Result := Format('select %s from %s', [champ, InfoTable.ProcedureStockee])
    else
      Result := Format('select %s from %1:s where dm_%1:s >= :UpgradeFromDate', [champ, InfoTable.TableName]);
  end;

  function CompteUpdates(const InfoTable: RInfoTable): Integer;
  begin
    with qry do
    begin
      SQL.Text := GetSQL(InfoTable, True);
      if Params.FieldCount > 0 then
        Params.AsDate[0] := Trunc(UpgradeFromDate);
      Open;
      Result := Fields.AsInteger[0];
      Close;

      if InfoTable.ID <> '' then
      begin
        SQL.Text := 'select count(*) from suppressions where tablename = :table and dm_suppressions >= :UpgradeFromDate';
        Prepare(True);
        Params.AsString[0] := Copy(InfoTable.TableName, 1, Params.MaxStrLen[0]);
        Params.AsDate[1] := Trunc(UpgradeFromDate);
        Open;
        Inc(Result, Fields.AsInteger[0]);
        Close;
      end;
    end;
  end;

  procedure SendDonnees(const InfoTable: RInfoTable);
  begin
    with qry do
    begin
      ProgressBar1.Position := 0;
      ProgressBar1.Max := CompteUpdates(InfoTable);

      SQL.Text := GetSQL(InfoTable, False);
      if Params.FieldCount > 0 then
        Params.AsDate[0] := Trunc(UpgradeFromDate);
      Open;
      SendDataset(InfoTable, qry);
      Close;

      if InfoTable.ID <> '' then
      begin
        SQL.Text := 'select ID as ' + InfoTable.ID +
          ' from suppressions where tablename = :table and dm_suppressions >= :UpgradeFromDate order by dm_suppressions';
        Prepare(True);
        Params.AsString[0] := Copy(InfoTable.TableName, 1, Params.MaxStrLen[0]);
        Params.AsDate[1] := Trunc(UpgradeFromDate);
        Open;
        SendDataset(InfoTable, qry, True);
        Close;
      end;
    end;
    SendData(1, 'OPTIMIZE TABLE /*DB_PREFIX*/' + InfoTable.TableName, False);
  end;

  procedure SendImages(const InfoTable: RInfoTable);
  var
    ms: TStream;
    es: TStringStream;
    l: Integer;
  begin
    with qry do
    begin
      ProgressBar1.Position := 0;
      ProgressBar1.Max := CompteUpdates(InfoTable);

      SQL.Text := GetSQL(InfoTable, False);
      if Params.FieldCount > 0 then
        Params.AsDate[0] := Trunc(UpgradeFromDate);
      Open;
      while not Eof do
      begin
        SetLength(Param, ParamLengthMin + 2);
        Param[ParamLengthMin + 0].Nom := 'action';
        Param[ParamLengthMin + 0].Valeur := '8';
        Param[ParamLengthMin + 1].Nom := 'ID';
        Param[ParamLengthMin + 1].Valeur := string(MimeEncodeStringNoCRLF(AnsiString(UTF8String(Fields.ByNameAsString[InfoTable.ID]))));
        PostHTTP;
        l := 0;
        if GetLabel(l) = 'file not found' then
        begin
          ms := GetCouvertureStream(False, StringToGUIDDef(Fields.ByNameAsString[InfoTable.ID], GUID_NULL), 400, 500,
            TGlobalVar.Utilisateur.Options.AntiAliasing);
          if Assigned(ms) then
          begin
            es := TStringStream.Create('');
            try
              MimeEncodeStream(ms, es);
              SetLength(Param, ParamLengthMin + 3);
              Param[ParamLengthMin + 0].Nom := 'action';
              Param[ParamLengthMin + 0].Valeur := '7';
              Param[ParamLengthMin + 1].Nom := 'ID';
              Param[ParamLengthMin + 1].Valeur := string(MimeEncodeStringNoCRLF(AnsiString(UTF8String(Fields.ByNameAsString[InfoTable.ID]))));
              Param[ParamLengthMin + 2].Nom := 'image';
              Param[ParamLengthMin + 2].Valeur := es.DataString;
              PostHTTP;
            finally
              es.Free;
              ms.Free;
            end;
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
  table: RInfoTable;
begin
  // TODO: ajouter la gestion des univers
  // TODO: v�rifier la gestion des cat�gories (table LISTES, le champ REF contient maintenant le code de la cat�gorie * 100)

  SQLSettings.ShortDateFormat := 'YYYY-MM-DD';
  SQLSettings.ShortTimeFormat := 'HH:mm:ss:zzz';
  SQLSettings.LongTimeFormat := 'HH:mm:ss:zzz';
  SQLSettings.DateSeparator := '-';
  SQLSettings.TimeSeparator := ':';

  URL := TGlobalVar.Utilisateur.Options.SiteWeb.Adresse;
  if (URL <> '') and (URL[Length(URL)] <> '/') then
    URL := URL + '/';
  URL := URL + 'interface.php';

  MaxBodySize := TGlobalVar.Utilisateur.Options.SiteWeb.Paquets;

  Reponse := TStringStream.Create('');
  slReponse := TStringList.Create;
  try
    SetLength(Param, ParamLengthMin);
    Param[0].Nom := 'auth_key';
    Param[0].Valeur := TGlobalVar.Utilisateur.Options.SiteWeb.cle;
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
    qry := TUIBQuery.Create(nil);
    with qry do
      try
        Transaction := GetTransaction(DMPrinc.UIBDataBase);
        FetchBlobs := True;

        rc := 0;
        for table in TablesSynchro do
          if ((table.version_mini = '') or (db_version >= table.version_mini)) and ((table.version_maxi = '') or (db_version < table.version_maxi)) then
            case table.TypeSynchro of
              tsImages:
                if CheckBox2.Checked then
                  Inc(rc, CompteUpdates(table) * 2); // la synchro des images est faite en 2 fois : les donn�es puis les fichiers
            else
              Inc(rc, CompteUpdates(table));
            end;

        if rc = 0 then
          ShowMessage('Rien � publier')
        else
        begin
          ProgressBar2.Position := 0;
          ProgressBar2.Max := rc;
          ProgressBar1.Position := 0;
          ProgressBar1.Max := 1;

          for i := low(TablesSynchro) to high(TablesSynchro) do
            with TablesSynchro[i] do
              if ((version_mini = '') or (db_version >= version_mini)) and ((version_maxi = '') or (db_version < version_maxi)) then
              begin
                Label8.Caption := 'Synchronisation de ' + TableName;
                StartTimeTable := Now;
                case TypeSynchro of
                  tsNone:
                    begin
                      if RadioButton3.Checked or (ProcedureStockee <> '') then
                        SendData(1, 'TRUNCATE TABLE /*DB_PREFIX*/' + LowerCase(TableName), False);
                      SendDonnees(TablesSynchro[i]);
                    end;
                  tsImages:
                    if CheckBox2.Checked then
                    begin
                      SendData(4); // cr�ation du r�pertoire
                      if RadioButton3.Checked then
                      begin
                        SendData(6); // enlever toutes les images
                        SendData(1, 'TRUNCATE TABLE /*DB_PREFIX*/' + LowerCase(TableName), False);
                      end;
                      SendDonnees(TablesSynchro[i]);
                      SendImages(TablesSynchro[i]);
                    end;
                end;
              end;

          SendOption('moneysymbol', CleanHTTP(TGlobalVar.Utilisateur.Options.SymboleMonnetaire));
          SendOption('formattitrealbum', IntToStr(TGlobalVar.Utilisateur.Options.FormatTitreAlbum));
          SendOption('lastsynchro', DateToStr(StartTime, SQLSettings));

          ShowMessage('Publication termin�e');
        end;
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
begin
  DateTimePicker1.DateTime := IncMonth(Now, -1);
end;

procedure TfrmPublier.DateTimePicker1Change(Sender: TObject);
begin
  RadioButton2.Checked := True;
end;

end.
