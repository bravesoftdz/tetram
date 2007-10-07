unit Proc_Gestions;

interface

uses
  editions, SysUtils, Classes, Controls, Dialogs, Db, DBCtrls, Divers, Commun, ComCtrls, VirtualTree, JvUIB;

type
  TActionGestionAdd = function(VT: TVirtualStringTree; const Valeur: string): TGUID;
  TActionGestionModif = function(VT: TVirtualStringTree): Boolean;
  TActionGestionSupp = function(VT: TVirtualStringTree): Boolean;
  TActionGestionAchat = function(VT: TVirtualStringTree): Boolean;

function AjouterEditeurs(VT: TVirtualStringTree; const Valeur: string): TGUID;
function ModifierEditeurs(VT: TVirtualStringTree): Boolean;
function SupprimerEditeurs(VT: TVirtualStringTree): Boolean;

function AjouterAchatsAlbum(VT: TVirtualStringTree; const Valeur: string): TGUID;
function ModifierAchatsAlbum(VT: TVirtualStringTree): Boolean;
function SupprimerAchatsAlbum(VT: TVirtualStringTree): Boolean;

function AjouterAlbums(VT: TVirtualStringTree; const Valeur: string): TGUID;
function ModifierAlbums(VT: TVirtualStringTree): Boolean;
function AcheterAlbums(VT: TVirtualStringTree): Boolean;
function SupprimerAlbums(VT: TVirtualStringTree): Boolean;

function AjouterGenres(VT: TVirtualStringTree; const Valeur: string): TGUID;
function ModifierGenres(VT: TVirtualStringTree): Boolean;
function SupprimerGenres(VT: TVirtualStringTree): Boolean;

function AjouterAuteurs(VT: TVirtualStringTree; const Valeur: string): TGUID;
function AjouterAuteurs2(VT: TVirtualStringTree; const Valeur: string): TGUID;
function ModifierAuteurs(VT: TVirtualStringTree): Boolean;
function SupprimerAuteurs(VT: TVirtualStringTree): Boolean;

function AjouterSeries(VT: TVirtualStringTree; const Valeur: string): TGUID;
function ModifierSeries(VT: TVirtualStringTree): Boolean;
function SupprimerSeries(VT: TVirtualStringTree): Boolean;

function AjouterEmprunteurs(VT: TVirtualStringTree; const Valeur: string): TGUID;
function ModifierEmprunteurs(VT: TVirtualStringTree): Boolean;
function SupprimerEmprunteurs(VT: TVirtualStringTree): Boolean;

function AjouterCollections(VT: TVirtualStringTree; const ID_Editeur: TGUID; const Valeur: string): TGUID; overload;
function AjouterCollections(VT: TVirtualStringTree; const Valeur: string): TGUID; overload;
function ModifierCollections(VT: TVirtualStringTree): Boolean;
function SupprimerCollections(VT: TVirtualStringTree): Boolean;

function AjouterParaBD(VT: TVirtualStringTree; const Valeur: string): TGUID;
function ModifierParaBD(VT: TVirtualStringTree): Boolean;
function AcheterParaBD(VT: TVirtualStringTree): Boolean;
function SupprimerParaBD(VT: TVirtualStringTree): Boolean;

function AjouterAchatsParaBD(VT: TVirtualStringTree; const Valeur: string): TGUID;
function ModifierAchatsParaBD(VT: TVirtualStringTree): Boolean;
function SupprimerAchatsParaBD(VT: TVirtualStringTree): Boolean;

implementation

uses Textes, Procedures, TypeRec;

//******************************************************************************************************

