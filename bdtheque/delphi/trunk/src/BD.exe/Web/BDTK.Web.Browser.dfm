object frmBDTKWebBrowser: TfrmBDTKWebBrowser
  Left = 0
  Top = 0
  ClientHeight = 553
  ClientWidth = 820
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inline Frame11: TframBoutons
    Left = 0
    Top = 0
    Width = 820
    Height = 29
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 820
    inherited btnOK: TButton
      Left = 654
      Caption = 'Enregistrer'
      Default = False
      ModalResult = 0
      OnClick = Frame11btnOKClick
      ExplicitLeft = 654
    end
    inherited btnAnnuler: TButton
      Left = 737
      Cancel = False
      ModalResult = 0
      OnClick = Frame11btnAnnulerClick
      ExplicitLeft = 737
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 29
    Width = 820
    Height = 524
    Align = alClient
    PopupMenu = PopupMenu1
    TabOrder = 1
  end
  object CEFSentinel1: TCEFSentinel
    OnClose = CEFSentinel1Close
    Left = 344
    Top = 104
  end
  object ApplicationEvents1: TApplicationEvents
    OnMessage = ApplicationEvents1Message
    Left = 48
    Top = 96
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 408
    Top = 280
    object Fermerlonglet1: TMenuItem
      Caption = 'Fermer l'#39'onglet'
      OnClick = Fermerlonglet1Click
    end
  end
end
