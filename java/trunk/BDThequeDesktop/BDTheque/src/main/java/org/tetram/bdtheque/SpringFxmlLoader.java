package org.tetram.bdtheque;

import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.stage.Stage;
import javafx.util.Callback;
import org.jetbrains.annotations.NonNls;
import org.tetram.bdtheque.gui.controllers.WindowController;
import org.tetram.bdtheque.utils.I18nSupport;

import java.io.IOException;
import java.io.InputStream;

/**
 * Created by Thierry on 21/06/2014.
 */
public class SpringFxmlLoader {
    @NonNls
    private static final String ORG_TETRAM_BDTHEQUE_GUI = "/org/tetram/bdtheque/gui/";

    public static <T extends WindowController> T load(@NonNls String url) throws RuntimeException {
        return load(url, null);
    }

    @SuppressWarnings({"unchecked", "ThrowFromFinallyBlock", "Convert2MethodRef"})
    public static <T extends WindowController> T load(@NonNls String url, Stage stage) throws RuntimeException {
        InputStream fxmlStream = null;
        try {
            fxmlStream = SpringFxmlLoader.class.getResourceAsStream(ORG_TETRAM_BDTHEQUE_GUI + url);
            FXMLLoader loader = new FXMLLoader();
            // idéalement, il faudrait donner le classloader de la classe du futur controller
            //loader.setClassLoader();
            loader.setControllerFactory(aClass -> SpringContext.CONTEXT.getBean(aClass));
            loader.setResources(I18nSupport.getCurrentBundle());

            Parent view = loader.load(fxmlStream);
            view.getStylesheets().addAll(SpringFxmlLoader.class.getResource(ORG_TETRAM_BDTHEQUE_GUI + "theme.css").toExternalForm());
            WindowController controller = loader.getController();
            controller.setView(view);
            controller.setDialog(stage);
            controller.controllerLoaded();

            return (T) controller;
        } catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        } finally {
            if (fxmlStream != null) {
                try {
                    fxmlStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                    throw new RuntimeException(e);
                }
            }
        }
    }
}
