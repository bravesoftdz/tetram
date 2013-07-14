package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.EditionBean;
import org.tetram.bdtheque.data.dao.EditeurDao;
import org.tetram.bdtheque.data.dao.lite.CollectionLiteDao;
import org.tetram.bdtheque.database.DDLConstants;

import java.util.UUID;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsBoolean;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsDate;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsDouble;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsInteger;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsUUID;

public class EditionFactory extends BeanFactoryImpl<EditionBean> {
    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean mustExists, EditionBean bean) {
        bean.setId(getFieldAsUUID(cursor, DDLConstants.EDITIONS_ID));
        if (mustExists && (bean.getId() == null)) return false;
        bean.setISBN(getFieldAsString(cursor, DDLConstants.EDITIONS_ISBN));
        final UUID editeurId = getFieldAsUUID(cursor, DDLConstants.EDITEURS_ID);
        if (editeurId != null) bean.setEditeur(new EditeurDao(context).getById(editeurId));
        final UUID collectionId = getFieldAsUUID(cursor, DDLConstants.COLLECTIONS_ID);
        if (collectionId != null)
            bean.setCollection(new CollectionLiteDao(context).getById(collectionId));
        bean.setAnnee(getFieldAsInteger(cursor, DDLConstants.EDITIONS_ANNEEEDITION));
        bean.setStock(getFieldAsBoolean(cursor, DDLConstants.EDITIONS_STOCK));
        bean.setCouleur(getFieldAsBoolean(cursor, DDLConstants.EDITIONS_COULEUR));
        bean.setDedicace(getFieldAsBoolean(cursor, DDLConstants.EDITIONS_DEDICACE));
        bean.setOffert(getFieldAsBoolean(cursor, DDLConstants.EDITIONS_OFFERT));
        bean.setDateAquisition(getFieldAsDate(cursor, DDLConstants.EDITIONS_DATEACHAT));
        bean.setNotes(getFieldAsString(cursor, DDLConstants.EDITIONS_NOTES));
        bean.setPages(getFieldAsInteger(cursor, DDLConstants.EDITIONS_NOMBREDEPAGES));
        bean.setNumeroPerso(getFieldAsString(cursor, DDLConstants.EDITIONS_NUMEROPERSO));
        bean.setGratuit(getFieldAsBoolean(cursor, DDLConstants.EDITIONS_GRATUIT));
        bean.setPrix(getFieldAsDouble(cursor, DDLConstants.EDITIONS_PRIX));
        bean.setAnneeCote(getFieldAsInteger(cursor, DDLConstants.EDITIONS_ANNEECOTE));
        bean.setPrixCote(getFieldAsDouble(cursor, DDLConstants.EDITIONS_PRIXCOTE));

        return true;
    }
}
