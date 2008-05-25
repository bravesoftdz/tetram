object frmPublier: TfrmPublier
  Left = 274
  Top = 124
  AutoSize = True
  BorderStyle = bsDialog
  BorderWidth = 8
  Caption = 'Publication'
  ClientHeight = 489
  ClientWidth = 977
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label8: TLabel
    Left = 0
    Top = 296
    Width = 32
    Height = 13
    Caption = 'Label8'
  end
  object Label9: TLabel
    Left = 0
    Top = 368
    Width = 32
    Height = 13
    Caption = 'Label9'
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 337
    Height = 255
    ActivePage = TabSheet1
    Style = tsButtons
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Publication'
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 329
        Height = 89
        Caption = ' Donn'#233'es '#224' envoyer '
        TabOrder = 0
        object DateTimePicker1: TDateTimePicker
          Left = 200
          Top = 38
          Width = 89
          Height = 21
          Date = 39587.542089050920000000
          Time = 39587.542089050920000000
          TabOrder = 0
        end
        object RadioButton1: TRadioButton
          Left = 8
          Top = 16
          Width = 193
          Height = 17
          Caption = 'Envoyer les derni'#232'res modifications'
          Checked = True
          TabOrder = 1
          TabStop = True
        end
        object RadioButton2: TRadioButton
          Left = 8
          Top = 40
          Width = 190
          Height = 17
          Caption = 'Envoyer les modifications depuis le '
          TabOrder = 2
        end
        object RadioButton3: TRadioButton
          Left = 8
          Top = 64
          Width = 105
          Height = 17
          Caption = 'R'#233'initialiser le site'
          TabOrder = 3
        end
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 96
        Width = 329
        Height = 65
        Caption = ' Base de donn'#233'es '
        TabOrder = 1
        object RadioButton4: TRadioButton
          Left = 8
          Top = 40
          Width = 121
          Height = 17
          Caption = 'Maintenir '#224' la version'
          TabOrder = 0
        end
        object RadioButton5: TRadioButton
          Left = 8
          Top = 16
          Width = 169
          Height = 17
          Caption = 'Mettre '#224' jour automatiquement'
          Checked = True
          TabOrder = 1
          TabStop = True
        end
        object ComboBox1: TComboBox
          Left = 136
          Top = 38
          Width = 97
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 2
        end
      end
      object CheckBox2: TCheckBox
        Left = 0
        Top = 168
        Width = 113
        Height = 17
        Caption = 'Envoyer les images'
        TabOrder = 2
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Param'#232'tres'
      ImageIndex = 1
      object GroupBox3: TGroupBox
        Left = 0
        Top = 0
        Width = 329
        Height = 105
        Caption = ' Site '
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 16
          Width = 101
          Height = 13
          Caption = 'Adresse du site web :'
        end
        object Label2: TLabel
          Left = 8
          Top = 56
          Width = 76
          Height = 13
          Caption = 'Cl'#233' de s'#233'curit'#233' :'
        end
        object Label7: TLabel
          Left = 168
          Top = 56
          Width = 41
          Height = 13
          Caption = 'Mod'#232'le :'
        end
        object Edit1: TEdit
          Left = 8
          Top = 32
          Width = 313
          Height = 21
          TabOrder = 0
          Text = 'http://bdtheque.tetram.org'
        end
        object Edit2: TEdit
          Left = 8
          Top = 72
          Width = 153
          Height = 21
          TabOrder = 1
          Text = 'blabla'
        end
        object ComboBox2: TComboBox
          Left = 168
          Top = 72
          Width = 153
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 2
        end
      end
      object GroupBox4: TGroupBox
        Left = 0
        Top = 112
        Width = 329
        Height = 113
        Caption = ' Base de donn'#233'es '
        TabOrder = 1
        object Label3: TLabel
          Left = 8
          Top = 24
          Width = 81
          Height = 13
          Caption = 'Serveur MySQL :'
        end
        object Label4: TLabel
          Left = 8
          Top = 44
          Width = 42
          Height = 13
          Caption = 'Compte :'
        end
        object Label6: TLabel
          Left = 8
          Top = 88
          Width = 83
          Height = 13
          Caption = 'Pr'#233'fix des tables :'
        end
        object Label5: TLabel
          Left = 168
          Top = 44
          Width = 70
          Height = 13
          Caption = 'Mot de passe :'
        end
        object Edit3: TEdit
          Left = 96
          Top = 20
          Width = 225
          Height = 21
          TabOrder = 0
          Text = 'localhost'
        end
        object Edit4: TEdit
          Left = 8
          Top = 60
          Width = 153
          Height = 21
          TabOrder = 1
          Text = 'bdtheque'
        end
        object Edit6: TEdit
          Left = 96
          Top = 84
          Width = 225
          Height = 21
          TabOrder = 2
          Text = 'bdt'
        end
        object Edit5: TEdit
          Left = 168
          Top = 60
          Width = 153
          Height = 21
          TabOrder = 3
          Text = 'tetram'
        end
      end
    end
  end
  object Memo1: TMemo
    Left = 344
    Top = 0
    Width = 633
    Height = 489
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object CheckBox1: TCheckBox
    Left = 240
    Top = 472
    Width = 97
    Height = 17
    Caption = 'CheckBox1'
    TabOrder = 2
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 320
    Width = 337
    Height = 16
    Smooth = True
    TabOrder = 3
  end
  object ProgressBar2: TProgressBar
    Left = 0
    Top = 344
    Width = 337
    Height = 16
    Smooth = True
    TabOrder = 4
  end
  object Button1: TButton
    Left = 262
    Top = 260
    Width = 75
    Height = 25
    Caption = 'Publier'
    TabOrder = 5
    OnClick = Button1Click
  end
end
