package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.ValeurListe;

/**
 * Created by Thierry on 10/06/2014.
 */
public interface ValeurListeDao {
    ValeurListe getDefaultEtat();

    ValeurListe getDefaultReliure();

    ValeurListe getDefaultTypeEdition();

    ValeurListe getDefaultOrientation();

    ValeurListe getDefaultFormatEdition();

    ValeurListe getDefaultTypeCouverture();

    ValeurListe getDefaultTypeParaBD();

    ValeurListe getDefaultSensLecture();

    ValeurListe getDefaultNotation();

    ValeurListe getDefaultTypePhoto();
}
