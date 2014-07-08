package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.EvaluatedEntity;
import org.tetram.bdtheque.data.bean.ValeurListe;

/**
 * Created by Thierry on 08/07/2014.
 */
public interface EvaluatedEntityDao<T extends EvaluatedEntity> {
    void changeNotation(T entity, ValeurListe notation);
}
