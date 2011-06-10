unit UfrmScriptsUpdate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Menus,
  Dialogs, UdmScripts, Generics.Collections, UScriptList, VirtualTrees, VirtualTreeBdtk,
  StdCtrls, UframBoutons, ActnList, ComCtrls, ComboCheck;

type
  TOnlineScript = class
  private
    FScriptName: string;
    FURL: string;
  public
    ScriptInfos: TScriptInfos;
    LocalScript: TScript;

    constructor Create;
    destructor Destroy; override;

    property URL: string read FURL;
    property ScriptName: string read FScriptName;
  end;

  TfrmScriptsUpdate = class(TForm)
    Button1: TButton;
    VirtualStringTree1: TVirtualStringTree;
    framBoutons1: TframBoutons;
    Button2: TButton;
    ActionList1: TActionList;
    actGetListe: TAction;
    actUpdate: TAction;
    LightComboCheck1: TLightComboCheck;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure VirtualStringTree1GetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure VirtualStringTree1InitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure VirtualStringTree1PaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure VirtualStringTree1InitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
    procedure actUpdateExecute(Sender: TObject);
    procedure actGetListeExecute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure FormShow(Sender: TObject);
    procedure LightComboCheck1Change(Sender: TObject);
    procedure LightComboCheck1BeforeShowPop(Sender: TObject; Menu: TPopupMenu; var Continue: Boolean);
  private
    onlineScripts: TObjectList<TOnlineScript>;
    FUpdating: Boolean;
  public
    dmScripts: TdmScripts;
    procedure GetOnlineList(List: TObjectList<TOnlineScript>);
  end;

implementation

uses
  JclSimpleXML, UScriptsFonctions, CommonConst, UNet;

{$R *.dfm}

{ TfrmScriptsUpdate }

procedure TfrmScriptsUpdate.actGetListeExecute(Sender: TObject);
begin
  VirtualStringTree1.BeginUpdate;
  FUpdating := True;
  try
    VirtualStringTree1.RootNodeCount := 0;
    GetOnlineList(onlineScripts);
    VirtualStringTree1.RootNodeCount := onlineScripts.Count;
  finally
    FUpdating := False;
    VirtualStringTree1.EndUpdate;
  end;
end;

procedure TfrmScriptsUpdate.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
begin
  actGetListe.Enabled := not FUpdating;
  actUpdate.Enabled := not FUpdating and (VirtualStringTree1.GetFirstChecked <> nil);
end;

procedure TfrmScriptsUpdate.actUpdateExecute(Sender: TObject);
var
  Node: PVirtualNode;
  script: TOnlineScript;
  fs: TFileStream;
  fichier, tmpFile: string;
  P: PChar;
  canCopy: Boolean;
begin
  FUpdating := True;
  try
    Node := VirtualStringTree1.GetFirstChecked;
    while Assigned(Node) do
    begin
      script := onlineScripts[Node.Index];
      fichier := IncludeTrailingPathDelimiter(TGlobalVar.Utilisateur.Options.RepertoireScripts) + script.FScriptName;

      SetLength(tmpFile, MAX_PATH + 1);
      FillMemory(@tmpFile[1], Length(tmpFile) * SizeOf(Char), 1);
      GetTempFileName(PChar(TempPath), 'bdk', 0, @tmpFile[1]);
      P := @tmpFile[1];
      while P^ <> #0 do
        Inc(P);
      SetLength(tmpFile, (Integer(P) - Integer(@tmpFile[1])) div SizeOf(Char));

      if FileExists(tmpFile) then
        fs := TFileStream.Create(tmpFile, fmOpenReadWrite, fmShareExclusive)
      else
        fs := TFileStream.Create(tmpFile, fmCreate, fmShareExclusive);
      try
        fs.Size := 0;
        canCopy := LoadStreamURL(script.URL, [], fs) = 200;
      finally
        fs.Free;
      end;
      if canCopy then
      begin
        DeleteFile(PChar(fichier));
        MoveFile(PChar(tmpFile), PChar(fichier));
      end
      else
        DeleteFile(PChar(tmpFile));

      Node := VirtualStringTree1.GetNextChecked(Node);
    end;

    dmScripts.ScriptList.LoadDir(TGlobalVar.Utilisateur.Options.RepertoireScripts);
  finally
    FUpdating := False;
  end;
  actGetListe.Execute;
