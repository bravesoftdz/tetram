unit BDTK.Web.Forms.Publish;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ComCtrls, ExtCtrls, BD.GUI.Frames.Buttons, BD.GUI.Forms;

type
  TfrmPublier = class(TbdtForm)
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
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

{$R *.dfm}

uses Math, BD.Utils.Net, Divers, BDTK.Updates, UIB, UIBLib, BDTK.GUI.DataModules.Main, BD.Utils.StrUtils, DateUtils, BD.Utils.GUIUtils, BD.Common, VarUtils, StrUtils,
  Generics.Collections, JclMime, BDTK.GUI.Utils, BDTK.Web;

type
  TPublicationWeb = class(TWeb)
  public type
    TSynchroSpecial = (tsNone, tsImages);

    RInfoTable = record
      TableName: string;
      ID: string;
      version_mini, version_maxi: string;
      TypeSynchro: TSynchroSpecial;
      SkipFields, UpperFields: string;
      ProcedureStockee: string;
    end;

    TInitProgressBars = reference to procedure(Full: Boolean; Count: Integer);
    TRefreshProgressBars = reference to procedure(StartTime, StartTimeTable: TDateTime);
    TShowStep = reference to procedure(const Step: string);
    TDebug = reference to procedure;

  public const
    ActionEmptyTable = ActionUpdateScript;
    ActionSendUpdateData = ActionSendOption;
    ActionCreateImagesDirectory = 4;
    ActionEmptyImagesDirectory = 6;

    TablesSynchro: array [1 .. 16] of RInfoTable = (
      (TableName: 'PERSONNES'; ID: 'id_personne'; SkipFields: 'ds_personnes'; UpperFields: 'nompersonne'),
      (TableName: 'EDITEURS'; ID: 'id_editeur'; SkipFields: 'ds_editeurs'; UpperFields: 'nomediteur'),
      (TableName: 'COLLECTIONS'; ID: 'id_collection'; SkipFields: 'ds_collections'; UpperFields: 'nomcollection'),
      (TableName: 'SERIES'; ID: 'id_serie'; SkipFields: 'etat=1.0.0.1@reliure=1.0.0.1@typeedition=1.0.0.1@orientation=1.0.0.1@formatedition=1.0.0.1@senslecture=1.0.0.1@vo=1.0.0.1@couleur=1.0.0.1@notation@ds_series'; UpperFields: 'titreserie@sujetserie@remarquesserie'),
      (TableName: 'ALBUMS'; ID: 'id_album'; SkipFields: 'notation@ds_albums'; UpperFields: 'titrealbum@sujetalbum@remarquesalbum'),
      (TableName: 'EDITIONS'; ID: 'id_edition'; SkipFields: 'ds_editions'),
      (TableName: 'AUTEURS'; ID: 'id_auteur'; SkipFields: 'ds_auteurs'),
      (TableName: 'GENRES'; ID: 'id_genre'; SkipFields: 'ds_genres'; UpperFields: 'genre'),
      (TableName: 'GENRESERIES'; ID: 'id_genreseries'; SkipFields: 'ds_genreseries'),
      (TableName: 'LISTES'; ID: 'id_liste'; SkipFields: 'ds_listes'),
      (TableName: 'ALBUMS_MANQUANTS'; UpperFields: 'titreserie'; ProcedureStockee: 'ALBUMS_MANQUANTS(1, 1, NULL)'),
      (TableName: 'PREVISIONS_SORTIES'; UpperFields: 'titreserie'; ProcedureStockee: 'PREVISIONS_SORTIES(1, NULL)'),
      (TableName: 'COUVERTURES'; ID: 'id_couverture'; TypeSynchro: tsImages; SkipFields: 'stockagecouverture@imagecouverture@fichiercouverture@ds_couvertures'),
      (TableName: 'UNIVERS'; ID: 'id_univers'; SkipFields: 'ds_univers'; UpperFields: 'nomunivers'),
      (TableName: 'SERIES_UNIVERS'; ID: 'id_serie_univers'; SkipFields: 'ds_series_univers'),
      (TableName: 'ALBUMS_UNIVERS'; ID: 'id_album_univers'; SkipFields: 'ds_albums_univers'));
  private
    FStartTime: TDateTime;
    FUpgradeFromDate: TDate;
    FInitProgressBars: TInitProgressBars;
    FShowStep: TShowStep;
    FStartTimeTable: TDateTime;
    FRefreshProgressBars: TRefreshProgressBars;
    FDebug: TDebug;
    function GetSQL(const InfoTable: RInfoTable; withCount: Boolean): string;
    function CompteUpdates(Query: TUIBQuery; const InfoTable: RInfoTable): Integer;
    procedure SendDonnees(Query: TUIBQuery; const InfoTable: RInfoTable);
    procedure SendImages(Query: TUIBQuery; const InfoTable: RInfoTable);
    procedure SendDataset(Query: TUIBQuery; const InfoTable: RInfoTable; isDelete: Boolean = False);
  protected
    procedure SendOption(const cle, Valeur: string); override;
  public
    constructor Create; reintroduce;

    procedure Publish(fromDate: TDate; fullPublish: Boolean; includeImages: Boolean);

    property InitProgressBars: TInitProgressBars read FInitProgressBars write FInitProgressBars;
    property RefreshProgressBars: TRefreshProgressBars read FRefreshProgressBars write FRefreshProgressBars;
    property ShowStep: TShowStep read FShowStep write FShowStep;

    property Debug: TDebug read FDebug write FDebug;
  end;

