object Frame1: TFrame1
  Left = 0
  Top = 0
  Width = 443
  Height = 25
  Align = alBottom
  TabOrder = 0
  OnResize = FrameResize
  DesignSize = (
    443
    25)
  object btnOK: TBitBtn
    Left = 272
    Top = 2
    Width = 79
    Height = 21
    Cursor = crHandPoint
    Hint = 'Valider les modifcations'
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnAnnuler: TBitBtn
    Left = 360
    Top = 2
    Width = 77
    Height = 21
    Cursor = crHandPoint
    Hint = 'Annuler les modifications'
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Annuler'
    ModalResult = 2
    TabOrder = 1
    OnClick = btnAnnulerClick
  end
end
