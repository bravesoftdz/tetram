package org.tetram.bdtheque.data.dao;

import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.bean.PhotoLite;

import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * Created by Thierry on 13/06/2014.
 */
@Repository
@Lazy
@Transactional
@SuppressWarnings("UnusedDeclaration")
public class PhotoLiteDaoImpl extends ImageLiteDaoImpl<PhotoLite, UUID> implements PhotoLiteDao {
    @Override
    public void saveList(List<PhotoLite> list, UUID parentId, Map<String, UUID> secondaryParams) {
        super.saveList("photos", "id_photo", "id_parabd", "fichierphoto", "stockagephoto", "imagephoto", list, parentId, secondaryParams);
    }
}
