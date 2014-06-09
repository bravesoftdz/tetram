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
