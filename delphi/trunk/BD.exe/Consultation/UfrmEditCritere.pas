unit UfrmEditCritere;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, System.Types, UframBoutons, StdCtrls, DBCtrls, UfrmRecherche,
  ActnList, EditLabeled, ComboCheck, ComCtrls, LoadComplet, UBdtForms,
  System.Actions;

type
  TfrmEditCritere = class(TbdtForm)
    champs: TLightComboCheck;
    signes: TLightComboCheck;
    valeur: TEditLabeled;
    Frame11: TframBoutons;
    Critere2: TLightComboCheck;
    ActionList1: TActionList;
    ActOk: TAction;
    procedure FormCreate(Sender: TObject);
    procedure champsChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ActOkExecute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
  private
    { Déclarations privées }
    wMin, WMax: Integer;
    FRecherche: TFrmRecherche;
    FChampValeurs: TStringList;
    FCritere: TCritere;
    procedure SetCritere(Value: TCritere);
    function GetCritere: TCritere;
  public
    { Déclarations publiques }
    property Critere: TCritere read GetCritere write SetCritere;
  end;

implementation

uses UIB, UdmCommun, Commun, UdmPrinc, UIBLib, Divers,
  UChampsRecherche;

{$R *.DFM}

function TfrmEditCritere.GetCritere: TCritere;
var
  Champ: PChamp;
  critereTexte: string;
begin
  Result := FCritere;

  Champ := PChamp(champs.LastItemData);

  Result.iChamp := champs.Value;
  Result.iCritere2 := Critere2.Value;
  Result.iSignes := signes.Value;
  Result.valeurText := valeur.Text;
  if Champ.Special = csGenre then
    Result.valeurText := FChampValeurs[Result.iCritere2];
  Result.NomTable := Champ.NomTable;
  Result.TestSQL := string(Champ.NomTable + '.' + Champ.NomChamp);
  critereTexte := UpperCase(SansAccents(Result.valeurText));
  case Champ.Special of
    csGenre:
      case Result.iSignes of
        0: // Indifférent
          Result.TestSQL := Result.TestSQL + ' IS NOT NULL';
        1: // est
          Result.TestSQL := Result.TestSQL + '=' + QuotedStr(critereTexte);
        2: // n'est pas
          Result.TestSQL := Result.TestSQL + '<>' + QuotedStr(critereTexte);
      end;
    csEtat, csReliure, csOrientation, csFormatEdition, csTypeEdition, csSensLecture:
      case Result.iSignes of
        0: // Indifférent
          Result.TestSQL := Result.TestSQL + ' IS NOT NULL';
        1: // est
          Result.TestSQL := Result.TestSQL + '=' + IntToStr(Result.iCritere2);
        2: // n'est pas
          Result.TestSQL := Result.TestSQL + '<>' + IntToStr(Result.iCritere2);
      end;
    csNotation:
      case Result.iSignes of
        0: // Indifférent
          Result.TestSQL := 'coalesce(' + Result.TestSQL + ',0)>0';
        1: // est
          Result.TestSQL := 'coalesce(' + Result.TestSQL + ',0)=' + IntToStr(Result.iCritere2);
        2: // n'est pas
          Result.TestSQL := 'coalesce(' + Result.TestSQL + ',0)<>' + IntToStr(Result.iCritere2);
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
          Result.TestSQL := Format('(%s IS NULL OR %s CONTAINING %s)', [Champ.NomTable + '.' + Champ.NomChamp, Champ.NomTable + '.' + Champ.NomChamp, QuotedStr(critereTexte)]);
        2: // Contient
          Result.TestSQL := Format('%s CONTAINING %s', [Champ.NomTable + '.' + Champ.NomChamp, QuotedStr(critereTexte)]);
        3: // Ne contient pas
          Result.TestSQL := Format('NOT (%s CONTAINING %s)', [Champ.NomTable + '.' + Champ.NomChamp, QuotedStr(critereTexte)]);
        4: // Ressemble
          Result.TestSQL := Format('%s CONTAINING UDF_SOUNDEX(%s, %d)', [Champ.NomTable + '.SOUNDEX' + Champ.NomChamp, QuotedStr(critereTexte), Integer(Result.iCritere2)]);
        5: // Ne ressemble pas
          Result.TestSQL := Format('NOT (%s CONTAINING UDF_SOUNDEX(%s, %d))', [Champ.NomTable + '.SOUNDEX' + Champ.NomChamp, QuotedStr(critereTexte), Integer(Result.iCritere2)]);
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
            Result.TestSQL := Result.TestSQL + signes.Caption + StringReplace(valeur.Text, FormatSettings.DecimalSeparator, '.', []);
        uftChar, uftVarchar, uftBlob:
          case Result.iSignes of
            1: // Vide ou contient
              Result.TestSQL := Format('(%s IS NULL OR %s CONTAINING %s)', [Result.TestSQL, Result.TestSQL, QuotedStr(critereTexte)]);
            2: // Contient
              Result.TestSQL := Format('%s CONTAINING %s', [Result.TestSQL, QuotedStr(critereTexte)]);
            3: // Ne contient pas
              Result.TestSQL := Format('NOT (%s CONTAINING %s)', [Result.TestSQL, QuotedStr(critereTexte)]);
          end;
        uftDate:
          Result.TestSQL := Result.TestSQL + signes.Caption + QuotedStr(FormatDateTime('YYYY-MM-DD', StrToDate(valeur.Text)));
        else
          Result.TestSQL := '';
      end;
  end;
  Result.Champ := champs.Caption;
  Result.Test := signes.Caption;
  if Critere2.Visible and Critere2.Enabled then Result.Test := Result.Test + ' (' + Critere2.Caption + ')';
  if valeur.Visible then Result.Test := Result.Test + ' ' + valeur.Text;
