unit Form_Recherche;

interface

uses
  SysUtils, Windows, Messages, Classes, Forms, Graphics, Controls, Menus, StdCtrls, Buttons, ComCtrls, ExtCtrls, ToolWin, Commun,
  CommonList, VirtualTrees, VirtualTree, ActnList, VDTButton, JvUIB, ComboCheck, ProceduresBDtk,
  Frame_RechercheRapide;

type
  TCritere = class
    // affichage
    Champ, Test: string;
    // sql
    NomTable: string;
    TestSQL: string;
    // fenêtre
    iChamp: Integer;
    iSignes, iCritere2: Integer;
    valeurText: string;

    procedure Assign(S: TCritere);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
  end;

  TTypeRecherche = (trAucune, trSimple, trComplexe);

  TFrmRecherche = class(TForm, IImpressionApercu)
    PopupMenu1: TPopupMenu;
    Critre1: TMenuItem;
    Groupedecritre1: TMenuItem;
    ActionList1: TActionList;
    RechercheApercu: TAction;
    RechercheImprime: TAction;
    PageControl2: TPageControl;
    TabSheet4: TTabSheet;
    plus: TButton;
    Modif: TButton;
    moins: TButton;
    methode: TComboBox;
    btnRecherche: TButton;
    TabSheet3: TTabSheet;
    Splitter1: TSplitter;
    TreeView1: TTreeView;
    vtPersonnes: TVirtualStringTree;
    VTResult: TVirtualStringTree;
    LightComboCheck1: TLightComboCheck;
    MainMenu1: TMainMenu;
    Recherche1: TMenuItem;
    Exporter1: TMenuItem;
    Imprimer1: TMenuItem;
    lbResult: TLabel;
    FrameRechercheRapide1: TFrameRechercheRapide;
    procedure plusClick(Sender: TObject);
    procedure moinsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RechPrint(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure VTResultDblClick(Sender: TObject);
    procedure ModifClick(Sender: TObject);
    procedure methodeChange(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure TreeView1Collapsing(Sender: TObject; Node: TTreeNode; var AllowCollapse: Boolean);
    procedure Critre1Click(Sender: TObject);
    procedure Groupedecritre1Click(Sender: TObject);
    procedure TreeView1Deletion(Sender: TObject; Node: TTreeNode);
    procedure btnRechercheClick(Sender: TObject);
    procedure VTResultGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure VTResultPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure VTResultHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure LightComboCheck1Change(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
    FTypeRecherche: TTypeRecherche;
    procedure SetTypeRecherche(Value: TTypeRecherche);
    procedure ImpressionExecute(Sender: TObject);
    procedure ApercuExecute(Sender: TObject);
    function ImpressionUpdate: Boolean;
    function ApercuUpdate: Boolean;
  public
    { Déclarations publiques }
    CurrentSQL: string;
    CritereSimple: TGUID;
    ResultList: TListAlbumAdd;
    ResultInfos: TStringList;
    property TypeRecherche: TTypeRecherche read FTypeRecherche write SetTypeRecherche;
    function ImpressionEnabled: Boolean;
    function TransChamps(const Champ: string): string;
    function ValChamps(const Champ: string): Integer;
    function IsValChampBoolean(ValChamp: Integer): Boolean;
    procedure LoadRechFromStream(Stream: TStream);
  end;

implementation

uses
  Textes, DM_Princ, TypeRec, Impression, Math, Form_EditCritere, UHistorique, Procedures, 
  Main;

{$R *.DFM}

{ TCritere }

procedure TCritere.Assign(S: TCritere);
begin
  Champ := S.Champ;
  Test := S.Test;
  NomTable := S.NomTable;
  TestSQL := S.TestSQL;
  iChamp := S.iChamp;
  iSignes := S.iSignes;
  iCritere2 := S.iCritere2;
  valeurText := S.valeurText;
end;

procedure TCritere.LoadFromStream(Stream: TStream);

  function ReadInteger: Integer;
  begin
    Stream.Read(Result, SizeOf(Integer));
  end;

  function ReadString: string;
  var
    l: Integer;
  begin
    l := ReadInteger;
    SetLength(Result, l);
    Stream.Read(Result[1], l);
  end;

begin
  Champ := ReadString;
  Test := ReadString;
  NomTable := ReadString;
  TestSQL := ReadString;
  iChamp := ReadInteger;
  iSignes := ReadInteger;
  iCritere2 := ReadInteger;
  valeurText := ReadString;
end;

procedure TCritere.SaveToStream(Stream: TStream);

  procedure WriteInteger(Value: Integer);
  begin
    Stream.Write(Value, SizeOf(Integer));
  end;

  procedure WriteString(const Value: string);
  var
    l: Integer;
  begin
    l := Length(Value);
    WriteInteger(l);
    Stream.WriteBuffer(Value[1], l);
  end;

begin
  WriteString(Champ);
  WriteString(Test);
  WriteString(NomTable);
  WriteString(TestSQL);
  WriteInteger(iChamp);
  WriteInteger(iSignes);
  WriteInteger(iCritere2);
  WriteString(valeurText);
end;

var
  FSortColumn: Integer;
  FSortDirection: TSortDirection;

function TFrmRecherche.TransChamps(const Champ: string): string;
begin
  Result := '';
  if SameText(Champ, 'titrealbum') then Result := rsTransAlbum;
  if SameText(Champ, 'anneeparution') then Result := rsTransAnneeParution;
  if SameText(Champ, 'tome') then Result := rsTransTome;
  if SameText(Champ, 'horsserie') then Result := rsTransHorsSerie;
  if SameText(Champ, 'integrale') then Result := rsTransIntegrale;
  if SameText(Champ, 'uppersujetalbum') then Result := rsTransHistoire + ' ' + rsTransAlbum;
  if SameText(Champ, 'upperremarquesalbum') then Result := rsTransNotes + ' ' + rsTransAlbum;

  if SameText(Champ, 'titreserie') then Result := rsTransSerie;
  if SameText(Champ, 'uppersujetserie') then Result := rsTransHistoire + ' ' + rsTransSerie;
  if SameText(Champ, 'upperremarquesserie') then Result := rsTransNotes + ' ' + rsTransSerie;
  if SameText(Champ, 'terminee') then Result := rsTransSerieTerminee;
  if SameText(Champ, 'complete') then Result := rsTransSerieComplete;
  if SameText(Champ, 'suivremanquants') then Result := rsTransSerieChercherManquants;
  if SameText(Champ, 'suivresorties') then Result := rsTransSerieSuivreSorties;

  if SameText(Champ, 'anneeedition') then Result := rsTransAnneeEdition;
  if SameText(Champ, 'prix') then Result := rsTransPrix;
  if SameText(Champ, 'vo') then Result := rsTransVO;
  if SameText(Champ, 'couleur') then Result := rsTransCouleur;
  if SameText(Champ, 'isbn') then Result := rsTransISBN;
  if SameText(Champ, 'prete') then Result := rsTransPrete;
  if SameText(Champ, 'stock') then Result := rsTransStock;
  if SameText(Champ, 'typeedition') then Result := rsTransEdition;
  if SameText(Champ, 'dedicace') then Result := rsTransDedicace;
  if SameText(Champ, 'etat') then Result := rsTransEtat;
  if SameText(Champ, 'reliure') then Result := rsTransReliure;
  if SameText(Champ, 'orientation') then Result := rsTransOrientation;
  if SameText(Champ, 'formatedition') then Result := rsTransFormatEdition;
  if SameText(Champ, 'typeedition') then Result := rsTransTypeEdition;
  if SameText(Champ, 'dateachat') then Result := rsTransDateAchat;
  if SameText(Champ, 'gratuit') then Result := rsTransGratuit;
  if SameText(Champ, 'offert') then Result := rsTransOffert;
  if SameText(Champ, 'nombredepages') then Result := rsTransNombreDePages;
  if SameText(Champ, 'anneecote') then Result := rsTransCote + ' (' + rsTransAnnee + ')';
  if SameText(Champ, 'prixcote') then Result := rsTransCote + ' (' + rsTransPrix + ')';

  if SameText(Champ, 'genreserie') then Result := rsTransGenre + ' *';
end;

function TFrmRecherche.ValChamps(const Champ: string): Integer;
begin
  Result := 0;
  if (Champ = rsTransAlbum) or (SameText(Champ, 'titrealbum')) then Result := 1;
  if (Champ = rsTransAnneeParution) or (SameText(Champ, 'anneeparution')) then Result := 2;
  if (Champ = rsTransTome) or (SameText(Champ, 'tome')) then Result := 3;
  if (Champ = rsTransHorsSerie) or (SameText(Champ, 'horsserie')) then Result := 4;
  if (Champ = rsTransIntegrale) or (SameText(Champ, 'integrale')) then Result := 5;
  if (Champ = rsTransHistoire + ' ' + rsTransAlbum) or (SameText(Champ, 'sujetalbum')) then Result := 6;
  if (Champ = rsTransNotes + ' ' + rsTransAlbum) or (SameText(Champ, 'remarquesalbum')) then Result := 7;

  if (Champ = rsTransSerie) or (SameText(Champ, 'titreserie')) then Result := 8;
  if (Champ = rsTransHistoire + ' ' + rsTransSerie) or (SameText(Champ, 'sujetserie')) then Result := 9;
  if (Champ = rsTransNotes + ' ' + rsTransSerie) or (SameText(Champ, 'remarquesserie')) then Result := 10;
  if (Champ = rsTransSerieTerminee) or (SameText(Champ, 'terminee')) then Result := 11;
  if (Champ = rsTransSerieComplete) or (SameText(Champ, 'complete')) then Result := 33;
  if (Champ = rsTransSerieChercherManquants) or (SameText(Champ, 'suivremanquants')) then Result := 34;
  if (Champ = rsTransSerieSuivreSorties) or (SameText(Champ, 'suivresorties')) then Result := 35;

  if (Champ = rsTransAnneeEdition) or (SameText(Champ, 'anneeedition')) then Result := 12;
  if (Champ = rsTransPrix) or (SameText(Champ, 'prix')) then Result := 13;
  if (Champ = rsTransVO) or (SameText(Champ, 'vo')) then Result := 14;
  if (Champ = rsTransCouleur) or (SameText(Champ, 'couleur')) then Result := 15;
  if (Champ = rsTransISBN) or (SameText(Champ, 'isbn')) then Result := 16;
  if (Champ = rsTransPrete) or (SameText(Champ, 'prete')) then Result := 17;
  if (Champ = rsTransStock) or (SameText(Champ, 'stock')) then Result := 18;
  if (Champ = rsTransEdition) or (SameText(Champ, 'typeedition')) then Result := 19;
  if (Champ = rsTransDedicace) or (SameText(Champ, 'dedicace')) then Result := 20;
  if (Champ = rsTransEtat) or (SameText(Champ, 'etat')) then Result := 21;
  if (Champ = rsTransReliure) or (SameText(Champ, 'reliure')) then Result := 22;
  if (Champ = rsTransOrientation) or (SameText(Champ, 'orientation')) then Result := 24;
  if (Champ = rsTransFormatEdition) or (SameText(Champ, 'formatedition')) then Result := 25;
  if (Champ = rsTransTypeEdition) or (SameText(Champ, 'typeedition')) then Result := 26;
  if (Champ = rsTransDateAchat) or (SameText(Champ, 'dateachat')) then Result := 27;
  if (Champ = rsTransGratuit) or (SameText(Champ, 'gratuit')) then Result := 28;
  if (Champ = rsTransOffert) or (SameText(Champ, 'offert')) then Result := 29;
  if (Champ = rsTransNombreDePages) or (SameText(Champ, 'nombredepages')) then Result := 30;
  if (Champ = rsTransCote + ' (' + rsTransAnnee + ')') or (SameText(Champ, 'anneecote')) then Result := 31;
  if (Champ = rsTransCote + ' (' + rsTransPrix + ')') or (SameText(Champ, 'prixcote')) then Result := 32;

  if (Champ = rsTransGenre + ' *') or (SameText(Champ, 'ID_Genre')) then Result := 23;
end;

function TFrmRecherche.IsValChampBoolean(ValChamp: Integer): Boolean;
begin
  Result := ValChamp in [4, 5, 11, 14, 15, 17, 18, 19, 20, 28, 29, 33, 34, 35];
end;

procedure TFrmRecherche.SetTypeRecherche(Value: TTypeRecherche);
begin
  FSortColumn := 2;
  FSortDirection := sdDescending;
  VTResult.Header.Columns[0].ImageIndex := -1;
  VTResult.Header.Columns[1].ImageIndex := -1;
  VTResult.Header.Columns[2].ImageIndex := -1;
  if FSortDirection = sdAscending then
    VTResult.Header.Columns[FSortColumn].ImageIndex := 0
  else
    VTResult.Header.Columns[FSortColumn].ImageIndex := 1;
  if Value = trSimple then
    VTResult.TreeOptions.StringOptions := VTResult.TreeOptions.StringOptions + [toShowStaticText]
  else
    VTResult.TreeOptions.StringOptions := VTResult.TreeOptions.StringOptions - [toShowStaticText];
  RechercheApercu.Enabled := Value <> trAucune;
  RechercheImprime.Enabled := RechercheApercu.Enabled;
  case Value of
    trComplexe: PageControl2.ActivePageIndex := 1;
    trSimple: PageControl2.ActivePageIndex := 0;
  end;
  FTypeRecherche := Value;
  Fond.Impression.Update;
  Fond.ApercuImpression.Update;
end;

procedure TFrmRecherche.FormCreate(Sender: TObject);
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  PrepareLV(Self);
  LightComboCheck1.Value := 0;
  ChargeImage(VTPersonnes.Background, 'FONDVT');
  ChargeImage(VTResult.Background, 'FONDVT');
  FrameRechercheRapide1.VirtualTreeView := vtPersonnes;
  FrameRechercheRapide1.ShowNewButton := False;

  ResultList := TListAlbumAdd.Create;
  ResultInfos := TStringList.Create;
  PageControl2.ActivePageIndex := 0;

  VTResult.TreeOptions.PaintOptions := VTResult.TreeOptions.PaintOptions - [toShowButtons, toShowDropmark, toShowRoot];

  btnRecherche.Font.Style := btnRecherche.Font.Style + [fsBold];
  VTPersonnes.Mode := vmPersonnes;
  methode.ItemIndex := 0;
  TypeRecherche := trAucune;
  Groupedecritre1.Click;
end;

procedure TFrmRecherche.ModifClick(Sender: TObject);
var
  ToModif: TTreeNode;
  p: TCritere;
begin
  ToModif := TreeView1.Selected;
  if not (Assigned(ToModif) and (Integer(ToModif.Data) > 0)) then Exit;
  p := ToModif.Data;
  with TFrmEditCritere.Create(Self) do begin
    try
      Critere := p;
      if ShowModal <> mrOk then Exit;
      p.Assign(Critere);
      ToModif.Text := p.Champ + ' ' + p.Test;
      if TypeRecherche = trComplexe then TypeRecherche := trAucune;
    finally
      Free;
    end;
  end;
end;

procedure TFrmRecherche.plusClick(Sender: TObject);
var
  p: TPoint;
begin
  if Assigned(TreeView1.Selected) then begin
    p := plus.ClientToScreen(Point(0, plus.Height));
    PopupMenu1.Popup(p.x, p.y);
  end
  else
    Groupedecritre1.Click;
end;

procedure TFrmRecherche.moinsClick(Sender: TObject);
begin
  if TypeRecherche = trComplexe then TypeRecherche := trAucune;
  if Assigned(TreeView1.Selected) and (TreeView1.Selected <> TreeView1.Items.GetFirstNode) then
    TreeView1.Selected.Delete;
end;

procedure TFrmRecherche.FormDestroy(Sender: TObject);
begin
  VTResult.RootNodeCount := 0;
  lbResult.Caption := '';
  ResultList.Free;
  ResultInfos.Free;

  if Bool(TreeView1.Items.Count) then
    TreeView1.Items[0].Delete;
end;

procedure TFrmRecherche.RechPrint(Sender: TObject);
var
  Criteres: TStringList;

  procedure ProcessTreeNode(Node: TTreeNode; prefix: string = '');
  var
    i: Integer;
    p: TCritere;
    s: string;
  begin
    if Integer(Node.Data) > 0 then begin
      s := IntToStr(Node.Level - 1) + '|';
      p := Node.Data;
      Criteres.Add(s + prefix + p.Champ + '|' + p.Test);
    end
    else begin
      if prefix <> '' then Criteres.Add(IntToStr(Node.Level - 1) + '|' + prefix + '| ');
      for i := 0 to Node.Count - 1 do begin
        if i > 0 then
          ProcessTreeNode(Node[i], Node.Text + ' ')
        else
          ProcessTreeNode(Node[i]);
      end;
    end;
  end;

begin
  Criteres := TStringList.Create;
  try
    case TypeRecherche of
      trSimple: begin
          vtPersonnes.CurrentValue := CritereSimple;
          Criteres.Add(LightComboCheck1.Caption);
          Criteres.Add(vtPersonnes.Caption);
        end;
      trComplexe:
        ProcessTreeNode(TreeView1.Items[0]);
    end;
    ImpressionRecherche(ResultList, ResultInfos, Criteres, TypeRecherche, TComponent(Sender).Tag = 1);
  finally
    Criteres.Free;
  end;
end;

procedure TFrmRecherche.SpeedButton1Click(Sender: TObject);
const
  Proc: array[0..4] of string = ('ALBUMS_BY_AUTEUR(?, NULL)',
    'ALBUMS_BY_SERIE(?, NULL)',
    'ALBUMS_BY_EDITEUR(?, NULL)',
    'ALBUMS_BY_GENRE(?, NULL)',
    'ALBUMS_BY_COLLECTION(?, NULL)');
var
  q: TJvUIBQuery;
  s: string;
  oldID_Album: TGUID;
  oldIndex: Integer;
begin
  if not IsEqualGUID(VTPersonnes.CurrentValue, GUID_NULL) then begin
    CritereSimple := VTPersonnes.CurrentValue;
    PageControl2.ActivePageIndex := 0;
    VTResult.RootNodeCount := 0;
    lbResult.Caption := '';
    ResultList.Clear;
    ResultInfos.Clear;
    q := TJvUIBQuery.Create(nil);
    with q do try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'SELECT * FROM ' + Proc[LightComboCheck1.Value];
      Params.AsString[0] := GUIDToString(CritereSimple);
      Open;
      oldID_Album := GUID_NULL;
      oldIndex := -1;
      s := '';
      while not EOF do begin
        if isEqualGUID(oldID_Album, StringToGUID(Fields.ByNameAsString['ID_Album'])) and (oldIndex <> -1) then begin
          if LightComboCheck1.Value = 0 then begin
            s := ResultInfos[oldIndex];
            case Fields.ByNameAsInteger['Metier'] of
              0: AjoutString(s, 'Scenariste', ', ');
              1: AjoutString(s, 'Dessinateur', ', ');
              2: AjoutString(s, 'Coloriste', ', ');
            end;
            ResultInfos[oldIndex] := s;
          end;
        end
        else begin
          ResultList.AddQ(q);
          if LightComboCheck1.Value = 0 then
            case Fields.ByNameAsInteger['Metier'] of
              0: oldIndex := ResultInfos.Add('Scenariste');
              1: oldIndex := ResultInfos.Add('Dessinateur');
              2: oldIndex := ResultInfos.Add('Coloriste');
            end
          else
            ResultInfos.Add('');
        end;
        oldID_Album := StringToGUID(Fields.ByNameAsString['ID_Album']);
        Next;
      end;
      if Bool(ResultList.Count) then
        TypeRecherche := trSimple
      else
        TypeRecherche := trAucune;
      CurrentSQL := SQL.Text;
      Historique.EditConsultation(CritereSimple, LightComboCheck1.Value);
      VTResult.RootNodeCount := ResultList.Count;
      lbResult.Caption := IntToStr(VTResult.RootNodeCount) + ' résultat(s) trouvé(s)';
    finally
      Transaction.Free;
      Free;
    end;
  end;
end;

procedure TFrmRecherche.VTResultDblClick(Sender: TObject);
begin
  if Assigned(VTResult.FocusedNode) then Historique.AddWaiting(fcAlbum, ResultList[VTResult.FocusedNode.Index].ID);
end;

procedure TFrmRecherche.methodeChange(Sender: TObject);
begin
  if (TypeRecherche = trComplexe) then TypeRecherche := trAucune;
  TreeView1.Selected.Data := pointer(-methode.ItemIndex);
  TreeView1.Selected.Text := methode.Text;
end;

function TFrmRecherche.ImpressionEnabled: Boolean;
begin
  Result := RechercheImprime.Enabled;
end;

procedure TFrmRecherche.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
  Modif.Enabled := Assigned(Node) and (Integer(Node.Data) > 0);
  moins.Enabled := Assigned(Node);
  methode.Visible := Assigned(Node) and (Integer(Node.Data) < 1);
  if methode.Visible then methode.ItemIndex := -Integer(Node.Data);
end;

procedure TFrmRecherche.TreeView1Collapsing(Sender: TObject; Node: TTreeNode; var AllowCollapse: Boolean);
begin
  AllowCollapse := False;
end;

procedure TFrmRecherche.Critre1Click(Sender: TObject);
var
  p: TCritere;
  ParentNode: TTreeNode;
begin
  if not Assigned(TreeView1.Selected) then Exit;
  with TFrmEditCritere.Create(Self) do begin
    try
      if ShowModal <> mrOk then Exit;
      p := TCritere.Create;
      p.Assign(Critere);
      if Integer(TreeView1.Selected.Data) < 1 then
        ParentNode := TreeView1.Selected
      else
        ParentNode := TreeView1.Selected.Parent;
      with TreeView1.Items.AddChild(ParentNode, '') do begin
        Data := p;
        Text := p.Champ + ' ' + p.Test;
        Selected := True;
      end;
      if TypeRecherche = trComplexe then TypeRecherche := trAucune;
    finally
      Free;
    end;
  end;
end;

procedure TFrmRecherche.Groupedecritre1Click(Sender: TObject);
var
  ParentNode: TTreeNode;
begin
  if not Assigned(TreeView1.Selected) then
    ParentNode := nil
  else if Integer(TreeView1.Selected.Data) < 1 then
    ParentNode := TreeView1.Selected
  else
    ParentNode := TreeView1.Selected.Parent;
  with TreeView1.Items.AddChild(ParentNode, methode.Items[0]) do begin
    Data := pointer(0);
    Selected := True;
  end;
end;

procedure TFrmRecherche.TreeView1Deletion(Sender: TObject; Node: TTreeNode);
begin
  // Node.Data = -1 est possible mais donc à libérer
  if Integer(Node.Data) > 0 then begin
    TCritere(Node.Data).Free;
    Node.Data := nil;
  end;
end;

procedure TFrmRecherche.btnRechercheClick(Sender: TObject);
var
  slFrom, slWhere: TStringList;
  RechStream: TMemoryStream;

  function ProcessTables: string;
  var
    i: Integer;
  begin
    // Tables possibles:
    // ALBUMS
    // SERIES
    // EDITIONS
    // GENRESERIES

    Result := 'ALBUMS INNER JOIN EDITIONS ON ALBUMS.ID_Album = EDITIONS.ID_Album LEFT JOIN SERIES ON ALBUMS.ID_Serie = SERIES.ID_Serie';
    slFrom.Delete(slFrom.IndexOf('ALBUMS'));
    slFrom.Delete(slFrom.IndexOf('SERIES'));
    slFrom.Delete(slFrom.IndexOf('EDITIONS'));
    i := slFrom.IndexOf('GENRESERIES');
    if i <> -1 then begin
      Result := Result + ' LEFT OUTER JOIN GENRESERIES ON GENRESERIES.ID_Serie = ALBUMS.ID_Serie';
      slFrom.Delete(i);
    end;
  end;

  function ProcessCritere(ItemCritere: TTreeNode): string;

    procedure WriteInteger(Value: Integer);
    begin
      RechStream.Write(Value, SizeOf(Integer));
    end;

    procedure WriteString(const Value: string);
    var
      l: Integer;
    begin
      l := Length(Value);
      WriteInteger(l);
      RechStream.WriteBuffer(Value[1], l);
    end;

    procedure WriteNode(Node: TTreeNode);
    begin
      WriteInteger(Node.Level);
      WriteInteger(Integer(Node.Data));
      WriteString(Node.Text);
      if Integer(Node.Data) > 0 then
        TCritere(Node.Data).SaveToStream(RechStream);
    end;

  var
    p: TCritere;
    i: Integer;
    sBool: string;
  begin
    Result := '';
    WriteNode(ItemCritere);
    if Integer(ItemCritere.Data) = -1 then
      sBool := ' OR '
    else
      sBool := ' AND ';
    for i := 0 to ItemCritere.Count - 1 do begin
      if Integer(ItemCritere.Item[i].Data) > 0 then begin
        WriteNode(ItemCritere.Item[i]);
        p := ItemCritere.Item[i].Data;
        if Result = '' then
          Result := '(' + p.TestSQL + ')'
        else
          Result := Result + sBool + '(' + p.TestSQL + ')';
        slFrom.Add(p.NomTable);
      end
      else begin
        if Result = '' then
          Result := '(' + ProcessCritere(ItemCritere.Item[i]) + ')'
        else
          Result := Result + sBool + '(' + ProcessCritere(ItemCritere.Item[i]) + ')';
      end;
    end;
  end;

var
  q: TJvUIBQuery;
  sWhere: string;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  VTResult.RootNodeCount := 0;
  lbResult.Caption := '';
  ResultList.Clear;
  ResultInfos.Clear;
  q := TJvUIBQuery.Create(Self);
  slFrom := TStringList.Create;
  slFrom.Sorted := True;
  slFrom.Duplicates := dupIgnore;
  slFrom.Delimiter := ',';
  slWhere := TStringList.Create;
  RechStream := TMemoryStream.Create;
  with q do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT DISTINCT ALBUMS.ID_Album, ALBUMS.TITREALBUM, ALBUMS.TOME, ALBUMS.TOMEDEBUT, ALBUMS.TOMEFIN, ALBUMS.HORSSERIE, ALBUMS.INTEGRALE, ALBUMS.MOISPARUTION, ALBUMS.ANNEEPARUTION, ALBUMS.ID_Serie, SERIES.TITRESERIE';

    slFrom.Add('ALBUMS');
    slFrom.Add('SERIES');
    slFrom.Add('EDITIONS');
    RechStream.Size := 0;
    sWhere := ProcessCritere(TreeView1.Items[0]);
    SQL.Add('FROM ' + ProcessTables);

    if sWhere <> '' then SQL.Add('WHERE ' + sWhere);

    SQL.Add('ORDER BY ALBUMS.UPPERTITREALBUM, SERIES.UPPERTITRESERIE, ALBUMS.HORSSERIE NULLS FIRST, ALBUMS.INTEGRALE NULLS FIRST,');
    SQL.Add('ALBUMS.TOME NULLS FIRST, ALBUMS.TOMEDEBUT NULLS FIRST, ALBUMS.TOMEFIN NULLS FIRST, ALBUMS.ANNEEPARUTION NULLS FIRST, ALBUMS.MOISPARUTION NULLS FIRST');

    Open;
    while not EOF do begin
      ResultList.AddQ(q);
      Next;
    end;
    if Bool(ResultList) then
      TypeRecherche := trComplexe
    else
      TypeRecherche := trAucune;
    CurrentSQL := SQL.Text;
    Historique.EditConsultation(RechStream);
  finally
    Transaction.Free;
    Free;
    slFrom.Free;
    slWhere.Free;
    RechStream.Free;
  end;
  VTResult.RootNodeCount := ResultList.Count;
  lbResult.Caption := IntToStr(VTResult.RootNodeCount) + ' résultat(s) trouvé(s)';
end;

procedure TFrmRecherche.VTResultGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
begin
  CellText := '';
  if TextType = ttNormal then
    case Column of
      0: CellText := FormatTitre(ResultList[Node.Index].Titre);
      1: CellText := NonZero(IntToStr(ResultList[Node.Index].Tome));
      2: CellText := FormatTitre(ResultList[Node.Index].Serie);
    end
  else if (TypeRecherche = trSimple) and Bool(ResultInfos.Count) then
    case Column of
      0: AjoutString(CellText, ResultInfos[Node.Index], '', '(', ')');
    end;
end;

procedure TFrmRecherche.VTResultPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
begin
  if TextType = ttStatic then TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsItalic];
end;

function ResultListCompare(Item1, Item2: Pointer): Integer;
begin
  case FSortColumn of
    0: Result := CompareText(TAlbum(Item1).Titre, TAlbum(Item2).Titre);
    1: Result := CompareValue(TAlbum(Item1).Tome, TAlbum(Item2).Tome);
    2: begin
        Result := CompareText(TAlbum(Item1).Serie, TAlbum(Item2).Serie);
        if Result = 0 then
          Result := CompareValue(TAlbum(Item1).Tome, TAlbum(Item2).Tome);
      end;
    else
      Result := 0;
  end;
  if FSortDirection = sdDescending then Result := -Result;
end;

procedure TFrmRecherche.VTResultHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Column <> FSortColumn then
    FSortDirection := sdAscending
  else if FSortDirection = sdAscending then
    FSortDirection := sdDescending
  else
    FSortDirection := sdAscending;
  if FSortColumn <> -1 then VTResult.Header.Columns[FSortColumn].ImageIndex := -1;
  FSortColumn := Column;
  if FSortDirection = sdAscending then
    VTResult.Header.Columns[FSortColumn].ImageIndex := 0
  else
    VTResult.Header.Columns[FSortColumn].ImageIndex := 1;
  VTResult.Header.SortColumn := FSortColumn;
  ResultList.Sort(@ResultListCompare);
  VTResult.ReinitNode(VTResult.RootNode, True);
  VTResult.Invalidate;
  VTResult.Refresh;
end;

procedure TFrmRecherche.LightComboCheck1Change(Sender: TObject);
const
  NewMode: array[0..4] of TVirtualMode = (vmPersonnes,
    vmSeries,
    vmEditeurs,
    vmGenres,
    vmCollections);
var
  Mode: TVirtualMode;
begin
  Mode := NewMode[LightComboCheck1.Value];
  if (VTPersonnes.Mode <> Mode) then
    VTPersonnes.Mode := Mode;
end;

procedure TFrmRecherche.ApercuExecute(Sender: TObject);
begin
  RechPrint(Sender);
end;

function TFrmRecherche.ApercuUpdate: Boolean;
begin
  Result := ImpressionEnabled;
end;

procedure TFrmRecherche.ImpressionExecute(Sender: TObject);
begin
  RechPrint(Sender);
end;

function TFrmRecherche.ImpressionUpdate: Boolean;
begin
  Result := ImpressionEnabled;
end;

procedure TFrmRecherche.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    Key := #0;
    vtPersonnes.OnDblClick(nil);
  end;
end;

procedure TFrmRecherche.LoadRechFromStream(Stream: TStream);

  function ReadInteger: Integer;
  begin
    Stream.Read(Result, SizeOf(Integer));
  end;

  function ReadString: string;
  var
    l: Integer;
  begin
    l := ReadInteger;
    SetLength(Result, l);
    Stream.Read(Result[1], l);
  end;

  function CreateNode(nodeType: Integer; ParentNode: TTreeNode; const Text: string): TTreeNode;
  begin
    Result := TreeView1.Items.AddChild(ParentNode, Text);
    Result.Data := Pointer(nodeType);
    if nodeType > 0 then begin
      Result.Data := TCritere.Create;
      TCritere(Result.Data).LoadFromStream(Stream);
    end;
  end;

var
  lvl, nodeType: Integer;
  str: string;
  ANode, NextNode: TTreeNode;
begin
  Stream.Position := 0;
  TreeView1.Items.BeginUpdate;
  try
    TreeView1.Items.Clear;

    ANode := nil;
    while Stream.Position < Stream.Size do begin
      lvl := ReadInteger;
      nodeType := ReadInteger;
      str := ReadString;
      if ANode = nil then
        ANode := CreateNode(nodeType, nil, str)
      else if ANode.Level = lvl then
        ANode := CreateNode(nodeType, ANode.Parent, str)
      else if ANode.Level = (lvl - 1) then
        ANode := CreateNode(nodeType, ANode, str)
      else if ANode.Level > lvl then
      begin
        NextNode := ANode.Parent;
        while NextNode.Level > lvl do
          NextNode := NextNode.Parent;
        ANode := CreateNode(nodeType, NextNode.Parent, str);
      end;
    end;
    TreeView1.Items[0].Expand(True);
  finally
    TreeView1.Items.EndUpdate;
  end;
end;

end.

