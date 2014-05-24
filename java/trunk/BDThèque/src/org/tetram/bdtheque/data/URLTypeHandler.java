package org.tetram.bdtheque.data;

import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;
import org.tetram.bdtheque.utils.StringUtils;

import java.net.MalformedURLException;
import java.net.URL;
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
public class URLTypeHandler extends BaseTypeHandler<URL> {
    @Override
    public void setNonNullParameter(PreparedStatement ps, int i, URL parameter, JdbcType jdbcType) throws SQLException {
        ps.setString(i, parameter == null ? null : parameter.toString());
    }

    @Override
    public URL getNullableResult(ResultSet rs, String columnName) throws SQLException {
        try {
            return new URL(rs.getString(columnName));
        } catch (MalformedURLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public URL getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
        try {
            return new URL(rs.getString(columnIndex));
        } catch (MalformedURLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public URL getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
        try {
            return new URL(cs.getString(columnIndex));
        } catch (MalformedURLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
