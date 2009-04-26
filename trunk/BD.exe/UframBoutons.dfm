object framBoutons: TframBoutons
  Left = 0
  Top = 0
  Width = 451
  Height = 29
  Align = alBottom
  TabOrder = 0
  OnResize = FrameResize
  DesignSize = (
    451
    29)
  object btnOK: TButton
    Left = 288
    Top = 6
    Width = 79
    Height = 21
    Cursor = crHandPoint
    Hint = 'Valider les modifcations'
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    DoubleBuffered = True
    ImageIndex = 2
    Images = frmFond.ShareImageList
    ModalResult = 1
    ParentDoubleBuffered = False
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnAnnuler: TButton
    Left = 368
    Top = 6
    Width = 77
    Height = 21
    Cursor = crHandPoint
    Hint = 'Annuler les modifications'
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Annuler'
    DoubleBuffered = True
    ImageIndex = 0
    Images = frmFond.ShareImageList
    ModalResult = 2
    ParentDoubleBuffered = False
    TabOrder = 1
    OnClick = btnAnnulerClick
  end
end
