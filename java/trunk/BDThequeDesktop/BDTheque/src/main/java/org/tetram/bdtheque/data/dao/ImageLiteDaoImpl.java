package org.tetram.bdtheque.data.dao;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.output.ByteArrayOutputStream;
import org.jetbrains.annotations.NonNls;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.bean.ImageLite;
import org.tetram.bdtheque.data.bean.ImageStream;
import org.tetram.bdtheque.data.dao.mappers.CommonMapper;
import org.tetram.bdtheque.data.dao.mappers.ImageMapper;
import org.tetram.bdtheque.data.services.UserPreferences;
import org.tetram.bdtheque.utils.FileUtils;
import org.tetram.bdtheque.utils.StringUtils;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.util.*;

/**
 * Created by Thierry on 13/06/2014.
 */
public abstract class ImageLiteDaoImpl<T extends ImageLite, K> extends DaoRWImpl<T, K> implements ImageLiteDao<T, K> {

    @Autowired
    private ImageMapper imageMapper;
    @Autowired
    private CommonMapper commonMapper;
    @Autowired
    private UserPreferences userPreferences;

    protected static String TABLE_NAME = null;

    protected byte[] getCouvertureStream(@NonNls String tableName, @NonNls String pkField, @NonNls String fieldFile, @NonNls String fieldModeStockage, @NonNls String fieldBlob, T image, Integer height, Integer width, boolean antiAliasing) {
        ImageStream imageInfo = imageMapper.getImageStream(image, tableName, pkField, fieldFile, fieldModeStockage, fieldBlob);
        if (imageInfo.getData().length == 0 && StringUtils.isNullOrEmpty(imageInfo.getFileName()))
            return null;

        if (imageInfo.isStockee()) {
            String fileName = new File(imageInfo.getFileName()).getName();
            String path = new File(imageInfo.getFileName()).getParent();
            if (StringUtils.isNullOrEmpty(path))
                path = userPreferences.getRepImages();

            byte[] imageBytes = commonMapper.getFileContent(path, fileName);
            if (imageBytes == null || imageBytes.length == 0) return null;

            try {
                ByteArrayOutputStream output = new ByteArrayOutputStream();
                // write to jpeg file
                ImageIO.write(FileUtils.resizePicture(ImageIO.read(new ByteArrayInputStream(imageBytes)), height, width, antiAliasing), "jpg", output);

                return output.toByteArray();
            } catch (IOException e) {
                e.printStackTrace();
                return null;
            }
        } else
            return FileUtils.getJPEGStream(new File(imageInfo.getFileName()), height, width, antiAliasing);
    }

    @SuppressWarnings({"HardCodedStringLiteral", "StringConcatenation"})
    protected void saveList(@NonNls String tableName, @NonNls String pkField, @NonNls String parentIdField, @NonNls String fieldFile, @NonNls String fieldModeStockage, @NonNls String fieldBlob, List<T> list, UUID parentId, Map<String, UUID> secondaryParams) {
        Set<String> fichiersImages = new HashSet<>();

        imageMapper.cleanImageLite(parentId, list, tableName, parentIdField, pkField);
        for (T image : list) {
            image.setPosition(list.indexOf(image));
            if (image.getId() == null || image.getId().equals(StringUtils.GUID_NULL)) {
                // nouvelles photos
                if (!image.isNewStockee()) {
                    // photos liées (q1)
                    image.setOldNom(image.getNewNom());
                    image.setNewNom(commonMapper.searchNewFileName(userPreferences.getRepImages(), new File(image.getNewNom()).getName(), true));
                    commonMapper.sendFileContent(userPreferences.getRepImages(), image.getNewNom(), FileUtils.getJPEGStream(new File(image.getOldNom()), null, null, false));
                    imageMapper.addImageLite(
                            image, parentId, secondaryParams, image.getNewNom(), null,
                            tableName, parentIdField, pkField, fieldFile, fieldModeStockage, fieldBlob
                    );
                } else if (new File(image.getNewNom()).exists()) {
                    // photos stockées (q2)
                    imageMapper.addImageLite(
                            image, parentId, secondaryParams, FilenameUtils.removeExtension(new File(image.getNewNom()).getName()), FileUtils.getJPEGStream(new File(image.getNewNom())),
                            tableName, parentIdField, pkField, fieldFile, fieldModeStockage, fieldBlob
                    );
                }
            } else {
                // ancienne photo
                if (image.isOldStockee() != image.isNewStockee()) {
                    // changement de stockage
                    byte[] imageStream = getCouvertureStream(image, null, null, false);
                    if (image.isNewStockee()) {
                        // conversion photos liées en stockées (q3)
                        imageMapper.changeModeImageLite(image, imageStream, tableName, pkField, fieldModeStockage, fieldBlob);
                        File f = new File(image.getNewNom());
                        if (f.getParent().isEmpty())
                            fichiersImages.add(new File(userPreferences.getRepImages(), image.getNewNom()).getPath());
                        else
                            fichiersImages.add(image.getNewNom());
                        image.setNewNom(FilenameUtils.removeExtension(f.getName()));
                    } else {
                        // conversion photos stockées en liées
                        image.setNewNom(commonMapper.searchNewFileName(userPreferences.getRepImages(), image.getNewNom() + ".jpg", true));
                        commonMapper.sendFileContent(userPreferences.getRepImages(), image.getNewNom(), imageStream);
                        imageMapper.changeModeImageLite(image, null, tableName, pkField, fieldModeStockage, fieldBlob);
                    }
                }
                // photos renommées, réordonnées, etc (q5)
                // obligatoire pour les changement de stockage
                imageMapper.updateMetadataImageLite(image, image.getNewNom(), tableName, pkField, fieldFile);
            }
        }

        int result;
        for (@NonNls String s : fichiersImages) {
            result = commonMapper.deleteFile(s);
            if (result != 0)
                throw new ConsistencyException(s + "\n\n" + result);
        }
    }

}
