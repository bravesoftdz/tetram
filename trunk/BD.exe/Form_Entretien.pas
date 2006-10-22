unit Form_Entretien;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons,
  VirtualTrees, VDTButton, ExtCtrls, ActnList, Browss, StdActns;

type
  TFrmEntretien = class(TForm)
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
    procedure vstEntretienGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
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
    procedure vstEntretienFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
  private
    { Déclarations privées }
    FServerWasActive: Boolean;
    procedure CheckVersions;
  public
    { Déclarations publiques }
  end;

implementation

uses Main, CommonConst, DM_Princ, JvUIB, Commun, Procedures, Textes,
  Form_Verbose, UHistorique, Form_Gestion, IniFiles;

{$R *.dfm}

const
  AdjustStr = ' ****'; // utilisée pour pallier à un défaut du VirtualTreeView ou de Windows

type
  PActionNodeData = ^RActionNodeData;
  RActionNodeData = record
    Texte, Description: string;
    Action: TCustomAction
  end;

procedure TFrmEntretien.VDTButton20Click(Sender: TObject);
begin
  ModalResult := mrCancel;
  Release;
end;

procedure TFrmEntretien.FormCreate(Sender: TObject);

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
  i: Integer;
  s: string;
  act: TCustomAction;
begin
  FServerWasActive := DMPrinc.HTTPServer.Active;
  DMPrinc.ActiveHTTPServer(False);
  BDDOpen.Hint := DatabasePath;
  vstEntretien.NodeDataSize := SizeOf(RActionNodeData);
  s := '';
  Node := nil;
  for i := 0 to Pred(ActionList1.ActionCount) do begin
    act := TCustomAction(ActionList1.Actions[i]);
    if not Assigned(Node) or (s <> act.Category) then Node := AddNode(nil, act.Category);
    s := act.Category;
    AddNode(Node, act);
  end;

  vstEntretien.FullExpand;
end;

procedure TFrmEntretien.FormDestroy(Sender: TObject);
begin
  case Mode_en_cours of
    mdConsult: begin
        Fond.ActualiseRepertoire.Execute;
        Historique.Clear;
      end;
    mdEdit: begin
        if Fond.FCurrentForm is TFrmGestions then
          TFrmGestions(Fond.FCurrentForm).VirtualTreeView.InitializeRep;
      end;
  end;
  DMPrinc.ActiveHTTPServer(FServerWasActive);
end;

procedure TFrmEntretien.vstEntretienGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var
  s: string;
begin
  case Column of
    0: CellText := PActionNodeData(vstEntretien.GetNodeData(Node))^.Texte;
    1: begin
        s := PActionNodeData(vstEntretien.GetNodeData(Node))^.Description;
        CellText := Copy(s, 1, Length(s) - Length(AdjustStr));
      end;
  end;
end;

procedure TFrmEntretien.vstEntretienPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
begin
  if vstEntretien.GetNodeLevel(Node) = 0 then TargetCanvas.Font.Style := [fsBold];
  if Column = 1 then TargetCanvas.Font.Color := clInactiveCaptionText;
end;

procedure TFrmEntretien.vstEntretienCollapsing(Sender: TBaseVirtualTree; Node: PVirtualNode; var Allowed: Boolean);
begin
  Allowed := False;
end;

procedure TFrmEntretien.vstEntretienInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  r: TRect;
  s: string;
  oldBottom: Integer;
  ActionNodeData: PActionNodeData;
begin
  ActionNodeData := vstEntretien.GetNodeData(Node);
  s := ActionNodeData.Description;
  r := Rect(0, 0, vstEntretien.Header.Columns[1].Width, 15);
  if s = '' then begin
    s := ActionNodeData.Texte;
    r := Rect(0, 0, vstEntretien.Header.Columns[0].Width, 15);
  end;
  oldBottom := r.Bottom;
  vstEntretien.NodeHeight[Node] := 8 + DrawText(vstEntretien.Canvas.Handle, PChar(s), Length(s), r, DT_CALCRECT or DT_WORDBREAK);
  if oldBottom <> r.Bottom then Include(InitialStates, ivsMultiline);
end;

procedure TFrmEntretien.vstEntretienResize(Sender: TObject);
begin
  vstEntretien.ReinitNode(vstEntretien.RootNode, True);
end;

procedure TFrmEntretien.vstEntretienDblClick(Sender: TObject);
var
  ActionNodeData: PActionNodeData;
begin
  ActionNodeData := vstEntretien.GetNodeData(vstEntretien.FocusedNode);
  if Assigned(ActionNodeData.Action) then ActionNodeData.Action.Execute;
end;

