object FMain: TFMain
  Left = 326
  Top = 354
  AutoSize = True
  BorderStyle = bsDialog
  BorderWidth = 8
  Caption = 'Configuration de SourceNet'
  ClientHeight = 233
  ClientWidth = 561
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 82
    Height = 13
    Caption = 'Adresse de base:'
  end
  object Edit1: TEdit
    Left = 0
    Top = 16
    Width = 561
    Height = 21
    TabOrder = 0
    Text = 'http://www.studio-live.com/Images/FE/Cinema/1024/009.jpg'
  end
  object Button1: TButton
    Left = 398
    Top = 208
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 486
    Top = 208
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Annuler'
    ModalResult = 1
    TabOrder = 5
  end
  object RadioButton2: TRadioButton
    Left = 0
    Top = 80
    Width = 105
    Height = 17
    Caption = 'Adresse variable'
    TabOrder = 2
    OnClick = RadioButton2Click
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 104
    Width = 545
    Height = 97
    Caption = 'G'#233'n'#233'ration de l'#39'adresse'
    TabOrder = 3
    object Label2: TLabel
      Left = 40
      Top = 29
      Width = 29
      Height = 13
      Caption = 'D'#233'but'
    end
    object Label3: TLabel
      Left = 200
      Top = 29
      Width = 14
      Height = 13
      Caption = 'Fin'
    end
    object Label4: TLabel
      Left = 344
      Top = 29
      Width = 60
      Height = 13
      Caption = 'Remplissage'
    end
    object Label5: TLabel
      Left = 16
      Top = 56
      Width = 513
      Height = 33
      AutoSize = False
      Caption = 
        'La partie %#% de l'#39'adresse sera remplac'#233'e par un nombre choisi e' +
        'ntre la valeur D'#233'but et la valeur Fin et compl'#233't'#233'e '#224' gauche par ' +
        'des z'#233'ros pour atteindre la taille Remplissage.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object SpinEdit1: TSpinEdit
      Left = 80
      Top = 24
      Width = 81
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
    end
    object SpinEdit2: TSpinEdit
      Left = 224
      Top = 24
      Width = 81
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
    object SpinEdit3: TSpinEdit
      Left = 416
      Top = 24
      Width = 81
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 0
    end
  end
  object RadioButton1: TRadioButton
    Left = 0
    Top = 56
    Width = 89
    Height = 17
    Caption = 'Adresse fixe'
    Checked = True
    TabOrder = 1
    TabStop = True
    OnClick = RadioButton2Click
  end
end
