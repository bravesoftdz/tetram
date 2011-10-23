unit UfrmEntretien;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons,
  VirtualTrees, VDTButton, ExtCtrls, ActnList, Browss, StdActns, ProceduresBDtk, UBdtForms,
  PngSpeedButton;

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
    { Déclarations privées }
    procedure CheckVersions;
  public
    { Déclarations publiques }
  end;

implementation

uses UfrmFond, CommonConst, UdmPrinc, UIB, Commun, Procedures, Textes,
  UfrmVerbose, UHistorique, UfrmGestion, IniFiles, Math, uiblib;

{$R *.dfm}

const
  AdjustStr = ' ****'; // utilisée pour pallier à un défaut du VirtualTreeView ou de Windows

type
  PActionNodeData = ^RActionNodeData;
  RActionNodeData = record
    Texte, Description: string;
    Action: TCustomAction
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
  BDDOpen.Hint := DatabasePath;
  vstEntretien.NodeDataSize := SizeOf(RActionNodeData);
  s := '';
  Node := nil;
  for act in ActionList1 do
    if act is TCustomAction then
    begin
      if not Assigned(Node) or (s <> act.Category) then Node := AddNode(nil, act.Category);
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
    0: CellText := PActionNodeData(vstEntretien.GetNodeData(Node))^.Texte;
    1:
      begin
        s := PActionNodeData(vstEntretien.GetNodeData(Node))^.Description;
        CellText := Copy(s, 1, Length(s) - Length(AdjustStr));
      end;
  end;
end;

procedure TfrmEntretien.vstEntretienPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
begin
  if vstEntretien.GetNodeLevel(Node) = 0 then TargetCanvas.Font.Style := [fsBold];
  if Column = 1 then TargetCanvas.Font.Color := clInactiveCaptionText;
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
  if oldBottom <> r.Bottom then Include(InitialStates, ivsMultiline);
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
  if Assigned(ActionNodeData.Action) then ActionNodeData.Action.Execute;
end;

procedure TfrmEntretien.CheckVersions;
var
  Info: TInformation;
