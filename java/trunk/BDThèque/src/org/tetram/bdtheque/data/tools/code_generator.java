package org.tetram.bdtheque.data.tools;

import org.mybatis.generator.api.MyBatisGenerator;
import org.mybatis.generator.config.*;
import org.mybatis.generator.exception.InvalidConfigurationException;
import org.mybatis.generator.internal.DefaultShellCallback;

import java.io.Console;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Thierry on 23/05/2014.
 */
public class code_generator {

    public static void main(String[] args) throws InvalidConfigurationException {
        List<String> warnings = new ArrayList<>();
        boolean overwrite = true;
        Configuration config = new Configuration();

        //   ... fill out the config object as appropriate...
        config.addClasspathEntry("D:\\MEDIA.KIT\\BDTheque\\Java\\lib\\Jaybird-2.2.5-JDK_1.8\\jaybird-full-2.2.5.jar");
        Context context = new Context(ModelType.FLAT);
        context.setId("bdtheque");

        JDBCConnectionConfiguration jdbcConnectionConfiguration = new JDBCConnectionConfiguration();
        jdbcConnectionConfiguration.setDriverClass("org.firebirdsql.jdbc.FBDriver");
        jdbcConnectionConfiguration.setConnectionURL("jdbc:firebirdsql:embedded:D:\\MEDIA.KIT\\BDTheque\\bin\\BD.GDB");
        jdbcConnectionConfiguration.setUserId("SYSDBA");
        jdbcConnectionConfiguration.setPassword("masterkey");
        context.setJdbcConnectionConfiguration(jdbcConnectionConfiguration);

        JavaModelGeneratorConfiguration javaModelGeneratorConfiguration = new JavaModelGeneratorConfiguration();
        javaModelGeneratorConfiguration.setTargetPackage("bean");
        javaModelGeneratorConfiguration.setTargetProject("D:\\MEDIA.KIT\\BDTheque\\java\\BDThèque\\generated");
        context.setJavaModelGeneratorConfiguration(javaModelGeneratorConfiguration);

        JavaClientGeneratorConfiguration javaClientGeneratorConfiguration = new JavaClientGeneratorConfiguration();
        javaClientGeneratorConfiguration.setConfigurationType("XMLMAPPER");
        javaClientGeneratorConfiguration.setTargetPackage("dao");
        javaClientGeneratorConfiguration.setTargetProject("D:\\MEDIA.KIT\\BDTheque\\Java\\BDThèque\\generated");
        context.setJavaClientGeneratorConfiguration(javaClientGeneratorConfiguration);

        context.addTableConfiguration(getTableConfiguration(context, "collections", "id_collection"));
        context.addTableConfiguration(getTableConfiguration(context, "editeurs", "id_editeur"));
        context.addTableConfiguration(getTableConfiguration(context, "series", "id_serie"));
        context.addTableConfiguration(getTableConfiguration(context, "albums", "id_album"));

        SqlMapGeneratorConfiguration sqlMapGeneratorConfiguration = new SqlMapGeneratorConfiguration();
        sqlMapGeneratorConfiguration.setTargetPackage("bean");
        sqlMapGeneratorConfiguration.setTargetProject("D:\\MEDIA.KIT\\BDTheque\\Java\\BDThèque\\generated");
        context.setSqlMapGeneratorConfiguration(sqlMapGeneratorConfiguration);

        config.addContext(context);

        System.out.println(config.toDocument().getFormattedContent());

        DefaultShellCallback callback = new DefaultShellCallback(overwrite);
        MyBatisGenerator myBatisGenerator = null;
        try {
            myBatisGenerator = new MyBatisGenerator(config, callback, warnings);
            myBatisGenerator.generate(null);
        } catch (InvalidConfigurationException | InterruptedException | SQLException | IOException e) {
            e.printStackTrace();
        }
    }

    private static TableConfiguration getTableConfiguration(Context context, String tableName, String pkName) {
        TableConfiguration tc = new TableConfiguration(context);
        tc.setTableName(tableName);

        tc.setGeneratedKey(new GeneratedKey(pkName, "select udf_createguid() from rdb$database", true, "post"));

        ColumnOverride columnOverride;
        columnOverride = new ColumnOverride(pkName);
        columnOverride.setJavaType("java.util.UUID");
        tc.addColumnOverride(columnOverride);

        tc.addIgnoredColumn(new IgnoredColumn("dc_" + tableName));
        tc.addIgnoredColumn(new IgnoredColumn("dm_"+tableName));
        tc.addIgnoredColumn(new IgnoredColumn("ds_"+tableName));

        return tc;
    }
}
