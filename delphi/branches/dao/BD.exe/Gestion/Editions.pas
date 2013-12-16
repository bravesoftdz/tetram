unit Editions;

interface

uses
  SysUtils, Windows, Dialogs, DB, DBCtrls, Forms, Controls, ComCtrls, Classes, EntitiesFull;

{
  Principes de base:
  * Creation
  - ouvre une transaction
  - renseigne les valeur par défaut
  - appel la proc d'edition

  * Edition
  - reprend ou ouvre une transaction
  - modifie l'enregistrement
  - ferme la transaction

  * Del
  - ouvre une transaction
  - efface l'enregistrement
  - ferme la transaction

  Cas des tables à champ unique
  * Creation
  - ouvre une transaction
  - renseigne les valeur par défaut
  - ferme la transaction

  * Edition
  - ouvre une transaction
  - modifie l'enregistrement
  - ferme la transaction

  * Del
  - ouvre une transaction
  - efface l'enregistrement
  - ferme la transaction

}

function CreationAchatAlbum(const Valeur: string): TGUID;
function EditionAchatAlbum(const ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function EditionAchatAlbum(Source: TObjetComplet): Boolean; overload;
function DelAchatAlbum(const ID: TGUID): Boolean;

function CreationAlbum(const Valeur: string): TGUID; overload;
function CreationAlbum(Source: TObjetComplet): TGUID; overload;
function EditionAlbum(const ID: TGUID; Creation: Boolean; const Valeur: string; Achat: Boolean): Boolean; overload;
function EditionAlbum(const ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function EditionAlbum(Source: TObjetComplet; Achat: Boolean): Boolean; overload;
function EditionAlbum(Source: TObjetComplet): Boolean; overload;
function DelAlbum(const ID: TGUID): Boolean;

function CreationEditeur(const Valeur: string): TGUID; overload;
function CreationEditeur(Source: TObjetComplet): TGUID; overload;
function EditionEditeur(const ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function EditionEditeur(Source: TObjetComplet): Boolean; overload;
function DelEditeur(const ID: TGUID): Boolean;

function CreationCollection(const ID_Editeur: TGUID; const Valeur: string): TGUID; overload;
function CreationCollection(Source: TObjetComplet): TGUID; overload;
function EditionCollection(const ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function EditionCollection(const ID: TGUID; const ID_Editeur: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function EditionCollection(Source: TObjetComplet): Boolean; overload;
function DelCollection(const ID: TGUID): Boolean;

function CreationGenre(const Genre: string; Source: TObjetComplet = nil): TGUID;
function EditionGenre(const ID: TGUID): Boolean;
function DelGenre(const ID: TGUID): Boolean;

function CreationAuteur(const Auteur: string): TGUID;
function CreationAuteur2(const Auteur: string): TGUID;
function EditionAuteur(const ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function EditionAuteur(Source: TObjetComplet): Boolean; overload;
function DelAuteur(const ID: TGUID): Boolean;

function CreationUnivers(const Valeur: string): TGUID; overload;
function CreationUnivers(Source: TObjetComplet): TGUID; overload;
function EditionUnivers(const ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function EditionUnivers(Source: TObjetComplet): Boolean; overload;
function DelUnivers(const ID: TGUID): Boolean;

function CreationSerie(const Valeur: string): TGUID; overload;
function CreationSerie(Source: TObjetComplet): TGUID; overload;
function EditionSerie(const ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function EditionSerie(Source: TObjetComplet): Boolean; overload;
function DelSerie(const ID: TGUID): Boolean;

function CreationParaBD(const Valeur: string): TGUID;
function EditionParaBD(const ID: TGUID; Creation: Boolean; const Valeur: string; Achat: Boolean): Boolean; overload;
function EditionParaBD(const ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function EditionParaBD(Source: TObjetComplet; Achat: Boolean): Boolean; overload;
function EditionParaBD(Source: TObjetComplet): Boolean; overload;
function DelParaBD(const ID: TGUID): Boolean;

function CreationAchatParaBD(const Valeur: string): TGUID;
function EditionAchatParaBD(const ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function EditionAchatParaBD(Source: TObjetComplet): Boolean; overload;
function DelAchatParaBD(const ID: TGUID): Boolean;

implementation

uses
  UIB, Commun, UfrmEditAlbum, UfrmEditSerie, Textes, UfrmEditEditeur, UdmPrinc,
  Math, UfrmFond, Procedures, ProceduresBDtk, UfrmEditCollection, UfrmEditAuteur, UfrmEditParaBD,
  UfrmEditAchatAlbum, UfrmEditUnivers, DaoLite, DaoFull;

function FindRec(const Table, Champ: string; const Reference: TGUID; WithMessage: Boolean): Boolean;
begin
  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := Format('SELECT %s FROM %s WHERE %s = ?', [Champ, Table, Champ]);
      Params.AsString[0] := GUIDToString(Reference);
      Open;
      Result := not Eof;
      if not Result and WithMessage then
        AffMessage(rsErrorFindEnr, mtConfirmation, [mbOk], True);
    finally
      Transaction.Free;
      Free;
    end;
end;

// **********************************************************************************************
type
  TLambdaEdition = function(const ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
  TLambdaEditionSrc = function(Source: TObjetComplet): Boolean;
  TLambdaEdition2 = function(const ID: TGUID; const Reference2: TGUID; Creation: Boolean; const Valeur: string): Boolean;

function CreationLambda(LambdaEdition: TLambdaEdition; const Valeur: string; Fenetre: TFormClass): TGUID; overload;
begin
  Result := GUID_NULL;
  if frmFond.IsShowing(Fenetre) then
    Exit;
  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'select udf_createguid() from rdb$database';
      Open;
      Result := StringToGUID(Fields.AsString[0]);
    finally
      Transaction.Free;
      Free;
    end;
  if not LambdaEdition(Result, True, Valeur) then
    Result := GUID_NULL;
end;

function CreationLambda(LambdaEdition: TLambdaEditionSrc; Source: TObjetComplet; Fenetre: TFormClass): TGUID; overload;
begin
  Result := Source.ID;
  if frmFond.IsShowing(Fenetre) then
    Exit;
  if IsEqualGUID(Result, GUID_NULL) then
  begin
    Source.New(False);
    Result := Source.ID;
  end;

  if not LambdaEdition(Source) then
    Result := GUID_NULL;
end;

function CreationLambda(LambdaEdition: TLambdaEdition2; const Reference2: TGUID; const Valeur: string; Fenetre: TFormClass): TGUID; overload;
begin
  Result := GUID_NULL;
  if frmFond.IsShowing(Fenetre) then
    Exit;
  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'select udf_createguid() from rdb$database';
      Open;
      Result := StringToGUID(Fields.AsString[0]);
    finally
      Transaction.Free;
      Free;
    end;
  if not LambdaEdition(Result, Reference2, True, Valeur) then
    Result := GUID_NULL;
end;

function CreationLambdaChampSimple(const TypeInfo, Table, Champ, ChampRef, ValeurDefaut: string): TGUID;
var
  Chaine: string;
  hg: IHourGlass;
begin
  Result := GUID_NULL;
  Chaine := ValeurDefaut;
  if (not InputQuery(Format(rsNewTitre, [TypeInfo]), Format(rsEntrerNewTitre, [TypeInfo]), Chaine)) then
    Exit;
  Chaine := Trim(Chaine);
  if (Chaine = '') then
    Exit;
  hg := THourGlass.Create;
  with TUIBQuery.Create(nil) do
    try
      try
        Transaction := GetTransaction(DMPrinc.UIBDataBase);
        SQL.Text := Format('SELECT %s FROM %s WHERE %s = ?', [ChampRef, Table, Champ]);
        Prepare(True);
        Params.AsString[0] := Copy(Chaine, 1, Params.MaxStrLen[0]);
        Open;
        if not Eof then
          raise Exception.CreateFmt(rsTitreStillUsed, [TypeInfo]);

        SQL.Text := 'select udf_createguid() from rdb$database';
        Open;
        Result := StringToGUID(Fields.AsString[0]);

        Params.Clear;
        SQL.Text := Format('INSERT INTO %s (%s, %s) VALUES (?, ?)', [Table, ChampRef, Champ]);
        Prepare(True);
        Params.AsString[0] := GUIDToString(Result);
        Params.AsString[1] := Copy(Chaine, 1, Params.MaxStrLen[1]);
        ExecSQL;
        Transaction.Commit;
      except
        Transaction.Rollback;
        AffMessage(rsErrorCreerEnr + #13#13 + Exception(ExceptObject).Message, mtInformation, [mbOk], True);
        Result := GUID_NULL;
      end;
    finally
      Transaction.Free;
      Free;
    end;
end;

function EditionLambdaChampSimple(const TypeInfo, Table, Champ, ChampRef: string; const Reference: TGUID): Boolean;
var
  Chaine: string;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  Result := False;
  with TUIBQuery.Create(nil) do
    try
      try
        Transaction := GetTransaction(DMPrinc.UIBDataBase);

        SQL.Text := Format('SELECT %s FROM %s WHERE %s = ?', [Champ, Table, ChampRef]);
        Params.AsString[0] := GUIDToString(Reference);
        Open;
        if Eof then
          raise Exception.Create(rsErrorFindEnr);
        Chaine := Fields.AsString[0];

        if not InputQuery(Format(rsNewTitre, [TypeInfo]), Format(rsEntrerModifyTitre, [TypeInfo]), Chaine) then
          Exit;
        Chaine := Trim(Chaine);
        if Chaine = '' then
          Exit;

        Params.Clear;
        SQL.Text := Format('SELECT %s FROM %s WHERE %s = ? AND %s <> ?', [ChampRef, Table, Champ, ChampRef]);
        Prepare(True);
        Params.AsString[0] := Copy(Chaine, 1, Params.MaxStrLen[0]);
        Params.AsString[1] := GUIDToString(Reference);
        Open;
        if not Eof then
          raise Exception.CreateFmt(rsTitreStillUsed, [TypeInfo]);

        SQL.Text := Format('UPDATE %s SET %s = ? WHERE %s = ?', [Table, Champ, ChampRef]);
        Prepare(True);
        Params.AsString[0] := Copy(Chaine, 1, Params.MaxStrLen[0]);
        Params.AsString[1] := GUIDToString(Reference);
        ExecSQL;
        Transaction.Commit;
        Result := True;
      except
        Transaction.Rollback;
        AffMessage(rsErrorModifEnr + #13#13 + Exception(ExceptObject).Message, mtInformation, [mbOk], True);
        Result := False;
      end;
    finally
      Transaction.Free;
      Free;
    end;
end;

function DelLambda(const Table, Champ: string; const Ref: TGUID): Boolean;
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  Result := False;
  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := Format('DELETE FROM %s WHERE %s=?', [Table, Champ]);
      Params.AsString[0] := GUIDToString(Ref);
      try
        ExecSQL;
        Transaction.Commit;
        Result := True;
      except
        Transaction.Rollback;
        AffMessage(rsErrorSuppEnr + #13#13 + Exception(ExceptObject).Message, mtInformation, [mbOk], True);
      end;
    finally
      Transaction.Free;
      Free;
    end;
end;

// **********************************************************************************************

function CreationAchatAlbum(const Valeur: string): TGUID;
begin
  Result := CreationLambda(EditionAchatAlbum, Valeur, TFrmEditAchatAlbum);
end;

function EditionAchatAlbum(Source: TObjetComplet): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditAchatAlbum;
begin
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditAchatAlbum.Create(Application);
  try
    f.Album := TAlbumFull(Source);
    hg := nil;
    Result := frmFond.SetModalChildForm(f) = mrOk;
  finally
    f.Free;
  end;
end;

function EditionAchatAlbum(const ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
var
  Album: TAlbumFull;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditAlbum) then
    Exit;
  if not Creation and not FindRec('ALBUMS', 'ID_Album', ID, True) then
    Exit;
  Album := TDaoAlbumFull.getInstance(ID);
  try
    if Creation then
      Album.TitreAlbum := Valeur;
    Result := EditionAchatAlbum(Album);
  finally
    Album.Free;
  end;
end;

function DelAchatAlbum(const ID: TGUID): Boolean;
begin
  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'SELECT COMPLET FROM ALBUMS WHERE ID_Album = ?';
      Params.AsString[0] := GUIDToString(ID);
      Open;
      if Fields.AsInteger[0] = 1 then
      begin
        SQL.Text := 'UPDATE ALBUMS SET ACHAT = 0 WHERE ID_Album = ?';
        Params.AsString[0] := GUIDToString(ID);
        Execute;
        Result := True;
      end
      else
        Result := DelAlbum(ID);
    finally
      Transaction.Free;
      Free;
    end;
end;
// **********************************************************************************************

function CreationAlbum(Source: TObjetComplet): TGUID;
begin
  Result := CreationLambda(EditionAlbum, Source, TFrmEditAlbum);
end;

function CreationAlbum(const Valeur: string): TGUID;
begin
  Result := CreationLambda(EditionAlbum, Valeur, TFrmEditAlbum);
end;

function EditionAlbum(Source: TObjetComplet): Boolean; overload;
begin
  Result := EditionAlbum(Source, False);
end;

function EditionAlbum(Source: TObjetComplet; Achat: Boolean): Boolean; overload;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditAlbum;
begin
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditAlbum.Create(Application);
  try
    f.isAchat := Achat;
    f.Album := TAlbumFull(Source);
    hg := nil;
    Result := frmFond.SetModalChildForm(f) = mrOk;
  finally
    f.Free;
  end;
end;

function EditionAlbum(const ID: TGUID; Creation: Boolean; const Valeur: string; Achat: Boolean): Boolean; overload;
var
  Album: TAlbumFull;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditAlbum) then
    Exit;
  if not Creation and not FindRec('ALBUMS', 'ID_Album', ID, True) then
    Exit;
  Album := TDaoAlbumFull.getInstance(ID);
  try
    if Creation then
      Album.TitreAlbum := Valeur;
    Result := EditionAlbum(Album, Achat);
  finally
    Album.Free;
  end;
end;

function EditionAlbum(const ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
begin
  Result := EditionAlbum(ID, Creation, Valeur, False);
end;

function DelAlbum(const ID: TGUID): Boolean;
begin
  Result := DelLambda('ALBUMS', 'ID_Album', ID);
end;
// **********************************************************************************************

function CreationSerie(const Valeur: string): TGUID;
begin
  Result := CreationLambda(EditionSerie, Valeur, TFrmEditSerie);
end;

function CreationSerie(Source: TObjetComplet): TGUID;
begin
  Result := CreationLambda(EditionSerie, Source, TFrmEditSerie);
end;

function EditionSerie(Source: TObjetComplet): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditSerie;
begin
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditSerie.Create(Application);
  try
    f.Serie := TSerieFull(Source);
    hg := nil;
    Result := frmFond.SetModalChildForm(f) = mrOk;
  finally
    f.Free;
  end;
end;

function EditionSerie(const ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
var
  Serie: TSerieFull;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditSerie) then
    Exit;
  if not Creation and not FindRec('SERIES', 'ID_Serie', ID, True) then
    Exit;
  Serie := TDaoSerieFull.getInstance(ID);
  try
    if Creation then
      Serie.TitreSerie := Valeur;
    Result := EditionSerie(Serie);
  finally
    Serie.Free;
  end;
end;

function DelSerie(const ID: TGUID): Boolean;
begin
  Result := DelLambda('SERIES', 'ID_Serie', ID);
end;
// **********************************************************************************************

function CreationUnivers(const Valeur: string): TGUID; overload;
begin
  Result := CreationLambda(EditionUnivers, Valeur, TFrmEditUnivers);
end;

function CreationUnivers(Source: TObjetComplet): TGUID; overload;
begin
  Result := CreationLambda(EditionUnivers, Source, TFrmEditUnivers);
end;

function EditionUnivers(Source: TObjetComplet): Boolean; overload;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditUnivers;
begin
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditUnivers.Create(Application);
  try
    f.Univers := TUniversFull(Source);
    hg := nil;
    Result := frmFond.SetModalChildForm(f) = mrOk;
  finally
    f.Free;
  end;
end;

function EditionUnivers(const ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
var
  Univers: TUniversFull;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditUnivers) then
    Exit;
  if not Creation and not FindRec('UNIVERS', 'ID_Univers', ID, True) then
    Exit;
  Univers := TDaoUniversFull.getInstance(ID);
  try
    if Creation then
      Univers.NomUnivers := Valeur;
    Result := EditionUnivers(Univers);
  finally
    Univers.Free;
  end;
end;

function DelUnivers(const ID: TGUID): Boolean;
begin
  Result := DelLambda('UNIVERS', 'ID_Univers', ID);
end;
// **********************************************************************************************

function CreationEditeur(const Valeur: string): TGUID;
begin
  Result := CreationLambda(EditionEditeur, Valeur, TFrmEditEditeur);
end;

function CreationEditeur(Source: TObjetComplet): TGUID;
begin
  Result := CreationLambda(EditionEditeur, Source, TFrmEditEditeur);
end;

function EditionEditeur(Source: TObjetComplet): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditEditeur;
begin
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditEditeur.Create(Application);
  try
    f.Editeur := TEditeurFull(Source);
    hg := nil;
    Result := frmFond.SetModalChildForm(f) = mrOk;
  finally
    f.Free;
  end;
end;

function EditionEditeur(const ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
var
  Editeur: TEditeurFull;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditEditeur) then
    Exit;
  if not Creation and not FindRec('EDITEURS', 'ID_Editeur', ID, True) then
    Exit;
  Editeur := TDaoEditeurFull.getInstance(ID);
  try
    if Creation then
      Editeur.NomEditeur := Valeur;
    Result := EditionEditeur(Editeur);
  finally
    Editeur.Free;
  end;
end;

function DelEditeur(const ID: TGUID): Boolean;
begin
  Result := DelLambda('EDITEURS', 'ID_Editeur', ID);
end;
// *************************************************************************************************************************

function CreationCollection(const ID_Editeur: TGUID; const Valeur: string): TGUID;
begin
  Result := CreationLambda(EditionCollection, ID_Editeur, Valeur, TFrmEditCollection);
end;

function CreationCollection(Source: TObjetComplet): TGUID;
begin
  Result := CreationLambda(EditionCollection, Source, TFrmEditCollection);
end;

function EditionCollection(Source: TObjetComplet): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditCollection;
begin
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditCollection.Create(Application);
  try
    f.Collection := TCollectionFull(Source);
    hg := nil;
    Result := frmFond.SetModalChildForm(f) = mrOk;
  finally
    f.Free;
  end;
end;

function EditionCollection(const ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
begin
  Result := EditionCollection(ID, GUID_NULL, Creation, Valeur);
end;

function EditionCollection(const ID: TGUID; const ID_Editeur: TGUID; Creation: Boolean; const Valeur: string): Boolean;
var
  Collection: TCollectionFull;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditCollection) then
    Exit;
  if not Creation and not FindRec('COLLECTIONS', 'ID_Collection', ID, True) then
    Exit;
  Collection := TDaoCollectionFull.getInstance(ID);
  try
    if Creation then
    begin
      Collection.NomCollection := Valeur;
      TDaoEditeurLite.Fill(Collection.Editeur, ID_Editeur);
    end;
    Result := EditionCollection(Collection);
  finally
    Collection.Free;
  end;
end;

function DelCollection(const ID: TGUID): Boolean;
begin
  Result := DelLambda('COLLECTIONS', 'ID_Collection', ID);
end;
// ************************************************************************************************************************

function CreationGenre(const Genre: string; Source: TObjetComplet = nil): TGUID;
begin
  Result := CreationLambdaChampSimple(Textes.rsGenre, 'GENRES', 'Genre', 'ID_Genre', Genre);
end;

function EditionGenre(const ID: TGUID): Boolean;
begin
  Result := EditionLambdaChampSimple(Textes.rsGenre, 'GENRES', 'Genre', 'ID_Genre', ID);
end;

function DelGenre(const ID: TGUID): Boolean;
begin
  Result := DelLambda('Genres', 'ID_Genre', ID);
end;
// **********************************************************************************************

function CreationAuteur(const Auteur: string): TGUID;
begin
  Result := CreationLambdaChampSimple(Textes.rsAuteur, 'PERSONNES', 'NomPersonne', 'ID_Personne', Auteur);
end;

function CreationAuteur2(const Auteur: string): TGUID;
begin
  Result := CreationLambda(EditionAuteur, Auteur, TFrmEditAuteur);
end;

function EditionAuteur(Source: TObjetComplet): Boolean; overload;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditAuteur;
begin
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditAuteur.Create(Application);
  try
    f.Auteur := TAuteurFull(Source);
    hg := nil;
    Result := frmFond.SetModalChildForm(f) = mrOk;
  finally
    f.Free;
  end;
end;

function EditionAuteur(const ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
var
  Auteur: TAuteurFull;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditAuteur) then
    Exit;
  if not Creation and not FindRec('Personnes', 'ID_Personne', ID, True) then
    Exit;
  Auteur := TDaoAuteurFull.getInstance(ID);
  try
    if Creation then
      Auteur.NomAuteur := Valeur;
    Result := EditionAuteur(Auteur);
  finally
    Auteur.Free;
  end;
end;

function DelAuteur(const ID: TGUID): Boolean;
begin
  Result := DelLambda('PERSONNES', 'ID_Personne', ID);
end;
// **********************************************************************************************

function CreationParaBD(const Valeur: string): TGUID;
begin
  Result := CreationLambda(EditionParaBD, Valeur, TFrmEditParaBD);
end;

function EditionParaBD(Source: TObjetComplet): Boolean; overload;
begin
  Result := EditionParaBD(Source, False);
end;

function EditionParaBD(Source: TObjetComplet; Achat: Boolean): Boolean; overload;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditParaBD;
begin
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditParaBD.Create(Application);
  try
    f.isAchat := Achat;
    f.ParaBD := TParaBDFull(Source);
    hg := nil;
    Result := frmFond.SetModalChildForm(f) = mrOk;
  finally
    f.Free;
  end;
end;

function EditionParaBD(const ID: TGUID; Creation: Boolean; const Valeur: string; Achat: Boolean): Boolean; overload;
var
  ParaBD: TParaBDFull;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditParaBD) then
    Exit;
  if not Creation and not FindRec('ParaBD', 'ID_ParaBD', ID, True) then
    Exit;
  ParaBD := TDaoParaBDFull.getInstance(ID);
  try
    if Creation then
      ParaBD.TitreParaBD := Valeur;
    Result := EditionParaBD(ParaBD, Achat);
  finally
    ParaBD.Free;
  end;
end;

function EditionParaBD(const ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
begin
  Result := EditionParaBD(ID, Creation, Valeur, False);
end;

function DelParaBD(const ID: TGUID): Boolean;
begin
  Result := DelLambda('ParaBD', 'ID_ParaBD', ID);
end;
// **********************************************************************************************

function CreationAchatParaBD(const Valeur: string): TGUID;
begin
  Result := CreationLambda(EditionAchatParaBD, Valeur, TFrmEditParaBD);
end;

function EditionAchatParaBD(Source: TObjetComplet): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditAchatParaBD;
begin
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditAchatParaBD.Create(Application);
  try
    f.ParaBD := TParaBDFull(Source);
    hg := nil;
    Result := frmFond.SetModalChildForm(f) = mrOk;
  finally
    f.Free;
  end;
end;

function EditionAchatParaBD(const ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
var
  ParaBD: TParaBDFull;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditParaBD) then
    Exit;
  if not Creation and not FindRec('ParaBD', 'ID_ParaBD', ID, True) then
    Exit;
  ParaBD := TDaoParaBDFull.getInstance(ID);
  try
    if Creation then
      ParaBD.TitreParaBD := Valeur;
    Result := EditionAchatParaBD(ParaBD);
  finally
    ParaBD.Free;
  end;
end;

function DelAchatParaBD(const ID: TGUID): Boolean;
begin
  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := 'SELECT COMPLET FROM ParaBD WHERE ID_ParaBD = ?';
      Params.AsString[0] := GUIDToString(ID);
      Open;
      if Fields.AsInteger[0] = 1 then
      begin
        SQL.Text := 'UPDATE ParaBD SET ACHAT = 0 WHERE ID_ParaBD = ?';
        Params.AsString[0] := GUIDToString(ID);
        Execute;
        Result := True;
      end
      else
        Result := DelParaBD(ID);
    finally
      Transaction.Free;
      Free;
    end;
end;

// **********************************************************************************************
end.