begin
  Info := TInformation.Create;
  try
    if not (OuvreSession and (DMPrinc.CheckVersions(Info.ShowInfo, False) or (BDDOpen.Execute and BDDOpen.ExecuteResult))) then
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
begin
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsOperationEnCours, 0, 100);
  UpdateQuery := TUIBQuery.Create(Self);
  FichiersImages := TStringList.Create;
  with TUIBQuery.Create(Self) do
  try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    UpdateQuery.Transaction := Transaction;
    SQL.Text := 'select count(id_couverture) from couvertures where stockagecouverture = 0';
    Open;
    nbAConvertir := Fields.AsInteger[0];
    fWaiting.ShowProgression(rsOperationEnCours, 0, nbAConvertir);
    SQL.Text := 'select id_couverture, fichiercouverture from couvertures where stockagecouverture = 0';
    UpdateQuery.SQL.Text := 'update couvertures set fichiercouverture = :fichiercouverture, stockagecouverture = 1, imagecouverture = :imagecouverture where id_couverture = :id_couverture';
    nbConverti := 0;
    Open;
    while not Eof do
    begin
      Fichier := Fields.AsString[1];
      UpdateQuery.Prepare(True);
      UpdateQuery.Params.AsString[0] := Copy(ChangeFileExt(ExtractFileName(Fichier), ''), 1, UpdateQuery.Params.MaxStrLen[0]);
      if ExtractFilePath(Fichier) = '' then
        FichiersImages.Add(RepImages + Fichier)
      else
        FichiersImages.Add(Fichier);
      Stream := GetCouvertureStream(False, StringToGUID(Fields.AsString[0]), -1, -1, False);
      try
        UpdateQuery.ParamsSetBlob(1, Stream);
      finally
        Stream.Free;
      end;
      UpdateQuery.Params.AsString[2] := Fields.AsString[0];
      UpdateQuery.ExecSQL;
      Inc(nbConverti);
      if (nbConverti mod 1000) = 0 then Transaction.CommitRetaining;
      if (nbConverti mod (Max(100, nbAConvertir) div 100)) = 0 then fWaiting.ShowProgression(rsOperationEnCours, nbConverti, nbAConvertir);
      Next;
    end;
    Transaction.Commit;
    if FichiersImages.Count > 0 then
    begin
      Transaction.StartTransaction;
      SQL.Text := 'select * from deletefile(:fichier)';
      Prepare(True);
      for i := 0 to Pred(FichiersImages.Count) do
      begin
        Params.AsString[0] := Copy(FichiersImages[i], 1, Params.MaxStrLen[0]);
        Open;
        if Fields.AsInteger[0] <> 0 then
          ShowMessage(FichiersImages[i] + #13#13 + SysErrorMessage(Fields.AsInteger[0]));
      end;
      Transaction.Commit;
    end;
    fWaiting := nil;
    ShowMessageFmt('%d liens convertis sur %d à convertir.', [nbConverti, nbAConvertir]);
  finally
    Transaction.Free;
    Free;
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
begin
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsOperationEnCours, 0, 100);
  UpdateQuery := TUIBQuery.Create(Self);
  ExtractQuery := TUIBQuery.Create(Self);
  with TUIBQuery.Create(Self) do
  try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    UpdateQuery.Transaction := Transaction;
    ExtractQuery.Transaction := Transaction;
    SQL.Text := 'select count(id_couverture) from couvertures where stockagecouverture = 1';
    Open;
    nbAExtraire := Fields.AsInteger[0];
    fWaiting.ShowProgression(rsOperationEnCours, 0, nbAExtraire);
    SQL.Text := 'select id_couverture, fichiercouverture from couvertures where stockagecouverture = 1';
    UpdateQuery.SQL.Text := 'update couvertures set fichiercouverture = :fichiercouverture, stockagecouverture = 0, imagecouverture = null where id_couverture = :id_couverture';
    UpdateQuery.Prepare(True);
    ExtractQuery.SQL.Text := 'select result from saveblobtofile(:chemin, :fichier, :blobcontent)';
    ExtractQuery.Prepare(True);
    nbExtrais := 0;
    Open;
    while not Eof do
    begin
      Fichier := SearchNewFileName(RepImages, Fields.AsString[1] + '.jpg', True);
      ExtractQuery.Params.AsString[0] := Copy(RepImages, 1, ExtractQuery.Params.MaxStrLen[0]);
      ExtractQuery.Params.AsString[1] := Copy(Fichier, 1, ExtractQuery.Params.MaxStrLen[1]);
      Stream := GetCouvertureStream(False, StringToGUID(Fields.AsString[0]), -1, -1, False);
      try
        ExtractQuery.ParamsSetBlob(2, Stream);
      finally
        Stream.Free;
      end;
      ExtractQuery.Open;

      UpdateQuery.Params.AsString[0] := Copy(Fichier, 1, UpdateQuery.Params.MaxStrLen[0]);
      UpdateQuery.Params.AsString[1] := Fields.AsString[0];
      UpdateQuery.ExecSQL;
      Inc(nbExtrais);
      if (nbExtrais mod 1000) = 0 then Transaction.CommitRetaining;
      if (nbExtrais mod (Max(100, nbAExtraire) div 100)) = 0 then fWaiting.ShowProgression(rsOperationEnCours, nbExtrais, nbAExtraire);
      Next;
    end;
    Transaction.Commit;
    fWaiting := nil;
    ShowMessageFmt('%d Couvertures extraites sur %d à extraire.'#13#10'Répertoire de destination: %s', [nbExtrais, nbAExtraire, RepImages]);
  finally
    Transaction.Free;
    Free;
    UpdateQuery.Free;
  end;
end;

procedure TfrmEntretien.actNettoyerExecute(Sender: TObject);
var
  nbSupprime, nbASupprimer: Integer;
  UpdateQuery: TUIBQuery;
  Stream: TStream;
  fWaiting: IWaiting;
begin
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsOperationEnCours, 0, 100);
  UpdateQuery := TUIBQuery.Create(Self);
  with TUIBQuery.Create(Self) do
  try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    UpdateQuery.Transaction := Transaction;
    SQL.Text := 'select count(id_couverture) from couvertures where stockagecouverture = 0';
    Open;
    nbASupprimer := Fields.AsInteger[0];
    fWaiting.ShowProgression(rsOperationEnCours, 0, nbASupprimer);
    SQL.Text := 'select id_couverture, fichiercouverture from couvertures where stockagecouverture = 0';
    UpdateQuery.SQL.Text := 'delete from couvertures where id_couverture = :id_couverture';
    nbSupprime := 0;
    Open;
    while not Eof do
    begin
      Stream := GetCouvertureStream(False, StringToGUID(Fields.AsString[0]), -1, -1, False);
      try
        if not Assigned(Stream) then
        begin
          UpdateQuery.Params.AsString[0] := Fields.AsString[0];
          UpdateQuery.ExecSQL;
          Inc(nbSupprime);
          if (nbSupprime mod 1000) = 0 then Transaction.CommitRetaining;
        end;
      finally
        FreeAndNil(Stream);
      end;
      Next;
      if (nbSupprime mod (Max(100, nbASupprimer) div 100)) = 0 then fWaiting.ShowProgression(rsOperationEnCours, nbSupprime, nbASupprimer);
    end;
    Transaction.Commit;
    fWaiting := nil;
    ShowMessageFmt('%d liens supprimé(s) sur %d.', [nbSupprime, nbASupprimer]);
  finally
    Transaction.Free;
    Free;
    UpdateQuery.Free;
  end;
