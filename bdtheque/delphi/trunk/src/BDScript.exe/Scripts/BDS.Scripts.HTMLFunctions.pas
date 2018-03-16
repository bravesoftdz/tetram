unit BDS.Scripts.HTMLFunctions;

interface

uses
  SysUtils, Classes, StrUtils;

function HTMLDecode(const Chaine: string): string;
function HTMLDecodeCRLF(const Chaine: string; CRLFOnly: Boolean): string;
function HTMLUTF8Decode(const Chaine: UTF8String; CRLFOnly: Boolean): UTF8String;
function HTMLText(const Chaine: string): string;
function HTTPDecode(const Chaine: string): string;

implementation

uses
  Generics.Collections;

var
  HTMLEntites: TDictionary<UTF8String, Integer>;
  HTMLTagCRLF: TStringList;

procedure PrepareHTMLEntites;
begin
  HTMLEntites := TDictionary<UTF8String, Integer>.Create;
  HTMLEntites.Add('zwnj', 8204); // zero width non-joiner,   U+200C NEW RFC 2070 -->
  HTMLEntites.Add('zwj', 8205); // zero width joiner, U+200D NEW RFC 2070 -->
  HTMLEntites.Add('zeta', 950); // greek small letter zeta, U+03B6 ISOgrk3 -->
  HTMLEntites.Add('Zeta', 918); // greek capital letter zeta, U+0396 -->
  HTMLEntites.Add('yuml', 255); // latin small letter y with diaeresis, U+00FF ISOlat1 -->
  HTMLEntites.Add('Yuml', 376); // latin capital letter Y with diaeresis,   U+0178 ISOlat2 -->
  HTMLEntites.Add('yen', 165); // yen sign = yuan sign, U+00A5 ISOnum -->
  HTMLEntites.Add('yacute', 253); // latin small letter y with acute, U+00FD ISOlat1 -->
  HTMLEntites.Add('Yacute', 221); // latin capital letter Y with acute, U+00DD ISOlat1 -->
  HTMLEntites.Add('xi', 958); // greek small letter xi, U+03BE ISOgrk3 -->
  HTMLEntites.Add('Xi', 926); // greek capital letter xi, U+039E ISOgrk3 -->
  HTMLEntites.Add('weierp', 8472); // script capital P = power set    = Weierstrass p, U+2118 ISOamso -->
  HTMLEntites.Add('uuml', 252); // latin small letter u with diaeresis, U+00FC ISOlat1 -->
  HTMLEntites.Add('Uuml', 220); // latin capital letter U with diaeresis, U+00DC ISOlat1 -->
  HTMLEntites.Add('upsilon', 965); // greek small letter upsilon,   U+03C5 ISOgrk3 -->
  HTMLEntites.Add('Upsilon', 933); // greek capital letter upsilon,   U+03A5 ISOgrk3 -->
  HTMLEntites.Add('upsih', 978); // greek upsilon with hook symbol,   U+03D2 NEW -->
  HTMLEntites.Add('uml', 168); // diaeresis = spacing diaeresis, U+00A8 ISOdia -->
  HTMLEntites.Add('ugrave', 249); // latin small letter u with grave, U+00F9 ISOlat1 -->
  HTMLEntites.Add('Ugrave', 217); // latin capital letter U with grave, U+00D9 ISOlat1 -->
  HTMLEntites.Add('ucirc', 251); // latin small letter u with circumflex, U+00FB ISOlat1 -->
  HTMLEntites.Add('Ucirc', 219); // latin capital letter U with circumflex, U+00DB ISOlat1 -->
  HTMLEntites.Add('uArr', 8657); // upwards double arrow, U+21D1 ISOamsa -->
  HTMLEntites.Add('uarr', 8593); // upwards arrow, U+2191 ISOnum-->
  HTMLEntites.Add('uacute', 250); // latin small letter u with acute, U+00FA ISOlat1 -->
  HTMLEntites.Add('Uacute', 218); // latin capital letter U with acute, U+00DA ISOlat1 -->
  HTMLEntites.Add('trade', 8482); // trade mark sign, U+2122 ISOnum -->
  HTMLEntites.Add('times', 215); // multiplication sign, U+00D7 ISOnum -->
  HTMLEntites.Add('tilde', 732); // small tilde, U+02DC ISOdia -->
  HTMLEntites.Add('thorn', 254); // latin small letter thorn, U+00FE ISOlat1 -->
  HTMLEntites.Add('THORN', 222); // latin capital letter THORN, U+00DE ISOlat1 -->
  HTMLEntites.Add('thinsp', 8201); // thin space, U+2009 ISOpub -->
  HTMLEntites.Add('thetasym', 977); // greek small letter theta symbol,   U+03D1 NEW -->
  HTMLEntites.Add('theta', 952); // greek small letter theta,   U+03B8 ISOgrk3 -->
  HTMLEntites.Add('Theta', 920); // greek capital letter theta,   U+0398 ISOgrk3 -->
  HTMLEntites.Add('there4', 8756); // therefore, U+2234 ISOtech -->
  HTMLEntites.Add('tau', 964); // greek small letter tau, U+03C4 ISOgrk3 -->
  HTMLEntites.Add('Tau', 932); // greek capital letter tau, U+03A4 -->
  HTMLEntites.Add('szlig', 223); // latin small letter sharp s = ess-zed, U+00DF ISOlat1 -->
  HTMLEntites.Add('supe', 8839); // superset of or equal to,    U+2287 ISOtech -->
  HTMLEntites.Add('sup3', 179); // superscript three = superscript digit three = cubed, U+00B3 ISOnum -->
  HTMLEntites.Add('sup2', 178); // superscript two = superscript digit two = squared, U+00B2 ISOnum -->
  HTMLEntites.Add('sup1', 185); // superscript one = superscript digit one, U+00B9 ISOnum -->
  HTMLEntites.Add('sup', 8835); // superset of, U+2283 ISOtech -->
  HTMLEntites.Add('sum', 8721); // n-ary sumation, U+2211 ISOamsb -->
  HTMLEntites.Add('sube', 8838); // subset of or equal to, U+2286 ISOtech -->
  HTMLEntites.Add('sub', 8834); // subset of, U+2282 ISOtech -->
  HTMLEntites.Add('spades', 9824); // black spade suit, U+2660 ISOpub -->
  HTMLEntites.Add('sim', 8764); // tilde operator = varies with = similar to,    U+223C ISOtech -->
  HTMLEntites.Add('sigmaf', 962); // greek small letter final sigma,   U+03C2 ISOgrk3 -->
  HTMLEntites.Add('sigma', 963); // greek small letter sigma,   U+03C3 ISOgrk3 -->
  HTMLEntites.Add('Sigma', 931); // greek capital letter sigma,   U+03A3 ISOgrk3 -->
  HTMLEntites.Add('shy', 173); // soft hyphen = discretionary hyphen, U+00AD ISOnum -->
  HTMLEntites.Add('sect', 167); // section sign, U+00A7 ISOnum -->
  HTMLEntites.Add('sdot', 8901); // dot operator, U+22C5 ISOamsb -->
  HTMLEntites.Add('scaron', 353); // latin small letter s with caron,   U+0161 ISOlat2 -->
  HTMLEntites.Add('Scaron', 352); // latin capital letter S with caron,   U+0160 ISOlat2 -->
  HTMLEntites.Add('sbquo', 8218); // single low-9 quotation mark, U+201A NEW -->
  HTMLEntites.Add('rsquo', 8217); // right single quotation mark,   U+2019 ISOnum -->
  HTMLEntites.Add('rsaquo', 8250); // single right-pointing angle quotation mark,   U+203A ISO proposed -->
  HTMLEntites.Add('rlm', 8207); // right-to-left mark, U+200F NEW RFC 2070 -->
  HTMLEntites.Add('rho', 961); // greek small letter rho, U+03C1 ISOgrk3 -->
  HTMLEntites.Add('Rho', 929); // greek capital letter rho, U+03A1 -->
  HTMLEntites.Add('rfloor', 8971); // right floor, U+230B ISOamsc  -->
  HTMLEntites.Add('reg', 174); // registered sign = registered trade mark sign, U+00AE ISOnum -->
  HTMLEntites.Add('real', 8476); // blackletter capital R = real part symbol,    U+211C ISOamso -->
  HTMLEntites.Add('rdquo', 8221); // right double quotation mark,   U+201D ISOnum -->
  HTMLEntites.Add('rceil', 8969); // right ceiling, U+2309 ISOamsc  -->
  HTMLEntites.Add('rArr', 8658); // rightwards double arrow,    U+21D2 ISOtech -->
  HTMLEntites.Add('rarr', 8594); // rightwards arrow, U+2192 ISOnum -->
  HTMLEntites.Add('raquo', 187); // right-pointing double angle quotation mark = right pointing guillemet, U+00BB ISOnum -->
  HTMLEntites.Add('rang', 9002); // right-pointing angle bracket = ket,    U+232A ISOtech -->
  HTMLEntites.Add('radic', 8730); // square root = radical sign,    U+221A ISOtech -->
  HTMLEntites.Add('quot', 34); // quotation mark = APL quote,   U+0022 ISOnum -->
  HTMLEntites.Add('psi', 968); // greek small letter psi, U+03C8 ISOgrk3 -->
  HTMLEntites.Add('Psi', 936); // greek capital letter psi,   U+03A8 ISOgrk3 -->
  HTMLEntites.Add('prop', 8733); // proportional to, U+221D ISOtech -->
  HTMLEntites.Add('prod', 8719); // n-ary product = product sign,    U+220F ISOamsb -->
  HTMLEntites.Add('Prime', 8243); // double prime = seconds = inches,    U+2033 ISOtech -->
  HTMLEntites.Add('prime', 8242); // prime = minutes = feet, U+2032 ISOtech -->
  HTMLEntites.Add('pound', 163); // pound sign, U+00A3 ISOnum -->
  HTMLEntites.Add('plusmn', 177); // plus-minus sign = plus-or-minus sign, U+00B1 ISOnum -->
  HTMLEntites.Add('piv', 982); // greek pi symbol, U+03D6 ISOgrk3 -->
  HTMLEntites.Add('pi', 960); // greek small letter pi, U+03C0 ISOgrk3 -->
  HTMLEntites.Add('Pi', 928); // greek capital letter pi, U+03A0 ISOgrk3 -->
  HTMLEntites.Add('phi', 966); // greek small letter phi, U+03C6 ISOgrk3 -->
  HTMLEntites.Add('Phi', 934); // greek capital letter phi,   U+03A6 ISOgrk3 -->
  HTMLEntites.Add('perp', 8869); // up tack = orthogonal to = perpendicular,    U+22A5 ISOtech -->
  HTMLEntites.Add('permil', 8240); // per mille sign, U+2030 ISOtech -->
  HTMLEntites.Add('part', 8706); // partial differential, U+2202 ISOtech  -->
  HTMLEntites.Add('para', 182); // pilcrow sign = paragraph sign, U+00B6 ISOnum -->
  HTMLEntites.Add('ouml', 246); // latin small letter o with diaeresis, U+00F6 ISOlat1 -->
  HTMLEntites.Add('Ouml', 214); // latin capital letter O with diaeresis, U+00D6 ISOlat1 -->
  HTMLEntites.Add('otimes', 8855); // circled times = vector product,    U+2297 ISOamsb -->
  HTMLEntites.Add('otilde', 245); // latin small letter o with tilde, U+00F5 ISOlat1 -->
  HTMLEntites.Add('Otilde', 213); // latin capital letter O with tilde, U+00D5 ISOlat1 -->
  HTMLEntites.Add('oslash', 248); // latin small letter o with stroke, = latin small letter o slash, U+00F8 ISOlat1 -->
  HTMLEntites.Add('Oslash', 216); // latin capital letter O with stroke = latin capital letter O slash, U+00D8 ISOlat1 -->
  HTMLEntites.Add('ordm', 186); // masculine ordinal indicator, U+00BA ISOnum -->
  HTMLEntites.Add('ordf', 170); // feminine ordinal indicator, U+00AA ISOnum -->
  HTMLEntites.Add('or', 8744); // logical or = vee, U+2228 ISOtech -->
  HTMLEntites.Add('oplus', 8853); // circled plus = direct sum,    U+2295 ISOamsb -->
  HTMLEntites.Add('omicron', 959); // greek small letter omicron, U+03BF NEW -->
  HTMLEntites.Add('Omicron', 927); // greek capital letter omicron, U+039F -->
  HTMLEntites.Add('omega', 969); // greek small letter omega,   U+03C9 ISOgrk3 -->
  HTMLEntites.Add('Omega', 937); // greek capital letter omega,   U+03A9 ISOgrk3 -->
  HTMLEntites.Add('oline', 8254); // overline = spacing overscore,    U+203E NEW -->
  HTMLEntites.Add('ograve', 242); // latin small letter o with grave, U+00F2 ISOlat1 -->
  HTMLEntites.Add('Ograve', 210); // latin capital letter O with grave, U+00D2 ISOlat1 -->
  HTMLEntites.Add('oelig', 339); // latin small ligature oe, U+0153 ISOlat2 -->
  HTMLEntites.Add('OElig', 338); // latin capital ligature OE,   U+0152 ISOlat2 -->
  HTMLEntites.Add('ocirc', 244); // latin small letter o with circumflex, U+00F4 ISOlat1 -->
  HTMLEntites.Add('Ocirc', 212); // latin capital letter O with circumflex, U+00D4 ISOlat1 -->
  HTMLEntites.Add('oacute', 243); // latin small letter o with acute, U+00F3 ISOlat1 -->
  HTMLEntites.Add('Oacute', 211); // latin capital letter O with acute, U+00D3 ISOlat1 -->
  HTMLEntites.Add('nu', 957); // greek small letter nu, U+03BD ISOgrk3 -->
  HTMLEntites.Add('Nu', 925); // greek capital letter nu, U+039D -->
  HTMLEntites.Add('ntilde', 241); // latin small letter n with tilde, U+00F1 ISOlat1 -->
  HTMLEntites.Add('Ntilde', 209); // latin capital letter N with tilde, U+00D1 ISOlat1 -->
  HTMLEntites.Add('nsub', 8836); // not a subset of, U+2284 ISOamsn -->
  HTMLEntites.Add('notin', 8713); // not an element of, U+2209 ISOtech -->
  HTMLEntites.Add('not', 172); // not sign, U+00AC ISOnum -->
  HTMLEntites.Add('ni', 8715); // contains as member, U+220B ISOtech -->
  HTMLEntites.Add('ne', 8800); // not equal to, U+2260 ISOtech -->
  HTMLEntites.Add('ndash', 8211); // en dash, U+2013 ISOpub -->
  HTMLEntites.Add('nbsp', 160); // no-break space = non-breaking space, U+00A0 ISOnum -->
  HTMLEntites.Add('nabla', 8711); // nabla = backward difference,    U+2207 ISOtech -->
  HTMLEntites.Add('mu', 956); // greek small letter mu, U+03BC ISOgrk3 -->
  HTMLEntites.Add('Mu', 924); // greek capital letter mu, U+039C -->
  HTMLEntites.Add('minus', 8722); // minus sign, U+2212 ISOtech -->
  HTMLEntites.Add('middot', 183); // middle dot = Georgian comma = Greek middle dot, U+00B7 ISOnum -->
  HTMLEntites.Add('micro', 181); // micro sign, U+00B5 ISOnum -->
  HTMLEntites.Add('mdash', 8212); // em dash, U+2014 ISOpub -->
  HTMLEntites.Add('macr', 175); // macron = spacing macron = overline = APL overbar, U+00AF ISOdia -->
  HTMLEntites.Add('lt', 60); // less-than sign, U+003C ISOnum -->
  HTMLEntites.Add('lsquo', 8216); // left single quotation mark,   U+2018 ISOnum -->
  HTMLEntites.Add('lsaquo', 8249); // single left-pointing angle quotation mark,   U+2039 ISO proposed -->
  HTMLEntites.Add('lrm', 8206); // left-to-right mark, U+200E NEW RFC 2070 -->
  HTMLEntites.Add('loz', 9674); // lozenge, U+25CA ISOpub -->
  HTMLEntites.Add('lowast', 8727); // asterisk operator, U+2217 ISOtech -->
  HTMLEntites.Add('lfloor', 8970); // left floor = apl downstile,    U+230A ISOamsc  -->
  HTMLEntites.Add('le', 8804); // less-than or equal to, U+2264 ISOtech -->
  HTMLEntites.Add('ldquo', 8220); // left double quotation mark,   U+201C ISOnum -->
  HTMLEntites.Add('lceil', 8968); // left ceiling = apl upstile,    U+2308 ISOamsc  -->
  HTMLEntites.Add('lArr', 8656); // leftwards double arrow, U+21D0 ISOtech -->
  HTMLEntites.Add('larr', 8592); // leftwards arrow, U+2190 ISOnum -->
  HTMLEntites.Add('laquo', 171); // left-pointing double angle quotation mark = left pointing guillemet, U+00AB ISOnum -->
  HTMLEntites.Add('lang', 9001); // left-pointing angle bracket = bra,    U+2329 ISOtech -->
  HTMLEntites.Add('lambda', 955); // greek small letter lambda,   U+03BB ISOgrk3 -->
  HTMLEntites.Add('Lambda', 923); // greek capital letter lambda,   U+039B ISOgrk3 -->
  HTMLEntites.Add('kappa', 954); // greek small letter kappa,   U+03BA ISOgrk3 -->
  HTMLEntites.Add('Kappa', 922); // greek capital letter kappa, U+039A -->
  HTMLEntites.Add('iuml', 239); // latin small letter i with diaeresis, U+00EF ISOlat1 -->
  HTMLEntites.Add('Iuml', 207); // latin capital letter I with diaeresis, U+00CF ISOlat1 -->
  HTMLEntites.Add('isin', 8712); // element of, U+2208 ISOtech -->
  HTMLEntites.Add('iquest', 191); // inverted question mark = turned question mark, U+00BF ISOnum -->
  HTMLEntites.Add('iota', 953); // greek small letter iota, U+03B9 ISOgrk3 -->
  HTMLEntites.Add('Iota', 921); // greek capital letter iota, U+0399 -->
  HTMLEntites.Add('int', 8747); // integral, U+222B ISOtech -->
  HTMLEntites.Add('infin', 8734); // infinity, U+221E ISOtech -->
  HTMLEntites.Add('image', 8465); // blackletter capital I = imaginary part,    U+2111 ISOamso -->
  HTMLEntites.Add('igrave', 236); // latin small letter i with grave, U+00EC ISOlat1 -->
  HTMLEntites.Add('Igrave', 204); // latin capital letter I with grave, U+00CC ISOlat1 -->
  HTMLEntites.Add('iexcl', 161); // inverted exclamation mark, U+00A1 ISOnum -->
  HTMLEntites.Add('icirc', 238); // latin small letter i with circumflex, U+00EE ISOlat1 -->
  HTMLEntites.Add('Icirc', 206); // latin capital letter I with circumflex, U+00CE ISOlat1 -->
  HTMLEntites.Add('iacute', 237); // latin small letter i with acute, U+00ED ISOlat1 -->
  HTMLEntites.Add('Iacute', 205); // latin capital letter I with acute, U+00CD ISOlat1 -->
  HTMLEntites.Add('hellip', 8230); // horizontal ellipsis = three dot leader,    U+2026 ISOpub  -->
  HTMLEntites.Add('hearts', 9829); // black heart suit = valentine,    U+2665 ISOpub -->
  HTMLEntites.Add('hArr', 8660); // left right double arrow,    U+21D4 ISOamsa -->
  HTMLEntites.Add('harr', 8596); // left right arrow, U+2194 ISOamsa -->
  HTMLEntites.Add('gt', 62); // greater-than sign, U+003E ISOnum -->
  HTMLEntites.Add('ge', 8805); // greater-than or equal to,    U+2265 ISOtech -->
  HTMLEntites.Add('gamma', 947); // greek small letter gamma,   U+03B3 ISOgrk3 -->
  HTMLEntites.Add('Gamma', 915); // greek capital letter gamma,   U+0393 ISOgrk3 -->
  HTMLEntites.Add('frasl', 8260); // fraction slash, U+2044 NEW -->
  HTMLEntites.Add('frac34', 190); // vulgar fraction three quarters = fraction three quarters, U+00BE ISOnum -->
  HTMLEntites.Add('frac14', 188); // vulgar fraction one quarter = fraction one quarter, U+00BC ISOnum -->
  HTMLEntites.Add('frac12', 189); // vulgar fraction one half = fraction one half, U+00BD ISOnum -->
  HTMLEntites.Add('forall', 8704); // for all, U+2200 ISOtech -->
  HTMLEntites.Add('fnof', 402); // latin small f with hook = function   = florin, U+0192 ISOtech -->
  HTMLEntites.Add('exist', 8707); // there exists, U+2203 ISOtech -->
  HTMLEntites.Add('euro', 8364); // euro sign, U+20AC NEW -->
  HTMLEntites.Add('euml', 235); // latin small letter e with diaeresis, U+00EB ISOlat1 -->
  HTMLEntites.Add('Euml', 203); // latin capital letter E with diaeresis, U+00CB ISOlat1 -->
  HTMLEntites.Add('eth', 240); // latin small letter eth, U+00F0 ISOlat1 -->
  HTMLEntites.Add('ETH', 208); // latin capital letter ETH, U+00D0 ISOlat1 -->
  HTMLEntites.Add('eta', 951); // greek small letter eta, U+03B7 ISOgrk3 -->
  HTMLEntites.Add('Eta', 919); // greek capital letter eta, U+0397 -->
  HTMLEntites.Add('equiv', 8801); // identical to, U+2261 ISOtech -->
  HTMLEntites.Add('epsilon', 949); // greek small letter epsilon,   U+03B5 ISOgrk3 -->
  HTMLEntites.Add('Epsilon', 917); // greek capital letter epsilon, U+0395 -->
  HTMLEntites.Add('ensp', 8194); // en space, U+2002 ISOpub -->
  HTMLEntites.Add('emsp', 8195); // em space, U+2003 ISOpub -->
  HTMLEntites.Add('empty', 8709); // empty set = null set = diameter,    U+2205 ISOamso -->
  HTMLEntites.Add('egrave', 232); // latin small letter e with grave, U+00E8 ISOlat1 -->
  HTMLEntites.Add('Egrave', 200); // latin capital letter E with grave, U+00C8 ISOlat1 -->
  HTMLEntites.Add('ecirc', 234); // latin small letter e with circumflex, U+00EA ISOlat1 -->
  HTMLEntites.Add('Ecirc', 202); // latin capital letter E with circumflex, U+00CA ISOlat1 -->
  HTMLEntites.Add('eacute', 233); // latin small letter e with acute, U+00E9 ISOlat1 -->
  HTMLEntites.Add('Eacute', 201); // latin capital letter E with acute, U+00C9 ISOlat1 -->
  HTMLEntites.Add('divide', 247); // division sign, U+00F7 ISOnum -->
  HTMLEntites.Add('diams', 9830); // black diamond suit, U+2666 ISOpub -->
  HTMLEntites.Add('delta', 948); // greek small letter delta,   U+03B4 ISOgrk3 -->
  HTMLEntites.Add('Delta', 916); // greek capital letter delta,   U+0394 ISOgrk3 -->
  HTMLEntites.Add('deg', 176); // degree sign, U+00B0 ISOnum -->
  HTMLEntites.Add('dArr', 8659); // downwards double arrow, U+21D3 ISOamsa -->
  HTMLEntites.Add('darr', 8595); // downwards arrow, U+2193 ISOnum -->
  HTMLEntites.Add('Dagger', 8225); // double dagger, U+2021 ISOpub -->
  HTMLEntites.Add('dagger', 8224); // dagger, U+2020 ISOpub -->
  HTMLEntites.Add('curren', 164); // currency sign, U+00A4 ISOnum -->
  HTMLEntites.Add('cup', 8746); // union = cup, U+222A ISOtech -->
  HTMLEntites.Add('crarr', 8629); // downwards arrow with corner leftwards    = carriage return, U+21B5 NEW -->
  HTMLEntites.Add('copy', 169); // copyright sign, U+00A9 ISOnum -->
  HTMLEntites.Add('cong', 8773); // approximately equal to, U+2245 ISOtech -->
  HTMLEntites.Add('clubs', 9827); // black club suit = shamrock,    U+2663 ISOpub -->
  HTMLEntites.Add('circ', 710); // modifier letter circumflex accent,   U+02C6 ISOpub -->
  HTMLEntites.Add('chi', 967); // greek small letter chi, U+03C7 ISOgrk3 -->
  HTMLEntites.Add('Chi', 935); // greek capital letter chi, U+03A7 -->
  HTMLEntites.Add('cent', 162); // cent sign, U+00A2 ISOnum -->
  HTMLEntites.Add('cedil', 184); // cedilla = spacing cedilla, U+00B8 ISOdia -->
  HTMLEntites.Add('ccedil', 231); // latin small letter c with cedilla, U+00E7 ISOlat1 -->
  HTMLEntites.Add('Ccedil', 199); // latin capital letter C with cedilla, U+00C7 ISOlat1 -->
  HTMLEntites.Add('cap', 8745); // intersection = cap, U+2229 ISOtech -->
  HTMLEntites.Add('bull', 8226); // bullet = black small circle,    U+2022 ISOpub  -->
  HTMLEntites.Add('brvbar', 166); // broken bar = broken vertical bar, U+00A6 ISOnum -->
  HTMLEntites.Add('beta', 946); // greek small letter beta, U+03B2 ISOgrk3 -->
  HTMLEntites.Add('Beta', 914); // greek capital letter beta, U+0392 -->
  HTMLEntites.Add('bdquo', 8222); // double low-9 quotation mark, U+201E NEW -->
  HTMLEntites.Add('auml', 228); // latin small letter a with diaeresis, U+00E4 ISOlat1 -->
  HTMLEntites.Add('Auml', 196); // latin capital letter A with diaeresis, U+00C4 ISOlat1 -->
  HTMLEntites.Add('atilde', 227); // latin small letter a with tilde, U+00E3 ISOlat1 -->
  HTMLEntites.Add('Atilde', 195); // latin capital letter A with tilde, U+00C3 ISOlat1 -->
  HTMLEntites.Add('asymp', 8776); // almost equal to = asymptotic to,    U+2248 ISOamsr -->
  HTMLEntites.Add('aring', 229); // latin small letter a with ring above = latin small letter a ring, U+00E5 ISOlat1 -->
  HTMLEntites.Add('Aring', 197); // latin capital letter A with ring above = latin capital letter A ring, U+00C5 ISOlat1 -->
  HTMLEntites.Add('ang', 8736); // angle, U+2220 ISOamso -->
  HTMLEntites.Add('and', 8743); // logical and = wedge, U+2227 ISOtech -->
  HTMLEntites.Add('amp', 38); // ampersand, U+0026 ISOnum -->
  HTMLEntites.Add('alpha', 945); // greek small letter alpha,   U+03B1 ISOgrk3 -->
  HTMLEntites.Add('Alpha', 913); // greek capital letter alpha, U+0391 -->
  HTMLEntites.Add('alefsym', 8501); // alef symbol = first transfinite cardinal,    U+2135 NEW -->
  HTMLEntites.Add('agrave', 224); // latin small letter a with grave = latin small letter a grave, U+00E0 ISOlat1 -->
  HTMLEntites.Add('Agrave', 192); // latin capital letter A with grave = latin capital letter A grave, U+00C0 ISOlat1 -->
  HTMLEntites.Add('aelig', 230); // latin small letter ae = latin small ligature ae, U+00E6 ISOlat1 -->
  HTMLEntites.Add('AElig', 198); // latin capital letter AE = latin capital ligature AE, U+00C6 ISOlat1 -->
  HTMLEntites.Add('acute', 180); // acute accent = spacing acute, U+00B4 ISOdia -->
  HTMLEntites.Add('acirc', 226); // latin small letter a with circumflex, U+00E2 ISOlat1 -->
  HTMLEntites.Add('Acirc', 194); // latin capital letter A with circumflex, U+00C2 ISOlat1 -->
  HTMLEntites.Add('aacute', 225); // latin small letter a with acute, U+00E1 ISOlat1 -->
  HTMLEntites.Add('Aacute', 193); // latin capital letter A with acute, U+00C1 ISOlat1 -->
