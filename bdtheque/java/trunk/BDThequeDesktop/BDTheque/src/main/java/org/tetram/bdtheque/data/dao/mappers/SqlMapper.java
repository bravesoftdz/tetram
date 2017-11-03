/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * SqlMapper.java
 * Last modified by Tetram, on 2014-07-29T11:02:06CEST
 */
package org.tetram.bdtheque.data.dao.mappers;

import org.apache.ibatis.annotations.SelectProvider;
import org.apache.ibatis.jdbc.SQL;
import org.jetbrains.annotations.NonNls;

import java.util.List;

/**
 * Created by Thierry on 18/06/2014.
 */
public interface SqlMapper extends BaseMapperInterface {
    @SelectProvider(type = PureSqlProvider.class, method = "sql")
    public List<?> select(@NonNls String sql);

    @SelectProvider(type = PureSqlProvider.class, method = "count")
    public Integer count(@NonNls String from);

    @SelectProvider(type = PureSqlProvider.class, method = "sql")
    public Integer execute(@NonNls String query);

    static class PureSqlProvider {
        public String sql(String sql) {
            return sql;
        }

        @SuppressWarnings("HardCodedStringLiteral")
        @NonNls
        public String count(String from) {
            return new SQL() {{
                SELECT("count(*)");
                FROM(from);
            }}.toString();
        }
    }
}