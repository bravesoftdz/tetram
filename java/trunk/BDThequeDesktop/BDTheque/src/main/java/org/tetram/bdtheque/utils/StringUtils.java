package org.tetram.bdtheque.utils;


import org.jetbrains.annotations.Contract;
import org.jetbrains.annotations.NonNls;
import org.tetram.bdtheque.data.BeanUtils;

import java.util.*;

@SuppressWarnings("UnusedDeclaration")
public abstract class StringUtils {

    @NonNls
    public static final UUID GUID_FULL = GUIDStringToUUID("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}");
    @NonNls
    public static final String GUID_FULL_STRING = "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}";
    public static final UUID GUID_NULL = GUIDStringToUUID("{00000000-0000-0000-0000-000000000000}");
    public static final String GUID_NULL_STRING = "{00000000-0000-0000-0000-000000000000}";

    public static UUID GUIDStringToUUID(final String guid) {
        return UUID.fromString(guid.substring(1, guid.length() - 1));
    }

    public static UUID GUIDStringToUUIDDef(final String guid, final UUID defaultGUID) {
        try {
            return UUID.fromString(guid.substring(1, guid.length() - 1));
        } catch (final Exception e) {
            return defaultGUID;
        }
    }

    @NonNls
    public static String UUIDToGUIDString(final UUID uuid) {
        return "{" + uuid.toString().toUpperCase(Locale.US) + "}";
    }

    public static String ajoutString(final String chaine, final String ajout, final String espace) {
        return ajoutString(chaine, ajout, espace, "", "");
    }

    public static String ajoutString(final String chaine, final String ajout, final String espace, final String avant) {
        return ajoutString(chaine, ajout, espace, avant, "");
    }

/*
function VerifieEAN(var Valeur: string): Boolean;
var
  i, fak, sum: Integer;
  tmp: string;
begin
  sum := 0;
  tmp := Copy(Valeur + '0000000000000', 1, 12);
  fak := Length(tmp);
  for i := 1 to Length(tmp) do
  begin
    if (fak mod 2) = 0 then
      sum := sum + (StrToInt(tmp[i]) * 1)
    else
      sum := sum + (StrToInt(tmp[i]) * 3);
    Dec(fak);
  end;
  if (sum mod 10) = 0 then
    tmp := tmp + '0'
  else
    tmp := tmp + IntToStr(10 - (sum mod 10));
  Result := Valeur = tmp;
  Valeur := tmp;
end;
*/

/*
function VerifieISBN(var Valeur: string; LongueurISBN: Integer = 10): Boolean;
var
  X, M, C, v: Integer;
  tmp: string;
begin
  tmp := ClearISBN(Valeur);
  Result := True;
  if tmp <> '' then
  begin
    if tmp[Length(tmp)] = 'X' then
    begin
      while Length(tmp) < LongueurISBN do
        Insert('0', tmp, Length(tmp) - 1);
      M := 10;
    end
    else
    begin
      while Length(tmp) < LongueurISBN do
        tmp := tmp + '0';
      M := Ord(tmp[Length(tmp)]) - Ord('0');
      //    M := StrToInt(tmp[Length(tmp)]);
    end;

    if LongueurISBN = 13 then
      Result := VerifieEAN(tmp)
    else
    begin
      C := 0;
      for X := 1 to Pred(Length(tmp)) do
        //    C := C + StrToInt(tmp[X]) * X;
        C := C + (Ord(tmp[X]) - Ord('0')) * X;
      v := C mod 11;
      Result := v = M;

      if v = 10 then
        tmp[Length(tmp)] := 'X'
      else
        tmp[Length(tmp)] := IntToStr(v)[1];
    end;
  end;
  Valeur := tmp;
end;
*/

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

}