procedure TFrmEntretien.CheckVersions;
var
  Info: TInformation;
begin
  Info := TInformation.Create;
  try
    if not (OuvreSession and (DMPrinc.CheckVersions(Info.ShowInfo, False) or (BDDOpen.Execute and BDDOpen.ExecuteResult))) then begin
      VDTButton20.Click;
      Application.Terminate;
    end;
  finally
    Info.Free;
  end;
end;

procedure TFrmEntretien.actCompresserExecute(Sender: TObject);
begin
  ShowMessage('Pour effectuer cette opération: Sauvez la base puis Restaurez là.');
end;

procedure TFrmEntretien.actConvertirExecute(Sender: TObject);
var
  nbConverti, nbAConvertir, i: Integer;
  UpdateQuery: TJvUIBQuery;
  Fichier: string;
  Stream: TStream;
  fWaiting: IWaiting;
  FichiersImages: TStringList;
begin
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsOperationEnCours, 0, 100);
  UpdateQuery := TJvUIBQuery.Create(Self);
  FichiersImages := TStringList.Create;
  with TJvUIBQuery.Create(Self) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    UpdateQuery.Transaction := Transaction;
    SQL.Text := 'SELECT Count(ID_Couverture) FROM Couvertures WHERE STOCKAGECOUVERTURE = 0';
    Open;
    nbAConvertir := Fields.AsInteger[0];
    fWaiting.ShowProgression(rsOperationEnCours, 0, nbAConvertir);
    SQL.Text := 'SELECT ID_Couverture, FichierCouverture FROM Couvertures WHERE STOCKAGECOUVERTURE = 0';
    UpdateQuery.SQL.Text := 'UPDATE CouvertureS SET FichierCouverture = :FichierCouverture, STOCKAGECOUVERTURE = 1, IMAGECOUVERTURE = :IMAGECOUVERTURE WHERE ID_Couverture = :ID_Couverture';
    nbConverti := 0;
    Open;
    while not Eof do begin
      Fichier := Fields.AsString[1];
      UpdateQuery.Params.Parse(UpdateQuery.SQL.Text);
      UpdateQuery.Params.AsString[0] := ChangeFileExt(ExtractFileName(Fichier), '');
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
      UpdateQuery.Params.AsInteger[2] := Fields.AsInteger[0];
      UpdateQuery.ExecSQL;
      Inc(nbConverti);
      if (nbConverti mod 1000) = 0 then Transaction.CommitRetaining;
      fWaiting.ShowProgression(rsOperationEnCours, epNext);
      Next;
    end;
    Transaction.Commit;
    if FichiersImages.Count > 0 then begin
      Transaction.StartTransaction;
      SQL.Text := 'SELECT * FROM DELETEFILE(:Fichier)';
      for i := 0 to Pred(FichiersImages.Count) do begin
        Params.AsString[0] := FichiersImages[i];
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

procedure TFrmEntretien.actExtraireExecute(Sender: TObject);
var
  nbExtrais, nbAExtraire: Integer;
  ExtractQuery, UpdateQuery: TJvUIBQuery;
  Fichier: string;
  Stream: TStream;
  fWaiting: IWaiting;
begin
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsOperationEnCours, 0, 100);
  UpdateQuery := TJvUIBQuery.Create(Self);
  ExtractQuery := TJvUIBQuery.Create(Self);
  with TJvUIBQuery.Create(Self) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    UpdateQuery.Transaction := Transaction;
    ExtractQuery.Transaction := Transaction;
    SQL.Text := 'SELECT Count(ID_Couverture) FROM Couvertures WHERE STOCKAGECOUVERTURE = 1';
    Open;
    nbAExtraire := Fields.AsInteger[0];
    fWaiting.ShowProgression(rsOperationEnCours, 0, nbAExtraire);
    SQL.Text := 'SELECT ID_Couverture, FichierCouverture FROM Couvertures WHERE STOCKAGECOUVERTURE = 1';
    UpdateQuery.SQL.Text := 'UPDATE CouvertureS SET FichierCouverture = :FichierCouverture, STOCKAGECOUVERTURE = 0, IMAGECOUVERTURE = Null WHERE ID_Couverture = :ID_Couverture';
    ExtractQuery.SQL.Text := 'SELECT Result FROM SAVEBLOBTOFILE(:Chemin, :Fichier, :BlobContent)';
    nbExtrais := 0;
    Open;
    while not Eof do begin
      Fichier := SearchNewFileName(RepImages, Fields.AsString[1] + '.jpg', True);
      ExtractQuery.Params.AsString[0] := RepImages;
      ExtractQuery.Params.AsString[1] := Fichier;
      Stream := GetCouvertureStream(False, StringToGUID(Fields.AsString[0]), -1, -1, False);
      try
        ExtractQuery.ParamsSetBlob(2, Stream);
      finally
        Stream.Free;
      end;
      ExtractQuery.Open;

      UpdateQuery.Params.AsString[0] := Fichier;
      UpdateQuery.Params.AsInteger[1] := Fields.AsInteger[0];
      UpdateQuery.ExecSQL;
      Inc(nbExtrais);
      if (nbExtrais mod 1000) = 0 then Transaction.CommitRetaining;
      fWaiting.ShowProgression(rsOperationEnCours, epNext);
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

