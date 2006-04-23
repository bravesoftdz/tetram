unit Editions;

interface

uses
  SysUtils, Windows, Dialogs, DB, DBCtrls, Forms, Controls, ComCtrls, Classes;

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
function EditionAchatAlbum(var ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean;
function DelAchatAlbum(ID: TGUID): Boolean;

function CreationAlbum(const Valeur: string): TGUID;
function EditionAlbum(var ID: TGUID; Creation: Boolean; const Valeur: string; Achat: Boolean): Boolean; overload;
function EditionAlbum(var ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function DelAlbum(ID: TGUID): Boolean;

function CreationEditeur(const Valeur: string): TGUID;
function EditionEditeur(var ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean;
function DelEditeur(ID: TGUID): Boolean;

function CreationCollection(ID_Editeur: TGUID; const Valeur: string): TGUID;
function EditionCollection(var ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function EditionCollection(var ID: TGUID; ID_Editeur: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function DelCollection(ID: TGUID): Boolean;

function CreationGenre(const Genre: string): TGUID;
function EditionGenre(var ID: TGUID): Boolean;
function DelGenre(ID: TGUID): Boolean;

function CreationAuteur(const Auteur: string): TGUID;
function CreationAuteur2(const Auteur: string): TGUID;
function EditionAuteur(var ID: TGUID; Creation: Boolean = False; const Auteur: string = ''): Boolean;
function DelAuteur(ID: TGUID): Boolean;

function CreationEmprunteur(const Emprunteur: string): TGUID;
function EditionEmprunteur(var ID: TGUID; Creation: Boolean = False; const Emprunteur: string = ''): Boolean;
function DelEmprunteur(ID: TGUID): Boolean;

function CreationSerie(const Valeur: string): TGUID;
function EditionSerie(var ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean;
function DelSupport(ID: TGUID): Boolean;

function CreationParaBD(const Valeur: string): TGUID;
function EditionParaBD(var ID: TGUID; Creation: Boolean; const Valeur: string; Achat: Boolean): Boolean; overload;
function EditionParaBD(var ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function DelParaBD(ID: TGUID): Boolean;

function CreationAchatParaBD(const Valeur: string): TGUID;
function EditionAchatParaBD(var ID: TGUID; Creation: Boolean = False; const Valeur: string = ''): Boolean;
function DelAchatParaBD(ID: TGUID): Boolean;

implementation

uses
  JvUIB, Commun, Form_EditAlbum, Form_EditSerie, Form_EditEmprunteur, Textes, Form_EditEditeur, DM_Princ,
  Math, Main, Procedures, Form_EditCollection, Form_EditAuteur, Form_EditParaBD,
  Form_EditAchatAlbum;

function FindRec(Table, Champ: string; Reference: TGUID; WithMessage: Boolean): Boolean;
begin
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := Format('SELECT %s FROM %s WHERE %s = ?', [Champ, Table, Champ]);
    Params.AsString[0] := GUIDToString(Reference);
    Open;
    Result := not Eof;
    if not Result and WithMessage then AffMessage(rsErrorFindEnr, mtConfirmation, [mbOk], True);
  finally
    Transaction.Free;
    Free;
  end;
end;

//**********************************************************************************************
type
  TLambdaEdition = function(var ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
  TLambdaEdition2 = function(var ID: TGUID; Reference2: TGUID; Creation: Boolean; const Valeur: string): Boolean;

function CreationLambda(LambdaEdition: TLambdaEdition; const Valeur: string; Fenetre: TFormClass): TGUID; overload;
begin
  Result := GUID_NULL;
  if Fond.IsShowing(Fenetre) then Exit;
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'select udf_createguid() from rdb$database';
    Open;
    Result := StringToGUID(Fields.AsString[0]);
  finally
    Transaction.Free;
    Free;
  end;
  if not LambdaEdition(Result, True, Valeur) then Result := GUID_NULL;
end;

function CreationLambda(LambdaEdition: TLambdaEdition2; Reference2: TGUID; Valeur: string; Fenetre: TFormClass): TGUID; overload;
begin
  Result := GUID_NULL;
  if Fond.IsShowing(Fenetre) then Exit;
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'select udf_createguid() from rdb$database';
    Open;
    Result := StringToGUID(Fields.AsString[0]);
  finally
    Transaction.Free;
    Free;
  end;
  if not LambdaEdition(Result, Reference2, True, Valeur) then Result := GUID_NULL;
end;

function CreationLambdaChampSimple(TypeInfo, Table, Generateur, Champ, ChampRef: string; ValeurDefaut: string): TGUID;
var
  Chaine: string;
  hg: IHourGlass;
begin
  Result := GUID_NULL;
  Chaine := ValeurDefaut;
  if (not InputQuery(Format(rsNewTitre, [TypeInfo]), Format(rsEntrerNewTitre, [TypeInfo]), Chaine)) then Exit;
  Chaine := Trim(Chaine);
  if (Chaine = '') then Exit;
  hg := THourGlass.Create;
  with TJvUIBQuery.Create(nil) do try
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := Format('SELECT %s FROM %s WHERE %s = ?', [ChampRef, Table, Champ]);
      Params.AsString[0] := Chaine;
      Open;
      if not Eof then raise Exception.CreateFmt(rsTitreStillUsed, [TypeInfo]);

      SQL.Text := 'select udf_createguid() from rdb$database';
      Open;
      Result := StringToGUID(Fields.AsString[0]);

      Params.Clear;
      SQL.Text := Format('INSERT INTO %s (%s, %s) VALUES (?, ?)', [Table, ChampRef, Champ]);
      Params.AsString[0] := GUIDToString(Result);
      Params.AsString[1] := Chaine;
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

function EditionLambdaChampSimple(TypeInfo, Table, Generateur, Champ, ChampRef: string; Reference: TGUID): Boolean;
var
  Chaine: string;
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  Chaine := '';
  Result := False;
  with TJvUIBQuery.Create(nil) do try
    try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);

      SQL.Text := Format('SELECT %s FROM %s WHERE %s = ?', [Champ, Table, ChampRef]);
      Params.AsString[0] := GUIDToString(Reference);
      Open;
      if Eof then raise Exception.Create(rsErrorFindEnr);
      Chaine := Fields.AsString[0];

      if not InputQuery(Format(rsNewTitre, [TypeInfo]), Format(rsEntrerModifyTitre, [TypeInfo]), Chaine) then Exit;
      Chaine := Trim(Chaine);
      if Chaine = '' then Exit;

      Params.Clear;
      SQL.Text := Format('SELECT %s FROM %s WHERE %s = ? AND %s <> ?', [ChampRef, Table, Champ, ChampRef]);
      Params.AsString[0] := Chaine;
      Params.AsString[1] := GUIDToString(Reference);
      Open;
      if not Eof then raise Exception.CreateFmt(rsTitreStillUsed, [TypeInfo]);

      SQL.Text := Format('UPDATE %s SET %s = ? WHERE %s = ?', [Table, Champ, ChampRef]);
      Params.AsString[0] := Chaine;
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

function DelLambda(Table, Champ: string; Ref: TGUID): Boolean;
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  Result := False;
  with TJvUIBQuery.Create(nil) do try
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

function EditionAchatAlbum(var ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditAchatAlbum;
begin
  Result := False;
  if Fond.IsShowing(TFrmEditAchatAlbum) then Exit;
  if not Creation and not FindRec('ALBUMS', 'ID_Album', ID, True) then Exit;
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditAchatAlbum.Create(Application);
  with f do try
    ID_Album := ID;
    if Creation then edTitre.Text := Valeur;
    hg := nil;
    Result := Fond.SetModalChildForm(f) = mrOk;
    if Result then
      ID := ID_Album;
  finally
    Free;
  end;
end;

function DelAchatAlbum(ID: TGUID): Boolean;
begin
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT COMPLET FROM ALBUMS WHERE ID_Album = ?';
    Params.AsString[0] := GUIDToString(ID);
    Open;
    if Fields.AsInteger[0] = 1 then begin
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

function CreationAlbum(const Valeur: string): TGUID;
begin
  Result := CreationLambda(EditionAlbum, Valeur, TFrmEditAlbum);
end;

function EditionAlbum(var ID: TGUID; Creation: Boolean; const Valeur: string; Achat: Boolean): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditAlbum;
begin
  Result := False;
  if Fond.IsShowing(TFrmEditAlbum) then Exit;
  if not Creation and not FindRec('ALBUMS', 'ID_Album', ID, True) then Exit;
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditAlbum.Create(Application);
  with f do try
    isAchat := Achat;
    ID_Album := ID;
    if Creation then edTitre.Text := Valeur;
    hg := nil;
    Result := Fond.SetModalChildForm(f) = mrOk;
  finally
    Free;
  end;
end;

function EditionAlbum(var ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
begin
  Result := EditionAlbum(ID, Creation, Valeur, False);
end;

function DelAlbum(ID: TGUID): Boolean;
begin
  Result := DelLambda('ALBUMS', 'ID_Album', ID);
end;
//**********************************************************************************************

function CreationSerie(const Valeur: string): TGUID;
begin
  Result := CreationLambda(EditionSerie, Valeur, TFrmEditSerie);
end;

function EditionSerie(var ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditSerie;
begin
  Result := False;
  if Fond.IsShowing(TFrmEditSerie) then Exit;
  if not Creation and not FindRec('SERIES', 'ID_Serie', ID, True) then Exit;
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditSerie.Create(Application);
  with f do try
    ID_Serie := ID;
    hg := nil;
    Result := Fond.SetModalChildForm(f) = mrOk;
  finally
    Free;
  end;
end;

function DelSupport(ID: TGUID): Boolean;
begin
  Result := DelLambda('SERIES', 'ID_Serie', ID);
end;
//**********************************************************************************************

function CreationEditeur(const Valeur: string): TGUID;
begin
  Result := CreationLambda(EditionEditeur, Valeur, TFrmEditEditeur);
end;

function EditionEditeur(var ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditEditeur;
begin
  Result := False;
  if Fond.IsShowing(TFrmEditEditeur) then Exit;
  if not Creation and not FindRec('EDITEURS', 'ID_Editeur', ID, True) then Exit;
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditEditeur.Create(Application);
  with f do try
    ID_Editeur := ID;
    if Creation then edNom.Text := Valeur;
    hg := nil;
    Result := Fond.SetModalChildForm(f) = mrOk;
  finally
    Free;
  end;
end;

function DelEditeur(ID: TGUID): Boolean;
begin
  Result := DelLambda('EDITEURS', 'ID_Editeur', ID);
end;
//*************************************************************************************************************************

function CreationCollection(ID_Editeur: TGUID; const Valeur: string): TGUID;
begin
  Result := CreationLambda(EditionCollection, ID_Editeur, Valeur, TFrmEditCollection);
end;

function EditionCollection(var ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
begin
  Result := EditionCollection(ID, GUID_NULL, Creation);
end;

function EditionCollection(var ID: TGUID; ID_Editeur: TGUID; Creation: Boolean; const Valeur: string): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditCollection;
begin
  Result := False;
  if Fond.IsShowing(TFrmEditCollection) then Exit;
  if not Creation and not FindRec('COLLECTIONS', 'ID_Collection', ID, True) then Exit;
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditCollection.Create(Application);
  with f do try
    ID_Collection := ID;
    if Creation then begin
      edNom.Text := Valeur;
      vtEditeurs.CurrentValue := ID_Editeur;
    end;
    hg := nil;
    Result := Fond.SetModalChildForm(f) = mrOk;
  finally
    Free;
  end;
end;

function DelCollection(ID: TGUID): Boolean;
begin
  Result := DelLambda('COLLECTIONS', 'ID_Collection', ID);
end;
//************************************************************************************************************************

function CreationGenre(const Genre: string): TGUID;
begin
  Result := CreationLambdaChampSimple(rsGenre, 'GENRES', 'AI_ID_Genre', 'Genre', 'ID_Genre', Genre);
end;

function EditionGenre(var ID: TGUID): Boolean;
begin
  Result := EditionLambdaChampSimple(rsGenre, 'GENRES', 'AI_ID_Genre', 'Genre', 'ID_Genre', ID);
end;

function DelGenre(ID: TGUID): Boolean;
begin
  Result := DelLambda('Genres', 'ID_Genre', ID);
end;
//**********************************************************************************************

function CreationAuteur(const Auteur: string): TGUID;
begin
  Result := CreationLambdaChampSimple(rsAuteur, 'PERSONNES', 'AI_ID_Personne', 'NomPersonne', 'ID_Personne', Auteur);
end;

function CreationAuteur2(const Auteur: string): TGUID;
begin
  Result := CreationLambda(EditionAuteur, Auteur, TFrmEditAuteur);
end;

function EditionAuteur(var ID: TGUID; Creation: Boolean; const Auteur: string): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditAuteur;
begin
  Result := False;
  if Fond.IsShowing(TFrmEditAuteur) then Exit;
  if not Creation and not FindRec('Personnes', 'ID_Personne', ID, True) then Exit;
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditAuteur.Create(Application);
  with f do try
    ID_Auteur := ID;
    if Creation then edNom.Text := Auteur;
    hg := nil;
    Result := Fond.SetModalChildForm(f) = mrOk;
  finally
    Free;
  end;
end;

function DelAuteur(ID: TGUID): Boolean;
begin
  Result := DelLambda('PERSONNES', 'ID_Personne', ID);
end;
//**********************************************************************************************

function CreationEmprunteur(const Emprunteur: string): TGUID;
begin
  Result := CreationLambda(EditionEmprunteur, Emprunteur, TFrmEditEmprunteur);
end;

function EditionEmprunteur(var ID: TGUID; Creation: Boolean; const Emprunteur: string): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditEmprunteur;
begin
  Result := False;
  if Fond.IsShowing(TFrmEditEmprunteur) then Exit;
  if not Creation and not FindRec('Emprunteurs', 'ID_Emprunteur', ID, True) then Exit;
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditEmprunteur.Create(Application);
  with f do try
    ID_Emprunteur := ID;
    if Creation then edNom.Text := Emprunteur;
    hg := nil;
    Result := Fond.SetModalChildForm(f) = mrOk;
  finally
    Free;
  end;
end;

function DelEmprunteur(ID: TGUID): Boolean;
begin
  Result := DelLambda('Emprunteurs', 'ID_Emprunteur', ID);
end;
//**********************************************************************************************

function CreationParaBD(const Valeur: string): TGUID;
begin
  Result := CreationLambda(EditionParaBD, Valeur, TFrmEditParaBD);
end;

function EditionParaBD(var ID: TGUID; Creation: Boolean; const Valeur: string; Achat: Boolean): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditParaBD;
begin
  Result := False;
  if Fond.IsShowing(TFrmEditParaBD) then Exit;
  if not Creation and not FindRec('ParaBD', 'ID_ParaBD', ID, True) then Exit;
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditParaBD.Create(Application);
  with f do try
    isAchat := Achat;
    ID_ParaBD := ID;
    if Creation then edTitre.Text := Valeur;
    hg := nil;
    Result := Fond.SetModalChildForm(f) = mrOk;
  finally
    Free;
  end;
end;

function EditionParaBD(var ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
begin
  Result := EditionParaBD(ID, Creation, Valeur, False);
end;

function DelParaBD(ID: TGUID): Boolean;
begin
  Result := DelLambda('ParaBD', 'ID_ParaBD', ID);
end;
//**********************************************************************************************

function CreationAchatParaBD(const Valeur: string): TGUID;
begin
  Result := CreationLambda(EditionAchatParaBD, Valeur, TFrmEditParaBD);
end;

function EditionAchatParaBD(var ID: TGUID; Creation: Boolean; const Valeur: string): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditParaBD;
begin
  Result := False;
  if Fond.IsShowing(TFrmEditAchatParaBD) then Exit;
  if not Creation and not FindRec('ParaBD', 'ID_ParaBD', ID, True) then Exit;
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditAchatParaBD.Create(Application);
  with f do try
    ID_ParaBD := ID;
    if Creation then edTitre.Text := Valeur;
    hg := nil;
    Result := Fond.SetModalChildForm(f) = mrOk;
    if Result then
      ID := ID_ParaBD;
  finally
    Free;
  end;
end;

function DelAchatParaBD(ID: TGUID): Boolean;
begin
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT COMPLET FROM ParaBD WHERE ID_ParaBD = ?';
    Params.AsString[0] := GUIDToString(ID);
    Open;
    if Fields.AsInteger[0] = 1 then begin
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

