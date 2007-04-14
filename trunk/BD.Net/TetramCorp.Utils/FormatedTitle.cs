using System;
using System.Text;

namespace TetramCorp.Utilities
{

    public sealed class StringUtils
    {
        private StringUtils() { }

        public static void AjoutString(StringBuilder chaine, string ajout, string espace)
        {
            AjoutString(chaine, ajout, espace, null, null);
        }

        public static void AjoutString(StringBuilder chaine, string ajout, string espace, string avant)
        {
            AjoutString(chaine, ajout, espace, avant, null);
        }

        public static void AjoutString(StringBuilder chaine, string ajout, string espace, string avant, string après)
        {
            if (chaine != null)
            {
                StringBuilder s = new StringBuilder(ajout);
                if (s.Length > 0)
                {
                    s.Insert(0, avant);
                    s.Append(après);
                    if (chaine.Length > 0) chaine.Append(espace);
                }
                chaine.Append(s);
            }
        }

        public static void AjoutString(StringBuilder chaine, StringBuilder ajout, string espace)
        {
            AjoutString(chaine, ajout, espace, null, null);
        }

        public static void AjoutString(StringBuilder chaine, StringBuilder ajout, string espace, string avant)
        {
            AjoutString(chaine, ajout, espace, avant, null);
        }

        public static void AjoutString(StringBuilder chaine, StringBuilder ajout, string espace, string avant, string après)
        {
            if (chaine != null)
            {
                StringBuilder s = new StringBuilder(ajout.ToString());
                if (s.Length > 0)
                {
                    s.Insert(0, avant);
                    s.Append(après);
                    if (chaine.Length > 0) chaine.Append(espace);
                }
                chaine.Append(s);
            }
        }

        public static string NotZero(string chaine)
        {
            if (chaine != null && chaine.Equals("0"))
                return string.Empty;
            else
                return chaine;
        }

        public static string ClearISBN(string Code)
        {
            string availableChars = "0123456789xX";
            StringBuilder result = new StringBuilder("");
            foreach (char c in Code)
                if (availableChars.IndexOf(c) > -1)
                    result.Append(c);
            return result.ToString().ToUpper();
        }

        //function VerifieISBN(var Valeur: string; LongueurISBN: Integer = 10): Boolean;
        //var
        //  X, M, C, v: Integer;
        //  tmp: string;
        //begin
        //  tmp := ClearISBN(Valeur);
        //  Result := True;
        //  if tmp <> '' then begin
        //    if tmp[Length(tmp)] = 'X' then begin
        //      while Length(tmp) < LongueurISBN do
        //        Insert('0', tmp, Length(tmp) - 1);
        //      M := 10;
        //    end
        //    else begin
        //      while Length(tmp) < LongueurISBN do
        //        tmp := tmp + '0';
        //      M := Ord(tmp[Length(tmp)]) - Ord('0');
        //      //    M := StrToInt(tmp[Length(tmp)]);
        //    end;
        //    C := 0;
        //    for X := 1 to Pred(Length(tmp)) do
        //      //    C := C + StrToInt(tmp[X]) * X;
        //      C := C + (Ord(tmp[X]) - Ord('0')) * X;
        //    v := C mod 11;
        //    Result := v = M;

        //    if v = 10 then
        //      tmp[Length(tmp)] := 'X'
        //    else
        //      tmp[Length(tmp)] := IntToStr(v)[1];
        //  end;
        //  Valeur := tmp;
        //end;

        internal static bool isBetween(string s, string s1, string s2)
        {
            return (s.CompareTo(s1) >= 0 && s.CompareTo(s2) <= 0);
        }

