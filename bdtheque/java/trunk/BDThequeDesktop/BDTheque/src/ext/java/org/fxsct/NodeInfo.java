package org.fxsct;

import javafx.beans.InvalidationListener;
import javafx.beans.Observable;
import javafx.beans.WeakInvalidationListener;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.Node;
import javafx.scene.Parent;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.*;

class NodeInfo {

    // These properties cannot be rendered in a property list. They "steal" the nodes away from
    // the scene.
    private static final HashSet<String> blacklistProperties = new HashSet<String>(Arrays.asList(
            "parent",
            "skin",
            "clip",
            "graphic",
            "content",
            "item"
    ));
    public final StringProperty valueProperty = new SimpleStringProperty();
    private final Node node;
    private final InvalidationListener listener = new InvalidationListener() {

        @Override
        public void invalidated(final Observable observable) {
            final String oldValue = valueProperty.get();
            final String newValue = NodeInfo.this.toString();
            valueProperty.set(newValue);
        }
    };
    private List<String> pseudoClasses = new ArrayList<String>();

    public NodeInfo(NodeInfo nodeInfo) {
        this(nodeInfo.node);
    }

    NodeInfo(Node node) {
        if (node == null) {
            throw new NullPointerException("Cannot extract info from null Node");
        }
        this.node = node;
        this.node.getStyleClass().addListener(new WeakInvalidationListener(listener));
        this.registerPseudoClasses("expanded", "selected", "pressed", "focused", "disabled", "hover");
    }

    static String toString(Node n) {
        return getClassName(n) + " - " + getStyleClass(n) + " " + getPseudoClasses(n) + "  -  #" + n.getId();

    }

    static String getClassName(Node n) {
        String name = n.getClass().getName();
        if (name.contains("."))
            return name.substring(name.lastIndexOf(".") + 1);
        else
            return name;
    }

    static String getStyleClass(Node n) {
        if (n.getStyleClass().isEmpty()) {
            return "";
        } else {
            StringBuilder sb = new StringBuilder();
            Iterator<String> iter = n.getStyleClass().iterator();
            while (iter.hasNext()) {
                String style = iter.next();
                if (style.isEmpty())
                    continue;
                sb.append(".").append(style);
                if (iter.hasNext()) {
                    sb.append(", ");
                }
            }
            return sb.toString();
        }
    }

    static String populatePseudoClasses(Node n, String... classes) {
        StringBuilder sb = new StringBuilder();
        for (final String pseudoClass : classes) {
            try {
                final Method method = n.getClass().getMethod(pseudoClass + "Property");
                try {
                    if (((ObservableValue<Boolean>) method.invoke(n)).getValue())
                        sb.append(":").append(pseudoClass);
                } catch (final ClassCastException e) {
                    // TODO Auto-generated catch block
                    //e.printStackTrace();
                    System.out.println(e + ": " + method);
                } catch (final IllegalArgumentException e) {
                    // TODO Auto-generated catch block
                    //e.printStackTrace();
                    System.out.println(e + ": " + method);
                }
            } catch (NoSuchMethodException e) {
                // TODO Auto-generated catch block
                //System.out.println(e);
                //e.printStackTrace();
            } catch (SecurityException e) {
                // TODO Auto-generated catch block
                //e.printStackTrace();
                System.out.println(e);
            } catch (IllegalAccessException e) {
                // TODO Auto-generated catch block
                //e.printStackTrace();
                System.out.println(e);
            } catch (InvocationTargetException e) {
                // TODO Auto-generated catch block
                //e.printStackTrace();
                System.out.println(e);
            }
        }

        return sb.toString();
    }

    static String getPseudoClasses(Node n) {
        return populatePseudoClasses(n, "expanded"
                , "selected", "pressed", "focused", "disabled", "hover");

    }

