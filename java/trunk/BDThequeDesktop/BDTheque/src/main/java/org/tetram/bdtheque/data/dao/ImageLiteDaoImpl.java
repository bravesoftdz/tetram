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
import org.tetram.bdtheque.utils.ImageUtils;
import org.tetram.bdtheque.utils.StringUtils;
import org.tetram.bdtheque.utils.TypeUtils;

import javax.imageio.ImageIO;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.util.*;

/**
 * Created by Thierry on 13/06/2014.
 */
public abstract class ImageLiteDaoImpl<T extends ImageLite, K> extends DaoRWImpl<T, K> implements ImageLiteDao<T, K> {

    private final String tableName;
    private final String fieldPk;
    private final String fieldParentId;
    private final String fieldFile;
    private final String fieldModeStockage;
    private final String fieldBlob;

    @Autowired
    private ImageMapper imageMapper;
    @Autowired
    private CommonMapper commonMapper;
    @Autowired
    private UserPreferences userPreferences;

    protected ImageLiteDaoImpl(@NonNls String tableName, @NonNls String fieldPk, @NonNls String fieldParentId, @NonNls String fieldFile, @NonNls String fieldModeStockage, @NonNls String fieldBlob) {
        this.tableName = tableName;
        this.fieldPk = fieldPk;
        this.fieldParentId = fieldParentId;
        this.fieldFile = fieldFile;
        this.fieldModeStockage = fieldModeStockage;
        this.fieldBlob = fieldBlob;
    }

    @Override
    public byte[] getImageStream(T image, Integer height, Integer width, boolean antiAliasing, boolean cadre, int effet3D) {
        ImageStream imageInfo = imageMapper.getImageStream(image, tableName, fieldPk, fieldFile, fieldModeStockage, fieldBlob);
        if (imageInfo.getData().length == 0 && StringUtils.isNullOrEmpty(imageInfo.getFileName()))
            return null;

        byte[] imageBytes;
        if (imageInfo.isStockee()) {
            imageBytes = imageInfo.getData();
        } else {
            String fileName = new File(imageInfo.getFileName()).getName();
            String path = new File(imageInfo.getFileName()).getParent();
            if (StringUtils.isNullOrEmpty(path))
                path = userPreferences.getRepImages();

            imageBytes = commonMapper.getFileContent(path, fileName).getData();
            if (imageBytes == null || imageBytes.length == 0) return null;
        }

        try {
            ByteArrayOutputStream output = new ByteArrayOutputStream();
            // write to jpeg file
            ImageIO.write(ImageUtils.resizePicture(ImageIO.read(new ByteArrayInputStream(imageBytes)), height, width, antiAliasing, cadre, effet3D), ImageUtils.JPG_FORMAT, output);

            return output.toByteArray();
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    @SuppressWarnings({"HardCodedStringLiteral", "StringConcatenation"})
    @Override
    public void saveList(List<T> list, UUID parentId, Map<String, UUID> secondaryParams) {
        Set<String> fichiersImages = new HashSet<>();

        imageMapper.cleanImageLite(parentId, list, tableName, fieldParentId, fieldPk);
        for (T image : list) {
            image.setPosition(list.indexOf(image));
            if (image.getId() == null || image.getId().equals(TypeUtils.GUID_NULL)) {
                // nouvelles photos
                if (!image.isNewStockee()) {
                    // photos liées (q1)
                    image.setOldNom(image.getNewNom());
                    image.setNewNom(commonMapper.searchNewFileName(userPreferences.getRepImages(), new File(image.getNewNom()).getName(), true));
                    commonMapper.sendFileContent(userPreferences.getRepImages(), image.getNewNom(), ImageUtils.getJPEGStream(new File(image.getOldNom()), null, null, false));
                    imageMapper.addImageLite(
                            image, parentId, secondaryParams, image.getNewNom(), null,
                            tableName, fieldParentId, fieldPk, fieldFile, fieldModeStockage, fieldBlob
                    );
                } else if (new File(image.getNewNom()).exists()) {
                    // photos stockées (q2)
                    imageMapper.addImageLite(
                            image, parentId, secondaryParams, FilenameUtils.removeExtension(new File(image.getNewNom()).getName()), ImageUtils.getJPEGStream(new File(image.getNewNom())),
                            tableName, fieldParentId, fieldPk, fieldFile, fieldModeStockage, fieldBlob
                    );
                }
            } else {
                // ancienne photo
                if (image.isOldStockee() != image.isNewStockee()) {
                    // changement de stockage
                    byte[] imageStream = getImageStream(image, null, null, false);
                    if (image.isNewStockee()) {
                        // conversion photos liées en stockées (q3)
                        imageMapper.changeModeImageLite(image, imageStream, tableName, fieldPk, fieldModeStockage, fieldBlob);
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
                        imageMapper.changeModeImageLite(image, null, tableName, fieldPk, fieldModeStockage, fieldBlob);
                    }
                }
                // photos renommées, réordonnées, etc (q5)
                // obligatoire pour les changement de stockage
                imageMapper.updateMetadataImageLite(image, image.getNewNom(), tableName, fieldPk, fieldFile);
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
