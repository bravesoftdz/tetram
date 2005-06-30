unit Procedures;

interface

uses
  SysUtils, Windows, Classes, Dialogs, ComCtrls, ExtCtrls, Controls, Forms, TypeRec, Graphics, CommonConst, JvUIB, jpeg, GraphicEx,
  StdCtrls, Form_Progression, JvUIBLib;

function AffMessage(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; Son: Boolean = False): Word;

type
  IImpressionApercu = interface
    ['{10227EB6-D5D0-4541-AAD6-D1A62E9308C9}']
    procedure ImpressionExecute(Sender: TObject);
    procedure ApercuExecute(Sender: TObject);
    function ImpressionUpdate: Boolean;
    function ApercuUpdate: Boolean;
  end;

  TEtapeProgression = (epNext, epFin);

  IWaiting = interface
    ['{82C50525-A282-4982-92DB-ED5FEC2E5C96}']
    procedure ShowProgression(const Texte: string; Etape: TEtapeProgression); overload; stdcall;
    procedure ShowProgression(Texte: PChar; Valeur, Maxi: Integer); overload; stdcall;
    procedure ShowProgression(const Texte: string; Valeur, Maxi: Integer); overload; stdcall;
  end;

  TWaiting = class(TInterfacedObject, IWaiting)
  private
    FTimer: TTimer;

    FMessage: string;
    FValeur, FMaxi: Integer;
    FTimeToWait: Cardinal;
    FForm: TFrmProgression;
    PResult: PInteger;
    procedure InitForm;
    procedure ClearForm;
    procedure RefreshForm;
    procedure Execute(Sender: TObject);
    procedure Cancel(Sender: TObject);
  public
    constructor Create(const Msg: string = ''; WaitFor: Cardinal = 2000; Retour: PInteger = nil); reintroduce;
    destructor Destroy; override;
    procedure ShowProgression(const Texte: string; Etape: TEtapeProgression); overload; stdcall;
    procedure ShowProgression(const Texte: string; Valeur, Maxi: Integer); overload; stdcall;
    procedure ShowProgression(Texte: PChar; Valeur, Maxi: Integer); overload; stdcall;
  end;

  //procedure ShowProgression(Texte: String; Etape: TEtapeProgression); overload;
  //procedure ShowProgression(Texte: String; Valeur, Maxi: Integer); overload;
  //procedure ShowProgression(Texte: PChar; Valeur, Maxi: Integer); overload;
function FormExistB(ClassType: TClass): Boolean;
function FormExistI(ClassType: TClass): Integer;

procedure MoveListItem(LV: TListView; Sens: Integer);

function DessineImage(Image: TImage; Fichier: string): Boolean;

procedure LitOptions;
procedure EcritOptions;

function Convertisseur(Caller: TControl; var Value: Currency): Boolean;

function Choisir(const Texte1, Texte2: string; Bouton: Integer): TModalResult;
type
  TDetailOption = (doScenario, doDessins, doCouleurs, doHistoire, doNotes);
  TDetailOptions = set of TDetailOption;
function ChoisirDetail(Bouton: Integer; out DetailsOptions: TDetailOptions): TModalResult;
procedure PrepareLV(Form: TForm);

function SupprimerTable(Table: string): Boolean;
function SupprimerToutDans(const ChampSupp, Table: string; const Reference: string = ''; Valeur: Integer = -1; UseTransaction: TJvUIBTransaction = nil): Boolean;

type
  PRecRef = ^TRecRef;
  TRecRef = record
    ref: Integer;
  end;

function AjoutMvt(RefEmprunteur, RefObjet: Integer; DateE: TDateTime; Pret: Boolean): Boolean;
function ChargeImage(ImgBmp: TImage; const ResName: string; ForceVisible: Boolean = True): Boolean; overload;
function ChargeImage(Picture: TPicture; const ResName: string): Boolean; overload;
procedure InitScrollBoxTableChamps(ScrollBox: TScrollBox; const Table: string; Ref: Integer; Editable: Boolean = False);
procedure VideListePointer(ListView: TListView);

function GetShellImage(const Path: string; Large, Open: Boolean): Integer;

type
  ILockWindow = interface
  end;
  TLockWindow = class(TInterfacedObject, ILockWindow)
  private
    FLocked: Boolean;
  published
    constructor Create(Form: TWinControl);
    destructor Destroy; override;
  end;

  IModeEditing = interface
  end;
  TModeEditing = class(TInterfacedObject, IModeEditing)
  private
    FOldMode: TModeConsult;
  published
    constructor Create;
    destructor Destroy; override;
  end;

  IInformation = interface
    procedure ShowInfo(Msg: string);
  end;
  TInformation = class(TInterfacedObject, IInformation)
  private
    FInfo: TForm;
    FLabel: TLabel;
    procedure SetupDialog;
  published
    procedure ShowInfo(Msg: string);
    constructor Create;
    destructor Destroy; override;
  end;

function GetCouvertureStream(RefCouverture, Hauteur, Largeur: Integer; AntiAliasing: Boolean; Cadre: Boolean = False; Effet3D: Integer = 0): TStream; overload;
function GetCouvertureStream(const Fichier: string; Hauteur, Largeur: Integer; AntiAliasing: Boolean; Cadre: Boolean = False; Effet3D: Integer = 0): TStream; overload;
procedure LoadCouverture(RefCouverture: Integer; Picture: TPicture);
function GetJPEGStream(const Fichier: string): TStream;
function SearchNewFileName(const Chemin, Fichier: string; Reserve: Boolean = True): string;

function HTMLPrepare(const AStr: string): string;

implementation

