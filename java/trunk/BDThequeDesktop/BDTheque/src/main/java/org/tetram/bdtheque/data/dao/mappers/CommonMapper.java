package org.tetram.bdtheque.data.dao.mappers;

import org.apache.ibatis.annotations.Param;
import org.tetram.bdtheque.data.BlobContainer;

import java.util.Set;
import java.util.UUID;

/**
 * Created by Thierry on 13/06/2014.
 */
public interface CommonMapper extends BaseMapperInterface {
    Set<String> fillAssociations(@Param("id") UUID id, @Param("typeData") int typeData);

    int cleanAssociations(@Param("id") UUID id, @Param("typeData") int typeData);

    int saveAssociations(@Param("chaine") String chaine, @Param("id") UUID id, @Param("typeData") int typeData, @Param("parentId") UUID parentId);

    BlobContainer getFileContent(@Param("path") String path, @Param("file") String fileName);

    int sendFileContent(@Param("path") String path, @Param("file") String fileName, @Param("content") byte[] content);

    int deleteFile(@Param("file") String fileName);

    String searchNewFileName(@Param("path") String path, @Param("baseFileName") String baseFileName, @Param("reserve") boolean reserve);
}
