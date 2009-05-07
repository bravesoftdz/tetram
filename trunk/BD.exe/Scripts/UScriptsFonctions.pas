unit UScriptsFonctions;

interface

uses
  Windows, SysUtils, Classes, Dialogs, WinInet, StrUtils, Math, UMetadata, TypeRec, Generics.Collections, UNet, jpeg;

type
  TScriptChoix = class

    type TChoix = class
      FLibelle, FCommentaire, FData: string;
      FImage: TJPEGImage;

      constructor Create;
      destructor Destroy; override;
    end;

    type TCategorie = class
      FNom: string;
      Choix: TObjectList<TChoix>;

      constructor Create;
      destructor Destroy; override;
    end;

  private
    FList: TObjectList<TCategorie>;
    FTitre: string;
    function GetCategorie(const Name: string): TCategorie; overload;
    function GetCategorie(const Name: string; Force: Boolean): TCategorie; overload;
  public
    constructor Create;
    destructor Destroy; override;

    procedure ResetList;
    procedure AjoutChoix(const Categorie, Libelle, Commentaire, Data: string);
    procedure AjoutChoixWithThumb(const Categorie, Libelle, Commentaire, Data, URL: string);
    function Show: string;

    function CategorieCount: Integer;
    function ChoixCount: Integer;
    function CategorieChoixCount(const Name: string): Integer;

    property Categorie[const Name: string]: TCategorie read GetCategorie;
    property Titre: string read FTitre write FTitre;
  end;

function GetPage(const url: string; UTF8: Boolean = True): string;
function PostPage(const url: string; Pieces: array of RAttachement; UTF8: Boolean = True): string;
function findInfo(const sDebut, sFin, sChaine, sDefault: string): string;
function MakeAuteur(const Nom: string; Metier: TMetierAuteur): TAuteur;
function AskSearchEntry(const Labels: array of string; out Search: string; out Index: Integer): Boolean;
procedure Split(SL: TStringList; const Chaine: string; Sep: Char);
function CombineURL(const Root, URL: string): string;
function ScriptStrToFloatDef(const S: string; const Default: Extended): Extended;

function ScriptChangeFileExt(const FileName, Extension: string): string;
function ScriptChangeFilePath(const FileName, Path: string): string;
function ScriptExtractFilePath(const FileName: string): string;
function ScriptExtractFileDir(const FileName: string): string;
function ScriptExtractFileName(const FileName: string): string;
function ScriptExtractFileExt(const FileName: string): string;
function ScriptIncludeTrailingPathDelimiter(const S: string): string;
function ScriptExcludeTrailingPathDelimiter(const S: string): string;

implementation

uses
  ProceduresBDtk, UBdtForms, EditLabeled, StdCtrls, Controls, Forms, UframBoutons,
  UfrmScriptChoix, OverbyteIcsHttpProt, CommonConst, Procedures;

const
  PathDelim = '/';
  DriveDelim = '';

constructor TScriptChoix.Create;
begin
  inherited;
  FTitre := 'Choisir parmi ces éléments';
  FList := TObjectList<TCategorie>.Create(True);
end;

destructor TScriptChoix.Destroy;
begin
  FList.Free;
  inherited;
end;

procedure TScriptChoix.AjoutChoixWithThumb(const Categorie, Libelle, Commentaire, Data, URL: string);
var
  Stream: TFileStream;
  P: PChar;
  tmpFile, docType: string;
  LoadImage: Boolean;
  Choix: TChoix;
  ms: TStream;