        public static string FormatISBN(string Code)
        {
            string CleanCode = (ClearISBN(Code) + "             ").Substring(0, 13).Trim(); // une fois nettoyé, le code ne peut contenir que 13 caractères
            StringBuilder s;
            string pred = string.Empty;
            if (CleanCode.Length > 10)
            {
                s = new StringBuilder((CleanCode + "   ").Substring(3, 10)); // ISBN13 = 3 premiers car de l'isbn13 + '-' + ISBN
                pred = CleanCode.Substring(0, 3) + '-';
            }
            else
                s = new StringBuilder(CleanCode);
            if (s.Length < 10)
                return String.Empty;

            int l = -1;
            string c;
            switch (s[0])
            {
                case '0':
                case '3':
                case '4':
                case '5': // codes anglophones
                    c = s.ToString(1, 2);
                    if (isBetween(c, "00", "19"))
                        l = 2;
                    else if (isBetween(c, "20", "69"))
                        l = 3;
                    else if (isBetween(c, "70", "84"))
                        l = 4;
                    else if (isBetween(c, "85", "89"))
                        l = 5;
                    else if (isBetween(c, "90", "94"))
                        l = 6;
                    else if (isBetween(c, "95", "99"))
                        l = 7;
                    break;
                case '2': // codes francophones
                    c = s.ToString().Substring(1, 2);
                    if (isBetween(c, "01", "19"))
                        l = 2;
                    else if (isBetween(c, "20", "34"))
                        l = 3;
                    else if (isBetween(c, "40", "69"))
                        l = 3;
                    else if (isBetween(c, "70", "83"))
                        l = 4;
                    else if (isBetween(c, "84", "89"))
                        l = 5;
                    else if (isBetween(c, "35", "39"))
                        l = 5;
                    else if (isBetween(c, "90", "94"))
                        l = 6;
                    else if (isBetween(c, "95", "99"))
                        l = 7;
                    break;
                case '1':
                    c = s.ToString(1, 6);
                    if (isBetween(c, "550000", "869799"))
                        l = 5;
                    else if (isBetween(c, "869800", "926429"))
                        l = 6;
                    break;
                case '7':
                    c = s.ToString(1, 2);
                    if (isBetween(c, "00", "09"))
                        l = 2;
                    else if (isBetween(c, "10", "49"))
                        l = 3;
                    else if (isBetween(c, "50", "79"))
                        l = 4;
                    else if (isBetween(c, "80", "89"))
                        l = 5;
                    else if (isBetween(c, "90", "99"))
                        l = 6;
                    break;
                case '8':
                    switch (s[1])
                    {
                        case '1':
                        case '3':
                        case '4':
                        case '5':
                        case '8':
                            c = s.ToString(2, 2);
                            if (isBetween(c, "00", "19"))
                                l = 2;
                            else if (isBetween(c, "20", "69"))
                                l = 3;
                            else if (isBetween(c, "70", "84"))
                                l = 4;
                            else if (isBetween(c, "85", "89"))
                                l = 5;
                            else if (isBetween(c, "90", "99"))
                                l = 6;
                            break;
                    }
                    break;
                case '9':
                    switch (s[1])
                    {
                        case '0':
                            c = s.ToString(2, 2);
                            if (isBetween(c, "00", "19"))
                                l = 3;
                            else if (isBetween(c, "20", "49"))
                                l = 4;
                            else if (isBetween(c, "50", "69"))
                                l = 5;
                            else if (isBetween(c, "70", "79"))
                                l = 6;
                            else if (isBetween(c, "80", "89"))
                                l = 7;
                            break;
                        case '2':
                            c = s.ToString(2, 2);
                            if (isBetween(c, "00", "05"))
                                l = 2;
                            else if (isBetween(c, "06", "07"))
                                l = 3;
                            else if (isBetween(c, "80", "89"))
                                l = 4;
                            else if (isBetween(c, "90", "99"))
                                l = 5;
                            break;
                    }
                    break;
            }

            if (l == -1)
                return string.Empty;
            return pred + string.Format("{0}-{1}-{2}-{3}", s[0], s.ToString(1, l), s.ToString(1 + l, 8 - l), s.ToString().Substring(9, 1));
        }

        public static string GuidToString(Guid value)
        {
            if (value.Equals(null))
                return null;
            else
                return '{' + value.ToString().ToUpper() + '}';
        }

        public static Guid StringToGuid(string value)
        {
            return (Guid)System.ComponentModel.TypeDescriptor.GetConverter(typeof(Guid)).ConvertFromString(value);
        }

        public static string QuotedStr(string S)
        {
            StringBuilder result = new StringBuilder(S);
            result.Replace("'", "''");
            return '\'' + result.ToString() + '\'';
        }

    }

    public class FormatedTitle
    {
        private string fRawTitle = string.Empty;

        public FormatedTitle()
        {
            fRawTitle = string.Empty;
        }

        public FormatedTitle(string rawTitle)
        {
            fRawTitle = rawTitle;
        }

        public override string ToString()
        {
            if (fRawTitle == null || fRawTitle.Length == 0) return string.Empty;
            int posStart = fRawTitle.LastIndexOfAny(new char[] { '[', '{' });
            if (posStart == -1) return fRawTitle;

            int posEnd = fRawTitle.IndexOf((fRawTitle.Substring(posStart, 1).Equals("[") ? ']' : '}'), posStart);
            if (posEnd == -1) return fRawTitle;

            string dummy = fRawTitle.Substring(posStart + 1, posEnd - posStart - 1);
            if (dummy.Length > 0 && !dummy.Substring(dummy.Length - 1).Equals("'"))
                dummy += " ";
            return (dummy + fRawTitle.Substring(0, posStart - 1) + fRawTitle.Substring(posEnd + 1)).Trim();
        }

        public string RawTitle
        {
            get
            {
                return fRawTitle;
            }
            set
            {
                fRawTitle = value;
            }
        }

    }
}