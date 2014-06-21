package org.tetram.bdtheque;/**
 * Created by Thierry on 24/05/2014.
 */

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;
import org.springframework.beans.factory.config.AutowireCapableBeanFactory;
import org.springframework.context.ApplicationContext;
import org.tetram.bdtheque.gui.WindowController;

import java.io.IOException;
import java.io.InputStream;

public class Main extends Application {

    public static void main(String[] args) {
        launch(args);
    }

    static public boolean isFBLogged() {
        return Boolean.getBoolean("FBLog4j");
    }

    static public void setFBLogged(boolean value) {
        if (isFBLogged() != value)
            System.setProperty("FBLog4j", String.valueOf(value));
    }

    @Override
    public void start(Stage primaryStage) throws IOException {
        setFBLogged(true);

        SpringFxmlLoader loader = new SpringFxmlLoader(SpringContext.getInstance().getContext());

        Parent root = (Parent) loader.load("main.fxml", primaryStage);
        // Parent root = FXMLLoader.load(getClass().getResource("main.fxml"));
        primaryStage.setTitle("Hello World");
        primaryStage.setScene(new Scene(root, 300, 275));
        primaryStage.show();
    }

    private class SpringFxmlLoader {
        private ApplicationContext context;

        public SpringFxmlLoader(ApplicationContext context) {
            this.context = context;
        }

        public Object load(String url, Stage stage) throws IOException {
            InputStream fxmlStream = null;
            try {
                fxmlStream = getClass().getResourceAsStream(url);
                FXMLLoader loader = new FXMLLoader();

                Object gui = loader.load(fxmlStream);

                Object controller = loader.getController();
                if (controller instanceof WindowController) ((WindowController) controller).setDialog(stage);
                context.getAutowireCapableBeanFactory().autowireBeanProperties(controller, AutowireCapableBeanFactory.AUTOWIRE_NO, false);

                return gui;
            } finally {
                if (fxmlStream != null) {
                    fxmlStream.close();
                }
            }
        }
    }
}
