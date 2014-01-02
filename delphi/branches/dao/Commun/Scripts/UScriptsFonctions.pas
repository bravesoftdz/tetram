unit UScriptsFonctions;

interface

uses
  Windows, SysUtils, Classes, Dialogs, WinInet, StrUtils, Math, UMetadata, Entities.Lite, Generics.Collections, UNet, jpeg,
  Entities.Full;

type
  TScriptChoix = class

  type
    TChoix = class
      FLibelle, FCommentaire, FData: string;
      FImage: TJPEGImage;

      constructor Create;
      destructor Destroy; override;
    end;

  type
    TCategorie = class
      FNom: string;
      Choix: TObjectList<TChoix>;

      constructor Create;
      destructor Destroy; override;
    end;

  strict private
    FList: TObjectList<TCategorie>;
    FTitre: string;
    function GetCategorie(const name: string): TCategorie;
  public
    constructor Create;
    destructor Destroy; override;

    procedure ResetList;
    procedure AjoutChoix(const Categorie, Libelle, Commentaire, Data: string);
    procedure AjoutChoixWithThumb(const Categorie, Libelle, Commentaire, Data, URL: string);
    function Show: string;

    function CategorieCount: Integer;
    function ChoixCount: Integer;
    function CategorieChoixCount(const name: string): Integer;

    property Categorie[const name: string]: TCategorie read GetCategorie;
    property Titre: string read FTitre write FTitre;
  end;

function findInfo(const sDebut, sFin, sChaine, sDefault: string): string;
function AskSearchEntry(const Labels: array of string; var Search: string; var index: Integer): Boolean;
procedure Split(SL: TStringList; const Chaine: string; Sep: Char);
function CombineURL(const Root, URL: string): string;
function ScriptStrToFloatDef(const S: string; const default: Extended): Extended;

function ScriptChangeFileExt(const FileName, Extension: string): string;
function ScriptChangeFilePath(const FileName, Path: string): string;
function ScriptExtractFilePath(const FileName: string): string;
function ScriptExtractFileDir(const FileName: string): string;
function ScriptExtractFileName(const FileName: string): string;
function ScriptExtractFileExt(const FileName: string): string;
function ScriptIncludeTrailingPathDelimiter(const S: string): string;
function ScriptExcludeTrailingPathDelimiter(const S: string): string;

function AddImageFromURL(Edition: TEditionFull; const URL: string; TypeImage: Integer): Integer;

implementation

uses
  IOUtils, UBdtForms, EditLabeled, StdCtrls, Controls, Forms, UframBoutons, UfrmScriptChoix, OverbyteIcsHttpProt, CommonConst, Procedures,
  SysConst, Graphics, System.UITypes, Entities.FactoriesLite,
  Entities.DaoLambda;

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
  Choix := TChoix.Create;
  GetCategorie(Categorie).Choix.Add(Choix);
  Choix.FLibelle := Libelle;
  Choix.FCommentaire := Commentaire;
  Choix.FData := Data;

  if URL <> '' then
    try
      SetLength(tmpFile, MAX_PATH + 1);
      ZeroMemory(@tmpFile[1], Length(tmpFile) * SizeOf(Char));
      GetTempFileName(PChar(TempPath), 'bdk', 0, @tmpFile[1]);
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

        if LoadImage then
        begin
          ms := GetJPEGStream(tmpFile, 70, 70, TGlobalVar.Utilisateur.Options.AntiAliasing);
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
        TFile.Delete(tmpFile);
      end;
    except
      //
    end;
end;

procedure TScriptChoix.AjoutChoix(const Categorie, Libelle, Commentaire, Data: string);
begin
  AjoutChoixWithThumb(Categorie, Libelle, Commentaire, Data, '');
end;

function TScriptChoix.CategorieCount: Integer;
begin
  Result := FList.Count;
end;

function TScriptChoix.CategorieChoixCount(const name: string): Integer;
var
  Categorie: TCategorie;
begin
  Categorie := GetCategorie(name);
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

function TScriptChoix.GetCategorie(const name: string): TCategorie;
begin
  for Result in FList do
    if SameText(Result.FNom, name) then
      Exit;

  Result := TCategorie.Create;
  FList.Add(Result);
  Result.FNom := name;
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
      Result := FList[VirtualStringTree1.GetFirstSelected.Parent.index].Choix[VirtualStringTree1.GetFirstSelected.index].FData;
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
  TCrackLabel = class(TLabel)
  end;

function AskSearchEntry(const Labels: array of string; var Search: string; var index: Integer): Boolean;
var
  F: TdummyForm;
  E: TEditLabeled;
  Titre, SousTitre: string;
  L, SubL: array of TLabel;
  i, T, maxW, P: Integer;
