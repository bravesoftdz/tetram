package org.tetram.bdtheque.data.dao;

import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.bean.CouvertureLite;

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
public class CouvertureLiteDaoImpl extends ImageLiteDaoImpl<CouvertureLite, UUID> implements CouvertureLiteDao {

    static {
        TABLE_NAME = "couvertures";
    }

    @Override
    public byte[] getImageStream(CouvertureLite image, Integer height, Integer width, boolean antiAliasing, boolean cadre, int effet3D) {
        return getCouvertureStream("couvertures", "id_couverture", "fichiercouverture", "stockagecouverture", "imagecouverture", image, height, width, antiAliasing, cadre, effet3D);
    }

    @Override
    public void saveList(List<CouvertureLite> list, UUID parentId, Map<String, UUID> secondaryParams) {
        super.saveList("couvertures", "id_couverture", "id_edition", "fichiercouverture", "stockagecouverture", "imagecouverture", list, parentId, secondaryParams);
    }
}
