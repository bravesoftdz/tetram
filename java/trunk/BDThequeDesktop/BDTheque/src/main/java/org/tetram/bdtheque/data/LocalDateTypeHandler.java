package org.tetram.bdtheque.data;

import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;
import org.jetbrains.annotations.NotNull;

import java.sql.*;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;

/**
 * Created by Thierry on 24/05/2014.
 */
// si on met l'annotation MappedJdbcTypes, il faut indiquer explicitement le JdbcType (ou le typehandler) sur les champs mappé sur un type UUID
// ne pas mettre l'annotation impose de tester le paramètre jdbcType pour connaitre le type de la propriété: ici on suppose toujours VARCHAR
//@MappedJdbcTypes(JdbcType.VARCHAR)
public class LocalDateTypeHandler extends BaseTypeHandler<LocalDate> {

    public static LocalDate toLocalDate(Date date) {
        if (date == null) return null;
        Instant instant = Instant.ofEpochMilli(date.getTime());
        return LocalDateTime.ofInstant(instant, ZoneId.systemDefault()).toLocalDate();
    }

    @Override
    public void setNonNullParameter(PreparedStatement ps, int i, @NotNull LocalDate parameter, JdbcType jdbcType) throws SQLException {
        ps.setDate(i, Date.valueOf(parameter));
    }

    @Override
    public LocalDate getNullableResult(ResultSet rs, String columnName) throws SQLException {
        return toLocalDate(rs.getDate(columnName));
    }

    @Override
    public LocalDate getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
        return toLocalDate(rs.getDate(columnIndex));
    }

    @Override
    public LocalDate getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
        return toLocalDate(cs.getDate(columnIndex));
    }
}
