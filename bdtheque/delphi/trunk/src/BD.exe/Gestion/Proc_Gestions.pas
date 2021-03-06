﻿unit Proc_Gestions;

interface

uses
  editions, System.SysUtils, System.Classes, Vcl.Controls, Vcl.Dialogs, Data.DB, Vcl.DBCtrls, Divers, BD.Utils.StrUtils, Vcl.ComCtrls, BDTK.GUI.Controls.VirtualTree, BD.Entities.Full;

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
  BD.Strings, BD.Utils.GUIUtils, BD.Entities.Lite;

// ******************************************************************************************************

function AjouterEditeurs(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
begin
  if Assigned(Source) then
    Result := CreationEditeur(Source)
  else
    Result := CreationEditeur(Valeur);
  if IsEqualGUID(Result, GUID_NULL) then
    Exit;
  TVirtualStringTree.InitializeRep(vmPARENT_EDITEURS + vmCHILD_EDITEURS, VT);
  if Assigned(VT) then
    VT.CurrentValue := Result;
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
    TVirtualStringTree.InitializeRep(vmPARENT_EDITEURS + vmCHILD_EDITEURS);
end;

function SupprimerEditeurs(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then
    Exit;
  if AffMessage(rsLienEditeur + #13 + rsSupprimerEditeur, mtConfirmation, [mbYes, mbNo], True) <> mrYes then
    Exit;
  Result := DelEditeur(i);
  if Result then
    TVirtualStringTree.InitializeRep(vmPARENT_EDITEURS, vmCHILD_EDITEURS, i);
end;
// ********************************************************************************************************

function AjouterAchatsAlbum(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
begin
  Result := CreationAchatAlbum(Valeur);
  if IsEqualGUID(Result, GUID_NULL) then
    Exit;
  TVirtualStringTree.InitializeRep(vmPARENT_ALBUMS + vmCHILD_ALBUMS, VT);
  if Assigned(VT) then
    VT.InitializeRep(False);
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
    TVirtualStringTree.InitializeRep(vmPARENT_ALBUMS + vmCHILD_ALBUMS);
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
  PA := VT.GetFocusedNodeData as TAlbumLite;
  s := rsSupprimerAchat;
  if Assigned(PA) and not PA.Complet then
    s := rsLienAchatAlbum + #13 + s;
  if AffMessage(s, mtConfirmation, [mbYes, mbNo], True) <> mrYes then
    Exit;
  Result := DelAchatAlbum(i);
  if Result then
    TVirtualStringTree.InitializeRep(vmPARENT_ALBUMS, vmCHILD_ALBUMS, i);
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
  TVirtualStringTree.InitializeRep(vmPARENT_ALBUMS + vmCHILD_ALBUMS, VT);
  if Assigned(VT) then
    VT.CurrentValue := Result;
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
    TVirtualStringTree.InitializeRep(vmPARENT_ALBUMS + vmCHILD_ALBUMS);
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
    TVirtualStringTree.InitializeRep(vmPARENT_ALBUMS + vmCHILD_ALBUMS);
end;

function SupprimerAlbums(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then
    Exit;
  if AffMessage(rsLienAlbum + #13 + rsSupprimerAlbum, mtConfirmation, [mbYes, mbNo], True) <> mrYes then
    Exit;
  Result := DelAlbum(i);
  if Result then
    TVirtualStringTree.InitializeRep(vmPARENT_ALBUMS, vmCHILD_ALBUMS, i);
end;
// *********************************************************************************************************

function AjouterGenres(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
begin
  Result := CreationGenre(Valeur);
  if IsEqualGUID(Result, GUID_NULL) then
    Exit;
  TVirtualStringTree.InitializeRep(vmPARENT_GENRES + vmCHILD_GENRES, VT);
  if Assigned(VT) then
    VT.CurrentValue := Result;
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
    TVirtualStringTree.InitializeRep(vmPARENT_GENRES + vmCHILD_GENRES);
end;

function SupprimerGenres(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then
    Exit;
  if AffMessage(rsLienGenre + #13 + rsSupprimerGenre, mtConfirmation, [mbYes, mbNo], True) <> mrYes then
    Exit;
  Result := DelGenre(i);
  if Result then
    TVirtualStringTree.InitializeRep(vmPARENT_GENRES, vmCHILD_GENRES, i);
end;
// ********************************************************************************************************************

function AjouterAuteurs(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
begin
  Result := CreationAuteur(FormalizeNom(Valeur));
  if IsEqualGUID(Result, GUID_NULL) then
    Exit;
  TVirtualStringTree.InitializeRep(vmPARENT_PERSONNES + vmCHILD_PERSONNES, VT);
  if Assigned(VT) then
    VT.CurrentValue := Result;
end;

function AjouterAuteurs2(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
begin
  Result := CreationAuteur2(FormalizeNom(Valeur));
  if IsEqualGUID(Result, GUID_NULL) then
    Exit;
  TVirtualStringTree.InitializeRep(vmPARENT_PERSONNES + vmCHILD_PERSONNES, VT);
  if Assigned(VT) then
    VT.CurrentValue := Result;
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
    TVirtualStringTree.InitializeRep(vmPARENT_PERSONNES + vmCHILD_PERSONNES);
end;

function SupprimerAuteurs(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then
    Exit;
  if AffMessage(rsLienAuteur + #13 + rsSupprimerAuteur, mtConfirmation, [mbYes, mbNo], True) <> mrYes then
    Exit;
  Result := DelAuteur(i);
  if Result then
    TVirtualStringTree.InitializeRep(vmPARENT_PERSONNES, vmCHILD_PERSONNES, i);
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
  TVirtualStringTree.InitializeRep(vmPARENT_SERIES + vmCHILD_SERIES, VT);
  if Assigned(VT) then
    VT.CurrentValue := Result;
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
    TVirtualStringTree.InitializeRep(vmPARENT_SERIES + vmCHILD_SERIES);
end;

function SupprimerSeries(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then
    Exit;
  if AffMessage(rsLienSerie + #13 + rsSupprimerSerie, mtConfirmation, [mbYes, mbNo], True) <> mrYes then
    Exit;
  Result := DelSerie(i);
  if Result then
    TVirtualStringTree.InitializeRep(vmPARENT_SERIES, vmCHILD_SERIES, i);
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
  TVirtualStringTree.InitializeRep(vmPARENT_UNIVERS + vmCHILD_UNIVERS, VT);
  if Assigned(VT) then
    VT.CurrentValue := Result;
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
    TVirtualStringTree.InitializeRep(vmPARENT_UNIVERS + vmCHILD_UNIVERS);
end;

function SupprimerUnivers(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then
    Exit;
  if AffMessage(rsLienUnivers + #13 + rsSupprimerUnivers, mtConfirmation, [mbYes, mbNo], True) <> mrYes then
    Exit;
  Result := DelUnivers(i);
  if Result then
    TVirtualStringTree.InitializeRep(vmPARENT_UNIVERS, vmCHILD_UNIVERS, i);
end;
// ********************************************************************************************************************

function AjouterCollections2(VT: TVirtualStringTree; const ID_Editeur: TGUID; const Valeur: string): TGUID;
begin
  Result := CreationCollection(ID_Editeur, Valeur);
  if IsEqualGUID(Result, GUID_NULL) then
    Exit;
  TVirtualStringTree.InitializeRep(vmPARENT_COLLECTIONS + vmCHILD_COLLECTIONS, VT);
  if Assigned(VT) then
    VT.CurrentValue := Result;
end;

function AjouterCollections(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
begin
  if Assigned(Source) then
    Result := CreationCollection(Source)
  else
    Result := CreationCollection(GUID_NULL, Valeur);
  if IsEqualGUID(Result, GUID_NULL) then
    Exit;
  TVirtualStringTree.InitializeRep(vmPARENT_COLLECTIONS + vmCHILD_COLLECTIONS, VT);
  if Assigned(VT) then
    VT.CurrentValue := Result;
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
    TVirtualStringTree.InitializeRep(vmPARENT_COLLECTIONS + vmCHILD_COLLECTIONS);
end;

function SupprimerCollections(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then
    Exit;
  if AffMessage(rsLienCollection + #13 + rsSupprimerCollection, mtConfirmation, [mbYes, mbNo], True) <> mrYes then
    Exit;
  Result := DelCollection(i);
  if Result then
    TVirtualStringTree.InitializeRep(vmPARENT_COLLECTIONS, vmCHILD_COLLECTIONS, i);
end;
// ********************************************************************************************************************

function AjouterParaBD(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
begin
  Result := CreationParaBD(Valeur);
  if IsEqualGUID(Result, GUID_NULL) then
    Exit;
  TVirtualStringTree.InitializeRep(vmPARENT_PARABD + vmCHILD_PARABD, VT);
  if Assigned(VT) then
    VT.CurrentValue := Result;
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
    TVirtualStringTree.InitializeRep(vmPARENT_PARABD + vmCHILD_PARABD);
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
    TVirtualStringTree.InitializeRep(vmPARENT_PARABD + vmCHILD_PARABD);
end;

function SupprimerParaBD(VT: TVirtualStringTree): Boolean;
var
  i: TGUID;
begin
  Result := False;
  i := VT.CurrentValue;
  if IsEqualGUID(i, GUID_NULL) then
    Exit;
  if AffMessage(rsLienParaBD + #13 + rsSupprimerParaBD, mtConfirmation, [mbYes, mbNo], True) <> mrYes then
    Exit;
  Result := DelParaBD(i);
  if Result then
    TVirtualStringTree.InitializeRep(vmPARENT_PARABD, vmCHILD_PARABD, i);
end;
// *********************************************************************************************************

function AjouterAchatsParaBD(VT: TVirtualStringTree; const Valeur: string; Source: TObjetFull = nil): TGUID;
begin
  Result := CreationAchatParaBD(Valeur);
  if IsEqualGUID(Result, GUID_NULL) then
    Exit;
  TVirtualStringTree.InitializeRep(vmPARENT_PARABD + vmCHILD_PARABD, VT);
  if Assigned(VT) then
    VT.CurrentValue := Result;
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
    TVirtualStringTree.InitializeRep(vmPARENT_PARABD + vmCHILD_PARABD);
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
  PA := VT.GetFocusedNodeData as TParaBDLite;
  s := rsSupprimerAchat;
  if Assigned(PA) and not PA.Complet then
    s := rsLienAchatParaBD + #13 + s;
  if AffMessage(s, mtConfirmation, [mbYes, mbNo], True) <> mrYes then
    Exit;
  Result := DelAchatParaBD(i);
  if Result then
    TVirtualStringTree.InitializeRep(vmPARENT_PARABD, vmCHILD_PARABD, i);
end;

// *********************************************************************************************************
end.
