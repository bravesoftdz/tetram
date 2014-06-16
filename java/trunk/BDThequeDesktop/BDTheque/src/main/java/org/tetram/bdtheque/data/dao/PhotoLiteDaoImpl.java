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

    static {
        TABLE_NAME = "photos";
    }

    @Override
    public byte[] getImageStream(PhotoLite image, Integer height, Integer width, boolean antiAliasing, boolean cadre, int effet3D) {
        return getCouvertureStream("photos", "id_photo", "fichierphoto", "stockagephoto", "imagephoto", image, height, width, antiAliasing, cadre, effet3D);
    }

    @Override
    public void saveList(List<PhotoLite> list, UUID parentId, Map<String, UUID> secondaryParams) {
        super.saveList("photos", "id_photo", "id_parabd", "fichierphoto", "stockagephoto", "imagephoto", list, parentId, secondaryParams);
    }
}
