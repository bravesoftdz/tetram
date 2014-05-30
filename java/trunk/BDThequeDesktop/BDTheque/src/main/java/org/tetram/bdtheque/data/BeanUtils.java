package org.tetram.bdtheque.data;

import org.tetram.bdtheque.data.bean.Serie;
import org.tetram.bdtheque.data.bean.UniversLite;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Thierry on 29/05/2014.
 */
public abstract class BeanUtils {
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
}
