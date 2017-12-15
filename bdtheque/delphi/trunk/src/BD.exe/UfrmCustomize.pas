unit UfrmCustomize;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Menus,
  StdCtrls, ComCtrls, CheckLst, ActnList, VDTButton, Buttons, ExtCtrls, UframBoutons,
  ToolWin, UBdtForms, PngSpeedButton;

type
  TfrmCustomize = class(TbdtForm)
    Label1: TLabel;
    Label4: TLabel;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    VDTButton2: TVDTButton;
    VDTButton3: TVDTButton;
    VDTButton4: TVDTButton;
    Frame11: TframBoutons;
    Cats: TListBox;
    Commands: TVDTListView;
    VDTListView1: TVDTListView;
    ToolButton1: TVDTButton;
    ToolButton4: TVDTButton;
    procedure CatsClick(Sender: TObject);
    procedure CommandsChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure FormCreate(Sender: TObject);
    procedure VDTButton2Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure VDTButton3Click(Sender: TObject);
    procedure VDTButton4Click(Sender: TObject);
    procedure Frame11btnOKClick(Sender: TObject);
    procedure VDTListView1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure VDTListView1DragDrop(Sender, Source: TObject; X, Y: Integer);
  public
    procedure FillCategories;
    procedure FillToolbar;
    procedure FillCommands(const cat: string);
  end;

implementation

uses BDTK.Main.Form, CommonConst, Procedures, Textes;

{$R *.DFM}

procedure TfrmCustomize.FillToolbar;
type
  TTypeButton = (tbSep, tbBut);
var
  i: Integer;
  tlb: TToolButton;
  LastButton: TTypeButton;
begin
  VDTListView1.Items.BeginUpdate;
  LastButton := tbSep;
  try
    for i := 0 to frmFond.ToolBar1.ButtonCount - 1 do
    begin
      tlb := frmFond.ToolBar1.Buttons[i];
      if Assigned(tlb.Action) and (TActionList(tlb.Action.Owner) <> frmFond.ActionList1) then
      begin
        with VDTListView1.Items.Add do
        begin
          Caption := StripHotkey(TCustomAction(tlb.Action).Caption);
          ImageIndex := TCustomAction(tlb.Action).ImageIndex;
          SubItems.Add(TCustomAction(tlb.Action).Hint);
          SubItems.Add('B');
          SubItems.Add(TCustomAction(tlb.Action).Name);
        end;
        LastButton := tbBut;
      end;
      if (tlb.Style = tbsSeparator) and (LastButton <> tbSep) then
      begin
        with VDTListView1.Items.Add do
        begin
          Caption := 'Séparateur';
          SubItems.Add('');
          SubItems.Add('S');
          SubItems.Add('');
          ImageIndex := -1;
        end;
        LastButton := tbSep;
      end;
    end;
  finally
    VDTListView1.Items.EndUpdate;
  end
end;

procedure TfrmCustomize.FillCategories;
// Reads the categories from the Actionlist and fills it to the Dialog
var
  i: Integer;
  act: TCustomAction;
begin
  Cats.Items.BeginUpdate;
  Cats.Items.Clear;
  Cats.Items.Add(rsToutesCategories); // Add "All" entry
  // Loop through the actions
  for i := 0 to frmFond.ActionsOutils.ActionCount - 1 do
  begin
    act := frmFond.ActionsOutils.Actions[i] as TCustomAction;
    // Only categories, we dont have in the list
    if Cats.Items.IndexOf(act.Category) < 0 then Cats.Items.Add(act.Category);
  end;
  Cats.Items.EndUpdate;
end;

procedure TfrmCustomize.FillCommands(const cat: string);
// Fills the command list with the items of the Actionlist
// cat = category that should be used. if cat = csAll, then
// fill all commands to the list
var
  i: Integer;
  act: TCustomAction;
  ti: TListItem;
begin
  Commands.Items.BeginUpdate;
  try
    Commands.Items.Clear;
    // Loop through the Actionlist
    for i := 0 to frmFond.ActionsOutils.ActionCount - 1 do
    begin
      act := frmFond.ActionsOutils.Actions[i] as TCustomAction;
      if Assigned(act) then
      begin
        // check if the category matches
        if (cat = rsToutesCategories) or (cat = act.Category) then
        begin
          ti := Commands.Items.Add;
          if Assigned(ti) then
          begin
            ti.Caption := StripHotkey(act.Caption);
            ti.ImageIndex := act.ImageIndex;
            ti.SubItems.Add(act.Hint);
            ti.data := act;
          end;
        end;
      end;
    end;
  finally
    Commands.Items.EndUpdate;
  end;
end;

procedure TfrmCustomize.CatsClick(Sender: TObject);
// Look what category the user has selected
var
  i: Integer;