uses
  CommonList, Divers, Textes, ShellAPI, ReadOnlyCheckBox, Form_ChoixDetail,
  JvUIBase, MaskUtils, Mask, Commun, DM_Princ, IniFiles, Form_Choix, Math, VirtualTrees, DbEditLabeled, ActnList,
  Form_Convertisseur, Main, HTTPApp, Types;

function AffMessage(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; Son: Boolean = False): Word;
begin
  if Son then MessageBeep(MB_ICONERROR);
  Result := MessageDlg(Msg, DlgType, Buttons, 0);
end;

function FormExistB(ClassType: TClass): Boolean;
begin
  Result := FormExistI(ClassType) > 0;
end;

function FormExistI(ClassType: TClass): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to Screen.FormCount - 1 do
    if Screen.Forms[i].ClassType = ClassType then Inc(Result);
end;

function DessineImage(Image: TImage; Fichier: string): Boolean;
var
  largeuraff, hauteuraff, largeurimg, hauteurimg: Integer;
  marge: Integer;
  hg: IHourGlass;
begin
  Result := False;
  Image.Picture := nil;
  if not FileExists(Fichier) then Exit;
  hg := THourGlass.Create;
  with TPicture.Create do try
    LoadFromFile(Fichier);
    hauteurimg := Height;
    largeurimg := Width;
    largeuraff := Image.Width;
    hauteuraff := Image.Height;
    if (hauteurimg >= hauteuraff) and (largeurimg >= largeuraff) then
      if (hauteurimg / largeurimg) > (hauteuraff / largeuraff) then begin
        largeuraff := Windows.MulDiv(hauteuraff, largeurimg, hauteurimg);
        marge := (Image.Width - largeuraff) div 2;
        Image.Canvas.StretchDraw(Rect(marge, 0, marge + largeuraff, hauteuraff), Graphic);
      end
      else begin
        hauteuraff := Windows.MulDiv(largeuraff, hauteurimg, largeurimg);
        marge := (Image.Height - hauteuraff) div 2;
        Image.Canvas.StretchDraw(Rect(0, marge, largeuraff, marge + hauteuraff), Graphic);
      end
    else
      Image.Canvas.Draw((largeuraff - largeurimg) div 2, (hauteuraff - hauteurimg) div 2, Graphic);
    Result := True;
  finally
    Free;
  end;
end;

procedure LitOptions;

  function LitStr(Table: TJvUIBQuery; Champ, Defaut: string): string;
  begin
    with Table do begin
      Params.AsString[0] := Champ;
      Open;
      if not Eof then
        Result := Fields.AsString[0]
      else
        Result := Defaut;
    end;
  end;

var
  op: TJvUIBQuery;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  op := TJvUIBQuery.Create(nil);
  with op do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT Valeur FROM OPTIONS WHERE NOM_OPTION = ?';
    Utilisateur.Options.SymboleMonnetaire := LitStr(op, 'SymboleM', CurrencyString);
    FormatMonnaie := IIf(CurrencyFormat in [0, 2], Utilisateur.Options.SymboleMonnetaire + IIf(CurrencyFormat = 2, ' ', ''), '') + FormatMonnaieCourt + IIf(CurrencyFormat in [1, 3], IIf(CurrencyFormat = 3, ' ', '') + Utilisateur.Options.SymboleMonnetaire, '');
    RepImages := LitStr(op, 'RepImages', RepImages);
  finally
    Transaction.Free;
    Free;
  end;
  with TIniFile.Create(FichierIni) do try
    Utilisateur.Options.ModeDemarrage := ReadBool('DIVERS', 'ModeDemarrage', True);
    Utilisateur.Options.FicheWithCouverture := ReadBool('DIVERS', 'FicheWithCouverture', True);
    Utilisateur.Options.Images := ReadBool('DIVERS', 'Images', True);
    Utilisateur.Options.AntiAliasing := ReadBool('DIVERS', 'AntiAliasing', True);
    Utilisateur.Options.ImagesStockees := ReadBool('ModeEdition', 'ImagesStockees', False);
    Utilisateur.Options.WebServerAutoStart := ReadBool('WebServer', 'AutoStart', False);
    Utilisateur.Options.WebServerPort := ReadInteger('WebServer', 'Port', 1024);
    Utilisateur.Options.WebServerAntiAliasing := ReadBool('WebServer', 'AntiAliasing', True);
    Utilisateur.Options.AvertirPret := ReadBool('DIVERS', 'AvertirPret', False);
    Utilisateur.Options.GrandesIconesMenus := ReadBool('DIVERS', 'GrandesIconesMenus', True);
    Utilisateur.Options.GrandesIconesBarre := ReadBool('DIVERS', 'GrandesIconesBarre', True);
  finally
    Free;
  end;
end;

procedure EcritOptions;

  procedure Sauve(Table: TJvUIBQuery; const Champ: string; Valeur: Currency); overload;
  begin
    with Table do try
      SQL.Text := 'INSERT INTO OPTIONS (Nom_Option, Valeur) VALUES (:Nom_Option, :Valeur)';
      Params.ByNameAsString['Nom_Option'] := Champ;
      Params.ByNameAsCurrency['Valeur'] := Valeur;
      ExecSQL;
    except
      SQL.Text := 'UPDATE OPTIONS SET Valeur = :Valeur WHERE Nom_Option = :Nom_Option';
      Params.ByNameAsString['Nom_Option'] := Champ;
      Params.ByNameAsCurrency['Valeur'] := Valeur;
      ExecSQL;
    end;
  end;

  procedure Sauve(Table: TJvUIBQuery; const Champ, Valeur: string); overload;
  begin
    with Table do try
      SQL.Text := 'INSERT INTO OPTIONS (Nom_Option, Valeur) VALUES (:Nom_Option, :Valeur)';
      Params.ByNameAsString['Nom_Option'] := Champ;
      Params.ByNameAsString['Valeur'] := Valeur;
      ExecSQL;
    except
      SQL.Text := 'UPDATE OPTIONS SET Valeur = :Valeur WHERE Nom_Option = :Nom_Option';
      Params.ByNameAsString['Nom_Option'] := Champ;
      Params.ByNameAsString['Valeur'] := Valeur;
      ExecSQL;
    end;
  end;

