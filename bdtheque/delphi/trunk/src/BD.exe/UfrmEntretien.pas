unit UfrmEntretien;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  VirtualTrees, VDTButton, Vcl.ExtCtrls, VCL.ActnList, Browss, Vcl.StdActns, BDTK.GUI.Utils, BD.GUI.Forms,
  PngSpeedButton, System.Actions;

type
  TfrmEntretien = class(TbdtForm)
    Panel14: TPanel;
    VDTButton20: TVDTButton;
    vstEntretien: TVirtualStringTree;
    ActionList1: TActionList;
    actCompresser: TAction;
    actExtraire: TAction;
    actConvertir: TAction;
    actNettoyer: TAction;
    BrowseDirectoryDlg1: TBrowseDirectoryDlg;
    Label1: TLabel;
    BDDRestore: TFileOpen;
    BDDBackup: TFileSaveAs;
    BDDOpen: TFileOpen;
    procedure VDTButton20Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure vstEntretienGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstEntretienPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure vstEntretienCollapsing(Sender: TBaseVirtualTree; Node: PVirtualNode; var Allowed: Boolean);
    procedure vstEntretienInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstEntretienResize(Sender: TObject);
    procedure vstEntretienDblClick(Sender: TObject);
    procedure actCompresserExecute(Sender: TObject);
    procedure actConvertirExecute(Sender: TObject);
    procedure actExtraireExecute(Sender: TObject);
    procedure actNettoyerExecute(Sender: TObject);
    procedure BDDBackupAccept(Sender: TObject);
    procedure BDDRestoreAccept(Sender: TObject);
    procedure BDDRestoreBeforeExecute(Sender: TObject);
    procedure BDDBackupBeforeExecute(Sender: TObject);
    procedure BDDOpenBeforeExecute(Sender: TObject);
    procedure BDDOpenAccept(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure vstEntretienFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
  private
    procedure CheckDBVersion;
  end;

implementation

uses
  System.IOUtils, BDTK.GUI.Forms.Main, BD.Common, BDTK.GUI.DataModules.Main, UIB, BD.Utils.StrUtils, BD.Utils.GUIUtils, BD.Strings,
  BD.GUI.Forms.Verbose, UHistorique, UfrmGestion, System.IniFiles, System.Math, uiblib,
  BD.DB.Connection;

{$R *.dfm}

const
  AdjustStr = ' ****'; // utilisée pour pallier à un défaut du VirtualTreeView ou de Windows

type
  PActionNodeData = ^RActionNodeData;

  RActionNodeData = record
    Texte, Description: string;
    Action: TCustomAction;
  end;

procedure TfrmEntretien.VDTButton20Click(Sender: TObject);
begin
  ModalResult := mrCancel;
  Release;
end;

procedure TfrmEntretien.FormCreate(Sender: TObject);

  function AddNode(Parent: PVirtualNode; act: TCustomAction): PVirtualNode; overload;
  var
    ActionNodeData: PActionNodeData;
  begin
    Result := vstEntretien.AddChild(Parent);
    ActionNodeData := vstEntretien.GetNodeData(Result);
    ActionNodeData.Texte := act.Caption;
    ActionNodeData.Description := act.Hint + AdjustStr;
    ActionNodeData.Action := act;
  end;

  function AddNode(Parent: PVirtualNode; const Texte: string): PVirtualNode; overload;
  var
    ActionNodeData: PActionNodeData;
  begin
    Result := vstEntretien.AddChild(Parent);
    ActionNodeData := vstEntretien.GetNodeData(Result);
    ActionNodeData.Texte := Texte;
    ActionNodeData.Description := AdjustStr;
    ActionNodeData.Action := nil;
  end;

var
  Node: PVirtualNode;
  s: string;
  act: TContainedAction;
begin
  BDDOpen.Hint := TGlobalVar.DatabasePath;
  vstEntretien.NodeDataSize := SizeOf(RActionNodeData);
  s := '';
  Node := nil;
  for act in ActionList1 do
    if act is TCustomAction then
    begin
      if not Assigned(Node) or (s <> act.Category) then
        Node := AddNode(nil, act.Category);
      s := act.Category;
      AddNode(Node, TCustomAction(act));
    end;

  vstEntretien.FullExpand;
end;

procedure TfrmEntretien.FormDestroy(Sender: TObject);
begin
  case TGlobalVar.Mode_en_cours of
    mdConsult:
      begin
        frmFond.actActualiseRepertoire.Execute;
        Historique.Clear;
      end;
    mdEdit:
      begin
        if frmFond.FCurrentForm is TFrmGestions then
          TFrmGestions(frmFond.FCurrentForm).VirtualTreeView.InitializeRep;
      end;
  end;
end;

procedure TfrmEntretien.vstEntretienGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  s: string;
begin
  case Column of
    0:
      CellText := PActionNodeData(vstEntretien.GetNodeData(Node))^.Texte;
    1:
      begin
        s := PActionNodeData(vstEntretien.GetNodeData(Node))^.Description;
        CellText := Copy(s, 1, Length(s) - Length(AdjustStr));
      end;
  end;
end;

procedure TfrmEntretien.vstEntretienPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
begin
  if vstEntretien.GetNodeLevel(Node) = 0 then
    TargetCanvas.Font.Style := [fsBold];
  if Column = 1 then
    TargetCanvas.Font.Color := clInactiveCaptionText;
end;

procedure TfrmEntretien.vstEntretienCollapsing(Sender: TBaseVirtualTree; Node: PVirtualNode; var Allowed: Boolean);
begin
  Allowed := False;
end;

procedure TfrmEntretien.vstEntretienInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  r: TRect;
  s: string;
  oldBottom: Integer;
  ActionNodeData: PActionNodeData;
begin
  ActionNodeData := vstEntretien.GetNodeData(Node);
  s := ActionNodeData.Description;
  r := Rect(0, 0, vstEntretien.Header.Columns[1].Width, 15);
  if s = '' then
  begin
    s := ActionNodeData.Texte;
    r := Rect(0, 0, vstEntretien.Header.Columns[0].Width, 15);
  end;
  oldBottom := r.Bottom;
  vstEntretien.NodeHeight[Node] := 8 + DrawText(vstEntretien.Canvas.Handle, PChar(s), Length(s), r, DT_CALCRECT or DT_WORDBREAK);
  if oldBottom <> r.Bottom then
    Include(InitialStates, ivsMultiline);
end;

procedure TfrmEntretien.vstEntretienResize(Sender: TObject);
begin
  vstEntretien.ReinitNode(vstEntretien.RootNode, True);
end;

procedure TfrmEntretien.vstEntretienDblClick(Sender: TObject);

var
  ActionNodeData: PActionNodeData;
begin
  ActionNodeData := vstEntretien.GetNodeData(vstEntretien.FocusedNode);
  if Assigned(ActionNodeData.Action) then
    ActionNodeData.Action.Execute;
end;

procedure TfrmEntretien.CheckDBVersion;
var
  Info: TInformation;
begin
  Info := TInformation.Create;
  try
    if not(dmPrinc.OuvreSession(True) and (dmPrinc.CheckDBVersion(Info.ShowInfo, False) or (BDDOpen.Execute and BDDOpen.ExecuteResult))) then
    begin
      VDTButton20.Click;
      Application.Terminate;
    end;
  finally
    Info.Free;
  end;
end;

procedure TfrmEntretien.actCompresserExecute(Sender: TObject);
begin
  ShowMessage('Pour effectuer cette opération: Sauvez la base puis Restaurez là.');
end;

procedure TfrmEntretien.actConvertirExecute(Sender: TObject);
var
  nbConverti, nbAConvertir, i: Integer;
  UpdateQuery: TUIBQuery;
  Fichier: string;
  Stream: TStream;
  fWaiting: IWaiting;
  FichiersImages: TStringList;
  qry: TManagedQuery;
begin
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsOperationEnCours, 0, 100);
  UpdateQuery := TUIBQuery.Create(Self);
  FichiersImages := TStringList.Create;
  qry := dmPrinc.DBConnection.GetQuery;
  try
    UpdateQuery.Transaction := qry.Transaction;
    qry.SQL.Text := 'select count(id_couverture) from couvertures where stockagecouverture = 0';
    qry.Open;
    nbAConvertir := qry.Fields.AsInteger[0];
    fWaiting.ShowProgression(rsOperationEnCours, 0, nbAConvertir);
    qry.SQL.Text := 'select id_couverture, fichiercouverture from couvertures where stockagecouverture = 0';
    UpdateQuery.SQL.Text := 'update couvertures set fichiercouverture = :fichiercouverture, stockagecouverture = 1, imagecouverture = :imagecouverture where id_couverture = :id_couverture';
    nbConverti := 0;
    qry.Open;
    while not qry.Eof do
    begin
      Fichier := qry.Fields.AsString[1];
      UpdateQuery.Prepare(True);
      UpdateQuery.Params.AsString[0] := Copy(TPath.GetFileNameWithoutExtension(Fichier), 1, UpdateQuery.Params.MaxStrLen[0]);
      if TPath.GetDirectoryName(Fichier) = '' then
        FichiersImages.Add(TPath.Combine(TGlobalVar.RepImages, Fichier))
      else
        FichiersImages.Add(Fichier);
      Stream := GetCouvertureStream(False, StringToGUID(qry.Fields.AsString[0]), -1, -1, False);
      try
        UpdateQuery.ParamsSetBlob(1, Stream);
      finally
        Stream.Free;
      end;
      UpdateQuery.Params.AsString[2] := qry.Fields.AsString[0];
      UpdateQuery.Execute;
      Inc(nbConverti);
      if (nbConverti mod 1000) = 0 then
        qry.Transaction.CommitRetaining;
      if (nbConverti mod (Max(100, nbAConvertir) div 100)) = 0 then
        fWaiting.ShowProgression(rsOperationEnCours, nbConverti, nbAConvertir);
      qry.Next;
    end;
    qry.Transaction.Commit;
    if FichiersImages.Count > 0 then
    begin
      qry.Transaction.StartTransaction;
      qry.SQL.Text := 'select * from deletefile(:fichier)';
      qry.Prepare(True);
      for i := 0 to Pred(FichiersImages.Count) do
      begin
        qry.Params.AsString[0] := Copy(FichiersImages[i], 1, qry.Params.MaxStrLen[0]);
        qry.Open;
        if qry.Fields.AsInteger[0] <> 0 then
          ShowMessage(FichiersImages[i] + #13#13 + SysErrorMessage(qry.Fields.AsInteger[0]));
      end;
      qry.Transaction.Commit;
    end;
    fWaiting := nil;
    ShowMessageFmt('%d liens convertis sur %d à convertir.', [nbConverti, nbAConvertir]);
  finally
    qry.Free;
    FichiersImages.Free;
    UpdateQuery.Free;
  end;
end;

procedure TfrmEntretien.actExtraireExecute(Sender: TObject);
var
  nbExtrais, nbAExtraire: Integer;
  ExtractQuery, UpdateQuery: TUIBQuery;
  Fichier: string;
  Stream: TStream;
  fWaiting: IWaiting;
  qry: TManagedQuery;
begin
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsOperationEnCours, 0, 100);
  UpdateQuery := TUIBQuery.Create(Self);
  ExtractQuery := TUIBQuery.Create(Self);
  qry := dmPrinc.DBConnection.GetQuery;
  try
    UpdateQuery.Transaction := qry.Transaction;
    ExtractQuery.Transaction := qry.Transaction;
    qry.SQL.Text := 'select count(id_couverture) from couvertures where stockagecouverture = 1';
    qry.Open;
    nbAExtraire := qry.Fields.AsInteger[0];
    fWaiting.ShowProgression(rsOperationEnCours, 0, nbAExtraire);
    qry.SQL.Text := 'select id_couverture, fichiercouverture from couvertures where stockagecouverture = 1';
    UpdateQuery.SQL.Text := 'update couvertures set fichiercouverture = :fichiercouverture, stockagecouverture = 0, imagecouverture = null where id_couverture = :id_couverture';
    UpdateQuery.Prepare(True);
    ExtractQuery.SQL.Text := 'select result from saveblobtofile(:chemin, :fichier, :blobcontent)';
    ExtractQuery.Prepare(True);
    nbExtrais := 0;
    qry.Open;
    while not qry.Eof do
    begin
      Fichier := SearchNewFileName(TGlobalVar.RepImages, qry.Fields.AsString[1] + '.jpg', True);
      ExtractQuery.Params.AsString[0] := Copy(TGlobalVar.RepImages, 1, ExtractQuery.Params.MaxStrLen[0]);
      ExtractQuery.Params.AsString[1] := Copy(Fichier, 1, ExtractQuery.Params.MaxStrLen[1]);
      Stream := GetCouvertureStream(False, StringToGUID(qry.Fields.AsString[0]), -1, -1, False);
      try
        ExtractQuery.ParamsSetBlob(2, Stream);
      finally
        Stream.Free;
      end;
      ExtractQuery.Open;

      UpdateQuery.Params.AsString[0] := Copy(Fichier, 1, UpdateQuery.Params.MaxStrLen[0]);
      UpdateQuery.Params.AsString[1] := qry.Fields.AsString[0];
      UpdateQuery.Execute;
      Inc(nbExtrais);
      if (nbExtrais mod 1000) = 0 then
        qry.Transaction.CommitRetaining;
      if (nbExtrais mod (Max(100, nbAExtraire) div 100)) = 0 then
        fWaiting.ShowProgression(rsOperationEnCours, nbExtrais, nbAExtraire);
      qry.Next;
    end;
    qry.Transaction.Commit;
    fWaiting := nil;
    ShowMessageFmt('%d Couvertures extraites sur %d à extraire.'#13#10'Répertoire de destination: %s', [nbExtrais, nbAExtraire, TGlobalVar.RepImages]);
  finally
    qry.Free;
    UpdateQuery.Free;
    ExtractQuery.Free;
  end;
end;

procedure TfrmEntretien.actNettoyerExecute(Sender: TObject);
var
  nbSupprime, nbASupprimer: Integer;
  UpdateQuery: TUIBQuery;
  Stream: TStream;
  fWaiting: IWaiting;
  qry: TManagedQuery;
begin
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsOperationEnCours, 0, 100);
  UpdateQuery := TUIBQuery.Create(Self);
  qry := dmPrinc.DBConnection.GetQuery;
  try
    UpdateQuery.Transaction := qry.Transaction;
    qry.SQL.Text := 'select count(id_couverture) from couvertures where stockagecouverture = 0';
    qry.Open;
    nbASupprimer := qry.Fields.AsInteger[0];
    fWaiting.ShowProgression(rsOperationEnCours, 0, nbASupprimer);
    qry.SQL.Text := 'select id_couverture, fichiercouverture from couvertures where stockagecouverture = 0';
    UpdateQuery.SQL.Text := 'delete from couvertures where id_couverture = :id_couverture';
    nbSupprime := 0;
    qry.Open;
    while not qry.Eof do
    begin
      Stream := GetCouvertureStream(False, StringToGUID(qry.Fields.AsString[0]), -1, -1, False);
      try
        if not Assigned(Stream) then
        begin
          UpdateQuery.Params.AsString[0] := qry.Fields.AsString[0];
          UpdateQuery.Execute;
          Inc(nbSupprime);
          if (nbSupprime mod 1000) = 0 then
            qry.Transaction.CommitRetaining;
        end;
      finally
        Stream.Free;
      end;
      qry.Next;
      if (nbSupprime mod (Max(100, nbASupprimer) div 100)) = 0 then
        fWaiting.ShowProgression(rsOperationEnCours, nbSupprime, nbASupprimer);
    end;
    qry.Transaction.Commit;
    fWaiting := nil;
    ShowMessageFmt('%d liens supprimé(s) sur %d.', [nbSupprime, nbASupprimer]);
  finally
    qry.Free;
    UpdateQuery.Free;
  end;
