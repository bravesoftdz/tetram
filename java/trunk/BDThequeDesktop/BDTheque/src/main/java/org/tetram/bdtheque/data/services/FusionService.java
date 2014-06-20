package org.tetram.bdtheque.data.services;

import org.tetram.bdtheque.data.bean.Edition;

import java.util.Collection;

/**
 * Created by Thierry on 20/06/2014.
 */
public interface FusionService {
    void fusionneInto(Collection<Edition> source, Collection<Edition> dest);
}
