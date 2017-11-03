unit Proc_Gestions;

interface

uses
  editions, SysUtils, Classes, Controls, Dialogs, Forms, Db, DBCtrls, Divers, Commun, ComCtrls, VirtualTree, JvUIB;

type
  TActionGestionAdd = function(VT: TVirtualStringTree; Valeur: string): Integer;
  TActionGestionModif = function(VT: TVirtualStringTree): Boolean;
  TActionGestionSupp = function(VT: TVirtualStringTree): Boolean;

function AjouterEditeurs(VT: TVirtualStringTree; Valeur: string): Integer;
function ModifierEditeurs(VT: TVirtualStringTree): Boolean;
function SupprimerEditeurs(VT: TVirtualStringTree): Boolean;

function AjouterAchats(VT: TVirtualStringTree; Valeur: string): Integer;
function ModifierAchats(VT: TVirtualStringTree): Boolean;
function SupprimerAchats(VT: TVirtualStringTree): Boolean;

function AjouterAlbums(VT: TVirtualStringTree; Valeur: string): Integer;
function ModifierAlbums(VT: TVirtualStringTree): Boolean;
function AcheterAlbums(VT: TVirtualStringTree): Boolean;
function SupprimerAlbums(VT: TVirtualStringTree): Boolean;

function AjouterGenres(VT: TVirtualStringTree; Valeur: string): Integer;
function ModifierGenres(VT: TVirtualStringTree): Boolean;
function SupprimerGenres(VT: TVirtualStringTree): Boolean;

function AjouterAuteurs(VT: TVirtualStringTree; Valeur: string): Integer;
function AjouterAuteurs2(VT: TVirtualStringTree; Valeur: string): Integer;
function ModifierAuteurs(VT: TVirtualStringTree): Boolean;
function SupprimerAuteurs(VT: TVirtualStringTree): Boolean;

function AjouterSeries(VT: TVirtualStringTree; Valeur: string): Integer;
function ModifierSeries(VT: TVirtualStringTree): Boolean;
function SupprimerSeries(VT: TVirtualStringTree): Boolean;

function AjouterEmprunteurs(VT: TVirtualStringTree; Valeur: string): Integer;
function ModifierEmprunteurs(VT: TVirtualStringTree): Boolean;
function SupprimerEmprunteurs(VT: TVirtualStringTree): Boolean;

function AjouterCollections(VT: TVirtualStringTree; RefEditeur: Integer; Valeur: string): Integer; overload;
function AjouterCollections(VT: TVirtualStringTree; Valeur: string): Integer; overload;
function ModifierCollections(VT: TVirtualStringTree): Boolean;
function SupprimerCollections(VT: TVirtualStringTree): Boolean;

implementation

uses Textes, Procedures, DM_Princ;

//******************************************************************************************************

function AjouterEditeurs(VT: TVirtualStringTree; Valeur: string): Integer;
begin
  Result := CreationEditeur(Valeur);
  if Result = -1 then Exit;
  if Assigned(VT) then begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierEditeurs(VT: TVirtualStringTree): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := VT.CurrentValue;
  if i = -1 then Exit;
  Result := EditionEditeur(i);
  if Result then VT.InitializeRep;
end;

function SupprimerEditeurs(VT: TVirtualStringTree): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := VT.CurrentValue;
  if i = -1 then Exit;
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

function AjouterAchats(VT: TVirtualStringTree; Valeur: string): Integer;
begin
  Result := CreationAchat(Valeur);
  if Result = -1 then Exit;
  if Assigned(VT) then begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierAchats(VT: TVirtualStringTree): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := VT.CurrentValue;
  if i = -1 then Exit;
  Result := EditionAchat(i);
  if Result then VT.InitializeRep;
end;

function SupprimerAchats(VT: TVirtualStringTree): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := VT.CurrentValue;
  if i = -1 then Exit;
  VT.MemorizeIndexNode;
//  if AffMessage(rsLienAlbum + #13 + rsSupprimerAlbum, mtConfirmation, [mbYes, mbNo], True) <> mrYes then Exit;
  Result := DelAchat(i);
  if Result then begin
    VT.InitializeRep(False);
    VT.FindIndexNode;
  end
  else
    VT.ClearIndexNode;
