package org.tetram.bdtheque.data;

import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;
import org.jetbrains.annotations.NotNull;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Year;

/**
 * Created by Thierry on 24/05/2014.
 */
// si on met l'annotation MappedJdbcTypes, il faut indiquer explicitement le JdbcType (ou le typehandler) sur les champs mappé sur un type UUID
// ne pas mettre l'annotation impose de tester le paramètre jdbcType pour connaitre le type de la propriété: ici on suppose toujours VARCHAR
//@MappedJdbcTypes(JdbcType.VARCHAR)
public class YearTypeHandler extends BaseTypeHandler<Year> {

    @Override
    public void setNonNullParameter(PreparedStatement ps, int i, @NotNull Year parameter, JdbcType jdbcType) throws SQLException {
        ps.setInt(i, parameter.getValue());
    }

    @Override
    public Year getNullableResult(ResultSet rs, String columnName) throws SQLException {
        return Year.of(rs.getInt(columnName));
    }

    @Override
    public Year getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
        return Year.of(rs.getInt(columnIndex));
    }

    @Override
    public Year getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
        return Year.of(cs.getInt(columnIndex));
    }
}
