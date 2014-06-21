package org.tetram.bdtheque;

import javafx.fxml.FXMLLoader;
import javafx.stage.Stage;
import org.jetbrains.annotations.NonNls;
import org.springframework.beans.factory.config.AutowireCapableBeanFactory;
import org.springframework.context.ApplicationContext;
import org.tetram.bdtheque.gui.WindowController;

import java.io.IOException;
import java.io.InputStream;

/**
 * Created by Thierry on 21/06/2014.
 */
class SpringFxmlLoader {
    @NonNls
    private static final String ORG_TETRAM_BDTHEQUE_GUI = "/org/tetram/bdtheque/gui/";
    private ApplicationContext context;

    public SpringFxmlLoader(ApplicationContext context) {
        this.context = context;
    }

    public Object load(@NonNls String url, Stage stage) throws IOException {
        InputStream fxmlStream = null;
        try {
            fxmlStream = getClass().getResourceAsStream(ORG_TETRAM_BDTHEQUE_GUI + url);
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
