unit UScriptsFonctions;

interface

uses
  Windows, SysUtils, Classes, Dialogs, WinInet, StrUtils, Math, UMetadata, TypeRec, Generics.Collections;

type
  TScriptChoix = class

    type TChoix = class
      FLibelle, FCommentaire, FData: string;
    end;

    type TCategorie = class
      FNom: string;
      Choix: TObjectList<TChoix>;

      constructor Create;
      destructor Destroy; override;
    end;

  private
    FList: TObjectList<TCategorie>;
    FTitre: string;
    function GetCategorie(const Name: string): TCategorie;
  public
    constructor Create;
    destructor Destroy; override;

    procedure ResetList;
    procedure AjoutChoix(const Categorie, Libelle, Commentaire, Data: string);
    function Show: string;

    property Categorie[const Name: string]: TCategorie read GetCategorie;
    property Titre: string read FTitre write FTitre;
  end;

function GetPage(const url: string; UTF8: Boolean = True): string;
function findInfo(const sDebut, sFin, sChaine, sDefault: string): string;
function MakeAuteur(const Nom: string; Metier: TMetierAuteur): TAuteur;
function AskSearchEntry(const Labels: array of string; out Search: string; out Index: Integer): Boolean;
procedure Split(SL: TStringList; const Chaine: string; Sep: Char);
function CombineURL(const Root, URL: string): string;
function ScriptStrToFloatDef(const S: string; const Default: Extended): Extended;

function HTMLDecode(const Chaine: string): string;
function HTMLUTF8Decode(const Chaine: UTF8String): UTF8String;

implementation

uses
  ProceduresBDtk, UBdtForms, EditLabeled, StdCtrls, Controls, Forms, UframBoutons,
  UfrmScriptChoix, OverbyteIcsHttpProt, UNet;

constructor TScriptChoix.Create;
begin
  inherited;
  FTitre := 'Choisir parmi ces éléments';
  FList := TObjectList<TCategorie>.Create(True);
end;

destructor TScriptChoix.Destroy;
begin
  FList.Free;
  inherited;
end;

procedure TScriptChoix.AjoutChoix(const Categorie, Libelle, Commentaire, Data: string);
var
  Choix: TChoix;
begin
  Choix := TChoix.Create;
  GetCategorie(Categorie).Choix.Add(Choix);
  Choix.FLibelle := Libelle;
  Choix.FCommentaire := Commentaire;
  Choix.FData := Data;
end;

function TScriptChoix.GetCategorie(const Name: string): TCategorie;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to Pred(FList.Count) do
    if SameText(FList[i].FNom, Name) then
    begin
      Result := FList[i];
      Exit;
    end;

  if not Assigned(Result) then
  begin
    Result := TCategorie.Create;
    FList.Add(Result);
    Result.FNom := Name;
  end;
end;

procedure TScriptChoix.ResetList;
begin
  FList.Clear;
end;

function TScriptChoix.Show: string;
begin
  Result := '';
  if FList.Count = 0 then
    Exit;

  with TfrmScriptChoix.Create(nil) do
    try
      Caption := FTitre;
      SetList(Self.FList);
      if ShowModal <> mrOk then
        Exit;
      Result := FList[VirtualStringTree1.GetFirstSelected.Parent.Index].Choix[VirtualStringTree1.GetFirstSelected.Index].FData;
    finally
      Free;
    end;
end;

constructor TScriptChoix.TCategorie.Create;
begin
  inherited;
  Choix := TObjectList<TChoix>.Create(True);
end;

destructor TScriptChoix.TCategorie.Destroy;
begin
  Choix.Free;
  inherited;
end;

function findInfo(const sDebut, sFin, sChaine, sDefault: string): string;
var
  iDebut, iFin: Integer;
begin
  Result := sDefault;
  if sDebut = '' then
    iDebut := 1
  else
    iDebut := Pos(sDebut, sChaine);
  if iDebut > 0 then
  begin
    Inc(iDebut, Length(sDebut));
    if sFin = '' then
      iFin := Length(sChaine)
    else
      iFin := PosEx(sFin, sChaine, iDebut);
    if iFin = 0 then
      iFin := Length(sChaine);
    Result := Copy(sChaine, iDebut, iFin - iDebut);
  end;
end;

function GetPage(const url: string; UTF8: Boolean): string;
var
  ss: TStringStream;
begin
  if UTF8 then
    ss := TStringStream.Create('', TEncoding.UTF8)
  else
    ss := TStringStream.Create('', TEncoding.Default);
  try
    if LoadStreamURL(url, [], ss) = 200 then
      Result := ss.DataString
    else
      Result := '';
  finally
    ss.Free;
  end;
end;

function MakeAuteur(const Nom: string; Metier: TMetierAuteur): TAuteur;
begin
  Result := TAuteur.Create;
  Result.Personne.Nom := Nom;
  Result.Metier := Metier;
end;

type
  TdummyForm = class(TbdtForm)
  public
    procedure editChange(Sender: TObject);
  end;