end;

procedure TfrmEntretien.BDDBackupBeforeExecute(Sender: TObject);
begin
  BDDBackup.Dialog.InitialDir := TPath.GetDirectoryName(TGlobalVar.DatabasePath);
  BDDBackup.Dialog.FileName := TPath.ChangeExtension(TGlobalVar.DatabasePath, '.gbk');
end;

procedure TfrmEntretien.BDDBackupAccept(Sender: TObject);
begin
  dmPrinc.doBackup(BDDBackup.Dialog.FileName);
end;

procedure TfrmEntretien.BDDRestoreBeforeExecute(Sender: TObject);
begin
  BDDRestore.Dialog.InitialDir := TPath.GetDirectoryName(TGlobalVar.DatabasePath);
  BDDRestore.Dialog.FileName := TPath.ChangeExtension(TGlobalVar.DatabasePath, '.gbk');
end;

procedure TfrmEntretien.BDDRestoreAccept(Sender: TObject);
begin
  dmPrinc.doRestore(BDDRestore.Dialog.FileName);
  CheckDBVersion;
end;

procedure TfrmEntretien.BDDOpenBeforeExecute(Sender: TObject);
begin
  BDDOpen.Dialog.InitialDir := TPath.GetDirectoryName(TGlobalVar.DatabasePath);
  BDDOpen.Dialog.FileName := TGlobalVar.DatabasePath;
end;

procedure TfrmEntretien.BDDOpenAccept(Sender: TObject);
var
  ini: TIniFile;
begin
  TGlobalVar.DatabasePath := BDDOpen.Dialog.FileName;
  BDDOpen.Hint := TGlobalVar.DatabasePath;
  ini := TIniFile.Create(TGlobalVar.FichierIni);
  try
    ini.WriteString('Database', 'Database', TGlobalVar.DatabasePath);
  finally
    ini.Free;
  end;
  dmPrinc.DBConnection.GetDatabase.Connected := False;
  CheckDBVersion;
  vstEntretien.Invalidate;
end;

procedure TfrmEntretien.vstEntretienFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  ActionNodeData: PActionNodeData;
begin
  ActionNodeData := vstEntretien.GetNodeData(Node);
  Finalize(ActionNodeData^);
end;

end.
