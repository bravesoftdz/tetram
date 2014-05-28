package org.tetram.bdtheque.data;

import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;
import org.jetbrains.annotations.NotNull;
import org.tetram.bdtheque.utils.StringUtils;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
// si on met l'annotation MappedJdbcTypes, il faut indiquer explicitement le JdbcType (ou le typehandler) sur les champs mappé sur un type UUID
// ne pas mettre l'annotation impose de tester le paramètre jdbcType pour connaitre le type de la propriété: ici on suppose toujours VARCHAR
//@MappedJdbcTypes(JdbcType.VARCHAR)
public class UUIDTypeHandler extends BaseTypeHandler<UUID> {
    @Override
    public void setNonNullParameter(PreparedStatement ps, int i, @NotNull UUID parameter, JdbcType jdbcType) throws SQLException {
        ps.setString(i, StringUtils.UUIDToGUIDString(parameter));
    }

    @Override
    public UUID getNullableResult(ResultSet rs, String columnName) throws SQLException {
        return StringUtils.GUIDStringToUUIDDef(rs.getString(columnName), null);
    }

    @Override
    public UUID getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
        return StringUtils.GUIDStringToUUIDDef(rs.getString(columnIndex), null);
    }

    @Override
    public UUID getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
        return StringUtils.GUIDStringToUUIDDef(cs.getString(columnIndex), null);
    }
}
