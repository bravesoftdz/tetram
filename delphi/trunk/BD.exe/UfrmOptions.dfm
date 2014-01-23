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
          F40000000473424954080808087C0864880000001974455874536F6674776172
          65007777772E696E6B73636170652E6F72679BEE3C1A000006884944415478DA
          ED970B50546514C7FF77EFDE7DB2C02EA88BA820282A609A285A6298DA683E40
          D392CAC9CC573EF3318E53368D8FB499DE36E30C5166242A68A26526DA68CE14
          8C64858A8682C48ABAAE2B2CB00BCBBEEEBD9D0B48281292344D33DD999DCBDC
          DDEFFBFFEE39FF73BE03238A22FECD8BF91FE03F07C070095DE936993E5320F2
          3F43284A1585EACA7F148044A3E99604514CD270FCF0717D6A64E3FB5623B330
          183F94E94C10EDEB215CD84B7BD5770A0009CAE996D0249A6CD47923A6F4B761
          CA001BC645D640CD09CDBFDD75A60BD61C09C70D077302E2AD7510CA7EA63D7D
          1D0620517FBA4D68129D38D0E8D427916012090FEB510B86697B13879BC5FAE3
          3DF1515E88DB27B8B743B8B20562A559BC8FF032908F94DEF6734EC63F9DD8DB
          A190DE54120ED7BB3B9CCF0B37D558FA75244E96E9CC84B519FCF97462A86B0F
          E029BDCAB5FF9D09C5983BCCD161D17B5D99E782B1FADB7098ED6C1EC40A4A4B
          692E8178DB02D83A31EAFAF2E71E32C15AA7C5EC38270CEA072FCD5A8F0C1B8E
          F7C2D65CA3CF2B78774228DF441E31DD9D1609207FE398B3F11186DA86070E37
          8758238B847057A744A3C8AAC6B24311385EAA3904FEF41A7A54420CCD2E9600
          4E2E197E29F1919E15CD8B2446A7CF0FF38792F9640F0650E53F0839F6C7F1FC
          BADC13A2EFF40A7A74B1653A24808C2121B6E7578D2C6AB5F8569D0A4F3DE441
          2F7FA1239A10695B5B8F6498FAADC44DFD28980A0AB064E6E253E0F317D0D7C5
          04D0EC700960960CE2CEA763AF6072FFEBB8BBDAEA5906C65E324C0EE4DB15E6
          E57EB0F599034BD462B8FD22E09571705147A8B87A15CF24A698C017A6903BCE
          B56C58120047F797E8933A70D2652CD259E1EF6B6DC2AA6016F34279A8EE9112
          B7A6272AFB2F85352C054E170F9653401B1402AFC0C04DDC1E4735968D4DC039
          4B801962D55A0817B309C2D9002099929AD07C043BD390741901354A2C0AA841
          ACBD75D554A96578A2B70AFD940D6B51AD8F87A5EF525418460182175A5D4083
          8104DE0BFF2EA1E0E93D6C9652980E6C4656D6F738566C14888FCE8F2BAF41B4
          9C21EDCADB00B918667E14031B8DC838594CD17A31DD5E07F6AE60882C8788F8
          24B86316A0CECA43D1AD2BFC427A80F13941D982BF21089C4A05F3B53C9CCA79
          037B5C6771A65607F1CB6E40B9D202D1F63A844B5F916E45CB085C42DC8D280C
          BAF5A712F92E8A4A7289AC1A41EE1626E4B490CDF81A01E93BA0CCCE009FBA0B
          AAF811080CEA42703E94947C83EF7237E3A0CA0AAB8A6D5C020586F02391BFF6
          3AE0858BDAF42B047188BEB2DC064885BE7E21A695B40ABBD6AEC4027F3BE2EC
          9E46A31947409E9C0EC3A615509C3802BC9D06F7936371AE7837722E6C436E80
          175EB6D1CA5D145D3137661E9EEDFB222CA595189F309B87F0DB6310ABAF49E2
          A4EDB90D309E827B18C3CD2C62EE71B4D361F304C7639693721F3503B231EF42
          BF6D23BCD5D751E65F890F8616E3AA966DFE79AC3E168B635FC6F4C8A990310A
          3223A9DDA8C490E8A91459EB6C082539A46B6D4E41C31F5CC228325026C2ECDD
          31EA2AA06C5DFBE14E155619BAC132FE3DDC3CBA01BB7B17C1681551162AA772
          62F078C8582C8C5E88A17E3134AB78A0D71BC02A55F0D156B54E17C207D0096F
          53515DB852C117BD498560B9631E2088608248879F6F22465F01BA395B41A81C
          1CDCD11C447D635F50B16A4CEC3E032F44CC4198C2004E2690B01E6A95026A05
          27590955F65AECCBCBC6CAB457811F7B50BF97068AFA6DE00B3E6C3590108494
          C0D514AB2D88BBC9DD61CCA64BCE2811193318F1BDC7605A680A82650C147206
          7EBA402858812044E8344AD438EC48FB2E1D1F7EB103EE421DD5AD54BF9E8310
          2C1910AF5DA0AD2ADA1CC908643845230BA17561482C07D4770E39CB13DFC784
          C8D1E0E47228B50150C20325274168515E6E42DAB79F2233EB28501A08F840F3
          41FD1E08A67D64400A2D2A6F9F077F3913124420417C46E2D31A20421B670B95
          5C83CF669E845A6D808695845968D41A9CBF5888ED073E41EE91423A4834E46B
          BE00A223834A8ECAC52799AEAAE549D82E400B90251084F731B84281382BC282
          06E09D497BA0A01C33D4980A7EC9C7CECCED28FDC942FEA26600EF316A38245C
          7A4A0A3369B439E9DCF7584E100F5334F63246571F5DB21D6F251FC6AF3FE6E3
          4056066CA50DB3440DA9EF8360DE4D6DB6B829CCED0E151DFABF8020A8A78A1F
          53893EAB502BE0A9A14A108532A08E5AE2EFD9546CE626E1F68FCEBF03D00264
          2E09CF2443EDA793ED045148A552733F5370A700342F6618B6236FDBE9009D71
          FD01F5701C24244AC9A50000000049454E44AE426082}
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