procedure TdummyForm.editChange(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to Pred(ControlCount) do
    if (Controls[i] is TEditLabeled) and (Controls[i] <> Sender) then
      with Controls[i] as TEditLabeled do
      begin
        OnChange := nil;
        Text := '';
        OnChange := editChange;
      end;
end;

type
  TCrackLabel = class(TLabel);

function AskSearchEntry(const Labels: array of string; out Search: string; out Index: Integer): Boolean;
var
  F: TdummyForm;
  E: TEditLabeled;
  L: array of TLabel;
  i, t, maxW: Integer;
begin
  Result := False;
  if Length(Labels) = 0 then
    Exit;

  SetLength(L, Length(Labels));
  t := 0;
  F := TdummyForm.Create(nil);
  try
    F.Position := poMainFormCenter;
    E := nil;
    maxW := 0;

    for i := Low(Labels) to High(Labels) do
    begin
      L[i] := TLabel.Create(F);
      L[i].Parent := F;

      L[i].WordWrap := True;
      L[i].AutoSize := True;
      L[i].Caption := Labels[i];
      L[i].Left := 0;
      L[i].Width := 150;
      TCrackLabel(L[i]).AdjustBounds;
      L[i].Visible := True;
      L[i].Transparent := True;

      if L[i].Width > maxW then
        maxW := L[i].Width;
    end;

    for i := Low(Labels) to High(Labels) do
    begin
      E := TEditLabeled.Create(F);
      E.Parent := F;
      E.Tag := i;
      E.BevelKind := bkTile;
      E.BorderStyle := bsNone;
      E.LinkControls.Add(L[i]);
      E.Left := L[i].Left + maxW + 8;
      E.Width := 250;
      E.Visible := True;
      E.OnChange := F.editChange;

      if E.Height > L[i].Height then
      begin
        E.Top := t;
        t := t + E.Height + 8;
        L[i].Top := E.Top + (E.Height - L[i].Height) div 2;
      end
      else
      begin
        L[i].Top := t;
        t := t + L[i].Height + 8;
        E.Top := L[i].Top + (L[i].Height - E.Height) div 2;
      end;
    end;

    with TframBoutons.Create(F) do
    begin
      Align := alNone;
      Parent := F;
      Top := t + 8;
      Left := 0;
      Width := E.Left + E.Width;
    end;

    F.AutoSize := True;
    F.BorderStyle := bsDialog;
    F.BorderWidth := 8;
    F.PopupMode := pmAuto;
    Result := F.ShowModal = mrOk;

    if Result then
    begin
      Search := '';
      for i := 0 to Pred(F.ControlCount) do
        if (F.Controls[i] is TEditLabeled) and (TEditLabeled(F.Controls[i]).Text <> '') then
          with F.Controls[i] as TEditLabeled do
          begin
            Search := Trim(Text);
            Index := Tag;
          end;
      Result := Search <> '';
    end;
  finally
    F.Free;
  end;
end;

procedure Split(SL: TStringList; const Chaine: string; Sep: Char);
begin
  SL.Delimiter := Sep;
  SL.DelimitedText := Chaine;
end;

function CombineURL(const Root, URL: string): string;
var
  buffer: array of char;
  lbuffer: Cardinal;
begin
  lbuffer := 0;
  InternetCombineUrl(PChar(Root), PChar(URL), nil, lbuffer, ICU_BROWSER_MODE);
  SetLength(buffer, lbuffer);
  ZeroMemory(buffer, Length(buffer));
  InternetCombineUrl(PChar(Root), PChar(URL), PChar(buffer), lbuffer, ICU_BROWSER_MODE);
  Result := PChar(buffer);
end;

function ScriptFormatSettings: TFormatSettings;
begin
  GetLocaleFormatSettings(1033, Result);
end;

function ScriptStrToFloatDef(const S: string; const Default: Extended): Extended;
begin
  Result := StrToFloatDef(S, Default, ScriptFormatSettings);
end;

var
  HTMLEntites: TStringList;

procedure PrepareHTMLEntites;
begin
  HTMLEntites := TStringList.Create;
  with HTMLEntites do
  begin
    AddObject('zwnj', Pointer(8204)); // zero width non-joiner,   U+200C NEW RFC 2070 -->
    AddObject('zwj', Pointer(8205)); // zero width joiner, U+200D NEW RFC 2070 -->
    AddObject('zeta', Pointer(950)); // greek small letter zeta, U+03B6 ISOgrk3 -->
    AddObject('Zeta', Pointer(918)); // greek capital letter zeta, U+0396 -->
    AddObject('yuml', Pointer(255)); // latin small letter y with diaeresis, U+00FF ISOlat1 -->
    AddObject('Yuml', Pointer(376)); // latin capital letter Y with diaeresis,   U+0178 ISOlat2 -->
    AddObject('yen', Pointer(165)); // yen sign = yuan sign, U+00A5 ISOnum -->
    AddObject('yacute', Pointer(253)); // latin small letter y with acute, U+00FD ISOlat1 -->
    AddObject('Yacute', Pointer(221)); // latin capital letter Y with acute, U+00DD ISOlat1 -->
    AddObject('xi', Pointer(958)); // greek small letter xi, U+03BE ISOgrk3 -->
    AddObject('Xi', Pointer(926)); // greek capital letter xi, U+039E ISOgrk3 -->
    AddObject('weierp', Pointer(8472)); // script capital P = power set    = Weierstrass p, U+2118 ISOamso -->
    AddObject('uuml', Pointer(252)); // latin small letter u with diaeresis, U+00FC ISOlat1 -->
    AddObject('Uuml', Pointer(220)); // latin capital letter U with diaeresis, U+00DC ISOlat1 -->
    AddObject('upsilon', Pointer(965)); // greek small letter upsilon,   U+03C5 ISOgrk3 -->
    AddObject('Upsilon', Pointer(933)); // greek capital letter upsilon,   U+03A5 ISOgrk3 -->
    AddObject('upsih', Pointer(978)); // greek upsilon with hook symbol,   U+03D2 NEW -->
    AddObject('uml', Pointer(168)); // diaeresis = spacing diaeresis, U+00A8 ISOdia -->
    AddObject('ugrave', Pointer(249)); // latin small letter u with grave, U+00F9 ISOlat1 -->
    AddObject('Ugrave', Pointer(217)); // latin capital letter U with grave, U+00D9 ISOlat1 -->
    AddObject('ucirc', Pointer(251)); // latin small letter u with circumflex, U+00FB ISOlat1 -->
    AddObject('Ucirc', Pointer(219)); // latin capital letter U with circumflex, U+00DB ISOlat1 -->
    AddObject('uArr', Pointer(8657)); // upwards double arrow, U+21D1 ISOamsa -->
    AddObject('uarr', Pointer(8593)); // upwards arrow, U+2191 ISOnum-->
    AddObject('uacute', Pointer(250)); // latin small letter u with acute, U+00FA ISOlat1 -->
    AddObject('Uacute', Pointer(218)); // latin capital letter U with acute, U+00DA ISOlat1 -->
    AddObject('trade', Pointer(8482)); // trade mark sign, U+2122 ISOnum -->
    AddObject('times', Pointer(215)); // multiplication sign, U+00D7 ISOnum -->
    AddObject('tilde', Pointer(732)); // small tilde, U+02DC ISOdia -->
    AddObject('thorn', Pointer(254)); // latin small letter thorn, U+00FE ISOlat1 -->
    AddObject('THORN', Pointer(222)); // latin capital letter THORN, U+00DE ISOlat1 -->
    AddObject('thinsp', Pointer(8201)); // thin space, U+2009 ISOpub -->
    AddObject('thetasym', Pointer(977)); // greek small letter theta symbol,   U+03D1 NEW -->
    AddObject('theta', Pointer(952)); // greek small letter theta,   U+03B8 ISOgrk3 -->
    AddObject('Theta', Pointer(920)); // greek capital letter theta,   U+0398 ISOgrk3 -->
    AddObject('there4', Pointer(8756)); // therefore, U+2234 ISOtech -->
    AddObject('tau', Pointer(964)); // greek small letter tau, U+03C4 ISOgrk3 -->
    AddObject('Tau', Pointer(932)); // greek capital letter tau, U+03A4 -->
    AddObject('szlig', Pointer(223)); // latin small letter sharp s = ess-zed, U+00DF ISOlat1 -->
    AddObject('supe', Pointer(8839)); // superset of or equal to,    U+2287 ISOtech -->
    AddObject('sup3', Pointer(179)); // superscript three = superscript digit three = cubed, U+00B3 ISOnum -->
    AddObject('sup2', Pointer(178)); // superscript two = superscript digit two = squared, U+00B2 ISOnum -->
    AddObject('sup1', Pointer(185)); // superscript one = superscript digit one, U+00B9 ISOnum -->
    AddObject('sup', Pointer(8835)); // superset of, U+2283 ISOtech -->
    AddObject('sum', Pointer(8721)); // n-ary sumation, U+2211 ISOamsb -->
    AddObject('sube', Pointer(8838)); // subset of or equal to, U+2286 ISOtech -->
    AddObject('sub', Pointer(8834)); // subset of, U+2282 ISOtech -->
    AddObject('spades', Pointer(9824)); // black spade suit, U+2660 ISOpub -->
    AddObject('sim', Pointer(8764)); // tilde operator = varies with = similar to,    U+223C ISOtech -->
    AddObject('sigmaf', Pointer(962)); // greek small letter final sigma,   U+03C2 ISOgrk3 -->
    AddObject('sigma', Pointer(963)); // greek small letter sigma,   U+03C3 ISOgrk3 -->
    AddObject('Sigma', Pointer(931)); // greek capital letter sigma,   U+03A3 ISOgrk3 -->
    AddObject('shy', Pointer(173)); // soft hyphen = discretionary hyphen, U+00AD ISOnum -->
    AddObject('sect', Pointer(167)); // section sign, U+00A7 ISOnum -->
    AddObject('sdot', Pointer(8901)); // dot operator, U+22C5 ISOamsb -->
    AddObject('scaron', Pointer(353)); // latin small letter s with caron,   U+0161 ISOlat2 -->
    AddObject('Scaron', Pointer(352)); // latin capital letter S with caron,   U+0160 ISOlat2 -->
    AddObject('sbquo', Pointer(8218)); // single low-9 quotation mark, U+201A NEW -->
    AddObject('rsquo', Pointer(8217)); // right single quotation mark,   U+2019 ISOnum -->
    AddObject('rsaquo', Pointer(8250)); // single right-pointing angle quotation mark,   U+203A ISO proposed -->
    AddObject('rlm', Pointer(8207)); // right-to-left mark, U+200F NEW RFC 2070 -->
    AddObject('rho', Pointer(961)); // greek small letter rho, U+03C1 ISOgrk3 -->
    AddObject('Rho', Pointer(929)); // greek capital letter rho, U+03A1 -->
    AddObject('rfloor', Pointer(8971)); // right floor, U+230B ISOamsc  -->
    AddObject('reg', Pointer(174)); // registered sign = registered trade mark sign, U+00AE ISOnum -->
    AddObject('real', Pointer(8476)); // blackletter capital R = real part symbol,    U+211C ISOamso -->
    AddObject('rdquo', Pointer(8221)); // right double quotation mark,   U+201D ISOnum -->
    AddObject('rceil', Pointer(8969)); // right ceiling, U+2309 ISOamsc  -->
    AddObject('rArr', Pointer(8658)); // rightwards double arrow,    U+21D2 ISOtech -->
    AddObject('rarr', Pointer(8594)); // rightwards arrow, U+2192 ISOnum -->
    AddObject('raquo', Pointer(187)); // right-pointing double angle quotation mark = right pointing guillemet, U+00BB ISOnum -->
    AddObject('rang', Pointer(9002)); // right-pointing angle bracket = ket,    U+232A ISOtech -->
    AddObject('radic', Pointer(8730)); // square root = radical sign,    U+221A ISOtech -->
    AddObject('quot', Pointer(34)); // quotation mark = APL quote,   U+0022 ISOnum -->
    AddObject('psi', Pointer(968)); // greek small letter psi, U+03C8 ISOgrk3 -->
    AddObject('Psi', Pointer(936)); // greek capital letter psi,   U+03A8 ISOgrk3 -->
    AddObject('prop', Pointer(8733)); // proportional to, U+221D ISOtech -->
    AddObject('prod', Pointer(8719)); // n-ary product = product sign,    U+220F ISOamsb -->
    AddObject('Prime', Pointer(8243)); // double prime = seconds = inches,    U+2033 ISOtech -->
    AddObject('prime', Pointer(8242)); // prime = minutes = feet, U+2032 ISOtech -->
    AddObject('pound', Pointer(163)); // pound sign, U+00A3 ISOnum -->
    AddObject('plusmn', Pointer(177)); // plus-minus sign = plus-or-minus sign, U+00B1 ISOnum -->
    AddObject('piv', Pointer(982)); // greek pi symbol, U+03D6 ISOgrk3 -->
    AddObject('pi', Pointer(960)); // greek small letter pi, U+03C0 ISOgrk3 -->
    AddObject('Pi', Pointer(928)); // greek capital letter pi, U+03A0 ISOgrk3 -->
    AddObject('phi', Pointer(966)); // greek small letter phi, U+03C6 ISOgrk3 -->
    AddObject('Phi', Pointer(934)); // greek capital letter phi,   U+03A6 ISOgrk3 -->
    AddObject('perp', Pointer(8869)); // up tack = orthogonal to = perpendicular,    U+22A5 ISOtech -->
    AddObject('permil', Pointer(8240)); // per mille sign, U+2030 ISOtech -->
    AddObject('part', Pointer(8706)); // partial differential, U+2202 ISOtech  -->
    AddObject('para', Pointer(182)); // pilcrow sign = paragraph sign, U+00B6 ISOnum -->
    AddObject('ouml', Pointer(246)); // latin small letter o with diaeresis, U+00F6 ISOlat1 -->
    AddObject('Ouml', Pointer(214)); // latin capital letter O with diaeresis, U+00D6 ISOlat1 -->
    AddObject('otimes', Pointer(8855)); // circled times = vector product,    U+2297 ISOamsb -->
    AddObject('otilde', Pointer(245)); // latin small letter o with tilde, U+00F5 ISOlat1 -->
    AddObject('Otilde', Pointer(213)); // latin capital letter O with tilde, U+00D5 ISOlat1 -->
    AddObject('oslash', Pointer(248)); // latin small letter o with stroke, = latin small letter o slash, U+00F8 ISOlat1 -->
    AddObject('Oslash', Pointer(216)); // latin capital letter O with stroke = latin capital letter O slash, U+00D8 ISOlat1 -->
    AddObject('ordm', Pointer(186)); // masculine ordinal indicator, U+00BA ISOnum -->
    AddObject('ordf', Pointer(170)); // feminine ordinal indicator, U+00AA ISOnum -->
    AddObject('or', Pointer(8744)); // logical or = vee, U+2228 ISOtech -->
    AddObject('oplus', Pointer(8853)); // circled plus = direct sum,    U+2295 ISOamsb -->
    AddObject('omicron', Pointer(959)); // greek small letter omicron, U+03BF NEW -->
    AddObject('Omicron', Pointer(927)); // greek capital letter omicron, U+039F -->
    AddObject('omega', Pointer(969)); // greek small letter omega,   U+03C9 ISOgrk3 -->
    AddObject('Omega', Pointer(937)); // greek capital letter omega,   U+03A9 ISOgrk3 -->
    AddObject('oline', Pointer(8254)); // overline = spacing overscore,    U+203E NEW -->
    AddObject('ograve', Pointer(242)); // latin small letter o with grave, U+00F2 ISOlat1 -->
    AddObject('Ograve', Pointer(210)); // latin capital letter O with grave, U+00D2 ISOlat1 -->
    AddObject('oelig', Pointer(339)); // latin small ligature oe, U+0153 ISOlat2 -->
    AddObject('OElig', Pointer(338)); // latin capital ligature OE,   U+0152 ISOlat2 -->
    AddObject('ocirc', Pointer(244)); // latin small letter o with circumflex, U+00F4 ISOlat1 -->
    AddObject('Ocirc', Pointer(212)); // latin capital letter O with circumflex, U+00D4 ISOlat1 -->
    AddObject('oacute', Pointer(243)); // latin small letter o with acute, U+00F3 ISOlat1 -->
    AddObject('Oacute', Pointer(211)); // latin capital letter O with acute, U+00D3 ISOlat1 -->
    AddObject('nu', Pointer(957)); // greek small letter nu, U+03BD ISOgrk3 -->
    AddObject('Nu', Pointer(925)); // greek capital letter nu, U+039D -->
    AddObject('ntilde', Pointer(241)); // latin small letter n with tilde, U+00F1 ISOlat1 -->
    AddObject('Ntilde', Pointer(209)); // latin capital letter N with tilde, U+00D1 ISOlat1 -->
    AddObject('nsub', Pointer(8836)); // not a subset of, U+2284 ISOamsn -->
    AddObject('notin', Pointer(8713)); // not an element of, U+2209 ISOtech -->
    AddObject('not', Pointer(172)); // not sign, U+00AC ISOnum -->
    AddObject('ni', Pointer(8715)); // contains as member, U+220B ISOtech -->
    AddObject('ne', Pointer(8800)); // not equal to, U+2260 ISOtech -->
    AddObject('ndash', Pointer(8211)); // en dash, U+2013 ISOpub -->
    AddObject('nbsp', Pointer(160)); // no-break space = non-breaking space, U+00A0 ISOnum -->
    AddObject('nabla', Pointer(8711)); // nabla = backward difference,    U+2207 ISOtech -->
    AddObject('mu', Pointer(956)); // greek small letter mu, U+03BC ISOgrk3 -->
    AddObject('Mu', Pointer(924)); // greek capital letter mu, U+039C -->
    AddObject('minus', Pointer(8722)); // minus sign, U+2212 ISOtech -->
    AddObject('middot', Pointer(183)); // middle dot = Georgian comma = Greek middle dot, U+00B7 ISOnum -->
    AddObject('micro', Pointer(181)); // micro sign, U+00B5 ISOnum -->
    AddObject('mdash', Pointer(8212)); // em dash, U+2014 ISOpub -->
    AddObject('macr', Pointer(175)); // macron = spacing macron = overline = APL overbar, U+00AF ISOdia -->
    AddObject('lt', Pointer(60)); // less-than sign, U+003C ISOnum -->
    AddObject('lsquo', Pointer(8216)); // left single quotation mark,   U+2018 ISOnum -->
    AddObject('lsaquo', Pointer(8249)); // single left-pointing angle quotation mark,   U+2039 ISO proposed -->
    AddObject('lrm', Pointer(8206)); // left-to-right mark, U+200E NEW RFC 2070 -->
    AddObject('loz', Pointer(9674)); // lozenge, U+25CA ISOpub -->
    AddObject('lowast', Pointer(8727)); // asterisk operator, U+2217 ISOtech -->
    AddObject('lfloor', Pointer(8970)); // left floor = apl downstile,    U+230A ISOamsc  -->
    AddObject('le', Pointer(8804)); // less-than or equal to, U+2264 ISOtech -->
    AddObject('ldquo', Pointer(8220)); // left double quotation mark,   U+201C ISOnum -->
    AddObject('lceil', Pointer(8968)); // left ceiling = apl upstile,    U+2308 ISOamsc  -->
    AddObject('lArr', Pointer(8656)); // leftwards double arrow, U+21D0 ISOtech -->
    AddObject('larr', Pointer(8592)); // leftwards arrow, U+2190 ISOnum -->
    AddObject('laquo', Pointer(171)); // left-pointing double angle quotation mark = left pointing guillemet, U+00AB ISOnum -->
    AddObject('lang', Pointer(9001)); // left-pointing angle bracket = bra,    U+2329 ISOtech -->
    AddObject('lambda', Pointer(955)); // greek small letter lambda,   U+03BB ISOgrk3 -->
    AddObject('Lambda', Pointer(923)); // greek capital letter lambda,   U+039B ISOgrk3 -->
    AddObject('kappa', Pointer(954)); // greek small letter kappa,   U+03BA ISOgrk3 -->
    AddObject('Kappa', Pointer(922)); // greek capital letter kappa, U+039A -->
    AddObject('iuml', Pointer(239)); // latin small letter i with diaeresis, U+00EF ISOlat1 -->
    AddObject('Iuml', Pointer(207)); // latin capital letter I with diaeresis, U+00CF ISOlat1 -->
    AddObject('isin', Pointer(8712)); // element of, U+2208 ISOtech -->
    AddObject('iquest', Pointer(191)); // inverted question mark = turned question mark, U+00BF ISOnum -->
    AddObject('iota', Pointer(953)); // greek small letter iota, U+03B9 ISOgrk3 -->
    AddObject('Iota', Pointer(921)); // greek capital letter iota, U+0399 -->
    AddObject('int', Pointer(8747)); // integral, U+222B ISOtech -->
    AddObject('infin', Pointer(8734)); // infinity, U+221E ISOtech -->
    AddObject('image', Pointer(8465)); // blackletter capital I = imaginary part,    U+2111 ISOamso -->
    AddObject('igrave', Pointer(236)); // latin small letter i with grave, U+00EC ISOlat1 -->
    AddObject('Igrave', Pointer(204)); // latin capital letter I with grave, U+00CC ISOlat1 -->
    AddObject('iexcl', Pointer(161)); // inverted exclamation mark, U+00A1 ISOnum -->
    AddObject('icirc', Pointer(238)); // latin small letter i with circumflex, U+00EE ISOlat1 -->
    AddObject('Icirc', Pointer(206)); // latin capital letter I with circumflex, U+00CE ISOlat1 -->
    AddObject('iacute', Pointer(237)); // latin small letter i with acute, U+00ED ISOlat1 -->
    AddObject('Iacute', Pointer(205)); // latin capital letter I with acute, U+00CD ISOlat1 -->
    AddObject('hellip', Pointer(8230)); // horizontal ellipsis = three dot leader,    U+2026 ISOpub  -->
    AddObject('hearts', Pointer(9829)); // black heart suit = valentine,    U+2665 ISOpub -->
    AddObject('hArr', Pointer(8660)); // left right double arrow,    U+21D4 ISOamsa -->
    AddObject('harr', Pointer(8596)); // left right arrow, U+2194 ISOamsa -->
    AddObject('gt', Pointer(62)); // greater-than sign, U+003E ISOnum -->
    AddObject('ge', Pointer(8805)); // greater-than or equal to,    U+2265 ISOtech -->
    AddObject('gamma', Pointer(947)); // greek small letter gamma,   U+03B3 ISOgrk3 -->
    AddObject('Gamma', Pointer(915)); // greek capital letter gamma,   U+0393 ISOgrk3 -->
    AddObject('frasl', Pointer(8260)); // fraction slash, U+2044 NEW -->
    AddObject('frac34', Pointer(190)); // vulgar fraction three quarters = fraction three quarters, U+00BE ISOnum -->
    AddObject('frac14', Pointer(188)); // vulgar fraction one quarter = fraction one quarter, U+00BC ISOnum -->
    AddObject('frac12', Pointer(189)); // vulgar fraction one half = fraction one half, U+00BD ISOnum -->
    AddObject('forall', Pointer(8704)); // for all, U+2200 ISOtech -->
    AddObject('fnof', Pointer(402)); // latin small f with hook = function   = florin, U+0192 ISOtech -->
    AddObject('exist', Pointer(8707)); // there exists, U+2203 ISOtech -->
    AddObject('euro', Pointer(8364)); // euro sign, U+20AC NEW -->
    AddObject('euml', Pointer(235)); // latin small letter e with diaeresis, U+00EB ISOlat1 -->
    AddObject('Euml', Pointer(203)); // latin capital letter E with diaeresis, U+00CB ISOlat1 -->
    AddObject('eth', Pointer(240)); // latin small letter eth, U+00F0 ISOlat1 -->
    AddObject('ETH', Pointer(208)); // latin capital letter ETH, U+00D0 ISOlat1 -->
    AddObject('eta', Pointer(951)); // greek small letter eta, U+03B7 ISOgrk3 -->
    AddObject('Eta', Pointer(919)); // greek capital letter eta, U+0397 -->
    AddObject('equiv', Pointer(8801)); // identical to, U+2261 ISOtech -->
    AddObject('epsilon', Pointer(949)); // greek small letter epsilon,   U+03B5 ISOgrk3 -->
    AddObject('Epsilon', Pointer(917)); // greek capital letter epsilon, U+0395 -->
    AddObject('ensp', Pointer(8194)); // en space, U+2002 ISOpub -->
    AddObject('emsp', Pointer(8195)); // em space, U+2003 ISOpub -->
    AddObject('empty', Pointer(8709)); // empty set = null set = diameter,    U+2205 ISOamso -->
    AddObject('egrave', Pointer(232)); // latin small letter e with grave, U+00E8 ISOlat1 -->
    AddObject('Egrave', Pointer(200)); // latin capital letter E with grave, U+00C8 ISOlat1 -->
    AddObject('ecirc', Pointer(234)); // latin small letter e with circumflex, U+00EA ISOlat1 -->
    AddObject('Ecirc', Pointer(202)); // latin capital letter E with circumflex, U+00CA ISOlat1 -->
    AddObject('eacute', Pointer(233)); // latin small letter e with acute, U+00E9 ISOlat1 -->
    AddObject('Eacute', Pointer(201)); // latin capital letter E with acute, U+00C9 ISOlat1 -->
    AddObject('divide', Pointer(247)); // division sign, U+00F7 ISOnum -->
    AddObject('diams', Pointer(9830)); // black diamond suit, U+2666 ISOpub -->
    AddObject('delta', Pointer(948)); // greek small letter delta,   U+03B4 ISOgrk3 -->
    AddObject('Delta', Pointer(916)); // greek capital letter delta,   U+0394 ISOgrk3 -->
    AddObject('deg', Pointer(176)); // degree sign, U+00B0 ISOnum -->
    AddObject('dArr', Pointer(8659)); // downwards double arrow, U+21D3 ISOamsa -->
    AddObject('darr', Pointer(8595)); // downwards arrow, U+2193 ISOnum -->
    AddObject('Dagger', Pointer(8225)); // double dagger, U+2021 ISOpub -->
    AddObject('dagger', Pointer(8224)); // dagger, U+2020 ISOpub -->
    AddObject('curren', Pointer(164)); // currency sign, U+00A4 ISOnum -->
    AddObject('cup', Pointer(8746)); // union = cup, U+222A ISOtech -->
    AddObject('crarr', Pointer(8629)); // downwards arrow with corner leftwards    = carriage return, U+21B5 NEW -->
    AddObject('copy', Pointer(169)); // copyright sign, U+00A9 ISOnum -->
    AddObject('cong', Pointer(8773)); // approximately equal to, U+2245 ISOtech -->
    AddObject('clubs', Pointer(9827)); // black club suit = shamrock,    U+2663 ISOpub -->
    AddObject('circ', Pointer(710)); // modifier letter circumflex accent,   U+02C6 ISOpub -->
    AddObject('chi', Pointer(967)); // greek small letter chi, U+03C7 ISOgrk3 -->
    AddObject('Chi', Pointer(935)); // greek capital letter chi, U+03A7 -->
    AddObject('cent', Pointer(162)); // cent sign, U+00A2 ISOnum -->
    AddObject('cedil', Pointer(184)); // cedilla = spacing cedilla, U+00B8 ISOdia -->
    AddObject('ccedil', Pointer(231)); // latin small letter c with cedilla, U+00E7 ISOlat1 -->
    AddObject('Ccedil', Pointer(199)); // latin capital letter C with cedilla, U+00C7 ISOlat1 -->
    AddObject('cap', Pointer(8745)); // intersection = cap, U+2229 ISOtech -->
    AddObject('bull', Pointer(8226)); // bullet = black small circle,    U+2022 ISOpub  -->
    AddObject('brvbar', Pointer(166)); // broken bar = broken vertical bar, U+00A6 ISOnum -->
    AddObject('beta', Pointer(946)); // greek small letter beta, U+03B2 ISOgrk3 -->
    AddObject('Beta', Pointer(914)); // greek capital letter beta, U+0392 -->
    AddObject('bdquo', Pointer(8222)); // double low-9 quotation mark, U+201E NEW -->
    AddObject('auml', Pointer(228)); // latin small letter a with diaeresis, U+00E4 ISOlat1 -->
    AddObject('Auml', Pointer(196)); // latin capital letter A with diaeresis, U+00C4 ISOlat1 -->
    AddObject('atilde', Pointer(227)); // latin small letter a with tilde, U+00E3 ISOlat1 -->
    AddObject('Atilde', Pointer(195)); // latin capital letter A with tilde, U+00C3 ISOlat1 -->
    AddObject('asymp', Pointer(8776)); // almost equal to = asymptotic to,    U+2248 ISOamsr -->
    AddObject('aring', Pointer(229)); // latin small letter a with ring above = latin small letter a ring, U+00E5 ISOlat1 -->
    AddObject('Aring', Pointer(197)); // latin capital letter A with ring above = latin capital letter A ring, U+00C5 ISOlat1 -->
    AddObject('ang', Pointer(8736)); // angle, U+2220 ISOamso -->
    AddObject('and', Pointer(8743)); // logical and = wedge, U+2227 ISOtech -->
    AddObject('amp', Pointer(38)); // ampersand, U+0026 ISOnum -->
    AddObject('alpha', Pointer(945)); // greek small letter alpha,   U+03B1 ISOgrk3 -->
    AddObject('Alpha', Pointer(913)); // greek capital letter alpha, U+0391 -->
    AddObject('alefsym', Pointer(8501)); // alef symbol = first transfinite cardinal,    U+2135 NEW -->
    AddObject('agrave', Pointer(224)); // latin small letter a with grave = latin small letter a grave, U+00E0 ISOlat1 -->
    AddObject('Agrave', Pointer(192)); // latin capital letter A with grave = latin capital letter A grave, U+00C0 ISOlat1 -->
    AddObject('aelig', Pointer(230)); // latin small letter ae = latin small ligature ae, U+00E6 ISOlat1 -->
    AddObject('AElig', Pointer(198)); // latin capital letter AE = latin capital ligature AE, U+00C6 ISOlat1 -->
    AddObject('acute', Pointer(180)); // acute accent = spacing acute, U+00B4 ISOdia -->
    AddObject('acirc', Pointer(226)); // latin small letter a with circumflex, U+00E2 ISOlat1 -->
    AddObject('Acirc', Pointer(194)); // latin capital letter A with circumflex, U+00C2 ISOlat1 -->
    AddObject('aacute', Pointer(225)); // latin small letter a with acute, U+00E1 ISOlat1 -->
    AddObject('Aacute', Pointer(193)); // latin capital letter A with acute, U+00C1 ISOlat1 -->
    Sorted := True;
  end;
end;

function HTMLDecode(const Chaine: string): string;
Begin
  Result := Utf8ToAnsi(HTMLUTF8Decode(AnsiToUtf8(Chaine)));
end;

function HTMLUTF8Decode(const Chaine: UTF8String): UTF8String;
var
  CurrentSrcPos, CurrentResultPos: Integer;
  j: Integer;
  aTmpInteger: Integer;
  SrcLength: Integer;

  procedure CopyCurrentSrcPosCharToResult;
  begin
    Result[CurrentResultPos] := Chaine[CurrentSrcPos];
    Inc(CurrentResultPos);
  end;

  procedure CopyCharToResult(aUnicodeOrdEntity: Integer; aNewCurrentSrcPos: Integer);
  var
    aUTF8String: UTF8String;
    K: Integer;
  begin
    aUTF8String := UTF8Encode(WideChar(aUnicodeOrdEntity));
    for k := 1 to Length(aUTF8String) do
    begin
      Result[CurrentResultPos] := aUTF8String[k];
      Inc(CurrentResultPos);
    end;
    CurrentSrcPos := aNewCurrentSrcPos;
  end;

var
  ident: UTF8String;
begin
  {init var}
  CurrentSrcPos := 1;
  CurrentResultPos := 1;
  SrcLength := Length(Chaine);
  SetLength(Result, SrcLength);

  {start loop}
  while CurrentSrcPos <= SrcLength do
  begin
    case Chaine[CurrentSrcPos] of
      #0: Break;
      '&':
      begin
        {HTMLentity detected}
        {extract the HTML entity}
        ident := '';
        j := CurrentSrcPos + 1;
        while (j <= SrcLength) and (Chaine[j] <> ';') and (Length(ident) <= 12) do
        begin
          ident := ident + Chaine[j];
          Inc(j);
        end;
        {HTML entity is valid}
        if (j <= SrcLength) and (Length(ident) > 0) and (Length(ident) <= 12) then
        begin
          {HTML entity is numeric}
          if (ident[1] = '#') then
          begin
            Delete(ident, 1, 1);
            {HTML entity is hexa}
            if (Length(ident) > 0) and (ident[1] = 'x') then
              ident[1] := '$';

            if TryStrToInt(ident, aTmpInteger) then
              CopyCharToResult(aTmpInteger, J)
            else
              CopyCurrentSrcPosCharToResult;
          end
          {HTML entity is litteral}
          else
          begin
            aTmpInteger := HTMLEntites.IndexOf(ident);
            if aTmpInteger >= 0 then
              CopyCharToResult(Integer(HTMLEntites.Objects[aTmpInteger]), J)
            else
              CopyCurrentSrcPosCharToResult;
          end;
        end
        else
          CopyCurrentSrcPosCharToResult;
      end;
      else
        CopyCurrentSrcPosCharToResult;
    end;
    Inc(CurrentSrcPos);
  end;
  SetLength(Result, CurrentResultPos - 1);
end;

initialization
  PrepareHTMLEntites;

finalization
  HTMLEntites.Free;

end.

