package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.tetram.bdtheque.data.bean.EditionBean;
import org.tetram.bdtheque.data.dao.EditeurDao;
import org.tetram.bdtheque.data.dao.ListeDao;
import org.tetram.bdtheque.data.dao.lite.CollectionLiteDao;
import org.tetram.bdtheque.database.DDLConstants;

import java.util.UUID;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsBool;
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
        bean.setStock(getFieldAsBool(cursor, DDLConstants.EDITIONS_STOCK, true));
        bean.setCouleur(getFieldAsBool(cursor, DDLConstants.EDITIONS_COULEUR, true));
        bean.setDedicace(getFieldAsBool(cursor, DDLConstants.EDITIONS_DEDICACE, false));
        bean.setOffert(getFieldAsBool(cursor, DDLConstants.EDITIONS_OFFERT, false));
        bean.setDateAquisition(getFieldAsDate(cursor, DDLConstants.EDITIONS_DATEACHAT));
        bean.setNotes(getFieldAsString(cursor, DDLConstants.EDITIONS_NOTES));
        bean.setPages(getFieldAsInteger(cursor, DDLConstants.EDITIONS_NOMBREDEPAGES));
        bean.setNumeroPerso(getFieldAsString(cursor, DDLConstants.EDITIONS_NUMEROPERSO));
        bean.setGratuit(getFieldAsBool(cursor, DDLConstants.EDITIONS_GRATUIT, false));
        bean.setPrix(getFieldAsDouble(cursor, DDLConstants.EDITIONS_PRIX));
        bean.setAnneeCote(getFieldAsInteger(cursor, DDLConstants.EDITIONS_ANNEECOTE));
        bean.setPrixCote(getFieldAsDouble(cursor, DDLConstants.EDITIONS_PRIXCOTE));

        final ListeDao listeDao = new ListeDao(context);
        bean.setTypeEdition(listeDao.getById(getFieldAsUUID(cursor, DDLConstants.EDITIONS_TYPEEDITION)));
        bean.setReliure(listeDao.getById(getFieldAsUUID(cursor, DDLConstants.EDITIONS_RELIURE)));
        bean.setEtat(listeDao.getById(getFieldAsUUID(cursor, DDLConstants.EDITIONS_ETAT)));
        bean.setOrientation(listeDao.getById(getFieldAsUUID(cursor, DDLConstants.EDITIONS_ORIENTATION)));
        bean.setFormatEdition(listeDao.getById(getFieldAsUUID(cursor, DDLConstants.EDITIONS_FORMATEDITION)));
        bean.setSensLecture(listeDao.getById(getFieldAsUUID(cursor, DDLConstants.EDITIONS_SENSLECTURE)));

        return true;
    }
}