end;

procedure TfrmEditCritere.SetCritere(Value: TCritere);
begin
  FCritere.Assign(Value);
  champs.Value := FCritere.iChamp;
  champsChange(champs);
  signes.Value := FCritere.iSignes;
  valeur.Text := FCritere.valeurText;
  if Critere2.Visible and Critere2.Enabled then Critere2.Value := FCritere.iCritere2;
end;

type
  TCrackWinControl = class(TWinControl)
  end;

procedure TfrmEditCritere.FormCreate(Sender: TObject);
const
  ListTables: array[0..2] of string = ('SERIES', 'ALBUMS', 'EDITIONS');
  NomTables: array[0..2] of string = ('Série', 'Album', 'Edition');
var
  i, j: Integer;
  pt: TPoint;
  hg: IHourGlass;
  ParentItem: TSubItem;
begin
  hg := THourGlass.Create;
  FRecherche := TFrmRecherche(Owner);
  FChampValeurs := TStringList.Create;
  FCritere := TCritere.Create(nil);
  pt := FRecherche.ClientToScreen(Point((FRecherche.Width - Width) div 2, (FRecherche.Height - Height) div 2));
  SetBounds(pt.x, pt.y, Width, Height);
  wMin := signes.Width;
  wMax := Critere2.Left + Critere2.Width - signes.Left;
  champs.Items.Clear;
  for j := Low(Groupes) to High(Groupes) do
  begin
    ParentItem := champs.Items.Add(Groupes[j]);
    for i := 1 to High(ChampsRecherche^) do
      if j = ChampsRecherche^[i].Groupe then
        with ParentItem.SubItems.Add(ChampsRecherche^[i].LibelleChamp) do
        begin
          Valeur := ChampsRecherche^[i].ID;
          Data := TObject(@ChampsRecherche^[i]);
        end;
  end;
end;

procedure TfrmEditCritere.champsChange(Sender: TObject);

  procedure AssignItems(Items: TItems; Source: TUIBQuery; ChampValeurs: TStrings); overload;
  begin
    try
      Source.Transaction := GetTransaction(DMPrinc.UIBDataBase);
      Items.Clear;
      FChampValeurs.Clear;
      Source.Open;
      while not Source.Eof do
      begin
        with Items.Add do
        begin
          Caption := Source.Fields.AsString[1];
          Valeur := Index;
          ChampValeurs.Add(Source.Fields.AsString[0]);
        end;
        Source.Next;
      end;
      Source.Close;
    finally
      Source.Transaction.Free;
    end;
  end;

  procedure AssignItems(Items: TItems; Source: TUIBQuery); overload;
  begin
    try
      Source.Transaction := GetTransaction(DMPrinc.UIBDataBase);
      Items.Clear;
      FChampValeurs.Clear;
      Source.Open;
      while not Source.Eof do
      begin
        with Items.Add do
        begin
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

