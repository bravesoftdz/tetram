package org.tetram.bdtheque;/**
 * Created by Thierry on 24/05/2014.
 */

import javafx.application.Application;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.IOException;

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

}
