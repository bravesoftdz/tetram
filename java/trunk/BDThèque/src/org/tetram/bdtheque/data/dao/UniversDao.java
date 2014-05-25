package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.Univers;
import org.tetram.bdtheque.data.bean.lite.UniversLite;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 25/05/2014.
 */
public interface UniversDao {
    UniversLite getUniversLiteById(UUID id);

    List<UniversLite> getListUniversLiteByParaBDId(UUID id);

    Univers getUniversById(UUID id);
}
