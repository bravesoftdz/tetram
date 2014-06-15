package org.tetram.bdtheque.data.dao;

import org.apache.commons.io.FilenameUtils;
import org.jetbrains.annotations.NonNls;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.data.services.UserPreferences;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.bean.ImageLite;
import org.tetram.bdtheque.data.dao.mappers.CommonMapper;
import org.tetram.bdtheque.data.dao.mappers.ImageMapper;
import org.tetram.bdtheque.utils.FileUtils;
import org.tetram.bdtheque.utils.StringUtils;

import java.io.File;
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
                    byte[] imageStream = null; // GetCouvertureStream(True, image.ID, -1, -1, False);
                    if (image.isNewStockee()) {
                        // conversion photos liées en stockées (q3)
                        // qry3.ParamsSetBlob('image', imageStream);
                        // qry3.Params.ByNameAsString['pk']:=GUIDToString(image.ID);
                        // qry3.Execute;
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

                        // qry4.Params.ByNameAsString['pk']:=GUIDToString(image.ID);
                        // qry4.Execute;
                    }
                }
                // photos renommées, réordonnées, etc (q5)
                // obligatoire pour les changement de stockage
                // qry5.Params.ByNameAsString['fichier']:=image.NewNom;
                // qry5.Params.ByNameAsInteger['ordre']:=List.IndexOf(image);
                // qry5.Params.ByNameAsInteger['categorieimage']:=image.Categorie;
                // qry5.Params.ByNameAsString['pk']:=

                // GUIDToString(image.ID);

                // qry5.Execute;
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
