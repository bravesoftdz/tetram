unit Proc_Gestions;

interface

uses
  editions, SysUtils, Classes, Controls, Dialogs, Db, DBCtrls, Divers, Commun, ComCtrls, VirtualTreeBdtk, Entities.Full;

type
  TActionGestionAdd = function(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
  TActionGestionAddWithRef = function(VT: TVirtualStringTree; const ID_Editeur: TGUID; const Valeur: string; Source: TObjetFull = nil): TGUID;
  TActionGestionModif = function(VT: TVirtualStringTree; Source: TObjetFull = nil): Boolean;
  TActionGestionModif2 = function(const ID: TGUID; Source: TObjetFull = nil): Boolean;
  TActionGestionSupp = function(VT: TVirtualStringTree): Boolean;
  TActionGestionAchat = function(VT: TVirtualStringTree): Boolean;

function AjouterEditeurs(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
function ModifierEditeurs(VT: TVirtualStringTree; Source: TObjetFull = nil): Boolean;
function SupprimerEditeurs(VT: TVirtualStringTree): Boolean;

function AjouterAchatsAlbum(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
function ModifierAchatsAlbum(VT: TVirtualStringTree; Source: TObjetFull = nil): Boolean;
function SupprimerAchatsAlbum(VT: TVirtualStringTree): Boolean;

function AjouterAlbums(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
function ModifierAlbums(VT: TVirtualStringTree; Source: TObjetFull = nil): Boolean;
function ModifierAlbums2(const ID: TGUID; Source: TObjetFull = nil): Boolean;
function AcheterAlbums(VT: TVirtualStringTree): Boolean;
function SupprimerAlbums(VT: TVirtualStringTree): Boolean;

function AjouterGenres(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
function ModifierGenres(VT: TVirtualStringTree; Source: TObjetFull = nil): Boolean;
function SupprimerGenres(VT: TVirtualStringTree): Boolean;

function AjouterAuteurs(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
function AjouterAuteurs2(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
function ModifierAuteurs(VT: TVirtualStringTree; Source: TObjetFull = nil): Boolean;
function ModifierAuteurs2(const ID: TGUID; Source: TObjetFull = nil): Boolean;
function SupprimerAuteurs(VT: TVirtualStringTree): Boolean;

function AjouterSeries(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
function ModifierSeries(VT: TVirtualStringTree; Source: TObjetFull = nil): Boolean;
function ModifierSeries2(const ID: TGUID; Source: TObjetFull = nil): Boolean;
function SupprimerSeries(VT: TVirtualStringTree): Boolean;

function AjouterUnivers(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
function ModifierUnivers(VT: TVirtualStringTree; Source: TObjetFull = nil): Boolean;
function ModifierUnivers2(const ID: TGUID; Source: TObjetFull = nil): Boolean;
function SupprimerUnivers(VT: TVirtualStringTree): Boolean;

function AjouterCollections2(VT: TVirtualStringTree; const ID_Editeur: TGUID; const Valeur: string): TGUID;
function AjouterCollections(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
function ModifierCollections(VT: TVirtualStringTree; Source: TObjetFull = nil): Boolean;
function SupprimerCollections(VT: TVirtualStringTree): Boolean;

function AjouterParaBD(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
function ModifierParaBD(VT: TVirtualStringTree; Source: TObjetFull = nil): Boolean;
function ModifierParaBD2(const ID: TGUID; Source: TObjetFull = nil): Boolean;
function AcheterParaBD(VT: TVirtualStringTree): Boolean;
function SupprimerParaBD(VT: TVirtualStringTree): Boolean;

function AjouterAchatsParaBD(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
function ModifierAchatsParaBD(VT: TVirtualStringTree; Source: TObjetFull = nil): Boolean;
function SupprimerAchatsParaBD(VT: TVirtualStringTree): Boolean;

implementation

uses
  Textes, Procedures, Entities.Lite;

// ******************************************************************************************************

function AjouterEditeurs(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
begin
  if Assigned(Source) then
    Result := CreationEditeur(Source)
  else
    Result := CreationEditeur(Valeur);
  if IsEqualGUID(Result, GUID_NULL) then
    Exit;
  if Assigned(VT) then
  begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierEditeurs(VT: TVirtualStringTree; Source: TObjetFull = nil): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then
    Exit;
  Result := EditionEditeur(i);
  if Result then
    VT.InitializeRep;
end;

function SupprimerEditeurs(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then
    Exit;
  VT.MemorizeIndexNode;
  if AffMessage(rsLienEditeur + #13 + rsSupprimerEditeur, mtConfirmation, [mbYes, mbNo], True) <> mrYes then
    Exit;
  Result := DelEditeur(i);
  if Result then
  begin
    VT.InitializeRep(False);
    VT.FindIndexNode;
  end
  else
    VT.ClearIndexNode;
end;
// ********************************************************************************************************

function AjouterAchatsAlbum(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
begin
  Result := CreationAchatAlbum(Valeur);
  if IsEqualGUID(Result, GUID_NULL) then
    Exit;
  if Assigned(VT) then
  begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierAchatsAlbum(VT: TVirtualStringTree; Source: TObjetFull = nil): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then
    Exit;
  Result := EditionAchatAlbum(i);
  if Result then
    VT.InitializeRep;
end;

function SupprimerAchatsAlbum(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
  PA: TAlbumLite;
  s: string;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then
    Exit;
  VT.MemorizeIndexNode;
  PA := VT.GetFocusedNodeData as TAlbumLite;
  s := rsSupprimerAchat;
  if Assigned(PA) and not PA.Complet then
    s := rsLienAchatAlbum + #13 + s;
  if AffMessage(s, mtConfirmation, [mbYes, mbNo], True) <> mrYes then
    Exit;
  Result := DelAchatAlbum(i);
  if Result then
  begin
    VT.InitializeRep(False);
    VT.FindIndexNode;
  end
  else
    VT.ClearIndexNode;
end;
// *********************************************************************************************************

function AjouterAlbums(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
begin
  if Assigned(Source) then
    Result := CreationAlbum(Source)
  else
    Result := CreationAlbum(Valeur);
  if IsEqualGUID(Result, GUID_NULL) then
    Exit;
  if Assigned(VT) then
  begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierAlbums2(const ID: TGUID; Source: TObjetFull = nil): Boolean;
var
  dummy: TGUID;
begin
  Result := False;
  if IsEqualGUID(ID, GUID_NULL) then
    Exit;
  dummy := ID;
  Result := EditionAlbum(dummy);
end;

function ModifierAlbums(VT: TVirtualStringTree; Source: TObjetFull = nil): Boolean;
begin
  Result := ModifierAlbums2(VT.CurrentValue);
  if Result then
    VT.InitializeRep;
end;

function AcheterAlbums(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then
    Exit;
  Result := EditionAlbum(i, False, '', True);
  if Result then
    VT.InitializeRep;
end;

function SupprimerAlbums(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then
    Exit;
  VT.MemorizeIndexNode;
  if AffMessage(rsLienAlbum + #13 + rsSupprimerAlbum, mtConfirmation, [mbYes, mbNo], True) <> mrYes then
    Exit;
  Result := DelAlbum(i);
  if Result then
  begin
    VT.InitializeRep(False);
    VT.FindIndexNode;
  end
  else
    VT.ClearIndexNode;
end;
// *********************************************************************************************************

function AjouterGenres(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
begin
  Result := CreationGenre(Valeur);
  if IsEqualGUID(Result, GUID_NULL) then
    Exit;
  if Assigned(VT) then
  begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierGenres(VT: TVirtualStringTree; Source: TObjetFull = nil): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then
    Exit;
  Result := EditionGenre(i);
  if Result then
    VT.InitializeRep;
end;

function SupprimerGenres(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then
    Exit;
  VT.MemorizeIndexNode;
  if AffMessage(rsLienGenre + #13 + rsSupprimerGenre, mtConfirmation, [mbYes, mbNo], True) <> mrYes then
    Exit;
  Result := DelGenre(i);
  if Result then
  begin
    VT.InitializeRep(False);
    VT.FindIndexNode;
  end
  else
    VT.ClearIndexNode;
end;
// ********************************************************************************************************************

function AjouterAuteurs(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
begin
  Result := CreationAuteur(FormalizeNom(Valeur));
  if IsEqualGUID(Result, GUID_NULL) then
    Exit;
  if Assigned(VT) then
  begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function AjouterAuteurs2(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
begin
  Result := CreationAuteur2(FormalizeNom(Valeur));
  if IsEqualGUID(Result, GUID_NULL) then
    Exit;
  if Assigned(VT) then
  begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierAuteurs2(const ID: TGUID; Source: TObjetFull = nil): Boolean;
var
  dummy: TGUID;
begin
  Result := False;
  if IsEqualGUID(ID, GUID_NULL) then
    Exit;
  dummy := ID;
  Result := EditionAuteur(dummy);
end;

function ModifierAuteurs(VT: TVirtualStringTree; Source: TObjetFull = nil): Boolean;
begin
  Result := ModifierAuteurs2(VT.CurrentValue);
  if Result then
    VT.InitializeRep;
end;

function SupprimerAuteurs(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then
    Exit;
  VT.MemorizeIndexNode;
  if AffMessage(rsLienAuteur + #13 + rsSupprimerAuteur, mtConfirmation, [mbYes, mbNo], True) <> mrYes then
    Exit;
  Result := DelAuteur(i);
  if Result then
  begin
    VT.InitializeRep(False);
    VT.FindIndexNode;
  end
  else
    VT.ClearIndexNode;
end;
// ********************************************************************************************************************

function AjouterSeries(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
begin
  if Assigned(Source) then
    Result := CreationSerie(Source)
  else
    Result := CreationSerie(Valeur);
  if IsEqualGUID(Result, GUID_NULL) then
    Exit;
  if Assigned(VT) then
  begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierSeries2(const ID: TGUID; Source: TObjetFull = nil): Boolean;
var
  dummy: TGUID;
begin
  Result := False;
  if IsEqualGUID(ID, GUID_NULL) then
    Exit;
  dummy := ID;
  Result := EditionSerie(dummy);
end;

function ModifierSeries(VT: TVirtualStringTree; Source: TObjetFull = nil): Boolean;
begin
  Result := ModifierSeries2(VT.CurrentValue);
  if Result then
    VT.InitializeRep;
end;

function SupprimerSeries(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then
    Exit;
  VT.MemorizeIndexNode;
  if AffMessage(rsLienSerie + #13 + rsSupprimerSerie, mtConfirmation, [mbYes, mbNo], True) <> mrYes then
    Exit;
  Result := DelSerie(i);
  if Result then
  begin
    VT.InitializeRep(False);
    VT.FindIndexNode;
  end
  else
    VT.ClearIndexNode;
end;
// ********************************************************************************************************************

function AjouterUnivers(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
begin
  if Assigned(Source) then
    Result := CreationUnivers(Source)
  else
    Result := CreationUnivers(Valeur);
  if IsEqualGUID(Result, GUID_NULL) then
    Exit;
  if Assigned(VT) then
  begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierUnivers2(const ID: TGUID; Source: TObjetFull = nil): Boolean;
var
  dummy: TGUID;
begin
  Result := False;
  if IsEqualGUID(ID, GUID_NULL) then
    Exit;
  dummy := ID;
  Result := EditionUnivers(dummy);
end;

function ModifierUnivers(VT: TVirtualStringTree; Source: TObjetFull = nil): Boolean;
begin
  Result := ModifierUnivers2(VT.CurrentValue);
  if Result then
    VT.InitializeRep;
end;

function SupprimerUnivers(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then
    Exit;
  VT.MemorizeIndexNode;
  if AffMessage(rsLienUnivers + #13 + rsSupprimerUnivers, mtConfirmation, [mbYes, mbNo], True) <> mrYes then
    Exit;
  Result := DelUnivers(i);
  if Result then
  begin
    VT.InitializeRep(False);
    VT.FindIndexNode;
  end
  else
    VT.ClearIndexNode;
end;
// ********************************************************************************************************************

function AjouterCollections2(VT: TVirtualStringTree; const ID_Editeur: TGUID; const Valeur: string): TGUID;
begin
  Result := CreationCollection(ID_Editeur, Valeur);
  if IsEqualGUID(Result, GUID_NULL) then
    Exit;
  if Assigned(VT) then
  begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function AjouterCollections(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
begin
  if Assigned(Source) then
    Result := CreationCollection(Source)
  else
    Result := CreationCollection(GUID_NULL, Valeur);
  if IsEqualGUID(Result, GUID_NULL) then
    Exit;
  if Assigned(VT) then
  begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierCollections(VT: TVirtualStringTree; Source: TObjetFull = nil): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then
    Exit;
  Result := EditionCollection(i);
  if Result then
    VT.InitializeRep;
end;

function SupprimerCollections(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then
    Exit;
  VT.MemorizeIndexNode;
  if AffMessage(rsLienCollection + #13 + rsSupprimerCollection, mtConfirmation, [mbYes, mbNo], True) <> mrYes then
    Exit;
  Result := DelCollection(i);
  if Result then
  begin
    VT.InitializeRep(False);
    VT.FindIndexNode;
  end
  else
    VT.ClearIndexNode;
end;
// ********************************************************************************************************************

function AjouterParaBD(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
begin
  Result := CreationParaBD(Valeur);
  if IsEqualGUID(Result, GUID_NULL) then
    Exit;
  if Assigned(VT) then
  begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierParaBD2(const ID: TGUID; Source: TObjetFull = nil): Boolean;
var
  dummy: TGUID;
begin
  Result := False;
  if IsEqualGUID(ID, GUID_NULL) then
    Exit;
  dummy := ID;
  Result := EditionParaBD(dummy);
end;

function ModifierParaBD(VT: TVirtualStringTree; Source: TObjetFull = nil): Boolean;
begin
  Result := ModifierParaBD2(VT.CurrentValue);
  if Result then
    VT.InitializeRep;
end;

function AcheterParaBD(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then
    Exit;
  Result := EditionParaBD(i, False, '', True);
  if Result then
    VT.InitializeRep;
end;

function SupprimerParaBD(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then
    Exit;
  VT.MemorizeIndexNode;
  if AffMessage(rsLienParaBD + #13 + rsSupprimerParaBD, mtConfirmation, [mbYes, mbNo], True) <> mrYes then
    Exit;
  Result := DelParaBD(i);
  if Result then
  begin
    VT.InitializeRep(False);
    VT.FindIndexNode;
  end
  else
    VT.ClearIndexNode;
end;
// *********************************************************************************************************

function AjouterAchatsParaBD(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
begin
  Result := CreationAchatParaBD(Valeur);
  if IsEqualGUID(Result, GUID_NULL) then
    Exit;
  if Assigned(VT) then
  begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierAchatsParaBD(VT: TVirtualStringTree; Source: TObjetFull = nil): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then
    Exit;
  Result := EditionAchatParaBD(i);
  if Result then
    VT.InitializeRep;
end;

function SupprimerAchatsParaBD(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
  PA: TParaBDLite;
  s: string;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then
    Exit;
  VT.MemorizeIndexNode;
  PA := VT.GetFocusedNodeData as TParaBDLite;
  s := rsSupprimerAchat;
  if Assigned(PA) and not PA.Complet then
    s := rsLienAchatParaBD + #13 + s;
  if AffMessage(s, mtConfirmation, [mbYes, mbNo], True) <> mrYes then
    Exit;
  Result := DelAchatParaBD(i);
  if Result then
  begin
    VT.InitializeRep(False);
    VT.FindIndexNode;
  end
  else
    VT.ClearIndexNode;
end;

// *********************************************************************************************************
end.
