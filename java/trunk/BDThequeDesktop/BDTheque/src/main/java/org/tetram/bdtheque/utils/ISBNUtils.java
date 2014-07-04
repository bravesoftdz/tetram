package org.tetram.bdtheque.utils;

import org.jetbrains.annotations.Contract;
import org.jetbrains.annotations.NonNls;
import org.jetbrains.annotations.Nullable;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

/**
 * Created by Thierry on 29/06/2014.
 */
public class ISBNUtils {
    @NonNls
    public static final String RESOURCE_ISBN_RANGES_XML = "/org/tetram/bdtheque/utils/isbn_ranges.xml";
    private static HashMap<String, List<ISBNRule>> isbnPrefixes;
    private static HashMap<String, List<ISBNRule>> isbnGroups;

    private static void decodeISBNRules() {
        if (isbnPrefixes != null) return;

        InputStream inputStream = ClassLoader.class.getResourceAsStream(RESOURCE_ISBN_RANGES_XML);
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
                    @NonNls String s = qName.toLowerCase(Locale.US);
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
                    @NonNls String s = qName.toLowerCase(Locale.US);
                    switch (s) {
                        case "valuelower":
                            this.currentRule.valueLower = Integer.valueOf(this.tmpValue);
                            break;
                        case "range":
                            Integer p = this.tmpValue.indexOf('-');
                            this.currentRule.valueLower = Integer.valueOf(this.tmpValue.substring(0, p));
                            this.tmpValue = this.tmpValue.substring(p + 1);
                            // volontairement pas de break pour continuer sur valueupper
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

    @Contract("null -> null")
    @Nullable
    public static String formatISBN(String isbn) {
        if (isbn == null) return null;

        decodeISBNRules();

        isbn = isbn.toUpperCase(Locale.US).substring(0, Math.min(isbn.length(), 13));
        @NonNls String prefix = "978";
        String s = isbn;
        if (s.length() > 10) {
            prefix = s.substring(0, 3);
            s = s.substring(3, Math.min(s.length(), 13));
        }
        if (s.length() < 10) return isbn;

        String s1;

        s1 = s.substring(0, 7);
        Integer groupSize = getLengthForPrefix(isbnPrefixes, prefix, Integer.valueOf(s1));
        @NonNls String group = s.substring(0, groupSize);

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
        for (final char c : code.toCharArray())
            if (Character.isDigit(c) || (c == 'X') || (c == 'x')) {
                result.append(c);
            }
        return result.toString();
    }

    private static class ISBNRule {
        int valueLower, valueUpper, length;
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

}
