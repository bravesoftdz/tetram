package org.tetram.bdtheque.utils;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.BDThequeApplication;
import org.tetram.bdtheque.R;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

@SuppressWarnings("UnusedDeclaration")
public abstract class StringUtils {

    public static final UUID GUID_FULL = GUIDStringToUUID("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}");
    public static final String GUID_FULL_STRING = "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}";
    public static final UUID GUID_NULL = GUIDStringToUUID("{00000000-0000-0000-0000-000000000000}");
    public static final String GUID_NULL_STRING = "{00000000-0000-0000-0000-000000000000}";

    private static final Map<Boolean, String> RES_TOME;
    private static final Map<Boolean, String> RES_HORSERIE;
    private static final Map<Boolean, String> RES_INTEGRALE;

    static {
        Map<Boolean, String> aMap;

        aMap = new HashMap<>();
        aMap.put(false, "T. ");
        aMap.put(true, "Tome ");
        RES_TOME = Collections.unmodifiableMap(aMap);

        aMap = new HashMap<>();
        aMap.put(false, "HS");
        aMap.put(true, "Hors-Série");
        RES_HORSERIE = Collections.unmodifiableMap(aMap);

        aMap = new HashMap<>();
        aMap.put(false, "INT.");
        aMap.put(true, "Intégrale");
        RES_INTEGRALE = Collections.unmodifiableMap(aMap);
    }

    public static UUID GUIDStringToUUID(final String guid) {
        return UUID.fromString(guid.substring(1, guid.length() - 1));
    }

    public static UUID GUIDStringToUUIDDef(final String guid, final UUID defaultGUID) {
        try {
            return UUID.fromString(guid.substring(1, guid.length() - 1));
        } catch (final Exception e) {
            return defaultGUID;
        }
    }

    public static String UUIDToGUIDString(final UUID uuid) {
        return "{" + uuid.toString().toUpperCase(Locale.US) + "}";
    }

    public static String ajoutString(final String chaine, final String ajout, final String espace) {
        return ajoutString(chaine, ajout, espace, "", "");
    }

    public static String ajoutString(final String chaine, final String ajout, final String espace, final String avant) {
        return ajoutString(chaine, ajout, espace, avant, "");
    }

    public static String ajoutString(String chaine, final String ajout, final String espace, final String avant, final String apres) {
        final StringBuilder stringBuilder = new StringBuilder(
                ((chaine == null) ? 0 : chaine.length())
                        + ((ajout == null) ? 0 : ajout.length())
                        + ((espace == null) ? 0 : espace.length())
                        + ((avant == null) ? 0 : avant.length())
                        + ((apres == null) ? 0 : apres.length())
        );
        if (chaine != null) stringBuilder.append(chaine);
        if ((ajout != null) && !"".equals(ajout)) {
            if ((stringBuilder.length() > 0) && (espace != null)) stringBuilder.append(espace);
            if (avant != null) stringBuilder.append(avant);
            stringBuilder.append(ajout);
            if (apres != null) stringBuilder.append(apres);
        }
        return stringBuilder.toString();
    }

    public static String nonZero(final String s) {
        if ((s == null) || "0".equals(s.trim()))
            return "";
        return s;
    }

    public static String nonZero(final Integer i) {
        if ((i == null) || Integer.valueOf(0).equals(i))
            return "";
        return i.toString();
    }

/*
function VerifieEAN(var Valeur: string): Boolean;
var
  i, fak, sum: Integer;
  tmp: string;
begin
  sum := 0;
  tmp := Copy(Valeur + '0000000000000', 1, 12);
  fak := Length(tmp);
  for i := 1 to Length(tmp) do
  begin
    if (fak mod 2) = 0 then
      sum := sum + (StrToInt(tmp[i]) * 1)
    else
      sum := sum + (StrToInt(tmp[i]) * 3);
    Dec(fak);
  end;
  if (sum mod 10) = 0 then
    tmp := tmp + '0'
  else
    tmp := tmp + IntToStr(10 - (sum mod 10));
  Result := Valeur = tmp;
  Valeur := tmp;
end;
*/

/*
function VerifieISBN(var Valeur: string; LongueurISBN: Integer = 10): Boolean;
var
  X, M, C, v: Integer;
  tmp: string;
begin
  tmp := ClearISBN(Valeur);
  Result := True;
  if tmp <> '' then
  begin
    if tmp[Length(tmp)] = 'X' then
    begin
      while Length(tmp) < LongueurISBN do
        Insert('0', tmp, Length(tmp) - 1);
      M := 10;
    end
    else
    begin
      while Length(tmp) < LongueurISBN do
        tmp := tmp + '0';
      M := Ord(tmp[Length(tmp)]) - Ord('0');
      //    M := StrToInt(tmp[Length(tmp)]);
    end;

    if LongueurISBN = 13 then
      Result := VerifieEAN(tmp)
    else
    begin
      C := 0;
      for X := 1 to Pred(Length(tmp)) do
        //    C := C + StrToInt(tmp[X]) * X;
        C := C + (Ord(tmp[X]) - Ord('0')) * X;
      v := C mod 11;
      Result := v = M;

      if v = 10 then
        tmp[Length(tmp)] := 'X'
      else
        tmp[Length(tmp)] := IntToStr(v)[1];
    end;
  end;
  Valeur := tmp;
end;
*/

