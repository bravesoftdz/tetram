object frmEntretien: TfrmEntretien
  Left = 168
  Top = 263
  Caption = 'frmEntretien'
  ClientHeight = 257
  ClientWidth = 439
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    439
    257)
  PixelsPerInch = 96
  TextHeight = 13
  object Panel14: TPanel
    Left = 0
    Top = 1
    Width = 112
    Height = 264
    Anchors = [akLeft, akTop, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = ' '
    TabOrder = 0
    DesignSize = (
      112
      264)
    object VDTButton20: TVDTButton
      Left = 5
      Top = 7
      Width = 103
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Fermer'
      Flat = False
      OnClick = VDTButton20Click
    end
    object Label1: TLabel
      Left = 8
      Top = 88
      Width = 97
      Height = 121
      AutoSize = False
      Caption = 
        'ATTENTION: la plupart de ces actions sont irr'#233'versibles. N'#39'h'#233'sit' +
        'ez pas '#224' faire des sauvegardes.'
      WordWrap = True
    end
  end
  object vstEntretien: TVirtualStringTree
    Left = 113
    Top = 2
    Width = 333
    Height = 263
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelKind = bkTile
    BorderStyle = bsNone
    Header.AutoSizeIndex = 1
    Header.DefaultHeight = 17
    Header.Height = 17
    Header.Options = [hoAutoResize, hoColumnResize, hoDrag]
    HintMode = hmTooltip
    ParentShowHint = False
    SelectionCurveRadius = 10
    ShowHint = True
    TabOrder = 1
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toVariableNodeHeight]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages]
    OnCollapsing = vstEntretienCollapsing
    OnDblClick = vstEntretienDblClick
    OnFreeNode = vstEntretienFreeNode
    OnGetText = vstEntretienGetText
    OnPaintText = vstEntretienPaintText
    OnInitNode = vstEntretienInitNode
    OnResize = vstEntretienResize
    Columns = <
      item
        Position = 0
        Width = 200
      end
      item
        Position = 1
        Width = 129
      end>
  end
  object ActionList1: TActionList
    Left = 24
    Top = 56
    object BDDOpen: TFileOpen
      Category = 'Base de donn'#233'es'
      Caption = 'Ouvrir'
      Dialog.DefaultExt = 'gdb'
      Dialog.Filter = 'Base de donn'#233'es (*.gdb)|*.gdb'
      Dialog.Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofNoReadOnlyReturn, ofNoNetworkButton, ofEnableSizing]
      BeforeExecute = BDDOpenBeforeExecute
      OnAccept = BDDOpenAccept
    end
    object BDDBackup: TFileSaveAs
      Category = 'Base de donn'#233'es'
      Caption = 'Sauver'
      Dialog.DefaultExt = 'gbk'
      Dialog.Filter = 'Fichier de sauvegarde (*.gbk)|*.gbk'
      Dialog.Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
      BeforeExecute = BDDBackupBeforeExecute
      OnAccept = BDDBackupAccept
    end
    object BDDRestore: TFileOpen
      Category = 'Base de donn'#233'es'
      Caption = 'Restaurer'
      Dialog.DefaultExt = 'gbk'
      Dialog.Filter = 'Fichier de sauvegarde (*.gbk)|*.gbk'
      Dialog.Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
      BeforeExecute = BDDRestoreBeforeExecute
      OnAccept = BDDRestoreAccept
    end
    object actCompresser: TAction
      Category = 'Base de donn'#233'es'
      Caption = 'Compresser'
      Hint = 
        'R'#233'cup'#232're l'#39'espace perdu si vous avez supprimer des donn'#233'es de la' +
        ' base.'
      OnExecute = actCompresserExecute
    end
    object actExtraire: TAction
      Category = 'Images'
      Caption = 'Extraire les images'
      Hint = 
        'Extrait de la base toutes les images stock'#233'es et les transforme ' +
        'en liens.'
      OnExecute = actExtraireExecute
    end
    object actConvertir: TAction
      Category = 'Images'
      Caption = 'Convertir les liens'
      Hint = 'Stocke les images li'#233'es dans la base.'
      OnExecute = actConvertirExecute
    end
    object actNettoyer: TAction
      Category = 'Images'
      Caption = 'Nettoyer les liens invalides'
      Hint = 'Retire tous les liens vers des fichiers introuvables.'
      OnExecute = actNettoyerExecute
    end
  end
  object BrowseDirectoryDlg1: TBrowseDirectoryDlg
    Title = 'Choisissez le r'#233'pertoire de destination des images.'
    Caption = 'Extraire dans...'
    ShowSelectionInStatus = False
    Left = 56
    Top = 56
  end
end
