package org.tetram.bdtheque.data;

import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;
import org.jetbrains.annotations.NotNull;
import org.tetram.bdtheque.data.bean.ValeurListe;

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

// le typehandler présuppose qu'on a un champ du même nom que le champ valeur et préfixé de LABEL_PREFIX pour contenir le libellé
public class ValeurListeTypeHandler extends BaseTypeHandler<ValeurListe> {

    public static final String LABEL_PREFIX = "lb_";

    @Override
    public void setNonNullParameter(PreparedStatement ps, int i, @NotNull ValeurListe parameter, JdbcType jdbcType) throws SQLException {
        ps.setInt(i, parameter.getValeur());
    }

    @Override
    public ValeurListe getNullableResult(ResultSet rs, String columnName) throws SQLException {
        ValeurListe v = new ValeurListe();
        v.setValeur(rs.getInt(columnName));
        if (rs.wasNull())
            return null;
        v.setTexte(rs.getString(LABEL_PREFIX + columnName));
        return v;
    }

    @Override
    public ValeurListe getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
        return getNullableResult(rs, rs.getMetaData().getColumnName(columnIndex));
    }

    @Override
    public ValeurListe getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
        ValeurListe v = new ValeurListe();
        v.setValeur(cs.getInt(columnIndex));
        if (cs.wasNull())
            return null;
        v.setTexte(cs.getString(LABEL_PREFIX + cs.getMetaData().getColumnName(columnIndex)));
        return v;
    }
}
