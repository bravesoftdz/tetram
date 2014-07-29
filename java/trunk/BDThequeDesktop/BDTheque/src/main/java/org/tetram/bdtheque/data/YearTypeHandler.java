/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * YearTypeHandler.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data;

import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;
import org.jetbrains.annotations.NotNull;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.DateTimeException;
import java.time.Year;

/**
 * Created by Thierry on 24/05/2014.
 */
public class YearTypeHandler extends BaseTypeHandler<Year> {

    Year fromInt(int value) {
        if (value < 1)
            return null;
        try {
            return Year.of(value);
        } catch (DateTimeException e) {
            return null;
        }
    }

    @Override
    public void setNonNullParameter(PreparedStatement ps, int i, @NotNull Year parameter, JdbcType jdbcType) throws SQLException {
        ps.setInt(i, parameter.getValue());
    }

    @Override
    public Year getNullableResult(ResultSet rs, String columnName) throws SQLException {
        return fromInt(rs.getInt(columnName));
    }

    @Override
    public Year getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
        return fromInt(rs.getInt(columnIndex));
    }

    @Override
    public Year getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
        return fromInt(cs.getInt(columnIndex));
    }
}