begin
  SetLength(tmpFile, MAX_PATH + 1);
  FillMemory(@tmpFile[1], Length(tmpFile) * SizeOf(Char), 1);
  GetTempFileName(TempPath, 'bdk', 0, @tmpFile[1]);
  P := @tmpFile[1];
  while P^ <> #0 do
    Inc(P);
  SetLength(tmpFile, (Integer(P) - Integer(@tmpFile[1])) div SizeOf(Char));

  Stream := TFileStream.Create(tmpFile, fmOpenReadWrite, fmShareExclusive);
  try
    try
      LoadImage := LoadStreamURL(URL, [], Stream, docType) = 200;
    finally
      Stream.Free;
    end;

    Choix := TChoix.Create;
    GetCategorie(Categorie).Choix.Add(Choix);
    Choix.FLibelle := Libelle;
    Choix.FCommentaire := Commentaire;
    Choix.FData := Data;
    if LoadImage then
    begin
      ms := GetCouvertureStream(tmpFile, 70, 70, TGlobalVar.Utilisateur.Options.AntiAliasing);
      if Assigned(ms) then
        try
          Choix.FImage := TJPEGImage.Create;
          try
            Choix.FImage.LoadFromStream(ms);
          except
            FreeAndNil(Choix.FImage);
          end;
        finally
          FreeAndNil(ms);
        end;
    end;
  finally
    DeleteFile(tmpFile);
  end;
end;

procedure TScriptChoix.AjoutChoix(const Categorie, Libelle, Commentaire, Data: string);
var
  Choix: TChoix;
begin
  Choix := TChoix.Create;
  GetCategorie(Categorie).Choix.Add(Choix);
  Choix.FLibelle := Libelle;
  Choix.FCommentaire := Commentaire;
  Choix.FData := Data;
end;

function TScriptChoix.CategorieCount: Integer;
begin
  Result := FList.Count;
end;

function TScriptChoix.CategorieChoixCount(const Name: string): Integer;
var
  Categorie: TCategorie;
begin
  Categorie := GetCategorie(Name);
  if Assigned(Categorie) then
    Result := Categorie.Choix.Count
  else
    Result := 0;
end;

function TScriptChoix.ChoixCount: Integer;
var
  Categorie: TCategorie;
begin
  Result := 0;
  for Categorie in FList do
    Inc(Result, Categorie.Choix.Count);
end;

function TScriptChoix.GetCategorie(const Name: string): TCategorie;
begin
  Result := GetCategorie(Name, True);
end;

function TScriptChoix.GetCategorie(const Name: string; Force: Boolean): TCategorie;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to Pred(FList.Count) do
    if SameText(FList[i].FNom, Name) then
    begin
      Result := FList[i];
      Exit;
    end;

  if not Assigned(Result) then
  begin
    Result := TCategorie.Create;
    FList.Add(Result);
    Result.FNom := Name;
  end;
end;

procedure TScriptChoix.ResetList;
begin
  FList.Clear;
end;

function TScriptChoix.Show: string;
begin
  Result := '';
  if FList.Count = 0 then
    Exit;

  with TfrmScriptChoix.Create(nil) do
    try
      Caption := FTitre;
      SetList(Self.FList);
      if ShowModal <> mrOk then
        Exit;
      Result := FList[VirtualStringTree1.GetFirstSelected.Parent.Index].Choix[VirtualStringTree1.GetFirstSelected.Index].FData;
    finally
      Free;
    end;
end;

constructor TScriptChoix.TChoix.Create;
begin
  inherited;
  FImage := nil;
end;

destructor TScriptChoix.TChoix.Destroy;
begin
  FImage.Free;
  inherited;
end;

constructor TScriptChoix.TCategorie.Create;
begin
  inherited;
  Choix := TObjectList<TChoix>.Create(True);
end;

destructor TScriptChoix.TCategorie.Destroy;
begin
  Choix.Free;
  inherited;
end;

function findInfo(const sDebut, sFin, sChaine, sDefault: string): string;
var
  iDebut, iFin: Integer;
begin
  Result := sDefault;
  if sDebut = '' then
    iDebut := 1
  else
    iDebut := Pos(sDebut, sChaine);
  if iDebut > 0 then
  begin
    Inc(iDebut, Length(sDebut));
    if sFin = '' then
      iFin := Length(sChaine)
    else
      iFin := PosEx(sFin, sChaine, iDebut);
    if iFin = 0 then
      iFin := Length(sChaine);
    Result := Copy(sChaine, iDebut, iFin - iDebut);
  end;