procedure TfrmPublier.Button1Click(Sender: TObject);
var
  UpgradeFromDate: TDate;
  web: TPublicationWeb;
begin
  web := TPublicationWeb.Create;
  try
    web.InitProgressBars := procedure(Full: Boolean; Count: Integer)
      begin
        if Full then
        begin
          ProgressBar2.Position := 0;
          ProgressBar2.Max := Count;
        end
        else
        begin
          ProgressBar1.Position := 0;
          ProgressBar1.Max := Count;
        end;
      end;
    web.RefreshProgressBars := procedure(StartTime, StartTimeTable: TDateTime)
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
          moyExecTimeTable := 10; // au départ la moyenne n'est pas forcément très juste: par tatonnement, il faut au moins 10ms par enregistrement
        if OperationFaitesAutresTables = 0 then
          moyExecTimeAutresTables := moyExecTimeTable
        else
          moyExecTimeAutresTables := ExecTimeAutresTables div OperationFaitesAutresTables;
        if moyExecTimeAutresTables < 10 then
          moyExecTimeAutresTables := 10; // au départ la moyenne n'est pas forcément très juste: par tatonnement, il faut au moins 10ms par enregistrement

        TempsRestantTable := moyExecTimeTable * OperationRestantTable;
        TempsRestantAutresTables := moyExecTimeAutresTables * OperationRestantAutresTables;
        TempsRestantTotal := TempsRestantTable + TempsRestantAutresTables;

        Label9.Caption := Format('Fin estimée : %s (%s)', [FormatDateTime('HH:mm:ss', IncMilliSecond(Now, TempsRestantTotal)),
          TimeToStr(IncMilliSecond(0, TempsRestantTotal))]);
        Application.ProcessMessages;
      end;

    web.ShowStep := procedure(const Step: string)
      begin
        Label8.Caption := Step;
      end;

    web.Debug := procedure
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

    web.CheckVersions;

    web.UpgradeDB;

    if RadioButton1.Checked then
      UpgradeFromDate := StrToDateDef(web.GetOption('lastsynchro'), -1, TGlobalVar.SQLSettings)
    else if RadioButton2.Checked then
      UpgradeFromDate := Trunc(DateTimePicker1.Date)
    else
      UpgradeFromDate := -1;

    web.Publish(UpgradeFromDate, RadioButton3.Checked, CheckBox2.Checked);
  finally
    ProgressBar2.Position := 0;
    ProgressBar1.Position := 0;
    web.Free;
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

