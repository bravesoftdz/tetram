using System;
using System.Data;
using System.Globalization;
using System.Reflection;
using System.Collections;
using TetramCorp.Utilities;
using System.Text;

namespace TetramCorp.Database
{
    [AttributeUsage(AttributeTargets.Field | AttributeTargets.Property)]
    public class SQLDataAttribute : System.Attribute
    {
    }

    [AttributeUsage(AttributeTargets.Field | AttributeTargets.Property)]
    public sealed class SQLDataFieldAttribute : SQLDataAttribute
    {
        internal string SQLFieldName; // = null;

        public SQLDataFieldAttribute()
            : base()
        {
        }

        public SQLDataFieldAttribute(string fieldName)
            : base()
        {
            SQLFieldName = fieldName;
        }

        public string FieldName
        {
            get { return SQLFieldName; }
        }
    }

    [AttributeUsage(AttributeTargets.Field | AttributeTargets.Property)]
    public sealed class SQLDataClassAttribute : SQLDataAttribute { }
    [AttributeUsage(AttributeTargets.Field | AttributeTargets.Property)]
    public sealed class IsReferenceAttribute : SQLDataAttribute { }

    public class SQLDataFieldInfo : IDisposable
    {
        internal string SQLFieldName; // = null;
        internal int fieldIndex;
        internal FieldInfo Field;
        internal PropertyInfo Property;
        internal Type FieldType;
        internal SQLDataClassInfo ParentInfo; // = null;

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        private void Dispose(Boolean disposing)
        {
            if (disposing)
            {
                if (ParentInfo != null)
                {
                    (ParentInfo as IDisposable).Dispose();
                    ParentInfo = null;
                }
                Field = null;
            }
        }

        public SQLDataFieldInfo(SQLDataFieldAttribute fa, FieldInfo field, SQLDataClassInfo parentClass)
        {
            Field = field;
            Property = null;
            FieldType = Field.FieldType;
            Init(fa, parentClass);
        }

        public SQLDataFieldInfo(SQLDataFieldAttribute fa, PropertyInfo property, SQLDataClassInfo parentClass)
        {
            Field = null;
            Property = property;
            FieldType = Property.PropertyType;
            Init(fa, parentClass);
        }

        internal void Init(SQLDataFieldAttribute fa, SQLDataClassInfo parentClass)
        {
            ParentInfo = parentClass;
            if (string.IsNullOrEmpty(fa.SQLFieldName))
            {
                SQLFieldName = string.Empty;
                if (Field != null)
                    SQLFieldName = Field.Name.ToUpper(CultureInfo.CurrentCulture);
                if (Property != null)
                    SQLFieldName = Property.Name.ToUpper(CultureInfo.CurrentCulture);
            }
            else
                SQLFieldName = fa.SQLFieldName.ToUpper(CultureInfo.CurrentCulture);
            fieldIndex = -1;
        }

        public void SetValue(object obj, object value)
        {
            object fieldObject = obj;
            if (ParentInfo != null)
                fieldObject = ParentInfo.GetValue(obj);

            if (Field != null) Field.SetValue(fieldObject, value);
            if (Property != null) Property.SetValue(fieldObject, value, null);
        }
    }

    public class SQLDataClassInfo : IDisposable
    {
        internal SQLDataClassInfo ParentField; // = null;
        internal FieldInfo Field;
        internal PropertyInfo Property;

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        private void Dispose(Boolean disposing)
        {
            if (disposing)
            {
                if (ParentField != null)
                {
                    (ParentField as IDisposable).Dispose();
                    ParentField = null;
                }
                Field = null;
            }
        }

        public SQLDataClassInfo(FieldInfo field, SQLDataClassInfo parentClass)
        {
            Field = field;
            Property = null;
            ParentField = parentClass;
        }

        public SQLDataClassInfo(PropertyInfo property, SQLDataClassInfo parentClass)
        {
            Field = null;
            Property = property;
            ParentField = parentClass;
        }

        internal object GetValue(object obj)
        {
            object fieldObject = obj;
            if (ParentField != null)
                fieldObject = ParentField.GetValue(obj);

            if (Field != null) return Field.GetValue(fieldObject);
            if (Property != null) return Property.GetValue(fieldObject, null);
            return null;
        }
    }

