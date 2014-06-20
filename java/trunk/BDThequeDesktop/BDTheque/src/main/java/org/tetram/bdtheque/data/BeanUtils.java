package org.tetram.bdtheque.data;

import org.jetbrains.annotations.Contract;
import org.jetbrains.annotations.NonNls;
import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.AuteurAlbumLite;
import org.tetram.bdtheque.data.bean.Serie;
import org.tetram.bdtheque.data.bean.UniversLite;
import org.tetram.bdtheque.data.services.UserPreferences;
import org.tetram.bdtheque.utils.I18nSupport;
import org.tetram.bdtheque.utils.StringUtils;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import java.io.IOException;
import java.io.InputStream;
import java.util.*;

/**
 * Created by Thierry on 29/05/2014.
 */
public abstract class BeanUtils {

    @NonNls
    public static final String SEARCH_ISBN_GROUP = "//ISBNRangeMessage/EAN.UCCPrefixes/EAN.UCC[Prefix='%2$s']/Rules/Rule[ValueLower<=%1$s and ValueUpper>=%1$s]/Length";
    @NonNls
    public static final String SEARCH_ISBN_PUBLISHER = "//ISBNRangeMessage/RegistrationGroups/Group[Prefix='%2$s-%3$s']/Rules/Rule[ValueLower<=%1$s and ValueUpper>=%1$s]/Length";
    @NonNls
    public static final String RESOURCE_ISBN_RANGES_XML = "/org/tetram/bdtheque/isbn_ranges.xml";
    public static final Map<Boolean, String> RES_TOME;
    public static final Map<Boolean, String> RES_HORSERIE;
    public static final Map<Boolean, String> RES_INTEGRALE;
    private static HashMap<String, List<ISBNRule>> isbnPrefixes;
    private static HashMap<String, List<ISBNRule>> isbnGroups;

    static {
        Map<Boolean, String> aMap;

        aMap = new HashMap<>();
        aMap.put(false, I18nSupport.message("Tome.abrev"));
        aMap.put(true, I18nSupport.message("Tome"));
        RES_TOME = Collections.unmodifiableMap(aMap);

        aMap = new HashMap<>();
        aMap.put(false, I18nSupport.message("Hors.serie.abrev"));
        aMap.put(true, I18nSupport.message("Hors.serie"));
        RES_HORSERIE = Collections.unmodifiableMap(aMap);

        aMap = new HashMap<>();
        aMap.put(false, I18nSupport.message("Integrale.abrev"));
        aMap.put(true, I18nSupport.message("Integrale"));
        RES_INTEGRALE = Collections.unmodifiableMap(aMap);
    }

    @Contract("null -> null")
    public static String trimOrNull(String v) {
        return v == null ? null : v.trim();
    }

    public static Set<UniversLite> checkAndBuildListUniversFull(Set<UniversLite> universFull, Set<UniversLite> univers, Serie serie) {
        int countUnivers = (univers != null ? univers.size() : 0);
        if (serie != null)
            countUnivers += (serie.getUnivers() != null ? serie.getUnivers().size() : 0);

        if (universFull == null || universFull.size() != countUnivers) {
            universFull = new HashSet<>();
            if (univers != null)
                universFull.addAll(univers);
            if (serie != null && serie.getUnivers() != null)
                universFull.addAll(serie.getUnivers());
        }
        return universFull;
    }

    public static <T extends Comparable> int compare(T bThis, T bOther) {
        return compare(bThis, bOther, true);
    }

    @SuppressWarnings("unchecked")
    public static <T extends Comparable> int compare(T bThis, T bOther, boolean nullsFirst) {
        if (bThis == bOther) return 0;

        if (bThis == null) return nullsFirst ? -1 : 1;
        if (bOther == null) return nullsFirst ? 1 : -1;

        return bThis.compareTo(bOther);
    }

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

    @Contract("null -> null")
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
            // (Int.|Intégrale)[ #tome][ \[(#tomeDebut|#tomeFin|#tomeDebut à #tomeFin)\]]
            final String s = StringUtils.ajoutString(StringUtils.nonZero(tomeDebut), StringUtils.nonZero(tomeFin), " " + I18nSupport.message("from.to") + " ");
            sTome = StringUtils.ajoutString(null, RES_INTEGRALE.get("".equals(sAlbum)), " - ", "", StringUtils.trimRight(" " + StringUtils.nonZero(tome)));
            sTome = StringUtils.ajoutString(sTome, s, " ", "[", "]");
        } else if (horsSerie)
            // (HS|Hors-série)[ #tome]
            sTome = StringUtils.ajoutString(null, RES_HORSERIE.get("".equals(sAlbum)), " - ", "", StringUtils.trimRight(" " + StringUtils.nonZero(tome)));
        else
            // (T.|Tome)[ #tome]
            sTome = StringUtils.ajoutString(null, StringUtils.trimRight(" " + StringUtils.nonZero(tome)), " - ", RES_TOME.get("".equals(sAlbum)));

        String result = "";

        UserPreferences userPreferences = Database.getInstance().getApplicationContext().getBean(UserPreferences.class);

        switch (userPreferences.getFormatTitreAlbum()) {
            case 0: // Album (Serie - Tome)
                sSerie = StringUtils.ajoutString(sSerie, sTome, " - ");
                if ("".equals(sAlbum)) {
                    result = sSerie;
                } else
                    result = StringUtils.ajoutString(sAlbum, sSerie, " ", "(", ")");
                break;
            case 1: // Tome - Album (Serie)
                if ("".equals(sAlbum))
                    sAlbum = sSerie;
                else
                    sAlbum = StringUtils.ajoutString(sAlbum, sSerie, " ", "(", ")");
                result = StringUtils.ajoutString(sTome, sAlbum, " - ");
                break;
        }

        return result;
    }

    public static boolean notInList(AuteurAlbumLite auteur, Collection<AuteurAlbumLite> list) {
        for (AuteurAlbumLite auteurAlbumLite : list)
            if (auteur.getId().equals(auteurAlbumLite.getPersonne().getId())) return false;
        return true;
    }

    private static boolean notInList(UniversLite univers, Collection<UniversLite> list) {
        return !list.contains(univers);
    }

    private static class ISBNRule {
        int valueLower, valueUpper, length;
    }
}
