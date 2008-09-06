unit Form_EditCollection;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Mask, DBCtrls, ExtCtrls, ComCtrls, VDTButton,
  Buttons, DBEditLabeled, VirtualTrees, VirtualTree, Frame_RechercheRapide, LoadComplet,
  Fram_Boutons, UBdtForms;

type
  TFrmEditCollection = class(TbdtForm)
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
    procedure vtEditeursDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
    FCollection: TCollectionComplete;
    procedure SetID_Collection(const Value: TGUID);
    function GetID_Collection: TGUID;
  public
    { Déclarations publiques }
    property ID_Collection: TGUID read GetID_Collection write SetID_Collection;
  end;

implementation

uses
  JvUIB, Commun, Procedures, Proc_Gestions,
  Textes, UHistorique;

{$R *.DFM}

procedure TFrmEditCollection.FormCreate(Sender: TObject);
begin
  PrepareLV(Self);
  vtEditeurs.Mode := vmEditeurs;
  FrameRechercheRapide1.VirtualTreeView := vtEditeurs;
  FCollection := TCollectionComplete.Create;
end;

procedure TFrmEditCollection.SetID_Collection(const Value: TGUID);
var
  hg: IHourGlass;
begin
  hg := THourGlass.Create;
  FCollection.Fill(Value);

  edNom.Text := FCollection.NomCollection;
  vtEditeurs.CurrentValue := FCollection.ID_Editeur;

  vtEditeurs.Enabled := FCollection.RecInconnu;
  FrameRechercheRapide1.Enabled := vtEditeurs.Enabled;
end;

procedure TFrmEditCollection.Frame11btnOKClick(Sender: TObject);
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
  ID_Editeur := vtEditeurs.CurrentValue;
  if IsEqualGUID(ID_Editeur, GUID_NULL) then
  begin
    AffMessage(rsEditeurObligatoire, mtInformation, [mbOk], True);
    FrameRechercheRapide1.edSearch.SetFocus;
    ModalResult := mrNone;
    Exit;
  end;

  FCollection.NomCollection := Trim(edNom.Text);
  FCollection.ID_Editeur := ID_Editeur;

  FCollection.SaveToDatabase;

  ModalResult := mrOk;
end;

procedure TFrmEditCollection.vtEditeursDblClick(Sender: TObject);
begin
  Historique.AddWaiting(fcGestionModif, nil, nil, @ModifierEditeurs, vtEditeurs);
end;

function TFrmEditCollection.GetID_Collection: TGUID;
begin
  Result := FCollection.ID_Collection;
end;

procedure TFrmEditCollection.FormDestroy(Sender: TObject);
begin
  FCollection.Free;
end;

end.

