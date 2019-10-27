unit UfrmEditCollection;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, VDTButton,
  Vcl.Buttons, EditLabeled, VirtualTrees, BDTK.GUI.Controls.VirtualTree, BDTK.GUI.Frames.QuickSearch, BD.Entities.Full,
  BD.GUI.Forms, UframVTEdit, BD.GUI.Frames.Buttons;

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
  BD.Utils.StrUtils, BD.Utils.GUIUtils, Proc_Gestions, BD.Strings, UHistorique, BD.Entities.Lite,
  BDTK.Entities.Dao.Full, BDTK.Entities.Dao.Lite, BD.Entities.Common;

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
  TDaoEditeurLite.Fill(FCollection.Editeur, ID_Editeur);
  FCollection.Associations.Text := edAssociations.Text;

  TDaoCollectionFull.SaveToDatabase(FCollection, nil);
  TDaoCollectionFull.SaveAssociations(FCollection, vmCollections, FCollection.Editeur.ID);

  ModalResult := mrOk;
end;

function TfrmEditCollection.GetID_Collection: TGUID;
begin
  Result := FCollection.ID_Collection;
end;

end.

