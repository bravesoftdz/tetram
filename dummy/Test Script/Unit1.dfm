object Form1: TForm1
  Left = 412
  Top = 168
  Width = 870
  Height = 640
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object mScript: TMemo
    Left = 8
    Top = 8
    Width = 585
    Height = 225
    Lines.Strings = (
      'const'
      
        '  urlSearch = '#39'http://www.encyclobd.com/biblio/find.html?query=%' +
        's&submit.x=0&submit.y=0'#39';'
      ''
      'var'
      '  s, s2, s3: string;'
      '  i: integer;'
      'begin'
      '  s := GetPage(Format(urlSearch, ['#39'Lanfeust'#39']));'
      '  '
      '  if Pos('#39'Aucuns r'#233'sultats correspondants'#39', s) > 0 then begin'
      '    SetHTML('#39'Pas de r'#233'sultats'#39');'
      '    Exit;'
      '  end;'
      ''
      '  s2 := '#39#39';'
      '  try'
      
        '    if Pos('#39'La liste de r'#233'sultats '#233'tant trop importante'#39', s) > 0' +
        ' then '
      '      s2 := '#39'R'#233'sultat partiel'#39'#13#10;'
      ''
      '    i := Pos('#39's'#233'rie(s) trouv'#233'e(s)'#39', s);'
      '    if i > 0 then begin'
      '      s2 := s2 + '#39'S'#233'ries :'#39'#13#10'#39'---------'#39'#13#10;'
      '      s := Copy(s, i, Length(s));'
      '      while Pos('#39'serie.html?id='#39', s) > 0 do begin'
      
        '        s3 := findInfo('#39'<tr valign="top">'#39', '#39'</td></tr>'#39', s, '#39#39')' +
        ';'
      '        if s3 <> '#39#39' then begin'
      '          s := Copy(s, 17 + Length(s3) + 10, Length(s));'
      
        '          s2 := s2 + Format('#39'%s (%s)'#39'#13#10, [findInfo('#39'class="d' +
        'efault">'#39', '#39'</a>'#39', s3, '#39#39'), findInfo('#39'serie.html?id='#39', '#39'" class=' +
        '"default">'#39', s3, '#39#39')]);'
      '        end;'
      '      end;'
      '    end;'
      ''
      '    s2 := s2 + #13#10;'
      ''
      '    i := Pos('#39'album(s) trouv'#233'(s)'#39', s);'
      '    if i > 0 then begin'
      '      s2 := s2 + '#39'Albums :'#39'#13#10'#39'---------'#39'#13#10;'
      '      s := Copy(s, i, Length(s));'
      '      while Pos('#39'album.html?serie='#39', s) > 0 do begin'
      
        '        s3 := findInfo('#39'<tr valign="top">'#39', '#39'</td></tr>'#39', s, '#39#39')' +
        ';'
      '        if s3 <> '#39#39' then begin'
      '          s := Copy(s, 17 + Length(s3) + 10, Length(s));'
      
        '          ShowMessage(Format('#39'%s - %s (%s)'#39'#13#10, [findInfo('#39'" ' +
        'class="default">'#39', '#39'</a>'#39', s3, '#39#39'), findInfo('#39'">'#39', '#39'&nbsp;&gt;&n' +
        'bsp;'#39', s3, '#39#39'), findInfo('#39'album.html?serie='#39', '#39'" class="default"' +
        '>'#39', s3, '#39#39')]));'
      
        '          s2 := s2 + Format('#39'%s - %s (%s)'#39'#13#10, [findInfo('#39'" c' +
        'lass="default">'#39', '#39'</a>'#39', s3, '#39#39'), findInfo('#39'">'#39', '#39'&nbsp;&gt;&nb' +
        'sp;'#39', s3, '#39#39'), findInfo('#39'album.html?serie='#39', '#39'" class="default">' +
        #39', s3, '#39#39')]);'
      '        end;'
      '      end;'
      '    end;'
      '  finally'
      '//  SetHTML(s2);'
      '  end;'
      'end.')
    ScrollBars = ssBoth
    TabOrder = 0
    OnChange = mScriptChange
  end
  object mResultat: TMemo
    Left = 8
    Top = 312
    Width = 593
    Height = 217
    Lines.Strings = (
      'mResultat')
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object Button1: TButton
    Left = 8
    Top = 240
    Width = 75
    Height = 25
    Action = actCompile
    TabOrder = 2
  end
  object Button2: TButton
    Left = 88
    Top = 240
    Width = 75
    Height = 25
    Action = actRun
    TabOrder = 3
  end
  object Button3: TButton
    Left = 184
    Top = 240
    Width = 81
    Height = 25
    Caption = 'Compile && Run'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 392
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Button4'
    TabOrder = 5
  end
  object PSScriptDebugger1: TPSScriptDebugger
    CompilerOptions = [icAllowUnit, icBooleanShortCircuit]
    OnCompile = PSScriptDebugger1Compile
    Plugins = <>
    UsePreProcessor = False
    Left = 600
    Top = 8
  end
  object ActionList1: TActionList
    OnUpdate = ActionList1Update
    Left = 640
    Top = 64
    object actCompile: TAction
      Caption = 'Compile'
      OnExecute = actCompileExecute
    end
    object actRun: TAction
      Caption = 'Run'
      OnExecute = actRunExecute
    end
  end
end