var
  op: TJvUIBQuery;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  op := TJvUIBQuery.Create(nil);
  with op do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    Sauve(op, 'SymboleM', Utilisateur.Options.SymboleMonnetaire);
    Sauve(op, 'RepImages', RepImages);
    Transaction.Commit;
  finally
    Transaction.Free;
    Free;
  end;
  with TIniFile.Create(FichierIni) do try
    WriteBool('DIVERS', 'ModeDemarrage', Utilisateur.Options.ModeDemarrage);
    WriteBool('DIVERS', 'Images', Utilisateur.Options.Images);
    WriteBool('DIVERS', 'FicheWithCouverture', Utilisateur.Options.FicheWithCouverture);
    WriteBool('DIVERS', 'AntiAliasing', Utilisateur.Options.AntiAliasing);
    WriteBool('DIVERS', 'AvertirPret', Utilisateur.Options.AvertirPret);
    WriteBool('DIVERS', 'GrandesIconesMenus', Utilisateur.Options.GrandesIconesMenus);
    WriteBool('DIVERS', 'GrandesIconesBarre', Utilisateur.Options.GrandesIconesBarre);
    WriteBool('ModeEdition', 'ImagesStockees', Utilisateur.Options.ImagesStockees);
    WriteBool('WebServer', 'AutoStart', Utilisateur.Options.WebServerAutoStart);
    WriteInteger('WebServer', 'Port', Utilisateur.Options.WebServerPort);
    WriteBool('WebServer', 'AntiAliasing', Utilisateur.Options.WebServerAntiAliasing);

    WriteString('DIVERS', 'RepImages', ''); // efface la ligne
  finally
    Free;
  end;
end;

procedure ShowProgression(const Texte: string; Etape: TEtapeProgression); overload;
begin
  if (not FormExistB(TFrmProgression)) then Exit;
  case Etape of
    epNext: FrmProgression.ProgressBar1.StepBy(1);
    epFin: FrmProgression.ProgressBar1.Position := FrmProgression.ProgressBar1.Max;
  end;
  FrmProgression.op.Caption := Texte;
  FrmProgression.Update;
  FrmProgression.Show;
  if (Etape = epFin) then FrmProgression.Release;
end;

procedure ShowProgression(const Texte: string; Valeur, Maxi: Integer); overload;
begin
  if (not FormExistB(TFrmProgression)) and (Valeur <> Maxi) then
    Application.CreateForm(TFrmProgression, FrmProgression);
  if FormExistB(TFrmProgression) then begin
    FrmProgression.ProgressBar1.Max := Maxi;
    FrmProgression.ProgressBar1.Position := Valeur;
    FrmProgression.op.Caption := Texte;
    FrmProgression.Update;
    FrmProgression.Show;
  end;
  if (Valeur = Maxi) then begin
    if FormExistB(TFrmProgression) then FrmProgression.Release;
    Exit;
  end;
end;

procedure ShowProgression(Texte: PChar; Valeur, Maxi: Integer); overload;
begin
  ShowProgression(StrPas(Texte), Valeur, Maxi);
end;

procedure MoveListItem(LV: TListView; Sens: Integer);
var
  AListItem: TListItem;
  TmpAListItem: TListItem;
  swLI: TListItem;
begin
  AListItem := LV.Selected;
  if not Assigned(AListItem) then Exit;
  if not (AListItem.Index + Sens in [0..LV.Items.Count - 1]) then Exit;
  TmpAListItem := LV.Items[AListItem.Index + Sens];
  if not Assigned(TmpAListItem) then Exit;
  LV.Items.BeginUpdate;
  swLI := LV.Items.Add;
  try
    swLI.Assign(TmpAListItem);
    TmpAListItem.Assign(AListItem);
    AListItem.Assign(swLI);
    LV.Selected := TmpAListItem;
    LV.Selected.Focused := True;
    LV.Selected.MakeVisible(False);
  finally
    swLI.Delete;
    LV.Items.EndUpdate;
  end;
end;

function Choisir(const Texte1, Texte2: string; Bouton: Integer): TModalResult;
var
  w: Integer;
begin
  if not Bouton in [0..2] then begin
    Result := 0; Exit;
  end;
  with TFrmChoix.Create(Application) do try
    w := Max(Canvas.TextWidth(Texte1), Canvas.TextWidth(Texte2));
    with BtnChoix1 do begin
      Width := Max(ClientWidth, w + Left);
      Caption := Texte1;
    end;
    with BtnChoix2 do begin
      Width := Max(ClientWidth, w + Left);
      Caption := Texte2;
    end;
    ClientWidth := BtnChoix1.Width + 2 * BtnChoix1.Left;
    Bevel2.Width := ClientWidth - 2 * Bevel2.Left;
    Bevel1.Width := ClientWidth - 2 * Bevel1.Left;
    BtnAnnuler.Left := (ClientWidth - BtnAnnuler.Width) div 2;
    if bouton = 0 then BtnAnnuler.Default := True;
    if bouton = 1 then BtnChoix1.Default := True;
    if bouton = 2 then BtnChoix2.Default := True;
    Result := ShowModal;
  finally
    Free;
  end;