{ TPublicationWeb }

function TPublicationWeb.CompteUpdates(Query: TUIBQuery; const InfoTable: RInfoTable): Integer;
begin
  Query.SQL.Text := GetSQL(InfoTable, True);
  if Query.Params.FieldCount > 0 then
    Query.Params.AsDate[0] := Trunc(FUpgradeFromDate);
  Query.Open;
  Result := Query.Fields.AsInteger[0];
  Query.Close;

  if InfoTable.ID <> '' then
  begin
    Query.SQL.Text := 'select count(*) from suppressions where tablename = :table and dm_suppressions >= :UpgradeFromDate';
    Query.Prepare(True);
    Query.Params.AsString[0] := Copy(InfoTable.TableName, 1, Query.Params.MaxStrLen[0]);
    Query.Params.AsDate[1] := Trunc(FUpgradeFromDate);
    Query.Open;
    Inc(Result, Query.Fields.AsInteger[0]);
    Query.Close;
  end;
end;

constructor TPublicationWeb.Create;
begin
  inherited Create(TGlobalVar.SiteWeb, 'interface.php');
  AddXMLHeader := True;
end;

function TPublicationWeb.GetSQL(const InfoTable: RInfoTable; withCount: Boolean): string;
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

procedure TPublicationWeb.Publish(fromDate: TDate; fullPublish: Boolean; includeImages: Boolean);
var
  qry: TUIBQuery;
  rc: Integer;
  table: RInfoTable;
begin
  FUpgradeFromDate := fromDate;
  FStartTime := Now;

  qry := dmPrinc.DBConnection.GetQuery;
  try
    qry.FetchBlobs := True;

    rc := 0;
    for table in TPublicationWeb.TablesSynchro do
      if ((table.version_mini = '') or (DBVersion >= table.version_mini)) and ((table.version_maxi = '') or (DBVersion < table.version_maxi)) then
        case table.TypeSynchro of
          tsImages:
            if includeImages then
              Inc(rc, CompteUpdates(qry, table) * 2); // la synchro des images est faite en 2 fois : les données puis les fichiers
        else
          Inc(rc, CompteUpdates(qry, table));
        end;

    if rc = 0 then
    begin
      SendOption('lastsynchro', DateToStr(FStartTime, TGlobalVar.SQLSettings));
      ShowMessage('Rien à publier');
    end
    else
    begin
      if Assigned(FInitProgressBars) then
      begin
        FInitProgressBars(True, rc);
        FInitProgressBars(False, 1);
      end;

      for table in TPublicationWeb.TablesSynchro do
      begin
        if ((table.version_mini = '') or (DBVersion >= table.version_mini)) and ((table.version_maxi = '') or (DBVersion < table.version_maxi)) then
        begin
          if Assigned(FShowStep) then
            FShowStep('Synchronisation de ' + table.TableName);
          FStartTimeTable := Now;
          case table.TypeSynchro of
            tsNone:
              begin
                if fullPublish or (table.ProcedureStockee <> '') then
                  SendData(ActionEmptyTable, 'TRUNCATE TABLE /*DB_PREFIX*/' + LowerCase(table.TableName));
                SendDonnees(qry, table);
              end;
            tsImages:
              if includeImages then
              begin
                SendData(ActionCreateImagesDirectory); // création du répertoire
                if fullPublish then
                begin
                  SendData(ActionEmptyImagesDirectory); // enlever toutes les images
                  SendData(ActionEmptyTable, 'TRUNCATE TABLE /*DB_PREFIX*/' + LowerCase(table.TableName));
                end;
                SendDonnees(qry, table);
                SendImages(qry, table);
              end;
          end;
        end;
      end;
      SendOption('moneysymbol', CleanHTTP(TGlobalVar.Options.SymboleMonnetaire));
      SendOption('formattitrealbum', IntToStr(TGlobalVar.Options.FormatTitreAlbum));
      SendOption('lastsynchro', DateToStr(FStartTime, TGlobalVar.SQLSettings));

      ShowMessage('Publication terminée');
    end;
  finally
    qry.Free;
  end;
