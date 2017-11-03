/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * MonthTypeHandler.java
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
import java.time.Month;

/**
 * Created by Thierry on 02/07/2014.
 */
public class MonthTypeHandler extends BaseTypeHandler<Month> {

    Month fromInt(int value) {
        if (value < 1 || value > 12)
            return null;
        return Month.of(value);
    }

    @Override
    public void setNonNullParameter(PreparedStatement ps, int i, @NotNull Month parameter, JdbcType jdbcType) throws SQLException {
        ps.setInt(i, parameter.getValue());
    }

    @Override
    public Month getNullableResult(ResultSet rs, String columnName) throws SQLException {
        return fromInt(rs.getInt(columnName));
    }

    @Override
    public Month getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
        return fromInt(rs.getInt(columnIndex));
    }

    @Override
    public Month getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
        return fromInt(cs.getInt(columnIndex));
    }
}
