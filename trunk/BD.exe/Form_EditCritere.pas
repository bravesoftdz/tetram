unit Form_EditCritere;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Fram_Boutons, StdCtrls, DBCtrls, Form_Recherche,
  ActnList, DBEditLabeled, ComboCheck;

type
  TFrmEditCritere = class(TForm)
    champs: TLightComboCheck;
    signes: TLightComboCheck;
    valeur: TEditLabeled;
    Frame11: TFrame1;
    Critere2: TLightComboCheck;
    ActionList1: TActionList;
    ActOk: TAction;
    procedure FormCreate(Sender: TObject);
    procedure champsChange(Sender: TObject);
    procedure SetCritere(const Value: RCritere);
    function GetCritere: RCritere;
    procedure FormDestroy(Sender: TObject);
    procedure ActOkExecute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
  private
    { Déclarations privées }
    wMin, WMax: Integer;
    FRecherche: TFrmRecherche;
  public
    { Déclarations publiques }
    property Critere: RCritere read GetCritere write SetCritere;
  end;

implementation

uses JvUIB, DM_Commun, Commun, DM_Princ, JvUIBLib;

{$R *.DFM}

type
  TChampSpecial = (csNone, csTitre, csGenre, csAffiche, csEtat, csReliure, csOrientation, csFormatEdition, csTypeEdition, csHistoire, csRemarques);

  PChamp = ^RChamp;
  RChamp = record
    NomChamp: string;
    NomTable: string;
    TypeData: TUIBFieldType;
    Booleen: Boolean;
    Special: TChampSpecial;
  end;

function TFrmEditCritere.GetCritere: RCritere;
var
  Champ: PChamp;
begin
  Result.iChamp := champs.Value;
  Result.iCritere2 := Critere2.Value;
  Result.iSignes := signes.Value;
  Result.valeurText := valeur.Text;
  Champ := PChamp(champs.LastItemData);
  Result.NomTable := Champ.NomTable;
  Result.TestSQL := Champ.NomTable + '.' + Champ.NomChamp;
  case Champ.Special of
    csEtat, csReliure, csOrientation, csFormatEdition, csGenre, csTypeEdition:
      case Result.iSignes of
        0: // Indifférent
          Result.TestSQL := Result.TestSQL + ' IS NOT NULL';
        1: // est
          Result.TestSQL := Result.TestSQL + '=' + IntToStr(Result.iCritere2);
        2: // n'est pas
          Result.TestSQL := Result.TestSQL + '<>' + IntToStr(Result.iCritere2);
      end;
    csAffiche:
      case Result.iSignes of
        1: // Oui
          Result.TestSQL := Result.TestSQL + ' IS NOT NULL';
        2: // Non
          Result.TestSQL := Result.TestSQL + ' IS NULL';
        3: // Valide
          Result.TestSQL := 'UDF_AFFICHEVALIDE(' + Result.TestSQL + ')';
        4: // (renseignée mais) Non valide
          Result.TestSQL := 'NOT UDF_AFFICHEVALIDE(' + Result.TestSQL + ')';
      end;
    csTitre:
      case Result.iSignes of
        1: // Vide ou contient
          Result.TestSQL := Format('(%s IS NULL OR %s LIKE ''%%%s%%'')', [Champ.NomTable + '.UPPER' + Champ.NomChamp, Champ.NomTable + '.UPPER' + Champ.NomChamp, UpperCase(valeur.Text)]);
        2: // Contient
          Result.TestSQL := Format('%s LIKE ''%%%s%%''', [Champ.NomTable + '.UPPER' + Champ.NomChamp, UpperCase(valeur.Text)]);
        3: // Ne contient pas
          Result.TestSQL := Format('NOT (%s LIKE ''%%%s%%'')', [Champ.NomTable + '.UPPER' + Champ.NomChamp, UpperCase(valeur.Text)]);
        4: // Ressemble
          Result.TestSQL := Format('%s LIKE UDF_SOUNDEX(''%%%s%%'', %d)', [Champ.NomTable + '.SOUNDEX' + Champ.NomChamp, UpperCase(valeur.Text), Integer(Result.iCritere2)]);
        5: // Ne ressemble pas
          Result.TestSQL := Format('NOT (%s LIKE UDF_SOUNDEX(''%%%s%%'', %d))', [Champ.NomTable + '.SOUNDEX' + Champ.NomChamp, UpperCase(valeur.Text), Integer(Result.iCritere2)]);
      end;
    csHistoire, csRemarques:
      case Result.iSignes of
        1: // Vide ou contient
          Result.TestSQL := Format('(%s IS NULL OR %s LIKE ''%%%s%%'')', [Champ.NomTable + '.UPPER' + Champ.NomChamp, Champ.NomTable + '.UPPER' + Champ.NomChamp, UpperCase(valeur.Text)]);
        2: // Contient
          Result.TestSQL := Format('%s LIKE ''%%%s%%''', [Champ.NomTable + '.UPPER' + Champ.NomChamp, UpperCase(valeur.Text)]);
        3: // Ne contient pas
          Result.TestSQL := Format('NOT (%s LIKE ''%%%s%%'')', [Champ.NomTable + '.UPPER' + Champ.NomChamp, UpperCase(valeur.Text)]);
      end;
    else
      case Champ.TypeData of
        uftInteger, uftSmallInt, uftFloat, uftNumeric:
          if Champ.Booleen then
            case Result.iSignes of
              1: Result.TestSQL := Result.TestSQL + '=1';
              2: Result.TestSQL := Result.TestSQL + '=0';
              3: Result.TestSQL := Format('(%s=1 OR %s IS NULL)', [Result.TestSQL, Result.TestSQL]);
              4: Result.TestSQL := Format('(%s=0 OR %s IS NULL)', [Result.TestSQL, Result.TestSQL]);
              5: Result.TestSQL := Result.TestSQL + ' IS NULL';
            end
          else
            Result.TestSQL := Result.TestSQL + signes.Caption + StringReplace(valeur.Text, DecimalSeparator, '.', []);
        uftChar, uftVarchar, uftBlob:
          case Result.iSignes of
            1: // Vide ou contient
              Result.TestSQL := Format('(%s IS NULL OR %s LIKE ''%%%s%%'')', [Result.TestSQL, Result.TestSQL, valeur.Text]);
            2: // Contient
              Result.TestSQL := Format('%s LIKE ''%%%s%%''', [Result.TestSQL, valeur.Text]);
            3: // Ne contient pas
              Result.TestSQL := Format('NOT (%s LIKE ''%%%s%%'')', [Result.TestSQL, valeur.Text]);
          end;
        else
          Result.TestSQL := '';
      end;
  end;
  Result.Champ := champs.Caption;
  Result.Test := signes.Caption;
  if Critere2.Visible and Critere2.Enabled then Result.Test := Result.Test + ' (' + Critere2.Caption + ')';
  if valeur.Visible then Result.Test := Result.Test + ' ' + valeur.Text;
