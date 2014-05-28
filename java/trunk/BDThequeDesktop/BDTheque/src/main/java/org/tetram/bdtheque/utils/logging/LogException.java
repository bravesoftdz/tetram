package org.tetram.bdtheque.utils.logging;

/**
 * Created by Thierry on 28/05/2014.
 */
public class LogException extends RuntimeException {
    public LogException() {
        super();
    }

    public LogException(String message) {
        super(message);
    }

    public LogException(String message, Throwable cause) {
        super(message, cause);
    }

    public LogException(Throwable cause) {
        super(cause);
    }
}