function AjouterEditeurs(VT: TVirtualStringTree; const Valeur: string): TGUID;
begin
  Result := CreationEditeur(Valeur);
  if IsEqualGUID(Result, GUID_NULL) then Exit;
  if Assigned(VT) then begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierEditeurs(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then Exit;
  Result := EditionEditeur(i);
  if Result then VT.InitializeRep;
end;

function SupprimerEditeurs(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then Exit;
  VT.MemorizeIndexNode;
  if AffMessage(rsLienEditeur + #13 + rsSupprimerEditeur, mtConfirmation, [mbYes, mbNo], True) <> mrYes then Exit;
  Result := DelEditeur(i);
  if Result then begin
    VT.InitializeRep(False);
    VT.FindIndexNode;
  end
  else
    VT.ClearIndexNode;
end;
//********************************************************************************************************

function AjouterAchatsAlbum(VT: TVirtualStringTree; const Valeur: string): TGUID;
begin
  Result := CreationAchatAlbum(Valeur);
  if IsEqualGUID(Result, GUID_NULL) then Exit;
  if Assigned(VT) then begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierAchatsAlbum(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then Exit;
  Result := EditionAchatAlbum(i);
  if Result then VT.InitializeRep;
end;

function SupprimerAchatsAlbum(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
  PA: TAlbum;
  s: string;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then Exit;
  VT.MemorizeIndexNode;
  PA := VT.GetFocusedNodeData;
  s := rsSupprimerAchat;
  if Assigned(PA) and not PA.Complet then
    s := rsLienAchatAlbum + #13 + s;
  if AffMessage(s, mtConfirmation, [mbYes, mbNo], True) <> mrYes then Exit;
  Result := DelAchatAlbum(i);
  if Result then begin
    VT.InitializeRep(False);
    VT.FindIndexNode;
  end
  else
    VT.ClearIndexNode;
end;
//*********************************************************************************************************

function AjouterAlbums(VT: TVirtualStringTree; const Valeur: string): TGUID;
begin
  Result := CreationAlbum(Valeur);
  if IsEqualGUID(Result, GUID_NULL) then Exit;
  if Assigned(VT) then begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierAlbums(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then Exit;
  Result := EditionAlbum(i);
  if Result then VT.InitializeRep;
end;

function AcheterAlbums(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then Exit;
  Result := EditionAlbum(i, False, '', True);
  if Result then VT.InitializeRep;
end;

function SupprimerAlbums(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then Exit;
  VT.MemorizeIndexNode;
  if AffMessage(rsLienAlbum + #13 + rsSupprimerAlbum, mtConfirmation, [mbYes, mbNo], True) <> mrYes then Exit;
  Result := DelAlbum(i);
  if Result then begin
    VT.InitializeRep(False);
    VT.FindIndexNode;
  end
  else
    VT.ClearIndexNode;
end;
//*********************************************************************************************************

function AjouterGenres(VT: TVirtualStringTree; const Valeur: string): TGUID;
begin
  Result := CreationGenre(Valeur);
  if IsEqualGUID(Result, GUID_NULL) then Exit;
  if Assigned(VT) then begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierGenres(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then Exit;
  Result := EditionGenre(i);
  if Result then VT.InitializeRep;
end;

function SupprimerGenres(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then Exit;
  VT.MemorizeIndexNode;
  if AffMessage(rsLienGenre + #13 + rsSupprimerGenre, mtConfirmation, [mbYes, mbNo], True) <> mrYes then Exit;
  Result := DelGenre(i);
  if Result then begin
    VT.InitializeRep(False);
    VT.FindIndexNode;
  end
  else
    VT.ClearIndexNode;
end;
//********************************************************************************************************************

function AjouterAuteurs(VT: TVirtualStringTree; const Valeur: string): TGUID;
begin
  Result := CreationAuteur(FormalizeNom(Valeur));
  if IsEqualGUID(Result, GUID_NULL) then Exit;
  if Assigned(VT) then begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function AjouterAuteurs2(VT: TVirtualStringTree; const Valeur: string): TGUID;
begin
  Result := CreationAuteur2(FormalizeNom(Valeur));
  if IsEqualGUID(Result, GUID_NULL) then Exit;
  if Assigned(VT) then begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierAuteurs(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then Exit;
  Result := EditionAuteur(i);
  if Result then VT.InitializeRep;
end;

function SupprimerAuteurs(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then Exit;
  VT.MemorizeIndexNode;
  if AffMessage(rsLienAuteur + #13 + rsSupprimerAuteur, mtConfirmation, [mbYes, mbNo], True) <> mrYes then Exit;
  Result := DelAuteur(i);
  if Result then begin
    VT.InitializeRep(False);
    VT.FindIndexNode;
  end
  else
    VT.ClearIndexNode;
end;
//********************************************************************************************************************

function AjouterSeries(VT: TVirtualStringTree; const Valeur: string): TGUID;
begin
  Result := CreationSerie(Valeur);
  if IsEqualGUID(Result, GUID_NULL) then Exit;
  if Assigned(VT) then begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierSeries(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then Exit;
  Result := EditionSerie(i);
  if Result then VT.InitializeRep;
end;

function SupprimerSeries(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then Exit;
  VT.MemorizeIndexNode;
  if AffMessage(rsLienSerie + #13 + rsSupprimerSerie, mtConfirmation, [mbYes, mbNo], True) <> mrYes then Exit;
  Result := DelSupport(i);
  if Result then begin
    VT.InitializeRep(False);
    VT.FindIndexNode;
  end
  else
    VT.ClearIndexNode;
end;
//********************************************************************************************************************

function AjouterEmprunteurs(VT: TVirtualStringTree; const Valeur: string): TGUID;
begin
  Result := CreationEmprunteur(Valeur);
  if IsEqualGUID(Result, GUID_NULL) then Exit;
  if Assigned(VT) then begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierEmprunteurs(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then Exit;
  Result := EditionEmprunteur(i);
  if Result then VT.InitializeRep;
end;

function SupprimerEmprunteurs(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then Exit;
  VT.MemorizeIndexNode;
  if AffMessage(rsLienEmprunteur + #13 + rsSupprimerEmprunteur, mtConfirmation, [mbYes, mbNo], True) <> mrYes then Exit;
  Result := DelEmprunteur(i);
  if Result then begin
    VT.InitializeRep(False);
    VT.FindIndexNode;
  end
  else
    VT.ClearIndexNode;
end;
//********************************************************************************************************************

function AjouterCollections(VT: TVirtualStringTree; const ID_Editeur: TGUID; const Valeur: string): TGUID;
begin
  Result := CreationCollection(ID_Editeur, Valeur);
  if IsEqualGUID(Result, GUID_NULL) then Exit;
  if Assigned(VT) then begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function AjouterCollections(VT: TVirtualStringTree; const Valeur: string): TGUID;
begin
  Result := AjouterCollections(VT, GUID_NULL, Valeur);
end;

function ModifierCollections(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then Exit;
  Result := EditionCollection(i);
  if Result then VT.InitializeRep;
end;

function SupprimerCollections(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then Exit;
  VT.MemorizeIndexNode;
  if AffMessage(rsLienCollection + #13 + rsSupprimerCollection, mtConfirmation, [mbYes, mbNo], True) <> mrYes then Exit;
  Result := DelCollection(i);
  if Result then begin
    VT.InitializeRep(False);
    VT.FindIndexNode;
  end
  else
    VT.ClearIndexNode;
end;
//********************************************************************************************************************

function AjouterParaBD(VT: TVirtualStringTree; const Valeur: string): TGUID;
begin
  Result := CreationParaBD(Valeur);
  if IsEqualGUID(Result, GUID_NULL) then Exit;
  if Assigned(VT) then begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierParaBD(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then Exit;
  Result := EditionParaBD(i);
  if Result then VT.InitializeRep;
end;

function AcheterParaBD(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then Exit;
  Result := EditionParaBD(i, False, '', True);
  if Result then VT.InitializeRep;
end;

function SupprimerParaBD(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then Exit;
  VT.MemorizeIndexNode;
  if AffMessage(rsLienParaBD + #13 + rsSupprimerParaBD, mtConfirmation, [mbYes, mbNo], True) <> mrYes then Exit;  Result := DelParaBD(i);
  if Result then begin
    VT.InitializeRep(False);
    VT.FindIndexNode;
  end
  else
    VT.ClearIndexNode;
end;
//*********************************************************************************************************
function AjouterAchatsParaBD(VT: TVirtualStringTree; const Valeur: string): TGUID;
begin
  Result := CreationAchatParaBD(Valeur);
  if IsEqualGUID(Result, GUID_NULL) then Exit;
  if Assigned(VT) then begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierAchatsParaBD(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then Exit;
  Result := EditionAchatParaBD(i);
  if Result then VT.InitializeRep;
end;

function SupprimerAchatsParaBD(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
  PA: TParaBD;
  s: string;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then Exit;
  VT.MemorizeIndexNode;
  PA := VT.GetFocusedNodeData;
  s := rsSupprimerAchat;
  if Assigned(PA) and not PA.Complet then
    s := rsLienAchatParaBD + #13 + s;
  if AffMessage(s, mtConfirmation, [mbYes, mbNo], True) <> mrYes then Exit;
  Result := DelAchatParaBD(i);
  if Result then begin
    VT.InitializeRep(False);
    VT.FindIndexNode;
  end
  else
    VT.ClearIndexNode;
end;
//*********************************************************************************************************
end.

