object frmChoixScript: TfrmChoixScript
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'S'#233'lectionnez le script '#224' ex'#233'cuter'
  ClientHeight = 419
  ClientWidth = 844
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
    844
    419)
  PixelsPerInch = 96
  TextHeight = 13
  inline framBoutons1: TframBoutons
    Left = 0
    Top = 0
    Width = 844
    Height = 29
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 844
    inherited btnOK: TButton
      Left = 678
      ExplicitLeft = 678
    end
    inherited btnAnnuler: TButton
      Left = 761
      ExplicitLeft = 761
    end
  end
  object Panel4: TPanel
    Left = 8
    Top = 33
    Width = 828
    Height = 272
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    Caption = 'Panel4'
    ShowCaption = False
    TabOrder = 1
    object Splitter3: TSplitter
      Left = 595
      Top = 0
      Height = 272
      Align = alRight
      ExplicitLeft = 629
      ExplicitTop = 4
      ExplicitHeight = 39
    end
    object ListBox2: TListBox
      Left = 598
      Top = 0
      Width = 230
      Height = 272
      Style = lbVirtual
      Align = alRight
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 0
      OnData = ListBox2Data
      OnDblClick = ListBox2DblClick
    end
    object ListView1: TListView
      Left = 0
      Top = 0
      Width = 595
      Height = 272
      Align = alClient
      BevelKind = bkTile
      BorderStyle = bsNone
      Columns = <>
      HideSelection = False
      ReadOnly = True
      TabOrder = 1
      ViewStyle = vsList
      OnDblClick = ListView1DblClick
      OnSelectItem = ListView1SelectItem
    end
  end
  object Panel5: TPanel
    Left = 8
    Top = 311
    Width = 828
    Height = 100
    Anchors = [akLeft, akRight, akBottom]
    BevelKind = bkTile
    BevelOuter = bvNone
    Caption = 'Panel5'
    ShowCaption = False
    TabOrder = 2
    DesignSize = (
      824
      96)
    object Label2: TLabel
      Left = 8
      Top = 8
      Width = 45
      Height = 13
      Caption = 'Auteur :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 46
      Width = 70
      Height = 13
      Caption = 'Description :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 59
      Top = 8
      Width = 31
      Height = 13
      Caption = 'Label2'
    end
    object Label7: TLabel
      Left = 8
      Top = 27
      Width = 48
      Height = 13
      Caption = 'Version :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label8: TLabel
      Left = 62
      Top = 27
      Width = 31
      Height = 13
      Caption = 'Label2'
    end
    object Label9: TLabel
      Left = 264
      Top = 27
      Width = 168
      Height = 13
      Caption = 'Version de BDth'#232'que requise :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label10: TLabel
      Left = 438
      Top = 27
      Width = 31
      Height = 13
      Caption = 'Label2'
    end
    object Label4: TLabel
      Left = 264
      Top = 8
      Width = 128
      Height = 13
      Caption = 'Derni'#232're modification :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 398
      Top = 8
      Width = 31
      Height = 13
      Caption = 'Label2'
    end
    object Memo1: TMemo
      Left = 84
      Top = 43
      Width = 731
      Height = 43
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Lines.Strings = (
        'Memo1')
      ParentColor = True
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
end
