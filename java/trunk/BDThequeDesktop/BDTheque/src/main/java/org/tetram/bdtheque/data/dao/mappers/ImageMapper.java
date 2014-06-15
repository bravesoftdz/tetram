package org.tetram.bdtheque.data.dao.mappers;

import org.apache.ibatis.annotations.Param;
import org.tetram.bdtheque.data.bean.CouvertureLite;
import org.tetram.bdtheque.data.bean.ImageLite;
import org.tetram.bdtheque.data.bean.PhotoLite;

import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * Created by Thierry on 25/05/2014.
 */
public interface ImageMapper extends BaseMapperInterface {
    List<CouvertureLite> getListCouvertureLiteByEditionId(UUID id);

    List<PhotoLite> getListPhotoLiteByParaBDId(UUID id);

    int cleanImageLite(
            @Param("parentId") UUID parentId,
            @Param("list") List<? extends ImageLite> list,
            @Param("tableName") String tableName,
            @Param("fieldParentId") String fieldParentId,
            @Param("fieldId") String fieldId
    );

    <T extends ImageLite>
    int addImageLite(
            @Param("image") T image,
            @Param("parentId") UUID parentId,
            @Param("secondaryParams") Map<String, UUID> secondaryParams,
            @Param("fileName") String fileName,
            @Param("data") byte[] stream,
            @Param("tableName") String tableName,
            @Param("fieldParentId") String fieldParentId,
            @Param("fieldId") String fieldId,
            @Param("fieldFile") String fieldFile,
            @Param("fieldModeStockage") String fieldModeStockage,
            @Param("fieldBlob") String fieldBlob
    );

}
