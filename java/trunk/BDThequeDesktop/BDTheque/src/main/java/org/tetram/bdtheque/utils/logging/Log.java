package org.tetram.bdtheque.utils.logging;

/**
 * Created by Thierry on 28/05/2014.
 */
public interface Log {
    boolean isDebugEnabled();

    boolean isTraceEnabled();

    void error(String s, Throwable e);

    void error(String s);

    void debug(String s);

    void trace(String s);

    void warn(String s);
}