end;

procedure TfrmScriptsUpdate.FormCreate(Sender: TObject);
begin
  FUpdating := False;
  onlineScripts := TObjectList<TOnlineScript>.Create(True);
  VirtualStringTree1.NodeDataSize := 0;
end;

procedure TfrmScriptsUpdate.FormDestroy(Sender: TObject);
begin
  onlineScripts.Free;
end;

procedure TfrmScriptsUpdate.FormShow(Sender: TObject);
begin
  LightComboCheck1.Value := 0;
  //  actGetListe.Execute;
end;

procedure TfrmScriptsUpdate.GetOnlineList(List: TObjectList<TOnlineScript>);

  function GetLocalScript(ScriptName: string): TScript;
  begin
    for Result in dmScripts.ScriptList do
      if SameText(ExtractFileName(Result.FileName), ScriptName) then
      begin
        if not Result.Loaded then
          Result.Load;
        Exit;
      end;
    Result := nil;
  end;

var
  xml: TJclSimpleXML;
  ss: TStringStream;
  script: TOnlineScript;
  i: Integer;
  url: string;
begin
  List.Clear;
  xml := TJclSimpleXML.Create;
  try
    url := 'http://www.tetram.org/scriptsupdate.php?code=bdtheque';
    if LightComboCheck1.Value = 1 then url := url + '&contrib';
//    ss := TStringStream.Create(GetPage(url, True));
//    try
//  09/06/2011: bug dans la jcl = tentative d'utilisation de l'utf16 ce qui n'est pas supporté avec delphi
      xml.LoadFromString(GetPage(url, True));
//      xml.LoadFromStream(ss);
//    finally
//      ss.Free;
//    end;
    xml.Options := xml.Options + [sxoAutoCreate];
    for i := 0 to Pred(xml.Root.Items.Count) do
      with xml.Root.Items[i] do begin
        if not SameText(Name, 'script') then Continue;
        script := TOnlineScript.Create;
        List.Add(script);
        script.FURL := Items.ItemNamed['url'].Value;
        script.FScriptName := Items.ItemNamed['name'].Value;
        script.ScriptInfos.Auteur := Items.ItemNamed['auteur'].Value;
        script.ScriptInfos.Description := Items.ItemNamed['Description'].Value;
        script.ScriptInfos.ScriptVersion := Items.ItemNamed['ScriptVersion'].Value;
        script.ScriptInfos.BDVersion := Items.ItemNamed['BDVersion'].Value;
        script.ScriptInfos.LastUpdate := RFC822ToDateTimeDef(Items.ItemNamed['LastUpdate'].Value, 0);
        script.LocalScript := GetLocalScript(script.FScriptName);
      end;
  finally
    xml.Free;
  end;
end;

procedure TfrmScriptsUpdate.LightComboCheck1BeforeShowPop(Sender: TObject; Menu: TPopupMenu; var Continue: Boolean);
begin
  Continue := not FUpdating;
end;

procedure TfrmScriptsUpdate.LightComboCheck1Change(Sender: TObject);
begin
  actGetListe.Execute;
end;

procedure TfrmScriptsUpdate.VirtualStringTree1GetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  script: TOnlineScript;
  localscript: TScript;
begin
  if Sender.GetNodeLevel(Node) = 0 then
  begin
    script := onlineScripts[Node.Index];
    case Column of
      0: CellText := script.ScriptName;
      1: CellText := script.ScriptInfos.Auteur;
      2: CellText := script.ScriptInfos.ScriptVersion;
      3: CellText := script.ScriptInfos.BDVersion;
      4: CellText := DateTimeToStr(script.ScriptInfos.LastUpdate);
    end;
  end
  else
  begin
    script := onlineScripts[Node.Parent.Index];
    localscript := script.LocalScript;
    case Column of
      1: CellText := localscript.ScriptInfos.Auteur;
      2: CellText := localscript.ScriptInfos.ScriptVersion;
      3: CellText := localscript.ScriptInfos.BDVersion;
      4: CellText := DateTimeToStr(localscript.ScriptInfos.LastUpdate);
    end;
  end;
