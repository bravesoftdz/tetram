package org.tetram.bdtheque.data.services;

/**
 * Created by Thierry on 15/06/2014.
 */
public interface UserPreferences {
    void reload();
    void save();

    String getRepImages();

    void setRepImages(String value);
}
