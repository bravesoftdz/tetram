package org.tetram.bdtheque.data;

import org.tetram.bdtheque.data.bean.Serie;
import org.tetram.bdtheque.data.bean.UniversLite;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

/**
 * Created by Thierry on 29/05/2014.
 */
public abstract class BeanUtils {
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
}