end;

procedure TPublicationWeb.SendDataset(Query: TUIBQuery; const InfoTable: RInfoTable; isDelete: Boolean);

  procedure SendXML(const XML: string);
  var
    i: Integer;
  begin
    SendData(TPublicationWeb.ActionSendUpdateData, XML);

    i := 0;
    if (GetLabel(i) <> 'done') and Assigned(FDebug) then
      FDebug;
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

    for i := 0 to Pred(Query.Fields.FieldCount) do
    begin
      champ := LowerCase(Query.Fields.AliasName[i]);

      // champ à passer ?
      s := '@' + InfoTable.SkipFields + '@';
      l := Pos('@' + champ + '=', s);
      if l > 0 then
      begin
        l := l + Length(champ) + 2;
        if DBVersion >= Copy(s, l, PosEx('@', s, l) - l) then
          listFields.Add(i);
        Continue; // ce n'est pas grave si on ne fait pas le test du champ à upper: si on l'a passé c'est qu'il ne l'est pas
      end;
      if Pos('@' + champ + '@', s) = 0 then
        listFields.Add(i);

      s := '@' + InfoTable.UpperFields + '@';
      l := Pos('@' + champ + '=', s);
      if l > 0 then
      begin
        l := l + Length(champ) + 2;
        if DBVersion >= Copy(s, l, PosEx('@', s, l) - l) then
          listUpperFields.Add(i);
        Continue;
      end;
      if Pos('@' + champ + '@', s) > 0 then
        listUpperFields.Add(i);
    end;
    bodyXML := '';
    while not Query.Eof do
    begin
      recordXML := '';
      for l := 0 to Pred(listFields.Count) do
      begin
        i := listFields[l];
        champ := LowerCase(Query.Fields.AliasName[i]);
        if Query.Fields.IsNull[i] then
          contenuChamp := ''
        else
        begin
          case Query.Fields.FieldType[i] of
            uftDate:
              contenuChamp := DateToStr(Query.Fields.AsDate[i], TGlobalVar.SQLSettings);
            uftTimestamp:
              contenuChamp := DateToStr(Query.Fields.AsDateTime[i], TGlobalVar.SQLSettings) + ' ' + TimeToStr(Query.Fields.AsDateTime[i], TGlobalVar.SQLSettings);
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
              contenuChamp := StringReplace(Query.Fields.AsString[i], FormatSettings.DecimalSeparator, '.', []);
          else
            contenuChamp := Trim(Query.Fields.AsString[i]);
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
          AjoutString(recordXML, CleanHTTP(contenuChamp), '', Format('<%s%s>', [champ, IIf(Query.Fields.FieldType[i] = uftBlob,
            { ' type="B"' } '', '')]), Format('</%s>', [champ]));
          if listUpperFields.IndexOf(i) <> -1 then
            AjoutString(recordXML, CleanHTTP(UpperCase(SansAccents(contenuChamp))), '',
              Format('<%s%s>', ['upper' + champ, IIf(Query.Fields.FieldType[i] = uftBlob, { ' type="B"' } '', '')]), Format('</%s>', ['upper' + champ]));
        end;
      end;
      AjoutString(bodyXML, recordXML, '', '<record' + IIf(isDelete, ' action="D"', '') + '>', '</record>');
      if Length(bodyXML) > Site.Paquets then
      begin
        SendXML(Format('<data>%s<records>%s</records></data>', [enteteXML, bodyXML]));
        bodyXML := '';
      end;

      Query.Next;
      if Assigned(RefreshProgressBars) then
        RefreshProgressBars(FStartTime, FStartTimeTable);
    end;
    if Length(bodyXML) > 0 then
      SendXML(Format('<data>%s<records>%s</records></data>', [enteteXML, bodyXML]));
  finally
    listFields.Free;
    listUpperFields.Free;
  end;
