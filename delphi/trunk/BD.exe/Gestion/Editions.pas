unit Editions;

interface

uses
  SysUtils, Windows, Dialogs, DB, DBCtrls, Forms, Controls, ComCtrls, Classes, LoadComplet;

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
function EditionAuteur(const ID: TGUID; Creation: Boolean = False; const Auteur: string = ''): Boolean;
function DelAuteur(const ID: TGUID): Boolean;

function CreationEmprunteur(const Emprunteur: string): TGUID;
function EditionEmprunteur(const ID: TGUID; Creation: Boolean = False; const Emprunteur: string = ''): Boolean;
function DelEmprunteur(const ID: TGUID): Boolean;

function CreationSerie(const Valeur: string): TGUID; overload;
function CreationSerie(Source: TObjetComplet): TGUID; overload;
function EditionSerie(const ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function EditionSerie(Source: TObjetComplet): Boolean; overload;
function DelSerie(const ID: TGUID): Boolean;

function CreationParaBD(const Valeur: string): TGUID;
function EditionParaBD(const ID: TGUID; Creation: Boolean; const Valeur: string; Achat: Boolean): Boolean; overload;
function EditionParaBD(const ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function DelParaBD(const ID: TGUID): Boolean;

function CreationAchatParaBD(const Valeur: string): TGUID;
function EditionAchatParaBD(const ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean;
function DelAchatParaBD(const ID: TGUID): Boolean;

implementation

uses
  UIB, Commun, UfrmEditAlbum, UfrmEditSerie, UfrmEditEmprunteur, Textes, UfrmEditEditeur, UdmPrinc,
  Math, UfrmFond, Procedures, ProceduresBDtk, UfrmEditCollection, UfrmEditAuteur, UfrmEditParaBD,
  UfrmEditAchatAlbum;

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

//**********************************************************************************************
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

//**********************************************************************************************

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
    f.Album := TAlbumComplet(Source);
    hg := nil;
    Result := frmFond.SetModalChildForm(f) = mrOk;
  finally
    f.Free;
  end;
end;

function EditionAchatAlbum(const ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
var
  Album: TAlbumComplet;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditAlbum) then
    Exit;
  if not Creation and not FindRec('ALBUMS', 'ID_Album', ID, True) then
    Exit;
  Album := TAlbumComplet.Create(ID);
  try
    if Creation then
      Album.Titre := Valeur;
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
//**********************************************************************************************

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
    f.Album := TAlbumComplet(Source);
    hg := nil;
    Result := frmFond.SetModalChildForm(f) = mrOk;
  finally
    f.Free;
  end;
end;

function EditionAlbum(const ID: TGUID; Creation: Boolean; const Valeur: string; Achat: Boolean): Boolean; overload;
var
  Album: TAlbumComplet;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditAlbum) then
    Exit;
  if not Creation and not FindRec('ALBUMS', 'ID_Album', ID, True) then
    Exit;
  Album := TAlbumComplet.Create(ID);
  try
    if Creation then
      Album.Titre := Valeur;
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
//**********************************************************************************************

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
    f.Serie := TSerieComplete(Source);
    hg := nil;
    Result := frmFond.SetModalChildForm(f) = mrOk;
  finally
    f.Free;
  end;
end;

function EditionSerie(const ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
var
  Serie: TSerieComplete;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditEditeur) then
    Exit;
  if not Creation and not FindRec('SERIES', 'ID_Serie', ID, True) then
    Exit;
  Serie := TSerieComplete.Create(ID);
  try
    if Creation then
      Serie.Titre := Valeur;
    Result := EditionSerie(Serie);
  finally
    Serie.Free;
  end;
end;

function DelSerie(const ID: TGUID): Boolean;
begin
  Result := DelLambda('SERIES', 'ID_Serie', ID);
end;
//**********************************************************************************************

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
    f.Editeur := TEditeurComplet(Source);
    hg := nil;
    Result := frmFond.SetModalChildForm(f) = mrOk;
  finally
    f.Free;
  end;
end;

function EditionEditeur(const ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
var
  Editeur: TEditeurComplet;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditEditeur) then
    Exit;
  if not Creation and not FindRec('EDITEURS', 'ID_Editeur', ID, True) then
    Exit;
  Editeur := TEditeurComplet.Create(ID);
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
//*************************************************************************************************************************

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
    f.Collection := TCollectionComplete(Source);
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
  Collection: TCollectionComplete;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditCollection) then
    Exit;
  if not Creation and not FindRec('COLLECTIONS', 'ID_Collection', ID, True) then
    Exit;
  Collection := TCollectionComplete.Create(ID);
  try
    if Creation then
    begin
      Collection.NomCollection := Valeur;
      Collection.Editeur.Fill(ID_Editeur);
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
//************************************************************************************************************************

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
//**********************************************************************************************

function CreationAuteur(const Auteur: string): TGUID;
begin
  Result := CreationLambdaChampSimple(Textes.rsAuteur, 'PERSONNES', 'NomPersonne', 'ID_Personne', Auteur);
end;

function CreationAuteur2(const Auteur: string): TGUID;
begin
  Result := CreationLambda(EditionAuteur, Auteur, TFrmEditAuteur);
end;

function EditionAuteur(const ID: TGUID; Creation: Boolean; const Auteur: string): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditAuteur;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditAuteur) then
    Exit;
  if not Creation and not FindRec('Personnes', 'ID_Personne', ID, True) then
    Exit;
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditAuteur.Create(Application);
  with f do
    try
      ID_Auteur := ID;
      if Creation then
        edNom.Text := Auteur;
      hg := nil;
      Result := frmFond.SetModalChildForm(f) = mrOk;
    finally
      Free;
    end;
