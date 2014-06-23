package org.tetram.bdtheque;

import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
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

    public static <T extends WindowController> T load(@NonNls String url) throws IOException {
        return load(url, null);
    }

    @SuppressWarnings("unchecked")
    public static <T extends WindowController> T load(@NonNls String url, Stage stage) throws IOException {
        InputStream fxmlStream = null;
        try {
            fxmlStream = SpringFxmlLoader.class.getResourceAsStream(ORG_TETRAM_BDTHEQUE_GUI + url);
            FXMLLoader loader = new FXMLLoader();
            loader.setControllerFactory(new Callback<Class<?>, Object>() {
                @Override
                public Object call(Class<?> aClass) {
                    return SpringContext.CONTEXT.getBean(aClass);
                }
            });
            loader.setResources(I18nSupport.getResources());

            Node view = loader.load(fxmlStream);
            WindowController controller = loader.getController();
            controller.setView(view);
            controller.setDialog(stage);

            return (T) controller;
        } finally {
            if (fxmlStream != null) {
                fxmlStream.close();
            }
        }
    }
}
