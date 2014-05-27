package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.lite.CouvertureLite;
import org.tetram.bdtheque.data.bean.lite.PhotoLite;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 25/05/2014.
 */
public interface ImageDao {
    List<CouvertureLite> getListCouvertureLiteByEditionId(UUID id);

    List<PhotoLite> getListPhotoLiteByParaBDId(UUID id);
}