end;

function DelAuteur(const ID: TGUID): Boolean;
begin
  Result := DelLambda('PERSONNES', 'ID_Personne', ID);
end;
//**********************************************************************************************

function CreationEmprunteur(const Emprunteur: string): TGUID;
begin
  Result := CreationLambda(EditionEmprunteur, Emprunteur, TFrmEditEmprunteur);
end;

function EditionEmprunteur(const ID: TGUID; Creation: Boolean; const Emprunteur: string): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditEmprunteur;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditEmprunteur) then
    Exit;
  if not Creation and not FindRec('Emprunteurs', 'ID_Emprunteur', ID, True) then
    Exit;
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditEmprunteur.Create(Application);
  with f do
    try
      ID_Emprunteur := ID;
      if Creation then
        edNom.Text := Emprunteur;
      hg := nil;
      Result := frmFond.SetModalChildForm(f) = mrOk;
    finally
      Free;
    end;
end;

function DelEmprunteur(const ID: TGUID): Boolean;
begin
  Result := DelLambda('Emprunteurs', 'ID_Emprunteur', ID);
end;
//**********************************************************************************************

function CreationParaBD(const Valeur: string): TGUID;
begin
  Result := CreationLambda(EditionParaBD, Valeur, TFrmEditParaBD);
end;

function EditionParaBD(const ID: TGUID; Creation: Boolean; const Valeur: string; Achat: Boolean): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditParaBD;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditParaBD) then
    Exit;
  if not Creation and not FindRec('ParaBD', 'ID_ParaBD', ID, True) then
    Exit;
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditParaBD.Create(Application);
  with f do
    try
      isAchat := Achat;
      ID_ParaBD := ID;
      if Creation then
        edTitre.Text := Valeur;
      hg := nil;
      Result := frmFond.SetModalChildForm(f) = mrOk;
    finally
      Free;
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
//**********************************************************************************************

function CreationAchatParaBD(const Valeur: string): TGUID;
begin
  Result := CreationLambda(EditionAchatParaBD, Valeur, TFrmEditParaBD);
end;

function EditionAchatParaBD(const ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditParaBD;
begin
  Result := False;
  if frmFond.IsShowing(TFrmEditAchatParaBD) then
    Exit;
  if not Creation and not FindRec('ParaBD', 'ID_ParaBD', ID, True) then
    Exit;
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditAchatParaBD.Create(Application);
  with f do
    try
      ID_ParaBD := ID;
      if Creation then
        edTitre.Text := Valeur;
      hg := nil;
      Result := frmFond.SetModalChildForm(f) = mrOk;
    finally
      Free;
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
//**********************************************************************************************
end.