end;
//*********************************************************************************************************

function AjouterAlbums(VT: TVirtualStringTree; Valeur: string): Integer;
begin
  Result := CreationAlbum(Valeur);
  if Result = -1 then Exit;
  if Assigned(VT) then begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierAlbums(VT: TVirtualStringTree): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := VT.CurrentValue;
  if i = -1 then Exit;
  Result := EditionAlbum(i);
  if Result then VT.InitializeRep;
end;

function AcheterAlbums(VT: TVirtualStringTree): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := VT.CurrentValue;
  if i = -1 then Exit;
  Result := EditionAlbum(i, False, '', True);
  if Result then VT.InitializeRep;
end;

function SupprimerAlbums(VT: TVirtualStringTree): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := VT.CurrentValue;
  if i = -1 then Exit;
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

function AjouterGenres(VT: TVirtualStringTree; Valeur: string): Integer;
begin
  Result := CreationGenre(Valeur);
  if Result = -1 then Exit;
  if Assigned(VT) then begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierGenres(VT: TVirtualStringTree): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := VT.CurrentValue;
  if i = -1 then Exit;
  Result := EditionGenre(i);
  if Result then VT.InitializeRep;
end;

function SupprimerGenres(VT: TVirtualStringTree): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := VT.CurrentValue;
  if i = -1 then Exit;
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

function AjouterAuteurs(VT: TVirtualStringTree; Valeur: string): Integer;
begin
  Result := CreationAuteur(Valeur);
  if Result = -1 then Exit;
  if Assigned(VT) then begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function AjouterAuteurs2(VT: TVirtualStringTree; Valeur: string): Integer;
begin
  Result := CreationAuteur2(Valeur);
  if Result = -1 then Exit;
  if Assigned(VT) then begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierAuteurs(VT: TVirtualStringTree): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := VT.CurrentValue;
  if i = -1 then Exit;
  Result := EditionAuteur(i);
  if Result then VT.InitializeRep;
end;

function SupprimerAuteurs(VT: TVirtualStringTree): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := VT.CurrentValue;
  if i = -1 then Exit;
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

function AjouterSeries(VT: TVirtualStringTree; Valeur: string): Integer;
begin
  Result := CreationSerie(Valeur);
  if Result = -1 then Exit;
  if Assigned(VT) then begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierSeries(VT: TVirtualStringTree): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := VT.CurrentValue;
  if i = -1 then Exit;
  Result := EditionSerie(i);
  if Result then VT.InitializeRep;
end;

function SupprimerSeries(VT: TVirtualStringTree): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := VT.CurrentValue;
  if i = -1 then Exit;
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

function AjouterEmprunteurs(VT: TVirtualStringTree; Valeur: string): Integer;
begin
  Result := CreationEmprunteur(Valeur);
  if Result = -1 then Exit;
  if Assigned(VT) then begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function ModifierEmprunteurs(VT: TVirtualStringTree): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := VT.CurrentValue;
  if i = -1 then Exit;
  Result := EditionEmprunteur(i);
  if Result then VT.InitializeRep;
end;

function SupprimerEmprunteurs(VT: TVirtualStringTree): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := VT.CurrentValue;
  if i = -1 then Exit;
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

function AjouterCollections(VT: TVirtualStringTree; RefEditeur: Integer; Valeur: string): Integer;
begin
  Result := CreationCollection(RefEditeur, Valeur);
  if Result = -1 then Exit;
  if Assigned(VT) then begin
    VT.InitializeRep(False);
    VT.CurrentValue := Result;
  end;
end;

function AjouterCollections(VT: TVirtualStringTree; Valeur: string): Integer;
begin
  Result := AjouterCollections(VT, -1, Valeur);
end;

function ModifierCollections(VT: TVirtualStringTree): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := VT.CurrentValue;
  if i = -1 then Exit;
  Result := EditionCollection(i);
  if Result then VT.InitializeRep;
end;

function SupprimerCollections(VT: TVirtualStringTree): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := VT.CurrentValue;
  if i = -1 then Exit;
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
end.

