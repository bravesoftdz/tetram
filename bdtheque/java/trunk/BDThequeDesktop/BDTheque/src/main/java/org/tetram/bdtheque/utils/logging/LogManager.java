/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * LogManager.java
 * Last modified by Tetram, on 2014-07-29T11:02:07CEST
 */

package org.tetram.bdtheque.utils.logging;

import org.tetram.bdtheque.utils.I18nSupport;

/**
 * Created by Thierry on 28/05/2014.
 */
public class LogManager {

    public static Log getLog(Class<?> aClass) {
        return getLog(aClass.getName());
    }

    public static Log getLog(String logger) {
        try {
            return new Log4j2Logger(logger);
        } catch (Throwable t) {
            throw new LogException(I18nSupport.message("error.creating.logger.for.logger.0.cause.1", logger, t), t);
        }
    }

}