end;

procedure TFrmEditCritere.SetCritere(const Value: RCritere);
begin
  champs.Value := Value.iChamp;
  champsChange(champs);
  signes.Value := Value.iSignes;
  valeur.Text := Value.valeurText;
  if Critere2.Visible and Critere2.Enabled then Critere2.Value := Value.iCritere2;
end;

procedure TFrmEditCritere.FormCreate(Sender: TObject);
const
  ListTables: array[0..2] of string = ('SERIES', 'ALBUMS', 'EDITIONS');
var
  i, j: Integer;
  t: string;
  pt: TPoint;
  Table1, Desc, LstChamps: TJvUIBQuery;
  p: PChamp;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  FRecherche := TFrmRecherche(Owner);
  pt := FRecherche.ClientToScreen(Point((FRecherche.Width - Width) div 2, (FRecherche.Height - Height) div 2));
  SetBounds(pt.x, pt.y, Width, Height);
  wMin := signes.Width;
  wMax := Critere2.Left + Critere2.Width - signes.Left;
  Table1 := TJvUIBQuery.Create(Self);
  Desc := TJvUIBQuery.Create(Self);
  LstChamps := TJvUIBQuery.Create(Self);
  champs.Items.Clear;
  with Table1 do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    for j := Low(ListTables) to High(ListTables) do begin
      Close;
      SQL.Text := 'SELECT FIRST 0 SKIP 0 * FROM ' + ListTables[j];
      Open;
      for i := 0 to Fields.FieldCount - 1 do begin
        t := FRecherche.TransChamps(Fields.SqlName[i]);
        if (t <> '') then begin
          New(p);
          p.NomChamp := UpperCase(Fields.SqlName[i]);
          p.NomTable := ListTables[j];
          p.TypeData := Fields.FieldType[i];
          p.Booleen := (p.TypeData = uftSmallInt) and FRecherche.IsValChampBoolean(FRecherche.ValChamps(t));
          case FRecherche.ValChamps(t) of
            1, 8: p.Special := csTitre;
            6, 9: p.Special := csHistoire;
            7, 10: p.Special := csRemarques;
            21: p.Special := csEtat;
            22: p.Special := csReliure;
            24: p.Special := csOrientation;
            25: p.Special := csFormatEdition;
            26: p.Special := csTypeEdition;
            else
              p.Special := csNone;
          end;
          with champs.Items.Add do begin
            Caption := t;
            Data := TObject(p);
          end;
        end;
      end;
    end;

    New(p);
    p.NomChamp := 'ID_Genre';
    p.NomTable := 'GENRESERIES';
    p.TypeData := uftChar;
    p.Special := csGenre;
    with champs.Items.Add do begin
      Caption := FRecherche.TransChamps('genreserie'); // ne pas traduire
      Data := TObject(p);
    end;

  finally
    Transaction.Free;
    Free;
    LstChamps.Free;
    Desc.Free;
  end;
end;

