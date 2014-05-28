package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.ValeurListe;

import java.util.List;

/**
 * Created by Thierry on 28/05/2014.
 */
public interface ValeurListeDao {
    List<ValeurListe> getListDefaultValeur();
}
