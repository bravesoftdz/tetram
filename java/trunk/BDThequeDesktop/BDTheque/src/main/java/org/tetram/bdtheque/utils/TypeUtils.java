/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * TypeUtils.java
 * Last modified by Tetram, on 2014-07-31T15:38:18CEST
 */

package org.tetram.bdtheque.utils;

import org.jetbrains.annotations.NonNls;

import java.time.Year;
import java.util.Map;
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

    public static boolean isNullOrZero(Year value) {
        return value == null || Year.of(0).equals(value);
    }

    public static boolean sameValue(String s1, String s2) {
        s1 = s1 == null ? "" : s1;
        s2 = s2 == null ? "" : s2;
        return s1.equalsIgnoreCase(s2);
    }

    public static <T> boolean sameValue(T v1, T v2) {
        return v1 == v2 || (v1 != null && v1.equals(v2));
    }

    public static String nonZero(Year year) {
        return year == null || year.equals(Year.of(0)) ? "" : year.toString();
    }

    public static boolean isNullOrZero(UUID uuid) {
        return uuid == null || uuid.equals(GUID_NULL);
    }

    public static boolean isNullOrEmpty(Map map) {
        return map == null || map.isEmpty();
    }
}
