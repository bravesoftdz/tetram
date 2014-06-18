package org.tetram.bdtheque.utils;

/**
 * Created by Thierry on 18/06/2014.
 */
public class TypeUtils {
    public static boolean isNullOrZero(Integer value) {
        return value == null || Integer.valueOf(0).equals(value);
    }
}
