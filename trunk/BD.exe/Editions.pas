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

function CreationAchat(const Valeur: string): Integer;
function EditionAchat(var Reference: Integer; Creation: Boolean = False; const Valeur: string = ''): Boolean;
function DelAchat(Ref: Integer): Boolean;

function CreationAlbum(const Valeur: string): Integer;
function EditionAlbum(var Reference: Integer; Creation: Boolean; const Valeur: string; Achat: Boolean): Boolean; overload;
function EditionAlbum(var Reference: Integer; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function DelAlbum(Ref: Integer): Boolean;

function CreationEditeur(const Valeur: string): Integer;
function EditionEditeur(var Reference: Integer; Creation: Boolean = False; const Valeur: string = ''): Boolean;
function DelEditeur(Ref: Integer): Boolean;

function CreationCollection(RefEditeur: Integer; const Valeur: string): Integer;
function EditionCollection(var Reference: Integer; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function EditionCollection(var Reference: Integer; RefEditeur: Integer; Creation: Boolean = False; const Valeur: string = ''): Boolean; overload;
function DelCollection(Ref: Integer): Boolean;

function CreationGenre(const Genre: string): Integer;
function EditionGenre(var Reference: Integer): Boolean;
function DelGenre(Ref: Integer): Boolean;

function CreationAuteur(const Auteur: string): Integer;
function CreationAuteur2(const Auteur: string): Integer;
function EditionAuteur(var Reference: Integer; Creation: Boolean = False; const Auteur: string = ''): Boolean;
function DelAuteur(Ref: Integer): Boolean;

function CreationEmprunteur(const Emprunteur: string): Integer;
function EditionEmprunteur(var Reference: Integer; Creation: Boolean = False; const Emprunteur: string = ''): Boolean;
function DelEmprunteur(Ref: Integer): Boolean;

function CreationSerie(const Valeur: string): Integer;
function EditionSerie(var Reference: Integer; Creation: Boolean = False; const Valeur: string = ''): Boolean;
function DelSupport(Ref: Integer): Boolean;

implementation

uses
  JvUIB, Commun, Form_EditAlbum, Form_EditSerie, Form_EditEmprunteur, Textes, Form_EditEditeur, DM_Princ,
  Math, Main, Procedures, Form_EditCollection, Form_EditAuteur,
  Form_EditAchat;

function FindRec(Table, Champ: string; Reference: Integer; WithMessage: Boolean): Boolean;
begin
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := Format('SELECT %s FROM %s WHERE %s = ?', [Champ, Table, Champ]);
    Params.AsInteger[0] := Reference;
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
  TLambdaEdition = function(var Reference: Integer; Creation: Boolean; const Valeur: string): Boolean;
  TLambdaEdition2 = function(var Reference: Integer; Reference2: Integer; Creation: Boolean; const Valeur: string): Boolean;

function CreationLambda(const Generateur: string; LambdaEdition: TLambdaEdition; const Valeur: string; Fenetre: TFormClass): Integer; overload;
begin
  Result := -1;
  if Fond.IsShowing(Fenetre) then Exit;
  if Generateur <> '' then
    with TJvUIBQuery.Create(nil) do try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := Format('SELECT GEN_ID(%s, 1) FROM RDB$DATABASE', [Generateur]);
      Open;
      Result := Fields.AsInteger[0];
    finally
      Transaction.Free;
      Free;
    end;
  if not LambdaEdition(Result, True, Valeur) then Result := -1;
end;

function CreationLambda(Generateur: string; LambdaEdition: TLambdaEdition2; Reference2: Integer; Valeur: string; Fenetre: TFormClass): Integer; overload;
begin
  Result := -1;
  if Fond.IsShowing(Fenetre) then Exit;
  if Generateur <> '' then
    with TJvUIBQuery.Create(nil) do try
      Transaction := GetTransaction(DMPrinc.UIBDataBase);
      SQL.Text := Format('SELECT GEN_ID(%s, 1) FROM RDB$DATABASE', [Generateur]);
      Open;
      Result := Fields.AsInteger[0];
    finally
      Transaction.Free;
      Free;
    end;
  if not LambdaEdition(Result, Reference2, True, Valeur) then Result := -1;
end;

function CreationLambdaChampSimple(TypeInfo, Table, Generateur, Champ, ChampRef: string; ValeurDefaut: string): Integer;
var
  Chaine: string;
  hg: IHourGlass;
begin
  Result := -1;
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

      SQL.Text := Format('SELECT GEN_ID(%s, 1) FROM RDB$DATABASE', [Generateur]);
      Open;
      Result := Fields.AsInteger[0];

      Params.Clear;
      SQL.Text := Format('INSERT INTO %s (%s, %s) VALUES (?, ?)', [Table, ChampRef, Champ]);
      Params.AsInteger[0] := Result;
      Params.AsString[1] := Chaine;
      ExecSQL;
      Transaction.Commit;
    except
      Transaction.Rollback;
      AffMessage(rsErrorCreerEnr + #13#13 + Exception(ExceptObject).Message, mtInformation, [mbOk], True);
      Result := -1;
    end;
  finally
    Transaction.Free;
    Free;
  end;
end;

function EditionLambdaChampSimple(TypeInfo, Table, Generateur, Champ, ChampRef: string; Reference: Integer): Boolean;
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
      Params.AsInteger[0] := Reference;
      Open;
      if Eof then raise Exception.Create(rsErrorFindEnr);
      Chaine := Fields.AsString[0];

      if not InputQuery(Format(rsNewTitre, [TypeInfo]), Format(rsEntrerModifyTitre, [TypeInfo]), Chaine) then Exit;
      Chaine := Trim(Chaine);
      if Chaine = '' then Exit;

      Params.Clear;
      SQL.Text := Format('SELECT %s FROM %s WHERE %s = ? AND %s <> ?', [ChampRef, Table, Champ, ChampRef]);
      Params.AsString[0] := Chaine;
      Params.AsInteger[1] := Reference;
      Open;
      if not Eof then raise Exception.CreateFmt(rsTitreStillUsed, [TypeInfo]);

      SQL.Text := Format('UPDATE %s SET %s = ? WHERE %s = ?', [Table, Champ, ChampRef]);
      Params.AsString[0] := Chaine;
      Params.AsInteger[1] := Reference;
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

function DelLambda(Table, Champ: string; Ref: Integer): Boolean;
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  Result := False;
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := Format('DELETE FROM %s WHERE %s=?', [Table, Champ]);
    Params.AsInteger[0] := Ref;
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

function CreationAchat(const Valeur: string): Integer;
begin
  Result := CreationLambda('', EditionAchat, Valeur, TFrmEditAchat);
end;

function EditionAchat(var Reference: Integer; Creation: Boolean; const Valeur: string): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditAchat;
begin
  Result := False;
  if Fond.IsShowing(TFrmEditAchat) then Exit;
  if not Creation and not FindRec('ALBUMS', 'REFALBUM', Reference, True) then Exit;
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditAchat.Create(Application);
  with f do try
    RefAlbum := Reference;
    if Creation then edTitre.Text := Valeur;
    hg := nil;
    Result := Fond.SetModalChildForm(f) = mrOk;
    if Result then
      Reference := RefAlbum;
  finally
    Free;
  end;
end;

function DelAchat(Ref: Integer): Boolean;
begin
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT COMPLET FROM ALBUMS WHERE REFALBUM = ?';
    Params.AsInteger[0] := Ref;
    Open;
    if Fields.AsInteger[0] = 1 then begin
      SQL.Text := 'UPDATE ALBUMS SET ACHAT = 0 WHERE REFALBUM = ?';
      Params.AsInteger[0] := Ref;
      Execute;
      Result := True;
    end
    else
      Result := DelAlbum(Ref);
  finally
    Transaction.Free;
    Free;
  end;
end;
//**********************************************************************************************

function CreationAlbum(const Valeur: string): Integer;
begin
  Result := CreationLambda('AI_REFALBUM', EditionAlbum, Valeur, TFrmEditAlbum);
end;

function EditionAlbum(var Reference: Integer; Creation: Boolean; const Valeur: string; Achat: Boolean): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditAlbum;
begin
  Result := False;
  if Fond.IsShowing(TFrmEditAlbum) then Exit;
  if not Creation and not FindRec('ALBUMS', 'REFALBUM', Reference, True) then Exit;
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditAlbum.Create(Application);
  with f do try
    isAchat := Achat;
    RefAlbum := Reference;
    if Creation then edTitre.Text := Valeur;
    hg := nil;
    Result := Fond.SetModalChildForm(f) = mrOk;
  finally
    Free;
  end;
end;

function EditionAlbum(var Reference: Integer; Creation: Boolean; const Valeur: string): Boolean;
begin
  Result := EditionAlbum(Reference, Creation, Valeur, False);
end;

function DelAlbum(Ref: Integer): Boolean;
begin
  Result := DelLambda('ALBUMS', 'REFALBUM', Ref);
end;
//**********************************************************************************************

function CreationSerie(const Valeur: string): Integer;
begin
  Result := CreationLambda('AI_RefSerie', EditionSerie, Valeur, TFrmEditSerie);
end;

function EditionSerie(var Reference: Integer; Creation: Boolean; const Valeur: string): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditSerie;
begin
  Result := False;
  if Fond.IsShowing(TFrmEditSerie) then Exit;
  if not Creation and not FindRec('SERIES', 'REFSERIE', Reference, True) then Exit;
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditSerie.Create(Application);
  with f do try
    RefSerie := Reference;
    hg := nil;
    Result := Fond.SetModalChildForm(f) = mrOk;
  finally
    Free;
  end;
end;

function DelSupport(Ref: Integer): Boolean;
begin
  Result := DelLambda('SERIES', 'REFSERIE', Ref);
end;
//**********************************************************************************************

function CreationEditeur(const Valeur: string): Integer;
begin
  Result := CreationLambda('AI_REFEDITEUR', EditionEditeur, Valeur, TFrmEditEditeur);
end;

function EditionEditeur(var Reference: Integer; Creation: Boolean; const Valeur: string): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditEditeur;
begin
  Result := False;
  if Fond.IsShowing(TFrmEditEditeur) then Exit;
  if not Creation and not FindRec('EDITEURS', 'REFEDITEUR', Reference, True) then Exit;
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditEditeur.Create(Application);
  with f do try
    RefEditeur := Reference;
    if Creation then edNom.Text := Valeur;
    hg := nil;
    Result := Fond.SetModalChildForm(f) = mrOk;
  finally
    Free;
  end;
end;

function DelEditeur(Ref: Integer): Boolean;
begin
  Result := DelLambda('EDITEURS', 'REFEDITEUR', Ref);
end;
//*************************************************************************************************************************

function CreationCollection(RefEditeur: Integer; const Valeur: string): Integer;
begin
  Result := CreationLambda('AI_REFCOLLECTION', EditionCollection, RefEditeur, Valeur, TFrmEditCollection);
end;

function EditionCollection(var Reference: Integer; Creation: Boolean; const Valeur: string): Boolean;
begin
  Result := EditionCollection(Reference, -1, Creation);
end;

function EditionCollection(var Reference: Integer; RefEditeur: Integer; Creation: Boolean; const Valeur: string): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditCollection;
begin
  Result := False;
  if Fond.IsShowing(TFrmEditCollection) then Exit;
  if not Creation and not FindRec('COLLECTIONS', 'REFCOLLECTION', Reference, True) then Exit;
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditCollection.Create(Application);
  with f do try
    FRefEditeur := RefEditeur;
    RefCollection := Reference;
    if Creation then edNom.Text := Valeur;
    hg := nil;
    Result := Fond.SetModalChildForm(f) = mrOk;
  finally
    Free;
  end;
end;

function DelCollection(Ref: Integer): Boolean;
begin
  Result := DelLambda('COLLECTIONS', 'REFCOLLECTION', Ref);
end;
//************************************************************************************************************************

function CreationGenre(const Genre: string): Integer;
begin
  Result := CreationLambdaChampSimple(rsGenre, 'GENRES', 'AI_REFGENRE', 'Genre', 'RefGenre', Genre);
end;

function EditionGenre(var Reference: Integer): Boolean;
begin
  Result := EditionLambdaChampSimple(rsGenre, 'GENRES', 'AI_REFGENRE', 'Genre', 'RefGenre', Reference);
end;

function DelGenre(Ref: Integer): Boolean;
begin
  Result := DelLambda('Genres', 'RefGenre', Ref);
end;
//**********************************************************************************************

function CreationAuteur(const Auteur: string): Integer;
begin
  Result := CreationLambdaChampSimple(rsAuteur, 'PERSONNES', 'AI_REFPERSONNE', 'NomPersonne', 'RefPersonne', Auteur);
end;

function CreationAuteur2(const Auteur: string): Integer;
begin
  Result := CreationLambda('AI_REFPERSONNE', EditionAuteur, Auteur, TFrmEditAuteur);
end;

function EditionAuteur(var Reference: Integer; Creation: Boolean; const Auteur: string): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditAuteur;
begin
  Result := False;
  if Fond.IsShowing(TFrmEditAuteur) then Exit;
  if not Creation and not FindRec('Personnes', 'RefPersonne', Reference, True) then Exit;
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditAuteur.Create(Application);
  with f do try
    RefAuteur := Reference;
    if Creation then edNom.Text := Auteur;
    hg := nil;
    Result := Fond.SetModalChildForm(f) = mrOk;
  finally
    Free;
  end;
end;

function DelAuteur(Ref: Integer): Boolean;
begin
  Result := DelLambda('PERSONNES', 'RefPersonne', Ref);
end;
//**********************************************************************************************

function CreationEmprunteur(const Emprunteur: string): Integer;
begin
  Result := CreationLambda('AI_RefEmprunteur', EditionEmprunteur, Emprunteur, TFrmEditEmprunteur);
end;

function EditionEmprunteur(var Reference: Integer; Creation: Boolean; const Emprunteur: string): Boolean;
var
  hg: IHourGlass;
  me: IModeEditing;
  f: TFrmEditEmprunteur;
begin
  Result := False;
  if Fond.IsShowing(TFrmEditEmprunteur) then Exit;
  if not Creation and not FindRec('Emprunteurs', 'RefEmprunteur', Reference, True) then Exit;
  hg := THourGlass.Create;
  me := TModeEditing.Create;
  f := TFrmEditEmprunteur.Create(Application);
  with f do try
    RefEmprunteur := Reference;
    if Creation then edNom.Text := Emprunteur;
    hg := nil;
    Result := Fond.SetModalChildForm(f) = mrOk;
  finally
    Free;
  end;
end;

function DelEmprunteur(Ref: Integer): Boolean;
begin
  Result := DelLambda('Emprunteurs', 'RefEmprunteur', Ref);
end;
//**********************************************************************************************
end.