end;

procedure TfrmEntretien.BDDBackupBeforeExecute(Sender: TObject);
begin
  BDDBackup.Dialog.InitialDir := ExtractFilePath(DatabasePath);
  BDDBackup.Dialog.FileName := ChangeFileExt(DatabasePath, '.gbk');
end;

procedure TfrmEntretien.BDDBackupAccept(Sender: TObject);
begin
  with TFrmVerbose.Create(Self) do
  try
    Application.ProcessMessages;
    DMPrinc.UIBBackup.OnVerbose := UIBVerbose;
    DMPrinc.UIBBackup.Verbose := True;
    DMPrinc.UIBBackup.BackupFiles.Text := BDDBackup.Dialog.FileName;
    DMPrinc.UIBBackup.Run;
  finally
    // pas de free, c'est la fenêtre qui va s'auto-libérer
    Fin;
  end;
end;

procedure TfrmEntretien.BDDRestoreBeforeExecute(Sender: TObject);
begin
  BDDRestore.Dialog.InitialDir := ExtractFilePath(DatabasePath);
  BDDRestore.Dialog.FileName := ChangeFileExt(DatabasePath, '.gbk');
end;

procedure TfrmEntretien.BDDRestoreAccept(Sender: TObject);
begin
  with TFrmVerbose.Create(Self) do
  try
    DMPrinc.UIBDataBase.Connected := False;
    Application.ProcessMessages;
    DMPrinc.UIBRestore.OnVerbose := UIBVerbose;
    DMPrinc.UIBRestore.Verbose := True;
    DMPrinc.UIBRestore.BackupFiles.Text := BDDRestore.Dialog.FileName;
    DMPrinc.UIBRestore.Run;
  finally
    // pas de free, c'est la fenêtre qui va s'auto-libérer
    Fin;
  end;
  CheckVersions;
end;

procedure TfrmEntretien.BDDOpenBeforeExecute(Sender: TObject);
begin
  BDDOpen.Dialog.InitialDir := ExtractFilePath(DatabasePath);
  BDDOpen.Dialog.FileName := DatabasePath;
end;

procedure TfrmEntretien.BDDOpenAccept(Sender: TObject);
begin
  DatabasePath := BDDOpen.Dialog.FileName;
  BDDOpen.Hint := DatabasePath;
  with TIniFile.Create(FichierIni) do
  try
    WriteString('Database', 'Database', DatabasePath);
  finally
    Free;
  end;
  DMPrinc.UIBDataBase.Connected := False;
  CheckVersions;
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

