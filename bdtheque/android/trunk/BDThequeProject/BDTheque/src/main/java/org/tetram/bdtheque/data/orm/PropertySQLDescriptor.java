package org.tetram.bdtheque.data.orm;

@SuppressWarnings("UnusedDeclaration")
public class PropertySQLDescriptor {
    SimplePropertyDescriptor property;
    String aliasName;
    String fullFieldName;
    PropertySQLDescriptor masterProperty;

    public SimplePropertyDescriptor getProperty() {
        return this.property;
    }

    public String getAliasName() {
        return this.aliasName;
    }

    public String getFullFieldName() {
        return this.fullFieldName;
    }

    public boolean isNullable() {
        boolean result = this.property.getAnnotation().nullable();
        if (this.masterProperty != null)
            result = result || this.masterProperty.isNullable();
        return result;
    }

    public PropertySQLDescriptor getMasterProperty() {
        return this.masterProperty;
    }

}