end;

procedure PrepareHTMLTagCRLF;
begin
  HTMLTagCRLF := TStringList.Create;
  with HTMLTagCRLF do
  begin
    Add('br');
    Add('br/');
    Add('p');
    Add('/p');
    Add('h1');
    Add('/h1');
    Add('h2');
    Add('/h2');
    Add('h3');
    Add('/h3');
    Add('h4');
    Add('/h4');
    Add('h5');
    Add('/h5');
    Add('hr');
    Add('ul');
    Add('/ul');
    Add('ol');
    Add('/ol');
    Add('li');
    Sorted := True;
  end;
end;

function HTMLDecodeCRLF(const Chaine: string; CRLFOnly: Boolean): string;
begin
  Result := Utf8ToAnsi(HTMLUTF8Decode(AnsiToUtf8(Chaine), CRLFOnly));
end;

function HTMLDecode(const Chaine: string): string;
begin
  Result := HTMLDecodeCRLF(Chaine, False);
end;

function HTMLUTF8Decode(const Chaine: UTF8String; CRLFOnly: Boolean): UTF8String;
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
    if CRLFOnly and not(aUnicodeOrdEntity in [13, 10]) then
    begin
      CopyCurrentSrcPosCharToResult;
      Exit;
    end;

    for K := 1 to Length(aUTF8String) do
    begin
      Result[CurrentResultPos] := aUTF8String[K];
      Inc(CurrentResultPos);
    end;
    CurrentSrcPos := aNewCurrentSrcPos;
  end;

