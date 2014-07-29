/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * URLTypeHandler.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data;

import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;
import org.jetbrains.annotations.NotNull;

import java.net.MalformedURLException;
import java.net.URL;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Created by Thierry on 24/05/2014.
 */
// si on met l'annotation MappedJdbcTypes, il faut indiquer explicitement le JdbcType (ou le typehandler) sur les champs mappé sur un type UUID
// ne pas mettre l'annotation impose de tester le paramètre jdbcType pour connaitre le type de la propriété: ici on suppose toujours VARCHAR
//@MappedJdbcTypes(JdbcType.VARCHAR)
public class URLTypeHandler extends BaseTypeHandler<URL> {
    @Override
    public void setNonNullParameter(PreparedStatement ps, int i, @NotNull URL parameter, JdbcType jdbcType) throws SQLException {
        ps.setString(i, parameter.toString());
    }

    @Override
    public URL getNullableResult(ResultSet rs, String columnName) throws SQLException {
        try {
            return new URL(rs.getString(columnName));
        } catch (MalformedURLException e) {
            return null;
        }
    }

    @Override
    public URL getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
        try {
            return new URL(rs.getString(columnIndex));
        } catch (MalformedURLException e) {
            return null;
        }
    }

    @Override
    public URL getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
        try {
            return new URL(cs.getString(columnIndex));
        } catch (MalformedURLException e) {
            return null;
        }
    }
}