procedure TFrmEditCritere.champsChange(Sender: TObject);

  procedure AssignItems(Items: TItems; Source: TJvUIBQuery); overload;
  begin
    try
      Source.Transaction := GetTransaction(DMPrinc.UIBDataBase);
      Items.Clear;
      Source.Open;
      while not Source.Eof do begin
        with Items.Add do begin
          Caption := Source.Fields.AsString[1];
          Valeur := Source.Fields.AsInteger[0];
        end;
        Source.Next;
      end;
      Source.Close;
    finally
      Source.Transaction.Free;
    end;
  end;

  procedure AssignItems(Items: TStrings; Source: TJvUIBQuery); overload;
  begin
    try
      Source.Transaction := GetTransaction(DMPrinc.UIBDataBase);
      Items.Clear;
      Source.Open;
      while not Source.Eof do begin
        Items.AddObject(Source.Fields.AsString[1], Pointer(Source.Fields.AsInteger[0]));
        Source.Next;
      end;
      Source.Close;
    finally
      Source.Transaction.Free;
    end;
  end;

begin
  valeur.Text := '';
  signes.Items.Clear;
  Critere2.Items.Clear;
  signes.Tag := 0;
  case PChamp(champs.LastItemData).Special of
    csTitre: begin
        AssignItems(signes.Items, DataCommun.TCritereTitre);
        AssignItems(Critere2.Items, DataCommun.TCritereLangueTitre);
        signes.Tag := 1;
        valeur.Visible := True;
      end;
    csGenre: begin
        AssignItems(signes.Items, DataCommun.TCritereListe);
        AssignItems(Critere2.Items, DataCommun.TGenre);
        valeur.Visible := False;
        signes.Tag := 2;
      end;
    csAffiche: begin
        AssignItems(signes.Items, DataCommun.TCritereAffiche);
        valeur.Visible := False;
      end;
    csEtat: begin
        AssignItems(signes.Items, DataCommun.TCritereListe);
        AssignItems(Critere2.Items, DataCommun.TCritereEtat);
        signes.Tag := 2;
        valeur.Visible := False;
      end;
    csReliure: begin
        AssignItems(signes.Items, DataCommun.TCritereListe);
        AssignItems(Critere2.Items, DataCommun.TCritereReliure);
        signes.Tag := 2;
        valeur.Visible := False;
      end;
    else
      case PChamp(champs.LastItemData).TypeData of
        uftChar, uftVarchar, uftBlob: begin
            AssignItems(signes.Items, DataCommun.TCritereString);
            valeur.Visible := True;
          end;
        uftSmallInt, uftInteger, uftFloat, uftNumeric:
          if PChamp(champs.LastItemData).Booleen then begin
            AssignItems(signes.Items, DataCommun.TCritereBoolean);
            valeur.Visible := False;
          end
          else begin
            AssignItems(signes.Items, DataCommun.TCritereNumeral);
            valeur.Visible := True;
          end;
        uftDate, uftTime, uftTimestamp: begin
            AssignItems(signes.Items, DataCommun.TCritereNumeral);
            valeur.Visible := True;
          end;
      end;
  end;
  if valeur.Visible then
    case PChamp(champs.LastItemData).TypeData of
      uftChar, uftVarchar, uftBlob: valeur.TypeDonnee := tdChaine;
      uftSmallInt, uftInteger: valeur.TypeDonnee := tdEntierSigne;
      uftFloat, uftNumeric: valeur.TypeDonnee := tdNumericSigne;
      uftDate: valeur.TypeDonnee := tdDate;
      uftTime: valeur.TypeDonnee := tdHeure;
      uftTimestamp: valeur.TypeDonnee := tdDateHeure;
    end;
  signes.Visible := Bool(signes.Items.Count);
  if signes.Visible then signes.Checked := False;
  Critere2.Visible := Bool(Critere2.Items.Count);
  if Critere2.Visible then Critere2.Checked := False;
  signes.Width := IIf(Critere2.Visible, wMin, wMax);
end;

procedure TFrmEditCritere.FormDestroy(Sender: TObject);
var
  i: Integer;
  p: PChamp;
begin
  champs.Items.BeginUpdate;
  try
    for i := 0 to champs.Items.Count - 1 do begin
      p := PChamp(champs.Items.Items[i].Data);
      Dispose(p);
    end;
  finally
    champs.Items.EndUpdate;
  end;
end;

procedure TFrmEditCritere.ActOkExecute(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFrmEditCritere.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
begin
  Critere2.Enabled := Critere2.Visible
    and (
    ((signes.Tag = 1 {DataCommun.TCritereTitre}) and (signes.Checked) and (signes.Value in [4..5]))
    or ((signes.Tag = 2 {DataCommun.TCritereListe}) and (signes.Checked) and (signes.Value >= 0))
    );
  ActOK.Enabled := (champs.Checked)
    and (signes.Checked)
    and (not valeur.Visible or (valeur.Text <> ''))
    and (not Critere2.Visible or (not Critere2.Enabled) or (Critere2.Checked));
end;

end.