end;

procedure TPublicationWeb.SendDonnees(Query: TUIBQuery; const InfoTable: RInfoTable);
begin
  if Assigned(FInitProgressBars) then
    FInitProgressBars(False, CompteUpdates(Query, InfoTable));

  Query.SQL.Text := GetSQL(InfoTable, False);
  if Query.Params.FieldCount > 0 then
    Query.Params.AsDate[0] := Trunc(FUpgradeFromDate);
  Query.Open;
  SendDataset(Query, InfoTable);
  Query.Close;

  if InfoTable.ID <> '' then
  begin
    Query.SQL.Text := 'select ID as ' + InfoTable.ID +
      ' from suppressions where tablename = :table and dm_suppressions >= :UpgradeFromDate order by dm_suppressions';
    Query.Prepare(True);
    Query.Params.AsString[0] := Copy(InfoTable.TableName, 1, Query.Params.MaxStrLen[0]);
    Query.Params.AsDate[1] := Trunc(FUpgradeFromDate);
    Query.Open;
    SendDataset(Query, InfoTable, True);
    Query.Close;
  end;
  SendData(ActionUpdateScript, 'OPTIMIZE TABLE /*DB_PREFIX*/' + InfoTable.TableName);
end;

procedure TPublicationWeb.SendImages(Query: TUIBQuery; const InfoTable: RInfoTable);
var
  ms: TStream;
  es: TStringStream;
  l: Integer;
begin
  if Assigned(FInitProgressBars) then
    FInitProgressBars(False, CompteUpdates(Query, InfoTable));

  Query.SQL.Text := GetSQL(InfoTable, False);
  if Query.Params.FieldCount > 0 then
    Query.Params.AsDate[0] := Trunc(FUpgradeFromDate);
  Query.Open;
  while not Query.Eof do
  begin
    SetLength(FParam, ParamLengthMin + 2);
    FParam[ParamLengthMin + 0].Nom := 'action';
    FParam[ParamLengthMin + 0].Valeur := '8';
    FParam[ParamLengthMin + 1].Nom := 'ID';
    FParam[ParamLengthMin + 1].Valeur := string(MimeEncodeStringNoCRLF(AnsiString(UTF8String(Query.Fields.ByNameAsString[InfoTable.ID]))));
    PostHTTP;
    l := 0;
    if GetLabel(l) = 'file not found' then
    begin
      ms := GetCouvertureStream(False, StringToGUIDDef(Query.Fields.ByNameAsString[InfoTable.ID], GUID_NULL), 400, 500,
        TGlobalVar.Options.AntiAliasing);
      if Assigned(ms) then
      begin
        es := TStringStream.Create('');
        try
          MimeEncodeStream(ms, es);
          SetLength(FParam, ParamLengthMin + 3);
          FParam[ParamLengthMin + 0].Nom := 'action';
          FParam[ParamLengthMin + 0].Valeur := '7';
          FParam[ParamLengthMin + 1].Nom := 'ID';
          FParam[ParamLengthMin + 1].Valeur := string(MimeEncodeStringNoCRLF(AnsiString(UTF8String(Query.Fields.ByNameAsString[InfoTable.ID]))));
          FParam[ParamLengthMin + 2].Nom := 'image';
          FParam[ParamLengthMin + 2].Valeur := es.DataString;
          PostHTTP;
        finally
          es.Free;
          ms.Free;
        end;
      end;
    end;
    Query.Next;
    if Assigned(RefreshProgressBars) then
      RefreshProgressBars(FStartTime, FStartTimeTable);
  end;
end;

procedure TPublicationWeb.SendOption(const cle, Valeur: string);
begin
  SendData(ActionSendOption, '<data><table>options</table><primarykey>cle</primarykey><records><record><cle>' + CleanHTTP(cle) + '</cle><valeur>' +
    CleanHTTP(Valeur) + '</valeur></record></records></data>');
end;

end.
