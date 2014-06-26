package org.tetram.bdtheque;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.data.services.UserPreferences;

import java.io.File;

public class UserPreferencesTest extends SpringTest {

    @Autowired
    private UserPreferences userPreferences;

    @Test
    public void testReload() throws Exception {

    }

    @Test
    public void testGetRepImages() throws Exception {
        userPreferences.getRepImages();
    }

    @Test
    public void testSetRepImages() throws Exception {
        userPreferences.setRepImages(new File("blabla3"));
        userPreferences.save();
    }
}