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
function EditionAchatAlbum(var ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function EditionAchatAlbum(Source: TObjetFull): Boolean; overload;
function DelAchatAlbum(const ID: TGUID): Boolean;

function CreationAlbum(const Valeur: string): TGUID; overload;
function CreationAlbum(Source: TObjetFull): TGUID; overload;
function EditionAlbum(var ID: TGUID; Creation: Boolean; const Valeur: string; Achat: Boolean): Boolean; overload;
function EditionAlbum(var ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function EditionAlbum(Source: TObjetFull; Achat: Boolean): Boolean; overload;
function EditionAlbum(Source: TObjetFull): Boolean; overload;
function DelAlbum(const ID: TGUID): Boolean;

function CreationEditeur(const Valeur: string): TGUID; overload;
function CreationEditeur(Source: TObjetFull): TGUID; overload;
function EditionEditeur(var ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function EditionEditeur(Source: TObjetFull): Boolean; overload;
function DelEditeur(const ID: TGUID): Boolean;

function CreationCollection(const ID_Editeur: TGUID; const Valeur: string): TGUID; overload;
function CreationCollection(Source: TObjetFull): TGUID; overload;
function EditionCollection(var ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function EditionCollection(var ID: TGUID; const ID_Editeur: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function EditionCollection(Source: TObjetFull): Boolean; overload;
function DelCollection(const ID: TGUID): Boolean;

function CreationGenre(const Genre: string; Source: TObjetFull = nil): TGUID;
function EditionGenre(var ID: TGUID): Boolean;
function DelGenre(const ID: TGUID): Boolean;

function CreationAuteur(const Auteur: string): TGUID;
function CreationAuteur2(const Auteur: string): TGUID;
function EditionAuteur(var ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function EditionAuteur(Source: TObjetFull): Boolean; overload;
function DelAuteur(const ID: TGUID): Boolean;

function CreationUnivers(const Valeur: string): TGUID; overload;
function CreationUnivers(Source: TObjetFull): TGUID; overload;
function EditionUnivers(var ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function EditionUnivers(Source: TObjetFull): Boolean; overload;
function DelUnivers(const ID: TGUID): Boolean;

function CreationSerie(const Valeur: string): TGUID; overload;
function CreationSerie(Source: TObjetFull): TGUID; overload;
function EditionSerie(var ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function EditionSerie(Source: TObjetFull): Boolean; overload;
function DelSerie(const ID: TGUID): Boolean;

function CreationParaBD(const Valeur: string): TGUID;
function EditionParaBD(var ID: TGUID; Creation: Boolean; const Valeur: string; Achat: Boolean): Boolean; overload;
function EditionParaBD(var ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function EditionParaBD(Source: TObjetFull; Achat: Boolean): Boolean; overload;
function EditionParaBD(Source: TObjetFull): Boolean; overload;
function DelParaBD(const ID: TGUID): Boolean;

function CreationAchatParaBD(const Valeur: string): TGUID;
function EditionAchatParaBD(var ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function EditionAchatParaBD(Source: TObjetFull): Boolean; overload;
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
      Transaction := GetTransaction(dmPrinc.UIBDataBase);
      SQL.Text := Format('select %s from %s where %s = ?', [Champ, Table, Champ]);
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
  TLambdaEdition = function(var ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
  TLambdaEditionSrc = function(Source: TObjetFull): Boolean;
  TLambdaEdition2 = function(var ID: TGUID; const Reference2: TGUID; Creation: Boolean; const Valeur: string): Boolean;

function CreationLambda(LambdaEdition: TLambdaEdition; const Valeur: string; Fenetre: TFormClass): TGUID; overload;
begin
  Result := GUID_NULL;
  if frmFond.IsShowing(Fenetre) then
    Exit;
  if not LambdaEdition(Result, True, Valeur) then
    Result := GUID_NULL;
end;

function CreationLambda(LambdaEdition: TLambdaEditionSrc; Source: TObjetFull; Fenetre: TFormClass): TGUID; overload;
begin
  Result := Source.ID;
  if frmFond.IsShowing(Fenetre) then
    Exit;
  LambdaEdition(Source);
  Result := Source.ID;
end;

function CreationLambda(LambdaEdition: TLambdaEdition2; const Reference2: TGUID; const Valeur: string; Fenetre: TFormClass): TGUID; overload;
begin
  Result := GUID_NULL;
  if frmFond.IsShowing(Fenetre) then
    Exit;
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
        Transaction := GetTransaction(dmPrinc.UIBDataBase);
        SQL.Text := Format('select %s from %s where %s = ?', [ChampRef, Table, Champ]);
        Prepare(True);
        Params.AsString[0] := Copy(Chaine, 1, Params.MaxStrLen[0]);
        Open;
        if not Eof then
          raise Exception.CreateFmt(rsTitreStillUsed, [TypeInfo]);

        Params.Clear;
        SQL.Text := Format('insert into %s (%s) values (?) returning %s', [Table, Champ, ChampRef]);
        Prepare(True);
        Params.AsString[0] := Copy(Chaine, 1, Params.MaxStrLen[0]);
        Execute;
        Result := StringToGUID(Fields.AsString[0]);
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

function EditionLambdaChampSimple(const TypeInfo, Table, Champ, ChampRef: string; Reference: TGUID): Boolean;
var
  Chaine: string;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  Result := False;
  with TUIBQuery.Create(nil) do
    try
      try
        Transaction := GetTransaction(dmPrinc.UIBDataBase);

        SQL.Text := Format('select %s from %s where %s = ?', [Champ, Table, ChampRef]);
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
        SQL.Text := Format('select %s from %s where %s = ? and %s <> ?', [ChampRef, Table, Champ, ChampRef]);
        Prepare(True);
        Params.AsString[0] := Copy(Chaine, 1, Params.MaxStrLen[0]);
        Params.AsString[1] := GUIDToString(Reference);
        Open;
        if not Eof then
          raise Exception.CreateFmt(rsTitreStillUsed, [TypeInfo]);

        SQL.Text := Format('update %s set %s = ? where %s = ?', [Table, Champ, ChampRef]);
        Prepare(True);
        Params.AsString[0] := Copy(Chaine, 1, Params.MaxStrLen[0]);
        Params.AsString[1] := GUIDToString(Reference);
        Execute;
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
      Transaction := GetTransaction(dmPrinc.UIBDataBase);
      SQL.Text := Format('delete from %s where %s=?', [Table, Champ]);
      Params.AsString[0] := GUIDToString(Ref);
      try
        Execute;
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

function EditionAchatAlbum(Source: TObjetFull): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditAchatAlbum;
begin
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditAchatAlbum.Create(Application);
  try
    f.Album := Source as TAlbumFull;
    hg := nil;
    Result := frmFond.SetModalChildForm(f) = mrOk;
  finally
    f.Free;
  end;
end;

function EditionAchatAlbum(var ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
var
  Album: TAlbumFull;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditAlbum) then
    Exit;
  Album := TDaoAlbumFull.getInstance(ID);
  try
    if Creation then
      Album.TitreAlbum := Valeur;
    Result := EditionAchatAlbum(Album);
    ID := Album.ID_Album;
  finally
    Album.Free;
  end;
end;

function DelAchatAlbum(const ID: TGUID): Boolean;
begin
  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(dmPrinc.UIBDataBase);
      SQL.Text := 'select complet from albums where id_album = ?';
      Params.AsString[0] := GUIDToString(ID);
      Open;
      if Fields.AsInteger[0] = 1 then
      begin
        SQL.Text := 'update albums set achat = 0 where id_album = ?';
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

function CreationAlbum(Source: TObjetFull): TGUID;
begin
  Result := CreationLambda(EditionAlbum, Source, TFrmEditAlbum);
end;

function CreationAlbum(const Valeur: string): TGUID;
begin
  Result := CreationLambda(EditionAlbum, Valeur, TFrmEditAlbum);
end;

function EditionAlbum(Source: TObjetFull): Boolean; overload;
begin
  Result := EditionAlbum(Source, False);
end;

function EditionAlbum(Source: TObjetFull; Achat: Boolean): Boolean; overload;
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
    f.Album := Source as TAlbumFull;
    hg := nil;
    Result := frmFond.SetModalChildForm(f) = mrOk;
  finally
    f.Free;
  end;
end;

function EditionAlbum(var ID: TGUID; Creation: Boolean; const Valeur: string; Achat: Boolean): Boolean; overload;
var
  Album: TAlbumFull;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditAlbum) then
    Exit;
  Album := TDaoAlbumFull.getInstance(ID);
  try
    if Creation then
      Album.TitreAlbum := Valeur;
    Result := EditionAlbum(Album, Achat);
    ID := Album.ID_Album;
  finally
    Album.Free;
  end;
end;

function EditionAlbum(var ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
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

function CreationSerie(Source: TObjetFull): TGUID;
begin
  Result := CreationLambda(EditionSerie, Source, TFrmEditSerie);
end;

function EditionSerie(Source: TObjetFull): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditSerie;
begin
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditSerie.Create(Application);
  try
    f.Serie := Source as TSerieFull;
    hg := nil;
    Result := frmFond.SetModalChildForm(f) = mrOk;
  finally
    f.Free;
  end;
end;

function EditionSerie(var ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
var
  Serie: TSerieFull;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditSerie) then
    Exit;
  Serie := TDaoSerieFull.getInstance(ID);
  try
    if Creation then
      Serie.TitreSerie := Valeur;
    Result := EditionSerie(Serie);
    ID := Serie.ID_Serie;
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

function CreationUnivers(Source: TObjetFull): TGUID; overload;
begin
  Result := CreationLambda(EditionUnivers, Source, TFrmEditUnivers);
end;

function EditionUnivers(Source: TObjetFull): Boolean; overload;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditUnivers;
begin
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditUnivers.Create(Application);
  try
    f.Univers := Source as TUniversFull;
    hg := nil;
    Result := frmFond.SetModalChildForm(f) = mrOk;
  finally
    f.Free;
  end;
end;

function EditionUnivers(var ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
var
  Univers: TUniversFull;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditUnivers) then
    Exit;
  Univers := TDaoUniversFull.getInstance(ID);
  try
    if Creation then
      Univers.NomUnivers := Valeur;
    Result := EditionUnivers(Univers);
    ID := Univers.ID_Univers;
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

function CreationEditeur(Source: TObjetFull): TGUID;
begin
  Result := CreationLambda(EditionEditeur, Source, TFrmEditEditeur);
end;

function EditionEditeur(Source: TObjetFull): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditEditeur;
begin
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditEditeur.Create(Application);
  try
    f.Editeur := Source as TEditeurFull;
    hg := nil;
    Result := frmFond.SetModalChildForm(f) = mrOk;
  finally
    f.Free;
  end;
end;

function EditionEditeur(var ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
var
  Editeur: TEditeurFull;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditEditeur) then
    Exit;
  Editeur := TDaoEditeurFull.getInstance(ID);
  try
    if Creation then
      Editeur.NomEditeur := Valeur;
    Result := EditionEditeur(Editeur);
    ID := Editeur.ID_Editeur;
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

function CreationCollection(Source: TObjetFull): TGUID;
begin
  Result := CreationLambda(EditionCollection, Source, TFrmEditCollection);
end;

function EditionCollection(Source: TObjetFull): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditCollection;
begin
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditCollection.Create(Application);
  try
    f.Collection := Source as TCollectionFull;
    hg := nil;
    Result := frmFond.SetModalChildForm(f) = mrOk;
  finally
    f.Free;
  end;
end;

function EditionCollection(var ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
begin
  Result := EditionCollection(ID, GUID_NULL, Creation, Valeur);
end;

function EditionCollection(var ID: TGUID; const ID_Editeur: TGUID; Creation: Boolean; const Valeur: string): Boolean;
var
  Collection: TCollectionFull;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditCollection) then
    Exit;
  Collection := TDaoCollectionFull.getInstance(ID);
  try
    if Creation then
    begin
      Collection.NomCollection := Valeur;
      TDaoEditeurLite.Fill(Collection.Editeur, ID_Editeur);
    end;
    Result := EditionCollection(Collection);
    ID := Collection.ID_Collection;
  finally
    Collection.Free;
  end;
end;

function DelCollection(const ID: TGUID): Boolean;
begin
  Result := DelLambda('COLLECTIONS', 'ID_Collection', ID);
end;
// ************************************************************************************************************************

function CreationGenre(const Genre: string; Source: TObjetFull = nil): TGUID;
begin
  Result := CreationLambdaChampSimple(Textes.rsGenre, 'GENRES', 'Genre', 'ID_Genre', Genre);
end;

function EditionGenre(var ID: TGUID): Boolean;
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

function EditionAuteur(Source: TObjetFull): Boolean; overload;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditAuteur;
begin
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditAuteur.Create(Application);
  try
    f.Auteur := Source as TAuteurFull;
    hg := nil;
    Result := frmFond.SetModalChildForm(f) = mrOk;
  finally
    f.Free;
  end;
end;

function EditionAuteur(var ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
var
  Auteur: TAuteurFull;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditAuteur) then
    Exit;
  Auteur := TDaoAuteurFull.getInstance(ID);
  try
    if Creation then
      Auteur.NomAuteur := Valeur;
    Result := EditionAuteur(Auteur);
    ID := Auteur.ID_Auteur;
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

function EditionParaBD(Source: TObjetFull): Boolean; overload;
begin
  Result := EditionParaBD(Source, False);
end;

function EditionParaBD(Source: TObjetFull; Achat: Boolean): Boolean; overload;
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
    f.ParaBD := Source as TParaBDFull;
    hg := nil;
    Result := frmFond.SetModalChildForm(f) = mrOk;
  finally
    f.Free;
  end;
end;

function EditionParaBD(var ID: TGUID; Creation: Boolean; const Valeur: string; Achat: Boolean): Boolean; overload;
var
  ParaBD: TParaBDFull;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditParaBD) then
    Exit;
  ParaBD := TDaoParaBDFull.getInstance(ID);
  try
    if Creation then
      ParaBD.TitreParaBD := Valeur;
    Result := EditionParaBD(ParaBD, Achat);
    ID := ParaBD.ID_ParaBD;
  finally
    ParaBD.Free;
  end;
end;

function EditionParaBD(var ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
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

function EditionAchatParaBD(Source: TObjetFull): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditAchatParaBD;
begin
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditAchatParaBD.Create(Application);
  try
    f.ParaBD := Source as TParaBDFull;
    hg := nil;
    Result := frmFond.SetModalChildForm(f) = mrOk;
  finally
    f.Free;
  end;
end;

function EditionAchatParaBD(var ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
var
  ParaBD: TParaBDFull;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditParaBD) then
    Exit;
  ParaBD := TDaoParaBDFull.getInstance(ID);
  try
    if Creation then
      ParaBD.TitreParaBD := Valeur;
    Result := EditionAchatParaBD(ParaBD);
    ID := ParaBD.ID_ParaBD;
  finally
    ParaBD.Free;
  end;
end;

function DelAchatParaBD(const ID: TGUID): Boolean;
begin
  with TUIBQuery.Create(nil) do
    try
      Transaction := GetTransaction(dmPrinc.UIBDataBase);
      SQL.Text := 'select complet from parabd where id_parabd = ?';
      Params.AsString[0] := GUIDToString(ID);
      Open;
      if Fields.AsInteger[0] = 1 then
      begin
        SQL.Text := 'update parabd set achat = 0 where id_parabd = ?';
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