procedure TFrmEntretien.actNettoyerExecute(Sender: TObject);
var
  nbSupprime, nbASupprimer: Integer;
  UpdateQuery: TJvUIBQuery;
  Stream: TStream;
  fWaiting: IWaiting;
begin
  fWaiting := TWaiting.Create;
  fWaiting.ShowProgression(rsOperationEnCours, 0, 100);
  UpdateQuery := TJvUIBQuery.Create(Self);
  with TJvUIBQuery.Create(Self) do try
    Transaction := GetTransaction(DMPrinc.UIBDataBase);
    UpdateQuery.Transaction := Transaction;
    SQL.Text := 'SELECT Count(ID_Couverture) FROM Couvertures WHERE STOCKAGECOUVERTURE = 0';
    Open;
    nbASupprimer := Fields.AsInteger[0];
    fWaiting.ShowProgression(rsOperationEnCours, 0, nbASupprimer);
    SQL.Text := 'SELECT ID_Couverture, FichierCouverture FROM Couvertures WHERE STOCKAGECOUVERTURE = 0';
    UpdateQuery.SQL.Text := 'DELETE FROM CouvertureS WHERE ID_Couverture = :ID_Couverture';
    nbSupprime := 0;
    Open;
    while not Eof do begin
      Stream := GetCouvertureStream(False, StringToGUID(Fields.AsString[0]), -1, -1, False);
      try
        if not Assigned(Stream) then begin
          UpdateQuery.Params.AsInteger[0] := Fields.AsInteger[0];
          UpdateQuery.ExecSQL;
          Inc(nbSupprime);
          if (nbSupprime mod 1000) = 0 then Transaction.CommitRetaining;
        end;
      finally
        FreeAndNil(Stream);
      end;
      Next;
      fWaiting.ShowProgression(rsOperationEnCours, epNext);
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

procedure TFrmEntretien.BDDBackupBeforeExecute(Sender: TObject);
begin
  BDDBackup.Dialog.InitialDir := ExtractFilePath(DatabasePath);
  BDDBackup.Dialog.FileName := ChangeFileExt(DatabasePath, '.gbk');
end;

procedure TFrmEntretien.BDDBackupAccept(Sender: TObject);
begin
  with TFrmVerbose.Create(Self) do begin
    Application.ProcessMessages;
    DMPrinc.UIBBackup.OnVerbose := UIBVerbose;
    DMPrinc.UIBBackup.BackupFiles.Text := BDDBackup.Dialog.FileName;
    DMPrinc.UIBBackup.Run;
    Fin;
  end;
end;

procedure TFrmEntretien.BDDRestoreBeforeExecute(Sender: TObject);
begin
  BDDRestore.Dialog.InitialDir := ExtractFilePath(DatabasePath);
  BDDRestore.Dialog.FileName := ChangeFileExt(DatabasePath, '.gbk');
end;

procedure TFrmEntretien.BDDRestoreAccept(Sender: TObject);
begin
  with TFrmVerbose.Create(Self) do try
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

procedure TFrmEntretien.BDDOpenBeforeExecute(Sender: TObject);
begin
  BDDOpen.Dialog.InitialDir := ExtractFilePath(DatabasePath);
  BDDOpen.Dialog.FileName := DatabasePath;
end;

procedure TFrmEntretien.BDDOpenAccept(Sender: TObject);
begin
  DatabasePath := BDDOpen.Dialog.FileName;
  BDDOpen.Hint := DatabasePath;
  with TIniFile.Create(FichierIni) do try
    WriteString('Database', 'Database', DatabasePath);
  finally
    Free;
  end;
  DMPrinc.UIBDataBase.Connected := False;
  CheckVersions;
  vstEntretien.Invalidate;
end;

procedure TFrmEntretien.vstEntretienFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  ActionNodeData: PActionNodeData;
begin
  ActionNodeData := vstEntretien.GetNodeData(Node);
  Finalize(ActionNodeData^);
end;

end.

