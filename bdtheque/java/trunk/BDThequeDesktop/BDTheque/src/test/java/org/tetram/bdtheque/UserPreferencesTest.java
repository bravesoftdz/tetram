/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * UserPreferencesTest.java
 * Last modified by Tetram, on 2014-07-29T11:02:08CEST
 */

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