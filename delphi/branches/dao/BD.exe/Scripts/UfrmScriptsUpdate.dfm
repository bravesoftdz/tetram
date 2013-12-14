object frmScriptsUpdate: TfrmScriptsUpdate
  Left = 177
  Top = 233
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Mise '#224' jour des scripts'
  ClientHeight = 498
  ClientWidth = 830
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    830
    498)
  PixelsPerInch = 96
  TextHeight = 13
  object LightComboCheck1: TLightComboCheck
    Left = 8
    Top = 5
    Width = 201
    Height = 20
    Checked = True
    DefaultValueChecked = 0
    PropertiesStored = True
    CheckVisible = False
    OnChange = LightComboCheck1Change
    BeforeShowPop = LightComboCheck1BeforeShowPop
    ShowCaptionHint = False
    AssignHint = False
    OptionValidValue.ValueOption = [vvoChecked, vvoUnchecked, vvoMissing, vvoUnknown, vvoOthers]
    Items.CaptionComplet = True
    Items.Separateur = ' '
    Items = <
      item
        Valeur = 0
        Caption = 'Officiels'
        Visible = True
        Enabled = True
        SubItems.CaptionComplet = True
        SubItems.Separateur = ' '
        SubItems = <>
      end
      item
        Valeur = 1
        Caption = 'Contributions'
        Visible = True
        Enabled = True
        SubItems.CaptionComplet = True
        SubItems.Separateur = ' '
        SubItems = <>
      end>
  end
  object Button1: TButton
    Left = 8
    Top = 438
    Width = 137
    Height = 25
    Cursor = crHandPoint
    Action = actGetListe
    Anchors = [akLeft, akBottom]
    TabOrder = 0
  end
  inline framBoutons1: TframBoutons
    Left = 0
    Top = 469
    Width = 830
    Height = 29
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 469
    ExplicitWidth = 830
    inherited btnOK: TButton
      Left = 667
      Visible = False
      ExplicitLeft = 667
    end
    inherited btnAnnuler: TButton
      Left = 747
      Caption = 'Fermer'
      ExplicitLeft = 747
    end
  end
  object Button2: TButton
    Left = 151
    Top = 438
    Width = 154
    Height = 25
    Cursor = crHandPoint
    Action = actUpdate
    Anchors = [akLeft, akBottom]
    TabOrder = 3
  end
  object VirtualStringTree1: TVirtualStringTree
    Left = 8
    Top = 31
    Width = 814
    Height = 401
    Anchors = [akLeft, akTop, akRight, akBottom]
    CheckImageKind = ckLightTick
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoVisible]
    TabOrder = 1
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toHideFocusRect, toHotTrack, toShowBackground, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages, toGhostedIfUnfocused]
    OnGetText = VirtualStringTree1GetText
    OnPaintText = VirtualStringTree1PaintText
    OnInitChildren = VirtualStringTree1InitChildren
    OnInitNode = VirtualStringTree1InitNode
    Columns = <
      item
        Position = 0
        Width = 200
        WideText = 'Script'
      end
      item
        Position = 1
        Width = 150
        WideText = 'Auteur'
      end
      item
        Position = 2
        Width = 120
        WideText = 'Version du script'
      end
      item
        Position = 3
        Width = 120
        WideText = 'Version BDth'#232'que requise'
      end
      item
        Position = 4
        Width = 200
        WideText = 'Derni'#232're modification'
      end>
  end
  object ActionList1: TActionList
    OnUpdate = ActionList1Update
    Left = 408
    Top = 432
    object actGetListe: TAction
      Caption = 'R'#233'cup'#233'rer la liste'
      OnExecute = actGetListeExecute
    end
    object actUpdate: TAction
      Caption = 'Mettre '#224' jour / Installer'
      OnExecute = actUpdateExecute
    end
  end
end
