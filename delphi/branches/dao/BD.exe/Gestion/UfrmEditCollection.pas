unit UfrmEditCollection;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Mask, DBCtrls, ExtCtrls, ComCtrls, VDTButton,
  Buttons, EditLabeled, VirtualTrees, VirtualTree, UframRechercheRapide, EntitiesFull,
  UBdtForms, UframVTEdit, UframBoutons;

type
  TfrmEditCollection = class(TbdtForm)
    ScrollBox1: TScrollBox;
    Label2: TLabel;
    edNom: TEditLabeled;
    Label5: TLabel;
    Bevel1: TBevel;
    Frame11: TframBoutons;
    vtEditEditeurs: TframVTEdit;
    Label4: TLabel;
    edAssociations: TMemoLabeled;
    Bevel4: TBevel;
    Label28: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Frame11btnOKClick(Sender: TObject);
  private
    { Déclarations privées }
    FCollection: TCollectionFull;
    procedure SetCollection(Value: TCollectionFull);
    function GetID_Collection: TGUID;
  public
    { Déclarations publiques }
    property ID_Collection: TGUID read GetID_Collection;
    property Collection: TCollectionFull read FCollection write SetCollection;
  end;

implementation

uses
  Commun, Procedures, Proc_Gestions, Textes, UHistorique, EntitiesLite,
  DaoFull;

{$R *.DFM}

procedure TfrmEditCollection.FormCreate(Sender: TObject);
begin
  PrepareLV(Self);
  vtEditEditeurs.Mode := vmEditeurs;
  FCollection := nil;
end;

procedure TfrmEditCollection.SetCollection(Value: TCollectionFull);
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  FCollection := Value;
  TDaoCollectionFull.FillAssociations(FCollection, vmCollections);

  edNom.Text := FCollection.NomCollection;
  vtEditEditeurs.CurrentValue := FCollection.ID_Editeur;
  edAssociations.Lines.Text := FCollection.Associations.Text;

  vtEditEditeurs.Enabled := FCollection.RecInconnu;
end;

procedure TfrmEditCollection.Frame11btnOKClick(Sender: TObject);
var
  ID_Editeur: TGUID;
begin
  if Length(Trim(edNom.Text)) = 0 then
  begin
    AffMessage(rsNomObligatoire, mtInformation, [mbOk], True);
    edNom.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;
  ID_Editeur := vtEditEditeurs.CurrentValue;
  if IsEqualGUID(ID_Editeur, GUID_NULL) then
  begin
    AffMessage(rsEditeurObligatoire, mtInformation, [mbOk], True);
    vtEditEditeurs.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;

  FCollection.NomCollection := Trim(edNom.Text);
  FCollection.ID_Editeur := ID_Editeur;
  FCollection.Associations.Text := edAssociations.Text;

  FCollection.SaveToDatabase;
  TDaoCollectionFull.SaveAssociations(FCollection, vmCollections, FCollection.Editeur.ID);

  ModalResult := mrOk;
end;

function TfrmEditCollection.GetID_Collection: TGUID;
begin
  Result := FCollection.ID_Collection;
end;

end.

