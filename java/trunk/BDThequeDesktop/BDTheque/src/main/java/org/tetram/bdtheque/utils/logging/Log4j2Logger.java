package org.tetram.bdtheque.utils.logging;

import org.apache.logging.log4j.Logger;

/**
 * Created by Thierry on 28/05/2014.
 */
class Log4j2Logger implements Log {

    private final Logger logger;

    public Log4j2Logger(String logger) {
        this.logger = org.apache.logging.log4j.LogManager.getLogger(logger);
    }

    public boolean isDebugEnabled() {
        return logger.isDebugEnabled();
    }

    public boolean isTraceEnabled() {
        return logger.isTraceEnabled();
    }

    public void error(String s, Throwable e) {
        logger.error(s, e);
    }

    public void error(String s) {
        logger.error(s);
    }

    public void debug(String s) {
        if (isDebugEnabled()) logger.debug(s);
    }

    public void trace(String s) {
        if (isTraceEnabled()) logger.trace(s);
    }

    public void warn(String s) {
        logger.warn(s);
    }

}