end;

function ChoisirDetail(Bouton: Integer; out DetailsOptions: TDetailOptions): TModalResult;
var
  w: Integer;
  Texte1, Texte2: string;
begin
  Texte1 := rsTransListeSimple;
  Texte2 := rsTransListeDetail;
  if not Bouton in [0..2] then begin
    Result := 0; Exit;
  end;
  with TFrmChoixDetail.Create(Application) do try
    w := Max(Canvas.TextWidth(Texte1), Canvas.TextWidth(Texte2));
    with BtnChoix1 do begin
      Width := Max(ClientWidth, w + Left);
      Caption := Texte1;
    end;
    with BtnChoix2 do begin
      Width := Max(ClientWidth, w + Left);
      Caption := Texte2;
    end;
    ClientWidth := BtnChoix1.Width + 2 * BtnChoix1.Left;
    Bevel2.Width := ClientWidth - 2 * Bevel2.Left;
    Bevel1.Width := ClientWidth - 2 * Bevel1.Left;
    BtnAnnuler.Left := (ClientWidth - BtnAnnuler.Width) div 2;
    if bouton = 0 then BtnAnnuler.Default := True;
    if bouton = 1 then BtnChoix1.Default := True;
    if bouton = 2 then BtnChoix2.Default := True;
    Result := ShowModal;
    if Result = mrNo then begin
      if cbScenario.Checked then Include(DetailsOptions, doScenario);
      if cbDessins.Checked then Include(DetailsOptions, doDessins);
      if cbCouleurs.Checked then Include(DetailsOptions, doCouleurs);
      if cbHistoire.Checked then Include(DetailsOptions, doHistoire);
      if cbNotes.Checked then Include(DetailsOptions, doNotes);
    end;
  finally
    Free;
  end;
end;

function Convertisseur(Caller: TControl; var Value: Currency): Boolean;
var
  p: TPoint;
begin
  with TFrmConvers.Create(nil) do try
    Valeur := Value;
    p := Caller.ClientOrigin;
    Inc(p.y, Caller.Height);
    Left := p.x;
    Top := p.y;
    if Left + Width > Screen.WorkAreaRect.Right then Left := Max(0, Screen.WorkAreaRect.Right - Width);
    if Top + Height > Screen.WorkAreaRect.Bottom then Top := Max(0, Screen.WorkAreaRect.Bottom - Height);
    Result := ShowModal = mrOk;
    if Result then Value := Valeur;
  finally
    Free;
  end;
end;

procedure PrepareLV(Form: TForm);
var
  i, j, w: integer;
begin
  for i := 0 to Form.ComponentCount - 1 do try
    if Form.Components[i] is TListView then
      with Form.Components[i] as TListView do
        if Columns.Count = 1 then Columns[0].Width := ClientWidth - GetSystemMetrics(SM_CXVSCROLL);
    if Form.Components[i] is TVirtualStringTree then
      with (Form.Components[i] as TVirtualStringTree).Header do
        if Columns.Count > 0 then begin
          w := 0;
          for j := 0 to Pred(Columns.Count) do
            if j <> MainColumn then Inc(w, Columns[j].Width);
          Columns[MainColumn].Width := TreeView.ClientWidth - w - GetSystemMetrics(SM_CXVSCROLL);
        end;
  except
  end;
end;

function SupprimerTable(Table: string): Boolean;
begin
  try
    with TJvUIBQuery.Create(nil) do try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      Transaction.Database.Connected := False; // fonctionne mais pas correct du tout!
      Transaction.Database.Connected := True;
      SQL.Text := 'DROP TABLE ' + Table;
      ExecSQL;
      Transaction.Commit;
      Result := True;
    finally
      Transaction.Free;
      Free;
    end;
  except
    Result := False;
  end;
end;

function SupprimerToutDans(const ChampSupp, Table: string; const Reference: string = ''; Valeur: Integer = -1; UseTransaction: TJvUIBTransaction = nil): Boolean;
var
  BackupPossible: Boolean;
begin
  BackupPossible := ChampSupp <> '';
  try
    with TJvUIBQuery.Create(nil) do try
      if Assigned(UseTransaction) then
        Transaction := UseTransaction
      else
        Transaction := GetTransaction(DMPrinc.UIBDataBase);

      if BackupPossible then
        SQL.Add(Format('UPDATE %s set %s = True', [Table, ChampSupp]))
      else
        SQL.Add(Format('DELETE FROM %s', [Table]));

      if Reference <> '' then SQL.Add(Format('WHERE %s = %d', [Reference, Valeur]));
      ExecSQL;
      Transaction.Commit;
      Result := True;
    finally
      if not Assigned(UseTransaction) then Transaction.Free;
      Free;
    end;
  except
    Result := False;
  end;
end;

const
  ErrorSaveMvt = 'Impossible d''enregistrer le mouvement !';

