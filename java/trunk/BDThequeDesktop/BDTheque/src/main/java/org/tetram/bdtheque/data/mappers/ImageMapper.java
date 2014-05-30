package org.tetram.bdtheque.data.mappers;

import org.tetram.bdtheque.data.bean.CouvertureLite;
import org.tetram.bdtheque.data.bean.PhotoLite;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 25/05/2014.
 */
public interface ImageMapper {
    List<CouvertureLite> getListCouvertureLiteByEditionId(UUID id);

    List<PhotoLite> getListPhotoLiteByParaBDId(UUID id);
}
