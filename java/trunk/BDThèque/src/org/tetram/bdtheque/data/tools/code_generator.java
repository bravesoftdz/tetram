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
        List<String> warnings = new ArrayList<String>();
        boolean overwrite = true;
        Configuration config = new Configuration();

        //   ... fill out the config object as appropriate...
        config.addClasspathEntry("D:\\MEDIA.KIT\\BDTheque\\Java\\lib\\Jaybird-2.2.5-JDK_1.8\\jaybird-full-2.2.5.jar");
        Context context = new Context(ModelType.CONDITIONAL);
        context.setId("bdtheque");
/*
        String decodedPath = null;
        try {
            decodedPath = URLDecoder.decode(ClassLoader.getSystemClassLoader().getResource(".").getPath(), "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        decodedPath=decodedPath.substring(1, decodedPath.length()-1).replaceAll("/", "\\\\");
        System.setProperty("java.library.path",decodedPath+";"+System.getProperty("java.library.path"));

        System.out.println(System.getProperty("java.library.path"));
*/
        JDBCConnectionConfiguration jdbcConnectionConfiguration = new JDBCConnectionConfiguration();
        jdbcConnectionConfiguration.setDriverClass("org.firebirdsql.jdbc.FBDriver");
        jdbcConnectionConfiguration.setConnectionURL("jdbc:firebirdsql:embedded:D:\\MEDIA.KIT\\BDTheque\\bin\\BD.GDB");
        jdbcConnectionConfiguration.setUserId("SYSDBA");
        jdbcConnectionConfiguration.setPassword("masterkey");
        context.setJdbcConnectionConfiguration(jdbcConnectionConfiguration);

        JavaModelGeneratorConfiguration javaModelGeneratorConfiguration = new JavaModelGeneratorConfiguration();
        javaModelGeneratorConfiguration.setTargetPackage("org.tetram.bdtheque.data.bean");
        javaModelGeneratorConfiguration.setTargetProject("D:\\MEDIA.KIT\\BDTheque\\Java\\BDThèque\\src");
        context.setJavaModelGeneratorConfiguration(javaModelGeneratorConfiguration);

        TableConfiguration tc;
        tc = new TableConfiguration(context);
        tc.setTableName("albums");
        context.addTableConfiguration(tc);

        config.addContext(context);

        config.validate();

        DefaultShellCallback callback = new DefaultShellCallback(overwrite);
        MyBatisGenerator myBatisGenerator = null;
        try {
            myBatisGenerator = new MyBatisGenerator(config, callback, warnings);
            myBatisGenerator.generate(null);
        } catch (InvalidConfigurationException | InterruptedException | SQLException | IOException e) {
            e.printStackTrace();
        }
    }
}
