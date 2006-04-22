unit Form_EditCollection;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Mask, DBCtrls, ExtCtrls, ComCtrls, VDTButton,
  Buttons, DBEditLabeled, VirtualTrees, VirtualTree, Frame_RechercheRapide,
  Fram_Boutons;

type
  TFrmEditCollection = class(TForm)
    ScrollBox1: TScrollBox;
    Label2: TLabel;
    edNom: TEditLabeled;
    Label5: TLabel;
    vtEditeurs: TVirtualStringTree;
    FrameRechercheRapide1: TFrameRechercheRapide;
    Bevel1: TBevel;
    Frame11: TFrame1;
    procedure FormCreate(Sender: TObject);
    procedure Frame11btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure vtEditeursDblClick(Sender: TObject);
  private
    { Déclarations privées }
    FID_Collection: TGUID;
    FCreation: Boolean;
    procedure SetID_Collection(Value: TGUID);
  public
    { Déclarations publiques }
    FID_Editeur: TGUID;
    property ID_Collection: TGUID read FID_Collection write SetID_Collection;
  end;

implementation

uses
  JvUIB, Commun, DM_Princ, Procedures, Proc_Gestions,
  Textes;

{$R *.DFM}

procedure TFrmEditCollection.FormCreate(Sender: TObject);
begin
  FID_Editeur := GUID_NULL;
  PrepareLV(Self);
  vtEditeurs.Mode := vmEditeurs;
  FrameRechercheRapide1.VirtualTreeView := vtEditeurs;
end;

procedure TFrmEditCollection.SetID_Collection(Value: TGUID);
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  FID_Collection := Value;
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    SQL.Text := 'SELECT NOMCOLLECTION, ID_Editeur FROM COLLECTIONS WHERE ID_Collection = ?';
    Params.AsString[0] := GUIDToString(FID_Collection);
    Open;
    FCreation := Eof;
    if not FCreation then begin
      edNom.Text := Fields.ByNameAsString['NOMCOLLECTION'];
      FID_Editeur := StringToGUID(Fields.ByNameAsString['ID_EDITEUR']);
      vtEditeurs.Enabled := False;
      FrameRechercheRapide1.Enabled := False;
    end;
    vtEditeurs.CurrentValue := FID_Editeur;
  finally
    Transaction.Free;
    Free;
  end;
end;

procedure TFrmEditCollection.Frame11btnOKClick(Sender: TObject);
var
  ID_Editeur: TGUID;
begin
  if Length(Trim(edNom.Text)) = 0 then begin
    AffMessage(rsNomObligatoire, mtInformation, [mbOk], True);
    edNom.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;
  ID_Editeur := vtEditeurs.CurrentValue;
  if IsEqualGUID(ID_Editeur, GUID_NULL) then begin
    AffMessage(rsEditeurObligatoire, mtInformation, [mbOk], True);
    FrameRechercheRapide1.edSearch.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;
  with TJvUIBQuery.Create(nil) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    if FCreation then
      SQL.Text := 'INSERT INTO COLLECTIONS (ID_Collection, NOMCOLLECTION, ID_Editeur) VALUES (:ID_Collection, :NOMCOLLECTION, :ID_Editeur)'
    else
      SQL.Text := 'UPDATE COLLECTIONS SET NOMCOLLECTION = :NOMCOLLECTION, ID_Editeur = :ID_Editeur WHERE ID_Collection = :ID_Collection';
    Params.ByNameAsString['NOMCOLLECTION'] := Trim(edNom.Text);
    Params.ByNameAsString['ID_EDITEUR'] := GUIDToString(ID_Editeur);
    Params.ByNameAsString['ID_COLLECTION'] := GUIDToString(ID_Collection);
    ExecSQL;
    Transaction.Commit;
  finally
    Transaction.Free;
    Free;
  end;
  ModalResult := mrOk;
end;

procedure TFrmEditCollection.FormShow(Sender: TObject);
begin
  edNom.SetFocus;
end;

procedure TFrmEditCollection.vtEditeursDblClick(Sender: TObject);
begin
  ModifierEditeurs(vtEditeurs);
end;

end.

