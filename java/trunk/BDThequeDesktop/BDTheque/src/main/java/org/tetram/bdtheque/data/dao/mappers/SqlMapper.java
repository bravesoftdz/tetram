package org.tetram.bdtheque.data.dao.mappers;

import org.apache.ibatis.annotations.SelectProvider;
import org.jetbrains.annotations.NonNls;

import java.util.List;

/**
 * Created by Thierry on 18/06/2014.
 */
public interface SqlMapper extends BaseMapperInterface {
    static class PureSqlProvider {
        public String sql(String sql) {
            return sql;
        }

        @NonNls
        public String count(String from) {
            return "SELECT count(*) FROM " + from;
        }
    }

    @SelectProvider(type = PureSqlProvider.class, method = "sql")
    public List<?> select(@NonNls String sql);

    @SelectProvider(type = PureSqlProvider.class, method = "count")
    public Integer count(@NonNls String from);

    @SelectProvider(type = PureSqlProvider.class, method = "sql")
    public Integer execute(@NonNls String query);
}