object frmOptions: TfrmOptions
  Left = 591
  Top = 278
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biHelp]
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 407
  ClientWidth = 360
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010002002020100000000000E80200002600000010101000000000002801
    00000E0300002800000020000000400000000100040000000000800200000000
    0000000000000000000000000000000000000000800000800000008080008000
    0000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF00
    0000FF00FF00FFFF0000FFFFFF007770FFFFFFFFFFFFF0070FFFFFFFFFFFF777
    0FFFFFFFFFFFF07870FFFFFFFFFFFF7770FFFFFFFFFF0788770FFFFFFFFFFFF7
    700FFFFFFFF078877770FFFFFFFFFFFF0070FFFFFF07887FF7770FFFFFFFFFFF
    07870FFFF07887FFFF7770FFFFFFFFF0788770FF07887FFFFFF7770FFFFFFF07
    887777000887FFFFFFFF7770FFFFF07887FF7770087FFF00FFFFF7700FFF0788
    7FFFF77707FFFF0F0FFFFF0070FF7887FFFFFF7770FF0F0FFFFFFF07870F887F
    F0FFFFF7770FF00FFFFFF078877087FF0FFFFFFF7700FFFFFFFF078877777FF0
    F0F0FFFFF0070FFFFFF07887FF770FF0FF0FFFFFF07870FFFF07887FFFF770FF
    00FFFFFF0788770FF07887FFFFFF700FFFFFFFF07887777000887FF0FFFF0070
    FFFFFF07887FF7770087FFF0FFFF07870FFFF07887FFFF77707FF00000FF7887
    70FF07887FFFFFF7770FFFF0FFFF887777000887FFF0FFFF7770FFF0FFFF87FF
    7770087FF0FF0FFFF7700FFFFFFF7FFFF77707FF0F0F0FFFFF0070FFFFFFFFFF
    FF7770FF0FF0FFFFFF07870FFFF0FFFFFFF7770FF0FFFFFFF0788770FF07F00F
    FFFF7700FFFFFFFF0788777700080F0FFFFFF0070FFFFFF07887FF777008FF00
    0FFFF07870FFFF07887FFFF77700FFFF0FFF0788770FF07887FF0FFF7770FFF0
    FFF07887777000887FF0F0FFF777FFF0FF07887FF7770087FF0FF0FFFF77FFFF
    F07887FFFF77707FF0FFF0FFFFF7000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000280000001000000020000000010004000000
    0000C00000000000000000000000000000000000000000000000000080000080
    00000080800080000000800080008080000080808000C0C0C0000000FF0000FF
    000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0070FFFFFFF00FFFFFF70F
    FFFF0870FFFFFF00FFF087F70FFFFF780F087FFF70FFF78F7007F0FFF70F78FF
    F70F00FFF0808F0FFF70FFFF08770FF0FFF70FF087FF70FFFF7870087FFF080F
    F78FF707F00F877078FFFF70FFFF7FF70F000FF00FFFFFFF70FFFFF780F000FF
    F00FFF78F700FF0F0870F78F0F70FFF087F708F0FFF700000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    00000000000000000000000000000000000000000000}
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object BtDef: TButton
    Left = 67
    Top = 253
    Width = 70
    Height = 23
    Caption = 'BtDef'
    Default = True
    TabOrder = 2
    TabStop = False
    OnClick = BtDefClick
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 360
    Height = 378
    Cursor = crHandPoint
    ActivePage = TabSheet2
    Align = alClient
    HotTrack = True
    Images = ImageList1
    Style = tsFlatButtons
    TabHeight = 38
    TabOrder = 0
    TabStop = False
    object options: TTabSheet
      Hint = 'Options diverses'
      Caption = 'Options diverses'
      object CategoryPanelGroup1: TCategoryPanelGroup
        Left = 0
        Top = 0
        Width = 352
        Height = 330
        VertScrollBar.Tracking = True
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        DoubleBuffered = True
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -9
        HeaderFont.Name = 'Tahoma'
        HeaderFont.Style = [fsBold]
        HeaderHeight = 16
        ParentDoubleBuffered = False
        TabOrder = 0
        object CategoryPanel1: TCategoryPanel
          Top = 0
          Height = 263
          Caption = 'G'#233'n'#233'ral'
          TabOrder = 0
          ExplicitWidth = 350
          object Label3: TLabel
            Left = 14
            Top = 95
            Width = 189
            Height = 13
            Margins.Top = 0
            Margins.Bottom = 1
            Caption = 'Format d'#39'affichage des titres d'#39'albums :'
          end
          object LightComboCheck2: TLightComboCheck
            Left = 14
            Top = 109
            Width = 315
            Height = 16
            Margins.Top = 0
            Margins.Bottom = 1
            Checked = True
            DefaultValueChecked = 4
            DefaultValueUnchecked = 0
            PropertiesStored = False
            CheckVisible = False
            CheckedCaptionBold = False
            ShowCaptionHint = False
            AssignHint = False
            OptionValidValue.ValueOption = [vvoChecked, vvoUnchecked, vvoMissing, vvoUnknown, vvoOthers]
            Items.CaptionComplet = True
            Items.Separateur = ' '
            Items = <
              item
                Valeur = 0
                Caption = 'Album (Serie - Tome)'
                Visible = True
                Enabled = True
                SubItems.CaptionComplet = True
                SubItems.Separateur = ' '
                SubItems = <>
              end
              item
                Valeur = 1
                Caption = 'Tome - Album (Serie)'
                Visible = True
                Enabled = True
                SubItems.CaptionComplet = True
                SubItems.Separateur = ' '
                SubItems = <>
              end>
          end
          object LightComboCheck1: TLightComboCheck
            Left = 14
            Top = 197
            Width = 315
            Height = 16
            Margins.Top = 0
            Margins.Bottom = 1
            Checked = True
            DefaultValueChecked = 4
            DefaultValueUnchecked = 0
            PropertiesStored = False
            CheckVisible = False
            CheckedCaptionBold = False
            ShowCaptionHint = False
            AssignHint = False
            OptionValidValue.ValueOption = [vvoChecked, vvoUnchecked, vvoMissing, vvoUnknown, vvoOthers]
            Items.CaptionComplet = True
            Items.Separateur = ' '
            Items = <
              item
                Valeur = 0
                Caption = 'Jamais v'#233'rifier les mise '#224' jour'
                Visible = True
                Enabled = True
                SubItems.CaptionComplet = True
                SubItems.Separateur = ' '
                SubItems = <>
              end
              item
                Valeur = 1
                Caption = 'V'#233'rifier les mise '#224' jour '#224' chaque d'#233'marrage'
                Visible = True
                Enabled = True
                SubItems.CaptionComplet = True
                SubItems.Separateur = ' '
                SubItems = <>
              end
              item
                Valeur = 2
                Caption = 'V'#233'rifier les mise '#224' jour une fois par jour'
                Visible = True
                Enabled = True
                SubItems.CaptionComplet = True
                SubItems.Separateur = ' '
                SubItems = <>
              end
              item
                Valeur = 3
                Caption = 'V'#233'rifier les mise '#224' jour une fois par semaine'
                Visible = True
                Enabled = True
                SubItems.CaptionComplet = True
                SubItems.Separateur = ' '
                SubItems = <>
              end
              item
                Valeur = 4
                Caption = 'V'#233'rifier les mise '#224' jour une fois par mois'
                Visible = True
                Enabled = True
                SubItems.CaptionComplet = True
                SubItems.Separateur = ' '
                SubItems = <>
              end>
          end
          object OpenStart: TCheckBox
            Left = 14
            Top = 5
            Width = 210
            Height = 16
            Cursor = crHandPoint
            Margins.Top = 0
            Margins.Bottom = 0
            Caption = 'D'#233'marrer l'#39'application en mode Gestion'
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
          object CheckBox6: TCheckBox
            Left = 14
            Top = 21
            Width = 266
            Height = 16
            Cursor = crHandPoint
            Margins.Top = 0
            Margins.Bottom = 1
            Caption = 'Avertir en cas de pr'#234't d'#39'une '#233'dition d'#233'j'#224' emprunt'#233'e'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object CheckBox7: TCheckBox
            Left = 14
            Top = 37
            Width = 298
            Height = 16
            Cursor = crHandPoint
            Margins.Top = 0
            Margins.Bottom = 1
            Caption = 'Saisie d'#39'une s'#233'rie obligatoire pour les albums et les achats'
            Checked = True
            State = cbChecked
            TabOrder = 2
          end
          object CheckBox8: TCheckBox
            Left = 14
            Top = 52
            Width = 242
            Height = 16
            Cursor = crHandPoint
            Margins.Top = 0
            Margins.Bottom = 1
            Caption = 'Saisie d'#39'une s'#233'rie obligatoire pour les para-bd'
            Checked = True
            State = cbChecked
            TabOrder = 3
          end
          object CheckBox5: TCheckBox
            Left = 14
            Top = 78
            Width = 266
            Height = 16
            Cursor = crHandPoint
            Margins.Top = 0
            Margins.Bottom = 1
            Caption = 'Utiliser l'#39'anti-aliasing pour redimensionner les images'
            Checked = True
            State = cbChecked
            TabOrder = 4
          end
          object CheckBox3: TCheckBox
            Left = 14
            Top = 139
            Width = 201
            Height = 16
            Cursor = crHandPoint
            Margins.Top = 0
            Margins.Bottom = 1
            Caption = 'D'#233'corer les fen'#234'tres avec des images'
            Checked = True
            State = cbChecked
            TabOrder = 5
          end
          object GrandesIconesMenu: TCheckBox
            Left = 14
            Top = 155
            Width = 170
            Height = 16
            Margins.Top = 0
            Margins.Bottom = 1
            Caption = 'Grandes icones dans les menus'
            Checked = True
            State = cbChecked
            TabOrder = 6
          end
          object GrandesIconesBarre: TCheckBox
            Left = 14
            Top = 172
            Width = 194
            Height = 16
            Margins.Top = 0
            Margins.Bottom = 1
            Caption = 'Grandes icones dans la barre d'#39'outils'
            Checked = True
            State = cbChecked
            TabOrder = 7
          end
          object AfficherNotesListes: TCheckBox
            Left = 14
            Top = 222
            Width = 257
            Height = 16
            Cursor = crHandPoint
            Margins.Top = 0
            Margins.Bottom = 1
            Caption = 'Afficher l'#39'appreciation personnelle dans les listes'
            Checked = True
            State = cbChecked
            TabOrder = 8
          end
        end
        object CategoryPanel2: TCategoryPanel
          Top = 263
          Height = 59
          Caption = 'Impression'
          TabOrder = 1
          ExplicitWidth = 350
          object FicheAlbumCouverture: TCheckBox
            Left = 14
            Top = 5
            Width = 242
            Height = 16
            Cursor = crHandPoint
            Caption = 'Imprimer les fiches d'#39'album avec la couverture'
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
          object FicheParaBDCouverture: TCheckBox
            Left = 14
            Top = 21
            Width = 242
            Height = 16
            Cursor = crHandPoint
            Caption = 'Imprimer les fiches de para-BD avec l'#39'image'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
        end
        object CategoryPanel3: TCategoryPanel
          Top = 322
          Height = 80
          Caption = 'Mode Gestion'
          TabOrder = 2
          ExplicitWidth = 350
          object Label14: TLabel
            Left = 14
            Top = 23
            Width = 175
            Height = 13
            Caption = 'R'#233'pertoire de stockage des images :'
          end
          object VDTButton1: TVDTButton
            Left = 14
            Top = 40
            Width = 315
            Height = 16
            Hint = 'R'#233'pertoire de stockage des images'
            Caption = 'R'#233'pertoire Images'
            Margin = 1
            OnClick = VDTButton1Click
          end
          object CheckBox2: TCheckBox
            Left = 14
            Top = 5
            Width = 224
            Height = 16
            Cursor = crHandPoint
            Caption = 'Images stock'#233'es dans la base par d'#233'faut'
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Monnaies'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        352
        330)
      object Label8: TLabel
        Left = 31
        Top = 33
        Width = 318
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = 'Taux de conversions'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object SpeedButton1: TVDTButton
        Left = 12
        Top = 182
        Width = 55
        Height = 21
        Caption = 'Nouveau'
        Flat = False
        OnClick = SpeedButton1Click
      end
      object SpeedButton2: TVDTButton
        Left = 122
        Top = 182
        Width = 55
        Height = 21
        Caption = 'Supprimer'
        Flat = False
        OnClick = SpeedButton2Click
      end
      object SpeedButton3: TVDTButton
        Left = 67
        Top = 182
        Width = 55
        Height = 21
        Caption = 'Modifier'
        Flat = False
        OnClick = SpeedButton3Click
      end
      object Label9: TLabel
        Left = 11
        Top = 10
        Width = 98
        Height = 13
        Alignment = taRightJustify
        Caption = 'Symbole mon'#233'taire :'
      end
      object Panel4: TPanel
        Left = 180
        Top = 179
        Width = 165
        Height = 90
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 2
        Visible = False
        object ComboBox2: TComboBox
          Left = 4
          Top = 3
          Width = 67
          Height = 21
          Cursor = crHandPoint
          TabOrder = 0
          OnChange = ComboBox2Change
        end
        object ComboBox3: TComboBox
          Left = 93
          Top = 3
          Width = 67
          Height = 21
          Cursor = crHandPoint
          TabOrder = 1
          OnChange = ComboBox2Change
        end
        object Panel6: TPanel
          Left = 4
          Top = 47
          Width = 157
          Height = 18
          BevelInner = bvRaised
          BevelOuter = bvLowered
          Caption = ' '
          TabOrder = 3
          object Label10: TLabel
            Left = 2
            Top = 2
            Width = 3
            Height = 13
            Align = alClient
          end
        end
        inline Frame12: TframBoutons
          Left = 0
          Top = 65
          Width = 165
          Height = 25
          Align = alBottom
          TabOrder = 4
          ExplicitTop = 65
          ExplicitWidth = 165
          ExplicitHeight = 25
          inherited btnOK: TButton
            Left = 24
            Top = 4
            Width = 64
            ModalResult = 0
            OnClick = Button2Click
            ExplicitLeft = 24
            ExplicitTop = 4
            ExplicitWidth = 64
          end
          inherited btnAnnuler: TButton
            Left = 96
            Top = 4
            Width = 64
            ModalResult = 0
            OnClick = Button3Click
            ExplicitLeft = 96
            ExplicitTop = 4
            ExplicitWidth = 64
          end
        end
        object Edit1: TEditLabeled
          Left = 4
          Top = 27
          Width = 157
          Height = 18
          Hint = 'Prix unitaire d'#39'une cassette vierge de 120 minutes'
          BevelKind = bkTile
          BorderStyle = bsNone
          TabOrder = 2
          Text = '0,00'
          OnChange = ComboBox2Change
          OnExit = Edit1Exit
          OnKeyPress = calculKeyPress
          LinkControls = <>
          TypeDonnee = tdNumeric
          CurrencyChar = #0
        end
      end
      object ComboBox1: TComboBox
        Left = 110
        Top = 6
        Width = 67
        Height = 21
        Cursor = crHandPoint
        TabOrder = 0
      end
      object ListView1: TVDTListView
        Left = 9
        Top = 56
        Width = 336
        Height = 121
        Anchors = [akLeft, akTop, akRight]
        BevelKind = bkTile
        Columns = <
          item
            Width = 46
          end>
        TabOrder = 1
        OnDblClick = ListView1DblClick
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Site web'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox3: TGroupBox
        Left = 0
        Top = 0
        Width = 353
        Height = 129
        Caption = ' Site '
        TabOrder = 0
        object Label4: TLabel
          Left = 8
          Top = 16
          Width = 104
          Height = 13
          Caption = 'Adresse du site web :'
        end
        object Label5: TLabel
          Left = 8
          Top = 56
          Width = 78
          Height = 13
          Caption = 'Cl'#233' de s'#233'curit'#233' :'
        end
        object Label7: TLabel
          Left = 184
          Top = 56
          Width = 41
          Height = 13
          Caption = 'Mod'#232'le :'
        end
        object Label17: TLabel
          Left = 8
          Top = 100
          Width = 93
          Height = 13
          Caption = 'Taille des paquets :'
        end
        object Edit2: TEdit
          Left = 8
          Top = 32
          Width = 337
          Height = 21
          TabOrder = 0
          Text = 'http://bdtheque.tetram.org'
        end
        object Edit3: TEdit
          Left = 8
          Top = 72
          Width = 161
          Height = 21
          TabOrder = 1
          Text = 'blabla'
        end
        object ComboBox4: TComboBox
          Left = 184
          Top = 72
          Width = 161
          Height = 21
          Style = csDropDownList
          TabOrder = 2
        end
        object ComboBox6: TComboBox
          Left = 112
          Top = 96
          Width = 57
          Height = 21
          Style = csDropDownList
          TabOrder = 3
          Items.Strings = (
            '1024'
            '2048'
            '4096'
            '8192'
            '16384')
        end
      end
      object GroupBox4: TGroupBox
        Left = 0
        Top = 136
        Width = 353
        Height = 193
        Caption = ' Base de donn'#233'es '
        TabOrder = 1
        object Label6: TLabel
          Left = 8
          Top = 24
          Width = 81
          Height = 13
          Caption = 'Serveur MySQL :'
        end
        object Label12: TLabel
          Left = 8
          Top = 44
          Width = 44
          Height = 13
          Caption = 'Compte :'
        end
        object Label13: TLabel
          Left = 8
          Top = 112
          Width = 87
          Height = 13
          Caption = 'Pr'#233'fix des tables :'
        end
        object Label15: TLabel
          Left = 184
          Top = 44
          Width = 71
          Height = 13
          Caption = 'Mot de passe :'
        end
        object Label16: TLabel
          Left = 8
          Top = 88
          Width = 139
          Height = 13
          Caption = 'Nom de la base de donn'#233'es :'
        end
        object Edit4: TEdit
          Left = 96
          Top = 20
          Width = 249
          Height = 21
          TabOrder = 0
          Text = 'localhost'
        end
        object Edit5: TEdit
          Left = 8
          Top = 60
          Width = 161
          Height = 21
          TabOrder = 1
          Text = 'thierry.rl'
        end
        object Edit6: TEdit
          Left = 184
          Top = 108
          Width = 161
          Height = 21
          TabOrder = 4
          Text = 'bdt'
        end
        object Edit7: TEdit
          Left = 184
          Top = 60
          Width = 161
          Height = 21
          TabOrder = 2
          Text = '280776'
        end
        object Edit8: TEdit
          Left = 184
          Top = 84
          Width = 161
          Height = 21
          TabOrder = 3
          Text = 'bdtheque'
        end
        object RadioButton5: TRadioButton
          Left = 8
          Top = 144
          Width = 169
          Height = 17
          Caption = 'Mettre '#224' jour automatiquement'
          Checked = True
          TabOrder = 5
          TabStop = True
        end
        object RadioButton4: TRadioButton
          Left = 8
          Top = 168
          Width = 121
          Height = 17
          Caption = 'Maintenir '#224' la version'
          TabOrder = 6
        end
        object ComboBox5: TComboBox
          Left = 136
          Top = 166
          Width = 97
          Height = 21
          Style = csDropDownList
          TabOrder = 7
        end
        object Button1: TButton
          Left = 272
          Top = 160
          Width = 75
          Height = 25
          Caption = 'G'#233'n'#233'rer'
          TabOrder = 8
          OnClick = Button1Click
        end
      end
    end
  end
  inline Frame11: TframBoutons
    Left = 0
    Top = 378
    Width = 360
    Height = 29
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 378
    ExplicitWidth = 360
    inherited btnOK: TButton
      Left = 203
      Width = 73
      OnClick = btnOKClick
      ExplicitLeft = 203
      ExplicitWidth = 73
    end
    inherited btnAnnuler: TButton
      Left = 284
      Width = 71
      ExplicitLeft = 284
      ExplicitWidth = 71
    end
  end
  object ImageList1: TPngImageList
    Height = 32
    Width = 32
    PngImages = <
      item
        Background = clWindow
        Name = 'PngImage0'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A0000079B4944415478DA
          ED977B5054D71DC7BF7717F6C9CAC2F21276D0C842A05603828F329A184C24B1
          06C898D6A9491C2769DA1975623B994443B5635B4D2671923FDAC9634CA3531F
          D164422D6044081451208AA29489BA202C6F6459846577D9E7DD7BFB3B974B86
          3A7D394E9B7F72673EDCBBBBF79EF339BFDFEF9C73E1F02D1FDC7702DF09DCE7
          F34AC24C08C4907CFEBF083C41EC21961291F27701C2467C417C425CFB5F0814
          10BF23F2D987DCBC6C78BD3EF4F5F64BE7BB8E9BC47159A6E77E0556C91D3FC2
          3E2C5F9187ADDB5E80CFE7872088C8CE5984D15107BA6EF5A0B9E9129A1A2FC2
          6E77CC7EBE91F835517FAF022CC4FB89C7D987850B335154B20EFDFD8318ECAA
          C113CB9D10FD40CD9568C4A71560F5A3AB30776E2244414077772FEA6ACFE1AF
          750D0885F899F6587A7612D7FF934032F126F13CBB67FEFC54FC686309BABB7A
          E19DAAC46F4A456451E905C689092048E79B3780B27340DB680A3297E463495E
          0E745A2DC6C727507DB6568A4C381C666DB33F8789DD84FD6E010DF10AF13AA1
          4F4C4A40C9D34F21363606A73E3B8297B78C62D33380484DF094F2909B982401
          2789104192F1914C33C99CB172189B938EEF67672323231DCEC949349E6F425B
          5BFB8C082BD887670B50D33840CC37C6185158B806794B97483FFCF9F35FE1D9
          755479A980C9480222CDB7100D852478AF2CE22201862CC468BD0D1C752B50B8
          E1E752AD08941A97CB838B5F7D059B4DAACB462660213E66367ABD1EAB1EA6F0
          E5E640C129A40718D5670F62FB761772D381A62A404B9DE450924426E19F8E06
          EF2109CFB44C07753C120B64AD05DEFD548FCCAC226920C1601056AB15D1D151
          526AAC373BEB38B9B2CFB13CAF5CB51246A31182287C632C0AD3D72323231819
          B4222FB9174FA609E8E8009C14F29C4480822249F48E015F9344164DD29A4115
          062717C262B150C444747674C230472715AA4EA7C7A13F1EA142B57DC4045484
          B3B8649D76CB0BCFA2B9F1123A6FD9E0F1F8101B138B8888887F28129EE731D0
          DF074D5F3B5606FD50DF01BAD53472BA2DFD41E00A2D8E23CA6C2C5890462102
          BABABBA0D76B909FBF026E8F07E71B9A919595892F6B6AE1743AF7CCD4405D52
          5242C11FDE3B00977B0A6ECA93D3E9A2107560606088421782C964424C4CCC37
          222C3ABD3DBD186B6FC73C9F0F5C0A704B9142D5BF146AB59A46D74DB3408DBC
          65B9B4468CA1E94233F4622FE62770B836940C87C3C152B26B46A099F8C16FF7
          ED8652A1C489139F233E3E1EF171F150CA11F090BDDD6E47C01F00AB95C4A444
          68341A49C466B341A552C16C364B521A6D24163FB4187D7D0368B9D8028BC90E
          531470E2174A448A4AE4ED0AE16FFD226B76F34C0A287B301495AC47980F2330
          5C851FAF06CA49EB5A4F34E212E721C59C22D5873491E99E11FB0826A808388E
          435C6C1CFC011F549111C8C8CCA015D186D62BADC8B7B8B0FB1925F2D314F853
          9D083E08BC98AFC2BE0A1E7B2A8317A9A91D4C60AD4685EA48DAD7E6A666606A
          6A0A7F7975187919C08767445CED0636D10E507519A86DD3C0E18D8725DD8284
          840428140A49A8B3B313A6B8580403215C6B6D4171AE0F2B2C1C42010E2F3F46
          7B5588A3058CC396C3417CF6BC0EC75B783C77D25B468F4A2978EB8DE714AF5D
          A6ADA3A28D835127C2713002340BB1767F08BB9E56A0603127AD996F940998F4
          8AC83073A8B8AC40DBED642C5BB60CB7876F43A954C2ED76E331733BDEDE1801
          1F75B8E983104EBDA495041052A0E8632F2A7E62C0A1CB41BC78DAC336AA9F31
          81B3E777A90B458F02FBAB42F02B4434BCAAC6545084A5D487C1773454071C15
          B480EF950651FFBA0A4934C76BBE16B0F9702C0AD614A0BFAF1F91AA48A9F802
          3DB5A8DFA1913A5CFFA10FA7374749D74CA2F8A41BE5C5467CD0EAC7D67AD741
          EA7B1B13A86FD8A65FED7028F0EE057FD8601095675FD2E3EA108F9D5FF8F1E5
          563D8D5E44CFB8802DC7FD68F8A5568AC6BEEA202A461E92E639136005196588
          425D55259C7BE74019E6B0E1D8148E3D658096A6A640F9DF503989BDCB0D78A5
          D185BA81E0DB6C63620235460DB7C0E917AD747DBE2843F556F946034E5E0FA0
          7990C7EF7FA8933AACB00650DDC5E3BD129D24547C740ACDA3D1489D972AAD0D
          CE0927868787218479044BE3A0E449A0CC85638F1BA1A1089675F9B1F7925BB8
          3E1E665BF369E22A9BFE33D3906A1EACA21E2C7A40FD7E79510C0EDFF0E2C638
          8F038F18E81711EFB779E10989786D854EBA33EBE038AC77C277EFA2B6049DC2
          6CFF69828A2D4205A7C6B1C6ACC251AB6FB2C3193EC3D24D8CCBF7D2828DD619
          016A157331FDC6B3779E4199BC3C3112372778B46C3441A3E4F069A70F6D633C
          DECC37480F641C75E09633FC0E5DCE231611D5445BBA517968676E14EB140D43
          C14EFAAE5C5E67D84B019BFC7682E61626EE7E1F582437C68E04228F78541BC1
          9969145169D14AD87D024E144EAF0569471CB04D86B7D365DFAC36728952964A
          A252DE7221773E287FF6CE0ED96C01B6E49964E28839F2F72C35B40F2287B1C8
          1491B9FE01B5E2A3EB3E8CF9841D2C8C4434417B24B28829C22D3F4B7BA5F43E
          D84F84F04F8E7FF74AA69A25C3CE51B3D2C5A2B5441EE525B616B1A010A9F23D
          93F26887E5B0FFCBE35EDE8A35B38418DA599D5D20B231FD8ACE3ABEF3DF367A
          3FFF98E864115614ED984E217FAF8D7CEBFF9AFD1D30C2223A8EE9C0A1000000
          0049454E44AE426082}
      end
      item
        Background = clWindow
        Name = 'PngImage1'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000000097048597300000B1300000B1301009A9C1800000A784944415478DA
          B5576B6C1CE5153DF3DCF7CB8FF5636DC77648E23C884D48420A2840930A480A
          092494A4500515AA4650F1835268C48F562A42544AD50A5A15955228205A5444
          1B540812AF4041401E380E24C689D78F387EADD7EBDDF5EECCEECCEC4CCFAE1D
          154205A9443F6934DAD5CCF79D7BEEB9E7DE110ADD4B717609A2004995160840
          93A95BAB8DBC7141A960D63AA6ED711CA7C6B1E1135529292AD22C1F9F953DF2
          B8EA538E4B2EB9DBB6EC8992599A8283F35EAEAE13102A00F892288B22016CE0
          A1D79879B3C32C588BCC6CA1D181E053022E1899222009E053B0AD52192E14B7
          9C2288D3BC3E55FDCA27B24779D136EC5E82FD1F001C5D0AEE79A5552C3D9439
          33FB0D2367706F6EEE92E06E8A40F0A8B0CA7FA912B4F15988A51214C7281F8E
          9269A3FCBC55B42AC03C359EA23FEA7B1E227E0247489C1700ABEFC22EDB2874
          674773B02C05C158106A40056C1BA80E4137044C1F9B4460410876C1025941B8
          C90F59200B86094911C988037D5A476E220B5F358144C2876D0B977213F32B01
          4CBEB0F8D6D0F2B5CFB822293E3E08A7A4F2EE409424E8190313831A6C418244
          01443AA2D09279F81B7CB04B0EB48104EA970451CEA1A838701C0B82B21A4672
          C641F1B828286E7C99262A000EEE146E09AEE87AB669CB8DF036952038A30491
          876D24E1183328D91AE051A0CD645048E5E06FAE4166A488899E19342C8921D6
          D50EC8D5DC8E0C59CD48758F438F3F6BD774C92FC9BEF02FA8978FBE14C07B3B
          B156B5F1A1A7268050E765082C5F0977731492B70AB2AA507822F2D326D2890C
          1CAB00973F0443B3A130E29AF66A022DC2488DA3303E89D4A177913E7A08FE25
          CCDE9A4604EBBC7951566E716C61DF7FA342ED248047D70275513CD210C26E8A
          5D0CB642F22D27BA681BE4AA8590BD11481E17010549AF0AA7988799D7782FC2
          4C275018ED85363485DC08901FA72C7CACE1AB6368E8F0302D8B50CA4DBF6A5B
          856B59E35F00E059D50DE141A22DEA505B9729372F5C50FA6DA0D6130C74F8E1
          0B4CC21DE64311400990080F2B41E65B1660D2050A291E384133E0A15A5A8065
          8A28293E841787D1BA7625D4701766FB92284EBDFC8A20E5360B90BF00A06A63
          02C2DE4E116BB6849B3B6FAAFB43FC99A16BC60FD36D3AEA11E2466A6D80C079
          A24021960C508715710A22C565D3AEF81B12D971F9E0AD0923D2D80CB74B853E
          91C2CC2743D087DE4478A5F9B4DB8B5D223370AE3D0437D165321F5EC8D2733F
          0DD9FEDEC88133187F6D120A75A736BBA1B67B217A0290428DA4DFC7CB0BD9E5
          625AAA48AF481DE4A0921945D460CD66A18D8E203F3203FDCC24EC34D971309B
          29E1DAAC85F734ABE2639F5B3B1F2780E49FDA58EBFE97A31B366C526AA7117F
          E70324FE750A5E5A41B00570B3CABCF54C450D75C194C05B4E1EAF724A759290
          610A26E7D2614E339DBC720519A97478A2F783CCAD7DC7CC378679B0E3E22BF6
          E701FC3D4900FBAE060222FED27871C78E866BAF81AB41C46C5E47E6CC14B223
          2799F349788259C86E8BD197EB7CEEE5B2F3390251963CCC7F2D2C4D45E2D42C
          524E17A297EE4241AC2DE4C6461EEB79E589873F7EF38D4989F4ABBECFA7E1A9
          38013CD00A5CB5D9FB549DA9ED3273ACE6256D08AD5E0457CC03C1E5A73BCAD0
          B2328A4C8B65042A7DC0D01826AD4E12A90B4B4369360523ADE1406231DABE75
          0F96755C8063DD07992619F5CD6DE3A75E7B6ED39B8F3E7454A01044F91C00F7
          8780AD7B16EEAB5FD870FDC4DBEFC1AD3B087700BE45A4BC4A861AF1B20A1456
          0139772973D49B066C7A8191B2A027746883268EF601AF3B3FC56D77FC10567E
          0A6E8F17A669A23F3E80DAE6B6C1834F3E78F9BB4FBC3856D5F21F162A000EFC
          BC0EE278F648DB15EB56E5BD0B604CC761E9299A501AFEC828DC04A8FA29200A
          5F54CBD493750AAA44460A334096F94F8F847038B10403FE1B70E7F7B7C3300C
          343636560E19397D1A270787E196A5B75FFFE57D574EF41DA7997D068033B462
          EFD1273EB9474E43087650ED8D4B5152EBD88B2C1EA433BF2596A0CCFE203070
          57E545C5552495A4533419A50D6D7A06DDA7AB30E4598FDDB7EFA8989EDBED46
          B92D4722119C3AD987E1441A6662E0B617EEBDFDCF723910791E80D9BBC11E1B
          4C0B63EF1CE1B441EAA9745F1DA3A6EAA5482B443AA0E471537C12FFF0963B35
          F34F5FE0C1665643762C8DF1EE11F49C8E60B4F5017CF7E61BA0C822B2D92C82
          41BA275F90E81DA7FAFB5174A4C4D1E77EB5F49D3FEE4BF9C8ECDFD204D0BF77
          95D1B4EDDBCACCCC30260EBEC57A1AA5B84AA0B7201463D5D5321ABAA1CCDF82
          77BEFC0A94416EAEF4A6E2C0600F30946A4676F18FB071F375087086181A1A42
          6B6B2B128904C2E130B2990CA6F34564064FEC39F6D23F1E0ED6B9B1E7F17D10
          3ED88E64A8BDA5BAEA9275509BAAA19714CC26A75956E39C79D2743F1BC25CC3
          654A4C4664554CA81C9953F2A2A0F99018D531DA3B0469CD6E746EDA85A66A1F
          F6EFDF8F152B56544094D36159160E1D3CC4F47AE39FBEF2E4F281F77B8ABF79
          FB43084377E2066AE651C341CCD51440F8221F27A1184BB01686E5E5A10AF5C0
          19C1F1A164B04D5B39884EA9527E763E0D7D6A14E9B13C867BB21056DD8AB6AD
          3FC3E2D67AF49E388E3367CE40D775C462B18A285D74D1DEF8307A9E7FE49BF1
          F7BBDF7AFCE301089735515492B0FEC1CDBED7EA5A6C556E30E00A5A6013843B
          3AEF7EBE72F39E2F5EAABF44F5EB53956C21CB2BC986747A989909B7A2F38E17
          B0A0BD83E39A8E542A851247B8B1B131D4D4D45434D1F7692FAD3CF0B0EA71EF
          59BF760DCEBAF3C5AF6F930F879A5A60D446116C36E0A97220C9D36C3E3C4D60
          D2C1114CE0D4C39B5D64456832DBB28A4281483D8D28B9AA91189944F58577A1
          65ED7710502D9C3AD50FAFD78B502854893E9D4E63606000BAA6BD415D6C5C7F
          C515730038732CFFF57A3CB7AD1D2B0B1C420A2D0B013F0BDF4515BBFDB45C0F
          27238E65F452856522C91C4A551D6EBFC08D598AB4EED47012FDEFC75170FC58
          76D75F11A88921979EC291231F550094CB311A8D56D8484D4F9F66A5766CDDBA
          553FCB809F43EEE5BB57E1C79B5AB16EDD45F0079A69BDA45E0AB20B725241D9
          09DD2C45599963839330720EDDD0E020328BD93107A34CC3BBDD70AAAEBB57EF
          BCFE07DE884F66702292C96485098FC75329CFBEBEBEDCDD77DFDD3C3131913E
          0B409CEF718D3E1597AD6BC325E1106A6EBC142B3BDAD0108C50C8ECCA2ABBB3
          5C1E05CA0331F5A86761A7A660C60791DA7F18F193A3C84C25905348F77D0FED
          DD145BB43CD4126BA8445E28142866BB02E0446F6F72E78E1DEDB4EAD9733A74
          656C71CF83294F9A2D9C476BE8237E06E22E7F8BF02ED3E06C0E27A6EDC0A2C6
          8C82018D94E6CBEFAB02EA5507D1A5ED4D2B6EBBE7FEEBFDC1B0B86C69079A9A
          9A2A1551B6E978BCFFA5EDDB6FDAA2691ACE0570EE92E64129F32C9DBD9CCF5C
          E567D4F2582C0BA8A509C65411CDBA89AA452DF55D1BB76CBB2ADA1073777576
          A1BAAA8AF94FF63FF6BBDF6EFFE7FE577B6C46F25500CE779519F3D39B224413
          E14754B54B4475DE4034E853572CED5ABDDAE70FF8C7C7460F8C0C0CFC3E95D7
          0EA25C535C5F1700E92C13A44765DB701384CB27D1412CB8F334500E4F05D295
          2495298E938651FE8EF91A1938BB2AFB9109814804B220B0706C02B1CB4D8C5F
          70D0593C53C5B9872B00CEF74BF6FFB5FE0D3DE199FD922ACEB1000000004945
          4E44AE426082}
      end
      item
        Background = clWindow
        Name = 'PngImage2'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000008D34944415478DA
          AD570B70545719FEEEDDDD7BF76637BBD9BC13B6A54B48080C09459A40795444
          2C582AA3D43EACCA881606DA412C14A1AD7D3A360A3A0AD2964A49471DABD83A
          40624120BC8402014A1004421E6C92250B21C9269B7D3FAFFFB9FBE8060246C6
          33F3CFF9EF39F7FEFF77FED7F92F87BB1CA5331E53D124351EF99BFB6E65B0C1
          0D53197BAF92E81B44B389CC4439443C9197E83AD105A29D44B504EAC6FF0D00
          299F49D316A2D1C31128CB7294A6AD1CC7AD2220AEBB06408AD368AA225A9EFA
          9ECC06E08498E681A08DC03B207291B091146A53BF8F4623D722A1C033AD2777
          EFFA9F0190F269347D40549C58CB2DC8F0784B1EEA93CBE7186714E7A54FCC00
          448A02812404A2B27CEC5CB3F350ED0E57F0D2C95C5A121360C341DF5F823EF7
          32DBF923CE610120E5F369DA8E987F2168383CBF200F0B1794A051FA2AEC8162
          9834B44ECA453E4E713E48C6AFEBF0CAEB5F5CDB13E8B6E7246446C2A1A6AE96
          862903DDB6BE3B0220E5598805531E7B9E304A42D5A20258F2E940E913C80C93
          70C99B839E801E022934AB06105689887062CC1AB4A6256AF7CA58BD7577AF75
          47753A2910982C9FCBF1E7F6B3079F23B6EF4E00B6D1F404E36796EBF1F67366
          F03CBD228D04F46349940E61C984E38E4244640D4A355DC84D8BA02598478254
          8A1512960990355EA8B3854EAF7B9E4950B1E0EC69BFB8A2D7D6B895E1B90500
          297F9CA6BF32DEA853A1F68D51C831AA639BA6A9E4108A317D169C5C068EF68E
          00C7A95026D861D67AD0C765C116CC8C016056885BE39A1F5858F5C7EBFE633B
          F3E3AEB0593FDBBB281CF41F64719A0410377D2351367B5EFF4C211E9D6C8C29
          575132A497016919700A79D8DD65A1D3AB91ABF162B6EE320151C32F64A1C153
          9874819012177F688BA27AD5D2EB7039F2E3AEF8985CB196D8D654004B697A97
          F1B327A6E3B7CF9A3FF78B8630198BE1D2DD836DF612F8A322C6095DF892BE99
          9453341280A82E13871CF791622E190B89E064E3E9DA8E48DF3B2B6552A696A3
          5157D3F19AA7E468A48EB68209007B687A98F13B5EB3608C3925A5C54C78F3A7
          E27D5B390642121ED15DC044A9131CAF569483CD04E0405F11C21417A92E4880
          78F11C70F19D575BA31D178B98C85EDBE597BBDBFEFD11B1CD1C29D7C5235363
          CE16E47D55455C4466812B43C545E02F1C878D9D8FA0CB9F8E6CD98D35850763
          F9193FBD0220CD84632E0B6E840CB7C4017BDE62050EEF3F782554F3F628F6A9
          DFDDBFB3AD61FFAF883DC2008C8BA79EE2F7754B2C387A4842E5243F441387A6
          CC4AAC6B9A050DCF233F32806538806C4A4F9EA108531CA90888211735D78AE0
          816ED0C913FCF64E604F734F38B061A912D5A180F71455C83789AD63006611B3
          9F6D2C9E9B85472BC662497831F6E4FF86AA2D8571BE051F3AA6616FF71845A0
          097E4CF2B6A0427315990672AA56C09560368E68CA07055F82585A6E6CA6DAE0
          266BFEECC9080BEB483878A5F978ED0AE2CF70A9E9B7E64933B68D7C053E2A2E
          7B0A36409408802821622EC64B1766A3D36F1A54FD6227948962C1372ACD8D02
          29A0ECF31C0F9D2A8A81B006AF5D50C1EED7C157F5B413E1A0311A89F4361DDB
          F13D5279910160D7EB3E06606A65B1AF614E959415EA474DD6064819E1582066
          E6E3AAB618AB2F3063A9079D8EA55D89DE85F90536E489545F8274C8307D2733
          14E49E7027A244579C7ACCFF7E0DDD1A324F1668230BB04BAE9501184FCC79E5
          F2C8B7B4A72D5E3FD210F6A0565D85F47BE3758A2550763E6A3D0F6073472574
          EAC1F7C0ABA50DC88BF6026E77EC0A5132849407A82DF0342A226EF487F0C5D5
          2D88C580EFB3D693BB5E27D6CA0018089583AE5395AC117BD2D6FE299B654075
          D7CF31A1C24785428E81102434E8A7E00767672183643362912EA9646C2A3F0A
          A9A79DB937766A565E420EAA3A36259BD838F82F179EDD7455E1FD1EE7DFDBCE
          D4BD47EC25E58863A62F384A00A62969BF6C03F8EC11B0F83AB1215A8D11E323
          E02264D68251A8BAFA103EEA2C4A9608AAD83090BE578A4F638AEF04E9A5D347
          C90DA18144A58D199030ACDED2257F72CAA1E8EBB3B7BED1D57AF634B1671300
          5611805F329E1FFBA057FCE62AD68C2037E8C0AF43BFC7984924CC60C2571ABE
          8DBE9078F38D8A39793654993EA4E6CC0DBF3F0D2D9754B827C70BBD59204C51
          349C0AE0BBBFBB1CA22AA8A13BC9DB52BFEB3BD4AC84E8D37F262A6121B9A189
          40E8146B7FEB255935FA0BCA9E14096065EF368C2C15B0C4F114861A99420075
          E3AB811E3B7658CBF0A6EA096407FB31CF71143A8AA78DFF383D10BA6635B077
          031EE72EEB993A56F6592F7920791B1655CC7D41A3D5AD8FFBDBA75DB159E2B4
          BAA49231DE365C4EBB6F48002A4EC6C98A6A70D7DBF0D6F92FE363E3CCE45EB8
          FE936068EF074A4F4016B05BCFECFB117548EC3AB6B20298DA0F70A327CFAB57
          0BDA0AC515A593DDE2E3ABF5894D6D34003F2F0E0960D1C8CB586ED80DD9E9C0
          8FCFCDC3FE8CC9CA7AB4F71A029B5704A94114587BE6E86C7EB9DB7AFE7C3C32
          0F13B90735243996B2499985A30F733CAF1C9DB794BB85AF2FD7737A136E3716
          9A1BB122AB0E5C5F97F25C63BF1FAF871F43F8E231996ABF9F724E62EB419F6B
          FB95D37BABE39F75109D0386E809CDE3A7FF546FCAFB4972412DF8355F5B26AA
          C7CFB8E5DDB7461FC65C7CCAA427D71C5E0E0FBF2B7A3C8D0D49FF5187CC1A91
          9521BFD7CFB0C44F1F1812000DB1A0E48135E939E6953CAF322616C91A2EF5E4
          79E9BCA58C2E4181CA8D8C1345BF803AE451F6AF7607B1EFAC07EFEFEE81C315
          FE3C06A8FBE9BC7462AB6FA0D71937FD718633E9F7DB58D62019B2E6149454FC
          509074D307ED707C007A938337E5F1C582C7C87B1DAA5E5780BFE10AAA525F23
          97F7BB7A3A37D91BEBEB134B71B3DB0689C3ED07AB0595648DB9861CF3328E57
          1930CC41A7FED4DE78F23DAFB33BD1013393341075DDFCEE7FFB3563F777995A
          902CD9F7964E948C390F6AC4B4FB294833A966A4FE2D05A2E1507BC0EBAC1FB8
          613BD17FDDDA9122C319573EE44FECB07E4E69B058A0BE3CD6B4923578293DD3
          4829ABF5BBFBFAE3797DF3608586DD44F63B091E2E80C460919D1727C68B2932
          58743320DD7153F70D47E07F0077AB7833A9F89E2A0000000049454E44AE4260
          82}
      end>
    Left = 24
    Top = 377
    Bitmap = {}
  end
  object BrowseDirectoryDlg1: TBrowseDirectoryDlg
    Title = 'S'#233'lectionnez le r'#233'pertoire contenant les affiches'
    Options = [bfDirectoriesOnly]
    Caption = 'Affiches'
    ShowSelectionInStatus = True
    Left = 64
    Top = 380
  end
end
