package org.tetram.bdtheque.utils;


import org.jetbrains.annotations.Contract;
import org.jetbrains.annotations.NonNls;

import java.util.Collection;
import java.util.Locale;
import java.util.UUID;

@SuppressWarnings("UnusedDeclaration")
public abstract class StringUtils {

    @Contract("null -> null")
    public static UUID GUIDStringToUUID(final String guid) {
        return guid == null ? null : UUID.fromString(guid.substring(1, guid.length() - 1));
    }

    @Contract("null,null -> null; null,!null -> !null")
    public static UUID GUIDStringToUUIDDef(final String guid, final UUID defaultGUID) {
        try {
            return guid == null ? defaultGUID : UUID.fromString(guid.substring(1, guid.length() - 1));
        } catch (final Exception e) {
            return defaultGUID;
        }
    }

    @NonNls
    @Contract("null -> null")
    public static String UUIDToGUIDString(final UUID uuid) {
        return uuid == null ? null : "{" + uuid.toString().toUpperCase(Locale.US) + "}";
    }

    public static String ajoutString(final String chaine, final String ajout, final String espace) {
        return ajoutString(chaine, ajout, espace, "", "");
    }

    public static String ajoutString(final String chaine, final String ajout, final String espace, final String avant) {
        return ajoutString(chaine, ajout, espace, avant, "");
    }

    @SuppressWarnings("CallToStringEquals")
    public static String ajoutString(String chaine, final String ajout, final String espace, final String avant, final String apres) {
        final StringBuilder stringBuilder = new StringBuilder(
                ((chaine == null) ? 0 : chaine.length())
                        + ((ajout == null) ? 0 : ajout.length())
                        + ((espace == null) ? 0 : espace.length())
                        + ((avant == null) ? 0 : avant.length())
                        + ((apres == null) ? 0 : apres.length())
        );
        if (chaine != null) stringBuilder.append(chaine);
        if ((ajout != null) && !"".equals(ajout)) {
            if ((stringBuilder.length() > 0) && (espace != null)) stringBuilder.append(espace);
            if (avant != null) stringBuilder.append(avant);
            stringBuilder.append(ajout);
            if (apres != null) stringBuilder.append(apres);
        }
        return stringBuilder.toString();
    }

    @SuppressWarnings("CallToStringEquals")
    @Contract("null -> !null")
    public static String nonZero(final String s) {
        if ((s == null) || "0".equals(s.trim()))
            return "";
        return s;
    }

    @SuppressWarnings("CallToNumericToString")
    @Contract("null -> !null")
    public static String nonZero(final Integer i) {
        if ((i == null) || Integer.valueOf(0).equals(i))
            return "";
        return i.toString();
    }

    public static String trimRight(final String str) {
        final int start = 0;
        final int last = str.length() - 1;
        int end = last;
        while ((end >= start) && (str.charAt(end) == ' ')) {
            end--;
        }
        if (end == last) {
            return str;
        }
        return str.substring(start, end + 1);
    }

    public static boolean isNullOrEmpty(String string) {
        return string == null || string.isEmpty();
    }

    public static <T extends Collection> boolean isNullOrEmpty(T list) {
        return list == null || list.isEmpty();
    }

    @Contract("null -> !null; !null -> !null")
    public static String notNull(String s) {
        return s == null ? "" : s;
    }
}
