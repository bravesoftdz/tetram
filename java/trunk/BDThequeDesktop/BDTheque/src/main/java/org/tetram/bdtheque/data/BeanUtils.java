package org.tetram.bdtheque.data;

import org.jetbrains.annotations.Contract;
import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.AuteurAlbumLite;
import org.tetram.bdtheque.data.bean.Serie;
import org.tetram.bdtheque.data.bean.UniversLite;
import org.tetram.bdtheque.data.services.UserPreferences;
import org.tetram.bdtheque.spring.SpringContext;
import org.tetram.bdtheque.utils.I18nSupport;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.*;

/**
 * Created by Thierry on 29/05/2014.
 */
public abstract class BeanUtils {

    public static final Map<Boolean, String> RES_TOME;
    public static final Map<Boolean, String> RES_HORSERIE;
    public static final Map<Boolean, String> RES_INTEGRALE;

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

    private static List<String> prefixes = new ArrayList<String>() {{
        add("un");
        add("une");
        add("des");
        add("l'");
        add("le");
        add("la");
        add("les");

        add("the");
        add("a");
        add("an");
    }};

    public static List<UniversLite> checkAndBuildListUniversFull(List<UniversLite> universFull, List<UniversLite> univers, Serie serie) {
        int countUnivers = (univers != null ? univers.size() : 0);
        if (serie != null)
            countUnivers += (serie.getUnivers() != null ? serie.getUnivers().size() : 0);

        if (universFull == null || universFull.size() != countUnivers) {
            universFull = new ArrayList<>();
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

    @Contract("null -> !null; !null -> !null")
    public static String formatTitre(final String titre) {
        String s = formatTitreAcceptNull(titre);
        return (s == null) ? "" : s;
    }

    @Contract("null -> null; !null -> !null")
    @Nullable
    @SuppressWarnings("StringConcatenationMissingWhitespace")
    public static String formatTitreAcceptNull(final String titre) {
        if (titre == null) return null;
        final int p = titre.lastIndexOf('[');
        if (p == -1) return StringUtils.trim(titre);

        final int p2 = titre.lastIndexOf(']');
        if (p2 < p) return StringUtils.trim(titre);

        final String article = StringUtils.trim(titre.substring(p + 1, p2));
        final String debut = titre.substring(0, p);
        final String fin = titre.substring(p2 + 1);

        final StringBuilder result = new StringBuilder(titre.length());
        result.append(article);
        if (!article.endsWith("'"))
            result.append(" ");
        result.append(debut);
        result.append(fin);

        return StringUtils.trim(result.toString());
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

        UserPreferences userPreferences = SpringContext.CONTEXT.getBean(UserPreferences.class);

        switch (userPreferences.getFormatTitreAlbum()) {
            case ALBUM_SERIE_TOME: // Album (Serie - Tome)
                sSerie = StringUtils.ajoutString(sSerie, sTome, " - ");
                if ("".equals(sAlbum)) {
                    result = sSerie;
                } else
                    result = StringUtils.ajoutString(sAlbum, sSerie, " ", "(", ")");
                break;
            case TOME_ALBUM_SERIE: // Tome - Album (Serie)
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

    @Contract("null->null")
    public static String prepareTitre(String titre) {
        if (titre == null) return null;
        titre = StringUtils.trim(titre);
        if (titre.isEmpty()) return titre;
        if (titre.endsWith("]")) return titre;
        int pEspace = titre.indexOf(' ');
        int pApostrophe = titre.indexOf('\'');
        if ((pApostrophe > 0) && (pEspace == 0 || pApostrophe < pEspace))
            pEspace = pApostrophe + 1; // +1 pour prendre l'apostrophe dans le mot
        if (pEspace == 0) return titre;
        String mot = titre.substring(0, pEspace);
        if (!prefixes.contains(mot.toLowerCase(I18nSupport.getLocale()))) return titre;
        return titre.substring(pEspace) + " [" + mot + "]";
    }
/*
function PrepareTitre(Titre: string): string;
var
  pEspace, pApostrophe: Integer;
  Mot: string;
begin
  Titre := Trim(Titre);
  Result := Titre;
  if Result = '' then Exit;
  if Copy(Result, Length(Result), 1) = ']' then Exit;
  pEspace := Pos(' ', Titre);
  pApostrophe := Pos('''', Titre);
  if (pApostrophe > 0) and ((pEspace = 0) or (pApostrophe < pEspace)) then pEspace := pApostrophe + 1; // + 1 pour prendre l'apostrophe dans le mot
  if pEspace = 0 then Exit;
  Mot := Copy(Titre, 1, pEspace - 1);
  if not ChaineIn(LowerCase(Mot), ['l''', 'un', 'une', 'des', 'le', 'la', 'les']) then Exit;
  Result := Trim(Copy(Titre, pEspace, Length(Titre))) + ' [' + Mot + ']';
end;

function PrepareTitre2(Titre: string): string;
var
  p: Integer;
  Mot: string;
begin
  try
    Titre := Trim(Titre);
    Result := Titre;
    if Result = '' then Exit;
    if Copy(Result, Length(Result), 1) <> ')' then Exit;
    p := Length(Result) - 1;
    while (p > 0) and (Result[p] <> '(') do
      p := p - 1;
    if p = 0 then Exit;

    Mot := Copy(Titre, p + 1, Length(Result) - p - 1);
    if not ChaineIn(LowerCase(Mot), ['l''', 'un', 'une', 'des', 'le', 'la', 'les']) then Exit;
    Result := Trim(Copy(Titre, 1, p - 1)) + ' [' + Mot + ']';
  finally
    Result := PrepareTitre(Result);
  end;
end;
 */
}