    private static class ISBNRule {
        int valueLower, valueUpper, length;
    }

    private static HashMap<String, List<ISBNRule>> isbnPrefixes, isbnGroups;

    private static void decodeISBNRules() {
        if (isbnPrefixes != null) return;

        InputStream inputStream = BDThequeApplication.getInstance().getResources().openRawResource(R.raw.isbnranges_original);
        try {
            isbnPrefixes = new HashMap<>();
            isbnGroups = new HashMap<>();

            SAXParser parseur = SAXParserFactory.newInstance().newSAXParser();
            parseur.parse(inputStream, new DefaultHandler() {

                private ISBNRule currentRule;
                public String tmpValue;
                public HashMap<String, List<ISBNRule>> currentList;
                public String prefix;

                @Override
                public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
                    String s = qName.toLowerCase(Locale.US);
                    switch (s) {
                        case "ean.uccprefixes":
                            this.currentList = isbnPrefixes;
                            break;
                        case "registrationgroups":
                            this.currentList = isbnGroups;
                            break;
                        case "rule":
                            this.currentRule = new ISBNRule();
                            break;
                    }
                    this.tmpValue = "";
                }

                @Override
                public void endElement(String uri, String localName, String qName) throws SAXException {
                    String s = qName.toLowerCase(Locale.US);
                    switch (s) {
                        case "valuelower":
                            this.currentRule.valueLower = Integer.valueOf(this.tmpValue);
                            break;
                        case "range":
                            Integer p = this.tmpValue.indexOf('-');
                            this.currentRule.valueLower = Integer.valueOf(this.tmpValue.substring(0, p));
                            this.tmpValue = this.tmpValue.substring(p + 1);
                            // volontairement pas de break pour continuer sur valueupper
                            // break;
                            this.currentRule.valueUpper = Integer.valueOf(this.tmpValue);
                            break;
                        case "valueupper":
                            this.currentRule.valueUpper = Integer.valueOf(this.tmpValue);
                            break;
                        case "length":
                            this.currentRule.length = Integer.valueOf(this.tmpValue);
                            break;
                        case "prefix":
                            this.prefix = this.tmpValue;
                            break;
                        case "rule":
                            List<ISBNRule> list;
                            if (!this.currentList.containsKey(this.prefix))
                                list = new ArrayList<>();
                            else
                                list = this.currentList.get(this.prefix);
                            list.add(this.currentRule);
                            this.currentList.put(this.prefix, list);
                            this.currentRule = null;
                            break;
                    }
                    this.tmpValue = null;
                }

                @SuppressWarnings("StringConcatenationMissingWhitespace")
                @Override
                public void characters(char[] ch, int start, int length) throws SAXException {
                    if (this.tmpValue != null)
                        this.tmpValue += new String(ch, start, length);
                }
            });

        } catch (final ParserConfigurationException | IOException | SAXException e) {
            e.printStackTrace();
        } finally {
            try {
                inputStream.close();
            } catch (final IOException e) {
                e.printStackTrace();
            }
        }

    }

    private static int getLengthForPrefix(HashMap<String, List<ISBNRule>> map, String prefix, int value) {
        List<ISBNRule> rules = map.get(prefix);
        if ((rules == null) || rules.isEmpty()) return 0;
        for (final ISBNRule rule : rules)
            if ((rule.valueLower <= value) && (rule.valueUpper >= value))
                return rule.length;
        return 0;
    }

    public static final String SEARCH_ISBN_GROUP = "//ISBNRangeMessage/EAN.UCCPrefixes/EAN.UCC[Prefix='%2$s']/Rules/Rule[ValueLower<=%1$s and ValueUpper>=%1$s]/Length";
    public static final String SEARCH_ISBN_PUBLISHER = "//ISBNRangeMessage/RegistrationGroups/Group[Prefix='%2$s-%3$s']/Rules/Rule[ValueLower<=%1$s and ValueUpper>=%1$s]/Length";

    @Nullable
    public static String formatISBN(String isbn) {
        if (isbn == null) return null;

        decodeISBNRules();


        isbn = isbn.toUpperCase(Locale.US).substring(0, Math.min(isbn.length(), 13));
        String prefix = "978";
        String s = isbn;
        if (s.length() > 10) {
            prefix = s.substring(0, 3);
            s = s.substring(3, Math.min(s.length(), 13));
        }
        if (s.length() < 10) return isbn;

        String s1;

        s1 = s.substring(0, 7);
        Integer groupSize = getLengthForPrefix(isbnPrefixes, prefix, Integer.valueOf(s1));
        String group = s.substring(0, groupSize);

        s1 = s.substring(groupSize, groupSize + 7);
        Integer publisherSize = getLengthForPrefix(isbnGroups, prefix + '-' + group, Integer.valueOf(s1));
        String publisher = s.substring(groupSize, groupSize + publisherSize);

        StringBuilder result = new StringBuilder(13 + 4);
        if (isbn.length() > 10) {
            result.append(prefix);
            result.append('-');
        }
        result.append(group);
        result.append('-');
        result.append(publisher);
        result.append('-');
        result.append(s.substring(groupSize + publisherSize, 9));
        result.append('-');
        result.append(s.substring(s.length() - 1, s.length()));
        return result.toString();
    }

    public static String clearISBN(final String code) {
        final StringBuilder result = new StringBuilder(code.length());
        for (final char c : code.toUpperCase(Locale.US).toCharArray())
            if (Character.isDigit(c) || (c == 'X')) {
                result.append(c);
            }
        return result.toString();
    }

    public static String formatTitre(final String titre) {
        String s = formatTitreAcceptNull(titre);
        return (s == null) ? "" : s;
    }

    @Nullable
    @SuppressWarnings("StringConcatenationMissingWhitespace")
    public static String formatTitreAcceptNull(final String titre) {
        if (titre == null) return null;
        final int p = titre.lastIndexOf('[');
        if (p == -1) return titre.trim();

        final int p2 = titre.lastIndexOf(']');
        if (p2 < p) return titre.trim();

        final String article = titre.substring(p + 1, p2).trim();
        final String debut = titre.substring(0, p);
        final String fin = titre.substring(p2 + 1);

        final StringBuilder result = new StringBuilder(titre.length());
        result.append(article);
        if (!article.endsWith("'"))
            result.append(" ");
        result.append(debut);
        result.append(fin);

        return result.toString().trim();
    }

    public static String trimRight(final String str) {
        final int start = 0;
        final int last = str.length() - 1;
        int end = last;
        while ((end >= start) && (str.charAt(end) == ' ')) {
            end--;
        }
        if (end == last) {
            return str;
        }
        return str.substring(start, end + 1);
    }

    public static String formatTitreAlbum(final boolean simple, final boolean avecSerie, final String titre, final String serie, final Integer tome, final Integer tomeDebut, final Integer tomeFin, final boolean integrale, final boolean horsSerie) {
        String sAlbum;
        if (simple)
            sAlbum = titre;
        else
            sAlbum = formatTitre(titre);

        String sSerie = "";
        if (avecSerie)
            if ("".equals(sAlbum))
                sAlbum = formatTitre(serie);
            else
                sSerie = formatTitreAcceptNull(serie);

        String sTome;
        if (integrale) {
            final String s = ajoutString(nonZero(tomeDebut), nonZero(tomeFin), " à ");
            sTome = ajoutString("", RES_INTEGRALE.get("".equals(sAlbum)), " - ", "", trimRight(" " + nonZero(tome)));
            sTome = ajoutString(sTome, s, " ", "[", "]");
        } else if (horsSerie)
            sTome = ajoutString("", RES_HORSERIE.get("".equals(sAlbum)), " - ", "", trimRight(" " + nonZero(tome)));
        else
            sTome = ajoutString("", nonZero(tome), " - ", RES_TOME.get("".equals(sAlbum)));

        String result = "";
        switch (UserConfig.getInstance().getFormatTitreAlbum()) {
            case 0: // Album (Serie - Tome)
                sSerie = ajoutString(sSerie, sTome, " - ");
                if ("".equals(sAlbum))
                    result = sSerie;
                else
                    result = ajoutString(sAlbum, sSerie, " ", "(", ")");
                break;
            case 1: // Tome - Album (Serie)
                if ("".equals(sAlbum))
                    sAlbum = sSerie;
                else
                    sAlbum = ajoutString(sAlbum, sSerie, " ", "(", ")");
                result = ajoutString(sTome, sAlbum, " - ");
                break;
        }

        return result;
    }
}