begin
  Result := False;
  if Length(Labels) = 0 then
    Exit;

  SetLength(L, Length(Labels));
  SetLength(SubL, Length(Labels));
  ZeroMemory(SubL, SizeOf(SubL));
  T := 0;
  F := TdummyForm.Create(nil);
  try
    F.Position := poMainFormCenter;
    E := nil;
    maxW := 0;

    for i := low(Labels) to high(Labels) do
    begin
      Titre := Labels[i];
      SousTitre := '';
      P := Pos('|', Titre);
      if P > 0 then
      begin
        SousTitre := Copy(Titre, P + 1, MaxInt);
        Titre := Copy(Titre, 1, P - 1);
      end;

      L[i] := TLabel.Create(F);
      L[i].Parent := F;

      L[i].WordWrap := True;
      L[i].AutoSize := True;
      L[i].Caption := Titre;
      L[i].Left := 0;
      L[i].Width := 150;
      TCrackLabel(L[i]).AdjustBounds;
      L[i].Visible := True;
      L[i].Transparent := True;

      if L[i].Width > maxW then
        maxW := L[i].Width;

      if SousTitre <> '' then
      begin
        SubL[i] := TLabel.Create(F);
        SubL[i].Parent := F;

        SubL[i].WordWrap := True;
        SubL[i].AutoSize := True;
        SubL[i].Caption := SousTitre;
        SubL[i].Left := 0;
        SubL[i].Visible := True;
        SubL[i].Transparent := True;
        SubL[i].Font.Style := SubL[i].Font.Style + [fsItalic];
      end;
    end;

    for i := low(Labels) to high(Labels) do
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
      if (index = i) then
      begin
        F.ActiveControl := E;
        E.Text := Search;
      end;
      E.OnChange := F.editChange;

      if E.Height > L[i].Height then
      begin
        E.Top := T;
        T := T + E.Height + 8;
        L[i].Top := E.Top + (E.Height - L[i].Height) div 2;
      end
      else
      begin
        L[i].Top := T;
        T := T + L[i].Height + 8;
        E.Top := L[i].Top + (L[i].Height - E.Height) div 2;
      end;

      if Assigned(SubL[i]) then
      begin
        SubL[i].Top := T - 8;
        SubL[i].Width := E.Left + E.Width;
        TCrackLabel(SubL[i]).AdjustBounds;
        T := T + SubL[i].Height;
      end;
    end;

    with TframBoutons.Create(F) do
    begin
      Align := alNone;
      Parent := F;
      Top := T + 8;
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
            index := Tag;
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
  buffer: array of Char;
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
  Result := TFormatSettings.Create('en-US');
end;

function ScriptStrToFloatDef(const S: string; const default: Extended): Extended;
var
  fs: TFormatSettings;
begin
  fs := ScriptFormatSettings;
  Result := StrToFloatDef(StringReplace(S, ',', fs.DecimalSeparator, []), default, fs);
end;

function ScriptIsPathDelimiter(const S: string; index: Integer): Boolean;
begin
  Result := (index > 0) and (index <= Length(S)) and (S[index] = PathDelim) and (ByteType(S, index) = mbSingleByte);
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
  i: Integer;
begin
  i := LastDelimiter('.' + PathDelim + DriveDelim, FileName);
  if (i = 0) or (FileName[i] <> '.') then
    i := MaxInt;
  Result := Copy(FileName, 1, i - 1) + Extension;
end;

function ScriptChangeFilePath(const FileName, Path: string): string;
begin
  Result := ScriptIncludeTrailingPathDelimiter(Path) + ScriptExtractFileName(FileName);
end;

function ScriptExtractFilePath(const FileName: string): string;
var
  i: Integer;
begin
  i := LastDelimiter(PathDelim + DriveDelim, FileName);
  Result := Copy(FileName, 1, i);
end;

function ScriptExtractFileDir(const FileName: string): string;
var
  i: Integer;
begin
  i := LastDelimiter(PathDelim + DriveDelim, FileName);
  if (i > 1) and (FileName[i] = PathDelim) and (not IsDelimiter(PathDelim + DriveDelim, FileName, i - 1)) then
    Dec(i);
  Result := Copy(FileName, 1, i);
end;

function ScriptExtractFileName(const FileName: string): string;
var
  i: Integer;
begin
  i := LastDelimiter(PathDelim + DriveDelim, FileName);
  Result := Copy(FileName, i + 1, MaxInt);
end;

function ScriptExtractFileExt(const FileName: string): string;
var
  i: Integer;
begin
  i := LastDelimiter('.' + PathDelim + DriveDelim, FileName);
  if (i > 0) and (FileName[i] = '.') then
    Result := Copy(FileName, i, MaxInt)
  else
    Result := '';
end;

function AddImageFromURL(Edition: TEditionFull; const URL: string; TypeImage: Integer): Integer;
var
  Stream: TFileStream;
  Couverture: TCouvertureLite;
  tmpFile: string;
  P: PChar;
begin
  Result := -1;

  SetLength(tmpFile, MAX_PATH + 1);
  FillMemory(@tmpFile[1], Length(tmpFile) * SizeOf(Char), 1);
  GetTempFileName(PChar(TempPath), 'bdk', 0, @tmpFile[1]);
  P := @tmpFile[1];
  while P^ <> #0 do
    Inc(P);
  SetLength(tmpFile, (Integer(P) - Integer(@tmpFile[1])) div SizeOf(Char));

  if TFile.Exists(tmpFile) then
    Stream := TFileStream.Create(tmpFile, fmOpenReadWrite, fmShareExclusive)
  else
    Stream := TFileStream.Create(tmpFile, fmCreate, fmShareExclusive);
  try
    Stream.Size := 0;
    if LoadStreamURL(URL, [], Stream) <> 200 then
      Exit;
  finally
    Stream.Free;
  end;

  Couverture := TFactoryCouvertureLite.getInstance;
  Result := Edition.Couvertures.Add(Couverture);
  Couverture.NewNom := tmpFile;
  Couverture.OldNom := Couverture.NewNom;
  Couverture.NewStockee := TGlobalVar.Utilisateur.Options.ImagesStockees;
  Couverture.OldStockee := Couverture.NewStockee;
  Couverture.Categorie := TypeImage;
  Couverture.sCategorie := TDaoListe.ListTypesImage.Values[IntToStr(TypeImage)];
end;

end.