end;

function PostPage(const url: string; Pieces: array of RAttachement; UTF8: Boolean): string;
var
  ss: TStringStream;
begin
  if UTF8 then
    ss := TStringStream.Create('', TEncoding.UTF8)
  else
    ss := TStringStream.Create('', TEncoding.Default);
  try
    if LoadStreamURL(url, Pieces, ss) = 200 then
      Result := ss.DataString
    else
      Result := '';
  finally
    ss.Free;
  end;
end;

function GetPage(const url: string; UTF8: Boolean): string;
var
  ss: TStringStream;
begin
  if UTF8 then
    ss := TStringStream.Create('', TEncoding.UTF8)
  else
    ss := TStringStream.Create('', TEncoding.Default);
  try
    if LoadStreamURL(url, [], ss) = 200 then
      Result := ss.DataString
    else
      Result := '';
  finally
    ss.Free;
  end;
end;

function MakeAuteur(const Nom: string; Metier: TMetierAuteur): TAuteur;
begin
  Result := TAuteur.Create;
  Result.Personne.Nom := Nom;
  Result.Metier := Metier;
end;

type
  TdummyForm = class(TbdtForm)
  public
    procedure editChange(Sender: TObject);
  end;

procedure TdummyForm.editChange(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to Pred(ControlCount) do
    if (Controls[i] is TEditLabeled) and (Controls[i] <> Sender) then
      with Controls[i] as TEditLabeled do
      begin
        OnChange := nil;
        Text := '';
        OnChange := editChange;
      end;
end;

type
  TCrackLabel = class(TLabel);

function AskSearchEntry(const Labels: array of string; out Search: string; out Index: Integer): Boolean;
var
  F: TdummyForm;
  E: TEditLabeled;
  L: array of TLabel;
  i, t, maxW: Integer;
begin
  Result := False;
  if Length(Labels) = 0 then
    Exit;

  SetLength(L, Length(Labels));
  t := 0;
  F := TdummyForm.Create(nil);
  try
    F.Position := poMainFormCenter;
    E := nil;
    maxW := 0;

    for i := Low(Labels) to High(Labels) do
    begin
      L[i] := TLabel.Create(F);
      L[i].Parent := F;

      L[i].WordWrap := True;
      L[i].AutoSize := True;
      L[i].Caption := Labels[i];
      L[i].Left := 0;
      L[i].Width := 150;
      TCrackLabel(L[i]).AdjustBounds;
      L[i].Visible := True;
      L[i].Transparent := True;

      if L[i].Width > maxW then
        maxW := L[i].Width;
    end;

    for i := Low(Labels) to High(Labels) do
    begin
      E := TEditLabeled.Create(F);
      E.Parent := F;
      E.Tag := i;
      E.BevelKind := bkTile;
      E.BorderStyle := bsNone;
      E.LinkControls.Add(L[i]);
      E.Left := L[i].Left + maxW + 8;
      E.Width := 250;
      E.Visible := True;
      E.OnChange := F.editChange;

      if E.Height > L[i].Height then
      begin
        E.Top := t;
        t := t + E.Height + 8;
        L[i].Top := E.Top + (E.Height - L[i].Height) div 2;
      end
      else
      begin
        L[i].Top := t;
        t := t + L[i].Height + 8;
        E.Top := L[i].Top + (L[i].Height - E.Height) div 2;
      end;
    end;

    with TframBoutons.Create(F) do
    begin
      Align := alNone;
      Parent := F;
      Top := t + 8;
      Left := 0;
      Width := E.Left + E.Width;
    end;

    F.AutoSize := True;
    F.BorderStyle := bsDialog;
    F.BorderWidth := 8;
    F.PopupMode := pmAuto;
    Result := F.ShowModal = mrOk;

    if Result then
    begin
      Search := '';
      for i := 0 to Pred(F.ControlCount) do
        if (F.Controls[i] is TEditLabeled) and (TEditLabeled(F.Controls[i]).Text <> '') then
          with F.Controls[i] as TEditLabeled do
          begin
            Search := Trim(Text);
            Index := Tag;
          end;
      Result := Search <> '';
    end;
  finally
    F.Free;
  end;
end;

procedure Split(SL: TStringList; const Chaine: string; Sep: Char);
begin
  SL.Delimiter := Sep;
  SL.DelimitedText := Chaine;
end;

function CombineURL(const Root, URL: string): string;
var
  buffer: array of char;
  lbuffer: Cardinal;
begin
  lbuffer := 0;
  InternetCombineUrl(PChar(Root), PChar(URL), nil, lbuffer, ICU_BROWSER_MODE);
  SetLength(buffer, lbuffer);
  ZeroMemory(buffer, Length(buffer));
  InternetCombineUrl(PChar(Root), PChar(URL), PChar(buffer), lbuffer, ICU_BROWSER_MODE);
  Result := PChar(buffer);
end;

function ScriptFormatSettings: TFormatSettings;
begin
  GetLocaleFormatSettings(1033, Result);
end;

function ScriptStrToFloatDef(const S: string; const Default: Extended): Extended;
begin
  Result := StrToFloatDef(S, Default, ScriptFormatSettings);
end;

function ScriptIsPathDelimiter(const S: string; Index: Integer): Boolean;
begin
  Result := (Index > 0) and (Index <= Length(S)) and (S[Index] = PathDelim) and (ByteType(S, Index) = mbSingleByte);
end;

function ScriptIncludeTrailingPathDelimiter(const S: string): string;
begin
  Result := S;
  if not ScriptIsPathDelimiter(Result, Length(Result)) then
    Result := Result + PathDelim;
end;

function ScriptExcludeTrailingPathDelimiter(const S: string): string;
begin
  Result := S;
  if ScriptIsPathDelimiter(Result, Length(Result)) then
    SetLength(Result, Length(Result) - 1);
end;

function ScriptChangeFileExt(const FileName, Extension: string): string;
var
  I: Integer;
begin
  I := LastDelimiter('.' + PathDelim + DriveDelim, Filename);
  if (I = 0) or (FileName[I] <> '.') then
    I := MaxInt;
  Result := Copy(FileName, 1, I - 1) + Extension;
end;

function ScriptChangeFilePath(const FileName, Path: string): string;
begin
  Result := ScriptIncludeTrailingPathDelimiter(Path) + ScriptExtractFileName(FileName);
end;

function ScriptExtractFilePath(const FileName: string): string;
var
  I: Integer;
begin
  I := LastDelimiter(PathDelim + DriveDelim, FileName);
  Result := Copy(FileName, 1, I);
end;

function ScriptExtractFileDir(const FileName: string): string;
var
  I: Integer;
begin
  I := LastDelimiter(PathDelim + DriveDelim, Filename);
  if (I > 1) and (FileName[I] = PathDelim) and
    (not IsDelimiter(PathDelim + DriveDelim, FileName, I - 1)) then
    Dec(I);
  Result := Copy(FileName, 1, I);
end;

function ScriptExtractFileName(const FileName: string): string;
var
  I: Integer;
begin
  I := LastDelimiter(PathDelim + DriveDelim, FileName);
  Result := Copy(FileName, I + 1, MaxInt);
end;

function ScriptExtractFileExt(const FileName: string): string;
var
  I: Integer;
begin
  I := LastDelimiter('.' + PathDelim + DriveDelim, FileName);
  if (I > 0) and (FileName[I] = '.') then
    Result := Copy(FileName, I, MaxInt)
  else
    Result := '';
end;

end.

