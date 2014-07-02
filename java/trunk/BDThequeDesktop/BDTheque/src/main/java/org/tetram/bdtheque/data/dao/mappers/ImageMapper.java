package org.tetram.bdtheque.data.dao.mappers;

import org.apache.ibatis.annotations.Param;
import org.tetram.bdtheque.data.bean.*;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * Created by Thierry on 25/05/2014.
 */
@FileLink("/org/tetram/bdtheque/data/dao/mappers/Image.xml")
public interface ImageMapper extends BaseMapperInterface {
    List<CouvertureLite> getListCouvertureLiteByEditionId(UUID id);

    List<PhotoLite> getListPhotoLiteByParaBDId(UUID id);

    <T extends ImageLite>
    int cleanImageLite(
            @Param("parentId") UUID parentId,
            @Param("list") Collection<T> list,
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

    <T extends ImageLite>
    int updateMetadataImageLite(
            @Param("image") T image,
            @Param("fileName") String fileName,
            @Param("tableName") String tableName,
            @Param("fieldId") String fieldId,
            @Param("fieldFile") String fieldFile
    );

    <T extends ImageLite>
    int changeModeImageLite(
            @Param("image") T image,
            @Param("data") byte[] stream,
            @Param("tableName") String tableName,
            @Param("fieldId") String fieldId,
            @Param("fieldModeStockage") String fieldModeStockage,
            @Param("fieldBlob") String fieldBlob
    );

    <T extends ImageLite>
    ImageStream getImageStream(
            @Param("image") T image,
            @Param("tableName") String tableName,
            @Param("fieldId") String fieldId,
            @Param("fieldFile") String fieldFile,
            @Param("fieldModeStockage") String fieldModeStockage,
            @Param("fieldBlob") String fieldBlob
    );

    int cleanCouverturesAlbum(@Param("idAlbum") UUID idAlbum, @Param("editions") Collection<Edition> editions);
}