begin
  Label3.Visible := False; // Hide description field
  Commands.Selected := nil; // Delete the selection
  for i := 0 to Cats.Items.Count - 1 do
  begin
    if Cats.Selected[i] then
    begin
      FillCommands(Cats.Items[i]); // Fill the command list
      Exit;
    end;
  end;
end;

procedure TfrmCustomize.CommandsChange(Sender: TObject; Item: TListItem; Change: TItemChange);
// An Action was selected, update the description display
begin
  if Change = ctState then
  begin
    if Assigned(Item) then
    begin
      // Description is the Action hint, stored in SubItems #2
      if Item.SubItems[0] <> '' then
        Label3.Caption := Item.SubItems[0]
      else
        Label3.Caption := Item.Caption;
      Label3.Visible := True;
    end
    else
    begin
      Label3.Visible := False;
    end;
  end;
end;

procedure TfrmCustomize.FormCreate(Sender: TObject);
begin
  PrepareLV(Self);
  FillCategories;
  FillCommands(rsToutesCategories);
  FillToolbar;
end;

procedure TfrmCustomize.VDTButton2Click(Sender: TObject);
var
  t: TListItem;
begin
  if Assigned(VDTListView1.selected) then
    t := VDTListView1.Items.Insert(VDTListView1.Selected.Index + 1)
  else
    t := VDTListView1.Items.Add;
  with t do
  begin
    Caption := 'Séparateur';
    SubItems.Add('');
    SubItems.Add('S');
    SubItems.Add('');
    ImageIndex := -1;
  end;
end;

procedure TfrmCustomize.ToolButton4Click(Sender: TObject);
begin
  MoveListItem(VDTListView1, 1);
end;

procedure TfrmCustomize.ToolButton1Click(Sender: TObject);
begin
  MoveListItem(VDTListView1, -1);
end;

procedure TfrmCustomize.VDTButton3Click(Sender: TObject);
var
  t: TListItem;
begin
  if not Assigned(Commands.Selected) then Exit;
  if Assigned(VDTListView1.Selected) then
    t := VDTListView1.Items.Insert(VDTListView1.Selected.Index + 1)
  else
    t := VDTListView1.Items.Add;
  with t do
  begin
    Caption := StripHotkey(TCustomAction(Commands.Selected.Data).Caption);
    ImageIndex := TCustomAction(Commands.Selected.Data).ImageIndex;
    SubItems.Add(TCustomAction(Commands.Selected.Data).Hint);
    SubItems.Add('B');
    SubItems.Add(TCustomAction(Commands.Selected.Data).Name);
  end;
end;

procedure TfrmCustomize.VDTButton4Click(Sender: TObject);
begin
  if Assigned(VDTListView1.Selected) then VDTListView1.Selected.Delete;
end;

procedure TfrmCustomize.Frame11btnOKClick(Sender: TObject);
var
  i: integer;
  tlb: TListItem;
begin
  frmFond.FToolCurrent.Clear;
  for i := 0 to VDTListView1.Items.Count - 1 do
  begin
    tlb := VDTListView1.Items[i];
    if Assigned(tlb) then
    begin
      if (tlb.SubItems[1] = 'B') then
        if CompareMem(PChar(tlb.SubItems[2]), PChar('act'), 3) then
          frmFond.FToolCurrent.Add(Format('b%d=%s', [i, Copy(tlb.SubItems[2], 4, MaxInt)]))
        else
          frmFond.FToolCurrent.Add(Format('b%d=%s', [i, tlb.SubItems[2]]));
      if (tlb.SubItems[1] = 'S') then frmFond.FToolCurrent.Add(Format('b%d=%s', [i, 'X']));
    end;
  end;
end;

procedure TfrmCustomize.VDTListView1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Sender = Source) or (Source = Commands);
end;

procedure TfrmCustomize.VDTListView1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  DestListItem: TListItem;
  newItemIndex: Integer;
begin
  DestListItem := VDTListView1.GetItemAt(X, Y);
  if Assigned(DestListItem) then
    newItemIndex := DestListItem.Index
  else
    newItemIndex := VDTListView1.Items.Count;
  if (Sender = Source) then
  begin
    VDTListView1.Items.AddItem(nil, newItemIndex).Assign(VDTListView1.Selected);
    VDTListView1.Items.Delete(VDTListView1.Selected.Index);
  end
  else
    with VDTListView1.Items.AddItem(nil, newItemIndex) do
    begin
      Caption := StripHotkey(TCustomAction(Commands.Selected.Data).Caption);
      ImageIndex := TCustomAction(Commands.Selected.Data).ImageIndex;
      SubItems.Add(TCustomAction(Commands.Selected.Data).Hint);
      SubItems.Add('B');
      SubItems.Add(TCustomAction(Commands.Selected.Data).Name);
    end;
end;

end.

