/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * SpringTest.java
 * Last modified by Tetram, on 2014-07-29T11:02:08CEST
 */

package org.tetram.bdtheque;

import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * Created by Thierry on 24/05/2014.
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"/org/tetram/bdtheque/config/spring-config.xml"})
public abstract class SpringTest {

}