function AjoutMvt(RefEmprunteur, RefObjet: Integer; DateE: TDateTime; Pret: Boolean): Boolean;
begin
  Result := False;
  try
    with TJvUIBQuery.Create(nil) do try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'Execute procedure PROC_AJOUTMVT(:RefEdition, :RefEmprunteur, :DateEmprunt, :Pret)';

      Params.AsInteger[0] := RefObjet;
      Params.AsInteger[1] := RefEmprunteur;
      Params.AsDateTime[2] := DateE;
      Params.AsInteger[3] := Iif(Pret, 1, 0);
      ExecSQL;
      Transaction.Commit;
    finally
      Transaction.Free;
      Free;
    end;
    Result := True;
  except
    AffMessage(ErrorSaveMvt + #13#10 + Exception(ExceptObject).Message, mtWarning, [mbOk], True);
  end;
end;

function ChargeImage(Picture: TPicture; const ResName: string): Boolean;
begin
  Result := False;
  Picture.Bitmap.FreeImage;
  if Utilisateur.Options.Images and not IsRemoteSession then begin
    if HandleDLLPic <= 32 then HandleDLLPic := LoadLibrary(PChar(RessourcePic));
    if HandleDLLPic > 32 then try
      Picture.Bitmap.LoadFromResourceName(HandleDLLPic, ResName);
      Result := True;
    except
    end;
  end;
end;

function ChargeImage(ImgBmp: TImage; const ResName: string; ForceVisible: Boolean = True): Boolean;
begin
  Result := ChargeImage(ImgBmp.Picture, ResName);
  if ForceVisible then ImgBmp.Visible := not ImgBmp.Picture.Bitmap.Empty;
end;

procedure VideListePointer(ListView: TListView);
var
  i: Integer;
  p: pointer;
begin
  try
    for i := 0 to ListView.Items.Count - 1 do begin
      p := ListView.Items[i].Data;
      Dispose(p);
    end;
  finally
    ListView.Items.Clear;
  end;
end;

procedure InitScrollBoxTableChamps(ScrollBox: TScrollBox; const Table: string; Ref: Integer; Editable: Boolean = False);
var
  t: Integer;
  c: TComponent;
  l: TLabel;
  s: string;
  Champs, Desc: TJvUIBQuery;
  Champ: Integer;
  LockUpdate: ILockWindow;
  TypeChamp: TUIBFieldType;
begin
  LockUpdate := TLockWindow.Create(ScrollBox);
  for t := ScrollBox.ControlCount - 1 downto 0 do
    ScrollBox.Controls[t].Free;
  t := 4;
  Desc := TJvUIBQuery.Create(nil);
  Champs := TJvUIBQuery.Create(nil);
  try
    with Desc do begin
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'SELECT Champ, TEXTECHAMP FROM description_typesupport WHERE Upper(TableChamps) = ? ORDER BY ordrechamp';
      Params.AsString[0] := UpperCase(Table);
      Open;
    end;
    if not Desc.Eof then begin
      with Champs do begin
        Transaction := Desc.Transaction;
        SQL.Text := 'SELECT * FROM ' + Table + ' WHERE RefSupport = ?';
        Params.AsInteger[0] := Ref;
        FetchBlobs := True;
        Open;
      end;
      with Desc do begin
        while not Eof do begin
          try
            Champ := Champs.Fields.GetFieldIndex(Fields.ByNameAsString['Champ']);
          except
            Champ := -1;
          end;
          if Champ <> -1 then begin
            TypeChamp := Fields.FieldType[Champ];
            case TypeChamp of
              uftChar, uftVarchar, uftInteger, uftFloat: begin
                  l := TLabel.Create(ScrollBox.Owner);
                  with l do begin
                    Top := t;
                    Parent := ScrollBox;
                    Caption := Fields.ByNameAsString['TEXTECHAMP'] + ':';
                    Left := 4;
                    Inc(t, Height);
                    Name := 'Compo' + IntToStr(ScrollBox.Owner.ComponentCount);
                  end;
                  if Editable then
                    c := TEditLabeled.Create(ScrollBox.Owner)
                  else
                    c := TEdit.Create(ScrollBox.Owner);
                  with TEdit(c) do begin
                    Anchors := [akLeft, akTop, akRight];
                    BevelKind := bkTile;
                    BorderStyle := bsNone;
                    Top := t;
                    Parent := ScrollBox;
                    Left := 4;
                    Width := ScrollBox.Width - 12 - GetSystemMetrics(SM_CXVSCROLL);
                    Inc(t, Height);
                    Name := Champs.Fields.SqlName[Champ];
                    if not (Champs.Eof or Champs.Fields.IsNull[Champ]) then
                      Text := Champs.Fields.AsString[Champ]
                    else
                      Text := '';
                    if Editable then begin
                      with TEditLabeled(c) do begin
                        LinkLabel.LinkLabel.Add(l.Name);
                        case TypeChamp of
                          uftChar, uftVarchar: TypeDonnee := tdChaine;
                          uftInteger: TypeDonnee := tdEntierSigne;
                          uftFloat: TypeDonnee := tdNumericSigne;
                        end;
                      end;
                    end
                    else
                      ReadOnly := True;
                  end;
                end;
              uftSmallInt: begin
                  if Editable then
                    c := TCheckBoxLabeled.Create(ScrollBox.Owner)
                  else
                    c := TReadOnlyCheckBox.Create(ScrollBox.Owner);
                  with TCheckBox(c) do begin
                    Anchors := [akLeft, akTop, akRight];
                    Top := t;
                    Parent := ScrollBox;
                    Name := Champs.Fields.SqlName[Champ];
                    s := Fields.ByNameAsString['TEXTECHAMP'];
                    Caption := s;
                    Left := 4;
                    Width := TForm(ScrollBox.Owner).Canvas.TextWidth(s) + 32;
                    Inc(t, Height + 4);
                    Checked := not (Champs.Eof or Champs.Fields.IsNull[Champ]) and Champs.Fields.AsBoolean[Champ];
                    if Editable then begin
                      with TCheckBoxLabeled(c) do begin
                      end;
                    end;
                  end;
                end;
              uftBlob: begin
                  l := TLabel.Create(ScrollBox.Owner);
                  with l do begin
                    Top := t;
                    Parent := ScrollBox;
                    Caption := Fields.ByNameAsString['TEXTECHAMP'] + ':';
                    Left := 4;
                    Inc(t, Height);
                    Name := 'Compo' + IntToStr(ScrollBox.Owner.ComponentCount);
                  end;
                  if Editable then
                    c := TMemoLabeled.Create(ScrollBox.Owner)
                  else
                    c := TMemo.Create(ScrollBox.Owner);
                  with TMemo(c) do begin
                    Anchors := [akLeft, akTop, akRight];
                    BevelKind := bkTile;
                    BorderStyle := bsNone;
                    Top := t;
                    Parent := ScrollBox;
                    Left := 4;
                    Width := ScrollBox.Width - 12 - GetSystemMetrics(SM_CXVSCROLL);
                    ClientHeight := 4 * TForm(ScrollBox.Owner).Canvas.TextHeight('A');
                    Inc(t, Height + 4);
                    Name := Champs.Fields.SqlName[Champ];
                    if not (Champs.Eof or Champs.Fields.IsNull[Champ]) then
                      Lines.Text := Champs.Fields.AsString[Champ]
                    else
                      Lines.Text := '';
                    WordWrap := True;
                    if Editable then begin
                      with TMemoLabeled(c) do begin
                        LinkLabel.LinkLabel.Add(l.Name);
                      end;
                    end
                    else begin
                      ReadOnly := True;
                      ScrollBars := ssVertical;
                    end;
                  end;
                end;
              uftDate, uftTime, uftTimestamp: begin
                  l := TLabel.Create(ScrollBox.Owner);
                  with l do begin
                    Top := t;
                    Parent := ScrollBox;
                    Caption := Fields.ByNameAsString['TEXTECHAMP'] + ':';
                    Left := 4;
                    Inc(t, Height);
                    Name := 'Compo' + IntToStr(ScrollBox.Owner.ComponentCount);
                  end;
                  if Editable then
                    c := TEditLabeled.Create(ScrollBox.Owner)
                  else
                    c := TEdit.Create(ScrollBox.Owner);
                  with TEdit(c) do begin
                    Anchors := [akLeft, akTop, akRight];
                    BevelKind := bkTile;
                    BorderStyle := bsNone;
                    Top := t;
                    Parent := ScrollBox;
                    Left := 4;
                    Width := ScrollBox.Width - 12 - GetSystemMetrics(SM_CXVSCROLL);
                    Inc(t, Height + 4);
                    Name := Champs.Fields.SqlName[Champ];
                    if not (Champs.Eof or Champs.Fields.IsNull[Champ]) then
                      Text := Champs.Fields.AsString[Champ]
                    else
                      Text := '';
                    if Editable then begin
                      with TEditLabeled(c) do begin
                        LinkLabel.LinkLabel.Add(l.Name);
                        case TypeChamp of
                          uftDate: TypeDonnee := tdDate;
                          uftTime: TypeDonnee := tdHeure;
                          uftTimestamp: TypeDonnee := tdDateHeure;
                        end;
                      end;
                    end
                    else
                      TEdit(c).ReadOnly := True;
                  end;
                end;
            end; // case Champ.Datatype
          end; // if Assigned(Champ)
          Next;
        end; // while not eof
      end; // with Desc
    end;
  finally
    Desc.Transaction.Free;
    Desc.Free;
    Champs.Free;
  end;
end;

function GetShellImage(const Path: string; Large, Open: Boolean): Integer;
var
  FileInfo: TSHFileInfo;
  Flags: Integer;
begin
  FillChar(FileInfo, SizeOf(FileInfo), #0);
  Flags := SHGFI_SYSICONINDEX or SHGFI_ICON;
  if Open then Flags := Flags or SHGFI_OPENICON;
  if Large then
    Flags := Flags or SHGFI_LARGEICON
  else
    Flags := Flags or SHGFI_SMALLICON;
  SHGetFileInfo(PChar(Path), 0, FileInfo, SizeOf(FileInfo), Flags);
  Result := FileInfo.iIcon;
end;

constructor TLockWindow.Create(Form: TWinControl);
begin
  FLocked := LockWindowUpdate(Form.Handle);
end;

destructor TLockWindow.Destroy;
begin
  if FLocked then LockWindowUpdate(0);
  inherited;
end;

{ TModeEditing }

constructor TModeEditing.Create;
var
  i: Integer;
begin
  FOldMode := Mode_en_cours;
  Mode_en_cours := mdEditing;
  for i := 0 to Pred(Fond.ActionsOutils.ActionCount) do
    TAction(Fond.ActionsOutils.Actions[i]).Enabled := False;
end;

destructor TModeEditing.Destroy;
var
  i: Integer;
begin
  Mode_en_cours := FOldMode;
  if Mode_en_cours <> mdEditing then
    for i := 0 to Pred(Fond.ActionsOutils.ActionCount) do
      TAction(Fond.ActionsOutils.Actions[i]).Enabled := True;
  inherited;
end;

procedure showimage(bmp: tgraphic);
var
  f: tform;
begin
  f := tform.create(nil);
  try
    with timage.create(f) do try
      parent := f;
      align := alClient;
      visible := true;
      picture.assign(bmp);
      f.ShowModal;
    finally
      free;
    end;
  finally
  end;
end;

function ResizePicture(Image: TPicture; Hauteur, Largeur: Integer; AntiAliasing, Cadre: Boolean; Effet3D: Integer): TStream;
var
  NewLargeur, NewHauteur: Integer;
  Bmp: TBitmap;
  Trace: array of TPoint;
begin
  Result := TMemoryStream.Create;
  try
    if (Hauteur <> -1) or (Largeur <> -1) then begin
      if Hauteur = -1 then begin
        NewLargeur := Largeur;
        NewHauteur := Windows.MulDiv(NewLargeur, Image.Height, Image.Width);
      end
      else begin
        NewHauteur := Hauteur;
        NewLargeur := Windows.MulDiv(NewHauteur, Image.Width, Image.Height);
        if (Largeur <> -1) and (NewLargeur > Largeur) then begin
          NewLargeur := Largeur;
          NewHauteur := Windows.MulDiv(NewLargeur, Image.Height, Image.Width);
        end;
      end;
      Bmp := TBitmap.Create;
      try
        Dec(NewHauteur, Effet3D);
        Dec(NewLargeur, Effet3D);
        Bmp.Height := NewHauteur;
        Bmp.Width := NewLargeur;
        if AntiAliasing then begin
          Bmp.Assign(Image.Graphic);
          Stretch(NewLargeur, NewHauteur, sfBell, 0, Bmp);
        end
        else
          Bmp.Canvas.StretchDraw(Rect(0, 0, NewLargeur, NewHauteur), Image.Graphic);
        Bmp.Height := NewHauteur + Effet3D;
        Bmp.Width := NewLargeur + Effet3D;
        BMP.Canvas.TextOut(Bmp.Width, Bmp.Height, '');

        if Cadre then begin
          Bmp.Canvas.Pen.Color := clBlack;
          Bmp.Canvas.Pen.Style := psSolid;
          Bmp.Canvas.Brush.Color := clBlack;
          Bmp.Canvas.Brush.Style := bsClear;
          Bmp.Canvas.Rectangle(0, 0, NewLargeur, NewHauteur);
        end;

        if Effet3D > 0 then begin
          Bmp.Canvas.Pen.Color := clBlack;
          Bmp.Canvas.Pen.Style := psSolid;
          Bmp.Canvas.Brush.Color := clGray;
          Bmp.Canvas.Brush.Style := bsSolid;
          SetLength(Trace, 6);
          Trace[0] := Point(0, NewHauteur);
          Trace[1] := Point(0 + Effet3D, Bmp.Height);
          Trace[2] := Point(Bmp.Width, Bmp.Height);
          Trace[3] := Point(Bmp.Width, 0 + Effet3D);
          Trace[4] := Point(NewLargeur, 0);
          Trace[5] := Point(NewLargeur, NewHauteur);
          Bmp.Canvas.Polygon(Trace);
        end;

        with TJPEGImage.Create do try
          Assign(Bmp);
          PixelFormat := jf24Bit;
          CompressionQuality := 70;
          Compress;
          SaveToStream(Result);
        finally
          Free;
        end;
      finally
        Bmp.Free;
      end;
    end
    else
      Image.Graphic.SaveToStream(Result);

    Result.Position := 0;
  except
    FreeAndNil(Result);
  end;
end;

function GetCouvertureStream(const Fichier: string; Hauteur, Largeur: Integer; AntiAliasing: Boolean; Cadre: Boolean = False; Effet3D: Integer = 0): TStream;
var
  Couverture: TPicture;
  img: TJPEGImage;
  Stream: TStream;
begin
  Couverture := TPicture.Create;
  try
    Stream := GetJPEGStream(Fichier);
    img := TJPEGImage.Create;
    try
      Stream.Position := 0;
      img.LoadFromStream(Stream);
      Couverture.Assign(img);
    finally
      img.Free;
      FreeAndNil(Stream);
    end;
    Result := ResizePicture(Couverture, Hauteur, Largeur, AntiAliasing, Cadre, Effet3D);
  finally
    Couverture.Free;
  end;
end;

function GetCouvertureStream(RefCouverture, Hauteur, Largeur: Integer; AntiAliasing: Boolean; Cadre: Boolean = False; Effet3D: Integer = 0): TStream;
var
  Couverture: TPicture;
begin
  Couverture := TPicture.Create;
  try
    LoadCouverture(RefCouverture, Couverture);
    Result := ResizePicture(Couverture, Hauteur, Largeur, AntiAliasing, Cadre, Effet3D);
  finally
    Couverture.Free;
  end;
end;

procedure LoadCouverture(RefCouverture: Integer; Picture: TPicture);
var
  ms: TMemoryStream;
  img: TJPEGImage;
  Fichier, Chemin: string;
begin
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT Couverture, TypeCouverture, FichierCouverture FROM Couvertures WHERE RefCouverture = ?';
    Params.AsInteger[0] := RefCouverture;
    FetchBlobs := True;
    Open;
    if Eof then
      Picture.Assign(nil)
    else if not Fields.AsBoolean[1] then begin
      Fichier := ExtractFileName(Fields.AsString[2]);
      Chemin := ExtractFilePath(Fields.AsString[2]);
      if Chemin = '' then Chemin := RepImages;
      SQL.Text := 'SELECT BlobContent FROM LOADBLOBFROMFILE(:Chemin, :Fichier);';
      Params.AsString[0] := Chemin;
      Params.AsString[1] := Fichier;
      Open;
      if Eof then begin
        Picture.Assign(nil);
        Exit;
      end;
    end;

    ms := TMemoryStream.Create;
    img := TJPEGImage.Create;
    try
      ReadBlob(0, ms);
      ms.Position := 0;
      img.LoadFromStream(ms);
      Picture.Assign(img);
    finally
      ms.Free;
      img.Free;
    end;
  finally
    Transaction.Free;
    Free;
  end;
end;

function GetJPEGStream(const Fichier: string): TStream;

  function MatchesMask(const Fichier, Mask: string): Boolean;
  begin
    with TStringList.Create do try
      Text := StringReplace(LowerCase(Mask), ';', #13#10, [rfReplaceAll]);
      Result := IndexOf('*' + Fichier) <> -1;
    finally
      Free;
    end;
  end;

var
  jImg: TJPEGImage;
  Img: TPicture;
begin
  if MatchesMask(LowerCase(ExtractFileExt(Fichier)), GraphicFileMask(TJPEGImage)) then begin
    Result := TFileStream.Create(Fichier, fmOpenRead or fmShareDenyWrite);
  end
  else begin
    Result := TMemoryStream.Create;
    img := TPicture.Create;
    jImg := TJPEGImage.Create;
    try
      img.LoadFromFile(Fichier);
      jImg.PixelFormat := jf24Bit;
      jImg.Assign(img.Graphic);
      jImg.CompressionQuality := 70;
      jImg.Compress;
      jImg.SaveToStream(Result);
    finally
      jImg.Free;
      img.Free;
    end;
  end;
  Result.Position := 0;
end;

{ TInformation }

constructor TInformation.Create;
begin
  FInfo := nil;
  FLabel := nil;
end;

destructor TInformation.Destroy;
begin
  if Assigned(FInfo) then FreeAndNil(FInfo);
  inherited;
end;

procedure TInformation.SetupDialog;
var
  FPanel: TPanel;
begin
  if Assigned(FInfo) then Exit;
  FInfo := TForm.Create(Application);
  with FInfo do begin
    AutoSize := True;
    BorderWidth := 0;
    FormStyle := fsStayOnTop;
    Position := poScreenCenter;
    BorderStyle := bsNone;
    BorderIcons := [];
  end;
  FPanel := TPanel.Create(FInfo);
  with FPanel do begin
    Parent := FInfo;
    AutoSize := True;
    BorderWidth := 8;
    Left := 0;
    Top := 0;
    Visible := True;
  end;
  FLabel := TLabel.Create(FInfo);
  with FLabel do begin
    Parent := FPanel;
    AutoSize := True;
    Left := 0;
    Top := 0;
    Visible := True;
  end;
end;

procedure TInformation.ShowInfo(Msg: string);
begin
  SetupDialog;
  FLabel.Caption := Msg;
  FInfo.Show;
  Application.ProcessMessages;
end;

procedure TWaiting.ClearForm;
begin
  if Assigned(FForm) then FreeAndNil(FForm);
end;

constructor TWaiting.Create(const Msg: string; WaitFor: Cardinal; Retour: PInteger);
begin
  inherited Create;
  FTimer := TTimer.Create(nil);
  FTimer.Interval := WaitFor;
  FTimer.OnTimer := Execute;
  FForm := nil;
  FTimeToWait := WaitFor;
  if Assigned(Retour) then Retour^ := 0;
  PResult := Retour;
  FTimer.Enabled := True;
end;

procedure TWaiting.InitForm;
var
  FButton: TButton;
  tmpForm: TFrmProgression;
begin
  tmpForm := TFrmProgression.Create(Application);
  if Assigned(PResult) then begin
    FButton := TButton.Create(FForm);
    with FButton do begin
      Parent := tmpForm;
      ModalResult := mrCancel;
      Caption := 'Annuler';
      Parent.ClientHeight := Parent.ClientHeight + Height + 5;
      SetBounds(Parent.ClientWidth - Width, Parent.ClientHeight - Height, Width, Height);
      OnClick := Self.Cancel;
    end;
  end;
  FForm := tmpForm;
  RefreshForm;
end;

destructor TWaiting.Destroy;
begin
  ShowProgression(FMessage, epFin);
  FreeAndNil(FTimer);
  if Assigned(FForm) then ClearForm;
  inherited;
end;

procedure TWaiting.Execute(Sender: TObject);
begin
  FTimer.Enabled := False;
  InitForm;
end;

procedure TWaiting.RefreshForm;
begin
  if Assigned(FForm) then begin
    FForm.ProgressBar1.Max := FMaxi;
    FForm.ProgressBar1.Position := FValeur;
    FForm.op.Caption := FMessage;
    FForm.Show;
    Application.ProcessMessages;
  end;
end;

procedure TWaiting.ShowProgression(const Texte: string; Etape: TEtapeProgression);
begin
  case Etape of
    epNext: Inc(FValeur);
    epFin: FValeur := FMaxi;
  end;
  FMessage := Texte;

  RefreshForm;
end;

procedure TWaiting.ShowProgression(const Texte: string; Valeur, Maxi: Integer);
begin
  FMaxi := Maxi;
  FValeur := Valeur;
  FMessage := Texte;
  RefreshForm;
end;

procedure TWaiting.ShowProgression(Texte: PChar; Valeur, Maxi: Integer);
begin
  FMaxi := Maxi;
  FValeur := Valeur;
  FMessage := Texte;
  RefreshForm;
end;

procedure TWaiting.Cancel(Sender: TObject);
begin
  if Assigned(PResult) then PResult^ := FForm.ModalResult;
  FForm.Release;
  FForm := nil;
end;

function HTMLPrepare(const AStr: string): string;
begin
  Result := HTMLEncode(AStr);
  ReplaceString(Result, #13, '<br>');
end;

function SearchNewFileName(const Chemin, Fichier: string; Reserve: Boolean = True): string;
begin
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT * FROM SearchFileName(:Chemin, :Fichier, :Reserve)';
    Params.AsString[0] := IncludeTrailingPathDelimiter(Chemin);
    Params.AsString[1] := Fichier;
    Params.AsBoolean[2] := Reserve;
    Open;
    Result := ExtractFileName(Fields.AsString[0]);
  finally
    Transaction.Free;
    Free;
  end;
end;

end.