end;

procedure TfrmScriptsUpdate.VirtualStringTree1InitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
begin
  ChildCount := 1;
end;

procedure TfrmScriptsUpdate.VirtualStringTree1InitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  script: TOnlineScript;
  localscript: TScript;
begin
  if Sender.GetNodeLevel(Node) = 0 then
  begin
    script := onlineScripts[Node.Index];
    localscript := script.LocalScript;

    Node.CheckType := ctCheckBox;
    Node.CheckState := csUncheckedNormal;
    if Assigned(localscript) then begin
      Include(InitialStates, ivsHasChildren);
      // on montre automatiquement les scripts qui différent du serveur
//      if
//        not SameText(script.ScriptInfos.Auteur, localscript.ScriptInfos.Auteur)
//        or (script.ScriptInfos.ScriptVersion <> localscript.ScriptInfos.ScriptVersion)
//        or (script.ScriptInfos.BDVersion <> localscript.ScriptInfos.BDVersion)
//        or (script.ScriptInfos.LastUpdate <> localscript.ScriptInfos.LastUpdate)
//      then
//        Include(InitialStates, ivsExpanded);

      // on coche automatiquement les scripts mis à jours et utilisables
      if ((script.ScriptInfos.LastUpdate > localscript.ScriptInfos.LastUpdate) or (script.ScriptInfos.ScriptVersion > localscript.ScriptInfos.ScriptVersion))
        and (script.ScriptInfos.BDVersion <= TGlobalVar.Utilisateur.ExeVersion)
      then
        Node.CheckState := csCheckedNormal;

      // les scripts non utilisables ne sont pas cochables
      if script.ScriptInfos.BDVersion > TGlobalVar.Utilisateur.ExeVersion then
        Node.CheckType := ctNone;
    end;
  end
  else
  begin
    // pour le moment rien
  end;
end;

procedure TfrmScriptsUpdate.VirtualStringTree1PaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  script: TOnlineScript;
  localscript: TScript;
begin
  if Sender.GetNodeLevel(Node) = 0 then
  begin
    script := onlineScripts[Node.Index];
    localscript := script.LocalScript;
    if Assigned(localscript) then
      case Column of
        1:
          if not SameText(script.ScriptInfos.Auteur, localscript.ScriptInfos.Auteur) then
            TargetCanvas.Font.Color := clGreen;
        2:
          if script.ScriptInfos.ScriptVersion > localscript.ScriptInfos.ScriptVersion then
            TargetCanvas.Font.Color := clGreen
          else if script.ScriptInfos.ScriptVersion < localscript.ScriptInfos.ScriptVersion then
            TargetCanvas.Font.Color := clRed;
        3:
          if script.ScriptInfos.BDVersion > TGlobalVar.Utilisateur.ExeVersion then
          begin
            TargetCanvas.Font.Style := [fsBold];
            TargetCanvas.Font.Color := clRed;
          end;
        4:
          if script.ScriptInfos.LastUpdate > localscript.ScriptInfos.LastUpdate then
            TargetCanvas.Font.Color := clBlue
          else if script.ScriptInfos.LastUpdate < localscript.ScriptInfos.LastUpdate then
            TargetCanvas.Font.Color := clRed;
      end;
  end
  else
  begin
    TargetCanvas.Font.Color := clInactiveCaptionText;
  end;
end;

{ TOnlineScript }

constructor TOnlineScript.Create;
begin
  ScriptInfos := TScriptInfos.Create;
end;

destructor TOnlineScript.Destroy;
begin
  ScriptInfos.Free;
  inherited;
end;

end.