begin
  valeur.Text := '';
  signes.Items.Clear;
  Critere2.Items.Clear;
  signes.Tag := 0;
  case PChamp(champs.LastItemData).Special of
    csTitre:
      begin
        AssignItems(signes.Items, dmCommun.TCritereTitre);
        AssignItems(Critere2.Items, dmCommun.TCritereLangueTitre);
        signes.Tag := 1;
        valeur.Visible := True;
      end;
    csGenre:
      begin
        AssignItems(signes.Items, dmCommun.TCritereListe);
        AssignItems(Critere2.Items, dmCommun.TGenre, FChampValeurs);
        signes.Tag := 2;
        valeur.Visible := False;
      end;
    csAffiche:
      begin
        AssignItems(signes.Items, dmCommun.TCritereAffiche);
        valeur.Visible := False;
      end;
    csEtat:
      begin
        AssignItems(signes.Items, dmCommun.TCritereListe);
        AssignItems(Critere2.Items, dmCommun.TCritereEtat);
        signes.Tag := 2;
        valeur.Visible := False;
      end;
    csReliure:
      begin
        AssignItems(signes.Items, dmCommun.TCritereListe);
        AssignItems(Critere2.Items, dmCommun.TCritereReliure);
        signes.Tag := 2;
        valeur.Visible := False;
      end;
    csSensLecture:
      begin
        AssignItems(signes.Items, dmCommun.TCritereListe);
        AssignItems(Critere2.Items, dmCommun.TCritereSensLecture);
        signes.Tag := 2;
        valeur.Visible := False;
      end;
    csNotation:
      begin
        AssignItems(signes.Items, dmCommun.TCritereListe);
        AssignItems(Critere2.Items, dmCommun.TCritereNotation);
        signes.Tag := 2;
        valeur.Visible := False;
      end;
    else
      case PChamp(champs.LastItemData).TypeData of
        uftChar, uftVarchar, uftBlob:
          begin
            AssignItems(signes.Items, dmCommun.TCritereString);
            valeur.Visible := True;
          end;
        uftSmallInt, uftInteger, uftFloat, uftNumeric:
          if PChamp(champs.LastItemData).Booleen then
          begin
            AssignItems(signes.Items, dmCommun.TCritereBoolean);
            valeur.Visible := False;
          end
          else
          begin
            AssignItems(signes.Items, dmCommun.TCritereNumeral);
            valeur.Visible := True;
          end;
        uftDate, uftTime, uftTimestamp:
          begin
            AssignItems(signes.Items, dmCommun.TCritereNumeral);
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
  signes.Visible := LongBool(signes.Items.Count);
  if signes.Visible then signes.Checked := False;
  Critere2.Visible := LongBool(Critere2.Items.Count);
  if Critere2.Visible then Critere2.Checked := False;
  signes.Width := IIf(Critere2.Visible, wMin, wMax);
end;

procedure TfrmEditCritere.FormDestroy(Sender: TObject);
begin
  FChampValeurs.Free;
  FCritere.Free;
end;

procedure TfrmEditCritere.ActOkExecute(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrmEditCritere.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
begin
  Critere2.Enabled := Critere2.Visible
    and (
    ((signes.Tag = 1 {DataCommun.TCritereTitre}) and (signes.Checked) and (signes.Value in [4..5]))
    or ((signes.Tag = 2 {DataCommun.TCritereListe}) and (signes.Checked) and (signes.Value > 0))
    );
  ActOk.Enabled := (champs.Checked)
    and (signes.Checked)
    and (not valeur.Visible or (valeur.Text <> ''))
    and (not Critere2.Visible or (not Critere2.Enabled) or (Critere2.Checked));
end;

end.

