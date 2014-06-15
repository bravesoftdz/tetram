package org.tetram.bdtheque;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.data.services.UserPreferences;

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
        userPreferences.setRepImages("blabla3");
        userPreferences.save();
    }
}