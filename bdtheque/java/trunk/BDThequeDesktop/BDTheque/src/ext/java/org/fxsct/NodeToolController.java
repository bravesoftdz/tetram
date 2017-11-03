/*
 * To change this template, choose Tools | Templates and open the template in
 * the editor.
 */
package org.fxsct;

import javafx.application.Platform;
import javafx.beans.InvalidationListener;
import javafx.beans.Observable;
import javafx.beans.binding.Bindings;
import javafx.beans.binding.BooleanBinding;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.Tab;
import javafx.scene.control.TitledPane;
import javafx.scene.control.ToggleButton;
import javafx.scene.layout.StackPane;
import javafx.stage.Window;
import org.fxsct.locator.LocatorStage;
import org.fxsct.locator.NodeVisualizer;

import java.net.URL;
import java.util.ResourceBundle;

/**
 * @author ABSW
 */
public class NodeToolController extends Controller implements Initializable {

    private final ObservableList<Window> stages = FXCollections.observableArrayList();
    private final NodeBrowser nodeBrowser = new NodeBrowser();
    private final ObjectProperty<Window> subjectWindow = new SimpleObjectProperty<Window>();
    private final BooleanBinding hasSubjectFocus = Bindings.selectBoolean(subjectWindow, "scene", "window", "focused");
    private final FocusTracker focusTracker = new FocusTracker() {{
        subjectSceneProperty().bind(Bindings.<Scene>select(subjectWindow, "scene"));
    }};
    private final ObjectProperty<Window> toolWindow = new SimpleObjectProperty<Window>();
    private final BooleanBinding hasToolFocus = Bindings.selectBoolean(toolWindow, "scene", "window", "focused");
    private final BooleanBinding isToolsVisible = Bindings.selectBoolean(toolWindow, "showing");
    private final LocatorStage locatorStage = new LocatorStage();
    private NodeVisualizer locator = new NodeVisualizer(locatorStage);
    private final NodeTracker tracker = new NodeTracker(locatorStage) {{
        subjectStageProperty().bind(subjectWindow);
    }};
    private final InvalidationListener focusListener = new InvalidationListener() {
        private int depth = 0;

        @Override
        public void invalidated(Observable arg0) {
            depth++;
            Platform.runLater(new Runnable() {

                @Override
                public void run() {
                    depth--;
                    if (depth > 0)
                        return;
                    boolean hasAnyFocus = hasToolFocus.get() || hasSubjectFocus.get();
                    if (nodeBrowser.selectedNodeProperty().get() != null &&
                            hasAnyFocus &&
                            isToolsVisible.get())
                        locator.subjectNodeProperty().set(nodeBrowser.selectedNodeProperty().get());
                    else
                        locator.subjectNodeProperty().set(null);
                }
            });
        }
    };
    private NodePropertyTable propTable = new NodePropertyTable();
    private PseudoClassPane pseudoClassPane = new PseudoClassPane();
    private BoundsPane boundsPane = new BoundsPane();
    private ConstraintsPane constraintsPane = new ConstraintsPane();
    private StyleClassesPane styleClassesPane = new StyleClassesPane();
    private IdPane idPane = new IdPane();
    @FXML
    private StackPane root;

    @FXML
    private Tab sceneGraphTab;

    @FXML
    private Tab stylesTab;

    @FXML
    private Tab idTab;

    @FXML
    private TitledPane propertiesPane;

    @FXML
    private TitledPane boundsContent;

    @FXML
    private StackPane pseudoClassContent;

    @FXML
    private TitledPane constraintsContent;

    @FXML
    private ToggleButton mouseTrackButton;

    @FXML
    private ToggleButton focusTrackButton;

    @Override
    public void initialize(URL url, ResourceBundle rb) {
        sceneGraphTab.setContent(nodeBrowser.getViewNode());
        stylesTab.setContent(styleClassesPane.getContent());
        styleClassesPane.subjectSceneProperty().bind(Bindings.<Scene>select(nodeBrowser.selectedNodeProperty(), "scene"));
        idTab.setContent(idPane.getContent());
        idPane.subjectSceneProperty().bind(Bindings.<Scene>select(nodeBrowser.selectedNodeProperty(), "scene"));
        propertiesPane.setContent(propTable.getRootNode());
        pseudoClassContent.getChildren().setAll(pseudoClassPane.getContentNode());
        boundsContent.setContent(boundsPane.getContentNode());
        constraintsContent.setContent(constraintsPane.getContentNode());
        constraintsPane.subjectNodeProperty().bind(nodeBrowser.selectedNodeProperty());
        stages.addListener(new InvalidationListener() {

            public void invalidated(Observable o) {
                if (stages.isEmpty()) {
                    nodeBrowser.setRootNode(null);
                } else {
                    nodeBrowser.setRootNode(stages.get(0).getScene().getRoot());
                    subjectWindow.set(stages.get(0));
                }
            }
        });
        boundsPane.subjectNode.bind(nodeBrowser.selectedNodeProperty());
        nodeBrowser.selectedNodeProperty().addListener(new InvalidationListener() {

            public void invalidated(Observable o) {
                Node selectedNode = nodeBrowser.getSelectedNode();
                propTable.setNode(selectedNode);
                pseudoClassPane.setNode(selectedNode);
            }
        });

        toolWindow.bind(Bindings.<Window>select(root.sceneProperty(), "window"));
        locatorStage.parentWindowProperty().bind(toolWindow);
        locator = new NodeVisualizer(locatorStage);
        hasSubjectFocus.addListener(focusListener);
        hasToolFocus.addListener(focusListener);
        nodeBrowser.selectedNodeProperty().addListener(focusListener);
        isToolsVisible.addListener(focusListener);
        tracker.nodeProperty().addListener(new InvalidationListener() {

            @Override
            public void invalidated(Observable paramObservable) {
                if (tracker.nodeProperty().get() != null)
                    nodeBrowser.scrollTo(tracker.nodeProperty().get());
            }
        });

        focusTracker.focusedNodeProperty().addListener(new InvalidationListener() {

            @Override
            public void invalidated(Observable paramObservable) {
//				System.out.println("NodeToolController.focusTracker Focus changed ---->>>");
                if (focusTracker.focusedNodeProperty().get() != null)
                    nodeBrowser.scrollTo(focusTracker.focusedNodeProperty().get());
            }
        });

        idPane.selectedNodeProperty().addListener(new InvalidationListener() {

            @Override
            public void invalidated(Observable arg0) {
                if (idPane.selectedNodeProperty().get() != null)
                    locator.subjectNodeProperty().set(idPane.selectedNodeProperty().get());
            }
        });

        tracker.trackMouseProperty().bindBidirectional(mouseTrackButton.selectedProperty());
        focusTracker.trackFocusProperty().bind(focusTrackButton.selectedProperty());

    }

    ObservableList<Window> getStages() {
        return stages;
    }

}
