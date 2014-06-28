package org.tetram.bdtheque.utils;

import org.jetbrains.annotations.NonNls;

import java.time.Year;
import java.util.UUID;

/**
 * Created by Thierry on 18/06/2014.
 */
public class TypeUtils {
    @NonNls
    public static final UUID GUID_FULL = StringUtils.GUIDStringToUUID("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}");
    @NonNls
    public static final String GUID_FULL_STRING = "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}";
    @NonNls
    public static final UUID GUID_NULL = StringUtils.GUIDStringToUUID("{00000000-0000-0000-0000-000000000000}");
    @NonNls
    public static final String GUID_NULL_STRING = "{00000000-0000-0000-0000-000000000000}";

    public static boolean isNullOrZero(Integer value) {
        return value == null || Integer.valueOf(0).equals(value);
    }

    public static boolean sameValue(String s1, String s2) {
        s1 = s1 == null ? "" : s1;
        s2 = s2 == null ? "" : s2;
        return s1.equalsIgnoreCase(s2);
    }

    public static <T> boolean sameValue(T d1, T d2) {
        return d1 == d2 || (d1 != null && d1.equals(d2));
    }

    public static String nonZero(Year year) {
        return year == null || year.equals(Year.of(0)) ? "" : year.toString();
    }
}
