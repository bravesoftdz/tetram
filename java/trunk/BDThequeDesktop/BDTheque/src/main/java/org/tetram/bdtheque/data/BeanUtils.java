package org.tetram.bdtheque.data;

import org.jetbrains.annotations.Contract;
import org.tetram.bdtheque.data.bean.Serie;
import org.tetram.bdtheque.data.bean.UniversLite;

import java.util.HashSet;
import java.util.Set;

/**
 * Created by Thierry on 29/05/2014.
 */
public abstract class BeanUtils {

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
}