var
  ident: UTF8String;
begin
  { init var }
  CurrentSrcPos := 1;
  CurrentResultPos := 1;
  SrcLength := Length(Chaine);
  SetLength(Result, SrcLength);

  { start loop }
  while CurrentSrcPos <= SrcLength do
  begin
    case Chaine[CurrentSrcPos] of
      #0:
        Break;
      '&':
        begin
          { HTMLentity detected }
          { extract the HTML entity }
          ident := '';
          j := CurrentSrcPos + 1;
          while (j <= SrcLength) and (Chaine[j] <> ';') and (Length(ident) <= 12) do
          begin
            ident := ident + UTF8String(Chaine[j]);
            Inc(j);
          end;
          { HTML entity is valid }
          if (j <= SrcLength) and (Length(ident) > 0) and (Length(ident) <= 12) then
          begin
            { HTML entity is numeric }
            if (ident[1] = '#') then
            begin
              Delete(ident, 1, 1);
              { HTML entity is hexa }
              if (Length(ident) > 0) and (ident[1] = 'x') then
                ident[1] := '$';

              if TryStrToInt(string(ident), aTmpInteger) then
                CopyCharToResult(aTmpInteger, j)
              else
                CopyCurrentSrcPosCharToResult;
            end
            { HTML entity is litteral }
            else
            begin
              if HTMLEntites.TryGetValue(ident, aTmpInteger) then
                CopyCharToResult(aTmpInteger, j)
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