    static Map<String, ObservableValue<?>> getProperties(Node n) {
        HashMap<String, ObservableValue<?>> props = new HashMap<String, ObservableValue<?>>();
        for (Method m : n.getClass().getMethods()) {

            if (m.getName().endsWith("Property")) {
                String prop = m.getName().replace("Property", "");

                try {
                    Object o = m.invoke(n);
                    if (o instanceof ObservableValue) {
                        ObservableValue<?> obsVal = (ObservableValue<?>) o;
                        if (!(obsVal.getValue() instanceof Node) && !blacklistProperties.contains(prop)) {
                            props.put(prop, (ObservableValue<?>) o);
                        }
                    }
                } catch (Throwable t) {
//                    Logger.getLogger(NodeInfo.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        return props;
    }

    public static <T extends ObservableValue<?>> T getProperty(Node n, String prop) {
        try {
            return (T) n.getClass().getMethod(prop + "Property").invoke(n);
        } catch (Throwable t) {
            return null;
        }
    }

    public static List<Node> getBreadCrumbElements(Node n) {
        ArrayList<Node> ancestors = new ArrayList<Node>();
        Node currentNode = n;
        while (currentNode != null) {
            ancestors.add(currentNode);
            currentNode = currentNode.getParent();
        }
        Collections.reverse(ancestors);
        return ancestors;
    }

    public static String getBreadCrumbString(Node n) {
        StringBuilder sb = new StringBuilder();
        for (Node element : getBreadCrumbElements(n))
            sb.append(" > ").append(getClassName(element));
        return sb.toString();

    }

    private void registerPseudoClasses(final String... pseudoClasses) {
        for (final String pseudoClass : pseudoClasses) {
            try {
                final Method method = this.node.getClass().getMethod(pseudoClass + "Property");
                try {
                    final ObservableValue<Boolean> booleanProperty = (ObservableValue<Boolean>) method.invoke(this.node);
                    booleanProperty.addListener(new ChangeListener<Boolean>() {

                        @Override
                        public void changed(
                                final ObservableValue<? extends Boolean> observableValue,
                                final Boolean oldValue,
                                final Boolean newValue) {
                            if (newValue) {
                                NodeInfo.this.pseudoClasses.add(pseudoClass);
                            } else {
                                NodeInfo.this.pseudoClasses.remove(pseudoClass);
                            }
                            listener.invalidated(null);
                        }
                    });
                } catch (final ClassCastException e) {
                    // TODO Auto-generated catch block
                    //e.printStackTrace();
                    System.out.println(e + ": " + method);
                } catch (final IllegalArgumentException e) {
                    // TODO Auto-generated catch block
                    //e.printStackTrace();
                    System.out.println(e + ": " + method);
                }
            } catch (NoSuchMethodException e) {
                // TODO Auto-generated catch block
                //System.out.println(e);
                //e.printStackTrace();
            } catch (SecurityException e) {
                // TODO Auto-generated catch block
                //e.printStackTrace();
                System.out.println(e);
            } catch (IllegalAccessException e) {
                // TODO Auto-generated catch block
                //e.printStackTrace();
                System.out.println(e);
            } catch (InvocationTargetException e) {
                // TODO Auto-generated catch block
                //e.printStackTrace();
                System.out.println(e);
            }
        }
    }

    String getId() {
        if (node.getId() == null || node.getId().isEmpty()) {
            return "Unidentified";
        } else {
            return node.getId();
        }
    }

    String getStyleClass() {
        return getStyleClass(node);
    }

    String getClassName() {
        return getClassName(node);
    }

    Node getNode() {
        return node;
    }

    ObservableList<Node> getChildren() {
        if (node instanceof Parent) {
            return ((Parent) node).getChildrenUnmodifiable();
        } else {
            return FXCollections.emptyObservableList();
        }
    }

    public void onValueChanged() {
    }

    public String getPseudoClasses() {
        String acc = "";

        for (final String pseudoClass : pseudoClasses) {
            acc += ":" + pseudoClass;
        }

        return acc;
    }

    @Override
    public String toString() {
        return getClassName() + "  -  ." + getStyleClass() + " " + getPseudoClasses() + "  -  #" + getId();
    }
}
