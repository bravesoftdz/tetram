object FrmZoomCouverture: TFrmZoomCouverture
  Left = 492
  Top = 352
  Width = 370
  Height = 540
  Caption = 'Zoom image'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 362
    Height = 494
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Image: TImage
      Left = 221
      Top = 91
      Width = 85
      Height = 85
      AutoSize = True
      Stretch = True
      OnDblClick = ImageDblClick
      OnMouseDown = ImageMouseDown
      OnMouseMove = ImageMouseMove
      OnMouseUp = ImageMouseUp
    end
    object ScrollBarV: TScrollBar
      Left = 543
      Top = 0
      Width = 16
      Height = 327
      Kind = sbVertical
      PageSize = 0
      TabOrder = 0
      Visible = False
    end
    object ScrollBarH: TScrollBar
      Left = 0
      Top = 327
      Width = 543
      Height = 16
      PageSize = 0
      TabOrder = 1
      Visible = False
    end
    object Panel1: TPanel
      Left = 543
      Top = 327
      Width = 16
      Height = 16
      BevelOuter = bvNone
      TabOrder = 2
      Visible = False
    end
  end
  object ActionList1: TActionList
    Left = 192
    Top = 42
    object ImageApercu: TAction
      Tag = 1
      Category = 'Image'
      Caption = 'Aper'#231'u avant impression'
      ImageIndex = 4
      OnExecute = ImageApercuExecute
    end
    object ImageImprimer: TAction
      Tag = 2
      Category = 'Image'
      Caption = 'Imprimer'
      ImageIndex = 3
    end
  end
  object MainMenu1: TMainMenu
    Left = 160
    Top = 40
    object Image1: TMenuItem
      Caption = 'Image'
      object Aperuavantimpression1: TMenuItem
        Action = ImageApercu
      end
      object Imprimer1: TMenuItem
        Action = ImageImprimer
      end
    end
  end
end