    public class BaseDataReader<T> : IDisposable where T : class, new()
    {
        private IDataReader dataReader;
        private ArrayList Fields;

        public BaseDataReader(IDataReader dr)
        {
            Fields = new ArrayList();
            DataReader = dr;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        private void Dispose(Boolean disposing)
        {
            if (disposing)
            {
                dataReader = null;
                foreach (IDisposable fi in Fields)
                    fi.Dispose();
                Fields.Clear();
            }
        }

        internal void GetFields(Type Classe, SQLDataClassInfo ParentClass)
        {
            foreach (FieldInfo Field in Classe.GetFields(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance))
            {
                foreach (SQLDataAttribute sqldata in Field.GetCustomAttributes(typeof(SQLDataAttribute), true))
                {
                    if (sqldata.GetType() == typeof(SQLDataFieldAttribute))
                        Fields.Add(new SQLDataFieldInfo(sqldata as SQLDataFieldAttribute, Field, ParentClass));
                    else
                        if (sqldata.GetType() == typeof(SQLDataClassAttribute))
                            GetFields(Field.FieldType, new SQLDataClassInfo(Field, ParentClass));
                }
            }

            foreach (PropertyInfo Property in Classe.GetProperties(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance))
            {
                foreach (SQLDataAttribute sqldata in Property.GetCustomAttributes(typeof(SQLDataAttribute), true))
                {
                    if (sqldata.GetType() == typeof(SQLDataFieldAttribute))
                        Fields.Add(new SQLDataFieldInfo(sqldata as SQLDataFieldAttribute, Property, ParentClass));
                    else
                        if (sqldata.GetType() == typeof(SQLDataClassAttribute))
                            GetFields(Property.PropertyType, new SQLDataClassInfo(Property, ParentClass));
                }
            }
        }

        private void PopulateKnownFields()
        {
            Fields.Clear();
            if (DataReader != null)
            {
                GetFields(typeof(T), null);

                string fieldName;
                int c = 0;
                for (int i = 0; i < DataReader.FieldCount && c < Fields.Count; i++)
                {
                    fieldName = DataReader.GetName(i);
                    foreach (SQLDataFieldInfo fi in Fields)
                        if (fi.SQLFieldName.CompareTo(fieldName) == 0)
                        {
                            if (fi.fieldIndex == -1)
                            {
                                fi.fieldIndex = i;
                                c++;
                            }
                        }
                }
            }
        }

        public object LoadData(T obj)
        {
            if (obj == null) return null;
            //			if (!(obj.GetType().Equals(typeof(T)))) throw new ArgumentException("obj n'est pas descendant de type " + typeof(T).FullName);

            foreach (SQLDataFieldInfo fi in Fields)
            {
                if (fi.fieldIndex != -1)
                {
                    if (fi.FieldType == typeof(string))
                        fi.SetValue(obj, GetString(fi.fieldIndex));
                    if (fi.FieldType == typeof(Guid))
                        fi.SetValue(obj, GetGuid(fi.fieldIndex));
                    if (fi.FieldType == typeof(FormatedTitle))
                        fi.SetValue(obj, new FormatedTitle(GetString(fi.fieldIndex)));
                    if (fi.FieldType == typeof(int))
                        fi.SetValue(obj, GetInt(fi.fieldIndex));
                    if (fi.FieldType == typeof(bool))
                        fi.SetValue(obj, GetBoolean(fi.fieldIndex));
                    if (fi.FieldType == typeof(decimal))
                        fi.SetValue(obj, GetDecimal(fi.fieldIndex));
                    if (fi.FieldType == typeof(DateTime))
                        fi.SetValue(obj, GetDateTime(fi.fieldIndex));
                }
            }

            return obj;
        }

        public IDataReader DataReader
        {
            get
            {
                return dataReader;
            }
            set
            {
                dataReader = value;
                PopulateKnownFields();
            }
        }

        public string GetString(int fieldIndex, string nullValue)
        {
            if (fieldIndex == -1 || DataReader.IsDBNull(fieldIndex)) return nullValue;
            Type fieldType = DataReader.GetFieldType(fieldIndex);
            if (fieldType == typeof(string))
                return DataReader.GetString(fieldIndex);

            int bufsize = 1024;
            byte[] blob = new byte[bufsize];
            long index = 0;
            long retval = 0;
            StringBuilder result = new StringBuilder();
            while ((retval = DataReader.GetBytes(fieldIndex, index, blob, 0, bufsize)) > 0)
            {
                index += retval;
                result.Append(System.Text.Encoding.Default.GetChars(blob), 0, (int)retval);
            }
            return result.ToString();
        }

        public string GetString(int fieldIndex)
        {
            return GetString(fieldIndex, null);
        }

        public int GetInt(int fieldIndex, int nullValue)
        {
            if (fieldIndex == -1 || DataReader.IsDBNull(fieldIndex)) return nullValue;
            Type fieldType = DataReader.GetFieldType(fieldIndex);
            if (fieldType == typeof(Int16))
                return DataReader.GetInt16(fieldIndex);
            return DataReader.GetInt32(fieldIndex);
        }

        public int GetInt(int fieldIndex)
        {
            return GetInt(fieldIndex, 0);
        }

        public Guid GetGuid(int fieldIndex, Guid nullValue)
        {
            if (fieldIndex == -1 || DataReader.IsDBNull(fieldIndex)) return nullValue;
            Type fieldType = DataReader.GetFieldType(fieldIndex);
            if (fieldType == typeof(string))
                return StringUtils.StringToGuid(DataReader.GetString(fieldIndex));
            else
                return DataReader.GetGuid(fieldIndex);
        }

            
        public Guid GetGuid(string fieldIndex)
        {
            return GetGuid(DataReader.GetOrdinal(fieldIndex), Guid.Empty);
        }

        public Guid GetGuid(int fieldIndex)
        {
            return GetGuid(fieldIndex, Guid.Empty);
        }

        public bool GetBoolean(int fieldIndex, bool nullValue)
        {
            if (fieldIndex == -1 || DataReader.IsDBNull(fieldIndex)) return nullValue;
            Type fieldType = DataReader.GetFieldType(fieldIndex);
            if (fieldType == typeof(Int32))
                return DataReader.GetInt32(fieldIndex) != 0;
            if (fieldType == typeof(Int16))
                return DataReader.GetInt16(fieldIndex) != 0;
            return DataReader.GetBoolean(fieldIndex);
        }

        public bool GetBoolean(int fieldIndex)
        {
            return GetBoolean(fieldIndex, false);
        }

        public decimal GetDecimal(int fieldIndex, decimal nullValue)
        {
            if (fieldIndex == -1 || DataReader.IsDBNull(fieldIndex))
                return nullValue;
            Type fieldType = DataReader.GetFieldType(fieldIndex);
            if (fieldType == typeof(decimal))
                return DataReader.GetDecimal(fieldIndex);
            else
                return GetInt(fieldIndex);
        }

        public decimal GetDecimal(int fieldIndex)
        {
            return GetDecimal(fieldIndex, 0);
        }

        public DateTime GetDateTime(int fieldIndex, DateTime nullValue)
        {
            if (fieldIndex == -1 || DataReader.IsDBNull(fieldIndex))
                return nullValue;
            return DataReader.GetDateTime(fieldIndex);
        }

        public DateTime GetDateTime(int fieldIndex)
        {
            return GetDateTime(fieldIndex, DateTime.MinValue);
        }

        public T NextObject()
        {
            return (T)LoadData(new T());
        }

        public void FillList(System.Collections.Generic.List<T> list)
        {
            if (list == null) return;
            list.Clear();
            while (DataReader.Read())
                list.Add(NextObject());
        }

    }

    [System.Runtime.InteropServices.ComVisible(true)]
    public class BaseRecord
    {
        public virtual void Fill(params object[] references) { }

        public static T Create<T>(params object[] references) where T : BaseRecord
        {
            T t = Activator.CreateInstance<T>();
            t.Fill(references);
            return t;
        }

        public Guid Reference
        {
            get
            {
                foreach (FieldInfo Field in this.GetType().GetFields())
                    if (Field.GetCustomAttributes(typeof(IsReferenceAttribute), true).Length > 0)
                        return (Guid)Field.GetValue(this);
                foreach (PropertyInfo Property in this.GetType().GetProperties())
                    if (Property.GetCustomAttributes(typeof(IsReferenceAttribute), true).Length > 0)
                        return (Guid)Property.GetValue(this, null);
                return Guid.Empty;
            }
        }
    }

}