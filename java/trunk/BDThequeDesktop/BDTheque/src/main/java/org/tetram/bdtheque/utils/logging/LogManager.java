package org.tetram.bdtheque.utils.logging;

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
            throw new LogException("Error creating logger for logger " + logger + ".  Cause: " + t, t);
        }
    }

}
