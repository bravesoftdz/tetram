/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * FusionService.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.services;

import org.tetram.bdtheque.data.bean.Edition;

import java.util.Collection;

/**
 * Created by Thierry on 20/06/2014.
 */
public interface FusionService {
    void fusionneInto(Collection<Edition> source, Collection<Edition> dest);
}