function HTTPDecode(const Chaine: string): string;
var
  Sp, Rp, Cp, Tp: PChar;
  int: Integer;
  S: string;
begin
  SetLength(Result, Length(Chaine));
  Sp := PChar(Chaine);
  Rp := PChar(Result);
  while Sp^ <> #0 do
  begin
    case Sp^ of
      '+':
        Rp^ := ' ';
      '%':
        begin
          Tp := Sp;
          Inc(Sp);

          // escaped % (%%)
          if Sp^ = '%' then
            Rp^ := '%'

            // %<hex> encoded character
          else
          begin
            Cp := Sp;
            Inc(Sp);
            if (Cp^ <> #0) and (Sp^ <> #0) then
            begin
              S := '$' + Cp^ + Sp^;
              if TryStrToInt(S, int) then
                Rp^ := Chr(int)
              else
              begin
                Rp^ := '%';
                Sp := Tp;
              end;
            end
            else
            begin
              Rp^ := '%';
              Sp := Tp;
            end;
          end;
        end;
    else
      Rp^ := Sp^;
    end;
    Inc(Rp);
    Inc(Sp);
  end;
  SetLength(Result, Rp - PChar(Result));
end;

function myHandleTagfunct(const TagString: string; TagParams: TStrings; ExtData: TObject; var Handled: Boolean): string;
var
  LowerTagString: string;
begin
  Handled := True;
  Result := '';
  LowerTagString := LowerCase(TagString);
  if HTMLTagCRLF.IndexOf(LowerTagString) <> -1 then
    Result := sLineBreak;
end;

procedure ALHideHtmlUnwantedTagForHTMLHandleTagfunct(var HtmlContent: string; const DeleteBodyOfUnwantedTag: Boolean = False;
  const ReplaceUnwantedTagCharBy: Char = #1); { this char is not use in html }
var
  InDoubleQuote: Boolean;
  InSimpleQuote: Boolean;
  P1, P2: Integer;
  X1: Integer;
  str1: string;
begin
  P1 := 1;
  while P1 <= Length(HtmlContent) do
    if HtmlContent[P1] = '<' then
    begin
      X1 := P1;
      str1 := '';
      while (X1 <= Length(HtmlContent)) and not(CharInSet(HtmlContent[X1], ['>', ' ', #13, #10, #9])) do
      begin
        str1 := str1 + HtmlContent[X1];
        Inc(X1);
      end;

      InSimpleQuote := False;
      InDoubleQuote := False;

      { hide script content tag }
      if LowerCase(str1) = '<script' then
      begin
        Inc(P1, 7);
        while (P1 <= Length(HtmlContent)) do
        begin
          if (HtmlContent[P1] = '''') and (not InDoubleQuote) then
            InSimpleQuote := not InSimpleQuote
          else if (HtmlContent[P1] = '"') and (not InSimpleQuote) then
            InDoubleQuote := not InDoubleQuote
          else if (HtmlContent[P1] = '>') and (not InSimpleQuote) and (not InDoubleQuote) then
            Break;
          Inc(P1);
        end;
        if P1 <= Length(HtmlContent) then
          Inc(P1);

        P2 := P1;
        while (P1 <= Length(HtmlContent)) do
        begin
          if (HtmlContent[P1] = '<') then
          begin
            if (Length(HtmlContent) >= P1 + 8) and (HtmlContent[P1 + 1] = '/') and (LowerCase(HtmlContent[P1 + 2]) = 's') and
              (LowerCase(HtmlContent[P1 + 3]) = 'c') and (LowerCase(HtmlContent[P1 + 4]) = 'r') and (LowerCase(HtmlContent[P1 + 5]) = 'i') and
              (LowerCase(HtmlContent[P1 + 6]) = 'p') and (LowerCase(HtmlContent[P1 + 7]) = 't') and (HtmlContent[P1 + 8] = '>') then
              Break
            else
              HtmlContent[P1] := ReplaceUnwantedTagCharBy;
          end;
          Inc(P1);
        end;
        if P1 <= Length(HtmlContent) then
          dec(P1);

        if DeleteBodyOfUnwantedTag then
        begin
          Delete(HtmlContent, P2, P1 - P2 + 1);
          P1 := P2;
        end;
      end

      { hide script content tag }
      else if LowerCase(str1) = '<style' then
      begin
        Inc(P1, 6);
        while (P1 <= Length(HtmlContent)) do
        begin
          if (HtmlContent[P1] = '''') and (not InDoubleQuote) then
            InSimpleQuote := not InSimpleQuote
          else if (HtmlContent[P1] = '"') and (not InSimpleQuote) then
            InDoubleQuote := not InDoubleQuote
          else if (HtmlContent[P1] = '>') and (not InSimpleQuote) and (not InDoubleQuote) then
            Break;
          Inc(P1);
        end;
        if P1 <= Length(HtmlContent) then
          Inc(P1);

        P2 := P1;
        while (P1 <= Length(HtmlContent)) do
        begin
          if (HtmlContent[P1] = '<') then
          begin
            if (Length(HtmlContent) >= P1 + 7) and (HtmlContent[P1 + 1] = '/') and (LowerCase(HtmlContent[P1 + 2]) = 's') and
              (LowerCase(HtmlContent[P1 + 3]) = 't') and (LowerCase(HtmlContent[P1 + 4]) = 'y') and (LowerCase(HtmlContent[P1 + 5]) = 'l') and
              (LowerCase(HtmlContent[P1 + 6]) = 'e') and (HtmlContent[P1 + 7] = '>') then
              Break
            else
              HtmlContent[P1] := ReplaceUnwantedTagCharBy;
          end;
          Inc(P1);
        end;
        if P1 <= Length(HtmlContent) then
          dec(P1);

        if DeleteBodyOfUnwantedTag then
        begin
          Delete(HtmlContent, P2, P1 - P2 + 1);
          P1 := P2;
        end;
      end

      { hide comment content tag }
      else if str1 = '<!--' then
      begin
        P2 := P1;
        HtmlContent[P1] := ReplaceUnwantedTagCharBy;
        Inc(P1, 4);
        while (P1 <= Length(HtmlContent)) do
        begin
          if (HtmlContent[P1] = '>') and (P1 > 2) and (HtmlContent[P1 - 1] = '-') and (HtmlContent[P1 - 2] = '-') then
            Break
          else if (HtmlContent[P1] = '<') then
            HtmlContent[P1] := ReplaceUnwantedTagCharBy;
          Inc(P1);
        end;
        if P1 <= Length(HtmlContent) then
          Inc(P1);

        if DeleteBodyOfUnwantedTag then
        begin
          Delete(HtmlContent, P2, P1 - P2);
          P1 := P2;
        end;
      end

      { hide text < tag }
      else if str1 = '<' then
      begin
        HtmlContent[P1] := ReplaceUnwantedTagCharBy;
        Inc(P1);
      end

      else
      begin
        Inc(P1, Length(str1));
        while (P1 <= Length(HtmlContent)) do
        begin
          if (HtmlContent[P1] = '''') and (not InDoubleQuote) then
            InSimpleQuote := not InSimpleQuote
          else if (HtmlContent[P1] = '"') and (not InSimpleQuote) then
            InDoubleQuote := not InDoubleQuote
          else if (HtmlContent[P1] = '>') and (not InSimpleQuote) and (not InDoubleQuote) then
            Break;
          Inc(P1);
        end;
        if P1 <= Length(HtmlContent) then
          Inc(P1);
      end;

    end
    else
      Inc(P1);
end;

procedure ALExtractHeaderFields(Separators, WhiteSpace: TSysCharSet; Content: PChar; Strings: TStrings; Decode: Boolean; StripQuotes: Boolean = False);
var
  Head, Tail: PChar;
  EOS, InQuote, LeadQuote: Boolean;
  QuoteChar: Char;
  ExtractedField: string;
  WhiteSpaceWithCRLF: TSysCharSet;
  SeparatorsWithCRLF: TSysCharSet;

  function DoStripQuotes(const S: string): string;
  var
    I: Integer;
    InStripQuote: Boolean;
    StripQuoteChar: Char;
  begin
    Result := S;
    InStripQuote := False;
    StripQuoteChar := #0;
    if StripQuotes then
      for I := Length(Result) downto 1 do
        if CharInSet(Result[I], ['''', '"']) then
          if InStripQuote and (StripQuoteChar = Result[I]) then
          begin
            Delete(Result, I, 1);
            InStripQuote := False;
          end
          else if not InStripQuote then
          begin
            StripQuoteChar := Result[I];
            InStripQuote := True;
            Delete(Result, I, 1);
          end;
  end;

begin
  if (Content = nil) or (Content^ = #0) then
    Exit;
  WhiteSpaceWithCRLF := WhiteSpace + [#13, #10];
  SeparatorsWithCRLF := Separators + [#0, #13, #10, '"', ''''];
  Tail := Content;
  QuoteChar := #0;
  repeat
    while CharInSet(Tail^, WhiteSpaceWithCRLF) do
      Inc(Tail);
    Head := Tail;
    InQuote := False;
    LeadQuote := False;
    while True do
    begin
      while (InQuote and not CharInSet(Tail^, [#0, '"', ''''])) or not CharInSet(Tail^, SeparatorsWithCRLF) do
        Inc(Tail);
      if CharInSet(Tail^, ['"', '''']) then
      begin
        if (QuoteChar <> #0) and (QuoteChar = Tail^) then
          QuoteChar := #0
        else if QuoteChar = #0 then
        begin
          LeadQuote := Head = Tail;
          QuoteChar := Tail^;
          if LeadQuote then
            Inc(Head);
        end;
        InQuote := QuoteChar <> #0;
        if InQuote then
          Inc(Tail)
        else
          Break;
      end
      else
        Break;
    end;
    if not LeadQuote and (Tail^ <> #0) and CharInSet(Tail^, ['"', '''']) then
      Inc(Tail);
    EOS := Tail^ = #0;
    if Head^ <> #0 then
    begin
      SetString(ExtractedField, Head, Tail - Head);
      if Decode then
        Strings.Add(HTTPDecode(DoStripQuotes(ExtractedField)))
      else
        Strings.Add(DoStripQuotes(ExtractedField));
    end;
    Inc(Tail);
  until EOS;
end;

type
  TALHandleTagfunct = function(const TagString: string; TagParams: TStrings; ExtData: TObject; var Handled: Boolean): string;

function ALFastTagReplace(const SourceString, TagStart, TagEnd: string; FastTagReplaceProc: TALHandleTagfunct; ReplaceStrParamName, ReplaceWith: string;
  AStripParamQuotes: Boolean; Flags: TReplaceFlags; ExtData: TObject): string;
var
  I: Integer;
  ReplaceString: string;
  Token, FirstTagEndChar: Char;
  TokenStr, ParamStr: string;
  ParamList: TStringList;
  TagStartLength: Integer;
  TagEndLength: Integer;
  SourceStringLength: Integer;
  T1, T2: Integer;
  InDoubleQuote: Boolean;
  InsingleQuote: Boolean;
  Work_SourceString: string;
  Work_TagStart: string;
  Work_TagEnd: string;
  TagHandled: Boolean;
  ResultCurrentPos: Integer;
  ResultCurrentLength: Integer;
const
  ResultBuffSize: Integer = 16384;

  function ExtractTokenStr: string;
  var
    x: Integer;
  begin
    x := Pos(' ', ReplaceString);
    if x > 0 then
      Result := Trim(Copy(ReplaceString, 1, x))
    else
      Result := Trim(ReplaceString);
  end;

  function ExtractParamsStr: string;
  begin
    Result := Trim(Copy(ReplaceString, Length(TokenStr) + 1, MaxInt));
  end;

  procedure MoveStr2Result(Src: string);
  var
    l: Integer;
  begin
    if Src <> '' then
    begin
      l := Length(Src);
      if l + ResultCurrentPos - 1 > ResultCurrentLength Then
      begin
        ResultCurrentLength := ResultCurrentLength + l + ResultBuffSize;
        SetLength(Result, ResultCurrentLength);
      end;
      Move(Src[1], Result[ResultCurrentPos], l * SizeOf(Char));
      ResultCurrentPos := ResultCurrentPos + l;
    end;
  end;

begin
  if (SourceString = '') or (TagStart = '') or (TagEnd = '') then
  begin
    Result := SourceString;
    Exit;
  end;

  if rfIgnoreCase in Flags then
  begin
    Work_SourceString := UpperCase(SourceString);
    Work_TagStart := UpperCase(TagStart);
    Work_TagEnd := UpperCase(TagEnd);
  end
  else
  begin
    Work_SourceString := SourceString;
    Work_TagStart := TagStart;
    Work_TagEnd := TagEnd;
  end;

  SourceStringLength := Length(Work_SourceString);
  ResultCurrentLength := SourceStringLength;
  SetLength(Result, ResultCurrentLength);
  ResultCurrentPos := 1;
  TagStartLength := Length(Work_TagStart);
  TagEndLength := Length(Work_TagEnd);
  FirstTagEndChar := Work_TagEnd[1];
  I := 1;

  T1 := PosEx(Work_TagStart, Work_SourceString, I);
  T2 := T1 + TagStartLength;
  if (T1 > 0) and (T2 <= SourceStringLength) then
  begin
    InDoubleQuote := False;
    InsingleQuote := False;
    Token := Work_SourceString[T2];
    if Token = '"' then
      InDoubleQuote := True
    else if Token = '''' then
      InsingleQuote := True;
    while (T2 < SourceStringLength) and (InDoubleQuote or InsingleQuote or (Token <> FirstTagEndChar) or (PosEx(Work_TagEnd, Work_SourceString, T2) <> T2)) do
    begin
      Inc(T2);
      Token := Work_SourceString[T2];
      if Token = '"' then
        InDoubleQuote := not InDoubleQuote and not InsingleQuote
      else if Token = '''' then
        InsingleQuote := not InsingleQuote and not InDoubleQuote;
    end;
  end;

  while (T1 > 0) and (T2 > T1) do
  begin
    ReplaceString := Copy(SourceString, T1 + TagStartLength, T2 - T1 - TagStartLength);

    TagHandled := True;
    if Assigned(FastTagReplaceProc) or (ReplaceStrParamName <> '') then
    begin
      TokenStr := ExtractTokenStr;
      ParamStr := ExtractParamsStr;
      ParamList := TStringList.Create;
      try
        ALExtractHeaderFields([' ', #9], [' ', #9], PChar(ParamStr), ParamList, False, AStripParamQuotes);
        if Assigned(FastTagReplaceProc) then
          ReplaceString := FastTagReplaceProc(TokenStr, ParamList, ExtData, TagHandled)
        else
          ReplaceString := ParamList.Values[ReplaceStrParamName];
      finally
        ParamList.Free;
      end;
    end
    else
      ReplaceString := ReplaceWith;

    if TagHandled then
      MoveStr2Result(Copy(SourceString, I, T1 - I) + ReplaceString)
    else
      MoveStr2Result(Copy(SourceString, I, T2 + TagEndLength - I));
    I := T2 + TagEndLength;

    if TagHandled and (not(rfreplaceAll in Flags)) then
      Break;

    T1 := PosEx(Work_TagStart, Work_SourceString, I);
    T2 := T1 + TagStartLength;
    if (T1 > 0) and (T2 <= SourceStringLength) then
    begin
      InDoubleQuote := False;
      InsingleQuote := False;
      Token := Work_SourceString[T2];
      if Token = '"' then
        InDoubleQuote := True
      else if Token = '''' then
        InsingleQuote := True;
      while (T2 < SourceStringLength) and (InDoubleQuote or InsingleQuote or (Token <> FirstTagEndChar) or (PosEx(Work_TagEnd, Work_SourceString, T2) <> T2)) do
      begin
        Inc(T2);
        Token := Work_SourceString[T2];
        if Token = '"' then
          InDoubleQuote := not InDoubleQuote and not InsingleQuote
        else if Token = '''' then
          InsingleQuote := not InsingleQuote and not InDoubleQuote;
      end;
    end;
  end;

  MoveStr2Result(Copy(SourceString, I, MaxInt));
  SetLength(Result, ResultCurrentPos - 1);
end;

function HTMLText(const Chaine: string): string;
begin
  Result := HTMLDecodeCRLF(Chaine, True);
  Result := AdjustLineBreaks(Result, tlbsCRLF);
  Result := StringReplace(Result, sLineBreak, '', [rfreplaceAll]);
  Result := StringReplace(Result, #9, '', [rfreplaceAll]);
  Result := StringReplace(Result, #7, '', [rfreplaceAll]);

  ALHideHtmlUnwantedTagForHTMLHandleTagfunct(Result, False, #1);
  Result := ALFastTagReplace(Result, '<', '>', myHandleTagfunct, '', '', True, [rfreplaceAll], nil);
  Result := StringReplace(Result, #1, '<', [rfreplaceAll]);
  Result := StringReplace(Result, '  ', ' ', [rfreplaceAll]);
  Result := StringReplace(Result, sLineBreak + ' ', sLineBreak, [rfreplaceAll]);
  Result := StringReplace(Result, ' ' + sLineBreak, sLineBreak, [rfreplaceAll]);
  Result := StringReplace(Result, sLineBreak + sLineBreak, sLineBreak, [rfreplaceAll]);

  while (Length(Result) > 0) and CharInSet(Result[1], [#13, #10, ' ']) do
    Delete(Result, 1, 1);
  while (Length(Result) > 0) and CharInSet(Result[Length(Result)], [#13, #10, ' ']) do
    Delete(Result, Length(Result), 1);
  Result := HTMLDecode(Result);
end;

initialization

PrepareHTMLEntites;
PrepareHTMLTagCRLF;

finalization

HTMLEntites.Free;
HTMLTagCRLF.Free;

end.
