/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * ConsistencyException.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data;

import org.apache.ibatis.exceptions.PersistenceException;

/**
 * Created by Thierry on 09/06/2014.
 */
public class ConsistencyException extends PersistenceException {
    public ConsistencyException() {
    }

    public ConsistencyException(String message) {
        super(message);
    }

    public ConsistencyException(String message, Throwable cause) {
        super(message, cause);
    }

    public ConsistencyException(Throwable cause) {
        super(cause);
    }
}
