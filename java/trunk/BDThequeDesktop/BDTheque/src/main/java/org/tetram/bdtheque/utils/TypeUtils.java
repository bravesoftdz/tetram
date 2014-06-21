package org.tetram.bdtheque.utils;

import org.jetbrains.annotations.NonNls;

import java.util.Date;
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

    public static boolean sameValue(Integer i1, Integer i2) {
        i1 = i1 == null ? Integer.valueOf(0) : i1;
        i2 = i2 == null ? Integer.valueOf(0) : i2;
        return i1.equals(i2);
    }

    public static boolean sameValue(UUID u1, UUID u2) {
        u1 = u1 == null ? GUID_NULL : u1;
        u2 = u2 == null ? GUID_NULL : u2;
        return u1.equals(u2);
    }

    public static boolean sameValue(Double d1, Double d2) {
        d1 = d1 == null ? Double.valueOf(0) : d1;
        d2 = d2 == null ? Double.valueOf(0) : d2;
        return d1.equals(d2);
    }

    public static boolean sameValue(Date d1, Date d2) {
        d1 = d1 == null ? new Date(0) : d1;
        d2 = d2 == null ? new Date(0) : d2;
        return d1.equals(d2);
    }
}
